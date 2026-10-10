-- 197_replace_decision_31_2024_carbon_credits_listing_and_delisting_rules_on_egyptian_exchanges_stored_in_english_only_as_non_official_translation_without_amendment.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (31) لسنة 2024 بتاريخ 2024/1/31 بشأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية، بالنص الموحد "وفقا لأخر تعديل بتاريخ 2024/10/30"
-- (تعديل بقرار مجلس إدارة الهيئة رقم 252 بتاريخ 2024/10/30) كما نشرته الهيئة على موقعها.
--
-- ===== الحالة السابقة (بذور 039 وما بعدها) =====
-- مخزَّن بصف واحد (article_no = 1، article_suffix_order = 0، 11229 حرفاً) كله بالإنجليزية، وعنوان القانون فى laws ورابط official_url بالإنجليزية أيضاً، فلا يجد البحث العربى ولا المساعد أى نص للقرار. وهو ترجمة إنجليزية غير رسمية لا تمثل نص الهيئة:
-- بعشر مواد مترجمة وتوقيع مطبوع "Dr. Mohamed Fareed Saleh" وبلا هوامش ولا عبارة تعديل. وهى ترجمة غير رسمية تخالف نص الهيئة فى مواضع جوهرية، منها (على سبيل المثال لا الحصر):
--   * المادة 3: بلا الفقرتين الأخيرتين (إجازة تسجيل المشروعات الجديدة قبل إصدار تقارير المصادقة بشرط موافاة الهيئة بنسخة منها خلال سنة وإلا اعتبر التسجيل كأن لم يكن، وإجازة مد المهلة) المضافتين بقرار 252/2024؛ والبند 3 يضيف تقييداً غير وارد ("that require an Environmental Impact Assessment as by National Environmental Law")؛
--   * المادة 4: البند 4 يضيف "including the coordinates" غير الواردة؛ والمدة "within five days" بدل "خمسة أيام عمل"؛
--   * المادة 2: تعريفات بصياغات مختلفة (البند 5 "Operators" بمواصفات غير واردة، والبند 8 بعبارة "traded carbon credits and forward contracts" بدل "عمليات التسوية الورقية والمالية"، والبند 2 "Reduction or Removal"، وتسمية "Carbon Market" بدل "سوق شهادات خفض الانبعاثات الكربونية")، وحرف "ICORA" بدل "ICROA"؛
-- (أُعيدت كتابة المتن كله من الأصل ولم يُعتمد على المخزَّن أساساً.)
--
-- ===== المصدر والمنهجية =====
-- PDF الهيئة الموحد (5 صفحات، منتَج بـ Word، بطبقة نصية فيها وصلات مقلوبة وتطويل وسقوط بعض الحروف وانفصال علامات التنوين). نُقل النص كاملاً من صور الصفحات بصرياً (200 dpi، كل صفحة فى ثلاثة أشرطة)، ثم قوبل بالطبقة النصية بمفاتيح الحروف المرتبة لكل كلمة
-- (بالتمييز بين الهمزات والياء والألف المقصورة) وبكل الأرقام، بمحاذاة تسلسلية؛ فلم يبق فرق فى متن المواد إلا ما سببه انفصال التنوين وبعض الحروف فى الطبقة النصية (دولياً، وفقاً، تُشكل، بناءً، المُعد، المُصدرة) وعناوين الصفحات وأسماء المواد والتوقيع.
-- أُبقى إملاء الأصل وأخطاؤه كما هى: "لدي" بالياء فى مواضع (لدي الهيئة ولدي إحدى ولدي جهات وضع المعايير) و"لدى" بالألف المقصورة فى غيرها ("لدى البورصة")، و"وعلي المالك الأصلي" و"لأعلي سعر" بالياء، و"وفى حالة تأييد" بالألف المقصورة (المادة 9)، و"الجهات مُنشأة سجلات الكربون الطوعية" (البند 5 من المادة 2)،
-- و"المعترف به دولياً" بالإفراد (البند 2)، و"الموقع الالكتروني" بلا همزة فى المادة 10 مقابل "الإلكتروني" فى غيرها، و"المسجل لديها الشهادات" (المادة 4 بند 9)، وقوسا "( Carbon Credits Registries )" و"( Standard Programs)" بمسافات داخلية بخلاف "(Standard Programs)" فى البند 3،
-- حُذفت ترويسة الصفحات وتذييلها وأرقامها وسطر "رئيس الهيئة" وسطر "مجلس إدارة الهيئة العامة للرقابة المالية" وكلمة "قرر" وتوقيع رئيس مجلس الإدارة ("رئيس مجلس إدارة الهيئة العامة للرقابة المالية د. محمد فريد صالح") المطبوع بآخر الصفحة 5. الأرقام لاتينية، وأُسقطت علامات التشكيل الصغيرة والتطويل (ضمة "يُقصد" و"يُشطب" وكسرة "قِبل"
-- وتطويل "بـ") وأُبقى تنوين الفتح مكتوباً على الحرف قبل الألف كباقى الهجرات؛ فصارت "بـ "الشهادات"" و"بـ «اللجنة»" بلا تطويل.
--
-- ===== تعديلات التمثيل (معلنة) =====
--   * العبارات الإنجليزية داخل الجمل العربية (Standard Programs، UNFCCC، ICROA، Carbon Credits Registries، Project Developers، Forward Contracts) كُتبت بترتيبها المقروء الطبيعى. فى البند 3 من المادة 2 يتبع "United Nations Framework Convention on Climate Change (UNFCCC)" عبارة "بتغير المناخ"
--     مباشرة ثم "والمنهجيات المعتمدة من قبل International Carbon Reduction and Offset Alliance (ICROA)،"، كما يقرؤها قارئ الصفحة؛ وفى البند 4 تنتهى الجملة بـ "( Standard Programs)." (تتصل النقطة بالقوس المغلق). وهو اختلاف عرض لا لفظ يغطيه فحص الهجرة بأنماط حرفية.
--   * عنوان كل مادة صار حقل title للصف بصيغة "المادة N - عنوان" كما فى الهجرات السابقة (يطبع الأصل "(المادة الأولي)" ثم سطراً بعنوانها؛ المادة 10 بلا عنوان فرعى: "المادة العاشرة")، وأُصحح هجاء رقم المادة الترتيبى فقط ("الأولى" بدل "الأولي" المطبوعة) لأنه تسمية لا نص ملزم.
--     وعلامة الهامش (1) المطبوعة بعد سطر "وفقاً لآخر تعديل بتاريخ 2024/10/30" نُقلت إلى hierarchical_location للديباجة مع عنوان القرار وعبارة "النص الموحد"؛ وعلامة الهامش (2) المطبوعة بعد "وإلا اعتبر التسجيل كأن لم يكن." فى المادة 3 بقيت فى المتن "(2)" بعد النقطة.
--   * قوائم البنود بأرقام "N-" لاتينية، كل بند فى سطر (بدل الترقيم المطبوع "١ -")، والتعريفات العشر فى المادة 2 بعناوينها الغليظة (مثل "سوق شهادات خفض الانبعاثات الكربونية:") نصاً عادياً. الهامشان المطبوعان أسفل الصفحتين 1 و2 جُمعا فى القسم 11 "هوامش التعديلات اللاحقة" بنصهما.
--
-- ===== الهيكل =====
-- 12 صفاً، 12 نسخة (version_no = 1): الديباجة (article_no = 0) بثلاثة اطلاعات وموافقة المجلس بتاريخ 2024/1/31، المواد 1–10 (article_suffix_order = 0)، ثم القسم 11 "هوامش التعديلات اللاحقة" (الهامشان 1 و2). المفتاح (1، 0) هو المفتاح المخزَّن نفسه فلا تعيد بذرة القرار
-- إدراج الصف القديم (إدراج laws فى البذور ON CONFLICT DO NOTHING وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود؛ وقد شُغِّلت كتلة البذرة محلياً فلم تُدرج شيئاً).
--
-- ===== التاريخ والنسخ (قرار تقديرى يُراجَع) =====
-- النص المتاح هو الموحد بعد تعديل 2024/10/30 فقط؛ لا نص أصلى لسنة 2024 ولا نص قرار 252/2024 ولا تاريخ نشره بالوقائع المصرية (المادة 10 تُعمل القرار من اليوم التالى لنشره بالوقائع). فجُعل effective_from = 2024-10-30
-- (تاريخ آخر تعديل المذكور فى المصدر) للنسخ الاثنتى عشرة، وسُجِّل amended_by = 252/2024 مع change_note على المادة 3 وحدها (إضافة الفقرة الثانية بحسب الهامش 2؛ أما الهامش 1 فيذكر التعديل عموماً بلا تحديد موضعه). أثر ذلك: لا نسخة للقرار قبل 2024-10-30 فى الاستعلام بالتاريخ
-- (فجوة معلنة بدل نص معدَّل منسوب لتواريخ سابقة)، كما فى الهجرات السابقة. لاحقاً: رفع نص 2024 الأصلى وقرار 252/2024 لبناء النسخة التاريخية. لا تُمس بيانات laws (العنوان الإنجليزى والرابط الإنجليزى؛ enacted_at مضبوط 2024-01-31 بالفعل
-- وlast_amended_at فارغ) وتُترك لهجرة بيانات laws المؤجلة.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (12 صفاً بديباجة سليمة والقسم 11 موجود)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف
-- (عدد، لفظ مغاير للأصل، أرقام أو علامات هوامش مغايرة، بقايا ترويسة أو تذييل أو توقيع أو وصلات مقلوبة، تاريخ سريان الصفوف وجهة التعديل، إجمالى الطول 7774 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix197$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[197] القرار 31/2024 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 12
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[197] القرار 31/2024 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[197] أُزيلت % مادة من القرار 31/2024 (صف واحد مخزن بالإنجليزية فقط (ترجمة غير رسمية لعشر مواد) بنص مغاير للنص الرسمى ولا يضم الهوامش ولا الفقرتين الأخيرتين من المادة الثالثة)', v_n;
  END IF;
END
$fix197$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (31) لسنة 2024 بتاريخ 2024/1/31 بشأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية (النص الموحد وفقاً لآخر تعديل بتاريخ 2024/10/30) (1)$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون سوق رأس المال الصادر بالقانون رقم (95) لسنة 1992 ولائحته التنفيذية؛
وعلى قرار مجلس إدارة الهيئة رقم (11) لسنة 2014 بشأن قواعد قيد وشطب الأوراق المالية بالبورصة المصرية؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2024/1/31؛$b0_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى - نطاق التطبيق$t1_0$, $b1_0$تسري أحكام هذا القرار في شأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالسوق الطوعية بالبورصات المصرية.$b1_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية - تعريفات$t2_0$, $b2_0$يقصد في تطبيق أحكام هذا القرار بالكلمات والعبارات التالية المعنى المبين قرين كل منها:
1- سوق شهادات خفض الانبعاثات الكربونية: هو سوق طوعي لتداول شهادات خفض الانبعاثات الكربونية بالبورصات المصرية.
2- شهادات خفض الانبعاثات الكربونية: هي أدوات مالية قابلة للتداول تمثل وحدات خفض انبعاثات غازات الاحتباس الحراري، وتمثل كل "وحدة" طنًا من انبعاثات غاز ثاني أكسيد الكربون المكافئ، وتصدر لصالح مطور مشروع الخفض وذلك بعد الانتهاء من أعمال التحقق والمصادقة وفقًا لمعايير ومنهجيات خفض الانبعاثات الكربونية المعترف به دوليًا، التي تقوم بها جهات التحقق والمصادقة سواء المحلية أو الدولية المقيدة بالقائمة المعدة لدي الهيئة لهذا الغرض، ويشار إليها في أحكام هذا القرار ب "الشهادات".
3- جهات وضع المعايير والمنهجيات (Standard Programs): هي الجهات التي تضع أسس ومنهجيات قياس خفض الانبعاثات الكربونية وفقًا لمنهجيات معترف بها دوليًا، ومنها منهجيات اتفاقية الأمم المتحدة الإطارية المعنية بتغير المناخ United Nations Framework Convention on Climate Change (UNFCCC) والمنهجيات المعتمدة من قبل International Carbon Reduction and Offset Alliance (ICROA)، أو وفقًا للمنهجيات المعتمدة محليًا من الجهات الحكومية المختصة في هذا الشأن.
4- سجلات الكربون الطوعية ( Carbon Credits Registries ): هي أنظمة حفظ مركزية إلكترونية تتضمن سجلات لإصدار وتسجيل وتتبع تسلسل نقل ملكية شهادات خفض الانبعاثات الكربونية والناتجة عن تنفيذ مشروعات خفض الانبعاثات الكربونية وفقًا للمنهجيات الصادرة عن جهات وضع المعايير والمنهجيات ( Standard Programs).
5- الجهات منشأة سجلات الكربون الطوعية: هي الجهات المالكة والقائمة على حفظ وإدارة سجلات الكربون الطوعية.
6- مطوري المشروعات (Project Developers): هي الجهات المسؤولة عن تنفيذ مشروعات خفض الانبعاثات الكربونية التي يتم بموجبها إصدار شهادات خفض الانبعاثات الكربونية بسجلات الكربون الطوعية بعد اعتماد جهات التحقق والمصادقة.
7- جهات التحقق والمصادقة: هي الجهات التي تقوم بعمليات التحقق والمصادقة من خلال مراجعة والتحقق من مطابقة المشروع لمتطلبات معايير ومنهجيات الخفض المعتمدة لدي جهات وضع المعايير والمنهجيات.
8- شركات التسوية: هي شركات التسوية والمقاصة المرخص لها من الهيئة للقيام بعمليات التسوية الورقية والمالية لشهادات خفض الانبعاثات الكربونية.
9- اللجنة المختصة: هي لجنة تشكل بالبورصة بقرار من مجلس إدارتها وتختص بالإشراف على عمليات قيد وشطب شهادات خفض الانبعاثات الكربونية، ويشار إليها في هذا القرار ب «اللجنة».
10- طالب القيد: هو مالك الشهادات الراغب في قيدها بالبورصة أو الممثل القانوني له أو من يفوضه.$b2_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة - ضوابط تسجيل مشروعات خفض الانبعاثات الكربونية لدي الهيئة$t3_0$, $b3_0$يقدم طالب القيد طلب للهيئة لتسجيل المشروع على قاعدة بيانات مشروعات خفض الانبعاثات الكربونية الصادر لها أو سيصدر عنها شهادات على النموذج المعد لذلك بالهيئة، وتصدر الهيئة ما يفيد تسجيل المشروع بقاعدة البيانات لديها بعد استيفاء المستندات الآتية:
1- طلب موقع من طالب القيد لتسجيل المشروع في قاعدة بيانات الهيئة.
2- ما يفيد أن الشهادات صادرة بعد سريان اتفاق باريس للمناخ.
3- نسخة من دراسة تقييم الأثر البيئي للمشروع معتمدة من وزارة البيئة بالنسبة للمشروعات التي تكون داخل مصر.
4- نسخة من تقارير جهات التحقق والمصادقة ووثيقة تصميم المشروع بالنسبة للمشروعات الصادر لها شهادات.
5- نسخة من تقارير جهات المصادقة ووثيقة تصميم المشروع أو ما يفيد تسجيل المشروع على أحد سجلات الكربون الطوعية بالنسبة للمشروعات التي سيصدر لها شهادات.
6- أي مستندات إضافية تراها الهيئة لقيد المشروع.
ويجوز تسجيل مشروعات خفض الانبعاثات الكربونية الجديدة بقاعدة البيانات المشار إليها بالفقرة السابقة قبل إصدار تقارير جهات المصادقة لتلك المشروعات، على أن يتم موافاة الهيئة بنسخة من التقارير المشار إليها خلال سنة من تاريخ تسجيل المشروع، وإلا اعتبر التسجيل كأن لم يكن. (2)
ويجوز للهيئة مد المهلة المشار إليها بناءً على مبررات جدية تقبلها الهيئة.$b3_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2024-10-30', 'active', 252, 2024, $c3_0$النص الموحد: إضافة الفقرة الثانية من المادة الثالثة بقرار مجلس إدارة الهيئة رقم (252) بتاريخ 2024/10/30$c3_0$ FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة - تقديم طلب قيد وتداول شهادات خفض الانبعاثات الكربونية بالبورصة$t4_0$, $b4_0$يقدم طالب القيد طلب قيد شهادات خفض الانبعاثات الكربونية لدى البورصة على النموذج المعد لذلك من البورصة، مرفقًا به ما يفيد تسجيل المشروع بقاعدة بيانات مشروعات خفض الانبعاثات الكربونية لدي الهيئة، وكذا ما يفيد فتح حساب لدي إحدى شركات التسوية والمقاصة المرخص لها من قبل الهيئة، بالإضافة إلى مذكرة المعلومات أو تقرير الإفصاح بغرض التداول المعتمد من الهيئة، ويجب أن يتضمن نموذج طلب القيد البيانات الآتية:
1- اسم سجل الكربون الطوعي المسجل به الشهادات.
2- الموقع الإلكتروني للسجل.
3- اسم المشروع والكود التعريفي الخاص به.
4- الموقع الجغرافي للمشروع.
5- اسم مطور المشروع.
6- المدة الزمنية للمشروع.
7- اسم المنهجية المعتمدة والمستخدمة في إصدار الشهادة.
8- عدد الشهادات المصدرة للمشروع وعدد الشهادات المطلوب إتاحتها للتداول بالبورصة وتحويلها لحساب شركة التسوية والمقاصة المرخص لها من قبل الهيئة والسعر المبدئي للشهادة.
9- الرابط الإلكتروني للمشروع على الموقع الإلكتروني لسجل الكربون المسجل لديها الشهادات.
وعلى البورصة نشر طلب قيد الشهادات وفقًا للوسائل المعدة لذلك.
وعلى اللجنة البت في طلب القيد خلال خمسة أيام عمل من تاريخ استيفاء شروط ومتطلبات القيد، ويكون قيد الشهادات بالبورصة بقرار من اللجنة، ويخطر طالب القيد بقرار اللجنة فور صدوره.
ويكون التعامل على الشهادات وفقًا لقواعد وإجراءات التداول التي تضعها البورصة وتعتمدها الهيئة.
وتقوم إدارة البورصة بإخطار الهيئة بجميع القرارات الصادرة عن اللجنة خلال ثلاثة أيام عمل من تاريخ صدورها.$b4_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة - قيد العقود الآجلة لشهادات خفض الانبعاثات الكربونية$t5_0$, $b5_0$يجوز للجهة المالكة أو الممولة لمشروع الخفض التقدم للبورصة بطلب قيد للعقود الآجلة (Forward Contracts) لشهادات خفض الانبعاثات الكربونية التي ستصدر نتيجة لتنفيذ المشروع، ويجب أن يتضمن العقد البيانات الآتية:
1- اسم المشروع والكود التعريفي الخاص به.
2- اسم سجل الكربون الطوعي المسجل به مشروع الخفض.
3- الموقع الجغرافي للمشروع.
4- وصف المشروع.
5- عدد شهادات الكربون المتوقع صدورها سنويًا.
6- التزامات التعاقد والتسليم.
7- الكميات والسعر الاتفاقي وآليات السداد، مع الوضع في الاعتبار حالة الإخلال بالتسليم أو الإخلال بالسداد.
8- البنود الخاصة بالسرية.
وعلى اللجنة البت في طلب القيد خلال خمسة أيام عمل من تاريخ استيفاء شروط ومتطلبات القيد، وبعد التأكد من تسجيل المشروع بقاعدة بيانات مشروعات خفض الانبعاثات الكربونية بالهيئة.
ويكون التعامل على هذه العقود وفقًا لقواعد وإجراءات التداول التي تضعها البورصة وتعتمدها الهيئة.
ويجوز للجهة الممولة للمشروع إشهار حقها قبل الجهة المالكة له بسجل الضمانات المنقولة، وتقوم الجهة القائمة على تسوية العمليات بإخطار السجل بالطرف الدائن مقابل الضمانة المنصوص عليها في العقد.$b5_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة - التزامات الإفصاح بعد القيد$t6_0$, $b6_0$يلتزم مالك الشهادات بالإفصاح الفوري للبورصة عن كافة المعلومات الجوهرية التي يكون لها تأثير ملموس على التعامل في تلك الشهادات بما فيها أية معلومات عن المشروعات المصدرة للشهادات وكذا أي تعديلات تطرأ على الإفصاحات المرفقة بطلب القيد.
وتلتزم شركة التسوية والمقاصة المعنية بموافاة البورصة بأية معلومات أخرى يلزم الإفصاح عنها، وتقوم البورصة بنشر تلك المعلومات للمتعاملين بالوسائل المعدة لذلك.$b6_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة - الشطب الاختياري للشهادات$t7_0$, $b7_0$يشطب قيد كل أو جزء من شهادات خفض الانبعاثات الكربونية بناءً على طلب مالك الشهادات بغرض إعدام تلك الشهادات لصالحه أو لصالح الغير أو لتحويل الشهادات إلى حسابه بسجل الكربون الطوعي وعدم إتاحتها للتداول.$b7_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة - الشطب الإجباري للشهادات$t8_0$, $b8_0$يشطب قيد الشهادات إجباريًا في أي من الحالات الآتية:
1- شطب المشروع من قاعدة بيانات تسجيل مشروعات خفض الانبعاثات بالهيئة.
2- حالات الإخلال الجسيم بأعمال التحقق والمصادقة للمشروع.
3- عدم اكتمال المشروع.
وعلي المالك الأصلي أو ممول المشروع شراء الشهادات من المستثمرين المتضررين من الشطب وفقًا لمتوسط سعر التداول في آخر ستة أشهر قبل قرار الشطب أو وفقًا لأعلي سعر تداول على تلك الشهادات في آخر ثلاثين يومًا قبل قرار الشطب أيهما أعلى.$b8_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة - التظلم من قرارات اللجنة$t9_0$, $b9_0$يجوز لطالب القيد تقديم طلب لمجلس إدارة البورصة بإعادة النظر في قرار اللجنة الصادر برفض القيد أو الشطب خلال خمسة عشر يومًا من تاريخ الإخطار بالقرار، وعلى مجلس إدارة البورصة البت في طلب إعادة النظر في أول جلسة تالية له.
وفى حالة تأييد مجلس إدارة البورصة لقرار اللجنة يجوز لطالب القيد تقديم التماس للهيئة خلال خمسة عشر يومًا من تاريخ إخطاره بقرار مجلس إدارة البورصة.$b9_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins9_0;

WITH ins10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $t10_0$المادة العاشرة$t10_0$, $b10_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الالكتروني للهيئة والبورصة المصرية، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.$b10_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins10_0;

WITH ins11_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, $h11$قرار مجلس إدارة الهيئة رقم (31) لسنة 2024 - هوامش التعديلات اللاحقة$h11$, $t11_0$هوامش التعديلات اللاحقة$t11_0$, $b11_0$(1) تم تعديل القرار بموجب قرار مجلس إدارة الهيئة رقم (252) بتاريخ 2024/10/30.
(2) تم إضافة الفقرة الثانية بموجب قرار مجلس إدارة الهيئة رقم (252) بتاريخ 2024/10/30.$b11_0$
  FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins11_0;

DO $verify197$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 31 AND law_year = 2024 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[197] القرار 31/2024 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 12 THEN RAISE EXCEPTION '[197] عدد المواد % بدل 12', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2024-10-30';
  IF v_v <> 12 THEN RAISE EXCEPTION '[197] عدد النسخ % بدل 12', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%FINANCIAL REGULATORY%' OR body LIKE '%WWW.FRA%' OR body LIKE '%Building Bridges%' OR body LIKE '%القرية الذكية%' OR body LIKE '%قـرر%' OR body LIKE '%جملس%' OR body LIKE '%املالية%' OR body LIKE '%اهليئة%' OR body LIKE '%اإل%' OR body LIKE '%األ%' OR body LIKE '%ا ً%' OR body LIKE '%رررر%' OR body LIKE '%فريد صالح%' OR body LIKE '%�%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[197] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون سوق رأس المال %' AND body LIKE '%ر مجلس إدارة الهيئة رقم (11) لسنة 20%' AND body LIKE '%سته المنعقدة بتاريخ 2024/1/31؛' AND body LIKE '%رقم (95) لسنة 1992%' AND body LIKE '%رقم (11) لسنة 2014%' AND body LIKE '%بتاريخ 2024/1/31؛' AND body LIKE '%بالقانون رقم (95) لسنة 1992 ول%' AND body LIKE '%رقم (95) لسنة 1992 ولائحته التنف%' AND body LIKE '%ة الهيئة رقم (11) لسنة 2014 بش%' AND body LIKE '%رقم (11) لسنة 2014 بشأن قواعد قي%' AND body LIKE '%منعقدة بتاريخ 2024/1/31؛%') THEN RAISE EXCEPTION '[197] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تسري أحكام هذا القرار في شأن قواعد ق%' AND body LIKE '%ام هذا القرار في شأن قواعد قيد وشطب %' AND body LIKE '%سوق الطوعية بالبورصات المصرية.' AND body LIKE '%بالسوق الطوعية بالبورصات المصرية.') THEN RAISE EXCEPTION '[197] المادة الأولى غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يقصد في تطبيق أحكام هذا القرار بالكل%' AND body LIKE '%ت منشأة سجلات الكربون الطوعية: هي ال%' AND body LIKE '%لممثل القانوني له أو من يفوضه.' AND body LIKE '%3- جهات وضع المعايير والمنهجيات (Standard Programs):%' AND body LIKE '%United Nations Framework Convention on Climate Change (UNFCCC) والمنهجيات%' AND body LIKE '%من قبل International Carbon Reduction and Offset Alliance (ICROA)، أو%' AND body LIKE '%4- سجلات الكربون الطوعية ( Carbon Credits Registries ):%' AND body LIKE '%المنهجيات ( Standard Programs).%' AND body LIKE '%5- الجهات منشأة سجلات%' AND body LIKE '%6- مطوري المشروعات (Project Developers):%' AND body LIKE '%ب «اللجنة».%' AND body LIKE '%المعترف به دوليًا،%' AND body LIKE '%لدي الهيئة لهذا الغرض%') THEN RAISE EXCEPTION '[197] المادة الثانية غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يقدم طالب القيد طلب للهيئة لتسجيل ال%' AND body LIKE '%من تقارير جهات التحقق والمصادقة ووثي%' AND body LIKE '%على مبررات جدية تقبلها الهيئة.' AND body LIKE '%كأن لم يكن. (2)%' AND body LIKE '%5- نسخة من تقارير جهات المصادقة%' AND body LIKE '%بناءً على مبررات جدية%' AND body LIKE '% كأن لم يكن. (2)%') THEN RAISE EXCEPTION '[197] المادة الثالثة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يقدم طالب القيد طلب قيد شهادات خفض ا%' AND body LIKE '%لمنهجية المعتمدة والمستخدمة في إصدار%' AND body LIKE '%لاثة أيام عمل من تاريخ صدورها.' AND body LIKE '%لدى البورصة%' AND body LIKE '%لدي الهيئة، وكذا ما يفيد فتح حساب لدي إحدى%' AND body LIKE '%المسجل لديها الشهادات.%' AND body LIKE '%خلال ثلاثة أيام عمل من تاريخ صدورها.') THEN RAISE EXCEPTION '[197] المادة الرابعة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يجوز للجهة المالكة أو الممولة لمشروع%' AND body LIKE '%مات التعاقد والتسليم.%' AND body LIKE '%لضمانة المنصوص عليها في العقد.' AND body LIKE '%(Forward Contracts)%' AND body LIKE '%8- البنود الخاصة بالسرية.%' AND body LIKE '%خلال خمسة أيام عمل من تاريخ استيفاء%') THEN RAISE EXCEPTION '[197] المادة الخامسة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'يلتزم مالك الشهادات بالإفصاح الفوري %' AND body LIKE '%ركة التسوية والمقاصة المعنية بموافاة%' AND body LIKE '%متعاملين بالوسائل المعدة لذلك.' AND body LIKE '%وكذا أي تعديلات تطرأ%') THEN RAISE EXCEPTION '[197] المادة السادسة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'يشطب قيد كل أو جزء من شهادات خفض الا%' AND body LIKE '% كل أو جزء من شهادات خفض الانبعاثات %' AND body LIKE '%ن الطوعي وعدم إتاحتها للتداول.') THEN RAISE EXCEPTION '[197] المادة السابعة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'يشطب قيد الشهادات إجباريًا في أي من %' AND body LIKE '% الإخلال الجسيم بأعمال التحقق والمصا%' AND body LIKE '%مًا قبل قرار الشطب أيهما أعلى.' AND body LIKE '%وعلي المالك الأصلي%' AND body LIKE '%لأعلي سعر تداول%' AND body LIKE '%أيهما أعلى.') THEN RAISE EXCEPTION '[197] المادة الثامنة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'يجوز لطالب القيد تقديم طلب لمجلس إدا%' AND body LIKE '% تأييد مجلس إدارة البورصة لقرار اللج%' AND body LIKE '%طاره بقرار مجلس إدارة البورصة.' AND body LIKE '%وفى حالة تأييد%' AND body LIKE '%خمسة عشر يومًا من تاريخ الإخطار%') THEN RAISE EXCEPTION '[197] المادة التاسعة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية و%' AND body LIKE '% القرار في الوقائع المصرية وعلى المو%' AND body LIKE '% لتاريخ نشره بالوقائع المصرية.' AND body LIKE '%الموقع الالكتروني للهيئة والبورصة المصرية%' AND body LIKE '%بالوقائع المصرية.') THEN RAISE EXCEPTION '[197] المادة العاشرة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND article_suffix_order = 0 AND body LIKE '(1) تم تعديل القرار بموجب قرار مجلس %' AND body LIKE '%ضافة الفقرة الثانية بموجب قرار مجلس %' AND body LIKE '%ة رقم (252) بتاريخ 2024/10/30.' AND body LIKE '(1) تم تعديل القرار بموجب%' AND body LIKE '%(2) تم إضافة الفقرة الثانية%' AND body LIKE '%(252) بتاريخ 2024/10/30.' AND body LIKE '%(1) تم تعديل الق%' AND body LIKE '%ة الهيئة رقم (252) بتاريخ 2024/%' AND body LIKE '% (252) بتاريخ 2024/10/30.%' AND body LIKE '%(2) تم إضافة الف%') THEN RAISE EXCEPTION '[197] الهوامش غير سليم'; END IF;
  IF v_len <> 7774 THEN RAISE EXCEPTION '[197] إجمالى طول المواد % بدل 7774', v_len; END IF;
  RAISE NOTICE '[197] القرار 31/2024: 12 مواد و12 نسخ، إجمالى % حرف', v_len;
END
$verify197$;

COMMIT;
