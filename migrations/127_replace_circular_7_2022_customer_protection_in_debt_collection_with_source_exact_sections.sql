-- 127_replace_circular_7_2022_customer_protection_in_debt_collection_with_source_exact_sections.sql
--
-- مطابقة الكتاب الدورى رقم (7) لسنة 2022 الصادر عن رئيس الهيئة العامة للرقابة المالية بتاريخ 29/12/2022
-- بشأن حماية العملاء من الممارسات السلبية فى تحصيل المستحقات مع الأصل الرسمى الممسوح وإعادة بنائه بنص مطابق.
--
-- ===== نتيجة المقابلة (بذر هجرة 015، مادة واحدة) =====
-- النص المخزَّن قريب جداً من الأصل (مُدخَل بعناية)، والعنوان والتاريخ المخزَّنان صحيحان
-- (29/12/2022؛ ترويسة الأصل: "بتاريخ" و"رقم" مكتوبان بخط اليد، خانتا اليوم "2" و"9"). المقابلة تسلسلاً
-- كلمةً كلمة (بعد توحيد الإملاء) كشفت فرقاً جوهرياً وحيداً: فى الفقرة الثانية كُتب "بمزاولة نشاط تمويل
-- المشروعات المتناهية الصغر" بينما الأصل "بمزاولة نشاطى تمويل المشروعات المتناهية الصغر، وتمويل
-- المشروعات المتوسطة والصغيرة" (نشاطان لا نشاط واحد، كما فى الفقرة الأولى)، إضافة إلى تصحيح كلمة
-- "بكلاً من" الواردة هكذا فى الأصل إلى "بكلٍ من"، وتحويل إملاء الياء (ى بدل ي) فى كل النص، واستبدال
-- علامتى الصح (✓) أمام المبدأين بشرطة، وكل الكتاب فى مادة واحدة بلا تقسيم. لا شىء آخر فى المحتوى.
--
-- ===== المصدر والمنهجية =====
-- نسخة ممسوحة (صفحة واحدة، بلا طبقة نصية) رفعها صاحب المشروع (كتاب-دورى٧.pdf) وهى الملف الذى يحمل اسمه
-- laws.official_url (fra.gov.eg/wp-content/uploads/2023/01/...) ولم يُمس الرابط. قُرئ النص بصرياً
-- بتكبير 220 dpi على أربعة مقاطع وقورن بقراءة OCR مستقلة (tesseract ara) وبالنص المخزَّن بمقارنة تسلسلية
-- (difflib) بعد توحيد الإملاء. الأرقام الهندية مقروءة لاتينية اتساقاً مع المنصة، وإملاء المصدر محفوظ كما هو
-- (ومنه "بكلاً من" و"المسئول")، والمسافة الزائدة قبل "اتخاذ" وقبل الفاصلة بعد 2009 وفاصل التنوين فى
-- "وانطلاقاً" عُدِّلت كأخطاء طباعية. حُذفت الترويسة والتذييل وختم الجهة ورقم القيد المختوم (46076)؛ التوقيع
-- المطبوع محفوظ فى آخر القسم الأخير. عنوان الكتاب فى laws.title كما هو (صحيح).
--
-- ===== الهيكل =====
-- 4 أقسام: التمهيد، التشديد على الالتزام بقرار مجلس الإدارة 123/2016 (المبدآن الخامس والسادس)، التشديد
-- على الالتزام بالكتاب الدورى 6/2022، ثم التزامات جهة التمويل ومجلس الإدارة والتوقيع. ترقيم الأقسام =
-- ترتيبها. التصنيف category='non_bank_finance' والنوع 'circular' والتاريخ كما هى.
--
-- ===== التاريخ =====
-- لا تغيير: effective_from = enacted_at = 2022-12-29 (تاريخ الكتاب المطبوع/المكتوب؛ لا نص يحدد سريانا مختلفاً).
--
-- ===== أمان إعادة التشغيل =====
-- هجرة 015 تُعاد مع كل نشر: إدراج الصف يتعارض (ON CONFLICT DO NOTHING)، وإدراج المادة رقم 1 يتعارض مع
-- القسم الأول الجديد فلا يُعاد إدراج النص القديم. الحذف هنا مشروط بوجود مادة واحدة فقط (الحالة القديمة)،
-- والإدراج بـON CONFLICT DO NOTHING، وتحقق الختام محصور فى هذا الكتاب (kind='circular').
--
-- ملاحظة تشغيلية: الأقسام الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix127_art$
DECLARE
  v_law_id uuid;
  v_cnt int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 7 AND law_year = 2022 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[127] الكتاب الدورى 7/2022 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  SELECT count(*) INTO v_cnt FROM articles WHERE law_id = v_law_id;
  IF v_cnt = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[127] أُزيلت المادة الواحدة المخزَّنة (يشوبها اختلاف عن الأصل)';
  ELSIF v_cnt = 4 THEN
    RAISE NOTICE '[127] 4 أقسام موجودة بالفعل — تخطّى الحذف';
  ELSE
    RAISE WARNING '[127] عدد مواد غير متوقَّع (%) — راجع يدوياً', v_cnt;
  END IF;
