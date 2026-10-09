-- 137_replace_pm_decision_4664_2022_carbon_certificates_voluntary_market_single_article_with_preamble_two_articles_and_two_added_regulation_articles.sql
--
-- إعادة رفع قرار رئيس مجلس الوزراء رقم (4664) لسنة 2022 بتعديل بعض أحكام اللائحة التنفيذية لقانون سوق
-- رأس المال الصادرة بقرار وزير الاقتصاد والتجارة الخارجية رقم 135 لسنة 1993 (إضافة المادتين 35 مكرراً 7
-- و35 مكرراً 8: سوق طوعية لتداول شهادات خفض الانبعاثات الكربونية)، المنشور بالجريدة الرسمية، العدد 51
-- مكرر (د)، فى 25 ديسمبر 2022 (صفحتان 5–6).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P3) =====
-- مزروع بالهجرة 039 كمادة واحدة (article_no = 1، نحو 2834 حرفاً) تضم القرار كله بأرقام هندية، وبلا أى
-- نسخة فى article_versions (لا تاريخ سريان مسجَّل)، فكان استرجاع نص المادتين المضافتين (35 مكرراً 7/8)
-- لا يُمكّن من الاستشهاد بأى منهما ولا يخضع للتصفية بالتاريخ. (الهجرة 039 تُدرج المادة فقط عند إدراج
-- القرار نفسه فى laws؛ ON CONFLICT DO NOTHING على laws يمنع إعادة الإدراج، فلا تُعيد المادة القديمة.)
-- القرار ضمن نطاق الحوكمة؛ لا تُمس بيانات laws (enacted_at = 2022-12-25 قائم).
--
-- ===== المصدر والمنهجية =====
-- PDF الجريدة الرسمية (صفحتان) رفعه صاحب المشروع؛ رابط laws.official_url لم يُمس. أُصلح الـxref بـqpdf
-- وقوبل النص المستخرج بصورتى الصفحتين كلمة بكلمة. حُذفت ترويسة الجريدة ويُحفظ عنوان القرار فى
-- hierarchical_location للديباجة. فُصلت المادتان المضافتان إلى اللائحة فى قسمين مستقلين ليُستشهد بكل
-- منهما (35 مكرراً 7: السوق الطوعية وتعريف الشهادات والإخطار والإفصاح؛ 35 مكرراً 8: لجنة الإشراف
-- وقاعدة البيانات وقواعد التداول)، مع إبقاء نص كل منهما حرفياً كما فى المصدر (بما فى علامات التنصيص).
-- كل الأعداد (159/1981، 95/1992، 4/1994، 93/2000، 10/2009، 269/2018، 279/2018، 135/1993، 35 مكرراً
-- 7/8، 1444، 25 ديسمبر 2022) موجودة كلها فى النص القديم ولا عدد جديد فى الجديد.
--
-- ===== الهيكل =====
-- 5 مواد، 5 نسخ (version_no = 1): ديباجة (article_no = 0)، المادة الأولى (جملة الإضافة)، المادة الثانية
-- (النشر والنفاذ والتوقيع)، ثم قسمان للمادتين المضافتين (3 و4) يميزهما hierarchical_location وعنوانهما.
-- أُبقى رقم المادة 1 للمادة الأولى مواءمة للقديم.
--
-- ===== التاريخ =====
-- effective_from = 2022-12-26: المادة الثانية تُعمل القرار من اليوم التالى لتاريخ نشره بالجريدة
-- الرسمية، والنشر فى 25 ديسمبر 2022. (القديم بلا نسخ.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (5 مواد بديباجة سليمة والقسم 4 موجود)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، محتوى،
-- ترويسة متبقية، إجمالى الطول 2451 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix137$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 4664 AND law_year = 2022 AND kind = 'pm_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[137] القرار 4664/2022 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 5
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[137] القرار 4664/2022 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[137] أُزيلت % مادة من القرار 4664/2022 (مادة واحدة تضم القرار كله بلا نسخ)', v_n;
  END IF;
END
$fix137$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار رئيس مجلس الوزراء رقم 4664 لسنة 2022 بتعديل بعض أحكام اللائحة التنفيذية لقانون سوق رأس المال الصادرة بقرار وزير الاقتصاد والتجارة الخارجية رقم 135 لسنة 1993$h0$, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على الدستور ؛
وعلى قانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد الصادر بالقانون رقم 159 لسنة 1981 ؛
وعلى قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992 ؛
وعلى قانون البيئة الصادر بالقانون رقم 4 لسنة 1994 ؛
وعلى قانون الإيداع والقيد المركزى للأوراق والأدوات المالية الصادر بالقانون رقم 93 لسنة 2000 ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قرار رئيس الجمهورية رقم 269 لسنة 2018 بتشكيل الوزارة ؛
وعلى قرار رئيس الجمهورية رقم 279 لسنة 2018 بتفويض رئيس مجلس الوزراء فى بعض الاختصاصات ؛
وعلى اللائحة التنفيذية لقانون سوق رأس المال الصادرة بقرار وزير الاقتصاد والتجارة الخارجية رقم 135 لسنة 1993 ؛
وبعد أخذ رأى كل من الهيئة العامة للرقابة المالية وجهاز شئون البيئة ؛
قرر :$b0$
  FROM laws WHERE law_no = 4664 AND law_year = 2022 AND kind = 'pm_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-26', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$يضاف إلى اللائحة التنفيذية لقانون سوق رأس المال المشار إليها مادتان جديدتان برقمى (35 مكررا 7 ، 35 مكررا 8) نصهما الآتى :$b1$
  FROM laws WHERE law_no = 4664 AND law_year = 2022 AND kind = 'pm_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-26', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$ينشر هذا القرار فى الجريدة الرسمية ، ويعمل به من اليوم التالى لتاريخ نشره .
صدر برئاسة مجلس الوزراء فى غرة جمادى الآخرة سنة 1444 ه .
الموافق 25 ديسمبر سنة 2022 م .
رئيس مجلس الوزراء
دكتور/ مصطفى كمال مدبولى$b2$
  FROM laws WHERE law_no = 4664 AND law_year = 2022 AND kind = 'pm_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-26', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $h3$المادة الأولى من قرار رئيس مجلس الوزراء رقم 4664 لسنة 2022 - مادة مضافة إلى اللائحة التنفيذية لقانون سوق رأس المال (قرار وزير الاقتصاد والتجارة الخارجية رقم 135 لسنة 1993)$h3$, $t3$المادة (35 مكررا 7) المضافة إلى اللائحة التنفيذية لقانون سوق رأس المال - السوق الطوعية لشهادات خفض الانبعاثات الكربونية$t3$, $b3$مادة (35 مكررا 7) :
تنشأ بالبورصة المصرية سوق طوعية لتداول "شهادات خفض الانبعاثات الكربونية" .
وتعد تلك الشهادات أدوات مالية قابلة للتداول ، ويقصد بها "وحدات خفض انبعاثات غازات الاحتباس الحرارى ، وتصدر لصالح أية جهة تنفذ مشروعات خفض انبعاثات غازات الاحتباس الحرارى بعد الحصول على موافقة الجهات المعنية ذات الاختصاص ، وتمثل كل "وحدة" طنا من ثانى أكسيد الكربون المكافئ تم تخفيضه .
وتلتزم كافة الجهات الحكومية وقطاع الأعمال العام والقطاع الخاص وكافة مطورى المشروعات بإخطار الهيئة ووزارة البيئة بجميع المشروعات التى سوف يصدر لها شهادات خفض الانبعاثات الكربونية .
وتلتزم الجهات المصدر لها شهادات خفض انبعاثات كربونية بالإفصاح عن أى أحداث أو تغيرات تطرأ بشأن الموافقات الصادرة لها من الجهات المعنية ذات الاختصاص طوال مدة الإصدار .$b3$
  FROM laws WHERE law_no = 4664 AND law_year = 2022 AND kind = 'pm_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-26', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $h4$المادة الأولى من قرار رئيس مجلس الوزراء رقم 4664 لسنة 2022 - مادة مضافة إلى اللائحة التنفيذية لقانون سوق رأس المال (قرار وزير الاقتصاد والتجارة الخارجية رقم 135 لسنة 1993)$h4$, $t4$المادة (35 مكررا 8) المضافة إلى اللائحة التنفيذية لقانون سوق رأس المال - لجنة الإشراف وقاعدة البيانات وقواعد التداول$t4$, $b4$مادة (35 مكررا 8) :
تشكل بقرار من مجلس إدارة الهيئة بالتنسيق مع وزارة البيئة لجنة تضم فى عضويتها ممثلين عن الجهات المعنية ، تسمى "لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية" تتولى وضع القواعد الخاصة بإصدار شهادات خفض الانبعاثات الكربونية وإتاحتها للتداول ، والإشراف والرقابة عليها ويحدد القرار الصادر بتشكيل اللجنة اختصاصاتها ونظام عملها .
وتعد الهيئة قاعدة بيانات لتسجيل المشروعات التى صدر لها شهادات خفض الانبعاثات الكربونية ، وتقوم بموافاة وزارة البيئة بتلك المشروعات بصورة شهرية .
وتصدر البورصة المصرية قواعد وإجراءات التداول على تلك الشهادات ، على ألا تكون سارية إلا بعد اعتمادها من الهيئة .$b4$
  FROM laws WHERE law_no = 4664 AND law_year = 2022 AND kind = 'pm_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-26', 'active' FROM ins4;

DO $verify137$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 4664 AND law_year = 2022 AND kind = 'pm_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[137] القرار 4664/2022 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 5 THEN RAISE EXCEPTION '[137] عدد المواد % بدل 5', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2022-12-26';
  IF v_v <> 5 THEN RAISE EXCEPTION '[137] عدد النسخ % بدل 5', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الجريدة الرسمية – العدد%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[137] % مادة بها تلف أو ترويسة أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND body LIKE 'بعد الاطلاع على الدستور%' AND body LIKE '%159 لسنة 1981%' AND body LIKE '%95 لسنة 1992%' AND body LIKE '%4 لسنة 1994%' AND body LIKE '%93 لسنة 2000%' AND body LIKE '%269 لسنة 2018%' AND body LIKE '%279 لسنة 2018%' AND body LIKE '%135 لسنة 1993%' AND body LIKE '%جهاز شئون البيئة%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[137] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE '%مادتان جديدتان برقمى (35 مكررا 7 ، 35 مكررا 8)%') THEN RAISE EXCEPTION '[137] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND body LIKE '%مادة (35 مكررا 7)%' AND body LIKE '%سوق طوعية%' AND body LIKE '%طنا من ثانى أكسيد الكربون المكافئ%' AND body LIKE '%طوال مدة الإصدار .%') THEN RAISE EXCEPTION '[137] المادة 35 مكررا 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND body LIKE '%مادة (35 مكررا 8)%' AND body LIKE '%لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية%' AND body LIKE '%بصورة شهرية%' AND body LIKE '%اعتمادها من الهيئة .%') THEN RAISE EXCEPTION '[137] المادة 35 مكررا 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE '%من اليوم التالى لتاريخ نشره%' AND body LIKE '%مصطفى كمال مدبولى' AND length(body) < 400) THEN RAISE EXCEPTION '[137] المادة 2 غير سليمة'; END IF;
  IF v_len <> 2451 THEN RAISE EXCEPTION '[137] إجمالى طول المواد % بدل 2451', v_len; END IF;
  RAISE NOTICE '[137] القرار 4664/2022: 5 مواد (ديباجة + مادتان + مادتان مضافتان) و5 نسخ، إجمالى % حرف', v_len;
END
$verify137$;

COMMIT;
