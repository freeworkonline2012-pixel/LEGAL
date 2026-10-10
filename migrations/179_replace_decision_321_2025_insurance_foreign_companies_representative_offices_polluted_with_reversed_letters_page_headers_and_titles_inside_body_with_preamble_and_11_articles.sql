-- 179_replace_decision_321_2025_insurance_foreign_companies_representative_offices_polluted_with_reversed_letters_page_headers_and_titles_inside_body_with_preamble_and_11_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (321) لسنة 2025 بشأن شروط وضوابط الترخيص بإنشاء مكاتب تمثيل فى مصر للشركات الأجنبية التى تعمل فى مجال التأمين أو إعادة التأمين أو الأنشطة والخدمات المرتبطة بها،
-- المنشور بالوقائع المصرية، العدد 29، فى 5 فبراير 2026 (الصفحات 24 إلى 29): ديباجة و11 مادة، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (11 صفاً، 6247 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) 344 حرف تلف (U+FFFD) فى المواد كلها (مكان بقايا التطويل داخل الكلمات: "تلت���زم" و"الش���ركات")؛
-- (2) حروف اللام ألف مقلوبة الترتيب (28 موضعاً: "األجنبية" و"األنشطة" و"اإللكترونى" و"اآلتية" و"خالل")، وتنوين مفصول عن حرفه (12 موضعاً)، وضمة مفصولة (5 مواضع)،
--     و103 فواصل CRLF داخل الجمل، وأرقام بنود معكوسة ومحشورة، وأرقام هندية وفارسية (8 أرقام)؛
-- (3) خمس ترويسات صفحات داخل المتن ("الوقائع املصرية -العدد 29فى 5فبراير سنة 2026 ...") فى المواد 2 و3 و4 و7 و9، تقطع البنود فى منتصفها؛
-- (4) عنوان كل مادة من المواد 1 إلى 10 مخزَّن فى أول المتن ملصقاً بالنص بدل أن يكون فى حقل العنوان، والتوقيع مبعثراً ("د .محمد فريد صالح") فى المادة 11؛
-- (5) بلا ديباجة (اطلاعان وموافقة مجلس الإدارة بجلسة 2025/12/24) وبلا تاريخ سريان (التاريخ المخزَّن تاريخ تشغيل البذر).
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: تقطّع شروط الترخيص ومستنداته (المادتان 2 و3) بترويسة الوقائع، وتلف الحروف يُفسد البحث النصى.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (6 صفحات، 381 كيلوبايت) قدّمه صاحب المشروع؛ بملف تالف جدول المراجع (xref) فأُصلح بـqpdf قبل القراءة.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات والبنود والعناوين بإحداثيات الأسطر. وطُبّقت قاعدة عرض الحرف لعيبى الترميز المعروفين فى خط هذه الوقائع («ين» النهائى المتصل و«لأ» المتصل) على كل صفحة فلم يلزم تصحيح شىء فى هذا الملف.
-- حُذفت ترويسة كل صفحة ورقمها، وسطر "الهيئة العامة للرقابة المالية" وعنوان القرار وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 11 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- عناوين المواد 1 إلى 10 (المطبوعة وسطاً تحت "(المادة ...)") فى حقل العنوان بالصيغة "المادة <الترتيب> - <العنوان>"؛ والمادة 11 بلا عنوان فى الأصل فعنوانها "المادة الحادية عشرة".
-- بنود المواد تُعرض "N- نص"، والمادتان 6 و7 فقرتان أو أكثر كما طُبعتا.
-- لا تعديل على المطبوع. أُبقيت كتابة الأصل كما هى، ومنها هفوات المطبوع: "لسنه 2009" بالهاء فى الديباجة، و"الصادة عن مجلس إدارتها" (المادة 7)، وقوس إغلاق زائد فى آخر البند 7 من المادة 3 ("ذلك التصنيف)."),
-- و"الشركة الذى يمثلها" و"المصري" بالياء، وغياب المسافة قبل النقطة فى بعض البنود وكذلك وجودها فى غيرها ("وعنوانه ."). الأرقام لاتينية، والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل،
-- وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛").
-- قوبل النص المُدخَل بمخرجات OCR مستقل (tesseract ara) على صور الصفحات الست: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام والعناوين وخلط الباء والياء والنون وأسطر أسقطها التعرف، وقُرئت صورتا الصفحتين 1 و3 فصار ما فى النص كما فى الصورة.
--
-- ===== الهيكل =====
-- 12 صفاً، 12 نسخة (version_no = 1): ديباجة (article_no = 0) باطلاعين (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024 والقرارات الصادرة تنفيذاً له)
-- وموافقة مجلس الإدارة بجلسته بتاريخ 2025/12/24؛ ثم المواد 1 إلى 11 بأرقامها الأصلية، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 إلى 11 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2026-02-06: المادة 11 تعمل بالقرار "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 29 بتاريخ 2026/2/5 (ثابت بترويسة الصفحات الست). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 10 تُمهل الشركات الأجنبية ومكاتب التمثيل القائمة ستة أشهر من تاريخ العمل به لتوفيق أوضاعها، فتنتهى المهلة 2026/8/6. هذه الهجرة تنقل النص كما نُشر ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (12 صفاً بديباجة سليمة والمادة 11 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 5321 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix179$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[179] القرار 321/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 12
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[179] القرار 321/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[179] أُزيلت % مادة من القرار 321/2025 (نص مخزَّن ملوَّث بتلف حروف وترويسات صفحات داخل المواد وعناوين داخل المتن وبلا ديباجة)', v_n;
  END IF;
