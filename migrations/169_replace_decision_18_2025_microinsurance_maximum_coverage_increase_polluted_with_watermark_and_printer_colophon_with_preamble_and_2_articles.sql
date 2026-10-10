-- 169_replace_decision_18_2025_microinsurance_maximum_coverage_increase_polluted_with_watermark_and_printer_colophon_with_preamble_and_2_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (18) لسنة 2025 بشأن زيادة الحد الأقصى للتغطية التأمينية لنشاط التأمين متناهى الصغر،
-- المنشور بالوقائع المصرية، العدد 30 (تابع)، فى 6 فبراير 2025 (الصفحة 20): ديباجة ومادتان، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (مادتان، 507 أحرف) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) بقايا تطويل تالفة (U+FFFD، 15 حرفاً) تتخلل الكلمات ("ُي���زاد" و"الح���د" و"نش���اط" و"متناه���ى")، وحروف اللام ألف مقلوبة الترتيب ("األقصى" و"ثالثمائة" و"اإللكترونى" و"اإليداع")، وتنوين مفصول عن حرفه ("أل ًفا" و"و ُيعمل" و"و ُيلغى")؛
-- (2) ذيل طباعة الوقائع ("طبعت بالهيئة العامة لشئون المطابع الأميرية" واسم رئيس مجلس إدارة الهيئة المطابع الأميرية ورقم الإيداع بدار الكتب 268 لسنة 2025 ورقم الإيداع 2024/25589) مُلحق بالمادة الثانية بعد توقيع القرار؛
-- (3) 10 فواصل CRLF داخل الجملة، وأرقام مقلوبة الترتيب فى ذيل الطباعة ("509- 2025/2/6 - 2024/25589")؛
-- (4) بلا ديباجة (الاطلاعات الثلاثة وموافقة مجلس الإدارة بجلسة 2025/1/28) ولا تاريخ سريان.
-- فالنص المخزَّن لا يصلح للاستشهاد الرسمى؛ والأهم أن مبلغ الحد الأقصى للتغطية فيه مكتوب "ثالثمائة واثنى عشر أل ًفا وخمسمائة جنيه" بحروف مقلوبة وتنوين مفصول، فلا يطابق بحث الكلمات ولا يُقرأ كما نُشر.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحة واحدة، 245.2 كيلوبايت) قدّمه صاحب المشروع؛ فيه علامة مائية قطرية مرسومة بخط مستقل (AhabHeadline) فاستُبعدت حروف ذلك الخط من الاستخراج.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً، وأُعيد تركيب الفقرات بإحداثيات الأسطر.
-- حُذفت ترويسة الصفحة وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" وعنوان القرار (إلى hierarchical_location للديباجة)، وحُذف ذيل الطباعة كله (جهة الطباعة والتوقيع المطبعى ورقم الإيداع) لأنه بيان طباعة للعدد لا من نص القرار؛
-- وبقى توقيع القرار فى المادة 2 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- أُبقيت كتابة الأصل كما طُبعت ("ويلغى كل حكم يخالفه ." بمسافة قبل النقطة، والفاصلة المنقوطة كما وردت)؛ لم يُعدَّل لفظ واحد. الأرقام لاتينية، والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل،
-- وضُبطت المسافات حول الفاصلة والفاصلة المنقوطة (" ، " و" ؛ ").
-- المبلغ مكتوب بالحروف فقط فى الأصل ("ثلاثمائة واثنى عشر ألفًا وخمسمائة جنيه"، أى 312500 جنيه) ولا رقم فيه؛ نُقل كما طُبع ولم يُضف رقماً.
-- قوبل النص المُدخَل بصورة الصفحة مباشرةً (فالصفحة قصيرة) وبمخرجات OCR مستقلة (tesseract ara): ترتيب أسطر OCR مختلط فى هذه الصفحة وأسقط المادة الثانية، فاعتُمدت قراءة النص على الصورة فوُجد مطابقاً لفظاً بلفظ.
--
-- ===== الهيكل =====
-- 3 صفوف، 3 نسخ (version_no = 1): ديباجة (article_no = 0) بالاطلاعات الثلاثة (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024، والقرار 268 لسنة 2024 المعدَّل حده الأقصى)
-- وموافقة مجلس الإدارة بجلسته بتاريخ 2025/1/28؛ ثم المادتان 1 و2 بأرقامهما الأصلية بلا عناوين كما فى الأصل ("المادة الأولى" و"المادة الثانية")، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 و2 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-02-07: المادة 2 تعمل بالقرار "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 30 (تابع) بتاريخ 2025/2/6 (ثابت بترويسة الصفحة وبذيل الطباعة). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 2 تنص على "ويُلغى كل حكم يخالفه"، وهو إلغاء ضمنى عام لا يسمّى قراراً؛ والقرار يرفع الحد الذى قرره القرار 268 لسنة 2024. هذه الهجرة تنقل النص كما نُشر ولا تعدّله ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (3 صفوف بديباجة سليمة والمادة 2 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو شظية علامة مائية أو ترويسة أو ذيل طباعة، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 658 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix169$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 18 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[169] القرار 18/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 3
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[169] القرار 18/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[169] أُزيلت % مادة من القرار 18/2025 (نص مخزَّن ملوَّث بحروف تالفة وترويسة طباعة وبلا ديباجة)', v_n;
  END IF;
