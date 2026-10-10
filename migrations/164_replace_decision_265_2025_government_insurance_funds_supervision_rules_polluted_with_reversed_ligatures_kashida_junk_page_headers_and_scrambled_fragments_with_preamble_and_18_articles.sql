-- 164_replace_decision_265_2025_government_insurance_funds_supervision_rules_polluted_with_reversed_ligatures_kashida_junk_page_headers_and_scrambled_fragments_with_preamble_and_18_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (265) لسنة 2025 بشأن الأحكام المنظمة لأوجه الرقابة على صناديق التأمين الحكومية،
-- المنشور بالوقائع المصرية، العدد 295 تابع، فى 30 ديسمبر 2025 (الصفحات 3 إلى 13): ديباجة و18 مادة، بلا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (18 صفاً، 18568 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) حروف اللام ألف مقلوبة الترتيب فى الصفوف الـ18 كلها (133 موضعاً)، وبقايا تطويل تالفة (U+FFFD، 889 حرفاً فى 17 صفاً) تتخلل الكلمات؛
-- (2) ترويسة صفحات الوقائع ("الوقائع المصرية - العدد 295 تابع ..." ورقم الصفحة) داخل 10 صفوف (المواد 1 و2 و5 و7 و9 و10 و11 و12 و14 و15)؛
-- (3) أرقام هندية فى 9 صفوف (27 حرفاً)، وتنوين مفصول عن حرفه فى 6 صفوف، و308 فاصل CRLF داخل الجمل؛
-- (4) عنوان كل مادة سطر أول داخل المتن بدل حقل title، وبلا ديباجة القرار ولا تاريخ سريان؛
-- (5) شظايا نص مبعثرة الترتيب (المادة 1 تبدأ بـ"بناءً على"، والمادة 6 بـ"تنفيذه"، وشظايا فى المواد 11 و13 و16)؛
-- (6) المادة 10 المخزَّنة (6337 حرفاً) تبتلع نص المواد 10 إلى 18 كلها، وهى مخزَّنة أيضاً صفوفاً مستقلة، فيتكرر النص ويقطع الاستشهاد؛
-- (7) المادة 18 تحمل التوقيع "د .محمد فريد صالح" بمسافة خاطئة، والمادة 12 فيها "سنو ى" والمادة 7 عنوانها "السجالت" بحروف مقلوبة.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى ولا لإدخاله إلى سياق نموذج اللغة.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (11 صفحة، 594 كيلوبايت) قدّمه صاحب المشروع؛ بلا علامة مائية، وجدول مراجعه تالف أُصلح بـqpdf قبل الاستخراج. استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة،
-- ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)، وأُعيد تركيب الفقرات والبنود بإحداثيات الأسطر (بداية الفقرة أو البند سطر مُزاح عن الهامش الأيمن بمقدار ثابت)، وأُلحقت العناوين المركزية بأرقام المواد ("المادة الأولى - إنشاء الصندوق").
-- حُذفت ترويسة الصفحات وأرقام الصفحات وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية"؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 18.
-- أُبقيت كتابة الأصل وأخطاؤه كما طُبعت، إلا إصلاحاً واحداً: مسافة داخل كلمة "سنو ى" فى المادة 12 صارت "سنوى" (أثر الاستخراج، لا الأصل). وفُرضت بداية فقرة جديدة فى المادة 10 عند سطر غير مُزاح على الصفحة 7 قُرئ موضعه على صورة الصفحة.
-- الأرقام لاتينية والتنوين فى موضعه، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" : " و" ؛ ").
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحات الإحدى عشرة: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الحروف والأرقام والعناوين، ولا فرق حقيقى فى كلمة واحدة.
--
-- ===== الهيكل =====
-- 19 صفاً، 19 نسخة (version_no = 1): ديباجة (article_no = 0) بالاطلاعات الثلاثة (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024 والقرارات الصادرة تنفيذاً له، والقرار 244 لسنة 2023) وموافقة مجلس الإدارة بجلسته بتاريخ 2025/11/5؛
-- ثم المواد 1 إلى 18 بأرقامها الأصلية وعناوينها (حقل title، مثل "المادة الأولى - إنشاء الصندوق"؛ والمادتان 17 و18 بلا عنوان كما فى الأصل). مفاتيح المواد هى المخزَّنة نفسها (1..18، 0) فلا تعيد البذور إدراج القديم.
--
-- ===== التاريخ =====
-- effective_from = 2025-12-31: المادة 18 تعمل بالقرار "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 295 تابع بتاريخ 2025/12/30. كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 17 تلزم الصناديق القائمة بتوفيق أوضاعها خلال سنة من تاريخ العمل بالقرار؛ هذه الهجرة تنقل النص كما نُشر ولا تعدّله.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (19 صفاً بديباجة سليمة والمادة 18 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو ترويسة، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 11467 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix164$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[164] القرار 265/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 19
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 18 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[164] القرار 265/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[164] أُزيلت % مادة من القرار 265/2025 (نص مخزَّن ملوَّث بحروف مقلوبة ورموز تطويل تالفة وترويسات صفحات، والمادة 10 فيه تحوى نص المواد 10-18 مدمجة، وبلا ديباجة)', v_n;
  END IF;
