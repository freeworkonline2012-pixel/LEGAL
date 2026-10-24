import { needsVerification, pickForVerification, validateVerdict } from './verification';

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
