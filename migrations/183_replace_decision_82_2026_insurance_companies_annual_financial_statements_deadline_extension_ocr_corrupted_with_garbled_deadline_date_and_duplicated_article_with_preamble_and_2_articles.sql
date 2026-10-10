-- 183_replace_decision_82_2026_insurance_companies_annual_financial_statements_deadline_extension_ocr_corrupted_with_garbled_deadline_date_and_duplicated_article_with_preamble_and_2_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (82) لسنة 2026 بشأن مد مدة عرض القوائم المالية السنوية للشركات التى تزاول نشاط التأمين ومجمعات التأمين،
-- المنشور بالوقائع المصرية، العدد 72 تابع (هـ)، فى أول أبريل 2026 (الصفحتان 3 و4): ديباجة ومادتان، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية OCR) =====
-- مخزَّن بالبذور (صفان، 626 حرفاً) ناتج عن OCR رديء للصورة الممسوحة، وبه:
-- (1) كلمات مشوهة بحروف زائدة وبديلة ("عرزاض" بدل "عرض"، و"المناليّة" بدل "المالية"، و"التأميّن"، و"متواقب" بدل "مراقب"، و"مجلين" بدل "مجلس"، و"المصضرية"، و"المؤقع" بدل "الموقع"، و"الالكترونئ"، و"ويغلى")، ورموز غريبة ("«" و"#" و"©")،
--     وأقواس مبتورة وملتصقة ("زالمادة الثانية)")، وكلمات ملتصقة ("رئيسيمجلسن" و"العامةاللرقابة")؛
-- (2) تاريخ الموعد النهائى وهو جوهر القرار مشوه بما لا يُقرأ ("©(/ه/" 707" بدل 2026/5/15)، وتاريخ نهاية السنة المالية مشوه ("٠١75/١5/8١" بدل 2025/12/31)؛
-- (3) تكرار: المادة 1 المخزَّنة تحوى فى آخرها عنوان المادة 2 ونصها والتوقيع كاملةً (171 حرفاً)، ثم المادة 2 المخزَّنة نسخة منها مرة ثانية؛
-- (4) بلا ديباجة (ستة اطلاعات وموافقة مجلس إدارة الهيئة بتاريخ 2026/3/31) وبلا تاريخ سريان (التاريخ المخزَّن تاريخ تشغيل البذر).
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى ولا لإدخاله إلى سياق نموذج اللغة: موعد 2026/5/15 هو مضمون القرار كله وهو مفقود.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحتان، 949 كيلوبايت) قدّمه صاحب المشروع؛ هو صورة ممسوحة (200 نقطة للبوصة) بلا طبقة نص وعليها علامة مائية قطرية ("صورة إلكترونية لا يعتد بها عند التداول")، فلا استخراج آلى من طبقة النص.
-- قُرئ النص من صورتى الصفحتين مباشرةً: بعد استخراج الصورتين الأصليتين قُطّعتا إلى مقاطع وقُرئ كل مقطع بصرياً، وكُبّرت أسطر الأرقام (الاطلاعات والتواريخ والتوقيع) ضعفين وقُرئت رقماً رقماً.
-- ثم قوبل النص المقروء بمخرجات OCR مستقل (tesseract ara) على الصورتين، فلم يبق فرق فى لفظ غير ضجيج التعرف (الأرقام الهندية والعلامة المائية وخلط الحروف المتشابهة)، أى أن الأرقام مصدرها القراءة البصرية المكبّرة لا الـOCR.
-- حُذفت ترويسة الصفحتين ("الوقائع المصرية - العدد 72 تابع (هـ) فى أول أبريل سنة 2026" ورقم الصفحة) وكلمة "قــرارات" وسطر "الهيئة العامة للرقابة المالية" وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة.
-- المادتان بلا عنوان فى الأصل فعنوانهما "المادة الأولى" و"المادة الثانية". التوقيع باقٍ فى المادة 2 كما طُبع فى ثلاثة أسطر ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د/ إسلام عبد العظيم عزام").
-- لا تعديل على لفظ المطبوع. أُبقيت كتابته بلا تعديل: "في" و"التي" بالياء، و"الالكتروني" بلا همزة، وتقديم المسافة قبل النقطة فى آخر المادة 2 ("أحكامه ."). كُتب تنوين "مرفقًا" على الحرف السابق للألف بالصيغة المعتمدة فى باقى الهجرات (المطبوع يضعه فوق الألف).
-- الأرقام لاتينية (المطبوعة هندية)، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛").
--
-- ===== الهيكل =====
-- 3 صفوف، 3 نسخ (version_no = 1): ديباجة (article_no = 0) بستة اطلاعات (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024، وقرارات مجلس إدارة الهيئة 11 لسنة 2014 و183 لسنة 2024 و3 لسنة 2025 و38 لسنة 2026)
-- وموافقة مجلس إدارة الهيئة بتاريخ 2026/3/31؛ ثم المادتان 1 و2 بأرقامهما الأصلية، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 و2 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2026-04-01 (تاريخ نشر القرار بالعدد 72 تابع (هـ)، ثابت بترويسة الصفحتين): تاريخ معلن. القرار بلا بند للعمل به، فالمادة 2 تنص على النشر وإلغاء المخالف فقط، فلم يُفترض يوم بعد النشر؛
-- ويُراجع المراجع القانونى هذا التاريخ. كان القديم تاريخ تشغيل البذر لا تاريخ سريان. (الموعد الجديد 2026/5/15 مذكور فى متن المادة 1؛ وهذه الهجرة تنقل النص كما نُشر ولا تعدّل بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (3 صفوف بديباجة سليمة والمادة 2 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 1118 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix183$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 82 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[183] القرار 82/2026 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 3
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[183] القرار 82/2026 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[183] أُزيلت % مادة من القرار 82/2026 (نص مخزَّن ملوَّث بأخطاء OCR وتاريخ مبهم ومادة مكررة وبلا ديباجة)', v_n;
  END IF;
END
$fix183$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 82 لسنة 2026 (منشور بالوقائع المصرية العدد 72 تابع (هـ) فى 2026/4/1) بشأن مد مدة عرض القوائم المالية السنوية للشركات التى تزاول نشاط التأمين ومجمعات التأمين$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 11 لسنة 2014 بشأن قواعد قيد وشطب الأوراق المالية بالبورصة المصرية ؛
وعلى قرار مجلس إدارة الهيئة رقم 183 لسنة 2024 بشأن تحديد موعد بداية ونهاية السنة المالية لشركات التأمين وإعادة التأمين ؛
وعلى قرار مجلس إدارة الهيئة رقم 3 لسنة 2025 بشأن مواعيد إعداد وعرض القوائم المالية للشركات التي تزاول نشاط التأمين ومجمعات التأمين ؛
وعلى قرار مجلس إدارة الهيئة رقم 38 لسنة 2026 بشأن مد مدة عرض القوائم المالية السنوية للشركات التي تزاول نشاط التأمين ومجمعات التأمين ؛
وبعد موافقة مجلس إدارة الهيئة بتاريخ 2026/3/31 ؛$b0_0$
  FROM laws WHERE law_no = 82 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-01', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$تمد مدة عرض القوائم المالية السنوية على الجمعية العامة للشركات التي تزاول نشاط التأمين ومجمعات التأمين عن السنة المالية المنتهية في 2025/12/31 والإفصاحات المرفقة بها وتقرير مراقب الحسابات بشأنها مرفقًا به تقرير مجلس الإدارة لتكون في موعد غايته 2026/5/15.$b1_0$
  FROM laws WHERE law_no = 82 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-01', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الالكتروني للهيئة ، ويلغى كل حكم يخالف أحكامه .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د/ إسلام عبد العظيم عزام$b2_0$
  FROM laws WHERE law_no = 82 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-01', 'active' FROM ins2_0;

DO $verify183$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 82 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[183] القرار 82/2026 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 3 THEN RAISE EXCEPTION '[183] عدد المواد % بدل 3', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2026-04-01';
  IF v_v <> 3 THEN RAISE EXCEPTION '[183] عدد النسخ % بدل 3', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%عرزاض%' OR body LIKE '%المناليّة%' OR body LIKE '%متواقب%' OR body LIKE '%مجلين%' OR body LIKE '%المصضرية%' OR body LIKE '%ويغلى%' OR body LIKE '%المؤقع%' OR body LIKE '%الالكترونئ%' OR body LIKE '%رئيسيمجلسن%' OR body LIKE '%العامةاللرقابة%' OR body LIKE '%«%' OR body LIKE '%#%' OR body LIKE '%©%' OR body LIKE '%٠١%' OR body LIKE '%707%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%الوقائع املصرية%' OR body LIKE '%املصرية%' OR body LIKE '%أبريل سنة 2026%' OR body LIKE '%صورة إ%' OR body LIKE '%ل تداول%' OR body LIKE '%���%' OR body LIKE '% ً%' OR body LIKE '%( )%' OR body LIKE '%٪%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%ال يقل%' OR body LIKE '%(المادة%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[183] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%دارة الهيئة بتاريخ 2026/3/31 ؛' AND body LIKE '%رقم 10 لسنة 2009 بتنظيم الرقابة%' AND body LIKE '%رقم 155 لسنة 2024 ؛%' AND body LIKE '%رقم 11 لسنة 2014 بشأن قواعد قيد وشطب الأوراق المالية بالبورصة المصرية ؛%' AND body LIKE '%رقم 183 لسنة 2024 بشأن تحديد موعد بداية ونهاية السنة المالية%' AND body LIKE '%رقم 3 لسنة 2025 بشأن مواعيد إعداد وعرض القوائم المالية%' AND body LIKE '%رقم 38 لسنة 2026 بشأن مد مدة عرض القوائم المالية السنوية%' AND body LIKE '%بتاريخ 2026/3/31 ؛') THEN RAISE EXCEPTION '[183] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تمد مدة عرض القوائم المالية السنوية على الجمع%' AND body LIKE '%لتكون في موعد غايته 2026/5/15.' AND body LIKE '%المنتهية في 2025/12/31 والإفصاحات المرفقة بها%' AND body LIKE '%وتقرير مراقب الحسابات بشأنها مرفقًا به تقرير مجلس الإدارة%' AND body LIKE '%لتكون في موعد غايته 2026/5/15.') THEN RAISE EXCEPTION '[183] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية وعلى الموق%' AND body LIKE '%د/ إسلام عبد العظيم عزام' AND body LIKE '%على الموقع الالكتروني للهيئة ، ويلغى كل حكم يخالف أحكامه .%' AND body LIKE '%د/ إسلام عبد العظيم عزام') THEN RAISE EXCEPTION '[183] المادة 2 غير سليم'; END IF;
  IF v_len <> 1118 THEN RAISE EXCEPTION '[183] إجمالى طول المواد % بدل 1118', v_len; END IF;
  RAISE NOTICE '[183] القرار 82/2026: 3 مواد و3 نسخ، إجمالى % حرف', v_len;
END
$verify183$;

COMMIT;
