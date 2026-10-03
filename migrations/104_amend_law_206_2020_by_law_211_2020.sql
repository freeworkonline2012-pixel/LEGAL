-- =====================================================================
-- Migration 104: تعديل قانون الإجراءات الضريبية الموحد 206/2020
--                        بموجب القانون رقم 211 لسنة 2020
-- =====================================================================
--
-- أول هجرة فى سلسلة تعديلات قانون 206/2020 نفسه (بعد migration 103: الزرع
--   التأسيسى).
--
-- المصدر: الجريدة الرسمية، العدد 49 (تابع)، 3 ديسمبر 2020، ثلاث صفحات
--   (3-5). قُرئ بالكامل مرتين هذه الجلسة (تحقق مزدوج). موقَّع الرئيس عبد
--   الفتاح السيسى 2020-12-03.
--
-- ست عمليات (المادتان الأولى والثانية من هذا القانون):
--   1) المادة (13/فقرة أخيرة) - استبدال جزئى: من مبلغ موحد (1%) إلى أربع
--      نسب متفاوتة (1%/3%/3%/2%) بحسب نوع المستند غير المقدم، بسقف أقصى
--      (3%) عند تعدد المخالفات.
--   2) المادة (44) - استبدال كامل: إحالة لتقادم جنائى خاص (74 مكررًا)
--      بدلاً من تمييز 5/6 سنوات.
--   3) المادة (70) - استبدال كامل: تشديد جوهرى للعقوبة (غرامة من
--      5,000-200,000 إلى 50,000-مليونى جنيه + عقوبة حبس عند التكرار).
--   4) المادة (73) - استبدال كامل: ⚠️ قلب عبء إثبات العلم بواقعة التهرب
--      (من إثبات العلم على جهة الاتهام إلى إثبات عدم العلم على المسئول).
--   5) مادة جديدة (73 مكررًا) - إحالة عامة لنصوص التجريم والعقاب الأخرى.
--   6) مادة جديدة (74 مكررًا) - تقادم جنائى خاص: خمس سنوات من نهاية
--      السنة التى تستحق عنها الضريبة.
--
-- effective_from = 2020-12-04 (اليوم التالى لتاريخ النشر 2020-12-03،
--   صراحة من نص المادة الثالثة من هذا القانون).
--
-- نفس القرار المعمارى المُتَّبع فى سلسلة تعديلات 91/2005 (084-102):
--   UPDATE مباشر لنص المادة (لا إدراج نسخة article_versions جديدة)، عبر
--   وحدة amend_common_206.py (نسخة مُعاد توجيهها من amend_common.py
--   لقانون 206/2020 بدلاً من 91/2005).
--
-- قابلة لإعادة التشغيل بأمان (idempotent) - UPDATE/UPSERT بقيمة ثابتة.
--
-- =====================================================================

BEGIN;

