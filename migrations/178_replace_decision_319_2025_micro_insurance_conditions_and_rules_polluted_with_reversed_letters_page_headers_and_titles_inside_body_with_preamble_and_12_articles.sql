-- 178_replace_decision_319_2025_micro_insurance_conditions_and_rules_polluted_with_reversed_letters_page_headers_and_titles_inside_body_with_preamble_and_12_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (319) لسنة 2025 بشأن الشروط والقواعد الحاكمة لنشاط التأمين متناهى الصغر،
-- المنشور بالوقائع المصرية، العدد 29، فى 5 فبراير 2026 (الصفحات 9 إلى 17): ديباجة و12 مادة، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (12 صفاً، 9009 أحرف) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) 487 حرف تلف (U+FFFD) فى المواد كلها (مكان بقايا التطويل داخل الكلمات: "تس���رى" و"ش���أن" و"يع���د")؛
-- (2) حروف اللام ألف مقلوبة الترتيب (42 موضعاً: "االلتزام" و"األشخاص" و"اإللكترونى" و"خالل" و"اآلتية")، وتنوين مفصول عن حرفه ("ً مبس���طا"، و17 موضعاً)، وضمة مفصولة ("ُيلغى")،
--     و163 فاصل CRLF داخل الجمل، وأرقام بنود معكوسة ومحشورة ("-1يج���ب" و"- ۲يج���ب" و"-٤وضع")، وأرقام هندية وفارسية (47 رقماً: بنود المواد 3 و4 و5 و6 و7 و8 و10 و11)؛
-- (3) سبع ترويسات صفحات داخل المتن ("الوقائع املصرية -العدد 29فى 5فبراير سنة 2026 12") فى المواد 3 و4 (ثلاث مرات) و5 و7 و8، تقطع البنود فى منتصفها؛
-- (4) عنوان كل مادة مخزَّن فى أول المتن ملصقاً بالنص (12 عنواناً) بدل أن يكون فى حقل العنوان، والتوقيع مبعثراً ("د .محمد فريد صالح") فى المادة 12؛
-- (5) بلا ديباجة (ستة اطلاعات وموافقة مجلس الإدارة بجلسة 2025/12/24) وبلا تاريخ سريان (التاريخ المخزَّن تاريخ تشغيل البذر).
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: تقطّع البنود بين الصفحات بترويسة الوقائع يُفسد معايير الاكتتاب وتسوية التعويضات (المادة 4)، وتلف الحروف يُفسد البحث النصى.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (9 صفحات، 393 كيلوبايت) قدّمه صاحب المشروع؛ بملف تالف جدول المراجع (xref) فأُصلح بـqpdf قبل القراءة.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات والبنود بإحداثيات الأسطر. وطُبّقت قاعدة عرض الحرف لعيبى الترميز المعروفين فى خط هذه الوقائع («ين» النهائى المتصل و«لأ» المتصل) على كل صفحة فلم يلزم تصحيح شىء فى هذا الملف.
-- حُذفت ترويسة كل صفحة ورقمها، وسطر "الهيئة العامة للرقابة المالية" وعنوان القرار وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 12 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- عناوين المواد 1 إلى 10 (المطبوعة وسطاً تحت "(المادة ...)") فى حقل العنوان بالصيغة "المادة <الترتيب> - <العنوان>"؛ والمادتان 11 و12 بلا عنوان فى الأصل فعنوانهما "المادة الحادية عشرة" و"المادة الثانية عشرة".
-- بنود المواد تُعرض "N- نص"، وعناوين فروع المادتين 3 و4 ("أولاً - ..." و"ثانيًا - ..." و"ثالثًا - ...") فى أسطر مستقلة كما طُبعت؛ والمادة 9 فقرتان والمادة 4 مرتبة بثلاثة أقسام.
-- تعديل واحد على المطبوع، معلن: "رقم902" فى سطر الاطلاع على قرار رئيس الهيئة 902 لسنة 2016 (الأصل بلا مسافة بين "رقم" والرقم) كُتب "رقم 902" كما فى المادة 11.
-- أُبقيت كتابة الأصل بلا تعديل لفظ: "الكترونيًا" بلا همزة فى الديباجة، و"تلقي" و"يلي" بالياء، و"البند (ه)" (الهاء المطبوعة بتطويل "هـ")، وغياب المسافة قبل النقطة فى "المصرية."؛ وكذلك مسافة قبل النقطة فى بعض البنود ("الأخرى التى توافق عليها الهيئة .").
-- الأرقام لاتينية، والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛").
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحات التسع: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام والعناوين وخلط الباء والياء والنون، وقُرئت صورتا الصفحتين 1 و9 فصار ما فى النص كما فى الصورة.
--
-- ===== الهيكل =====
-- 13 صفاً، 13 نسخة (version_no = 1): ديباجة (article_no = 0) بستة اطلاعات (القانون 10 لسنة 2009، والقانون 141 لسنة 2014، وقانون التأمين الموحد 155 لسنة 2024، وقرارات مجلس إدارة الهيئة 186 لسنة 2024 و18 لسنة 2025 و199 لسنة 2025، وقرار رئيس الهيئة 902 لسنة 2016)
-- وموافقة مجلس الإدارة بجلسته بتاريخ 2025/12/24؛ ثم المواد 1 إلى 12 بأرقامها الأصلية، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 إلى 12 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2026-02-06: المادة 12 تعمل بالقرار "من اليوم التالى لنشره بالوقائع المصرية"، ونشره بالعدد 29 بتاريخ 2026/2/5 (ثابت بترويسة الصفحات التسع). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 10 تُمهل الشركات ستة أشهر من تاريخ العمل به لتوفيق أوضاعها، فتنتهى المهلة 2026/8/6؛ والمادة 11 تُلغى صراحةً قرار رئيس الهيئة 902 لسنة 2016. هذه الهجرة تنقل النص كما نُشر ولا تعدّل حالة ذلك القرار فى laws ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (13 صفاً بديباجة سليمة والمادة 12 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 8116 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix178$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[178] القرار 319/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 13
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 12 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[178] القرار 319/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[178] أُزيلت % مادة من القرار 319/2025 (نص مخزَّن ملوَّث بتلف حروف وترويسات صفحات داخل المواد وعناوين داخل المتن وبلا ديباجة)', v_n;
  END IF;
END
$fix178$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 319 لسنة 2025 (منشور بالوقائع المصرية العدد 29 فى 2026/2/5) بشأن الشروط والقواعد الحاكمة لنشاط التأمين متناهى الصغر$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى القانون رقم 141 لسنة 2014 بتنظيم مزاولة نشاط تمويل المشروعات المتوسطة والصغيرة ومتناهية الصغر ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 والقرارات الصادرة تنفيذًا له ؛
وعلى قرار مجلس إدارة الهيئة رقم 186 لسنة 2024 بشأن الالتزام بالاستعلام عن صحة بيانات العملاء ؛
وعلى قرار مجلس إدارة الهيئة رقم 18 لسنة 2025 بشأن زيادة الحد الأقصى للتغطية التأمينية لنشاط التأمين متناهي الصغر ؛
وعلى قرار مجلس إدارة الهيئة رقم 199 لسنة 2025 بشأن تنظيم إصدار وتوزيع شركات التأمين لبعض وثائق التأمين رقميًا من خلال شبكة نظم المعلومات ؛
وعلى قرار رئيس الهيئة رقم 902 لسنة 2016 بشأن تعريف التأمين متناهى الصغر والضوابط التنفيذية لإصدار وتوزيع وثائقه الكترونيًا من خلال شبكة نظم المعلومات ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/12/24 ؛$b0_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - نطاق التطبيق$t1_0$, $b1_0$تسرى أحكام هذا القرار فى شأن الشروط والقواعد الحاكمة لنشاط التأمين متناهى الصغر.$b1_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - تعريف التأمين متناهى الصغر$t2_0$, $b2_0$يعد تأمين متناهى الصغر كل تأمين يستهدف ذوى الدخول المنخفضة فى مجالات تأمين الممتلكات والأشخاص لحمايتهم من أخطار قد يتعرضون لها مقابل سداد أقساط تتناسب مع طبيعة الخطر المؤمن عليه ، وبحد أقصى للتغطية التأمينية يتحدد وفقًا للقرار الصادر عن مجلس إدارة الهيئة فى هذا الشأن.$b2_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - فروع التأمين متناهى الصغر$t3_0$, $b3_0$تصدر وثائق التأمين متناهى الصغر فى فروع التأمين الآتية :
أولاً - وثائق التأمين متناهى الصغر بالنسبة للأشخاص ، وتشمل ما يلي :
1- تأمينات الحياة بجميع أنواعها.
2- تأمينات الحوادث الشخصية.
3- تأمينات العلاج الطبى طويل الأجل.
ثانيًا - وثائق التأمين متناهى الصغر بالنسبة لتأمينات الممتلكات والمسئوليات ، وتشمل ما يلي :
1- التأمين ضد أخطار الحريق والأخطار المرتبطة به.
2- التأمين ضد أخطار النقل بأنواعه البرى والنهرى والبحرى والجوى وتأمينات المسئوليات المتعلقة بها.
3- التأمين على أجسام مراكب الصيد وآلاتها ومهماتها وتأمينات المسئوليات المتعلقة بها.
4- التأمين التكميلى على المركبات والمسئوليات المتعلقة بها وذلك فيما يخص المركبات الخاصة بمشروعات التوزيع وشباب الخريجين وما يماثلها.
5- التأمين ضد الأخطار الهندسية وتأمينات المسئوليات المتعلقة بها .
6- التأمينات الزراعية والمسئوليات والأخطار المرتبطة بها.
7- التأمين ضد أخطار الحوادث المتنوعة والمسئوليات.
8- التأمين ضد مخاطر عدم السداد.
9- تأمينات العلاج الطبى قصير الأجل.
10- أى فروع تأمين أخرى توافق عليها الهيئة.$b3_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - المعايير الواجب على الشركات التى تزاول نشاط التأمين متناهى الصغر الالتزام بها$t4_0$, $b4_0$يجب على الشركات عند مزاولة نشاط التأمين متناهى الصغر ، أن تلتزم بالمعايير الآتية :
أولاً - معايير عامة :
1- يجب أن تتسم منتجات التأمين متناهى الصغر بالبساطة وسهولة الفهم للمؤمن عليهم ، مع مراعاة إجراء تحليل شامل مستمر للفئات منخفضة الدخل للعمل على توفير المنتجات التأمينية للمخاطر الأكثر شيوعًا لدى الفئات منخفضة الدخل.
2- يجب أن تتسم المواد التسويقية والدعائية لمنتجات التأمين متناهى الصغر بالبساطة والوضوح ، بما يضمن إيصال المعلومات بدقة وشفافية للمستفيدين دون أى تعقيد.
3- يجب أن تتسم عملية تحصيل الأقساط بالمرونة وبما يتناسب مع دخل الأفراد المستفيدين من هذا التأمين ، وأن تتسم عملية دفع التعويضات بالسرعة مع إتاحة استخدام وسائل دفع إلكترونية كوسيلة لتسهيل تحصيل الأقساط ودفع التعويضات.
4- وضع آلية مبسطة تمكن عملاء التأمين متناهى الصغر من تقديم الشكاوى بسهولة ، على أن تضمن هذه الآلية وضوح الإجراءات وتعدد وسائل تقديم الشكاوى ، مع الالتزام بدراسة الشكاوى والرد عليها خلال فترة زمنية قصيرة ومحددة ، وبما يتوافق مع قرارات الهيئة الصادرة فى هذا الشأن.
5- عدم تحميل المؤمن له أى مبالغ إضافية غير منصوص عليها صراحة فى الوثيقة.
ثانيًا - معايير وأسس الاكتتاب وإصدار الوثائق والتسويق :
1- وضع سياسة اكتتابية لمنتجات التأمين متناهى الصغر معتمدة من مجلس إدارة الشركة ، ومراجعتها سنويًا على الأقل للتأكد من كفاءتها وملاءمتها للفئات المستهدفة وتطورات السوق.
2- تحديد الأسس الفنية والاكتوارية للتسعير وحدود القبول ونسب التحمل ، مع ضرورة تضمينها لآليات مراجعة الأسعار على أن يكون السعر معقولاً ومتناسبًا مع مستوى المخاطر.
3- تحديد الطرق التسويقية وقنوات التوزيع التى تتناسب مع طبيعة المنتجات متناهية الصغر والفئات المستهدفة.
4- تحديد آليات التواصل مع العملاء بشكل واضح لهم بشأن تعديلات وثائق التأمين أو تجديدها أو إلغائها ، سواء عبر الرسائل النصية أو البريد الإلكتروني.
5- عند إصدار الوثائق يتعين أن يكون طلب التأمين مبسطًا ومستوفيًا لكافة البيانات الأساسية الخاصة بالعملاء وكذا الإفصاحات عن الحالة الصحية فى حالة التأمين على الحياة والوضع المالى لهم بالشكل الذى يمكن الشركة من تقييم مخاطر العملاء.
6- عند إصدار الوثائق يتعين الالتزام بالاستعلام عن صحة بيانات العملاء وفقًا لقرار مجلس إدارة الهيئة رقم 186 لسنة 2024 المشار إليه.
ثالثًا - معايير تسوية التعويضات :
1- وضع سياسة معتمدة من مجلس إدارة الشركة لتسوية التعويضات الخاصة بمنتجات التأمين متناهى الصغر.
2- يجب أن تكون إجراءات تسوية المطالبات مبسطة مع الاكتفاء بالحد الأدنى من المستندات اللازمة لإثبات المطالبة بما يضمن سرعة البت فيها ، على ألا تتجاوز المدة القصوى للفصل فى المطالبة خمسة أيام عمل من تاريخ استكمال المستندات المطلوبة.
3- وضع آلية مبسطة تمكن المؤمن له أو المستفيد أو من ينوب عنه فى إخطار شركة التأمين بالمطالبة بأى وسيلة اتصال ميسرة (مكتوبة أو إلكترونية أو عبر مركز الاتصال).
4- إبلاغ المؤمن له كتابة أو إلكترونيًا بالإجراءات الواجب اتباعها والمستندات المطلوبة لتسوية المطالبة فور تلقي الإخطار.
5- تلتزم الشركة بسداد التعويض خلال يومى عمل كحد أقصى من تاريخ الموافقة عليه.$b4_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - بيانات وثائق التأمين متناهى الصغر$t5_0$, $b5_0$يجب أن تتضمن وثائق التأمين متناهى الصغر البيانات الآتية :
1- رقم الوثيقة ، على أن يذكر فى جميع الأوراق التى لها صلة بالوثيقة.
2- اسم المؤمن له وبيانات التواصل معه (بما فى ذلك عنوانه البريدى إن وجد).
3- نوع ووصف التغطية وحدودها.
4- فترة التغطية.
5- الشروط العامة للوثيقة .
6- الاستثناءات الخاصة بالوثيقة على أن تكون فى أضيق الحدود وبما يتفق مع مبادئ التأمين المتعارف عليها.
7- سعر التأمين ، والقسط ، والعمولات المدفوعة عن الوثيقة.
8- المستندات المطلوبة فى حالة المطالبة.
9- الأثر المترتب على إلغاء الوثيقة.
10- المدة التى يتم من خلالها إخطار الشركة المؤمنة بتحقق الخطر ، على ألا تزيد على شهر من تاريخ تحقق الخطر.
11- الجهة التى يتم من خلالها سداد التعويض.
12- شرط الإعذار أو الشرط الفاسخ الذى يتم تحديده وفقًا لطبيعة التأمين.
13- ما يفيد إمهال المؤمن له فترة السماح المناسبة لسداد الأقساط.$b5_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - الجهات التى يجوز لها تسويق وتوزيع وثائق التأمين متناهى الصغر رقميًا$t6_0$, $b6_0$يجوز تسويق وتوزيع وثائق التأمين متناهى الصغر رقميًا من خلال شبكات نظم المعلومات من خلال إحدى الجهات الآتية :
1- الجهات المنصوص عليها بالمادة الخامسة من قرار مجلس إدارة الهيئة رقم 199 لسنة 2025 المشار إليه عدا البند (ه) منها.
2- الشركات والجمعيات والمؤسسات الأهلية (أ ، ب) المرخص لها بمزاولة نشاط تمويل المشروعات متناهية الصغر.
3- البنك الزراعى المصري.
4- الجهات الأخرى التى توافق عليها الهيئة .
وذلك كله بمراعاة الضوابط المشار إليها بالمادة الخامسة من قرار مجلس إدارة الهيئة رقم 199 لسنة 2025 عند التعاقد مع أى من الفئات المشار إليها بهذه المادة.$b6_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - تدريب المعنيين بالإصدار والتوزيع لوثائق التأمين متناهى الصغر$t7_0$, $b7_0$تلتزم الشركات المخاطبة بأحكام هذا القرار بتوفير التدريب اللازم لأعضاء الجهاز الإنتاجى بالشركة والوسطاء والعاملين بجهات التسويق والتوزيع ، على أن يشمل التدريب - بحد أدنى - التعرف على ما يلي :
1- الأحكام الرئيسية لقانون التأمين الموحد والقرارات الصادرة عن مجلس إدارة الهيئة تنفيذًا له.
2- طبيعة التأمين متناهى الصغر ، وخصائص المنتجات التى تصدرها الشركة وإجراءات إصدارها ، ومزاياها.
3- إجراءات توزيع المنتج وخدمته والتعامل مع المطالبات وتسويتها وصرف التعويضات.
4- حقوق والتزامات العملاء ، والأحكام الخاصة بسرية بياناتهم وخصوصية معلوماتهم.
5- إجراءات تقديم وفحص وتسوية الشكاوى المقدمة من العملاء.$b7_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة - التقارير الرقابية$t8_0$, $b8_0$تلتزم الشركات المخاطبة بأحكام هذا القرار بتقديم تقرير للهيئة كل ثلاثة أشهر بشأن عمليات التأمين متناهى الصغر ، على أن يتضمن التقرير بحد أدنى ما يلي :
1- فرع التأمين.
2- التغطية التأمينية.
3- نوع التأمين (فردى - جماعى فى حالة التأمين على الحياة).
4- عدد الوثائق (جديدة - مجددة).
5- مبالغ التأمين.
6- الأقساط (محصلة - تحت التحصيل).
7- الحالة الإنتاجية (إدارة - وسطاء - غير ذلك) .
8- العمولات المسددة .
9- المطالبات .$b8_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة - التثقيف المالى والتأمينى$t9_0$, $b9_0$تلتزم الشركات المخاطبة بأحكام هذا القرار بوضع برامج للتثقيف المالى والتأمينى موجهة للفئات المستهدفة من منتجات التأمين متناهى الصغر ، وذلك باستخدام وسائل مبسطة ؛ كالرسائل النصية (SMS) النشرات المصورة ، مقاطع الفيديو التوعوية القصيرة ، والندوات بالتعاون مع الجمعيات والمؤسسات الأهلية ، على أن تتضمن هذه البرامج شرحًا لماهية التأمين متناهى الصغر ، وعلى وجه الأخص ؛ حقوق والتزامات العملاء وإجراءات تقديم وفحص وتسوية الشكاوى المقدمة منهم.
ويجب الحصول على موافقة الهيئة المسبقة على المواد المستخدمة لتثقيف وطرقها.$b9_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins9_0;

WITH ins10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $t10_0$المادة العاشرة - توفيق الأوضاع$t10_0$, $b10_0$تلتزم الشركات المخاطبة بأحكام هذا القرار بتوفيق أوضاعها وفقًا لأحكامه خلال ستة أشهر من تاريخ العمل به.$b10_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins10_0;

WITH ins11_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, $t11_0$المادة الحادية عشرة$t11_0$, $b11_0$يلغى قرار رئيس الهيئة رقم 902 لسنة 2016 المشار إليه ، كما يلغى كل حكم يخالف أحكام هذا القرار.$b11_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins11_0;

WITH ins12_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, NULL, $t12_0$المادة الثانية عشرة$t12_0$, $b12_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لنشره بالوقائع المصرية.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b12_0$
  FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins12_0;

DO $verify178$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 319 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[178] القرار 319/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 13 THEN RAISE EXCEPTION '[178] عدد المواد % بدل 13', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2026-02-06';
  IF v_v <> 13 THEN RAISE EXCEPTION '[178] عدد النسخ % بدل 13', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع املصرية%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%فبراير سنة 2026%' OR body LIKE '%املصرية%' OR body LIKE '%صورة إ%' OR body LIKE '%ل تداول%' OR body LIKE '%تد بها%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%( )%' OR body LIKE '%٪%' OR body LIKE '%٢٠%' OR body LIKE '%ال يقل%' OR body LIKE '%ثان ًيا%' OR body LIKE '%- 1%' OR body LIKE '%نطاق التطبيق%' OR body LIKE '%تعريف التأمين متناهى الصغر%' OR body LIKE '%التقارير الرقابية%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[178] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%ه المنعقدة بتاريخ 2025/12/24 ؛' AND body LIKE '%رقم 10 لسنة 2009 بتنظيم الرقابة%' AND body LIKE '%رقم 141 لسنة 2014 بتنظيم مزاولة نشاط تمويل%' AND body LIKE '%رقم 155 لسنة 2024 والقرارات%' AND body LIKE '%رقم 186 لسنة 2024 بشأن الالتزام بالاستعلام%' AND body LIKE '%رقم 18 لسنة 2025 بشأن زيادة الحد الأقصى%' AND body LIKE '%رقم 199 لسنة 2025 بشأن تنظيم إصدار%' AND body LIKE '%قرار رئيس الهيئة رقم 902 لسنة 2016 بشأن تعريف%' AND body LIKE '%بتاريخ 2025/12/24 ؛') THEN RAISE EXCEPTION '[178] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تسرى أحكام هذا القرار فى شأن الشروط والقواعد%' AND body LIKE '%مة لنشاط التأمين متناهى الصغر.' AND body LIKE '%والقواعد الحاكمة لنشاط التأمين متناهى الصغر.') THEN RAISE EXCEPTION '[178] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يعد تأمين متناهى الصغر كل تأمين يستهدف ذوى ال%' AND body LIKE '%جلس إدارة الهيئة فى هذا الشأن.' AND body LIKE '%وبحد أقصى للتغطية التأمينية يتحدد%') THEN RAISE EXCEPTION '[178] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'تصدر وثائق التأمين متناهى الصغر فى فروع التأم%' AND body LIKE '%تأمين أخرى توافق عليها الهيئة.' AND body LIKE '%أولاً - وثائق التأمين متناهى الصغر بالنسبة للأشخاص%' AND body LIKE '%3- تأمينات العلاج الطبى طويل الأجل.%' AND body LIKE '%ثانيًا - وثائق التأمين متناهى الصغر بالنسبة لتأمينات الممتلكات%' AND body LIKE '%10- أى فروع تأمين أخرى توافق عليها الهيئة.') THEN RAISE EXCEPTION '[178] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يجب على الشركات عند مزاولة نشاط التأمين متناه%' AND body LIKE '%د أقصى من تاريخ الموافقة عليه.' AND body LIKE '%أولاً - معايير عامة :%' AND body LIKE '%ثانيًا - معايير وأسس الاكتتاب وإصدار الوثائق والتسويق :%' AND body LIKE '%ثالثًا - معايير تسوية التعويضات :%' AND body LIKE '%خمسة أيام عمل من تاريخ استكمال%' AND body LIKE '%5- تلتزم الشركة بسداد التعويض خلال يومى عمل كحد أقصى%' AND body LIKE '%رقم 186 لسنة 2024 المشار إليه.%') THEN RAISE EXCEPTION '[178] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يجب أن تتضمن وثائق التأمين متناهى الصغر البيا%' AND body LIKE '%السماح المناسبة لسداد الأقساط.' AND body LIKE '%12- شرط الإعذار أو الشرط الفاسخ%' AND body LIKE '%على ألا تزيد على شهر%' AND body LIKE '%13- ما يفيد إمهال المؤمن له فترة السماح المناسبة لسداد الأقساط.') THEN RAISE EXCEPTION '[178] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'يجوز تسويق وتوزيع وثائق التأمين متناهى الصغر%' AND body LIKE '%فئات المشار إليها بهذه المادة.' AND body LIKE '%عدا البند (ه) منها.%' AND body LIKE '%(أ ، ب)%' AND body LIKE '%4- الجهات الأخرى التى توافق عليها الهيئة%' AND body LIKE '%رقم 199 لسنة 2025 عند التعاقد%') THEN RAISE EXCEPTION '[178] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات المخاطبة بأحكام هذا القرار بتوف%' AND body LIKE '%ية الشكاوى المقدمة من العملاء.' AND body LIKE '%على أن يشمل التدريب - بحد أدنى - التعرف على ما يلي :%' AND body LIKE '%5- إجراءات تقديم وفحص وتسوية الشكاوى المقدمة من العملاء.') THEN RAISE EXCEPTION '[178] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات المخاطبة بأحكام هذا القرار بتقد%' AND body LIKE '%9- المطالبات .' AND body LIKE '%كل ثلاثة أشهر%' AND body LIKE '%3- نوع التأمين (فردى - جماعى فى حالة التأمين على الحياة).%' AND body LIKE '%9- المطالبات .') THEN RAISE EXCEPTION '[178] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات المخاطبة بأحكام هذا القرار بوضع%' AND body LIKE '%لمواد المستخدمة لتثقيف وطرقها.' AND body LIKE '%(SMS)%' AND body LIKE '%ويجب الحصول على موافقة الهيئة المسبقة على المواد المستخدمة لتثقيف وطرقها.') THEN RAISE EXCEPTION '[178] المادة 9 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات المخاطبة بأحكام هذا القرار بتوف%' AND body LIKE '%ال ستة أشهر من تاريخ العمل به.' AND body LIKE '%خلال ستة أشهر من تاريخ العمل به.') THEN RAISE EXCEPTION '[178] المادة 10 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0 AND body LIKE 'يلغى قرار رئيس الهيئة رقم 902 لسنة 2016 المشا%' AND body LIKE '%كل حكم يخالف أحكام هذا القرار.' AND body LIKE '%يلغى قرار رئيس الهيئة رقم 902 لسنة 2016 المشار إليه ،%' AND body LIKE '%يخالف أحكام هذا القرار.') THEN RAISE EXCEPTION '[178] المادة 11 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 12 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به من اليوم التالى لنشره بالوقائع المصرية.%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[178] المادة 12 غير سليم'; END IF;
  IF v_len <> 8116 THEN RAISE EXCEPTION '[178] إجمالى طول المواد % بدل 8116', v_len; END IF;
  RAISE NOTICE '[178] القرار 319/2025: 13 مواد و13 نسخ، إجمالى % حرف', v_len;
END
$verify178$;

COMMIT;