END
$fix179$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 321 لسنة 2025 (منشور بالوقائع المصرية العدد 29 فى 2026/2/5) بشأن شروط وضوابط الترخيص بإنشاء مكاتب تمثيل فى مصر للشركات الأجنبية التى تعمل فى مجال التأمين أو إعادة التأمين أو الأنشطة والخدمات المرتبطة بها$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنه 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 والقرارات الصادرة تنفيذًا له ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/12/24 ؛$b0_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - نطاق التطبيق$t1_0$, $b1_0$تسرى أحكام هذا القرار فى شأن شروط وضوابط الترخيص بإنشاء مكاتب تمثيل فى مصر للشركات الأجنبية التى تعمل فى مجال التأمين أو إعادة التأمين أو الأنشطة والخدمات المرتبطة بها.$b1_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - شروط الترخيص بإنشاء مكاتب التمثيل$t2_0$, $b2_0$تلتزم الشركات الأجنبية التى تعمل فى مجال التأمين أو إعادة التأمين أو الأنشطة والخدمات المرتبطة بها حال رغبتها فى الحصول على ترخيص بإنشاء مكاتب تمثيل لها فى مصر باستيفاء الشروط الآتية :
1- أن تكون الشركة الأجنبية خاضعة لرقابة جهة نظيرة للهيئة فيما يتعلق بالرقابة على نشاط التأمين.
2- الحصول على موافقة الجهة المشار إليها بالبند السابق على فتح مكتب تمثيل للشركة الأجنبية فى مصر.
3- التعهد بأن يقتصر نشاط مكتب التمثيل على دراسة سوق التأمين والعلاقات العامة والاتصالات ، والقيام بدور حلقة اتصال مع المركز الرئيسى له فى الخارج ، والمساهمة فى تذليل المشاكل والصعوبات وتقديم التسهيلات لشركات السوق المحلية.
4- التعهد بعدم ممارسة المكتب لأى من أنشطة التأمين أو إعادة التأمين أو الأنشطة والخدمات المرتبطة بهما.
وفى جميع الأحوال ، لا يجوز للشركة الأجنبية أن توكل أو تعهد لأى جهة أخرى بخلاف مكتب التمثيل المرخص لها بإنشائه فى مصر للقيام بالدور المنوط بتلك المكاتب.$b2_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - إجراءات الترخيص$t3_0$, $b3_0$يقدم طلب الحصول على الترخيص بإنشاء مكتب تمثيل لشركة أجنبية فى مصر إلى الهيئة ، على النموذج المعد منها لهذا الغرض مرفقًا به المستندات الدالة على استيفاء الشروط الواردة بالمادة الثانية من هذا القرار ، بالإضافة إلى ما يلي :
1- بيان يتضمن اسم ومقر وعنوان الشركة فى الخارج وعنوان المكتب فى مصر.
2- صورة من النظام الأساسى للشركة ، مصحوبًا بترجمة معتمدة له إلى اللغة العربية.
3- صورة من القوائم المالية للشركة عن آخر سنتين ماليتين مرفقًا بهما تقرير مراقب الحسابات بشأنها.
4- البيانات الخاصة بالمدير المسئول عن إدارة المكتب بما فيها اسمه وجنسيته وخبرته ، على أن يرفق بذلك ما يفيد توافر خبرة لديه فى مجال التأمين أو إعادة التأمين أو أحد الأنشطة والخدمات المرتبطة بهما لا تقل عن خمس سنوات وفقًا لطبيعة نشاط الشركة التى يمثلها المكتب والدور المنوط بالمكتب القيام به.
5- تقرير من الشركة مبينًا به جدوى وأهداف واستراتيجية وخطة عمل المكتب فى مصر ، وكذا الأنشطة التى يرغب المكتب فى مزاولتها.
6- الهيكل التنظيمى للمكتب متضمنًا بيان بالعدد المقترح للعاملين به ومؤهلاتهم وخبراتهم.
7- ما يفيد حصول الشركة الذى يمثلها المكتب على تصنيف ائتمانى محلى أو دولى من قبل إحدى وكالات التصنيف الائتمانية التى تعتد بها الهيئة وذلك فى حال حصول الشركة على ذلك التصنيف).
8- تعهد من الشركة الذى يمثلها مكتب التمثيل بالالتزام بالتشريعات المعمول بها.
9- ما يفيد سداد رسم التسجيل بواقع مبلغ قدره خمسة آلاف دولار أمريكى أو ما يعادله بالعملات الأجنبية الحرة التى يقبلها البنك المركزى المصري.$b3_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - البت فى طلب الترخيص$t4_0$, $b4_0$تقوم الهيئة بدراسة طلب الترخيص بإنشاء مكتب التمثيل والبت فيه خلال ثلاثين يومًا على الأكثر من تاريخ تقديمه مستوفيًا المتطلبات اللازمة للبت فيه ، وللهيئة طلب استيفاء أى بيانات أو مستندات أخرى لازمة لإصدار موافقتها ، ويجوز لها إجراء فحص ميدانى للمكتب للتحقق من استيفاء المتطلبات اللازمة لمزاولة المكتب لنشاطه.$b4_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - تسجيل مكتب التمثيل لدى الهيئة$t5_0$, $b5_0$يسجل المكتب حال الموافقة على الترخيص بإنشائه بالسجل المعد لهذا الغرض بالهيئة ، ويتضمن السجل بحد أدنى البيانات الآتية :
1- اسم المكتب وعنوانه .
2- اسم الشركة الذى يمثلها المكتب وجنسيتها ومقر وعنوان مركزها الرئيسى واسم الجهة الرقابية الخاضعة لها.
3- تاريخ بدء نشاط المكتب فى مصر ، وتاريخ التجديد.
4- البيانات الخاصة بالمسئول عن إدارة المكتب.$b5_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - تجديد التسجيل$t6_0$, $b6_0$تجدد الموافقة الصادرة لمكتب التمثيل على تسجيله لدى الهيئة ، سنويًا ، بناءً على طلب تقدمه الشركة للهيئة قبل انتهاء مدة تسجيل المكتب بشهرين ، وذلك شريطة استمرار توافر المتطلبات المشار إليها بهذا القرار وإرفاق تقرير سنوى عن نشاط المكتب فى مصر.
ويكون رسم تجديد القيد بواقع مبلغ قدره ألف دولار أو ما يعادله بالعملات الأجنبية الحرة التى يقبلها البنك المركزي المصري.$b6_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - تعديل بيانات تسجيل مكتب التمثيل$t7_0$, $b7_0$يجب على الشركة فى حال رغبتها فى تعديل بيانات تسجيل المكتب ، تقديم طلب بذلك للهيئة مرفقًا به ما يفيد عدم ممانعة الجهة الرقابية الخاضعة لها الشركة على تعديل بيانات التسجيل.
ويتعين على المكتب إخطار الهيئة حال تحقق أى من الحالات الآتية :
1- التغييرات التى تطرأ على الشركة الذى يمثلها المكتب ، وعلى وجه الأخص ؛ البيانات المقدمة للحصول على الترخيص بإنشاء المكتب أو عند إجراء تعديل فى هيكل ملكيتها أو تصنيفها الائتماني ، مع الالتزام بتقديم صور من القوائم المالية المعتمدة للشركة وكذا التقارير السنوية الصادة عن مجلس إدارتها.
2- التغييرات التى تطرأ على المكتب بما فى ذلك تغيير المدير المسئول أو عنوان المكتب أو خطة عمله أو الأنشطة التى يقوم بها.
ويجب إخطار الهيئة بأى من الحالات السابقة خلال عشرة أيام ، كما يتعين إخطار الهيئة فى حالة رغبة الشركة فى وقف نشاط المكتب فى مصر سواء بصورة مؤقتة أو نهائية وذلك قبل الوقف بشهرين مع توضيح السبب والمدة فى حال الوقف المؤقت.$b7_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة - الرقابة على أعمال مكاتب التمثيل$t8_0$, $b8_0$تلتزم مكاتب التمثيل حال اتخاذ إجراءات فحصها من قبل الهيئة بموافاتها بكافة البيانات والمعلومات اللازمة للفحص ، وكذا أى بيانات أو مستندات أخرى ترى الهيئة ضرورة تقديمها فى هذا الشأن.$b8_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة - شطب مكاتب التمثيل$t9_0$, $b9_0$يشطب مكتب التمثيل من سجل الهيئة بقرار من مجلس إدارة الهيئة فى أى من الحالات الآتية :
1- بناءً على طلب الشركة التى يمثلها المكتب.
2- مخالفة المكتب لأى من الأحكام الواجب عليه الالتزام بها ، وذلك حال عدم الالتزام بإزالة هذه المخالفات بعد إنذاره خلال ثلاثين يومًا من تاريخ الإنذار.
3- عدم تجديد الموافقة على تسجيل المكتب لدى الهيئة.$b9_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins9_0;

