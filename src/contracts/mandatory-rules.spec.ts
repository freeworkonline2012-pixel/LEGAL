import { mandatoryArticleRef, mandatoryRuleHits } from './mandatory-rules';
import { quoteInText } from './clause-facts';

const ids = (t: string): string[] => mandatoryRuleHits(t).map((h) => h.ruleId);

describe('الجولة 90: قواعد المواد الآمرة الحتمية', () => {
  describe('الضمان العشرى (651/653)', () => {
    it('التنازل عن الضمان العشرى + إخلاء المسئولية عن التصدع بعد الاستلام ⇒ decennial_waiver حرج بالمادتين 651 و653', () => {
      const t = 'الضمان: يتسلم رب العمل الأعمال بحالتها، ويخلى المقاول مسئوليته عن أى عيب أو تصدع بعد الاستلام ويتنازل رب العمل عن ضمان المقاول العشرى المقرر قانوناً.';
      const h = mandatoryRuleHits(t);
      expect(h[0].ruleId).toBe('decennial_waiver');
      expect(h[0].severity).toBe('حرج');
      expect(h[0].articles).toEqual([651, 653]);
      expect(quoteInText(h[0].quote, t)).toBe(true);
      expect(h[0].explanation).toContain('653');
    });

    it('استثناء ما وافق عليه رب العمل أو عيب الأرض وبدء المدة من إنجاز الهيكل ⇒ decennial_limit (حدٌّ باطل)', () => {
      const t =
        'يضمن المقاول سلامة المبنى لمدة عشر سنوات من تاريخ إنجاز الهيكل الخرسانى، ولا يسرى هذا الضمان على العيوب الناتجة عن مواد حددها رب العمل أو وافق عليها أو عن عيب فى المخططات المعتمدة منه أو فى تربة الموقع.';
      const h = mandatoryRuleHits(t);
      expect(h.map((x) => x.ruleId)).toContain('decennial_limit');
      expect(h[0].severity).toBe('عالٍ');
    });

    it('تقصير المدة (ضمان سلامة المبنى ثلاث سنوات) ⇒ decennial_limit', () => {
      expect(ids('يضمن المقاول سلامة المبنى والهيكل الإنشائى لمدة ثلاث سنوات من تاريخ التسلم.')).toEqual(['decennial_limit']);
    });

    it('صيغة سليمة (عشر سنوات من التسلم بلا استثناء) وضمان الصيانة سنة واحدة ⇒ لا ملاحظة', () => {
      expect(ids('يضمن المقاول والمهندس متضامنين سلامة المبنى والمنشآت الثابتة لمدة عشر سنوات من وقت تسلم العمل، ويضمن المقاول إصلاح عيوب التشطيب لمدة سنة من الاستلام الابتدائى.')).toEqual([]);
      expect(ids('يحتجز رب العمل 5% ضماناً للصيانة تفرج بعد سنة من الاستلام الابتدائى.')).toEqual([]);
    });
  });

  describe('الفوائد (227/232)', () => {
    it('3% شهرياً (36% سنوياً) مع ضم الفوائد إلى الأصل ⇒ interest_cap + interest_compounding', () => {
      const t = 'الفائدة: يستحق المقرض فائدة بواقع 3% شهرياً (36% سنوياً) على الرصيد، وتضاف الفوائد المستحقة إلى رأس المال كل ثلاثة أشهر وتحسب عليها فائدة.';
      const h = mandatoryRuleHits(t);
      expect(h.map((x) => x.ruleId).sort()).toEqual(['interest_cap', 'interest_compounding']);
      const cap = h.find((x) => x.ruleId === 'interest_cap')!;
      expect(cap.articles).toEqual([227]);
      expect(cap.explanation).toContain('وجب تخفيضها إلى هذا القدر');
      expect(cap.explanation).toContain('المادة 64');
      expect(cap.uncertainReading).toBe(false);
    });

    it('فائدة 7% سنوياً أو أقل ⇒ لا ملاحظة', () => {
      expect(ids('يستحق المقرض فائدة بواقع 7% سنوياً على الرصيد المتناقص.')).toEqual([]);
      expect(ids('يستحق المقرض فائدة بواقع 5.5% سنوياً.')).toEqual([]);
    });

    it('فائدة تأخير 2% شهرياً (24% سنوياً) ⇒ interest_cap', () => {
      expect(ids('إذا تأخر المقترض عن أى قسط التزم بفائدة تأخير 2% شهرياً على القسط المتأخر.')).toContain('interest_cap');
    });

    it('نسبة المصروفات المخصومة ونسبة غرامة السداد المعجل ليستا سعر فائدة', () => {
      expect(ids('مبلغ القرض 2000000 جنيه، يخصم منه عند الصرف 10% مصروفات إدارية، وتحتسب الفائدة على كامل المبلغ بواقع 6% سنوياً.')).toEqual([]);
      expect(ids('إذا رغب المقترض فى السداد المعجل التزم بدفع غرامة قدرها 15% من الرصيد المسدد قبل ميعاده بالإضافة إلى فوائد باقى المدة كاملة.')).toEqual([]);
    });

    it('النسبة التالفة القراءة بعد كلمة الفائدة («9636» ⇒ 36%) تُقرأ مرشحة لا مؤكدة', () => {
      const h = mandatoryRuleHits('الفائدة: يستحق المقرض فائدة بواقع 9636 شهرياً على الرصيد القائم.');
      expect(h[0].ruleId).toBe('interest_cap');
      expect(h[0].uncertainReading).toBe(true);
    });

    it('رقم يبدأ بـ90 لا علاقة له بالفائدة (مبلغ بالجنيه) ⇒ لا ملاحظة', () => {
      expect(ids('يلتزم المقترض بدفع فائدة 5% سنوياً، وبسداد مبلغ 9025 جنيه عند التوقيع.')).toEqual([]);
    });
  });

  describe('التعويض الاتفاقى (224)', () => {
    it('التنازل عن طلب التخفيض أو الاستحقاق دون إثبات ضرر ⇒ penalty_no_reduction', () => {
      expect(ids('يلتزم المورد بغرامة تأخير 1% يومياً، ويتنازل المورد عن حقه فى طلب تخفيض هذه الغرامة أمام أى جهة.')).toEqual(['penalty_no_reduction']);
      expect(ids('تستحق الغرامة دون حاجة إلى إثبات وقوع أى ضرر ولو لم يلحق الطرف الأول ضرر.')).toEqual(['penalty_no_reduction']);
    });

    it('غرامة بسقف بلا منع من التخفيض ⇒ لا ملاحظة', () => {
      expect(ids('يلتزم المورد بغرامة تأخير 0.5% عن كل أسبوع بحد أقصى 5% من قيمة العقد.')).toEqual([]);
    });
  });

  it('نصوص المواد الموثَّقة موجودة للمواد التى تستشهد بها القواعد كلها', () => {
    for (const n of [224, 227, 232, 651, 653]) expect(mandatoryArticleRef(n)?.snippet.length).toBeGreaterThan(40);
    expect(mandatoryArticleRef(1)).toBeNull();
  });
});

