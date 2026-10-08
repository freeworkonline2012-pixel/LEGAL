import { DeepseekGenerationService } from './deepseek-generation.service';
import { buildEnrichedQuestion } from '../questions/clarification';

function jsonResponse(status: number, body: unknown) {
  return {
    ok: status >= 200 && status < 300,
    status,
    text: async () => JSON.stringify(body),
    json: async () => body,
  } as unknown as Response;
}
const completion = (content: string | null) => ({
  choices: [{ message: { content }, finish_reason: 'stop' }],
});

const ART_TEXT =
  'إذا كان العقد غير محدد المدة فإذا كان الإنهاء من جانب صاحب العمل استحق العامل مكافأة عن مدة خدمته.';
const INPUT = {
  question: 'ما حقوقى عند الإنهاء؟',
  articles: [
    { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 154, articleText: ART_TEXT },
  ],
};
const GOOD = {
  direct_answer: 'يستحق مكافأة إذا أنهى صاحب العمل العقد.',
  rulings: [
    {
      claim: 'يستحق العامل مكافأة إذا كان الإنهاء من جانب صاحب العمل.',
      kind: 'نص',
      source: 1,
      quote: 'فإذا كان الإنهاء من جانب صاحب العمل استحق العامل مكافأة',
    },
  ],
  open_issues: [],
  warnings: [],
  facts_to_confirm: ['ما مدة الخدمة؟'],
  not_covered: [],
};

describe('DeepseekGenerationService.composeStructuredAnswer', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;
  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    process.env.STRUCTURED_MAX_ATTEMPTS = '1'; // اختبارات المحاولة الواحدة؛ إعادة المحاولة لها describe مستقل أدناه
  });
  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    delete process.env.STRUCTURED_MAX_ATTEMPTS;
    jest.restoreAllMocks();
  });

  it('not_configured بلا أى fetch عند غياب المفتاح', async () => {
    delete process.env.DEEPSEEK_API_KEY;
    const fetchMock = jest.fn();
    global.fetch = fetchMock as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(r).toEqual({ status: 'not_configured' });
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('ok: يُرجع البنية الموثَّقة ويرسل JSON-mode وthinking disabled', async () => {
    const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))));
    global.fetch = fetchMock as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(r.status).toBe('ok');
    if (r.status !== 'ok') return;
    expect(r.structured.rulings[0]).toMatchObject({ kind: 'نص', quote_verified: true, citation_index: 0 });
    const body = JSON.parse(fetchMock.mock.calls[0][1].body);
    expect(body.response_format).toEqual({ type: 'json_object' });
    expect(body.thinking).toEqual({ type: 'disabled' });
    expect(fetchMock).toHaveBeenCalledTimes(1);
  });

  it('invalid_structure عند JSON تالف (بلا إعادة محاولة صامتة، المتصل يرجع للمسار القديم)', async () => {
    global.fetch = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, completion('{"direct_answer": "ناقص'))) as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(r).toEqual({ status: 'invalid_structure', reason: 'unparseable_json' });
  });

  it('hallucination_rejected عند ذكر رقم مادة غير مرسَل داخل الحكم', async () => {
    const bad = { ...GOOD, direct_answer: 'تنطبق المادة 999 على حالتك.' };
    global.fetch = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(bad)))) as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(r).toEqual({ status: 'hallucination_rejected' });
  });

  it('api_error عند 500 وعند استثناء الشبكة، وempty_response عند content فارغ', async () => {
    const svc = new DeepseekGenerationService();
    global.fetch = jest.fn().mockResolvedValueOnce(jsonResponse(500, { e: 1 })) as unknown as typeof fetch;
    expect(await svc.composeStructuredAnswer(INPUT)).toEqual({ status: 'api_error' });
    global.fetch = jest.fn().mockRejectedValueOnce(new Error('net')) as unknown as typeof fetch;
    expect(await svc.composeStructuredAnswer(INPUT)).toEqual({ status: 'api_error' });
    global.fetch = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(''))) as unknown as typeof fetch;
    expect(await svc.composeStructuredAnswer(INPUT)).toEqual({ status: 'empty_response' });
  });
});


