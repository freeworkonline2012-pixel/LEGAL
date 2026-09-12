-- 050_add_web_fallback_column_to_answers.sql
--
-- تعديل بنيوى بناءً على طلب صريح من رجل الأعمال: "فى حالة عدم وجود اجابة
-- للسؤال على المنصة يتم البحث على الانترنت للوصول الى الاجابة الصحيحة
-- والرد على المستخدم". راجع WebSearchFallbackService (src/llm/
-- web-search-fallback.service.ts) للتصميم الكامل والمبرر التفصيلى لماذا لم
-- يُنفَّذ هذا كـ"بحث حر + إجابة مباشرة بنفس ثقة الاستشهادات الموثَّقة" —
-- بإيجاز: هذا يتعارض مع المبدأ المعمارى المؤسِّس لكل هذا المشروع (رفض آمن
-- أفضل من إجابة واثقة خاطئة، توليد مقيَّد حصراً بمصدر متحقَّق منه). التصميم
-- المُطبَّق هنا: طبقة احتياطية (Tier 2) مُقيَّدة النطاق (مصادر رسمية فقط)،
-- معطَّلة افتراضياً (ENABLE_WEB_FALLBACK)، لا تستبدل answer.refused=true
-- إطلاقاً (تبقى الإجابة تدخل طابور المراجعة البشرية كما كانت)، بل تُرفَق
-- كحقل إضافى منفصل يحمل تنويهاً إلزامياً صريحاً.
--
-- هذا الملف يضيف فقط العمود التخزينى اللازم (jsonb، nullable) — عمود إضافى
-- بحت لا يمس أى صف أو سلوك موجود، ولا يغيّر أى قيد حالى.
--
-- قابل لإعادة التشغيل بأمان (idempotent): ADD COLUMN IF NOT EXISTS.

BEGIN;

ALTER TABLE answers ADD COLUMN IF NOT EXISTS web_fallback jsonb;

COMMENT ON COLUMN answers.web_fallback IS
  'نتيجة WebSearchFallbackService (Tier 2 — بحث ويب مقيَّد النطاق) عند فشل الاسترجاع الموثَّق. NULL فى الوضع الافتراضى وفى كل الصفوف السابقة لهذه الهجرة. الشكل: {answer, sources:[{title,url,snippet}], provider, queriedAt}.';

DO $verify$
DECLARE
  v_exists boolean;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'answers' AND column_name = 'web_fallback'
  ) INTO v_exists;
  IF NOT v_exists THEN
    RAISE WARNING '050: عمود answers.web_fallback غير موجود بعد التنفيذ — تحقّق يدوياً';
  ELSE
    RAISE NOTICE '050: عمود answers.web_fallback موجود كما هو متوقَّع';
  END IF;
END;
$verify$;

COMMIT;
