-- 062_replace_corrupted_law_148_2001_real_estate_finance_with_clean_text_and_enable_governance_scope.sql
--
-- إصلاح جذرى لعيب "المادة الواحدة الضخمة" — رابع إصلاح من دفعة الـ7 قوانين
-- المؤكَّدة بهذا العيب (تقرير التدقيق 2026-09-26)، مُرتَّبة حسب الحجم من
-- الأصغر للأكبر. هذا هو الرابع (29,463 حرفاً): القانون رقم 148 لسنة 2001
-- بإصدار قانون التمويل العقارى.
--
-- law_id = 6365f3e9-db68-497d-a98a-5e129fc61aa8، law_no=148، law_year=2001، kind='law'. لا يوجد أى صف آخر
-- بنفس (law_no=148, law_year=2001) بأى نوع مختلف — تم التحقق من ذلك أولاً
-- (عبر audit_law_completeness_report.json) قبل بناء هذه الهجرة.
--
-- ===== الحالة السابقة (قبل هذه الهجرة) =====
-- الصف (law_id = 6365f3e9-db68-497d-a98a-5e129fc61aa8، kind='law') موجود بالفعل فى laws
-- (governance_scope=true مُفعَّل مسبقاً رغم تلف النص)، لكن متنه بالكامل
-- كان مخزَّناً كمادة واحدة (article_no=1) بطول 29,463 حرفاً، وعنوان الصف
-- نفسه يذكر صراحة "نسخة محدثة وفقًا لآخر تعديل بالقانون رقم 93 لسنة 2018"
-- — راجع audit_law_completeness_report.json (تدقيق حى 2026-09-26).
--
-- ===== المصدر والمنهجية =====
-- المصدر: PDF رسمى من الهيئة العامة للرقابة المالية (fra.gov.eg)، 13 صفحة،
-- بعنوان "نسخة محدثة من قانون التمويل العقارى"، رفعه صاحب المشروع نفسه.
-- عنوان الوثيقة ("قانون رقم 148 لسنة 2001 بتاريخ 2001/6/24 وفقاً لآخر
-- تعديل") يطابق تماماً الصف المخزَّن فى قاعدة البيانات. استُخرج النص بقراءة
-- بصرية مباشرة لكل الصفحات الـ13 (بدقة عرض عالية 300 DPI)، ثم تحقُّق مزدوج
-- عبر OCR (tesseract بحزمة اللغة العربية) على نفس صور الصفحات لمطابقة كل
-- رقم وحرف حرفياً، مع تكبير مقاطع محددة (crop) للتحقق النهائى من أرقام
-- القوانين المستشهد بها فى المادة الأولى إصدار (تبيَّن أنها "15 لسنة 1963"
-- و"230 لسنة 1996" — رقم القانون الأول كان مُقترَحاً خطأً من الذاكرة العامة
-- قبل التكبير المباشر وصُحِّح فوراً بعد معاينة الصورة، تطبيقاً حرفياً لقاعدة
-- "لا اختلاق": لا يُعتمَد أى رقم قانون إلا بعد معاينة مباشرة للمصدر، ولا
-- يُستكمل من الذاكرة العامة أو الاستنتاج المنطقى مهما بدا مرجَّحاً).
--
-- تاريخ صدور القانون: 2001-06-24 ("صدر برئاسة الجمهورية فى 3 ربيع الآخر سنة
-- 1422هـ الموافق 24 يونيه سنة 2001م") — enacted_at ونفس effective_from
-- لكل المواد = 2001-06-24.
--
-- ===== هيكل الوثيقة وإعادة الترقيم =====
-- الوثيقة جزءان:
--   (أ) قرار الإصدار الرئاسى نفسه: 4 مواد تقليدية — article_suffix_order
--       = -1، نفس اصطلاح migrations/054/057/059/060/061.
--   (ب) "قانون التمويل العقارى" المرفق: ترقيم أصلى متصل 1-52 مقسَّم على 8
--       أبواب (hierarchical_location لكل مادة = اسم بابها) — article_no
--       1-52، article_suffix_order=0، بالإضافة لـ8 مواد "مكرر" أُضيفت لاحقاً
--       (مُعلَّمة صراحة "مضافة بقرار رئيس جمهورية مصر بالقانون رقم 55 لسنة
--       2014" فى النص الرسمى نفسه): 1 مكرر، 32 مكرر، 34 مكرر، 36 مكرر،
--       42 مكرر، 42 مكرر 1، 43 مكرر، 48 مكرر — article_suffix_order = 1
--       (أو 2 لـ42 مكرر 1) حسب اصطلاح migrations/021/061.
--
-- خمس مواد أُلغيت بالكامل بموجب القانون رقم 93 لسنة 2018 (المذكور صراحة
-- فى عنوان الصف الأصلى كآخر تعديل): المادة 5، 35، 36، 36 مكرر، 48 مكرر.
-- طُبِّق عليها اصطلاح migrations/012 حرفياً: body='ملغاة.'،
-- article_versions.status='repealed'، وchange_note يحمل استشهاد الإلغاء
-- فقط (بلا اختلاق أو استعادة نص تشغيلى غير سارٍ فعلياً لأى من هذه المواد،
-- اتساقاً صريحاً مع نفس القاعدة المُتبعة فى migrations/012/053).
--
-- المواد المعدَّلة والسارية (وعلى الأخص: 1، 2، 4، 6، 11 [بطبقتى تعديل:
-- استبدال بالقانون 143/2004 ثم تعديل بالقانون 55/2014]، 28، 33، 34، 40،
-- 42، 46، 47، 50، 51) خُزِّن نصها التشغيلى الحالى (بعد آخر تعديل) كاملاً فى
-- body مع ملاحظة استشهاد مضمَّنة فى نهاية النص ("* معدله بقرار رئيس
-- جمهورية مصر العربية بالقانون رقم 55 لسنة 2014" ثم "النص قبل التعديل: ..."
-- كاملاً)، بنفس أسلوب migrations/059/060/061 — لا فقدان لأى تاريخ تشريعى.
--
-- إجمالى المواد بعد الإصلاح: 64 (4 إصدارية + 60 موضوعية شاملة
-- الثمان المكررة والخمس الملغاة).
--
-- ===== الأثر =====
-- (أ) استبدال صف المتن التالف الوحيد بـ64 مادة نظيفة، (ب) تأكيد
-- governance_scope=true (كان مُفعَّلاً بالفعل رغم التلف)، (ج) تعيين
-- enacted_at = 2001-06-24.
--
-- قابلة لإعادة التشغيل بأمان (idempotent): حذف الصف التالف مشروط بعدد مواد
-- =1 فقط، وكل إدراج محمى بـON CONFLICT (law_id, article_no,
-- article_suffix_order) DO NOTHING.

BEGIN;

DO $fix148_2001$
DECLARE
  v_law_id uuid;
  v_article_count int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law';

  IF v_law_id IS NULL THEN
    RAISE WARNING '[062] law 148/2001 (kind=law) غير موجود فى laws — غير متوقَّع، تخطّى هذه الهجرة';
    RETURN;
  END IF;

  SELECT count(*) INTO v_article_count FROM articles WHERE law_id = v_law_id;

  IF v_article_count = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[062] law 148/2001: أُزيل الصف التالف القديم (مادة 1 واحدة بطول 29,463 حرفاً)';
  ELSIF v_article_count = 64 THEN
    RAISE NOTICE '[062] law 148/2001: 64 مادة موجودة بالفعل — سبق إصلاحه، تخطّى الحذف';
  ELSE
    RAISE WARNING '[062] law 148/2001: عدد مواد غير متوقَّع (%) — راجع يدوياً', v_article_count;
  END IF;
END
$fix148_2001$;

-- ===== الجزء (أ): قرار الإصدار (4 مواد، article_suffix_order = -1) =====

WITH insd1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, -1, 'القانون الأصلى (مواد إصدارية)', 'المادة الأولى إصدار', $d1$مع عدم الإخلال بأحكام القرار بقانون رقم 15 لسنة 1963 بحظر تملك الأجانب للأراضى الزراعية وما فى حكمها، والقانون رقم 230 لسنة 1996 بتنظيم تملك غير المصريين للعقارات المبنية والأراضى الفضاء، يعمل بأحكام القانون المرافق فى شأن التمويل العقارى ويلغى كل حكم يخالف أحكامه.$d1$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM insd1;

WITH insd2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, -1, 'القانون الأصلى (مواد إصدارية)', 'المادة الثانية إصدار', $d2$فى تطبيق أحكام القانون المرافق والقرارات الصادرة تنفيذاً له يقصد بالكلمات والعبارات المعنى المبين قرين كل منها:

(أ) الوزير المختص: الوزير المختص بتطبيق أحكام قانون تنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية الصادر بالقانون رقم 10 لسنة 2009.

(ب) الهيئة أو الجهة الإدارية: الهيئة العامة للرقابة المالية.

(ج) التمويل العقارى: التمويل فى أى من الأنشطة المنصوص عليها فى المادة (1) من القانون المرافق أو التى يتم إضافتها بقرار من الوزير المختص بعد موافقة مجلس إدارة الهيئة.

(د) إعادة التمويل العقارى: إعادة تمويل الجهات التى تزاول نشاط التمويل العقارى.

(هـ) الإجارة: تأجير العقارات الذى ينتهى بالتملك.

(و) الضمان العقارى: الضمان المقدم عن التمويل العقارى.

(ز) العقار الضامن: العقار المحمل بحق الإمتياز أو بالرهن الرسمى أو بغير ذلك من الضمانات.

(ح) المستثمر: المشترى أو من حصل على التمويل فى غير حالة الشراء.

(ط) الشركة: كل شركة تمارس نشاطاً أو أكثر من أنشطة التمويل العقارى المنصوص عليها فى المادة (1) من القانون المرافق.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: فى تطبيق أحكام القانون المرافق والقرارات الصادرة تنفيذاً له يقصد بعبارة الوزير المختص وزير الاقتصاد والتجارة الخارجية، وبعبارة الجهة الإدارية الهيئة العامة المختصة بشئون التمويل العقارى وتتبع وزير الاقتصاد والتجارة الخارجية.$d2$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM insd2;

WITH insd3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, -1, 'القانون الأصلى (مواد إصدارية)', 'المادة الثالثة إصدار', $d3$يصدر مجلس الوزراء اللائحة التنفيذية للقانون المرافق فى تاريخ العمل به.$d3$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM insd3;

WITH insd4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, -1, 'القانون الأصلى (مواد إصدارية)', 'المادة الرابعة إصدار', $d4$ينشر هذا القانون فى الجريدة الرسمية ويعمل به اعتباراً من اليوم التالى لمضى ثلاثة أشهر على تاريخ نشره.

يبصم هذا القانون بخاتم الدولة وينفذ كقانون من قوانينها.

صدر برئاسة الجمهورية فى 3 ربيع الآخر سنة 1422هـ (الموافق 24 يونيه سنة 2001م).

حسنى مبارك$d4$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM insd4;

-- ===== الجزء (ب): القانون المرافق (60 صفاً: 52 مادة أساسية + 8 مواد مكررة، منها 5 ملغاة) =====

WITH inss1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, 'الباب الأول: أحكام عامة', 'مادة (1)', $s5$تسرى أحكام هذا القانون على أنشطة التمويل العقارى وهى:

(أ) تمويل شراء أو بناء أو ترميم أو تحسين العقارات لأغراض السكن والوحدات الإدارية والمنشآت الخدمية ومبانى المحال المخصصة للنشاط التجارى.

(ب) الإجارة مع مراعاة أحكام القانون رقم 95 لسنة 1995 فى شأن التأجير التمويلى.

(ج) تمويل شراء حق الإنتفاع بالعقارات.

(د) تمويل شراء العقارات بنظامى المشاركة والمرابحة.

(هـ) إعادة التمويل العقارى.

ويجوز للوزير المختص بعد موافقة مجلس إدارة الهيئة إضافة أنشطة أخرى فى مجال التمويل العقارى.

ويكون ذلك التمويل بضمان حق الإمتياز على العقار أو رهنه رهناً رسمياً، أو غير ذلك من الضمانات التى يقبلها الممول طبقاً للقواعد والإجراءات والشروط التى تحددها اللائحة التنفيذية لهذا القانون.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: تسرى أحكام هذا القانون على نشاط التمويل للاستثمار فى مجالات شراء أو بناء أو ترميم أو تحسين المساكن والوحدات الإدارية والمنشآت الخدمية ومبانى المحال المخصصة للنشاط التجارى وذلك بضمان حق الامتياز على العقار أو رهنه رهناً رسمياً أو غير ذلك من الضمانات التى يقبلها الممول طبقاً للقواعد والإجراءات التى تحددها اللائحة التنفيذية لهذا القانون.
ويطلق على هذا التمويل اسم التمويل العقارى وعلى ذلك الضمان اسم الضمان العقارى وعلى العقار المحمل بحق الامتياز أو بالرهن الرسمى أو بغير ذلك من الضمانات اسم العقار الضامن وعلى المشترى أو من حصل على التمويل فى غير حالة الشراء اسم المستثمر ويعفى قيد هذا الضمان وتجديده وشطبه من جميع الرسوم والمصروفات.$s5$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss1;

WITH inss1_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 1, 'الباب الأول: أحكام عامة', 'مادة (1 مكرر) (مضافة بقانون 55 لسنة 2014)', $s6$يعفى إثبات تاريخ إتفاق التمويل العقارى وشهره وكذا قيد الضمان وتجديده وشطبه وحوالته من جميع الرسوم والمصروفات والتكاليف المساحية.

ويستثنى قيد الضمان من أحكام المادتين (43، 44) من القانون رقم 114 لسنة 1946 بتنظيم الشهر العقارى لحين سداد كامل الدين، والمادة (42) من قانون الضريبة على الدخل الصادر بالقانون رقم 91 لسنة 2005 وذلك عند منح التمويل العقارى.

كما تعفى العقارات الممولة وفقاً لأحكام هذا القانون من رسوم التنازل التى تفرضها الجهات المصدرة لقرارات تخصيص الأراضى لجهات التمويل.

* مضافة بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.$s6$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss1_m1;

WITH inss2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, 'الباب الأول: أحكام عامة', 'مادة (2)', $s7$مع عدم الإخلال بإختصاص جهاز حماية المنافسة ومنع الممارسات الإحتكارية، تختص الهيئة بالتنظيم والرقابة والإشراف على جميع أنشطة التمويل العقارى المبينة فى هذا القانون.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: تنشأ هيئة عامة تتبع وزير الاقتصاد والتجارة الخارجية تختص بشئون التمويل العقارى ويصدر بتشكيلها وتحديد اختصاصاتها قرار من رئيس الجمهورية.$s7$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss2;

WITH inss3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, 'الباب الأول: أحكام عامة', 'مادة (3)', $s8$تكون للجهات التالية دون غيرها مزاولة نشاط التمويل العقارى المنصوص عليه فى هذا القانون بشرط قيدها فى سجل تعده الجهة الإدارية لهذا الغرض:

(1) الأشخاص الاعتبارية العامة التى يدخل نشاط التمويل العقارى ضمن أغراضها.

(2) شركات التمويل العقارى المنصوص عليها فى الباب الخامس من هذا القانون.

ويجوز للبنوك المسجلة لدى البنك المركزى المصرى بعد موافقته ووفقاً للقواعد التى يقررها أن تزاول نشاط التمويل العقارى دون قيدها لدى الجهة الإدارية ولا تسرى عليه أحكام الفقرة الثانية من المادة (4) والباب السابع من هذا القانون.$s8$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss3;

WITH inss4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, 'الباب الأول: أحكام عامة', 'مادة (4)', $s9$تكون مزاولة أنشطة ومجالات التمويل العقارى المنصوص عليها فى هذا القانون وفقاً للقواعد والمعايير التى يحددها مجلس إدارة الهيئة، وبما يكفل تناسب التمويل مع القدرة المالية لطالب التمويل وذلك فى ضوء الحالة العامة للسوق.

وتصدر الهيئة قواعد وإجراءات وشروط التمويل وحدوده الإئتمانية ونسبة التمويل إلى قيمة العقار أو الضمان المقدم حسب الأحوال.

ويكون لجهات التمويل وإعادة التمويل المرخص لها الحق فى تحديد تكاليف التمويل دون التقيد بالحدود القصوى المقررة فى أى قانون آخر.

وتقدر قيمة العقار الضامن بمعرفة خبراء التقييم المقيدة أسماؤهم فى الجداول التى تعدها الهيئة لهذا الغرض بشرط ألا يكون من بين العاملين لدى أى من أطراف عملية التمويل.

وتحدد اللائحة التنفيذية قواعد وشروط وإجراءات القيد فى هذه الجداول.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: تكون مزاولة نشاط التمويل العقارى وفق المعايير التى تحددها اللائحة التنفيذية وبما يكفل تناسب التمويل مع القدرة المالية لمشترى العقار أو لمن حصل على التمويل فى غير حالة الشراء وذلك فى ضوء الحالة العامة لسوق العقارات.
وتحدد اللائحة التنفيذية قواعد وإجراءات التمويل وحدوده الائتمانية ونسبة التمويل إلى قيمة العقار مقدرة بمعرفة خبراء التقييم المقيدة أسماؤهم فى الجداول التى تعدها الجهة الإدارية لهذا الغرض بشرط ألا يكونوا من بين العاملين لدى الممول.$s9$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss4;

WITH inss5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, 'الباب الأول: أحكام عامة', 'مادة (5)', $s10$ملغاة.$s10$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, change_note)
SELECT id, 1, body, '2018-01-01', 'repealed', $n11$أُلغيت المادة بموجب القانون رقم 93 لسنة 2018.$n11$ FROM inss5;

WITH inss6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, 'الباب الثانى: اتفاق التمويل', 'مادة (6)', $s12$يكون التمويل العقارى بموجب إتفاق بين أطراف التمويل وفقاً للنماذج المعتمدة من الهيئة، ويتضمن هذا الإتفاق على الأخص ما يأتى:

(أ) بيان العقار وثمنه.

(ب) مقدار المبلغ المعجل الذى يتم سداده من ثمن العقار.

(ج) عدد وقيمة أقساط باقى الثمن وشروط الوفاء بها، على أن تكون محددة أو قابلة للتحديد سلفاً بإستخدام معادلة ثابتة مربوطة بأحد المؤشرات الرسمية التى تحددها الهيئة لحساب التغيير فى تكلفة التمويل زيادة أو نقصاً وذلك لحين إستيفائها بالكامل.

(د) قبول البائع حوالة حقوقه فى أقساط الثمن والضمانات المرتبطة بها إلى الممول بالشروط التى يتفقان عليها.

(هـ) إلتزام المستثمر بقيد حق إمتياز الثمن المحالة أقساطه إلى الممول، وذلك ضماناً للوفاء بها.

(و) إلتزام أطراف الإتفاق بإثبات تاريخ إتفاق التمويل وتوثيق إتفاق التمويل بالشهر العقارى بالشكل الرسمى العام أو التصديق عليه بحسب الأحوال ووضع الصيغة التنفيذية عليه، وتعفى جميع الإجراءات الواردة فى هذه الفقرة من كافة الرسوم والضرائب والمصروفات.

وتحدد اللائحة التنفيذية الشروط والبيانات الأخرى الواجب تضمينها فى إتفاقات التمويل العقارى المنصوص عليها فى هذا القانون طبقاً لطبيعة كل اتفاق.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: يكون التمويل العقارى فى مجال شراء العقارات وفقاً لأحكام هذا القانون بموجب اتفاق تمويلى بين الممول والمشترى باعتباره المستثمر وبائع العقار ويجب أن يتضمن الاتفاق ما يأتى:
(أ) الشروط التى تم قبولها من البائع والمشترى فى شأن بيع العقار بالتقسيط بما فى ذلك بيان العقار وثمنه.
(ب) مقدار المعجل من ثمن البيع الذى أداه للبائع.
(ج) عدد وقيمة باقى الثمن وشروط الوفاء بها على أن تكون محددة إلى حين استيفائها بالكامل.
(د) قبول البائع حوالة حقوقه فى أقساط الثمن إلى الممول بالشروط التى يتفقان عليها.
(هـ) التزام البائع بتسجيل العقار باسم المشترى خالية من أى حقوق عينية على الغير.
(و) التزام المشترى بقيد حق امتياز الثمن المحالة أقساطه إلى الممول وذلك ضماناً للوفاء بها.
(ز) التزام أطراف الاتفاق بإعطائه تاريخاً ثابتاً.
فإذا كان التمويل لغرض الاستثمار فى بناء عقار على أرض يملكها المستثمر أو لغرض ترميم أو تحسين عقار يملكه أو غير ذلك من المجالات تعين أن يكون التمويل بموجب اتفاق بينه وبين الممول وبين أى طرف آخر يكون له شأن فى الاتفاق.
ويصدر الوزير المختص قراراً بنماذج الاتفاقات المشار إليها فى الفقرتين السابقتين.$s12$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss6;

WITH inss7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, 'الباب الثانى: اتفاق التمويل', 'مادة (7)', $s13$يجوز للمستثمر التصرف فى العقار الضامن بالبيع أو الهبة أو غيرهما من التصرفات أو ترتيب أى حق عينى عليه وذلك بعد موافقة الممول وبشرط أن يقبل المتصرف إليه الحلول محل المستثمر فى الالتزامات المترتبة على اتفاق التمويل.

ويجوز للمستثمر تأجير العقار الضامن أو تمكين غيره من الانفراد بشغله وذلك بعد الحصول على موافقة الممول، وللممول أن يشترط حوالة الحق فى أجرة العقار أو مقابل شغله وذلك وفاء لمستحقاته.

ولا يجوز للممول رفض الموافقة على التصرف فى العقار الضامن أو تأجيره أو تمكين الغير من الانفراد بشغله إلا لأسباب جدية تتعرض معها مصالحه وحقوقه للخطر، ويجب عليه إخطار المستثمر بهذه الأسباب كتابة خلال ثلاثين يوماً من تاريخ إخطار المستثمر له برغبته فى التصرف أو فى التأجير أو تمكين الغير من الانفراد بشغل العقار وإلا اعتبر موافقاً على ذلك.

وللممول أن يشترط تضامن المستثمر مع التصرف إليه فى الوفاء بالالتزامات المترتبة على اتفاق التمويل.

وتحدد اللائحة التنفيذية القواعد والإجراءات التى تتبع فى الأحوال المشار إليها.$s13$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss7;

WITH inss8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, 'الباب الثانى: اتفاق التمويل', 'مادة (8)', $s14$إذا تصرف المستثمر فى العقار الضامن أو أجره أو مكن أحداً من شغله بالمخالفة لأحكام المادة السابقة كان للممول أن يطالبه بباقى أقساط الثمن أو باقى قيمة اتفاق التمويل بحسب الأحوال بإنذار على يد محضر بالوفاء خلال مهلة لا تقل عن ثلاثين يوماً.

فإذا لم يقم المستثمر بهذا الوفاء كان للممول أن يتخذ فى مواجهته الإجراءات المنصوص عليها فى الباب الرابع من هذا القانون.$s14$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss8;

WITH inss9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, 'الباب الثانى: اتفاق التمويل', 'مادة (9)', $s15$يجوز للمستثمر أن يعجل بالوفاء بأقساط الثمن أو بالتمويل كله أو بعضه.

وفى هذه الحالة يتم خفض الأقساط المستحقة عليه بما يتناسب مع تعجيل الوفاء وفقاً للقواعد التى تحددها اللائحة التنفيذية لهذا القانون.$s15$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss9;

WITH inss10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, 'الباب الثالث: قيد الضمان العقارى وحوالة الحقوق الناشئة عن اتفاق التمويل', 'مادة (10)', $s16$يقدم طلب قيد الضمان العقارى إلى مكتب الشهر العقارى الكائن فى دائرته العقار من الممول أو المستثمر متضمناً البيانات التى تحددها اللائحة التنفيذية ومرفقاً به اتفاق التمويل وسند ملكية العقار.

ويجب البت خلال أسبوع فى طلب القيد بعد التحقق من صحة حدود العقار على النحو الوارد بالطلب وبسند الملكية أو تكليف مقدمه بما يجب أن يستوفيه وذلك خلال أسبوع من تاريخ تقديم الطلب.

ويخطر مقدم الطلب خلال الموعد المشار إليه بالقرار الصادر فى شأنه بموجب كتاب مسجل موصى عليه بعلم الوصول، ويجب أن يكون القرار برفض الطلب مسبباً.$s16$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss10;

WITH inss11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, 'الباب الثالث: قيد الضمان العقارى وحوالة الحقوق الناشئة عن اتفاق التمويل', 'مادة (11)', $s17$يجوز للممول أن يحيل حقوقه الناشئة عن إتفاق التمويل سواء على سبيل التملك أو الرهن إلى الشركة أو إحدى الجهات المرخص لها بمباشرة نشاط التوريق، على أن ترهن الإتفاقات الضامنة رهناً حيازياً وذلك كله طبقاً للقواعد التى تحددها اللائحة التنفيذية لهذا القانون.

ويقيد عقد الرهن بسجل تمسكه الهيئة أو إحدى الجهات التى يحددها مجلس إدارتها.

ويجب أن يتضمن إتفاق التمويل قبول المستثمر بحوالة حقوق الممول إلى إحدى الجهات المشار إليها بالفقرة الأولى، ويتم إخطار المستثمر بالحوالة ويحدد إتفاق التمويل طريقة الإخطار.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
(**) المادة رقم 11 مستبدلة بالقانون رقم 143 لسنة 2004 - الجريدة الرسمية العدد 25 تابع (أ) فى 17/6/2004.
النص قبل التعديل: يجوز للممول أن يحيل حقوقه الكمالية ومستحقاته أجلة الدفع بالضمانات المقررة لها عن اتفاق التمويل وذلك وفقاً لأحكام الفصل الثالث من الباب الثالث من قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992.$s17$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss11;

WITH inss12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (12)', $s18$للممول فى حالة عدم وفاء المستثمر بالمبالغ المستحقة عليه ومضى ثلاثين يوماً من تاريخ استحقاقها أو عند ثبوت نقص مخل بضمان الممول لقيمة العقار بفعل أو إهمال المستثمر أو شاغل العقار بحكم قضائى واجب النفاذ أن ينذر المستثمر بالوفاء أو بتقديم ضمان كافٍ بحسب الأحوال وذلك خلال ستين يوماً على الأقل من تاريخ الإنذار.$s18$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss12;

WITH inss13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (13)', $s19$مع عدم الإخلال بأحكام المادتين (35) و(37) من هذا القانون إذا انقضت المدة المحددة بالإنذار دون قيام المستثمر بالوفاء أو بتقديم الضمان كان ملتزماً بالوفاء بكامل المبالغ المتبقية طبقاً لاتفاق التمويل العقارى.

ويكون للممول فى هذه الحالة أن يطلب من قاضى التنفيذ الذى يقع العقار فى دائرة اختصاصه وضع الصيغة التنفيذية على اتفاق التمويل والأمر بالحجز على العقار الضامن تمهيداً لبيعه وذلك بعد إعلان المستثمر قانوناً لسماع أقواله.$s19$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss13;

WITH inss14 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (14)', $s20$يقوم الممول بعد وضع الصيغة التنفيذية على اتفاق التمويل بإعلانه إلى المستثمر مع تكليفه بالوفاء خلال مدة لا تقل عن ثلاثين يوماً كما يقوم بإعلانه إلى مكتب الشهر العقارى المختص للتأشير به بغير رسوم خلال مدة لا تتجاوز أسبوعاً على هامش قيد الضمان العقارى مع إعلان ذلك إلى جميع الدائنين المقيدة حقوقهم على العقار وإلى حائزه وإلا كان التكليف بالوفاء غير نافذ فى حقهم.$s20$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss14;

WITH inss15 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (15)', $s21$يقوم التأشير بالسند التنفيذى فى مكتب الشهر العقارى مقام تسجيل تنبيه نزع الملكية.$s21$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss15;

WITH inss16 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (16)', $s22$إذا لم يقم المستثمر بالوفاء خلال المدة المحددة له فى الإعلان بالسند التنفيذى يصدر قاضى التنفيذ بناء على طلب الممول أمراً بتعيين وكيل عقارى من بين الوكلاء المقيدة أسماؤهم فى سجل تعده الجهة الإدارية لهذا الغرض وذلك لمباشرة إجراءات بيع العقار بالمزاد العلنى المنصوص عليها فى المواد التالية تحت الإشراف المباشر لقاضى التنفيذ.

وتحدد اللائحة التنفيذية الشروط الواجب توافرها فى الوكلاء العقاريين وقواعد تحديد أتعابهم وإجراءات القيد فى السجل.$s22$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss16;

WITH inss17 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (17)', $s23$لكل ذى مصلحة أن يطلب استبدال الوكيل العقارى بطلب يقدمه إلى قاضى التنفيذ مبيناً به أسبابه ولا يترتب على مجرد تقديم الطلب وقف إجراءات التنفيذ على العقار ما لم يقرر القاضى عكس ذلك وللقاضى أن يأمر بالاستبدال إذا تبين له جدية أسباب الطلب.$s23$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss17;

WITH inss18 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (18)', $s24$يحدد أثنان من خبراء التقييم المشار إليهم فى الفقرة الثانية من المادة (4) الثمن الأساسى للعقار.

ويحدد الوكيل العقارى شروط بيع العقار بالمزاد العلنى على أن تتضمن تاريخ وساعة ومكان إجراء البيع والثمن الأساسى للعقار وتأمين الاشتراك فى المزاد وتحدد اللائحة التنفيذية قواعد حساب التأمين.$s24$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss18;

WITH inss19 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (19)', $s25$على الوكيل العقارى أن يعلن كلاً من المستثمر وحائز العقار والدائنين المقيدة حقوقهم بشروط البيع قبل اليوم المحدد لإجراء المزايدة بمدة لا تقل عن ثلاثين يوماً ولا تجاوز خمسة وأربعين يوماً كما يقوم بلصق الإعلان على العقار وعلى اللوحة المعدة للإعلانات بالمحكمة المختصة الكائن فى دائرتها العقار مع نشره فى جريدتين يوميتين واسعتى الانتشار على نفقة المستثمر، وللممول أو للمستثمر أن يطلب الإعلان أو النشر أكثر من مرة على نفقته.$s25$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss19;

WITH inss20 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (20)', $s26$يتولى الوكيل العقارى إجراء المزايدة فى اليوم المحدد للبيع وتبدأ المزايدة بالنداء على الثمن الأساسى وتنتهى بإيقاع البيع على من تقدم بأكبر عرض.

فإذا كان هذا العرض أقل من الثمن الأساسى أو لم يجاوز عدد المزايدين ثلاثة أشخاص وجب على الوكيل العقارى تأجيل البيع إلى يوم آخر خلال الثلاثين يوماً التالية يعلن عنه بذات الإجراءات المنصوص عليها فى المادة (19) من هذا القانون ولا يجوز للممول أن يشترك فى المزايدة، ومع ذلك إذا لم يبلغ أكبر عرض الثمن الأساسى وكان أقل من مستحقات الممول كان له أن يطلب إيقاع البيع عليه مقابل إبراء ذمة المستثمر من جميع التزاماته.

وفى جميع الأحوال يعتبر العرض الذى لا يزاد عليه خلال خمس دقائق منهياً للمزايدة.$s26$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss20;

WITH inss21 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (21)', $s27$إذا قام المستثمر بالوفاء بما حل عليه من أقساط فى أى وقت سابق على إيقاع البيع وجب على الوكيل العقارى أن يوقف الإجراءات ويلتزم المستثمر بأن يؤدى إلى الممول المصروفات التى يصدر بتقديرها أمر من قاضى التنفيذ.$s27$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss21;

WITH inss22 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (22)', $s28$يصدر القاضى حكماً بإيقاع البيع بناء على ما تم من إجراءات وسداد كامل الثمن يتضمن قائمة شروطه وما اتبع من إجراءات يوم البيع ويجب أن يتضمن منطوق الحكم الأمر بتسليم العقار خالياً من شاغليه إلى من حكم بإيقاع البيع عليه ما لم يكن الممول قد سبقت موافقته على شغلهم العقار تطبيقاً لأحكام المادة (7) من هذا القانون أو كانوا مستأجرين للعقار بعقود ثابتة التاريخ قبل اتفاق التمويل.

ويجب إيداع نسخة الحكم الأصلية ملف التنفيذ فى اليوم التالى لصدوره.$s28$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss22;

WITH inss23 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (23)', $s29$لمن حكم بإيقاع البيع عليه أن يسجل الحكم ويترتب على هذا التسجيل تطهير العقار من جميع الحقوق العينية التبعية التى أعلن أصحابها بالسند التنفيذى وبإجراءات البيع طبقاً للمادة (19) من هذا القانون.$s29$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss23;

WITH inss24 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (24)', $s30$لا يجوز استئناف حكم إيقاع البيع إلا لعيب فى إجراءات المزايدة أو لبطلان الحكم، ومع ذلك يجوز لشاغل العقار استئناف الحكم إذا تضمن إخلاءه من العقار ويرفع الاستئناف إلى المحكمة المختصة بالأوضاع المعتادة خلال الخمسة عشر يوماً التالية لتاريخ النطق بالحكم عدا شاغل العقار فيبدأ الميعاد بالنسبة له من تاريخ إعلانه بالحكم.$s30$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss24;

WITH inss25 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (25)', $s31$لا يترتب على رفع دعوى الاستحقاق من الغير وقف إجراءات التنفيذ على العقار ما لم تقض المحكمة بغير ذلك.$s31$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss25;

WITH inss26 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 26, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (26)', $s32$يقوم الوكيل العقارى بإيداع حصيلة البيع خزينة المحكمة ويتولى قاضى التنفيذ ما لم يتم الطعن على حكم إيقاع البيع من أحد الأطراف فى إجراءات المزايدة توزيع هذه الحصيلة على الدائنين حسب مرتبتهم فى اليوم التالى لفوات ميعاد الطعن أو صدور حكم برفضه وذلك بعد سداد جميع مصاريف التنفيذ ويحرر محضر بذلك يودع ملف التنفيذ.$s32$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss26;

WITH inss27 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 27, 0, 'الباب الرابع: التنفيذ على العقار', 'مادة (27)', $s33$تسرى أحكام قانون المرافعات المدنية والتجارية فيما لم يرد بشأنه نص خاص فى هذا الباب.$s33$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss27;

WITH inss28 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 28, 0, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (28)', $s34$يجب أن تتخذ الشركة شكل شركة مساهمة مصرية، وألا يقل رأس مالها المصدر والمدفوع منه عن الحد الذى تبينه اللائحة التنفيذية.

وإستثناءً من المادة الأولى من مواد إصدار هذا القانون لا تسرى أحكام القانون رقم 230 لسنة 1996 بتنظيم تملك غير المصريين للعقارات المبنية والأراضى الفضاء على الشركات الخاضعة لأحكام هذا القانون أياً كانت نسبة رأس المال غير المصرى فيها عدا نصى المادتين (الثانية) بند (3)، (الرابعة) من القانون المشار إليه. ويكون الترخيص بمزاولة أنشطة التمويل وإعادة التمويل العقارى وفقاً لأحكام المواد التالية وما تحدده اللائحة التنفيذية لهذا القانون.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: يجب أن تتخذ شركة التمويل العقارى شكل شركة مساهمة مصرية وألا يقل رأس مالها المصدر والمدفوع منه عن الحد الذى تبينه اللائحة التنفيذية.
ويكون الترخيص بمزاولة نشاط التمويل العقارى وفقاً لأحكام المواد التالية.$s34$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss28;

WITH inss29 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 29, 0, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (29)', $s35$يقدم طلب الترخيص إلى الجهة الإدارية على النموذج الذى تعده لهذا الغرض وتحدد اللائحة التنفيذية قواعد وإجراءات الترخيص ورسومه بما لا يجاوز عشرة آلاف جنيه.$s35$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss29;

WITH inss30 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 30, 0, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (30)', $s36$على الجهة الإدارية إعطاء طالب الترخيص شهادة باستلام المستندات المقدمة منه أو بياناً بما يلزم تقديمه من مستندات أخرى وعليه استيفاء هذه المستندات خلال الثلاثة أشهر التالية وإلا سقط طلبه.$s36$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss30;

WITH inss31 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 31, 0, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (31)', $s37$تقوم الجهة الإدارية بالبت فى طلب الترخيص وإخطار الطالب كتابة بقرارها فى شأنه وذلك خلال ثلاثين يوماً من تاريخ استيفاء المستندات اللازمة.

ولا يجوز للجهة الإدارية أن ترفض الترخيص إلا فى الحالات الآتية:

(1) عدم استيفاء الشروط المبينة فى هذا القانون أو القرارات الصادرة تنفيذاً له.

(2) عدم توافر المعايير التى تحددها اللائحة التنفيذية بشأن الخبرة والكفاءة المهنية فى مديرى الشركة.

(3) صدور حكم بشهر إفلاس أى من مؤسسى الشركة أو مديريها خلال السنوات الخمس السابقة على تقديم الطلب ما لم يكن قد رد إليه اعتباره.

(4) أن يكون قد سبق الحكم على أحد مؤسسى الشركة أو مديرها أو أحد أعضاء مجلس الإدارة خلال الخمس سنوات السابقة على تقديم طلب الترخيص بعقوبة جناية أو جنحة فى جريمة ماسة بالشرف أو الأمانة ما لم يكن قد رد إليه اعتباره.$s37$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss31;

WITH inss32 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 32, 0, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (32)', $s38$تبين اللائحة التنفيذية المعايير المالية التى يتعين على الشركة الالتزام بها على أن تتضمن ما يأتى:

(1) الأسلوب الذى يتبع فى تقييم أصول الشركة.

(2) تحديد نسب الحد الأدنى لحقوق المساهمين إلى كل من أصول الشركة وخصومها وحجم محفظة التمويل.

(3) تحديد الحد الأدنى للأصول المتداولة إلى الخصوم المتداولة.

(4) القواعد اللازمة لضمان حسن سير أعمال الشركة وضمان حقوق الدائنين والعملاء.$s38$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss32;

WITH inss32_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 32, 1, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (32 مكرر) (مضافة بقانون 55 لسنة 2014)', $s39$تُعد العوائد المدينة التى تدفعها الشركة على القروض وغيرها من وسائل التمويل والمخصصات التى تحتسبها على التمويل المشكوك فى تحصيله وفقاً للمعايير التى تضعها الهيئة ولما يقره مراقبو حسابات الشركة من التكاليف الواجبة الخصم عند تحديد صافى الدخل الخاضع للضريبة وفقاً لأحكام قانون الضريبة على الدخل رقم 91 لسنة 2005.

كما تعد من التكاليف واجبة الخصم الديون التى يقرر مجلس إدارة الشركة إعدامها بناء على تقرير مراقبى الحسابات وتزيد على المخصصات المشار إليها وذلك بعد إتخاذ الإجراءات الجادة لإستيفائها وفقاً للضوابط والإجراءات التى يضعها مجلس إدارة الهيئة فى هذا الخصوص.

وتعفى من ضريبة الدمغة وغيرها من الضرائب والرسوم أرصدة القروض وأية صورة من صور التمويل التى تقدمها الشركة لعملائها وفقاً لأحكام هذا القانون.

* مضافة بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.$s39$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss32_m1;

WITH inss33 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 33, 0, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (33)', $s40$تلتزم الشركة بإعداد القوائم المالية وتقديمها للهيئة وفقاً للمعايير وفى المواعيد التى يحددها مجلس إدارة الهيئة.

ويتولى مراجعة حسابات الشركة مراقبان للحسابات من بين المقيدين فى السجل المعد لهذا الغرض بالهيئة وفقاً لمعايير المراجعة التى يحددها مجلس إدارتها.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: يتولى مراجعة حسابات الشركة مراقبان للحسابات من بين المقيدين فى سجل تمسكه الجهة الإدارية.
وتلتزم الشركة بتقديم قوائمها المالية إلى الجهة الإدارية كل ستة أشهر فى المعياد الذى تحدده اللائحة التنفيذية.$s40$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss33;

WITH inss34 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 34, 0, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (34)', $s41$لا يجوز للشركة أن تندمج مع شركة أخرى تعمل فى النشاط ذاته أو فى غيره أو أن تتوقف عن النشاط أو تقوم بتصفية أصولها أو الجزء الأكبر منها أو الإستحواذ على حصص فى رأس مال شركات التمويل العقارى إلا بعد الحصول على موافقة كتابية من الهيئة وإلا كان الإندماج غير نافذ قانوناً، وذلك كله وفقاً للقواعد والإجراءات التى يحددها مجلس إدارة الهيئة.

وللهيئة رفض الموافقة لأسباب جدية تتعلق بإعتبارات إستقرار نشاط التمويل العقارى أو مصالح المستثمرين أو المساهمين.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: يجوز للشركة أن تندمج مع شركة أخرى تعمل فى النشاط ذاته أو فى غيره أو أن تتوقف عن النشاط أو تقوم بتصفية أصولها أو الجزء الأكبر منها وذلك بعد الحصول على موافقة كتابية من الجهة الإدارية وذلك كله وفقاً للقواعد والاجراءات التى تحددها اللائحة التنفيذية.
ولا يجوز للجهة الإدارية رفض الموافقة إلا لأسباب جدية تتعلق باعتبارات استقرار نشاط التمويل العقارى أو مصالح المستثمرين أو المساهمين.$s41$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss34;

WITH inss34_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 34, 1, 'الباب الخامس: شركات التمويل وإعادة التمويل العقارى', 'مادة (34 مكرر) (مضافة بقانون 55 لسنة 2014)', $s42$ينشأ إتحاد يُسمى الإتحاد المصرى للتمويل العقارى يتمتع بالشخصية الإعتبارية العامة ويتبع الهيئة ويصدر بتشكيله قرار من مجلس إدارتها، ويسجل فى سجل خاص لديها يضم جميع الشركات الخاضعة لهذا القانون والجهات التى تحددها اللائحة التنفيذية.

ويختص الإتحاد بتوحيد جهود شركات التمويل العقارى والتنسيق فيما بينها للنهوض بمجال التمويل العقارى فى جمهورية مصر العربية.

ولا تسرى المعايير والقواعد المهنية التى يضعها الإتحاد إلا بعد إعتمادها من مجلس إدارة الهيئة.

وتعين الهيئة ممثلاً لها لدى الإتحاد يكون له الحق فى حضور جلساته والإشتراك فى مناقشاته، دون أن يكون له صوت معدود.

ويصدر بالنظام الأساسى للإتحاد قرار من مجلس إدارة الهيئة، وينشر فى الوقائع المصرية على نفقة الإتحاد.

* مضافة بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.$s42$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss34_m1;

WITH inss35 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 0, 'الباب السادس: ضمانات التمويل العقارى', 'مادة (35)', $s43$ملغاة.$s43$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, change_note)
SELECT id, 1, body, '2018-01-01', 'repealed', $n44$أُلغيت المادة بموجب القانون رقم 93 لسنة 2018.$n44$ FROM inss35;

WITH inss36 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 0, 'الباب السادس: ضمانات التمويل العقارى', 'مادة (36)', $s45$ملغاة.$s45$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, change_note)
SELECT id, 1, body, '2018-01-01', 'repealed', $n46$أُلغيت المادة بموجب القانون رقم 93 لسنة 2018.$n46$ FROM inss36;

