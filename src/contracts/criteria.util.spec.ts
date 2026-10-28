import {
  anchorArticleNumbers,
  classifyClauseCriteria,
  leaseAnchorArticleNumbers,
  servicesAnchorArticleNumbers,
  scopedLawsForClause,
  scopedLawsForCriteria,
  serializeCriteria,
} from './criteria.util';

describe('classifyClauseCriteria', () => {
  it('يصنّف شرطاً جزائياً كتعويض', () => {
    const r = classifyClauseCriteria('الشرط الجزائي', 'إذا تأخر المستأجر فى السداد التزم بغرامة تأخير قدرها 5%.');
    expect(r).toContain('compensation');
  });
  it('يصنّف القوة القاهرة', () => {
    expect(classifyClauseCriteria('القوة القاهرة', 'لا يسأل أى طرف عن التأخير الناشئ عن قوة قاهرة.')).toContain(
      'force_majeure',
    );
  });
  it('يصنّف الفسخ والإنهاء كخروج', () => {
    expect(classifyClauseCriteria('الفسخ', 'يحق للمؤجر فسخ العقد بإخطار كتابى.')).toContain('exit');
  });
  it('يصنّف الإعفاء من المسؤولية', () => {
    expect(classifyClauseCriteria('المسؤولية', 'يُعفى الطرف الأول من أية مسئولية عن الأضرار.')).toContain('liability');
  });
  it('يصنّف التفرد بالقرار كمعاملة بالمثل', () => {
    expect(classifyClauseCriteria(null, 'يجوز للطرف الأول تعديل الأجرة بإرادته المنفردة.')).toContain('reciprocity');
  });
  it('يصنّف حماية البيانات الشخصية', () => {
    expect(classifyClauseCriteria('البيانات', 'يلتزم الطرفان بحماية البيانات الشخصية.')).toContain('data_protection');
  });
  it('لا يصنّف بنداً بلا إشارات (أطراف العقد)', () => {
    expect(classifyClauseCriteria('الأطراف', 'تم الاتفاق بين السيد أحمد والسيد محمد')).toEqual([]);
  });
  it('بحد أقصى 3 معايير', () => {
    const r = classifyClauseCriteria(
      'عام',
      'تعويض ومسئولية وفسخ وسداد وقوة قاهرة وضريبة وبيانات شخصية وإخطار ودفعات',
    );
    expect(r.length).toBeLessThanOrEqual(3);
  });
});

describe('anchorArticleNumbers', () => {
  it('يناوب بين المعايير بلا تكرار ويحترم الحد الأقصى', () => {
    const r = anchorArticleNumbers(['liability', 'compensation', 'financial_impact'], 4);
    expect(r).toHaveLength(4);
    expect(new Set(r).size).toBe(4);
    expect(r[0]).toBe(217);
    expect(r[1]).toBe(224);
  });
  it('يعيد قائمة فارغة لمعيار بلا مواد مرجعية', () => {
    expect(anchorArticleNumbers(['duration', 'legal_compliance'])).toEqual([]);
  });
  it('القوة القاهرة تضم 373 و165 و159 و147', () => {
    expect(anchorArticleNumbers(['force_majeure'], 5)).toEqual([373, 165, 159, 147]);
  });
});

describe('scopedLawsForCriteria / serializeCriteria', () => {
  it('حماية البيانات مقيَّدة بالقانون 151/2020', () => {
    expect(scopedLawsForCriteria(['data_protection', 'exit'])).toMatchObject([{ lawNo: 151, lawYear: 2020 }]);
  });
  it('تسلسل المفاتيح', () => {
    expect(serializeCriteria(['exit', 'payment'])).toBe('exit,payment');
    expect(serializeCriteria([])).toBeNull();
  });
});

describe('leaseAnchorArticleNumbers', () => {
  it('بند معاينة فى عقد إيجار يجلب مواد ضمان العيوب', () => {
    const r = leaseAnchorArticleNumbers(null, 'يقر المستأجر بأنه عاين العين المؤجرة المعاينة التامة النافية للجهالة.');
    expect(r).toContain(576);
    expect(r).toContain(578);
  });
  it('بند رد العين وانتهاء المدة', () => {
    const r = leaseAnchorArticleNumbers('الانتهاء', 'عند انتهاء العقد يلتزم المستأجر بتسليم العين المؤجرة خالية.');
    expect(r).toContain(590);
  });
  it('لا مواد إيجار لبند ليس فى سياق إيجار', () => {
    expect(leaseAnchorArticleNumbers(null, 'يحل البائع محل الشركة فى التزامات التوريد وتسليم البضاعة.')).toEqual([]);
  });
  it('يحترم الحد الأقصى', () => {
    expect(
      leaseAnchorArticleNumbers(null, 'المستأجر يسدد الأجرة ويعاين العين وينهى العقد ويغير الديكور ويجدد المدة.', 3).length,
    ).toBeLessThanOrEqual(3);
  });
});

describe('القوة القاهرة بصيغ العقود المصرية', () => {
  it('«الأسباب القهرية» و«خارجة عن إرادة» تُصنَّف قوة قاهرة', () => {
    const r = classifyClauseCriteria(null, 'التأخير يرجع لأحد الأسباب القهرية التى نص عليها القانون، أو لأسباب أخرى خارجه عن إرادة أى منهما.');
    expect(r).toContain('force_majeure');
  });
});


