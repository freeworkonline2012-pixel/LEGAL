-- 167_replace_decision_55_2026_general_managing_agents_registration_criteria_polluted_with_watermark_page_headers_and_swallowed_article_with_preamble_and_11_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (55) لسنة 2026 بشأن شروط ومعايير قيد وكلاء الإدارة العموميين فى مجال التأمين لدى الهيئة،
-- المنشور بالوقائع المصرية، العدد 87 (تابع)، فى 20 أبريل 2026 (الصفحات 28 إلى 34): ديباجة و11 مادة، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (11 صفاً، 8813 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) شظايا نص العلامة المائية القطرية للوقائع ("صورة إ" و"لك" و"تروني" و"ة ال يع" و"تد بها" و"عند ا" و"ل" و"تداول") فى الصفوف الـ11 كلها تتخلل الجمل وتقطعها؛
-- (2) ترويسة صفحات الوقائع ("الوقائع املصرية - العدد ( 87تابع) فى 20أبريل سنة 2026" ورقم الصفحة) داخل 8 صفوف (2 و4 و5 و6 و7 و9 و10 و11) وفاصل الصفحة؛
-- (3) المادة 10 المخزَّنة تبتلع المادة 11 كاملة بعلامتها ("(المادة الحادية عشرة)") وتوقيع القرار، والمادة 11 المخزَّنة تكرر نصها وتوقيعها؛
-- (4) عنوان كل مادة (10 مواد) سطر أول داخل المتن بدل حقل title، وبلا ديباجة ولا تاريخ سريان؛
-- (5) حروف اللام ألف مقلوبة الترتيب فى الصفوف الـ11 ("وكالء اإلدارة" و"األموال" و"خالل" و"العمالت" ...)، وبقايا تطويل تالفة (U+FFFD، 410 حروف فى 10 صفوف)؛
-- (6) أرقام هندية وفارسية (11 رقماً فى 5 صفوف) وأرقام البنود ملتصقة بالكلمة التالية وبترتيب مقلوب ("- ۲منشآت" و"-٣شركات")، وتنوين مفصول عن حرفه فى 7 صفوف ("وف ًقا")، و190 فاصل CRLF داخل الجمل،
-- وأقواس الكلمات اللاتينية فى التعريفات مبعثرة وملتصقة بالكلمة العربية التالية ("( ) Managing General Agent «MGAهو الشخص" و"Letter of Authorityمن شركات").
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (7 صفحات، 444.2 كيلوبايت) قدّمه صاحب المشروع؛ جدول مراجعه تالف أُصلح بـqpdf قبل الاستخراج، وفيه علامة مائية قطرية مرسومة بخط مستقل (AhabHeadline) بحروف كبيرة مائلة فاستُبعدت حروف ذلك الخط من الاستخراج.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام تُترك كما هى، ومقاطع العربية تُعكس، وكلمات اللغة اللاتينية المتجاورة تُجمع فى مقطع واحد بترتيب قراءتها الإنجليزية)،
-- وأُعيد تركيب الفقرات والبنود والبنود الفرعية بإحداثيات الأسطر (بداية الفقرة أو البند سطر مُزاح عن الهامش الأيمن بمقدار ثابت فى كل صفحات الملف).
-- حُذفت ترويسة الصفحات وأرقام الصفحات وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية"؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 11 كما طُبع ("د/ إسلام عبد العظيم عزام").
-- أُبقيت كتابة الأصل وأخطاؤه كما طُبعت ("المصطلحين الآتيين" وعلامة التنصيص الواحدة «MGA وقوس الإغلاق وحده بعد BAA كما فى طبعة الوقائع، و"في" و"فى" معاً)؛ لم يُعدَّل لفظ واحد. الأرقام لاتينية والتنوين فى موضعه كما طُبع،
-- وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" : " و" ؛ ") وأُضيفت مسافة بين الرقم أو القوس والكلمة الملتصقة به؛ وأرقام البنود "N- ".
-- وقرئت على صور الصفحات مواضع الكلمات اللاتينية (الصفحات 1 و2 و4) وموضع الأقواس "(A)" و"(BBB)" بالمادة 4، فصار ما فى النص كما فى الصورة.
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحات السبع: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الحروف والأرقام والعناوين وعلى الكلمات اللاتينية؛ وسطران أسقطهما التعرف ("كل منهما" بالمادة 2، و"يتضمن ما يلي" بالمادة 5 البند 3) موجودان فى طبقة نص الصفحة؛ ولا فرق حقيقى فى كلمة واحدة.
--
-- ===== الهيكل =====
-- 12 صفاً، 12 نسخة (version_no = 1): ديباجة (article_no = 0) بالاطلاعات الثلاثة (القانون 10 لسنة 2009، وقانون مكافحة غسل الأموال 80 لسنة 2002 ولائحته التنفيذية، وقانون التأمين الموحد 155 لسنة 2024 والقرارات الصادرة تنفيذاً له)
-- وموافقة مجلس الإدارة بجلسته بتاريخ 2026/2/26؛ ثم المواد 1 إلى 11 بأرقامها الأصلية وعناوينها (حقل title، "المادة الأولى - نطاق التطبيق" ...؛ والمادة 11 بلا عنوان كما فى الأصل). لا hierarchical_location للمواد لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1..11، 0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2026-04-21: المادة 11 تعمل بالقرار "من اليوم التالى لتاريخ نشره فى الوقائع المصرية"، ونشره بالعدد 87 (تابع) بتاريخ 2026/4/20 (ثابت بترويسة كل صفحة). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 10 تمنح منشآت التأمين ووكلاء الإدارة العموميين ستة أشهر من تاريخ العمل لتوفيق أوضاعهم، أى حتى 2026/10/21، وشهراً لموافاة الهيئة بالبيانات، أى حتى 2026/5/21؛ هذه الهجرة تنقل النص كما نُشر ولا تعدّله ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (12 صفاً بديباجة سليمة والمادة 11 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو علامة مائية، أو ترويسة، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 7331 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix167$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[167] القرار 55/2026 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 12
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[167] القرار 55/2026 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[167] أُزيلت % مادة من القرار 55/2026 (نص مخزَّن ملوَّث بعلامة مائية وترويسات صفحات وتلف حروف، والمادة 10 فيه تبتلع المادة 11)', v_n;
  END IF;
END
$fix167$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 55 لسنة 2026 (منشور بالوقائع المصرية العدد 87 تابع فى 2026/4/20) بشأن شروط ومعايير قيد وكلاء الإدارة العموميين فى مجال التأمين لدى الهيئة$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون مكافحة غسل الأموال الصادر بالقانون رقم 80 لسنة 2002 ولائحته التنفيذية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 والقرارات الصادرة تنفيذًا له ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2026/2/26 ؛$b0_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - نطاق التطبيق$t1_0$, $b1_0$تسرى أحكام هذا القرار فى شأن شروط ومعايير قيد وكلاء الإدارة العموميين فى مجال التأمين ، حال رغبتهم فى القيد بالقائمة المعدة لهذا الغرض لدى الهيئة .
ولا يجوز لمنشآت التأمين العاملة فى مصر التعامل مع وكلاء الإدارة العموميين غير المقيدين بالقائمة المشار إليها.$b1_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - تعريفات$t2_0$, $b2_0$فى تطبيق أحكام هذا القرار ، يقصد بالمصطلحين الآتيين المعنى المبين قرين كل منهما :
وكيل الإدارة العمومى (Managing General Agent «MGA ) هو الشخص الاعتبارى الذى يجوز له تقديم خدمات مرتبطة بإعادة التأمين بما فى ذلك الاكتتاب وتسوية التعويضات نيابة عن شركات إعادة التأمين المقيدة لدى الهيئة وفقًا لاتفاقية التفويض المبرمة بينهما ، لصالح منشآت التأمين العاملة فى مصر.
اتفاقية التفويض Binding Authority Agreement BAA) هى وثيقة قانونية مبرمة بين شركة إعادة التأمين المقيدة لدى الهيئة ووكيل الإدارة العمومي ، يكون لوكيل الإدارة العمومى بموجبها الحق فى إبرام التعاقد وتقديم خدمات مرتبطة بإعادة التأمين نيابة عن شركات إعادة التأمين ، كما تحدد الاتفاقية نطاق السلطات والاختصاصات المفوض بها وكيل الإدارة العمومى فى هذا الشأن.$b2_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - قائمة قيد وكلاء الإدارة العموميين لدى الهيئة$t3_0$, $b3_0$تنشأ بالهيئة قائمة لقيد وكلاء الإدارة العموميين تتضمن البيانات التى تحددها الهيئة ، وعلى الأخص ما يلي :
1- اسم وكيل الإدارة العمومي ، والدولة التى يتبعها ، والجهة الرقابية الخاضع لها.
2- منشآت التأمين المتعاقد معها.
3- شركات إعادة التأمين المتعاقد معها.$b3_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - شروط القيد بالقائمة$t4_0$, $b4_0$يشترط لقيد وكيل الإدارة العمومى بالقائمة المشار إليها بالمادة الثالثة من هذا القرار ، استيفاء الشروط الآتية :
1- أن يكون خاضعًا لإشراف ورقابة جهة مختصة ومناظرة لاختصاصات الهيئة فى مجال الرقابة والإشراف على نشاط التأمين.
2- ألا تقل حقوق ملكيته عن رأس ماله المدفوع وفقًا لآخر قوائم مالية.
3- أن يكون لديه خبرة سابقة فى مجال الوكالة فى إعادة التأمين ، وأن يكون لديه سابقة أعمال مع إحدى شركات إعادة التأمين التى لا يقل تصنيفها عن (A) وتعمل فى دولة لا يقل تصنيفها الائتمانى الدولى عن (BBB) أو ما يناظرها وأن يكون لديه فريق عمل من ذوى الخبرة والكفاءة فى مجال إعادة التأمين.
4- ألا يكون أى من مساهميه الرئيسيين أو المستفيدين النهائيين أو أعضاء مجلس إداراته مدرجًا بقوائم مجلس الأمن أو قائمتى الكيانات الإرهابية والإرهابيين على النحو المشار إليه باللائحة التنفيذية لقانون مكافحة غسل الأموال.
5- ألا يكون قد صدر ضده تدابير إدارية من الجهة الرقابية الخاضع لها خلال السنوات الثلاث السابقة على طلب قيده.
6- أن يكون مبرمًا لاتفاقية تفويض مع إحدى شركات إعادة التأمين المقيدة لدى الهيئة ، على أن تكون سارية لمدة سنة على الأقل.
7- إبرام وثيقة تأمين مسئولية مهنية لدى إحدى شركات التأمين العاملة فى مصر بحدود مسئولية قدرها أربعين مليون جنيه مصرى عند القيد لأول مرة ، وعند التجديد تحدد قيمة الوثيقة بمتوسط أعمال وكيل الإدارة العمومى فى مصر عن الثلاث سنوات السابقة.
8- سداد مقابل خدمات فحص ودراسة طلب القيد أو تجديده بواقع مبلغ قدره خمسة وعشرين ألف جنيه أو ما يعادله بالعملات الأجنبية المعتمدة لدى البنك المركزى المصري.$b4_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - إجراءات القيد بالقائمة$t5_0$, $b5_0$يقدم طلب القيد بالقائمة على النموذج المعد من الهيئة لهذا الغرض مرفقًا به المستندات الدالة على استيفاء الشروط المنصوص عليها بالمادة الرابعة من هذا القرار ، بالإضافة إلى ما يلي :
1- بيان يتضمن هيكل ملكية وكيل الإدارة العمومى بما يمكن الهيئة من التعرف على المستفيد النهائي ، وأسماء أعضاء مجلس إدارته والمديرين التنفيذيين ووسائل الاتصال بهم.
2- اتفاقية التفويض.
3- خطاب تفويض Letter of Authority من شركات إعادة التأمين المتعاقدة مع وكيل الإدارة العمومى المطلوب قيده مختوم وممهور بتوقيع كليهما ، على أن يتضمن ما يلي :
(أ) أن وكيل الإدارة العمومى وكيل عن شركة إعادة التأمين فى حدود صلاحيات الوكالة الممنوحة له ، وأنه مفوض للعمل نيابة عنها.
(ب) أن وكيل الإدارة العمومى له حق التوقيع نيابة عن معيد التأمين.
(ج) مسئولية شركة إعادة التأمين عن كافة العمليات التى أبرمها وكيل الإدارة العمومي ، وكذا مسئوليتها عن كافة التزاماته حال إنهاء التفويض الصادر له.
4- آخر قوائم مالية خاصة بوكيل الإدارة العمومى باللغة العربية أو الإنجليزية.
5- خطة عمل وكيل الإدارة العمومى وحجم أعماله المستهدفة داخل السوق المصري.
وتتولى الهيئة دراسة الطلب المشار إليه ، ولها طلب استيفاء أى بيانات أو مستندات ترى ضرورة تقديمها للبت فى الطلب ، ويجوز للهيئة قبل الموافقة على قيد وكيل الإدارة العمومى إجراء مقابلة مع القائمين على الإدارة أو المديرين التنفيذيين به للتأكد من كفاءتهم وخبرتهم.$b5_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - مدة القيد بالقائمة وتجديدها$t6_0$, $b6_0$تكون مدة قيد وكيل الإدارة العمومى بالقائمة ثلاث سنوات قابلة للتجديد لمدد أخرى مماثلة ، شريطة استمرار توافر متطلبات القيد ، على أن يقدم طلب التجديد خلال الثلاثة أشهر السابقة على انتهاء مدة القيد ، ويعد القيد ساريًا فى الفترة من تاريخ انتهاء مدة القيد وحتى صدور قرار الهيئة بالبت فى طلب التجديد.$b6_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - التزامات وكيل الإدارة العمومي$t7_0$, $b7_0$يلتزم وكيل الإدارة العمومى المقيد لدى الهيئة بما يلي :
1- الامتثال للتشريعات الصادرة ذات الصلة بنشاطه وكذا المتعلقة بمكافحة غسل الأموال وتمويل الإرهاب.
2- عدم إسناد أى عمليات إعادة تأمين من قبل منشآت التأمين إلا لمعيدى التأمين المقيدين لدى الهيئة.
3- تجنب تعارض المصالح والحفاظ على سرية البيانات وخصوصية المعلومات المتعلقة بالاتفاقات المبرمة مع منشآت التأمين.
4- المساعدة فى تقييم الأخطار وتسوية وسداد المطالبات لمنشآت التأمين ، وسرعة النظر والبت فى الشكاوى المقدمة منهم فى هذا الشأن.
5- إخطار الهيئة بأى جزاءات أو أحكام قضائية أو تحكيمية فيما يخص نشاطه ، وذلك خلال عشرة أيام على الأكثر من تاريخ صدورها.
6- موافاة الهيئة سنويًا بالقوائم المالية السنوية الخاصة به باللغة العربية أو الإنجليزية .
7- موافاة الهيئة ببيان بكافة العمليات التى تم التعاقد عليها مع منشآت التأمين خلال السنة المنقضية ، على أن يتضمن البيان إجمالى الأقساط والتعويضات والتعويضات تحت التسوية ، وذلك لكل منشأة على حدة.
8- إخطار الهيئة حال وجود أى تغيير فى البيانات التى تم القيد بالقائمة بناء عليها ، وذلك فور حدوث التغيير.
9- موافاة الهيئة بأى بيانات أو مستندات تطلبها بشأن نشاطه.$b7_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة - التزامات منشآت التأمين$t8_0$, $b8_0$تلتزم منشآت التأمين عند تعاملها مع وكلاء الإدارة العموميين بما يلي :
1- التأكد من أن الأعمال المستهدف التعاقد بشأنها مع وكيل الإدارة العمومي ، تدخل ضمن سلطاته وصلاحياته المحددة باتفاقية التفويض وأنها ملزمة لمعيد التأمين.
2- الالتزام بتضمين العقود المبرمة عمولات إعادة التأمين التى تحصلها منشآت التأمين من قبل وكيل الإدارة العمومي.
3- إخطار الهيئة فورًا حال تحقق أى من الحالات الآتية :
(أ) التعاقد مع وكيل الإدارة العمومي.
(ب) تعديل أو إنهاء اتفاقية التفويض.
(ج) مخالفة وكيل الإدارة العمومى لبنود الاتفاق مع منشأة التأمين أو حال مخالفته للتشريعات الحاكمة لنشاط التأمين.
(د) إنهاء التعاقد مع وكيل الإدارة العمومي ، مع بيان سبب الإنهاء.
(ه) تعديل أى من البيانات المقدمة رفق الطلب المقدم للهيئة للقيد.
وذلك كله دون الإخلال بحق منشآت التأمين فى اتخاذ الإجراءات اللازمة لضمان حقوقها فى هذا الشأن.$b8_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة - الشطب من القائمة$t9_0$, $b9_0$لمجلس إدارة الهيئة شطب قيد وكيل الإدارة العمومى من القائمة فى أى من الحالات الآتية :
1- فقد أحد شروط القيد.
2- عدم قيام منشآت التأمين العاملة فى مصر بإسناد أى عمليات إلى وكيل الإدارة العمومى لمدة عامين متتاليين.
3- الإخلال بأى من الالتزامات المقررة عليه أو القيام بممارسات من شأنها الإضرار بسوق التأمين المصري.
ولا يخل قرار الشطب من القائمة من تنفيذ كافة الالتزامات تجاه منشآت التأمين المصرية.
وفى جميع الأحوال ، يجوز فى حال صدور قرار بالشطب أن يتم تقديم طلب بإعادة القيد بالقائمة شريطة زوال سبب الشطب.$b9_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins9_0;

