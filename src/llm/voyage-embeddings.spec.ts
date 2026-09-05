import { VoyageEmbeddingsService } from './voyage-embeddings.service';

/**
 * 2026-09-05: أول اختبار وحدة لـ VoyageEmbeddingsService — أُضيف مباشرة بعد
 * اكتشاف (بأدلة من سجلّات Railway الفعلية لقياس دقة خدمة الحوكمة، لا افتراضاً)
 * أن حساب Voyage بلا وسيلة دفع مسجَّلة يُقيَّد بـ3 RPM، فيرجع rerank()/embed()
 * null فى كل الاستدعاءات 36/36 لتلك التجربة — وهذا هو السبب الجذرى المؤكَّد
 * وراء تدهور دقة خدمة الحوكمة (44%/29%)، وليس عيباً فى منطق LLM القرار. هذا
 * الملف يختبر التحصين المضاف (إعادة محاولة محدودة عند 429 + عدّادات تدهور
 * مرئية) — لا يُقر بأنه "يعمل" دون تشغيله فعلياً هنا، طبقاً لقاعدة المشروع
 * "لا تُقر بأن شيئاً يعمل إلا إذا اختبرته بنفسك".
 *
 * retrieval.spec.ts وثّق سابقاً أن اختبارات fetch/rerank خارج نطاق دفعته
 * الأولى عمداً — هذا الملف يسدّ تلك الفجوة تحديداً لأول مرة.
 */

function jsonResponse(status: number, body: unknown, headers: Record<string, string> = {}) {
  return {
    ok: status >= 200 && status < 300,
    status,
    headers: { get: (name: string) => headers[name.toLowerCase()] ?? null },
    text: async () => JSON.stringify(body),
    json: async () => body,
  } as unknown as Response;
}

describe('VoyageEmbeddingsService', () => {
  const originalFetch = global.fetch;
  const originalKey = process.env.VOYAGE_API_KEY;

  beforeEach(() => {
    process.env.VOYAGE_API_KEY = 'test-key';
    jest.useFakeTimers();
  });

  afterEach(() => {
    global.fetch = originalFetch;
    process.env.VOYAGE_API_KEY = originalKey;
    jest.useRealTimers();
    jest.restoreAllMocks();
  });

  describe('rerank — إعادة المحاولة عند 429', () => {
    it('ينجح بعد إعادة محاولة واحدة عند 429، ولا يزيد عدّاد الفشل النهائى', async () => {
      const service = new VoyageEmbeddingsService();
      const fetchMock = jest
        .fn()
        .mockResolvedValueOnce(jsonResponse(429, { detail: 'rate limited' }))
        .mockResolvedValueOnce(
          jsonResponse(200, { results: [{ index: 0, relevance_score: 0.9 }] }),
        );
      global.fetch = fetchMock as unknown as typeof fetch;

      const resultPromise = service.rerank('سؤال', ['مادة 1']);
      // نتقدّم بالوقت الوهمي بدل انتظار التراجع الأُسّى فعلياً — يتحقق من
      // *سلوك* إعادة المحاولة (تحدث، وتُفضي لنجاح) بلا إبطاء تنفيذ الاختبار.
      await jest.advanceTimersByTimeAsync(10_000);
      const result = await resultPromise;

      expect(fetchMock).toHaveBeenCalledTimes(2);
      expect(result).toEqual([{ index: 0, relevanceScore: 0.9 }]);
      expect(service.getDegradationStats().rerank_rate_limit_count).toBe(0);
      expect(service.getDegradationStats().rerank_failure_count).toBe(0);
    });

    it('يستسلم بعد استنفاد إعادات المحاولة عند 429 المستمر، ويُسجِّل ذلك فى عدّاد rerank_rate_limit_count', async () => {
      const service = new VoyageEmbeddingsService();
      const fetchMock = jest.fn().mockResolvedValue(jsonResponse(429, { detail: 'rate limited' }));
      global.fetch = fetchMock as unknown as typeof fetch;

      const resultPromise = service.rerank('سؤال', ['مادة 1']);
      await jest.advanceTimersByTimeAsync(30_000);
      const result = await resultPromise;

      // maxRetries=2 يعني: المحاولة الأولى + محاولتان إضافيتان = 3 نداءات إجمالاً
      expect(fetchMock).toHaveBeenCalledTimes(3);
      expect(result).toBeNull();
      expect(service.getDegradationStats().rerank_rate_limit_count).toBe(1);
    });

    it('يحترم رأس Retry-After عند وجوده بدل التراجع الأُسّى الافتراضى', async () => {
      const service = new VoyageEmbeddingsService();
      const fetchMock = jest
        .fn()
        .mockResolvedValueOnce(jsonResponse(429, { detail: 'rate limited' }, { 'retry-after': '2' }))
        .mockResolvedValueOnce(
          jsonResponse(200, { results: [{ index: 0, relevance_score: 0.5 }] }),
        );
      global.fetch = fetchMock as unknown as typeof fetch;

      const resultPromise = service.rerank('سؤال', ['مادة 1']);
      // لا تقدُّم كافٍ بعد (أقل من ثانيتين) — يجب ألا تحدث المحاولة الثانية بعد
      await jest.advanceTimersByTimeAsync(500);
      expect(fetchMock).toHaveBeenCalledTimes(1);

      await jest.advanceTimersByTimeAsync(2000);
      const result = await resultPromise;
      expect(fetchMock).toHaveBeenCalledTimes(2);
      expect(result).toEqual([{ index: 0, relevanceScore: 0.5 }]);
    });

    it('لا يعيد المحاولة إطلاقاً عند خطأ غير 429 (500 مثلاً) — عطل غير مؤقت', async () => {
      const service = new VoyageEmbeddingsService();
      const fetchMock = jest.fn().mockResolvedValue(jsonResponse(500, { detail: 'server error' }));
      global.fetch = fetchMock as unknown as typeof fetch;

      const result = await service.rerank('سؤال', ['مادة 1']);

      expect(fetchMock).toHaveBeenCalledTimes(1);
      expect(result).toBeNull();
      expect(service.getDegradationStats().rerank_failure_count).toBe(1);
      expect(service.getDegradationStats().rerank_rate_limit_count).toBe(0);
    });
  });

  describe('embedQuery — إعادة المحاولة عند 429 وعدّادات منفصلة عن rerank', () => {
    it('يُسجِّل embed_rate_limit_count بمعزل عن rerank عند استنفاد المحاولات', async () => {
      const service = new VoyageEmbeddingsService();
      const fetchMock = jest.fn().mockResolvedValue(jsonResponse(429, { detail: 'rate limited' }));
      global.fetch = fetchMock as unknown as typeof fetch;

      const resultPromise = service.embedQuery('نص السؤال');
      await jest.advanceTimersByTimeAsync(30_000);
      const result = await resultPromise;

      expect(result).toBeNull();
      const stats = service.getDegradationStats();
      expect(stats.embed_rate_limit_count).toBe(1);
      expect(stats.rerank_rate_limit_count).toBe(0);
    });
  });

  describe('التدهور الآمن بلا مفتاح API', () => {
    it('يُرجع null فوراً بلا أى طلب شبكة عند غياب VOYAGE_API_KEY', async () => {
      delete process.env.VOYAGE_API_KEY;
      const service = new VoyageEmbeddingsService();
      const fetchMock = jest.fn();
      global.fetch = fetchMock as unknown as typeof fetch;

      const result = await service.rerank('سؤال', ['مادة 1']);

      expect(result).toBeNull();
      expect(fetchMock).not.toHaveBeenCalled();
    });
  });
});
