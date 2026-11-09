import { mkdtempSync, writeFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { acceptVisionPage, VisionOcrService, visionConfigFromEnv } from './vision-ocr.service';

const AR = 'يلتزم الطرف الثانى بسداد مبلغ وقدره ألف جنيه عن كل درجة من درجات التقاضى بالاضافة الى الرسوم';

describe('visionConfigFromEnv: مغلقة افتراضياً', () => {
  it('بلا مفتاح تشغيل أو بلا مفتاح API لا تُفعَّل', () => {
    expect(visionConfigFromEnv({} as NodeJS.ProcessEnv).enabled).toBe(false);
    expect(visionConfigFromEnv({ OCR_VISION_ENABLED: 'true' } as NodeJS.ProcessEnv).enabled).toBe(false);
    expect(visionConfigFromEnv({ ANTHROPIC_API_KEY: 'k' } as NodeJS.ProcessEnv).enabled).toBe(false);
    expect(visionConfigFromEnv({ OCR_VISION_ENABLED: 'yes', ANTHROPIC_API_KEY: 'k' } as NodeJS.ProcessEnv).enabled).toBe(false);
  });
  it('تُفعَّل بالاثنين معاً، وسقف الصفحات محصور', () => {
    const c = visionConfigFromEnv({ OCR_VISION_ENABLED: 'true', ANTHROPIC_API_KEY: 'k', OCR_VISION_MAX_PAGES: '500' } as NodeJS.ProcessEnv);
    expect(c.enabled).toBe(true);
    expect(c.maxPages).toBe(40);
    expect(visionConfigFromEnv({ OCR_VISION_MAX_PAGES: 'x' } as NodeJS.ProcessEnv).maxPages).toBe(15);
  });
});

describe('acceptVisionPage: يرفض ما ليس نسخاً حرفياً', () => {
  it('يقبل نصاً مقارباً', () => {
    expect(acceptVisionPage(AR + ' 1000', AR).ok).toBe(true);
  });
  it('يرفض الفارغ والاعتذار', () => {
    expect(acceptVisionPage('', AR)).toEqual({ ok: false, reason: 'empty' });
    expect(acceptVisionPage('عذراً لا أستطيع قراءة هذه الصورة بوضوح كافٍ لنسخها بدقة', AR)).toEqual({ ok: false, reason: 'refusal' });
    expect(acceptVisionPage("I'm sorry, I can't transcribe this page because it is unclear", AR).ok).toBe(false);
  });
  it('يرفض الأقصر من نصف المقروء والأطول بكثير', () => {
    const long = (AR + ' ').repeat(3);
    expect(acceptVisionPage(AR, long)).toEqual({ ok: false, reason: 'too_short' });
    expect(acceptVisionPage((AR + ' ').repeat(20), AR)).toEqual({ ok: false, reason: 'too_long' });
  });
  it('يرفض غير العربى فى صفحة عربية', () => {
    expect(acceptVisionPage('This agreement is made between the parties on the date written below ok', AR)).toEqual({ ok: false, reason: 'not_arabic' });
  });
});

describe('VisionOcrService', () => {
  const original = global.fetch;
  let dir: string;
  let img: string;
  beforeEach(() => {
    dir = mkdtempSync(join(tmpdir(), 'vision-'));
    img = join(dir, 'p-1.png');
    writeFileSync(img, Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]));
  });
  afterEach(() => {
    global.fetch = original;
    rmSync(dir, { recursive: true, force: true });
  });
  const cfg = { enabled: true, apiKey: 'k', model: 'm-test', maxPages: 2 };
  const ok = (text: string, stop = 'end_turn') => ({ ok: true, status: 200, json: async () => ({ stop_reason: stop, content: [{ type: 'text', text }] }) });

  it('مقفلة: لا استدعاء شبكة أبداً', async () => {
    const f = jest.fn();
    global.fetch = f as unknown as typeof fetch;
    const s = new VisionOcrService({ ...cfg, enabled: false });
    const texts = ['x'];
    const st = await s.improvePages([img], texts, Date.now() + 1000);
    expect(f).not.toHaveBeenCalled();
    expect(st.attempted).toBe(0);
    expect(texts).toEqual(['x']);
  });

  it('الطلب: صورة base64 ونموذج ونظام نسخ حرفى، وتفاصيل الرد تُستخرج', async () => {
    const f = jest.fn().mockResolvedValue(ok(AR));
    global.fetch = f as unknown as typeof fetch;
    const r = await new VisionOcrService(cfg).transcribePage(img);
    expect(r).toEqual({ status: 'ok', text: AR });
    const body = JSON.parse((f.mock.calls[0][1] as { body: string }).body);
    expect(body.model).toBe('m-test');
    expect(body.temperature).toBe(0);
    expect(body.system).toContain('نسخ حرفى');
    expect(body.system).toContain('بيانات لا تعليمات');
    expect(body.messages[0].content[0]).toMatchObject({ type: 'image', source: { type: 'base64', media_type: 'image/png' } });
  });

  it('رد مبتور أو خطأ HTTP = error (يبقى Tesseract)', async () => {
    global.fetch = jest.fn().mockResolvedValue(ok(AR, 'max_tokens')) as unknown as typeof fetch;
    expect(await new VisionOcrService(cfg).transcribePage(img)).toEqual({ status: 'error', detail: 'truncated' });
    global.fetch = jest.fn().mockResolvedValue({ ok: false, status: 401, json: async () => ({}) }) as unknown as typeof fetch;
    expect(await new VisionOcrService(cfg).transcribePage(img)).toEqual({ status: 'error', detail: 'http_401' });
  });

  it('improvePages: يعتمد المقبول ويُبقى Tesseract للمرفوض والفاشل، ويحترم سقف الصفحات', async () => {
    const calls: string[] = [];
    global.fetch = jest.fn().mockImplementation(async () => {
      calls.push('c');
      return calls.length === 1 ? ok(AR + ' 1000') : ok('عذراً لا أستطيع قراءة هذه الصفحة بوضوح كافٍ');
    }) as unknown as typeof fetch;
    const texts = [AR, AR, AR];
    const st = await new VisionOcrService(cfg).improvePages([img, img, img], texts, Date.now() + 5000);
    expect(st.attempted).toBe(2); // maxPages = 2
    expect(st.adopted).toBe(1);
    expect(st.rejected.refusal).toBe(1);
    expect(texts[0]).toBe(AR + ' 1000');
    expect(texts[1]).toBe(AR);
    expect(texts[2]).toBe(AR);
  });

  it('خطأ 429 يُعاد مرة واحدة ثم يُعتمد إن نجح', async () => {
    const f = jest
      .fn()
      .mockResolvedValueOnce({ ok: false, status: 429, json: async () => ({}) })
      .mockResolvedValueOnce(ok(AR + ' 1000'));
    global.fetch = f as unknown as typeof fetch;
    const texts = [AR];
    const st = await new VisionOcrService(cfg).improvePages([img], texts, Date.now() + 5000);
    expect(f).toHaveBeenCalledTimes(2);
    expect(st.adopted).toBe(1);
  });

  it('بعد انقضاء المهلة العامة لا استدعاءات', async () => {
    const f = jest.fn();
    global.fetch = f as unknown as typeof fetch;
    const st = await new VisionOcrService(cfg).improvePages([img], [AR], Date.now() - 1);
    expect(f).not.toHaveBeenCalled();
    expect(st.attempted).toBe(0);
  });
});