END
$fix164$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 265 لسنة 2025 (منشور بالوقائع المصرية العدد 295 تابع فى 2025/12/30) بشأن الأحكام المنظمة لأوجه الرقابة على صناديق التأمين الحكومية$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 والقرارات الصادرة تنفيذًا له ؛
وعلى قرار مجلس إدارة الهيئة رقم 244 لسنة 2023 بإعادة تنظيم ضوابط القيد واستمرار القيد والشطب فى سجل مراقبى الحسابات لدى الهيئة ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/11/5 ؛$b0_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - إنشاء الصندوق$t1_0$, $b1_0$يكون إنشاء صندوق التأمين الحكومى بقرار من رئيس مجلس الوزراء بناءً على اقتراح من مجلس إدارة الهيئة .
ويجوز للجهات العامة التقدم للهيئة بمقترح إنشاء صندوق تأمين حكومى على أن يتضمن على الأقل ما يلي :
1- الأهداف القومية أو الاجتماعية من إنشاء الصندوق.
2- الحادث أو الخطر المؤمن ضده.
3- المستفيدين من التأمين.
4- موارد الصندوق المالية.
5- أى بيانات أو مستندات أخرها تحددها الهيئة لدراسة المقترح.
وللهيئة لاستكمال دراسة المقترح أن تطلب من مقدمه تقديم دراسة اكتوارية معدة من أحد الخبراء الاكتواريين المقيدين لدى الهيئة.
ويكون لكل صندوق مقر رئيسى ملائم لمباشرة نشاطه ، ويجوز له إنشاء فروع له فى المحافظات بعد الحصول على موافقة الهيئة.$b1_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - تسجيل الصندوق$t2_0$, $b2_0$تسجل صناديق التأمين الحكومية بسجل معد لذلك بالهيئة مقابل سداد رسم التسجيل المحدد بقرار مجلس إدارة الهيئة الصادر فى هذا الشأن ، ولا يجوز للصندوق مزاولة نشاطه إلا بعد تمام التسجيل فى السجل المعد لذلك .
ويجب أن يتضمن السجل بحد أدنى البيانات الآتية :
1- اسم الصندوق والغرض من إنشائه والخطر الذى يغطيه.
2- عنوان المركز الرئيسى للصندوق وفروعه.
3- الموارد المالية للصندوق وقواعد وأوجه الصرف منها.
4- أسماء أعضاء مجلس إدارة الصندوق والمسئولين عن الوظائف الرئيسية به.
وللهيئة قبل إصدار قرار تسجيل الصندوق إجراء الفحص الميدانى للتأكد من توافر البنية الإدارية والمعلوماتية والهياكل التنظيمية ، وفى حال عدم استيفاء أى من المتطلبات اللازمة لمباشرة النشاط ، تخطر الهيئة الصندوق بما يتوجب عليه استكماله.
وينشر قرار التسجيل على الموقع الإلكترونى الذى تخصصه الهيئة لهذا الغرض.
ويجب على الصندوق الحصول على عدم ممانعة الهيئة فى حال تعديل أو تغيير أى من البيانات التى تم تسجيل الصندوق بناء عليها.$b2_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - مجلس إدارة الصندوق$t3_0$, $b3_0$يجب أن يتضمن مقترح إنشاء الصندوق الضوابط المنظمة لتشكيل مجلس إدارته بما فى ذلك الأعضاء من ذوى الخبرة ، واختصاصاته ، ومدة العضوية به ، وتنظيم معاملته المالية ، وضوابط مساءلته وعزله ، وكيفية دعوته للانعقاد ، ودورية اجتماعاته ، ونصاب الحضور والتصويت.
ويكون رئيس مجلس إدارة الصندوق هو الممثل القانونى للصندوق أمام القضاء والغير ، ويلتزم الصندوق بموافاة الهيئة بمحضر اجتماع مجلس الإدارة خلال ثلاثين يومًا على الأكثر من تاريخ الاجتماع للتصديق عليه.$b3_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - الهيكل التنظيمى للصندوق$t4_0$, $b4_0$يكون للصندوق مدير تنفيذى يرشحه ويحدد معاملته المالية قرار من مجلس إدارة الصندوق.
ويحدد مقترح إنشاء الصندوق الوظائف الرئيسية المتطلبة وفقًا للغرض من إنشائه وحجمه وطبيعة الخطر المؤمن ضده ، وكذا تحديد شروط شاغلى تلك الوظائف واختصاصاتهم وضوابط إنهاء عملهم به ومساءلتهم.
وفى جميع الأحوال لا يجوز شغل المدير التنفيذى لمنصبه أو أى من شاغلى الوظائف الرئيسية بالصندوق إلا بعد الحصول على عدم ممانعة الهيئة.$b4_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - اختصاصات المدير التنفيذى$t5_0$, $b5_0$يختص المدير التنفيذى للصندوق - بحد أدنى - بما يلى :
1- رئاسة العمل التنفيذى بالصندوق ، والإشراف على سير العمل اليومى وعلى جميع الأعمال الفنية والمالية والإدارية الخاصة بالصندوق ، واتخاذ القرارات اللازمة بما يحقق انتظام العمل به وتحقيق أهدافه.
2- متابعة تنفيذ أهداف الصندوق واستراتيجيته وكافة السياسات واللوائح والنظم الداخلية له وخطة عمله السنوية .
3- التأكد من فعالية نظام الرقابة الداخلية بالصندوق ، والتحقق من كفاءتها وفعاليتها ، وإجراء تقييم دورى لها مع اقتراح التعديلات اللازمة عليها.
4- الإشراف على إعداد القوائم المالية السنوية للصندوق وحساباته الختامية وعرضها على مجلس الإدارة.
5- الإشراف على إعداد الموازنة التقديرية للصندوق وعرضها على مجلس الإدارة قبل ثلاثة أشهر على الأقل من بداية السنة المالية.
6- الإشراف على أداء التزامات الصندوق تجاه المستحقين وفقًا للتشريعات المعمول بها.
7- الإشراف على إعداد التقارير الدورية والسنوية عن نشاط الصندوق وعرضها على مجلس الإدارة.
8- اتخاذ الإجراءات التى تكفل الحفاظ على أموال الصندوق وحقوقه قبل الغير.
9- التأكد من وجود الآليات التى تكفل رصد أية مخالفات على أصول الصندوق من قبل العاملين به أو المتعاملين معه وإخطار الهيئة ومجلس إدارة الصندوق فورًا بهذه المخالفات واتخاذ الإجراءات التصحيحية المناسبة.
10- أى مهام أخرى يكلف بها من قبل مجلس إدارة الصندوق.
ويكون المدير التنفيذى للصندوق مسئولاً مسئولية مباشرة أمام مجلس إدارة الصندوق عن أعمال الصندوق.$b5_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - الرقابة الداخلية على الصندوق$t6_0$, $b6_0$يلتزم الصندوق بوضع نظام فعال للرقابة الداخلية معتمد من مجلس إدارته يهدف إلى تحقيق ما يلي :
1- التحقق من التزام الصندوق والعاملين به بتطبيق أحكام قانون التأمين الموحد والقرارات ذات الصلة الصادرة تنفيذًا له.
2- تحديد آليات تقييم المخاطر المحتملة ، ووضع خطط للحد منها ، والإجراءات التصحيحية المناسبة لها.
3- ضمان دقة وصحة السجلات التى يجب على الصندوق إمساكها.
4- حماية أصول الصندوق ، والعمل على تعظيمها.
5- وضع قواعد المساءلة والمحاسبة داخل الصندوق.$b6_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - السجلات التى يتعين على الصندوق إمساكها$t7_0$, $b7_0$على كل صندوق أن يمسك - بحد أدنى - السجلات الآتية :
1- سجل الوثائق وتقيد به جميع الوثائق والنماذج التى يصدرها الصندوق حال قيامه بإصدار وثائق تأمين.
2- سجل المطالبات وتقيد به جميع المطالبات المقدمة للصندوق وتاريخ سدادها وقيمة التعويضات الخاصة بكل منها ، مع بيان المطالبات التى تم رفضها وسبب ذلك وتاريخه.
3- سجل الاستثمارات وتقيد به إجمالى قيمة المحفظة الاستثمارية للصندوق ، والبيانات التفصيلية للأدوات المالية المستثمر فيها ونسبتها من إجمالى المحفظة والعوائد المحققة لكل أداة استثمارية على حدة بالمبالغ والمعدلات.
4- سجل محاضر مجلس الإدارة.
5- سجل الشكاوى ويتضمن تاريخ تقديم الشكوى ورقم مسلسل قيدها واسم مقدمها ، وبيان موجز بموضوعها الشكوى وبيان بالمستندات المقدمة تأييدًا لها.
6- سجل الدعاوى القضائية أو التحكيمية التى يكون الصندوق طرفًا فيها.
7- سجل الإيرادات وتقيد به جميع الإيرادات المستحقة للصندوق.
8- أى سجلات أخرى تحددها الهيئة.
ويجب أن تعتمد السجلات المشار إليها من الهيئة ، ويحتفظ الصندوق بجميع بيانات السجلات المشار إليها فى مركزه الرئيسى على أن يحتفظ كل فرع من فروعه بالسجلات التى تخصه ، ويجوز للصندوق إمساك وحفظ تلك السجلات إلكترونيًا.$b7_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة - مواعيد إعداد وعرض القوائم المالية$t8_0$, $b8_0$مع عدم الإخلال بالأوضاع القائمة ، يلتزم الصندوق بموافاة الهيئة بالقوائم المالية السنوية والإفصاحات المرفقة بها وفقًا لمعايير المحاسبة المصرية وتقرير مراقب الحسابات بشأنها وذلك خلال أربعة أشهر من انتهاء السنة المالية.
وللهيئة إبداء ملاحظاتها على تلك القوائم أو البيانات أو التقارير المرفقة بها وإخطار الصندوق بملاحظاتها ، وإلزام الصندوق باتخاذ الإجراءات التصحيحية المناسبة خلال الأجل الذى تحدده.$b8_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة - البيانات والحسابات المالية للصندوق$t9_0$, $b9_0$تلتزم صناديق التأمين الحكومية بأن تقدم للهيئة القوائم المالية والإيضاحات المتممة والحسابات الموضحة فيما يلي :
1- قائمة المركز المالي.
2- حساب الإيرادات والمصروفات.
3- بيان بتوزيع أقساط التأمين والمخصصات الفنية والمصروفات.
4- كافة البيانات والإفصاحات والإيضاحات المتممة وفقًا لمتطلبات معايير المحاسبة المصرية.
5- أية بيانات أخرى تطلبها الهيئة.$b9_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins9_0;

