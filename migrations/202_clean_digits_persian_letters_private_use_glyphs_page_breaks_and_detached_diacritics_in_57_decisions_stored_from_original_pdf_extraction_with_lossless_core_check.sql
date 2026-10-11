-- ============================================================================
-- 202 — تنظيف آلى بلا فقدان لـ 57 قراراً/كتاباً دورياً مخزَّناً من استخراج PDF أصلى (لم يُعَد بناؤه)
-- ----------------------------------------------------------------------------
-- العيوب المعالَجة (طبقة آلية آمنة فقط):
--   1) أرقام عربية-هندية (٠-٩) وفارسية (۰-۹) → لاتينية 0-9، و"٪" → "%": يحافظ على ترتيب الأرقام كما هو
--      ويجعل رقم القرار والسنة والنسب قابلة للبحث نصياً. (مفردات الهجرات الأخرى تستعمل الأرقام اللاتينية.)
--   2) الياء الفارسية "ی" → "ي"، الكاف الفارسية "ک" → "ك"، "ھ" → "ه" (مثل "المصریة").
--   3) حذف رموز منطقة الاستخدام الخاص U+E000–U+F8FF: هى مزخرفات خط قديم تُعرض كحركات (فتحتان وضمة) داخل
--      الكلمات ("اعتبار?ا"، "الم?شار") أو كنص مخفى (علامة مائية) بين الفقرات؛ لا تحمل حرفاً.
--   4) فاصل الصفحة \f → سطر جديد.
--   5) فصل التنوين والحركات عن حرفها بمسافة ("تنفيذ ًا"، "وفقا ً"، "ت ُمد") → إلصاقها.
--   6) رقم لاصق بكلمة ("١٥٥لسنة") → رقم ثم مسافة. وطى الأسطر الفارغة المتتالية الناتجة.
--
-- لا يُعالَج هنا (يحتاج مصدراً رسمياً، لأن إصلاحه آلياً قد يغيّر رقماً قانونياً):
--   * ترويسات صفحات الوقائع الدخيلة وسط المتن ("الوقائع المصرية – العدد ... تابع ... فى ... سنة ...") وأرقام الصفحات الملتصقة بها.
--   * تبعثر الأقواس والنسب (") (٪٥") وكلمات مقطوعة من العلامة المائية.
-- هذه تُعالَج بإعادة رفع القرار من PDF نظيف، وتقرير الباقى منها فى التقرير المرافق.
--
-- النطاق: القائمة الصريحة أدناه فقط (قرارات لم تُعَد بالهجرات 128–201)، فلا تُمس نصوص أُعيد بناؤها وتعتمد
-- هجراتها على نصها (تفحص أطوالها وألفاظها عند كل إقلاع). اللائحة 135/1993 مستثناة (مشروع مستقل).
-- كل مادة معدَّلة يُعدَّل معها نص كل نسخها فى article_versions بالتحويل نفسه.
--
-- الضمان: لكل مادة ونسخة يُقارَن "الجوهر" قبل التنظيف وبعده، وهو النص بعد توحيد الأرقام والياء ومن غير مسافات
-- وحركات ورموز خاصة؛ أى فرق (حرف زائد أو ناقص أو مغيَّر) يُفشل الهجرة كلها بلا أثر. كما يفشلها بقاء أى رقم هندى أو
-- رمز خاص أو ياء فارسية أو \f فى القائمة، أو تغيُّر عدد المواد أو النسخ. embeddings لا تُمس (النص المعنوى لم يتغيّر).
-- قابلية إعادة التشغيل: تحديث مشروط بوجود فرق، فالتشغيل الثانى لا يغيّر شيئاً.
-- ============================================================================

CREATE OR REPLACE FUNCTION pg_temp.m202_map(t text) RETURNS text LANGUAGE sql IMMUTABLE AS $f$
  SELECT translate(t, '٠١٢٣٤٥٦٧٨٩۰۱۲۳۴۵۶۷۸۹٪یکھ', '01234567890123456789%يكه')
$f$;

CREATE OR REPLACE FUNCTION pg_temp.m202_clean(t text) RETURNS text LANGUAGE sql IMMUTABLE AS $f$
  SELECT regexp_replace(
           regexp_replace(
             regexp_replace(
               regexp_replace(
                 regexp_replace(
                   pg_temp.m202_map(regexp_replace(t, '[-]', '', 'g')),
                   E'\f', E'\n', 'g'),
                 '\s+([ً-ْ])', '\1', 'g'),
               '([0-9])([ء-ي])', '\1 \2', 'g'),
             E'(\r?\n[ \t]*){3,}', E'\n\n', 'g'),
           E'[ \t]+(\r?\n)', '\1', 'g')
$f$;

CREATE OR REPLACE FUNCTION pg_temp.m202_core(t text) RETURNS text LANGUAGE sql IMMUTABLE AS $f$
  SELECT regexp_replace(pg_temp.m202_map(t), '[\sً-ْـ-]', '', 'g')
$f$;

DO $m202$
DECLARE
  v_ids uuid[];
  v_n_laws int;
  v_art_before int;
  v_ver_before int;
  v_changed_art int;
  v_changed_ver int;
  v_bad int;
