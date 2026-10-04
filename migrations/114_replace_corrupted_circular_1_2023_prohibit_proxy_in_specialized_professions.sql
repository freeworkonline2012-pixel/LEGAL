-- 114_replace_corrupted_circular_1_2023_prohibit_proxy_in_specialized_professions.sql
--
-- إصلاح جذرى للكتاب الدورى رقم (1) لسنة 2023 الصادر عن الهيئة العامة للرقابة المالية
-- بتاريخ 20/2/2023 بشأن حظر التوكيل أو التفويض فى مزاولة المهن المتخصصة فى الأنشطة
-- المالية غير المصرفية الخاضعة لإشراف ورقابة الهيئة.
--
-- ===== الحالة السابقة (أربعة عيوب فى صف واحد) =====
-- (1) المتن مادة واحدة (article_no=1) هى ناتج OCR خام من الصورة الممسوحة، وفيه
--     ترويسة مشوَّهة ("42 جا وس متت ...")، وأرقام وكلمات مكسورة ("لسنة؟ ٠ ١"،
--     "بشاريخ 1١35/1/5١")، وسطر كامل من البند الأول غير مقروء، وبند ثالث مقطوع
--     ("...فى الأنشطة المالية") ينقصه "غير المصرفية"، وتذييل الصفحة داخل المتن.
-- (2) النوع kind = 'board_decision' بينما الوثيقة كتاب دورى (kind='circular').
-- (3) العنوان مختصر "بشأن حظر ... (التأمينية)" والتصنيف category='insurance' بينما
--     الكتاب موجَّه لكل الأنشطة المالية غير المصرفية، وكلمة "(التأمينية)" ليست من المصدر.
-- (4) enacted_at = NULL رغم أن التاريخ مطبوع فى ترويسة الكتاب.
--
-- ===== المصدر والمنهجية =====
-- النسخة الممسوحة (صفحة واحدة) رفعها صاحب المشروع (كتاب-دوري-رقم-1-لسنة-2023-1.pdf)؛
-- الرابط المخزَّن فى laws.official_url يحمل اسم الملف نفسه (fra.gov.eg/wp-content/
-- uploads/2023/02/...) ولم يُمس. نُقل النص بقراءة بصرية للصفحة بتكبير 200 dpi فى خمسة
-- مقاطع كلمةً كلمة (لا من أى طبقة نصية)، بإملاء المصدر كما هو (بما فيه "أولغيرهم"
-- و"أخر" و"المسائلة" و"حقوق ،") والأرقام الهندية مقروءة لاتينية اتساقاً مع المنصة.
-- التاريخ: مطبوع "٢٠/٢/٢٠٢٣" وفُحص بتكبير 400 dpi؛ يوم 30 فبراير غير ممكن، ويتسق
-- مع تاريخ إنشاء الملف الممسوح (2023-02-21) ومسار الرابط (2023/02).
--
-- ===== الهيكل =====
-- الكتاب الدورى لا يحوى "مواد"؛ قُسِّم إلى 4 أقسام وفق بنيته: (1) التمهيد وأسباب
-- الإصدار والعبارة التمهيدية للبنود، ثم البنود الثلاثة (2-4) كلٌّ على حدة، والتوقيع
-- مع البند الأخير. دمج الأقسام بفاصل سطر فارغ يعيد التمهيد كاملاً بلا أى حذف.
--
-- ===== أمان إعادة التشغيل (مهم) =====
-- هجرة 006 تُعاد مع كل نشر وكانت تُدرج هذا الكتاب بنوع board_decision؛ عُدِّلت لتُدرجه
-- بنوع circular (نفس الكوميت)، وهذه الهجرة تتعامل مع كل الحالات الممكنة: الصف القديم
-- board_decision وحده (يُحوَّل فى مكانه بحفظ معرّفه)، أو الصفين معاً فى أول نشر (يبقى
-- القديم ويُحذف المُكرَّر الجديد)، أو الصف circular وحده (الحالة المستقرة). الحذف
-- مشروط بعنوان البذر القديم نفسه فلا يُمس أى قرار آخر. وتحقق الختام محصور فى هذا الكتاب.
--
-- ملاحظة تشغيلية: الأقسام الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix114_kind$
DECLARE
  v_old uuid;
  v_new uuid;
  v_new_articles int;
