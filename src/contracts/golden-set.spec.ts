import { readFileSync } from 'fs';
import { join } from 'path';
import { classifyClauseCriteria, scopedLawsForClause } from './criteria.util';
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

  it.each(Object.entries(expected.deterministic.scopedLaws as Record<string, string[]>))(
    'البند %s يُربط بالقوانين المقيَّدة المتوقعة (151/2020 وجولة 5: 82/2002 و27/1994) ولا شىء زائد',
    (n, laws) => {
      const c = seg.clauses[Number(n) - 1];
      const got = scopedLawsForClause(classifyClauseCriteria(c.title, c.text), c.title, c.text).map(
        (s) => `${s.lawNo}/${s.lawYear}`,
      );
      expect([...got].sort()).toEqual([...laws].sort());
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

import { headingLineNumber, headingNumbers, missingHeadingNumbers } from './clause-headings';

describe('أدوات عناوين البنود', () => {
  it('missingHeadingNumbers يكشف الفجوة', () => {
    expect(missingHeadingNumbers('البند الأول\nنص\nالبند الثانى\nنص\nالبند الرابع\nنص')).toEqual([3]);
    expect(missingHeadingNumbers('بلا عناوين')).toEqual([]);
    expect(headingNumbers(text)).toHaveLength(15);
    expect(missingHeadingNumbers(text)).toEqual([]);
  });
  it('headingLineNumber يقبل العنوان القصير ويرفض جملة الإحالة', () => {
    expect(headingLineNumber('البند الثالث')).toBe(3);
    expect(headingLineNumber('‏الثالث‏')).toBe(3);
    expect(headingLineNumber('وفقاً للبند الثالث من هذا العقد وملحقاته الأخرى كلها')).toBeNull();
    expect(headingLineNumber('نص عادى')).toBeNull();
  });
});

import { canonicalHeading, looseHeadingLineNumber, ordinalWords } from './clause-headings';

describe('القراءة المتساهلة لعنوان منفرد', () => {
  it('تقبل عنواناً شوّهت رموز مجاورة بدايته', () => {
    expect(looseHeadingLineNumber('ص ٣ البند الثالث')).toBe(3);
    expect(looseHeadingLineNumber('ابند الثالث')).toBe(3);
    expect(looseHeadingLineNumber('البند الثالث')).toBe(3);
  });
  it('ترفض جملة إحالة ولو قصيرة أو سطراً طويلاً', () => {
    expect(looseHeadingLineNumber('طبقاً للبند الثالث من العقد')).toBeNull();
    expect(looseHeadingLineNumber('يسدد الطرف الثانى كما هو مبين بالبند الثالث وملحقاته الأخرى جميعها')).toBeNull();
  });
  it('العنوان القياسى والكلمات التشخيصية', () => {
    expect(canonicalHeading(3)).toBe('البند الثالث');
    expect(canonicalHeading(99)).toBeNull();
    expect(ordinalWords([3])).toContain('الثالث');
  });
});
