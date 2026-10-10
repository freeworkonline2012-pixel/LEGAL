-- 175_replace_decision_302_2025_egyptian_pool_compulsory_insurance_payment_terms_polluted_with_page_headers_and_reversed_letters_with_preamble_and_7_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (302) لسنة 2025 بشأن كيفية وشروط أداء مبلغ التأمين من المجمعة المصرية للتأمين الإجبارى عن المسئولية الناشئة عن حوادث مركبات النقل السريع،
-- المنشور بالوقائع المصرية، العدد 295 (تابع)، فى 30 ديسمبر 2025 (الصفحات 15 إلى 17): ديباجة و7 مواد، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (7 صفوف، 2581 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) ترويستا صفحتين للوقائع ("الوقائع المصرية - العدد (295 تابع) فى 30 ديسمبر سنة 2025" برقم الصفحة 16 و17) داخل المادتين 1 و3، تقطع قائمة المستندات المطلوبة؛
-- (2) عناوين المواد 1 إلى 4 داخل متن كل مادة، لا فى حقل العنوان؛
-- (3) حروف اللام ألف مقلوبة الترتيب ("الحاالت" و"اآلتية" و"األضرار" و"اإلجبارى") وبقايا تطويل تالفة (U+FFFD، 81 حرفاً)، وتنوين مفصول ("مرف ًقا" و"موضحا ... ً")، و42 فاصل CRLF داخل الجمل، وأرقام بنود معكوسة ("- 1صورة")، وأرقام هندية وفارسية (فى البنود وفى "٢٠٠٧" بالمادة 6)، والتوقيع مبعثراً ("د .محمد فريد صالح")؛
-- (4) المادة 6 (إلغاء قرار الهيئة المصرية للرقابة على التأمين رقم 345 لسنة 2007) مبعثرة الحروف ("ُيلغ���ى ق���رار الهيئ���ة") وبرقم السنة هندياً؛
-- (5) بلا ديباجة (ثلاثة اطلاعات وموافقة مجلس الإدارة بجلسة 2025/12/10) ولا تاريخ سريان.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: ترويسات الصفحات تقطع قائمة المستندات، وتلف المادة 6 يخفى أن القرار يلغى القرار 345 لسنة 2007.
-- (لا علامة مائية فى النص المخزَّن لهذا القرار، وإن كان فى الـPDF الأصلى خط علامة مائية استُبعد.)
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (3 صفحات، 364 كيلوبايت) قدّمه صاحب المشروع؛ بملف تالف جدول المراجع (xref) فأُصلح بـqpdf قبل القراءة.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات والبنود بإحداثيات الأسطر. وطُبّقت قاعدة عرض الحرف لعيبى الترميز المعروفين فى خط هذه الوقائع («ين» النهائى المتصل و«لأ» المتصل) على كل صفحة.
-- حُذفت ترويسة كل صفحة ورقمها وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 7 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- عنوان كل مادة من المواد 1 إلى 4 (سطران متوسطان فى الأصل) فى حقل العنوان بعد "المادة <ترتيبها> - "؛ والمواد 5 إلى 7 بلا عنوان فى الأصل فعنوانها "المادة الخامسة" و"المادة السادسة" و"المادة السابعة" فقط. البنود تُعرض "N- نص".
-- فى المادة 2 قائمتان مرقَّمتان 1-3 ثم 1-4 تتوسطهما الفقرة "وللمجمعة فى حالة وجود قصر للمتوفى ..."؛ نُقلت كما طُبعت كل بند فى فقرة مستقلة.
-- أُبقيت كتابة الأصل كما طُبعت بلا تعديل لفظ: "للمتوفي" بياء (المادة 2)، و"قيمه" (المادة 4)، والمسافة قبل النقطة فى آخر المادة 7. الأرقام لاتينية، والتنوين فى موضعه كما طُبع، وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" :" و" ؛"). (بعض الفقرات الافتتاحية مطبوعة بخط تحته خط فى الأصل؛ التسطير تنسيق لا نص فلم يُنقل.)
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحات: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام والعناوين وخلط الباء والياء والنون، وقُرئت صورة الصفحة 2 فصار ما فى النص كما فى الصورة.
--
-- ===== الهيكل =====
-- 8 صفوف، 8 نسخ (version_no = 1): ديباجة (article_no = 0) بثلاثة اطلاعات (القانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024، وقرار الهيئة المصرية للرقابة على التأمين 345 لسنة 2007) وموافقة مجلس الإدارة بجلسته بتاريخ 2025/12/10؛
-- ثم المواد 1 إلى 7 بأرقامها الأصلية، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 إلى 7 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-12-31: المادة 7 تعمل بالقرار "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 295 (تابع) بتاريخ 2025/12/30 (ثابت بترويسة الصفحات). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 6 تُلغى صراحةً القرار 345 لسنة 2007. هذه الهجرة تنقل النص كما نُشر ولا تعدّل حالة ذلك القرار فى laws ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (8 صفوف بديباجة سليمة والمادة 7 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو ترويسة صفحة، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 2468 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix175$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[175] القرار 302/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 8
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[175] القرار 302/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[175] أُزيلت % مادة من القرار 302/2025 (نص مخزَّن ملوَّث بترويسات صفحات وتلف حروف، وبلا ديباجة)', v_n;
  END IF;
