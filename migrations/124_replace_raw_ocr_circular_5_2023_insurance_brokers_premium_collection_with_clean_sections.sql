-- 124_replace_raw_ocr_circular_5_2023_insurance_brokers_premium_collection_with_clean_sections.sql
--
-- إصلاح جذرى للكتاب الدورى رقم (5) لسنة 2023 الصادر عن رئيس الهيئة العامة للرقابة المالية بتاريخ
-- 29/10/2023 بشأن تحصيل رسوم أو أقساط وثائق التأمين أو غيرها من المبالغ من العملاء من خلال وسطاء
-- التأمين المقيدين لدى الهيئة.
--
-- ===== الحالة السابقة =====
-- (1) المتن مادة واحدة (article_no=1) ناتج OCR خام من الصورة الممسوحة: ترويسة مشوَّهة، ورقم الكتاب
--     وتاريخه مكسوران ("رقم ( ه ) لسنة ٠١١١ بستاريخ 5١7/١١/59")، ورقم قرار المجلس المُشار إليه مكسور
--     (")١١5( لسنة ه")، وأرقام البنود مشوَّهة ("؟-"، "*-"، "4-")، وكلمات مبتورة ("المبالخ"، "العيئة")، وتذييل
--     الصفحة (عنوان القرية الذكية/هاتف/فاكس) كلام مشوَّه داخل المتن.
-- (2) النوع kind = 'board_decision' بينما الوثيقة كتاب دورى (kind='circular').
-- (3) enacted_at = NULL رغم أن التاريخ مطبوع فى ترويسة الكتاب، والعنوان المخزَّن ناقص ("...من خلال وسطاء
--     التأمين" بلا عبارة "أو غيرها من المبالغ من العملاء" و"المقيدين لدى الهيئة") ولا يحمل رقم الكتاب ولا تاريخه.
--
-- ===== المصدر والمنهجية =====
-- النسخة الممسوحة (صفحة واحدة، بلا طبقة نصية) رفعها صاحب المشروع (كتاب-دوري-رقم-5-لسنة-2023.pdf)،
-- وهى الملف الذى يحمل اسمه laws.official_url (fra.gov.eg/wp-content/uploads/2023/11/...) ولم يُمس الرابط.
-- نُقل النص بقراءة بصرية بتكبير 220 dpi على أربعة مقاطع متتالية، وقورن بقراءة OCR مستقلة لكشف أى
-- سهو، والأرقام الهندية مقروءة لاتينية اتساقاً مع المنصة، وإملاء المصدر محفوظ كما هو (مثل "ابرام"
-- و"الالكتروني"). التاريخ المطبوع "بتاريخ 2023/10/29" بصيغة سنة/شهر/يوم (ورفع الملف إلى الموقع فى
-- نوفمبر 2023 حسب مسار الرابط لا يغيّر تاريخ الكتاب). حُذفت الترويسة والتذييل (شعار/عنوان/هاتف) لأنها
-- ليست من النص؛ ولا يحمل الكتاب توقيعاً ولا جهة موقِّعة مطبوعة (يكتفى بعبارة "رئيس الهيئة" فى الترويسة).
-- عنوان الكتاب انتقل إلى laws.title.
--
-- ===== الهيكل =====
-- الكتاب الدورى لا يحوى "مواد"؛ قُسِّم إلى 6 أقسام: التمهيد (يحدد قرار المجلس 215/2023 المعدِّل لقرار
-- 23/2014 وسبب التشديد)، ثم كل بند من البنود الأربعة فى قسم مستقل بعنوان يحمل موضوعه، ثم عبارة النشر.
-- ترقيم الأقسام = ترتيبها. التصنيف category='insurance' يبقى كما هو.
--
-- ===== التاريخ =====
-- effective_from = enacted_at = 2023-10-29 (تاريخ الكتاب المطبوع)؛ النص لا يحدد تاريخ سريان مختلفاً
-- (ينص فقط على النشر بالموقع الإلكترونى للهيئة).
--
-- ===== أمان إعادة التشغيل (مهم) =====
-- هجرة 006 تُعاد مع كل نشر وكانت تُدرج هذا الكتاب بنوع board_decision؛ عُدِّلت لتُدرجه بنوع circular
-- (نفس الكوميت)، وهذه الهجرة تتعامل مع كل الحالات: الصف القديم وحده (يُحوَّل فى مكانه)، أو الصفين
-- معاً فى أول نشر (يبقى القديم ويُحذف المكرَّر الجديد)، أو circular وحده (الحالة المستقرة). كل
-- الاستعلامات مقيَّدة بالنوع، والحذف مشروط بعنوان البذر القديم نفسه، وتحقق الختام محصور فى هذا
-- الكتاب. نفس نمط هجرات 117 و120 و123.
--
-- ملاحظة تشغيلية: الأقسام الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix124_kind$
DECLARE
  v_old uuid;
  v_new uuid;
  v_new_articles int;
BEGIN
  SELECT id INTO v_old FROM laws
   WHERE law_no = 5 AND law_year = 2023 AND kind = 'board_decision'
     AND title = $o$بشأن تحصيل رسوم أو أقساط وثائق التأمين من خلال وسطاء التأمين$o$;
  SELECT id INTO v_new FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular';

  IF v_old IS NOT NULL AND v_new IS NOT NULL THEN
    SELECT count(*) INTO v_new_articles FROM articles WHERE law_id = v_new;
    IF v_new_articles = 6 THEN
      DELETE FROM laws WHERE id = v_old;
      RAISE NOTICE '[124] أُزيل صف board_decision المكرَّر (الكتاب المصحَّح موجود)';
    ELSE
      DELETE FROM laws WHERE id = v_new;
      UPDATE laws SET kind = 'circular', updated_at = now() WHERE id = v_old;
      RAISE NOTICE '[124] حُوِّل الصف القديم إلى circular (حُذف المكرَّر الناتج عن إعادة تشغيل 006)';
    END IF;
  ELSIF v_old IS NOT NULL THEN
    UPDATE laws SET kind = 'circular', updated_at = now() WHERE id = v_old;
    RAISE NOTICE '[124] حُوِّل الصف القديم من board_decision إلى circular';
  ELSIF v_new IS NOT NULL THEN
    RAISE NOTICE '[124] الصف circular موجود — لا تحويل مطلوب';
  ELSE
    RAISE WARNING '[124] الكتاب الدورى 5/2023 غير موجود فى laws — تخطّى';
  END IF;
END
$fix124_kind$;

UPDATE laws
   SET title = $t$كتاب دورى رقم 5 لسنة 2023 بتاريخ 29/10/2023 بشأن تحصيل رسوم أو أقساط وثائق التأمين أو غيرها من المبالغ من العملاء من خلال وسطاء التأمين المقيدين لدى الهيئة$t$,
       short_title = $s$تحصيل رسوم أو أقساط وثائق التأمين من خلال وسطاء التأمين$s$,
       enacted_at = DATE '2023-10-29',
       updated_at = now()
 WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular'
   AND (title IS DISTINCT FROM $t$كتاب دورى رقم 5 لسنة 2023 بتاريخ 29/10/2023 بشأن تحصيل رسوم أو أقساط وثائق التأمين أو غيرها من المبالغ من العملاء من خلال وسطاء التأمين المقيدين لدى الهيئة$t$ OR enacted_at IS DISTINCT FROM DATE '2023-10-29');

DO $fix124_art$
DECLARE
  v_law_id uuid;
  v_cnt int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RETURN;
  END IF;
  SELECT count(*) INTO v_cnt FROM articles WHERE law_id = v_law_id;
  IF v_cnt = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[124] أُزيلت المادة الواحدة التالفة (OCR خام)';
  ELSIF v_cnt = 6 THEN
    RAISE NOTICE '[124] 6 أقسام موجودة بالفعل — تخطّى الحذف';
  ELSE
    RAISE WARNING '[124] عدد مواد غير متوقَّع (%) — راجع يدوياً', v_cnt;
  END IF;
END
$fix124_art$;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $h1$الكتاب الدورى رقم 5 لسنة 2023$h1$, $t1$التمهيد وسبب الإصدار$t1$, $b1$في ضوء صدور قرار مجلس إدارة الهيئة رقم (215) لسنة 2023 بتعديل قرار مجلس الإدارة رقم (23) لسنة 2014 بشأن القواعد الحاكمة لممارسة نشاط وساطة التأمين داخل جمهورية مصر العربية، وما تضمنه ذلك القرار من التزام وسطاء التأمين بعدم استلام أي مبالغ نقداً من العملاء تحت حساب رسوم الوثائق أو أقساطها إلا في الحدود المقررة لذلك بقانون تنظيم استخدام وسائل الدفع غير النقدي ولائحته التنفيذية، وكذا التزام الوسيط بالامتناع عن تحصيل أي مبالغ من العملاء بأية وسيلة ينتج عنها إضافة هذه المبالغ إلى حساباته الخاصة، فإن الهيئة تشدد على شركات التأمين الالتزام بما يلي:$b1$
  FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-29', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $h2$الكتاب الدورى رقم 5 لسنة 2023$h2$, $t2$البند (1): استلام المبالغ النقدية بإيصالات معتمدة وتوريدها خلال خمسة أيام عمل$t2$, $b2$1- أن يكون استلامها لأي مبالغ نقدية تحت حساب رسوم الوثائق أو أقساطها من وسطاء التأمين بموجب الإيصالات المعتمدة من الشركة والسابق تسليمها إليه كعهدة شخصية، والتأكد من وجود صورة الإيصال الموقع من العميل بما يفيد استلامه الأصل، مع التأكيد على الوسطاء بالقيام بتوريد تلك المبالغ إليها خلال خمسة أيام عمل من تاريخ تحصيلها.$b2$
  FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-29', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $h3$الكتاب الدورى رقم 5 لسنة 2023$h3$, $t3$البند (2): إتاحة وسائل السداد المباشر إلى حسابات الشركة$t3$, $b3$2- اتخاذ ما يلزم من إجراءات وإتاحة الوسائل التي تكفل لعملائها سداد المبالغ المشار إليها أعلاه بحساباتها بشكل مباشر، بما في ذلك تسليم الوسيط ماكينات نقاط دفع خاصة بالشركة أو موافاته بفروع الشركة أو حساباتها البنكية أو أي وسيلة دفع غير نقدي أخرى خاصة بها، على نحو يسمح له بتوضيح تلك الوسائل للعميل للسداد من خلالها مباشرة إلى حسابات الشركة.$b3$
  FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-29', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $h4$الكتاب الدورى رقم 5 لسنة 2023$h4$, $t4$البند (3): تنبيه العملاء بضرورة استلام إيصال معتمد وتوضيح وسائل الدفع غير النقدي$t4$, $b4$3- تنبيه العملاء عند ابرام التعاقد معهم عبر الهاتف المحمول للعميل أو بالطريقة المتبعة في شأن تبادل المراسلات بينهما، بما يفيد أن سداد أية مبالغ نقدية منهم لوسطاء التأمين لصالح الشركة يجب أن يكون مقروناً باستلام إيصال من الوسيط بقيمة المبلغ المدفوع على أن يكون ذلك الإيصال معتمداً من الشركة، وكذا توضيح أي من الوسائل المشار إليها بالبند السابق التي تقبلها الشركة في حالة الدفع غير النقدي وشرح لطريقة السداد من خلالها.$b4$
  FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-29', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $h5$الكتاب الدورى رقم 5 لسنة 2023$h5$, $t5$البند (4): إبلاغ الهيئة فوراً بتحويل الوسطاء المبالغ من حساباتهم الخاصة إلى حسابات الشركة$t5$, $b5$4- إبلاغ الهيئة فوراً في الحالات التي يقوم فيها وسطاء التأمين بتحويل المبالغ المشار إليها أعلاه من حساباتهم الخاصة إلى حسابات الشركة، لاتخاذ الإجراءات القانونية اللازمة حيال ذلك.$b5$
  FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-29', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $h6$الكتاب الدورى رقم 5 لسنة 2023$h6$, $t6$النشر$t6$, $b6$يُنشر هذا الكتاب الدوري على الموقع الالكتروني للهيئة.$b6$
  FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-10-29', 'active' FROM ins6;

DO $verify124$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_stray int;
  v_content int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RAISE EXCEPTION '[124] الكتاب الدورى 5/2023 (circular) غير موجود';
  END IF;
  SELECT count(*) INTO v_stray FROM laws WHERE law_no = 5 AND law_year = 2023 AND kind = 'board_decision';
  IF v_stray <> 0 THEN
    RAISE EXCEPTION '[124] ما زال هناك صف 5/2023 بنوع board_decision';
  END IF;
  IF (SELECT enacted_at FROM laws WHERE id = v_law_id) IS DISTINCT FROM DATE '2023-10-29' THEN
    RAISE EXCEPTION '[124] enacted_at غير مضبوط';
  END IF;
  SELECT count(*), COALESCE(sum(length(body)),0),
         count(*) FILTER (WHERE body LIKE '%' || chr(65533) || '%' OR body LIKE '%المبالخ%' OR body LIKE '%العيئة%' OR body LIKE '%بستاريخ%' OR body LIKE '%0110117%'),
         count(*) FILTER (WHERE (article_no = 1 AND body LIKE '%رقم (215) لسنة 2023%' AND body LIKE '%رقم (23) لسنة 2014%')
                             OR (article_no = 2 AND body LIKE '%خلال خمسة أيام عمل من تاريخ تحصيلها%')
                             OR (article_no = 3 AND body LIKE '%ماكينات نقاط دفع خاصة بالشركة%')
                             OR (article_no = 4 AND body LIKE '%يجب أن يكون مقروناً باستلام إيصال%')
                             OR (article_no = 5 AND body LIKE '%الإجراءات القانونية اللازمة حيال ذلك%')
                             OR (article_no = 6 AND body LIKE '%الموقع الالكتروني للهيئة%'))
    INTO v_arts, v_len, v_bad, v_content FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2023-10-29' AND av.status = 'active';
  IF v_arts <> 6 OR v_vers <> 6 THEN
    RAISE EXCEPTION '[124] متوقَّع 6 أقسام و6 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_content <> 6 THEN
    RAISE EXCEPTION '[124] فشل التحقق من المحتوى (تلف=%, محتوى=%)', v_bad, v_content;
  END IF;
  IF v_len <> 1849 THEN
    RAISE EXCEPTION '[124] مجموع الأطوال % لا يطابق المتوقع 1849', v_len;
  END IF;
  RAISE NOTICE '[124] كتاب دورى 5/2023: % أقسام و% نسخ سليمة.', v_arts, v_vers;
END
$verify124$;

COMMIT;
