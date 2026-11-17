import { assessNeedsExtra, resolveAssessmentVotes, type AssessSample } from './assess-vote';
import { ContractsService } from './contracts.service';

const NO_TEXT = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
type OkS = Extract<AssessSample, { status: 'ok' }>;
const ok = (assessment: string, over: Partial<OkS> = {}): AssessSample => ({
  status: 'ok',
  assessment,
  selectedIndices: [],
  reasoning: 'شرح',
  confidence: 0.6,
  violationType: 'none',
  mandatoryQuote: '',
  ...over,
});
const sound = (over: Partial<OkS> = {}) => ok('سليم', over);
const review = (over: Partial<OkS> = {}) => ok('يحتاج مراجعة', over);
const noText = () => ok(NO_TEXT);
const picked = (o: AssessSample) => (o.status === 'ok' ? o.selectedIndices : null);

describe('الجولة 108: تصويت على المواد', () => {
  it('المادة التى أجمعت عليها العيّنات تتقدم على مادة انفردت بها عيّنة أعلى ثقة', () => {
    const r = resolveAssessmentVotes(
      [sound({ selectedIndices: [0], confidence: 0.9 }), sound({ selectedIndices: [1], confidence: 0.6 }), sound({ selectedIndices: [1], confidence: 0.6 })],
      3,
    );
    expect(picked(r.outcome)).toEqual([1]);
  });

  it('الدعم متوسط أصوات مواد العيّنة: من اختارت 3 مواد منفردة لا تتقدم على من وافقتها الأغلبية', () => {
    const r = resolveAssessmentVotes(
      [
        sound({ selectedIndices: [0, 1, 2], confidence: 0.9 }),
        sound({ selectedIndices: [2], confidence: 0.6 }),
        sound({ selectedIndices: [2], confidence: 0.6 }),
      ],
      3,
    );
    expect(picked(r.outcome)).toEqual([2]);
  });

  it('تعادل الدعم: الأعلى ثقة ثم الأسبق (كالسابق)', () => {
    const r = resolveAssessmentVotes([sound({ selectedIndices: [0], confidence: 0.6 }), sound({ selectedIndices: [1], confidence: 0.8 }), sound({ selectedIndices: [2], confidence: 0.8 })], 3);
    expect(picked(r.outcome)).toEqual([1]);
  });

  it('لا تغيّر الحالة الفائزة ولا العدّ: التصويت على المواد داخل العيّنات الفائزة فقط', () => {
    const r = resolveAssessmentVotes(
      [review({ selectedIndices: [0] }), review({ selectedIndices: [0] }), sound({ selectedIndices: [1] }), sound({ selectedIndices: [1] }), sound({ selectedIndices: [1] })],
      2,
    );
    expect(r.decision).toBe('sound');
    expect(r.tally).toEqual({ review: 2, sound: 3, noText: 0, errors: 0 });
    expect(picked(r.outcome)).toEqual([1]);
  });

  it('لا عيّنة مغطّاة أو عدد مرشحات مجهول: السلوك السابق (الأعلى ثقة)', () => {
    const a = resolveAssessmentVotes([sound({ confidence: 0.5 }), sound({ confidence: 0.9 }), sound({ confidence: 0.7 })], 3);
    expect(a.outcome.status === 'ok' && a.outcome.confidence).toBe(0.9);
    const b = resolveAssessmentVotes([sound({ selectedIndices: [0], confidence: 0.5 }), sound({ confidence: 0.9 })]);
    expect(b.outcome.status === 'ok' && b.outcome.confidence).toBe(0.9);
  });
});

