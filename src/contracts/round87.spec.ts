import { SegmentationService } from './segmentation.service';

const seg = (t: string) => new SegmentationService().segment(t);
const WORDS = ['يلتزم', 'الطرف', 'الأول', 'بتسليم', 'الوحدة', 'المبيعة', 'للطرف', 'الثانى', 'فى', 'الموعد', 'المتفق', 'عليه', 'كتابةً', 'ويقر'];
/** سطر عربى بطول مطلوب بالضبط (كلمات متتابعة تُقطع/تُحشى) */
const line = (len: number, tag: string): string => {
  let s = tag;
  let i = 0;
  while (s.length < len) s += ' ' + WORDS[i++ % WORDS.length];
  return s.slice(0, len).trimEnd().padEnd(len, 'ا');
};
const L = (n: string) => [n, line(80, 'م1'), line(60, 'م2')];

/** أطوال الأسطر من لوج الإنتاج لعقد البيع: بين 6 و8 (72,52,92,86,92,57) ولا عنوان للسابع. */
const sale7 = (lens: number[], extra: string[] = []) =>
  [
    'عقد بيع وحدة إدارية',
    ...L('البند الأول'), ...L('البند الثانى'), ...L('البند الثالث'), ...L('البند الرابع'), ...L('البند الخامس'),
    'البند السادس',
    ...lens.map((n, i) => line(n, `س${i}`)),
    ...extra,
    'البند الثامن', line(80, 'ث1'), line(60, 'ث2'),
    ...L('البند التاسع'),
  ].join('\n');

describe('الجولة 87 — عنوان ضاع كلياً بلا فراغ يُحدَّد من نهاية الفقرة المبتورة', () => {
  it('أطوال إنتاج البيع (72,52,92,86,92,57): السابع يبدأ بعد السطر القصير 52', () => {
    const r = seg(sale7([72, 52, 92, 86, 92, 57]));
    const c7 = r.clauses.find((c) => c.declaredNumber === 7);
    expect(c7).toBeDefined();
    expect(c7?.text.startsWith('س2')).toBe(true);
    const c6 = r.clauses.find((c) => c.declaredNumber === 6)!;
    expect(c6.text).toContain('س1');
    expect(c6.text).not.toContain('س2');
    expect(r.warnings.some((w) => w.includes('البند السابع') && w.includes('نهاية فقرة'))).toBe(true);
  });

  it('ضوضاء التوقيع (أسطر < 8 أحرف) لا تفسد الاسترجاع ولا تُعد مرشحاً', () => {
    const r = seg(sale7([72, 52, 92, 86, 92, 57], ['د', 'ل', '+ يي']));
    expect(r.clauses.map((c) => c.declaredNumber)).toContain(7);
  });

  it('سطران مبتوران ⇒ التباس ⇒ لا تغيير', () => {
    const r = seg(sale7([72, 40, 92, 41, 92, 86, 57]));
    expect(r.clauses.map((c) => c.declaredNumber)).not.toContain(7);
  });

  it('لا سطر مبتور داخل النافذة ⇒ لا تغيير', () => {
    const r = seg(sale7([90, 88, 92, 86, 92, 90]));
    expect(r.clauses.map((c) => c.declaredNumber)).not.toContain(7);
  });

  it('فراغ داخل النافذة ⇒ الأولوية لبنية الفقرات (الجولة 82) لا لهذا الاسترجاع', () => {
    const t = sale7([72, 52, 92, 86, 92, 57]).replace(line(92, 'س2'), '\n' + line(92, 'س2'));
    const r = seg(t);
    // يُسترجع (إن حدث) بفاصل الفقرات لا بالأسطر المبتورة
    expect(r.warnings.some((w) => w.includes('نهاية فقرة'))).toBe(false);
  });

  it('وسيط الأسطر قصير (< 45): نص غير مسطور العرض ⇒ لا تغيير', () => {
    const r = seg(sale7([30, 12, 35, 33, 34, 30]));
    expect(r.clauses.map((c) => c.declaredNumber)).not.toContain(7);
  });
});

describe('الجولة 87 — ملحق مرقَّم بعد التوقيع لا يُنسب لآخر بند', () => {
  const agencyEnd = (annexHead: string) =>
    [
      'عقد وكالة',
      ...L('البند الأول'), ...L('البند الثانى'),
      'البند الثالث',
      'تحرر هذا العقد من نسختين بيد كل طرف نسخة للعمل بموجبها عند الحاجة وللاستناد إليها قانوناً',
      'الطرف الأول الطرف الثانى',
      annexHead,
      'إتفق الطرفان على الأتى : تكون العمولة المستحقة على هذا الإتفاق قدرها 20 % عند السداد الفعلى',
      'تكون عمولة التبكير المستحقة على هذا الإتفاق قدرها 5 % عند السداد خلال 15 يوماً من الإصدار',
    ].join('\n');

  it('«ملحق(4) عقد الوكالة» يُفصل عن البند الثالث ويحمل نسبه', () => {
    const r = seg(agencyEnd('ملحق(4) عقد الوكالة فى الانتاج'));
    const last = r.clauses[r.clauses.length - 1];
    expect(last.label).toBe('ملحق (4)');
    expect(last.declaredNumber).toBeNull();
    expect(last.text).toContain('20 %');
    const c3 = r.clauses.find((c) => c.declaredNumber === 3)!;
    expect(c3.text).not.toContain('20 %');
    expect(c3.text).toContain('نسختين');
    expect(r.warnings.some((w) => w.includes('ملحق (4)'))).toBe(true);
  });

  it('إحالة وسط الجملة إلى ملحق («وفقاً لملحق 2») لا تفصل شيئاً', () => {
    const t = agencyEnd('وفقاً لملحق 4 المرفق بهذا العقد وعلى النحو الوارد فيه تماماً').replace('ملحق 4', 'ملحق 4');
    const r = seg(t);
    expect(r.clauses.some((c) => c.label.startsWith('ملحق'))).toBe(false);
  });
});
