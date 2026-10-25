import { ConflictException, NotFoundException } from '@nestjs/common';
import { Answer } from '../database/entities/answer.entity';
import { Contract } from '../database/entities/contract.entity';
import { ContractClause } from '../database/entities/contract-clause.entity';
import { GovernanceAssessment } from '../database/entities/governance-assessment.entity';
import { LegalMemo } from '../database/entities/legal-memo.entity';
import { Question } from '../database/entities/question.entity';
import { ExportsService, type ExportActor } from './exports.service';

const OWNER: ExportActor = { userId: 'u-owner', role: 'user', ipAddress: '1.1.1.1', userAgent: 'jest' };
const OTHER: ExportActor = { userId: 'u-other', role: 'user', ipAddress: null, userAgent: null };
const ADMIN: ExportActor = { userId: 'u-admin', role: 'admin', ipAddress: null, userAgent: null };
const NOW = new Date('2026-10-15T09:00:00Z');

function setup(rows: { answer?: unknown; question?: unknown; governance?: unknown; contract?: unknown; clauses?: unknown[]; memo?: unknown }) {
  const update = jest.fn().mockResolvedValue(undefined);
  const repos = new Map<unknown, unknown>([
    [Answer, { findOne: jest.fn().mockResolvedValue(rows.answer ?? null) }],
    [Question, { findOne: jest.fn().mockResolvedValue(rows.question ?? null) }],
    [GovernanceAssessment, { findOne: jest.fn().mockResolvedValue(rows.governance ?? null) }],
    [LegalMemo, { findOne: jest.fn().mockResolvedValue(rows.memo ?? null) }],
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

  describe('نسخة Word بتعديلات متتبَّعة (الجولة 6)', () => {
    const redraftClause = {
      ...clause,
      clauseText: 'يجوز فسخ العقد دون إنذار.',
      assessmentStatus: 'يحتاج مراجعة',
      riskLevel: 'عالٍ',
      assessmentReasoning: 'مشكلة.',
      suggestedWording: JSON.stringify({ text: 'يجوز فسخ العقد دون إنذار أو حكم قضائى.', changes: ['أُضيف.'] }),
      verification: null,
    };

    it('نفس شروط التقرير: قبل الاعتماد العميل 409 والمدير مسودة، وبعده العميل يحصل عليها', async () => {
      const before = setup({ contract: contract(), clauses: [redraftClause] });
      await expect(before.service.exportContractTracked('c', OWNER)).rejects.toBeInstanceOf(ConflictException);
      const draft = await before.service.exportContractTracked('c', ADMIN);
      expect(draft.filename).toMatch(/-tracked-draft\.docx$/);
      const after = setup({ contract: contract({ reportApprovedAt: NOW }), clauses: [redraftClause] });
      const file = await after.service.exportContractTracked('c', OWNER);
      expect(file.filename).toMatch(/^contract-[0-9a-f]{8}-\d{8}-tracked\.docx$/);
      expect(file.contentType).toContain('wordprocessingml');
      expect(file.buffer.subarray(0, 2).toString()).toBe('PK');
    });

    it('غير المالك 404 ولا ملف ولا تدقيق، وعقد لم يكتمل 409', async () => {
      const { service, audit } = setup({ contract: contract({ reportApprovedAt: NOW }), clauses: [redraftClause] });
      await expect(service.exportContractTracked('c', OTHER)).rejects.toBeInstanceOf(NotFoundException);
      expect(audit.record).not.toHaveBeenCalled();
      const pending = setup({ contract: contract({ status: 'processing' }) });
      await expect(pending.service.exportContractTracked('c', ADMIN)).rejects.toBeInstanceOf(ConflictException);
    });

    it('التنزيل يُسجَّل بنوعه وبعدد التعديلات', async () => {
      const { service, audit } = setup({ contract: contract({ reportApprovedAt: NOW }), clauses: [redraftClause] });
      await service.exportContractTracked('c', OWNER);
      expect(audit.record).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'export.downloaded',
          resourceType: 'contract',
          metadata: expect.objectContaining({ kind: 'contract_tracked', format: 'docx', trackedClauses: 1, approved: true }),
        }),
      );
    });
  });
});

const memoRow = (over: Record<string, unknown> = {}) => ({
  id: 'bbbbbbbb-1111-2222-3333-444444444444',
  userId: OWNER.userId,
  answerId: 'aaaaaaaa-1111-2222-3333-444444444444',
  memoType: 'defense_memo',
  partyRole: 'claimant',
  title: 'مذكرة',
  issue: 'مسألة قانونية للبحث',
  facts: 'وقائع مفصلة بما يكفى للمذكرة',
  requests: { items: ['طلب أول'] },
  createdAt: NOW,
  ...over,
});

describe('ExportsService — المذكرات والتقارير', () => {
  it('المالك يحصل على PDF ويُسجَّل التنزيل بنوع المذكرة', async () => {
    const { service, audit, pdf } = setup({ memo: memoRow(), answer: answerRow() });
    const file = await service.exportMemo('m', 'pdf', OWNER);
    expect(file.filename).toMatch(/^memo-bbbbbbbb-\d{8}\.pdf$/);
    expect(pdf.render).toHaveBeenCalledTimes(1);
    expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ resourceType: 'legal_memo', metadata: expect.objectContaining({ kind: 'memo', memoType: 'defense_memo' }) }));
  });

  it('المستند مسودة بعلامة مائية دائماً حتى للمالك', async () => {
    const { service, pdf } = setup({ memo: memoRow(), answer: answerRow() });
    await service.exportMemo('m', 'pdf', OWNER);
    expect((pdf.render.mock.calls[0][0] as { watermark: string }).watermark).toContain('مسودة');
  });

  it('غير المالك 404، وadmin مسموح', async () => {
    const a = setup({ memo: memoRow(), answer: answerRow() });
    await expect(a.service.exportMemo('m', 'pdf', OTHER)).rejects.toThrow(NotFoundException);
    const b = setup({ memo: memoRow(), answer: answerRow() });
    await expect(b.service.exportMemo('m', 'docx', ADMIN)).resolves.toBeDefined();
  });

  it('مذكرة غير موجودة 404، وإجابة مصدرها محذوفة أو مرفوضة 409', async () => {
    await expect(setup({}).service.exportMemo('m', 'pdf', OWNER)).rejects.toThrow(NotFoundException);
    await expect(setup({ memo: memoRow(), answer: null }).service.exportMemo('m', 'pdf', OWNER)).rejects.toThrow(ConflictException);
    await expect(setup({ memo: memoRow(), answer: answerRow({ refused: true }) }).service.exportMemo('m', 'pdf', OWNER)).rejects.toThrow(ConflictException);
  });

  it('طلبات تالفة فى الصف لا تكسر البناء', async () => {
    const { service } = setup({ memo: memoRow({ requests: { items: 'ليست مصفوفة' } }), answer: answerRow() });
    await expect(service.exportMemo('m', 'docx', OWNER)).resolves.toBeDefined();
  });
});