BEGIN
  SELECT id INTO v_old FROM laws
   WHERE law_no = 1 AND law_year = 2023 AND kind = 'board_decision'
     AND title = $o$بشأن حظر التوكيل أو التفويض فى مزاولة المهن المتخصصة (التأمينية)$o$;
  SELECT id INTO v_new FROM laws WHERE law_no = 1 AND law_year = 2023 AND kind = 'circular';

  IF v_old IS NOT NULL AND v_new IS NOT NULL THEN
    SELECT count(*) INTO v_new_articles FROM articles WHERE law_id = v_new;
    IF v_new_articles = 4 THEN
      DELETE FROM laws WHERE id = v_old;
      RAISE NOTICE '[114] أُزيل صف board_decision المكرَّر (الكتاب المصحَّح موجود)';
    ELSE
      DELETE FROM laws WHERE id = v_new;
      UPDATE laws SET kind = 'circular', updated_at = now() WHERE id = v_old;
      RAISE NOTICE '[114] حُوِّل الصف القديم إلى circular (حُذف المكرَّر الناتج عن إعادة تشغيل 006)';
    END IF;
  ELSIF v_old IS NOT NULL THEN
    UPDATE laws SET kind = 'circular', updated_at = now() WHERE id = v_old;
    RAISE NOTICE '[114] حُوِّل الصف القديم من board_decision إلى circular';
  ELSIF v_new IS NOT NULL THEN
    RAISE NOTICE '[114] الصف circular موجود — لا تحويل مطلوب';
  ELSE
    RAISE WARNING '[114] الكتاب الدورى 1/2023 غير موجود فى laws — تخطّى';
  END IF;
END
$fix114_kind$;

UPDATE laws
   SET title = $t$كتاب دورى رقم 1 لسنة 2023 بتاريخ 20/2/2023 بشأن حظر التوكيل أو التفويض فى مزاولة المهن المتخصصة فى الأنشطة المالية غير المصرفية الخاضعة لإشراف ورقابة الهيئة$t$,
       short_title = $s$حظر التوكيل أو التفويض فى مزاولة المهن المتخصصة$s$,
       category = 'non_bank_finance',
       enacted_at = DATE '2023-02-20',
       updated_at = now()
 WHERE law_no = 1 AND law_year = 2023 AND kind = 'circular'
   AND (title IS DISTINCT FROM $t$كتاب دورى رقم 1 لسنة 2023 بتاريخ 20/2/2023 بشأن حظر التوكيل أو التفويض فى مزاولة المهن المتخصصة فى الأنشطة المالية غير المصرفية الخاضعة لإشراف ورقابة الهيئة$t$ OR short_title IS DISTINCT FROM $s$حظر التوكيل أو التفويض فى مزاولة المهن المتخصصة$s$
        OR category IS DISTINCT FROM 'non_bank_finance' OR enacted_at IS DISTINCT FROM DATE '2023-02-20');

DO $fix114_art$
DECLARE
  v_law_id uuid;
  v_cnt int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 1 AND law_year = 2023 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RETURN;
  END IF;
  SELECT count(*) INTO v_cnt FROM articles WHERE law_id = v_law_id;
  IF v_cnt = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[114] أُزيلت المادة الواحدة التالفة (OCR خام)';
  ELSIF v_cnt = 4 THEN
    RAISE NOTICE '[114] 4 أقسام موجودة بالفعل — تخطّى الحذف';
  ELSE
    RAISE WARNING '[114] عدد مواد غير متوقَّع (%) — راجع يدوياً', v_cnt;
  END IF;
END
$fix114_art$;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, 'الكتاب الدورى رقم 1 لسنة 2023', 'تمهيد وأسباب الإصدار', $b1$في إطار الدور المنوط بالهيئة العامة للرقابة المالية وفقاً للقانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية، بالعمل على سلامة واستقرار الأسواق المالية غير المصرفية وحماية حقوق ، ومصالح المتعاملين فيها، وتوفير الوسائل والنظم وإصدار القواعد التي تضمن كفاءة هذه الأسواق.

وفي ضوء ما تلاحظ للهيئة من قيام بعض الأشخاص المرخص لهم بمزاولة المهن المتخصصة في الأنشطة المالية غير المصرفية، بعمل توكيلات رسمية أو تفويضات لبعضهم البعض أولغيرهم من الأشخاص غير الحاصلين على ترخيص من الهيئة، للتعامل نيابة عنهم في المهن المتخصصة المرخص لهم بها من الهيئة.

وحيث أن منح الترخيص بمزاولة المهن المتخصصة في الأنشطة المالية غير المصرفية يكون في ضوء ما يتوافر في الشخص من مؤهلات علمية وخبرات عملية وإجتياز الإختبارات و المقابلات للتأكد من صلاحيته للحصول على هذا الترخيص، بالإضافة لما يرتبط بمزاولة الأعمال المهنية المتخصصة من مسئولية قانونية حال عدم قيام الشخص بها وفقاً للقواعد والمعايير المقررة في هذا الشأن، على نحو يكون الترخيص الممنوح في هذا الشأن له طابع شخصي يرتبط بالشخص الحاصل عليه وجوداً وعدماً.

