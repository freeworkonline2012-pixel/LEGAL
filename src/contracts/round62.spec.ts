import { articleInLawScope, lawScopeContext } from './law-scope';
import { checkBlankNumbers, checkInternalReferences, clauseNumberOf, internalConsistencyFindings } from './internal-checks';
import type { LevelClause } from './contract-level';
import { officeRuleFindings } from './office-rules';
import { inferContractFamilyFromBody, resolveContractFamily } from './contract-level';
import { isDismissedFindingVerification } from './verification';

const clause = (i: number, title: string, text: string, label = `البند ${i}`): LevelClause => ({ clauseIndex: i, clauseLabel: label, clauseTitle: title, clauseText: text });
const opts = (contractType: string | null, textMayBeIncomplete = false) => ({ contractType, textMayBeIncomplete });
const ids = (cs: LevelClause[], type: string | null, incomplete = false) => officeRuleFindings(cs, opts(type, incomplete)).map((f) => f.id);

const refuted = (refutationKind: string, quote: string | null = 'نص موثَّق') => ({ status: 'unconfirmed' as const, basis: 'refuted', refutationKind, quote });

describe('الجولة 61.1: الاستبعاد بحسب نوع الملاحظة', () => {
  it('«reconciled» يستبعد التعارض وعدم الاتساق فقط', () => {
    expect(isDismissedFindingVerification('conflict', refuted('reconciled'))).toBe(true);
    expect(isDismissedFindingVerification('scope_mismatch', refuted('reconciled'))).toBe(true);
  });
  it('«reconciled» لا يستبعد شرطاً مفتوحاً ولا مصطلحاً/إحالة غير معرَّفة ولا غياب بند ولا قاعدة مكتب', () => {
    for (const kind of ['open_term', 'undefined_term', 'missing_clause', 'office_rule']) {
      expect(isDismissedFindingVerification(kind, refuted('reconciled'))).toBe(false);
    }
  });
  it('الشرط المفتوح والمصطلح غير المعرَّف يُستبعدان بـ clause_addresses أو not_applicable فقط', () => {
    for (const kind of ['open_term', 'undefined_term']) {
      expect(isDismissedFindingVerification(kind, refuted('clause_addresses'))).toBe(true);
      expect(isDismissedFindingVerification(kind, refuted('not_applicable'))).toBe(true);
      expect(isDismissedFindingVerification(kind, refuted('not_mandatory'))).toBe(false);
      expect(isDismissedFindingVerification(kind, refuted('other'))).toBe(false);
    }
  });
  it('بلا اقتباس موثَّق أو بغير refuted لا استبعاد أياً كان النوع', () => {
    expect(isDismissedFindingVerification('conflict', refuted('reconciled', null))).toBe(false);
    expect(isDismissedFindingVerification('conflict', { status: 'unconfirmed', basis: 'uncertain', refutationKind: 'reconciled', quote: 'ن' })).toBe(false);
    expect(isDismissedFindingVerification('conflict', null)).toBe(false);
  });
});

describe('الجولة 62: عدد مفقود قبل الوحدة (ق5)', () => {
  it('«فى خلال اسبوع    أيام عمل» (العدد ضائع) يُرصد باقتباس حرفى', () => {
    const c = clause(4, 'المقابل', 'يتم تحويل المبالغ إلى الطرف الثانى فى خلال اسبوع    أيام عمل من تاريخ استلامها.');
    const f = checkBlankNumbers([c], { textMayBeIncomplete: false });
    expect(f).toHaveLength(1);
    expect(f[0].severity).toBe('متوسط');
    expect(f[0].kind).toBe('open_term');
    expect(f[0].evidence[0].quote).toContain('أيام عمل');
  });
  it('الفراغ بنقاط أو شرطات أو أقواس يُرصد', () => {
    for (const t of ['يسدد المستأجر خلال ____ يوماً من الإخطار.', 'تلتزم الشركة بالرد خلال ..... أيام عمل.', 'يكون الإخطار قبل ( ) يوماً من الانتهاء.']) {
      expect(checkBlankNumbers([clause(1, 'x', t)], { textMayBeIncomplete: false })).toHaveLength(1);
    }
  });
  it('العدد المكتوب لا يُرصد، ولا «أسبوع» وحدها ولا الوحدة المسبوقة بعدد', () => {
    for (const t of ['يتم التحويل خلال ثلاثة أيام عمل من تاريخ الاستلام.', 'يتم التحويل خلال 3 أيام عمل.', 'يتم التحويل أسبوعياً.', 'يسدد خلال أسبوع من الاستلام.']) {
      expect(checkBlankNumbers([clause(1, 'x', t)], { textMayBeIncomplete: false })).toEqual([]);
    }
  });
  it('على النص الممسوح يضيف التنبيه إلى احتمال ضياع الرقم فى القراءة', () => {
    const c = clause(4, 'المقابل', 'يتم التحويل فى خلال اسبوع    أيام عمل من تاريخ استلامها.');
    expect(checkBlankNumbers([c], { textMayBeIncomplete: true })[0].explanation).toContain('قارن بالأصل');
  });
});