BEGIN
  SELECT array_agg(l.id), count(*) INTO v_ids, v_n_laws
  FROM laws l
  WHERE l.country_code = 'EG'
    AND l.kind NOT IN ('law', 'regulation')
    AND NOT (l.law_no = 135 AND l.law_year = 1993)
    AND (l.law_no, l.law_year) IN (
      (48, 2022), (193, 2022), (152, 2023), (147, 2024), (161, 2024), (183, 2024), (196, 2024), (223, 2024), (236, 2024), (237, 2024), (256, 2024), (268, 2024), (269, 2024), (271, 2024), (273, 2024), (276, 2024), (278, 2024), (298, 2024), (16, 2025), (49, 2025), (58, 2025), (62, 2025), (69, 2025), (79, 2025), (89, 2025), (90, 2025), (102, 2025), (123, 2025), (126, 2025), (127, 2025), (144, 2025), (148, 2025), (159, 2025), (223, 2025), (228, 2025), (230, 2025), (254, 2025), (267, 2025), (306, 2025), (3973, 2025), (2, 2026), (29, 2026), (35, 2026), (38, 2026), (42, 2026), (57, 2026), (64, 2026), (97, 2026), (98, 2026), (116, 2026), (130, 2026), (132, 2026), (134, 2026), (135, 2026), (145, 2026), (2036, 2026), (2044, 2026)
    );
  IF v_ids IS NULL THEN
    RAISE NOTICE '[202] لا قرارات مطابقة فى laws — تخطّى';
    RETURN;
  END IF;

  CREATE TEMP TABLE m202_old_art ON COMMIT DROP AS
    SELECT id, body FROM articles WHERE law_id = ANY(v_ids);
  CREATE TEMP TABLE m202_old_ver ON COMMIT DROP AS
    SELECT v.id, v.body FROM article_versions v JOIN articles a ON a.id = v.article_id WHERE a.law_id = ANY(v_ids);
  SELECT count(*) INTO v_art_before FROM m202_old_art;
  SELECT count(*) INTO v_ver_before FROM m202_old_ver;

  UPDATE articles a SET body = pg_temp.m202_clean(a.body)
   WHERE a.law_id = ANY(v_ids) AND pg_temp.m202_clean(a.body) IS DISTINCT FROM a.body;
  GET DIAGNOSTICS v_changed_art = ROW_COUNT;

  UPDATE article_versions v SET body = pg_temp.m202_clean(v.body)
   FROM articles a
   WHERE a.id = v.article_id AND a.law_id = ANY(v_ids)
     AND pg_temp.m202_clean(v.body) IS DISTINCT FROM v.body;
  GET DIAGNOSTICS v_changed_ver = ROW_COUNT;

  -- ختام 1: لم يتغيّر عدد المواد ولا النسخ
  IF (SELECT count(*) FROM articles WHERE law_id = ANY(v_ids)) <> v_art_before
     OR (SELECT count(*) FROM article_versions v JOIN articles a ON a.id = v.article_id WHERE a.law_id = ANY(v_ids)) <> v_ver_before THEN
    RAISE EXCEPTION '[202] تغيّر عدد المواد أو النسخ';
  END IF;

  -- ختام 2: الجوهر محفوظ حرفاً بحرف لكل مادة ولكل نسخة
  SELECT count(*) INTO v_bad FROM articles a JOIN m202_old_art o ON o.id = a.id
   WHERE pg_temp.m202_core(a.body) <> pg_temp.m202_core(o.body);
  IF v_bad <> 0 THEN
    RAISE EXCEPTION '[202] % مادة تغيّر جوهر نصها', v_bad;
  END IF;
  SELECT count(*) INTO v_bad FROM article_versions v JOIN m202_old_ver o ON o.id = v.id
   WHERE pg_temp.m202_core(v.body) <> pg_temp.m202_core(o.body);
  IF v_bad <> 0 THEN
    RAISE EXCEPTION '[202] % نسخة تغيّر جوهر نصها', v_bad;
  END IF;

  -- ختام 3: لا بقايا من العيوب المعالَجة
  SELECT count(*) INTO v_bad FROM articles a
   WHERE a.law_id = ANY(v_ids)
     AND (a.body ~ '[٠-٩۰-۹٪یکھ]' OR a.body ~ '[-]' OR position(E'\f' in a.body) > 0
          OR a.body ~ '\s[ً-ْ]' OR a.body ~ '[0-9][ء-ي]');
  IF v_bad <> 0 THEN
    RAISE EXCEPTION '[202] % مادة فيها بقايا من العيوب المعالَجة', v_bad;
  END IF;
  SELECT count(*) INTO v_bad FROM article_versions v JOIN articles a ON a.id = v.article_id
   WHERE a.law_id = ANY(v_ids)
     AND (v.body ~ '[٠-٩۰-۹٪یکھ]' OR v.body ~ '[-]' OR position(E'\f' in v.body) > 0);
  IF v_bad <> 0 THEN
    RAISE EXCEPTION '[202] % نسخة فيها بقايا من العيوب المعالَجة', v_bad;
  END IF;

  RAISE NOTICE '[202] قرارات: %، مواد معدَّلة: % من %، نسخ معدَّلة: % من %', v_n_laws, v_changed_art, v_art_before, v_changed_ver, v_ver_before;
END
$m202$;
