-- 196_replace_decision_163_2023_verification_and_validation_bodies_registration_criteria_stored_in_english_only_as_non_official_translation_without_last_article_and_amendment.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (163) لسنة 2023 بتاريخ 2023/8/9 بشأن معايير قيد جهات التحقق والمصادقة لمشروعات خفض الانبعاثات الكربونية لدى الهيئة، بالنص الموحد "وفقا لأخر تعديل بتاريخ 2024/10/30"
-- (تعديل بقرار مجلس إدارة الهيئة رقم 253 بتاريخ 2024/10/30) كما نشرته الهيئة على موقعها.
--
-- ===== الحالة السابقة (بذور 039 وما بعدها) =====
-- مخزَّن بصف واحد (article_no = 1، article_suffix_order = 0، 5207 حروف) كله بالإنجليزية، وعنوان القانون فى laws ورابط official_url بالإنجليزية أيضاً، فلا يجد البحث العربى ولا المساعد أى نص للقرار. وهو ترجمة إنجليزية غير رسمية تخالف نص الهيئة:
--   * سابقة على تعديل 253/2024: المادة الأولى بقائمة واحدة لقيد جهات التحقق والمصادقة وبقطاعاتها الستة عشر، بينما النص المعمول به قائمتان (قائمة لأغراض الرصد والتحقق من قياسات الانبعاثات وقائمة لمشروعات خفض الانبعاثات لغرض إصدار الشهادات) وحظر القيام بأعمال التحقق والمصادقة لغير المقيدين بهما؛
--   * المادة الثانية بلا التفرقة بين معايير قيد الجهات المصرية لأغراض الرصد والتحقق ومعايير قيدها لمشروعات خفض الانبعاثات (فقرة "ويشترط لقيد جهات التحقق والمصادقة المصرية لمشروعات خفض الانبعاثات الكربونية ..." غائبة)، وبنود 2–5 مختلفة المضمون والصياغة (منها شهادة الأيزو 14064-2:2019 والبند الخاص بالمقابلة الشخصية مع لجنة الإشراف)؛
--   * سقوط المادة التاسعة (النشر بالوقائع المصرية والسريان)، وغياب الهوامش وعنوان القرار وعبارة التعديل؛
--   * جمل ليست فى النص العربى: "Only VVBs approved in this registry may conduct verification and validation for carbon emission reduction projects intended for trading in Egypt" فى آخر المادة الأولى؛ وتوقيع مطبوع "Dr. Mohammed Farid Saleh".
-- (هذه أبرز العيوب لا حصرها؛ أُعيدت كتابة المتن كله من الأصل ولم يُعتمد على المخزَّن أساساً.)
--
-- ===== المصدر والمنهجية =====
-- PDF الهيئة الموحد (4 صفحات، منتَج بـ Word، بطبقة نصية فيها وصلات مقلوبة وتطويل بحروف "ر" وسقوط بعض الحروف). نُقل النص كاملاً من صور الصفحات بصرياً (200 dpi، كل صفحة فى ثلاثة أشرطة مع تكبير المواضع الصغيرة)، ثم قوبل بالطبقة النصية:
-- مفاتيح الحروف المرتبة لكل كلمة (بالتمييز بين الهمزات والياء والألف المقصورة) وكل الأرقام؛ فلم يبق فرق إلا ما سببه تطويل الحروف وسقوط حرف (الطاء والغين والثاء والهمزة على الواو) فى الطبقة النصية وترويسة الصفحات وتذييلها وعناوين المواد.
-- وحيث تلتبس الصورة بين الألف المقصورة والياء أو الهمزة والألف اعتُمد حرف الطبقة النصية: "يشترط في جهات التحقق والمصادقة الأجنبية الراغبة في القيد" بالياء، و"كحد أدني" بالياء، و"باخطار الهيئة" بلا همزة.
-- أُبقى إملاء الأصل وأخطاؤه كما هى: "أدني" و"باخطار" و"لدي" (فى "لدي أحد سجلات الكربون") و"مستوي" و"بعالية" و"لإزاله" و"التدابير الاتية" و"دولار امريكي" و"الموقع الالكتروني" و"أو أحد الجهات" و"لعدد ثلاث مشروعات" و"كأحد جهات التحقق" و"سنة قابلة للتجديد لمدد أخرى" بصياغتها المطبوعة،
-- وفاصلة "2،000" العربية فى بند الرسوم وأقواس "( 10,000 )" و"( 2،000 )" و"( 500 )" بمسافات داخلية بخلاف "(100)"، وقطاع "الصناعات الكيماوية" بالعبارة الإنجليزية ذاتها "Manufacturing Industries" الواردة لقطاع الصناعة، و"ISO-14064:3" فى البند 4 من المادة الثانية (والمعيار الفعلى 14064-3)، وعدم وجود نقطة ختامية بعد الهامش 3 وبعد "Fugitive Emissions From Fuels, Solid، Oil, And Gas".
-- حُذفت ترويسة الصفحات وتذييلها وأرقامها وسطر "رئيس الهيئة" وسطر "مجلس إدارة الهيئة العامة للرقابة المالية" وكلمة "قرر" وتوقيع رئيس مجلس الإدارة المطبوع بآخر الصفحة 4. الأرقام لاتينية، وأُسقطت علامات التشكيل الصغيرة (ضمة "يُنشر" و"يُعمل") وأُبقى تنوين الفتح مكتوباً على الحرف قبل الألف كباقى الهجرات.
--
-- ===== تعديلات التمثيل (معلنة) =====
--   * العبارات الإنجليزية داخل الجمل العربية (أسماء القطاعات والأيزو وكيانات DOE وUNFCCC وأسماء سجلات الكربون) كُتبت بترتيبها المقروء الطبيعى؛ وحيث تتداخل أقواس الأقسام الإنجليزية مع النص العربى فى الصفحة (قطاع "Energy (Renewable/Nonrenewable)" وقطاع "Fugitive Emissions From Fuels, Solid، Oil, And Gas" وأرقام الأيزو) اعتُمد ترتيب القراءة المنطقى، ويبقى موضع الأقواس
--     وعلامة الترقيم عند حدود المقاطع الإنجليزية موضع احتمال يسير لتباين الاتجاه الطباعى؛ وهو اختلاف عرض لا لفظ، وتغطيه فحوص الهجرة بأنماط حرفية لكل مقطع منها.
--   * عنوان كل مادة (المادة الأولى .. التاسعة) صار حقل title للصف كما طُبع، وعلامتا الهامش 2 و3 المطبوعتان بعد "المادة الأولى" و"المادة الثانية" نُقلتا إلى العنوان "(2)" و"(3)"؛ وعلامة (1) إلى hierarchical_location للديباجة مع عنوان القرار وعبارة "النص الموحد".
--   * قوائم البنود بأرقام "N-" لاتينية، كل بند فى سطر (بدل الترقيم المطبوع "١ -" و".1")، والقوائم النقطية بشرطة "- " كل نقطة فى سطر، (16 قطاعاً فى المادة الأولى مع فقرة ما بعدها، و3 سجلات فى بند 1 من المادة الثالثة).
--   * بنود الرسوم فى المادة السابعة تحت سطرى "أولاً: ..." و"ثانياً: ..." بنصهما. الهوامش الثلاثة المطبوعة أسفل الصفحات 1 و2 جُمعت فى القسم 10 "هوامش التعديلات اللاحقة" بنصها (الهامش 3 بلا نقطة ختامية كما طُبع).
--
-- ===== الهيكل =====
-- 11 صفاً، 11 نسخة (version_no = 1): الديباجة (article_no = 0) بخمسة اطلاعات، المواد 1–9 (article_suffix_order = 0)، ثم القسم 10 "هوامش التعديلات اللاحقة" (الهوامش 1–3). المفتاح (1، 0) هو المفتاح المخزَّن نفسه فلا تعيد بذرة القرار
-- إدراج الصف القديم (إدراج laws فى البذور ON CONFLICT DO NOTHING وإدراج المواد مبنى على RETURNING فلا يعمل مع قانون موجود؛ وقد شُغِّلت كتلة البذرة محلياً فلم تُدرج شيئاً).
--
-- ===== التاريخ والنسخ (قرار تقديرى يُراجَع) =====
-- النص المتاح هو الموحد بعد تعديل 2024/10/30 فقط؛ لا نص أصلى لسنة 2023 ولا نص قرار 253/2024 ولا تاريخ نشره بالوقائع المصرية (المادة 9 تُعمل القرار من اليوم التالى لنشره بالوقائع). فجُعل effective_from = 2024-10-30
-- (تاريخ آخر تعديل المذكور فى المصدر) للنسخ الإحدى عشرة، وسُجِّل amended_by = 253/2024 مع change_note على المادتين 1 (تعديل الصدر) و2 (تعديل النص) وحدهما بحسب الهامشين 2 و3. أثر ذلك: لا نسخة للقرار قبل 2024-10-30 فى الاستعلام بالتاريخ
-- (فجوة معلنة بدل نص معدَّل منسوب لتواريخ سابقة)، كما فى الهجرات السابقة. لاحقاً: رفع نص 2023 الأصلى وقرار 253/2024 لبناء النسخة التاريخية. لا تُمس بيانات laws (العنوان الإنجليزى والرابط الإنجليزى وغياب enacted_at)
-- وتُترك لهجرة بيانات laws المؤجلة، على أن تكون enacted_at فيها 2023/8/9 (جلسة المجلس).
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (11 صفاً بديباجة سليمة والقسم 10 موجود)؛ والإدراج ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف
-- (عدد، لفظ مغاير للأصل، أرقام أو مبالغ أو علامات هوامش مغايرة، بقايا ترويسة أو تذييل أو توقيع أو وصلات مقلوبة، تاريخ سريان الصفوف وجهة التعديل، إجمالى الطول 6351 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.
BEGIN;
DO $fix196$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[196] القرار 163/2023 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 11
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[196] القرار 163/2023 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[196] أُزيلت % مادة من القرار 163/2023 (صف واحد مخزن بالإنجليزية فقط (ديباجة ومواد القرار) بنص مغاير للنص الرسمى ولا يضم المادة التاسعة ولا الهوامش)', v_n;
  END IF;
END
$fix196$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (163) لسنة 2023 بتاريخ 2023/8/9 بشأن معايير قيد جهات التحقق والمصادقة لمشروعات خفض الانبعاثات الكربونية لدى الهيئة (النص الموحد وفقاً لآخر تعديل بتاريخ 2024/10/30) (1)$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على قانون سوق رأس المال الصادر بالقانون رقم (95) لسنة 1992 ولائحته التنفيذية؛
وعلى القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وعلى قرار مجلس إدارة الهيئة رقم (57) لسنة 2023 بشأن لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية واختصاصاتها؛
وبعد العرض على لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية باجتماعها المنعقد بتاريخ 2023/7/25؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2023/8/9؛$b0_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى (2)$t1_0$, $b1_0$تنشأ بالهيئة قائمة لقيد جهات التحقق والمصادقة لأغراض الرصد والتحقق من قياسات الانبعاثات الكربونية، وقائمة أخرى لقيد جهات التحقق والمصادقة لمشروعات خفض الانبعاثات الكربونية لغرض إصدار شهادات خفض الانبعاثات الكربونية، ولا يجوز لغير الجهات المقيدة بتلك القائمتين القيام بأعمال التحقق أو المصادقة المشار إليها، ويجب أن تتضمن القائمتين المذكورتين البيانات الرئيسية للجهات المقيدة بها والقطاع الذي يتم فيه عملية التحقق والمصادقة، وتشمل تلك القطاعات ما يلي:
- قطاع الطاقة المتجددة/غير المتجددة Energy (Renewable/Nonrenewable).
- قطاع توزيع الطاقة (Energy Distribution).
- قطاع الطلب على الطاقة (Energy Demand).
- قطاع الصناعة (Manufacturing Industries).
- قطاع الصناعات الكيماوية (Manufacturing Industries).
- قطاع البناء والتشييد (Construction).
- قطاع النقل والمواصلات (Transport).
- قطاع التعدين (Mining/Mineral Production).
- قطاع إنتاج المعادن (Metal Production).
- قطاع الانبعاثات المتسربة من الوقود (الصلب والنفط والغاز) Fugitive Emissions From Fuels, Solid، Oil, And Gas
- قطاع الانبعاثات المتسربة من الغازات الصناعية (الهالوكربونات وسداسي فلوريد الكبريت).
- قطاع استخدام المذيبات (Solvents Use).
- قطاع التعامل مع النفايات والتخلص منها (Waste Handling And Disposal).
- قطاع الزراعة (Agriculture).
- قطاع احتجاز الكربون وتخزينه (Carbon Capture and Storage).
- قطاع إدارة الثروة الحيوانية والسماد الطبيعي (Livestock and Manure Management).
ويجوز بقرار من رئيس الهيئة إضافة أي قطاعات أخرى بخلاف القطاعات المشار إليها أعلاه.$b1_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2024-10-30', 'active', 253, 2024, $c1_0$النص الموحد: تعديل صدر المادة الأولى بقرار مجلس إدارة الهيئة رقم (253) بتاريخ 2024/10/30$c1_0$ FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية (3)$t2_0$, $b2_0$يشترط في جهات التحقق والمصادقة المصرية الراغبة في القيد لدى الهيئة لأغراض الرصد والتحقق من قياسات الانبعاثات الكربونية توافر المعايير الآتية:
1- أن تكون الجهة طالبة القيد شخصًا اعتباريًا.
2- الحصول على شهادة اعتماد الأيزو الخاصة بمتطلبات اعتماد مؤسسات التحقق والمصادقة ISO-14065:2020 أو ISO/IEC 17029 أو أي تحديث لهما.
3- الحصول على شهادة اعتماد الأيزو ISO 14064-2:2019 الخاصة بقياسات غازات الانبعاثات الكربونية على مستوي المشروعات.
4- الحصول على شهادة اعتماد الأيزو ISO-14064:3 الخاصة بتوثيق أعمال التحقق والمصادقة لمشروعات خفض الانبعاثات الكربونية.
5- استيفاء متطلبات الكفاءة المهنية واجتياز العضو المنتدب أو من يقوم مقامه في الأشخاص الاعتبارية الأخرى أو فريق العمل المختص بالقيام بأعمال التحقق أو المصادقة للمقابلة الشخصية التي يتم عقدها مع لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية.
6- عدم صدور أحكام جنائية نهائية بعقوبة جناية، أو بعقوبة جنحة في جريمة ماسة بالشرف أو الأمانة ضد أي من الأشخاص القائمين على إدارة الشخص الاعتباري أو الأشخاص القائمين بالتحقق والمصادقة بالجهة ما لم يكن قد رد إليهم اعتبارهم.
ويشترط لقيد جهات التحقق والمصادقة المصرية لمشروعات خفض الانبعاثات الكربونية لغرض إصدار شهادات خفض الانبعاثات الكربونية لدى الهيئة، استيفاء المعايير المشار إليها بالفقرة السابقة بالإضافة إلى أن تكون تلك الجهات معتمدة كأحد جهات التحقق والمصادقة لدي أحد سجلات الكربون الطوعية المعتمدة لدى الهيئة.$b2_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2024-10-30', 'active', 253, 2024, $c2_0$النص الموحد: تعديل نص المادة الثانية بقرار مجلس إدارة الهيئة رقم (253) بتاريخ 2024/10/30$c2_0$ FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$يشترط في جهات التحقق والمصادقة الأجنبية الراغبة في القيد لدى الهيئة توافر المعايير الآتية:
1- أن تكون الجهة أحد الكيانات التشغيلية المعترف بها دوليًا Designated Operational Entities (DOE) طبقا للمعايير المصدرة عن سكرتارية اتفاقية الأمم المتحدة الإطارية بشأن تغير المناخ United Nations Framework Convention on Climate Change (UNFCCC)، أو أحد الجهات المعترف بها ضمن اتفاقية باريس بالمادة السادسة أو تكون الجهة معتمدة في سجل أو أكثر من سجلات الكربون الطوعية الدولية، ومنها على سبيل المثال لا الحصر:
- سجل الكربون الطوعي Gold Standard.
- سجل الكربون الطوعي The Verified Carbon Standard (VCS).
- سجل الكربون الطوعي Global Carbon Council (GCC).
2- تقديم كافة المستندات المؤيدة للخبرات وسابقة الأعمال في مجال أعمال التحقق والمصادقة لعدد ثلاث مشروعات كحد أدني مسجلة بأحد سجلات الكربون الطوعية الدولية المشار إليها بعالية.
3- أن يتضمن فريق العمل المختص بالقيام بأعمال التحقق أو المصادقة أحد الخبراء المصريين على الأقل ممن تتوافر فيه الكفاءة والخبرة المطلوبة.$b3_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$المادة الرابعة$t4_0$, $b4_0$تلتزم الجهات أو المشروعات الأجنبية الصادر لها شهادات خفض انبعاثات كربونية خارج مصر باخطار الهيئة بجهات التحقق والمصادقة في شأن تلك الشهادات، وذلك في حال رغبة هذه الجهات أو المشروعات تداول تلك الشهادات داخل مصر على أن يتم الإخطار وفقًا للنموذج المعد لذلك من قبل الهيئة.
وفي جميع الأحوال يشترط لتداول تلك الشهادات في مصر تحقق الهيئة من استيفاء جهات التحقق والمصادقة للبند رقم (1) من المادة الثالثة من هذا القرار.$b4_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins4_0;

WITH ins5_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5_0$المادة الخامسة$t5_0$, $b5_0$على جهات التحقق والمصادقة الراغبة في القيد لدى الهيئة تقديم طلب على النموذج المعد لذلك بالهيئة، مرفقًا به المستندات الدالة على استيفاء شروط القيد على النحو المشار إليه بهذا القرار، وأي مستندات أخرى ترى الهيئة ضرورة تقديمها.
وعلى الهيئة البت في طلب القيد خلال ثلاثين يومًا من تاريخ تقديمه مستوفيًا المستندات المؤيدة له.$b5_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins5_0;

WITH ins6_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $t6_0$المادة السادسة$t6_0$, $b6_0$يشترط لاستمرار قيد جهات التحقق والمصادقة لدى الهيئة، ما يلي:
1- توافر شروط ومعايير القيد لدى الهيئة على النحو المشار إليه بهذا القرار.
2- الالتزام بتنفيذ التعهدات المنصوص عليها بنموذج طلب القيد أو تجديده.$b6_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins6_0;

WITH ins7_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $t7_0$المادة السابعة$t7_0$, $b7_0$تكون مدة القيد لدى الهيئة لمدة سنة قابلة للتجديد لمدد أخرى، ويشترط لتجديد القيد لدى الهيئة توافر المعايير المتطلبة للقيد واستمراره.
ويكون مقابل خدمات فحص ودراسة طلب القيد لدى الهيئة على النحو الآتي:
أولًا: بالنسبة للأشخاص الاعتبارية المصرية:
1- بواقع ( 10,000 ) جنيه مصري تسدد عند تقديم طلب القيد لأول مرة.
2- بواقع ( 2،000 ) جنيه مصري عند تجديد طلب القيد.
ثانيًا: بالنسبة للأشخاص الاعتبارية الأجنبية:
1- بواقع ( 500 ) دولار امريكي تسدد عند تقديم طلب القيد لأول مرة.
2- بواقع (100) دولار امريكي تسدد عند تجديد طلب القيد.$b7_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins7_0;

WITH ins8_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $t8_0$المادة الثامنة$t8_0$, $b8_0$لمجلس إدارة الهيئة حال ثبوت مخالفة أي من المعايير التي تصدرها الهيئة في هذا الشأن أو فقد أحد معايير القيد أو استمرار القيد اتخاذ واحد أو أكثر من التدابير الاتية:
1- توجيه التنبيه بالمخالفات المنسوبة وتحديد الفترة الزمنية اللازمة لإزاله أسبابها.
2- الإيقاف المؤقت للقيد بالسجل لمدة لا تجاوز ستة أشهر.
3- شطب القيد من السجل مع عدم جواز إعادة القيد إلا بعد مضي مدة لا تقل عن سنة.$b8_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins8_0;

WITH ins9_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $t9_0$المادة التاسعة$t9_0$, $b9_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الالكتروني للهيئة، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.$b9_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins9_0;

WITH ins10_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, $h10$قرار مجلس إدارة الهيئة رقم (163) لسنة 2023 - هوامش التعديلات اللاحقة$h10$, $t10_0$هوامش التعديلات اللاحقة$t10_0$, $b10_0$(1) تم التعديل بموجب قرار مجلس إدارة الهيئة رقم 253 بتاريخ 2024/10/30.
(2) تم تعديل صدر المادة الأولى بموجب قرار مجلس إدارة الهيئة رقم 253 بتاريخ 2024/10/30.
(3) تم تعديل نص المادة الثانية بموجب قرار مجلس إدارة الهيئة رقم 253 بتاريخ 2024/10/30$b10_0$
  FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-10-30', 'active' FROM ins10_0;

DO $verify196$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 163 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[196] القرار 163/2023 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 11 THEN RAISE EXCEPTION '[196] عدد المواد % بدل 11', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2024-10-30';
  IF v_v <> 11 THEN RAISE EXCEPTION '[196] عدد النسخ % بدل 11', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%FINANCIAL REGULATORY%' OR body LIKE '%WWW.FRA%' OR body LIKE '%Building Bridges%' OR body LIKE '%القرية الذكية%' OR body LIKE '%قـرر%' OR body LIKE '%جملس%' OR body LIKE '%املالية%' OR body LIKE '%اهليئة%' OR body LIKE '%اإل%' OR body LIKE '%األ%' OR body LIKE '%ا ً%' OR body LIKE '%رررر%' OR body LIKE '%فريد صالح%' OR body LIKE '%�%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[196] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع على قانون سوق رأس المال %' AND body LIKE '%ر مجلس إدارة الهيئة رقم (57) لسنة 20%' AND body LIKE '%لسته المنعقدة بتاريخ 2023/8/9؛' AND body LIKE '%رقم (95) لسنة 1992%' AND body LIKE '%رقم (10) لسنة 2009%' AND body LIKE '%رقم (57) لسنة 2023%' AND body LIKE '%بتاريخ 2023/7/25؛%' AND body LIKE '%بتاريخ 2023/8/9؛' AND body LIKE '%بالقانون رقم (95) لسنة 1992 ول%' AND body LIKE '%رقم (95) لسنة 1992 ولائحته التنف%' AND body LIKE '% القانون رقم (10) لسنة 2009 بت%' AND body LIKE '%رقم (10) لسنة 2009 بتنظيم الرقاب%' AND body LIKE '%ة الهيئة رقم (57) لسنة 2023 بش%' AND body LIKE '%رقم (57) لسنة 2023 بشأن لجنة الإ%' AND body LIKE '%لمنعقد بتاريخ 2023/7/25؛%' AND body LIKE '%منعقدة بتاريخ 2023/8/9؛%') THEN RAISE EXCEPTION '[196] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'تنشأ بالهيئة قائمة لقيد جهات التحقق %' AND body LIKE '%نتاج المعادن (Metal Production).%' AND body LIKE '%ف القطاعات المشار إليها أعلاه.' AND body LIKE '%- قطاع الطاقة المتجددة/غير المتجددة Energy (Renewable/Nonrenewable).%' AND body LIKE '%- قطاع توزيع الطاقة (Energy Distribution).%' AND body LIKE '%- قطاع الصناعات الكيماوية (Manufacturing Industries).%' AND body LIKE '%Fugitive Emissions From Fuels, Solid، Oil, And Gas%' AND body LIKE '%(الهالوكربونات وسداسي فلوريد الكبريت).%' AND body LIKE '%(Waste Handling And Disposal).%' AND body LIKE '%- قطاع احتجاز الكربون وتخزينه (Carbon Capture and Storage).%' AND body LIKE '%(Livestock and Manure Management).%' AND body LIKE '%وتشمل تلك القطاعات ما يلي:%') THEN RAISE EXCEPTION '[196] المادة الأولى غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'يشترط في جهات التحقق والمصادقة المصر%' AND body LIKE '%ل على شهادة اعتماد الأيزو ISO-14064:%' AND body LIKE '%ن الطوعية المعتمدة لدى الهيئة.' AND body LIKE '%ISO-14065:2020 أو ISO/IEC 17029 أو أي تحديث لهما.%' AND body LIKE '%ISO 14064-2:2019 الخاصة بقياسات%' AND body LIKE '%ISO-14064:3 الخاصة بتوثيق%' AND body LIKE '%6- عدم صدور أحكام جنائية%' AND body LIKE '%كأحد جهات التحقق والمصادقة لدي أحد سجلات الكربون%' AND body LIKE '%والمصادقة ISO-14065:2020 أو ISO/I%' AND body LIKE '%دقة ISO-14065:2020 أو ISO/IEC 17%' AND body LIKE '%20 أو ISO/IEC 17029 أو أي تحديث ل%' AND body LIKE '%اد الأيزو ISO 14064-2:2019 الخاصة%' AND body LIKE '%يزو ISO 14064-2:2019 الخاصة ب%' AND body LIKE '%و ISO 14064-2:2019 الخاصة بقياسا%' AND body LIKE '%اد الأيزو ISO-14064:3 الخاصة بتوث%' AND body LIKE '%يزو ISO-14064:3 الخاصة بتوثيق%') THEN RAISE EXCEPTION '[196] المادة الثانية غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'يشترط في جهات التحقق والمصادقة الأجن%' AND body LIKE '%كربون الطوعي The Verified Carbon Sta%' AND body LIKE '% فيه الكفاءة والخبرة المطلوبة.' AND body LIKE '%Designated Operational Entities (DOE) طبقا%' AND body LIKE '%United Nations Framework Convention on Climate Change (UNFCCC)، أو أحد%' AND body LIKE '%- سجل الكربون الطوعي Gold Standard.%' AND body LIKE '%(VCS).%' AND body LIKE '%(GCC).%' AND body LIKE '%3- أن يتضمن فريق العمل%') THEN RAISE EXCEPTION '[196] المادة الثالثة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'تلتزم الجهات أو المشروعات الأجنبية ا%' AND body LIKE '% الأحوال يشترط لتداول تلك الشهادات ف%' AND body LIKE '% المادة الثالثة من هذا القرار.' AND body LIKE '%باخطار الهيئة بجهات%' AND body LIKE '%للبند رقم (1) من المادة الثالثة من هذا القرار.' AND body LIKE '%قة للبند رقم (1) من المادة ال%') THEN RAISE EXCEPTION '[196] المادة الرابعة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0 AND body LIKE 'على جهات التحقق والمصادقة الراغبة في%' AND body LIKE '%يئة البت في طلب القيد خلال ثلاثين يو%' AND body LIKE '%مستوفيًا المستندات المؤيدة له.' AND body LIKE '%خلال ثلاثين يومًا من تاريخ تقديمه%') THEN RAISE EXCEPTION '[196] المادة الخامسة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND article_suffix_order = 0 AND body LIKE 'يشترط لاستمرار قيد جهات التحقق والمص%' AND body LIKE '% شروط ومعايير القيد لدى الهيئة على ا%' AND body LIKE '%ها بنموذج طلب القيد أو تجديده.' AND body LIKE '%2- الالتزام بتنفيذ التعهدات%') THEN RAISE EXCEPTION '[196] المادة السادسة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND article_suffix_order = 0 AND body LIKE 'تكون مدة القيد لدى الهيئة لمدة سنة ق%' AND body LIKE '% ( 2،000 ) جنيه مصري عند تجديد طلب ا%' AND body LIKE '%ريكي تسدد عند تجديد طلب القيد.' AND body LIKE '%أولًا: بالنسبة للأشخاص الاعتبارية المصرية:%' AND body LIKE '%ثانيًا: بالنسبة للأشخاص الاعتبارية الأجنبية:%' AND body LIKE '%2- بواقع (100) دولار امريكي%' AND body LIKE '%1- بواقع ( 10,000 ) جنيه مصري ت%' AND body LIKE '%2- بواقع ( 2،000 ) جنيه مص%' AND body LIKE '%2- بواقع ( 2،000 ) جنيه مصري ع%' AND body LIKE '%1- بواقع ( 500 ) دولار امريك%') THEN RAISE EXCEPTION '[196] المادة السابعة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0 AND body LIKE 'لمجلس إدارة الهيئة حال ثبوت مخالفة أ%' AND body LIKE '%اف المؤقت للقيد بالسجل لمدة لا تجاوز%' AND body LIKE '%إلا بعد مضي مدة لا تقل عن سنة.' AND body LIKE '%لمدة لا تجاوز ستة أشهر.%' AND body LIKE '%لا تقل عن سنة.') THEN RAISE EXCEPTION '[196] المادة الثامنة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية و%' AND body LIKE '% القرار في الوقائع المصرية وعلى المو%' AND body LIKE '% لتاريخ نشره بالوقائع المصرية.' AND body LIKE '%بالوقائع المصرية.') THEN RAISE EXCEPTION '[196] المادة التاسعة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND article_suffix_order = 0 AND body LIKE '(1) تم التعديل بموجب قرار مجلس إدارة%' AND body LIKE '%عديل صدر المادة الأولى بموجب قرار مج%' AND body LIKE '%هيئة رقم 253 بتاريخ 2024/10/30' AND body LIKE '(1) تم التعديل بموجب%' AND body LIKE '%(3) تم تعديل نص المادة الثانية%' AND body LIKE '%(1) تم التعديل ب%' AND body LIKE '%رة الهيئة رقم 253 بتاريخ 2024/1%' AND body LIKE '%قم 253 بتاريخ 2024/10/30.%' AND body LIKE '%(2) تم تعديل صدر%' AND body LIKE '%(3) تم تعديل نص %' AND body LIKE '%قم 253 بتاريخ 2024/10/30%') THEN RAISE EXCEPTION '[196] الهوامش غير سليم'; END IF;
  IF v_len <> 6351 THEN RAISE EXCEPTION '[196] إجمالى طول المواد % بدل 6351', v_len; END IF;
  RAISE NOTICE '[196] القرار 163/2023: 11 مواد و11 نسخ، إجمالى % حرف', v_len;
END
$verify196$;

COMMIT;