describe('scopedLawsForClause (الجولة 5: التحكيم والملكية الفكرية والبيانات)', () => {
  const nums = (title: string | null, text: string) =>
    scopedLawsForClause(classifyClauseCriteria(title, text), title, text).map((s) => `${s.lawNo}/${s.lawYear}`);

  it('بند التحكيم يُربط بقانون 27/1994', () => {
    expect(nums('التحكيم', 'تحال كل المنازعات إلى التحكيم وفق قواعد مركز القاهرة الإقليمى للتحكيم التجارى الدولى وتشكل هيئة التحكيم من ثلاثة محكمين.')).toContain('27/1994');
  });
  it('بند يذكر «المحكم» منفرداً يُربط بقانون التحكيم', () => {
    expect(nums(null, 'يعين الطرفان محكماً واحداً يفصل فى النزاع.')).toContain('27/1994');
  });
  it('«المحكمة المختصة» أو «محاكم القاهرة» لا تُربط بقانون التحكيم', () => {
    expect(nums('الاختصاص', 'تختص المحكمة المختصة بنظر النزاع وتختص محاكم القاهرة.')).not.toContain('27/1994');
  });
  it('بند ملكية الشفرة المصدرية وحقوق المؤلف يُربط بقانون 82/2002', () => {
    expect(nums('الملكية', 'يظل النظام وشفرته المصدرية ملكاً للطرف الأول.')).toContain('82/2002');
    expect(nums(null, 'تؤول حقوق المؤلف والعلامات التجارية وبراءات الاختراع للمورد.')).toContain('82/2002');
    expect(nums('الترخيص', 'يمنح الطرف الأول ترخيص استخدام البرنامج.')).toContain('82/2002');
  });
  it('البيانات الشخصية للعملاء والمرضى والخرق تُربط بقانون 151/2020', () => {
    expect(nums(null, 'يعالج المورد بيانات المرضى ويلتزم بالإخطار عند أى خرق للبيانات.')).toContain('151/2020');
    expect(nums(null, 'يخضع التسويق الإلكترونى لموافقة صاحب بيانات العملاء.')).toContain('151/2020');
  });
  it('بند لا صلة له لا يحمل أى قانون مقيَّد', () => {
    expect(nums('الأطراف', 'تم الاتفاق بين السيد أحمد والسيد محمد')).toEqual([]);
    expect(nums('التسليم', 'يسلم الطرف الأول النظام خلال تسعين يوماً من تاريخ التعاقد.')).toEqual([]);
  });
  it('لا تكرار حين يتفق المعيار والموضوع على القانون نفسه', () => {
    const r = nums('حماية البيانات', 'يلتزم الطرفان بحماية البيانات الشخصية ومعالجة بيانات العملاء.');
    expect(r.filter((x) => x === '151/2020')).toHaveLength(1);
  });
  it('المرشَّح يحمل كلمات موضوعية للبحث', () => {
    const r = scopedLawsForClause([], null, 'اتفق الطرفان على التحكيم');
    expect(r[0].seed).toContain('التحكيم');
  });
});

describe('servicesAnchorArticleNumbers (الجولة 30)', () => {
  it('بند تسليم وقبول فى عقد تطوير يجلب مادة تسلم العمل', () => {
    const r = servicesAnchorArticleNumbers('التسليم', 'يلتزم الطرف الأول بتسليم المشروع وفق مراحل التطوير ويقبل الطرف الثانى العمل بمحضر استلام.');
    expect(r).toContain(655);
  });
  it('بند الأجر والدفعات يجلب 656 و659', () => {
    const r = servicesAnchorArticleNumbers(null, 'يسدد رب العمل الأجر على دفعات حسب مراحل تنفيذ العمل.', 3);
    expect(r).toEqual(expect.arrayContaining([656]));
  });
  it('إنهاء العقد من رب العمل يجلب 663', () => {
    expect(servicesAnchorArticleNumbers(null, 'لرب العمل إنهاء العقد ووقف تنفيذ العمل فى أى وقت.')).toContain(663);
  });
  it('المقاول من الباطن يجلب 661', () => {
    expect(servicesAnchorArticleNumbers(null, 'لا يجوز للمقاول التعاقد من الباطن لتنفيذ العمل دون موافقة رب العمل.')).toContain(661);
  });
  it('لا مواد مقاولة لبنود الإيجار أو البيع أو العمل', () => {
    expect(servicesAnchorArticleNumbers(null, 'يلتزم المستأجر بسداد الأجرة وتسليم العين المؤجرة عند انتهاء مدة المشروع.')).toEqual([]);
    expect(servicesAnchorArticleNumbers(null, 'يلتزم البائع بتسليم المبيع وسداد المشتري للثمن.')).toEqual([]);
    expect(servicesAnchorArticleNumbers(null, 'يلتزم العامل بتنفيذ العمل مقابل الراتب.')).toEqual([]);
  });
  it('بند لا صلة له بالخدمات لا يجلب شيئاً، ويحترم الحد الأقصى', () => {
    expect(servicesAnchorArticleNumbers(null, 'يقر الطرفان بصحة العناوين الواردة بصدر العقد.')).toEqual([]);
    expect(
      servicesAnchorArticleNumbers(null, 'يسلم المقاول العمل ويسدد رب العمل الأجر ويجوز إنهاء العقد ومن الباطن واستحالة المواصفات.', 3).length,
    ).toBeLessThanOrEqual(3);
  });
});