WITH inss36_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 1, 'الباب السادس: ضمانات التمويل العقارى', 'مادة (36 مكرر)', $s47$ملغاة.$s47$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, change_note)
SELECT id, 1, body, '2018-01-01', 'repealed', $n48$أُلغيت المادة بموجب القانون رقم 93 لسنة 2018.$n48$ FROM inss36_m1;

WITH inss37 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 37, 0, 'الباب السادس: ضمانات التمويل العقارى', 'مادة (37)', $s49$للممول أن يشترط على المستثمر التأمين لصالح الممول بقيمة حقوقه لدى إحدى شركات التأمين المصرية وذلك ضد مخاطر عدم الوفاء بسبب وفاة المستثمر أو عجزه.

وتحدد اللائحة التنفيذية قواعد وشروط هذا التأمين.$s49$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss37;

WITH inss38 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 38, 0, 'الباب السادس: ضمانات التمويل العقارى', 'مادة (38)', $s50$لا يجوز لغير الوسطاء المقيدة أسماؤهم فى جدول تعده الجهة الإدارية لهذا الغرض القيام مباشرة بأعمال الوساطة بين الممول والمستثمر فى اتفاق التمويل.

وتحدد اللائحة التنفيذية قواعد وشروط وإجراءات القيد فى هذا الجدول.$s50$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss38;