END
$fix127_art$;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $h1$الكتاب الدورى رقم 7 لسنة 2022$h1$, $t1$التمهيد وسبب الإصدار$t1$, $b1$في إطار اضطلاع الهيئة العامة للرقابة المالية بمباشرة دورها بشأن تنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية، بما في ذلك نشاطي تمويل المشروعات المتناهية الصغر، وتمويل المشروعات المتوسطة والصغيرة بوصفهما أحد أهم الأدوات الداعمة للأنشطة الاقتصادية والإنتاجية والخدمية وانطلاقاً من دورها الرقابي وحرصها على استقرار الأسواق وحماية المتعاملين بها وفق القانون رقم 10 لسنة 2009، والحفاظ على حقوق المتعاملين فيها، وتوفير الوسائل والنظم، وإصدار القواعد التي تضمن كفاءة هذه الأسواق وشفافية الأنشطة التي تمارس فيها، واتخاذ ما يلزم من الإجراءات للحد من التلاعب والغش في تلك الأسواق، مع التأكيد على مراعاة حماية المتعاملين فيها.$b1$
  FROM laws WHERE law_no = 7 AND law_year = 2022 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-29', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $h2$الكتاب الدورى رقم 7 لسنة 2022$h2$, $t2$التشديد على الالتزام بقرار مجلس الإدارة رقم 123 لسنة 2016 (المبدآن الخامس والسادس)$t2$, $b2$لذا تشدد الهيئة على كافة الشركات والجمعيات والمؤسسات الأهلية المرخص لها بمزاولة نشاطي تمويل المشروعات المتناهية الصغر، وتمويل المشروعات المتوسطة والصغيرة الخاضعة لإشراف ورقابة الهيئة الالتزام بتنفيذ ما ورد بقرار مجلس إدارة الهيئة رقم (123) لسنة 2016 بشأن " دليل حماية عملاء الشركات والجمعيات/ المؤسسات الأهلية التي تزاول نشاط التمويل متناهي الصغر" وبصفة خاصة سلوكيات التعامل مع العملاء على النحو الوارد بكلاً من:
- المبدأ الخامس " مراعاة الاعتبارات المهنية والأخلاقية في التعامل مع العملاء"،
- المبدأ السادس " تيسير سداد الأقساط"$b2$
  FROM laws WHERE law_no = 7 AND law_year = 2022 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-29', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $h3$الكتاب الدورى رقم 7 لسنة 2022$h3$, $t3$التشديد على الالتزام بالكتاب الدوري رقم 6 لسنة 2022$t3$, $b3$كما تشدد الهيئة على جميع الجهات الالتزام بما ورد بالكتاب الدوري رقم (6) لسنة 2022 بشأن " اعتبارات منح التمويل وتطبيق خيار السداد المعجل لمواجهة مخاطر التعثر"$b3$
  FROM laws WHERE law_no = 7 AND law_year = 2022 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-29', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $h4$الكتاب الدورى رقم 7 لسنة 2022$h4$, $t4$التزامات جهة التمويل ومجلس الإدارة والتوقيع$t4$, $b4$وعلى جهة التمويل القيام بدورها نحو توعية كافة العاملين لديها بذلك، ويلتزم مجلس الإدارة، والمسئول الفعلي عن إدارة نشاط التمويل لدى جهة التمويل باتخاذ كل ما يلزم نحو الالتزام بتطبيق ما ورد بالكتاب الدوري على مستوى كافة منافذ تقديم خدمات التمويل. وإخطار الهيئة فوراً بما قد يتكشف لهم ويتعارض مع أحكامه، وتقع عليهم مسئولية عدم الالتزام.

رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د/محمد فريد صالح$b4$
  FROM laws WHERE law_no = 7 AND law_year = 2022 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-12-29', 'active' FROM ins4;

DO $verify127$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_content int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 7 AND law_year = 2022 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RAISE EXCEPTION '[127] الكتاب الدورى 7/2022 (circular) غير موجود';
  END IF;
  IF (SELECT enacted_at FROM laws WHERE id = v_law_id) IS DISTINCT FROM DATE '2022-12-29'
     OR (SELECT title FROM laws WHERE id = v_law_id) NOT LIKE '%بتاريخ 29/12/2022%' THEN
    RAISE EXCEPTION '[127] تاريخ/عنوان الكتاب غير مضبوط';
  END IF;
  SELECT count(*), COALESCE(sum(length(body)),0),
         count(*) FILTER (WHERE body LIKE '%' || chr(65533) || '%' OR body LIKE '%بمزاولة نشاط تمويل المشروعات المتناهية%'
                             OR body ~ '[٠-٩]' OR body LIKE '%✓%'),
         count(*) FILTER (WHERE (article_no = 1 AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%نشاطي تمويل المشروعات المتناهية الصغر%')
                             OR (article_no = 2 AND body LIKE '%بمزاولة نشاطي تمويل المشروعات المتناهية الصغر%'
                                 AND body LIKE '%رقم (123) لسنة 2016%' AND body LIKE '%المبدأ السادس%')
                             OR (article_no = 3 AND body LIKE '%الدوري رقم (6) لسنة 2022%')
                             OR (article_no = 4 AND body LIKE '%عدم الالتزام.%' AND body LIKE '%محمد فريد صالح%'))
    INTO v_arts, v_len, v_bad, v_content FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2022-12-29' AND av.status = 'active';
  IF v_arts <> 4 OR v_vers <> 4 THEN
    RAISE EXCEPTION '[127] متوقَّع 4 أقسام و4 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_content <> 4 THEN
    RAISE EXCEPTION '[127] فشل التحقق من المحتوى (تلف=%, محتوى=%)', v_bad, v_content;
  END IF;
  IF v_len <> 1708 THEN
    RAISE EXCEPTION '[127] مجموع الأطوال % لا يطابق المتوقع 1708', v_len;
  END IF;
  RAISE NOTICE '[127] كتاب دورى 7/2022: % أقسام و% نسخ سليمة.', v_arts, v_vers;
END
$verify127$;

COMMIT;
