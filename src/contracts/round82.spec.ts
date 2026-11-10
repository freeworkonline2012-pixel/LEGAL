import { recoverHeadsFromParagraphBreaks, SegmentationService } from './segmentation.service';

const P = (s: string) => `${s} يلتزم الطرف الثانى بتقديم كافة المستندات والبيانات والمعلومات فور طلبها من الطرف الأول.`;
// نص الإنتاج: عنوان الخامس فارغ تماماً (سطر فارغ) بين متن الرابع ومتن الخامس
const prod = (opts: { blank?: boolean; extraPara?: boolean } = {}) =>
  [
    'عقد اتفاق أتعاب محاماة',
    'البند الأول',
    P('أ'),
    '',
    'البند الثانى',
    P('ب'),
    '',
    'البند الثالث',
    P('ج'),
    '',
    'البند الرابع',
    'يسرى هذا العقد لمدة سنة قابلة للتجديد تبدأ من أول يناير وحتى آخره',
    'ويجدد العقد لمدة أخرى مالم يخطر أحد الطرفين الطرف الآخر',
    'بعدم الرغبة فى تجديد العقد وذلك قبل شهر من إنتهاء مدة العقد .',
    ...(opts.extraPara ? ['', 'فقرة ثانية داخل البند الرابع نفسه طويلة بما يكفى لتكون فقرة مستقلة.'] : []),
    ...(opts.blank === false ? [] : ['']),
    'يلتزم الطرف الثاني بتقديم كافة المستندات و البيانات و المعلومات فور طلبها من',
    'الطرف الأول و إلا كان مسئولاً عن التأخير .',
    '',
    'البند السادس',
    P('د'),
    '',
    'البند السابع',
    P('هـ'),
  ].join('\n');
const nums = (t: string) => new SegmentationService().segment(t).clauses.map((c) => c.declaredNumber);

describe('round 82: عنوان ضاع كلياً (سطره فارغ) يُسترجع حدّه من فاصل الفقرات', () => {
  it('الخامس يُستعاد: متن الرابع لا يلتصق به ويبدأ الخامس بـ«يلتزم»', () => {
    const r = new SegmentationService().segment(prod());
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7]);
    const c4 = r.clauses.find((c) => c.declaredNumber === 4)!;
    const c5 = r.clauses.find((c) => c.declaredNumber === 5)!;
    expect(c4.text).not.toContain('يلتزم الطرف الثاني');
    expect(c4.text).toContain('إنتهاء مدة العقد');
    expect(c5.text.startsWith('يلتزم الطرف الثاني')).toBe(true);
    expect(r.warnings.some((w) => w.includes('البند الخامس') && w.includes('فاصل الفقرات'))).toBe(true);
  });
  it('لا فاصل فقرات بين المتنين: لا تخمين', () => {
    expect(nums(prod({ blank: false }))).not.toContain(5);
  });
  it('فقرة إضافية داخل الرابع (فقرات أكثر من الأرقام الناقصة + 1): لا تخمين', () => {
    expect(nums(prod({ extraPara: true }))).not.toContain(5);
  });
  it('ترقيم سليم لا يتغير، ولا يُسترجع بعد آخر بند مقروء', () => {
    const t = prod().replace('يلتزم الطرف الثاني بتقديم كافة المستندات و البيانات و المعلومات فور طلبها من', 'البند الخامس\nيلتزم الطرف الثاني بتقديم كافة المستندات و البيانات و المعلومات فور طلبها من');
    expect(nums(t)).toEqual([1, 2, 3, 4, 5, 6, 7]);
    const h = [{ lineStart: 0, markerStart: 0, marker: 'a', rawLength: 1, declaredNumber: 1 }, { lineStart: 40, markerStart: 40, marker: 'b', rawLength: 1, declaredNumber: 2 }];
    expect(recoverHeadsFromParagraphBreaks('x'.repeat(40) + '\nyy\n' + 'z'.repeat(60), h).recovered).toEqual([]);
  });
  it('رقمان ناقصان متتاليان وثلاث فقرات: يُستعادان', () => {
    const t = [
      'عقد أتعاب محاماة',
      'البند الأول', P('أ'), '',
      'البند الثانى', P('ب'), '',
      'البند الثالث', P('ج'), '',
      P('د ببند رابع بلا عنوان'), '',
      P('هـ ببند خامس بلا عنوان'), '',
      'البند السادس', P('و'), '',
      'البند السابع', P('ز'),
    ].join('\n');
    expect(nums(t)).toEqual([1, 2, 3, 4, 5, 6, 7]);
  });
});
