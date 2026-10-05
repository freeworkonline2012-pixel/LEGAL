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
