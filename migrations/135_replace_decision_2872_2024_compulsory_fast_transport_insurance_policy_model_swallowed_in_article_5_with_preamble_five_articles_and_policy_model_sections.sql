-- 135_replace_decision_2872_2024_compulsory_fast_transport_insurance_policy_model_swallowed_in_article_5_with_preamble_five_articles_and_policy_model_sections.sql
--
-- إعادة رفع قرار رئيس الهيئة العامة للرقابة المالية رقم (2872) لسنة 2024 بإصدار نموذج وثيقة التأمين
-- الإلزامى عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية،
-- المنشور بالوقائع المصرية، العدد 196 (تابع ج)، فى 3 سبتمبر 2025 (الصفحات 16–26).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P3) =====
-- مخزَّن منذ الهجرة 004 بخمس مواد، والمادة الخامسة (النشر والتوقيع) ابتلعت نموذج الوثيقة وجدول
-- التعويضات كاملين (نحو 10.4 ألف حرف) بأرقام هندية وترويسة الوقائع تتكرر 9 مرات داخلها وعلامات
-- تنوين مبعثرة وكلمات مقطوعة، والنص بلا ديباجة. القرار ضمن نطاق الحوكمة (لا تُمس بيانات laws).
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (11 صفحة) رفعه صاحب المشروع؛ رابط laws.official_url لم يُمس. الملف تالف الـxref
-- فأُصلح بـqpdf. استُخرج النص ونُظّف ثم قوبل بصور الصفحات الإحدى عشرة صفحة بصفحة؛ وأُصلحت أخطاء
-- الطبقة النصية (مثل "التزامات امعة" ← "التزامات المجمعة"، وتنوين العناوين "أولاً/ثانياً" المبعثر).
-- جداول نسب العجز الجزئى أُعيد بناؤها صفاً بصف: لكل حالة نسبتها "الأيمن" و"الأيسر" فى الجدول (1)
-- (الأيمن 60٪/الأيسر 50٪ ... إلخ) ولكل حالة نسبة واحدة فى (2) الأطراف السفلى و(3) الكسور و(4) الصمم.
-- أُبقى إملاء المصدر، ومنه "إلهام القدم" فى جدول الأطراف السفلى (يقصد به الإبهام؛ يظهر هكذا فى
-- الوقائع) و"الأيسر/الأيمن" كما وردا. عنوان القرار "قرار رقم 2872 لسنة 2024" ومُصدره "رئيس الهيئة
-- العامة للرقابة المالية" (يُثبَّت فى hierarchical_location للديباجة) ويوقعه رئيس مجلس الإدارة. قوبلت
-- كل الأعداد بين النص القديم والجديد فلم يبقَ إلا ترويسات الصفحات وأرقامها (16–26) وتكرار أرقام نص
-- المادة الخامسة المنقولة إلى موضعها. أُضيفت بين قوسين تنبيهات "(حقل يُملأ عند الإصدار)" لحقول
-- النموذج الفارغة حتى لا تُقرأ بيانات ناقصة كأنها قيم.
--
-- ===== الهيكل =====
-- 14 مادة، 14 نسخة (version_no = 1): ديباجة (article_no = 0) + المواد 1–5 + 8 أقسام لنموذج الوثيقة
-- وجدول التعويضات: 6 جدول الوثيقة؛ 7–10 الشروط العامة (أولاً–سابعاً)؛ 11 التعويضات (أولاً الوفاة،
-- ثانياً العجز الكلى)؛ 12 العجز الجزئى (1) الأطراف العليا؛ 13 (2) الأطراف السفلى (3) الكسور (4) الصمم
-- ثم رابعاً الأضرار المادية. الأرقام 6–13 أقسام للنموذج المرفق وليست مواد من القرار ويميزها
-- hierarchical_location. أُبقيت المواد 1–5 بأرقامها حتى لا يعيد بذر 004 إدراج مواد قديمة.
--
-- ===== التاريخ (قرار تقديرى يُراجَع، كما فى الهجرة 134) =====
-- المادة الخامسة تُعمل القرار "اعتبارا من تاريخ العمل بأحكام قانون التأمين الموحد" (155/2024) دون
-- تحديد تاريخ؛ فجُعل effective_from = 2024-07-11 وهو تاريخ نفاذ القانون المسجَّل على المنصة. النشر
-- بالوقائع 2025-09-03. enacted_at يبقى NULL.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (14 مادة بديباجة سليمة والقسم 13 موجود)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، محتوى،
-- 29 صفاً لنسب العجز، إجمالى الطول 11468 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix135$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[135] القرار 2872/2024 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 14
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 13 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[135] القرار 2872/2024 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[135] أُزيلت % مادة من القرار 2872/2024 (5 مواد، خامستها تبتلع النموذج وجدول التعويضات)', v_n;
  END IF;
