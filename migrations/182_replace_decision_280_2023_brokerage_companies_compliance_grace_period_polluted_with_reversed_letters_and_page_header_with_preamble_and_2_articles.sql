-- 182_replace_decision_280_2023_brokerage_companies_compliance_grace_period_polluted_with_reversed_letters_and_page_header_with_preamble_and_2_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (280) لسنة 2023 بتاريخ 2023/12/27 بشأن منح مهلة لشركات الوساطة فى التأمين للتوافق مع أحكام قرار مجلس إدارة الهيئة رقم 215 لسنة 2023،
-- المنشور بالوقائع المصرية، العدد 18 تابع (ج)، فى 22 يناير 2024 (الصفحتان 3 و4): ديباجة ومادتان، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (صفان، 905 أحرف) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) 30 حرف تلف (U+FFFD) فى الصفين (مكان بقايا التطويل داخل الكلمات: "تس���ويات" و"ينش���ر")؛
-- (2) حروف اللام ألف مقلوبة الترتيب ("ثالثة" بدل "ثلاثة"، و"اإللكترونى")، وتنوين مفصول عن حرفه ("اعتبا ًرا")، وضمة مفصولة ("ُينش���ر"، "و ُيعمل")،
--     و15 فاصل CRLF داخل الجمل، وأرقام القرار وسنته ملتصقة بما بعدها ("رقم 215لسنة" و"2023المشار")، والتوقيع مبعثراً ("د .محمد فريد صالح")؛
-- (3) ترويسة صفحة للوقائع داخل متن المادة 1 ("الوقائع املصرية -العدد 18تابع (ج) فى 22يناير ...") تقطع الفقرة الثانية؛
-- (4) بلا ديباجة (ثلاثة اطلاعات وموافقة مجلس الإدارة بجلسة 2023/12/27) وبلا تاريخ سريان (التاريخ المخزَّن تاريخ تشغيل البذر).
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: القرار قرار مهلة (ثلاثة أشهر من العمل به، وطلب خلال خمسة عشر يوماً، وإمكان المد)، وتشويه "ثلاثة" والرقم 215 يُضعف الاستشهاد.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحتان، 481 كيلوبايت) قدّمه صاحب المشروع (باسم الملف alamiria_2023_280)؛ بملف تالف جدول المراجع (xref) فأُصلح بـqpdf قبل القراءة.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات بإحداثيات الأسطر. وطُبّقت قواعد عرض الحرف لعيوب الترميز المعروفة فى خط هذه الوقائع («ين» النهائى المتصل و«لأ» المتصل و«لا» المتصل) على الصفحتين فلم يلزم تصحيح شىء فى هذا الملف.
-- حُذفت ترويسة كل صفحة ورقمها، وكلمة "قــرارات" وسطر "الهيئة العامة للرقابة المالية" وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار (ومعه سطر "بتاريخ 2023/12/27" كما طُبع) وبيان نشره بالوقائع فى hierarchical_location للديباجة.
-- التوقيع باقٍ فى المادة 2 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح"). المادتان بلا عنوان فى الأصل فعنوانهما "المادة الأولى" و"المادة الثانية". المادة 1 ثلاث فقرات كما طُبعت.
-- لا تعديل على المطبوع. أُبقيت كتابة الأصل بلا تعديل لفظ، ومنها المسافة قبل النقطة فى آخر فقرات المادة 1 ("المشار إليه ." و"لذلك ." و"الشركة ."). الأرقام لاتينية،
-- والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛").
-- قوبل النص المُدخَل بمخرجات OCR مستقل (tesseract ara) على صورتى الصفحتين: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام وخلط الباء والياء والنون، وقُرئت صورة الصفحة 1 فصار ما فى النص كما فى الصورة.
--
-- ===== الهيكل =====
-- 3 صفوف، 3 نسخ (version_no = 1): ديباجة (article_no = 0) بثلاثة اطلاعات (قانون الإشراف والرقابة على التأمين فى مصر 10 لسنة 1981 ولائحته التنفيذية، والقانون 10 لسنة 2009، وقرار مجلس إدارة الهيئة 23 لسنة 2014 المعدل بالقرار 215 لسنة 2023)
-- وموافقة مجلس الإدارة بجلسته بتاريخ 2023/12/27؛ ثم المادتان 1 و2 بأرقامهما الأصلية، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 و2 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2024-01-23: المادة 2 تعمل بالقرار "من اليوم التالى لتاريخ نشره"، ونشره بالعدد 18 تابع (ج) بتاريخ 2024/1/22 (ثابت بترويسة الصفحتين). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المهلة الممنوحة ثلاثة أشهر من تاريخ العمل به فانتهت 2024/4/23، ومدة تقديم الطلب خمسة عشر يوماً فانتهت 2024/2/7، مع جواز مد المهلة للشركات؛ هذه الهجرة تنقل النص كما نُشر ولا تعدّل بيانات laws، ومنها عنوان القانون المخزَّن بالـlaws "بشأن منح مهلة لشركات الوساطة فى التأمين لتوفيق أوضاعها" المختلف لفظياً عن المطبوع.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (3 صفوف بديباجة سليمة والمادة 2 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 1209 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix182$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 280 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[182] القرار 280/2023 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 3
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[182] القرار 280/2023 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[182] أُزيلت % مادة من القرار 280/2023 (نص مخزَّن ملوَّث بتلف حروف وترويسة صفحة داخل المادة وبلا ديباجة)', v_n;
  END IF;
END
$fix182$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 280 لسنة 2023 بتاريخ 2023/12/27 (منشور بالوقائع المصرية العدد 18 تابع (ج) فى 2024/1/22) بشأن منح مهلة لشركات الوساطة فى التأمين للتوافق مع أحكام قرار مجلس إدارة الهيئة رقم 215 لسنة 2023$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون الإشراف والرقابة على التأمين فى مصر الصادر بالقانون رقم 10 لسنة 1981 ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قرار مجلس إدارة الهيئة رقم 23 لسنة 2014 بشأن القواعد الحاكمة لممارسة نشاط وساطة التأمين داخل جمهورية مصر العربية والمعدل بالقرار رقم 215 لسنة 2023 ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة 2023/12/27 ؛$b0_0$
  FROM laws WHERE law_no = 280 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-01-23', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$تمنح شركات الوساطة فى التأمين القائم نموذج أعمالها على استخدام التكنولوجيا ولديها أنظمة تسويات إلكترونية مع شركات التأمين ، مهلة لمدة ثلاثة أشهر اعتبارًا من تاريخ العمل بهذا القرار للتوافق مع أحكام قرار مجلس إدارة الهيئة رقم 215 لسنة 2023 المشار إليه .
وتلتزم الشركات المشار إليها بتقديم طلب للهيئة فى موعد غايته خمسة عشر يومًا من تاريخ العمل بهذا القرار يتضمن المتطلبات والإجراءات التى ستتبعها الشركة للتوافق الكامل مع قرار مجلس إدارة الهيئة رقم 215 لسنة 2023 المشار إليه ، والمدة الزمنية المطلوبة لذلك .
وتقوم الهيئة بدراسة الطلب المشار إليه ، ويجوز لها مد المهلة المذكورة لمدة أخرى إضافية فى ضوء المبررات التى تقدمها الشركة .$b1_0$
  FROM laws WHERE law_no = 280 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-01-23', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$ينشر هذا القرار بالوقائع المصرية ، وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b2_0$
  FROM laws WHERE law_no = 280 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-01-23', 'active' FROM ins2_0;

DO $verify182$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 280 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[182] القرار 280/2023 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 3 THEN RAISE EXCEPTION '[182] عدد المواد % بدل 3', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2024-01-23';
  IF v_v <> 3 THEN RAISE EXCEPTION '[182] عدد النسخ % بدل 3', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع املصرية%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%يناير سنة 2024%' OR body LIKE '%املصرية%' OR body LIKE '%العدد 18%' OR body LIKE '%صورة إ%' OR body LIKE '%ل تداول%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%( )%' OR body LIKE '%٪%' OR body LIKE '%٢٠%' OR body LIKE '%ال يقل%' OR body LIKE '%- 1%' OR body LIKE '%ثالثة%' OR body LIKE '%215لسنة%' OR body LIKE '%2023المشار%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[182] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون الإشراف والرقابة على ال%' AND body LIKE '%ة بجلسته المنعقدة 2023/12/27 ؛' AND body LIKE '%رقم 10 لسنة 1981 ولائحته التنفيذية ؛%' AND body LIKE '%رقم 10 لسنة 2009 بتنظيم الرقابة%' AND body LIKE '%رقم 23 لسنة 2014 بشأن القواعد الحاكمة%' AND body LIKE '%والمعدل بالقرار رقم 215 لسنة 2023 ؛%' AND body LIKE '%بجلسته المنعقدة 2023/12/27 ؛') THEN RAISE EXCEPTION '[182] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تمنح شركات الوساطة فى التأمين القائم نموذج أع%' AND body LIKE '%المبررات التى تقدمها الشركة .' AND body LIKE '%مهلة لمدة ثلاثة أشهر اعتبارًا من تاريخ العمل بهذا القرار%' AND body LIKE '%رقم 215 لسنة 2023 المشار إليه .%' AND body LIKE '%خمسة عشر يومًا من تاريخ العمل بهذا القرار%' AND body LIKE '%والمدة الزمنية المطلوبة لذلك .%' AND body LIKE '%المبررات التى تقدمها الشركة .') THEN RAISE EXCEPTION '[182] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار بالوقائع المصرية ، وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره .%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[182] المادة 2 غير سليم'; END IF;
  IF v_len <> 1209 THEN RAISE EXCEPTION '[182] إجمالى طول المواد % بدل 1209', v_len; END IF;
  RAISE NOTICE '[182] القرار 280/2023: 3 مواد و3 نسخ، إجمالى % حرف', v_len;
END
$verify182$;

COMMIT;