describe('الجولة 62: الإحالات الداخلية (ق8)', () => {
  it('رقم البند من عنوانه الترتيبى أو الرقمى', () => {
    expect(clauseNumberOf(clause(1, '', 'ن', 'البند السادس'))).toBe(6);
    expect(clauseNumberOf(clause(1, '', 'ن', 'البند 12'))).toBe(12);
    expect(clauseNumberOf(clause(1, '', 'ن', 'نص سابق لـ البند الأول'))).toBeNull();
  });
  it('البند السادس يصف نفسه «هذا البند السابع» فيُرصد', () => {
    const c6 = clause(6, 'السرية', 'يلتزم الطرف الثانى بالسرية. وفى حالة إخلاله بالتزاماته بموجب هذا البند السابع يكون العقد مفسوخاً.', 'البند السادس');
    const f = checkInternalReferences([c6]);
    expect(f.map((x) => x.id)).toEqual(['ref:self:6']);
    expect(f[0].severity).toBe('منخفض');
    expect(f[0].evidence[0].quote).toContain('هذا البند السابع');
  });
  it('«هذا البند» بلا رقم أو برقمه الصحيح لا يُرصد', () => {
    const ok = clause(6, 'السرية', 'يلتزم الطرف الثانى بالسرية بموجب هذا البند. ويسرى هذا البند السادس طوال المدة.', 'البند السادس');
    expect(checkInternalReferences([ok])).toEqual([]);
  });
  it('الإحالة إلى بند فرعى لا يتصل بموضوعها تُرصد بدرجة منخفضة وصياغة احتمالية', () => {
    const c8 = clause(8, 'المراقبة', 'يتولى مقدم الخدمة مراقبة العمليات المشبوهة والإبلاغ عنها كما هو منصوص عليه فى البند الفرعى 10-1.', 'البند الثامن');
    const c10 = clause(10, 'أحكام ختامية', 'تخضع جميع المراسلات بين الطرفين للعناوين المذكورة بصدر العقد، ولا يعتد بغيرها.', 'البند العاشر');
    const f = checkInternalReferences([c8, c10]);
    expect(f).toHaveLength(1);
    expect(f[0].id).toBe('ref:topic:8:10-1');
    expect(f[0].explanation).toContain('والمحامى يقطع');
  });
  it('الإحالة إلى بند فرعى متصل بالموضوع لا تُرصد', () => {
    const c8 = clause(8, 'المراقبة', 'يتولى مقدم الخدمة مراقبة العمليات المشبوهة والإبلاغ عنها كما هو منصوص عليه فى البند الفرعى 10-1.', 'البند الثامن');
    const c10 = clause(10, 'الإبلاغ', 'يتم الإبلاغ عن العمليات المشبوهة إلى جهة الرقابة عبر القنوات المعتمدة، وتوثق المراقبة فى سجل.', 'البند العاشر');
    expect(checkInternalReferences([c8, c10])).toEqual([]);
  });
  it('رقم البند المُحال إليه غير موجود أو بند غير معلوم الرقم: لا حكم (فشل آمن)', () => {
    const c8 = clause(8, 'المراقبة', 'يتولى مقدم الخدمة مراقبة العمليات المشبوهة والإبلاغ عنها وفق البند الفرعى 40-1.', 'البند الثامن');
    expect(checkInternalReferences([c8])).toEqual([]);
    expect(internalConsistencyFindings([clause(1, 'x', 'نص عادى بلا إحالات')], { textMayBeIncomplete: false })).toEqual([]);
  });
});

const COLLECTION_BASE = [
  clause(1, 'موضوع العقد', 'يلتزم مقدم الخدمة بتقديم خدمات التحصيل الإلكترونى لأقساط الوثائق من عملاء الطرف الثانى.', 'البند الأول'),
  clause(4, 'المقابل', 'تحدد عمولات التحصيل كالتالى. يتم تحويل إجمالى المبالغ المحصلة أسبوعياً إلى حساب الطرف الثانى.', 'البند الرابع'),
];

