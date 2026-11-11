import { articleInLawScope, lawScopeContext, SECTOR_LAW_KEYS } from './law-scope';

describe('الجولة 88 — القانون 27/2026 وقرار الهيئة 28/2026', () => {
  const budget = { lawNo: 27, lawYear: 2026 };
  const consumerFinanceDecision = { lawNo: 28, lawYear: 2026 };
  it('27/2026 (ربط حساب ختامى لهيئة النقل العام) محجوب عن كل العقود وكل الأسر', () => {
    for (const family of [null, 'lease', 'sale', 'services', 'finance'] as const) {
      expect(articleInLawScope(lawScopeContext('عقد بيع وحدة إدارية ويسرى من تاريخ التوقيع', family), budget)).toBe(false);
    }
  });
  it('28/2026 محجوب عن عقد بيع/إيجار/وكالة ويمر على عقد يذكر التمويل الاستهلاكى أو قانونه 18/2020', () => {
    expect(articleInLawScope(lawScopeContext('عقد بيع وحدة إدارية ويسرى من تاريخ التوقيع', null), consumerFinanceDecision)).toBe(false);
    expect(articleInLawScope(lawScopeContext('عقد وكالة تأمين لشركة تأمين ووسيط', null), consumerFinanceDecision)).toBe(false);
    expect(articleInLawScope(lawScopeContext('عقد تمويل استهلاكى بين شركة تمويل استهلاكى وعميل', null), consumerFinanceDecision)).toBe(true);
    expect(articleInLawScope(lawScopeContext('وفقاً لقانون تنظيم نشاط التمويل الاستهلاكى رقم 18 لسنة 2020', null), consumerFinanceDecision)).toBe(true);
  });
  it('السجل يضم 27/2026 و28/2026', () => {
    expect(SECTOR_LAW_KEYS).toEqual(expect.arrayContaining(['27/2026', '28/2026']));
  });
  it('قوانين أخرى غير قطاعية (المدنى) تمر كما كانت', () => {
    expect(articleInLawScope(lawScopeContext('عقد بيع', null), { lawNo: 131, lawYear: 1948, articleNo: 418 })).toBe(true);
  });
});
