-- 174_replace_decision_271_2025_government_fund_compensation_required_documents_polluted_with_watermark_and_page_headers_with_preamble_and_6_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (271) لسنة 2025 بشأن تحديد المستندات اللازمة لصرف التعويض من الصندوق الحكومى لتغطية الأضرار الناتجة عن حوادث مركبات النقل السريع،
-- المنشور بالوقائع المصرية، العدد 271 (تابع - ب)، فى 2 ديسمبر 2025 (الصفحات 21 إلى 23): ديباجة و6 مواد، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (6 صفوف، 2621 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) شظايا نص العلامة المائية القطرية للوقائع ("صورة إ" و"لك" و"تروني" و"ة ال يع" و"تد بها" و"عند ا" و"ل" و"تداول") فى خمسة صفوف (1 و2 و3 و5 و6) تتخلل الجمل والبنود وتقطعها، حتى فى بند التوقيع؛
-- (2) ترويستا صفحتين للوقائع ("الوقائع المصرية - العدد 271 تابع (ب) فى 2 ديسمبر سنة 2025" برقم الصفحة 22 و23) داخل المادتين 1 و3؛
-- (3) عناوين المواد 1 إلى 4 داخل متن كل مادة، لا فى حقل العنوان؛
-- (4) حروف اللام ألف مقلوبة الترتيب ("احلاالت" و"األضرار" و"اآلتية") وحروف مبعثرة ("التأمني" بدل "التأمين" فى مواضع، و"املستندات" و"احلكومى")، وبقايا تطويل تالفة (U+FFFD، 75 حرفاً)، وتنوين مفصول ("مرف ًقا" و"موضحا ... ً")، و60 فاصل CRLF داخل الجمل، وأرقام بنود معكوسة ("- 1صورة")، وأرقام هندية وفارسية، والتوقيع مبعثراً ("د .محمد فريد صالح");
-- (5) بلا ديباجة (ثلاثة اطلاعات وموافقة مجلس الإدارة بجلسة 2025/11/5) ولا تاريخ سريان.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: شظايا العلامة المائية وترويسات الصفحات تقطع قائمة المستندات المطلوبة وتُنتج جواباً مشوَّهاً عن "ما المستندات اللازمة لصرف التعويض".
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (3 صفحات، 132 كيلوبايت) قدّمه صاحب المشروع؛ وفيه علامة مائية قطرية مرسومة بخط مستقل (AhabHeadline) فاستُبعدت حروف ذلك الخط من الاستخراج.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات والبنود بإحداثيات الأسطر. وطُبّقت قاعدة عرض الحرف لعيبى الترميز المعروفين فى خط هذه الوقائع («ين» النهائى المتصل و«لأ» المتصل) على كل صفحة.
-- حُذفت ترويسة كل صفحة ورقمها وسطر جهة الإصدار "رئيس مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 6 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- عنوان كل مادة من المواد 1 إلى 4 (سطران متوسطان فى الأصل) فى حقل العنوان بعد "المادة <ترتيبها> - "؛ والمادتان 5 و6 بلا عنوان فى الأصل فعنوانهما "المادة الخامسة" و"المادة السادسة" فقط. البنود تُعرض "N- نص".
-- أُبقيت كتابة الأصل كما طُبعت بلا تعديل لفظ: "للمتوفي" بياء (المادة 2)، و"النيابة الحزبية" (المادة 2 البند 4)، و"قيمه" (المادة 4)،، والمسافة قبل النقطة فى "شهادة الوفاة المميكنة ." و"سارية ." و"له ."،
-- وغياب الفاصلة المنقوطة بعد آخر اطلاع فى الديباجة. الأرقام لاتينية، والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛"). (بعض الفقرات الافتتاحية مطبوعة بخط تحته خط فى الأصل؛ التسطير تنسيق لا نص فلم يُنقل.)
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحات: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام والعناوين وخلط الباء والياء والنون (ومنه "تقديها" و"الانيه" وهما من التعرف لا من الأصل)، وقُرئت صورة الصفحة 2 فصار ما فى النص كما فى الصورة.
--
-- ===== الهيكل =====
-- 7 صفوف، 7 نسخ (version_no = 1): ديباجة (article_no = 0) بثلاثة اطلاعات (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024، وقرار الهيئة المصرية للرقابة على التأمين 345 لسنة 2007) وموافقة مجلس الإدارة بجلسته بتاريخ 2025/11/5؛
-- ثم المواد 1 إلى 6 بأرقامها الأصلية، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 إلى 6 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-12-03: المادة 6 تعمل بالقرار "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 271 (تابع - ب) بتاريخ 2025/12/2 (ثابت بترويسة الصفحات). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 6: "ويلغى كل حكم يخالف أحكام هذا القرار" إلغاء ضمنى عام؛ هذه الهجرة تنقل النص كما نُشر ولا تضيف حالة إلغاء ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (7 صفوف بديباجة سليمة والمادة 6 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو علامة مائية، أو ترويسة صفحة، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 2360 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix174$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[174] القرار 271/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 7
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[174] القرار 271/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[174] أُزيلت % مادة من القرار 271/2025 (نص مخزَّن ملوَّث بعلامة مائية وترويسات صفحات وتلف حروف، وبلا ديباجة)', v_n;
  END IF;