describe('الجولة 108: عيّنتان إضافيتان لإجماع بلا مادة صالحة', () => {
  it('إجماع «سليم» بلا مادة مع وجود مرشحات ⇒ تُسحب الإضافيتان', () => {
    expect(assessNeedsExtra([sound(), sound(), sound()], 4)).toBe(true);
    expect(assessNeedsExtra([review(), review(), review()], 4)).toBe(true);
  });
  it('فهارس خارج المرشحات لا تُعدّ مادة صالحة ⇒ تُسحب الإضافيتان', () => {
    expect(assessNeedsExtra([sound({ selectedIndices: [9] }), sound({ selectedIndices: [-1] }), sound()], 4)).toBe(true);
  });
  it('إن اختارت عيّنة واحدة مادة صالحة فلا حاجة لإضافيتين', () => {
    expect(assessNeedsExtra([sound(), sound({ selectedIndices: [1] }), sound()], 4)).toBe(false);
  });
  it('إجماع «لا يوجد نص» أو بلا مرشحات أو عيّنة واحدة سليمة: لا إضافيتان', () => {
    expect(assessNeedsExtra([noText(), noText(), noText()], 4)).toBe(false);
    expect(assessNeedsExtra([sound(), sound(), sound()], 0)).toBe(false);
    expect(assessNeedsExtra([sound(), { status: 'error', detail: 'x' }, { status: 'error', detail: 'x' }], 4)).toBe(false);
  });
  it('الانقسام بين الأحكام يستدعيهما كالسابق (105.5)', () => {
    expect(assessNeedsExtra([sound({ selectedIndices: [0] }), review({ selectedIndices: [0] }), sound({ selectedIndices: [0] })], 4)).toBe(true);
  });
});

describe('الجولة 108: عبر الخدمة assessWithVote', () => {
  const make = (results: AssessSample[]) => {
    let n = 0;
    const service = Object.create(ContractsService.prototype) as unknown as {
      generationService: { assessClause: jest.Mock };
      logger: { log: jest.Mock; warn: jest.Mock };
      assessWithVote(req: unknown, clauseIndex: number): Promise<AssessSample>;
    };
    service.generationService = { assessClause: jest.fn(async () => results[n++ % results.length]) };
    service.logger = { log: jest.fn(), warn: jest.fn() };
    return service;
  };
  const OLD = process.env.CONTRACT_ASSESS_SAMPLES;
  const OLDX = process.env.CONTRACT_ASSESS_EXTRA_SAMPLES;
  beforeEach(() => {
    delete process.env.CONTRACT_ASSESS_SAMPLES;
    delete process.env.CONTRACT_ASSESS_EXTRA_SAMPLES;
  });
  afterEach(() => {
    if (OLD === undefined) delete process.env.CONTRACT_ASSESS_SAMPLES;
    else process.env.CONTRACT_ASSESS_SAMPLES = OLD;
    if (OLDX === undefined) delete process.env.CONTRACT_ASSESS_EXTRA_SAMPLES;
    else process.env.CONTRACT_ASSESS_EXTRA_SAMPLES = OLDX;
  });

  it('3 عيّنات «سليم» بلا مادة ثم الإضافيتان: إحداهما بمادة ⇒ البند مغطّى', async () => {
    const s = make([sound(), sound(), sound(), sound({ selectedIndices: [1], confidence: 0.55 }), sound()]);
    const out = await s.assessWithVote({ clauseText: 'نص', candidates: [{}, {}, {}] }, 8);
    expect(s.generationService.assessClause).toHaveBeenCalledTimes(5);
    expect(picked(out)).toEqual([1]);
    expect(s.logger.log.mock.calls[0][0]).toBe('assess vote clauseIndex=8 samples=5 extra=2 review=0 sound=5 noText=0 errors=0 decision=sound');
  });

  it('إجماع «لا يوجد نص» لا يكلّف نداءً إضافياً', async () => {
    const s = make([noText(), noText(), noText()]);
    await s.assessWithVote({ clauseText: 'نص', candidates: [{}, {}] }, 1);
    expect(s.generationService.assessClause).toHaveBeenCalledTimes(3);
  });

  it('بلا مرشحات (candidates فارغة) لا إضافيتان حتى لو «سليم» بلا مادة', async () => {
    const s = make([sound(), sound(), sound()]);
    await s.assessWithVote({ clauseText: 'نص', candidates: [] }, 1);
    expect(s.generationService.assessClause).toHaveBeenCalledTimes(3);
  });

  it('CONTRACT_ASSESS_EXTRA_SAMPLES=0 يعطّل الإضافيتين أيضاً لهذه الحالة', async () => {
    process.env.CONTRACT_ASSESS_EXTRA_SAMPLES = '0';
    const s = make([sound(), sound(), sound()]);
    await s.assessWithVote({ clauseText: 'نص', candidates: [{}, {}] }, 1);
    expect(s.generationService.assessClause).toHaveBeenCalledTimes(3);
  });
});
