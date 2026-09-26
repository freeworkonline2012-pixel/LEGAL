import {
  REFUSAL_THRESHOLD,
  MAX_CROSS_REFERENCE_ARTICLES,
  END_OF_RELATIONSHIP_BUNDLE_ARTICLES,
  INDEFINITE_TERMINATION_BUNDLE_ARTICLES,
  buildFtsQuery,
  confidenceFromRank,
  detectArticleReference,
  detectCrossReferencedArticles,
  isConfident,
  isEndOfRelationshipTopic,
  isIndefiniteContractTerminationTopic,
  toCitationStatus,
} from './retrieval';

/**
 * أول ملف اختبارات وحدة (Unit Tests) فى المشروع — يغطي retrieval.ts، أدوات
 * الاسترجاع النقية (pure functions) التي يعتمد عليها خط FTS/عتبة الرفض
 * بالكامل (EP-06، EP-10). اختيرت هذه الدوال أولاً لأنها:
 *   (أ) بلا أي تبعية خارجية (لا قاعدة بيانات، لا شبكة) — اختبارها رخيص وموثوق
 *       تماماً، بلا أي mocking.
 *   (ب) منطق حرج فعلياً أثبتت الحوادث السابقة (EP-06: صفر تطابق لكل الأسئلة
 *       بسبب plainto_tsquery؛ EP-10: تسريب حالة "in_force" الخاطئة لعمود
 *       citations.status) أن أي خطأ صامت فيها يُسقط النظام بالكامل دون أي
 *       رسالة خطأ واضحة فى وقت التشغيل.
 * لا تُغطى هنا الدوال المعتمدة على DataSource/fetch الحقيقي (fts/semantic
 * Retrieval، rerank، selectBestCandidate) — تلك تحتاج اختبارات تكامل/e2e
 * منفصلة (mocking لـ TypeORM وVoyage/DeepSeek)، خارج نطاق هذه الدفعة الأولى.
 */

describe('toCitationStatus', () => {
  it('يحوّل in_force إلى active (تجنّباً لكسر قيد CHECK فى citations.status)', () => {
    expect(toCitationStatus('in_force')).toBe('active');
  });

  it('يُبقي amended كما هى', () => {
    expect(toCitationStatus('amended')).toBe('amended');
  });

  it('يُبقي repealed كما هى', () => {
    expect(toCitationStatus('repealed')).toBe('repealed');
  });
});

describe('detectArticleReference', () => {
  it('يستخرج رقم مادة من صيغة "مادة 110"', () => {
    expect(detectArticleReference('اشرح لي مادة 110')).toEqual({ articleNo: 110 });
  });

  it('يستخرج رقم مادة من صيغة "المادة 224"', () => {
    expect(detectArticleReference('ما نص المادة 224؟')).toEqual({ articleNo: 224 });
  });

  it('يدعم الأرقام العربية-الهندية ("ماده ١١٠")', () => {
    expect(detectArticleReference('ماده ١١٠ عايز اعرف نصها')).toEqual({ articleNo: 110 });
  });

  it('يستخرج رقم القانون والسنة معاً من "مادة 110 من قانون 12 لسنة 2003"', () => {
    expect(detectArticleReference('مادة 110 من قانون 12 لسنة 2003')).toEqual({
      articleNo: 110,
      lawNo: 12,
      lawYear: 2003,
    });
  });

  it('يدعم "قانون رقم 14" (بصيغة "رقم" الصريحة) قبل "قانون 14" العامة', () => {
    expect(detectArticleReference('مادة 5 من قانون رقم 14 لسنة 2025')).toEqual({
      articleNo: 5,
      lawNo: 14,
      lawYear: 2025,
    });
  });

  it('يدعم "قانون 14" بلا كلمة "رقم"', () => {
    expect(detectArticleReference('مادة 5 من قانون 14')).toEqual({
      articleNo: 5,
      lawNo: 14,
    });
  });

  it('يدعم "سنة" بلا "لـ" البادئة، وكذلك "سنه"/"لسنه" (تطبيع التاء المربوطة)', () => {
    expect(detectArticleReference('مادة 1 سنة 2024')).toEqual({ articleNo: 1, lawYear: 2024 });
    expect(detectArticleReference('مادة 1 لسنه 2024')).toEqual({ articleNo: 1, lawYear: 2024 });
  });

  it('يُرجع articleNo فقط بلا lawNo/lawYear لو السؤال بلا ذكر قانون صراحة', () => {
    expect(detectArticleReference('وضّح مادة 7')).toEqual({ articleNo: 7 });
  });

  it('يُرجع null لو لا توجد إشارة صريحة لرقم مادة إطلاقاً', () => {
    expect(detectArticleReference('ما هى حقوق العامل عند الفصل؟')).toBeNull();
  });

  it('يُرجع null لمادة رقمها صفر (articleNo <= 0 غير صالح)', () => {
    expect(detectArticleReference('مادة 0')).toBeNull();
  });

  it('لا يتأثر بحالة الأحرف أو التطبيع (الألف المقصورة/الهمزات)', () => {
    // "المادة" هنا تبدأ بألف عادية أصلاً — نتأكد أن التطبيع لا يكسر المطابقة
    // حتى مع وجود همزة قبلها فى سياق الجملة.
    expect(detectArticleReference('إيه رأيك فى المادة 42؟')).toEqual({ articleNo: 42 });
  });
});

