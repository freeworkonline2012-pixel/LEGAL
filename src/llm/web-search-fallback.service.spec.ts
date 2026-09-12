import { WEB_FALLBACK_DISCLAIMER, WebSearchFallbackService } from './web-search-fallback.service';

/**
 * اختبار وحدة لـ WebSearchFallbackService — يغطى تحديداً الضوابط الآمنة
 * الموثَّقة فى تعليق الملف نفسه (fail-closed بلا مفتاح، تقييد النطاق
 * allowlist، إلحاق التنويه الإلزامى)، وليس اتصال شبكة حقيقياً (نفس نهج
 * voyage-embeddings.spec.ts). "لا تُقر بأن شيئاً يعمل إلا إذا اختبرته
 * بنفسك" — هذا الملف هو ذلك الاختبار الفعلى لضوابط الأمان تحديداً، لا مجرد
 * افتراض أن التعليقات التوثيقية كافية.
 */

function jsonResponse(status: number, body: unknown) {
  return {
    ok: status >= 200 && status < 300,
    status,
    text: async () => JSON.stringify(body),
    json: async () => body,
  } as unknown as Response;
}

describe('WebSearchFallbackService', () => {
  const originalFetch = global.fetch;
  const env = { ...process.env };

  afterEach(() => {
    global.fetch = originalFetch;
    process.env = { ...env };
    jest.restoreAllMocks();
  });

  it('لا تُجرى أى اتصال شبكة إن لم تُفعَّل ENABLE_WEB_FALLBACK (fail-closed بالافتراضى)', async () => {
    delete process.env.ENABLE_WEB_FALLBACK;
    process.env.WEB_SEARCH_API_KEY = 'test-key';
    const fetchSpy = jest.fn();
    global.fetch = fetchSpy as unknown as typeof fetch;

    const service = new WebSearchFallbackService();
    expect(service.isConfigured).toBe(false);

    const result = await service.tryWebFallback('سؤال ما', async () => 'إجابة وهمية');
    expect(result).toBeNull();
    expect(fetchSpy).not.toHaveBeenCalled();
  });

  it('لا تُجرى أى اتصال شبكة إن غاب WEB_SEARCH_API_KEY حتى لو كانت مفعَّلة', async () => {
    process.env.ENABLE_WEB_FALLBACK = 'true';
    delete process.env.WEB_SEARCH_API_KEY;
    const fetchSpy = jest.fn();
    global.fetch = fetchSpy as unknown as typeof fetch;

    const service = new WebSearchFallbackService();
    expect(service.isConfigured).toBe(false);

    const result = await service.tryWebFallback('سؤال ما', async () => 'إجابة وهمية');
    expect(result).toBeNull();
    expect(fetchSpy).not.toHaveBeenCalled();
  });

  it('تستبعد نتائج خارج نطاق allowlist ولا تُرجع نتيجة لو كل الروابط خارجه', async () => {
    process.env.ENABLE_WEB_FALLBACK = 'true';
    process.env.WEB_SEARCH_API_KEY = 'test-key';
    process.env.WEB_FALLBACK_ALLOWED_DOMAINS = 'fra.gov.eg';

    global.fetch = jest.fn().mockResolvedValue(
      jsonResponse(200, {
        organic: [
          { title: 'نتيجة غير موثوقة', link: 'https://random-blog.example.com/post', snippet: 'نص' },
        ],
      }),
    ) as unknown as typeof fetch;

    const generateAnswer = jest.fn().mockResolvedValue('لن يُستدعى');
    const service = new WebSearchFallbackService();
    const result = await service.tryWebFallback('ما هو الحد الأقصى؟', generateAnswer);

    expect(result).toBeNull();
    expect(generateAnswer).not.toHaveBeenCalled();
  });

  it('تقبل نتائج fra.gov.eg (ضمن allowlist)، وتُلحق التنويه الإلزامى بالإجابة المولَّدة', async () => {
    process.env.ENABLE_WEB_FALLBACK = 'true';
    process.env.WEB_SEARCH_API_KEY = 'test-key';
    process.env.WEB_FALLBACK_ALLOWED_DOMAINS = 'fra.gov.eg';

    global.fetch = jest.fn().mockResolvedValue(
      jsonResponse(200, {
        organic: [
          {
            title: 'قرار مجلس إدارة الهيئة رقم 98 لسنة 2023',
            link: 'https://fra.gov.eg/portals/microfinance/companies/pdf/FBD-2023-98-ar.pdf',
            snippet: 'زيادة الحد الأقصى للتمويل...',
          },
          { title: 'نتيجة غير موثوقة', link: 'https://random-blog.example.com/post', snippet: 'نص' },
        ],
      }),
    ) as unknown as typeof fetch;

    const generateAnswer = jest.fn().mockResolvedValue('الحد الأقصى الحالى المعروف هو كذا [1]');
    const service = new WebSearchFallbackService();
    const result = await service.tryWebFallback('ما هو الحد الأقصى؟', generateAnswer);

    expect(result).not.toBeNull();
    expect(result?.sources).toHaveLength(1);
    expect(result?.sources[0].url).toContain('fra.gov.eg');
    expect(result?.answer.endsWith(WEB_FALLBACK_DISCLAIMER)).toBe(true);
    expect(generateAnswer).toHaveBeenCalledTimes(1);
  });

  it('fail-closed آمن عند فشل استدعاء الشبكة (لا يُسرَّب أى استثناء للمستدعى)', async () => {
    process.env.ENABLE_WEB_FALLBACK = 'true';
    process.env.WEB_SEARCH_API_KEY = 'test-key';

    global.fetch = jest.fn().mockRejectedValue(new Error('network down')) as unknown as typeof fetch;

    const service = new WebSearchFallbackService();
    const result = await service.tryWebFallback('سؤال ما', async () => 'إجابة');
    expect(result).toBeNull();
  });

  it('fail-closed آمن لو لم يُرجع مولِّد الإجابة نصاً (مثلاً DeepSeek غير مُهيَّأ)', async () => {
    process.env.ENABLE_WEB_FALLBACK = 'true';
    process.env.WEB_SEARCH_API_KEY = 'test-key';
    process.env.WEB_FALLBACK_ALLOWED_DOMAINS = 'fra.gov.eg';

    global.fetch = jest.fn().mockResolvedValue(
      jsonResponse(200, {
        organic: [{ title: 'قرار', link: 'https://fra.gov.eg/x.pdf', snippet: 'نص' }],
      }),
    ) as unknown as typeof fetch;

    const service = new WebSearchFallbackService();
    const result = await service.tryWebFallback('سؤال ما', async () => null);
    expect(result).toBeNull();
  });
});