END
$fix174$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 271 لسنة 2025 (منشور بالوقائع المصرية العدد 271 تابع (ب) فى 2025/12/2) بشأن تحديد المستندات اللازمة لصرف التعويض من الصندوق الحكومى لتغطية الأضرار الناتجة عن حوادث مركبات النقل السريع$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار الهيئة المصرية للرقابة على التأمين رقم 345 لسنة 2007 بشأن كيفية وشروط أداء مبالغ التأمين المستحقة وفقًا لأحكام قانون التأمين الإجبارى عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/11/5$b0_0$
  FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - المستندات الواجب تقديمها لصرف التعويض فى جميع الحالات التى يغطيها الصندوق$t1_0$, $b1_0$يجب على المتضرر ممن تتوافر فى شأنه إحدى الحالات التى يغطيها الصندوق الحكومى لتغطية الأضرار الناتجة عن حوادث مركبات النقل السريع أن يتقدم بطلب للصندوق للحصول على التعويض ، مرفقًا به المستندات الآتية :
1- صورة رسمية من محضر الحادث مرفقًا به المستندات ذات الصلة بالحادث.
2- أصل شهادة البيانات للمركبة مرتكبة الحادث أو صورة منها.
3- إقرار من ذوى الشأن بصحة المستندات المقدمة منهم وما يفيد أنه تم تقديمها تحت مسئوليتهم القانونية.
وفى حالة توكيل المضرور أو ورثته إلى شخص آخر فى استلام مبلغ التأمين ، فيجب تقديم توكيل خاص مصدق عليه متضمنًا قيمة مبلغ التأمين وما يخول للوكيل حق استلامه من الصندوق.$b1_0$
  FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - المستندات الواجب تقديمها لصرف التعويض فى حالة الوفاة$t2_0$, $b2_0$يجب تقديم المستندات الآتية لصرف مبلغ التعويض فى حالة الوفاة ، بالإضافة إلى المستندات المشار إليها بالمادة الأولى من هذا القرار :
1- شهادة الوفاة المميكنة .
2- أصل إعلام وراثة للمتوفي .
3- صورة من بطاقة الرقم القومى للورثة البالغين ، سارية .
4- فى حالة وجود قصر للمتوفى يجب تقديم (أصل شهادات ميلاد القصر - أصل قرار الوصاية - إفادة النيابة الحزبية بأرقام حسابات القصر - إفادة بنكية ببيانات الحساب البنكى لتحويل مبلغ التأمين المستحق لهم).$b2_0$
  FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - المستندات الواجب تقديمها لصرف التعويض فى حالة الإصابة التى ينتج عنها عجز كلى أو جزئى مستديم$t3_0$, $b3_0$يجب تقديم المستندات الآتية لصرف مبلغ التعويض فى حالة الإصابة التى ينتج عنها عجز كلى أو جزئى مستديم ، بالإضافة إلى المستندات المشار إليها بالمادة الأولى من هذا القرار :
1- صورة شخصية للمصاب.
2- صورة من بطاقة الرقم القومى للمصاب ، سارية.
3- تقرير الجهة الطبية المختصة موضحًا به توصيف لحالة العجز ونسبته.$b3_0$
  FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - المستندات الواجب تقديمها لصرف التعويض فى حالة الأضرار المادية التى تلحق بالممتلكات$t4_0$, $b4_0$يجب تقديم المستندات الآتية لصرف مبلغ التعويض فى حالة الأضرار المادية التى تلحق بالممتلكات ، بالإضافة إلى المستندات المشار إليها بالمادة الأولى من هذا القرار :
1- صورة رسمية من محضر الحادث.
2- تقرير من الخبير المعاين لتقدير قيمه الأضرار المادية.$b4_0$
  FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$يلتزم الصندوق بالبت فى طلب صرف التعويض خلال شهر على الأكثر من تاريخ تقديمه مستوفيًا المستندات المؤيدة له .$b5_0$
  FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة$t6_0$, $b6_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة والصندوق ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية ، ويلغى كل حكم يخالف أحكام هذا القرار.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b6_0$
  FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins6_0;