describe('الجولة 90: تطبيق القاعدة على البند بعد المدقق', () => {
  const waiver = 'الضمان: يخلى المقاول مسئوليته عن أى عيب أو تصدع بعد الاستلام ويتنازل رب العمل عن ضمان المقاول العشرى المقرر قانوناً.';
  const { mandatoryClausePatch } = jest.requireActual('./mandatory-rules') as typeof import('./mandatory-rules');

  it('ملاحظة دحضها المدقق: تعود «يحتاج مراجعة/حرج» مؤكدة ويُحفظ سبب الدحض، وتُضاف المادتان 651 و653 بنصيهما', () => {
    const patch = mandatoryClausePatch(
      {
        assessmentStatus: 'يحتاج مراجعة',
        riskLevel: 'عالٍ',
        assessmentReasoning: 'ملاحظة النموذج',
        matchedArticles: [],
        verification: { status: 'unconfirmed', basis: 'refuted', refutationKind: 'not_applicable', quote: 'x', reason: 'دحض' },
      },
      mandatoryRuleHits(waiver),
    )!;
    expect(patch.riskLevel).toBe('حرج');
    expect(patch.verification['status']).toBe('confirmed');
    expect(String(patch.verification['reason'])).toContain('دحض المدقق');
    expect(patch.matchedArticles.map((m) => m.article_no)).toEqual([651, 653]);
    expect(patch.assessmentReasoning).not.toContain('ملاحظة النموذج');
  });

  it('بند لم يرصد النموذج فيه شيئاً (سليم/منخفض) يُرفع إلى «يحتاج مراجعة»', () => {
    const patch = mandatoryClausePatch(
      { assessmentStatus: 'متوافق', riskLevel: null, assessmentReasoning: null, matchedArticles: null, verification: null },
      mandatoryRuleHits(waiver),
    )!;
    expect(patch.assessmentStatus).toBe('يحتاج مراجعة');
    expect(patch.riskLevel).toBe('حرج');
  });

  it('لا تُخفَّض درجة أعلى من درجة القاعدة، ويُبقى شرح النموذج ويُلحق به شرح القاعدة', () => {
    const patch = mandatoryClausePatch(
      { assessmentStatus: 'يحتاج مراجعة', riskLevel: 'حرج', assessmentReasoning: 'شرح النموذج', matchedArticles: [], verification: null },
      mandatoryRuleHits('يتحمل المقترض فائدة 3% شهرياً على الرصيد.'),
    )!;
    expect(patch.riskLevel).toBe('حرج');
    expect(patch.assessmentReasoning.startsWith('شرح النموذج')).toBe(true);
    expect(patch.assessmentReasoning).toContain('قاعدة نصية حتمية');
  });

  it('قراءة نسبة تالفة ⇒ تبقى غير مؤكدة بسبب صريح', () => {
    const patch = mandatoryClausePatch(
      { assessmentStatus: null, riskLevel: null, assessmentReasoning: null, matchedArticles: null, verification: null },
      mandatoryRuleHits('يستحق المقرض فائدة بواقع 9636 شهرياً على الرصيد.'),
    )!;
    expect(patch.verification['status']).toBe('unconfirmed');
    expect(patch.verification['basis']).toBe('uncertain');
  });

  it('بلا مخالفة ⇒ null', () => {
    expect(mandatoryClausePatch({ assessmentStatus: null, riskLevel: null, assessmentReasoning: null, matchedArticles: null, verification: null }, [])).toBeNull();
  });
});
