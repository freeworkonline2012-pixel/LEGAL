-- 184_replace_decision_897_2026_car_insurance_depreciation_rates_amendment_of_1052_2019_ocr_corrupted_without_preamble_with_printer_block_and_4_articles.sql
--
-- إعادة رفع قرار رئيس الهيئة العامة للرقابة المالية رقم (897) لسنة 2026 بتعديل القرار رقم (1052) لسنة 2019 بشأن ضوابط تحديد نسب الاستهلاك لتأمينات السيارات،
-- المنشور بالوقائع المصرية، العدد 72 تابع (هـ)، فى أول أبريل 2026 (الصفحتان 5 و6): ديباجة وأربع مواد، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية OCR) =====
-- مخزَّن بالبذور (4 صفوف، 1901 حرفاً) ناتج عن OCR رديء للصورة الممسوحة، وبه:
-- (1) كلمات وأرقام مشوهة فى مواضع جوهرية: رقم القرار المعدَّل وسنته ("رقن ١.55” لسنة 5١١9" بدل "رقم 1052 لسنة 2019" فى المادة 1، و"٠١517 لسنة ٠١١5" فى المادة 2)، وجدول النسب مشوه ("5 (اثنان ونص ف ,تالمائة)")، وكلمات مثل "بنمن" و"مطالببات" و"السيازات" و"وجكعيات" و"الوقسائع" و"تاراييخ" و"الالكترونياللهيئة"، وأقواس مبتورة وعلامات غريبة، وكلمات ملتصقة ("مجلسبإدارة" و"العامةإللرقابةالمالية");
-- (2) بقايا الصفحة الأخيرة المطبوعة داخل المادة 4: "طبعت بالهيئة العامة لشئون المطابع الأميرية / رئيس مجلس الإدارة / محاسب/ أشرف إمام عبد السلام / رقم الإيداع بدار الكتب ..." وأرقام الإيداع والتاريخ المشوهة، وهى بيانات طباعة لا من نص القرار؛
-- (3) بلا ديباجة (ثلاثة اطلاعات وعرض نائب رئيس الهيئة المشرف على قطاع التأمين) وبلا عنوان القرار وتاريخه (2026/3/30) وبيان نشره بالوقائع، وبلا عناوين المواد؛
-- (4) نهايات أسطر CRLF، وبلا تاريخ سريان فعلى (التاريخ المخزَّن 2026-10-09 تاريخ تشغيل البذر لا تاريخ سريان).
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى ولا لإدخاله إلى سياق نموذج اللغة: جدول نسب الاستهلاك، وهو جوهر القرار، مشوه.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحتان، 1.2 ميجابايت) قدّمه صاحب المشروع؛ هو صورة ممسوحة (200 نقطة للبوصة) بلا طبقة نص وعليها علامة مائية قطرية، فلا استخراج آلى من طبقة النص.
-- قُرئ النص من صورتى الصفحتين مباشرةً: بعد استخراج الصورتين الأصليتين قُطّعتا إلى مقاطع وقُرئ كل مقطع بصرياً، وكُبّرت أسطر الأرقام (رقم القرار وتاريخه والاطلاعات والجدول) ضعفين وقُرئت رقماً رقماً.
-- ثم قوبل النص المقروء بمخرجات OCR مستقل (tesseract ara) على الصورتين، فلم يظهر فرق فى لفظ غير ضجيج التعرف (الأرقام الهندية والعلامة المائية وخلط الحروف المتشابهة)، فالأرقام مصدرها القراءة البصرية المكبّرة لا الـOCR.
-- حُذفت ترويسة الصفحتين ("الوقائع المصرية - العدد 72 تابع (هـ) فى أول أبريل سنة 2026" ورقم الصفحة) وسطر "الهيئة العامة للرقابة المالية" وسطر جهة الإصدار "رئيس مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى عنوان القرار وكلمة "قـــرر"، وكتلة الطباعة الأخيرة (المطابع الأميرية، ورقم الإيداع). وعنوان القرار وتاريخه وبيان نشره بالوقائع فى hierarchical_location للديباجة.
-- المواد بلا عنوان وسطى فى الأصل فعناوينها "المادة الأولى" إلى "المادة الرابعة". التوقيع باقٍ فى المادة 4 كما طُبع فى ثلاثة أسطر ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د/ إسلام عبد العظيم عزام").
-- عنوان "(نسب الاستهلاك)" فى المادة 1 و"(نسبة الخصم المرتبط بعدم تسليم العملاء لقطع الغيار التي تم تغييرها أو استبدالها)" فى المادة 2 من متن النص المستبدَل (عنوان المادة المعدَّلة فى القرار 1052) فبقيا فى متن المادتين بين قوسين كما طُبعا.
-- الجدول (سنة الموديل | نسبة الاستهلاك) مكتوب فى المتن سطراً لكل صف بفاصل " | " بين الخليتين، بترتيب القراءة: الخلية اليمنى (البيان) ثم اليسرى (النسبة). ثمانية صفوف بعد صف الترويسة.
-- لا تعديل على لفظ المطبوع. أُبقيت كتابته بلا تعديل: "أقصي" بالياء فى المادة 1، و"خمسة عشرة بالمائة" (والصواب "خمسة عشر") و"اقصى" بلا همزة فى صف الكاوتش والبطاريات، و"أوترميل" متصلة، و"في" و"التي" بالياء، و"الالكتروني" بلا همزة، وتقديم المسافة قبل النقطة. كُتب تنوين "وفقًا" على الحرف السابق للألف بالصيغة المعتمدة فى باقى الهجرات (المطبوع يضعه فوق الألف).
-- الأرقام لاتينية (المطبوعة هندية) والنسبة المئوية "%" (المطبوعة "٪")، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛").
--
-- ===== الهيكل =====
-- 5 صفوف، 5 نسخ (version_no = 1): ديباجة (article_no = 0) بثلاثة اطلاعات (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024، وقرار رئيس الهيئة 1052 لسنة 2019) وعرض نائب رئيس الهيئة المشرف على قطاع التأمين؛ ثم المواد 1 و2 و3 و4 بأرقامها الأصلية، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 إلى 4 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2026-04-02: المادة 4 تنص على العمل به "من اليوم التالى لتاريخ نشره" ونُشر بالوقائع فى 2026/4/1 (ثابت بترويسة الصفحتين). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- مهلة المادة 3 (ستة أشهر لتعديل نماذج وثائق تأمين السيارات من تاريخ العمل) انقضت فى 2026/10/2 بحساب ستة أشهر من 2026/4/2؛ وهذه الهجرة تنقل النص كما نُشر ولا تعدّل بيانات laws.
-- القرار صادر من رئيس الهيئة لا من مجلس الإدارة، وkind فى laws = board_decision كما فى بقية الهجرات؛ ولم تُعدَّل بيانات laws (لا العنوان ولا النوع) فى هذه الهجرة.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (5 صفوف بديباجة سليمة والمادة 4 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 2004 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix184$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 897 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[184] القرار 897/2026 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 5
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[184] القرار 897/2026 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[184] أُزيلت % مادة من القرار 897/2026 (نص مخزَّن ملوَّث بأخطاء OCR وبلا ديباجة وبه بيانات الطباعة وإيداع الكتب)', v_n;
  END IF;
END
$fix184$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار رئيس الهيئة العامة للرقابة المالية رقم 897 لسنة 2026 بتاريخ 2026/3/30 (منشور بالوقائع المصرية العدد 72 تابع (هـ) فى 2026/4/1) بتعديل القرار رقم 1052 لسنة 2019 بشأن ضوابط تحديد نسب الاستهلاك لتأمينات السيارات$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار رئيس الهيئة رقم 1052 لسنة 2019 بشأن ضوابط تحديد نسب الاستهلاك لتأمينات السيارات ؛
وعلى ما عرضه نائب رئيس الهيئة المشرف على قطاع التأمين ؛$b0_0$
  FROM laws WHERE law_no = 897 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-02', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$يستبدل بنص المادة الثانية من قرار رئيس الهيئة رقم 1052 لسنة 2019 المشار إليه ، النص التالى :
(نسب الاستهلاك)
تلتزم شركات وجمعيات التأمين المرخص لها بممارسة فرع تأمين السيارات بخصم قيم نسب الاستهلاك بحد أقصي من مقايسة إصلاح السيارات التي تعرضت لحوادث ، وذلك وفقًا للمقرر بالجدول الآتي :
سنة الموديل | نسبة الاستهلاك
السنة الأولى | 2,5% (اثنان ونصف بالمائة)
السنة الثانية | 5% (خمسة بالمائة)
السنة الثالثة | 10% (عشرة بالمائة)
السنة الرابعة | 15% (خمسة عشرة بالمائة)
السنة الخامسة وما بعدها | 20% (عشرون بالمائة)
الكاوتش والبطاريات | 25% (خمسة وعشرون بالمائة) للسنة الأولى مع العلم أن الحد الأقصى لاستهلاك سنتين بحد اقصى 50% (خمسون بالمائة)
في حالة وجود بارومة | 50% (خمسون بالمائة) للجزء الذي به بارومة
صنفرة أوترميل الزجاج من أثر الطريق | 50% (خمسون بالمائة)$b1_0$
  FROM laws WHERE law_no = 897 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-02', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$يستبدل بنص المادة الثالثة من قرار رئيس الهيئة رقم 1052 لسنة 2019 المشار إليه ، النص التالى :
(نسبة الخصم المرتبط بعدم تسليم العملاء لقطع الغيار التي تم تغييرها أو استبدالها)
يجوز لشركات وجمعيات التأمين المخاطبة بهذا القرار عند تنفيذ مطالبات إصلاح السيارات التي تعرضت لحوادث بأن تطلب من عملاءها مقدمي تلك المطالبات تسليم أجزاء السيارات - قطع الغيار - التالفة ، ويتم تطبيق نسبة الخصم المنصوص عليها في الوثيقة حالة تعذر تسليم الأجزاء أو قطع الغيار التالفة لأى سبب من الأسباب .$b2_0$
  FROM laws WHERE law_no = 897 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-02', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$وبمراعاة ما تقدم من ضوابط تلتزم شركات وجمعيات التأمين المرخص لها بممارسة فرع تأمين السيارات بتعديل نماذج وثائق تأمين السيارات التي تصدر عنها بما يتفق مع ما تضمنه هذا القرار من ضوابط ، وذلك خلال مدة لا تجاوز ستة أشهر من تاريخ العمل بأحكام هذا القرار .$b3_0$
  FROM laws WHERE law_no = 897 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-02', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة$t4_0$, $b4_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الالكتروني للهيئة ، وعلى جميع شركات التأمين الالتزام به ، ويعمل به من اليوم التالي لتاريخ نشره .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د/ إسلام عبد العظيم عزام$b4_0$
  FROM laws WHERE law_no = 897 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-02', 'active' FROM ins4_0;

DO $verify184$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 897 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[184] القرار 897/2026 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 5 THEN RAISE EXCEPTION '[184] عدد المواد % بدل 5', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2026-04-02';
  IF v_v <> 5 THEN RAISE EXCEPTION '[184] عدد النسخ % بدل 5', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%نمن_%' OR body LIKE '%قرار رئيس الهيئة رقن%' OR body LIKE '%تالمائة%' OR body LIKE '%نص ف%' OR body LIKE '%مطالببات%' OR body LIKE '%السيازات%' OR body LIKE '%وجكعيات%' OR body LIKE '%الوقسائع%' OR body LIKE '%الالكترونياللهيئة%' OR body LIKE '%تاراييخ%' OR body LIKE '%مجلسبإدارة%' OR body LIKE '%العامةإللرقابة%' OR body LIKE '%طبعت%' OR body LIKE '%أشرف%' OR body LIKE '%رقم الإيداع%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%���%' OR body LIKE '%٪%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%(المادة%' OR body LIKE '%«%' OR body LIKE '%#%' OR body LIKE '%©%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[184] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%هيئة المشرف على قطاع التأمين ؛' AND body LIKE '%رقم 10 لسنة 2009 بتنظيم الرقابة%' AND body LIKE '%رقم 155 لسنة 2024 ؛%' AND body LIKE '%رقم 1052 لسنة 2019 بشأن ضوابط تحديد نسب الاستهلاك لتأمينات السيارات ؛%' AND body LIKE '%نائب رئيس الهيئة المشرف على قطاع التأمين ؛') THEN RAISE EXCEPTION '[184] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يستبدل بنص المادة الثانية من قرار رئيس الهيئة%' AND body LIKE '%ر الطريق | 50% (خمسون بالمائة)' AND body LIKE '%رقم 1052 لسنة 2019 المشار إليه ، النص التالى :%' AND body LIKE '%السنة الأولى | 2,5_ (اثنان ونصف بالمائة)%' AND body LIKE '%السنة الثانية | 5_ (خمسة بالمائة)%' AND body LIKE '%السنة الثالثة | 10_ (عشرة بالمائة)%' AND body LIKE '%السنة الرابعة | 15_ (خمسة عشرة بالمائة)%' AND body LIKE '%السنة الخامسة وما بعدها | 20_ (عشرون بالمائة)%' AND body LIKE '%25_ (خمسة وعشرون بالمائة) للسنة الأولى%بحد اقصى 50_ (خمسون بالمائة)%' AND body LIKE '%للجزء الذي به بارومة%' AND body LIKE '%من أثر الطريق | 50_ (خمسون بالمائة)') THEN RAISE EXCEPTION '[184] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يستبدل بنص المادة الثالثة من قرار رئيس الهيئة%' AND body LIKE '%ر التالفة لأى سبب من الأسباب .' AND body LIKE '%المادة الثالثة من قرار رئيس الهيئة رقم 1052 لسنة 2019%' AND body LIKE '%تسليم أجزاء السيارات - قطع الغيار - التالفة%' AND body LIKE '%لأى سبب من الأسباب .') THEN RAISE EXCEPTION '[184] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'وبمراعاة ما تقدم من ضوابط تلتزم شركات وجمعيات%' AND body LIKE '%اريخ العمل بأحكام هذا القرار .' AND body LIKE '%خلال مدة لا تجاوز ستة أشهر من تاريخ العمل بأحكام هذا القرار .') THEN RAISE EXCEPTION '[184] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية وعلى الموق%' AND body LIKE '%د/ إسلام عبد العظيم عزام' AND body LIKE '%ويعمل به من اليوم التالي لتاريخ نشره .%' AND body LIKE '%د/ إسلام عبد العظيم عزام') THEN RAISE EXCEPTION '[184] المادة 4 غير سليم'; END IF;
  IF v_len <> 2004 THEN RAISE EXCEPTION '[184] إجمالى طول المواد % بدل 2004', v_len; END IF;
  RAISE NOTICE '[184] القرار 897/2026: 5 مواد و5 نسخ، إجمالى % حرف', v_len;
END
$verify184$;

COMMIT;
