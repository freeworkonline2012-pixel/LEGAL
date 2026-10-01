-- =====================================================================
-- Migration 077: اللائحة التنفيذية لقانون الضريبة على الدخل
--                        91/2005 (قرار وزير المالية 991/2005) - الكتاب
--                        الأول (أحكام عامة) - الدفعة 1 من 6
-- =====================================================================
--
-- المصدر الأساسى: نسخة PDF رفعها صاحب المشروع مباشرة (55 صفحة) - مسح
--   ضوئى كامل للوقائع المصرية، العدد 295 تابع، 27 ديسمبر 2005، موقَّع
--   باسم وزير المالية د. يوسف بطرس غالى. بلا طبقة نص قابلة للاستخراج
--   الآلى (مسح ضوئى بحت) - نُقل كل نص هذه الدفعة من القراءة البصرية
--   المباشرة لصفحات الـPDF.
--
-- سجل laws مستقل عن القانون الأم 91/2005 (law_no=991, law_year=2005,
--   kind='regulation') - قياساً على نفس النمط المعتمد سابقاً للائحة
--   التنفيذية 96/1982 لقانون الشركات 159/1981 (migrations 073/075).
--
-- قرار التقسيم (بموافقة صريحة من صاحب المشروع): اللائحة بالكامل 146 مادة
--   موزعة على 6 كتب - تقريباً بحجم القانون الأم نفسه (147 مادة). بُنيت
--   على 6 هجرات منفصلة (077-082)، هجرة واحدة لكل كتاب، بدلاً من هجرة
--   واحدة ضخمة، لإتاحة اختبار ونشر والتحقق من كل جزء فور اكتماله.
--
-- محتوى هذه الدفعة (077): مواد الإصدار الأربعة لقرار وزير المالية
--   991/2005 نفسه (article_suffix_order=-1) + الكتاب الأول من اللائحة
--   المرفقة (أحكام عامة، مواد 1-7، article_suffix_order=0).
--
-- سياسة effective_from: تاريخ واحد موحَّد = '2005-12-28' (مُشتَق صراحة من
--   نص المادة الرابعة من مواد الإصدار: "يُنشر هذا القرار فى الوقائع
--   المصرية، ويعمل به من اليوم التالى لتاريخ نشره." صدر القرار ونُشر فى
--   2005/12/27، فيُعمل به من 2005/12/28).
--
-- التصنيف: category='other' (يطابق قيد laws_category_check؛ قياساً
--   على نفس تصنيف القانون الأم 91/2005 - لا فئة ضريبية/مالية مخصصة متاحة).
--
-- عدد صفوف هذه الدفعة: 11 (4 مواد إصدار
--   + 7 مادة من الكتاب الأول، مدى الأرقام 1-7).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

INSERT INTO laws (country_code, law_no, law_year, kind, category, title, short_title, status, official_url, enacted_at)
SELECT 'EG', 991, 2005, 'regulation', 'other',
       $tlaw$اللائحة التنفيذية لقانون الضريبة على الدخل رقم 91 لسنة 2005 (قرار وزير المالية رقم 991 لسنة 2005)$tlaw$, $stlaw$اللائحة التنفيذية لقانون الضريبة على الدخل 991/2005$stlaw$, 'in_force', $urllaw$مصدر المستخدم المباشر: نسخة PDF رفعها صاحب المشروع مباشرة (55 صفحة) - مسح ضوئى للوقائع المصرية، العدد 295 تابع، 27 ديسمبر 2005، موقَّع باسم وزير المالية د. يوسف بطرس غالى. اللائحة بالكامل 146 مادة موزعة على 6 كتب؛ تُبنى على 6 هجرات منفصلة (077-082) بقرار صريح من صاحب المشروع - هذه الهجرة (077) تحوى الكتاب الأول فقط (أحكام عامة، مواد 1-7) + مواد الإصدار الأربعة لقرار الوزير.$urllaw$, '2005-12-28'
WHERE NOT EXISTS (
    SELECT 1 FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
);

-- ===== مواد الإصدار (قرار وزير المالية، article_suffix_order = -1) =====
WITH insE1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, -1, $hE1$قرار وزير المالية 991/2005 > مواد الإصدار > مادة 1$hE1$, $bE1$يُعمل باللائحة التنفيذية المرفقة لقانون الضريبة على الدخل الصادر بالقانون رقم 91 لسنة 2005 .$bE1$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM insE1;

WITH insE2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, -1, $hE2$قرار وزير المالية 991/2005 > مواد الإصدار > مادة 2$hE2$, $bE2$تسرى أحكام قانون الضريبة على الدخل الصادر بالقانون رقم 91 لسنة 2005 :
1 - بالنسبة للأشخاص الطبيعيين :
( أ ) على دخل المرتبات وما فى حكمها اعتباراً من مرتبات شهر يوليو سنة 2005 .
( ب ) على دخل النشاط التجارى والصناعى ودخل المهن غير التجارية ودخل الثروة العقارية اعتباراً من الفترة الضريبية لسنة 2005 التى تبدأ من أول يناير سنة 2005 وتنتهى بعد تاريخ العمل بقانون الضريبة على الدخل المشار إليه .
2 - بالنسبة للأشخاص الاعتبارية :
( أ ) الفترة الضريبية الأولى التى تبدأ بفترة من سنة 2004 وتنتهى فى 31 ديسمبر سنة 2005 .
( ب ) الفترة الضريبية التى تبدأ من أول يناير سنة 2005 أو أى تاريخ لاحق لذلك وتنتهى بعد تاريخ العمل بالقانون المشار إليه .$bE2$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM insE2;

