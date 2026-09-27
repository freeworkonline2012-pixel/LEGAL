-- 070_seed_law_81_2016_civil_service.sql
--
-- بذر القانون رقم 81 لسنة 2016 بإصدار قانون الخدمة المدنية —
-- 85 صفاً: 5 مواد إصدار (article_suffix_order=-1) + 77 مادة
-- موضوعية من قانون الخدمة المدنية المرافق (article_suffix_order=0)
-- + 3 جداول أجور ملحقة (article_suffix_order=-2). الترتيب رقم 1
-- (الأصغر التالى) فى قائمة القوانين الناقصة بعد إتمام 114/1946 فى
-- migrations/069.
--
-- ===== المصدر =====
-- مسح ضوئى رسمى للجريدة الرسمية، العدد 43 مكرر (أ)، بتاريخ أول
-- نوفمبر 2016 (39 صفحة)، رفعه المستخدم مباشرة (مصدر رسمى موثوق —
-- توثيق كامل: ديباجة 'باسم الشعب / رئيس الجمهورية'، وتوقيع عبد
-- الفتاح السيسى فى ختام مواد الإصدار). قُرئت الصفحات 1-20 بصرياً
-- مباشرة فى هذه الجلسة (تأكيد بنية القانون: 5 مواد إصدار + مواد
-- 1-45 من القانون المرافق)، والصفحات 21-38 بصرياً مباشرة كذلك
-- (مواد 46-77 + الجداول الثلاثة). فُوِّض تفريغ نصى كامل حرفى لكل
-- الملف (39 صفحة) لوكيل فرعى بنفس منهجية التدقيق المزدوج المتبعة
-- سابقاً، وتم التحقق المتقاطع لعينات من نص هذا التفريغ (مواد
-- 46-53، والجداول الثلاثة كاملة) حرفياً مقابل الصور المقروءة
-- مباشرة فى هذه الجلسة — تطابق تام بلا فارق حرف واحد. لم تظهر
-- أى فجوة [غير واضح] فى كامل التفريغ (جودة مسح جيدة فى كل
-- الصفحات الـ39)، ونقطة واحدة أشار إليها الوكيل الفرعى تستحق
-- تنويهاً: عبارة 'دبلومة مدتها سنتان دراسيتان' فى المادة (39)
-- احتملت ترتيب كلمتين متقاربين بصرياً لا يغيران المعنى القانونى
-- (أُدرجت بالصياغة الأوضح والأكثر شيوعاً فى النصوص المصرية).
--
-- ===== فحص التعديلات اللاحقة (قاعدة 'لا اختلاق') =====
-- بحث ويب مخصص (استعلامان + قراءة مباشرة لمقالين مستقلين يعرضان
-- 'النص الكامل وفقاً لآخر تعديل') لم يُظهر أى قانون أو قرار بقانون
-- عدَّل نصوص هذا القانون منذ صدوره فى 2016-11-01 حتى تاريخ هذه
-- الهجرة. الموجود فقط تعديلات على اللائحة التنفيذية (قرار 1216
-- لسنة 2017، وقرار 714 لسنة 2019) — وهى خارج نطاق نص القانون
-- ذاته ولا تُدرج هنا. القانون يُنشر بنصه الأصلى الكامل كما صدر.
--
-- ===== قرار معمارى: مواد الإصدار (article_suffix_order=-1) =====
-- قياساً على سابقة مؤكَّدة فى migrations/066 (قانون 174/2025):
-- مواد الإصدار الخمس (تُلغى قانون 47/1978، تنقل الموظفين، تحدد
-- تاريخ النفاذ) تُدرج بـ suffix=-1 منفصلة عن مواد القانون
-- المرافق الموضوعية (1-77) بـ suffix=0 — كلاهما نص مُلزِم لكن
-- بطبيعة مختلفة (إجرائى/إصداري مقابل موضوعى).
--
-- ===== قرار معمارى: الجداول الملحقة (article_suffix_order=-2) =====
-- لا سابقة مباشرة لتمثيل جدول بيانى ملحق فى المخطط الحالى
-- (articles/article_versions نصّى بلا دعم جداول). القرار: تمثيل
-- كل جدول كصف 'مادة' بمعرّف مميز جديد (suffix=-2) بمتن نصى
-- يعرض كل صف من كل جدول حرفياً (مستوى وظيفى، درجة مالية، مدة
-- بينية، نسبة ترقية، أجر شهرى) — حل نهائى يحفظ البيانات المُلزِمة
-- قانوناً والمُستشهَد بها صراحة من مواد 29، 36، 73، بدل إسقاطها
-- بصمت أو تأجيل القانون بالكامل بسببها.
--
-- category='other' (لا فئة مخصصة لتوظيف القطاع العام/الخدمة
-- المدنية فى قيد laws_category_check الحالى؛ متمايزة عن 'labor'
-- التى تخص قانون العمل بالقطاع الخاص. نفس المعالجة المتبعة سابقاً
-- مع 15/2004 و114/1946).
--
-- effective_from موحَّد لكل الصفوف = 2016-11-02 (اليوم التالى
-- لنشر القانون فى 2016-11-01، عملاً بنص المادة الخامسة من قانون
-- الإصدار: 'يُعمل به من اليوم التالى لتاريخ نشره'). لا تعديل
-- تشريعى لاحق يستوجب تاريخ نفاذ مختلف (انظر فحص التعديلات أعلاه).
--
-- قابلة لإعادة التشغيل بأمان (idempotent).

BEGIN;

-- ===== laws =====
INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
VALUES (
  81, 2016,
  $lawt0$القانون رقم 81 لسنة 2016 بإصدار قانون الخدمة المدنية$lawt0$,
  $laws0$قانون الخدمة المدنية 81/2016$laws0$,
  'other', 'law', 'in_force',
  $url0$مصدر المستخدم المباشر: مسح ضوئى للجريدة الرسمية العدد 43 مكرر (أ) (2016-11-01)$url0$,
  '2016-11-01'
)
ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, -1, $eh00$القانون الأصلى (مواد إصدارية)$eh00$, $et00$المادة الأولى إصدار$et00$, $e00$يُعمل بأحكام القانون المرافق فى شأن الخدمة المدنية، وتسرى أحكامه على الوظائف فى الوزارات ومصالحها والأجهزة الحكومية ووحدات الإدارة المحلية والهيئات العامة وذلك ما لم تنص قوانين أو قرارات إنشائها على ما يخالف ذلك.$e00$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, -1, $eh10$القانون الأصلى (مواد إصدارية)$eh10$, $et10$المادة الثانية إصدار$et10$, $e10$يُلغى قانون نظام العاملين المدنيين بالدولة الصادر بالقانون رقم 47 لسنة 1978، كما يُلغى كل حكم يخالف أحكام القانون المرافق.$e10$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, -1, $eh20$القانون الأصلى (مواد إصدارية)$eh20$, $et20$المادة الثالثة إصدار$et20$, $e20$يُصدر رئيس مجلس الوزراء، بعد أخذ رأى مجلس الخدمة المدنية اللائحة التنفيذية للقانون المرافق خلال ثلاثة أشهر من تاريخ العمل به وإلى أن تصدر هذه اللائحة يستمر العمل باللوائح والقرارات القائمة حاليًا فيما لا يتعارض وأحكام القانون المرافق.$e20$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, -1, $eh30$القانون الأصلى (مواد إصدارية)$eh30$, $et30$المادة الرابعة إصدار$et30$, $e30$يُنقل الموظفون المعينون الموجودون بالخدمة قبل العمل بأحكام هذا القانون إلى الوظائف المعادلة لوظائفهم الحالية على النحو الموضح بالجداول أرقام (1، 2، 3) الملحقة بالقانون المرافق بها فيها المستوى الوظيفى الأول (أ)، ويكون ترتيب الأقدمية بين المنقولين لوظيفة واحدة بحسب أوضاعهم السابقة.
ويحتفظ كل منهم بالأجر المقرر له قانونًا والذى كان يتقاضاه إذا كان زاد على الأجر الوظيفى المقرر لمستوى وظيفته فى الجداول الملحقة بالقانون المرافق، أما إذا قلَّ الأجر المحتفظ به عن الأجر الوظيفى المقرر لمستوى وظيفته يصرف له الأجر الوظيفى المقرر فى الجداول المشار إليها.
ذلك كله مع عدم الإخلال بالقوانين والقرارات المنظمة للحدين الأدنى والأقصى للدخول.$e30$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, -1, $eh40$القانون الأصلى (مواد إصدارية)$eh40$, $et40$المادة الخامسة إصدار$et40$, $e40$يُنشر هذا القانون فى الجريدة الرسمية، ويُعمل به من اليوم التالى لتاريخ نشره.$e40$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $eh50$الباب الأول: الأحكام العامة$eh50$, $et50$مادة (1)$et50$, $e50$الوظائف المدنية حق للمواطنين على أساس الكفاءة والجدارة، وهى تكليف للقائمين بها لخدمة الشعب، وتكفل الدولة حقوقهم وحمايتهم، وقيامهم بأداء واجباتهم فى رعاية مصالح الشعب.
ويُحظر التمييز بين الموظفين فى تطبيق أحكام هذا القانون بسبب الدين أو الجنس أو لأى سبب آخر.$e50$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $eh60$الباب الأول: الأحكام العامة$eh60$, $et60$مادة (2)$et60$, $e60$يُقصد فى تطبيق أحكام هذا القانون بالكلمات والعبارات التالية المعنى المبين قرين كل منها:
1 - السلطة المختصة: الوزير أو المحافظ أو رئيس مجلس إدارة الهيئة بحسب الأحوال.
2 - الوحدة: الوزارة أو المصلحة أو الجهاز الحكومى أو المحافظة أو الهيئة العامة.
3 - الوظائف القيادية: وظائف المستويات الثلاثة التالية للسلطة المختصة والتى يرأس شاغلوها وحدات تنظيمية بالوحدة من مستوى إدارة عامة أو إدارة مركزية أو قطاعات، وما يعادلها من تقسيمات.
4 - وظائف الإدارة الإشرافية: وظائف المستوى التالى للوظائف القيادية، والتى يرأس شاغلوها إدارات بالوحدة.
5 - الموظف: كل من يشغل إحدى الوظائف الواردة بموازنة الوحدة.
6 - الأجر الوظيفى: الأجر المنصوص عليه فى الجداول الملحقة بهذا القانون مضمومًا إليه جميع العلاوات المقررة بمقتضى هذا القانون.
7 - الأجر المكمل: كل ما يحصل عليه الموظف نظير عمله بخلاف الأجر الوظيفى.
8 - كامل الأجر: كل ما يحصل عليه الموظف نظير عمله من أجر وظيفى وأجر مكمل.
9 - السنة: السنة المالية للدولة.
10 - الوزير المختص: الوزير المعنى بالخدمة المدنية.
11 - الجهاز: الجهاز المركزى للتنظيم والإدارة.$e60$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $eh70$الباب الأول: الأحكام العامة - مجلس الخدمة المدنية$eh70$, $et70$مادة (3)$et70$, $e70$يُنشأ مجلس للخدمة المدنية بغرض تقديم المقترحات الخاصة بتطوير الخدمة المدنية وتحسين الخدمات العامة فى البلاد، ويقوم على وجه الخصوص بالآتى:
(أ) إبداء المشورة فيما يُطرح عليه من قضايا الخدمة المدنية، سواء من رئيس مجلس الوزراء أو الوزير المختص أو رئيس الجهاز.
(ب) إبداء الرأى فى مشروعات القوانين واللوائح المتعلقة بالخدمة المدنية.
(جـ) إبداء الرأى فى طريقة ومعايير تقييم الجهات الحكومية وموظفى الخدمة المدنية.
(د) إبداء الرأى فى البرامج التدريبية المقدمة لموظفى الخدمة المدنية.
(هـ) إبداء الرأى فى القضايا المتعلقة بالأخلاقيات المهنية لموظفى الخدمة المدنية.
(و) تقديم المقترحات فيما يتعلق بالموازنة المخصصة للخدمة المدنية.
(ز) تقديم مقترحات تحسين أداء الخدمة المدنية.
ويُشكل مجلس الخدمة المدنية برئاسة رئيس الجهاز وعضوية كل من:
1 - رئيس الجمعية العمومية لقسمى الفتوى والتشريع بمجلس الدولة.
2 - رئيس قطاع الخدمة المدنية بالجهاز.
3 - رئيس قطاع الموازنة العامة للدولة بوزارة المالية.
4 - عضو من المنظمات النقابية المنتخبة يختاره الاتحاد العام لنقابات عمال مصر.
5 - أربعة خبراء فى الإدارة والموارد البشرية والقانون، يختارهم الوزير المختص لمدة ثلاث سنوات قابلة للتجديد ولمرة واحدة.
ويكون للمجلس أمانة فنية يصدر بتشكيلها قرار من رئيس المجلس.
ويضع المجلس لائحة داخلية تتضمن القواعد والإجراءات المتعلقة بسير العمل به وأمانته الفنية.
وتعتمد توصيات المجلس من الوزير المختص.$e70$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $eh80$الباب الأول: الأحكام العامة - لجنة الموارد البشرية$eh80$, $et80$مادة (4)$et80$, $e80$تُشكل فى كل وزارة وحدة، بقرار من السلطة المختصة، لجنة أو أكثر للموارد البشرية، برئاسة أحد موظفى الوحدة من شاغلى الوظائف القيادية وعضوية أربعة أعضاء، يكون من بينهم أحد القانونيين وأحد المتخصصين فى الموارد البشرية من داخل الوحدة أو خارجها، وأحد أعضاء اللجنة النقابية إن وجدت يختاره مجلس إدارة اللجنة النقابية.
وتختص اللجنة بالنظر فى التعيين فى الوظائف من المستوى الأول (ب) فما دونها، ومنح العلاوات لشاغليها ونقلهم خارج الوحدة واعتماد تقارير تقويم أدائهم، واقتراح البرامج والدورات التدريبية اللازمة لتنمية الموارد البشرية، وتغيير مفاهيم الوظيفة وثقافتها وتطوير أساليب العمل ورفع معدلات الأداء، وغير ذلك مما يُحال إليها من السلطة المختصة.
وتُرسل اللجنة اقتراحاتها إلى السلطة المختصة خلال أسبوع لاعتمادها، فإذا لم تعتمدها ولم تُبد اعتراضًا عليها خلال ثلاثين يومًا من تاريخ وصولها اعتبرت نافذة.
أما إذا اعترضت على اقتراحات اللجنة كلها أو بعضها، فيتعين أن تُبدى الأسباب المبررة لذلك كتابة وتُعيد ما اعترضت عليه للجنة للنظر فيه على ضوء هذه الأسباب، وتُحدد لها أجلاً للبت فيه، فإذا انقضى هذا الأجل دون أن تبدى اللجنة رأيها اعتبر رأى السلطة المختصة نافذًا، أما إذا تمسكت اللجنة برأيها خلال الأجل المحدد، ترسل اقتراحاتها إلى السلطة المختصة لاتخاذ ما تراه بشأنها ويعتبر قرارها فى هذه الحالة نهائيًا.
وتحدد اللائحة التنفيذية كيفية اختيار أعضاء اللجنة ونظام العمل بها.$e80$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins8;

