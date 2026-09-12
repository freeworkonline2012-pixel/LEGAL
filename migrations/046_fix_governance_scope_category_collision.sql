-- 046_fix_governance_scope_category_collision.sql
--
-- تصحيح تعويضى صريح لعيب اكتُشف اليوم فى migrations/032 (راجع الشرح الكامل
-- والتعديل الجذرى هناك): شرط `WHERE (law_no, law_year) IN (...)` كان غير
-- مقيَّد بـ`category`/`country_code`، فطابق أى قانون يتشارك نفس الرقم
-- والسنة بصرف النظر عن فئته. اكتُشف هذا عبر اختبار إعادة تشغيل السلسلة
-- الكاملة (idempotency test) لدفعة تدقيق نطاق سوق المال الحالية — النتيجة
-- اختلفت بين أول تشغيل (25 قانوناً) وإعادة التشغيل (26 قانوناً)، مما كشف
-- أن migrations/032 وسم قانون التكنولوجيا المالية (5/2022، فئة
-- non_bank_finance) خطأً بمجرد إعادة تشغيله، لأنه يتشارك (law_no, law_year)
-- مع قرار اختبارات الوظائف الرئيسية (5/2022، فئة insurance) المُدرَج أصلاً
-- عمداً منذ 2026-09-04.
--
-- ==================== الأثر الفعلى ====================
-- migrations/032 تعديل بنيوى وقائى (منع أى تصادم مستقبلى مماثل) — لكنه
-- لا "يُصلح" أى صف سبق وسمه خطأً فعلاً، لأن UPDATE ... SET true لا يعيد
-- true إلى false تلقائياً لصفوف لم تعد تطابق الشرط الجديد. لذلك هذه الهجرة
-- التعويضية ضرورية بشكل منفصل ومباشر:
--   1. تُعيد تعيين قانون التكنولوجيا المالية (5/2022، non_bank_finance)
--      صراحة إلى governance_scope=false — لم يخضع هذا القانون لأى تدقيق
--      نطاق حوكمة حتى الآن (ليس جزءاً من دفعتَى تدقيق سوق المال 044/045،
--      ولا من الدفعة الأصلية لـ032)، فوسمه كان خطأً فنياً بحتاً ال قرار
--      محتوى — إعادته لحالته الصحيحة (خارج النطاق، بانتظار تدقيق مخصَّص
--      منفصل إن رُغِب) هى التصحيح الوحيد المبرَّر هنا.
--   2. تتحقَّق من العدد الكلى النهائى المتوقَّع (25، مطابق لما بعد 045 على
--      أول تشغيل نظيف).
--
-- ⚠️ ملاحظة مهمة عن الإنتاج: نظراً لأن scripts/run-migration.js يُعيد تطبيق
-- **كل** ملفات migrations/*.sql فى كل نشر (لا جدول تتبع)، فإن هذا العيب
-- كان سيتكرر تلقائياً فى كل نشر إنتاجى تال لدمج migrations/043 (قانون
-- 5/2022 التكنولوجيا المالية) — بصرف النظر عن أن هذا النشر التالى نفسه لا
-- عالقة له بموضوع الحوكمة إطلاقاً. لا يمكننى التحقق مباشرة مما إذا كان هذا
-- قد حدث فعلياً على قاعدة بيانات الإنتاج الحقيقية (لا صلاحية وصول لى)،
-- لكن هذه الهجرة آمنة ومضمونة النتيجة بصرف النظر عن الحالة الحالية للصف
-- فى الإنتاج (idempotent: تعيد الصف الصريح لـfalse سواء كان already false
-- أو تأثر بالعيب فعلاً).
--
-- التحقق: قابلة لإعادة التشغيل بأمان — UPDATE بقيمة صريحة (لا تراكمية).

BEGIN;

UPDATE laws SET governance_scope = false
WHERE country_code = 'EG'
  AND law_no = 5 AND law_year = 2022
  AND category = 'non_bank_finance'
  AND governance_scope IS DISTINCT FROM false;

DO $verify$
DECLARE
  v_count int;
  v_expected int := 25;
  v_fintech_scope boolean;
BEGIN
  SELECT count(*) INTO v_count FROM laws WHERE governance_scope = true;
  SELECT governance_scope INTO v_fintech_scope FROM laws
    WHERE country_code = 'EG' AND law_no = 5 AND law_year = 2022 AND category = 'non_bank_finance';
  IF v_count <> v_expected THEN
    RAISE WARNING 'governance_scope: % قانوناً موسوماً، المتوقَّع % — تحقّق يدوياً', v_count, v_expected;
  ELSIF v_fintech_scope IS DISTINCT FROM false THEN
    RAISE WARNING 'governance_scope: قانون التكنولوجيا المالية 5/2022 لا يزال true بعد محاولة التصحيح — تحقّق يدوياً';
  ELSE
    RAISE NOTICE 'governance_scope: % قانوناً موسوماً كما هو متوقَّع، وقانون التكنولوجيا المالية 5/2022 مؤكَّد خارج النطاق', v_count;
  END IF;
END;
$verify$;

COMMIT;
