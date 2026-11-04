import {
  describeHeadingCandidates,
  editDistance,
  findAlignedHeads,
  fuzzyHeadingLineNumber,
  headingLikeScore,
  missingHeadingNumbersFuzzy,
  skeleton,
} from './clause-headings-fuzzy';
import { SegmentationService } from './segmentation.service';

/**
 * نصوص **مُصطنَعة** تحاكى أنماط تشوّه القراءة الآلية (OCR) لعناوين البنود التى
 * رُصدت على عقود ممسوحة حقيقية — دون أى نص عقد حقيقى (قرار الخصوصية).
 */
const body = (n: number) => `نص تجريبى للبند رقم ${n} يتضمن التزامات الطرفين وآلية التنفيذ.`;

const build = (headings: string[]) =>
  headings.map((h, i) => `${h}\n${body(i + 1)}\n`).join('\n');

describe('findAlignedHeads (مطابقة تقريبية مقيّدة بالتسلسل)', () => {
  it('skeleton يوحّد الحروف ويحذف التشكيل', () => {
    expect(skeleton('البَنْد الأُولى')).toBe(skeleton('البند الاولي'));
  });

  it('editDistance يحترم الحد الأعلى', () => {
    expect(editDistance('abc', 'abc', 2)).toBe(0);
    expect(editDistance('abc', 'abd', 2)).toBe(1);
    expect(editDistance('abc', 'xyz', 1)).toBeGreaterThan(1);
  });

  it('يتعرّف على عناوين مشوّهة بالتسلسل', () => {
    const text = build([
      'البند الأول: التعريفات',
      'البن دالثانى',
      'البندالالث',
      'البنسد الرا يسع',
      'الند الخامس',
      'البند السادس',
    ]);
    const heads = findAlignedHeads(text);
    expect(heads.map((h) => h.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6]);
    expect(heads.some((h) => h.distance > 0)).toBe(true);
  });

  it('يتعرّف على الترتيبى الطويل المشوّه (حرف مكرر)', () => {
    const text = build([
      'البند الأول',
      'البند الثانى',
      'البند الثالث',
      'البند الرابع',
      'البند الخامس',
      'البند السسسادس',
    ]);
    expect(findAlignedHeads(text).map((h) => h.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6]);
  });

  it('لا يقبل سطر إحالة داخل المتن كعنوان', () => {
    const text = [
      'البند الأول: أ',
      body(1),
      'البند الثانى: ب',
      'طبقاً للبند الثالث من العقد يلتزم الطرف الأول بالسداد.',
      'البند الثالث: ج',
      body(3),
    ].join('\n');
    const heads = findAlignedHeads(text);
    expect(heads.map((h) => h.declaredNumber)).toEqual([1, 2, 3]);
    expect(heads[2].lineStart).toBeGreaterThan(text.indexOf('طبقاً'));
  });

  it('لا يكرر رقماً ولا يقبل إعادة ترقيم الملحق من جديد', () => {
    const text = build([
      'البند الأول',
      'البند الثانى',
      'البند الثالث',
      'البند الأول: ملحق',
    ]);
    const nums = findAlignedHeads(text).map((h) => h.declaredNumber);
    expect(nums).toEqual([1, 2, 3]);
  });

  it('يرجع فارغاً إن وُجد أقل من عنوانين', () => {
    expect(findAlignedHeads('البند الأول\nنص')).toEqual([]);
    expect(findAlignedHeads('نص عادى بلا بنود')).toEqual([]);
  });
});

