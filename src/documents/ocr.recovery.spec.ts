import { headingLineNumber, headingNumbers, missingHeadingNumbers } from '../contracts/clause-headings';
import { OcrService } from './ocr.service';

// الاسترجاع يُختبَر بإحلال tsvLines (لا حاجة لـTesseract فى الاختبار): القراءة العادية تُسقط العنوان، والمتناثرة تلتقطه.
describe('OcrService.recoverMissingHeadings', () => {
  const cfg = { missingNumbers: missingHeadingNumbers, headingNumber: headingLineNumber };
  const page1 = 'البند الأول\nنص أول.\n\nالبند الثانى\nنص ثان.';
  const page2 = 'تتمة نص ثان.\n\nالبند الرابع\nنص رابع.';

  function service(sparse: Array<{ text: string; top: number; block: number }>, base: Array<{ text: string; top: number; block: number }>) {
    const s = new OcrService();
    jest.spyOn(s as never, 'tsvLines' as never).mockImplementation((async (img: string, psm: number) => (img !== 'b.png' ? [] : psm === 11 ? sparse : base)) as never);
    return s as unknown as { recoverMissingHeadings: (t: string[], i: string[][], c: typeof cfg) => Promise<void> };
  }

  it('يُدرج «البند الثالث» الملتقط بالقراءة المتناثرة فى موضعه من الصفحة', async () => {
    const base = [
      { text: 'تتمة نص ثان.', top: 100, block: 1 },
      { text: 'البند الرابع', top: 900, block: 2 },
      { text: 'نص رابع.', top: 950, block: 2 },
    ];
    const s = service([{ text: 'البند الثالث', top: 600, block: 7 }], base);
    const texts = [page1, page2];
    await s.recoverMissingHeadings(texts, [['a.png', 'b.png']], cfg);
    expect(missingHeadingNumbers(texts.join('\n\n'))).toEqual([]);
    expect(texts[1].split('\n').filter(Boolean)).toEqual(['تتمة نص ثان.', 'البند الثالث', 'البند الرابع', 'نص رابع.']);
  });

  it('لا يغيّر شيئاً إن لم تلتقط القراءة المتناثرة العنوان الناقص', async () => {
    const s = service([{ text: 'كلام آخر', top: 10, block: 1 }], []);
    const texts = [page1, page2];
    await s.recoverMissingHeadings(texts, [['a.png', 'b.png']], cfg);
    expect(texts).toEqual([page1, page2]);
  });

  it('لا يلمس نصاً مكتملاً التسلسل', async () => {
    const s = service([], []);
    const texts = ['البند الأول\nنص.\nالبند الثانى\nنص.'];
    await s.recoverMissingHeadings(texts, [['a.png']], cfg);
    expect(texts).toEqual(['البند الأول\nنص.\nالبند الثانى\nنص.']);
  });

  it('خطأ فى القراءة لا يُسقط الصفحة', async () => {
    const s = new OcrService();
    jest.spyOn(s as never, 'tsvLines' as never).mockRejectedValue(new Error('boom') as never);
    const texts = [page1, page2];
    await (s as unknown as { recoverMissingHeadings: (t: string[], i: string[][], c: typeof cfg) => Promise<void> }).recoverMissingHeadings(texts, [['a.png', 'b.png']], cfg);
    expect(texts).toEqual([page1, page2]);
  });
});

// الجولة 50: القراءة بالنموذج الثانى فى الاسترجاع + حماية من أى تغيير لا يقلّل الأرقام الناقصة
describe('OcrService.recoverMissingHeadings — النموذج الثانى والحماية من التراجع', () => {
  const cfg = { missingNumbers: missingHeadingNumbers, headingNumber: headingLineNumber, presentNumbers: headingNumbers };
  type Line = { text: string; top: number; block: number };
  type Fn = (t: string[], i: string[][], c: typeof cfg, r?: undefined, d?: undefined, alt?: string[]) => Promise<void>;
  const page1 = 'البند الأول\nنص أول.\n\nالبند الثانى\nنص ثان.';
  const page2 = 'تتمة نص ثان.\n\nالبند الرابع\nنص رابع.';
  const prev = process.env.OCR_TESSDATA_ALT;
  afterEach(() => {
    if (prev === undefined) delete process.env.OCR_TESSDATA_ALT;
    else process.env.OCR_TESSDATA_ALT = prev;
  });

  function build(handler: (img: string, psm: number, dir?: string) => Line[]) {
    process.env.OCR_TESSDATA_ALT = '/opt/tessdata-alt';
    const s = new OcrService();
    const calls: Array<[string, number, string | undefined]> = [];
    jest.spyOn(s as never, 'tsvLines' as never).mockImplementation((async (img: string, psm: number, dir?: string) => {
      calls.push([img, psm, dir]);
      return handler(img, psm, dir);
    }) as never);
    return { run: (s as unknown as { recoverMissingHeadings: Fn }).recoverMissingHeadings.bind(s) as Fn, calls };
  }

  it('يلتقط العنوان الناقص من قراءة النموذج الثانى حين لا يلتقطه النموذج العادى', async () => {
    const base = [
      { text: 'تتمة نص ثان.', top: 100, block: 1 },
      { text: 'البند الرابع', top: 900, block: 2 },
      { text: 'نص رابع.', top: 950, block: 2 },
    ];
    const { run, calls } = build((img, psm, dir) => {
      if (img !== 'alt-b.png' || dir !== '/opt/tessdata-alt') return [];
      return psm === 11 ? [{ text: 'البند الثالث', top: 600, block: 7 }] : base;
    });
    const texts = [page1, page2];
    await run(texts, [['a.png', 'b.png']], cfg, undefined, undefined, ['alt-a.png', 'alt-b.png']);
    expect(missingHeadingNumbers(texts.join('\n\n'))).toEqual([]);
    expect(texts[1]).toContain('البند الثالث');
    expect(calls.some(([img, , dir]) => img === 'alt-b.png' && dir === '/opt/tessdata-alt')).toBe(true);
    // القراءات بالنموذج العادى تجرى بلا مجلد خاص
    expect(calls.filter(([img]) => img === 'b.png').every(([, , dir]) => dir === undefined)).toBe(true);
  });

  it('لا يُقبل تغيير صفحة لا يقلّل الأرقام الناقصة (يُعاد النص الأصلى)', async () => {
    // قراءة TSV تلتقط «البند الثالث» لكنها تُسقط «البند الرابع» الموجود: الناقص قبل=1 وبعد=1 → تراجع
    const base = [{ text: 'تتمة نص ثان.', top: 100, block: 1 }];
    const { run } = build((img, psm) => (img === 'b.png' ? (psm === 11 ? [{ text: 'البند الثالث', top: 600, block: 7 }] : base) : []));
    const texts = [page1, page2];
    await run(texts, [['a.png', 'b.png']], cfg);
    expect(texts).toEqual([page1, page2]);
  });
});
