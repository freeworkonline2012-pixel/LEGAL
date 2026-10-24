import type { ClauseFacts } from './clause-facts';
import { evaluateRules, summarizeFindings } from './clause-rules';

// وقائع مُصطنَعة (الاقتباسات هنا بيانات اختبار للقواعد؛ تحقق الاقتباس نفسه فى clause-facts.spec)
const waived: ClauseFacts = {
  termination: { mechanism: 'unilateral_right', holder: 'second', quote: 'يجوز للطرف الثانى فسخ العقد' },
  notice: { state: 'waived_explicitly', quote: 'دون حاجة الى إنذار أو تنبيه' },
};

describe('قاعدة الفسخ والإعذار (157/158)', () => {
  it('G1: إعفاء صريح من الإعذار والحق للعميل ⇒ متوافق ولا ملاحظة إعذار', () => {
    const [f] = evaluateRules(waived, { clientParty: 'second' });
    expect(f.status).toBe('compliant');
    expect(f.articles).toContain(158);
    expect(f.explanation).toContain('دون حاجة الى إنذار أو تنبيه');
    expect(f.explanation).toContain('الحق هنا للعميل');
  });
  it('الإعفاء الصريح والحق للطرف المقابل ⇒ مراجعة متوسطة بلا ادعاء مخالفة قانونية', () => {
    const [f] = evaluateRules(waived, { clientParty: 'first' });
    expect(f.status).toBe('review');
    expect(f.severity).toBe('medium');
    expect(f.explanation).toContain('فلا مخالفة قانونية');
  });
  it('بلا ذكر للإعذار والحق للعميل ⇒ مراجعة (إعفاء غير صريح)', () => {
    const [f] = evaluateRules({ termination: waived.termination, notice: { state: 'not_addressed', quote: '' } }, { clientParty: 'second' });
    expect(f.status).toBe('review');
    expect(f.ruleId).toBe('termination.not_addressed.weak_waiver');
  });
  it('بلا ذكر للإعذار والحق للطرف المقابل ⇒ متوافق (يحمى العميل)', () => {
    const [f] = evaluateRules({ termination: waived.termination, notice: { state: 'not_addressed', quote: '' } }, { clientParty: 'first' });
    expect(f.status).toBe('compliant');
  });
  it('فسخ بحكم قضائى ⇒ متوافق', () => {
    const [f] = evaluateRules({ termination: { mechanism: 'court_required', holder: 'both', quote: 'بحكم قضائى نهائى' } }, { clientParty: null });
    expect(f.status).toBe('compliant');
  });
  it('بلا قسم notice لا تصدر نتيجة (لا تخمين)', () => {
    expect(evaluateRules({ termination: waived.termination }, { clientParty: 'second' })).toEqual([]);
  });
});

describe('قاعدة القوة القاهرة (165/373/217)', () => {
  const fm = (over: Partial<NonNullable<ClauseFacts['forceMajeure']>>): ClauseFacts => ({
    forceMajeure: { extraCauses: 'open_ended', counterpartyCanReject: false, noticeRequired: true, beneficiary: 'first', quote: 'أسباب أخرى خارجه عن إرادة أى منهما', ...over },
  });
  it('أسباب مفتوحة بلا حق رفض ⇒ مراجعة عالية عند العميل المقابل', () => {
    const [f] = evaluateRules(fm({}), { clientParty: 'second' });
    expect(f.status).toBe('review');
    expect(f.severity).toBe('high');
    expect(f.articles).toEqual(expect.arrayContaining([165, 373]));
  });
  it('أسباب مفتوحة مع حق الطرف المقابل فى الرفض ⇒ متوافق', () => {
    const [f] = evaluateRules(fm({ counterpartyCanReject: true }), { clientParty: 'second' });
    expect(f.status).toBe('compliant');
  });
  it('قوة قاهرة قانونية فقط ⇒ متوافق', () => {
    expect(evaluateRules(fm({ extraCauses: 'legal_only' }), { clientParty: null })[0].status).toBe('compliant');
  });
});

