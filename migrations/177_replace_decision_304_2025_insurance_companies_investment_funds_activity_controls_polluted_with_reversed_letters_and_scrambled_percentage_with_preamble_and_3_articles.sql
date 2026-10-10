-- 177_replace_decision_304_2025_insurance_companies_investment_funds_activity_controls_polluted_with_reversed_letters_and_scrambled_percentage_with_preamble_and_3_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (304) لسنة 2025 بشأن ضوابط مزاولة شركات التأمين بنفسها أو مع غيرها نشاط صناديق الاستثمار،
-- المنشور بالوقائع المصرية، العدد 295 (تابع)، فى 30 ديسمبر 2025 (الصفحتان 18 و19): ديباجة و3 مواد، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (3 صفوف، 1262 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) النسبة المئوية فى البند 4 من المادة 1 مبعثرة ("( ) ٪10من الحد األدنى") بأقواس فارغة والنسبة خارجها وعلامة ٪ هندية، وهى شرط جوهرى (الفائض من الأموال الحرة لا يقل عن 10% من الحد الأدنى لرأس المال المصدر)؛
-- (2) حروف اللام ألف مقلوبة الترتيب ("اإلخالل" و"االستثمار" و"األموال" و"المالءة") وبقايا تطويل تالفة (U+FFFD، 18 حرفاً)، وتنوين مفصول ("وف ًقا")، و18 فاصل CRLF داخل الجمل، وأرقام بنود معكوسة ("- 1أن يتوافر")، وأرقام هندية وفارسية (12)، والتوقيع مبعثراً ("د .محمد فريد صالح")؛
-- (3) المادة 2 (إلغاء قرار مجلس إدارة الهيئة رقم 46 لسنة 2014) مبعثرة الترتيب برقم القرار وسنته ("رقم 46لسنة ٢٠١٤المشار إليه")؛
-- (4) بلا ديباجة (سبعة اطلاعات وموافقة مجلس الإدارة بجلسة 2025/12/10) ولا تاريخ سريان.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: تبعثر النسبة (10%) يُنتج جواباً خاطئاً عن حد الفائض، وتلف أرقام المادة 2 يُخفى أن القرار يلغى القرار 46 لسنة 2014 صراحةً.
-- (لا علامة مائية ولا ترويسة صفحة فى النص المخزَّن لهذا القرار.)
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحتان، 360 كيلوبايت) قدّمه صاحب المشروع؛ بملف تالف جدول المراجع (xref) فأُصلح بـqpdf قبل القراءة.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات والبنود بإحداثيات الأسطر. وطُبّقت قاعدة عرض الحرف لعيبى الترميز المعروفين فى خط هذه الوقائع («ين» النهائى المتصل و«لأ» المتصل) على كل صفحة فلم يلزم تصحيح شىء فى هذا الملف.
-- حُذفت ترويسة كل صفحة ورقمها وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 3 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- النسبة كُتبت "(10%)" بلا مسافات داخل القوسين (المطبوع "( 10٪ )")؛ والمادة "(175)" كما طُبعت. البنود الأربعة تُعرض "N- نص". أُبقيت كتابة الأصل بلا تعديل لفظ: "رؤوس" و"مزاولة" و"المزمع إنشاؤه"،
-- وغياب المسافة قبل النقطة فى آخر المادة 3 ("المصرية."). الأرقام لاتينية، والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛").
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحتين: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام والعناوين وخلط الباء والياء والنون، وقُرئت صورة الصفحة 2 فصار ما فى النص كما فى الصورة.
--
-- ===== الهيكل =====
-- 4 صفوف، 4 نسخ (version_no = 1): ديباجة (article_no = 0) بسبعة اطلاعات (قانون سوق رأس المال 95 لسنة 1992، والقانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024، وقرارات مجلس إدارة الهيئة 46 لسنة 2014 و58 لسنة 2018 و196 لسنة 2024 و148 لسنة 2025)
-- وموافقة مجلس الإدارة بجلسته بتاريخ 2025/12/10؛ ثم المواد 1 إلى 3 بأرقامها الأصلية بلا عناوين كما فى الأصل، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 و2 و3 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-12-31: المادة 3 تعمل بالقرار "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 295 (تابع) بتاريخ 2025/12/30 (ثابت بترويسة الصفحتين). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 2 تُلغى صراحةً القرار 46 لسنة 2014. هذه الهجرة تنقل النص كما نُشر ولا تعدّل حالة ذلك القرار فى laws ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (4 صفوف بديباجة سليمة والمادة 3 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 2083 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix177$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 304 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[177] القرار 304/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 4
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[177] القرار 304/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[177] أُزيلت % مادة من القرار 304/2025 (نص مخزَّن ملوَّث بتلف حروف ونسبة مئوية مبعثرة وبلا ديباجة)', v_n;
  END IF;
END
$fix177$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 304 لسنة 2025 (منشور بالوقائع المصرية العدد 295 تابع فى 2025/12/30) بشأن ضوابط مزاولة شركات التأمين بنفسها أو مع غيرها نشاط صناديق الاستثمار$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992 ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة والإشراف على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 46 لسنة 2014 بشأن ضوابط مزاولة شركات التأمين بنفسها لنشاط صناديق الاستثمار المفتوحة وصناديق أسواق النقد وصناديق أدوات الدين ؛
وعلى قرار مجلس إدارة الهيئة رقم 58 لسنة 2018 بشأن قواعد وضوابط وإجراءات الترخيص للبنوك ولبعض الشركات التى تباشر أنشطة مالية غير مصرفية أن تباشر بنفسها أو مع غيرها نشاط صناديق الاستثمار ؛
وعلى قرار مجلس إدارة الهيئة رقم 196 لسنة 2024 بشأن تحديد الحد الأدنى لرؤوس أموال الشركات العاملة فى قطاع التأمين ؛
وعلى قرار مجلس إدارة الهيئة رقم 148 لسنة 2025 بشأن معايير الملاءة المالية لشركات التأمين ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/12/10 ؛$b0_0$
  FROM laws WHERE law_no = 304 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$مع عدم الإخلال بقرار مجلس إدارة الهيئة رقم 58 لسنة 2018 المشار إليه ، تلتزم شركات التأمين حال رغبتها فى مزاولة نشاط صناديق الاستثمار بنفسها أو مع غيرها باستيفاء الشروط الآتية :
