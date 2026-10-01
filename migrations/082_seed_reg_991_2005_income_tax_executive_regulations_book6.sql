-- =====================================================================
-- Migration 082: اللائحة التنفيذية لقانون الضريبة على الدخل
--                        91/2005 (قرار وزير المالية 991/2005) - الكتاب
--                        السادس والأخير (التزامات الممولين وغيرهم) -
--                        الدفعة 6 من 6 (الأخيرة - تكتمل اللائحة بالكامل)
-- =====================================================================
--
-- المصدر الأساسى: نسخة PDF رفعها صاحب المشروع مباشرة (55 صفحة) - مسح
--   ضوئى كامل للوقائع المصرية، العدد 295 تابع، 27 ديسمبر 2005، موقَّع
--   باسم وزير المالية د. يوسف بطرس غالى. بلا طبقة نص قابلة للاستخراج
--   الآلى (مسح ضوئى بحت) - نُقل كل نص هذه الدفعة من القراءة البصرية
--   المباشرة لصفحات الـPDF (صفحات الوقائع المصرية 41-56، وهى آخر صفحات
--   الوثيقة، تنتهى بخاتمة الطباعة الرسمية بعد المادة 146 مباشرة).
--
-- تعتمد هذه الهجرة على سجل laws الذى أنشأته migration 077 - لا تُعيد
--   إدراجه، وتتحقق كتلة التحقق النهائية من وجوده صراحة.
--
-- كتلة التحقق مبنية من البداية وفقاً للإصلاح الجذرى المُطبَّق على
--   077-080: لا يوجد أى تحقق من "إجمالى تراكمى عبر كامل سجل اللائحة"
--   يعتمد على هجرات لاحقة - كل التحقق الأساسى مقيَّد بنطاق مواد هذا
--   الكتاب حصراً. بالإضافة لذلك، ولأن 082 هى آخر هجرة فى سلسلة اللائحة
--   (لا يوجد كتاب سابع سيضيف صفوفاً لاحقاً لنفس السجل)، تضيف كتلة
--   التحقق هنا تحققاً نهائياً آمناً من اكتمال اللائحة بالكامل.
--
-- محتوى هذه الدفعة (082): الكتاب السادس والأخير بالكامل - التزامات
--   الممولين وغيرهم، مواد 90-146 (57 مادة،
--   article_suffix_order=0)، موزعة على 6 أبواب: الباب الأول (الإخطار
--   وإمساك الدفاتر، 90-101)، الباب الثانى (الإقرارات الضريبية،
--   102-113)، الباب الثالث (ربط الضريبة، 114-117)، الباب الرابع (الفحص
--   والتحريات، 118-122)، الباب الخامس (ضمانات التحصيل، 123-128)،
--   الباب السادس (إجراءات الطعن، 129-146).
--
-- سياسة effective_from: تاريخ واحد موحَّد = '2005-12-28'.
--
-- عدد صفوف هذه الدفعة: 57 مادة (مدى الأرقام 90-146).
--   الإجمالى التراكمى النهائى لكامل اللائحة (077+078+079+080+081+082) =
--   150 صفاً (146 مادة موضوعية + مواد الإصدار).
--
-- هذه آخر هجرة فى سلسلة بناء اللائحة التنفيذية 991/2005 - بعد نشرها
--   تكتمل اللائحة بالكامل (146 مادة، 6 كتب، 6 هجرات 077-082).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

