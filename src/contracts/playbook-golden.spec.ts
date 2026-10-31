import { readFileSync } from 'fs';
import { join } from 'path';
import type { LevelClause } from './contract-level';
import { buildPlaybook, type PlaybookStatus } from './playbook';
import { PLAYBOOK_TOPICS } from './playbook-data';
import { norm } from './playbook-util';
import { SegmentationService } from './segmentation.service';

/**
 * مجموعة قياس ذهبية للدليل التفاوضى (الجولة 7): لكل نوع عقد نص مُصطنَع بالكامل (أطراف ومبالغ وهمية) فيه بنود معيبة عمداً لكل طرف،
 * وتُقرأ بصفتى الطرفين. كل تغيير لاحق فى الأنماط يكسر هذه النتائج هنا قبل أن يصل لعميل.
 * القيم المتوقعة روجعت يدوياً بند ببند مقابل نص الفكسترات.
 */
const dir = join(__dirname, '__fixtures__', 'golden');

function clausesOf(file: string): LevelClause[] {
  const seg = new SegmentationService().segment(readFileSync(join(dir, file), 'utf-8'));
  return seg.clauses.map((c, i) => ({ clauseIndex: i + 1, clauseLabel: c.label, clauseTitle: c.title, clauseText: c.text }));
}

type Expected = Record<string, [PlaybookStatus, ...string[]]>;

interface Case {
  name: string;
  file: string;
  type: string;
  role: string | null;
  clauseCount: number;
  expected: Expected;
}

const SERVICES = 'عقد خدمات أو مقاولة أو توريد';
const PROVIDER = 'مقدم الخدمة (المقاول / المورد)';
const CUSTOMER = 'طالب الخدمة (صاحب العمل / العميل)';