WITH inss39 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 39, 0, 'الباب السادس: ضمانات التمويل العقارى', 'مادة (39)', $s51$تعد الجهة الإدارية نموذجاً بالشروط الأساسية للتمويل العقارى وعلى الممول أو الوسيط أن يسلم طالب التمويل صورة من هذا النموذج ويجب أن يرفق باتفاق التمويل إقرار من المستثمر بأنه تسلم تلك الصورة واطلع عليها قبل التوقيع على اتفاق التمويل.$s51$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss39;

WITH inss40 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 40, 0, 'الباب السادس: ضمانات التمويل العقارى', 'مادة (40)', $s52$يلتزم الممول بإبلاغ المستثمر مرتين سنوياً على الأقل بجميع البيانات المتعلقة بإتفاق التمويل وكذلك عند حدوث أى تعديل فى هذه البيانات وذلك وفقاً لما تحدده الهيئة.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: يلتزم الممول بإبلاغ المستثمر شهرياً بجميع البيانات المتعلقة باتفاق التمويل وفقاً لما تحدده اللائحة التنفيذية.$s52$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss40;

WITH inss41 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 41, 0, 'الباب السادس: ضمانات التمويل العقارى', 'مادة (41)', $s53$ينشأ لدى الجهة الإدارية مكتب لتلقى وفحص الشكاوى التى تقدم عن مخالفة أحكام هذا القانون والقرارات الصادرة تنفيذاً له وتحدد اللائحة التنفيذية نظام وإجراءات عمل هذا المكتب.$s53$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss41;

