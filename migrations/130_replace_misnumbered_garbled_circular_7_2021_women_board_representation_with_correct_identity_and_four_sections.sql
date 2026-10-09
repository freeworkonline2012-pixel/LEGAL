-- 130_replace_misnumbered_garbled_circular_7_2021_women_board_representation_with_correct_identity_and_four_sections.sql
--
-- إصلاح جذرى للكتاب الدورى رقم (7) لسنة 2021 الصادر عن نائب رئيس الهيئة العامة للرقابة المالية بتاريخ
-- 25/7/2021 بشأن تمثيل المرأة فى مجالس إدارات الشركات العاملة فى مجال الأنشطة المالية غير المصرفية
-- والشركات المقيد لها أوراق مالية بالبورصة المصرية (يوضح القرارين 109 و110 لسنة 2021).
--
-- ===== الحالة السابقة (خمسة عيوب فى صف واحد، بذر هجرة 006) =====
-- (1) رقم خاطئ: مخزَّن باسم 17/2021 بينما رقمه 7/2021 (قراءة OCR للرقم "(7)" بصورة "017/107").
-- (2) النوع kind='board_decision' بينما الوثيقة كتاب دورى (kind='circular').
-- (3) المتن مادة واحدة (article_no=1) ناتج OCR خام: ترويسة مشوهة، ورقم الكتاب وسنته وتاريخه مكسورة،
--     ورقما القرارين (109) و(110) وسنتاهما مكسورة، والنسبة (25%) المذكورة مرتين مقروءة "(5؟96)" و"(9015)"
--     (أى أن أهم رقم فى الوثيقة غير صحيح)، وتذييل الصفحة (العنوان والهاتف) داخل المتن.
-- (4) التصنيف category='insurance' بينما الكتاب موجَّه لكل الأنشطة المالية غير المصرفية والشركات المقيدة بالبورصة.
-- (5) enacted_at = NULL رغم أن التاريخ مطبوع فى الترويسة وفى ختام الكتاب (2021/7/25).
--
-- ===== المصدر والمنهجية =====
-- النسخة الممسوحة (صفحة واحدة، بلا طبقة نصية) رفعها صاحب المشروع، والرابط المخزَّن فى laws.official_url
-- يخص الكتاب نفسه (fra.gov.eg/wp-content/uploads/2021/07/...) ولم يُمس. قُرئ النص بصرياً بتكبير 240 و400 dpi
-- على خمسة مقاطع كلمةً كلمة، وقورن بقراءة OCR مستقلة (tesseract ara) فلم يبقَ فرق حروف غير مفسَّر
-- (فروق OCR كلها فى الأرقام الهندية والترويسة والختم). فُحصت الأرقام بتكبير خاص: 109 و110 و2021 و2030
-- و(25%) مرتين وتاريخ 2021/7/25 مرتين. الأرقام الهندية مقروءة لاتينية اتساقاً مع المنصة، وإملاء المصدر
-- محفوظ كما هو. حُذفت الترويسة والتذييل (العنوان والهاتف) وخاتم الجهة ورقم القيد المختوم.
-- التوقيع (نائب رئيس الهيئة، د. إسلام عزام) محفوظ فى آخر القسم الأخير.
--
-- ===== الهيكل =====
-- الكتاب لا يحوى "مواد"؛ قُسِّم إلى 4 أقسام وفق فقراته: التمهيد وسبب الإصدار، تأكيد الهيئة أن الالتزام
-- تخييرى، ما تتحقق به الشركات من الوفاء بالالتزام، ثم النشر والتحرير والتوقيع. ترقيم الأقسام = ترتيبها.
-- دمج الأقسام بفاصل سطر فارغ يعيد المتن كاملاً بلا حذف.
--
-- ===== التاريخ والنطاق =====
-- enacted_at = effective_from = 2021-07-25 (تاريخ الكتاب؛ لا نص يحدد سريانا مختلفاً). governance_scope
-- يبقى true (الكتاب ضمن نطاق الحوكمة منذ 032 باسم 17/2021) ويُثبَّت هنا صراحةً بعد تغيير الرقم والتصنيف.
-- التصنيف category='non_bank_finance' (نفس تصنيف الكتاب الدورى 1/2023 فى 114) والنوع 'circular'.
--
-- ===== أمان إعادة التشغيل (مهم) =====
-- هجرة 006 تُعاد مع كل نشر وتُدرج صفاً جديداً باسم 17/2021 (نوع board_decision) بالمتن التالف، وهجرة 032
-- تَسِمه governance_scope. لذلك تعمل هذه الهجرة (وهى تُنفَّذ بعدهما) على الحالات الثلاث: الصف القديم وحده
-- (يُحوَّل فى مكانه بحفظ معرّفه ووسمه)، أو الصفان معاً (يُحذف الصف المكرَّر من إعادة البذر)، أو الصف
-- المصحَّح وحده (الحالة المستقرة). الحذف مشروط برقم 17/2021 ونوع board_decision وعنوان البذر القديم نفسه،
-- فلا يُمس أى قرار آخر. الأقسام تُدرج بـON CONFLICT DO NOTHING، وتحقق الختام محصور فى هذا الكتاب.
--
-- ملاحظة تشغيلية: الأقسام الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix130_law$
DECLARE
  v_old uuid;
  v_new uuid;