describe('DeepseekGenerationService.composeStructuredAnswer — خطوة الاستكمال', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;
  const originalFlag = process.env.STRUCTURED_COMPLETION_ENABLED;
  const ART_87 = 'يبرم عقد العمل الفردى لمدة غير محددة،أو لمدة محددة إذا كانت طبيعة العمل تقتضى ذلك.';
  const TWO = {
    question: 'عقدى محدد المدة ولم يجدد، ما حقوقى؟',
    articles: [
      { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 154, articleText: ART_TEXT },
      { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 87, articleText: ART_87 },
    ],
  };
  const ADD_87 = {
    rulings: [
      {
        claim: 'يبرم عقد العمل الفردى لمدة غير محددة أو لمدة محددة إذا اقتضت طبيعة العمل ذلك.',
        kind: 'نص',
        source: 2,
        quote: 'يبرم عقد العمل الفردى لمدة غير محددة،أو لمدة محددة إذا كانت طبيعة العمل تقتضى ذلك.',
      },
    ],
    scenarios: [{ condition: 'إذا كانت الوظيفة دائمة بطبيعتها', outcome: 'لا يجوز توقيت العقد إلا لطبيعة العمل.', source: 2 }],
    warnings: [],
    skipped: [],
  };

  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    delete process.env.STRUCTURED_COMPLETION_ENABLED;
  });
  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    if (originalFlag === undefined) delete process.env.STRUCTURED_COMPLETION_ENABLED;
    else process.env.STRUCTURED_COMPLETION_ENABLED = originalFlag;
    jest.restoreAllMocks();
  });

  it('مادة مرسَلة لم يُستند إليها ← نداء استكمال يضيف حكمها وسيناريوها بعد الأساسى', async () => {
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))))
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(ADD_87))));
    global.fetch = fetchMock as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(TWO);
    expect(fetchMock).toHaveBeenCalledTimes(2);
    expect(r.status).toBe('ok');
    if (r.status !== 'ok') return;
    expect(r.structured.rulings.map((x) => x.citation_index)).toEqual([0, 1]);
    expect(r.structured.rulings[1]).toMatchObject({ kind: 'نص', quote_verified: true });
    expect(r.structured.scenarios[0]).toMatchObject({ condition: 'كانت الوظيفة دائمة بطبيعتها', citation_index: 1 });
    const body = JSON.parse(fetchMock.mock.calls[1][1].body);
    expect(body.response_format).toEqual({ type: 'json_object' });
    expect(body.messages[1].content).toContain('نصوص لم تُستخدم: المادة 87');
    expect(body.messages[1].content).toContain(GOOD.rulings[0].claim);
  });

  it('فشل نداء الاستكمال (500/شبكة/JSON تالف) لا يُسقط الإجابة الأساسية', async () => {
    const seconds: Array<() => Promise<Response>> = [
      () => Promise.resolve(jsonResponse(500, { e: 1 })),
      () => Promise.reject(new Error('net')),
      () => Promise.resolve(jsonResponse(200, completion('{"rulings": [ناقص'))),
      () => Promise.resolve(jsonResponse(200, completion(''))),
    ];
    for (const second of seconds) {
      global.fetch = jest
        .fn()
        .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))))
        .mockImplementationOnce(second) as unknown as typeof fetch;
      const r = await new DeepseekGenerationService().composeStructuredAnswer(TWO);
      expect(r.status).toBe('ok');
      if (r.status === 'ok') expect(r.structured.rulings).toHaveLength(1);
    }
  });

  it('إضافة تستشهد بمادة غير مرسَلة تُهمَل كلها وتبقى الإجابة الأساسية', async () => {
    const bad = {
      ...ADD_87,
      rulings: [{ ...ADD_87.rulings[0], claim: `${ADD_87.rulings[0].claim} وفق المادة 999.` }],
    };
    global.fetch = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))))
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(bad)))) as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(TWO);
    expect(r.status).toBe('ok');
    if (r.status === 'ok') expect(r.structured.rulings).toHaveLength(1);
  });

  it('إقرار النموذج بعدم صلة المادة (skipped) لا يضيف شيئاً ولا يفشل', async () => {
    global.fetch = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))))
      .mockResolvedValueOnce(
        jsonResponse(200, completion(JSON.stringify({ rulings: [], scenarios: [], warnings: [], skipped: [{ article: 87, reason: 'بعيدة' }] }))),
      ) as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(TWO);
    expect(r.status).toBe('ok');
    if (r.status === 'ok') expect(r.structured.rulings).toHaveLength(1);
  });

  it('لا نداء ثانياً حين تُستخدم كل المواد أو عند تعطيل المفتاح STRUCTURED_COMPLETION_ENABLED=false', async () => {
    const both = {
      ...GOOD,
      rulings: [...GOOD.rulings, ADD_87.rulings[0]],
    };
    let fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(both))));
    global.fetch = fetchMock as unknown as typeof fetch;
    await new DeepseekGenerationService().composeStructuredAnswer(TWO);
    expect(fetchMock).toHaveBeenCalledTimes(1);

    process.env.STRUCTURED_COMPLETION_ENABLED = 'false';
    fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))));
    global.fetch = fetchMock as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(TWO);
    expect(fetchMock).toHaveBeenCalledTimes(1);
    expect(r.status === 'ok' && r.structured.rulings).toHaveLength(1);
  });

  it('2h: مادة تُركت بلا استناد ولا إقرار ← جولة استكمال ثانية تطلبها صراحةً فتُضاف', async () => {
    const EMPTY = { rulings: [], scenarios: [], warnings: [], skipped: [] };
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))))
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(EMPTY))))
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(ADD_87))));
    global.fetch = fetchMock as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(TWO);
    expect(fetchMock).toHaveBeenCalledTimes(3);
    expect(r.status === 'ok' && r.structured.rulings.map((x) => x.citation_index)).toEqual([0, 1]);
    const second = JSON.parse(fetchMock.mock.calls[2][1].body).messages[1].content as string;
    expect(second).toContain('لم تتناولها الإجابة ولم يُذكر لها إقرار');
    expect(second).toContain('نصوص لم تُستخدم: المادة 87');
  });

  it('2h: لا جولة ثانية إذا أقرّ النموذج بعدم الصلة أو فشل النداء الأول', async () => {
    const skip = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))))
      .mockResolvedValueOnce(
        jsonResponse(200, completion(JSON.stringify({ rulings: [], scenarios: [], warnings: [], skipped: [{ article: 87, reason: 'بعيدة' }] }))),
      );
    global.fetch = skip as unknown as typeof fetch;
    await new DeepseekGenerationService().composeStructuredAnswer(TWO);
    expect(skip).toHaveBeenCalledTimes(2);

    const fail = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))))
      .mockResolvedValueOnce(jsonResponse(500, {}));
    global.fetch = fail as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().composeStructuredAnswer(TWO);
    expect(fail).toHaveBeenCalledTimes(2);
    expect(r.status).toBe('ok');
  });
});

