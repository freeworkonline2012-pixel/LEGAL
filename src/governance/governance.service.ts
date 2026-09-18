import { Injectable, Logger } from '@nestjs/common';
import { createHash } from 'crypto';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { DeepseekGenerationService, GovernanceVerdict } from '../llm/deepseek-generation.service';
import { VoyageEmbeddingsService, toPgVectorLiteral } from '../llm/voyage-embeddings.service';
import { WebSearchFallbackService } from '../llm/web-search-fallback.service';
import { Article } from '../database/entities/article.entity';
import { ArticleVersion } from '../database/entities/article-version.entity';
import { Law } from '../database/entities/law.entity';
import { buildFtsQuery, confidenceFromRank } from '../questions/retrieval';
import { AssessGovernanceDto } from './dto/assess-governance.dto';
import {
  GovernanceLegalBasisDto,
  GovernanceRecommendationDto,
  GovernanceVerdictResponseDto,
} from './dto/governance-verdict-response.dto';

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

// ⚠️ 2026-09-17: إصلاح جذرى مؤكَّد تجريبياً (لا قيمة افتراضية عشوائية) —
// راجع تعليق semanticCandidates() أدناه للتفاصيل الكاملة والدليل. القيمة
// هنا نتيجة تحقيق مباشر لتناقض gov-090 (22/2018 م15): articles.embedding
// مُفهرَس بفهرس pgvector HNSW التقريبى (migrations/001_init.sql،
// 002_embeddings_dimension.sql)، وthis.dataSource.query() الأصلى كان
// يعمل بـhnsw.ef_search الافتراضى (40) — أُعيد إنتاج عطل الإنتاج حرفياً عبر
// سكربت تحقُّق (scripts/validate_hnsw_ef_search_hypothesis.js، نفس نمط
// الاستعلام تماماً بما فيه LIMIT): عند الإعداد الافتراضى (40)، مرشح حقيقى
// صحيح (رتبته الفعلية #6 من 1355 مرشحاً ضمن نطاق الحوكمة، مؤكَّدة مرتين
// بنداءى Voyage مستقلين) غائب تماماً عن نتيجة LIMIT=25 — وهو بالضبط ما
// شُوهد فى سجلّ [DIAG-SEMANTIC-RAW] الحى وقتها. رُفع الإعداد تجريبياً إلى
// 100/200/400 — الثلاثة استعادت المرشح بنجاح؛ اختير 200 تحديداً (لا 100 ولا
// 400): هامش أمان كبير (33x فوق الرتبة الحقيقية المؤكَّدة #6) يحمى من حالات
// أخرى غير مكتشَفة بعد بنفس النمط، مع بقاء فهرس HNSW مُستخدَماً فعلياً حسب
// EXPLAIN (لا يدفع مخطِّط الاستعلام لمسح تسلسلى كامل كما لوحظ عند 400 —
// فيُحافَظ على الغرض المعمارى من الفهرس أصلاً بدل تعطيله ضمناً). مُطبَّق عبر
// SET LOCAL داخل معاملة قصيرة العمر تلف هذا الاستعلام فقط (QueryRunner مخصَّص
// أدناه) — لا تعديل دائم على أى إعداد جلسة أو قاعدة بيانات، ولا تأثير على أى
// استعلام آخر فى الخدمة.
const HNSW_EF_SEARCH_GOVERNANCE = 200;