BEGIN
  SELECT id INTO v_old FROM laws
   WHERE country_code = 'EG' AND law_no = 17 AND law_year = 2021 AND kind = 'board_decision'
     AND title = $o$بشأن تمثيل المرأة فى مجالس إدارات الشركات العاملة فى الأنشطة المالية غير المصرفية$o$;
  SELECT id INTO v_new FROM laws
   WHERE country_code = 'EG' AND law_no = 7 AND law_year = 2021 AND kind = 'circular';

  IF v_old IS NOT NULL AND v_new IS NOT NULL THEN
    DELETE FROM laws WHERE id = v_old;
    RAISE NOTICE '[130] أُزيل الصف المكرَّر 17/2021 (ناتج إعادة تشغيل 006)؛ الكتاب المصحَّح 7/2021 موجود';
  ELSIF v_old IS NOT NULL THEN
    UPDATE laws SET law_no = 7, kind = 'circular', updated_at = now() WHERE id = v_old;
    RAISE NOTICE '[130] حُوِّل الصف 17/2021 (board_decision) إلى 7/2021 (circular) بحفظ المعرّف';
  ELSIF v_new IS NOT NULL THEN
    RAISE NOTICE '[130] الصف 7/2021 (circular) موجود — لا تحويل مطلوب';
  ELSE
    RAISE WARNING '[130] الكتاب الدورى 17/2021 (القديم) و7/2021 غير موجودين فى laws — تخطّى';
  END IF;
END
$fix130_law$;

UPDATE laws
   SET title = $t$كتاب دورى رقم 7 لسنة 2021 بتاريخ 25/7/2021 بشأن تمثيل المرأة فى مجالس إدارات الشركات العاملة فى مجال الأنشطة المالية غير المصرفية والشركات المقيد لها أوراق مالية بالبورصة المصرية$t$,
       short_title = $s$تمثيل المرأة فى مجالس إدارات الشركات العاملة فى الأنشطة المالية غير المصرفية والشركات المقيد لها أوراق مالية$s$,
       category = 'non_bank_finance',
       enacted_at = DATE '2021-07-25',
       governance_scope = true,
       updated_at = now()
 WHERE country_code = 'EG' AND law_no = 7 AND law_year = 2021 AND kind = 'circular'
   AND (title IS DISTINCT FROM $t$كتاب دورى رقم 7 لسنة 2021 بتاريخ 25/7/2021 بشأن تمثيل المرأة فى مجالس إدارات الشركات العاملة فى مجال الأنشطة المالية غير المصرفية والشركات المقيد لها أوراق مالية بالبورصة المصرية$t$ OR short_title IS DISTINCT FROM $s$تمثيل المرأة فى مجالس إدارات الشركات العاملة فى الأنشطة المالية غير المصرفية والشركات المقيد لها أوراق مالية$s$
        OR category IS DISTINCT FROM 'non_bank_finance' OR enacted_at IS DISTINCT FROM DATE '2021-07-25'
        OR governance_scope IS DISTINCT FROM true);

