-- 146_replace_decision_278_2025_non_bank_finance_debt_collection_companies_registry_single_article_with_preamble_and_nine_articles.sql
--
-- إعادة هيكلة قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (278) لسنة 2025 (موافقة المجلس بتاريخ 2025/11/26،
-- منشور بالوقائع المصرية العدد 17 (تابع) فى 21 يناير 2026) بشأن ضوابط القيد لدى الهيئة للشركات الراغبة فى تحصيل
-- المستحقات المالية للشركات والجهات العاملة فى مجال أنشطة التمويل غير المصرفى.
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2 - المجموعة أ) =====
-- مخزَّن بالهجرة 042 كمادة واحدة (article_no = 1) تحوى القرار كله (تسع مواد وتوقيع)، بلا ديباجة مستقلة ولا مواد، ولا صف
-- article_versions. والمتن نفسه سليم (طبقة نصية حقيقية) لكنه ملوَّث بترويسات صفحات الوقائع ("الوقائع المصریة – العدد ) 17
-- تابع( فى 21 ینایر سنة 2026") وأرقام الصفحات (2-7) داخل المتن بأرقام هندية، وبقايا تقطيع الكلمات ("مرفق ًـا" و"يوما ً" و"نقدا ً"
-- و"وفق ًا")، مما يضعف الاسترجاع (الاستشهاد بمادة بعينها ممتنع لأن كل القرار مادة واحدة) ويلوث الاقتباس. وعنوان المادة المخزَّن
-- يحمل "ملاحظة شفافية" عن طعن قضائى أمام مجلس الدولة أدخلتها الهجرة 042 من بحث ويب منفصل؛ لم يتحقق منها هنا (لا ترد
-- فى الملف) فلا تُنقل إلى متن القرار ولا عناوين مواده، وإن لزم توثيقها فمكانها بيانات laws بعد التحقق من مصدر موثوق.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (6 صفحات، قُدِّم من صاحب المشروع؛ يُصلح بـ qpdf لتلف جدول xref). قوبل المتن المخزَّن بطبقة النص
-- المستخرجة (تطبيع NFKC وإزالة علامات الاتجاه والأرقام الهندية) كلمة بكلمة فتطابقا تماماً (1280 كلمة)، ثم قُرئت الصفحات
-- الست بصرياً (130 dpi) للتأكد من الأرقام الجوهرية: القوانين 159/1981 و148/2001 و80/2002 و10/2009 و141/2014 و176/2018
-- و18/2020، جلسة 2025/11/26، رأس المال 10 ملايين وحقوق الملكية 20 مليون جنيه، ثلاث سنوات سابقة وللمدة، مقابل الخدمات
-- 25 ألف جنيه، ثلاثون يوماً للبت، ثلاثة أشهر للتجديد، خمسة أيام عمل للتوريد، سنة للإيقاف المؤقت، من ستة أشهر إلى خمس سنوات
-- للشطب، ستة أشهر للتوفيق. حُذفت ترويسات الصفحات وأرقامها، وفُكَّت الحروف المباعدة وعلامات التنوين المنفصلة ("مرفقاً"
-- "وفقاً" "يوماً" "نقداً" "مستوفياً"). أُبقى إملاء المصدر (المسئول، ى فى "القانونى" و"يلى"، "الالتزام"، المسافة قبل علامات الترقيم).
-- الأرقام لاتينية. أُسقطت علامات التشكيل الصغيرة وأُبقى تنوين الفتح. التوقيع داخل المادة التاسعة (رئيس مجلس الإدارة، د/ محمد فريد
-- صالح). عنوان القرار (وموافقة المجلس) فى hierarchical_location للديباجة، وعنوان كل مادة (إنشاء السجل، شروط القيد ...) فى عنوانها.
--
-- ===== الهيكل =====
-- 10 صفوف، 10 نسخ (version_no = 1): ديباجة (article_no = 0)، والمواد 1–9: إنشاء السجل، شروط القيد، إجراءات القيد، مدة
-- القيد وتجديدها، التزامات الشركات المقيدة، التزامات الشركات والجهات العاملة فى التمويل غير المصرفى، التدابير الإدارية،
-- توفيق الأوضاع (ستة أشهر)، النشر والتوقيع. المفتاح (1، 0) محفوظ حتى لا تعيد بذرة 042 إدراج المادة القديمة
-- (ON CONFLICT DO NOTHING).
--
-- ===== التاريخ =====
-- effective_from = 2026-01-22 (اليوم التالى لنشر الوقائع فى 21/1/2026، وفق المادة التاسعة: "ويعمل به من اليوم التالى لتاريخ نشره").
-- لا تُمس بيانات laws (enacted_at = 2026-01-21 هو تاريخ النشر لا الإصدار؛ يُصحَّح فى هجرة laws لاحقة إن لزم).
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (10 مواد بديباجة سليمة والمادة 9 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق
-- الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، بقايا ترويسة أو تنوين منفصل، محتوى المواد، إجمالى الطول 6582 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix146$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[146] القرار 278/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 10
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[146] القرار 278/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[146] أُزيلت % مادة من القرار 278/2025 (القرار كله فى مادة واحدة بترويسات صفحات وأرقام وتنوين منفصل)', v_n;
  END IF;
END
$fix146$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 278 لسنة 2025 (موافقة المجلس بتاريخ 2025/11/26، منشور بالوقائع المصرية العدد 17 تابع فى 2026/1/21) بشأن ضوابط القيد لدى الهيئة للشركات الراغبة في تحصيل المستحقات المالية للشركات والجهات العاملة في مجال أنشطة التمويل غير المصرفي$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد الصادر بالقانون رقم 159 لسنة 1981 ولائحته التنفيذية ؛
وعلى قانون التمويل العقاري الصادر بالقانون رقم 148 لسنة 2001 ولائحته التنفيذية ؛
وعلى قانون مكافحة غسل الأموال الصادر بالقانون رقم 80 لسنة 2002 ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى القانون رقم 141 لسنة 2014 بتنظيم مزاولة نشاط تمويل المشروعات المتوسطة والصغيرة ومتناهية الصغر ؛
وعلى قانون تنظيم نشاطي التأجير التمويلي والتخصيم الصادر بالقانون رقم 176 لسنة 2018 ؛
وعلى قانون تنظيم نشاط التمويل الاستهلاكي الصادر بالقانون رقم 18 لسنة 2020 ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/11/26 ؛
قرر :$b0_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - إنشاء السجل$t1_0$, $b1_0$ينشأ بالهيئة سجل لقيد الشركات الراغبة في مباشرة أعمال تحصيل المستحقات المالية الناشئة عن التمويلات الممنوحة من الشركات والجهات العاملة في مجال أنشطة التمويل غير المصرفي لعملائها ، ويتضمن السجل - بحد أدنى – البيانات الآتية :
1- اسم الشركة وشكلها القانوني وغرضها .
2- عنوان المركز الرئيسي لها .
3- اسم العضو المنتدب أو المسئول القائم بالإدارة التنفيذية بالشركة ، وممثلها القانونى .
4- بيانات التواصل .
ويحظر على الشركات والجهات العاملة في مجال أنشطة التمويل غير المصرفي الاستعانة بغير الشركات المقيدة بالسجل لتحصيل مستحقاتها المالية قبل عملائها .$b1_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - شروط قيد الشركات بالسجل$t2_0$, $b2_0$يشترط في الشركات الراغبة في القيد بالسجل استيفاء الشروط الآتية :
1- أن تتخذ أحد الأشكال القانونية للشركات التجارية وأن يكون من ضمن أغراضها القيام بمهام تحصيل المستحقات المالية .
2- ألا يقل رأس مالها المصدر والمدفوع عن عشرة ملايين جنيه أو ما يعادله بالعملات الأجنبية .
3- ألا تقل حقوق ملكية الشركة عن عشرين مليون جنيه ، وفي حال عدم توافر هذا الشرط يجب ألا تقل مدة مباشرة الشركة للنشاط عن ثلاث سنوات سابقة على تاريخ طلب القيد في السجل . وفي جميع الأحوال ، يجب ألا تقل حقوق الملكية عن رأس المال المدفوع للشركة .
4- أن يكون المسئول عن الإدارة التنفيذية بالشركة محمود السيرة ، حسن السمعة .
5- حصول المسئول عن الإدارة التنفيذية أو القائمين بالتحصيل بالشركة على الدورات التدريبية التي تحددها الهيئة .
6- ألا يكون قد صدر ضد الشركة أو القائم بالإدارة التنفيذية بها حكم نهائي في جناية أو في جنحة في جريمة ماسة بالشرف أو الأمانة أو في إحدى الجرائم المنصوص عليها في قوانين الشركات أو التجارة أو القوانين المنظمة للأنشطة المالية غير المصرفية لأسباب تتعلق بنشاط الشركة أو حكم بإشهار إفلاسه ما لم يكن قد رد إليه اعتباره ، وذلك خلال الثلاث سنوات السابقة على تقديم طلب القيد .
7- سداد مقابل خدمات فحص ودراسة طلب القيد وتجديده لدى الهيئة بواقع مبلغ خمسة وعشرين ألف جنيه .$b2_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - إجراءات القيد$t3_0$, $b3_0$على الشركات الراغبة في القيد بالسجل التقدم بطلب بذلك للهيئة مرفقاً به المستندات الدالة على استيفاء الشروط المشار إليها بالمادة الثانية من هذا القرار ، بالإضافة إلى ما يلى :
1- نسخة محدثة من النظام الأساسي للشركة .
2- آخر قوائم مالية للشركة معتمدة مرفقاً بها تقرير من مراقب حسابات الشركة أو آخر مركز مالي معتمد سابق على تاريخ طلب القيد بالسجل ، بحسب الأحوال .
3- العقود السابق إبرامها لتقديم خدمات التحصيل مع الشركات والجهات العاملة في مجال التمويل أو غيرها من الجهات .
4- أي بيانات أو مستندات أخرى ترى الهيئة ضرورة تقديمها للبت في الطلب .
وتتولى الهيئة دراسة الطلب والبت فيه خلال ثلاثين يوماً على الأكثر من تاريخ تقديمه مستوفياً .$b3_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - مدة القيد بالسجل وتجديدها$t4_0$, $b4_0$تكون مدة القيد بالسجل ثلاث سنوات وتجدد لمدد مماثلة شريطة توافر متطلبات القيد المشار إليها بهذا القرار ، ويتم تقديم طلب تجديد القيد خلال الثلاثة أشهر السابقة على انتهاء مدة القيد .$b4_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - التزامات الشركات المقيدة بالسجل$t5_0$, $b5_0$تلتزم الشركات المقيدة بالسجل بمراعاة مبادئ الأمانة والنزاهة ، وعليها بذل عناية الرجل الحريص في جميع أعمالها والامتناع عن القيام بأي فعل ينطوي على إساءة إلى الشركات أو الجهات العاملة في مجال أنشطة التمويل غير المصرفي أو عملائهم ، ويجب على الشركات المقيدة بالسجل الالتزام على وجه الأخص بما يلى :
1- الحصول على موافقة الهيئة المسبقة على العقد المزمع إبرامه مع شركات أو جهات التمويل غير المصرفي .
2- الاقتصار على القيام بتحصيل المستحقات المالية للجهات والشركات المتعاقد معها ، ويحظر عليهم ممارسة أي مهام تتعلق بنشاط التمويل .
3- الامتناع عن تحصيل أي مبالغ بأي وسيلة ينتج عنها إضافة تلك المبالغ إلى حساباتهم الخاصة ، وعليهم تحصيل المبالغ المستحقة من العملاء من خلال ماكينات نقاط الدفع المسلمة إليهم من الشركة أو الجهة المتعاقد معها أو من خلال أي وسيلة دفع غير نقدي خاصة بتلك الشركة أو الجهة ، أو بموجب شيكات صادرة من العملاء لصالح الشركة أو الجهة .
4- الامتناع عن تسلم أي مبالغ نقداً من العملاء إلا في الحدود المقررة بقانون تنظيم استخدام وسائل الدفع غير النقدي ولائحته التنفيذية وبموجب إيصالات معتمدة من الشركة ومسلمة إليهم كعهدة شخصية مع الالتزام بتسليم أصل الإيصال للعميل ، وتقديم صورة منه للشركة / الجهة موقعة من العميل بما يفيد استلامه الأصل ، مع الالتزام بتوريد المبالغ المحصلة إلى الشركة / الجهة خلال خمسة أيام عمل على الأكثر من تاريخ التحصيل .
5- المحافظة على السرية التامة للبيانات والمعلومات الخاصة بالعملاء ، وعدم إفشائها أو الإفصاح عنها للغير إلا في الحالات التي تطلب فيها الهيئة تقديم معلومات محددة لها بشأنها .
6- موافاة الهيئة بتقرير نصف سنوي عن نتائج أعمالهم يتضمن على وجه الخصوص بيان بالشركات والجهات التي تم التعاقد معها ، وبيانات العملاء الذين تم التحصيل منهم لصالح كل شركة أو جهة وقيمة المبالغ المحصلة وطريقة التحصيل ، كما تلتزم الشركات المقيدة بالسجل بتقديم البيانات المشار إليها للهيئة متى طلبت ذلك .$b5_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - التزامات الشركات والجهات العاملة في مجال أنشطة التمويل غير المصرفي$t6_0$, $b6_0$تلتزم الشركات والجهات العاملة في مجال أنشطة التمويل غير المصرفي عند التعامل مع الشركات المقيدة بالسجل ، بما يلي :
1- موافاة العميل بالبيانات الخاصة بشركة التحصيل التي يجوز له السداد لها ووسائل التحقق من هوية المحصلين بها ، وبيانات التواصل معهم ، والبيانات التي يحظر على العميل الإفصاح عنها لهم .
2- قصر تكليف الشركات المقيدة بالسجل على الأعمال المتعلقة بتحصيل المستحقات المالية الناشئة قبل عملائهم ، وعدم إسناد أي مهام تتعلق بنشاط التمويل لهم .
3- اتخاذ كافة الإجراءات اللازمة لضمان حقوقها قبل شركة التحصيل .
4- النظر والبت في الشكاوى المقدمة من عملائها ضد شركات التحصيل ، واتخاذ الإجراءات التصحيحية المناسبة .
5- موافاة الهيئة بتقرير نصف سنوي يتضمن بيان بشركات التحصيل المتعاقد معها والمبالغ المحصلة من كل منهم وبيانات العملاء المحصل منهم والموقع الجغرافي لهم ، كما تلتزم تلك الشركات والجهات بتقديم البيانات المشار إليها للهيئة متى طلبت ذلك .
6- إخطار الهيئة حال ارتكاب شركات التحصيل لأى مخالفات تتعلق بممارستهم لمهام التحصيل .$b6_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - التدابير الإدارية$t7_0$, $b7_0$لرئيس مجلس إدارة الهيئة حال مخالفة الشركات المقيدة بالسجل لأحكام هذا القرار أو مخالفة أي من القرارات ذات الصلة الصادرة عن الهيئة ، اتخاذ أي من التدابير الآتية :
1- الإنذار .
2- الإيقاف المؤقت للقيد بالسجل لمدة لا تجاوز سنة .
3- شطب القيد من السجل ، مع عدم جواز إعادة القيد مرة أخرى إلا بعد انقضاء فترة لا تقل عن ستة أشهر ولا تزيد على خمس سنوات .
4- الشطب النهائي من السجل .$b7_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة$t8_0$, $b8_0$تلتزم الشركات والجهات العاملة في مجال أنشطة التمويل غير المصرفي بتوفيق أوضاعها وفقاً لأحكام هذا القرار خلال ستة أشهر من تاريخ العمل به .$b8_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة$t9_0$, $b9_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره .
رئيس مجلس الإدارة
الهيئة العامة للرقابة المالية
د/ محمد فريد صالح$b9_0$
  FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-22', 'active' FROM ins9_0;

DO $verify146$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 278 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[146] القرار 278/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 10 THEN RAISE EXCEPTION '[146] عدد المواد % بدل 10', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2026-01-22';
  IF v_v <> 10 THEN RAISE EXCEPTION '[146] عدد النسخ % بدل 10', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%العدد 17%' OR body LIKE '%العدد ) 17%' OR body LIKE '%تابع%' OR body LIKE '%ینایر%' OR body LIKE '%المصریة%' OR body LIKE '% ً%' OR body LIKE '%ـ%' OR body LIKE '%٢٠٢٦%' OR body LIKE '%محل طعن%' OR body LIKE '%ملاحظة شفافية%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[146] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%رقم 159 لسنة 1981%' AND body LIKE '%رقم 148 لسنة 2001%' AND body LIKE '%رقم 80 لسنة 2002%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%رقم 141 لسنة 2014%' AND body LIKE '%رقم 176 لسنة 2018%' AND body LIKE '%رقم 18 لسنة 2020%' AND body LIKE '%بتاريخ 2025/11/26 ؛%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[146] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'ينشأ بالهيئة سجل لقيد الشركات%' AND body LIKE '%4- بيانات التواصل .%' AND body LIKE '%لتحصيل مستحقاتها المالية قبل عملائها .') THEN RAISE EXCEPTION '[146] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يشترط في الشركات الراغبة%' AND body LIKE '%عن عشرة ملايين جنيه%' AND body LIKE '%عن عشرين مليون جنيه%ثلاث سنوات سابقة%' AND body LIKE '%7- سداد مقابل خدمات فحص%خمسة وعشرين ألف جنيه .') THEN RAISE EXCEPTION '[146] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'على الشركات الراغبة في القيد بالسجل%' AND body LIKE '%بالمادة الثانية من هذا القرار%' AND body LIKE '%خلال ثلاثين يوماً على الأكثر%مستوفياً .') THEN RAISE EXCEPTION '[146] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'تكون مدة القيد بالسجل ثلاث سنوات%' AND body LIKE '%خلال الثلاثة أشهر السابقة على انتهاء مدة القيد .') THEN RAISE EXCEPTION '[146] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات المقيدة بالسجل بمراعاة%' AND body LIKE '%1- الحصول على موافقة الهيئة المسبقة%' AND body LIKE '%خمسة أيام عمل على الأكثر من تاريخ التحصيل .%' AND body LIKE '%6- موافاة الهيئة بتقرير نصف سنوي%متى طلبت ذلك .') THEN RAISE EXCEPTION '[146] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات والجهات العاملة%' AND body LIKE '%1- موافاة العميل بالبيانات%' AND body LIKE '%6- إخطار الهيئة حال ارتكاب شركات التحصيل%لمهام التحصيل .') THEN RAISE EXCEPTION '[146] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'لرئيس مجلس إدارة الهيئة حال مخالفة%' AND body LIKE '%لمدة لا تجاوز سنة .%' AND body LIKE '%ستة أشهر ولا تزيد على خمس سنوات .%' AND body LIKE '%4- الشطب النهائي من السجل .') THEN RAISE EXCEPTION '[146] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'تلتزم الشركات والجهات العاملة%' AND body LIKE '%خلال ستة أشهر من تاريخ العمل به .') THEN RAISE EXCEPTION '[146] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية%' AND body LIKE '%من اليوم التالي لتاريخ نشره .%' AND body LIKE '%د/ محمد فريد صالح') THEN RAISE EXCEPTION '[146] المادة 9 غير سليم'; END IF;
  IF v_len <> 6582 THEN RAISE EXCEPTION '[146] إجمالى طول المواد % بدل 6582', v_len; END IF;
  RAISE NOTICE '[146] القرار 278/2025: 10 مواد و10 نسخ، إجمالى % حرف', v_len;
END
$verify146$;

COMMIT;