describe('الجولة 62: قواعد عقود الخدمات والتحصيل', () => {
  it('ق2: تحويل أسبوعى بلا يوم ولا مهلة ولا جزاء يُرصد عالياً؛ ومع اليوم والجزاء لا يُرصد', () => {
    expect(ids(COLLECTION_BASE, 'خدمات')).toContain('office:collected_funds_transfer_terms');
    const f = officeRuleFindings(COLLECTION_BASE, opts('خدمات')).find((x) => x.id === 'office:collected_funds_transfer_terms')!;
    expect(f.severity).toBe('عالٍ');
    expect(f.evidence[0].quote).toContain('أسبوعياً');
    const ok = [
      COLLECTION_BASE[0],
      clause(4, 'المقابل', 'يتم تحويل إجمالى المبالغ المحصلة أسبوعياً كل يوم أحد إلى حساب الطرف الثانى. وعن كل يوم تأخير فى تحويل المبالغ تستحق غرامة تأخير بنسبة 1%.'),
    ];
    expect(ids(ok, 'خدمات')).not.toContain('office:collected_funds_transfer_terms');
  });
  it('ق3/ق4: غياب المراجعة وحفظ الأموال يُرصدان بلا اقتباس ثابت، ويسقطان بوجود النص', () => {
    const f = officeRuleFindings(COLLECTION_BASE, opts('خدمات'));
    expect(f.map((x) => x.id)).toEqual(expect.arrayContaining(['office:collected_funds_no_audit_right', 'office:collected_funds_no_segregation']));
    expect(f.find((x) => x.id === 'office:collected_funds_no_audit_right')!.severity).toBe('عالٍ');
    expect(f.find((x) => x.id === 'office:collected_funds_no_segregation')!.severity).toBe('متوسط');
    const withText = [
      ...COLLECTION_BASE,
      clause(5, 'الحسابات', 'للطرف الثانى الحق فى مراجعة سجلات التحصيل ومطابقتها شهرياً. وتعد المبالغ المحصلة أمانة تودع فى حساب منفصل.'),
    ];
    const g = ids(withText, 'خدمات');
    expect(g).not.toContain('office:collected_funds_no_audit_right');
    expect(g).not.toContain('office:collected_funds_no_segregation');
  });
  it('قواعد التحصيل لا تعمل على عقد خدمات لا تحصيل فيه', () => {
    const c = [clause(1, 'موضوع', 'يلتزم مقدم الخدمة بتطوير موقع إلكترونى للعميل وتسليمه خلال ستين يوماً.')];
    const g = ids(c, 'خدمات');
    expect(g).not.toContain('office:collected_funds_no_audit_right');
    expect(g).not.toContain('office:collected_funds_no_segregation');
    expect(g).not.toContain('office:collected_funds_transfer_terms');
  });
  it('ادعاء الغياب على نص ممسوح بتحذيرات يبقى «غير مؤكد» (مرشح)', () => {
    const f = officeRuleFindings(COLLECTION_BASE, opts('خدمات', true)).find((x) => x.id === 'office:collected_funds_no_audit_right')!;
    expect(f.verification?.status).toBe('unconfirmed');
    const present = officeRuleFindings(COLLECTION_BASE, opts('خدمات', true)).find((x) => x.id === 'office:collected_funds_transfer_terms')!;
    expect(present.verification ?? null).toBeNull();
  });
  it('ق1: الحصرية على العميل وحده متوسطة؛ المتبادلة لا تُرصد', () => {
    const c = clause(10, 'أحكام عامة', 'لا يجوز للعميل — فى أى وقت طوال مدة هذا العقد — التعاون أو العمل بأى شكل من الأشكال مع أى جهة قد تكون من المنافسين لمقدم الخدمة.');
    const f = officeRuleFindings([c], opts('خدمات')).find((x) => x.id === 'office:exclusivity_binds_client')!;
    expect(f.severity).toBe('متوسط');
    const mutual = clause(10, 'أحكام عامة', 'لا يجوز للعميل التعاون مع أى جهة منافسة لمقدم الخدمة. ولا يجوز لمقدم الخدمة التعاون مع أى جهة منافسة للعميل.');
    expect(ids([mutual], 'خدمات')).not.toContain('office:exclusivity_binds_client');
  });
  it('ق6: شرائح العمولة بلا بيان تُرصد عالياً ومعها صفوف الشرائح، وبيان التطبيق يسقطها', () => {
    const tiers = clause(
      4,
      'العمولات',
      'تحسب العمولة بحسب الحجم الشهرى كالتالى:\nأقل من 5000000: 1.3%\n5000000:10000000: 1.2%\nأكبر من 10000000: 1.1%',
    );
    const f = officeRuleFindings([tiers], opts('خدمات')).find((x) => x.id === 'office:commission_tiers_ambiguous')!;
    expect(f).toBeDefined();
    expect(f.severity).toBe('عالٍ');
    expect(f.evidence.length).toBeGreaterThanOrEqual(2);
    const clear = clause(4, 'العمولات', 'تحسب العمولة بحسب الحجم الشهرى كالتالى:\nأقل من 5000000: 1.3%\nأكبر من 10000000: 1.1%\nوتسرى النسبة على الجزء الواقع فى كل شريحة فقط.');
    expect(ids([clear], 'خدمات')).not.toContain('office:commission_tiers_ambiguous');
    const single = clause(4, 'العمولات', 'عمولة التحصيل 1.5% من قيمة كل عملية.');
    expect(ids([single], 'خدمات')).not.toContain('office:commission_tiers_ambiguous');
  });
  it('ق7: «1.8% + 2 جنيه» بلا «لكل عملية» تُرصد عالياً؛ ومع «عن كل عملية» لا', () => {
    const c = clause(4, 'العمولات', 'عمولة التحصيل عبر المحافظ الإلكترونية 1.8% + 2 جنيه.');
    const f = officeRuleFindings([c], opts('خدمات')).find((x) => x.id === 'office:fixed_fee_plus_percent_unspecified')!;
    expect(f.severity).toBe('عالٍ');
    const ok = clause(4, 'العمولات', 'عمولة التحصيل 1.8% + 2 جنيه عن كل عملية ناجحة.');
    expect(ids([ok], 'خدمات')).not.toContain('office:fixed_fee_plus_percent_unspecified');
  });
  it('ق13: العمولات غير المتضمنة ضريبة القيمة المضافة تُرصد عالياً دون استشهاد بنص قانونى', () => {
    const c = clause(4, 'العمولات', 'جميع هذه العمولات غير متضمنة ضريبة القيمة المضافة.');
    const f = officeRuleFindings([c], opts('خدمات')).find((x) => x.id === 'office:fees_exclusive_of_vat')!;
    expect(f.severity).toBe('عالٍ');
    expect(f.explanation).not.toMatch(/القانون رقم|لسنة \d{4}/);
  });
  it('ق9: غياب حدود المسئولية والتعويض عالٍ؛ يسقط بأى منهما', () => {
    const base = [clause(1, 'موضوع العقد', 'يلتزم مقدم الخدمة بتقديم خدمات التحصيل الإلكترونى للعميل.')];
    expect(ids(base, 'خدمات')).toContain('office:no_liability_and_indemnity_terms');
    const withCap = [...base, clause(7, 'المسئولية', 'لا تتجاوز مسئولية مقدم الخدمة إجمالى العمولات المحصلة خلال اثنى عشر شهراً، عدا الغش والخطأ الجسيم.')];
    expect(ids(withCap, 'خدمات')).not.toContain('office:no_liability_and_indemnity_terms');
    const withIndemnity = [...base, clause(7, 'التعويض', 'يلتزم كل طرف بتعويض الطرف الآخر عن الأضرار المباشرة الناشئة عن إخلاله.')];
    expect(ids(withIndemnity, 'خدمات')).not.toContain('office:no_liability_and_indemnity_terms');
  });
  it('ق9: بند معنون بالمسئولية ولو غير محدود (مقاولة) لا يُعد غياباً؛ وكلمة «يحصل» العامة لا تجعل العقد عقد تحصيل', () => {
    const works = [clause(4, 'المسئولية', 'يتحمل المقاول مسئولية غير محدودة عن كل الأضرار المباشرة وغير المباشرة التى تلحق بصاحب العمل.')];
    expect(ids(works, 'مقاولة')).not.toContain('office:no_liability_and_indemnity_terms');
    const agent = [clause(1, 'العمولة', 'يحصل الوكيل على عمولة 8 % من قيمة الصفقات المبرمة.')];
    const g = ids(agent, 'وكالة');
    expect(g).not.toContain('office:collected_funds_no_audit_right');
    expect(g).not.toContain('office:collected_funds_no_segregation');
  });
  it('ق10: تداول بيانات عملاء العميل بلا حماية بيانات عالٍ؛ ومع نص الحماية لا', () => {
    expect(ids(COLLECTION_BASE, 'خدمات')).toContain('office:customer_data_without_protection');
    const withProtection = [...COLLECTION_BASE, clause(6, 'حماية البيانات', 'يلتزم مقدم الخدمة بحماية البيانات الشخصية للعملاء ومعالجتها لغرض تنفيذ العقد فقط.')];
    expect(ids(withProtection, 'خدمات')).not.toContain('office:customer_data_without_protection');
  });
  it('ق11: إنهاء وحيد بإخطار شهر بلا سبب عالٍ؛ وحق الفسخ للإخلال يسقطه', () => {
    const term = clause(7, 'مدة العقد', 'مدة العقد سنة ويجوز لأى طرف إنهاءه بخطاب مسجل بعلم الوصول قبل الانتهاء بشهر على الأقل.');
    expect(ids([term], 'خدمات')).toContain('office:no_termination_for_breach');
    const withBreach = [term, clause(8, 'الفسخ', 'يحق للطرف المتضرر فسخ العقد عند إخلال الطرف الآخر بأى من التزاماته الجوهرية بعد إخطاره ومنحه مهلة ثلاثين يوماً.')];
    expect(ids(withBreach, 'خدمات')).not.toContain('office:no_termination_for_breach');
  });
  it('ق12: «المحاكم المختصة» دون تحديد متوسطة؛ ومع تحديد المحكمة أو التحكيم لا', () => {
    const generic = clause(9, 'الاختصاص', 'تختص المحاكم المختصة بجمهورية مصر العربية بنظر أى نزاع ينشأ عن هذا العقد.');
    const f = officeRuleFindings([generic], opts('خدمات')).find((x) => x.id === 'office:court_not_specified')!;
    expect(f.severity).toBe('متوسط');
    // لا تكرار: العبارة العامة تتناولها ق12 وحدها
    expect(ids([generic], 'خدمات')).not.toContain('office:economic_courts_forum');
    const named = clause(9, 'الاختصاص', 'تختص محكمة القاهرة الاقتصادية بنظر أى نزاع ينشأ عن هذا العقد.');
    expect(ids([named], 'خدمات')).not.toContain('office:court_not_specified');
  });
  it('ق14: اقتراح المحاكم الاقتصادية منخفض ولغته اقتراحية وتعمل على التحكيم والمحاكم العادية، ولا تعمل على الإيجار والعمل أو مع ذكرها', () => {
    const arb = clause(9, 'الاختصاص', 'يحال أى نزاع ينشأ عن هذا العقد إلى التحكيم وفقا لقانون التحكيم المصرى.');
    const f = officeRuleFindings([arb], opts('شراكة')).find((x) => x.id === 'office:economic_courts_forum')!;
    expect(f.severity).toBe('منخفض');
    expect(f.explanation).toContain('اقتراح للأطراف لا التزام عليهم');
    expect(f.suggestion).toContain('يمكن');
    expect(f.suggestion).not.toContain('يجب');
    const ordinary = clause(9, 'الاختصاص', 'تختص محكمة القاهرة الابتدائية بنظر أى نزاع ينشأ عن هذا العقد.');
    expect(ids([ordinary], 'بيع')).toContain('office:economic_courts_forum');
    const econ = clause(9, 'الاختصاص', 'تختص المحاكم الاقتصادية بنظر أى نزاع ينشأ عن هذا العقد، ويحال إلى التحكيم ما يخرج عنها.');
    expect(ids([econ], 'شراكة')).not.toContain('office:economic_courts_forum');
    expect(ids([arb], 'إيجار')).not.toContain('office:economic_courts_forum');
    expect(ids([arb], 'عمل')).not.toContain('office:economic_courts_forum');
    expect(ids([clause(1, 'x', 'مدة العقد سنة.')], 'شراكة')).not.toContain('office:economic_courts_forum');
  });
  it('لا قواعد الخدمات على الشراكة ولا الإيجار', () => {
    const g = ids(COLLECTION_BASE, 'شراكة');
    expect(g.filter((x) => /collected_funds|exclusivity|commission_tiers|fees_exclusive|no_liability|no_termination|court_not_specified/.test(x))).toEqual([]);
  });
});

