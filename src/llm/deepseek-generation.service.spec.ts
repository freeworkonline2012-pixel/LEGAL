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

/**
 * 2026-09-24: اختبارات decomposeQuestion — الإصلاح الجذري الثاني بعد التحقق
 * الحي الذي كشف أن expandWithCrossReferences وحدها لا تكفي لسؤال مُركَّب
 * يحتاج شِقّين قانونيين منفصلين تماماً (راجع تعليق الدالة الكامل فى
 * deepseek-generation.service.ts). يختبر هنا: التقسيم الفعلي، عدم التقسيم
 * لسؤال بسيط، fail-open الكامل (not_configured/HTTP error/JSON غير صالح)،
 * وأن الحد الأقصى MAX_SUBQUESTIONS=3 يُطبَّق فعلياً.
 */
describe('DeepseekGenerationService.decomposeQuestion', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;

  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    jest.restoreAllMocks();
  });

  it('يُرجِع not_configured بلا أى استدعاء fetch عند غياب DEEPSEEK_API_KEY', async () => {
    delete process.env.DEEPSEEK_API_KEY;
    const service = new DeepseekGenerationService();
    const fetchMock = jest.fn();
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.decomposeQuestion('سؤال تجريبى');

    expect(fetchMock).not.toHaveBeenCalled();
    expect(result).toEqual({ status: 'not_configured' });
  });

  it(
    'يُقسِّم سؤالاً مُركَّباً فعلياً إلى سؤالين فرعيين (نفس السيناريو الحى: ' +
      'عقد مؤقت مقابل عقد غير محدد المدة)',
    async () => {
      process.env.DEEPSEEK_API_KEY = 'test-key';
      const service = new DeepseekGenerationService();
      const subQuestions = [
        'ما حقوق الموظف الذى لديه عقد عمل مؤقت يُجدَّد سنوياً وأفادت الشركة برغبتها فى عدم تجديده؟',
        'هل تختلف تلك الحقوق لو كان العقد غير محدد المدة؟',
      ];
      const fetchMock = jest
        .fn()
        .mockResolvedValueOnce(
          jsonResponse(200, chatCompletion(JSON.stringify({ subQuestions }), 'stop')),
        );
      global.fetch = fetchMock as unknown as typeof fetch;

      const result = await service.decomposeQuestion(
        'ما حقوق الموظف الذى لديه عقد عمل مؤقت يُجدَّد سنوياً وبعد عدة سنوات ' +
          'أفادت الشركة برغبتها فى عدم تجديد العقد؟ وهل تختلف تلك الحقوق لو ' +
          'كان العقد غير محدد المدة؟',
      );

      expect(fetchMock).toHaveBeenCalledTimes(1);
      expect(result).toEqual({ status: 'ok', subQuestions });
    },
  );

  it('لا يُقسِّم سؤالاً بسيطاً — subQuestions بعنصر واحد فقط', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce(
        jsonResponse(
          200,
          chatCompletion(JSON.stringify({ subQuestions: ['ما هى مدة الإجازة السنوية؟'] }), 'stop'),
        ),
      );
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.decomposeQuestion('ما هى مدة الإجازة السنوية؟');

    expect(result).toEqual({ status: 'ok', subQuestions: ['ما هى مدة الإجازة السنوية؟'] });
  });

  it('يحدّ subQuestions بـ3 عناصر كحد أقصى حتى لو أرجع النموذج أكثر', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    const fetchMock = jest.fn().mockResolvedValueOnce(
      jsonResponse(
        200,
        chatCompletion(JSON.stringify({ subQuestions: ['س1', 'س2', 'س3', 'س4', 'س5'] }), 'stop'),
      ),
    );
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.decomposeQuestion('سؤال تجريبى مُركَّب جداً');

    expect(result).toEqual({ status: 'ok', subQuestions: ['س1', 'س2', 'س3'] });
  });

  it('يُرجِع unparseable_json عند رد بلا حقل subQuestions صالح', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce(jsonResponse(200, chatCompletion('{"foo": "bar"}', 'stop')));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.decomposeQuestion('سؤال تجريبى');

    expect(result).toEqual({ status: 'error', detail: 'unparseable_json' });
  });

  it('يُرجِع empty_response عند content فارغ بلا إعادة محاولة (لا منطق retry هنا)', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, chatCompletion(null, 'stop')));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.decomposeQuestion('سؤال تجريبى');

    expect(fetchMock).toHaveBeenCalledTimes(1);
    expect(result).toEqual({ status: 'error', detail: 'empty_response' });
  });

  it('لا يُعيد المحاولة عند خطأ HTTP — يُرجِع فوراً', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(500, { detail: 'server error' }));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.decomposeQuestion('سؤال تجريبى');

    expect(fetchMock).toHaveBeenCalledTimes(1);
    expect(result).toEqual({ status: 'error', detail: 'http_500' });
  });
});
