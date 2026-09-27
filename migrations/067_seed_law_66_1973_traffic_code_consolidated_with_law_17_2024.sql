-- 067_seed_law_66_1973_traffic_code_consolidated_with_law_17_2024.sql
--
-- بذر قانون المرور رقم 66 لسنة 1973 (النص الحالى الموحَّد الكامل، شاملاً
-- تعديل القانون رقم 17 لسنة 2024، وهو آخر تعديل نافذ حتى تاريخ هذه الهجرة).
-- الجزء (ب) من استكمال رفع القوانين الناقصة فى المحور الأول من الخطة.
--
-- ===== المصادر (لا اختلاق — كل مصدر PDF رسمى) =====
-- 1) الأساس: نسخة موحَّدة من alberonsy.com، وفقاً لآخر تعديل صادر فى 27
--    ديسمبر 2021 (القانون رقم 161 لسنة 2021)، 40 صفحة، تتضمن تاريخ كل
--    تعديل تاريخى فى ذيل الوثيقة (استدراكات 1-62) — تحقُّق مرجعى مباشر.
-- 2) التعديل الأخير: نسخة PDF رسمية من منشور الجريدة الرسمية، العدد 13
--    تابع (أ)، الصادر فى 28 مارس 2024 — القانون رقم 17 لسنة 2024 (يعمل
--    به من 2024-03-29، اليوم التالى للنشر)، 7 صفحات كاملة، بتوقيع
--    الرئيس عبد الفتاح السيسى. مُحمَّل من رابط تحميل مباشر (منشورات
--    قانونية) بعد أن ثبت أن رابط lawhub.info المعروض على شكل صفحة ويب
--    لا يوفر تحميلاً مباشراً، ورفض المستخدم نسخة alberonsy.com وحدها
--    لأنها متوقفة عند تعديل 2021 (أقدم من التعديل الفعلى الأخير).
--
-- ===== منهجية الدمج =====
-- طُبِّقت المادة الأولى من القانون 17/2024 (استبدال نصوص: 3/فقرة ثانية،
-- 13/فقرة ثانية، 28/فقرتين أولى وثانية، 34/بند 8، 65/فقرة أولى، 74/بند
-- 2، 74 مكررا 2) حرفياً من نص الجريدة الرسمية نفسه، ثم المادة الثالثة
-- (إضافة مواد 3 مكررا، 7 مكررا، 65 مكررا 1-4) حرفياً كذلك. بقية مواد
-- الأساس (بما فيها كل مواد 'مكررا' التاريخية الموثَّقة فى ذيل نسخة 2021
-- ذاتها) أُبقيت كما هى دون أى تغيير باستثناء ما ينص عليه صراحة.
--
-- ===== قرار تفسيرى صريح يحتاج مراجعة قانونية (وفقاً لقاعدة الشفافية) =====
-- المادة الثانية من القانون 17/2024 تنص حرفياً: "يستبدل لفظا (آلية)
-- و(الآلية) بلفظى (نارية) و(النارية) أينما وردا فى قانون المرور المشار
-- إليه." طُبِّق هذا الاستبدال هنا برمجياً وحرفياً على كل نص وردت فيه هاتان
-- الكلمتان بالضبط فى كامل القانون (مثال: 'مركبة آلية' أصبحت 'مركبة
-- نارية' فى مواد العقوبات 74مكررا/75/75مكررا)، اتساقاً مع صياغة النص
-- ذاتها لا تخصيصاً على 'الدراجة' فقط. هذا تفسير حرفى صريح للنص كما
-- وردت كلماته بالضبط، وليس اجتهاداً فى المعنى — لكنه يستحق تأكيداً من
-- مراجعة قانونية بشرية نظراً لأثره الواسع على عدة مواد عقابية.
--
-- ⚠️ ينطبق على هذا القانون نفس الفجوة المعمارية الموثَّقة سابقاً فى
-- migrations/066 (استعلامات الاسترجاع لا تُقيَّد بـ effective_from <=
-- CURRENT_DATE) — لا أثر عملى هنا لأن كل effective_from أدناه بتاريخ
-- ماضٍ بالفعل (سريان قديم منذ 1973، وتعديل 2024 سارٍ بالفعل).
--
-- قابلة لإعادة التشغيل بأمان (idempotent).

BEGIN;

-- ===== laws =====
INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
VALUES (
  66, 1973,
  $lawt0$القانون رقم 66 لسنة 1973 بإصدار قانون المرور (بتعديلاته حتى القانون رقم 17 لسنة 2024)$lawt0$,
  $laws0$قانون المرور 66/1973$laws0$,
  'traffic', 'law', 'in_force', NULL, '1973-08-23'
)
ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $eh00$الباب الأول: تنظيم المرور فى الطرق العامة - الفصل الأول: استعمال الطريق فى المرور$eh00$, $et00$مادة 1$et00$, $e00$يكون استعمال الطرق أيا كانت طبيعتها فى المرور على الوجه الذى لا يعرض الأرواح أو الأموال للخطر أو يؤدى إلى الإخلال بأمن الطريق أو يعطل أو يعوق استعمال الغير له، أو يقلق الراحة أو يضر بالبيئة.

ويقصد بالطرق فى تطبيق أحكام هذا القانون الطريق، والطرق التي يصدر بتحديدها قرار من وزير الداخلية إذا كانت داخلة فى تقسيمات تجمعات سكنية أو صناعية أو سياحية أو أى تجمعات أخرى.(35)(25)$e00$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $eh10$الفصل الأول: استعمال الطريق فى المرور$eh10$, $et10$مادة 2$et10$, $e10$ويقصد بقسم المرور المختص قسم المرور التابع لإدارة المرور فى المحافظة التى يوجد بها محل إقامة طالب الترخيص.(40)

ويقصد بقسم مرور المحافظة التى يوجد بها محل إقامة طالب الترخيص.$e10$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $eh20$الفصل الثانى: المركبات وأنواعها$eh20$, $et20$مادة 3 - فقرة أولى$et20$, $e20$فى تطبيق أحكام هذا القانون يقصد بالمركبة كل ما أعد للسير على الطرق العامة من آلات النقل ومن أدوات النقل والجر.

والمركبات نوعان:

مركبات النقل السريع وهى السيارات والجرارات والمقطورات ونصف المقطورات، والدراجات النارية، والمركبات الخفيفة والمعدات الثقيلة (اللوادر، الحفارات، الأوناش، الجرافات، البلدوزرات) وغير ذلك من الآلات المعدة للسير على الطرق.(41)$e20$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 1, $eh30$الفصل الثانى: المركبات وأنواعها$eh30$, $et30$مادة 3 - فقرة ثانية (مستبدلة بالقانون 17/2024)$et30$, $e30$والمركبات نوعان:

مركبات النقل السريع: وهى السيارات والجرارات والمقطورات ونصف المقطورات، والدراجات النارية، والمركبات الخفيفة والمعدات الثقيلة (اللوادر، الحفارات، الأوناش، الجرافات، البلدوزرات) وغير ذلك من الآلات المعدة للسير على الطرق.

ومركبات النقل البطيء: وهى الدراجات غير النارية والعربات التى تسير بقوة الإنسان أو الحيوان.(النص المستبدل بالقانون رقم 17 لسنة 2024)$e30$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 2, $eh40$الفصل الثانى: المركبات وأنواعها$eh40$, $et40$مادة 3 مكررا (مضافة بالقانون 17/2024)$et40$, $e40$فى تطبيق أحكام هذا القانون، يقصد بالكلمات والعبارات التالية المعانى المبينة قرين كل منها:

المركبات المهملة: المركبات التي يمر على انتهاء ترخيصها ثلاثون يوما وتحمل لوحات معدنية غير مؤمنة، أو غير منصرفة من قسم المرور المختص أولا تحمل لوحات معدنية.

أنقاض المركبات: هياكل المركبات، والمركبات التي تفتقد لأحد الأجزاء الجوهرية الآتية: القاعدة، المحرك، جسم المركبة.

المركبات المتروكة: المركبات التي لم يستدل على بيانات لها بقاعدة بيانات المرور، والمركبات المهملة وأنقاض المركبات التي تم إخطار مالكها أو المسئول عن إدارتها بأماكن إيداعها ولم يتقدموا لإنهاء إجراءات استلامها وأداء جميع الضرائب والرسوم والغرامات ونفقات الرفع والإيداع والإيواء المقررة عليها خلال ستين يوما من تاريخ الإخطار.(مُضافة بالقانون رقم 17 لسنة 2024)$e40$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $eh50$الفرع الأول: مركبات النقل السريع$eh50$, $et50$مادة 4$et50$, $e50$السيارة مركبة ذات محرك آلى تسير بواسطته، ومن أنواعها ما يلى:

(1) سيارة خاصة: وهى المعدة للاستعمال الشخصى.

(2) سيارة أجرة: وهى المعدة لنقل الركاب بأجر شامل عن الرحلة.

ويجوز طبقًا للقواعد التي يصدر بها قرار من المحافظ المختص المسموح له بقيادة سيارة سير معينة سماحًا لنقل الركاب بأجر عن الراكب، ويحظر تسيير السيارة التي تخضع لهذا النظام خارج المحافظة المرخصة بها إلا بتصريح من إدارة المرور المختصة.

ولا يجوز الترخيص بالسيارات الأجرة وسيارات نقل الركاب الأجرة التي يكون قد مضى على صنعها خمس سنوات بما فيها سنة الصنع، وذلك عند الترخيص بها لأول مرة، وكذلك لا يجوز الاستمرار في الترخيص للسيارات الأجرة وسيارات نقل الركاب التي مضت على صنعها عشرون سنة.

وفي جميع الأحوال يسمح لمالك المركبة الأجرة بنقل الترخيص إلى مركبته الجديدة المستبدلة بها، وذلك مع عدم الإخلال بجواز ترخيصها كسيارة خاصة.

(3) سيارة نقل الركاب: وهى المعدة لنقل عدد من الركاب لا يقل عن ثمانية عن أنواعها:

(أ)سيارة عام للركاب (أتوبيس أو ترولى باص): وهى المعدة لنقل الركاب بأجر محدد عن كل راكب وتعمل بطريقة منتظمة فى خط سير معين.

(ب)سيارة خاص للركاب (أتوبيس مدارس، أو أتوبيس خاص): وهى المعدة لنقل الطلبة أو العاملين وعائلاتهم.

(ج)أتوبيس سياحى: وهو سيارة معدة للسياحة ويجوز أيضا استعمالها لنقل عمال المرخص له عمال المرخص لنقل عمال المرخص بالأحكام والشروط التي يصدر بها قرار من وزير الداخلية.

(د)أتوبيس رحلات: وهو سيارة معدة لنقل الرحلات، ويجوز أيضا استعمالها لنقل عمال المرخص له بالأحكام والشروط التي يصدر بها قرار من وزير الداخلية.

(4) سيارة نقل مشترك: وهى المعدة لنقل الأشخاص والأشياء معا في حدود المناطق التي يحددها وزير الداخلية بقرار منه.

(5) سيارة نقل: وهى المعدة لنقل الحيوانات أو البضائع وغيرها من الأشياء.

(6) سيارة نقل خفيف: وهى المعدة لنقل البضائع وغيرها من الأشياء الخفيفة التي لا تزيد حمولتها الصافية على 2000 كيلو جرام طبقا للشروط والأوضاع التي يحددها وزير الداخلية.

ويجوز قيادة هذه السيارة برخصة قيادة خاصة.(1)$e50$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $eh60$الفرع الأول: مركبات النقل السريع$eh60$, $et60$مادة 5$et60$, $e60$الجرار مركبة ذات محرك آلى تسير بواسطته ولا يسمح تصميمها بوضع أية حمولة عليها أو استعمالها فى نقل الأشخاص ويقتصر استعمالها على جر المقطورات والآلات وغيرها.$e60$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $eh70$الفرع الأول: مركبات النقل السريع$eh70$, $et70$مادة 6$et70$, $e70$يحظر استيراد أو التصنيع أو الترخيص بمقطورة يجرها جرار أو سيارة أو أية آلة أخرى بعد نفاذ حظر تسييرها، ويستثنى من ذلك مقطورات الجرارات الزراعية، وتحدد اللائحة التنفيذية لهذا القانون شروط استخدامها.

ويعاقب على تسيير مقطورات بالحبس مدة لا تقل عن شهر ولا تزيد على شهرين، وبغرامة لا تقل عن خمسة آلاف جنيه ولا تزيد على عشرين ألف جنيه أو بإحدى هاتين العقوبتين ويحكم بمصادرة المقطورة وما يجرها.(42)$e70$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, $eh80$الفرع الأول: مركبات النقل السريع$eh80$, $et80$مادة 7$et80$, $e80$الدراجات النارية مركبة نارية من وسائل النقل الخفيفة والمواصلات الخفيفة تسير بواسطة محرك آلي، ومن أنواعها:

1-دراجة نارية تسير بعجلتين أو أكثر، ويجوز أن يلحق بها صندوق جانبي أو خلفي لنقل الأشياء أو الأفراد.

2-التوك توك دراجة نارية تسير بثلاث عجلات وتكون مجهزة بعدد من الرحلات المقررة لنقل الركاب بالأجر.

3-دراجة نارية تسير بثلاث عجلات أو أكثر، مصممة للسير في الأماكن الوعرة ولا يسمح بالسير بها إلا في الأماكن الجبلية والساحلية ولا يجوز أن تستخدم لنقل الأفراد، ويجوز أن يلحق بها صندوق خلفي لنقل البضائع.

وذلك كله وفقا للشروط الواردة بأحكام هذا القانون ولائحته التنفيذية، كما تحدد اللائحة التنفيذية المواصفات الأخرى الخاصة بكل نوع منها.(61)(54)$e80$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins8;

WITH ins9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 1, $eh90$الفرع الأول: مركبات النقل السريع$eh90$, $et90$مادة 7 مكررا (مضافة بالقانون 17/2024)$et90$, $e90$المركبة الخفيفة هي مركبة نارية ذات أربع عجلات تعمل بإحدى وسائل الطاقة وتتخصص لنقل الأشخاص بأجر، وذلك وفقا للشروط والمواصفات التي تحددها اللائحة التنفيذية.

وتسرى على المركبة الخفيفة الأحكام الخاصة بمركبات التوك توك، كما تسرى على المركبة الخفيفة ومركبات التوك توك الضرائب والرسوم المقررة على سيارات الأجرة بجدول الرسوم والضرائب الملحق بقانون المرور المشار إليه، وذلك كله فيما لم يرد بشأنه نص خاص فى هذا القانون أو أى قانون آخر.(مُضافة بالقانون رقم 17 لسنة 2024)$e90$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins9;

WITH ins10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, $eh100$الفرع الثانى: مركبات النقل البطىء$eh100$, $et100$مادة 8$et100$, $e100$الدراجة مركبة ذات عجلتين أو أكثر تسير بقوة راكبها ومعدة لنقل الأشخاص فقط. ويجوز استعمالها فى نقل الأشياء على أن يلحق بها صندوق.$e100$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins10;

WITH ins11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, $eh110$الفرع الثانى: مركبات النقل البطىء$eh110$, $et110$مادة 9$et110$, $e110$العربة مركبة معدة لنقل الأشخاص أو الأشياء وأنواعها كالآتى:

(1) عربة ركوب حنطور: وهى تسير بقوة الحيوان ومعدة لنقل الأشخاص.

(2) عربة نقل كارو: وهى تسير بقوة الحيوان ومعدة لنقل الأشياء.

(3) عربة نقل موتى: وهى تسير بقوة الحيوان ومعدة لنقل الموتى.

(4) عربة يد: وهى تسير بقوة الإنسان ومعدة لنقل الأشياء.$e110$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins11;

WITH ins12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, $eh120$الباب الثانى: رخص تسيير وقيادة مركبات النقل السريع - الفصل الأول: رخص تسيير مركبات النقل السريع$eh120$, $et120$مادة 10$et120$, $e120$يقدم طلب الترخيص من مالك المركبة أو نائبه إلى قسم المرور المختص مرفقا به المستندات المثبتة لشخصيته وصفته وملكية المركبة.

ويصدر بتحديد هذه المستندات وشروط قبولها قرار من وزير الداخلية.$e120$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins12;

WITH ins13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, $eh130$الفصل الأول: رخص تسيير مركبات النقل السريع$eh130$, $et130$مادة 11$et130$, $e130$يشترط للترخيص بتسيير المركبة ما يأتى:

(1) الوفاء بالضرائب والرسوم المقررة في هذا القانون.

(2) التأمين عن المسئولية المدنية الناشئة عن حوادث المركبة عن كافة الأضرار المادية الناجمة عنها، التي تلحق بالغير عدا تلفيات المركبات، وذلك مدة سريان ترخيصها، أو تسييرها طبقا لأحكام القانون الخاص بذلك، ووفقا لبنود لبنود التأمين.

(3) استيفاء المركبة لشروط المتانة والأمن التي يحددها وزير الداخلية بقرار منه.

وتحدد اللائحة التنفيذية شروط وإجراءات الفحص الفني ومقابل إجراءات الفحص الفني والجهات التي تتولاه من حالات الإعفاء.

(4) وضع جهاز محدد السرعات بمركبات السياحة، والنقل بنصف مقطورة، والنقل بمقطورة، والنقل بمقطورة قبل نفاذ حظر تسييرها، لا يتيح فنيا لقائدى تلك المركبات تجاوز السرعات المقررة لها والواردة في اللائحة التنفيذية لهذا القانون.

(5) وضع جهاز صالح للاستعمال لتسجيل جميع المعلومات الخاصة بتحركات المركبة وتصرفات السائق وتخزينها فيه بطريقة نارية يستحيل التدخل اليدوى فيها، وذلك لاستخراج المعلومات منه وتفريغها بالوسائل الفنية عند الحاجة إليها فى أتوبيسات نقل الركاب (أتوبيسات عامة، ترولى باص، أتوبيسات مدارس، أتوبيسات سياحية، أتوبيسات رحلات) والسيارات والنقل، والنقل بنصف مقطورة، والنقل بمقطورة قبل نفاذ حظر تسييرها، وذلك كله وفقا للقواعد التي تضعها اللائحة التنفيذية لهذا القانون.

(6) تزويد المركبة بمثلث عاكس للضوء وفقا للاشتراطات المرورية لوضعه على أرضية الطريق خلف المركبة بمسافة لا تقل عن عشرة أمتار حال توقفها بالطريق نتيجة عطل أو أى سبب آخر.

(7) تزويد المركبة بحقيبة للإسعافات الأولية يصدر بتحديد مكوناتها قرار من وزير الداخلية بالاتفاق مع وزير الصحة.(4)

(8) وضع وتثبيت ملصق مرورى إلكتروني منصرف للمركبة يصدر بصورة دائمة يصرف للمركبة، ويؤدى عنه رسم لا يقل عن خمسة وسبعين جنيها ولا يزيد على ثلاثمائة جنيه سنويا وفقا للتغيرات والإضافات الفنية التي سوف تضاف عليه نقدا، يلزم تضاده بأي وسيلة إلكترونية أخرى.$e130$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins13;

WITH ins14 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, $eh140$الفصل الأول: رخص تسيير مركبات النقل السريع$eh140$, $et140$مادة 12$et140$, $e140$لا تسري الرخصة إلا عن المركبة التي صرفت عنها، والمدة التي تسدد عنها الضريبة، والمدة التي لا يزيد بما لا يزيد على سنة، فيما عدا السيارات الخاصة والدراجات النارية عدا التي تعمل بالأجرة والجرارات والمعدات الثقيلة فيجوز أن تكون لمدة لا تزيد على ثلاث سنوات بحسب رغبة مالك المركبة وذلك وفقا للشروط التي تحددها اللائحة التنفيذية لهذا القانون.

ويجوز تسيير المركبة في جميع أنحاء البلاد، ما لم يكن الترخيص مقصورا على دائرة معينة أو خط سير محدد.

ويجب أن تكون رخصة سيرها موجودة بها دائما، ولرجال الشرطة والمرور أن يطلبوا تقديمها في أى وقت.

وتنظم اللائحة التنفيذية إجراءات الترخيص وتحدد النماذج اللازمة لذلك.(23)$e140$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins14;

WITH ins15 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, $eh150$الفصل الأول: رخص تسيير مركبات النقل السريع$eh150$, $et150$مادة 13 (فقرة ثانية مستبدلة بالقانون 17/2024)$et150$, $e150$تحمل كل مركبة أثناء سيرها لوحتين معدنيتين تصرفهما إدارة المرور المختصة بعد إتمام إجراءات الترخيص وأداء تأمين عنهما.

وتحدد اللائحة التنفيذية لهذا القانون شكل اللوحات المعدنية والبيانات التي تتضمنها وعلامات تأمينها ومدة صلاحيتها وأماكن تثبيتها على المركبة ومقابل تطوير اللوحات المعدنية بما لا يجاوز (مائة جنيه)، وقيمة التأمين الذى يؤدى عنها بما لا يجاوز (مائتى جنيه)، ويجوز بقرار من رئيس مجلس الوزراء زيادة الحد الأقصى لمقابل التطوير المشار إليه بهذه المادة بنسبة سنويا لا تجاوز (10%) وبما لا يجاوز ثلاثة أمثال الحد الأقصى المشار إليه بهذه المادة، ويتم تحصيل هذه المبالغ بإحدى الوسائل المنصوص عليها بقانون تنظيم استخدام وسائل الدفع غير النقدى الصادر بالقانون رقم 18 لسنة 2019.(النص المستبدل بالقانون رقم 17 لسنة 2024)$e150$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins15;

WITH ins16 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, $eh160$الفصل الأول: رخص تسيير مركبات النقل السريع$eh160$, $et160$مادة 14$et160$, $e160$لا يجوز تسيير المركبة المرخص بها بغير لوحاتها، كما لا يجوز استعمال اللوحات إلا للمركبة المنصرفة لها، أو إبدال، أو تغيير بياناتها، وإلا سحبت إداريا اللوحات الأصلية للمركبة وضبطت اللوحات المخالفة المستعملة عليها، وتؤول قيمة التأمين عن اللوحات الأصلية إلى الدولة.(42)$e160$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins16;

WITH ins17 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, $eh170$الفصل الأول: رخص تسيير مركبات النقل السريع$eh170$, $et170$مادة 15$et170$, $e170$على مالك المركبة والمرخص له في حالة فقد اللوحات أو إحداها إبلاغ أقرب مركز للشرطة أو للمرور فورا.

وعليه عند انتهاء ترخيص المركبة أو استغنائه عن تسييرها وكذلك عند سحب الرخصة رد اللوحات إلى قسم المرور المختص وذلك في موعد أقصاه اليوم التالى.

وتؤول قيمة التأمين إلى الدولة عند فقد اللوحات أو إحداها أو تلفها وعند الامتناع أو الغياب عن تسليمها إذا انتهى أجل الرخصة أو سحبت أو ألغيت وذلك دون الإخلال بأية عقوبة عليها ينص عليها قانون العقوبات أو أى قانون آخر.

وكل مركبة سحبت لوحاتها طبقا للقانون يجوز منحها ترخيصا مؤقتا لتوصيلها إلى أقرب مكان مبين بالترخيص، فإذا ضبطت مسيرة في الطريق، إذا كان ترخيصها قائدها ملغى من تاريخ الضبط.(35)

ولا يجوز إعادة الترخيص بها قبل مضى تسعين يوما على إلغاء الترخيص.$e170$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins17;

WITH ins18 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, $eh180$الفصل الأول: رخص تسيير مركبات النقل السريع$eh180$, $et180$مادة 16$et180$, $e180$على المرخص له إخطار قسم المرور المختص بكل تغيير في محل إقامته المثبت في محل الرخصة خلال ثلاثين يوما من اليوم التالى لتاريخ التغيير، فإذا كان التغيير إلى محافظة أخرى وجب عليه خلال الميعاد المذكور أن يستوفي إجراءات نقل القيد التي يحددها وزير الداخلية بقرار منه.

ويترتب على مخالفة ذلك إلغاء الترخيص ومنح رخصة معدنية مؤقتة بعد أداء الضرائب والرسوم المقررة لنقل القيد لجهة المرور الواقع في دائرتها محل الإقامة.(25)$e180$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins18;

WITH ins19 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, $eh190$الفصل الأول: رخص تسيير مركبات النقل السريع$eh190$, $et190$مادة 17$et190$, $e190$على المرخص له إخطار قسم المرور المختص قبل إجراء أى تغيير في الأجزاء الجوهرية للمركبة، وبكل تغيير جوهرى في وجوه استعمال المركبة أو في وصفها بما يجعلها غير مطابقة للبيانات المدونة بالرخصة، وفي جميع الأحوال لا يجوز تسيير المركبة بما لحقها من تغيير قبل الحصول على موافقة قسم المرور المختص عليه، ويحدد وزير الداخلية بقرار منه ما يعتبر من الأجزاء الجوهرية وكذا التغييرات الموجبة للإخطار.

ومع عدم الإخلال بأية عقوبة أشد في أى قانون آخر يعاقب كل من قام بالتزوير أو التلاعب في الأجزاء الجوهرية بالحبس.(25)$e190$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins19;

WITH ins20 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, $eh200$الفصل الأول: رخص تسيير مركبات النقل السريع$eh200$, $et200$مادة 18$et200$, $e200$إذا تعدد ملاك المركبة وجب أن يعينوا من بينهم من يكون مسئولا عن إدارتها وعن مراعاة أحكام هذا القانون ويؤشر بذلك في الرخصة ويكونون جميعا مسئولين بالتضامن معه عن الضرائب والرسوم التي تستحق على المركبة طبقا لهذا القانون.$e200$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins20;

WITH ins21 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, $eh210$الفصل الأول: رخص تسيير مركبات النقل السريع$eh210$, $et210$مادة 19$et210$, $e210$على المرخص له في حالة نقل ملكية المركبة إخطار قسم المرور المختص بذلك، ويرفق بإخطاره سندا مقبولا في إثبات نقل الملكية طبقا للمادة 10 من هذا القانون. وعلى المالك الجديد أن يطلب نقل القيد باسمه، وأن يتم الإخطار واستيفاء جميع إجراءات نقل القيد خلال ثلاثين يوما من اليوم التالى لتاريخ صيرورة السند الناقل للملكية مقبولا في حكم المادة 10 من هذا القانون، وإلا اعتبرت الرخصة ملغاة من اليوم التالى لإنتهاء هذه المدة، ولا يجوز نقل القيد إلا بعد أداء الضرائب والرسوم المستحقة عن المركبة وكذلك الوفاء بالغرامات المحكوم بها لمخالفة أحكام هذا القانون عن المدة من تاريخ ترخيص نقل القيد.

ويظل المقيدة باسمه المركبة مسئولا بالتضامن مع المالك الجديد عن تنفيذ أحكام هذا القانون عن تاريخ انتقال الملكية حتى تاريخ نقل الملكية أو إلى أن ترد اللوحات المعدنية للمركبة إلى أى قسم من أقسام المرور.

وتحدد اللائحة التنفيذية إجراءات نقل القيد والمستندات اللازمة لذلك.$e210$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins21;

WITH ins22 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, $eh220$الفصل الأول: رخص تسيير مركبات النقل السريع$eh220$, $et220$مادة 20$et220$, $e220$إذا وضعت المركبة تحت الحراسة القضائية أو الاتفاقية أو كانت جزءا من أموال وضعت تحت الحراسة أو من تفليسة أو تصفية قضائية أو اتفاقية أو إذا وضع المرخص له تحت الوصاية أو القوامة أو المساعدة القضائية، وجب على الحارس أو وكيل الدائنين أو المصفى أو الوصى أو القيم أو المساعد القضائى إخطار قسم المرور المختص بذلك خلال ثلاثين يوما من قيامه بمهمته، ويؤشر بذلك في دفاتر الرخصة على المركبة بحسب الأحوال، وعليه الإخطار عند انتهاء مهمته وبمن آلت إليه حالة حل محله فيها أو من انتهاءها أو أيلولتها من ثلاثين يوما.

ويسرى على الفقرة السابقة على من يتولى التركة والوصى والقيم مع مراعاة الميعاد المنصوص عليه في الفقرة السابقة.

ويلغى ترخيص المركبة لعدم الإخطار عن تغيير المسئول عنها المبين في الميعاد المشار إليه في هذه المادة أو عن تغيير الملكية نتيجة الوفاة الموضحة في المواعيد الخاصة بالإخطار عن الوفاة والمبينة بالفقرة السابقة.(49)$e220$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins22;

WITH ins23 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, $eh230$الفصل الأول: رخص تسيير مركبات النقل السريع$eh230$, $et230$مادة 21$et230$, $e230$إذا توفي مالك المركبة أو حكم باعتباره مفقودا وجب على من يمثلهم أو من ورثته إخطار قسم المرور المختص بذلك خلال ستة أشهر التالى لتاريخ الوفاة أو الحكم أو ممن يكون مسئولا عن المركبة من الورثة البالغين من له من النيابة عن القصر، فإذا آلت المركبة إلى أحد الورثة وجب عليه الاخطار بذلك ليتم نقل قيد الرخصة إليه.

ويسرى على مصفى التركة والوصى والقيم مع مراعاة الميعاد المنصوص عليه في الفقرة السابقة.

ويلغى ترخيص المركبة لعدم الإخطار عن تغيير المسئول عنها المبين في الميعاد المبين في هذه المادة أو عن تغيير الملكية نتيجة الوفاة الموضحة في المواعيد الخاصة بالإخطار عن الوفاة والمبينة بالفقرة السابقة.(49)$e230$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins23;

WITH ins24 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, $eh240$الفصل الأول: رخص تسيير مركبات النقل السريع$eh240$, $et240$مادة 22$et240$, $e240$تنقضي صلاحية ترخيص تسيير المركبة بانقضاء أجله دون تجديد.

ويكون تجديد رخصة المركبة في موعد لا يجاوز الثلاثين يوما التالية لانتهاء مدة الترخيص.$e240$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins24;

WITH ins25 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, $eh250$الفصل الأول: رخص تسيير مركبات النقل السريع$eh250$, $et250$مادة 23$et250$, $e250$يقدم طلب التجديد على النموذج المعتمد من وزير الداخلية مع أداء الضرائب والرسوم المقررة. ولا يجوز التجديد إلا بعد أداء الضرائب والرسوم المتأخرة عن المركبة من آخر ترخيص لها حتى تاريخ التجديد وقيام قائد المركبة بالغرامات المحكوم بها الناجمة عن مخالفته لأحكام هذا القانون، كما يتم فحص المركبة فنيا على الوجه المبين في المادة (11) من هذا القانون، فإذا أسفر الفحص عن عدم صلاحية المركبة أخطر الطالب كتابة بالرفض مع بيان الأسباب خلال أسبوع من تاريخ الفحص، وفي هذه الحالة يجوز منح ترخيص مؤقت بتسيير المركبة لمدة لا تتجاوز ثلاثين يوما لتدارك أسباب هذا الرفض متى كان لا يعرض حياة الأرواح أو الأموال للخطر أو يقلق الراحة أو يضر بالبيئة.(43)$e250$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins25;

WITH ins26 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, $eh260$الفصل الأول: رخص تسيير مركبات النقل السريع$eh260$, $et260$مادة 24$et260$, $e260$إذا أدى المرخص له الضرائب والرسوم المقررة للتجديد خلال المدة المبينة في المادة 22 من هذا القانون دون استيفاء باقي إجراءات التجديد خلالها، تسحب الرخصة اللوحات المعدنية عند انتهاء الترخيص ولا ترد إليه اللوحات المعدنية إلا بعد استيفاء إجراءات التجديد.

مع الرخصة المجددة، تسري هذه الرخصة المجددة من تاريخ انتهاء الرخصة السابقة.

فإذا انقضت المدة المدفوع عنها الضرائب والرسوم دون استيفاء إجراءات التجديد سقط الحق في استردادها ويتبع في استرادادها إجراءات التجديد بالمركبة إجراءات الترخيص الجديد.$e260$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins26;

WITH ins27 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, $eh270$الفصل الأول: رخص تسيير مركبات النقل السريع$eh270$, $et270$مادة 25$et270$, $e270$يجوز منح رخص ولوحات معدنية مؤقتة لمن يزاولون صناعة أو الاتجار فيها أو إصلاحها أو استيرادها أو إصلاحها متى كان الطالب مقيدا بهذه الصفة في السجل التجارى، وكذا للأشخاص الاعتبارية العامة التي تمارس وفقا لنظمها إحدى هذه العمليات للغير، وذلك بعد أداء الضرائب والرسوم المقررة، تحدد اللائحة التنفيذية شروط منح هذه الرخص بما في ذلك تحديد أغراض استعمالها.

وفي حالة مخالفة شروط منح الرخصة أو استعمال المركبة في غير الأغراض المذكورة إداريا يلغى الترخيص إداريا وتعتبر المركبة مسيرة بدون ترخيص.$e270$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins27;

WITH ins28 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 26, 0, $eh280$الفصل الأول: رخص تسيير مركبات النقل السريع$eh280$, $et280$مادة 26$et280$, $e280$يجوز منح رخص ولوحات معدنية مؤقتة بعد أداء الضرائب والرسوم المقررة وذلك في الحالات الواردة في المادة السابقة لمن ليس لهم حق الحصول على رخص تجارية. وعند مخالفة شروط منح الرخصة أو استعمال المركبة في غير الأغراض المذكورة، تعتبر المركبة مسيرة بدون ترخيص.(39)$e280$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins28;

WITH ins29 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 27, 0, $eh290$الفصل الأول: رخص تسيير مركبات النقل السريع$eh290$, $et290$مادة 27$et290$, $e290$يضع وزير الداخلية بقرار منه نظم ترخيص بتسيير المركبات المملوكة للحكومة وللجامعات ولوحدات الحكم المحلى وشروطه وإجراءاته ومدته وأوضاعه وكيفية وجهة صرفها. وفي جميع الأحوال يجب أن يتوافر في هذه المركبات شروط المتانة والأمن المشار إليها في المادة 11 من هذا القانون.

ويقصد بالحكومة رياسة الجمهورية ومجلس الوزراء والوزارات وما يتبع هذه الجهات من مصالح وفروع دون الهيئات العامة والمؤسسات العامة وشركات القطاع العام.$e290$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins29;

WITH ins30 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 28, 0, $eh300$الفصل الأول: رخص تسيير مركبات النقل السريع$eh300$, $et300$مادة 28 (فقرتان أولى وثانية مستبدلتان بالقانون 17/2024)$et300$, $e300$يحدد المحافظ المختص بقرار منه بعد موافقة المجلس الشعبي المحلي للمحافظة الحد الأقصى لعدد مركبات الأجرة، وكذلك مركبات (التوك توك) والمركبات الخفيفة المستخدمة فى نقل الأشخاص بأجر المصرح بتسييرها فى إقليم المحافظة.

وتحدد تعريفة أجور مركبات الأجرة والتوك توك والمركبات الخفيفة ونقل الموتى بقرار من المحافظ المختص بعد موافقة المجلس الشعبي المحلي للمحافظة.(النص المستبدل بالقانون رقم 17 لسنة 2024)

ولا يجوز تسيير مركبة أجرة فى دائرة المحافظة التي صدر فيها قرار باستعمال العدادات (تاكسيميتر)، ما لم تكن مجهزة بعداد معتمد من إدارة المرور المختصة.

ولإدارات المرور أن تفحص أية عداد مركبة في أى وقت للتأكد من صلاحيته.

وتحدد اللائحة التنفيذية لهذا القانون رسم فحص العداد بما لا يجاوز عشرين جنيها، وأحوال استحقاقه، وكافة الضوابط المحددة لنظام تسيير مركبات الأجرة.(6)$e300$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins30;

WITH ins31 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 29, 0, $eh310$الفصل الأول: رخص تسيير مركبات النقل السريع$eh310$, $et310$مادة 29$et310$, $e310$يوضح في رخص سيارات الأجرة ونقل الركاب عدد الركاب المرخص بنقلهم والدائرة المعينة لسيرها أو خط سيرها، ويعلن بوضوح داخل السيارة رقمها وعدد الركاب المرخص بنقلهم ونقلهم بنقلهم بنقلهم بحسب نوع السيارة.

ويوضح في رخص مركبات النقل أقصى وزن وارتفاع وعرض ولحمولتها وعدد من يصرح لهم بالركوب من عمال السيارة، فضلا عن الاشتراطات الصحية والإدارية التي يرى المحافظة وجوب توافرها في هذا النوع من السيارات، كما يعلن على جانبى السيارة رقمها وأقصى وزن وارتفاع وعرض ولحمولتها وعدد من يصرح لهم بالركوب.

وتسري على سيارات النقل المشترك الأحكام الواردة في هذه المادة الخاصة بسيارات النقل وبسيارات النقل العام للركاب.$e310$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins31;

WITH ins32 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 30, 0, $eh320$الفصل الأول: رخص تسيير مركبات النقل السريع$eh320$, $et320$مادة 30$et320$, $e320$لوزير الداخلية بقرار منه أن يعفي من ترخيص التسيير أو من شروطه وإجراءاته، بعضها أو كلها، المركبات المصممة لتكون آلات صناعية أو زراعية أو لتعبيد الطرق وصيانتها والتي لا يمكن بحسب تصميمها وتجهيزها واستعمالها في نقل الأشخاص أو الأشياء.$e320$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins32;

WITH ins33 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 31, 0, $eh330$الفصل الأول: رخص تسيير مركبات النقل السريع$eh330$, $et330$مادة 31$et330$, $e330$لأقسام المرور وأقسام ومراكز الشرطة بعد موافقة الجهة الصحية المختصة أن تصرح بنقل الموتى في غير المركبات المعدة لذلك.$e330$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins33;

WITH ins34 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 32, 0, $eh340$الفصل الأول: رخص تسيير مركبات النقل السريع$eh340$, $et340$مادة 32$et340$, $e340$يلغي تسيير المركبة ورخصة قائدها إذا استخدمت المركبة في غير الغرض المبين برخصتها، ولا يجوز إعادة ترخيصها أو استخراج رخصة لقائدها قبل مضى ثلاثين يوما من تاريخ الضبط.

وفي حالة ارتكاب الفعل ذاته خلال ستة أشهر من تاريخ ارتكاب الفعل السابق يلغى ترخيص تسيير المركبة ورخصة قائدها لمدة لا تزيد على ثلاثة أشهر، وفي حالة ارتكاب الفعل ذاته مرة ثالثة خلال سنة من تاريخ ارتكاب الفعل الأول يلغى ترخيص تسيير المركبة ورخصة قائدها لمدة ستة أشهر.

ولا يسرى ذلك على مالك المركبة إلا إذا كان قد وافق على استخدامها في غير الغرض المبين برخصتها.(16)$e340$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins34;

WITH ins35 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 33, 0, $eh350$الفصل الأول: رخص تسيير مركبات النقل السريع$eh350$, $et350$مادة 33$et350$, $e350$لضباط المرور المختصين إيقاف أية مركبة لا تتوافر فيها شروط المتانة والأمن أو الشروط المنصوص عليها في الرخصة، وتوصيلها إلى أقرب مركز للشرطة أو للمرور للتأكد من صلاحيتها فنيا.(42)$e350$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins35;

WITH ins36 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 34, 0, $eh360$الباب الثانى: رخص تسيير وقيادة مركبات النقل السريع - الفصل الثانى: رخص قيادة مركبات النقل السريع$eh360$, $et360$مادة 34 (بند 8 مستبدل بالقانون 17/2024)$et360$, $e360$لا يجوز لأحد أن يحصل على أكثر من رخصة واحدة من رخص القيادة المبينة في هذه المادة عدا المرخص لهم طبقا للبنود من 5 إلى 12 منها فيجوز لهم الحصول على رخصة واحدة إضافية من نوع آخر.

وأنواع رخص القيادة كالآتى:

(1) رخصة قيادة خاصة: تجيز لحاملها، ممن لا تكون القيادة مهنته، قيادة سيارة خاصة، وقيادة سيارات الأجرة التي تعمل فى النقل السياحى والجرار الزراعى بقصد الاستعمال الشخصى، وسيارات النقل الخفيف التي لا تزيد حمولتها على ألفي كيلو جرام.

(2) رخصة قيادة درجة ثالثة: تجيز لحاملها، ممن لا تكون قيادة السيارات مهنته، قيادة السيارات الأجرة، وسيارات الأتوبيس التي لا يزيد عدد ركابها على سبعة عشر راكبا، فضلا عن السيارات المبينة في البند السابق.

(3) رخصة قيادة درجة ثانية: تجيز لحاملها قيادة سيارات الأجرة، وسيارات الأتوبيس التي يزيد عدد ركابها على سبعة عشر وحتى ستة وعشرين راكبا، وسيارات النقل، والمعدات الثقيلة، فضلا عن قيادة السيارات المبينة في البندين السابقين، ولا تصرف إلا بعد مضى ثلاث سنوات على الأقل من تاريخ الحصول على الرخصة المبينة في البند (2).

(4) رخصة قيادة درجة أولى: تجيز لحاملها قيادة جميع أنواع السيارات، ولا تصرف إلا بعد مضى ثلاث سنوات على الأقل من تاريخ الحصول على الرخصة المبينة في البند (3).

(5) رخصة قيادة جرار زراعي: تجيز لحاملها قيادة جرار مفرد أو ذي مقطورة زراعية.

(6) رخصة قيادة مترو أو ترام: تجيز لحاملها قيادة مركبات المترو أو الترام.

(7) رخصة دراجة بخارية خاصة: وتجيز لحاملها من لا تكون القيادة مهنتهم قيادة دراجة بخارية.

(8) رخصة قيادة مركبات (التوك توك) أو رخصة قيادة المركبات الخفيفة تجيز لحاملها قيادتها.(النص المستبدل بالقانون رقم 17 لسنة 2024)

(9) رخصة قيادة دراجة نارية خفيفة تجيز لحاملها قيادتها.

(10) رخصة قيادة عسكرية: وتجيز لحاملها قيادة المركبات العسكرية فقط وتمنح لأفراد القوات المسلحة من الجهات التابعين لها وفقا للشروط والأوضاع التي يحددها وزير الداخلية بالاتفاق مع وزير الحربية.

(11) رخصة قيادة شرطة: وتجيز لحاملها قيادة مركبات الشرطة فقط وتمنح لأفراد هيئة الشرطة بالشروط والأوضاع التي يحددها وزير الداخلية.

(12) رخصة قيادة للتجربة: تمنح للمنوط بهم اختبار صلاحية مركبات النقل السريع.

(13) رخصة قيادة مؤقتة للتعلم: تمنح لراغبى تعلم قيادة المركبات.

ويعفى كل من اجتاز بنجاح الدراسة المقررة في إحدى مدارس أو مراكز تعليم قيادة السيارات التابعة للحكومة أو القطاع العام أو قطاع الأعمال العام المرخص بها، من الاختبار الفنى فى القيادة وفى قواعد المرور وآدابه، وكذلك من شروط المدد البينية الواردة في هذه المادة، والمحددة للحصول على رخص قيادة درجة أولى ودرجة ثانية.

ويصرف إليه بنوع تصريح يسمح له الرخصة بقيادة السيارات التابعة للجهة التي تولت تدريبه دون غيرها، ولا تسلم له رخصة القيادة المهنية النهائية إلا بعد استكماله المدة المقررة قانونا.(62)(7)$e360$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins36;

WITH ins37 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 0, $eh370$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh370$, $et370$مادة 35$et370$, $e370$يشترط لمنح رخص القيادة أن تتوافر في طالب الترخيص الشروط الآتية:

1- ألا يقل سن الطالب عن (16) سنة ميلادية بالنسبة للرخص الواردة للبند (9) من المادة (34) من هذا القانون، وعن (18) سنة ميلادية للرخص الواردة للبندين (1)، (7) من المادة (34) من هذا القانون ورخصة التعليم اللازمة للحصول عليها، وعن (21) سنة ميلادية بالنسبة للرخص الواردة في البنود (2)، (3)، (4)، (5)، (6)، (8) من المادة (34) من هذا القانون، ورخص التعليم اللازم للحصول عليها.(61)(12)

2- لياقته صحيا من حيث سلامة البنية والنظر والخلو من العاهات التي تعجزه عن القيادة.

3- أن يكون حاصلا على شهادة إتمام مرحلة دراسية أو شهادة محو الأمية الصادرة من الهيئة العامة لمحو الأمية وتعليم الكبار.

4- اجتياز اختبار فنى في القيادة وفي قواعد المرور وآدابه وذلك بعد أداء رسم مقابل الاختبار وتحدد اللائحة التنفيذية قيمة الرسم وأحوال استحقاقه.

5- بالنسبة للرخص الواردة في البنود (2) و(3) و(4) و(6) و(12) من المادة السابقة ألا يكون قد سبق الحكم عليه بعقوبة جناية أو فى إحدى الجرائم المنصوص عليها في المادة (182) من القانون رقم 1960 لسنة 1960 في شأن مكافحة المخدرات وتنظيم استعمالها والإتجار فيها أو سبق معاقبته لقيادته مركبة تحت تأثير خمر أو مخدر، ما لم تمض على تنفيذ العقوبة أو سقوطها بمضي المدة ثلاث سنوات، أو كان الحكم مشمولا بوقف تنفيذ العقوبة.

وينظم وزير العدل بالاتفاق مع وزير الداخلية إجراءات إخطار الإدارة العامة للمرور بالأحكام النهائية الصادرة في هذه الجرائم.

وتنظم اللائحة التنفيذية إجراءات منح رخص القيادة والمستندات المرفقة التي ترفق بطلب الترخيص للتحقق من توفر الشروط المطلوبة، كما تحدد النماذج اللازمة للترخيص، وتبين نظام وشروط منح الرخص المبينة بالبند أرقام (9، 12، 13) من المادة (34) من هذا القانون، كما تنظم اللائحة الترخيص لذوى الإعاقة ونوع المركبات التي يصرح لهم بقيادتها وشروطها من حيث التصميم الفنى ومنحها التأهيل لمن يفيدون من نظم منح الرخص دون تقيد بأحكام البند(5) أو الفقرة الثانية من المادة (36) من هذا القانون.(8)(61)$e370$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins37;

WITH ins38 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 1, $eh380$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh380$, $et380$مادة 35 مكررا$et380$, $e380$يشترط لمنح رخصة القيادة لأول مرة إجادة القراءة والكتابة.(50)$e380$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins38;

WITH ins39 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 2, $eh390$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh390$, $et390$مادة 35 مكررا 1$et390$, $e390$في حالة ثبوت ارتكاب قائد المركبة حادث مرورى حادث وفاة شخص أو إصابته يجوز إلغاء رخصة القيادة ولا يتم منح رخصة قيادة جديدة إلا بعد اجتيازه دورة تدريبية لمدة لا تقل عن ثلاثة أشهر فى أحد المراكز أو المدارس المعتمدة من الإدارة العامة للمرور لمنحة ذات الرخصة بذات الدرجة ويعاد اختياره ويعاد وفقا لذات الشروط والاختبارات الواردة في نص المادة (35) ودون الإخلال بما ورد في نص المادة (56).(36)$e390$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins39;

WITH ins40 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 0, $eh400$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh400$, $et400$مادة 36$et400$, $e400$يجوز الامتناع عن منح ترخيص القيادة لمن سبق الحكم عليه بجريمة قتل أو إصابة خطأ بسبب قيادة مركبة وذلك خلال ثلاث سنوات من تنفيذ العقوبة أو سقوطها بمضى المدة، أو من تاريخ الحكم إذا اقترن بوقف تنفيذ العقوبة.

وإذا حكم عليه مرة أخرى في إحدى الجريمتين المشار إليهما في الفقرة السابقة خلال الفترة السابقة، فلا يجوز منح ترخيص القيادة إلا بعد انقضاء ثلاث سنوات تحسب على الوجه السابق.$e400$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins40;

WITH ins41 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 37, 0, $eh410$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh410$, $et410$مادة 37$et410$, $e410$تكون مدد سريان الرخص المنصوص عليها في المادة (34) من هذا القانون كما يلي:

1- عشر سنوات بالنسبة للبند (1).

2- خمس سنوات بالنسبة للبنود (5)، (7)، (12).

3- ثلاث سنوات بالنسبة للبنود 2، 3، 4، 6، 8.

4- سنة واحدة بالنسبة للبند (9)، وستة أشهر بالنسبة للبند (13).(61)

5- مدة الخدمة بالنسبة للبندين (10)، (11).

ويكون تجديد الرخص خلال الثلاثين يوما التالية لانتهاء مدتها، ويشترط عند كل تجديد توافر الشروط المطلوبة لمنح الترخيص عدا البند رقم (4) من المادة (35) من هذا القانون.(9)$e410$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins41;

WITH ins42 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 38, 0, $eh420$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh420$, $et420$مادة 38$et420$, $e420$على المرخص له عند تغيير محل إقامته إخطار قسم المرور المختص خلال ثلاثين يوما من اليوم التالى للتغيير بكتاب موصى عليه، فإذا كان التغيير إلى محافظة أخرى يجب عليه خلال المدة المذكورة أن يقدم إلى قسم المرور المذكورة بهذه المحافظة طلبا لنقل القيد واستيفاء إجراءات نقل القيد التي يحددها وزير الداخلية بقرار منه.

ويترتب على عدم مراعاة الميعاد اعتبار الرخصة الثانية الحالة ملغاة.$e420$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins42;

WITH ins43 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 39, 0, $eh430$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh430$, $et430$مادة 39$et430$, $e430$تسري رخصة القيادة الأجنبية أو الدولية للمدد المصرح بها طبقا للاتفاقيات الدولية النافذة في البلاد على ألا تجاوز مدة صلاحيتها في الدولة الصادرة منها ولا يعتد بتجديدها في الخارج أثناء وجود المرخص له بالبلاد.

وتنظم اللائحة التنفيذية شروط وإجراءات منح تلك الرخص لحاملي قيادة رخص طبقا لهذا القانون وأنواعها.$e430$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins43;

WITH ins44 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 40, 0, $eh440$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh440$, $et440$مادة 40$et440$, $e440$يحدد وزير الداخلية بقرار منه الجهة التي تتولى منح رخص القيادة الدولية وشروط منحها والرسوم المستحقة.$e440$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins44;

WITH ins45 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 41, 0, $eh450$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh450$, $et450$مادة 41$et450$, $e450$على المرخص له حمل الرخصة أثناء القيادة وتقديمها لرجال الشرطة والمرور كلما طلبوا ذلك.$e450$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins45;

WITH ins46 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 0, $eh460$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh460$, $et460$مادة 42$et460$, $e460$تحظر قيادة أية مركبة نقل سريع دون الحصول على رخصة قيادة سارية تجيز قيادتها.

كما تحظر قيادتها أثناء فترة سحب أو إيقاف سريان الرخصة أو حال إلغائها.(51)$e460$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins46;

WITH ins47 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 43, 0, $eh470$الفصل الثانى: رخص قيادة مركبات النقل السريع$eh470$, $et470$مادة 43$et470$, $e470$لا يجوز لأحد ممارسة مهنة معلمي قيادة المركبات إلا بعد الحصول على ترخيص بذلك من إدارة المرور المختصة.

ولا يجوز إنشاء أو إدارة مدارس لتعليم قيادة المركبات إلا بعد الحصول على ترخيص بذلك من مدير الإدارة العامة للمرور بناء على عرض إدارة المرور المختصة، وفي حالة المخالفة تغلق المدرسة إداريا بقرار من مدير الإدارة العامة للمرور إلى أن يستوفى مالك المدرسة أو المسئول عنها إجراءات الترخيص.

وتحدد اللائحة التنفيذية لهذا القانون شروط منح الترخيص وتجديده، ونظم التعليم، والامتحان.(10)$e470$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins47;

WITH ins48 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 44, 0, $eh480$الباب الثالث: رخص تسيير وقيادة مركبات النقل البطىء - الفصل الأول: رخص تسيير مركبات النقل البطىء$eh480$, $et480$مادة 44$et480$, $e480$يشترط للترخيص بمركبات النقل البطيء ما يأتي:

(1) الوفاء بالضرائب والرسوم المقررة في هذا القانون.

(2) التأمين من المسئولية المدنية الناشئة من حوادث المركبة بالنسبة لأنواع المركبات التي يحددها المحافظ المختص بقرار منه.(11)

(3) استيفاء المركبة شروط الصلاحية للسير بما لا يؤثر على سلامة الطرق وأمن المرور بها والتي يحددها المحافظ المختص لكل نوع منها، كما يحدد الشروط الواجب توافرها في حيوانات الجر.(11)

وتحدد اللائحة التنفيذية إجراءات الترخيص وتجديده والجهة التي تتولاه والنماذج اللازمة.$e480$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins48;

WITH ins49 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 45, 0, $eh490$الفصل الأول: رخص تسيير مركبات النقل البطىء$eh490$, $et490$مادة 45$et490$, $e490$تسري الرخصة للمدة المؤداة عنها الضريبة، ومع ذلك يجوز لوزير الداخلية أن يضع نظاما لسريان الرخص لمدد أطول على أن تعتبر الرخصة ملغاة إذا لم تؤد الضرائب والرسوم المستحقة عنها في موعد لا يجاوز الثلاثين يوما التالية لهذه المدة.$e490$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins49;

WITH ins50 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 46, 0, $eh500$الفصل الأول: رخص تسيير مركبات النقل البطىء$eh500$, $et500$مادة 46$et500$, $e500$تسري الرخصة في نطاق المحافظة التي تتبعها الجهة الصادرة منها، ومع ذلك يجوز للمحافظ المختص وضع نظام لتسيير هذه المركبات في أكثر من محافظة.(14)$e500$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins50;

WITH ins51 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 47, 0, $eh510$الفصل الأول: رخص تسيير مركبات النقل البطىء$eh510$, $et510$مادة 47$et510$, $e510$مع عدم الإخلال بالأحكام الواردة في هذا الفصل، تسرى على رخص مركبات النقل البطيء أحكام المواد 10 و12 و13 و14 و15 و16 و17 و18 و19 و20 و21 و22 و23 و24 و27 و28 فقرة أولى وثانية و31 و32 و33 من هذا القانون.$e510$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins51;

WITH ins52 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 48, 0, $eh520$الباب الثالث: رخص تسيير وقيادة مركبات النقل البطىء - الفصل الثانى: رخص قيادة مركبات النقل البطىء$eh520$, $et520$مادة 48$et520$, $e520$أنواع رخص قيادة مركبات النقل البطيء هي:

(1) رخصة قيادة عربة ركوب أو عربة نقل موتى.

(2) رخصة قيادة عربة نقل.

(3) رخصة قيادة دراجة نقل.

ويشترط في طالب الترخيص أن تتوافر فيه الشروط الآتية:

(1) ألا تقل سنه عن 18 سنة ميلادية.

(2) لياقته صحيا للقيادة من حيث سلامة البنية والنظر والخلو من العاهات التي تعجزه عن القيادة.

(3) اجتياز اختبار فني في قيادة النوع الذى يطلب الترخيص له بقيادته وفي قواعد المرور وآدابه.

(4) ألا يكون قد سبق الحكم عليه في جريمة مخلة بالشرف أو الأمانة أو في إحدى جرائم المخدرات أو ما لم تكن سنة على تنفيذ العقوبة أو سقوطها بمضى المدة أو من تاريخ الحكم إذا اقترن بوقف تنفيذ العقوبة، أو كان الحكم مشمولا بوقف التنفيذ لمن كانت مهنته القيادة.

ويحمل قائد عربات الركوب والنقل علامات معدنية مميزة يحددها بقرار منه وزير الداخلية ويحدد وسيلة تثبيتها ومكان وضعها وقيمة التأمين الذى يؤدى عنها بحيث لا يكون العلامة المذكورة ظاهرة وبياناتها واضحة.(17)

وفي جميع الأحوال لا يجوز الترخيص بتسيير دراجات الركوب أو عربات اليد إلا بعد التحقق من قدرة المرخص له على قيادة المركبة وإلمامه بقواعد المرور وآدابه.$e520$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins52;

WITH ins53 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 49, 0, $eh530$الفصل الثانى: رخص قيادة مركبات النقل البطىء$eh530$, $et530$مادة 49$et530$, $e530$تسري رخصة القيادة لمدة خمس سنوات من تاريخ صرفها. وفيما عدا الأحكام الواردة بهذا الفصل تسري على رخص قيادة مركبات النقل البطيء أحكام المواد 36 و38 و41 و42 من هذا القانون، وفي جميع الأحوال التي يجوز فيها إلغاء ترخيص القيادة لمخالفة أحكام هذا القانون أو سحبه أو وقفه، تلغى بالنسبة لدراجات الركوب وعربات اليد رخصة المركبة ذاتها أو تسحب أو توقف لذات المدة المقررة.$e530$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins53;

WITH ins54 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 50, 0, $eh540$الفصل الثانى: رخص قيادة مركبات النقل البطىء$eh540$, $et540$مادة 50$et540$, $e540$لا يجوز قيادة دراجات الركوب في الطرق العامة لمن تقل سنه عن ثمانى سنوات ميلادية ويكون متولى شئون الصغير مسئولا عما يحدث عن ذلك من أضرار.

ولا يجوز لمؤجرى هذه الدراجات وعمالهم تأجيرها لهم وإلا كانوا مسئولين عما يحدث عن ذلك من أضرار للغير وللصغير نفسه.

ولا يجوز مزاولة مهنة مؤجر الدراجات للغير إلا بعد الحصول على ترخيص بذلك ويحدد المحافظ المختص شروط الترخيص والجهة التي تتولاه والشروط التي يجب أن تتوافر في الدراجات المؤجرة الصلاحية المتطلبة في الدراجات المركوب.(12)$e540$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins54;

WITH ins55 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 51, 0, $eh550$الباب الرابع: فى الضرائب والرسوم$eh550$, $et550$مادة 51$et550$, $e550$تفرض على تراخيص تسيير المركبات وتراخيص القيادة الضرائب والرسوم المحددة بالجدول المرافق لهذا القانون، وتؤدى مقدما وكاملة.

ومع ذلك يجوز أداؤها مقدما على أقساط لا تقل مدة كل قسط عن ثلاثة أشهر بالنسبة لرخص تسيير سيارات النقل والنقل المشترك غير الزراعية، وسيارات نقل الركاب عدا المخصصة لنقل الطلبة.

وتسري المدة المؤداة عنها الضريبة من تاريخ صرف اللوحات المعدنية بالنسبة للمركبات، وبالنسبة لرخص القيادة من تاريخ صرفها.$e550$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins55;

WITH ins56 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 51, 1, $eh560$الباب الرابع: فى الضرائب والرسوم$eh560$, $et560$مادة 51 مكررا$et560$, $e560$يفرض رسم تحدد فئاته بجدول الرسوم والضرائب الملحق بقانون المرور عن كل عام للترخيص بتسيير المركبات من قسم المرور المختص، يخصص لإنشاء وتطوير منظومة النقل الإلكترونية لإدارة الحركة على الطرق بما يحقق السيولة المرورية، ويوفر وسائل الأمان للأشخاص والأشياء، ويحكم السيطرة على منافذ تحصيل الرسوم.

وتحدد فئات هذا الرسم بالجدول المرفق، على ألا يزداد سنويا بنسبة (6%) من أصل قيمة الرسم المفروض، بما لا يجاوز ثلاثة أضعاف الرسم، ولا تسري على هذا الرسم أحكام الإعفاء من سداد الضرائب والرسوم المقررة بموجب هذا القانون أو غيره من القوانين، عدا رسم (جمرك) الوارد بالبند الفرعى رقم (4) من البند «ثانيا: رسوم إنشاء وتطوير منظومة النقل الذكى» بجدول الرسوم والضرائب الملحق بقانون المرور بالنسبة لسيارات النقل الأجنبية بشرط المعاملة بالمثل، وفي حدود تلك المعاملة.(61)

وتنول حصيلة الرسم المشار إليه لصالح تمويل إنشاء وتطوير منظومة النقل الذكى.(60)$e560$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins56;

WITH ins57 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 52, 0, $eh570$الباب الرابع: فى الضرائب والرسوم$eh570$, $et570$مادة 52$et570$, $e570$يلتزم بأداء الضرائب والرسوم المقررة بهذا القانون المرخص له باسمه المركبة ومالكها، وكذلك من انتقلت إليه ملكيتها طالما لم يتم نقل القيد طبقا للمادة 19 من هذا القانون.$e570$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins57;

WITH ins58 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 53, 0, $eh580$الباب الرابع: فى الضرائب والرسوم$eh580$, $et580$مادة 53$et580$, $e580$إذا لم يقم المرخص له في المواعيد المبينة في المادة 22 من هذا القانون بأداء الضرائب والرسوم المستحقة عن المركبة ولم يرد اللوحات المعدنية، استحق على المركبة عن اليوم التالى من انقضاء تلك المواعيد الضرائب والرسوم المستحقة عن سنة كاملة وعن كل قسط واحد لا يقل عن ثلاثة أشهر التي يجوز تقسيطها بشأنها للمركبات، ويفرض عليها ضريبة إضافية مقدارها ثلث الضريبة السنوية المستحقة عنها.

فإذا طلب المرخص له إعادة الترخيص بالمركبة خلال المدة التي دفعت عنها الضريبة الأصلية والإضافية استفاد بباقي المدة سواء كانت اللوحات المعدنية سحبت أم لم تسحب.

أما إذا طلب إعادة الترخيص بعد فوات ميعاد التجديد اتبعت إجراءات الترخيص الجديد، وذلك بعد أداء الضرائب والرسوم المستحقة من تاريخ انتهاء الترخيص مضافا إليها ضريبة إضافية مقدارها ثلث الضريبة السنوية المستحقة بحد أقصى خمس سنوات.(28)$e580$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins58;

WITH ins59 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 54, 0, $eh590$الباب الرابع: فى الضرائب والرسوم$eh590$, $et590$مادة 54$et590$, $e590$في حالة تسيير أية مركبة في الطريق بدون ترخيص تضبط إداريا ويستحق عنها الضريبة السنوية كاملة، وذلك من تاريخ شرائها أو إدخالها إلى البلاد إلى اليوم التالى من انتهاء الضريبة السابقة لانتهاء تلك المدة بحسب الأحوال، كما تستحق عنها ضريبة إضافية مقدارها ثلث الضريبة السنوية من تاريخ انتهاء الترخيص وبحد أقصى خمس سنوات عن كل من الضريبة الأصلية والضريبة الإضافية.

وإذا لم يتمكن مالك المركبة من إثبات تاريخ إدخالها للبلاد أو تاريخ شرائها، تستحق عنها الضريبة كاملة عن سنة الصنع حتى تاريخ الضبط بحد أقصى خمس سنوات، كما تستحق عنها فضلا عن ذلك الضريبة الإضافية المنصوص عليها في الفقرة السابقة.

فإذا رخص بعد ذلك للمرخص له كان للمنتفع من الباقى من المدة المؤداة عنها الضريبة وتطبق على قائد المركبة أحكام المادة (14) من هذا القانون.(25)$e590$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins59;

WITH ins60 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 55, 0, $eh600$الباب الرابع: فى الضرائب والرسوم$eh600$, $et600$مادة 55$et600$, $e600$إذا أدى التغيير المشار إليه في المادة 17 من هذا القانون إلى زيادة الضرائب والرسوم التي تستحق عن المركبة، استحق الفرق من تاريخ الإخطار بالتغيير إلى نهاية المدة المؤداة عنها الضريبة.

فإذا لم تتم الإجراءات المبينة في المادة المذكورة استحق ضريبة كاملة باعتبارها مدة ترخيص كاملة، واستحقت ضريبة إضافية قيمتها ثلث الضريبة السنوية المستحقة عن التغيير سنويا أو ثلث الضريبة السنوية المستحقة عن ثلاثة أشهر بالنسبة للمركبات التي يجوز التقسيط بشأنها.(34)$e600$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins60;

WITH ins61 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 56, 0, $eh610$الباب الرابع: فى الضرائب والرسوم$eh610$, $et610$مادة 56$et610$, $e610$للمرخص له إذا استغنى عن تسيير المركبة وقام برد الرخصة واللوحات المعدنية إلى قسم المرور المختص أن يسترد جزءا من الضريبة المؤداة عن المركبة يناسب المدة الباقية من المدة الضريبة المؤداة عنها وتسقط من حساب المدة التي تسترد عنها الضريبة أجزاء الشهر.$e610$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins61;

WITH ins62 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 57, 0, $eh620$الباب الرابع: فى الضرائب والرسوم$eh620$, $et620$مادة 57$et620$, $e620$تعفى من الضرائب والرسوم المقررة بهذا القانون:

(1) المركبات المملوكة للحكومة وللمجالس المحلية وللهيئات العامة، التي لا تستغل لقاء أجر.

(2) مركبات الهيئات الدبلوماسية والقنصلية العربية أو الأجنبية والمركبات المملوكة لموظفيها العرب أو الأجانب وعائلاتهم في الحدود التي يقررها وزير الداخلية بالاتفاق مع وزير الخارجية وبشرط المعاملة بالمثل.

(3) مركبات الهيئات الدولية والوكالات التابعة لها والهيئات العربية أو الأجنبية وموظفيها العرب أو الأجانب التي يقرر لها الإعفاء بمقتضى اتفاقيات دولية نافذة في البلاد.

(4) المركبات المملوكة لجامعة الدول العربية وفروعها والمندوبين المعتمدين لديها وموظفيها طبقا للاتفاقات المبرمة بشأنها والنافذة في البلاد.

(5) المركبات المملوكة للبعثات الخيرية والهيئات العربية أو الأجنبية، ولبعض الشخصيات العربية أو الأجنبية التي يقرر إعفاءها بناء على طلب وزير الخارجية.

(6) مركبات الاسعاف المعدة لأغراض الإسعافات العامة.

(7) مركبات الجمعيات الخيرية التي يصدر بتحديدها قرار من المحافظ المختص بالاتفاق مع مديريات الشئون الاجتماعية بالمحافظة.(13)

(8) مركبات جمعيات الرفق بالحيوان المعدة لنقل الحيوانات المريضة أو المصابة.

(9) المركبات المصممة ليقودها ذوو العاهات والتي يتولون قيادتها بأنفسهم.

(10) الجرارات الزراعية والآلات الملحقة بها المخصصة لخدمة الإنتاج الزراعى.

(11) المركبات المملوكة للعابرين والسائحين المرخص بتسييرها في الدول التي يقيمون فيها ذلك لمدة تسعين يوما فقط من يوم دخولها البلاد متى كان مؤمنا عن حوادثها الناشئة من المسئولية المدنية أثناء وجودها بالبلاد.

ويجوز الترخيص بها بعد انقضاء هذه المدة بعد أداء الضرائب والرسوم عنها، ويجوز أداء الضريبة على أقساط لا تقل مدة كل قسط عن ثلاثة أشهر إذا ما تقدم المالك لذلك ويسرى ذلك على المدة المذكورة.

فإذا ضبطت مسيرة بعد انقضاء مدة التسعين يوما دون ترخيص عليها فرض ضريبة إضافية تعادل ثلث الضريبة السنوية المستحقة عنها أشهر، وللمالك أن يستفيد من باقي المدة المؤداة عنها الضريبة والرسوم متى طلب الترخيص بالمركبة.(34)$e620$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins62;

WITH ins63 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 58, 0, $eh630$الباب الرابع: فى الضرائب والرسوم$eh630$, $et630$مادة 58$et630$, $e630$يعفى من رسوم رخص القيادة الخاصة، أعضاء السلكين الدبلوماسى والقنصلى والأجنبيين والعاملون العرب والأجانب بالسفارات والقنصليات العربية أو الأجنبية وعائلاتهم بشرط المعاملة بالمثل، كما يعفى أعضاء الهيئات الدولية العربية أو الأجنبية وعائلاتهم الذين يقرر الداخلية إعفاءهم بناء على طلب وزير الخارجية.$e630$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins63;

WITH ins64 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 58, 1, $eh640$الباب الرابع: فى الضرائب والرسوم$eh640$, $et640$مادة 58 مكررا$et640$, $e640$يعفي ذوو العاهات من رسوم رخص القيادة الخاصة.(30)$e640$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins64;

WITH ins65 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 59, 0, $eh650$الباب الرابع: فى الضرائب والرسوم$eh650$, $et650$مادة 59$et650$, $e650$يجوز لكل صاحب شأن أن يسترد ما دفعه من ضرائب ورسوم طبقا لهذا القانون إذا تبين أنها غير مستحقة كلها أو بعضها، متى قدم بذلك طلبا إلى قسم المرور المختص خلال ثلاثة أشهر من الدفع مصحوبا بما يؤيده من الأوراق وإيصال ما أداه من ضرائب ورسوم، وإلا سقط حقه في الاسترداد.

ويجوز أن يرسل الطلب بكتاب موصى عليه مصحوب بعلم وصول متى أرسل في الميعاد.$e650$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins65;

WITH ins66 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 60, 0, $eh660$الباب الرابع: فى الضرائب والرسوم$eh660$, $et660$مادة 60$et660$, $e660$عند عدم الوفاء بالضرائب الأصلية والإضافية والرسوم والغرامات المالية المحكوم بها لمخالفة أحكامه، تحصل بطريق الحجز الإدارى على المركبة المستحقة عنها طبقا للقانون الخاص بذلك.

فإذا لم يعثر على المركبة أو لم يف الببيع ناتج البيع بالمبالغ المطلوبة جاز تحصيلها على التنفيذ على أموال المدين الأخرى طبقا للقانون.

ويسرى ذلك بالنسبة للغرامات المحكوم بها على المرخص له بقيادة المركبة طبقا لهذا القانون.$e660$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins66;

WITH ins67 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 61, 0, $eh670$الباب الرابع: فى الضرائب والرسوم$eh670$, $et670$مادة 61$et670$, $e670$كل مركبة تستدعى للعمل طبقا لأحكام القانون الخاص بالتعبئة العامة يوقف سريان رخصتها من تاريخ وضعها تحت تصرف السلطة المختصة ويعفى مالكها من إجراءات التجديد وأداء الضرائب والرسوم المقررة إذا حلت مواعيد استحقاقها خلال مدة الاستدعاء.

فإذا رغب في تسييرها بعد إعادتها فله أن يستفيد من الضرائب والرسوم المؤداة لمدة مماثلة للمدة التي كانت الرخصة موقوفة خلالها.

أما إذا استغنى عن تسييرها فله استرداد الضرائب التي أداها عن مدة وقف سريان الرخصة بحيث لا تقل عن ثلاثين يوما، إذا ما طلب ذلك خلال تسعين يوما من تاريخ إعادة المركبة إليه وإلا سقط حقه في الاسترداد، وتسقط من حساب المدة التي تسترد عنها الضريبة أجزاء الشهر.$e670$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins67;

WITH ins68 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 62, 0, $eh680$الباب الرابع: فى الضرائب والرسوم$eh680$, $et680$مادة 62$et680$, $e680$كل مركبة يستولى عليها لأحكام قانون التعبئة العامة تلغى رخصتها من تاريخ الاستيلاء عليها ولمالك المركبة أن يطلب استرداد ما أداه من ضرائب عن المدة الباقية من الترخيص بحيث لا تقل عن شهر إذا ما طلب ذلك خلال ثلاثة أشهر من تاريخ الاستيلاء على المركبة وألا سقط حقه في الاسترداد، وتسقط من حساب المدة التي تسترد عنها الضريبة أجزاء الشهر.$e680$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins68;

WITH ins69 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 63, 0, $eh690$الباب الخامس: قواعد المرور وآدابه$eh690$, $et690$مادة 63$et690$, $e690$على المشاة وقائدي المركبات التزام قواعد المرور وآدابه واتباع إشارات المرور وعلاماته وتعليماته وتعليمات رجال المرور والشرطة.

ويصدر وزير الداخلية القرارات اللازمة لبيان قواعد المرور وآدابه وإشاراته وعلاماته كما يضع الحدين الأقصى والأدنى لسرعة المركبات عند الحاجة.

وللمحافظ عند الاقتضاء أن يحدد السرعة في المناطق التي يعينها داخل حدود المحافظة.$e690$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins69;

WITH ins70 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 64, 0, $eh700$الباب الخامس: قواعد المرور وآدابه$eh700$, $et700$مادة 64$et700$, $e700$لقسم المرور المختص تنظيم وتحديد أماكن لافتات الإعلان وإشارات المرور الضوئية وعلامات المرور الدولية وله ذلك أن يحدد الجهات والأوقات التي يمنع فيها سير أنواع معينة من المركبات أو يمنع فيها أو يمنع المشاة سير فيها أو أوقاف المركبات، كما ينظم أماكن انتظار ووقوف المركبات وإصدار التعليمات اللازمة لانتظام حركة المرور وتأمين سلامتها وسلامة الركاب والمشاة والمركبات، وذلك كله بعد أخذ رأى المجالس المحلية المختصة.

وتتولى هيئة السكك الحديدية بالاشتراك مع قسم المرور المختص تنظيم ووضع الحواجز والإشارات وآلات التنبيه اللازمة عند تقاطع الطرق مع الخطوط الحديدية.

ولقسم المرور المختص عند الضرورة تعديل خط وموعاد سير سيارات النقل العام للركاب وله اتخاذ ما يراه لازما لصالح المرور أو الأمن العام أو الصحة العامة بالنسبة لجميع مستعملى الطرق العامة.$e700$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins70;

WITH ins71 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 64, 1, $eh710$الباب الخامس: قواعد المرور وآدابه$eh710$, $et710$مادة 64 مكررا$et710$, $e710$مع عدم الإخلال بأحكام المادتين (28) و(64) من هذا القانون، يجوز بقرار من رئيس مجلس الوزراء تحديد وتنظيم أو منع سير نوع معين من أنواع المركبات في أوقات وأماكن محددة.(59)$e710$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins71;

WITH ins72 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 0, $eh720$الباب الخامس: قواعد المرور وآدابه$eh720$, $et720$مادة 65 (فقرة أولى مستبدلة بالقانون 17/2024)$et720$, $e720$لا يجوز ترك المركبات المهملة أو المتروكة فى الطريق العام أو أنقاض المركبات فى حالة ينجم عنها تعريض حياة الغير للخطر أو أمواله أو تعطيل حركة المرور أو إعاقتها.(النص المستبدل بالقانون رقم 17 لسنة 2024)

وعلى الهيئات والمؤسسات والشركات من عامة وخاصة وغيرها من الأشخاص الاعتبارية وعلى المقاولين وغيرهم إخطار قسم المرور المختص قبل الشروع في إجراء أى إنشاءات أو عمليات حفر أو تعبيد بالطرق العامة، ووضع لوحات للتحذير وعلامات حمراء نهارا ومصابيح تشع ضوءا أحمر ليلا لا تحدد من بعد لا يقل عن مائة متر عن أماكن وجود العمليات والإنشاءات بالطرق.

ولرجال المرور والشرطة اتخاذ أية إجراءات وقائية تكون لازمة، ولهم إزالة المخالفة على نفقة المتسبب بالطريق الإدارى.

ومع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب المتسبب بالحبس مدة لا تزيد على ستة أشهر وبغرامة لا تقل عن ألف جنيه ولا تزيد على ألفي جنيه أو بإحدى هاتين العقوبتين.(3)$e720$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins72;

WITH ins73 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 1, $eh730$الباب الخامس: قواعد المرور وآدابه$eh730$, $et730$مادة 65 مكررا$et730$, $e730$يرخص لضباط المرور المختصين، بتقييد المركبات حال توقفها أو انتظارها في الأماكن المحظور الوقوف فيها، بصورة تعوق إنسياب حركة المرور، وذلك بوضع أقفال حديدية على إطاراتها لمنع حركتها، ولحين استكمال إجراءات سحبها وتحرير المخالفة اللازمة لها.

ويعاقب بالحبس لمدة لا تزيد على ستة أشهر وبغرامة لا تقل عن مائتى جنيه ولا تزيد على ألف جنيه، أو بإحدى هاتين العقوبتين كل من أزال أو فك أو احتفظ بأى من تلك الأقفال بالمخالفة لأحكام هذا القانون.(50)$e730$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins73;

WITH ins74 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 2, $eh740$الباب الخامس: قواعد المرور وآدابه$eh740$, $et740$مادة 65 مكررا 1 (مضافة بالقانون 17/2024)$et740$, $e740$يتولى قسم المرور المختص بالتنسيق مع المحافظة المختصة ووحدات الإدارة المحلية والأجهزة التابعة لهيئة المجتمعات العمرانية الجديدة بحسب الأحوال، رفع المركبات المهملة، أو المتروكة، أو أنقاض المركبات الموجودة في أى مكان بالطريق العام فور ضبطها، وإيداعها بالأماكن التي يصدر بتحديدها قرار من المحافظ أو رئيس الجهاز المختص بهيئة المجتمعات العمرانية الجديدة، بحسب الأحوال، وتكون تلك المركبات في حيازة المحافظة أو الجهاز المختص بالأماكن المحدد بها الإيداع.

ويحرر بضبط الواقعة محضر يثبت فيه أوصاف المركبة أو أنقاضها ومكان تواجدها، وساعة ضبطها واسم مالكها إذا كان معلوما ورقم اللوحات إذا كانت مثبتة عليها ورقمي القاعدة والمحرك، وسبب الرفع، ومكان الإيداع وتاريخه، وسائر الظروف المحيطة بواقعة الضبط، وتعرض على نيابة المرور المختصة لاتخاذ شئونها.

وتتولى نيابة المرور المختصة إعلان مالك المركبة أو أنقاضها أو المسئول عن إدارتها، متى كان معلوما بمحضر الضبط خلال ثمانية وأربعين ساعة من تاريخ الضبط.(مُضافة بالقانون رقم 17 لسنة 2024)$e740$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins74;

WITH ins75 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 3, $eh750$الباب الخامس: قواعد المرور وآدابه$eh750$, $et750$مادة 65 مكررا 2 (مضافة بالقانون 17/2024)$et750$, $e750$لمالك المركبة المضبوطة أو أنقاضها أو المسئول عن إدارتها، التقدم إلى نيابة المرور المختصة لاستلامها خلال ستين يوما من تاريخ إعلانه بطلب يقدم إليها مشفوعا بسند الملكية وإيصالات سداد جميع نفقات الرفع والإيداع والإيواء المستحقة، وتسلم النيابة المختصة المركبة أو أنقاضها ما لم يوجد مانع قانوني على ألا تؤول حصيلة تلك النفقات إلى الخزانة العامة.

ولمالك المركبة أو أنقاضها، التنازل عنها لصالح المحافظة أو الجهاز المختص التابع بهيئة المجتمعات العمرانية الجديدة، بحسب الأحوال، خلال ستين يوما من تاريخ إعلانه، ويعفى المالك فى هذه الحالة من سداد نفقات الرفع والإيداع والإيواء.(مُضافة بالقانون رقم 17 لسنة 2024)$e750$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins75;

WITH ins76 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 4, $eh760$الباب الخامس: قواعد المرور وآدابه$eh760$, $et760$مادة 65 مكررا 3 (مضافة بالقانون 17/2024)$et760$, $e760$إذا لم يتقدم مالك المركبة المضبوطة أو أنقاضها أو المسئول عن إدارتها بطلب استلامها خلال ستين يوما من تاريخ إعلانه على النحو المبين بالمادة (65 مكررا 2) من هذا القانون، وتحقق بشأن تلك المركبات أو أنقاضها وصف الشيء المتروك وفقا لحكم الفقرة الأولى من المادة 871 من القانون المدنى، يجوز بيع المركبة أو أنقاضها عملا بأحكام المادتين 76، 78 من قانون تنظيم التعاقدات العامة الجهات الصادر بالقانون رقم 182 لسنة 2018، وذلك عن طريق لجنة محلية تسمى (لجنة التصرف في المركبات المتروكة والمهملة) تنشأ بكل محافظة تابعة لأحد الأجهزة التابعة لهيئة المجتمعات العمرانية الجديدة برئاسة المحافظ أو رئيس الجهاز المختص، أو من ينيبه، ومن بين عضويتها ممثلين عن الوزارات والجهات المعنية، ويصدر بتشكيل تلك اللجان وتحديد اختصاصاتها ونظام عملها قرار من رئيس مجلس الوزراء.

وتودع حصيلة البيع بالخزانة العامة، وإذا لم تف قيمة المبيع لتغطية الضرائب والرسوم وجميع نفقات الرفع والإيداع والإيواء التي تكبدتها الدولة، يتم تحصيل الفارق ممن كان مالكا للمركبة أو مسئولا عن إدارتها، إذا كان معلوما بالطرق المقررة قانونا، ويجوز تحصيله بطريق الحجز الإدارى وفقا لأحكام القانون المنظم لذلك.(مُضافة بالقانون رقم 17 لسنة 2024)$e760$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins76;

WITH ins77 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 5, $eh770$الباب الخامس: قواعد المرور وآدابه$eh770$, $et770$مادة 65 مكررا 4 (مضافة بالقانون 17/2024)$et770$, $e770$تخصص نسبة (15%) من الإيراد المحقق من بيع المركبات المهملة أو المتروكة أو أنقاض المركبات وفقا لأحكام هذا القانون كحافز لصالح القائمين على هذه الإجراءات، يصدر بها قرار من وزير المالية بالتنسيق مع الوزير المختص بشئون التنمية المحلية.(مُضافة بالقانون رقم 17 لسنة 2024)$e770$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins77;

WITH ins78 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 66, 0, $eh780$الباب الخامس: قواعد المرور وآدابه$eh780$, $et780$مادة 66$et780$, $e780$تحظر قيادة أية مركبة على من كان واقعا تحت تأثير خمر أو مخدر. ولمأموري الضبط القضائي عند التلبس بمخالفة الفقرة الأولى من هذه المادة في إحدى الحالات المنصوص عليها في المادة (30) من قانون الإجراءات الجنائية أن يأمر بفحص حالة قائد المركبة الفنية بالوسائل التي يحددها وزير الداخلية بالاتفاق مع وزير الصحة، وذلك دون الإخلال باتخاذ ما يراه وفقا للقانون.(36)$e780$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins78;

WITH ins79 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 67, 0, $eh790$الباب الخامس: قواعد المرور وآدابه$eh790$, $et790$مادة 67$et790$, $e790$على قائد أية مركبة وقع منه حادث نشأت عنه إصابات للأشخاص أن يهتم بإبلاغ أقرب رجل مرور أو شرطة أو إسعاف فورا بالحادث ووقوعه، وعليه عند ضرورة نقل المصاب إلى أقرب مكان لإسعافه.$e790$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins79;

WITH ins80 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 68, 0, $eh800$الباب الخامس: قواعد المرور وآدابه$eh800$, $et800$مادة 68$et800$, $e800$على قائد أية مركبة أو المرخصة باسمه أو حائزها أو المسئول عنها أن يرشد من طلب منه رجال الشرطة والمرور عن اسم وعنوان من كان يقود المركبة في وقت معين.$e800$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins80;

WITH ins81 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 0, $eh810$الباب الخامس: قواعد المرور وآدابه$eh810$, $et810$مادة 69$et810$, $e810$لا يجوز تركيب أجهزة تنبيه أو مصابيح تنبيه بالمركبة بالمخالفة لأحكام هذا القانون أو القرارات المنفذة له، كما لا يجوز تركيب سيرينة هوائية أو أجهزة أو ما يماثلها وإلا جاز ضبطها في جميع الأحوال والحكم بمصادرتها.$e810$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins81;

WITH ins82 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 1, $eh820$الباب الخامس: قواعد المرور وآدابه$eh820$, $et820$مادة 69 مكررا$et820$, $e820$لا يجوز استعمال المركبات في وضع الإعلان لافتات أو نماذج مجسمة أو غير ذلك من الوسائل إلا بترخيص من قسم المرور المختص وفقا للقواعد والإجراءات التي تبينها اللائحة التنفيذية لهذا القانون، ويقدم المعلن طلب الترخيص إلى قسم المرور المختص مرفقا به النموذج المعد لذلك بالمستندات التي تحددها اللائحة التنفيذية لهذا القانون، ويصدر الترخيص لمدة لا تجاوز ثلاث سنوات قابلة للتجديد، وبعد سداد رسم لا يجاوز عشرة آلاف جنيه تحدد فئاته باللائحة التنفيذية لهذا القانون، يسدد نقدا أو بأى وسيلة من وسائل الدفع الإلكترونى المحددة قانونا، وينول ما يعادل نسبة (20%) من حصيلة هذا الرسم إلى الخزانة العامة للدولة، ونسبة (10%) إلى الوزارة المختصة بشئون التنمية المحلية، وينول الباقى إلى وزارة الداخلية.(62)$e820$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins82;

WITH ins83 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 2, $eh830$الباب الخامس: قواعد المرور وآدابه$eh830$, $et830$مادة 69 مكررا 1$et830$, $e830$يقصد بالمعلن في تطبيق أحكام المادة (69 مكررا) من هذا القانون ما يأتى:

1 – الشركات المعتمدة من وزارة الداخلية العاملة في مجال الدعاية والإعلان أو التي تكون الدعاية والإعلان من أنشطتها، ويشترط أن تتخذ شكل شركة مساهمة ولا يقل رأسمالها المصدر عن ثلاثين مليون جنيه مصرى، وتحدد اللائحة التنفيذية لهذا القانون التزامات هذه الشركات والقواعد التي تتبعها في استصدار تراخيص الإعلان للغير.

2 – الشركات والمصانع والمحال التجارية وغيرها من الأشخاص الاعتبارية، بالنسبة للإعلانات المباشرة على وسائل النقل الخاصة بها متى كان الإعلان متعلقا بالاسم أو نوع العمل أو التجارة التي تزاولها.(62)$e830$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins83;

WITH ins84 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 3, $eh840$الباب الخامس: قواعد المرور وآدابه$eh840$, $et840$مادة 69 مكررا 2$et840$, $e840$تتولى الشركات المشار إليها بالمادة (69 مكررا 1/ بند 1) من هذا القانون، نيابة عن الأشخاص الطبيعية والاعتبارية مالكى المركبات الراغبين في وضع المواد الإعلانية عليها في المقيدين عليها سجلات تلك الشركات، تقديم طلبات الترخيص بوضع المواد الإعلانية على مركباتهم. ويجب أن يتضمن الترخيص بالإضافة إلى بيانات مالك المركبة المرخص له، اسم الشركة الإعلانية العاملة في مجال الدعاية والإعلان المعتمدة من وزارة الداخلية، ومدة الترخيص وتاريخ بدء سريانه، والبيانات الأخرى التي تحددها اللائحة التنفيذية لهذا القانون.$e840$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins84;

WITH ins85 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 4, $eh850$الباب الخامس: قواعد المرور وآدابه$eh850$, $et850$مادة 69 مكررا 3$et850$, $e850$يجوز لقسم المرور المختص إلغاء الترخيص وفقا لما تقتضيه اعتبارات تنظيم حركة المرور.(62)$e850$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins85;

WITH ins86 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 5, $eh860$الباب الخامس: قواعد المرور وآدابه$eh860$, $et860$مادة 69 مكررا 4$et860$, $e860$استثناء من حكم المادة (69 مكررا) من هذا القانون، لوزير الداخلية لاعتبارات يقتضيها الصالح العام وبقرار مسبب الإعفاء من سداد رسوم الترخيص، أو الإعفاء من كل أو بعض شروط وضوابط الترخيص المنصوص عليها في المواد (69 مكررا، 69 مكررا 1، 69 مكررا 2) من هذا القانون.(62)$e860$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins86;

WITH ins87 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 70, 0, $eh870$الباب الخامس: قواعد المرور وآدابه$eh870$, $et870$مادة 70$et870$, $e870$يعاقب بغرامة لا تقل عن ثلاثمائة جنيه ولا تزيد على خمسمائة جنيه كل سائق مركبة أجرة مرخصة بالعداد بدونه أو بدون تشغيل العداد، أو امتنع دون مبرر عن نقل الركاب، أو طلب أجرا أكثر من المقرر، أو نقل عددا من الركاب يزيد على الحد الأقصى المقرر، أو قام بنقل ركاب من غير مواقف الانتظار المخصصة لمركبات الأجرة الأجرة بدون عداد.(26)$e870$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins87;

WITH ins88 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 70, 1, $eh880$الباب الخامس: قواعد المرور وآدابه$eh880$, $et880$مادة 70 مكررا$et880$, $e880$يلتزم قائد مركبات النقل (سيارة نقل، سيارة نقل مشترك، سيارة نقل خفيف)، والنقل العام للركاب (أتوبيس، ترولى باص)، والميكروباص المخصص لنقل الركاب بأجر، بالسير أقصى يمين الطريق. كما يلتزم قائدو مركبات السياحة والرحلات، بالسير في المسار التالى لأقصى اليمين، وبالسرعة المحددة بقرار وزير الداخلية، وذلك سواء كان السير داخل المدن أم خارجها.

ويعاقب أى من تلك المركبات المخالف لمسار السير في تلك الطرق، أو المتجاوز للسرعة المحددة وفقا للفقرة السابقة، بغرامة لا تقل عن مائتى جنيه ولا تزيد على ألف جنيه.

وتضاعف الغرامة المالية عند العود ذاته الفعل خلال مدة أشهر ستة من تاريخ أشهر الحكم النهائى بالإدانة.(50)$e880$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins88;

WITH ins89 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 71, 0, $eh890$الباب الخامس: قواعد المرور وآدابه$eh890$, $et890$مادة 71$et890$, $e890$تسري على تسيير وقيادة مركبات المترو والترام أحكام المواد 1 و2 و35 و36 و37 و38 و41 و63 و65 فقرة أولى و66 و67 من هذا القانون.$e890$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins89;

WITH ins90 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 72, 0, $eh900$الباب السادس: العقوبات$eh900$, $et900$مادة 72$et900$, $e900$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب بالحبس مدة لا تزيد على ستة أشهر وبغرامة لا تقل عن ثلاثمائة جنيه ولا تزيد على خمسمائة جنيه أو بإحدى هاتين العقوبتين، كل من ضبط مرتكبا فعلا مخالفا للآداب في المركبة، ويعاقب قائد المركبة بذات العقوبة إذا سمح بارتكاب هذا الفعل في المركبة.

وفي حالة العود إلى الفعل ذاته خلال سنة من تاريخ ارتكابه، تضاعف مدة العقوبة السالبة للحرية والغرامة المالية.(44)$e900$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins90;

WITH ins91 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 72, 1, $eh910$الباب السادس: العقوبات$eh910$, $et910$مادة 72 مكررا$et910$, $e910$تسحب رخصة القيادة بقرار من مدير إدارة المرور المختص، لمدة لا تزيد على شهر في حالة ارتكاب المخالفات المنصوص عليها في البند (أ)، ولمدة لا تقل عن شهر ولا تزيد على ثلاثة أشهر في حالة ارتكاب المخالفات المنصوص عليها في البند (ب) عدا الفقرة (7) منه، ولمدة لا تقل عن ثلاثة أشهر ولا تزيد على ستة أشهر في حالة ارتكاب المخالفات المنصوص عليها في البند (ج).

وتسحب رخصة تسيير المركبة بقرار من مدير إدارة المرور المختص للمخالفات الواردة في الفقرتين (3، 4) من البند (أ) ولمدة لا تقل عن شهر ولا تزيد على ثلاثة أشهر على المخالفات المنصوص عليها في الفقرات (5، 6، 7) من البند (ب) ولمدة لا تقل عن ستة أشهر على المخالفات المنصوص عليها في الفقرات (1، 2، 3، 4) من البند (ج).

وفي حالة العود إلى الفعل ذاته خلال ستة أشهر تضاعف مدة سحب الرخصة، وفي حالة تكرار المخالفة بعد العود تلغى الرخصة ولا تجوز إعادة الترخيص قبل مضى ثلاث سنوات وبعد توافر الشروط الواجبة لمنح الترخيص ابتداء:

البند (أ):

1-مخالفة خط سير المركبات الأجرة المحدد بقرار من المحافظ المختص.

2-مخالفة سير مركبات الأجرة خارج المحافظة المرخصة بها بدون تصريح من إدارة المرور المختصة.

3-وجود خلل بالعداد، ولا يجوز إعادة تسيير المركبة إلا بعد تمام إصلاح العداد أو استبداله بغيره.

4-عدم توافر شروط الأمن والمتانة، ويجوز منح المركبة ترخيصا مؤقتا بالسير لمدة لا تزيد على سبعة أيام لاستيفاء شروط الأمن والمتانة. كما يجوز تمديدها مدة أخرى أربعة وعشرين ساعة إلى قسم المرور المختص لتسييرها ساعة لإعادة فحصها.

البند (ب):

1-السماح بوجود ركاب على أجزاء المركبة من الخارج.

2-استعمال الأنوار العالية المبهرة للبصر والمصابيح الكاشفة على وجه مخالف للمقرر في شأن استعمالها.

3-وقوف المركبة ليلا في الطرق وفي الأماكن غير المضاءة بدون إضاءة الأنوار الأمامية الصغيرة والأنوار الحمراء الخلفية أو عاكس الأنوار المقررة.

4-استعمال المركبة في مواكب خاصة أو تجمعات دون تصريح من الجهات المختصة.

5-عدم وجود المثلث العاكس للضوء في المركبة.

6-عدم وجود حقيبة الإسعافات الأولية في المركبة.

7-عدم وضع أو تثبيت الملصق المرورى الإلكترونى المنصرف للمركبة أو إتلافه أو إخفاؤه، أو نقله لمركبة أخرى، أو العبث به بما يفقده صلاحيته.(60)

البند (ج):

1-قيادة مركبة بلوحات معدنية غير منصرفة من إدارة المرور المختصة، أو غير ظاهرة بياناتها، أو غير واضحة، أو يصعب قراءتها من بعد مناسب.

2-قيادة مركبة ليلا بدون استعمال الأنوار الأمامية والأنوار الخلفية والأنوار المقررة، وذلك سواء كانت أنوارا غير مستعملة أو غير صالحة للاستعمال أو غير موجودة.

3-قيادة مركبة من مركبات السياحة، والنقل، ونصف مقطورة، والنقل بمقطورة قبل نفاذ حظر تسييرها، لا يوجد بها جهاز محدد السرعات.

4-قيادة إحدى أتوبيسات نقل الركاب (أتوبيسات عامة، ترولى باص، أتوبيسات مدارس، أتوبيسات سياحة، أتوبيسات رحلات) والنقل بنصف مقطورة، والنقل بمقطورة قبل نفاذ حظر تسييرها لا يوجد بها جهاز صالح للاستعمال لتسجيل المعلومات الخاصة بتحركات المركبة وتصرفات السائق وتخزينها فيه بطريقة نارية يستحيل التدخل اليدوى فيها.

5-قيادة مركبة تنقل مواد أو سلعا أو أدوات محظور تداولها قانونا أو صدر بشأن نقلها قرار من سلطة مختصة بحظر نقلها كله في الحدود التي يشملها الحظر.(18)$e910$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins91;

WITH ins92 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 72, 2, $eh920$الباب السادس: العقوبات$eh920$, $et920$مادة 72 مكررا 1 (ملغاة)$et920$, $e920$ملغاة.(52)$e920$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins92;

WITH ins93 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 72, 3, $eh930$الباب السادس: العقوبات$eh930$, $et930$مادة 72 مكررا 2$et930$, $e930$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب بغرامة لا تقل عن خمسمائة جنيه ولا تزيد على ألف وخمسمائة جنيه كل قائد مركبة تسبب في تلويث الطريق بإلقاء فضلات أو مخلفات أو أي أشياء أخرى، وكذلك كل من قاد مركبة تصدر أصواتا مزعجة، أو ينبعث منها دخان كثيف، أو عادم غير مطابق للشروط البيئية، أو رائحة كريهة، أو تسيل منها مواد قابلة للاشتعال، أو مضرة بالصحة العامة أو مؤثرة في صلاحية الطريق للمرور، أو يتساقط من حمولتها ما ينال من سلامة الطريق، أو يشكل خطرا أو إيذاء لمستعمليه، أو عدم إحكام ربط وتغطية الحمولة بصورة آمنة.

فإذا ارتكب قائد المركبة ذاته مرة ثانية خلال ثلاثة أشهر من تاريخ ارتكابه الفعل السابق، تضاعف الغرامة المشار إليها.

فإذا ارتكب الفعل ذاته مرة ثالثة خلال ستة أشهر من تاريخ ارتكاب الفعل الثانى، يعاقب بالغرامة المشار إليها في الفقرة السابقة، مع سحب رخصة قيادته لمدة عام.(45)$e930$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins93;

WITH ins94 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 73, 0, $eh940$الباب السادس: العقوبات$eh940$, $et940$مادة 73$et940$, $e940$في جميع الأحوال التي ينص فيها هذا القانون على سحب الرخص أو إيقافها أو إلغائها أو اعتبارها ملغاة، يصدر القرار بضبط الرخص من مدير إدارة المرور المختص أو من يندبه من مأموري الضبط القضائى من ضباط المرور المختصين فور عرض الأمر عليه عقب ضبط الواقعة.

ويتم عرض الرخصة في الحالة المنصوص عليها في الفقرة السابقة مع محضر الضبط على نائب مدير الأمن المختص ليقرر – بحسب الأحوال – إما إعادة الرخصة إلى صاحبها إذا لم يتبين له وجود مخالفة وإما بإيقاف الرخصة إذا لم يتبين له اعتبارها ملغاة على الوجه الذى يحدده القانون أو سحبها أو اعتبارها ملغاة على الوجه الذى يحدده القانون.

ولصاحب الشأن أن يتظلم من هذا الأمر خلال خمسة عشر يوما من تاريخ إبلاغه بالرفض أو مضى خمسة عشر يوما على تقديم التظلم دون البت فيه.$e940$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins94;

WITH ins95 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 73, 1, $eh950$الباب السادس: العقوبات$eh950$, $et950$مادة 73 مكررا$et950$, $e950$في جميع الأحوال التي ينص فيها هذا القانون على إلغاء رخصة القيادة، ومع عدم الإخلال بالتدابير المقررة بهذا القانون، لا يجوز منح رخصة قيادة جديدة إلا بعد توافر الشروط المقررة للترخيص وإعادة اجتياز الاختبار الفنى وقواعد المرور وآدابه واجتياز دورة تعليمية للقيادة تعقدها بأحد المعاهد المعتمدة لتعليم القيادة، كشرط لمنح الرخصة من جديد بذات درجتها.

ومع عدم الإخلال بأية عقوبة أشد في أى قانون آخر يعاقب بالحبس مدة لا تزيد على سنة وبغرامة لا تقل عن ألف جنيه ولا تزيد على خمسة آلاف جنيه، أو بإحدى هاتين العقوبتين كل من استخرج أو استخدم أكثر من رخصة قيادة، أو غير بطريقة غير مشروعة من حالة رخصته الأولى، وكذلك كل من اتفق أو ساعد أو ساهم بأية طريقة على استخراج رخصة قيادة بدلا من الرخصة المسحوبة، أو الملغاة على خلاف أحكام القانون.(47)$e950$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins95;

WITH ins96 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 0, $eh960$الباب السادس: العقوبات$eh960$, $et960$مادة 74 (بند 2 مستبدل بالقانون 17/2024)$et960$, $e960$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب بغرامة لا تقل عن خمسمائة جنيه ولا تزيد على ألف جنيه كل من ارتكب فعلا من الأفعال الآتية:

1- عدم الالتزام بالجانب الأيمن المعد للسير في نهر الطريق للسير في الاتجاهين، أو السير في مسار مخالف.

2- مخالفة أحكام المواد (7، 7 مكررا، 67، 68، 69) من هذا القانون.(النص المستبدل بالقانون رقم 17 لسنة 2024)

3- عدم اتباع قائد المركبة لإشارات المرور وعلاماته وتعليمات رجال المرور الخاصة بتنظيم السير.

4- مخالفة مركبة النقل لشروط وزن الحمولة أو ارتفاعها أو عرضها أو طولها.

وفي جميع الأحوال تضاعف عقوبة الغرامة المالية عند ارتكاب أى من الأفعال المشار إليها خلال أشهر ستة من تاريخ الحكم النهائى بالإدانة.(31)$e960$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins96;

WITH ins97 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 1, $eh970$الباب السادس: العقوبات$eh970$, $et970$مادة 74 مكررا$et970$, $e970$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب بغرامة لا تقل عن مائة جنيه ولا تزيد على ثلاثمائة جنيه كل من ارتكب فعلا من الأفعال الآتية:

1- قيادة مركبة نارية بسرعة تقل عن الحد الأدنى للسرعة المقررة للسير إذا ترتب عليها إعاقة حركة المرور بالطريق.

2- استعمال قائد المركبة النارية لها في الغرض المبين برخصتها.

3- عدم استخدام قائد السيارة أو من يركب بجواره حزام الأمان أثناء سيرها في الطريق، وذلك وفقا للقواعد والشروط التي تحددها اللائحة التنفيذية لهذا القانون، ويعاقب قائد السيارة بذات العقوبة إذا سمح بأن يركب بجواره أحد دون استخدامه حزام الأمان.

4- عدم استخدام قائد الدراجة النارية غطاء الرأس الواقى.

5- إستخدام التليفون يدويا أثناء القيادة.

6- عدم تثبيت اللوحات المعدنية للمركبة في المكان المقرر لها.

7- عدم تزويد المركبة بأجهزة الإطفاء الصالحة للاستعمال أو عدم جعلها في متناول قائد السيارة والركاب.

8- عدم تزويد المركبة بالمثلث العاكس للضوء.

9- عدم تزويد المركبة بحقيبة الإسعافات الأولية.

10- عدم حمل مركبة النقل البطيء للوحة المعدنية المنصرفة لها أو استعمالها لوحة معدنية لغير المركبة المنصرفة لها أو تغيير بيانات أو لون اللوحة المعدنية.

11- إضافة ملصقات أو معلقات أو وضع أية كتابة أو رسم أو رموز أو أية بيانات أخرى غير تلك الواجبة بحكم القانون واللوائح على جسم المركبة أو أى جزء من أجزائها، أو لوحاتها المعدنية.

وفي جميع الأحوال تضاعف عقوبة الغرامة المالية عند ارتكاب أى من الأفعال المشار إليها خلال أشهر ستة من تاريخ الحكم النهائى بالإدانة.(29)$e970$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins97;

WITH ins98 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 2, $eh980$الباب السادس: العقوبات$eh980$, $et980$مادة 74 مكررا 1$et980$, $e980$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب بغرامة لا تقل عن مائة جنيه ولا تزيد على ألف جنيه، كل من:

1- استعمل جهاز تنبيه بالمركبة في غير تنبيه لمركبة، أو لحيوان، أو لشخص، لمنع ضرر جسيم، محدق، قد يلحق بأى منها.

2- كل قائد مركبة لا يغلق متعمدا مركبته أبوابها كاملا، أثناء السير بها.

3- كل قائد مركبة يتعمد التوقف أو السير ببطء شديد على الكبارى، عند مطالعها أو منازلها، أو في الأنفاق، أو في مداخلها أو مخارجها، أو مخارجها أو في تقاطع الطرق.

وفي جميع الأحوال تضاعف عقوبة الغرامة المالية عند العود لارتكاب أى من الأفعال المشار إليها خلال أشهر ستة من تاريخ الحكم النهائى بالإدانة.(50)$e980$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins98;

WITH ins99 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 3, $eh990$الباب السادس: العقوبات$eh990$, $et990$مادة 74 مكررا 2 (مستبدلة بالقانون 17/2024)$et990$, $e990$مع عدم الإخلال بحقوق الغير حسن النية، تقضى المحكمة فضلا عن العقوبات المنصوص عليها في هذا القانون بمصادرة مركبات الدراجات النارية والتوك توك والمركبات الخفيفة حال تسييرها دون ترخيص أو عدم حمل هذه المركبات المعدنية المنصرفة لها أو استعمال لوحات معدنية غير خاصة بها.(النص المستبدل بالقانون رقم 17 لسنة 2024)$e990$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins99;

WITH ins100 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 4, $eh1000$الباب السادس: العقوبات$eh1000$, $et1000$مادة 74 مكررا 3$et1000$, $e1000$يعاقب بالحبس لمدة لا تزيد على ستة أشهر وبغرامة لا تقل عن ألف جنيه ولا تزيد على ألفي جنيه أو بإحدى هاتين العقوبتين كل من قاد مركبة دون الحصول على رخصة تسيير.(57)$e1000$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins100;

WITH ins101 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 5, $eh1010$الباب السادس: العقوبات$eh1010$, $et1010$مادة 74 مكررا 4$et1010$, $e1010$يعاقب بالحبس لمدة لا تزيد على ستة أشهر وبغرامة لا تقل عن ألف جنيه ولا تزيد على ألفي جنيه كل من قاد مركبة دون الحصول على رخصة قيادة تجيز له ذلك ومخالفة أحكام المادة (42) من هذا القانون، وفي حالة العود خلال سنة من ارتكاب الفعل تضاعف العقوبة.(59)$e1010$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins101;

WITH ins102 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 6, $eh1020$الباب السادس: العقوبات$eh1020$, $et1020$مادة 74 مكررا 5$et1020$, $e1020$يعاقب بغرامة لا تقل عن ألف جنيه ولا تزيد على ثلاثة آلاف جنيه كل قائد مركبة بالمخالفة لأحكام المادة (64) مكررا.(59)$e1020$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins102;

WITH ins103 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 7, $eh1030$الباب السادس: العقوبات$eh1030$, $et1030$مادة 74 مكررا 6$et1030$, $e1030$يعاقب بغرامة لا تجاوز خمسة آلاف جنيه كل من وضع إعلانا أو تسبب في وضعه بالمخالفة للمادة (69 مكررا 1) من هذا القانون، وتتعدد العقوبات بتعدد المخالفات، ولرجال المرور والشرطة اتخاذ الإجراءات الوقائية اللازمة، ولهم إزالة المتسبب في المخالفة بالطريق الإدارى.(62)$e1030$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins103;

WITH ins104 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 75, 0, $eh1040$الباب السادس: العقوبات$eh1040$, $et1040$مادة 75$et1040$, $e1040$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب بالحبس مدة لا تقل عن أشهر ستة على تزيد وبغرامة لا تقل عن ثلاثمائة جنيه ولا تزيد على ألف وخمسمائة جنيه، أو بإحدى هاتين العقوبتين كل من أرتكب فعلا من الأفعال الآتية:

1-قيادة مركبة نارية بسرعة تجاوز الحد الأقصى للسرعة المقررة.

2-ملغى.

3-ملغى.

4-عدم حمل مركبة النقل السريع للوحات المعدنية المنصرفة لها أو استعمال لوحات معدنية غير خاصة بها.

5-قيادة مركبة نارية خالية من الفرامل بنوعيها أو كانت جميع فرامها أو إحداها غير صالحة للاستعمال.

6-تعمد إثبات بيانات غير صحيحة في النماذج المنصوص عليها في هذا القانون.

7-تعمد تعطيل حركة المرور بالطرق العامة أو إعاقتها.

8-ملغى.

9-تغيير بيانات أو لون اللوحات المعدنية المقرر لمركبات النقل السريع.

10-عدم استيفاء إجراءات الترخيص بإنشاء أو إدارة مدرسة لتعليم قيادة السيارات.

11-اعتداء قائد المركبة على أحد أفراد المرور أثناء أو بسبب تأدية وظيفته.

وفي جميع الأحوال تضاعف العقوبة السالبة للحرية وعقوبة الغرامة المالية عند ارتكاب أى من الأفعال المشار إليها خلال أشهر ستة من تاريخ الحكم النهائى بالإدانة.(32)

12-قيادة مركبة بالمخالفة لحكم البند (8) من المادة (11) من هذا القانون.(60)$e1040$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins104;

WITH ins105 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 75, 1, $eh1050$الباب السادس: العقوبات$eh1050$, $et1050$مادة 75 مكررا$et1050$, $e1050$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب بالحبس مدة لا تزيد على ستة أشهر وبغرامة لا تقل عن ألف وخمسمائة جنيه ولا تزيد على ثلاثة آلاف جنيه أو بإحدى هاتين العقوبتين كل من ارتكب فعلا من الأفعال الآتية:

1- قيادة مركبة بالمخالفة لحكم البند (4، 5) من المادة (11) وذلك بعدم تركيب جهاز محدد السرعة وجهاز تسجيل البيانات المحددة في المركبات المشار إليها فيها.

2- من حاز فيه جاز فيه أجهزة تكشف أو تنذر بمواقع أجهزة قياس سرعة المركبات أو تؤثر في عملها، كما يتم ضبط تلك الأجهزة وتقضى المحكمة بمصادرتها.

وتضاعف العقوبة السالبة للحرية، وعقوبة الغرامة المالية، عند العود إلى ارتكاب ذات الفعل خلال سنة من تاريخ الحكم النهائى بالإدانة.(22)$e1050$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins105;

WITH ins106 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 76, 0, $eh1060$الباب السادس: العقوبات$eh1060$, $et1060$مادة 76$et1060$, $e1060$مع عدم الإخلال بالتدابير المقررة في هذا القانون وبأية عقوبة أشد في أى قانون آخر يعاقب كل من قاد مركبة وهو تحت تأثير مخدر أو مسكر أو سائر في عكس الاتجاه في الطريق العام المدين خارجها بالحبس مدة لا تقل عن سنة عن سنة.

فإذا ترتب على القيادة تحت تأثير مخدر أو مسكر أو السير عكس الاتجاه إصابة شخص أو أكثر يعاقب بالحبس مدة لا تقل عن سنتين ولا تزيد عن غرامة لا تقل عن عشرة آلاف جنيه.

وإذا ترتب على ذلك وفاة شخص أو أكثر أو إصابته بعجز كلى يعاقب بالحبس مدة لا تقل عن ثلاث ولا تزيد على سبع سنوات وغرامة لا تقل عن عشرين ألف جنيه.

وفي جميع الأحوال يقضى بإلغاء رخصة القيادة ولا يجوز منح رخصة جديدة إلا بعد مرور مدة مساوية لمدة الحبس المقضى بها عليه.(58)$e1060$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins106;

WITH ins107 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 76, 1, $eh1070$الباب السادس: العقوبات$eh1070$, $et1070$مادة 76 مكررا$et1070$, $e1070$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب بالحبس ولا يزيد على ثلاثة آلاف جنيه ولا تزيد على ألف جنيه كل من تعمد السير عكس الاتجاه في الطريق العام داخل المدن أو خارجها، فإذا نجم عن ذلك السير المعاكس أو مخالفة إشارة المرور الخاصة بتنظيم السير، حدوث إصابة أو وفاة للغير تضاعف الغرامة المالية.(50)$e1070$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins107;

WITH ins108 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 77, 0, $eh1080$الباب السادس: العقوبات$eh1080$, $et1080$مادة 77$et1080$, $e1080$مع عدم الإخلال بالتدابير المقررة في هذا القانون أو بأية عقوبة أشد في أى قانون آخر، يعاقب على أية مخالفات أخرى واردة في هذا القانون والقرارات المنفذة له بغرامة لا تقل عن عشرين جنيها ولا تزيد على خمسين جنيها.(48)$e1080$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins108;

WITH ins109 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 78, 0, $eh1090$الباب السادس: العقوبات$eh1090$, $et1090$مادة 78$et1090$, $e1090$إذا حكم على قائد مركبة مرخص له بالقيادة لارتكابه فعلا معاقبا عليه بمقتضى المواد من 74 إلى 77 من هذا القانون، فللقاضي أن يأمر أن يضمن الحكم وقف سريان رخصة القيادة لمدة لا تجاوز سنة من اليوم التالى لتاريخ انتهاء تنفيذ العقوبة أو للإكراه البدنى أو من تاريخ الحكم إذا كان مقرونا بوقف التنفيذ.

وفي هذه الأحوال للقاضى أن يأمر بتعليق إعادة صرف الرخصة على قضاء المحكوم عليه المدة التي يحددها القاضى بإحدى مدارس أو مراكز تعليم القيادة المشار إليها في المادة 43 من هذا القانون.

وفي الأحوال التي توقف فيها الرخصة إداريا بناء على نص آخر في هذا القانون تحسب مدة الوقف الإدارى من المدة المحكوم بها خلالها.$e1090$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins109;

WITH ins110 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 79, 0, $eh1100$الباب السادس: العقوبات$eh1100$, $et1100$مادة 79 (ملغاة)$et1100$, $e1100$ملغاة.(37)$e1100$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins110;

WITH ins111 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 80, 0, $eh1110$الباب السادس: العقوبات$eh1110$, $et1110$مادة 80$et1110$, $e1110$استثناء من القواعد والإجراءات المنصوص عليها في المادة 18 مكررا من قانون الإجراءات الجنائية بشأن التصالح، يجوز للمخالف التصالح فورا في الجرائم المنصوص عليها في هذا القانون، عدا الجرائم الواردة (70، 73 مكررا)، والبند 6 من المادة (74)، والبنود (4، 5، 6، 7، 11) من المادة (75، 75 مكررا، 76، 76 مكررا)، أو خلال ثلاثة أيام عمل من تاريخ الضبط، وذلك مقابل دفع نصف الحد الأدنى للغرامة المقررة قانونا، يسدد لمأمور الضبط القضائى، أو في أحد مكاتب هيئة البريد، أو في أحد المنافذ التي تحددها اللائحة التنفيذية لهذا القانون، ويثبت ذلك في تقرير المخالفة.

كما يجوز للمخالف التصالح أمام النيابة العامة مقابل دفع مبلغ يعادل الحد الأدنى للغرامة المقررة قانونا.

ويترتب على التصالح في جميع الأحوال انقضاء الدعوى الجنائية، وعدم سحب الترخيص وإلغاء القرارات التي صدرت في تلك الحالات، وينسحب أثر التصالح إلى الجريمة الأشد للجريمة المرتبطة الأخف.

وإذا اعترض المخالف في المواعيد وبالإجراءات المقررة قانونا للاعتراض على الأوامر الجنائية، اتخذت النيابة العامة إجراءات إحالته للمحاكمة خلال أسبوع من تاريخ الاعتراض.

وعند صدور الحكم النهائى بالغرامة، يلتزم المحكوم عليه بسدادها لخزينة المحكمة خلال ثلاثة أيام عمل على الأكثر.(27)$e1110$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins111;

WITH ins112 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 81, 0, $eh1120$الباب السادس: العقوبات$eh1120$, $et1120$مادة 81$et1120$, $e1120$إذا اتهم قائد أية سيارة بارتكاب جريمة قتل أو إصابة خطأ بالسيارة فيجوز للنيابة العامة أن تأمر بإيقاف سريان رخصة القيادة المنصرفة إليه لمدة لا تجاوز شهرا ولها إذا رأت أن مدة إيقافه أطول أن تعرض الأمر على القاضى الجزئى ليأمر بإلغائه أو امتداده للمدة التي يحددها.$e1120$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins112;

WITH ins113 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 81, 1, $eh1130$الباب السادس: العقوبات$eh1130$, $et1130$مادة 81 مكررا$et1130$, $e1130$تنقضى الدعوى الجنائية في المخالفات المنصوص عليها في هذا القانون بمضى ثلاث سنوات من تاريخ وقوع الفعل، كما تسقط العقوبة بمرور ثلاث سنوات على صيرورة الحكم بها نهائيا.(24)$e1130$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins113;

WITH ins114 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 81, 2, $eh1140$الباب السادس: العقوبات$eh1140$, $et1140$مادة 81 مكررا 1$et1140$, $e1140$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب كل من قاندو المركبات التي تتسبب دون مقتضى في تعطيل حركة المرور أو تعويقها، بغرامة لا تقل عن خمسمائة جنيه ولا تزيد على ألفى جنيه.

ولضباط المرور المختصين والأمناء والمساعدين إزالة أسباب المخالفة على نفقة المتسبب بالطريق الإدارى.(50)$e1140$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins114;

WITH ins115 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 81, 3, $eh1150$الباب السادس: العقوبات$eh1150$, $et1150$مادة 81 مكررا 2$et1150$, $e1150$مع عدم الإخلال بأية عقوبة أشد في أى قانون آخر، يعاقب كل من أقام مطبا صناعيا دون ترخيص، أو قام بغلق مكان، أو اقتطاع، أو احتجاز، أو منع استخدام جزء من الطريق بشكل يؤدى إلى تضييقه، أو إعاقة المرور، أو تعريض الأرواح للخطر، بالحبس مدة لا تزيد على سنة وبغرامة لا تقل عن ألف جنيه ولا تزيد على ثلاثة آلاف جنيه.

وتضاعف العقوبتين السالبة للحرية والغرامة المالية عند العود لارتكاب الفعل خلال سنة من تاريخ الحكم النهائى بالإدانة.

ولضباط المرور المختصين والأمناء والمساعدين إزالة أسباب المخالفة على نفقة المتسبب بالطريق الإدارى.(50)$e1150$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins115;

WITH ins116 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 81, 4, $eh1160$الباب السادس: العقوبات$eh1160$, $et1160$مادة 81 مكررا 3$et1160$, $e1160$مع عدم الإخلال بالتدابير المقررة في هذا القانون، أو بأية عقوبة أشد في أى قانون آخر، يعاقب بذات العقوبة المقررة للفعل كل من سمح بقيادة مركبة مرخص له لأى شخص غير مرخص له بالقيادة، إذا نجم عن ذلك حدوث إصابة أو وفاة أو ضرر للغير.(50)(61)$e1160$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins116;

WITH ins117 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 81, 5, $eh1170$الباب السادس: العقوبات$eh1170$, $et1170$مادة 81 مكررا 4$et1170$, $e1170$مع عدم الإخلال بالتدابير المقررة في هذا القانون، وأية عقوبة أخرى في أى قانون آخر، يعاقب بالحبس مدة لا تقل عن ستة أشهر، وبغرامة لا تقل عن عشرين ألف جنيه ولا تزيد على خمسين ألف جنيه أو بإحدى هاتين العقوبتين كل من قاد مركبة لنقل مواد أو سلع أو أدوات من الأشياء المحظور تداولها أو نقلها.(50)$e1170$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins117;

WITH ins118 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 82, 0, $eh1180$الباب السابع: أحكام ختامية - الفصل الأول: المجلس الاعلى للمرور$eh1180$, $et1180$مادة 82$et1180$, $e1180$ينشأ بوزارة الداخلية مجلس أعلى للمرور، يختص برسم السياسة العامة لمرفق المرور ووضع خططه ووسائل وأساليب النهوض به، ويختص كذلك بتحديد مهام ومسئوليات الوزارات والهيئات والجهات القائمة على تنفيذ خطط مرفق المرور.

ويصدر بتشكيل عمل المجلس ونظام عمل قرار من رئيس الجمهورية بناء على اقتراح وزير الداخلية وتكون قراراته ملزمة بعد اعتمادها من رئيس مجلس الوزراء.(14)$e1180$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins118;

WITH ins119 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 83, 0, $eh1190$الفصل الثانى: أحكام انتقالية$eh1190$, $et1190$مادة 83$et1190$, $e1190$تسرى رخص تسيير المركبات وقيادتها الصادرة قبل العمل بهذا القانون حتى نهاية مدتها، والرخص التي تنتهى مدتها خلال تسعين يوما من بدء العمل به، يجوز تجديدها خلال هذه المدة.$e1190$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins119;

WITH ins120 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 84, 0, $eh1200$الفصل الثانى: أحكام انتقالية$eh1200$, $et1200$مادة 84$et1200$, $e1200$للحاصلين على رخصة قائدة سيارة خاصة أو أجرة عند العمل بهذا القانون حق قيادة السيارات المنصوص عليها في البند (2) من المادة 34 من هذا القانون ذات الرخصة، إلى أن يستبدل بها رخصة أخرى عند تجديدها طبقا لهذا القانون مع مراعاة المدة المقررة في المادة السابقة.$e1200$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins120;

WITH ins121 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 85, 0, $eh1210$الجدول الملحق بقانون المرور: أولا- الضرائب$eh1210$, $et1210$الجدول الملحق بقانون المرور (الضرائب والرسوم)$et1210$, $e1210$أولا - الضرائب:

1- ضرائب مركبات النقل السريع:

(أ) تكون الضرائب عن المركبات المبينة بعد إذا كان الوقود المستعمل في إدارة محركها بنزينا صافيا على الوجه الآتى:
15 جنيها سنويا للسيارات التي تقل سعة محركها عن 1000 سم3.
18 جنيها سنويا للسيارات سعة محركها 1000 سم3 ولا تزيد على 1300 سم3.
30 جنيها سنويا للسيارات التي تزيد سعة محركها على 1300 سم3 ولا تزيد على 1600 سم3.
50 جنيها سنويا للسيارات التي تزيد سعة محركها على 1600 سم3 ولا تزيد على 2000 سم3.
90 جنيها سنويا للسيارات التي تزيد سعة محركها على 2000 سم3 ولا تزيد على 2500 سم3.
120 جنيها سنويا للسيارات التي تزيد سعة محركها على 2500 سم3.

(ب) تكون ضريبة الرخصة التجارية خمسون (50) جنيها سنويا، وضريبة الرخصة المؤقتة جنيها واحدا (1 جنيه) عن اليوم الواحد.

(ج) تكون الضريبة عن الجرار المفرد أو الذى يقطر مقطورة زراعية والذى يسير على عجلات ذات أطواق غير معدة لنقل أشخاص أو أشياء (2 جنيهين) سنويا.

(د) ضرائب المركبات المقطورة: تكون هذه الضرائب سنويا عن المركبات المقطورة المبينة بعد كالآتى:
مليم جنيه.
12 عن المقطورة الملحقة بالسيارة الخاصة (الكارافان).
15 عن المقطورة الزراعية.
2.250 عن كل راكب من عدد الركاب المصرح به للمقطورات المخصصة لنقل الركاب.
25 عن الكيلو جرام من الوزن الصافى للمقطورة أو نصف المقطورة غير الزراعية المخصصة لنقل البضائع والأشياء.
20 عن الكيلو جرام من الوزن الصافى للمقطورات الملحقة بسيارات النقل المشترك للركاب والبضائع معا وتكون من نوعها.
15(أ) عن الكيلو جرام من وزن المقطورات الثلاجة المجهزة لنقل الأسماك والطيور المذبوحة واللحوم والألبان.
(ب) عن الكيلو جرام من وزن المعدة لنقل بضائع غير مؤن ومزودة بها آلات أو أجهزة «ونش» أو رافع وتكون معها وحدة كاملة.
(هـ) تزاد بمقدار 50% الضرائب التي تستحق عن السيارات الخاصة والمركبات المقطورة (الكارافان) الملحقة بالسيارات الخاصة، وسيارات الأجرة وسيارات النقل الخاص عدا المخصصة لنقل الطلبة، والموتوسيكل، وتؤول حصيلة هذه الزيادة إلى الخزانة العامة.(21)(38)

2- ضرائب مركبات النقل البطىء:

تكون هذه الضرائب سنويا كالآتى:
مليم جنيه
1- عن عربة الركوب.
1- عن عربة نقل الموتى.
1- عن عربة النقل.
200- عن دراجة الركوب المعدة للإيجار.
1- عن الدراجة ذات الصندوق.
100- عن دراجة الركوب الخاصة.
100- عن عربة اليد.

تفرض ضريبة إضافية على رخصة سيارات الركوب الخاصة والأجرة التي تعمل بالسولار مقدارها عشرة جنيهات سنويا.

وتحصل هذه الضريبة مع الضرائب المقررة للترخيص بهذه السيارات، وتسرى عليها الأحكام التي تسرى على هذه الضرائب.(19)

ثانيا - الرسوم:

1- رسوم رخص قيادة مركبات النقل السريع:

تكون رسوم رخصة القيادة وتجديدها كالآتى:
مليم جنيه
1- عن الرخصة التي تسرى لمدة خمس سنوات.
400- عن الرخصة التي تسرى لمدة سنتين.
600- عن رخصة القيادة المؤقتة للتعليم لمدة ستة أشهر.
200- عن بدل الفاقد أو التالف.

2- رسوم رخص قيادة مركبات النقل البطىء:
500- عن رخصة عربة ركوب أو نقل لمدة خمس سنوات ويحصل هذا الرسم مثل عند تجديدها.
100- عن بدل الفاقد أو التالف.

3- رسوم أخرى:
400- رسم بدل فاقد أو تالف لرخصة تسيير أية مركبة من مركبات النقل السريع.
400- رسم سنوى مقابل استعمال اللوحتين المعدنيتين للمركبة.
200- رسم سنوى مقابل استعمال لوحة المقطورة والموتوسيكل.(38)
100- رسم سنوى مقابل استعمال اللوحة المعدنية لمركبات النقل البطىء.
250- رسم بدل فاقد أو تالف لرخصة تسيير عربة الركوب وعربة نقل الموتى.
150- رسم بدل فاقد أو تالف لرخصة تسيير عربة النقل.
100- رسم بدل فاقد أو تالف لرخصة تسيير دراجة الركوب المعدة للإيجار والدراجة ذات الصندوق.
50- رسم بدل فاقد أو تالف لرخصة دراجة الركوب الخاصة وعربة اليد.(*)
10- ضريبة سنوية على سيارات النقل الخفيف التي لا تزيد حمولتها الصافية على 750 كيلو جرام.
15- ضريبة سنوية على سيارات النقل الخفيف التي تزيد حمولتها الصافية على 750 كيلو جرام ولا تجاوز 2000 كيلو جرام.(2)
10- عن الرخصة التي تسرى لمدة عشر سنوات.(19)

4- رسوم إنشاء وتطوير منظومة النقل الذكى:(60)
نوع الترخيص/الفئات - الرسم بالجنيه
ملاكى (بالسعة اللترية) أقل من 1300: 60
1300-1600: 75
1601-2000: 150
2001-2500: 250
أكثر من 2500: 350
جمرك: 1000
دراجة نارية: 20
أتوبيس خاص: 200
أتوبيس رحلات: 200
أتوبيس عام: 200
أتوبيس سياحة: 200
أتوبيس مدارس: 50
الأجرة - الأجرة دراجة نارية (توكتوك): 25
النقل بالطن من 2 إلى 7: 250
أكبر من 7: 300
مقطورة: 400
الحكومة: 50
القطاع العام: 50
المحافظة: 50
معدة ثقيلة: 500
مقطورة زراعية: 50
تجارى: 2500
مؤقت: 50
منطقة حرة: 100
هيئة دبلوماسية: 50
ملاكى مميز: 50
جرار زراعى: 50
تحت الطلب: 50
ملحقة: 600

(*) ينظر الاستدراك المنشور بالجريدة الرسمية فى 31 ديسمبر سنة 1973 - العدد 52 مكرر.$e1210$
  FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1973-08-23', 'active' FROM ins121;

-- ===== تحقق نهائى =====
DO $verify067$
DECLARE
  v_law_id uuid;
  v_total INT;
  v_versions INT;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 66 AND law_year = 1973 AND kind = 'law';
  IF v_law_id IS NULL THEN RAISE EXCEPTION 'law 66/1973 not found after seed'; END IF;
  SELECT count(*) INTO v_total FROM articles WHERE law_id = v_law_id;
  IF v_total <> 122 THEN RAISE EXCEPTION 'expected 122 articles, got %', v_total; END IF;
  SELECT count(*) INTO v_versions FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id;
  IF v_versions <> 122 THEN RAISE EXCEPTION 'expected 122 article_versions, got %', v_versions; END IF;
  RAISE NOTICE '067_seed_law_66_1973_traffic_code: تم بنجاح. % مادة، % نسخة.', v_total, v_versions;
END $verify067$;

COMMIT;