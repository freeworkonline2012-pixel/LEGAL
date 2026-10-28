import { hasAnyFact, neutralizeDirections, quoteInText, validateClauseFacts } from './clause-facts';

// نصوص مُصطنَعة بالكامل
const CLAUSE = 'يجوز للطرف الثانى فسخ هذا العقد من جانب واحد إذا أخل الطرف الأول بالتزام جوهرى، وذلك دون حاجة الى إنذار أو تنبيه، مع احتفاظه بحق التعويض.';

describe('quoteInText', () => {
  it('يقبل اقتباساً حرفياً ويتجاوز اختلاف الألف والياء والتشكيل', () => {
    expect(quoteInText('دون حاجة إلى إنذار أو تنبيه', CLAUSE)).toBe(true);
    expect(quoteInText('دون حاجة الى إنذار أو تنبيه', CLAUSE)).toBe(true);
  });
  it('يرفض اقتباساً غير موجود أو قصيراً أو غير نصى', () => {
    expect(quoteInText('بإرادته المنفردة دون قيد', CLAUSE)).toBe(false);
    expect(quoteInText('فسخ', CLAUSE)).toBe(false);
    expect(quoteInText(null, CLAUSE)).toBe(false);
    expect(quoteInText('أ'.repeat(500), CLAUSE)).toBe(false);
  });
});

describe('validateClauseFacts', () => {
  const good = {
    termination: { mechanism: 'unilateral_right', holder: 'second', quote: 'يجوز للطرف الثانى فسخ هذا العقد من جانب واحد' },
    notice: { state: 'waived_explicitly', quote: 'دون حاجة الى إنذار أو تنبيه' },
    compensation: { method: 'court_assessed', waives_proof_of_damage: false, has_cap: false, payer: 'first', quote: 'احتفاظه بحق التعويض' },
  };

  it('يقبل الوقائع السليمة بالمخطط والاقتباس', () => {
    const f = validateClauseFacts(good, CLAUSE);
    expect(f.termination).toMatchObject({ mechanism: 'unilateral_right', holder: 'second' });
    expect(f.notice?.state).toBe('waived_explicitly');
    expect(f.compensation?.method).toBe('court_assessed');
    expect(hasAnyFact(f)).toBe(true);
  });

  it('يُسقط القسم كله إن كان اقتباسه مختلَقاً (لا يُصلح ولا يخمّن)', () => {
    const f = validateClauseFacts({ ...good, notice: { state: 'waived_explicitly', quote: 'ويتنازل الطرفان عن الإعذار نهائياً' } }, CLAUSE);
    expect(f.notice).toBeUndefined();
    expect(f.termination).toBeDefined();
  });

  it('يُسقط القسم إن كانت قيمة خارج المخطط', () => {
    const f = validateClauseFacts({ termination: { ...good.termination, mechanism: 'whenever' } }, CLAUSE);
    expect(f.termination).toBeUndefined();
  });

  it('not_addressed لا يحتاج اقتباساً', () => {
    expect(validateClauseFacts({ notice: { state: 'not_addressed', quote: '' } }, CLAUSE).notice).toEqual({ state: 'not_addressed', quote: '' });
  });

  it('مدخلات غير صالحة تعطى وقائع فارغة', () => {
    for (const bad of [null, undefined, 'x', 5, [], { termination: 'x' }]) {
      expect(hasAnyFact(validateClauseFacts(bad, CLAUSE))).toBe(false);
    }
  });

  it('قيم منطقية غير منطقية تُسقط قسم القوة القاهرة', () => {
    const f = validateClauseFacts(
      { force_majeure: { extra_causes: 'open_ended', counterparty_can_reject: 'yes', notice_required: true, beneficiary: 'first', quote: 'دون حاجة الى إنذار أو تنبيه' } },
      CLAUSE,
    );
    expect(f.forceMajeure).toBeUndefined();
  });
});

describe('neutralizeDirections (الجولة 31)', () => {
  it('first/second تصير unknown، وboth/none تبقى', () => {
    const out = neutralizeDirections({
      termination: { mechanism: 'unilateral_right', holder: 'first', quote: 'يجوز لشركة س فسخ العقد' },
      liability: { kind: 'exclusion', grossFault: 'unspecified', beneficiary: 'both', quote: 'يعفى الطرفان من المسئولية' },
      forceMajeure: { extraCauses: 'listed', counterpartyCanReject: false, noticeRequired: false, beneficiary: 'second', quote: 'القوة القاهرة والحريق' },
      compensation: { method: 'party_discretion', waivesProofOfDamage: false, hasCap: false, payer: 'second', quote: 'بما تراه من تعويضات' },
    });
    expect(out.termination?.holder).toBe('unknown');
    expect(out.liability?.beneficiary).toBe('both');
    expect(out.forceMajeure?.beneficiary).toBe('unknown');
    expect(out.compensation?.payer).toBe('unknown');
  });
  it('لا يغيّر شيئاً آخر ولا يعدّل الأصل', () => {
    const src = { compensation: { method: 'fixed_amount' as const, waivesProofOfDamage: false, hasCap: true, payer: 'first' as const, quote: 'مبلغ 5000 جنيه' } };
    const out = neutralizeDirections(src);
    expect(out.compensation?.method).toBe('fixed_amount');
    expect(src.compensation.payer).toBe('first');
  });
  it('validateClauseFacts يقبل unknown قيمة اتجاه', () => {
    const f = validateClauseFacts(
      { compensation: { method: 'party_discretion', waives_proof_of_damage: false, has_cap: false, payer: 'unknown', quote: 'بما تراه من تعويضات' } },
      'يجوز لشركة أروب الرجوع على بلاك بيلتس بما تراه من تعويضات.',
    );
    expect(f.compensation?.payer).toBe('unknown');
  });
});