WITH ins10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $t10_0$المادة العاشرة - مراجعة حسابات الصندوق$t10_0$, $b10_0$مع عدم الإخلال بالأوضاع القائمة ، يتولى مراجعة حسابات الصندوق مراقب حسابات أو أكثر من بين المقيدين بالقسم الأول من سجل مراقبى الحسابات بالهيئة ، على أن يختاره ويحدد أتعابه مجلس إدارة الصندوق بمراعاة قواعد تجنب تعارض المصالح.
ويجوز لمجلس إدارة الصندوق التعاقد مع مراقب الحسابات لأداء أعمال إضافية غير مرتبطة مباشرة بمهامه كمراقب للحسابات شريطة ألا تكون تلك الأعمال من الأعمال التى تتعارض مع طبيعة عمله كمراقب حسابات ، وأن تتناسب الأتعاب مع طبيعة وحجم الأعمال الإضافية ، مع الإفصاح عن تلك الأعمال فى التقرير السنوى للصندوق.
ويكون تعيين مراقب حسابات الصندوق بصورة سنوية ، ويجوز أن يجدد له بحد أقصى ست سنوات مالية متصلة ، ولا يجوز أن يعاد تعيينه إلا بعد مرور ثلاث سنوات مالية من انتهاء الست سنوات المشار إليها.$b10_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins10_0;