DO $verify174$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 271 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[174] القرار 271/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 7 THEN RAISE EXCEPTION '[174] عدد المواد % بدل 7', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-12-03';
  IF v_v <> 7 THEN RAISE EXCEPTION '[174] عدد النسخ % بدل 7', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%العدد 271%' OR body LIKE '%ديسمبر سنة 2025%' OR body LIKE '%صورة إ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ل تداول%' OR body LIKE '%عند ا%' OR body LIKE '%تد بها%' OR body LIKE '%تروني%' OR body LIKE '%ً -%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%التأمن%' OR body LIKE '%البالغن%' OR body LIKE '%المتضررين%' OR body LIKE '%( )%' OR body LIKE '%٪%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[174] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%لسته المنعقدة بتاريخ 2025/11/5' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%رقم 345 لسنة 2007%' AND body LIKE '%مركبات النقل السريع داخل جمهورية مصر العربية ؛%' AND body LIKE '%بتاريخ 2025/11/5') THEN RAISE EXCEPTION '[174] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يجب على المتضرر ممن تتوافر فى شأنه إحدى الحال%' AND body LIKE '%للوكيل حق استلامه من الصندوق.' AND body LIKE '%يغطيها الصندوق الحكومى لتغطية الأضرار الناتجة عن حوادث مركبات النقل السريع%' AND body LIKE '%1- صورة رسمية من محضر الحادث مرفقًا به%' AND body LIKE '%2- أصل شهادة البيانات للمركبة مرتكبة الحادث%' AND body LIKE '%3- إقرار من ذوى الشأن بصحة المستندات المقدمة منهم%' AND body LIKE '%تحت مسئوليتهم القانونية.%' AND body LIKE '%وفى حالة توكيل المضرور أو ورثته%' AND body LIKE '%حق استلامه من الصندوق.%') THEN RAISE EXCEPTION '[174] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يجب تقديم المستندات الآتية لصرف مبلغ التعويض%' AND body LIKE '%ويل مبلغ التأمين المستحق لهم).' AND body LIKE '%1- شهادة الوفاة المميكنة .%' AND body LIKE '%2- أصل إعلام وراثة للمتوفي .%' AND body LIKE '%3- صورة من بطاقة الرقم القومى للورثة البالغين ، سارية .%' AND body LIKE '%4- فى حالة وجود قصر للمتوفى يجب تقديم (أصل شهادات ميلاد القصر - أصل قرار الوصاية - إفادة النيابة الحزبية بأرقام حسابات القصر - إفادة بنكية%' AND body LIKE '%لتحويل مبلغ التأمين المستحق لهم).%') THEN RAISE EXCEPTION '[174] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يجب تقديم المستندات الآتية لصرف مبلغ التعويض%' AND body LIKE '%ا به توصيف لحالة العجز ونسبته.' AND body LIKE '%عجز كلى أو جزئى مستديم%' AND body LIKE '%1- صورة شخصية للمصاب.%' AND body LIKE '%2- صورة من بطاقة الرقم القومى للمصاب ، سارية.%' AND body LIKE '%موضحًا به توصيف لحالة العجز ونسبته.%') THEN RAISE EXCEPTION '[174] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يجب تقديم المستندات الآتية لصرف مبلغ التعويض%' AND body LIKE '%ن لتقدير قيمه الأضرار المادية.' AND body LIKE '%1- صورة رسمية من محضر الحادث.%' AND body LIKE '%لتقدير قيمه الأضرار المادية.%') THEN RAISE EXCEPTION '[174] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يلتزم الصندوق بالبت فى طلب صرف التعويض خلال ش%' AND body LIKE '%ستوفيًا المستندات المؤيدة له .' AND body LIKE '%خلال شهر على الأكثر من تاريخ%' AND body LIKE '%تقديمه مستوفيًا المستندات المؤيدة له .%') THEN RAISE EXCEPTION '[174] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية ،%' AND body LIKE '%ويلغى كل حكم يخالف أحكام هذا القرار.%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[174] المادة 6 غير سليم'; END IF;
  IF v_len <> 2360 THEN RAISE EXCEPTION '[174] إجمالى طول المواد % بدل 2360', v_len; END IF;
  RAISE NOTICE '[174] القرار 271/2025: 7 مواد و7 نسخ، إجمالى % حرف', v_len;
END
$verify174$;

COMMIT;