// ⚠️ 2026-09-18 (طبقة النصيحة): تنويه إلزامى مُلحَق برمجياً — لا يعتمد على
// التزام النموذج بذكره — بكل توصية basis_type='web_supplementary'. نص مستقل
// عمداً عن WEB_FALLBACK_DISCLAIMER العام (web-search-fallback.service.ts):
// هذا السياق أكثر حساسية (قرار امتثال قد يُبنى عليه قرار عمل حقيقى، لا سؤال
// عام)، فيصرِّح صراحة أن الحكم الأساسى fail-closed لم يتغيَّر ولا يزال قائماً
// بصرف النظر عن هذه التوصية التكميلية.
const GOVERNANCE_WEB_ADVISORY_DISCLAIMER =
  '⚠️ هذه توصية تكميلية مبنية على بحث ويب عام فى مصادر رسمية، وليست مبنية على ' +
  'قاعدة بياناتنا القانونية المُراجَعة داخلياً — الحكم الرسمى لهذا السؤال يبقى ' +
  '"معلومات غير كافية" (verdict أعلاه) بصرف النظر عن هذه التوصية. لا تُعتمَد ' +
  'هذه التوصية وحدها فى أى قرار تنظيمى أو تعاقدى دون مراجعة مستشار قانونى ' +
  'مباشرة يتحقق من المصادر المذكورة ومن سريانها حالياً.';

