-- 173_replace_decision_269_2025_insurance_institute_conversion_rules_polluted_with_page_headers_and_reversed_letters_with_preamble_and_12_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (269) لسنة 2025 بشأن الضوابط والقواعد والإجراءات الخاصة بتحويل (معهد التأمين المصرى) ليكون (معهد تدريب وتأهيل العاملين بشركات التأمين)،
-- المنشور بالوقائع المصرية، العدد 271 (تابع - ب)، فى 2 ديسمبر 2025 (الصفحات 14 إلى 20): ديباجة و12 مادة، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (12 صفاً، 7926 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) خمس ترويسات صفحات للوقائع ("الوقائع المصرية - العدد 271 تابع (ب) فى 2 ديسمبر سنة 2025" برقم الصفحة 16 إلى 20) وفواصل صفحات (\f) داخل المواد 2 و4 و8 و10؛
-- (2) المادة 10 تحمل بداخلها عنوانى المادتين 11 و12 ونصيهما كاملين بعد ترويسة الصفحة 20، فهما مكرَّران (فالمادتان 11 و12 موجودتان مرة داخل المادة 10 ومرة فى صفيهما)؛
-- (3) حروف اللام ألف مقلوبة الترتيب ("االعتبارية" و"األساسى" و"خالل" و"الحتاد") وحروف مبعثرة ("التأمني" بدل "التأمين" فى 16 موضعاً، و"املعهد" و"احلكومية")، وبقايا تطويل تالفة (U+FFFD، 386 حرفاً)، وتنوين مفصول ("حال ًيا" و"وف ًقا")، و119 فاصل CRLF داخل الجمل، وبنود مرقَّمة بصيغة معكوسة ("-1عق���د")، وأرقام هندية وفارسية (30)، والتوقيع مبعثراً ("د .محمد فريد صالح")؛
-- (4) بلا ديباجة (سبعة اطلاعات وموافقة مجلس الإدارة بجلسة 2025/11/5) ولا تاريخ سريان.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: ترويسات الصفحات تقطع الجمل، وتكرار المادتين 11 و12 داخل المادة 10 يُنتج استشهاداً بنص المادة 10 يتضمن أحكاماً ليست منها.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (7 صفحات، 587 كيلوبايت) قدّمه صاحب المشروع؛ بملف تالف جدول المراجع (xref) فأُصلح بـqpdf قبل القراءة؛ ولا علامة مائية فى هذا الملف (ليس فيه خط AhabHeadline).
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات بإحداثيات الأسطر. وعُولج فى هذا الملف عيبا ترميز: «ين» النهائى المتصل (يُرمَّز «ن» فقط فتضيع الياء) فى 45 موضعاً، و«لأ» المتصل (يُرمَّز «أ» فقط فتضيع اللام) فى موضعين ("للأنشطة")، بقاعدة عرض الحرف، وتحققتُ منها على صور الصفحات وبمقابلة OCR مستقل.
-- حُذفت ترويسة كل صفحة ورقمها وسطر جهة الإصدار "رئيس مجلس إدارة الهيئة العامة للرقابة المالية" الذى يلى العنوان؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 12 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- المادتان 4 و6 تضمان فقرات وبنوداً غير مرقَّمة (عضوان وخمسة أعضاء فى المادة 4، وأربعة بنود فى المادة 6) كما طُبعت؛ كل منها فقرة مستقلة بسطر مستقل. البنود المرقَّمة تُعرض بصيغة "N- نص".
-- أُبقيت كتابة الأصل كما طُبعت بلا تعديل لفظ: "رد اليه اعتباره" فى المادة 4 مقابل "رد إليه" فى المادة 8، و"خبرة باحد المجالات" فى المادة 8، و"أن يكون متمتعا" فى المادة 8 مقابل "متمتعًا" فى المادة 4، و"التاريخ النشر" فى المادة 12،
-- و"التالي" و"الآتي" و"التنفيذي" بياء بلا ألف مقصورة، والمسافة قبل النقطة فى آخر المادتين 11 و12. الأرقام لاتينية، والتنوين فى موضعه كما طُبع، وأُسقطت الكسرة (يمضِ) وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والفاصلة المنقوطة والنقطتين (" ، " و" ؛ " و" :").
-- (الفقرات الافتتاحية للمواد 4 و6 و8 مطبوعة بخط تحته خط فى الأصل؛ والتسطير تنسيق لا نص، فلم يُنقل.)
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحات: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الأرقام والعناوين وخلط الباء والياء، وقُرئت صورة الصفحات 1 و3 و4 و5 و7 فصار ما فى النص كما فى الصورة (ومنها "لخطأ" بلا تنوين فى المادة 4 والمادة 8 كما طُبعت).
--
-- ===== الهيكل =====
-- 13 صفاً، 13 نسخة (version_no = 1): ديباجة (article_no = 0) بسبعة اطلاعات (القانون 82 لسنة 2006، والقانون 10 لسنة 2009، وقرار رئيس الجمهورية 192 لسنة 2009، والقانون 160 لسنة 2022، وقانون التأمين الموحد 155 لسنة 2024، وقانون العمل 14 لسنة 2025، وقرار مجلس إدارة الهيئة 127 لسنة 2025) وموافقة مجلس الإدارة بجلسته بتاريخ 2025/11/5؛
-- ثم المواد 1 إلى 12 بأرقامها الأصلية بلا عناوين كما فى الأصل ("المادة الأولى" إلى "المادة الثانية عشرة")، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1 إلى 12 و0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-12-03: المادة 12 تعمل بالقرار "من اليوم التالى" لتاريخ نشره، ونشره بالعدد 271 (تابع - ب) بتاريخ 2025/12/2 (ثابت بترويسة الصفحات). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 11 تمنح اتحاد شركات التأمين المصرية شهراً من تاريخ صدور القرار لوضع النظام الأساسى للمعهد واعتماده من الهيئة، والمادة 1 تُكسب المعهد الشخصية الاعتبارية من تاريخ نشر ذلك النظام بالوقائع. هذه الهجرة تنقل النص كما نُشر ولا تعدّله ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (13 صفاً بديباجة سليمة والمادة 12 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو ترويسة صفحة، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 7352 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix173$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[173] القرار 269/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 13
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 12 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[173] القرار 269/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[173] أُزيلت % مادة من القرار 269/2025 (نص مخزَّن ملوَّث بترويسات صفحات وتلف حروف وتكرار مادتين، وبلا ديباجة)', v_n;
  END IF;
END
$fix173$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 269 لسنة 2025 (منشور بالوقائع المصرية العدد 271 تابع (ب) فى 2025/12/2) بشأن الضوابط والقواعد والإجراءات الخاصة بتحويل (معهد التأمين المصرى) ليكون (معهد تدريب وتأهيل العاملين بشركات التأمين)$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم 82 لسنة 2006 بإنشاء الهيئة القومية لضمان جودة التعليم والاعتماد وتعديلاته ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قرار رئيس الجمهورية رقم 192 لسنة 2009 بإصدار النظام الأساسى للهيئة العامة للرقابة المالية ؛
وعلى القانون رقم 160 لسنة 2022 بإنشاء الهيئة المصرية لضمان الجودة والاعتماد فى التعليم الفنى والتقنى والتدريب المهنى (إتقان) ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قانون العمل الصادر بالقانون رقم (14) لسنة 2025 ؛
وعلى قرار مجلس إدارة الهيئة رقم (127) لسنة 2025 بشأن اعتماد النظام الأساسى لاتحاد شركات التأمين المصرية ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/11/5 ؛$b0_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$يحول معهد التأمين المصرى القائم حاليًا والتابع لاتحاد شركات التأمين المصرية ليكون (معهد تدريب وتأهيل العاملين بشركات التأمين) ويسجل فى سجلات الهيئة كجهاز معاون لاتحاد شركات التأمين المصرية ، ويكتسب الشخصية الاعتبارية المستقلة اعتبارًا من تاريخ نشر النظام الأساسى للمعهد بالوقائع المصرية ، ويعد من أشخاص القانون الخاص .$b1_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$يخضع المعهد لإشراف ورقابة الهيئة العامة للرقابة المالية ، ولا يسعى المعهد إلى تحقيق ربح ، ويكون مقره بالقاهرة الكبرى ويجوز إنشاء فروع له بالمحافظات بعد موافقة مجلس إدارة الاتحاد واعتماد الهيئة ، ويعمل المعهد على المساعدة فى تنفيذ استراتيجية الهيئة فى مجال التدريب ويباشر الاختصاصات التالية :
1- عقد الندوات وورش العمل والبرامج التدريبية للعاملين بشركات التأمين المصرية لرفع مستوى الكفاءة والقدرة لديهم ، ويجوز للمعهد تدريب العاملين بشركات تأمين بدول أخرى وفق برامج تدريب محددة فى الموضوعات التى تدخل فى نطاق اختصاصه .
2- تكوين مكتبة تأمينية تكون مرجعًا للدارسين والباحثين والعاملين فى مجال التأمين .
3- توفير المنح الدراسية والبعثات التدريبية بالخارج للمتدربين بالمعهد .
ولا يجوز للمعهد تنظيم ندوات أو عقد دورات تدريبية أو تأهيلية لموضوعات لا تتعلق بمجال التأمين أو رفع كفاءة العاملين بشركات التأمين ، ويجوز لمعهد الخدمات المالية أن يسند إلى المعهد تنظيم بعض الدورات التدريبية الداخلية فى اختصاص المعهد وفقًا للقواعد التى يتم الاتفاق عليها بين المعهدين.$b2_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$يكون للمعهد جمعية عامة تعد سلطته العليا وتشكل من ممثل عن كل شركة من شركات التأمين أعضاء اتحاد شركات التأمين المصرية ، على أن يكونوا من رؤساء مجالس إدارات هذه الشركات ، أو نوابهم أو أعضائها المنتدبين ممن يصدر بتحديدهم قرار من مجلس إدارة الشركة.
ويرأس اجتماعاتها رئيس اتحاد شركات التأمين المصرية أو نائبه فى حالة غيابه ، أو من يختاره أعضاء الجمعية فى حالة غيابهما.
وتجتمع الجمعية العامة ، بناء على دعوة من رئيسها ، أو بناء على طلب يتقدم به ثلث عدد أعضائها.
ويكون اجتماع الجمعية العامة صحيحًا بحضور أغلبية أعضائها ، فإن لم يكتمل النصاب يؤجل الاجتماع لمدة ساعة ، ويكون الاجتماع الثانى صحيحًا بحضور أى عدد من أعضائها ممن لهم حق الحضور ، وبحد أدنى ربع عدد الأعضاء على أن يكون من بينهم أربعة من أعضاء مجلس إدارة المعهد على الأقل فإذا لم يكتمل النصاب يقوم مجلس الإدارة بإعادة الدعوة للجمعية العامة خلال مدة لا تقل عن أسبوع ويكون الاجتماع صحيحًا فى هذه الحالة بحضور أى عدد من الأعضاء ، ولا يجوز لعضو مجلس إدارة المعهد أن يجمع بين هذه الصفة وتمثيل أحد أعضاء الجمعية العامة للمعهد فى الاجتماع.
وتصدر قرارات الجمعية العامة بأغلبية أصوات الأعضاء الحاضرين.$b3_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة$t4_0$, $b4_0$يتولى إدارة المعهد مجلس إدارة مكون من سبعة أعضاء وذلك على النحو التالي :
خمسة أعضاء يتم انتخابهم كممثلين لشركات التأمين من بين رؤساء مجالس إدارات هذه الشركات أو نوابهم أو أعضائها المنتدبين من غير أعضاء مجلس إدارة اتحاد شركات التأمين المصرية.
عضوين من ذوى الخبرة التى لا تقل خبرتهم عن خمسة عشر عامًا فى أحد مجالات عمل المعهد يحددهما مجلس إدارة اتحاد شركات التأمين المصرية بعد موافقة الهيئة.
ويشترط فيمن يرشح لرئاسة أو عضوية مجلس إدارة المعهد توافر الشروط التالية :
1- أن يكون محمود السيرة حسن السمعة.
2- ألا يكون قد سبق الحكم عليه بعقوبة جناية أو بعقوبة جنحة مقيدة للحرية فى جريمة ماسة بالشرف أو الأمانة أو بعقوبة سالبة للحرية فى إحدى الجرائم المنصوص عليها فى قوانين الشركات أو التجارة أو القوانين المنظمة للأنشطة المالية غير المصرفية لأسباب تتعلق بنشاط الشركة ، أو حكم بإشهار إفلاسه ، ما لم يكن قد رد اليه اعتباره.
3- أن يكون متمتعًا بحقوقه المدنية كاملة.
4- ألا يقوم به عارض من عوارض الأهلية.
5- ألا يكون قد سبق فصله من وظيفة شغلها بحكم أو قرار تأديبى أو صدر قرار بشطب اسمه من سجل إحدى المهن التى تنظمها القوانين أو اللوائح لأمور تمس الأمانة أو الشرف ما لم يمض على صدور الحكم أو القرار ثلاثة أعوام على الأقل.
6- ألا يكون قد سبق توقيع تدبير عليه من مجلس إدارة الهيئة لخطأ جسيم تسبب فيه مالم يمض على ذلك ثلاثة أعوام على الأقل.
7- أن تتوافر لديه خبرة تأمينية أو خبرة بأحد المجالات ذات الصلة بعمل المعهد مدة لا تقل عن عشر سنوات.
8- أن يكون مضى على شغله لوظيفة رئيس مجلس إدارة أو نائب الرئيس أو عضو منتدب مدة لا تقل عن سنة.
9- اجتياز المقابلة الشخصية التى تعقدها الهيئة فى هذا الشأن.
ويختار مجلس الإدارة من بين أعضائه رئيسًا ونائبًا للرئيس.$b4_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$تكون مدة مجلس إدارة المعهد أربع سنوات تبدأ من تاريخ اختيار أعضائه ، ويجوز إعادة اختيار العضو لدورة واحدة أخرى متصلة.$b5_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة$t6_0$, $b6_0$يلتزم المعهد بإخطار الهيئة بالبرامج التدريبية التى يقدمها لاعتمادها على أن يتضمن ذلك الآتي :
الشروط التى يجب توافرها فى المتدربين للالتحاق بالبرنامج.
مدى كفاية العمليات التدريبية من حيث موضوعات ومجالات التدريب وعدد الساعات المخصصة.
مستويات وتخصصات المدربين.
مستوى المهارة التى يكتسبها المتدرب بعد الانتهاء من البرنامج.$b6_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة$t7_0$, $b7_0$يجب أن يتوافر فى المدربين الذين يزاولون أعمال التدريب بالمعهد الحد الأدنى من الشروط والمؤهلات والخبرات التى يصدر بتحديدها قرار من مجلس إدارة الهيئة ، وعلى المعهد إخطار الهيئة بقائمة المدربين لمراجعتها واعتمادها ، كما يتعين عليه إخطارها بأى تعديل فيها ولا يعمل به إلا بعد الاعتماد.$b7_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة$t8_0$, $b8_0$يكون للمعهد مدير تنفيذى متفرغ يصدر بتعيينه وتحديد معاملته المالية قرار من مجلس إدارة المعهد ، على أن يتوافر فيه الشروط التالية :
1- أن يكون محمود السيرة حسن السمعة.
2- ألا يكون قد سبق الحكم عليه بعقوبة جناية أو بعقوبة جنحة مقيدة للحرية فى جريمة ماسة بالشرف أو الأمانة أو بعقوبة سالبة للحرية فى إحدى الجرائم المنصوص عليها فى قوانين الشركات أو التجارة أو القوانين المنظمة للأنشطة المالية غير المصرفية لأسباب تتعلق بنشاط الشركة ، أو حكم بإشهار إفلاسه ، ما لم يكن قد رد إليه اعتباره.
3- أن يكون متمتعا بحقوقه المدنية كاملة.
4- ألا يقوم به عارض من عوارض الأهلية.
5- ألا يكون قد سبق فصله من وظيفة شغلها بحكم أو قرار تأديبى أو صدر قرار بشطب اسمه من سجل إحدى المهن التى تنظمها القوانين أو اللوائح لأمور تمس الأمانة أو الشرف ما لم يمض على صدور الحكم أو القرار ثلاثة أعوام على الأقل.
6- ألا يكون قد سبق توقيع تدبير عليه من مجلس إدارة الهيئة لخطأ جسيم تسبب فيه مالم يمض على ذلك ثلاثة أعوام على الأقل.
7- أن تتوافر لديه خبرة تأمينية أو خبرة باحد المجالات ذات الصلة بعمل المعهد مدة لا تقل عن عشر سنوات.
8- اجتياز المقابلة الشخصية التى تعقدها الهيئة فى هذا الشأن.
ويحدد النظام الأساسى للمعهد اختصاصات المدير التنفيذي.$b8_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة$t9_0$, $b9_0$يلتزم المعهد بمنح المتدرب لديه شهادة تفيد اجتياز التدريب الذى عقده المعهد له والمستوى الذى وصل له ويتم توقيع الشهادة من المدير التنفيذى للمعهد ورئيس مجلس الإدارة.$b9_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins9_0;

WITH ins10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $t10_0$المادة العاشرة$t10_0$, $b10_0$يلتزم المعهد باستيفاء المعايير المقررة والحصول على شهادات الاعتماد وفقًا لأحكام القوانين أرقام 82 لسنة 2006 المعدل بالقانون رقم 159 لسنة 2022 بإنشاء الهيئة القومية لضمان جودة التعليم والاعتماد والقانون رقم 160 لسنة 2022 بإنشاء الهيئة المصرية لضمان الجودة والاعتماد فى التعليم الفنى والتقنى والتدريب المهنى (إتقان) خلال المواعيد المقررة قانونًا وإخطار معهد الخدمات المالية بصورة من شهادات الاعتماد فور صدورها.$b10_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins10_0;

WITH ins11_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, $t11_0$المادة الحادية عشرة$t11_0$, $b11_0$يضع اتحاد شركات التأمين المصرية النظام الأساسى للمعهد ويعتمده من الهيئة خلال شهر من تاريخ صدور هذا القرار ، ويتم نشره بالوقائع المصرية وعلى الموقع الإلكترونى للمعهد والهيئة ويعمل به من اليوم التالى لتاريخ النشر بالوقائع المصرية .$b11_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins11_0;

WITH ins12_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, NULL, $t12_0$المادة الثانية عشرة$t12_0$, $b12_0$ينشر هذا القرار بالوقائع المصرية ويعمل به من اليوم التالى التاريخ النشر ، وعلى الجهات المختصة تنفيذه .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b12_0$
  FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-12-03', 'active' FROM ins12_0;

DO $verify173$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 269 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[173] القرار 269/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 13 THEN RAISE EXCEPTION '[173] عدد المواد % بدل 13', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-12-03';
  IF v_v <> 13 THEN RAISE EXCEPTION '[173] عدد النسخ % بدل 13', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%العدد 271%' OR body LIKE '%ديسمبر سنة 2025%' OR body LIKE '%صورة إ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ل تداول%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%التأمن%' OR body LIKE '%المتدربن%' OR body LIKE '%المقيمن%' OR body LIKE '%الدارسن%' OR body LIKE '%والباحثن%' OR body LIKE '%المدربن%' OR body LIKE '%الحاضرن%' OR body LIKE '%المنتدبن%' OR body LIKE '%العاملن%' OR body LIKE '%( )%' OR body LIKE '%٪%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[173] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 82 لسنة 2006 بإنش%' AND body LIKE '%ته المنعقدة بتاريخ 2025/11/5 ؛' AND body LIKE '%رقم 82 لسنة 2006%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 192 لسنة 2009%' AND body LIKE '%رقم 160 لسنة 2022%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%رقم (14) لسنة 2025%' AND body LIKE '%رقم (127) لسنة 2025%' AND body LIKE '%بتاريخ 2025/11/5 ؛%') THEN RAISE EXCEPTION '[173] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يحول معهد التأمين المصرى القائم حاليًا والتاب%' AND body LIKE '%ويعد من أشخاص القانون الخاص .' AND body LIKE '%ليكون (معهد تدريب وتأهيل العاملين بشركات التأمين)%' AND body LIKE '%ويعد من أشخاص%' AND body LIKE '%القانون الخاص .%') THEN RAISE EXCEPTION '[173] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يخضع المعهد لإشراف ورقابة الهيئة العامة للرقا%' AND body LIKE '%تم الاتفاق عليها بين المعهدين.' AND body LIKE '%1- عقد الندوات وورش العمل%' AND body LIKE '%2- تكوين مكتبة تأمينية%' AND body LIKE '%3- توفير المنح الدراسية والبعثات التدريبية بالخارج%' AND body LIKE '%وفقًا للقواعد التى يتم الاتفاق عليها بين المعهدين.%') THEN RAISE EXCEPTION '[173] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يكون للمعهد جمعية عامة تعد سلطته العليا وتشكل%' AND body LIKE '%أغلبية أصوات الأعضاء الحاضرين.' AND body LIKE '%أو نوابهم أو أعضائها المنتدبين ممن يصدر بتحديدهم%' AND body LIKE '%بحد أدنى ربع عدد الأعضاء%' AND body LIKE '%أربعة من أعضاء مجلس إدارة المعهد على الأقل%' AND body LIKE '%بأغلبية أصوات الأعضاء الحاضرين.%') THEN RAISE EXCEPTION '[173] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يتولى إدارة المعهد مجلس إدارة مكون من سبعة أع%' AND body LIKE '%أعضائه رئيسًا ونائبًا للرئيس.' AND body LIKE '%خمسة أعضاء يتم انتخابهم%' AND body LIKE '%عضوين من ذوى الخبرة%' AND body LIKE '%1- أن يكون محمود السيرة حسن السمعة.%' AND body LIKE '%5- ألا يكون قد سبق فصله%' AND body LIKE '%6- ألا يكون قد سبق توقيع تدبير عليه من مجلس إدارة الهيئة لخطأ جسيم%' AND body LIKE '%8- أن يكون مضى على شغله لوظيفة رئيس مجلس إدارة%' AND body LIKE '%9- اجتياز المقابلة الشخصية%' AND body LIKE '%رئيسًا ونائبًا للرئيس.%') THEN RAISE EXCEPTION '[173] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'تكون مدة مجلس إدارة المعهد أربع سنوات تبدأ من%' AND body LIKE '%العضو لدورة واحدة أخرى متصلة.' AND body LIKE '%لدورة واحدة أخرى متصلة.%') THEN RAISE EXCEPTION '[173] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'يلتزم المعهد بإخطار الهيئة بالبرامج التدريبية%' AND body LIKE '%تدرب بعد الانتهاء من البرنامج.' AND body LIKE '%الشروط التى يجب توافرها فى المتدربين%' AND body LIKE '%مدى كفاية العمليات التدريبية%' AND body LIKE '%مستويات وتخصصات المدربين.%' AND body LIKE '%مستوى المهارة التى يكتسبها المتدرب%') THEN RAISE EXCEPTION '[173] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'يجب أن يتوافر فى المدربين الذين يزاولون أعمال%' AND body LIKE '%ولا يعمل به إلا بعد الاعتماد.' AND body LIKE '%ولا يعمل به إلا بعد الاعتماد.%') THEN RAISE EXCEPTION '[173] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'يكون للمعهد مدير تنفيذى متفرغ يصدر بتعيينه وت%' AND body LIKE '%معهد اختصاصات المدير التنفيذي.' AND body LIKE '%مدير تنفيذى متفرغ%' AND body LIKE '%3- أن يكون متمتعا بحقوقه المدنية كاملة.%' AND body LIKE '%7- أن تتوافر لديه خبرة تأمينية أو خبرة باحد المجالات%' AND body LIKE '%8- اجتياز المقابلة الشخصية%' AND body LIKE '%ويحدد النظام الأساسى للمعهد اختصاصات المدير التنفيذي.%') THEN RAISE EXCEPTION '[173] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'يلتزم المعهد بمنح المتدرب لديه شهادة تفيد اجت%' AND body LIKE '%يذى للمعهد ورئيس مجلس الإدارة.' AND body LIKE '%المدير التنفيذى للمعهد ورئيس مجلس الإدارة.%') THEN RAISE EXCEPTION '[173] المادة 9 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0 AND body LIKE 'يلتزم المعهد باستيفاء المعايير المقررة والحصو%' AND body LIKE '%من شهادات الاعتماد فور صدورها.' AND body LIKE '%القانون رقم 159 لسنة 2022%' AND body LIKE '%القانون رقم 160 لسنة 2022%' AND body LIKE '%فور صدورها.%') THEN RAISE EXCEPTION '[173] المادة 10 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0 AND body LIKE 'يضع اتحاد شركات التأمين المصرية النظام الأساس%' AND body LIKE '%تاريخ النشر بالوقائع المصرية .' AND body LIKE '%خلال شهر من تاريخ صدور هذا القرار%' AND body LIKE '%لتاريخ النشر بالوقائع المصرية .%') THEN RAISE EXCEPTION '[173] المادة 11 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 12 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار بالوقائع المصرية ويعمل به من%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%من اليوم التالى التاريخ النشر ،%' AND body LIKE '%وعلى الجهات المختصة تنفيذه .%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[173] المادة 12 غير سليم'; END IF;
  IF v_len <> 7352 THEN RAISE EXCEPTION '[173] إجمالى طول المواد % بدل 7352', v_len; END IF;
  RAISE NOTICE '[173] القرار 269/2025: 13 مواد و13 نسخ، إجمالى % حرف', v_len;
END
$verify173$;

COMMIT;