END
$fix175$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 302 لسنة 2025 (منشور بالوقائع المصرية العدد 295 تابع فى 2025/12/30) بشأن كيفية وشروط أداء مبلغ التأمين من المجمعة المصرية للتأمين الإجبارى عن المسئولية الناشئة عن حوادث مركبات النقل السريع$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار الهيئة المصرية للرقابة على التأمين رقم 345 لسنة 2007 بشأن كيفية وشروط أداء مبالغ التأمين المستحقة وفقًا لأحكام قانون التأمين الإجبارى عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/12/10 ؛$b0_0$
  FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - المستندات الواجب تقديمها لصرف التعويض فى جميع الحالات التى تغطيها المجمعة$t1_0$, $b1_0$يجب على المتضرر ممن تتوافر فى شأنه إحدى الحالات التى تغطيها المجمعة المصرية للتأمين الإجبارى عن المسئولية الناشئة عن حوادث مركبات النقل السريع ، أن يتقدم بطلب للمجمعة للحصول على التعويض ، مرفقًا به المستندات الآتية :
1- صورة رسمية من محضر الحادث مرفقًا به المستندات ذات الصلة بالحادث.
2- إقرار من ذوى الشأن بصحة المستندات المقدمة منهم وما يفيد أنه تم تقديمها تحت مسئوليتهم القانونية.
وفى حال رغبة العميل فى استلام مبلغ التأمين عن طريق التحويلات البنكية على الحسابات الخاصة بالمستفيدين ، يجب إحضار إفادة بنكية بها.
وفى حالة توكيل المضرور أو ورثته إلى شخص آخر فى استلام مبلغ التأمين ، فيجب تقديم توكيل خاص مصدق عليه متضمنًا قيمة مبلغ التأمين وما يخول للوكيل حق استلامه من المجمعة.$b1_0$
  FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - المستندات الواجب تقديمها لصرف التعويض فى حالة الوفاة$t2_0$, $b2_0$يجب تقديم المستندات الآتية لصرف مبلغ التعويض فى حالة الوفاة ، بالإضافة إلى المستندات المشار إليها بالمادة الأولى من هذا القرار :
1- شهادة الوفاة المميكنة.
2- أصل إعلام وراثة للمتوفي.
3- صورة من بطاقة الرقم القومى للورثة البالغين ، سارية.
وللمجمعة فى حالة وجود قصر للمتوفى أن تطلب تقديم المستندات الآتية :
1- أصل شهادات ميلاد القصر.
2- أصل قرار الوصاية.
3- إفادة النيابة الحسبية بأرقام حسابات القصر.
4- إفادة بنكية ببيانات الحساب البنكى لتحويل مبلغ التأمين المستحق لهم.$b2_0$
  FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - المستندات الواجب تقديمها لصرف التعويض فى حالة الإصابة التى ينتج عنها عجز كلى أو جزئى مستديم$t3_0$, $b3_0$يجب تقديم المستندات الآتية لصرف مبلغ التعويض فى حالة الإصابة التى ينتج عنها عجز كلى أو جزئى مستديم ، بالإضافة إلى المستندات المشار إليها بالمادة الأولى من هذا القرار :
1- صورة شخصية للمصاب.
2- صورة من بطاقة الرقم القومى للمصاب ، سارية.
3- تقرير الجهة الطبية المختصة موضحًا به توصيف لحالة العجز ونسبته.$b3_0$
  FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - المستندات الواجب تقديمها لصرف التعويض فى حالة الأضرار المادية التى تلحق بالممتلكات$t4_0$, $b4_0$فى حالة الأضرار المادية التى تلحق بالممتلكات يجب تقديم تقرير من الخبير المعاين لتقدير قيمه الأضرار المادية لصرف مبلغ التعويض بالإضافة إلى المستندات المشار إليها بالمادة الأولى من هذا القرار.$b4_0$
  FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$تلتزم المجمعة بالبت فى طلب صرف التعويض خلال شهر على الأكثر من تاريخ تقديمه مستوفيًا المستندات المؤيدة له.$b5_0$
  FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة$t6_0$, $b6_0$يلغى قرار الهيئة المصرية للرقابة على التأمين رقم 345 لسنة 2007 المشار إليه.$b6_0$
  FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة$t7_0$, $b7_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة والمجمعة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b7_0$
  FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-31', 'active' FROM ins7_0;