describe('قاعدة الإعفاء من المسئولية (217)', () => {
  const li = (grossFault: 'reserved' | 'covered' | 'unspecified', kind: 'exclusion' | 'cap' = 'exclusion'): ClauseFacts => ({
    liability: { kind, grossFault, beneficiary: 'first', quote: 'لا يسأل الطرف الأول عن أى ضرر' },
  });
  it('إعفاء يشمل الغش والخطأ الجسيم ⇒ حرج', () => {
    const [f] = evaluateRules(li('covered'), { clientParty: 'second' });
    expect(f.status).toBe('review');
    expect(f.severity).toBe('critical');
  });
  it('إعفاء صامت عن الغش ⇒ مراجعة، وعالية إن كان المستفيد الطرف المقابل', () => {
    expect(evaluateRules(li('unspecified'), { clientParty: 'second' })[0].severity).toBe('high');
    expect(evaluateRules(li('unspecified'), { clientParty: 'first' })[0].severity).toBe('medium');
  });
  it('استثناء الغش والخطأ الجسيم أو سقف ⇒ متوافق', () => {
    expect(evaluateRules(li('reserved'), { clientParty: null })[0].status).toBe('compliant');
    expect(evaluateRules(li('unspecified', 'cap'), { clientParty: null })[0].status).toBe('compliant');
  });
});

describe('قاعدة التعويض (221/223/224)', () => {
  const co = (over: Partial<NonNullable<ClauseFacts['compensation']>>): ClauseFacts => ({
    compensation: { method: 'court_assessed', waivesProofOfDamage: false, hasCap: false, payer: 'first', quote: 'بالتعويض عن الأضرار', ...over },
  });
  it('تعويض بتقدير القضاء ⇒ متوافق', () => {
    expect(evaluateRules(co({}), { clientParty: 'second' })[0].status).toBe('compliant');
  });
  it('G9: تقدير أحد الطرفين ⇒ مراجعة (221/223/224)', () => {
    const [f] = evaluateRules(co({ method: 'party_discretion' }), { clientParty: 'second' });
    expect(f.status).toBe('review');
    expect(f.articles).toEqual(expect.arrayContaining([221, 224]));
  });
  it('تعويض اتفاقى بلا إثبات ضرر ⇒ مراجعة عالية (224 باطل)', () => {
    const [f] = evaluateRules(co({ method: 'fixed_amount', waivesProofOfDamage: true }), { clientParty: null });
    expect(f.severity).toBe('high');
    expect(f.articles).toContain(224);
  });
  it('تعويض اتفاقى عادى ⇒ متوافق', () => {
    expect(evaluateRules(co({ method: 'percentage' }), { clientParty: null })[0].status).toBe('compliant');
  });
  it('تعويض غير محدد الطريقة بلا سقف ⇒ مراجعة متوسطة', () => {
    expect(evaluateRules(co({ method: 'unspecified' }), { clientParty: null })[0].severity).toBe('medium');
  });
});

describe('summarizeFindings', () => {
  it('أى مراجعة ⇒ يحتاج مراجعة وأعلى خطورة، والمراجعات أولاً', () => {
    const findings = evaluateRules(
      {
        ...waived,
        liability: { kind: 'exclusion', grossFault: 'covered', beneficiary: 'first', quote: 'لا يسأل الطرف الأول' },
      },
      { clientParty: 'second' },
    );
    const s = summarizeFindings(findings);
    expect(s.status).toBe('يحتاج مراجعة');
    expect(s.risk).toBe('حرج');
    expect(s.reasoning.startsWith('الإعفاء من المسئولية:')).toBe(true);
    expect(s.articles).toContain(217);
  });
  it('كلها متوافقة ⇒ سليم مع تنبيه أن الحكم لا يشمل بقية البند', () => {
    const s = summarizeFindings(evaluateRules(waived, { clientParty: 'second' }));
    expect(s.status).toBe('سليم');
    expect(s.risk).toBeNull();
    expect(s.reasoning).toContain('لا يعنى اعتماد بقية أحكام البند');
  });
});
