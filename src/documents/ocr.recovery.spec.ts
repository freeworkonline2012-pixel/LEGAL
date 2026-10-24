import { headingLineNumber, missingHeadingNumbers } from '../contracts/clause-headings';
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
