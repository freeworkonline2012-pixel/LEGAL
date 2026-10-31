import { BadRequestException, ConflictException, ForbiddenException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { Answer } from '../database/entities/answer.entity';
import { Contract } from '../database/entities/contract.entity';
import { ContractClause } from '../database/entities/contract-clause.entity';
import { GovernanceAssessment } from '../database/entities/governance-assessment.entity';
import { LegalMemo } from '../database/entities/legal-memo.entity';
import { Question } from '../database/entities/question.entity';
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

  /** تحميل العقد وبنوده لأى تصدير: الملكية، اكتمال المعالجة، وشرط الاعتماد البشرى (قبله لـadmin فقط). */
  private async loadContractForExport(contractId: string, actor: ExportActor): Promise<{ contract: Contract; clauses: ContractClause[]; approved: boolean }> {
    const contract = await this.dataSource.getRepository(Contract).findOne({ where: { id: contractId } });
    if (!contract || !this.canAccess(contract.uploadedBy, actor)) {
      throw new NotFoundException('العقد غير موجود');
    }
    if (contract.status !== 'processed') {
      throw new ConflictException('لم تكتمل معالجة العقد بعد، فلا يتوفر تقرير للتنزيل.');
    }
    const approved = contract.reportApprovedAt !== null;
    const approvalRequired = process.env.CONTRACT_REPORT_REQUIRES_APPROVAL !== 'false';
    if (approvalRequired && !approved && actor.role !== 'admin') {
      // التقرير الآلى مسودة عمل: لا يصل العميل قبل مراجعة بشرية (قرار المنتج)
      throw new ConflictException('التقرير قيد المراجعة البشرية وسيتاح للتنزيل فور اعتماده.');
    }
    const clauses = await this.dataSource.getRepository(ContractClause).find({
      where: { contractId },
      order: { clauseIndex: 'ASC' },
    });
    return { contract, clauses, approved };
  }

  async exportContract(contractId: string, format: ExportFormat, actor: ExportActor, audience: 'lawyer' | 'client' = 'lawyer'): Promise<ExportedFile> {
    const { contract, clauses, approved } = await this.loadContractForExport(contractId, actor);
    const doc = this.guard(() =>
      buildContractDocument({
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
        audience,
        generatedAt: new Date(),
        brand: this.brand,
      }),
    );
    return this.deliver(doc, format, actor, 'contract', contract.id, { approved });
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

  private reportVerification(v: Record<string, unknown> | null | undefined): { status: 'confirmed' | 'unconfirmed'; reason: string; quote: string | null } | null {
    if (!v || (v.status !== 'confirmed' && v.status !== 'unconfirmed') || typeof v.reason !== 'string' || !v.reason) return null;
    return { status: v.status, reason: v.reason, quote: typeof v.quote === 'string' && v.quote ? v.quote : null };
  }

  /** اسما الطرفين المخزَّنان وقت الرفع (contractFindings.parties)؛ null إن لم يُخزَّنا (عقد قديم). */
  private reportParties(stored: Record<string, unknown> | null | undefined): { first: string | null; second: string | null } | null {
    const p = (stored as { parties?: { first?: unknown; second?: unknown } } | null | undefined)?.parties;
    if (!p || typeof p !== 'object') return null;
    const n = (v: unknown) => (typeof v === 'string' && v.trim() ? v.trim() : null);
    return { first: n(p.first), second: n(p.second) };
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
    };
    const str = (v: unknown) => (typeof v === 'string' ? v : '');
    const rank: Record<string, number> = { حرج: 0, عالٍ: 1, متوسط: 2, منخفض: 3 };
    const list = (doc.findings as Array<Record<string, unknown>>)
      .filter((f) => f && typeof f === 'object' && str(f.title) && str(f.explanation))
      .map((f) => ({
        kind: str(f.kind),
        kindLabel: labels[str(f.kind)] ?? str(f.kind),
        severity: str(f.severity) || 'متوسط',
        title: str(f.title),
        explanation: str(f.explanation),
        suggestion: str(f.suggestion) || null,
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
