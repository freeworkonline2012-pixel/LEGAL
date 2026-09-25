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

/**
 * 2026-09-25 (إصلاح جذرى سادس — راجع تعليق findHallucinatedArticleCitations
 * فى deepseek-generation.service.ts للتشخيص الكامل): دليل حى مباشر أن
 * composeGroundedAnswerMulti استشهد بـ"المادة 11" لنص المادة 175 الفعلى بعد
 * دمج 11 مادة فى استدعاء توليد واحد — الاسترجاع كان صحيحاً 100%، والعطل فى
 * خطوة الصياغة وحدها. هذه الاختبارات تُشغِّل بوابة التحقق الحتمية الجديدة
 * فعلياً (لا تقرأ الكود قراءة ثابتة فقط) للتأكد أنها تكتشف بالضبط هذا النمط
 * وتُرجِع null بدل تمرير استشهاد خاطئ للمستخدم — طبقاً لقاعدة "التحقق قبل
 * القول".
 */
describe('DeepseekGenerationService — بوابة رفض الاستشهاد بأرقام مواد غير مرسَلة (composeGroundedAnswer)', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;

  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    jest.restoreAllMocks();
  });

  it('يُرجِع النص كما هو حين يستشهد فقط برقم المادة المرسَلة فعلياً', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    const fetchMock = jest.fn().mockResolvedValueOnce(
      jsonResponse(200, chatCompletion('طبقاً للمادة 1 من قانون تجريبى (رقم 1 لسنة 2020)...', 'stop')),
    );
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.composeGroundedAnswer({
      question: 'سؤال تجريبى',
      ...CANDIDATE,
    });

    expect(result).toBe('طبقاً للمادة 1 من قانون تجريبى (رقم 1 لسنة 2020)...');
  });

  it(
    'يُرجِع null (fail-safe) حين يستشهد بمادة غير المادة الوحيدة المرسَلة — نفس نمط ' +
      'عطل المادة 11/175 الحى بالضبط',
    async () => {
      process.env.DEEPSEEK_API_KEY = 'test-key';
      const service = new DeepseekGenerationService();
      const fetchMock = jest.fn().mockResolvedValueOnce(
        jsonResponse(
          200,
          chatCompletion('طبقاً للمادة 175 من قانون تجريبى، يلتزم صاحب العمل بمنح شهادة خبرة...', 'stop'),
        ),
      );
      global.fetch = fetchMock as unknown as typeof fetch;

      // CANDIDATE.articleNo === 1 — النص المُولَّد يستشهد بـ175 بدلاً منها.
      const result = await service.composeGroundedAnswer({
        question: 'سؤال تجريبى',
        ...CANDIDATE,
      });

      expect(result).toBeNull();
      expect(fetchMock).toHaveBeenCalledTimes(1); // لا إعادة محاولة — fail-safe فورى.
    },
  );
});

describe('DeepseekGenerationService — بوابة رفض الاستشهاد بأرقام مواد غير مرسَلة (composeGroundedAnswerMulti)', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;

  const ARTICLES = [
    { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 108, articleText: 'نص المادة 108.' },
    { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 125, articleText: 'نص المادة 125.' },
    { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 175, articleText: 'نص المادة 175.' },
  ];

  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    jest.restoreAllMocks();
  });

  it('يُرجِع النص كما هو حين تُطابق كل أرقام المواد المذكورة المواد المرسَلة فعلياً', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    const text = 'طبقاً للمادة 108 والمادة 125 والمادة 175 من قانون العمل (2025)...';
    const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, chatCompletion(text, 'stop')));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.composeGroundedAnswerMulti({ question: 'سؤال تجريبى', articles: ARTICLES });

    expect(result).toBe(text);
  });

  it(
    'يُرجِع null (fail-safe) حين يستشهد بمادة غير موجودة ضمن المواد المرسَلة فعلياً — ' +
      'إعادة إنتاج مباشرة لعطل "المادة 11" بدل "المادة 175" المُكتشَف حياً 2026-09-25',
    async () => {
      process.env.DEEPSEEK_API_KEY = 'test-key';
      const service = new DeepseekGenerationService();
      const text =
        'طبقاً للمادة 108 من قانون العمل (2025)... وبموجب المادة 11 يلتزم صاحب العمل ' +
        'بمنح العامل شهادة خبرة عند انتهاء علاقة العمل...'; // 11 ليست ضمن ARTICLES — هلوسة.
      const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, chatCompletion(text, 'stop')));
      global.fetch = fetchMock as unknown as typeof fetch;

      const result = await service.composeGroundedAnswerMulti({ question: 'سؤال تجريبى', articles: ARTICLES });

      expect(result).toBeNull();
      expect(fetchMock).toHaveBeenCalledTimes(1);
    },
  );

  it('لا يُطابق ذكر "المواد" (جمع) عرضاً كاستشهاد مفرد قابل للتحقق (لا إيجابية كاذبة)', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    // "المواد" هنا سياق عام لا استشهاد برقم مادة بعينها — لا يجوز أن يُسقِط
    // البوابة إجابة سليمة بسبب هذا النمط (راجع تعليق findHallucinatedArticleCitations:
    // الفحص عمداً يطابق "المادة"/"ماده" المفرد فقط لتفادى إيجابيات كاذبة).
    const text = 'طبقاً للمادة 108 من قانون العمل (2025)، مع مراعاة المواد الأخرى ذات الصلة.';
    const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, chatCompletion(text, 'stop')));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.composeGroundedAnswerMulti({ question: 'سؤال تجريبى', articles: ARTICLES });

    expect(result).toBe(text);
  });
});

