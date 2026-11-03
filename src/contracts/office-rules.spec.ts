import { findingAction } from '../exports/audit-report/recommendations';
import { quoteInText } from './clause-facts';
import type { LevelClause } from './contract-level';
import { DEFAULT_OFFICE_PROFILE, officeRuleFindings, type OfficeProfile } from './office-rules';

// عقود اصطناعية بالكامل (لا نصوص عقود حقيقية فى المستودع): تحاكى الصياغات التى بُنيت عليها القواعد.
const clause = (i: number, title: string, text: string): LevelClause => ({
  clauseIndex: i,
  clauseLabel: `البند ${i}`,
  clauseTitle: title,
  clauseText: text,
});

const opts = (contractType: string | null) => ({ contractType, textMayBeIncomplete: false });
const ids = (cs: LevelClause[], type: string | null) => officeRuleFindings(cs, opts(type)).map((f) => f.id);

describe('قواعد المكتب — المدة بلا تجديد تلقائى', () => {
  const autoRenew = clause(
    1,
    'مدة العقد',
    'مدة هذا العقد سنة ميلادية واحدة. واتفق الطرفان على أن يجدد هذا العقد تلقائياً لمدد مماثلة ما لم يخطر أى من الطرفين الآخر برغبته فى عدم التجديد قبل انتهائه بثلاثين يوماً.',
  );

  it('تُرصد صيغة التجديد التلقائى حتى مع عبارة «عدم التجديد» الخاصة بالإخطار', () => {
    expect(ids([autoRenew], 'خدمات')).toContain('office:term_no_auto_renewal');
  });

  it('لا تُرصد حين ينص العقد صراحةً على عدم التجديد التلقائى', () => {
    const c = clause(1, 'المدة', 'مدة العقد سنة تنتهى بانتهائها، ولا يجدد هذا العقد تلقائياً، وأى تجديد يكون بعقد جديد.');
    expect(ids([c], 'خدمات')).not.toContain('office:term_no_auto_renewal');
  });

  it('لا تُرصد حين لا ذكر للتجديد', () => {
    const c = clause(1, 'المدة', 'مدة هذا العقد سنة ميلادية تبدأ فى أول يناير وتنتهى فى آخر ديسمبر.');
    expect(ids([c], 'خدمات')).toEqual([]);
  });

  it('لا تنطبق على عقد إيجار (نظامه القانونى الخاص)', () => {
    expect(ids([autoRenew], 'إيجار')).not.toContain('office:term_no_auto_renewal');
  });

  it('تنطبق على اتفاقية سرية', () => {
    expect(ids([autoRenew], 'اتفاقية عدم إفصاح')).toContain('office:term_no_auto_renewal');
  });
});

