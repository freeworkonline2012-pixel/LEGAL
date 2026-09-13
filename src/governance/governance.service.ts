import { Injectable, Logger } from '@nestjs/common';
import { createHash } from 'crypto';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { DeepseekGenerationService, GovernanceVerdict } from '../llm/deepseek-generation.service';
import { VoyageEmbeddingsService, toPgVectorLiteral } from '../llm/voyage-embeddings.service';
import { Article } from '../database/entities/article.entity';
import { ArticleVersion } from '../database/entities/article-version.entity';
import { Law } from '../database/entities/law.entity';
import { buildFtsQuery, confidenceFromRank } from '../questions/retrieval';
import { AssessGovernanceDto } from './dto/assess-governance.dto';
import { GovernanceLegalBasisDto, GovernanceVerdictResponseDto } from './dto/governance-verdict-response.dto';

interface GovernanceCitation {
  law: string;
  lawNo: number;
  lawYear: number;
  articleNo: number;
  // ⚠️ 2026-09-07: إضافة جوهرية لا تجميلية — انظر تعليق mergeCandidates
  // أدناه للتبرير الكامل (دليل مباشر من الإنتاج: بند gov-024).
  articleSuffixOrder: number;
  snippet: string;
  officialUrl: string | null;
}

interface GovernanceCandidate {
  citation: GovernanceCitation;
  confidence: number;
  source: 'fts' | 'semantic';
}

const INSUFFICIENT_INFO: GovernanceVerdict = 'معلومات غير كافية';

/**
 * Service 3 — مساعد الحوكمة والالتزام والمخاطر (2026-09-04، Phase 1-3 من
 * خطة القسم 4.4 فى project doc تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى-
 * 2026-09-02.md). Phase 4 (Golden Test Set مخصَّص 30-50 سؤال) وواجهة العرض
 * المخصَّصة (جزء من Phase 3) مؤجَّلتان عمداً — راجع تقرير التسليم.
 *
 * قرار إعادة استخدام مدروس (لا نسخ أعمى ولا إعادة بناء غير ضرورية): يُعاد
 * استخدام VoyageEmbeddingsService وDeepseekGenerationService وAuditService
 * مباشرة (نفس الحقن فى LlmModule/AuditModule — بلا تعديل عليهم سوى إضافة
 * assessCompliance فى DeepseekGenerationService). أما بناء المرشحين
 * (FTS/دلالى) فمُعاد **باستقلالية** هنا بدل استيراد الدوال الخاصة (private)
 * من QuestionsService — ذلك الملف موثَّق صراحة بتاريخ حوادث إنتاج متعددة
 * (g051, g067, g039...) و"لا تُعدَّل هذه الدالة إلا بتجربة مستقلة موثَّقة"؛
 * لمس بنيته لأجل إعادة استخدام حرفية كان سيحمل مخاطر انحدار حقيقية على خط
 * Service 1 المُتحقَّق منه بالفعل، لأجل توفير كود مكرَّر فقط. النسخة هنا
 * أبسط عمداً (بلا rerank متعدد المصادر معقَّد) وتضيف الفلتر الجوهرى الوحيد
 * المطلوب: `law.governance_scope = true`.
 */
