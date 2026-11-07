import { claimKindFromRisk, needsVerification, pickContributionContext, pickForVerification, validateVerdict } from './verification';

const CLAUSE = 'يجوز للطرف الثانى فسخ العقد دون حاجة إلى إنذار أو تنبيه إذا أخل الطرف الأول بالتزام جوهرى.';
const ART = 'يجوز الاتفاق على أن يعتبر العقد مفسوخاً من تلقاء نفسه دون حكم قضائى عند عدم الوفاء بالالتزامات.';

describe('validateVerdict', () => {
  it('confirmed ⇒ مؤكدة بلا اقتباس', () => {
    const v = validateVerdict({ verdict: 'confirmed', reason: 'لم أجد ما ينقض الملاحظة.' }, CLAUSE, [ART]);
    expect(v).toMatchObject({ status: 'confirmed', basis: 'confirmed', quote: null });
  });

  it('refuted باقتباس حرفى من البند ⇒ غير مؤكدة بأساس refuted', () => {
    const v = validateVerdict({ verdict: 'refuted', counter_quote: 'دون حاجة إلى إنذار أو تنبيه', reason: 'البند يعفى صراحة من الإنذار.' }, CLAUSE, [ART]);
    expect(v).toMatchObject({ status: 'unconfirmed', basis: 'refuted', quoteSource: 'clause', quote: 'دون حاجة إلى إنذار أو تنبيه' });
  });

  it('refuted باقتباس حرفى من المادة المعروضة ⇒ مصدره article', () => {
    const v = validateVerdict({ verdict: 'refuted', article_quote: 'يجوز الاتفاق على أن يعتبر العقد مفسوخاً من تلقاء نفسه', reason: 'المادة مكملة.' }, CLAUSE, [ART]);
    expect(v).toMatchObject({ status: 'unconfirmed', basis: 'refuted', quoteSource: 'article' });
  });

  it('refuted باقتباس مخترع أو بلا اقتباس ⇒ لا يُعتد بالاعتراض (uncertain) مع التنبيه', () => {
    const fake = validateVerdict({ verdict: 'refuted', counter_quote: 'عبارة لا وجود لها فى البند أبداً', reason: 'سبب.' }, CLAUSE, [ART]);
    expect(fake).toMatchObject({ status: 'unconfirmed', basis: 'uncertain', quote: null });
    expect(fake?.reason).toContain('دون اقتباس موثَّق');
    expect(validateVerdict({ verdict: 'refuted', reason: 'سبب.' }, CLAUSE, [ART])?.basis).toBe('uncertain');
  });

  it('uncertain ⇒ غير مؤكدة، ورد غير صالح ⇒ null', () => {
    expect(validateVerdict({ verdict: 'uncertain', reason: 'تعذر الجزم.' }, CLAUSE, [])).toMatchObject({ status: 'unconfirmed', basis: 'uncertain' });
    expect(validateVerdict({ verdict: 'maybe', reason: 'x يكفى' }, CLAUSE, [])).toBeNull();
    expect(validateVerdict({ verdict: 'confirmed' }, CLAUSE, [])).toBeNull();
    expect(validateVerdict(null, CLAUSE, [])).toBeNull();
  });
});

describe('needsVerification / pickForVerification', () => {
  const base = { assessmentStatus: 'يحتاج مراجعة', riskLevel: 'عالٍ', matchedArticles: [{}], ruleFindings: null };
  it('يخص تقييم النموذج فقط: لا للقواعد الحتمية ولا للسليم ولا لبلا مواد ولا للمنخفض', () => {
    expect(needsVerification(base)).toBe(true);
    expect(needsVerification({ ...base, ruleFindings: [{}] })).toBe(false);
    expect(needsVerification({ ...base, assessmentStatus: 'سليم' })).toBe(false);
    expect(needsVerification({ ...base, matchedArticles: [] })).toBe(false);
    expect(needsVerification({ ...base, riskLevel: null })).toBe(false);
  });
  it('يقدّم الأخطر ويقتصر على 12', () => {
    const list = Array.from({ length: 20 }, (_, i) => ({ clauseIndex: i + 1, riskLevel: i === 19 ? 'حرج' : 'متوسط' }));
    const picked = pickForVerification(list);
    expect(picked).toHaveLength(12);
    expect(picked[0].clauseIndex).toBe(20);
  });
});

describe('claimKindFromRisk (الجولة 57)', () => {
  it('حرج/عالٍ ⇒ mandatory، ومتوسط أو غيره ⇒ deviation', () => {
    expect(claimKindFromRisk('حرج')).toBe('mandatory');
    expect(claimKindFromRisk('عالٍ')).toBe('mandatory');
    expect(claimKindFromRisk('متوسط')).toBe('deviation');
    expect(claimKindFromRisk(null)).toBe('deviation');
  });
});