describe('قواعد المكتب — أثر الإخلال بالسرية', () => {
  const conf = clause(2, 'السرية', 'يتعهد مقدم الخدمة بالحفاظ على سرية أى معلومات يتلقاها من العميل وعدم إفشائها لأى طرف ثالث إلا بموافقة خطية مسبقة.');
  const genericIndemnity = clause(3, 'التعويض', 'يلتزم كل طرف بتعويض الطرف الآخر عن أى أضرار تنشأ بسبب إخلاله ببنود العقد.');

  it('تُرصد السرية بلا أثر منصوص عند الإخلال، والتعويض العام لا يكفى', () => {
    const f = officeRuleFindings([conf, genericIndemnity], opts('خدمات')).find((x) => x.id === 'office:confidentiality_breach_consequence');
    expect(f).toBeDefined();
    expect(f!.evidence.map((e) => e.clauseIndex)).toEqual([2]);
  });

  it('لا تُرصد إن ربط بند السرية الإخلال بالفسخ أو التعويض', () => {
    const c = clause(2, 'السرية', 'يلتزم مقدم الخدمة بسرية المعلومات. وفى حالة إخلاله بسرية المعلومات يكون العقد مفسوخاً من تلقاء نفسه ويحق للعميل المطالبة بالتعويض.');
    expect(ids([c], 'خدمات')).not.toContain('office:confidentiality_breach_consequence');
  });

  it('لا تُرصد إن وُجد فى العقد حق إنهاء عند الإخلال بأى بند', () => {
    const term = clause(4, 'الإنهاء', 'يحق للعميل إنهاء العقد فوراً بإخطار كتابى فى حالة إخلال مقدم الخدمة بأى بند من بنوده.');
    expect(ids([conf, term], 'خدمات')).not.toContain('office:confidentiality_breach_consequence');
  });

  it('لا تُرصد إن لم يكن فى العقد التزام بالسرية أصلاً (يتولاه فحص البنود الناقصة)', () => {
    const c = clause(1, 'المقابل', 'يسدد العميل المقابل الشهرى فى أول كل شهر.');
    expect(ids([c], 'خدمات')).toEqual([]);
  });

  it('تجمع المواضع المتعددة فى ملاحظة واحدة بأدلتها', () => {
    const a = clause(5, 'مسؤوليات', 'يجب على مقدم الخدمة الحفاظ على السرية التامة وخصوصية البيانات.');
    const f = officeRuleFindings([a, conf], opts('خدمات')).filter((x) => x.id === 'office:confidentiality_breach_consequence');
    expect(f).toHaveLength(1);
    expect(f[0].evidence.map((e) => e.clauseIndex).sort()).toEqual([2, 5]);
  });
});

describe('قواعد المكتب — الإخطار ومهلة التصحيح', () => {
  it('يُرصد الفسخ التلقائى دون إخطار ومهلة', () => {
    const c = clause(14, 'الإخلال', 'فى حالة الإخلال بأى بند يعتبر هذا العقد مفسوخاً من تلقاء نفسه دون الحاجة إلى حكم قضائى.');
    expect(ids([c], 'إيجار')).toContain('office:breach_notice_and_cure');
  });

  it('يُرصد التعويض عن الإخلال دون إخطار ومهلة', () => {
    const c = clause(9, 'التعويض', 'يلتزم كل طرف بتعويض الطرف الآخر عن أى خسائر أو أضرار تنشأ بسبب إخلاله بأى من بنود هذا العقد.');
    expect(ids([c], 'خدمات')).toContain('office:breach_notice_and_cure');
  });

  it('لا يُرصد إن اشتُرط إخطار مسجل ومهلة للرد فى البند نفسه', () => {
    const c = clause(
      14,
      'الإخلال',
      'فى حالة الإخلال بأى بند يلتزم الطرف الآخر بإخطار المخالف بخطاب مسجل بعلم الوصول، فإن لم يصحح المخالف خلال 30 يوماً يعتبر العقد مفسوخاً من تلقاء نفسه.',
    );
    expect(ids([c], 'إيجار')).not.toContain('office:breach_notice_and_cure');
  });

  it('لا تنطبق على عقد العمل ولا على النوع غير المحدد', () => {
    const c = clause(14, 'الإخلال', 'يعتبر العقد مفسوخاً من تلقاء نفسه عند الإخلال بأى بند دون حاجة إلى حكم.');
    expect(ids([c], 'عقد عمل')).toEqual([]);
    expect(ids([c], null)).toEqual([]);
  });

  it('لا يُرصد بند لا فسخ فيه ولا تعويض عن إخلال', () => {
    const c = clause(3, 'السداد', 'يسدد العميل المقابل خلال ثلاثين يوماً من استلام الفاتورة، ولا يحق لمقدم الخدمة وقف الخدمة بسبب نزاع على فاتورة.');
    expect(ids([c], 'خدمات')).toEqual([]);
  });
});