WITH inss42 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 0, 'الباب السابع: الرقابة', 'مادة (42)', $s54$لمجلس إدارة الهيئة فى حال مخالفة الشركة أى من أحكام هذا القانون أو القرارات الصادرة تنفيذاً له أو إذا فقدت شرطاً من شروط الترخيص أو إذا قامت بما من شأنه تهديد إستقرار السوق أو مصالح المساهمين فيها أو المتعاملين معها أن تتخذ تدبيراً أو أكثر من التدابير الآتية:

(أ) توجيه تنبيه إلى الشركة بإزالة المخالفة خلال المدة وبالشروط المحددة فى التنبيه.

(ب) مطالبة رئيس مجلس إدارتها بدعوة المجلس أو الجمعية العامة للإنعقاد للنظر فى أمر المخالفات المنسوبة إليها وإتخاذ اللازم نحو إزالتها.

(ج) حل مجلس إدارة الشركة وتعيين مفوض لإدارتها لحين تعيين مجلس جديد بالأداة القانونية المقررة.

(د) المنع من مزاولة كل أو بعض الأنشطة المرخص بمزاولتها لفترة محددة، أو منع التعامل مع عملاء جدد.

(هـ) إلغاء ترخيص مزاولة بعض أو كل الأنشطة المرخص بمزاولتها.

