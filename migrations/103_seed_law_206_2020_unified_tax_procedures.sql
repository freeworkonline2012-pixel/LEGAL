-- =====================================================================
-- Migration 103: قانون الإجراءات الضريبية الموحد رقم 206 لسنة 2020
--                        (النص التأسيسى الأصلى فقط؛ مواد الإصدار الست +
--                         81 مادة موضوعية تغطى المدى 1-81 بالكامل)
-- =====================================================================
--
-- المصدر الأساسى: نسخة PDF رفعها صاحب المشروع مباشرة (43 صفحة) - مسح
--   ضوئى كامل للجريدة الرسمية، العدد 42 مكرر (ج)، 19 أكتوبر 2020، موقَّع
--   باسم رئيس الجمهورية عبد الفتاح السيسى (صدر برئاسة الجمهورية فى 2 ربيع
--   الأول 1442هـ الموافق 19 أكتوبر 2020م). تحقَّق مباشرة (pymupdf) أنه
--   مستند بطبقة نص مُستخرَجة معطوبة بالكامل (حروف تحكم خام لكل صفحة - خط
--   مخصص/معتم، مختلف عن عطل عكس pdftotext المعروف فى مستندات أخرى بهذا
--   المشروع) - لذا نُقل كل سطر من القراءة البصرية المباشرة لصفحات الـPDF
--   (43 صفحة)، صفحة بصفحة، دون أى اعتماد على التفريغ الآلى، مع تحقق إضافى
--   بالزووم العالى (6x عبر pymupdf+PIL) للمادة الرابعة من مواد الإصدار
--   (قائمة الإلغاءات الكثيفة) تحديدًا.
--
-- ⚠️ ملاحظة جوهرية (لا اختلاق): المادة الثالثة من مواد الإصدار الست ليست
--   حكمًا تأسيسيًا عن هذا القانون نفسه، بل هى تعديل مباشر على الفقرة
--   الرابعة من المادة (63) من قانون الضريبة على الدخل 91/2005. تُسجَّل هنا
--   كمادة من مواد إصدار 206/2020 (لأنها فعلاً إحدى مواده الستة المرقَّمة
--   فى الجريدة الرسمية)، لكن أثرها الموضوعى على جدول articles الخاص
--   بقانون 91/2005 يُنفَّذ فى هجرة مستقلة لاحقة (migration 104) بنفس نمط
--   amend_common.py المعتمد فى سلسلة تعديلات 91/2005 (084-102) - وليس هنا.
--   هذا تعديل ثامن عشر إضافى على قانون 91/2005 لم يكن موثقًا فى تقرير
--   إغلاق السلسلة الصادر 2026-10-03 (الذى اعتبر migration 102 آخر تعديل).
--
-- ⚠️ قرار نطاق صريح (عناية واجبة 2026-10-03، موافقة صاحب المشروع): اكتُشف
--   أن هذا القانون عُدِّل لاحقًا أيضًا بالقانونين 176/2022 (إضافة فقرة
--   ثانية للمادة 78) و7/2025 (إضافة مواد 45مكررا و75مكررا و75مكررا1)،
--   بالإضافة إلى القانون 211/2020 (يُبنى فى هجرة لاحقة منفصلة، migration
--   105، فور الانتهاء من هذه الهجرة). لم تتوفر نسخ PDF رسمية موثوقة من
--   176/2022 و7/2025 عند هذه الجلسة (فقط ملخصات من مصادر غير رسمية) - تم
--   تأجيل بنائهما لحين توفر مصدر رسمى موثوق، وتوثيق هذه الفجوة بشفافية.
--
-- سياسة effective_from: تاريخ واحد موحَّد لكل الصفوف = '2020-10-20' (مُشتَق
--   صراحة من نص المادة السادسة من مواد الإصدار: "يُنشر هذا القانون فى
--   الجريدة الرسمية، ويُعمل به من اليوم التالى لتاريخ نشره" - نُشر 19
--   أكتوبر 2020، فيُعمل به من 20 أكتوبر 2020). لا نمط REPLACE هنا (نسخة
--   واحدة فقط لكل صف، status='active' دائمًا فى article_versions).
--
-- بنية الترقيم: لا فجوات ولا مواد "مكررة" ظاهرة فى هذا النص التأسيسى -
--   كل رقم مادة من 1 إلى 81 يظهر مرة واحدة فقط فى نص المصدر.
--   - 6 مواد إصدار (article_suffix_order = -1، أرقام 1-6).
--   - 81 رقم مادة أساسية مميزة تغطى المدى 1-81 بالكامل.
--   - إجمالى الصفوف: 87 صفًا.
--
-- البنية الهرمية: الباب (الأول-العاشر) > الفصل أحيانًا > المادة. الأبواب
--   العشرة: الأول (أحكام عامة، 1-2)، الثانى (حقوق والتزامات الممولين
--   والمكلفين وتنظيم الإدارة الضريبية، 3-24)، الثالث (التسجيل الضريبى،
--   25-28)، الرابع (الإقرارات الضريبية، 29-34)، الخامس (الرقابة الضريبية،
--   35-44)، السادس (التحصيل، 45-53)، السابع (إجراءات الطعن الضريبى،
--   54-55)، الثامن (مراحل الطعن الضريبى، 56-67)، التاسع (الجرائم
--   والعقوبات، 68-77)، العاشر (الأحكام الختامية، 78-81).
--
-- التصنيف: category='other' (يطابق قيد laws_category_check؛ لا فئة
--   ضريبية/مالية مخصصة متاحة فيه حاليًا - نفس المعيار المتبع لقانون
--   91/2005 فى migration 076).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