describe('DeepseekGenerationService — الاستيضاح', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;
  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
  });
  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    jest.restoreAllMocks();
  });
  const DETECT_INPUT = {
    question: 'ما حقوقى عند الفصل؟',
    history: [{ question: 'ما نوع العقد؟', answer: 'محدد المدة', kind: 'option' as const }],
    articles: INPUT.articles,
  };

  it('detectClarification: not_configured بلا fetch عند غياب المفتاح', async () => {
    delete process.env.DEEPSEEK_API_KEY;
    const fetchMock = jest.fn();
    global.fetch = fetchMock as unknown as typeof fetch;
    expect(await new DeepseekGenerationService().detectClarification(DETECT_INPUT)).toEqual({ status: 'not_configured' });
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('detectClarification: يرسل السؤال والتاريخ والمواد المسترجعة فى JSON-mode ويُرجع JSON الخام', async () => {
    const raw = { needs_clarification: true, questions: [{ question: 'س؟', options: ['أ', 'ب'] }] };
    const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(raw))));
    global.fetch = fetchMock as unknown as typeof fetch;
    const r = await new DeepseekGenerationService().detectClarification(DETECT_INPUT);
    expect(r).toEqual({ status: 'ok', raw });
    const body = JSON.parse(fetchMock.mock.calls[0][1].body);
    expect(body.response_format).toEqual({ type: 'json_object' });
    expect(body.thinking).toEqual({ type: 'disabled' });
    const user = body.messages[1].content as string;
    expect(user).toContain('ما حقوقى عند الفصل؟');
    expect(user).toContain('ما نوع العقد؟ ← محدد المدة');
    expect(user).toContain('المادة 154');
  });

  it('detectClarification: أخطاء (500، شبكة، فارغ، JSON تالف) تُرجع error لا استثناء', async () => {
    const svc = new DeepseekGenerationService();
    global.fetch = jest.fn().mockResolvedValueOnce(jsonResponse(500, {})) as unknown as typeof fetch;
    expect((await svc.detectClarification(DETECT_INPUT)).status).toBe('error');
    global.fetch = jest.fn().mockRejectedValueOnce(new Error('net')) as unknown as typeof fetch;
    expect((await svc.detectClarification(DETECT_INPUT)).status).toBe('error');
    global.fetch = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(null))) as unknown as typeof fetch;
    expect((await svc.detectClarification(DETECT_INPUT)).status).toBe('error');
    global.fetch = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion('{bad'))) as unknown as typeof fetch;
    expect((await svc.detectClarification(DETECT_INPUT)).status).toBe('error');
  });

  it('قاعدة وقائع السائل تُلحَق بتعليمات التوليد فقط عند وجود قسم التوضيحات', async () => {
    const svc = new DeepseekGenerationService();
    const plain = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))));
    global.fetch = plain as unknown as typeof fetch;
    await svc.composeStructuredAnswer(INPUT);
    expect(JSON.parse(plain.mock.calls[0][1].body).messages[0].content).not.toContain('وقائع السائل (إلزامية');

    const enriched = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))));
    global.fetch = enriched as unknown as typeof fetch;
    await svc.composeStructuredAnswer({
      ...INPUT,
      question: `${INPUT.question}\n\n[توضيحات السائل]\n- ما نوع العقد؟ ← محدد المدة`,
    });
    expect(JSON.parse(enriched.mock.calls[0][1].body).messages[0].content).toContain('وقائع السائل (إلزامية');
  });

  it('مقدار ذكره السائل فى توضيحاته يُقبل فى شرط السيناريو، وأثر شديد غير وارد فى المادة يُسقَط رغم ذلك', async () => {
    const withScenarios = {
      ...GOOD,
      scenarios: [
        { condition: 'مدة خدمتك عشر سنوات', outcome: 'تستحق المكافأة عن مدة خدمتك', source: 1 },
        { condition: 'مدة خدمتك عشر سنوات', outcome: 'يسقط حقك بالتقادم', source: 1 },
      ],
    };
    global.fetch = jest
      .fn()
      .mockResolvedValue(jsonResponse(200, completion(JSON.stringify(withScenarios)))) as unknown as typeof fetch;
    const noFacts = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(noFacts.status === 'ok' && noFacts.structured.scenarios).toHaveLength(0);
    const withFacts = await new DeepseekGenerationService().composeStructuredAnswer({
      ...INPUT,
      question: `${INPUT.question}\n\n[توضيحات السائل]\n- كم مدة الخدمة؟ ← عشر سنوات`,
    });
    expect(withFacts.status).toBe('ok');
    if (withFacts.status !== 'ok') return;
    expect(withFacts.structured.scenarios).toHaveLength(1);
    expect(withFacts.structured.scenarios[0].outcome).toContain('تستحق');
  });
});