describe('buildFtsQuery', () => {
  it('يبني استعلام OR مفصولاً بـ | من توكينز السؤال', () => {
    const result = buildFtsQuery('ما هو الأجر الأساسي');
    // كل توكن (طوله > 1) مقتبس بـ'...'، مفصول بـ' | '، ترتيب الظهور كما ورد.
    expect(result).toBe("'ما' | 'هو' | 'الاجر' | 'الاساسي'");
  });

  it('يستبعد التوكينز أحادية الحرف (طول <= 1)', () => {
    const result = buildFtsQuery('ب س الأجر');
    expect(result).toBe("'الاجر'");
  });

  it('يزيل علامات الترقيم الملتصقة بالتوكن (؟ ، .)', () => {
    const result = buildFtsQuery('الأجر؟ الأساسي، اليوم.');
    expect(result).toBe("'الاجر' | 'الاساسي' | 'اليوم'");
  });

  it('يحوّل الأرقام العربية-الهندية ويحتفظ بها كأرقام لاتينية داخل التوكن', () => {
    const result = buildFtsQuery('مادة ١١٠');
    expect(result).toBe("'ماده' | '110'");
  });

  it('يحدّ عدد التوكينز بـ8 كحد أقصى', () => {
    const result = buildFtsQuery('واحد اثنين ثلاثة اربعة خمسة سته سبعه ثمانيه تسعه عشره');
    expect(result.split(' | ')).toHaveLength(8);
  });

  it('يُرجع نص فارغاً لو كل التوكينز أحادية الحرف أو فُلترت بالكامل', () => {
    expect(buildFtsQuery('؟ . ,')).toBe('');
  });

  it('يهرب علامة اقتباس مفردة داخل التوكن (احتياطياً — نادر فى العربية لكن أمان استعلام SQL)', () => {
    // toEnglishDigits/normalizeArabic لا يزيلان الأحرف اللاتينية، والفلتر
    // [^ء-ي0-9] يستبعد أي حرف لاتيني أو رمز أصلاً، فلا يمكن عملياً لعلامة ' أن
    // تصل لجسم التوكن — نتحقق من هذا السلوك الفعلي بدل افتراضه.
    const result = buildFtsQuery("a'b عربي");
    expect(result).toBe("'عربي'");
  });
});

describe('confidenceFromRank', () => {
  it('يُمرِّر قيمة عادية ضمن [0,1] كما هى', () => {
    expect(confidenceFromRank(0.55)).toBe(0.55);
  });

  it('يقصّ القيم الأكبر من 1 إلى 1', () => {
    expect(confidenceFromRank(1.4)).toBe(1);
  });

  it('يقصّ القيم السالبة إلى 0', () => {
    expect(confidenceFromRank(-0.3)).toBe(0);
  });

  it('يُرجع 0 لقيمة NaN', () => {
    expect(confidenceFromRank(NaN)).toBe(0);
  });

  it('يُرجع 0 لقيمة Infinity (موجبة أو سالبة)', () => {
    expect(confidenceFromRank(Infinity)).toBe(0);
    expect(confidenceFromRank(-Infinity)).toBe(0);
  });
});

