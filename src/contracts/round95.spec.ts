import { mandatoryClausePatch, mandatoryRuleHits } from './mandatory-rules';
import { officeRuleFindings } from './office-rules';
import type { LevelClause } from './contract-level';

const ids = (t: string) => mandatoryRuleHits(t).map((h) => h.ruleId);
const cl = (i: number, text: string): LevelClause => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: text });
const office = (clauses: LevelClause[], type = 'عقد إيجار') => officeRuleFindings(clauses, { contractType: type, textMayBeIncomplete: false });

describe('R95 — المادة 578/453: إسقاط ضمان العيب مع العلم به أو تعمد إخفائه', () => {
  const LEASE = 'العين المؤجرة: أجرت المؤجرة للمستأجر المحل بحالته التى عاينها، ويقر المستأجر بصلاحيته لنشاطه، ولا تضمن المؤجرة أى عيب خفى تعلم به أو تعمد إخفاءه لم يظهر عند المعاينة العادية.';

  it('نص إيجار ج الصريح ⇒ latent_defect_waiver حرج بالمادة 578 مؤكدة', () => {
    const h = mandatoryRuleHits(LEASE).find((x) => x.ruleId === 'latent_defect_waiver')!;
    expect(h).toBeDefined();
    expect(h.severity).toBe('حرج');
    expect(h.articles).toEqual([578]);
    expect(h.uncertainReading).toBe(false);
    expect(h.explanation).toContain('يقع باطلا كل اتفاق يتضمن الإعفاء أو الحد من ضمان التعرض أو العيب');
  });

  it('المدقق المستقل دحض الملاحظة (بلا اقتباس) ⇒ يثبتها القاعدة ولا يُسقطها الدحض', () => {
    const hits = mandatoryRuleHits(LEASE);
    const patch = mandatoryClausePatch(
      {
        assessmentStatus: 'يحتاج مراجعة',
        riskLevel: 'حرج',
        assessmentReasoning: 'يسقط البند ضمان العيوب الخفية.',
        matchedArticles: [],
        verification: { status: 'unconfirmed', basis: 'uncertain', reason: 'اعترض المدقق المستقل دون اقتباس موثَّق', quote: null, quoteSource: null },
      },
      hits,
    )!;
    expect(patch.verification['status']).toBe('confirmed');
    expect(patch.riskLevel).toBe('حرج');
    expect(patch.matchedArticles.some((m) => m.article_no === 578 && m.snippet.includes('تعمد إخفاء سبب هذا الضمان'))).toBe(true);
  });

  it('قراءة ممسوحة تالفة لكلمة الإعفاء («ولا hace المؤجرة أى عيت خفى…») ⇒ مرشحة غير مؤكدة بسبب القراءة لا النسبة', () => {
    const garbled = 'ويقر المستأجر بصلاحيته لنشاطه. ولا hace المؤجرة أى عيت خفى تعلم به أو تعمد إخفاءه لم يظهر غند المفاينة العادية.';
    const hits = mandatoryRuleHits(garbled);
    const h = hits.find((x) => x.ruleId === 'latent_defect_waiver')!;
    expect(h).toBeDefined();
    expect(h.uncertainReading).toBe(true);
    const patch = mandatoryClausePatch({ assessmentStatus: null, riskLevel: null, assessmentReasoning: null, matchedArticles: null, verification: null }, hits)!;
    expect(patch.verification['status']).toBe('unconfirmed');
    expect(String(patch.verification['reason'])).toContain('كلمة الإعفاء من الضمان');
    expect(String(patch.verification['reason'])).not.toContain('النسبة');
  });

  it('البائع: إسقاط ضمان العيب ولو تعمد إخفاءه ⇒ المادة 453', () => {
    const h = mandatoryRuleHits('يبيع البائع المبيع بحالته ولا يضمن البائع أى عيب ولو تعمد إخفاءه أو كان يعلم به وقت البيع.').find((x) => x.ruleId === 'latent_defect_waiver')!;
    expect(h).toBeDefined();
    expect(h.articles).toEqual([453]);
  });

  it('سلبيات: إعفاء عام بلا ذكر العلم/الإخفاء، أو استثناء الغش، أو ضمان المؤجر لما علمه', () => {
    expect(ids('ولا تضمن المؤجرة أى عيب خفى لم يظهر عند المعاينة العادية.')).not.toContain('latent_defect_waiver');
    expect(ids('ولا تضمن المؤجرة أى عيب خفى إلا ما تعلم به أو تعمد إخفاءه.')).not.toContain('latent_defect_waiver');
    expect(ids('ولا تضمن المؤجرة العيوب الخفية ما لم تكن قد تعمدت إخفاءها.')).not.toContain('latent_defect_waiver');
    expect(ids('تضمن المؤجرة كل عيب خفى تعلم به أو تعمد إخفاءه ويلتزم المؤجر بإصلاحه.')).not.toContain('latent_defect_waiver');
    expect(ids('لا يضمن المقاول العيوب التى تعلم بها رب العمل.')).not.toContain('latent_defect_waiver');
  });
});

