-- =====================================================================
-- Migration 074: القانون المدنى المصرى رقم 131 لسنة 1948
--                        (المتن الكامل: مادتا إصدار + 1148
--                         صفاً موضوعياً يغطى المدى 1-1149)
-- =====================================================================
--
-- المصدر الأساسى: نسخة PDF رفعها صاحب المشروع مباشرة (100 صفحة، 1149
--   مادة — أكبر قانون بُنى على هذه المنصة حتى تاريخه). بيانات تعريف الملف
--   (pdfinfo) أظهرت: Author = "WIPO Lex" (قاعدة بيانات التشريعات التابعة
--   للمنظمة العالمية للملكية الفكرية، مصدر دولى موثوق)، الرمز "EG026AR"،
--   تاريخ إنشاء 2011-02-09 وتاريخ تعديل أخير 2013-07-28. لا توجد فى هذا
--   المستند أى حواشى توضح قوانين مُعدِّلة لمواد بعينها.
--
-- منهجية النقل: نص كل مادة من مواد هذا الملف منقول بالكامل من القراءة
--   البصرية المباشرة لصفحات الـPDF الأصلية (صور)، صفحة بصفحة، وليس من أى
--   تفريغ نصى آلى (pdftotext) — استُخدم التفريغ الآلى حصراً كأداة تحقق
--   تقاطعى مستقلة لعدّ أرقام المواد (كشف عطل نظامى غير قابل للإصلاح
--   الآلى الآمن فى هذا المستند تحديداً: حرف الكاف "ك" يُستخرج أحياناً
--   كحرف الألف الممدودة "آ" بشكل غير منتظم، مما يجعل التفريغ الآلى غير
--   موثوق كمصدر لنص المواد نفسه).
--
-- سياسة effective_from: تاريخ واحد موحَّد لكل الصفوف = '1949-10-15' (تاريخ
--   العمل بالقانون المدنى صراحة بنص المادة 2 من مواد الإصدار: "يعمل به
--   ابتداء من 15 أكتوبر سنة 1949"). لا توجد حواشى تعديل ظاهرة فى نسخة
--   المصدر، وأُجرى بحث ويب مخصص قبل البناء (ثقة متوسطة-عالية) لم يُظهر
--   أى دليل على تعديل تشريعى جوهرى لاحق لنص القانون المدنى نفسه بعد تاريخ
--   تعديل المصدر (2013). لا نمط REPLACE هنا (نسخة واحدة فقط لكل صف،
--   status='active' دائماً).
--
-- فجوتان موثقتان صراحة فى نص المصدر نفسه (عبارة "ملغاة" ظاهرة بين
--   المواد، 56 رقماً إجمالاً أُدرجت كصفوف بمتن "(ملغاة)."
--   بدل حذف ترقيمها):
--     * المواد 54-80 (27 مادة، نهاية باب الجمعيات) — "المواد من 54 إلى 80
--       ملغاة" بنص المصدر، مع علامة حاشية (1) بلا نص حاشية مصاحب فى هذه
--       النسخة (لا تتوفر معلومة القانون المُلغِى تحديداً من هذا المصدر).
--     * المواد 389-417 (29 مادة، باب إثبات الالتزام بالكامل) — "المواد
--       من 389 إلى 417 ملغاة" بنص المصدر، لنفس السبب (استُبدل هذا الباب
--       لاحقاً بقانون الإثبات فى المواد المدنية والتجارية 25/1968، دون أن
--       يكون هذا استنتاجاً معتمَداً من حاشية فى هذا المستند تحديداً).
--
-- فجوة ثالثة غير موثقة بأى ملاحظة إلغاء: المادة 1022 غائبة تماماً من نص
--   المصدر (لا ترقيم مزدوج، لا ملاحظة "ملغاة") — تحقَّق هذا مباشرة
--   بالقراءة البصرية للصفحة 87 من المستند الأصلى مرتين منفصلتين: المادة
--   1021 تليها مباشرة المادة 1023 دون أى فاصل. فجوة ترقيم أصلية فى
--   المستند المصدر نفسه دون تفسير مصاحب، فلم يُدرَج أى صف لها إطلاقاً
--   (لا اختلاق)، قياساً على معالجة فجوة مماثلة غير مُفسَّرة فى اللائحة
--   التنفيذية 96/1982 (الفجوة 323-332، migration 073).
--
-- بنية الترقيم:
--   - مادتا إصدار (article_suffix_order = -1، أرقام 1-2).
--   - 1148 رقم مادة أساسى موضوعية مميز يغطى المدى الكامل
--     1-1149 باستثناء فجوة المادة 1022 الوحيدة غير المُفسَّرة (1148 رقماً
--     = 1149 - 1). لا مواد "مكررة" (article_suffix_order >= 1) فى هذا
--     القانون — كل رقم مادة موضوعية يظهر مرة واحدة فقط فى نص المصدر.
--   - إجمالى الصفوف: 1150 صفاً.
--
-- البنية الهرمية: القسم (مستويان: الالتزامات والحقوق الشخصية / الحقوق
--   العينية) > الكتاب > الباب > الفصل، مع عناوين فرعية رقمية أحياناً
--   داخل الفصل الواحد. كل عنوان هرمى نُقل بصرياً من رأس كل صفحة أو من
--   عنوان القسم/الفصل الظاهر فعلياً فى الصورة.
--
-- التصنيف: category='commercial' (يطابق قيد laws_category_check؛ لا فئة
--   "مدنى" مخصصة فى القيد الحالى، فاستُخدمت 'commercial' قياساً على
--   التصنيف المعتمد سابقاً لقانون الشركات 159/1981 ولقانون التجارة
--   الموحد، باعتبار القانون المدنى المرجع العام للمعاملات المدنية
--   والتجارية على السواء).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

INSERT INTO laws (country_code, law_no, law_year, kind, category, title, short_title, status, official_url, enacted_at)
SELECT 'EG', 131, 1948, 'law', 'commercial',
       $tlaw$القانون المدنى المصرى، الصادر بالقانون رقم 131 لسنة 1948$tlaw$, $stlaw$القانون المدنى 131/1948$stlaw$, 'in_force', $urllaw$مصدر المستخدم المباشر: نسخة PDF رفعها صاحب المشروع مباشرة (100 صفحة)؛ بيانات تعريف الملف تُظهر Author = WIPO Lex (قاعدة بيانات التشريعات التابعة للمنظمة العالمية للملكية الفكرية، مصدر دولى موثوق)، الرمز EG026AR$urllaw$, '1949-10-15'
WHERE NOT EXISTS (
    SELECT 1 FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
);

-- ===== مادتا الإصدار (article_suffix_order = -1) =====
WITH insE1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, -1, 'مواد الإصدار', $bE1$يلغى القانون المدنى المعمول به أمام المحاكم الوطنية والصادر فى 28 أكتوبر سنة 1883 والقانون المدنى المعمول به أمام المحاكم المختلطة والصادر فى 28 يونيو سنة 1875 ويستعاض عنهما بالقانون المدنى المرافق لهذا القانون.$bE1$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM insE1;

WITH insE2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, -1, 'مواد الإصدار', $bE2$على وزير العدل تنفيذ هذا القانون ويعمل به ابتداء من 15 أكتوبر سنة 1949.$bE2$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM insE2;

-- ===== المواد الموضوعية 1-1149 (article_suffix_order = 0)، باستثناء فجوة 1022 =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, 0, $h1$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 1- القانون والحق$h1$, $b1$(1) تسرى النصوص التشريعية على جميع المسائل التي تتناولها لهذه النصوص في لفظها أو في فحواها.
(2) فإذا لم يوجد نص تشريعي يمكن تطبيقه، حكم القاضي بمقتضى العرف، فإذا لم يوجد، فبمقتضى مبادئ الشريعة الإسلامية، فإذا لم توجد، فبمقتضى مبادئ القانون الطبيعي وقواعد العدالة.$b1$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, 0, $h2$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 1- القانون والحق$h2$, $b2$لا يجوز إلغاء نص تشريعي إلا بتشريع لاحق ينص صراحة على هذا الإلغاء، أو يشتمل على نص يتعارض مع نص التشريع القديم، أو ينظم من جديد الموضوع الذي سبق أن قرر قواعده ذلك التشريع.$b2$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, 0, $h3$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 1- القانون والحق$h3$, $b3$تحسب المواعيد بالتقويم الميلادي، ما لم ينص القانون على غير ذلك.$b3$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, 0, $h4$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 1- القانون والحق$h4$, $b4$من استعمل حقه استعمالا مشروعاً لا يكون مسئولا عما ينشأ عن ذلك من ضرر.$b4$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, 0, $h5$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 1- القانون والحق$h5$, $b5$يكون استعمال الحق غير مشروع في الأحوال الآتية:
(أ) إذا لم يقصد به سوى الإضرار بالغير.
(ب) إذا كانت المصالح التي يرمي إلى تحقيقها قليلة الأهمية، بحيث لا تتناسب البتة مع ما يصيب الغير من ضرر بسببها.
(جـ) إذا كانت المصالح التي يرمي إلى تحقيقها غير مشروعة.$b5$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, 0, $h6$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث الزمان$h6$, $b6$(1) النصوص المتعلقة بالأهلية تسري على جميع الأشخاص الذين تنطبق عليهم الشروط المقررة في هذه النصوص.
(2) وإذا عاد شخص توافرت فيه الأهلية، بحسب نصوص قديمة، ناقص الأهلية بحسب نصوص جديدة، فان ذلك لا يؤثر في تصرفاته السابقة.$b6$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 7, 0, $h7$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث الزمان$h7$, $b7$تسري النصوص الجديدة المتعلقة بالتقادم من وقت العمل بها على كل تقادم لم يكتمل.
على أن النصوص القديمة هي التي تسري على المسائل الخاصة ببدء التقادم ووقفه وانقطاعه، وذلك عن المدة السابقة على العمل بالنصوص الجديدة.$b7$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 8, 0, $h8$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث الزمان$h8$, $b8$(1) إذا قرر النص الجديد مدة للتقادم اقصر مما قرره النص القديم سرت المدة الجديدة من وقت العمل بالنص الجديد، ولو كانت المدة القديمة قد بدأت قبل ذلك.
(2) أما إذا كان الباقي من المدة التي نص عليها القانون القديم أقصر من المدة التي قررها النص الجديد، فان التقادم يتم بانقضاء هذا الباقي.$b8$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 9, 0, $h9$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث الزمان$h9$, $b9$تسري في شأن الأدلة التي تعد مقدما النصوص المعمول بها في الوقت الذي أعد فيه الدليل، أو في الوقت الذي كان ينبغي فيه إعداده.$b9$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 10, 0, $h10$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h10$, $b10$القانون المصري هو المرجع في تكييف العلاقات عندما يطلب تحديد نوع هذه العلاقات في قضية تتنازع فيها القوانين، لمعرفة القانون الواجب تطبيقه من بينها.$b10$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 11, 0, $h11$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h11$, $b11$(1) الحالة المدنية للأشخاص وأهليتهم يسري عليها قانون الدولة التي ينتمون إليها بجنسيتهم. ومع ذلك ففي التصرفات المالية التي تعقد في مصر وتترتب أثارها فيها، إذا كان أحد الطرفين أجنبيا ناقص الأهلية وكان نقص الأهلية يرجع إلى سبب فيه خفاء لا يسهل على الطرف الآخر تبينه، فان هذا السبب لا يؤثر في أهليته.
(2) أما النظام القانوني للأشخاص الاعتبارية الأجنبية، من شركات وجمعيات ومؤسسات وغيرها، فيسري عليه قانون الدولة التي اتخذت فيها هذه الأشخاص مركز إدارتها الرئيسي الفعلي ومع ذلك فإذا باشرت نشاطها الرئيسي في مصر، فان القانون المصري هو الذي يسري.$b11$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins11;

WITH ins12 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 12, 0, $h12$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h12$, $b12$يرجع في الشروط الموضوعية لصحة الزواج إلى قانون كل من الزوجين.$b12$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins12;

WITH ins13 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 13, 0, $h13$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h13$, $b13$(1) يسري قانون الدولة التي ينتمي إليها الزوج وقت انعقاد الزواج على الآثار التي يرتبها عقد الزواج، مما في ذلك من أثر بالنسبة إلى المال.
(2) أما الطلاق فيسري عليه قانون الدولة التي ينتمي إليها الزوج وقت الطلاق، ويسري على التطليق والانفصال قانون الدولة التي ينتمي إليها الزوج وقت الدعوى.$b13$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins13;

WITH ins14 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 14, 0, $h14$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h14$, $b14$في الأحوال المنصوص عليها في المادتين السابقتين إذا كان أحد الزوجين مصريا وقت انعقاد الزواج، يسري القانون المصري وحده، فما عدا شرط الأهلية للزواج.$b14$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins14;

WITH ins15 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 15, 0, $h15$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h15$, $b15$يسري على الإلزام بالنفقة فيما بين الأقارب، قانون المدين بها.$b15$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins15;

WITH ins16 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 16, 0, $h16$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h16$, $b16$يسري على المسائل الموضوعية الخاصة بالولاية والوصاية والقوامة وغيرها من النظم الموضوعة لحماية المحجورين والغائبين، قانون الشخص الذي تجب حمايته.$b16$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins16;

WITH ins17 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 17, 0, $h17$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h17$, $b17$(1) يسري على الميراث والوصية وسائر التصرفات المضافة إلى ما بعد الموت، قانون المورث أو الموصي أو من صدر منه التصرف وقت موته.
(2) ومع ذلك يسري على شكل الوصية، قانون الموصي وقت الإيصاء أو قانون البلد الذي تمت فيه الوصية، وكذلك الحكم في شكل سائر التصرفات المضافة إلى ما بعد الموت.$b17$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins17;

WITH ins18 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 18, 0, $h18$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h18$, $b18$يسري على الحيازة والملكية والحقوق العينية الأخرى، قانون الموقع فيما يختص بالعقار، ويسري بالنسبة إلى المنقول، قانون الجهة التي يوجد فيها هذا المنقول وقت تحقق السبب الذي ترتب عليه كسب الحيازة أو الملكية أو الحقوق العينية الأخرى أو فقدها.$b18$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins18;

WITH ins19 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 19, 0, $h19$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h19$, $b19$(1) يسري على الالتزامات التعاقدية، قانون الدولة التي يوجد فيها الموطن المشترك للمتعاقدين إذا اتحدا موطنا، فان اختلفا موطنا سري قانون الدولة التي تم فيها العقد. هذا ما لم يتفق المتعاقدان أو يتبين من الظروف أن قانونا آخر هو الذي يراد تطبيقه.
(2) على أن قانون موقع العقار هو الذي يسري على العقود التي أبرمت في شان هذا العقار.$b19$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins19;

WITH ins20 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 20, 0, $h20$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h20$, $b20$يسري على العقود ما بين الأحياء تخضع في شكلها لقانون البلد الذي تم فيه، ويجوز أيضا أن تخضع للقانون الذي يسري على أحكامها الموضوعية، كما يجوز أيضا أن تخضع لقانون موطن المتعاقدين أو قانونهما الوطني المشترك.$b20$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins20;

WITH ins21 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 21, 0, $h21$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h21$, $b21$(1) يسري على الالتزامات غير التعاقدية قانون البلد الذي وقع فيه الفعل المنشئ للالتزام.
(2) على أنه فيما يتعلق بالالتزامات الناشئة عن الفعل الضار، لا تسري أحكام الفقرة السابقة على الوقائع التي تحدث في الخارج في مصر وتكون مشروعة في مصر وأن كانت تعد غير مشروعة في البلد الذي وقعت فيه.$b21$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins21;

WITH ins22 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 22, 0, $h22$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h22$, $b22$يسري على قواعد الاختصاص وجميع المسائل الخاصة بالإجراءات قانون البلد الذي تقام فيه الدعوى أو تباشر فيه الإجراءات.$b22$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins22;

WITH ins23 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 23, 0, $h23$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h23$, $b23$لا تسري أحكام المواد السابقة إلا حيث لا يوجد نص على خلاف ذلك في قانون خاص أو في معاهدة دولية نافذة في مصر.$b23$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins23;

WITH ins24 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 24, 0, $h24$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h24$, $b24$تتبع فيما لم يرد في شأنه نص في المواد السابقة من أحوال تنازع القوانين مبادئ القانون الدولي الخاص.$b24$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins24;

WITH ins25 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 25, 0, $h25$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h25$, $b25$(1) يعين القاضي القانون الذي يجب تطبيقه في حالة الأشخاص الذين لا تعرف لهم جنسية، أو الذين تثبت لهم جنسيات متعددة في وقت واحد.
(2) على أن الأشخاص الذين تثبت لهم في وقت واحد الجنسية المصرية وبالنسبة إلى دولة أجنبية أو عدة دول أجنبية جنسية تلك الدول، فالقانون المصري هو الذي يجب تطبيقه.$b25$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins25;

WITH ins26 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 26, 0, $h26$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h26$, $b26$متى ظهر من الأحكام الواردة في المواد المتقدمة أن القانون الواجب التطبيق هو قانون دولة معينة تتعدد فيها الشرائع، فإن القانون الداخلي لتلك الدولة هو الذي يقرر أية شريعة من هذه الشرائع يجب تطبيقها.$b26$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins26;

WITH ins27 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 27, 0, $h27$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h27$, $b27$إذا تقرر أن قانونا أجنبيا هو الواجب التطبيق فلا يطبق منه إلا أحكامه الداخلية، دون تلك التي تتعلق بالقانون الدولي الخاص.$b27$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins27;

WITH ins28 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 28, 0, $h28$باب تمهيدى - أحكام عامة > الفصل الأول - القانون وتطبيقه > 2- تطبيق القانون > تنازع القوانين من حيث المكان$h28$, $b28$لا يجوز تطبيق أحكام القانون الأجنبي عينته النصوص السابقة - إذا كانت هذه الأحكام مخالفة للنظام العام أو للآداب في مصر.$b28$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins28;

WITH ins29 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 29, 0, $h29$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h29$, $b29$(1) تبدأ شخصية الإنسان بتمام ولادته حيا، وتنتهى بموته.
(2) ومع ذلك فحقوق الحمل المستكن يعينها القانون.$b29$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins29;

WITH ins30 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 30, 0, $h30$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h30$, $b30$(1) تثبت الولادة والوفاة بالسجلات الرسمية المعدة لذلك.
(2) فإذا لم يوجد لهذا الدليل عدم صحة ما أدرج بالسجلات، جاز الإثبات بأية طريقة أخرى.$b30$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins30;

WITH ins31 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 31, 0, $h31$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h31$, $b31$دفاتر المواليد والوفيات والتبليغات المتعلقة بها، ينظمها قانون خاص.$b31$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins31;

WITH ins32 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 32, 0, $h32$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h32$, $b32$يسري في شأن المفقود والغائب الأحكام المقررة في قوانين خاصة فإن لم توجد فأحكام الشريعة الإسلامية.$b32$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins32;

WITH ins33 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 33, 0, $h33$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h33$, $b33$الجنسية المصرية ينظمها قانون خاص.$b33$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins33;

WITH ins34 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 34, 0, $h34$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h34$, $b34$(1) تتكون أسرة الشخص من ذوي قرباه.
(2) ويعتبر من ذوي القربى كل من يجمعهم أصل مشترك.$b34$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins34;

WITH ins35 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 35, 0, $h35$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h35$, $b35$(1) القرابة المباشرة هي الصلة ما بين الأصول والفروع.
(2) وقرابة الحواشي هي الرابطة ما بين أشخاص يجمعهم أصل مشترك، دون أن يكون أحدهم فرعا للآخر.$b35$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins35;

WITH ins36 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 36, 0, $h36$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h36$, $b36$يراعى في حساب درجة القرابة المباشرة، اعتبار كل فرع درجة عند الصعود للأصل بخروج هذا الأصل، وعند حساب درجات الحواشي تعد درجات صعودا من الفرع للأصل المشترك، ثم نزولا منه إلى الفرع الآخر، وكل فرع فيما عدا الأصل المشترك يعتبر درجة.$b36$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins36;

WITH ins37 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 37, 0, $h37$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h37$, $b37$أقارب أحد الزوجين يعتبرون في نفس القرابة والدرجة بالنسبة إلى الزوج الآخر.$b37$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins37;

WITH ins38 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 38, 0, $h38$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h38$, $b38$يكون لكل شخص اسم ولقب، ولقب الشخص يلحق أولاده.$b38$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins38;

WITH ins39 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 39, 0, $h39$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h39$, $b39$ينظم بتشريع خاص كيفية اكتساب الألقاب وتغييرها.$b39$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins39;

WITH ins40 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 40, 0, $h40$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h40$, $b40$(1) الموطن هو المكان الذي يقيد فيه الشخص عادة.
(2) ويجوز أن يكون للشخص في وقت واحد أكثر من موطن، كما يجوز ألا يكون له موطن ما.$b40$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins40;

WITH ins41 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 41, 0, $h41$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h41$, $b41$يعتبر المكان الذي يباشر فيه الشخص تجارة أو حرفة موطنا بالنسبة إلى الأعمال المتعلقة بهذه التجارة أو الحرفة.$b41$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins41;

WITH ins42 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 42, 0, $h42$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h42$, $b42$(1) موطن القاصر والمحجور عليه والمفقود والغائب هو موطن من ينوب عنهم قانونا.
(2) ومع ذلك يكون للقاصر الذي بلغ ثماني عشرة سنة في حكمه موطن خاص، بالنسبة إلى الأعمال والتصرفات التي يعتبره القانون أهلا لمباشرتها.$b42$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins42;

WITH ins43 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 43, 0, $h43$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h43$, $b43$(1) يجوز اتخاذ موطن مختار لتنفيذ عمل قانوني معين.
(2) ولا يجوز إثبات وجود الموطن المختار إلا بالكتابة.
(3) والموطن المختار لتنفيذ عمل قانوني يكون هو الموطن بالنسبة إلى كل ما يتعلق بهذا العمل، إلا إذا اشترط صراحة قصر هذا الموطن على أعمال دون أخرى.$b43$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins43;

WITH ins44 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 44, 0, $h44$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h44$, $b44$(1) كل شخص بلغ سن الرشد متمتعا بقواه العقلية، ولم يحجر عليه، يكون كامل الأهلية لمباشرة حقوقه المدنية.
(2) وسن الرشد هي إحدى وعشرون سنة ميلادية كاملة.$b44$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins44;

WITH ins45 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 45, 0, $h45$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h45$, $b45$(1) لا يكون أهلا لمباشرة حقوقه المدنية من كان فاقد التمييز لصغر في السن أو عته أو جنون.
(2) وكل من لم يبلغ السابعة يعتبر فاقدا للتمييز.$b45$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins45;

WITH ins46 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 46, 0, $h46$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h46$, $b46$كل من بلغ سن التمييز ولم يبلغ سن الرشد يكون ناقص الأهلية، وكل من بلغ سن الرشد وكان سفها أو كان ذا غفلة، يكون ناقص الأهلية وفقا لما يقرره القانون.$b46$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins46;

WITH ins47 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 47, 0, $h47$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h47$, $b47$يخضع فاقدو الأهلية وناقصوها بحسب الأحوال لأحكام الولاية أو الوصاية أو القوامة وفقا للقواعد المقررة للقانون.$b47$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins47;

WITH ins48 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 48, 0, $h48$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h48$, $b48$ليس لحد النزول عن أهليته ولا التعديل في أحكامها.$b48$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins48;

WITH ins49 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 49, 0, $h49$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h49$, $b49$ليس لحد النزول عن حريته الشخصية.$b49$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins49;

WITH ins50 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 50, 0, $h50$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h50$, $b50$لكل من وقع عليه اعتداء غير مشروع في حق من الحقوق الملازمة لشخصيته، أن يطلب وقف هذا الاعتداء مع التعويض عما قد يكون لحقه من ضرر.$b50$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins50;

WITH ins51 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 51, 0, $h51$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 1- الشخص الطبيعى$h51$, $b51$لكل من نازعه الغير في استعمال اسمه بلا مبرر، ومن انتحل الغير اسمه دون حق، أن يطلب وقف هذا الاعتداء مع التعويض عما قد يكون لحقه من ضرر.$b51$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins51;

WITH ins52 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 52, 0, $h52$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى$h52$, $b52$الأشخاص الاعتبارية هي:
1- الدولة وكذلك المديريات والمدن والقرى بالشروط التي يحددها القانون والإدارات والمصالح العامة وغيرها من المنشآت التي يمنحها القانون شخصية اعتبارية.
2- الهيئات والطوائف الدينية التي تعترف لها الدولة بشخصية اعتبارية.
3- الأوقاف.
4- الشركات التجارية والمدنية.
5- الجمعيات والمؤسسات المنشأة للأحكام التي سيأتي فيما بعد.
6- كل مجموعة من الأشخاص أو الأموال الاعتبارية تثبت لها الشخصية الاعتبارية بمقتضى نص في القانون.$b52$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins52;

WITH ins53 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 53, 0, $h53$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى$h53$, $b53$(1) الشخص الاعتباري يتمتع بجميع الحقوق إلا ما كان منها ملازما لصفة الإنسان الطبيعية، وذلك في الحدود التي قررها القانون.
(2) فيكون له:
(أ) ذمة مالية مستقلة.
(ب) أهلية في الحدود التي يعينها سند إنشائه، أو التي يقررها القانون.
(جـ) حق التقاضي
(د) موطن مستقل. ويعتبر موطنه المكان الذي يوجد فيه مركز إدارته. والشركات التي يكون مركزها الرئيسي في الخارج ولها نشاط في مصر يعتبر مركز إدارتها، بالنسبة إلى القانون الداخلي، المكان الذي توجد فيه الإدارة المحلية.
(3) ويكون له نائب يعبر عن إرادته.$b53$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins53;

WITH ins54 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 54, 0, $h54$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h54$, $b54$(ملغاة).$b54$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins54;

WITH ins55 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 55, 0, $h55$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h55$, $b55$(ملغاة).$b55$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins55;

WITH ins56 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 56, 0, $h56$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h56$, $b56$(ملغاة).$b56$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins56;

WITH ins57 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 57, 0, $h57$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h57$, $b57$(ملغاة).$b57$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins57;

WITH ins58 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 58, 0, $h58$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h58$, $b58$(ملغاة).$b58$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins58;

WITH ins59 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 59, 0, $h59$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h59$, $b59$(ملغاة).$b59$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins59;

WITH ins60 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 60, 0, $h60$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h60$, $b60$(ملغاة).$b60$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins60;

WITH ins61 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 61, 0, $h61$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h61$, $b61$(ملغاة).$b61$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins61;

WITH ins62 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 62, 0, $h62$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h62$, $b62$(ملغاة).$b62$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins62;

WITH ins63 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 63, 0, $h63$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h63$, $b63$(ملغاة).$b63$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins63;

WITH ins64 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 64, 0, $h64$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h64$, $b64$(ملغاة).$b64$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins64;

WITH ins65 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 65, 0, $h65$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h65$, $b65$(ملغاة).$b65$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins65;

WITH ins66 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 66, 0, $h66$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h66$, $b66$(ملغاة).$b66$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins66;

WITH ins67 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 67, 0, $h67$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h67$, $b67$(ملغاة).$b67$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins67;

WITH ins68 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 68, 0, $h68$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h68$, $b68$(ملغاة).$b68$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins68;

WITH ins69 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 69, 0, $h69$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h69$, $b69$(ملغاة).$b69$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins69;

WITH ins70 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 70, 0, $h70$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h70$, $b70$(ملغاة).$b70$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins70;

WITH ins71 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 71, 0, $h71$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h71$, $b71$(ملغاة).$b71$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins71;

WITH ins72 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 72, 0, $h72$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h72$, $b72$(ملغاة).$b72$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins72;

WITH ins73 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 73, 0, $h73$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h73$, $b73$(ملغاة).$b73$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins73;

WITH ins74 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 74, 0, $h74$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h74$, $b74$(ملغاة).$b74$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins74;

WITH ins75 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 75, 0, $h75$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h75$, $b75$(ملغاة).$b75$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins75;

WITH ins76 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 76, 0, $h76$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h76$, $b76$(ملغاة).$b76$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins76;

WITH ins77 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 77, 0, $h77$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h77$, $b77$(ملغاة).$b77$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins77;

WITH ins78 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 78, 0, $h78$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h78$, $b78$(ملغاة).$b78$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins78;

WITH ins79 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 79, 0, $h79$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h79$, $b79$(ملغاة).$b79$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins79;

WITH ins80 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 80, 0, $h80$باب تمهيدى - أحكام عامة > الفصل الثانى - الأشخاص > 2- الشخص الاعتبارى > الجمعيات$h80$, $b80$(ملغاة).$b80$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins80;

WITH ins81 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 81, 0, $h81$باب تمهيدى - أحكام عامة > الفصل الثالث - تقسيم الأشياء والأموال$h81$, $b81$(1) كل شيء غير خارج عن التعامل بطبيعته أو بحكم القانون يصح أن يكون محلا للحقوق المالية.
(2) والأشياء التي تخرج عن التعامل بطبيعتها هي التي لا يستطيع أحد أن يستأثر بحيازتها، وأما الخارجة بحكم القانون فهي التي لا يجيز القانون أن تكون محلا للحقوق المالية.$b81$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins81;

WITH ins82 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 82, 0, $h82$باب تمهيدى - أحكام عامة > الفصل الثالث - تقسيم الأشياء والأموال$h82$, $b82$(1) كل شيء مستقر بحيزه ثابت فيه لا يمكن نقله دون أن ذلك يتلف، فهو عقار وكل ما عدا ذلك فهو منقول.
(2) ومع ذلك يعتبر عقارا بالتخصيص، المنقول الذي يضعه صاحبه في عقار يملكه على خدمة هذا العقار أو استغلاله.$b82$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins82;

WITH ins83 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 83, 0, $h83$باب تمهيدى - أحكام عامة > الفصل الثالث - تقسيم الأشياء والأموال$h83$, $b83$(1) يعتبر مالا عقاريا كل حق عيني يقع على عقار، بما في ذلك حق الملكية، وكذلك كل دعوى تتعلق بحق عيني يقع على عقار.
(2) ويعتبر مالا منقولا ما عدا ذلك من الحقوق المالية.$b83$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins83;

WITH ins84 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 84, 0, $h84$باب تمهيدى - أحكام عامة > الفصل الثالث - تقسيم الأشياء والأموال$h84$, $b84$(1) الأشياء القابلة للاستهلاك هي التي ينحصر استعمالها، بحسب ما أعدت له، في استهلاكها أو أنفاقها.
(2) فيعتبر قابلا للاستهلاك كل ما اعد في المتاجر للبيع.$b84$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins84;

WITH ins85 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 85, 0, $h85$باب تمهيدى - أحكام عامة > الفصل الثالث - تقسيم الأشياء والأموال$h85$, $b85$الأشياء المثلية هي التي يقوم بعضها بعضها مقام الوفاء، والتي تقدر عادة في التعامل بين الناس بالعدد أو الكيل أو المقاس أو الوزن.$b85$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins85;

WITH ins86 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 86, 0, $h86$باب تمهيدى - أحكام عامة > الفصل الثالث - تقسيم الأشياء والأموال$h86$, $b86$الحقوق التي ترد على شيء غير مادي تنظمها قوانين خاصة.$b86$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins86;

WITH ins87 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 87, 0, $h87$باب تمهيدى - أحكام عامة > الفصل الثالث - تقسيم الأشياء والأموال$h87$, $b87$(1) تعتبر أموالا عامة العقارات والمنقولات التي للدولة أو للأشخاص الاعتبارية العامة، والتي تكون مخصصة لمنفعة عامة بالفعل أو بمقتضى قانون أو مرسوم أو قرار من الوزير المختص.
(2) وهذه الأموال لا يجوز التصرف فيها أو الحجز عليها أو تملكها بالتقادم.$b87$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins87;

WITH ins88 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 88, 0, $h88$باب تمهيدى - أحكام عامة > الفصل الثالث - تقسيم الأشياء والأموال$h88$, $b88$تفقد الأموال العامة صفتها العامة بانهاء تخصيصها للمنفعة العامة. وينتهي التخصيص بمقتضى قانون أو مرسوم أو قرار من الوزير المختص أو بالفعل، أو بانتهاء الغرض الذي من أجله خصصت تلك الأموال للمنفعة العامة.$b88$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins88;

WITH ins89 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 89, 0, $h89$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h89$, $b89$يتم العقد بمجرد أن يتبادل طرفان التعبير عن ارادتين متطابقتين، مع مراعاة ما يقرره القانون فوق ذلك من أوضاع معينة لانعقاد العقد.$b89$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins89;

WITH ins90 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 90, 0, $h90$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h90$, $b90$(1) التعبير عن الإرادة يكون باللفظ والكتابة وبالإشارة المتداولة عرفا، كما يكون باتخاذ موقف لا تدع ظروف الحال شكا في دلالته على حقيقة المقصود.
(2) ويجوز أن يكون التعبير عن الإرادة ضمنيا، إذا لم ينص القانون أو يتفق الطرفان على أن يكون صريحا.$b90$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins90;

WITH ins91 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 91, 0, $h91$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h91$, $b91$ينتج التعبير عن الإرادة أثره في الوقت الذي يتصل فيه بعلم من وجه إليه، ويعتبر وصول التعبير قرينة على العلم به، ما لم يقم الدليل على عكس ذلك.$b91$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins91;

WITH ins92 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 92, 0, $h92$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h92$, $b92$إذا مات من صدر منه التعبير عن الإرادة أو فقد أهليته قبل أن ينتج التعبير عن إرادته أثره، فان ذلك لا يمنع من ترتب هذا الأثر عند اتصال التعبير بعلم من وجه إليه، هذا ما لم يتبين العكس من التعبير أو من طبيعة التعامل.$b92$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins92;

WITH ins93 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 93, 0, $h93$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h93$, $b93$(1) إذا عين ميعاد للقبول الموجب التزم بالبقاء على إيجابه إلى أن ينقضي هذا الميعاد.
(2) وقد يستخلص الميعاد من ظروف الحال أو من طبيعة المعاملة.$b93$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins93;

WITH ins94 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 94, 0, $h94$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h94$, $b94$(1) إذا صدر الإيجاب في مجلس العقد، دون أن يعين ميعاد القبول، فان الموجب يتحلل من إيجابه إذا لم يصدر القبول فورا، وكذلك الحال إذا صدر الإيجاب من شخص إلى شخص آخر بطريق التليفون أو بأي طريق مماثل.
(2) ومع ذلك يتم العقد ولو لم يصدر القبول فورا، إذا لم يوجد ما يدل على أن الموجب قد عدل عن إيجابه في الفترة ما بين الإيجاب والقبول، وكان القبول قد صدر قبل أن ينفض مجلس العقد.$b94$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins94;

WITH ins95 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 95, 0, $h95$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h95$, $b95$إذا اتفق الطرفان على جميع المسائل الجوهرية في العقد، واحتفظا فيما بعد بمسائل تفصيلية ليتفقا عليها، لا يمنع ذلك من اعتبار العقد قد تم. وإذا قام خلاف على المسائل التي لم يتم الاتفاق عليها، فان المحكمة تقضي فيها طبقا لطبيعة المعاملة ولأحكام القانون والعرف والعدالة.$b95$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins95;

WITH ins96 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 96, 0, $h96$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h96$, $b96$إذا اقترن القبول بما يزيد في الإيجاب أو يقيد منه أو يعدل فيه، اعتبر رفضا يتضمن إيجابا جديدا.$b96$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins96;

WITH ins97 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 97, 0, $h97$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h97$, $b97$(1) يعتبر التعاقد ما بين الغائبين قد تم في المكان وفي الزمان اللذين يعلم فيهما الموجب بالقبول، ما لم يوجد اتفاق أو نص قانوني يقضي بغير ذلك.
(2) ويفترض أن الموجب قد علم بالقبول في المكان وفي الزمان اللذان وصل إليه فيهما هذا القبول.$b97$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins97;

WITH ins98 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 98, 0, $h98$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h98$, $b98$(1) إذا كانت طبيعة المعاملة أو العرف أو غير ذلك من الظروف تدل على أن الموجب لم يكن لينتظر تصريحا بالقبول، فان العقد يعتبر قد تم، إذا لم يرفض الإيجاب في وقت مناسب.
(2) ويعتبر السكوت عن الرد قبولا، إذا كان هناك تعامل سبق بين المتعاقدين واتصل هذا الإيجاب بهذا التعامل، أو إذا تمخض إيجاب لمنفعة من وجه إليه.$b98$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins98;

WITH ins99 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 99, 0, $h99$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h99$, $b99$لا يتم العقد في المزايدات إلا برسوم المزاد، ويسقط العطاء بعطاء يزيد عليه ولو كان باطلا.$b99$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins99;

WITH ins100 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 100, 0, $h100$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h100$, $b100$القبول في عقود الإذعان يقتصر على مجرد التسليم بشروط يضعها الموجب ولا يقبل مناقشة فيها.$b100$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins100;

WITH ins101 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 101, 0, $h101$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h101$, $b101$(1) الاتفاق الذي يعد بموجبه كلا المتعاقدين أو إحداهما بإبرام عقد معين في المستقبل لا ينعقد، إلا إذا عينت جميع المسائل الجوهرية للعقد المراد إبرامه، والمدة التي يجب إبرامه فيها.
(2) وإذا اشترط القانون لتمام العقد استيفاء شكل معين، فهذا الشكل تجب مراعاته أيضا في الاتفاق الذي يتضمن الوعد بإبرام هذا العقد.$b101$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins101;

WITH ins102 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 102, 0, $h102$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h102$, $b102$إذا وعد شخص بإبرام عقد ثم نكل عن قضاء المتعاقد الآخر تنفيذ الوعد، وكانت الشروط اللازمة لتمام العقد الذي وعد به متوافرة متى يتعلق منها بخاصة بالشكل الذي يجب أن يستوفيه فيه العقد، قام الحكم متى حاز قوة الشيء المقضي به مقام العقد.$b102$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins102;

WITH ins103 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 103, 0, $h103$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h103$, $b103$(1) دفع العربون وقت إبرام العقد يفيد أن يحق لكل من المتعاقدين الحق في العدول عنه، إلا إذا قضي الاتفاق بغير ذلك.
(2) فإذا عدل من دفع من العربون وقت، فقده، وإذا عدل من قبضه، رد ضعفه، هذا ولو لم يترتب على العدول أي ضرر.$b103$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins103;

WITH ins104 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 104, 0, $h104$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h104$, $b104$(1) إذا تم العقد بطريق النيابة، كان شخص النائب لا محل الأصيل هو محل الاعتبار عند النظر في عيوب الإرادة أو في أثر بعض الظروف الخاصة بالعلم أو افتراض العلم بها حتما.
(2) ومع ذلك إذا كان النائب وكيلا ويتصرف وفقا لتعليمات معينة صدرت له من موكله، فليس للموكل أن يتمسك بجهل النائب لظروف كان يعلمها هو، أو كان المفروض حتما أن يعلمها.$b104$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins104;

WITH ins105 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 105, 0, $h105$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h105$, $b105$إذا أبرم النائب في حدود نيابته عقدا باسم الأصيل فان ما ينشأ عن هذا العقد من حقوق والتزامات يضاف إلى الأصيل.$b105$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins105;

WITH ins106 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 106, 0, $h106$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h106$, $b106$إذا لم يعلن العاقد وقت إبرام العقد أنه يتعاقد بصفته نائبا، فان أثر العقد لا يضاف إلى الأصيل إلا إذا كان من المفروض حتما أن النائب معه أن من تعاقد معه كان يعلم بوجود النيابة، أو كان يستوي عنده أن يتعامل مع الأصيل أو النائب.$b106$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins106;

WITH ins107 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 107, 0, $h107$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h107$, $b107$إذا كان النائب ومن تعاقد معه قد جهلا معا وقت العقد انقضاء العقد الذي يبرمه، فان أثر العقد الذي يبرمه ينقضي، أو كان حقا أو التزاما، يضاف إلى الأصيل أو خلفائه أو النائب.$b107$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins107;

WITH ins108 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 108, 0, $h108$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > الرضاء$h108$, $b108$لا يجوز لشخص أن يتعاقد لنفسه باسم شخص آخر ينوب عنه، سواء أكان التعاقد لحسابه هو أم لحساب شخص آخر ترخيص من الأصيل. على أنه يجوز للأصيل في هذه الحالة أن يجيز التعاقد، كل هذا مع مراعاة ما يخالفه من قواعد التجارة.$b108$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins108;

WITH ins109 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 109, 0, $h109$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h109$, $b109$كل شخص أهل للتعاقد ما لم تسلب أهليته أو يحد منها بحكم القانون.$b109$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins109;

WITH ins110 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 110, 0, $h110$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h110$, $b110$ليس للصغير غير المميز حق التصرف في ماله وتكون جميع تصرفاته باطلة.$b110$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins110;

WITH ins111 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 111, 0, $h111$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h111$, $b111$(1) إذا كان الصبي مميزا كانت تصرفاته المالية الصحيحة متى كانت نافعة له نفعا محضا، وباطلة متى كانت ضارة ضررا محضا.
(2) أما التصرفات المالية الدائرة بين النفع والضرر، فتكون قابلة للأبطال لمصلحة القاصر، ويزول حق التمسك بالأبطال إذا أجاز القاصر التصرف بعد بلوغه سن الرشد، أو إذا صدرت الإجازة من ولية أو من المحكمة بحسب الأحوال وفقا للقانون.$b111$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins111;

WITH ins112 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 112, 0, $h112$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h112$, $b112$إذا بلغ الصبي المميز الثامنة عشرة من عمره وأذن له في تسلم أمواله لإدارتها، أو تسلمها بحكم القانون، كانت أعمال الإدارة منه صحيحة في الحدود التي رسمها القانون.$b112$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins112;

WITH ins113 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 113, 0, $h113$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h113$, $b113$المجنون والمعتوه وذو الغفلة والسفيه تحجر عليهم المحكمة، وترفع الحجر عنهم وفقا للقواعد وللإجراءات المقررة في القانون.$b113$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins113;

WITH ins114 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 114, 0, $h114$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h114$, $b114$(1) يقع باطلا تصرف المجنون والمعتوه إذا صدر التصرف بعد تسجيل قرار الحجر.
(2) أما إذا صدر التصرف قبل تسجيل قرار الحجر فلا يكون باطلا إلا إذا كانت حالة الجنون أو العته شائعة وقت التعاقد، أو كان الطرف الآخر على بينة منها.$b114$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins114;

WITH ins115 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 115, 0, $h115$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h115$, $b115$(1) إذا صدر تصرف من ذي الغفلة أو من السفيه بعد تسجيل قرار الحجر، سري على هذا التصرف ما يسري على تصرفات الصبي المميز من أحكام.
(2) أما التصرف الصادر قبل تسجيل قرار الحجر فلا يكون قابلا للأبطال، إلا إذا كان نتيجة استغلال أو تواطؤ.$b115$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins115;

WITH ins116 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 116, 0, $h116$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h116$, $b116$(1) يكون تصرف المحجور عليه لسفه أو غفلة بالوقف أو بالوصية صحيحا، متى أذنته المحكمة في ذلك.
(2) وتكون أعمال الإدارة الصادرة من المحجور عليه لسفه المأذون له في إدارة أمواله، صحيحة في الحدود التي رسمها القانون.$b116$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins116;

WITH ins117 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 117, 0, $h117$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h117$, $b117$(1) إذا كان الشخص أصم أبكم، أو أعمى أبكم، وتعذر عليه بسبب ذلك التعبير عن إرادته، جاز للمحكمة أن تعين له مساعدا قضائيا يعاونه في التصرفات التي تقتضي مصلحته فيها ذلك.
(2) ويكون قابلا للأبطال كل تصرف من التصرفات التي تقررت المساعدة القضائية فيها، متى صدر من الشخص الذي تقررت مساعدته قضائيا بغير معاونة المساعد، إذا صدر التصرف بعد تسجيل قرار المساعدة.$b117$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins117;

WITH ins118 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 118, 0, $h118$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h118$, $b118$التصرفات الصادرة من الأوصياء والقوام والإدارة، تكون صحيحة في الحدود التي رسمها القانون.$b118$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins118;

WITH ins119 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 119, 0, $h119$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h119$, $b119$يجوز لناقص الأهلية أن يطلب أبطال العقد، دون إخلال بالقواعد المتعلقة بالميراث، ما لم يتبين من العقد أو من طبيعة التعامل أو من نص القانون أن هذا الأثر لا ينصرف إلى الخلف العام.$b119$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins119;

WITH ins120 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 120, 0, $h120$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h120$, $b120$إذا وقع المتعاقد في غلط جوهري جاز له أن يطلب إبطال العقد، أن كان المتعاقد الآخر قد وقع هو أيضا في هذا الغلط، أو كان على علم به، أو كان من السهل عليه أن يتبينه.$b120$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins120;

WITH ins121 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 121, 0, $h121$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h121$, $b121$(1) يكون الغلط جوهريا إذا بلغ حدا من الجسامة بحيث يمتنع معه المتعاقد عن إبرام العقد لو لم يقع في هذا الغلط.
(2) ويعتبر الغلط جوهريا على الأخص:
(أ) إذا وقع في صفة للشيء تكون جوهرية في اعتبار المتعاقدين أو يجب اعتبارها كذلك لما يلابس العقد من ظروف ولما ينبغي في التعامل من حسن نية.
(ب) إذا وقع في ذات المتعاقد أو في صفة من صفاته، وكانت تلك الذات أو هذه الصفة السبب الرئيسي في التعاقد.$b121$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins121;

WITH ins122 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 122, 0, $h122$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h122$, $b122$يكون العقد قابلا للأبطال لغلط في القانون، إذا توافرت فيه شروط الغلط في الواقع طبقا للمادتين السابقتين، هذا ما لم يقض القانون بغير ذلك.$b122$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins122;

WITH ins123 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 123, 0, $h123$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h123$, $b123$لا يؤثر في صحة العقد مجرد الغلط في الحساب، ولكن يجب تصحيح الغلط.$b123$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins123;

WITH ins124 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 124, 0, $h124$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h124$, $b124$(1) ليس لمن وقع في غلط أن يتمسك به على وجه يتعارض مع ما يقضي به حسن النية.
(2) ويبقى العقد ملزما بالأخص بالعقد الذي قصد إبرامه، إذا أظهر الطرف الآخر استعداده لتنفيذ هذا العقد.$b124$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins124;

WITH ins125 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 125, 0, $h125$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h125$, $b125$(1) يجوز إبطال العقد للتدليس إذا كانت الحيل التي لجأ إليها أحد المتعاقدين، أو نائب عنه، من الجسامة بحيث لولا أبرمها الطرف الثاني العقد.
(2) ويعتبر تدليسا السكوت عمدا عن واقعة أو ملابسة، إذا ثبت أن المدلس عليه ما كان ليبرم العقد لو علم بتلك الواقعة أو هذه الملابسة.$b125$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins125;

WITH ins126 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 126, 0, $h126$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h126$, $b126$إذا صدر التدليس من غير المتعاقدين، فليس للمتعاقد عليه المدلس أن يطلب إبطال العقد، ما لم يثبت أن المتعاقد الآخر كان يعلم حتما بهذا التدليس.$b126$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins126;

WITH ins127 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 127, 0, $h127$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h127$, $b127$(1) يجوز إبطال العقد للإكراه إذا تعاقد شخص تحت سلطان رهبة بعثها المتعاقد الآخر في نفسه بغير حق وكانت قائمة على أساس.
(2) وتكون الرهبة قائمة على أساس إذا كانت ظروف الحال تصور للطرف الذي يدعيها أن خطرا جسيما محدقا يهدده هو أو غيره في النفس أو الجسم أو الشرف أو المال.
(3) ويراعى في تقدير جنس الإكراه من وقع عليه الإكراه وسنه وحالته الاجتماعية والصحية وكل ظرف آخر من شأنه أن يؤثر في جسامة الإكراه.$b127$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins127;

WITH ins128 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 128, 0, $h128$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h128$, $b128$إذا صدر الإكراه من غير المتعاقدين، فليس للمتعاقد المكره أن يطلب إبطال العقد، ما لم يثبت أن المتعاقد الآخر كان يعلم أو كان من المفروض حتما أن يعلم بهذا الإكراه.$b128$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins128;

WITH ins129 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 0, $h129$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h129$, $b129$(1) إذا كانت التزامات أحد المتعاقدين لا تتعادل البتة مع ما حصل عليه من فائدة بموجب العقد أو مع التزامات المتعاقد الآخر، وتبين أن المتعاقد المغبون لم يبرم العقد إلا لأن المتعاقد الآخر قد استغل فيه طيشا بينا أو هوى جامحا، جاز للقاضي بناء على طلب المتعاقد المغبون أن يبطل العقد أو ينقص التزامات هذا المتعاقد.
(2) ويجب أن ترفع الدعوى بذلك خلال سنة من تاريخ العقد، وإلا كانت غير مقبولة.
(3) ويجوز في عقود المعاوضة أن يتوقى الطرف الآخر دعوى الأبطال إذا عرض ما يراه القاضي كافيا لرفع الغبن.$b129$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins129;

WITH ins130 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 130, 0, $h130$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h130$, $b130$يراعى في تطبيق المادة السابقة عدم الإخلال بالأحكام الخاصة بالغبن في بعض العقود أو بسعر الفائدة.$b130$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins130;

WITH ins131 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 131, 0, $h131$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h131$, $b131$(1) يجوز أن يكون محل الالتزام شيئا مستقبلا.
(2) غير أن التعامل في تركة إنسان على قيد الحياة باطل ولو كان برضاه، إلا في الأحوال التي نص عليها في القانون.$b131$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins131;

WITH ins132 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 132, 0, $h132$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h132$, $b132$إذا كان محل الالتزام مستحيلا في ذاته كان العقد باطلا.$b132$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins132;

WITH ins133 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 133, 0, $h133$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h133$, $b133$(1) إذا لم يكن محل الالتزام معينا بذاته، وجب أن يكون معينا بنوعه ومقداره وإلا كان العقد باطلا.
(2) ويكفي أن يكون المحل معينا بنوعه فقط إذا تضمن العقد ا تضمن ما يستطاع به تعيين مقداره. فإذا لم يتفق المتعاقدان على درجة جودة الشيء، ولم يمكن استخلاص ذلك من العرف أو من أي ظرف آخر، التزم المدين بأن يسلم شيئا من صنف متوسط.$b133$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins133;

WITH ins134 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 134, 0, $h134$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > المحل$h134$, $b134$إذا كان محل الالتزام نقودا، التزم المدين بقدر عددها المذكور في العقد دون أن يكون لارتفاع قيمة هذه النقود أو لانخفاضها وقت الوفاء أي أثر.$b134$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins134;

WITH ins135 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 0, $h135$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > السبب$h135$, $b135$إذا كان محل الالتزام مخالفا للنظام العام أو الآداب كان العقد باطلا.$b135$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins135;

WITH ins136 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 136, 0, $h136$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > السبب$h136$, $b136$إذا لم يكن للالتزام سبب، أو كان سببه مخالفا للنظام العام أو الآداب، كان العقد باطلا.$b136$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins136;

WITH ins137 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 137, 0, $h137$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > السبب$h137$, $b137$(1) كل التزام لم يذكر له سبب في العقد يفترض أن له سببا مشروعا، ما لم يقم الدليل على غير ذلك.
(2) ويعتبر السبب المذكور في العقد هو السبب الحقيقي حتى يقوم الدليل على ما يخالف ذلك. فإذا قام الدليل على صورية السبب، فعلى من يدعي أن للالتزام سببا آخر مشروعا أن يثبت ما يدعيه.$b137$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins137;

WITH ins138 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 138, 0, $h138$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > البطلان$h138$, $b138$إذا جعل القانون لأحد المتعاقدين حقا في إبطال العقد فليس للمتعاقد الآخر أن يتمسك بهذا الحق.$b138$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins138;

WITH ins139 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 139, 0, $h139$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > البطلان$h139$, $b139$(1) يزول حق إبطال العقد بالإجازة الصريحة أو الضمنية.
(2) وتستند الإجازة إلى التاريخ الذي تم فيه العقد، دون إخلال بحقوق الغير.$b139$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins139;

WITH ins140 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 140, 0, $h140$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > البطلان$h140$, $b140$(1) يسقط الحق في إبطال العقد إذا لم يتمسك به صاحبه خلال ثلاث سنوات.
(2) ويبدأ سريان هذه المدة، في حالة نقص الأهلية، من اليوم الذي يزول فيه هذا السبب، وفي حالة الغلط أو التدليس، من اليوم الذي ينكشف فيه الغلط أو التدليس، وفي حالة الإكراه، من يوم انقطاعه، وفي كل حال لا يجوز التمسك بحق الأبطال لغبن أو تدليس أو إكراه إذا انقضت خمس عشرة سنة من وقت تمام العقد.$b140$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins140;

WITH ins141 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 141, 0, $h141$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > البطلان$h141$, $b141$(1) إذا كان العقد باطلا جاز لكل ذي مصلحة أن يتمسك بالبطلان، وللمحكمة أن تقضي به من تلقاء نفسها، ولا يزول البطلان بالإجازة.
(2) وتسقط دعوى البطلان بمضي خمس عشرة سنة من وقت العقد.$b141$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins141;

WITH ins142 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 142, 0, $h142$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > البطلان$h142$, $b142$(1) في حالتي إبطال العقد وبطلانه يعاد المتعاقدان إلى الحالة التي كانا عليها قبل العقد، فإذا كان هذا مستحيلا جاز الحكم بتعويض معادل.
(2) ومع ذلك لا يلزم ناقص الأهلية إذا أبطل العقد لنقص أهليته، أن يرد غير ما عاد عليه من منفعة بسبب تنفيذ العقد.$b142$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins142;

WITH ins143 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 143, 0, $h143$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > البطلان$h143$, $b143$إذا كان العقد باطلا منه شق باطلا أو قابلا للأبطال فهذا الشق وحده هو الذي يبطل، إلا إذا تبين أن العقد ما كان ليتم بغير الشق الذي وقع باطلا أو قابلا للأبطال فيبطل العقد كله.$b143$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins143;

WITH ins144 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 144, 0, $h144$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 1- أركان العقد > البطلان$h144$, $b144$إذا كان العقد باطلا أو قابلا للأبطال فيما اعتباره أركان أخر، فان العقد يكون صحيحا من اعتباره العقد الذي توافرت فيه أركانه، إذا تبين أن نية المتعاقدين كانت تنصرف إلى إبرام هذا العقد.$b144$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins144;

WITH ins145 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 145, 0, $h145$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h145$, $b145$يتصرف أثر العقد إلى المتعاقدين والخلف العام، دون إخلال بالقواعد المتعلقة بالميراث، ما لم يتبين من العقد أو من طبيعة التعامل أو من نص القانون أن هذا الأثر لا ينصرف إلى الخلف العام.$b145$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins145;

WITH ins146 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 146, 0, $h146$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h146$, $b146$إذا أنشأ العقد التزامات وحقوقا شخصية تتصل بشيء انتقل بعد ذلك إلى خلف خاص، فان هذه الالتزامات والحقوق تنتقل إلى هذا الخلف في الوقت الذي ينتقل فيه الشيء، إذا كانت من مستلزماته وكان الخلف الخاص يعلم بها وقت انتقال الشيء إليه.$b146$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins146;

WITH ins147 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 147, 0, $h147$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h147$, $b147$(1) العقد شريعة المتعاقدين، فلا يجوز نقضه ولا تعديله إلا باتفاق الطرفين أو للأسباب التي يقررها القانون.
(2) ومع ذلك إذا طرأت حوادث استثنائية عامة لم يكن في الوسع توقعها وترتب على حدوثها أن تنفيذ الالتزام التعاقدي، وأن لم يصبح مستحيلا، صار مرهقا للمدين بحيث يهدده بخسارة فادحة، جاز للقاضي تبعا للظروف وبعد الموازنة بين مصلحة الطرفين أن يرد الالتزام المرهق إلى الحد المعقول، ويقع باطلا كل اتفاق على خلاف ذلك.$b147$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins147;

WITH ins148 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 148, 0, $h148$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h148$, $b148$(1) يجب تنفيذ العقد طبقا لما اشتمل عليه وبطريقة تتفق مع ما يوجبه حسن النية.
(2) ولا يقتصر العقد على إلزام المتعاقد بما ورد فيه، ولكن يتناول أيضا ما هو من مستلزماته وفقا للقانون والعرف والعدالة بحسب طبيعة الالتزام.$b148$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins148;

WITH ins149 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 149, 0, $h149$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h149$, $b149$إذا تم العقد بطريق الإذعان، وكان قد تضمن شروطا تعسفية جاز للقاضي أن يعدل هذه الشروط أو أن يعفي الطرف المذعن منها، وذلك وفقا لما تقضي به العدالة. ويقع باطلا كل اتفاق على خلاف ذلك.$b149$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins149;

WITH ins150 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 150, 0, $h150$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h150$, $b150$(1) إذا كانت عبارة العقد واضحة، فلا يجوز الانحراف عنها عن طريق تفسيرها للتعرف على إرادة المتعاقدين.
(2) أما إذا كان هناك محل لتفسير العقد، فيجب البحث عن النية المشتركة للمتعاقدين دون الوقوف عند المعنى الحرفي للألفاظ، مع الاستهداء في ذلك بطبيعة التعامل، وبما ينبغي أن يتوافر من أمانة وثقة بين المتعاقدين، وفقا للعرف الجاري في المعاملات.$b150$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins150;

WITH ins151 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 151, 0, $h151$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h151$, $b151$(1) يفسر الشك في مصلحة المدين.
(2) ومع ذلك يكون تفسير العبارات الغامضة في عقود الإذعان ضارا بمصلحة الطرف المذعن.$b151$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins151;

WITH ins152 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 152, 0, $h152$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h152$, $b152$لا يرتب العقد التزاما في ذمة الغير، ولكن يجوز أن يكسبه حقا.$b152$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins152;

WITH ins153 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 153, 0, $h153$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h153$, $b153$(1) إذا تعهد شخص بأن يجعل الغير يلتزم بأمر فلا يلزم الغير بتعهده. فإذا رفض الغير أن يلتزم، وجب على المتعهد أن يعوض من تعاقد معه عن ذلك، ويجوز له أن يتخلص من ذلك بأن يقوم بنفسه بالالتزام الذي تعهد به.
(2) أما إذا قبل الغير هذا التعهد، فان قبوله لا ينتج أثرا غلا من وقت صدوره، ما لم يتبين أنه ضمنا قصد صراحة أو ضمنا أن يستند هذا القبول إلى الوقت الذي صدر فيه التعهد.$b153$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins153;

WITH ins154 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 154, 0, $h154$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h154$, $b154$(1) يجوز للشخص أن يتعاقد باسمه على التزامات يشترطها لمصلحة الغير، إذا كان له في تنفيذ هذه الالتزامات مصلحة شخصية مادية كانت أو أدبية.
(2) ويترتب على هذا الاشتراط أن يكسب المنتفع حقا مباشرا قبل المتعهد بتنفيذ الاشتراط، يستطيع أن يطالبه بوفائه، ما لم يتفق على خلاف ذلك. ويكون لهذا المنتفع أن يتمسك قبل المتعهد بالدفوع التي تنشأ عن العقد.
(3) ويجوز كذلك للمشترط أن يطالب بتنفيذ ما اشترط لمصلحة المنتفع، إلا إذا تبين أن قصد المتعاقدين انصرف إلى أن يكون من حق المنتفع وحده أن يطلب هذا التنفيذ.$b154$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins154;

WITH ins155 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 155, 0, $h155$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h155$, $b155$(1) للمشترط دون دائنيه أو ورثته أن ينقض المشارطة قبل أن يعلن المنتفع إلى المتعهد أو إلى المشترط رغبته في الاستفادة منها، ما لم يكن مخالفا لما يقتضيه العقد.
(2) ولا يترتب على نقض المشارطة أن تبرأ ذمة المتعهد قبل المشترط، إلا إذا اتفق صراحة على خلاف ذلك، وللمشترط إخلال بالانتفاع بالمشارطة لنفسه كما له أن يستأثر لنفسه بالانتفاع منتفعا آخر محل المنتفع الأول.$b155$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins155;

WITH ins156 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 156, 0, $h156$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 2- أثار العقد$h156$, $b156$يجوز في الاشتراط لمصلحة الغير أن يكون المنتفع شخصا مستقبلا أو جهة مستقبلة، كما يجوز أن يكون شخصا أو جهة لم يعينا وقت العقد، متى كانت تعيينهما مستطاعا وقت أن ينتج أثره المشارطة.$b156$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins156;

WITH ins157 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 157, 0, $h157$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 3- انحلال العقد$h157$, $b157$(1) في العقود الملزمة للجانبين، إذا لم يوف أحد المتعاقدين بالتزامه جاز للمتعاقد الآخر بعد إعذاره المدين أن يطالب بتنفيذ العقد أو بفسخه، مع التعويض في الحالتين إن كان له محل.
(2) ويجوز للقاضي أن يمنح المدين أجلا إذا اقتضت الظروف ذلك، كما يجوز له أن يرفض الفسخ إذا كان ما لم يوف به المدين قليل الأهمية بالنسبة إلى الالتزام في جملته.$b157$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins157;

WITH ins158 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 158, 0, $h158$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 3- انحلال العقد$h158$, $b158$يجوز الاتفاق على أن يعتبر العقد مفسوخا من تلقاء نفسه دون حاجة إلى حكم قضائي عند عدم الوفاء بالالتزامات الناشئة عنه، وهذا الاتفاق لا يعفي من الإعذار إلا إذا اتفق المتعاقدان صراحة على الإعفاء منه.$b158$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins158;

WITH ins159 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 159, 0, $h159$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 3- انحلال العقد$h159$, $b159$في العقود الملزمة للجانبين إذا انقضي التزام أحد المتعاقدين بسبب استحالة تنفيذه انقضت معه الالتزامات المقابلة له وينفسخ العقد من تلقاء نفسه.$b159$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins159;

WITH ins160 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 160, 0, $h160$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 3- انحلال العقد$h160$, $b160$إذا فسخ العقد أعيد المتعاقدان إلى الحالة التي كانا عليها قبل العقد، فإذا استحال ذلك جاز الحكم بالتعويض.$b160$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins160;

WITH ins161 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 161, 0, $h161$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الأول - العقد > 3- انحلال العقد$h161$, $b161$في العقود الملزمة للجانبين إذا كانت الالتزامات المتقابلة التزاما أحدهم لم يقم المتعاقد الآخر بتنفيذ ما التزم به.$b161$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins161;

WITH ins162 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 162, 0, $h162$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثانى - الإرادة المنفردة$h162$, $b162$(1) من وجه للجمهور وعدا بجائزة يعطيها نظير عمل معين التزم بإعطاء الجائزة لمن قام بهذا العمل، ولو قام به دون نظر إلى الوعد بالجائزة أو دون علم به.
(2) وإذا لم يعين الواعد أجلا للقيام بالعمل جاز للواعد الرجوع في وعده بإعلان للجمهور، على ألا يؤثر ذلك في حق من أتم من العمل قبل الرجوع في الوعد، وتسقط دعوى المطالبة بالجائزة إذا لم ترفع خلال ستة أشهر من تاريخ إعلانه العدول للجمهور.$b162$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins162;

WITH ins163 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 163, 0, $h163$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h163$, $b163$(1) كل خطأ سبب ضررا للغير يلزم من ارتكبه بالتعويض.
(2) ومع ذلك إذا وقع الضرر من شخص غير مميز ولم يكن هناك من هو مسئول عنه، جاز تعويض الضرر بتعويض عادل، مراعيا في ذلك مركز الخصوم.$b163$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins163;

WITH ins164 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 164, 0, $h164$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h164$, $b164$يكون الشخص مسئولا عن أعماله غير المشروعة متى صدرت منه وهو مميز.$b164$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins164;

WITH ins165 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 165, 0, $h165$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h165$, $b165$إذا أثبت الشخص أن الضرر قد نشأ عن سبب أجنبي لا يد له فيه، كحادث مفاجئ، أو قوة قاهرة، أو خطأ من المضرور، أو خطأ من الغير، كان غير ملزم بتعويض هذا الضرر ما لم يوجد نص أو اتفاق على غير ذلك.$b165$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins165;

WITH ins166 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 166, 0, $h166$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h166$, $b166$من أحدث ضررا وهو في حالة دفاع شرعي عن نفسه أو عن ماله أو عن نفس الغير أو ماله، كان غير مسئول، على ألا يتجاوز في دفاعه القدر الضروري، وإلا أصبح ملزما بتعويض يراعى فيه مقتضيات العدالة.$b166$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins166;

WITH ins167 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 167, 0, $h167$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h167$, $b167$لا يكون الموظف العام مسئولا عن عمله الذي اضر بالغير إذا قام بتنفيذا لأمر صدر إليه من رئيس متى كانت إطاعة هذا الأمر واجبة عليه، أو كان يعتقد أنها واجبة، وأثبت أن كان يعتقد مشروعية العمل الذي قام به مبنيا على أسباب معقولة، وانه راعي في عمله جانب الحيطة.$b167$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins167;

WITH ins168 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 168, 0, $h168$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h168$, $b168$من سبب ضررا للغير ليتفادى ضررا أكبر محدقا به أو بغيره، لا يكون ملزما بالتعويض إلا بالقدر الذي يراه القاضي مناسبا.$b168$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins168;

WITH ins169 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 169, 0, $h169$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h169$, $b169$إذا تعدد المسئولون عن عمل ضار كانوا متضامنين في التزامهم بتعويض الضرر، وتكون المسئولية فيما بينهم بالتساوي، إلا إذا عين القاضي نصيب كل منهم في التعويض.$b169$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins169;

WITH ins170 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 170, 0, $h170$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h170$, $b170$يقدر القاضي مدي التعويض عن الضرر الذي لحق المضرور طبقا لأحكام المادتين 221، 222 مراعيا في ذلك الظروف الملابسة، فان لم يتيسر له وقت الحكم أن يعين مدي التعويض تعيينا نهائيا، فله أن يحتفظ للمضرور بالحق في أن يطالب خلال مدة معينة بإعادة النظر في التقدير.$b170$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins170;

WITH ins171 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 171, 0, $h171$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h171$, $b171$(1) يعين القاضي طريقة التعويض تبعا للظروف ويصح أن يكون التعويض مقسطا كما يصح أن يكون إيرادا مرتبا، ويجوز في هاتين الحالتين إلزام المدين بأن يقدم تأمينا.
(2) ويقدر التعويض بالنقد على أنه يجوز للقاضي، تبعا للظروف وبناء على طلب المضرور، أن يأمر بإعادة الحالة إلى ما كانت عليه أو أن يحكم بأداء أمر معين متصل بالعمل غير المشروع، وذلك على سبيل التعويض.$b171$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins171;

WITH ins172 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 172, 0, $h172$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 1- المسئولية عن الأعمال الشخصية$h172$, $b172$(1) تسقط بالتقادم دعوى التعويض الناشئة عن العمل غير المشروع بانقضاء ثلاث سنوات من اليوم الذي علم فيه المضرور بحدوث الضرر وبالشخص المسئول عنه. وتسقط هذه الدعوى في كل حال، بانقضاء خمس عشرة سنة من يوم وقوع العمل غير المشروع.
(2) على أنه إذا كانت الدعوى الناشئة عن الفعل الضار جريمة، وكانت الدعوى الجنائية لم تسقط بعد انقضاء المواعيد المذكورة في الفقرة السابقة، فان دعوى التعويض لا تسقط إلا بسقوط الدعوى الجنائية.$b172$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins172;

WITH ins173 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 173, 0, $h173$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 2- المسئولية عن عمل الغير$h173$, $b173$(1) كل من يجب عليه قانونا أو اتفاقا رقابة شخص في حاجة إلى الرقابة، بسبب قصوره أو بسبب حالته العقلية أو الجسمية، يكون ملزما بتعويض الضرر الذي يحدثه ذلك الشخص للغير بعمله غير المشروع، ويترتب هذا الالتزام ولو كان من وقع منه الضرر غير مميز.
(2) ويعتبر القاصر في حاجة إلى الرقابة إذا لم يبلغ خمس عشرة سنة، أو بلغها وكان في كنف القائم على تربيته. وتنتقل الرقابة على القاصر إلى المعلم أو المشرف على الحرفة، مادام القاصر تحت إشراف المعلم أو المشرف. وتنتقل الرقابة على الزوجة القاصر إلى زوجها أو إلى من يتولى الرقابة على الزوج.$b173$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins173;

WITH ins174 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 174, 0, $h174$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 2- المسئولية عن عمل الغير$h174$, $b174$(1) يكون المتبوع مسئولا عن الضرر الذي يحدثه تابعه بعمله غير المشروع، متى كان واقعا منه في حال تأدية وظيفته أو بسببها.
(2) وتقوم رابطة التبعية ولو لم يكن المتبوع حرا في اختيار تابعه، متى كانت له عليه سلطة فعلية في رقابته وفى توجيهه.$b174$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins174;

WITH ins175 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 175, 0, $h175$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 2- المسئولية عن عمل الغير$h175$, $b175$للمسئول عن عمل الغير حق الرجوع على من هو مسئول عنه في الحدود التي يكون فيها الغير مسئولا عن تعويض الضرر.$b175$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins175;

WITH ins176 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 176, 0, $h176$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 3- المسئولية الناشئة عن الأشياء$h176$, $b176$حارس الحيوان، ولو لم يكن مالكا له، مسئول عما يحدثه الحيوان من ضرر، ولو ضل الحيوان أو تسرب، ما لم يثبت الحارس أن وقوع الحادث كان بسبب أجنبي لا يد له فيه.$b176$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins176;

WITH ins177 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 177, 0, $h177$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 3- المسئولية الناشئة عن الأشياء$h177$, $b177$(1) حارس البناء، ولو لم يكن مالكا له، مسئول عما يحدثه انهدام البناء من ضرر، ولو كان انهداما جزئيا، ما لم يثبت أن الحادث لا يرجع سببه إلى إهمال في الصيانة أو قدم في البناء أو عيب فيه.
(2) ويجوز لمن كان مهددا بضرر من مبني مصيبه من البناء أن يطالب المالك باتخاذ ما يلزم من التدابير الضرورية لدرء الخطر، فان لم يقم المالك بذلك جاز الحصول على إذن من المحكمة في اتخاذ هذه التدابير على حسابه.$b177$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins177;

WITH ins178 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 178, 0, $h178$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الثالث - العمل غير المشروع > 3- المسئولية الناشئة عن الأشياء$h178$, $b178$كل من تولى حراسة أشياء تتطلب حراستها عناية خاصة أو حراسة آلات ميكانيكية يكون مسئولا عما تحدثه هذه الأشياء من ضرر، ما لم يثبت أن وقوع الضرر كان بسبب أجنبي لا يد له فيه، هذا مع عدم الإخلال بما يرد في ذلك من أحكام خاصة.$b178$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins178;

WITH ins179 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 179, 0, $h179$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب$h179$, $b179$كل شخص، ولو غير مميز، يثري دون سبب مشروع على حساب شخص أخر يلتزم في حدود ما أثري به بتعويض هذا الشخص عما لحقه من خسارة، ويبقى هذا الالتزام قائما ولو زال الإثراء فيما بعد.$b179$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins179;

WITH ins180 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 180, 0, $h180$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب$h180$, $b180$تسقط دعوى التعويض عن الإثراء بلا سبب بانقضاء ثلاث سنوات من اليوم الذي يعلم فيه من لحقته الخسارة بحقه في التعويض، وتسقط الدعوى في جميع الأحوال بانقضاء خمس عشرة سنة من اليوم الذي ينشأ فيه هذا الحق.$b180$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins180;

WITH ins181 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 181, 0, $h181$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 1- دفع غير المستحق$h181$, $b181$(1) كل من تسلم على سبيل الوفاء ما ليس مستحقا له وجب عليه رده.
(2) على أنه لا محل للرد إذا كان من قام بالوفاء يعلم أنه غير ملزم بما دفعه، إلا أن يكون قد وقع منه تحت تأثير إكراه أو أن يكون قد دفعه وهو لا يكون ناقص الأهلية على هذا الوفاء.$b181$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins181;

WITH ins182 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 182, 0, $h182$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 1- دفع غير المستحق$h182$, $b182$يصح استرداد غير المستحق إذا كان الوفاء قد تم لالتزام لم يتحقق سببه أو زال سببه بعد أن تحقق.$b182$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins182;

WITH ins183 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 183, 0, $h183$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 1- دفع غير المستحق$h183$, $b183$(1) يصح كذلك استرداد غير المستحق، إذا كان الوفاء قد تم لالتزام لم يحل اجله وكان الموفي جاهلا قيام الأجل.
(2) على أنه لا يجوز للدائن أن يرد على ما استفاده بسبب الوفاء المعجل من حق المدين، فإذا كان الالتزام الذي لم يحل اجله نقودا، التزم الدائن الذي يرد للمدين فائدتها بسعرها القانوني أو الاتفاقي عن المدة الباقية لحلول الأجل.$b183$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins183;

WITH ins184 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 184, 0, $h184$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 1- دفع غير المستحق$h184$, $b184$لا محل لاسترداد غير المستحق إذا حصل الوفاء من غير المدين وترتب عليه أن الدائن، وهو حسن النية، قد تجرد من سند الدين، أو مما حصل عليه من التأمينات. ويلتزم المدين الحقيقي في هذه الحالة بتعويض الغير الذي قام بالوفاء.$b184$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins184;

WITH ins185 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 185, 0, $h185$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 1- دفع غير المستحق$h185$, $b185$(1) إذا كان من تسلم غير المستحق حسن النية فلا يلتزم أن يرد ما غلا ما تسلم.
(2) أما إذا كان سيئ النية فانه يلتزم أن يرد أيضا الفوائد والأرباح التي جناها أو التي قصر في جنيها من جنبها الذي تسلمه الشيء بغير حق، وذلك من يوم الوفاء غير الحق أو من اليوم الذي أصبح فيه سيئ النية.
(3) وعلى أي حال يلتزم من تسلم غير المستحق برد الفوائد والثمرات من يوم رفع الدعوى.$b185$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins185;

WITH ins186 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 186, 0, $h186$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 1- دفع غير المستحق$h186$, $b186$إذا لم تتوافر أهلية التعاقد فيمن تسلم غير المستحق فلا يكون ملتزما إلا بالقدر الذي أثري به.$b186$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins186;

WITH ins187 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 187, 0, $h187$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 1- دفع غير المستحق$h187$, $b187$تسقط دعوى استرداد ما دفع بغير حق بانقضاء ثلاث سنوات من اليوم الذي يعلم فيه من دفع غير المستحق بحقه في الاسترداد، وتسقط الدعوى كذلك في جميع الأحوال بانقضاء خمس عشرة سنة من اليوم الذي ينشأ فيه هذا الحق.$b187$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins187;

WITH ins188 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 188, 0, $h188$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h188$, $b188$الفضالة هي أن يتولى شخص قصد القيام بشان عاجل لحساب أخر، دون أن يكون ملزما بذلك.$b188$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins188;

WITH ins189 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 189, 0, $h189$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h189$, $b189$تتحقق الفضالة ولو كان الفضولي، في أثناء توليه الشأن نفسه، قد ظن توليه شان غيره، قد توالي من الشأنين لا يمكن بأحدهما القيام منفصلا عن الآخر.$b189$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins189;

WITH ins190 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 190, 0, $h190$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h190$, $b190$تسري قواعد الوكالة إذا أقر رب العمل ما قام به الفضولي.$b190$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins190;

WITH ins191 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 191, 0, $h191$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h191$, $b191$يجب على الفضولي أن يتمكن من إلى أن يتمكن رب العمل من مباشرته بنفسه، كما يجب عليه أن يخطر رب العمل بتدخله متى استطاع ذلك.$b191$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins191;

WITH ins192 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 192, 0, $h192$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h192$, $b192$(1) يجب على الفضولي أن يبذل في القيام بالعمل عناية الشخص العادي، ويكون مسئولا عن خطئه. ومع ذلك يجوز للقاضي أن ينقض التعويض المترتب على هذا الخطأ إذا كانت الظروف تبرر ذلك.
(2) وإذا عهد الفضولي إلى غيره أو ببعضه كان مسئولا عن تصرفات نائبه، دون إخلال بما لرب العمل من الرجوع على هذا النائب مباشرة.
(3) وإذا تعدد الفضوليون في القيام بعمل واحد، كانوا متضامنين في المسئولية.$b192$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins192;

WITH ins193 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 193, 0, $h193$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h193$, $b193$يلتزم الفضولي بما يلتزم به الوكيل من رد ما استولي عليه بسبب الفضالة، وبتقديم حساب عما قام به.$b193$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins193;

WITH ins194 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 194, 0, $h194$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h194$, $b194$(1) إذا مات الفضولي التزام بما يلتزم به الوكيل طبقا لأحكام المادة 717 فقرة 2.
(2) وإذا مات رب العمل بقي العمل ملتزما نحو الورثة بما كان ملتزما به نحو مورثهم.$b194$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins194;

WITH ins195 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 195, 0, $h195$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h195$, $b195$يعتبر نائبا عن رب العمل في إدارته، متى كان قد بدا في إدارته لحسابه بعناية الشخص العادي، ولو لم تتحقق النتيجة المرجوة. وفي هذه الحالة يكون العمل ملزما بان ينفذ التعهدات التي عقدها الفضولي لحسابه، وبان يعوضه عن التعهدات التي التزم بها، وبأن يرد له النفقات الضرورية والنافعة التي سوغتها الظروف مضافا إليها فوائدها من يوم دفعها، وان يعوضه الضرر الذي لحقه بسبب قيامه بالعمل إلا إذا لم يكن يستحق الفضولي أجرا على عمله من أعمال مهنته.$b195$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins195;

WITH ins196 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 196, 0, $h196$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h196$, $b196$(1) إذا لم تتوافر في الفضولي أهلية التعاقد فلا يكون مسئولا عن إدارته إلا بالقدر الذي أثري به، ما لم تكن مسئوليته ناشئة عن عمل غير مشروع.
(2) أما رب العمل فتبقي مسئوليته كاملة، ولو لم تتوافر فيه أهلية التعاقد.$b196$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins196;

WITH ins197 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 197, 0, $h197$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الرابع - الإثراء بلا سبب > 2- الفضالة$h197$, $b197$تسقط الدعوى الناشئة عن الفضالة بانقضاء ثلاث سنوات من اليوم الذي يعلم فيه كل طرف بحقه. وتسقط كذلك في جميع الأحوال بانقضاء خمس عشرة سنة من اليوم الذي ينشأ فيه هذا الحق.$b197$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins197;

WITH ins198 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 198, 0, $h198$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الأول - مصادر الالتزام > الفصل الخامس - القانون$h198$, $b198$الالتزامات التي تنشأ مباشرة عن القانون وحدة تسري عليها النصوص القانونية التي أنشأتها.$b198$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins198;

WITH ins199 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 199, 0, $h199$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h199$, $b199$(1) ينفذ الالتزام جبرا على المدين.
(2) ومع ذلك إذا كان الالتزام طبيعيا فلا جبر في تنفيذه.$b199$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins199;

WITH ins200 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 200, 0, $h200$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h200$, $b200$يقدر القاضي، عند عدم النص، ما إذا كان التزام ما يقوم التزاما طبيعيا. وفي كل حال لا يجوز أن يقوم التزام طبيعي يخالف النظام العام.$b200$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins200;

WITH ins201 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 201, 0, $h201$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h201$, $b201$لا يسترد المدين ما أداه باختياره، قاصدا أن يوفي التزاما طبيعيا.$b201$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins201;

WITH ins202 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 202, 0, $h202$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h202$, $b202$الالتزام الطبيعي الذي يصلح سببا لالتزام مدني.$b202$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins202;

WITH ins203 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 203, 0, $h203$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h203$, $b203$(1) يجبر المدين بعد أعذاره طبقا للمادتين 219، 220 على تنفيذ التزامه تنفيذا عينيا متي كان ذلك ممكنا.
(2) على أنه إذا كان في التنفيذ العيني إرهاق للمدين جاز له أن يقتصر على دفع تعويض نقدي إذا كان ذلك لا يلحق بالدائن ضررا جسيما.$b203$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins203;

WITH ins204 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 204, 0, $h204$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h204$, $b204$الالتزام بنقل الملكية أو أي حق عيني أخر ينقل من نفسه ذلك الحق متي كان محل الالتزام شيئا معينا بالذات يملكه الملتزم، وذلك دون إخلال بالقواعد المتعلقة بالتسجيل.$b204$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins204;

WITH ins205 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 205, 0, $h205$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h205$, $b205$(1) إذا ورد الالتزام بنقل حق عيني على شيء لم يعين إلا بنوعه فلا ينتقل الحق إلا بإفراز هذا الشيء.
(2) فإذا لم يقم المدين بتنفيذ التزامه، جاز للدائن أن يحصل على شيء من ذات النوع على نفقة المدين بعد استئذان القاضي في حالة الاستعجال أو دون استئذانه، كما يجوز له أن يطالب بقيمة الشيء في الحالتين، مع الإخلال بحقه في التعويض.$b205$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins205;

WITH ins206 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 206, 0, $h206$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h206$, $b206$الالتزام بنقل حق عيني يتضمن الالتزام بتسليم الشيء والمحافظة عليه حتى التسليم.$b206$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins206;

WITH ins207 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 207, 0, $h207$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h207$, $b207$(1) إذا التزم المدين أن ينقل حقا عينيا أو أن يقوم بعمل، وتضمن هذا الالتزام أن يسلم شيئا ولم يقم بتسليمه بعد أعذار، فان المدين يضمن الهلاك ولو كان بسبب أجنبي.
(2) ومع ذلك لا يكون الهلاك على المدين، إذا أثبت أن الشيء كان يهلك ولو أعذر، إذا سلم إليه الدائن كذلك لو لم يكن المدين قد تحمل تبعة الحوادث المفاجئة.
(3) على أن الشيء المسروق إذا هناك أي ضياع بأية صورة كانت تبعة الهلاك تقع على السارق.$b207$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins207;

WITH ins208 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 208, 0, $h208$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h208$, $b208$في الالتزام بعمل، إذا نص الاتفاق أو استوجبت طبيعة الالتزام الذين ينفذه المدين بنفسه جاز للدائن ألا يرضي أن يقوم بتنفيذه غير المدين.$b208$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins208;

WITH ins209 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 209, 0, $h209$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h209$, $b209$(1) في الالتزام بعمل، إذا لم يقم المدين بتنفيذه جاز للدائن أن يطلب ترخيصا في تنفيذه على نفقة المدين إذا كان هذا التنفيذ ممكنا.
(2) ويجوز في حالة الاستعجال أن ينفذ الدائن الالتزام على نفقة المدين دون ترخيص من القضاء.$b209$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins209;

WITH ins210 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 210, 0, $h210$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h210$, $b210$في الالتزام بعمل يقوم حكم القاضي مقام التنفيذ، إذا سمحت بهذا طبيعة الالتزام.$b210$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins210;

WITH ins211 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 211, 0, $h211$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h211$, $b211$(1) في الالتزام بعمل إذا كان المطلوب من المدين هو أن يحافظ على الشيء أو أن يقوم بإدارته في تنفيذ التزامه، فان المدين قد وفي بالتزامه إذا بذل في تنفيذه كل العناية التي يبذلها الشخص العادي، ولو لم يتحقق الغرض المقصود، هذا ما لم ينص القانون أو الاتفاق على غير ذلك.
(2) وفي كل حال يبقي المدين مسئولا عما يأتيه من غش أو خطأ جسيم.$b211$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins211;

WITH ins212 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 212, 0, $h212$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h212$, $b212$إذا التزم المدين بالامتناع عن عمل وأخل بهذا الالتزام، جاز للدائن أن يطلب إزالة$b212$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins212;

WITH ins213 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 213, 0, $h213$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h213$, $b213$(1) إذا كان تنفيذ الالتزام عينا غير ممكن أو غير ملائم إلا إذا قام به المدين نفسه، جاز للدائن أن يحصل على الحكم بإلزام المدين بهذا التنفيذ وبدفع غرامة تهديدية عن امتناع عن ذلك.
(2) وإذا رأى القاضى أن مقدار الغرامة ليس كافيا لإكراه المدين الممتنع عن تنفيذ جاز له أن يزيد فى الغرامة كلما رأى داعيا للزيادة.$b213$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins213;

WITH ins214 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 214, 0, $h214$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h214$, $b214$إذا تم التنفيذ العينى أو أصر المدين على رفض التنفيذ حدد القاضى مقدار التعويض الذى يلزم به المدين مراعيا فى ذلك الضرر الذى أصاب الدائن والعنت الذى بدأ من المدين.$b214$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins214;

WITH ins215 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 215, 0, $h215$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الأول - التنفيذ العينى$h215$, $b215$إذا استحال على المدين أن ينفذ الالتزام عينا حكم عليه بالتعويض لعدم الوفاء بالتزامه، ما لم يثبت أن استحالة التنفيذ قد نشأت عن سبب أجنبى لا يد له فيه. ويكون الحكم كذلك إذا تأخر المدين فى تنفيذ التزامه.$b215$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins215;

WITH ins216 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 216, 0, $h216$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h216$, $b216$يجوز للقاضى أن ينقض مقدار التعويض أو ألا يحكم بتعويض ما إذا كان الدائن بخطئه قد اشترك فى إحداث الضرر أو زاد فيه.$b216$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins216;

WITH ins217 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 217, 0, $h217$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h217$, $b217$(1) يجوز الاتفاق على أن يتحمل المدين تبعة الحادث المفاجئ والقوة القاهرة.
(2) وكذلك يجوز الاتفاق على إعفاء المدين من أية مسئولية تترتب على عدم تنفيذ التزامه التعاقدى إلا ما ينشأ عن غشه أو عن خطئه الجسيم، ومع ذلك يجوز للمدين أن يشترط عدم مسئوليته عن الغش أو الخطأ الجسيم الذى يقع من أشخاص يستخدمهم فى تنفيذ التزامه.
(3) ويقع باطلا كل شرط يقضى بالإعفاء من المسئولية المترتبة على العمل غير المشروع.$b217$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins217;

WITH ins218 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 218, 0, $h218$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h218$, $b218$لا يستحق التعويض إلا بعد إعذار المدين، ما لم ينص على غير ذلك.$b218$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins218;

WITH ins219 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 219, 0, $h219$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h219$, $b219$يكون إعذار المدين بإنذاره أو بما يقوم مقام الإنذار، ويجوز أن يتم الإعذار عن طريق البريد المبين فى قانون المرافعات، كما يجوز أن يكون مرتبا على اتفاق يقضى بأن يكون المدين معذورا بمجرد حلول الأجل دون حاجة إلى أى إجراء آخر.$b219$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins219;

WITH ins220 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 220, 0, $h220$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h220$, $b220$لا ضرورة لإعذار المدين فى الحالات الآتية:
(أ) إذا أصبح تنفيذ الالتزام غير ممكن أو غير مجد بفعل المدين.
(ب) إذا كان محل الالتزام تعويضا يترتب على عمل غير مشروع.
(جـ) إذا كان محل الالتزام رد شيء يعلم المدين أنه مسروق أو شيء تسلمه دون حق بذلك.
(د) إذا صرح المدين كتابة أنه لا يريد القيام بالتزامه.$b220$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins220;

WITH ins221 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 221, 0, $h221$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h221$, $b221$(1) إذا لم يكن التعويض مقدرا فى العقد أو بنص فى القانون، فالقاضى هو الذى يقدره، ويشمل التعويض ما لحق الدائن من خسارة وما فاته من كسب، بشرط أن يكون هذا نتيجة طبيعية لعدم الوفاء بالالتزام أو للتأخر فى الوفاء به، ويعتبر الضرر نتيجة طبيعية إذا لم يكن فى استطاعة الدائن أن يتوقاه ببذل جهد معقول.
(2) ومع ذلك إذا كان الالتزام مصدره العقد، فلا يلزم المدين الذى لم يرتكب غشا أو خطأ جسيما إلا بتعويض الضرر الذى كان يمكن توقعه عادة وقت التعاقد.$b221$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins221;

WITH ins222 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 222, 0, $h222$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h222$, $b222$(1) يشمل التعويض الضرر الأدبى أيضا، ولكن لا يجوز فى هذه الحالة أن ينتقل إلى الغير إلا إذا تحدد بمقتضى اتفاق أو طالب به الدائن أمام القضاء.
(2) ومع ذلك يكون الحكم بتعويض الأزواج والأقارب إلى الدرجة الثانية عما يصيبهم من ألم من جراء موت المصاب.$b222$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins222;

WITH ins223 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 223, 0, $h223$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h223$, $b223$يجوز للمتعاقدين أن يحددا مقدما قيمة التعويض بالنص عليها فى العقد أو فى اتفاق لاحق، ويراعى فى هذه الحالة أحكام المواد من 215 إلى 220.$b223$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins223;

WITH ins224 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 224, 0, $h224$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h224$, $b224$(1) لا يكون التعويض الاتفاقى مستحقا إذا أثبت المدين أن الدائن لم يلحقه أى ضرر.
(2) ويجوز للقاضى أن يخفض هذا التعويض إذا أثبت المدين أن التقدير كان مبالغا فيه إلى درجة كبيرة، أو أن الالتزام الأصلى قد نفذ فى جزء منه.
(3) ويقع باطلا كل اتفاق يخالف أحكام الفقرتين السابقتين.$b224$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins224;

WITH ins225 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 225, 0, $h225$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h225$, $b225$إذا جاوز الضرر قيمة التعويض الاتفاقى فلا يجوز للدائن أن يطالب بأكثر من هذه القيمة إلا إذا أثبت أن المدين قد ارتكب غشا أو خطأ جسيما.$b225$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins225;

WITH ins226 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 226, 0, $h226$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h226$, $b226$إذا كان محل الالتزام مبلغا من النقود وكان المقدار معلوم وقت الطلب وتأخر المدين فى الوفاء به، كان ملزما بأن يدفع للدائن على سبيل التعويض عن التأخر فوائد قدرها أربعة فى المائة فى المسائل المدنية وخمسة فى المائة فى المسائل التجارية. وتسرى هذه الفوائد من تاريخ المطالبة القضائية بها، ما لم يحدد الاتفاق أو العرف التجارى تاريخا آخر لسريانها، وهذا كله ما لم ينص القانون على غير ذلك.$b226$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins226;

WITH ins227 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 227, 0, $h227$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h227$, $b227$(1) يجوز للمتعاقدين أن يتفقا على سعر آخر للفوائد سواء أكان ذلك فى مقابل تأخير الوفاء أم فى أية حالة أخرى، فإذا اتفقا على فوائد تزيد على سبعة فى المائة وجب تخفيضها إلى هذا القدر.
(2) وكل عمولة أو منفعة، أيا كان نوعها، اشترطها الدائن إذا زادت والفائدة المتفق عليه على الحد الأقصى تعتبر مستترة فائدة ربوية وتكون قابلة للتخفيض، إذا ما أثبت أن هذه العمولة أو المنفعة لا تقابلها خدمة حقيقية يكون الدائن قد أداها ولا منفعة مشروعة.$b227$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins227;

WITH ins228 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 228, 0, $h228$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h228$, $b228$لا يشترط لاستحقاق الفوائد التأخيرية قانونية كانت أو اتفاقية أن يثبت الدائن أن هذا التأخير لحقه ضرر من هذا التأخير.$b228$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins228;

WITH ins229 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 229, 0, $h229$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h229$, $b229$إذا تسبب الدائن، بسوء نية، فى إطالة أمد النزاع فللقاضى أن يخفض الفوائد القانونية كانت أو اتفاقية أو لا يقضى بها إطلاقا عن المدة التى طال فيها النزاع بلا مبرر.$b229$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins229;

WITH ins230 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 230, 0, $h230$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h230$, $b230$عند توزيع ثمن الشىء بيع جبرا لا يكون للتوزيع المقبولون من الدائنين المستحقين بعد رسوم المزاد لفوائد تأخير عن الأنصبة التى تقررت لهم فى هذا التوزيع إلا إذا كان الراسى عليه هذا التوزيع ملزما بدفع فوائد الثمن، أو كانت خزانة المحكمة ملزمة بهذه الفوائد بسبب إيداع الثمن فيها، على ألا يتجاوز ما يتقاضاه من الدائنين من فوائد فى هذه الحالة ما هو مستحق منها على الراسى عليه المزاد أو خزانة المحكمة. وهذه الفوائد تقسم بين الدائنين جميعا قسمة غرماء.$b230$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins230;

WITH ins231 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 231, 0, $h231$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h231$, $b231$يجوز للدائن أن يطالب بتعويض تكميلى يضاف إلى الفوائد إذا أثبت أن الضرر الذى تسبب فيه المدين الذى فيه بسوء نية جاوز الفوائد المذكورة.$b231$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins231;

WITH ins232 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 232, 0, $h232$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h232$, $b232$لا يجوز تقاضى فوائد على متجمد الفوائد، ولا يجوز فى أية حال أن يكون مجموع ما يتقاضاه الدائن أكثر من رأس المال وذلك كله دون إخلال بالقواعد والعادات التجارية.$b232$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins232;

WITH ins233 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 233, 0, $h233$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثانى - التنفيذ بطريق التعويض$h233$, $b233$الفوائد التجارية التى تسرى على الحساب الجارى يختلف سعرها باختلاف الجهات القانونية، ويتبع فى طريقة حساب الفوائد المركبة فى الحساب الجارى ما يقضى به العرف التجارى.$b233$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins233;

WITH ins234 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 234, 0, $h234$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان$h234$, $b234$(1) أموال المدين جميعها ضامنة للوفاء بديونه.
(2) وجميع الدائنين متساوون فى هذا الضمان إلا من كان منهم له حق التقدم طبقا للقانون.$b234$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins234;

WITH ins235 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 235, 0, $h235$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h235$, $b235$(1) لكل دائن لم يكن حقه مستحق الأداء أن يستعمل باسم مدينه جميع حقوق هذا المدين إلا ما كان منها خاصة بشخصه أو غير قابل للحجز.
(2) ولا يكون استعمال الدائن لحقوق مدينه مقبولا إلا إذا أثبت أن المدين لم يستعمل هذه الحقوق وأن عدم استعماله لها من شأنه أن يسبب إعساره أو أن يزيد فى هذا الإعسار، ولا يشترط إعذار المدين لاستعمال هذا الحق ولكن يجب إدخاله خصما فى الدعوى.$b235$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins235;

WITH ins236 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 236, 0, $h236$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h236$, $b236$يعتبر الدائن فى استعماله حقوق مدينه نائبا عن هذا المدين، وكل فائدة تنتج من استعمال هذه الحقوق تدخل فى أموال المدين وتكون ضمانا لجميع دائنيه.$b236$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins236;

WITH ins237 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 237, 0, $h237$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h237$, $b237$لكل دائن أصبح حقه مستحق الأداء، وصدر من مدينه تصرف ضار، أن يطلب عدم نفاذ هذا التصرف فى حقه، إذا كان التصرف قد أنقص من حقوق المدين أو زاد فى التزاماته وترتب عليه إعساره أو زيادة إعساره، وذلك متى توافرت الشروط المنصوص عليها فى المادة التالية.$b237$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins237;

WITH ins238 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 238, 0, $h238$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h238$, $b238$(1) إذا كان تصرف المدين بعوض، اشترط لعدم نفاذه فى حق الدائن أن يكون منطويا على غش، وأن يكون من صدر له التصرف قد علم بهذا الغش، ويكفى لاعتبار التصرف منطويا على الغش أن يكون قد صدر من المدين وهو عالم أنه معسر.
(2) أما إذا كان التصرف تبرعا، فإنه لا ينفذ فى حق الدائن ولو كان من صدر له التبرع حسن النية ولم يثبت أن المدين لم يرتكب غشا.
(3) وإذا كان الخلف الذى انتقل إليه الشىء محل التصرف قد تصرف فيه بعوض إلى خلف آخر، فلا يصح للدائن عدم نفاذ التصرف الثانى إلا إذا كان الخلف الثانى يعلم غش المدين، وعلم الخلف الأول بهذا الغش، إن كان المدين قد تصرف بعوض، وإن كان هذا الخلف الثانى يعلم وقت إعسار المدين وقت تصرف الخلف الأول للخلف الثانى إن كان المدين قد تصرف له تبرعا.$b238$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins238;

WITH ins239 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 239, 0, $h239$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h239$, $b239$إذا أدعى الدائن إعسار المدين فليس عليه إلا أن يثبت مقدار ما له فى ذمة المدين من ديون، وعلى المدين نفسه أن يثبت أن له مالا يساوى قيمة الديون أو يزيد عليها.$b239$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins239;

WITH ins240 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 240, 0, $h240$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h240$, $b240$متى تقرر عدم نفاذ التصرف استفاد من ذلك جميع الدائنين الذين صدر هذا التصرف أضرارا بهم.$b240$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins240;

WITH ins241 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 241, 0, $h241$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h241$, $b241$إذا كان من تلقى حقا من المدين المعسر لم يدفع ثمنه، فإنه يتخلص من الدعوى متى كان هذا الثمن مثلا، وقام بإيداعه خزانة المحكمة.$b241$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins241;

WITH ins242 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 242, 0, $h242$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h242$, $b242$(1) إذا لم يقصد بالغش إلا تفضيل دائن على آخر دون حق، فلا يترتب عليه إلا حرمان الدائن من هذه الميزة.
(2) وإذا وفى المدين المعسر أحد دائنيه قبل انقضاء الأجل الذى عين أصلا للوفاء، فإن هذا الوفاء لا يسرى فى حق باقى الدائنين، وكذلك لا يسرى إذا حصل بعد انقضاء هذا الأجل، إذا كان قد تم نتيجة تواطؤ مع الدائن الذى استوفى.$b242$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins242;

WITH ins243 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 243, 0, $h243$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h243$, $b243$تسقط بالتقادم دعوى عدم نفاذ التصرف بانقضاء ثلاث سنوات من اليوم الذى يعلم فيه الدائن بسبب عدم نفاذ التصرف وتسقط فى جميع الأحوال بانقضاء خمس عشرة سنة من الوقت الذى صدر فيه التصرف المطعون فيه.$b243$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins243;

WITH ins244 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 244, 0, $h244$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h244$, $b244$(1) إذا أبرم عقد صورى فلدائنى المتعاقدين وللخلف الخاص، متى كانوا حسنى النية، أن يتمسكوا بالعقد الصورى، كما أن لهم أن يتمسكوا بالعقد المستتر ويثبتوا صورية العقد الذى أضر بهم بجميع الوسائل.
(2) وإذا تعارضت مصالح ذوى الشأن فتمسك بعضهم بالعقد الظاهر وتمسك الآخرون بالعقد المستتر، كانت الأفضلية للأولين.$b244$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins244;

WITH ins245 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 245, 0, $h245$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 1- وسائل التنفيذ$h245$, $b245$إذا ستر المتعاقدان عقدا حقيقيا بعقد ظاهر، فالعقد النافذ فيما بين المتعاقدين والخلف العام هو العقد الحقيقى.$b245$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins245;

WITH ins246 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 246, 0, $h246$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 2- إحدى وسائل الضمان : الحق فى الحبس$h246$, $b246$(1) لكل من التزم بأداء شىء أن يمتنع عن الوفاء به، مادام الدائن لم يعرض الوفاء بالتزامه المترتب على التزام المدين ومرتبط به، أو مادام الدائن لم يقم بتقديم تأمين كاف للوفاء بالتزامه هذا.
(2) ويكون ذلك بوجه خاص لحائز الشىء محرزة أو إذا هو أنفق عليه مصروفات ضرورية أو نافعة، فإن له أن يمتنع عن رد هذا الشىء حتى يستوفى ما هو مستحق له، إلا أن يكون الالتزام بالرد ناشئا عن عمل غير مشروع.$b246$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins246;

WITH ins247 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 247, 0, $h247$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 2- إحدى وسائل الضمان : الحق فى الحبس$h247$, $b247$(1) مجرد الحق فى حبس الشىء لا يثبت حق امتياز عليه.
(2) وعلى الحابس أن يحافظ على الشىء وفقا لأحكام الرهن الحيازى وعليه أن يقدم حسابا عن غلته.
(3) وإذا كان الشىء المحبوس يخشى عليه الهلاك أو التلف، فللحابس أن يحصل على إذن من القضاء فى بيعه وفقا للأحكام المنصوص عليها فى المادة 119، وينتقل الحق فى الحبس إلى الشىء من الثمن.$b247$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins247;

WITH ins248 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 248, 0, $h248$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 2- إحدى وسائل الضمان : الحق فى الحبس$h248$, $b248$(1) ينقضى الحق فى الحبس بخروج الشىء من يد حائزه أو محرزه.
(2) ومع ذلك لا يجوز لحابس الشىء، إذا خرج الشىء من يده خفية أو بالرغم من معارضته، أن يطلب استرداده، إذا هو قام بهذا الطلب خلال ثلاثين يوما من الوقت الذى علم فيه بخروج الشىء من يده وقبل انقضاء سنة من وقت خروجه.$b248$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins248;

WITH ins249 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 249, 0, $h249$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h249$, $b249$يجوز أن يشهر إعسار المدين إذا كانت أمواله لا تكفى لوفاء ديونه المستحقة الأداء.$b249$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins249;

WITH ins250 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 250, 0, $h250$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h250$, $b250$يكون شهر الإعسار بحكم تصدره المحكمة الابتدائية التى يتبعها موطن المدين، بناء على طلب المدين نفسه أو أحد دائنيه، وتنظر الدعوى على وجه السرعة.$b250$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins250;

WITH ins251 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 251, 0, $h251$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h251$, $b251$على المحكمة فى كل حال، قبل أن تشهر إعسار المدين، أن تراعى فى تقديرها جميع الظروف التى أحاطت به، سواء أكانت هذه الظروف عامة أم خاصة. فتنظر إلى موارده المستقبلة ومقدرته الشخصية ومسئوليته عن الأسباب التى أدت إلى إعساره، ومصالح دائنيه، وكل ظرف آخر من شأنه أن يؤثر فى حالته المالية.$b251$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins251;

WITH ins252 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 252, 0, $h252$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h252$, $b252$مدة المعارضة فى الأحكام الصادرة فى شأن الإعسار ثمانية أيام، ومدة استئنافها خمسة عشر يوما، تبدأ من تاريخ إعلان تلك الأحكام.$b252$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins252;

WITH ins253 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 253, 0, $h253$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h253$, $b253$(1) على كاتب المحكمة فى اليوم الذى تقيد فيه دعوى الإعسار أن يسجل صحيفتها فى سجل خاص يرتب بحسب أسماء المعسرين، وعليه أيضا أن يؤشر فى هامش التسجيل المذكور بالحكم الصادر فى الدعوى، وذلك كله يوم صدور الحكم أو بإبلاغه.
(2) وعلى الكاتب أيضا أن يرسل إلى قلم كتاب محكمة مصر صورة من هذه التسجيلات لإثباتها فى سجل عام، ينظم وفقا لقرار يصدر من وزير العدل.$b253$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins253;

WITH ins254 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 254, 0, $h254$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h254$, $b254$يجب على المدين إذا تغير موطنه أن يخطر بذلك كاتب المحكمة التى يتبعها موطنه السابق، وعلى هذا الكاتب بمجرد علمه بتغير الموطن، سواء أخطره المدين أم علم ذلك من أى طريق آخر، أن يرسل على نفقة المدين صورة من محضر شهر الإعسار ومن البيانات المؤشر بها فى هامش التسجيل إلى المحكمة الجديدة المتبعة التى يقوم لتقيدها فى سجلاتها.$b254$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins254;

WITH ins255 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 255, 0, $h255$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h255$, $b255$(1) يترتب على الحكم بشهر الإعسار أن يحل كل ما فى ذمة المدين من ديون مؤجلة. ويخصم من هذه الديون مقدار الفائدة الاتفاقية أو القانونية عن المدة التى سقطت بسقوط الأجل.
(2) ومع ذلك يجوز للقاضى أن يحكم، بناء على طلب المدين وفى مواجهة ذوى الشأن من دائنيه، بإبقاء الأجل أو مدة بالنسبة إلى الديون المؤجلة، كما له أن يمنح المدين أجلا جديدا بالنسبة إلى الديون الحالة، إذا رأى أن هذا الإجراء تبرره الظروف، وأنه خير وسيلة تكفل مصالح المدين والدائنين جميعا.$b255$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins255;

WITH ins256 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 256, 0, $h256$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h256$, $b256$(1) لا يحول شهر الإعسار دون اتخاذ الدائنين إجراءات فردية ضد المدين.
(2) على أنه لا يجوز على الدائنين الذين لم يكن لهم حقوق سابقة على تسجيل صحيفة دعوى الإعسار أن يحتجوا بحقوق كان لهم على عقارات يقع فى اختصاص المحكمة بعد هذا التسجيل.$b256$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins256;

WITH ins257 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 257, 0, $h257$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h257$, $b257$متى سجلت صحيفة دعوى الإعسار فلا يسرى فى حق دائنى المدين أى تصرف من شأنه أن ينقص من حقوقه أو يزيد فى التزاماته، كما لا يسرى فى حقهم أى وفاء يقوم به المدين.$b257$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins257;

WITH ins258 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 258, 0, $h258$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h258$, $b258$(1) يجوز للمدين أن يتصرف فى ماله، ولو بغير رضاء الدائنين، على أن يكون ذلك بثمن المثل، وأن يقوم المشترى بإيداع الثمن خزانة المحكمة حتى يوزع وفقا لإجراءات التوزيع.
(2) فإذا كان الثمن الذى يبيع به المال أقل من ثمن المثل، كان التصرف غير سار فى حق الدائنين، إلا إذا أودع المشترى الثمن الذى اشترى به فوق ثمن المثل.$b258$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins258;

WITH ins259 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 259, 0, $h259$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h259$, $b259$إذا أوقع الدائنون الحجز على إيرادات المدين، كان لرئيس المحكمة المختصة بشهر الإعسار، بناء على عريضة يقدمها المدين، أن يقرر للمدين نفقة يتقاضاها من إيراداته المحجوزة، ويجوز التظلم من الأمر الذى يصدر على هذه العريضة، فى مدة ثلاثة أيام من تاريخ صدوره، إن كان التظلم من المدين، ومن تاريخ إعلان الأمر إن كان التظلم ممن سواه.$b259$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins259;

WITH ins260 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 260, 0, $h260$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h260$, $b260$يعاقب المدين بعقوبة التبديد فى الحالتين الآتيتين:
(أ) إذا رفعت عليه دعوى فتعمد الإعسار بقصد الإضرار بدائنيه، وانتهت الدعوى بصدور حكم عليه بالدين وشهر إعساره.
(ب) إن كان بعد الحكم بشهر إعساره أخفى بعض أمواله ليحول دون التنفيذ عليها، أو اصطنع ديونا صورية أو مبالغا فيها، وذلك كله بقصد الإضرار بدائنيه.$b260$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins260;

WITH ins261 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 261, 0, $h261$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h261$, $b261$(1) تنتهى حالة الإعسار بحكم تصدره المحكمة الابتدائية التى يتبعها موطن المدين، بناء على طلب ذى شأن فى الحالتين الآتيتين:
(أ) متى ثبت أن ديون المدين أصبحت لا تزيد على أمواله.
(ب) متى قام المدين بوفاء ديونه التى حلت بسبب شهر إعساره. وفى هذه الحالة تعود آجال الديون التى حلت دون أن يكون لشهر الإعسار أثر فى حلولها إلى ما كانت عليه من قبل وفقا للمادة 263.
(2) ويؤشر كاتب المحكمة من تلقاء نفسه بالحكم الصادر بإنهاء حالة الإعسار بجانب صدوره على هامش التسجيل المنصوص عليه فى المادة 253، وعليه أن يرسل منه صورة إلى قلم كتاب محكمة مصر للتأشير به كذلك.$b261$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins261;

WITH ins262 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 262, 0, $h262$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h262$, $b262$تنتهى حالة الإعسار بقوة القانون متى انقضت خمس سنوات على تاريخ التأشير بالحكم الصادر بشهر الإعسار.$b262$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins262;

WITH ins263 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 263, 0, $h263$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h263$, $b263$يجوز للمدين بعد إنهاء حالة الإعسار أن يطلب إعادة الديون التى كانت قد حلت بسبب شهر الإعسار ولم يتم دفعها إلى آجالها السابق تحديدها قبل أن تكون قد حلت، وذلك دون الديون التى حلت دون أن يكون لشهر الإعسار أثر فى حلولها.$b263$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins263;

WITH ins264 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 264, 0, $h264$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثانى - آثار الالتزام > الفصل الثالث - ما يكفل حقوق الدائنين من وسائل تنفيذ ووسائل ضمان > 3- الإعسار$h264$, $b264$إنهاء حالة الإعسار بقوة القانون أو بحكم القضاء لا يمنع الدائنين من الطعن فى تصرفات المدين، ولا من التمسك باستعمال حقوقه وفقا للمواد من 235 إلى 243.$b264$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins264;

WITH ins265 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 265, 0, $h265$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 1- الشرط$h265$, $b265$يكون الالتزام معلقا على شرط إذا كان وجوده أو زواله مرتبا على أمر مستقبل غير محقق الوقوع.$b265$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins265;

WITH ins266 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 266, 0, $h266$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 1- الشرط$h266$, $b266$(1) لا يكون الالتزام قائما إذا علق على شرط غير ممكن أو على شرط مخالف للآداب أو النظام العام. أما إذا كان الشرط فاسخا فهو الذى يعتبر غير قائم.
(2) ومع ذلك لا يقوم الالتزام الذى يعلق على شرط فاسخ مخالف للآداب أو النظام العام، إذا كان هذا الشرط هو السبب الدافع للالتزام.$b266$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins266;

WITH ins267 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 267, 0, $h267$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 1- الشرط$h267$, $b267$لا يكون الالتزام قائما إذا علق على شرط واقف يجعل وجود الالتزام متوقفا على محض إرادة الملتزم.$b267$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins267;

WITH ins268 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 268, 0, $h268$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 1- الشرط$h268$, $b268$إذا كان الالتزام معلقا على شرط واقف، فلا يكون نافذا إلا إذا تحقق الشرط. أما قبل تحقق الشرط، فلا يكون الالتزام قابلا للتنفيذ القهري ولا للتنفيذ الاختياري، على أنه يجوز للدائن أن يتخذ من الإجراءات ما يحافظ به على حقه.$b268$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins268;

WITH ins269 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 269, 0, $h269$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 1- الشرط$h269$, $b269$(1) يترتب على تحقق الشرط الفاسخ زوال الالتزام ويكون الدائن ملزما برد ما أخذه، فإذا استحال الرد لسبب هو مسئول عنه وجب عليه التعويض.
(2) على أن أعمال الإدارة التى تصدر من الدائن نافذة تبقى رغم تحقق الشرط.$b269$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins269;

WITH ins270 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 270, 0, $h270$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 1- الشرط$h270$, $b270$(1) إذا تحقق الشرط استند أثره إلى الوقت الذى نشأ فيه الالتزام، إلا إذا تبين من إرادة المتعاقدين أو من طبيعة العقد أن وجود الالتزام، أو زواله، إنما يكون فى الوقت الذى تحقق فيه الشرط.
(2) ومع ذلك لا يكون للشرط أثر رجعى، إذا أصبح تنفيذ الالتزام قبل تحقق الشرط غير ممكن لسبب لا يد للمدين فيه.$b270$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins270;

WITH ins271 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 271, 0, $h271$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 2- الأجل$h271$, $b271$(1) يكون الالتزام لأجل إذا كان نفاذه أو انقضاؤه مرتبا على أمر مستقبل محقق الوقوع.
(2) ويعتبر الأمر محققا متى كان وقوعه محتما، ولو لم يعرف الوقت الذى يقع فيه.$b271$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins271;

WITH ins272 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 272, 0, $h272$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 2- الأجل$h272$, $b272$إذا تبين من الالتزام أن المدين لا يقوم بوفائه إلا عند المقدرة، عين القاضى ميعادا مناسبا لحلول الأجل، مراعيا فى ذلك موارد المدين الحالية والمستقبلة، ومقتضيا عناية الرجل الحريص على الوفاء بالتزامه.$b272$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins272;

WITH ins273 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 273, 0, $h273$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 2- الأجل$h273$, $b273$يسقط حق المدين فى الأجل:
(1) إذا شهر إفلاسه أو إعساره وفقا لنصوص القانون.
(2) إذا أضعف بفعله إلى حد كبير أى تأمين خاص، ولو كان هذا التأمين قد أعطى بعقد لاحق أو بمقتضى القانون، هذا ما لم يؤثر الدائن أن يطالب بتكملة التأمين، إذا كان إضعاف التأمين يرجع إلى سبب لا دخل لإرادة المدين فيه، فإن الأجل يسقط ما لم يقدم المدين ضمانا كافيا.
(3) إذا لم يقدم للدائن ما وعد به فى العقد من التأمينات.$b273$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins273;

WITH ins274 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 274, 0, $h274$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الأول - الشرط والأجل > 2- الأجل$h274$, $b274$(1) إذا كان الالتزام مقترنا بأجل واقف، فإنه لا يكون نافذا إلا فى الوقت الذى ينقضى فيه الأجل، على أنه لا يجوز للدائن حتى قبل انقضاء الأجل أن يتخذ من الإجراءات ما يحافظ به على حقوقه، وله بوجه خاص أن يطالب بتأمين إذا يخشى إفلاس المدين أو إعساره واستند فى ذلك إلى سبب معقول.
(2) ويترتب على انقضاء الأجل الفاسخ زوال الالتزام، دون أن يكون لهذا الزوال أثر رجعى.$b274$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins274;

WITH ins275 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 275, 0, $h275$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثانى - تعدد محل الالتزام > 1- الالتزام التخييرى$h275$, $b275$يكون الالتزام تخييريا إذا شمل محله أشياء متعددة تبرأ ذمة المدين براءة تامة إذا أدى واحد منها، ويكون الخيار للمدين ما لم ينص القانون أو يتفق المتعاقدان على غير ذلك.$b275$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins275;

WITH ins276 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 276, 0, $h276$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثانى - تعدد محل الالتزام > 1- الالتزام التخييرى$h276$, $b276$(1) إذا كان الخيار للمدين وامتنع عن الاختيار أو تعدد المدينون ولم يتفقوا فيما بينهم، جاز للدائن أن يطلب من القاضى أجل تعيين يختار فيه المدين أو المدينون الدين، فإذا لم يتم ذلك تولى القاضى بنفسه تعيين محل الالتزام.
(2) أما إذا كان الخيار للدائن وامتنع عن الاختيار أو تعدد الدائنون ولم يتفقوا فيما بينهم، عين القاضى أجلا لذلك، فإذا انقضى الأجل ولم يتم الاختيار انتقل الخيار إلى المدين.$b276$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins276;

WITH ins277 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 277, 0, $h277$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثانى - تعدد محل الالتزام > 1- الالتزام التخييرى$h277$, $b277$إذا كان الخيار للمدين، ثم استحال تنفيذ كل من الأشياء المتعددة التى اشتمل عليها محل الالتزام، وكان المدين مسئولا عن هذه الاستحالة ولو فيما يتعلق بواحدة من هذه الأشياء كان ملزما بأن يدفع قيمة شيء آخر استحال تنفيذه.$b277$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins277;

WITH ins278 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 278, 0, $h278$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثانى - تعدد محل الالتزام > 2- الالتزام البدلى$h278$, $b278$(1) يكون الالتزام بديليا إذا لم يشمل محله إلا شيئا واحدا، ولكن تبرأ ذمة المدين إذا أدى بدلا منه شيئا آخر.
(2) والشيء الذى يشمله محل الالتزام البديل الذى تبرأ المدين بأدائه هو وحده الذى يتعين به الالتزام وهو الذى يتعين طبيعته.$b278$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins278;

WITH ins279 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 279, 0, $h279$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h279$, $b279$التضامن بين الدائنين أو بين المدينين لا يفترض، وإنما يكون بناء على اتفاق أو نص فى القانون.$b279$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins279;

WITH ins280 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 280, 0, $h280$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h280$, $b280$(1) إذا كان التضامن بين الدائنين، جاز للمدين أن يوفى الدين لأى منهم، إلا إذا كان هناك مانع من ذلك.
(2) ومع ذلك لا يحول التضامن دون انقسام الدين بين ورثة أحد الدائنين المتضامنين، إلا إذا كان الدين غير قابل للانقسام.$b280$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins280;

WITH ins281 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 281, 0, $h281$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h281$, $b281$(1) يجوز للدائنين المتضامنين، مجتمعين أو منفردين، مطالبة المدين بالوفاء، ويراعى فى ذلك ما يلحق رابطة كل دائن من وصف من أثر الدين.
(2) ولا يجوز للمدين إذا طالبه أحد الدائنين المتضامنين بالوفاء أن يحتج على هذا الدائن بأوجه الدفع الخاصة بغيره من الدائنين، ولكن يجوز له أن يحتج على الدائن المطالب بأوجه الدفع الخاصة بهذا الدائن، وبأوجه الدفع المشتركة بين الدائنين جميعا.$b281$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins281;

WITH ins282 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 282, 0, $h282$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h282$, $b282$(1) إذا برئت ذمة المدين قبل أحد الدائنين المتضامنين بسبب غير الوفاء، فلا تبرأ ذمته قبل باقى الدائنين إلا بقدر حصة الدائن الذى برئت ذمته قبله.
(2) ولا يجوز لأحد الدائنين المتضامنين أن يأتى عملا من شأنه الإضرار بالدائنين الآخرين.$b282$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins282;

WITH ins283 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 283, 0, $h283$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h283$, $b283$(1) كل ما يستوفيه أحد الدائنين المتضامنين من الدين يصير من حق الدائنين جميعا ويتحاصون فيه.
(2) وتكون القسمة بينهم بالتساوى، إلا إذا وجد اتفاق أو نص يقضى بغير ذلك.$b283$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins283;

WITH ins284 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 284, 0, $h284$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h284$, $b284$إذا كان التضامن بين المدينين فإن وفاء أحدهم بالدين تبرأ به ذمة الباقين.$b284$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins284;

WITH ins285 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 285, 0, $h285$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h285$, $b285$(1) يجوز للدائن مطالبة المدينين المتضامنين بالدين مجتمعين أو منفردين، ويراعى فى ذلك ما يلحق رابطة كل مدين من وصف من أثر الدين.
(2) ولا يجوز للمدين الذى يطالبه الدائن بالوفاء أن يحتج بأوجه الدفع الخاصة بغيره من المدينين، ولكن يجوز له أن يحتج بأوجه الدفع الخاصة به وبالأوجه المشتركة بين المدينين جميعا.$b285$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins285;

WITH ins286 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 286, 0, $h286$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h286$, $b286$يترتب على تجديد الدين بين الدائن وأحد المدينين المتضامنين أن تبرأ ذمة المدينين الباقين إلا إذا احتفظ الدائن بحقه قبلهم.$b286$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins286;

WITH ins287 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 287, 0, $h287$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h287$, $b287$لا يجوز للمدين المتضامن أن يتمسك بالمقاصة التى تقع بين الدائن ومدين متضامن آخر، إلا بقدر حصة هذا المدين.$b287$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins287;

WITH ins288 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 288, 0, $h288$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h288$, $b288$إذا اتحدت الذمة بين الدائن وأحد مدينيه المتضامنين، فإن الدين لا ينقضى بالنسبة إلى باقى المدينين، إلا بقدر حصة المدين الذى اتحدت ذمته مع الدائن.$b288$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins288;

WITH ins289 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 289, 0, $h289$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h289$, $b289$(1) إذا أبرأ الدائن أحد المدينين المتضامنين فلا تبرأ ذمة الباقين إلا بما يبقى من الدين بعد خصم حصة المدين الذى أبرأ، إلا أن يكون قد صرح الدائن بذلك.
(2) فإذا لم يصدر منه هذا التصريح، لم يكن له أن يطالب باقى المدينين المتضامنين إلا بما يبقى من الدين بعد خصم حصة المدين الذى أبرأه، إلا أن يكون قد احتفظ بحقه فى الرجوع بهذه الحصة على باقى المدينين، وفى هذه الحالة يكون لهم حق الرجوع على المدين الذى صدر الإبراء لصالحه بحصته فى الدين.$b289$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins289;

WITH ins290 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 290, 0, $h290$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h290$, $b290$إذا أبرأ الدائن أحد المدينين المتضامنين من التضامن بقى حقه فى الرجوع على الباقين بكل الدين، ما لم يتفق على غير ذلك.$b290$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins290;

WITH ins291 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 291, 0, $h291$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h291$, $b291$(1) فى جميع الأحوال التى يبرئ فيها الدائن أحد المدينين المتضامنين من الإبراء، سواء أكان الإبراء من الدين أم من التضامن، يكون لباقى المدينين أن يرجعوا عند الاقتضاء على هذا المدين بنصيبه مما يصيبهم من حصة المدين المعسر وفقا للمادة 298.
(2) على أنه إذا أخلى الدائن المدين الذى أبرأه من كل مسئولية عن الدين، فإن هذا الدائن هو الذى يتحمل نصيب هذا المدين فى حصة المدين المعسر.$b291$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins291;

WITH ins292 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 292, 0, $h292$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h292$, $b292$(1) إذا انقضى الدين بالتقادم بالنسبة إلى أحد المدينين المتضامنين، فلا يفيد ذلك باقى المدينين إلا بقدر حصة هذا المدين.
(2) وإذا انقطعت مدة التقادم أو وقف سريانها بالنسبة إلى أحد المدينين المتضامنين، فلا يجوز للدائن أن يتمسك بذلك قبل باقى المدينين.$b292$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins292;

WITH ins293 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 293, 0, $h293$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h293$, $b293$(1) لا يكون المدين المتضامن مسئولا فى تنفيذ الالتزام إلا عن فعله.
(2) وإذا أعذر الدائن أحد المدينين المتضامنين أو قاضاه، فلا يكون لذلك أثر بالنسبة إلى باقى المدينين. أما إذا أعذر أحد المدينين الدائن، فإن المدينين المتضامنين يستفيدون من هذا الإعذار.$b293$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins293;

WITH ins294 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 294, 0, $h294$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h294$, $b294$إذا تصالح الدائن مع أحد المدينين المتضامنين وتضمن الصلح الإبراء من الدين أو براءة الذمة منه بأية وسيلة أخرى، استفاد منه الباقون. أما إذا كان من شأن هذا الصلح أن يرتب فى ذمتهم التزاما يزيد فيما هم ملتزمون به، فإنه لا ينفذ فى حقهم إلا إذا قبلوه.$b294$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins294;

WITH ins295 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 295, 0, $h295$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h295$, $b295$(1) إذا أقر أحد المدينين المتضامنين بالدين، فلا يسرى هذا الإقرار فى حق الباقين.
(2) وإذا نكل أحد المدينين المتضامنين عن اليمين أو وجه إلى الدائن يمينا وحلفها، فلا يضار بذلك باقى المدينين.
(3) وإذا اقتصر الدائن على توجيه اليمين إلى أحد المدينين المتضامنين فحلف، فإن المدينين الآخرين يستفيدون من ذلك.$b295$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins295;

WITH ins296 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 296, 0, $h296$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h296$, $b296$(1) إذا صدر حكم على أحد المدينين المتضامنين، فلا يحتج بهذا الحكم على الباقين.
(2) أما إذا صدر الحكم لصالح أحدهم، فيستفيد منه الباقون إلا إذا كان الحكم مبنيا على سبب خاص بالمدين الذى صدر لصالحه الحكم.$b296$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins296;

WITH ins297 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 297, 0, $h297$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h297$, $b297$(1) إذا وفى أحد المدينين المتضامنين كل الدين، فلا يجوز له أن يرجع على أى من الباقين إلا بقدر حصته فى الدين، ولو كان له من حق الحلول ما له من دعوى الدائن.
(2) وينقسم الدين إذا وفاه أحد المدينين حصصا متساوية بين الجميع، ما لم يوجد اتفاق أو نص يقضى بغير ذلك.$b297$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins297;

WITH ins298 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 298, 0, $h298$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h298$, $b298$إذا أعسر أحد المدينين المتضامنين تحمل تبعة هذا الإعسار المدين الذى وفى بالدين وباقى المدينين الموسرين، كل بقدر حصته.$b298$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins298;

WITH ins299 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 299, 0, $h299$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 1- التضامن$h299$, $b299$إذا كان أحد المدينين المتضامنين هو وحده صاحب المصلحة فى الدين، فهو الذى يتحمله كله نحو الباقين.$b299$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins299;

WITH ins300 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 300, 0, $h300$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 2- عدم القابلية للانقسام$h300$, $b300$يكون الالتزام غير قابل للانقسام:
(أ) إذا ورد على محل لا يقبل بطبيعته أن ينقسم.
(ب) إذا تبين من الغرض الذى رمى إليه المتعاقدان أن الالتزام لا يجوز تنفيذه منقسما، أو إذا انصرفت نية المتعاقدين إلى ذلك.$b300$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins300;

WITH ins301 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 301, 0, $h301$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 2- عدم القابلية للانقسام$h301$, $b301$(1) إذا تعدد المدينون فى التزام غير قابل للانقسام كان كل منهم ملزما بوفاء الدين كاملا.
(2) وللمدين الذى وفى بالدين الرجوع على الباقين، كل بقدر حصته إلا إذا تبين من الظروف غير ذلك.$b301$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins301;

WITH ins302 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 302, 0, $h302$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الثالث - الأوصاف المعدلة لأثر الالتزام > الفصل الثالث - تعدد طرفى الالتزام > 2- عدم القابلية للانقسام$h302$, $b302$(1) إذا تعدد الدائنون فى التزام غير قابل للانقسام أو تعدد ورثة الدائن فى هذا الالتزام، جاز لكل دائن أو وارث أن يطالب بأداء الالتزام كاملا، فإذا اعترض أحد الدائنين أو الورثة على ذلك، كان المدين ملزما بأداء الالتزام للدائنين مجتمعين أو إيداع الشيء محل الالتزام.
(2) ويرجع الدائنون على الدائن الذى استوفى الالتزام، كل بقدر حصته.$b302$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins302;

WITH ins303 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 303, 0, $h303$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h303$, $b303$يجوز للدائن أن يحول حقه إلى شخص آخر، إلا إذا حال دون ذلك نص فى القانون أو اتفاق المتعاقدين أو طبيعة الالتزام. وتتم الحوالة دون حاجة إلى رضاء المدين.$b303$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins303;

WITH ins304 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 304, 0, $h304$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h304$, $b304$لا تجوز حوالة الحق إلا بمقدار ما يكون منه قابلا للحجز.$b304$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins304;

WITH ins305 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 305, 0, $h305$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h305$, $b305$لا تكون الحوالة نافذة قبل المدين أو قبل الغير إلا إذا قبلها المدين أو أعلن بها. على أن نفاذها قبل الغير لا يستلزم قبول المدين بهذا القبول.$b305$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins305;

WITH ins306 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 306, 0, $h306$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h306$, $b306$يجوز قبل إعلان الحوالة أو قبولها أن يتخذ الدائن المحال له من الإجراءات ما يحافظ به على الحق الذى انتقل إليه.$b306$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins306;

WITH ins307 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 307, 0, $h307$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h307$, $b307$تشمل حوالة الحق ضماناته، كالكفالة والرهن والامتياز، كما تعتبر شاملة لما حل من فوائد وأقساط.$b307$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins307;

WITH ins308 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 308, 0, $h308$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h308$, $b308$(1) إذا كانت الحوالة بعوض فلا يضمن المحيل إلا وجود الحق المحال به وقت الحوالة، ما لم يوجد اتفاق يقضى بغير ذلك.
(2) أما إذا كانت الحوالة بغير عوض، فلا يكون المحيل ضامنا حتى لوجود الحق.$b308$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins308;

WITH ins309 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 309, 0, $h309$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h309$, $b309$(1) لا يضمن المحيل يسار المدين إلا إذا وجد اتفاق خاص على هذا الضمان.
(2) وإذا ضمن المحيل يسار المدين، فلا ينصرف هذا الضمان إلى اليسار وقت الحوالة ما لم يتفق على غير ذلك.$b309$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins309;

WITH ins310 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 310, 0, $h310$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h310$, $b310$إذا رجع المحال له بالضمان على المحيل طبقا للمادتين السابقتين، فلا يلزم المحيل إلا برد ما استولاه من المحال له مع الفوائد والمصروفات، ولو وجد اتفاق يقضى بغير ذلك.$b310$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins310;

WITH ins311 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 311, 0, $h311$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h311$, $b311$يكون المحيل مسئولا عن أفعاله الشخصية، ولو كانت الحوالة بغير عوض أو اشترط عدم الضمان.$b311$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins311;

WITH ins312 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 312, 0, $h312$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h312$, $b312$للمحال عليه أن يتمسك قبل المحال له بالدفوع التى كان له أن يتمسك بها قبل المحيل وقت نفاذ الحوالة فى حقه، كما يجوز له أن يتمسك بالدفوع المستمدة من عقد الحوالة.$b312$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins312;

WITH ins313 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 313, 0, $h313$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h313$, $b313$إذا تعددت الحوالة بحق واحد فضلت الحوالة التى تصبح نافذة قبل غيرها فى حق الغير.$b313$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins313;

WITH ins314 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 314, 0, $h314$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الأول - حوالة الحق$h314$, $b314$(1) إذا وقع تحت يد المحال عليه حجز قبل أن تصبح الحوالة نافذة فى حق الغير، كانت الحوالة بالنسبة إلى الحاجز بمثابة حجز آخر.
(2) وفى هذه الحالة، إذا وقع حجز آخر بعد أن أصبحت الحوالة نافذة فى حق الغير، فإن الدين يقسم بين الحاجز المتقدم والمحال له فضلت الحوالة المتأخر، على أن يؤخذ من حصة الحاجز المتأخر ما يستكمل به المحال له قيمة الحوالة.$b314$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins314;

WITH ins315 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 315, 0, $h315$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الثانى - حوالة الدين$h315$, $b315$تتم حوالة الدين باتفاق المدين وشخص آخر يتحمل الدين.$b315$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins315;

WITH ins316 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 316, 0, $h316$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الثانى - حوالة الدين$h316$, $b316$(1) لا تكون الحوالة نافذة فى حق الدائن إلا إذا أقرها.
(2) وإذا قام المحال عليه أو المدين الأصلى بإعلان الحوالة إلى الدائن، وعين له أجلا معقولا ليقر الحوالة ثم انقضى الأجل دون أن يصدر الإقرار، اعتبر سكوت الدائن رفضا للحوالة.$b316$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins316;

WITH ins317 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 317, 0, $h317$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الثانى - حوالة الدين$h317$, $b317$(1) مادام الدائن لم يحدد موقفه من الحوالة إقرارا أو رفضا، كان المحال عليه ملزما قبل المدين الأصلى بالوفاء للدائن فى الوقت المناسب ما لم يوجد اتفاق يقضى بغير ذلك ويسرى هذا الحكم ولو رفض الدائن الحوالة.
(2) على أنه لا يجوز للمدين الأصلى أن يطالب المحال عليه بالوفاء للدائن، مادام هو لم يقم بما التزم به نحو المحال عليه بمقتضى عقد الحوالة.$b317$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins317;

WITH ins318 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 318, 0, $h318$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الثانى - حوالة الدين$h318$, $b318$(1) تبقى للدين المحال به ضماناته.
(2) ومع ذلك لا يبقى الكفيل، عينيا كان أو شخصيا، ملتزما قبل المحال له إلا إذا رضى بالحوالة.$b318$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins318;

WITH ins319 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 319, 0, $h319$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الثانى - حوالة الدين$h319$, $b319$يضمن المدين الأصلى أن يكون المحال عليه موسرا وقت إقرار الدائن الحوالة، ما لم يتفق على غير ذلك.$b319$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins319;

WITH ins320 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 320, 0, $h320$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الثانى - حوالة الدين$h320$, $b320$للمحال عليه أن يتمسك قبل الدائن بالدفوع التى كان للمدين الأصلى أن يتمسك بها، كما يجوز له أن يتمسك بالدفوع المستمدة من عقد الحوالة.$b320$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins320;

WITH ins321 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 321, 0, $h321$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الثانى - حوالة الدين$h321$, $b321$(1) يجوز أيضا أن تتم حوالة الدين باتفاق بين الدائن والمحال عليه، يتقرر فيه أن هذا المحال عليه يحل محل المدين الأصلى فى التزامه.
(2) وتسرى فى هذه الحالة أحكام المادتين 318، 320.$b321$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins321;

WITH ins322 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 322, 0, $h322$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الرابع - انتقال الالتزام > الفصل الثانى - حوالة الدين$h322$, $b322$(1) لا يتبع بيع العقار المرهون رهنا رسميا انتقال الدين المضمون بالرهن إلى ذمة المشترى إلا إذا كان هناك اتفاق على ذلك.
(2) فإذا اتفق البائع والمشترى على حوالة الدين، وسجل عقد البيع، وتعين على الدائن متى أعلن رسميا بالحوالة أن يقرها أو يرفضها فى ميعاد لا يجاوز ستة أشهر، فإذا انقضى هذا الميعاد دون صدور إقرار أو رفض، اعتبر سكوته إقرارا.$b322$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins322;

WITH ins323 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 323, 0, $h323$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h323$, $b323$(1) يصح الوفاء من المدين أو من نائبه أو من أى شخص آخر له مصلحة فى الوفاء، وذلك مع مراعاة ما جاء بالمادة 208.
(2) ويصح الوفاء أيضا ممن ليست له مصلحة فى هذا الوفاء، ولو كان ذلك دون علم المدين أو رغم إرادته، على أنه يجوز للدائن أن يرفض الوفاء من الغير إذا اعترض المدين على ذلك وأبلغ الدائن هذا الاعتراض.$b323$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins323;

WITH ins324 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 324, 0, $h324$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h324$, $b324$(1) إذا قام الغير بوفاء الدين، كان له الحق فى الرجوع على المدين بقدر ما دفعه.
(2) ومع ذلك للمدين الذى حصل الوفاء بغير إرادته أن يمنع رجوع الموفى بما وفاه عنه كلا أو بعضا، إذا أثبت أن له أية مصلحة فى الاعتراض على الوفاء.$b324$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins324;

WITH ins325 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 325, 0, $h325$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h325$, $b325$(1) يشترط لصحة الوفاء أن يكون الموفى مالكا للشيء الذى وفى به، وأن يكون ذا أهلية للتصرف فيه.
(2) ومع ذلك فالوفاء بالشيء المستحق ممن ليس أهلا للتصرف فيه ينقضى به الالتزام، إذا لم يلحق الوفاء ضررا بالموفى.$b325$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins325;

WITH ins326 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 326, 0, $h326$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h326$, $b326$إذا قام بالوفاء شخص غير المدين، حل الموفى محل الدائن الذى استوفى حقه فى الأحوال الآتية:
(أ) إذا كان الموفى ملزما بالدين مع المدين أو ملزما بوفائه عنه.
(ب) إذا كان الموفى دائنا وفى دائنا آخر مقدما عليه بما له من تأمين عينى، ولو لم يكن للموفى أى تأمين.
(ج) إذا كان الموفى قد اشترى عقارا ودفع ثمنه وفاء لدائنين خصص العقار لضمان حقوقهم.
(د) إذا كان هناك نص خاص يقرر الحلول للموفى.$b326$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins326;

WITH ins327 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 327, 0, $h327$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h327$, $b327$للدائن الذى استوفى حقه من غير المدين أن يتفق مع هذا الغير على أن يحل هذا الغير محله، ولو لم يقبل المدين ذلك، ولا يصح أن يتأخر هذا الاتفاق عن وقت الوفاء.$b327$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins327;

WITH ins328 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 328, 0, $h328$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h328$, $b328$يجوز أيضا للمدين إذا اقترض مالا ليفى به الدين أن يحل المقرض محل الدائن الذى استوفى حقه، ولو بغير رضاء هذا الدائن، على أن يذكر فى عقد القرض أن المال قد خصص للوفاء، وفى المخالصة أن الوفاء كان من هذا المال الذى أقرضه الدائن الجديد.$b328$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins328;

WITH ins329 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 329, 0, $h329$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h329$, $b329$من حل قانونا أو اتفاقا محل الدائن كان له لهذا الحق من خصائص وما يلحقه من توابع، وما يكلفه من تأمينات، وما يرد عليه من دفوع، ويكون هذا الحلول بالقدر الذى أداه من ماله من حل محل الدائن.$b329$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins329;

WITH ins330 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 330, 0, $h330$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h330$, $b330$(1) إذا وفى الغير الدائن جزءا من حقه وحل محله فيه، فلا يضار الدائن بهذا الوفاء، ويكون له فى استيفاء ما بقى له من حق مقدما على من حل محله فى الوفاء، ما لم يوجد اتفاق يقضى بغير ذلك.
(2) فإذا حل شخص آخر محل الدائن فيما بقى له من حق رجع كل أخيرا هو ومن تقدمه فى الحلول كل بقدر ما هو مستحق له وتقاسما قسمة الغرماء.$b330$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins330;

WITH ins331 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 331, 0, $h331$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h331$, $b331$إذا وفى حائز العقار المرهون كل الدين، فلا يحل محل الدائنين، ويحل محل الدائنين بمقتضى هذا الحلول أن يرجع على أى دائن آخر لعقار مرهون فى ذات الدين إلا بقدر حصة هذا الدين بحسب قيمة ما حازه من عقار.$b331$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins331;

WITH ins332 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 332, 0, $h332$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h332$, $b332$يكون الوفاء للدائن أو لنائبه. ويعتبر ذا صفة فى استيفاء الدين من يقدم للمدين مخالصة صادرة من الدائن، إلا إذا كان متفقا على أن الوفاء للدائن يكون للدائن شخصيا.$b332$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins332;

WITH ins333 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 333, 0, $h333$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h333$, $b333$إذا كان الوفاء لشخص غير الدائن أو نائبه، فلا تبرأ ذمة المدين إلا إذا أقر الدائن هذا الوفاء أو عادت عليه هذه المنفعة، وبقدر هذه المنفعة، أو تم الوفاء بحسن نية لشخص كان الدين فى حيازته.$b333$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins333;

WITH ins334 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 334, 0, $h334$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h334$, $b334$إذا رفض الدائن دون مبرر قبول الوفاء المعروض عليه عرضا صحيحا، أو رفض القيام بالأعمال التى لا يتم الوفاء بدونها، أو أعلن أنه لن يقبل الوفاء، اعتبر أنه قد تم إعذاره من الوقت الذى يسجل المدين عليه هذا الرفض بإعلان رسمى.$b334$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins334;

WITH ins335 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 335, 0, $h335$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h335$, $b335$إذا تم إعذار الدائن، تحمل تبعة هلاك الشيء أو تلفه، وأصبح للمدين الحق فى إيداع الشيء على نفقة الدائن ومطالبته بتعويض ما أصابه من ضرر.$b335$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins335;

WITH ins336 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 336, 0, $h336$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h336$, $b336$إذا كان محل الوفاء شيئا معينا بالذات، وكان الواجب أن يسلم فى المكان الذى يوجد فيه، جاز للمدين أن ينذر الدائن بأن يتسلمه إذا كان الدائن لا يريد تسلمه، فإذا كان هذا الشيء عقارا أو شيئا معدا للبقاء حيث وجد، جاز للمدين أن يطلب وضعه تحت الحراسة.$b336$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins336;

WITH ins337 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 337, 0, $h337$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h337$, $b337$(1) يجوز للمدين بعد استئذان القضاء أن يبيع بالمزاد العلنى الأشياء التى يسرع إليها التلف، أو التى تكلف نفقات باهظة فى إيداعها أو حراستها، وأن يودع الثمن خزانة المحكمة.
(2) فإذا كان الشىء له سعر معروف فى الأسواق، أو كان التعامل فيه متداولا فى البورصات فلا يجوز بيعه بالمزاد إلا إذا تعذر البيع بسعر ممارسة بالسعر المعروف.$b337$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins337;

WITH ins338 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 338, 0, $h338$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h338$, $b338$يكون الإيداع أو ما يقوم مقامه من إجراء جائز أيضا، إذا كان المدين يجهل شخصية الدائن أو موطنه، أو كان الدائن عديم الأهلية ولم يناقصها من ناب عنه، أو لم يكن له نائب يقبل عنه الوفاء، أو كان الدين متنازعا عليه بين عدة أشخاص، أو كانت هناك أسباب جدية أخرى تبرر هذا الإجراء.$b338$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins338;

WITH ins339 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 339, 0, $h339$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h339$, $b339$يقوم العرض الحقيقى بالنسبة إلى المدين مقام الوفاء، إذا تلاه إيداع يتم وفقا لأحكام قانون المرافعات، أو تلاه أى إجراء مماثل، وذلك إذا قبله الدائن أو صدر حكم نهائى بصحته.$b339$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins339;

WITH ins340 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 340, 0, $h340$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 1- طرفا الوفاء$h340$, $b340$(1) إذا عرض المدين الدين واتبع العرض بإيداع أو بإجراء مماثل، جاز له أن يرجع فى هذا العرض مادام الدائن لم يقبله، أو مادام لم يصدر حكم نهائى بصحته، وإذا رجع فلا تبرأ ذمة شركائه فى الدين ولا ذمة الضامنين.
(2) فإذا رجع المدين فى العرض بعد أن قبله الدائن، أو بعد أن حكم بصحته، ولم يتمسك هذا الدائن الذى لم يتمسك بما يكفل حقه من تأمينات وتبرأ ذمة الشركاء والضامنين.$b340$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins340;

WITH ins341 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 341, 0, $h341$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 2- محل الوفاء$h341$, $b341$الشيء المستحق أصلا هو الذى يكون الوفاء به، فلا يجبر الدائن على قبول شىء غيره، ولو كان هذا الشيء مساويا له فى القيمة أو كانت له قيمة أعلى.$b341$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins341;

WITH ins342 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 342, 0, $h342$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 2- محل الوفاء$h342$, $b342$(1) لا يجوز للمدين أن يجبر الدائن على أن يقبل وفاء جزئيا لحقه، ما لم يوجد اتفاق أو نص يقضى بغير ذلك.
(2) فإذا كان الدين متنازعا فى جزء منه وقبل الدائن أن يستوفى الجزء المعترف به، فليس للمدين أن يرفض الوفاء بهذا الجزء.$b342$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins342;

WITH ins343 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 343, 0, $h343$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 2- محل الوفاء$h343$, $b343$إذا كان المدين ملزما بأن يوفى مع الدين مصروفات وفوائد، وكان ما أداه لا يفى بالدين مع هذه الملحقات، خصم ما أدى من حساب المصروفات ثم من الفوائد ثم من أصل الدين، كل هذا ما لم يتفق على غيره.$b343$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins343;

WITH ins344 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 344, 0, $h344$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 2- محل الوفاء$h344$, $b344$إذا تعددت الديون فى ذمة المدين، وكانت لدائن واحد ومن جنس واحد، وكان ما أداه المدين لا يفى بهذه الديون جميعا، جاز للمدين عند الوفاء أن يعين الدين الذى يريد الوفاء به، ما لم يوجد مانع قانونى أو اتفاقى يحول دون هذا التعيين.$b344$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins344;

WITH ins345 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 345, 0, $h345$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 2- محل الوفاء$h345$, $b345$إذا لم يعين الدين على الوجه المبين فى المادة السابقة، كان الخصم من حساب الدين الذى حل، فإذا تعددت الديون الحالة فمن حساب أشدها كلفة على المدين، فإذا تساوت الديون فى الكلفة فمن حساب الدين الذى يعينه الدائن.$b345$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins345;

WITH ins346 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 346, 0, $h346$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 3- وقت الوفاء ومكانه$h346$, $b346$(1) يجب أن يتم الوفاء فورا بمجرد ترتب الالتزام فى ذمة المدين نهائيا، ما لم يوجد اتفاق أو نص يقضى بغير ذلك.
(2) على أنه يجوز للقاضى فى حالات استثنائية، إذا لم يمنعه نص فى القانون، أن ينظر المدين إلى أجل أو أن ينفذ التزامه فيها إذا استدعت حالته ذلك ولم يلحق الدائن من هذا التأجيل ضرر جسيم.$b346$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins346;

WITH ins347 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 347, 0, $h347$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 3- وقت الوفاء ومكانه$h347$, $b347$(1) إذا كان محل الالتزام شيئا معينا بالذات وجب تسليمه فى المكان الذى كان موجودا فيه وقت نشوء الالتزام، ما لم يقض اتفاق أو نص بغير ذلك.
(2) أما فى الالتزامات الأخرى فيكون الوفاء فى المكان الذى يوجد فيه موطن المدين وقت الوفاء، أو فى المكان الذى يوجد فيه مركز أعمال المدين إذا كان الالتزام متعلقا بهذه الأعمال.$b347$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins347;

WITH ins348 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 348, 0, $h348$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 3- وقت الوفاء ومكانه$h348$, $b348$تكون نفقات الوفاء على المدين إلا إذا وجد اتفاق أو نص يقضى بغير ذلك.$b348$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins348;

WITH ins349 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 349, 0, $h349$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الأول - الوفاء > 3- وقت الوفاء ومكانه$h349$, $b349$(1) لمن قام بوفاء جزء من دينه من المدين أن يطلب مخالصة بما استوفاه مع التأشير على سند الدين، فإذا كان الدين كله أن يطلب رد سند الدين أو إلغاءه، فإن كان السند قد ضاع كان له أن يطلب من الدائن أن يقر كتابة بضياع السند.
(2) فإذا رفض الدائن القيام بما فرضته عليه الفقرة السابقة جاز للمدين أن يودع الشيء المستحق إيداعا قضائيا.$b349$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins349;

WITH ins350 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 350, 0, $h350$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 1- الوفاء بمقابل$h350$, $b350$إذا قبل الدائن فى استيفاء حقه مقابلا استعاض به عن الشيء المستحق قام هذا المقام مقام الوفاء.$b350$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins350;

WITH ins351 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 351, 0, $h351$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 1- الوفاء بمقابل$h351$, $b351$يسرى على الوفاء بمقابل، فيما إذا كان ينقل ملكية شيء أعطى مقابلة فى الدين، أحكام البيع، وبالأخص ما يتعلق منه بأهلية المتعاقدين وضمان الاستحقاق وضمان العيوب الخفية. ويسرى عليه من حيث أنه يقضى أحكام الوفاء، وبالأخص ما يتعلق منها بتعيين جهة الدفع وانقضاء التأمينات.$b351$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins351;

WITH ins352 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 352, 0, $h352$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h352$, $b352$يتجدد الالتزام:
(أولا) بتغيير الدين إذ اتفق الطرفان على أن يستبدلا بالالتزام الأصلى التزاما جديدا يختلف عنه جيدا فى محله أو فى مصدره.
(ثانيا) بتغيير المدين إذا اتفق الدائن مع أجنبى على أن يكون هذا الأجنبى مدينا مكان المدين الأصلى وعلى أن تبرأ ذمة المدين الأصلى دون رضائه، أو إذا حصل المدين على رضاء الدائن بشخص أجنبى يكون هو المدين الجديد.
(ثالثا) بتغيير الدائن إذا اتفق الدائن والمدين وأجنبى على أن يكون هذا الأجنبى هو الدائن الجديد.$b352$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins352;

WITH ins353 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 353, 0, $h353$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h353$, $b353$(1) لا يتم التجديد إلا إذا كان الالتزامان القديم والجديد قد خلا كل منهما من أسباب البطلان.
(2) أما إذا كان الالتزام القديم ناشئا عن عقد قابل للإبطال، فلا يكون التجديد صحيحا إلا إذا قصد بالالتزام الجديد إجازة العقد القديم، وإن يحل محله.$b353$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins353;

WITH ins354 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 354, 0, $h354$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h354$, $b354$(1) التجديد لا يفترض، بل يجب أن يتفق عليه صراحة، أو أن يستخلص بوضوح من الظروف.
(2) وبوجه خاص لا يستفاد التجديد من سند كتابة بدين سند موجود قبل ذلك، ولا مما يحدث فى الالتزام من تغيير يتناول زمان الوفاء أو مكانه أو كيفيته، ولا مما يدخل على الالتزام من تعديل لا يتناول إلا التأمينات أو سعر الفائدة، كل هذا ما لم يوجد اتفاق يقضى بغيره.$b354$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins354;

WITH ins355 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 355, 0, $h355$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h355$, $b355$(1) لا يكون تجديدا مجرد تقييد الالتزام فى حساب جار.
(2) وإنما يتحدد الالتزام إذا قطع رصيد الحساب وتم إقراره، على أنه إذا كان الالتزام مكفولا بتأمين خاص، فإن هذا التأمين يبقى ما لم يتفق على غير ذلك.$b355$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins355;

WITH ins356 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 356, 0, $h356$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h356$, $b356$(1) يترتب على التجديد أن ينقضى الالتزام الأصلى بتوابعه وينشأ محله التزام جديد.
(2) ولا ينتقل إلى الالتزام الجديد التأمينات التى كانت تكفل الالتزام الأصلى إلا إذا نص على ذلك فى العقد أو اقتضاه النص فى القانون، أو إلا إذا تبين من الاتفاق أو من الظروف أن نية المتعاقدين قد انصرفت إلى ذلك.$b356$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins356;

WITH ins357 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 357, 0, $h357$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h357$, $b357$(1) إذا كانت هناك تأمينات عينية قدمها المدين الأصلى لكفالة الالتزام الأصلى، فإن الاتفاق على نقل هذه التأمينات إلى الالتزام الجديد تراعى فيه الأحكام الآتية:
(أ) إذا كان التجديد بتغيير الدين، جاز للدائن والمدين أن يتفقا على انتقال التأمينات للالتزام الجديد فى الحدود التى لا تلحق ضررا بالغير.
(ب) إذا كان التجديد بتغيير المدين، جاز للدائن والمدين الجديد أن يتفقا على استبقاء التأمينات العينية، دون حاجة إلى رضاء المدين القديم.
(جـ) إذا كان التجديد بتغيير الدائن، جاز للمتعاقدين ثلاثتهم أن يتفقوا على استبقاء التأمينات.
(2) ولا يكون الاتفاق على نقل التأمينات العينية نافذا فى حق الغير إلا إذا تم مع التجديد فى وقت واحد، هذا مع مراعاة الأحكام المتعلقة بالتسجيل.$b357$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins357;

WITH ins358 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 358, 0, $h358$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h358$, $b358$لا ينتقل إلى الالتزام الجديد الكفالة عينية كانت أو شخصية ولا التضامن، إلا إذا رضى بذلك الكفلاء والمدينون المتضامنون.$b358$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins358;

WITH ins359 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 359, 0, $h359$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h359$, $b359$(1) تتم الإنابة إذا حصل المدين على رضاء الدائن بشخص أجنبى يلتزم أجنبى بوفاء الدين مكان المدين.
(2) ولا تقتضى الإنابة أن تكون هناك مديونية سابقة ما بين المدين والأجنبى.$b359$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins359;

WITH ins360 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 360, 0, $h360$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h360$, $b360$(1) إذا اتفق المتعاقدون فى الإنابة على أن يستبدلوا بالالتزام سابق التزاما جديدا، كانت هذه الإنابة تجديدا للالتزام بتغيير المدين، ويترتب عليها أن تبرأ ذمة المنيب قبل المناب لديه، على أن يكون الالتزام الجديد الذى التزم به المناب صحيحا وإلا يكون المناب معسرا وقت الإنابة.
(2) ومع ذلك لا يفترض التجديد فى الإنابة، فإذا لم يكن هناك اتفاق على التجديد قام الالتزام الجديد إلى جانب الالتزام الأول.$b360$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins360;

WITH ins361 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 361, 0, $h361$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 2- التجديد والإنابة$h361$, $b361$يكون الالتزام المناب قبل المناب لديه صحيحا ولو كان التزامه قبل المنيب باطلا أو كان هذا الالتزام خاضعا لدفوع من الدفوع التى كانت له قبل المنيب، ولا يبقى للمناب إلا حق الرجوع على المنيب، كل هذا ما لم يوجد اتفاق يقضى بغيره.$b361$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins361;

WITH ins362 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 362, 0, $h362$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 3- المقاصة$h362$, $b362$(1) للمدين حق المقاصة بين ما هو مستحق عليه لدائنه وما هو مستحق له قبل هذا الدائن، ولو اختلف سبب الدينين، إذا كان موضوع كل منهما مثليات متحدة فى النوع والجودة وكان كل منهما خاليا من النزاع مستحق الأداء، صالحا للمطالبة به قضاء.
(2) ولا يمنع من المقاصة ميعاد الوفاء لمهلة منحها القاضى أو تبرع بها الدائن.$b362$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins362;

WITH ins363 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 363, 0, $h363$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 3- المقاصة$h363$, $b363$يجوز للمدين أن يتمسك بالمقاصة ولو اختلف مكان الوفاء فى الدينين، ولكن يجب عليه فى هذه الحالة أن يعوض الدائن عما عسى أن يلحقه من ضرر بسبب عدم تمكنه من استيفاء ما له أو الوفاء بما عليه فى المكان الذى عين لذلك.$b363$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins363;

WITH ins364 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 364, 0, $h364$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 3- المقاصة$h364$, $b364$تقع المقاصة فى الديون أيا كان مصدرها وذلك فيما عدا الأحوال الآتية:
(أ) إذا كان أحد الدينين نزع شيئا دون حق من يد مالكه وكان مطلوبا رده.
(ب) إذا كان أحد الدينين شيئا مودعا أو معارا عارية استعمال وكان مطلوبا رده.
(جـ) إذا كان أحد الدينين حقا غير قابل للحجز.$b364$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins364;

WITH ins365 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 365, 0, $h365$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 3- المقاصة$h365$, $b365$(1) لا تقع المقاصة إلا إذا تمسك بها من له مصلحة فيها، ولا يجوز النزول عنها إلا بعد ثبوت الحق فيها.
(2) ويترتب على المقاصة انقضاء الدينين بقدر الأقل منهما، منذ الوقت الذى يصبحان فيه صالحين للمقاصة، ويكون تعيين جهة الدفع فى المقاصة كتعيينها فى الوفاء.$b365$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins365;

WITH ins366 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 366, 0, $h366$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 3- المقاصة$h366$, $b366$إذا كان الدين قد مضت عليه مدة التقادم وقت التمسك بالمقاصة فلا يمنع ذلك من وقوع المقاصة متى كانت مدة التقادم لم تكن قد تمت فى الوقت الذى تم فيه المقاصة أصبحت ممكنة.$b366$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins366;

WITH ins367 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 367, 0, $h367$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 3- المقاصة$h367$, $b367$(1) لا يجوز أن تقع المقاصة أضرارا بحقوق كسبها الغير.
(2) فإذا أوقع الغير حجزا تحت يد المدين، ثم أصبح المدين دائنا لحاجزه بعد ذلك، فلا يجوز له أن يتمسك بالمقاصة إضرارا بالحاجز.$b367$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins367;

WITH ins368 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 368, 0, $h368$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 3- المقاصة$h368$, $b368$(1) إذا حول الدائن حقه للغير وقبل المدين الحوالة دون تحفظ فلا يجوز لهذا المدين أن يتمسك قبل المحال له بالمقاصة التى كان له أن يتمسك بها قبل قبوله للحوالة، ولا يكون له إلا الرجوع على المحيل.
(2) أما إذا كان المدين لم يقبل الحوالة ولكن أعلن بها، فلا تمنعه هذه الحوالة من أن يتمسك بالمقاصة.$b368$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins368;

WITH ins369 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 369, 0, $h369$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 3- المقاصة$h369$, $b369$إذا وفى المدين دينا فى وقت كان يحق له أن يطلب المقاصة فيه، فلا يجوز له أن يتمسك إضرارا بالغير بالتأمينات التى تكفل هذا الحق، إلا إذا كان يجهل وجود هذا الحق.$b369$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins369;

WITH ins370 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 370, 0, $h370$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثانى - انقضاء الالتزام بما يعادل الوفاء > 4- اتحاد الذمة$h370$, $b370$(1) إذا اجتمع فى شخص واحد صفتا الدائن والمدين بالنسبة إلى دين واحد، انقضى هذا الدين بالقدر الذى أحدث فيه اتحاد الذمة.
(2) وإذا زال السبب الذى أدى لاتحاد الذمة وكان لزواله أثر رجعى، عاد الدين إلى الوجود وملحقاته بالنسبة إلى ذوى الشأن جميعا، ويعتبر اتحاد الذمة كأن لم يكن.$b370$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins370;

WITH ins371 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 371, 0, $h371$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 1- الإبراء$h371$, $b371$ينقضى الالتزام إذا أبرأ الدائن مدينه مختارا ويتم الإبراء متى وصل إلى علم المدين ويرتد بره.$b371$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins371;

WITH ins372 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 372, 0, $h372$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 1- الإبراء$h372$, $b372$(1) يسرى على الإبراء الأحكام الموضوعية التى تسرى على كل تبرع.
(2) ولا يشترط فيه شكل خاص، ولو وقع على التزام يشترط على قيامه توافر شكل فرضه القانون أو اتفق عليه المتعاقدان.$b372$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins372;

WITH ins373 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 373, 0, $h373$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 2- استحالة التنفيذ$h373$, $b373$ينقضى الالتزام إذا أثبت المدين أن الوفاء به أصبح مستحيلا لسبب أجنبى لا يد له فيه.$b373$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins373;

WITH ins374 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 374, 0, $h374$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h374$, $b374$يتقادم الالتزام بانقضاء خمس عشرة سنة فيما عدا الحالات التى ورد عنها نص خاص فى القانون وفيما عدا الاستثناءات التالية.$b374$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins374;

WITH ins375 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 375, 0, $h375$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h375$, $b375$(1) يتقادم بخمس سنوات كل حق دورى متجدد كأجرة المبانى والأراضى الزراعية ومقابل الحكر، والفوائد والإيرادات المرتبة والمهايا والأجور والمعاشات.
(2) ولا يسقط الريع المستحق فى ذمة الحائز سيىء النية الواجب أداؤه للناظر على الواقف إلا بانقضاء خمس عشرة سنة.$b375$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins375;

WITH ins376 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 376, 0, $h376$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h376$, $b376$تتقادم بخمس سنوات حقوق الأطباء والصيادلة والمحامين والمهندسين والخبراء ووكلاء التفليسة والسماسرة والأساتذة والمعلمين، على أن تكون هذه الحقوق واجبة لهم عما أدوه من عمل من أعمال مهنتهم وما تكبدوه من مصروفات.$b376$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins376;

WITH ins377 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 377, 0, $h377$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h377$, $b377$(1) تتقادم بثلاث سنوات الضرائب والرسوم المستحقة للدولة ويبدأ سريان التقادم فى الضرائب والرسوم السنوية من نهاية السنة التى تستحق عنها، وفى الرسوم القضائية عن الأوراق القضائية من تاريخ انتهاء المرافعة التى حررت فى شأنها هذه الأوراق، أو من تاريخ تحريرها إذا لم تحصل مرافعة.
(2) ويتقادم بثلاث سنوات أيضا الحق فى المطالبة برد الضرائب والرسوم التى دفعت بغير حق ويبدأ سريان التقادم من يوم دفعها.
(3) ولا تخل الأحكام السابقة بأحكام النصوص الواردة فى القوانين الخاصة.$b377$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins377;

WITH ins378 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 378, 0, $h378$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h378$, $b378$(1) تتقادم بسنة واحدة الحقوق الآتية:
(أ) حقوق التجار والصناع عن أشياء وردوها لأشخاص لا يتجرون فى هذه الأشياء، وحقوق أصحاب الفنادق والمطاعم عن ثمن الإقامة وثمن الطعام وكل ما صرفوه لحساب عملائهم.
(ب) حقوق العمال والخدم والأجراء من أجر يومية وغير يومية ومن ثمن ما قاموا به من توريدات.
(2) ويجب على من يتمسك بأن الحق قد تقادم بسنة أن يحلف اليمين على أنه أدى الدين فعلا، وهذه اليمين يوجهها القاضى من تلقاء نفسه إلى المدين أو إلى ورثته أو أوصيائهم إن كانوا قصرا لا يعلمون بوجود الدين أو يعلمون بحصول الوفاء.$b378$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins378;

WITH ins379 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 379, 0, $h379$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h379$, $b379$(1) يبدأ سريان التقادم فى الحقوق المذكورة فى المادتين 376-378 من الوقت الذى يتم فيه الدائنون تقدماتهم، ولو استمروا يؤدون تقدمات أخرى.
(2) وإذا حرر سند بهذا الحق فلا يتقادم الحق إلا بانقضاء خمس عشرة سنة.$b379$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins379;

WITH ins380 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 380, 0, $h380$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h380$, $b380$تحسب مدة التقادم بالأيام لا بالساعات، ولا بكسور اليوم الأول، وتكمل المدة بانقضاء آخر يوم منها.$b380$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins380;

WITH ins381 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 381, 0, $h381$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h381$, $b381$(1) لا يبدأ سريان التقادم فيما لم يرد فيه نص خاص إلا من اليوم الذى يصبح فيه الدين مستحق الأداء.
(2) وبخاصة لا يسرى التقادم بالنسبة إلى دين معلق على شرط واقف إلا من الوقت الذى يتحقق فيه الشرط، وبالنسبة إلى ضمان الاستحقاق إلا من الوقت الذى يثبت فيه الاستحقاق، وبالنسبة إلى الدين المؤجل إلا من الوقت الذى ينقضى فيه الأجل.
(3) وإذا كان تحديد ميعاد الوفاء متوقفا على إرادة الدائن، سرى التقادم من الوقت الذى يتمكن فيه الدائن من إعلان إرادته.$b381$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins381;

WITH ins382 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 382, 0, $h382$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h382$, $b382$(1) لا يسرى التقادم كلما وجد مانع يتعذر معه على الدائن أن يطالب بحقه ولو كان هذا المانع أدبيا. وكذلك لا يسرى التقادم فيما بين الأصيل والنائب.
(2) ولا يسرى التقادم الذى تزيد مدته على خمس سنوات فى حق من لا تتوافر فيه الأهلية أو فى حق الغائب أو فى حق المحكوم عليه بعقوبة جنائية إذا لم يكن له نائب يمثله قانونا.$b382$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins382;

WITH ins383 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 383, 0, $h383$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h383$, $b383$ينقطع التقادم بالمطالبة القضائية ولو رفعت الدعوى إلى محكمة غير مختصة، وبالتنبيه، وبالحجز، وبالطلب الذى يتقدم به الدائن لقبول حقه فى تفليس المدين أو فى توزيع، أو بأى عمل يقوم به الدائن للتمسك بحقه أثناء السير فى إحدى الدعاوى.$b383$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins383;

WITH ins384 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 384, 0, $h384$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h384$, $b384$(1) ينقطع التقادم إذا أقر المدين بحق الدائن إقرارا صريحا أو ضمنيا.
(2) ويعتبر إقرارا ضمنيا أن يترك المدين تحت يد الدائن مالا مرهونا رهنا حيازيا تأمينا لوفاء الدين.$b384$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins384;

WITH ins385 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 385, 0, $h385$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h385$, $b385$(1) إذا انقطع التقادم بدأ تقادم جديد يسرى من وقت إنهاء الأثر المترتب على سبب الانقطاع، وتكون مدته هى مدة التقادم الأول.
(2) على أنه إذا كان الدين قد حاز حكما بقوة الأمر المقضى أو إذا كان الدين مما يتقادم بسنة واحدة وانقطع تقادمه بإقرار المدين، كانت مدة التقادم الجديد خمس عشرة سنة، إلا أن يكون الدين المحكوم به متضمنا التزامات دورية متجددة لا تستحق الأداء إلا بعد صدور الحكم.$b385$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins385;

WITH ins386 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 386, 0, $h386$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h386$, $b386$(1) يترتب على التقادم انقضاء الالتزام ومع ذلك يتخلف فى ذمة المدين التزام طبيعى.
(2) وإذا سقط الحق بالتقادم سقطت معه الفوائد وغيرها من الملحقات ولو لم تكتمل مدة التقادم الخاصة بهذه الملحقات.$b386$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins386;

WITH ins387 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 387, 0, $h387$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h387$, $b387$(1) لا يجوز للمحكمة أن تقضى بالتقادم من تلقاء نفسها، بل يجب أن يكون ذلك بناء على طلب المدين أو بناء على طلب أى شخص له مصلحة فيه ولو لم يتمسك به المدين.
(2) ويجوز التمسك بالتقادم فى أية حالة كانت عليها الدعوى ولو أمام المحكمة الاستئنافية.$b387$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins387;

WITH ins388 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 388, 0, $h388$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب الخامس - انقضاء الالتزام > الفصل الثالث - انقضاء الالتزام دون الوفاء به > 3- التقادم المسقط$h388$, $b388$(1) لا يجوز النزول عن التقادم قبل ثبوت الحق فيه، كما لا يجوز الاتفاق على أن يتم التقادم فى مدة تختلف عن المدة التى عليها القانون.
(2) وإنما يجوز لكل شخص يملك التصرف فى حقوقه أن ينزل ولو ضمنا عن التقادم بعد ثبوت الحق فيه، على أن هذا النزول لا ينفذ فى حق الدائنين إذا صدر إضرارا بهم.$b388$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins388;

WITH ins389 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 389, 0, $h389$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h389$, $b389$(ملغاة).$b389$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins389;

WITH ins390 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 390, 0, $h390$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h390$, $b390$(ملغاة).$b390$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins390;

WITH ins391 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 391, 0, $h391$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h391$, $b391$(ملغاة).$b391$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins391;

WITH ins392 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 392, 0, $h392$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h392$, $b392$(ملغاة).$b392$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins392;

WITH ins393 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 393, 0, $h393$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h393$, $b393$(ملغاة).$b393$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins393;

WITH ins394 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 394, 0, $h394$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h394$, $b394$(ملغاة).$b394$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins394;

WITH ins395 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 395, 0, $h395$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h395$, $b395$(ملغاة).$b395$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins395;

WITH ins396 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 396, 0, $h396$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h396$, $b396$(ملغاة).$b396$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins396;

WITH ins397 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 397, 0, $h397$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h397$, $b397$(ملغاة).$b397$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins397;

WITH ins398 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 398, 0, $h398$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h398$, $b398$(ملغاة).$b398$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins398;

WITH ins399 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 399, 0, $h399$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h399$, $b399$(ملغاة).$b399$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins399;

WITH ins400 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 400, 0, $h400$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h400$, $b400$(ملغاة).$b400$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins400;

WITH ins401 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 401, 0, $h401$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h401$, $b401$(ملغاة).$b401$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins401;

WITH ins402 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 402, 0, $h402$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h402$, $b402$(ملغاة).$b402$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins402;

WITH ins403 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 403, 0, $h403$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h403$, $b403$(ملغاة).$b403$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins403;

WITH ins404 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 404, 0, $h404$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h404$, $b404$(ملغاة).$b404$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins404;

WITH ins405 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 405, 0, $h405$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h405$, $b405$(ملغاة).$b405$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins405;

WITH ins406 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 406, 0, $h406$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h406$, $b406$(ملغاة).$b406$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins406;

WITH ins407 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 407, 0, $h407$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h407$, $b407$(ملغاة).$b407$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins407;

WITH ins408 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 408, 0, $h408$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h408$, $b408$(ملغاة).$b408$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins408;

WITH ins409 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 409, 0, $h409$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h409$, $b409$(ملغاة).$b409$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins409;

WITH ins410 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 410, 0, $h410$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h410$, $b410$(ملغاة).$b410$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins410;

WITH ins411 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 411, 0, $h411$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h411$, $b411$(ملغاة).$b411$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins411;

WITH ins412 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 412, 0, $h412$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h412$, $b412$(ملغاة).$b412$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins412;

WITH ins413 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 413, 0, $h413$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h413$, $b413$(ملغاة).$b413$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins413;

WITH ins414 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 414, 0, $h414$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h414$, $b414$(ملغاة).$b414$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins414;

WITH ins415 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 415, 0, $h415$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h415$, $b415$(ملغاة).$b415$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins415;

WITH ins416 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 416, 0, $h416$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h416$, $b416$(ملغاة).$b416$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins416;

WITH ins417 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 417, 0, $h417$القسم الأول - الالتزامات أو الحقوق الشخصية > الكتاب الأول - الالتزامات بوجه عام > الباب السادس - إثبات الالتزام$h417$, $b417$(ملغاة).$b417$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins417;

WITH ins418 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 418, 0, $h418$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h418$, $b418$البيع عقد يلتزم به البائع أن ينقل للمشترى ملكية شىء أو حقا ماليا آخر فى مقابل ثمن نقدى.$b418$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins418;

WITH ins419 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 419, 0, $h419$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h419$, $b419$(1) يجب أن يكون المشترى عالما بالمبيع علما كافيا، ويعتبر العلم كافيا إذا اشتمل العقد على بيان المبيع وأوصافه الأساسية بيانا يمكن من تعرفه.
(2) وإذا ذكر فى عقد البيع أن المشترى عالم بالمبيع، سقط حقه فى طلب إبطال البيع بدعوى عدم علمه به إلا إذا أثبت تدليس البائع.$b419$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins419;

WITH ins420 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 420, 0, $h420$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h420$, $b420$(1) إذا كان البيع "بالعينة" وجب أن يكون المبيع مطابقا لها.
(2) وإذا تلفت "العينة" أو هلكت فى يد أحد المتعاقدين ولو دون خطأ، كان على المتعاقد الذى وقعت فى يده أن يثبت أن الشيء مطابق للعينة أو غير مطابق، إذا كان هو البائع، أو على المشترى أن يثبت ذلك إذا كانت فى يده.$b420$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins420;

WITH ins421 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 421, 0, $h421$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h421$, $b421$(1) فى البيع بشرط التجربة يجوز للمشترى أن يقبل المبيع أو يرفضه، وجب على البائع أن يمكنه من التجربة، فإذا رفض المشترى المبيع وجب أن يعلن الرفض فى المدة المتفق عليها، فإن لم يكن هناك اتفاق على المدة فمدة معقولة يعينها البائع، فإذا انقضت هذه المدة وسكت المشترى مع تمكنه من تجربة المبيع اعتبر سكوته قبولا.
(2) ويعتبر البيع بشرط التجربة معلقا على شرط واقف هو قبول المبيع إلا إذا تبين من الاتفاق أو من الظروف أن البيع معلق على شرط فاسخ.$b421$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins421;

WITH ins422 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 422, 0, $h422$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h422$, $b422$إذا بيع الشيء بشرط المذاق كان للمشترى أن يقبل البيع إن شاء، ولكن عليه أن يعلن هذا القبول فى المدة التى يعينها الاتفاق أو العرف ولا ينعقد البيع إلا من الوقت الذى يتم فيه هذا الإعلان.$b422$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins422;

WITH ins423 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 423, 0, $h423$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h423$, $b423$(1) يجوز أن يقتصر تقدير الثمن على بيان الأسس التى يحدد بمقتضاها فيما بعد.
(2) وإذا اتفق على أن الثمن هو سعر السوق، وجب عند الشك، أن يكون الثمن هو سعر السوق فى المكان والزمان اللذين يجب فيهما تسليم المبيع للمشترى، فإذا لم يكن فى مكان التسليم سعر للسوق، وجب الرجوع إلى سعر السوق فى المكان الذى يقضى العرف أن تكون أسعاره هى السارية.$b423$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins423;

WITH ins424 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 424, 0, $h424$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h424$, $b424$إذا لم يحدد المتعاقدان ثمنا للمبيع، فلا يترتب على ذلك بطلان البيع متى تبين أن نية المتعاقدين قد اتجهت إلى اعتماد السعر المتداول فى التجارة أو السعر الذى جرى عليه التعامل بينهما.$b424$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins424;

WITH ins425 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 425, 0, $h425$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h425$, $b425$(1) إذا بيع عقار مملوك لشخص لا تتوافر فيه الأهلية وكان فى البيع غبن يزيد على الخمس فللبائع أن يطلب تكملة الثمن إلى أربعة أخماس ثمن المثل.
(2) ويجب لتقدير ما إذا كان الغبن يزيد على الخمس أن يقوم العقار بحسب قيمته وقت البيع.$b425$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins425;

WITH ins426 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 426, 0, $h426$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h426$, $b426$(1) تسقط بالتقادم دعوى تكملة الثمن بسبب الغبن إذا انقضت ثلاث سنوات من وقت صدور العقد أو من اليوم الذى يبلغ فيه صاحب العقار المبيع سن الرشد أو توافر الأهلية.
(2) ولا تلحق هذه الدعوى ضررا بالغير حسن النية إذا كسب حقا عينيا على العقار المبيع.$b426$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins426;

WITH ins427 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 427, 0, $h427$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > أركان البيع$h427$, $b427$لا يجوز الطعن بالغبن فى البيع إذا تم المبيع بطريق المزاد العلنى.$b427$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins427;

WITH ins428 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 428, 0, $h428$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h428$, $b428$يلتزم البائع بما يقوم به من ضرورى لنقل الحق المبيع إلى المشترى وأن يكف عن أى عمل من شأنه أن يجعل نقل الحق مستحيلا أو عسيرا.$b428$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins428;

WITH ins429 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 429, 0, $h429$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h429$, $b429$إذا كان البيع جزافا، انتقلت الملكية إلى المشترى على النحو الذى تنتقل به ملكية الشيء المعين بالذات، ويكون البيع جزافا ولو كان تحديد الثمن موقوفا على تقدير المبيع.$b429$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins429;

WITH ins430 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 430, 0, $h430$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h430$, $b430$(1) إذا كان البيع مؤجل الثمن، جاز للبائع أن يشترط أن يكون نقل الملكية إلى المشترى موقوفا على استيفاء الثمن كله ولو تم تسليم المبيع.
(2) فإذا كان الثمن يدفع أقساطا، جاز للمتعاقدين أن يتفقا على أن يستبقى البائع جزءا منه تعويضا له عن فسخ البيع إذا لم توف جميع الأقساط. ومع ذلك يجوز للقاضى تبعا للظروف أن يخفض التعويض المتفق عليه وفقا للفقرة الثانية من المادة 224.
(3) وإذا وفيت الأقساط جميعا، فإن انتقال الملكية إلى المشترى يعتبر مستندا إلى وقت البيع.
(4) وتسرى أحكام الفقرات الثلاث السابقة ولو سمى المتعاقدان البيع إيجارا.$b430$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins430;

WITH ins431 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 431, 0, $h431$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h431$, $b431$يلتزم البائع بتسليم المبيع للمشترى بالحالة التى كان عليها وقت البيع.$b431$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins431;

WITH ins432 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 432, 0, $h432$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h432$, $b432$يشمل التسليم ملحقات الشيء المبيع وكل ما أعد بصفة دائمة لاستعمال هذا الشيء وذلك طبقا لما تقضى به طبيعة الأشياء وعرف الجهة وقصد المتعاقدين.$b432$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins432;

WITH ins433 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 433, 0, $h433$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h433$, $b433$(1) إذا عين فى العقد مقدار المبيع كان البائع مسئولا عن نقص هذا القدر، بحسب ما يقضى به العرف ما لم يتفق على غير ذلك، على أنه لا يجوز للمشترى أن يطلب فسخ العقد لنقص فى المبيع إلا إذا أثبت أن هذا النقص بحيث لو كان يعلمه لما أتم العقد.
(2) أما إذا تبين أن القدر الذى يشتمل عليه المبيع يزيد على ما ذكر فى العقد وكان الثمن مقدرا بحساب الوحدة، وجب على المشترى أن يكمل الثمن إذا كان المبيع غير قابل للتبعيض، إلا إذا كانت الزيادة جسيمة فيجوز له أن يطلب فسخ العقد، وكل هذا ما لم يوجد اتفاق يخالفه.$b433$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins433;

WITH ins434 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 434, 0, $h434$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h434$, $b434$إذا وجد فى المبيع عجز أو زيادة، فإن حق المشترى فى طلب إنقاص الثمن أو فى طلب فسخ العقد وحق البائع فى طلب تكملة الثمن يسقط كل منهما إذا انقضت سنة من وقت تسلم المبيع تسلما فعليا.$b434$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins434;

WITH ins435 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 435, 0, $h435$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h435$, $b435$(1) يكون التسليم بوضع المبيع تحت تصرف المشترى بحيث يتمكن من حيازته والانتفاع به دون عائق ولو لم يستول عليه المشترى مادام البائع قد أعلمه بذلك، ويحصل هذا التسليم على النحو الذى يتفق مع طبيعة الشيء المبيع.
(2) ويجوز أن يتم التسليم بمجرد تراضى المتعاقدين إذا كان المبيع فى حيازة المشترى قبل البيع لسبب آخر غير البيع، أو كان البائع قد استبقى المبيع بعد بيعه لسبب آخر غير الملكية.$b435$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins435;

WITH ins436 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 436, 0, $h436$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h436$, $b436$إذا وجب تصدير المبيع للمشترى، فلا يتم التسليم إلا إذا وصل إليه ما لم يوجد اتفاق بغير ذلك.$b436$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins436;

WITH ins437 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 437, 0, $h437$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h437$, $b437$إذا هلك المبيع قبل التسليم لسبب لا يد للبائع فيه، انفسخ البيع واسترد المشترى الثمن إلا إذا كان الهلاك بعد إعذار المشترى لتسليم المبيع.$b437$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins437;

WITH ins438 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 438, 0, $h438$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h438$, $b438$إذا نقصت قيمة المبيع قبل التسليم لتلف أصابه، جاز للمشترى أما أن يطلب فسخ البيع إذا كان النقص جسيما لو طرأ قبل تمام العقد، وأما أن يبقى البيع مع إنقاص الثمن.$b438$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins438;

WITH ins439 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 439, 0, $h439$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h439$, $b439$يضمن البائع عدم التعرض للمشترى فى الانتفاع بالمبيع كله أو بعضه سواء كان هذا التعرض من فعله هو أو من فعل أجنبى يكون له حق على المبيع وقت البيع يحتج به على المشترى إذا كان هذا الحق قد آل إليه من البائع نفسه.$b439$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins439;

WITH ins440 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 440, 0, $h440$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h440$, $b440$(1) إذا رفعت على المشترى دعوى باستحقاق المبيع وأخطر بها البائع، كان على البائع بحسب الأحوال، ووفقا لقانون المرافعات أن يتدخل فى الدعوى إلى جانب المشترى أو أن يحل فيها محله.
(2) فإذا تم الإخطار فى الوقت الملائم ولم يتدخل البائع فى الدعوى، وجب عليه الضمان إلا إذا أثبت أن الحكم الصادر فى الدعوى كان نتيجة لتدليس المشترى أو الخطأ الجسيم منه.
(3) وإذا لم يخطر المشترى البائع فى الوقت الملائم بالدعوى وصدر عليه حكم حاز قوة الأمر المقضى فقد حقه فى الرجوع على البائع بالضمان إذا أثبت البائع أن تدخله فى الدعوى كان يؤدى إلى رفض دعوى الاستحقاق.$b440$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins440;

WITH ins441 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 441, 0, $h441$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h441$, $b441$يثبت حق المشترى فى الضمان وهو معترف للأجنبى بحقه، ولو تصالح معه على ذلك دون أن ينتظر صدور حكم قضائى متى كان قد أخطر البائع بالدعوى فى الوقت الملائم ودعاه فيها، فإن لم يفعل ذلك لم يثبت له حق فى الضمان إلا أن يثبت أنه لم يكن للأجنبى حق فى دعواه.$b441$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins441;

WITH ins442 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 442, 0, $h442$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h442$, $b442$إذا توقى المشترى استحقاق المبيع كله أو بعضه بأداء مبلغ من النقود أو بأداء شىء آخر، كان للبائع أن يتخلص من نتائج الضمان بأن يرد للمشترى المبلغ الذى دفعه أو قيمة ما أداه مع الفوائد القانونية وجميع المصروفات.$b442$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins442;

WITH ins443 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 443, 0, $h443$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h443$, $b443$إذا استحق كل المبيع كان للمشترى أن يطلب من البائع:
قيمة المبيع وقت الاستحقاق مع الفوائد القانونية من ذلك الوقت.
قيمة الثمار التى ألزم المشترى بردها لمن استحق المبيع.
المصروفات النافعة التى لا يستطيع المشترى أن يلزم بها المستحق وكذلك المصروفات الكمالية إذا كان البائع سيئ النية.
جميع مصروفات دعوى الضمان ودعوى الاستحقاق عدا ما كان المشترى يستطيع أن يتقيه منها لو أخطر البائع بالدعوى طبقا للمادة 440.
وبوجه عام، تعويض المشترى عما لحقه من خسارة أو فاته من كسب بسبب استحقاق المبيع.
كل هذا ما لم يكن رجوع المشترى مبنيا على المطالبة بفسخ البيع أو إبطاله.$b443$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins443;

WITH ins444 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 444, 0, $h444$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h444$, $b444$(1) إذا استحق بعض المبيع أو وجد مثقلا بتكليف لم يكن يعلمه وبلغت الخسارة التى لحقته من ذلك قدرا لو علمه لما أتم العقد، كان له أن يطالب البائع بالمبالغ المبينة فى المادة السابقة على أن يرد له ما أفاده منه.
(2) فإذا اختار المشترى استبقاء المبيع، ولم تبلغ الخسارة التى لحقته القدر المبين فى الفقرة السابقة، لم يكن له إلا أن يطالب بالتعويض عما أصابه من ضرر بسبب الاستحقاق.$b444$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins444;

WITH ins445 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 445, 0, $h445$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h445$, $b445$(1) يجوز للمتعاقدين باتفاق خاص ضمان الاستحقاق أن يزيدا منه أو أن ينقصا منه، أو أن يسقطا هذا الضمان.
(2) ويفترض فى حق الارتفاع أن البائع قد اشترط عدم الضمان إذا كان هذا الحق ظاهرا أو كان البائع قد أبان عنه للمشترى.
(3) ويقع باطلا كل شرط يسقط الضمان أو ينقصه إذا كان البائع قد تعمد إخفاء حق الأجنبى.$b445$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins445;

WITH ins446 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 446, 0, $h446$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h446$, $b446$(1) إذا اتفق على عدم الضمان بقى البائع مع ذلك مسئولا عن كل استحقاق ينشأ عن فعله، ويقع باطلا كل اتفاق يقضى بغير ذلك.
(2) أما إذا كان استحقاق المبيع ناشئا عن فعل الغير، فإن البائع يكون مسئولا عن رد قيمة المبيع وقت الاستحقاق، إلا إذا أثبت المشترى أن البائع كان يعلم وقت البيع سبب الاستحقاق، أو أنه أسقط الخيار.$b446$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins446;

WITH ins447 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 447, 0, $h447$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h447$, $b447$(1) يكون البائع ملزما بالضمان إذا لم يتوافر فى المبيع وقت التسليم الصفات التى كفل للمشترى وجودها فيه، أو إذا كان بالمبيع عيب ينقص من قيمته أو من نفعه بحسب الغاية المقصودة منه مستفادة مما هو مبين فى العقد أو مما هو ظاهر من طبيعة الشيء، أو الغرض الذى أعد له، ويضمن البائع هذا العيب ولو لم يكن عالما بوجوده.
(2) ومع ذلك لا يضمن البائع العيوب التى كان المشترى يعرفها وقت البيع، أو كان يستطيع أن يتبينها بنفسه لو أنه فحص المبيع بعناية الرجل العادى، إلا إذا أثبت المشترى أن البائع أكد له خلو المبيع من هذا العيب، أو أثبت أن البائع تعمد إخفاء العيب غشا منه.$b447$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins447;

WITH ins448 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 448, 0, $h448$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h448$, $b448$لا يضمن البائع عيبا جرى العرف على التسامح فيه.$b448$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins448;

WITH ins449 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 449, 0, $h449$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h449$, $b449$(1) إذا تسلم المشترى المبيع، وجب عليه التحقق من حالته بمجرد أن يتمكن من ذلك وفقا للمألوف فى التعامل، فإذا كشف عيبا يضمنه البائع وجب عليه أن يخطره به خلال مدة معقولة، فإن لم يفعل اعتبر قابلا للمبيع.
(2) أما إذا كان العيب مما لا يمكن الكشف عنه بالفحص المعتاد، وجب عليه الكشف عنه ثم إخطاره به عند ظهوره مجرد ظهوره، وإلا اعتبر قابلا للمبيع بما فيه من عيب.$b449$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins449;

WITH ins450 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 450, 0, $h450$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h450$, $b450$إذا أخطر المشترى البائع بالعيب فى الوقت الملائم كان له أن يرجع بالضمان على النحو المبين فى المادة 444.$b450$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins450;

WITH ins451 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 451, 0, $h451$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h451$, $b451$تبقى دعوى الضمان ولو هلك المبيع بأى سبب كان.$b451$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins451;

WITH ins452 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 452, 0, $h452$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h452$, $b452$(1) تسقط بالتقادم دعوى الضمان إذا انقضت سنة من وقت تسليم المبيع ولو لم يكشف المشترى العيب إلا بعد ذلك ما لم يلتزم البائع بالضمان لمدة أطول.
(2) على أنه لا يجوز للبائع أن يتمسك بتمام التقادم بالنسبة إلى العيب الذى ثبت أنه تعمد إخفاءه غشا منه.$b452$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins452;

WITH ins453 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 453, 0, $h453$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h453$, $b453$يجوز للمتعاقدين باتفاق خاص أن يزيدا فى الضمان أو أن ينقصا منه أو أن يسقطا هذا الضمان، على أن كل شرط يسقط الضمان أو ينقضه يقع باطلا إذا كان البائع قد تعمد إخفاء العيب فى المبيع غشا منه.$b453$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins453;

WITH ins454 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 454, 0, $h454$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h454$, $b454$لا ضمان للعيب فى البيوع القضائية. ولا فى البيوع الإدارية إذا كانت بالمزاد.$b454$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins454;

WITH ins455 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 455, 0, $h455$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات البائع$h455$, $b455$إذا ضمن البائع صلاحية المبيع للعمل مدة معلومة ثم ظهر خلل، فعلى المشترى أن يخطر البائع بهذا الخلل فى مدة شهر من ظهوره وأن يرفع الدعوى فى مدة ستة شهور من تاريخ هذا الإخطار، وإلا سقط حقه فى الضمان، كل هذا ما لم يتفق على غير ذلك.$b455$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins455;

WITH ins456 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 456, 0, $h456$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h456$, $b456$(1) يكون الثمن مستحق الوفاء فى المكان الذى سلم فيه المبيع ما لم يوجد اتفاق أو عرف يقضى بغير ذلك.
(2) فإذا لم يكن الثمن مستحقا وقت تسليم المبيع، وجب الوفاء به فى المكان الذى يوجد فيه موطن المشترى وقت استحقاق الثمن.$b456$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins456;

WITH ins457 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 457, 0, $h457$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h457$, $b457$(1) يكون الثمن مستحق الوفاء فى الوقت الذى يسلم فيه المبيع ما لم يوجد اتفاق أو عرف يقضى بغير ذلك.
(2) فإذا تعرض أحد للمشترى مستندا إلى حق سابق على البيع أو آيل من البائع، أو إذا خيف على المبيع أن ينزع من يد المشترى، جاز له أن يمتنع عن دفع الثمن ما لم يمنعه شرط فى العقد حتى يزول التعرض أو الخطر، ومع ذلك يجوز للبائع فى هذه الحالة أن يطلب من المشترى استيفاء الثمن حتى يقدم كفيلا.
(3) ويسرى حكم الفقرة السابقة فى حالة ما إذا اكتشف المشترى عيبا فى المبيع.$b457$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins457;

WITH ins458 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 458, 0, $h458$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h458$, $b458$(1) لا حق للبائع فى الفوائد القانونية عن الثمن إلا إذا أعذر المشترى أو إذا سلم الشيء المبيع وكان هذا الشيء ينتج ثمرات أو إيرادات أخرى، هذا ما لم يوجد اتفاق أو عرف يقضى بغيره.
(2) وللمشترى ثمر المبيع ونماؤه من وقت تمام البيع، وعليه تكاليف المبيع من هذا الوقت أيضا، هذا ما لم يوجد اتفاق أو عرف يقضى بغيره.$b458$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins458;

WITH ins459 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 459, 0, $h459$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h459$, $b459$(1) إذا كان الثمن كله أو بعضه مستحق الدفع حتى يستوفى البائع فللبائع أن يحبس المبيع حتى يستوفى ما هو مستحق له من ثمن أو كفالة، هذا ما لم يمنح البائع المشترى أجلا بعد البيع.
(2) وكذلك يجوز للبائع أن يحبس المبيع ولو لم يحل الأجل المشترط لدفع الثمن إذا سقط حق المشترى فى الأجل طبقا لأحكام المادة 273.$b459$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins459;

WITH ins460 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 460, 0, $h460$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h460$, $b460$إذا هلك المبيع فى يد البائع وهو حابس له كان الهلاك على المشترى ما لم يكن قد هلك بفعل البائع.$b460$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins460;

WITH ins461 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 461, 0, $h461$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h461$, $b461$فى بيع العروض وغيرها من المنقولات إذا اتفق على ميعاد لدفع الثمن وتسلم المبيع يكون البيع مفسوخا من تلقاء نفسه دون حاجة إلى إعذار إن لم يدفع الثمن عند حلول الميعاد إذا اختار البائع ذلك، وهذا ما لم يوجد اتفاق على غيره.$b461$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins461;

WITH ins462 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 462, 0, $h462$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h462$, $b462$نفقات عقد البيع ورسوم "الدمغة" والتسجيل وغير ذلك من مصروفات تكون على المشترى ما لم يوجد اتفاق أو عرف يقضى بغير ذلك.$b462$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins462;

WITH ins463 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 463, 0, $h463$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h463$, $b463$إذا لم يعين الاتفاق أو العرف مكانا أو زمانا لتسليم المبيع وجب على المشترى أن يتسلمه فى المكان الذى يوجد فيه المبيع وقت البيع وأن ينقله دون إبطاء إلا بما يقتضيه النقل من زمن.$b463$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins463;

WITH ins464 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 464, 0, $h464$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 1- البيع بوجه عام > التزامات المشترى$h464$, $b464$نفقات تسلم المبيع على المشترى ما لم يوجد اتفاق أو عرف يقضى بغير ذلك.$b464$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins464;

WITH ins465 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 465, 0, $h465$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع الوفاء$h465$, $b465$إذا احتفظ البائع عند البيع بحق استرداد المبيع خلال مدة معينة وقع البيع باطلا.$b465$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins465;

WITH ins466 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 466, 0, $h466$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع ملك الغير$h466$, $b466$(1) إذا باع شخص شيئا معينا بالذات وهو لا يملكه، جاز للمشترى أن يطلب إبطال البيع. ويكون الأمر كذلك ولو وقع البيع على عقار وسجل العقد أو لم يسجل.
(2) وفى كل حال لا يسرى هذا البيع فى حق المالك للعين المبيعة ولو أجاز المشترى العقد.$b466$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins466;

WITH ins467 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 467, 0, $h467$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع ملك الغير$h467$, $b467$(1) إذا أقر المالك البيع الصادر من غير مالك سرى حقه فى العقد وانقلب صحيحا فى حق المشترى.
(2) وكذلك ينقلب العقد صحيحا فى حق المشترى إذا آلت ملكية المبيع إلى البائع بعد صدور العقد.$b467$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins467;

WITH ins468 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 468, 0, $h468$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع ملك الغير$h468$, $b468$إذا حكم للمشترى بإبطال البيع وكان يجهل أن المبيع غير مملوك للبائع، فله أن يطالب بتعويض ولو كان البائع حسن النية.$b468$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins468;

WITH ins469 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 469, 0, $h469$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع الحقوق المتنازع عليها$h469$, $b469$(1) إذا كان الحق المتنازع فيه قد نزل عنه صاحبه بمقابل إلى شخص آخر فللمتنازل ضده أن يتخلص من المطالبة من قبل المتنازل له برد الثمن الحقيقى الذى دفعه مع المصروفات وفوائد الثمن من وقت الدفع.
(2) ويعتبر الحق متنازعا فيه إذا كان موضوعه قد رفعت به دعوى أو قام فى شأنه نزاع جدى.$b469$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins469;

WITH ins470 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 470, 0, $h470$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع الحقوق المتنازع عليها$h470$, $b470$لا تسرى أحكام المادة السابقة فى الأحوال الآتية:
(أ) إذا كان الحق المتنازع فيه داخلا ضمن أموال بيعت جزافا بثمن واحد.
(ب) إذا كان الحق المتنازع فيه شائعا بين ملاك أو ورثة وباع أحدهم نصيبه للآخر.
(جـ) إذا نزل المدين للدائن عن حق متنازع فيه وفاء للدين المستحق فى ذمته.
(د) إذا كان الحق المتنازع فيه يتعلق بعقار يحوزه حائز العقار.$b470$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins470;

WITH ins471 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 471, 0, $h471$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع الحقوق المتنازع عليها$h471$, $b471$لا يجوز للقضاة ولا لأعضاء النيابة ولا للمحامين ولا للكتبة ولا للمحضرين أن يشتروا لأنفسهم ولا باسم مستعار الحق المتنازع فيه كله أو بعضه إذا كان النزاع يدخل فى اختصاص المحكمة التى يباشرون أعمالهم فى دائرتها وإلا كان البيع باطلا.$b471$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins471;

WITH ins472 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 472, 0, $h472$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع الحقوق المتنازع عليها$h472$, $b472$لا يجوز للمحامين أن يتعاملوا مع موكليهم فى الحقوق المتنازع عليها فيها إذا كانوا هم الذين يتولون الدفاع عنها سواء أكان التعامل بأسمائهم أم باسم مستعار وإلا كان العقد باطلا.$b472$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins472;

WITH ins473 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 473, 0, $h473$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع التركة$h473$, $b473$من باع تركة، دون أن يفصل مشتملاتها، لا يضمن إلا ثبوت وراثته ما لم يتفق على غير ذلك.$b473$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins473;

WITH ins474 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 474, 0, $h474$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع التركة$h474$, $b474$إذا بيعت تركة فلا يسرى البيع فى حق الغير إلا إذا استوفى المشترى الإجراءات الواجبة لنقل كل حق اشتملت عليه التركة، فإذا نص القانون على إجراءات لنقل هذا الحق فيما بين المتعاقدين، وجب أيضا أن تستوفى هذه الإجراءات.$b474$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins474;

WITH ins475 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 475, 0, $h475$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع التركة$h475$, $b475$إذا كان البائع قد استوفى بعض ما اشتمل عليه من الديون أو باع شيئا من التركة، وجب أن يرد للمشترى ما استوفاه أو ما قبض ثمنه ما لم يكن البيع قد اشترط صراحة عدم الرد.$b475$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins475;

WITH ins476 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 476, 0, $h476$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع التركة$h476$, $b476$يرد المشترى للبائع ما وفاه هذا من ديون التركة ويحسب للبائع كل ما يوجد للتركة من ديون ما لم يوجد اتفاق على غير ذلك.$b476$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins476;

WITH ins477 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 477, 0, $h477$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > البيع فى مرض الموت$h477$, $b477$(1) إذا باع المريض مرض الموت لوارث أو لغير وارث بثمن يقل عن قيمة المبيع وقت البيع فإن البيع يسرى فى حق الورثة إذا كانت زيادة قيمة المبيع على الثمن لا تجاوز ثلث التركة داخلا فيها المبيع ذاته.
(2) أما إذا كانت هذه الزيادة تجاوز ثلث التركة فإن البيع فيما يجاوز الثلث لا يسرى فى حق الورثة إلا إذا أقروه أو رد المشترى للتركة ما يفى بتكملة الثلثين.
(3) ويسرى على بيع المريض مرض الموت أحكام المادة 916.$b477$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins477;

WITH ins478 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 478, 0, $h478$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > البيع فى مرض الموت$h478$, $b478$لا تسرى أحكام المادة السابقة إضرارا بالغير حسن النية إذا كان هذا الغير قد كسب بعوض حقا عينيا على العين المبيعة.$b478$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins478;

WITH ins479 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 479, 0, $h479$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع النائب لنفسه$h479$, $b479$لا يجوز لمن ينوب عن غيره بمقتضى اتفاق أو نص أو أمر من السلطات المختصة أن يشترى بنفسه مباشرة أو باسم مستعار ولو بطريق المزاد العلنى ما نيط به بيعه بموجب هذه النيابة ما لم يكن بإذن القضاء ومع عدم الإخلال بما يكون منصوصا عليه فى قوانين أخرى.$b479$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins479;

WITH ins480 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 480, 0, $h480$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع النائب لنفسه$h480$, $b480$لا يجوز للسماسرة ولا للخبراء أن يشتروا الأموال المعهود إليهم فى بيعها أو فى تقدير قيمتها سواء أكان الشراء بأسمائهم أم باسم مستعار.$b480$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins480;

WITH ins481 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 481, 0, $h481$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الأول - البيع > 2- بعض أنواع البيوع > بيع النائب لنفسه$h481$, $b481$يصح العقد فى الأحوال المنصوص عليها فى المادتين السابقتين إذا أجازه من تم البيع من أجله إجازته.$b481$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins481;

WITH ins482 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 482, 0, $h482$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثانى - المقايضة$h482$, $b482$المقايضة عقد يلتزم بمقتضاه كل من المتعاقدين أن ينقل للآخر، على سبيل التبادل، ملكية مال ليس من النقود.$b482$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins482;

WITH ins483 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 483, 0, $h483$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثانى - المقايضة$h483$, $b483$إذا كانت الأشياء المتقايض فيها قيما مختلفة فى تقدير المتعاقدين، جاز تعويض الفرق بمبلغ من النقود يكون معدلا.$b483$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins483;

WITH ins484 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 484, 0, $h484$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثانى - المقايضة$h484$, $b484$مصروفات عقد المقايضة وغيرها من النفقات الأخرى يتحملها المتقايضان مناصفة ما لم يوجد اتفاق يقضى بغير ذلك.$b484$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins484;

WITH ins485 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 485, 0, $h485$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثانى - المقايضة$h485$, $b485$تسرى على المقايضة أحكام البيع، بالقدر الذى تسمح به طبيعة المقايضة، ويعتبر كل من المتقايضين بائعا للشيء الذى قايض به ومشتريا للشىء الذى قايض عليه.$b485$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins485;

WITH ins486 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 486, 0, $h486$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 1- أركان الهبة$h486$, $b486$(1) الهبة عقد يتصرف بمقتضاه الواهب فى مال له دون عوض.
(2) ويجوز للواهب، دون أن يتجرد عن نية التبرع، أن يفرض على الموهوب له القيام بالتزام معين.$b486$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins486;

WITH ins487 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 487, 0, $h487$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 1- أركان الهبة$h487$, $b487$(1) لا تتم الهبة إلا إذا قبلها الموهوب له أو نائبه.
(2) فإذا كان الواهب هو ولى الموهوب له أو وصيا أو ناب عنه فى قبول الهبة وقبض الشيء الموهوب.$b487$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins487;

WITH ins488 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 488, 0, $h488$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 1- أركان الهبة$h488$, $b488$(1) تكون الهبة بورقة رسمية، وإلا وقعت باطلة ما لم تتم تحت ستار عقد آخر.
(2) ومع ذلك يجوز فى المنقول أن تتم الهبة بالقبض، دون حاجة إلى ورقة رسمية.$b488$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins488;

WITH ins489 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 489, 0, $h489$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 1- أركان الهبة$h489$, $b489$إذا قام الواهب أو ورثته مختارين بتنفيذ هبة باطلة لعيب فى الشكل، فلا يجوز لهم أن يستردوا ما سلموه.$b489$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins489;

WITH ins490 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 490, 0, $h490$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 1- أركان الهبة$h490$, $b490$الوعد بالهبة لا ينعقد إلا إذا كان بورقة رسمية.$b490$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins490;

WITH ins491 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 491, 0, $h491$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 1- أركان الهبة$h491$, $b491$إذا وردت الهبة على شيء معين بالذات، غير مملوك للواهب، سرت عليها أحكام المادتين 466، 467.$b491$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins491;

WITH ins492 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 492, 0, $h492$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 1- أركان الهبة$h492$, $b492$تقع هبة الأموال المستقبلة باطلة.$b492$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins492;

WITH ins493 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 493, 0, $h493$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 2- آثار الهبة$h493$, $b493$إذا لم يكن الواهب قد تسلم الشيء الموهوب له فإن الواهب يلتزم بتسليمه إياه، وتسرى فى ذلك الأحكام المتعلقة بتسليم المبيع.$b493$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins493;

WITH ins494 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 494, 0, $h494$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 2- آثار الهبة$h494$, $b494$(1) لا يضمن الواهب استحقاق الشيء الموهوب، إلا إذا تعمد إخفاء سبب الاستحقاق أو كانت الهبة بعوض. وفى الحالة الأولى يقدر القاضى تعويضا عادلا للموهوب له يعرضه له. وفى الحالة الثانية لا يضمن الواهب الاستحقاق إلا بقدر ما أداه الموهوب له من هذا العوض، كل هذا ما لم يتفق على غير ذلك.
(2) وإذا استحق الشيء الموهوب حل الموهوب له محل الواهب فيما له من حقوق ودعاوى.$b494$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins494;

WITH ins495 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 495, 0, $h495$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 2- آثار الهبة$h495$, $b495$(1) لا يضمن الواهب خلو الشيء الموهوب من العيب.
(2) على أنه إذا تعمد الواهب إخفاء العيب، أو ضمن خلو الشيء الموهوب من العيوب، كان ملزما بتعويض الموهوب له عن الضرر الذى يسببه العيب. ويكون كذلك ملزما بالتعويض إذا كانت الهبة بعوض على ألا يجاوز التعويض فى هذه الحالة قدر ما أداه الموهوب له من هذا العوض.$b495$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins495;

WITH ins496 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 496, 0, $h496$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 2- آثار الهبة$h496$, $b496$لا يكون الواهب مسئولا إلا عن فعله العمد أو خطئه الجسيم.$b496$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins496;

WITH ins497 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 497, 0, $h497$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 2- آثار الهبة$h497$, $b497$يلتزم الموهوب له بأداء ما اشترط عليه سواء اشترط هذا العوض لمصلحة الواهب أو لمصلحة أجنبى أم للمصلحة العامة.$b497$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins497;

WITH ins498 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 498, 0, $h498$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 2- آثار الهبة$h498$, $b498$إذا تبين أن الشيء الموهوب أقل فى القيمة من العوض المشترط، فلا يكون الموهوب له ملزما بأن يؤدى من هذا العوض إلا بقدر قيمة الشيء الموهوب.$b498$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins498;

WITH ins499 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 499, 0, $h499$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 2- آثار الهبة$h499$, $b499$إذا اشترط الواهب عوضا عن الهبة وفاء دينه، فلا يكون الموهوب له ملزما لوفاء الدين إلا بقدر الدين الذى يلتزم بوفائه، ما لم يوجد اتفاق على غير ذلك.$b499$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins499;

WITH ins500 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 500, 0, $h500$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 3- الرجوع فى الهبة$h500$, $b500$(1) يجوز للواهب أن يرجع فى الهبة إذا قبل الموهوب له ذلك.
(2) فإذا لم يقبل الموهوب له جاز للواهب أن يطلب من القضاء الترخيص له فى الرجوع متى كان يستند فى ذلك إلى عذر مقبول ولم يوجد مانع من الرجوع.$b500$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins500;

WITH ins501 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 501, 0, $h501$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 3- الرجوع فى الهبة$h501$, $b501$يعتبر بنوع خاص عذرا مقبولا للرجوع فى الهبة:
(أ) أن يخل الموهوب له بما يجب عليه نحو الواهب، أو نحو أحد أقاربه، بحيث يكون هذا الإخلال جحودا كبيرا من جانبه.
(ب) أن يصبح الواهب عاجزا عن أن يوفر لنفسه أسباب المعيشة بما يتفق مع مكانته الاجتماعية، أو أن يصبح غير قادر على الوفاء بما يفرضه القانون من النفقة على الغير.
(جـ) أن يرزق الواهب بعد الهبة ولدا ظل حيا إلى وقت الرجوع، أو أن يكون للواهب ولد كان يظنه ميتا فإذا به حى.$b501$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins501;

WITH ins502 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 502, 0, $h502$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 3- الرجوع فى الهبة$h502$, $b502$يرفض طلب الرجوع فى الهبة إذا وجد مانع من الموانع الآتية:
(أ) إذا حصل للموهوب له زيادة متصلة موجبة لزيادة قيمته فإذا زال المانع عاد حق الرجوع.
(ب) إذا مات أحد طرفى عقد الهبة.
(جـ) إذا تصرف الموهوب له فى الشيء الموهوب تصرفا نهائيا، فإذا اقتصر التصرف على بعض الشيء، جاز للواهب أن يرجع فى الباقى.
(د) إذا كانت الهبة من أحد الزوجين للآخر وأراد الواهب الرجوع بعد انقضاء الزوجية.
(هـ) إذا كانت الهبة لذى رحم محرم.
(و) إذا هلك الشيء الموهوب فى يد الموهوب له، سواء كان هلاكه بفعله أو بحادث أجنبى لا يد له فيه، فإذا لم يهلك إلا بعض الشيء، جاز الرجوع فى الباقى.
(ز) إذا قدم الموهوب له عوضا عن الهبة.
(حـ) إذا كانت الهبة صدقة أو عملا من أعمال البر.$b502$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins502;

WITH ins503 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 503, 0, $h503$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 3- الرجوع فى الهبة$h503$, $b503$(1) يترتب على الرجوع فى الهبة بالتراضى أو بالتقاضى أن تعتبر الهبة كأن لم تكن.
(2) ولا يرد الموهوب له الثمرات إلا من وقت الاتفاق على الرجوع، أو من وقت رفع الدعوى، وله أن يرجع بجميع ما أنفقه من مصروفات ضرورية، أما المصروفات النافعة فلا يجاوز الرجوع بها القدر الذى زاد فى قيمة الشيء الموهوب.$b503$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins503;

WITH ins504 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 504, 0, $h504$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الثالث - الهبة > 3- الرجوع فى الهبة$h504$, $b504$(1) إذا استولى الواهب على الشيء الموهوب، بغير التراضى أو التقاضى، كان مسئولا قبل الموهوب له عن هلاك الشيء سواء كان الهلاك بفعل الواهب أو بسبب أجنبى لا يد له فيه أو بسبب الاستعمال.
(2) أما إذا صدر الحكم بالرجوع فى الهبة وهلك الشيء فى يد الموهوب له بعد إعذاره بالتسليم، فيكون الموهوب له مسئولا عن هذا الهلاك، ولو كان هذا الهلاك بسبب أجنبى.$b504$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins504;

WITH ins505 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 505, 0, $h505$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة$h505$, $b505$الشركة عقد بمقتضاه يلتزم شخصان أو أكثر بأن يساهم كل منهم فى مشروع مالى، بتقديم حصة من مال أو من عمل، لاقتسام ما قد ينشأ عن هذا المشروع من ربح أو من خسارة.$b505$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins505;

WITH ins506 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 506, 0, $h506$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة$h506$, $b506$(1) تعتبر الشركة بمجرد تكوينها شخصا اعتباريا ولكن لا يحتج بهذه الشخصية على الغير إلا بعد استيفاء إجراءات النشر التى يقررها القانون.
(2) ومع ذلك للغير إذا لم تقم الشركة بإجراءات النشر المقررة أن يتمسك بشخصيتها.$b506$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins506;

WITH ins507 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 507, 0, $h507$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h507$, $b507$(1) يجب أن يكون عقد الشركة مكتوبا وإلا كان باطلا، وكذلك يكون باطلا كل ما يدخل على العقد من تعديلات دون أن تستوفى الشكل الذى أفرغ فيه ذلك العقد.
(2) غير أن هذا البطلان لا يجوز أن يحتج به قبل الشركاء الغير ولا يكون له أثر فيما بين الشركاء أنفسهم، إلا من وقت أن يطلب الشريك الحكم بالبطلان.$b507$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins507;

WITH ins508 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 508, 0, $h508$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h508$, $b508$تعتبر حصص الشركاء متساوية القيمة إذا كانت واردة على ملكية المال أو مجرد الانتفاع به، ما لم يوجد اتفاق أو عرف يقضى بغير ذلك.$b508$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins508;

WITH ins509 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 509, 0, $h509$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h509$, $b509$لا يجوز أن تقتصر حصة الشريك على ما يكون له من نفوذ أو على ما يتمتع به من ثقة مالية.$b509$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins509;

WITH ins510 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 510, 0, $h510$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h510$, $b510$إذا تعهد الشريك بأن يقدم حصته فى الشركة مبلغا من النقود، ولم يقدم هذا المبلغ لزمته فوائده من وقت أن يكون للشركة مطالبة إلى حاجة قضائية أو إعذار، وذلك دون إخلال بما قد يستحق من تعويض تكميلى عند الاقتضاء.$b510$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins510;

WITH ins511 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 511, 0, $h511$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h511$, $b511$(1) إذا كانت حصة الشريك حق ملكية أو حق منفعة أو أى حق عينى آخر، فإن أحكام البيع هى التى تسرى فى ضمان هذه الحصة إذا هلكت، أو ظهر فيها عيب، أو استحقت.
(2) أما إذا كانت الحصة مجرد الانتفاع بالمال، فإن أحكام الإيجار هى التى تسرى فى كل ذلك.$b511$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins511;

WITH ins512 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 512, 0, $h512$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h512$, $b512$(1) إذا تعهد الشريك بأن يقدم حصته فى الشركة عملا وجب عليه أن يقوم بالخدمات التى تعهد بها، وأن يقدم حسابا عما يكون قد كسبه من مزاولته العمل الذى قدمه حصة له.
(2) على أنه لا يكون ملزما بأن يقدم للشركة ما يكون قد حصل عليه من حق اختراع، إلا إذا وجد اتفاق يقضى بغير ذلك.$b512$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins512;

WITH ins513 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 513, 0, $h513$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h513$, $b513$إذا كانت الحصة التى قدمها الشريك هى ديون له فى ذمة الغير، فلا ينقضى التزامه للشركة إلا إذا استوفيت هذه الديون، ويكون الشريك مسئولا فوق ذلك عن تعويض الضرر، إذا لم توف الديون عند حلول أجلها.$b513$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins513;

WITH ins514 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 514, 0, $h514$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h514$, $b514$(1) إذا لم يبين عقد الشركة نصيب كل من الشركاء فى الأرباح والخسائر، كان نصيب كل منهم فى ذلك بنسبة حصته فى رأس المال.
(2) فإذا اقتصر العقد على تعيين نصيب الشركاء فى الربح وجب اعتبار هذا النصيب فى الخسارة أيضا، وكذلك الحال إذا اقتصر العقد على تعيين النصيب فى الخسارة.
(3) وإذا كانت حصة أحد الشركاء مقصورة على عمله، وجب أن يقدر نصيبه فى الربح والخسارة تبعا بما تفيده الشركة من هذا العمل، فإذا قدم العمل فوق نصيبه كان له شىء آخر، كان له نصيب عن العمل وآخر عما قدمه فوقه.$b514$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins514;

WITH ins515 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 515, 0, $h515$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 1- أركان الشركة$h515$, $b515$(1) إذا اتفق على أن يبقى أحد الشركاء لا يساهم فى أرباح الشركة أو فى خسائرها، كان عقد الشركة باطلا.
(2) ويجوز الاتفاق على إعفاء الشريك الذى لم يقدم غير عمله من المساهمة فى الخسائر، بشرط ألا يكون قد تقرر له أجر عن عمله.$b515$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins515;

WITH ins516 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 516, 0, $h516$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 2- إدارة الشركة$h516$, $b516$(1) للشريك المنتدب للإدارة بنص خاص فى عقد الشركة أن يقوم، بالرغم من معارضة سائر الشركاء، بأعمال الإدارة وبالتصرفات التى تدخل فى غرض الشركة، متى كانت أعماله وتصرفاته خالية من الغش. ولا يجوز عزل هذا الشريك من الإدارة دون مسوغ مادامت الشركة باقية.
(2) وإذا كان انتداب الشريك للإدارة لاحقا لعقد الشركة، جاز الرجوع فيه كما يجوز فى التوكيل العادى.
(3) أما المديرون من غير الشركاء فهم دائما قابلون للعزل.$b516$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins516;

WITH ins517 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 517, 0, $h517$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 2- إدارة الشركة$h517$, $b517$(1) إذا تعدد الشركاء المنتدبون للإدارة دون أن يعين اختصاص كل منهم ودون أن ينص على عدم جواز أن يعمل أى منهم بالإدارة منفردا، كان لكل منهم أن يقوم منفردا بأى عمل من أعمال الإدارة إلا أن يعترض عليه قبل تمامه باقى الشركاء المنتدبين، وعلى أن يكون من حق أغلبية الشركاء المنتدبين رفض هذا الاعتراض، فإذا تساوى الجانبان كان الرفض من حق أغلبية الشركاء جميعا.
(2) أما إذا اتفق على أن تكون قرارات المنتدبين للإدارة بالإجماع أو بالأغلبية، فلا يجوز الخروج على ذلك، إلا أن يكون لأمر عاجل على تفويته خسارة جسيمة لا تستطيع الشركة تعويضها.$b517$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins517;

WITH ins518 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 518, 0, $h518$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 2- إدارة الشركة$h518$, $b518$إذا وجب أن يصدر قرار بالأغلبية، تعين الأخذ بالأغلبية العددية ما لم يتفق على غير ذلك.$b518$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins518;

WITH ins519 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 519, 0, $h519$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 2- إدارة الشركة$h519$, $b519$الشركاء غير المديرين ممنوعون من الإدارة وكل اتفاق على غير ذلك باطل.$b519$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins519;

WITH ins520 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 520, 0, $h520$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 2- إدارة الشركة$h520$, $b520$إذا لم يوجد نص خاص على طريقة الإدارة، اعتبر كل شريك مفوضا من الآخرين فى الإدارة، وكان لأى منهم حق الاعتراض على أى عمل قبل تمامه ولأغلبية الشركاء الحق فى رفض هذا الاعتراض.$b520$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins520;

WITH ins521 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 521, 0, $h521$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 3- آثار الشركة$h521$, $b521$(1) على الشريك أن يمتنع عن أى نشاط يلحق الضرر بالشركة، أو يكون مخالفا للغرض الذى أنشئت لتحقيقه.
(2) وعليه أن يبذل من العناية فى تدبير مصالح الشركة ما يبذله فى تدبير مصالحه الخاصة، إلا إذا كان منتدبا للإدارة بأجر فلا يجوز له أن ينزل فى ذلك عن عناية الرجل المعتاد.$b521$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins521;

WITH ins522 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 522, 0, $h522$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 3- آثار الشركة$h522$, $b522$(1) إذا أخذ الشريك أو احتجز مبلغا من مال الشركة، لزمته فوائد هذا المبلغ من يوم أخذه أو احتجازه، بغير حاجة إلى مطالبة قضائية أو إعذار وذلك دون إخلال بما قد يستحق من تعويض تكميلى عند الاقتضاء.
(2) وإذا أمد الشريك الشركة من ماله، أو أنفق فى مصلحتها شيئا من المصروفات النافعة عن حسن نية وتبصر، وجبت له على الشركة فوائد هذه المبالغ من يوم دفعها.$b522$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins522;

WITH ins523 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 523, 0, $h523$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 3- آثار الشركة$h523$, $b523$(1) إذا لم تف أموال الشركة بديونها، كان الشركاء مسئولين عن هذه الديون فى أموالهم الخاصة، كل منهم بنسبة نصيبه فى خسائر الشركة، ما لم يوجد اتفاق على نسبة أخرى.
(2) وفى كل حال يكون لدائنى الشركة حق مطالبة الشركاء كل بقدر الحصة التى تخصصت له فى أرباح الشركة.$b523$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins523;

WITH ins524 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 524, 0, $h524$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 3- آثار الشركة$h524$, $b524$(1) لا تضامن بين الشركاء فيما يلزم كل منهم من ديون الشركة، ما لم يتفق على خلاف ذلك.
(2) غير أنه إذا أعسر أحد الشركاء وزعت حصته فى الدين على الباقين، كل بقدر نصيبه فى تحمل الخسارة.$b524$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins524;

WITH ins525 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 525, 0, $h525$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 3- آثار الشركة$h525$, $b525$إذا كان لأحد الشركاء دائنون شخصيون، فليس لهم أثناء قيام الشركة أن يتقاضوا حقوقهم مما يخص ذلك الشريك من رأس المال، وإنما لهم أن يتقاضوا ما يخصه مما فى الأرباح، أما بعد تصفية الشركة فيكون لهم أن يتقاضوا حقوقهم فى نصيب مدينهم فى أموال الشركة بعد استنزال ديونها. ومع ذلك يجوز لهم قبل التصفية توقيع الحجز التحفظى على نصيب هذا المدين.$b525$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins525;

WITH ins526 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 526, 0, $h526$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 4- طرق انقضاء الشركة$h526$, $b526$(1) تنتهى الشركة بانقضاء الميعاد المعين لها أو بانتهاء العمل الذى قامت من أجله.
(2) فإذا انقضت المدة المعينة أو انتهى العمل ثم استمر الشركاء يقومون بعمل من نوع الأعمال التى تألفت لها الشركة، امتد العقد سنة فسنة بالشروط ذاتها.
(3) ويجوز لدائنى أحد الشركاء أن يعترضوا على هذا الامتداد ويترتب على اعتراضهم وقف أثره فى حقهم.$b526$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins526;

WITH ins527 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 527, 0, $h527$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 4- طرق انقضاء الشركة$h527$, $b527$(1) تنتهى الشركة بهلاك جميع مالها أو جزء كبير منه بحيث لا تبقى فائدة فى استمرارها.
(2) وإذا كان أحد الشركاء قد تعهد بأن يقدم حصته شيئا معينا بالذات وهلك هذا الشيء قبل تقديمه، أصبحت الشركة منحلة فى حق جميع الشركاء.$b527$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins527;

WITH ins528 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 528, 0, $h528$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 4- طرق انقضاء الشركة$h528$, $b528$(1) تنتهى الشركة بموت أحد الشركاء أو بالحجر عليه أو بإعساره أو بإفلاسه.
(2) ومع ذلك يجوز الاتفاق على أنه إذا مات أحد الشركاء تستمر الشركة مع ورثته ولو كانوا قصرا.
(3) ويجوز أيضا الاتفاق على أنه إذا مات أحد الشركاء أو حجر عليه أو أفلس أو انسحب وفقا لأحكام المادة التالية، تستمر الشركة فيما بين الباقين، وفى هذه الحالة لا يكون لهذا الشريك أو ورثته إلا نصيبه فى أموال الشركة، يقدر هذا النصيب بحسب قيمته يوم وقوع الحادث الذى أدى إلى خروجه من الشركة ويدفع له نقدا، ولا يكون له نصيب فيما يستجد بعد ذلك من حقوق، إلا بقدر ما تكون تلك الحقوق ناتجة من عمليات سابقة على ذلك الحادث.$b528$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins528;

WITH ins529 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 529, 0, $h529$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 4- طرق انقضاء الشركة$h529$, $b529$(1) تنتهى الشركة بانسحاب أحد الشركاء، إذا كانت مدتها غير معينة، على أن يعلن الشريك إرادته فى الانسحاب إلى سائر الشركاء قبل حصوله، وألا يكون انسحابه فى وقت غير لائق أو عن غش.
(2) وتنتهى أيضا بإجماع الشركاء على حلها.$b529$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins529;

WITH ins530 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 530, 0, $h530$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 4- طرق انقضاء الشركة$h530$, $b530$(1) يجوز للمحكمة أن تقضى بحل الشركة بناء على طلب أحد الشركاء، لعدم وفاء شريك بما تعهد به أو لأى سبب آخر يرجع إلى الشركاء، ويقدر القاضى ما ينطوى عليه هذا السبب من خطورة تسوغ الحل.
(2) ويكون باطلا كل اتفاق يقضى بغير ذلك.$b530$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins530;

WITH ins531 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 531, 0, $h531$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 4- طرق انقضاء الشركة$h531$, $b531$(1) يجوز لكل شريك أن يطلب من القضاء الحكم بفصل أى من الشركاء يكون وجوده فى الشركة قد أثار آثارا من أجلها أو تكون تصرفاته مما يمكن اعتباره سببا مسوغا لحل الشركة، على أن تظل الشركة قائمة فيما بين الباقين.
(2) ويجوز أيضا لأى شريك، إذا كانت الشركة معينة المدة أن يطلب من القضاء إخراجه منها متى استند فى ذلك إلى أسباب معقولة، وفى هذه الحالة تنحل الشركة ما لم يتفق باقى الشركاء على استمرارها.$b531$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins531;

WITH ins532 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 532, 0, $h532$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 5- تصفية الشركة وقسمتها$h532$, $b532$تتم تصفية أموال الشركة وقسمتها بالطريقة المبينة فى العقد. وعند خلوه من حكم خاص تتبع الأحكام الآتية:$b532$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins532;

WITH ins533 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 533, 0, $h533$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 5- تصفية الشركة وقسمتها$h533$, $b533$تنتهى عند حل الشركة سلطة المديرين، أما شخصية الشركة فتبقى بالقدر اللازم للتصفية وإلى أن تنتهى هذه التصفية.$b533$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins533;

WITH ins534 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 534, 0, $h534$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 5- تصفية الشركة وقسمتها$h534$, $b534$(1) يقوم بالتصفية عند الاقتضاء، أما جميع الشركاء، وأما مصف واحد أو أكثر تعينهم أغلبية الشركاء.
(2) وإذا لم يتفق الشركاء على تعيين المصفى، تولى القاضى تعيينه، بناء على طلب أحدهم.
(3) وفى الحالات التى تكون فيها الشركة باطلة تعين المحكمة المصفى، وتحدد طريقة التصفية، بناء على طلب كل ذى شأن.
(4) وحتى يتم تعيين المصفى يعتبر المديرون بالنسبة إلى الغير فى حكم المصفين.$b534$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins534;

WITH ins535 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 535, 0, $h535$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 5- تصفية الشركة وقسمتها$h535$, $b535$(1) ليس للمصفى أن يبدأ أعمالا جديدة للشركة، إلا أن تكون لازمة لاتمام أعمال سابقة.
(2) ويجوز له أن يبيع مال الشركة منقولا أو عقارا إما بالمزاد وإما بالممارسة، ما لم ينص فى أمر تعيينه على تقييد هذه السلطة.$b535$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins535;

WITH ins536 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 536, 0, $h536$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 5- تصفية الشركة وقسمتها$h536$, $b536$(1) تقسم أموال الشركة بين الشركاء جميعا وذلك بعد استيفاء الدائنين لحقوقهم، وبعد استنزال المبالغ اللازمة لوفاء الديون التى لم تحل أو الديون المتنازع فيها، وبعد رد المصروفات أو القروض التى يكون أحد الشركاء قد باشرها فى مصلحة الشركة.
(2) وتختص كل واحد من الشركاء بمبلغ يعادل قيمة الحصة التى قدمها فى رأس المال، كما هى مبينة فى العقد، أو يعادل هذه القيمة وقت تسليمها إذا لم تبين قيمتها فى العقد، ما لم يكن الشريك قد اقتصر على تقديم عمله، أو اقتصر فيما قدمه على حق المنفعة فيه أو على مجرد الانتفاع به.
(3) وإذا بقى شىء بعد ذلك وجبت قسمته بين الشركاء بنسبة نصيب كل منهم فى الأرباح.
(4) أما إذا لم يكف صافى مال الشركة للوفاء بحصص الشركاء فإن الخسارة توزع عليهم جميعا بحسب النسبة المتفق عليها فى توزيع الخسائر.$b536$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins536;

WITH ins537 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 537, 0, $h537$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الرابع - الشركة > 5- تصفية الشركة وقسمتها$h537$, $b537$تتبع فى قسمة الشركات القواعد المتعلقة بقسمة المال الشائع.$b537$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins537;

WITH ins538 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 538, 0, $h538$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 1- القرض$h538$, $b538$القرض عقد يلتزم به المقرض أن ينقل إلى المقترض ملكية مبلغ من النقود أو أى شيء مثلى آخر، على أن يرد إليه المقترض عند نهاية القرض شيئا مثله فى مقداره ونوعه وصفته.$b538$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins538;

WITH ins539 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 539, 0, $h539$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 1- القرض$h539$, $b539$(1) يجب على المقرض أن يسلم للمقترض العين موضوع العقد فى الوقت المحدد، ولا يجوز له أن يطالبه برد المثل إلا عند انتهاء القرض.
(2) وإذا هلك الشيء قبل تسليمه إلى المقترض كان الهلاك على المقرض.$b539$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins539;

WITH ins540 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 540, 0, $h540$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 1- القرض$h540$, $b540$إذا استحق الشيء، فإن كان القرض بأجر سرت أحكام البيع، وإلا فأحكام العارية.$b540$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins540;

WITH ins541 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 541, 0, $h541$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 1- القرض$h541$, $b541$(1) إذا ظهر فى الشيء عيب خفى وكان القرض بغير أجر واختار المقترض استبقاء الشيء فلا يلزمه أن يرد إلا قيمة الشيء معيبا.
(2) أما إذا كان القرض بأجر، أو كان المقرض قد تعمد إخفاء العيب، كان للمقترض أن يطلب إما إصلاح العيب أو استبدال شىء سليم بالشيء المعيب.$b541$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins541;

WITH ins542 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 542, 0, $h542$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 1- القرض$h542$, $b542$على المقترض أن يدفع الفوائد المتفق عليها عند حلول مواعيد استحقاقها، فإذا لم يكن هناك اتفاق على فوائد اعتبر القرض بغير أجر.$b542$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins542;

WITH ins543 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 543, 0, $h543$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 1- القرض$h543$, $b543$ينتهى القرض بانتهاء الميعاد المتفق عليه.$b543$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins543;

WITH ins544 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 544, 0, $h544$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 1- القرض$h544$, $b544$إذا اتفق على الفوائد، كان للمدين إذا انقضت سنة أن يعلن رغبته فى إلغاء العقد ورد ما اقترضه، على أن يتم الرد فى أجل لا يجاوز ستة أشهر من تاريخ هذا الإعلان، وفى هذه الحالة يلزم المدين بأداء الفوائد المستحقة عن ستة الأشهر التالية للإعلان، ولا يجوز بوجه من الوجوه إلزامه بأداء فائدة أو مقابل من أى نوع بسبب تعجيل الوفاء، ولا يجوز الاتفاق على إسقاط حق المقترض فى الرد أو الحد منه.$b544$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins544;

WITH ins545 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 545, 0, $h545$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 2- الدخل الدائم$h545$, $b545$(1) يجوز أن يتعهد شخص بأن يؤدى على الدوام إلى شخص آخر وإلى خلفائه من بعده دخلا دوريا يكون مبلغا من النقود أو مقدارا معينا من أشياء مثلية أخرى، ويكون هذا التعهد بعقد من عقود المعاوضة أو التبرع أو بطريق الوصية.
(2) فإذا كان ترتيب الدخل الدائم بعقد من عقود المعاوضة، اتبع فى شأنه من حيث سعر الفائدة القواعد التى تسرى على القرض ذى الفائدة.$b545$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins545;

WITH ins546 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 546, 0, $h546$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 2- الدخل الدائم$h546$, $b546$(1) يشترط فى الدخل الدائم أن يكون الاستبدال قابلا فى أى وقت يشاء المدين، ويقع كل اتفاق بغير ذلك باطلا.
(2) غير أنه يجوز الاتفاق على ألا يحصل الاستبدال مادام مستحق الدخل حيا، أو على ألا يحصل قبل انقضاء مدة لا تزيد على خمس عشرة سنة.
(3) وفى كل حالة لا يجوز استعمال حق الاستبدال إلا بعد إعلان الرغبة فى ذلك، وانقضاء سنة على هذا الإعلان.$b546$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins546;

WITH ins547 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 547, 0, $h547$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 2- الدخل الدائم$h547$, $b547$يجبر المدين على الاستبدال فى الأحوال الآتية:
(أ) إذا لم يدفع الدخل لسنتين متواليتين رغم إعذاره.
(ب) إذا قصر فيما وعد به الدائن من ضمانات أو إذا انعدمت التأمينات ولم يقدم بديلا عنها.
(جـ) إذا أفلس أو أعسر.$b547$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins547;

WITH ins548 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 548, 0, $h548$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل الخامس - القرض والدخل الدائم > 2- الدخل الدائم$h548$, $b548$(1) إذا رتب الدخل مقابل مبلغ من النقود، تم الاستبدال برد المبلغ بتمامه، أو برد مبلغ أقل منه إذا اتفق على ذلك.
(2) وفى الحالات الأخرى يتم الاستبدال بدفع مبلغ من النقود تكون فائدته محسوبة بالسعر القانونى مساوية للدخل.$b548$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins548;

WITH ins549 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 549, 0, $h549$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 1- أركان الصلح$h549$, $b549$الصلح عقد يحسم به الطرفان نزاعا قائما أو يتوقيان به نزاعا محتملا، وذلك بأن ينزل كل منهما على وجه التقابل عن جزء من ادعائه.$b549$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins549;

WITH ins550 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 550, 0, $h550$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 1- أركان الصلح$h550$, $b550$يشترط فيمن يعقد صلحا أن يكون أهلا للتصرف بعوض فى الحقوق التى يشملها عقد الصلح.$b550$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins550;

WITH ins551 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 551, 0, $h551$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 1- أركان الصلح$h551$, $b551$لا يجوز الصلح فى المسائل المتعلقة بالحالة الشخصية والتقادم العام. ولكن يجوز الصلح على المصالح المالية التى تترتب على الحالة الشخصية، أو التى تنشأ عن ارتكاب إحدى الجرائم.$b551$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins551;

WITH ins552 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 552, 0, $h552$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 1- أركان الصلح$h552$, $b552$لا يثبت الصلح إلا بالكتابة أو بمحضر رسمى.$b552$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins552;

WITH ins553 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 553, 0, $h553$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 2- آثار الصلح$h553$, $b553$(1) تنحسم بالصلح المنازعات التى تناولها.
(2) ويترتب عليه انقضاء الحقوق والادعاءات التى نزل عنها أى من المتعاقدين نزولا نهائيا.$b553$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins553;

WITH ins554 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 554, 0, $h554$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 2- آثار الصلح$h554$, $b554$للصلح أثر كاشف بالنسبة إلى ما تناوله من الحقوق ويقتصر هذا الأثر على الحقوق المتنازع فيها دون غيرها.$b554$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins554;

WITH ins555 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 555, 0, $h555$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 2- آثار الصلح$h555$, $b555$يجب أن تفسر عبارات التنازل التى يتضمنها الصلح تفسيرا ضيقا، وأيا كانت تلك العبارات فإن التنازل لا ينصب إلا على الحقوق التى كانت محلا للنزاع الذى حسمه الصلح.$b555$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins555;

WITH ins556 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 556, 0, $h556$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 3- بطلان الصلح$h556$, $b556$لا يجوز الطعن فى الصلح بسبب غلط فى القانون.$b556$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins556;

WITH ins557 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 557, 0, $h557$الكتاب الثانى - العقود المسماة > الباب الأول - العقود التى تقع على الملكية > الفصل السادس - الصلح > 3- بطلان الصلح$h557$, $b557$(1) الصلح لا يتجزأ، فبطلان جزء منه يقتضى بطلان العقد كله.
(2) على أن هذا الحكم لا يسرى إذا تبين من عبارات العقد، أو من الظروف، أن المتعاقدين اتفقا على أن أجزاء العقد مستقلة بعضها عن بعض.$b557$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins557;

WITH ins558 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 558, 0, $h558$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > أركان الإيجار$h558$, $b558$الإيجار عقد يلتزم المؤجر بمقتضاه أن يمكن المستأجر من الانتفاع بشىء معين مدة معينة لقاء أجر معلوم.$b558$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins558;

WITH ins559 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 559, 0, $h559$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > أركان الإيجار$h559$, $b559$لا يجوز لمن لا يملك إلا حق الإدارة أن يعقد إيجارا تزيد مدته على ثلاث سنوات إلا بترخيص من السلطة المختصة، فإذا عقد الإيجار لمدة أطول من ذلك، انتقصت المدة إلى ثلاث سنوات، كل هذا ما لم يوجد نص يقضى بغيره.$b559$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins559;

WITH ins560 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 560, 0, $h560$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > أركان الإيجار$h560$, $b560$الإجارة الصادرة ممن له حق المنفعة تنتهى بانقضاء هذا الحق إذا لم يحرز مالك الرقبة هذا الإنهاء، على أن تراعى المواعيد المقررة للتنبيه بالإخلاء والمواعيد اللازمة لنقل محصول السنة.$b560$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins560;

WITH ins561 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 561, 0, $h561$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > أركان الإيجار$h561$, $b561$يجوز أن تكون الأجرة نقودا كما يجوز أن تكون أى قيمة أخرى.$b561$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins561;

WITH ins562 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 562, 0, $h562$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > أركان الإيجار$h562$, $b562$إذا لم يتفق المتعاقدان على مقدار الأجرة أو على كيفية تقديرها، وجب إثبات مقدار الأجرة، أو إذا تعذر إثبات أجرة المثل.$b562$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins562;

WITH ins563 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 563, 0, $h563$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > أركان الإيجار$h563$, $b563$إذا عقد الإيجار دون اتفاق على مدة معينة أو لمدة غير معينة، اعتبر الإيجار منعقدا للفترة المعينة لدفع الأجرة. وينتهى الإيجار بانقضاء هذه الفترة بناء على طلب أحد المتعاقدين إذا هو نبه المتعاقد الآخر بالإخلاء وفقا للمواعيد الآتى بيانها:
(أ) فى الأراضى الزراعية والأراضى البور إذا كانت المدة المعينة لدفع الأجرة ستة أشهر أو أكثر، وجب التنبيه قبل انتهائها بثلاثة أشهر، فإذا كانت المدة أقل من ذلك وجب التنبيه قبل نصفها، كل هذا مع مراعاة حق المستأجر فى دفع الأجرة وفقا للمحصول وفقا للعرف.
(ب) فى المنازل والحوانيت والمكاتب والمتاجر والمصانع والمخازن إذا كانت الفترة المعينة لدفع الأجرة أربعة أشهر أو أكثر وجب التنبيه قبل انتهائها بشهرين، فإذا كانت الفترة أقل من ذلك وجب التنبيه قبل نصفها.
(جـ) فى المساكن والغرف المؤثثة وفى أى شىء غير ما تقدم إذا كانت الفترة المعينة لدفع الأجرة شهرين أو أكثر، وجب التنبيه قبل انتهائها نهائيا بشهر، فإذا كانت المدة أقل من ذلك وجب التنبيه قبل نصفها الأخير.$b563$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins563;

WITH ins564 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 564, 0, $h564$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h564$, $b564$يلتزم المؤجر أن يسلم المستأجر العين المؤجرة وملحقاتها فى حالة تصلح معها لأن تفى بما أعدت له من المنفعة، وفقا لما اتفق عليه أو لطبيعة العين.$b564$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins564;

WITH ins565 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 565, 0, $h565$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h565$, $b565$(1) إذا سلمت العين المؤجرة فى حالة لا تكون فيها صالحة للانتفاع الذى أوجرت من أجله أو إذا نقص هذا الانتفاع نقصا كبيرا، جاز للمستأجر أن يطلب فسخ العقد إذا كان ذلك لا ينطوى على ما يخالف ذلك.
(2) فإذا كانت العين المؤجرة فى حالة من شأنها أن تعرض صحة المستأجر أو من يعيشون معه أو مستخدميه لعمله خطر جسيم، جاز للمستأجر أن يطلب فسخ العقد، ولو كان قد سبق له أن نزل عن هذا الحق.$b565$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins565;

WITH ins566 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 566, 0, $h566$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h566$, $b566$يسرى على التزام المؤجر بتسليم العين المؤجرة ما يسرى على الالتزام بتسليم العين المبيعة، وعلى الأخص ما يتعلق منها بزمان التسليم ومكانه وتحديد مقدار العين المؤجرة وتحديد ملحقاتها.$b566$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins566;

WITH ins567 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 567, 0, $h567$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h567$, $b567$(1) على المؤجر أن يتعهد العين المؤجرة لتبقى على الحالة التى سلمت بها وأن يقوم فى أثناء الإجارة بجميع الترميمات الضرورية دون الترميمات "التأجيرية".
(2) وعليه أن يجرى الأعمال اللازمة للسطح من تخصيص أو بياض وأن يقوم بنزح الآبار والمراحيض ومصاريف المياه.
(3) ويتحمل المؤجر التكاليف والضرائب المستحقة على العين المؤجرة ويلزم بثمن المياه إذا قدر جزافا، أما إذا كان تقديره "بالعداد" كان على المستأجر، أما ثمن الكهرباء والغاز وغير ذلك مما هو خاص بالاستعمال الشخصى فيتحمله المستأجر.
(4) كل هذا ما لم يقض الاتفاق بغيره.$b567$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins567;

WITH ins568 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 568, 0, $h568$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h568$, $b568$(1) إذا تأخر المؤجر بعد إعذاره عن القيام بتنفيذ الالتزامات المبينة فى المادة السابقة، جاز للمستأجر أن يحصل على ترخيص من القضاء فى إجراء ذلك بنفسه وفى استيفاء ما أنفقه خصما من الأجرة، وهذا دون إخلال بحقه فى طلب الفسخ أو إنقاص الأجرة.
(2) ويجوز للمستأجر دون حاجة إلى ترخيص من القضاء أن يقوم بإجراء الترميمات المستعجلة البسيطة أو الترميمات التى يلتزم بها المؤجر مما لا يلزم به المؤجر، سواء أكان العيب موجودا وقت بدء الانتفاع أو طرأ عليه بعد ذلك، إذا لم يقم المؤجر بعد إعذاره بتنفيذ هذا الالتزام فى الميعاد المناسب، على أن يستوفى ما أنفقه خصما من الأجرة.$b568$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins568;

WITH ins569 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 569, 0, $h569$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h569$, $b569$(1) إذا هلكت العين المؤجرة أثناء الإيجار هلاكا كليا، انفسخ العقد من تلقاء نفسه.
(2) أما إذا هلكت العين جزئيا، أو إذا أصبحت العين المؤجرة لا تصلح معها للانتفاع الذى أجرت من أجله، أو نقص هذا الانتفاع نقصا كبيرا، سواء كان ذلك بسبب أجنبى أو بفعل المؤجر أو بسبب من شىء فى يد المستأجر، فيجوز له، إذا لم يقم المؤجر بإعادة العين إلى الحالة التى كانت عليها، تبعا للظروف إما أن يطلب فسخ الإيجار أو إنقاص الأجرة دون إخلال بما له من حق فى أن يقوم بنفسه بتنفيذ التزام المؤجر وفقا لأحكام المادة السابقة.
(3) ولا يجوز للمستأجر فى الحالتين السابقتين أن يطلب تعويضا إذا كان الهلاك أو التلف قد رجع إلى سبب لا يد للمؤجر فيه.$b569$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins569;

WITH ins570 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 570, 0, $h570$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h570$, $b570$(1) لا يجوز للمستأجر أن يمنع المؤجر من إجراء الترميمات المستعجلة التى تكون ضرورية لحفظ العين المؤجرة، على أنه إذا ترتب على هذه الترميمات إخلال كلى أو جزئى بالانتفاع بالعين، جاز للمستأجر أن يطلب تبعا للظروف إما فسخ الإيجار أو إنقاص الأجرة.
(2) ومع ذلك إذا بقى المستأجر فى العين المؤجرة إلى أن تتم الترميمات، سقط حقه فى طلب الفسخ.$b570$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins570;

WITH ins571 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 571, 0, $h571$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h571$, $b571$(1) على المؤجر أن يمتنع عن كل ما من شأنه أن يحول دون انتفاع المستأجر بالعين، ولا يجوز له أن يحدث بالعين أو بملحقاتها أى تغيير يخل بهذا الانتفاع.
(2) ولا يقتصر ضمان المؤجر على الأعمال التى تصدر منه، بل يمتد هذا الضمان إلى كل تعرض مبنى على سبب قانونى يصدر من أى مستأجر آخر أو من أى شخص آخر تلقى الحق من المؤجر.$b571$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins571;

WITH ins572 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 572, 0, $h572$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h572$, $b572$(1) إذا ادعى أجنبى حقا يتعارض مع ما للمستأجر من حقوق بمقتضى عقد الإيجار، وجب على المستأجر أن يبادر بإخطار المؤجر بذلك وكان له أن يخرج من الدعوى، وفى هذه الحالة لا توجه الإجراءات إلا إلى المؤجر.
(2) فإذا ترتب على هذا الادعاء أن حرم المستأجر فعلا من الانتفاع كله بموجب عقد الإيجار، جاز للمستأجر تبعا للظروف أن يطلب الفسخ أو إنقاص الأجرة مع التعويض إن كان له مقتضى.$b572$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins572;

WITH ins573 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 573, 0, $h573$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h573$, $b573$(1) إذا تعدد المستأجرون لعين واحدة فضل من سبق منهم إلى وضع يده عليها دون غش، فإذا كان مستأجر عقار قد سجل عقده وهو حسن النية قبل أن يضع مستأجر آخر يده على العقار المؤجر أو قبل أن يتجدد عقد إيجاره، فإنه هو الذى يفضل.
(2) فإذا لم يوجد سبب لتفضيل أحد المستأجرين فليس لمن تعارضت حقوقهم إلا طلب التعويض.$b573$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins573;

WITH ins574 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 574, 0, $h574$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h574$, $b574$إذا ترتب على عمل من جهة حكومية فى حدود القانون نقص كبير فى الانتفاع بالعين المؤجرة، جاز للمستأجر تبعا للظروف أن يطلب فسخ العقد أو إنقاص الأجرة، وله أن يطالب المؤجر بتعويضه إذا كان عمل الجهة الحكومية قد صدر لسبب يكون المؤجر مسئولا عنه، كل هذا ما لم يقض الاتفاق بغيره.$b574$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins574;

WITH ins575 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 575, 0, $h575$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h575$, $b575$(1) لا يضمن المؤجر للمستأجر التعرض المادى إذا صدر من أجنبى مادام المتعرض لا يدعى حقا، ولكن هذا لا يخل بما للمستأجر من الحق فى أن يرفع باسمه على المتعرض دعوى المطالبة بالتعويض وجميع دعاوى وضع اليد.
(2) على أنه إذا وقع التعرض المادى لسبب لا يد للمستأجر فيه، وكان هذا التعرض من العيوب التى يضمنها المؤجر، كان له أن يرجع عليه بمقتضى أحكام الضمان المنصوص عليها فى المواد المتعلقة بذلك.$b575$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins575;

WITH ins576 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 576, 0, $h576$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h576$, $b576$(1) يضمن المؤجر للمستأجر جميع ما يوجد فى العين المؤجرة من عيوب تحول دون الانتفاع بها، أو تنقص من هذا الانتفاع إنقاصا كبيرا ولكنه لا يضمن العيوب التى جرى العرف بالتسامح فيها. وهو مسئول عن خلو العين من صفات تعهد صراحة بتوافرها أو عن خلوها من صفات يقتضيها الانتفاع المقصود، كل هذا ما لم يقض الاتفاق بغيره.
(2) ومع ذلك لا يضمن المؤجر العيب إذا كان المستأجر قد أخطر به أو كان به العلم به وقت التعاقد.$b576$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins576;

WITH ins577 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 577, 0, $h577$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h577$, $b577$(1) إذا وجد بالعين المؤجرة عيب يتحقق معه الضمان، جاز للمستأجر تبعا للظروف أن يطلب فسخ العقد أو إنقاص الأجرة، وله كذلك أن يطلب إصلاح العيب أو أن يقوم هو بإصلاحه على نفقة المؤجر إذا كان هذا الإصلاح لا يبهظ المؤجر.
(2) فإذا لحق المستأجر ضرر من العيب التزم المؤجر بتعويضه، ما لم يثبت أنه كان يجهل وجود العيب.$b577$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins577;

WITH ins578 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 578, 0, $h578$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h578$, $b578$يقع باطلا كل اتفاق يتضمن الإعفاء أو الحد من ضمان التعرض أو العيب إذا كان المؤجر قد تعمد إخفاء سبب هذا الضمان.$b578$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins578;

WITH ins579 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 579, 0, $h579$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h579$, $b579$يلتزم المستأجر بأن يستعمل العين المؤجرة على النحو المتفق عليه، فإن لم يكن هناك اتفاق التزم بأن يستعمل العين بحسب ما أعدت له.$b579$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins579;

WITH ins580 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 580, 0, $h580$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h580$, $b580$(1) لا يجوز للمستأجر أن يحدث بالعين المؤجرة تغييرا بدون إذن المؤجر إلا إذا كان هذا التغيير لا ينشأ عنه أى ضرر للمؤجر.
(2) فإذا أحدث المستأجر تغييرا فى العين المؤجرة مجاوزا حدود الالتزام الوارد فى الفقرة السابقة، جاز إلزامه بإعادة العين إلى الحالة التى كانت عليها وبالتعويض عند الاقتضاء إن كان له مقتضى.$b580$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins580;

WITH ins581 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 581, 0, $h581$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h581$, $b581$(1) يجوز للمستأجر أن يضع بالعين المؤجرة أجهزة لتوصيل المياه والنور والكهربائى والغاز والتليفون والراديو وما إلى ذلك مادامت الطريقة التى توضع بها هذه الأجهزة لا تخالف الأصول المرعية، وذلك ما لم يثبت المؤجر أن وضع هذه الأجهزة يهدد بسلامة العقار.
(2) فإذا كان تدخل المؤجر لازما لإتمام شىء من ذلك، جاز للمستأجر أن يكلفه بما يقتضيه منه هذا التدخل.$b581$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins581;

WITH ins582 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 582, 0, $h582$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h582$, $b582$يلتزم المستأجر بإجراء الترميمات "التأجيرية" التى يقضى بها العرف، ما لم يكن هناك اتفاق على غير ذلك.$b582$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins582;

WITH ins583 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 583, 0, $h583$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h583$, $b583$(1) يجب على المستأجر أن يبذل من العناية فى استعمال العين المؤجرة وفى المحافظة عليها ما يبذله الشخص المعتاد.
(2) وهو مسئول عما يصيب العين أثناء انتفاعه بها من تلف أو هلاك غير ناشئ عن استعمالها استعمالا مألوفا.$b583$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins583;

WITH ins584 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 584, 0, $h584$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h584$, $b584$(1) المستأجر مسئول عن حريق العين المؤجرة إلا إذا أثبت أن الحريق نشأ عن سبب لا يد له فيه.
(2) فإذا تعدد المستأجرون لعقار واحد، كان كل منهم مسئولا عن الحريق بنسبة الجزء الذى يشغله، ويتناول ذلك المؤجر إن كان مقيما فى العقار، ما لم يثبت أبتدأ النار من الجزء الذى يشغله أحد المستأجرين فيكون مسئولا وحده عن الحريق.$b584$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins584;

WITH ins585 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 585, 0, $h585$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h585$, $b585$يجب على المستأجر أن يبادر إلى إخطار المؤجر بكل أمر يستوجب تدخله، كان العين تحتاج إلى ترميمات مستعجلة، أو ينكشف عيب بها، أو يقع اغتصاب عليها، أو يعتدى أجنبى عليها بالتعرض، أو بإحداث ضرر بها.$b585$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins585;

WITH ins586 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 586, 0, $h586$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h586$, $b586$(1) يجب على المستأجر أن يقوم بوفاء الأجرة فى المواعيد المتفق عليها، فإذا لم يكن هناك اتفاق وجب وفاء الأجرة فى المواعيد التى يعينها عرف الجهة.
(2) ويكون الوفاء فى موطن المستأجر ما لم يكن هناك اتفاق أو عرف يقضى بغير ذلك.$b586$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins586;

WITH ins587 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 587, 0, $h587$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h587$, $b587$الوفاء بالأجرة يسقط قرينة على الوفاء بالأقساط السابقة على هذا القسط حتى يقوم الدليل على عكس ذلك.$b587$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins587;

WITH ins588 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 588, 0, $h588$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h588$, $b588$يجب على من استأجر منزلا أو مخزنا أو حانوتا أو مكانا مماثلا لذلك أن يضع فى العين المؤجرة أثاثا أو بضائع أو محصولات أو مواشى أو أدوات تكون قيمتها كافية لضمان الأجرة عن سنتين، أو عن كل مدة الإيجار إذا قلت عن سنتين، ويعفى المستأجر من هذا الالتزام إذا تم الاتفاق على هذا الإعفاء أو إذا قدم المستأجر تأمينا آخر.$b588$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins588;

WITH ins589 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 589, 0, $h589$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h589$, $b589$(1) يكون للمؤجر، ضمانا لحق ثبت له بمقتضى عقد الإيجار، أن يحبس جميع المنقولات القابلة للحجز الموجودة فى العين المؤجرة مادامت العين مثقلة بامتياز المؤجر ولو لم تكن مملوكة للمستأجر. وللمؤجر الحق فى أن يمانع فى نقلها، فإذا نقلت رغم معارضته، أو دون علمه أو موافقته، فله الحق فى استردادها من الحائز لها ولو كان حسن النية، مع عدم الإخلال بما لهذا الحائز من حقوق.
(2) وليس للمؤجر حقه فى الحبس أو فى الاسترداد إذا كان نقل هذه الأشياء أمرا اقتضته حرفة المستأجر المألوفة فى شئون الحياة، أو كانت المنقولات التى تركت فى العين المؤجرة أو التى تم استردادها تفى بضمان الأجرة وفاء تاما.$b589$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins589;

WITH ins590 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 590, 0, $h590$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h590$, $b590$يجب على المستأجر أن يرد العين المؤجرة عند انتهاء الإيجار. فإذا أبقاها تحت يده دون حق كان ملزما بأن يدفع للمؤجر تعويضا يراعى فى تقديره القيمة الإيجارية للعين وما أصاب المؤجر من ضرر.$b590$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins590;

WITH ins591 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 591, 0, $h591$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h591$, $b591$(1) على المستأجر أن يرد العين المؤجرة بالحالة التى تسلمها عليها، إلا ما يكون قد لحقه من هلاك أو تلف لسبب لا يد له فيه.
(2) فإذا كان تسليم العين للمستأجر قد تم دون بيان بأوصافها كتابة أو محضر، افترض، حتى يقوم الدليل على العكس، أن المستأجر قد تسلم العين فى حالة حسنة.$b591$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins591;

WITH ins592 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 592, 0, $h592$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > آثار الإيجار$h592$, $b592$(1) إذا أوجد المستأجر فى العين المؤجرة بناء أو غراسا أو غير ذلك من التحسينات مما يزيد فى قيمة العقار، التزم المؤجر عند انتهاء الإيجار أن يرد للمستأجر ما أنفقه فى هذه التحسينات أو ما زاد فى قيمة العقار ما لم يكن هناك اتفاق يقضى بغير ذلك.
(2) فإذا كانت تلك التحسينات قد استحدثت دون علم المؤجر أو رغم معارضته، كان له أيضا أن يطلب من المستأجر إزالتها. وله أن يطلب فوق ذلك تعويضا عن الضرر الذى يصيب العقار إن كان لهذه الإزالة مقتضى.
(3) فإذا اختار المؤجر أن يحتفظ بهذه التحسينات فى مقابل رد قيمتها بإحدى القيمتين المتقدم ذكرها، جاز للمحكمة أن تنظره إلى أجل الوفاء بها.$b592$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins592;

WITH ins593 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 593, 0, $h593$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > التنازل عن الإيجار والإيجار من الباطن$h593$, $b593$للمستأجر حق التنازل عن الإيجار أو الإيجار من الباطن وذلك عن كل ما استأجره أو بعضه ما لم يقض الاتفاق بغير ذلك.$b593$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins593;

WITH ins594 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 594, 0, $h594$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > التنازل عن الإيجار والإيجار من الباطن$h594$, $b594$(1) منع المستأجر من أن يؤجر من الباطن يقتضى منعه من التنازل عن الإيجار وكذلك العكس.
(2) ومع ذلك إذا كان الأمر خاصا بإيجار عقار أنشئ بناؤه خصيصا ليكون مصنعا أو متجرا واقتضت الضرورة أن يبيع المستأجر هذا المصنع أو المتجر، جاز للمحكمة بالرغم من وجود الشرط المانع أن تقضى بإبقاء الإيجار نافذا إذا قدم المشترى ضمانا كافيا ولم يلحق المؤجر من ذلك ضرر محقق.$b594$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins594;

WITH ins595 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 595, 0, $h595$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > التنازل عن الإيجار والإيجار من الباطن$h595$, $b595$فى حالة التنازل عن الإيجار يبقى المستأجر ضامنا للمتنازل له فى تنفيذ التزاماته.$b595$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins595;

WITH ins596 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 596, 0, $h596$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > التنازل عن الإيجار والإيجار من الباطن$h596$, $b596$(1) يكون المستأجر من الباطن ملزما نحو المؤجر بأن يؤدى مباشرة ما يكون ثابتا فى ذمته للمستأجر الأصلى وقت أن ينذره المؤجر.
(2) ولا يجوز للمستأجر من الباطن أن يتمسك قبل المؤجر بما عجله من الأجرة للمستأجر الأصلى، ما لم يكن ذلك قد تم قبل الإنذار وفقا للعرف أو لاتفاق ثابت التاريخ تم وقت الإيجار من الباطن.$b596$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins596;

WITH ins597 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 597, 0, $h597$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > التنازل عن الإيجار والإيجار من الباطن$h597$, $b597$تبرأ ذمة المستأجر الأصلى قبل المؤجر فيما يتعلق بضمانه سواء فيما يتعلق بعقد الإيجار أم فيما يتعلق بما يفرضه عقد الإيجار الأصلى من التزامات فى حالة التنازل عن الإيجار أو الإيجار من الباطن:
(أولا) إذا صدر من المؤجر قبول صريح بالتنازل عن الإيجار أو بالإيجار من الباطن.
(ثانيا) إذا استوفى المؤجر الأجرة مباشرة من المتنازل له أو من المستأجر من الباطن دون أن يبدى تحفظا فى شأن حفظ حقوقه قبل المستأجر الأصلى.$b597$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins597;

WITH ins598 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 598, 0, $h598$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h598$, $b598$ينتهى الإيجار بانتهاء المدة المعينة فى العقد دون حاجة إلى تنبيه بالإخلاء.$b598$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins598;

WITH ins599 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 599, 0, $h599$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h599$, $b599$(1) إذا انتهى الإيجار بانقضاء مدته وبقى المستأجر منتفعا بالعين المؤجرة بعلم المؤجر ودون اعتراض منه، اعتبر عقد الإيجار قد تجدد بشروطه الأولى ولكن لمدة غير معينة، وتسرى على هذا الوجه أحكام المادة 563.
(2) ويعتبر هذا التجديد الضمنى إيجارا جديدا، لا مجرد امتداد للإيجار الأصلى، ومع ذلك لا تنتقل إلى الإيجار الجديد التأمينات العينية التى كان المستأجر قدمها فى الإيجار القديم مع مراعاة قواعد الشهر العقارى، أما الكفالة شخصية كانت أو عينية فلا تنتقل إلى الإيجار الجديد إلا إذا رضى الكفيل بذلك.$b599$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins599;

WITH ins600 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 600, 0, $h600$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h600$, $b600$إذا نبه أحد الطرفين على الآخر بالإخلاء واستمر المستأجر منتفعا بالعين بعد انتهاء الإيجار فلا يفترض أن ذلك تجديد له ما لم يقم الدليل على عكس ذلك.$b600$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins600;

WITH ins601 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 601, 0, $h601$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار > موت المستأجر أو إعساره$h601$, $b601$(1) لا ينتهى الإيجار بموت المؤجر ولا بموت المستأجر.
(2) ومع ذلك إذا مات المستأجر جاز لورثته أن يطلبوا إنهاء العقد إذا أثبتوا أنه بسبب موت مورثهم أصبحت أعباء العقد أثقل من أن تتحملها مواردهم، أو أصبح الإيجار مجاوزا حدود حاجتهم. وفى هذه الحالة يجب أن تراعى مواعيد التنبيه بالإخلاء المبينة فى المادة 563، وأن يكون طلب إنهاء العقد فى مدة أقصاها شهر من وقت موت المستأجر.$b601$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins601;

WITH ins602 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 602, 0, $h602$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h602$, $b602$إذا لم يعقد الإيجار بسبب حرفة المستأجر أو لاعتبارات أخرى تتعلق بشخصه، جاز لورثته أو للمؤجر إنهاء العقد إذا مات.$b602$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins602;

WITH ins603 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 603, 0, $h603$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h603$, $b603$(1) لا يترتب على إعسار المستأجر أن تحل أجرة لم تستحق.
(2) ومع ذلك يجوز للمؤجر أن يطلب فسخ الإيجار إذا لم يقدم فى ميعاد مناسب تأمينات تكفل الوفاء بالأجرة التى لم تحل، وكذلك يجوز للمؤجر إذا لم يرخص له فى التنازل عن الإيجار أو فى الإيجار من الباطن أن يطلب الفسخ بدلا من أن يدفع تعويضا عادلا.$b603$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins603;

WITH ins604 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 604, 0, $h604$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h604$, $b604$(1) إذا انتقلت ملكية العين المؤجرة اختيارا أو جبرا إلى شخص آخر، فلا يكون الإيجار نافذا فى حق هذا الشخص إلا إذا كان له تاريخ ثابت سابق على تاريخ نقل الملكية.
(2) ومع ذلك يجوز لمن انتقلت إليه الملكية أن يتمسك بعقد الإيجار ولو كان هذا العقد غير نافذ فى حقه.$b604$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins604;

WITH ins605 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 605, 0, $h605$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h605$, $b605$(1) لا يجوز لمن انتقلت إليه ملكية العين المؤجرة ولم يكن الإيجار نافذا فى حقه أن يجبر المستأجر على الإخلاء إلا بعد التنبيه عليه بذلك فى المواعيد المبينة فى المادة 563.
(2) فإذا نبه على المستأجر بالإخلاء قبل انقضاء الإيجار فإن المؤجر يلتزم بأن يدفع للمستأجر تعويضا ما لم يتفق على غير ذلك، ولا يجبر المستأجر على الإخلاء إلا بعد أن يتقاضى التعويض من المؤجر أو ممن انتقلت إليه الملكية نيابة عن المؤجر أو بعد أن يحصل على تأمين كاف للوفاء بهذا التعويض.$b605$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins605;

WITH ins606 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 606, 0, $h606$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h606$, $b606$لا يجوز للمستأجر أن يتمسك بما عجله من الأجرة قبل من انتقلت إليه الملكية إذا أثبت هذا أن المستأجر وقت الدفع كان يعلم بانتقال الملكية أو كان من المفروض حتما أنه يعلم. فإذا عجز من انتقلت إليه الملكية عن الإثبات فلا يكون له الرجوع على المؤجر.$b606$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins606;

WITH ins607 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 607, 0, $h607$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h607$, $b607$إذا اتفق على أنه يجوز للمؤجر أن ينهى العقد إذا وجدت له حاجة شخصية للعين، وجب عليه فى استعمال هذا الحق أن ينبه على المستأجر بالإخلاء فى المواعيد المبينة بالمادة 563 ما لم يتفق على غير ذلك.$b607$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins607;

WITH ins608 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 608, 0, $h608$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h608$, $b608$(1) إذا كان الإيجار معين المدة، جاز لكل من المتعاقدين قبل انقضاء مدته أن يطلب إنهاءه إذا جدت ظروف غير متوقعة من شأنها أن تجعل تنفيذ الإيجار من مبدأ الأمر أو فى أثناء سريانه مرهقا، على أن يراعى فى إنهاء العقد مواعيد التنبيه بالإخلاء المبينة بالمادة 563، وعلى أن يعوض الطرف الآخر تعويضا عادلا.
(2) فإذا كان المؤجر هو الذى يطلب إنهاء العقد، فلا يجبر المستأجر على رد العين المؤجرة حتى يستوفى التعويض أو يحصل على تأمين كاف.$b608$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins608;

WITH ins609 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 609, 0, $h609$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 1- الإيجار بوجه عام > انتهاء الإيجار$h609$, $b609$يجوز للموظف أو المستخدم إذا اقتضى إنهاء عمله أن يترك محل إقامته إذا كان هذا الإيجار معين المدة، على أن يراعى فى هذا الإنهاء المواعيد المبينة فى المادة 563، ويقع باطلا كل اتفاق على غير ذلك.$b609$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins609;

WITH ins610 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 610, 0, $h610$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h610$, $b610$إذا كانت العين المؤجرة أرضا زراعية، فلا يكون المؤجر ملزما بتسليم المستأجر المواشى والأدوات الزراعية التى توجد فى الأرض الزراعية إلا إذا كان الإيجار يشملها.$b610$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins610;

WITH ins611 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 611, 0, $h611$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h611$, $b611$إذا تسلم المستأجر مواشى وأدوات زراعية مملوكة للمؤجر، وجب عليه أن يرعاها ويتعهدها بالصيانة بحسب المألوف فى استغلالها.$b611$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins611;

WITH ins612 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 612, 0, $h612$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h612$, $b612$إذا ذكر فى عقد إيجار الأرض الزراعية أن الإيجار قد عقد لسنة أو لعدة سنوات، كان المقصود من ذلك أنه قد عقد لدورة زراعية سنوية أو لعدة دورات.$b612$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins612;

WITH ins613 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 613, 0, $h613$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h613$, $b613$(1) يجب أن يكون استغلال المستأجر للأرض الزراعية موافقا لمقتضيات الاستغلال المألوف، وعلى المستأجر بوجه خاص أن يعمل على أن تبقى الأرض صالحة للإنتاج.
(2) ولا يجوز له دون رضاء المؤجر أن يدخل على الطريقة المتبعة فى استغلالها أى تغيير جوهرى يمتد أثره إلى ما بعد انقضاء الإيجار.$b613$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins613;

WITH ins614 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 614, 0, $h614$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h614$, $b614$(1) على المستأجر أن يقوم بإجراء الإصلاحات التى يقتضيها الانتفاع بالأرض المؤجرة بالأسلوب المألوف، ويلتزم بوجه خاص بتطهير الترع والمساقى وصيانة المراوى والمصارف وكذلك القيام بأعمال الصيانة المعتادة للطرق والسور والقناطر والأسوار والآبار والمبانى المعدة للسكنى أو للاستغلال، كل هذا ما لم يقض اتفاق أو العرف بغيره.
(2) أما إقامة المبانى والإصلاحات الكبرى القائمة من ملحقات العين وغيرها، فلا يلتزم بها المستأجر ما لم يقض الاتفاق أو العرف بذلك، وكذلك يكون الحكم فى الإصلاحات اللازمة للآبار ومجارى المياه والخزانات.$b614$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins614;

WITH ins615 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 615, 0, $h615$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h615$, $b615$إذا منع المستأجر من تهيئة الأرض للزراعة أو من بذرها أو هلك البذر كله أو أكثره بسبب قوة قاهرة، برئت ذمة المستأجر من الأجرة كلها أو بعضها بحسب الأحوال، كل هذا ما لم يوجد اتفاق يقضى بغيره.$b615$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins615;

WITH ins616 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 616, 0, $h616$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h616$, $b616$(1) إذا بذر المستأجر الأرض ثم هلك الزرع كله قبل حصاده بسبب قوة قاهرة، جاز للمستأجر أن يطلب إسقاط الأجرة.
(2) أما إذا لم يهلك إلا بعض الزرع ولكن ترتب على الهلاك نقص كبير فى ريع الأرض، كان للمستأجر أن يطلب إنقاص الأجرة.
(3) وليس للمستأجر أن يطلب إسقاط الأجرة أو إنقاصها إذا كان قد عوض عما أصابه من ضرر بما عاد عليه من أرباح فى الإجارة كلها أو بما حصل عليه من طريق التأمين أو من أى طريق آخر.$b616$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins616;

WITH ins617 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 617, 0, $h617$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h617$, $b617$يجوز للمستأجر إذا لم تنضج غلة الأرض عند انتهاء الإيجار لا يد له فيه أن يبقى بالعين المؤجرة حتى تنضج الغلة على أن يؤدى الأجرة المناسبة.$b617$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins617;

WITH ins618 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 618, 0, $h618$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الأراضى الزراعية$h618$, $b618$لا يجوز للمستأجر أن يأتى عملا من شأنه أن ينقص انتفاع من يخلفه فى الأرض، ويجب عليه بوجه خاص قبل إخلاء الأرض أن يمسح لهذا الخلف هيئة الأرض وبذرها إذا لم يصبه ضرر من ذلك.$b618$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins618;

WITH ins619 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 619, 0, $h619$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h619$, $b619$يجوز أن تعطى الأرض الزراعية والأرض المغروسة بالأشجار للمستأجر مزارعة فى مقابل أخذ المؤجر جزءا معينا من المحصول.$b619$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins619;

WITH ins620 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 620, 0, $h620$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h620$, $b620$تسرى أحكام الإيجار على المزارعة مع مراعاة الأحكام الآتية إذا لم يوجد اتفاق أو عرف يخالفها.$b620$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins620;

WITH ins621 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 621, 0, $h621$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h621$, $b621$إذا لم تعين مدة المزارعة، كانت المدة دورة زراعية سنوية.$b621$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins621;

WITH ins622 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 622, 0, $h622$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h622$, $b622$الإيجار فى المزارعة تدخل فيه الأدوات الزراعية والمواشى التى توجد فى الأرض وقت التعاقد إذا كانت مملوكة للمؤجر.$b622$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins622;

WITH ins623 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 623, 0, $h623$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h623$, $b623$(1) يجب على المستأجر أن يبذل فى الزراعة وفى المحافظة على الزرع من العناية ما يبذله فى شئونه نفسه.
(2) وهو مسئول عما يصيب الأرض من التلف أثناء الانتفاع إلا إذا أثبت أنه بذل فى المحافظة عليها وفى صيانتها ما يبذله الشخص المعتاد.
(3) ولا يلزم المستأجر أن ينفق ما يعوض من المواشى والأدوات الزراعية بلا خطأ منه.$b623$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins623;

WITH ins624 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 624, 0, $h624$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h624$, $b624$(1) توزع الغلة بين الطرفين بالنسبة المتفق عليها بالنسبة لكل منهما أو بالنسبة التى يعينها العرف، فإذا لم يوجد اتفاق أو عرف كان لكل منهما نصف الغلة.
(2) فإذا هلكت الغلة كلها أو بعضها بسبب قوة قاهرة، تحمل الطرفان معا تبعة هذا الهلاك تبعا لحصتيهما ولا يرجع أحدهما على الآخر.$b624$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins624;

WITH ins625 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 625, 0, $h625$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h625$, $b625$لا يجوز للمزارع أن ينزل المستأجر عن الإيجار أو أن يؤجر الأرض من الباطن إلا برضاء المؤجر.$b625$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins625;

WITH ins626 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 626, 0, $h626$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h626$, $b626$لا تنتهى المزارعة بموت المؤجر، ولكنها تنتهى بموت المستأجر.$b626$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins626;

WITH ins627 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 627, 0, $h627$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > المزارعة$h627$, $b627$(1) إذا انتهت المزارعة بموت المستأجر قبل انقضاء مدتها، وجب أن يرد ورثته للمؤجر ما أنفقه على المحصول الذى لم يتم نضجه مع تعويض عادل عما قام به المستأجر من العمل.
(2) ومع ذلك إذا انتهت المزارعة بموت المستأجر، جاز لورثته عوضا عن استعمال حقهم المتقدم ذكره أن يحلوا محل مورثهم حتى ينضج المحصول مادام يستطيعون القيام بذلك على الوجه المرضى.$b627$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins627;

WITH ins628 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 628, 0, $h628$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الوقف$h628$, $b628$(1) للناظر ولاية إجارة الوقف.
(2) فلا يملكها الموقوف عليه ولو انحصر فيه الاستحقاق إلا إذا كان قبل الواقف متوليا أو مأذونا له بولاية الإجارة من ناظر أو قاضى.$b628$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins628;

WITH ins629 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 629, 0, $h629$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الوقف$h629$, $b629$ولاية قبض الأجرة للناظر على الموقوف عليه، ولا يملكها الموقوف عليه إلا أن يأذن له الناظر فى قبضها.$b629$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins629;

WITH ins630 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 630, 0, $h630$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الوقف$h630$, $b630$(1) لا يجوز للناظر أن يستأجر الوقف ولو بأجر المثل.
(2) ويجوز له أن يؤجر الوقف لأصوله وفروعه على أن يكون ذلك بأجر المثل.$b630$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins630;

WITH ins631 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 631, 0, $h631$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الوقف$h631$, $b631$لا تصح إجارة الوقف بالغبن الفاحش إلا إذا كان المؤجر هو المستحق الوحيد الذى له ولاية التصرف فى الوقف، فتجوز إجارته بالغبن الفاحش فى حق نفسه لا فى حق من ليله من المستحقين.$b631$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins631;

WITH ins632 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 632, 0, $h632$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الوقف$h632$, $b632$(1) فى إجارة الوقف تكون العبرة فى تقدير أجر المثل بالوقت الذى أبرم فيه عقد الإيجار، ولا يعتد بالتغيير الحاصل بعد ذلك.
(2) وإذا أجر الناظر الوقف بالغبن الفاحش، وجب على المستأجر تكملة الأجرة إلى أجر المثل وإلا فسخ العقد.$b632$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins632;

WITH ins633 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 633, 0, $h633$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الوقف$h633$, $b633$(1) لا يجوز للناظر بغير إذن القاضى أن يؤجر الوقف مدة تزيد على ثلاث سنين ولو كان ذلك بعقود متراصفة، فإذا عقدت الإجارة لمدة أطول، انتقصت المدة إلى ثلاث سنين.
(2) ومع ذلك إذا كان الناظر هو الواقف أو المستحق الوحيد، جاز له أن يؤجر الوقف مدة تزيد على ثلاث سنين بلا إذن القاضى، وهذا دون إخلال بحق الناظر الذى يخلفه فى طلب إنقاص المدة إلى ثلاث سنين.$b633$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins633;

WITH ins634 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 634, 0, $h634$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الأول - الإيجار > 2- بعض أنواع الإيجار > إيجار الوقف$h634$, $b634$تسرى أحكام عقد الإيجار على إجارة الوقف إلا إذا تعارضت مع النصوص السابقة.$b634$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins634;

WITH ins635 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 635, 0, $h635$Q2B2F2$h635$, $b635$العارية عقد يلتزم به المعير أن يسلم المستعير شيئا غير قابل للاستهلاك ليستعمله بلا عوض لمدة معينة أو فى غرض معين على أن يرده بعد الاستعمال.$b635$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins635;

WITH ins636 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 636, 0, $h636$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 1- التزامات المعير$h636$, $b636$يلتزم المعير أن يسلم المستعير الشيء المعار بالحالة التى يكون عليها وقت انعقاد العارية وأن يتركه للمستعير طول مدة العارية.$b636$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins636;

WITH ins637 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 637, 0, $h637$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 1- التزامات المعير$h637$, $b637$(1) إذا اضطر المستعير إلى الإنفاق للمحافظة على الشيء أثناء العارية التزم المعير أن يرد إليه ما أنفقه من المصروفات.
(2) أما المصروفات النافعة فتنطبق فى شأنها الأحكام الخاصة بالمصروفات التى ينفقها الحائز سيئ النية.$b637$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins637;

WITH ins638 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 638, 0, $h638$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 1- التزامات المعير$h638$, $b638$(1) لا ضمان على المعير فى استحقاق الشيء المعار إلا إذا كان هناك اتفاق على الضمان أو كان المعير قد تعمد إخفاء سبب الاستحقاق.
(2) ولا ضمان عليه كذلك فى العيوب الخفية، غير أنه إذا تعمد إخفاء العيب أو إذا ضمن سلامة الشيء منه لزمه تعويض المستعير عن كل ضرر يسببه ذلك.$b638$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins638;

WITH ins639 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 639, 0, $h639$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 2- التزامات المستعير$h639$, $b639$(1) ليس للمستعير أن يستعمل الشيء المعار إلا على الوجه المعين وبالقدر المحدد، وذلك طبقا لما بينه العقد أو تقتضيه طبيعة الشيء أو يعينه العرف. ولا يجوز له دون إذن المعير أن ينزل عن الاستعمال للغير ولو على سبيل التبرع.
(2) ولا يكون مسئولا عما يلحق الشيء من تغيير أو تلف يسببه الاستعمال الذى تبيحه العارية.$b639$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins639;

WITH ins640 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 640, 0, $h640$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 2- التزامات المستعير$h640$, $b640$(1) إذا اقتضى استعمال الشيء المعار نفقة فليس للمستعير استردادها، إلا إذا اقتضتها ضرورة النفقة اللازمة لصيانة الشيء صيانة معتادة.
(2) وله أن ينزع من الشيء المعار كل ما يكون قد أضافه إليه، على أن يعيد الشيء إلى حالته الأصلية.$b640$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins640;

WITH ins641 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 641, 0, $h641$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 2- التزامات المستعير$h641$, $b641$(1) على المستعير أن يبذل فى المحافظة على الشيء العناية التى يبذلها فى المحافظة على ماله دون أن ينزل ذلك عن عناية الرجل المعتاد.
(2) وفى كل حال يكون ضامنا لهلاك الشيء إذا نشأ الهلاك عن حادث مفاجئ أو قوة قاهرة وكان فى وسعه أن يتجنبه باستعمال شىء من ملكه الخاص، أو كان بين شيئا مملوكا له أختار أن ينقذ ما يملكه.$b641$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins641;

WITH ins642 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 642, 0, $h642$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 2- التزامات المستعير$h642$, $b642$(1) متى انتهت العارية وجب على المستعير أن يرد الشيء الذى تسلمه بالحالة التى تسلمها عليها، وذلك دون إخلال بمسئوليته عن الهلاك أو التلف.
(2) ويجب رد الشيء فى المكان الذى يكون المستعير قد تسلمه فيه ما لم يوجد اتفاق يقضى بغير ذلك.$b642$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins642;

WITH ins643 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 643, 0, $h643$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 3- انتهاء العارية$h643$, $b643$(1) تنتهى العارية بانقضاء الأجل المتفق عليه، فإذا لم يعين لها أجل انتهت باستعمال الشيء فيما أعير من أجله.
(2) فإن لم يكن هناك سبيل لتعيين مدة العارية، جاز للمعير أن يطلب إنهاءها فى أى وقت.
(3) وفى كل حال يجوز للمستعير أن يرد الشيء المعار قبل انتهاء العارية، غير أنه إذا كان هذا الرد يضر بالمعير فلا يلزم المعير بقبوله.$b643$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins643;

WITH ins644 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 644, 0, $h644$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 3- انتهاء العارية$h644$, $b644$يجوز للمعير أن يطلب فى أى وقت إنهاء العارية فى الأحوال الآتية:
(أ) إذا عرضت له حاجة عاجلة للشيء لم تكن متوقعة.
(ب) إذا أساء المستعير استعمال الشيء أو قصر فى الاحتياط الواجب للمحافظة عليه.
(جـ) إذا أعسر المستعير بعد انعقاد العارية أو كان معسرا قبل ذلك ولم يعلم المعير بذلك.$b644$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins644;

WITH ins645 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 645, 0, $h645$الكتاب الثانى - العقود المسماة > الباب الثانى - العقود الواردة على الانتفاع بالشىء > الفصل الثانى - العارية > 3- انتهاء العارية$h645$, $b645$تنتهى العارية بموت المستعير ما لم يوجد اتفاق يقضى بغيره.$b645$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins645;

WITH ins646 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 646, 0, $h646$Q2B3F1_1$h646$, $b646$المقاولة عقد يتعهد بمقتضاه أحد المتعاقدين أن يصنع شيئا أو أن يؤدى عملا لقاء أجر يتعهد به المتعاقد الآخر.$b646$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins646;

WITH ins647 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 647, 0, $h647$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات المقاول$h647$, $b647$(1) يجوز أن يقتصر المقاول على التعهد بتقديم عمله على أن يقدم رب العمل المادة التى يستخدمها أو يستعين بها فى القيام بعمله.
(2) كما يجوز أن يتعهد المقاول بتقديم العمل والمادة معا.$b647$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins647;

WITH ins648 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 648, 0, $h648$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات المقاول$h648$, $b648$إذا تعهد المقاول بتقديم مادة العمل كلها أو بعضها، كان مسئولا عن جودتها وعليه ضمانها لرب العمل.$b648$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins648;

WITH ins649 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 649, 0, $h649$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات المقاول$h649$, $b649$(1) إذا كان رب العمل هو الذى قدم المادة، فعلى المقاول أن يحرص عليها ويراعى أصول الفن فى استخدامه لها وأن يؤدى حسابا لرب العمل عما استعمله منها ويرد إليه ما بقى منها، فإذا صار شىء من هذه المادة غير صالح للاستعمال بسبب إهمال أو قصور كفايته الفنية، التزم برد قيمة هذا الشىء لرب العمل.
(2) وعلى المقاول أن يأتى بما يحتاج إليه فى إنجاز العمل من أدوات ومهمات إضافية ويكون ذلك على نفقته، هذا ما لم يقض عرف الحرفة بغيره.$b649$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins649;

WITH ins650 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 650, 0, $h650$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات المقاول$h650$, $b650$(1) إذا ثبت أثناء سير العمل أن طريقة التنفيذ يقوم بها على وجه معيب أو مناف لعقد، جاز لرب العمل أن ينذره بأن يعدل من طريقة التنفيذ خلال أجل معقول يعينه له، فإذا انقضى الأجل دون أن يرجع المقاول إلى الطريقة الصحيحة، جاز لرب العمل إما أن يطلب فسخ العقد وإما أن يعهد إلى مقاول آخر بإنجاز العمل على نفقة المقاول الأول طبقا لأحكام المادة 209.
(2) على أنه يجوز طلب فسخ العقد فى الحال دون تعيين أجل إذا كان إصلاح ما فى طريقة التنفيذ من عيب مستحيلا.$b650$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins650;

WITH ins651 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 651, 0, $h651$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات المقاول$h651$, $b651$(1) يضمن المهندس المعمارى والمقاول متضامنين ما يحدث خلال عشر سنوات من تهدم كلى أو جزئى فيما شيدوه من مبان أو أقاموه من منشآت ثابتة أخرى ولو كان هذا التهدم ناشئا عن عيب فى الأرض ذاتها، أو كان رب العمل قد أجاز إقامة المنشآت المعيبة، ما لم يكن المتعاقدان فى هذه الحالة قد أرادا أن تبقى هذه المنشآت مدة أقل من عشر سنوات.
(2) ويشمل الضمان المنصوص عليه فى الفقرة السابقة ما يوجد فى المبانى والمنشآت من عيوب يترتب عليها تهديد متانة البناء وسلامته.
(3) وتبدأ مدة السنوات العشر من وقت تسلم العمل ولا تسرى هذه المادة على ما قد يكون للمقاول من حق الرجوع على المقاولين من الباطن.$b651$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins651;

WITH ins652 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 652, 0, $h652$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات المقاول$h652$, $b652$إذا اقتصر المهندس المعمارى على وضع التصميمات دون أن يكلف بالرقابة على التنفيذ، لم يكن مسئولا إلا عن العيوب التى أتت من التصميم.$b652$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins652;

WITH ins653 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 653, 0, $h653$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات المقاول$h653$, $b653$يكون باطلا كل شرط يقصد به إعفاء المهندس المعمارى والمقاول من الضمان أو الحد منه.$b653$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins653;

WITH ins654 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 654, 0, $h654$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات المقاول$h654$, $b654$تسقط دعاوى الضمان المتقدمة بانقضاء ثلاث سنوات من وقت حصول التهدم أو اكتشاف العيب.$b654$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins654;

WITH ins655 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 655, 0, $h655$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات رب العمل$h655$, $b655$متى أتم المقاول العمل ووضعه تحت تصرف رب العمل، وجب على هذا أن يبادر إلى تسلمه فى أقرب وقت ممكن بحسب الجارى فى المعاملات، فإذا امتنع دون سبب مشروع عن التسليم رغم دعوته إلى ذلك بإنذار رسمى، اعتبر أن العمل قد سلم إليه.$b655$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins655;

WITH ins656 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 656, 0, $h656$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات رب العمل$h656$, $b656$يستحق دفع الأجر عند تسلم العمل، إلا إذا قضى العرف بغير ذلك.$b656$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins656;

WITH ins657 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 657, 0, $h657$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات رب العمل$h657$, $b657$(1) إذا أبرم عقد المقاولة بمقتضى مقايسة على أساس الوحدة وتبين فى أثناء العمل أن من الضرورى لتنفيذ التصميم المتفق عليه مجاوزة المقاييس المقدرة مجاوزة محسوسة، وجب على المقاول أن يخطر رب العمل بالحال دون إبطاء ما يتوقعه من زيادة فى الثمن، فإن لم يفعل سقط حقه فى استرداد ما جاوز به قيمة المقايسة من نفقات.
(2) فإذا كانت المجاوزة التى يقتضيها تنفيذ التصميم جسيمة، جاز لرب العمل أن يتحلل من العقد ويوقف التنفيذ، مع إيفاء المقاول قيمة الأعمال المقدرة وفقا لشروط العقد، دون أن يعوضه عما كان يستطيع كسبه لو أتم العمل.$b657$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins657;

WITH ins658 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 658, 0, $h658$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات رب العمل$h658$, $b658$(1) إذا أبرم العقد بأجر إجمالى على أساس تصميم اتفق عليه رب العمل والمقاول، فليس للمقاول أن يطالب بأية زيادة فى الأجر ولو حدث فى هذا التصميم من تعديل أو إضافة إلا أن يكون ذلك راجعا إلى خطأ من رب العمل أو أن يكون مأذونا به منه مع اتفاقه مع المقاول على أجره.
(2) ويجب أن يحصل هذا الاتفاق كتابة، إلا إذا كان العقد الأصلى ذاته قد اتفق عليه مشافهة.
(3) وليس للمقاول إذا ارتفعت أسعار المواد الأولية وأجور الأيدى العاملة أو غيرها من التكاليف أن يطلب لذلك زيادة الأجر ولو بلغ هذا الارتفاع حدا جعل تنفيذ العقد عسيرا.
(4) على أنه إذا انهار التوازن الاقتصادى بين التزامات كل من رب العمل والمقاول بسبب حوادث استثنائية عامة لم تكن فى الحسبان وقت التعاقد، وتداعى بذلك الأساس الذى قام عليه التقدير المالى لعقد المقاولة، جاز للقاضى أن يحكم بزيادة الأجر أو بفسخ العقد.$b658$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins658;

WITH ins659 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 659, 0, $h659$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات رب العمل$h659$, $b659$إذا لم يحدد الأجر سلفا وجب الرجوع فى تحديده إلى قيمة العمل ونفقات المقاول.$b659$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins659;

WITH ins660 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 660, 0, $h660$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > التزامات رب العمل$h660$, $b660$(1) يستحق المهندس المعمارى أجرا مستقلا عن وضع التصميم وعمل المقايسة وآخر عن إدارة الأعمال.
(2) فإن لم يحدد العقد هذه الأجور وجب تقديرها وفقا للعرف الجارى.
(3) غير أنه إذا لم يتم العمل بمقتضى التصميم الذى وضعه المهندس، وجب تقدير الأجر بحسب طبيعة هذا العمل مع مراعاة الزمن الذى استغرقه وضع التصميم.$b660$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins660;

WITH ins661 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 661, 0, $h661$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > المقاولة من الباطن$h661$, $b661$(1) يجوز للمقاول أن ينفذ العمل فى كلمته أو فى جزء منه عن طريق مقاول من الباطن إذا لم يمنعه من ذلك شرط فى العقد أو لم تكن طبيعة العمل تفترض الاعتماد على كفايته الشخصية.
(2) ولكنه يبقى فى هذه الحالة مسئولا عن المقاول من الباطن قبل رب العمل.$b661$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins661;

WITH ins662 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 662, 0, $h662$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > المقاولة من الباطن$h662$, $b662$(1) يكون للمقاولين من الباطن والعمال الذين يشتغلون لحساب المقاول فى تنفيذ العمل، حق مطالبة رب العمل مباشرة بما لا يجاوز القدر الذى يكون مدينا به للمقاول الأصلى وقت رفع الدعوى، ويكون لهذا الحق مثل هذا الحق لكل من المقاولين من الباطن ولعمال المقاول الأصلى قبل المقاول ورب العمل.
(2) ولهم فى حالة توقيع الحجز من أحدهم تحت يد رب العمل أو المقاول الأصلى امتياز على المبالغ المستحقة للمقاول الأصلى أو للمقاول من الباطن وقت توقيع الحجز، ويكون الامتياز لكل منهم بنسبة حقه ويجوز أداء هذه المبالغ إليهم مباشرة.
(3) وحقوق المقاولين من الباطن والعمال المقررة بمقتضى هذه المادة مقدمة على حقوق رب العمل عن دينه قبل المقاول عن العمل.$b662$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins662;

WITH ins663 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 663, 0, $h663$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > انقضاء المقاولة$h663$, $b663$(1) لرب العمل أن يتحلل من العقد ويقف التنفيذ فى أى وقت قبل إتمامه، على أن يعوض المقاول عن جميع ما أنفقه من المصروفات، وما أنجزه من الأعمال، وما كان يستطيع كسبه لو أنه أتم العمل.
(2) على أنه يجوز للمحكمة أن تخفض التعويض المستحق عما فات المقاول من كسب إذا كانت الظروف تجعل هذا التخفيض عادلا، ويتعين عليها بوجه خاص أن تنقص من هذا المقدار ما يكون المقاول قد اقتصده من جراء حله من العقد وما يكون قد كسبه باستخدام وقته فى أمر آخر.$b663$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins663;

WITH ins664 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 664, 0, $h664$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > انقضاء المقاولة$h664$, $b664$ينقضى عقد المقاولة باستحالة تنفيذ العمل المعقود عليه.$b664$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins664;

WITH ins665 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 665, 0, $h665$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > انقضاء المقاولة$h665$, $b665$(1) إذا هلك الشيء بسبب حادث مفاجئ قبل تسليمه إلى رب العمل، فليس للمقاول أن يطالب لرب العمل بثمن عمله ولا برد نفقاته، ما لم يكن قد أعذر فى تسلمها من الطرفين.
(2) أما إذا كان رب العمل قد أعذر فى تسلم الشيء أو كان هلاك الشيء راجعا إلى عيب فى المادة التى قام رب العمل بتوريدها، وجب عليه أن يعوض المقاول عما قدمه من مواد.
(3) فإذا كان رب العمل هو الذى قدم الشيء ثم هلك قبل أن يسلم إلى المقاول، أو كان هلاك الشيء راجعا إلى خطأ منه، أو كان هلاكه بسبب عيب فى المادة التى قام بتوريدها، كان هلاكه على رب العمل، وكان للمقاول الحق فى الأجر الذى كان يستحقه عند الاقتضاء.$b665$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins665;

WITH ins666 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 666, 0, $h666$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > انقضاء المقاولة$h666$, $b666$ينقضى عقد المقاولة بموت المقاول إذا كانت مؤهلاته الشخصية محل اعتبار فى التعاقد. فإن لم تكن محل اعتبار فلا ينقضى العقد بموته، ولا يجوز لرب العمل فسخه إلا فى غير الحالات التى تطبق فيها المادة 663 إلا إذا لم تتوافر فى ورثة المقاول الضمانات الكافية لحسن تنفيذ العمل.$b666$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins666;

WITH ins667 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 667, 0, $h667$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 1- عقد المقاولة > انقضاء المقاولة$h667$, $b667$(1) إذا انقضى العقد بموت المقاول، وجب على رب العمل أن يدفع للتركة قيمة ما تم من العمل وما أنفق من المصروفات، وذلك بقدر ما يعود عليه من النفع من هذه الأعمال والنفقات.
(2) ويجوز لرب العمل أن يطالب نظير ذلك بتسليم المواد التى تم إعدادها والرسوم التى تمت لتنفيذها، على أن يدفع عنها تعويضا عادلا.
(3) وتسرى هذه الأحكام أيضا إذا بدأ المقاول فى تنفيذ العمل ثم أصبح عاجزا عن إتمامه لسبب لا يد له فيه.$b667$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins667;

WITH ins668 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 668, 0, $h668$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 2- التزام المرافق العامة$h668$, $b668$التزام المرافق العامة عقد الغرض منه إدارة مرفق عام ذى صفة اقتصادية، ويكون هذا العقد بين جهة الإدارة المختصة بتنظيمه وبين فرد أو شركة يعهد إليها باستغلال المرفق فترة معينة من الزمن.$b668$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins668;

WITH ins669 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 669, 0, $h669$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 2- التزام المرافق العامة$h669$, $b669$ملتزم المرفق العام يتعهد بمقتضى العقد الذى يبرمه مع عميله بأن يؤدى لهذا العميل على الوجه المألوف، الخدمات المقابلة للأجر الذى يقبضه وفقا للشروط المنصوص عليها فى عقد الالتزام وملحقاته، وللشروط التى تقتضيها طبيعة العمل وما ينظم هذا العمل من القوانين.$b669$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins669;

WITH ins670 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 670, 0, $h670$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 2- التزام المرافق العامة$h670$, $b670$(1) إذا كان ملتزم المرفق محتكرا له احتكارا قانونيا أو فعليا، وجب عليه أن يحقق المساواة التامة بين عملائه سواء فى الخدمات العامة أو فى تقاضى الأجور.
(2) ولا تحول المساواة دون أن تكون هناك معاملة خاصة تنطوى على تخفيض الأجور أو الإعفاء منها، على أن ينتفع بهذه المعاملة من يطلب ذلك ممن توافرت فيه شروط يعينها الملتزم بوجه عام. ولكن المساواة تحرم على الملتزم أن يمنح أحد عملائه ميزات يرفض منحها لآخرين.
(3) وكل تمييز على خلاف ما تقضى به الفقرة السابقة، يوجب على الملتزم أن يعوض الضرر الذى قد يصيب الغير من جراء ما يترتب على هذا التمييز من إخلال بالتوازن الطبيعى فى المنافسة المشروعة.$b670$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins670;

WITH ins671 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 671, 0, $h671$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 2- التزام المرافق العامة$h671$, $b671$(1) يكون لتعريفات الأسعار التى قررتها السلطة العامة قوة القانون بالنسبة إلى العقود التى يبرمها الملتزم مع عملائه، فلا يجوز للمتعاقدين أن يتفقا على ما يخالفها.
(2) ويجوز إعادة النظر فى هذه القوائم وتعديلها. فإذا عدلت الأسعار المعمول بها وصدق على التعديل، أثر ذلك من الوقت الذى عينه قرار التصديق لسريانها جاريا وقت التعديل، وما يسرى هذا التعديل على ما عليه من المرافق العام فيما بين اشتراكاته فى زيادة أو نقص فى الأجور وذلك فيما بقى من المدة المعينة لسريان الأسعار الجديدة.$b671$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins671;

WITH ins672 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 672, 0, $h672$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 2- التزام المرافق العامة$h672$, $b672$(1) كل انحراف أو غلط يقع عند تطبيق تعريفة الأسعار على العقود الفردية يكون قابلا للتصحيح.
(2) فإذا وقع الانحراف أو الغلط ضد مصلحة العميل كان له الحق فى استرداد ما دفعه زيادة على الأسعار المقررة، وإذا وقع ضد مصلحة الملتزم بالمرفق العام كان له الحق فى استكمال ما نقص من الأسعار المقررة. ويكون باطلا كل اتفاق يخالف ذلك. ويسقط الحق فى الحالين بانقضاء سنة من وقت قبض الأجور التى لا تتفق مع الأسعار المقررة.$b672$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins672;

WITH ins673 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 673, 0, $h673$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الأول - المقاولة والتزام المرافق العامة > 2- التزام المرافق العامة$h673$, $b673$(1) على عملاء المرافق المتعلقة بتوزيع المياه والغاز والكهرباء والقوى المحركة وما شابه ذلك، أن يتحملوا ما يلزم من أدوات عادة من عطل أو خلل لمدة قصيرة، كهذا الذى تقتضيه صيانة الأدوات التى يدار بها المرفق.
(2) ولملتزمى هذه المرافق أن يدفعوا عن مسئوليتهم عما يصيب المرفق من عطل أو خلل يزيد فى مدته أو جسامته المألوفة، إذا أثبتوا أن ذلك راجع إلى قوة قاهرة خارجة عن إرادة المرفق من يقظة مقدرة أن تتوقع حصوله أو أن تدرأ نتائجه، ويعتبر الإضراب حادثا مفاجئا إذا استطاع الملتزم إقامة الدليل على أن وقوع الإضراب كان دون خطأ منه، وأنه لم يكن فى وسعه أن يتلافى نتيجة إضرابهم بأية وسيلة أخرى.$b673$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins673;

WITH ins674 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 674, 0, $h674$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل$h674$, $b674$لا تسرى أحكام هذا الفصل إلا على العقد الذى يتعهد فيه أحد المتعاقدين بأن يعمل فى خدمة المتعاقد الآخر وتحت إدارته أو إشرافه مقابل أجر يتعهد به المتعاقد الآخر.$b674$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins674;

WITH ins675 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 675, 0, $h675$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل$h675$, $b675$(1) لا تسرى الأحكام الواردة فى هذا الفصل إلا بالقدر الذى لا تتعارض فيه صراحة أو ضمنا مع التشريعات الخاصة التى تتعلق بالعمل.
(2) وتبين هذه التشريعات طوائف العمال الذين لا تسرى عليهم هذه الأحكام.$b675$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins675;

WITH ins676 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 676, 0, $h676$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل$h676$, $b676$(1) تسرى أحكام عقد العمل على العلاقة ما بين أرباب الأعمال وبين الممثلين التجاريين والوسطاء والمندوبين الجوابين ومندوبى التأمين وغيرهم من الوسطاء، ولو كانوا مأجورين بطريقة العمالة أو كانوا يعملون لحساب جملة من أرباب الأعمال، مادام هؤلاء الأشخاص تابعين لأرباب العمل وخاضعين لرقابتهم.
(2) وإذا انتهت خدمات الممثل التجارى أو المندوب الجواب ولو كان ذلك بانتهاء المدة المعينة فى عقد استخدامه، كان له الحق فى أن يتقاضى على سبيل الأجر الخصم أو العمالة التى يقضى بها العرف عن التوصيات التى لم تبلغ الممثل التجارى أو المندوب الجواب أو الوسيط خروجه من خدمته، متى كانت هذه التوصيات حدثت نتيجة مباشرة لما قام به هؤلاء المستخدمون من سعى لدى العملاء أثناء مدة خدمتهم. على أنه لا يجوز لهم المطالبة بهذا الحق إلا خلال المدة المعتادة التى يقررها العرف بالنسبة إلى كل مهنة.$b676$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins676;

WITH ins677 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 677, 0, $h677$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 1- أركان العقد$h677$, $b677$لا يشترط فى عقد العمل أى شكل خاص، ما لم تنص القوانين واللوائح الإدارية على خلاف ذلك.$b677$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins677;

WITH ins678 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 678, 0, $h678$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 1- أركان العقد$h678$, $b678$(1) يجوز أن يبرم عقد لخدمة معينة أو لمدة معينة، كما يجوز أن يكون غير معين المدة.
(2) فإذا كان عقد العمل لمدة حياة العامل أو رب العمل أو لأكثر من خمس سنوات، جاز للعامل بعد انقضاء خمس سنوات أن يفسخ العقد دون تعويض على أن ينظر رب العمل إلى العمل إلى ستة أشهر.$b678$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins678;

WITH ins679 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 679, 0, $h679$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 1- أركان العقد$h679$, $b679$(1) إذا كان عقد العمل معين المدة أنتهى من تلقاء نفسه بانقضاء مدته.
(2) فإذا استمر طرفاه فى تنفيذ العقد بعد انقضاء مدته، أعتبر ذلك منهما تجديداً للعقد لمدة غير معينة.$b679$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins679;

WITH ins680 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 680, 0, $h680$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 1- أركان العقد$h680$, $b680$(1) إذا أبرم العقد لتنفيذ عمل معين أنتهى بانقضاء العمل المتفق عليه.
(2) فإذا كان العمل قابلاً بطبيعته لأن يتجدد، واستمر تنفيذ العقد بعد إنهاء العمل المتفق عليه، أعتبر العقد قد تجدد تجديداً ضمنياً للمدة اللازمة للقيام بالعمل ذاته مرة أخرى.$b680$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins680;

WITH ins681 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 681, 0, $h681$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 1- أركان العقد$h681$, $b681$يفترض فى أداء الخدمة أن يكون بأجر إذا كان قوام هذه الخدمة عملا لم تجر العادة بالتبرع به أو عملاً داخلاً فى مهنة من أدّاه.$b681$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins681;

WITH ins682 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 682, 0, $h682$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 1- أركان العقد$h682$, $b682$(1) إذا لم تنص العقود الفردية أو العقود الجماعية أو لوائح المصنع على الأجر الذى يلتزم به صاحب المصنع، أخذ بالسعر المقدر لعمل من ذات النوع إن وجد، وإلا فطبقاً لعرف المهنة وعرف الجهة التى يؤدى فيها العمل، فإن لم يوجد عرف تولى القاضى تقدير الأجر وفقاً لمقتضيات العدالة.
(2) ويتبع ذلك أيضاً فى تحديد نوع الخدمة الواجب على العامل أداؤها وفى تحديد مداها.$b682$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins682;

WITH ins683 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 683, 0, $h683$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 1- أركان العقد$h683$, $b683$تعتبر المبالغ الآتية جزءاً لا يتجزأ من الأجر الذى يحسب فى تعيين القدر الجائز الحجز عليه:
(1) العمالة التى تعطى للطوافين والمندوبين الجوابين والممثلين التجاريين.
(2) النسب المئوية التى تدفع إلى مستخدمى المحال التجارية عن ثمن ما يبيعونه والعلاوات التى تصرف لهم بسبب غلاء المعيشة.
(3) كل منحة تعطى للعامل على علاوة المرتب وما يصرف له جزءاً فى مقابل أمانته أو فى مقابل زيادة أعبائه العائلية وما شابه ذلك، إذا كانت هذه المبالغ مقررة فى عقود العمل الفردية أو لوائح المصنع أو جرى العرف يمنحها حتى أصبح عمال المصنع يعتبرونها جزءاً من الأجر لا تبرعاً على أن تكون هذه المبالغ معلومة المقدار قبل الحجز.$b683$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins683;

WITH ins684 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 684, 0, $h684$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 1- أركان العقد$h684$, $b684$(1) لا يلحق بالأجر ما يعطى على سبيل الوهبة إلا فى الصناعة أو التجارة التى جرى فيها العرف بدفع وهبة وتكون لها قواعد تسمح بضبطها.
(2) وتعتبر الوهبة جزءاً من الأجر، إذا كان ما يدفعه منها العملاء إلى صندوق مشترك يجمع فيه المتجر الواحد ليقوم رب العمل بذلك بتوزيعه على هؤلاء المستخدمين بنفسه أو تحت إشرافه.
(3) ويجوز فى بعض الصناعات كصناعات الفنادق والمطاعم والمقاهى والمشارب، ألا يكون للعامل أجر سوى ما يحصل عليه من وهبة وما يتناول من طعام.$b684$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins684;

WITH ins685 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 685, 0, $h685$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات العامل$h685$, $b685$يجب على العامل:
(أ) أن يؤدى العمل بنفسه، وأن يبذل فى تأديته من العناية ما يبذله الشخص المعتاد.
(ب) أن يأتمر بأوامر رب العمل الخاصة بتنفيذ العمل المتفق عليه الذى يدخل فى وظيفة العامل، إذا لم يكن فى هذه الأوامر ما يخالف العقد أو القانون أو الآداب، ولم يكن فى أطاعتها ما يعرض للخطر.
(ج) أن يحرص على حفظ الأشياء المسلمة إليه لتأدية عمله.
(د) أن يحفظ بأسرار العمل الصناعية والتجارية حتى بعد انقضاء العقد.$b685$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins685;

WITH ins686 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 686, 0, $h686$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات العامل$h686$, $b686$(1) إذا كان العمل الموكول إلى العامل يسمح له بمعرفة عملاء رب العمل أو بالاطلاع على سر أعماله كان للطرفين أن يتفقا على ألا يجوز للعامل بعد إنهاء العقد أن ينافس رب العمل أو أن يشترك فى أى مشروع يقوم بمنافسته.
(2) غير أنه يشترط لصحة هذا الاتفاق أن يتوافر فيه ما يأتي:
(أ) أن يكون العامل بالغاً رشده وقت إبرام العقد.
(ب) أن يكون القيد مقصوراً من حيث الزمان والمكان ونوع العمل، على القدر الضرورى لحماية مصالح رب العمل المشروعة.
(3) ولا يجوز أن يتمسك رب العمل بهذا الاتفاق إذا فسخ العقد أو رفض تجديده دون أن يقع من العامل ما يبرر ذلك، كما لا يجوز له أن يتمسك بالاتفاق إذا وقع منه هو ما يبرز فسخ العامل للعقد.$b686$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins686;

WITH ins687 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 687, 0, $h687$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات العامل$h687$, $b687$إذا اتفق على شرط جزائى فى حالة الإخلال بالامتناع عن المنافسة وكان فى الشرط مبالغة تجعله وسيلة لإجبار العامل على البقاء فى صناعة رب العمل مدة أطول من المدة المتفق عليها، كان هذا الشرط باطلاً وينسحب بطلانه أيضاً إلى شرط عدم المنافسة الذى يشتمل فى جملته.$b687$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins687;

WITH ins688 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 688, 0, $h688$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات العامل$h688$, $b688$(1) إذا وفق العامل إلى اختراع جديد أثناء خدمة رب العمل كان لهذا الاختراع حق لهذا العامل ولو كان العمل الذى قام به مناسبة لهذا الاختراع قد استنبطه فى غير ذلك من أعمال رب العمل.
(2) على أن ما يستنبطه العامل من اختراعات أثناء عمله يكون من حق رب العمل إذا كان تعهد به العامل التى تقتضى منه إفراغ جهده إلى الابتداء، أو إذا كان قد اشترط العقد صراحة أن يكون له الحق فيما يهتدى إليه من المخترعات.
(3) وإذا كان الاختراع ذا أهمية اقتصادية جدية، جاز للعامل فى الحالات المنصوص عليها فى الفقرة السابقة أن يطالب بمقابل خاص وفقاً لمقتضيات العدالة. ويراعى فى تقدير هذا المقابل مقدار المعونة التى قدمها رب العمل وما استخدم فى هذا السبيل من منشأته.$b688$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins688;

WITH ins689 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 689, 0, $h689$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات العامل$h689$, $b689$يجب على العامل إلى جانب الالتزامات المبينة فى المواد السابقة، أن يقوم بالالتزامات التى تفرضها القوانين الخاصة.$b689$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins689;

WITH ins690 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 690, 0, $h690$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات رب العمل$h690$, $b690$يلتزم رب العمل أن يدفع للعامل أجرته فى الزمان والمكان اللذين يحددهما العقد أو العرف مع مراعاة ما تقضى به القوانين الخاصة فى ذلك.$b690$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins690;

WITH ins691 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 691, 0, $h691$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات رب العمل$h691$, $b691$(1) إذا نص العقد على أن يكون للعامل فوق الأجر المتفق عليه أو بدلاً منه حق فى جزء من أرباح رب العمل أو فى نسبة مئوية من جملة الإيراد أو من مقدار الإنتاج أو ما يتحقق من وفر، وجب على رب العمل أن يقدم إلى العامل عند كل استحقاق بياناً يستحقه بما من ذلك.
(2) ويجب على رب العمل أن يقدم فوق هذا إلى العامل أو إلى شخص موثوق به ذى شأن يعينه القاضى، المعلومات الضرورية للتحقق من صحة هذا البيان، وأن يأذن له فى الإطلاع على ذلك فى دفاتره.$b691$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins691;

WITH ins692 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 692, 0, $h692$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات رب العمل$h692$, $b692$(1) إذا حضر العامل أو المستخدم لمزاولة عمله فى الفترة اليومية التى يلزمه بها عقد العمل، أو أعلن أنه مستعد لمزاولة عمله فى هذه الفترة ولم يمنعه من العمل سبب راجع إلى رب العمل، كان له الحق فى أجر ذلك اليوم.$b692$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins692;

WITH ins693 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 693, 0, $h693$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 2- أحكام العقد > التزامات رب العمل$h693$, $b693$يجب على رب العمل إلى جانب التزاماته المبينة فى المواد السابقة أن يقوم بالالتزامات التى تفرضها القوانين الخاصة.$b693$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins693;

WITH ins694 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 694, 0, $h694$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 3- انتهاء عقد العمل$h694$, $b694$(1) ينتهى عقد العمل بانقضاء مدته أو بإنجاز العمل الذى أبرم من أجله، وذلك مع عدم الإخلال بأحكام المادتين 678، 679.
(2) فإن لم تعين مدة العقد بالاتفاق أو بنوع العمل أو بالغرض منه، جاز لكل من المتعاقدين أن يضع حداً لعلاقته مع المتعاقد الآخر. ويجب فى استعمال هذا الحق أن يسبقه إخطار، وطريقة الإخطار ومدته تبينها القوانين الخاصة.$b694$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins694;

WITH ins695 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 695, 0, $h695$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 3- انتهاء عقد العمل$h695$, $b695$(1) إذا كان العقد أبرم لمدة غير معينة، ونقضه أحد المتعاقدين دون مراعاة لميعاد الإخطار، أو قبل انقضاء هذا الميعاد، لزمه أن يعوض المتعاقد الآخر عن مدة هذا الميعاد أو عن المدة الباقية منه. ويشمل التعويض فوق الأجر الذى كان يستحق خلال هذه المدة جميع ملحقات الأجر التى تكون ثابتة ومعينة، مع مراعاة ما تقضى به القوانين الخاصة.
(2) وإذا فسخ العقد بتعسف من أحد المتعاقدين كان للمتعاقد الآخر، إلى جانب التعويض الذى يكون مستحقاً له بسبب عدم مراعاة ميعاد الإخطار، الحق فى تعويض ما أصابه من ضرر بسبب فسخ العقد فسخاً تعسفياً. ويعتبر الفصل تعسفياً إذا وقع بسبب حجوز أوقعت تحت يد رب العمل، أو وقع هذا الفصل بسبب ديون يكون العامل قد ألتزم بها للغير.$b695$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins695;

WITH ins696 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 696, 0, $h696$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 3- انتهاء عقد العمل$h696$, $b696$(1) يجوز الحكم بالتعويض عن الفصل ولو لم يصدر هذا الفصل بصدد هذا الفصل من رب العمل إذا كان الأخير قد دفع، وعلى الأخص بمعاملته الجائزة بمخالفته شروط العقد أو الظاهر الذى أنهى العقد.
(2) ونقل العامل إلى مركز أقل ملاءمة أو ميزة عن المركز الذى كان يشغله لا يعد عملاً تعسفياً مباشر إذا ما اقتضته مصلحة العمل، ولكنه يعد كذلك إذا كان الغرض منه إساءة العامل.$b696$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins696;

WITH ins697 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 697, 0, $h697$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 3- انتهاء عقد العمل$h697$, $b697$(1) لا ينفسخ عقد العمل بوفاة رب العمل، ما لم تكن شخصيته قد روعيت فى إبرام العقد، ولكن ينفسخ العقد بوفاة العامل.
(2) ويراعى فى فسخ العقد لوفاة العامل أو لمرضه مرضاً طويلاً أو لسبب قاهر آخر من شأنه ان يمنع العامل من الاستمرار فى العمل الأحكام التى نصت عليها قوانين العمل الخاصة.$b697$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins697;

WITH ins698 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 698, 0, $h698$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثانى - عقد العمل > 3- انتهاء عقد العمل$h698$, $b698$(1) تسقط بالتقادم الدعاوى الناشئة عن عقد العمل بانقضاء سنة من وقت إنهاء العقد، إلا فيما يتعلق بالعمالة والمشاركة فى الأرباح والنسب المئوية فى جملة الإيراد فإن مدة السنة لا تبدأ إلا من الوقت الذى يسلم فيه رب العمل إلى العامل بياناً يستحقه بحسب آخر جرد.
(2) ولا يسرى هذا التقادم الخاص على الدعاوى المتعلقة بانتهاك حرمة الأسرار التجارية أو بتنفيذ عقد العمل فيما يرمى إلى ضمان احترام هذه الأسرار.$b698$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins698;

WITH ins699 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 699, 0, $h699$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 1- أركان الوكالة$h699$, $b699$الوكالة عقد بمقتضاه يلتزم الوكيل بأن يقوم بعمل قانونى لحساب الموكل.$b699$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins699;

WITH ins700 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 700, 0, $h700$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 1- أركان الوكالة$h700$, $b700$يجب أن يتوافر فى الوكيل وفى الموكل الشروط الواجب توافرها فى العمل القانونى الذى يكون محل الوكالة، ما لم يوجد نص يقضى بغير ذلك.$b700$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins700;

WITH ins701 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 701, 0, $h701$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 1- أركان الوكالة$h701$, $b701$(1) الوكالة الواردة فى ألفاظ عامة لا تخصيص فيها حتى لنوع العمل القانونى الحاصل التوكيل فيه، لا تخول الوكيل صفة إلا فى أعمال الإدارة.
(2) ويعد من أعمال الإدارة الإيجار إذا لم تزد مدته على ثلاث سنوات وأعمال الحفظ والصيانة واستيفاء الحقوق ووفاء الديون. ويدخل فيها أيضاً كل عمل من أعمال التصرف تقتضيه الإدارة كبيع المحصول وبيع البضاعة أو المنقول الذى يسرع إليه التلف وشراء ما يستلزمه الشىء من أدوات لحفظه ولاستغلاله.$b701$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins701;

WITH ins702 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 702, 0, $h702$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 1- أركان الوكالة$h702$, $b702$(1) لابد من وكالة خاصة فى كل عمل ليس من أعمال الإدارة، وبوجه خاص فى البيع والرهن والتبرعات والإقرار والصلح وتوجيه اليمين والمرافعة أمام القضاء.
(2) والوكالة الخاصة فى نوع معين من أنواع الأعمال القانونية تصح ولو لم يعين محل هذا العمل على وجه التخصيص، إلا إذا كان العمل من نوع التبرعات.
(3) والوكالة الخاصة لا تجعل للوكيل صفة إلا فيما تباشره من الأمور المحددة فيها وما تقتضيه هذه الأمور من توابع ضرورية وفقاً لطبيعة كل أمر وللعرف الجارى.$b702$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins702;

WITH ins703 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 703, 0, $h703$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h703$, $b703$(1) الوكيل ملزم بتنفيذ الوكالة دون أن يجاوز حدودها المرسومة.
(2) على أن له أن يخرج عن هذه الحدود متى كان من المستحيل عليه إخطار الموكل سلفاً وكانت الظروف يغلب معها الظن بأن الموكل ما كان إلا ليوافق على هذا التصرف، وعلى الوكيل فى هذه الحالة أن يبادر بإبلاغ الموكل خروجه عن حدود الوكالة.$b703$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins703;

WITH ins704 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 704, 0, $h704$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h704$, $b704$(1) إذا كانت الوكالة بلا أجر وجب على الوكيل أن يبذل فى تنفيذها من العناية التى يبذلها فى أعماله الخاصة، دون أن يكلف فى ذلك أزيد من عناية الرجل المعتاد.
(2) فإن كانت بأجر وجب على الوكيل أن يبذل دائماً فى تنفيذها عناية الرجل المعتاد.$b704$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins704;

WITH ins705 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 705, 0, $h705$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h705$, $b705$على الوكيل أن يوافى الموكل بالمعلومات الضرورية عما وصل إليه فى تنفيذ الوكالة، وأن يقدم له حساباً عنها.$b705$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins705;

WITH ins706 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 706, 0, $h706$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h706$, $b706$(1) ليس للوكيل أن يستعمل مال الموكل لصالح نفسه.
(2) وعليه فوائد المبالغ التى استخدمها لصالحه من وقت استخدامها، وعليه أيضاً فوائد ما تبقى فى ذمته من حساب الوكالة من وقت أن يعذر.$b706$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins706;

WITH ins707 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 707, 0, $h707$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h707$, $b707$(1) إذا تعدد الوكلاء كانوا مسئولين بالتضامن متى كانت الوكالة غير قابلة للانقسام، أو كان الضرر الذى أصاب الموكل ناتجاً عن خطأ مشترك، على أن الوكلاء ولو كانوا متضامنين لا يسألون عما فعله أحدهم مجاوزاً حدود الوكالة أو مجاوزاً حدود تنفيذها.
(2) وإذا عين الوكلاء فى عقد واحد دون أن يرخص لهم فى العمل منفردين كان عليهم أن يعملوا مجتمعين إلا إذا كان العمل مما يحتاج فيه إلى تبادل الرأى كقبض الدين أو وفائه.$b707$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins707;

WITH ins708 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 708, 0, $h708$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h708$, $b708$(1) إذا أناب الوكيل عنه غيره فى تنفيذ الوكالة دون أن يكون مرخصاً له فى ذلك، كان مسئولاً عن عمل النائب كما لو كان هذا العمل قد صدر منه هو، ويكون الوكيل ونائبه متضامنين فى هذه الحالة فى المسئولية.
(2) أما إذا رخص للوكيل فى إقامة نائب عنه دون أن يعين شخص هذا النائب، فإن الوكيل لا يكون مسئولاً إلا عن خطئه فى اختيار نائبه، أو عن خطئه فيما أصدره إليه من تعليمات.
(3) ويجوز فى الحالتين السابقتين للموكل ولنائب الوكيل أن يرجع كل منهما مباشرة على الآخر.$b708$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins708;

WITH ins709 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 709, 0, $h709$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h709$, $b709$(1) الوكالة تبرعية، ما لم يتفق على غير ذلك صراحة أو يستخلص ضمناً من حالة الوكيل.
(2) فإذا اتفق على أجر للوكالة كان هذا الأجر خاضعاً لتقدير القاضى، إلا إذا دفع طوعاً بعد تنفيذ الوكالة.$b709$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins709;

WITH ins710 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 710, 0, $h710$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h710$, $b710$على الموكل أن يرد للوكيل ما أنفقه فى تنفيذ الوكالة التنفيذ المعتاد مع الفوائد من وقت الإنفاق مهما كان حظ الوكيل من النجاح فى تنفيذ الوكالة. فإذا اقتضى تنفيذ الوكالة أن يقدم الوكيل للموكل مبالغ للإنفاق منها فى شئون الوكالة، وجب على الموكل أن يقدم هذه المبالغ إذا طلب الوكيل ذلك.$b710$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins710;

WITH ins711 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 711, 0, $h711$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h711$, $b711$يكون الموكل مسئولاً عما أصاب الوكيل من ضرر دون خطأ منه بسبب تنفيذه الوكالة تنفيذاً معتاداً.$b711$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins711;

WITH ins712 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 712, 0, $h712$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h712$, $b712$إذا وكل أشخاص متعددون وكيلاً واحداً فى عمل مشترك كان جميع الموكلين متضامنين قبل الوكيل فى تنفيذ الوكالة ما لم يتفق على غير ذلك.$b712$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins712;

WITH ins713 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 713, 0, $h713$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 2- آثار الوكالة$h713$, $b713$تطبق المواد من 104 إلى 107 الخاصة بالنيابة فى علاقة الموكل والوكيل بالغير الذى يتعامل مع الوكيل.$b713$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins713;

WITH ins714 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 714, 0, $h714$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 3- انتهاء الوكالة$h714$, $b714$تنتهى الوكالة بإتمام العمل الموكل فيه أو بانهاء الأجل المعين للوكالة وتنتهى أيضاً بموت الموكل أو الوكيل.$b714$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins714;

WITH ins715 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 715, 0, $h715$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 3- انتهاء الوكالة$h715$, $b715$(1) يجوز للموكل فى أى وقت أن ينهى أو يقيد الوكالة ولو وجد اتفاق يخالف ذلك. فإذا كانت الوكالة بأجر فإن الموكل يكون ملزماً بتعويض الوكيل عن الضرر الذى لحقه من جراء إنهائها فى وقت غير مناسب أو بغير عذر مقبول.
(2) على أنه إذا كانت الوكالة صادرة لمصلحة الوكيل أو لمصلحة أجنبى، فلا يجوز للموكل أن ينهيها أو يقيدها دون رضاء من صدرت الوكالة لمصلحته.$b715$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins715;

WITH ins716 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 716, 0, $h716$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 3- انتهاء الوكالة$h716$, $b716$(1) للوكيل أن ينزل فى أى وقت عن الوكالة ولو وجد اتفاق يخالف ذلك، ويتم التنازل بإعلانه للموكل. فإذا كانت الوكالة بأجر فإن الوكيل يكون ملزماً بتعويض الموكل عن الضرر الذى لحقه من جراء التنازل فى وقت غير مناسب وبغير عذر مقبول.
(2) غير أنه لا يجوز للوكيل أن ينزل عن الوكالة متى كانت صادرة لمصلحة أجنبى إلا إذا وجدت أسباب جدية تبرر ذلك على أن يخطر الأجنبى بهذا التنازل وقتاً يمهله ليتخذ ما يلزم لصيانة مصالحه.$b716$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins716;

WITH ins717 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 717, 0, $h717$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الثالث - الوكالة > 3- انتهاء الوكالة$h717$, $b717$(1) على أى وجه كان انتهاء الوكالة، يجب على الوكيل أن يصل بالأعمال التى بدأها إلى حالة لا تتعرض معها إلى التلف.
(2) وفى حالة انتهاء الوكالة بموت الوكيل يجب على ورثته، إذا توافرت فيهم الأهلية وكانوا على علم بالوكالة، أن يبادروا إلى إخطار الموكل بموت الوكيل وأن يتخذوا من التدبيرات ما تقتضيه الحال لمصلحة الموكل.$b717$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins717;

WITH ins718 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 718, 0, $h718$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة$h718$, $b718$الوديعة عقد يلتزم به شخص أن يتسلم شيئاً من آخر على أن يتولى حفظ هذا الشىء وعلى أن يرده عيناً.$b718$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins718;

WITH ins719 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 719, 0, $h719$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 1- التزامات المودع عنده$h719$, $b719$(1) على المودع عنده أن يتسلم الوديعة.
(2) وليس له أن يستعملها دون أن يأذن له المودع فى ذلك صراحة أو ضمناً.$b719$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins719;

WITH ins720 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 720, 0, $h720$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 1- التزامات المودع عنده$h720$, $b720$(1) إذا كانت الوديعة بغير أجر وجب على المودع عنده أن يبذل من العناية فى حفظ الشىء ما يبذله فى حفظ ماله، دون أن يكلف فى ذلك أزيد من عناية الرجل المعتاد.
(2) أما إذا كانت الوديعة بأجر فيجب أن يبذل فى حفظ الوديعة عناية الرجل المعتاد.$b720$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins720;

WITH ins721 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 721, 0, $h721$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 1- التزامات المودع عنده$h721$, $b721$يجب على المودع عنده ألا يحل غيره محله فى حفظ الوديعة دون إذن صريح من المودع إلا أن يكون مضطراً لذلك بسبب ضرورة ملجئة عاجلة.$b721$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins721;

WITH ins722 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 722, 0, $h722$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 1- التزامات المودع عنده$h722$, $b722$يجب على المودع عنده أن يسلم الشىء إلى المودع بمجرد طلبه إلا إذا ظهر من العقد أن الأجل من مصلحة المودع عنده فى حفظ الشىء إلى أى وقت، إلا إذا ظهر من العقد أن الأجل من مصلحة المودع.$b722$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins722;

WITH ins723 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 723, 0, $h723$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 1- التزامات المودع عنده$h723$, $b723$إذا باع وارث المودع الشىء عنده وهو حسن النية، فليس عليه لمالكه إلا رد ما قبضه من الثمن، أو التنازل له عن حقوقه قبل المشترى، وأما إذا كان عالماً بحقوقه فإنه يلتزم بقيمة الشىء وقت التصرف فيه.$b723$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins723;

WITH ins724 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 724, 0, $h724$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 2- التزامات المودع$h724$, $b724$الأصل فى الوديعة أن تكون بغير أجر، فإذا اتفق على أجر وجب على المودع أن يؤديه، ما لم يوجد اتفاق يقضى بغير ذلك.$b724$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins724;

WITH ins725 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 725, 0, $h725$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 2- التزامات المودع$h725$, $b725$على المودع أن يرد إلى المودع عنده ما أنفقه فى حفظ الشىء، وعليه أن يعوضه عن كل ما لحقه من خسارة بسبب الوديعة.$b725$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins725;

WITH ins726 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 726, 0, $h726$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 3- بعض أنواع الوديعة$h726$, $b726$إذا كانت الوديعة مبلغاً من النقود أو أى شىء آخر مما يهلك بالاستعمال، وكان المودع عنده مأذوناً له فى استعمال الشىء اعتبر العقد قرضاً.$b726$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins726;

WITH ins727 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 727, 0, $h727$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 3- بعض أنواع الوديعة$h727$, $b727$(1) يكون أصحاب الفنادق والخانات وأمثالها مسئولين عما يجب عليهم أن يحفظوه من عناية فيما يأتى به المسافرون والنزلاء من الأشياء التى يأتون بها إلى الفندق أو الخان.
(2) غير أنهم لا يكونون مسئولين فيما يتعلق بالنقود والأوراق المالية والأشياء الثمينة عن تعويض يجاوز خمسين جنيهاً، ما لم يكونوا قد أخذوا على عاتقهم حفظ هذه الأشياء وهم يعرفون قيمتها، أو يكونوا قد رفضوا دون مسوغ أن يتسلموها عهدة فى ذمتهم، أو يكونوا قد تسببوا فى وقوع الضرر بخطأ جسيم منهم أو من أحد تابعيهم.$b727$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins727;

WITH ins728 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 728, 0, $h728$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الرابع - الوديعة > 3- بعض أنواع الوديعة$h728$, $b728$(1) على المسافر أن يخطر صاحب الفندق أو الخان بسرقة الشىء أو ضياعه أو تلفه بمجرد علمه بوقوع شىء من ذلك. فإن أبطأ فى الأخطار دون مسوغ سقطت حقوقه.
(2) وتسقط بالتقادم دعوى المسافر قبل صاحب الفندق أو الخان بانقضاء ستة أشهر من اليوم الذى يغادر فيه الفندق أو الخان.$b728$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins728;

WITH ins729 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 729, 0, $h729$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h729$, $b729$الحراسة عقد يعهد الطرفان بمقتضاه إلى شخص آخر بمنقول أو عقار أو مجموع من المال نزاع فى شأنه يكون الحق فيه غير ثابت. فيتكفل هذا الشخص بحفظه وبإدارته وبرده مع غلته إلى من يثبت له الحق فيه.$b729$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins729;

WITH ins730 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 730, 0, $h730$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h730$, $b730$يجوز للقضاء أن يأمر بالحراسة:
(1) فى الأحوال المشار إليها فى المادة السابقة إذا لم يتفق ذوو الشأن على الحراسة.
(2) إذا كان صاحب المصلحة فى منقول أو عقار قد تجمع لديه من الأسباب المعقولة ما يخشى معه خطراً عاجلاً من بقاء المال تحت يد حائزة.
(3) فى الأحوال الأخرى المنصوص عليها فى القانون.$b730$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins730;

WITH ins731 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 731, 0, $h731$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h731$, $b731$تجوز الحراسة القضائية على الأموال الموقوفة فى الأحوال الآتية:
(1) إذا كان الوقف شاغراً أو قام بين نظاره أو بين من يدعون حق النظر عليه نزاع أو كانت هناك دعوى مرفوعة بعزل الناظر، وكل هذا إذا تبين أن الحراسة إجراء لابد منه للمحافظة على ما قد يكون لدى ذوى الشأن من الحقوق. وتنتهى الحراسة فى هذه الأحوال إذا عين ناظر على الوقف سواء أكان بصفة مؤقتة أم بصفة نهائية.
(2) إذا كان الوقف مديناً.
(3) إذا كان أحد المستحقين معسراً مدنياً، وتكون الحراسة على حصته وحدها إن أمكن فرزها ولو بقسمة مؤقتة، وإلا ففعلى الوقف كله، ويشترط أن تكون الحراسة فى الحالين هى الوسيلة الوحيدة لعدم ضياع حقوق الدائنين بسبب سوء إدارة الناظر أو سوء نيته.$b731$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins731;

WITH ins732 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 732, 0, $h732$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h732$, $b732$يكون تعيين الحارس سواء أكانت الحراسة اتفاقية أم كانت قضائية باتفاق ذوى الشأن جميعاً، فإذا لم يتفقوا تولى القاضى تعيينه.$b732$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins732;

WITH ins733 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 733, 0, $h733$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h733$, $b733$يحدد الاتفاق أو الحكم القاضى بالحراسة ما على الحارس من التزامات وما له من حقوق وسلطة، وإلا فتطبق أحكام الوديعة والوكالة بالقدر الذى لا تتعارض فيه مع الأحكام الآتية:$b733$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins733;

WITH ins734 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 734, 0, $h734$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h734$, $b734$(1) يلتزم الحارس بالمحافظة على الأموال المعهودة إليه حراستها وبإدارة هذه الأموال، ويجب أن يبذل فى كل ذلك عناية الرجل المعتاد.
(2) ولا يجوز له بطريق مباشر أو غير مباشر أن يحل محله فى أداء مهمته كلها أو بعضها أحد دون رضاء ذوى الشأن الآخرين.$b734$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins734;

WITH ins735 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 735, 0, $h735$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h735$, $b735$لا يجوز للحارس فى غير أعمال الإدارة أن يتصرف إلا برضاء ذوى الشأن جميعاً أو بترخيص من القضاء.$b735$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins735;

WITH ins736 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 736, 0, $h736$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h736$, $b736$للحارس أن يتقاضى أجراً ما لم يكن قد نزل عنه.$b736$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins736;

WITH ins737 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 737, 0, $h737$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h737$, $b737$(1) يلتزم الحارس باتخاذ حساب دفاتر منظمة ويجوز للقاضى إلزامه باتخاذ دفاتر موقع عليها من المحكمة.
(2) ويلتزم أن يقدم لذوى الشأن كل سنة على الأكثر حساباً بما تسلمه وبما أنفقه، معززاً بما يثبت ذلك من مستندات وإذا كان الحارس قد عينته المحكمة وجب عليه فوق ذلك أن يودع صورة من هذا الحساب قلم كتابها.$b737$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins737;

WITH ins738 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 738, 0, $h738$الكتاب الثانى - العقود المسماة > الباب الثالث - العقود الواردة على العمل > الفصل الخامس - الحراسة$h738$, $b738$(1) تنتهى الحراسة باتفاق ذوى الشأن جميعاً أو يحكم القضاء.
(2) وعلى الحارس حينئذ أن يبادر إلى رد الشىء المعهود إليه حراسته إلى من يختاره ذوو الشأن أو من يعينه القاضى.$b738$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins738;

WITH ins739 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 739, 0, $h739$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الأول - المقامرة والرهان$h739$, $b739$(1) يكون باطلا كل اتفاق خاص بمقامرة أو رهان.
(2) ولمن خسر فى مقامرة أو رهان أن يسترد ما دفعه خلال ثلاث سنوات من الوقت الذى أدى فيه ما خسره ولو كان هناك اتفاق يقضى بغير ذلك. وله أن يثبت ما أداه بجميع الطرق.$b739$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins739;

WITH ins740 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 740, 0, $h740$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الأول - المقامرة والرهان$h740$, $b740$(1) يستثنى من أحكام المادة السابقة الرهان الذى يعقده المتبارون شخصياً فيما بينهم فى الألعاب الرياضية، ولكن للقاضى أن يخفض قيمة هذا الرهان إذا كان مبالغاً فيه.
(2) ويستثنى أيضاً ما رخص فيه قانوناً من أوراق النصيب.$b740$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins740;

WITH ins741 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 741, 0, $h741$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثانى - المرتب مدى الحياة$h741$, $b741$(1) يجوز للشخص أن يلتزم بأن يؤدى إلى شخص آخر مرتباً دورياً بعوض أو بغير عوض.
(2) ويكون هذا الالتزام بعقد أو بوصية.$b741$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins741;

WITH ins742 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 742, 0, $h742$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثانى - المرتب مدى الحياة$h742$, $b742$(1) يجوز أن يكون المرتب مقرراً مدى حياة الملتزم له أو مدى حياة الملتزم أو مدى حياة شخص آخر.
(2) ويعتبر المرتب مقرراً مدى حياة الملتزم له إذا لم يوجد اتفاق يقضى بغير ذلك.$b742$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins742;

WITH ins743 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 743, 0, $h743$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثانى - المرتب مدى الحياة$h743$, $b743$العقد الذى يقرر المرتب لا يكون صحيحاً إلا إذا كان مكتوباً، وهذا دون إخلال بما يتطلبه القانون من شكل خاص لعقود التبرع.$b743$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins743;

WITH ins744 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 744, 0, $h744$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثانى - المرتب مدى الحياة$h744$, $b744$لا يصح أن يشترط عدم جواز الحجز على المرتب إلا إذا كان قد قرر على سبيل التبرع.$b744$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins744;

WITH ins745 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 745, 0, $h745$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثانى - المرتب مدى الحياة$h745$, $b745$(1) لا يكون للمستحق حق فى المرتب إلا عن الأيام التى عاشها من مدة المرتب مدى حياته.
(2) على أنه إذا اشترط الدفع مقدماً كان للمستحق حق فى القسط الذى حل.$b745$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins745;

WITH ins746 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 746, 0, $h746$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثانى - المرتب مدى الحياة$h746$, $b746$إذا لم يقم المدين بالتزامه كان للمستحق أن يطلب تنفيذ العقد، فإن كان العقد بعوض جاز له أيضاً أن يطلب فسخه مع التعويض إن كان له محل.$b746$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins746;

WITH ins747 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 747, 0, $h747$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 1- أحكام عامة$h747$, $b747$التأمين عقد يلتزم المؤمن بمقتضاه أن يؤدى إلى المؤمن له أو إلى المستفيد الذى اشترط التأمين لصالحه مبلغاً من المال أو إيراداً مرتباً أو أى عوض مالى آخر فى حالة وقوع الحادث أو تحقق الخطر المبين بالعقد وذلك نظير قسط أو أية دفعة مالية أخرى يؤديها المؤمن له للمؤمن.$b747$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins747;

WITH ins748 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 748, 0, $h748$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 1- أحكام عامة$h748$, $b748$الأحكام المتعلقة بعقد التأمين التى لم يرد ذكرها فى هذا القانون ينظمها القوانين الخاصة.$b748$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins748;

WITH ins749 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 749, 0, $h749$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 1- أحكام عامة$h749$, $b749$يكون محلا للتأمين كل مصلحة اقتصادية مشروعة تعود على الشخص من عدم وقوع خطر معين.$b749$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins749;

WITH ins750 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 750, 0, $h750$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 1- أحكام عامة$h750$, $b750$يقع باطلا ما يرد فى وثيقة التأمين من الشروط الآتية:
(1) الشرط الذى يقضى بسقوط الحق فى التأمين بسبب مخالفة القوانين واللوائح، إلا إذا انطوت هذه المخالفة على جناية أو جنحة عمدية.$b750$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins750;

WITH ins751 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 751, 0, $h751$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 1- أحكام عامة$h751$, $b751$لا يلتزم المؤمن فى تعويض المؤمن له إلا عن الضرر الناتج من وقوع الخطر المؤمن منه بشرط ألا يجاوز ذلك قيمة التأمين.$b751$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins751;

WITH ins752 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 752, 0, $h752$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 1- أحكام عامة$h752$, $b752$(1) تسقط بالتقادم الدعاوى الناشئة عن عقد التأمين بانقضاء ثلاث سنوات من وقت حدوث الواقعة التى تولدت عنها هذه الدعاوى.
(2) ومع ذلك لا تسرى هذه المدة:
أ. فى حالة إخفاء بيانات متعلقة بالخطر المؤمن منه، أو تقديم بيانات غير صحيحة أو غير دقيقة عن هذا الخطر إلا من اليوم الذى علم فيه المؤمن بذلك.
ب. فى حالة وقوع الحادث المؤمن منه إلا من اليوم الذى علم فيه ذوو الشأن بوقوعه.$b752$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins752;

WITH ins753 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 753, 0, $h753$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 1- أحكام عامة$h753$, $b753$يقع باطلا كل اتفاق يخالف أحكام النصوص الواردة فى هذا الفصل، إلا أن يكون ذلك لمصلحة المؤمن له أو لمصلحة المستفيد.$b753$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins753;

WITH ins754 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 754, 0, $h754$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h754$, $b754$المبالغ التى يلتزم المؤمن فى التأمين على الحياة بدفعها إلى المؤمن له أو إلى المستفيد عند وقوع الحادث المؤمن منه أو حلول الأجل المنصوص عليه فى وثيقة التأمين تصبح مستحقة من وقت وقوع الحادث أو حلول الأجل دون حاجة إلى إثبات ضرر أصاب المؤمن له أو أصحاب المستفيد.$b754$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins754;

WITH ins755 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 755, 0, $h755$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h755$, $b755$(1) يقع باطلا التأمين على حياة الغير ما لم يوافق عليه الغير كتابة قبل إبرام العقد. فإذا كان هذا الغير لا تتوافر فيه الأهلية فلا يكون العقد صحيحاً إلا بموافقة من يمثله قانوناً.
(2) وتكون هذه الموافقة لازمة لصحة حوالة الحق فى الاستفادة من التأمين أو لصحة رهن هذا الحق.$b755$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins755;

WITH ins756 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 756, 0, $h756$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h756$, $b756$(1) تبرأ ذمة المؤمن من التزامه بدفع مبلغ التأمين على الحياة إذا انتحر الشخص المؤمن على حياته. ومع ذلك يلتزم المؤمن أن يدفع لمن يؤول إليهم الحق مبلغاً يساوى قيمة الاحتياطى التأميني.
(2) فإذا كان سبب الانتحار اضطراباً عقلياً أفقد المؤمن عليه إرادته، بقى التزام المؤمن قائماً بأكمله، وعلى المستفيد أن يثبت أن المؤمن عليه مات منتحراً وقت انتحاره فاقد الإرادة.
(3) وإذا اشتملت وثيقة التأمين على شرط يلزم المؤمن بدفع مبلغ التأمين ولو كان الانتحار عن اختيار وإدراك، فلا يكون هذا الشرط نافذاً إلا إذا وقع الانتحار بعد سنتين من تاريخ العقد.$b756$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins756;

WITH ins757 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 757, 0, $h757$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h757$, $b757$(1) إذا كان التأمين على حياة شخص غير المؤمن له، برئت ذمة المؤمن من التزاماته متى تسبب المؤمن له عمداً فى وفاة ذلك الشخص، أو وقعت الوفاة بناء على تحريض منه.
(2) وإذا كان التأمين على الحياة لصالح مستفيد غير المؤمن له، فلا يستفيد هذا الشخص من التأمين إذا تسبب عمداً فى وفاة الشخص المؤمن على حياته، أو وقعت الوفاة بناء على تحريض منه. فإذا كان ما وقع من هذا الشخص مجرد شروع فى إحداث الوفاة، كان للمؤمن له الحق فى أن يستبدل بالمستفيد شخصاً آخر، ولو كان المستفيد قد اشترط ما قبل ذلك لمصلحته من تأمين.$b757$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins757;

WITH ins758 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 758, 0, $h758$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h758$, $b758$(1) يجوز فى التأمين على الحياة الاتفاق على أن يدفع مبلغ التأمين، إما إلى أشخاص معينين، وإما إلى أشخاص يعينهم المؤمن له فيما بعد.
(2) ويعتبر التأمين معقوداً لمصلحة مستفيدين معينين إذا ذكر المؤمن له فى الوثيقة أن المؤمن له زوجه أو أولاده أو فروعه، من يولد منهم ومن لم يولد، أو لورثته دون ذكر أسمائهم. فإذا كان التأمين لصالح الورثة كان لهؤلاء الحق فى مبلغ التأمين كل بنسبة نصيبه فى الميراث. ويثبت لهم هذا الحق ولو نزلوا عن الإرث.
(3) ويقصد بالزوج الشخص الذى تثبت له هذه الصفة وقت وفاة المؤمن له، ويقصد بالأولاد الفروع الذين لهم فى ذلك الوقت حق الإرث.$b758$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins758;

WITH ins759 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 759, 0, $h759$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h759$, $b759$يجوز للمؤمن له الذى التزم بدفع أقساط دورية، أن يتحلل فى أى وقت من العقد بإخطار كتابى يرسله إلى المؤمن قبل انتهاء الفترة الجارية من الأقساط اللاحقة، وفى هذه الحالة تبرأ ذمته من الأقساط اللاحقة.$b759$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins759;

WITH ins760 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 760, 0, $h760$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h760$, $b760$(1) فى العقود المبرمة مدى الحياة التى التزم اشتراط بقاء المؤمن عليه على قيد حياة مدة معينة، وفى جميع العقود المشترط فيها دفع مبلغ التأمين بعد عدد معين من السنين، يجوز للمؤمن له متى كان قد دفع ثلاثة أقساط سنوية على الأقل أن يستبدل بالوثيقة الأصلية وثيقة مدفوعة فى مقابل تخفيض فى قيمة مبلغ التأمين الحادث المؤمن منه يكون محقق الوقوع.
(2) ولا يكون قابلا للتخفيض التأمين على الحياة إذا كان مؤقتاً.$b760$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins760;

WITH ins761 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 761, 0, $h761$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h761$, $b761$إذا خفض التأمين فلا يجوز أن ينزل عن الحدود الآتية:
(أ) فى العقود المبرمة مدى الحياة لا يجوز أن يقل مبلغ التأمين المخفض عن القيمة التى كان يستحقها المؤمن له لو دفع ما كان قد دفعه احتياطى تأمينى مخصوماً منه فى تاريخ التخفيض 1% من مبلغ التأمين الأصلي، باعتبار أن هذا المبلغ هو مقابل التأمين الذى يجب دفعه مرة واحدة فى تأمين من ذات النوع وطبقاً لتعريفة التأمين التى كانت مرعية فى عقد التأمين الأصلي.
(ب) فى العقود المتفق فيها على دفع مبلغ التأمين بعد عدد معين من السنين، لا يجوز أن يقل مبلغ التأمين المخفض عن جزء من مبلغ التأمين الأصلى نسبته إلى مبلغ التأمين الأصلى تعادل النسبة بين القسط المتفق عليه الذى سدد والقسط الواجب أداؤه على أساس السن الحقيقية.$b761$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins761;

WITH ins762 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 762, 0, $h762$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h762$, $b762$(1) يجوز أيضاً للمؤمن له، متى كان قد دفع ثلاثة أقساط سنوية على الأقل، أن يصفى التأمين بشرط أن يكون محقق الوقوع.
(2) ولا يكون قابلاً للتصفية، التأمين على الحياة إذا كان مؤقتاً.$b762$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins762;

WITH ins763 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 763, 0, $h763$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h763$, $b763$تعتبر شروط التخفيض والتصفية جزءاً من الشروط العامة للتأمين ويجب أن تذكر فى وثيقة التأمين.$b763$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins763;

WITH ins764 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 764, 0, $h764$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h764$, $b764$(1) لا يترتب على البيانات الخاطئة أو الغلط فى سن الشخص الذى عقد التأمين على حياته بطلان التأمين، إلا إذا كانت السن الحقيقية للمؤمن عليه تجاوز الحد المعين الذى نصت عليه تعريفة التأمين.
(2) وفى غير ذلك من الأحوال، إذا ترتب على البيانات الخاطئة أو الغلط أن كان القسط المتفق عليه أقل من القسط الذى كان يجب أداؤه، وجب تخفيض مبلغ التأمين بما يتعادل مع النسبة بين القسط المتفق عليه والقسط الواجب أداؤه على أساس السن الحقيقية.
(3) أما إذا كان القسط المتفق عليه أكبر مما كان يجب دفعه على أساس السن الحقيقية للمؤمن على حياته، وجب على المؤمن أن يرد دون فوائد الزيادة التى حصل عليها، وأن يخفض الأقساط التالية إلى الحد الذى يتناسب مع السن الحقيقية للمؤمن عليه.$b764$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins764;

WITH ins765 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 765, 0, $h765$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين على الحياة$h765$, $b765$فى التأمين على الحياة لا يكون للمؤمن الذى دفع مبلغ التأمين حق فى الحلول محل المستفيد فى حقوقه قبل المسئول عن هذا الحادث أو قبل المؤمن المسئول عن هذا الحادث.$b765$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins765;

WITH ins766 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 766, 0, $h766$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين من الحريق$h766$, $b766$(1) فى التأمين من الحريق يكون المؤمن مسئولا عن كافة الأضرار الناشئة عن حريق، أو عن بداية حريق يمكن أن يصبح حريقاً كاملاً، أو عن خطر حريق يمكن أن يتحقق.
(2) ولا يقتصر التزامه على الأضرار الناشئة مباشرة عن الحريق بل يتناول أيضا الأضرار التى تكون نتيجة حتمية لذلك، وبالأخص ما يلحق الأشياء المؤمن عليها من ضرر بسبب اتخاذ وسائل الإنقاذ أو لمنع امتداد الحريق.
(3) ويكون مسئولا عن ضياع الأشياء المؤمن عليها أو اختفائها أثناء الحريق ما لم يثبت أن ذلك كان نتيجة سرقة، كل هذا ولو اتفق على غير ذلك.$b766$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins766;

WITH ins767 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 767, 0, $h767$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين من الحريق$h767$, $b767$يضمن المؤمن تعويض الأضرار الناجمة عن الحريق ولو نشأ هذا الحريق عن عيب فى الشىء المؤمن عليه.$b767$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins767;

WITH ins768 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 768, 0, $h768$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين من الحريق$h768$, $b768$(1) يكون المؤمن مسئولا عن الأضرار الناشئة عن خطأ المؤمن له غير المتعمد. وكذلك يكون المؤمن مسئولا عن الأضرار الناجمة من حادث مفاجئ أو قوة قاهرة.
(2) أما الخسائر والأضرار التى يحدثها المؤمن له عمداً أو غشاً، فلا يكون المؤمن مسئولا عنها ولو اتفق على غير ذلك.$b768$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins768;

WITH ins769 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 769, 0, $h769$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين من الحريق$h769$, $b769$يسأل المؤمن عن الأضرار التى تسبب فيها الأشخاص الذين يكون المؤمن له مسئولا عنهم، مهما يكن نوع خطئهم ومداه.$b769$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins769;

WITH ins770 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 770, 0, $h770$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين من الحريق$h770$, $b770$(1) إذا كان الشىء المؤمن عليه مثقلا برهن حيازى أو رهن تأمينى أو غير ذلك من التأمينات العينية، انتقلت هذه الحقوق إلى التعويض المستحق للمدين بمقتضى عقد التأمين.
(2) فإذا شهرت هذه الحقوق أو أعلنت إلى المؤمن له ولو بكتاب موصى عليه، فلا يجوز للمؤمن أن يدفع ما فى ذمته للمؤمن له إلا برضاء الدائنين.
(3) فإذا حجز على الشىء المؤمن عليه أو وضع هذا الشىء تحت الحراسة بالوجه المبين فى الفقرة السابقة، وأعلن بذلك المؤمن، فلا يجوز للمؤمن أن يدفع للمؤمن له شيئا مما فى ذمته.$b770$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins770;

WITH ins771 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 771, 0, $h771$الكتاب الثانى - العقود المسماة > الباب الرابع - عقود الغرر > الفصل الثالث - عقد التأمين > 2- بعض أنواع التأمين > التأمين من الحريق$h771$, $b771$يحل المؤمن قانونا بما دفعه من تعويض عن الحريق فى الدعاوى التى تكون للمؤمن له قبل من كان بفعله قد تسبب فى الضرر الذى نجمت عنه مسئولية المؤمن، ما لم يكن من أحدث الضرر قريباً أو صهراً للمؤمن له ممن يكونون معه فى معيشة واحدة، أو شخصا مسئولا عنه من أفعاله.$b771$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins771;

WITH ins772 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 772, 0, $h772$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h772$, $b772$الكفالة عقد بمقتضاه يكفل شخص تنفيذ التزام بأن يتعهد للدائن بأن يفى بهذا الالتزام إذا لم يف به المدين نفسه.$b772$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins772;

WITH ins773 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 773, 0, $h773$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h773$, $b773$لا تثبت الكفالة إلا بالكتابة، ولو كان من الجائز إثبات الالتزام الأصلى بالبينة.$b773$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins773;

WITH ins774 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 774, 0, $h774$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h774$, $b774$إذا ألتزم شخص بتقديم كفيل، وجب أن يقدم شخصاً موسرا مقيما فى مصر، وله أن يقدم عوضاً عن الكفيل تأمينا عينيا كافيا.$b774$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins774;

WITH ins775 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 775, 0, $h775$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h775$, $b775$تجوز كفالة المدين بغير علمه، وتجوز أيضاً رغم معارضته.$b775$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins775;

WITH ins776 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 776, 0, $h776$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h776$, $b776$لا تكون الكفالة صحيحة إلا إذا كان الإلزام المكفول صحيحاً.$b776$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins776;

WITH ins777 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 777, 0, $h777$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h777$, $b777$من كفل ناقص الأهلية وكانت الكفالة بسبب نقص الأهلية كان ملزما ما لم ينفذه المدين المكفول.$b777$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins777;

WITH ins778 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 778, 0, $h778$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h778$, $b778$(1) تجوز الكفالة فى الدين المستقبل إذا حدد مقدما المبلغ المكفول، كما تجوز الكفالة فى الدين الشرطي.
(2) على أنه إذا كان الكفيل فى الدين المستقبل لم يعين مدة للكفالة، كان له فى أى وقت أن يرجع فيها مادام الدين المكفول لم ينشأ.$b778$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins778;

WITH ins779 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 779, 0, $h779$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h779$, $b779$(1) كفالة الدين التجارى تعتبر عملا مدنيا ولو كان الكفيل تاجرا.
(2) على أن الكفالة الناشئة عن ضمان الأوراق التجارية ضمانا احتياطيا أو عن تظهير هذه الأوراق، تعتبر دائما عملا تجاريا.$b779$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins779;

WITH ins780 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 780, 0, $h780$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h780$, $b780$(1) لا تجوز الكفالة فى مبلغ أكبر مما هو مستحق على المدين، ولا بشرط أشد من شروط الدين المكفول.
(2) ولكن تجوز الكفالة فى مبلغ أقل وبشروط أهون.$b780$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins780;

WITH ins781 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 781, 0, $h781$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الأول - أركان الكفالة$h781$, $b781$إذا لم يكن هناك اتفاق خاص، فإن الكفالة تشمل ملحقات الدين، ومصروفات المطالبة الأولى، وما يستجد من المصروفات بعد إخطار الكفيل.$b781$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins781;

WITH ins782 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 782, 0, $h782$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h782$, $b782$(1) يبرأ الكفيل بمجرد براءة المدين، وله أن يتمسك بجميع الأوجه التى يحتج بها المدين.
(2) على أنه إذا كان الوجه الذى يحتج به هو عدم أهلية المدين وكان الكفيل عالما بذلك وقت التعاقد، فليس له أن يحتج بهذا الوجه.$b782$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins782;

WITH ins783 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 783, 0, $h783$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h783$, $b783$إذا قبل الدائن فى مقابل الدين شيئا آخر برئت ذمة الكفيل ولو استحق هذا الشىء.$b783$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins783;

WITH ins784 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 784, 0, $h784$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h784$, $b784$(1) تبرأ ذمة الكفيل بقدر ما أضاعه الدائن بخطئه من الضمانات.
(2) ويقصد بالضمانات فى هذه المادة كل تأمين يخصص لضمان الدين ولو تقرر بعد الكفالة، وكل تأمين مقرر بحكم القانون.$b784$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins784;

WITH ins785 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 785, 0, $h785$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h785$, $b785$(1) لا تبرأ ذمة الكفيل لمجرد أن الدائن تأخر فى اتخاذ الإجراءات أو لمجرد أنه لم يتخذها.
(2) على أن ذمة الكفيل تبرأ إذا لم يقم الدائن باتخاذ الإجراءات ضد المدين خلال ستة أشهر من إنذار الكفيل للدائن، ما لم يقدم المدين للكفيل ضمانا كافيا.$b785$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins785;

WITH ins786 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 786, 0, $h786$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h786$, $b786$إذا أفلس المدين وجب على الدائن أن يتقدم على التفليسة بالدين، وإلا سقط حقه فى الرجوع على الكفيل بقدر ما أصاب هذا الأخير من ضرر بسبب إهمال الدائن.$b786$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins786;

WITH ins787 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 787, 0, $h787$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h787$, $b787$(1) يلتزم الدائن بأن يسلم الكفيل وقت وفائه المستندات اللازمة لاستعمال حقه فى الرجوع.
(2) فإذا كان الدين مضمونا بمنقول مرهون أو محبوس، وجب على الدائن أن يتخلى عنه للكفيل.
(3) أما إذا كان الدين مضمونا بتأمين عقاري، فإن الدائن يلتزم أن يقوم بالإجراءات اللازمة لنقل هذا التأمين، ويتحمل الكفيل مصروفات النقل، على أن يرجع بها على المدين.$b787$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins787;

WITH ins788 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 788, 0, $h788$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h788$, $b788$(1) لا يجوز للدائن أن يرجع على الكفيل وحده إلا بعد رجوعه على المدين.
(2) ولا ينفذ على أموال الكفيل إلا بعد تجريد المدين من أمواله، ويجب على الكفيل أن يتمسك بهذا الحق فى هذه الحالة.$b788$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins788;

WITH ins789 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 789, 0, $h789$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h789$, $b789$(1) إذا طلب الكفيل التجريد، وجب عليه أن يقوم بنفقته بإرشاد الدائن إلى أموال المدين تفى بالدين كله.
(2) ولا عبرة بالأموال التى يدل عليها الكفيل، إذا كانت هذه الأموال تقع خارج الأراضى المصرية، أو كانت أموالا متنازعا فيها.$b789$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins789;

WITH ins790 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 790, 0, $h790$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h790$, $b790$فى كل الأحوال التى يدل فيها الكفيل على أموال المدين، يكون الدائن مسئولا قبل الكفيل عن إعسار المدين الذى يترتب على عدم اتخاذه الإجراءات اللازمة فى الوقت المناسب.$b790$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins790;

WITH ins791 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 791, 0, $h791$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h791$, $b791$إذا كان هناك تأمين عينى خصص قانونا أو اتفاقا لضمان الدين الذى قدمت كفالة به ولم يكن الكفيل متضامنا مع المدين، فلا يجوز التنفيذ على أموال الكفيل إلا بعد التنفيذ على الأموال التى خصصت لهذا التأمين.$b791$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins791;

WITH ins792 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 792, 0, $h792$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h792$, $b792$(1) إذا تعدد الكفلاء لدين واحد وبعقد واحد وكانوا غير متضامنين فيما بينهم، قسم الدين عليهم، ولا يجوز للدائن أن يطالب كل كفيل إلا بقدر نصيبه فى الكفالة.
(2) أما إذا كان الكفلاء قد التزموا بعقود متوالية، فإن كل واحد منهم مسئولا عن الدين كله، إلا إذا كان قد احتفظ لنفسه بحق التقسيم.$b792$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins792;

WITH ins793 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 793, 0, $h793$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h793$, $b793$لا يجوز للكفيل المتضامن مع المدين أن يطلب التجريد.$b793$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins793;

WITH ins794 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 794, 0, $h794$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h794$, $b794$يجوز للكفيل المتضامن أن يتمسك بما يتمسك به الكفيل غير المتضامن من دفوع متعلقة بالدين.$b794$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins794;

WITH ins795 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 795, 0, $h795$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h795$, $b795$فى الكفالة القضائية أو القانونية يكون الكفلاء دائما متضامنين.$b795$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins795;

WITH ins796 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 796, 0, $h796$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h796$, $b796$إذا كان الكفلاء متضامنين فيما بينهم ووفى أحدهم الدين عند حلوله، كان له أن يرجع على كل الباقين بحصته فى الدين وبنصيبه فى حصة المعسر منهم.$b796$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins796;

WITH ins797 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 797, 0, $h797$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 1- العلاقة ما بين الكفيل والدائن$h797$, $b797$تجوز كفالة الكفيل، وفى هذه الحالة لا يجوز للدائن أن يرجع إلا على كفيل الكفيل قبل الرجوع على الكفيل، إلا إذا كان كفيل الكفيل متضامنا مع الكفيل.$b797$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins797;

WITH ins798 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 798, 0, $h798$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 2- العلاقة ما بين الكفيل والمدين$h798$, $b798$(1) يجب على الكفيل أن يخطر المدين قبل أن يقوم بوفاء الدين، وإلا سقط حقه فى الرجوع على المدين إذا كان هذا قد وفى الدين أو كانت عنده وقت الاستحقاق أسباب تقضى ببطلان الدين أو بانقضائه.
(2) فإذا لم يعارض المدين فى الوفاء، بقى للكفيل حقه فى الرجوع عليه ولو كان قد دفع الدين ولو كانت لديه أسباب تقضى بطلانه أو بانقضائه.$b798$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins798;

WITH ins799 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 799, 0, $h799$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 2- العلاقة ما بين الكفيل والمدين$h799$, $b799$إذا وفى الكفيل الدين، كان له أن يحل محل الدائن فى جميع ما له من حقوق قبل المدين. ولكن إذا لم يوف إلا بعض الدين، فلا يرجع بما وفاه إلا بعد أن يستوفى الدائن كل حقه من المدين.$b799$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins799;

WITH ins800 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 800, 0, $h800$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 2- العلاقة ما بين الكفيل والمدين$h800$, $b800$(1) للكفيل الذى وفى الدين أن يرجع على المدين بما عقدت الكفالة بعلمه أو بغير علمه.
(2) ويرجع بأصل الدين والفوائد والمصروفات، على أنه فى المصروفات لا يرجع إلا بالذى دفعه من وقت إخباره المدين الأصلى بالإجراءات التى اتخذت ضده.
(3) ويكون للكفيل الحق فى الفوائد القانونية عن كل ما قام بدفعه ابتداء من يوم الدفع.$b800$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins800;

WITH ins801 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 801, 0, $h801$الكتاب الثانى - العقود المسماة > الباب الخامس - الكفالة > الفصل الثانى - آثار الكفالة > 2- العلاقة ما بين الكفيل والمدين$h801$, $b801$إذا تعدد المدينون فى دين واحد وكانوا متضامنين، فللكفيل الذى ضمنهم جميعا أن يرجع على أى منهم بوفاء ما من الدين.$b801$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins801;

WITH ins802 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 802, 0, $h802$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 1- نطاقه ووسائل حمايته$h802$, $b802$لمالك الشىء وحده، فى حدود القانون، حق استعماله واستغلاله والتصرف فيه.$b802$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins802;

WITH ins803 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 803, 0, $h803$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 1- نطاقه ووسائل حمايته$h803$, $b803$(1) مالك الشىء يملك كل ما يعد من عناصره الجوهرية بحيث لا يمكن فصله عنه دون أن يهلك أو يتلف أو يتغير.
(2) وملكية الأرض تشمل ما فوقها وما تحتها إلى الحد المفيد فى التمتع بها، علوا أو عمقا.
(3) ويجوز بمقتضى القانون أو الاتفاق أن تكون ملكية سطح الأرض منفصلة عن ملكية ما فوقها أو ما تحتها.$b803$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins803;

WITH ins804 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 804, 0, $h804$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 1- نطاقه ووسائل حمايته$h804$, $b804$لمالك الشىء الحق فى كل ثماره ومنتجاته وملحقاته، ما لم يوجد نص أو اتفاق يخالف ذلك.$b804$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins804;

WITH ins805 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 805, 0, $h805$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 1- نطاقه ووسائل حمايته$h805$, $b805$لا يجوز أن يحرم أحد من ملكه إلا فى الأحوال التى يقررها القانون، وبالطريقة التى يرسمها، ويكون ذلك فى مقابل تعويض عادل.$b805$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins805;

WITH ins806 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 806, 0, $h806$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h806$, $b806$يراعى المالك فى استعمال حقه ما تقضى به القوانين والمراسيم واللوائح المتعلقة بالمصلحة العامة أو بالمصلحة الخاصة. وعليه أيضا مراعاة الأحكام الآتية:$b806$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins806;

WITH ins807 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 807, 0, $h807$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h807$, $b807$(1) على المالك ألا يغلو فى استعمال حقه إلى حد يضر بملك الجار.
(2) وليس للجار أن يرجع على جاره فى مضار الجوار المألوفة التى لا يمكن تجنبها، وإنما له أن يطلب إزالة هذه المضار إذا جاوزت الحد المألوف، على أن يراعى فى ذلك العرف، وطبيعة العقارات وموقع كل منها بالنسبة إلى الآخر، والغرض الذى خصصت له. ولا يحول الترخيص الصادر من الجهات المختصة دون استعمال هذا الحق.$b807$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins807;

WITH ins808 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 808, 0, $h808$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h808$, $b808$(1) من أنشأ مصرفا خصوصيا طبقا للوائح الخاصة بذلك كان له وحده حق استعماله.
(2) ومع ذلك يجوز للملاك المجاورين أن يستعملوا المسقاة أو المصرف فيما تحتاجه أراضيهم من ري أو صرف، بعد أن يكون مالك المسقاة أو المصرف قد استوفى حاجته منها. وعلى الملاك المجاورين فى هذه الحالة أن يشتركوا فى نفقات إنشاء المسقاة أو المصرف وصيانتهما بنسبة مساحة أراضيهم التى تنتفع منها.$b808$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins808;

WITH ins809 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 809, 0, $h809$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h809$, $b809$يجب على مالك الأرض أن يسمح بأن تمر بأرضه المياه الكافية لري الأراضي البعيدة عن مورد المياه، وكذلك مياه الصرف الآتية من الأراضي المجاورة لتصب فى أقرب مصرف عمومي، بشرط أن يعوض عن ذلك تعويضا عادلا.$b809$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins809;

WITH ins810 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 810, 0, $h810$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h810$, $b810$إذا أصاب الأرض ضرر من مسقاة أو مصرف يمر بها، سواء كان ذلك ناشئا عن عدم التطهير أم عن سوء حالة الجسور، فإن لمالك الأرض أن يطلب تعويضا كافيا عما أصابه من ضرر.$b810$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins810;

WITH ins811 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 811, 0, $h811$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h811$, $b811$إذا لم يتفق المنتفعون بمسقاة أو مصرف على القيام بالإصلاحات الضرورية، جاز إلزامهم بالاشتراك فيها بناء على طلب أى واحد منهم.$b811$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins811;

WITH ins812 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 812, 0, $h812$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h812$, $b812$(1) مالك الأرض المحبوسة عن الطريق العام، أو التى لا يصلها بهذا الطريق ممر كاف إذا كان لا يتيسر له الوصول إلى ذلك الطريق إلا بنفقة باهظة أو مشقة كبيرة، له حق المرور فى الأراضي المجاورة بالقدر اللازم لاستغلال أرضه واستعمالها على الوجه المألوف، مادامت هذه الأرض محبوسة عن الطريق العام، وذلك فى نظير تعويض فيه أخف ضررا وفى موضع منه يتحقق فيه ذلك.
(2) على أنه إذا كان الحبس عن الطريق العام ناشئا عن تجزئة عقار تمت بناء على تصرف قانوني، وكان من المستطاع إيجاد ممر كاف لأجزاء هذا العقار فى أجزاء العقار الأخرى، فلا تجوز المطالبة بحق المرور إلا فى هذه الأجزاء.$b812$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins812;

WITH ins813 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 813, 0, $h813$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h813$, $b813$لكل مالك جار يجبر جاره على وضع حدود لأملاكهما المتلاصقة، وتكون نفقات التحديد مشتركة بينهما.$b813$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins813;

WITH ins814 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 814, 0, $h814$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h814$, $b814$(1) لمالك الحائط المشترك أن يستعمله بحسب الغرض الذى أعد له، وأن يضع فوقه عوارض ليسند عليها السقف دون أن يحمل الحائط فوق طاقته.
(2) فإذا لم يعد الحائط المشترك صالحا للغرض الذى خصص له عادة، فنفقة إصلاحه أو تجديده على جميع الشركاء، كل بنسبة حصته فيه.$b814$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins814;

WITH ins815 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 815, 0, $h815$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h815$, $b815$(1) للمالك إذا كانت له مصلحة جدية فى تعلية الحائط المشترك أن يعليه، بشرط ألا يلحق بشريكه ضررا بليغا، وعليه أن ينفق على التعلية وصيانة الجزء المعلى، وعمل ما يلزم لجعل الحائط يتحمل زيادة العبء الناشئ عن التعلية دون أن يفقد شيئا من متانته.
(2) فإذا لم يكن الحائط المشترك صالحا لتحمل التعلية، فعلى من يرغب فيها من الشركاء أن يعيد بناء الحائط كله على نفقته، على أن يزيد ما يلزم من سمكه فى ناحيته بقدر الاستطاعة، ويظل الحائط المجدد فى غير الجزء المعلى مشتركا، دون أن يكون للجار الذى أحدث التعلية حق فى التعويض.$b815$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins815;

WITH ins816 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 816, 0, $h816$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h816$, $b816$للجار الذى لم يساهم فى نفقات التعلية أن يصبح شريكا فى الجزء المعلى إذا هو دفع نصف ما اتفق عليه وقيمة نصف الأرض التى تقوم عليها زيادة السمك إن كانت هناك زيادة.$b816$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins816;

WITH ins817 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 817, 0, $h817$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h817$, $b817$الحائط الذي يكون فى وقت إنشائه فاصلا بين بنائين، يعد مشتركا حتى يقوم دليل على العكس.$b817$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins817;

WITH ins818 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 818, 0, $h818$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h818$, $b818$(1) ليس لجار جبر جاره على تحويل ملكه والنزول له عن جزء من حائط أو من الأرض التى عليها الحائط إلا فى الحالة المذكورة فى المادة 816.
(2) ومع ذلك فليس لمالك الحائط أن يهدمه مختارا دون عذر قوى إذا كان هذا يضر الجار الذى يستر بالحائط.$b818$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins818;

WITH ins819 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 819, 0, $h819$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h819$, $b819$(1) لا يجوز للجار أن يكون له على جاره مطل مواجه على مسافة تقل عن متر، وتقاس المسافة من ظهر الحائط الذى فيه المطل، أو من حافة المشربة أو الخارجة.
(2) وإذا اكسب أحد بالتقادم الحق فى مطل مواجه لملك الجار على مسافة تقل عن متر، فلا يجوز لهذا الجار أن يبنى بالطريقة السابقة بيانها أقل من متر يقاس على الطول الذى يحق فتح المطل فيه.$b819$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins819;

WITH ins820 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 820, 0, $h820$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h820$, $b820$لا يجوز للجار أن يكون له على جاره مطل منحرف على مسافة تقل عن خمسين سنتيمترا من حرف المطل. ولكن يرتفع هذا الحظر إذا كان المطل المنحرف على العقار المجاور هو فى الوقت ذاته مطل مواجه للطريق العام.$b820$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins820;

WITH ins821 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 821, 0, $h821$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h821$, $b821$لا تشترط أية مسافة لفتح المناور، وهى التى تعلو قاعدتها عن قامة الإنسان المعتادة، ولا يقصد بها مرور الهواء ونفاذ النور، دون أن يستطاع منها الاطلاع على العقار المجاور.$b821$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins821;

WITH ins822 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 822, 0, $h822$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h822$, $b822$المصانع والآبار والآلات البخارية وجميع المحال المضرة بالجيران يجب أن تنشأ على المسافات المبينة فى اللوائح والشروط التى تفرضها.$b822$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins822;

WITH ins823 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 823, 0, $h823$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h823$, $b823$(1) إذا تضمن العقد أو الوصية شرطا يقضى بمنع التصرف فى مال، فلا يصح هذا الشرط ما لم يكن مبنيا على باعث مشروع، ومقصورا على مدة معقولة.
(2) ويكون الباعث مشروعا متى كان المراد من المنع حماية مصلحة مشروعة للمتصرف أو للمتصرف إليه أو للغير.
(3) والمدة المعقولة يجوز أن تستغرق مدى حياة المتصرف أو المتصرف إليه أو الغير.$b823$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins823;

WITH ins824 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 824, 0, $h824$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 2- القيود التى ترد على حق الملكية$h824$, $b824$إذا كان شرط المنع من التصرف الوارد فى العقد أو الوصية صحيحا طبقا لأحكام المادة السابقة، فكل تصرف مخالف له يقع باطلا.$b824$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins824;

WITH ins825 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 825, 0, $h825$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h825$, $b825$إذا ملك اثنان أو أكثر شيئا غير مفرزة حصة كل منهم فيه، فهم شركاء على الشيوع، وتحسب الحصص متساوية إذا لم يقم دليل على غير ذلك.$b825$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins825;

WITH ins826 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 826, 0, $h826$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h826$, $b826$(1) كل شريك فى الشيوع يملك حصته ملكا تاما، وله أن يتصرف فيها وأن يستولي على ثمارها وأن يستعملها بحيث لا يلحق الضرر بحقوق سائر الشركاء.
(2) وإذا كان التصرف منصبا على جزء مفرز من المال الشائع ولم يقع هذا الجزء عند القسمة فى نصيب المتصرف، انتقل حق المتصرف إليه من وقت التصرف إلى الجزء الذى آل بطريق القسمة إلى المتصرف، إذا كان يجهل أن المتصرف لا يملك العين المتصرف فيها مفرزة، الحق فى أبطال التصرف.$b826$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins826;

WITH ins827 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 827, 0, $h827$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h827$, $b827$تكون إدارة المال الشائع من حق الشركاء مجتمعين ما لم يوجد اتفاق يخالف ذلك.$b827$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins827;

WITH ins828 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 828, 0, $h828$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h828$, $b828$(1) ما يستقر عليه رأى أغلبية الشركاء فى أعمال الإدارة المعتادة يكون ملزما للجميع. وتحسب الأغلبية على أساس قيمة الأنصباء، فإن لم يكن ثمة أغلبية فللمحكمة بناء على طلب أحد الشركاء، أن تتخذ من التدابير ما تقتضيه الضرورة، ولها أن تعين عند الحاجة من يدير المال الشائع.
(2) وللأغلبية أيضا أن تختار مديرا، كما لها أن تضع للإدارة ولحسن الانتفاع بالمال الشائع نظاما يسرى على جميع الشركاء حتى ولو كان الخلف عاما أم خاصا.
(3) وإذا تولى أحد الشركاء الإدارة دون اعتراض من الباقين عد وكيلا عنهم.$b828$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins828;

WITH ins829 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 829, 0, $h829$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h829$, $b829$(1) للشركاء الذين يملكون على الأقل ثلاثة أرباع المال الشائع، أن يقرروا، فى سبيل تحسين الانتفاع بهذا المال، التغييرات الأساسية والتعديل فى الغرض الذى أعد له، ما لم يخرج عن حدود الإدارة المعتادة، على أن يعلنوا قراراتهم إلى باقي الشركاء. ولمن خالف من هؤلاء حق الرجوع إلى المحكمة خلال شهرين من وقت الإعلان.
(2) وللمحكمة عند الرجوع إليها إذا وافقت على قرار تلك الأغلبية، أن تقرر ما تراه مناسبا من التدابير. ولها بوجه خاص أن تأمر بإعطاء المخالف من الشركاء كفالة تضمن الوفاء بالتعويضات.$b829$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins829;

WITH ins830 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 830, 0, $h830$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h830$, $b830$لكل شريك الحق فى أن يتخذ من الوسائل ما يلزم لحفظ الشيء، ولو كان ذلك بغير موافقة باقي الشركاء.$b830$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins830;

WITH ins831 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 831, 0, $h831$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h831$, $b831$نفقات إدارة المال الشائع وحفظه والضرائب وسائر التكاليف الناتجة عن الشيوع أو المقررة على المال، يتحملها جميع الشركاء، كل بقدر حصته، ما لم يوجد نص يقضى بغير ذلك.$b831$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins831;

WITH ins832 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 832, 0, $h832$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h832$, $b832$للشركاء الذين يملكون على الأقل ثلاثة أرباع المال الشائع أن يتصرفوا فيه إذا استندوا فى ذلك إلى أسباب قوية، على أن يعلنوا قراراتهم إلى باقي الشركاء. ولمن خالف من هؤلاء حق الرجوع إلى المحكمة خلال شهرين من وقت الإعلان. وللمحكمة عندما تكون قسمة المال الشائع ضارة بمصالح الشركاء، أن تقدر تبعا للظروف ما إذا كان التصرف واجبا.$b832$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins832;

WITH ins833 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 833, 0, $h833$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > أحكام الشيوع$h833$, $b833$(1) للشريك فى المنقول الشائع أو فى المجموع من المال الشائع أن يسترد الحصة الشائعة التى باعها شريك غيره لأجنبى بطريق الممارسة، وذلك خلال ثلاثين يوما من تاريخ علمه بإعلانه به. ويتم الاسترداد بإعلان يوجه إلى كل من البائع والمشترى، ويحل المسترد محل المشترى فى جميع حقوقه والتزاماته إذا هو عوضه عن كل ما أنفقه.
(2) وإذا تعدد المستردون فلكل منهم أن يسترد بنسبة حصته.$b833$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins833;

WITH ins834 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 834, 0, $h834$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h834$, $b834$لكل شريك أن يطالب بقسمة المال الشائع ما لم يكن مجبرا على البقاء فى الشيوع بمقتضى نص أو اتفاق، ولا يجوز بمقتضى الاتفاق أن تمنع القسمة إلى أجل يجاوز خمس سنين، فإذا كان الأجل أطول وجب تخفيضه إلى خمس سنين ونفذ الاتفاق فى حق من خلفه.$b834$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins834;

WITH ins835 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 835, 0, $h835$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h835$, $b835$للشركاء إذا انعقد إجماعهم، أن يقتسموا المال الشائع بالطريقة التى يرونها. فإذا كان بينهم من هو ناقص الأهلية وجبت مراعاة الإجراءات التى يفرضها القانون.$b835$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins835;

WITH ins836 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 836, 0, $h836$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h836$, $b836$(1) إذا اختلف الشركاء فى أقسام المال الشائع فعلى من يريد الخروج من الشيوع أن يكلف باقي الشركاء الحضور أمام المحكمة الجزئية.
(2) وتندب المحكمة إن رأت وجها لذلك خبيرا أو أكثر لتقويم المال الشائع وقسمته حصصا إن كان المال يقبل القسمة عينا دون أن يلحقه نقص كبير فى قيمته.$b836$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins836;

WITH ins837 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 837, 0, $h837$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h837$, $b837$(1) يكون تقسيم الخبير الحصص على أساس أصغر نصيب حتى لو كانت القسمة جزئية، فإن تعذرت القسمة على هذا الأساس جاز للخبير أن يجنب لكل شريك حصته.
(2) وإذا تعذر أن يختص أحد الشركاء بكامل نصيبه عينا، عوض بمعدل عما نقص من نصيبه.$b837$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins837;

WITH ins838 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 838, 0, $h838$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h838$, $b838$(1) تفصل المحكمة الجزئية فى المنازعات التى تتعلق بتكوين الحصص وفى كل المنازعات الأخرى التى تدخل فى اختصاصها.
(2) فإذا قامت منازعات لا تدخل فى اختصاص تلك المحكمة كان عليها أن تحيل الخصوم إلى المحكمة الابتدائية، وأن تعين لهم الجلسة التى يحضرون فيها، وتقف دعوى القسمة إلى أن يفصل نهائيا فى تلك المنازعات.$b838$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins838;

WITH ins839 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 839, 0, $h839$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h839$, $b839$(1) متى انتهى الفصل فى المنازعات وكانت الحصص قد عينت بطريق التجنيب، أصدرت المحكمة الجزئية حكما بإعطاء كل شريك النصيب المفرز الذى عين إليه.
(2) فإن كانت الحصص لم تعين بطريق التجنيب، تجرى القسمة بطريق الاقتراع، وتثبت المحكمة ذلك فى محضرها وتصدر حكما بإعطاء كل شريك نصيبه المفرز.$b839$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins839;

WITH ins840 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 840, 0, $h840$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h840$, $b840$إذا كان بين الشركاء غائب أو كان بينهم من لم تتوافر فيه الأهلية، وجب تصديق المحكمة على حكم القسمة بعد صيرورته نهائيا، وذلك وفقا لما يقرره القانون.$b840$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins840;

WITH ins841 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 841, 0, $h841$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h841$, $b841$إذا لم تكن القسمة عينا، أو كان من شأنها إحداث نقص كبير فى قيمة المال المراد قسمته، بيع هذا المال بالطريق المبينة فى قانون المرافعات، وتقتصر المزايدة على الشركاء إذا طلبوا هذا بالإجماع.$b841$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins841;

WITH ins842 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 842, 0, $h842$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h842$, $b842$(1) لدائني كل شريك أن يعارضوا فى أن تتم القسمة عينا أو أن يباع المال بالمزاد بغير تدخلهم، وتوجه المعارضة إلى كل الشركاء، ويترتب عليها إلزامهم أن يدخلوا الدائنين الذين عارضوا فى جميع الإجراءات، وإلا كانت القسمة غير نافذة فى حقهم، ويجب على كل حال إدخال الدائنين المقيدة حقوقهم قبل رفع دعوى القسمة.
(2) أما إذا تمت القسمة، فليس للدائنين الذين لم يتدخلوا فيها أن يطعنوا عليها إلا فى حالة الغش.$b842$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins842;

WITH ins843 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 843, 0, $h843$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h843$, $b843$يعتبر المتقاسم مالكا للحصة التى آلت إليه منذ أن تملك فى الشيوع وأنه لم يملك شيئا فى بقية الحصص.$b843$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins843;

WITH ins844 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 844, 0, $h844$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h844$, $b844$(1) يضمن المتقاسمون بعضهم لبعض ما قد يقع من تعرض أو استحقاق لسبب سابق على القسمة، ويكون كل منهم ملزما بنسبة حصته بتعويض مستحق الضمان، على أن تكون العبرة فى تقدير الشيء بقيمته وقت القسمة. فإذا كان أحد المتقاسمين معسرا، وزع القدر الذى يلزمه على المتقاسمين وجميع المتقاسمين غير المعسرين.
(2) غير أنه لا محل للضمان إذا كان هناك اتفاق صريح يقضى بالإعفاء منه فى الحالة الخاصة التى نشأ عنها، ويمتنع الضمان أيضا إذا كان الاستحقاق أو الضرر إنما يرجع إلى خطأ المتقاسم نفسه.$b844$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins844;

WITH ins845 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 845, 0, $h845$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h845$, $b845$(1) يجوز نقض القسمة الحاصلة بالتراضي إذا أثبت أحد المتقاسمين أنه قد لحقه منها غبن يزيد على الخمس، على أن تكون العبرة فى التقدير بقيمة الشيء وقت القسمة.
(2) ويجب أن ترفع الدعوى خلال السنة التالية للقسمة. وللمدعى عليه أن يقف سيرها ويمنع نقض القسمة من جديد إذا أكمل للمدعى نقدا أو عينا ما نقص من حصته.$b845$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins845;

WITH ins846 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 846, 0, $h846$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h846$, $b846$(1) فى قسمة المهايأة يتفق الشركاء على أن يختص كل منهم بمنفعة جزء مفرز يوازي حصته فى المال الشائع، متنازلا لشركائه فى مقابل ذلك عن الانتفاع بباقي الأجزاء. ولا يصح هذا الاتفاق لمدة تزيد على خمس سنين، فإذا لم تشترط له مدة أو انتهت المدة المتفق عليها ولم يحصل اتفاق جديد، كانت مدته سنة واحدة تتجدد إذا لم يعلن الشريك إلى شركائه قبل انتهاء السنة الجارية بثلاثة أشهر أنه لا يرغب فى التجديد.
(2) وإذا دامت هذه القسمة خمس عشرة سنة، انقلبت قسمة نهائية، ما لم يتفق الشركاء على غير ذلك. وإذا حاز الشريك على الشيوع من المال الشائع جزءا مفرزا مدة خمس عشرة سنة، افترض أن حيازته لهذا الجزء تستند إلى قسمة مهايأة.$b846$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins846;

WITH ins847 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 847, 0, $h847$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h847$, $b847$تكون قسمة المهاياة أيضا بأن يتفق الشركاء على أن يتناوبوا الانتفاع بجميع المال المشترك، كل منهم لمدة تتناسب مع حصته.$b847$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins847;

WITH ins848 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 848, 0, $h848$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h848$, $b848$تخضع قسمة المهاياة من حيث جواز الاحتجاج بها على الغير ومن حيث أهلية المتقاسمين وحقوقهم والتزاماتهم وطرق الإثبات لأحكام عقد الإيجار، مادامت هذه الأحكام لا تتعارض مع طبيعة هذه القسمة.$b848$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins848;

WITH ins849 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 849, 0, $h849$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > انقضاء الشيوع بالقسمة$h849$, $b849$(1) للشركاء أن يتفقوا أثناء إجراءات القسمة النهائية على أن يقسم المال الشائع على مهاياة بينهم، وتظل هذه القسمة نافذة حتى تتم القسمة النهائية.
(2) إذا تعذر اتفاق الشركاء على قسمة المهاياة، جاز للقاضي الجزئي أن يأمر بها إذا طلب منه ذلك أحد الشركاء، بد الاستعانة بخبير إذا اقتضى الأمر ذلك.$b849$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins849;

WITH ins850 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 850, 0, $h850$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > الشيوع الإجباري$h850$, $b850$ليس للشركاء فى مال شائع طلب قسمته إذا تبين من الغرض الذى أعد له هذا المال، أنه يجب أن يبقى دائما على الشيوع.$b850$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins850;

WITH ins851 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 851, 0, $h851$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكية الأسرة$h851$, $b851$لأعضاء الأسرة الواحدة الذين تجمعهم وحدة العمل أو المصلحة، أن يتفقوا كتابة على إنشاء ملكية للأسرة، تكون هذه الملكية إما من تركة ورثوها واتفقوا على جعلها كلها أو بعضها ملكا للأسرة، وإما من أى مال آخر اتفقوا على إدخاله فى هذه الملكية.$b851$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins851;

WITH ins852 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 852, 0, $h852$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكية الأسرة$h852$, $b852$(1) يجوز الاتفاق على إنشاء ملكية الأسرة لمدة لا تزيد على خمس عشرة سنة، على أنه يجوز لكل شريك أن يطلب من المحكمة الإذن له فى إخراج نصيبه من هذه الملكية قبل الأجل المتفق عليه إذا وجد مبرر قوي لذلك.
(2) وإذا لم يكن للملكية المذكورة أجل معين، كان لكل شريك أن يخرج نصيبه منها بعد ستة أشهر من يوم أن يعلن إلى الشركاء رغبته.$b852$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins852;

WITH ins853 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 853, 0, $h853$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكية الأسرة$h853$, $b853$(1) ليس للشركاء أن يطلبوا القسمة ما دامت ملكية الأسرة قائمة، ولا يجوز لأي شريك أن يتصرف فى نصيبه للأجنبي عن الأسرة إلا بموافقة الشركاء جميعا.
(2) وإذا تملك أجنبي حصة عن الأسرة برضاء أحد الشركاء وكانت هذه الملكية بسبب نقص الأهلية، فلا يكون الأجنبي شريكا فى ملكية الأسرة إلا برضائه ورضاء باقي الشركاء.$b853$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins853;

WITH ins854 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 854, 0, $h854$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكية الأسرة$h854$, $b854$(1) للشركاء أصحاب القدر الأكبر من قيمة الحصص أن يعينوا من بينهم واحدا أو أكثر للإدارة، وللمدير أن يدخل على ملكية الأسرة من التغيير فى الغرض الذي أعد له المال المشترك ما يحسن به الانتفاع بهذا المال، ما لم يكن هناك اتفاق على غير ذلك.
(2) ويجوز عزل المدير بالطريقة التي عين بها ولو اتفق على غير ذلك، كما يجوز للمحكمة أن تعزله إذا طلب شريك أي طلب وجد سبب قوي يبرر هذا العزل.$b854$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins854;

WITH ins855 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 855, 0, $h855$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكية الأسرة$h855$, $b855$فيما عدا الأحكام السابقة تنطبق قواعد الملكية الشائعة وقواعد الوكالة على ملكية الأسرة.$b855$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins855;

WITH ins856 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 856, 0, $h856$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات$h856$, $b856$(1) إذا تعدد ملاك طبقات الدار أو شققها فإنهم يعدون شركاء فى ملكية الأرض وملكية أجزاء البناء المعدة للاستعمال المشترك بين الجميع، وبوجه خاص الأساس والجدران الرئيسية والمداخل والأفنية والأسطح والمصاعد والدهاليز وقواعد الأرضيات وكل أنواع الأنابيب إلا ما كان منها داخل الطبقة أو الشقة، كل هذا ما لم يوجد فى سندات الملك ما يخالفه.
(2) وهذه الأجزاء المشتركة من الدار لا تقبل القسمة، ويكون نصيب كل مالك فيها بنسبة قيمة الجزء الذى له فى الدار، وليس لمالك هذا الجزء أن يتصرف فيه مستقلا عن الجزء الذى يملكه.
(3) والحواجز الفاصلة بين شقتين تكون ملكيتها مشتركة بين أصحاب هاتين الشقتين.$b856$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins856;

WITH ins857 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 857, 0, $h857$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات$h857$, $b857$(1) كل مالك فى سبيل الانتفاع بالجزء الذى يملكه فى الدار حر فى أن يستعمل الأجزاء المشتركة فيما أعدت له، على ألا يحول دون استعمال باقي الشركاء لحقوقهم.
(2) ولا يجوز إحداث أي تعديل فى الأجزاء المشتركة بغير موافقة جميع الملاك حتى تجديد البناء، إلا إذا كان التعديل الذى يقوم به أحد الملاك بنفقته الخاصة، من شأنه أن يسهل استعمال تلك الأجزاء، دون أن يغير من تخصيصها أو يلحق الضرر بالملاك الآخرين.$b857$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins857;

WITH ins858 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 858, 0, $h858$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات$h858$, $b858$(1) على كل مالك أن يشترك فى تكاليف حفظ الأجزاء المشتركة وصيانتها وأدارتها وتجديدها، ويكون نصيبه فى هذه التكاليف بنسبة قيمة الجزء الذى له فى الدار ما لم يوجد اتفاق على غير ذلك.
(2) ولا يحق لمالك أن يتخلى عن نصيبه فى الأجزاء المشتركة للتخلص من الاشتراك فى التكاليف المتقدمة الذكر.$b858$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins858;

WITH ins859 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 859, 0, $h859$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات$h859$, $b859$(1) على صاحب السفل أن يقوم بالأعمال والترميمات اللازمة لمنع سقوط العلو.
(2) فإذا امتنع عن القيام بهذه الترميمات، جاز للقاضي أن يأمر ببيع السفل. ويجوز فى كل حال لقاضي الأمور المستعجلة أن يأمر بإجراء الترميمات العاجلة.$b859$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins859;

WITH ins860 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 860, 0, $h860$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات$h860$, $b860$(1) إذا انهدم البناء وجب على صاحب السفل أن يعيد بناء سفله، فإذا امتنع جاز للقاضي أن يأمر ببيع السفل إلا إذا طلب صاحب العلو أن يعيد بناء السفل على نفقته.
(2) وفى الحالة الأخيرة يجوز لصاحب العلو أن يمنع صاحب السفل من السكنى والانتفاع حتى يؤدى ما فى ذمته، ويجوز له أيضا أن يحصل على إذن فى إيجار السفل باسم صاحبه استيفاء لحقه.$b860$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins860;

WITH ins861 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 861, 0, $h861$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات$h861$, $b861$لا يجوز لصاحب العلو أن يزيد فى ارتفاع بنائه بحيث يضر بالسفل.$b861$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins861;

WITH ins862 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 862, 0, $h862$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات > اتحاد ملاك طبقات البناء الواحد$h862$, $b862$(1) حينما توجد ملكية مشتركة لعقار مقسم إلى طبقات أو شقق جاز للملاك أن يكونوا اتحادا فيما بينهم.
(2) ويجوز أن يكون الغرض من تكوين الاتحاد بناء العقارات أو شراءها أو توزيع ملكية أجزائها على أعضائها.$b862$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins862;

WITH ins863 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 863, 0, $h863$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات > اتحاد ملاك طبقات البناء الواحد$h863$, $b863$للاتحاد أن يضع بموافقة جميع الأعضاء نظاما لضمان حسن الانتفاع بالعقار المشترك وحسن أدارته.$b863$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins863;

WITH ins864 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 864, 0, $h864$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات > اتحاد ملاك طبقات البناء الواحد$h864$, $b864$إذا لم يوجد نظام للإدارة أو إذا خلا النظام من النص على بعض الأمر، تكون أدارة الأجزاء المشتركة من حق الاتحاد، وتكون قراراته فى ذلك ملزمة بشرط أن يدعى جميع ذوى الشأن بكتاب موصى عليه إلى الاجتماع، وأن تصدر القرارات من أغلبية الملاك محسوبة على أساس قيمة الأنصباء.$b864$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins864;

WITH ins865 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 865, 0, $h865$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات > اتحاد ملاك طبقات البناء الواحد$h865$, $b865$للاتحاد بأغلبية الأصوات المنصوص عليها فى المادة السابقة، أن يفرض أى تأمين مشترك ضد الأخطار التى تهدد العقار أو الشركاء فى جملتهم، وله أن يأذن فى إجراء أية أعمال أو تركيبات مما يترتب عليها زيادة قيمة العقار كله أو شروط والتزامات أخرى لمصلحة الشركاء.$b865$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins865;

WITH ins866 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 866, 0, $h866$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات > اتحاد ملاك طبقات البناء الواحد$h866$, $b866$(1) يكون للاتحاد مأمور يعينه بالأغلبية المشار إليها فى المادة 864، فإن لم تتحقق الأغلبية عين بأمر يصدر من رئيس المحكمة الابتدائية الكائن فى دائرتها العقار بناء على طلب أحد الشركاء بعد إعلان الملاك الآخرين لسماع أقوالهم. وعلى المأمور إذا اقتضى الحال أن يقوم من تلقاء نفسه بما يلزم لحفظ جميع الأجزاء المشتركة وحراستها وصيانتها، وله أن يطالب كل ذي شأن بتنفيذ هذه الالتزامات، كل هذا ما لم يوجد نص فى نظام الاتحاد يخالفه.
(2) ويمثل المأمور الاتحاد أمام القضاء حتى فى مخاصمة الملاك إذا اقتضى الأمر.$b866$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins866;

WITH ins867 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 867, 0, $h867$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات > اتحاد ملاك طبقات البناء الواحد$h867$, $b867$(1) أجر المأمور يحدده القرار أو الأمر الصادر بتعيينه.
(2) ويجوز عزله بقرار تتوافر فيه الأغلبية المشار إليها فى المادة 864 أو بأمر يصدر من رئيس المحكمة الابتدائية الكائن فى دائرتها العقار بعد إعلان الشركاء لسماع أقوالهم فى هذا العزل.$b867$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins867;

WITH ins868 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 868, 0, $h868$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات > اتحاد ملاك طبقات البناء الواحد$h868$, $b868$(1) إذا هلك البناء بحريق أو بسبب آخر، فعلى الشركاء أن يلتزموا من حيث تجديده بما يقرره الاتحاد بالأغلبية المنصوص عليها فى المادة 864 ما لم يتفق على خلاف ذلك.
(2) فإذا قرر الاتحاد تجديد البناء خصص ما يستحق من تعويض عن هلاك البناء لأعمال التجديد، دون إخلال بحقوق أصحاب الديون المقيدة.$b868$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins868;

WITH ins869 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 869, 0, $h869$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الأول - حق الملكية بوجه العام > 3- الملكية الشائعة > ملكيات الطبقات > اتحاد ملاك طبقات البناء الواحد$h869$, $b869$(1) كل قرض يمنحه أحد الشركاء للاتحاد لتمكينه من القيام بالتزاماته يكون مضمونا بامتياز على الجزء المفرز الذى يملكه ذلك الشريك وعلى حصته الشائعة فى الأجزاء المشتركة فى العقار.
(2) وتحسب مرتبة هذا الامتياز من يوم قيده.$b869$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins869;

WITH ins870 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 870, 0, $h870$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 1- الاستيلاء > الاستيلاء على منقول ليس له مالك$h870$, $b870$من وضع يده على منقول لا مالك له بنية تملكه، ملكه.$b870$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins870;

WITH ins871 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 871, 0, $h871$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 1- الاستيلاء > الاستيلاء على منقول ليس له مالك$h871$, $b871$(1) يصبح المنقول لا مالك له إذا تخلى عنه مالكه بقصد النزول عن ملكيته.
(2) وتعتبر الحيوانات غير الألفية لا مالك لها مادامت طليقة، وإذا اعتقل حيوان منها ثم أفلت وعاد لا مالك له إذا لم يتبعه المالك فورا وإذا كف عن تتبعه. وما روض من الحيوانات وألف الرجوع إلى المكان المخصص له ثم فقد هذه العادة لا يرجع إلى مالكه له.$b871$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins871;

WITH ins872 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 872, 0, $h872$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 1- الاستيلاء > الكنز$h872$, $b872$(1) الكنز المدفون أو المخبوء الذى لا يستطيع أحد أن يثبت ملكيته له، يكون لمالك العقار الذى وجد فيه الكنز أو لمالك رقبته.
(2) والكنز الذي يعثر عليه فى عين موقوفة يكون ملكا خاصا للواقف ولورثته.$b872$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins872;

WITH ins873 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 873, 0, $h873$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 1- الاستيلاء > الكنز$h873$, $b873$الحق فى صيد البحر والبر واللقطة والأشياء الأثرية تنظمه لوائح خاصة.$b873$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins873;

WITH ins874 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 874, 0, $h874$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 1- الاستيلاء > الاستيلاء على عقار ليس له مالك$h874$, $b874$(1) الأراضى غير المزروعة التى لا مالك لها تكون ملكا للدولة.
(2) ولا يجوز تملك هذه الأراضي أو وضع اليد عليها إلا بترخيص من الدولة وفقا للوائح.
(3) إلا أنه من زرع أرضا غير مزروعة أو غرسها أو بنى عليها، تملك فى الحال الزرع أو المغروس أو المبني، ولكنه يفقد ملكيته بعدم استعمالها مدة خمس سنوات خلال العشر السنوات التالية للتمليك.$b874$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins874;

WITH ins875 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 875, 0, $h875$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة$h875$, $b875$(1) تعيين الورثة وتحديد أنصبائهم فى الإرث وانتقال أموالهم إليهم تسرى فى شأنها أحكام الشريعة الإسلامية والقوانين الصادرة فى شأنها.
(2) وتتبع فى تصفية التركة الأحكام الآتية:$b875$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins875;

WITH ins876 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 876, 0, $h876$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تعيين مصف للتركة$h876$, $b876$إذا لم يعين المورث وصيا لتركته وطلب أحد ذوى الشأن تعيين مصف لها، عينت المحكمة، إذا رأت موجبا لذلك، من تجمع الورثة على اختياره، فإن لم تجمع الورثة على اختياره تولى القاضى اختيار المصفى بقدر الإمكان من بين هؤلاء الورثة، وذلك بعد سماع أقوالهم.$b876$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins876;

WITH ins877 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 877, 0, $h877$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تعيين مصف للتركة$h877$, $b877$(1) لمن عين مصفيا أن يرفض تولى هذه المهمة أو يتنحى عنها بعد توليها وذلك طبقا لأحكام الوكالة.
(2) وللقاضي أيضا، إذا طلب إليه أحد ذوى الشأن أو النيابة العامة طلب عزل المصفى واستبداله بغيره، متى وجدت أسباب تبرر ذلك.$b877$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins877;

WITH ins878 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 878, 0, $h878$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تعيين مصف للتركة$h878$, $b878$(1) إذا عين المورث وصيا للتركة وجب أن يقر القاضي هذا التعيين.
(2) ويسرى على وصي التركة ما يسرى على المصفى من أحكام.$b878$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins878;

WITH ins879 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 879, 0, $h879$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تعيين مصف للتركة$h879$, $b879$(1) على كاتب المحكمة أن يقيد يوما فيوما الأوامر الصادرة بتعيين المصفين وبتثبيت أوصياء التركة، فى سجل عام تدون فيه أسماء المورثين بحسب الأوضاع المقررة للفهارس الأبجدية ويجب أن يؤشر فى هامش السجل بكل أمر يصدر بالعزل وبكل ما يقع من تنازل.
(2) ويكون لقيد الأمر الصادر بتعيين المصفى من الأثر فى حق الغير الذى يتعامل مع الورثة فى شأن عقارات التركة ما للتأشير المنصوص عليه فى المادة 914.$b879$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins879;

WITH ins880 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 880, 0, $h880$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h880$, $b880$(1) يتسلم المصفى أموال التركة بمجرد تعيينه، ويتولى تصفيتها برقابة المحكمة، وله أن يطلب منها أجرا عادلا على قيامه بمهمته.
(2) ونفقات التصفية تتحملها التركة، ويكون لهذه النفقات حق امتياز فى مرتبة امتياز المصروفات القضائية.$b880$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins880;

WITH ins881 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 881, 0, $h881$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h881$, $b881$على المحكمة أن تتخذ عند الاقتضاء جميع الاحتياطات المستعجلة للمحافظة على التركة، وذلك بناء على طلب أحد ذوى الشأن أو بناء على طلب النيابة العامة أو من تلقاء نفسها، ولها بوجه خاص أن تأمر بوضع الأختام وإيداع النقود والأوراق المالية والأشياء ذات القيمة.$b881$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins881;

WITH ins882 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 882, 0, $h882$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h882$, $b882$(1) على المصفى أن يقوم فى الحال بالصرف من مال التركة لتسديد نفقات تجهيز الميت ونفقات مأتمه بما يناسب حالته، وعليه أيضا أن يستصدر أمرا من قاضي الأمور الوقتية بصرف نفقة كافية بالقدر المقبول من هذا المال إلى من كان المورث يعولهم حتى تنتهي التصفية، على أن تخصم النفقة التى تستوفيها كل وارث من نصيبه فى الإرث.
(2) وكل منازعة تتعلق بهذه النفقة يفصل فيها قاضى الأمور الوقتية.$b882$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins882;

WITH ins883 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 883, 0, $h883$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h883$, $b883$(1) لا يجوز من وقت قيد الأمر الصادر بتعيين المصفى أن يتخذ الدائنون أى إجراء على التركة، كما لا يجوز لهم أن يستمروا فى إجراء اتخذوه إلا فى مواجهة المصفى.
(2) وكل توزيع فتح ضد المورث ولم تقفل قائمته النهائية يجب وقفه حتى تتم تسوية جميع ديون التركة متى طلب ذلك أحد ذوى الشأن.$b883$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins883;

WITH ins884 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 884, 0, $h884$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h884$, $b884$لا يجوز للوارث قبل أن يتسلم إليه شهادة التوريث المنصوص عليها فى المادة 901 أن يتصرف فى مال من مال التركة من ديون أو أن يجعل دينا عليه قصاصا بدين يدينه للتركة.$b884$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins884;

WITH ins885 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 885, 0, $h885$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h885$, $b885$(1) على المصفى أثناء التصفية أن يتخذ من الوسائل التحفظية ما تتطلبه أموال التركة، وأن يقوم بما يلزم من الإدارة، وعليه أيضا أن ينوب عن التركة فى الدعاوى وأن يستوفى ما لها من ديون قد حلت.
(2) ويكون المصفى، ولو لم يكن مأجورا، مسئولا مسئولية الوكيل المأجور. وللقاضي أن يطالبه بتقديم حساب عن إدارته فى مواعيد دورية.$b885$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins885;

WITH ins886 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 886, 0, $h886$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h886$, $b886$(1) على المصفى أن يوجه تكليفا لدائني التركة ومدينيها بأن يدعوهم فيه بأن يقدموا بيانا بما لهم من حقوق وما عليهم من ديون خلال ثلاثة أشهر من التاريخ الذى ينشر فيه التكليف.
(2) ويجب أن يلصق التكليف على الباب الرئيسي لمقر العمدة فى المدينة أو القرية التى توجد بها أعيان التركة، أو على الباب الرئيسي لمركز البوليس فى المدن التى تقع فى دائرتها هذه الأعيان، وفى لوحة المحكمة الجزئية التى يقع فى دائرتها آخر موطن للمورث وفى صحيفة من الصحف اليومية الواسعة الانتشار.$b886$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins886;

WITH ins887 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 887, 0, $h887$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h887$, $b887$(1) على المصفى أن يودع قلم كتاب المحكمة، خلال أربعة أشهر من تعيينه، قائمة تبين ما لها وما عليها وتشتمل على تقدير لقيمة هذه الأموال، وعليه أيضا أن يخطر بكتاب موصى عليه كل ذي شأن بتاريخ الميعاد المتقدم بشأن هذا الإيداع.
(2) ويجوز أن يطلب من القاضي مد هذا الميعاد إذا وجدت ظروف تبرر ذلك.$b887$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins887;

WITH ins888 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 888, 0, $h888$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h888$, $b888$(1) للمصفى أن يستعين فى الجرد وفى تقدير قيمة أموال التركة بخبير أو بمن يكون له فى ذلك دراية خاصة.
(2) وعلى المصفى أن يثبت ما تكشف عنه أوراق المورث وما هو ثابت فى السجلات العامة من حقوق وديون وما يصل إلى علمه من أى طريق كان من ديون على التركة أو حقوق لها، وعلى الورثة أن يبلغوا المصفى عما يعلمونه من ديون على التركة وحقوق لها.$b888$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins888;

WITH ins889 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 889, 0, $h889$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h889$, $b889$يعاقب بعقوبة التبديد كل من استولى غشا على شىء من مال التركة ولو كان وارثا.$b889$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins889;

WITH ins890 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 890, 0, $h890$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > جرد التركة$h890$, $b890$(1) كل منازعة فى صحة الجرد، وبخاصة ما كان متعلقا بإغفال أعيان أو حقوق للتركة أو عليها، ترفع بعريضة للمحكمة بناء على طلب كل ذى شأن خلال الثلاثين يوما التالية لإيداع قائمة الجرد.
(2) وتجرى المحكمة تحقيقا، فإذا رأت أن الشكوى جدية أصدرت أمرا بقبولها، ويصح الطعن فى هذا الأمر وفقا لأحكام قانون المرافعات.
(3) وإن لم يكن النزاع قد سبق رفعه إلى القضاء عينت المحكمة أجلا يرفع فيه ذو الشأن دعواه أمام المحكمة المختصة، وتقضى فيها هذه المحكمة على وجه الاستعجال.$b890$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins890;

WITH ins891 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 891, 0, $h891$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسوية ديون التركة$h891$, $b891$بعد انقضاء الميعاد لرفع المنازعات المتعلقة بالجرد، يقوم المصفى بعد استئذان المحكمة بوفاء ديون التركة التى لم يقم فى شأنها نزاع نهائيا، أما الديون التى يقوم فيها نزاع فتسوى بعد الفصل فى النزاع نهائيا.$b891$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins891;

WITH ins892 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 892, 0, $h892$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسوية ديون التركة$h892$, $b892$على المصفى فى حالة إعسار التركة أو فى حالة احتمال إعسارها، أن يقف تسوية أى دين، ولو لم يقم فى شأنه نزاع، حتى يفصل نهائيا فى جميع المنازعات المتعلقة بديون التركة.$b892$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins892;

WITH ins893 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 893, 0, $h893$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسوية ديون التركة$h893$, $b893$(1) يقوم المصفى بوفاء ديون التركة مما يحصله من حقوقها، ومما تشتمل عليه من نقود، ومن ثمن ما يكون قد باعه بسعر السوق من أوراق مالية، ومن ثمن منقول فى التركة إن لم يكن ذلك كافيا، ومن ثمن عقار من التركة إن لم يكن ذلك كافيا.
(2) وتباع منقولات التركة وعقاراتها بالمزاد العلني وفقا للأوضاع المنصوص عليها فى المواعيد الجبرية، إلا إذا اتفق جميع الورثة على أن يتم البيع بطريقة أخرى أو على أن يتم ممارسة. فإذا كانت التركة معسرة لزمت أيضا موافقة جميع الدائنين. وللورثة الحق فى جميع الأحوال فى أن يدخلوا فى المزاد.$b893$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins893;

WITH ins894 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 894, 0, $h894$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسوية ديون التركة$h894$, $b894$للمحكمة بناء على طلب جميع الورثة أن تحكم بحلول الدين المؤجل وبتعيين المبلغ الذى يستحقه الدائن المؤجل مراعية فى ذلك حكم المادة 554.$b894$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins894;

WITH ins895 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 895, 0, $h895$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسوية ديون التركة$h895$, $b895$(1) إذا لم يجمع الورثة على طلب حلول الدين المؤجل، تولت المحكمة توزيع الديون المؤجلة وتوزيع أموال الدين المؤجل، بحيث يختص كل وارث من جملة ديون التركة ومن جملة أموالها بما يكون معادلا لصافي حصته فى الإرث.
(2) وترتب المحكمة لكل دائن من دائني التركة تأمينا كافيا على عقار أو منقول، على أن تحتفظ لمن كان له تأمين خاص بنفس هذا التأمين، فإن استحال تحقيق ذلك، التزم له الورثة من مالهم الخاص أو بالاتفاق على أية تسوية أخرى، رتبت المحكمة التأمين على جميع أموال التركة جميعها.
(3) وفى جميع هذه الأحوال إذا ورد تأمين على عقار ولم يكن قد سبق شهره وجب أن يشهر قبل أن يحل هذا التأمين وفقا للأحكام المقررة فى شهر حق الاختصاص.$b895$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins895;

WITH ins896 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 896, 0, $h896$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسوية ديون التركة$h896$, $b896$يجوز لكل وارث أو دائن بعد توزيع الديون المؤجلة أن يدفع القدر الذى اختص به قبل أن يحل الأجل الذى يحدده طبقا للمادة 894.$b896$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins896;

WITH ins897 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 897, 0, $h897$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسوية ديون التركة$h897$, $b897$دائنو التركة الذين لم يستوفوا حقوقهم لعدم ظهورهم فى قائمة الجرد ولم تكن لهم تأمينات على أموال التركة، لا يجوز لهم أن يرجعوا على من كسب حقا عينيا بحسن نية على تلك الأموال، وإنما لهم الرجوع على الورثة بسبب إثرائهم.$b897$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins897;

WITH ins898 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 898, 0, $h898$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسوية ديون التركة$h898$, $b898$يتولى المصفى بعد تسوية ديون التركة تنفيذ الوصايا وغيرها من التكاليف.$b898$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins898;

WITH ins899 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 899, 0, $h899$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h899$, $b899$بعد تنفيذ التزامات التركة يؤول ما بقي من أموالها إلى الورثة كل بحسب نصيبه الشرعي.$b899$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins899;

WITH ins900 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 900, 0, $h900$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h900$, $b900$(1) يسلم المصفى إلى الورثة ما آل إليهم من أموال التركة، وله أن يسمح لهم بأن يتسلموا، بصفة مؤقتة، الأشياء أو النقود التى لا يحتاج لها فى تصفية التركة، أو أن يتسلموا بعضا منها وذلك مقابل تقديم كفالة أو بدون تقديمها.$b900$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins900;

WITH ins901 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 901, 0, $h901$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h901$, $b901$تسلم المحكمة إلى كل وارث يقدم إعلاما شرعيا بالوراثة أو ما يقوم مقام هذا الإعلام، شهادة تقرر حقه فى الإرث وتبين حقه فى أموال التركة.$b901$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins901;

WITH ins902 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 902, 0, $h902$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h902$, $b902$لكل وارث أن يطلب من المصفى أن يسلمه نصيبه فى الإرث مفرزا، إلا إذا كان الوارث ملزما بالبقاء فى الشيوع بناء على اتفاق أو نص فى القانون.$b902$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins902;

WITH ins903 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 903, 0, $h903$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h903$, $b903$(1) إذا كان طلب القسمة واجب القبول، تولى المصفى إجراء هذه القسمة بطريقة ودية على ألا تصبح هذه القسمة نهائية إلا بعد أن يقرها الورثة بالإجماع.
(2) فإذا لم ينعقد إجماعهم على ذلك، فعلى المصفى أن يرفع على نفقة التركة دعوى القسمة وفقا لأحكام القانون، وتستنزل نفقات الدعوى من أنصباء المتقاسمين.$b903$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins903;

WITH ins904 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 904, 0, $h904$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h904$, $b904$تسرى على قسمة التركة القواعد المقررة للقسمة فى القسمة، وبوجه خاص ما يتعلق منها بضمان التعرض والاستحقاق وبامتياز المتقاسم، وتسرى عليها أيضا الأحكام الآتية:$b904$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins904;

WITH ins905 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 905, 0, $h905$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h905$, $b905$إذا لم يتفق الورثة على قسمة الأوراق المالية العائلية أو الأشياء التى تتصل بعاطفة الورثة نحو المورث أمرت المحكمة إما ببيع هذه الأشياء أو بإعطائها لأحد الورثة مع استنزال قيمتها من نصيبه فى الميراث دون استنزال، ويراعى فى ذلك ما يجرى عليه العرف من ظروف شخصية بالورثة.$b905$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins905;

WITH ins906 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 906, 0, $h906$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h906$, $b906$إذا كان بين أموال التركة مستغل زراعي أو تجاري أو صناعي يعتبر مما يكون وحدة اقتصادية قائمة بذاتها، وجب تخصيصه بقيمته لمن يطلبه من الورثة إذا كان أقدرهم على الاضطلاع به. وثمن هذا المستغل يقوم بحسب قيمته ويستنزل من نصيب الوارث فى التركة، فإذا تساوت قدرة الورثة على الاضطلاع بالمستغل خصص لمن يعطى من بينهم أعلى قيمة لا تقل عن ثمن المثل.$b906$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins906;

WITH ins907 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 907, 0, $h907$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h907$, $b907$إذا اختص أحد الورثة بدين عند القسمة للتركة، فإن باقي الورثة لا يضمنون له المدين إذا هو أعسر بعد القسمة ما لم يوجد اتفاق يقضى بغير ذلك.$b907$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins907;

WITH ins908 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 908, 0, $h908$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h908$, $b908$تصح الوصية بقسمة أعيان التركة على الورثة الموصى، بحيث يعين لكل وارث أو لبعضهم نصيب، فإن زاد نصيبه عما لأحدهم على استحقاقه فى التركة كانت الزيادة وصية.$b908$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins908;

WITH ins909 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 909, 0, $h909$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h909$, $b909$القسمة المضافة إلى ما بعد الموت يجوز الرجوع فيها دائما، وتصبح لازمة بوفاة الموصى.$b909$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins909;

WITH ins910 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 910, 0, $h910$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h910$, $b910$إذا لم تشتمل القسمة جميع أموال المورث وقت وفاته، فإن الأموال التى لم تدخل فى القسمة تؤول شائعة إلى الورثة طبقا لقواعد الميراث.$b910$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins910;

WITH ins911 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 911, 0, $h911$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h911$, $b911$إذا مات قبل وفاة المورث واحد أو أكثر من الورثة المحتملين الذين دخلوا فى القسمة، فإن الحصة المفرزة التى وقعت فى نصيب من مات تؤول شائعة إلى الورثة طبقا لقواعد الميراث.$b911$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins911;

WITH ins912 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 912, 0, $h912$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h912$, $b912$تسرى فى القسمة المضافة إلى ما بعد الموت أحكام القسمة عامة عدا أحكام الغين.$b912$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins912;

WITH ins913 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 913, 0, $h913$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > تسليم أموال التركة وقسمة هذه الأموال$h913$, $b913$إذا لم تشتمل القسمة ديون التركة، أو شملتها ولكن لم يوافق الدائنون على هذه القسمة، جاز عند عدم تسوية الديون بالاتفاق مع الدائنين أن يطلب أى وارث قسمة التركة طبقا للمادة 895، على أن تراعى بقدر الإمكان الاعتبارات والنوايا التى أوصى بها المورث وبنيت عليها.$b913$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins913;

WITH ins914 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 914, 0, $h914$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 2- الميراث وتصفية التركة > أحكام التركات التى لم تصف$h914$, $b914$إذا لم تكن التركة قد صفيت وفقا لأحكام النصوص السابقة، جاز لدائني التركة العاديين أن ينفذوا بحقوقهم أو بما أوصى به لهم على عقارات التركة التى حصل التصرف فيها، أو التى رتبت عليها حقوق عينية لصالح الغير، إذا أشهروا ديونهم وفقا لأحكام القانون.$b914$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins914;

WITH ins915 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 915, 0, $h915$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 3- الوصية$h915$, $b915$تسرى على الوصية أحكام الشريعة الإسلامية والقوانين الصادرة فى شأنها.$b915$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins915;

WITH ins916 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 916, 0, $h916$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 3- الوصية$h916$, $b916$(1) كل عمل قانوني يصدر من شخص فى مرض الموت ويكون مقصودا به التبرع، يعتبر مضافا إلى ما بعد الموت، وتسرى عليه أحكام الوصية أيا كانت التسمية التى أعطت لهذا التصرف.
(2) وعلى ورثة من يثبتوا أن العمل القانوني قد صدر من مورثهم وهو فى مرض الموت، ولهم إثبات ذلك بجميع الطرق، ولا يحتج على الورثة بتاريخ السند إذا لم يكن هذا التاريخ ثابتا.
(3) وإذا أثبت الورثة أن التصرف صدر من مورثهم فى مرض الموت، اعتبر التصرف صادرا على سبيل التبرع، ما لم يثبت من صدر له التصرف عكس ذلك. كل هذا ما لم توجد أحكام خاصة تخالفه.$b916$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins916;

WITH ins917 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 917, 0, $h917$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 3- الوصية$h917$, $b917$إذا تصرف شخص لأحد ورثته واحتفظ بأية طريقة كانت بحيازة العين التى تصرف فيها، وبحقه فى الانتفاع بها مدى حياته، اعتبر التصرف مضافا إلى ما بعد الموت وتسرى عليه أحكام الوصية ما لم يقم دليل يخالف ذلك.$b917$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins917;

WITH ins918 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 918, 0, $h918$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h918$, $b918$الأرض التى تتكون من طمي النهر يجلبه بطريقة تدريجية محسوسة تكون ملكا للملاك المجاورين.$b918$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins918;

WITH ins919 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 919, 0, $h919$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h919$, $b919$(1) الأراضي التى ينكشف عنها البحر تكون ملكا للدولة.
(2) ولا يجوز التعدي على أرض البحر إلا إذا كان ذلك لإعادة حدود الملك الذى طغى عليه البحر.$b919$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins919;

WITH ins920 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 920, 0, $h920$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h920$, $b920$ملاك الأراضي الملاصقة للمياه الراكدة كمياه البحيرات والبرك، لا يملكون ما تنكشف عنه هذه المياه من أرض.$b920$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins920;

WITH ins921 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 921, 0, $h921$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h921$, $b921$الأراضي التى يحولها النهر من مكانها أو ينكشف عنها، والجزائر التى تتكون فى مجراه، تكون ملكيتها خاضعة للقوانين الخاصة بها.$b921$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins921;

WITH ins922 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 922, 0, $h922$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h922$, $b922$(1) كل ما على الأرض أو تحتها من بناء أو غراس أو منشآت أخرى، يعتبر من عمل صاحب الأرض أقامه على نفقته ويكون مملوكا له.
(2) ويجوز مع ذلك أن يقام الدليل على أن أجنبيا قد أقام هذه المنشآت على نفقته، كما يجوز أن يقام الدليل على أن مالك الأرض قد خول أجنبيا ملكية منشآت كانت قائمة من قبل، أو خوله الحق فى إقامة هذه المنشآت وتملكها.$b922$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins922;

WITH ins923 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 923, 0, $h923$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h923$, $b923$(1) يكون مالكا خالصا لصاحب الأرض ما يحدثه فيها من بناء أو غراس أو منشآت أخرى من مواد يقيمها بمواد مملوكة لغيره، إذا لم يكن ممكنا نزع هذه المواد دون أن يلحق هذه المنشآت ضرر جسيم، أو كان ممكنا نزعها ولكن لم ترفع الدعوى باستردادها خلال سنة من اليوم الذى يعلم فيه مالك المواد أنها اندمجت فى هذه المنشآت.
(2) فإذا تملك صاحب الأرض المواد، كان عليه أن يدفع قيمتها مع التعويض عن الضرر إن كان له وجه. أما إذا استرد المواد صاحبها فإن نزعها يكون على نفقة صاحب الأرض.$b923$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins923;

WITH ins924 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 924, 0, $h924$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h924$, $b924$(1) إذا أقام شخص منشآت بمواد من عنده فى أرض يعلم أنها مملوكة لغيره دون رضاء صاحب الأرض، كان لهذا أن يطلب إزالة المنشآت على نفقة من أقامها مع التعويض إن كان له وجه، وذلك فى ميعاد سنة من اليوم الذى يعلم فيه بإقامة المنشآت، أو أن يطلب استبقاء المنشآت مقابل دفع قيمتها مستحقة الإزالة، أو دفع مبلغ يساوي ما زاد فى ثمن الأرض بسبب هذه المنشآت.
(2) ويجوز لمن أقام المنشآت أن يطلب نزعها إن كان ذلك لا يلحق بالأرض ضررا، إلا إذا اختار صاحب الأرض أن يستبقى المنشآت طبقا لأحكام الفقرة السابقة.$b924$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins924;

WITH ins925 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 925, 0, $h925$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h925$, $b925$(1) إذا كان من أقام المنشآت المشار إليها فى المادة السابقة يعتقد بحسن نية أن له الحق فى إقامتها، فلا يكون لصاحب الأرض أن يطلب الإزالة، وإنما يخير بين أن يدفع قيمة المواد وأجرة العمل أو أن يدفع مبلغا يساوي ما زاد فى ثمن الأرض بسبب هذه المنشآت، هذا ما لم يطلب صاحب المنشآت نزعها.
(2) إلا أنه إذا كانت المنشآت قد بلغت حدا من الجسامة يرهق صاحب الأرض أن يؤدى ما هو مستحق عنها، كان له أن يطلب تمليك الأرض لمن أقام المنشآت نظير تعويض عادل.$b925$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins925;

WITH ins926 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 926, 0, $h926$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h926$, $b926$إذا أقام أجنبي منشآت بمواد من عنده بعد الحصول على ترخيص من مالك الأرض، فلا يجوز لهذا المالك إلا إذا لم يوجد اتفاق يخالف ذلك فى شأن هذه المنشآت أن يطلب إزالتها، ويجب عليه إذا لم يطلب صاحب المنشآت نزعها أن يؤدى إليه إحدى القيمتين المنصوص عليهما فى الفقرة الأولى من المادة السابقة.$b926$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins926;

WITH ins927 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 927, 0, $h927$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h927$, $b927$تسرى أحكام المادة 982 فى أداء التعويض المنصوص عليه فى المواد الثلاث السابقة.$b927$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins927;

WITH ins928 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 928, 0, $h928$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h928$, $b928$إذا كان مالك الأرض وهو جار قد أقام عليها بناء على جزء من الأرض الملاصقة بحسن نية، جاز للمحكمة إذا رأت لذلك محلا ألا تجبر صاحب هذه الأرض على أن ينزل لجاره عن ملكية الجزء المشغول بالبناء، وذلك فى نظير تعويض عادل.$b928$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins928;

WITH ins929 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 929, 0, $h929$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h929$, $b929$المنشآت الصغيرة كالأكشاك والحوانيت والمأوى التى تقام على أرض الغير دون أن يكون مقصودا بقاؤها على الدوام تكون ملكا لمن أقامها.$b929$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins929;

WITH ins930 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 930, 0, $h930$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالعقار$h930$, $b930$إذا أقام أجنبي منشآت بمواد مملوكة لغيره، فليس لمالك المواد أن يطلب استردادها، وإنما يكون له أن يرجع بالتعويض على هذا الأجنبي، كما يكون له أن يرجع على مالك الأرض بما لا يزيد على ما هو باق فى ذمته للأجنبي بالتعويض له بما لا يزيد على قيمة تلك المنشآت.$b930$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins930;

WITH ins931 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 931, 0, $h931$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 4- الالتصاق > الالتصاق بالمنقول$h931$, $b931$إذا التصق منقولان لمالكين مختلفين بحيث لا يمكن فصلهما دون تلف ولم يكن هناك اتفاق بين المالكين فى الأمر، قضت المحكمة مسترشدة بقواعد العدالة، ومراعاة الضرر الذى حدث وحالة الطرفين وحسن نية كل منهما.$b931$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins931;

WITH ins932 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 932, 0, $h932$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 5- العقد$h932$, $b932$تنتقل الملكية وغيرها من الحقوق العينية فى المنقول والعقار بالعقد، متى ورد على محل مملوك للمتصرف، وذلك مع مراعاة النصوص الآتية طبقا للمادتين 204 و205.$b932$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins932;

WITH ins933 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 933, 0, $h933$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 5- العقد$h933$, $b933$المنقول الذى لم يتعين بنوعه لا تنتقل ملكيته إلا بإفرازه طبقا للمادة 205.$b933$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins933;

WITH ins934 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 934, 0, $h934$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 5- العقد$h934$, $b934$(1) فى المواد العقارية لا تنتقل الملكية ولا الحقوق العينية الأخرى سواء كان ذلك فيما بين المتعاقدين أم فى حق الغير، إلا إذا روعيت الأحكام المبينة فى قانون تنظيم الشهر العقاري.
(2) ويبين قانون الشهر المتقدم الذكر التصرفات والأحكام والسندات التى يجب شهرها سواء أكانت ناقلة للملكية أو غير ناقلة، ويقرر الأحكام المتعلقة بهذا الشهر.$b934$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins934;

WITH ins935 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 935, 0, $h935$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > شروط الأخذ بالشفعة$h935$, $b935$الشفعة رخصة تجيز فى الأحوال وبالشروط المنصوص عليها فى المواد التالية الحلول محل المشترى فى بيع العقار.$b935$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins935;

WITH ins936 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 936, 0, $h936$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > شروط الأخذ بالشفعة$h936$, $b936$يثبت الحق فى الشفعة:
(أ) لمالك الرقبة إذا بيع كل حق الانتفاع الملابس لها أو بعضه.
(ب) للشريك فى الشيوع إذا بيع لأجنبي شىء من العقار الشائع.
(ج) لصاحب حق الانتفاع إذا بيعت كل الرقبة الملابسة لهذا الحق أو بعضها.
(د) لمالك الرقبة فى الحكر إذا بيع حق الحكر، وللمستحكر إذا بيعت الرقبة.
(هـ) للجار المالك فى الأحوال الآتية:
إذا كانت العقارات من المباني أو من الأراضي المعدة للبناء سواء أكانت فى المدن أم فى القرى.
إذا كان للأرض المبيعة حق ارتفاق على أرض الجار، أو كان حق الارتفاق لأرض الجار على الأرض المبيعة.
إذا كانت أرض الجار ملاصقة للأرض المبيعة من جهتين وتساوى من القيمة نصف ثمن الأرض المبيعة على الأقل.$b936$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins936;

WITH ins937 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 937, 0, $h937$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > شروط الأخذ بالشفعة$h937$, $b937$(1) إذا تزاحم الشفعاء يكون استعمال حق الشفعة على حسب الترتيب المنصوص عليه فى المادة السابقة.
(2) وإذا تزاحم الشفعاء من طبقة واحدة، فاستحقاق كل منهم للشفعة يكون على قدر نصيبه.
(3) فإذا كان المشترى قد توافرت فيه الشروط التى تجعله شفيعا، فإنه يفضل على الشفعاء الذين هم من طبقته أو من طبقة أدنى، ولكن يتقدمه الذين هم من طبقة أعلى.$b937$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins937;

WITH ins938 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 938, 0, $h938$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > شروط الأخذ بالشفعة$h938$, $b938$إذا اشترى شخص عينا تجوز فيها الشفعة ثم باعها رغبة قبل أن تعلن أية رغبة فى الأخذ بالشفعة أو قبل أن يتم تسجيل هذه الرغبة طبقا للمادة 942، فلا يجوز الأخذ بالشفعة فى البيع الثانى إلا من المشترى الذى اشترى بالشروط التى اشترى بها.$b938$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins938;

WITH ins939 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 939, 0, $h939$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > شروط الأخذ بالشفعة$h939$, $b939$(1) لا يجوز الأخذ بالشفعة:
(أ) إذا حصل البيع بالمزاد العلني وفقا لإجراءات رسمها القانون.
(ب) إذا وقع البيع بين الأصول والفروع أو بين الزوجين أو بين الأقارب لغاية الدرجة الرابعة أو بين الأصهار لغاية الدرجة الثانية.
(ج) إذا كان العقار قد بيع ليجعل محل عبادة أو ليلحق بمحل عبادة.
(2) ولا يجوز للوقف أن يأخذ بالشفعة.$b939$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins939;

WITH ins940 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 940, 0, $h940$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > إجراءات الشفعة$h940$, $b940$على من يريد الأخذ بالشفعة أن يعلن رغبته فيها إلى كل من البائع والمشترى خلال خمسة عشر يوما من تاريخ الإنذار الرسمي الذى يوجهه إليه البائع أو المشترى وإلا سقط حقه، ويزاد على تلك المدة ميعاد المسافة إذا اقتضى الأمر ذلك.$b940$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins940;

WITH ins941 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 941, 0, $h941$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > إجراءات الشفعة$h941$, $b941$يشتمل الإنذار الرسمي المنصوص عليه فى المادة السابقة على البيانات الآتية وإلا كان باطلا:
(أ) بيان العقار الجائز أخذه بالشفعة بيانا كافيا.
(ب) بيان الثمن والمصروفات الرسمية وشروط البيع واسم كل من البائع والمشترى ولقبه وصناعته وموطنه.$b941$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins941;

WITH ins942 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 942, 0, $h942$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > إجراءات الشفعة$h942$, $b942$(1) إعلان الرغبة بالأخذ بالشفعة يجب أن يكون رسميا وإلا كان باطلا. ولا يكون هذا الإعلان حجة على الغير إلا إذا سجل.
(2) وخلال ثلاثين يوما على الأكثر من تاريخ هذا الإعلان يجب أن يودع خزانة المحكمة الكائن فى دائرتها العقار كل الثمن الحقيقي الذى حصل به البيع، مع مراعاة أن يكون هذا الإيداع قبل رفع دعوى الشفعة، فإن لم يتم الإيداع على الوجه المتقدم بيانه سقط حق الأخذ بالشفعة.$b942$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins942;

WITH ins943 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 943, 0, $h943$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > إجراءات الشفعة$h943$, $b943$ترفع دعوى الشفعة على البائع والمشترى أمام المحكمة الكائن فى دائرتها العقار وتقيد بالجدول، ويكون كل ذلك خلال ثلاثين يوما من تاريخ الإعلان المنصوص عليه فى المادة السابقة وإلا سقط الحق فى الدعوى، ويحكم فيها على وجه السرعة.$b943$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins943;

WITH ins944 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 944, 0, $h944$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > إجراءات الشفعة$h944$, $b944$الحكم الذى يصدر نهائيا بثبوت الشفعة يعتبر سندا نهائيا لملكية الشفيع وذلك دون إخلال بالقواعد المتعلقة بالتسجيل.$b944$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins944;

WITH ins945 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 945, 0, $h945$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > آثار الشفعة$h945$, $b945$(1) يحل الشفيع قبل البائع محل المشترى فى جميع حقوقه والتزاماته.
(2) وإنما لا يحق له الانتفاع بالأجل الممنوح للمشترى فى دفع الثمن إلا برضاء البائع.
(3) وإذا استحق العقار للغير بعد أخذه بالشفعة، فليس للشفيع أن يرجع إلا على البائع.$b945$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins945;

WITH ins946 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 946, 0, $h946$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > آثار الشفعة$h946$, $b946$(1) إذا بنى المشترى فى العقار المشفوع فيه أو غرس فيه أشجارا قبل إعلان الرغبة فى الشفعة، كان الشفيع ملزما لما يختاره المشترى أن يدفع له إما المبلغ الذى أنفقه أو مقدار ما زاد فى قيمة العقار بسبب البناء أو الغراس.
(2) وأما إذا حصل البناء أو الغراس بعد إعلان الرغبة فى الشفعة، كان للشفيع أن يطلب الإزالة. فإذا اختار أن يستبقى البناء أو الغراس فلا يلزم إلا بدفع قيمة أدوات البناء وأجرة العمل أو نفقات الغراس.$b946$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins946;

WITH ins947 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 947, 0, $h947$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > آثار الشفعة$h947$, $b947$لا يسرى فى حق الشفيع أى رهن رسمي أو أى حق اختصاص أخذ ضد المشترى من أى بيع صدر من المشترى ولا أى حق عيني رتبه ضده إذا كان كل ذلك قد تم بعد التاريخ الذى سجل فيه إعلان الرغبة فى الشفعة. ويبقى مع ذلك للدائنين المقيدين ما كان لهم من حقوق الأولوية فيما آل للمشترى من ثمن العقار.$b947$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins947;

WITH ins948 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 948, 0, $h948$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 6- الشفعة > سقوط الشفعة$h948$, $b948$يسقط الحق فى الأخذ بالشفعة فى الأحوال الآتية:
(أ) إذا نزل الشفيع عن حقه فى الأخذ بالشفعة ولو قبل البيع.
(ب) إذا انقضت أربعة أشهر من يوم تسجيل عقد البيع.
(ج) فى الأحوال الأخرى التى نص عليها القانون.$b948$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins948;

WITH ins949 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 949, 0, $h949$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h949$, $b949$(1) لا تقوم الحيازة على عمل يأتيه شخص على أنه مجرد رخصة من المباحات أو عمل يتحمله الغير على سبيل التسامح.
(2) وإذا اقترنت بإكراه أو حصلت خفية أو كان فيها لبس لا يكون لها أثر من وقع عليه من وقع عليه الإكراه أو أخفيت عنه أو التبس عليه أمرها، إلا من الوقت الذى تزول فيه هذه العيوب.$b949$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins949;

WITH ins950 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 950, 0, $h950$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h950$, $b950$يجوز لغير المميز أن يكسب الحيازة عن طريق من ينوب عنه نيابة قانونية.$b950$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins950;

WITH ins951 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 951, 0, $h951$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h951$, $b951$(1) تصح الحيازة بالوساطة متى كان الوسيط يباشرها باسم الحائز وكان متصلا به اتصالا يلزمه بأوامره فيما يتعلق بهذه الحيازة.
(2) وعند الشك فى مباشر الحيازة هل يباشرها لنفسه أو لغيره، فإنه إذا كانت استمرارا لحيازة سابقة افترض أن هذا الاستمرار هو لحساب من كان يباشرها.$b951$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins951;

WITH ins952 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 952, 0, $h952$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h952$, $b952$تنتقل الحيازة من الحائز إلى غيره إذا اتفقا على ذلك وكان فى استطاعة من انتقلت إليه أن يسيطر على الحق الواردة عليه الحيازة، ولو لم يكن هناك تسلم مادي للشيء موضوع هذا الحق.$b952$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins952;

WITH ins953 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 953, 0, $h953$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h953$, $b953$يجوز أن يتم نقل الحيازة دون تسليم مادي إذا استمر الحائز واضعا يده لحساب من يخلفه فى الحيازة، أو استمر الخلف واضعا يده ولكن لحساب نفسه.$b953$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins953;

WITH ins954 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 954, 0, $h954$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h954$, $b954$(1) تسليم السندات المعطاة عن البضائع المعهود بها إلى أمين النقل أو المودعة فى المخازن يقوم مقام تسليم البضائع ذاتها.
(2) على أنه إذا تسلم شخص هذه المستندات وتسلم آخر البضاعة ذاتها وكان كلاهما حسن النية فإن الأفضلية تكون لمن تسلم البضاعة.$b954$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins954;

WITH ins955 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 955, 0, $h955$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h955$, $b955$(1) تنتقل الحيازة للخلف العام بصفاتها، على أنه إذا كان السلف سيئ النية وأثبت الخلف أنه كان فى حيازته حسن النية جاز له أن يتمسك بحسن نيته.
(2) ويجوز للخلف الخاص أن يضم إلى حيازته حيازة سلفه فى كل ما يرتب القانون على الحيازة من أثر.$b955$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins955;

WITH ins956 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 956, 0, $h956$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h956$, $b956$تزول الحيازة إذا تخلى الحائز عن سيطرته الفعلية على الحق أو إذا فقد هذه السيطرة بأية طريقة أخرى.$b956$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins956;

WITH ins957 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 957, 0, $h957$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها$h957$, $b957$(1) لا تنقضي الحيازة إذا حال دون مباشرة السيطرة الفعلية على الحق مانع وقتي.
(2) ولكن الحيازة تنقضي إذا استمر هذا المانع سنة كاملة، وكان ناشئا من حيازة جديدة وقعت رغم إرادة الحائز أو دون علمه. وتحسب ابتداء من الوقت الذى باتت فيه الحيازة الجديدة خفية، إذا بدأت علنا، أو من وقت علم الحائز الأول بها إذا بدأت خفية.$b957$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins957;

WITH ins958 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 958, 0, $h958$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h958$, $b958$(1) لحائز العقار أن يطلب خلال السنة التالية لفقدها ردها إليه. فإذا كان فقد الحيازة خفية بدأ سريان هذه السنة من وقت أن ينكشف ذلك.
(2) ويجوز أيضا أن يسترد الحيازة من كل حائز بالنيابة عن غيره.$b958$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins958;

WITH ins959 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 959, 0, $h959$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h959$, $b959$(1) إذا لم يكن من فقد الحيازة قد انقضت على حيازته سنة وقت فقده فلا يجوز أن يسترد الحيازة إلا من شخص لا يستند حيازته إلى حيازة أحق بالتفضيل. والحيازة الأحق بالتفضيل هى التى تقوم على سند قانوني. فإذا لم يكن لدى أى من الحائزين سند كانت الحيازة الأحق هى الأسبق فى التاريخ.
(2) أما إذا كان فقد الحيازة بالقوة فللحائز فى جميع الأحوال أن يسترد حيازته خلال السنة التالية من المتعدي.$b959$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins959;

WITH ins960 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 960, 0, $h960$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h960$, $b960$للحائز أن يرفع فى الميعاد القانوني دعوى استرداد الحيازة على من انتقلت إليه حيازة الشيء المغتصب حيازته ولو كان هذا الأخير حسن النية.$b960$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins960;

WITH ins961 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 961, 0, $h961$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h961$, $b961$من حاز عقارا واستمر حائزا له سنة كاملة ثم وقع له تعرض فى حيازته جاز له أن يرفع خلال السنة التالية دعوى بمنع هذا التعرض.$b961$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins961;

WITH ins962 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 962, 0, $h962$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h962$, $b962$(1) من حاز عقارا واستمر حائزا له سنة كاملة وخشى لأسباب معقولة التعرض له من جراء أعمال جديدة تهدد حيازته، كان له أن يرفع الأمر إلى القاضى طالبا وقف هذه الأعمال بشرط ألا تكون قد تمت ولم ينقض عام على البدء فى العمل الذى من شأنه أن يحدث هذا الضرر.
(2) وللقاضي أن يمنع استمرار الأعمال أو أن يأذن فى استمرارها، وفى كلتا الحالتين يجوز للقاضي أن يأمر بتقديم كفالة مناسبة تكون فى حالة الحكم بوقف الأعمال ضمانا لإصلاح الضرر الناشئ من هذا الوقف، وتكون فى حالة الحكم باستمرار الأعمال ضمانا لإزالة هذه الأعمال كلها أو بعضها إصلاحا للضرر الذى يصيب الحائز إذا حصل على حكم نهائي فى مصلحته، متى تبين بحكم نهائي أن الاعتراض على استمرارها كان على غير أساس.$b962$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins962;

WITH ins963 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 963, 0, $h963$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h963$, $b963$إذا تنازع أشخاص متعددون على حيازة حق واحد اعتبر بصفة مؤقتة أن الحائز هو من له الحيازة المادية، إلا إذا ظهر أن عقد هذه الحيازة قد حصل على هذه الحيازة بطريقة معيبة.$b963$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins963;

WITH ins964 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 964, 0, $h964$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h964$, $b964$من كان حائزا للحق اعتبر صاحبه حتى يقوم الدليل على العكس.$b964$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins964;

WITH ins965 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 965, 0, $h965$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h965$, $b965$(1) يعد حسن النية من يحوز الحق وهو يجهل أنه يعتدي على حق الغير، إلا إذا كان هذا الجهل ناشئا عن خطأ جسيم.
(2) فإذا كان الحائز شخصا معنويا اعتبر العبرة بنية من يمثله.
(3) وحسن النية يفترض دائما ما لم يقم الدليل على العكس.$b965$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins965;

WITH ins966 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 966, 0, $h966$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h966$, $b966$(1) لا تزول صفة حسن النية لدى الحائز إلا من الوقت الذى يصبح فيه عالما أن حيازته اعتداء على حق الغير.
(2) ويزول حسن النية وقت إعلان الحائز بعيوب حيازته فى صحيفة الدعوى، ويعد سيئ النية من اغتصب الحيازة بالإكراه من غيره.$b966$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins966;

WITH ins967 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 967, 0, $h967$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > حماية الحيازة (دعاوى الحيازة الثلاث)$h967$, $b967$تبقى الحيازة محتفظة بالصفة التى بدأت بها وقت كسبها، ما لم يقم الدليل على عكس ذلك.$b967$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins967;

WITH ins968 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 968, 0, $h968$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > آثار الحيازة - التقادم المكسب$h968$, $b968$من حاز منقولا أو عقارا دون أن يكون مالكا له، أو حاز حقا عينيا على منقول أو عقار دون أن يكون هذا الحق خاصا به، كان له أن يكسب ملكية الشيء أو الحق العيني إذا استمرت حيازته دون انقطاع مدة خمس عشرة سنة.$b968$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins968;

WITH ins969 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 969, 0, $h969$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > آثار الحيازة - التقادم المكسب$h969$, $b969$(1) إذا وقعت الحيازة على عقار أو على حق عيني عقاري وكانت مقترنة بحسن النية ومستندة فى الوقت ذاته إلى سبب صحيح، فإن مدة التقادم المكسب تكون خمس سنوات.
(2) ولا يشترط توافر حسن النية إلا وقت تلقي الحق.
(3) والسبب الصحيح سند يصدر من شخص لا يكون مالكا للشيء أو صاحبا للحق الذى يراد كسبه بالتقادم، ويجب أن يكون مسجلا طبقا للقانون.$b969$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins969;

WITH ins970 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 970, 0, $h970$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > آثار الحيازة - التقادم المكسب$h970$, $b970$فى جميع الأحوال لا تكسب حقوق الإرث بالتقادم إلا إذا دامت الحيازة مدة ثلاث وثلاثين سنة.
ولا يجوز تملك الأموال الخاصة المملوكة للدولة أو للأشخاص الاعتبارية العامة وكذلك أموال الوحدات الاقتصادية التابعة للمؤسسات العامة أو للهيئات العامة وشركات القطاع العام غير التابعة لأيهما والأوقاف الخيرية أو كسب أي حق عيني أو حق على هذه الأموال بالتقادم.
ولا يجوز التعدي على الأموال المشار إليها فى الفقرة السابقة وفى حالة حصول التعدي يكون للوزير المختص حق إزالته إداريا.$b970$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins970;

WITH ins971 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 971, 0, $h971$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > آثار الحيازة - التقادم المكسب$h971$, $b971$إذا ثبت قيام الحيازة فى وقت سابق معين وكانت قائمة حالا، فإن ذلك يكون قرينة على قيامها فى الزمن ما بين المدتين ما لم يقم الدليل على العكس.$b971$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins971;

WITH ins972 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 972, 0, $h972$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > آثار الحيازة - التقادم المكسب$h972$, $b972$(1) ليس لأحد أن يكسب بالتقادم على خلاف سنده. فلا يستطيع أحد أن يغير بنفسه لنفسه سبب حيازته ولا الأصل الذى تقوم عليه هذه الحيازة.
(2) ولكن يستطيع من يكسب بالتقادم إذا تغيرت صفة حيازته بفعل من الغير وأما بفعل منه يعتبر معارضة لحق المالك، ولكن فى هذه الحالة لا يبدأ سريان التقادم إلا من تاريخ هذا التغيير.$b972$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins972;

WITH ins973 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 973, 0, $h973$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > آثار الحيازة - التقادم المكسب$h973$, $b973$تسرى قواعد التقادم المسقط على التقادم المكسب فيما يتعلق بحساب المدة ووقف التقادم وانقطاعه والتمسك به أمام القضاء والتنازل عنه والاتفاق على تعديل المدة، وذلك بالقدر الذى لا تتعارض فيه هذه القواعد مع طبيعة التقادم المكسب، ومع مراعاة الأحكام الآتية:$b973$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins973;

WITH ins974 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 974, 0, $h974$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > آثار الحيازة - التقادم المكسب$h974$, $b974$أيا كانت مدة التقادم المكسب فإنه يقف متى وجد سبب الوقف.$b974$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins974;

WITH ins975 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 975, 0, $h975$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > آثار الحيازة - التقادم المكسب$h975$, $b975$(1) ينقطع التقادم المكسب إذا تخلى الحائز عن الحيازة أو فقدها بفعل الغير.
(2) غير أن التقادم لا ينقطع إذا فقد الحائز الحيازة إذا استردها الحائز خلال سنة أو رفع دعوى باستردادها فى هذا الميعاد.$b975$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins975;

WITH ins976 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 976, 0, $h976$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > تملك المنقول بالحيازة$h976$, $b976$(1) من حاز منقولا بسبب صحيح وحقا عينيا على منقول أو سندا لحامله فإنه يصبح مالكا له إذا كان حسن النية وقت حيازته.
(2) فإذا كان حسن النية والسبب الصحيح قد توفر لمن اعتبر الحائز الشيء خاليا من التكاليف والقيود العينية، فإنه يكسب الملكية خالصة منها.
(3) الحيازة فى ذاتها قرينة على وجود السبب الصحيح وحسن النية ما لم يقم الدليل على عكس ذلك.$b976$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins976;

WITH ins977 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 977, 0, $h977$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > تملك المنقول بالحيازة$h977$, $b977$(1) لمالك المنقول والسند الصحيح وحسن النية ما لم يقم الدليل على عكس ذلك.
(2) فإذا كان يوجد الشيء المسروق أو الضائع أو الشيء الذى حاز حيازته بحسن نية قد اشتراه فى مزاد علني أو من سوق أو ممن يتجر فى مثله، فإن له أن يطلب ممن يسترد منه هذا الشيء أن يجعل له الثمن الذى دفعه.$b977$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins977;

WITH ins978 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 978, 0, $h978$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > تملك الثمار بالحيازة$h978$, $b978$(1) يكسب الحائز ما يقبضه من ثمار ما دام حسن النية.
(2) والثمار الطبيعية أو المستحدثة تعتبر مقبوضة من يوم فصلها أما الثمار المدنية فتعتبر مقبوضة يوما فيوما.$b978$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins978;

WITH ins979 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 979, 0, $h979$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > تملك الثمار بالحيازة$h979$, $b979$يكون الحائز سيئ النية مسئولا من وقت أن يصبح سيئ النية عن جميع الثمار التى يقبضها والتى قصر فى قبضها. غير أنه يجوز أن يسترد ما أنفقه فى إنتاج هذه الثمار.$b979$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins979;

WITH ins980 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 980, 0, $h980$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > استرداد المصروفات$h980$, $b980$(1) على المالك الذى يرد إليه ملكه أن يؤدى إلى الحائز جميع ما أنفقه من المصروفات الضرورية.
(2) أما المصروفات النافعة فيسرى فى شأنها أحكام المادتين 924، 925.
(3) فإذا كانت المصروفات كمالية فليس للحائز أن يطالب المالك بشيء منها، ومع ذلك يجوز له أن ينزع ما استحدثه من منشآت على أن يعيد الشيء إلى حالته الأولى إلا إذا اختار المالك أن يستبقيها مقابل دفع قيمتها مستحقة الإزالة.$b980$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins980;

WITH ins981 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 981, 0, $h981$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > استرداد المصروفات$h981$, $b981$إذا تلقى شخص الحيازة من مالك أو حائز سابق وأثبت أنه أدى إلى سلفه ما أنفقه من مصروفات فإن له أن يطالب بها المالك المسترد.$b981$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins981;

WITH ins982 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 982, 0, $h982$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > استرداد المصروفات$h982$, $b982$يجوز للقاضي بناء على ما يراه مناسبا أن يقرر إلزام المالك بالوفاء بالمصروفات المنصوص عليها فى المادتين السابقتين، وله أن يقضي بأن يكون الوفاء بأقساط دورية بشرط تقديم الضمانات اللازمة. وللمالك أن يتحلل من هذا الالتزام إذا هو عجل مبلغا يوازي قيمة هذه الأقساط مخصوما منها فوائدها بالسعر القانوني لغاية مواعيد استحقاقها.$b982$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins982;

WITH ins983 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 983, 0, $h983$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > المسئولية عن الهلاك$h983$, $b983$(1) إذا كان الحائز حسن النية وانتفع بالشيء وفقا لما يحسبه من حقه، فلا يكون مسئولا مطلقا عما يصيبه من هلاك بسبب هذا الانتفاع.
(2) ولا يكون الحائز مسئولا عما يصيب الشيء من هلاك إلا بقدر ما عاد إليه من فائدة ترتبت على هذا الهلاك أو التلف.$b983$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins983;

WITH ins984 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 984, 0, $h984$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الأول - حق الملكية > الفصل الثانى - أسباب كسب الملكية > 7- الحيازة كسب الحيازة وزوالها > المسئولية عن الهلاك$h984$, $b984$إذا كان الحائز سيئ النية فإنه يكون مسئولا عن هلاك الشيء أو تلفه ولو كان ذلك ناشئا عن حادث مفاجئ، إلا إذا أثبت أن الشيء كان يهلك أو يتلف ولو كان باقيا فى يد من يستحقه.$b984$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins984;

WITH ins985 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 985, 0, $h985$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h985$, $b985$(1) حق الانتفاع يكسب بعمل قانوني أو بالتقادم.
(2) ويجوز أن يوصى بحق الانتفاع لأشخاص متعاقبين إذا كانوا موجودين على قيد الحياة وقت الوصية، كما يجوز للحمل المستكن.$b985$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins985;

WITH ins986 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 986, 0, $h986$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h986$, $b986$يراعى فى حقوق المنتفع والتزاماته السند الذى أنشأ حق الانتفاع وكذلك الأحكام المقررة فى المواد الآتية:$b986$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins986;

WITH ins987 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 987, 0, $h987$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h987$, $b987$تكون ثمار الشيء المنتفع به من حق المنتفع بنسبة مدة انتفاعه مع مراعاة أحكام الفقرة الثانية من المادة 993.$b987$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins987;

WITH ins988 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 988, 0, $h988$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h988$, $b988$(1) على المنتفع أن يستعمل الشيء بحالته التى تسلمه بها وبحسب ما أعد له وأن يديره إدارة حسنة.
(2) للمالك أن يعترض على أى استعمال غير مشروع أو غير متفق مع طبيعة الشيء، فإذا أثبت أن حقوقه فى خطر جاز له أن يطالب بتقديم تأمينات، فإن لم يقدمها المنتفع وظل على الرغم من اعتراض المالك يستعمل العين استعمالا غير مشروع أو غير متفق مع طبيعتها، فللقاضى أن ينزع هذه العين من تحت يده وأن يسلمها إلى آخر يتولى إدارتها، بل له تبعا لخطورة الحال أن يحكم بانتهاء حق الانتفاع دون إخلال بحقوق الغير.$b988$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins988;

WITH ins989 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 989, 0, $h989$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h989$, $b989$(1) المنتفع ملزم أثناء انتفاعه بكل ما يفرض على العين المنتفع بها من التكاليف المعتادة، وبكل النفقات التى تقتضيها أعمال الصيانة.
(2) أما التكاليف غير المعتادة والإصلاحات الجسيمة التى لم تنشأ عن خطأ المنتفع فإنها تكون على المالك، ويلتزم المنتفع بأن يؤدى للمالك فوائد ما أنفقه فى ذلك إذا كان المنتفع هو الذى قام بإنفاق رأس المال اللازم لها، ويكون المنتفع هو الذى يؤدى ما أنفقه فى ذلك باسترداد رأس المال عند انتهاء حق الانتفاع.$b989$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins989;

WITH ins990 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 990, 0, $h990$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h990$, $b990$(1) على المنتفع أن يبذل فى العناية بحفظ الشيء ما يبذله الشخص المعتاد.
(2) وهو مسئول عن هلاك الشيء ولو بسبب أجنبي إذا كان قد تأخر عن رده إلى صاحبه بعد انتهاء حق الانتفاع.$b990$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins990;

WITH ins991 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 991, 0, $h991$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h991$, $b991$إذا هلك الشيء أو تلف أو احتاج إلى إصلاحات جسيمة مما يجب على المالك تحمل نفقاته، أو إلى اتخاذ إجراء يقيه من خطر منظور لم يكن ضروريا، فعلى المنتفع أن يبادر بإخطار المالك وعليه إخطاره أيضا إذا استمسك أجنبي بحق يدعيه على الشيء نفسه.$b991$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins991;

WITH ins992 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 992, 0, $h992$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h992$, $b992$(1) إذا كان المال المقرر عليه حق الانتفاع منقولا، وجب جرده ولزم المنتفع تقديم كفالة به. فإن لم يقدمها المنتفع لزم جرده ووظف ثمنه فى شراء سندات عامة يستولي المنتفع على أرباحها.
(2) وللمنتفع الذى قدم الكفالة القابلة للاستهلاك أن يرد بدلها، وإنما عليه أن يعوض من نقص منها بعد انتهاء الانتفاع بحادث مفاجئ.$b992$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins992;

WITH ins993 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 993, 0, $h993$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h993$, $b993$(1) ينتهي حق الانتفاع بانقضاء الأجل المعين، فإن لم يعين له أجل عد مقررا لحياة المنتفع، وهو ينتهي على أى حال بموت المنتفع المعين.
(2) وإذا كانت الأرض المشغولة بحق الانتفاع مشغولة عند انتهاء الأجل أو موت المنتفع بزرع قائم، تركت الأرض للمنتفع أو لورثته إلى حين إدراك الزرع، على أن يدفعوا أجرة الأرض عن هذه الفترة من الزمن.$b993$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins993;

WITH ins994 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 994, 0, $h994$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h994$, $b994$(1) ينتهي حق الانتفاع بهلاك الشيء، إلا أنه ينتقل من هذا الشيء إلى ما قد يقوم مقامه من عوض.
(2) وإذا لم يكن الهلاك راجعا إلى خطأ المالك، فلا يجبر على إعادة الشيء إلى أصله، ولكنه إذا رجع الهلاك إلى خطأ المنتفع التزم بأن يعيد الشيء إذا لم يكن المالك قد أعاده، وفى هذه الحالة تطبق المادة 989 الفقرة الثانية.$b994$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins994;

WITH ins995 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 995, 0, $h995$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 1- حق الانتفاع$h995$, $b995$ينتهي حق الانتفاع بعدم الاستعمال مدة خمس عشرة سنة.$b995$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins995;

WITH ins996 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 996, 0, $h996$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 2- حق الاستعمال وحق السكنى$h996$, $b996$نطاق حق الاستعمال وحق السكنى يحدد بمقدار ما يحتاج إليه صاحب الحق هو وأسرته لخاصتهم، وذلك دون إخلال بما يقرره السند المنشئ للحق من أحكام.$b996$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins996;

WITH ins997 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 997, 0, $h997$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 2- حق الاستعمال وحق السكنى$h997$, $b997$لا يجوز النزول للغير عن حق الاستعمال أو عن حق السكنى إلا بناء على شرط صريح.$b997$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins997;

WITH ins998 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 998, 0, $h998$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الأول - حق الانتفاع وحق الاستعمال وحق السكنى > 2- حق الاستعمال وحق السكنى$h998$, $b998$فيما عدا الأحكام المتقدمة تسرى الأحكام الخاصة بحق الانتفاع على حق الاستعمال وحق السكنى متى كانت لا تتعارض مع طبيعة هذين الحقين.$b998$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins998;

WITH ins999 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 999, 0, $h999$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h999$, $b999$لا يجوز التحكير لمدة تزيد على ستين سنة، فإذا عينت مدة أطول أو أغفل تعيين المدة اعتبر الحكر معقودا لمدة ستين سنة.$b999$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins999;

WITH ins1000 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1000, 0, $h1000$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1000$, $b1000$لا يجوز التحكير إلا لضرورة أو مصلحة وبإذن من المحكمة الابتدائية الشرعية التى تقع فى دائرتها الأرض كلها أو أكثرها قيمة، ويجب أن يصدر به عقد على يد رئيس المحكمة أو من يحله محله من القضاء أو الموثقين، ويجب شهره وفقا لأحكام قانون تنظيم الشهر العقاري.$b1000$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1000;

WITH ins1001 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1001, 0, $h1001$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1001$, $b1001$للمحتكر أن يتصرف فى حقه وينتقل هذا الحق بالميراث.$b1001$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1001;

WITH ins1002 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1002, 0, $h1002$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1002$, $b1002$يملك المحتكر ما أحدثه من بناء أو غراس ملكا تاما، وله أن يتصرف فيه وحده مقترنا بحق الحكر.$b1002$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1002;

WITH ins1003 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1003, 0, $h1003$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1003$, $b1003$(1) على المحتكر أن يؤدى الأجرة المتفق عليها إلى المحكر.
(2) وتكون الأجرة مستحقة الدفع فى نهاية كل سنة ما لم ينص عقد التحكير على غير ذلك.$b1003$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1003;

WITH ins1004 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1004, 0, $h1004$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1004$, $b1004$(1) لا يجوز التحكير بأقل من أجرة المثل.
(2) وتزيد هذه الأجرة أو تنقص كلما بلغ التغيير فى أجرة المثل حدا يجوز زيادة الخمس أو نقصا، على أن يكون قد مضى ثماني سنوات على آخر تقدير.$b1004$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1004;

WITH ins1005 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1005, 0, $h1005$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1005$, $b1005$يرجع فى تقدير الزيادة أو النقص للأرض إلى ما للأرض من قيمة إيجارها وقت التقدير، ويراعى فى ذلك ما صقع الأرض ورغبات الناس فيها بغض النظر عما يوجد فيها من بناء أو غرس، ودون اعتبار لما أحدثه المحتكر فيها من تحسين أو إتلاف فى ذات الأرض أو فى صقع الجهة، ودون تأثر بما للمحتكر على الأرض من حق القرار.$b1005$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1005;

WITH ins1006 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1006, 0, $h1006$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1006$, $b1006$لا يسرى التقدير الجديد إلا من الوقت الذى يتفق الطرفان عليه، وإلا فمن يوم رفع الدعوى.$b1006$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1006;

WITH ins1007 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1007, 0, $h1007$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1007$, $b1007$على المحتكر أن يتخذ من الوسائل ما يلزم لجعل الأرض صالحة للاستغلال مراعيا فى ذلك الشروط المتفق عليها، وطبيعة الأرض، والغرض الذى أعدت له، وما يقضى به عرف الجهة.$b1007$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1007;

WITH ins1008 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1008, 0, $h1008$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1008$, $b1008$(1) ينتهي حق الحكر بحلول الأجل المعين.
(2) ومع ذلك ينتهي هذا الحق قبل حلول الأجل إذا مات المحكر قبل أن يبني أو يغرس إذا طلب جميع الورثة بقاء الحكر.
(3) وينتهي حق الحكر أيضا قبل حلول الأجل إذا زالت صفة الوقف عن الأرض المحكرة، إلا إذا كان زوال هذه الصفة بسبب رجوع الواقف فى وقفه، ففي هذه الحالة يبقى الحكر إلى انتهاء مدته.$b1008$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1008;

WITH ins1009 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1009, 0, $h1009$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1009$, $b1009$يجوز للمحكر إذا لم تدفع له الأجرة ثلاث سنين متوالية أن يطلب فسخ العقد.$b1009$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1009;

WITH ins1010 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1010, 0, $h1010$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1010$, $b1010$(1) عند فسخ العقد أو انتهائه يكون للمحكر أن يطلب إما إزالة البناء والغراس وإما استبقاءهما مقابل دفع أقل قيمتيهما مستحقتي الإزالة أو البقاء، وهذا كله ما لم يوجد اتفاق يقضي بغير ذلك.
(2) وللمحكمة أن تمهل المحكر فى الدفع إذا كانت هناك ظروف استثنائية تبرر الإمهال، وفى هذه الحالة يقدم المحكر كفالة لضمان الوفاء بما يستحق فى ذمته.$b1010$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1010;

WITH ins1011 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1011, 0, $h1011$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1011$, $b1011$ينتهي حق الحكر بعدم استعماله مدة خمس عشرة سنة، إلا إذا كان حق الحكر موقوفا فينتهي بعدم استعماله مدة ثلاثين سنة.$b1011$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1011;

WITH ins1012 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1012, 0, $h1012$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر$h1012$, $b1012$(1) من وقت العمل بهذا القانون لا يجوز ترتيب حق حكر على أرض غير موقوفة، وذلك مع عدم الإخلال بحكم المادة 1008 الفقرة الثالثة.
(2) والأحكار القائمة على أرض غير موقوفة وقت العمل بهذا القانون تسرى عليها الأحكام المبينة فى المواد السابقة.$b1012$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1012;

WITH ins1013 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1013, 0, $h1013$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر > بعض أنواع الحكر$h1013$, $b1013$(1) عقد الايجارتين هو أن يحكر الوقف أرضا عليها بناء فى حالة الإصلاح مقابل مبلغ من المال مساوي قيمة هذا البناء، وأجرة سنوية مساوية للأرض لأجر المثل.
(2) وتسرى عليه أحكام الحكر إلا فيما نصت عليه الفقرة السابقة.$b1013$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1013;

WITH ins1014 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1014, 0, $h1014$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثانى - حق الحكر > بعض أنواع الحكر$h1014$, $b1014$(1) خلو الانتفاع عقد يؤجر به الوقف عينا ولو بغير إذن القاضى مقابل أجرة ثابتة لزمن غير معين.
(2) ويلتزم المستأجر بمقتضى هذا العقد أن يجعل العين صالحة للاستعمال. ويحق للوقف أن يفسخ العقد فى أى وقت بعد التنبيه فى الميعاد القانونى طبقا للقواعد الخاصة بعقد الإيجار على شرط أن يعوض الوقف المستأجر عن النفقات طبقا لأحكام المادة 179.
(3) وتسرى عليه الأحكام الخاصة بإيجار العقارات الموقوفة دون إخلال بما نصت عليه الفقرتان السابقتان.$b1014$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1014;

WITH ins1015 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1015, 0, $h1015$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1015$, $b1015$الارتفاق حق يحد من منفعة عقار لفائدة عقار غيره يملكه شخص آخر ويجوز أن يترتب الارتفاق على مال عام إن كان لا يتعارض مع الاستعمال الذى خصص له هذا المال.$b1015$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1015;

WITH ins1016 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1016, 0, $h1016$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1016$, $b1016$(1) حق الارتفاق يكسب بعمل قانونى أو بالميراث.
(2) ولا يكسب بالتقادم إلا الارتفاقات الظاهرة بما فيها حق المرور.$b1016$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1016;

WITH ins1017 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1017, 0, $h1017$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1017$, $b1017$(1) يجوز فى الارتفاقات الظاهرة أن ترتب أيضا بتخصيص من المالك الأصلي.
(2) ويكون هناك تخصيص من المالك الأصلي إذا تبين من أى طريق للإثبات أن عقارين منفصلين قد أقام بينهما مالك واحد علامة ظاهرة من شأنها أن تدل على وجود ارتفاق لو انتقل العقاران إلى أيدى مالكين مختلفين، فأنشأ بذلك ارتفاقا مرتبا على أحد العقارين لمصلحة الآخر، فإذا انتقل هذان العقاران إلى أيدى مالكين مختلفين دون تغيير فى حالتهما، عد الارتفاق مرتبا بينهما تبعا لهذه العلاقة ما لم يوجد شرط صريح يخالف ذلك.$b1017$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1017;

WITH ins1018 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1018, 0, $h1018$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1018$, $b1018$(1) إذا فرضت قيود معينة تحد من حق مالك العقار فى البناء عليه كيف شاء كأن يمنع من تجاوز معين فى الارتفاع بالبناء أو فى مساحة رقعته، فإن هذه القيود تكون حقوق ارتفاق لفائدة العقارات التى فرضت لمصلحتها هذه القيود، هذا ما لم يكن هناك اتفاق يقضى بغيره.
(2) وكل مخالفة لهذه القيود تجوز المطالبة بإصلاحها عينا، ومع ذلك يجوز الاقتصار على الحكم بالتعويض إذا رأت المحكمة ما يبرر ذلك.$b1018$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1018;

WITH ins1019 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1019, 0, $h1019$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1019$, $b1019$تخضع حقوق الارتفاق للقواعد المقررة فى سند إنشائها ولما جرى به العرف فى الجهة وللأحكام الآتية:$b1019$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1019;

WITH ins1020 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1020, 0, $h1020$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1020$, $b1020$(1) لمالك العقار المرتفق أن يجرى من الأعمال ما هو ضروري لاستعمال حقه فى الارتفاق، وما يلزم للمحافظة عليه، وأن يستعمل هذا الحق على الوجه الذى لا ينشأ عنه إلا أقل ضرر ممكن.
(2) ولا يجوز أن يرتب على ما يجد من حاجات العقار المرتفق أى زيادة فى عبء الارتفاق.$b1020$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1020;

WITH ins1021 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1021, 0, $h1021$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1021$, $b1021$(1) لا يلزم مالك العقار المرتفق به أن يقوم بأي عمل لمصلحة العقار المرتفق إلا أن يكون عملا إضافيا يقتضيه استعمال الارتفاق على الوجه المألوف ما لم يشترط غير ذلك.
(2) فإذا كان مالك العقار المكلف به هو الذى يقوم بتلك الأعمال على نفقته، كان له دائما أن يتخلص من هذا التكليف بالتخلي عن العقار المرتفق به كله أو بعضه لمالك العقار المرتفق.
(3) وإذا كانت الأعمال نافعة أيضا لمالك العقار المرتفق به، كانت نفقة الصيانة على الطرفين كل بنسبة ما يعود عليه من الفائدة.$b1021$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1021;

WITH ins1022 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1023, 0, $h1022$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1022$, $b1022$(1) لا يجوز لمالك العقار المرتفق به أن يعمل شيئا يؤدى إلى الانتقاص من استعمال حق الارتفاق أو جعله أكثر مشقة، ولا يجوز له بوجه خاص أن يغير من الوضع القائم أصلا لاستعمال حق الارتفاق إلا أن يبذل للمالك موضعا آخر لاستعمال الارتفاق.
(2) ومع ذلك إذا كان الموضع الذى كان عين الارتفاق قد أصبح من شأنه أن يزيد فى عبء الارتفاق، أو أصبح مانعا من إحداث تحسينات فى العقار المرتفق به، فلمالك هذا العقار أن يطلب نقل الارتفاق إلى موضع آخر من العقار، أو إلى عقار آخر يملكه هو أو يملكه الغير إذا قبل هذا الأجنبي ذلك. كل هذا متى كان استعمال الارتفاق فى وضعه الجديد ميسورا للعقار المرتفق بالقدر الذى كان ميسورا به فى وضعه السابق.$b1022$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1022;

WITH ins1023 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1024, 0, $h1023$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1023$, $b1023$(1) إذا جزئ العقار المرتفق بقى الارتفاق لكل جزء منه، على ألا يزيد ذلك فى العبء الواقع على العقار المرتفق به.
(2) غير أنه إذا كان حق الارتفاق لا يفيد فى الواقع إلا جزءا من هذه الأجزاء، فلمالك العقار المرتفق به أن يطلب زوال هذا الحق عن الأجزاء الأخرى.$b1023$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1023;

WITH ins1024 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1025, 0, $h1024$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1024$, $b1024$(1) إذا جزئ العقار المرتفق به بقى حق الارتفاق واقعا على كل جزء منه.
(2) غير أنه إذا كان حق الارتفاق لا يستعمل فى الواقع فى بعض هذه الأجزاء ولا يمكن أن يستعمل عليها، فلمالك كل جزء منها أن يطلب زوال هذا الحق عن الجزء الذى يملكه.$b1024$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1024;

WITH ins1025 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1026, 0, $h1025$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1025$, $b1025$تنتهي حقوق الارتفاق بانقضاء الأجل المعين وبهلاك العقار المرتفق أو العقار المرتفق به تماما أو باجتماع العقارين تاما فى يد مالك واحد، إلا أنه إذا زالت حالة الاجتماع هذه زوالا يرجع أثره إلى الماضي فإن حق الارتفاق يعود.$b1025$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1025;

WITH ins1026 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1027, 0, $h1026$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1026$, $b1026$(1) تنتهي حقوق الارتفاق بعدم استعمالها مدة خمس عشرة سنة، فإن كان الارتفاق مقررا لمصلحة عين موقوفة كانت المدة الموقوفة ثلاثين سنة، وكما يجوز كذلك أن يعدل من الطريقة ذاتها التى يستعمل بها الارتفاق سقط حق استعماله بالتقادم بالطريقة ذاتها.
(2) وإذا ملك العقار المرتفق عدة شركاء على الشيوع فانتفاع أحدهم بالارتفاق يقطع التقادم لمصلحة الباقين، كما أن وقف التقادم لمصلحة أحد هؤلاء الشركاء يجعله موقوفا لمصلحة سائرهم.$b1026$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1026;

WITH ins1027 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1028, 0, $h1027$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1027$, $b1027$(1) ينتهي حق الارتفاق إذا تغير وضع الأشياء بحيث تصبح فى حالة لا يمكن فيها استعمال هذا الحق.
(2) ويعود إذا عادت الأشياء إلى وضع يمكن معه استعمال الحق، إلا أن يكون قد انتهى استعمال الحق بعدم الاستعمال.$b1027$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1027;

WITH ins1028 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1029, 0, $h1028$القسم الثانى - الحقوق العينية > الكتاب الثالث - الحقوق العينية الأصلية > الباب الثانى - الحقوق المتفرعة عن حق الملكية > الفصل الثالث - حق الارتفاق$h1028$, $b1028$لمالك العقار المرتفق به أن يتحرر من الارتفاق كله أو ببعضه إذا فقد الارتفاق كل منفعة للعقار المرتفق، أو لم يبق له غير فائدة محدودة لا تتناسب البتة مع الأعباء الواقعة على العقار المرتفق به.$b1028$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1028;

WITH ins1029 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1030, 0, $h1029$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى$h1029$, $b1029$الرهن الرسمي عقد به يكسب الدائن على عقار مخصص لوفاء دينه حقاً عينياً، يكون له بمقتضاه أن يتقدم على الدائنين العاديين والدائنين التالين له فى المرتبة فى استيفاء حقه من ثمن ذلك العقار فى أى يد يكون.$b1029$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1029;

WITH ins1030 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1031, 0, $h1030$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1030$, $b1030$(1) لا ينعقد الرهن إلا إذا كان بورقة رسمية.
(2) ونفقات العقد على الراهن إلا إذا اتفق على غير ذلك.$b1030$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1030;

WITH ins1031 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1032, 0, $h1031$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1031$, $b1031$(1) يجوز أن يكون الراهن هو نفس المدين كما يجوز أن يكون شخصا آخر يقدم رهنا لمصلحة المدين.
(2) وفى كلتا الحالتين يجب أن يكون الراهن مالكاً للعقار المرهون وأهلاً للتصرف فيه.$b1031$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1031;

WITH ins1032 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1033, 0, $h1032$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1032$, $b1032$(1) إذا كان الراهن غير مالك للعقار المرهون فإن عقد الرهن يصبح صحيحا إذا أقره المالك الحقيقي بورقة رسمية، وإذا لم يصدر هذا الإقرار فإن حق الرهن لا يترتب على العقار إلا من الوقت الذى يصبح فيه هذا العقار مملوكاً للراهن.
(2) ويقع باطلا رهن المال المستقبل.$b1032$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1032;

WITH ins1033 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1034, 0, $h1033$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1033$, $b1033$يبقى قائماً لمصلحة الدائن المرتهن الرهن الصادر من المالك الذى تقرر إبطال سند ملكيته أو فسخه أو إلغاؤه أو زواله لأى سبب آخر، إذا كان هذا الدائن حسن النية فى الوقت الذى أبرم فيه الرهن.$b1033$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1033;

WITH ins1034 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1035, 0, $h1034$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1034$, $b1034$(1) لا يجوز أن يرد الرهن الرسمي إلا على عقار لا يوجد نص يقضي بخلاف ذلك.
(2) ويجب أن يكون العقار المرهون مما يصح التعامل فيه ومما يصح بيعه بالمزاد العلني، وأن يكون معيناً تعييناً دقيقاً من حيث طبيعته وموقعه، وأن يرد هذا التعيين إما فى عقد الرهن ذاته أو فى عقد رسمي لاحق، وإلا وقع الرهن باطلا.$b1034$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1034;

WITH ins1035 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1036, 0, $h1035$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1035$, $b1035$يشمل الرهن ملحقات العقار المرهون التى تعتبر عقاراً، وبوجه خاص يشمل حقوق الارتفاق والعقارات بالتخصيص والتحسينات والإنشاءات التى تعود بمنفعة على المالك، ما لم يتفق على غير ذلك، مع عدم الإخلال بامتياز المبالغ المستحقة للمقاولين أو المهندسين المنصوص عليه فى المادة 1148.$b1035$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1035;

WITH ins1036 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1037, 0, $h1036$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1036$, $b1036$يترتب على تسجيل تنبيه نزع الملكية أن يلحق بالعقار ما يغله من ثمار وإيراد عن المدة التى أعقبت التسجيل، ويجرى فى توزيع هذه الغلة ما يجرى فى توزيع ثمن العقار.$b1036$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1036;

WITH ins1037 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1038, 0, $h1037$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1037$, $b1037$يجوز لمالك المبانى القائمة على أرض غير مملوكة له أن يرهنها للدائن، ويكون للدائن المرتهن فى هذه الحالة حق التقدم على سائر الدائنين فى استيفاء الدين من ثمن الأنقاض إذا هدمت المبانى، أو من الثمن الذى يدفعه مالك الأرض إذا لم يكن للدائن حق آخر وفقا للأحكام الخاصة بالالتصاق.$b1037$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1037;

WITH ins1038 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1039, 0, $h1038$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1038$, $b1038$(1) يبقى نافذاً الرهن الصادر من جميع الملاك على عقار شائع، أياً كانت النتيجة التى ترتبت على قسمة العقار سواء على قسمته عينا أو على بيعه فيما بعد لعدم إمكان قسمته.
(2) وإذا رهن أحد الشركاء حصته الشائعة فى العقار أو جزءا مفرزاً من هذا العقار، ثم وقع فى نصيبه عند القسمة أعيان غير التى رهنها، انتقل الرهن بمرتبته إلى قدر من هذه الأعيان يعادل قيمة الأعيان التى كان مرهوناً فى الأصل، ويعين هذا القدر بأمر على عريضة. ويقوم الدائن المرتهن بإجراء قيد جديد يبين فيه القدر الذى انتقل إليه الرهن خلال تسعين يوماً من الوقت الذى يخطره فيه ذو الشأن بسجل القسمة، ولا يضر انتقال الرهن على هذا الوجه بأى حق من حقوق الشركاء ولا بامتياز المتقاسمين.$b1038$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1038;

WITH ins1039 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1040, 0, $h1039$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1039$, $b1039$يجوز أن يترتب الرهن ضماناً لدين معلق على شرط أو دين مستقبل أو احتمالى، كما يجوز أن يترتب ضمانا لاعتماد مفتوح أو لفتح حساب جار على أن يتحدد عند حلول الأجل الأقصى الذى ينتهى إليه هذا الدين مبلغ الرهن المضمون.$b1039$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1039;

WITH ins1040 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1041, 0, $h1040$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1040$, $b1040$كل جزء من العقار أو العقارات المرهونة ضامن لكل الدين، وكل جزء من الدين مضموناً بالعقار أو العقارات المرهونة كلها، ما لم ينص القانون أو يقض الاتفاق بغير ذلك.$b1040$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1040;

WITH ins1041 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1042, 0, $h1041$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الأول - إنشاء الرهن$h1041$, $b1041$(1) لا ينفسخ الرهن عن الدين المضمون، بل يكون تابعاً له فى صحته وفى انقضائه، ما لم ينص القانون على غير ذلك.
(2) وإذا كان الراهن غير المدين، فله إلى جانب الدفوع الخاصة به أن يتمسك بأوجه الدفع المتعلقة بالدين، ويبقى له الحق ولو نزل عنه المدين فى أوجه الدفع التى يتمسك بها من الدين.$b1041$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1041;

WITH ins1042 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1043, 0, $h1042$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الراهن$h1042$, $b1042$يجوز للراهن أن يتصرف فى العقار المرهون وأي تصرف منه لا يؤثر فى حق الدائن المرتهن.$b1042$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1042;

WITH ins1043 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1044, 0, $h1043$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الراهن$h1043$, $b1043$للراهن الحق فى إدارة العقار المرهون وفى قبض ثماره وقت التحاقها بالعقار.$b1043$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1043;

WITH ins1044 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1045, 0, $h1044$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الراهن$h1044$, $b1044$(1) الإيجار الصادر من الراهن لا ينفذ فى حق الدائن المرتهن إلا إذا كان ثابت التاريخ قبل تسجيل تنبيه نزع الملكية. أما إذا لم يكن الإيجار ثابت التاريخ على هذا الوجه، أو كان قد عقد بعد تسجيل التنبيه ولم تعجل فيه الأجرة، فلا يكون نافذا إلا إذا أمكن إدخاله فى أعمال الإدارة الحسنة.
(2) وإذا كان الإيجار السابق على تسجيل التنبيه تزيد مدته على تسع سنوات، فلا يكون نافذا فى حق الدائن المرتهن إلا لمدة تسع سنوات ما لم يكن قد سجل قبل قيد الرهن.$b1044$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1044;

WITH ins1045 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1046, 0, $h1045$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الراهن$h1045$, $b1045$(1) لا تكون المخالصة بالأجرة مقدما لمدة لا تزيد على ثلاث سنوات ولا الحوالة بها كذلك نافذة فى حق الدائن المرتهن إلا إذا كانت ثابتة التاريخ قبل تسجيل تنبيه نزع الملكية.
(2) أما إذا كانت المخالصة أو الحوالة لمدة تزيد على ثلاث سنوات، فإنها لا تكون نافذة فى حق الدائن المرتهن ما لم تكن مسجلة قبل قيد الرهن، وإلا خفضت المدة إلى ثلاث سنوات مع مراعاة الحكم الوارد فى الفقرة السابقة.$b1045$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1045;

WITH ins1046 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1047, 0, $h1046$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الراهن$h1046$, $b1046$يلتزم الراهن بضمان سلامة الرهن. وللدائن المرتهن أن يعترض على كل عمل أو تقصير من شأنه إنقاص ضمانه، وله فى حالة الاستعجال الكبير أن يتخذ ما يلزم من الوسائل التحفظية وأن يرجع على الراهن بما ينفقه فى ذلك.$b1046$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1046;

WITH ins1047 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1048, 0, $h1047$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الراهن$h1047$, $b1047$(1) إذا تسبب الراهن بخطئه فى هلاك العقار المرهون أو تلفه، كان الدائن المرتهن مخيرا بأن يقتضي تأمينا كافيا أو أن يستوفى حقه فورا.
(2) فإذا كان الهلاك أو التلف قد نشأ عن سبب أجنبي ولم يقبل الدائن بقاء الدين بلا تأمين، كان المدين مخيرا بين أن يقدم تأمينا كافيا أو أن يوفى الدين فورا قبل حلول الأجل. وفى الحالة الأخيرة إذا لم يكن للدين فوائد كان للدائن الحق فى استيفاء مبلغ الدين منقوصا منه ما يعادل الفائدة القانونية عن المدة ما بين تاريخ الوفاء وتاريخ حلول الدين.
(3) وفى جميع الأحوال إذا وقعت أعمال من شأنها أن تعرض العقار المرهون للهلاك أو التلف، كان للدائن أن يطلب إلى القاضي وقف هذه الأعمال واتخاذ ما يلزم من الوسائل التى تمنع وقوع الضرر.$b1047$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1047;

WITH ins1048 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1049, 0, $h1048$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الراهن$h1048$, $b1048$إذا هلك العقار المرهون أو تلف لأي سبب كان، انتقل الرهن بمرتبته إلى الحق الذى يترتب على ذلك كالتعويض أو مبلغ التأمين أو الثمن الذى يتقرر نزع ملكيته مقابل المنفعة العامة.$b1048$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1048;

WITH ins1049 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1050, 0, $h1049$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الدائن المرتهن$h1049$, $b1049$إذا كان الراهن شخصا آخر غير المدين فلا يجوز التنفيذ على ماله إلا من هذا المال، ولا يكون له حق الدفع بتجريد المدين ما لم يوجد اتفاق يقضي بغير ذلك.$b1049$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1049;

WITH ins1050 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1051, 0, $h1050$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الدائن المرتهن$h1050$, $b1050$(1) للدائن بعد التنبيه على المدين بالوفاء أن ينفذ بحقه على العقار المرهون ويطلب بيعه وفقا للأوضاع المقررة فى قانون المرافعات.
(2) وإذا كان الراهن شخصا آخر غير المدين، جاز له أن يتفادى أن يجرى عليه الإجراء الموجه إليه بأن يتخلى عن العقار المرهون وفقا للأحكام التى يتبعها الحائز فى تخليه عنه.$b1050$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1050;

WITH ins1051 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1052, 0, $h1051$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 1- أثر الرهن فيما بين المتعاقدين > بالنسبة إلى الدائن المرتهن$h1051$, $b1051$(1) يقع باطلا كل اتفاق يجعل للدائن الحق عند عدم استيفاء الدين وقت حلول أجله أن يتملك العقار المرهون فى نظير ثمن معلوم أيا كان، أو أن يبيعه دون مراعاة للإجراءات التى فرضها القانون ولو كان هذا الاتفاق قد أبرم بعد الرهن.
(2) ولكن يجوز بعد حلول الدين أو قسط من الدين أن يتفق المدين الراهن مع دائنه على أن ينزل له عن العقار المرهون وفاء لدينه.$b1051$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1051;

WITH ins1052 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1053, 0, $h1052$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير$h1052$, $b1052$(1) لا يكون الرهن نافذا فى حق الغير إلا إذا قيد العقد أو الحكم المثبت للرهن قبل أن يكسب هذا الغير حقا عينيا على العقار، وذلك دون إخلال بالأحكام المقررة فى الإفلاس.
(2) لا يصح التمسك قبل الغير بتحويل حق مضمون بقيد، ولا التمسك بالحق الناشئ من حلول شخص محل دائن فى هذا الحق بحكم القانون أو الاتفاق، ولا كذلك التنازل عن مرتبة القيد لمصلحة دائن آخر إلا إذا حصل التأشير بذلك فى هامش القيد الأصلى.$b1052$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1052;

WITH ins1053 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1054, 0, $h1053$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير$h1053$, $b1053$يتبع فى إجراء القيد وتجديده ومحوه وإلغائه والآثار المترتبة على ذلك كله، الأحكام الواردة بقانون تنظيم الشهر العقاري.$b1053$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1053;

WITH ins1054 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1055, 0, $h1054$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير$h1054$, $b1054$مصروفات القيد وتجديده ومحوه على الراهن ما لم يتفق على غير ذلك.$b1054$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1054;

WITH ins1055 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1056, 0, $h1055$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1055$, $b1055$يستوفى الدائنون المرتهنون حقوقهم قبل الدائنين العاديين من ثمن العقار المرهون، أو من المال الذى حل محل هذا العقار، كل منهم بحسب مرتبة قيده ولو كانوا قد أجروا القيد فى يوم واحد.$b1055$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1055;

WITH ins1056 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1057, 0, $h1056$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1056$, $b1056$تحسب مرتبة الرهن من وقت قيده، ولو كان الدين المضمون بالرهن معلقا على شرط أو كان دينا مستقبلا أو احتماليا.$b1056$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1056;

WITH ins1057 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1058, 0, $h1057$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1057$, $b1057$(1) يترتب على قيد الرهن إدخال مصروفات العقد والقيد والتجديد إدخالا ضمنيا فى التوزيع وفى مرتبة الرهن نفسها.
(2) وإذا ذكر سعر الفائدة فى العقد فإنه يدخل قيد الرهن فى التوزيع مع أصل الدين فى نفس مرتبة الرهن وفوائد السنتين السابقتين على تسجيل تنبيه نزع الملكية والفوائد التى تستحق من هذا التاريخ إلى يوم رسو المزاد، دون مساس بالقيود الخاصة التى تؤخذ ضمانا لفوائد أخرى قد استحقت والتى تحسب مرتبتها من وقت إجرائها. وإذا سجل أحد الدائنين انتفع سائر الدائنين بهذا التسجيل.$b1057$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1057;

WITH ins1058 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1059, 0, $h1058$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1058$, $b1058$للدائن المرتهن أن ينزل عن مرتبة رهنه فى حدود الدين المضمون بالرهن لمصلحة دائن آخر له على نفس العقار رهن مقيد مرتبة أدنى، ويجوز التمسك قبل الدائن الأول بجميع أوجه الدفع التى يجوز التمسك بها قبل الدائن الآخر، عدا ما كان منها متعلقا بانقضاء حق هذا الدائن الأول إذا كان هذا الانقضاء لاحقا للتنازل.$b1058$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1058;

WITH ins1059 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1060, 0, $h1059$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1059$, $b1059$(1) يجوز للدائن المرتهن عند حلول أجل الدين أن ينزع ملكية هذا العقار أو أى حق عيني آخر له على العقار قابل للرهن دون أن يكون مسئولا شخصيا عن الدين المضمون بالرهن.$b1059$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1059;

WITH ins1060 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1061, 0, $h1060$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1060$, $b1060$يجوز للحائز عند حلول الدين المضمون بالرهن أن يقضيه هو وملحقاته بما فى ذلك ما صرف من مصروفات من وقت إنذاره، ويبقى حقه هذا قائما إلى يوم رسو المزاد. وعلى الحائز فى هذه الحالة أن يرجع بكل ما يوفيه على المدين، وعلى المالك السابق للعقار المرهون، كما يحل محل الدائن الذى استوفى حقه فيما له من حقوق وتأمينات قدمها له من ماله شخص غير المدين.$b1060$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1060;

WITH ins1061 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1062, 0, $h1061$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1061$, $b1061$يجب على الحائز أن يحتفظ بقيد الرهن الذى حل فيه محل الدائن وأن ذلك إلى أن تمحى القيود التى كانت موجودة على العقار وقت تسجيل سند هذا الحائز.$b1061$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1061;

WITH ins1062 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1063, 0, $h1062$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1062$, $b1062$(1) إذا كان فى ذمة الحائز بسبب امتلاكه العقار المرهون مبلغ مستحق الأداء حالا يكفى لوفاء جميع الدائنين المقيدة حقوقهم على العقار، فلكل من هؤلاء الدائنين أن يجبره بشرط بحقه سند ملكية.
(2) فإذا كان الدين الذى فى ذمة الحائز غير مستحق الأداء حالا، أو كان أقل من الديون المستحقة للدائنين، أو مغايرا لها، جاز للدائنين إذا اتفقوا جميعا أن يطالبوا الحائز بدفع ما فى ذمته بقدر ما هو مستحق لهم، ويكون الدفع طبقا للشروط التى التزم الحائز بها فى أصل تعهده وفى مواعيدها بمقتضى الأجل المتفق عليه فى الدفع فيه.
(3) وفى كلتا الحالتين لا يجوز للحائز أن يتخلص من التزامه بالوفاء للدائنين عن العقار، ولكن إذا هو وفى فإن العقار يعتبر خالصا من كل رهن عليه ويكون للحائز الحق فى طلب الحق فى محو القيود.$b1062$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1062;

WITH ins1063 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1064, 0, $h1063$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1063$, $b1063$(1) يجوز للحائز إذا سجل سند ملكيته أن يطهر العقار من كل رهن قيد قبل تسجيل هذا السند.
(2) وللحائز أن يستعمل هذا الحق حتى ولو وجه الدائنون المرتهنون التنبيه إلى المدين أو الإنذار إلى هذا الحائز إلى يوم إيداع قائمة شروط البيع.$b1063$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1063;

WITH ins1064 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1065, 0, $h1064$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1064$, $b1064$إذا أراد الحائز تطهير العقار وجب عليه أن يوجه إلى الدائنين المقيدة حقوقهم فى مواطنهم المختارة فى القيد إعلانات تشتمل على البيانات الآتية:
(أ) خلاصة من سند ملكية الحائز تقتصر على بيان نوع التصرف وتاريخه واسم المالك السابق للعقار مع تعيينه تعيينا دقيقا ومحل العقار مع تحديده بالدقة. وإذا كان التصرف بيعا يذكر أيضا الثمن وما يوجد من مصروفات تعتبر جزءا من هذا الثمن.$b1064$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1064;

WITH ins1065 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1066, 0, $h1065$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1065$, $b1065$(ب) تاريخ تسجيل ملكية الحائز ورقم هذا التسجيل.
(ج) المبلغ الذى يقدره الحائز قيمة للعقار ولو كان التصرف بيعا، ويجب ألا يقل هذا المبلغ عن السعر الذى يتخذ أساسا لتقدير الثمن فى حالة نزع الملكية، ولا أن يقل فى أى حال عن الباقي فى ذمة الحائز من ثمن العقار إذا كان التصرف بيعا. وإذا كانت أجزاء العقار مثقلة برهون مختلفة وجب تقدير قيمة كل جزء على حدة.
(د) قائمة بالحقوق على العقار التى قيدها قبل تسجيل سند الحائز تشتمل على بيان تاريخ هذه القيود ومقدار هذه الحقوق وأسماء الدائنين.$b1065$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1065;

WITH ins1066 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1067, 0, $h1066$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1066$, $b1066$يجب على الحائز أن يذكر فى الإعلان أنه مستعد أن يوفى الديون المقيدة إلى القدر الذى قوم به العقار، وليس عليه أن يصحب العرض بالمبلغ نقدا، وإنما ينحصر العرض فى إظهار استعداده للوفاء بمبلغ الدفع فى الحال أيا كان ميعاد استحقاق الديون المقيدة.$b1066$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1066;

WITH ins1067 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1068, 0, $h1067$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1067$, $b1067$يجوز لكل دائن قيد حقه ولكل كفيل لحق مقيد أن يطلب بيع العقار المطلوب تطهيره، ويكون ذلك فى مدى ثلاثين يوما من آخر إعلان رسمي يضاف إليها مواعيد المسافة بين الموطن الأصلى للدائن وموطنه المختار، على ألا تزيد مواعيد المسافة على ثلاثين يوما أخرى.$b1067$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1067;

WITH ins1068 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1069, 0, $h1068$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1068$, $b1068$(1) يكون الطلب بإعلان يوجه إلى الحائز وإلى المالك السابق ويوقعه الطالب أو وكيله فى ذلك توكيلا خاصا، ويجب أن يودع الطالب خزانة المحكمة مبلغا كافيا لتغطية مصروفات البيع بالمزاد، ولا يجوز أن يسترد منه ما استغرق منه مصروفات فى المزاد إذا لم يرس المزاد بثمن يزيد على المبلغ الذى عرضه الحائز إذا لم تستوف هذه الشروط.
(2) ولا يجوز للطالب أن يتنحى عن طلبه إلا بموافقة جميع الدائنين المقيدين وجميع الكفلاء.$b1068$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1068;

WITH ins1069 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1070, 0, $h1069$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1069$, $b1069$(1) إذا طلب بيع العقار وجب إتباع الإجراءات المقررة فى البيع الجبري ويتم البيع بناء على طلب صاحب المصلحة فى التعجيل، سواء كان طالبا أو حائزا. وعلى من يباشر الإجراءات أن يذكر فى إعلانات البيع المبلغ الذى قوم به العقار.
(2) ويلتزم الراسي عليه المزاد أن يرد إلى الحائز الذى نزعت ملكيته المصروفات التى أنفقها فى سند ملكيته وفى تسجيل هذا السند، وفيما قام به من الإعلانات، وذلك إلى جانب التزاماته بالثمن الذى رسا به المزاد وبالمصروفات التى اقتضتها إجراءات التطهير.$b1069$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1069;

WITH ins1070 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1071, 0, $h1070$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1070$, $b1070$إذا لم يطلب بيع العقار فى الميعاد المقرر وبالأوضاع المقررة استقرت ملكية العقار نهائيا للحائز خالصة من كل حق مقيد إذا هو دفع المبلغ الذى قوم به العقار للدائنين الذين تسمح مرتبتهم باستيفاء حقوقهم منه، أو إذا هو أودع هذا المبلغ خزانة المحكمة.$b1070$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1070;

WITH ins1071 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1072, 0, $h1071$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1071$, $b1071$(1) تكون تخلية العقار المرهون إما بتقرير يقدمه الحائز إلى قلم كتاب المحكمة الابتدائية المختصة، ويجب عليه أن يؤشر بذلك فى هامش تسجيل التنبيه بنزع الملكية، وأن يعلن الدائن المباشر لهذه الإجراءات بهذه التخلية خلال خمسة أيام من وقت التقرير بها.
(2) ويجوز لمن له مصلحة فى التعجيل أن يطلب إلى قاضى الأمور المستعجلة تعيين حارس تتخذ فى مواجهته إجراءات نزع الملكية ويعين الحائز حارسا إذا طلب ذلك.$b1071$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1071;

WITH ins1072 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1073, 0, $h1072$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1072$, $b1072$إذا لم يختر الحائز أن يقضى الديون المقيدة أو يطهر العقار من الرهن أو يتخلى عنه، فلا يجوز للدائنين المرتهنين أن يتخذوا فى مواجهته إجراءات نزع الملكية وفقا لأحكام قانون المرافعات إلا بعد إنذاره بدفع الدين المستحق أو تخلية العقار، ويكون الإنذار على الحائز بعد إنذار المدين بنزع الملكية أو مع هذا التنبيه فى وقت واحد.$b1072$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1072;

WITH ins1073 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1074, 0, $h1073$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1073$, $b1073$(1) يجوز للحائز الذى سجل سند ملكيته ولم يكن طرفا فى الدعوى التى صدر فيها حكم على المدين بالدين، أن يتمسك بأوجه الدفع التى كان للمدين أن يتمسك بها، إذا كان الحكم لاحقا لتسجيل سند الحائز.
(2) ويجوز للحائز فى جميع الأحوال أن يتمسك بالدفوع التى لا يزال للمدين بعد الحكم بالدين حق التمسك بها.$b1073$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1073;

WITH ins1074 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1075, 0, $h1074$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1074$, $b1074$يحق للحائز أن يدخل فى المزاد على شرط ألا يعرض فيه ثمنا أقل من الباقي فى ذمته من ثمن العقار الجاري بيعه.$b1074$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1074;

WITH ins1075 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1076, 0, $h1075$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1075$, $b1075$إذا نزعت ملكية العقار المرهون ولو كان ذلك بعد اتخاذ إجراءات التطهير أو التخلية ورسا المزاد على الحائز نفسه، اعتبر هذا الحائز مالكا للعقار بمقتضى سند ملكيته الأصلى، ويتطهر العقار من كل حق مقيد إذا دفع الحائز الثمن الذى رسا به المزاد أو أودعه خزانة المحكمة.$b1075$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1075;

WITH ins1076 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1077, 0, $h1076$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1076$, $b1076$إذا رسا المزاد فى الأحوال المتقدمة على شخص آخر غير الحائز، فإن هذا الشخص الآخر يتلقى الملكية عن الحائز بمقتضى حكم مرسى المزاد.$b1076$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1076;

WITH ins1077 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1078, 0, $h1077$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1077$, $b1077$يعود للحائز ما كان له قبل انتقال ملكية العقار إليه من حقوق ارتفاق وحقوق عينية أخرى.$b1077$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1077;

WITH ins1078 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1079, 0, $h1078$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1078$, $b1078$على الحائز أن يرد ثمار العقار من وقت إنذاره بالدفع أو التخلية. فإذا تركت الإجراءات مدة ثلاث سنوات، فلا يرد الثمار إلا من وقت أن يوجه إليه إنذار جديد.$b1078$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1078;

WITH ins1079 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1080, 0, $h1079$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1079$, $b1079$(1) يرجع الحائز بدعوى الضمان على المالك السابق فى الحدود التى يرجع بها من تلقى منه الملكية بمعاوضة أو تبرعا.
(2) ويرجع الحائز أيضا بما دفعه زيادة على ما هو مستحق فى ذمته من المدين بمقتضى سند ملكيته أيا كان السبب فى دفع هذه الزيادة، ويحل محل الدائنين الذين وفاهم حقوقهم. وبوجه خاص يحل محلهم فيما لهم من تأمينات قدمها لهم من ماله شخص غير المدين دون التأمينات التى قدمها المدين.$b1079$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1079;

WITH ins1080 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1081, 0, $h1080$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثانى - آثار الرهن > 2- أثر الرهن بالنسبة إلى الغير > حق التقدم وحق التتبع$h1080$, $b1080$الحائز مسئول شخصيا قبل الدائنين عما يصيب العقار من تلف بخطئه.$b1080$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1080;

WITH ins1081 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1082, 0, $h1081$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثالث - انقضاء الرهن$h1081$, $b1081$ينقضي حق الرهن الرسمي بانقضاء الدين المضمون معه ويعود هذا الحق إذا زال السبب الذى انقضى به الدين، دون إخلال بالحقوق التى يكون الغير حسن النية قد كسبها فى الفترة ما بين انقضاء الحق وعودته.$b1081$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1081;

WITH ins1082 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1083, 0, $h1082$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثالث - انقضاء الرهن$h1082$, $b1082$إذا تمت إجراءات التطهير انقضى حق الرهن الرسمي انقضاءً نهائيا، ولو زالت لأي سبب من الأسباب ملكية الحائز الذى طهر العقار.$b1082$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1082;

WITH ins1083 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1084, 0, $h1083$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الأول - الرهن الرسمى > الفصل الثالث - انقضاء الرهن$h1083$, $b1083$إذا بيع العقار المرهون بيعا جبريا بالمزاد العلني سواء كان ذلك فى مواجهة مالك العقار أو الحائز أو الحارس الذى سلم إليه العقار عند التخلية، فإن حقوق الرهن على هذا العقار تنتقل إلى الثمن الذى رسا به المزاد بإيداع هذا الثمن استيفاء لحقوقهم من هذا الثمن.$b1083$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1083;

WITH ins1084 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1085, 0, $h1084$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1084$, $b1084$(1) يجوز لكل دائن بيده حكم واجب التنفيذ صادر فى موضوع الدعوى يلزم المدين بشيء معين أن يحصل على حق اختصاص بعقارات مدينة ضمانا لأصل الدين والفوائد والمصروفات، متى كان حسن النية.
(2) ولا يجوز للدائن بعد موت المدين أخذ اختصاص على عقار فى التركة.$b1084$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1084;

WITH ins1085 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1086, 0, $h1085$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1085$, $b1085$لا يجوز الحصول على حق اختصاص بناء على حكم صادر من محكمة أجنبية، أو على قرار صادر من محكمتين إلا إذا أصبح الحكم أو القرار واجب التنفيذ.$b1085$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1085;

WITH ins1086 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1087, 0, $h1086$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1086$, $b1086$يجوز الحصول على حق اختصاص بناء على حكم يثبت صلحا أو اتفاقا تم بين الخصوم. ولكن لا يجوز الحصول على حق اختصاص بناء على حكم صادر بصحة التوقيع.$b1086$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1086;

WITH ins1087 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1088, 0, $h1087$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1087$, $b1087$لا يجوز أخذ حق الاختصاص إلا على عقار أو عقارات معينة مملوكة للمدين وقت قيد هذا الحق وجائز بيعها بالمزاد العلني.$b1087$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1087;

WITH ins1088 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1089, 0, $h1088$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1088$, $b1088$(1) على الدائن الذى يريد أخذ اختصاص على عقارات مدينة أن يقدم عريضة بذلك إلى رئيس المحكمة الابتدائية التى تقع فى دائرتها العقارات التى يريد الاختصاص بها.
(2) وهذه العريضة يجب أن تكون مصحوبة بصورة رسمية من الحكم أو بشهادة من قلم الكتاب بمنطوق الحكم، وأن تشتمل على البيانات الآتية:
(أ) اسم الدائن ولقبه وصناعته وموطنه الأصلى والموطن المختار الذى يعينه فى البلدة التى يقع فيها مقر المحكمة.
(ب) اسم المدين ولقبه وصناعته وموطنه.
(ج) تاريخ الحكم وبيان المحكمة التى أصدرته.
(د) مقدار الدين، فإذا كان الحكم المذكور غير محدد المقدار، تولى رئيس المحكمة تقديره مؤقتا وعين المبلغ الذى يؤخذ به حق الاختصاص.
(هـ) تعيين العقارات تعيينا دقيقا وبيان موقعها مع تقديم الأوراق الدالة على قيمتها.$b1088$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1088;

WITH ins1089 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1090, 0, $h1089$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1089$, $b1089$(1) يدون رئيس المحكمة فى ذيل العريضة أمره بالاختصاص.
(2) وإنما يجب عليه عند الترخيص أن يراعى أن يكون مقدار الدين وقيمة العقارات المبينة بالعريضة متقاربين بوجه التقريب، وعند الاقتضاء يجعل الاختصاص مقصورا على بعض هذه العقارات أو على واحد منها فقط أو على جزء من أحدها إذا رأى أن ذلك كاف لتأمين دفع أصل الدين والفوائد والمصروفات المستحقة للدائنين.$b1089$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1089;

WITH ins1090 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1091, 0, $h1090$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1090$, $b1090$على قلم الكتاب إعلان الأمر الصادر بالاختصاص إلى المدين فى نفس اليوم الذى يصدر فيه هذا الأمر، وعليه أيضا أن يؤشر بهذا الأمر على صورة الحكم أو على الشهادة المرفقة بالطلب المقدم لأخذ الاختصاص، وأن يخطر قلم كتاب المحكمة الصادر منها الحكم بالتأشير بذلك على كل شهادة أخرى يسلمها للدائن.$b1090$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1090;

WITH ins1091 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1092, 0, $h1091$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1091$, $b1091$(1) يجوز للمدين أن يتظلم من الأمر الصادر بالاختصاص أمام الأمر الذى يصدر فيه الأمر، كما يجوز له أن يرفع هذا التظلم إلى المحكمة الابتدائية.
(2) ويجب أن يؤشر على هامش القيد بكل قرار أو حكم قضى بإلغاء الأمر الصادر بالاختصاص.$b1091$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1091;

WITH ins1092 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1093, 0, $h1092$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الأول - إنشاء حق الاختصاص$h1092$, $b1092$إذا رفض رئيس المحكمة طلب الاختصاص المقدم من الدائن، سواء كان الرفض من بادئ الأمر أو بعد تظلم المدين، جاز للدائن أن يتظلم من أمر الرفض إلى المحكمة الابتدائية.$b1092$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1092;

WITH ins1093 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1094, 0, $h1093$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الثانى - آثار حق الاختصاص وإنقاصه وانقضاؤه$h1093$, $b1093$(1) يجوز لكل ذي مصلحة أن يطلب إنقاص الاختصاص إلى الحد المناسب إذا كانت الأعيان التى رتب عليها هذا الحق تزيد قيمتها على ما يكفى لضمان الدين.
(2) ويكون إنقاص الاختصاص إما بقصره على جزء من العقار أو العقارات التى رتب عليها، أو بنقله إلى عقار آخر تكون قيمته كافية لضمان الدين.
(3) والمصروفات اللازمة لإجراء الإنقاص ولو تم بموافقة الدائن على طلب الإنقاص تكون على من طلب الإنقاص.$b1093$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1093;

WITH ins1094 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1095, 0, $h1094$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثانى - حق الاختصاص > الفصل الثانى - آثار حق الاختصاص وإنقاصه وانقضاؤه$h1094$, $b1094$يكون للدائن الذى حصل على حق الاختصاص نفس الحقوق التى يحصل عليها الدائن الذى حصل على رهن رسمي، ويسرى على الاختصاص ما يسرى على الرهن الرسمي من أحكام وبخاصة ما يتعلق بتجديده ومحوه وعدم تجزئة الحق وأثره وانقضائه، وذلك كله مع عدم الإخلال بما ورد بأحكام خاصة.$b1094$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1094;

WITH ins1095 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1096, 0, $h1095$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى$h1095$, $b1095$الرهن الحيازى عقد به يلتزم شخص ضمانا لدين عليه أو على غيره، أن يسلم إلى الدائن أو إلى أجنبي يعينه المتعاقدان شيئا يرتب عليه للدائن حقا عينيا يخوله حبس الشيء لحين استيفاء الدين، وأن يتقدم الدائنين العاديين والدائنين التالين له فى المرتبة فى اقتضاء حقه من ثمن هذا الشيء فى أى يد يكون.$b1095$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1095;

WITH ins1096 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1097, 0, $h1096$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى$h1096$, $b1096$لا يكون محلا للرهن الحيازى إلا ما يمكن بيعه استقلالا بالمزاد العلني من منقول وعقار.$b1096$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1096;

WITH ins1097 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1098, 0, $h1097$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى$h1097$, $b1097$تسرى على الرهن الحيازى أحكام المادة 1033 وأحكام المواد من 1040 إلى 1042 المتعلقة بالرهن الرسمي.$b1097$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1097;

WITH ins1098 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1099, 0, $h1098$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الراهن$h1098$, $b1098$(1) على الراهن تسليم الشيء المرهون إلى الدائن أو إلى الشخص الذى عينه المتعاقدان لتسلمه.
(2) ويسرى على الالتزام بتسليم الشيء المرهون أحكام الالتزام بتسليم الشيء المبيع.$b1098$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1098;

WITH ins1099 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1100, 0, $h1099$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الراهن$h1099$, $b1099$إذا رجع المرهون إلى حيازة الراهن انقضى الرهن، إلا إذا أثبت الدائن المرتهن أن الرجوع لا يقصد به انقضاء الرهن. كل هذا دون إخلال بحقوق الغير.$b1099$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1099;

WITH ins1100 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1101, 0, $h1100$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الراهن$h1100$, $b1100$يضمن الراهن سلامة الرهن ونفاذه وليس له أن يأتي عملا من شأنه أن ينقص من قيمة الشيء المرهون أو يحول دون استعمال الدائن لحقوقه المستمدة من العقد، وللدائن المرتهن فى حالة الاستعجال أن يتخذ على نفقة الراهن كل الوسائل التى تلزم للمحافظة على الشيء المرهون.$b1100$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1100;

WITH ins1101 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1102, 0, $h1101$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الراهن$h1101$, $b1101$(1) يضمن الراهن هلاك الشيء المرهون أو تلفه إذا كان الهلاك أو التلف راجعا إلى خطئه أو ناشئا عن قوة قاهرة.
(2) وتسرى على الرهن الحيازى أحكام المادتين 1048 و1049 المتعلقة بهلاك الشيء المرهون رهنا رسميا، وبانتقال حق الدائن من الشيء المرهون إلى ما حل محله.$b1101$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1101;

WITH ins1102 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1103, 0, $h1102$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الدائن المرتهن$h1102$, $b1102$إذا تسلم الدائن المرتهن الشيء المرهون فعليه أن يبذل فى حفظه وصيانته من العناية ما يبذله الشخص المعتاد، وهو مسئول عن هلاك الشيء أو تلفه ما لم يثبت أن ذلك راجع إلى سبب لا يد له فيه.$b1102$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1102;

WITH ins1103 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1104, 0, $h1103$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الدائن المرتهن$h1103$, $b1103$(1) ليس للدائن أن ينتفع بالشيء المرهون دون مقابل.
(2) وعليه أن يستثمره كاملا ما لم يتفق على غير ذلك.
(3) وما حصل عليه الدائن من صافى الريع وما استفاده من استعمال الشيء المرهون يخصم من المبلغ المضمون ولو لم يكن قد حل أجله، على أن يكون الخصم أولا على ما أنفقه من المحافظة على الشيء وفى الإصلاحات، ثم من المصروفات والفوائد، ثم من أصل الدين.$b1103$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1103;

WITH ins1104 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1105, 0, $h1104$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الدائن المرتهن$h1104$, $b1104$(1) إذا كان الشيء المرهون ينتج ثمارا أو إيرادا واتفق الطرفان على أن يجعل ذلك كله فى مقابل الفوائد، كان هذا الاتفاق نافذا فى حدود أقصى ما يسمح به القانون من الفوائد الاتفاقية.
(2) فإذا لم يتفق الطرفان على أن تجعل الثمار فى مقابل الفوائد وسكتا عن تحديد سعر الفائدة، حسبت الفائدة على أساس السعر القانوني دون أن تجاوز قيمة الثمار. فإذا لم يعينا ميعادا لحلول الدين المضمون فلا يجوز للدائن أن يطالب باستيفاء حقه من طريق استنزاله من قيمة الثمار، دون إخلال بحق المدين فى الوفاء بالدين فى أى وقت أراد.$b1104$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1104;

WITH ins1105 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1106, 0, $h1105$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الدائن المرتهن$h1105$, $b1105$(1) يتولى الدائن المرتهن إدارة الشيء المرهون، وعليه أن يبذل فى ذلك من العناية ما يبذله الرجل المعتاد، وليس له أن يغير من طريقة استغلال الشيء المرهون إلا برضاء الراهن، ويجب عليه أن يبادر بإخطار الراهن عن كل أمر يقتضي تدخله.$b1105$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1105;

WITH ins1106 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1107, 0, $h1106$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الدائن المرتهن$h1106$, $b1106$يرد الدائن الشيء المرهون إلى الراهن بعد أن يستوفى كامل حقه، وما يتصل بالحق من ملحقات ومصروفات وتعويضات.$b1106$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1106;

WITH ins1107 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1108, 0, $h1107$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 1- فيما بين المتعاقدين > التزامات الدائن المرتهن$h1107$, $b1107$يسرى على رهن الحيازة أحكام المادة 1050 المتعلقة بمسئولية الراهن غير المدين وأحكام المادة 1052 المتعلقة بعدم التملك بشرط الوفاء وشرط البيع دون إجراءات.$b1107$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1107;

WITH ins1108 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1109, 0, $h1108$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 2- بالنسبة إلى الغير$h1108$, $b1108$(1) يجب لنفاذ الرهن فى حق الغير أن يكون الشيء المرهون فى يد الدائن المرتهن أو فى يد الأجنبي الذى ارتضاه المتعاقدان.
(2) ويجوز أن يكون الشيء المرهون ضامنا لعدة ديون.$b1108$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1108;

WITH ins1109 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1110, 0, $h1109$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 2- بالنسبة إلى الغير$h1109$, $b1109$(1) يخول الرهن الدائن المرتهن الحق فى حبس الشيء المرهون فى مواجهة كافة الناس، دون إخلال بما للغير من حقوق وفقا لما يحفظها القانون.
(2) وإذا خرج الشيء من يد الدائن دون إرادته أو دون علمه كان له أن يسترد حيازته من الغير وفقا لأحكام الحيازة.$b1109$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1109;

WITH ins1110 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1111, 0, $h1110$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثانى - آثار رهن الحيازة > 2- بالنسبة إلى الغير$h1110$, $b1110$لا يقتصر الرهن الحيازى على ضمان الحق وإنما يضمن أيضا فى نفس المرتبة ما يأتي:
(أ) المصروفات الضرورية التى أنفقت للمحافظة على الشيء.
(ب) التعويضات عن الأضرار الناشئة من عيوب الشيء.
(ج) مصروفات العقد الذى أنشأ عقد الرهن الحيازى ومصروفات قيده عند الاقتضاء.
(د) المصروفات التى اقتضاها تنفيذ الرهن الحيازى.
(هـ) جميع الفوائد المستحقة مع مراعاة ما جاء فى المادة 230.$b1110$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1110;

WITH ins1111 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1112, 0, $h1111$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثالث - انقضاء الرهن الحيازى$h1111$, $b1111$ينقضي حق الرهن الحيازى بانقضاء الدين المضمون معه ويعود إذا زال السبب الذى انقضى به الدين، دون إخلال بالحقوق التى يكون الغير حسن النية قد كسبها قانونا فى الفترة ما بين انقضاء الحق وعودته.$b1111$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1111;

WITH ins1112 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1113, 0, $h1112$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الثالث - انقضاء الرهن الحيازى$h1112$, $b1112$ينقضي أيضا الرهن الحيازى بأحد الأسباب الآتية:
(أ) إذا نزل الدائن عن هذا الحق وكان ذا أهلية فى إبراء ذمة المدين من الدين، ويجوز أن يستفاد التنازل ضمنا من تخلى الدائن باختياره عن الشيء المرهون أو من موافقته على التصرف فيه دون تحفظ، على أنه إذا كان الرهن مثقلا بحق تقرر لمصلحة الغير، فإن تنازل الدائن لا ينفذ فى حق هذا الغير إلا إذا أقره.
(ب) إذا اجتمع حق الرهن الحيازى مع حق الملكية فى يد شخص واحد.
(ج) إذا هلك الشيء أو انقضى الحق المرهون.$b1112$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1112;

WITH ins1113 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1114, 0, $h1113$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 1- الرهن العقاري$h1113$, $b1113$يشترط لنفاذ الرهن العقاري فى حق الغير إلى جانب انتقال الحيازة أن يقيد عقد الرهن، وتسرى على هذا القيد الأحكام الخاصة بقيد الرهن الرسمى.$b1113$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1113;

WITH ins1114 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1115, 0, $h1114$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 1- الرهن العقاري$h1114$, $b1114$يجوز للدائن المرتهن لعقار أن يؤجر العقار إلى الراهن دون أن يمنع ذلك من نفاذ الرهن فى حق الغير. أما إذا اتفق على الإيجار فى عقد الرهن وجب ذكر ذلك فى القيد الذى يوجب عنه، إلا أن هذا التأشير لا يكون ضروريا إذا جدد الإيجار تجديدا ضمنيا.$b1114$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1114;

WITH ins1115 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1116, 0, $h1115$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 1- الرهن العقاري$h1115$, $b1115$(1) على الدائن المرتهن لعقار أن يتعهد العقار بالصيانة وأن يقوم بالنفقات اللازمة لحفظه، وأن يدفع ما يستحق سنويا من ضرائب وتكاليف، على أن يستنزل من الثمار التى يحصلها ما أنفق أو يستوفى هذه القيمة من ثمن العقار فى المرتبة التى يخولها له القانون.
(2) ويجوز للدائن أن يتحلل من هذه الالتزامات إذا هو تخلى عن حق الرهن.$b1115$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1115;

WITH ins1116 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1117, 0, $h1116$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 2- رهن المنقول$h1116$, $b1116$يشترط لنفاذ رهن المنقول فى حق الغير إلى جانب انتقال الحيازة أن يدون العقد فى ورقة ثابتة التاريخ يبين فيها المبلغ المضمون بالرهن والعين المرهونة بيانا كافيا - وهذا التاريخ الثابت يحدد مرتبة الدائن المرتهن.$b1116$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1116;

WITH ins1117 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1118, 0, $h1117$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 2- رهن المنقول$h1117$, $b1117$(1) الأحكام المتعلقة بالآثار التى تترتب على حيازة المنقولات المادية والسندات لحاملها تسرى أيضا على رهن المنقول.
(2) وبوجه خاص يكون للمرتهن إذا كان حسن النية أن يتمسك بحقه فى الشيء المرهون ولو كان الراهن لا يملك التصرف فى الشيء المرهون، كما يجوز لحائز اكتسب الشيء المرهون من جهة حائز حسن النية أن يتمسك بالحق الذى كسبه على الشيء المرهون ولو كان ذلك لاحقا لتاريخ حق الدائن المرتهن.$b1117$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1117;

WITH ins1118 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1119, 0, $h1118$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 2- رهن المنقول$h1118$, $b1118$(1) إذا كان الشيء المرهون مهددا بالهلاك أو التلف أو نقص القيمة بحيث يخشى ألا يصبح كافيا لضمان حق الدائن، ولم يطلب الراهن رده أو يقدم له شيئا آخر بدلا منه، جاز للدائن أو للراهن أن يطلب من القاضى الترخيص فى بيعه بالمزاد العلني أو بسعره فى البورصة أو السوق.
(2) ويفصل القاضي فى أمر إيداع الثمن عند الترخيص فى البيع. وينتقل حق الدائن فى هذه الحالة من الشيء إلى ثمنه.$b1118$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1118;

WITH ins1119 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1120, 0, $h1119$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 2- رهن المنقول$h1119$, $b1119$يجوز للراهن إذا عرضت فرصة لبيع الشيء المرهون وكان البيع صفقة رابحة، أن يطلب من القاضى الترخيص فى بيع هذا الشيء، ولو كان ذلك قبل حلول أجل الدين، ويحدد القاضى عند الترخيص شروط البيع ويفصل فى أمر إيداع الثمن.$b1119$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1119;

WITH ins1120 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1121, 0, $h1120$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 2- رهن المنقول$h1120$, $b1120$(1) يجوز للدائن المرتهن إذا لم يستوف حقه أن يطلب من القاضى الترخيص له فى بيع المرهون بالمزاد العلني أو بسعره فى البورصة أو السوق.
(2) ويجوز له أيضا أن يطلب من القاضى أن يأمر بتمليكه الشيء وفاء للدين على أن يحسب عليه بقيمته بحسب تقدير الخبراء.$b1120$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1120;

WITH ins1121 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1122, 0, $h1121$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 2- رهن المنقول$h1121$, $b1121$تسرى الأحكام المتقدمة بالقدر الذى لا تتعارض فيه مع أحكام القوانين التجارية والأحكام الخاصة ببيوت التسليف المرخص لها فى الرهن وأحكام القوانين واللوائح الخاصة بأحوال خاصة فى رهن المنقول.$b1121$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1121;

WITH ins1122 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1123, 0, $h1122$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 3- رهن الدين$h1122$, $b1122$(1) لا يكون رهن الدين نافذا فى حق المدين فيه إلا بإعلان هذا الرهن إليه أو بقبوله له وفقا للمادة 305.
(2) ولا يكون نافذا فى حق الغير إلا بحيازة المرتهن لسند الدين المرهون، وتحسب للرهن مرتبته من التاريخ الثابت للإعلان أو القبول.$b1122$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1122;

WITH ins1123 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1124, 0, $h1123$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 3- رهن الدين$h1123$, $b1123$السندات الاسمية والسندات الاذنية يتم رهنها بالطريقة التى رسمها القانون لحوالة هذه السندات على أن يذكر أن الحوالة قد تمت على سبيل الرهن، ويتم الرهن دون حاجة إلى إعلان.$b1123$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1123;

WITH ins1124 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1125, 0, $h1124$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 3- رهن الدين$h1124$, $b1124$إذا كان الدين غير قابل للحوالة أو للحجز فلا يجوز رهنه.$b1124$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1124;

WITH ins1125 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1126, 0, $h1125$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 3- رهن الدين$h1125$, $b1125$(1) للدائن المرتهن أن يستولى على الفوائد المستحقة عن الدين المرهون والتى تحل بعد الرهن، وكذلك له أن يستولى على كل الاستحقاقات الدورية التى لهذا الدين على أن يخصم ما يستولى عليه من المصروفات ثم من الفوائد ثم من أصل الدين المضمون بالرهن، كل هذا ما لم يتفق على غير ذلك.
(2) ويلتزم الدائن المرتهن بالمحافظة على الدين المرهون، فإذا كان له أن يقتضى شيئا من هذا الدين دون تدخل من الراهن، كان عليه أن يقتضيه فى الزمان والمكان المعينين للاستيفاء وأن يبادر بإخطار الراهن بذلك.$b1125$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1125;

WITH ins1126 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1127, 0, $h1126$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 3- رهن الدين$h1126$, $b1126$يجوز للمدين فى الدين المرهون أن يتمسك قبل الدائن المرتهن بأوجه الدفع المتعلقة بصحة الحق المضمون بالرهن، وكذلك بأوجه الدفع التى تكون له قبل دائنه الأصلي، كل ذلك بالقدر الذى يجوز فيه للمدين أن يتمسك بهذه الدفوع فى حالة الحوالة قبل المحال إليه.$b1126$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1126;

WITH ins1127 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1128, 0, $h1127$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 3- رهن الدين$h1127$, $b1127$(1) إذا حل الدين المرهون قبل حلول الدين المضمون بالرهن، فلا يجوز للمدين أن يوفى الدين المرهون إلا للمرتهن والراهن معا، ولكن لكل من هذين أن يطلب إلى المدين إيداع ما يؤديه، وينتقل حق الرهن إلى ما تم إيداعه.
(2) وعلى المرتهن والراهن أن يتعاونا على استغلال ما أداه المدين على أنفع وجه يكون ذلك فيه للراهن دون ضرر فيه للدائن المرتهن، مع المبادرة إلى إنشاء رهن جديد لمصلحة هذا الدائن.$b1127$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1127;

WITH ins1128 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1129, 0, $h1128$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الثالث - الرهن الحيازى > الفصل الرابع - بعض أنواع الرهن الحيازى > 3- رهن الدين$h1128$, $b1128$إذا أصبح كل من الدين المرهون والدين المضمون بالرهن مستحق الأداء، جاز للدائن المرتهن إذا لم يستوف حقه أن يقبض من الدين المرهون ما يكون مستحقا له أو أن يطلب تمليكه وفقا للمادة 1121 الفقرة الثانية.$b1128$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1128;

WITH ins1129 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1130, 0, $h1129$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الأول - أحكام عامة$h1129$, $b1129$(1) الامتياز أولوية يقررها القانون لحق معين مراعاة منه لصفته.
(2) ولا يكون للامتياز إلا بمقتضى نص فى القانون.$b1129$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1129;

WITH ins1130 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1131, 0, $h1130$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الأول - أحكام عامة$h1130$, $b1130$(1) مرتبة الامتياز يحددها القانون، فإذا لم ينص صراحة على مرتبة امتياز، كان هذا الحق متأخرا فى المرتبة عن كل امتياز ورد فى هذا الباب.
(2) وإذا كانت الحقوق الممتازة فى مرتبة واحدة، فإنها تستوفى بنسبة قيمة كل منها ما لم يقض بغير ذلك.$b1130$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1130;

WITH ins1131 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1132, 0, $h1131$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الأول - أحكام عامة$h1131$, $b1131$ترد حقوق الامتياز العامة على جميع أموال المدين من منقول وعقار. أما حقوق الامتياز الخاصة فتكون مقصورة على منقول أو عقار معين.$b1131$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1131;

WITH ins1132 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1133, 0, $h1132$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الأول - أحكام عامة$h1132$, $b1132$(1) لا يحتج بحق الامتياز على حائز المنقول بحسن نية.
(2) ويعتبر حائزا فى حكم هذه المادة بالنسبة إلى المنقولات الموجودة فى العين المؤجرة مؤجر العقار، وصاحب الفندق بالنسبة إلى الأمتعة التى يودعها النزلاء فى فندقه.
(3) وإذا خشى الدائن لأسباب معقولة تبديد المنقول المثقل بحق امتياز، جاز لمصلحته أن يطلب وضعه تحت الحراسة.$b1132$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1132;

WITH ins1133 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1134, 0, $h1133$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الأول - أحكام عامة$h1133$, $b1133$(1) تسرى على حقوق الامتياز الواقعة على عقار، أحكام الرهن الرسمي، بالقدر الذى لا تتعارض فيه مع طبيعة هذه الحقوق. وتسرى بنوع خاص أحكام التطهير والقيد وما يترتب على القيد من آثار وما يتصل به من تجديد ومحو.
(2) ومع ذلك فإن حقوق الامتياز العامة ولو كان محلها عقارا لا يجب الشهر فيها، ولا يثبت فيها حق التتبع، ولا حاجة للشهر أيضا فى حقوق الامتياز العقارية الضامنة لمبالغ مستحقة للخزانة العامة. وهذه الحقوق الممتازة جميعا تكون أسبق فى المرتبة على أى امتياز عقاري آخر، وعلى أى حق رهن رسمي مهما كان تاريخ قيده، أما فيما بينها فالامتياز الضامن للمبالغ المستحقة للخزانة العامة يتقدم على حقوق الامتياز العامة.$b1133$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1133;

WITH ins1134 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1135, 0, $h1134$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الأول - أحكام عامة$h1134$, $b1134$يسرى على الامتياز ما يسرى على الرهن الرسمي من أحكام متعلقة بهلاك الشيء أو تلفه.$b1134$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1134;

WITH ins1135 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1136, 0, $h1135$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الأول - أحكام عامة$h1135$, $b1135$ينقضي حق الامتياز بنفس الطرق التى ينقضي بها حق الرهن الرسمي وحق الرهن الحيازى ووفقا لأحكام انقضاء هذين الحقين، ما لم يوجد نص خاص يقضي بغير ذلك.$b1135$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1135;

WITH ins1136 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1137, 0, $h1136$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة$h1136$, $b1136$الحقوق المبينة فى المواد الآتية تكون ممتازة إلى جانب حقوق الامتياز المقررة بنصوص خاصة.$b1136$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1136;

WITH ins1137 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1138, 0, $h1137$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1137$, $b1137$(1) المصروفات القضائية التى أنفقت لمصلحة جميع الدائنين فى حفظ أموال المدين وبيعها، لها امتياز على ثمن هذه الأموال.
(2) وتستوفى هذه المصروفات قبل أى حق آخر كان ممتازا ولو كان مضمونا برهن رسمي بما فى ذلك حقوق الدائنين الذين أنفقت المصروفات فى مصلحتهم فى بيع الأموال، على أن تتقدم المصروفات التى أنفقت على حفظ تلك الأموال على المصروفات التى أنفقت على إجراءات التوزيع.$b1137$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1137;

WITH ins1138 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1139, 0, $h1138$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1138$, $b1138$(1) المبالغ المستحقة للخزانة العامة من ضرائب وحقوق ورسوم أخرى من أى نوع كان، يكون لها امتياز بالشروط المقررة فى القوانين والأوامر الصادرة فى هذا الشأن.
(2) وتستوفى هذه المبالغ من ثمن الأموال المثقلة بهذا الامتياز بأية يد كانت ولو كان ممتازا أو مضمونا برهن رسمي عدا المصروفات القضائية.$b1138$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1138;

WITH ins1139 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1140, 0, $h1139$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1139$, $b1139$(1) المبالغ التى صرفت فى حفظ المنقول وفيما يلزم له من ترميم يكون لها امتياز عليه كله.
(2) وتستوفى هذه المبالغ من ثمن المنقول المثقل بهذا الامتياز بعد المصروفات القضائية والمبالغ المستحقة للخزانة العامة، أما فيما بينها فيقدم بعضها على بعض بحسب الترتيب العكسي لتواريخ صرفها.$b1139$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1139;

WITH ins1140 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1141, 0, $h1140$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1140$, $b1140$(1) يكون للحقوق الآتية امتياز على جميع أموال المدين من منقول وعقار:
(أ) المبالغ المستحقة للخدم والكتبة والعمال وكل أجير آخر.
(ب) المبالغ المستحقة عما تم توريده للمدين ولمن يعوله من مأكل وملبس فى الستة الأشهر الأخيرة.
(ج) النفقة المستحقة فى ذمة المدين لأقاربه عن ستة الأشهر الأخيرة.
(2) وتستوفى هذه المبالغ مباشرة بعد المصروفات القضائية والمبالغ المستحقة للخزانة العامة، أما فيما بينها فتستوفى بنسبة كل منها.$b1140$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1140;

WITH ins1141 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1142, 0, $h1141$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1141$, $b1141$(1) المبالغ المنصرفة فى البذور والسماد وغيره من مواد التخصيب والمواد المقاومة للحشرات والمبالغ المنصرفة فى أعمال الزراعة والحصاد للمحصول الذى صرفت فى إنتاجه يكون لها امتياز على هذا المحصول.
(2) وتستوفى هذه المبالغ من ثمن المحصول مباشرة بعد الحقوق المتقدمة الذكر.
(3) وكذلك يكون للمبالغ المستحقة فى مقابل آلات الزراعة حق امتياز فى نفس المرتبة على هذه الآلات.$b1141$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1141;

WITH ins1142 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1143, 0, $h1142$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1142$, $b1142$(1) أجرة المباني والأراضي الزراعية لسنتين أو لمدة الإيجار إن قلت عن ذلك، وكل حق آخر للمؤجر بمقتضى عقد الإيجار، يكون لها جميعا امتياز على كل منقول قابل للحجز موجود بالعين المؤجرة ومملوك للمستأجر ومن محصول زراعي.
(2) ويثبت الامتياز ولو كانت المنقولات المثقلة مملوكة لزوجة المستأجر أو كانت مملوكة للغير إذا لم يثبت أن المؤجر كان وقت وضعها فى العين المؤجرة يعلم بوجود حق للغير عليها، وذلك دون إخلال بالأحكام المتعلقة بالمنقولات المسروقة أو الضائعة.
(3) ويقع الامتياز أيضا على المنقولات والمحصولات المملوكة للمستأجر من الباطن إذا كان المؤجر قد اشترط صراحة عدم الإيجار من الباطن، فإذا لم يشترط ذلك فلا يثبت الامتياز إلا للمبالغ التى تكون مستحقة للمستأجر الأصلى فى ذمة المستأجر من الباطن من الوقت الذى ينذره المؤجر فيه.
(4) وتستوفى هذه المبالغ الممتازة من ثمن الأموال المثقلة بالامتياز بعد الحقوق المتقدمة الذكر، إلا ما كان من هذه الحقوق غير نافذ فى حق المؤجر باعتباره حائزا حسن النية.
(5) وإذا نقلت الأموال المثقلة بالامتياز من العين المؤجرة على الرغم من معارضة المؤجر أو على غير علم منه ولم يبق فى العين ما يكفى لضمان الحقوق الممتازة، بقى الامتياز قائما على الأموال التى نقلت دون أن يضر ذلك بالحق الحسن النية الذى كسبه الغير على هذه الأموال، ويبقى الامتياز قائما ولو أضر بحق الغير إذا نقلها لمدة ثلاث سنوات من يوم أوقع المؤجر عليها حجزا تحفظيا فى المواعيد القانونية. ومع ذلك إذا بيعت هذه الأموال إلى مشتري حسن النية فى سوق عام أو فى مزاد علني أو ممن يتجر فى مثلها، وجب على المؤجر أن يرجع على المدين دون أن يرد إلى هذا المشترى الثمن الذى دفعه.$b1142$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1142;

WITH ins1143 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1144, 0, $h1143$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1143$, $b1143$(1) المبالغ المستحقة لصاحب الفندق فى ذمة النزيل عن أجرة الإقامة والمؤونة وما أحضره النزيل فى الفندق أو ملحقاته يكون لها امتياز على أمتعة هذا النزيل الموجودة فى الفندق أو ملحقاته.
(2) ويقع الامتياز على الأمتعة ولو كانت غير مملوكة للنزيل إذا لم يثبت أن صاحب الفندق كان عند إدخالها عنده يعلم بحق الغير عليها، وذلك دون إخلال بالأحكام المتعلقة بالأمتعة المسروقة أو الضائعة. ولصاحب الفندق أن يعارض فى نقل الأمتعة من فندقه مادام لم يستوف حقه كاملا، فإذا نقلت الأمتعة رغم معارضته أو دون علمه، بقى حق الامتياز قائما عليها دون إخلال بالحقوق الحسنة النية التى كسبها الغير.
(3) ولا يمتاز صاحب الفندق على المنقولات التى لامتياز المؤجر عليها مرتبة أسبق، فإذا تزاحما قدم الأسبق فى التاريخ.$b1143$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1143;

WITH ins1144 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1145, 0, $h1144$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1144$, $b1144$(1) ما يستحق لبائع المنقول من الثمن وملحقاته يكون له امتياز على الشيء المبيع ويبقى الامتياز قائما مادام المبيع محتفظا بذاتيته، وهذا دون إخلال بالحقوق التى كسبها الغير بحسن نية، مع مراعاة الأحكام الخاصة بالمواد التجارية.
(2) ويكون هذا الامتياز تاليا فى المرتبة لما تقدم ذكره من حقوق الامتياز الواقعة على منقول، إلا أنه يسرى أيضا على مؤجر العقار وصاحب الفندق إذا ثبت أنهما كانا يعلمان وقت وضع المبيع فى العين المؤجرة أو الفندق أنه لم يدفع ثمنه.$b1144$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1144;

WITH ins1145 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1146, 0, $h1145$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 1- حقوق الامتياز العامة وحقوق الامتياز الخاصة الواقعة على منقول$h1145$, $b1145$(1) للشركاء الذين اقتسموا منقولا حق امتياز تأمينا لحق كل منهم فى الرجوع على الآخرين بسبب القسمة، وفى استيفاء ما تقرر لهم فيها من معدل.
(2) وتكون لامتياز المتقاسم نفس المرتبة التى يكون لامتياز بائع المنقول، فإذا تزاحم الحقان قدم الأسبق فى التاريخ.$b1145$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1145;

WITH ins1146 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1147, 0, $h1146$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 2- حقوق الامتياز الخاصة الواقعة على عقار$h1146$, $b1146$(1) ما يستحق لبائع العقار من الثمن وملحقاته، يكون له امتياز على العقار المبيع.
(2) ويجب أن يقيد الامتياز ولو كان البيع مسجلا، وتكون مرتبته من وقت القيد.$b1146$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1146;

WITH ins1147 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1148, 0, $h1147$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 2- حقوق الامتياز الخاصة الواقعة على عقار$h1147$, $b1147$(1) المبالغ المستحقة للمقاولين والمهندسين المعماريين الذين عهد إليهم فى تشييد أبنية أو منشآت أخرى أو فى إعادة تشييدها أو فى ترميمها أو فى صيانتها، يكون لها امتياز على هذه المنشآت، ولكن بقدر ما يكون بسبب هذه الأعمال زائدا فى قيمة العقار وقت رفع الدعوى.
(2) ويجب أن يقيد هذا الامتياز، وتكون مرتبته من وقت القيد.$b1147$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1147;

WITH ins1148 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1149, 0, $h1148$الكتاب الرابع - الحقوق العينية التبعية أو التأمينات العينية > الباب الرابع - حقوق الامتياز > الفصل الثانى - أنواع الحقوق الممتازة > 2- حقوق الامتياز الخاصة الواقعة على عقار$h1148$, $b1148$للشركاء الذين اقتسموا عقارا حق امتياز تأمينا لما تخوله القسمة من حق المطالبة على الآخرين بما فى ذلك حق المطالبة بمعدل القسمة. ويجب أن يقيد هذا الامتياز، وتكون مرتبته من وقت القيد.$b1148$
    FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1949-10-15'::date, 'active' FROM ins1148;

-- ===== كتلة التحقق النهائية =====

DO $verify074$
DECLARE
    v_law_id uuid;
    v_total INT;
    v_versions INT;
    v_distinct_main INT;
    v_repealed INT;
    v_max_no INT;
    v_min_no INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 131 AND law_year = 1948 AND kind = 'law';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 074: تعذر العثور على سجل القانون بعد الإدراج.';
    END IF;

    SELECT COUNT(*) INTO v_total FROM articles WHERE law_id = v_law_id;
    IF v_total <> 1150 THEN
        RAISE EXCEPTION 'migration 074: عدد المواد المتوقع 1150 لكن الفعلى %', v_total;
    END IF;

    SELECT COUNT(*) INTO v_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id;
    IF v_versions <> 1150 THEN
        RAISE EXCEPTION 'migration 074: عدد النسخ المتوقع 1150 لكن الفعلى %', v_versions;
    END IF;

    SELECT COUNT(DISTINCT article_no) INTO v_distinct_main
    FROM articles WHERE law_id = v_law_id AND article_suffix_order >= 0;
    IF v_distinct_main <> 1148 THEN
        RAISE EXCEPTION 'migration 074: عدد أرقام المواد الأساسية المتوقع 1148 لكن الفعلى %', v_distinct_main;
    END IF;

    SELECT COUNT(*) INTO v_repealed
    FROM articles WHERE law_id = v_law_id AND article_suffix_order >= 0 AND body = '(ملغاة).';
    IF v_repealed <> 56 THEN
        RAISE EXCEPTION 'migration 074: عدد المواد الملغاة المتوقع 56 لكن الفعلى %', v_repealed;
    END IF;

    SELECT MIN(article_no), MAX(article_no) INTO v_min_no, v_max_no
    FROM articles WHERE law_id = v_law_id AND article_suffix_order >= 0;
    IF v_min_no <> 1 OR v_max_no <> 1149 THEN
        RAISE EXCEPTION 'migration 074: مدى أرقام المواد المتوقع 1-1149 لكن الفعلى %-%', v_min_no, v_max_no;
    END IF;

    IF EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1022 AND article_suffix_order >= 0) THEN
        RAISE EXCEPTION 'migration 074: المادة 1022 غير موجودة فى نص المصدر ولا يجب أن تظهر كصف.';
    END IF;

    RAISE NOTICE 'migration 074 (القانون المدنى 131/1948): تم بنجاح. % مادة، % نسخة، % مادة ملغاة، مدى الأرقام 1-1149 ناقص فجوة 1022.', v_total, v_versions, v_repealed;
END $verify074$;

COMMIT;
