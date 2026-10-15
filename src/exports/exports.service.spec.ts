import { ConflictException, NotFoundException } from '@nestjs/common';
import { Answer } from '../database/entities/answer.entity';
import { Contract } from '../database/entities/contract.entity';
import { ContractClause } from '../database/entities/contract-clause.entity';
import { GovernanceAssessment } from '../database/entities/governance-assessment.entity';
import { Question } from '../database/entities/question.entity';
import { ExportsService, type ExportActor } from './exports.service';

const OWNER: ExportActor = { userId: 'u-owner', role: 'user', ipAddress: '1.1.1.1', userAgent: 'jest' };
const OTHER: ExportActor = { userId: 'u-other', role: 'user', ipAddress: null, userAgent: null };
const ADMIN: ExportActor = { userId: 'u-admin', role: 'admin', ipAddress: null, userAgent: null };
const NOW = new Date('2026-10-15T09:00:00Z');

function setup(rows: { answer?: unknown; question?: unknown; governance?: unknown; contract?: unknown; clauses?: unknown[] }) {
  const update = jest.fn().mockResolvedValue(undefined);
  const repos = new Map<unknown, unknown>([
    [Answer, { findOne: jest.fn().mockResolvedValue(rows.answer ?? null) }],
    [Question, { findOne: jest.fn().mockResolvedValue(rows.question ?? null) }],
    [GovernanceAssessment, { findOne: jest.fn().mockResolvedValue(rows.governance ?? null) }],
    [Contract, { findOne: jest.fn().mockResolvedValue(rows.contract ?? null), update }],
    [ContractClause, { find: jest.fn().mockResolvedValue(rows.clauses ?? []) }],
  ]);
  const dataSource = { getRepository: (e: unknown) => repos.get(e) };
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const pdf = { render: jest.fn().mockResolvedValue(Buffer.from("%PDF-fake")), isAvailable: jest.fn().mockReturnValue(true) };
  const service = new ExportsService(dataSource as never, audit as never, pdf as never);
  return { service, audit, pdf, update };
}

const answerRow = (over: Record<string, unknown> = {}) => ({
  id: 'aaaaaaaa-1111-2222-3333-444444444444',
  questionId: 'q1',
  answer: 'نص',
  refused: false,
  structured: null,
  createdAt: NOW,
  citations: [{ law: 'ق', lawNo: 1, lawYear: 2000, articleNo: 1, status: 'active', lastAmended: null, officialUrl: null, snippet: 'نص المادة', position: 0 }],
  ...over,
});

describe('ExportsService — القدرات', () => {
  it('docx دائماً متاح وpdf بحسب توفر المتصفح', () => {
    expect(setup({}).service.capabilities()).toEqual({ pdf: true, docx: true });
  });
});

describe('ExportsService — الإجابات', () => {
  it('المالك يحصل على PDF ويُسجَّل التنزيل فى التدقيق', async () => {
    const { service, audit, pdf } = setup({ answer: answerRow(), question: { userId: OWNER.userId, question: 'س' } });
    const file = await service.exportAnswer('a', 'pdf', OWNER);
    expect(file.contentType).toBe('application/pdf');
    expect(file.filename).toMatch(/^answer-aaaaaaaa-\d{8}\.pdf$/);
    expect(pdf.render).toHaveBeenCalledTimes(1);
    expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ action: 'export.downloaded', actorId: OWNER.userId, resourceType: 'answer', metadata: expect.objectContaining({ format: 'pdf' }) }));
  });

  it('صيغة docx لا تستدعى متصفح PDF', async () => {
    const { service, pdf } = setup({ answer: answerRow(), question: { userId: OWNER.userId, question: 'س' } });
    const file = await service.exportAnswer('a', 'docx', OWNER);
    expect(file.filename.endsWith('.docx')).toBe(true);
    expect(file.buffer.subarray(0, 2).toString()).toBe('PK');
    expect(pdf.render).not.toHaveBeenCalled();
  });

  it('غير المالك: 404 (لا نكشف وجود السجل) ولا تدقيق ولا توليد', async () => {
    const { service, audit, pdf } = setup({ answer: answerRow(), question: { userId: OWNER.userId, question: 'س' } });
    await expect(service.exportAnswer('a', 'pdf', OTHER)).rejects.toBeInstanceOf(NotFoundException);
    expect(pdf.render).not.toHaveBeenCalled();
    expect(audit.record).not.toHaveBeenCalled();
  });

  it('سؤال الزائر (بلا مالك) لا يُنزَّل لمستخدم عادى، والمدير يستطيع', async () => {
    const { service } = setup({ answer: answerRow(), question: { userId: null, question: 'س' } });
    await expect(service.exportAnswer('a', 'pdf', OTHER)).rejects.toBeInstanceOf(NotFoundException);
    await expect(service.exportAnswer('a', 'pdf', ADMIN)).resolves.toBeDefined();
  });

  it('إجابة مرفوضة أو بلا استشهاد: 409', async () => {
    const q = { userId: OWNER.userId, question: 'س' };
    await expect(setup({ answer: answerRow({ refused: true }), question: q }).service.exportAnswer('a', 'pdf', OWNER)).rejects.toBeInstanceOf(ConflictException);
    await expect(setup({ answer: answerRow({ citations: [] }), question: q }).service.exportAnswer('a', 'pdf', OWNER)).rejects.toBeInstanceOf(ConflictException);
  });

  it('إجابة غير موجودة: 404', async () => {
    await expect(setup({}).service.exportAnswer('a', 'pdf', OWNER)).rejects.toBeInstanceOf(NotFoundException);
  });
});