WITH insE3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, -1, $hE3$قرار وزير المالية 991/2005 > مواد الإصدار > مادة 3$hE3$, $bE3$يُلغى كل ما يخالف أحكام هذا القرار أو اللائحة التنفيذية المرافقة له أو يتعارض مع أحكامهما .$bE3$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM insE3;

WITH insE4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, -1, $hE4$قرار وزير المالية 991/2005 > مواد الإصدار > مادة 4$hE4$, $bE4$يُنشر هذا القرار فى الوقائع المصرية ، ويعمل به من اليوم التالى لتاريخ نشره .$bE4$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM insE4;

-- ===== الكتاب الأول: أحكام عامة (article_suffix_order = 0) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 1, 0, $h1$لائحة 991/2005 > الكتاب الأول: أحكام عامة > مادة 1$h1$, $b1$إذا آلت منشأة فردية بالميراث لوارث أو أكثر، يعامل كل منهم ضريبياً معاملة الممول الفرد المنصوص عليها فى القانون .$b1$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 2, 0, $h2$لائحة 991/2005 > الكتاب الأول: أحكام عامة > مادة 2$h2$, $b2$يعد تأجير المعدات، فى تطبيق حكم المادة ( 1 ) من القانون، فى حكم استعمالها أو الحق فى استعمالها. وتشمل الإتاوات جميع المبالغ التى تدفع مقابل تأجير المعدات الصناعية أو التجارية أو العلمية.
ومع ذلك إذا كان المؤجر يباشر نشاطه من خلال فرع مُسجل فإنه يحاسب لأغراض الضريبية باعتباره منشأة دائمة.$b2$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 3, 0, $h3$لائحة 991/2005 > الكتاب الأول: أحكام عامة > مادة 3$h3$, $b3$يكون للشخص الطبيعي موطن دائم فى مصر فى أى من الحالتين الآتيتين:
1 - إذا تواجد فى مصر معظم أوقات السنة سواء فى مكان مملوك له أو مستأجر وبأية صفة كانت.
2 - إذا كان للممول محل تجارى أو مكتب مهنى أو مصنع أو غير ذلك من أماكن العمل التى يزاول فيها الشخص الطبيعي نشاطه فى مصر.
وتكون مصر مركزاً للإدارة الفعلى للشخص الاعتبارى إذا تحققت فى شأنه حالتان على الأقل من الحالات الآتية:
1 - إذا كانت هي المقر الذى تتخذ فيه قرارات الإدارة اليومية.
2 - إذا كانت هي المقر الذى تنعقد به اجتماعات مجلس الإدارة أو المديرين.
3 - إذا كانت هي المقر الذى يقيم فيه 50% على الأقل من أعضاء مجلس الإدارة أو المديرين.
4 - إذا كانت هي المقر الذى يقيم فيه الشركاء أو المساهمون الذين تزيد حصصهم على نصف رأس المال أو حقوق التصويت.$b3$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 4, 0, $h4$لائحة 991/2005 > الكتاب الأول: أحكام عامة > مادة 4$h4$, $b4$يُقصد بالعمل ذى الصفة التمهيدية أو المساعدة للمشروع، المنصوص عليه فى البند [5] من الفقرة الثالثة من المادة (4) من القانون، كل نشاط لا يساهم فى تحقيق دخل يخضع للضريبة فى مصر.$b4$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins4;

WITH ins5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 5, 0, $h5$لائحة 991/2005 > الكتاب الأول: أحكام عامة > مادة 5$h5$, $b5$يعتبر السمسار أو الوكيل قد كرس معظم وقته أو جهده خلال الفترة الضريبية لصالح شركة أجنبية، فى تطبيق حكم البند [7] من الفقرة الثالثة من المادة (4) من القانون، إذا كان نشاطه على نحو كلى أو شبه كلى باسم الشركة، وكانت الشروط التى تنظم علاقتهما التجارية والمالية تختلف عن الشروط التى تنظم العلاقة بين المؤسسات المستقلة.$b5$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins5;