ويجوز أن تصدر التدابير المنصوص عليها بالبندين (أ، ب) من رئيس الهيئة، كما يجوز له إتخاذ أى من التدابير المنصوص عليها فى البند (د) من هذه المادة إذا كان الخطر من شأنه أن يترتب عليه ضرر يتعذر تداركه وذلك لمدة أقصاها شهر أو لحين العرض على مجلس إدارة الهيئة أيهما أقرب.

ويجوز لمجلس إدارة الهيئة تقرير ما يراه مناسباً من تدابير أخرى للحفاظ على حقوق المتعاملين مع هذه الشركة.

كما يجوز للمجلس تحقيقاً لإستقرار السوق أو حماية لحقوق المتعاملين مع الشركة أو فى حالة تعرض الشركة لمشاكل مالية تؤثر على مركزها المالى إلزام الشركة بزيادة رأسمالها المدفوع أو الأموال المخصصة لمزاولة النشاط أو معدل ملاءتها المالية وفقاً لجدول زمنى محدد.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: للجهة الإدارية عند مخالفة أحكام هذا القانون أو القرارات الصادرة تنفيذاً له أو إذا قام خطر يهدد استقرار نشاط التمويل العقارى أو مصالح المستثمرين أو المساهمين فى شركات التمويل العقارى أن تتخذ ما تراه مناسباً من التدابير الآتية:
(1) توجيه إنذار بإزالة المخالفة خلال مدة محددة.
(2) وقف مزاولة النشاط لفترة لا تجاوز تسعين يوماً.
(3) المنع من مزاولة النشاط مع تحديد الإجراءات والتدابير اللازمة لمواجهة الآثار المترتبة على هذا المنع.
ويكون للجهة الإدارية أن تتخذ التدابير التالية بالنسبة لشركات التمويل العقارى المخالفة:
(1) إلزام الشركة باتخاذ إجراءات دمجها فى شركة أخرى من شركات التمويل العقارى أو فى إحدى الجهات الأخرى التى تزاول هذا النشاط خلال مدة لا تجاوز ثلاثة أشهر يجوز مدها بقرار من الوزير المختص.
(2) إلزام الشركة بزيادة رأس مالها المدفوع أو حجم السيولة النقدية أو الأمرين معاً وفقاً لجدول زمنى محدد.$s54$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss42;

