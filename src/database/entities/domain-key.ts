/**
 * T-VOCAB-1 — المفتاح الموحّد لمجالات القانون (DomainKey).
 *
 * مفردات واحدة تُستخدم في كل طبقات النظام:
 *   - laws.category (CHECK في 001_init.sql + كيان Law)
 *   - questions.category (CHECK في 001_init.sql + كيان Question — هذه النقطة كانت
 *     نصاً حراً بلا قيد؛ أصبحت DomainKey موحّداً)
 *   - عقد OpenAPI (backend/openapi.yaml)
 *
 * عند وصول مصنّف المجال القانوني (EP-03 / وكيل ai) يجب أن يُخرج أحد هذه المفاتيح
 * حصراً؛ أي قيمة أخرى تُرفض (نوعياً عبر TS، وقاعدياً عبر CHECK في قاعدة البيانات).
 */
export const DOMAIN_KEYS = [
  'labor',
  'rent',
  'personal_status',
  'traffic',
  'consumer_protection',
  // 'insurance' أُضيفت 2026-08-21 (EP-05) مع قانون التأمين الموحد 155/2024 —
  // كانت غائبة عن هذا الاتحاد رغم إضافتها لقيد CHECK فى قاعدة البيانات
  // (migrations/003_seed_real_laws.sql) فى نفس اليوم، وهي فجوة نوع (type
  // safety gap) حقيقية اكتُشفت فى مراجعة ما بعد الإطلاق 2026-08-21: أي كود
  // مستقبلي يعتمد على DomainKey/isDomainKey() لتصنيف الأسئلة تلقائياً كان
  // سيرفض أو يصنّف خطأً أي سؤال متعلق بالتأمين رغم وجود محتوى حقيقي له.
  'insurance',
  // 'aml_cft' أُضيفت 2026-08-27 مع دفعة قرارات مكافحة غسل الأموال وتمويل
  // الإرهاب (migrations/007_seed_fra_aml_cft_decisions.sql) — أُضيفت وقتها
  // لقيد CHECK فى قاعدة البيانات (laws.category) فقط، وكانت غائبة عن هذا
  // الاتحاد، وهي بالضبط نفس فجوة النوع (type safety gap) التى وقعت مع
  // 'insurance' فى 2026-08-21 (راجع التعليق أعلاه) — اكتُشفت هذه المرة فى
  // مراجعة تقنية قبل أن تصل لأثر وظيفي فعلي: كانت ستمنع GET /api/laws?
  // category=aml_cft (رفض 400 عبر @IsIn(LAW_CATEGORIES)) وتُسقط أي تصنيف
  // تلقائى مستقبلى للأسئلة فى هذا المجال إلى 'other' بصمت عبر
  // IngestionService.coerceCategory(). إعادة استخدام DOMAIN_KEYS يمنع
  // تكرار هذا الخطأ للمرة الثالثة.
  'aml_cft',
  // 'legal_profession' أُضيفت 2026-08-28 مع قانون المحاماة 17/1983 وتعديلاته —
  // أُضيفت فى نفس الوقت لقيد CHECK فى قاعدة البيانات (migrations/003 و007،
  // كلاهما يُعيد إنشاء laws_category_check فى كل نشر — راجع تعليق 003 عن سبب
  // ضرورة تحديث الاثنين معاً) تفادياً لنفس فجوة النوع المذكورة أعلاه للمرة الثالثة.
  'legal_profession',
  // 'capital_markets' و'non_bank_finance' أُضيفتا 2026-08-28 مع دفعة قوانين
  // وقرارات الهيئة العامة للرقابة المالية فى سوق المال والتمويل غير المصرفى
  // (migrations/014_seed_capital_markets_and_nbf_laws.sql) — نفس فجوة النوع
  // (type safety gap) المذكورة أعلاه ثلاث مرات سابقاً: أُضيفتا فى نفس الوقت
  // لقيد CHECK فى قاعدة البيانات (migrations/003 و007 و012 و014 معاً — الأربعة
  // تُعيد إنشاء laws_category_check فى كل نشر، راجع تعليق 003) تفادياً لتكرار
  // نفس الخطأ للمرة الرابعة. 'capital_markets' = قانون سوق رأس المال ولوائحه
  // وقرارات مجلس إدارة الهيئة الخاصة بالبورصة والسندات والطرح العام.
  // 'non_bank_finance' = التمويل غير المصرفى (تمويل استهلاكى) + القطاعات
  // الناشئة والخدمات المساندة (تكنولوجيا مالية، تحصيل ديون، تمويل عقارى،
  // خبراء تقييم الأصول) — جُمعت فى فئة واحدة بدل تفتيتها لعدة فئات لأن حجم
  // المحتوى المُدخَل فى كل قطاع فرعى صغير نسبياً.
  'capital_markets',
  'non_bank_finance',
  'other',
] as const;

export type DomainKey = (typeof DOMAIN_KEYS)[number];

export function isDomainKey(value: unknown): value is DomainKey {
  return typeof value === 'string' && (DOMAIN_KEYS as readonly string[]).includes(value);
}
