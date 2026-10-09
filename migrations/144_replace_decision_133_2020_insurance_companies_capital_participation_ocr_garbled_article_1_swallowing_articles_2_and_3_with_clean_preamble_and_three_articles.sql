-- 144_replace_decision_133_2020_insurance_companies_capital_participation_ocr_garbled_article_1_swallowing_articles_2_and_3_with_clean_preamble_and_three_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (133) لسنة 2020 (بتاريخ 2020/8/16) بشأن
-- ضوابط المساهمة فى رأس مال شركات التأمين (ملف PDF من صفحتين من موقع الهيئة).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2) =====
-- مخزَّن منذ الهجرات 004/005/006 من تفريغ مسح ضوئى (OCR) تالف: المادة الأولى ابتلعت المادة الثانية وبداية
-- الثالثة وتذييل الهيئة (العنوان والهاتف والفاكس) مشوَّهاً، والمادتان 2 و3 مكررتان بصفوف مستقلة (الثالثة تحمل
-- التذييل المشوَّه)، وبلا ديباجة. والأخطر أن أرقام المواد والقرارات مقروءة خطأً: "قرار مجلس إدارة الهيئة رقم
-- (57) لسنة 7٠١١4" بينما الصحيح فى المصدر القرار رقم (53) لسنة 2018، و"المادتين (0؟ مكرراً 21 ٠ 4)" والصحيح
-- (27 مكرراً 1، 40)، و"(9075!)" والصحيح (25%)، و"أسسهم" الخ. وهى بيانات
-- جوهرية (نسبة التملك المسموحة وسند الإصدار) فكان الاستشهاد بها يعطى أرقاماً مضللة. نسخ article_versions
-- القديمة بتاريخ تشغيل البذر. لا تُمس بيانات laws (enacted_at فارغ؛ ويُترك لهجرة بيانات laws لاحقة).
--
-- ===== المصدر والمنهجية =====
-- PDF رفعه صاحب المشروع (مسح ضوئى بلا طبقة نصية؛ الاسم UG51302UG51303.pdf وهو نفسه laws.official_url).
-- قُرئت الصفحتان بصرياً (130 dpi، والبنود الرقمية بتكبير 300 dpi) وقوبلتا بالنص المخزَّن. الأرقام الهندية
-- حُوِّلت إلى لاتينية: القانون 10/1981، القانون 10/2009، قرار وزير الاستثمار والتعاون الدولى 112/2018، قرار
-- المجلس 53/2018، المادتان 27 مكرراً 1 و40 من قانون الإشراف والرقابة على التأمين، النسبة 25%، ومدتا الاندماج
-- (سنة) والبيع (ستة أشهر). حُذفت ترويسة الهيئة وتذييل العنوان والهاتف وختم ورقم مكتب رئيس الهيئة،
-- ويُحفظ عنوان القرار وتاريخه فى hierarchical_location للديباجة. أُبقى إملاء المصدر بما فيه هفواته المطبعية ("الالكتروني" و"ويمفردهم" و"وينسبة" كما وردتا فى الصورة بنقطتين تحت الحرف؛ تحققت منها بتكبير 500 dpi) وأُسقطت
-- علامات التشكيل الصغيرة وأُبقى تنوين الفتح. التوقيع داخل المادة الثالثة.
--
-- ===== الهيكل =====
-- 4 مواد، 4 نسخ (version_no = 1): ديباجة (article_no = 0) بأربعة اطلاعات وجلسة المجلس، المادة الأولى
-- (حظر المساهمة بحصة مسيطرة فى أكثر من شركة تأمين مع استثناء الاندماج وجزاء المخالفة)، المادة الثانية (تعريف
-- الحصة المسيطرة)، المادة الثالثة (النشر والعمل من اليوم التالى للنشر، مع التوقيع). أُبقيت المواد 1–3
-- بأرقامها حتى لا تعيد بذور 004/005/006 إدراج مواد قديمة (ON CONFLICT DO NOTHING).
--
-- ===== التاريخ =====
-- effective_from = 2020-08-16 (تاريخ القرار وجلسة المجلس). المادة الثالثة تُعمل القرار من اليوم التالى
-- لتاريخ نشره بالوقائع المصرية، وتاريخ النشر غير وارد فى الملف (نسخة الموقع) فلم يُخمَّن؛ فإذا عُرف عدد
-- الوقائع صُحِّح التاريخ إلى اليوم التالى للنشر.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (4 مواد بديباجة سليمة والمادة 3 موجودة)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، بقايا OCR أو
-- تذييل، الأرقام الجوهرية، إجمالى الطول 2116 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix144$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 133 AND law_year = 2020 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[144] القرار 133/2020 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 4
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[144] القرار 133/2020 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[144] أُزيلت % مادة من القرار 133/2020 (مادة أولى ابتلعت المادتين 2 و3 مع بقايا OCR وأرقام خاطئة)', v_n;
  END IF;