describe('الجولة 62: بوابة قطاع التأمين لا تُفتح باسم الطرف', () => {
  const brokerage = { lawNo: 69, lawYear: 2025 };
  const digital = { lawNo: 199, lawYear: 2025 };
  const contract0174 =
    'عقد إدارة خدمات التحصيل الإلكترونى. بين شركة مصر للتأمين التكافلى (الطرف الثانى) وشركة التحصيل (الطرف الأول). ' +
    'يقوم الطرف الأول بتحصيل مبالغ من عملاء الطرف الثانى عبر قنوات الدفع الإلكترونى مقابل عمولة.';
  it('اسم شركة التأمين وحده لا يمرر قرارات الوساطة وإصدار الوثائق', () => {
    expect(articleInLawScope(lawScopeContext(contract0174, null), brokerage)).toBe(false);
    expect(articleInLawScope(lawScopeContext(contract0174, null), digital)).toBe(false);
  });
  it('عبارات الموضوع تفتحها: وساطة التأمين وإصدار وثيقة التأمين وإعادة التأمين', () => {
    for (const t of ['عقد وساطة تأمين بين الشركة والوسيط', 'تتولى الشركة إصدار وثائق التأمين رقمياً', 'اتفاقية إعادة التأمين الاختيارى']) {
      expect(articleInLawScope(lawScopeContext(t, null), brokerage)).toBe(true);
    }
  });
  it('شركة وساطة التأمين بالاسم تظل ضمن القطاع', () => {
    expect(articleInLawScope(lawScopeContext('عقد مع شركة وساطة التأمين الدولية لتسويق المنتجات', null), brokerage)).toBe(true);
  });
});

