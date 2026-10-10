-- 180_replace_decision_326_2025_government_insurance_fund_azhar_students_terms_and_prices_polluted_with_reversed_letters_page_headers_and_titles_inside_body_with_preamble_and_5_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (326) لسنة 2025 بشأن شروط وأسعار عمليات التأمين التى يغطيها صندوق التأمين الحكومى على طلاب التعليم الأزهرى،
-- المنشور بالوقائع المصرية، العدد 30، فى 7 فبراير 2026 (الصفحات 24 إلى 26): ديباجة و5 مواد، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (5 صفوف، 1724 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) 82 حرف تلف (U+FFFD) فى المواد كلها (مكان بقايا التطويل داخل الكلمات: "تس���رى" و"ش���أن" و"يص���رف")؛
-- (2) حروف اللام ألف مقلوبة الترتيب فى كلمات منها "التعويض" و"طالب" (طلاب) و"ثالثون" (ثلاثون) و"تحميالت" (تحميلات) و"االشتراك" و"اإلصابة" و"باألزهر"، وتنوين مفصول عن حرفه (6 مواضع)، وضمة مفصولة (موضعان)،
--     و30 فاصل CRLF داخل الجمل، ورقم بند معكوس ومحشور ("- 1مبلغ 19.23جنيه")، ورقم فارسى ("۲") وفاصلة عشرية عربية ("23٫78") فى سعر المادة 2 بينما سعر البند 1 بنقطة لاتينية؛
-- (3) ترويستان للوقائع داخل المتن ("الوقائع املصرية -العدد 30 ...") فى المادتين 1 و3؛
-- (4) عنوان كل مادة من المواد 1 إلى 4 مخزَّن فى أول المتن ملصقاً بالنص بدل أن يكون فى حقل العنوان، والتوقيع مبعثراً ("د .محمد فريد صالح") فى المادة 5؛
-- (5) بلا ديباجة (ستة اطلاعات وموافقة مجلس إدارة الهيئة بجلسة 2025/12/24) وبلا تاريخ سريان (التاريخ المخزَّن تاريخ تشغيل البذر).
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: القرار قرار أسعار (19.23 جنيه لطلاب التعليم قبل الجامعى و23.78 لطلاب التعليم الجامعى، ومبلغ تأمين الوفاة 30 ألف جنيه)، والتشويه فى أرقام الأسعار وكلمة "طلاب" يُضعف البحث والاستشهاد.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (3 صفحات، 372 كيلوبايت) قدّمه صاحب المشروع؛ بملف تالف جدول المراجع (xref) فأُصلح بـqpdf قبل القراءة.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات والبنود والعناوين بإحداثيات الأسطر. وطُبّقت قاعدة عرض الحرف لعيوب الترميز المعروفة فى خط هذه الوقائع («ين» النهائى المتصل و«لأ» المتصل)، وظهر فى هذا الملف عيب ثالث من النوع نفسه:
-- حرف «لا» المتصل يُرمَّز فى طبقة النص «ا» فقط (تضيع اللام) فيقرأ "الاطاع" و"طاب" و"ثاثون" و"تحميات"؛ وهو يُعرض بضعف عرض الألف العادية (8.4 نقطة مقابل 2.9 و4.3)، فأُصلح بقاعدة العرض على الصفحات الثلاث (10 مواضع: "الاطلاع" وخمس مرات "طلاب" وثلاث مرات "تحميلات" و"ثلاثون")،
-- وتأكد من كل موضع بصورة الصفحة وبمقابلة OCR. (راجع الهجرات اللاحقة: يُفحَص كل ملف بهذه القاعدة.)
-- حُذفت ترويسة كل صفحة ورقمها، وسطر "الهيئة العامة للرقابة المالية" وعنوان القرار وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 5 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- عناوين المواد 1 إلى 4 (المطبوعة وسطاً تحت "(المادة ...)") فى حقل العنوان بالصيغة "المادة <الترتيب> - <العنوان>"؛ والمادة 5 بلا عنوان فى الأصل فعنوانها "المادة الخامسة".
-- بنود المادة 2 تُعرض "N- نص"، وعنوانا فرعى المادة 3 ("أولاً - ..." و"ثانيًا - ...") فى أسطر مستقلة كل منهما يليه فقرته، كما طُبعا؛ والسعران "19.23" و"23.78" بنقطة (كما فى طبقة النص، والمطبوع يعرضها فاصلة صغيرة).
-- تعديل واحد على المطبوع، معلن: "رقم10" فى سطر الاطلاع على القانون 10 لسنة 2009 (الأصل بلا مسافة بين "رقم" والرقم) كُتب "رقم 10". أُبقيت كتابة الأصل بلا تعديل لفظ فيما عدا ذلك، ومنها "الأزهري" و"السنوي" و"المصروفات" بالياء وغياب المسافة قبل النقطة فى بعض البنود ووجودها فى غيرها ("الأزهرى .").
-- الأرقام لاتينية، والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛").
-- قوبل النص المُدخَل بمخرجات OCR مستقل (tesseract ara) على صور الصفحات الثلاث: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام والعناوين وخلط الباء والياء والنون، وقُرئت صورة الصفحة 2 (الأسعار والمزايا) فصار ما فى النص كما فى الصورة.
--
-- ===== الهيكل =====
-- 6 صفوف، 6 نسخ (version_no = 1): ديباجة (article_no = 0) بستة اطلاعات (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024، وقرارا رئيس مجلس الوزراء 1584 لسنة 2019 و3868 لسنة 2022، والطلب المقدم من الصندوق، وموافقة مجلس إدارة الصندوق)
-- وموافقة مجلس إدارة الهيئة بجلسته بتاريخ 2025/12/24؛ ثم المواد 1 إلى 5 بأرقامها الأصلية، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 إلى 5 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-07-01: المادة 5 تنص صراحةً على أن القرار "يُعمل به اعتباراً من 2025/7/1" (بأثر رجعى عن نشره بالعدد 30 بتاريخ 2026/2/7 الثابت بترويسة الصفحات الثلاث)؛ فالتاريخ المنصوص عليه هو تاريخ السريان لا اليوم التالى للنشر. كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (هذه الهجرة تنقل النص كما نُشر ولا تعدّل بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (6 صفوف بديباجة سليمة والمادة 5 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 2012 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix180$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 326 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[180] القرار 326/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 6
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[180] القرار 326/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[180] أُزيلت % مادة من القرار 326/2025 (نص مخزَّن ملوَّث بتلف حروف وترويسات صفحات داخل المواد وعناوين داخل المتن وبلا ديباجة)', v_n;
  END IF;
END
$fix180$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 326 لسنة 2025 (منشور بالوقائع المصرية العدد 30 فى 2026/2/7) بشأن شروط وأسعار عمليات التأمين التى يغطيها صندوق التأمين الحكومى على طلاب التعليم الأزهرى$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 والقرارات الصادرة تنفيذًا له ؛
وعلى قرار رئيس مجلس الوزراء رقم 1584 لسنة 2019 بإنشاء صندوق التأمين الحكومى على طلاب التعليم الأزهري ؛
وعلى قرار رئيس مجلس الوزراء رقم 3868 لسنة 2022 بشأن شروط وأسعار التأمين لدى صندوق التأمين الحكومى لطلاب الأزهر ؛
وعلى الطلب المقدم من الصندوق بشأن تعديل شروط وأسعار التأمين لديه ؛
وعلى موافقة مجلس إدارة الصندوق ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/12/24 ؛$b0_0$
  FROM laws WHERE law_no = 326 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-07-01', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - نطاق التطبيق$t1_0$, $b1_0$تسرى أحكام هذا القرار فى شأن شروط وأسعار عمليات التأمين التى يغطيها صندوق التأمين الحكومى على طلاب التعليم الأزهرى .$b1_0$
  FROM laws WHERE law_no = 326 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-07-01', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - قسط التأمين$t2_0$, $b2_0$يكون مقابل الاشتراك السنوى بالصندوق على النحو الآتى :
1- مبلغ 19.23 جنيه مصرى بدون أى تحميلات لطلاب التعليم قبل الجامعى بالأزهر الشريف .
2- مبلغ 23.78 جنيه مصرى بدون أى تحميلات لطلاب التعليم الجامعى بالأزهر الشريف.
ويسدد مقابل الاشتراك المشار إليه مع المصروفات الدراسية.
وتضاف أى تحميلات يقررها الأزهر الشريف إلى هذا السعر عند تحصيل الاشتراكات ، كما يحل الأزهر الشريف محل الحالات المستثناة فى سداد الاشتراكات حال وجودها.$b2_0$
  FROM laws WHERE law_no = 326 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-07-01', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - المزايا التأمينية$t3_0$, $b3_0$أولاً - التعويض فى حالة الوفاة الطبيعية أو نتيجة حادث والإصابة بالعجز الكلى المستديم :
يصرف الصندوق مبلغ تأمين قدره ثلاثون ألف جنيه مصرى فى حالة الوفاة الطبيعية للطالب أو الناتجة عن حادث ، أو فى حال إصابة الطالب بعجز كلى مستديم نتيجة حادث.
ثانيًا - التعويض فى حالة الإصابة بالعجز الجزئى المستديم الناتج عن حادث :
يلتزم الصندوق بصرف تعويض بنسبة من الحد الأقصى لمبلغ التعويض المشار إليه بالبند أولاً من هذه المادة وذلك فى حالات العجز الجزئى المستديم ، على أن تحدد نسبة العجز بقرار من الجهة الطبية المختصة التى يحددها مجلس إدارة الصندوق.$b3_0$
  FROM laws WHERE law_no = 326 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-07-01', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - مراجعة سعر التأمين$t4_0$, $b4_0$يلتزم الصندوق بمراجعة قيمة الاشتراك السنوي ، دوريًا ، فى ضوء الخبرة الفعلية للصندوق ، وذلك بناءً على دراسة اكتوارية يتم إعدادها فى هذا الشأن وموافاة الهيئة بها فور إعدادها.$b4_0$
  FROM laws WHERE law_no = 326 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-07-01', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة والصندوق ، ويعمل به اعتبارًا من 2025/7/1 ، ويلغى كل حكم يخالف أحكامه.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b5_0$
  FROM laws WHERE law_no = 326 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-07-01', 'active' FROM ins5_0;

DO $verify180$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 326 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[180] القرار 326/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 6 THEN RAISE EXCEPTION '[180] عدد المواد % بدل 6', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-07-01';
  IF v_v <> 6 THEN RAISE EXCEPTION '[180] عدد النسخ % بدل 6', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع املصرية%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%فبراير سنة 2026%' OR body LIKE '%املصرية%' OR body LIKE '%صورة إ%' OR body LIKE '%ل تداول%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%( )%' OR body LIKE '%٪%' OR body LIKE '%٢٠%' OR body LIKE '%ال يقل%' OR body LIKE '%- 1%' OR body LIKE '%نطاق التطبيق%' OR body LIKE '%قسط التأمين%' OR body LIKE '%طاب %' OR body LIKE '%ثاث%' OR body LIKE '%تحميات%' OR body LIKE '%الاطاع%' OR body LIKE '%٫%' OR body LIKE '%طالب التعليم%' OR body LIKE '%تحميالت%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[180] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%ه المنعقدة بتاريخ 2025/12/24 ؛' AND body LIKE '%رقم 10 لسنة 2009 بتنظيم الرقابة%' AND body LIKE '%رقم 155 لسنة 2024 والقرارات%' AND body LIKE '%رقم 1584 لسنة 2019 بإنشاء صندوق التأمين الحكومى على طلاب التعليم الأزهري ؛%' AND body LIKE '%رقم 3868 لسنة 2022 بشأن شروط وأسعار%' AND body LIKE '%وعلى موافقة مجلس إدارة الصندوق ؛%' AND body LIKE '%بتاريخ 2025/12/24 ؛') THEN RAISE EXCEPTION '[180] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تسرى أحكام هذا القرار فى شأن شروط وأسعار عملي%' AND body LIKE '%ومى على طلاب التعليم الأزهرى .' AND body LIKE '%صندوق التأمين الحكومى على طلاب التعليم الأزهرى .') THEN RAISE EXCEPTION '[180] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يكون مقابل الاشتراك السنوى بالصندوق على النحو%' AND body LIKE '%فى سداد الاشتراكات حال وجودها.' AND body LIKE '%1- مبلغ 19.23 جنيه مصرى بدون أى تحميلات لطلاب التعليم قبل الجامعى%' AND body LIKE '%2- مبلغ 23.78 جنيه مصرى%' AND body LIKE '%ويسدد مقابل الاشتراك المشار إليه مع المصروفات الدراسية.%' AND body LIKE '%كما يحل الأزهر الشريف محل الحالات المستثناة%' AND body LIKE '%حال وجودها.') THEN RAISE EXCEPTION '[180] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'أولاً - التعويض فى حالة الوفاة الطبيعية أو نت%' AND body LIKE '%لتى يحددها مجلس إدارة الصندوق.' AND body LIKE '%أولاً - التعويض فى حالة الوفاة الطبيعية أو نتيجة حادث والإصابة بالعجز الكلى المستديم :%' AND body LIKE '%ثلاثون ألف جنيه مصرى%' AND body LIKE '%ثانيًا - التعويض فى حالة الإصابة بالعجز الجزئى المستديم الناتج عن حادث :%' AND body LIKE '%التى يحددها مجلس إدارة الصندوق.') THEN RAISE EXCEPTION '[180] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يلتزم الصندوق بمراجعة قيمة الاشتراك السنوي ،%' AND body LIKE '%موافاة الهيئة بها فور إعدادها.' AND body LIKE '%فى ضوء الخبرة الفعلية للصندوق%' AND body LIKE '%وموافاة الهيئة بها فور إعدادها.') THEN RAISE EXCEPTION '[180] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به اعتبارًا من 2025/7/1 ، ويلغى كل حكم يخالف أحكامه.%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[180] المادة 5 غير سليم'; END IF;
  IF v_len <> 2012 THEN RAISE EXCEPTION '[180] إجمالى طول المواد % بدل 2012', v_len; END IF;
  RAISE NOTICE '[180] القرار 326/2025: 6 مواد و6 نسخ، إجمالى % حرف', v_len;
END
$verify180$;

COMMIT;
