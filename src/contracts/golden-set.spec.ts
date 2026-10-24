import { readFileSync } from 'fs';
import { join } from 'path';
import { classifyClauseCriteria } from './criteria.util';
import { countHeadingLines } from './clause-headings';
import { checkInstallments, numericWarnings } from './numeric-checks.util';
import { SegmentationService } from './segmentation.service';

/**
 * مجموعة قياس ذهبية للجزء الحتمى من خط تدقيق العقود (التقسيم، الفحوص الحسابية، التصنيف) على عقد مُصطنَع بالكامل.
 * أى تعديل لاحق يكسر هذه النتائج يظهر هنا قبل وصوله لعميل. الحالات المعلّقة (pending) تخص طبقات لاحقة وتُفعَّل بجولاتها.
 */
const dir = join(__dirname, '__fixtures__', 'golden');
const text = readFileSync(join(dir, 'synthetic-software-supply.txt'), 'utf-8');
const expected = JSON.parse(readFileSync(join(dir, 'synthetic-software-supply.expected.json'), 'utf-8'));

describe('golden set — عقد توريد برمجيات مُصطنَع', () => {
  const seg = new SegmentationService().segment(text);

  it('يقسّم إلى 15 بنداً بترقيم سليم وبلا تنبيهات', () => {
    expect(seg.clauses).toHaveLength(expected.deterministic.clauseCount);
    expect(seg.clauses.map((c) => c.declaredNumber)).toEqual(expected.deterministic.declaredNumbers);
    expect(seg.warnings).toEqual(expected.deterministic.warnings);
  });

  it('الفحوص الحسابية: الدفعات 100% والمبلغ بالحروف مطابق فلا تحذير', () => {
    const inst = checkInstallments(text);
    expect(inst).toMatchObject(expected.deterministic.installments);
    expect(numericWarnings(text)).toEqual([]);
  });

  it('يكشف تعارض المبلغ إن عُبث بالرقم', () => {
    expect(numericWarnings(text.replace('600000', '650000'))).toHaveLength(1);
  });

  it('يكشف مجموع دفعات خاطئاً إن عُبث بنسبة', () => {
    expect(numericWarnings(text.replace('قيمتها 40 %', 'قيمتها 30 %'))).toHaveLength(1);
  });

  it.each(Object.entries(expected.deterministic.criteria as Record<string, string[]>))(
    'البند %s يحمل المعايير المتوقعة',
    (n, keys) => {
      const c = seg.clauses[Number(n) - 1];
      const got = classifyClauseCriteria(c.title, c.text);
      for (const k of keys) expect(got).toContain(k);
    },
  );

  it('إسقاط عناوين مسطّرة (محاكاة OCR) يُنتج تنبيهاً أو يُسترجع، ولا يمر صامتاً بعدد بنود ناقص', () => {
    const dropped = text.replace('البند الثالث عشر\n', '');
    const r = new SegmentationService().segment(dropped);
    const complete = r.clauses.length === 15 && r.warnings.length === 0;
    expect(complete).toBe(false);
    expect(r.warnings.length).toBeGreaterThan(0);
  });

  it('countHeadingLines يعدّ 15 عنواناً ويقل عند إسقاط عنوان', () => {
    expect(countHeadingLines(text)).toBe(15);
    expect(countHeadingLines(text.replace('البند الرابع\n', ''))).toBe(14);
  });
});
