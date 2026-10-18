import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { DeepseekGenerationService } from '../llm/deepseek-generation.service';
import { VoyageEmbeddingsService, toPgVectorLiteral } from '../llm/voyage-embeddings.service';
import { Article } from '../database/entities/article.entity';
import { ArticleVersion } from '../database/entities/article-version.entity';
import { Law } from '../database/entities/law.entity';
import { buildFtsQuery, confidenceFromRank } from '../questions/retrieval';
import {
  anchorArticleNumbers,
  CIVIL_CODE,
  classifyClauseCriteria,
  leaseAnchorArticleNumbers,
  scopedLawsForCriteria,
  serializeCriteria,
} from './criteria.util';
import { Contract, ContractStatus } from '../database/entities/contract.entity';
import { ContractClause, MatchedArticle } from '../database/entities/contract-clause.entity';
import { ExtractionService } from './extraction.service';
import {
  dropUnapprovedArticleSentences,
  guardMandatoryClaims,
  softenSupplementaryWording,
  stripInternalCandidateRefs,
  tidyNoTextReasoning,
} from './reasoning.util';
import { ClientPosition, describePosition } from './position.util';
import { REDRAFT_DISCLAIMER, RedraftProposal, validateRedraft } from './redraft.util';
import { SegmentationService, SegmentedClause } from './segmentation.service';
import { ContractClauseResponseDto } from './dto/contract-clause-response.dto';
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
  source: 'fts' | 'semantic' | 'anchor';
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
    position: ClientPosition = { contractType: null, clientRole: null },
  ): Promise<ContractResponseDto> {
    let contract = this.contractRepository.create({
      uploadedBy: context.userId,
      originalFilename: file.originalname,
      status: 'uploaded' as ContractStatus,
      contractType: position.contractType,
      clientRole: position.clientRole,
    });
    contract = await this.contractRepository.save(contract);

    await this.audit(context, 'contracts.upload', contract.id, {
      filename: file.originalname,
      hasClientPosition: Boolean(position.clientRole),
    });

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
      await this.assessAndPersistClause(row, context, position);
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

  /**
   * صياغة بديلة مقترحة لبند "يحتاج مراجعة" له استشهاد معتمَد فقط. عند الطلب (لا عند
   * الرفع) كى لا تُضاعَف تكلفة ومدة معالجة العقد. الاقتراح يمر ببوابة حتمية
   * (validateRedraft) وإلا يُرفض بلا عرض، ويُخزَّن بعد اجتيازها فيُعاد كما هو عند
   * الطلب التالى.
   */
  async proposeRedraft(
    contractId: string,
    clauseId: string,
    context: { userId: string; role: string; ipAddress: string | null; userAgent: string | null },
  ): Promise<ContractClauseResponseDto> {
    const contract = await this.contractRepository.findOne({ where: { id: contractId } });
    if (!contract) {
      throw new NotFoundException('العقد غير موجود');
    }
    if (contract.uploadedBy !== context.userId && context.role !== 'admin') {
      throw new ForbiddenException('لا تملك صلاحية الاطّلاع على هذا العقد');
    }
    const clause = await this.clauseRepository.findOne({ where: { id: clauseId, contractId } });
    if (!clause) {
      throw new NotFoundException('البند غير موجود');
    }
    const matched = clause.matchedArticles ?? [];
    if (clause.assessmentStatus !== 'يحتاج مراجعة' || matched.length === 0) {
      throw new BadRequestException(
        'لا تتوفر صياغة بديلة إلا للبنود التى تحتاج مراجعة ولها سند قانونى معتمَد.',
      );
    }

    if (!clause.suggestedWording) {
      const outcome = await this.generationService.proposeClauseRedraft({
        clauseText: clause.clauseText,
        clientPosition: describePosition({ contractType: contract.contractType, clientRole: contract.clientRole }),
        reviewNote: clause.assessmentReasoning ?? '',
        articles: matched.map((m) => ({
          lawTitle: m.law,
          lawNo: m.law_no,
          lawYear: m.law_year,
          articleNo: m.article_no,
          articleText: m.snippet,
        })),
      });
      if (outcome.status === 'not_configured') {
        throw new UnprocessableEntityException('خدمة الصياغة الآلية غير مُفعَّلة على هذه البيئة.');
      }
      if (outcome.status === 'error') {
        throw new UnprocessableEntityException('تعذَّر توليد صياغة بديلة تقنياً الآن؛ أعد المحاولة لاحقاً.');
      }
      if (!outcome.canResolve) {
        throw new UnprocessableEntityException(
          'لا يمكن اقتراح صياغة آمنة لهذا البند دون معلومات تجارية إضافية؛ يلزم نظر محامٍ مختص.',
        );
      }
      if (outcome.needsChange === false) {
        const note = dropUnapprovedArticleSentences(
          outcome.noChangeReason.replace(/(?:ال)?مرشح\S*/g, ''),
          matched.map((m) => m.article_no),
          'لا يتطلب البند تعديلاً لإزالة خطر قانونى محدد؛ ويُترك تقدير الملاءمة التجارية لصاحب العقد أو محاميه.',
        ).trim();
        clause.suggestedWording = JSON.stringify({ text: '', changes: [], noChange: true, note });
        await this.clauseRepository.save(clause);
        await this.audit(context, 'contracts.redraft_no_change', contractId, { clauseIndex: clause.clauseIndex });
        return this.toClauseDto(clause);
      }
      const verdict = validateRedraft({
        proposedText: outcome.proposedText,
        changes: outcome.changes,
        originalText: clause.clauseText,
        articleTexts: matched.map((m) => m.snippet),
        approvedArticleNos: matched.map((m) => m.article_no),
      });
      if (!verdict.ok) {
        this.logger.warn(`redraft rejected clauseId=${clauseId} reason=${verdict.reason}`);
        await this.audit(context, 'contracts.redraft_rejected', contractId, {
          clauseIndex: clause.clauseIndex,
          reason: verdict.reason,
        });
        throw new UnprocessableEntityException(
          'لم تجتز الصياغة المقترحة فحوص الأمان الآلية (أرقام أو إحالات غير موثَّقة)، فلم تُعرَض؛ يلزم نظر محامٍ مختص.',
        );
      }
      clause.suggestedWording = JSON.stringify(verdict.proposal);
      await this.clauseRepository.save(clause);
      await this.audit(context, 'contracts.redraft_generated', contractId, { clauseIndex: clause.clauseIndex });
    }

    return this.toClauseDto(clause);
  }

  private parseRedraft(
    raw: string | null,
  ): { text: string; changes: string[]; disclaimer: string; no_change: boolean; note: string | null } | null {
    if (!raw) return null;
    try {
      const p = JSON.parse(raw) as Partial<RedraftProposal> & { noChange?: boolean; note?: string };
      if (p.noChange === true) {
        return {
          text: '',
          changes: [],
          disclaimer: REDRAFT_DISCLAIMER,
          no_change: true,
          note: typeof p.note === 'string' && p.note ? p.note : null,
        };
      }
      if (typeof p.text !== 'string' || !p.text) return null;
      return {
        text: p.text,
        changes: Array.isArray(p.changes) ? p.changes.filter((c): c is string => typeof c === 'string') : [],
        disclaimer: REDRAFT_DISCLAIMER,
        no_change: false,
        note: null,
      };
    } catch {
      return null;
    }
  }

  private toClauseDto(c: ContractClause): ContractClauseResponseDto {
    return {
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
      suggested_redraft: this.parseRedraft(c.suggestedWording),
    };
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
    position: ClientPosition,
  ): Promise<void> {
    try {
      const [ftsCandidates, semanticCandidates] = await Promise.all([
        this.ftsCandidates(row.clauseText, 8),
        this.semanticCandidates(row.clauseText, 8),
      ]);
      const merged = this.mergeCandidates(ftsCandidates, semanticCandidates);

      // تصنيف البند إلى معايير المراجعة العشرة (حتمى، بكلمات مفتاحية) + جلب المواد
      // المرجعية للمعيار (مثل 224 للتعويض الاتفاقى و217 للإعفاء من المسؤولية) التى
      // لا يلتقطها البحث العام لأن صياغة البند التعاقدى لا تشبه صياغة النص القانونى.
      const criteria = classifyClauseCriteria(row.clauseTitle, row.clauseText);
      row.clauseTypeGuess = serializeCriteria(criteria);
      const anchors = await this.anchorCandidates(criteria, row.clauseText, row.clauseTitle);

      if (merged.length === 0 && anchors.length === 0) {
        row.assessmentStatus = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
        row.assessmentReasoning =
          'لا توجد مادة قانونية مصرية مفهرَسة ذات صلة مباشرة بموضوع هذا البند حتى الآن.';
        row.matchedArticles = [];
        row.assessmentConfidence = 0;
        await this.clauseRepository.save(row);
        return;
      }

      const rerankResults =
        merged.length > 0
          ? await this.embeddingsService.rerank(
              row.clauseText,
              merged.map((c) => c.citation.snippet),
            )
          : null;

      const ordered: ClauseCandidate[] = rerankResults
        ? [...rerankResults]
            .sort((a, b) => b.relevanceScore - a.relevanceScore)
            .filter((r) => merged[r.index] !== undefined)
            .map((r) => merged[r.index])
        : merged;

      const topGeneral = ordered.slice(0, 3);
      const seen = new Set(topGeneral.map((c) => this.candidateKey(c)));
      // المواد المرجعية تُضاف بعد أفضل 3 نتائج عامة (لا تحلّ محلها)، بلا تكرار
      const topCandidates = [...topGeneral, ...anchors.filter((a) => !seen.has(this.candidateKey(a)))];

      const assessment = await this.generationService.assessClause({
        clauseText: row.clauseText,
        clientPosition: describePosition(position),
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
        const NO_TEXT_STATUS = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
        const downgradedForNoCitation = assessment.assessment !== NO_TEXT_STATUS && matched.length === 0;
        row.assessmentStatus = downgradedForNoCitation ? NO_TEXT_STATUS : assessment.assessment;
        // حكم بلا استشهاد معتمَد لا يُعرَض شرحه (قد يصف مخالفة بلا أساس مستشهَد به):
        // نستبدله بجملة صريحة بدل تناقض بين الحالة والشرح.
        if (downgradedForNoCitation || row.assessmentStatus === NO_TEXT_STATUS) {
          // بند بلا نص مفهرَس: وصف موضوع البند فقط، بلا تعليل عن نصوص استُبعدت
          row.assessmentReasoning = downgradedForNoCitation
            ? 'لا يوجد نص قانونى مصرى مفهرَس يحكم هذا البند مباشرة.'
            : tidyNoTextReasoning(dropUnapprovedArticleSentences(assessment.reasoning, [], ''));
        } else {
          const cleaned = dropUnapprovedArticleSentences(
            stripInternalCandidateRefs(assessment.reasoning, 'يلزم نظر محامٍ مختص فى هذا البند.'),
            matched.map((m) => m.article_no),
            'يلزم نظر محامٍ مختص فى هذا البند.',
          );
          // الحاجز البنيوى: لا ادعاء "آمرة/مخالفة صريحة" بلا عبارة حرفية موثَّقة من نص المادة
          const guarded = guardMandatoryClaims({
            reasoning: cleaned,
            violationType: assessment.violationType,
            mandatoryQuote: assessment.mandatoryQuote,
            matched: validIndices.map((i) => ({
              law: topCandidates[i].citation.law,
              articleNo: topCandidates[i].citation.articleNo,
              text: topCandidates[i].citation.snippet,
            })),
          });
          row.assessmentReasoning = softenSupplementaryWording(guarded.reasoning, guarded.mandatoryVerified);
        }
        row.matchedArticles = matched;
        row.assessmentConfidence = assessment.confidence;
      }

      await this.clauseRepository.save(row);

      await this.audit(context, 'contracts.clause_assessed', row.contractId, {
        clauseIndex: row.clauseIndex,
        candidateCount: topCandidates.length,
        anchorCount: topCandidates.length - topGeneral.length,
        criteria: row.clauseTypeGuess,
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
      contract_type: contract.contractType,
      client_role: contract.clientRole,
      warnings,
      clauses: clauses.map((c) => this.toClauseDto(c)),
      created_at: contract.createdAt,
    };
  }

  // ===== استرجاع بلا فلتر نطاق (بخلاف GovernanceService) — راجع تعليق الوحدة أعلاه =====

  private async ftsCandidates(
    clauseText: string,
    limit: number,
    lawFilter?: { lawNo: number; lawYear: number },
  ): Promise<ClauseCandidate[]> {
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

    if (lawFilter) {
      qb.andWhere('law.law_no = :scopeLawNo AND law.law_year = :scopeLawYear', {
        scopeLawNo: lawFilter.lawNo,
        scopeLawYear: lawFilter.lawYear,
      });
    }

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

  private candidateKey(c: ClauseCandidate): string {
    return `${c.citation.lawNo}-${c.citation.lawYear}-${c.citation.articleNo}`;
  }

  /**
   * مرشحو "المواد المرجعية" لمعايير البند: مواد القانون المدنى المحددة سلفاً + أفضل
   * نتيجتين من القانون المقيَّد (مثل 151/2020 لحماية البيانات). كلها من النص المفهرَس
   * فعلياً (النسخة السارية)، وأى مادة غير موجودة تُتخطّى بلا اختلاق.
   */
  private async anchorCandidates(
    criteria: ReturnType<typeof classifyClauseCriteria>,
    clauseText: string,
    clauseTitle: string | null,
  ): Promise<ClauseCandidate[]> {
    const out: ClauseCandidate[] = [];
    const articleNos = Array.from(
      new Set([...anchorArticleNumbers(criteria, 3), ...leaseAnchorArticleNumbers(clauseTitle, clauseText, 3)]),
    );
    if (articleNos.length > 0) {
      const rows: Array<{
        article_no: number;
        short_title: string | null;
        title: string;
        law_no: number;
        law_year: number;
        body: string;
        official_url: string | null;
      }> = await this.dataSource.query(
        `SELECT a.article_no, l.short_title, l.title, l.law_no, l.law_year, l.official_url, av.body
         FROM articles a
         JOIN laws l ON l.id = a.law_id
         JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
         WHERE l.law_no = $1 AND l.law_year = $2 AND a.article_suffix_order = 0
           AND a.article_no = ANY($3::int[])`,
        [CIVIL_CODE.lawNo, CIVIL_CODE.lawYear, articleNos],
      );
      const order = new Map(articleNos.map((n, i) => [n, i]));
      rows
        .sort((x, y) => (order.get(x.article_no) ?? 99) - (order.get(y.article_no) ?? 99))
        .forEach((row) =>
          out.push({
            citation: {
              law: row.short_title ?? row.title,
              lawNo: row.law_no,
              lawYear: row.law_year,
              articleNo: row.article_no,
              snippet: row.body,
              officialUrl: row.official_url,
            },
            confidence: 0.5,
            source: 'anchor',
          }),
        );
    }
    for (const scope of scopedLawsForCriteria(criteria)) {
      const scoped = await this.ftsCandidates(clauseText, 2, scope);
      out.push(...scoped.map((c) => ({ ...c, source: 'anchor' as const })));
    }
    return out;
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
