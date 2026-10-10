-- 170_replace_decision_158_2025_foreign_non_resident_reinsurance_brokers_registration_criteria_polluted_with_watermark_and_page_headers_with_preamble_and_9_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (158) لسنة 2025 بشأن شروط ومعايير قيد وسطاء إعادة التأمين الأجانب غير المقيمين،
-- المنشور بالوقائع المصرية، العدد 183 (تابع - أ)، فى 19 أغسطس 2025 (الصفحات 2 إلى 8): ديباجة و9 مواد، بلا فصول ولا قواعد مرفقة (فمفاتيح المواد كلها article_suffix_order = 0).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P1) =====
-- مخزَّن بالبذور (9 صفوف، 7160 حرفاً) مأخوذ من طبقة النص فى PDF دون تنظيف، وبه:
-- (1) شظايا نص العلامة المائية القطرية للوقائع ("صورة إ" و"لك" و"تروني" و"ة ال يع" و"تد بها" و"عند ا" و"ل" و"تداول") فى 5 صفوف (2 و3 و5 و6 و9) تتخلل الجمل وتقطعها؛
-- (2) ترويسة صفحات الوقائع ("الوقائع المصرية - العدد 183 تابع (أ) فى 19 أغسطس سنة 2025" ورقم الصفحة) وفاصل الصفحة داخل 6 صفوف (1 و2 و3 و5 و6 و8)؛
-- (3) عنوان كل مادة (8 مواد من 9) سطر أول داخل المتن بدل حقل title؛
-- (4) حروف اللام ألف مقلوبة الترتيب فى 8 صفوف ("اإلدارية" و"األوضاع" و"خالل" و"ثالث") وبقايا تطويل تالفة (U+FFFD، 393 حرفاً فى 8 صفوف) تتخلل الكلمات ("ُينش���ر" و"ه���ذا")؛
-- (5) أرقام هندية وفارسية (15 رقماً فى 6 صفوف) وتنوين مفصول عن حرفه فى 5 صفوف، و113 فاصل CRLF داخل الجمل، وتوقيع القرار فى المادة 9 بصيغة مبعثرة ("د .محمد فريد صالح")؛
-- (6) بلا ديباجة (الاطلاعات الخمسة وموافقة مجلس الإدارة بجلسة 2025/7/30) ولا تاريخ سريان.
-- فلا يصلح النص المخزَّن للاستشهاد الرسمى، ولا لإدخاله إلى سياق نموذج اللغة: شظايا العلامة المائية والترويسة تقطع الجمل، والتلف يمنع مطابقة الكلمات.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (7 صفحات، 5.5 ميجابايت) قدّمه صاحب المشروع؛ جدول مراجعه تالف (لا startxref) أُصلح بـqpdf قبل الاستخراج، وفيه علامة مائية قطرية مرسومة بخط مستقل (AhabHeadline) فاستُبعدت حروف ذلك الخط من الاستخراج.
-- استُخرج النص من مواضع الحروف نفسها (pdfplumber) لا من مخرجات poppler التى تقلب اللام ألف وتُخرج رموز التطويل تالفة، ثم رُتّبت الحروف منطقياً (مقاطع الأرقام واللاتينية تُترك كما هى، ومقاطع العربية تُعكس)،
-- وأُعيد تركيب الفقرات والبنود بإحداثيات الأسطر (بداية الفقرة أو البند سطر مُزاح عن الهامش الأيمن بمقدار ثابت فى كل صفحات الملف).
-- حُذفت ترويسة الصفحات وأرقام الصفحات وسطر جهة الإصدار "مجلس إدارة الهيئة العامة للرقابة المالية"؛ وعنوان القرار وبيان نشره بالوقائع فى hierarchical_location للديباجة. التوقيع باقٍ فى المادة 9 كما طُبع ("رئيس مجلس إدارة / الهيئة العامة للرقابة المالية / د. محمد فريد صالح").
-- أُبقيت كتابة الأصل وأخطاؤه كما طُبعت ("يسرى أحكام هذا القرار" بالمادة 1، و"في" و"فى" معاً، والمسافة قبل النقطة فى مواضع، والشرطتان "-" و"–" فى المادة 3)؛ لم يُعدَّل لفظ واحد. الأرقام لاتينية، والتنوين فى موضعه كما طُبع،
-- وأُسقطت الضمة وغيرها من علامات التشكيل الصغيرة والتطويل، وضُبطت المسافات حول الفاصلة والنقطتين والفاصلة المنقوطة (" ، " و" : " و" ؛ ") وأُضيفت مسافة بين الرقم أو القوس والكلمة الملتصقة به؛ وأرقام البنود "N- ".
-- وقرئ على صور الصفحات موضع التصنيفين "(A)" و"(BBB)" بالمادة 2، وتعبير "(20 مليون جنيه مصرى)" والشرطتين وعلامة "/" فى "المبرم / المزمع إبرامه" بالمادة 3، وسطرا المادة 9 والتوقيع، فصار ما فى النص كما فى الصورة.
-- قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) على صور الصفحات السبع: لم يبق فرق فى ألفاظ غير ضجيج التعرف على الحروف والأرقام والعناوين، وسطر واحد أسقطه التعرف (سطرا المادة 9 "ويُعمل به من اليوم التالى ... ويُلغى كل حكم يخالف أحكامه") قُرئ على صورة الصفحة فوُجد كما فى النص.
--
-- ===== الهيكل =====
-- 10 صفوف، 10 نسخ (version_no = 1): ديباجة (article_no = 0) بالاطلاعات الخمسة (قانون مكافحة غسل الأموال 80 لسنة 2002 ولائحته التنفيذية، والقانون 10 لسنة 2009، وقانون التأمين الموحد 155 لسنة 2024، والقرارين 66 لسنة 2015 و69 لسنة 2025)
-- وموافقة مجلس الإدارة بجلسته بتاريخ 2025/7/30؛ ثم المواد 1 إلى 9 بأرقامها الأصلية وعناوينها (حقل title، "المادة الأولى - نطاق التطبيق" ...؛ والمادة 9 بلا عنوان كما فى الأصل)، بلا hierarchical_location لأن الأصل بلا فصول.
-- أُبقيت المواد بمفاتيحها (1..9، 0) حتى لا تعيد بذور 004/005/006 إدراج المواد القديمة (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2025-08-20: المادة 9 تعمل بالقرار "من اليوم التالى لتاريخ نشره بالوقائع المصرية"، ونشره بالعدد 183 (تابع - أ) بتاريخ 2025/8/19 (ثابت بترويسة كل صفحة). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
-- (المادة 8 تمنح منشآت التأمين ووسطاء إعادة التأمين الأجانب ستة أشهر من تاريخ العمل لتوفيق أوضاعهم، أى حتى 2026/2/20، مع جواز مد الهيئة المهلة لمبررات تقبلها؛ والمادة 9 تنص على "ويُلغى كل حكم يخالف أحكامه" وهو إلغاء ضمنى عام لا يسمّى قراراً.
-- هذه الهجرة تنقل النص كما نُشر ولا تعدّله ولا تمس بيانات laws.)
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (10 صفوف بديباجة سليمة والمادة 9 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، أو علامة مائية، أو ترويسة، أو بقايا تلف،
-- أو محتوى المواد، أو إجمالى الطول 6585 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix170$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[170] القرار 158/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 10
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[170] القرار 158/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[170] أُزيلت % مادة من القرار 158/2025 (نص مخزَّن ملوَّث بعلامة مائية وترويسات صفحات وتلف حروف)', v_n;
  END IF;
END
$fix170$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 158 لسنة 2025 (منشور بالوقائع المصرية العدد 183 تابع (أ) فى 2025/8/19) بشأن شروط ومعايير قيد وسطاء إعادة التأمين الأجانب غير المقيمين$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون مكافحة غسل الأموال الصادر بالقانون رقم 80 لسنة 2002 ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 66 لسنة 2015 بشأن القواعد المنظمة لتعامل شركات التأمين أو إعادة التأمين مع وسطاء التأمين الأجانب ؛
وعلى قرار مجلس إدارة الهيئة رقم 69 لسنة 2025 بشأن القواعد والمعايير المهنية لقيد ومزاولة نشاط الوساطة فى التأمين أو الوساطة فى إعادة التأمين ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/7/30 ؛$b0_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - نطاق التطبيق$t1_0$, $b1_0$يسرى أحكام هذا القرار فى شأن شروط ومعايير قيد وسطاء إعادة التأمين الأجانب غير المقيمين حال رغبتهم في القيد بالقائمة المعدة لهذا الغرض لدى الهيئة .
ولا يجوز لمنشآت التأمين وإعادة التأمين التعامل مع وسطاء إعادة تأمين من غير المقيدين بالقائمة المشار إليها .$b1_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - شروط القيد بالقائمة$t2_0$, $b2_0$يشترط لقيد وسيط إعادة التأمين الأجنبى غير المقيم ، بالقائمة المعدة لهذا الغرض لدى الهيئة استيفاء ما يلي :
1- أن يكون شخصًا اعتباريًا يقع مركزه الرئيسى خارج مصر .
2- أن يكون مرخصًا له فى القيام بأعمال الوساطة فى إعادة التأمين من جهة رقابية تمارس اختصاصات مثيلة للهيئة فى مجال التأمين .
3- ألا يكون قد صدر ضده أى تدابير من الجهة الرقابية الخاضع لها خلال الثلاث سنوات السابقة على طلب القيد بالقائمة .
4- ألا تقل حقوق ملكيته عن رأس ماله المصدر والمدفوع وفقًا لآخر قوائم مالية.
5- أن يكون لديه خبرة سابقة فى مجال الوساطة فى إعادة التأمين ، وأن يكون لديه سابقة أعمال مع إحدى شركات إعادة التأمين الأجنبية التى لا يقل تصنيفها عن (A) وتعمل بدولة لا يقل تصنيفها الائتمانى الدولى عن (BBB) أو ما يناظرها ، وأن يكون لديه فريق عمل من ذوى الخبرة والكفاءة فى مجال إعادة التأمين والوساطة فى إعادة التأمين .
6- ألا يكون أى من مؤسسيه أو مساهميه الرئيسيين أو المستفيدين النهائيين أو أعضاء مجلس إدارته ، مدرجًا بالقوائم السلبية المتعلقة بالعقوبات المحلية أو الدولية.
7- سداد مقابل خدمات فحص ودراسة طلب القيد أو تجديده بواقع مبلغ قدره (خمسة وعشرون ألف جنيه) أو ما يعادله بالعملات الأجنبية المعتمدة لدى البنك المركزى المصري .$b2_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - إجراءات التقدم للقيد بالقائمة$t3_0$, $b3_0$يقدم طلب القيد بالقائمة المشار إليها مرفقًا به المستندات الدالة على استيفاء الشروط المنصوص عليها بالمادة الثانية من هذا القرار ، بالإضافة إلى ما يلي :
1- نموذج عقد خدمات الوساطة فى إعادة التأمين المبرم / المزمع إبرامه بين الوسيط والمنشآت العاملة فى سوق التأمين المصرى لعمليات إعادة التأمين الاتفاقي.
2- دراسة جدوى فنية تتعلق بنشاط الوسيط فى سوق التأمين المصري ، على أن تتضمن - بحد أدنى – خطة عمله وخطته التشغيلية المستهدفة ومدى مساهمته فى نقل الخبرات الفنية ، ويجوز للهيئة أن تطلب من الوسيط إعداد عرض تقديمى واف لمشتملات دراسة الجدوى.
3- وثيقة تأمين مسئولية مهنية لدى إحدى شركات التأمين العاملة فى مصر بحدود مسئولية قدرها (20 مليون جنيه مصرى) عند القيد لأول مرة ، وعند التجديد تحدد قيمة الوثيقة بمتوسط أعمال الوسيط فى مصر عن الثلاث سنوات السابقة .
4- بيان بالعمليات التى قام الوسيط بالتوسط فيها لمنشآت التأمين وإعادة التأمين المصرية خلال الثلاث سنوات السابقة على طلب القيد ، على أن يتضمن الشركات التى تعامل معها ، وقيمة الأرصدة المحصلة من منشآت التأمين وإعادة التأمين المصرية ، وأرصدة التعويضات المستحقة لهم ، ويستثنى من هذا البند الوسطاء الراغبين فى التعامل لأول مرة.
5- بيان معتمد يتضمن هيكل ملكية الوسيط وأسماء أعضاء مجلس إدارته والمديرين التنفيذيين ووسائل الاتصال بهم ؛ بما يمكن الهيئة من التعرف على المستفيد النهائي ، مع التعهد بإخطار الهيئة حال تعديل أى من تلك البيانات فور تعديلها.
6- آخر قوائم مالية للوسيط باللغة العربية أو الإنجليزية.
7- إفادة من شركات إعادة التأمين التى يتعامل معها الوسيط تفيد تفويضه فى تحصيل الأقساط وسداد التعويضات نيابة عنهم .
8- أى بيانات أو مستندات أخرى ترى الهيئة ضرورة تقديمها للبت فى الطلب.$b3_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - مدة القيد بالقائمة وتجديدها$t4_0$, $b4_0$تكون مدة القيد بالقائمة ثلاث سنوات ، ويجوز تجديدها لمدد أخرى مماثلة شريطة استمرار توافر الشروط المتطلبة للقيد وتقديم المستندات المشار إليها بالمادة السابقة فيما عدا البند (2) منها .$b4_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - التزامات وسطاء إعادة التأمين المقيدين لدى الهيئة$t5_0$, $b5_0$يلتزم وسيط إعادة التأمين المقيد لدى الهيئة بما يلي :
1- الامتثال للتشريعات الصادرة ذات الصلة بنشاطه وكذا المتعلقة بمكافحة غسل الأموال وتمويل الإرهاب .
2- عدم إسناد أى عمليات إعادة تأمين وفقًا لأحكام هذا القرار إلا لمعيدى التأمين المقيدين لدى الهيئة .
3- تجنب تعارض المصالح والحفاظ على سرية البيانات وخصوصية المعلومات المتعلقة بالتعاقد مع منشآت التأمين وإعادة التأمين .
4- تقديم النصح والمشورة إلى منشآت التأمين وإعادة التأمين بشأن برامج إعادة التأمين المتاحة فى أسواق التأمين وإعادة التأمين ؛ سواء المحلية أو الأجنبية ، مع إيضاح أسباب اختيار تلك البرامج وشرح ما تتضمنه من شروط واستثناءات ، وتقديم مقارنة بين التغطيات والأسعار الواردة بها وغيرها من البرامج البديلة ، متى طلب منه ذلك .
5- الإفصاح لمنشآت التأمين وإعادة التأمين عن أسماء شركات (فروع شركات) إعادة التأمين الذين اكتتبوا فى الخطر ، مع بيان نسبة اكتتاب كل منهم ، وأية عمولات أو خصومات أو امتيازات لكل شركة (فرع) إعادة التأمين على حدة ، وذلك فور الانتهاء من توزيع الخطر ، وتقديم المستندات التى تثبت قبولهم للخطر .
6- المساعدة فى توزيع الأخطار بين أسواق إعادة التأمين المختلفة .
7- المساهمة فى المفاوضات الخاصة بتسوية المطالبات والمنازعات القائمة بين منشآت التأمين أو إعادة التأمين وشركات (فروع شركات) إعادة التأمين .
8- إخطار منشآت التأمين وإعادة التأمين فورًا بأى أسباب قد تؤثر على التزامات معيدى التأمين بتعويض الأخطار المسندة إليهم .
9- إخطار الهيئة حال وجود أى تغيير فى الشروط أو المستندات المتطلبة للقيد لدى الهيئة أو تجديده ، وكذا موافاة الهيئة بأى بيانات أو مستندات تطلبها خلال الأجل الذى تحدده .$b5_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - التزامات منشآت التأمين وإعادة التأمين عند تعاملها مع وسطاء إعادة التأمين$t6_0$, $b6_0$تلتزم منشآت التأمين وإعادة التأمين عند تعاملها مع وسطاء إعادة التأمين بما يلي :
1- موافاة الهيئة بصورة من عقد خدمات الوساطة فى إعادة التأمين الاتفاقى المبرم مع الوسيط .
2- إخطار الهيئة فورًا بأى مخالفات يرتكبها الوسيط بما فى ذلك مخالفته لأى من التشريعات الحاكمة للنشاط .
3- إخطار الهيئة فور انتهاء تعاقدها مع الوسيط ، أيًا كان سببه.$b6_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - التدابير الإدارية$t7_0$, $b7_0$لمجلس إدارة الهيئة حال ثبوت مخالفة الوسيط أو إخلاله بالالتزامات المقررة عليه أو لأى من تعهداته المقدمة للهيئة أو فقد أحد شروط القيد بالقائمة ، اتخاذ أى من التدابير الآتية :
1- توجيه إنذار بالمخالفات المنسوبة له وتحديد الفترة الزمنية اللازمة لإزالة أسبابها .
2- الإيقاف المؤقت عن قبول عمليات جديدة لمدة لا تزيد على ثلاث سنوات.
3- الشطب من القائمة ، مع عدم جواز إعادة القيد مرة أخرى إلا بعد انقضاء مدة لا تقل عن ستة أشهر ولا تزيد على خمس سنوات.
4- الشطب النهائى من القائمة.
كما يجوز شطب الوسيط حال عدم قيامه بالتوسط فى عمليات إعادة التأمين لصالح منشآت تأمين أو إعادة تأمين مصرية خلال ثلاث سنوات متتالية ، دون تقديم مبرر تقبله الهيئة.
وفى جميع الأحوال ، لا يخل شطب الوسيط من القائمة من تنفيذ كافة التزاماته تجاه المنشآت المتعاقد معها.$b7_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة - توفيق الأوضاع$t8_0$, $b8_0$تلتزم منشآت التأمين وإعادة التأمين ووسطاء إعادة التأمين الأجانب غير المقيمين ، بتوفيق أوضاعهم وفقًا لأحكام هذا القرار خلال ستة أشهر من تاريخ العمل به ، ويجوز للهيئة مد هذه المهلة فى ضوء مبررات تقبلها.$b8_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة$t9_0$, $b9_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية ، ويلغى كل حكم يخالف أحكامه .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b9_0$
  FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-08-20', 'active' FROM ins9_0;

DO $verify170$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 158 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[170] القرار 158/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 10 THEN RAISE EXCEPTION '[170] عدد المواد % بدل 10', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-08-20';
  IF v_v <> 10 THEN RAISE EXCEPTION '[170] عدد النسخ % بدل 10', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%األ%' OR body LIKE '%اإل%' OR body LIKE '%اآل%' OR body LIKE '%خالل%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%الوقائع المصرية -%' OR body LIKE '%العدد 183%' OR body LIKE '%أغسطس سنة 2025%' OR body LIKE '%صورة إ%' OR body LIKE '%ة ال يع%' OR body LIKE '%ل تداول%' OR body LIKE '% ً%' OR body LIKE '%���%' OR body LIKE '%A) (%' OR body LIKE '%BBB) (%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[170] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون مكافحة غسل الأموال الصا%' AND body LIKE '%ته المنعقدة بتاريخ 2025/7/30 ؛' AND body LIKE '%رقم 80 لسنة 2002%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 155 لسنة 2024%' AND body LIKE '%رقم 66 لسنة 2015%' AND body LIKE '%رقم 69 لسنة 2025%' AND body LIKE '%بتاريخ 2025/7/30 ؛%') THEN RAISE EXCEPTION '[170] ديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يسرى أحكام هذا القرار فى شأن شروط ومعايير قيد%' AND body LIKE '%مقيدين بالقائمة المشار إليها .' AND body LIKE '%يسرى أحكام هذا القرار%' AND body LIKE '%المشار إليها .%') THEN RAISE EXCEPTION '[170] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يشترط لقيد وسيط إعادة التأمين الأجنبى غير الم%' AND body LIKE '%مدة لدى البنك المركزى المصري .' AND body LIKE '%عن (A) وتعمل%' AND body LIKE '%عن (BBB) أو ما يناظرها%' AND body LIKE '%خمسة وعشرون ألف جنيه%' AND body LIKE '%7- سداد مقابل%') THEN RAISE EXCEPTION '[170] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يقدم طلب القيد بالقائمة المشار إليها مرفقًا ب%' AND body LIKE '%ة ضرورة تقديمها للبت فى الطلب.' AND body LIKE '%المبرم / المزمع إبرامه%' AND body LIKE '%(20 مليون جنيه مصرى)%' AND body LIKE '%- بحد أدنى – خطة عمله%' AND body LIKE '%8- أى بيانات%') THEN RAISE EXCEPTION '[170] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'تكون مدة القيد بالقائمة ثلاث سنوات ، ويجوز تج%' AND body LIKE '%ابقة فيما عدا البند (2) منها .' AND body LIKE '%ثلاث سنوات ، ويجوز تجديدها%' AND body LIKE '%فيما عدا البند (2) منها .%') THEN RAISE EXCEPTION '[170] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يلتزم وسيط إعادة التأمين المقيد لدى الهيئة بم%' AND body LIKE '%تطلبها خلال الأجل الذى تحدده .' AND body LIKE '%9- إخطار الهيئة%' AND body LIKE '%(فروع شركات)%') THEN RAISE EXCEPTION '[170] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'تلتزم منشآت التأمين وإعادة التأمين عند تعامله%' AND body LIKE '%دها مع الوسيط ، أيًا كان سببه.' AND body LIKE '%3- إخطار الهيئة فور انتهاء تعاقدها%') THEN RAISE EXCEPTION '[170] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'لمجلس إدارة الهيئة حال ثبوت مخالفة الوسيط أو%' AND body LIKE '%ته تجاه المنشآت المتعاقد معها.' AND body LIKE '%4- الشطب النهائى من القائمة.%' AND body LIKE '%خمس سنوات.%') THEN RAISE EXCEPTION '[170] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'تلتزم منشآت التأمين وإعادة التأمين ووسطاء إعا%' AND body LIKE '%ه المهلة فى ضوء مبررات تقبلها.' AND body LIKE '%خلال ستة أشهر من تاريخ العمل به%') THEN RAISE EXCEPTION '[170] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية وعلى الموق%' AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%ويعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية ، ويلغى كل حكم يخالف أحكامه .%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[170] المادة 9 غير سليم'; END IF;
  IF v_len <> 6585 THEN RAISE EXCEPTION '[170] إجمالى طول المواد % بدل 6585', v_len; END IF;
  RAISE NOTICE '[170] القرار 158/2025: 10 مواد و10 نسخ، إجمالى % حرف', v_len;
END
$verify170$;

COMMIT;