describe('الجولة 62: عقد تحصيل بصيغ العقد الحقيقى (0174) — ما يُرصد وما لا يُرصد', () => {
  const c0174: LevelClause[] = [
    clause(1, 'موضوع العقد', 'يلتزم الطرف الأول بتقديم خدمات التحصيل الإلكترونى لأقساط الوثائق من عملاء الطرف الثانى.', 'البند الأول'),
    clause(3, 'التحصيل', 'يقوم الطرف الأول بتحصيل أقساط الوثائق من عملاء الطرف الثانى وإرسال التقارير الدورية.', 'البند الثالث'),
    clause(
      4,
      'العمولات وآلية التحويل',
      '4-1 تحسب عمولات التحصيل كالتالى:\nأقل من 5000000: 1.3%\n5000000:10000000: 1.2%\nأكبر من 10000000: 1.1%\nعمولة المحافظ الإلكترونية 1.8% + 2 جنيه.\nجميع هذه العمولات غير متضمنة ضريبة القيمة المضافة.\n4-2 يتم تحويل إجمالى المبالغ المحصلة أسبوعياً فى خلال اسبوع    أيام عمل من تاريخ استلامها.',
      'البند الرابع',
    ),
    clause(6, 'السرية', 'يلتزم الطرفان بالحفاظ على سرية المعلومات، وتسرى التزاماتهما بموجب هذا البند السابع.', 'البند السادس'),
    clause(7, 'مدة العقد', 'مدة العقد سنة، ويجوز إنهاؤه بخطاب مسجل بعلم الوصول قبل الانتهاء بشهر على الأقل.', 'البند السابع'),
    clause(8, 'المراقبة', '8-3 يتولى الطرف الأول مراقبة العمليات المشبوهة والإبلاغ عنها من خلال وسيلة منصوص عليها فى البند الفرعى 10-1.', 'البند الثامن'),
    clause(9, 'الاختصاص', '9-1 تختص المحاكم المختصة بجمهورية مصر العربية بنظر النزاع.', 'البند التاسع'),
    clause(10, 'أحكام عامة', '10-4 لا يجوز للعميل — فى أى وقت طوال مدة هذا العقد — التعاون أو العمل بأى شكل من الأشكال مع أى جهة قد تكون من المنافسين لمقدم الخدمة.', 'البند العاشر'),
  ];
  it('تُرصد كل ملاحظات المستشار الواحدة بدرجتها المقررة', () => {
    const f = officeRuleFindings(c0174, opts('خدمات'));
    const sev = (id: string) => f.find((x) => x.id === `office:${id}`)?.severity;
    expect(sev('exclusivity_binds_client')).toBe('متوسط');
    expect(sev('collected_funds_transfer_terms')).toBe('عالٍ');
    expect(sev('collected_funds_no_audit_right')).toBe('عالٍ');
    expect(sev('collected_funds_no_segregation')).toBe('متوسط');
    expect(sev('commission_tiers_ambiguous')).toBe('عالٍ');
    expect(sev('fixed_fee_plus_percent_unspecified')).toBe('عالٍ');
    expect(sev('no_liability_and_indemnity_terms')).toBe('عالٍ');
    expect(sev('customer_data_without_protection')).toBe('عالٍ');
    expect(sev('no_termination_for_breach')).toBe('عالٍ');
    expect(sev('court_not_specified')).toBe('متوسط');
    expect(sev('fees_exclusive_of_vat')).toBe('عالٍ');
    expect(sev('confidentiality_breach_consequence')).toBe('عالٍ'); // قاعدة قائمة من الدفعة 1 (ق15: تبقى عالية)
  });
  it('فحوص العدد والإحالة تُرصد: العدد الضائع متوسط، والإحالة الذاتية منخفضة', () => {
    const f = internalConsistencyFindings(c0174, { textMayBeIncomplete: true });
    expect(f.find((x) => x.id.startsWith('blank:'))?.severity).toBe('متوسط');
    expect(f.find((x) => x.id === 'ref:self:6')?.severity).toBe('منخفض');
  });
  it('الوثيقة نفسها بعد معالجتها: لا ضجيج على عقد سليم من هذه العيوب', () => {
    const clean: LevelClause[] = [
      clause(1, 'موضوع العقد', 'يلتزم مقدم الخدمة بتقديم خدمات التحصيل الإلكترونى لأقساط الوثائق من عملاء العميل.', 'البند الأول'),
      clause(2, 'التحويل', 'يحول مقدم الخدمة المبالغ المحصلة أسبوعياً كل يوم أحد، وعن كل يوم تأخير فى تحويل المبالغ تستحق غرامة تأخير.', 'البند الثانى'),
      clause(3, 'الحسابات', 'للعميل مراجعة سجلات التحصيل ومطابقتها شهرياً، وتعد المبالغ المحصلة أمانة فى حساب منفصل.', 'البند الثالث'),
      clause(4, 'حماية البيانات', 'يلتزم مقدم الخدمة بحماية البيانات الشخصية ومعالجتها لغرض العقد فقط.', 'البند الرابع'),
      clause(5, 'المسئولية', 'لا تتجاوز مسئولية مقدم الخدمة إجمالى العمولات عدا الغش والخطأ الجسيم، ويعوض كل طرف الآخر عن الضرر المباشر.', 'البند الخامس'),
      clause(6, 'الإنهاء', 'يحق للطرف المتضرر فسخ العقد عند إخلال الآخر إخلالاً جسيماً بعد إخطاره ومنحه مهلة ثلاثين يوماً.', 'البند السادس'),
      clause(7, 'الاختصاص', 'تختص محكمة القاهرة الاقتصادية بنظر النزاع.', 'البند السابع'),
    ];
    expect(officeRuleFindings(clean, opts('خدمات')).map((x) => x.id)).toEqual([]);
    expect(internalConsistencyFindings(clean, { textMayBeIncomplete: false })).toEqual([]);
  });
});