END
$fix144$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (133) لسنة 2020 بتاريخ 2020/8/16 بشأن ضوابط المساهمة في رأس مال شركات التأمين$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون الإشراف والرقابة على التأمين في مصر الصادر بالقانون رقم (10) لسنة 1981 ولائحته التنفيذية؛
وعلى القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وعلى قرار وزير الاستثمار والتعاون الدولي رقم (112) لسنة 2018 بتحديد نسبة ما تمتلكه شركات التأمين وإعادة التأمين من أسهم في الشركات؛
وعلى قرار مجلس إدارة الهيئة رقم (53) لسنة 2018 بشأن ضوابط منح الترخيص واستمراره وقواعد تملك أسهم الشركات العاملة في الأنشطة المالية غير المصرفية؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2020/8/16؛
قرر$b0_0$
  FROM laws WHERE law_no = 133 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-08-16', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$مع عدم الإخلال بأحكام المادتين (27 مكرراً 1، 40) من قانون الإشراف والرقابة على التأمين في مصر وقرار مجلس إدارة الهيئة رقم (53) لسنة 2018 بشأن ضوابط منح الترخيص واستمراره وقواعد تملك أسهم الشركات العاملة في الأنشطة المالية غير المصرفية، لا يجوز للأشخاص الطبيعيين أو الاعتباريين الذين يتملكون حصة مسيطرة في إحدى شركات التأمين، المساهمة بشكل مباشر أو غير مباشر ويمفردهم أو من خلال أطرافهم المرتبطة، إلا في شركة تأمين واحدة أخرى تزاول ذات النشاط وينسبة تقل عن (25%) من أسهم تلك الشركة أو حقوق التصويت بها.
ويجوز زيادة نسبة المساهمة بما يجاوز النسبة المذكورة بالفقرة السابقة إذا اقترن طلب التملك بتقديم خطة ملزمة لاندماج شركتي التأمين المشار إليهما، على أن يتم تنفيذ عملية الاندماج خلال سنة بحد أقصى من تاريخ تقديم الطلب ووفقاً للشروط التي يقرها مجلس إدارة الهيئة في هذا الشأن.
وفي حال مخالفة الفقرة السابقة، توقف حقوق التصويت وتوزيعات الأرباح الخاصة بالأسهم الزائدة على النسبة المصرح بها، ويتعين على المخالف التصرف في النسبة الزائدة خلال ستة أشهر من تاريخ أيلولتها إليه، وإلا كان للهيئة الأمر بتعيين إحدى شركات السمسرة لتولي إجراءات بيع الأسهم المخالفة، على أن تؤول حصيلة البيع للمساهم بعد خصم المصروفات.$b1_0$
  FROM laws WHERE law_no = 133 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-08-16', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$يقصد بالحصة المسيطرة في تطبيق أحكام هذا القرار، استحواذ الشخص الطبيعي أو الاعتباري لأي نسبة في رأس المال أو حقوق التصويت بطريقة مباشرة أو غير مباشرة تمكنه من تعيين غالبية أعضاء مجلس إدارة الشركة أو التحكم على أي نحو في القرارات التي يصدرها مجلس إدارتها أو التحكم في القرارات التي تصدر عن جمعيتها العامة.$b2_0$
  FROM laws WHERE law_no = 133 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-08-16', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الالكتروني للهيئة، ويعمل به اعتباراً من اليوم التالي لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة الهيئة
د. محمد عمران$b3_0$
  FROM laws WHERE law_no = 133 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-08-16', 'active' FROM ins3_0;

DO $verify144$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 133 AND law_year = 2020 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[144] القرار 133/2020 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 4 THEN RAISE EXCEPTION '[144] عدد المواد % بدل 4', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2020-08-16';
  IF v_v <> 4 THEN RAISE EXCEPTION '[144] عدد النسخ % بدل 4', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%7٠١١4%' OR body LIKE '%(57)%' OR body LIKE '%أسسهم%' OR body LIKE '%القرية الذكية%' OR body LIKE '%البريدى%' OR body LIKE '%تليفون%' OR body LIKE '%FRA%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[144] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%القانون رقم (10) لسنة 1981%' AND body LIKE '%القانون رقم (10) لسنة 2009%' AND body LIKE '%رقم (112) لسنة 2018%' AND body LIKE '%رقم (53) لسنة 2018%' AND body LIKE '%بتاريخ 2020/8/16؛%' AND body LIKE '%قرر') THEN RAISE EXCEPTION '[144] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'مع عدم الإخلال بأحكام المادتين (27 مكرراً 1، 40)%' AND body LIKE '%رقم (53) لسنة 2018%' AND body LIKE '%تقل عن (25%) من أسهم تلك الشركة%' AND body LIKE '%خطة ملزمة لاندماج%' AND body LIKE '%خلال سنة بحد أقصى%' AND body LIKE '%خلال ستة أشهر من تاريخ أيلولتها إليه%' AND body LIKE '%بعد خصم المصروفات.') THEN RAISE EXCEPTION '[144] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يقصد بالحصة المسيطرة%' AND body LIKE '%جمعيتها العامة.') THEN RAISE EXCEPTION '[144] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية%' AND body LIKE '%من اليوم التالي لتاريخ نشره بالوقائع المصرية.%' AND body LIKE '%د. محمد عمران') THEN RAISE EXCEPTION '[144] المادة 3 غير سليم'; END IF;
  IF v_len <> 2116 THEN RAISE EXCEPTION '[144] إجمالى طول المواد % بدل 2116', v_len; END IF;
  RAISE NOTICE '[144] القرار 133/2020: 4 مواد و4 نسخ، إجمالى % حرف', v_len;
END
$verify144$;

COMMIT;
