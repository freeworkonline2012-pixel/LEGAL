import { BadRequestException, ForbiddenException, UnprocessableEntityException } from '@nestjs/common';
import { ContractsService } from './contracts.service';
import { parseRedraftJson } from '../llm/deepseek-generation.service';

const ORIGINAL = 'يلتزم المستأجر بسداد غرامة تأخير قدرها 5% عن كل يوم تأخير، ولا يجوز تخفيضها بأى حال.';
const MATCHED = [
  {
    law: 'القانون المدنى 131/1948',
    law_no: 131,
    law_year: 1948,
    article_no: 224,
    snippet: '(2) ويجوز للقاضى أن يخفض هذا التعويض إذا أثبت المدين أن التقدير كان مبالغا فيه.\n(3) ويقع باطلا كل اتفاق يخالف أحكام الفقرتين السابقتين.',
    official_url: null,
  },
];

function build(clauseOverrides: Record<string, unknown> = {}, outcome?: unknown) {
  const contract = { id: 'c1', uploadedBy: 'u1', contractType: 'عقد إيجار', clientRole: 'المستأجر' };
  const clause: Record<string, unknown> = {
    id: 'cl1',
    contractId: 'c1',
    clauseIndex: 7,
    clauseLabel: 'البند السابع',
    clauseTitle: null,
    clauseTypeGuess: 'compensation',
    clauseText: ORIGINAL,
    assessmentStatus: 'يحتاج مراجعة',
    assessmentReasoning: 'البند يمنع تخفيض التعويض الاتفاقى.',
    matchedArticles: MATCHED,
    assessmentConfidence: 0.8,
    suggestedWording: null,
    ...clauseOverrides,
  };
  const contractRepo = { findOne: jest.fn().mockResolvedValue(contract) };
  const clauseRepo = { findOne: jest.fn().mockResolvedValue(clause), save: jest.fn().mockImplementation(async (c) => c) };
  const dataSource = {
    getRepository: jest.fn().mockImplementation((e: { name: string }) =>
      e.name === 'Contract' ? contractRepo : e.name === 'ContractClause' ? clauseRepo : {},
    ),
  };
  const generation = { proposeClauseRedraft: jest.fn().mockResolvedValue(outcome) };
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const service = new ContractsService(
    dataSource as never,
    audit as never,
    {} as never,
    {} as never,
    generation as never,
    {} as never,
  );
  return { service, generation, clauseRepo, clause };
}

const ctx = { userId: 'u1', role: 'user', ipAddress: null, userAgent: null };

describe('ContractsService.proposeRedraft', () => {
  it('يرفض مستخدماً غير مالك العقد', async () => {
    const { service } = build();
    await expect(service.proposeRedraft('c1', 'cl1', { ...ctx, userId: 'other' })).rejects.toBeInstanceOf(
      ForbiddenException,
    );
  });

  it('يمرّر مركز العميل المخزَّن مع العقد إلى النموذج', async () => {
    const { service, generation } = build(
      {},
      { status: 'ok', canResolve: true, needsChange: false, noChangeReason: 'جائز', proposedText: '', changes: [] },
    );
    await service.proposeRedraft('c1', 'cl1', ctx);
    expect(generation.proposeClauseRedraft).toHaveBeenCalledWith(
      expect.objectContaining({ clientPosition: 'المستأجر (فى عقد إيجار)' }),
    );
  });

  it('يرفض بنداً ليس "يحتاج مراجعة"', async () => {
    const { service, generation } = build({ assessmentStatus: 'سليم' });
    await expect(service.proposeRedraft('c1', 'cl1', ctx)).rejects.toBeInstanceOf(BadRequestException);
    expect(generation.proposeClauseRedraft).not.toHaveBeenCalled();
  });

  it('يرفض بنداً بلا مواد معتمدة', async () => {
    const { service, generation } = build({ matchedArticles: [] });
    await expect(service.proposeRedraft('c1', 'cl1', ctx)).rejects.toBeInstanceOf(BadRequestException);
    expect(generation.proposeClauseRedraft).not.toHaveBeenCalled();
  });

  it('يخزّن ويعيد صياغة سليمة مع التنويه', async () => {
    const { service, clauseRepo } = build(
      {},
      {
        status: 'ok',
        canResolve: true,
        needsChange: true,
        proposedText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 5% عن كل يوم تأخير، مع بقاء حق القاضى فى تخفيضها إذا كان التقدير مبالغاً فيه.',
        changes: ['إزالة منع التخفيض بسبب المادة 224'],
      },
    );
    const dto = await service.proposeRedraft('c1', 'cl1', ctx);
    expect(dto.suggested_redraft?.text).toContain('تخفيضها');
    expect(dto.suggested_redraft?.disclaimer).toContain('تُراجَع من محامٍ');
    expect(clauseRepo.save).toHaveBeenCalled();
  });

  it('يرفض صياغة فيها رقم مخترع ولا يخزّنها', async () => {
    const { service, clauseRepo } = build(
      {},
      {
        status: 'ok',
        canResolve: true,
        needsChange: true,
        proposedText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 2% عن كل يوم تأخير مع جواز تخفيضها قضاءً عند المبالغة.',
        changes: [],
      },
    );
    await expect(service.proposeRedraft('c1', 'cl1', ctx)).rejects.toBeInstanceOf(UnprocessableEntityException);
    expect(clauseRepo.save).not.toHaveBeenCalled();
  });

  it('يرفض عند can_resolve=false', async () => {
    const { service } = build({}, { status: 'ok', canResolve: false, proposedText: '', changes: [] });
    await expect(service.proposeRedraft('c1', 'cl1', ctx)).rejects.toBeInstanceOf(UnprocessableEntityException);
  });

  it('يخزّن ويعيد "لا يتطلب تعديلاً" مع السبب ويحذف المواد غير المعتمدة منه', async () => {
    const { service, clauseRepo } = build(
      {},
      {
        status: 'ok',
        canResolve: true,
        needsChange: false,
        noChangeReason: 'الاتفاق على خلاف قاعدة مكملة جائز. المادة 999 لا تتصل بالبند.',
        proposedText: '',
        changes: [],
      },
    );
    const dto = await service.proposeRedraft('c1', 'cl1', ctx);
    expect(dto.suggested_redraft?.no_change).toBe(true);
    expect(dto.suggested_redraft?.note).toBe('الاتفاق على خلاف قاعدة مكملة جائز.');
    expect(dto.suggested_redraft?.text).toBe('');
    expect(clauseRepo.save).toHaveBeenCalled();
  });

  it('يعيد المخزَّن دون استدعاء النموذج مرة ثانية', async () => {
    const stored = JSON.stringify({ text: 'صياغة مخزنة سابقاً بعد اجتياز الفحوص بنجاح.', changes: ['تعديل'] });
    const { service, generation } = build({ suggestedWording: stored });
    const dto = await service.proposeRedraft('c1', 'cl1', ctx);
    expect(dto.suggested_redraft?.text).toContain('مخزنة');
    expect(generation.proposeClauseRedraft).not.toHaveBeenCalled();
  });
});