describe('قواعد المكتب — الاختصاص للمحاكم الاقتصادية (معطلة افتراضياً)', () => {
  const arb = clause(16, 'المنازعات', 'يُحال أى نزاع ينشأ عن هذا العقد إلى التحكيم وفقاً لقانون التحكيم، ومكان التحكيم القاهرة.');

  it('لا تعمل فى الملف الافتراضى', () => {
    expect(ids([arb], 'خدمات')).not.toContain('office:economic_courts_forum');
  });

  it('تعمل إذا فُعّلت فى ملف المكتب، ولا تعمل إن ورد ذكر المحاكم الاقتصادية', () => {
    const profile: OfficeProfile = {
      ...DEFAULT_OFFICE_PROFILE,
      rules: DEFAULT_OFFICE_PROFILE.rules.map((r) => (r.id === 'economic_courts_forum' ? { ...r, enabled: true } : r)),
    };
    expect(officeRuleFindings([arb], opts('خدمات'), profile).map((f) => f.id)).toContain('office:economic_courts_forum');
    const econ = clause(17, 'الاختصاص', 'ينعقد الاختصاص بنظر أى نزاع للمحاكم الاقتصادية.');
    expect(officeRuleFindings([arb, econ], opts('خدمات'), profile).map((f) => f.id)).not.toContain('office:economic_courts_forum');
  });
});

describe('قواعد المكتب — الضمانات العامة', () => {
  const c = clause(1, 'المدة', 'يجدد هذا العقد تلقائياً لمدد مماثلة ما لم يخطر أى طرف برغبته فى عدم التجديد.');

  it('كل دليل اقتباس حرفى موجود فى البند، والنوع والمصدر صحيحان', () => {
    const [f] = officeRuleFindings([c], opts('خدمات'));
    expect(f.kind).toBe('office_rule');
    expect(f.source).toBe('rule');
    expect(f.severity).toBe('عالٍ');
    for (const e of f.evidence) expect(quoteInText(e.quote, c.clauseText)).toBe(true);
  });

  it('الشرح يعلن أنها ممارسة مكتب لا نص قانونى، ولا يكشف بيانات التطوير الداخلية للعميل', () => {
    const [f] = officeRuleFindings([c], opts('خدمات'));
    expect(f.explanation).toContain('قاعدة المكتب');
    expect(f.explanation).toContain('ممارسة تعاقدية للمكتب وليست نصاً قانونياً');
    expect(f.explanation).not.toMatch(/الدفعة|المجموعة الذهبية|عينة|محامى المكتب على|مصدر القاعدة/);
  });

  it('تنبيه القراءة الآلية يُضاف للشرح عند وجود تحذيرات ترقيم', () => {
    const [f] = officeRuleFindings([c], { contractType: 'خدمات', textMayBeIncomplete: true });
    expect(f.explanation).toContain('تحذيرات قراءة');
  });

  it('لا تحمل القواعد رقم مادة قانونية (لا مادة بلا تحقق من نصها المفهرس)', () => {
    for (const r of DEFAULT_OFFICE_PROFILE.rules) {
      expect(`${r.title} ${r.explanation} ${r.suggestion} ${r.provenance}`).not.toMatch(/المادة\s*\d|المواد\s*\d/);
    }
  });

  it('عقد بلا بنود أو نوع غير مدعوم لا يرمى استثناء', () => {
    expect(officeRuleFindings([], opts('خدمات'))).toEqual([]);
    expect(() => officeRuleFindings([clause(1, '', '؟؟؟')], opts('خدمات'))).not.toThrow();
  });

  it('ملف مخصص بقاعدة واحدة لا يشغّل غيرها (أساس Playbook لكل مكتب)', () => {
    const only: OfficeProfile = { ...DEFAULT_OFFICE_PROFILE, rules: DEFAULT_OFFICE_PROFILE.rules.filter((r) => r.id === 'term_no_auto_renewal') };
    const conf = clause(2, 'السرية', 'يلتزم مقدم الخدمة بالحفاظ على سرية المعلومات.');
    expect(officeRuleFindings([c, conf], opts('خدمات'), only).map((f) => f.id)).toEqual(['office:term_no_auto_renewal']);
  });

  it('يتحول إلى إجراء توصية بعبارة «قاعدة المكتب» بأولوية عالية', () => {
    const [f] = officeRuleFindings([c], opts('خدمات'));
    const a = findingAction({ kind: f.kind, severity: f.severity, title: f.title, suggestion: f.suggestion });
    expect(a.text).toContain('قاعدة المكتب');
    expect(a.priority).toBe('عالية');
  });
});

