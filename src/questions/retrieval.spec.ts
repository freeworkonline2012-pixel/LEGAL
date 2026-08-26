import {
  REFUSAL_THRESHOLD,
  buildFtsQuery,
  confidenceFromRank,
  detectArticleReference,
  isConfident,
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
