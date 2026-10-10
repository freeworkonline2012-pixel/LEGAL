-- 189_replace_decision_82_2020_stop_new_licences_insurance_brokerage_companies_ocr_corrupted_two_rows_without_preamble_with_letterhead_and_footer_in_article_2.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (82) لسنة 2020 بتاريخ 2020/6/3 بشأن وقف منح تراخيص جديدة لشركات الوساطة فى التأمين وشركات الوساطة فى إعادة التأمين:
-- ديباجة ومادتان (صفحة واحدة)، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية OCR) =====
-- مخزَّن بالبذور صفّان (article_no = 1 بـ194 حرفاً و2 بـ334 حرفاً، بلا عنوان وبلا hierarchical_location) من OCR رديء للصفحة الممسوحة، وبهما:
-- (1) لا ديباجة: غاب كل ما قبل "قرر" (القانونان 10 لسنة 1981 و10 لسنة 2009 وتاريخ المذكرة 2020/5/7 وتاريخ جلسة المجلس 2020/6/3)، ولا عنوان القرار ولا رقمه ولا تاريخه؛
-- (2) المادة 2 تحمل بعد نصها بقايا ترويسة وتذييل مشوهة ("اليوم التاني" بدل "التالي"، و"حمل 3 3 5"، و"38 مجلس إدارة الغيئة"، و"القرية الذكية: مبنى 2١1١ الجيزة" والرقم البريدى والهاتف والفاكس و"نبنى الجسور لا الحواجزٌ")، وبلا اسم الموقِّع وصفته؛
-- (3) أرقام هندية متبقية، ونهايات أسطر CRLF، وتاريخ سريان هو تاريخ تشغيل البذر (2026-10-09) لا تاريخ القرار.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى ولا لإدخاله إلى سياق نموذج اللغة: يفتقد المرجعية (الرقم والتاريخ) وأساس القرار.
--
-- ===== المصدر والمنهجية =====
-- PDF من صفحة واحدة (34 كيلوبايت) قدّمه صاحب المشروع باسم UG50745UG50746 (هو الاسم نفسه فى official_url المسجَّل فى laws)؛ هو صورة ممسوحة بالأبيض والأسود (JBIG2، 200 نقطة للبوصة) على ورق الهيئة وبلا طبقة نص. قُرئ النص من الصورة الأصلية مباشرةً مقاطعَ مكبّرة، وكُبّرت أسطر الأرقام (رقم القرار 82 وتاريخه 2020/6/3 والقانونان وتاريخ المذكرة 2020/5/7 وتاريخ الجلسة 2020/6/3) وقُرئت رقماً رقماً (الأرقام المطبوعة هندية).
-- ثم قوبل النص المقروء بمخرجات OCR مستقل (tesseract ara): لم يظهر فرق فى لفظ غير ضجيج التعرف (التشوهات وترويسة الصفحة وتذييلها وبقايا الختم)، عدا كلمة واحدة أخطأها الـOCR هى "التالي" وهى ظاهرة بوضوح فى الصورة.
-- حُذفت ترويسة الصفحة (شعار "الهيئة العامة للرقابة المالية FINANCIAL REGULATORY AUTHORITY" وسطر "رئيس الهيئة")، وتذييلها (القرية الذكية والرقم البريدى والهاتف والفاكس وموقع الهيئة وشعار "نبنى الجسور لا الحواجز / Building Bridges not Walls")، وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان، وكلمة "قرر"، وختم "مكتب رئيس الهيئة" ورقمه المكتوب بخط اليد (46076) وتوقيع اليد (ليست من النص).
-- عنوان القرار ورقمه وتاريخه وموضوعه فى hierarchical_location للديباجة كما طُبعت على الصفحة (وكُتب فيها "العامة للرقابة المالية" بعد "الهيئة" بالصيغة الموحدة لعناوين الهجرات الأخرى؛ المطبوع "قرار مجلس إدارة الهيئة رقم (82) لسنة 2020 بتاريخ 2020/6/3"). الديباجة (article_no = 0 بعنوان "ديباجة القرار") من "بعد الاطلاع" إلى آخر "وبعد موافقة مجلس إدارة الهيئة"، وبعد "قرر" المادتان بعنوانين وسطيين "(المادة الأولى)" و"(المادة الثانية)" فعنوانا الصفين "المادة الأولى" و"المادة الثانية". والتوقيع باقٍ فى المادة 2 سطرين ("رئيس مجلس إدارة الهيئة / د. محمد عمران") كما طُبع.
-- لا تعديل على لفظ المطبوع. أُبقيت علامات الترقيم كما طُبعت: لا فاصلة بعد "لمدة عام" قبل "وتكليف" فى المادة الأولى، وكُتبت المادة فقرة واحدة (انكسر السطر المطبوع بعد "لمدة عام" لضيق السطر لا لبداية فقرة). وأُسقطت علامة الضمة فى "يُنشر" و"ويُعمل" ضمن إسقاط علامات التشكيل الصغيرة.
-- الأرقام لاتينية (المطبوعة هندية)، وضُبطت المسافات حول الفاصلة والفاصلة المنقوطة (" ، " و" ؛").
--
-- ===== الهيكل =====
-- 3 صفوف، 3 نسخ (version_no = 1): ديباجة (article_no = 0) ثم المادتان 1 و2 بأرقامهما الأصلية. أُبقى مفتاحا المادتين المخزَّنتين (1، 0) و(2، 0) فلا تعيد بذور 004/005/006 إدراج الصفوف القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2020-06-03 (تاريخ القرار المطبوع على الصفحة، معلن ومؤقت): المادة 2 تنص على العمل به "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، وتاريخ النشر غير مطبوع على النسخة المقدمة، ولم يُعثر عليه فى مصدر ثانوى (بحث صحفى لم يُظهر العدد ولا تاريخه)؛ فالتاريخ الفعلى للسريان لاحق لـ2020/6/3 ويجب أن يُراجَع على نسخة الوقائع المصرية. كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- ولا تُعدَّل بيانات laws (التاريخ ورقم القرار والعنوان والحالة) فى هذه الهجرة.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (3 صفوف بديباجة سليمة والمادة 2 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف، أو محتوى المواد، أو إجمالى الطول 703 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix189$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 82 AND law_year = 2020 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[189] القرار 82/2020 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 3
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[189] القرار 82/2020 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[189] أُزيلت % مادة من القرار 82/2020 (نص مخزَّن صفّان بلا ديباجة والمادة الثانية فيها ترويسة وتذييل مشوهان وبلا اسم الموقِّع)', v_n;
  END IF;
