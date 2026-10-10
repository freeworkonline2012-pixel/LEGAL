-- 195_replace_decision_57_2023_carbon_credits_supervision_committee_stored_in_english_only_as_original_2023_text_with_unofficial_additions_and_without_amendments.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (57) لسنة 2023 بتاريخ 2023/3/22 بشأن لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية واختصاصاتها، بالنص الموحد "وفقا لأخر تعديل بتاريخ 2025/3/26"
-- (مع تعديلات القرارات 257 بتاريخ 2024/11/13 و279 بتاريخ 2024/12/12 و70 بتاريخ 2025/3/26) كما نشرته الهيئة على موقعها.
--
-- ===== الحالة السابقة (بذور 039 وما بعدها) =====
-- مخزَّن بصف واحد (article_no = 1، article_suffix_order = 0، 4937 حرفاً) كله بالإنجليزية، وعنوان القانون فى laws ورابط official_url بالإنجليزية أيضاً، فلا يجد البحث العربى ولا المساعد أى نص للقرار. وهو ترجمة إنجليزية للنص الأصلى لسنة 2023 قبل التعديلات:
--   * المادة الأولى بتشكيلها الأصلى (بند 3: "ممثل عن البورصة المصرية يختاره رئيس البورصة"، وبند 4: "عضو واحد من ذوى الخبرة")، بينما النص المعمول به اليوم "ممثل عن البنك المركزى المصرى يختاره المحافظ" و"ثلاثة أعضاء من ذوى الخبرة"؛
--   * سقوط المواد المضافة بقرار 279/2024: المادة الرابعة مكرراً (المجموعة الاستشارية) والرابعة مكرراً "1" والرابعة مكرراً "2"؛
--   * إضافات ليست فى نص الهيئة: فى آخر المادة الرابعة فقرة "Some further roles can include: i. ... ii. ... iii. ..." (ثلاثة أدوار للأمانة الفنية) لا مقابل لها فى الأصل العربى، وبعض عبارات المواد 2–4 ترجمة حرة لا نص رسمى؛
--   * توقيع مطبوع "Dr. Mohammed Farid Saleh" وسطر صفة الموقّع، وغياب الهوامش وعنوان القرار وعبارة التعديل.
-- (هذه أبرز العيوب لا حصرها؛ أُعيدت كتابة المتن كله من الأصل ولم يُعتمد على المخزَّن أساساً.)
--
-- ===== المصدر والمنهجية =====
-- PDF الهيئة الموحد (3 صفحات، منتَج بـ Word، بطبقة نصية سليمة الحروف لكن بوصلات مقلوبة فى بعض الكلمات). نُقل النص كاملاً من صور الصفحات بصرياً (200 dpi، كل صفحة فى ثلاثة أشرطة)، ثم قوبل بالطبقة النصية: مفاتيح الحروف المرتبة لكل كلمة
-- (بالتمييز بين الهمزات والألف المقصورة والياء) ومطابقة كل الأرقام؛ فلم يبق فرق غير ترويسة الصفحات وعناوينها وتذييلها ورؤوس الهوامش وفصل التنوين عن الحرف فى الطبقة النصية.
-- وحيث تلتبس الألف المقصورة بالياء أو الهمزة بالألف فى الصورة اعتُمد حرف الطبقة النصية: "المادة الاولى" فى الهامشين 2 و3 بلا همزة وبياء (الاولي)، وليس "الأولي".
-- أُبقى إملاء الأصل وأخطاؤه كما هى: "الاولي" فى الهامشين 2 و3، و"(المادة الرابعة مكرر)" بلا ألف فى الهامش 4 مع "مكرراً" فى عناوين المواد، وعلامتا التنصيص حول الرقمين 1 و2 فى "مكرراً "1"" و"مكرراً "2"" كما طُبعتا،
-- و"و (المادة" بمسافة بعد الواو فى الهامش 4، و"تم إضافة"، و"ويجوز انعقاد اللجنة بأية وسيلة" فى المادة الرابعة مكرراً "2" (ومحلها المجموعة الاستشارية)، و"فى" بالألف المقصورة فى بعض المواضع و"التى" و"المصرى".
-- حُذفت ترويسة الصفحات وتذييلها وأرقامها وسطر "رئيس الهيئة" وسطر "مجلس إدارة الهيئة العامة للرقابة المالية" وكلمة "قرر" (لا توقيع مطبوع فى الأصل). الأرقام لاتينية، وأُسقطت علامة الضمة الصغيرة على "ممثل" فى بند 3 وأُبقى تنوين الفتح مكتوباً على الحرف قبل الألف كباقى الهجرات.
--
-- ===== تعديلات التمثيل (معلنة) =====
--   * عنوان كل مادة (المادة الأولى .. الخامسة) صار حقل title للصف كما طُبع، وعلامة الهامش 4 المطبوعة بعد "المادة الرابعة مكرراً" نُقلت إلى العنوان "(4)"؛ وعلامتا الهامش 2 و3 المطبوعتان فى آخر البندين 3 و4 من المادة الأولى بقيتا فى المتن "(2)" و"(3)" بعد النقطة؛
--     وعلامة (1) إلى hierarchical_location للديباجة مع عنوان القرار وعبارة "النص الموحد".
--   * قوائم البنود كلها بأرقام "N-" لاتينية، كل بند فى سطر (بدل الترقيم المطبوع ".1" إلخ).
--   * الهوامش الأربعة المطبوعة أسفل الصفحتين 1 و2 جُمعت فى القسم 6 "هوامش التعديلات اللاحقة" بنصها.
--
-- ===== الهيكل =====
-- 10 صفوف، 10 نسخ (version_no = 1): الديباجة (article_no = 0) بأربعة اطلاعات، المواد 1–5 (article_suffix_order = 0)، والمواد المضافة المكررة بمفاتيح article_suffix_order على اصطلاح المنصة (كما فى الهجرة 155):
-- 4 مكرراً (4/1)، 4 مكرراً "1" (4/2)، 4 مكرراً "2" (4/3)، ثم القسم 6 "هوامش التعديلات اللاحقة" (الهوامش 1–4). المفتاح (1، 0) هو المفتاح المخزَّن نفسه فلا تعيد بذرة القرار إدراج الصف القديم
-- (إدراج laws فى البذور ON CONFLICT DO NOTHING وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود).
--
-- ===== التاريخ والنسخ (قرار تقديرى يُراجَع) =====
-- النص المتاح هو الموحد بعد تعديل 2025/3/26 فقط؛ لا نص أصلى لسنة 2023 ولا نصوص قرارات التعديل ولا تواريخ نشرها بالوقائع المصرية. فجُعل effective_from = 2025-03-26 (تاريخ آخر تعديل المذكور فى المصدر) للنسخ العشر،
-- وسُجِّل amended_by على الصفوف التى مسّها التعديل وحدها: المادة 1 (البند 3 باستبدال بقرار 70/2025 والبند 4 باستبدال بقرار 257/2024، فسُجِّل 70/2025 وهو الأحدث مع ذكر الاثنين فى change_note)،
-- والمواد 4 مكرراً و4 مكرراً "1" و4 مكرراً "2" (مضافة بقرار 279/2024). أثر ذلك: لا نسخة للقرار قبل 2025-03-26 فى الاستعلام بالتاريخ (فجوة معلنة بدل نص معدَّل منسوب لتواريخ سابقة)، كما فى الهجرات 138 و154 و155 و192 و193.
-- لاحقاً: رفع نص 2023 الأصلى وقرارات 257/2024 و279/2024 و70/2025 لبناء النسخ التاريخية. لا تُمس بيانات laws (العنوان الإنجليزى والرابط الإنجليزى وغياب enacted_at) وتُترك لهجرة بيانات laws المؤجلة، على أن تكون enacted_at فيها 2023/3/22 (جلسة المجلس).
--
-- ===== ملاحظة للمراجعة القانونية (لا يعالجها هذا الملف) =====
-- المادة الرابعة مكرراً "2" تنص (كما طُبعت) على "ويجوز انعقاد اللجنة بأية وسيلة من وسائل الاتصال الحديثة" ومحلها اجتماعات المجموعة الاستشارية، فيُرجَّح خطأ مادى فى الأصل لا يُصحَّح هنا.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (10 صفوف بديباجة سليمة والقسم 6 موجود)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف
-- (عدد، لفظ مغاير للأصل، أرقام أو علامات هوامش مغايرة، بقايا ترويسة أو تذييل أو وصلات مقلوبة، تاريخ سريان الصفوف وجهة التعديل، إجمالى الطول 4421 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix195$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[195] القرار 57/2023 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 10
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[195] القرار 57/2023 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[195] أُزيلت % مادة من القرار 57/2023 (صف واحد مخزن بالإنجليزية فقط (ديباجة ومواد القرار الخمس) بلا المواد المضافة بالتعديلات ولا الهوامش)', v_n;
  END IF;
END
$fix195$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (57) لسنة 2023 بتاريخ 2023/3/22 بشأن لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية واختصاصاتها (النص الموحد وفقاً لآخر تعديل بتاريخ 2025/3/26) (1)$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون سوق رأس المال الصادر بالقانون رقم 95 لسنة 1992 ولائحته التنفيذية؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وبعد التنسيق مع وزارة البيئة؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2023/3/22؛$b0_0$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-03-26', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى$t1_0$, $b1_0$تشكل لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية برئاسة رئيس الهيئة العامة للرقابة المالية أو من يفوضه، وعضوية كل من:
1- أربعة ممثلين عن الهيئة العامة للرقابة المالية يختارهم رئيسها.
2- أربعة ممثلين عن الوزارة المختصة بشئون البيئة يختارهم الوزير المختص.
3- ممثل عن البنك المركزي المصري يختاره المحافظ. (2)
4- ثلاثة أعضاء من ذوي الخبرة من الجهات العاملة في مجال أسواق الكربون يختارهم رئيس اللجنة. (3)$b1_0$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2025-03-26', 'active', 70, 2025, $c1_0$النص الموحد: استبدال البند (3) بقرار مجلس إدارة الهيئة رقم (70) بتاريخ 2025/3/26، واستبدال البند (4) بقرار رقم (257) بتاريخ 2024/11/13$c1_0$ FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$تختص اللجنة المشار إليها بالمادة الأولى من هذا القرار بما يلي:
1- إعداد القواعد الخاصة بإصدار شهادات خفض الانبعاثات الكربونية.
2- إعداد قواعد الإشراف والرقابة على شهادات خفض الانبعاثات الكربونية بما يشمل متطلبات الإفصاح المستمر والشفافية لمشروعات وبرامج خفض الانبعاثات الكربونية.
3- إعداد معايير اختيار جهات التحقق والمصادقة لمشروعات خفض الانبعاثات الكربونية.
4- إعداد القواعد الاسترشادية الخاصة بمعايير نزاهة ومصداقية شهادات خفض الانبعاثات الكربونية.
5- إعداد قواعد تجنب تعارض المصالح للأطراف ذوي العلاقة بعملية إصدار شهادات خفض الانبعاثات الكربونية.
6- إعداد قواعد تحديد سجلات شهادات خفض الانبعاثات الكربونية التى يعتد بتداول الشهادات الصادرة عنها.
7- التنسيق مع الجهات المعنية لإنشاء (السجل المصرى لشهادات خفض الانبعاثات الكربونية).
8- توصيف لأنواع شهادات خفض الانبعاثات الكربونية.
كما تتولى اللجنة القيام بأي مهام أخرى مرتبطة بأعمالها يكلفها بها رئيسها.
ويتم اعتماد القواعد المشار إليها من مجلس إدارة الهيئة.$b2_0$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-03-26', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$تجتمع اللجنة بناءً على دعوة من رئيسها، مرة كل شهر على الأقل أو كلما دعت الحاجة إلى ذلك بمقر الهيئة العامة للرقابة المالية أو أى مقر آخر يحدده رئيس اللجنة، ولا يكون انعقاد اللجنة صحيحًا إلا بحضور أغلبية أعضائها.
وتصدر اللجنة قراراتها بأغلبية عدد أعضائها، وعند التساوي يرجح الجانب الذي منه الرئيس.
ويجوز المشاركة فى اجتماعات اللجنة باستخدام الوسائط التكنولوجية، وتحتسب تلك المشاركة ضمن نصاب الحضور أو التصويت.
وللجنة دعوة من تراه مناسبًا لحضور اجتماعاتها دون أن يكون له حق التصويت على قرارات اللجنة.$b3_0$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-03-26', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة$t4_0$, $b4_0$يكون للجنة أمانة فنية يصدر بتشكيلها قرار من رئيس اللجنة، وتتولى القيام بما يلي:
1- الإعداد والتجهيز لاجتماعات اللجنة بما فى ذلك إعداد دعوات انعقاد اللجنة وجدول الأعمال والموضوعات المعروضة وإرسالها.
2- تدوين محاضر اجتماعات اللجنة، وإبلاغ ذوي الشأن بقرارات اللجنة، ومتابعة تنفيذ تلك القرارات وإعداد تقارير المتابعة اللازمة لذلك.
3- حفظ الملفات الخاصة بالموضوعات التى تعرض فى اجتماعات اللجنة، ومحاضر هذه الاجتماعات، والمستندات التى تتداولها اللجنة فى اجتماعاتها.
4- ما يسند إليها من أعمال من رئيس اللجنة.$b4_0$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-03-26', 'active' FROM ins4_0;

WITH ins4_1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 1, NULL, $t4_1$المادة الرابعة مكرراً (4)$t4_1$, $b4_1$يكون للجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية مجموعة استشارية من عدد من الأعضاء لا يجاوز ثلاثة عشر عضوًا من ذوي الخبرات المحلية والدولية في المجالات المرتبطة بخفض الانبعاثات الكربونية والتنمية المستدامة والتغييرات المناخية والطاقة النظيفة، تختارهم اللجنة بناءً على ترشيح من رئيس اللجنة لمدة سنة واحدة قابلة للتجديد.$b4_1$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2025-03-26', 'active', 279, 2024, $c4_1$النص الموحد: إضافة المادة الرابعة مكرراً بقرار مجلس إدارة الهيئة رقم (279) بتاريخ 2024/12/12$c4_1$ FROM ins4_1;

WITH ins4_2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 2, NULL, $t4_2$المادة الرابعة مكرراً "1"$t4_2$, $b4_2$تختص المجموعة الاستشارية المشار إليها بالعمل على معاونة اللجنة في تحقيق أهدافها واختصاصاتها، وتقوم على وجه الأخص بتقديم المشورة الفنية في المجالات المرتبطة بعمل اللجنة ودراسة الموضوعات التي يتم تكليفها بها من قبل اللجنة.
ويتم عرض توصيات المجموعة الاستشارية على اللجنة لاتخاذ ما تراه مناسبًا بشأنها، ويجوز للجنة تكليف عضو أو أكثر من أعضاء المجموعة الاستشارية للقيام بمهام محددة تتعلق بعمل اللجنة.$b4_2$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2025-03-26', 'active', 279, 2024, $c4_2$النص الموحد: إضافة المادة الرابعة مكرراً "1" بقرار مجلس إدارة الهيئة رقم (279) بتاريخ 2024/12/12$c4_2$ FROM ins4_2;

WITH ins4_3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 3, NULL, $t4_3$المادة الرابعة مكرراً "2"$t4_3$, $b4_3$تجتمع المجموعة الاستشارية بناءً على دعوة من رئيس اللجنة كلما دعت الحاجة لذلك، ويجوز انعقاد اللجنة بأية وسيلة من وسائل الاتصال الحديثة، ولا يكون انعقادها صحيحًا إلا بحضور أكثر من نصف عدد أعضائها على أن يكون من بينهم رئيس المجموعة أو نائبه، وتتخذ المجموعة الاستشارية قراراتها بأغلبية أصوات الحاضرين وعند التساوي يرجح الجانب الذي منه رئيس الاجتماع.
ويكون لرئيس اللجنة أو من يفوضه حضور اجتماعات المجموعة كما يكون لها دعوة من ترى الاستعانة به لحضور اجتماعاتها دون أن يكون له صوت معدود.$b4_3$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2025-03-26', 'active', 279, 2024, $c4_3$النص الموحد: إضافة المادة الرابعة مكرراً "2" بقرار مجلس إدارة الهيئة رقم (279) بتاريخ 2024/12/12$c4_3$ FROM ins4_3;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكتروني للهيئة والبورصة المصرية، ويعمل به من اليوم التالي لتاريخ نشره.$b5_0$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-03-26', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $h6$قرار مجلس إدارة الهيئة رقم (57) لسنة 2023 - هوامش التعديلات اللاحقة$h6$, $t6_0$هوامش التعديلات اللاحقة$t6_0$, $b6_0$(1) تم تعديل القرار بموجب قرار مجلس إدارة الهيئة رقم (257) بتاريخ 2024/11/13، وقرار رقم (279) بتاريخ 2024/12/12، وقرار رقم (70) بتاريخ 2025/3/26.
(2) تم استبدال البند رقم (3) من المادة الاولي بموجب قرار مجلس إدارة الهيئة رقم (70) بتاريخ 2025/3/26.
(3) تم استبدال البند رقم (4) من المادة الاولي بموجب قرار مجلس إدارة الهيئة رقم (257) بتاريخ 2024/11/13.
(4) تم إضافة (المادة الرابعة مكرر) و(المادة الرابعة مكررًا "1") و (المادة الرابعة مكررًا "2") بموجب قرار مجلس إدارة الهيئة رقم (279) بتاريخ 2024/12/12.$b6_0$
  FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-03-26', 'active' FROM ins6_0;

DO $verify195$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 57 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[195] القرار 57/2023 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 10 THEN RAISE EXCEPTION '[195] عدد المواد % بدل 10', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2025-03-26';
  IF v_v <> 10 THEN RAISE EXCEPTION '[195] عدد النسخ % بدل 10', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%FINANCIAL REGULATORY%' OR body LIKE '%WWW.FRA%' OR body LIKE '%Building Bridges%' OR body LIKE '%القرية الذكية%' OR body LIKE '%قـرر%' OR body LIKE '%جملس%' OR body LIKE '%املالية%' OR body LIKE '%اهليئة%' OR body LIKE '%اإل%' OR body LIKE '%األ%' OR body LIKE '%ا ً%' OR body LIKE '%�%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[195] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون سوق رأس المال %' AND body LIKE '%نسيق مع وزارة البيئة؛%' AND body LIKE '%سته المنعقدة بتاريخ 2023/3/22؛' AND body LIKE '%رقم 95 لسنة 1992%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%بتاريخ 2023/3/22؛' AND body LIKE '% بالقانون رقم 95 لسنة 1992 ولا%' AND body LIKE '%ن رقم 95 لسنة 1992 ولائحته التنف%' AND body LIKE '%ى القانون رقم 10 لسنة 2009 بتن%' AND body LIKE '%ن رقم 10 لسنة 2009 بتنظيم الرقاب%' AND body LIKE '%منعقدة بتاريخ 2023/3/22؛%') THEN RAISE EXCEPTION '[195] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تشكل لجنة الإشراف والرقابة على وحدات%' AND body LIKE '% ممثلين عن الوزارة المختصة بشئون الب%' AND body LIKE '%كربون يختارهم رئيس اللجنة. (3)' AND body LIKE '%أربعة ممثلين عن الهيئة العامة%' AND body LIKE '%أربعة ممثلين عن الوزارة المختصة%' AND body LIKE '%يختاره المحافظ. (2)%' AND body LIKE '%يختارهم رئيس اللجنة. (3)' AND body LIKE '%اره المحافظ. (2)%' AND body LIKE '%رئيس اللجنة. (3)%') THEN RAISE EXCEPTION '[195] المادة الأولى غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'تختص اللجنة المشار إليها بالمادة الأ%' AND body LIKE '% قواعد تجنب تعارض المصالح للأطراف ذو%' AND body LIKE '%ار إليها من مجلس إدارة الهيئة.' AND body LIKE '%7- التنسيق مع الجهات المعنية%' AND body LIKE '%8- توصيف لأنواع%' AND body LIKE '%ويتم اعتماد القواعد المشار إليها%') THEN RAISE EXCEPTION '[195] المادة الثانية غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'تجتمع اللجنة بناءً على دعوة من رئيسه%' AND body LIKE '%مشاركة فى اجتماعات اللجنة باستخدام ا%' AND body LIKE '% حق التصويت على قرارات اللجنة.' AND body LIKE '%مرة كل شهر على الأقل%' AND body LIKE '%إلا بحضور أغلبية أعضائها.%' AND body LIKE '%دون أن يكون له حق التصويت%') THEN RAISE EXCEPTION '[195] المادة الثالثة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'يكون للجنة أمانة فنية يصدر بتشكيلها %' AND body LIKE '% محاضر اجتماعات اللجنة، وإبلاغ ذوي ا%' AND body LIKE '%إليها من أعمال من رئيس اللجنة.' AND body LIKE '%4- ما يسند إليها من أعمال%' AND body LIKE '%2- تدوين محاضر اجتماعات اللجنة%') THEN RAISE EXCEPTION '[195] المادة الرابعة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 1 AND body LIKE 'يكون للجنة الإشراف والرقابة على وحدا%' AND body LIKE '%نة الإشراف والرقابة على وحدات خفض ال%' AND body LIKE '% لمدة سنة واحدة قابلة للتجديد.' AND body LIKE '%لا يجاوز ثلاثة عشر عضوًا%' AND body LIKE '%لمدة سنة واحدة قابلة للتجديد.') THEN RAISE EXCEPTION '[195] المادة الرابعة مكرراً غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 2 AND body LIKE 'تختص المجموعة الاستشارية المشار إليه%' AND body LIKE '% توصيات المجموعة الاستشارية على اللج%' AND body LIKE '%بمهام محددة تتعلق بعمل اللجنة.') THEN RAISE EXCEPTION '[195] المادة الرابعة مكرراً 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 3 AND body LIKE 'تجتمع المجموعة الاستشارية بناءً على %' AND body LIKE '%ئيس اللجنة أو من يفوضه حضور اجتماعات%' AND body LIKE '%اتها دون أن يكون له صوت معدود.' AND body LIKE '%أكثر من نصف عدد أعضائها%' AND body LIKE '%دون أن يكون له صوت معدود.') THEN RAISE EXCEPTION '[195] المادة الرابعة مكرراً 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية و%' AND body LIKE '% القرار فى الوقائع المصرية وعلى المو%' AND body LIKE '%ه من اليوم التالي لتاريخ نشره.' AND body LIKE '%وعلى الموقع الإلكتروني للهيئة والبورصة المصرية%') THEN RAISE EXCEPTION '[195] المادة الخامسة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE '(1) تم تعديل القرار بموجب قرار مجلس %' AND body LIKE '%ستبدال البند رقم (4) من المادة الاول%' AND body LIKE '%ة رقم (279) بتاريخ 2024/12/12.' AND body LIKE '(1) تم تعديل القرار بموجب%' AND body LIKE '%(4) تم إضافة%' AND body LIKE '%(1) تم تعديل الق%' AND body LIKE '%ة الهيئة رقم (257) بتاريخ 2024/%' AND body LIKE '% (257) بتاريخ 2024/11/13، وقرار رقم (2%' AND body LIKE '%3، وقرار رقم (279) بتاريخ 2024/%' AND body LIKE '% (279) بتاريخ 2024/12/12، وقرار رقم (7%' AND body LIKE '%2، وقرار رقم (70) بتاريخ 2025/%' AND body LIKE '%م (70) بتاريخ 2025/3/26.%' AND body LIKE '%(2) تم استبدال ا%' AND body LIKE '%ال البند رقم (3) من المادة ال%' AND body LIKE '%ة الهيئة رقم (70) بتاريخ 2025/%' AND body LIKE '%(3) تم استبدال ا%' AND body LIKE '%ال البند رقم (4) من المادة ال%' AND body LIKE '% (257) بتاريخ 2024/11/13.%' AND body LIKE '%(4) تم إضافة (ال%' AND body LIKE '%رابعة مكررًا "1") و (المادة ا%' AND body LIKE '%رابعة مكررًا "2") بموجب قرار %' AND body LIKE '%ة الهيئة رقم (279) بتاريخ 2024/%' AND body LIKE '% (279) بتاريخ 2024/12/12.%') THEN RAISE EXCEPTION '[195] الهوامش غير سليم'; END IF;
  IF v_len <> 4421 THEN RAISE EXCEPTION '[195] إجمالى طول المواد % بدل 4421', v_len; END IF;
  RAISE NOTICE '[195] القرار 57/2023: 10 مواد و10 نسخ، إجمالى % حرف', v_len;
END
$verify195$;

COMMIT;