WITH ins11_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, $t11_0$المادة الحادية عشرة - تقرير مراقب الحسابات$t11_0$, $b11_0$يجب على مراقب حسابات الصندوق أن يوضح ضمن تقريره المعد بشأن مراجعة حسابات الصندوق ما إذا كانت القوائم المالية المشار إليها قد أعدت على الوجه الصحيح وأنها تمثل حالة الصندوق تمثيلاً صحيحًا من واقع السجلات والبيانات الأخرى التى رأى ضرورة الحصول عليها والتى وضعت تحت تصرفه ، على أن يتضمن التقرير - حال وجود تحفظات - بيان مدى تأثيرها على المركز المالى للصندوق ، وعلى مراقب الحسابات أن يخطر الهيئة والصندوق كتابة بأى نقص أو خطأ أو أية مخالفة يكتشفها أثناء فحصه وأن يوضح فى تقريره عما إذا كانت العمليات التى قام بمراجعتها تخالف أى حكم من أحكام قانون التأمين الموحد أو القرارات الصادرة تنفيذًا له.$b11_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins11_0;

WITH ins12_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, NULL, $t12_0$المادة الثانية عشرة - التقرير السنوى عن نشاط الصندوق$t12_0$, $b12_0$يلتزم الصندوق بإعداد تقرير سنوى عن نشاط الصندوق يعرض على مجلس إدارته ، ويتم موافاة الهيئة به مرفقًا بالقوائم المالية السنوية ، ويجب أن يتضمن بحد أدنى ما يلي :
1- طبيعة نشاط الصندوق ، وأهدافه ، ورؤيته ، واستراتيجيته المستقبلية.
2- هيكل تشكيل مجلس الإدارة ، وأسماء أعضائه وصفاتهم وأى تغيير يطرأ عليهم ، وتاريخ بداية ونهاية الدورة الحالية ، وعدد الاجتماعات المعقودة وتواريخها وقيمة البدلات والمكافآت التى صرفت لأعضاء مجلس الإدارة ، وذلك كله عن الفترة المقدم عنها التقرير.
3- بيان بالإنجازات المحققة خلال العام.
4- القرارات الجوهرية المتخذة وأثرها على أداء ووضع الصندوق.
5- تحليل لأهم المخاطر التى تواجه الصندوق حاليًا أو مستقبلاً ، والإجراءات المتخذة فى هذا الشأن.
6- تقرير عن وضع الملاءة المالية للصندوق ، ومستوى المخاطر التى يتعرض له ، وكيفية إدارة هذه المخاطر.
7- تقرير مراجعة كفاءة وفعالية نظام الرقابة الداخلية للصندوق.
8- أسماء ومناصب ومؤهلات وخبرات شاغلى الوظائف الرئيسية بالصندوق.
9- بيان التدابير أو المخالفات أو الدعاوى القضائية أو التحكيمية التى اتخذت ضد الصندوق أو ضد أى من أعضاء مجلس إدارته أو المدير التنفيذى أو شاغلى الوظائف الرئيسية ، أو الأحكام الصادرة ضد أى منهم والمتعلقة بمهامهم الوظيفية.$b12_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins12_0;