END
$fix169$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 18 لسنة 2025 (منشور بالوقائع المصرية العدد 30 تابع فى 2025/2/6) بشأن زيادة الحد الأقصى للتغطية التأمينية لنشاط التأمين متناهى الصغر$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 268 لسنة 2024 بشأن زيادة الحد الأقصى للتغطية التأمينية لنشاط التأمين متناهى الصغر ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/1/28 ؛$b0_0$
  FROM laws WHERE law_no = 18 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-07', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$يزاد الحد الأقصى للتغطية التأمينية لنشاط التأمين متناهى الصغر ليصبح ثلاثمائة واثنى عشر ألفًا وخمسمائة جنيه .$b1_0$
  FROM laws WHERE law_no = 18 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-07', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية ، ويلغى كل حكم يخالفه .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b2_0$
  FROM laws WHERE law_no = 18 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-07', 'active' FROM ins2_0;

DO $verify169$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 18 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[169] القرار 18/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 3 THEN RAISE EXCEPTION '[169] عدد المواد % بدل 3', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-02-07';
  IF v_v <> 3 THEN RAISE EXCEPTION '[169] عدد النسخ % بدل 3', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%العدد 30%' OR body LIKE '%فبراير سنة 2025%' OR body LIKE '%صورة إ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ل تداول%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%طبعت بالهيئة%' OR body LIKE '%رقم الإيداع%' OR body LIKE '%أشرف%' OR body LIKE '%25589%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[169] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%ته المنعقدة بتاريخ 2025/1/28 ؛' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%رقم 268 لسنة 2024%' AND body LIKE '%بتاريخ 2025/1/28 ؛%') THEN RAISE EXCEPTION '[169] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يزاد الحد الأقصى للتغطية التأمينية لنشاط التأ%' AND body LIKE '%اثنى عشر ألفًا وخمسمائة جنيه .' AND body LIKE '%ثلاثمائة واثنى عشر ألفًا وخمسمائة جنيه .%') THEN RAISE EXCEPTION '[169] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويلغى كل حكم يخالفه .%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[169] المادة 2 غير سليم'; END IF;
  IF v_len <> 658 THEN RAISE EXCEPTION '[169] إجمالى طول المواد % بدل 658', v_len; END IF;
  RAISE NOTICE '[169] القرار 18/2025: 3 مواد و3 نسخ، إجمالى % حرف', v_len;
END
$verify169$;

COMMIT;