/**
 * Service 3 — مساعد الحوكمة والالتزام والمخاطر (2026-09-04، Phase 1-3 من
 * خطة القسم 4.4 فى project doc تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى-
 * 2026-09-02.md). Phase 4 (Golden Test Set مخصَّص 30-50 سؤال) وواجهة العرض
 * المخصَّصة (جزء من Phase 3) مؤجَّلتان عمداً — راجع تقرير التسليم.
 *
 * ⚠️ 2026-09-18 — طبقة النصيحة (مصر فقط؛ راجع تقرير بناء طبقة النصيحة بنفس
 * التاريخ للقرار الكامل): يُضاف حقل `recommendation` فوق العقد الأساسى
 * {verdict, legal_basis, risk_note, confidence} دون أى تعديل على منطق هذا
 * الأخير — موصى به/غير موصى به/موصى به بشرط مُشتقَّة مباشرة من legal_basis
 * المتحقَّق منه لثلاثة الأحكام الحاسمة (متوافق/غير متوافق/متوافق جزئياً)، أو
 * من طبقة بحث ويب تكميلية منفصلة الثقة (basis_type='web_supplementary')
 * تحديداً عند "معلومات غير كافية" فقط — بقرار صريح مؤكَّد مع صاحب المشروع أن
 * هذه الطبقة **لا تتجاوز أبداً** سياسة fail-closed الأساسية (لا تُبدِّل
 * verdict، ولا تُعامَل بنفس ثقة استشهاد قاعدة البيانات). دعم دول أخرى (السعودية/
 * البحرين/قطر) مؤجَّل عمداً لمشروعات منفصلة لاحقة، كل منها مبنى على مستندات
 * رسمية يرفعها صاحب المشروع بنفسه — لا محتوى قانونى مُستخرَج من الويب لأى دولة
 * (بما فى ذلك مصر: هذه الطبقة التكميلية تبقى استشارية فقط، لا مصدراً للمواد
 * القانونية المفهرَسة أو legal_basis الرسمى).
 *
 * ⚠️ 2026-09-18 — طبقة استشهاد العقوبة (مشروع منفصل، بُنى فوق طبقة النصيحة
 * أعلاه): اكتُشفت الحاجة إليها من مراجعة حية لإجابة فعلية (سؤال تستُّر شركة
 * تمويل استهلاكى عن غسل أموال) — الحكم "غير متوافق" كان دقيقاً لكن دون ذكر
 * الجزاء الفعلى المترتب. تحقَّق أن مواد العقوبة **موجودة بالفعل** فى قاعدتنا
 * لمعظم قوانين نطاق الحوكمة (ingestion سابق كامل يشمل فصول العقوبات) — فلا
 * حاجة لأى محتوى قانونى جديد أو تعديل مخطط قاعدة بيانات، فقط استرجاع FTS
 * مقيَّد بنفس قوانين legal_basis + تحقق دلالى إلزامى (راجع
 * DeepseekGenerationService.selectApplicablePenalties لتبرير التحقق —
 * قوانين مثل 80/2002 تحوى عدة مواد عقوبة منفصلة لجرائم مختلفة، فربط "قانون →
 * عقوبته الوحيدة" كان سيُخطئ). تُحاوَل فقط عند verdict="غير متوافق" أو
 * "متوافق جزئياً"؛ fail-closed بلا استثناء (null لا يعنى غياب عقوبة، بل عدم
 * تحديدها آلياً بثقة كافية).
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
    private readonly webFallbackService: WebSearchFallbackService,
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
        [],
        0,
      );
      result.recommendation = await this.attemptWebAdvisory(question, qHash);
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
        [],
        0,
      );
    } else if (selection.status === 'error') {
      result = this.buildResult(
        INSUFFICIENT_INFO,
        [],
        'تعذَّر إجراء التقييم الآلى تقنياً فى هذه اللحظة — يلزم مراجعة مستشار قانونى مباشرة قبل اتخاذ أى قرار.',
        [],
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
      result = this.buildResult(
        verdict,
        basis,
        selection.riskNote,
        verdict === 'متوافق جزئياً' ? selection.conditions : [],
        selection.confidence,
      );
    }

    // ⚠️ 2026-09-18 (طبقة النصيحة): يُحاوَل فقط بعد أن استقر verdict النهائى
    // (بعد تصويت الأغلبية وكل قيود fail-closed أعلاه) على "معلومات غير كافية"
    // تحديداً — فى الحالات الثلاث الأخرى recommendation مبنية بالفعل داخل
    // buildResult من legal_basis/risk_note/conditions مباشرة (basis_type=
    // 'database')، فلا حاجة ولا معنى لاستدعاء بحث ويب. هذا الاستدعاء معزول
    // تماماً (طبقة تكميلية اختيارية بعد نهاية منطق fail-closed الأساسى، لا
    // تعديل عليه) ولا يُغيِّر result.verdict/legal_basis/risk_note/confidence
    // إطلاقاً — فقط قد يملأ result.recommendation إن نجحت.
    if (result.verdict === INSUFFICIENT_INFO) {
      result.recommendation = await this.attemptWebAdvisory(question, qHash);
    } else if (
      (result.verdict === 'غير متوافق' || result.verdict === 'متوافق جزئياً') &&
      result.recommendation
    ) {
      // ⚠️ طبقة استشهاد العقوبة (مشروع منفصل — 2026-09-18، راجع تقريره
      // الخاص) — تُحاوَل فقط هنا (الحكمان اللذان تهم فيهما العقوبة فعلياً
      // لقرار عمل حقيقى). معزولة تماماً بنفس فلسفة attemptWebAdvisory: لا
      // تُغيِّر verdict/legal_basis/risk_note/confidence إطلاقاً، فقط قد
      // تملأ applicable_penalties/penalty_note داخل recommendation الموجودة
      // بالفعل (result.recommendation مضمونة non-null هنا — buildRecommendation
      // تُعيد كائناً حقيقياً دائماً لهذين الحكمين تحديداً).
      const { applicablePenalties, penaltyNote } = await this.attemptPenaltyCitation(
        result.verdict,
        result.legal_basis,
        result.risk_note,
        qHash,
      );
      result.recommendation.applicable_penalties = applicablePenalties;
      result.recommendation.penalty_note = penaltyNote;
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
        conditions: [],
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
    conditions: string[],
    confidence: number,
  ): GovernanceVerdictResponseDto {
    return {
      verdict,
      legal_basis: legalBasis,
      risk_note: riskNote,
      confidence,
      recommendation: this.buildRecommendation(verdict, legalBasis, riskNote, conditions, confidence),
    };
  }

  /**
   * طبقة النصيحة — الجزء البنيوى المشتق مباشرة من verdict الأساسى وlegal_basis
   * وrisk_note وconditions المُنتَجة بالفعل من assessCompliance (لا نداء LLM
   * إضافى هنا، ولا أى منطق غير حتمى — دالة خالصة بلا I/O). راجع تعليق
   * GovernanceRecommendationDto فى الـDTO لتفاصيل كل حقل.
   *
   * لماذا "متوافق جزئياً" → "موصى به بشرط" لا "غير موصى به": الإجراء الجزئى
   * قد يكون معقولاً للمضى فيه فعلياً أثناء استيفاء الشروط الباقية (قرار تجارى
   * يخص صاحب المشروع لا هذه الدالة) — تصنيفه القسرى "غير موصى به" كان سيُخفى
   * هذا الفارق الجوهرى عن التصنيف الثنائى الحاد لـ"غير متوافق" الكامل.
   *
   * "معلومات غير كافية" تُعيد null دائماً من هنا — لا أساس قاعدة بيانات كافٍ
   * أصلاً لبناء أى توصية؛ التوصية الوحيدة الممكنة لهذا الحكم (إن وُجدت) تُبنى
   * لاحقاً حصراً عبر attemptWebAdvisory (basis_type='web_supplementary')، لا
   * من هنا.
   */
  private buildRecommendation(
    verdict: GovernanceVerdict,
    legalBasis: GovernanceLegalBasisDto[],
    riskNote: string,
    conditions: string[],
    confidence: number,
  ): GovernanceRecommendationDto | null {
    if (verdict === 'متوافق') {
      return {
        advice: 'موصى به',
        reasoning: riskNote,
        basis_type: 'database',
        confidence,
        conditions_for_compliance: null,
        violated_provisions: null,
        web_sources: null,
        disclaimer: null,
        applicable_penalties: null,
        penalty_note: null,
      };
    }
    if (verdict === 'غير متوافق') {
      return {
        advice: 'غير موصى به',
        reasoning: riskNote,
        basis_type: 'database',
        confidence,
        conditions_for_compliance: null,
        violated_provisions: legalBasis.length > 0 ? legalBasis : null,
        web_sources: null,
        disclaimer: null,
        // ⚠️ تُملأ لاحقاً (إن أمكن) عبر attemptPenaltyCitation فى assess() —
        // null هنا هو القيمة الافتراضية قبل تلك المحاولة، لا نتيجتها.
        applicable_penalties: null,
        penalty_note: null,
      };
    }
    if (verdict === 'متوافق جزئياً') {
      return {
        advice: 'موصى به بشرط',
        reasoning: riskNote,
        basis_type: 'database',
        confidence,
        conditions_for_compliance: conditions.length > 0 ? conditions : null,
        violated_provisions: null,
        web_sources: null,
        disclaimer: null,
        // ⚠️ نفس ملاحظة "غير متوافق" أعلاه — تُملأ لاحقاً إن أمكن.
        applicable_penalties: null,
        penalty_note: null,
      };
    }
    return null; // معلومات غير كافية — راجع attemptWebAdvisory
  }

  /**
   * طبقة النصيحة التكميلية عبر بحث الويب — تُستدعى **فقط** من الاستدعاءات
   * الصريحة فى assess() بعد استقرار verdict النهائى على "معلومات غير كافية"
   * (راجع تعليقات نقاط الاستدعاء). القرار المعمارى المؤكَّد مع صاحب المشروع
   * 2026-09-18: هذه طبقة توصية تكميلية منفصلة الثقة فقط — **لا تُغيِّر ولا
   * تتجاوز أبداً** سياسة fail-closed الأساسية لـGovernanceService (بخلاف
   * questions.service.ts الذى يسمح لـWebSearchFallbackService بأن يكون
   * الإجابة المعروضة الوحيدة عند فشل الاسترجاع — هنا verdict يبقى "معلومات
   * غير كافية" دائماً بصرف النظر عن نتيجة هذه الدالة).
   *
   * fail-closed بلا استثناء على أى خطأ (غير مُفعَّلة، لا مصادر مسموحة، فشل
   * شبكة/تحليل، أو قرار النموذج نفسه بعدم كفاية مقتطفات الويب) — يُعاد null
   * فى كل هذه الحالات، فيبقى result.recommendation = null (لا توصية) دون أى
   * استثناء يتسرَّب أو يُبطئ الاستجابة الأساسية.
   */
  private async attemptWebAdvisory(
    question: string,
    qHash: string,
  ): Promise<GovernanceRecommendationDto | null> {
    if (!this.webFallbackService.isConfigured) {
      return null;
    }
    try {
      const sources = await this.webFallbackService.searchAllowlisted(question);
      if (!sources) {
        return null;
      }
      const context = sources
        .map((s, i) => `[${i + 1}] ${s.title}\nالرابط: ${s.url}\nمقتطف: ${s.snippet}`)
        .join('\n\n');
      const advisory = await this.generationService.composeGovernanceWebAdvisory(question, context);
      if (!advisory) {
        this.logger.log(
          `governance web-advisory: qHash=${qHash} — لا توصية (معطَّلة/بلا مصادر مسموحة/النموذج قرَّر عدم الكفاية)`,
        );
        return null;
      }
      this.logger.log(
        `governance web-advisory: qHash=${qHash} → ${advisory.advice} (ثقة=${advisory.confidence.toFixed(2)}, مصادر=${sources.length})`,
      );
      return {
        advice: advisory.advice,
        reasoning: advisory.reasoning,
        basis_type: 'web_supplementary',
        confidence: advisory.confidence,
        conditions_for_compliance: null,
        violated_provisions: null,
        web_sources: sources.map((s) => ({ title: s.title, url: s.url, snippet: s.snippet })),
        disclaimer: GOVERNANCE_WEB_ADVISORY_DISCLAIMER,
        // طبقة استشهاد العقوبة تعمل فقط فوق legal_basis من قاعدتنا (verdict
        // "غير متوافق"/"متوافق جزئياً" المبنيَّين على database) — لا معنى لها
        // هنا (basis_type=web_supplementary لا يملك legal_basis أصلاً).
        applicable_penalties: null,
        penalty_note: null,
      };
    } catch (err) {
      this.logger.warn(`governance web-advisory failed safely (fail-closed): ${(err as Error)?.message}`);
      return null;
    }
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
        metadata: {
          qHash,
          candidates,
          selection,
          verdict: result.verdict,
          confidence: result.confidence,
          // ⚠️ 2026-09-18: recommendation.advice/basis_type فقط (لا web_sources
          // الكاملة ولا النص الكامل) — كافٍ لرصد معدَّل استخدام طبقة النصيحة
          // التكميلية (web_supplementary) بمعزل عن الاستخدام العادى، بنفس
          // فلسفة answer.web_fallback_used فى questions.service.ts، دون تضخيم
          // حجم سجل التدقيق بمحتوى مكرَّر موجود بالفعل فى result نفسه.
          recommendationAdvice: result.recommendation?.advice ?? null,
          recommendationBasisType: result.recommendation?.basis_type ?? null,
        },
      })
      .catch((err) => {
        this.logger.warn(`governance audit log failed (non-fatal): ${(err as Error).message}`);
      });
  }

  // ===== طبقة استشهاد العقوبة (مشروع منفصل — 2026-09-18) =====

  /**
   * استرجاع FTS مباشر (بلا rerank — مجموعة النتائج صغيرة أصلاً ومُقيَّدة
   * بقوانين معدودة، والتحقق الدلالى الحقيقى مؤجَّل لـselectApplicablePenalties
   * حيث السياق الكامل للمخالفة متاح) لمواد "شكلها عقوبة" (تحوى كلمات دلالة
   * العقوبة) ضمن **نفس القوانين المستشهَد بها بالفعل فى legal_basis** فقط —
   * لا بحث عام، فلا خطر تسرّب مادة من قانون غير ذى صلة بالمخالفة أصلاً.
   *
   * ⚠️ لا اشتقاق عربى فى to_tsquery('simple', ...) (نفس قيد buildFtsQuery
   * الموثَّق فى retrieval.ts) — لذلك القائمة أدناه تضم صوراً معرَّفة ومنكَّرة
   * صراحة (الحبس/حبس، السجن/سجن، الغرامة/غرامة) بدل الاعتماد على اشتقاق غير
   * متاح فعلياً فى إعداد 'simple'. اتساع الاسترجاع هنا مقصود (لا دقة زائدة
   * مطلوبة فى هذه المرحلة) — الدقة الفعلية تُفرَض لاحقاً بالتحقق الدلالى
   * الإلزامى فى selectApplicablePenalties، لا هنا.
   *
   * ⚠️ إصلاح جذرى 2026-09-18 (اكتُشف من اختبار حى فعلى بعد نشر هذه الطبقة
   * مباشرة — راجع تقرير الإصلاح الثانى بنفس التاريخ): الاستعلام الأصلى كان
   * يحمل `LIMIT 12` **بلا أى ORDER BY** — تحقَّقتُ مباشرة من ملفات الهجرة
   * أن قانونى 80/2002 و161/2024 معاً (المثال الحى نفسه) يحويان بمفردهما 14
   * مادة تُطابق كلمات دلالة العقوبة (9 من 80/2002 + 5 من 161/2024)، أى أكثر
   * من الحد القديم. بلا ORDER BY، ترتيب Postgres للصفوف غير مضمون وقد يُسقِط
   * أياً منها بصمت — وفعلاً، فى هذا الاختبار الحى بالذات، سُقِطت المادة
   * 15/الفقرة صفر (النص الصحيح الذى يغطى المادة 8 تحديداً: "كل من يخالف
   * أيًا من أحكام المواد أرقام (8، 9، 11)") من قائمة المرشحين، فاضطُر النموذج
   * للاستقرار خطأً على 15/الفقرة1 (تخص المادة 9 مكرراً1 فقط، لا صلة لها
   * بالمخالفة). **هذا فشل فى طبقة الاسترجاع قبل أن يصل الأمر أصلاً للتحقق
   * الدلالى المُصمَّم خصيصاً لمنع هذا النوع من الأخطاء** — لا فائدة من تحقق
   * دلالى صارم إن كان المرشح الصحيح غائباً عن القائمة المعروضة عليه أصلاً.
   * الإصلاح: رفع الحد لـ60 (سقف سخى يتسع بمراحل لأى قانون واحد ضمن نطاق
   * الحوكمة المفهرَس حالياً دون أن يُقارب الاستنفاد فعلياً) **مع** ORDER BY
   * حتمى — كلاهما معاً: رفع الحد وحده لا يضمن الحتمية لو تكرر تضخم القوائم
   * مستقبلاً، وORDER BY وحده لا يمنع إسقاط مرشح صحيح لو بقى الحد أقل من
   * العدد الفعلى للمطابقات.
   */
  private async fetchPenaltyCandidates(
    lawRefs: Array<{ lawNo: number; lawYear: number }>,
  ): Promise<GovernanceCitation[]> {
    if (lawRefs.length === 0) {
      return [];
    }
    const uniqueRefs = Array.from(
      new Map(lawRefs.map((r) => [`${r.lawNo}-${r.lawYear}`, r])).values(),
    );
    const conditions = uniqueRefs
      .map((_, i) => `(l.law_no = $${i * 2 + 1} AND l.law_year = $${i * 2 + 2})`)
      .join(' OR ');
    const params = uniqueRefs.flatMap((r) => [r.lawNo, r.lawYear]);

    const rows: Array<{
      article_no: number;
      article_suffix_order: number;
      short_title: string | null;
      title: string;
      law_no: number;
      law_year: number;
      official_url: string | null;
      body: string;
    }> = await this.dataSource.query(
      `SELECT
         a.article_no, a.article_suffix_order,
         l.short_title, l.title, l.law_no, l.law_year, l.official_url,
         av.body
       FROM article_versions av
       JOIN articles a ON a.id = av.article_id
       JOIN laws l ON l.id = a.law_id
       WHERE av.effective_to IS NULL
         AND (${conditions})
         AND to_tsvector('simple', arabic_normalize(av.body)) @@
             to_tsquery('simple', 'يعاقب | عقوبة | عقوبات | غرامة | الغرامة | حبس | الحبس | سجن | السجن | جزاء | جزاءات | مصادرة')
       ORDER BY l.law_no, l.law_year, a.article_no, a.article_suffix_order
       LIMIT 60`,
      params,
    );

    return rows.map((row) => ({
      law: row.short_title ?? row.title,
      lawNo: row.law_no,
      lawYear: row.law_year,
      articleNo: row.article_no,
      articleSuffixOrder: row.article_suffix_order,
      snippet: row.body,
      officialUrl: row.official_url,
    }));
  }

  /**
   * طبقة استشهاد العقوبة — تُستدعى **فقط** من نقطة الاستدعاء الصريحة الوحيدة
   * فى assess() (بعد استقرار verdict على "غير متوافق"/"متوافق جزئياً"
   * تحديداً). راجع تعليق DeepseekGenerationService.selectApplicablePenalties
   * للتصميم الكامل وتبرير التحقق الدلالى الإلزامى (قوانين متعددة العقوبات).
   *
   * fail-closed بلا استثناء (بنفس فلسفة attemptWebAdvisory تماماً): أى خطأ
   * أو عدم يقين يُعيد {null, null} بهدوء — لا يمس result.verdict/legal_basis/
   * risk_note/confidence بأى حال، ولا يُسقِط استجابة /api/governance/assess
   * الأساسية.
   */
  private async attemptPenaltyCitation(
    verdict: GovernanceVerdict,
    legalBasis: GovernanceLegalBasisDto[],
    riskNote: string,
    qHash: string,
  ): Promise<{ applicablePenalties: GovernanceLegalBasisDto[] | null; penaltyNote: string | null }> {
    const NONE = { applicablePenalties: null, penaltyNote: null };
    if (legalBasis.length === 0) {
      return NONE;
    }
    try {
      const penaltyCandidates = await this.fetchPenaltyCandidates(
        legalBasis.map((b) => ({ lawNo: b.law_no, lawYear: b.law_year })),
      );
      if (penaltyCandidates.length === 0) {
        this.logger.log(`governance penalty-citation: qHash=${qHash} — لا مرشحو عقوبة مسترجَعون`);
        return NONE;
      }

      const selection = await this.generationService.selectApplicablePenalties({
        violation: riskNote,
        violatedProvisions: legalBasis.map((b) => ({
          lawTitle: b.law,
          lawNo: b.law_no,
          lawYear: b.law_year,
          articleNo: b.article_no,
          articleText: b.snippet,
        })),
        penaltyCandidates: penaltyCandidates.map((c) => ({
          lawTitle: c.law,
          lawNo: c.lawNo,
          lawYear: c.lawYear,
          articleNo: c.articleNo,
          articleText: c.snippet,
        })),
      });

      if (selection.status !== 'ok' || selection.selectedIndices.length === 0) {
        this.logger.log(
          `governance penalty-citation: qHash=${qHash} — لا عقوبة مطابقة محددة (status=${selection.status})`,
        );
        return NONE;
      }

      const applicablePenalties: GovernanceLegalBasisDto[] = selection.selectedIndices
        .filter((i) => penaltyCandidates[i] !== undefined)
        .map((i) => {
          const c = penaltyCandidates[i];
          return {
            law: c.law,
            law_no: c.lawNo,
            law_year: c.lawYear,
            article_no: c.articleNo,
            snippet: c.snippet,
            official_url: c.officialUrl,
          };
        });

      if (applicablePenalties.length === 0) {
        return NONE;
      }

      this.logger.log(
        `governance penalty-citation: qHash=${qHash} → ${applicablePenalties.length} مادة عقوبة مطابقة`,
      );
      return { applicablePenalties, penaltyNote: selection.note || null };
    } catch (err) {
      this.logger.warn(`governance penalty-citation failed safely (fail-closed): ${(err as Error)?.message}`);
      return NONE;
    }
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

    // ⚠️ 2026-09-13: نجلب أكثر من limit المستخدَم فعلياً (+10 هامش تشخيصى
    // ثابت) لتسجيل الترتيب الحقيقى المحسوب مباشرة **داخل نفس مسار الإنتاج**
    // — لا سكربت خارجى منفصل يعيد بناء نفس الاستعلام يدوياً (وقد ثبت فعلاً
    // فى هذا التحقيق أن نسخة معاد بناؤها يدوياً أعطت رتبة (#6) لمادة
    // 22/2018 م15 لم تظهر إطلاقاً فى سجلّ الإنتاج الحقيقى لنفس اللحظة —
    // تناقض غير محسوم يحتاج دليلاً من الكود الفعلى نفسه لا من محاكاة
    // خارجية قد تحمل انحرافاً دقيقاً غير مكتشَف). لا تغيير فى limit
    // المُستخدَم فعلياً لبناء المرشحين (سطر slice أدناه) — تسجيل إضافى فقط.
    const debugFetchLimit = limit + 10;

    // ⚠️ 2026-09-17: SET LOCAL hnsw.ef_search يجب أن يُنفَّذ على نفس اتصال
    // Postgres وداخل نفس المعاملة التى تُنفَّذ فيها استعلام SELECT التالى —
    // this.dataSource.query() العادى (المُستخدَم فى بقية الملف) لا يضمن ذلك
    // إطلاقاً: كل نداء منفصل له قد يسحب اتصالاً مختلفاً من تجمع الاتصالات
    // (connection pool)، فلو نُفِّذ SET LOCAL فى اتصال ثم SELECT فى اتصال آخر
    // لن يكون لأى منهما أثر (تجربة فعلية موثَّقة أعلاه). QueryRunner مخصَّص هنا
    // يضمن اتصالاً واحداً ثابتاً + معاملة صريحة (BEGIN...COMMIT) تُنهى تلقائياً
    // فور اكتمال هذا الاستعلام — تماماً كما اختُبِر ونجح فى
    // scripts/validate_hnsw_ef_search_hypothesis.js.
    const queryRunner = this.dataSource.createQueryRunner();
    let rows: Array<{
      article_no: number;
      article_suffix_order: number;
      short_title: string | null;
      title: string;
      law_no: number;
      law_year: number;
      body: string;
      official_url: string | null;
      similarity: number;
    }>;
    await queryRunner.connect();
    try {
      await queryRunner.startTransaction();
      await queryRunner.query(`SET LOCAL hnsw.ef_search = ${HNSW_EF_SEARCH_GOVERNANCE}`);
      rows = await queryRunner.query(
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
        [vectorLiteral, debugFetchLimit],
      );
      await queryRunner.commitTransaction();
    } catch (err) {
      await queryRunner.rollbackTransaction().catch(() => undefined);
      throw err;
    } finally {
      await queryRunner.release();
    }

    this.logger.log(
      `[DIAG-SEMANTIC-RAW] qHash=${this.hashQuestion(questionText)} أفضل(${rows.length})=` +
        rows
          .map(
            (r, i) =>
              `#${i + 1}:${r.law_no}/${r.law_year}م${r.article_no}` +
              (r.article_suffix_order !== 0 ? `.${r.article_suffix_order}` : '') +
              `(${Number(r.similarity).toFixed(4)})`,
          )
          .join(', '),
    );

    return rows.slice(0, limit).map((row) => ({
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
