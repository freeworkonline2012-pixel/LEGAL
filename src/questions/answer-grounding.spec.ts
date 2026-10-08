/** نصوص حقيقية من migrations/003_seed_real_laws.sql (قانون العمل 14/2025) — بلا رموز الاستخراج الخاصة. */
export const ART_6 = `يقع باطلا ً كل شرط أو اتفاق يخالف أحكام هذا القانون،ولو كان سابق ًا على العمل به،إذا تضمن انتقاصا من حقوق العامل المقررة فيه،أو إبراء من حقوق العامل الناشئة عن عقد العمل خلال مدة سريانه،أو خلال ثلاثة أشهر من تاريخ انتهائه. ويستمر العمل بأية مزايا أو شروط أفضل تكون مقررة،أو تقرر فى عقود العمل الفردية،أو الجماعية أو الأنظمة الأساسية،أو غيرها من لوائح المنشأة، أو بمقتضى العرف. كما يسرى ذلك فى حالة تغيير الكيان القانونى للمنشأة،أو انتقال ملكيتها.`;

export const ART_87 = `يبرم عقد العمل الفردى لمدة غير محددة،أو لمدة محددة إذا كانت طبيعة العمل تقتضى ذلك كما يجوز باتفاق الطرفين تجديد العقد لمدد أخرى مماثلة.`;

export const ART_88 = `يعتبر عقد العمل غير محدد المدة منذ إبرامه فى الحالات الآتية:
-١ إذا كان غير مكتوب.
-٢ إذا لم ينص العقد على مدته.
-٣ إذا كان مبرما لمدة محددة واستمر الطرفان فى تنفيذه بعد انتهاء هذه المدة دون اتفاق مكتوب بينهما.`;

export const ART_108 = `تؤدى الأجور وغيرها من المبالغ المستحقة للعامل فى أحد أيام العمل وفى مكانه بالعملة المتداولة قانون ًا،أو فى حساب العامل البنكى،مع مراعاة الأحكام التالية:
-١ العمال المعينون بأجر شهرى تؤدى أجورهم مرة على الأقل فى الشهر.
-٢ إذا كان الأجر بالإنتاج أو بالعمولة واستلزم العمل مدة تزيد على أسبوعين، وجب أن يحصل العامل كل أسبوع على دفعة تحت الحساب تتناسب مع ما أتمه من العمل،وأن يؤدى له باقى أجره خلال الأسبوع التالى لتسليم ما كلف به.
-٣ فى غير ما ذكر فى البندين ) (٢، ۱من هذه المادة تؤدى للعمال أجورهم مرة كل أسبوع على الأكثر ما لم يتفق على غير ذلك.
-٤ إذا انتهت علاقة العمل لأى سبب يؤدى صاحب العمل للعامل أجره وجميع المبالغ المستحقة له فى مدة لا تجاوز سبعة أيام من تاريخ مطالبة العامل بهذه المستحقات. وفى جميع الأحوال،يجب ألا يقل ما يحصل عليه العامل عن الحد الأدنى للأجور،ويحظر احتجاز أجر العامل أو جزء منه دون سند قانوني.`;

export const ART_154_REAL = `مع عدم الإخلال بما نصت عليه المواد ) (٩٥، ۸۸، ۸۷من هذا القانون، ينتهى عقد العمل محدد المدة بانقضاء مدته.
فإذا أبرم العقد أو جدد لمدة تزيد على خمس سنوات،جاز للعامل إنهاؤه دون تعويض عند انقضاء خمس سنوات،وذلك بعد إخطار صاحب العمل قبل الإنهاء بثلاثة أشهر. وتسرى أحكام الفقرة الثانية من هذه المادة على حالات إنهاء العامل للعقد بعد انقضاء المدة المذكورة. فإذا كان الإنهاء من جانب صاحب العمل استحق العامل مكافأة تعادل أجر شهر عن كل سنة من سنوات الخدمة.`;

export const ART_157 = `مع عدم الإخلال بحكم المادة ) (٢٣٥من هذا القانون،ومع مراعاة أحكام المواد من ) ١٥٨إلى (١٧٥من هذا القانون،لا يجوز لأصحاب الأعمال والعمال إنهاء عقد العمل غير محدد المدة،إلا بمبرر مشروع وكاف. ويراعى فى جميع الأحوال،أن يتم الإنهاء فى وقت مناسب لظروف العمل.`;


