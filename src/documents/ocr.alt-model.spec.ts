import { OcrService } from './ocr.service';

type Priv = {
  rereadWithAlternateModel: (images: string[], texts: string[], score: (t: string) => number, report?: (d: number, t: number) => void, deadline?: number) => Promise<void>;
  isAltAvailable: () => Promise<boolean>;
};

// القراءة الإضافية بنموذج ثانٍ: تُختبَر بإحلال recognizeFile وisAltAvailable (لا حاجة لـTesseract).
describe('OcrService.rereadWithAlternateModel', () => {
  const score = (t: string) => (t.match(/البند/g) ?? []).length;
  const prev = process.env.OCR_TESSDATA_ALT;
  afterEach(() => {
    if (prev === undefined) delete process.env.OCR_TESSDATA_ALT;
    else process.env.OCR_TESSDATA_ALT = prev;
  });

  function build(alts: Array<string | Error>, available = true) {
    process.env.OCR_TESSDATA_ALT = '/opt/tessdata-alt';
    const s = new OcrService();
    const calls: Array<[string, string | undefined]> = [];
    let i = 0;
    jest.spyOn(s as never, 'recognizeFile' as never).mockImplementation((async (img: string, dir?: string) => {
      calls.push([img, dir]);
      const r = alts[i++];
      if (r instanceof Error) throw r;
      return r;
    }) as never);
    jest.spyOn(s as never, 'isAltAvailable' as never).mockResolvedValue(available as never);
    return { svc: s as unknown as Priv, calls };
  }

  it('يتبنّى القراءة الثانية للصفحة التى مقياسها أعلى ويُبقى الباقى', async () => {
    const { svc, calls } = build(['البند الأول\nالبند الثانى', 'نص أقل']);
    const texts = ['البند الأول', 'البند الثالث'];
    await svc.rereadWithAlternateModel(['a.png', 'b.png'], texts, score);
    expect(texts).toEqual(['البند الأول\nالبند الثانى', 'البند الثالث']);
    expect(calls).toEqual([['a.png', '/opt/tessdata-alt'], ['b.png', '/opt/tessdata-alt']]);
  });

  it('عند التعادل تبقى القراءة الحالية', async () => {
    const { svc } = build(['البند الأول (بديل)']);
    const texts = ['البند الأول'];
    await svc.rereadWithAlternateModel(['a.png'], texts, score);
    expect(texts).toEqual(['البند الأول']);
  });

  it('فشل صفحة لا يُسقط القراءة ولا يمنع بقية الصفحات', async () => {
    const { svc } = build([new Error('boom'), 'البند الأول\nالبند الثانى']);
    const texts = ['x', 'البند الأول'];
    await svc.rereadWithAlternateModel(['a.png', 'b.png'], texts, score);
    expect(texts).toEqual(['x', 'البند الأول\nالبند الثانى']);
  });

  it('لا تُجرى قراءة إضافية إن لم يكن النموذج الثانى متاحاً', async () => {
    const { svc, calls } = build(['البند الأول\nالبند الثانى'], false);
    const texts = ['x'];
    await svc.rereadWithAlternateModel(['a.png'], texts, score);
    expect(texts).toEqual(['x']);
    expect(calls).toEqual([]);
  });

  it('انقضاء السقف الزمنى يوقف القراءة الإضافية ويُبقى ما قُرئ', async () => {
    const { svc, calls } = build(['البند الأول\nالبند الثانى']);
    const texts = ['x'];
    await svc.rereadWithAlternateModel(['a.png'], texts, score, undefined, Date.now() - 1);
    expect(texts).toEqual(['x']);
    expect(calls).toEqual([]);
  });

  it('بلا متغير OCR_TESSDATA_ALT يكون النموذج الثانى غير متاح', async () => {
    delete process.env.OCR_TESSDATA_ALT;
    const s = new OcrService() as unknown as Priv;
    await expect(s.isAltAvailable()).resolves.toBe(false);
  });

  it('مسار غير صالح يعطّل القراءة الإضافية بلا استثناء', async () => {
    process.env.OCR_TESSDATA_ALT = '/nonexistent/dir';
    const s = new OcrService() as unknown as Priv;
    await expect(s.isAltAvailable()).resolves.toBe(false);
  });
});