describe('R95 — المادة 544: السداد المعجل فى القرض بفوائد (قرار المالك: حرج)', () => {
  const C = 'السداد المعجل: يجوز للمقترض السداد المعجل بموافقة كتابية من المقرض يحق له رفضها، فإذا وافق التزم المقترض بدفع الفوائد عن المدة الباقية من القرض كاملة.';
  const A = 'السداد المعجل: إذا رغب المقترض فى السداد المعجل التزم بدفع غرامة قدرها 15% من الرصيد المسدد قبل ميعاده بالإضافة إلى فوائد باقى المدة كاملة.';
  const B = 'السداد المعجل: يجوز للمقترض السداد المعجل كلياً أو جزئياً بإخطار قبل خمسة عشر يوماً، ويستحق المقرض عن ذلك مصروفات قدرها 1% من الرصيد المسدد، وتحسب الفوائد حتى تاريخ السداد فقط.';

  it('تمويل ج: فوائد المدة الباقية + موافقة يحق للمقرض رفضها ⇒ prepayment_charge حرج بالمادة 544', () => {
    const h = mandatoryRuleHits(C).find((x) => x.ruleId === 'prepayment_charge')!;
    expect(h).toBeDefined();
    expect(h.severity).toBe('حرج');
    expect(h.articles).toEqual([544]);
    expect(h.explanation).toContain('فوائد المدة الباقية');
    expect(h.explanation).toContain('يحق للمقرض رفضها');
    expect(h.explanation).toContain('ولا يجوز بوجه من الوجوه إلزامه بأداء فائدة أو مقابل من أى نوع بسبب تعجيل الوفاء');
  });

  it('تمويل أ: غرامة 15% + فوائد باقى المدة ⇒ يُرصد', () => {
    expect(ids(A)).toContain('prepayment_charge');
  });

  it('تمويل ب: مصروفات 1% وفوائد حتى تاريخ السداد فقط ⇒ لا يُرصد (عقد نظيف فى المفتاح)', () => {
    expect(ids(B)).not.toContain('prepayment_charge');
  });

  it('بند لا يذكر الفائدة أصلاً ⇒ لا يُرصد (544 تشترط قرضاً بفوائد)', () => {
    expect(ids('يجوز للمقترض السداد المعجل بموافقة كتابية من المقرض يحق له رفضها.')).not.toContain('prepayment_charge');
  });

  it('حظر السداد قبل الأجل فى قرض بفوائد ⇒ يُرصد', () => {
    expect(ids('الفائدة 7% سنوياً، ولا يجوز للمقترض السداد قبل الأجل المحدد بأى حال.')).toContain('prepayment_charge');
  });
});