END
$fix135$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار رئيس الهيئة العامة للرقابة المالية رقم 2872 لسنة 2024 بإصدار نموذج وثيقة التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية$h0$, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على قانون المرور الصادر بالقانون رقم 66 لسنة 1973 ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار رئيس الهيئة المصرية للرقابة على التأمين رقم 344 لسنة 2007 بإصدار نموذج وثيقة التأمين الإجباري عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية ؛
وعلى قرار رئيس الهيئة رقم 252 لسنة 2019 بإنشاء مجمعة التأمين الإجباري عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع ؛
قرر :$b0$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$يعمل بنموذج وثيقة التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية المرافق لهذا القرار ، في شأن كافة أنواع المركبات المرخص في تسييرها طبقا لأحكام قانون المرور .$b1$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$تلتزم مجمعة التأمين الإجباري عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع بالعمل بالنموذج المرفق بهذا القرار ، كما تلتزم بتضمين إيصالات تحصيل القسط التأميني رمز الاستجابة السريعة (QR Code) الذي يحتوي على البيانات والشروط الأساسية للوثيقة .$b2$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3$المادة الثالثة$t3$, $b3$يكون إثبات العجز الناشئ عن حوادث مركبات النقل السريع بمعرفة الجهة الطبية المختصة ويصرف مبلغ التأمين وفقا للنسب المبينة بالجدول المرافق لنموذج الوثيقة .$b3$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4$المادة الرابعة$t4$, $b4$يلغى قرار رئيس الهيئة المصرية للرقابة على التأمين رقم 344 لسنة 2007 المشار إليه ، كما يلغى كل حكم يخالف أحكام هذا القرار .$b4$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $t5$المادة الخامسة$t5$, $b5$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة ومجمعة التأمين الإجباري عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع ، ويعمل به اعتبارا من تاريخ العمل بأحكام قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024
رئيس مجلس إدارة الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b5$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $h6$نموذج وثيقة التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع المرافق بالقرار رقم 2872 لسنة 2024$h6$, $t6$نموذج الوثيقة - جدول الوثيقة (بيانات المجمعة وحدود التعويض وحقول الإصدار وحساب القسط)$t6$, $b6$نموذج وثيقة التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية وفقا لأحكام قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024
جدول الوثيقة
اسم المؤمن : المجمعة المصرية للتأمين الإجباري عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية .
المقر الرئيسي للمجمعة : 44 شارع عبد المنعم رياض - المهندسين .
المحافظة : الجيزة .
الوثيقة رقم : (حقل يُملأ عند الإصدار)
تليفون : +20233047949 داخلي : 112
وحدة المرور : (حقل يُملأ عند الإصدار)
البريد الإلكتروني : ecip@ecip-egypt.org
يخضع إصدار هذه الوثيقة وملاحقها لأحكام قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ، وقانون المرور الصادر بالقانون رقم 66 لسنة 1973 ولائحته التنفيذية وفقا لما يلي :
1- يبدأ سريان التغطية التأمينية بسداد قسط التأمين الموضح أدناه إلى المجمعة مباشرة .
2- تؤدي المجمعة مبالغ التأمين المستحقة عن الحوادث المشار إليها في المادتين رقمي (40 ، 47) من قانون التأمين الموحد ، وذلك على النحو الآتي :
(أ) في حالة الأضرار الجسمانية 100000 جنيه مصري (مائة ألف جنيه مصري) عن الشخص الواحد في حالة (الوفاة أو العجز الكلي المستديم) ، وفى حالة العجز الجزئي المستديم يكون المبلغ بمقدار نسبة العجز التي تحددها الجهة الطبية المختصة .
(ب) في حالة الأضرار المادية التي تلحق بممتلكات الغير يكون التعويض بحد أقصى 20000 جنيه مصري (عشرون ألف جنيه مصري) عن كل مضرور .
تلتزم المجمعة بعدم إتاحة بيانات العميل في أية أغراض تسويقية سواء بالاتصال الهاتفي أو الإلكتروني .
مدة تأمين الوثيقة من : (حقل) إلى : (حقل) (تتضمن الثلاثون يوما التالية للمدة المؤداة عنها الضريبة) .
بيانات المؤمن له (حقول تُملأ عند الإصدار) : الاسم ، الوظيفة أو الصناعة ، العنوان ، رقم الإثبات ، رقم التليفون .
بيانات المركبة (حقول تُملأ عند الإصدار) : رقم اللوحة ، جهة التأمين السابقة ، الماركة / الطراز ، الجهة المقيدة بها ، سنة الصنع ، شكل المركبة ، رقم الشاسيه ، حالة المركبة ، عدد السلندرات ، رقم المحرك ، عدد الركاب ، السعة اللترية ، نوع الوقود ، الكيلوات ، عدد المحاور ، حمولة المركبة بالكيلو جرام ، الغرض من الترخيص ، وزن المعدة .
حساب القسط (كل بند بالجنيه المصري ويُملأ عند الإصدار) : صافي القسط ، نصف الدمغة النسبية ، ضريبة نوعية ، رسوم الإشراف والرقابة ، مقابل خدمات مراجعة واعتماد وثائق التأمين ، إجمالي القسط .
### فقط ........................... جنيه مصري لا غير ###
تحريرا في : / / تاريخ الإصدار : / /
فى حالة وجود أي استفسار أو شكوى يرجى الاتصال بالمجمعة على أي من وسائل الاتصال الموضحة أعلاه .
وفى حالة وجود أي شكوى تعذر حلها بالمجمعة يمكن التواصل مع الهيئة العامة للرقابة المالية .
صدرت هذه الوثيقة من المجمعة ولا تحتاج إلى توقيع المؤمن له عليها .$b6$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, $h7$نموذج وثيقة التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع المرافق بالقرار رقم 2872 لسنة 2024$h7$, $t7$نموذج الوثيقة - الشروط العامة: أولاً الأخطار المغطاة، ثانياً التزامات المجمعة$t7$, $b7$الشروط العامة
أولاً - الأخطار المغطاة
تلتزم المجمعة بتغطية المسئولية المدنية الناشئة عن الحوادث التي تقع للغير داخل جمهورية مصر العربية عن المركبة المثبت بياناتها في هذه الوثيقة ، وذلك خلال مدة سريانها دون اللجوء للقضاء عن الأخطار الآتية :
1- الوفاة .
2- العجز الكلي أو الجزئي المستديم .
وتسري التغطية الواردة بالبندين (1 ، 2) أعلاه إذا توفى المصاب أو لحق به عجز كلي مستديم من جراء الحادث خلال سنة من تاريخ وقوعه وثبت بشهادة طبية معتمدة أن الوفاة أو العجز الكلي المستديم كان نتيجة الحادث .
3- الأضرار المادية التي تلحق بممتلكات الغير .
ويشمل الغير الركاب ويعتبر الشخص راكبا سواء كان في داخل السيارة أو صاعدا إليها أو نازلاً منها .
ثانياً - التزامات المجمعة
تلتزم المجمعة بسداد مبالغ التأمين المنصوص عليها بهذه الوثيقة في الحالات الواردة بالبند أولاً أعلاه ، على أن يصرف مبلغ التأمين في مدة لا تجاوز ثلاثين يوما من تاريخ إبلاغ المجمعة بوقوع الحادث واستيفاء المستندات اللازمة .$b7$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, $h8$نموذج وثيقة التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع المرافق بالقرار رقم 2872 لسنة 2024$h8$, $t8$نموذج الوثيقة - الشروط العامة: ثالثاً التزامات المؤمن له، رابعاً الاستثناءات$t8$, $b8$ثالثاً - التزامات المؤمن له
يجب على المؤمن له أو من ينوب عنه قانونا الالتزام بما يلي :
1- إبلاغ المجمعة بالحادث الذي تسببت فيه المركبة والموجب للتعويض خلال خمسة عشر يوما من تاريخ وقوعه .
2- اتخاذ جميع الاحتياطات والإجراءات اللازمة لتجنب تفاقم الأضرار الناجمة عن الحادث .
3- أن يقدم للمجمعة الأوراق والمستندات المتعلقة بالحادث حال تسليمها له .
وإذا أخل المؤمن له بأي من الالتزامات السابقة يحق للمجمعة الرجوع عليه بما تحملته من أضرار نتيجة ذلك ، ما لم يكن التأخير مبررا .
رابعاً - الاستثناءات
لا يغطي التأمين محل هذه الوثيقة بأي حال من الأحوال ما يلي :
1- قائد المركبة المتسببة في الحادث .
2- التلفيات التي تلحق بالمركبات .
3- الأضرار المادية التي تصيب الممتلكات المملوكة للمؤمن له أو لأي فرد من أفراد أسرته المقيمين معه أو المودعة لديهم أو التي في حيازتهم .
الأضرار المادية التي تلحق بممتلكات الغير والمغطاة بموجب وثيقة أو وثائق أكثر تخصصا .$b8$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins8;

