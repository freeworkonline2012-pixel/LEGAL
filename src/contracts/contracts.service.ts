import {
  BadRequestException,
  ForbiddenException,
  HttpException,
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
import { DocumentReaderService, looksLikeVisualOrderArabic } from '../documents/document-reader.service';
import { ExtractionService } from './extraction.service';
import {
  dropUnapprovedArticleSentences,
  guardMandatoryClaims,
  hasMandatoryMarker,
  isQuoteInArticles,
  softenSupplementaryWording,
  stripInternalCandidateRefs,
  tidyNoTextReasoning,
} from './reasoning.util';
import { ClientPosition, describePosition } from './position.util';
import { riskLevelFor } from './risk-level.util';
import { neutralizeOcrNoise } from './ocr-noise.util';
import { describeRedraftRejection, describeWeakeningFeedback, REDRAFT_DISCLAIMER, RedraftProposal, validateRedraft } from './redraft.util';
import { SegmentationService, SegmentedClause } from './segmentation.service';
import { ContractClauseResponseDto } from './dto/contract-clause-response.dto';
import { ContractResponseDto } from './dto/contract-response.dto';
import { canonicalHeading, countHeadingLines, looseHeadingLineNumber, missingHeadingNumbers, ordinalWords } from './clause-headings';
import { numericWarnings } from './numeric-checks.util';
import { ClauseFactsService } from './clause-facts.service';
import { hasAnyFact } from './clause-facts';
import { evaluateRules, summarizeFindings } from './clause-rules';
import { ContractConsistencyService } from './contract-consistency.service';
import { ClauseVerifierService } from './clause-verifier.service';
import { type Verification, needsVerification, pickForVerification } from './verification';
import { compareFactsForClient, describeWeakenings } from './redraft-guard';
import type { ClauseFacts } from './clause-facts';
import type { Weakening } from './redraft-guard';
import {
  type ContractFinding,
  type ContractLevelResult,
  type LevelClause,
  FINDING_KIND_LABEL,
  deterministicFindings,
  mergeFindings,
  sortFindings,
} from './contract-level';

// معايير الموضوعات التى لها قواعد حتمية (clause-rules.ts)
const RULE_TOPIC_CRITERIA: readonly string[] = ['exit', 'liability', 'force_majeure', 'compensation'];

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
    private readonly documentReader: DocumentReaderService,
    private readonly factsService: ClauseFactsService,
    private readonly consistencyService: ContractConsistencyService,
    private readonly verifierService: ClauseVerifierService,
  ) {
    this.contractRepository = this.dataSource.getRepository(Contract);
    this.clauseRepository = this.dataSource.getRepository(ContractClause);
    this.versionRepository = this.dataSource.getRepository(ArticleVersion);
  }

  async upload(
    file: { buffer: Buffer; mimetype: string; originalname: string },
    context: { userId: string; ipAddress: string | null; userAgent: string | null },
    position: ClientPosition = { contractType: null, clientRole: null, clientParty: null },
  ): Promise<ContractResponseDto> {
    let contract = this.contractRepository.create({
      uploadedBy: context.userId,
      originalFilename: file.originalname,
      status: 'uploaded' as ContractStatus,
      contractType: position.contractType,
      clientRole: position.clientRole,
      clientParty: position.clientParty ?? null,
    });
    contract = await this.contractRepository.save(contract);

    await this.audit(context, 'contracts.upload', contract.id, {
      filename: file.originalname,
      hasClientPosition: Boolean(position.clientRole),
      hasClientParty: Boolean(position.clientParty),
    });

    let extraction = await this.extractionService.extract(file.buffer, file.mimetype, file.originalname);
    const uploadWarnings: string[] = [];

    // PDF ممسوح ضوئياً (صور بلا نص) أو بترميز تالف/معكوس: القراءة الآلية (OCR) لصور الصفحات هى الحل الجذرى
    // بدل رفض العقد. النص المقروء آلياً قد يخطئ فى الأرقام والمبالغ والتواريخ والأسماء والخط اليدوى، فيُنبَّه
    // المستخدم صراحةً بذلك، وتُرفَض العقود الممسوحة الأطول من حد صفحات القراءة بدل تقييم جزء منها بصمت.
    const isPdf = file.mimetype === 'application/pdf' || file.originalname.toLowerCase().endsWith('.pdf');
    const needsOcr =
      isPdf &&
      (extraction.status === 'empty' ||
        extraction.status === 'corrupted_encoding' ||
        (extraction.status === 'ok' && looksLikeVisualOrderArabic(extraction.text)));
    if (needsOcr) {
      try {
        const read = await this.documentReader.read(file.buffer, {
          messages: {
            unsupportedType: 'نوع الملف غير مدعوم — المدعوم: PDF أو DOCX.',
            ocrUnavailable:
              'الملف صور ممسوحة ضوئياً ولا نص رقمى فيه، والقراءة الآلية للصور غير متاحة حالياً على الخادم — ارفع نسخة Word أو PDF نصى من العقد.',
            ocrFailed:
              'تعذّرت القراءة الآلية للصور الممسوحة — جرّب نسخة أوضح أو ارفع نسخة Word أو PDF نصى من العقد.',
            unreadable: 'تعذّرت قراءة الملف — ارفع نسخة Word أو PDF نصى من العقد.',
            tooLittleText:
              'لم نتمكن من قراءة نص كافٍ من هذا الملف الممسوح — تأكد من وضوح الصور أو ارفع نسخة Word أو PDF نصى من العقد.',
          },
          failOnOcrTruncation: true,
          ocrPageScore: countHeadingLines,
          ocrRecoverMissing: {
            missingNumbers: missingHeadingNumbers,
            headingNumber: looseHeadingLineNumber,
            canonical: canonicalHeading,
            diagnosticWords: ordinalWords,
          },
          minChars: 200,
        });
        extraction = { status: 'ok', text: read.text };
        uploadWarnings.push(
          'قُرئ هذا العقد آلياً من صور ممسوحة ضوئياً (OCR). قد تحتوى القراءة أخطاء، خصوصاً فى الأرقام والمبالغ والتواريخ والأسماء والخط اليدوى والأختام، وقد يفوت التقسيم بعض البنود. قارن كل بند بالأصل قبل أى اعتماد، ويُفضَّل رفع نسخة Word أو PDF نصى إن وُجدت.',
        );
        await this.audit(context, 'contracts.ocr_used', contract.id, { usedOcr: true });
      } catch (err) {
        const detail = err instanceof HttpException ? this.httpExceptionMessage(err) : 'تعذّرت القراءة الآلية للملف.';
        extraction = { status: 'error', detail };
      }
    }

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
    const contractWarnings = [...uploadWarnings, ...segmentation.warnings, ...numericWarnings(extraction.text)];
    contract.extractionWarnings = contractWarnings.length > 0 ? contractWarnings : null;
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

    // الطبقة 4: تحقق مستقل بتعليمات معاكسة من ملاحظات البنود التى قيّمها النموذج (لا يُسقط المعالجة أبداً)
    await this.verifyClauseFlags(clauseRows, position);

    // تحليل العقد ككل بعد تقييم البنود: لا يُسقط المعالجة أبداً (أى عطل ⇒ تُحفظ النتائج الحتمية وحالة النموذج الصريحة)
    contract.contractFindings = (await this.analyzeContractLevel(clauseRows, contract.contractType, contractWarnings)) as unknown as Record<
      string,
      unknown
    >;

    await this.verifyContractFindings(contract.contractFindings as unknown as ContractLevelResult | null, clauseRows);

    contract.status = 'processed';
    contract = await this.contractRepository.save(contract);

    await this.audit(context, 'contracts.processed', contract.id, {
      clauseCount: clauseRows.length,
      warnings: contractWarnings,
      contractFindings: (contract.contractFindings as unknown as ContractLevelResult | null)?.findings?.length ?? 0,
    });

    return this.toResponseDto(contract, clauseRows, contractWarnings);
  }

  /**
   * الجولة 3: فحوص حتمية (بنود غير مرصودة بحسب نوع العقد، إحالات غير معرَّفة، شروط مفتوحة) ثم تمرير نموذج واحد للعقد كاملاً بحثاً عن
   * التعارض وعدم الاتساق، لا يُقبل منه إلا ما أُسند باقتباسات حرفية موجودة فى البنود المذكورة. لا يرمى استثناء.
   */
  async analyzeContractLevel(
    clauseRows: ContractClause[],
    contractType: string | null,
    extractionWarnings: string[],
  ): Promise<ContractLevelResult> {
    const clauses: LevelClause[] = clauseRows.map((c) => ({
      clauseIndex: c.clauseIndex,
      clauseLabel: c.clauseLabel,
      clauseTitle: c.clauseTitle,
      clauseText: c.clauseText,
    }));
    const textMayBeIncomplete = extractionWarnings.some((w) => /OCR|ترقيم|بند/.test(w));
    let rules: ContractFinding[] = [];
    try {
      rules = deterministicFindings(clauses, { contractType, textMayBeIncomplete });
    } catch (err) {
      this.logger.warn(`contract-level rules failed (non-fatal): ${(err as Error).message}`);
    }
    let model: ContractLevelResult['model'] = 'error';
    let modelFindings: ContractFinding[] = [];
    try {
      const outcome = await this.consistencyService.analyze(clauses);
      if (outcome.status === 'ok') {
        model = 'ok';
        modelFindings = outcome.findings;
      } else {
        model = outcome.status;
      }
    } catch (err) {
      this.logger.warn(`contract consistency failed (non-fatal): ${(err as Error).message}`);
    }
    return { version: 1, findings: mergeFindings(rules, modelFindings), model, generatedAt: new Date().toISOString() };
  }

  /**
   * الطبقة 4 على البنود: لكل بند قيّمه النموذج «يحتاج مراجعة» بمخاطرة حرجة/عالية/متوسطة (حتى 12 بنداً، الأخطر أولاً) يعيد مدقق مستقل
   * بتعليمات معاكسة فحص الملاحظة. لا تُغيَّر حالة البند أبداً: النتيجة وسم «مؤكدة/غير مؤكدة» مع سبب واقتباس موثَّق.
   * أى عطل فى بند ⇒ يُترك بلا وسم (null) ويستمر ما بعده.
   */
  private async verifyClauseFlags(rows: ContractClause[], position: ClientPosition): Promise<void> {
    if (!this.verifierService?.isConfigured) return;
    const picks = pickForVerification(rows.filter((r) => needsVerification(r)));
    const clientPosition = describePosition(position);
    for (const row of picks) {
      try {
        const out = await this.verifierService.verifyAssessment({
          clauseText: row.clauseText,
          claim: row.assessmentReasoning ?? '',
          clientPosition,
          articles: (row.matchedArticles ?? []).map((m) => ({ lawTitle: m.law, articleNo: m.article_no, articleText: m.snippet })),
        });
        if (out.status !== 'ok') continue;
        row.verification = out.verification as unknown as Record<string, unknown>;
        await this.clauseRepository.save(row);
      } catch (err) {
        this.logger.warn(`clause verification failed clauseIndex=${row.clauseIndex} (non-fatal): ${(err as Error).message}`);
      }
    }
  }

  /** الطبقة 4 على ملاحظات العقد ككل التى اقترحها النموذج (التعارض وعدم الاتساق...)؛ الحتمية منها لا تحتاج. تعدّل الوثيقة فى مكانها. */
  private async verifyContractFindings(level: ContractLevelResult | null, rows: ContractClause[]): Promise<void> {
    if (!level || !this.verifierService?.isConfigured) return;
    const byIndex = new Map(rows.map((r) => [r.clauseIndex, r]));
    for (const f of level.findings.filter((x) => x.source === 'model').slice(0, 8)) {
      try {
        const out = await this.verifierService.verifyFinding({
          kindLabel: FINDING_KIND_LABEL[f.kind] ?? f.kind,
          title: f.title,
          explanation: f.explanation,
          evidence: f.evidence.map((e) => ({ clauseLabel: e.clauseLabel, quote: e.quote })),
          clauseTexts: f.evidence.map((e) => byIndex.get(e.clauseIndex)?.clauseText ?? ''),
        });
        if (out.status === 'ok') f.verification = out.verification;
      } catch (err) {
        this.logger.warn(`finding verification failed id=${f.id} (non-fatal): ${(err as Error).message}`);
      }
    }
  }

  /**
   * حارس حتمى لحماية مركز العميل فى الصياغة: يستخرج وقائع الصياغة المقترحة بالطريقة نفسها ويقارنها بوقائع البند الأصلى (راجع redraft-guard.ts).
   * يُرجع [] عند أى عجز (غير مفعَّل، تعذّر الاستخراج) فيبقى المدقق اللغوى الموازى هو خط الدفاع.
   */
  private async guardRedraftFacts(clause: ContractClause, proposedText: string, party: 'first' | 'second'): Promise<Weakening[]> {
    if (!this.factsService?.isConfigured) return [];
    try {
      let original = clause.facts as unknown as ClauseFacts | null;
      if (!original || !hasAnyFact(original)) {
        const o = await this.factsService.extract({ clauseText: clause.clauseText });
        if (o.status !== 'ok') return [];
        original = o.facts;
      }
      const p = await this.factsService.extract({ clauseText: proposedText });
      if (p.status !== 'ok') return [];
      return compareFactsForClient(original, p.facts, party);
    } catch (err) {
      this.logger.warn(`redraft facts guard failed (non-fatal): ${(err as Error).message}`);
      return [];
    }
  }

  private httpExceptionMessage(err: HttpException): string {
    const res = err.getResponse();
    if (typeof res === 'string') return res;
    const msg = (res as { message?: string | string[] }).message;
    return Array.isArray(msg) ? msg.join(' ') : (msg ?? err.message);
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
      // صفة بلا تحديد الطرف: النموذج يخمّن أى الطرفين هو العميل فيحمى الطرف الخطأ (وقع فعلاً فى عقد برمجيات) — fail-closed.
      if (contract.clientRole && !contract.clientParty) {
        throw new BadRequestException(
          'لم يُحدَّد هل أنت «الطرف الأول» أم «الطرف الثانى» فى نص العقد، ولا يمكن اقتراح صياغة تحمى مركزك بلا ذلك؛ أعد رفع العقد وحدّد طرفك.',
        );
      }
      const request = {
        clauseText: clause.clauseText,
        clientPosition: describePosition({
          contractType: contract.contractType,
          clientRole: contract.clientRole,
          clientParty: contract.clientParty,
        }),
        reviewNote: clause.assessmentReasoning ?? '',
        articles: matched.map((m) => ({
          lawTitle: m.law,
          lawNo: m.law_no,
          lawYear: m.law_year,
          articleNo: m.article_no,
          articleText: m.snippet,
        })),
      };
      const gate = (o: { proposedText: string; changes: string[] }) =>
        validateRedraft({
          proposedText: o.proposedText,
          changes: o.changes,
          originalText: clause.clauseText,
          articleTexts: matched.map((m) => m.snippet),
          approvedArticleNos: matched.map((m) => m.article_no),
        });

      let outcome = await this.generationService.proposeClauseRedraft(request);
      let verdict: ReturnType<typeof validateRedraft> | null = null;
      let weakensClient = false;
      // محاولة ثانية واحدة فقط عند رفض فحوص الأمان أو فحص حماية مركز العميل، بإبلاغ النموذج بالسبب؛
      // والناتج الجديد يمر بالفحوص نفسها بلا تخفيف.
      for (let attempt = 0; attempt < 2; attempt++) {
        if (outcome.status !== 'ok' || !outcome.canResolve || outcome.needsChange === false) break;
        verdict = gate(outcome);
        weakensClient = false;
        let feedback: string | null = null;
        if (!verdict.ok) {
          this.logger.warn(`redraft rejected clauseId=${clauseId} attempt=${attempt + 1} reason=${verdict.reason}`);
          await this.audit(context, 'contracts.redraft_rejected', contractId, {
            clauseIndex: clause.clauseIndex,
            reason: verdict.reason,
            attempt: attempt + 1,
          });
          feedback = describeRedraftRejection(verdict.reason);
        } else if (request.clientPosition) {
          const guard = contract.clientParty ? await this.guardRedraftFacts(clause, verdict.proposal.text, contract.clientParty) : [];
          const check: Awaited<ReturnType<DeepseekGenerationService['verifyRedraftProtectsClient']>> =
            guard.length > 0
              ? { status: 'ok', weakens: true, reason: describeWeakenings(guard) }
              : await this.generationService.verifyRedraftProtectsClient({
                  clauseText: clause.clauseText,
                  proposedText: verdict.proposal.text,
                  clientPosition: request.clientPosition,
                  reviewNote: request.reviewNote,
                });
          if (check.status === 'ok' && check.weakens) {
            weakensClient = true;
            this.logger.warn(`redraft weakens client clauseId=${clauseId} attempt=${attempt + 1}`);
            await this.audit(context, 'contracts.redraft_weakens_client', contractId, {
              clauseIndex: clause.clauseIndex,
              attempt: attempt + 1,
            });
            feedback = describeWeakeningFeedback(check.reason);
          } else if (check.status === 'error') {
            // المدقق استشارى: فشله لا يمنع صياغة اجتازت فحوص الأمان الحتمية، لكنه يُسجَّل
            this.logger.warn(`redraft client check unavailable clauseId=${clauseId} detail=${check.detail}`);
          }
        }
        if (feedback === null || attempt === 1) break;
        outcome = await this.generationService.proposeClauseRedraft({ ...request, retryFeedback: feedback });
      }
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
      if (weakensClient) {
        throw new UnprocessableEntityException(
          'لم تجتز الصياغة المقترحة فحص حماية مركزك فى العقد (تُضعف حقاً لك أو تمنح الطرف الآخر حقاً جديداً)، فلم تُعرَض؛ يلزم نظر محامٍ مختص.',
        );
      }
      if (!verdict || !verdict.ok) {
        throw new UnprocessableEntityException(
          'لم تجتز الصياغة المقترحة فحوص الأمان الآلية (أرقام أو إحالات غير موثَّقة)، فلم تُعرَض؛ يلزم نظر محامٍ مختص.',
        );
      }
      // عقد مقروء آلياً: رموز القراءة المشوَّهة (ختم/شخبطة) لا تنتقل إلى صياغة مقترحة؛ تُستبدل بفراغ ظاهر وتُذكر فى التعليق.
      let proposal = verdict.proposal;
      if ((contract.extractionWarnings ?? []).some((w) => typeof w === 'string' && w.includes('OCR'))) {
        const cleaned = neutralizeOcrNoise(proposal.text, clause.clauseText);
        if (cleaned.replaced.length > 0) {
          proposal = {
            text: cleaned.text,
            changes: [
              ...proposal.changes,
              `استُبدل رمز مشوَّه ناتج عن القراءة الآلية (${cleaned.replaced.map((t) => `«${t}»`).join('، ')}) بفراغ؛ تحقق من النسخة الموقَّعة.`,
            ],
          };
        }
      }
      clause.suggestedWording = JSON.stringify(proposal);
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
      rule_findings: (c.ruleFindings as unknown as ContractClauseResponseDto['rule_findings']) ?? null,
      verification: this.toVerificationDto(c.verification),
      suggested_redraft: this.parseRedraft(c.suggestedWording),
    };
  }

  private toVerificationDto(v: Record<string, unknown> | null | undefined): ContractClauseResponseDto['verification'] {
    const x = v as Partial<Verification> | null | undefined;
    if (!x || (x.status !== 'confirmed' && x.status !== 'unconfirmed') || typeof x.reason !== 'string') return null;
    return { status: x.status, basis: x.basis ?? (x.status === 'confirmed' ? 'confirmed' : 'uncertain'), reason: x.reason, quote: x.quote ?? null };
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

  /**
   * مسار القواعد: وقائع البند بالاقتباس ثم قواعد حتمية. يُرجع true إن حسمت القواعد البند (تُحفظ نتيجته ولا يُنادى نموذج التقييم)،
   * وfalse لتكملة المسار العادى (لا وقائع موثَّقة، أو لا قاعدة تنطبق، أو تعذّر جلب المواد المرجعية). لا يُسقط البند أبداً: أى عطل ⇒ false.
   */
  private async tryRuleAssessment(
    row: ContractClause,
    criteria: ReturnType<typeof classifyClauseCriteria>,
    position: ClientPosition,
    context: { userId: string; ipAddress: string | null; userAgent: string | null },
  ): Promise<boolean> {
    if (!this.factsService?.isConfigured) return false;
    if (!criteria.some((c) => RULE_TOPIC_CRITERIA.includes(c))) return false;
    let out = await this.factsService.extract({ clauseText: row.clauseText });
    if (out.status === 'error') out = await this.factsService.extract({ clauseText: row.clauseText });
    if (out.status !== 'ok' || !hasAnyFact(out.facts)) return false;
    row.facts = out.facts as unknown as Record<string, unknown>;
    const findings = evaluateRules(out.facts, { clientParty: position.clientParty ?? null });
    row.ruleFindings = findings as unknown as Array<Record<string, unknown>>;
    if (findings.length === 0) return false;
    const summary = summarizeFindings(findings);
    const candidates = await this.civilCodeCandidates(summary.articles);
    if (candidates.length === 0) return false; // لا حكم بلا سند مفهرَس
    row.assessmentStatus = summary.status;
    row.assessmentReasoning = summary.reasoning;
    row.matchedArticles = candidates.map((c) => ({
      law: c.citation.law,
      law_no: c.citation.lawNo,
      law_year: c.citation.lawYear,
      article_no: c.citation.articleNo,
      snippet: c.citation.snippet,
      official_url: c.citation.officialUrl,
    }));
    row.assessmentConfidence = 0.8;
    row.riskLevel = summary.risk;
    await this.clauseRepository.save(row);
    await this.audit(context, 'contracts.clause_assessed', row.contractId, {
      clauseIndex: row.clauseIndex,
      criteria: row.clauseTypeGuess,
      status: row.assessmentStatus,
      viaRules: findings.map((f) => f.ruleId),
    });
    return true;
  }

  private async assessAndPersistClause(
    row: ContractClause,
    context: { userId: string; ipAddress: string | null; userAgent: string | null },
    position: ClientPosition,
  ): Promise<void> {
    try {
      // تصنيف البند إلى معايير المراجعة العشرة (حتمى، بكلمات مفتاحية) + جلب المواد
      // المرجعية للمعيار (مثل 224 للتعويض الاتفاقى و217 للإعفاء من المسؤولية) التى
      // لا يلتقطها البحث العام لأن صياغة البند التعاقدى لا تشبه صياغة النص القانونى.
      const criteria = classifyClauseCriteria(row.clauseTitle, row.clauseText);
      row.clauseTypeGuess = serializeCriteria(criteria);
      try {
        if (await this.tryRuleAssessment(row, criteria, position, context)) return;
      } catch (err) {
        // أى عطل فى مسار القواعد لا يُسقط البند: يُكمل بالتقييم الآلى العادى
        this.logger.warn(`rule assessment skipped clauseIndex=${row.clauseIndex}: ${(err as Error).message}`);
      }
      const [ftsCandidates, semanticCandidates] = await Promise.all([
        this.ftsCandidates(row.clauseText, 8),
        this.semanticCandidates(row.clauseText, 8),
      ]);
      const merged = this.mergeCandidates(ftsCandidates, semanticCandidates);

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

      const assessRequest = {
        clauseText: row.clauseText,
        clientPosition: describePosition(position),
        candidates: topCandidates.map((c) => ({
          lawTitle: c.citation.law,
          lawNo: c.citation.lawNo,
          lawYear: c.citation.lawYear,
          articleNo: c.citation.articleNo,
          articleText: c.citation.snippet,
        })),
      };
      let assessment = await this.generationService.assessClause(assessRequest);
      if (assessment.status === 'error') {
        // عطل عابر أو رد غير مقروء: محاولة ثانية واحدة قبل الإقرار بالفشل (يبقى fail-closed بعدها)
        this.logger.warn(`assessClause retry clauseIndex=${row.clauseIndex} detail=${assessment.detail}`);
        assessment = await this.generationService.assessClause(assessRequest);
      }

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
        row.riskLevel = null;
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
        let mandatoryVerified = false;
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
            assessmentStatus: row.assessmentStatus,
            matched: validIndices.map((i) => ({
              law: topCandidates[i].citation.law,
              articleNo: topCandidates[i].citation.articleNo,
              text: topCandidates[i].citation.snippet,
            })),
          });
          if (assessment.violationType === 'mandatory_violation' && !guarded.mandatoryVerified) {
            // تشخيص فقط (لا نص عقد): لماذا خُفِّض ادعاء المخالفة الآمرة؟
            const q = assessment.mandatoryQuote ?? '';
            this.logger.warn(
              `mandatory claim downgraded clauseIndex=${row.clauseIndex} quoteLen=${q.length} hasMarker=${hasMandatoryMarker(q)} ` +
                `inArticles=${isQuoteInArticles(q, topCandidates.map((c) => c.citation.snippet))}`,
            );
          }
          mandatoryVerified = guarded.mandatoryVerified;
          row.assessmentReasoning = softenSupplementaryWording(guarded.reasoning, guarded.mandatoryVerified);
        }
        row.matchedArticles = matched;
        row.assessmentConfidence = assessment.confidence;
        row.riskLevel = riskLevelFor(row.assessmentStatus, assessment.violationType, mandatoryVerified);
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
      row.riskLevel = null;
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
      client_party: contract.clientParty ?? null,
      warnings,
      ...this.toFindingsDto(contract.contractFindings),
      clauses: clauses.map((c) => this.toClauseDto(c)),
      created_at: contract.createdAt,
    };
  }

  private toFindingsDto(stored: Record<string, unknown> | null | undefined): Pick<ContractResponseDto, 'contract_findings' | 'contract_findings_model'> {
    const doc = stored as Partial<ContractLevelResult> | null | undefined;
    if (!doc || !Array.isArray(doc.findings)) return { contract_findings: [], contract_findings_model: null };
    return {
      contract_findings: sortFindings(doc.findings).map((f) => ({
        id: f.id,
        kind: f.kind,
        kind_label: FINDING_KIND_LABEL[f.kind] ?? f.kind,
        severity: f.severity,
        title: f.title,
        explanation: f.explanation,
        suggestion: f.suggestion ?? null,
        evidence: (f.evidence ?? []).map((e) => ({ clause_index: e.clauseIndex, clause_label: e.clauseLabel, quote: e.quote })),
        source: f.source,
        verification: this.toVerificationDto(f.verification as unknown as Record<string, unknown> | null | undefined),
      })),
      contract_findings_model: doc.model ?? null,
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
  /** مواد القانون المدنى 131/1948 المفهرَسة بأرقامها (النسخة السارية)، بترتيب الأرقام المطلوبة. */
  private async civilCodeCandidates(articleNos: number[]): Promise<ClauseCandidate[]> {
    const out: ClauseCandidate[] = [];
    if (articleNos.length === 0) return out;
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
    return out;
  }

  private async anchorCandidates(
    criteria: ReturnType<typeof classifyClauseCriteria>,
    clauseText: string,
    clauseTitle: string | null,
  ): Promise<ClauseCandidate[]> {
    const out: ClauseCandidate[] = [];
    const articleNos = Array.from(
      new Set([...anchorArticleNumbers(criteria, 3), ...leaseAnchorArticleNumbers(clauseTitle, clauseText, 3)]),
    );
    out.push(...(await this.civilCodeCandidates(articleNos)));
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