WITH ins13_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, NULL, $t13_0$المادة الثالثة عشرة - التقرير الاكتوارى للصندوق$t13_0$, $b13_0$يلتزم الصندوق بحد أقصى كل خمس سنوات أو بناءً على طلب من الهيئة بتقديم تقرير اكتوارى معد من قبل أحد الخبراء الإكتواريين المقيدين لدى الهيئة يوضح فيه المركز المالى للصندوق ، ومدى كفاية أموال الصندوق لمقابلة التزاماته ، وذلك وفقًا للأسس الفنية المعتمدة من الهيئة فى هذا الخصوص.
ويجب أن يتضمن التقرير شهادة من الخبير الاكتوارى بمدى قيام المسئولين عن إدارة الصندوق بوضع تحت تصرفه جميع البيانات والمعلومات التى طلبها ويراها ضرورية لأداء مهامه ، ويلتزم الخبير الاكتوارى بإخطار الهيئة بأى خطأ أو مخالفات قد تتكشف لديه أثناء إعداد التقرير الإكتواري.
وللهيئة حال عدم قيام الصندوق بموافاتها بالتقرير المشار إليه أو تبين لها أن التقرير المقدم لا يعبر عن حقيقة المركز المالى للصندوق ، أن تلزم الصندوق بإعادة إعداد التقرير بواسطة خبير اكتوارى آخر على نفقة الصندوق.$b13_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins13_0;

