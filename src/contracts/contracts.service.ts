import { ForbiddenException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { DeepseekGenerationService } from '../llm/deepseek-generation.service';
import { VoyageEmbeddingsService, toPgVectorLiteral } from '../llm/voyage-embeddings.service';
import { Article } from '../database/entities/article.entity';
import { ArticleVersion } from '../database/entities/article-version.entity';
import { Law } from '../database/entities/law.entity';
import { buildFtsQuery, confidenceFromRank } from '../questions/retrieval';
import { Contract, ContractStatus } from '../database/entities/contract.entity';
import { ContractClause, MatchedArticle } from '../database/entities/contract-clause.entity';
import { ExtractionService } from './extraction.service';
import { SegmentationService, SegmentedClause } from './segmentation.service';
import { ContractResponseDto } from './dto/contract-response.dto';

interface ClauseCitation {
  law: string;
  lawNo: number;
  lawYear: number;
  articleNo: number;
  snippet: string;
  officialUrl: string | null;
}

interface ClauseCandidate {
  citation: ClauseCitation;
  confidence: number;
  source: 'fts' | 'semantic';
}

/**
 * Service 2 — المدقق القانونى للعقود (Phase 1 استخراج+تقسيم، Phase 2 الأساسية
 * تقييم أولى per-clause). راجع تعليق migrations/034 وsegmentation.service.ts
 * وextraction.service.ts للسياق الكامل، وتقرير التسليم لما هو مؤجَّل عمداً
 * (Phase 3: تصنيف مخاطر + صياغة بديلة + مراجعة محامٍ، Phase 4: تقرير PDF).
 *
 * إعادة استخدام مدروسة (نفس مبدأ GovernanceService بالحرف): يُعاد استخدام
 * VoyageEmbeddingsService/DeepseekGenerationService/AuditService مباشرة، لكن
 * بناء المرشحين (FTS/دلالى) مُعاد بناؤه **باستقلالية** هنا أيضاً (لا استيراد
 * من QuestionsService الخاص ولا من GovernanceService) — الفارق الجوهرى عن
 * الحوكمة: هنا **بلا** فلتر `law.governance_scope`، لأن بنود العقود قد تخصّ أى
 * مجال قانونى مفهرَس (إيجارات، عمل، تجارى...)، لا نطاقاً محدَّداً سلفاً.
 *
 * ⚠️ فجوة تغطية معروفة وموثَّقة صراحة فى migrations/034: القانون المدنى
 * 131/1943 غير مفهرَس — أى بند لا يجد استشهاداً مصرياً ذا صلة مباشرة (خاصة
 * بنود تحكمها قواعد القانون المدنى العامة) سيُصنَّف بصدق
 * 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة' بدل تخمين استشهاد غير دقيق.
 */
@Injectable()
export class ContractsService {
  private readonly logger = new Logger(ContractsService.name);
  private readonly contractRepository: Repository<Contract>;
  private readonly clauseRepository: Repository<ContractClause>;
  private readonly versionRepository: Repository<ArticleVersion>;

  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly auditService: AuditService,
    private readonly extractionService: ExtractionService,
    private readonly segmentationService: SegmentationService,
    private readonly generationService: DeepseekGenerationService,
    private readonly embeddingsService: VoyageEmbeddingsService,
  ) {
    this.contractRepository = this.dataSource.getRepository(Contract);
    this.clauseRepository = this.dataSource.getRepository(ContractClause);
    this.versionRepository = this.dataSource.getRepository(ArticleVersion);
  }

  async upload(
    file: { buffer: Buffer; mimetype: string; originalname: string },
    context: { userId: string; ipAddress: string | null; userAgent: string | null },
  ): Promise<ContractResponseDto> {
    let contract = this.contractRepository.create({
      uploadedBy: context.userId,
      originalFilename: file.originalname,
      status: 'uploaded' as ContractStatus,
    });
    contract = await this.contractRepository.save(contract);

    await this.audit(context, 'contracts.upload', contract.id, { filename: file.originalname });

    const extraction = await this.extractionService.extract(file.buffer, file.mimetype, file.originalname);

    if (extraction.status !== 'ok') {
      contract.status = 'extraction_failed';
      contract.extractionError = extraction.detail;
      contract = await this.contractRepository.save(contract);
      await this.audit(context, 'contracts.extraction_failed', contract.id, {
        reason: extraction.status,
        detail: extraction.detail,
      });
      return this.toResponseDto(contract, [], []);
    }

    const segmentation = this.segmentationService.segment(extraction.text);

    contract.status = 'processing';
    contract.clauseCount = segmentation.clauses.length;
    contract = await this.contractRepository.save(contract);

    let clauseRows: ContractClause[] = await Promise.all(
      segmentation.clauses.map((clause) => this.persistInitialClause(contract.id, clause)),
    );

    // تقييم كل بند بالتتابع (لا Promise.all متوازٍ) عمداً: عدد البنود قد يصل
    // لعشرات، وDeepSeek/Voyage لهما حدود معدَّل (rate limits) مُوثَّقة فعلياً
    // فى هذا المشروع (راجع تقارير Voyage السابقة) — التوازى الكامل هنا كان
    // سيخاطر بإطلاقها من أول استخدام حقيقى لخدمة جديدة، مقابل فارق زمن استجابة
    // مقبول لمستخدم يرفع عقداً (عملية غير تفاعلية آنية أصلاً).
    for (const row of clauseRows) {
      await this.assessAndPersistClause(row, context);
    }

    clauseRows = await this.clauseRepository.find({
      where: { contractId: contract.id },
      order: { clauseIndex: 'ASC' },
    });

    contract.status = 'processed';
    contract = await this.contractRepository.save(contract);

    await this.audit(context, 'contracts.processed', contract.id, {
      clauseCount: clauseRows.length,
      warnings: segmentation.warnings,
    });

    return this.toResponseDto(contract, clauseRows, segmentation.warnings);
  }

  async findById(
    id: string,
    context: { userId: string; role: string },
  ): Promise<ContractResponseDto> {
    const contract = await this.contractRepository.findOne({ where: { id } });
    if (!contract) {
      throw new NotFoundException('العقد غير موجود');
    }
    if (contract.uploadedBy !== context.userId && context.role !== 'admin') {
      // لا يجوز لمستخدم الاطّلاع على عقد مستخدم آخر — بيانات عمل حسّاسة، ولهذا
      // بالتحديد اخترنا JwtAuthGuard الإلزامى (لا OptionalJwtAuthGuard كالحوكمة).
      throw new ForbiddenException('لا تملك صلاحية الاطّلاع على هذا العقد');
    }
    const clauses = await this.clauseRepository.find({
      where: { contractId: id },
      order: { clauseIndex: 'ASC' },
    });
    return this.toResponseDto(contract, clauses, []);
  }

  private async persistInitialClause(contractId: string, clause: SegmentedClause): Promise<ContractClause> {
    const row = this.clauseRepository.create({
      contractId,
      clauseIndex: clause.index,
      clauseLabel: clause.label,
      clauseTitle: clause.title,
      clauseTypeGuess: null,
      clauseText: clause.text,
      assessmentStatus: null,
      assessmentReasoning: null,
      matchedArticles: null,
      assessmentConfidence: null,
    });
    return this.clauseRepository.save(row);
  }

  private async assessAndPersistClause(
    row: ContractClause,
    context: { userId: string; ipAddress: string | null; userAgent: string | null },
  ): Promise<void> {
    try {
      const [ftsCandidates, semanticCandidates] = await Promise.all([
        this.ftsCandidates(row.clauseText, 8),
        this.semanticCandidates(row.clauseText, 8),
      ]);
      const merged = this.mergeCandidates(ftsCandidates, semanticCandidates);

      if (merged.length === 0) {
        row.assessmentStatus = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
        row.assessmentReasoning =
          'لا توجد مادة قانونية مصرية مفهرَسة ذات صلة مباشرة بموضوع هذا البند حتى الآن.';
        row.matchedArticles = [];
        row.assessmentConfidence = 0;
        await this.clauseRepository.save(row);
        return;
      }

      const rerankResults = await this.embeddingsService.rerank(
        row.clauseText,
        merged.map((c) => c.citation.snippet),
      );

      const ordered: ClauseCandidate[] = rerankResults
        ? [...rerankResults]
            .sort((a, b) => b.relevanceScore - a.relevanceScore)
            .filter((r) => merged[r.index] !== undefined)
            .map((r) => merged[r.index])
        : merged;

      const topCandidates = ordered.slice(0, 3);

      const assessment = await this.generationService.assessClause({
        clauseText: row.clauseText,
        candidates: topCandidates.map((c) => ({
          lawTitle: c.citation.law,
          lawNo: c.citation.lawNo,
          lawYear: c.citation.lawYear,
          articleNo: c.citation.articleNo,
          articleText: c.citation.snippet,
        })),
      });

      if (assessment.status === 'not_configured' || assessment.status === 'error') {
        // fail-closed اتساقاً مع GovernanceService: عدم القدرة التقنية على
        // التقييم لا يعنى الافتراض الضمنى بالسلامة — تُصنَّف "يحتاج مراجعة"
        // صراحة، لا "سليم" ولا سكوت.
        row.assessmentStatus = 'يحتاج مراجعة';
        row.assessmentReasoning =
          assessment.status === 'not_configured'
            ? 'خدمة التقييم الآلى غير مُفعَّلة حالياً على هذه البيئة — يلزم مراجعة قانونية بشرية.'
            : 'تعذَّر إجراء التقييم الآلى تقنياً — يلزم مراجعة قانونية بشرية.';
        row.matchedArticles = [];
        row.assessmentConfidence = 0;
      } else {
        const validIndices = assessment.selectedIndices.filter((i) => topCandidates[i] !== undefined);
        const matched: MatchedArticle[] = validIndices.map((i) => {
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
        // نفس القيد الدفاعى المطبَّق فى GovernanceService: حكم "سليم"/"يحتاج
        // مراجعة" بلا أى استشهاد مُعتمَد فعلياً غير منطقى بنيوياً — يُخفَّض
        // قسراً بدل الثقة بحكم بلا أساس مستشهَد به.
        row.assessmentStatus =
          assessment.assessment !== 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة' && matched.length === 0
            ? 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة'
            : assessment.assessment;
        row.assessmentReasoning = assessment.reasoning;
        row.matchedArticles = matched;
        row.assessmentConfidence = assessment.confidence;
      }

      await this.clauseRepository.save(row);

      await this.audit(context, 'contracts.clause_assessed', row.contractId, {
        clauseIndex: row.clauseIndex,
        candidateCount: topCandidates.length,
        status: row.assessmentStatus,
        confidence: row.assessmentConfidence,
      });
    } catch (err) {
      this.logger.warn(
        `clause assessment failed contractId=${row.contractId} clauseIndex=${row.clauseIndex}: ${(err as Error).message}`,
      );
      row.assessmentStatus = 'يحتاج مراجعة';
      row.assessmentReasoning = 'تعذَّر إجراء التقييم الآلى تقنياً لهذا البند — يلزم مراجعة قانونية بشرية.';
      row.matchedArticles = [];
      row.assessmentConfidence = 0;
      await this.clauseRepository.save(row);
    }
  }

  private async audit(
    context: { userId: string | null; ipAddress: string | null; userAgent: string | null },
    action: string,
    resourceId: string,
    metadata: Record<string, unknown>,
  ): Promise<void> {
    await this.auditService
      .record({
        actorId: context.userId,
        action,
        resourceType: 'contract',
        resourceId,
        ipAddress: context.ipAddress,
        userAgent: context.userAgent,
        metadata,
      })
      .catch((err) => {
        this.logger.warn(`contracts audit log failed (non-fatal): ${(err as Error).message}`);
      });
  }

  private toResponseDto(
    contract: Contract,
    clauses: ContractClause[],
    warnings: string[],
  ): ContractResponseDto {
    return {
      id: contract.id,
      original_filename: contract.originalFilename,
      status: contract.status,
      extraction_error: contract.extractionError,
      clause_count: contract.clauseCount,
      warnings,
      clauses: clauses.map((c) => ({
        id: c.id,
        clause_index: c.clauseIndex,
        clause_label: c.clauseLabel,
        clause_title: c.clauseTitle,
        clause_type_guess: c.clauseTypeGuess,
        clause_text: c.clauseText,
        assessment_status: c.assessmentStatus,
        assessment_reasoning: c.assessmentReasoning,
        matched_articles: c.matchedArticles,
        assessment_confidence: c.assessmentConfidence,
      })),
      created_at: contract.createdAt,
    };
  }

  // ===== استرجاع بلا فلتر نطاق (بخلاف GovernanceService) — راجع تعليق الوحدة أعلاه =====

  private async ftsCandidates(clauseText: string, limit: number): Promise<ClauseCandidate[]> {
    const query = buildFtsQuery(clauseText);
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

  private async semanticCandidates(clauseText: string, limit: number): Promise<ClauseCandidate[]> {
    if (!this.embeddingsService.isConfigured) {
      return [];
    }

    const clauseEmbedding = await this.embeddingsService.embedQuery(clauseText);
    if (!clauseEmbedding) {
      return [];
    }

    const vectorLiteral = toPgVectorLiteral(clauseEmbedding);

    const rows: Array<{
      article_no: number;
      short_title: string | null;
      title: string;
      law_no: number;
      law_year: number;
      body: string;
      official_url: string | null;
      similarity: number;
    }> = await this.dataSource.query(
      `SELECT
         a.article_no,
         l.short_title, l.title, l.law_no, l.law_year, l.official_url,
         av.body,
         1 - (a.embedding <=> $1::vector) AS similarity
       FROM articles a
       JOIN laws l ON l.id = a.law_id
       JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
       WHERE a.embedding IS NOT NULL
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
        officialUrl: row.official_url,
      },
      confidence: Math.min(1, Math.max(0, Number(row.similarity))),
      source: 'semantic' as const,
    }));
  }

  private mergeCandidates(
    ftsCandidates: ClauseCandidate[],
    semanticCandidates: ClauseCandidate[],
  ): ClauseCandidate[] {
    const byKey = new Map<string, ClauseCandidate>();
    for (const candidate of [...ftsCandidates, ...semanticCandidates]) {
      const key = `${candidate.citation.lawNo}-${candidate.citation.lawYear}-${candidate.citation.articleNo}`;
      const existing = byKey.get(key);
      if (!existing || candidate.confidence > existing.confidence) {
        byKey.set(key, candidate);
      }
    }
    return Array.from(byKey.values()).sort((a, b) => b.confidence - a.confidence);
  }

  private citationFromVersion(version: ArticleVersion & { article: Article & { law: Law } }): ClauseCitation {
    return {
      law: version.article.law.shortTitle ?? version.article.law.title,
      lawNo: version.article.law.lawNo,
      lawYear: version.article.law.lawYear,
      articleNo: version.article.articleNo,
      snippet: version.body,
      officialUrl: version.article.law.officialUrl,
    };
  }
}