describe('detectCrossReferencedArticles', () => {
  it('يستخرج قائمة أرقام من صيغة "المواد (87، 88، 95)" — حالة المادة 154 الحقيقية', () => {
    const body =
      'مع عدم الإخلال بما نصت عليه المواد (87، 88، 95) من هذا القانون، ينتهى عقد العمل محدد المدة بانقضاء مدته.';
    expect(detectCrossReferencedArticles(body)).toEqual([87, 88, 95]);
  });

  it(
    'يستخرج نفس القائمة من النص الحقيقى المُخزَّن فعلياً فى قاعدة البيانات لهذه المادة ' +
      '(أقواس معكوسة الترتيب ") (" — عطل استخراج نص حقيقى مؤكَّد بفحص مباشر 2026-09-24، لا افتراضى) ' +
      'وبأرقام هندية/فارسية مختلطة كما وردت فعلياً',
    () => {
      const body =
        'مع عدم الإخلال بما نصت عليه المواد ) (٩٥، ۸۸، ۸۷من هذا القانون، ينتهى عقد العمل محدد المدة بانقضاء مدته.';
      expect(detectCrossReferencedArticles(body)).toEqual([87, 88, 95]);
    },
  );

  it('يتحمّل قوساً معكوساً بلا مسافات إطلاقاً "المادة )(243" (نمط ثانٍ مُلاحَظ فعلياً فى نفس القانون)', () => {
    expect(detectCrossReferencedArticles('مع مراعاة ما نصت عليه المادة )(243 من هذا القانون.')).toEqual([243]);
  });

  it('يستخرج قائمة من صيغة "المواد 87 و88 و95" بلا أقواس', () => {
    expect(detectCrossReferencedArticles('طبقاً للمواد 87 و88 و95 من القانون')).toEqual([87, 88, 95]);
  });

  it('يستخرج إحالة مفردة من "المادة 88"', () => {
    expect(detectCrossReferencedArticles('وفقاً لأحكام المادة 88 من هذا القانون')).toEqual([88]);
  });

  it('يستخرج إحالة من صيغة المثنى "المادتين 12 و13"', () => {
    expect(detectCrossReferencedArticles('مع مراعاة المادتين 12 و13')).toEqual([12, 13]);
  });

  it('يستثني رقم المادة الحالية إن مُرِّر excludeArticleNo (لا تُحيل مادة لنفسها)', () => {
    expect(detectCrossReferencedArticles('طبقاً للمواد 87 و88 و154', 154)).toEqual([87, 88]);
  });

  it('يُزيل التكرار ويرتّب الأرقام تصاعدياً بصرف النظر عن ترتيب ورودها', () => {
    expect(detectCrossReferencedArticles('المادة 95 ثم المادة 87 ثم المادة 95 مجدداً')).toEqual([87, 95]);
  });

  it('لا يلتقط أرقاماً بعيدة عن كلمة "مادة" (كرقم القانون أو السنة)', () => {
    expect(detectCrossReferencedArticles('طبقاً للمادة 88 من قانون رقم 14 لسنة 2025')).toEqual([88]);
  });

  it('يُرجع مصفوفة فارغة لو لا توجد إحالات صريحة إطلاقاً', () => {
    expect(detectCrossReferencedArticles('ينتهي العقد بانقضاء مدته المتفق عليها بين الطرفين.')).toEqual([]);
  });

  it(`يحدّ عدد الإحالات المُستخرَجة بـ${MAX_CROSS_REFERENCE_ARTICLES} كحد أقصى (عبر مدى طويل جداً يتجاوز الحد)`, () => {
    // ⚠️ 2026-09-26: بعد رفع MAX_CROSS_REFERENCE_ARTICLES إلى 20 (بند P2)، لم
    // يعد ممكناً اختبار هذا السقف بقائمة أرقام مفصولة بفواصل بشكل عملى/واقعي
    // (يتطلب سرداً تشريعياً غير واقعى من 20+ رقماً) — نستخدم بدلاً منه مدى
    // "من X إلى Y" أطول من الحد (لا يزال داخل MAX_RANGE_SPAN=50 كى لا يُرفَض
    // كلياً)، وهو تعبير واقعى فعلاً عن كيفية وصول أعداد كبيرة لهذه الدالة.
    const body = 'طبقاً للمواد من 1 إلى 30';
    expect(detectCrossReferencedArticles(body)).toHaveLength(MAX_CROSS_REFERENCE_ARTICLES);
  });

  // ⚠️ P2 (2026-09-26): نمط الإحالة بالنطاق "من X إلى Y" — حالة المادة 157
  // الحقيقية (قانون العمل 14/2025)، موثَّقة أعلاه فى تعليق الدالة.
  describe('نمط الإحالة بالنطاق "من X إلى Y"', () => {
    it('يستخرج كل الأرقام بين طرفى المدى (شاملة) من النص الحقيقى المخزَّن فعلياً للمادة 157 (أقواس معكوسة)', () => {
      const body = 'مع مراعاة أحكام المواد من (158 إلى (175 من هذا القانون.';
      const result = detectCrossReferencedArticles(body);
      expect(result[0]).toBe(158);
      expect(result[result.length - 1]).toBe(175);
      expect(result).toHaveLength(18);
      expect(result).toEqual(Array.from({ length: 18 }, (_, i) => 158 + i));
    });

    it('يعمل أيضاً مع أقواس بترتيب سليم ومسافات عادية "من 10 إلى 12"', () => {
      expect(detectCrossReferencedArticles('طبقاً للمواد من 10 إلى 12')).toEqual([10, 11, 12]);
    });

    it('يدمج نطاقاً مع إحالة مفردة منفصلة فى نفس النص، بلا تكرار وبترتيب تصاعدى', () => {
      expect(detectCrossReferencedArticles('المادة 5 مع مراعاة المواد من 10 إلى 12')).toEqual([5, 10, 11, 12]);
    });

    it('يتجاهل مدى معكوساً (البداية أكبر من النهاية — على الأرجح عطل استخراج) بلا توليد أرقام وهمية', () => {
      expect(detectCrossReferencedArticles('طبقاً للمواد من 175 إلى 158')).toEqual([]);
    });

    it('يتجاهل مدى أكبر من الحد الآمن (MAX_RANGE_SPAN) بالكامل — حماية من عطل استخراج ينتج مدى ضخماً غير منطقى', () => {
      expect(detectCrossReferencedArticles('طبقاً للمواد من 1 إلى 5000')).toEqual([]);
    });

    it('لا يخلط بين إحالة مفردة تحتوي كلمة "من" فى سياق آخر وبين نمط النطاق الفعلى', () => {
      // لا يوجد هنا "إلى" على الإطلاق، فلا يجوز أن يُفعِّل نمط النطاق
      expect(detectCrossReferencedArticles('طبقاً للمادة 88 من هذا القانون')).toEqual([88]);
    });
  });
});