import {
  TEXT_COVERAGE_MIN,
  TEXT_UPGRADE_COVERAGE_MIN,
  claimCoverage,
  contentStems,
  extractArticleNumbers,
  extractQuantities,
  findUnsupportedTerms,
  perYearRates,
} from './answer-grounding';
import { parseStructuredAnswer, referencedProvidedArticles } from './structured-answer';

const ARTS = [
  { text: ART_108, articleNo: 108 },
  { text: ART_154_REAL, articleNo: 154 },
  { text: ART_6, articleNo: 6 },
  { text: ART_87, articleNo: 87 },
  { text: ART_88, articleNo: 88 },
  { text: ART_157, articleNo: 157 },
];

describe('claimCoverage (وسم نص/تفسير حتمى)', () => {
  const quote154 = 'ينتهى عقد العمل محدد المدة بانقضاء مدته';

  it('حكم يطابق مقتطفه يغطيه كلياً', () => {
    expect(claimCoverage('ينتهى عقد العمل محدد المدة بانقضاء مدته.', quote154)).toBeGreaterThanOrEqual(
      TEXT_UPGRADE_COVERAGE_MIN,
    );
  });

  it('إعادة صياغة موجزة بنفس الكلمات المضمونية تبقى مغطاة (تصريف ال/و/ب لا يؤثر)', () => {
    expect(claimCoverage('عقد العمل المحدد المدة ينتهي بانقضاء المدة', quote154)).toBeGreaterThanOrEqual(
      TEXT_COVERAGE_MIN,
    );
  });

  it('حكم يضيف ما لا يغطيه المقتطف الظاهر (حالة م154: التجديد) يهبط تحت العتبة', () => {
    const claim = 'ينتهى عقد العمل محدد المدة بانقضاء مدته ويجوز تجديده لمدد أخرى مماثلة باتفاق الطرفين';
    expect(claimCoverage(claim, quote154)).toBeLessThan(TEXT_COVERAGE_MIN);
  });

  it('النفى جزء من المضمون: حكم "لا يستحق" لا يغطيه مقتطف "يستحق"', () => {
    expect(claimCoverage('لا يستحق العامل مكافأة', 'يستحق العامل مكافأة')).toBeLessThan(1);
    expect(contentStems('لا يستحق العامل مكافأة')).toContain('لا');
  });

  it('حكم بلا كلمات مضمونية أو بلا مقتطف = تغطية صفر', () => {
    expect(claimCoverage('من في على', quote154)).toBe(0);
    expect(claimCoverage('حكم ما', '')).toBe(0);
  });
});

describe('extractQuantities', () => {
  it('أعداد بالحروف والأرقام والمثنى والمركَّب', () => {
    expect(extractQuantities('خلال سبعة أيام من تاريخ المطالبة')).toEqual([{ n: 7, unit: 'يوم' }]);
    expect(extractQuantities('خلال ثلاثة أشهر')).toEqual([{ n: 3, unit: 'شهر' }]);
    expect(extractQuantities('مدة تزيد على خمس سنوات')).toEqual([{ n: 5, unit: 'سنه' }]);
    expect(extractQuantities('إخطار قبل شهرين')).toEqual([{ n: 2, unit: 'شهر' }]);
    expect(extractQuantities('مهلة 30 يوما')).toEqual([{ n: 30, unit: 'يوم' }]);
    expect(extractQuantities('خلال خمسة عشر يوماً')).toEqual([{ n: 15, unit: 'يوم' }]);
  });

  it('رقم مادة أو عدد بلا وحدة زمنية ليس مقداراً، و"أجر شهر" بلا عدد ليس مقداراً', () => {
    expect(extractQuantities('المادة 88 من هذا القانون')).toEqual([]);
    expect(extractQuantities('مكافأة تعادل أجر شهر عن كل سنة')).toEqual([]);
  });
});

describe('extractArticleNumbers', () => {
  it('يقرأ صيغ الإحالة المختلفة', () => {
    expect(extractArticleNumbers('ميعاد الوفاء سبعة أيام (المادة 108).')).toEqual([108]);
    expect(extractArticleNumbers('بحسب المواد 87 و88')).toEqual([87, 88]);
    expect(extractArticleNumbers('وفق م 125')).toEqual([125]);
    expect(extractArticleNumbers('(المادة ١٥٦)')).toEqual([156]);
  });
  it('لا يلتقط حرف م داخل كلمة', () => {
    expect(extractArticleNumbers('حكم 5 سنوات')).toEqual([]);
  });
});