WITH ins10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $t10_0$المادة العاشرة - توفيق الأوضاع$t10_0$, $b10_0$تلتزم الشركات الأجنبية ومكاتب التمثيل التابعة لها القائمة وقت العمل بهذا القرار بتوفيق أوضاعها وفقًا لأحكامه خلال ستة أشهر من تاريخ العمل به.$b10_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins10_0;

WITH ins11_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, $t11_0$المادة الحادية عشرة$t11_0$, $b11_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b11_0$
  FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-06', 'active' FROM ins11_0;

DO $verify179$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 321 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[179] القرار 321/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 12 THEN RAISE EXCEPTION '[179] عدد المواد % بدل 12', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2026-02-06';
  IF v_v <> 12 THEN RAISE EXCEPTION '[179] عدد النسخ % بدل 12', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع املصرية%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%فبراير سنة 2026%' OR body LIKE '%املصرية%' OR body LIKE '%صورة إ%' OR body LIKE '%ل تداول%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%( )%' OR body LIKE '%٪%' OR body LIKE '%٢٠%' OR body LIKE '%ال يقل%' OR body LIKE '%- 1%' OR body LIKE '%نطاق التطبيق%' OR body LIKE '%توفيق األوضاع%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[179] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنه 2009 بتنظ%' AND body LIKE '%ه المنعقدة بتاريخ 2025/12/24 ؛' AND body LIKE '%رقم 10 لسنه 2009 بتنظيم الرقابة%' AND body LIKE '%رقم 155 لسنة 2024 والقرارات%' AND body LIKE '%بتاريخ 2025/12/24 ؛') THEN RAISE EXCEPTION '[179] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تسرى أحكام هذا القرار فى شأن شروط وضوابط التر%' AND body LIKE '%الأنشطة والخدمات المرتبطة بها.' AND body LIKE '%شروط وضوابط الترخيص بإنشاء مكاتب تمثيل فى مصر للشركات الأجنبية%' AND body LIKE '%والخدمات المرتبطة بها.') THEN RAISE EXCEPTION '[179] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات الأجنبية التى تعمل فى مجال التأ%' AND body LIKE '%ام بالدور المنوط بتلك المكاتب.' AND body LIKE '%1- أن تكون الشركة الأجنبية خاضعة لرقابة جهة نظيرة للهيئة%' AND body LIKE '%2- الحصول على موافقة الجهة المشار إليها بالبند السابق%' AND body LIKE '%4- التعهد بعدم ممارسة المكتب%' AND body LIKE '%وفى جميع الأحوال ، لا يجوز للشركة الأجنبية أن توكل%' AND body LIKE '%بخلاف مكتب التمثيل المرخص لها بإنشائه فى مصر%' AND body LIKE '%بتلك المكاتب.') THEN RAISE EXCEPTION '[179] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يقدم طلب الحصول على الترخيص بإنشاء مكتب تمثيل%' AND body LIKE '%ى يقبلها البنك المركزى المصري.' AND body LIKE '%استيفاء الشروط الواردة بالمادة الثانية من هذا القرار ، بالإضافة إلى ما يلي :%' AND body LIKE '%لا تقل عن خمس سنوات وفقًا لطبيعة نشاط الشركة%' AND body LIKE '%حال حصول الشركة على ذلك التصنيف).%' AND body LIKE '%9- ما يفيد سداد رسم التسجيل بواقع مبلغ قدره خمسة آلاف دولار أمريكى%' AND body LIKE '%البنك المركزى المصري.') THEN RAISE EXCEPTION '[179] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'تقوم الهيئة بدراسة طلب الترخيص بإنشاء مكتب ال%' AND body LIKE '%اللازمة لمزاولة المكتب لنشاطه.' AND body LIKE '%خلال ثلاثين يومًا على الأكثر من تاريخ تقديمه%' AND body LIKE '%لنشاطه.') THEN RAISE EXCEPTION '[179] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يسجل المكتب حال الموافقة على الترخيص بإنشائه%' AND body LIKE '%خاصة بالمسئول عن إدارة المكتب.' AND body LIKE '%4- البيانات الخاصة بالمسئول عن إدارة المكتب.' AND body LIKE '%1- اسم المكتب وعنوانه .%' AND body LIKE '%3- تاريخ بدء نشاط المكتب فى مصر ، وتاريخ التجديد.%') THEN RAISE EXCEPTION '[179] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'تجدد الموافقة الصادرة لمكتب التمثيل على تسجيل%' AND body LIKE '%ى يقبلها البنك المركزي المصري.' AND body LIKE '%قبل انتهاء مدة تسجيل المكتب بشهرين%' AND body LIKE '%ويكون رسم تجديد القيد بواقع مبلغ قدره ألف دولار%') THEN RAISE EXCEPTION '[179] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'يجب على الشركة فى حال رغبتها فى تعديل بيانات%' AND body LIKE '%بب والمدة فى حال الوقف المؤقت.' AND body LIKE '%عدم ممانعة الجهة الرقابية الخاضعة لها الشركة%' AND body LIKE '%التقارير السنوية الصادة عن مجلس إدارتها.%' AND body LIKE '%خلال عشرة أيام%' AND body LIKE '%قبل الوقف بشهرين مع توضيح السبب والمدة فى حال الوقف المؤقت.') THEN RAISE EXCEPTION '[179] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'تلتزم مكاتب التمثيل حال اتخاذ إجراءات فحصها م%' AND body LIKE '%ئة ضرورة تقديمها فى هذا الشأن.' AND body LIKE '%ترى الهيئة ضرورة تقديمها فى هذا الشأن.') THEN RAISE EXCEPTION '[179] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'يشطب مكتب التمثيل من سجل الهيئة بقرار من مجلس%' AND body LIKE '%ة على تسجيل المكتب لدى الهيئة.' AND body LIKE '%1- بناءً على طلب الشركة التى يمثلها المكتب.%' AND body LIKE '%خلال ثلاثين يومًا من تاريخ الإنذار.%' AND body LIKE '%3- عدم تجديد الموافقة على تسجيل المكتب لدى الهيئة.') THEN RAISE EXCEPTION '[179] المادة 9 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات الأجنبية ومكاتب التمثيل التابعة%' AND body LIKE '%ال ستة أشهر من تاريخ العمل به.' AND body LIKE '%خلال ستة أشهر من تاريخ العمل به.') THEN RAISE EXCEPTION '[179] المادة 10 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية.%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[179] المادة 11 غير سليم'; END IF;
  IF v_len <> 5321 THEN RAISE EXCEPTION '[179] إجمالى طول المواد % بدل 5321', v_len; END IF;
  RAISE NOTICE '[179] القرار 321/2025: 12 مواد و12 نسخ، إجمالى % حرف', v_len;
END
$verify179$;

COMMIT;