const CASES: Case[] = [
  {
    name: 'إيجار — المستأجر',
    file: 'synthetic-lease.txt',
    type: 'عقد إيجار',
    role: 'المستأجر',
    clauseCount: 8,
    expected: {
      lease_rent: ['concern', 'rent_unilateral'],
      lease_term: ['found'],
      lease_deposit: ['concern', 'deposit_no_return'],
      lease_use: ['concern', 'sublet_banned'],
      lease_maintenance: ['concern', 'tenant_all_repairs'],
      lease_handover: ['concern', 'waive_defects'],
      lease_termination: ['concern', 'auto_rescission', 'short_cure'],
    },
  },
  {
    name: 'إيجار — المؤجر',
    file: 'synthetic-lease.txt',
    type: 'عقد إيجار',
    role: 'المؤجر (المالك)',
    clauseCount: 8,
    expected: {
      lease_rent: ['found'],
      lease_term: ['concern', 'auto_renew'],
      lease_deposit: ['found'],
      lease_use: ['found'],
      lease_maintenance: ['found'],
      lease_handover: ['found'],
      lease_termination: ['concern', 'auto_rescission'],
    },
  },
  {
    name: 'بيع — المشترى',
    file: 'synthetic-sale.txt',
    type: 'عقد بيع',
    role: 'المشترى',
    clauseCount: 7,
    expected: {
      common_disputes: ['missing'],
      sale_price: ['concern', 'full_prepay', 'nonrefundable'],
      sale_delivery: ['concern', 'soft_dates'],
      sale_warranty: ['concern', 'sold_as_is', 'short_notice'],
      sale_title: ['concern', 'no_title_warranty'],
      sale_inspection: ['concern', 'deemed_acceptance'],
      sale_default: ['concern', 'auto_rescission', 'penalty_no_cap'],
      sale_costs: ['concern', 'prior_taxes_on_buyer'],
    },
  },
  {
    name: 'بيع — البائع',
    file: 'synthetic-sale.txt',
    type: 'عقد بيع',
    role: 'البائع',
    clauseCount: 7,
    expected: {
      common_disputes: ['missing'],
      sale_price: ['found'],
      sale_delivery: ['found'],
      sale_warranty: ['found'],
      sale_title: ['found'],
      sale_inspection: ['found'],
      sale_default: ['concern', 'auto_rescission', 'penalty_no_cap'],
      sale_costs: ['found'],
    },
  },
  {
    name: 'مقاولة — المقاول',
    file: 'synthetic-works.txt',
    type: SERVICES,
    role: PROVIDER,
    clauseCount: 7,
    expected: {
      common_disputes: ['missing'],
      svc_scope: ['concern', 'free_changes'],
      svc_payment: ['concern', 'slow_pay', 'retention'],
      svc_acceptance: ['found'],
      svc_liability: ['concern', 'unlimited'],
      svc_delay: ['concern', 'no_cap', 'heavy_rate'],
      svc_termination: ['concern', 'convenience_no_comp'],
      svc_ip: ['missing'],
      svc_confidentiality: ['missing'],
      svc_data_protection: ['missing'],
      svc_warranty: ['found'],
    },
  },
  {
    name: 'مقاولة — صاحب العمل',
    file: 'synthetic-works.txt',
    type: SERVICES,
    role: CUSTOMER,
    clauseCount: 7,
    expected: {
      common_disputes: ['missing'],
      svc_scope: ['found'],
      svc_payment: ['found'],
      svc_acceptance: ['concern', 'deemed_accept'],
      svc_liability: ['found'],
      svc_delay: ['found'],
      svc_termination: ['found'],
      svc_ip: ['missing'],
      svc_confidentiality: ['missing'],
      svc_data_protection: ['missing'],
      svc_warranty: ['concern', 'no_warranty'],
    },
  },
  {
    name: 'توريد برمجيات — العميل',
    file: 'synthetic-software-supply.txt',
    type: SERVICES,
    role: CUSTOMER,
    clauseCount: 15,
    expected: {
      common_disputes: ['found'],
      svc_scope: ['found'],
      svc_payment: ['found'],
      svc_acceptance: ['found'],
      svc_liability: ['found'],
      svc_delay: ['missing'],
      svc_termination: ['concern', 'auto_rescission'],
      svc_ip: ['concern', 'limited_licence', 'licence_term_bound'],
      svc_confidentiality: ['found'],
      svc_data_protection: ['found'],
      svc_warranty: ['found'],
    },
  },
  {
    name: 'توريد برمجيات — المورد',
    file: 'synthetic-software-supply.txt',
    type: SERVICES,
    role: PROVIDER,
    clauseCount: 15,
    expected: {
      common_disputes: ['found'],
      svc_scope: ['found'],
      svc_payment: ['found'],
      svc_acceptance: ['found'],
      svc_liability: ['found'],
      svc_delay: ['missing'],
      svc_termination: ['concern', 'auto_rescission'],
      svc_ip: ['found'],
      svc_confidentiality: ['found'],
      svc_data_protection: ['found'],
      svc_warranty: ['found'],
    },
  },
  {
    name: 'عمل — العامل',
    file: 'synthetic-employment.txt',
    type: 'عقد عمل',
    role: 'العامل',
    clauseCount: 7,
    expected: {
      emp_form: ['found'],
      emp_probation: ['concern', 'long_probation'],
      emp_wage: ['concern', 'inclusive_wage', 'unilateral_wage_change'],
      emp_hours: ['concern', 'excess_hours', 'leave_waiver'],
      emp_termination: ['concern', 'at_will'],
      emp_noncompete: ['concern', 'broad_noncompete'],
      emp_insurance: ['concern', 'employee_bears'],
    },
  },
  {
    name: 'عمل — صاحب العمل',
    file: 'synthetic-employment.txt',
    type: 'عقد عمل',
    role: 'صاحب العمل',
    clauseCount: 7,
    expected: {
      emp_form: ['found'],
      emp_probation: ['found'],
      emp_wage: ['found'],
      emp_hours: ['found'],
      emp_termination: ['found'],
      emp_noncompete: ['found'],
      emp_insurance: ['found'],
    },
  },
  {
    name: 'شراكة — المستثمر',
    file: 'synthetic-partnership.txt',
    type: 'عقد شراكة أو استثمار',
    role: 'الشريك المستثمر',
    clauseCount: 8,
    expected: {
      common_disputes: ['missing'],
      prt_form: ['concern', 'verbal_amendments'],
      prt_contribution: ['concern', 'lump_sum_upfront', 'inkind_self_valued'],
      prt_profit: ['concern', 'loss_exempt', 'profit_discretion'],
      prt_management: ['concern', 'manager_sole_authority'],
      prt_info: ['concern', 'no_inspection'],
      prt_noncompete: ['concern', 'broad_noncompete'],
      prt_liability: ['concern', 'joint_liability', 'personal_guarantee'],
      prt_exit: ['concern', 'exit_barred', 'waive_dissolution', 'exit_valuation_discretion'],
    },
  },
  {
    name: 'شراكة — المدير',
    file: 'synthetic-partnership.txt',
    type: 'عقد شراكة أو استثمار',
    role: 'الشريك المدير أو صاحب المشروع',
    clauseCount: 8,
    expected: {
      common_disputes: ['missing'],
      prt_form: ['concern', 'verbal_amendments'],
      prt_contribution: ['found'],
      prt_profit: ['concern', 'loss_exempt'],
      prt_management: ['found'],
      prt_info: ['found'],
      prt_noncompete: ['concern', 'broad_noncompete'],
      prt_liability: ['concern', 'joint_liability'],
      prt_exit: ['concern', 'waive_dissolution'],
    },
  },
  {
    name: 'تمويل — الممول',
    file: 'synthetic-finance.txt',
    type: 'عقد تمويل أو قرض',
    role: 'الممول (الدائن)',
    clauseCount: 7,
    expected: {
      common_disputes: ['found'],
      fin_principal: ['found'],
      fin_interest: ['found'],
      fin_repayment: ['found'],
      fin_default: ['found'],
      fin_security: ['found'],
      fin_prepayment: ['found'],
    },
  },
  {
    name: 'تمويل — المقترض',
    file: 'synthetic-finance.txt',
    type: 'عقد تمويل أو قرض',
    role: 'المقترض (المدين)',
    clauseCount: 7,
    expected: {
      common_disputes: ['found'],
      fin_principal: ['concern', 'fees_netted'],
      fin_interest: ['concern', 'rate_above_cap', 'hidden_fee', 'compound_interest', 'rate_unilateral'],
      fin_repayment: ['concern', 'heavy_late_charge'],
      fin_default: ['concern', 'acceleration_no_notice', 'cross_default_broad'],
      fin_security: ['concern', 'blank_instrument', 'open_guarantee', 'guarantor_joint'],
      fin_prepayment: ['concern', 'prepay_penalty', 'no_prepay'],
    },
  },
  {
    name: 'وكالة — الموكل',
    file: 'synthetic-agency.txt',
    type: 'عقد وكالة أو سمسرة أو تسويق',
    role: 'الموكِّل (صاحب المنتج أو الخدمة)',
    clauseCount: 6,
    expected: {
      common_disputes: ['missing'],
      agy_authority: ['concern', 'broad_authority', 'sub_agent_free'],
      agy_commission: ['concern', 'commission_post_termination'],
      agy_exclusivity: ['concern', 'exclusive_no_target'],
      agy_accounting: ['concern', 'slow_remittance'],
      agy_termination: ['concern', 'principal_exit_barred', 'heavy_termination_comp'],
      agy_liability: ['found'],
    },
  },
  {
    name: 'وكالة — الوكيل',
    file: 'synthetic-agency.txt',
    type: 'عقد وكالة أو سمسرة أو تسويق',
    role: 'الوكيل أو السمسار',
    clauseCount: 6,
    expected: {
      common_disputes: ['missing'],
      agy_authority: ['found'],
      agy_commission: ['concern', 'commission_setoff', 'commission_on_collection'],
      agy_exclusivity: ['concern', 'principal_may_compete'],
      agy_accounting: ['found'],
      agy_termination: ['concern', 'agent_exit_barred'],
      agy_liability: ['concern', 'agent_guarantees_customers'],
    },
  },
  {
    name: 'ترخيص — المانح',
    file: 'synthetic-licence.txt',
    type: 'عقد ترخيص أو امتياز تجارى',
    role: 'مانح الترخيص',
    clauseCount: 7,
    expected: {
      common_disputes: ['missing'],
      lic_scope: ['concern', 'exclusive_no_minimum', 'scope_unlimited'],
      lic_fees: ['found'],
      lic_term: ['found'],
      lic_quality: ['found'],
      lic_ip: ['found'],
      lic_transfer: ['found'],
      lic_warranty: ['found'],
    },
  },
  {
    name: 'ترخيص — المرخص له',
    file: 'synthetic-licence.txt',
    type: 'عقد ترخيص أو امتياز تجارى',
    role: 'المرخَّص له',
    clauseCount: 7,
    expected: {
      common_disputes: ['missing'],
      lic_scope: ['found'],
      lic_fees: ['concern', 'minimum_royalty', 'upfront_nonrefundable', 'royalty_gross_base'],
      lic_term: ['concern', 'licensor_terminate_anytime', 'licensee_exit_balance'],
      lic_quality: ['concern', 'unilateral_standards'],
      lic_ip: ['concern', 'improvements_to_licensor', 'no_infringement_defence'],
      lic_transfer: ['concern', 'no_assignment'],
      lic_warranty: ['concern', 'licensor_no_warranty', 'licensee_unlimited_indemnity'],
    },
  },
];