WITH ins14_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, NULL, $t14_0$المادة الرابعة عشرة - السياسة الاستثمارية للصندوق والتقارير الرقابية الخاصة باستثماراته$t14_0$, $b14_0$تلتزم صناديق التأمين الحكومية بقواعد وضوابط الاستثمار الذى يصدرها مجلس إدارة الهيئة ، وعليها إعداد سياسة استثمارية تعرض على مجلس إدارتها لاعتمادها ويتم موافاة الهيئة بنسخة منها وببيانات الشخص المسئول عن إدارة استثمارات الصندوق متضمنة خبراته ومؤهلاته.
ويتعين على الصندوق إخطار الهيئة فورًا عند إجراء أى تعديل فى السياسة الاستثمارية أو الشخص أو الجهة المسئولة عن إدارة استثمارات الصندوق.
ويجوز للصندوق أن يعهد بإدارة استثماراته إلى إحدى شركات إدارة المحافظ الاستثمارية المرخص لها من الهيئة.
ويلتزم الصندوق بأن يقدم للهيئة تقرير ربع سنوى بشأن استثماراته معتمد من المدير التنفيذى وبعد العرض على مجلس إدارة الصندوق ، متضمنًا على الأخص الأرصدة التى تبين الأصول المملوكة له من الجهات الآتى ذكرها – إن وجد - :
1- البنوك المودع لديها أرصدة نقدية للصندوق أو المستثمر فى شهادات الإيداع أو الاستثمار الصادرة عنها.
2- أمناء الحفظ المودع لديها أوراق مالية للصندوق.
3- شركات خدمات الإدارة فى مجال صناديق الاستثمار التى يستثمر فى وثائقها الصندوق.
4- الجهات الأخرى التى تحددها الهيئة فيما يخص أى أوجه استثمار بخلاف الواردة أعلاه.$b14_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins14_0;

WITH ins15_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, NULL, $t15_0$المادة الخامسة عشرة - فحص أعمال صناديق التأمين الحكومية$t15_0$, $b15_0$تلتزم صناديق التأمين الحكومية حال اتخاذ إجراءات فحصها من قبل الهيئة بموافاتها بكافة البيانات والمعلومات اللازمة للتأكد من سلامة مركزها المالى والأسس الفنية لمزاولة نشاطها ، وكذا أى بيانات أو مستندات أخرى ترى الهيئة ضرورة تقديمها فى هذا الشأن.$b15_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins15_0;

WITH ins16_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, NULL, $t16_0$المادة السادسة عشرة - التدابير الإدارية$t16_0$, $b16_0$لمجلس إدارة الهيئة فى حالة ثبوت مخالفة الصندوق للأحكام القانونية المنظمة له أو القرارات الصادرة تنفيذًا لذلك أو فى حالة وجود خطر يهدد المركز المالى للصندوق أو المستفيدين منه ، اتخاذ تدبير أو أكثر من التدابير الآتية :
1- توجيه إنذار إلى الصندوق بالمخالفات المنسوبة له وتحديد المدة الزمنية لإزالتها.
2- دعوة مجلس إدارة الصندوق إلى الانعقاد للنظر فى أمر المخالفات المنسوبة إليه واتخاذ اللازم نحو إزالتها ، ويحضر اجتماع مجلس الإدارة فى هذه الحالة ممثل أو أكثر عن الهيئة.
3- تنحية واحد أو أكثر من القائمين على الإدارة التنفيذية للصندوق.$b16_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins16_0;

