import { DeepseekGenerationService } from './deepseek-generation.service';

/**
 * 2026-09-19: أول اختبار وحدة لـ assessCompliance فى DeepseekGenerationService
 * — أُضيف مباشرة بعد اكتشاف (بأدلة من عيّنتين تشخيصيتين حيّتين متتاليتين على
 * إنتاج Railway الفعلى، لا افتراضاً) أن رفع max_tokens من 1000 لـ2500 لم
 * يُصلح فشل unparseable_json (بل زاد معدله 18%→25.6%)، وأن السبب الحقيقى
 * المؤكَّد عبر حقل finish_reason الجديد هو عدم-حتمية فعلية فى خدمة DeepSeek
 * رغم temperature:0 (نفس المدخل الحرفى ينجح فى محاولة ويفشل فى أخرى). الإصلاح
 * الجذرى المطبَّق هو إعادة محاولة محدودة (حد أقصى محاولتان) عند
 * unparseable_json/empty_response تحديداً. هذا الملف يختبر تلك الحلقة فعلياً
 * — لا يُقر بأنها "تعمل" دون تشغيلها هنا، طبقاً لقاعدة المشروع "لا تُقر بأن
 * شيئاً يعمل إلا إذا اختبرته بنفسك".
 */

function jsonResponse(status: number, body: unknown) {
  return {
    ok: status >= 200 && status < 300,
    status,
    text: async () => JSON.stringify(body),
    json: async () => body,
  } as unknown as Response;
}

function chatCompletion(content: string | null, finishReason: string) {
  return {
    choices: [
      {
        message: { content, reasoning_content: '' },
        finish_reason: finishReason,
      },
    ],
  };
}

const CANDIDATE = {
  lawTitle: 'قانون تجريبى',
  lawNo: 1,
  lawYear: 2020,
  articleNo: 1,
  articleText: 'نص تجريبى للاختبار فقط.',
};

const VALID_VERDICT_JSON = JSON.stringify({
  risk_note: 'ملاحظة تجريبية.',
  selected: [1],
  verdict: 'متوافق',
  conditions: [],
  confidence: 0.9,
});

const TRUNCATED_JSON = '{"risk_note": "ملاحظة تجريبية بلا بقية الحقول"';

describe('DeepseekGenerationService.assessCompliance', () => {
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

  it(
    'ينجح فى المحاولة الثانية عند unparseable_json فى الأولى (finish_reason=stop فى كلتيهما)، ' +
      'ولا يُجرى أكثر من محاولتين',
    async () => {
      const service = new DeepseekGenerationService();
      const fetchMock = jest
        .fn()
        .mockResolvedValueOnce(jsonResponse(200, chatCompletion(TRUNCATED_JSON, 'stop')))
        .mockResolvedValueOnce(jsonResponse(200, chatCompletion(VALID_VERDICT_JSON, 'stop')));
      global.fetch = fetchMock as unknown as typeof fetch;

      const result = await service.assessCompliance({
        question: 'سؤال تجريبى',
        candidates: [CANDIDATE],
      });

      expect(fetchMock).toHaveBeenCalledTimes(2);
      expect(result).toEqual({
        status: 'ok',
        verdict: 'متوافق',
        selectedIndices: [0],
        riskNote: 'ملاحظة تجريبية.',
        conditions: [],
        confidence: 0.9,
      });
    },
  );

  it('يُرجِع unparseable_json بعد فشل محاولتين متتاليتين (لا محاولة ثالثة)', async () => {
    const service = new DeepseekGenerationService();
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, chatCompletion(TRUNCATED_JSON, 'stop')))
      .mockResolvedValueOnce(jsonResponse(200, chatCompletion(TRUNCATED_JSON, 'stop')));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.assessCompliance({
      question: 'سؤال تجريبى',
      candidates: [CANDIDATE],
    });

    expect(fetchMock).toHaveBeenCalledTimes(2);
    expect(result).toEqual({ status: 'error', detail: 'unparseable_json' });
  });

  it('ينجح فى المحاولة الثانية عند empty_response فى الأولى', async () => {
    const service = new DeepseekGenerationService();
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, chatCompletion(null, 'stop')))
      .mockResolvedValueOnce(jsonResponse(200, chatCompletion(VALID_VERDICT_JSON, 'stop')));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.assessCompliance({
      question: 'سؤال تجريبى',
      candidates: [CANDIDATE],
    });

    expect(fetchMock).toHaveBeenCalledTimes(2);
    expect(result.status).toBe('ok');
  });

  it('ينجح من أول محاولة بلا أى إعادة محاولة عند رد صالح مباشرة', async () => {
    const service = new DeepseekGenerationService();
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, chatCompletion(VALID_VERDICT_JSON, 'stop')));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.assessCompliance({
      question: 'سؤال تجريبى',
      candidates: [CANDIDATE],
    });

    expect(fetchMock).toHaveBeenCalledTimes(1);
    expect(result.status).toBe('ok');
  });

  it('لا يُعيد المحاولة عند خطأ HTTP (مثل http_500) — يُرجِع فوراً من أول محاولة', async () => {
    const service = new DeepseekGenerationService();
    const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(500, { detail: 'server error' }));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.assessCompliance({
      question: 'سؤال تجريبى',
      candidates: [CANDIDATE],
    });

    expect(fetchMock).toHaveBeenCalledTimes(1);
    expect(result).toEqual({ status: 'error', detail: 'http_500' });
  });
});