DO $fix130_art$
DECLARE
  v_law_id uuid;
  v_cnt int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE country_code = 'EG' AND law_no = 7 AND law_year = 2021 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RETURN;
  END IF;
  SELECT count(*) INTO v_cnt FROM articles WHERE law_id = v_law_id;
  IF v_cnt = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[130] أُزيلت المادة الواحدة التالفة (OCR خام)';
  ELSIF v_cnt = 0 THEN
    RAISE NOTICE '[130] لا مواد قديمة — تُدرج الأقسام الأربعة';
  ELSIF v_cnt = 4 THEN
    RAISE NOTICE '[130] 4 أقسام موجودة بالفعل — تخطّى الحذف';
  ELSE
    RAISE WARNING '[130] عدد مواد غير متوقَّع (%) — راجع يدوياً', v_cnt;
  END IF;
END
$fix130_art$;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $h1$الكتاب الدورى رقم 7 لسنة 2021$h1$, $t1$التمهيد وسبب الإصدار (القراران 109 و110 لسنة 2021)$t1$, $b1$في إطار الجهود التي تبذلها الهيئة للإسهام في تمكين المرأة بإعطائها الفرصة للقيادة والمشاركة في صنع القرار بما يتسق مع رؤية مصر 2030 واستراتيجيتها للتنمية المستدامة في هذا الشأن، فقد أصدر مجلس إدارة الهيئة القرار رقم (109) لسنة 2021 بتعديل قواعد قيد وشطب الأوراق المالية بالبورصة المصرية والقرار رقم (110) لسنة 2021 بتعديل ضوابط منح الترخيص واستمراره وقواعد تملك أسهم الشركات العاملة في الأنشطة المالية غير المصرفية، وذلك باشتراط أن يتضمن تشكيل مجالس إدارات الشركات المقيد لها أوراق مالية بالبورصة المصرية والشركات العاملة في الأنشطة المالية غير المصرفية عناصر نسائية وذلك على النحو الوارد بهذين القرارين.$b1$
  FROM laws WHERE country_code = 'EG' AND law_no = 7 AND law_year = 2021 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-25', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $h2$الكتاب الدورى رقم 7 لسنة 2021$h2$, $t2$تأكيد الهيئة: الالتزام تخييرى (عضوتان على الأقل أو نسبة لا تقل عن 25%)$t2$, $b2$وفي هذا الصدد، فإن الهيئة وحرصاً منها على استقرار الأسواق المالية غير المصرفية وحسن تطبيق القرارات الصادرة عنها تود أن تؤكد على أن التزام الشركات المقيد لها أوراق مالية بالبورصة المصرية والشركات العاملة في الأنشطة المالية غير المصرفية وفقاً لقراري مجلس إدارة الهيئة المشار إليهما هو التزام تخييري إما بأن يتضمن تشكيل مجالس إدارات هذه الشركات عضوتين على الأقل أو ألا تقل نسبة تمثيل المرأة عن (25%) من تشكيل مجالس إدارات تلك الشركات.$b2$
  FROM laws WHERE country_code = 'EG' AND law_no = 7 AND law_year = 2021 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-25', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $h3$الكتاب الدورى رقم 7 لسنة 2021$h3$, $t3$ما تتحقق به الشركات من الوفاء بالالتزام (الخيار بين عضوتين أو 25%)$t3$, $b3$وبالتالي فإن هذه الشركات وحتى تكون قد أوفت بالتزامها وفقاً لأحكام قراري مجلس إدارة الهيئة المشار إليهما، يكون لها الخيار إما أن يتضمن تشكيل مجالس إداراتها عضوتين أو أن تكون نسبة تمثيل المرأة في هذا التشكيل لا تقل عن (25%) منه.$b3$
  FROM laws WHERE country_code = 'EG' AND law_no = 7 AND law_year = 2021 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-25', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $h4$الكتاب الدورى رقم 7 لسنة 2021$h4$, $t4$النشر والتحرير والتوقيع$t4$, $b4$يُنشر هذا الكتاب الدوري على الموقع الالكتروني لكل من الهيئة والبورصة المصرية.