WITH ins17_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, NULL, $t17_0$المادة السابعة عشرة$t17_0$, $b17_0$تلتزم صناديق التأمين الحكومية القائمة بتوفيق أوضاعها وفقًا لأحكام هذا القرار خلال سنة من تاريخ العمل به.$b17_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins17_0;

WITH ins18_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, NULL, $t18_0$المادة الثامنة عشرة$t18_0$, $b18_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b18_0$
  FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins18_0;

DO $verify164$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 265 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[164] القرار 265/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 19 THEN RAISE EXCEPTION '[164] عدد المواد % بدل 19', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-12-31';
  IF v_v <> 19 THEN RAISE EXCEPTION '[164] عدد النسخ % بدل 19', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الس جالت%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%العدد 295%' OR body LIKE '%سنو ى%' OR body LIKE '%السجالت%' OR body LIKE '% ً%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[164] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%ته المنعقدة بتاريخ 2025/11/5 ؛' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%رقم 244 لسنة 2023%' AND body LIKE '%بتاريخ 2025/11/5 ؛%') THEN RAISE EXCEPTION '[164] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يكون إنشاء صندوق التأمين الحكومى بقرار من رئي%' AND body LIKE '%بعد الحصول على موافقة الهيئة.' AND body LIKE '%بناءً على اقتراح من مجلس إدارة الهيئة .%' AND body LIKE '%5- أى بيانات أو مستندات أخرها تحددها%' AND body LIKE '%4- موارد الصندوق المالية.%') THEN RAISE EXCEPTION '[164] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'تسجل صناديق التأمين الحكومية بسجل معد لذلك با%' AND body LIKE '%ى تم تسجيل الصندوق بناء عليها.' AND body LIKE '%4- أسماء أعضاء مجلس إدارة الصندوق%' AND body LIKE '%3- الموارد المالية للصندوق%') THEN RAISE EXCEPTION '[164] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يجب أن يتضمن مقترح إنشاء الصندوق الضوابط المن%' AND body LIKE '%ن تاريخ الاجتماع للتصديق عليه.' AND body LIKE '%خلال ثلاثين يومًا على الأكثر%') THEN RAISE EXCEPTION '[164] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يكون للصندوق مدير تنفيذى يرشحه ويحدد معاملته%' AND body LIKE '%الحصول على عدم ممانعة الهيئة.' AND body LIKE '%وفقًا للغرض من إنشائه%') THEN RAISE EXCEPTION '[164] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يختص المدير التنفيذى للصندوق - بحد أدنى - بما%' AND body LIKE '%دارة الصندوق عن أعمال الصندوق.' AND body LIKE '%10- أى مهام أخرى%' AND body LIKE '%قبل ثلاثة أشهر على الأقل%' AND body LIKE '%9- التأكد من وجود الآليات%') THEN RAISE EXCEPTION '[164] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'يلتزم الصندوق بوضع نظام فعال للرقابة الداخلية%' AND body LIKE '%مساءلة والمحاسبة داخل الصندوق.' AND body LIKE '%5- وضع قواعد المساءلة%' AND body LIKE '%الصادرة تنفيذًا له.%') THEN RAISE EXCEPTION '[164] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'على كل صندوق أن يمسك - بحد أدنى - السجلات الآ%' AND body LIKE '%ك وحفظ تلك السجلات إلكترونيًا.' AND body LIKE '%8- أى سجلات أخرى%' AND body LIKE '%3- سجل الاستثمارات%') THEN RAISE EXCEPTION '[164] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'مع عدم الإخلال بالأوضاع القائمة ، يلتزم الصند%' AND body LIKE '%لمناسبة خلال الأجل الذى تحدده.' AND body LIKE '%خلال أربعة أشهر من انتهاء السنة المالية%') THEN RAISE EXCEPTION '[164] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'تلتزم صناديق التأمين الحكومية بأن تقدم للهيئة%' AND body LIKE '%أية بيانات أخرى تطلبها الهيئة.' AND body LIKE '%5- أية بيانات أخرى%' AND body LIKE '%3- بيان بتوزيع أقساط%') THEN RAISE EXCEPTION '[164] المادة 9 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0 AND body LIKE 'مع عدم الإخلال بالأوضاع القائمة ، يتولى مراجع%' AND body LIKE '%نتهاء الست سنوات المشار إليها.' AND body LIKE '%ست سنوات مالية متصلة%' AND body LIKE '%ثلاث سنوات مالية%' AND body LIKE '%بالقسم الأول من سجل%' AND body LIKE '%الإضافية ، مع الإفصاح عن تلك الأعمال فى التقرير السنوى للصندوق.