WITH ins9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $eh90$الباب الأول: الأحكام العامة - لجنة الموارد البشرية$eh90$, $et90$مادة (5)$et90$, $e90$تُعلن القرارات التى تصدر فى شأن الخدمة المدنية فى نشرة رسمية تصدرها الوحدة ورقيًا أو إلكترونيًا.
وتحدد اللائحة التنفيذية كيفية وإجراءات النشر أو الإتاحة على نحو يكفل علم ذوى الشأن بها.$e90$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins9;

WITH ins10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $eh100$الباب الأول: الأحكام العامة - لجنة الموارد البشرية$eh100$, $et100$مادة (6)$et100$, $e100$يختص مجلس الدولة، دون غيره، بإبداء الرأى مسببًا فى المسائل المتعلقة بتطبيق أحكام هذا القانون ولائحته التنفيذية، بناءً على طلب السلطة المختصة.$e100$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins10;

WITH ins11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, $eh110$الباب الأول: الأحكام العامة - تنمية ثقافة الخدمة المدنية والموارد البشرية$eh110$, $et110$مادة (7)$et110$, $e110$تعمل الوحدة على تدريب وتأهيل وإعداد الموظفين للقيام بواجباتها ومسئولياتها على نحو يكفل تنمية ثقافة الخدمة المدنية ودورها فى المجتمع وتحقيق أهدافها.
ولكل وحدة إنشاء مركز لتنمية الموارد البشرية، بعد موافقة الجهاز، لتدريب وتأهيل وإعداد الموظفين بها وبالمصالح أو الوحدات أو الفروع التابعة لها، ويجوز إسناد عمليات التدريب والتأهيل والإعداد إلى مراكز وهيئات التدريب التى يصدر باعتمادها قرار من رئيس الجهاز.
وتحدد اللائحة التنفيذية إجراءات وضوابط إنشاء مراكز تنمية الموارد البشرية ونظام التدريب والتأهيل والإعداد وضوابط الالتحاق بها والشهادات التى تمنحها.$e110$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins11;

WITH ins12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, $eh120$الباب الأول: الأحكام العامة - تنمية ثقافة الخدمة المدنية والموارد البشرية$eh120$, $et120$مادة (8)$et120$, $e120$يجوز للوحدة أن تقوم بتدريب الشباب على الأنشطة والأعمال التخصصية بها بناءً على طلبهم دون التزامها بتعيينهم، وذلك على النحو الذى تنظمه اللائحة التنفيذية.$e120$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins12;

WITH ins13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, $eh130$الباب الثانى: الوظائف والعلاقة الوظيفية - الوظائف$eh130$, $et130$مادة (9)$et130$, $e130$تضع كل وحدة هيكلاً تنظيميًا لها، يُعتمد من السلطة المختصة، بعد أخذ رأى الجهاز، يتضمن تقسيمها إلى تقسيمات فرعية تتناسب مع أنشطتها وحجم ومجالات العمل بها.
وتضع كل وحدة جدولاً للوظائف مرفقًا به بطاقات وصف كل وظيفة، تتضمن تحديد مستواها الوظيفى وطريقة شغلها والمجموعة الوظيفية التى تنتمى إليها والشروط اللازم توافرها فيمن يشغلها، والواجبات والمسئوليات والمهام المنوطة بها، ومؤشرات قياس أدائها.
ويختص رئيس الجهاز باعتماد جدول وظائف كل وحدة وحجم الموارد البشرية اللازمة لها فى ضوء احتياجاتها الفعلية.$e130$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins13;

WITH ins14 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, $eh140$الباب الثانى: الوظائف والعلاقة الوظيفية - الوظائف$eh140$, $et140$مادة (10)$et140$, $e140$تُقسم الوظائف الخاضعة لأحكام هذا القانون إلى المجموعات الوظيفية الرئيسية الآتية:
1 - مجموعة الوظائف التخصصية.
2 - مجموعة الوظائف الفنية.
3 - مجموعة الوظائف الكتابية.
4 - مجموعة الوظائف الحرفية والخدمة المعاونة.
وتعتبر كل مجموعة وظيفية وحدة متميزة فى مجال التعيين والترقية والنقل والندب والإعارة.
وتتكون كل مجموعة وظيفية من مجموعات نوعية، وتنظم اللائحة التنفيذية معايير إنشاء هذه المجموعات النوعية والنقل بين المجموعات المتماثلة.$e140$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins14;

WITH ins15 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, $eh150$الباب الثانى: الوظائف والعلاقة الوظيفية - الوظائف$eh150$, $et150$مادة (11)$et150$, $e150$يكون شغل الوظائف عن طريق التعيين أو الترقية أو النقل أو الندب أو الإعارة بمراعاة استيفاء شروط شغلها، وذلك بحسب الأحوال المبينة بهذا القانون.$e150$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins15;

WITH ins16 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, $eh160$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف$eh160$, $et160$مادة (12)$et160$, $e160$يكون التعيين بموجب قرار يصدر من رئيس الجمهورية أو من يفوضه، على أساس الكفاءة والجدارة، دون محاباة أو وساطة من خلال إعلان مركزى على موقع بوابة الحكومة المصرية متضمنًا البيانات المتعلقة بالوظيفة وشروط شغلها على نحو يكفل تكافؤ الفرص والمساواة بين المواطنين.
وفى جميع الأحوال يشترط لشغل الوظائف أن تكون شاغرة وممولة.
ويكون التعيين فى تلك الوظائف بامتحان ينفذه الجهاز من خلال لجنة للاختيار، ويشرف عليه الوزير المختص، على أن يكون التعيين بحسب الأسبقية الواردة فى الترتيب النهائى لنتيجة الامتحان، وعند التساوى يقدم الأعلى فى مرتبة الحصول على المؤهل المطلوب لشغل الوظيفة، فالدرجة الأعلى فى ذات المرتبة، فالأعلى مؤهلاً، فالأقدم فى التخرج، فالأكبر سنًا.
وتحدد اللائحة التنفيذية قواعد الإعلان عن الوظائف الشاغرة وكيفيته، وتشكيل لجنة الاختيار وإجراءات انعقاد الامتحان وكيفيته وقواعد المفاضلة، على أن يكون الإعلان خلال شهرى يناير ويونيو من كل سنة عند الحاجة، وألا تقل مدة الإعلان والتقديم عن شهر، وتُعلن النتيجة على الموقع الإلكترونى المشار إليه بالفقرة الأولى من هذه المادة.$e160$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins16;

WITH ins17 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, $eh170$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف$eh170$, $et170$مادة (13)$et170$, $e170$تلتزم كل وحدة بتخصيص نسبة خمسة فى المائة من مجموع الوظائف بها للأشخاص ذوى الإعاقة.
وتُحدد بقرار من رئيس مجلس الوزراء الوظائف التى تُحجز للمصابين فى العمليات الحربية ومصابى الثورة والمحاربين القدماء ومصابى العمليات الأمنية متى سمحت حالتهم بالقيام بأعمالها، وذلك وفقًا للقواعد التى يحددها هذا القرار، على أن تلتزم الوحدة بتعيين هذه النسبة وفقًا لاحتياجاتها.
كما يجوز أن يعين فى هذه الوظائف أزواج الفئات المنصوص عليها فى الفقرة السابقة أو أحد أولادهم أو أحد والديهم أو أحد إخوتهم، القائمين بإعالتهم، وذلك فى حالة عجزهم عجزًا تامًا أو وفاتهم، إذا توافرت فيهم شروط شغل هذه الوظائف، وكذلك الأمر بالنسبة لأسر الشهداء والمفقودين فى العمليات الحربية وأسر شهداء العمليات الأمنية.$e170$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins17;