WITH ins9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, $h9$نموذج وثيقة التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع المرافق بالقرار رقم 2872 لسنة 2024$h9$, $t9$نموذج الوثيقة - الشروط العامة: خامساً حق الرجوع$t9$, $b9$خامساً - حق الرجوع
للمجمعة أن ترجع على المؤمن له بقيمة ما يكون قد أدته من مبلغ التأمين في الحالات الآتية :
1- إذا ثبت أن المؤمن له أدلى ببيانات غير صحيحة أو أخفى وقائع جوهرية عند إبرام عقد التأمين تؤثر على قبول المجمعة تغطية الخطر .
2- إذا ثبت استعمال المركبة وقت وقوع الحادث في غير الغرض المبين برخصتها أو ثبت تحميلها بأكثر من الحمولة المقررة لها أو استخدامها في سباق أو اختبار السرعة أو السرعة الزائدة عن المسموح به داخل وخارج المدن أو السير في عكس الاتجاه .
3- إذا كان قائد المركبة سواء المؤمن له أو شخص آخر يقودها دون الحصول على رخصة قيادة أو رخصة قيادة مناسبة لنوع المركبة أو بموجب رخصة تسيير منتهية الصلاحية .
4- إذا ثبت أن قائد المركبة سواء كان المؤمن له أو شخص آخر سمح له بقيادتها ارتكب الحادث وهو في غير حالته الطبيعية بسبب تأثير تناول مشروبات كحولية أو مخدرات .
5- إذا ثبت وقوع الحادث عمدا من جانب المؤمن له .
ويجوز للمجمعة إذا أدت مبلغ التأمين في حالة قيام المسئولية المدنية قبل غير المؤمن له أو غير المصرح له بقيادة المركبة أن ترجع على المسئول عن وقوع الأضرار لاسترداد ما تكون قد أدته من مبالغ التأمين .
ولا يترتب على حق الرجوع المقرر للمجمعة وفقا لأحكام القانون والشروط الواردة بهذه الوثيقة الإخلال بحق المضرور في الرجوع على المسئول بالحقوق المدنية .$b9$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins9;

