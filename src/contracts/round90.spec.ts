import { extractKeyTerms } from './key-terms';
import { buildPaymentSchedules, isPenaltyOrCapPercent } from './payment-schedule';

const terms = (text: string) => extractKeyTerms([{ clauseIndex: 1, clauseLabel: 'البند 1', clauseTitle: null, clauseText: text }]);

describe('الجولة 90: جدول الدفعات لا يجمع نسب الغرامة والسقف', () => {
  it('«غرامة 1% … بحد أقصى 5%» بعد كلمة «السداد» لا تُعدّ دفعتين', () => {
    const t = terms('السداد: تسدد الأجرة شهرياً مقدماً فى أول كل شهر، وإذا تأخر المستأجر عن السداد التزم بغرامة 1% من الأجرة عن كل أسبوع بحد أقصى 5% منها.');
    expect(buildPaymentSchedules(t)).toEqual([]);
    const pct = t.filter((x) => x.kind === 'percent');
    expect(pct.length).toBeGreaterThanOrEqual(2);
    expect(pct.every((x) => isPenaltyOrCapPercent(x))).toBe(true);
  });

  it('دفعات حقيقية مع احتجاز ضمان تبقى جدولاً ومجموعها يُحسب (110% تُكشف)', () => {
    const t = terms('يسدد رب العمل 20% عند التوقيع و30% عند إنجاز الهيكل الخرسانى و30% عند إنجاز التشطيبات و25% عند الاستلام الابتدائى، ويحتجز 5% ضماناً للصيانة.');
    const s = buildPaymentSchedules(t);
    expect(s).toHaveLength(1);
    expect(s[0].sumPercent).toBe(110);
  });

  it('غرامة تأخير ضمن جملة دفعات لا تدخل الجدول، والدفعات قبلها تبقى', () => {
    const t = terms('يسدد المشترى 40% عند التوقيع و60% عند التسليم. وفى حال التأخر عن السداد تستحق غرامة 2% عن كل أسبوع بحد أقصى 10%.');
    const s = buildPaymentSchedules(t);
    expect(s).toHaveLength(1);
    expect(s[0].sumPercent).toBe(100);
  });
});

describe('الجولة 90: رمز % المقروء 90/96 ملتصقاً بالرقم', () => {
  const val = (text: string): string[] => terms(text).filter((x) => x.kind === 'percent').map((x) => `${x.value}${x.suspect ? '?' : ''}`);

  it('«تزاد 9015 سنوياً» ⇒ 15% مشكوك فيها لا رقم 9015', () => {
    expect(val('الأجرة الشهرية 15000 جنيه، تزاد 9015 سنوياً.')).toContain('15%?');
  });
  it('«غرامة 905 يومياً» و«يسدد 9020 عند التوقيع» و«9630 من الثمن»', () => {
    expect(val('التزم بغرامة 905 يوماً من الأجرة.')).not.toContain('905%');
    expect(val('يسدد رب العمل 9020 عند التوقيع و9630 عند إنجاز الهيكل.')).toEqual(expect.arrayContaining(['20%?', '30%?']));
    expect(val('يدفع المشترى 9625 من الثمن مقدماً.')).toContain('25%?');
  });
  it('مبالغ بالجنيه وسنوات لا تُقرأ نسباً', () => {
    expect(val('الأجرة 9025 جنيه تزاد سنوياً، والعقد يبدأ سنة 9020 ميلادية.')).toEqual([]);
  });
});