describe('المحاذاة الشاملة (الجولة 46)', () => {
  it('تصمد أمام فقد عدة عناوين متتالية بين عنوانين سليمين', () => {
    const text = [
      'البند الأول: أ',
      body(1),
      'البند الثانى: ب',
      body(2),
      body(3),
      body(4),
      body(5),
      'البندالسادس',
      body(6),
      'البنسد السا بع',
      body(7),
    ].join('\n');
    expect(findAlignedHeads(text).map((h) => h.declaredNumber)).toEqual([1, 2, 6, 7]);
  });

  it('يقبل عنواناً مشوّهاً بشدة إن اتسق مع الترتيب (فراغات وحرف مبدّل)', () => {
    const text = build(['البند الأول', 'البند الثانى', 'البند الثالث', 'البند الرابع', 'البذ د الخام س']);
    expect(findAlignedHeads(text).map((h) => h.declaredNumber)).toEqual([1, 2, 3, 4, 5]);
  });

  it('يتعرّف على عناوين «المادة» ويكتبها بصيغة المؤنث', () => {
    const text = build(['المادة الأولى:', 'المادة الثانيه:', 'الماده الثالثة', 'المادة الرابعه;']);
    const heads = findAlignedHeads(text);
    expect(heads.map((h) => h.marker)).toEqual(['المادة الأولى:', 'المادة الثانية:', 'المادة الثالثة', 'المادة الرابعة']);
  });

  it('لا يقبل «الباب» أو «المرفق» عنواناً', () => {
    const text = build(['الباب الأول', 'الباب الثانى', 'الباب الثالث', 'المرفق الرابع']);
    expect(findAlignedHeads(text)).toEqual([]);
  });

  it('يلتقط سطراً معزولاً سقطت كلمة «البند» منه بين مرساتين', () => {
    const text = [
      'البند الخامس',
      body(5),
      '',
      'اليتس دك السسسادس',
      '',
      body(6),
      'البند السابع',
      body(7),
      'البند الثامن',
      body(8),
    ].join('\n');
    expect(findAlignedHeads(text).map((h) => h.declaredNumber)).toEqual([5, 6, 7, 8]);
  });

  it('missingHeadingNumbersFuzzy: يحسب الناقص من القراءة التقريبية وأعلى بند يُحال إليه', () => {
    const text = ['البند الأول', body(1), 'البن د الثانى', 'يُنفَّذ طبقاً للبند الخامس من هذا العقد.'].join('\n');
    expect(missingHeadingNumbersFuzzy(text)).toEqual([3, 4, 5]);
    expect(missingHeadingNumbersFuzzy('نص بلا بنود')).toEqual([]);
  });

  it('fuzzyHeadingLineNumber: عنوان مشوّه منفرد ولا يلتقط جملة', () => {
    expect(fuzzyHeadingLineNumber('البذ د الراد ع عش')).toBe(14);
    expect(fuzzyHeadingLineNumber('البند الحادى عش')).toBe(11);
    expect(fuzzyHeadingLineNumber('طبقاً للبند الثالث من العقد يلتزم الطرف')).toBeNull();
    expect(fuzzyHeadingLineNumber('الباب الثالث عشر')).toBeNull();
  });
});

describe('جودة الصفحة والتشخيص (الجولة 46)', () => {
  it('headingLikeScore: القراءة الأوضح عناوين تفوز، وصفحة بلا عناوين صفر', () => {
    const garbled = ['البن دالثالث', body(3), 'الند الرابع', body(4)].join('\n');
    const clean = ['البند الثالث', body(3), 'البند الرابع', body(4)].join('\n');
    expect(headingLikeScore(clean)).toBeGreaterThan(headingLikeScore(garbled));
    expect(headingLikeScore(garbled)).toBeGreaterThan(0);
    expect(headingLikeScore(body(1))).toBe(0);
  });

  it('describeHeadingCandidates: يسجّل الأسطر الشبيهة بعنوان فقط ويعلّم المعتمد منها', () => {
    const text = build(['البند الأول', 'البن دالثانى', 'البند الثالث']) + '\nشركة المثال للتجارة\n';
    const lines = describeHeadingCandidates(text);
    expect(lines.length).toBe(3);
    expect(lines.every((l) => /=>\d+$/.test(l))).toBe(true);
    expect(lines.join('').includes('المثال')).toBe(false);
  });
});

describe('SegmentationService مع القراءة الآلية المشوّهة', () => {
  const service = new SegmentationService();

  it('يستعيد البنود التى فشل الكاشف الصارم فى قراءتها ويُحذّر', () => {
    const text = build([
      'البند الأول: التعريفات',
      'البن دالثانى',
      'البندالالث',
      'البنسد الرا يسع',
      'الند الخامس',
    ]);
    const r = service.segment(text);
    expect(r.clauses.length).toBe(5);
    expect(r.warnings.some((w) => w.includes('مطابقة تقريبية'))).toBe(true);
  });

  it('لا يغيّر شيئاً فى عقد نظيف ولا يُصدر تحذير المطابقة التقريبية', () => {
    const text = build([
      'البند الأول: أ',
      'البند الثانى: ب',
      'البند الثالث: ج',
      'البند الرابع: د',
    ]);
    const r = service.segment(text);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4]);
    expect(r.warnings.some((w) => w.includes('مطابقة تقريبية'))).toBe(false);
  });
});
