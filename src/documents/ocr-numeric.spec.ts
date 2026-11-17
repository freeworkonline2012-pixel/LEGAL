import { readFileSync } from 'fs';
import { join } from 'path';
import {
  alignDigitTokens, applyNumberFixes, canonicalRead, decideNumber, emptyNumberStats, hasIndicDigit, isPureNumeric, numberWarnings, numericTokens, parseTsvWords, toLatin,
} from './ocr-numeric';
import { OcrService } from './ocr.service';

const tsv = (rows: Array<[string, number, number, number, number]>): string =>
  [
    'level\tpage_num\tblock_num\tpar_num\tline_num\tword_num\tleft\ttop\twidth\theight\tconf\ttext',
    '1\t1\t0\t0\t0\t0\t0\t0\t1654\t2339\t-1\t',
    ...rows.map(([t, l, tp, w, h]) => `5\t1\t1\t1\t1\t1\t${l}\t${tp}\t${w}\t${h}\t90.5\t${t}`),
  ].join('\n');

describe('numericTokens', () => {
  it('يوحّد الأرقام الهندية والفواصل وعلامة النسبة', () => {
    expect(numericTokens('مبلغ ٧٥٠٫٠٠٠ و 750,000 جنيه ونسبة ٦٪ و 10 % و %5')).toEqual(expect.arrayContaining(['750000', '6%', '10%', '5%']));
    expect(toLatin('٢٤')).toBe('24');
  });
});

describe('canonicalRead', () => {
  it('«%10» ← «10%» ويرفض ما ليس رقماً', () => {
    expect(canonicalRead('%10')).toBe('10%');
    expect(canonicalRead(' 250,000 ')).toBe('250,000');
    expect(canonicalRead('.%10')).toBe('10%');
    expect(canonicalRead('abc')).toBeNull();
    expect(canonicalRead('')).toBeNull();
    expect(canonicalRead('%')).toBe('%');
  });
});

describe('decideNumber', () => {
  it('«%» المقروءة 96 تُصلَح بقراءتين متفقتين', () => {
    expect(decideNumber('9610', ['%10', '%10'])).toEqual({ kind: 'corrected', text: '10%' });
    expect(decideNumber('962', ['%2', '2'])).toEqual({ kind: 'corrected', text: '2%' });
    expect(decideNumber('9010.', ['%10', '.%10'])).toEqual({ kind: 'corrected', text: '10%' });
    expect(decideNumber('96', ['%', '%'])).toEqual({ kind: 'corrected', text: '%' });
  });
  it('مؤكد إن طابقت القراءة المخصصة القراءة العامة، ولو اختلف فاصل الآلاف', () => {
    expect(decideNumber('250,000', ['250,000', '250,000'])).toEqual({ kind: 'verified' });
    expect(decideNumber('5.000', ['5,000', '5,000'])).toEqual({ kind: 'verified' });
    expect(decideNumber('45', ['45', null])).toEqual({ kind: 'uncertain' });
  });
  it('لا يستبدل رقماً برقم مختلف ولا يُقصّر رقماً (ولو اتفقت ثلاث قراءات)', () => {
    expect(decideNumber('15000', ['0', '0', '0'])).toEqual({ kind: 'uncertain' });
    expect(decideNumber('120,000', ['1200000', '1200000', '1200000'])).toEqual({ kind: 'corrected', text: '1200000' }); // استكمال: رقم القراءة العامة بادئة
    expect(decideNumber('250000', ['20.0', '20.0', '20.0'])).toEqual({ kind: 'uncertain' });
    expect(decideNumber('30', ['20', '20', '20'])).toEqual({ kind: 'uncertain' });
  });
  it('يستكمل رقماً بتره القراءة العامة باتفاق ثلاث قراءات فقط', () => {
    expect(decideNumber('0', ['250,000', '250,000.', '250,000.'])).toEqual({ kind: 'corrected', text: '250000' });
    expect(decideNumber('0', ['75,000', '75,000'])).toEqual({ kind: 'uncertain' });
  });
  it('قراءتان مختلفتان على الأرقام = غير مؤكد', () => {
    expect(decideNumber('961', ['%1', '%7'])).toEqual({ kind: 'uncertain' });
    expect(decideNumber('961', [null, null])).toEqual({ kind: 'uncertain' });
  });
  it('الأرقام الهندية لا تُصحَّح', () => {
    expect(decideNumber('٧٥٠', ['750', '750', '750'])).toEqual({ kind: 'indic' });
    expect(hasIndicDigit('٢٤')).toBe(true);
    expect(isPureNumeric('250,000')).toBe(true);
    expect(isPureNumeric('قبل:30')).toBe(false);
  });
  it('سقوط % كلياً يلزمه تأكيد القراءتين معاً', () => {
    expect(decideNumber('10', ['10%', '10%'])).toEqual({ kind: 'corrected', text: '10%' });
    expect(decideNumber('10', ['10%', '10'])).toEqual({ kind: 'uncertain' }); // قراءة واحدة فقط بـ%: لا نضيفها
  });
});

