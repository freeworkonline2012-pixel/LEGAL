import * as fs from 'fs';
import { officeRuleFindings } from './office-rules';
import type { LevelClause } from './contract-level';

const cl = (i: number, text: string): LevelClause => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: text });
const ids = (clauses: LevelClause[], type: string) => officeRuleFindings(clauses, { contractType: type, textMayBeIncomplete: false }).map((f) => f.id.replace('office:', ''));

describe('R97 — الاستئثار الطويل', () => {
  it('كل الاحتياجات من المورد وحده لخمس سنوات ولو عجز ⇒ يُرصد (توريد أ بند 9)', () => {
    const t = 'الاستئثار وعدم المنافسة: يلتزم المشترى بشراء كل احتياجاته من العبوات من المورد وحده لمدة خمس سنوات، ولا يجوز له التعامل مع غيره ولو عجز المورد عن التوريد.';
    expect(ids([cl(9, t)], 'عقد توريد')).toContain('long_exclusive_purchase');
  });
  it('سنتان أو غير حصرى ⇒ لا يُرصد', () => {
    expect(ids([cl(9, 'يلتزم المشترى بشراء كل احتياجاته من العبوات من المورد وحده لمدة سنتين.')], 'عقد توريد')).not.toContain('long_exclusive_purchase');
    expect(ids([cl(9, 'يتعاقد الطرفان على أساس غير حصرى، ويحق للمشترى الشراء من غير المورد، ويمنح المورد أولوية فى عروض الأسعار المتساوية.')], 'عقد توريد')).not.toContain('long_exclusive_purchase');
  });
});

describe('R97 — الحد الأدنى الإلزامى', () => {
  it('حد أدنى سواء احتاج إليها أم لا ويدفع ثمنها (توريد أ بند 3) ⇒ يُرصد', () => {
    const t = 'الكميات: يلتزم المشترى بشراء حد أدنى 50000 عبوة شهرياً سواء احتاج إليها أم لا ويدفع ثمنها كاملة، وللمورد زيادة الكميات المرسلة وفق ما يراه.';
    expect(ids([cl(3, t)], 'عقد توريد')).toContain('take_or_pay_minimum');
  });
  it('80% يرحل العجز ويدفع ثمنه (توريد ج بند 3) ⇒ يُرصد', () => {
    const t = 'الكميات: يقدم المشترى توقعاً سنوياً لاحتياجاته بنحو 40000 عبوة شهرياً، ويلتزم بشراء 80% من هذا التوقع على الأقل شهرياً، وما لم يشتر منه فى شهر يحسب ضمن الحد الأدنى للشهر التالى ويدفع المشترى ثمنه عن الشهر الذى حدث فيه العجز.';
    expect(ids([cl(3, t)], 'عقد توريد')).toContain('take_or_pay_minimum');
  });
  it('تقدير احتياج بلا حد أدنى (توريد ب) ⇒ لا يُرصد', () => {
    const t = 'الكميات: تقدر احتياجات المشترى بنحو 40000 عبوة شهرياً، ويصدر أوامر توريد شهرية يلتزم المورد بتنفيذها بزيادة أو نقص لا يجاوز 20% من الكمية التقديرية دون التزام بحد أدنى.';
    expect(ids([cl(3, t)], 'عقد توريد')).not.toContain('take_or_pay_minimum');
  });
});

describe('R97 — التعليق أو الإنهاء الأحادى', () => {
  it('للمورد إنهاء العقد أو تعليق التوريد فى أى وقت بإخطار شفوى (توريد أ بند 11) ⇒ يُرصد', () => {
    const t = 'الإنهاء وتعليق التوريد: للمورد إنهاء العقد أو تعليق التوريد فى أى وقت بإخطار شفوى ودون أى مسئولية، أما المشترى فلا يجوز له إنهاء العقد بحال قبل انقضاء المدة.';
    expect(ids([cl(11, t)], 'عقد توريد')).toContain('unilateral_suspension_or_termination');
  });
  it('تعليق إذا رأى ما يهدد قدرة المشترى (توريد ج بند 11) ⇒ يُرصد', () => {
    const t = 'الإنهاء وتعليق التوريد: مدة العقد سنتان، وللمورد تعليق التوريد فى أى وقت إذا رأى ما يهدد قدرة المشترى على السداد، ولا يكون للمشترى إنهاء العقد إلا عند ثبوت إخلال المورد بحكم قضائى نهائى.';
    expect(ids([cl(11, t)], 'عقد توريد')).toContain('unilateral_suspension_or_termination');
  });
  it('إنهاء عند إخلال بعد إنذار وتعليق بعد إنذاره (توريد ب) ⇒ لا يُرصد', () => {
    const t = 'الإنهاء وتعليق التوريد: مدة العقد سنتان، ولكل طرف إنهاؤه عند إخلال الآخر بالتزام جوهرى بعد إنذاره بتصحيحه خلال ثلاثين يوماً، ولا يعلق المورد التوريد إلا لتأخر المشترى فى سداد مبالغ مستحقة غير متنازع عليها بعد إنذاره.';
    expect(ids([cl(11, t)], 'عقد توريد')).not.toContain('unilateral_suspension_or_termination');
  });
});