INSERT INTO laws (country_code, law_no, law_year, kind, category, title, short_title, status, official_url, enacted_at)
SELECT 'EG', 206, 2020, 'law', 'other',
       $tlaw$قانون الإجراءات الضريبية الموحد رقم 206 لسنة 2020$tlaw$, $stlaw$قانون الإجراءات الضريبية الموحد 206/2020$stlaw$, 'in_force', $urllaw$مصدر المستخدم المباشر: نسخة PDF رفعها صاحب المشروع مباشرة (43 صفحة) - مسح ضوئى للجريدة الرسمية، العدد 42 مكرر (ج)، 19 أكتوبر 2020، موقَّع باسم رئيس الجمهورية عبد الفتاح السيسى. النص التأسيسى الأصلى كما صدر عام 2020 فقط (دون التعديلات اللاحقة: 211/2020 (مبنية فى هجرة منفصلة لاحقة)، و176/2022 و7/2025 (مؤجَّلتان لحين توفر مصدر رسمى موثوق) - دفعة أولى بقرار صريح من صاحب المشروع$urllaw$, '2020-10-20'
WHERE NOT EXISTS (
    SELECT 1 FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
);

-- ===== مواد الإصدار (article_suffix_order = -1، 6 مواد) =====
WITH insE1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, -1, $hE1$قانون 206/2020 > مواد الإصدار > مادة 1$hE1$, $bE1$يُعمل بأحكام القانون المرافق فى شأن إجراءات ربط وتحصيل الضريبة على الدخل، والضريبة على القيمة المضافة، ورسم تنمية الموارد المالية للدولة، وضريبة الدمغة، وأى ضريبة ذات طبيعة مماثلة تتفق أو يتفق فى جوهرها مع هذه الفرائض المالية أو تحل محلها، وذلك فيما لم يرد فى شأنه نص خاص فى القانون المنظم لكل منها، وفيما لا يتعارض مع أحكامه.$bE1$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM insE1;

WITH insE2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, -1, $hE2$قانون 206/2020 > مواد الإصدار > مادة 2$hE2$, $bE2$كل إجراء من إجراءات ربط وتحصيل الضرائب المنصوص عليها فى المادة الأولى من هذا القانون تم صحيحًا فى ظل قانون معمول به يبقى صحيحًا، وتسرى أحكام القانون المرافق على ما لم يستكمل من إجراءات قبل تاريخ العمل بهذا القانون.$bE2$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM insE2;

WITH insE3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, -1, $hE3$قانون 206/2020 > مواد الإصدار > مادة 3$hE3$, $bE3$يُستبدل بنص الفقرة الرابعة من المادة (63) من قانون الضريبة على الدخل الصادر بالقانون رقم 91 لسنة 2005 النص الآتى :
"وتتم تسوية المبالغ المدفوعة تطبيقًا لهذا النظام عند تقديم الإقرار السنوى المنصوص عليه فى المادة (31 بند/ج) من قانون الإجراءات الضريبية الموحد ، ويلتزم الممول بسداد الجزء المتبقى من الضريبة المستحقة من واقع الإقرار بعد خصم ما سبق أن أداه من دفعات مقدمة مضافًا إليها عائدٌ سنوىٌ محسوبٌ وفقًا لسعر الائتمان والخصم المُعلن من البنك المركزى مع استبعاد كسور الشهر والجنيه ." $bE3$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM insE3;

WITH insE4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, -1, $hE4$قانون 206/2020 > مواد الإصدار > مادة 4$hE4$, $bE4$تُلغى المواد أرقام (6 عدا الفقرة الأولى ، 10 الفقرتين الثالثة والرابعة ، 17 ، 18 ، 19 ، 20 ، 25 ، 26 ، 37) من قانون ضريبة الدمغة الصادر بالقانون رقم 111 لسنة 1980 .
وتُلغى المواد أرقام (15 الفقرة الأولى ، 69 ، 74 ، 75 ، 76 ، 77 ، 78 ، 79 فقرة أخيرة ، 80 ، 82 ، 83 ، 84 عدا الفقرة الأخيرة ، 87 ، 91 عدا الفقرة الأخيرة ، 95 عدا الفقرة الأخيرة ، 96 ، 97 ، 98 ، 99 ، 100 ، 101 ، 102 ، 103 ، 104 ، 106 ، 107 ، 108 ، 112 ، 113 ، 114) والباب السادس من الكتاب عدا المادة 126 ، وتُلغى المواد (135 عدا الفقرة الثالثة ، 137 ، 138 ، 148) من قانون الضريبة على الدخل الصادر بالقانون رقم 91 لسنة 2005 .
كما تُلغى المواد أرقام (12 ، 13 ، 14 ، 15 عدا الفقرة الثانية ، 16 الفقرتين الثالثة والرابعة ، 19 ، 20 ، 31 الفقرة الأولى ، 34 ، 35 ، 48 ، 50 ، 51 ، 53) والفصل الثالث من الباب الرابع عدا المادة 62 ، وتُلغى المواد (63 الفقرة الأولى ، 64 عدا الفقرتين الأولى والثانية ، 68 ، 66 ، البنود/ "7 ، 9 ، 11" ، 70 ، 72 ، 73) من قانون الضريبة على القيمة المضافة الصادر بالقانون رقم 67 لسنة 2016 .$bE4$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM insE4;

WITH insE5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, -1, $hE5$قانون 206/2020 > مواد الإصدار > مادة 5$hE5$, $bE5$يُصدر وزير المالية اللائحة التنفيذية للقانون المرافق خلال ستة أشهر من تاريخ العمل به، وإلى أن تصدر هذه اللائحة يستمر العمل باللوائح والقرارات المعمول بها حاليًا فيما لا يتعارض مع أحكامه.$bE5$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM insE5;

WITH insE6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, -1, $hE6$قانون 206/2020 > مواد الإصدار > مادة 6$hE6$, $bE6$يُنشر هذا القانون فى الجريدة الرسمية، ويُعمل به من اليوم التالى لتاريخ نشره.
يُبصم هذا القانون بخاتم الدولة، ويُنفذ كقانون من قوانينها.
صدر برئاسة الجمهورية فى 2 ربيع الأول سنة 1442هـ (الموافق 19 أكتوبر سنة 2020م).
عبد الفتاح السيسى$bE6$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM insE6;

-- ===== المواد الموضوعية 1-81 (article_suffix_order = 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, 0, $h1$قانون 206/2020 > الباب الأول: أحكام عامة > الفصل الأول: التعريفات > مادة 1$h1$, $b1$فى تطبيق أحكام هذا القانون، يُقصد بالألفاظ والعبارات التالية المعنى المبيَّن قرين كل منها :
1- الوزير : وزير المالية .
2- رئيس المصلحة : رئيس مصلحة الضرائب المصرية .
3- القانون الضريبى : قانون الضريبة على الدخل أو الضريبة على القيمة المضافة أو رسم تنمية الموارد المالية للدولة أو ضريبة الدمغة أو كل قانون يقرر فريضة مالية أخرى ذات طبيعة مماثلة أو تتفق فى جوهرها مع هذه الضرائب أو تحل محلها .
4- المصلحة : مصلحة الضرائب المصرية .
5- الضريبة : أى فريضة مالية أيًا كان وعاؤها أو القانون الذى ينظمها، وتتولى المصلحة ربطها وتحصيلها .
6- المبالغ الأخرى : أى مبلغ بخلاف الضريبة تلتزم المصلحة بأداء واجبه بموجب أى قانون ضريبى تطبقه المصلحة أو أى من المصالح الإيرادية التابعة لوزارة المالية، بما فى ذلك مقابل التأخير والضريبة الإضافية والتعويضات والجزاءات المالية .
7- الممول : الشخص الطبيعى أو الاعتبارى الخاضع للضريبة التى يفرضها القانون الضريبى .
8- المكلف : الشخص الطبيعى أو الاعتبارى الخاص أو العام أو المكلف بتحصيل وتوريد الضريبة للمصلحة، سواء كان منتجًا أو تاجرًا أو مؤديًا لسلعة أو خدمة خاضعة للضريبة بلغت مبيعاته حد التسجيل المنصوص عليه فى القانون الضريبى، وكل مستورد أو مصدر ووكيل توزيع لسلعة أو خدمة خاضعة للضريبة مهما كان حجم معاملاته، وكذلك كل منتج أو مؤدٍ لسلعة أو خدمة منصوص عليها فى الجدول المرافق للقانون الضريبى مهما كان حجم معاملاته .
9- الفترة الضريبية : المدة الزمنية المحددة التى يقدم عنها الإقرار الضريبى وفقًا للقانون الضريبى .
10- الإقرار الضريبى : النموذج أو البيان الذى يحل محله والذى يتضمن جميع المعلومات والبيانات المحددة لأغراض ربط الضريبة، عن فترة ضريبية معينة .$b1$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, 0, $h2$قانون 206/2020 > الباب الأول: أحكام عامة > الفصل الثانى: اللغة > مادة 2$h2$, $b2$يجوز للمصلحة قبول البيانات والمعلومات والسجلات والمستندات المتعلقة بالضريبة بأى لغة، على أن تكون مصحوبة بترجمة إلى اللغة العربية من جهة معتمدة لدى المصلحة.$b2$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, 0, $h3$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 3$h3$, $b3$مع مراعاة أحكام القانون الضريبى، يضمن هذا القانون لذوى الشأن الحقوق الآتية :
( أ ) التوعية بأحكام القانون الضريبى .
(ب) الحصول على النماذج والمطبوعات الضريبية .
(ج) الإخطار بالإجراءات الضريبية المتخذة فى شأنه بأى صورة من صور الإخطار المنصوص عليها فى هذا القانون .
(د) الاطلاع على الملف الضريبى .
(هـ) التحقق من شخصية الموظفين والتكليفات الرسمية .
(و) تلقى الردود الكتابية عن الاستفسارات التى سبق طرحها من الممول أو المكلف أو غيرهما عن وضعه الضريبى .
(ز) الحفاظ على سرية المعلومات الضريبية والفنية .
(ح) التواجد أثناء الفحص الميدانى .
(ط) استرداد الضريبة المسددة بالزيادة أو بالخطأ .
(ى) الحقوق الأخرى التى يكفلها القانون الضريبى .$b3$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, 0, $h4$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الأول: حقوق الممولين والمكلفين > مادة 4$h4$, $b4$للممول أو المكلف الذى يرغب فى إتمام معاملات له آثار ضريبية أن يتقدم بطلب كتابى إلى رئيس المصلحة لبيان موقفها فى شأن تطبيق أحكام القانون الضريبى على تلك المعاملات، ويجب أن يقدم الطلب مصحوبًا بالوثائق الآتية :
1 - اسم الممول أو المكلف ورقم تسجيله الضريبى الموحد .
2 - بيان بالمعاملة والآثار الضريبية لها .
3 - صور المستندات والعقود والحسابات المتعلقة بالمعاملة .
ويُصدر رئيس المصلحة قرارًا فى شأن الطلب خلال ثلاثين يومًا من تاريخ استيفاء المستندات، ويجوز لها طلب بيانات إضافية من الممول أو المكلف لهذا الغرض خلال تلك المدة، ويكون القرار ملزمًا للمصلحة ما لم يُكشف بعد إصداره عناصر للمعاملة لم تُعرض عليها قبل إصدار القرار.$b4$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, 0, $h5$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 5$h5$, $b5$يجب على الممولين والمكلفين وغيرهم الالتزام بأحكام هذا القانون والقانون الضريبى، وعلى الأخص ما يأتى :
( أ ) الإخطار ببدء مزاولة النشاط والتسجيل لدى المصلحة .
(ب) الالتزام بإمساك الدفاتر والسجلات الورقية أو الإلكترونية، والاحتفاظ بها خلال المدة القانونية المقررة، وإصدار الفواتير الضريبية وفقًا لأحكام القوانين واللوائح .
(ج) تقديم الإقرار الضريبى على النموذج المُعد لذلك .
(د) تمكين موظفى المصلحة من أداء واجباتهم فى شأن إجراءات الاطلاع والفحص والاستيفاء والرقابة فيما يتعلق بتطبيق أحكام هذا القانون، والقانون الضريبى .
(هـ) إخطار المصلحة بأى تغييرات تطرأ على النشاط أو المنشأة وذلك خلال الميعاد القانونى المحدد .
(و) تحديد المسئول عن التعامل مع المصلحة سواء كان صاحب الشأن أو من يمثله قانونًا .
(ز) حساب الضريبة بطريقة صحيحة وفقًا للقانون الضريبى واللوائح والقرارات المنفذة له .
(ح) سداد الضريبة بالطريقة المقررة قانونًا وخلال المهلة المحددة لذلك .
(ط) إدراج رقم التسجيل الضريبى الموحد فى جميع المراسلات والتعاملات مع المصلحة أو مع الغير وفقًا لأحكام هذا القانون أو القانون الضريبى .
(ى) الوفاء بأى التزامات أخرى ينص عليها هذا القانون أو القانون الضريبى .$b5$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, 0, $h6$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 6$h6$, $b6$يلتزم كل شخص يكون له بحكم وظيفته أو اختصاصه أو عمله شأن فى ربط أو تحصيل الضريبة المنصوص عليها فى القانون الضريبى أو فى الفصل فيما يتعلق بها من منازعات بمراعاة سرية المهنة .
ولا يجوز لأى من موظفى المصلحة ممن لا يتصل عملهم بربط أو تحصيل الضريبة إعطاء بيانات أى غير على إطلاع على ورقة أو بيان أو ملف أو غيره إلا فى الأحوال المصرح بها قانونًا .$b6$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 7, 0, $h7$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 7$h7$, $b7$يلتزم المكلفون بإدارة أموال الشركات والهيئات والمنشآت وأصحاب المهن التجارية وغير التجارية ومن فى حكمهم، وكل من يفرض عليهم قانون التجارة أو غيره إمساكها من غيرها وكذلك الممولين والمكلفين بأن يقدموا إلى موظفى المصلحة ممن لهم صفة الضبطية القضائية، عند طلب كل منهم، الدفاتر التى يفرض عليهم قانون التجارة أو غيره إمساكها وكذلك غيرها من الدفاتر التى يقررها القانون الضريبى لتنفيذ جميع الأحكام التى يقررها القانون الضريبى، سواء بالنسبة لهم أو لغيرهم من الممولين أو المكلفين .
ولا يجوز الامتناع عن تمكين موظفى المصلحة المشار إليهم من الاطلاع على تلك الدفاتر والمحررات والوثائق ومستندات الإيرادات والمصروفات وغيرها، سواء كانت ورقية أو إلكترونية، على أن يتم الاطلاع فى مكان وجودها، ودون الحاجة إلى إخطار مسبق.$b7$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 8, 0, $h8$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 8$h8$, $b8$يلتزم المختصون فى الوزارات والهيئات الاقتصادية والخدمية والمصالح الحكومية ووحدات الإدارة المحلية وغيرها من الأشخاص الاعتبارية العامة والنقابات والاتحادات المهنية والرياضية والفنية وغيرها التى يكون من اختصاصها منح تراخيص أو شهادات مزاولة تجارة أو صناعة أو حرفة أو منح تراخيص لبناء عقار أو إمكان استغلال عقار فى مزاولة تجارة أو صناعة أو حرفة أو مهنة، بإخطار المصلحة عند منح أى ترخيص أو شهادة ببيانات واسم طالب الترخيص أو الشهادة وذلك خلال أقصاها نهاية الشهر التالى للشهر الذى صدر فيه الترخيص أو الشهادة على النماذج التى يصدر بها قرار من الوزير .
ويعتبر فى حكم الترخيص المشار إليه منح امتياز أو التزام أو إذن لازم لمزاولة التجارة أو الصناعة أو الحرفة أو المهنة.$b8$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 9, 0, $h9$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 9$h9$, $b9$يلتزم كل مالك أو منتفع بعقار بإخطار مأمورية الضرائب المختصة باستغلال عقاره أو جزء منه فى مزاولة نشاط خاضع للضريبة، وذلك خلال ثلاثين يومًا من تاريخ الاستغلال.$b9$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 10, 0, $h10$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 10$h10$, $b10$تلتزم أقسام المرور بالامتناع عن تجديد أو نقل رخصة تسيير مركبات الأجرة أو النقل المملوكة لأى أشخاص من القطاع الخاص إلا بعد تقديم ما يفيد سداد الضريبة الواجبة الأداء على النموذج المعد لهذا الغرض.$b10$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 11, 0, $h11$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 11$h11$, $b11$تلتزم جميع المنشآت والمؤسسات والجهات والهيئات سواء الخاضعة للضريبة أو غير الخاضعة لها أو المعفاة منها بأن تقدم إلى موظفى المصلحة ممن لهم صفة الضبطية القضائية عند طلب كل منهم دفاتر حساباتها وكل ما تطلبه المصلحة من مستندات.$b11$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins11;

WITH ins12 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 12, 0, $h12$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 12$h12$, $b12$يلتزم كل شخص لديه معاملات تجارية أو مالية مع أشخاص مرتبطة بأن يقدم للمصلحة المستندات التالية الخاصة بمعاملاته التجارية والمالية لتسعير المعاملات :
( أ ) الملف الرئيسى : ويشمل المعلومات اللازمة عن جميع أعضاء مجموعة الأشخاص المرتبطة .
(ب) الملف المحلى : ويشمل المعاملات البينية للممول المحلى وتحليلاتها .
(ج) التقرير على مستوى كل دولة على حدة : ويشمل المعلومات المتعلقة بمجموعة الأشخاص المرتبطة فيما يخص توزيع دخل مجموعة الشركات على مستوى العالم والضرائب المسددة من جانب المجموعة، وعدد العاملين لديها، ورأس المال، والأرباح المحتجزة، والأصول الملموسة للمجموعة فى كل دولة، وتحديد الدول التى تُمارس المجموعة أنشطتها فيها، وكذلك المؤشرات الخاصة بمكان ممارسة النشاط الاقتصادى عبر مجموعة الأشخاص المرتبطة .
ويجوز للوزير أو من يفوضه الإعفاء من تقديم تقرير على مستوى كل دولة على حدة المشار إليه بناءً على تقرير يقدم على مستوى كل دولة على حدة، وفقًا لظروف كل شركة وبما يتفق مع الممارسات الدولية .
ويكون للمصلحة حال الإخلال بالالتزام المنصوص عليه فى الفقرة الأولى من هذه المادة، وضع قواعد التسعير التى تراها ملائمة، وذلك دون الإخلال بحق الشركة فى الطعن والاعتراض على قرار المصلحة وفقًا لما تبينه اللائحة التنفيذية لهذا القانون .
ويعفى الشخص الذى لا تتعدى قيمة تعاملاته من أشخاص مرتبطة خلال الفترة الضريبة مبلغ ثمانية ملايين جنيه من أحكام البندين (أ ، ب) المشار إليهما، ويجوز بقرار من الوزير زيادة هذا المبلغ .
ويحدد الدليل الإرشادى الذى يصدره الوزير القواعد والإجراءات المنظمة لما ورد بالفقرة الأولى من هذه المادة.$b12$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins12;

WITH ins13 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 13, 0, $h13$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 13$h13$, $b13$يجب تقديم المستندات المنصوص عليها فى المادة (12) من هذا القانون طبقًا لما يأتى :
( أ ) الملف الرئيس : وفقًا لتاريخ تقديم الملف الرئيس إلى الإدارة الضريبية فى دولة الإقامة للكيان الأم أو الشركة الأم لمجموعة الأشخاص المرتبطة .
(ب) الملف المحلى : خلال شهرين من تاريخ تقديم الممول لإقراره الضريبى السنوى فى مصر .
(ج) تقرير على مستوى كل دولة على حدة : خلال عام من نهاية السنة الضريبية المتعلقة بالفحص والربط .
ويلتزم كل شخص لديه معاملات تجارية أو مالية مع أشخاص مرتبطة حال الإخلال بالالتزام المنصوص عليه فى الفقرة الأولى من المادة (12) من هذا القانون، والفقرة الأولى من هذه المادة بأن يؤدى للمصلحة مبلغًا يعادل (1%) من قيمة المعاملات مع الأشخاص المرتبطة التى لم يقر عنها فى حالة عدم الإفصاح ضمن الإقرار الضريبى عن المعاملات مع الأشخاص المرتبطة طبقًا لنموذج الإقرار.$b13$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins13;

WITH ins14 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 14, 0, $h14$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 14$h14$, $b14$تلتزم الجهات التى تختص بالترخيص بطبع أو نشر الكتب والمؤلفات والمصنفات الفنية وغيرها أو إيداعها أو تسجيلها أو الإعلان أو النشر بالوسائل التكنولوجية عن طريق مواقع الإنترنت أو غيرها، بإخطار المصلحة فى كل حالة عن اسم المؤلف وعنوانه واسم المصنف أو الكتاب أو غيره، أو اسم طالب الإعلان أو النشر، وعنوانه، خلال مدة أقصاها نهاية الشهر التالى الذى صدر فيه الترخيص بالطبع أو النشر أو الإعلان، وذلك على النموذج الذى يصدر به قرار من الوزير .
ولا تسرى أحكام هذه المادة على وزارة الدفاع.$b14$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins14;

WITH ins15 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 15, 0, $h15$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثانى: التزامات الممولين والمكلفين وغيرهم > مادة 15$h15$, $b15$مع عدم الإخلال بأحكام سرية الحسابات المنصوص عليها فى القوانين المختلفة، على الجهات الحكومية بما فى ذلك جهاز الكسب غير المشروع والجهاز المركزى للتعبئة العامة والإحصاء ووحدات الإدارة المحلية والهيئات العامة وشركات قطاع الأعمال العام وقطاع الأعمال العام والنقابات والاتحادات أن تمكن موظفى المصلحة ممن لهم صفة الضبطية القضائية من الاطلاع على ما يريدونه من بيانات وأوراق متعلقة بالضريبة، وذلك فيما لا يتعارض مع مقتضيات الأمن القومى.$b15$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins15;

WITH ins16 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 16, 0, $h16$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 16$h16$, $b16$استثناءً من أحكام قانون الخدمة المدنية الصادر بالقانون رقم 81 لسنة 2016، يجوز للوزير وضع نظام خاص لإثابة موظفى المصلحة فى ضوء معدلات أدائهم وحجم ومستوى إنجازهم فى العمل، وذلك دون التقيد بأى قانون أو نظام آخر، ويُعتمد هذا النظام من رئيس مجلس الوزراء .
ويجوز أن تتضمن الموازنة العامة للدولة تخصيص مبالغ للمساهمة فى صناديق الرعاية الاجتماعية والصحية للعاملين بالمصلحة وأسرهم .
وتتمتع الصناديق المنصوص عليها فى هذه المادة فى الفقرة الثانية بالشخصية الاعتبارية المستقلة.$b16$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins16;

WITH ins17 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 17, 0, $h17$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 17$h17$, $b17$يجوز للوزير تفويض رئيس المصلحة فى التعاقد طبقًا لأحكام قانون تنظيم التعاقدات التى تبرمها الجهات العامة الصادر بالقانون رقم 182 لسنة 2018، وذلك فى شأن تدبير احتياجات المصلحة من المقار والتجهيزات والمعدات والأدوات والأجهزة اللازمة لحسن سير العمل.$b17$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins17;

WITH ins18 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 18, 0, $h18$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 18$h18$, $b18$للمصلحة تعيين مندوبين عنها من بين موظفيها لدى الوزارات والمصالح الحكومية ووحدات الإدارة المحلية والأشخاص الاعتبارية العامة وشركات قطاع الأعمال العام، ويتولى مندوب المصلحة متابعة سلامة تنفيذ هذه الجهات والشركات لأحكام القانون الضريبى وهذا القانون، والتحقق من أداء هذه الجهات للضرائب وفقًا لأحكام هذه القوانين الضريبية .
ويكون لهم إثبات ما يقع من مخالفات بموجب محاضر يتم اتخاذ ما يلزم من إجراءات قانونية فى شأنها.$b18$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins18;

WITH ins19 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 19, 0, $h19$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 19$h19$, $b19$فى مجال تطبيق أحكام القانون الضريبى واللوائح والقرارات المنفذة له، يكون للموظفين الذين يصدر بتحديدهم قرار من وزير العدل بالاتفاق مع وزير المالية صفة مأمورى الضبط القضائى فيما يتعلق بإثبات ما يتم من مخالفات لأحكام كل منها، واتخاذ الإجراءات المقررة فى شأن تلك المخالفات.$b19$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins19;

WITH ins20 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 20, 0, $h20$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 20$h20$, $b20$يُحظر على موظفى المصلحة الارتباط بأى علاقة عمل مباشرة أو غير مباشرة مع أى من مكاتب المحاسبة أو المراجعة أو مكاتب المحاماة أو غيرها من المنشآت المهنية أو أى من الممولين أو المكلفين فيما يتصل بتطبيق أحكام هذا القانون أو القانون الضريبى.$b20$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins20;

WITH ins21 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 21, 0, $h21$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 21$h21$, $b21$يُحظر على موظف المصلحة القيام أو المشاركة فى أى إجراءات ضريبية تخص أى شخص فى الحالات الآتية :
( أ ) وجود صلة قرابة حتى الدرجة الرابعة بينه وبين ذلك الشخص .
(ب) وجود مصلحة أو علاقات مادية بينه وبين الشخص الذى يخصه الإجراء أو أحد أقربائه حتى الدرجة الثالثة .
(ج) إذا قرر الرئيس المباشر عدم قيام الموظف بأى إجراءات ضريبية تخص ذلك الشخص لوجود أى حالة من حالات تضارب المصالح.$b21$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins21;

WITH ins22 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 22, 0, $h22$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 22$h22$, $b22$تباشر هيئة قضايا الدولة اختصاصها فى نظر الدعاوى التى تُرفع من الممول أو المكلف أو عليه أو يعاونها فى ذلك مندوب من المصلحة .
ويجوز للمحكمة أو لهيئة قضايا الدولة دعوة أحد الموظفين المختصين بالمصلحة ممن لهم صفة الضبطية القضائية للحضور أمام المحكمة أو لدى الهيئة بحسب الأحوال لاستيضاح الجوانب الفنية المتعلقة بالضريبة محل النزاع، ويلتزم الموظف المكلف بالحضور فى الموعد والمكان المحددين بالإخطار، ولا يعتبر ما يقدمه من إيضاحات أو آراء أمام المحكمة إقرارًا قضائيًا حجة على المصلحة .
وللمصلحة تكليف من تراه بها من الموظفين ممن لهم صفة الضبطية القضائية بالحضور أمام النيابة العامة وهيئة مفوضى الدولة ومصلحة الخبراء وجميع اللجان بنظر المنازعات الضريبية.$b22$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins22;

WITH ins23 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 23, 0, $h23$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 23$h23$, $b23$مع عدم الإخلال بأحكام قانون إعادة تنظيم النيابة الإدارية والمحاكمات التأديبية الصادر بالقانون رقم 117 لسنة 1958، تُجرى هيئة النيابة الإدارية التحقيق فى الشكاوى المقدمة ضد موظفى المصلحة ممن لهم صفة الضبطية القضائية أو أعضاء لجان الطعن من موظفى المصلحة بخصوص عملهم الفنى بعد فحص تجريه هيئة المصلحة أو وزارة المالية بناءً على طلب هيئة النيابة الإدارية، ويكون لتقرير الفحص المشار إليه اعتبار فى نتيجة التصرف فى تلك الشكاوى.$b23$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins23;

WITH ins24 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 24, 0, $h24$قانون 206/2020 > الباب الثانى: حقوق والتزامات الممولين والمكلفين وتنظيم الإدارة الضريبية > الفصل الثالث: تنظيم الإدارة الضريبية > مادة 24$h24$, $b24$لا يجوز لموظف المصلحة الذى انتهت خدمته لأى سبب من الأسباب أن يحضر أو يُشارك أو يترافع أو يمثل أيًا من الممولين أو المكلفين، سواء كان ذلك بنفسه أو عن طريق وكيل له فى أى من الملفات الضريبية التى سبق له الاشتراك فى فحصها أو مراجعتها أو اتخاذ أى إجراء فى إجراءات ربط الضريبة فيها، وذلك خلال خمس سنوات من تاريخ انتهاء خدمته.$b24$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins24;

WITH ins25 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 25, 0, $h25$قانون 206/2020 > الباب الثالث: التسجيل الضريبى > الفصل الأول: التسجيل > مادة 25$h25$, $b25$يلتزم كل ممول أو مكلف بأن يتقدم إلى مأمورية الضرائب المختصة بطلب للتسجيل خلال ثلاثين يومًا من تاريخ بدء مزاولة النشاط أو من تاريخ الخضوع للضريبة على القيمة المضافة، بحسب الأحوال، ويقدم هذا الطلب على النموذج المعد لهذا الغرض يدويًا أو بأى وسيلة إلكترونية لها الحجية فى الإثبات قانونًا، مرفقًا به المستندات اللازمة والتى تحددها اللائحة التنفيذية لهذا القانون .
وعلى المأمورية مراجعة طلب التسجيل المنصوص عليه فى الفقرة الأولى من هذه المادة، وإذا تبين لها عدم استيفائه للبيانات المطلوبة تقوم بإخطار الممول أو المكلف على النموذج المعد لهذا الغرض لاستيفاء البيانات خلال خمسة عشر يومًا من تاريخ الإخطار بأى من الوسائل المنصوص عليها بالفقرة الأولى من هذه المادة .
وفى حال عدم تقديم الممول أو المكلف طلب التسجيل المشار إليه، تقوم المأمورية بتسجيله بناءً على ما يتوافر لديها من بيانات أو معلومات، مع إخطاره بالتسجيل خلال خمسة أيام عمل وذلك مع عدم الإخلال بالمسئولية الجنائية .
ويلتزم غير المكلفين ممن لم تبلغ مبيعاتهم حد التسجيل المقرر قانونًا بالتسجيل بالمنظومة الإلكترونية مقابل رسم سنوى يحدده وزير المالية بما لا يتجاوز خمسمائة جنيه، ويتوقف تحصيل هذا الرسم عند بلوغ حد التسجيل.$b25$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins25;

WITH ins26 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 26, 0, $h26$قانون 206/2020 > الباب الثالث: التسجيل الضريبى > الفصل الثانى: رقم التسجيل الضريبى > مادة 26$h26$, $b26$تُخصص المصلحة لكل ممول أو مكلف رقم تسجيل ضريبى موحدًا لجميع أنواع الضرائب الخاضع لها، وتلتزم كل من المصلحة والممول والمكلف والجهات والمنشآت الأخرى باستخدامه فى جميع التعاملات، ويتم إثباته على جميع الإخطارات والسجلات والمستندات والفواتير وأى مكاتبات أخرى.$b26$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins26;

WITH ins27 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 27, 0, $h27$قانون 206/2020 > الباب الثالث: التسجيل الضريبى > الفصل الثالث: البطاقة الضريبية > مادة 27$h27$, $b27$تلتزم مأمورية الضرائب المختصة بإصدار بطاقة ضريبية للممول المسجل خلال خمسة أيام عمل من تاريخ استخراج طلب البطاقة على النموذج المعد لهذا الغرض، كما يجب عليها منح المكلفين المسجلين لديها شهادة تفيد تسجيلهم خلال خمسة أيام عمل من تاريخ التسجيل، وتكون مدة سريان البطاقة الضريبية أو شهادة التسجيل خمس سنوات من تاريخ إصدارها، ويحق للممول أو المكلف حال انتهاء مدة سريانها أو فقدها أو تلفها طلب تجديدها أو استخراج بدل فاقد أو تالف لها، بحسب الأحوال، وذلك على النموذج المعد لهذا الغرض .
ولا يجوز لأى جهة حكومية أو غير حكومية التعامل مع الممول أو المكلف إلا من خلال البطاقة الضريبية أو شهادة التسجيل، بحسب الأحوال، على أن تكون البطاقة الضريبية ضمن إجراءات التأسيس أو الترخيص بمزاولة المهنة أو النشاط أو تجديده.$b27$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins27;

WITH ins28 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 28, 0, $h28$قانون 206/2020 > الباب الثالث: التسجيل الضريبى > الفصل الثالث: البطاقة الضريبية > مادة 28$h28$, $b28$يلتزم الممول أو المكلف بالإخطار بأى تغييرات تحدث على البيانات السابق تقديمها عند التسجيل وفقًا للمادة (25) من هذا القانون وذلك خلال ثلاثين يومًا من تاريخ حدوث هذا التغيير، ويقع عبء هذا الإخطار فى حالة وفاة الممول أو المكلف على ورثته خلال ستين يومًا من تاريخ الوفاة.$b28$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins28;

WITH ins29 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 29, 0, $h29$قانون 206/2020 > الباب الرابع: الإقرارات الضريبية > الفصل الأول: الشخص الملزم بتقديم الإقرار الضريبى وآلية تقديمه > مادة 29$h29$, $b29$يلتزم كل ممول أو مكلف أو من يمثله قانونًا بأن يقدم إلى مأمورية الضرائب المختصة إقرارًا عن الفترة الضريبية على النموذج المعد لهذا الغرض .
ويكون تقديم الإقرار الضريبى المنصوص عليه فى الفقرة الأولى من هذه المادة والفواتير والمستندات وغيرها من الأوراق والبيانات التى يتطلبها القانون الضريبى وهذا القانون بالصورة الرقمية المعتمدة بتوقيع إلكترونى وفقًا للنظم التى يصدر بها قرار من الوزير، ويحدد هذا القرار الجدول الزمنى لبدء الالتزام بهذا الحكم، بحسب طبيعة فئات الممولين والمكلفين المخاطبين به، وذلك خلال مدة لا تجاوز عامين من تاريخ العمل بهذا القانون ويجوز مد هذه المدة لمدة مماثلة .
ويجب أن يكون الإقرار الضريبى المشار إليه مستوفيًا لبيانات النموذج المشار إليه، وتؤدى الضريبة المستحقة من واقع الإقرار .
ولا يُحتج بهذا الإقرار فى مواجهة المصلحة حال عدم توقيعه أو عدم استيفاء بيانات النموذج المنصوص عليه فى الفقرة الأولى من هذه المادة .
ويسدد الممول أو المكلف رسمًا يصدر بتحديده قرار من الوزير نظير استخدامه للمنظومة الإلكترونية، على ألا يجاوز هذا الرسم ألف جنيه سنويًا.$b29$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins29;

WITH ins30 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 30, 0, $h30$قانون 206/2020 > الباب الرابع: الإقرارات الضريبية > الفصل الأول: الشخص الملزم بتقديم الإقرار الضريبى وآلية تقديمه > مادة 30$h30$, $b30$يكون للتوقيع الإلكترونى فى نطاق تطبيق أحكام القانون الضريبى وهذا القانون ذات الحجية المقررة للتوقيعات فى أحكام قانون الإثبات فى المواد المدنية والتجارية إذا روعى فى إنشائه وإتمامه الشروط المنصوص عليها فى القانون رقم 15 لسنة 2004 بتنظيم التوقيع الإلكترونى وبإنشاء هيئة تنمية صناعة تكنولوجيا المعلومات، والضوابط الفنية والتقنية التى تحددها اللائحة التنفيذية له.$b30$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins30;

WITH ins31 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 31, 0, $h31$قانون 206/2020 > الباب الرابع: الإقرارات الضريبية > الفصل الثانى: مواعيد تقديم الإقرار الضريبى > مادة 31$h31$, $b31$يجب تقديم الإقرار الضريبى المنصوص عليه فى المادة (29) من هذا القانون خلال المواعيد الآتية :
( أ ) إقرارات شهرية :
على كل مكلف أن يقدم للمأمورية المختصة إقرارًا شهريًا عن الضريبة على القيمة المضافة، وضريبة الجدول المستحقة أو إحداهما، بحسب الأحوال، وذلك على النموذج المعد لهذا الغرض خلال الشهر التالى لانتهاء الفترة الضريبية .
كما يجب على المكلف تقديم الإقرار ولو لم يكن قد حقق أو أدى خدمات خاضعة للضريبة على القيمة المضافة أو ضريبة الجدول خلال الفترة الضريبية .
ويجوز لرئيس المصلحة أو من يفوضه بالنسبة للمصدرين أو المستوردين الذين يقومون بالتصدير أو الاستيراد أو أداء الخدمة مرة أو مرتين فى السنة الموافقة على الاكتفاء بتقديم الإقرار عن الشهر الذى يتم فيه عملية التصدير أو الاستيراد أو أداء الخدمة إذا ما اقترنت بواقعة بيع هذه الفترة أو سداد مقابل تأدية الخدمة فى الفترة ذاتها، دون حاجة إلى تقديم إقرار شهرى .
(ب) إقرارات ربع سنوية :
يلتزم أصحاب الأعمال والملتزمون بدفع الإيرادات الخاضعة للضريبة على المرتبات وما فى حكمها بما فى ذلك الشركات والمشروعات المقامة بنظام المناطق الحرة بالآتى :
تقديم إقرار ربع سنوى إلى مأمورية الضرائب المختصة فى يناير وأبريل ويوليو وأكتوبر من كل عام على النموذج المعد لهذا الغرض، موضحًا به عدد العاملين وبياناتهم وما فى حكمهم، وإجمالى المرتبات المنصرفة لهم خلال الثلاثة أشهر السابقة، والمبالغ المستقطعة تحت حساب الضريبة والمبالغ المسددة عن ذات المدة، وصورة من إيصالات السداد، وبيان بالتعديلات التى طرأت على هؤلاء العاملين بالزيادة أو النقص .
إعطاء العامل بناءً على طلبه كشفًا يبين فيه اسمه وثلاثيًا ومبلغ ونوع الدخل وقيمة الضريبة المحجوزة .
إعداد إقرار ضريبى بالتسوية النهائية فى نهاية السنة وتقديمه لمأمورية الضرائب المختصة خلال شهر يناير من كل سنة، موضحًا به إجمالى الإيرادات التى تقاضاها العامل خلال السنة مخصومًا منها جميع الاستقطاعات والإعفاءات المقررة قانونًا، وعلى صاحب العمل أو الملتزم بدفع الإيراد أداء ما يستحق من فروق الضريبة، دون الإخلال بحقه فى الرجوع على العامل بما هو مدين به .
(ج) إقرارات سنوية :
يلتزم كل ممول خاضع لأحكام قانون الضريبة على الدخل بأن يقدم لمأمورية الضرائب المختصة إقرارًا ضريبيًا سنويًا على النموذج المعد لهذا الغرض وملحقاته .
ولا يعتد بالإقرار المقدم دون استيفاء جميع الجداول والبيانات الواردة بنموذج الإقرار وملحقاته فى الميعاد المحدد لتقديم الإقرار .
ويجب تقديم ذلك الإقرار خلال المواعيد الآتية :
قبل أول أبريل من كل سنة تالية لانتهاء الفترة الضريبية عن السنة السابقة لها بالنسبة للأشخاص الطبيعيين .
قبل أول مايو من كل سنة أو خلال أربعة أشهر تالية لتاريخ انتهاء السنة المالية بالنسبة للأشخاص الاعتبارية .
ويلتزم الممول بتقديم الإقرار عن فترات إعفائه من الضريبة .
ويعتبر تقديم الإقرار لأول مرة إخطارًا بمزاولة النشاط .
ويعفى الممول من تقديم الإقرار فى الحالات الآتية :
إذا اقتصر دخله على المرتبات وما فى حكمها .
إذا اقتصر دخله على إيرادات الثروة العقارية ولم يتجاوز دخله الصافى منها المبلغ المحدد المعفى من الشريحة طبقًا لقانون الضريبة على الدخل .
إذا اقتصر دخله على المرتبات وما فى حكمها وإيرادات الثروة العقارية ولم يتجاوز دخله الصافى منهما المبلغ المحدد المعفى فى الشريحة طبقًا لقانون الضريبة على الدخل وتعديلاته .
(د) مواعيد خاصة لتقديم الإقرارات :
فى حالة وفاة الممول أو المكلف خلال الفترة الضريبية، يجب على الورثة أو وصى التركة أو المصفى، بحسب الأحوال، أن يقدم الإقرار الضريبى عن الفترة أو الفترات السابقة التى لم يحل ميعاد تقديم إقراراتها حتى تاريخ الوفاة، وذلك خلال تسعين يومًا من هذا التاريخ، وأن تؤدى الضريبة المستحقة على الممول أو المكلف من مال التركة .
وعلى الممول أو المكلف الذى تنقطع إقامته أن يقدم الإقرار الضريبى قبل انقطاع إقامته بستين يومًا على الأقل ما لم يكن هذا الانقطاع لسبب مفاجئ خارج عن إرادته .
وعلى الممول الذى يتوقف عن مزاولة نشاطه بصفة كلية أن يقدم الإقرار الضريبى خلال ستين يومًا من تاريخ التوقف .
كما على الممول المتنازل فى حالة التنازل عن كل أو بعض المنشأة أن يقدم خلال ستين يومًا من تاريخ التنازل إقرارًا مستقلاً مبينًا فيه نتيجة العمليات المتعلقة بالمنشأة المتنازل عنها مرفقًا به المستندات والبيانات اللازمة لتحديد الأرباح حتى تاريخ التنازل، على أن تدرج بيانات هذا الإقرار ضمن الإقرار الضريبى السنوى للمتنازل .
ويوقع الإقرار المنصوص عليه فى البندين (أ ، ب) من الفقرة الأولى من هذه المادة من الملتزم بتقديمه أو من يمثله، ويوقع الإقرار المنصوص عليه فى البند (ج) من الفقرة ذاتها من الممول أو من يمثله قانونًا، وإذا أعد الإقرار المنصوص عليه بالبند (ج) محاسب مستقل، فإن التوقيع على الإقرار يكون منه مع الممول أو من يمثله قانونًا، وإلا اعتبر الإقرار كأن لم يكن .
ويجب أن يكون الإقرار المنصوص عليه فى البند (ج) من الفقرة الأولى من هذه المادة موقعًا من محاسب مقيد بجدول المحاسبين والمراجعين طبقًا للقانون المنظم لذلك، وذلك بالنسبة لشركات الأموال والجمعيات التعاونية والأشخاص الطبيعيين وشركات الأشخاص إذا تجاوز رقم الأعمال لأى منهم مليونى جنيه سنويًا.$b31$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins31;

WITH ins32 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 32, 0, $h32$قانون 206/2020 > الباب الرابع: الإقرارات الضريبية > الفصل الثانى: مواعيد تقديم الإقرار الضريبى > مادة 32$h32$, $b32$يلتزم الممول أو المكلف بتقديم إقراره الضريبى من خلال الوسائل الإلكترونية المتاحة وذلك بعد الحصول على كلمة المرور السرية، وتوقيع إلكترونى مجاز طبقًا لأحكام القانون رقم 15 لسنة 2004 بتنظيم التوقيع الإلكترونى وبإنشاء هيئة تنمية صناعة تكنولوجيا المعلومات، ويعتبر الممول مسئولاً مسئولية كاملة عما يقدمه .
وفى جميع الأحوال، يلتزم الممول بسداد مبلغ الضريبة المستحق من واقع الإقرار فى ذات يوم تقديمه، بعد استنزال الضرائب المخصومة والمحصلة والدفعات المقدمة والعائد المستحق عليها إن وجد، وفى حال زيادة الضرائب المخصومة على مبلغ الضريبة المستحقة يتم استخدام الزيادة فى تسوية المستحقات الضريبية السابقة، فإن لم توجد مستحقات ضريبية سابقة التزمت المصلحة برد الزيادة ما لم يطلب الممول كتابة استخدام هذه الزيادة لسداد مستحقات ضريبية له فى المستقبل .
ويعتبر تقديم الممول أو المكلف للإقرار بالطريقة المنصوص عليها فى هذه المادة بمثابة كتابة تقديمه لمأمورية الضرائب المختصة.$b32$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins32;

WITH ins33 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 33, 0, $h33$قانون 206/2020 > الباب الرابع: الإقرارات الضريبية > الفصل الثالث: الإقرار الضريبى المُعدل > مادة 33$h33$, $b33$يجب على الممول إذا اكتشف خلال السنة التالية لتاريخ انتهاء الميعاد المحدد لتقديم الإقرار السنوى المنصوص عليه فى البند (ج) من الفقرة الأولى من المادة (31) من هذا القانون سهوًا أو خطأ فى إقراره الضريبى الذى تم تقديمه لمأمورية الضرائب المختصة أن يتقدم بإقرار ضريبى معدل لتصحيح السهو أو الخطأ .
وإذا قام الممول بتقديم الإقرار المعدل خلال ثلاثين يومًا من انتهاء الميعاد القانونى لتقديم الإقرار، يعتبر الإقرار المعدل بمثابة الإقرار الأصلى .
ويكون لبنوك وشركات ووحدات القطاع العام وشركات قطاع الأعمال العام والأشخاص الاعتبارية العامة التى تباشر نشاطًا مما يخضع للضريبة تقديم إقرار نهائى خلال ثلاثين يومًا من تاريخ اعتماد الجمعية العمومية لحساباتها وواقعها، وتؤدى فروق الضريبة .
وفى حالة تقديم إقرار معدل وفقًا للفقرتين الثانية والثالثة من هذه المادة، لا يعتبر الخطأ أو السهو فى الإقرار تهربًا ضريبيًا .
ويجوز للمكلف أن يقدم إقرارًا معدلاً عن الإقرار السابق تقديمه فى الميعاد .
ويسقط حق الممول أو المكلف فى تقديم إقرار معدل فى الحالتين الآتيتين :
1- اكتشاف إحدى حالات التهرب الضريبى .
2- الإخطار بالبدء فى إجراءات الفحص وفقًا لأحكام الفقرة الأولى من المادة (41) من هذا القانون.$b33$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins33;

WITH ins34 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 34, 0, $h34$قانون 206/2020 > الباب الرابع: الإقرارات الضريبية > الفصل الثالث: الإقرار الضريبى المُعدل > مادة 34$h34$, $b34$إذا قدم الممول أو المكلف إقرارًا معدلاً متضمنًا ضريبة أقل من الضريبة الواردة بالإقرار الأصلى، فلا يحق له استرداد أو تسوية فرق الضريبة إلا بعد مراجعة المصلحة وتأكدها من صحة الاسترداد أو التسوية، وذلك خلال ستة أشهر من تاريخ تقديمه طلب الاسترداد أو التسوية.$b34$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins34;

WITH ins35 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 35, 0, $h35$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 35$h35$, $b35$يجب على الشركات وغيرها من الأشخاص الاعتبارية والطبيعية الذين تحددهم اللائحة التنفيذية لهذا القانون ممن يبيعون سلعة أو يقدمون خدمة تسجيل جميع مشترياتهم ومبيعاتهم من السلع والخدمات على النظام الإلكترونى الذى تحدد اللائحة التنفيذية لهذا القانون مواصفاته ومعاييره الفنية وضوابط وأحكام العمل به، بما يكفل للمصلحة من خلاله متابعة حركة المبيعات بشكل دائم، والوقوف على حجمها وقيمتها وأطراف علاقة التعامل، وغير ذلك مما يلزم لربط الضريبة المقررة وتحصيلها.$b35$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins35;

WITH ins36 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 36, 0, $h36$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 36$h36$, $b36$يجب أن يُضمِّن النظام المنصوص عليه فى الفقرة الأولى من المادة السابقة من هذا القانون تسجيل جميع المتحصلات النقدية أو الإلكترونية التى توضح قيمة المبيعات من السلع والخدمات، والضريبة المستحقة عليها، وإصدار فاتورة إلكترونية سليمة عن كل عملية بيع موقعة إلكترونيًا من مصدرها ومستوفاة لمعايير التأمين التى تحددها اللائحة التنفيذية لهذا القانون المشار إليها، وتتضمن البيانات المنصوص عليها فى المادة (37) من هذا القانون .
وللشركات وغيرها من الأشخاص المنصوص عليهم فى الفقرة الأولى من هذه المادة التعاقد مع إحدى الشركات المرخص لها من الوزير لتنفيذ النظام الإلكترونى المشار إليه، وتوفير مستلزماته والتدريب على استخدامه، وعلى الشركات المتعاقد معها متابعة التحقق من التزامها بذلك النظام وسلامة مخرجاته، وبصفة خاصة إصدار فاتورة إلكترونية سليمة عن كل حركة بيع، وموافاة المصلحة بتقرير شهرى بما يفيد ذلك .
ويكون منح الترخيص للشركات التى تتولى تنفيذ النظام الإلكترونى المشار إليه وإلغاء هذا الترخيص طبقًا للضوابط والشروط التى تحددها اللائحة التنفيذية لهذا القانون.$b36$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins36;

WITH ins37 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 37, 0, $h37$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 37$h37$, $b37$يجب على كل ممول أو مُكلف وغيرهم ممن يفرض عليهم ذلك القانون إصدار فاتورة ضريبية أو إيصال مهنى بالنسبة لمن يزاولون مهنة حرة عند بيع السلعة أو أداء الخدمة، وفقًا للضوابط الآتية :
( أ ) أن تكون الفاتورة أو الإيصال من أصل وصورة، ويسلم الأصل للمشترى، وتحفظ الصورة لدى الممول أو المكلف .
(ب) أن تكون الفاتورة أو الإيصال مرقمة بأرقام مسلسلة طبقًا لتواريخ تحريرها وخالية من الشطب أو الكشط أو التحشير .
(ج) أن تتضمن الفاتورة أو الإيصال البيانات الآتية :
رقم مسلسل الفاتورة أو الإيصال .
تاريخ الإصدار .
اسم الممول أو المكلف وعنوانه ورقم تسجيله .
اسم المشترى وعنوانه ورقم تسجيله إن وجد .
بيان السلعة المباعة أو الخدمة المؤداة وفئتها وقيمتها والضريبة على القيمة المضافة أو ضريبة الجدول المقررة وقيمتها مع بيان إجمالى قيمة الفاتورة أو الإيصال .
أى بيانات أخرى تحددها اللائحة التنفيذية لهذا القانون .
وتحدد اللائحة التنفيذية لهذا القانون البيانات التى يجب أن يتضمنها الإيصال المهنى المشار إليه .
وللوزير وضع نظم مبسطة لأغراض ربط الضريبة على القيمة المضافة وضريبة الجدول للمنشآت التى يتعذر عليها إصدار فواتير ضريبية عند كل عملية بيع .
ويجب أن يتم إصدار الفاتورة أو الإيصال المنصوص عليهما فى الفقرة الأولى من هذه المادة فى شكل محرر إلكترونى وذلك بالصورة وطبقًا للضوابط والأحكام التى تحددها اللائحة التنفيذية لهذا القانون .
ويجوز بقرار من الوزير تقرير شكل خاص بالفاتورة الضريبية الإلكترونية لفئة معينة من الممولين أو المكلفين .
وفى حالة إلغاء الفاتورة أو الإيصال، يلتزم الممول أو المكلف بالاحتفاظ بأصل الإيصال أو الفاتورة الملغاة وجميع صورها .
ويُعتد بالإيصالات الإلكترونية التى تصدر من خلال الوسائل الإلكترونية المختلفة، وتحدد اللائحة التنفيذية لهذا القانون شكل هذه الإيصالات والبيانات الأساسية التى يجب توافرها وغيرها من الإجراءات ونظم الرقابة اللازمة لتنفيذ ذلك.$b37$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins37;

WITH ins38 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 38, 0, $h38$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 38$h38$, $b38$مع مراعاة أحكام قانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد الصادر بالقانون رقم 159 لسنة 1981، يلتزم كل ممول يزاول نشاطًا تجاريًا أو صناعيًا أو حرفيًا أو مهنيًا إذا تجاوز رقم أعماله السنوى مبلغ خمسمائة ألف جنيه بإمساك السجلات والدفاتر المحاسبية المنتظمة المنصوص عليها بقانون التجارة رقم 17 لسنة 1999 يدويًا أو إلكترونيًا .
وعلى كل ممول أو مكلف إمساك حسابات إلكترونية توضح الإيرادات والتكاليف السنوية، ويصدر الوزير قرارًا بتنظيم إمساك هذه الحسابات وضوابطها، واللازم توافره للتحول من نظام الحسابات الورقية إلى المنظومة الإلكترونية .
وفى جميع الأحوال، يلتزم الممول أو المكلف بالاحتفاظ بالسجلات والدفاتر والمستندات بما فيها صور الفواتير لمدة خمس سنوات تالية للفترة الضريبية التى يُقدم عنها الإقرار .
وللوزير وضع قواعد مبسطة لإمساك الدفاتر والسجلات بالنسبة لفئات الممولين أو المكلفين التى يصدر بتحديدها قرار منه.$b38$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins38;

WITH ins39 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 39, 0, $h39$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 39$h39$, $b39$يقع عبء الإثبات على المصلحة فى الحالتين الآتيتين :
( أ ) تصحيح الإقرار أو تعديله أو عدم الاعتداد به إذا كان مقدمًا طبقًا للشروط والأوضاع المنصوص عليها فى هذا القانون .
(ب) تعديل الربط وفقًا لأحكام القانون الضريبى.$b39$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins39;

WITH ins40 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 40, 0, $h40$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الأول: الإثبات الضريبى > مادة 40$h40$, $b40$يقع عبء الإثبات على الممول أو المكلف فى الحالات الآتية :
( أ ) قيام المصلحة بإجراء ربط تقديرى للضريبة إذا ما تبين أن البيانات المقدمة من الممول وتم الربط على أساسها غير صحيحة، أو لم يقدم البيانات المقررة قانونًا فى الحالات التى يجوز لها ذلك وفقًا لهذا القانون .
(ب) قيام الممول أو المكلف بتصحيح خطأ فى إقراره الضريبى .
(ج) اعتراض الممول أو المكلف على محتوى محضر محرر بمعرفة مأمور من المصلحة ممن لهم صفة الضبطية القضائية.$b40$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins40;

WITH ins41 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 41, 0, $h41$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الثانى: الفحص الضريبى > مادة 41$h41$, $b41$يجب على مأمورية الضرائب المختصة إخطار الممول أو المكلف بكتاب موصى عليه بعلم الوصول وبأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا، أو أى وسيلة كتابية يتحقق بها العلم بالتاريخ المحدد للفحص ومكانه والمدة التقديرية للفحص قبل عشرة أيام على الأقل، وذلك على النموذج المعد لهذا الغرض .
ويجوز استثناءً اتخاذ إجراءات وأعمال الفحص فى الأحوال التى تكون فيها حقوق الخزانة العامة معرضة للخطر أو يكون فيها شبهة تهرب ضريبى، وذلك بموافقة رئيس المصلحة بناءً على عرض رئيس المأمورية المختص بموجب مذكرة تتضمن الأسباب التى تبرر هذا الإجراء .
ويلتزم الممول أو المكلف بتوفير البيانات وصور المستندات والمحررات بما فى ذلك قوائم العملاء والموردين التى تطلبها المصلحة منه كتابة، وذلك خلال خمسة عشر يومًا من تاريخ طلبها، ولرئيس المصلحة أو من يفوضه مد هذه المدة لمدة مماثلة إذا قدم المكلف أو الممول دليلاً كافيًا على ما يعترضه من صعوبات فى تقديم تلك البيانات والمستندات والمحررات المطلوبة.$b41$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins41;

WITH ins42 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 42, 0, $h42$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الثانى: الفحص الضريبى > مادة 42$h42$, $b42$يحق لموظفى المصلحة ممن لهم صفة الضبطية القضائية دخول مقار عمل الممول أو المكلف خلال ساعات العمل دون إخطار مسبق، وإذا لزم دخول هذه المقار بعد ساعات العمل يجب إصدار تصريح بذلك من رئيس جهة العمل .
وعلى مأمور الضبط القضائى إثبات ما يتم أو ما يتكشف له فى محضر محرر وفقًا لما يصدر به قرار من الوزير.$b42$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins42;

WITH ins43 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 43, 0, $h43$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الثالث: الإخطار بالربط > مادة 43$h43$, $b43$تُخطر المصلحة الممول أو المكلف بتعديل أو تقدير الضريبة على النموذج المعد لهذا الغرض بخطاب موصى عليه مصحوبًا بعلم الوصول أو بأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا، أو تسليمه النموذج لهذا الغرض بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله .
وإذا ثبت للمصلحة وجود إيرادات لم يسبق إخطار الممول أو المكلف بها يتم محاسبته وإخطاره بالتعديل على النموذج لهذا الغرض بأى من الوسائل المنصوص عليها بالفقرة الأولى من هذه المادة.$b43$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins43;

WITH ins44 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 44, 0, $h44$قانون 206/2020 > الباب الخامس: الرقابة الضريبية > الفصل الثالث: الإخطار بالربط > مادة 44$h44$, $b44$فى جميع الأحوال، لا يجوز للمصلحة إجراء تقدير أو تعديل للضريبة إلا خلال خمس سنوات من تاريخ انتهاء المدة المحددة قانونًا لتقديم الإقرار عن الفترة الضريبية، وتكون المدة ست سنوات فى حالات التهرب .
وينقطع التقادم لأى سبب من الأسباب المنصوص عليها فى القانون المدنى، أو بالإخطار بربط الضريبة على الممول أو المكلف بأدائها، أو بالإحالة إلى لجان الطعن.$b44$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins44;

WITH ins45 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 45, 0, $h45$قانون 206/2020 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 45$h45$, $b45$يكون تحصيل الضريبة غير المسددة ومقابل التأخير والضريبة الإضافية المستحقة بموجب القانون الضريبى من خلال مطالبات واجبة التنفيذ تصدر باسم من هم ملزمون قانونًا بأدائها وبغير إخلال بما قد يكون لهم من حق الرجوع على من هم مدينون بها، وذلك على النماذج المعدة لهذا الغرض والتى يصدر بها قرار من الوزير، وترسل هذه المطالبات بكتاب موصى عليه بعلم الوصول وبأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا، أو يتم تسليمها بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله.$b45$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins45;

WITH ins46 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 46, 0, $h46$قانون 206/2020 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 46$h46$, $b46$للمصلحة حق توقيع حجز تنفيذى بقيمة ما يكون مستحقًا من الضرائب من واقع الإقرارات المقدمة من الممول أو المكلف إذا لم يتم أداؤها فى المواعيد القانونية، دون حاجة إلى إصدار مطالبة أو تنبيه بذلك، ويكون إقرار الممول أو المكلف فى هذه الحالة سند تنفيذ .
وفى جميع الأحوال، لا يجوز توقيع الحجز إلا بعد إنذار الممول بكتاب موصى عليه بعلم الوصول ما لم يكن هناك خطر يهدد اقتضاء دين الضريبة .
ويتبع فى تحصيل الضرائب والمبالغ الأخرى المستحقة طبقًا للقانون الضريبى أحكام القانون رقم 308 لسنة 1955 فى شأن الحجز الإدارى والأحكام المنصوص عليها فى هذا القانون .
واستثناءً من أحكام أى قانون آخر، تسرى أحكام الفقرة السابقة على الشركات والمنشآت أيًا كان النظام القانونى المنشأة وفقًا له.$b46$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins46;

WITH ins47 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 47, 0, $h47$قانون 206/2020 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 47$h47$, $b47$إذا تبين للمصلحة أن حقوق الخزانة العامة معرضة للضياع، فلرئيسها أن يطلب من رئيس الدائرة المختصة بمحكمة القضاء الإدارى أن يصدر أمرًا على عريضة بحجز الأموال التى تكفى لاستيفاء الحقوق المعرضة للضياع منها تحت يد أية جهة كانت، وتعتبر الأموال محجوزة بمقتضى هذا الأمر حجزًا تحفظيًا ولا يجوز التصرف فيها إلا إذا رفع الحجز بحكم من المحكمة أو بقرار من رئيس المصلحة أو بعد مضى ستين يومًا من تاريخ توقيع إخطار الممول أو المكلف بقيمة الضريبة طبقًا لتقدير المأمورية المختصة.$b47$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins47;

WITH ins48 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 48, 0, $h48$قانون 206/2020 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 48$h48$, $b48$ويكون إصدار أمر الحجز طبقًا للفقرة السابقة بطلب من الوزير إذا لم تكن للممول أو المكلف أموال تكفى لسداد الحقوق المعرضة للضياع غير أمواله السائلة المودعة فى البنوك .
ويرفع الحجز بقرار من رئيس الدائرة المختصة بمحكمة القضاء الإدارى إذا قام الممول أو المكلف بإيداع خزانة المحكمة مبلغًا كافيًا لسداد تلك الحقوق بدين ضمان الوفاء عند تحديدها بصفة نهائية .
وعلى قلم كتاب المحكمة التى تباشر أمامها إجراءات التنفيذ على عقار إخطار مالكه بكتاب موصى عليه بعلم الوصول بإيداع قائمة شروط البيع وذلك خلال الخمسة عشر يومًا التالية لتاريخ الإيداع .
كما على قلم كتاب المحكمة التى يحصل البيع بالمزاد أمامها، وكذلك على كل من يتولى البيع بالمزاد أن يخطر المصلحة بخطاب موصى عليه بعلم الوصول بتاريخ بيع العقارات أو المنقولات وذلك قبل تاريخ البيع بخمسة عشر يومًا على الأقل .
وكل تقصير أو تأخير فى الإخطار المنصوص عليه فى الفقرتين السابقتين يعرض المتسبب فيه للمساءلة التأديبية.$b48$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins48;

WITH ins49 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 49, 0, $h49$قانون 206/2020 > الباب السادس: التحصيل > الفصل الأول: أداء الضريبة > مادة 49$h49$, $b49$يكون للضريبة والمبالغ الأخرى المستحقة للمصلحة بمقتضى القانون الضريبى امتياز على جميع أموال المدينين بها أو الملتزمين بتوريدها والمكلفين بتحصيلها وتوريدها إلى المصلحة بحكم القانون، وذلك بالأولوية على جميع الديون الأخرى عدا المصروفات القضائية .
ويكون دين الضريبة واجب الأداء فى مقر المصلحة وفروعها دون حاجة إلى مطالبة فى مقر المدين.$b49$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins49;

WITH ins50 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 50, 0, $h50$قانون 206/2020 > الباب السادس: التحصيل > الفصل الثانى: المقاصة وبراءة الذمة > مادة 50$h50$, $b50$تقع المقاصة بقوة القانون بين ما هو مستحق للممول أو المكلف لدى المصلحة وما يكون مستحقًا عليه واجب الأداء بموجب أى قانون ضريبى تطبقه المصلحة أو أى من المصالح الإيرادية التابعة لوزارة المالية .
ويحظر على وحدات الجهاز الإدارى للدولة، ووحدات الإدارة المحلية، والهيئات العامة وغيرها من الأشخاص الاعتبارية العامة وشركات القطاع العام وقطاع الأعمال العام أداء أى مستحقات مالية لأى ممول أو مكلف أو من يمثله إلا بعد التحقق من براءة ذمته من الضريبة الواجبة الأداء والمبالغ الأخرى .
وللممول أو المكلف أو من يمثله أن يطلب من المصلحة إصدار شهادة تفيد براءة ذمته من الضريبة والمبالغ الأخرى، وعلى المصلحة إصدار هذه الشهادة خلال أربعين يومًا من تاريخ طلبها، وذلك بعد التحقق من عدم وجود أى مستحقات ضريبية عليه.$b50$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins50;

WITH ins51 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 51, 0, $h51$قانون 206/2020 > الباب السادس: التحصيل > الفصل الثالث: إسقاط الضريبة > مادة 51$h51$, $b51$يجوز إسقاط الضريبة والمبالغ الأخرى، المستحقة للمصلحة، كليًا أو جزئيًا على الممول أو المكلف فى الأحوال الآتية :
( أ ) إذا توفى عن غير تركة ظاهرة .
(ب) إذا ثبت عدم وجود مال له يمكن التنفيذ عليه .
(ج) إذا قُضى نهائيًا بإفلاسه وأقفلت التفليسة .
(د) إذا غادر البلاد لمدة عشر سنوات متصلة بغير أن يترك أموالاً يمكن التنفيذ عليها .
وإذا كان الممول أو المكلف قد أنهى نشاطه وكانت له أموال يمكن التنفيذ عليها تفى بكل أو بعض مستحقات المصلحة، ففى هذه الحالة يجب أن يتبقى له أو لورثته بعد التنفيذ ما لا يقل إيرادًا عن الشريحة المعفاة طبقًا للقانون الضريبى.$b51$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins51;

WITH ins52 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 52, 0, $h52$قانون 206/2020 > الباب السادس: التحصيل > الفصل الثالث: إسقاط الضريبة > مادة 52$h52$, $b52$تختص بالإسقاط المنصوص عليه بالمادة (51) من هذا القانون لجان يصدر بتشكيلها قرار من الوزير أو من يفوضه على أن يتم البت فى حالة الإسقاط خلال سنة ميلادية من تاريخ تقديم طلب الإسقاط أو عرضه من مأمورية الضرائب المختصة، وفى حال قبوله يتم اعتماد توصيات اللجنة بقرار من الوزير أو من يفوضه، ويجوز سحب القرار خلال المدة المقررة قانونًا إذا تبين أنه قام على سبب غير صحيح.$b52$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins52;

WITH ins53 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 53, 0, $h53$قانون 206/2020 > الباب السادس: التحصيل > الفصل الرابع: رد الضريبة > مادة 53$h53$, $b53$مع عدم الإخلال بحكم المادة (34) من هذا القانون، تلتزم المصلحة برد الضريبة السابق سدادها لها فى الحالات المنصوص عليها فى القانون الضريبى، على أن يتم الرد خلال خمسة وأربعين يومًا من تاريخ تقديم طلب الاسترداد مستوفيًا المستندات اللازمة للرد قانونًا، وإلا استحق عليها مقابل تأخير يُحسب على أساس سعر الائتمان والخصم المعلن من البنك المركزى من الأول من يناير من تاريخ استحقاق رد الضريبة مضافًا إليه 2% مع استبعاد كسور الشهر والجنيه، وذلك كله وفقًا للضوابط والأحكام التى يصدر بها قرار من الوزير.$b53$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins53;

WITH ins54 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 54, 0, $h54$قانون 206/2020 > الباب السابع: إجراءات الطعن الضريبى > الفصل الأول: طرق الإعلان > مادة 54$h54$, $b54$يكون للإعلان المرسل بكتاب موصى عليه مصحوبًا بعلم الوصول، أو بأى وسيلة إلكترونية لها الحجية فى الإثبات قانونًا، أو استلام الإعلان بموجب محضر موقع عليه من الممول أو المكلف أو من يمثله قانونًا، ذات الأثر المترتب على الإعلان الذى يتم بالطرق القانونية، بما فى ذلك إعلان المحجوز عليه بصورة من محضر الحجز .
ويكون الإعلان صحيحًا سواء تسلمه الممول أو المكلف من مأمورية الضرائب المختصة أو من لجنة الطعن المختصة أو تسلمه بمحل المنشأة أو بمحله المختار .
وفى حالة غلق المنشأة أو غياب الممول أو المكلف وتعذر إعلانه بإحدى الطرق المشار إليها، وكذلك فى حالة رفض الممول أو المكلف تسلم الإعلان، يُثبت ذلك بموجب محضر يحرره المأمور المختص أو عضو لجنة الطعن المختصة ممن لهم صفة الضبطية القضائية، من ثلاث صور تحفظ الأولى بملف الممول أو المكلف، وتلصق الثانية على مقر المنشأة، وتتعلق الثالثة بلوحة الإعلانات بالمأمورية أو لجنة الطعن المختصة، وتعلن على الموقع الإلكترونى للمصلحة، وعلى كل مأمورية أو لجنة طعن إمساك سجل تقيد فيه المحاضر المشار إليها أولاً بأول .
إذا ارتد الإعلان مؤشرًا عليه بما يفيد عدم وجود المنشأة أو عدم التعرف على عنوان الممول أو المكلف يتم إعلانه فى مواجهة النيابة العامة بعد إجراء التحريات اللازمة .
ويعتبر النشر على الوجه السابق والإعلان فى مواجهة النيابة العامة إجراءً قاطعًا للتقادم.$b54$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins54;

WITH ins55 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 55, 0, $h55$قانون 206/2020 > الباب السابع: إجراءات الطعن الضريبى > الفصل الثانى: ميعاد الطعن > مادة 55$h55$, $b55$فى الحالات التى يتم فيها إخطار الممول أو المكلف بنماذج ربط الضريبة من المصلحة، يكون للممول أو المكلف الطعن على ذلك الربط خلال ثلاثين يومًا من تاريخ علمه به، وكذلك فى الحالات المنصوص عليها فى الفقرتين الثالثة والرابعة من المادة (54) من هذا القانون، أو عدم استيفاء علم الوصول للبيانات الواردة بالتعليمات العامة للبريد، وللممول أو المكلف أن يطعن فى قرار المصلحة أو فى قرار لجنة الطعن بالربط الضريبة، بحسب الأحوال، خلال ستين يومًا من تاريخ توقيع الحجز عليه .
وفى حال عدم قيام الممول أو المكلف بالطعن على نموذج الربط فى الميعاد المحدد قانونًا، يكون الربط نهائيًا.$b55$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins55;

WITH ins56 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 56, 0, $h56$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 56$h56$, $b56$تقوم المصلحة بالبت فى الطعون المقدمة من الممولين أو المكلفين بواسطة لجان داخلية، يصدر بتشكيلها وتحديد مقارها ونطاق اختصاصها قرار من رئيس المصلحة .
ويكون الطعن المقدم من الممول أو المكلف على ربط الضريبة بصحيفة من أصل وثلاث صور يودعها مأمورية الضرائب المختصة محدثها وتسلم للممول أو المكلف، ويجب أن تتضمن صحيفة الطعن تحديد جميع أوجه الخلاف على وجه الدقة فيما ورد بنموذج ربط الضريبة، والأسباب الجوهرية التى يقوم عليها الطعن، ولا يعتد بالطعن الذى لا يتضمن أوجه الخلاف محل الطعن .
وعلى اللجنة الداخلية إخطار الممول أو المكلف بتاريخ الجلسة المحددة لنظر طعنه، على أن يكون ميعاد الجلسة خلال ثلاثين يومًا من تاريخ إيداع صحيفة الطعن، وتخطر اللجنة الممول أو المكلف بتاريخ الجلسة بكتاب موصى عليه بعلم الوصول أو بأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا، أو تسليمه نموذج الإخطار بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله، وعلى المأمورية المختصة موافاة اللجنة خلال خمسة عشر يومًا من ملف الممول أو المكلف بملف الممول أو المكلف والأوراق والمستندات مشفوعة بمذكرة الرد على أسباب الطعن المُقدم من الممول أو المكلف .
وتثبت اللجنة فى دفتر خاص بيانات الطعن وملخصًا بأوجه الخلاف التى تضمنها، وعلى اللجنة البت فى الطعن خلال ستين يومًا من تاريخ استلام الملف والأوراق والمستندات مشفوعة بمذكرة الرد المشار إليها، وللجنة مد أجل البت فى الطعن لمدة أخرى مماثلة إذا توافرت لديها أسباب جدية تبينها اللجنة فى محضر أعمالها.$b56$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins56;

WITH ins57 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 57, 0, $h57$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 57$h57$, $b57$للممول الخاضع للضريبة على المرتبات والأجور خلال ثلاثين يومًا من تاريخ استلام الإيراد الخاضع للضريبة أن يعترض على ما تم خصمه من ضرائب بطلب يقدم إلى الجهة التى قامت بالخصم .
ويتعين على هذه الجهة أن ترسل الطلب مشفوعًا بردها إلى مأمورية الضرائب المختصة خلال ثلاثين يومًا من تاريخ تقديمه، وإذا لم تقم بذلك يكون للممول التقدم بطعنه إلى المأمورية المختصة مباشرة .
كما يكون لهذه الجهة أن تعترض على ما تخطر به من فروق الضريبة الناتجة عن الفحص خلال ثلاثين يومًا من تاريخ استلام الإخطار .
وتتولى المأمورية فحص الطلب أو الاعتراض فإذا تبين لها صحته كان عليها إخطار الجهة بتعديل ربط الضريبة، أما إذا لم تقتنع بصحة الطلب أو الاعتراض فيتعين عليها إحالته إلى لجنة الطعن طبقًا لأحكام هذا القانون مع إخطار الممول أو الجهة، بحسب الأحوال، بذلك بكتاب موصى عليه بعلم الوصول أو بأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا، أو تسليمه نموذج الإخطار بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله، وذلك خلال ثلاثين يومًا من تاريخ الإحالة .
وإذا لم يكن للممول جهة يتيسر له أن يتقدم لها بالطلب المنصوص عليه بالفقرة الأولى من هذه المادة، كان له أن يتقدم به إلى مأمورية الضرائب المختصة، وعلى المأمورية فى هذه الحالة إحالة الطلب إلى اللجنة الداخلية، بحسب الأحوال.$b57$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins57;

WITH ins58 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 58, 0, $h58$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 58$h58$, $b58$تُشكل اللجان الداخلية المنصوص عليها فى الفقرة الأولى من المادة (56) من هذا القانون برئاسة أحد الموظفين بالمصلحة من درجة مدير عام على الأقل وعضوية اثنين من الموظفين بها ممن لهم صفة الضبطية القضائية، ويكون لكل لجنة أمانة فنية من عدد كاف من الموظفين بالمصلحة، ويجوز تعيين رئيس احتياطى لرئيس اللجنة حال وجود مانع قانونى يحل محله، وتكون عضوية تلك اللجان لمدة عام قابلة للتجديد، ويجب ألا يكون عضو اللجنة أو رئيسها قد سبق له نظر أى موضوع من الموضوعات المعروضة على اللجنة سواء بالفحص أو بالمراجعة.$b58$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins58;

WITH ins59 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 59, 0, $h59$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 59$h59$, $b59$على اللجنة الداخلية فى حال عدم حضور الممول أو المكلف أو من يمثله الجلسة المحددة لنظر الطعن على الرغم من إخطاره طبقًا لحكم الفقرة الثالثة من المادة (56) من هذا القانون إعادة إخطاره مرة أخرى، وفى حالة عدم حضوره تقوم اللجنة الداخلية بإحالة الخلاف إلى لجنة الطعن المختصة وتُخطر الممول أو المكلف بذلك.$b59$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins59;

WITH ins60 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 60, 0, $h60$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 60$h60$, $b60$تكون جلسات اللجنة الداخلية سرية، ويجب إثبات ما يتم تناوله بالجلسة فى محضر مؤيد بالمستندات المقدمة من الممول أو من يمثله قانونًا أو من المأمورية .
ويجب على اللجنة مناقشة جميع بنود الخلاف وأوجه الدفاع التى يقدمها الممول أو المكلف، وأن ترد على كل بند من هذه البنود .
وتصدر اللجنة قراراتها بالأغلبية، وتكون مسببة وغير معلقة على شرط، ومحددًا بها مبلغ الضريبة المستحقة وأسس حسابها على وجه الدقة .
ويجب أن يوقع محضر اللجنة الداخلية من رئيس اللجنة وأعضائها والممول أو المكلف أو من يمثله قانونًا، ويكون للممول أو المكلف الحق فى الحصول على نسخة من هذا المحضر حال توقيعه عليه .
وتحدد الدفاتر والسجلات التى يتعين على الأمانة الفنية للجنة الداخلية إمساكها بقرار من رئيس المصلحة.$b60$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins60;

WITH ins61 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 61, 0, $h61$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 61$h61$, $b61$تُشكل لجان الطعن بقرار من الوزير برئاسة أحد أعضاء الجهات القضائية، وعضوية اثنين من موظفى المصلحة ممن لهم صفة الضبطية القضائية، واثنين من خبراء الضرائب يُرشح أحدهما اتحاد الغرف التجارية أو اتحاد الصناعات، بحسب الأحوال، ويُرشح الآخر نقابة التجاريين من أحد ذوى الخبرة فى مجال الضرائب من بين المحاسبين المقيدين فى جدول المحاسبين والمراجعين لشركات الأموال بالسجل العام لمزاولى المهن الحرة للمحاسبة والمراجعة، ويجب ألا يكون لأى من أعضاء اللجنة علاقة مباشرة أو غير مباشرة بموضوع أو أطراف النزاع.$b61$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins61;

WITH ins62 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 62, 0, $h62$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 62$h62$, $b62$تختص لجان الطعن بالفصل فى أوجه الخلاف بين الممول أو المكلف والمصلحة المحددة بصحيفة الطعن .
وتخطر اللجنة كلاً من الممول أو المكلف والمصلحة بميعاد جلسة نظر الطعن قبل انعقادها بعشرة أيام على الأقل وذلك بكتاب موصى عليه بعلم الوصول أو بأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا، أو تسليمه نموذج الإخطار بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله، ولها أن تطلب من كل من المأمورية والممول أو المكلف تقديم ما تراه ضروريًا من البيانات والأوراق، وعلى الممول أو المكلف حضور أمام اللجنة بنفسه أو من يمثله وإلا فصلت اللجنة فى الطعن فى ضوء المستندات المقدمة.$b62$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins62;

WITH ins63 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 63, 0, $h63$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 63$h63$, $b63$تخطر اللجنة كلاً من الممول أو المكلف والمصلحة بميعاد جلسة نظر الطعن قبل انعقادها بعشرة أيام على الأقل وذلك بكتاب موصى عليه بعلم الوصول، أو بأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا، أو تسليمه نموذج الإخطار بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله، ولها أن تطلب من كل من المأمورية والممول أو المكلف تقديم ما تراه ضروريًا من البيانات والأوراق .
وعلى الممول أو المكلف الحضور أمام اللجنة بنفسه أو من يمثله وإلا فصلت اللجنة فى الطعن فى ضوء المستندات المقدمة.$b63$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins63;

WITH ins64 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 64, 0, $h64$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الأول: المراحل الإدارية لنظر الطعن > مادة 64$h64$, $b64$تصدر اللجنة قراراتها بالأغلبية، وذلك فى حدود تقدير المصلحة وطلبات الممول أو المكلف، ويعدل ربط الضريبة وفقًا لقرار اللجنة، فإذا لم تكن الضريبة قد حُصلت يكون تحصيلها بمقتضى هذا القرار .
وفى جميع الأحوال، يجب على رئيس اللجنة وأمين سر اللجنة توقيع قرارات اللجنة خلال أسبوع على الأكثر من تاريخ صدورها .
ويكون إعلان كل من المصلحة والممول أو المكلف بقرار اللجنة بكتاب موصى عليه بعلم الوصول وبأى وسيلة إلكترونية لها حجية فى الإثبات قانونًا، أو تسليمه بمقر العمل أو المأمورية بموجب محضر يوقع عليه الممول أو المكلف أو من يمثله .
وتكون الضريبة واجبة الأداء من واقع قرار اللجنة، ولا يمنع الطعن فى قرارها أمام المحكمة المختصة من تحصيل الضريبة، أو اتخاذ إجراءات الحجز الإدارى لاستئدائها.$b64$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins64;

WITH ins65 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 65, 0, $h65$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الثانى: المرحلة القضائية لنظر الطعن > مادة 65$h65$, $b65$لكل من المصلحة والممول والمكلف الطعن فى قرار لجنة الطعن أمام محكمة القضاء الإدارى المختصة خلال ستين يومًا من اليوم التالى لتاريخ الإعلان بالقرار .
واستثناءً من أحكام قانون مجلس الدولة الصادر بالقانون رقم 47 لسنة 1972، يكون الفصل فى الدعاوى والطعون الضريبية دون العرض على هيئة مفوضى الدولة، وللمحكمة نظر هذه الدعاوى والطعون فى جلسة سرية، ويكون الحكم فيها دائمًا على وجه السرعة.$b65$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins65;

WITH ins66 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 66, 0, $h66$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الثالث: طلب الصلح فى الطعن > مادة 66$h66$, $b66$يجوز للممول أو المكلف أو من يمثله طلب إجراء تسوية لأوجه الخلاف محل الطعن بموجب طلب يقدم إلى مأمورية الضرائب المختصة قبل حجز الطعن للقرار، ويجب على المأمورية إخطار اللجنة بهذا الطلب خلال ثلاثين يومًا من تاريخ تقديمه، والبت فيه خلال ثلاثين يومًا من تاريخ إخطارها بالطلب، وعلى لجنة الطعن حال إخطارها بتقديم الطلب وقف نظره إلى حين إخطارها من جانب المأمورية بما تم فيه، وفى جميع الأحوال، يتعين على المأمورية المختصة إخطار لجنة الطعن المختصة خلال خمسة أيام عمل من تاريخ انتهاء مدة الثلاثين يومًا بما تم فى الطلب، وعلى لجنة الطعن حال اتفاق المأمورية والممول أو المكلف على تسوية النزاع إثبات هذه التسوية فى محضر يوقع من الطرفين، ويُعد هذا المحضر سندًا تنفيذيًا.$b66$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins66;

WITH ins67 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 67, 0, $h67$قانون 206/2020 > الباب الثامن: مراحل الطعن الضريبى > الفصل الرابع: إعادة النظر فى الربط النهائى > مادة 67$h67$, $b67$على المصلحة تصحيح الربط النهائى المستند إلى تقدير أو تعديل مأمورية الضرائب المختصة أو قرار لجنة الطعن بناءً على طلب يقدمه صاحب الشأن خلال خمس سنوات من التاريخ الذى أصبح فيه الربط نهائيًا، وذلك فى الحالات الآتية :
( أ ) عدم مزاولة صاحب الشأن أى نشاط مما ربطت عليه الضريبة .
(ب) ربط الضريبة على نشاط معفى منها قانونًا .
(ج) ربط الضريبة على إيرادات غير خاضعة للضريبة، ما لم ينص القانون على خلاف ذلك .
(د) عدم تطبيق الإعفاءات المقررة قانونًا .
(هـ) الخطأ فى تطبيق سعر الضريبة .
(و) الخطأ فى نوع الضريبة التى ربطت على الممول .
(ز) عدم ترحيل الخسائر على خلاف حكم القانون .
(ح) عدم خصم الضرائب واجبة الخصم .
(ط) عدم خصم القيمة الإيجارية للعقارات التى تستأجرها المنشأة .
(ى) عدم خصم التبرعات التى تحققت شروط خصمها قانونًا .
(ك) تحميل بعض السنوات الضريبية بإيرادات أو مصروفات تخص سنوات أخرى .
(ل) ربط ذات الضريبة على ذات الإيرادات أكثر من مرة .
(م) أى حالات أخرى يتم إضافتها بقرار من الوزير .
(ن) وعلى وجه العموم، فى الحالات التى يحصل فيها صاحب الشأن على مستندات وأوراق قاطعة من شأنها أن تؤدى إلى عدم صحة الربط .
وتختص بالنظر فى الطلبات المشار إليها لجنة أو أكثر تسمى "لجنة إعادة النظر فى الربط النهائى" يكون من بين أعضائها عضو من مجلس الدولة بدرجة مستشار مساعد على الأقل يرشحه المجلس، ويصدر بتشكيلها وتحديد اختصاصها ومقارها قرار من رئيس المصلحة، ولا يكون قرار اللجنة نافذًا إلا بعد اعتماده من رئيس المصلحة .
ويُخطر كل من صاحب الشأن أو الممول أو المكلف، بحسب الأحوال، مأمورية الضرائب المختصة بقرار اللجنة، وعلى المأمورية تعديل الربط وفقًا لهذا القرار.$b67$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins67;

WITH ins68 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 68, 0, $h68$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 68$h68$, $b68$مع عدم الإخلال بأى عقوبة أشد ينص عليها قانون العقوبات أو أى قانون آخر، يعاقب على الجرائم المبينة فى المواد التالية بالعقوبات المنصوص عليها فيها.$b68$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins68;

WITH ins69 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 69, 0, $h69$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 69$h69$, $b69$يُعاقب بغرامة لا تقل عن ثلاثة آلاف جنيه ولا تجاوز خمسين ألف جنيه فضلاً عن الضريبة والمبالغ الأخرى المستحقة، كل من :
( أ ) تأخر فى تقديم الإقرار وأداء الضريبة عن المدد المحددة فى المادة (31) من هذا القانون بما لا يجاوز ستين يومًا .
(ب) قدم بيانات خاطئة بالإقرار إذا ظهرت زيادة فى الضريبة عما ورد به .
(ج) لم يمكن موظفى المصلحة من القيام بواجباتهم فى الرقابة والتفتيش والمعاينة والمراجعة وطلب المستندات أو الاطلاع عليها .
(د) لم يلتزم بأحكام المواد (6 ، 7 ، 8 ، 9 ، 10 ، 11 ، 12 ، 13 ، 14 ، 15 ، 21 ، 29 ، 32/فقرتين أولى وثانية) من هذا القانون .
وتضاعف العقوبة بحديها الأدنى والأقصى لثلاثة أمثالها فى حالة العود.$b69$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins69;

WITH ins70 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 70, 0, $h70$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 70$h70$, $b70$يُعاقب على عدم تقديم الإقرار الضريبى المنصوص عليه فى المادة (31) من هذا القانون لمدة تتجاوز ستين يومًا من تاريخ انتهاء المواعيد المحددة لتقديمه بغرامة لا تقل عن خمسة آلاف جنيه ولا تجاوز مائتى ألف جنيه .
وتضاعف العقوبة المنصوص عليها فى الفقرة الأولى من هذه المادة فى حالة تكرار الجريمة خلال ثلاث سنوات.$b70$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins70;

WITH ins71 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 71, 0, $h71$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 71$h71$, $b71$يُعاقب بغرامة لا تقل عن عشرين ألف جنيه ولا تجاوز مائة ألف جنيه كل من يخالف أحكام المواد (24 ، 28 ، 35 ، 37/فقرتين أولى ورابعة ، 38/فقرات أولى وثانية وثالثة) من هذا القانون. ويُعاقب بغرامة لا تزيد على خمسين ألف جنيه كل من لم يلتزم بالاحتفاظ بالدفاتر والسجلات الورقية والإلكترونية خلال المدة المقررة قانونًا.$b71$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins71;

WITH ins72 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 72, 0, $h72$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 72$h72$, $b72$يُعاقب على مخالفة حكم المادة (20) من هذا القانون بالحبس مدة لا تقل عن سنة ولا تجاوز ثلاث سنوات وبغرامة لا تقل عن خمسين ألف جنيه ولا تزيد على مائتين وخمسين ألف جنيه، أو بإحدى هاتين العقوبتين.$b72$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins72;

WITH ins73 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 73, 0, $h73$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 73$h73$, $b73$فى حالة وقوع أى فعل من أفعال التهرب من الضريبة من أحد الأشخاص الاعتبارية المنصوص عليها فى القانون الضريبى، يكون المسئول عنه الشريك المسئول أو المدير أو عضو مجلس الإدارة المنتدب أو رئيس مجلس الإدارة ممن يتولون الإدارة الفعلية، بحسب الأحوال، متى ثبت علمه بها وكان بإخلاله بالواجبات التى تفرضها عليه الإدارة قد ساهم فى وقوع الجريمة.$b73$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins73;

WITH ins74 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 74, 0, $h74$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 74$h74$, $b74$لا يجوز رفع الدعوى الجنائية عن الجرائم المنصوص عليها فى هذا القانون أو القانون الضريبى أو اتخاذ أى إجراء من إجراءات التحقيق فيها إلا بناءً على طلب كتابى من الوزير أو من يفوضه.$b74$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins74;

WITH ins75 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 75, 0, $h75$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 75$h75$, $b75$يجوز للوزير أو من يفوضه التصالح فى الجرائم المنصوص عليها فى هذا القانون أو القانون الضريبى، ومن يرغب فى التصالح أن يدفع قبل رفع الدعوى الجنائية مبلغًا يعادل (100%) من قيمة المستحقات الضريبية طبقًا لهذا القانون أو القانون الضريبى، ويكون الدفع إلى خزانة المصلحة أو إلى من يُرخص له فى ذلك من الوزير .
ولا يسقط الحق فى التصالح برفع الدعوى الجنائية إلى المحكمة المختصة إذا دفع (150%) من قيمة المستحقات الضريبية لهذا القانون أو القانون الضريبى، وذلك قبل صدور حكم فى الموضوع، فإذا صدر حكم بات جاز التصالح نظير دفع (175%) من قيمة المستحقات الضريبية طبقًا لهذا القانون أو للقانون الضريبى.$b75$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins75;

WITH ins76 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 76, 0, $h76$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 76$h76$, $b76$للوزير أو من يفوضه التصالح فى الجرائم المنصوص عليها فى القانون الضريبى التى تقع من المحاسب مقابل سداد تعويض لا يقل عن الحد الأدنى للغرامة المنصوص عليها فيه ولا يجاوز الحد الأقصى لهذه الغرامة.$b76$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins76;

WITH ins77 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 77, 0, $h77$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 77$h77$, $b77$يترتب على التصالح انقضاء الدعوى الجنائية وإلغاء ما ترتب على قيامها من آثار بما فى ذلك العقوبة المقضى بها، وتأمر النيابة العامة بوقف تنفيذ العقوبة إذا تم التصالح أثناء تنفيذها.$b77$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins77;

WITH ins78 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 78, 0, $h78$قانون 206/2020 > الباب العاشر: الأحكام الختامية > مادة 78$h78$, $b78$للمصلحة تبادل المعلومات لأغراض الضريبة بين السلطات الضريبية فى الدول التى تكون بينها وبين مصر اتفاقيات ضريبية دولية، وفى حدود ما تنص عليه أحكام هذه الاتفاقيات، كما لها أن تبرم بروتوكولات أو اتفاقيات مع الجهات الحكومية والهيئات العامة والنقابات والجمعيات وغيرها من الأشخاص الاعتبارية تسمح بتبادل المعلومات فيما بينها لأغراض تطبيق القانون، وفى حدود عدم الإخلال بالأسرار التجارية أو المهنية للممول أو المكلف.$b78$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins78;

WITH ins79 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 79, 0, $h79$قانون 206/2020 > الباب العاشر: الأحكام الختامية > مادة 79$h79$, $b79$يجوز للنيابة العامة فى الأحوال التى تقدرها تكليف وزارة المالية بإخطار الجهات الحكومية والبنوك وشركات القطاع العام وقطاع الأعمال العام التى يتعامل معها الممول أو المكلف الذى يحال إلى التحقيق أو المحاكمة فى إحدى جرائم التهرب الضريبى محل التحقيق أو المحاكمة، وعلى هذه الجهات والبنوك والشركات وقف التعامل مؤقتًا مع الممول أو المكلف إلى حين حفظ التحقيق أو الحكم بالبراءة أو انقضاء الدعوى الجنائية بالتصالح.$b79$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins79;

WITH ins80 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 80, 0, $h80$قانون 206/2020 > الباب العاشر: الأحكام الختامية > مادة 80$h80$, $b80$يجوز للمصلحة نشر قوائم بأسماء الممولين أو المكلفين الذين صدرت ضدهم أحكام باتة بعقوبة سالبة للحرية فى إحدى جرائم التهرب الضريبى .
ويتم النشر فى جريدتين يوميتين على الأقل واسعتى الانتشار.$b80$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins80;

WITH ins81 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 81, 0, $h81$قانون 206/2020 > الباب العاشر: الأحكام الختامية > مادة 81$h81$, $b81$تسرى أحكام هذا القانون على الضرائب التى تطبقها مصلحة الضرائب العقارية فيما لا يتعارض مع أحكام القوانين المنظمة لهذه الضرائب، وذلك بقرار من مجلس الوزراء، بناءً على عرض الوزير، عند الانتهاء من تطوير المصلحة المذكورة وميكنتها.$b81$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-20'::date, 'active' FROM ins81;

-- ===== كتلة التحقق النهائية =====

DO $verify103$
DECLARE
    v_law_id uuid;
    v_total INT;
    v_versions INT;
    v_distinct_main INT;
    v_min_no INT;
    v_max_no INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 103: تعذر العثور على سجل القانون بعد الإدراج.';
    END IF;

    SELECT COUNT(*) INTO v_total FROM articles WHERE law_id = v_law_id;
    IF v_total <> 87 THEN
        RAISE EXCEPTION 'migration 103: عدد المواد المتوقع 87 لكن الفعلى %', v_total;
    END IF;

    SELECT COUNT(*) INTO v_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id;
    IF v_versions <> 87 THEN
        RAISE EXCEPTION 'migration 103: عدد النسخ المتوقع 87 لكن الفعلى %', v_versions;
    END IF;

    SELECT COUNT(DISTINCT article_no) INTO v_distinct_main
    FROM articles WHERE law_id = v_law_id AND article_suffix_order >= 0;
    IF v_distinct_main <> 81 THEN
        RAISE EXCEPTION 'migration 103: عدد أرقام المواد الأساسية المتوقع 81 لكن الفعلى %', v_distinct_main;
    END IF;

    SELECT MIN(article_no), MAX(article_no) INTO v_min_no, v_max_no
    FROM articles WHERE law_id = v_law_id AND article_suffix_order >= 0;
    IF v_min_no <> 1 OR v_max_no <> 81 THEN
        RAISE EXCEPTION 'migration 103: مدى أرقام المواد المتوقع 1-81 لكن الفعلى %-%', v_min_no, v_max_no;
    END IF;

    RAISE NOTICE 'migration 103 (قانون الإجراءات الضريبية الموحد 206/2020 - النص التأسيسى): تم بنجاح. % مادة، % نسخة، مدى الأرقام 1-81 متصل دون فجوات.', v_total, v_versions;
END $verify103$;

COMMIT;