/**
 * 2026-09-25T16:54: إصلاح جذرى سابع — راجع تعليق computeValidCitationNumbers
 * فى deepseek-generation.service.ts للتشخيص الكامل. القياس الحى الأول لبوابة
 * الإصلاح السادس (أعلاه) اكتشف إيجابية كاذبة: نص المادة 150 الحقيقى (راجع
 * migrations/003_seed_real_laws.sql) يُحيل صراحة داخل محتواه لمادة 143
 * ("...مع مراعاة نص المادة ) (١٤٣من هذا القانون...")، والنموذج نقل هذه
 * الإحالة بأمانة طبقاً لتعليمة system prompt الصريحة بذلك — فرفضته البوابة
 * القديمة خطأً باعتباره هلوسة. هذان الاختباران يعيدان إنتاج العطل بالضبط
 * (نص مادة يحتوى إحالة صريحة بصيغة قوس معكوس حقيقية) ويتحققان من أن الإصلاح
 * السابع يقبلها، مع التأكد أن رقماً غير مرتبط بأى إحالة فعلية لا يزال يُرفَض.
 */
describe('DeepseekGenerationService — الإصلاح السابع: لا ترفض البوابة إحالة صريحة داخل نص مادة مرفقة', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.DEEPSEEK_API_KEY;

  // نص المادة 150 الحقيقى (مُقتطَف، بنفس صيغة القوس المعكوس الحقيقية فى قاعدة
  // البيانات) — يُحيل صراحة لمادة 143.
  const ARTICLE_150_TEXT =
    'وتخصم المبالغ التى استوفاها العامل نفاذاً لقرار المحكمة من مبلغ التعويض ' +
    'الذى يحكم به أو أى مبالغ أخرى مستحقة له قبل صاحب العمل،مع مراعاة نص ' +
    'المادة ) (١٤٣من هذا القانون.';
  const ARTICLES_WITH_150 = [
    { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 108, articleText: 'نص المادة 108.' },
    { lawTitle: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 150, articleText: ARTICLE_150_TEXT },
  ];

  afterEach(() => {
    global.fetch = originalFetch;
    process.env.DEEPSEEK_API_KEY = originalKey;
    jest.restoreAllMocks();
  });

  it(
    'يقبل استشهاداً بمادة 143 حين يكون مذكوراً كإحالة صريحة داخل نص المادة 150 المرفقة ' +
      '— إعادة إنتاج مباشرة للإيجابية الكاذبة المُكتشَفة حياً بتوقيت 2026-09-25T16:54',
    async () => {
      process.env.DEEPSEEK_API_KEY = 'test-key';
      const service = new DeepseekGenerationService();
      const text =
        'طبقاً للمادة 108 من قانون العمل (2025)... وطبقاً للمادة 150 يُحال النزاع ' +
        'للمحكمة العمالية، مع مراعاة المادة 143 بشأن خصم المبالغ المستوفاة سلفاً.';
      const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, chatCompletion(text, 'stop')));
      global.fetch = fetchMock as unknown as typeof fetch;

      const result = await service.composeGroundedAnswerMulti({
        question: 'سؤال تجريبى',
        articles: ARTICLES_WITH_150,
      });

      expect(result).toBe(text);
    },
  );

  it('يظل يرفض (fail-safe) استشهاداً برقم لا صلة له إطلاقاً حتى مع تفعيل توسيع الإحالات', async () => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    // 999 ليست المادة الأساسية (108 أو 150) ولا إحالة داخل نص المادة 150 — هلوسة حقيقية.
    const text = 'طبقاً للمادة 108... وطبقاً للمادة 999 يلتزم صاحب العمل بكذا.';
    const fetchMock = jest.fn().mockResolvedValueOnce(jsonResponse(200, chatCompletion(text, 'stop')));
    global.fetch = fetchMock as unknown as typeof fetch;

    const result = await service.composeGroundedAnswerMulti({
      question: 'سؤال تجريبى',
      articles: ARTICLES_WITH_150,
    });

    expect(result).toBeNull();
    expect(fetchMock).toHaveBeenCalledTimes(1);
  });
});
