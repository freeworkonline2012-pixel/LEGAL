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
    // الجولة 62: التأمينات الاجتماعية لا تجعل العقد عقد وساطة تأمين (كان يمر بلفظ «تأمين» وحده)
    expect(articleInLawScope(lawScopeContext('يلتزم صاحب العمل بسداد التأمينات الاجتماعية', null), brokerage)).toBe(false);
  });
  it('السجل يضم القوانين القطاعية المتفق عليها', () => {
    expect(SECTOR_LAW_KEYS).toEqual(expect.arrayContaining(['176/2018', '69/2025', '5/2023', '199/2025', '77/2025']));
  });
});

describe('الجولة 90: بوابات نطاق القوانين', () => {
  const art = (lawNo: number, lawYear: number) => ({ lawNo, lawYear, articleNo: 1 });
  const supplyPrivate = lawScopeContext('عقد توريد عبوات بين شركة الأفق للصناعات وشركة النور للتعبئة. يلتزم المورد بتوريد الطلبات خلال عشرة أيام من أمر التوريد.', 'services');
  const supplyPublic = lawScopeContext('عقد توريد أجهزة لوزارة الصحة بعد مناقصة عامة وفقاً لقانون التعاقدات العامة 182 لسنة 2018.', 'services');
  const loanPrivate = lawScopeContext('عقد قرض بين السيد/ منصور وشركة الركن، مدة القرض أربعة وعشرون شهراً وفائدة 7% سنوياً.', 'finance');
  const loanLicensed = lawScopeContext('عقد تمويل استهلاكى تبرمه شركة تمويل مرخص لها من الهيئة العامة للرقابة المالية.', 'finance');

  it('182/2018 و692/2019 محجوبان عن توريد بين شركتين خاصتين ويُقبلان عند ذكر جهة عامة أو مناقصة', () => {
    expect(articleInLawScope(supplyPrivate, art(182, 2018))).toBe(false);
    expect(articleInLawScope(supplyPrivate, art(692, 2019))).toBe(false);
    expect(articleInLawScope(supplyPublic, art(182, 2018))).toBe(true);
    expect(articleInLawScope(supplyPublic, art(692, 2019))).toBe(true);
  });

  it('قرارا الهيئة 105/2021 و6/2022 محجوبان عن قرض خاص ويُقبلان عند ذكر نشاط خاضع للرقابة المالية', () => {
    expect(articleInLawScope(loanPrivate, art(105, 2021))).toBe(false);
    expect(articleInLawScope(loanPrivate, art(6, 2022))).toBe(false);
    expect(articleInLawScope(loanLicensed, art(105, 2021))).toBe(true);
    expect(articleInLawScope(loanLicensed, art(6, 2022))).toBe(true);
  });

  it('49/1977 و136/1981 لا يظهران على عقد إيجار تجارى جديد (قرار المالك: يحكمه المدنى) ويظهران عند ذكر علاقة إيجار قديمة', () => {
    const newLease = lawScopeContext('عقد إيجار محل تجارى لمدة سنة تبدأ من 1/1/2027 بين المؤجرة والمستأجر.', 'lease');
    const oldLease = lawScopeContext('عقد إيجار قديم خاضع للقانون 49 لسنة 1977 وامتداده القانونى.', 'lease');
    expect(articleInLawScope(newLease, art(49, 1977))).toBe(false);
    expect(articleInLawScope(newLease, art(136, 1981))).toBe(false);
    expect(articleInLawScope(oldLease, art(49, 1977))).toBe(true);
  });
});
