-- 116_fix_decision_2_2026_micro_insurance_coverage_cap_effective_date_and_preamble.sql
--
-- استكمال قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (2) لسنة 2026
-- بشأن زيادة الحد الأقصى للتغطية التأمينية لنشاط التأمين متناهى الصغر (إلى 390,000 جنيه)
-- (المنشور بالوقائع المصرية، العدد 22 تابع، فى 27 يناير 2026، ص 4).
--
-- ===== نتيجة الفحص =====
-- القرار مخزَّن بنيوياً بمادتين (هجرة 006) ونص المادتين سليم ومطابق للنسخة الرسمية فى
-- الجوهر (المبلغ "ثلاثمائة وتسعين ألف جنيه" مقروء بصرياً من الصفحة الرسمية الوحيدة).
-- لذلك لا يُستبدل المتن (وبقاء الصفين كما هما يُبقى الـembedding الموجود صالحاً).
-- العيوب الفعلية التى يعالجها هذا الملف:
--   (1) effective_from للنسختين = now()::date وقت أول تشغيل للبذرة (تاريخ تقنى لا قانونى)،
--       والصحيح 2026-01-28: المادة الثانية تنص على العمل به من اليوم التالى لنشره
--       بالوقائع، والنشر 27 يناير 2026 (ترويسة الصفحة الرسمية).
--   (2) الديباجة (أساس الإصدار وموافقة المجلس 2026/1/14) غير مخزَّنة؛ تُضاف كمادة
--       article_no=0 على نمط 113/115. وهى مهمة هنا لأنها تربط القرار بسلسلة قراراته
--       السابقة (18/2025 و319/2025).
--
-- ===== التواريخ =====
-- enacted_at لم يُعدَّل (NULL): المصدر لا يذكر تاريخ إصدار، و2026/1/14 هو جلسة موافقة المجلس.
-- official_url لم يُمس.
--
-- قابلة لإعادة التشغيل: الإدراج محمى بـON CONFLICT DO NOTHING، والتحديث لا يغيّر شيئاً
-- عند التكرار، وتحقق الختام محصور فى هذا القرار. إعادة تشغيل بلوك 006 لا تعيد التاريخ
-- الخاطئ لأن إدراج الصفوف يتخطى الموجود.
--
-- ملاحظة تشغيلية: مادة الديباجة الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js.

BEGIN;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, NULL, 'ديباجة القرار', $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 18 لسنة 2025 بشأن زيادة الحد الأقصى للتغطية التأمينية لنشاط التأمين متناهى الصغر ؛
وعلى قرار مجلس إدارة الهيئة رقم 319 لسنة 2025 بشأن الشروط والقواعد الحاكمة لنشاط التأمين متناهى الصغر ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2026/1/14 ؛
قرر :$b0$
  FROM laws WHERE law_no = 2 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-28', 'active' FROM ins0;

UPDATE article_versions av SET effective_from = DATE '2026-01-28'
FROM articles a JOIN laws l ON l.id = a.law_id
WHERE av.article_id = a.id AND l.law_no = 2 AND l.law_year = 2026 AND l.kind = 'board_decision'
  AND a.article_no IN (1, 2) AND av.version_no = 1 AND av.effective_from IS DISTINCT FROM DATE '2026-01-28';

DO $verify116$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_cap int;
  v_pre int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 2 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE EXCEPTION '[116] القرار 2/2026 غير موجود';
  END IF;
  SELECT count(*),
         count(*) FILTER (WHERE body LIKE '%' || chr(65533) || '%'),
         count(*) FILTER (WHERE article_no = 1 AND body LIKE '%ثلاثمائة وتسعين ألف جنيه%'),
         count(*) FILTER (WHERE article_no = 0 AND length(body) = 451)
    INTO v_arts, v_bad, v_cap, v_pre FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2026-01-28' AND av.status = 'active';
  IF v_arts <> 3 OR v_vers <> 3 THEN
    RAISE EXCEPTION '[116] متوقَّع 3 مواد و3 نسخ بتاريخ 2026-01-28، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_cap <> 1 OR v_pre <> 1 THEN
    RAISE EXCEPTION '[116] فشل التحقق من المحتوى (تلف=%, مبلغ=%, ديباجة=%)', v_bad, v_cap, v_pre;
  END IF;
  RAISE NOTICE '[116] قرار 2/2026: % مواد و% نسخ بتاريخ نفاذ 2026-01-28.', v_arts, v_vers;
END
$verify116$;

COMMIT;
