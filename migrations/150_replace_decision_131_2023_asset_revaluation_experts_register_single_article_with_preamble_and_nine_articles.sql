-- 150_replace_decision_131_2023_asset_revaluation_experts_register_single_article_with_preamble_and_nine_articles.sql
--
-- إعادة هيكلة قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (131) لسنة 2023 بتاريخ 2023/6/7 بشأن ضوابط القيد بسجل خبراء إعادة تقييم الأصول لدى الهيئة.
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2 - المجموعة أ) =====
-- مخزَّن بالهجرة 015 كمادة واحدة (article_no = 1، 5645 حرفاً) تحوى القرار كله (الديباجة والمواد التسع والتوقيع) بلا ديباجة مستقلة ولا مواد، فلا يمكن الاستشهاد بمادة
-- بعينها. والأهم أن المتن المخزَّن ليس مطابقاً لأصل القرار الصادر عن الهيئة: فيه تاريخ جلسة المجلس مكتوب "7/6/2023" (والأصل "2023/6/7")، وبالمادة 2/1 عبارة
-- "أو أن يكون مرخصاً له بأن يكون خبير تقييم" (والأصل "كخبير تقييم")، وبالمادة 2/4 "أو جنحة فى إحدى الجرائم الماسة بالشرف" (والأصل "أو جنحة في جريمة ماسة بالشرف، أو في إحدى الجرائم
-- المنصوص عليها...")، وبالمادة 3/1 "بسجل بيوت خبرة" (والأصل "بسجل بيوت الخبرة")، وبالمادة 4 جملة "من هذا القرار" فى غير موضعها، وبالمادة 8 "ادارة" بلا همزة، وإملاء "فى/في" و"المسئوليات/المسؤوليات" بما لا يطابق الأصل.
--
-- ===== المصدر والمنهجية =====
-- PDF الهيئة (3 صفحات، صورة ممسوحة ضوئياً بلا طبقة نصية، قدّمه صاحب المشروع). لا توجد طبقة نصية ولا OCR موثوق، فقُرئ القرار بصرياً من الصور بدقة 130 ثم 200 نقطة/بوصة مع
-- تكبير مقاطع حتى 5 أضعاف، وقوبل كلمة بكلمة بالنص المخزَّن (ومخرجات OCR كدليل مساعد فقط)، فصُحِّحت الفروق الجوهرية أعلاه. التحقق على مستوى الكلمات والأرقام (القوانين 159/1981 و95/1992 و10/2009
-- و194/2020، القرارات 110/2015 و39/2015 و1/2017 و114/2018، جلسة 2023/6/7، ثلاث سنوات، ثلاثون يوماً، عشرة آلاف وعشرون ألف جنيه، سنة) ثابت. فى الهمزات (أ/ا) والياء/الألف المقصورة اتُّبع الأصل
-- حيث وضح فى الصورة ("فى" فى مقدمتى المادتين 2 و3 كما هي، "في" فى باقى المواضع، "الايقاف" و"او" بلا همزة بالمادتين 5 و8، "الاختبارات" بلا همزة)، وما لم يُمكن حسمه بصرياً
-- (همزة الألف فى كلمات قليلة بدقة المسح 200 نقطة/بوصة) أُبقى على صورته الإملائية المعتادة؛ وهذا فرق إملائى لا يمس المعنى.
-- حُذف سطر "مجلس إدارة الهيئة العامة للرقابة المالية" (جهة الإصدار) من الديباجة ودُمج بعنوان القرار فى hierarchical_location، وحُذفت ترويسة كل صفحة (رئيس الهيئة، الشعار) وتذييلها (العنوان وأرقام الصفحات)
-- والأختام. أُبقي توقيع رئيس المجلس داخل المادة التاسعة. الأرقام لاتينية. أُسقطت علامات التشكيل الصغيرة وأُبقى تنوين الفتح.
--
-- ===== الهيكل =====
-- 10 صفوف، 10 نسخ (version_no = 1): ديباجة (article_no = 0) بثمانية اطلاعات وجلسة المجلس، والمواد 1–9: إنشاء السجل وأقسامه الثلاثة، شروط قيد الأشخاص الطبيعيين (5 بنود)، شروط قيد الأشخاص
-- الاعتباريين (4 بنود)، إجراءات الطلب ولجنة البت خلال 30 يوماً، المسئولية عن أعمال التقييم، شروط استمرار القيد (3 بنود)، مدة القيد ثلاث سنوات ومقابل الخدمات (عشرة آلاف جنيه للطبيعى وعشرون ألفاً للاعتبارى)،
-- التدابير الإدارية (تنبيه/إيقاف مؤقت حتى سنة/شطب)، والنشر والتوقيع. المفتاح (1، 0) محفوظ فلا تعيد بذرة 015 إدراج المادة القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج النسخة مبنى
-- على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2023-06-07: المادة التاسعة تعمل بالقرار "من اليوم التالي لتاريخ نشره بالوقائع المصرية"، وتاريخ النشر بالوقائع غير وارد فى نسخة الهيئة الممسوحة ولم نعثر عليه فى مصدر موثوق؛ فاعتُمد تاريخ
-- صدور القرار (2023/6/7، وهو ما كان عليه التاريخ المخزَّن) كقيمة مؤقتة معلنة، ويُصحَّح لاحقاً بهجرة صغيرة عند الوقوف على عدد الوقائع. لا يُخمَّن. لا تُمس بيانات laws.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (10 صفوف بديباجة سليمة والمادة 9 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، بقايا OCR أو ترويسة،
-- محتوى المواد، إجمالى الطول 5124 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix150$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[150] القرار 131/2023 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 10
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[150] القرار 131/2023 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[150] أُزيلت % مادة من القرار 131/2023 (القرار كله فى مادة واحدة بلا ديباجة ولا مواد ومتنه يخالف أصل الهيئة فى مواضع)', v_n;
  END IF;
END
$fix150$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 131 لسنة 2023 بتاريخ 2023/6/7 بشأن ضوابط القيد بسجل خبراء إعادة تقييم الأصول لدى الهيئة$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد الصادر بالقانون رقم (159) لسنة 1981 ولائحته التنفيذية؛
وعلى قانون سوق رأس المال الصادر بالقانون رقم (95) لسنة 1992 ولائحته التنفيذية؛
وعلى القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وعلى قانون البنك المركزي والجهاز المصرفي الصادر بالقانون رقم (194) لسنة 2020؛
وعلى قرار وزير الاستثمار رقم (110) لسنة 2015 بشأن معايير المحاسبة المصرية؛
وعلى قرار مجلس إدارة الهيئة رقم (39) لسنة 2015 بشأن معايير التقييم العقاري؛
وعلى قرار مجلس إدارة الهيئة رقم (1) لسنة 2017 بشأن معايير التقييم المالي للمنشآت؛
وعلى قرار مجلس إدارة الهيئة رقم (114) لسنة 2018 بشأن شروط وضوابط قيد شركات الاستشارات المالية والجهات المرخص لهما من الهيئة للقيام بأعمال التقييم المالي وإعداد دراسات القيمة العادلة لدى الهيئة؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2023/6/7؛
قرر$b0_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - إنشاء السجل$t1_0$, $b1_0$ينشأ بالهيئة سجل لقيد الأشخاص الراغبين في القيام بأعمال التقييم، يسمى «سجل خبراء إعادة تقييم الأصول».
ويجب أن يتضمن السجل البيانات الرئيسية لخبراء التقييم الذين يتم قيدهم به، وذلك على النحو الذي تحدده الهيئة.
ولا يجوز لغير المقيدين بالسجل القيام بأي من أعمال التقييم لأغراض إعادة تقييم الأصول وفقاً لمعايير المحاسبة المصرية.
ويقسم السجل إلى عدة أقسام بحسب الأصول المراد تقييمها على النحو الآتي:
القسم الأول: شركات الاستشارات المالية والجهات المرخص لهما من الهيئة للقيام بأعمال التقييم المالي وإعداد دراسات القيمة العادلة.
القسم الثاني: خبراء تقييم الأصول العقارية.
القسم الثالث: خبراء تقييم الآلات والمعدات ووسائل النقل والانتقال.$b1_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - شروط قيد الأشخاص الطبيعيين بالسجل$t2_0$, $b2_0$يشترط فى راغب القيد من الأشخاص الطبيعيين استيفاء الشروط الآتية:
1- أن يكون مقيداً بجدول خبراء التقييم لدى الهيئة أو أن يكون مرخصاً له كخبير تقييم من الجهة المختصة في الدولة التي اكتسب خبرته فيها بالنسبة لطالبي القيد من الأجانب.
2- أن يتوافر لديه الكفاءة المهنية وأن يجتاز الاختبارات التي تحددها الهيئة لهذا الغرض.
3- أن يتعهد بتقديم وثيقة تأمين ضد الأخطار المهنية طوال مدة القيد، وفقاً للشروط التي تضعها الهيئة بما يتلاءم مع حجم ونطاق المسؤوليات المترتبة على أعمال التقييم التي يقوم بها.
4- ألا يكون قد صدر بشأنه خلال الثلاث سنوات السابقة على تقديم طلب القيد أي أحكام نهائية في جناية، أو جنحة في جريمة ماسة بالشرف، أو في إحدى الجرائم المنصوص عليها في القوانين المالية غير المصرفية، أو قانون البنك المركزي والجهاز المصرفي، أو قانون غسل الأموال، أو صدر ضده إحدى التدابير الإدارية عدا التنبيه.
5- سداد مقابل الخدمات المشار إليه بالمادة السابعة من هذا القرار.$b2_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - شروط قيد الأشخاص الاعتباريين بالسجل$t3_0$, $b3_0$يشترط فى راغب القيد من الأشخاص الاعتباريين استيفاء الشروط الآتية:
1- أن يكون مقيداً بسجل قيد شركات الاستشارات المالية والجهات المرخص لهما من الهيئة للقيام بأعمال التقييم المالي وإعداد دراسات القيمة العادلة أو بجدول خبراء التقييم لدى الهيئة أو بسجل بيوت الخبرة لدى البنك المركزي المصري.
2- أن يتوافر في المسئولين الرئيسيين الذين تحددهم الهيئة لدى الشخص الاعتباري ممن لهم حق اعتماد تقارير التقييم الصادرة عنهم حسن السمعة والكفاءة المهنية واجتياز الاختبارات التي تحددها الهيئة لهذا الغرض.
3- أن يتعهد بتقديم وثيقة تأمين ضد الأخطار المهنية طوال مدة القيد، وفقاً للشروط التي تضعها الهيئة وبما يتلاءم مع حجم ونطاق المسؤوليات المترتبة على أعمال التقييم التي يتم القيام بها.
4- سداد مقابل الخدمات المشار إليه بالمادة السابعة من هذا القرار.$b3_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - إجراءات تقديم طلب القيد بالسجل$t4_0$, $b4_0$يقدم طلب القيد بالسجل من الأشخاص الطبيعيين أو الاعتباريين على النموذج المعد من الهيئة لهذا الغرض مرفقاً به المستندات الدالة على استيفاء الشروط الواردة بالمادتين الثانية أو الثالثة بحسب الأحوال من هذا القرار، وأي مستندات أخرى ترى الهيئة ضرورة تقديمها.
تشكل لجنة بالهيئة للبت في طلب القيد خلال ثلاثين يوماً من تاريخ تقديمه مستوفياً المستندات المؤيدة له.$b4_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - المسئولية عن أعمال التقييم$t5_0$, $b5_0$يكون الشخص الطبيعي او المدير المسئول لدى الشخص الاعتباري المقيدين بالسجل مسئولين عن أعمال التقييم الصادرة عنهما، ويلتزمان بالتوقيع على تقارير التقييم ودراسات القيمة العادلة الصادرة عنهم ولا يجوز الإنابة في ذلك، كما يكونا مسئولين عن التحقق من التزام كافة الأطراف ذوي العلاقة والمجموعات المرتبطة بهم بالمعايير الأساسية للأداء المهني ومعايير التقييم الصادرة عن الهيئة.$b5_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - شروط استمرار القيد بالسجل$t6_0$, $b6_0$يشترط لاستمرار قيد الأشخاص الطبيعيين والاعتباريين بالسجل مراعاة ما يلي:
1- الالتزام بتطبيق معايير التقييم الصادرة عن الهيئة.
2- استيفاء الشروط المتطلبة للقيد بالسجل على النحو المنصوص عليه بهذا القرار
3- الالتزام بتنفيذ التعهدات المنصوص عليها بنموذج طلب القيد أو تجديده.$b6_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - مدة ومقابل القيد بالسجل$t7_0$, $b7_0$تكون مدة القيد بالسجل ثلاث سنوات، وتجدد لمدد أخرى مماثلة شريطة استمرار توافر شروط القيد واستمراره.
ويكون مقابل خدمات فحص ودراسة طلب القيد بالسجل أو تجديده على النحو الآتي:
1- عشرة آلاف جنيه مصري بالنسبة للأشخاص الطبيعيين.
2- عشرون ألف جنيه مصري بالنسبة للأشخاص الاعتباريين.$b7_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة - التدابير الإدارية$t8_0$, $b8_0$لمجلس إدارة الهيئة حال ثبوت مخالفة أياً من التشريعات الحاكمة وعلى الأخص معايير التقييم الصادرة عن الهيئة في هذا الشأن أو فقد أحد شروط القيد او استمراره، اتخاذ واحد أو أكثر من التدابير الآتية:
1- توجيه التنبيه بالمخالفات المنسوبة وتحديد الفترة الزمنية اللازمة لإزالة أسبابها.
2- الايقاف المؤقت للقيد بالسجل لمدة لا تجاوز سنة.
3- شطب القيد من السجل، مع عدم جواز إعادة القيد إلا بعد مضي مدة لا تقل عن سنة.
كما يجوز لمجلس إدارة الهيئة دعوة مجلس إدارة الشخص الاعتباري للانعقاد بحضور أحد ممثلي الهيئة للنظر في أمر المخالفات المنسوبة إليها واتخاذ اللازم نحو إزالتها.$b8_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة$t9_0$, $b9_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الالكتروني للهيئة، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b9_0$
  FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-06-07', 'active' FROM ins9_0;

DO $verify150$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 131 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[150] القرار 131/2023 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 10 THEN RAISE EXCEPTION '[150] عدد المواد % بدل 10', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2023-06-07';
  IF v_v <> 10 THEN RAISE EXCEPTION '[150] عدد النسخ % بدل 10', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%7/6/2023%' OR body LIKE '%أن يكون خبير تقييم%' OR body LIKE '%جنحة فى إحدى%' OR body LIKE '%بسجل بيوت خبرة%' OR body LIKE '%tluafeD%' OR body LIKE '%مجلس ادارة%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[150] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%رقم (159) لسنة 1981%' AND body LIKE '%رقم (95) لسنة 1992%' AND body LIKE '%رقم (10) لسنة 2009%' AND body LIKE '%رقم (194) لسنة 2020%' AND body LIKE '%رقم (110) لسنة 2015%' AND body LIKE '%رقم (39) لسنة 2015%' AND body LIKE '%رقم (1) لسنة 2017%' AND body LIKE '%رقم (114) لسنة 2018%' AND body LIKE '%بتاريخ 2023/6/7؛%' AND body LIKE '%قرر') THEN RAISE EXCEPTION '[150] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'ينشأ بالهيئة سجل لقيد الأشخاص%' AND body LIKE '%«سجل خبراء إعادة تقييم الأصول»%' AND body LIKE '%القسم الثالث: خبراء تقييم الآلات والمعدات ووسائل النقل والانتقال.') THEN RAISE EXCEPTION '[150] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يشترط فى راغب القيد من الأشخاص الطبيعيين%' AND body LIKE '%مرخصاً له كخبير تقييم%' AND body LIKE '%من الأجانب.%' AND body LIKE '%أو جنحة في جريمة ماسة بالشرف، أو في إحدى الجرائم%' AND body LIKE '%عدا التنبيه.%' AND body LIKE '%5- سداد مقابل الخدمات المشار إليه بالمادة السابعة من هذا القرار.') THEN RAISE EXCEPTION '[150] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يشترط فى راغب القيد من الأشخاص الاعتباريين%' AND body LIKE '%أو بسجل بيوت الخبرة لدى البنك المركزي المصري.%' AND body LIKE '%4- سداد مقابل الخدمات المشار إليه بالمادة السابعة من هذا القرار.') THEN RAISE EXCEPTION '[150] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يقدم طلب القيد بالسجل من الأشخاص الطبيعيين أو الاعتباريين%' AND body LIKE '%بالمادتين الثانية أو الثالثة بحسب الأحوال من هذا القرار%' AND body LIKE '%خلال ثلاثين يوماً من تاريخ تقديمه%') THEN RAISE EXCEPTION '[150] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يكون الشخص الطبيعي او المدير المسئول%' AND body LIKE '%ولا يجوز الإنابة في ذلك%' AND body LIKE '%ومعايير التقييم الصادرة عن الهيئة.') THEN RAISE EXCEPTION '[150] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'يشترط لاستمرار قيد الأشخاص الطبيعيين والاعتباريين بالسجل مراعاة ما يلي:%' AND body LIKE '%1- الالتزام بتطبيق معايير التقييم الصادرة عن الهيئة.%' AND body LIKE '%3- الالتزام بتنفيذ التعهدات%أو تجديده.') THEN RAISE EXCEPTION '[150] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'تكون مدة القيد بالسجل ثلاث سنوات%' AND body LIKE '%1- عشرة آلاف جنيه مصري%' AND body LIKE '%2- عشرون ألف جنيه مصري بالنسبة للأشخاص الاعتباريين.') THEN RAISE EXCEPTION '[150] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'لمجلس إدارة الهيئة حال ثبوت مخالفة%' AND body LIKE '%2- الايقاف المؤقت للقيد بالسجل لمدة لا تجاوز سنة.%' AND body LIKE '%3- شطب القيد من السجل%بعد مضي مدة لا تقل عن سنة.%' AND body LIKE '%نحو إزالتها.') THEN RAISE EXCEPTION '[150] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية%' AND body LIKE '%من اليوم التالي لتاريخ نشره بالوقائع المصرية.%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[150] المادة 9 غير سليم'; END IF;
  IF v_len <> 5124 THEN RAISE EXCEPTION '[150] إجمالى طول المواد % بدل 5124', v_len; END IF;
  RAISE NOTICE '[150] القرار 131/2023: 10 مواد و10 نسخ، إجمالى % حرف', v_len;
END
$verify150$;

COMMIT;
