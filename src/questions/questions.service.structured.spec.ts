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

describe('QuestionsService.ask — الاستيضاح', () => {
  const DETECT_OK = {
    status: 'ok',
    raw: {
      needs_clarification: true,
      reason: 'يختلف الحكم باختلاف نوع العقد',
      questions: [
        {
          question: 'ما نوع عقد العمل؟',
          why: 'تختلف الحقوق',
          options: ['عقد محدد المدة', 'عقد غير محدد المدة'],
          allow_multiple: false,
        },
      ],
    },
  };
  const ANSWERS = [{ question: 'ما نوع عقد العمل؟', answer: 'عقد محدد المدة', kind: 'option' }];

  function buildClar(detect: unknown) {
    const b = build({ structured: { status: 'ok', structured: STRUCTURED } });
    const gen = b.generation as unknown as Record<string, jest.Mock>;
    gen.detectClarification = jest.fn().mockResolvedValue(detect);
    return { ...b, gen };
  }
  afterEach(() => {
    delete process.env.CLARIFICATION_ENABLED;
    delete process.env.CLARIFICATION_MAX_ROUNDS;
  });

  it('أول طلب غامض: يُرجع clarification بلا إجابة ولا توليد ولا حفظ، مع تدقيق', async () => {
    const { svc, gen, generation } = buildClar(DETECT_OK);
    const r = await svc.ask({ question: 'ما حقوقى عند الفصل؟' } as never, CTX as never);
    expect(r.clarification?.round).toBe(1);
    expect(r.clarification?.max_rounds).toBe(2);
    expect(r.clarification?.questions[0].options).toEqual(['عقد محدد المدة', 'عقد غير محدد المدة']);
    expect(r.citations).toEqual([]);
    expect(r.refused).toBe(false);
    expect(r.id).toBeUndefined();
    expect(generation.composeStructuredAnswer).not.toHaveBeenCalled();
    expect(gen.detectClarification.mock.calls[0][0].articles[0].articleNo).toBe(154);
    const audit = (svc as unknown as { auditService: { record: jest.Mock } }).auditService.record;
    expect(audit.mock.calls.map((c) => c[0].action)).toEqual(['question.clarification_requested']);
  });

  it('بعد الإجابة: السؤال المُثرى يدخل التوليد، والاسترجاع بالاستعلام المضغوط، ويُمرَّر التاريخ للكاشف', async () => {
    const { svc, gen, generation } = buildClar({ status: 'ok', raw: { needs_clarification: false } });
    const r = await svc.ask(
      { question: 'ما حقوقى عند الفصل؟', clarification: { round: 1, answers: ANSWERS } } as never,
      CTX as never,
    );
    expect(r.clarification).toBeUndefined();
    expect(r.structured?.direct_answer).toBe('يعتمد على مدة الخدمة.');
    const retrieve = (svc as unknown as { retrieve: jest.Mock }).retrieve;
    expect(retrieve.mock.calls[0][0]).toBe('ما حقوقى عند الفصل؟ عقد محدد المدة');
    const genQuestion = generation.composeStructuredAnswer.mock.calls[0][0].question as string;
    expect(genQuestion).toContain('[توضيحات السائل]');
    expect(genQuestion).toContain('ما نوع عقد العمل؟ ← عقد محدد المدة');
    expect(gen.detectClarification.mock.calls[0][0].history).toHaveLength(1);
  });

  it('جولة ثانية مسموحة؛ وبلوغ الحد الأقصى يُجيب مباشرة بلا نداء للكاشف', async () => {
    const second = buildClar(DETECT_OK);
    const r2 = await second.svc.ask(
      { question: 'س؟؟؟', clarification: { round: 1, answers: [{ question: 'سؤال آخر مختلف تماماً؟', answer: 'ج', kind: 'option' }] } } as never,
      CTX as never,
    );
    expect(r2.clarification?.round).toBe(2);

    const last = buildClar(DETECT_OK);
    const r3 = await last.svc.ask(
      { question: 'س؟؟؟', clarification: { round: 2, answers: ANSWERS } } as never,
      CTX as never,
    );
    expect(last.gen.detectClarification).not.toHaveBeenCalled();
    expect(r3.clarification).toBeUndefined();
    expect(r3.structured).not.toBeNull();
  });

  it('skip=true: إجابة مباشرة بما أُجيب حتى الآن بلا نداء للكاشف', async () => {
    const { svc, gen, generation } = buildClar(DETECT_OK);
    const r = await svc.ask({ question: 'س؟؟؟', clarification: { skip: true, round: 0, answers: [] } } as never, CTX as never);
    expect(gen.detectClarification).not.toHaveBeenCalled();
    expect(r.clarification).toBeUndefined();
    expect(generation.composeStructuredAnswer.mock.calls[0][0].question).toBe('س؟؟؟');
  });

  it('CLARIFICATION_ENABLED=false: لا كاشف إطلاقاً', async () => {
    process.env.CLARIFICATION_ENABLED = 'false';
    const { svc, gen } = buildClar(DETECT_OK);
    const r = await svc.ask({ question: 'س؟؟؟' } as never, CTX as never);
    expect(gen.detectClarification).not.toHaveBeenCalled();
    expect(r.structured).not.toBeNull();
  });

  it('سؤال برقم مادة صريح لا يُستوضح أبداً', async () => {
    const { svc, gen } = buildClar(DETECT_OK);
    await svc.ask({ question: 'ما نص المادة 154 من قانون رقم 14 لسنة 2025؟' } as never, CTX as never);
    expect(gen.detectClarification).not.toHaveBeenCalled();
  });

  it('fail-open: عطل الكاشف (خطأ/استثناء/ناتج غير صالح/أسئلة كلها مرفوضة) = إجابة مباشرة', async () => {
    const bad = [
      { status: 'error', detail: 'http_500' },
      { status: 'not_configured' },
      { status: 'ok', raw: 'تالف' },
      { status: 'ok', raw: { needs_clarification: true, questions: [{ question: 'ما اسمك الكامل؟', options: ['أ', 'ب'] }] } },
    ];
    for (const d of bad) {
      const { svc } = buildClar(d);
      const r = await svc.ask({ question: 'س؟؟؟' } as never, CTX as never);
      expect(r.clarification).toBeUndefined();
      expect(r.structured).not.toBeNull();
    }
    const thrower = buildClar(DETECT_OK);
    thrower.gen.detectClarification.mockRejectedValue(new Error('boom'));
    const r = await thrower.svc.ask({ question: 'س؟؟؟' } as never, CTX as never);
    expect(r.clarification).toBeUndefined();
  });
});