WITH ins18 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, $eh180$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف$eh180$, $et180$مادة (14)$et180$, $e180$يُشترط فيمن يعين فى إحدى الوظائف ما يأتى:
1 - أن يكون متمتعًا بالجنسية المصرية أو جنسية إحدى الدول العربية التى تعامل المصريين بالمثل فى تولى الوظائف المدنية.
2 - أن يكون محمود السيرة، حسن السمعة.
3 - ألا يكون قد سبق الحكم عليه بعقوبة جناية أو بعقوبة مقيدة للحرية فى جريمة مخلة بالشرف أو الأمانة ما لم يكن قد رُد إليه اعتباره.
4 - ألا يكون قد سبق فصله من الخدمة بحكم أو قرار تأديبى نهائى، ما لم يمضِ على صدوره أربع سنوات على الأقل.
5 - أن تثبت لياقته الصحية لشغل الوظيفة بشهادة تصدر من المجلس الطبى المختص.
6 - أن يكون مستوفيًا لاشتراطات شغل الوظيفة.
7 - أن يجتاز الامتحان المقرر لشغل الوظيفة.
8 - ألا تقل سنه عن ثمانية عشر عامًا ميلاديًا.$e180$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins18;

WITH ins19 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, $eh190$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف$eh190$, $et190$مادة (15)$et190$, $e190$يُوضع المعين لأول مرة تحت الاختبار لمدة ستة أشهر من تاريخ تسلمه العمل تتقرر خلالها مدى صلاحيته للعمل، فإذا ثبت عدم صلاحيته أُنهيت خدمته، وتحدد اللائحة التنفيذية أحوال وإجراءات عدم الصلاحية.
ولا يجوز نقل أو ندب أو إعارة المعين خلال فترة الاختبار.
ولا تسرى أحكام هذه المادة على شاغلى الوظائف القيادية والإدارة الإشرافية.$e190$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins19;

WITH ins20 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, $eh200$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف$eh200$, $et200$مادة (16)$et200$, $e200$يجوز التعاقد فى حالات الضرورة مع ذوى الخبرات فى التخصصات النادرة وفقًا للشروط والضوابط الآتية:
1 - ألا يوجد بالوحدة والأجهزة التابعة لها من يملك خبرة مماثلة فى التخصص المطلوب ويمكن الاستعانة به.
2 - ألا تقل خبرة المتعاقد معه فى التخصص المطلوب عن عشر سنوات.
3 - عدم الإخلال بالحد الأقصى للدخول.
4 - أن يكون التعاقد لمدة أو لمدد لا تجاوز ثلاث سنوات.
5 - أن يكون التعاقد بموافقة رئيس مجلس الوزراء، بناءً على عرض الوزير المختص.$e200$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins20;

WITH ins21 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, $eh210$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف القيادية والإدارة الإشرافية$eh210$, $et210$مادة (17)$et210$, $e210$يكون التعيين فى الوظائف القيادية والإدارة الإشرافية عن طريق مسابقة يعلن عنها على موقع بوابة الحكومة المصرية أو النشر فى جريدتين واسعتى الانتشار متضمنًا البيانات المتعلقة بالوظيفة. ويكون التعيين من خلال لجنة للاختيار لمدة أقصاها ثلاث سنوات، يجوز تجديدها بحد أقصى ثلاث سنوات، بناءً على تقارير تقويم الأداء، وذلك دون الإخلال بباقى الشروط اللازمة لشغل هذه الوظائف.
ويُشترط للتعيين فى هذه الوظائف التأكد من توفر صفات النزاهة من الجهات المعنية على أن يستند الرأى بعدم توفرها إلى قرائن كافية وأسباب جدية، واجتياز التدريب اللازم، ويحدد الجهاز مستوى البرامج التدريبية المتطلبة والجهات المعتمدة لتقديم هذه البرامج.
وتحدد اللائحة التنفيذية إجراءات وقواعد اختيار شاغلى هذه الوظائف وتشكيل لجنة الاختيار والإعداد والتأهيل اللازمين لشغلها وإجراءات تقويم نتائج أعمال شاغليها.
واستثناءً من أحكام هذا القانون يجوز للوزراء اختيار مساعدين ومعاونين لهم لمدة محددة وفقًا للنظام الذى يصدر به قرار من رئيس مجلس الوزراء بناءً على عرض الوزير المختص واقتراح الجهاز على أن يتضمن هذا النظام على الأخص قواعد اختيار وتقويم أداء هؤلاء والمعاملة المالية المقررة لهم.$e210$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins21;

WITH ins22 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, $eh220$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف القيادية والإدارة الإشرافية$eh220$, $et220$مادة (18)$et220$, $e220$تُنشأ بكل وزارة وحدة وظيفة واحدة دائمة لوكيل الوزارة بالمستوى الممتاز لمعاونة الوزير فى مباشرة اختصاصاته.
واستثناءً من أحكام المادة (17) من هذا القانون يختار الوزير الوكيل الدائم من خلال لجنة للاختيار وذلك لمدة أقصاها أربع سنوات، يجوز تجديدها بحد أقصى أربع سنوات أخرى، يُكلف خلالها بضمان الاستقرار التنظيمى والمؤسسى للوزارة والهيئات والأجهزة التابعة لها، ورفع مستوى كفاءة تنفيذ سياساتها، واستمرارية البرامج والمشروعات والخطط ومتابعتها تحت إشراف الوزير.
وتحدد اللائحة التنفيذية قواعد وضوابط اختيار الوكيل الدائم.$e220$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins22;

WITH ins23 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, $eh230$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف القيادية والإدارة الإشرافية$eh230$, $et230$مادة (19)$et230$, $e230$يؤدى كل موظف يعين فى وظيفة من الوظائف القيادية أمام السلطة المختصة وقبل أن يباشر عمله اليمين الآتية: «أقسم بالله العظيم أن أحترم الدستور والقانون، وأن أخدم الدولة، وأن أحافظ على المال العام، وأن أؤدى واجباتى الوظيفية بنزاهة وشفافية وبروح فريق العمل وعلى الوجه الأكمل لخدمة الشعب».$e230$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins23;

WITH ins24 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, $eh240$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف القيادية والإدارة الإشرافية$eh240$, $et240$مادة (20)$et240$, $e240$تنتهى مدة شغل الوظائف القيادية والإدارة الإشرافية بانقضاء المدة المحددة فى قرار شغلها ما لم يصدر قرار بتجديدها، وبانتهاء هذه المدة يشغل الموظف وظيفة أخرى لا يقل مستواها عن مستوى الوظيفة التى كان يشغلها إذا كان من موظفى الدولة قبل شغله لإحدى هذه الوظائف.
ويجوز للموظف خلال الثلاثين يومًا التالية لانتهاء مدة شغله لإحدى الوظائف المشار إليها طلب إنهاء خدمته، وفى هذه الحالة تسوى حقوقه التأمينية على أساس مدة اشتراكه فى التأمين الاجتماعى مضافًا إليها مدة خمس سنوات أو المدة الباقية لبلوغه السن المقررة قانونًا لترك الخدمة أيهما أقل، ويعامل فيما يتعلق بالمعاش الذى يستحقه فى وظيفته السابقة معاملة من تنتهى خدمته ببلوغه هذه السن.
وتتحمل الخزانة العامة للدولة الزيادة فى الحقوق التأمينية الناتجة عن تطبيق هذه المادة.
ويجب أن تُتخذ الإجراءات اللازمة لتجديد مدة شغل الوظائف القيادية والإدارة الإشرافية أو النقل منها طبقًا للأحكام السابقة قبل انتهاء المدة المحددة لشغل الوظيفة بستين يومًا على الأقل.$e240$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins24;

WITH ins25 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, $eh250$الباب الثانى: الوظائف والعلاقة الوظيفية - التعيين فى الوظائف القيادية والإدارة الإشرافية$eh250$, $et250$مادة (21)$et250$, $e250$لا تسرى أحكام المادتين (17، 20) من هذا القانون على الجهات والوظائف ذات الطبيعة الخاصة التى يصدر بتحديدها قرار من رئيس الجمهورية، ويكون التعيين فى الوظائف القيادية والإدارة الإشرافية فى هذه الجهات والوظائف بقرار من رئيس الجمهورية أو من يفوضه.
ويكون شغل هذه الوظائف عن طريق الترقية بالاختيار وذلك على أساس بيانات تقويم الأداء وما ورد فى ملف الخدمة من عناصر الامتياز.$e250$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins25;

WITH ins26 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, $eh260$الباب الثانى: الوظائف والعلاقة الوظيفية - العلاقة الوظيفية$eh260$, $et260$مادة (22)$et260$, $e260$تعتبر الأقدمية فى الوظيفة من تاريخ شغلها، فإذا اتحد تاريخ شغل الوظيفة لأكثر من موظف اعتبرت الأقدمية وفقًا لما يأتى:
1 - إذا كان شغل الوظيفة لأول مرة اعتبرت الأقدمية بحسب الأسبقية فى التعيين طبقًا لما ورد فى المادة (12) من هذا القانون.
2 - إذا كان شغل الوظيفة بطريق الترقية اعتبرت الأقدمية على أساس الأقدمية فى الوظيفة السابقة.$e260$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins26;

WITH ins27 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, $eh270$الباب الثانى: الوظائف والعلاقة الوظيفية - العلاقة الوظيفية$eh270$, $et270$مادة (23)$et270$, $e270$مع عدم الإخلال بأحكام المادة (76) من هذا القانون، يجوز للموظفين الحاصلين على مؤهلات أعلى قبل الخدمة أو أثنائها، التقدم للوظائف الخالية بالوحدات التى يعملون بها أو غيرها من الوحدات، متى كانت تلك المؤهلات متطلبة لشغلها، ويشترط استيفائهم الشروط اللازمة لشغل هذه الوظائف.$e270$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins27;

WITH ins28 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, $eh280$الباب الثانى: الوظائف والعلاقة الوظيفية - العلاقة الوظيفية$eh280$, $et280$مادة (24)$et280$, $e280$لا يجوز بأية حال من الأحوال أن يعمل موظف تحت الرئاسة المباشرة لأحد أقاربه من الدرجة الأولى فى ذات الوحدة، وتحدد اللائحة التنفيذية الإجراءات الواجب اتخاذها عند توافر هذه الحالة.$e280$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins28;

WITH ins29 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, $eh290$الباب الثالث: تقويم الأداء$eh290$, $et290$مادة (25)$et290$, $e290$تضع السلطة المختصة نظامًا يكفل تقويم أداء الموظف بالوحدة بما يتفق وطبيعة نشاطها وأهدافها ونوعية وظائفها.
ويكون تقويم أداء الموظف عن سنة مالية على مرتين على الأقل قبل وضع التقرير النهائى، ويقتصر تقويم الأداء على القائمين بالعمل فعلاً بالوحدة مدة ستة أشهر على الأقل.
ويكون الأداء العادى هو الأساس المعوَّل عليه فى تقويم أداء الموظفين بما يحقق أهداف الوحدة ونشاطها ونوعية الوظائف بها.
ويكون تقويم الأداء بمرتبة ممتاز، أو كفء، أو فوق المتوسط، أو متوسط، أو ضعيف.
وتُحدد اللائحة التنفيذية ضوابط وإجراءات التقويم بما يكفل الحيادية والدقة فى القياس وصولاً للمنحنى الطبيعى للأداء، وكذا ميعاد وضع تقارير التقويم وكيفية اعتمادها والتظلم منها ومعادلة هذه المراتب بالمراتب المعمول بها فى تاريخ العمل بهذا القانون.
ويقدر تقويم أداء الموظف الذى لم يقم بالعمل فعليًا بالوحدة لمدة ستة أشهر على الأقل بسبب التجنيد، أو للاستدعاء للاحتياط أو للاستبقاء، أو للمرض، أو للإجازة أو لإجازة رعاية الطفل، أو لعضوية أحد المجالس النقابية، أو لعضوية مجلس النواب بمرتبة كفء حكمًا، فإذا كان تقويم أدائه فى العام السابق بمرتبة ممتاز يقدر بمرتبة ممتاز حكمًا.$e290$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins29;