WITH inss42_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 1, 'الباب السابع: الرقابة', 'مادة (42 مكرر) (مضافة بقانون 55 لسنة 2014)', $s55$لمجلس إدارة الهيئة عند إخلال أى من الوكلاء العقاريين أو خبراء التقييم العقارى أو وسطاء التمويل العقارى بأى من إلتزاماتهم الواردة بهذا القانون ولائحته التنفيذية أو عند مخالفة الضوابط والمعايير التى يضعها مجلس إدارتها إتخاذ ما يراه مناسباً من التدابير الآتية:

1- توجيه إنذار بإزالة المخالفة.

2- وقف مزاولة النشاط لمدة لا تجاوز سنة.

3- الشطب من سجلات القيد بالهيئة.

* مضافة بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.$s55$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss42_m1;

WITH inss42_m2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 2, 'الباب السابع: الرقابة', 'مادة (42 مكرر 1) (مضافة بقانون 55 لسنة 2014)', $s56$تنشأ لجنة أو أكثر لنظر تظلمات الشركات والوكلاء العقاريين وخبراء التقييم العقارى ووسطاء التمويل العقارى من القرارات الإدارية الصادرة تطبيقاً لأحكام هذا القانون ولائحته التنفيذية.

ويصدر بتشكيل كل لجنة قرار من الوزير المختص، تكون برئاسة أحد نواب رئيس مجلس الدولة وعضوية إثنين من مستشارى مجلس الدولة يختارهم رئيس المجلس، وممثل عن الهيئة، وعضو من ذوى الخبرة يختاره الوزير المختص.