describe('golden set — الدليل التفاوضى لكل نوع عقد', () => {
  it.each(CASES)('$name', ({ file, type, role, clauseCount, expected }) => {
    const clauses = clausesOf(file);
    expect(clauses).toHaveLength(clauseCount);
    const pb = buildPlaybook({ contractType: type, clientRole: role, clauses })!;
    const actual: Expected = {};
    for (const r of pb.rows) actual[r.topicId] = [r.status, ...r.concerns.map((c) => c.flagId)];
    expect(actual).toEqual(expected);
  });

  it('كل اقتباس (دليل أو ملاحظة) نص متصل من البند المنسوب إليه، بحد أقصى 300 حرف', () => {
    for (const c of CASES) {
      const clauses = clausesOf(c.file);
      const byLabel = new Map(clauses.map((x) => [x.clauseLabel, norm(x.clauseText)]));
      const pb = buildPlaybook({ contractType: c.type, clientRole: c.role, clauses })!;
      for (const r of pb.rows) {
        const quotes = [...(r.evidence ? [r.evidence] : []), ...r.concerns];
        for (const q of quotes) {
          expect(q.quote.length).toBeLessThanOrEqual(300);
          expect(byLabel.get(q.clauseLabel)).toContain(norm(q.quote));
        }
      }
    }
  });

  it('عند حذف بند من العقد يتحول محوره إلى «لم يُرصد» ويظهر أثر الغياب', () => {
    const clauses = clausesOf('synthetic-lease.txt').filter((c) => !/^التأمين/.test(c.clauseText));
    expect(clauses).toHaveLength(7);
    const pb = buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clauses })!;
    const dep = pb.rows.find((r) => r.topicId === 'lease_deposit')!;
    expect(dep.status).toBe('missing');
    expect(dep.evidence).toBeNull();
    expect(pb.counts).toEqual({ found: 1, concern: 5, missing: 1 });
  });

  it('صفة غير محددة: نفس المحاور ونفس الرصد، وتظهر ملاحظات الطرفين معاً', () => {
    const clauses = clausesOf('synthetic-lease.txt');
    const pb = buildPlaybook({ contractType: 'عقد إيجار', clientRole: null, clauses })!;
    expect(pb.rows.map((r) => r.topicId)).toEqual(PLAYBOOK_TOPICS.filter((t) => t.families.includes('lease')).map((t) => t.id));
    const flags = pb.rows.flatMap((r) => r.concerns.map((c) => c.flagId));
    expect(flags).toEqual(expect.arrayContaining(['rent_unilateral', 'auto_renew', 'sublet_banned', 'auto_rescission']));
    expect(pb.rows.every((r) => r.stance === null && r.bothStances?.length === 2)).toBe(true);
  });

  it('أنواع العقود غير المدعومة لا تُنتج دليلاً (لا تخمين)', () => {
    const clauses = clausesOf('synthetic-lease.txt');
    expect(buildPlaybook({ contractType: 'عقد رهن', clientRole: 'الراهن', clauses })).toBeNull();
  });
});

