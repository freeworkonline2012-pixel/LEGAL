-- =====================================================================
-- Migration 081: اللائحة التنفيذية لقانون الضريبة على الدخل
--                        91/2005 (قرار وزير المالية 991/2005) - الكتاب
--                        الخامس (الخصم والتحصيل والدفعات المقدمة تحت
--                        حساب الضريبة) - الدفعة 5 من 6
-- =====================================================================
--
-- المصدر الأساسى: نسخة PDF رفعها صاحب المشروع مباشرة (55 صفحة) - مسح
--   ضوئى كامل للوقائع المصرية، العدد 295 تابع، 27 ديسمبر 2005، موقَّع
--   باسم وزير المالية د. يوسف بطرس غالى. بلا طبقة نص قابلة للاستخراج
--   الآلى (مسح ضوئى بحت) - نُقل كل نص هذه الدفعة من القراءة البصرية
--   المباشرة لصفحات الـPDF.
--
-- تعتمد هذه الهجرة على سجل laws الذى أنشأته migration 077 - لا تُعيد
--   إدراجه، وتتحقق كتلة التحقق النهائية من وجوده صراحة.
--
-- كتلة التحقق مبنية من البداية وفقاً للإصلاح الجذرى المُطبَّق على
--   077-080 (راجع commit إصلاح 079/080): لا يوجد أى تحقق من "إجمالى
--   تراكمى عبر كامل سجل اللائحة" - كل التحقق مقيَّد بنطاق مواد هذا
--   الكتاب حصراً، فتبقى محصَّنة ضد الكتاب السادس (082) اللاحق.
--
-- محتوى هذه الدفعة (081): الكتاب الخامس بالكامل - الخصم والتحصيل
--   والدفعات المقدمة تحت حساب الضريبة، مواد 82-89
--   (8 مادة، article_suffix_order=0).
--
-- سياسة effective_from: تاريخ واحد موحَّد = '2005-12-28'.
--
-- عدد صفوف هذه الدفعة: 8 مادة (مدى الأرقام 82-89).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

