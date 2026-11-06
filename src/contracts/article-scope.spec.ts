import { articleInScopeForFamily, isEmploymentRegimeArticle } from './article-scope';

const civil = (n: number) => ({ lawNo: 131, lawYear: 1948, articleNo: n });
describe('بوابة نطاق المادة', () => {
  it('المادة 686 مدنى مستبعدة من الشراكة والبيع والإيجار، ومقبولة للعمل والخدمات وللأسرة المجهولة', () => {
    for (const f of ['partnership', 'sale', 'lease', 'finance', 'licence', 'agency'] as const) expect(articleInScopeForFamily(f, civil(686))).toBe(false);
    expect(articleInScopeForFamily('employment', civil(686))).toBe(true);
    expect(articleInScopeForFamily('services', civil(686))).toBe(true);
    expect(articleInScopeForFamily(null, civil(686))).toBe(true);
  });
  it('حدود المواد المدنية 674-698 فقط، وقانون العمل 14/2025 كله', () => {
    expect(isEmploymentRegimeArticle(civil(673))).toBe(false);
    expect(isEmploymentRegimeArticle(civil(674))).toBe(true);
    expect(isEmploymentRegimeArticle(civil(698))).toBe(true);
    expect(isEmploymentRegimeArticle(civil(699))).toBe(false);
    expect(articleInScopeForFamily('sale', { lawNo: 14, lawYear: 2025, articleNo: 117 })).toBe(false);
    expect(articleInScopeForFamily('partnership', civil(515))).toBe(true);
    expect(articleInScopeForFamily('partnership', { lawNo: 159, lawYear: 1981, articleNo: 10 })).toBe(true);
  });
});