describe('قواعد المكتب — الصياغات العامة (عدم التنازل وتحديد المسئولية)', () => {
  const nonWaiver = clause(14, 'التنازل عن الحقوق', 'لا يعتبر تنازل أى من الطرفين عن حق من حقوقه بموجب هذا العقد فى أى مناسبة بمثابة تنازل عن هذا الحق فى مناسبات لاحقة.');
  const cap = clause(
    11,
    'تحديد المسئولية',
    'لن يكون مقدم الخدمة مسئولا عن الأضرار غير المباشرة أو العرضية أو التبعية، بما فى ذلك خسارة الأرباح. يجب ألا تتجاوز المسئولية الإجمالية لمقدم الخدمة المبلغ الذى دفعه العميل بموجب هذه الاتفاقية.',
  );

  it('عدم التنازل بصيغة عامة: يُرصد مع توصية الحذف وإعادة الصياغة', () => {
    const f = officeRuleFindings([nonWaiver], opts('خدمات')).find((x) => x.id === 'office:generic_non_waiver');
    expect(f).toBeDefined();
    expect(f!.title).toContain('حذفه وإعادة صياغته');
    expect(f!.evidence.map((e) => e.clauseIndex)).toEqual([14]);
  });

  it('لا يُرصد بند عدم التنازل إن اشترط الكتابة والتوقيع', () => {
    const c = clause(14, 'التنازل', 'لا يعتبر تنازل أى طرف عن حق بمثابة تنازل عن غيره، ولا يصح أى تنازل إلا إذا كان صريحاً ومكتوباً وموقعاً من الطرف المتنازل.');
    expect(ids([c], 'خدمات')).not.toContain('office:generic_non_waiver');
  });

  it('لا يُرصد بند عدم التنازل فى عقد العمل ولا النوع غير المحدد', () => {
    expect(ids([nonWaiver], 'عقد عمل')).not.toContain('office:generic_non_waiver');
    expect(ids([nonWaiver], null)).not.toContain('office:generic_non_waiver');
  });

  it('تحديد المسئولية بصيغة عامة: يُرصد', () => {
    expect(ids([cap], 'خدمات')).toContain('office:generic_liability_limit');
  });

  it('لا يُرصد إن استثنى البند الغش والخطأ الجسيم', () => {
    const c = clause(11, 'تحديد المسئولية', `${cap.clauseText} ولا يسرى هذا السقف فى حالة الغش أو الخطأ الجسيم.`);
    expect(ids([c], 'خدمات')).not.toContain('office:generic_liability_limit');
  });

  it('لا يُرصد ذكر عابر لخسارة الأرباح فى بند لا يتناول المسئولية', () => {
    const c = clause(6, 'المقابل', 'يسدد العميل المقابل الشهرى، ولا تُحتسب فيه أى مبالغ عن خسارة الأرباح المتوقعة للعميل.');
    expect(ids([c], 'خدمات')).not.toContain('office:generic_liability_limit');
  });

  it('لا ينطبق سقف المسئولية على البيع (خارج أنواع القاعدة)', () => {
    expect(ids([cap], 'بيع')).not.toContain('office:generic_liability_limit');
  });

  it('مصدر القاعدتين معلن بأنه بند واحد فى عقد واحد', () => {
    for (const id of ['generic_non_waiver', 'generic_liability_limit']) {
      const r = DEFAULT_OFFICE_PROFILE.rules.find((x) => x.id === id)!;
      expect(r.provenance).toContain('بند واحد فى عقد واحد');
    }
  });
});
