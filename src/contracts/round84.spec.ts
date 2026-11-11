import { articleInLawScope, lawScopeContext } from './law-scope';
import { norm } from './playbook-util';

const labor = { lawNo: 14, lawYear: 2025, articleNo: 87 };
const civilWork = { lawNo: 131, lawYear: 1948, articleNo: 679 };
const ctx = (text: string, family: any) => lawScopeContext(norm(text), family);

describe('الجولة 84 — مؤشرات علاقة العمل لا تلتقط ألفاظاً عابرة', () => {
  it('«ساعات العمل الرسمية وغلق الفرع» فى عقد حراسة لا تفتح قانون العمل', () => {
    const t = 'تنتهى المسئولية الأمنية بفرعى المعادى ومصر الجديدة بمجرد الانتهاء من ساعات العمل الرسمية وغلق الفرع. يلتزم الطرف الثانى بتوفير أفراد الأمن.';
    expect(articleInLawScope(ctx(t, 'services'), labor)).toBe(false);
    expect(articleInLawScope(ctx(t, 'services'), civilWork)).toBe(false);
  });
  it('«عقد عمليات التأمين» ليس «عقد عمل» (حد الكلمة)', () => {
    const t = 'عدم مراعاة حسن النية فى تقديم وساطة الطرف الأول فى عقد عمليات التأمين وبوجه عام فى حالة إخلال الطرف الثانى.';
    expect(articleInLawScope(ctx(t, 'agency'), labor)).toBe(false);
  });
  it('نفى سريان قانون العمل صراحةً لا يُعد مؤشر علاقة عمل', () => {
    const t = 'وبالتالى لا تخضع هذه العلاقة لقانون العمل أو التأمينات الاجتماعية، وهى علاقة وساطة مستقلة.';
    expect(articleInLawScope(ctx(t, 'agency'), labor)).toBe(false);
    expect(articleInLawScope(ctx(t, 'agency'), civilWork)).toBe(false);
  });
  it('إثبات علاقة العمل صراحةً ما زال يفتح القانون على عقد آخر', () => {
    const t = 'يخضع هذا الاتفاق لأحكام قانون العمل بشأن مكافأة نهاية الخدمة.';
    expect(articleInLawScope(ctx(t, 'services'), labor)).toBe(true);
  });
  it('عقد عمل حقيقى (أسرة employment) يقبل القانون دون مؤشر', () => {
    expect(articleInLawScope(ctx('يعمل الطرف الثانى لدى الأول', 'employment'), labor)).toBe(true);
  });
  it('النفى فى موضع والإثبات فى موضع آخر: الإثبات يغلب', () => {
    const t = 'لا تخضع خدمات الحراسة لقانون الاستثمار. ويخضع العامل لقانون العمل فى مدة التجربة.';
    expect(articleInLawScope(ctx(t, 'services'), labor)).toBe(true);
  });
});

import { SegmentationService, recoverHeadsFromIsolatedShortLines } from './segmentation.service';

const BODY = (s: string) => `${s} يلتزم الطرف الأول بتسليم الطرف الثانى الوحدة المبيعة فى الموعد المتفق عليه كتابةً`;
/** نص إنتاج بلا أسطر فارغة إطلاقاً (أرقام الأسطر متتالية فى لوج الإنتاج L83..L96). */
const dense = (heads: Record<number, string>) => {
  const label = ['', 'البند الأول', 'البند الثانى', 'البند الثالث', 'البندالرابع', '', '', '', 'البند الثامن', 'البند التاسع'];
  const out: string[] = ['عقد بيع وحدة إدارية'];
  for (let n = 1; n <= 9; n++) {
    out.push(heads[n] ?? label[n]);
    out.push(BODY(`أ${n}`));
    out.push(`${BODY(`ب${n}`)} ويقر الطرف الأول بذلك إقراراً نهائياً قاطعاً`);
  }
  return out.join('\n');
};
const numsOf = (t: string) => new SegmentationService().segment(t).clauses.map((c) => c.declaredNumber);

describe('الجولة 84 — عناوين تالفة فى نص بلا أسطر فارغة (عقد البيع: البنود 5 و6 و7)', () => {
  it('ثلاثة عناوين لاتينية مخلوطة تُسترجع بالترتيب مع تنبيه', () => {
    const t = dense({ 5: 'oa Jla gl', 6: 'sal الساد pl', 7: 'Lien البيد o' });
    const r = new SegmentationService().segment(t);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    expect(r.warnings.join(' ')).toMatch(/سطراً قصيراً تالفاً/);
  });
  it('نفس النص لكن سطر واحد ملتبس زائد (سطر قصير ثالث غير عنوان) ⇒ لا تغيير', () => {
    const t = dense({ 5: 'oa Jla gl', 6: 'sal الساد pl', 7: 'Lien البيد o' }).replace('ب4 يلتزم', 'xx gl\nب4 يلتزم');
    const heads = (new SegmentationService() as any).segment(t).clauses.map((c: any) => c.declaredNumber);
    expect(heads).not.toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });
  it('أسطر قصيرة عربية سليمة بلا مؤشر عنوان لا تُعد عناوين (بلا فراغ قبلها)', () => {
    const t = dense({ 5: 'لرقابه القضاء', 6: 'مع التحية', 7: 'ولا يجوز' });
    expect(numsOf(t)).not.toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9]);
  });
  it('الدالة المصدَّرة لا تتجاوز 4 أرقام ناقصة', () => {
    const heads: any[] = [1, 2, 8].map((n, i) => ({ lineStart: i * 100, markerStart: i * 100, marker: 'x', rawLength: 5, declaredNumber: n }));
    const text = Array.from({ length: 30 }, () => 'سطر طويل من المتن لا عنوان فيه ولا ضوضاء إطلاقاً').join('\n');
    expect(recoverHeadsFromIsolatedShortLines(text, heads).recovered).toEqual([]);
  });
});
