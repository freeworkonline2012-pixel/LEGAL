-- =====================================================================
-- Migration 083: قرار وزير المالية رقم 778 لسنة 2010 بتعديل
--                        بعض أحكام اللائحة التنفيذية لقانون الضريبة على
--                        الدخل الصادرة بقرار وزير المالية 991/2005 -
--                        إضافة المواد الجديدة 99 مكررا (1) إلى (4)
-- =====================================================================
--
-- المصدر: الوقائع المصرية، العدد 274 (تابع)، أول ديسمبر سنة 2010،
--   صفحتان، موقَّع د. يوسف بطرس غالى وزير المالية، تحريراً فى 2010/12/1.
--   مسح ضوئى بطبقة نص قابلة للاستخراج - تم نقل النص الكامل حرفياً.
--
-- محتوى القرار: المادة الأولى تضيف 4 مواد جديدة برقم "99 مكررا" مع
--   ترقيم فرعى (1) إلى (4) إلى اللائحة التنفيذية، موضوعها الالتزامات
--   المتعلقة بالفواتير والإيصالات لأصحاب الأعمال التجارية والصناعية
--   وأصحاب المهن غير التجارية. المادة الثانية: النفاذ من اليوم التالى
--   لتاريخ النشر (2010/12/2).
--
-- فجوة موثقة (لا اختلاق): ديباجة القرار تشير إلى "قانون الضريبة على
--   الدخل الصادر بالقانون رقم 91 لسنة 2005 المعدل بالقانون رقم 73 لسنة
--   2010" - قانون 73/2010 نفسه غير مرفوع ولم يُبنَ هنا؛ موثَّق سلفاً فى
--   تقرير الجرد
--   (claude/تقرير-جرد-وتصنيف-تعديلات-قانون-الضريبة-على-الدخل-91-2005-2026-10-02.md).
--
-- التمثيل فى قاعدة البيانات: article_no=99 (نفس رقم المادة الأصلية التى
--   أُدرجت فى migration 082 بـ article_suffix_order=0)، مع
--   article_suffix_order=1..4 لتمييز "99 مكررا (1)"
--   إلى "99 مكررا (4)" - امتداد لمبدأ الترقيم الفرعى المعتمد فى قانون
--   الشركات 159/1981، مُطبَّق هنا لأول مرة لتمثيل 4 مواد فرعية متتالية
--   بدلاً من واحدة.
--
-- الدرس الجذرى المُطبَّق على كتلة التحقق: migration 082 افترضت خطأً
--   أنها "الهجرة الأخيرة فى سلسلة اللائحة" وأضافت تحققاً نهائياً على
--   مستوى اللائحة بالكامل. هذه الهجرة (083) تثبت أن ذلك الافتراض كان
--   خاطئاً - فهى تضيف صفوفاً جديدة لنفس سجل اللائحة بعد اكتمالها
--   الظاهرى. لذلك كتلة تحقق 083 مُقيَّدة حصراً بنطاق المواد الجديدة
--   التى تُضيفها هى بعينها (article_no=99, suffix IN (1..4))
--   ولا تفترض أى شىء عن "النهاية" - بما يحمى أى هجرة مستقبلية تضيف مواد
--   أخرى للائحة من الانكسار.
--
-- عدد صفوف هذه الهجرة: 4 مادة جديدة (article_no=99,
--   suffix_order 1-4)، كل منها بنسخة واحدة
--   (version_no=1)، effective_from = '2010-12-02'.
--
-- قابلة لإعادة التشغيل بأمان (idempotent) عبر ON CONFLICT DO NOTHING.
--
-- =====================================================================

BEGIN;

-- ===== قرار 778/2010: مواد 99 مكررا (1)-(4) =====
WITH ins1 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 99, 1, $h1$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > إضافة بقرار وزير المالية 778/2010 > مادة 99 مكررا (1)$h1$, $b1$على كل مزاول من أصحاب الأعمال التجارية والصناعية ومن أصحاب المهن غير التجارية حيازة فواتير تتكون من جزئين، جزء كعب يظل بحوزة الممول بعد أداء الخدمة أو تسليم السلعة، وجزء يسلم إلى العميل مقابل الحصول على الخدمة أو السلعة وسداد قيمتها.$b1$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2010-12-02'::date, 'active' FROM ins1;

WITH ins2 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 99, 2, $h2$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > إضافة بقرار وزير المالية 778/2010 > مادة 99 مكررا (2)$h2$, $b2$يجب أن تتضمن الفاتورة البيانات الآتية كحد أدنى:
اسم الممول .
رقم التسجيل الضريبى .
رقم الفاتورة المسلسل .
اسم مشترى السلعة ومتلقى الخدمة .
تاريخ تحرير الفاتورة .
نوع السلعة أو الخدمة المباعة .
قيمة السلعة أو الخدمة المباعة .
ويستثنى الممولون من أصحاب الأعمال التجارية من إثبات بيان اسم مشترى السلعة أو متلقى الخدمة فى الفاتورة .
ويجب أن يتضمن الكعب الذى يحتفظ به المول اسم المستفيد، تاريخ الخدمة والمبلغ المدفوع، ويجوز استخدام نسخة كربون بدلاً من الكعب .
وعلى أصحاب المهن الحرة تسجيل اسم المستفيد والمبلغ المدفوع حتمياً على كل من الأصل والصورة من الكعب أو الفاتورة .$b2$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2010-12-02'::date, 'active' FROM ins2;