-- ===== الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة (article_suffix_order = 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 82, 0, $h1$لائحة 991/2005 > الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة > الباب الأول: النشاط التجارى والصناعى > الفصل الأول: الخصم > مادة 82$h1$, $b1$يكون توريد الجهات والمنشآت، المنصوص عليها فى المادة (59) من القانون، للمبالغ التى تم خصمها تحت حساب الضريبة من أى شخص من أشخاص القطاع الخاص طبقاً للآتي:
1- أن يتم التوريد على النموذج رقم (41 خصم وتحصيل) مرفقاً به الشيك أو نقداً أو من خلال وسائل الدفع الالكترونية المنصوص عليها فى الفقرة الثالثة من هذه المادة.
2- أن يتم التوريد فى موعد أقصاه آخر ابريل ويوليو وأكتوبر ويناير من كل عام.
3- أن يتم التوريد إلى الإدارة العامة لتجميع نماذج الخصم والتحصيل تحت حساب الضريبة بالمصلحة.
ويجب أن يتضمن النموذج المنصوص عليه فى البند [1] بيانات الممول من واقع البطاقة الضريبية، وأن يحدد به بدقة رقم التسجيل الضريبي/ رقم الملف/ المأمورية المختصة/ طبيعة التعامل، كما يجب استيفاء بيانات الشيك من حيث التوقيعات والبنك المسحوب عليه واسم وصفة الموقعين على النموذج المعد لذلك.
وتعتبر قنوات الدفع التالية من وسائل الدفع الإلكترونية:
1 - تحويلات بنكية للممولين الذين لديهم حسابات بالبنوك مع إخطار المصلحة بإشعار إضافة بالاتفاق مع هذه البنوك والربط على شبكة معلومات المصلحة باستخدامها فى الإخطار.
2- استخدام الكروت الذكية فى إدراج مدفوعات الممول/ الجهة على الكروت على أن يتم تسليم القيمة إما لمندوب المصلحة أو يتوفير القارئ وبرنامج التحويل المالي لدى الجهة أو الممول، وأن يتم السداد من خلاله ثم تفريغ محتوياته بعد ذلك.
3- استخدام شبكة بنك أو بنوك معينة أو الهيئة القومية للبريد التي تتفق معها المصلحة على السماح للممول بالسداد لدى منافذها، ويتم إدراج التعامل على الكارت الذكي ويفرغ محتواه بالمأمورية المختصة لكل مدة طبقاً لأحكام القانون.
وتخطر المصلحة من خلال شبكة المعلومات بالسداد فوريا، ويقوم الممول بقراءة محتويات الكارت للمطابقة.
وفى جميع الأحوال تعتبر الوسائل السابقة قنوات للدفع بشرط توافر اتفاق تجهيزه من وزارة المالية مع الجهات السابقة.$b1$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 83, 0, $h2$لائحة 991/2005 > الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة > الباب الأول: النشاط التجارى والصناعى > الفصل الثانى: الدفعات المقدمة > مادة 83$h2$, $b2$يكون طلب الممول الالتزام بأحكام الدفعات المقدمة تحت حساب الضريبة على النموذج رقم (1 دفعات مقدمة).
ويجب أن يقدم هذا الطلب إلى المأمورية المختصة مرفقاً به المستندات الآتية:
1- بيان آخر ضريبة واجبة الأداء من واقع آخر إقرار ضريبي أو اتفاق مباشر أو قرار لجنة داخلية أو قرار لجنة طعن أو حكم محكمة أو قرار لجنة تصالح.
2- بيان بالضريبة المقدرة إذا كان الممول لم يسبق له تقديم إقرار ضريبي أو إذا كانت الفترة الضريبية السابقة على تقديم الطلب تتضمن خسارة.$b2$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 84, 0, $h3$لائحة 991/2005 > الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة > الباب الأول: النشاط التجارى والصناعى > الفصل الثانى: الدفعات المقدمة > مادة 84$h3$, $b3$على المأمورية المختصة أن ترد على طلب الممول المنصوص عليه فى المادة السابقة خلال ستين يوماً من تاريخ تقديم الطلب، وذلك بموجب إخطار موصى عليه، ويكون الرد بالموافقة على النموذج رقم (2 دفعات مقدمة).
وفى حالة الإخطار بالموافقة يعد هذا الإخطار بمثابة شهادة صادرة لجميع جهات تعامل الممول بخضوعه لنظام الدفعات المقدمة، وتكون هذه الشهادة صالحة لفترة ضريبية واحدة، تجدد بناء على طلب الممول وفقاً لهذا النظام ما لم يعدل الممول عن اختياره لهذا النظام وفقاً لحكم المادة (64) من القانون أو أن يتم إعفاؤه أو حرمانه من تطبيقه وفقاً لحكم المادة (65) منه.
ويجب أن يتضمن الإخطار المنصوص عليه فى الفقرة السابقة بيان مدة الفترة الضريبية الصالح للسريان خلالها، كما يجب إثبات خضوع الممول لنظام الدفعات المقدمة بالصفحة الأخيرة من البطاقة الضريبية وما يفيد تجديد العمل به، وإذا لم يتم هذا التجديد تلتزم جهات التعامل تلقائياً ودون إخطار مسبق من المصلحة بتطبيق نظام الخصم تحت حساب الضريبة.
ويعتبر عدم الرد على طلب الممول خلال المدة المشار إليها للطلب رفضاً للطلب.$b3$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 85, 0, $h4$لائحة 991/2005 > الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة > الباب الأول: النشاط التجارى والصناعى > الفصل الثانى: الدفعات المقدمة > مادة 85$h4$, $b4$يكون إخطار الممول للمصلحة بتخفيض القسط الثالث من الدفعات المقدمة أو عدم أدائه أو تخفيض عدد الدفعات، طبقاً للمادة (63) من القانون، على النموذج رقم (3 دفعات مقدمة).$b4$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 86, 0, $h5$لائحة 991/2005 > الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة > الباب الأول: النشاط التجارى والصناعى > الفصل الثانى: الدفعات المقدمة > مادة 86$h5$, $b5$يكون عدول الممول عن اختيار نظام الدفعات المقدمة بموجب طلب يقدم إلى المأمورية المختصة على النموذج رقم (4 دفعات مقدمة).
وفى حالة عدم توافر أى من شرطي قبول الطلب المشار إليه، تلتزم المأمورية المختصة بإخطار الممول برفض الطلب بكتاب موصى عليه مصحوبا بعلم الوصول خلال ستين يوماً من تاريخ تقديمه وذلك على النموذج رقم (5 دفعات مقدمة)، ويعتبر عدم الإخطار خلال هذه المدة قبولاً للطلب.$b5$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 87, 0, $h6$لائحة 991/2005 > الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة > الباب الأول: النشاط التجارى والصناعى > الفصل الثانى: الدفعات المقدمة > مادة 87$h6$, $b6$يكون إخطار الممول بإعفائه من تطبيق نظام الدفعات المقدمة على النموذج رقم (6 دفعات مقدمة)، ويكون إخطاره بحرمانه من تطبيق هذا النظام على النموذج رقم (7 دفعات مقدمة).$b6$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 88, 0, $h7$لائحة 991/2005 > الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة > الباب الثانى: المهن غير التجارية > التحصيل تحت حساب الضريبة > مادة 88$h7$, $b7$يكون تحصيل المبالغ المنصوص عليها فى المادة (71) من القانون، تحت حساب الضريبة على النموذج رقم (41 خصم وتحصيل).$b7$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 89, 0, $h8$لائحة 991/2005 > الكتاب الخامس: الخصم والتحصيل والدفعات المقدمة تحت حساب الضريبة > الباب الثالث: أحكام عامة > مادة 89$h8$, $b8$يكون توريد المبالغ التى تم تحصيلها تحت حساب الضريبة، طبقاً للمادة (72) من القانون، فى موعد أقصاه آخر ابريل ويوليو وأكتوبر ويناير من كل عام إلى الإدارة العامة لتجميع نماذج الخصم والتحصيل تحت حساب الضريبة على النموذج رقم (41 خصم وتحصيل) مرفقاً به الشيك أو نقداً أو من خلال وسائل الدفع الالكترونية المنصوص عليها فى هذه اللائحة، ويجب أن يتضمن النموذج المشار إليه بيانات الممول من واقع البطاقة الضريبية، وأن يحدد به بدقة رقم التسجيل الضريبي/ رقم الملف/ المأمورية المختصة/ طبيعة التعامل، كما يجب استيفاء بيانات الشيك من حيث التوقيعات والبنك المسحوب عليه واسم وصفة الموقعين على النموذج المعد لذلك.$b8$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins8;

-- ===== كتلة التحقق النهائية =====

DO $verify081$
DECLARE
    v_law_id uuid;
    v_book5_count INT;
    v_book5_versions INT;
    v_book5_min INT;
    v_book5_max INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 081: سجل اللائحة غير موجود - يجب تشغيل migration 077 أولاً.';
    END IF;

    SELECT COUNT(*) INTO v_book5_count
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 82 AND 89;
    IF v_book5_count <> 8 THEN
        RAISE EXCEPTION 'migration 081: عدد مواد الكتاب الخامس المتوقع 8 لكن الفعلى %', v_book5_count;
    END IF;

    SELECT COUNT(*) INTO v_book5_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_suffix_order = 0
        AND a.article_no BETWEEN 82 AND 89;
    IF v_book5_versions <> 8 THEN
        RAISE EXCEPTION 'migration 081: عدد نسخ مواد الكتاب الخامس المتوقع 8 لكن الفعلى %', v_book5_versions;
    END IF;

    SELECT MIN(article_no), MAX(article_no) INTO v_book5_min, v_book5_max
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 82 AND 89;
    IF v_book5_min <> 82 OR v_book5_max <> 89 THEN
        RAISE EXCEPTION 'migration 081: مدى أرقام الكتاب الخامس المتوقع 82-89 لكن الفعلى %-%', v_book5_min, v_book5_max;
    END IF;

    RAISE NOTICE 'migration 081 (اللائحة التنفيذية 991/2005 - الكتاب الخامس): تم بنجاح. % مادة فى هذا الكتاب، مدى أرقام الكتاب 82-89.', v_book5_count;
END $verify081$;

COMMIT;
