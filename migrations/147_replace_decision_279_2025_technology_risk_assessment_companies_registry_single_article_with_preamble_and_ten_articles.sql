-- 147_replace_decision_279_2025_technology_risk_assessment_companies_registry_single_article_with_preamble_and_ten_articles.sql
--
-- إعادة هيكلة قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (279) لسنة 2025 (موافقة المجلس بتاريخ 2025/11/26،
-- منشور بالوقائع المصرية العدد 295 تابع (ج) فى 30 ديسمبر 2025) بشأن إنشاء سجل لدى الهيئة لقيد الشركات التى توفر أنظمة
-- تكنولوجية لتقييم المخاطر لأغراض التمويل غير المصرفى.
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2 - المجموعة أ) =====
-- مخزَّن بالهجرة 042 كمادة واحدة (article_no = 1، 6564 حرفاً) تحوى القرار كله (عشر مواد وتوقيع)، بلا ديباجة مستقلة ولا
-- مواد ولا صف article_versions. والمتن نفسه سليم (طبقة نصية حقيقية) لكنه ملوَّث بترويسات صفحات الوقائع ("الوقائع المصریة –
-- العدد 295 تابع )ج( فى 30 دیسمبر سنة 2025") وأرقام الصفحات (3-7) وكلمة "قرارات" داخل المتن بأرقام هندية، وتنوين منفصل
-- ("مملوك ًا" و"مرفق ًـا" و"وفق ًا")، فيضعف الاسترجاع ويمتنع الاستشهاد بمادة بعينها.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (5 صفحات، قُدِّم من صاحب المشروع). قوبل المتن المخزَّن بطبقة النص المستخرجة (تطبيع NFKC وإزالة علامات
-- الاتجاه والأرقام الهندية) كلمة بكلمة فتطابقا تماماً (1030 كلمة)، ثم قُرئت الصفحات (1 و2 و3 و5 بصرياً بـ130 dpi، والرابعة
-- بالنص) للتأكد من الأرقام الجوهرية: القوانين 148/2001 و80/2002 و10/2009 و141/2014 و176/2018 و18/2020 و5/2022،
-- قرار المجلس 244/2023، جلسة 2025/11/26، رأس المال 10 ملايين جنيه، حقوق الملكية 20 مليون جنيه أو (50%) لشركة تقدم حلولاً
-- تكنولوجية، ثلاث سنوات سابقة، مقابل الفحص 25 ألف جنيه، ثلاثون يوماً للبت، ثلاثة أشهر للتجديد، تقرير ربع سنوى، سنة للإيقاف
-- المؤقت، من ستة أشهر إلى خمس سنوات للشطب، ستة أشهر للتوفيق. حُذفت ترويسات الصفحات وأرقامها وكلمة "قرارات"، وفُكَّت علامات
-- التنوين المنفصلة ("مملوكاً" و"مرفقاً" و"وفقاً" و"يوماً"). أُبقى إملاء المصدر (الياء غير المنقوطة "ى" فى "المصرفى" و"يلى" وغيرهما،
-- و"المصرفي" بالياء فى المادة 1، "المسئول"، المسافة قبل علامات الترقيم، "د.محمد" بلا مسافة). الأرقام لاتينية. أُسقطت علامات
-- التشكيل الصغيرة وأُبقى تنوين الفتح. التوقيع داخل المادة العاشرة (رئيس مجلس إدارة الهيئة العامة للرقابة المالية، د.محمد فريد
-- صالح). عنوان القرار (وموافقة المجلس) فى hierarchical_location للديباجة، وعنوان كل مادة (إنشاء السجل، شروط القيد ...) فى عنوانها.
--
-- ===== الهيكل =====
-- 11 صفاً، 11 نسخة (version_no = 1): ديباجة (article_no = 0) بتسعة اطلاعات وجلسة المجلس، والمواد 1–10: إنشاء السجل، شروط
-- القيد، إجراءات القيد، البت فى الطلب (30 يوماً)، مدة القيد وتجديدها، التزامات الشركات المقيدة، اعتماد الأنظمة التكنولوجية لشركات
-- وجهات التمويل، التدابير الإدارية، توفيق الأوضاع، النشر والتوقيع. المفتاح (1، 0) محفوظ حتى لا تعيد بذرة 042 إدراج المادة القديمة
-- (إدراج laws فيها ON CONFLICT DO NOTHING فلا تُرجع id لقانون موجود فلا تُدرج مواد).
--
-- ===== التاريخ =====
-- effective_from = 2025-12-31 (اليوم التالى لنشر الوقائع فى 30/12/2025، وفق المادة العاشرة: "ويعمل به من اليوم التالى لتاريخ
-- نشره بالوقائع المصرية"). لا تُمس بيانات laws (enacted_at = 2025-12-30 هو تاريخ النشر لا الإصدار؛ يُصحَّح فى هجرة laws لاحقة إن لزم).
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (11 صفاً بديباجة سليمة والمادة 10 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام
-- محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، بقايا ترويسة أو تنوين منفصل، محتوى المواد، إجمالى الطول 5300 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix147$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[147] القرار 279/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 11
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[147] القرار 279/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[147] أُزيلت % مادة من القرار 279/2025 (القرار كله فى مادة واحدة بترويسات صفحات وأرقام وتنوين منفصل)', v_n;
  END IF;
END
$fix147$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 279 لسنة 2025 (موافقة المجلس بتاريخ 2025/11/26، منشور بالوقائع المصرية العدد 295 تابع (ج) فى 2025/12/30) بشأن إنشاء سجل لدى الهيئة لقيد الشركات التى توفر أنظمة تكنولوجية لتقييم المخاطر لأغراض التمويل غير المصرفى$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون التمويل العقارى الصادر بالقانون رقم 148 لسنة 2001 ولائحته التنفيذية ؛
وعلى قانون مكافحة غسل الأموال الصادر بالقانون رقم 80 لسنة 2002 ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى القانون رقم 141 لسنة 2014 بتنظيم مزاولة نشاط تمويل المشروعات المتوسطة والصغيرة ومتناهية الصغر ؛
وعلى قانون تنظيم نشاطى التأجير التمويلى والتخصيم الصادر بالقانون رقم 176 لسنة 2018 ؛
وعلى قانون تنظيم نشاط التمويل الاستهلاكى الصادر بالقانون رقم 18 لسنة 2020 ؛
وعلى قانون تنظيم وتنمية استخدام التكنولوجيا المالية فى الأنشطة المالية غير المصرفية الصادر بالقانون رقم 5 لسنة 2022 ؛
وعلى قرار مجلس إدارة الهيئة رقم 244 لسنة 2023 بشأن إعادة تنظيم ضوابط القيد واستمرار القيد والشطب فى سجل مراقبى الحسابات لدى الهيئة ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/11/26 ؛
قرر :$b0_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - إنشاء السجل$t1_0$, $b1_0$ينشأ بالهيئة سجل لقيد الشركات التى توفر أنظمة تكنولوجية لتقييم المخاطر لأغراض التمويل غير المصرفي ، ويتضمن السجل المعلومات والبيانات الرئيسية الخاصة بكل شركة يتم قيدها بالسجل ، وعلى وجه الأخص ما يلى :
1- اسم الشركة وشكلها القانونى وغرضها .
2- عنوان المركز الرئيسى لها .
3- اسم العضو المنتدب أو المسئول القائم على الإدارة بالشركة ، وممثلها القانونى .
4- بيانات التواصل .
ولا يجوز للشركات والجهات المرخص لها بمزاولة أنشطة التمويل غير المصرفى الاستعانة بغير الشركات المقيدة بالسجل لأغراض تقييم المخاطر المرتبطة بمنح التمويل لعملائها .
وتلتزم شركات وجهات التمويل غير المصرفى فى حال رغبتها فى التعاقد مع إحدى الشركات المقيدة بالسجل ، بإخطار الهيئة قبل إبرام التعاقد وموافاتها بصورة من العقد وكذا عند إدخال أى تعديل عليه أو عند انتهاء التعاقد .$b1_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - شروط القيد بالسجل$t2_0$, $b2_0$على الشركات الراغبة فى القيد بالسجل المشار إليه بالمادة الأولى من هذا القرار ، استيفاء الشروط الآتية :
1- أن يكون من ضمن أغراضها توفير الأنظمة التكنولوجية أو الحلول التقنية وأن يتفق غرض الشركة المثبت بالسجل التجارى مع الهدف من قيد الشركة لدى الهيئة .
2- ألا يقل رأس المال المصدر والمدفوع عن عشرة ملايين جنيه أو ما يعادله بالعملات الأجنبية ، وألا تقل حقوق الملكية عن رأس المال المدفوع .
3- ألا تقل مدة مزاولتها للنشاط عن ثلاث سنوات سابقة على طلب القيد فى السجل ، وفى حال عدم توافر تلك المدة يجب ألا تقل حقوق ملكية الشركة عن عشرين مليون جنيه أو أن يكون هيكل ملكيتها مملوكاً بنسبة لا تقل عن (50%) لإحدى الشركات التى تقدم حلول تكنولوجية لمدة لا تقل عن ثلاث سنوات سابقة على التقدم بطلب القيد .
4- تقديم القوائم المالية للشركة مرفقاً بها تقرير أحد مراقبى الحسابات من المقيدين بالقسم الأول من سجل مراقبى الحسابات المنظم بقرار مجلس إدارة الهيئة رقم 244 لسنة 2023 المشار إليه ، وتقبل القوائم المالية الفترية شريطة أن يصدر عنها تقرير مراجعة وليس تقرير فحص محدود .$b2_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - إجراءات القيد$t3_0$, $b3_0$على الشركات الراغبة فى القيد بالسجل أن تتقدم للهيئة بطلب بذلك ، مرفقاً به ما يلى :
1- نموذج الأعمال الرقمى الذى تستخدمه الشركة وتطبيقاته الإحصائية فى تحليل بيانات العملاء ، وذلك بمراعاة طبيعة نشاط التمويل غير المصرفى .
2- المنهجية والاستراتيجية التى اعتمد عليها نموذج الأعمال الرقمى فى بناء الخوارزميات وكذا الفرضيات والمعطيات التى اتبعها فى تحليل بيانات العملاء .
3- دليل يتضمن التوثيق الفنى للتجهيزات والبنية التكنولوجية وأنظمة المعلومات ووسائل الحماية والتأمين المستخدمة فى مزاولة النشاط .
4- سابقة أعمال الشركة .
5- ما يفيد سداد مقابل فحص ودراسة طلب القيد بالسجل وتجديده بواقع خمسة وعشرين ألف جنيه .
6- أى بيانات أو مستندات أخرى ترى الهيئة ضرورة تقديمها للبت فى الطلب .$b3_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - البت فى طلب القيد بالسجل$t4_0$, $b4_0$تقوم الهيئة بدراسة طلب القيد بالسجل ، وتبت فيه خلال ثلاثين يوماً من تاريخ استيفاء المتطلبات المشار إليها بهذا القرار والتحقق منها .$b4_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - مدة القيد بالسجل وتجديدها$t5_0$, $b5_0$تكون مدة القيد بالسجل ثلاث سنوات وتجدد لمدد مماثلة شريطة توافر شروط متطلبات القيد ، ويتم تقديم طلب تجديد القيد خلال الثلاثة أشهر السابقة على انتهاء مدة القيد .$b5_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - التزامات الشركات المقيدة بالسجل$t6_0$, $b6_0$تلتزم الشركات المقيدة بالسجل بما يلى :
1- مراعاة كافة القرارات والتعليمات ذات الصلة التى تصدرها الهيئة .
2- تمكين الهيئة من فحص الأنظمة التكنولوجية ونموذج الأعمال الذى تتبعه الشركة فى تحليل بيانات العملاء ، متى طلبت الهيئة ذلك .
3- المحافظة على السرية التامة للبيانات والمعلومات التى تطلع عليها ، سواء تلك التى يتم الحصول عليها بمعرفتها مباشرة أو من خلال شركات أو جهات التمويل ، وعدم إفشائها أو الإفصاح عنها لأى طرف آخر إلا فى الحالات التى تطلب فيها الهيئة تقديم معلومات محددة لها بشأنها .
4- تجنب حالات تعارض المصالح أو الشبهة بها مع الأطراف ذوى العلاقة .
5- موافاة الهيئة بتقرير ربع سنوى عن نتائج أعمالها على أن يتضمن على وجه الأخص ؛ بيان بالشركات والجهات التى تم التعاقد معها ، وكذا العملاء التى قامت الشركة بدراسة وتحليل بياناتهم ، والنتائج التى انتهت إليها فى هذا الشأن ، كما تلتزم الشركات المقيدة بالسجل بتقديم البيانات المشار إليها للهيئة كلما طلبت ذلك .$b6_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - اعتماد الأنظمة التكنولوجية الخاصة بشركات وجهات التمويل من الهيئة$t7_0$, $b7_0$يجوز للشركات والجهات المرخص لها بمزاولة أنشطة التمويل غير المصرفى استخدام أنظمتها التكنولوجية فى تقييم المخاطر لأغراض منح التمويل للعملاء ، شريطة اعتماد تلك الأنظمة ونموذج الأعمال الرقمى من الهيئة قبل العمل بهم .$b7_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة - التدابير الإدارية$t8_0$, $b8_0$لرئيس مجلس إدارة الهيئة حال مخالفة الشركة المقيدة بالسجل لأحد متطلبات القيد أو الالتزامات الملقاة عليها أو مخالفة أى من القرارات الصادرة عن الهيئة ذات الصلة ، اتخاذ أى من التدابير الآتية :
1- الإنذار .
2- الإيقاف المؤقت للقيد بالسجل لمدة لا تجاوز سنة .
3- شطب القيد من السجل ، مع عدم جواز إعادة القيد مرة أخرى إلا بعد انقضاء فترة لا تقل عن ستة أشهر ولا تزيد على خمس سنوات .
4- الشطب النهائى من السجل .$b8_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة - توفيق الأوضاع$t9_0$, $b9_0$تلتزم الشركات والجهات المرخص لها بمزاولة أنشطة التمويل غير المصرفى بتوفيق أوضاعها وفقاً لأحكام هذا القرار خلال ستة أشهر من تاريخ العمل به .$b9_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins9_0;

WITH ins10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $t10_0$المادة العاشرة$t10_0$, $b10_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د.محمد فريد صالح$b10_0$
  FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins10_0;

DO $verify147$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 279 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[147] القرار 279/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 11 THEN RAISE EXCEPTION '[147] عدد المواد % بدل 11', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-12-31';
  IF v_v <> 11 THEN RAISE EXCEPTION '[147] عدد النسخ % بدل 11', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%العدد 295%' OR body LIKE '%العدد ) 295%' OR body LIKE '%تابع )%' OR body LIKE '%دیسمبر%' OR body LIKE '%المصریة%' OR body LIKE '% ً%' OR body LIKE '%ـ%' OR body LIKE '%٢٠٢٥%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[147] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%رقم 148 لسنة 2001%' AND body LIKE '%رقم 80 لسنة 2002%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 141 لسنة 2014%' AND body LIKE '%رقم 176 لسنة 2018%' AND body LIKE '%رقم 18 لسنة 2020%' AND body LIKE '%رقم 5 لسنة 2022%' AND body LIKE '%رقم 244 لسنة 2023%' AND body LIKE '%بتاريخ 2025/11/26 ؛%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[147] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'ينشأ بالهيئة سجل لقيد الشركات%' AND body LIKE '%4- بيانات التواصل .%' AND body LIKE '%أو عند انتهاء التعاقد .') THEN RAISE EXCEPTION '[147] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'على الشركات الراغبة فى القيد بالسجل المشار إليه%' AND body LIKE '%عن عشرة ملايين جنيه%' AND body LIKE '%عن عشرين مليون جنيه%(50%)%ثلاث سنوات سابقة%' AND body LIKE '%وليس تقرير فحص محدود .') THEN RAISE EXCEPTION '[147] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'على الشركات الراغبة فى القيد بالسجل أن تتقدم%' AND body LIKE '%خمسة وعشرين ألف جنيه .%' AND body LIKE '%6- أى بيانات أو مستندات أخرى%للبت فى الطلب .') THEN RAISE EXCEPTION '[147] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'تقوم الهيئة بدراسة طلب القيد%' AND body LIKE '%خلال ثلاثين يوماً من تاريخ استيفاء المتطلبات%') THEN RAISE EXCEPTION '[147] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'تكون مدة القيد بالسجل ثلاث سنوات%' AND body LIKE '%خلال الثلاثة أشهر السابقة على انتهاء مدة القيد .') THEN RAISE EXCEPTION '[147] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات المقيدة بالسجل بما يلى :%' AND body LIKE '%1- مراعاة كافة القرارات%' AND body LIKE '%5- موافاة الهيئة بتقرير ربع سنوى%كلما طلبت ذلك .') THEN RAISE EXCEPTION '[147] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'يجوز للشركات والجهات المرخص لها%' AND body LIKE '%اعتماد تلك الأنظمة ونموذج الأعمال الرقمى من الهيئة قبل العمل بهم .') THEN RAISE EXCEPTION '[147] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'لرئيس مجلس إدارة الهيئة حال مخالفة%' AND body LIKE '%لمدة لا تجاوز سنة .%' AND body LIKE '%ستة أشهر ولا تزيد على خمس سنوات .%' AND body LIKE '%4- الشطب النهائى من السجل .') THEN RAISE EXCEPTION '[147] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات والجهات المرخص لها%' AND body LIKE '%خلال ستة أشهر من تاريخ العمل به .') THEN RAISE EXCEPTION '[147] المادة 9 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية%' AND body LIKE '%بالوقائع المصرية .%' AND body LIKE '%د.محمد فريد صالح') THEN RAISE EXCEPTION '[147] المادة 10 غير سليم'; END IF;
  IF v_len <> 5300 THEN RAISE EXCEPTION '[147] إجمالى طول المواد % بدل 5300', v_len; END IF;
  RAISE NOTICE '[147] القرار 279/2025: 11 مواد و11 نسخ، إجمالى % حرف', v_len;
END
$verify147$;

COMMIT;