describe('alignDigitTokens وapplyNumberFixes', () => {
  const text = 'قدرها 9610 من إجمالى 250,000 جنيه قبل:30 يوماً';
  const words = parseTsvWords(tsv([['قدرها', 900, 10, 50, 20], ['9610', 800, 10, 55, 24], ['من', 700, 10, 30, 20], ['إجمالى', 600, 10, 60, 20], ['250,000', 500, 10, 100, 24], ['جنيه', 400, 10, 50, 20], ['قبل:30', 300, 10, 60, 24], ['يوماً', 200, 10, 50, 20]]));
  it('يقابل رموز الأرقام بالترتيب', () => {
    const t = alignDigitTokens(text, words);
    expect(t?.map((x) => x.text)).toEqual(['9610', '250,000', 'قبل:30']);
    expect(t?.[0].word.left).toBe(800);
  });
  it('اختلاف العدد أو النص = null (فشل مغلق)', () => {
    expect(alignDigitTokens('9610 و 250,000', words)).toBeNull();
    expect(alignDigitTokens(text.replace('9610', '9611'), words)).toBeNull();
  });
  it('يطبّق التصحيحات ويُلصق % المنفردة بالرقم التالى', () => {
    const t = alignDigitTokens(text, words)!;
    expect(applyNumberFixes(text, [{ start: t[0].start, end: t[0].end, text: '10%' }])).toBe('قدرها 10% من إجمالى 250,000 جنيه قبل:30 يوماً');
    expect(applyNumberFixes('بنسبة % 10 من', [])).toBe('بنسبة 10% من');
  });
  it('يتجاهل علامات الاتجاه فى مطابقة النص', () => {
    expect(alignDigitTokens('‏250,000‎ جنيه', parseTsvWords(tsv([['250,000', 1, 1, 1, 1], ['جنيه', 1, 1, 1, 1]])))).not.toBeNull();
  });
});

describe('numberWarnings', () => {
  it('لا تنبيه بلا أثر، وتنبيه لكل نوع', () => {
    expect(numberWarnings(undefined)).toEqual([]);
    expect(numberWarnings(emptyNumberStats())).toEqual([]);
    const w = numberWarnings({ checked: 30, verified: 10, corrected: 4, uncertain: 5, indic: 3, pagesSkipped: 1, weakPages: 0 });
    expect(w).toHaveLength(4);
    expect(w.join(' ')).toContain('4 رقماً');
    expect(w.join(' ')).toContain('الأرقام الهندية');
    expect(numberWarnings({ ...emptyNumberStats(), weakPages: 2 })[0]).toContain('2 صفحة');
  });
});

type Priv = {
  rereadNumbers: (pdf: string, dir: string, texts: string[], srcs: Array<{ image: string; dpi: number }>, report?: (d: number, t: number) => void, deadline?: number) => ReturnType<typeof emptyNumberStatsAsync>;
};
const emptyNumberStatsAsync = async () => emptyNumberStats();