-- ===== الكتاب السادس: التزامات الممولين وغيرهم (article_suffix_order = 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 90, 0, $h1$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 90$h1$, $b1$يكون إخطار المأمورية المختصة بمزاولة نشاط تجاري أو صناعي أو مهني أو حرفي أو نشاط غير تجاري خلال ثلاثين يوماً من تاريخ بدء مزاولة النشاط على النموذج رقم (16 حصر)، والنموذج رقم (17 حصر)، بحسب الأحوال.
وعلى المأمورية المختصة فتح ملف ضريبي للممول فور إخطارها.$b1$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 91, 0, $h2$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 91$h2$, $b2$يكون طلب استخراج البطاقة الضريبية لكل من يُزاول نشاطاً تجارياً أو صناعياً أو حرفياً أو نشاطاً غير تجاري، وكل من يمارس نشاطاً مهنياً على النموذج رقم (18 حصر).$b2$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 92, 0, $h3$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 92$h3$, $b3$يُعد فى حكم الإخطار بمزاولة النشاط واستخراج البطاقة الضريبية، قيام الممول باستخدام النموذج الإلكتروني المعد لذلك من خلال شبكة المعلومات الإلكترونية (بوابة الحكومة الإلكترونية) خدمة ممولي الضريبة على الدخل.$b3$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 93, 0, $h4$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 93$h4$, $b4$يجب أن تتضمن البطاقة الضريبية للممول، سواء صدرت على هيئة ورقية مكتوبة أو فى شكل بطاقة ذكية، البيانات الآتية:
1- رقم التسجيل الضريبي
2- الرقم المسلسل للبطاقة طبقاً لما هو وارد فى سجل قيد البطاقة الضريبية
3- تاريخ إصدارها
4- كود المأمورية
5- اسم الممول
6- عنوان الممول
7- رقم الملف الضريبي
8- نشاط الممول
9- عنوان النشاط " السمة التجارية "
10- رقم التأمينات الاجتماعية
11- رقم السجل التجارى
12- رقم سجل الشركات
13- عنوان المركز الرئيسي والفروع والمخازن
14- تاريخ بدء مزاولة كل نشاط
15- الكيان القانونى
16- بيانات الإقرار [ سنة الإقرار - تاريخ الإقرار - توقيع المختص بالمأمورية ]
17- بيانات الإعفاءات الضريبية
18- بيان ما إذا كان الممول خاضعا لنظام الدفعات المقدمة.
19- تاريخ الإصدار و تاريخ الانتهاء
20- أى تغيير فى بيانات البطاقة$b4$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 94, 0, $h5$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 94$h5$, $b5$يُقدم طلب استخراج البطاقة الضريبية من الممول أو وكيله إلى المأمورية المختصة التي يتبعها الممول، مرفقاً به المستندات الآتية:
1. صورة عقد الإيجار.
2. صورة عقد شركة الأشخاص أو نسخة من عدد الوقائع المصرية أو النشرة الخاصة التى تم النشر فيها عن الشركة أو صورة من عقدها ونظامها الأساسي.

وعلى المأمورية قيد الطلبات المقدمة فى سجل خاص حسب ترتيب تاريخ ورودها، ويوقع على البطاقة كل من المأمور والمراجع، وتُعتمد من رئيس المأمورية وتختم بختمها، وتسلم للممول خلال أسبوع على الأكثر من تاريخ تقديم الطلب.

وينشأ بكل مأمورية سجل خاص تُقيد به بيانات كل بطاقة.$b5$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 95, 0, $h6$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 95$h6$, $b6$تكون مدة سريان البطاقة الضريبية خمس سنوات من تاريخ إصدارها، وتعتبر البطاقة لاغية وغير صالحة للتعامل بها عند انتهاء هذه المدة على أن تثبت بالبطاقة فى مكان ظاهر عبارة تفيد ذلك.$b6$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 96, 0, $h7$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 96$h7$, $b7$لا يجوز إصدار أكثر من بطاقة ضريبية للممول الواحد، فإذا كان للممول أكثر من نشاط تجارى أو صناعى أو مهني أو أكثر من فرع، تكون المأمورية المختصة بإصدار البطاقة الضريبية مأمورية المركز الرئيسي.$b7$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 97, 0, $h8$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 97$h8$, $b8$فى تطبيق حكم المادة (75) من القانون، تصدر البطاقة الضريبية بلونين:
اللون الأخضر: للأشخاص الطبيعيين.
اللون الأحمر: للأشخاص الاعتبارية.

وإذا اختار الممول نظام الدفعات المقدمة، فيجب التأشير على البطاقة الضريبية بما يفيد ذلك.$b8$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 98, 0, $h9$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 98$h9$, $b9$على المختصين فى الجهات المنصوص عليها فى المادة (76) من القانون، إخطار الإدارة العامة للحصر والإقرارات بمصلحة الضرائب بالنسبة لمحافظة القاهرة أو منطقة الضرائب بالنسبة للمحافظات التى يوجد بها منطقة ضرائب واحدة أو منطقة ضرائب أول بالنسبة لباقى المحافظات خلال مدة أقصاها نهاية الشهر التالى للشهر الذى صدر فيه الترخيص بالطبع أو النشر، وذلك على النموذج رقم (20 حصر).$b9$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 99, 0, $h10$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 99$h10$, $b10$على المختصين فى الجهات المنصوص عليها فى المادة (77) من القانون عند منح أى ترخيص لمزاولة تجارة أو صناعة أو حرفة أو مهنة أو لبناء عقار أو لاستغلال عقار فى مزاولة تجارة أو صناعة أو مهنة أو منح امتياز أو التزام أو إذن مزاولة نشاط إخطار الإدارة العامة للحصر والإقرارات بمصلحة الضرائب بالقاهرة أو منطقة الضرائب بالنسبة لمحافظة القاهرة أو منطقة الضرائب بالنسبة للمحافظات التى يوجد بها منطقة ضرائب واحدة أو منطقة ضرائب أول بالنسبة لباقى المحافظات خلال مدة أقصاها نهاية الشهر التالى للشهر الذى صدر فيه الترخيص، موضحاً به اسم طالب الترخيص وجميع البيانات ذات العلاقة، وذلك على النماذج أرقام (21 حصر) و (22 حصر) و (23 حصر) و (24 حصر) بحسب الأحوال.$b10$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 100, 0, $h11$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 100$h11$, $b11$يكون الإخطار عند توقف المنشأة، طبقاً لحكم الفقرة الثالثة من المادة (79) من القانون، على النموذج رقم (25 توقف). ويجوز أن يتم هذا الإخطار عن طريق الاتصال الإلكتروني بالمأمورية المختصة وفقاً لضوابط التوقيع الإلكتروني باستخدام النماذج المعدة بقوائم الخدمات الإلكترونية المتاحة بمعرفة المصلحة، ويعتبر استلاماً لها إخطار الممول برسالة الوصول المرسلة إليه من المصلحة.

ويعتبر من حالات عدم تحقيق أية إيرادات للممول بعد تاريخ التوقف:
1 - مغادرة البلاد نهائياً.
2 - الغلق الجبرى أو الإدارى
3 - ترك مكان مزاولة النشاط لمالك العقار
4 - الاستيلاء على مكان مزاولة النشاط للمنفعة العامة.

وذلك كله ما لم يثبت للمصلحة أن الممول حقق إيرادات بعد تاريخ التوقف.$b11$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins11;

WITH ins12 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 101, 0, $h12$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > مادة 101$h12$, $b12$يكون طلب الممول الذى يرغب فى التوقف عن مزاولة النشاط أو التنازل عن المنشأة أو مغادرة البلاد مغادرة نهائية تحديد موقفه الضريبي حتى تاريخ توقفه أو تنازله أو مغادرته البلاد، طبقاً للمادة (81) من القانون، على النموذج رقم (26 طلبات)، بشرط أن يكون قد قدم الإقرارات الملتزم بها قانوناً، وعلى المأمورية المختصة إجابته إلى طلبه خلال تسعين يوماً من تاريخ استلام الطلب بعد سداد رسم قدره خمسة جنيهات.$b12$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins12;

WITH ins13 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 102, 0, $h13$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 102$h13$, $b13$على كل ممول من الأشخاص الطبيعيين أن يقدم إلى مأمورية الضرائب المختصة قبل أول إبريل من كل سنة الإقرار الضريبي المنصوص عليه فى المادة (82) من القانون على النموذج رقم (27 إقرارات)، ويجب أن يقدم هذا الإقرار من أصل وصورة، سواء تم تسليمه للمأمورية المختصة أو تم إرساله بالبريد بكتاب موصى عليه بعلم الوصول، ويتم ختم الإقرار المقدم بخاتم المأمورية، كما يتم ختم الصورة التى تسلم للممول أو تعاد إليه بالبريد دون مراجعة الإقرار أو إبداء رأي فيه.$b13$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins13;

WITH ins14 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 103, 0, $h14$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 103$h14$, $b14$على كل ممول من الأشخاص الاعتبارية، المنصوص عليها فى المادة (48) من القانون، أن يقدم إلى المأمورية المختصة قبل أول مايو من كل سنة أو خلال الأربعة أشهر التالية لتاريخ انتهاء السنة المالية إقراره الضريبي على النموذج رقم (28 إقرارات)، ويجب تقديم هذا الإقرار من أصل وصورة، سواء تم تسليمه للمأمورية المختصة أو تم إرساله بالبريد بكتاب موصى عليه بعلم الوصول، ويتم ختم الإقرار المقدم بخاتم المأمورية، كما يتم ختم الصورة التى تسلم للممول أو تعاد إليه بالبريد دون مراجعة الإقرار أو إبداء رأي فيه.$b14$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins14;

WITH ins15 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 104, 0, $h15$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 104$h15$, $b15$يجوز للممول إرسال الإقرار الضريبي من خلال بوابة الحكومة الإلكترونية (خدمة ممولي ضريبة الدخل) أو من خلال أية قناة إلكترونية أخرى تحددها وزارة المالية، على أن يقوم الممول بتسجيل نفسه والحصول على كلمة المرور السرية، ويعتبر الممول مسئولاً عما يقدمه مسئولية كاملة إما من خلال توقيع إقرار بذلك عند طلبه الاستفادة من هذه الخدمة أو أن يقدم توقيعاً إلكترونياً مجازاً من المصلحة.

وفى جميع الأحوال، يجب أن يقدم الممول ما يفيد سداد الضريبة المستحقة من واقع الإقرار بإحدى وسائل الدفع الإلكترونية المجازة المنصوص عليها فى المادة (82) من هذه اللائحة أو التى تقرها وزارة المالية.$b15$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins15;

WITH ins16 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 105, 0, $h16$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 105$h16$, $b16$يعتبر اعتماد الإقرار من أحد المحاسبين المقيدين بالسجل العام للمحاسبين والمراجعين طبقاً لأحكام القانون رقم 133 لسنة 1951 بمزاولة مهنة المحاسبة والمراجعة أو من الجهاز المركزى للمحاسبات، بحسب الأحوال، إقراراً يساًن صافى الربح الخاضع للضريبة أو الخسارة كما ورد بالإقرار قد أُعد وفقاً لأحكام القانون وهذه اللائحة.$b16$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins16;

WITH ins17 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 106, 0, $h17$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 106$h17$, $b17$لبنوك وشركات ووحدات القطاع العام وشركات قطاع الأعمال العام والأشخاص الاعتبارية العامة تقديم إقرار نهائي على النموذج رقم (29 إقرارات) خلال ثلاثين يوماً من تاريخ اعتماد الجمعية العمومية لحساباتها، وأداء فروق الضريبة المستحقة من واقعه.$b17$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins17;

WITH ins18 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 107, 0, $h18$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 107$h18$, $b18$تسرى على المشروعات الصغيرة، المنصوص عليها فى المادة (18) من القانون قواعد وأسس المحاسبة الضريبية وإجراءات تحصيل الضريبة طبقاً لقرار وزير المالية الذى يصدر فى هذا الشأن.$b18$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins18;

WITH ins19 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 108, 0, $h19$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 108$h19$, $b19$تعد بوابة الحكومة الإلكترونية ( خدمة ممولي الضريبة على الدخل ) أو القناة التى تحددها وزارة المالية إحدى وسائل المراسلة التى تستخدمها كل من المصلحة والممول فى كل ما يتصل بالخدمات التى تقدمها مصلحة الضرائب للمسئولين من خلال هذه القنوات ومن ذلك:
1 - طلب استخراج بطاقة ضريبية أو تجديدها.
2 - إخطارات بتحديد مواعيد جلسات لجان داخلية أو طعن أو أي لجان أخرى.
3 - غير ذلك مما تُثبيحه الوزارة أو المصلحة من خدمات إلكترونية.$b19$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins19;

WITH ins20 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 109, 0, $h20$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 109$h20$, $b20$للمصلحة تصحيح الأخطاء الحسابية الواردة بالإقرار الضريبي بعد تقديمه ويتم إخطار الممول بنتيجة التصحيح وإرفاق شيك بالمبلغ المستحق للممول أو مطالبته بالفروق المستحقة عليه على النموذج رقم (30 إقرارات) ويكون طلب الممول مد ميعاد تقديم إقراره الضريبي، طبقا للمادة (85) من القانون، على النموذج رقم (26 طلبات)، ويجوز تقديم الطلب بالأساليب الإلكترونية أو بكتاب موصى عليه بعلم الوصول على أن يكون تاريخ وصول الكتاب سابقاً على تاريخ انتهاء المدة المحددة لتقديم الإقرار بخمسة عشر يوماً.$b20$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins20;

WITH ins21 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 110, 0, $h21$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 110$h21$, $b21$على الجهات الملتزمة بتطبيق أحكام الخصم تحت حساب الضريبة أداء المبالغ المخصومة فى موعد أقصاه آخر أبريل و يوليو و أكتوبر و يناير من كل عام وفقاً للسجلات المنصوص عليها فى المادة (111) من هذه اللائحة، ويجب أن تتضمن هذه السجلات البيانات التالية عن كل فترة ضريبية:
1. اسم الشخص المتلقي لهذه المبالغ ورقم ملفه الضريبي والمأمورية المختصة.
2. مقدار المبالغ المدفوعة ونسبة الخصم تحت حساب الضريبة.
3. رقم الشيك الخاص بتوريد هذه المبالغ وتاريخه.

وعلى هذه الجهات توفير السجلات المشار اليها للفحص بمعرفة الإدارة العامة للتحصيل تحت حساب الضريبة المختصة، ويجب إرسال صورة من هذه السجلات الي الإدارات المختصة.$b21$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins21;

WITH ins22 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 111, 0, $h22$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 111$h22$, $b22$على الجهات الملتزمة بتطبيق أحكام الخصم والتحصيل تحت حساب الضريبة إمساك السجلين الآتيين:
1 - سجل أو أكثر حسب عدد المتعاملين معها يتضمن:
أ - اسم الشخص المتلقي لهذه المبالغ ورقم ملفه الضريبي والمأمورية المختصة.
ب - مقدار المبالغ المدفوعة ونسبة الخصم تحت حساب الضريبة.
2 - سجل تدون به حركة التسديدات التى يتم توريدها كل ثلاثة أشهر مسع توضيح بيانات الشيك والجهة المستفيدة.$b22$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins22;

WITH ins23 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 112, 0, $h23$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 112$h23$, $b23$لا يجوز للممول تقديم إقرار ضريبي معدل، طبقا للمادة (87) من القانون، إذا استعمل إحدى الطرق التى يعد فيها متهرباً طبقا للمادة (133) من القانون، وتم اكتشاف ذلك من قبل المصلحة.$b23$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins23;

WITH ins24 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 113, 0, $h24$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثانى: الإقرارات الضريبية > مادة 113$h24$, $b24$فى تطبيق حكم المادة (88) من القانون، لا يجوز للمصلحة عدم الاعتداد بالدفاتر والسجلات التى يمسكها الممول أو إهدارها إلا إذا أثبتت المصلحة بالمستندات عدم صحة ما ورد بهذه الدفاتر والسجلات.$b24$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins24;

WITH ins25 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 114, 0, $h25$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثالث: ربط الضريبة > مادة 114$h25$, $b25$يُقصد بربط الضريبة، فى تطبيق حكم المادة (89) من القانون، تحديد دين الضريبة المستحقة من واقع الإقرار الضريبي للممول.$b25$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins25;

WITH ins26 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 115, 0, $h26$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثالث: ربط الضريبة > مادة 115$h26$, $b26$يكون إخطار الممول بعناصر ربط الضريبة في الحالات المنصوص عليها في المادة (90) من القانون وبقيمتها على النموذج رقم (19 ضريبة).$b26$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins26;

WITH ins27 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 116, 0, $h27$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثالث: ربط الضريبة > مادة 116$h27$, $b27$ينقطع التقادم، فى تطبيق حكم الفقرة الثانية من المادة (91) من القانون، بالإخطار بعناصر ربط الضريبة أو بالتنبيه على الممول بأدائها أو بالإحالة الى لجان الطعن.

كما ينقطع التقادم لأي من الأسباب المنصوص عليها فى القانون المدني كالمطالبة القضائية ولو رفعت الدعوى إلى محكمة غير مختصة والتنبيه والحجز والطلب الذى يتقدم به الدائن لقبول حقه في تفليسة أو فى توزيع، وبأي عمل يقوم به الدائن للتمسك بحقه أثناء السير فى إحدى الدعاوى، كما ينقطع التقادم إذا أقر المدين بحق الدائن إقراراً صريحاً أو ضمنياً.$b27$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins27;

WITH ins28 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 117, 0, $h28$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الثالث: ربط الضريبة > مادة 117$h28$, $b28$يقصد بالأخطاء المادية، فى تطبيق حكم المادة (93) من القانون، ورود النتيجة مخالفة للحيثيات، ويقصد بالأخطاء الحسابية فى تطبيقها الأخطاء في نقل الأرقام أو الجمع والطرح وكافة العمليات الحسابية.

ويعد فى حكم الأخطاء المادية التى يكون على المأمورية المختصة تصحيحها من تلقاء ذاتها أو بناء على طلب الممول، جميع الحالات المنصوص عليها فى المادة (124) من القانون، وذلك ما لم يصبح الربط نهائياً.$b28$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins28;

WITH ins29 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 118, 0, $h29$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الرابع: الفحص والتحريات > مادة 118$h29$, $b29$يكون إخطار الممول بالتاريخ المحدد للفحص ومكانه والمدة التقديرية له على النموذج رقم (31 فحص) قبل عشرة أيام على الأقل من تاريخ استلام الممول لهذا الإخطار.$b29$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins29;

WITH ins30 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 119, 0, $h30$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الرابع: الفحص والتحريات > مادة 119$h30$, $b30$لا يجوز للمصلحة إعادة فحص حسابات ودفاتر الممول، طبقا لحكم الفقرة الأخيرة من المادة (95) من القانون، إلا إذا توافرت إحدى الطرق المنصوص عليها في المادة (132) منه.

وفى جميع الأحوال، على المصلحة بيان الأسباب الداعية إلى إعادة الفحص.$b30$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins30;

WITH ins31 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 120, 0, $h31$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الرابع: الفحص والتحريات > مادة 120$h31$, $b31$يكون طلب المصلحة للبيانات وصور الدفاتر والمستندات والمحررات من الممول، طبقا للمادة (96) من القانون، على النموذج رقم (32 فحص)، وللممول أن يطلب مد المهلة الممنوحة له على النموذج رقم (26 طلبات)، ويكون إخطار الممول بمد المهلة أو برفض طلبه على النموذج رقم (33 فحص) مع إبداء الأسباب في حالة الرفض.$b31$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins31;

WITH ins32 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 121, 0, $h32$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الرابع: الفحص والتحريات > مادة 121$h32$, $b32$يكون طلب الوزير من رئيس محكمة الاستئناف الأمر باطلاع العاملين بالمصلحة أو حصولهم على بيانات متعلقة بحسابات العملاء وودائعهم وخزائنهم على النموذج رقم (34 بيانات).$b32$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins32;

WITH ins33 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 122, 0, $h33$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الرابع: الفحص والتحريات > مادة 122$h33$, $b33$تشمل المنشآت الملتزمة بتقديم دفاتر حساباتها، وفقاً لأحكام القانون، المنشآت والشركات المقامة بنظام المناطق الحرة.$b33$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins33;

WITH ins34 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 123, 0, $h34$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الخامس: ضمانات التحصيل > مادة 123$h34$, $b34$يكون تحصيل الضريبة غير المسددة ومقابل التأخير بمقتضى مطالبات واجبة التنفيذ موقعا عليها من مأمور الفحص ومأمور التحصيل ورئيس المأمورية على النموذج رقم (35 سداد) بالنسبة للأشخاص الطبيعيين، وعلى النموذج رقم (36 سداد) بالنسبة للأشخاص الاعتبارية، وترسل هذه المطالبات بكتاب موصى عليه بعلم الوصول.$b34$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins34;

WITH ins35 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 124, 0, $h35$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الخامس: ضمانات التحصيل > مادة 124$h35$, $b35$يكون إخطار الممول بالمطالبة بالسداد، طبقا للفقرة الثانية من المادة (104) من القانون، على النموذج رقم (37 سداد) من تاريخ موافقة المسئول على تقديرات المأمورية أو صدور قرار لجنة الطعن أو حكم من المحكمة الابتدائية، وذلك بموجب كتاب موصى عليه مصحوباً بعلم الوصول.$b35$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins35;

WITH ins36 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 125, 0, $h36$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الخامس: ضمانات التحصيل > مادة 125$h36$, $b36$فى حالة سداد الضريبة على أقساط، يكون تحديد قيمة القسط ومدة التقسيط وفقا لما يأتي:
1. حجم تعاملات الممول طبقاً لبيانات الخصم والتحصيل تحت حساب الضريبة
2. صافى الأرباح النهائية فى الثلاث سنوات الأخيرة.
3. قيمة المحجوزات المنقولة أو العقارية.
4. مدى انتظام الممول في السداد إذا كان قد سبق صدور قرارات تقسيط له.$b36$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins36;

WITH ins37 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 126, 0, $h37$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الخامس: ضمانات التحصيل > مادة 126$h37$, $b37$فى تطبيق حكم المادة (105) من القانون، إذا طرأت ظروف عامة أو ظروف خاصة بالممول تحول دون التزامه بالسداد وفقاً للاتفاق مع المصلحة على التقسيط، يجوز للمصلحة بناءً على طلب الممول تعديل قرار التقسيط سواء بالنسبة لقيمة القسط أو عدد سنوات التقسيط بما يتناسب مع ظروف الممول وتحصيل المتأخرات.

فإذا تعذر الاتفاق مع الممول بشأن تقسيط الضريبة المستحقة يتم إخطاره برفض طلب التقسيط وتُتخذ إجراءات التنفيذ الجبري لتحصيل المستحقات الضريبية.$b37$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins37;

WITH ins38 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 127, 0, $h38$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الخامس: ضمانات التحصيل > مادة 127$h38$, $b38$تكون الضريبة واجبة الأداء، في تطبيق حكم البند (1) من المادة (110) من القانون، في الحالات الآتية:
1 - من واقع الإقرار الضريبي للممول.
2 - من واقع الاتفاق باللجنة الداخلية.
3 - من واقع قرار لجنة الطعن ولو كان مطعونا عليه.
4 - في حالة عدم الطعن علي نموذج الإخطار بعناصر ربط الضريبة وقيمتها أو المطالبة.
5 - من واقع حكم محكمة واجب النفاذ ولو كان مطعونا عليه.$b38$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins38;

WITH ins39 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 128, 0, $h39$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الخامس: ضمانات التحصيل > مادة 128$h39$, $b39$تقع المقاصة بقوة القانون طبقا لحكم المادة (113) من القانون على النحو الاتى:
1 - أن تكون المقاصة بين المبالغ التى أداها الممول بالزيادة فى أى ضريبة يفرضها القانون وبين المبالغ المستحقة عليه وواجبة الأداء يفرضها القانون ذاته.
2 - أن تكون المقاصة بين مبالغ مؤداة بالزيادة وفقا للقانون ومبالغ أخرى مستحقة وفقا لأي قانون ضريبي آخر تطبقه المصلحة.
3 - أن تكون المبالغ المطلوب إجراء المقاصة بشأنها نهائية وخالصة من أى نزاع.

وتقع المقاصة بقوة القانون فى تاريخ توفر شروطها، وعلى المأمورية المختصة إخطار الممول بنتيجة المقاصة.$b39$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins39;

WITH ins40 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 129, 0, $h40$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 129$h40$, $b40$يقصد بمحل الإقامة المختار للممول، فى تطبيق حكم الفقرة الثانية من المادة (116) من القانون، المكان الذى يحدده الممول لإخطاره بالنماذج الضريبية كمكتب المحامى أو المحاسب.

ويكون إثبات ارتداد الإعلان المرسل من المأمورية أو لجنة الطعن إلى الممول بكتاب موصى عليه مصحوباً بعلم الوصول مؤشراً عليه من موزع البريد بما يفيد غلق المنشأة أو غياب صاحبها أو رفض الاستلام، بموجب محضر يحرره المأمور المختص أو عضو لجنة الطعن المختصة، بحسب الأحوال، من ثلاث صور تُحفظ الأولى بملف الممول وتُلصق الثانية على مقر المنشأة وتُعلق الثالثة بلوحة الإعلانات بالمأمورية أو لجنة الطعن أو تُعلن على الموقع الالكترونى للمصلحة.

وعلى كل مأمورية أو لجنة طعن إمساك سجل تقيد فيه المحاضر المشار إليها أولاً بأول.

وفى الحالات التى فيها يرتد الإعلان مؤشراً عليه بما يفيد عدم وجود المنشأة أو عدم التعرف على عنوان الممول، يقوم المأمور المختص أو عضو اللجنة المختصة بإجراء التحريات اللازمة، فإن أسفرت هذه التحريات عن وجود المنشأة أو التعرف على عنوان الممول، يتم إعادة الإعلان بتسليمه إليه، وإن لم تُسفر التحريات عن التعرف على المنشأة أو عنوان الممول يتم إعلانه فى مواجهة النيابة العامة.

وفى تطبيق حكم الفقرة الأخيرة من المادة (116) من القانون، يقصد بتاريخ توقيع الحجز على الممول تاريخ علمه بهذا الحجز.$b40$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins40;

WITH ins41 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 130, 0, $h41$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 130$h41$, $b41$فى تطبيق حكم الفقرة الثالثة من المادة (118) من القانون، يكون الإخطار بفروق الضريبة الناتجة عن الفحص على النموذج رقم (38 مرتبات).$b41$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins41;

WITH ins42 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 131, 0, $h42$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 131$h42$, $b42$تشكل اللجنة الداخلية المنصوص عليها في المادة (119) من القانون، بقرار من رئيس المصلحة أو من يفوضه، برئاسة أحد العاملين بالمصلحة من درجة مدير عام وعضوية اثنين من العاملين بها.$b42$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins42;

WITH ins43 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 132, 0, $h43$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 132$h43$, $b43$تختص اللجان الداخلية المنصوص عليها في المادة (119) من القانون، بالفصل فى الطعون المقدمة من الممولين للمأمورية طعناً على ربط الضريبة بالنسبة للنشاط التجارى والصناعى والمهني وإيرادات الثروة العقارية والضريبة المستقطعة من المنبع والضريبية على أرباح الأشخاص الاعتبارية، على أن يتم ذلك خلال ستين يوماً من تاريخ ورود الطعن للجنة.$b43$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins43;

WITH ins44 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 133, 0, $h44$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 133$h44$, $b44$يجب أن يتوفر بكل لجنة داخلية السجلات الآتية:-
1 - سجل قيد الطعون.
2- سجل محاضر الجلسات.
3- سجل القرارات التى تنتهي إليها اللجنة.$b44$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins44;

WITH ins45 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 134, 0, $h45$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 134$h45$, $b45$على اللجنة الداخلية إخطار الممول بكتاب موصى عليه مصحوباً بعلم الوصول بتاريخ الجلسة، وفى حالة عدم حضوره أو من يمثله قانونا فى التاريخ المحدد يتم إخطاره بكتاب ثان أخير، وفى حالة عدم حضور الممول أو من يمثله فى الموعد الثاني تقوم اللجنة الداخلية بإحالة الخلاف إلى لجنة الطعن المختصة وتخطر الممول بذلك.$b45$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins45;

WITH ins46 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 135, 0, $h46$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 135$h46$, $b46$تكون جلسات اللجنة الداخلية سرية، ويجب إثبات ما يتم تناوله بالجلسة في محضر مؤيد بالمستندات المقدمة من الممول والمأمورية، وعلى اللجنة مناقشة جميع بنود الخلاف وأوجه الدفاع التى يقدمها الممول، وأن ترد على كل بند من هذه البنود، وفى حالة الاتفاق مع الممول يصدر القرار بما تم الاتفاق عليه، وفى حالة عدم الاتفاق تحدد اللجنة أوجه الخلاف ورأى اللجنة بشأنها، ويتم إحالة أوجه الخلاف إلى لجنة الطعن المختصة، ويخطر الممول بذلك.

ويجب أن يوقع محضر اللجنة الداخلية من رئيس اللجنة وأعضائها والممول أو من يمثله قانوناً.

ويكون للممول الحق فى الحصول على نسخة من هذا المحضر.$b46$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins46;

WITH ins47 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 136, 0, $h47$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 136$h47$, $b47$يجب أن تمسك لجان الطعن، المنصوص عليها فى المادة (120) من القانون، السجلات الآتية:
1 - سجل الطعون الضريبية، وتقيد به الطعون حسب تاريخ ورودها، ويجب أن يتضمن القيد البيانات الخاصة بكل طعن من حيث سنوات الخلاف وصافي ربح كل سنة، وقرار اللجنة عند صدوره.
2 - سجل الجلسات، وتدون به المداولات التى تدور فى كل جلسة.
3 - أية سجلات أخرى تتطلبها طبيعة العمل باللجنة.

ويكون القيد في السجلات المشار إليها بمعرفة أمانة اللجنة.$b47$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins47;

WITH ins48 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 137, 0, $h48$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 137$h48$, $b48$يكون العمل بلجان الطعن، المنصوص عليها فى المادة (120) من القانون، على النحو الآتي:
1 - يحدد رئيس اللجنة مقرر الحالة من أحد العضوين المعينين من المصلحة.
2 - يقوم كل عضو من أعضاء اللجنة المشار إليهم فى البند [1] من هذه المادة بدراسة ما يحال إليه من طعون وكافة أوجه الدفاع المتعلقة بها، ويعد مسودة القرار في كل طعن.
3 - تتم المداولة مع باقي أعضاء اللجنة على مسودة القرار بعد إطلاعهم على أوراق الطعن.
4- يصدر قرار اللجنة بعد المداولة طبقا لحكم المادة (122) من القانون.$b48$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins48;

WITH ins49 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 138, 0, $h49$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 138$h49$, $b49$يجب على لجان الطعن إنجاز المعدلات التى تحددها الإدارة المشرفة على اللجان.$b49$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins49;

WITH ins50 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 139, 0, $h50$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 139$h50$, $b50$على لجنة الطعن مراعاة الأصول والمبادئ العامة لإجراءات التقاضي وفقا لحكم المادة (141) من هذه اللائحة.$b50$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins50;

WITH ins51 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 140, 0, $h51$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 140$h51$, $b51$على لجنة الطعن إخطار كل من الطاعن والمأمورية المختصة بموعد الجلسة على النموذج رقم (39 لجان) بكتاب موصى عليه بعلم الوصول، فإذا لم يحضر الممول أو وكيله أمام اللجنة فى أول جلسة حجز الطعن للقرار بعد أسبوعين على الأقل، ويعلن الممول بذلك بكتاب موصى عليه مصحوباً بعلم الوصول، فإذا أبدى عذراً تقبله اللجنة فتح باب المرافعة وحددت جلسة لنظر الطعن، أما إذا لم تقبل عذره تصدر اللجنة قراراً مسبباً في الطعن.

وفى جميع الأحوال يتعين على اللجنة أن تتحقق من إخطار الممول من خلال علم الوصول.

ويجب على رئيس اللجنة وأمين السر توقيع قرارات اللجنة خلال خمسة عشر يوماً من تاريخ صدورها، ويكون إعلان كل من المصلحة والممول بقرار اللجنة بكتاب موصى عليه مصحوباً بعلم الوصول على النموذج رقم (40 لجان).$b51$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins51;

WITH ins52 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 141, 0, $h52$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 141$h52$, $b52$تشمل الأصول والمبادئ العامة لإجراءات التقاضي، في تطبيق حكم المادة (122) من القانون، ما يأتي:
1 - الاختصاص.
2 - إعلان أطراف الخلاف.
3 - أحقية الممول فى رد اللجنة أو أحد أعضائها.
4 - مناقشة كافة الدفوع المقدمة من الممول.
5 - تسبيب القرارات.

وذلك مع عدم الإخلال بالأصول والمبادئ العامة للتقاضي المنصوص عليها فى قانون المرافعات المدنية والتجارية.$b52$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins52;

WITH ins53 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 142, 0, $h53$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 142$h53$, $b53$تشكل لجنه أو أكثر لإعادة النظر في الربط النهائي بقرار من رئيس مصلحة الضرائب برئاسة احد العاملين بالمصلحة من درجة مدير عام، وعضوية مستشار مساعد على الأقل من مجلس الدولة يختاره رئيس المجلس، وأحد العاملين بها، ويحدد قرار تشكيل اللجنة اختصاصها ومقرها.$b53$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins53;

WITH ins54 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 143, 0, $h54$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 143$h54$, $b54$على لجنة إعادة النظر في الربط النهائي خلال خمسة عشر يوما من ورود طلب الممول إليها طلب الملف الضريبي الخاص به من المأمورية المختصة، وعلى المأمورية موافاة اللجنة بالملف خلال مدة أقصاها خمسة عشر يوماً من تاريخ ورود طلب اللجنة إليها، وبمجرد ورود الملف تقوم اللجنة بدراسة طلب الممول والمستندات المقدمة فى ضوء المستندات المرفقة بالملف الضريبي، وتصدر قرارها خلال مدة أقصاها ستون يوماً من تاريخ ورود الملف، ولا يكون هذا القرار نافذا إلا بعد اعتماده من رئيس المصلحة.

ويخطر كل من الممول والمأمورية المختصة بالقرار.$b54$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins54;

WITH ins55 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 144, 0, $h55$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 144$h55$, $b55$تتولى لجان إعادة النظر، المشكلة طبقاً لأحكام القانون، النظر في الطلبات المقدمة لتصحيح الربط النهائي قبل تاريخ العمل به ولم يتم البت فيها.$b55$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins55;

WITH ins56 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 145, 0, $h56$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 145$h56$, $b56$على مندوبي المصلحة لدى الجهات المنصوص عليها في المادة (128) من القانون، متابعة سلامة تنفيذ هذه الجهات لأحكام قانون الضريبة على الدخل وغيره من التشريعات الضريبية المرتبطة به، وفى حالة اكتشاف المندوب أية مخالفة، عليه أن يثبت ذلك في محضر أعمال يتضمن البيانات الأساسية الآتية:
1 - اسم المندوب.
2 - اسم الجهة.
3 - تاريخ اكتشاف المخالفة.
4 - وصف المخالفة.
5 - الأثر المالي للمخالفة.
6 - المدة التى وقعت خلالها المخالفة.

ويجب إحالة محضر الأعمال المشار إليه إلى الإدارة التي يتبعها المندوب لاتخاذ اللازم.$b56$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins56;

WITH ins57 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 146, 0, $h57$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب السادس: إجراءات الطعن > مادة 146$h57$, $b57$على مأمورية الضرائب المختصة أن تثبت بموجب مذكرة معتمدة، مرفقاً بها المستندات المؤيدة لها، أسباب تصحيح الإقرار أو تعديله أو عدم الاعتداد به أو تعديل الربط، وذلك فى الحالات المنصوص عليها في المادة (129) من القانون.

ويجب أن يتضمن إخطار الممول بالتصحيح أو التعديل أو عدم الاعتداد، بيان هذه الأسباب.$b57$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins57;

-- ===== كتلة التحقق النهائية =====

DO $verify082$
DECLARE
    v_law_id uuid;
    v_book6_count INT;
    v_book6_versions INT;
    v_book6_min INT;
    v_book6_max INT;
    v_substantive_total INT;
    v_substantive_max INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 082: سجل اللائحة غير موجود - يجب تشغيل migration 077 أولاً.';
    END IF;

    -- تحقق مقيَّد بنطاق الكتاب السادس حصراً (نفس نمط 078-081)
    SELECT COUNT(*) INTO v_book6_count
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 90 AND 146;
    IF v_book6_count <> 57 THEN
        RAISE EXCEPTION 'migration 082: عدد مواد الكتاب السادس المتوقع 57 لكن الفعلى %', v_book6_count;
    END IF;

    SELECT COUNT(*) INTO v_book6_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_suffix_order = 0
        AND a.article_no BETWEEN 90 AND 146;
    IF v_book6_versions <> 57 THEN
        RAISE EXCEPTION 'migration 082: عدد نسخ مواد الكتاب السادس المتوقع 57 لكن الفعلى %', v_book6_versions;
    END IF;

    SELECT MIN(article_no), MAX(article_no) INTO v_book6_min, v_book6_max
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 90 AND 146;
    IF v_book6_min <> 90 OR v_book6_max <> 146 THEN
        RAISE EXCEPTION 'migration 082: مدى أرقام الكتاب السادس المتوقع 90-146 لكن الفعلى %-%', v_book6_min, v_book6_max;
    END IF;

    -- تحقق نهائى من اكتمال اللائحة بالكامل (آمن فقط لأن هذه آخر هجرة فى السلسلة -
    -- لا يوجد كتاب سابع سيضيف صفوفاً لاحقاً لنفس السجل):
    SELECT COUNT(*), MAX(article_no) INTO v_substantive_total, v_substantive_max
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0;
    IF v_substantive_total <> 146 THEN
        RAISE EXCEPTION 'migration 082: عدد مواد اللائحة الموضوعية الإجمالى المتوقع 146 لكن الفعلى %', v_substantive_total;
    END IF;
    IF v_substantive_max <> 146 THEN
        RAISE EXCEPTION 'migration 082: أعلى رقم مادة فى اللائحة المتوقع 146 لكن الفعلى %', v_substantive_max;
    END IF;

    RAISE NOTICE 'migration 082 (اللائحة التنفيذية 991/2005 - الكتاب السادس والأخير): تم بنجاح. % مادة فى هذا الكتاب، مدى أرقام الكتاب 90-146. اللائحة بالكامل الآن مكتملة: % مادة موضوعية (1-146).', v_book6_count, v_substantive_total;
END $verify082$;

COMMIT;