WITH ins30 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 26, 0, $eh300$الباب الثالث: تقويم الأداء$eh300$, $et300$مادة (26)$et300$, $e300$تُعلن إدارة الموارد البشرية للموظف بصورة من تقرير تقويم أدائه بمجرد اعتماده من السلطة المختصة.
وله أن يتظلم منه خلال خمسة عشر يومًا من تاريخ إعلانه.
ويكون تظلم الموظفين شاغلى الوظائف القيادية والإدارة الإشرافية من التقارير المقدمة عن أدائهم إلى السلطة المختصة.
ويكون تظلم باقى الموظفين إلى لجنة تظلمات، تنشأ لهذا الغرض، وتُشكل بقرار من السلطة المختصة من ثلاثة من شاغلى الوظائف القيادية، وعضو تختاره اللجنة النقابية بالوحدة إن وُجدت.
ويُبت فى التظلم خلال ستين يومًا من تاريخ تقديمه، ويجب على إدارة الموارد البشرية إعلان الموظف بنتيجة تظلمه والأسباب التى بُنى عليها، ويكون قرار السلطة المختصة أو اللجنة نهائيًا، وذلك مع عدم الإخلال بحقه فى التقاضى.
ولا يُعتبر تقرير تقويم الأداء نهائيًا إلا بعد انقضاء ميعاد التظلم منه أو البت فيه.
وتحدد اللائحة التنفيذية كيفية إعلان الموظف بتقرير تقويم الأداء ونتيجة التظلم منه.$e300$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins30;

WITH ins31 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 27, 0, $eh310$الباب الثالث: تقويم الأداء$eh310$, $et310$مادة (27)$et310$, $e310$يُعرض أمر الموظف الذى يُقدم عنه تقريران سنويان متتاليان بمرتبة ضعيف على لجنة الموارد البشرية، لنقله لوظيفة أخرى ملائمة فى ذات مستوى وظيفته لمدة سنة.
وإذا تبين للجنة بعد انقضاء المدة المشار إليها فى الفقرة السابقة أنه غير صالح للعمل بها بطريقة مرضية، اقترحت خصم (50٪) من الأجر المكمل لمدة ستة أشهر.
وإذا تبين بعدها أنه غير صالح للعمل، اقترحت اللجنة إنهاء خدمته لعدم الصلاحية للوظيفة مع حفظ حقوقه التأمينية.
وفى جميع الأحوال ترفع اللجنة تقريرها للسلطة المختصة للاعتماد.$e310$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins31;

WITH ins32 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 28, 0, $eh320$الباب الثالث: تقويم الأداء$eh320$, $et320$مادة (28)$et320$, $e320$تنتهى لعدم الصلاحية للوظيفة خدمة شاغلى الوظائف القيادية الذين يُقدم عنهم تقريران متتاليان بمرتبة أقل من فوق المتوسط من اليوم التالى لتاريخ صدور آخر تقرير نهائى مع حفظ حقهم فى المعاش.$e320$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins32;

WITH ins33 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 29, 0, $eh330$الباب الرابع: الترقية، والنقل، والندب، والحلول والإعارة - الترقية$eh330$, $et330$مادة (29)$et330$, $e330$مع مراعاة استيفاء الموظف لشروط شغل الوظيفة المرقى إليها، تكون الترقية بموجب قرار يصدر من السلطة المختصة من الوظيفة التى تسبقها مباشرة فى المستوى والمجموعة الوظيفية التى تنتمى إليها.
وتكون الترقية للوظائف التخصصية من المستوى الأول (ب) بالاختيار على أساس بيانات تقويم الأداء وما ورد فى ملف الخدمة من عناصر الامتياز، وتكون الترقية للوظائف التخصصية الأخرى بالاختيار فى حدود النسب الواردة فى الجدول رقم (1) الملحق بهذا القانون.
وتكون الترقية لباقى الوظائف بالأقدمية.
ويُشترط للترقية أن يحصل الموظف على تقرير تقويم أداء بمرتبة كفء فى السنتين السابقتين مباشرة على الترقية، أما الترقية بالاختيار فى الوظائف التخصصية فيجب الحصول على تقرير تقويم أداء بمرتبة ممتاز. فإذا كان عدد من تتوافر فيهم شروط الترقية بالاختيار من الحاصلين على مرتبة ممتاز أقل من العدد المخصص للترقية بالاختيار تكون الترقية فى الجزء الباقى من الحاصلين على مرتبة كفء، على الأقل عن ذات المدة السابقة. فإذا كان عدد من تتوافر فيهم شروط الترقية بالاختيار أقل من العدد المخصص لها تؤجل الترقية وتحجز الوظائف فى الجزء المتبقى فى أول ترقية تالية.
وباستثناء جزاءى الإنذار والخصم من الأجر مدة لا تزيد على عشرة أيام، لا تجوز ترقية الموظف قبل محو الجزاء الموقع عليه.
وتُحدد اللائحة التنفيذية ضوابط وإجراءات الترقية.$e330$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins33;

WITH ins34 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 30, 0, $eh340$الباب الرابع: الترقية، والنقل، والندب، والحلول والإعارة - الترقية$eh340$, $et340$مادة (30)$et340$, $e340$تُفضل عند الترقية بالاختيار ترقية الأعلى فى مجموع درجات تقويم أداء السنتين السابقتين مباشرة على الترقية، وعند التساوى يُفضل الأعلى فى مجموع درجات تقويم أداء السنة السابقة عليهما، فالحاصل على درجة علمية أعلى متى كانت متصلة بطبيعة العمل طبقًا لما تقرره السلطة المختصة بناءً على اقتراح لجنة الموارد البشرية، وعند التساوى يُفضل الأعلى فى التقدير العام لهذه الدرجة، فالأقدم فى المستوى الوظيفى المرقى منه.$e340$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins34;

WITH ins35 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 31, 0, $eh350$الباب الرابع: الترقية، والنقل، والندب، والحلول والإعارة - الترقية$eh350$, $et350$مادة (31)$et350$, $e350$يصدر قرار الترقية من السلطة المختصة، وتعتبر الترقية نافذة من تاريخ صدور القرار بها.
ويستحق الموظف اعتبارًا من هذا التاريخ الأجر الوظيفى المقرر للوظيفة المرقى إليها أو أجره السابق مضافًا إليه علاوة ترقية بنسبة (5٪) من هذا الأجر الوظيفى أيهما أكبر.$e350$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins35;

WITH ins36 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 32, 0, $eh360$الباب الرابع: الترقية، والنقل، والندب، والحلول والإعارة - النقل$eh360$, $et360$مادة (32)$et360$, $e360$يجوز بقرار من السلطة المختصة نقل الموظف من وحدة إلى أخرى وذلك إذا كان النقل لا يفوت عليه دوره فى الترقية أو كان بناءً على طلبه.
ويكون نقل شاغلى الوظائف القيادية إلى خارج الوحدة بقرار من رئيس مجلس الوزراء.
ولا يجوز نقل الموظف من وظيفة إلى أخرى تقل فى مستواها عن مستوى وظيفته الأصلية.
وتحدد اللائحة التنفيذية القواعد الخاصة بالنقل.$e360$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins36;

WITH ins37 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 33, 0, $eh370$الباب الرابع: الترقية، والنقل، والندب، والحلول والإعارة - الندب$eh370$, $et370$مادة (33)$et370$, $e370$يجوز بقرار من السلطة المختصة ندب الموظف للقيام بعمل وظيفة مؤقتًا بعمل وظيفة أخرى من ذات المستوى الوظيفى لوظيفته أو من المستوى الذى يعلوه مباشرةً فى ذات الوحدة التى يعمل بها أو فى وحدة أخرى، إذا كانت حاجة العمل فى الوظيفة الأصلية تسمح بذلك.
ولا يجوز ندب الموظف خارج الوحدة إلا بناءً على طلبه.
وتحدد اللائحة التنفيذية القواعد الخاصة بالندب، على ألا تزيد مدته على أربع سنوات.
وللوحدة المنتدب إليها الموظف اتخاذ إجراءات نقله من الوحدة المنتدب منها، بعد هذه المدة، وفى حالة رغبة الموظف، ووفقًا لحاجة العمل.
واستثناءً مما تقدم، يجوز بقرار من السلطة المختصة ندب الموظف بعد موافقته إلى الجمعيات والمؤسسات الأهلية ذات النفع العام، وتتحمل الوحدة بكامل الأجر أو بعضه، وذلك على النحو الذى تحدده اللائحة التنفيذية.$e370$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins37;

WITH ins38 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 34, 0, $eh380$الباب الرابع: الترقية، والنقل، والندب، والحلول والإعارة - الحلول$eh380$, $et380$مادة (34)$et380$, $e380$عند غياب شاغل وظيفة من الوظائف القيادية والإدارة الإشرافية عن العمل، يحل محله فى مباشرة واجبات ومسئوليات وظيفته مباشرةً من يليه فى ترتيب الأقدمية ما لم تحدد السلطة المختصة من يحل محله، على أن يكون من ذات المستوى أو من المستوى الأدنى مباشرة.$e380$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins38;

WITH ins39 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 0, $eh390$الباب الرابع: الترقية، والنقل، والندب، والحلول والإعارة - الإعارة$eh390$, $et390$مادة (35)$et390$, $e390$يجوز بقرار من السلطة المختصة إعارة الموظف للعمل بالداخل أو الخارج بعد موافقة كتابية منه، ويُحدد القرار الصادر بالإعارة مدتها.
ويترتب على إعارة شاغل وظيفة من الوظائف القيادية أو الإدارة الإشرافية انتهاء مدة شغله لها.
ويكون أجر الموظف المعار بكامله على الجهة المستعيرة، وتدخل مدة الإعارة ضمن مدة خدمته، ولا يجوز ترقية المعار إلا بعد عودته من الإعارة واستكمال المدة البينية اللازمة لشغل الوظيفة الأعلى مباشرةً ولا تدخل مدة الإعارة ضمن المدة البينية اللازمة للترقية.
وتدخل مدة الإعارة ضمن مدة اشتراك الموظف فى نظام التأمين الاجتماعى واستحقاق العلاوة، وذلك مع مراعاة أحكام قانون التأمين الاجتماعى الصادر بالقانون رقم 79 لسنة 1975.
وتحدد اللائحة التنفيذية القواعد الخاصة بالإعارة.$e390$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins39;

WITH ins40 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 0, $eh400$الباب الخامس: الأجور والعلاوات - الأجر الوظيفى$eh400$, $et400$مادة (36)$et400$, $e400$يُحدد الأجر الوظيفى للوظائف وفقًا للجداول أرقام (1، 2، 3) الملحقة بهذا القانون.
ويستحق الموظف أجره من تاريخ تسلمه العمل، ما لم يكن مستبقًى بالقوات المسلحة فيستحق أجره من تاريخ التعيين.$e400$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins40;

WITH ins41 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 37, 0, $eh410$الباب الخامس: الأجور والعلاوات - العلاوات$eh410$, $et410$مادة (37)$et410$, $e410$يستحق الموظف علاوة دورية سنوية فى الأول من يوليو التالى لانقضاء سنة من تاريخ شغل الوظيفة أو من تاريخ استحقاق العلاوة الدورية السابقة بنسبة (7٪) من الأجر الوظيفى، على أن يُعاد النظر فى هذه النسبة بصفة دورية منتظمة.$e410$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins41;