/**
 * الدقة (عدم الإنذار الكاذب): نصوص متوازنة محكمة الصياغة لا ينبغى أن يرصد فيها دليل أى ميل ضد أى من الطرفين،
 * وبها عمداً كلمات قد توقع فى إنذار كاذب (ضمان، تنازل، كما هو مبين، فسخ، غرامة بسقف...).
 */
const BALANCED: Array<{ name: string; type: string; roles: string[]; texts: string[] }> = [
  {
    name: 'إيجار متوازن',
    type: 'عقد إيجار',
    roles: ['المؤجر (المالك)', 'المستأجر'],
    texts: [
      'المدة: مدة العقد سنتان تبدأ من 1/1/2027. وتجدد بالاتفاق الكتابى بين الطرفين قبل انتهائها بشهرين ما لم يخطر أحدهما الآخر بعدم رغبته.',
      'الأجرة: القيمة الإيجارية الشهرية 15000 جنيه تسدد فى أول كل شهر. وتزداد الأجرة سنوياً بنسبة 10 % لا تتجاوز هذه النسبة بأى حال.',
      'التأمين: يدفع المستأجر مبلغ تأمين قدره 30000 جنيه يرد كاملاً خلال 15 يوماً من تسليم العين بعد خصم ما يثبت بمحضر الإخلاء من تلفيات.',
      'الغرض: يستعمل المستأجر العين مكتباً إدارياً. ويجوز له التأجير من الباطن بموافقة المؤجر الكتابية التى لا تحجب بغير مبرر.',
      'الصيانة: يتحمل المؤجر الإصلاحات الإنشائية والضرورية، ويتحمل المستأجر الصيانة الدورية والترميمات التأجيرية.',
      'التسليم: تسلم المستأجر العين بموجب محضر تسليم موقع من الطرفين يبين حالتها، ويردها فى نهاية المدة بالحالة التى تسلمها بها عدا الاستهلاك العادى.',
      'الفسخ: إذا أخل أحد الطرفين بالتزام جوهرى جاز للآخر إنذاره بتصحيح الإخلال خلال 30 يوماً، فإن لم يصحح جاز طلب الفسخ والتعويض.',
    ],
  },
  {
    name: 'بيع متوازن',
    type: 'عقد بيع',
    roles: ['البائع', 'المشترى'],
    texts: [
      'الثمن: ثمن المبيع 300000 جنيه يسدد على دفعتين: 50 % عند التوقيع، و50 % عند التسليم بعد فحص المبيع.',
      'التسليم: يسلم البائع المبيع فى 1/3/2027 فى مقر المشترى، وتنتقل تبعة الهلاك إلى المشترى من وقت التسليم الفعلى.',
      'الضمان: يضمن البائع المبيع ضد عيوب الصنع لمدة سنتين من التسليم، ويخطر المشترى بالعيب خلال 30 يوماً من اكتشافه.',
      'الملكية: يقر البائع بأن المبيع ملكه وخال من أى رهن أو حجز، ويضمن عدم التعرض للمشترى.',
      'الفحص: للمشترى فحص المبيع خلال 14 يوماً من الاستلام ويخطر البائع كتابة بملاحظاته.',
      'الإخلال: إذا تأخر أحد الطرفين فى تنفيذ التزامه جاز للآخر إعذاره، وتفرض غرامة تأخير 1 % عن كل أسبوع بحد أقصى 10 % من الثمن.',
      'المصروفات: يتحمل المشترى مصروفات التسجيل والدمغة، ويتحمل البائع الضرائب المستحقة على المبيع قبل البيع.',
    ],
  },
  {
    name: 'خدمات متوازنة',
    type: 'عقد خدمات أو مقاولة أو توريد',
    roles: ['مقدم الخدمة (المقاول / المورد)', 'طالب الخدمة (صاحب العمل / العميل)'],
    texts: [
      'نطاق العمل: ينفذ المقاول الأعمال كما هو مبين بملحق المواصفات المرفق. وأى تعديل يطلب كتابةً يتضمن أثره على السعر والجدول قبل التنفيذ.',
      'المقابل: إجمالى الأجر 1000000 جنيه يسدد على دفعات مرتبطة بالمراحل، وتسدد كل فاتورة خلال 30 يوماً من تقديمها.',
      'القبول: يفحص العميل المخرجات خلال 10 أيام وفق معايير القبول المرفقة، ويخطر المقاول كتابةً بملاحظاته المسببة.',
      'المسئولية: لا تتجاوز مسئولية كل طرف عن الأضرار غير المباشرة قيمة العقد، ولا يسرى هذا السقف على الغش والخطأ الجسيم.',
      'غرامة التأخير: يوقع على المقاول غرامة 0.5 % من قيمة العقد عن كل أسبوع تأخير بحد أقصى 10 % من قيمة العقد.',
      'الإنهاء: لكل طرف إنهاء العقد عند الإخلال الجوهرى بعد إنذار بتصحيح الإخلال خلال 30 يوماً، وللعميل الإنهاء للمصلحة بإخطار قبل شهر مع سداد قيمة الأعمال المنفذة والمصروفات.',
      'الملكية الفكرية: تنتقل ملكية المخرجات المخصصة للعميل بعد السداد الكامل، ويحتفظ المقاول بأدواته السابقة ويمنح العميل ترخيصاً دائماً لاستخدامها.',
      'السرية: يلتزم الطرفان بسرية المعلومات المتبادلة وحماية البيانات الشخصية وفق القانون.',
      'الضمان: يضمن المقاول الأعمال ضد العيوب لمدة 12 شهراً من التسليم ويصلحها دون مقابل خلال مدة معقولة.',
    ],
  },
  {
    name: 'عمل متوازن',
    type: 'عقد عمل',
    roles: ['صاحب العمل', 'العامل'],
    texts: [
      'المدة: عقد غير محدد المدة يبدأ فى 1/3/2027 ويحرر كتابةً بالعربية من أربع نسخ تسلم إحداها للعامل.',
      'فترة الاختبار: يخضع العامل لفترة اختبار مدتها ثلاثة أشهر ولمرة واحدة.',
      'الأجر: الأجر الأساسى 12000 جنيه والبدلات 3000 جنيه تصرف شهرياً بحساب العامل البنكى. ولا يجوز تعديل الأجر إلا باتفاق كتابى.',
      'ساعات العمل: يعمل العامل 8 ساعات يومياً و40 ساعة أسبوعياً، وله إجازة سنوية بأجر وفق القانون، ولا يجوز للعامل النزول عن إجازته.',
      'الإنهاء: لا يجوز لأى من الطرفين إنهاء العقد إلا لمبرر مشروع وكاف وبإخطار كتابى قبل شهرين.',
      'السرية: يلتزم العامل بالحفاظ على أسرار العمل أثناء العقد وبعده.',
      'التأمينات: يسجل صاحب العمل العامل فى التأمينات الاجتماعية من تاريخ بدء العمل بالأجر الفعلى، ويتحمل كل طرف حصته القانونية.',
    ],
  },
  {
    name: 'شراكة متوازنة',
    type: 'عقد شراكة أو استثمار',
    roles: ['الشريك المستثمر', 'الشريك المدير أو صاحب المشروع'],
    texts: [
      'الشكل القانونى: يتفق الشريكان على إنشاء شركة مدنية بعقد مكتوب، ولا يجوز تعديل العقد إلا بملحق مكتوب موقع من الطرفين.',
      'رأس المال: يسدد الشريك المستثمر رأس المال وقدره 5000000 جنيه على ثلاث دفعات مرتبطة بمراحل الإنجاز فى حساب مصرفى مخصص للمشروع.',
      'الأرباح: يوزع صافى الربح بنسبة 60 % للمدير و40 % للمستثمر كل ثلاثة أشهر بعد اعتماد الحسابات، ويتحمل كل شريك الخسائر بنسبة حصته.',
      'الإدارة: يدير الشريك المدير المشروع يومياً، ويلزم موافقة المستثمر الكتابية على الاقتراض والرهن وبيع الأصول الرئيسية وتجاوز الموازنة المعتمدة.',
      'الدفاتر: يمسك المدير دفاتر منتظمة ويقدم تقريراً ربع سنوياً، وللمستثمر الاطلاع على الدفاتر والمستندات بإخطار مسبق وفى ساعات العمل.',
      'عدم المنافسة: يمتنع كل شريك عن أى نشاط مماثل لنشاط المشروع طوال مدة الشركة ولمدة ستة أشهر بعدها فى نطاق القاهرة الكبرى.',
      'المسئولية: يتحمل كل شريك ديون الشركة بنسبة حصته، ولا تضامن بين الشركاء إلا بنص كتابى.',
      'الخروج: لأى شريك الانسحاب بإخطار قبل ثلاثة أشهر، وتقدر حصته بمعرفة مقيم مستقل، وللشريك الآخر أولوية الشراء.',
    ],
  },
  {
    name: 'تمويل متوازن',
    type: 'عقد تمويل أو قرض',
    roles: ['الممول (الدائن)', 'المقترض (المدين)'],
    texts: [
      'مبلغ القرض: يمنح الممول المقترض قرضاً قدره 2000000 جنيه يصرف على دفعتين عند استيفاء الشروط السابقة المبينة بالملحق، وللممول إيقاف الصرف عند إخلال المقترض بالتزام جوهرى.',
      'الفائدة: يسدد المقترض فائدة سنوية ثابتة قدرها 7 % بسيطة تحسب على الرصيد المتبقى، ولا يتقاضى الممول أى عمولات أخرى إلا مقابل خدمات فعلية مبينة بالملحق.',
      'السداد: يسدد المقترض القرض على 24 قسطاً شهرياً متساوياً، وفى حالة التأخير تحتسب فائدة تأخير 1 % سنوياً بعد مهلة 15 يوماً.',
      'الإخلال: إذا تأخر المقترض عن سداد قسطين متتاليين أخطره الممول كتابة بمهلة 30 يوماً لتدارك الإخلال، فإن لم يتدارك حلت باقى الأقساط.',
      'الضمانات: يقدم المقترض رهناً تجارياً على المعدات، ويقدم الكفيل كفالة غير تضامنية فى حدود مبلغ 500000 جنيه ولمدة سنتين، ويفك الضمان عند السداد الكامل.',
      'السداد المبكر: يحق للمقترض السداد المبكر فى أى وقت بإخطار قبل 30 يوماً دون أى رسوم.',
    ],
  },
  {
    name: 'وكالة متوازنة',
    type: 'عقد وكالة أو سمسرة أو تسويق',
    roles: ['الموكِّل (صاحب المنتج أو الخدمة)', 'الوكيل أو السمسار'],
    texts: [
      'الوكالة: يتولى الوكيل الترويج للمنتجات وإبرام العقود باسم الموكل فى حدود مبلغ 100000 جنيه للصفقة الواحدة، وما جاوز ذلك يلزم له موافقة الموكل الكتابية، ولا يجوز للوكيل إنابة غيره إلا بموافقة كتابية مسبقة.',
      'العمولة: يستحق الوكيل عمولة 8 % من قيمة الصفقات التى أبرمت بسببه خلال مدة العقد وتستحق بمجرد إبرام الصفقة، ويقدم الموكل للوكيل كشف حساب شهرى بها.',
      'الحصرية: يكون الوكيل وكيلاً حصرياً فى إقليم الإسكندرية بشرط تحقيق حد أدنى للمبيعات قدره مليون جنيه سنوياً، وللموكل إنهاء الحصرية إذا لم يبلغ هذا الحد.',
      'التحصيل: يورد الوكيل المبالغ المحصلة إلى حساب الموكل خلال 7 أيام من تحصيلها، ويقدم كشف حساب شهرى.',
      'الإنهاء: لكل طرف إنهاء الوكالة بإخطار كتابى قبل ثلاثة أشهر، وإذا أنهاها الموكل دون سبب مشروع خلال السنتين الأوليين عوض الوكيل عن الضرر الذى لحقه.',
      'المسئولية: يبذل الوكيل عناية الرجل المعتاد، ولا يسأل عن عدم سداد العملاء إلا إذا قصر فى التحرى عن ملاءتهم، ويرد الموكل للوكيل ما أنفقه فى تنفيذ الوكالة.',
    ],
  },
  {
    name: 'ترخيص متوازن',
    type: 'عقد ترخيص أو امتياز تجارى',
    roles: ['مانح الترخيص', 'المرخَّص له'],
    texts: [
      'النطاق: يمنح المانح المرخص له ترخيصاً حصرياً لاستعمال العلامة على الأحذية فى جمهورية مصر العربية بشرط تحقيق حد أدنى للمبيعات السنوية.',
      'المقابل: تحتسب الأتاوة بنسبة 5 % من صافى المبيعات بعد خصم المرتجعات والضرائب وتسدد كل ثلاثة أشهر، وللمانح تدقيق دفاتر المرخص له سنوياً.',
      'المدة: مدة الترخيص خمس سنوات تجدد بموافقة الطرفين، ولا ينهى المانح الترخيص إلا لسبب مشروع بعد إخطار المرخص له بمهلة 60 يوماً لتدارك الإخلال.',
      'الجودة: يلتزم المرخص له بدليل معايير الجودة المرفق، ولا يعدل المانح المعايير إلا بإخطار قبل 90 يوماً وبمهلة معقولة للتنفيذ.',
      'الملكية: تبقى العلامة مملوكة للمانح وحده، وتبقى التحسينات المستقلة التى يبتكرها المرخص له ملكاً له مع ترخيص للمانح باستعمالها، ويلتزم المانح بالدفاع عن العلامة ضد التعدى.',
      'التنازل: لا يجوز للمرخص له التنازل عن الترخيص إلا بموافقة المانح الكتابية التى لا تحجب دون سبب معقول.',
      'الضمان: يضمن المانح أنه مالك العلامة وأنها لا تتعدى على حقوق الغير، ويعوض المرخص له عن ادعاءات الغير، ويلتزم المرخص له بتعويض المانح عن إخلاله بالعقد بحد أقصى مجموع الأتاوات المدفوعة.',
    ],
  },
];

describe('golden set — الدقة: لا إنذار كاذب على نصوص متوازنة', () => {
  for (const b of BALANCED) {
    for (const role of b.roles) {
      it(`${b.name} — ${role}`, () => {
        const clauses: LevelClause[] = b.texts.map((t, i) => ({
          clauseIndex: i + 1,
          clauseLabel: `البند ${i + 1}`,
          clauseTitle: null,
          clauseText: t,
        }));
        const pb = buildPlaybook({ contractType: b.type, clientRole: role, clauses })!;
        const flagged = pb.rows.flatMap((r) => r.concerns.map((c) => `${r.topicId}.${c.flagId}`));
        expect(flagged).toEqual([]);
      });
    }
  }
});