ويكون التظلم من القرار أمام هذه اللجنة خلال خمسة عشر يوماً من تاريخ الإخطار أو العلم به، على أن تصدر اللجنة قرارها فى التظلم فى ميعاد لا يجاوز ثلاثين يوماً ويكون قرارها نهائياً.

ولا تقبل الدعوى التى ترفع إبتداءً إلى المحكمة المختصة إلا بعد اللجوء للجنة المشار إليها وفوات ميعاد البت فى التظلم.

ويترتب على تقديم التظلم إلى اللجنة وقف المدد المقررة قانوناً لسقوط أو تقادم الحقوق أو لرفع الدعوى، وذلك حتى إنقضاء ميعاد البت فى التظلم.

ويصدر بإجراءات نظر التظلم والبت فيه والرسوم واجبة السداد بما لا يجاوز عشرين ألف جنيه لشركات التمويل العقارى أو إعادة التمويل العقارى وعشرة آلاف جنيه بالنسبة للوكلاء العقاريين وخبراء التقييم العقارى ووسطاء التمويل العقارى قرار من الوزير المختص.

ويتم رد الرسوم التى تم سدادها للمتظلم فى حالة قبول تظلمه أو صدور حكم بإلغاء القرار.

* مضافة بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.$s56$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss42_m2;

WITH inss43 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 43, 0, 'الباب السابع: الرقابة', 'مادة (43)', $s57$مع عدم الإخلال بأحكام القوانين المنظمة لسرية المعلومات يجوز لكل ذى شأن أن يطلب من الجهة الإدارية الاطلاع على السجلات والتقارير والمستندات وغيرها من الأوراق المتعلقة بنشاط التمويل العقارى أو الحصول على مستخرجات رسمية منها مقابل رسم تحدد فئاته اللائحة التنفيذية بما لا يجاوز مائة جنيه ووفقاً للقواعد والإجراءات التى تقررها هذه اللائحة.

وللجهة الإدارية أن ترفض الطلب إذا كان من شأن الإضرار بنشاط التمويل العقارى أو المساس بالصالح العام.$s57$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss43;

WITH inss43_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 43, 1, 'الباب السابع: الرقابة', 'مادة (43 مكرر) (مضافة بقانون 55 لسنة 2014)', $s58$تلتزم الشركة بقرارات الهيئة برد ما هو مستحق للمستثمر إذا ثبت أثناء قيامها بأعمال الرقابة وجود مستحقات مالية له تم الحصول عليها من الشركة بالمخالفة لأحكام هذا القانون ولائحته التنفيذية والقرارات الصادرة تنفيذاً لهما.

* مضافة بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.$s58$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss43_m1;