@Injectable()
export class GovernanceService {
  private readonly logger = new Logger(GovernanceService.name);
  private readonly versionRepository: Repository<ArticleVersion>;

  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly auditService: AuditService,
    private readonly generationService: DeepseekGenerationService,
    private readonly embeddingsService: VoyageEmbeddingsService,
  ) {
    this.versionRepository = this.dataSource.getRepository(ArticleVersion);
  }

  private hashQuestion(text: string): string {
    // H-4 (نفس مبدأ questions.service.ts): معرّف ارتباط قصير غير قابل
    // للعكس للسجلات التشخيصية، بدل طباعة وصف الإجراء صراحة.
    return createHash('sha256').update(text).digest('hex').slice(0, 8);
  }

  async assess(
    dto: AssessGovernanceDto,
    context: { userId: string | null; ipAddress: string | null; userAgent: string | null },
  ): Promise<GovernanceVerdictResponseDto> {
    const question = dto.action_description;
    const qHash = this.hashQuestion(question);

    // ⚠️ 2026-09-06: كان الحد هنا 8/8 (16 مرشحاً كحد أقصى قبل الترتيب النهائى).
    // تشخيص مباشر لسجلات الإنتاج (قياس فعلى لـ36 بنداً، انظر تقرير القياس
    // بنفس التاريخ) أثبت أن المادة الصحيحة أحياناً لا تدخل مجمع المرشحين
    // إطلاقاً رغم وجودها ومطابقتها فعلياً (مثال موثَّق: قانون 22/2018 م.6 —
    // "يتظلم" فعلاً مقابل "تظلم/بتظلم" اسماً فى نص السؤال؛ بحث FTS بإعداد
    // 'simple' بلا اشتقاق عربى لا يطابق صيغاً صرفية مختلفة من نفس الجذر، والترتيب
    // الدلالى الخام لم يكفِ وحده لإدخالها ضمن أفضل 8 وسط تنافس مكثف من قرارات
    // أطول مثل 161/2024). الحل الجذرى الصحيح هندسياً (لا حل مؤقت): توسيع مجمع
    // الاسترجاع الخام قبل إعادة الترتيب (Retrieve-then-Rerank) بدل تضييقه مبكراً
    // — Voyage rerank (نموذج مطابقة دلالية دقيق) قادر على ترقية المادة الصحيحة
    // للمقدمة لو دخلت المجمع أصلاً، فالعطل الفعلى فى مرحلة السحب الأولى لا
    // الترتيب النهائى. تعديل معزول هنا فقط (لا لمس لـbuildFtsQuery أو
    // retrieval.ts المشترك الموثَّق كهش — راجع تعليق الوحدة أعلى الملف).
    const [ftsCandidates, semanticCandidates] = await Promise.all([
      this.ftsCandidates(question, 15),
      this.semanticCandidates(question, 15),
    ]);

    const merged = this.mergeCandidates(ftsCandidates, semanticCandidates);

    this.logger.log(
      `governance pool: qHash=${qHash} مرشحون=${merged.length} → ` +
        merged
          .map(
            (c) =>
              `${c.citation.lawNo}/${c.citation.articleNo}` +
              (c.citation.articleSuffixOrder !== 0 ? `.${c.citation.articleSuffixOrder}` : '') +
              `(${c.source},${c.confidence.toFixed(3)})`,
          )
          .join(', '),
    );

    if (merged.length === 0) {
      const result = this.buildResult(
        INSUFFICIENT_INFO,
        [],
        'لا توجد مادة قانونية مفهرَسة ذات صلة ضمن نطاق الحوكمة والالتزام والمخاطر الحالى (مكافحة غسل أموال/تمويل إرهاب، تأمين، تمويل غير مصرفى) — يلزم مراجعة مستشار قانونى مباشرة.',
        0,
      );
      await this.audit(context, qHash, [], { status: 'no_candidates' }, result);
      return result;
    }

    const rerankResults = await this.embeddingsService.rerank(
      question,
      merged.map((c) => c.citation.snippet),
    );

    const ordered: Array<GovernanceCandidate & { rerankScore: number | null }> = rerankResults
      ? [...rerankResults]
          .sort((a, b) => b.relevanceScore - a.relevanceScore)
          .filter((r) => merged[r.index] !== undefined)
          .map((r) => ({ ...merged[r.index], rerankScore: r.relevanceScore }))
      : merged.map((c) => ({ ...c, rerankScore: null }));

    // ⚠️ تسجيل تشخيصى مؤقت (2026-09-13 — يُزال بعد إغلاق التحقيق التالى):
    // قياس حى بعد نجاح backfill-embeddings.js (24/24) كشف تراجعاً صافياً فى
    // دقة الحوكمة (72.76% → 67.48%، راجع تقرير-تراجع-غير-متوقع-فى-دقة-
    // الحوكمة-بعد-إصلاح-فجوة-embeddings-2026-09-13 فى توثيق المشروع)، مركَّز
    // بنسبة 71% فى فئة insurance بعد أن وسَّعت migration 048 نطاقها من 10
    // إلى 23 قانوناً. الفرضية: نافذة أفضل 5 (topCandidates أدناه) لم تعد
    // كافية بعد اكتمال فهرسة المرشحين الجدد. هذا السطر وحده يسجّل الترتيب
    // الكامل بعد rerank (لا الـ5 الأوائل فقط كما فى سجلّ "governance select"
    // الموجود أصلاً أسفله) — لمعرفة هل المادة الصحيحة قريبة من حافة الـ5
    // (فتوسيع النافذة يكفى) أم بعيدة (فيلزم rerank مصنَّف حسب الفئة). لا
    // تأثير على السلوك أو الاستجابة — سجلّ إضافى فقط.
    this.logger.log(
      `[DIAG-RERANK-FULL] qHash=${qHash} ترتيب_كامل(${ordered.length})=` +
        ordered
          .map(
            (c, i) =>
              `#${i + 1}:${c.citation.lawNo}/${c.citation.lawYear}م${c.citation.articleNo}` +
              (c.citation.articleSuffixOrder !== 0 ? `.${c.citation.articleSuffixOrder}` : '') +
              `(${c.rerankScore?.toFixed(4) ?? 'n/a'})`,
          )
          .join(', '),
    );

    // ⚠️ 2026-09-07: كان الحد هنا 3 فقط. دليل مباشر من سجلات الإنتاج (قياس
    // فعلى، انظر تقرير الحادث/التحليل بنفس التاريخ): بند gov-024 (قرار
    // 101/2020 م.1 — معيار كفاية رأس المال، نص "10%") كان **الأعلى دلالياً**
    // فى كامل مجمع 21 مرشحاً قبل rerank (0.528)، ومع ذلك أنزله Voyage rerank
    // للمركز الثالث تماماً (0.5078) خلف مرشحين أضعف دلالياً فى الأصل. أى أن
    // افتراض التعليق أعلاه ("لو دخلت المجمع، rerank سيرقّيها للمقدمة") غير
    // صحيح دائماً — rerank نفسه عرضة لخطأ ترتيب حتى مع مرشح صحيح ومهيمن
    // دلالياً. الحل الهندسى المباشر: توسيع نافذة الاختيار النهائية بعد
    // rerank من 3 إلى 5 (لا توسيع إضافى لمجمع السحب الخام، فهذا مُعالَج
    // بالفعل أعلاه) — يمنح هامش أمان يستوعب أخطاء ترتيب rerank الصغيرة (فرق
    // مركزين هنا) دون تحميل assessCompliance بعدد مفرط من المرشحين، خصوصاً
    // أن قواعد الفحص (1) و(2) فى system prompt الخاص به مصمَّمة أصلاً
    // لاستبعاد أى مرشح خارج النطاق بصرف النظر عن عدد المرشحين المعروضين.
    const topCandidates = ordered.slice(0, 5);

    // ⚠️ 2026-09-13: إصلاح جذرى لعدم-حتمية DeepSeek (لا إعادة قياس متكررة
    // للالتفاف حولها) — راجع تقرير-تراجع-غير-متوقع-فى-دقة-الحوكمة... فى
    // توثيق المشروع للتحقيق الكامل. دليل مباشر من الإنتاج: استدعاء نفس
    // الاستعلام بنفس المرشحين تماماً (temperature=0 صراحةً) أعطى أحكاماً
    // مختلفة بين محاولة وأخرى فى 15 من 21 حالة مُختبَرة. DeepSeek لا يوفر
    // معامل seed (تحقَّق من توثيقها الرسمى مباشرة، api-docs.deepseek.com) —
    // فلا توجد وسيلة API لفرض حتمية تامة. الحل الهندسى الصحيح المعمول به
    // فى الصناعة لهذه الحالة تحديداً هو self-consistency (تصويت أغلبية على
    // عيّنات متعددة مستقلة لنفس المدخل — Wang et al. 2022)، لا قبول عيّنة
    // واحدة كحكم نهائى على قرار امتثال قد يُبنى عليه قرار عمل حقيقى.
    //
    // التكلفة الصريحة: 3 نداءات DeepSeek بدل نداء واحد لكل تقييم حوكمة
    // (لا تُضاعِف زمن الاستجابة فعلياً — Promise.all متوازٍ — لكنها تُضاعِف
    // تكلفة الـAPI ×3 على هذا المسار تحديداً). هذا تبادل واعٍ ومُفصَح عنه:
    // الدقة والاتساق فى منتج امتثال قانونى تبرر التكلفة، ويمكن ضبط العدد
    // عبر GOVERNANCE_CONSENSUS_SAMPLES لو استدعى الأمر لاحقاً.
    const consensusSamples = Math.max(
      1,
      Number(process.env.GOVERNANCE_CONSENSUS_SAMPLES) || 3,
    );

    const requestPayload = {
      question,
      candidates: topCandidates.map((c) => ({
        lawTitle: c.citation.law,
        lawNo: c.citation.lawNo,
        lawYear: c.citation.lawYear,
        articleNo: c.citation.articleNo,
        articleText: c.citation.snippet,
      })),
    };

    const samples = await Promise.all(
      Array.from({ length: consensusSamples }, () =>
        this.generationService.assessCompliance(requestPayload),
      ),
    );

    const { selection, consensusDetail } = this.resolveConsensus(samples);

    this.logger.log(
      `governance select: qHash=${qHash} مرشحون=` +
        topCandidates
          .map(
            (c) =>
              `${c.citation.lawNo}/${c.citation.articleNo}` +
              (c.citation.articleSuffixOrder !== 0 ? `.${c.citation.articleSuffixOrder}` : '') +
              `(rerank=${c.rerankScore?.toFixed(4) ?? 'n/a'})`,
          )
          .join(', ') +
        ` → ${JSON.stringify(selection)}`,
    );

    this.logger.log(
      `governance consensus: qHash=${qHash} عينات(${samples.length})=` +
        samples.map((s) => (s.status === 'ok' ? s.verdict : s.status)).join(' | ') +
        ` → ${consensusDetail}`,
    );

    let result: GovernanceVerdictResponseDto;

    // سياسة fail-closed **بلا استثناء** هنا (بخلاف selectBestCandidate فى
    // /api/questions الذى يقبل fail-open عند 'not_configured') — راجع تعليق
    // assessCompliance فى deepseek-generation.service.ts للتبرير الكامل: حكم
    // حوكمة قد يُبنى عليه قرار عمل حقيقى مباشرة، فـ"غير متأكد" يجب أن يُترجَم
    // دائماً لـ"معلومات غير كافية" صريحة، لا لقبول ضمنى لأفضل مرشح.
    if (selection.status === 'not_configured') {
      result = this.buildResult(
        INSUFFICIENT_INFO,
        [],
        'خدمة التقييم الآلى غير مُفعَّلة حالياً على هذه البيئة — يلزم مراجعة مستشار قانونى مباشرة قبل اتخاذ أى قرار.',
        0,
      );
    } else if (selection.status === 'error') {
      result = this.buildResult(
        INSUFFICIENT_INFO,
        [],
        'تعذَّر إجراء التقييم الآلى تقنياً فى هذه اللحظة — يلزم مراجعة مستشار قانونى مباشرة قبل اتخاذ أى قرار.',
        0,
      );
    } else {
      // 'ok' — لكن نفرض هنا قيداً دفاعياً إضافياً: حكم غير "معلومات غير
      // كافية" بلا أى مرشح مُعتمَد فعلياً (selectedIndices فارغة) غير منطقى
      // بنيوياً (لا أساس قانونى لحكم صريح) — يُخفَّض قسراً لـ"معلومات غير
      // كافية" بدل الثقة بحكم بلا استشهاد، اتساقاً مع مبدأ الاستشهاد
      // الإلزامى فى القسم 1.3 من project doc.
      const validIndices = selection.selectedIndices.filter((i) => topCandidates[i] !== undefined);
      const verdict: GovernanceVerdict =
        selection.verdict !== INSUFFICIENT_INFO && validIndices.length === 0
          ? INSUFFICIENT_INFO
          : selection.verdict;
      const basis: GovernanceLegalBasisDto[] = validIndices.map((i) => {
        const c = topCandidates[i].citation;
        return {
          law: c.law,
          law_no: c.lawNo,
          law_year: c.lawYear,
          article_no: c.articleNo,
          snippet: c.snippet,
          official_url: c.officialUrl,
        };
      });
      result = this.buildResult(verdict, basis, selection.riskNote, selection.confidence);
    }

    await this.audit(
      context,
      qHash,
      topCandidates.map((c) => ({
        articleNo: c.citation.articleNo,
        lawNo: c.citation.lawNo,
        lawYear: c.citation.lawYear,
        source: c.source,
        originalConfidence: c.confidence,
        rerankScore: c.rerankScore,
      })),
      selection,
      result,
    );

    return result;
  }

  /**
   * تصويت أغلبية (self-consistency) على عيّنات assessCompliance المستقلة
   * لنفس السؤال — راجع تعليق استدعائها فى assess() أعلاه للتبرير الكامل
   * (عدم-حتمية DeepSeek رغم temperature=0، ولا معامل seed متاح فى واجهتها).
   * سياسة fail-closed بلا استثناء عند الغموض: لا أغلبية واضحة (>النصف) →
   * "معلومات غير كافية" الآمنة صراحةً، لا تخمين أو اختيار عشوائى بين أحكام
   * متعارضة على قرار قد يُبنى عليه قرار عمل حقيقى.
   */
  private resolveConsensus(
    samples: Array<Awaited<ReturnType<DeepseekGenerationService['assessCompliance']>>>,
  ): {
    selection: Awaited<ReturnType<DeepseekGenerationService['assessCompliance']>>;
    consensusDetail: string;
  } {
    const okSamples = samples.filter(
      (s): s is Extract<typeof s, { status: 'ok' }> => s.status === 'ok',
    );

    if (okSamples.length === 0) {
      // كل العيّنات فشلت (not_configured/error) — تُمرَّر أول عيّنة كما هى؛
      // المسارات الحالية أسفل assess() تتعامل معها بنفس فشل-مغلق القديم
      // (not_configured/error) دون أى تعديل مطلوب هناك.
      return { selection: samples[0], consensusDetail: `0/${samples.length} عيّنات صالحة` };
    }

    const groups = new Map<GovernanceVerdict, typeof okSamples>();
    for (const s of okSamples) {
      const list = groups.get(s.verdict) ?? [];
      list.push(s);
      groups.set(s.verdict, list);
    }

    const ranked = [...groups.entries()].sort((a, b) => b[1].length - a[1].length);
    const [majorityVerdict, majorityGroup] = ranked[0];
    const hasClearMajority = majorityGroup.length > okSamples.length / 2;

    if (hasClearMajority) {
      // من بين العيّنات المتفقة على الحكم الأغلب، تُختار الأعلى ثقة كممثل
      // (بدل الأولى عشوائياً) — استشهادها/تحليلها هو ما يُعرض فعلياً.
      const best = majorityGroup.reduce((a, b) => (b.confidence > a.confidence ? b : a));
      return {
        selection: best,
        consensusDetail: `${majorityGroup.length}/${okSamples.length} اتفقت على "${majorityVerdict}"`,
      };
    }

    // لا أغلبية واضحة (مثال: 3 عيّنات، 3 أحكام مختلفة) — لا تخمين. تُرجَع
    // "معلومات غير كافية" الآمنة صراحةً، ويبقى الانقسام مرئياً بالكامل فى
    // سجلّ "governance consensus" (أعلاه فى assess()) لمراجعة يدوية لاحقة.
    return {
      selection: {
        status: 'ok',
        verdict: INSUFFICIENT_INFO,
        selectedIndices: [],
        riskNote:
          'تباينت أحكام النموذج عبر عيّنات مستقلة متعددة لنفس السؤال دون أغلبية واضحة — يلزم مراجعة مستشار قانونى مباشرة.',
        confidence: 0,
      },
      consensusDetail: `انقسام بلا أغلبية (${[...groups.entries()]
        .map(([v, g]) => `${v}×${g.length}`)
        .join(', ')})`,
    };
  }

  private buildResult(
    verdict: GovernanceVerdict,
    legalBasis: GovernanceLegalBasisDto[],
    riskNote: string,
    confidence: number,
  ): GovernanceVerdictResponseDto {
    return { verdict, legal_basis: legalBasis, risk_note: riskNote, confidence };
  }

  private async audit(
    context: { userId: string | null; ipAddress: string | null; userAgent: string | null },
    qHash: string,
    candidates: unknown,
    selection: unknown,
    result: GovernanceVerdictResponseDto,
  ): Promise<void> {
    await this.auditService
      .record({
        actorId: context.userId,
        action: 'governance.assess',
        resourceType: 'governance_verdict',
        ipAddress: context.ipAddress,
        userAgent: context.userAgent,
        metadata: { qHash, candidates, selection, verdict: result.verdict, confidence: result.confidence },
      })
      .catch((err) => {
        this.logger.warn(`governance audit log failed (non-fatal): ${(err as Error).message}`);
      });
  }

  // ===== استرجاع مُقيَّد بـ governance_scope=true (راجع تعليق الوحدة أعلاه) =====

  private async ftsCandidates(questionText: string, limit: number): Promise<GovernanceCandidate[]> {
    const query = buildFtsQuery(questionText);
    if (!query) {
      return [];
    }

    const qb = this.versionRepository
      .createQueryBuilder('version')
      .innerJoinAndSelect('version.article', 'article')
      .innerJoinAndSelect('article.law', 'law')
      .where(`to_tsvector('simple', arabic_normalize(version.body)) @@ to_tsquery('simple', :query)`, {
        query,
      })
      .andWhere('version.effective_to IS NULL')
      .andWhere('law.governance_scope = true')
      .addSelect(
        `ts_rank(to_tsvector('simple', arabic_normalize(version.body)), to_tsquery('simple', :query))`,
        'rank',
      )
      .orderBy('rank', 'DESC')
      .take(limit);

    const { entities, raw } = await qb.getRawAndEntities();

    return entities.map((version, i) => ({
      citation: this.citationFromVersion(version),
      confidence: confidenceFromRank(Number(raw[i]?.rank ?? 0)),
      source: 'fts' as const,
    }));
  }

  private async semanticCandidates(questionText: string, limit: number): Promise<GovernanceCandidate[]> {
    if (!this.embeddingsService.isConfigured) {
      return [];
    }

    const questionEmbedding = await this.embeddingsService.embedQuery(questionText);
    if (!questionEmbedding) {
      return [];
    }

    const vectorLiteral = toPgVectorLiteral(questionEmbedding);

    const rows: Array<{
      article_no: number;
      article_suffix_order: number;
      short_title: string | null;
      title: string;
      law_no: number;
      law_year: number;
      body: string;
      official_url: string | null;
      similarity: number;
    }> = await this.dataSource.query(
      `SELECT
         a.article_no, a.article_suffix_order,
         l.short_title, l.title, l.law_no, l.law_year, l.official_url,
         av.body,
         1 - (a.embedding <=> $1::vector) AS similarity
       FROM articles a
       JOIN laws l ON l.id = a.law_id
       JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
       WHERE a.embedding IS NOT NULL AND l.governance_scope = true
       ORDER BY a.embedding <=> $1::vector
       LIMIT $2`,
      [vectorLiteral, limit],
    );

    return rows.map((row) => ({
      citation: {
        law: row.short_title ?? row.title,
        lawNo: row.law_no,
        lawYear: row.law_year,
        articleNo: row.article_no,
        articleSuffixOrder: row.article_suffix_order,
        snippet: row.body,
        officialUrl: row.official_url,
      },
      confidence: Math.min(1, Math.max(0, Number(row.similarity))),
      source: 'semantic' as const,
    }));
  }

  private mergeCandidates(
    ftsCandidates: GovernanceCandidate[],
    semanticCandidates: GovernanceCandidate[],
  ): GovernanceCandidate[] {
    // ⚠️ 2026-09-07: كان مفتاح الدمج هنا (lawNo-lawYear-articleNo) بلا
    // articleSuffixOrder. دليل مباشر من الإنتاج (بند gov-024، قرار 101/2020):
    // article_no=1 يتكرر عمداً كصفّين مختلفين تماماً فى قاعدة البيانات —
    // "المادة الأولى" الإصدارية (suffix=-1، نص عام بلا أرقام) و"مادة 1"
    // الموضوعية (suffix=0، تتضمن نص "10%" الحرج لمعيار كفاية رأس المال) —
    // بالضبط النمط الموثَّق فى تعليق Article.articleSuffixOrder نفسه
    // (migrations/021، 022). المفتاح القديم كان يُصادم الصفّين معاً، فيُسقِط
    // الدمج أحدهما عشوائياً بحسب أى الاثنين له confidence أعلى فى تلك
    // اللحظة — وقد لوحظ فعلياً اختيار النسخة الإصدارية الفارغة من الأرقام
    // بدل الموضوعية عدة مرات فى اختبار حى متكرر لنفس السؤال. إضافة
    // articleSuffixOrder للمفتاح تمنع هذا التصادم نهائياً بلا أى أثر جانبى
    // على القوانين التى لا تحتوى مواد مكررة (suffix=0 دائماً هناك، فالمفتاح
    // يبقى فريداً كما كان).
    const byKey = new Map<string, GovernanceCandidate>();
    for (const candidate of [...ftsCandidates, ...semanticCandidates]) {
      const key =
        `${candidate.citation.lawNo}-${candidate.citation.lawYear}-` +
        `${candidate.citation.articleNo}-${candidate.citation.articleSuffixOrder}`;
      const existing = byKey.get(key);
      if (!existing || candidate.confidence > existing.confidence) {
        byKey.set(key, candidate);
      }
    }
    return Array.from(byKey.values()).sort((a, b) => b.confidence - a.confidence);
  }

  private citationFromVersion(version: ArticleVersion & { article: Article & { law: Law } }): GovernanceCitation {
    return {
      law: version.article.law.shortTitle ?? version.article.law.title,
      lawNo: version.article.law.lawNo,
      lawYear: version.article.law.lawYear,
      articleNo: version.article.articleNo,
      articleSuffixOrder: version.article.articleSuffixOrder,
      snippet: version.body,
      officialUrl: version.article.law.officialUrl,
    };
  }
}
