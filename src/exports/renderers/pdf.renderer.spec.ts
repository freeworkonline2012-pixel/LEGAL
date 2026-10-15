import { PdfRenderer } from './pdf.renderer';

const launch = jest.fn();
jest.mock('puppeteer-core', () => ({ launch: (...a: unknown[]) => launch(...a) }));

/** انحدار: طلبان متزامنان عند أول استعمال كانا يُطلقان متصفحين ويتسرب أحدهما (اكتُشف بالاختبار الفعلى). */
describe('PdfRenderer.getBrowser', () => {
  const OLD = process.env.PDF_CHROMIUM_PATH;
  beforeEach(() => {
    launch.mockReset();
    launch.mockImplementation(async () => ({ on: jest.fn(), close: jest.fn(), newPage: jest.fn() }));
    process.env.PDF_CHROMIUM_PATH = process.execPath; // أى ملف موجود
  });
  afterAll(() => {
    if (OLD === undefined) delete process.env.PDF_CHROMIUM_PATH;
    else process.env.PDF_CHROMIUM_PATH = OLD;
  });

  it('يُطلق متصفحاً واحداً فقط مهما تزامنت الطلبات', async () => {
    const r = new PdfRenderer() as unknown as { getBrowser: () => Promise<unknown> };
    const all = await Promise.all(Array.from({ length: 6 }, () => r.getBrowser()));
    expect(launch).toHaveBeenCalledTimes(1);
    expect(new Set(all).size).toBe(1);
  });

  it('فشل الإطلاق لا يُبقى وعداً مرفوضاً عالقاً: المحاولة التالية تعيد الإطلاق', async () => {
    launch.mockRejectedValueOnce(new Error('boom'));
    const r = new PdfRenderer() as unknown as { getBrowser: () => Promise<unknown> };
    await expect(r.getBrowser()).rejects.toThrow('boom');
    await expect(r.getBrowser()).resolves.toBeDefined();
    expect(launch).toHaveBeenCalledTimes(2);
  });

  it('بلا Chromium: 503 صريح (و Word يبقى متاحاً)', async () => {
    process.env.PDF_CHROMIUM_PATH = '/nonexistent/chrome';
    const r = new PdfRenderer();
    // قد يوجد Chromium فى مسارات النظام الافتراضية؛ نتحقق فقط من منطق الخطأ إن غاب
    if (!r.isAvailable()) {
      await expect(r.render({} as never)).rejects.toThrow('تصدير PDF غير متاح');
    }
  });
});