describe('parseRedraftJson', () => {
  it('يحلل JSON سليماً', () => {
    expect(parseRedraftJson('{"proposed_text":"نص","changes":["أ"],"can_resolve":true}')).toEqual({
      proposedText: 'نص',
      changes: ['أ'],
      canResolve: true,
      needsChange: true,
      noChangeReason: '',
    });
  });
  it('يستخرج JSON من نص محيط', () => {
    expect(parseRedraftJson('هذا: {"proposed_text":"نص","can_resolve":false} انتهى')?.canResolve).toBe(false);
  });
  it('يقرأ needs_change=false مع السبب', () => {
    expect(
      parseRedraftJson('{"needs_change": false, "no_change_reason": "جائز", "proposed_text": "", "changes": []}'),
    ).toEqual({ proposedText: '', changes: [], canResolve: true, needsChange: false, noChangeReason: 'جائز' });
  });
  it('يعيد null لغير الصالح', () => {
    expect(parseRedraftJson('لا json')).toBeNull();
  });

  it('عند رفض الفحص الآلى يعيد المحاولة مرة واحدة بسبب الرفض، ويقبل الناتج الثانى إن اجتاز الفحص', async () => {
    const bad = {
      status: 'ok', canResolve: true, needsChange: true, noChangeReason: '', changes: ['خُفضت الغرامة.'],
      proposedText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 9% عن كل يوم تأخير، ولا يجوز تخفيضها بأى حال.',
    };
    const good = {
      status: 'ok', canResolve: true, needsChange: true, noChangeReason: '',
      changes: ['أُجيز للقاضى تخفيض التعويض المبالغ فيه وفق المادة 224.'],
      proposedText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 5% عن كل يوم تأخير، ويجوز للقاضى تخفيضها إن ثبت أن التقدير مبالغ فيه.',
    };
    const { service, generation, clause } = build({}, bad);
    generation.proposeClauseRedraft.mockResolvedValueOnce(bad).mockResolvedValueOnce(good);
    const dto = await service.proposeRedraft('c1', 'cl1', ctx);
    expect(generation.proposeClauseRedraft).toHaveBeenCalledTimes(2);
    expect(generation.proposeClauseRedraft.mock.calls[0][0].retryFeedback).toBeUndefined();
    expect(generation.proposeClauseRedraft.mock.calls[1][0].retryFeedback).toContain('رقماً');
    expect(dto.suggested_redraft).toBeTruthy();
    expect(String(clause.suggestedWording)).toContain('يجوز للقاضى');
  });

  it('إن رُفضت المحاولتان لا تُعرض صياغة ولا تتجاوز المحاولات اثنتين', async () => {
    const bad = {
      status: 'ok', canResolve: true, needsChange: true, noChangeReason: '', changes: ['x'],
      proposedText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 9% عن كل يوم تأخير، ولا يجوز تخفيضها بأى حال.',
    };
    const { service, generation, clause } = build({}, bad);
    await expect(service.proposeRedraft('c1', 'cl1', ctx)).rejects.toBeInstanceOf(UnprocessableEntityException);
    expect(generation.proposeClauseRedraft).toHaveBeenCalledTimes(2);
    expect(clause.suggestedWording).toBeNull();
  });
});