WITH ins10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, $h10$نموذج وثيقة التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع المرافق بالقرار رقم 2872 لسنة 2024$h10$, $t10$نموذج الوثيقة - الشروط العامة: سادساً إلغاء التأمين، سابعاً شرط التقادم$t10$, $b10$سادساً - إلغاء التأمين
لا يجوز للمجمعة ولا للمؤمن له إلغاء أو سحب وثيقة التأمين أثناء مدة سريانها ما دام ترخيص المركبة قائما ، ولا يرتب الإلغاء أي أثر بالنسبة للغير .
وفي حالة نقل الملكية للغير تسري الوثيقة الأصلية أو المجددة بالنسبة للمالك الجديد عن المدة الباقية .
سابعاً - شرط التقادم
تخضع دعوى المضرور في مواجهة المجمعة للتقادم المنصوص عليه في المادة (6) من قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024$b10$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins10;

WITH ins11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, $h11$جدول تعويضات الحالات التى يشملها التأمين الإلزامى المرافق بنموذج الوثيقة (القرار رقم 2872 لسنة 2024)$h11$, $t11$جدول التعويضات - أولاً الوفاة، ثانياً العجز الكلي المستديم$t11$, $b11$جدول تعويضات الحالات التي يشملها التأمين الإلزامي عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية وفقا لقانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024
تؤدى المجمعة المصرية للتأمين الإجباري عن المسئولية المدنية الناشئة عن حوادث مركبات النقل السريع داخل جمهورية مصر العربية مبلغ التأمين المحدد عن الحالات المشار إليها بالمادة (40) من قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 إلى المستحق أو ورثته وذلك وفقا لأحكام وثيقة التأمين الصادرة تنفيذا للقانون المذكور على النحو الآتي :
أولاً - في حالة الوفاة :
مبلغ التأمين المستحق 100000 جنيه (مائة ألف جنيه) عن الشخص الواحد .
ثانياً - العجز الكلي المستديم :
مبلغ التأمين المستحق 100000 جنيه (مائة ألف جنيه) عن الشخص الواحد .
ويعتبر العجز كليا مستديما في الحالات الآتية :
فقد إبصار العينين نهائيا .
فقد الذراعين أو اليدين .
فقد الساقين أو القدمين .
فقد ذراع وساق .
فقد ذراع وقدم .
فقد يد وساق .
فقد يد وقدم .
كما يعتبر عجز الطرف أو العضو كله أو بعضه عجزا مطلقا نهائيا عن أداء وظيفته في حكم الطرف أو العضو المفقود في تفسير هذه الوثيقة .
ولا يستحق للمضرور أي مبلغ قبل ثبوت العجز نهائيا .$b11$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins11;

