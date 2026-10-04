-- =====================================================================
-- Migration 110: إلغاء 46 مادة من اللائحة التنفيذية لقانون الضريبة على
--                        الدخل 991/2005 بموجب المادة 3 من قرار وزير المالية 286/2021
-- =====================================================================
--
-- المصدر: نص المادة (3) من قرار وزير المالية 286/2021 (الوقائع المصرية،
--   العدد 123 تابع (ج)، 3/6/2021) كما سُجِّل فى migration 109 (suffix=-1).
--   قائمة 991/2005 الواردة بالنص: 22، 90-99، 102-108، 112، 115، 116، 118،
--   120-124، 126 مكررًا، 126 مكررًا (1)، 128-146.
--
-- المنفَّذ هنا: 46 مادة (suffix=0) - كل أرقام القائمة عدا "126 مكررًا"
--   و"126 مكررًا (1)".
--
-- ⚠️ فجوة موثَّقة (لا اختلاق): "126 مكررًا" و"126 مكررًا (1)" غير موجودتين
--   فى سجل اللائحة 991/2005 بالقاعدة (مبنية بمدى 1-146 بلا مكررات لهاتين
--   المادتين ولا مصدر مرفوع لنصهما) - لم تُنشأ مواد صورية لإلغائها. المادة
--   126 نفسها لم تُلغَ (القائمة تلغى مكرراتها فقط).
--
-- المادة 4 من القرار: 99 مكررًا (1)-(4) (المضافة بقرار 778/2010 - migration
--   083) يستمر العمل بها لحين صدور قرار باكتمال منظومة الفواتير الإلكترونية؛
--   لذا لا تُمَسّ (تتحقق كتلة التحقق من بقائها سارية).
--
-- بنود المادة 3 الخاصة باللائحتين 525/2006 (ضريبة الدمغة) و66/2017 (القيمة
--   المضافة) غير منفَّذة: اللائحتان غير موجودتين فى القاعدة (فجوة موثَّقة).
--
-- نفس دلالات repeal فى amend_common_206.py: تحديث article_versions
--   (version_no=1) إلى status='repealed' مع effective_to وamended_by وchange_note
--   دون حذف أى صف؛ idempotent (قيم ثابتة). effective_to = 2021-06-04.
--
-- لا تتحقق هذه الهجرة من أى إجمالى تراكمى على سجل اللائحة، وهجرات 077-083
--   (مقيَّدة بنطاقاتها) لا تتأثر بحالة status.
--
-- =====================================================================

BEGIN;

-- ===== عمليات الإلغاء =====
-- مادة 22 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 22 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 90 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 90 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 91 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 91 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 92 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 92 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 93 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 93 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 94 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 94 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 95 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 95 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 96 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 96 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 97 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 97 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 98 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 98 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 99 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 99 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 102 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 102 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 103 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 103 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 104 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 104 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 105 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 105 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 106 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 106 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 107 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 107 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 108 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 108 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 112 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 112 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 115 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 115 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 116 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 116 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 118 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 118 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 120 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 120 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 121 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 121 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 122 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 122 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 123 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 123 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 124 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 124 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 128 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 128 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 129 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 129 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 130 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 130 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 131 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 131 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 132 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 132 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 133 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 133 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 134 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 134 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 135 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 135 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 136 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 136 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 137 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 137 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 138 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 138 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 139 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 139 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 140 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 140 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 141 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 141 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 142 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 142 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 143 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 143 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 144 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 144 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 145 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 145 AND a.article_suffix_order = 0
) AND version_no = 1;

-- مادة 146 (suffix=0) - REPEAL (effective_to=2021-06-04)
UPDATE article_versions SET
    status = 'repealed',
    effective_to = '2021-06-04'::date,
    amended_by_law_no = 286,
    amended_by_law_year = 2021,
    change_note = $note110_$أُلغيت بموجب المادة (3) من قرار وزير المالية رقم 286 لسنة 2021 (اللائحة التنفيذية لقانون الإجراءات الضريبية الموحد) - يُعمل به من 2021-06-04.$note110_$
WHERE article_id = (
    SELECT a.id FROM articles a JOIN laws l ON l.id = a.law_id
    WHERE l.law_no = 991 AND l.law_year = 2005 AND l.kind = 'regulation'
      AND a.article_no = 146 AND a.article_suffix_order = 0
) AND version_no = 1;

-- ===== كتلة التحقق =====

DO $verify110$
DECLARE
    v_law_id uuid;
    v_repealed INT;
    v_alive_mokarrar INT;
    v_bad INT;
BEGIN
    SELECT id INTO v_law_id FROM laws WHERE law_no = 991 AND law_year = 2005 AND kind = 'regulation';
    IF v_law_id IS NULL THEN
        RAISE EXCEPTION 'migration 110: سجل اللائحة 991/2005 غير موجود - يجب تشغيل 077-083 أولاً.';
    END IF;

    SELECT COUNT(*) INTO v_repealed
    FROM articles a JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_suffix_order = 0 AND a.article_no IN (22, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 102, 103, 104, 105, 106, 107, 108, 112, 115, 116, 118, 120, 121, 122, 123, 124, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146)
      AND av.status = 'repealed' AND av.effective_to = '2021-06-04'::date
      AND av.amended_by_law_no = 286 AND av.amended_by_law_year = 2021;
    IF v_repealed <> 46 THEN
        RAISE EXCEPTION 'migration 110: عدد المواد الملغاة المتوقع 46 لكن الفعلى %', v_repealed;
    END IF;

    -- المادة 4 من القرار: 99 مكررا (1)-(4) (suffix 1-4) يستمر العمل بها - لا يجوز المساس بها.
    SELECT COUNT(*) INTO v_alive_mokarrar
    FROM articles a JOIN article_versions av ON av.article_id = a.id AND av.version_no = 1
    WHERE a.law_id = v_law_id AND a.article_no = 99 AND a.article_suffix_order BETWEEN 1 AND 4
      AND av.status <> 'repealed';
    IF v_alive_mokarrar <> 4 THEN
        RAISE EXCEPTION 'migration 110: مواد 99 مكررا (1-4) يجب أن تظل سارية (المادة 4 من القرار) لكن عدد السارية %', v_alive_mokarrar;
    END IF;

    -- لا يجوز أن تُلغى مادة خارج قائمة المادة 3 بهذا القرار.
    SELECT COUNT(*) INTO v_bad
    FROM articles a JOIN article_versions av ON av.article_id = a.id
    WHERE a.law_id = v_law_id AND av.amended_by_law_no = 286 AND av.amended_by_law_year = 2021
      AND NOT (a.article_suffix_order = 0 AND a.article_no IN (22, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 102, 103, 104, 105, 106, 107, 108, 112, 115, 116, 118, 120, 121, 122, 123, 124, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146));
    IF v_bad <> 0 THEN
        RAISE EXCEPTION 'migration 110: % مادة خارج قائمة الإلغاء تحمل علامة القرار 286/2021', v_bad;
    END IF;

    RAISE NOTICE 'migration 110: تم بنجاح. % مادة من اللائحة 991/2005 ملغاة بالقرار 286/2021 (المادة 3).', v_repealed;
END $verify110$;

COMMIT;