WITH ins6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 6, 0, $h6$لائحة 991/2005 > الكتاب الأول: أحكام عامة > مادة 6$h6$, $b6$يجوز حساب الضريبة عن فترة تقل أو تزيد على اثنى عشر شهراً فى الحالات الآتية:
1 - الحالات التى يجوز فيها حساب فترة الضريبة عن فترة تقل عن اثنى عشر شهراً:
أ - الفترة المالية الأولى للممول، سواء انتهت هذه الفترة فى نهاية السنة الميلادية أو فى تاريخ آخر يتخذه الممول نهاية لسنته المالية.
ب - وفاة الممول أو انقطاع إقامته أو توقفه عن مزاولة النشاط أو تنازله عن المنشأة قبل نهاية السنة المالية له.
ج - إذا أمسك الممول حسابات منتظمة خلال إحدى سنواته المالية.
د - عند تعديل الممول نهاية سنته المالية، وفى هذه الحالة يتم حساب الضريبة عن الفترة من بداية السنة المالية قبل تعديلها حتى تاريخ تعديل السنة المالية.
2 - الحالات التى يجوز فيها حساب فترة الضريبة عن فترة ضريبية تزيد على اثنى عشر شهراً:
أ - إقفال حسابات الشخص الاعتبارى فى أول سنة مالية له تنفيذاً لما ينص عليه نظامه الأساسى أو عقد الشركة.
ب - تعديل الممول نهاية سنته المالية، فإذا كانت المدة من بداية السنة المالية حتى تاريخ تعديل السنة المالية لا تجاوز ثلاثة أشهر تدخل هذه الفترة ضمن الفترة الضريبية الأولى.
ويكون سعر الضريبة، المنصوص عليه فى المادتين (8) و(49) من القانون، هو الواجب التطبيق سواء بالنسبة للأرباح الناتجة عن ممارسة النشاط خلال فترة ضريبية كاملة [12 شهراً] أو إذا تم حساب الضريبة عن فترة تزيد على أو تقل عن 12 شهراً، وذلك دون إدخال أى تعديل عليه سواء عن طريق تخفيض السعر أو زيادته أو تغيير فى الشرائح بتنسيبها إلى فترة ممارسة النشاط.$b6$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins6;

WITH ins7 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 7, 0, $h7$لائحة 991/2005 > الكتاب الأول: أحكام عامة > مادة 7$h7$, $b7$يجوز لمصلحة الضرائب فى جميع الأحوال بناء على طلب الممول على النموذج (1 طلبات) أن ترخص له بتغيير الفترة الضريبية إذا توافرت الشروط الآتية:
1 - أن يكون من الأشخاص الاعتبارية المنصوص عليها فى المادتين (47) و(48) من القانون.
2 - أن يكون لديه دفاتر وحسابات منتظمة.
3 - وجود أسباب جوهرية لتغيير الفترة الضريبية، منها:
[أ]- طلب الشركة التابعة أو الفرع الأجنبى تعديل سنته المالية بما يتفق مع السنة المالية للشركة القابضة أو المركز الرئيسي.
[ب]- تغيير الشكل القانونى للشخص الاعتبارى.
4 - أن تكون مدة الفترة الضريبية اثنى عشر شهراً.$b7$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2005-12-28'::date, 'active' FROM ins7;

-- ===== كتلة التحقق النهائية =====

DO $verify077$
DECLARE
    v_law_id uuid;
    v_enactment_count INT;
    v_enactment_versions INT;
    v_book1_count INT;
    v_book1_versions INT;
    v_book1_min INT;
    v_book1_max INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 077: تعذر العثور على سجل اللائحة بعد الإدراج.';
    END IF;

    SELECT COUNT(*) INTO v_enactment_count
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = -1;
    IF v_enactment_count <> 4 THEN
        RAISE EXCEPTION 'migration 077: عدد مواد الإصدار المتوقع 4 لكن الفعلى %', v_enactment_count;
    END IF;

    SELECT COUNT(*) INTO v_enactment_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_suffix_order = -1;
    IF v_enactment_versions <> 4 THEN
        RAISE EXCEPTION 'migration 077: عدد نسخ مواد الإصدار المتوقع 4 لكن الفعلى %', v_enactment_versions;
    END IF;

    SELECT COUNT(*) INTO v_book1_count
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 1 AND 7;
    IF v_book1_count <> 7 THEN
        RAISE EXCEPTION 'migration 077: عدد مواد الكتاب الأول المتوقع 7 لكن الفعلى %', v_book1_count;
    END IF;

    SELECT COUNT(*) INTO v_book1_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_suffix_order = 0
        AND a.article_no BETWEEN 1 AND 7;
    IF v_book1_versions <> 7 THEN
        RAISE EXCEPTION 'migration 077: عدد نسخ مواد الكتاب الأول المتوقع 7 لكن الفعلى %', v_book1_versions;
    END IF;

    SELECT MIN(article_no), MAX(article_no) INTO v_book1_min, v_book1_max
    FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0
        AND article_no BETWEEN 1 AND 7;
    IF v_book1_min <> 1 OR v_book1_max <> 7 THEN
        RAISE EXCEPTION 'migration 077: مدى أرقام الكتاب الأول المتوقع 1-7 لكن الفعلى %-%', v_book1_min, v_book1_max;
    END IF;

    RAISE NOTICE 'migration 077 (اللائحة التنفيذية 991/2005 - الكتاب الأول): تم بنجاح. % مادة إصدار، % مادة فى الكتاب الأول، مدى أرقام الكتاب 1-7.', v_enactment_count, v_book1_count;
END $verify077$;

COMMIT;