WITH ins12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, $h12$جدول تعويضات الحالات التى يشملها التأمين الإلزامى المرافق بنموذج الوثيقة (القرار رقم 2872 لسنة 2024)$h12$, $t12$جدول التعويضات - ثالثاً العجز الجزئي المستديم: (1) الأطراف العليا$t12$, $b12$ثالثاً - العجز الجزئي المستديم :
مبلغا يعادل نسبة من مبلغ التأمين وذلك بنسبة العجز الجزئي عن كل مضرور حسب البيان الآتي :
(1) الأطراف العليا لغير الأعسر :
الفقد الكامل لذراع أو يد : نسبة العجز الجزئي الأيمن 60٪ ، الأيسر 50٪
الفقد الكامل لحركة الكتف : نسبة العجز الجزئي الأيمن 25٪ ، الأيسر 20٪
الفقد الكامل لحركة المرفق : نسبة العجز الجزئي الأيمن 20٪ ، الأيسر 15٪
الفقد الكامل لحركة المعصم : نسبة العجز الجزئي الأيمن 20٪ ، الأيسر 15٪
الفقد الكامل للإبهام والسبابة : نسبة العجز الجزئي الأيمن 30٪ ، الأيسر 25٪
الفقد الكامل للإبهام والأصبع غير السبابة : نسبة العجز الجزئي الأيمن 25٪ ، الأيسر 20٪
الفقد الكامل للسبابة والأصبع غير الإبهام : نسبة العجز الجزئي الأيمن 20٪ ، الأيسر 15٪
الفقد الكامل لثلاثة أصابع غير الإبهام والسبابة : نسبة العجز الجزئي الأيمن 25٪ ، الأيسر 20٪
الفقد الكامل للإبهام فقط : نسبة العجز الجزئي الأيمن 20٪ ، الأيسر 15٪
الفقد الكامل للسبابة فقط : نسبة العجز الجزئي الأيمن 15٪ ، الأيسر 10٪
الفقد الكامل للوسطى فقط : نسبة العجز الجزئي الأيمن 10٪ ، الأيسر 8٪
الفقد الكامل للبنصر فقط : نسبة العجز الجزئي الأيمن 8٪ ، الأيسر 7٪
الفقد الكامل للخنصر فقط : نسبة العجز الجزئي الأيمن 7٪ ، الأيسر 6٪
وإذا كان المضرور أعسر وكان قد تبين ذلك بالتقرير الطبي فإن الفئات المنصوص عليها أعلاه بالنسبة لمختلف حالات عجز اليد اليمنى تتبادل موضعها مع الفئات الخاصة بحالات عجز اليد اليسرى المناظرة لها .$b12$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins12;