describe('R97 — حلول الأجل بتقدير المقرض', () => {
  it('المطالبة بسداد كامل المبلغ فى أى وقت (تمويل أ بند 3) ⇒ يُرصد', () => {
    const t = 'مدة القرض والسداد: مدة القرض اثنا عشر شهراً، وللمقرض أن يطالب بسداد كامل المبلغ وفوائده فى أى وقت متى طلب ذلك، ويلتزم المقترض بالسداد فوراً.';
    expect(ids([cl(3, t)], 'عقد تمويل')).toContain('lender_discretionary_acceleration');
  });
  it('حلول الأجل دون إنذار وبرأى المقرض وحده (تمويل أ بند 6) ⇒ يُرصد', () => {
    const t = 'حلول الأجل: يحل أجل القرض كله فوراً دون إنذار إذا أخل المقترض بأى التزام فى هذا العقد مهما كان بسيطاً أو إذا رأى المقرض وحده أن مركز الشركة المالى قد ساء.';
    expect(ids([cl(6, t)], 'عقد تمويل')).toContain('lender_discretionary_acceleration');
  });
  it('حلول الأجل بحسب تقدير المقرض (تمويل ج بند 6) ⇒ يُرصد', () => {
    const t = 'حلول الأجل: يحل أجل القرض كله إذا تأخر المقترض عن سداد قسط، أو إذا طرأ تغيير جوهرى فى نشاط الشركة أو ملكيتها أو مركزها المالى حسب تقدير المقرض، ويكفى لذلك إخطار المقرض للمقترض بالبريد الإلكترونى.';
    expect(ids([cl(6, t)], 'عقد تمويل')).toContain('lender_discretionary_acceleration');
  });
  it('لا يحل الأجل إلا بعد ثلاثة أقساط وإنذار (تمويل ب) ⇒ لا يُرصد', () => {
    const t = 'حلول الأجل: لا يحل أجل القرض قبل ميعاده إلا إذا تأخر المقترض عن ثلاثة أقساط متتالية أو أخل بالتزام جوهرى ولم يصححه خلال ثلاثين يوماً من إنذاره كتابة.';
    expect(ids([cl(6, t)], 'عقد تمويل')).not.toContain('lender_discretionary_acceleration');
  });
});

describe('R97 — مسح الاثنى عشر عقداً: لا إصابة على العقود النظيفة (ب)', () => {
  const dir = '/home/claude/r90_synth/out/';
  const RULES = ['long_exclusive_purchase', 'take_or_pay_minimum', 'unilateral_suspension_or_termination', 'lender_discretionary_acceleration'];
  const present = fs.existsSync(dir);
  (present ? it : it.skip)('مسح المصادر', () => {
    const rows: string[] = [];
    for (const f of fs.readdirSync(dir).filter((x) => x.startsWith('دفعة2_') && x.endsWith('.txt'))) {
      const t = fs.readFileSync(dir + f, 'utf8');
      const parts = t.split(/\n(?=(?:المادة|البند)\s*\d+\s*\n)/);
      const clauses = parts.map((p, i) => cl(i, p));
      const type = /إيجار/.test(f) ? 'عقد إيجار' : /تمويل/.test(f) ? 'عقد تمويل' : /توريد/.test(f) ? 'عقد توريد' : 'عقد مقاولة';
      const hit = officeRuleFindings(clauses, { contractType: type, textMayBeIncomplete: false }).filter((x) => RULES.some((r) => x.id === `office:${r}`));
      rows.push(`${f}: ${hit.map((x) => `${x.id.replace('office:', '')}@${x.evidence[0]?.clauseIndex}`).join(' ')}`);
    }
    const clean = rows.filter((r) => /_ب\.txt/.test(r) && /: \S/.test(r));
    expect(clean).toEqual([]);
  });
});