describe('isEndOfRelationshipTopic', () => {
  it.each([
    'ما حقوق الموظف عند عدم تجديد العقد المؤقت؟',
    'هل يجوز فصل العامل بدون سبب؟',
    'هل يجوز فصل موظف بسبب النشاط النقابي؟',
    'صاحب العمل فصلني بدون إنذار، ماذا أفعل؟',
    'تم فصلي من العمل تعسفياً',
    'قدمت استقالتي، متى تنتهي علاقتي بالعمل؟',
    'ما هي مدة الإخطار قبل إنهاء عقد العمل؟',
    'ترك العمل بدون إخطار صاحب العمل',
    'ما هي حقوقي عند انتهاء خدمتي بالشركة؟',
  ])('يكتشف أن السؤال "%s" يتعلق بنهاية علاقة العمل', (text) => {
    expect(isEndOfRelationshipTopic(text)).toBe(true);
  });

  it.each([
    'ما هي ساعات العمل الإضافية المسموح بها؟',
    'هل يحق لي الحصول على ترقية بعد سنتين؟',
    'كم قيمة بدل الأجازة السنوية إذا لم أستنفدها؟',
    'ما هو الحد الأدنى للأجور؟',
    'هل العامل ملزم بتوقيع عقد عمل مكتوب؟',
    'ما شروط عقد التلمذة الصناعية؟',
  ])('لا يُفعَّل زائفاً على سؤال عمالي غير متعلق بنهاية العلاقة: "%s"', (text) => {
    expect(isEndOfRelationshipTopic(text)).toBe(false);
  });

  it(
    'لا يُفعَّل زائفاً على كلمة تحتوي جذر "فصل" كجزء من كلمة أخرى غير متعلقة ' +
      '(حالة حقيقية فحصتها: "المكافأة الفصلية" تحتوي حرفياً على السلسلة "فصلي")',
    () => {
      expect(isEndOfRelationshipTopic('ما قيمة المكافأة الفصلية المستحقة للموظف؟')).toBe(false);
    },
  );
});

