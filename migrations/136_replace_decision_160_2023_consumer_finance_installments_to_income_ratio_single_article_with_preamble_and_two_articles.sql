-- 136_replace_decision_160_2023_consumer_finance_installments_to_income_ratio_single_article_with_preamble_and_two_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (160) لسنة 2023 (بتاريخ 2023/7/26) بشأن
-- نسبة أقساط التمويل إلى دخل العميل فى نشاط التمويل الاستهلاكى، المنشور بالوقائع المصرية، العدد 186
-- (تابع)، فى 24 أغسطس 2023 (صفحة 16).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P3) =====
-- مخزَّن منذ الهجرة 014 كمادة واحدة (article_no = 1، نحو 1071 حرفاً) تضم القرار كله: ترويسة
-- الوقائع، العنوان، الديباجة، المادتين، التوقيع، وبيانات المطبعة (رقم الإيداع بدار الكتب)، بأرقام
-- هندية وكلمات مقطوعة بمسافات ("الاســتهلاك ى"، "ف ى"، "وي عمل") وعلامة النسبة منفصلة عن رقمها
-- (٪ فى سطر و"50" فى آخر). فكان استرجاع المادة الأولى يعطى المادتين والتوقيع معاً. القرار ضمن نطاق
-- الحوكمة (لا تُمس بيانات laws؛ enacted_at = 2023-07-26 قائم).
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحة واحدة) رفعه صاحب المشروع؛ رابط laws.official_url لم يُمس. الملف تالف الـxref
-- فأُصلح بـqpdf، واستُخرج النص ونُظّف وقوبل بصورة الصفحة. حُذفت ترويسة الوقائع وبيانات المطبعة
-- (رقم الإيداع، رئيس مجلس إدارة المطابع) لأنها ليست من نص القرار، ويُحفظ عنوان القرار وتاريخه
-- ("بتاريخ 2023/7/26") فى hierarchical_location للديباجة. النسبة "(50٪)" عادت متصلة برقمها.
-- مقابلة الأعداد مع النص القديم: 160، 2023، 10، 2009، 18، 2020، 26، 7، 50 كلها موجودة فى الجديد.
--
-- ===== الهيكل =====
-- 3 مواد، 3 نسخ (version_no = 1): ديباجة (article_no = 0)، المادة الأولى (النسبة 50٪ من مجموع الدخل
-- الشهرى)، المادة الثانية (النشر والعمل به من اليوم التالى للنشر، مع التوقيع). أُبقى رقم المادة 1
-- للمادة الأولى حتى لا يعيد بذر 014 إدراج مادة قديمة (ON CONFLICT DO NOTHING).
--
-- ===== التاريخ =====
-- effective_from = 2023-08-25: المادة الثانية تُعمل القرار من اليوم التالى لتاريخ نشره بالوقائع
-- المصرية، والنشر فى 24 أغسطس 2023 (ترويسة الصفحة). كانت النسخة القديمة 2023-07-26 (تاريخ جلسة
-- المجلس) فتُستبدل بالتاريخ الصحيح للنفاذ.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (3 مواد بديباجة سليمة والمادة 2 موجودة)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، محتوى،
-- ترويسة أو بيانات مطبعة متبقية، إجمالى الطول 570 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix136$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 160 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[136] القرار 160/2023 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 3
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[136] القرار 160/2023 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[136] أُزيلت % مادة من القرار 160/2023 (مادة واحدة تضم القرار كله)', v_n;
  END IF;
END
$fix136$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 160 لسنة 2023 بتاريخ 2023/7/26 بشأن نسبة أقساط التمويل إلى دخل العميل فى نشاط التمويل الاستهلاكى$h0$, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون تنظيم نشاط التمويل الاستهلاكى الصادر بالقانون رقم 18 لسنة 2020 ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2023/7/26 ؛
قرر :$b0$
  FROM laws WHERE law_no = 160 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-08-25', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$تلتزم الشركات المرخص لها بمزاولة نشاط التمويل الاستهلاكى بألا يتجاوز إجمالى أقساط التمويل الشهرية للعميل نسبة (50٪) من مجموع دخله الشهرى .$b1$
  FROM laws WHERE law_no = 160 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-08-25', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية .
رئيس مجلس إدارة الهيئة العامة للرقابة المالية
د/ محمد فريد صالح$b2$
  FROM laws WHERE law_no = 160 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-08-25', 'active' FROM ins2;

DO $verify136$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 160 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[136] القرار 160/2023 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 3 THEN RAISE EXCEPTION '[136] عدد المواد % بدل 3', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2023-08-25';
  IF v_v <> 3 THEN RAISE EXCEPTION '[136] عدد النسخ % بدل 3', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%رقم الإيداع%' OR body LIKE '%الأميرية%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[136] % مادة بها تلف أو ترويسة أو بيانات مطبعة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%القانون رقم 10 لسنة 2009%' AND body LIKE '%القانون رقم 18 لسنة 2020%' AND body LIKE '%بتاريخ 2023/7/26 ؛%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[136] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE '%نسبة (50٪) من مجموع دخله الشهرى%' AND body LIKE '%نشاط التمويل الاستهلاكى%') THEN RAISE EXCEPTION '[136] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE '%من اليوم التالى لتاريخ نشره بالوقائع المصرية%' AND body LIKE '%د/ محمد فريد صالح' AND length(body) < 400) THEN RAISE EXCEPTION '[136] المادة 2 غير سليمة'; END IF;
  IF v_len <> 570 THEN RAISE EXCEPTION '[136] إجمالى طول المواد % بدل 570', v_len; END IF;
  RAISE NOTICE '[136] القرار 160/2023: 3 مواد (ديباجة + مادتان) و3 نسخ، إجمالى % حرف', v_len;
END
$verify136$;

COMMIT;