WITH inss44 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 44, 0, 'الباب السابع: الرقابة', 'مادة (44)', $s59$يكون لموظفى الجهة الإدارية الذين يصدر بتحديد اسمائهم أو وظائفهم قرار من وزير العدل بالاتفاق مع الوزير المختص صفة الضبطية القضائية فى إثبات الجرائم التى تقع بالمخالفة لأحكام هذا القانون والقرارات الصادرة تنفيذاً له ولهم فى سبيل ذلك الاطلاع على السجلات والدفاتر والمستندات والبيانات لدى الجهات التى توجد بها.

وعلى المسئولين فى الجهات المشار إليها أن يقدموا إلى الموظفين المذكورين البيانات والمستخرجات والمستندات والصور التى يطلبونها لهذا الغرض وذلك كله دون الإخلال بأحكام القوانين المنظمة لسرية المعلومات.$s59$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss44;

WITH inss45 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 45, 0, 'الباب الثامن: العقوبات', 'مادة (45)', $s60$مع عدم الإخلال بأية عقوبة أشد منصوص عليها فى أى قانون آخر يعاقب على الأفعال المبينة فى المواد التالية بالعقوبات المنصوص عليها فيها.$s60$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss45;

WITH inss46 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 46, 0, 'الباب الثامن: العقوبات', 'مادة (46)', $s61$يعاقب بالحبس وبغرامة لا تقل عن مائتى ألف جنيه ولا تجاوز مليون جنيه أو بإحدى هاتين العقوبتين كل من باشر أياً من أنشطة التمويل العقارى المنصوص عليها فى هذا القانون دون أن يكون مرخصاً له فى ذلك.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: يعاقب بالحبس وبغرامة لا تقل عن خمسين ألف جنيه ولا تجاوز مائتى ألف جنيه أو بإحدى هاتين العقوبتين كل من باشر نشاط التمويل العقارى المنصوص عليه فى هذا القانون دون أن يكون مرخصاً له فى ذلك.$s61$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss46;

WITH inss47 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 47, 0, 'الباب الثامن: العقوبات', 'مادة (47)', $s62$يعاقب بالحبس مدة لا تزيد على ثلاثة أشهر وبغرامة لا تقل عن خمسين ألف جنيه ولا تجاوز خمسمائة ألف جنيه أو بإحدى هاتين العقوبتين كل من خالف لدى مزاولته أياً من أنشطة التمويل العقارى المعايير والقواعد المشار إليها فى المادتين (4) و(32) من هذا القانون أو التى تحددها اللائحة التنفيذية.

كما يعاقب بالغرامة المشار إليها بالفقرة السابقة كل من يخالف أحكام اللائحة التنفيذية أو القواعد الصادرة من مجلس إدارة الهيئة تطبيقاً لأحكام هذا القانون.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: يعاقب بالحبس مدة لا تزيد على ثلاثة أشهر وبغرامة لا تقل عن عشرة آلاف جنيه ولا تجاوز خمسين ألف جنيه أو بإحدى هاتين العقوبتين كل من خالف فى مزاولة نشاط التمويل العقارى المعايير والقواعد المشار إليها فى المادتين (4) و(32) من هذا القانون والتى تحددها اللائحة التنفيذية.$s62$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss47;

WITH inss48 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 48, 0, 'الباب الثامن: العقوبات', 'مادة (48)', $s63$يعاقب من يخالف أياً من أحكام الفقرة الأولى من المادة (34) بغرامة لا تقل عن مائتى ألف جنيه ولا تجاوز خمسمائة ألف جنيه.$s63$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss48;

WITH inss48_m1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 48, 1, 'الباب الثامن: العقوبات', 'مادة (48 مكرر)', $s64$ملغاة.$s64$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, change_note)
SELECT id, 1, body, '2018-01-01', 'repealed', $n65$أُلغيت المادة بموجب القانون رقم 93 لسنة 2018.$n65$ FROM inss48_m1;

WITH inss49 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 49, 0, 'الباب الثامن: العقوبات', 'مادة (49)', $s66$يجوز فضلاً عن العقوبات المقررة للجرائم المنصوص عليها فى المواد السابقة الحكم على من قُضى عليه بإحدى هذه العقوبات بالحرمان من مزاولة المهنة أو بحظر مزاولة النشاط الذى وقعت الجريمة بمناسبته وذلك لمدة لا تزيد على ثلاث سنوات ويكون الحكم بذلك وجوبياً فى حالة العود.$s66$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss49;

WITH inss50 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 50, 0, 'الباب الثامن: العقوبات', 'مادة (50)', $s67$تسرى أحكام المادة السادسة عشرة من القانون رقم 10 لسنة 2009 المشار إليه على الجرائم التى ترتكب بالمخالفة لأحكام هذا القانون.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: لا يجوز تحريك الدعوى الجنائية باتخاذ أى إجراء فيها أو رفعها بالنسبة إلى الجرائم التى ترتكب بالمخالفة لأحكام هذا القانون أو لائحته التنفيذية أو اتخاذ أى من إجراءات التحقيق فيها إلا بناء على طلب الوزير المختص.
وللوزير المختص قبل صدور حكم بات فى الدعوى أن يقبل الصلح مع المخالف مقابل أداء الحد الأقصى للغرامة المنصوص عليها فى المواد السابقة ويترتب على الصلح انقضاء الدعوى الجنائية.$s67$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss50;

WITH inss51 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 51, 0, 'الباب الثامن: العقوبات', 'مادة (51)', $s68$يُعاقب المسئول عن الإدارة الفعلية للشركة بذات العقوبات المقررة عن الأفعال التى ترتكب بالمخالفة لأحكام هذا القانون أو لائحته التنفيذية إذا ثبت علمه بها وكان إخلاله بالواجبات التى تفرضها عليه تلك الإدارة قد أسهم فى وقوع الجريمة.

وتكون الشركة مسئولة بالتضامن عن الوفاء بما يحكم به من عقوبات مالية وتعويضات.

* معدله بقرار رئيس جمهورية مصر العربية بالقانون رقم 55 لسنة 2014.
النص قبل التعديل: يعاقب المسئول عن الإدارة الفعلية بالشركة بالعقوبات المقررة عن الأفعال التى ترتكب بالمخالفة لأحكام هذا القانون أو لائحته التنفيذية إذا كان إخلاله العمدى بالواجبات التى تفرضها عليه تلك الإدارة قد أدى إلى وقوع الجريمة أو تسبب فيها بخطئه الجسيم.$s68$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss51;

WITH inss52 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 52, 0, 'الباب الثامن: العقوبات', 'مادة (52)', $s69$تكون الشركة مسئولة بالتضامن عن الوفاء بما يحكم به من عقوبات مالية إذا كانت المخالفة قد ارتكبت من أحد العاملين بالشركة باسمها ولصالحها.$s69$
  FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2001-06-24', 'active' FROM inss52;

-- ===== تحقق ختامى =====

DO $verify148_2001$
DECLARE
  v_law_id uuid;
  v_article_count INT;
  v_version_count INT;
  v_repealed_count INT;
  v_scope_count INT;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 148 AND law_year = 2001 AND kind = 'law';

  SELECT count(*) INTO v_article_count FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_version_count FROM article_versions av
    JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id;
  SELECT count(*) INTO v_repealed_count FROM article_versions av
    JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.status = 'repealed';

  IF v_article_count < 64 THEN
    RAISE WARNING '[062] law 148/2001: بعد الهجرة % مادة فقط (متوقَّع 64) — راجع يدوياً.', v_article_count;
  ELSE
    RAISE NOTICE '[062] law 148/2001: % مادة و% نسخة (% منها ملغاة) بعد الهجرة.', v_article_count, v_version_count, v_repealed_count;
  END IF;

  UPDATE laws SET governance_scope = true, enacted_at = COALESCE(enacted_at, '2001-06-24')
  WHERE id = v_law_id;

  SELECT count(*) INTO v_scope_count FROM laws WHERE governance_scope = true;
  RAISE NOTICE '[062] law 148/2001: governance_scope=true مؤكَّد. إجمالى governance_scope=true الآن: %.', v_scope_count;
END;
$verify148_2001$;

COMMIT;