ويكون تعيين مراقب%') THEN RAISE EXCEPTION '[164] المادة 10 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0 AND body LIKE 'يجب على مراقب حسابات الصندوق أن يوضح ضمن تقري%' AND body LIKE '%و القرارات الصادرة تنفيذًا له.' AND body LIKE '%تمثيلاً صحيحًا من واقع السجلات%' AND body LIKE '%القرارات الصادرة تنفيذًا له.') THEN RAISE EXCEPTION '[164] المادة 11 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 12 AND article_suffix_order = 0 AND body LIKE 'يلتزم الصندوق بإعداد تقرير سنوى عن نشاط الصند%' AND body LIKE '%هم والمتعلقة بمهامهم الوظيفية.' AND body LIKE '%تقرير سنوى عن نشاط الصندوق%' AND body LIKE '%9- بيان التدابير%' AND body LIKE '%8- أسماء ومناصب%') THEN RAISE EXCEPTION '[164] المادة 12 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 13 AND article_suffix_order = 0 AND body LIKE 'يلتزم الصندوق بحد أقصى كل خمس سنوات أو بناءً%' AND body LIKE '%اكتوارى آخر على نفقة الصندوق.' AND body LIKE '%كل خمس سنوات أو بناءً على طلب من الهيئة%') THEN RAISE EXCEPTION '[164] المادة 13 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 14 AND article_suffix_order = 0 AND body LIKE 'تلتزم صناديق التأمين الحكومية بقواعد وضوابط ا%' AND body LIKE '%ه استثمار بخلاف الواردة أعلاه.' AND body LIKE '%تقرير ربع سنوى%' AND body LIKE '%4- الجهات الأخرى%' AND body LIKE '%3- شركات خدمات الإدارة%') THEN RAISE EXCEPTION '[164] المادة 14 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 15 AND article_suffix_order = 0 AND body LIKE 'تلتزم صناديق التأمين الحكومية حال اتخاذ إجراء%' AND body LIKE '%ئة ضرورة تقديمها فى هذا الشأن.') THEN RAISE EXCEPTION '[164] المادة 15 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 16 AND article_suffix_order = 0 AND body LIKE 'لمجلس إدارة الهيئة فى حالة ثبوت مخالفة الصندو%' AND body LIKE '%على الإدارة التنفيذية للصندوق.' AND body LIKE '%القرارات الصادرة تنفيذًا لذلك%' AND body LIKE '%3- تنحية واحد%' AND body LIKE '%2- دعوة مجلس إدارة الصندوق%') THEN RAISE EXCEPTION '[164] المادة 16 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 17 AND article_suffix_order = 0 AND body LIKE 'تلتزم صناديق التأمين الحكومية القائمة بتوفيق%' AND body LIKE '%ار خلال سنة من تاريخ العمل به.' AND body LIKE '%خلال سنة من تاريخ العمل به.%') THEN RAISE EXCEPTION '[164] المادة 17 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 18 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية.%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[164] المادة 18 غير سليم'; END IF;
  IF v_len <> 11467 THEN RAISE EXCEPTION '[164] إجمالى طول المواد % بدل 11467', v_len; END IF;
  RAISE NOTICE '[164] القرار 265/2025: 19 مواد و19 نسخ، إجمالى % حرف', v_len;
END
$verify164$;

COMMIT;
