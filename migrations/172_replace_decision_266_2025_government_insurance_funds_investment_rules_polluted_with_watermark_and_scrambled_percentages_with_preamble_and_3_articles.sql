-- 172_replace_decision_266_2025_government_insurance_funds_investment_rules_polluted_with_watermark_and_scrambled_percentages_with_preamble_and_3_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (266) لسنة 2025 بشأن قواعد وضوابط استثمار أموال صناديق التأمين الحكومية،
-- المنشور بالوقائع المصرية، العدد 271 (تابع - ب)، فى 2 ديسمبر 2025 (الصفحة 13): ديباجة و3 مواد، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (3 صفوف، 764 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) شظايا نص العلامة المائية القطرية للوقائع ("صورة إ" و"لك" و"تروني" و"ة ال يع" و"تد بها" و"عند ا" و"ل" و"تداول") فى الصفوف الثلاثة تتخلل الجمل وتقطعها؛
-- (2) النسب المئوية — وهى جوهر القرار — مبعثرة: "( )٪٥" و"( )٪۲۰" و"( )٪10" بأقواس فارغة والرقم خارجها، وبأرقام هندية وفارسية ولاتينية معاً، فلا يُعرف الحد الأدنى (5%) ولا الأقصى (20%) ولا سقف الصندوق الواحد (5% و10%) من النص المخزَّن؛
-- (3) حروف اللام ألف مقلوبة الترتيب ("باالستثمار" و"األسهم" و"ال تقل") وحروف مبعثرة ("التأمني احلكومية" و"املقيدة" و"متنح" بدل "تمنح")، وبقايا تطويل تالفة (U+FFFD، 26 حرفاً)، وتنوين مفصول ("وف ًقا")، و18 فاصل CRLF داخل الجمل، والتوقيع مبعثراً ("د .محمد فريد صالح")؛
-- (4) بلا ديباجة (الاطلاعان وموافقة مجلس الإدارة بجلسة 2025/11/5) ولا تاريخ سريان.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: شظايا العلامة المائية تقطع الجمل، وتبعثر النسب المئوية يُنتج جواباً خاطئاً عن سؤال النسب.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحة واحدة، 125 كيلوبايت) قدّمه صاحب المشروع؛ وفيه علامة مائية قطرية مرسومة بخط مستقل (AhabHeadline) فاستُبعدت حروف ذلك الخط من الاستخراج.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات بإحداثيات الأسطر. وعُولج فى هذا الملف عيب ترميز "ين" النهائى المتصل (يُرمَّز "ن" فقط فتضيع الياء) بقاعدة عرض الحرف (4 مواضع، كلها "التأمين")، وتحققتُ منه على صورة الصفحة.
-- حُذفت ترويسة الصفحة ورقمها وسطر جهة الإصدار "رئيس مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 3 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- أُبقيت كتابة الأصل كما طُبعت ("نشر" بلا ضمة فى "ينشر" و"تمنح"، والمسافة قبل النقطة فى آخر المادة 3)؛ لم يُعدَّل لفظ واحد. الأرقام لاتينية والنسبة المئوية بلا مسافات داخل الأقواس ("(5%)" و"(20%)" و"(10%)")،
-- والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والفاصلة المنقوطة (" ، " و" ؛ ").
-- وقرئ على صورة الصفحة ما يلى فصار ما فى النص كما فى الصورة: النسب (5%) و(20%) و(5%) و(10%)، و"مائة مليون جنيه"، وعبارة "أيهما أقل"، ومهلة "ستة أشهر"، والمادة 3 والتوقيع.
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صورة الصفحة: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام والعناوين، وسطر واحد أسقطه التعرف ("اليوم التالى لتاريخ نشره بالوقائع المصرية") قُرئ على الصورة فوُجد كما فى النص.
--
-- ===== الهيكل =====
-- 4 صفوف، 4 نسخ (version_no = 1): ديباجة (article_no = 0) بالاطلاعين (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024) وموافقة مجلس الإدارة بجلسته بتاريخ 2025/11/5؛
-- ثم المواد 1 إلى 3 بأرقامها الأصلية بلا عناوين كما فى الأصل ("المادة الأولى" و"المادة الثانية" و"المادة الثالثة")، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 و2 و3 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-12-03: المادة 3 تعمل بالقرار "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 271 (تابع - ب) بتاريخ 2025/12/2 (ثابت بترويسة الصفحة). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 2 تمنح صناديق التأمين الحكومية ستة أشهر من تاريخ العمل لتوفيق أوضاعها، أى حتى 2026/6/3. هذه الهجرة تنقل النص كما نُشر ولا تعدّله ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (4 صفوف بديباجة سليمة والمادة 3 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو علامة مائية، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 887 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix172$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 266 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[172] القرار 266/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 4
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[172] القرار 266/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[172] أُزيلت % مادة من القرار 266/2025 (نص مخزَّن ملوَّث بعلامة مائية وتلف حروف ونسب مئوية مبعثرة)', v_n;
  END IF;