describe('OcrService.rereadNumbers', () => {
  function build(tsvText: string, reads: Array<string | null>) {
    const s = new OcrService();
    let i = 0;
    jest.spyOn(s as never, 'pageTsv' as never).mockResolvedValue(tsvText as never);
    jest.spyOn(s as never, 'cropNumber' as never).mockResolvedValue('x.png' as never);
    jest.spyOn(s as never, 'readNumberCrop' as never).mockImplementation((async () => reads[i++] ?? null) as never);
    return s as unknown as Priv;
  }
  const srcs = [{ image: 'p.png', dpi: 200 }];

  it('يُصلح نسبة مقروءة 96 ويُبقى الأرقام السليمة ويعدّ الهندية', async () => {
    const text = 'قدرها 9610 من 250,000 جنيه و ٧٥٠ قبل';
    const t = tsv([['قدرها', 900, 10, 50, 20], ['9610', 800, 10, 55, 24], ['من', 700, 10, 30, 20], ['250,000', 600, 10, 100, 24], ['جنيه', 500, 10, 50, 20], ['و', 450, 10, 10, 20], ['٧٥٠', 400, 10, 40, 24], ['قبل', 300, 10, 40, 20]]);
    // 9610: psm7 %10, psm8 %10 ؛ 250,000: psm7 250,000 (مؤكد فوراً)
    const svc = build(t, ['%10', '%10', '250,000']);
    const texts = [text];
    const st = await svc.rereadNumbers('in.pdf', '/tmp', texts, srcs);
    expect(texts[0]).toBe('قدرها 10% من 250,000 جنيه و ٧٥٠ قبل');
    expect(st).toMatchObject({ checked: 3, corrected: 1, verified: 1, indic: 1, uncertain: 0, pagesSkipped: 0 });
  });

  it('عدم تقابل النص بالصورة يُسقط الصفحة دون تعديل', async () => {
    const t = tsv([['9610', 800, 10, 55, 24]]);
    const svc = build(t, ['%10', '%10']);
    const texts = ['9610 و 250,000'];
    const st = await svc.rereadNumbers('in.pdf', '/tmp', texts, srcs);
    expect(texts[0]).toBe('9610 و 250,000');
    expect(st.pagesSkipped).toBe(1);
  });

  it('قراءات متباينة تُبقى الرقم وتعدّه غير مؤكد، والصفحة الباهتة تُوسَم', async () => {
    const words = ['10', '20', '30', '40', '50'];
    const t = tsv(words.map((w, k) => [w, 900 - k * 100, 10, 40, 24] as [string, number, number, number, number]));
    const svc = build(t, words.flatMap(() => [null, null, null]));
    const texts = [words.join(' ')];
    const st = await svc.rereadNumbers('in.pdf', '/tmp', texts, srcs);
    expect(texts[0]).toBe(words.join(' '));
    expect(st).toMatchObject({ uncertain: 5, weakPages: 1 });
  });

  it('انقضاء السقف الزمنى يوقف الخطوة دون تعديل ما بقى', async () => {
    const t = tsv([['9610', 800, 10, 55, 24]]);
    const svc = build(t, ['%10', '%10']);
    const texts = ['9610'];
    const st = await svc.rereadNumbers('in.pdf', '/tmp', texts, srcs, undefined, Date.now() - 1);
    expect(texts[0]).toBe('9610');
    expect(st.pagesSkipped).toBe(1);
  });
});

describe('حارس: لا \\w فى ocr-numeric.ts', () => {
  it('لا backslash-w فى الكود', () => {
    const src = readFileSync(join(__dirname, 'ocr-numeric.ts'), 'utf8');
    const code = src.split('\n').filter((l) => !/^\s*(\/\/|\*|\/\*)/.test(l)).join('\n');
    expect(/\\w/.test(code)).toBe(false);
  });
});
