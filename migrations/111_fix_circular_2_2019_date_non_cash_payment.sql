-- 111_fix_circular_2_2019_date_non_cash_payment.sql
--
-- تصحيح تاريخ الكتاب الدورى رقم (2) لسنة 2019 بشأن تنظيم استخدام وسائل الدفع
-- غير النقدى فى إتمام المعاملات المالية للمؤسسات المالية غير المصرفية.
--
-- ===== السبب =====
-- فى إطار المحور الثانى (مراجعة اكتمال رفع القرارات واللوائح) رفع صاحب المشروع
-- نسخة PDF من الكتاب الدورى (3 صفحات، مسح ضوئى، توقيع د. محمد عمران رئيس مجلس
-- إدارة الهيئة العامة للرقابة المالية). المقارنة الحرفية بين النص المخزَّن فى
-- القاعدة (migrations/015) والأصل أثبتت أن **النص مطابق بلا نقص ولا زيادة**
-- (الكتاب الدورى لا يحتوى مواد مرقَّمة؛ تعليمات موحَّدة بعناوين فرعية، فيبقى
-- كمادة واحدة بطبيعته ولا يُقسَّم).
--
-- الفرق الوحيد: تاريخ الكتاب. المخزَّن: 6/5/2019. المكتوب بخط اليد فى ترويسة
-- الأصل: "26/5/2019" (خانتان ظاهرتان: 2 ثم 6، بنفس شكل رقم الكتاب (2) المجاور
-- لها فى السطر نفسه)، ويتسق مع تاريخ المسح الضوئى للملف (2019-05-26).
-- يُستبدَل التاريخ المخزَّن بـ 2019-05-26 فى: عنوان laws، وenacted_at،
-- وeffective_from لنسخة المادة. لا يمس هذا النص الجوهرى للكتاب إطلاقاً.
--
-- ⚠️ ثقة القراءة: عالية لكن التاريخ مكتوب بخط اليد (لا مطبوع) — يُنصح بتأكيده
-- مع نسخة أخرى إن توفرت.
--
-- ===== آمنة لإعادة التشغيل مع كل نشر =====
-- الشرط: تُعدَّل فقط إذا كان التاريخ الحالى ما زال 2019-05-06. migrations/015
-- (INSERT ... ON CONFLICT DO NOTHING) لا تُعيد كتابة الصف بعد وجوده، فلا تتعارض.
-- كتلة التحقق مقيَّدة بنطاق هذه الهجرة فقط (صف الكتاب الدورى 2/2019).

BEGIN;

UPDATE laws
SET title = replace(title, 'بتاريخ 6/5/2019', 'بتاريخ 26/5/2019'),
    enacted_at = DATE '2019-05-26'
WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular'
  AND enacted_at = DATE '2019-05-06';

UPDATE article_versions av
SET effective_from = DATE '2019-05-26'
FROM articles a
JOIN laws l ON l.id = a.law_id
WHERE av.article_id = a.id
  AND l.law_no = 2 AND l.law_year = 2019 AND l.kind = 'circular'
  AND l.enacted_at = DATE '2019-05-26'
  AND av.effective_from = DATE '2019-05-06';

DO $verify111$
DECLARE
  v_law_id uuid;
  v_enacted date;
  v_title text;
  v_articles int;
  v_versions int;
  v_bad int;
BEGIN
  SELECT id, enacted_at, title INTO v_law_id, v_enacted, v_title
  FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular';

  IF v_law_id IS NULL THEN
    RAISE WARNING '[111] الكتاب الدورى 2/2019 غير موجود — تخطّى';
    RETURN;
  END IF;

  IF v_enacted <> DATE '2019-05-26' THEN
    RAISE EXCEPTION '[111] enacted_at غير متوقع: %', v_enacted;
  END IF;
  IF v_title LIKE '%بتاريخ 6/5/2019%' THEN
    RAISE EXCEPTION '[111] العنوان ما زال يحمل التاريخ القديم';
  END IF;

  SELECT count(*) INTO v_articles FROM articles WHERE law_id = v_law_id;
  IF v_articles <> 1 THEN
    RAISE EXCEPTION '[111] عدد المواد المتوقع 1 لكن الفعلى %', v_articles;
  END IF;

  SELECT count(*), count(*) FILTER (WHERE av.effective_from <> DATE '2019-05-26')
    INTO v_versions, v_bad
  FROM article_versions av JOIN articles a ON a.id = av.article_id
  WHERE a.law_id = v_law_id;
  IF v_versions <> 1 OR v_bad <> 0 THEN
    RAISE EXCEPTION '[111] نسخ المادة غير متسقة: versions=% bad=%', v_versions, v_bad;
  END IF;

  RAISE NOTICE '[111] تم بنجاح: كتاب دورى 2/2019 بتاريخ 2019-05-26.';
END
$verify111$;

COMMIT;