describe('الجولة 62.1: استنتاج النوع من المتن حين تسقط قراءة العنوان (عقد ممسوح رُفع بلا نوع)', () => {
  const collectionBody = [
    { clauseTitle: 'موضوع العقد', clauseText: 'يلتزم مقدم الخدمة بتقديم خدمات التحصيل الإلكترونى لأقساط الوثائق من عملاء الطرف الثانى.' },
    { clauseTitle: 'العمولات', clauseText: 'يحصل مقدم الخدمة على عمولة عن كل عملية تحصيل. وتحدد الخدمات المقدمة للعميل بالملحق.' },
    { clauseTitle: 'الخدمات', clauseText: 'تتضمن الخدمات التى سيوفرها مقدم الخدمة للعميل من خلال الشبكة قنوات التحصيل.' },
  ];
  const brokerageBody = [
    { clauseTitle: 'موضوع العقد', clauseText: 'يتولى الوسيط الوساطة فى إبرام وثائق التأمين لحساب الشركة مقابل عمولة.' },
    { clauseTitle: 'العمولة', clauseText: 'يستحق الوسيط عمولة عن الوساطة فى كل وثيقة. ويلتزم الوسيط بالتسويق لخدمات الشركة.' },
    { clauseTitle: 'الوكالة', clauseText: 'لا ينشئ هذا العقد وكالة، والوسيط ليس وكيلاً عن الشركة فى قبول المخاطر.' },
  ];
  const licenceBody = [
    { clauseTitle: 'الترخيص', clauseText: 'يرخص الطرف الأول للطرف الثانى باستغلال المساحة المحددة، ولا يمنح هذا الترخيص أى حق ملكية.' },
    { clauseTitle: 'مقابل الاستغلال', clauseText: 'يدفع المرخص له مقابل استغلال شهرى، وينتهى الترخيص بانتهاء مدته.' },
    { clauseTitle: 'الالتزامات', clauseText: 'يلتزم المرخص له بعدم التنازل عن الترخيص أو استغلال المساحة فى غير الغرض.' },
  ];
  it('عقد تحصيل ووساطة وترخيص بلا عنوان مقروء يُستنتج نوعها من المتن', () => {
    expect(resolveContractFamily({ contractType: null, titleText: '', clauses: collectionBody })).toEqual({ family: 'services', source: 'body' });
    expect(resolveContractFamily({ contractType: null, titleText: 'ش ط خ', clauses: brokerageBody })).toEqual({ family: 'agency', source: 'body' });
    expect(resolveContractFamily({ contractType: null, titleText: null, clauses: licenceBody })).toEqual({ family: 'licence', source: 'body' });
  });
  it('النوع المحدد وعنوان الديباجة يسبقان المتن', () => {
    expect(resolveContractFamily({ contractType: 'عقد إيجار', titleText: '', clauses: collectionBody })).toEqual({ family: 'lease', source: 'stated' });
    expect(resolveContractFamily({ contractType: null, titleText: 'عقد شراكة بين الطرفين', clauses: collectionBody })).toEqual({ family: 'partnership', source: 'title' });
  });
  it('لا فائز واضح أو متن قليل: unknown (فشل آمن)، ولا يُخمَّن من كلمة واحدة', () => {
    expect(inferContractFamilyFromBody([{ clauseTitle: 'x', clauseText: 'يلتزم الطرفان بما ورد فى هذا العقد.' }])).toBe('unknown');
    expect(resolveContractFamily({ contractType: null, titleText: '', clauses: [] })).toEqual({ family: 'unknown', source: 'none' });
    const mixed = [...licenceBody, ...brokerageBody];
    expect(inferContractFamilyFromBody(mixed)).toBe('unknown');
  });
  it('«صاحب العمل» بمعنى المالك فى المقاولة لا يجعل العقد عقد عمل', () => {
    const works = [{ clauseTitle: 'المقابل', clauseText: 'يسدد صاحب العمل للمقاول كل مستخلص خلال 90 يوماً. ويحتجز صاحب العمل 10 % من كل مستخلص. وينفذ المقاول أعمال التشطيب.' }];
    expect(resolveContractFamily({ contractType: null, titleText: '', clauses: works }).family).not.toBe('employment');
  });
  it('اسم الملف قرينة أخيرة لا تُقبل إلا بتأييد المتن', () => {
    const weak = [{ clauseTitle: 'x', clauseText: 'يتولى الوسيط الوساطة لحساب الشركة مقابل عمولة.' }];
    expect(resolveContractFamily({ contractType: null, titleText: '', clauses: weak, fileName: 'عقد وساطة.pdf' })).toEqual({ family: 'agency', source: 'filename' });
    expect(resolveContractFamily({ contractType: null, titleText: '', clauses: weak, fileName: 'عقد إيجار.pdf' })).toEqual({ family: 'unknown', source: 'none' });
    expect(resolveContractFamily({ contractType: null, titleText: '', clauses: weak, fileName: 'contract-683fbaad-draft.pdf' })).toEqual({ family: 'unknown', source: 'none' });
  });
  it('قواعد المكتب تعمل الآن على عقد ممسوح بلا نوع ولا عنوان مقروء (كانت تتعطل بصمت)', () => {
    const cs: LevelClause[] = collectionBody.map((c, i) => clause(i + 1, c.clauseTitle, c.clauseText));
    cs.push(clause(4, 'العمولات', 'جميع هذه العمولات غير متضمنة ضريبة القيمة المضافة.'));
    const f = officeRuleFindings(cs, { contractType: null, titleText: '', textMayBeIncomplete: true });
    expect(f.map((x) => x.id)).toContain('office:fees_exclusive_of_vat');
    // وعند الغياب على ممسوح: مرشح غير مؤكد
    expect(f.find((x) => x.id === 'office:no_liability_and_indemnity_terms')?.verification?.status).toBe('unconfirmed');
  });
});