describe('ExportsService — الحوكمة', () => {
  const row = { id: '99999999-1111-2222-3333-444444444444', userId: OWNER.userId, requestText: 'إجراء', createdAt: NOW, result: { verdict: 'متوافق', legal_basis: [], risk_note: 'ر' } };
  it('المالك فقط', async () => {
    const { service } = setup({ governance: row });
    await expect(service.exportGovernance('g', 'docx', OWNER)).resolves.toBeDefined();
    await expect(service.exportGovernance('g', 'docx', OTHER)).rejects.toBeInstanceOf(NotFoundException);
  });
  it('نتيجة تالفة: 409 لا انهيار', async () => {
    const { service } = setup({ governance: { ...row, result: { nothing: true } } });
    await expect(service.exportGovernance('g', 'docx', OWNER)).rejects.toBeInstanceOf(ConflictException);
  });
});

describe('ExportsService — تقرير العقد والاعتماد البشرى', () => {
  const contract = (over: Record<string, unknown> = {}) => ({
    id: '11111111-2222-3333-4444-555555555555', uploadedBy: OWNER.userId, originalFilename: 'عقد.pdf', status: 'processed', createdAt: NOW,
    reportApprovedAt: null, reportApprovalNote: null, ...over,
  });
  const clause = { clauseIndex: 1, clauseLabel: 'البند 1', clauseTitle: null, clauseText: 'نص', assessmentStatus: 'سليم', assessmentReasoning: null, matchedArticles: null, lawyerVerdict: null, lawyerNotes: null };

  afterEach(() => { delete process.env.CONTRACT_REPORT_REQUIRES_APPROVAL; });

  it('قبل الاعتماد: العميل 409، والمدير يحصل على مسودة بعلامة مائية فى الاسم', async () => {
    const { service } = setup({ contract: contract(), clauses: [clause] });
    await expect(service.exportContract('c', 'docx', OWNER)).rejects.toBeInstanceOf(ConflictException);
    const draft = await service.exportContract('c', 'docx', ADMIN);
    expect(draft.filename).toContain('-draft');
  });

  it('بعد الاعتماد: العميل يحصل على التقرير بلا علامة مسودة', async () => {
    const { service, audit } = setup({ contract: contract({ reportApprovedAt: NOW }), clauses: [clause] });
    const file = await service.exportContract('c', 'docx', OWNER);
    expect(file.filename).not.toContain('-draft');
    expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ metadata: expect.objectContaining({ approved: true }) }));
  });

  it('غير المالك 404 حتى بعد الاعتماد', async () => {
    const { service } = setup({ contract: contract({ reportApprovedAt: NOW }), clauses: [clause] });
    await expect(service.exportContract('c', 'docx', OTHER)).rejects.toBeInstanceOf(NotFoundException);
  });

  it('عقد لم تكتمل معالجته: 409', async () => {
    const { service } = setup({ contract: contract({ status: 'processing' }) });
    await expect(service.exportContract('c', 'docx', ADMIN)).rejects.toBeInstanceOf(ConflictException);
  });

  it('الاعتماد يُسجَّل ويحفظ المعتمِد، وإعادته idempotent بلا كتابة ثانية', async () => {
    const { service, update, audit } = setup({ contract: contract() });
    const first = await service.approveContractReport('c', ' ملاحظة ', ADMIN);
    expect(first.already_approved).toBe(false);
    expect(update).toHaveBeenCalledWith({ id: 'c' }, expect.objectContaining({ reportApprovedBy: ADMIN.userId, reportApprovalNote: 'ملاحظة' }));
    expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ action: 'contracts.report_approved' }));

    const again = setup({ contract: contract({ reportApprovedAt: NOW }) });
    const second = await again.service.approveContractReport('c', null, ADMIN);
    expect(second.already_approved).toBe(true);
    expect(again.update).not.toHaveBeenCalled();
  });

  it('لا يُعتمد تقرير عقد لم تكتمل معالجته', async () => {
    const { service } = setup({ contract: contract({ status: 'extraction_failed' }) });
    await expect(service.approveContractReport('c', null, ADMIN)).rejects.toBeInstanceOf(ConflictException);
  });

  it('CONTRACT_REPORT_REQUIRES_APPROVAL=false يرفع شرط الاعتماد (قرار منتج صريح)', async () => {
    process.env.CONTRACT_REPORT_REQUIRES_APPROVAL = 'false';
    const { service } = setup({ contract: contract(), clauses: [clause] });
    await expect(service.exportContract('c', 'docx', OWNER)).resolves.toBeDefined();
  });
});