WITH ins42 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 38, 0, $eh420$الباب الخامس: الأجور والعلاوات - العلاوات$eh420$, $et420$مادة (38)$et420$, $e420$يجوز للسلطة المختصة منح الموظف علاوة تشجيعية بنسبة (5٪) من أجره الوظيفى، وذلك طبقًا للشروط الآتية:
1 - أن تكون كفاية الموظف قد حُددت بمرتبة كفء على الأقل عن العامين الأخيرين.
2 - ألا يمنح الموظف هذه العلاوة أكثر من مرة كل ثلاثة أعوام.
3 - ألا يزيد عدد الموظفين الذين يُمنحون هذه العلاوة فى سنة واحدة على (10٪) من عدد الموظفين فى وظائف كل مستوى من كل مجموعة نوعية على حدة، فإذا كان عدد الموظفين فى تلك الوظائف أقل من عشرة تُمنح العلاوة لواحد منهم.$e420$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins42;

WITH ins43 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 39, 0, $eh430$الباب الخامس: الأجور والعلاوات - العلاوات$eh430$, $et430$مادة (39)$et430$, $e430$يستحق الموظف الذى يحصل على مؤهل أعلى أثناء الخدمة حافز تميز علمى.
ويمنح الموظف هذا الحافز إذا حصل على دبلومة مدتها سنتان دراسيتان على الأقل، أو على درجة الماجستير أو ما يعادلها أو دبلومتين من دبلومات الدراسات العليا مدة كل منهما سنة دراسية على الأقل، كما يمنح الموظف حافز تميز آخر إذا حصل على درجة الدكتوراة أو ما يعادلها.
ويكون حافز التميز العلمى المشار إليه بنسبة (7٪) من الأجر الوظيفى، أو الفئات المالية التالية أيهما أكبر:
- 25 جنيهًا شهريًا لمن يحصل على مؤهل متوسط أو فوق المتوسط.
- 50 جنيهًا شهريًا لمن يحصل على مؤهل عالٍ.
- 75 جنيهًا شهريًا لمن يحصل على دبلومة مدتها سنتان دراسيتان على الأقل.
- 100 جنيه شهريًا لمن يحصل على درجة الماجستير أو ما يعادلها أو دبلومتين من دبلومات الدراسات العليا مدة كل منها سنة دراسية على الأقل.
- 200 جنيه شهريًا لمن يحصل على درجة الدكتوراة أو ما يعادلها.
وتحدد اللائحة التنفيذية شروط وضوابط منح حافز التميز، على ألا يجوز منح هذا الحافز أكثر من مرة عن ذات المستوى العلمى.$e430$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins43;

WITH ins44 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 40, 0, $eh440$الباب الخامس: الأجور والعلاوات - العلاوات$eh440$, $et440$مادة (40)$et440$, $e440$تُضم العلاوات المقررة بمقتضى هذا القانون إلى الأجر الوظيفى للموظف.$e440$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins44;

WITH ins45 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 41, 0, $eh450$الباب الخامس: الأجور والعلاوات - الأجر المكمل$eh450$, $et450$مادة (41)$et450$, $e450$يصدر بنظام الأجر المكمل قرار من رئيس مجلس الوزراء بمراعاة طبيعة عمل كل وحدة ونوعية الوظائف بها وطبيعة اختصاصاتها ومعدلات أداء موظفيها بحسب الأحوال بناءً على عرض الوزير المختص وبعد موافقة وزير المالية ودراسة الجهاز.$e450$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins45;

WITH ins46 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 0, $eh460$الباب الخامس: الأجور والعلاوات - الأجر المكمل$eh460$, $et460$مادة (42)$et460$, $e460$يجوز للسلطة المختصة تقرير مكافآت تشجيعية للموظف الذى يقدم خدمات ممتازة أو أعمالاً أو بحوثًا أو اقتراحات تساعد على تحسين طرق العمل، أو رفع كفاءة الأداء، أو توفير فى النفقات، وذلك كله بشرط سماح البند المخصص لذلك فى الموازنة العامة.$e460$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins46;

WITH ins47 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 43, 0, $eh470$الباب الخامس: الأجور والعلاوات - الأجر المكمل$eh470$, $et470$مادة (43)$et470$, $e470$يجوز لرئيس الجمهورية فى الحالات التى يُقدرها الاحتفاظ لمن يُعين بوظيفة أخرى بكامل أو بعض الأجر الذى كان يتقاضاه قبل التعيين بها.$e470$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins47;

WITH ins48 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 44, 0, $eh480$الباب الخامس: الأجور والعلاوات - الأجر المكمل$eh480$, $et480$مادة (44)$et480$, $e480$تُشجع الدولة زيادة وعى الموظفين بالعلوم والتكنولوجيا، والعمل على نشر المعارف بينهم، وتطوير القدرات الابتكارية. وتكون الاختراعات والمصنفات التى يبتكرها الموظف أثناء تأدية وظيفته أو بسببها ملكًا للدولة إذا كان الاختراع نتيجة تجارب رسمية أو له صلة بالشئون العسكرية، أو إذا كان الاختراع أو المصنف يدخل فى نطاق أعمال الوظيفة.
وفى جميع الأحوال يكون للموظف الحق فى تعويض عادل، يُراعَى عند تقديره تشجيع البحث والاختراع.
ويجوز أن يُنشأ صندوق خاص فى الوحدة، تتكون موارده من حصيلة استغلال حق هذه الاختراعات والمصنفات، ويكون الصرف من حصيلة هذا الصندوق طبقًا للائحة المالية التى تضعها السلطة المختصة.$e480$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins48;

WITH ins49 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 45, 0, $eh490$الباب الخامس: الأجور والعلاوات - الأجر المكمل$eh490$, $et490$مادة (45)$et490$, $e490$تضع السلطة المختصة بالاشتراك مع اللجنة النقابية للوحدة نظامًا للرعاية الاجتماعية والثقافية والرياضية للموظفين بها، وذلك بمراعاة أحكام التشريعات ذات الصلة.$e490$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins49;

WITH ins50 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 46, 0, $eh500$الباب السادس: الإجازات$eh500$, $et500$مادة (46)$et500$, $e500$تُحدد السلطة المختصة أيام العمل فى الأسبوع ومواقيته وتوزيع ساعاته وفقًا لمقتضيات المصلحة العامة، على ألا يقل عدد ساعات العمل الأسبوعية عن خمس وثلاثين ساعة ولا يزيد على اثنتين وأربعين ساعة.
وتخفض عدد ساعات العمل اليومية بمقدار ساعة للموظف ذى الإعاقة، والموظفة التى ترضع طفلها وحتى بلوغه العامين، والحالات الأخرى التى تبينها اللائحة التنفيذية.
ولا يجوز للموظف أن ينقطع عن عمله إلا لإجازة يُرخص له بها فى حدود الإجازات المقررة فى هذا القانون، ووفقًا للضوابط والإجراءات التى تحددها اللائحة التنفيذية، وإلا حُرم من أجره عن مدة الانقطاع دون الإخلال بمسئوليته التأديبية.$e500$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins50;

WITH ins51 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 47, 0, $eh510$الباب السادس: الإجازات - إجازة بأجر كامل$eh510$, $et510$مادة (47)$et510$, $e510$يستحق الموظف إجازة بأجر كامل عن أيام عطلات الأعياد والمناسبات الرسمية التى تحدد بقرار من رئيس مجلس الوزراء، ويجوز تشغيل الموظف فى هذه العطلات إذا اقتضت الضرورة ذلك، مع منحه أجرًا مماثلاً مضافًا إلى أجره المستحق أو إجازة عوضًا عنها.
وتسرى بالنسبة للأعياد الدينية لغير المسلمين أحكام قرار رئيس مجلس الوزراء الصادر فى هذا الشأن.$e510$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins51;

WITH ins52 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 48, 0, $eh520$الباب السادس: الإجازات - إجازة بأجر كامل$eh520$, $et520$مادة (48)$et520$, $e520$للموظف أن ينقطع عن العمل لسبب عارض لمدة لا تتجاوز سبعة أيام خلال السنة وبحد أقصى يومان فى المرة الواحدة.$e520$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins52;

WITH ins53 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 49, 0, $eh530$الباب السادس: الإجازات - إجازة بأجر كامل$eh530$, $et530$مادة (49)$et530$, $e530$يستحق الموظف إجازة اعتيادية سنوية بأجر كامل، لا يدخل فى حسابها أيام عطلات الأعياد والمناسبات الرسمية فيما عدا العطلات الأسبوعية، وذلك على الوجه الآتى:
1 - 15 يومًا فى السنة الأولى، وذلك بعد مضى ستة أشهر من تاريخ استلام العمل.
2 - 21 يومًا لمن أمضى سنة كاملة فى الخدمة.
3 - 30 يومًا لمن أمضى عشر سنوات فى الخدمة.
4 - 45 يومًا لمن تجاوزت سنه الخمسين.
ويستحق الموظف من ذوى الإعاقة إجازة اعتيادية سنوية مدتها خمسة وأربعون يومًا دون التقيد بعدد سنوات الخدمة.
وللسلطة المختصة أن تقرر زيادة مدة الإجازة الاعتيادية بما لا يجاوز خمسة عشر يومًا لمن يعملون فى المناطق النائية، أو إذا كان العمل فى أحد فروع الوحدة خارج جمهورية مصر العربية.
ولا يجوز تقصير أو تأجيل الإجازة الاعتيادية أو إنهاؤها إلا لأسباب قومية تقتضيها مصلحة العمل.$e530$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins53;

WITH ins54 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 50, 0, $eh540$الباب السادس: الإجازات - إجازة بأجر كامل$eh540$, $et540$مادة (50)$et540$, $e540$يجب على الموظف أن يتقدم بطلب للحصول على كامل إجازاته الاعتيادية السنوية، ولا يجوز للوحدة ترحيلها إلا لأسباب تتعلق بمصلحة العمل وفى حدود الثلث على الأكثر ولمدة لا تزيد على ثلاث سنوات.
وإذا لم يتقدم الموظف بطلب للحصول على إجازاته على النحو المشار إليه، سقط حقه فيها وفى اقتضاء مقابل عنها، أما إذا تقدم بطلب للحصول عليها ورفضته السلطة المختصة استحق مقابلاً نقديًا عنها يُصرف بعد مرور ثلاث سنوات على انتهاء العام المستحق عنه الإجازة على أساس أجره الوظيفى فى هذا العام.
وتبين اللائحة التنفيذية إجراءات الحصول على الإجازة، وكيفية ترحيلها.$e540$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins54;

WITH ins55 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 51, 0, $eh550$الباب السادس: الإجازات - إجازة بأجر كامل$eh550$, $et550$مادة (51)$et550$, $e550$يستحق الموظف إجازة مرضية عن كل ثلاث سنوات تقضى فى الخدمة، وتُمنح بقرار من المجلس الطبى المختص فى الحدود الآتية:
1 - الثلاثة أشهر الأولى بأجر كامل.
2 - الثلاثة أشهر التالية بأجر يعادل (75٪) من الأجر الوظيفى.
3 - الستة أشهر التالية بأجر يعادل (50٪) من الأجر الوظيفى، (75٪) من أجره الوظيفى لمن يجاوز سن الخمسين.
ويحق للموظف طلب مد الإجازة المرضية بدون أجر للمدة التى يحددها المجلس الطبى المختص إذا قرر احتمال شفائه.
ويحق للموظف أن يطلب تحويل الإجازة المرضية إلى إجازة اعتيادية، إذا كان له رصيد منها، وعلى الموظف المريض أن يخطر جهة عمله عن مرضه خلال أربع وعشرين ساعة من انقطاعه عن العمل للمرض إلا إذا تعذر عليه ذلك لأسباب قهرية. وتضع السلطة المختصة الإجراءات المنظمة لحصول الموظف على الإجازة المرضية، ويعتبر التمارض إخلالاً بواجبات الوظيفة.
ويمنح الموظف المريض بأحد الأمراض المزمنة التى يصدر بتحديدها قرار من وزير الصحة بناءً على موافقة المجلس الطبى المختص إجازة استثنائية بأجر كامل إلى أن يُشفى أو تستقر حالته استقرارًا يمكنه من العودة إلى العمل أو يتبين عجزه عجزًا كاملاً، وفى هذه الحالة الأخيرة يظل الموظف فى إجازة مرضية بذات الأجر حتى بلوغه سن الإحالة للمعاش.
وإذا رغب الموظف المريض فى إنهاء إجازته والعودة إلى عمله، وجب عليه أن يقدم طلبًا كتابيًا بذلك، وأن يوافق المجلس الطبى المختص على عودته.$e550$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins55;