describe('findUnsupportedTerms على نصوص قانون العمل 14/2025 الحقيقية', () => {
  it('خطأ التقييم: "يسقطان" منسوباً للمادة 108 لا أصل له فى نصها', () => {
    const w = 'الأجر ومقابل الإجازة يسقطان إن لم يطالب بهما العامل خلال المدة المقررة (المادة 108).';
    expect(findUnsupportedTerms(w, [ART_108])).toContain('أثر:سقوط');
  });

  it('الصياغة الصحيحة لنص 108 (ميعاد وفاء سبعة أيام من المطالبة) مؤصَّلة', () => {
    const w = 'يلتزم صاحب العمل بصرف الأجر وجميع المستحقات خلال سبعة أيام من تاريخ مطالبة العامل (المادة 108).';
    expect(findUnsupportedTerms(w, [ART_108])).toEqual([]);
  });

  it('مدة غير واردة فى المادة تُرصَد (ثلاثون يوماً بدل سبعة)', () => {
    const w = 'تُصرف المستحقات خلال ثلاثين يوماً من المطالبة (المادة 108).';
    expect(findUnsupportedTerms(w, [ART_108])).toEqual(['مقدار:30 يوم']);
  });

  it('المادة 6: البطلان وثلاثة أشهر مؤصَّلان، وسنتان غير مؤصَّلتين', () => {
    expect(
      findUnsupportedTerms('يقع باطلاً أى إبراء من الحقوق يوقّعه العامل خلال ثلاثة أشهر من انتهاء العقد (المادة 6).', [ART_6]),
    ).toEqual([]);
    expect(findUnsupportedTerms('يبطل الإبراء خلال سنتين من انتهاء العقد (المادة 6).', [ART_6])).toEqual([
      'مقدار:2 سنه',
    ]);
  });

  it('المادة 154: خمس سنوات مؤصَّلة، وبطلان/سقوط غير مؤصَّلين', () => {
    expect(findUnsupportedTerms('مدة تزيد على خمس سنوات تُنشئ استحقاق مكافأة', [ART_154_REAL])).toEqual([]);
    expect(findUnsupportedTerms('يسقط حق العامل فى المكافأة', [ART_154_REAL])).toEqual(['أثر:سقوط']);
  });

  it('الأثر يُقبل إذا ورد فى أى من النصوص المستند إليها', () => {
    expect(findUnsupportedTerms('يقع باطلاً الإبراء', [ART_108, ART_6])).toEqual([]);
  });
});