WITH ins3 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 99, 3, $h3$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > إضافة بقرار وزير المالية 778/2010 > مادة 99 مكررا (3)$h3$, $b3$تقوم مصلحة الضرائب إذا اقتضت ضرورة الفحص بمراجعة المبالغ المحصلة من واقع دفتر أو دفاتر الفواتير بإجمالى دخل المنشأة، وفى حالة عدم وجود فواتير، يجوز للمصلحة أن تأخذ بقيمة مطبة أو دخل مبيعات حددها فى ضوء الأعراف المتداولة فى السوق بالنسبة للسلعة أو الخدمة المقدمة .$b3$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2010-12-02'::date, 'active' FROM ins3;

WITH ins4 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 99, 4, $h4$لائحة 991/2005 > الكتاب السادس: التزامات الممولين وغيرهم > الباب الأول: الإخطار وإمساك الدفاتر > إضافة بقرار وزير المالية 778/2010 > مادة 99 مكررا (4)$h4$, $b4$على المصلحة فى حالة عدم تساوى مجموع قيمة الفواتير الصادرة مع إجمالى الدخل المعلن فى الإقرار البحث عن دلائل أخرى تنفى إقرار أو نفى التهرب الضريبى .
وإذا حصلت المصلحة على إقرارات من المستفيدين من الخدمة أو مشترى السلعة محل الفحص تثبت دفع مبالغ غير ثابتة فى دفتر الفواتير، فإن ذلك يعد تهرباً، تتخذ فى شأنه الإجراءات المقررة قانوناً .$b4$
    FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2010-12-02'::date, 'active' FROM ins4;

-- ===== كتلة التحقق (مُقيَّدة حصراً بالمواد الجديدة) =====

DO $verify083$
DECLARE
    v_law_id uuid;
    v_base_art99_exists INT;
    v_new_count INT;
    v_new_versions INT;
    v_suffix_min INT;
    v_suffix_max INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 083: سجل اللائحة غير موجود - يجب تشغيل migration 077 أولاً.';
    END IF;

    -- سلامة منطقية: المادة الأصلية 99 (suffix=0) يجب أن تكون موجودة سلفاً
    -- من migration 082 قبل إضافة "99 مكررا" التابعة لها.
    SELECT COUNT(*) INTO v_base_art99_exists
    FROM articles WHERE law_id = v_law_id AND article_no = 99 AND article_suffix_order = 0;
    IF v_base_art99_exists <> 1 THEN
        RAISE EXCEPTION 'migration 083: المادة 99 الأصلية (suffix=0) غير موجودة - يجب تشغيل migration 082 أولاً.';
    END IF;

    -- تحقق مُقيَّد حصراً بنطاق المواد الجديدة التى تُضيفها هذه الهجرة
    -- بعينها (article_no=99, article_suffix_order IN (1..4)) - لا تحقق
    -- من أى إجمالى تراكمى على مستوى اللائحة بالكامل (انظر تعليق أعلى
    -- الملف لشرح سبب تجنُّب ذلك عمداً).
    SELECT COUNT(*) INTO v_new_count
    FROM articles
    WHERE law_id = v_law_id AND article_no = 99 AND article_suffix_order BETWEEN 1 AND 4;
    IF v_new_count <> 4 THEN
        RAISE EXCEPTION 'migration 083: عدد مواد "99 مكررا" الجديدة المتوقع 4 لكن الفعلى %', v_new_count;
    END IF;

    SELECT COUNT(*) INTO v_new_versions
    FROM article_versions av
    JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND a.article_no = 99 AND a.article_suffix_order BETWEEN 1 AND 4;
    IF v_new_versions <> 4 THEN
        RAISE EXCEPTION 'migration 083: عدد نسخ مواد "99 مكررا" الجديدة المتوقع 4 لكن الفعلى %', v_new_versions;
    END IF;

    SELECT MIN(article_suffix_order), MAX(article_suffix_order) INTO v_suffix_min, v_suffix_max
    FROM articles WHERE law_id = v_law_id AND article_no = 99 AND article_suffix_order BETWEEN 1 AND 4;
    IF v_suffix_min <> 1 OR v_suffix_max <> 4 THEN
        RAISE EXCEPTION 'migration 083: مدى الترقيم الفرعى المتوقع 1-4 لكن الفعلى %-%', v_suffix_min, v_suffix_max;
    END IF;

    RAISE NOTICE 'migration 083 (قرار 778/2010 - إضافة مادة 99 مكررا (1)-(4) إلى لائحة 991/2005): تم بنجاح. % مادة جديدة أُضيفت.', v_new_count;
END $verify083$;

COMMIT;