WITH ins56 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 52, 0, $eh560$الباب السادس: الإجازات - إجازة بأجر كامل$eh560$, $et560$مادة (52)$et560$, $e560$تكون حالات الترخيص بإجازة خاصة بأجر كامل على الوجه الآتى:
1 - يستحق الموظف إجازة لمدة ثلاثين يومًا، ولمرة واحدة طوال مدة عمله بالخدمة المدنية لأداء فريضة الحج.
2 - تستحق الموظفة إجازة وضع لمدة أربعة أشهر، بحد أقصى ثلاث مرات طوال مدة عملها بالخدمة المدنية، على أن تبدأ هذه الإجازة من اليوم التالى للوضع، ويجوز أن تبدأ هذه الإجازة قبل شهر من التاريخ المتوقع للوضع بناءً على طلب مقدم من الموظفة وتقرير من المجلس الطبى المختص.
3 - يستحق الموظف المخالط لمريض معد بمرض إجازة للمدة التى يحددها المجلس الطبى المختص.
4 - يستحق الموظف الذى يصاب إصابة عمل إجازة للمدة التى يحددها المجلس الطبى المختص، وذلك مع مراعاة أحكام قانون التأمين الاجتماعى المشار إليه.
5 - يستحق الموظف المقيد بإحدى الكليات أو المعاهد أو المدارس إجازة عن أيام الامتحان الفعلية.$e560$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins56;

WITH ins57 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 53, 0, $eh570$الباب السادس: الإجازات - الإجازة بدون أجر$eh570$, $et570$مادة (53)$et570$, $e570$تكون حالات الترخيص بالإجازة بدون أجر على الوجه الآتى:
1 - يُمنح الزوج أو الزوجة إذا سافر أحدهما إلى الخارج للعمل أو للدراسة إجازة بدون أجر مدة بقاء الزوج أو الزوجة فى الخارج، وفى جميع الأحوال يتعين على الوحدة أن تستجيب لطلب الزوج أو الزوجة.
2 - يجوز للسلطة المختصة منح الموظف إجازة بدون أجر للأسباب التى يبديها وتقدرها السلطة المختصة ووفقًا لحاجة العمل.
ولا يجوز فى البندين السابقين ترقية الموظف إلا بعد عودته من الإجازة واستكمال المدة البينية اللازمة لشغل الوظيفة الأعلى مباشرة، ولا تدخل مدد الإجازات المنصوص عليها فى هذين البندين ضمن المدد البينية اللازمة للترقية.
3 - مع مراعاة أحكام قانون الطفل الصادر بالقانون رقم (12) لسنة 1996، تستحق الموظفة إجازة بدون أجر لرعاية طفلها لمدة عامين على الأكثر فى المرة الواحدة، وبحد أقصى ستة أعوام طوال مدة عملها بالخدمة المدنية.
واستثناءً من أحكام قانون التأمين الاجتماعى المشار إليه، تتحمل الوحدة اشتراكات التأمين المستحقة عليها وعلى الموظفة.$e570$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins57;

WITH ins58 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 54, 0, $eh580$الباب السادس: الإجازات - الإجازة بدون أجر$eh580$, $et580$مادة (54)$et580$, $e580$يجوز للسلطة المختصة، وفقًا للقواعد التى تضعها، الترخيص للموظف بأن يعمل بعض الوقت بناءً على طلبه وذلك مقابل نسبة من الأجر.
ويستحق الموظف فى هذه الحالة الإجازات الاعتيادية والعارضة والمرضية المقررة له بما يتفق مع الجزء من الوقت الذى خصصه لعمله.
وتحدد اللائحة التنفيذية قواعد احتساب الأجر المشار إليه.
واستثناءً من أحكام قانون التأمين الاجتماعى المشار إليه، تؤدى الاشتراكات المستحقة وفقًا لأحكام هذا القانون من الأجر المخفض على أساس الأجر الكامل، وتدخل المدة بالكامل ضمن مدة اشتراكه.$e580$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins58;

WITH ins59 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 55, 0, $eh590$الباب السادس: الإجازات - الإجازة بدون أجر$eh590$, $et590$مادة (55)$et590$, $e590$لا يستحق المجند والمستبقى والمستدعى للاحتياط أية إجازة تم النص عليها فى هذا القانون طوال مدة وجوده بالقوات المسلحة.$e590$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins59;

WITH ins60 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 56, 0, $eh600$الباب السادس: الإجازات - الإجازة بدون أجر$eh600$, $et600$مادة (56)$et600$, $e600$يُحظر على الموظف أن يؤدى عملاً للغير بأجر أو بدون أجر خلال مدة الإجازة بغير ترخيص من السلطة المختصة، وإلا حُرم من أجره عن مدة الإجازة، وللوحدة أن تسترد ما أدته إليه من أجر عن هذه المدة، وذلك دون الإخلال بالمسئولية التأديبية.$e600$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins60;

WITH ins61 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 57, 0, $eh610$الباب السابع: السلوك الوظيفى والتأديب$eh610$, $et610$مادة (57)$et610$, $e610$يتعين على الموظف الالتزام بأحكام هذا القانون ولائحته التنفيذية وغيرهما من القوانين واللوائح والقرارات والتعليمات المنفذة لها، وما يصدر عن الجهاز من قرارات تنظيمية أو تعليمات أو نشرات أو كتب دورية فى هذا الشأن، ومدونات السلوك وأخلاقيات الخدمة المدنية الصادرة من الوزير المختص.
ويحظر على الموظف بصفة خاصة مباشرة الأعمال التى تتنافى مع الحيدة، والتجرد، والالتزام الوظيفى أثناء ساعات العمل الرسمية، أو ممارسة أى عمل حزبى، أو سياسى داخل مكان عمله، أو بمناسبة تأديته لهذا العمل، أو القيام بجمع تبرعات، أو مساهمات لصالح أحزاب سياسية، أو نشر الدعاية أو الترويج لها.$e610$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins61;

WITH ins62 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 58, 0, $eh620$الباب السابع: السلوك الوظيفى والتأديب$eh620$, $et620$مادة (58)$et620$, $e620$كل موظف يخرج على مقتضى الواجب فى أعمال وظيفته، أو يظهر بمظهر من شأنه الإخلال بكرامة الوظيفة يجازى تأديبيًا.
ولا يعفى الموظف من الجزاء استنادًا إلى أمر صادر إليه من رئيسه إلا إذا ثبت أن ارتكاب المخالفة كان تنفيذًا لأمر مكتوب صادر إليه من هذا الرئيس، بالرغم من تنبيهه إليه كتابةً إلى المخالفة، وفى هذه الحالة تكون المسئولية على مصدر الأمر وحده.
ولا يسأل الموظف مدنيًا إلا عن خطئه الشخصى.$e620$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins62;

WITH ins63 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 59, 0, $eh630$الباب السابع: السلوك الوظيفى والتأديب$eh630$, $et630$مادة (59)$et630$, $e630$لا يجوز توقيع أى جزاء على الموظف إلا بعد التحقيق معه كتابةً، وسماع أقواله وتحقيق دفاعه، ويكون القرار الصادر بتوقيع الجزاء مسببًا.
ومع ذلك، يجوز بالنسبة لجزائى الإنذار والخصم من الأجر لمدة لا تجاوز ثلاثة أيام أن يكون التحقيق شفاهة، على أن يثبت مضمونه فى القرار الصادر بتوقيع الجزاء.$e630$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins63;

WITH ins64 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 60, 0, $eh640$الباب السابع: السلوك الوظيفى والتأديب$eh640$, $et640$مادة (60)$et640$, $e640$تختص النيابة الإدارية دون غيرها بالتحقيق مع شاغلى الوظائف القيادية، وكذا تختص دون غيرها بالتحقيق فى المخالفات المالية التى يترتب عليها ضياع حق من الحقوق المالية للدولة أو المساس بها.
كما تتولى التحقيق فى المخالفات الأخرى التى تحال إليها ويكون لها بالنسبة لهذه المخالفات السلطات المقررة للسلطة المختصة فى توقيع الجزاءات أو الحفظ.
وعلى الجهة الإدارية المختصة بالنسبة لسائر المخالفات أن توقف ما تجريه من تحقيق فى واقعة ما أو ما يرتبط بها إذا كانت النيابة الإدارية قد بدأت التحقيق فيها، ويقع باطلاً كل إجراء أو تصرف يخالف ذلك.$e640$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins64;

WITH ins65 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 61, 0, $eh650$الباب السابع: السلوك الوظيفى والتأديب$eh650$, $et650$مادة (61)$et650$, $e650$الجزاءات التى يجوز توقيعها على الموظف هى:
1 - الإنذار.
2 - الخصم من الأجر لمدة أو مدد لا تجاوز ستين يومًا فى السنة.
3 - الوقف عن العمل لمدة لا تجاوز ستة أشهر مع صرف نصف الأجر الكامل.
4 - تأجيل الترقية عند استحقاقها لمدة لا تزيد على سنتين.
5 - الخفض إلى وظيفة فى المستوى الأدنى مباشرة.
6 - الخفض إلى وظيفة فى المستوى الأدنى مباشرة مع خفض الأجر إلى القدر الذى كان عليه قبل الترقية.
7 - الإحالة إلى المعاش.
8 - الفصل من الخدمة.
أما الجزاءات التى يجوز توقيعها على شاغلى الوظائف القيادية هى:
1 - التنبيه.
2 - اللوم.
3 - الإحالة إلى المعاش.
4 - الفصل من الخدمة.
وللسلطة المختصة بعد توقيع جزاء تأديبى على أحد شاغلى الوظائف القيادية والإدارة الإشرافية تقدير مدى استمراره فى شغل تلك الوظيفة.
وتحتفظ كل وحدة فى حساب خاص بحصيلة جزاءات الخصم الموقعة على العاملين، ويكون الصرف من هذه الحصيلة فى الأغراض الاجتماعية، أو الثقافية، أو الرياضية للعاملين طبقًا للشروط والأوضاع التى تُحددها السلطة المختصة.$e650$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins65;

