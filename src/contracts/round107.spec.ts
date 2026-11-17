import { resolveAssessmentVotes, type AssessSample } from './assess-vote';
import { ContractsService } from './contracts.service';

const ok = (assessment: string, over: Partial<Extract<AssessSample, { status: 'ok' }>> = {}): AssessSample => ({
  status: 'ok',
  assessment,
  selectedIndices: [],
  reasoning: 'شرح',
  confidence: 0.6,
  violationType: 'none',
  mandatoryQuote: '',
  ...over,
});
const sound = (over: Partial<Extract<AssessSample, { status: 'ok' }>> = {}) => ok('سليم', over);
const review = (over: Partial<Extract<AssessSample, { status: 'ok' }>> = {}) => ok('يحتاج مراجعة', over);
const picked = (o: AssessSample) => (o.status === 'ok' ? o.selectedIndices : null);

describe('الجولة 107: العيّنة الممثِّلة تُفضَّل فيها من اختارت مادة صالحة', () => {
  it('3 عيّنات «سليم» اختارت إحداها مادة وبلا ثقة أعلى لغيرها: تُعتمد صاحبة المادة (تغطية)', () => {
    const r = resolveAssessmentVotes([sound(), sound({ selectedIndices: [1] }), sound()], 3);
    expect(picked(r.outcome)).toEqual([1]);
  });

  it('الأعلى ثقة بلا مادة لا يسبق عيّنة اتفقت معه بمادة أقل ثقة', () => {
    const r = resolveAssessmentVotes([sound({ confidence: 0.9 }), sound({ confidence: 0.5, selectedIndices: [0] }), sound({ confidence: 0.7 })], 2);
    expect(picked(r.outcome)).toEqual([0]);
  });

  it('بين عيّنات اختارت مواد: الأعلى ثقة ثم الأسبق كما كان', () => {
    const r = resolveAssessmentVotes([sound({ selectedIndices: [0], confidence: 0.6 }), sound({ selectedIndices: [1], confidence: 0.8 }), sound({ selectedIndices: [2], confidence: 0.8 })], 3);
    expect(picked(r.outcome)).toEqual([1]);
  });

  it('فهرس خارج المرشحات المعروضة لا يُعدّ مادة صالحة', () => {
    const r = resolveAssessmentVotes([sound({ confidence: 0.9 }), sound({ selectedIndices: [7], confidence: 0.5 }), sound({ confidence: 0.6 })], 3);
    expect(r.outcome.status === 'ok' && r.outcome.confidence).toBe(0.9);
  });

  it('لا عيّنة اختارت مادة، أو عدد المرشحات مجهول (0): السلوك السابق حرفياً (الأعلى ثقة)', () => {
    const a = resolveAssessmentVotes([sound({ confidence: 0.5 }), sound({ confidence: 0.9 }), sound({ confidence: 0.7 })], 3);
    expect(a.outcome.status === 'ok' && a.outcome.confidence).toBe(0.9);
    const b = resolveAssessmentVotes([sound({ confidence: 0.5, selectedIndices: [0] }), sound({ confidence: 0.9 }), sound()]);
    expect(b.outcome.status === 'ok' && b.outcome.confidence).toBe(0.9);
  });

  it('لا يغيّر الحالة الفائزة ولا الأغلبية: العيّنة المراجِعة لا تُفضَّل على «سليم» لأنها اختارت مادة', () => {
    const r = resolveAssessmentVotes([review({ selectedIndices: [0] }), sound(), sound(), review({ selectedIndices: [0] }), sound()], 1);
    expect(r.decision).toBe('sound');
    expect(r.outcome.status === 'ok' && r.outcome.assessment).toBe('سليم');
    expect(r.tally).toEqual({ review: 2, sound: 3, noText: 0, errors: 0 });
  });

  it('نوع المخالفة الأكثر تكراراً يبقى المحدِّد: التفضيل داخل النوع المختار فقط', () => {
    const r = resolveAssessmentVotes(
      [
        review({ violationType: 'supplementary_difference', confidence: 0.6 }),
        review({ violationType: 'supplementary_difference', confidence: 0.7, selectedIndices: [0] }),
        review({ violationType: 'mandatory_violation', confidence: 0.99, selectedIndices: [1] }),
      ],
      2,
    );
    expect(r.outcome.status === 'ok' && r.outcome.violationType).toBe('supplementary_difference');
    expect(picked(r.outcome)).toEqual([0]);
  });

  it('عبر الخدمة: assessWithVote يمرّر عدد المرشحات فتُعتمد عيّنة صاحبة المادة', async () => {
    const results = [sound(), sound({ selectedIndices: [0], confidence: 0.55 }), sound({ confidence: 0.8 })];
    let n = 0;
    const service = Object.create(ContractsService.prototype) as unknown as {
      generationService: { assessClause: jest.Mock };
      logger: { log: jest.Mock; warn: jest.Mock };
      assessWithVote(req: unknown, clauseIndex: number): Promise<AssessSample>;
    };
    service.generationService = { assessClause: jest.fn(async () => results[n++ % results.length]) };
    service.logger = { log: jest.fn(), warn: jest.fn() };
    const out = await service.assessWithVote({ clauseText: 'نص', candidates: [{}, {}] }, 8);
    expect(picked(out)).toEqual([0]);
  });
});
