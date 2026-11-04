import { editDistance, findAlignedHeads, skeleton } from './clause-headings-fuzzy';
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
