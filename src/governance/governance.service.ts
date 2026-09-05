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
  snippet: string;
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

    const [ftsCandidates, semanticCandidates] = await Promise.all([
      this.ftsCandidates(question, 8),
      this.semanticCandidates(question, 8),
    ]);

    const merged = this.mergeCandidates(ftsCandidates, semanticCandidates);

    this.logger.log(
      `governance pool: qHash=${qHash} مرشحون=${merged.length} → ` +
        merged
          .map((c) => `${c.citation.lawNo}/${c.citation.articleNo}(${c.source},${c.confidence.toFixed(3)})`)
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

    const topCandidates = ordered.slice(0, 3);

    const selection = await this.generationService.assessCompliance({
      question,
      candidates: topCandidates.map((c) => ({
        lawTitle: c.citation.law,
        lawNo: c.citation.lawNo,
        lawYear: c.citation.lawYear,
        articleNo: c.citation.articleNo,
        articleText: c.citation.snippet,
      })),
    });

    this.logger.log(
      `governance select: qHash=${qHash} مرشحون=` +
        topCandidates
          .map((c) => `${c.citation.lawNo}/${c.citation.articleNo}(rerank=${c.rerankScore?.toFixed(4) ?? 'n/a'})`)
          .join(', ') +
        ` → ${JSON.stringify(selection)}`,
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
        return { law: c.law, law_no: c.lawNo, law_year: c.lawYear, article_no: c.articleNo, snippet: c.snippet };
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
      short_title: string | null;
      title: string;
      law_no: number;
      law_year: number;
      body: string;
      similarity: number;
    }> = await this.dataSource.query(
      `SELECT
         a.article_no,
         l.short_title, l.title, l.law_no, l.law_year,
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
        snippet: row.body,
      },
      confidence: Math.min(1, Math.max(0, Number(row.similarity))),
      source: 'semantic' as const,
    }));
  }

  private mergeCandidates(
    ftsCandidates: GovernanceCandidate[],
    semanticCandidates: GovernanceCandidate[],
  ): GovernanceCandidate[] {
    const byKey = new Map<string, GovernanceCandidate>();
    for (const candidate of [...ftsCandidates, ...semanticCandidates]) {
      const key = `${candidate.citation.lawNo}-${candidate.citation.lawYear}-${candidate.citation.articleNo}`;
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
      snippet: version.body,
    };
  }
}