describe('DeepseekGenerationService — وضع الوقائع: خطوة التطبيق ومراجعة الاتساق', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;
  const originalReview = process.env.STRUCTURED_REVIEW_ENABLED;
  const FACTS_Q = {
    ...INPUT,
    question: buildEnrichedQuestion(INPUT.question, [
      { question: 'كم إجمالى مدة الخدمة بالسنوات؟', answer: '12', kind: 'custom' },
    ]),
  };
  const DRAFT = { ...GOOD, direct_answer: 'لا تستحق شيئاً لأن مدة خدمتك لم تتجاوز خمس سنوات.' };
  const FIXED = { ...GOOD, direct_answer: 'تستحق مكافأة إذا أنهى صاحب العمل العقد، ومدة خدمتك 12 سنة.' };
  const DEFECTS = {
    defects: [
      { type: 'contradicts_fact', problem: 'الجواب المباشر ينفى تجاوز خمس سنوات والسائل ذكر 12 سنة', fix: 'اعتمد مدة 12 سنة' },
    ],
  };
  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    process.env.STRUCTURED_MAX_ATTEMPTS = '1';
    process.env.STRUCTURED_FACT_FILTER_ENABLED = 'false'; // نداء تصفية الوقائع له اختبارات مستقلة أدناه
    delete process.env.STRUCTURED_REVIEW_ENABLED;
  });
  afterEach(() => {
    delete process.env.STRUCTURED_MAX_ATTEMPTS;
    delete process.env.STRUCTURED_FACT_FILTER_ENABLED;
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    if (originalReview === undefined) delete process.env.STRUCTURED_REVIEW_ENABLED;
    else process.env.STRUCTURED_REVIEW_ENABLED = originalReview;
    jest.restoreAllMocks();
  });
  const mockSeq = (...bodies: unknown[]) => {
    const f = jest.fn();
    for (const b of bodies) f.mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(b))));
    global.fetch = f as unknown as typeof fetch;
    return f;
  };

  it('تعليمات التوليد فى وضع الوقائع: مفتاح facts_applied قبل direct_answer وقاعدة التطبيق، والوحدة تُلحَق بالرقم المجرد', async () => {
    const f = mockSeq(GOOD, { defects: [] });
    await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    const body = JSON.parse(f.mock.calls[0][1].body);
    const sys = body.messages[0].content as string;
    expect(sys.indexOf('"facts_applied"')).toBeGreaterThan(-1);
    expect(sys.indexOf('"facts_applied"')).toBeLessThan(sys.indexOf('"direct_answer"'));
    expect(sys).toContain('المسار الأول');
    expect(sys).toContain('لا تجزم');
    expect(body.messages[1].content).toContain('12 سنوات');
  });

  it('المسار العادى (بلا توضيحات): لا facts_applied ولا نداء مراجعة', async () => {
    const f = mockSeq(GOOD);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(r.status).toBe('ok');
    expect(f).toHaveBeenCalledTimes(1);
    expect(JSON.parse(f.mock.calls[0][1].body).messages[0].content).not.toContain('facts_applied');
  });

  it('عيب مؤكد ← تصحيح واحد يُعتمد، والناقد يرى الوقائع والمسودة، والمصحِّح يرى العيب', async () => {
    const f = mockSeq(DRAFT, DEFECTS, FIXED);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(f).toHaveBeenCalledTimes(3);
    expect(r.status === 'ok' && r.structured.direct_answer).toBe(FIXED.direct_answer);
    const critic = JSON.parse(f.mock.calls[1][1].body);
    expect(critic.temperature).toBe(0);
    expect(critic.messages[1].content).toContain('12');
    expect(critic.messages[1].content).toContain(DRAFT.direct_answer);
    const revise = JSON.parse(f.mock.calls[2][1].body).messages[1].content as string;
    expect(revise).toContain('contradicts_fact');
    expect(revise).toContain('اعتمد مدة 12 سنة');
    expect(revise).toContain(DRAFT.direct_answer);
  });

  it('بلا عيوب ← تبقى المسودة ولا نداء تصحيح', async () => {
    const f = mockSeq(DRAFT, { defects: [] });
    const r = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(f).toHaveBeenCalledTimes(2);
    expect(r.status === 'ok' && r.structured.direct_answer).toBe(DRAFT.direct_answer);
  });

  it('فشل الناقد (500/شبكة/JSON تالف) أو تصحيح غير صالح أو يستشهد بمادة غير مرسَلة ← تبقى المسودة', async () => {
    const svc = new DeepseekGenerationService();
    const bad = jest.fn();
    bad.mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(DRAFT)))).mockResolvedValueOnce(jsonResponse(500, {}));
    global.fetch = bad as unknown as typeof fetch;
    expect((await svc.composeStructuredAnswer(FACTS_Q)).status).toBe('ok');

    const net = jest.fn();
    net.mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(DRAFT)))).mockRejectedValueOnce(new Error('net'));
    global.fetch = net as unknown as typeof fetch;
    const r2 = await svc.composeStructuredAnswer(FACTS_Q);
    expect(r2.status === 'ok' && r2.structured.direct_answer).toBe(DRAFT.direct_answer);

    const junk = jest.fn();
    junk
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(DRAFT))))
      .mockResolvedValueOnce(jsonResponse(200, completion('{bad')));
    global.fetch = junk as unknown as typeof fetch;
    const r3 = await svc.composeStructuredAnswer(FACTS_Q);
    expect(r3.status === 'ok' && r3.structured.direct_answer).toBe(DRAFT.direct_answer);

    mockSeq(DRAFT, DEFECTS, { not: 'valid' });
    const r4 = await svc.composeStructuredAnswer(FACTS_Q);
    expect(r4.status === 'ok' && r4.structured.direct_answer).toBe(DRAFT.direct_answer);

    // تصحيح يستشهد بمادة 999 غير مرسَلة ← بوابة الهلوسة تُسقط الإجابة كلها (المسار القديم) لا تمرّر الاستشهاد الخاطئ
    mockSeq(DRAFT, DEFECTS, { ...FIXED, direct_answer: 'تستحق مكافأة طبقاً للمادة 999.' });
    const r5 = await svc.composeStructuredAnswer(FACTS_Q);
    expect(r5.status).toBe('hallucination_rejected');
  });

  it('مفتاح STRUCTURED_REVIEW_ENABLED=false يعطّل المراجعة', async () => {
    process.env.STRUCTURED_REVIEW_ENABLED = 'false';
    const f = mockSeq(DRAFT);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(f).toHaveBeenCalledTimes(1);
    expect(r.status).toBe('ok');
  });

  it('أنواع عيوب غير معروفة وعيوب بلا إصلاح تُهمَل (لا تصحيح بلا سبب)', async () => {
    const f = mockSeq(DRAFT, { defects: [{ type: 'style', problem: 'الأسلوب ركيك جداً', fix: 'حسّنه' }, { type: 'contradicts_fact', problem: 'قصير', fix: '' }] }, FIXED);
    await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(f).toHaveBeenCalledTimes(2);
  });

  it('قواعد 2g فى وضع الوقائع: اتساق المسارات، شكل الإجراء، الخطوات العملية، صياغة الجواب المباشر', async () => {
    const f = mockSeq(GOOD, { defects: [] });
    await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    const sys = JSON.parse(f.mock.calls[0][1].body).messages[0].content as string;
    expect(sys).toContain('اتساق المسارات');
    expect(sys).toContain('قيّد النفى بمساره');
    expect(sys).toContain('شكل الإجراء وميعاده');
    expect(sys).toContain('الخطوات العملية');
    expect(sys).toContain('لا يبدأ بنفى');
    expect(sys).toContain('الأصلى');
    expect(sys).toContain('الاحتياطى');
    // ضمانات مهلة الإخطار الجارية لا تُدرج حين انتهت العلاقة فعلاً
    expect(sys).toContain('ضمانات مهلة إخطار جارية');
  });

  it('أنواع الناقد الجديدة (تناقض المسارات، شكل الإجراء، خطوة عملية، افتتاح بنفى، تكرار) تُقبل وتُمرَّر للمصحِّح', async () => {
    const defects = {
      defects: [
        { type: 'path_inconsistency', problem: 'ينفى م165 مطلقاً وهى تنطبق على المسار الأول', fix: 'قيّد النفى بالمسار الثانى' },
        { type: 'ignores_stated_formality', problem: 'الإخطار الشفهى لم يقارن بشرط الكتابة', fix: 'قارنه بالمادة 156' },
        { type: 'missing_practical_step', problem: 'لا خطوة عملية رغم عدم استلام المستحقات', fix: 'أضف المطالبة والتسوية الودية' },
        { type: 'negative_lead', problem: 'الجواب يبدأ بفلا تعويض', fix: 'ابدأ بالمسار الأصلى' },
        { type: 'duplicate_item', problem: 'تنبيه يكرر مدة الإخطار', fix: 'احذفه' },
      ],
    };
    const f = mockSeq(DRAFT, defects, FIXED);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(f).toHaveBeenCalledTimes(3);
    expect(r.status === 'ok' && r.structured.direct_answer).toBe(FIXED.direct_answer);
    const revise = JSON.parse(f.mock.calls[2][1].body).messages[1].content as string;
    for (const t of ['path_inconsistency', 'ignores_stated_formality', 'missing_practical_step', 'negative_lead', 'duplicate_item']) {
      expect(revise).toContain(t);
    }
  });

  it('قواعد 2h فى وضع الوقائع: ترتيب الأصل العام، إسناد الأثر، صاحب الميعاد، تمام الإجراء', async () => {
    const f = mockSeq(GOOD, { defects: [] });
    await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    const sys = JSON.parse(f.mock.calls[0][1].body).messages[0].content as string;
    // لم يعد «الأصلى» معرَّفاً بأنه الأقوى للسائل بل بأنه القاعدة العامة فى النص
    expect(sys).not.toContain('الأقوى للسائل');
    expect(sys).toContain('القاعدة العامة');
    expect(sys).toContain('ممنوع أن تصف مساراً يقرره نص');
    expect(sys).toContain('إسناد الأثر لمصدره');
    expect(sys).toContain('لا تُدخل فيها حالة لم تُذكر فيها');
    expect(sys).toContain('open_issues');
    expect(sys).toContain('صاحب الميعاد');
    expect(sys).toContain('108/8');
    expect(sys).toContain('تمام الإجراء');
    expect(sys).toContain('اختيارية');
    expect(sys).toContain('فى العقد غير محدد المدة فقط');
    expect(sys).toContain('حق العامل فى الإنهاء بعد مدة معينة');
  });

  it('أنواع الناقد 2h (انقلاب المسارات، خطأ الإسناد، ميعاد لغير صاحبه، إجراء ناقص) تُقبل وتُمرَّر للمصحِّح', async () => {
    const defects = {
      defects: [
        { type: 'inverted_paths', problem: 'قدّم العقد المحدد كأصل ووصف غير المحدد بالاحتياطى', fix: 'اجعل غير المحدد أولاً' },
        { type: 'misattributed_effect', problem: 'نسب طبيعة العمل إلى المادة 88', fix: 'أسندها إلى المادة 87' },
        { type: 'wrong_party_deadline', problem: 'عرض السبعة أيام كمهلة على العامل مع ترقيم 108/8', fix: 'اجعلها على صاحب العمل' },
        { type: 'incomplete_procedure', problem: 'حُذف المسار الاستعجالى فى المادة 150', fix: 'أضف مدته وحد الأجر المؤقت' },
      ],
    };
    const f = mockSeq(DRAFT, defects, FIXED);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(f).toHaveBeenCalledTimes(3);
    expect(r.status === 'ok' && r.structured.direct_answer).toBe(FIXED.direct_answer);
    const revise = JSON.parse(f.mock.calls[2][1].body).messages[1].content as string;
    for (const t of ['inverted_paths', 'misattributed_effect', 'wrong_party_deadline', 'incomplete_procedure']) {
      expect(revise).toContain(t);
    }
    expect(revise).toContain('لا تحذف حكماً أو تنبيهاً سليماً');
  });

  it('2i: قاعدة (د) تُبقي facts_to_confirm فارغة إلا لـ«لا يعرف»، وتصحيح الناقد يُمنح حد مخرجات أكبر من المسودة', async () => {
    const f = mockSeq(DRAFT, { defects: [{ type: 'asks_known_fact', problem: 'يسأل عن مدة الخدمة', fix: 'احذفه' }] }, FIXED);
    await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    const first = JSON.parse(f.mock.calls[0][1].body);
    expect(first.messages[0].content).toContain('السائل استُوضح بالفعل');
    expect(first.messages[0].content).toContain('facts_to_confirm فارغة');
    const revise = JSON.parse(f.mock.calls[2][1].body);
    expect(revise.max_tokens).toBeGreaterThan(first.max_tokens);
    expect(revise.max_tokens).toBeLessThanOrEqual(8000);
  });

  it('2j: تصفية الوقائع تحذف السيناريو الذى تنفيه وقائع السائل بالمعرّف، ولا تحذف الحكم الوحيد', async () => {
    delete process.env.STRUCTURED_FACT_FILTER_ENABLED;
    const withScenarios = {
      ...GOOD,
      scenarios: [
        { condition: 'استمر التنفيذ بعد انتهاء المدة', outcome: 'يصير العقد غير محدد المدة.', source: 1 },
        { condition: 'أنهى صاحب العمل العقد', outcome: 'يستحق العامل مكافأة عن مدة خدمته.', source: 1 },
      ],
    };
    const f = mockSeq(withScenarios, { defects: [] }, {
      inapplicable: [
        { id: 'S1', reason: 'السائل قال إن التنفيذ توقف بعد انتهاء المدة' },
        { id: 'R1', reason: 'محاولة حذف الحكم الوحيد' },
      ],
    });
    const r = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(f).toHaveBeenCalledTimes(3);
    const filterSys = JSON.parse(f.mock.calls[2][1].body).messages[0].content as string;
    expect(filterSys).toContain('مرشِّح تطبيق على الوقائع');
    const filterUser = JSON.parse(f.mock.calls[2][1].body).messages[1].content as string;
    expect(filterUser).toContain('S1 (م');
    expect(r.status === 'ok' && r.structured.scenarios.map((x) => x.condition)).toEqual(['أنهى صاحب العمل العقد']);
    expect(r.status === 'ok' && r.structured.rulings).toHaveLength(1);
  });

  it('2j: فشل نداء التصفية أو معرّف غير صالح لا يغيّر الإجابة', async () => {
    delete process.env.STRUCTURED_FACT_FILTER_ENABLED;
    const withScenarios = {
      ...GOOD,
      scenarios: [{ condition: 'استمر التنفيذ بعد انتهاء المدة', outcome: 'يصير العقد غير محدد المدة.', source: 1 }],
    };
    const bad = jest.fn();
    bad
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(withScenarios))))
      .mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify({ defects: [] }))))
      .mockResolvedValueOnce(jsonResponse(500, {}));
    global.fetch = bad as unknown as typeof fetch;
    const r1 = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(r1.status === 'ok' && r1.structured.scenarios).toHaveLength(1);
    mockSeq(withScenarios, { defects: [] }, { inapplicable: [{ id: 'S9', reason: 'x' }, { id: 'Z1', reason: 'y' }] });
    const r2 = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(r2.status === 'ok' && r2.structured.scenarios).toHaveLength(1);
  });

  it('2j: قاعدتا (ع) و(ف) وقائمة الفحص فى التعليمات، وأنواع الناقد الجديدة تُقبل', async () => {
    const f = mockSeq(GOOD, { defects: [] });
    await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    const sys = JSON.parse(f.mock.calls[0][1].body).messages[0].content as string;
    expect(sys).toContain('فى حالتك');
    expect(sys).toContain('تصفية الاحتمالات');
    expect(sys).toContain('قائمة الفحص الثابتة');
    expect(sys).toContain('C1) المادة 161 تخص العقد غير محدد المدة');
    expect(sys).toContain('C8)');
    const critic = JSON.parse(f.mock.calls[1][1].body).messages[0].content as string;
    expect(critic).toContain('checklist_violation');
    expect(critic).toContain('generic_direct_answer');
    expect(critic).toContain('C5)');
    const g = mockSeq(DRAFT, { defects: [{ type: 'generic_direct_answer', problem: 'الجواب المباشر عام', fix: 'ابدأ بفى حالتك' }, { type: 'checklist_violation', problem: 'C2 مخالف', fix: 'اجعل المهلة على صاحب العمل' }] }, FIXED);
    await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    const revise = JSON.parse(g.mock.calls[2][1].body).messages[1].content as string;
    expect(revise).toContain('generic_direct_answer');
    expect(revise).toContain('checklist_violation');
  });

  it('2j: قائمة الفحص داخل المسار — فى وضع المستحقات يُضاف نص المادة 125 حرفياً إن تجاهلها النموذج فى الجولتين', async () => {
    const A125 = 'يستحق العامل مقابل رصيد إجازاته السنوية عند انتهاء علاقة العمل. ويصرف له عند التسوية.';
    const dues = {
      question: 'انتهى عقدى ولم أستلم مستحقاتى فماذا أفعل؟',
      articles: [
        { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 154, articleText: ART_TEXT },
        { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 125, articleText: A125 },
      ],
    };
    const EMPTY = { rulings: [], scenarios: [], warnings: [], skipped: [] };
    const f = mockSeq(GOOD, EMPTY, EMPTY);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(dues);
    expect(f).toHaveBeenCalledTimes(3);
    expect(r.status).toBe('ok');
    if (r.status !== 'ok') return;
    expect(r.structured.rulings).toHaveLength(2);
    expect(r.structured.rulings[1]).toMatchObject({
      kind: 'نص',
      quote_verified: true,
      citation_index: 1,
      quote: 'يستحق العامل مقابل رصيد إجازاته السنوية عند انتهاء علاقة العمل.',
    });
  });

  it('2j: مفتاح STRUCTURED_CHECKLIST_ENABLED=false يعطّل القائمة', async () => {
    process.env.STRUCTURED_CHECKLIST_ENABLED = 'false';
    try {
      const A125 = 'يستحق العامل مقابل رصيد إجازاته السنوية عند انتهاء علاقة العمل.';
      const dues = {
        question: 'انتهى عقدى ولم أستلم مستحقاتى فماذا أفعل؟',
        articles: [
          { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 154, articleText: ART_TEXT },
          { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 125, articleText: A125 },
        ],
      };
      const EMPTY = { rulings: [], scenarios: [], warnings: [], skipped: [] };
      mockSeq(GOOD, EMPTY, EMPTY);
      const r = await new DeepseekGenerationService().composeStructuredAnswer(dues);
      expect(r.status === 'ok' && r.structured.rulings).toHaveLength(1);
    } finally {
      delete process.env.STRUCTURED_CHECKLIST_ENABLED;
    }
  });

  it('واقعة سُئل عنها وأُجيب عنها لا تعود فى facts_to_confirm', async () => {
    mockSeq(GOOD, { defects: [] });
    const r = await new DeepseekGenerationService().composeStructuredAnswer(FACTS_Q);
    expect(r.status === 'ok' && r.structured.facts_to_confirm).toEqual([]);
  });

  it('محلل الاستيضاح: قاعدة المقادير بوحدتها الصريحة فى تعليمات النظام', async () => {
    const f = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify({ needs_clarification: false }))));
    global.fetch = f as unknown as typeof fetch;
    await new DeepseekGenerationService().detectClarification({ question: 'س', history: [], articles: INPUT.articles });
    expect(JSON.parse(f.mock.calls[0][1].body).messages[0].content).toContain('بوحدته الصريحة');
  });

  it('2j: محلل الاستيضاح يسأل عن طريقة إبلاغ الإنهاء وسببه واستلام المستحقات فى أسئلة انتهاء العلاقة', async () => {
    const f = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify({ needs_clarification: false }))));
    global.fetch = f as unknown as typeof fetch;
    await new DeepseekGenerationService().detectClarification({ question: 'س', history: [], articles: INPUT.articles });
    const sys = JSON.parse(f.mock.calls[0][1].body).messages[0].content as string;
    expect(sys).toContain('كيف أُبلغ العامل بالإنهاء');
    expect(sys).toContain('السبب الذى أعلنه صاحب العمل');
    expect(sys).toContain('هل تسلّم مستحقاته');
  });
});