END
$fix189$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 82 لسنة 2020 بتاريخ 2020/6/3 بشأن وقف منح تراخيص جديدة لشركات الوساطة في التأمين وشركات الوساطة في إعادة التأمين$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون الإشراف والرقابة على التأمين في مصر الصادر بالقانون رقم (10) لسنة 1981 ولائحته التنفيذية ؛
وعلى القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى المذكرة المعدة من الإدارة المركزية للإشراف والرقابة على التأمين بتاريخ 2020/5/7 ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2020/6/3.$b0_0$
  FROM laws WHERE law_no = 82 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-06-03', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$وقف منح تراخيص جديدة لشركات الوساطة في التأمين وشركات الوساطة في إعادة التأمين لمدة عام وتكليف الإدارات المختصة بالهيئة بإعداد دراسة حول ضوابط وشروط عمل تلك الشركات بهدف تطويرها وتنمية نشاطها.$b1_0$
  FROM laws WHERE law_no = 82 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-06-03', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة الهيئة
د. محمد عمران$b2_0$
  FROM laws WHERE law_no = 82 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-06-03', 'active' FROM ins2_0;

DO $verify189$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 82 AND law_year = 2020 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[189] القرار 82/2020 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 3 THEN RAISE EXCEPTION '[189] عدد المواد % بدل 3', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2020-06-03';
  IF v_v <> 3 THEN RAISE EXCEPTION '[189] عدد النسخ % بدل 3', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الغيئة%' OR body LIKE '%الهينئة%' OR body LIKE '%الشيئة%' OR body LIKE '%التاني%' OR body LIKE '%الرقم اليريدى%' OR body LIKE '%القرية الذكية%' OR body LIKE '%الرقم البريدى%' OR body LIKE '%تليفون%' OR body LIKE '%نبنى الجسور%' OR body LIKE '%Building Bridges%' OR body LIKE '%WWW%' OR body LIKE '%FRA.GOV%' OR body LIKE '%الحواجر%' OR body LIKE '%التأصين%' OR body LIKE '%٠%' OR body LIKE '%١%' OR body LIKE '%�%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%ال يقل%' OR body LIKE '%وقف منج%' OR body LIKE '%حمل 3%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[189] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون الإشراف والرقابة على ال%' AND body LIKE '%لسته المنعقدة بتاريخ 2020/6/3.' AND body LIKE '%رقم (10) لسنة 1981 ولائحته التنفيذية ؛%' AND body LIKE '%رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق%' AND body LIKE '%بتاريخ 2020/5/7 ؛%' AND body LIKE '%المنعقدة بتاريخ 2020/6/3.') THEN RAISE EXCEPTION '[189] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'وقف منح تراخيص جديدة لشركات الوساطة في التأمي%' AND body LIKE '%ات بهدف تطويرها وتنمية نشاطها.' AND body LIKE '%لمدة عام وتكليف الإدارات المختصة بالهيئة%' AND body LIKE '%بهدف تطويرها وتنمية نشاطها.') THEN RAISE EXCEPTION '[189] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد عمران' AND body LIKE '%ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.%' AND body LIKE '%رئيس مجلس إدارة الهيئة%' AND body LIKE '%د. محمد عمران') THEN RAISE EXCEPTION '[189] المادة 2 غير سليم'; END IF;
  IF v_len <> 703 THEN RAISE EXCEPTION '[189] إجمالى طول المواد % بدل 703', v_len; END IF;
  RAISE NOTICE '[189] القرار 82/2020: 3 مواد و3 نسخ، إجمالى % حرف', v_len;
END
$verify189$;

COMMIT;