وتأسيساً على ما تقدم؛ فتؤكد الهيئة علي ما يلي:-$b1$
  FROM laws WHERE law_no = 1 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-02-20', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, 'الكتاب الدورى رقم 1 لسنة 2023', 'البند (1): حظر التوكيل أو التفويض بين المرخص لهم', $b2$1- يُحظر على الأشخاص الحاصلين على ترخيص من الهيئة بمزاولة المهن المتخصصة في الأنشطة المالية غير المصرفية عمل أي توكيلات أو تفويضات لبعضهم البعض أو لأي شخص أخر للتعامل بموجبها أو نيابة عنهم في الأعمال المهنية المتخصصة المرخص لهم بها، وعليهم إلغاء أية توكيلات أو تفويضات تكون قد صدرت منهم في هذا الشأن وإتخاذ اللازم نحو إيقاف العمل بها، تجنباً للمسائلة القانونية الناتجة عن مخالفة ذلك.$b2$
  FROM laws WHERE law_no = 1 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-02-20', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, 'الكتاب الدورى رقم 1 لسنة 2023', 'البند (2): حظر مزاولة غير المرخص لهم استناداً إلى توكيل أو تفويض', $b3$2- يُحظر على الأشخاص غير الحاصلين على ترخيص من الهيئة بمزاولة المهن المتخصصة في الأنشطة المالية غير المصرفية القيام بمزاولة الأعمال المهنية المتخصصة أو بعضها إستناداً لتوكيل أو تفويض صادر لها من أحد الأشخاص الحاصلين على ترخيص من الهيئة بمزاولتها، بإعتبار أن ذلك يُعد ممارسة لنشاط مهني غير مرخص به يستوجب المسائلة القانونية.$b3$
  FROM laws WHERE law_no = 1 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-02-20', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, 'الكتاب الدورى رقم 1 لسنة 2023', 'البند (3): التزام الشركات والجهات الخاضعة بالتعامل المباشر مع المرخص لهم', $b4$3- يتعين على كافة الشركات والجهات الخاضعة لاشراف ورقابة الهيئة مراعاة ما سبق، وأن يكون تعاملها مباشرة مع الأشخاص المرخص لهم بمزاولة المهن المتخصصة في الأنشطة المالية غير المصرفية.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b4$
  FROM laws WHERE law_no = 1 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-02-20', 'active' FROM ins4;

DO $verify114$
DECLARE
  v_law_id uuid;
  v_kind text; v_cat text; v_enacted date; v_title text;
  v_arts int; v_vers int; v_len int; v_dups int;
BEGIN
  SELECT id, kind, category, enacted_at, title INTO v_law_id, v_kind, v_cat, v_enacted, v_title
    FROM laws WHERE law_no = 1 AND law_year = 2023 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RAISE EXCEPTION '[114] صف الكتاب الدورى 1/2023 (circular) غير موجود';
  END IF;
  SELECT count(*) INTO v_dups FROM laws WHERE law_no = 1 AND law_year = 2023 AND kind = 'board_decision'
     AND title = $o$بشأن حظر التوكيل أو التفويض فى مزاولة المهن المتخصصة (التأمينية)$o$;
  IF v_dups <> 0 THEN
    RAISE EXCEPTION '[114] ما زال صف board_decision المكرَّر موجوداً';
  END IF;
  IF v_cat <> 'non_bank_finance' OR v_enacted <> DATE '2023-02-20' OR v_title <> $t$كتاب دورى رقم 1 لسنة 2023 بتاريخ 20/2/2023 بشأن حظر التوكيل أو التفويض فى مزاولة المهن المتخصصة فى الأنشطة المالية غير المصرفية الخاضعة لإشراف ورقابة الهيئة$t$ THEN
    RAISE EXCEPTION '[114] حقول laws غير مطابقة: %, %, %', v_cat, v_enacted, v_title;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)),0) INTO v_arts, v_len FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2023-02-20' AND av.status = 'active';
  IF v_arts <> 4 OR v_vers <> 4 THEN
    RAISE EXCEPTION '[114] متوقَّع 4 أقسام و4 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_len <> 2013 THEN
    RAISE EXCEPTION '[114] مجموع الأطوال % لا يطابق المتوقع 2013', v_len;
  END IF;
  RAISE NOTICE '[114] كتاب دورى 1/2023: % أقسام و% نسخ، النوع %.', v_arts, v_vers, v_kind;
END
$verify114$;

COMMIT;
