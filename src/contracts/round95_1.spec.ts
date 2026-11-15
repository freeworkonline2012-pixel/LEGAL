import { checkOpenTerms, sentencesOf, type LevelClause } from './contract-level';
import { mandatoryRuleHits } from './mandatory-rules';
import { officeRuleFindings } from './office-rules';

const cl = (i: number, text: string): LevelClause => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: text });
const office = (clauses: LevelClause[], type = 'عقد إيجار') => officeRuleFindings(clauses, { contractType: type, textMayBeIncomplete: false });

/** نص ممسوح: الجملة الواحدة ملفوفة على أسطر بعرض الصفحة (بلا علامة نهاية فى آخر السطر) */
const WRAPPED_LATE_INTEREST =
  'التأخر فى السداد: إذا تأخر المقترض عن أى قسط ولو لساعة واحدة التزم بفائدة تأخير\n' + '962 شهرياً مضافة إلى المبلغ كله لا إلى القسط المتأخر، وتتراكم الفائدة وتصبح جزءاً من أصل الدين.';

describe('R95.1 — جمل البند من نص ملفوف الأسطر (OCR)', () => {
  it('الجملة الملفوفة على سطرين جملة واحدة', () => {
    const s = sentencesOf(WRAPPED_LATE_INTEREST);
    expect(s).toHaveLength(1);
    expect(s[0]).toContain('فائدة تأخير 962 شهرياً');
  });

  it('السطر القصير والسطر الفارغ والسطر المختوم بنقطة وعلامة القائمة فواصل', () => {
    expect(sentencesOf('الفائدة:\nيستحق المقرض فائدة بواقع 7% سنوياً على الرصيد القائم.')).toHaveLength(2);
    expect(sentencesOf('يستحق المقرض فائدة بواقع 7% سنوياً على الرصيد القائم أول كل شهر\n\nويلتزم المقترض بسداد الأقساط فى مواعيدها المحددة بالجدول.')).toHaveLength(2);
    expect(sentencesOf('يلتزم المقترض بسداد الأقساط فى مواعيدها المحددة بالجدول المرفق بالعقد.\nويلتزم المقرض بتسليم القرض فى الموعد المتفق عليه بين الطرفين.')).toHaveLength(2);
    expect(sentencesOf('يلتزم المقترض بما يلى من الالتزامات المتفق عليها بين الطرفين فى هذا العقد\n1- سداد الأقساط فى مواعيدها\n2- إخطار المقرض بأى تغيير جوهرى')).toHaveLength(3);
  });

  it('فائدة التأخير 962 شهرياً (النسبة التالفة) فى جملة ملفوفة ⇒ interest_cap مرشحة (كانت لا تُرصد)', () => {
    const h = mandatoryRuleHits(WRAPPED_LATE_INTEREST).find((x) => x.ruleId === 'interest_cap')!;
    expect(h).toBeDefined();
    expect(h.uncertainReading).toBe(true);
  });

  it('الإنهاء المبكر دون تعويض فى جملة ملفوفة على ثلاثة أسطر ⇒ يُرصد', () => {
    const t = 'مدة الإيجار: مدة الإيجار ثلاث سنوات تبدأ من 1/1/2027، وللمؤجرة إنهاؤه قبل المدة إذا احتاجت\nالعين لأغراض شخصية أو لهدم العقار أو ترميمه بإخطار قبل شهر،\nدون التزام بتعويض المستأجر عن التجهيزات.';
    expect(office([cl(3, t)]).some((x) => x.id === 'office:early_termination_no_compensation')).toBe(true);
  });

  it('خبير تختاره المؤجرة وقد فصل الالتفاف الفعل عن الفاعل ⇒ يُرصد', () => {
    const t = 'تتحمل المؤجرة الإصلاحات الإنشائية الجسيمة فقط إذا ثبت أنها لم تنشأ عن الاستعمال بتقرير\nتختاره المؤجرة وتتحمل المستأجر ما عدا ذلك من الإصلاحات.';
    expect(office([cl(7, t)]).some((x) => x.id === 'office:one_sided_determiner')).toBe(true);
  });
});

describe('R95.1 — مقابل مالى يُحدَّد «بإخطار لاحق»', () => {
  it('مصروفات «يحددها بإخطار لاحق» (تمويل ج بند 2) ⇒ شرط مفتوح متوسط', () => {
    const t = 'مبلغ القرض: مبلغ القرض 2000000 جنيه يصرف بتحويل بنكى إلى حساب الشركة، ويخصم منه عند الصرف ما يستحقه المقرض من مصروفات دراسة ومتابعة وإدارة يحددها بإخطار لاحق.';
    const f = checkOpenTerms([cl(2, t)]);
    expect(f).toHaveLength(1);
    expect(f[0].severity).toBe('متوسط');
    expect(f[0].kind).toBe('open_term');
  });

  it('مصروفات محددة فى العقد أو بالاتفاق ⇒ لا ملاحظة', () => {
    expect(checkOpenTerms([cl(2, 'يخصم من القرض عند الصرف مصروفات دراسة بنسبة 1% من مبلغ القرض تُخصم مرة واحدة.')])).toHaveLength(0);
    expect(checkOpenTerms([cl(2, 'تُحدد المصروفات بالاتفاق الكتابى بين الطرفين قبل الصرف.')])).toHaveLength(0);
  });
});
