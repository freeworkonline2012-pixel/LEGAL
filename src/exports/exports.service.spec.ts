import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
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
    reportApprovedAt: null, reportApprovalNote: null,
    // السداد مؤكَّد افتراضياً هنا: هذه الاختبارات تفحص الاعتماد البشرى؛ مراحل الموافقة والسداد فى describe مستقل أدناه
    clientApprovedAt: NOW, paymentStatus: 'paid', paidAt: NOW, paymentReference: null, serviceFeeMinor: 15000, ...over,
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

describe('ExportsService — طلب المراجعة: الموافقة والسداد والتسليم', () => {
  const unpaid = (over: Record<string, unknown> = {}) => ({
    id: '11111111-2222-3333-4444-555555555555', uploadedBy: OWNER.userId, originalFilename: 'عقد.docx', status: 'processed', createdAt: NOW,
    reportApprovedAt: null, reportApprovalNote: null,
    clientApprovedAt: null, paymentStatus: 'unpaid', paidAt: null, paymentReference: null, serviceFeeMinor: null, ...over,
  });
  const clause = { clauseIndex: 1, clauseLabel: 'البند 1', clauseTitle: null, clauseText: 'نص', assessmentStatus: 'سليم', assessmentReasoning: null, matchedArticles: null, lawyerVerdict: null, lawyerNotes: null };
  const status = (e: unknown) => (e as { getStatus?: () => number }).getStatus?.();

  beforeEach(() => { process.env.CONTRACT_REVIEW_FEE_EGP = '250'; process.env.CONTRACT_PAYMENT_INSTRUCTIONS = 'حوّل إلى المحفظة 0100'; });
  afterEach(() => { delete process.env.CONTRACT_REVIEW_FEE_EGP; delete process.env.CONTRACT_PAYMENT_INSTRUCTIONS; delete process.env.CONTRACT_REPORT_REQUIRES_APPROVAL; });

  describe('النسخة الأولية PDF', () => {
    it('المالك (admin) يحصل عليها قبل الموافقة والسداد والاعتماد، بعلامة «نسخة أولية» واسم -preliminary', async () => {
      const { service, pdf, audit } = setup({ contract: unpaid(), clauses: [clause] });
      const file = await service.exportContractPreliminary('c', ADMIN);
      expect(file.contentType).toBe('application/pdf');
      expect(file.filename).toMatch(/-client-preliminary\.pdf$/);
      expect(file.filename).not.toContain('-draft');
      const doc = pdf.render.mock.calls[0][0];
      expect(doc.watermark).toBe('نسخة أولية — غير نهائية');
      expect(doc.audit.watermark).toBe('نسخة أولية — غير نهائية');
      expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ metadata: expect.objectContaining({ preliminary: true }) }));
    });

    it('العميل العادى: 402 قبل السداد حتى لو وافق وأعلن السداد واعتُمد التقرير (لا ملفات قبل السداد)، ولا تدقيق تنزيل', async () => {
      for (const over of [{}, { clientApprovedAt: NOW }, { clientApprovedAt: NOW, paymentStatus: 'submitted', reportApprovedAt: NOW }]) {
        const { service, pdf, audit } = setup({ contract: unpaid(over), clauses: [clause] });
        await expect(service.exportContractPreliminary('c', OWNER)).rejects.toMatchObject({ status: 402 });
        expect(pdf.render).not.toHaveBeenCalled();
        expect(audit.record).not.toHaveBeenCalled();
      }
    });

    it('لا تحمل اعتماداً حتى لو اعتُمد التقرير؛ ولغير صاحب العقد 404؛ وقبل اكتمال المعالجة 409', async () => {
      const { service, pdf } = setup({ contract: unpaid({ reportApprovedAt: NOW }), clauses: [clause] });
      await service.exportContractPreliminary('c', ADMIN);
      expect(pdf.render.mock.calls[0][0].watermark).toBeTruthy();
      await expect(service.exportContractPreliminary('c', OTHER)).rejects.toBeInstanceOf(NotFoundException);
      const pending = setup({ contract: unpaid({ status: 'processing' }) });
      await expect(pending.service.exportContractPreliminary('c', ADMIN)).rejects.toBeInstanceOf(ConflictException);
    });
  });

  describe('التنزيل النهائى (Word/PDF/متتبَّع) مقفول حتى السداد المؤكَّد', () => {
    it('قبل الموافقة، بعدها، وبعد إعلان السداد: 402 بكل صيغة، برسالة المرحلة', async () => {
      const stages: Array<[Record<string, unknown>, RegExp]> = [
        [{}, /موافقتك على النسخة الأولية/],
        [{ clientApprovedAt: NOW }, /بعد سداد مقابل الخدمة/],
        [{ clientApprovedAt: NOW, paymentStatus: 'submitted' }, /بانتظار تأكيد السداد/],
      ];
      for (const [over, msg] of stages) {
        const { service, audit } = setup({ contract: unpaid({ reportApprovedAt: NOW, ...over }), clauses: [clause] });
        for (const run of [() => service.exportContract('c', 'docx', OWNER), () => service.exportContract('c', 'pdf', OWNER, 'client'), () => service.exportContractTracked('c', OWNER)]) {
          const err = await run().catch((e) => e);
          expect(status(err)).toBe(402);
          expect(String((err as Error).message)).toMatch(msg);
        }
        expect(audit.record).not.toHaveBeenCalled();
      }
    });

    it('بعد السداد المؤكَّد لكن قبل الاعتماد البشرى: 409 «قيد المراجعة»، وبعد الاعتماد: ملف', async () => {
      const paid = { clientApprovedAt: NOW, paymentStatus: 'paid', paidAt: NOW };
      const before = setup({ contract: unpaid(paid), clauses: [clause] });
      await expect(before.service.exportContract('c', 'docx', OWNER)).rejects.toBeInstanceOf(ConflictException);
      await expect(before.service.exportContract('c', 'docx', OWNER)).rejects.toThrow('قيد المراجعة البشرية');
      const after = setup({ contract: unpaid({ ...paid, reportApprovedAt: NOW }), clauses: [clause] });
      expect((await after.service.exportContract('c', 'docx', OWNER)).filename).toMatch(/\.docx$/);
      expect((await after.service.exportContract('c', 'pdf', OWNER, 'client')).contentType).toBe('application/pdf');
      expect((await after.service.exportContractTracked('c', OWNER)).contentType).toContain('wordprocessingml');
    });

    it('admin (المالك) بلا سداد ولا موافقة ولا اعتماد، ولو على عقد عميل', async () => {
      const { service } = setup({ contract: unpaid(), clauses: [clause] });
      expect((await service.exportContract('c', 'docx', ADMIN)).filename).toContain('-draft');
      await expect(service.exportContractTracked('c', ADMIN)).resolves.toBeDefined();
    });

    it('CONTRACT_REPORT_REQUIRES_APPROVAL=false: السداد وحده يكفى، ولا يرفع قفل السداد', async () => {
      process.env.CONTRACT_REPORT_REQUIRES_APPROVAL = 'false';
      const paid = setup({ contract: unpaid({ clientApprovedAt: NOW, paymentStatus: 'paid', paidAt: NOW }), clauses: [clause] });
      await expect(paid.service.exportContract('c', 'docx', OWNER)).resolves.toBeDefined();
      const notPaid = setup({ contract: unpaid(), clauses: [clause] });
      expect(status(await notPaid.service.exportContract('c', 'docx', OWNER).catch((e) => e))).toBe(402);
    });
  });

  describe('مراحل الطلب', () => {
    it('عرض المرحلة: السعر والتعليمات والمتاح، وlocked قبل السداد', async () => {
      const { service } = setup({ contract: unpaid() });
      const v = await service.getContractOrder('c', OWNER);
      expect(v).toMatchObject({ stage: 'preview', free_access: false, fee_amount: 250, fee_currency: 'EGP', payment_instructions: 'حوّل إلى المحفظة 0100', can_download_preliminary: false, can_download_final: false, details_locked: true, awaiting_human_review: false });
    });

    it('غير المالك 404 على كل عمليات الطلب', async () => {
      const { service } = setup({ contract: unpaid({ clientApprovedAt: NOW }) });
      await expect(service.getContractOrder('c', OTHER)).rejects.toBeInstanceOf(NotFoundException);
      await expect(service.approveContractOrder('c', OTHER)).rejects.toBeInstanceOf(NotFoundException);
      await expect(service.submitContractPayment('c', 'TX12345', OTHER)).rejects.toBeInstanceOf(NotFoundException);
    });

    it('الموافقة: تثبّت السعر وقت الموافقة وتُسجَّل، وإعادتها idempotent بلا كتابة', async () => {
      const { service, update, audit } = setup({ contract: unpaid() });
      const v = await service.approveContractOrder('c', OWNER);
      expect(update).toHaveBeenCalledWith({ id: 'c' }, expect.objectContaining({ serviceFeeMinor: 25000, serviceFeeCurrency: 'EGP' }));
      expect(v.stage).toBe('approved');
      expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ action: 'contracts.order_approved' }));
      const again = setup({ contract: unpaid({ clientApprovedAt: NOW, serviceFeeMinor: 25000 }) });
      expect((await again.service.approveContractOrder('c', OWNER)).stage).toBe('approved');
      expect(again.update).not.toHaveBeenCalled();
    });

    it('الموافقة بلا سعر مضبوط: 409 ولا مجانية صامتة؛ وقبل اكتمال المعالجة 409', async () => {
      delete process.env.CONTRACT_REVIEW_FEE_EGP;
      const { service, update } = setup({ contract: unpaid() });
      await expect(service.approveContractOrder('c', OWNER)).rejects.toThrow('لم يُحدَّد سعر الخدمة');
      expect(update).not.toHaveBeenCalled();
      process.env.CONTRACT_REVIEW_FEE_EGP = '250';
      const pending = setup({ contract: unpaid({ status: 'processing' }) });
      await expect(pending.service.approveContractOrder('c', OWNER)).rejects.toBeInstanceOf(ConflictException);
    });

    it('السعر المثبَّت وقت الموافقة لا يتغير بتغيير المتغير لاحقاً', async () => {
      process.env.CONTRACT_REVIEW_FEE_EGP = '999';
      const { service } = setup({ contract: unpaid({ clientApprovedAt: NOW, serviceFeeMinor: 25000 }) });
      expect((await service.getContractOrder('c', OWNER)).fee_amount).toBe(250);
    });

    it('إعلان السداد: بعد الموافقة فقط، بمرجع صالح، ويُسجَّل بلا نص المرجع', async () => {
      const early = setup({ contract: unpaid() });
      await expect(early.service.submitContractPayment('c', 'TX12345', OWNER)).rejects.toBeInstanceOf(ConflictException);
      const { service, update, audit } = setup({ contract: unpaid({ clientApprovedAt: NOW, serviceFeeMinor: 25000 }) });
      await expect(service.submitContractPayment('c', 'ab', OWNER)).rejects.toBeInstanceOf(BadRequestException);
      await expect(service.submitContractPayment('c', undefined, OWNER)).rejects.toBeInstanceOf(BadRequestException);
      const v = await service.submitContractPayment('c', '  TX 998877  ', OWNER);
      expect(update).toHaveBeenCalledWith({ id: 'c' }, expect.objectContaining({ paymentStatus: 'submitted', paymentReference: 'TX 998877' }));
      expect(v).toMatchObject({ stage: 'payment_submitted', can_download_final: false, details_locked: true });
      const call = audit.record.mock.calls.find((c: unknown[]) => (c[0] as { action: string }).action === 'contracts.payment_submitted');
      expect(JSON.stringify(call)).not.toContain('998877');
    });

    it('العميل لا يستطيع تأكيد سداد نفسه: التأكيد admin فقط (يُفرَض بالمتحكم) والخدمة تؤكّد بعد الإعلان أو الموافقة', async () => {
      const { service, update, audit } = setup({ contract: unpaid({ clientApprovedAt: NOW, paymentStatus: 'submitted', serviceFeeMinor: 25000 }) });
      const v = await service.confirmContractPayment('c', ADMIN);
      expect(update).toHaveBeenCalledWith({ id: 'c' }, expect.objectContaining({ paymentStatus: 'paid', paidConfirmedBy: ADMIN.userId }));
      expect(v.stage).toBe('paid');
      expect(audit.record).toHaveBeenCalledWith(expect.objectContaining({ action: 'contracts.payment_confirmed', actorId: ADMIN.userId }));
    });

    it('التأكيد: لا قبل موافقة العميل، وidempotent بعد السداد، وعقد غير موجود 404', async () => {
      const early = setup({ contract: unpaid() });
      await expect(early.service.confirmContractPayment('c', ADMIN)).rejects.toBeInstanceOf(ConflictException);
      const paid = setup({ contract: unpaid({ clientApprovedAt: NOW, paymentStatus: 'paid', paidAt: NOW }) });
      await paid.service.confirmContractPayment('c', ADMIN);
      expect(paid.update).not.toHaveBeenCalled();
      await expect(setup({}).service.confirmContractPayment('c', ADMIN)).rejects.toBeInstanceOf(NotFoundException);
    });

    it('بعد التأكيد: تُفتح التفاصيل، والنهائى ينتظر الاعتماد البشرى ثم يُتاح', async () => {
      const paid = { clientApprovedAt: NOW, paymentStatus: 'paid', paidAt: NOW };
      const waiting = await setup({ contract: unpaid(paid) }).service.getContractOrder('c', OWNER);
      expect(waiting).toMatchObject({ stage: 'paid', details_locked: false, awaiting_human_review: true, can_download_final: false, payment_instructions: null });
      const ready = await setup({ contract: unpaid({ ...paid, reportApprovedAt: NOW }) }).service.getContractOrder('c', OWNER);
      expect(ready).toMatchObject({ awaiting_human_review: false, can_download_final: true });
    });

    it('admin بلا مراحل: لا تغيير بالموافقة ولا بالإعلان، ويرى free_access والتنزيل متاحاً', async () => {
      const { service, update } = setup({ contract: unpaid() });
      expect(await service.approveContractOrder('c', ADMIN)).toMatchObject({ free_access: true, can_download_final: true, details_locked: false });
      await service.submitContractPayment('c', 'x', ADMIN);
      expect(update).not.toHaveBeenCalled();
    });

    it('قائمة الانتظار: طلبات الإعلان بمعرّف واسم ملف ومرجع وقيمة', async () => {
      const rows = [unpaid({ id: 'c1', clientApprovedAt: NOW, paymentStatus: 'submitted', paymentReference: 'TX1', paymentSubmittedAt: NOW, serviceFeeMinor: 25000 })];
      const find = jest.fn().mockResolvedValue(rows);
      const dataSource = { getRepository: () => ({ find }) };
      const service = new ExportsService(dataSource as never, { record: jest.fn() } as never, {} as never);
      const list = await service.listPendingPayments();
      expect(find).toHaveBeenCalledWith(expect.objectContaining({ where: { paymentStatus: 'submitted' }, take: 100 }));
      expect(list).toEqual([{ contract_id: 'c1', original_filename: 'عقد.docx', fee_amount: 250, fee_currency: 'EGP', payment_reference: 'TX1', submitted_at: NOW.toISOString() }]);
    });
  });
});
