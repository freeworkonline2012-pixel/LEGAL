import { articleInLawScope, lawScopeContext } from './law-scope';

const civil = (articleNo: number) => ({ lawNo: 131, lawYear: 1948, articleNo });
const SALE = 'عقد بيع وحدة إدارية: يبيع الطرف الأول الوحدة للطرف الثانى بثمن إجمالى ويلتزم بتسليمها فى الموعد المتفق عليه';
const SERVICES = 'عقد خدمات أمنية وحراسة بين شركة وشركة، يلتزم الطرف الثانى بتوفير أفراد أمن للفروع مقابل أتعاب شهرية';
const AGENCY = 'عقد وكالة تأمين بين شركة تأمين ووسيط يتقاضى عمولة عن الوثائق التى يصدرها';
const LEASE = 'عقد إيجار شقة سكنية بين المؤجر والمستأجر بأجرة شهرية قدرها ألف جنيه';

describe('الجولة 89 — مواد باب الإيجار فى المدنى (558-634) مقيَّدة بنوع العقد', () => {
  it('محجوبة عن عقود بيع وخدمات ووكالة لا يرد فيها ما يدل على إيجار (حتى مع أسرة مجهولة)', () => {
    for (const text of [SALE, SERVICES, AGENCY]) {
      for (const no of [558, 580, 598, 608, 634]) {
        expect(articleInLawScope(lawScopeContext(text, null), civil(no))).toBe(false);
      }
    }
    expect(articleInLawScope(lawScopeContext(SALE, 'sale'), civil(571))).toBe(false);
  });

  it('مقبولة على أسرة الإيجار بلا مؤشر، وعلى أى عقد يدل نصه على إيجار', () => {
    expect(articleInLawScope(lawScopeContext('عقد بلا ألفاظ', 'lease'), civil(580))).toBe(true);
    expect(articleInLawScope(lawScopeContext(LEASE, null), civil(580))).toBe(true);
    expect(articleInLawScope(lawScopeContext('عقد إيجار ماكينة تصوير مع شركة سيفرز', null), civil(571))).toBe(true);
    // بيع يذكر مستأجراً شاغلاً للوحدة: علاقة إيجار فى النص
    expect(articleInLawScope(lawScopeContext(SALE + ' والوحدة مشغولة بالمستأجر الحالى', null), civil(598))).toBe(true);
  });

  it('حدّا الباب: 557 (الصلح) و635 (العارية) ليسا من الباب فيمرّان دائماً', () => {
    expect(articleInLawScope(lawScopeContext(SALE, null), civil(557))).toBe(true);
    expect(articleInLawScope(lawScopeContext(SALE, null), civil(635))).toBe(true);
  });

  it('مواد المدنى الأخرى (البيع 418، الوكالة 699، الالتزامات 224) لا تتأثر', () => {
    for (const no of [224, 418, 699]) expect(articleInLawScope(lawScopeContext(SALE, null), civil(no))).toBe(true);
  });

  it('«التأجير التمويلى» وحده ليس مؤشر إيجار مدنى، لكن «المؤجر/المستأجر» فى عقد تأجير تمويلى مؤشر', () => {
    expect(articleInLawScope(lawScopeContext('عقد التأجير التمويلى لمعدات بين شركة التأجير التمويلى والعميل', null), civil(580))).toBe(false);
    expect(articleInLawScope(lawScopeContext('عقد التأجير التمويلى: يلتزم المؤجر بتسليم الأصل ويلتزم المستأجر بسداد الأقساط', null), civil(580))).toBe(true);
  });

  it('مادة بلا رقم لا تُحجب (فاشل الأمان)', () => {
    expect(articleInLawScope(lawScopeContext(SALE, null), { lawNo: 131, lawYear: 1948 })).toBe(true);
  });

  it('لا أثر على بقية القوانين', () => {
    expect(articleInLawScope(lawScopeContext(SALE, null), { lawNo: 17, lawYear: 1999, articleNo: 580 })).toBe(true);
  });
});