describe('parseStructuredAnswer — فحص التأصيل والوسم الحتمى والسيناريوهات', () => {
  const direct = 'جواب مباشر مفصل كفاية للاختبار.';
  const mk = (extra: Record<string, unknown>) =>
    JSON.stringify({ direct_answer: direct, rulings: [{ claim: 'حكم موجز واحد هنا.', kind: 'تفسير', source: 1 }], ...extra });

  it('يُسقط تحذير "يسقطان" المنسوب للمادة 108 ويُحصيه، ويُبقى تحذيراً مؤصَّلاً', () => {
    const r = parseStructuredAnswer(
      mk({
        warnings: [
          'الأجر ومقابل الإجازة يسقطان إن لم يطالب بهما العامل (المادة 108).',
          'يلتزم صاحب العمل بالوفاء خلال سبعة أيام من تاريخ المطالبة (المادة 108).',
        ],
      }),
      ARTS,
    );
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.warnings).toEqual(['يلتزم صاحب العمل بالوفاء خلال سبعة أيام من تاريخ المطالبة (المادة 108).']);
    expect(r.stats.guard_dropped.warnings).toBe(1);
    expect(r.stats.guard_details.join('|')).toContain('أثر:سقوط');
  });

  it('يُسقط تحذيراً يشير لمادة غير مرسَلة (لا يمكن فحص تأصيله)', () => {
    const r = parseStructuredAnswer(mk({ warnings: ['مهلة قصيرة جداً للمطالبة (المادة 999).'] }), ARTS);
    expect(r.ok && r.value.warnings).toEqual([]);
    expect(r.ok && r.stats.guard_dropped.warnings).toBe(1);
  });

  it('بلا أرقام مواد فى بيانات المواد (استدعاء قديم) يُفحَص على اتحاد النصوص', () => {
    const r = parseStructuredAnswer(mk({ warnings: ['يقع باطلاً الإبراء (المادة 6).'] }), [{ text: ART_6 }]);
    expect(r.ok && r.value.warnings).toHaveLength(1);
  });

  it('يُسقط حكماً فيه أثر أو مدة لا أصل لهما فى مادته', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({
        direct_answer: direct,
        rulings: [
          { claim: 'يسقط حق العامل فى الأجر إن لم يطالب به.', kind: 'تفسير', source: 1 },
          { claim: 'يلتزم صاحب العمل بالوفاء خلال سبعة أيام من المطالبة.', kind: 'تفسير', source: 1 },
        ],
      }),
      ARTS,
    );
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.rulings).toHaveLength(1);
    expect(r.value.rulings[0].claim).toContain('سبعة أيام');
    expect(r.stats.guard_dropped.rulings).toBe(1);
  });

  it('مفتاح الإيقاف guard:false يُبقى الأحكام والتحذيرات كما كانت', () => {
    const r = parseStructuredAnswer(
      mk({ warnings: ['الأجر يسقط إن لم يطالب به (المادة 108).'] }),
      ARTS,
      { guard: false },
    );
    expect(r.ok && r.value.warnings).toHaveLength(1);
  });

  it('وسم "نص" لا يثبت إذا لم يغطِّ المقتطف الظاهر كل ما يقرره الحكم (م154: التجديد)', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({
        direct_answer: direct,
        rulings: [
          {
            claim: 'ينتهى عقد العمل محدد المدة بانقضاء مدته ويجوز تجديده لمدد أخرى مماثلة باتفاق الطرفين.',
            kind: 'نص',
            source: 2,
            quote: 'ينتهى عقد العمل محدد المدة بانقضاء مدته',
          },
        ],
      }),
      ARTS,
    );
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.rulings[0].kind).toBe('تفسير');
    expect(r.value.rulings[0].quote_verified).toBe(true);
    expect(r.stats.coverage_downgraded).toBe(1);
  });

  it('حكم وسمه النموذج "تفسير" لكنه يطابق مقتطفه الموثَّق يُرفَع إلى "نص"', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({
        direct_answer: direct,
        rulings: [
          {
            claim: 'ينتهى عقد العمل محدد المدة بانقضاء مدته.',
            kind: 'تفسير',
            source: 2,
            quote: 'ينتهى عقد العمل محدد المدة بانقضاء مدته',
          },
        ],
      }),
      ARTS,
    );
    expect(r.ok && r.value.rulings[0].kind).toBe('نص');
    expect(r.ok && r.stats.coverage_upgraded).toBe(1);
  });

  it('سيناريوهات تطبيقية: تُقبَل المؤصَّلة، وتُسقَط ذات المقدار غير الوارد أو المصدر الفاسد، وتُحَدّ بستة', () => {
    const r = parseStructuredAnswer(
      mk({
        scenarios: [
          { condition: 'إذا كانت مدة الخدمة أقل من خمس سنوات', outcome: 'ينتهى العقد بانقضاء مدته دون مكافأة المادة 154', source: 2 },
          { condition: 'إذا كانت مدة الخدمة أكثر من عشر سنوات', outcome: 'تستحق مكافأة مضاعفة', source: 2 },
          { condition: 'شرط بلا مصدر صالح هنا', outcome: 'نتيجة بلا مصدر صالح هنا', source: 99 },
          { condition: 'قصير', outcome: 'x', source: 2 },
          ...Array.from({ length: 6 }, (_, i) => ({ condition: `إذا تحقق الاحتمال رقم ${i} فى الحالة`, outcome: `ينتهى العقد بانقضاء مدته ${i}`, source: 2 })),
        ],
      }),
      ARTS,
    );
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.scenarios.length).toBe(6);
    expect(r.value.scenarios[0]).toMatchObject({ citation_index: 1, condition: 'كانت مدة الخدمة أقل من خمس سنوات' });
    expect(r.value.scenarios.map((s) => s.condition)).not.toContain('كانت مدة الخدمة أكثر من عشر سنوات');
    expect(r.stats.guard_dropped.scenarios).toBe(1);
  });

  it('غياب scenarios يعطى مصفوفة فارغة (توافق مع المخرجات القديمة)', () => {
    const r = parseStructuredAnswer(mk({}), ARTS);
    expect(r.ok && r.value.scenarios).toEqual([]);
  });
});

