-- ============================================================================
-- 209 — اصلاح المادة 2 من قرار الهيئة 271/2024 (ضوابط ورسوم نشر قرارات شركات التأمين) من النص الرسمى
-- ----------------------------------------------------------------------------
-- المشكلة: المادة 2 مخزَّنة بأقواس مقلوبة ومبعثرة من استخراج PDF (") (Bold" و"1,50) :سم( ). (Line Spacing" وغيرهما) وفيها قوسان فارغان.
-- الإصلاح: أُعيدت كتابة المادة حرفاً بحرف من نسخة الوقائع المصرية (العدد 286 تابع فى 23 ديسمبر 2024، ص 3-4) المرفقة من المستخدم.
-- الضمان: قبل التوليد تأكّد أن الحروف العربية/اللاتينية مطابقة تماماً للنص المخزَّن وأن مجموعة الأعداد مطابقة (الفرق علامات ترقيم وأقواس ومسافات فقط).
-- يُطبَّق فقط إذا كان md5 النص الحالى مطابقاً للمتوقع (ecb168828e100d4059de6dde9d9a9bc2) فلا تُكتب فوق نص تغيّر لاحقاً. النص القديم يُحفظ فى migration_209_backup.
-- نسخ article_versions المطابقة تُحدَّث معها. embeddings لا تُمس. قابلة لإعادة التشغيل.
-- ============================================================================

CREATE TABLE IF NOT EXISTS migration_209_backup (
  article_id uuid NOT NULL,
  version_id uuid,
  old_body   text NOT NULL,
  saved_at   timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS uq_migration_209_backup_art ON migration_209_backup (article_id) WHERE version_id IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_migration_209_backup_ver ON migration_209_backup (version_id) WHERE version_id IS NOT NULL;

DO $m209$
DECLARE
  v_new text := replace($b$تكون مواصفات كل صفحة من القرارات المشار إليها فى (المادة الأولى) على النحو الآتى :
1- حجم الورقة : A4 .
2- نوع الخط لكامل الملف : (Times New Romon) .
3- حجم الخط :
العنوان الرئيسى : يكتب بمقاس (16) بخط عريض (Bold) .
العناوين الفرعية : تكتب بمقاس (14) بخط عريض (Bold) .
النص الأساسى : يكتب بمقاس (14) وتكون النصوص واضحة ومنسقة بدون زخرفة .
الحواشى السفلية (Footer) : تكتب بمقاس (12) .
4- الهوامش : الأعلى 5 سم ، الأسفل 3,5 سم ، يمين 2,5 سم ، يسار 2,5 سم .
5- المسافة البينية للأسطر : (1,50سم) (Line Spacing) .
6- عدد الأسطر بالورقة الواحدة : تتراوح بين (20) إلى (25) سطر .$b$, E'\n', E'\r\n');
  v_old_md5 text := 'ecb168828e100d4059de6dde9d9a9bc2';
  v_new_md5 text := '72ff21aceaf5c7d1e7e08996291f12bf';
  v_aid uuid; v_cur text; v_upd_art int := 0; v_upd_ver int := 0;
BEGIN
  IF md5(v_new) <> v_new_md5 THEN
    RAISE EXCEPTION '[209] النص المحمَّل لا يطابق md5 المختبَر';
  END IF;
  SELECT a.id, md5(a.body) INTO v_aid, v_cur
  FROM articles a JOIN laws l ON l.id = a.law_id
  WHERE l.country_code = 'EG' AND l.kind = 'board_decision' AND l.law_no = 271 AND l.law_year = 2024
    AND a.article_no = 2 AND a.article_suffix_order = 0;
  IF v_aid IS NULL THEN
    RAISE WARNING '[209] المادة 2 من قرار 271/2024 غير موجودة — تخطّى';
    RETURN;
  END IF;
  IF v_cur = v_new_md5 THEN
    RAISE NOTICE '[209] مُصلَحة سابقاً — لا تغيير';
    RETURN;
  END IF;
  IF v_cur <> v_old_md5 THEN
    RAISE WARNING '[209] نص المادة الحالى يختلف عن المتوقع (md5 %) — تُخطّيت دون تعديل، راجعها يدوياً', v_cur;
    RETURN;
  END IF;

  INSERT INTO migration_209_backup (article_id, version_id, old_body)
    SELECT a.id, NULL, a.body FROM articles a WHERE a.id = v_aid ON CONFLICT DO NOTHING;
  INSERT INTO migration_209_backup (article_id, version_id, old_body)
    SELECT v.article_id, v.id, v.body FROM article_versions v WHERE v.article_id = v_aid AND md5(v.body) = v_old_md5 ON CONFLICT DO NOTHING;

  UPDATE article_versions SET body = v_new WHERE article_id = v_aid AND md5(body) = v_old_md5;
  GET DIAGNOSTICS v_upd_ver = ROW_COUNT;
  UPDATE articles SET body = v_new WHERE id = v_aid AND md5(body) = v_old_md5;
  GET DIAGNOSTICS v_upd_art = ROW_COUNT;

  IF v_upd_art <> 1 THEN
    RAISE EXCEPTION '[209] عدد المواد المعدلة % بدل 1', v_upd_art;
  END IF;
  IF (SELECT md5(body) FROM articles WHERE id = v_aid) <> v_new_md5 THEN
    RAISE EXCEPTION '[209] النص بعد التعديل لا يطابق المختبَر';
  END IF;
  RAISE NOTICE '[209] عُدِّلت المادة 2 من قرار 271/2024 (نسخ: %)', v_upd_ver;
END
$m209$;