describe('R95 — قواعد المكتب: جهة يختارها أحد الطرفين وحده / إنهاء مبكر دون تعويض', () => {
  const MAINT = 'الصيانة والإصلاحات: يتحمل المستأجر الصيانة والإصلاحات اللازمة للانتفاع بالمحل، وتتحمل المؤجرة الإصلاحات الإنشائية الجسيمة فقط إذا ثبت أنها لم تنشأ عن الاستعمال بتقرير تختاره المؤجرة.';
  const FM = 'المسئولية والتأمين على العين: يتحمل المستأجر المسئولية عن أى تلف أو هلاك يلحق بالعين ما لم يثبت أن سببه قوة قاهرة، ويكفى لإثبات القوة القاهرة تقرير جهة تختارها المؤجرة.';
  const TERM = 'مدة الإيجار: مدة الإيجار ثلاث سنوات تبدأ من 1/1/2027، وللمؤجرة إنهاؤه قبل المدة إذا احتاجت العين لأغراض شخصية أو لهدم العقار أو ترميمه بإخطار قبل شهر، دون التزام بتعويض المستأجر عن التجهيزات.';

  it('بندا الصيانة (7) والمسئولية (12) فى إيجار ج ⇒ ملاحظة واحدة بدليلين', () => {
    const f = office([cl(7, MAINT), cl(12, FM)]).find((x) => x.id === 'office:one_sided_determiner')!;
    expect(f).toBeDefined();
    expect(f.severity).toBe('متوسط');
    expect(f.evidence.map((e) => e.clauseIndex).sort((a, b) => a - b)).toEqual([7, 12]);
  });

  it('قراءة ممسوحة: «جهةتختارها» بلا فواصل تالفة لا تحجب، و«المؤجر» بلا تاء مربوطة', () => {
    expect(office([cl(12, 'ويكفى لإثبات القوة القاهرة تقرير جهة تختارها المؤجر.')]).some((x) => x.id === 'office:one_sided_determiner')).toBe(true);
  });

  it('تحكيم يختاره المقرض ⇒ يُرصد؛ أما الخبير الذى يتفق عليه الطرفان أو تعينه المحكمة فلا', () => {
    expect(office([cl(13, 'يحال كل نزاع إلى تحكيم يختاره المقرض ونفقاته على المقترض.')], 'عقد قرض وتمويل').some((x) => x.id === 'office:one_sided_determiner')).toBe(true);
    expect(office([cl(7, 'يثبت العيب الإنشائى بتقرير خبير يتفق عليه الطرفان.')]).some((x) => x.id === 'office:one_sided_determiner')).toBe(false);
    expect(office([cl(7, 'يثبت ذلك بتقرير خبير تعينه المحكمة المختصة بناء على طلب المؤجرة.')]).some((x) => x.id === 'office:one_sided_determiner')).toBe(false);
  });

  it('إنهاء مبكر بإرادة المؤجرة «دون التزام بتعويض» ⇒ early_termination_no_compensation متوسط', () => {
    const f = office([cl(3, TERM)]).find((x) => x.id === 'office:early_termination_no_compensation')!;
    expect(f).toBeDefined();
    expect(f.severity).toBe('متوسط');
    expect(f.evidence[0].clauseIndex).toBe(3);
  });

  it('قراءة ممسوحة «قبل المذة» تُرصد أيضاً', () => {
    expect(office([cl(3, 'وللمؤجرة إنهاؤة قبل المذة إذا احتاجت العين لأغراض شخصية بإخطار قبل شهر، دون التزام بتعويض المستأجر.')]).some((x) => x.id === 'office:early_termination_no_compensation')).toBe(true);
  });

  it('إنهاء مبكر مع تعويض، أو دون تعويض لكن بلا إنهاء مبكر ⇒ لا يُرصد', () => {
    expect(office([cl(3, 'وللمؤجرة إنهاؤه قبل المدة لأغراض شخصية بإخطار قبل ثلاثة أشهر وتعويض المستأجر عن التجهيزات غير المستهلكة.')]).some((x) => x.id === 'office:early_termination_no_compensation')).toBe(false);
    expect(office([cl(3, 'ينتهى العقد بانتهاء مدته دون التزام بتعويض أى من الطرفين.')]).some((x) => x.id === 'office:early_termination_no_compensation')).toBe(false);
  });
});