describe('referencedProvidedArticles', () => {
  it('87 و88 مُحال إليهما فى نص م154 الحقيقى ومرفقتان؛ 95 غير مرفقة فلا تُذكَر', () => {
    const list = referencedProvidedArticles([
      { articleNo: 154, text: ART_154_REAL },
      { articleNo: 87, text: ART_87 },
      { articleNo: 88, text: ART_88 },
    ]);
    expect(list).toEqual([87, 88]);
  });
  it('مادة لا تُحال إليها غيرها لا تدخل القائمة', () => {
    expect(referencedProvidedArticles([{ articleNo: 108, text: ART_108 }, { articleNo: 6, text: ART_6 }])).toEqual([]);
  });
});

describe('findUnsupportedTerms — وقائع السائل (quantitySupport)', () => {
  const ART = 'يستحق العامل مكافأة عن مدة خدمته إذا أنهى صاحب العمل العقد.';
  it('مقدار ذكره السائل يُقبل، ويُرفض بدونه', () => {
    expect(findUnsupportedTerms('تستحق المكافأة بعد خدمة عشر سنوات', [ART])).toEqual([expect.stringContaining('مقدار:10')]);
    expect(findUnsupportedTerms('تستحق المكافأة بعد خدمة عشر سنوات', [ART], '- كم مدة الخدمة؟ ← عشر سنوات')).toEqual([]);
  });
  it('الأثر الشديد لا يُقبل من وقائع السائل أبداً', () => {
    expect(findUnsupportedTerms('يسقط حقك بالتقادم', [ART], '- كم مدة الخدمة؟ ← عشر سنوات')).toEqual(
      expect.arrayContaining([expect.stringContaining('أثر:')]),
    );
  });
});

describe('findUnsupportedTerms — مقادير مشتقة (معدل «عن كل سنة» × سنوات السائل)', () => {
  const ART_165 = 'يستحق العامل تعويضاً لا يقل عن أجر شهرين عن كل سنة من سنوات الخدمة إذا أنهى صاحب العمل العقد لسبب غير مشروع.';
  const ART_154 = 'استحق العامل مكافأة تعادل أجر شهر عن كل سنة من سنوات الخدمة.';
  it('perYearRates تستخرج المعدل من نص المادة (شهرين = 2 شهر، شهر = 1)', () => {
    expect(perYearRates(ART_165)).toEqual([{ n: 2, unit: 'شهر' }]);
    expect(perYearRates(ART_154)).toEqual([{ n: 1, unit: 'شهر' }]);
    expect(perYearRates('يستحق مكافأة عن مدة خدمته')).toEqual([]);
  });
  it('الحاصل (12 سنة × شهرين = 24 شهراً) مؤصَّل بوجود سنوات السائل، وغير مؤصَّل بدونها', () => {
    const facts = '- كم مدة الخدمة؟ ← 12 سنوات';
    expect(findUnsupportedTerms('تعويض لا يقل عن 24 شهراً من الأجر', [ART_165], facts)).toEqual([]);
    expect(findUnsupportedTerms('تعويض لا يقل عن 24 شهراً من الأجر', [ART_165])).not.toEqual([]);
  });
  it('حاصل خاطئ (30 شهراً) أو بلا معدل فى المادة يُرفض', () => {
    const facts = '- كم مدة الخدمة؟ ← 12 سنوات';
    expect(findUnsupportedTerms('تعويض 30 شهراً من الأجر', [ART_165], facts)).not.toEqual([]);
    expect(findUnsupportedTerms('تعويض 24 شهراً من الأجر', ['يستحق العامل تعويضاً.'], facts)).not.toEqual([]);
  });
  it('الأثر الشديد لا يُشتق أبداً مهما كانت الوقائع', () => {
    expect(findUnsupportedTerms('يسقط حقك بعد 24 شهراً', [ART_165], '- مدة الخدمة ← 12 سنوات')).not.toEqual([]);
  });
});