1- أن يتوافر لدى الشركة الأموال المخصصة الكافية لمقابلة التزاماتها قبل حملة الوثائق وفقًا لأحكام المادة (175) من قانون التأمين الموحد.
2- الالتزام بالمعايير المتطلبة للملاءة المالية لشركات التأمين ، وذلك من واقع آخر قوائم مالية معتمدة للشركة.
3- ألا يقل صافى حقوق الملكية بعد استبعاد كل من المبالغ المجنبة من شركة التأمين للاكتتاب فى وثائق صناديق الاستثمار بما فى ذلك الصندوق المزمع إنشاؤه والمبالغ المستثمرة من الشركة فى رؤوس أموال شركات صناديق الاستثمار ، عن الحد الأدنى المقرر لرأس المال المصدر لشركات التأمين.
4- ألا يقل الفائض من الأموال الحرة بعد استبعاد كل من المبالغ المجنبة من شركة التأمين للاكتتاب فى وثائق صناديق الاستثمار بما فى ذلك الصندوق المزمع إنشاؤه والمبالغ المستثمرة من الشركة فى رؤوس أموال شركات صناديق الاستثمار ، عن (10%) من الحد الأدنى المقرر لرأس المال المصدر لشركات التأمين.$b1_0$
  FROM laws WHERE law_no = 304 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$يلغى قرار مجلس إدارة الهيئة رقم 46 لسنة 2014 المشار إليه.$b2_0$
  FROM laws WHERE law_no = 304 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b3_0$
  FROM laws WHERE law_no = 304 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins3_0;

DO $verify177$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 304 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[177] القرار 304/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 4 THEN RAISE EXCEPTION '[177] عدد المواد % بدل 4', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-12-31';
  IF v_v <> 4 THEN RAISE EXCEPTION '[177] عدد النسخ % بدل 4', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%العدد 295%' OR body LIKE '%ديسمبر سنة 2025%' OR body LIKE '%صورة إ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ل تداول%' OR body LIKE '%عند ا%' OR body LIKE '%تد بها%' OR body LIKE '%تروني%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%التأمن%' OR body LIKE '%( )%' OR body LIKE '%٪%' OR body LIKE '%٢٠١٤%' OR body LIKE '%٧٥%' OR body LIKE '%ال يقل%' OR body LIKE '%أال %');
  IF v_bad > 0 THEN RAISE EXCEPTION '[177] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون سوق رأس المال الصادر با%' AND body LIKE '%ه المنعقدة بتاريخ 2025/12/10 ؛' AND body LIKE '%رقم 95 لسنة 1992 ولائحته التنفيذية ؛%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 155 لسنة 2024 ؛%' AND body LIKE '%رقم 46 لسنة 2014 بشأن ضوابط مزاولة شركات التأمين بنفسها لنشاط صناديق الاستثمار المفتوحة%' AND body LIKE '%رقم 58 لسنة 2018 بشأن قواعد وضوابط وإجراءات الترخيص%' AND body LIKE '%رقم 196 لسنة 2024 بشأن تحديد الحد الأدنى%' AND body LIKE '%رقم 148 لسنة 2025 بشأن معايير الملاءة المالية لشركات التأمين ؛%' AND body LIKE '%بتاريخ 2025/12/10 ؛') THEN RAISE EXCEPTION '[177] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'مع عدم الإخلال بقرار مجلس إدارة الهيئة رقم 58%' AND body LIKE '%س المال المصدر لشركات التأمين.' AND body LIKE '%رقم 58 لسنة 2018 المشار إليه ،%' AND body LIKE '%وفقًا لأحكام المادة (175) من قانون التأمين الموحد.%' AND body LIKE '%2- الالتزام بالمعايير المتطلبة للملاءة المالية لشركات التأمين%' AND body LIKE '%3- ألا يقل صافى حقوق الملكية%' AND body LIKE '%4- ألا يقل الفائض من الأموال الحرة%' AND body LIKE '%الصندوق المزمع إنشاؤه%' AND body LIKE '%عن (10_) من الحد الأدنى المقرر لرأس المال المصدر لشركات التأمين.%') THEN RAISE EXCEPTION '[177] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يلغى قرار مجلس إدارة الهيئة رقم 46 لسنة 2014%' AND body LIKE '%رقم 46 لسنة 2014 المشار إليه.' AND body LIKE '%يلغى قرار مجلس إدارة الهيئة رقم 46 لسنة 2014 المشار إليه.%') THEN RAISE EXCEPTION '[177] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية.%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[177] المادة 3 غير سليم'; END IF;
  IF v_len <> 2083 THEN RAISE EXCEPTION '[177] إجمالى طول المواد % بدل 2083', v_len; END IF;
  RAISE NOTICE '[177] القرار 304/2025: 4 مواد و4 نسخ، إجمالى % حرف', v_len;
END
$verify177$;

COMMIT;
