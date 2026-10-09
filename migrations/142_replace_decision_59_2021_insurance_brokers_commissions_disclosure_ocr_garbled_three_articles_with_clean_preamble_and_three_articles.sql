-- 142_replace_decision_59_2021_insurance_brokers_commissions_disclosure_ocr_garbled_three_articles_with_clean_preamble_and_three_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (59) لسنة 2021 (بتاريخ 2021/4/4) بشأن
-- ضوابط الإفصاح عن قيمة العمولات المستحقة لوسطاء التأمين (ملف PDF من صفحة واحدة من موقع الهيئة).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2) =====
-- مخزَّن منذ الهجرة 006 بثلاث مواد من تفريغ مسح ضوئى (OCR) تالف: المادة الأولى (إلغاء القرار 181/2019)
-- بتاريخ مشوَّه ("رقم )١8١( لسنة 7٠١15")، والمادة الثانية سليمة نسبياً لكن بنقطتين رأسيتين بدل الفاصلة،
-- والمادة الثالثة ملتصق بها توقيع مشوَّه ("2 ئيس عجلس إدارة العينة") وتذييل الهيئة (العنوان والهاتف
-- والفاكس) مشوَّهاً بالأرقام والرموز، وبلا ديباجة (أساس الإصدار: القانونان 10/1981 و10/2009، القرار
-- 181/2019، حكما القضاء الإدارى، جلسة المجلس). نسخ article_versions القديمة تحمل effective_from =
-- تاريخ تشغيل البذر لا تاريخ سريان القرار. القرار ضمن نطاق الحوكمة (governance_scope = true)؛ لم تُمس
-- بيانات laws (enacted_at فارغ، ويُترك لهجرة بيانات laws لاحقة).
--
-- ===== المصدر والمنهجية =====
-- PDF رفعه صاحب المشروع (مسح ضوئى بلا طبقة نصية، 59.pdf وهو نفسه laws.official_url). قُرئت الصفحة بصرياً
-- بتكبير 220 dpi (وجزء الدعويين بتكبير 400 dpi) وقوبلت بالنص المخزَّن كلمةً كلمة. الأرقام الهندية حُوِّلت
-- إلى لاتينية: القانونان 10/1981 و10/2009، القرار 181/2019، الدعويان 33824 و37071 لسنة 74ق،
-- جلسة 2021/4/4. حُذفت ترويسة الهيئة ("رئيس الهيئة" والشعار) وتذييل العنوان والهاتف وختم مكتب
-- رئيس الهيئة ورقمه، ويُحفظ عنوان القرار وتاريخه فى hierarchical_location للديباجة. أُبقى إملاء
-- المصدر (الياء بدل الألف المقصورة: "في"، "الالكتروني"، "التي") وأُسقطت علامات الضمة الصغيرة
-- ("يُلغى" و"يُنشر" و"يُعمل") وأُبقى تنوين الفتح. فاصلة المصدر المنقوطة (؛) كما هى.
--
-- ===== الهيكل =====
-- 4 مواد، 4 نسخ (version_no = 1): ديباجة (article_no = 0) بأربعة اطلاعات وجلسة المجلس، المادة الأولى
-- (إلغاء القرار 181/2019)، المادة الثانية (إدراج قيمة ونسب العمولات الأساسية بإيصالات وإخطارات السداد
-- وحفظ صورة موقعة من العميل)، المادة الثالثة (النشر والعمل من اليوم التالى للنشر، مع التوقيع). أُبقيت
-- المواد 1-3 بأرقامها حتى لا يعيد بذر 006 إدراج مواد قديمة (ON CONFLICT DO NOTHING).
--
-- ===== التاريخ =====
-- effective_from = 2021-04-04 (تاريخ القرار وجلسة المجلس). المادة الثالثة تُعمل القرار من اليوم التالى
-- لتاريخ نشره بالوقائع المصرية، وتاريخ النشر غير وارد فى الملف المرفوع (نسخة الموقع) فلم يُخمَّن؛
-- فإذا عُرف عدد الوقائع صُحِّح التاريخ إلى اليوم التالى للنشر.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (4 مواد بديباجة سليمة والمادة 3 موجودة)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، توقيع أو
-- تذييل OCR متبقٍ، محتوى، إجمالى الطول 1082 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix142$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 59 AND law_year = 2021 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[142] القرار 59/2021 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 4
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[142] القرار 59/2021 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[142] أُزيلت % مادة من القرار 59/2021 (تفريغ OCR تالف بلا ديباجة)', v_n;
  END IF;
