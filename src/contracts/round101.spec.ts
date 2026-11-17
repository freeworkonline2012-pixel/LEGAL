import { assessSampleCount, resolveAssessmentVotes, type AssessSample } from './assess-vote';
import { ContractsService } from './contracts.service';

const NO_TEXT = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
const ok = (assessment: string, over: Partial<Extract<AssessSample, { status: 'ok' }>> = {}): AssessSample => ({
  status: 'ok',
  assessment,
  selectedIndices: [0],
  reasoning: 'شرح',
  confidence: 0.6,
  violationType: 'none',
  mandatoryQuote: '',
  ...over,
});
const review = (over: Partial<Extract<AssessSample, { status: 'ok' }>> = {}) => ok('يحتاج مراجعة', over);
const sound = (over: Partial<Extract<AssessSample, { status: 'ok' }>> = {}) => ok('سليم', over);
const err = (): AssessSample => ({ status: 'error', detail: 'http_500' });
const label = (o: AssessSample) => (o.status === 'ok' ? o.assessment : o.status);

describe('الجولة 101: تصويت أغلبية على عيّنات التقييم الأولى', () => {
  it('عدد العيّنات: افتراضى 3، 1 يعيد السلوك السابق، أقصى 5، تالف يرجع للافتراضى', () => {
    expect(assessSampleCount(undefined)).toBe(3);
    expect(assessSampleCount('')).toBe(3);
    expect(assessSampleCount('1')).toBe(1);
    expect(assessSampleCount('9')).toBe(5);
    expect(assessSampleCount('0')).toBe(3);
    expect(assessSampleCount('x')).toBe(3);
  });

  it('أغلبية «سليم» (2 من 3) تُسقط عيّنة شاذة تقول «يحتاج مراجعة»: لا إنذار عابر', () => {
    const r = resolveAssessmentVotes([review(), sound(), sound()]);
    expect(label(r.outcome)).toBe('سليم');
    expect(r.decision).toBe('sound');
    expect(r.tally).toEqual({ review: 1, sound: 2, noText: 0, errors: 0 });
  });

  it('أغلبية «يحتاج مراجعة» (2 من 3) تثبت الملاحظة رغم عيّنة تقول سليم: لا التقاط ضائع', () => {
    const r = resolveAssessmentVotes([sound(), review(), review()]);
    expect(label(r.outcome)).toBe('يحتاج مراجعة');
    expect(r.decision).toBe('review');
  });

  it('بلا نصاب (يحتاج/سليم/لا نص): «يحتاج مراجعة» ولا يُسكت عن بند لم يُجمَع على سلامته', () => {
    const r = resolveAssessmentVotes([review(), sound(), ok(NO_TEXT)]);
    expect(label(r.outcome)).toBe('يحتاج مراجعة');
    expect(r.decision).toBe('review_no_quorum');
  });

  it('عيّنتان سليمتان متخالفتان (الثالثة عطل): «يحتاج مراجعة» (لا نصاب)', () => {
    const r = resolveAssessmentVotes([review(), sound(), err()]);
    expect(label(r.outcome)).toBe('يحتاج مراجعة');
    expect(r.tally.errors).toBe(1);
  });

  it('بلا عيّنة «يحتاج» وبلا نصاب: «سليم» قبل «لا نص»', () => {
    expect(label(resolveAssessmentVotes([sound(), ok(NO_TEXT)]).outcome)).toBe('سليم');
  });

  it('أغلبية «لا يوجد نص» تُعتمد', () => {
    expect(label(resolveAssessmentVotes([ok(NO_TEXT), ok(NO_TEXT), sound()]).outcome)).toBe(NO_TEXT);
  });

  it('عيّنة سليمة واحدة (الباقى أعطال) ⇒ حكمها كما كان، وكلها أعطال ⇒ أول عطل', () => {
    expect(label(resolveAssessmentVotes([err(), sound(), err()]).outcome)).toBe('سليم');
    const all = resolveAssessmentVotes([err(), err(), err()]);
    expect(all.outcome).toEqual({ status: 'error', detail: 'http_500' });
    const nc = resolveAssessmentVotes([{ status: 'not_configured' }, { status: 'not_configured' }]);
    expect(nc.outcome.status).toBe('not_configured');
  });

  it('نوع المخالفة: الأكثر تكراراً بين عيّنات «يحتاج»، فلا تُصعَّد «آمرة» بلا أغلبية', () => {
    const mandatory = review({ violationType: 'mandatory_violation', mandatoryQuote: 'لا يجوز', confidence: 0.95, selectedIndices: [3] });
    const r = resolveAssessmentVotes([mandatory, review({ violationType: 'supplementary_difference', confidence: 0.6 }), review({ violationType: 'supplementary_difference', confidence: 0.7 })]);
    expect(r.outcome.status === 'ok' && r.outcome.violationType).toBe('supplementary_difference');
    // الأعلى ثقة بين أصحاب النوع الفائز
    expect(r.outcome.status === 'ok' && r.outcome.confidence).toBe(0.7);
  });

  it('تعادل نوع المخالفة: الأخف (لا تصعيد آمرة بتعادل 1 مقابل 1)', () => {
    const r = resolveAssessmentVotes([review({ violationType: 'mandatory_violation', mandatoryQuote: 'x' }), review({ violationType: 'supplementary_difference' })]);
    expect(r.outcome.status === 'ok' && r.outcome.violationType).toBe('supplementary_difference');
  });

  it('أغلبية على آمرة تُحفظ مع اقتباسها ومواد عيّنتها نفسها (لا اختلاط تعليل بمواد غيره)', () => {
    const a = review({ violationType: 'mandatory_violation', mandatoryQuote: 'يقع باطلاً', selectedIndices: [2], reasoning: 'ر1', confidence: 0.5 });
    const b = review({ violationType: 'mandatory_violation', mandatoryQuote: 'باطل', selectedIndices: [4], reasoning: 'ر2', confidence: 0.9 });
    const c = sound();
    const r = resolveAssessmentVotes([a, b, c]);
    expect(r.outcome).toMatchObject({ selectedIndices: [4], mandatoryQuote: 'باطل', reasoning: 'ر2' });
  });

  it('الترتيب لا يغيّر النتيجة (إلا عند تساوى الثقة: الأسبق)', () => {
    const x = review({ confidence: 0.8, reasoning: 'أ' });
    const y = review({ confidence: 0.8, reasoning: 'ب' });
    expect((resolveAssessmentVotes([x, y, sound()]).outcome as { reasoning: string }).reasoning).toBe('أ');
    expect((resolveAssessmentVotes([sound(), review({ confidence: 0.7 }), review({ confidence: 0.9 })]).outcome as { confidence: number }).confidence).toBe(0.9);
  });
});

