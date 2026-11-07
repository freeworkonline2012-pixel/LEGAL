import { articleInLawScope, lawScopeContext, SECTOR_LAW_KEYS } from './law-scope';

const leasing = { lawNo: 176, lawYear: 2018 };
const civil = { lawNo: 131, lawYear: 1948 };
const brokerage = { lawNo: 69, lawYear: 2025 };

const collectionContract = `عقد تقديم خدمات تحصيل إلكترونى. يقوم الطرف الأول بتحصيل أقساط الوثائق المختلفة من عملاء الطرف الثانى
عبر شبكة فورى وتحويل المبالغ المحصلة إلى الحساب البنكى للطرف الثانى مقابل عمولات التحصيل.`;

describe('بوابة نطاق القانون القطاعى (الجولة 60)', () => {
  it('القانون 176/2018 محجوب عن عقد تحصيل إلكترونى لا يرد فيه تأجير تمويلى ولا تخصيم، ولو كان النوع مجهولاً', () => {
    const ctx = lawScopeContext(collectionContract, null);
    expect(articleInLawScope(ctx, leasing)).toBe(false);
  });
  it('القانون 176/2018 مقبول حين يرد التأجير التمويلى أو التخصيم فى النص بأى صياغة معرَّفة', () => {
    for (const text of ['عقد التأجير التمويلي لمعدات', 'اتفاقية تخصيم فواتير', 'تعاقد مع شركة التخصيم', 'Factoring agreement']) {
      expect(articleInLawScope(lawScopeContext(text, null), leasing)).toBe(true);
    }
  });
  it('نوع العقد «تمويل» يقبل 176/2018 دون مؤشر نصى؛ والإيجار العادى لا', () => {
    expect(articleInLawScope(lawScopeContext('عقد بلا مؤشر', 'finance'), leasing)).toBe(true);
    expect(articleInLawScope(lawScopeContext('عقد إيجار شقة سكنية', 'lease'), leasing)).toBe(false);
  });
  it('القوانين غير القطاعية (المدنى) تمر دائماً، وكذلك مادة بلا رقم قانون', () => {
    const ctx = lawScopeContext(collectionContract, null);
    expect(articleInLawScope(ctx, civil)).toBe(true);
    expect(articleInLawScope(ctx, { lawNo: null, lawYear: null })).toBe(true);
  });
  it('قرارات قطاع التأمين تُحجب عن عقد لا يرد فيه التأمين وتمر على عقد وساطة تأمين وعلى عقد يذكر التأمينات', () => {
    expect(articleInLawScope(lawScopeContext('عقد إيجار مخزن بالجيزة', null), brokerage)).toBe(false);
    expect(articleInLawScope(lawScopeContext('عقد وساطة فى التأمين بين شركة تأمين ووسيط', null), brokerage)).toBe(true);
    expect(articleInLawScope(lawScopeContext('يلتزم صاحب العمل بسداد التأمينات الاجتماعية', null), brokerage)).toBe(true);
  });
  it('السجل يضم القوانين القطاعية المتفق عليها', () => {
    expect(SECTOR_LAW_KEYS).toEqual(expect.arrayContaining(['176/2018', '69/2025', '5/2023', '199/2025', '77/2025']));
  });
});