-- ===== عمليات التعديل =====
-- مادة 13 (suffix=0) - UPDATE (effective_from=2020-12-04)
UPDATE articles SET body = $b104_1$يجب تقديم المستندات المنصوص عليها فى المادة (12) من هذا القانون طبقًا لما يأتى :
( أ ) الملف الرئيس : وفقًا لتاريخ تقديم الملف الرئيس إلى الإدارة الضريبية فى دولة الإقامة للكيان الأم أو الشركة الأم لمجموعة الأشخاص المرتبطة .
(ب) الملف المحلى : خلال شهرين من تاريخ تقديم الممول لإقراره الضريبى السنوى فى مصر .
(ج) تقرير على مستوى كل دولة على حدة : خلال عام من نهاية السنة الضريبية المتعلقة بالفحص والربط .
ويلتزم كل شخص لديه معاملات تجارية أو مالية مع أشخاص مرتبطة حال الإخلال بالالتزام المنصوص عليه فى الفقرة الأولى من المادة (12) من هذا القانون، والفقرة الأولى من هذه المادة بأن يؤدى للمصلحة مبلغًا يعادل :
(1%) من قيمة المعاملات مع الأشخاص المرتبطة التى لم يقر عنها فى حالة عدم الإفصاح ضمن الإقرار الضريبى عن المعاملات مع الأشخاص المرتبطة طبقًا لنموذج الإقرار .
(3%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم الملف المحلى .
(3%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم الملف الرئيسى .
(2%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم التقرير أو الإخطار على مستوى كل دولة على حدة .
ولا يجوز أن تزيد قيمة المبلغ المشار إليه على ما يعادل (3%) من قيمة المعاملات مع الأشخاص المرتبطة حال تعدد المخالفات سالفة الذكر .$b104_1$, updated_at = now()
WHERE law_id = (SELECT id FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law')
  AND article_no = 13 AND article_suffix_order = 0;

UPDATE article_versions SET
    body = $b104_1$يجب تقديم المستندات المنصوص عليها فى المادة (12) من هذا القانون طبقًا لما يأتى :
( أ ) الملف الرئيس : وفقًا لتاريخ تقديم الملف الرئيس إلى الإدارة الضريبية فى دولة الإقامة للكيان الأم أو الشركة الأم لمجموعة الأشخاص المرتبطة .
(ب) الملف المحلى : خلال شهرين من تاريخ تقديم الممول لإقراره الضريبى السنوى فى مصر .
(ج) تقرير على مستوى كل دولة على حدة : خلال عام من نهاية السنة الضريبية المتعلقة بالفحص والربط .
ويلتزم كل شخص لديه معاملات تجارية أو مالية مع أشخاص مرتبطة حال الإخلال بالالتزام المنصوص عليه فى الفقرة الأولى من المادة (12) من هذا القانون، والفقرة الأولى من هذه المادة بأن يؤدى للمصلحة مبلغًا يعادل :
(1%) من قيمة المعاملات مع الأشخاص المرتبطة التى لم يقر عنها فى حالة عدم الإفصاح ضمن الإقرار الضريبى عن المعاملات مع الأشخاص المرتبطة طبقًا لنموذج الإقرار .
(3%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم الملف المحلى .
(3%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم الملف الرئيسى .
(2%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم التقرير أو الإخطار على مستوى كل دولة على حدة .
ولا يجوز أن تزيد قيمة المبلغ المشار إليه على ما يعادل (3%) من قيمة المعاملات مع الأشخاص المرتبطة حال تعدد المخالفات سالفة الذكر .$b104_1$,
    effective_from = '2020-12-04'::date,
    amended_by_law_no = 211,
    amended_by_law_year = 2020,
    change_note = $n104_1$استُبدلت الفقرة الأخيرة فقط من المادة (13) بالمادة الأولى من القانون 211/2020: من مبلغ موحد (1%) إلى أربع نسب متفاوتة (1%/3%/3%/2%) بحسب نوع المستند غير المقدم، مع سقف أقصى (3%) عند تعدد المخالفات. الفقرة الأولى وبنودها (أ،ب،ج) دون تغيير.$n104_1$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 206 AND l.law_year = 2020 AND l.kind = 'law'
      AND a.article_no = 13 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 44 (suffix=0) - UPDATE (effective_from=2020-12-04)
UPDATE articles SET body = $b104_2$مع عدم الإخلال بحكم المادة (74 مكررًا) من هذا القانون، لا يجوز للمصلحة فى جميع الأحوال إجراء تقدير أو تعديل للضريبة إلا خلال خمس سنوات من تاريخ انتهاء المدة المحددة قانونًا لتقديم الإقرار عن الفترة الضريبية .
وينقطع التقادم لأى سبب من الأسباب المنصوص عليها فى القانون المدنى أو بالإخطار بربط الضريبة أو بالتنبيه على الممول أو المكلف بأدائها أو بالإحالة إلى لجان الطعن .$b104_2$, updated_at = now()
WHERE law_id = (SELECT id FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law')
  AND article_no = 44 AND article_suffix_order = 0;

UPDATE article_versions SET
    body = $b104_2$مع عدم الإخلال بحكم المادة (74 مكررًا) من هذا القانون، لا يجوز للمصلحة فى جميع الأحوال إجراء تقدير أو تعديل للضريبة إلا خلال خمس سنوات من تاريخ انتهاء المدة المحددة قانونًا لتقديم الإقرار عن الفترة الضريبية .
وينقطع التقادم لأى سبب من الأسباب المنصوص عليها فى القانون المدنى أو بالإخطار بربط الضريبة أو بالتنبيه على الممول أو المكلف بأدائها أو بالإحالة إلى لجان الطعن .$b104_2$,
    effective_from = '2020-12-04'::date,
    amended_by_law_no = 211,
    amended_by_law_year = 2020,
    change_note = $n104_2$استُبدلت المادة (44) بالكامل بالمادة الأولى من القانون 211/2020: حُذف التمييز بين خمس سنوات (عادى) وست سنوات (تهرب) وأُحيل بدلاً منه إلى تقادم خاص بالدعوى الجنائية فى المادة الجديدة (74 مكررًا)؛ أُضيف 'التنبيه على الممول أو المكلف بأدائها' كسبب مستقل لقطع التقادم.$n104_2$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 206 AND l.law_year = 2020 AND l.kind = 'law'
      AND a.article_no = 44 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 70 (suffix=0) - UPDATE (effective_from=2020-12-04)
UPDATE articles SET body = $b104_3$يُعاقب على عدم تقديم الإقرار الضريبى المنصوص عليه فى المادة (31) من هذا القانون لمدة تتجاوز ستين يومًا من تاريخ انتهاء المواعيد المحددة لتقديمه بغرامة لا تقل عن خمسين ألف جنيه ولا تجاوز مليونى جنيه .
وفى حالة تكرار هذه الجريمة لأكثر من ستة إقرارات شهرية أو ثلاثة إقرارات سنوية تكون العقوبة الغرامة المشار إليها فى الفقرة السابقة والحبس مدة لا تقل عن ستة أشهر ولا تجاوز ثلاث سنوات، أو بإحدى هاتين العقوبتين .$b104_3$, updated_at = now()
WHERE law_id = (SELECT id FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law')
  AND article_no = 70 AND article_suffix_order = 0;

UPDATE article_versions SET
    body = $b104_3$يُعاقب على عدم تقديم الإقرار الضريبى المنصوص عليه فى المادة (31) من هذا القانون لمدة تتجاوز ستين يومًا من تاريخ انتهاء المواعيد المحددة لتقديمه بغرامة لا تقل عن خمسين ألف جنيه ولا تجاوز مليونى جنيه .
وفى حالة تكرار هذه الجريمة لأكثر من ستة إقرارات شهرية أو ثلاثة إقرارات سنوية تكون العقوبة الغرامة المشار إليها فى الفقرة السابقة والحبس مدة لا تقل عن ستة أشهر ولا تجاوز ثلاث سنوات، أو بإحدى هاتين العقوبتين .$b104_3$,
    effective_from = '2020-12-04'::date,
    amended_by_law_no = 211,
    amended_by_law_year = 2020,
    change_note = $n104_3$استُبدلت المادة (70) بالكامل بالمادة الأولى من القانون 211/2020: تشديد جوهرى للعقوبة - الغرامة من (5,000-200,000 جنيه) إلى (50,000 جنيه-مليونى جنيه)، وإضافة عقوبة حبس (6 أشهر-3 سنوات) عند تكرار الجريمة لأكثر من ست إقرارات شهرية أو ثلاث سنوية (بدلاً من مجرد مضاعفة الغرامة خلال ثلاث سنوات).$n104_3$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 206 AND l.law_year = 2020 AND l.kind = 'law'
      AND a.article_no = 70 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 73 (suffix=0) - UPDATE (effective_from=2020-12-04)
UPDATE articles SET body = $b104_4$فى حالة وقوع أى فعل من أفعال التهرب من الضريبة من أحد الأشخاص الاعتبارية المنصوص عليها فى القانون الضريبى يكون المسئول عنه الشريك المسئول أو المدير أو عضو مجلس الإدارة المنتدب أو رئيس مجلس الإدارة ممن يتولون الإدارة الفعلية على حسب الأحوال .
وللمسئول إثبات عدم علمه بواقعة التهرب .$b104_4$, updated_at = now()
WHERE law_id = (SELECT id FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law')
  AND article_no = 73 AND article_suffix_order = 0;

UPDATE article_versions SET
    body = $b104_4$فى حالة وقوع أى فعل من أفعال التهرب من الضريبة من أحد الأشخاص الاعتبارية المنصوص عليها فى القانون الضريبى يكون المسئول عنه الشريك المسئول أو المدير أو عضو مجلس الإدارة المنتدب أو رئيس مجلس الإدارة ممن يتولون الإدارة الفعلية على حسب الأحوال .
وللمسئول إثبات عدم علمه بواقعة التهرب .$b104_4$,
    effective_from = '2020-12-04'::date,
    amended_by_law_no = 211,
    amended_by_law_year = 2020,
    change_note = $n104_4$استُبدلت المادة (73) بالكامل بالمادة الأولى من القانون 211/2020: ⚠️ تغيير جوهرى فى عبء الإثبات - النص التأسيسى كان يشترط إثبات علم المسئول بالواقعة وإسهامه فيها بإخلاله بواجباته (عبء على جهة الاتهام)؛ النص الجديد يحذف هذا الشرط ويضيف بدلاً منه حق المسئول فى إثبات عدم علمه (قلب لقرينة العلم - العلم مفترض ما لم يُثبت المسئول عكسه).$n104_4$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 206 AND l.law_year = 2020 AND l.kind = 'law'
      AND a.article_no = 73 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 73 (suffix=1) - INSERT/UPSERT جديدة (effective_from=2020-12-04)
WITH ins104_5 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 73, 1, $h104_5$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 73 مكررًا$h104_5$, $b104_5$يُعمل فيما لم يرد بشأنه نص خاص فى هذا الباب بنصوص التجريم والعقاب التى يتضمنها القانون الضريبى أو أى قانون آخر.$b104_5$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO UPDATE SET
        hierarchical_location = EXCLUDED.hierarchical_location,
        body = EXCLUDED.body,
        updated_at = now()
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2020-12-04'::date, 'active', 211, 2020, $n104_5$مادة جديدة أضافتها المادة الثانية من القانون 211/2020: إحالة عامة إلى نصوص التجريم والعقاب فى القانون الضريبى أو أى قانون آخر فيما لم يرد بشأنه نص خاص فى الباب التاسع.$n104_5$ FROM ins104_5
ON CONFLICT (article_id, version_no) DO UPDATE SET
    body = EXCLUDED.body,
    effective_from = EXCLUDED.effective_from,
    status = 'active',
    amended_by_law_no = EXCLUDED.amended_by_law_no,
    amended_by_law_year = EXCLUDED.amended_by_law_year,
    change_note = EXCLUDED.change_note;

-- مادة 74 (suffix=1) - INSERT/UPSERT جديدة (effective_from=2020-12-04)
WITH ins104_6 AS (
    INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
    SELECT id, 74, 1, $h104_6$قانون 206/2020 > الباب التاسع: الجرائم والعقوبات > مادة 74 مكررًا$h104_6$, $b104_6$يبدأ حساب تقادم الدعوى الجنائية فى الجرائم المنصوص عليها فى هذا القانون أو القانون الضريبى بعد مضى خمس سنوات من نهاية السنة التى تستحق عنها الضريبة.$b104_6$
    FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law'
    ON CONFLICT (law_id, article_no, article_suffix_order) DO UPDATE SET
        hierarchical_location = EXCLUDED.hierarchical_location,
        body = EXCLUDED.body,
        updated_at = now()
    RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2020-12-04'::date, 'active', 211, 2020, $n104_6$مادة جديدة أضافتها المادة الثانية من القانون 211/2020: تقادم خاص للدعوى الجنائية فى جرائم هذا القانون أو القانون الضريبى - خمس سنوات من نهاية السنة التى تستحق عنها الضريبة، وإليها تحيل المادة (44) المعدَّلة.$n104_6$ FROM ins104_6
ON CONFLICT (article_id, version_no) DO UPDATE SET
    body = EXCLUDED.body,
    effective_from = EXCLUDED.effective_from,
    status = 'active',
    amended_by_law_no = EXCLUDED.amended_by_law_no,
    amended_by_law_year = EXCLUDED.amended_by_law_year,
    change_note = EXCLUDED.change_note;

-- ===== كتلة التحقق =====

DO $verify104$
DECLARE
    v_law_id uuid;
    v_art_body text;
    v_ver_body text;
    v_amended_no int;
    v_amended_year int;
    v_status text;
    v_eff_from date;
    v_eff_to date;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 206 AND law_year = 2020 AND kind = 'law';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 104: سجل قانون 206/2020 غير موجود - يجب تشغيل migration 103 أولاً.';
    END IF;

    SELECT a.body, av.body, av.amended_by_law_no, av.amended_by_law_year, av.status, av.effective_from
    INTO v_art_body, v_ver_body, v_amended_no, v_amended_year, v_status, v_eff_from
    FROM articles a
    JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_no = 13 AND a.article_suffix_order = 0;

    IF v_art_body IS NULL THEN
        RAISE EXCEPTION 'migration 104: المادة 13 (suffix=0) غير موجودة.';
    END IF;
    IF v_art_body <> $vb104_1$يجب تقديم المستندات المنصوص عليها فى المادة (12) من هذا القانون طبقًا لما يأتى :
( أ ) الملف الرئيس : وفقًا لتاريخ تقديم الملف الرئيس إلى الإدارة الضريبية فى دولة الإقامة للكيان الأم أو الشركة الأم لمجموعة الأشخاص المرتبطة .
(ب) الملف المحلى : خلال شهرين من تاريخ تقديم الممول لإقراره الضريبى السنوى فى مصر .
(ج) تقرير على مستوى كل دولة على حدة : خلال عام من نهاية السنة الضريبية المتعلقة بالفحص والربط .
ويلتزم كل شخص لديه معاملات تجارية أو مالية مع أشخاص مرتبطة حال الإخلال بالالتزام المنصوص عليه فى الفقرة الأولى من المادة (12) من هذا القانون، والفقرة الأولى من هذه المادة بأن يؤدى للمصلحة مبلغًا يعادل :
(1%) من قيمة المعاملات مع الأشخاص المرتبطة التى لم يقر عنها فى حالة عدم الإفصاح ضمن الإقرار الضريبى عن المعاملات مع الأشخاص المرتبطة طبقًا لنموذج الإقرار .
(3%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم الملف المحلى .
(3%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم الملف الرئيسى .
(2%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم التقرير أو الإخطار على مستوى كل دولة على حدة .
ولا يجوز أن تزيد قيمة المبلغ المشار إليه على ما يعادل (3%) من قيمة المعاملات مع الأشخاص المرتبطة حال تعدد المخالفات سالفة الذكر .$vb104_1$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 13 (articles.body) لا يطابق المتوقع.';
    END IF;
    IF v_ver_body <> $vb104_1$يجب تقديم المستندات المنصوص عليها فى المادة (12) من هذا القانون طبقًا لما يأتى :
( أ ) الملف الرئيس : وفقًا لتاريخ تقديم الملف الرئيس إلى الإدارة الضريبية فى دولة الإقامة للكيان الأم أو الشركة الأم لمجموعة الأشخاص المرتبطة .
(ب) الملف المحلى : خلال شهرين من تاريخ تقديم الممول لإقراره الضريبى السنوى فى مصر .
(ج) تقرير على مستوى كل دولة على حدة : خلال عام من نهاية السنة الضريبية المتعلقة بالفحص والربط .
ويلتزم كل شخص لديه معاملات تجارية أو مالية مع أشخاص مرتبطة حال الإخلال بالالتزام المنصوص عليه فى الفقرة الأولى من المادة (12) من هذا القانون، والفقرة الأولى من هذه المادة بأن يؤدى للمصلحة مبلغًا يعادل :
(1%) من قيمة المعاملات مع الأشخاص المرتبطة التى لم يقر عنها فى حالة عدم الإفصاح ضمن الإقرار الضريبى عن المعاملات مع الأشخاص المرتبطة طبقًا لنموذج الإقرار .
(3%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم الملف المحلى .
(3%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم الملف الرئيسى .
(2%) من قيمة المعاملات مع الأشخاص المرتبطة فى حالة عدم تقديم التقرير أو الإخطار على مستوى كل دولة على حدة .
ولا يجوز أن تزيد قيمة المبلغ المشار إليه على ما يعادل (3%) من قيمة المعاملات مع الأشخاص المرتبطة حال تعدد المخالفات سالفة الذكر .$vb104_1$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 13 (article_versions.body) لا يطابق المتوقع.';
    END IF;
    IF v_amended_no <> 211 OR v_amended_year <> 2020 THEN
        RAISE EXCEPTION 'migration 104: amended_by_law_no/year للمادة 13 غير مطابق (متوقع 211/2020).';
    END IF;
    IF v_eff_from <> '2020-12-04'::date THEN
        RAISE EXCEPTION 'migration 104: effective_from للمادة 13 غير مطابق (متوقع 2020-12-04، الفعلى %)', v_eff_from;
    END IF;

    SELECT a.body, av.body, av.amended_by_law_no, av.amended_by_law_year, av.status, av.effective_from
    INTO v_art_body, v_ver_body, v_amended_no, v_amended_year, v_status, v_eff_from
    FROM articles a
    JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_no = 44 AND a.article_suffix_order = 0;

    IF v_art_body IS NULL THEN
        RAISE EXCEPTION 'migration 104: المادة 44 (suffix=0) غير موجودة.';
    END IF;
    IF v_art_body <> $vb104_2$مع عدم الإخلال بحكم المادة (74 مكررًا) من هذا القانون، لا يجوز للمصلحة فى جميع الأحوال إجراء تقدير أو تعديل للضريبة إلا خلال خمس سنوات من تاريخ انتهاء المدة المحددة قانونًا لتقديم الإقرار عن الفترة الضريبية .
وينقطع التقادم لأى سبب من الأسباب المنصوص عليها فى القانون المدنى أو بالإخطار بربط الضريبة أو بالتنبيه على الممول أو المكلف بأدائها أو بالإحالة إلى لجان الطعن .$vb104_2$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 44 (articles.body) لا يطابق المتوقع.';
    END IF;
    IF v_ver_body <> $vb104_2$مع عدم الإخلال بحكم المادة (74 مكررًا) من هذا القانون، لا يجوز للمصلحة فى جميع الأحوال إجراء تقدير أو تعديل للضريبة إلا خلال خمس سنوات من تاريخ انتهاء المدة المحددة قانونًا لتقديم الإقرار عن الفترة الضريبية .
وينقطع التقادم لأى سبب من الأسباب المنصوص عليها فى القانون المدنى أو بالإخطار بربط الضريبة أو بالتنبيه على الممول أو المكلف بأدائها أو بالإحالة إلى لجان الطعن .$vb104_2$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 44 (article_versions.body) لا يطابق المتوقع.';
    END IF;
    IF v_amended_no <> 211 OR v_amended_year <> 2020 THEN
        RAISE EXCEPTION 'migration 104: amended_by_law_no/year للمادة 44 غير مطابق (متوقع 211/2020).';
    END IF;
    IF v_eff_from <> '2020-12-04'::date THEN
        RAISE EXCEPTION 'migration 104: effective_from للمادة 44 غير مطابق (متوقع 2020-12-04، الفعلى %)', v_eff_from;
    END IF;

    SELECT a.body, av.body, av.amended_by_law_no, av.amended_by_law_year, av.status, av.effective_from
    INTO v_art_body, v_ver_body, v_amended_no, v_amended_year, v_status, v_eff_from
    FROM articles a
    JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_no = 70 AND a.article_suffix_order = 0;

    IF v_art_body IS NULL THEN
        RAISE EXCEPTION 'migration 104: المادة 70 (suffix=0) غير موجودة.';
    END IF;
    IF v_art_body <> $vb104_3$يُعاقب على عدم تقديم الإقرار الضريبى المنصوص عليه فى المادة (31) من هذا القانون لمدة تتجاوز ستين يومًا من تاريخ انتهاء المواعيد المحددة لتقديمه بغرامة لا تقل عن خمسين ألف جنيه ولا تجاوز مليونى جنيه .
وفى حالة تكرار هذه الجريمة لأكثر من ستة إقرارات شهرية أو ثلاثة إقرارات سنوية تكون العقوبة الغرامة المشار إليها فى الفقرة السابقة والحبس مدة لا تقل عن ستة أشهر ولا تجاوز ثلاث سنوات، أو بإحدى هاتين العقوبتين .$vb104_3$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 70 (articles.body) لا يطابق المتوقع.';
    END IF;
    IF v_ver_body <> $vb104_3$يُعاقب على عدم تقديم الإقرار الضريبى المنصوص عليه فى المادة (31) من هذا القانون لمدة تتجاوز ستين يومًا من تاريخ انتهاء المواعيد المحددة لتقديمه بغرامة لا تقل عن خمسين ألف جنيه ولا تجاوز مليونى جنيه .
وفى حالة تكرار هذه الجريمة لأكثر من ستة إقرارات شهرية أو ثلاثة إقرارات سنوية تكون العقوبة الغرامة المشار إليها فى الفقرة السابقة والحبس مدة لا تقل عن ستة أشهر ولا تجاوز ثلاث سنوات، أو بإحدى هاتين العقوبتين .$vb104_3$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 70 (article_versions.body) لا يطابق المتوقع.';
    END IF;
    IF v_amended_no <> 211 OR v_amended_year <> 2020 THEN
        RAISE EXCEPTION 'migration 104: amended_by_law_no/year للمادة 70 غير مطابق (متوقع 211/2020).';
    END IF;
    IF v_eff_from <> '2020-12-04'::date THEN
        RAISE EXCEPTION 'migration 104: effective_from للمادة 70 غير مطابق (متوقع 2020-12-04، الفعلى %)', v_eff_from;
    END IF;

    SELECT a.body, av.body, av.amended_by_law_no, av.amended_by_law_year, av.status, av.effective_from
    INTO v_art_body, v_ver_body, v_amended_no, v_amended_year, v_status, v_eff_from
    FROM articles a
    JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_no = 73 AND a.article_suffix_order = 0;

    IF v_art_body IS NULL THEN
        RAISE EXCEPTION 'migration 104: المادة 73 (suffix=0) غير موجودة.';
    END IF;
    IF v_art_body <> $vb104_4$فى حالة وقوع أى فعل من أفعال التهرب من الضريبة من أحد الأشخاص الاعتبارية المنصوص عليها فى القانون الضريبى يكون المسئول عنه الشريك المسئول أو المدير أو عضو مجلس الإدارة المنتدب أو رئيس مجلس الإدارة ممن يتولون الإدارة الفعلية على حسب الأحوال .
وللمسئول إثبات عدم علمه بواقعة التهرب .$vb104_4$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 73 (articles.body) لا يطابق المتوقع.';
    END IF;
    IF v_ver_body <> $vb104_4$فى حالة وقوع أى فعل من أفعال التهرب من الضريبة من أحد الأشخاص الاعتبارية المنصوص عليها فى القانون الضريبى يكون المسئول عنه الشريك المسئول أو المدير أو عضو مجلس الإدارة المنتدب أو رئيس مجلس الإدارة ممن يتولون الإدارة الفعلية على حسب الأحوال .
وللمسئول إثبات عدم علمه بواقعة التهرب .$vb104_4$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 73 (article_versions.body) لا يطابق المتوقع.';
    END IF;
    IF v_amended_no <> 211 OR v_amended_year <> 2020 THEN
        RAISE EXCEPTION 'migration 104: amended_by_law_no/year للمادة 73 غير مطابق (متوقع 211/2020).';
    END IF;
    IF v_eff_from <> '2020-12-04'::date THEN
        RAISE EXCEPTION 'migration 104: effective_from للمادة 73 غير مطابق (متوقع 2020-12-04، الفعلى %)', v_eff_from;
    END IF;

    SELECT a.body, av.body, av.amended_by_law_no, av.amended_by_law_year, av.status, av.effective_from
    INTO v_art_body, v_ver_body, v_amended_no, v_amended_year, v_status, v_eff_from
    FROM articles a
    JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_no = 73 AND a.article_suffix_order = 1;

    IF v_art_body IS NULL THEN
        RAISE EXCEPTION 'migration 104: المادة 73 (suffix=1) غير موجودة.';
    END IF;
    IF v_art_body <> $vb104_5$يُعمل فيما لم يرد بشأنه نص خاص فى هذا الباب بنصوص التجريم والعقاب التى يتضمنها القانون الضريبى أو أى قانون آخر.$vb104_5$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 73 (articles.body) لا يطابق المتوقع.';
    END IF;
    IF v_ver_body <> $vb104_5$يُعمل فيما لم يرد بشأنه نص خاص فى هذا الباب بنصوص التجريم والعقاب التى يتضمنها القانون الضريبى أو أى قانون آخر.$vb104_5$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 73 (article_versions.body) لا يطابق المتوقع.';
    END IF;
    IF v_amended_no <> 211 OR v_amended_year <> 2020 THEN
        RAISE EXCEPTION 'migration 104: amended_by_law_no/year للمادة 73 غير مطابق (متوقع 211/2020).';
    END IF;
    IF v_eff_from <> '2020-12-04'::date THEN
        RAISE EXCEPTION 'migration 104: effective_from للمادة 73 غير مطابق (متوقع 2020-12-04، الفعلى %)', v_eff_from;
    END IF;

    SELECT a.body, av.body, av.amended_by_law_no, av.amended_by_law_year, av.status, av.effective_from
    INTO v_art_body, v_ver_body, v_amended_no, v_amended_year, v_status, v_eff_from
    FROM articles a
    JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_no = 74 AND a.article_suffix_order = 1;

    IF v_art_body IS NULL THEN
        RAISE EXCEPTION 'migration 104: المادة 74 (suffix=1) غير موجودة.';
    END IF;
    IF v_art_body <> $vb104_6$يبدأ حساب تقادم الدعوى الجنائية فى الجرائم المنصوص عليها فى هذا القانون أو القانون الضريبى بعد مضى خمس سنوات من نهاية السنة التى تستحق عنها الضريبة.$vb104_6$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 74 (articles.body) لا يطابق المتوقع.';
    END IF;
    IF v_ver_body <> $vb104_6$يبدأ حساب تقادم الدعوى الجنائية فى الجرائم المنصوص عليها فى هذا القانون أو القانون الضريبى بعد مضى خمس سنوات من نهاية السنة التى تستحق عنها الضريبة.$vb104_6$ THEN
        RAISE EXCEPTION 'migration 104: نص المادة 74 (article_versions.body) لا يطابق المتوقع.';
    END IF;
    IF v_amended_no <> 211 OR v_amended_year <> 2020 THEN
        RAISE EXCEPTION 'migration 104: amended_by_law_no/year للمادة 74 غير مطابق (متوقع 211/2020).';
    END IF;
    IF v_eff_from <> '2020-12-04'::date THEN
        RAISE EXCEPTION 'migration 104: effective_from للمادة 74 غير مطابق (متوقع 2020-12-04، الفعلى %)', v_eff_from;
    END IF;

    RAISE NOTICE 'migration 104: تم بنجاح. 6 عملية مُطبَّقة. القانون 211/2020: استبدال المادة (13/فقرة أخيرة) بأربع نسب متفاوتة، واستبدال المواد (44، 70، 73)، وإضافة مادتين جديدتين (73مكررا، 74مكررا). أول هجرة فى سلسلة تعديلات قانون 206/2020.';
END $verify104$;

COMMIT;
