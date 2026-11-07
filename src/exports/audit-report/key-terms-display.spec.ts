import { extractKeyTerms } from '../../contracts/key-terms';
import { groupKeyTerms, unionQuotes } from './key-terms-display';
import { buildPaymentSchedules } from '../../contracts/payment-schedule';

const clause = (i: number, text: string) => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: text });
const norm = (s: string) => s.replace(/\s+/g, ' ');

// بند إيجار بلا علامات وقف (كما فى العقود الممسوحة): المبلغ بالأرقام ثم بالحروف ثم المدة فى الجملة نفسها
const RENT =
  'اتفق الطرفان على ان تكون القيمة الايجارية الشهرية للعين محل العقد مبلغا وقدرة ( 45000 ) جنيه مصرى شهريا ( فقط خمسة واربعون الف جنيها مصريا لا غير ) تدفع نقدا او تحويل بنكى كل ثلاثة اشهر مقابل ايصال بالقيمة الايجارية خلال الاسبوع الاول من الشهر الرابع طوال مدة العقد ويتم التحويل الى حساب السيدة سلوى محمد على رشيد بالبنك الاهلى المصرى';

describe('عرض الشروط الرئيسية بلا تكرار', () => {
  it('القيمة المكتوبة بالأرقام وبالحروف فى البند نفسه تُعرض مرة واحدة', () => {
    const terms = extractKeyTerms([clause(4, RENT)]);
    const money = terms.filter((t) => t.kind === 'amount' && t.value.startsWith('45,000'));
    expect(money.length).toBeGreaterThanOrEqual(1);
    const rows = groupKeyTerms(terms);
    const shown = rows.flatMap((r) => r.terms).filter((t) => t.kind === 'amount' && t.value.startsWith('45,000'));
    expect(shown).toHaveLength(1);
  });

  it('القيم المتجاورة فى مقطع واحد تُجمع فى صف واحد باقتباس واحد متصل من النص', () => {
    const terms = extractKeyTerms([clause(4, RENT)]);
    const rows = groupKeyTerms(terms);
    expect(rows.length).toBeLessThan(terms.length);
    for (const r of rows) expect(norm(RENT).includes(r.quote)).toBe(true);
    // لا فقدان: كل قيمة غير مكررة تبقى فى صف
    const kept = rows.flatMap((r) => r.terms).map((t) => `${t.kind}|${t.value}`);
    for (const t of terms.filter((x) => !x.fromWords)) expect(kept).toContain(`${t.kind}|${t.value}`);
  });

  it('بندان مختلفان لا يُدمجان حتى لو تشابه نصاهما', () => {
    const a = clause(4, 'يدفع المستأجر مبلغ 90000 جنيه تأمينا يرد بعد انتهاء العلاقة الايجارية بدون حساب اى فوائد على المبلغ');
    const b = clause(5, 'يدفع المستأجر مبلغ 90000 جنيه تأمينا يرد بعد انتهاء العلاقة الايجارية بدون حساب اى فوائد على المبلغ');
    expect(groupKeyTerms(extractKeyTerms([a, b]))).toHaveLength(2);
  });

  it('نفس النسبة مرتين فى بند واحد بنافذتين مختلفتين لا تُحذف (دفعتان حقيقيتان)', () => {
    const text = 'تسدد الدفعة الأولى 30% عند التوقيع. وتسدد الدفعة الثانية 30% عند التسليم النهائى للمشروع بعد اختبارات القبول.';
    const terms = extractKeyTerms([clause(1, text)]);
    const pct = groupKeyTerms(terms).flatMap((r) => r.terms).filter((t) => t.kind === 'percent');
    expect(pct.length + pct.reduce((a, t) => a + ((t.occurrences ?? 1) - 1), 0)).toBe(2);
  });

  it('جدول الدفعات لا يتأثر: مدخلاته هى مخرجات المستخرِج الأصلية', () => {
    const t = extractKeyTerms([clause(1, 'قيمة العقد 100000 جنيه. تسدد الدفعة الأولى 30% عند التوقيع والثانية 30% عند التسليم.')]);
    expect(buildPaymentSchedules(t).length).toBeGreaterThan(0);
  });

  it('unionQuotes: نافذتان متداخلتان تتحدان، وغير المتداخلتين null', () => {
    const base = 'أ'.repeat(10) + ' الجملة المشتركة بين النافذتين طويلة بما يكفى لتجاوز الحد الأدنى للتداخل ' + 'ب'.repeat(10);
    const a = base.slice(0, 60);
    const b = base.slice(20);
    expect(unionQuotes(a, b)).toBe(base);
    expect(unionQuotes('اول نص مستقل تماما عن الاخر بكل شئ', 'ثان نص مختلف كليا لا يشترك معه بشىء ابدا فيه')).toBeNull();
    expect(unionQuotes('نص طويل يحوى الاخر', 'يحوى الاخر')).toBe('نص طويل يحوى الاخر');
  });
});

describe('الجولة 60: التاريخ المكرر فى البند نفسه يُعرض مرة', () => {
  it('تاريخان متطابقان فى بند واحد يصيران صفاً واحداً، والنسبة المتكررة بجملتين مختلفتين لا تُدمج', () => {
    const text =
      'تحريرا فى 05/07/2021 وقع الطرفان. اسم المستلم : ........ حرر فى 05/07/2021 . ويكون الحد الاقصى 30% من اجمالى المحفظة ولا تزيد نسبة اى منهما عن 30% من اجمالى المحفظة سنويا.';
    const terms = extractKeyTerms([clause(17, text)]);
    const shown = groupKeyTerms(terms).flatMap((r) => r.terms);
    expect(shown.filter((t) => t.kind === 'date' && t.value.includes('05/07/2021'))).toHaveLength(1);
    expect(shown.filter((t) => t.kind === 'percent' && t.value.startsWith('30')).length).toBeGreaterThanOrEqual(1);
  });
});