WITH ins13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, $h13$جدول تعويضات الحالات التى يشملها التأمين الإلزامى المرافق بنموذج الوثيقة (القرار رقم 2872 لسنة 2024)$h13$, $t13$جدول التعويضات - ثالثاً (2) الأطراف السفلى (3) الكسور (4) الصمم وفقد الأبصار، ورابعاً الأضرار المادية$t13$, $b13$(2) الأطراف السفلى :
الفقد الكامل لطرف سفلي إلى ما فوق الركبة : نسبة العجز الجزئي 50٪
الفقد الكامل لطرف سفلي إلى ما تحت الركبة : نسبة العجز الجزئي 40٪
البتر الجزئي للقدم والشامل لجميع الأصابع : نسبة العجز الجزئي 30٪
الفقد الكامل لحركة الحرقفة : نسبة العجز الجزئي 30٪
الفقد الكامل لحركة الركبة : نسبة العجز الجزئي 30٪
الفقد الكامل لحركة مفصل القدم : نسبة العجز الجزئي 15٪
الفقد الكامل لحركة إلهام القدم : نسبة العجز الجزئي 8٪
(3) الكسور :
كسر لم يلتحم بالساق : نسبة العجز الجزئي 30٪
كسر لم يلتحم بالقدم : نسبة العجز الجزئي 20٪
كسر لم يلتحم بالرصغة : نسبة العجز الجزئي 20٪
كسر لم يلتحم بالفك الأسفل : نسبة العجز الجزئي 25٪
كسر ضلعي بصحبة تشوه دائم في الصدر واضطرابات وظيفية. : نسبة العجز الجزئي 10٪
(4) الصمم وانكماش الأطراف وفقد الأبصار :
صمم تام : نسبة العجز الجزئي 40٪
صمم إحدى الأذنين : نسبة العجز الجزئي 15٪
انكماش طرف سفلى خمسة [5] سنتيمترات على الأقل. : نسبة العجز الجزئي 15٪
الفقد الكامل لعين واحدة : نسبة العجز الجزئي 35٪
ويعتبر عجز الطرف أو العضو كله أو بعضه عجزا مطلقا نهائيا عن أداء وظيفته في حكم الطرف أو العضو المفقود في تفسير هذه الوثيقة .
وفي حالة فقد أحد الأطراف أو الأعضاء كله أو بعضه فقدا جزئيا يقدر مدى العجز فيه بنسبته إلى الفقد الكامل .
أما بالنسبة لحالات العجز المستديم غير الواردة في هذا البند فتحدد نسبتها بمعرفة الطبيب المعالج وبشرط أن تقرها الجهة الطبية المختصة على أنه من المتفق عليه ما يلي:
إذا نشأت عن ذات الإصابة حالات عجز متعددة تتناول أطراف أو أعضاء مختلفة أو أي أجزاء من أحد الأطراف أو الأعضاء يحسب المبلغ المستحق في هذه الحالة على أساس جملة النسبة التي يمنحها هذا البند عن جملة حالات العجز المذكور على ألا يتعدى بأي حال من الأحوال مبلغ التأمين المستحق لحالة الوفاة .
رابعاً - الأضرار المادية :
الحد الأقصى لالتزام المجمعة عن الأضرار المادية التي تلحق بممتلكات الغير دون تلفيات المركبات 20000 جنيه (عشرون ألف جنيه) عن كل مضرور .$b13$
  FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2024-07-11', 'active' FROM ins13;

