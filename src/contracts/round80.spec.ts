import { Logger } from '@nestjs/common';
import { describeGapWindow, recoverNoisyOrdinalHeads, SegmentationService } from './segmentation.service';

const body = (n: string) => `${n}\nيلتزم الطرف الثانى بتقديم كافة المستندات والبيانات والمعلومات فور طلبها من الطرف الأول وإلا كان مسئولاً عن التأخير فى التنفيذ.`;
const doc = (fifth: string | null) =>
  ['عقد اتفاق أتعاب محاماة', body('البند الأول'), body('البند الثانى'), body('البند الثالث'), body('البند الرابع'), ...(fifth ? [body(fifth)] : []), body('البند السادس'), body('البند السابع')].join('\n');
const numbers = (t: string) => new SegmentationService().segment(t).clauses.map((c) => c.declaredNumber);

describe('round 80: عنوان ناقص بسطر «ضوضاء + ترتيبى» (بحث موجَّه بالتسلسل)', () => {
  it.each(['ر الخامس', 'لاا الخامس', 'الخامس', 'الحامس', 'ش الخامس :', 'Rent الخامس', '؟ الخامس'])('«%s» يُقرأ البند الخامس', (h) => {
    expect(numbers(doc(h))).toEqual([1, 2, 3, 4, 5, 6, 7]);
  });
  it('نص البند الخامس لا يلتصق بالرابع ولا يبتلع العنوان', () => {
    const r = new SegmentationService().segment(doc('ر الخامس'));
    const c4 = r.clauses.find((c) => c.declaredNumber === 4);
    const c5 = r.clauses.find((c) => c.declaredNumber === 5);
    expect(c4?.text).not.toContain('الخامس');
    expect(c5?.text.startsWith('يلتزم')).toBe(true);
    expect(r.warnings.some((w) => w.includes('البند الخامس') && w.includes('سطر مشوَّه'))).toBe(true);
  });
  it('جملة عادية «الطرف الخامس» بين البندين لا تُقرأ عنواناً', () => {
    expect(numbers(doc('الطرف الخامس'))).not.toContain(5);
  });
  it('سطر طويل ينتهى بالترتيبى لا يُقبل', () => {
    const t = doc(null).replace('البند السادس\n', 'نص طويل جداً يشبه الجملة العادية فى المتن الخامس\nيلتزم الطرف الثانى.\nالبند السادس\n');
    expect(numbers(t)).not.toContain(5);
  });
  it('لا يخمّن بنداً أخيراً (لا عنوان مقروء بعده)', () => {
    const t = ['عقد أتعاب', body('البند الأول'), body('البند الثانى'), body('البند الثالث'), body('البند الرابع'), body('ر الخامس')].join('\n');
    expect(numbers(t)).toEqual([1, 2, 3, 4]);
  });
  it('الترتيب أو الترقيم السليم لا يتغير', () => {
    expect(numbers(doc('البند الخامس'))).toEqual([1, 2, 3, 4, 5, 6, 7]);
    const h = [{ lineStart: 0, markerStart: 0, marker: 'a', rawLength: 1, declaredNumber: 1 }, { lineStart: 10, markerStart: 10, marker: 'b', rawLength: 1, declaredNumber: 2 }];
    expect(recoverNoisyOrdinalHeads('x\n'.repeat(20), h).recovered).toEqual([]);
  });
  it('ترتيبى يلتبس بآخر (السابع/السادس) لا يُقبل تقريبياً', () => {
    expect(numbers(doc('السابغ'))).not.toContain(5);
  });
});

describe('round 80: لوج نافذة الفجوة', () => {
  it('يسجّل أسطر النافذة (أرقام وبدايات قصيرة) إن بقيت الفجوة', () => {
    const spy = jest.spyOn(Logger.prototype, 'log').mockImplementation(() => undefined);
    const t = doc(null);
    new SegmentationService().segment(t);
    const lines = spy.mock.calls.map((c) => String(c[0]));
    spy.mockRestore();
    const w = lines.find((l) => l.startsWith('segmentation gap window n=5:'));
    expect(w).toBeDefined();
    expect(w).toContain('len=');
    expect(w).not.toContain('يلتزم الطرف الثانى بتقديم كافة'); // الأسطر الطويلة تُقتطع إلى بداية قصيرة
  });
  it('describeGapWindow بلا عنوان سابق يرجع رمزاً لا يرمى', () => {
    expect(describeGapWindow('abc', [], 5)).toBe('no-before');
  });
});
