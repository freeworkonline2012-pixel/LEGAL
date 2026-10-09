-- 153_replace_decision_115_2022_securitization_bonds_backed_by_future_cash_flows_single_article_with_preamble_and_nine_articles.sql
--
-- إعادة هيكلة قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (115) لسنة 2022 بتاريخ 2022/9/27 بشأن الضوابط المنظمة لإصدار سندات توريق مقابل
-- ما ينشأ من تدفقات نقدية مستقبلية.
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2 - المجموعة أ، حالة رمادية) =====
-- مخزَّن بالهجرة 040 كمادة واحدة (article_no = 1، 7208 أحرف) بعنوان "قرار مجلس إدارة الهيئة رقم 115/2022 — ضوابط إصدار سندات..." تحوى القرار كله (العنوان والديباجة
-- والمواد التسع والتوقيع) بلا ديباجة مستقلة ولا مواد، فلا يمكن الاستشهاد بمادة أو بند بعينه (المادة 4 أو 5 أو 8 وهى جوهر الضوابط). وقد أُعدّت نسخته من نقل بصرى سابق
-- لكنها ليست على إملاء الأصل: الألف المقصورة "ى" فى مواضع الياء ("فى" و"الذى" و"التى" و"الآتى" و"المجرى العادى" و"ائتمانى" و"القانونى" و"المركزى" و"الإلكترونى")،
-- وعلامة النسبة مقلوبة ("(%50)" و"(%2)" بدل (50%))، وصياغة موضعين مخالفة للأصل: "1- البيانات الخاصة بالمحيل: وعلى وجه الأخص ما يلى:" بدل "، وعلى وجه الأخص ما يلي:"،
-- و"عدم تعارض المصالح. كما له" بدل "عدم تعارض المصالح، كما له"، 
--
-- ===== المصدر والمنهجية =====
-- PDF الهيئة (5 صفحات، كتاب رسمى بترويسة الهيئة ورئيس الهيئة وختم مكتب رئيس الهيئة، ممسوح ضوئياً بلا طبقة نصية، قدّمه صاحب المشروع). قُرئت الصفحات الخمس بصرياً
-- بدقة 130 نقطة/بوصة مع تكبير المواضع المشتبهة على الصور الأصلية (200 نقطة/بوصة): التصنيف الائتمانى "(-BBB)" فى المادتين 4 و5، "(50%)" و"(2%)"، "اليها" بلا همزة فى المادة 8،
-- ثم قوبل النص المُدخَل بمخرجات OCR مستقلة (tesseract ara) كلمة بكلمة بعد تطبيع الهمزات والياء والأرقام: لا فرق غير ضجيج المسح وبيانات تذييل الصفحات والأختام،
-- وقوبل بالنص المخزَّن فتطابقت الألفاظ كلها (الفروق فى الإملاء وعلامات الترقيم والهيكل فقط). الأرقام والمراجع مطابقة (القانون 95/1992 ولائحته، القانون 10/2009، جلسة 2022/9/27،
-- المادتان 304 و312 من اللائحة التنفيذية لقانون سوق رأس المال، "ثلاثة أيام عمل"، "الثلاث سنوات"، "50%" و"2%"). أُبقى إملاء الأصل (الياء "ي" لا "ى" فى "في" و"التي" و"الآتي"،
-- "اليها" بلا همزة فى المادة 8 كما وردت، والمصطلح "(-BBB)" بترتيبه فى المصدر دون تعديل، وعلامات الترقيم ملاصقة كما فى الأصل، وشرطة "–" بين "على الأقل")، وحُذفت ترويسة
-- الصفحات (شعار الهيئة وعبارة "رئيس الهيئة") وتذييلها (العنوان وأرقام الصفحات والشعار) والأختام والتوقيعات اليدوية وسطر "مجلس إدارة الهيئة العامة للرقابة المالية" وعنوان القرار
-- (نُقل إلى hierarchical_location للديباجة). الأرقام لاتينية. أُسقطت علامات التشكيل الصغيرة (ضمة "يُنشر" و"يُعمل") وأُبقى تنوين الفتح. التوقيع داخل المادة التاسعة.
-- "قرر" بلا نقطتين كما فى المصدر.
--
-- ===== الهيكل =====
-- 10 صفوف، 10 نسخ (version_no = 1): ديباجة (article_no = 0) باطلاعين وجلسة المجلس، والمواد 1–9: شروط التدفقات النقدية المستقبلية محل الإصدار (3 شروط)، حوالة نسبة
-- من التدفقات ودراسة مراقب الحسابات، حق الامتياز على محفظة التوريق والضمانات الإضافية، التزامات المحيل (5 بنود)، بيانات نشرة الاكتتاب (7 بنود)، مستندات الإيداع لدى أمين
-- الحفظ (5 بنود)، توريد التدفقات، حسابات أمين الحفظ واستثمار الفائض والتقرير الشهرى، النشر والتوقيع. المفتاح (1، 0) محفوظ فلا تعيد بذرة 040 إدراج المادة القديمة
-- (إدراج laws فيها ON CONFLICT DO NOTHING، وإدراج المادة مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ =====
-- effective_from = 2022-09-27 (تاريخ القرار) بصفة مؤقتة: المادة التاسعة تعمل بالقرار "من اليوم التالي لتاريخ نشره بالوقائع المصرية"، وتاريخ النشر بالوقائع غير ثابت فى
-- المصدر المقدَّم (نسخة موقع الهيئة بلا ترويسة الوقائع) فلا يُخمَّن. يُصحَّح بهجرة لاحقة بمجرد معرفة العدد وتاريخ النشر. لا تُمس بيانات laws.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (10 صفوف بديباجة سليمة والمادة 9 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند
-- أى انحراف (عدد، علامة نسبة مقلوبة أو إملاء مغاير أو عنوان قديم، محتوى المواد، إجمالى الطول 6852 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix153$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[153] القرار 115/2022 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 10
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[153] القرار 115/2022 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[153] أُزيلت % مادة من القرار 115/2022 (القرار كله فى مادة واحدة بلا ديباجة ولا مواد ومتنه بإملاء مغاير للأصل)', v_n;
  END IF;
END
$fix153$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (115) لسنة 2022 بتاريخ 2022/9/27 بشأن الضوابط المنظمة لإصدار سندات توريق مقابل ما ينشأ من تدفقات نقدية مستقبلية$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون سوق رأس المال الصادر بالقانون رقم (95) لسنة 1992 ولائحته التنفيذية؛
وعلى القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2022/9/27؛
قرر$b0_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$يجوز لشركات التوريق إصدار سندات قابلة للتداول توجه حصيلتها لتمويل الأشخاص الاعتبارية العامة أو الخاصة بعد موافقة السلطة المختصة بها مقابل ما ينشأ لصالح هذه الجهات من تدفقات نقدية متوقع دخولها في المستقبل في ذمة المحيل طبقاً للمجرى العادي للأمور، ويشترط في تلك التدفقات الآتي:
1- أن تكون ناشئة لصالح الأشخاص الاعتبارية العامة أو الخاصة.
2- ألا تكون مقيدة أو مشروطة.
3- أن تكون خالية من أي حقوق حالية أو مستقبلية للغير.$b1_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$يتم حوالة نسبة من التدفقات النقدية المستقبلية لمشروع أو مشروعات محددة ناتجة عن أصل أو أكثر للمحيل، خلال فترة محددة، وذلك بموجب اتفاق بين المحيل وشركة التوريق.
وعلى المحيل إعداد دراسة معتمدة من مراقب الحسابات توضح معدلات التشغيل والإيرادات السابقة الخاصة بالمشروع (إن وجدت)، وكذلك التدفقات النقدية المستقبلية المتوقعة للمشروع طوال عمر الإصدار، كما يجب أن تتضمن الدراسة ما يفيد كفاية التدفقات النقدية المستقبلية المقابلة لمحفظة التوريق لسداد مستحقات حملة السندات في مواعيد استحقاقها.$b2_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$يكون لحملة سندات التوريق حق امتياز على محفظة التوريق بما يضمن الوفاء بحقوقهم ومستحقاتهم في هذه السندات من أصل وعائد.
ويجوز تقديم ضمانات إضافية يتم الرجوع عليها لسداد مستحقات حملة السندات، ويجوز رهن هذه الضمانات وفقاً للأحكام القانونية المنظمة لذلك.$b3_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة$t4_0$, $b4_0$يلتزم محيل محفظة توريق التدفقات النقدية المستقبلية عند إصدار السندات بما يلي:
1- الحصول على درجة تصنيف ائتماني من إحدى الشركات المرخص لها بذلك أو إحدى الجهات المعتمدة لدى الهيئة، والذي ينبغي ألا تقل درجته عن (-BBB)، مع مراعاة أن يتم تجديده سنوياً طوال عمر الإصدار.
2- الإفصاح في نشرة الاكتتاب أو مذكرة المعلومات الخاصة بالإصدار عن موجز القوائم والبيانات المالية المعدة وفقاً لمعايير المحاسبة المصرية عن الثلاث سنوات السابقة على الإصدار أو عن المدة من تاريخ التأسيس وحتى الإصدار حال عدم تحقق مدة الثلاث سنوات المشار إليها (إن وجدت)، على أن يرفق به تقرير مراقب الحسابات عن تلك القوائم معداً وفقاً لمعايير المراجعة المصرية.
3- تقديم بيان بصافي القيمة الحالية للتدفقات النقدية المستقبلية، وأسس تقييمها، والضمانات الإضافية إن وجدت معتمداً من مراقب حسابات المحيل.
4- تحديد التدفقات النقدية المستقبلية المراد توريقها بشكل تفصيلي، وتقديم ما يفيد استمرارية تلك التدفقات طوال فترة الإصدار.
5- تحديد الضمانات المقدمة لحملة السندات بشكل محدد للرجوع عليها حال وجود عجز أو إخلال.$b4_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$يجب أن تتضمن نشرة الاكتتاب في سندات التوريق أو مذكرة المعلومات، فضلاً عن البيانات المنصوص عليها بالمادة (304) من اللائحة التنفيذية لقانون سوق رأس المال، البيانات الآتية:
1- البيانات الخاصة بالمحيل، وعلى وجه الأخص ما يلي:
- الشكل القانوني.
- رأس المال المصدر والمدفوع للشركة المحيلة.
- هيكل المساهمين المالكين لنسبة (50%) أو أكثر من رأس المال أو حقوق التصويت للشركة المحيلة.
- الموقف من القضايا والنزاعات التحكيمية التي تتعلق بنشاطه أو تؤثر على مركزه المالي أو بإحدى مساهماته أو بغيرها من الأصول المملوكة له، وإذا كان المحيل شركة فيجب أن يتضمن البيان المشار إليه القضايا والنزاعات التحكيمية التي تتجاوز قيمتها (2%) من حقوق الملكية للشركة وفقاً لآخر قوائم مالية سنوية مجمعة أو منفردة بحسب الأحوال.
- الموقف الضريبي وأي مستحقات أخرى عليه لدى الدولة، وكذا بيان بما إذا كان هناك أي رهونات أو امتيازات على أصوله أو أي قروض أو تسهيلات ائتمانية ممنوحة له (حال وجود ذلك).
2- ملخص لاتفاق الحوالة المبرم بين المحيل وشركة التوريق متضمناً – على الأقل – بياناً بقيمة محفظة التوريق والمعايير والسمات الخاصة بها ومدى تنوعها.
3- موجز القوائم والبيانات المالية للمحيل معدة وفقاً لمعايير المحاسبة المصرية عن الثلاث سنوات السابقة على الإصدار أو عن المدة من تاريخ التأسيس وحتى الإصدار حال عدم تحقق مدة الثلاث سنوات المشار إليها (إن وجدت).
4- قائمة التدفقات النقدية التقديرية لمحفظة التوريق طوال عمر الإصدار، وأسس إعدادها، مرفقاً بها تقرير مراقب الحسابات برأيه في الافتراضات التي تم الاعتماد عليها في إعداد قائمة التدفقات النقدية المشار إليها.
5- التزامات وتعهدات الأطراف الخاصة بعملية التوريق طوال عمر الإصدار، وحالات الإخلال بتلك الالتزامات والتعهدات، والإجراءات المتخذة لمواجهتها في حال حدوثها.
6- التصنيف الائتماني لكل من المحيل وسندات التوريق والذي ينبغي ألا يقل عن (-BBB) أو ما يعادلها، مع مراعاة أن يتم تجديدهما سنوياً طوال عمر الإصدار.
7- المخاطر التي قد يتحملها حملة السندات وما تم اتخاذه من تدابير أو ضمانات للحد من تلك المخاطر.
وفي جميع الأحوال، يجب اعتماد بيانات نشرة الاكتتاب أو مذكرة المعلومات من رئيس مجلس الإدارة أو العضو المنتدب بشركة التوريق، والمحيل وشركة الترويج والتغطية، وكذا من مراقب حسابات المحيل، والمستشار القانوني لعملية التوريق، وذلك بحسب الأحوال.$b5_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة$t6_0$, $b6_0$تلتزم شركة التوريق بأن تودع لدى أمين الحفظ خلال ثلاثة أيام عمل من تاريخ تغطية الاكتتاب في سندات التوريق – على الأقل – ما يلي:
1- نسخة أصلية من نشرة الاكتتاب أو مذكرة المعلومات الخاصة بإصدار السندات والمعتمدة من الهيئة.
2- نسخة من موافقة الهيئة على إصدار السندات.
3- نسخة أصلية من اتفاق الحوالة المبرم بين المحيل وشركة التوريق.
4- نسخة أصلية من اتفاق التحصيل المبرم بين المحيل وشركة التوريق أو الطرف الذي تم الاتفاق معه على تحصيل التدفقات النقدية المستقبلية (حال وجوده)، على أن يتضمن التكليف بتوريد الحصيلة إلى أمين الحفظ فور تحصيلها.
5- المستندات الخاصة بمحفظة التوريق وما يرتبط بها من ضمانات.$b6_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة$t7_0$, $b7_0$يلتزم المحيل أو المحصل بحسب الأحوال بتوريد التدفقات النقدية المستقبلية محل محفظة التوريق، ويتم إيداعها في حساب خاص لدى أمين الحفظ فور تحويلها له لصالح حملة السندات.
كما يلتزم أمين الحفظ بسداد أصل وعائد سندات التوريق المصدرة في مواعيد استحقاقها، وذلك من التدفقات النقدية المستقبلية محل محفظة التوريق، وذلك وفقاً للعقد المبرم بينه وبين شركة التوريق.$b7_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة$t8_0$, $b8_0$يتعين على أمين الحفظ أن يفرد حسابات مستقلة لكل عملية توريق، ولا يجوز له الخلط أو الدمج أو المزج بين حساباته الخاصة وبين حسابات عمليات التوريق أو بين بعضها البعض أو أي حسابات أخرى.
ويجب أن يفرد أمين الحفظ لكل عملية توريق الحسابات الآتية:
1- حساب لحصيلة محفظة التوريق.
2- حساب لسداد أصل قيمة سندات التوريق.
3- حساب لسداد العائد المستحق على سندات التوريق.
4- حساب لإدارة استثمار الفائض من حصيلة محفظة التوريق.
ولا يجوز لأمين الحفظ استخدام حصيلة الحقوق والمستحقات المالية المستقبلية لغير سداد مستحقات حملة سندات التوريق، وذلك بعد خصم العمولات والمصاريف والأتعاب المقررة وبما لا يجاوز ما تم تحديده في نشرة الاكتتاب أو مذكرة المعلومات الخاصة بالإصدار.
ولأمين الحفظ، بعد موافقة شركة التوريق، استثمار فائض المبالغ المودعة لديه في: أذون خزانة و/أو ودائع لدى البنوك المسجلة لدى البنك المركزي المصري و/أو صناديق استثمار أسواق النقد و/أو صناديق استثمار أدوات الدين، وذلك مع مراعاة عدم تعارض المصالح، كما له أن يعهد بذلك إلى إحدى شركات إدارة محافظ الأوراق المالية بشرط أن تتضمن نشرة الاكتتاب أو مذكرة المعلومات الخاصة بالإصدار ذلك.
كما يلتزم أمين الحفظ بإعداد تقرير شهري بشأن محفظة التوريق يتضمن البيانات المشار اليها بالمادة (312) من اللائحة التنفيذية لقانون سوق رأس المال وذلك بمراعاة طبيعة سندات توريق التدفقات النقدية المستقبلية، وعليه إخطار الهيئة وحملة سندات التوريق أو من يمثلهم بالتقرير وذلك بعد اعتماده من مراقب الحسابات.$b8_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة$t9_0$, $b9_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b9_0$
  FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-09-27', 'active' FROM ins9_0;

DO $verify153$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 115 AND law_year = 2022 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[153] القرار 115/2022 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 10 THEN RAISE EXCEPTION '[153] عدد المواد % بدل 10', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2022-09-27';
  IF v_v <> 10 THEN RAISE EXCEPTION '[153] عدد النسخ % بدل 10', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%(BBB-)%' OR body LIKE '%قرار مجلس إدارة الهيئة رقم 115/2022%' OR body LIKE '%٢٠٢٢%' OR body LIKE '%مجلس إدارة الهيئة العامة للرقابة المالية
%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[153] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%رقم (95) لسنة 1992%' AND body LIKE '%رقم (10) لسنة 2009%' AND body LIKE '%بتاريخ 2022/9/27؛%' AND body LIKE '%قرر') THEN RAISE EXCEPTION '[153] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'يجوز لشركات التوريق إصدار سندات قابلة للتداول%' AND body LIKE '%ويشترط في تلك التدفقات الآتي:%' AND body LIKE '%3- أن تكون خالية من أي حقوق%للغير.') THEN RAISE EXCEPTION '[153] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يتم حوالة نسبة من التدفقات النقدية المستقبلية%' AND body LIKE '%وعلى المحيل إعداد دراسة معتمدة من مراقب الحسابات%في مواعيد استحقاقها.') THEN RAISE EXCEPTION '[153] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يكون لحملة سندات التوريق حق امتياز%' AND body LIKE '%ويجوز رهن هذه الضمانات%') THEN RAISE EXCEPTION '[153] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يلتزم محيل محفظة توريق التدفقات النقدية المستقبلية%' AND body LIKE '%(-BBB)%' AND body LIKE '%5- تحديد الضمانات المقدمة لحملة السندات%إخلال.') THEN RAISE EXCEPTION '[153] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'يجب أن تتضمن نشرة الاكتتاب في سندات التوريق%' AND body LIKE '%المادة (304) من اللائحة التنفيذية%' AND body LIKE '%(50%) أو أكثر%' AND body LIKE '%(2%) من حقوق الملكية%' AND body LIKE '%6- التصنيف الائتماني%(-BBB)%' AND body LIKE '%7- المخاطر التي قد يتحملها%وذلك بحسب الأحوال.') THEN RAISE EXCEPTION '[153] المادة 5 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'تلتزم شركة التوريق بأن تودع لدى أمين الحفظ خلال ثلاثة أيام عمل%' AND body LIKE '%5- المستندات الخاصة بمحفظة التوريق%ضمانات.') THEN RAISE EXCEPTION '[153] المادة 6 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'يلتزم المحيل أو المحصل بحسب الأحوال%' AND body LIKE '%وفقاً للعقد المبرم بينه وبين شركة التوريق.') THEN RAISE EXCEPTION '[153] المادة 7 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'يتعين على أمين الحفظ أن يفرد حسابات مستقلة%' AND body LIKE '%4- حساب لإدارة استثمار الفائض%' AND body LIKE '%أذون خزانة%' AND body LIKE '%المادة (312) من اللائحة التنفيذية%بعد اعتماده من مراقب الحسابات.') THEN RAISE EXCEPTION '[153] المادة 8 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية%' AND body LIKE '%بالوقائع المصرية.%' AND body LIKE '%د. محمد فريد صالح') THEN RAISE EXCEPTION '[153] المادة 9 غير سليم'; END IF;
  IF v_len <> 6852 THEN RAISE EXCEPTION '[153] إجمالى طول المواد % بدل 6852', v_len; END IF;
  RAISE NOTICE '[153] القرار 115/2022: 10 مواد و10 نسخ، إجمالى % حرف', v_len;
END
$verify153$;

COMMIT;