WITH ins66 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 62, 0, $eh660$الباب السابع: السلوك الوظيفى والتأديب$eh660$, $et660$مادة (62)$et660$, $e660$يكون الاختصاص بالتصرف فى التحقيق على النحو الآتى:
1 - للرؤساء المباشرين الذين تحددهم السلطة المختصة كل فى حدود اختصاصه، حفظ التحقيق أو توقيع جزاء الإنذار أو الخصم من الأجر، بما لا يجاوز عشرين يومًا فى السنة ولا يزيد على ثلاثة أيام فى المرة الواحدة.
2 - لشاغلى الوظائف القيادية والإدارة الإشرافية كل فى حدود اختصاصه، حفظ التحقيق أو توقيع جزاء الإنذار أو الخصم من الأجر، بما لا يجاوز أربعين يومًا فى السنة ولا يزيد على خمسة عشر يومًا فى المرة الواحدة.
3 - للسلطة المختصة حفظ التحقيق أو توقيع أى من الجزاءات المنصوص عليها فى البنود من (1) إلى (5) من الفقرة الأولى من المادة (61) من هذا القانون والبندين (2، 1) من الفقرة الثانية من ذات المادة.
4 - للمحكمة التأديبية المختصة توقيع أى من الجزاءات المنصوص عليها فى هذا القانون.
وتكون الجهة المنتدب أو المعار إليها الموظف هى المختصة بالتحقيق معه وتأديبه طبقًا لأحكام هذا القانون عن المخالفات التى يرتكبها خلال فترة الندب أو الإعارة.$e660$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins66;

WITH ins67 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 63, 0, $eh670$الباب السابع: السلوك الوظيفى والتأديب$eh670$, $et670$مادة (63)$et670$, $e670$لكل من السلطة المختصة ورئيس هيئة النيابة الإدارية بحسب الأحوال أن يوقف الموظف عن عمله احتياطيًا إذا اقتضت مصلحة التحقيق معه ذلك لمدة لا تزيد على ثلاثة أشهر، ولا يجوز مد هذه المدة إلا بقرار من المحكمة التأديبية المختصة للمدة التى تحددها، ويترتب على وقف العامل عن عمله وقف صرف نصف أجره ابتداءً من تاريخ الوقف.
ويجب عرض الأمر فورًا على المحكمة التأديبية المختصة لتقرير صرف أو عدم صرف المتبقى من أجره، فإذا لم يُعرض الأمر عليها خلال عشرة أيام من تاريخ الوقف وجب صرف كامل أجره حتى تقرر المحكمة ما يُتبع فى شأنه.
وعلى المحكمة التأديبية أن تُصدر قرارها خلال عشرين يومًا من تاريخ رفع الأمر إليها، فإذا لم تصدر المحكمة قرارها خلال هذه المدة يصرف الأجر كاملاً. فإذا برئ الموظف أو حفظ التحقيق معه أو جُوزيَ بجزاء الإنذار أو الخصم من الأجر لمدة لا تجاوز خمسة أيام صرف إليه ما يكون قد أوقف صرفه من أجره، وإذا جُوزيَ بجزاء أشد تقرر السلطة التى وقعت الجزاء ما يُتبع فى شأن الأجر الموقوف صرفه، فإن جُوزيَ بجزاء الفصل انتهت خدمته من تاريخ وقفه ولا يجوز أن يُسترد منه فى هذه الحالة ما سبق أن صرف له من أجر.$e670$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins67;

WITH ins68 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 64, 0, $eh680$الباب السابع: السلوك الوظيفى والتأديب$eh680$, $et680$مادة (64)$et680$, $e680$كل موظف يُحبس احتياطيًا أو تنفيذًا لحكم جنائى يُوقف عن عمله بقوة القانون مدة حبسه، ويحرم من نصف أجره إذا كان الحبس احتياطيًا أو تنفيذًا لحكم جنائى غير نهائى، ويُحرم من كامل أجره إذا كان الحبس تنفيذًا لحكم جنائى نهائى.
وإذا لم يكن من شأن الحكم الجنائى إنهاء خدمة الموظف يُعرض أمره عند عودته إلى عمله على السلطة المختصة لتقرير ما يُتبع فى شأن مسئوليته التأديبية.$e680$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins68;

WITH ins69 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 0, $eh690$الباب السابع: السلوك الوظيفى والتأديب$eh690$, $et690$مادة (65)$et690$, $e690$لا تجوز ترقية الموظف المحال إلى المحاكمة التأديبية أو الجنائية أو الموقوف عن العمل مدة الإحالة أو الوقف، وفى هذه الحالة تحجز وظيفة للموظف.
وإذا بُرئ الموظف المحال أو قُضِى بحكم نهائى بمعاقبته بالإنذار أو الخصم من الأجر لمدة لا تزيد على عشرة أيام وجب ترقيته اعتبارًا من التاريخ الذى كانت ستتم فيه الترقية لو لم يُحل إلى المحاكمة، ويُمنح أجر الوظيفة المرقى إليها من هذا التاريخ.
وفى جميع الأحوال، لا يجوز تأخير ترقية الموظف لمدة تزيد على سنتين.$e690$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins69;

WITH ins70 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 66, 0, $eh700$الباب السابع: السلوك الوظيفى والتأديب$eh700$, $et700$مادة (66)$et700$, $e700$لا يمنع انتهاء خدمة الموظف لأى سبب من الأسباب عدا الوفاة من محاكمته تأديبيًا إذا كان قد بُدئ فى التحقيق قبل انتهاء مدة خدمته.
ويجوز فى المخالفات التى يترتب عليها ضياع حق من حقوق الخزانة العامة للدولة إقامة الدعوى التأديبية ولو لم يكن قد بُدئ فى التحقيق قبل انتهاء الخدمة وذلك لمدة خمس سنوات من تاريخ انتهائها.
ويجوز أن يوقع على من انتهت خدمته غرامة لا تجاوز عشرة أضعاف أجره الوظيفى الذى كان يتقاضاه فى الشهر عند انتهاء الخدمة، وذلك مع عدم الإخلال بالعقوبات الجنائية والتزامه برد قيمة الحق، واستثناءً من أحكام قانون التأمين الاجتماعى المشار إليه، تستوفى الغرامة المشار إليها بالفقرة السابقة من المعاش بما لا يجاوز ربعه، أو بطريق الحجز الإدارى.$e700$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins70;

WITH ins71 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 67, 0, $eh710$الباب السابع: السلوك الوظيفى والتأديب$eh710$, $et710$مادة (67)$et710$, $e710$تُمحى الجزاءات التأديبية التى توقع على الموظف بانقضاء الفترات الآتية:
1 - سنة فى حالة الإنذار والتنبيه والخصم من الأجر مدة لا تزيد على خمسة أيام.
2 - سنتان فى حالة اللوم والخصم من الأجر مدة تزيد على خمسة أيام وحتى خمسة عشر يومًا.
3 - ثلاث سنوات فى حالة الخصم من الأجر مدة تزيد على خمسة عشر يومًا وحتى ثلاثين يومًا.
4 - أربع سنوات بالنسبة إلى الجزاءات الأخرى عدا جزاءى الفصل والإحالة إلى المعاش.
وتُحسب فترات المحو اعتبارًا من تاريخ توقيع الجزاء.
ويترتب على محو الجزاء اعتباره كأن لم يكن بالنسبة للمستقبل ولا يؤثر على الحقوق والتعويضات التى ترتبت نتيجة له.
وتحدد اللائحة التنفيذية إجراءات المحو.$e710$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins71;

WITH ins72 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 68, 0, $eh720$الباب السابع: السلوك الوظيفى والتأديب$eh720$, $et720$مادة (68)$et720$, $e720$تسقط الدعوى التأديبية بالنسبة للموظف الموجود بالخدمة بمضى ثلاث سنوات من تاريخ ارتكاب المخالفة.
وتنقطع هذه المدة بأى إجراء من إجراءات التحقيق أو الاتهام أو المحاكمة، وتسرى المدة من جديد ابتداءً من آخر إجراء.
وإذا تعدد المتهمون فإن انقطاع المدة بالنسبة لأحدهم يترتب عليه انقطاعها بالنسبة للباقين ولو لم تكن قد اتخذت ضدهم إجراءات قاطعة للمدة.
ومع ذلك إذا شكل الفعل جريمة جنائية، فلا تسقط الدعوى التأديبية إلا بسقوط الدعوى الجنائية.$e720$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins72;

WITH ins73 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 0, $eh730$الباب الثامن: انتهاء الخدمة$eh730$, $et730$مادة (69)$et730$, $e730$تنتهى خدمة الموظف لأحد الأسباب الآتية:
1 - بلوغ سن الستين مع مراعاة أحكام قانون التأمين الاجتماعى المشار إليه، ويجوز بقرار من رئيس الجمهورية لاعتبارات يقدرها مد الخدمة لشاغلى الوظائف القيادية لمدة لا تجاوز ثلاث سنوات.
2 - الاستقالة.
3 - الإحالة إلى المعاش أو الفصل من الخدمة.
4 - فقد الجنسية، أو انتفاء شرط المعاملة بالمثل بالنسبة لرعايا الدول الأخرى.
5 - الانقطاع عن العمل بدون إذن خمسة عشر يومًا متتالية ما لم يقدم خلال الخمسة عشر يومًا التالية ما يثبت أن الانقطاع كان بعذر مقبول.
6 - الانقطاع عن العمل بدون إذن ثلاثين يومًا غير متصلة فى السنة.
7 - عدم اللياقة للخدمة صحيًا وذلك بقرار من المجلس الطبى المختص.
8 - الالتحاق بخدمة جهة أجنبية بغير ترخيص من حكومة جمهورية مصر العربية.
9 - الحكم عليه بعقوبة جناية أو بعقوبة مقيدة للحرية فى جريمة مخلة بالشرف أو الأمانة أو تفقده الثقة والاعتبار.
10 - الوفاة، وفى هذه الحالة يُصرف ما يعادل الأجر الكامل لمدة شهرين لمواجهة نفقات الجنازة وذلك للأرمل أو لأرشد الأولاد أو لمن يثبت قيامه بتحمل هذه النفقات.
وتُبين اللائحة التنفيذية قواعد وإجراءات إنهاء الخدمة لهذه الأسباب.$e730$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins73;

WITH ins74 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 70, 0, $eh740$الباب الثامن: انتهاء الخدمة$eh740$, $et740$مادة (70)$et740$, $e740$للموظف الذى جاوز سن الخمسين أن يطلب إحالته للمعاش المبكر ما لم يكن قد اتُخذت ضده إجراءات تأديبية، ويتعين على الوحدة الاستجابة لهذا الطلب وفقًا لما تحدده اللائحة التنفيذية، وفى هذه الحالة تُسوى حقوقه التأمينية على النحو الآتى:
1 - إذا لم يكن قد جاوز سن الخامسة والخمسين وجاوزت مدة اشتراكه فى نظام التأمين الاجتماعى عشرين عامًا ومضى على شغله الوظيفة أكثر من سنة، فيعتبر مرقى إلى الوظيفة التالية لوظيفته من اليوم السابق على تاريخ إحالته للمعاش، وتُسوى حقوقه التأمينية بعد ترقيته على أساس مدة اشتراكه فى نظام التأمين الاجتماعى مضافًا إليها خمس سنوات.
2 - إذا كان قد جاوز سن الخامسة والخمسين وجاوزت مدة اشتراكه فى التأمينات الاجتماعية عشرين عامًا، فتُسوى حقوقه التأمينية على أساس مدة اشتراكه فى التأمينات الاجتماعية مضافًا إليها المدة الباقية لبلوغه السن المقررة لانتهاء الخدمة أو خمس سنوات أيهما أقل.
ولا يجوز تعيين من يُحال للمعاش المبكر وفقًا لأحكام هذه المادة فى أى من الوحدات الخاضعة لأحكام هذا القانون.$e740$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins74;

WITH ins75 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 71, 0, $eh750$الباب التاسع: أحكام عامة وانتقالية$eh750$, $et750$مادة (71)$et750$, $e750$يستحق الموظف عند انتهاء خدمته مقابلاً عن رصيد إجازاته الاعتيادية الذى تَكَوَّن قبل العمل بأحكام هذا القانون ولم يستنفدها قبل انتهاء خدمته.
ويُحسب المقابل النقدى على أساس الأجر الأساسى مضافًا إليه العلاوات الخاصة التى كان يتقاضاها حتى تاريخ العمل بهذا القانون.$e750$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins75;

