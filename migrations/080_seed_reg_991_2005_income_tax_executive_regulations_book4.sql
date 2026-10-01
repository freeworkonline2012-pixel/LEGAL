-- =====================================================================
-- Migration 080: اللائحة التنفيذية لقانون الضريبة على الدخل
--                        91/2005 (قرار وزير المالية 991/2005) - الكتاب
--                        الرابع (الضريبة المستقطعة من المنبع) - الدفعة
--                        4 من 6
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
-- محتوى هذه الدفعة (080): الكتاب الرابع بالكامل - الضريبة المستقطعة من
--   المنبع، مواد 71-81 (11 مادة،
--   article_suffix_order=0). لا توجد أبواب/فصول فرعية فى هذا الكتاب فى
--   النص المصدرى - مواد متتالية مباشرة.
--
-- سياسة effective_from: تاريخ واحد موحَّد = '2005-12-28'.
--
-- عدد صفوف هذه الدفعة: 11 مادة (مدى الأرقام 71-81).
--   الإجمالى التراكمى بعد هذه الهجرة (077+078+079+080) = 85 صفاً.
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

-- ===== الكتاب الرابع: الضريبة المستقطعة من المنبع (article_suffix_order = 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 71, 0, $h1$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 71$h1$, $b1$تشمل العوائد، فى تطبيق حكم البند [1] من المادة (56) من القانون، جميع ما تنتجه القروض والسلفيات والديون أياً كان نوعها والسندات والأذون.$b1$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 72, 0, $h2$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 72$h2$, $b2$لا يُعد مقابل الخدمات التالية من قبيل مقابل الخدمات المنصوص عليه فى البند [3] من المادة (56) من القانون:
1- النقل أو النولون
2- الشحن
3- التأمين
4- التدريب
5- الاشتراك فى المعارض والمؤتمرات
6- القيد فى البورصات العالمية
7- الإعلان والترويج المباشر.$b2$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 73, 0, $h3$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 73$h3$, $b3$يخضع للضريبة طبقاً لحكم المادة (56) من القانون مقابل الخدمات المؤداة بالخارج فى دول ليس بينها وبين جمهورية مصر العربية اتفاقيات تجنب ازدواج ضريبي، وفى حالة تأدية الخدمات فى دول بينها وبين جمهورية مصر العربية اتفاقيات تجنب ازدواج ضريبي فيتم تطبيق أحكام هذه الاتفاقيات، بشرط التزام الجهة التى تؤدى هذا المقابل بتقديم المستندات التى تثبت ارتباط هذه الخدمات بنشاطها وسداد هذا المقابل.
وعلى الجهات التى تتطلب طبيعة عملها الحصول على خدمات مستمرة تؤدى فى الخارج أن تتقدم للمصلحة للحصول على الرأي المسبق بشأن المعاملة الضريبية، وفقاً لحكم المادة (127) من القانون.$b3$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 74, 0, $h4$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 74$h4$, $b4$لا يعد من قبيل مقابل الخدمات، فى تطبيق حكم المادة (56) من القانون، نصيب المنشأة الدائمة العاملة فى مصر من المصروفات الإدارية ومصروفات الرقابة والإشراف التى يتحملها المركز الرئيسى فى الخارج.
ويجب عند تحديد أرباح المنشأة الدائمة، ألا يزيد ما يعتمد ضمن المصروفات الإدارية ومصروفات الرقابة والإشراف التى يتحملها المركز الرئيسى فى الخارج على 7% من صافى الربح الضريبي للمنشأة، على ألا تتضمن المصروفات المحملة فى حدود هذه النسبة أية إتاوات أو عوائد أو عمولات أو أجور مباشرة، وبشرط تقديم شهادة من مراقب حسابات المركز الرئيسى معتمدة وموثقة.$b4$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 75, 0, $h5$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 75$h5$, $b5$يشترط لسريان الإعفاء المقرر لعوائد القروض طبقاً لحكم الفقرة قبل الأخيرة من المادة (56) من القانون، ألا تقل مدة القرض عن ثلاث سنوات، وإذا كان تاريخ عقد القرض سابقاً على تاريخ العمل بالقانون فإن الإعفاء يسرى على العوائد المستحقة اعتباراً من تاريخ العمل بالقانون.$b5$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 76, 0, $h6$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 76$h6$, $b6$يكون الإخطار بحجز الضريبة وتوريدها إلى المأمورية المختصة، طبقاً للمادة (56) من القانون، على النموذج رقم (11 مستقطعه).
ويقصد بالمأمورية المختصة فى هذا الشأن المأمورية التى يتبعها دافع المبالغ المنصوص عليها فى المادة المشار إليها.$b6$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 77, 0, $h7$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 77$h7$, $b7$على غير المقيمين الخاضعين للضريبة، طبقاً لحكم المادة (56) من القانون، والمتعاملين مع المنشآت والمشروعات المقامة بنظام المناطق الحرة فى مصر توريد الضريبة على النموذج رقم (12 مستقطعه).
وفى حالة عدم الالتزام بالتوريد، يكون على مأمورية الضرائب التى تتبعها الجهة الدافعة للإيراد الخاضع للضريبة مطالبة غير المقيم بالضريبة المستحقة على النموذج رقم (13 مستقطعه).$b7$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins7;

WITH ins8 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 78, 0, $h8$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 78$h8$, $b8$يُقصد بالمأمورية المختصة، فى تطبيق حكم المادة (57) من القانون، المأمورية التى يتبعها دافع العمولة أو السمسرة.$b8$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins8;

WITH ins9 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 79, 0, $h9$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 79$h9$, $b9$يكون الإخطار بتوريد الضريبة المستحقة على العمولة أو السمسرة غير المتصلة بمباشرة المهنة، طبقاً لحكم المادة (57) من القانون، على النموذج رقم (14 مستقطعه).$b9$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins9;

WITH ins10 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 80, 0, $h10$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 80$h10$, $b10$يُقصد بالمأمورية المختصة، فى تطبيق حكم المادة (58) من القانون، المأمورية التى يتبعها البنك المركزى أو أى بنك آخر يكتتب فى السندات التى تصدرها وزارة المالية لصالح البنك المركزى أو غيره من البنوك.$b10$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins10;

WITH ins11 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 81, 0, $h11$لائحة 991/2005 > الكتاب الرابع: الضريبة المستقطعة من المنبع > مادة 81$h11$, $b11$يكون الإخطار بتحصيل وتوريد الضريبة المستحقة على عوائد السندات، المنصوص عليها فى المادة السابقة، على النموذج رقم (15 مستقطعه) مع خصم الضريبة المسددة على عوائد هذه السندات من الضريبة على أرباح الأشخاص الاعتبارية المستحقة على هذه البنوك وبما لا يجاوز هذه الضريبة.$b11$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins11;

-- ===== كتلة التحقق النهائية =====

DO $verify080$
DECLARE
    v_law_id uuid;
    v_book4_count INT;
    v_book4_versions INT;
    v_book4_min INT;
    v_book4_max INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 080: سجل اللائحة غير موجود - يجب تشغيل migration 077 أولاً.';
    END IF;

    SELECT COUNT(*) INTO v_book4_count
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 71 AND 81;
    IF v_book4_count <> 11 THEN
        RAISE EXCEPTION 'migration 080: عدد مواد الكتاب الرابع المتوقع 11 لكن الفعلى %', v_book4_count;
    END IF;

    SELECT COUNT(*) INTO v_book4_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_suffix_order = 0
        AND a.article_no BETWEEN 71 AND 81;
    IF v_book4_versions <> 11 THEN
        RAISE EXCEPTION 'migration 080: عدد نسخ مواد الكتاب الرابع المتوقع 11 لكن الفعلى %', v_book4_versions;
    END IF;

    SELECT MIN(article_no), MAX(article_no) INTO v_book4_min, v_book4_max
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 71 AND 81;
    IF v_book4_min <> 71 OR v_book4_max <> 81 THEN
        RAISE EXCEPTION 'migration 080: مدى أرقام الكتاب الرابع المتوقع 71-81 لكن الفعلى %-%', v_book4_min, v_book4_max;
    END IF;

    RAISE NOTICE 'migration 080 (اللائحة التنفيذية 991/2005 - الكتاب الرابع): تم بنجاح. % مادة فى هذا الكتاب، مدى أرقام الكتاب 71-81.', v_book4_count;
END $verify080$;

COMMIT;