WITH ins10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $t10_0$المادة العاشرة - توفيق الأوضاع$t10_0$, $b10_0$على منشآت التأمين ووكلاء الإدارة العموميين توفيق أوضاعهم وفقًا لأحكام هذا القرار خلال ستة أشهر من تاريخ العمل به .
كما تلتزم كافة منشآت التأمين التى تتعامل مع وكلاء إدارة عموميين بموافاة الهيئة بكافة البيانات التى تخص هؤلاء الوكلاء على النحو الوارد بهذا القرار ، وذلك خلال شهر من تاريخ العمل به.$b10_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins10_0;

WITH ins11_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, $t11_0$المادة الحادية عشرة$t11_0$, $b11_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره فى الوقائع المصرية.
رئيس مجلس إدارة الهيئة العامة للرقابة المالية
د/ إسلام عبد العظيم عزام$b11_0$
  FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-21', 'active' FROM ins11_0;

DO $verify167$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 55 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[167] القرار 55/2026 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 12 THEN RAISE EXCEPTION '[167] عدد المواد % بدل 12', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2026-04-21';
  IF v_v <> 12 THEN RAISE EXCEPTION '[167] عدد النسخ % بدل 12', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%العدد 87%' OR body LIKE '%أبريل سنة 2026%' OR body LIKE '%صورة إ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ل تداول%' OR body LIKE '%تد بها%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%Agent General%' OR body LIKE '%Authority Binding%' OR body LIKE '%Authority of Letter%' OR body LIKE '%Agreement Authority%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[167] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظ%' AND body LIKE '%ته المنعقدة بتاريخ 2026/2/26 ؛' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 80 لسنة 2002%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%بتاريخ 2026/2/26 ؛%') THEN RAISE EXCEPTION '[167] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تسرى أحكام هذا القرار فى شأن شروط ومعايير قيد%' AND body LIKE '%لمقيدين بالقائمة المشار إليها.') THEN RAISE EXCEPTION '[167] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'فى تطبيق أحكام هذا القرار ، يقصد بالمصطلحين ا%' AND body LIKE '%الإدارة العمومى فى هذا الشأن.' AND body LIKE '%(Managing General Agent «MGA ) هو الشخص%' AND body LIKE '%Binding Authority Agreement BAA) هى وثيقة%') THEN RAISE EXCEPTION '[167] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'تنشأ بالهيئة قائمة لقيد وكلاء الإدارة العمومي%' AND body LIKE '%ت إعادة التأمين المتعاقد معها.') THEN RAISE EXCEPTION '[167] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يشترط لقيد وكيل الإدارة العمومى بالقائمة المش%' AND body LIKE '%تمدة لدى البنك المركزى المصري.' AND body LIKE '%عن (A) وتعمل%' AND body LIKE '%عن (BBB) أو ما يناظرها%' AND body LIKE '%أربعين مليون جنيه مصرى%' AND body LIKE '%خمسة وعشرين ألف جنيه%' AND body LIKE '%8- سداد مقابل%') THEN RAISE EXCEPTION '[167] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يقدم طلب القيد بالقائمة على النموذج المعد من%' AND body LIKE '%به للتأكد من كفاءتهم وخبرتهم.' AND body LIKE '%Letter of Authority%' AND body LIKE '%(أ) أن وكيل%' AND body LIKE '%(ج) مسئولية شركة%' AND body LIKE '%5- خطة عمل%') THEN RAISE EXCEPTION '[167] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'تكون مدة قيد وكيل الإدارة العمومى بالقائمة ثل%' AND body LIKE '%ر الهيئة بالبت فى طلب التجديد.' AND body LIKE '%ثلاث سنوات قابلة للتجديد%') THEN RAISE EXCEPTION '[167] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'يلتزم وكيل الإدارة العمومى المقيد لدى الهيئة%' AND body LIKE '%أو مستندات تطلبها بشأن نشاطه.' AND body LIKE '%خلال عشرة أيام على الأكثر%' AND body LIKE '%9- موافاة الهيئة%') THEN RAISE EXCEPTION '[167] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'تلتزم منشآت التأمين عند تعاملها مع وكلاء الإد%' AND body LIKE '%زمة لضمان حقوقها فى هذا الشأن.' AND body LIKE '%(د) إنهاء التعاقد%' AND body LIKE '%(ه) تعديل أى من البيانات%') THEN RAISE EXCEPTION '[167] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'لمجلس إدارة الهيئة شطب قيد وكيل الإدارة العمو%' AND body LIKE '%بالقائمة شريطة زوال سبب الشطب.' AND body LIKE '%لمدة عامين متتاليين%') THEN RAISE EXCEPTION '[167] المادة 9 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0 AND body LIKE 'على منشآت التأمين ووكلاء الإدارة العموميين تو%' AND body LIKE '%لك خلال شهر من تاريخ العمل به.' AND body LIKE '%خلال ستة أشهر من تاريخ العمل به .%' AND body LIKE '%خلال شهر من تاريخ العمل به.%') THEN RAISE EXCEPTION '[167] المادة 10 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د/ إسلام عبد العظيم عزام' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره فى الوقائع المصرية.%' AND body LIKE '%د/ إسلام عبد العظيم عزام') THEN RAISE EXCEPTION '[167] المادة 11 غير سليم'; END IF;
  IF v_len <> 7331 THEN RAISE EXCEPTION '[167] إجمالى طول المواد % بدل 7331', v_len; END IF;
  RAISE NOTICE '[167] القرار 55/2026: 12 مواد و12 نسخ، إجمالى % حرف', v_len;
END
$verify167$;

COMMIT;