تحريراً في: 2021/7/25

نائب رئيس الهيئة
د. إسلام عزام$b4$
  FROM laws WHERE country_code = 'EG' AND law_no = 7 AND law_year = 2021 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-25', 'active' FROM ins4;

DO $verify130$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_content int;
  v_dup int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE country_code = 'EG' AND law_no = 7 AND law_year = 2021 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RAISE EXCEPTION '[130] الكتاب الدورى 7/2021 (circular) غير موجود';
  END IF;
  IF (SELECT enacted_at FROM laws WHERE id = v_law_id) IS DISTINCT FROM DATE '2021-07-25'
     OR (SELECT title FROM laws WHERE id = v_law_id) NOT LIKE '%بتاريخ 25/7/2021%'
     OR (SELECT governance_scope FROM laws WHERE id = v_law_id) IS DISTINCT FROM true THEN
    RAISE EXCEPTION '[130] بيانات الكتاب (التاريخ/العنوان/نطاق الحوكمة) غير مضبوطة';
  END IF;
  SELECT count(*) INTO v_dup FROM laws
   WHERE country_code = 'EG' AND law_no = 17 AND law_year = 2021 AND kind = 'board_decision'
     AND title = $o$بشأن تمثيل المرأة فى مجالس إدارات الشركات العاملة فى الأنشطة المالية غير المصرفية$o$;
  IF v_dup <> 0 THEN
    RAISE EXCEPTION '[130] ما زال صف 17/2021 القديم موجوداً (%)', v_dup;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)),0),
         count(*) FILTER (WHERE body LIKE '%' || chr(65533) || '%' OR body ~ '[٠-٩]' OR body LIKE '%تمشيل%'
                             OR body LIKE '%5؟96%' OR body LIKE '%9015%' OR body LIKE '%نبنى الجسور%' OR body LIKE '%الرقمالبريدى%'),
         count(*) FILTER (WHERE (article_no = 1 AND body LIKE '%رقم (109) لسنة 2021%' AND body LIKE '%رقم (110) لسنة 2021%'
                                 AND body LIKE '%رؤية مصر 2030%' AND body LIKE '%عناصر نسائية%')
                             OR (article_no = 2 AND body LIKE '%التزام تخييري%' AND body LIKE '%عضوتين على الأقل%'
                                 AND position('(25%)' in body) > 0)
                             OR (article_no = 3 AND body LIKE '%يكون لها الخيار%' AND body LIKE '%عضوتين%' AND position('(25%) منه' in body) > 0)
                             OR (article_no = 4 AND body LIKE '%تحريراً في: 2021/7/25%' AND body LIKE '%إسلام عزام%'))
    INTO v_arts, v_len, v_bad, v_content FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2021-07-25' AND av.status = 'active';
  IF v_arts <> 4 OR v_vers <> 4 THEN
    RAISE EXCEPTION '[130] متوقَّع 4 أقسام و4 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_content <> 4 THEN
    RAISE EXCEPTION '[130] فشل التحقق من المحتوى (تلف=%, محتوى=%)', v_bad, v_content;
  END IF;
  IF v_len <> 1393 THEN
    RAISE EXCEPTION '[130] مجموع الأطوال % لا يطابق المتوقع 1393', v_len;
  END IF;
  RAISE NOTICE '[130] كتاب دورى 7/2021: % أقسام و% نسخ سليمة.', v_arts, v_vers;
END
$verify130$;

COMMIT;
