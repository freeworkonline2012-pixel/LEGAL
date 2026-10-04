-- 120_replace_raw_ocr_circular_4_2023_client_data_confidentiality_with_clean_sections.sql
--
-- إصلاح جذرى للكتاب الدورى رقم (4) لسنة 2023 الصادر عن رئيس الهيئة العامة للرقابة المالية
-- بتاريخ 12/10/2023 بشأن حماية سرية بيانات المتعاملين فى الأنشطة المالية غير المصرفية من مخاطر الاحتيال.
--
-- ===== الحالة السابقة (ثلاثة عيوب فى صف واحد) =====
-- (1) المتن مادة واحدة (article_no=1) هى ناتج OCR خام من الصورة الممسوحة، فيه ترويسة مشوَّهة
--     ("الورك الت الها ائلاليه"، "دن لِمَنْم")، ورقم الكتاب وتاريخه مكسوران ("رقم ر-5 ) لسنة ٠١59
--     بتاريخ ١١55/1١/1١")، وكلمات محرَّفة ("سربة"، "المستوبات"، "الطربقة"، "سعياأ"، "نريد" بدل "فريد")،
--     وعلامات ترقيم مبدَّلة (":" و"ء" مكان "،" و"؛")، وأرقام البنود الثلاثة مفقودة، وتذييل الصفحة
--     (عنوان القرية الذكية/هاتف/فاكس) كلام مشوَّه داخل المتن.
-- (2) النوع kind = 'board_decision' بينما الوثيقة كتاب دورى (kind='circular').
-- (3) enacted_at = NULL رغم أن التاريخ مكتوب فى ترويسة الكتاب، والعنوان لا يحمل رقم الكتاب ولا تاريخه.
--
-- ===== المصدر والمنهجية =====
-- النسخة الممسوحة (صفحة واحدة) رفعها صاحب المشروع (كتاب-دوري-4.pdf)؛ الرابط المخزَّن فى
-- laws.official_url يحمل اسم الملف نفسه (fra.gov.eg/wp-content/uploads/2023/10/كتاب-دوري-4.pdf)
-- ولم يُمس. نُقل النص بقراءة بصرية للصفحة بتكبير 250 dpi (الملف صورة بلا طبقة نصية) على أربعة
-- مقاطع متتالية، بإملاء المصدر كما هو (بما فيه "فى الأسواق" و"ابرام" و"الالكتروني") والأرقام الهندية
-- مقروءة لاتينية اتساقاً مع المنصة. رقم الكتاب (4) مكتوب بخط اليد فوق الترويسة، والتاريخ
-- 2023/10/12 مطبوع، ويتسق مع مسار الرابط (2023/10). حُذفت ترويسة الصفحة وتذييلها (عنوان/هاتف/شعار/
-- QR) لأنها ليست من نص الكتاب، وبقيت الجهة الموقِّعة والتوقيع. عنوان الكتاب انتقل إلى laws.title.
--
-- ===== الهيكل =====
-- الكتاب الدورى لا يحوى "مواد"؛ قُسِّم إلى 5 أقسام وفق بنيته: التمهيد، ثم كل بند من البنود الثلاثة
-- فى قسم مستقل (لكل بند التزام مستقل بموضوع مختلف فيحسُن استرجاعه منفرداً، وعنوان القسم يحمل
-- موضوعه)، ثم النشر والتوقيع. ترقيم الأقسام = ترتيبها. التصنيف category='insurance' يبقى كما هو
-- (تصنيف دفعة البذر نفسها؛ لم يُغيَّر لأنه قرار تصنيف لا تصحيح نص).
--
-- ===== التاريخ =====
-- effective_from = enacted_at = 2023-10-12 (تاريخ الكتاب المطبوع)؛ النص لا يحدد تاريخ سريان مختلفاً
-- (ينص فقط على النشر بالموقع الإلكترونى للهيئة).
--
-- ===== أمان إعادة التشغيل (مهم) =====
-- هجرة 006 تُعاد مع كل نشر وكانت تُدرج هذا الكتاب بنوع board_decision؛ عُدِّلت لتُدرجه بنوع circular
-- (نفس الكوميت)، وهذه الهجرة تتعامل مع كل الحالات: الصف القديم وحده (يُحوَّل فى مكانه)، أو الصفين
-- معاً فى أول نشر (يبقى القديم ويُحذف المكرَّر الجديد)، أو circular وحده (الحالة المستقرة). الحذف
-- مشروط بعنوان البذر القديم نفسه، وتحقق الختام محصور فى هذا الكتاب. نفس نمط هجرة 117.
--
-- ملاحظة تشغيلية: الأقسام الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix120_kind$
DECLARE
  v_old uuid;
  v_new uuid;
  v_new_articles int;
BEGIN
  SELECT id INTO v_old FROM laws
   WHERE law_no = 4 AND law_year = 2023 AND kind = 'board_decision'
     AND title = $o$بشأن حماية سرية بيانات المتعاملين فى الأنشطة المالية غير المصرفية$o$;
  SELECT id INTO v_new FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular';

  IF v_old IS NOT NULL AND v_new IS NOT NULL THEN
    SELECT count(*) INTO v_new_articles FROM articles WHERE law_id = v_new;
    IF v_new_articles = 5 THEN
      DELETE FROM laws WHERE id = v_old;
      RAISE NOTICE '[120] أُزيل صف board_decision المكرَّر (الكتاب المصحَّح موجود)';
    ELSE
      DELETE FROM laws WHERE id = v_new;
      UPDATE laws SET kind = 'circular', updated_at = now() WHERE id = v_old;
      RAISE NOTICE '[120] حُوِّل الصف القديم إلى circular (حُذف المكرَّر الناتج عن إعادة تشغيل 006)';
    END IF;
  ELSIF v_old IS NOT NULL THEN
    UPDATE laws SET kind = 'circular', updated_at = now() WHERE id = v_old;
    RAISE NOTICE '[120] حُوِّل الصف القديم من board_decision إلى circular';
  ELSIF v_new IS NOT NULL THEN
    RAISE NOTICE '[120] الصف circular موجود — لا تحويل مطلوب';
  ELSE
    RAISE WARNING '[120] الكتاب الدورى 4/2023 غير موجود فى laws — تخطّى';
  END IF;
END
$fix120_kind$;

UPDATE laws
   SET title = $t$كتاب دورى رقم 4 لسنة 2023 بتاريخ 12/10/2023 بشأن حماية سرية بيانات المتعاملين فى الأنشطة المالية غير المصرفية من مخاطر الاحتيال$t$,
       short_title = $s$حماية سرية بيانات المتعاملين من مخاطر الاحتيال$s$,
       enacted_at = DATE '2023-10-12',
       updated_at = now()
 WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular'
   AND (title IS DISTINCT FROM $t$كتاب دورى رقم 4 لسنة 2023 بتاريخ 12/10/2023 بشأن حماية سرية بيانات المتعاملين فى الأنشطة المالية غير المصرفية من مخاطر الاحتيال$t$ OR enacted_at IS DISTINCT FROM DATE '2023-10-12');

DO $fix120_art$
DECLARE
  v_law_id uuid;
  v_cnt int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RETURN;
  END IF;
  SELECT count(*) INTO v_cnt FROM articles WHERE law_id = v_law_id;
  IF v_cnt = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[120] أُزيلت المادة الواحدة التالفة (OCR خام)';
  ELSIF v_cnt = 5 THEN
    RAISE NOTICE '[120] 5 أقسام موجودة بالفعل — تخطّى الحذف';
  ELSE
    RAISE WARNING '[120] عدد مواد غير متوقَّع (%) — راجع يدوياً', v_cnt;
  END IF;
END
$fix120_art$;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $h1$الكتاب الدورى رقم 4 لسنة 2023$h1$, $t1$التمهيد وسبب الإصدار$t1$, $b1$انطلاقاً من الدور المنوط بالهيئة في حماية المتعاملين فى الأسواق المالية غير المصرفية، واتخاذ ما يلزم من الإجراءات للحد من التلاعب والغش في تلك الأسواق، وسعياً من الهيئة لاستمرار تقديم الخدمات المالية غير المصرفية بالمستويات المأمولة في تحقيق مستهدفات الشمول المالي والتنمية المستدامة، وما يتطلبه ذلك من اتخاذ السبل اللازمة لحماية سرية بيانات وسلامة تعاملات العملاء في تلك الأسواق من مخاطر الاحتيال، فإن الهيئة تؤكد على ما يلي:$b1$
  FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-12', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $h2$الكتاب الدورى رقم 4 لسنة 2023$h2$, $t2$البند (1): توضيح عدم الإفصاح عن بيانات العملاء وإرسال التحذير الشهري$t2$, $b2$1- التزام الشركات والجهات المرخص لها بمزاولة أي من الأنشطة المالية غير المصرفية بأن توضح لعملائها من الأشخاص الطبيعيين عند ابرام التعاقد معهم، بشكل مكتوب وشفهي، ضرورة عدم الإفصاح عن بياناتهم الشخصية أو المالية أو اسم المستخدم أو كلمة المرور (السر) والتي يتم التعامل بأي منها في تقديم الخدمات المالية غير المصرفية سواء بالطرق التقليدية أو باستخدام الأساليب التكنولوجية، لأي شخص طبيعي أو اعتباري، وكذا التزامها بإرسال تحذير شهري - بحد أدنى - لعملائها، عبر الهاتف المحمول للعميل أو بالطريقة المتبعة في شأن تبادل المراسلات بينهما، يتضمن بشكل واضح التنبيه عليهم بعدم الإفصاح عن أي من البيانات المشار إليها لأي شخص طبيعي أو اعتباري.$b2$
  FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-12', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $h3$الكتاب الدورى رقم 4 لسنة 2023$h3$, $t3$البند (2): تنبيه العاملين بعدم طلب بيانات العملاء أو تداولها أو الإفصاح عنها$t3$, $b3$2- التزام الشركات والجهات المرخص لها بمزاولة أي من الأنشطة المالية غير المصرفية بالتنبيه على العاملين بها بعدم طلب أي من البيانات المشار إليها أعلاه من العملاء أو تداولها أو الإفصاح عنها، عبر المكالمات الهاتفية أو الرسائل النصية على الهاتف المحمول أو تطبيقات التواصل الاجتماعي المختلفة أو من خلال الضغط على أي رابط إلكتروني غير موثوق فيه، مع ضرورة إيضاح الشركة أو الجهة لذلك الأمر لعملائها سواء عند ابرام التعاقد أو بالتحذير الدوري.$b3$
  FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-12', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $h4$الكتاب الدورى رقم 4 لسنة 2023$h4$, $t4$البند (3): إخطار العملاء بطلبات مشاركة البيانات ورصد الشكاوى وحماية قاعدة البيانات والتوعية$t4$, $b4$3- التزام الشركات والجهات المشار إليها بالتنبيه على عملائها بضرورة إخطارها بأي طلبات تردهم بأي طريقة كانت لمشاركة بياناتهم سالفة الذكر، وكذا قيام الشركة أو الجهة برصد أية شكاوى أو إخطارات تتلقاها في هذا الشأن واتخاذ اللازم نحو ذلك، مع ضرورة اتخاذ تلك الشركات والجهات لما يلزم نحو حماية قاعدة بيانات عملائها من مخاطر أمن المعلومات، وإيلاء العناية الواجبة لتعزيز مستويات التوعية اللازمة للعملاء بمخاطر الاحتيال.$b4$
  FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-12', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $h5$الكتاب الدورى رقم 4 لسنة 2023$h5$, $t5$النشر والتوقيع$t5$, $b5$يُنشر هذا الكتاب الدوري على الموقع الالكتروني للهيئة.

رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b5$
  FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-12', 'active' FROM ins5;

DO $verify120$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_stray int;
  v_content int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RAISE EXCEPTION '[120] الكتاب الدورى 4/2023 (circular) غير موجود';
  END IF;
  SELECT count(*) INTO v_stray FROM laws WHERE law_no = 4 AND law_year = 2023 AND kind <> 'circular';
  IF v_stray <> 0 THEN
    RAISE EXCEPTION '[120] ما زال هناك صف 4/2023 بنوع غير circular';
  END IF;
  IF (SELECT enacted_at FROM laws WHERE id = v_law_id) IS DISTINCT FROM DATE '2023-10-12' THEN
    RAISE EXCEPTION '[120] enacted_at غير مضبوط';
  END IF;
  SELECT count(*), COALESCE(sum(length(body)),0),
         count(*) FILTER (WHERE body LIKE '%' || chr(65533) || '%' OR body LIKE '%الورك%' OR body LIKE '%سربة%' OR body LIKE '%الطربقة%' OR body LIKE '%نريد%'),
         count(*) FILTER (WHERE (article_no = 2 AND body LIKE '%تحذير شهري - بحد أدنى%')
                             OR (article_no = 3 AND body LIKE '%الضغط على أي رابط إلكتروني غير موثوق فيه%')
                             OR (article_no = 4 AND body LIKE '%حماية قاعدة بيانات عملائها%')
                             OR (article_no = 5 AND body LIKE '%محمد فريد صالح%'))
    INTO v_arts, v_len, v_bad, v_content FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2023-10-12' AND av.status = 'active';
  IF v_arts <> 5 OR v_vers <> 5 THEN
    RAISE EXCEPTION '[120] متوقَّع 5 أقسام و5 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_content <> 4 THEN
    RAISE EXCEPTION '[120] فشل التحقق من المحتوى (تلف=%, محتوى=%)', v_bad, v_content;
  END IF;
  IF v_len <> 2011 THEN
    RAISE EXCEPTION '[120] مجموع الأطوال % لا يطابق المتوقع 2011', v_len;
  END IF;
  RAISE NOTICE '[120] كتاب دورى 4/2023: % أقسام و% نسخ سليمة.', v_arts, v_vers;
END
$verify120$;

COMMIT;
