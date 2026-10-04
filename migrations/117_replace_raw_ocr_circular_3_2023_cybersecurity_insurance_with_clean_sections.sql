-- 117_replace_raw_ocr_circular_3_2023_cybersecurity_insurance_with_clean_sections.sql
--
-- إصلاح جذرى للكتاب الدورى رقم (3) لسنة 2023 الصادر عن رئيس الهيئة العامة للرقابة المالية
-- بتاريخ 10/8/2023 بشأن اجراءات تعزيز الأمن السيبراني بشركات التأمين.
--
-- ===== الحالة السابقة (ثلاثة عيوب فى صف واحد) =====
-- (1) المتن مادة واحدة (article_no=1) هى ناتج OCR خام من الصورة الممسوحة، فيه ترويسة
--     مشوَّهة ("كرجا مسبو شت"، "01!107117ا ...")، ورقم الكتاب وتاريخه مكسوران
--     ("( 30 ) لسنة ٠١7١"، "5١77/0/٠١")، وأرقام قرارات مفقودة أو مشوَّهة ("رقم لسنة 7٠١77"،
--     "رقم 9" لسنة ؟١١1١")، وأرقام البنود محرَّفة ("5"، "؟"، "6")، وسطر مكرر للمهلة (واحد
--     بـ"" أشهر" والآخر بـ"١١ شهرا")، وبريد التواصل وتذييل الصفحة (عنوان/هاتف/فاكس) كلام
--     غير مقروء داخل المتن. أى أن البند الرقمى الأهم فى الكتاب (المهلتان: 6 أشهر و12 شهراً)
--     لم يكن مقروءاً أصلاً، ولا رقم القرار 139/2023 الذى يحيل إليه.
-- (2) النوع kind = 'board_decision' بينما الوثيقة كتاب دورى (kind='circular').
-- (3) enacted_at = NULL رغم أن التاريخ مكتوب فى ترويسة الكتاب، والعنوان لا يحمل رقم الكتاب.
--
-- ===== المصدر والمنهجية =====
-- النسخة الممسوحة (صفحة واحدة) رفعها صاحب المشروع (2023-08-10-10-04-08-735-1.pdf)؛ الرابط
-- المخزَّن فى laws.official_url يحمل اسم الملف نفسه (fra.gov.eg/wp-content/uploads/2023/08/...)
-- ولم يُمس. نُقل النص بقراءة بصرية للصفحة بتكبير 200-400 dpi (لا من أى طبقة نصية؛ الملف
-- صورة بلا نص)، بإملاء المصدر كما هو (بما فيه "اجراءات" و"اعداد" و"بعالية") والأرقام
-- الهندية مقروءة لاتينية اتساقاً مع المنصة. فُحص بتكبير 400 dpi: رقم الكتاب (٣)، وتاريخه
-- (٢٠٢٣/٨/١٠ مكتوب بخط اليد)، والبريد FRA2INS@fra.gov.eg. التاريخ يتسق مع اسم الملف
-- (2023-08-10) ومسار الرابط (2023/08). حُذفت ترويسة الصفحة وتذييلها (عنوان/هاتف/شعار)
-- لأنها ليست من نص الكتاب، وبقيت الجهة الموقِّعة والتوقيع.
--
-- ===== الهيكل =====
-- الكتاب الدورى لا يحوى "مواد"؛ قُسِّم إلى 3 أقسام وفق بنيته: (1) التمهيد مع البنود الستة
-- (تبقى معاً لأن البنود تتمّة جملة "على أن يشمل ذلك ما يلي")، (2) المهلتان الزمنيتان،
-- (3) التسليم والتواصل والتوقيع. دمج الأقسام بفاصل سطر فارغ يعيد المتن كاملاً بلا حذف.
-- التصنيف category='insurance' يبقى كما هو (الكتاب موجَّه لشركات التأمين).
--
-- ===== أمان إعادة التشغيل (مهم) =====
-- هجرة 006 تُعاد مع كل نشر وكانت تُدرج هذا الكتاب بنوع board_decision؛ عُدِّلت لتُدرجه
-- بنوع circular (نفس الكوميت)، وهذه الهجرة تتعامل مع كل الحالات: الصف القديم وحده
-- (يُحوَّل فى مكانه)، أو الصفين معاً فى أول نشر (يبقى القديم ويُحذف المكرَّر الجديد)، أو
-- circular وحده (الحالة المستقرة). الحذف مشروط بعنوان البذر القديم نفسه، وتحقق الختام
-- محصور فى هذا الكتاب. نفس نمط هجرة 114.
--
-- ملاحظة تشغيلية: الأقسام الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix117_kind$
DECLARE
  v_old uuid;
  v_new uuid;
  v_new_articles int;
BEGIN
  SELECT id INTO v_old FROM laws
   WHERE law_no = 3 AND law_year = 2023 AND kind = 'board_decision'
     AND title = $o$بشأن إجراءات تعزيز الأمن السيبراني بشركات التأمين$o$;
  SELECT id INTO v_new FROM laws WHERE law_no = 3 AND law_year = 2023 AND kind = 'circular';

  IF v_old IS NOT NULL AND v_new IS NOT NULL THEN
    SELECT count(*) INTO v_new_articles FROM articles WHERE law_id = v_new;
    IF v_new_articles = 3 THEN
      DELETE FROM laws WHERE id = v_old;
      RAISE NOTICE '[117] أُزيل صف board_decision المكرَّر (الكتاب المصحَّح موجود)';
    ELSE
      DELETE FROM laws WHERE id = v_new;
      UPDATE laws SET kind = 'circular', updated_at = now() WHERE id = v_old;
      RAISE NOTICE '[117] حُوِّل الصف القديم إلى circular (حُذف المكرَّر الناتج عن إعادة تشغيل 006)';
    END IF;
  ELSIF v_old IS NOT NULL THEN
    UPDATE laws SET kind = 'circular', updated_at = now() WHERE id = v_old;
    RAISE NOTICE '[117] حُوِّل الصف القديم من board_decision إلى circular';
  ELSIF v_new IS NOT NULL THEN
    RAISE NOTICE '[117] الصف circular موجود — لا تحويل مطلوب';
  ELSE
    RAISE WARNING '[117] الكتاب الدورى 3/2023 غير موجود فى laws — تخطّى';
  END IF;
END
$fix117_kind$;

UPDATE laws
   SET title = $t$كتاب دورى رقم 3 لسنة 2023 بتاريخ 10/8/2023 بشأن اجراءات تعزيز الأمن السيبراني بشركات التأمين$t$,
       short_title = $s$تعزيز الأمن السيبراني بشركات التأمين$s$,
       enacted_at = DATE '2023-08-10',
       updated_at = now()
 WHERE law_no = 3 AND law_year = 2023 AND kind = 'circular'
   AND (title IS DISTINCT FROM $t$كتاب دورى رقم 3 لسنة 2023 بتاريخ 10/8/2023 بشأن اجراءات تعزيز الأمن السيبراني بشركات التأمين$t$ OR enacted_at IS DISTINCT FROM DATE '2023-08-10');

DO $fix117_art$
DECLARE
  v_law_id uuid;
  v_cnt int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 3 AND law_year = 2023 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RETURN;
  END IF;
  SELECT count(*) INTO v_cnt FROM articles WHERE law_id = v_law_id;
  IF v_cnt = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[117] أُزيلت المادة الواحدة التالفة (OCR خام)';
  ELSIF v_cnt = 3 THEN
    RAISE NOTICE '[117] 3 أقسام موجودة بالفعل — تخطّى الحذف';
  ELSE
    RAISE WARNING '[117] عدد مواد غير متوقَّع (%) — راجع يدوياً', v_cnt;
  END IF;
END
$fix117_art$;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $h1$الكتاب الدورى رقم 3 لسنة 2023$h1$, $t1$التمهيد والإجراءات الواجبة (البنود 1-6)$t1$, $b1$في إطار حرص الهيئة العامة للرقابة المالية على تعزيز إجراءات الأمن السيبراني في قطاع التأمين المصري، وتسهيلاً على الشركات حال التقدم في الحصول على رخص توفير منتجات تأمينية إلكترونيا تطبيقا للقرار (140) لسنة 2023 للوصول إلى الفئات وتوسيع رقعة الشمول التأميني، تلتزم الشركات باتخاذ كافة الإجراءات الواجبة لتعزيز منظومة الأمن السيبراني لديها وحماية الأنظمة والبيانات الحساسة، على أن يشمل ذلك ما يلي:
1- التجهيزات والبنية التكنولوجية وأنظمة المعلومات ووسائل الحماية والتأمين الواردة في البند ثانيا من قرار مجلس إدارة الهيئة رقم 139 لسنة 2023 والمتضمن أن تكون قاعدة بيانات عملاء الشركة داخل جمهورية مصر العربية.
2- اتباع ضوابط أمن المعلومات الواردة في البند ثانيا من قرار مجلس إدارة الهيئة رقم 139 لسنة 2023.
3- اعداد دليل السياسات والإجراءات المتبعة فيما يخص أمن المعلومات، وموافاة الهيئة به بعد اعتماده من مجلس إدارة الشركة.
4- إعداد إطار عمل لحوكمة تكنولوجيا المعلومات، وموافاة الهيئة به بعد اعتماده من مجلس إدارة الشركة.
5- إعداد إطار عمل لإدارة مخاطر تكنولوجيا المعلومات، وموافاة الهيئة به بعد اعتماده من مجلس إدارة الشركة.
6- إعداد إطار عمل لإدارة الأمن السيبراني، وموافاة الهيئة به بعد اعتماده من مجلس إدارة الشركة.$b1$
  FROM laws WHERE law_no = 3 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-08-10', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $h2$الكتاب الدورى رقم 3 لسنة 2023$h2$, $t2$المهل الزمنية للخطة والتنفيذ$t2$, $b2$على أن يتم موافاة الهيئة بالخطة الزمنية لتنفيذ التعليمات المنصوص عليها في البنود 1 و2 و3 في مدة لا تتجاوز 15 يوم عمل من تاريخه، على ألا يتجاوز تنفيذ تلك التعليمات 6 أشهر من تاريخه.

على أن يتم موافاة الهيئة بالخطة الزمنية لتنفيذ التعليمات المنصوص عليها في البنود 4 و5 و6 في مدة لا تتجاوز 15 يوم عمل من تاريخه، على ألا يتجاوز تنفيذ تلك التعليمات 12 شهرا من تاريخه.$b2$
  FROM laws WHERE law_no = 3 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-08-10', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $h3$الكتاب الدورى رقم 3 لسنة 2023$h3$, $t3$التسليم والتواصل والتوقيع$t3$, $b3$لذا نرجو اتخاذ كافة الإجراءات اللازمة لتنفيذ ما سبق وموافاة الهيئة بما تم في هذا الشأن. على أن يتم تسليم المستندات المشار إليها بعالية في مظروف مغلق باسم قطاع تكنولوجيا المعلومات.

للتواصل: FRA2INS@fra.gov.eg

رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b3$
  FROM laws WHERE law_no = 3 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-08-10', 'active' FROM ins3;

DO $verify117$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_stray int;
  v_months int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 3 AND law_year = 2023 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RAISE EXCEPTION '[117] الكتاب الدورى 3/2023 (circular) غير موجود';
  END IF;
  SELECT count(*) INTO v_stray FROM laws WHERE law_no = 3 AND law_year = 2023 AND kind <> 'circular';
  IF v_stray <> 0 THEN
    RAISE EXCEPTION '[117] ما زال هناك صف 3/2023 بنوع غير circular';
  END IF;
  SELECT count(*), COALESCE(sum(length(body)),0),
         count(*) FILTER (WHERE body LIKE '%' || chr(65533) || '%' OR body LIKE '%كرجا%' OR body LIKE '%الهينة%'),
         count(*) FILTER (WHERE article_no = 2 AND body LIKE '%15 يوم عمل%6 أشهر%15 يوم عمل%12 شهرا%')
    INTO v_arts, v_len, v_bad, v_months FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2023-08-10' AND av.status = 'active';
  IF v_arts <> 3 OR v_vers <> 3 THEN
    RAISE EXCEPTION '[117] متوقَّع 3 أقسام و3 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_months <> 1 THEN
    RAISE EXCEPTION '[117] فشل التحقق من المحتوى (تلف=%, مهل=%)', v_bad, v_months;
  END IF;
  IF v_len <> 1752 THEN
    RAISE EXCEPTION '[117] مجموع الأطوال % لا يطابق المتوقع 1752', v_len;
  END IF;
  RAISE NOTICE '[117] كتاب دورى 3/2023: % أقسام و% نسخ سليمة.', v_arts, v_vers;
END
$verify117$;

COMMIT;