describe('DeepseekGenerationService.composeStructuredAnswer — إعادة المحاولة الذكية', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;
  const NO_DIRECT = { ...GOOD, direct_answer: '' };
  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    delete process.env.STRUCTURED_MAX_ATTEMPTS;
  });
  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    delete process.env.STRUCTURED_MAX_ATTEMPTS;
    jest.restoreAllMocks();
  });
  const seq = (...items: Array<unknown | 'HTTP500'>) => {
    const f = jest.fn();
    for (const it of items) {
      f.mockResolvedValueOnce(it === 'HTTP500' ? jsonResponse(500, {}) : jsonResponse(200, completion(JSON.stringify(it))));
    }
    global.fetch = f as unknown as typeof fetch;
    return f;
  };

  it('direct_answer غائب فى المحاولة الأولى ← محاولة ثانية بملاحظة السبب تنجح (لا سقوط للمسار القديم)', async () => {
    const f = seq(NO_DIRECT, GOOD);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(r.status).toBe('ok');
    expect(f).toHaveBeenCalledTimes(2);
    const second = JSON.parse(f.mock.calls[1][1].body).messages[1].content as string;
    expect(second).toContain('missing_direct_answer');
    expect(second).toContain('direct_answer');
    expect(JSON.parse(f.mock.calls[0][1].body).messages[1].content).not.toContain('إخراجك السابق مرفوض');
  });

  it('خطأ API عابر (500) ثم نجاح', async () => {
    const f = seq('HTTP500', GOOD);
    expect((await new DeepseekGenerationService().composeStructuredAnswer(INPUT)).status).toBe('ok');
    expect(f).toHaveBeenCalledTimes(2);
  });

  it('رقم مادة غير مرسَل ← إعادة بملاحظة الأرقام المسموح بها', async () => {
    const BAD = { ...GOOD, direct_answer: 'يستحق مكافأة طبقاً للمادة 999 من القانون.' };
    const f = seq(BAD, GOOD);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(r.status).toBe('ok');
    const note = JSON.parse(f.mock.calls[1][1].body).messages[1].content as string;
    expect(note).toContain('999');
    expect(note).toContain('154');
  });

  it('استنفاد المحاولات (الافتراضى 2) يُعيد آخر حالة فشل ليرجع المتصل للمسار القديم', async () => {
    const f = seq(NO_DIRECT, NO_DIRECT, GOOD);
    const r = await new DeepseekGenerationService().composeStructuredAnswer(INPUT);
    expect(r).toEqual({ status: 'invalid_structure', reason: 'missing_direct_answer' });
    expect(f).toHaveBeenCalledTimes(2);
  });

  it('STRUCTURED_MAX_ATTEMPTS: 1 يعطّل الإعادة، و3 يسمح بثالثة، وغير الصالح = 2', async () => {
    process.env.STRUCTURED_MAX_ATTEMPTS = '1';
    let f = seq(NO_DIRECT, GOOD);
    expect((await new DeepseekGenerationService().composeStructuredAnswer(INPUT)).status).toBe('invalid_structure');
    expect(f).toHaveBeenCalledTimes(1);
    process.env.STRUCTURED_MAX_ATTEMPTS = '3';
    f = seq(NO_DIRECT, NO_DIRECT, GOOD);
    expect((await new DeepseekGenerationService().composeStructuredAnswer(INPUT)).status).toBe('ok');
    process.env.STRUCTURED_MAX_ATTEMPTS = 'x';
    f = seq(NO_DIRECT, NO_DIRECT, GOOD);
    expect((await new DeepseekGenerationService().composeStructuredAnswer(INPUT)).status).toBe('invalid_structure');
    expect(f).toHaveBeenCalledTimes(2);
  });

  it('not_configured لا يُعاد ولا fetch', async () => {
    delete process.env.DEEPSEEK_API_KEY;
    const f = jest.fn();
    global.fetch = f as unknown as typeof fetch;
    expect(await new DeepseekGenerationService().composeStructuredAnswer(INPUT)).toEqual({ status: 'not_configured' });
    expect(f).not.toHaveBeenCalled();
  });
});

describe('DeepseekGenerationService.detectClarification — قواعد الصياغة (تقييم حى 3.5/10)', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;
  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
  });
  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    jest.restoreAllMocks();
  });
  it('الحد العددى يُقسَّم (أقل/بالضبط/أكثر)، وسؤال طبيعة العمل يتقدم ولا يُسقَط، وحتى 12 نصاً تُعرَض', async () => {
    const f = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify({ needs_clarification: false }))));
    global.fetch = f as unknown as typeof fetch;
    const many = Array.from({ length: 13 }, (_, i) => ({
      lawTitle: 'ق', lawNo: 14, lawYear: 2025, articleNo: 100 + i, articleText: `نص رقم ${i}`,
    }));
    await new DeepseekGenerationService().detectClarification({ question: 'س', history: [], articles: many });
    const body = JSON.parse(f.mock.calls[0][1].body);
    const sys = body.messages[0].content as string;
    expect(sys).toContain('الحد بالضبط');
    expect(sys).toContain('طبيعة العمل مستمرة');
    expect(sys).toContain('فلا تُسقِط سؤال طبيعة العمل');
    const user = body.messages[1].content as string;
    expect(user).toContain('المادة 111');
    expect(user).not.toContain('المادة 112');
  });
});
