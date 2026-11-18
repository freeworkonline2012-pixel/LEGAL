import { BadRequestException, ConflictException, ForbiddenException, HttpException, HttpStatus, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { Answer } from '../database/entities/answer.entity';
import { Contract } from '../database/entities/contract.entity';
import { ContractClause } from '../database/entities/contract-clause.entity';
import { GovernanceAssessment } from '../database/entities/governance-assessment.entity';
import { LegalMemo } from '../database/entities/legal-memo.entity';
import { Question } from '../database/entities/question.entity';
import {
  type OrderStage,
  isPaid,
  paymentInstructionsFromEnv,
  sanitizePaymentReference,
  serviceFeeFromEnv,
  stageOf,
} from '../contracts/contract-order';
import { buildAnswerDocument, NotExportableError } from './builders/answer-document.builder';
import { buildContractDocument, type ContractExportInput } from './builders/contract-document.builder';
import { buildTrackedDocx } from './tracked-changes/tracked-document';
import { buildGovernanceDocument } from './builders/governance-document.builder';
import { buildMemoDocument } from './builders/memo-document.builder';
import { DEFAULT_BRAND, type LegalDocument, compactCairoDate, shortReference } from './document-model';
import { renderDocx } from './renderers/docx.renderer';
import { PdfRenderer } from './renderers/pdf.renderer';

export type ExportFormat = 'pdf' | 'docx';

export interface ExportActor {
  userId: string;
  role: string;
  ipAddress: string | null;
  userAgent: string | null;
}

export interface ContractOrderView {
  contract_id: string;
  stage: OrderStage;
  /** المالك/admin: بلا مقابل ولا مراحل */
  free_access: boolean;
  processed: boolean;
  fee_amount: number | null;
  fee_currency: 'EGP';
  payment_instructions: string | null;
  payment_reference: string | null;
  approved_at: string | null;
  paid_at: string | null;
  can_download_preliminary: boolean;
  can_download_final: boolean;
  awaiting_human_review: boolean;
  /** تفاصيل المراجعة (الأسانيد والصياغات) مخفية على الشاشة حتى السداد */
  details_locked: boolean;
}

export interface PendingPaymentItem {
  contract_id: string;
  original_filename: string;
  fee_amount: number | null;
  fee_currency: 'EGP';
  payment_reference: string | null;
  submitted_at: string | null;
}

export interface ExportedFile {
  buffer: Buffer;
  contentType: string;
  filename: string;
}

const CONTENT_TYPES: Record<ExportFormat, string> = {
  pdf: 'application/pdf',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
};

/**
 * تنزيل المستندات (PDF / Word). المبادئ:
 *  1) المحتوى يُبنى على الخادم من سجل محفوظ ومملوك للمستخدم — لا يُقبل نص من العميل أبداً (لا تزوير لمستند بترويسة المنصة).
 *  2) الملكية: المالك أو admin فقط؛ وغير ذلك 404 (لا نكشف وجود سجل لا يملكه).
 *  3) كل تنزيل يُسجَّل فى سجل التدقيق (من/ماذا/متى/بأى صيغة).
 *  4) تقرير العقد لا يُسلَّم لغير admin قبل اعتماد المراجعة البشرية.
 */
@Injectable()
export class ExportsService {
  private readonly logger = new Logger(ExportsService.name);

  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly auditService: AuditService,
    private readonly pdfRenderer: PdfRenderer,
  ) {}

  private get brand(): string {
    return process.env.EXPORT_BRAND_NAME?.trim() || DEFAULT_BRAND;
  }

  capabilities(): { pdf: boolean; docx: boolean } {
    return { pdf: this.pdfRenderer.isAvailable(), docx: true };
  }

  async exportAnswer(answerId: string, format: ExportFormat, actor: ExportActor): Promise<ExportedFile> {
    const answer = await this.dataSource.getRepository(Answer).findOne({
      where: { id: answerId },
      relations: { citations: true },
    });
    const question = answer
      ? await this.dataSource.getRepository(Question).findOne({ where: { id: answer.questionId } })
      : null;
    if (!answer || !question || !this.canAccess(question.userId, actor)) {
      throw new NotFoundException('الإجابة غير موجودة');
    }
    if (answer.refused || (answer.citations ?? []).length === 0) {
      throw new ConflictException('هذه الإجابة بلا سند قانونى موثَّق، فلا تُتاح للتنزيل كمستند للاستشهاد.');
    }
    const doc = this.guard(() =>
      buildAnswerDocument({
        answerId: answer.id,
        question: question.question,
        answerText: answer.answer,
        structured: answer.structured,
        citations: (answer.citations ?? []).map((c) => ({
          law: c.law,
          lawNo: c.lawNo,
          lawYear: c.lawYear,
          articleNo: c.articleNo,
          status: c.status,
          lastAmended: c.lastAmended,
          officialUrl: c.officialUrl,
          snippet: c.snippet,
          position: c.position,
        })),
        createdAt: answer.createdAt,
        generatedAt: new Date(),
        brand: this.brand,
      }),
    );
    return this.deliver(doc, format, actor, 'answer', answer.id);
  }

  async exportGovernance(assessmentId: string, format: ExportFormat, actor: ExportActor): Promise<ExportedFile> {
    const row = await this.dataSource.getRepository(GovernanceAssessment).findOne({ where: { id: assessmentId } });
    if (!row || !this.canAccess(row.userId, actor)) {
      throw new NotFoundException('التقييم غير موجود');
    }
    const doc = this.guard(() =>
      buildGovernanceDocument({
        assessmentId: row.id,
        requestText: row.requestText,
        result: row.result,
        createdAt: row.createdAt,
        generatedAt: new Date(),
        brand: this.brand,
      }),
    );
    return this.deliver(doc, format, actor, 'governance', row.id);
  }

  /**
   * مذكرة/تقرير قانونى (migrations/204): الأسانيد من الإجابة المنظَّمة المحفوظة المرتبطة بالمذكرة
   * (answer_id)، والوقائع والطلبات من سجل المذكرة المُشفَّر. المالك أو admin فقط؛ المستند مسودة دائماً.
   */
  async exportMemo(memoId: string, format: ExportFormat, actor: ExportActor): Promise<ExportedFile> {
    const memo = await this.dataSource.getRepository(LegalMemo).findOne({ where: { id: memoId } });
    if (!memo || !this.canAccess(memo.userId, actor)) {
      throw new NotFoundException('المذكرة غير موجودة');
    }
    const answer = await this.dataSource.getRepository(Answer).findOne({
      where: { id: memo.answerId },
      relations: { citations: true },
    });
    if (!answer || answer.refused || (answer.citations ?? []).length === 0) {
      throw new ConflictException('أسانيد هذه المذكرة غير متاحة (قد تكون حُذفت)، فلا يمكن تنزيلها.');
    }
    const rawRequests = memo.requests?.items;
    const requests = Array.isArray(rawRequests)
      ? rawRequests.filter((r): r is string => typeof r === 'string' && r.trim().length > 0)
      : [];
    const doc = this.guard(() =>
      buildMemoDocument({
        memoId: memo.id,
        memoType: memo.memoType,
        partyRole: memo.partyRole,
        title: memo.title,
        issue: memo.issue,
        facts: memo.facts,
        requests,
        answerText: answer.answer,
        structured: answer.structured,
        citations: (answer.citations ?? []).map((c) => ({
          law: c.law,
          lawNo: c.lawNo,
          lawYear: c.lawYear,
          articleNo: c.articleNo,
          status: c.status,
          lastAmended: c.lastAmended,
          officialUrl: c.officialUrl,
          snippet: c.snippet,
          position: c.position,
        })),
        createdAt: memo.createdAt,
        generatedAt: new Date(),
        brand: this.brand,
      }),
    );
    return this.deliver(doc, format, actor, 'legal_memo', memo.id, { memoType: memo.memoType });
  }

  /**
   * تحميل العقد وبنوده لأى تصدير: الملكية، اكتمال المعالجة، ثم (للتنزيل النهائى فقط) السداد المؤكَّد والاعتماد البشرى.
   * purpose='preliminary' = النسخة الأولية PDF: متاحة للمالك دائماً بعد اكتمال المعالجة (بعلامة «نسخة أولية»).
   * admin بلا مقابل ولا مراحل.
   */
  private async loadContractForExport(
    contractId: string,
    actor: ExportActor,
    purpose: 'final' | 'preliminary' = 'final',
  ): Promise<{ contract: Contract; clauses: ContractClause[]; approved: boolean }> {
    const contract = await this.dataSource.getRepository(Contract).findOne({ where: { id: contractId } });
    if (!contract || !this.canAccess(contract.uploadedBy, actor)) {
      throw new NotFoundException('العقد غير موجود');
    }
    if (contract.status !== 'processed') {
      throw new ConflictException('لم تكتمل معالجة العقد بعد، فلا يتوفر تقرير للتنزيل.');
    }
    const approved = contract.reportApprovedAt !== null;
    if (purpose === 'final' && actor.role !== 'admin') {
      if (!isPaid(contract)) {
        throw new HttpException(this.paymentRequiredMessage(stageOf(contract)), HttpStatus.PAYMENT_REQUIRED);
      }
      const approvalRequired = process.env.CONTRACT_REPORT_REQUIRES_APPROVAL !== 'false';
      if (approvalRequired && !approved) {
        // التقرير الآلى مسودة عمل: لا يصل العميل قبل مراجعة بشرية (قرار المنتج)
        throw new ConflictException('العقد قيد المراجعة البشرية وسيتاح للتنزيل فور اعتماده.');
      }
    }
    const clauses = await this.dataSource.getRepository(ContractClause).find({
      where: { contractId },
      order: { clauseIndex: 'ASC' },
    });
    return { contract, clauses, approved };
  }

  private paymentRequiredMessage(stage: OrderStage): string {
    if (stage === 'payment_submitted') return 'بانتظار تأكيد السداد — سيتاح التنزيل فور التأكيد.';
    if (stage === 'approved') return 'التنزيل النهائى يتاح بعد سداد مقابل الخدمة.';
    return 'التنزيل النهائى يتاح بعد موافقتك على النسخة الأولية وسداد مقابل الخدمة.';
  }

  private contractInput(contract: Contract, clauses: ContractClause[], audience: 'lawyer' | 'client'): ContractExportInput {
    return {
      contractId: contract.id,
      originalFilename: contract.originalFilename,
      uploadedAt: contract.createdAt,
      contractType: contract.contractType,
      clientRole: contract.clientRole,
      clientParty: contract.clientParty ?? null,
      clauses: clauses.map((c) => ({
        clauseIndex: c.clauseIndex,
        clauseLabel: c.clauseLabel,
        clauseTitle: c.clauseTitle,
        clauseText: c.clauseText,
        assessmentStatus: c.assessmentStatus,
        assessmentReasoning: c.assessmentReasoning,
        matchedArticles: c.matchedArticles,
        riskLevel: c.riskLevel,
        suggestedWording: c.suggestedWording,
        lawyerVerdict: c.lawyerVerdict,
        lawyerNotes: c.lawyerNotes,
        verification: this.reportVerification(c.verification),
      })),
      approvedAt: contract.reportApprovedAt,
      approvalNote: contract.reportApprovalNote,
      extractionWarnings: Array.isArray(contract.extractionWarnings)
        ? contract.extractionWarnings.filter((w): w is string => typeof w === 'string')
        : null,
      ...this.reportFindings(contract.contractFindings),
      partyNames: this.reportParties(contract.contractFindings),
      inferredContractType: this.reportInferredType(contract.contractFindings),
      inferredContractTypeSource: this.reportInferredSource(contract.contractFindings),
      audience,
      generatedAt: new Date(),
      brand: this.brand,
    };
  }

  async exportContract(contractId: string, format: ExportFormat, actor: ExportActor, audience: 'lawyer' | 'client' = 'lawyer'): Promise<ExportedFile> {
    const { contract, clauses, approved } = await this.loadContractForExport(contractId, actor);
    const doc = this.guard(() => buildContractDocument(this.contractInput(contract, clauses, audience)));
    return this.deliver(doc, format, actor, 'contract', contract.id, { approved });
  }

  /**
   * النسخة الأولية PDF: نسخة العميل المبسطة بعلامة مائية «نسخة أولية — غير نهائية»، متاحة للمالك دائماً بعد اكتمال المعالجة
   * (قبل الموافقة والسداد). لا تحمل اعتماداً بشرياً مهما كانت حالة العقد، وصيغتها PDF فقط.
   */
  async exportContractPreliminary(contractId: string, actor: ExportActor): Promise<ExportedFile> {
    const { contract, clauses } = await this.loadContractForExport(contractId, actor, 'preliminary');
    const doc = this.guard(() => buildContractDocument({ ...this.contractInput(contract, clauses, 'client'), approvedAt: null, approvalNote: null }));
    const WATERMARK = 'نسخة أولية — غير نهائية';
    const preliminary = {
      ...doc,
      watermark: WATERMARK,
      filenameBase: doc.filenameBase.replace(/-draft$/, '-preliminary'),
      audit: doc.audit ? { ...doc.audit, watermark: WATERMARK } : doc.audit,
    };
    return this.deliver(preliminary, 'pdf', actor, 'contract', contract.id, { preliminary: true });
  }

  /**
   * نسخة Word من العقد بتعديلات متتبَّعة وتعليقات (الجولة 6). نفس شروط تقرير العقد (الملكية + الاعتماد البشرى)، وتُسجَّل فى
   * سجل التدقيق كتنزيل من نوع contract_tracked. الصياغات المقترحة وحدها هى مصدر التعديلات؛ لا نص من العميل.
   */
  async exportContractTracked(contractId: string, actor: ExportActor): Promise<ExportedFile> {
    const { contract, clauses, approved } = await this.loadContractForExport(contractId, actor);
    const reference = shortReference('CTR', contract.id);
    const generatedAt = new Date();
    const { buffer, stats } = await buildTrackedDocx({
      originalFilename: contract.originalFilename,
      contractType: contract.contractType,
      reference,
      generatedAt,
      approvedAt: contract.reportApprovedAt,
      brand: this.brand,
      clauses: clauses.map((c) => ({
        clauseIndex: c.clauseIndex,
        clauseLabel: c.clauseLabel,
        clauseTitle: c.clauseTitle,
        clauseText: c.clauseText,
        assessmentStatus: c.assessmentStatus,
        assessmentReasoning: c.assessmentReasoning,
        riskLevel: c.riskLevel,
        matchedArticles: c.matchedArticles,
        suggestedWording: c.suggestedWording,
        verification: (() => {
          const v = this.reportVerification(c.verification);
          return v ? { status: v.status, reason: v.reason } : null;
        })(),
      })),
    });
    await this.auditService
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action: 'export.downloaded',
        resourceType: 'contract',
        resourceId: contract.id,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
        metadata: { format: 'docx', kind: 'contract_tracked', bytes: buffer.length, reference, approved, ...stats },
      })
      .catch((err) => this.logger.warn(`export audit failed (non-fatal): ${(err as Error).message}`));
    return {
      buffer,
      contentType: CONTENT_TYPES.docx,
      filename: `contract-${reference.slice(4).toLowerCase()}-${compactCairoDate(generatedAt)}-tracked${approved ? '' : '-draft'}.docx`,
    };
  }

  private reportVerification(v: Record<string, unknown> | null | undefined): { status: 'confirmed' | 'unconfirmed'; reason: string; quote: string | null; reclassified?: 'deviation'; basis?: string; refutationKind?: string } | null {
    if (!v || (v.status !== 'confirmed' && v.status !== 'unconfirmed') || typeof v.reason !== 'string' || !v.reason) return null;
    return {
      status: v.status,
      reason: v.reason,
      quote: typeof v.quote === 'string' && v.quote ? v.quote : null,
      ...(v.reclassified === 'deviation' ? { reclassified: 'deviation' as const } : {}),
      ...(typeof v.basis === 'string' ? { basis: v.basis } : {}),
      ...(typeof v.refutationKind === 'string' ? { refutationKind: v.refutationKind } : {}),
    };
  }

  /** اسما الطرفين المخزَّنان وقت الرفع (contractFindings.parties)؛ null إن لم يُخزَّنا (عقد قديم). */
  private reportParties(
    stored: Record<string, unknown> | null | undefined,
  ): { first: string | null; second: string | null; blank?: Array<'first' | 'second'> } | null {
    const p = (stored as { parties?: { first?: unknown; second?: unknown; blank?: unknown } } | null | undefined)?.parties;
    if (!p || typeof p !== 'object') return null;
    const n = (v: unknown) => (typeof v === 'string' && v.trim() ? v.trim() : null);
    const blank = Array.isArray(p.blank) ? (p.blank.filter((x) => x === 'first' || x === 'second') as Array<'first' | 'second'>) : [];
    return { first: n(p.first), second: n(p.second), ...(blank.length > 0 ? { blank } : {}) };
  }

  /** نوع العقد المستنتج من العنوان وقت الرفع (contractFindings.inferredContractType)؛ null إن لم يُستنتج أو كان عقداً قديماً. */
  private reportInferredType(stored: Record<string, unknown> | null | undefined): string | null {
    const v = (stored as { inferredContractType?: unknown } | null | undefined)?.inferredContractType;
    return typeof v === 'string' && v.trim() ? v.trim() : null;
  }

  /** مصدر استنتاج النوع (title | body | filename)؛ null للعقود القديمة (كان العنوان وحده). */
  private reportInferredSource(stored: Record<string, unknown> | null | undefined): 'title' | 'body' | 'filename' | null {
    const v = (stored as { inferredContractTypeSource?: unknown } | null | undefined)?.inferredContractTypeSource;
    return v === 'title' || v === 'body' || v === 'filename' ? v : null;
  }

  /** ملاحظات العقد ككل المخزَّنة (migrations/237) بصيغة التقرير؛ لا شىء للعقود التى لم تُحلَّل. */
  private reportFindings(stored: Record<string, unknown> | null | undefined): Pick<ContractExportInput, 'contractFindings' | 'contractFindingsModel'> {
    const doc = stored as { findings?: unknown; model?: unknown } | null | undefined;
    if (!doc || !Array.isArray(doc.findings)) return {};
    const labels: Record<string, string> = {
      missing_clause: 'بند غير مرصود',
      undefined_term: 'مصطلح أو إحالة غير معرَّفة',
      open_term: 'شرط مفتوح',
      conflict: 'تعارض محتمل بين بندين',
      scope_mismatch: 'عدم اتساق فى النطاق',
      office_rule: 'قاعدة المكتب',
      blank_field: 'نموذج غير مكتمل',
    };
    const str = (v: unknown) => (typeof v === 'string' ? v : '');
    const rank: Record<string, number> = { حرج: 0, عالٍ: 1, متوسط: 2, منخفض: 3 };
    const list = (doc.findings as Array<Record<string, unknown>>)
      .filter((f) => f && typeof f === 'object' && str(f.title) && str(f.explanation))
      .map((f) => ({
        id: str(f.id) || undefined,
        kind: str(f.kind),
        kindLabel: labels[str(f.kind)] ?? str(f.kind),
        severity: str(f.severity) || 'متوسط',
        title: str(f.title),
        explanation: str(f.explanation),
        suggestion: str(f.suggestion) || null,
        severityNote: str(f.severityNote) || null,
        verification: this.reportVerification(f.verification as Record<string, unknown> | null | undefined),
        evidence: (Array.isArray(f.evidence) ? (f.evidence as Array<Record<string, unknown>>) : [])
          .filter((e) => e && str(e.quote))
          .map((e) => ({ clauseLabel: str(e.clauseLabel), quote: str(e.quote) })),
      }))
      .sort((a, b) => (rank[a.severity] ?? 9) - (rank[b.severity] ?? 9));
    const m = str(doc.model);
    return {
      contractFindings: list,
      contractFindingsModel: m === 'ok' || m === 'not_configured' || m === 'skipped' || m === 'error' ? m : null,
    };
  }

  // ===== طلب المراجعة: الموافقة والسداد (migrations/262) =====

  private orderView(contract: Contract, actor: ExportActor): ContractOrderView {
    const fee = serviceFeeFromEnv();
    const free = actor.role === 'admin';
    const stage = stageOf(contract);
    const approvalRequired = process.env.CONTRACT_REPORT_REQUIRES_APPROVAL !== 'false';
    const humanApproved = contract.reportApprovedAt !== null;
    const paid = stage === 'paid';
    return {
      contract_id: contract.id,
      stage,
      free_access: free,
      processed: contract.status === 'processed',
      fee_amount: contract.serviceFeeMinor !== null && contract.serviceFeeMinor !== undefined ? contract.serviceFeeMinor / 100 : fee.amount,
      fee_currency: 'EGP',
      payment_instructions: free || paid ? null : paymentInstructionsFromEnv(),
      payment_reference: contract.paymentReference ?? null,
      approved_at: contract.clientApprovedAt ? contract.clientApprovedAt.toISOString() : null,
      paid_at: contract.paidAt ? contract.paidAt.toISOString() : null,
      can_download_preliminary: contract.status === 'processed',
      can_download_final: contract.status === 'processed' && (free || (paid && (!approvalRequired || humanApproved))),
      awaiting_human_review: !free && paid && approvalRequired && !humanApproved,
      details_locked: !free && !paid,
    };
  }

  private async ownedContract(contractId: string, actor: ExportActor): Promise<Contract> {
    const contract = await this.dataSource.getRepository(Contract).findOne({ where: { id: contractId } });
    if (!contract || !this.canAccess(contract.uploadedBy, actor)) throw new NotFoundException('العقد غير موجود');
    return contract;
  }

  private async recordOrderAudit(actor: ExportActor, action: string, contractId: string, metadata: Record<string, unknown>): Promise<void> {
    await this.auditService
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action,
        resourceType: 'contract',
        resourceId: contractId,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
        metadata,
      })
      .catch((err) => this.logger.warn(`order audit failed (non-fatal): ${(err as Error).message}`));
  }

  async getContractOrder(contractId: string, actor: ExportActor): Promise<ContractOrderView> {
    return this.orderView(await this.ownedContract(contractId, actor), actor);
  }

  /** موافقة العميل على النسخة الأولية: تُثبّت قيمة الخدمة وقتها. idempotent؛ admin بلا مراحل (لا تغيير). */
  async approveContractOrder(contractId: string, actor: ExportActor): Promise<ContractOrderView> {
    const repo = this.dataSource.getRepository(Contract);
    const contract = await this.ownedContract(contractId, actor);
    if (actor.role === 'admin') return this.orderView(contract, actor);
    if (contract.status !== 'processed') throw new ConflictException('لم تكتمل معالجة العقد بعد.');
    if (stageOf(contract) !== 'preview') return this.orderView(contract, actor);
    const fee = serviceFeeFromEnv();
    if (fee.amount === null) throw new ConflictException('لم يُحدَّد سعر الخدمة بعد — تواصل مع إدارة المنصة.');
    const approvedAt = new Date();
    await repo.update({ id: contractId }, { clientApprovedAt: approvedAt, serviceFeeMinor: fee.amount * 100, serviceFeeCurrency: fee.currency });
    contract.clientApprovedAt = approvedAt;
    contract.serviceFeeMinor = fee.amount * 100;
    contract.serviceFeeCurrency = fee.currency;
    await this.recordOrderAudit(actor, 'contracts.order_approved', contractId, { feeMinor: fee.amount * 100, currency: fee.currency });
    return this.orderView(contract, actor);
  }

  /** إعلان العميل أنه سدّد (مرجع عملية قصير يطابقه المالك). يجوز تصحيح المرجع قبل التأكيد. */
  async submitContractPayment(contractId: string, referenceRaw: unknown, actor: ExportActor): Promise<ContractOrderView> {
    const repo = this.dataSource.getRepository(Contract);
    const contract = await this.ownedContract(contractId, actor);
    if (actor.role === 'admin') return this.orderView(contract, actor);
    const stage = stageOf(contract);
    if (stage === 'paid') return this.orderView(contract, actor);
    if (stage === 'preview') throw new ConflictException('وافق على النسخة الأولية أولاً قبل السداد.');
    const reference = sanitizePaymentReference(referenceRaw);
    if (!reference) throw new BadRequestException('اكتب مرجع السداد (رقم العملية أو التحويل) — من 3 إلى 100 حرف.');
    const submittedAt = new Date();
    await repo.update({ id: contractId }, { paymentStatus: 'submitted', paymentReference: reference, paymentSubmittedAt: submittedAt });
    contract.paymentStatus = 'submitted';
    contract.paymentReference = reference;
    contract.paymentSubmittedAt = submittedAt;
    await this.recordOrderAudit(actor, 'contracts.payment_submitted', contractId, { hasReference: true });
    return this.orderView(contract, actor);
  }

  /** تأكيد السداد (admin فقط — يُفرَض فى المتحكم). idempotent؛ لا يجوز قبل موافقة العميل. */
  async confirmContractPayment(contractId: string, actor: ExportActor): Promise<ContractOrderView> {
    const repo = this.dataSource.getRepository(Contract);
    const contract = await repo.findOne({ where: { id: contractId } });
    if (!contract) throw new NotFoundException('العقد غير موجود');
    const stage = stageOf(contract);
    if (stage === 'paid') return this.orderView(contract, actor);
    if (stage === 'preview') throw new ConflictException('لم يوافق العميل على النسخة الأولية بعد.');
    const paidAt = new Date();
    await repo.update({ id: contractId }, { paymentStatus: 'paid', paidAt, paidConfirmedBy: actor.userId });
    contract.paymentStatus = 'paid';
    contract.paidAt = paidAt;
    await this.recordOrderAudit(actor, 'contracts.payment_confirmed', contractId, { feeMinor: contract.serviceFeeMinor });
    return this.orderView(contract, actor);
  }

  /** طلبات بانتظار تأكيد السداد (admin فقط). أقدمها أولاً، بحد 100. */
  async listPendingPayments(): Promise<PendingPaymentItem[]> {
    const rows = await this.dataSource.getRepository(Contract).find({
      where: { paymentStatus: 'submitted' },
      order: { paymentSubmittedAt: 'ASC' },
      take: 100,
    });
    return rows.map((c) => ({
      contract_id: c.id,
      original_filename: c.originalFilename,
      fee_amount: c.serviceFeeMinor !== null && c.serviceFeeMinor !== undefined ? c.serviceFeeMinor / 100 : null,
      fee_currency: 'EGP',
      payment_reference: c.paymentReference ?? null,
      submitted_at: c.paymentSubmittedAt ? c.paymentSubmittedAt.toISOString() : null,
    }));
  }

  /** اعتماد المراجعة البشرية لتقرير عقد (admin فقط — يُفرَض فى المتحكم). idempotent. */
  async approveContractReport(
    contractId: string,
    note: string | null,
    actor: ExportActor,
  ): Promise<{ approved_at: string; already_approved: boolean }> {
    const repo = this.dataSource.getRepository(Contract);
    const contract = await repo.findOne({ where: { id: contractId } });
    if (!contract) throw new NotFoundException('العقد غير موجود');
    if (contract.status !== 'processed') {
      throw new ConflictException('لا يُعتمد تقرير عقد لم تكتمل معالجته.');
    }
    if (contract.reportApprovedAt) {
      return { approved_at: contract.reportApprovedAt.toISOString(), already_approved: true };
    }
    const approvedAt = new Date();
    await repo.update(
      { id: contractId },
      { reportApprovedBy: actor.userId, reportApprovedAt: approvedAt, reportApprovalNote: note?.trim() || null },
    );
    await this.auditService.record({
      actorId: actor.userId,
      actorRole: actor.role,
      action: 'contracts.report_approved',
      resourceType: 'contract',
      resourceId: contractId,
      ipAddress: actor.ipAddress,
      userAgent: actor.userAgent,
      metadata: { hasNote: Boolean(note?.trim()) },
    });
    return { approved_at: approvedAt.toISOString(), already_approved: false };
  }

  private canAccess(ownerId: string | null, actor: ExportActor): boolean {
    return actor.role === 'admin' || (ownerId !== null && ownerId === actor.userId);
  }

  private guard(build: () => LegalDocument): LegalDocument {
    try {
      return build();
    } catch (err) {
      if (err instanceof NotExportableError) throw new ConflictException(err.message);
      throw err;
    }
  }

  private async deliver(
    doc: LegalDocument,
    format: ExportFormat,
    actor: ExportActor,
    resourceType: string,
    resourceId: string,
    extra: Record<string, unknown> = {},
  ): Promise<ExportedFile> {
    if (format !== 'pdf' && format !== 'docx') throw new BadRequestException('الصيغة غير مدعومة');
    const buffer = format === 'pdf' ? await this.pdfRenderer.render(doc) : await renderDocx(doc);
    await this.auditService
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action: 'export.downloaded',
        resourceType,
        resourceId,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
        metadata: { format, kind: doc.kind, bytes: buffer.length, reference: doc.reference, ...extra },
      })
      .catch((err) => this.logger.warn(`export audit failed (non-fatal): ${(err as Error).message}`));
    return { buffer, contentType: CONTENT_TYPES[format], filename: `${doc.filenameBase}.${format}` };
  }
}