WITH ins76 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 72, 0, $eh760$الباب التاسع: أحكام عامة وانتقالية$eh760$, $et760$مادة (72)$et760$, $e760$يحتفظ شاغلو وظيفة كبير بوظائفهم بصفة شخصية إلى حين انتهاء مدة شغلهم لها، أو بلوغ سن التقاعد أيهما أقرب.$e760$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins76;

WITH ins77 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 73, 0, $eh770$الباب التاسع: أحكام عامة وانتقالية$eh770$, $et770$مادة (73)$et770$, $e770$يُعين فى أدنى الدرجات على بند الأجور الثابتة بالباب الأول (أجور) كل من مضى على نقله على بند (أجور موسميين) على الباب الأول ثلاث سنوات على الأقل على وظائف واردة بموازنة الوحدة، بشرط استيفاء شروط شغل تلك الوظائف، وتعاقده قبل 2016/6/30.
ويُطبق حكم الفقرة الأولى على جميع العاملين المؤقتين والمتعاقدين بالجهات الخاضعة لأحكام قانون الخدمة المدنية المسند إليهم شغل الوظيفة العامة حتى 2016/6/30 وذلك كله على النحو الذى تبينه اللائحة التنفيذية.
ويوضع نظام للتعاقد مع العمالة المؤقتة أو الموسمية على الباب الأول أن يصدر به قرار من الوزير المختص بناءً على اقتراح الجهاز.$e770$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins77;

WITH ins78 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 0, $eh780$الباب التاسع: أحكام عامة وانتقالية$eh780$, $et780$مادة (74)$et780$, $e780$يستمر العمل بالأحكام والقواعد الخاصة بتحديد المخصصات المالية للموظفين بالوظائف والجهات الصادر بتنظيم مخصصاتهم قوانين ولوائح خاصة طبقًا لجدول الأجور المقرر بها.
ويستمر صرف باقى الحوافز والمكافآت والجهود غير العادية والأعمال الإضافية والبدلات وكافة المزايا النقدية والعينية وغيرها بخلاف المزايا التأمينية التى يحصل عليها الموظف بذات القواعد والشروط المقررة قبل العمل بأحكام هذا القانون بعد تحويلها من نسب مئوية مرتبطة بالأجر الأساسى إلى فئات مالية مقطوعة فى 2015/6/30.$e780$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins78;

WITH ins79 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 75, 0, $eh790$الباب التاسع: أحكام عامة وانتقالية$eh790$, $et790$مادة (75)$et790$, $e790$تلتزم الوحدات المخاطبة بأحكام هذا القانون بتحديث الهياكل التنظيمية، وبطاقات الوصف، ودورات العمل، وحصر الخدمات التى تقدمها وإجراءاتها وشروطها، وذلك فى مدة لا تجاوز عامًا من تاريخ العمل بهذا القانون. كما تلتزم تلك الجهات بوضع مؤشرات ومعايير الأداء، وطرق تقديم الخدمات العامة سواء بصورة مباشرة أو عن طريق إحدى الجهات غير الحكومية، وسبل تحقيق رضاء المواطنين. ويلتزم الجهاز بمتابعة تنفيذ هذه المهام فى ضوء المعايير والآليات المنظمة التى يصدرها الوزير المختص، بعد العرض على مجلس الخدمة المدنية.$e790$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins79;

WITH ins80 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 76, 0, $eh800$الباب التاسع: أحكام عامة وانتقالية$eh800$, $et800$مادة (76)$et800$, $e800$يجوز للسلطة المختصة، ولمدة ثلاث سنوات اعتبارًا من تاريخ العمل بهذا القانون، إعادة تعيين الموظفين المعينين قبل العمل بأحكامه، والحاصلين على مؤهلات أعلى أثناء الخدمة فى الوظائف الخالية بالوحدات التى يعملون بها، متى توافرت فيهم الشروط اللازمة لشغل هذه الوظائف وفقًا لجداول الترتيب والتوصيف المعمول بها مع استثنائهم من شرطى الإعلان والامتحان اللازمين لشغل هذه الوظائف، وذلك كله وفقًا للقواعد والشروط التى تبينها اللائحة التنفيذية، على أن يتم التعيين فى بداية مجموعة الوظائف المعين عليها.$e800$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins80;

WITH ins81 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 77, 0, $eh810$الباب التاسع: أحكام عامة وانتقالية$eh810$, $et810$مادة (77)$et810$, $e810$يصدر بنظام الشكاوى المتعلقة بالمخاطبين بأحكام هذا القانون، وقواعد وواجبات تعامل موظفى الوحدة مع الجمهور، قرار من رئيس الجهاز.
ويكون للجهاز استئداء رسم مقداره عشرة جنيهات من المتقدم لأداء الامتحانات المشار إليها فى المادة (12) من هذا القانون أو التظلم من نتائجها، على أن يزاد هذا الرسم بمقدار جنيهين كل عام ميلادى.
ويُودع المبلغ المشار إليه مع المبالغ الأخرى التى يحصلها الجهاز نظير الخدمات التى يقدمها للغير فى الداخل أو الخارج فى حساب خاص باسم الجهاز لدى البنك المركزى بحساب الخزانة الموحد، ويصرف من الحساب المشار إليه فى تطوير الجهاز، وذلك بموجب قرار يصدر من رئيس الجهاز، على أن يرحل الفائض من هذا الحساب من عام لآخر.$e810$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins81;

WITH ins82 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, -2, $eh820$الجداول الملحقة بالقانون (المرتبطة بالمواد 29، 36، 73)$eh820$, $et820$الجدول رقم (1) الملحق - الوظائف التخصصية$et820$, $e820$جدول رقم (1): الوظائف التخصصية
المستوى الوظيفى | الدرجة المالية المعادلة | المدد البينية اللازمة للترقية إلى المستوى | نسبة الترقية بالاختيار إلى المستوى | الأجر الوظيفى الشهرى (جنيه)
الممتازة | الممتازة | تحددها شروط شغل الوظيفة | مسابقة | 2065
العالية | العالية | تحددها شروط شغل الوظيفة | مسابقة | 1415
مدير عام | مدير عام | تحددها شروط شغل الوظيفة | مسابقة | 1335
الأولى (أ) | الأولى، أقدمية أكثر من سنة | سنة | 100٪ | 1195
الأولى (ب) | الأولى، أقدمية حتى سنة | ثلاث سنوات | 75٪ | 1175
الثانية (أ) | الثانية، أقدمية أكثر من 3 سنوات | ثلاث سنوات | 50٪ | 1035
الثانية (ب) | الثانية، أقدمية حتى 3 سنوات | ثلاث سنوات | 40٪ | 1020
الثالثة (أ) | الثالثة، أقدمية أكثر من 6 سنوات | ثلاث سنوات | 30٪ | 910
الثالثة (ب) | الثالثة، أقدمية أكثر من 3 سنوات وحتى 6 سنوات | ثلاث سنوات | 25٪ | 895
الثالثة (ج) | الثالثة، أقدمية حتى 3 سنوات | — | — | 880$e820$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins82;

WITH ins83 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, -2, $eh830$الجداول الملحقة بالقانون (المرتبطة بالمواد 29، 36، 73)$eh830$, $et830$الجدول رقم (2) الملحق - الوظائف الكتابية والفنية$et830$, $e830$جدول رقم (2): الوظائف الكتابية والفنية
المستوى الوظيفى | الدرجة المالية المعادلة | المدد البينية اللازمة للترقية إلى المستوى | الأجر الوظيفى الشهرى (جنيه)
الأولى (أ) كاتب/فنى | الأولى، أقدمية سنة فأكثر | 3 سنوات | 1195
الأولى (ب) كاتب/فنى | الأولى، أقدمية حتى سنة | 3 سنوات | 1175
الثانية (أ) كاتب/فنى | الثانية، أقدمية أكثر من 3 سنوات | 3 سنوات | 1035
الثانية (ب) كاتب/فنى | الثانية، أقدمية حتى 3 سنوات | 3 سنوات | 1020
الثالثة (أ) كاتب/فنى | الثالثة، أقدمية أكثر من 6 سنوات | 3 سنوات | 910
الثالثة (ب) كاتب/فنى | الثالثة، أقدمية أكثر من 3 سنوات وحتى 6 سنوات | 3 سنوات | 895
الثالثة (ج) كاتب/فنى | الثالثة، أقدمية حتى 3 سنوات | 3 سنوات | 880
الرابعة (أ) كاتب/فنى | الرابعة، أقدمية أكثر من سنتين | 3 سنوات | 850
الرابعة (ب) كاتب/فنى | الرابعة، أقدمية حتى سنتين | — | 845$e830$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins83;

WITH ins84 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, -2, $eh840$الجداول الملحقة بالقانون (المرتبطة بالمواد 29، 36، 73)$eh840$, $et840$الجدول رقم (3) الملحق - الوظائف الحرفية والخدمة المعاونة$et840$, $e840$جدول رقم (3): الوظائف الحرفية والخدمة المعاونة
المستوى الوظيفى | الدرجة المالية | المدد البينية اللازمة للترقية إلى المستوى | الأجر الوظيفى الشهرى (جنيه)
الثانى (أ) حرفى | الثانية، أقدمية أكثر من 3 سنوات | 3 سنوات | 1035
الثانى (ب) حرفى | الثانية، أقدمية حتى 3 سنوات | 3 سنوات | 1020
الثالث (أ) معاون خدمة/حرفى | الثالثة، أقدمية أكثر من 6 سنوات | 3 سنوات | 910
الثالث (ب) معاون خدمة/حرفى | الثالثة، أقدمية أكثر من 3 سنوات وحتى 6 سنوات | 3 سنوات | 895
الثالث (ج) معاون خدمة/حرفى | الثالثة، أقدمية حتى 3 سنوات | 3 سنوات | 880
الرابع (أ) معاون خدمة/حرفى | الرابعة، أقدمية أكثر من سنتين | 3 سنوات | 850
الرابع (ب) معاون خدمة/حرفى | الرابعة، أقدمية حتى سنتين | 3 سنوات | 845
الخامس (أ) معاون خدمة/حرفى | الخامسة، أقدمية أكثر من سنتين | 3 سنوات | 843
الخامس (ب) معاون خدمة/حرفى | الخامسة، أقدمية حتى سنتين | 3 سنوات | 840
السادس (أ) معاون خدمة/حرفى | السادسة، أقدمية أكثر من سنتين | 3 سنوات | 837
السادس (ب) معاون خدمة/حرفى | السادسة، أقدمية حتى سنتين | — | 835$e840$
  FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2016-11-02', 'active' FROM ins84;

-- ===== تحقق نهائى =====
DO $verify070$
DECLARE
  v_law_id uuid;
  v_total INT;
  v_versions INT;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 81 AND law_year = 2016 AND kind = 'law';
  IF v_law_id IS NULL THEN RAISE EXCEPTION 'law 81/2016 not found after seed'; END IF;
  SELECT count(*) INTO v_total FROM articles WHERE law_id = v_law_id;
  IF v_total <> 85 THEN RAISE EXCEPTION 'expected 85 articles, got %', v_total; END IF;
  SELECT count(*) INTO v_versions FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id;
  IF v_versions <> 85 THEN RAISE EXCEPTION 'expected 85 article_versions, got %', v_versions; END IF;
  RAISE NOTICE '070_seed_law_81_2016_civil_service: تم بنجاح. % مادة، % نسخة.', v_total, v_versions;
END $verify070$;

COMMIT;