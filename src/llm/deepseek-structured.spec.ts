import { DeepseekGenerationService } from './deepseek-generation.service';

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
  });
  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
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
        quote: 'يبرم عقد العمل الفردى لمدة غير محددة',
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
    expect(JSON.parse(plain.mock.calls[0][1].body).messages[0].content).not.toContain('وقائع السائل (إلزامية)');

    const enriched = jest.fn().mockResolvedValueOnce(jsonResponse(200, completion(JSON.stringify(GOOD))));
    global.fetch = enriched as unknown as typeof fetch;
    await svc.composeStructuredAnswer({
      ...INPUT,
      question: `${INPUT.question}\n\n[توضيحات السائل]\n- ما نوع العقد؟ ← محدد المدة`,
    });
    expect(JSON.parse(enriched.mock.calls[0][1].body).messages[0].content).toContain('وقائع السائل (إلزامية)');
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
