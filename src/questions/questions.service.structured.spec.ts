import { QuestionsService } from './questions.service';

/**
 * اختبار تكامل خفيف لمسار ask(): المنظَّم أولاً، ثم الرجوع للمسار القديم، ثم
 * مفتاح الإيقاف. الاسترجاع (retrieve) والاعتماديات مُحاكاة؛ لا قاعدة بيانات.
 */
const CITATION = {
  law: 'قانون العمل',
  lawNo: 14,
  lawYear: 2025,
  articleNo: 154,
  articleId: 'a1',
  articleVersionId: 'v1',
  lawId: 'l1',
  status: 'in_force',
  lastAmended: null,
  officialUrl: null,
  snippet: 'نص المادة 154 للاختبار فقط.',
};

function build(opts: { structured: unknown; legacy?: unknown }) {
  const repo = { create: (x: unknown) => x, save: async (x: object) => ({ ...x, id: 'id1' }), insert: jest.fn() };
  const dataSource = {
    getRepository: () => repo,
    transaction: async (cb: (m: unknown) => Promise<void>) => cb({ getRepository: () => repo }),
  };
  const generation = {
    composeStructuredAnswer: jest.fn().mockResolvedValue(opts.structured),
    composeGroundedAnswerMulti: jest.fn().mockResolvedValue(opts.legacy ?? { status: 'ok', text: 'نص قديم' }),
  };
  const audit = { record: jest.fn() };
  const svc = new QuestionsService(
    dataSource as never,
    audit as never,
    generation as never,
    {} as never,
    { isConfigured: false } as never,
  );
  jest
    .spyOn(svc as unknown as { retrieve: () => Promise<unknown> }, 'retrieve')
    .mockResolvedValue({ citations: [CITATION], confidence: 0.9 });
  return { svc, generation };
}

const STRUCTURED = {
  direct_answer: 'يعتمد على مدة الخدمة.',
  rulings: [{ claim: 'حكم.', kind: 'نص', citation_index: 0, quote: 'نص المادة', quote_verified: true }],
  scenarios: [{ condition: 'إذا كانت الخدمة أقل من خمس سنوات', outcome: 'لا مكافأة', citation_index: 0 }],
  open_issues: [],
  warnings: [],
  facts_to_confirm: ['ما مدة الخدمة؟'],
  not_covered: [],
};
const CTX = { userId: null, role: null, ipAddress: null, userAgent: null };

describe('QuestionsService.ask — الإجابة المنظَّمة', () => {
  afterEach(() => {
    delete process.env.STRUCTURED_ANSWERS_ENABLED;
  });

  it('عند نجاح التوليد المنظَّم: structured فى الرد، والنص المخزَّن مرتَّب، وحالة المصدر ساري', async () => {
    const { svc, generation } = build({ structured: { status: 'ok', structured: STRUCTURED } });
    const r = await svc.ask({ question: 'سؤال؟' } as never, CTX as never);
    expect(r.refused).toBe(false);
    expect(r.structured?.direct_answer).toBe('يعتمد على مدة الخدمة.');
    expect(r.structured?.scenarios?.[0].outcome).toBe('لا مكافأة');
    expect(r.answer.startsWith('الجواب المباشر:')).toBe(true);
    expect(r.citations[0].source_status).toBe('ساري');
    expect(generation.composeGroundedAnswerMulti).not.toHaveBeenCalled();
  });

  it('عند فشل المنظَّم: يعمل المسار القديم كما كان وstructured=null', async () => {
    const { svc, generation } = build({ structured: { status: 'invalid_structure', reason: 'x' } });
    const r = await svc.ask({ question: 'سؤال؟' } as never, CTX as never);
    expect(generation.composeGroundedAnswerMulti).toHaveBeenCalledTimes(1);
    expect(r.answer).toBe('نص قديم');
    expect(r.structured).toBeNull();
  });

  it('STRUCTURED_ANSWERS_ENABLED=false: لا يُستدعى المنظَّم إطلاقاً', async () => {
    process.env.STRUCTURED_ANSWERS_ENABLED = 'false';
    const { svc, generation } = build({ structured: { status: 'ok', structured: STRUCTURED } });
    const r = await svc.ask({ question: 'سؤال؟' } as never, CTX as never);
    expect(generation.composeStructuredAnswer).not.toHaveBeenCalled();
    expect(r.answer).toBe('نص قديم');
  });

  it('مصدر ملغى يظهر تحذيراً أول القائمة فى structured.warnings', async () => {
    const { svc } = build({ structured: { status: 'ok', structured: { ...STRUCTURED, warnings: ['تحذير النموذج'] } } });
    (svc as unknown as { retrieve: jest.Mock }).retrieve.mockResolvedValue({
      citations: [{ ...CITATION, status: 'repealed' }],
      confidence: 0.9,
    });
    const r = await svc.ask({ question: 'سؤال؟' } as never, CTX as never);
    expect(r.structured?.warnings[0]).toContain('ملغاة');
    expect(r.structured?.warnings[1]).toBe('تحذير النموذج');
    expect(r.citations[0].source_status).toBe('ملغى');
  });
});