describe('الجولة 101: ContractsService.assessWithVote', () => {
  const makeService = (results: AssessSample[]) => {
    const calls = { n: 0 };
    const service = Object.create(ContractsService.prototype) as unknown as {
      generationService: { assessClause: jest.Mock };
      logger: { log: jest.Mock; warn: jest.Mock };
      assessWithVote(req: unknown, clauseIndex: number): Promise<AssessSample>;
    };
    service.generationService = { assessClause: jest.fn(async () => results[calls.n++ % results.length]) };
    service.logger = { log: jest.fn(), warn: jest.fn() };
    return service;
  };
  const OLD = process.env.CONTRACT_ASSESS_SAMPLES;
  afterEach(() => {
    if (OLD === undefined) delete process.env.CONTRACT_ASSESS_SAMPLES;
    else process.env.CONTRACT_ASSESS_SAMPLES = OLD;
  });

  it('افتراضياً 3 نداءات متوازية والقرار بالأغلبية مع سطر سجل أعداد بلا نص عقد', async () => {
    delete process.env.CONTRACT_ASSESS_SAMPLES;
    // الجولة 105.5: إجماع العيّنات الثلاث ⇒ لا عيّنات إضافية
    const s = makeService([review(), review(), review()]);
    const out = await s.assessWithVote({ clauseText: 'نص', candidates: [] }, 5);
    expect(s.generationService.assessClause).toHaveBeenCalledTimes(3);
    expect(label(out)).toBe('يحتاج مراجعة');
    const line = s.logger.log.mock.calls[0][0] as string;
    expect(line).toBe('assess vote clauseIndex=5 samples=3 extra=0 review=3 sound=0 noText=0 errors=0 decision=review');
    expect(line).not.toMatch(/[؀-ۿ]/);
  });

  it('الجولة 105.5: انقسام العيّنات الثلاث ⇒ عيّنتان إضافيتان والأغلبية من 5', async () => {
    delete process.env.CONTRACT_ASSESS_SAMPLES;
    delete process.env.CONTRACT_ASSESS_EXTRA_SAMPLES;
    const s = makeService([review(), sound(), review(), sound(), sound()]);
    const out = await s.assessWithVote({ clauseText: 'نص', candidates: [] }, 5);
    expect(s.generationService.assessClause).toHaveBeenCalledTimes(5);
    expect(label(out)).toBe('سليم');
    expect(s.logger.log.mock.calls[0][0]).toBe('assess vote clauseIndex=5 samples=5 extra=2 review=2 sound=3 noText=0 errors=0 decision=sound');
  });

  it('الجولة 105.5: CONTRACT_ASSESS_EXTRA_SAMPLES=0 يعطّل التوسعة (3 نداءات رغم الانقسام)', async () => {
    delete process.env.CONTRACT_ASSESS_SAMPLES;
    process.env.CONTRACT_ASSESS_EXTRA_SAMPLES = '0';
    const s = makeService([review(), sound(), review()]);
    await s.assessWithVote({ clauseText: 'نص', candidates: [] }, 5);
    expect(s.generationService.assessClause).toHaveBeenCalledTimes(3);
    delete process.env.CONTRACT_ASSESS_EXTRA_SAMPLES;
  });

  it('CONTRACT_ASSESS_SAMPLES=1 يعيد السلوك السابق: نداء واحد بلا سطر تصويت', async () => {
    process.env.CONTRACT_ASSESS_SAMPLES = '1';
    const s = makeService([sound()]);
    const out = await s.assessWithVote({ clauseText: 'نص', candidates: [] }, 2);
    expect(s.generationService.assessClause).toHaveBeenCalledTimes(1);
    expect(label(out)).toBe('سليم');
    expect(s.logger.log).not.toHaveBeenCalled();
  });

  it('كل العيّنات أعطال ⇒ يُرجع العطل ليُعاد مرة كما كان', async () => {
    delete process.env.CONTRACT_ASSESS_SAMPLES;
    const s = makeService([err()]);
    const out = await s.assessWithVote({ clauseText: 'نص', candidates: [] }, 1);
    expect(out.status).toBe('error');
  });
});