DO $verify175$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 302 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[175] القرار 302/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 8 THEN RAISE EXCEPTION '[175] عدد المواد % بدل 8', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-12-31';
  IF v_v <> 8 THEN RAISE EXCEPTION '[175] عدد النسخ % بدل 8', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%العدد 295%' OR body LIKE '%ديسمبر سنة 2025%' OR body LIKE '%صورة إ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ل تداول%' OR body LIKE '%عند ا%' OR body LIKE '%تد بها%' OR body LIKE '%تروني%' OR body LIKE '%ً -%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%التأمن%' OR body LIKE '%البالغن%' OR body LIKE '%المتضررين%' OR body LIKE '%٢٠٠٧%' OR body LIKE '%( )%' OR body LIKE '%٪%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[175] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%ه المنعقدة بتاريخ 2025/12/10 ؛' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%رقم 345 لسنة 2007%' AND body LIKE '%مركبات النقل السريع داخل جمهورية مصر العربية ؛%' AND body LIKE '%بتاريخ 2025/12/10 ؛') THEN RAISE EXCEPTION '[175] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يجب على المتضرر ممن تتوافر فى شأنه إحدى الحال%' AND body LIKE '%للوكيل حق استلامه من المجمعة.' AND body LIKE '%المجمعة المصرية للتأمين الإجبارى عن المسئولية الناشئة عن حوادث مركبات النقل السريع ، أن يتقدم بطلب للمجمعة%' AND body LIKE '%1- صورة رسمية من محضر الحادث مرفقًا به%' AND body LIKE '%2- إقرار من ذوى الشأن بصحة المستندات المقدمة منهم%' AND body LIKE '%تحت مسئوليتهم القانونية.%' AND body LIKE '%وفى حال رغبة العميل فى استلام مبلغ التأمين%' AND body LIKE '%يجب إحضار إفادة بنكية بها.%' AND body LIKE '%وفى حالة توكيل المضرور أو ورثته%' AND body LIKE '%حق استلامه من المجمعة.%') THEN RAISE EXCEPTION '[175] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يجب تقديم المستندات الآتية لصرف مبلغ التعويض%' AND body LIKE '%حويل مبلغ التأمين المستحق لهم.' AND body LIKE '%1- شهادة الوفاة المميكنة.%' AND body LIKE '%2- أصل إعلام وراثة للمتوفي.%' AND body LIKE '%3- صورة من بطاقة الرقم القومى للورثة البالغين ، سارية.%' AND body LIKE '%وللمجمعة فى حالة وجود قصر للمتوفى أن تطلب تقديم المستندات الآتية :%' AND body LIKE '%1- أصل شهادات ميلاد القصر.%' AND body LIKE '%2- أصل قرار الوصاية.%' AND body LIKE '%3- إفادة النيابة الحسبية بأرقام حسابات القصر.%' AND body LIKE '%4- إفادة بنكية ببيانات الحساب البنكى لتحويل مبلغ التأمين المستحق لهم.%') THEN RAISE EXCEPTION '[175] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يجب تقديم المستندات الآتية لصرف مبلغ التعويض%' AND body LIKE '%ا به توصيف لحالة العجز ونسبته.' AND body LIKE '%عجز كلى أو جزئى مستديم%' AND body LIKE '%1- صورة شخصية للمصاب.%' AND body LIKE '%2- صورة من بطاقة الرقم القومى للمصاب ، سارية.%' AND body LIKE '%موضحًا به توصيف لحالة العجز ونسبته.%') THEN RAISE EXCEPTION '[175] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'فى حالة الأضرار المادية التى تلحق بالممتلكات%' AND body LIKE '%بالمادة الأولى من هذا القرار.' AND body LIKE '%لتقدير قيمه الأضرار المادية لصرف مبلغ التعويض بالإضافة إلى المستندات%' AND body LIKE '%المشار إليها بالمادة الأولى من هذا القرار.%') THEN RAISE EXCEPTION '[175] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'تلتزم المجمعة بالبت فى طلب صرف التعويض خلال ش%' AND body LIKE '%مستوفيًا المستندات المؤيدة له.' AND body LIKE '%تلتزم المجمعة بالبت فى طلب صرف التعويض%' AND body LIKE '%خلال شهر على الأكثر من تاريخ%' AND body LIKE '%تقديمه مستوفيًا المستندات المؤيدة له.%') THEN RAISE EXCEPTION '[175] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'يلغى قرار الهيئة المصرية للرقابة على التأمين%' AND body LIKE '%رقم 345 لسنة 2007 المشار إليه.' AND body LIKE '%يلغى قرار الهيئة المصرية للرقابة على التأمين رقم 345 لسنة 2007 المشار إليه.%') THEN RAISE EXCEPTION '[175] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%وعلى الموقع الإلكترونى للهيئة والمجمعة ،%' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية .%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[175] المادة 7 غير سليم'; END IF;
  IF v_len <> 2468 THEN RAISE EXCEPTION '[175] إجمالى طول المواد % بدل 2468', v_len; END IF;
  RAISE NOTICE '[175] القرار 302/2025: 8 مواد و8 نسخ، إجمالى % حرف', v_len;
END
$verify175$;

COMMIT;