END
$fix142$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 59 لسنة 2021 بتاريخ 2021/4/4 بشأن ضوابط الإفصاح عن قيمة العمولات المستحقة لوسطاء التأمين$h0$, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على القانون رقم (10) لسنة 1981 بشأن الإشراف والرقابة على التأمين ولائحته التنفيذية؛
وعلى القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وعلى قرار مجلس إدارة الهيئة رقم (181) لسنة 2019 بشأن ضوابط الإفصاح عن قيمة العمولات المستحقة لوسطاء التأمين؛
وعلى حكمي محكمة القضاء الإداري الصادرين في الدعويين رقمي (33824، 37071) لسنة 74ق؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2021/4/4؛
قرر$b0$
  FROM laws WHERE law_no = 59 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-04-04', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$يلغى قرار مجلس إدارة الهيئة رقم (181) لسنة 2019 المشار إليه.$b1$
  FROM laws WHERE law_no = 59 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-04-04', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$تلتزم شركات التأمين بإدراج قيمة ونسب العمولات الأساسية المستحقة لوسطاء التأمين ضمن البيانات الواردة بإيصالات أو إخطارات السداد المعمول بها لكل شركة والمتضمنة رقم الوثيقة وقيمة القسط المطلوب وذلك عن كل مطالبة بالأقساط المستحقة للشركة عن تلك الوثائق، وعلى أن تحتفظ الشركة بملف الإصدار لديها بصورة من الإيصال أو الإخطار موقعاً من العميل بما يفيد قيامه بالاستلام وعلى مسئولية الشركة، وذلك كله وفقاً للضوابط التي تصدرها الهيئة.$b2$
  FROM laws WHERE law_no = 59 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-04-04', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3$المادة الثالثة$t3$, $b3$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الالكتروني للهيئة، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة الهيئة
د. محمد عمران$b3$
  FROM laws WHERE law_no = 59 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-04-04', 'active' FROM ins3;

DO $verify142$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 59 AND law_year = 2021 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[142] القرار 59/2021 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 4 THEN RAISE EXCEPTION '[142] عدد المواد % بدل 4', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2021-04-04';
  IF v_v <> 4 THEN RAISE EXCEPTION '[142] عدد النسخ % بدل 4', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%عجلس%' OR body LIKE '%العينة%' OR body LIKE '%تليفون%' OR body LIKE '%البريدى%' OR body LIKE '%FRA%' OR body LIKE '%7٠١%' OR body LIKE '%لاه ألبيلة%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[142] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%القانون رقم (10) لسنة 1981%' AND body LIKE '%القانون رقم (10) لسنة 2009%' AND body LIKE '%قرار مجلس إدارة الهيئة رقم (181) لسنة 2019%' AND body LIKE '%الدعويين رقمي (33824، 37071) لسنة 74ق؛%' AND body LIKE '%بتاريخ 2021/4/4؛%' AND body LIKE '%قرر') THEN RAISE EXCEPTION '[142] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE 'يلغى قرار مجلس إدارة الهيئة رقم (181) لسنة 2019 المشار إليه.') THEN RAISE EXCEPTION '[142] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE 'تلتزم شركات التأمين بإدراج قيمة ونسب العمولات الأساسية%' AND body LIKE '%رقم الوثيقة وقيمة القسط المطلوب%' AND body LIKE '%موقعاً من العميل%' AND body LIKE '%على مسئولية الشركة%' AND body LIKE '%تصدرها الهيئة.') THEN RAISE EXCEPTION '[142] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية%' AND body LIKE '%من اليوم التالي لتاريخ نشره بالوقائع المصرية.%' AND body LIKE '%د. محمد عمران') THEN RAISE EXCEPTION '[142] المادة 3 غير سليم'; END IF;
  IF v_len <> 1082 THEN RAISE EXCEPTION '[142] إجمالى طول المواد % بدل 1082', v_len; END IF;
  RAISE NOTICE '[142] القرار 59/2021: 4 مواد و4 نسخ، إجمالى % حرف', v_len;
END
$verify142$;

COMMIT;
