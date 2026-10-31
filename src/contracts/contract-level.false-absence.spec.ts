import { checkMissingClauses } from './contract-level';

/**
 * «لم يُرصد بند يتناول…» ادعاء غياب: خطؤه يُفقد التقرير مصداقيته أمام المحامى. وقع فعلاً فى تقرير على عقد إيجار حقيقى أن قيل
 * «لم يُرصد التأمين (الوديعة)» و«الغرض/التأجير من الباطن» و«الإخطارات» وكلها مذكورة فى العقد بصيغ لم تطابقها الأنماط، وعلى اتفاقية سرية
 * أن قيل «لم يُرصد تعديل العقد» وفى البند 6.2 «لا تكون أي تعديلات… إلا إذا كانت مكتوبة وموقعة».
 */
const clause = (i: number, text: string, title: string | null = null) => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: title, clauseText: text });
const missing = (clauses: ReturnType<typeof clause>[], type: string) =>
  checkMissingClauses(clauses as never, { contractType: type, textMayBeIncomplete: false }).map((f) => f.id.replace('missing:', ''));

const FILLER = 'يلتزم الطرف الاول بتسليم الشقة المؤجرة صالحة للانتفاع بها وتسرى مدة الايجار خمس سنوات من 1/7/2024 وتنتهى فى 30/6/2029 والقيمة الايجارية شهريا 20000 جنيه. ';

describe('عقد إيجار: ما هو مذكور بصيغة غير نمطية لا يُدّعى غيابه', () => {
  it('«التامين : سدد المستاجر … مبلغا قدره 50000 جنيه … قيمة تامين يرد اليه»', () => {
    const c = [clause(1, FILLER), clause(2, 'التامين : سدد المستاجر للمؤجر مبلغا قدره 50000 جنيه ( خمسون الف جنيه ) بشيك اثناء التوقيع قيمة تامين يرد اليه فى نهاية مدة العقد عند تسليم الشقة.')];
    expect(missing(c, 'عقد إيجار')).not.toContain('lease_deposit');
  });

  it('منع التنازل والتأجير من الباطن يُعدّ تنظيماً للتأجير من الباطن', () => {
    const c = [clause(1, FILLER), clause(2, 'يمتنع على المستاجر منعا باتا ان يتنازل عن الايجار او يؤجر من الباطن كل او بعض المكان المؤجر له.')];
    expect(missing(c, 'عقد إيجار')).not.toContain('lease_use');
  });

  it('«المحل المختار: … كل اخطار او انذار يرسل له صحيحا» هو بند الإخطارات', () => {
    const c = [clause(1, FILLER), clause(2, 'المحل المختار : يقر كل من المتعاقدين باتخاذه محلا مختارا لعنوانه المذكور بصدر هذا العقد، وبان كل اخطار او انذار او اعلان يرسل له فيه صحيحا قانونا.')];
    expect(missing(c, 'عقد إيجار')).not.toContain('notices');
  });

  it('وحيث لا ذكر لها فعلاً يبقى الادعاء قائماً (لا إفراط فى التساهل)', () => {
    const m = missing([clause(1, FILLER)], 'عقد إيجار');
    expect(m).toEqual(expect.arrayContaining(['lease_deposit', 'lease_use', 'notices', 'amendments']));
  });
});

describe('اتفاقية: «لا تكون أي تعديلات على هذه الاتفاقية سارية إلا إذا كانت مكتوبة وموقعة» بند تعديل', () => {
  it('لا يُقال إن تعديل العقد غير مذكور', () => {
    const c = [
      clause(1, 'يتعهد المصمم بالحفاظ على السرية التامة لجميع المعلومات السرية التى يطلع عليها بموجب هذه الاتفاقية لمدة خمس سنوات.'),
      clause(2, 'لا تكون أي تعديلات أو تغييرات على هذه الاتفاقية سارية المفعول إلا إذا كانت مكتوبة وموقعة من كلا الطرفين.', 'التعديلات'),
    ];
    expect(missing(c, 'اتفاقية سرية')).not.toContain('amendments');
  });
});

describe('مدة مفتوحة صراحة ليست «غير مرصودة»', () => {
  const nda = [
    clause(1, 'يتعهد المصمم بالحفاظ على السرية التامة لجميع المعلومات السرية التى يطلع عليها بموجب هذه الاتفاقية.'),
    clause(2, 'تظل هذه الاتفاقية سارية إلى أجل غير مسمى أو حتى يتم إنهاؤها باتفاق خطي متبادل بين الطرفين.', 'المدة'),
  ];

  it('«سارية إلى أجل غير مسمى»: بند مدة مفتوحة بدليل من نص العقد لا ادّعاء غياب', () => {
    const f = checkMissingClauses(nda as never, { contractType: 'اتفاقية سرية', textMayBeIncomplete: false });
    expect(f.some((x) => x.id === 'missing:duration')).toBe(false);
    const open = f.find((x) => x.id === 'open:indefinite_duration')!;
    expect(open.kind).toBe('open_term');
    expect(open.severity).toBe('متوسط');
    expect(open.evidence[0].quote).toContain('أجل غير مسمى');
    expect(open.evidence[0].clauseLabel).toBe('البند 2');
  });

  it('عقد بلا أى ذكر للمدة يبقى «غير مرصود» بعالٍ', () => {
    const f = checkMissingClauses([clause(1, 'يلتزم الطرف الاول بتسليم البضاعة المتفق عليها للطرف الثانى فى مقر الشركة وفق الاصول.')] as never, {
      contractType: 'عقد خدمات أو مقاولة أو توريد',
      textMayBeIncomplete: false,
    });
    const d = f.find((x) => x.id === 'missing:duration')!;
    expect(d.severity).toBe('عالٍ');
  });
});
