import { ForbiddenException, HttpException } from '@nestjs/common';
import { ContractsService } from './contracts.service';

/** قفل ما قبل السداد: findById يخفى التفاصيل لغير admin، والصياغة البديلة 402. بيانات مُصطنَعة. */
function build(contractOver: Record<string, unknown> = {}) {
  const NOW = new Date();
  const contract = {
    id: 'c1', uploadedBy: 'u1', status: 'processed', originalFilename: 'a.docx', createdAt: NOW, updatedAt: NOW, clauseCount: 1,
    contractType: 'عقد إيجار', clientRole: 'المستأجر', clientParty: 'second', contractFindings: null,
    clientApprovedAt: null, paymentStatus: 'unpaid', paidAt: null, ...contractOver,
  };
  const clause = {
    id: 'cl1', contractId: 'c1', clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseTypeGuess: null, clauseText: 'نص',
    assessmentStatus: 'يحتاج مراجعة', assessmentReasoning: 'تفسير', matchedArticles: [], assessmentConfidence: 0.7, ruleFindings: null, verification: null, suggestedWording: null,
  };
  const contractRepo = { findOne: jest.fn().mockResolvedValue(contract), save: jest.fn() };
  const clauseRepo = { find: jest.fn().mockResolvedValue([clause]), findOne: jest.fn().mockResolvedValue(clause), save: jest.fn() };
  const dataSource = { getRepository: jest.fn().mockImplementation((e: { name: string }) => (e.name === 'Contract' ? contractRepo : clauseRepo)) };
  const generation = { proposeClauseRedraft: jest.fn(), verifyRedraftProtectsClient: jest.fn() };
  const service = new ContractsService(
    dataSource as never, { record: jest.fn().mockResolvedValue(undefined) } as never, {} as never, {} as never, generation as never, {} as never, {} as never,
    { isConfigured: false } as never, { isConfigured: false, analyze: jest.fn() } as never, { isConfigured: false } as never,
  );
  return { service, generation };
}

const owner = { userId: 'u1', role: 'user' };

describe('findById — إخفاء التفاصيل قبل السداد', () => {
  it('المالك العادى قبل السداد: تفاصيل مخفية ونص بنده وحالته ظاهران', async () => {
    const { service } = build();
    const r = await service.findById('c1', owner);
    expect(r.details_locked).toBe(true);
    expect(r.clauses![0].assessment_reasoning).toBeNull();
    expect(r.clauses![0].clause_text).toBe('نص');
    expect(r.clauses![0].assessment_status).toBe('يحتاج مراجعة');
  });

  it('أعلن السداد لكن لم يؤكَّد بعد: ما زالت مخفية', async () => {
    const { service } = build({ clientApprovedAt: new Date(), paymentStatus: 'submitted' });
    expect((await service.findById('c1', owner)).details_locked).toBe(true);
  });

  it('بعد تأكيد السداد: كاملة بلا علامة قفل', async () => {
    const { service } = build({ clientApprovedAt: new Date(), paymentStatus: 'paid', paidAt: new Date() });
    const r = await service.findById('c1', owner);
    expect(r.details_locked).toBeUndefined();
    expect(r.clauses![0].assessment_reasoning).toBe('تفسير');
  });

  it('admin (المالك/المطوّر) يرى كل شىء بلا سداد، ولو لعقد عميل', async () => {
    const { service } = build();
    const r = await service.findById('c1', { userId: 'admin-1', role: 'admin' });
    expect(r.details_locked).toBeUndefined();
    expect(r.clauses![0].assessment_reasoning).toBe('تفسير');
  });

  it('مستخدم آخر 403 كما كان', async () => {
    const { service } = build();
    await expect(service.findById('c1', { userId: 'u2', role: 'user' })).rejects.toBeInstanceOf(ForbiddenException);
  });
});

describe('proposeRedraft — من مقابل الخدمة', () => {
  const ctx = { userId: 'u1', role: 'user', ipAddress: null, userAgent: null };

  it('قبل السداد: 402 ولا يُستدعى النموذج', async () => {
    const { service, generation } = build();
    const err = await service.proposeRedraft('c1', 'cl1', ctx).catch((e) => e);
    expect(err).toBeInstanceOf(HttpException);
    expect((err as HttpException).getStatus()).toBe(402);
    expect(generation.proposeClauseRedraft).not.toHaveBeenCalled();
  });
});