END
$fix172$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 266 لسنة 2025 (منشور بالوقائع المصرية العدد 271 تابع (ب) فى 2025/12/2) بشأن قواعد وضوابط استثمار أموال صناديق التأمين الحكومية$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/11/5 ؛$b0_0$
  FROM laws WHERE law_no = 266 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$تلتزم صناديق التأمين الحكومية التى يزيد حجم استثماراتها على مائة مليون جنيه بالاستثمار فى وثائق صناديق استثمار مفتوحة فى الأسهم المقيدة بالبورصات المصرية بنسبة لا تقل عن (5%) ولا تزيد على (20%) من جملة أموال الصندوق ، على ألا تزيد قيمة الأموال المستثمرة فى وثائق صندوق الاستثمار الواحد على (5%) من جملة أموال صندوق التأمين أو (10%) من صافى قيمة أصول صندوق الاستثمار أيهما أقل.$b1_0$
  FROM laws WHERE law_no = 266 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$تمنح صناديق التأمين الحكومية مهلة ستة أشهر من تاريخ العمل بهذا القرار لتوفيق أوضاعها وفقًا لأحكامه.$b2_0$
  FROM laws WHERE law_no = 266 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b3_0$
  FROM laws WHERE law_no = 266 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins3_0;

DO $verify172$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 266 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[172] القرار 266/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 4 THEN RAISE EXCEPTION '[172] عدد المواد % بدل 4', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-12-03';
  IF v_v <> 4 THEN RAISE EXCEPTION '[172] عدد النسخ % بدل 4', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%العدد 271%' OR body LIKE '%ديسمبر سنة 2025%' OR body LIKE '%صورة إ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ل تداول%' OR body LIKE '%تد بها%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%التأمن%' OR body LIKE '%( )%' OR body LIKE '%٪%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[172] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%ته المنعقدة بتاريخ 2025/11/5 ؛' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%بتاريخ 2025/11/5 ؛%') THEN RAISE EXCEPTION '[172] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تلتزم صناديق التأمين الحكومية التى يزيد حجم ا%' AND body LIKE '%صول صندوق الاستثمار أيهما أقل.' AND body LIKE '%مائة مليون جنيه%' AND body LIKE '%لا تقل عن (5_) ولا تزيد على (20_) من جملة أموال الصندوق%' AND body LIKE '%على (5_) من جملة أموال صندوق التأمين%' AND body LIKE '%أو (10_) من صافى قيمة أصول صندوق الاستثمار أيهما أقل.%') THEN RAISE EXCEPTION '[172] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'تمنح صناديق التأمين الحكومية مهلة ستة أشهر من%' AND body LIKE '%لتوفيق أوضاعها وفقًا لأحكامه.' AND body LIKE '%مهلة ستة أشهر من تاريخ العمل بهذا القرار%' AND body LIKE '%وفقًا لأحكامه.%') THEN RAISE EXCEPTION '[172] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية .%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[172] المادة 3 غير سليم'; END IF;
  IF v_len <> 887 THEN RAISE EXCEPTION '[172] إجمالى طول المواد % بدل 887', v_len; END IF;
  RAISE NOTICE '[172] القرار 266/2025: 4 مواد و4 نسخ، إجمالى % حرف', v_len;
END
$verify172$;

COMMIT;