describe('END_OF_RELATIONSHIP_BUNDLE_ARTICLES', () => {
  it('يحتوي فقط على أرقام مواد صحيحة موجبة، بلا تكرار', () => {
    const seen = new Set<number>();
    for (const n of END_OF_RELATIONSHIP_BUNDLE_ARTICLES) {
      expect(Number.isInteger(n)).toBe(true);
      expect(n).toBeGreaterThan(0);
      expect(seen.has(n)).toBe(false);
      seen.add(n);
    }
  });
});

/**
 * 2026-09-25: بند P1 من "تقرير تحليل شامل لفجوات إجابة المنصة مقارنة بالمرجع
 * 9.5" — راجع تعليق isIndefiniteContractTerminationTopic وINDEFINITE_
 * TERMINATION_BUNDLE_ARTICLES الكاملين فى retrieval.ts. حالة "%s" الأولى فى
 * الاختبارات الإيجابية أدناه هى الصياغة الحقيقية للشِّق الثالث من السؤال
 * المرجعى الذى كشف الفجوة أصلاً ("هل تختلف الحقوق لو كان العقد غير محدد
 * المدة؟").
 */
describe('isIndefiniteContractTerminationTopic', () => {
  it.each([
    'هل تختلف الحقوق لو كان العقد غير محدد المدة؟',
    'ما حقوقى لو كان عقدى غير محدد المدة وأنهاه صاحب العمل؟',
    'صاحب العمل فصلني بدون إخطار من عقد دائم، ماذا أفعل؟',
    'ما هي مهلة الإخطار المطلوبة لإنهاء عقد عمل مفتوح؟',
    'تم فصلي تعسفياً من وظيفتى',
    'أنهى صاحب العمل عقدى بدون مبرر مشروع',
  ])('يكتشف أن السؤال "%s" يتعلق بإنهاء عقد غير محدد المدة', (text) => {
    expect(isIndefiniteContractTerminationTopic(text)).toBe(true);
  });

  it.each([
    'ما حقوق الموظف عند عدم تجديد العقد المؤقت؟',
    'كم قيمة بدل الأجازة السنوية إذا لم أستنفدها؟',
    'ما هي ساعات العمل الإضافية المسموح بها؟',
    'ما هو الحد الأدنى للأجور؟',
  ])(
    'لا يُفعَّل زائفاً على سؤال عمالى عام لا يتعلق تحديداً بإنهاء عقد غير محدد المدة: "%s"',
    (text) => {
      expect(isIndefiniteContractTerminationTopic(text)).toBe(false);
    },
  );
});

describe('INDEFINITE_TERMINATION_BUNDLE_ARTICLES', () => {
  it('يحتوي فقط على أرقام مواد صحيحة موجبة، بلا تكرار، ومنفصلة عن حزمة نهاية العلاقة العامة', () => {
    const seen = new Set<number>();
    for (const n of INDEFINITE_TERMINATION_BUNDLE_ARTICLES) {
      expect(Number.isInteger(n)).toBe(true);
      expect(n).toBeGreaterThan(0);
      expect(seen.has(n)).toBe(false);
      seen.add(n);
      expect(END_OF_RELATIONSHIP_BUNDLE_ARTICLES.includes(n)).toBe(false);
    }
  });
});

describe('isConfident', () => {
  it('يُرجع true عند تجاوز عتبة الرفض REFUSAL_THRESHOLD', () => {
    expect(isConfident(REFUSAL_THRESHOLD + 0.01)).toBe(true);
  });

  it('يُرجع true تماماً عند حد العتبة (حد شامل >=)', () => {
    expect(isConfident(REFUSAL_THRESHOLD)).toBe(true);
  });

  it('يُرجع false تحت العتبة مباشرة', () => {
    expect(isConfident(REFUSAL_THRESHOLD - 0.01)).toBe(false);
  });

  it('يُرجع false لثقة صفرية', () => {
    expect(isConfident(0)).toBe(false);
  });
});