describe('إعادة التصنيف (الجولة 58)', () => {
  const ok = {
    verdict: 'refuted',
    refutation_kind: 'not_mandatory',
    deviates_against_client: true,
    deviation_quote: 'دون حاجة إلى إنذار أو تنبيه',
    article_quote: 'يجوز الاتفاق على أن يعتبر العقد مفسوخاً من تلقاء نفسه',
    reason: 'المادة مكملة.',
  };
  it('مادة مكملة + خروج عن الأصل ضد العميل + اقتباسان حرفيان ⇒ مؤكد كاختلال (reclassified)', () => {
    const v = validateVerdict(ok, CLAUSE, [ART]);
    expect(v).toMatchObject({ status: 'confirmed', basis: 'reclassified', reclassified: 'deviation', quoteSource: 'clause', quote: 'دون حاجة إلى إنذار أو تنبيه' });
  });
  it('بلا اقتباس البند أو باقتباس مخترع ⇒ تبقى غير مؤكدة', () => {
    expect(validateVerdict({ ...ok, deviation_quote: undefined }, CLAUSE, [ART])).toMatchObject({ status: 'unconfirmed' });
    expect(validateVerdict({ ...ok, deviation_quote: 'عبارة لا وجود لها فى البند' }, CLAUSE, [ART])).toMatchObject({ status: 'unconfirmed' });
  });
  it('اقتباس المادة غير حرفى أو deviates=false أو نوع الاعتراض غير not_mandatory ⇒ لا إعادة تصنيف', () => {
    expect(validateVerdict({ ...ok, article_quote: 'نص غير موجود فى المادة' }, CLAUSE, [ART])?.status).toBe('unconfirmed');
    expect(validateVerdict({ ...ok, deviates_against_client: false }, CLAUSE, [ART])?.status).toBe('unconfirmed');
    expect(validateVerdict({ ...ok, refutation_kind: 'clause_addresses' }, CLAUSE, [ART])?.status).toBe('unconfirmed');
  });
  it('يُسجَّل نوع الاعتراض ويُطبَّع المجهول إلى other', () => {
    const v = validateVerdict({ verdict: 'refuted', refutation_kind: 'xx', counter_quote: 'دون حاجة إلى إنذار أو تنبيه', reason: 'سبب.' }, CLAUSE, [ART]);
    expect(v).toMatchObject({ basis: 'refuted', refutationKind: 'other' });
  });
});

describe('سياق الحصص لبند الأرباح (الجولة 58)', () => {
  const clauses = [
    { clauseIndex: 1, clauseLabel: 'البند 1', clauseText: 'يقدم الشريك الأول حصة نقدية قدرها مائة ألف جنيه تمثل رأس المال، ويقدم الشريك الثانى عمله فقط.', matchedArticles: [] },
    { clauseIndex: 2, clauseLabel: 'البند 2', clauseText: 'يستحق الشريك الثانى كامل الأرباح ويتحمل الشريك الأول وحده الخسائر.', matchedArticles: [{ article_no: 515 }] },
    { clauseIndex: 3, clauseLabel: 'البند 3', clauseText: 'مدة الشركة خمس سنوات.', matchedArticles: [] },
  ];
  it('بند أرباح/خسائر ⇒ يُعرض بند رأس المال والحصص سياقاً', () => {
    const ctx = pickContributionContext(clauses[1], clauses);
    expect(ctx).toHaveLength(1);
    expect(ctx[0].clauseLabel).toBe('البند 1');
  });
  it('بند آخر غير الأرباح ⇒ لا سياق', () => {
    expect(pickContributionContext(clauses[2], clauses)).toEqual([]);
  });
  it('الدحض باقتباس حرفى من بند السياق مقبول، ومن خارجه لا', () => {
    const own = clauses[1].clauseText;
    const rel = [clauses[0].clauseText];
    const q = 'ويقدم الشريك الثانى عمله فقط';
    expect(validateVerdict({ verdict: 'refuted', counter_quote: q, reason: 'الشريك الثانى بالعمل فقط.' }, own, [], new Date(), rel)).toMatchObject({ basis: 'refuted', quoteSource: 'clause' });
    expect(validateVerdict({ verdict: 'refuted', counter_quote: q, reason: 'الشريك الثانى بالعمل فقط.' }, own, [])?.basis).toBe('uncertain');
  });
});

describe('الجولة 60: isDismissedVerification', () => {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  const { isDismissedVerification, validateVerdict } = require('./verification') as typeof import('./verification');
  const clauseText = 'يتم تحويل اجمالى المبالغ المحصلة اسبوعيا الى الحساب البنكى للطرف الثانى';
  it('دحض باقتباس موثَّق وسبب محدد = مستبعدة؛ بلا اقتباس أو بسبب «other» أو متأكدة = لا', () => {
    const ok = validateVerdict({ verdict: 'refuted', reason: 'لا تعارض بين البندين', refutation_kind: 'clause_addresses', counter_quote: 'اجمالى المبالغ المحصلة اسبوعيا' }, clauseText, []);
    expect(isDismissedVerification(ok)).toBe(true);
    const other = validateVerdict({ verdict: 'refuted', reason: 'لا تعارض بين البندين', refutation_kind: 'other', counter_quote: 'اجمالى المبالغ المحصلة اسبوعيا' }, clauseText, []);
    expect(isDismissedVerification(other)).toBe(false);
    const noQuote = validateVerdict({ verdict: 'refuted', reason: 'لا تعارض بين البندين', refutation_kind: 'clause_addresses', counter_quote: 'عبارة غير موجودة فى النص إطلاقاً' }, clauseText, []);
    expect(noQuote?.basis).toBe('uncertain');
    expect(isDismissedVerification(noQuote)).toBe(false);
    const confirmed = validateVerdict({ verdict: 'confirmed', reason: 'صحيحة' }, clauseText, []);
    expect(isDismissedVerification(confirmed)).toBe(false);
    expect(isDismissedVerification(null)).toBe(false);
  });
});
