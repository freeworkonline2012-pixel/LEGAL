import { quoteReducesLiability, validateClauseFacts } from './clause-facts';
import type { LevelClause } from './contract-level';
import { buildPlaybook } from './playbook';

const cl = (text: string, i = 1): LevelClause => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: text });

// نص البند 8 فى عقد السمسرة 0178 (الأصل الممسوح): توزيع المسئولية على الوسيط لا إعفاء
const CLAUSE8 =
  'يلتزم الطرف الثانى بتوفير العاملين اللازمين ويكون استخدامه لهم لحسابه وحده وعلى نفقته وتحت اشرافه ورقابته بحيث يكون مسئولا وحده عنهم وعن أعمالهم أمام الطرف الأول أو أمام الغير.';
const QUOTE8 = 'بحيث يكون مسئولا وحده عنهم وعن أعمالهم أمام الطرف الأول أو أمام الغير';

describe('الجولة 64: بوابة دلالة الإعفاء من المسئولية', () => {
  it('البند 8 (تحميل المسئولية على الوسيط) لا يصير واقعة إعفاء ⇒ لا ملاحظة 217/2', () => {
    const f = validateClauseFacts({ liability: { kind: 'exclusion', gross_fault: 'unspecified', beneficiary: 'second', quote: QUOTE8 } }, CLAUSE8);
    expect(f.liability).toBeUndefined();
  });

  it.each([
    'لا يسأل الطرف الأول عن أى ضرر',
    'يعفى الطرفان من المسئولية',
    'يعفى الطرف الثانى من أية مسئولية تترتب على التأخير',
    'غير مسئولة الشركة عن أى خسائر غير مباشرة',
    'ولا يتحمل الطرف الثانى أية مسؤولية عن الأعطال',
    'بدون أى مسئولية على الشركة تجاه العميل',
    'تكون مسئولية الطرف الثانى بحد أقصى قيمة العقد',
    'على ألا تتجاوز المسئولية قيمة الأتعاب المسددة',
    'ويقتصر التعويض فى حدود قيمة الأتعاب',
    'يتنازل الطرف الأول عن أى مطالبة بالتعويض',
  ])('اقتباس إعفاء/تحديد حقيقى يُقبل: %s', (q) => {
    expect(quoteReducesLiability(q)).toBe(true);
  });

  it.each([
    'يكون مسئولا وحده عن عماله أمام الغير',
    'يتحمل الطرف الثانى كافة المسئولية عن أعمال تابعيه',
    'تظل الشركة مسئولة مسئولية كاملة عن الأضرار',
    'يلتزم الطرف الثانى بتعويض الطرف الأول عن كل ضرر',
  ])('تحميل المسئولية ليس إعفاء ولا تحديداً: %s', (q) => {
    expect(quoteReducesLiability(q)).toBe(false);
  });

  it('واقعة إعفاء صحيحة تبقى كما هى', () => {
    const clause = 'لا يسأل الطرف الأول عن أى ضرر ينشأ عن تأخير التسليم.';
    const f = validateClauseFacts({ liability: { kind: 'exclusion', gross_fault: 'unspecified', beneficiary: 'first', quote: 'لا يسأل الطرف الأول عن أى ضرر' } }, clause);
    expect(f.liability?.kind).toBe('exclusion');
  });

  it('kind none لا يخضع للبوابة', () => {
    const f = validateClauseFacts({ liability: { kind: 'none', gross_fault: 'unspecified', beneficiary: 'none', quote: 'يكون مسئولا وحده عن عماله' } }, 'يكون مسئولا وحده عن عماله أمام الغير');
    expect(f.liability?.kind).toBe('none');
  });
});

describe('الجولة 64: بوابة النوع الفرعى لصفوف دليل التفاوض', () => {
  const COLLECTION = [
    'يتولى مقدم الخدمة تحصيل المبالغ المستحقة للعميل لدى عملائه ويورد المبالغ المحصلة.',
    'تورد متحصلات التحصيل خلال ثلاثة أيام من تاريخ التحصيل ويمسك مقدم الخدمة سجلاً بالحصيلة.',
    'يتقاضى مقدم الخدمة عمولة على المبالغ المحصلة وفقاً لجدول التحصيل المرفق.',
  ].map((t, i) => cl(t, i + 1));
  const run = (clauses: LevelClause[]) =>
    buildPlaybook({ contractType: 'عقد خدمات أو مقاولة أو توريد', clientRole: 'طالب الخدمة (صاحب العمل / العميل)', clientParty: 'first', clauses })!;

  it('عقد تحصيل بلا نص ملكية فكرية أو ضمان ⇒ لا صف svc_ip ولا svc_warranty', () => {
    const ids = run(COLLECTION).rows.map((r) => r.topicId);
    expect(ids).not.toContain('svc_ip');
    expect(ids).not.toContain('svc_warranty');
  });

  it('نفس العقد إن ورد فيه نص ملكية فكرية فالصف يُعرض (المرصود لا يُحجب)', () => {
    const withIp = [...COLLECTION, cl('تظل حقوق الملكية الفكرية على المنصة ملكاً لمقدم الخدمة ويرخص للعميل باستخدامها.', 4)];
    expect(run(withIp).rows.map((r) => r.topicId)).toContain('svc_ip');
  });

  it('عقد خدمات عام (بلا مؤشرات تحصيل) يبقى صف الملكية الفكرية', () => {
    const generic = [cl('يلتزم الطرف الأول بتطوير تطبيق للطرف الثانى وتسليمه خلال ستين يوماً ويدفع الطرف الثانى الأتعاب المتفق عليها.')];
    expect(run(generic).rows.map((r) => r.topicId)).toContain('svc_ip');
  });
});