DO $verify135$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int; v_rows int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 2872 AND law_year = 2024 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[135] القرار 2872/2024 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 14 THEN RAISE EXCEPTION '[135] عدد المواد % بدل 14', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active';
  IF v_v <> 14 THEN RAISE EXCEPTION '[135] عدد النسخ % بدل 14', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الوقائع المصریة%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[135] % مادة بها تلف (أرقام هندية/استبدال/تطويل/ترويسة)', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND body LIKE '%د. محمد فريد صالح' AND body LIKE '%اعتبارا من تاريخ العمل بأحكام قانون التأمين الموحد%' AND length(body) < 400) THEN RAISE EXCEPTION '[135] المادة 5 غير سليمة أو ما زال النموذج داخلها'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%344 لسنة 2007%' AND body LIKE '%252 لسنة 2019%' AND body LIKE '%155 لسنة 2024%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[135] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE '%كافة أنواع المركبات المرخص%') THEN RAISE EXCEPTION '[135] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE '%(QR Code)%' AND body LIKE '%تلتزم مجمعة التأمين الإجباري%') THEN RAISE EXCEPTION '[135] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND body LIKE '%الجهة الطبية المختصة%') THEN RAISE EXCEPTION '[135] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND body LIKE '%344 لسنة 2007%') THEN RAISE EXCEPTION '[135] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND body LIKE '%ecip@ecip-egypt.org%' AND body LIKE '%100000 جنيه مصري (مائة ألف جنيه مصري)%' AND body LIKE '%20000 جنيه مصري (عشرون ألف جنيه مصري)%' AND body LIKE '%+20233047949%') THEN RAISE EXCEPTION '[135] جدول الوثيقة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND body LIKE '%نازلاً منها%' AND body LIKE '%لا تجاوز ثلاثين يوما%') THEN RAISE EXCEPTION '[135] الشروط أولاً/ثانياً غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND body LIKE '%خمسة عشر يوما%' AND body LIKE '%أكثر تخصصا%') THEN RAISE EXCEPTION '[135] الشروط ثالثاً/رابعاً غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 9 AND body LIKE '%السير في عكس الاتجاه%' AND body LIKE '%بالحقوق المدنية%') THEN RAISE EXCEPTION '[135] حق الرجوع غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 10 AND body LIKE '%المادة (6) من قانون التأمين الموحد%') THEN RAISE EXCEPTION '[135] الإلغاء والتقادم غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 11 AND body LIKE '%فقد يد وقدم%' AND body LIKE '%100000 جنيه (مائة ألف جنيه)%') THEN RAISE EXCEPTION '[135] التعويضات غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 12 AND body LIKE '%الفقد الكامل لذراع أو يد : نسبة العجز الجزئي الأيمن 60٪ ، الأيسر 50٪%' AND body LIKE '%الفقد الكامل للخنصر فقط : نسبة العجز الجزئي الأيمن 7٪ ، الأيسر 6٪%') THEN RAISE EXCEPTION '[135] العجز الجزئى (1) غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 13 AND body LIKE '%إلهام القدم : نسبة العجز الجزئي 8٪%' AND body LIKE '%الفقد الكامل لعين واحدة : نسبة العجز الجزئي 35٪%' AND body LIKE '%20000 جنيه (عشرون ألف جنيه) عن كل مضرور .%') THEN RAISE EXCEPTION '[135] العجز الجزئى (2-4) غير سليم'; END IF;
  SELECT COALESCE(sum((length(body) - length(replace(body, ' : نسبة العجز الجزئي ', ''))) / length(' : نسبة العجز الجزئي ')), 0) INTO v_rows FROM articles WHERE law_id = v_law_id AND article_no BETWEEN 12 AND 13;
  IF v_rows <> 29 THEN RAISE EXCEPTION '[135] صفوف نسب العجز % بدل 29', v_rows; END IF;
  IF v_len <> 11468 THEN RAISE EXCEPTION '[135] إجمالى طول المواد % بدل 11468', v_len; END IF;
  RAISE NOTICE '[135] القرار 2872/2024: 14 مواد (ديباجة + 5 مواد + 8 أقسام للنموذج والجدول) و14 نسخ، إجمالى % حرف', v_len;
END
$verify135$;

COMMIT;
