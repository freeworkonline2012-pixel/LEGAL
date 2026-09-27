-- 069_seed_law_114_1946_real_estate_registration.sql
--
-- بذر القانون رقم 114 لسنة 1946 بتنظيم الشهر العقارى — النص الحالى
-- المُوحَّد (61 مادة أساسية + 4 مواد 'مكررة' من تعديل 2022 = 65 صفاً).
-- الترتيب رقم 1 (الأصغر التالى) فى قائمة القوانين الناقصة، بعد إتمام
-- 15/2004 فى migrations/068.
--
-- ===== المصادر (لا اختلاق — مصدران رسميان مباشران من المستخدم) =====
-- 1) الأساس: مسح ضوئى لصفحات الوقائع المصرية، العدد 85، بتاريخ
--    1946-08-24، يتضمن النص الكامل الأصلى لقانون 114/1946 (61 مادة،
--    7 أبواب)، موقَّع من الملك فاروق الأول. رُفع مباشرة من المستخدم.
--    قُرئ ونُقل بصرياً صفحة بصفحة (مرتين: تفريغ أولى + مراجعة مباشرة
--    لاحقة لكل فقرة كانت غير واضحة فى المحاولة الأولى، حتى استقرت
--    كل مادة على نص نهائى واضح بلا أى فجوة متبقية).
-- 2) التعديل: مسح ضوئى لصفحات الوقائع المصرية، العدد 9 مكرر (أ)،
--    بتاريخ 2022-03-06، يتضمن القانون رقم 9 لسنة 2022 بتعديل بعض
--    أحكام القانون 114/1946، موقَّع من الرئيس عبد الفتاح السيسى.
--    رُفع مباشرة من المستخدم، وقُرئ بصرياً صفحة بصفحة (مرتين، مع
--    إعادة قراءة الصفحة الأولى تحديداً لأن الاستخراج النصى الآلى
--    لها كان تالفاً/معكوساً؛ الصورة المُصيَّرة نفسها كانت سليمة).
--
-- ===== منهجية الدمج =====
-- طُبِّقت المادة الأولى من قانون 9/2022 (استبدال نصوص: 9/فقرتين
-- رابعة وسادسة، 21، 22، 23مكرراً، 28، 33، 35، 36مكرراً، 48، 49،
-- 50، 57) حرفياً من نص الجريدة الرسمية نفسه، ثم المادة الثانية
-- (إضافة مادتين جديدتين 10مكررا و22مكررا) حرفياً كذلك، ثم المادة
-- الثالثة (إلغاء المواد 9/فقرة خامسة، 24، 26، 29، 34) — المواد
-- الأربع الأخيرة (24، 26، 29، 34) أُدرجت بصفوف مستقلة بعنوان
-- '(ملغاة)' وبمتن 'ملغاة.' قياساً على السابقة المؤكَّدة فى
-- migrations/067 (مادة 79 (ملغاة) لقانون المرور)، وفقرة 9/الخامسة
-- أُدرجت كملاحظة داخل متن المادة 9 نفسها بدل حذفها بصمت. بقية مواد
-- الأساس (1-61 عدا ما تقدَّم) أُبقيت كما هى من نص 1946 الأصلى دون
-- أى تغيير.
--
-- ===== قرار نطاق صريح (تطبيقاً لقاعدة 'لا اختلاق') =====
-- ثلاث مواد 'مكررة' تاريخية أشارت إليها بحوث ثانوية غير رسمية
-- (12مكررا [1957]، 19مكررا [1956]، 35مكررا [تاريخ متضارب بين
-- 186/2020 و23/2020 حسب المصدر]) استُبعدت بالكامل من هذه الهجرة
-- لعدم توفر مصدر رسمى أو موثوق لنصها الحرفى حتى تاريخ هذه الهجرة،
-- ولتضارب إجابات المصدر الثانوى نفسه حول رقم القانون المُنشئ
-- لمادة 35مكررا تحديداً عبر استعلامات منفصلة. هذا قرار نطاق واعٍ
-- وليس إغفالاً: القانون هنا يُنشر بنص 65 مادة مؤكَّدة المصدر بدل
-- تأجيل كامل القانون أو اختلاق نص غير موثوق لثلاث مواد. يُستكمل
-- إدراج هذه المواد الثلاث فى هجرة لاحقة إذا تم العثور على مصدر
-- رسمى موثوق لها.
--
-- التصنيف category='other' (لا فئة مخصصة للشهر العقارى/التوثيق فى
-- قيد laws_category_check الحالى؛ نفس المعالجة المتبعة سابقاً مع
-- 15/2004 و174/2025).
--
-- تواريخ النفاذ: نص 1946 غير المُعدَّل = 1947-01-01 (مادة 61 الأصلية:
-- 'يعمل به من أول يناير التالى لتاريخ نشره'، نُشر 1946-08-24). نص
-- 2022 المُستبدَل/المُضاف = 2022-05-06 (مادة خامسة من قانون 9/2022:
-- 'يعمل به من اليوم التالى لمرور ستين يوماً على تاريخ نشره'، نُشر
-- 2022-03-06 → +60 يوماً = 2022-05-05 → اليوم التالى = 2022-05-06).
--
-- قابلة لإعادة التشغيل بأمان (idempotent).

BEGIN;

-- ===== laws =====
INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
VALUES (
  114, 1946,
  $lawt0$القانون رقم 114 لسنة 1946 بتنظيم الشهر العقارى (بتعديلاته حتى القانون رقم 9 لسنة 2022)$lawt0$,
  $laws0$الشهر العقارى 114/1946$laws0$,
  'other', 'law', 'in_force',
  $url0$مصدر المستخدم المباشر: مسح ضوئى للوقائع المصرية العدد 85 (1946-08-24) + مسح ضوئى للوقائع المصرية العدد 9 مكرر (أ) (2022-03-06)$url0$,
  '1946-08-24'
)
ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $eh00$الباب الأول: فى مكاتب الشهر العقارى$eh00$, $et00$مادة 1$et00$, $e00$تنشأ فى المديريات والمحافظات مكاتب للشهر العقارى تتولى شهر المحررات التى تقضى القوانين بشهرها أو بقيدها.
تتبع هذه المكاتب وزارة العدل، ويعين بمرسوم مقر كل منها ودائرة اختصاصه، ويلحق بكل مكتب مأموريات يعين بقرار وزارى مقر كل منها ودائرة اختصاصها.$e00$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $eh10$الباب الأول: فى مكاتب الشهر العقارى$eh10$, $et10$مادة 2$et10$, $e10$ينشأ مكتب رئيسى مقره مدينة القاهرة، برئاسة أمين عام يعين بمرسوم، ويتولى هذا المكتب إدارة مكاتب الشهر العقارى ومراقبتها وحفظ صور جميع المحررات التى شهرت فيها وصورة من الفهارس الخاصة بها.$e10$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $eh20$الباب الأول: فى مكاتب الشهر العقارى$eh20$, $et20$مادة 3$et20$, $e20$ينشأ مجلس أعلى للشهر العقارى يتكون من الأمين العام رئيساً ومن ستة أعضاء يعينون بقرار من مجلس الوزراء لمدة ثلاث سنوات، يكون من بينهم من يمثل جهة القضاء ومصلحة المساحة وبيت الاتقان العقارى.
ويُعرض على هذا المجلس مشروعات القوانين واللوائح والمنشورات والقرارات المتعلقة بالشهر العقارى.
وللمجلس اقتراح ما يراه من إدخال نظام من تعديلات، وبحث ما يقدم إليه من اقتراحات فى هذا الشأن.$e20$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $eh30$الباب الأول: فى مكاتب الشهر العقارى$eh30$, $et30$مادة 4$et30$, $e30$تُحفظ أفلام التسجيل الملتقطة بالمحاكم الوطنية والمختلطة وتُعمل عنها نسخ تُحفظ بمكتب الشهر العقارى. ويُحال ما يلزم من هذه الأفلام وما بمصلحة المساحة من السجلات والفهارس وغير ذلك من الوثائق الخاصة بشهر المحررات إلى هذه المكاتب.$e30$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $eh40$الباب الأول: فى مكاتب الشهر العقارى$eh40$, $et40$مادة 5$et40$, $e40$يختص كل مكتب من مكاتب الشهر دون غيره بشهر المحررات المتعلقة بالعقارات التى تقع فى دائرة اختصاصه.
فإذا كانت العقارات واقعة فى دائرة اختصاص مكاتب متعددة وجب إجراء الشهر فى كل مكتب منها.
ولا يكون للشهر الذى يتم فى أحد هذه المكاتب أثره بالنسبة إلى العقارات وأجزاء العقارات التى تقع فى دائرة اختصاصه.
ويُعد بكل مكتب فهرس للمحررات التى تم شهرها فيه، وتُحرَّر الشهادات العقارية التى تُطلب وفقاً للبيانات الواردة فى هذا الفهرس.
ويُبيَّن فى الشهادات قلم التسجيل الذى شُهرت فيه بأحكام العمل بها سابقاً على العمل بأحكام هذا القانون.$e40$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $eh50$الباب الأول: فى مكاتب الشهر العقارى$eh50$, $et50$مادة 6$et50$, $e50$تقوم مكاتب الشهر بما يأتى:
(1) إثبات المحررات فى دفاتر الشهر والتأشير عليها بما يفيد شهرها.
(2) تصوير المحررات التى يُطلب شهرها.
(3) حفظ أصول المحررات التى تم شهرها وموافاة الجهات المختصة بصور منها.
(4) إعداد فهارس للمحررات التى تُشهر.
(5) التأشيرات الهامشية وإرسال صور منها إلى المكتب الرئيسى.
(6) إعطاء الشهادات العقارية.
(7) إعطاء الصور التى تُطلب من المحررات التى تم شهرها.
(8) الترخيص بالاطلاع (الكشف النظرى).$e50$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, $eh60$الباب الأول: فى مكاتب الشهر العقارى$eh60$, $et60$مادة 7$et60$, $e60$لا يجوز بأى حال من الأحوال أن تُنقل من مكتب الشهر أصول المحررات التى تم شهرها ولا الدفاتر أو الوثائق المتعلقة بالشهر.$e60$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, $eh70$الباب الأول: فى مكاتب الشهر العقارى$eh70$, $et70$مادة 8$et70$, $e70$يصدر مرسوم باللائحة التنفيذية تشتمل على تنظيم دفاتر الشهر ودفاتر الفهارس وعمل التنظيم الداخلى لمكتب الشهر العقارى والمأموريات وسير العمل فيها.$e70$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, $eh80$الباب الثانى: فى المحررات الواجب شهرها$eh80$, $et80$مادة 9$et80$, $e80$جميع التصرفات التى من شأنها إنشاء حق من الحقوق العينية العقارية الأصلية أو نقله أو تغييره، وكذلك الأحكام النهائية المثبتة لشىء من ذلك، يجب شهرها بطريق التسجيل، ويدخل فى هذه التصرفات الوقف والوصية.
يترتب على عدم التسجيل أن الحقوق المشار إليها لا تنشأ ولا تنتقل ولا تزول ولا يترتب عليها أى تغيير فيما بين ذوى الشأن ولا بالنسبة إلى الغير.
ولا يكون للتصرفات غير المسجلة من الأثر سوى الالتزامات الشخصية فيما بين ذوى الشأن.
(فقرة رابعة — نص مُستبدَل بالقانون رقم 9 لسنة 2022): ويجوز لمن حصل لصالحه أو مع آخرين على حكم نهائى مثبت لحق من هذه الحقوق أن يطلب قصر التسجيل على القدر الذى قضى له به، كما يجوز له أن يطلب قصر التسجيل على أى من العقارات المقضى له بها أو بجزء منها، سواء كان ذلك شائعاً أو مفرزاً، على حسب الأحوال.
(فقرة خامسة): ملغاة بالقانون رقم 9 لسنة 2022.
(فقرة سادسة — نص مُستبدَل بالقانون رقم 9 لسنة 2022): ولا يسرى حكم الفقرة الرابعة من هذه المادة إذا كان التصرف المقضى به من عقود المقايضة.$e80$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins8;

WITH ins9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, $eh90$الباب الثانى: فى المحررات الواجب شهرها$eh90$, $et90$مادة 10$et90$, $e90$جميع التصرفات والأحكام النهائية المقررة لحق من الحقوق العينية العقارية الأصلية يجب تسجيلها، ويترتب على عدم التسجيل أن هذه الحقوق لا تكون حجة على الغير.
ويسرى هذا الحكم على القسمة المتعلقة بها ولو كانت لها آثار مقررة.$e90$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins9;

WITH ins10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 1, $eh100$الباب الثانى: فى المحررات الواجب شهرها$eh100$, $et100$مادة 10 مكرراً$et100$, $e100$يجوز أن تشهر الوقائع التى من شأنها إنشاء حق من الحقوق العينية العقارية الأصلية أو نقله أو تغييره أو زواله أو تقريره بطريق التسجيل، ويعد من هذه الوقائع فى تطبيق أحكام هذه المادة الحيازة المكسبة للملكية وفقاً لأحكام المادتين (968، 969) من القانون المدنى والحيازة المصحوبة بسند، ولو كان عرفياً، لمدة خمس سنوات تبدأ من تاريخ نشوء الحق إذا كانت بحسن نية حتى التسجيل.
ويترتب على عدم التسجيل عدم الاحتجاج بالحقوق المشار إليها قِبل الغير.
[مادة مضافة بالقانون رقم 9 لسنة 2022]$e100$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins10;

WITH ins11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, $eh110$الباب الثانى: فى المحررات الواجب شهرها$eh110$, $et110$مادة 11$et110$, $e110$يجب تسجيل الإيجارات والسندات التى ترد على منفعة العقار إذا زادت مدتها على تسع سنوات، والمخالصات والحوالات بأكثر من أجرة ثلاث سنوات مقدماً، وكذلك الأحكام النهائية المثبتة لشىء من ذلك.
ويترتب على عدم تسجيلها أنها لا تكون نافذة فى حق الغير فيما زاد على مدة تسع سنوات بالنسبة للإيجارات والسندات، وفيما زاد على أجرة ثلاث سنوات بالنسبة إلى المخالصات والحوالات.$e110$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins11;

WITH ins12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, $eh120$الباب الثانى: فى المحررات الواجب شهرها$eh120$, $et120$مادة 12$et120$, $e120$جميع التصرفات المنشئة لحق من الحقوق العينية العقارية التبعية أو المقررة لها، وكذلك الأحكام النهائية المثبتة لشىء من ذلك، يجب شهرها بطريق القيد، ويترتب على عدم القيد أن هذه الحقوق لا تكون حجة على الغير.$e120$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins12;

WITH ins13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, $eh130$الباب الثانى: فى المحررات الواجب شهرها$eh130$, $et130$مادة 13$et130$, $e130$يجب شهر حق الإرث بتسجيل إشهادات الوراثة الشرعية أو الأحكام النهائية المثبتة لهذا الإرث أو غيرها من السندات، مع قوائم جرد التركة إذا اشتملت على حقوق عقارية، وذلك بدون رسم.
إلى أن يتم هذا التسجيل لا يجوز تصرف بمقتضاه الوارث فى حق الوارثين فى الميراث الثابت لهم.
ويجوز أن يقتصر شهر حق الإرث على جزء من عقارات التركة، وفى هذه الحالة يُعتبر هذا الجزء وحده يُبنى على أساسه تصرفات الوراثة.$e130$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins13;

WITH ins14 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, $eh140$الباب الثانى: فى المحررات الواجب شهرها$eh140$, $et140$مادة 14$et140$, $e140$يجب التأشير بالمحررات المثبتة لدين من الديون المادية فى هامش تسجيل الإشهادات أو الأحكام أو السندات وقوائم الجرد المتعلقة بها.$e140$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins14;

WITH ins15 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, $eh150$الباب الثانى: فى المحررات الواجب شهرها$eh150$, $et150$مادة 15$et150$, $e150$يجب التأشير فى هامش سجل المحررات وواجهة الشهر بما يُقدَّم ضدها من الدعاوى التى يكون الغرض منها الطعن فى التصرف الذى تضمنته المحرر وجوداً أو صحة أو نفاذاً، كدعاوى البطلان أو الفسخ أو الإبطال أو الإلغاء أو الرجوع، فإذا كان المحرر لم يُشهر تُسجَّل تلك الدعاوى.
ويجب كذلك تسجيل دعاوى استحقاق أى حق من الحقوق العينية العقارية أو التأشير بها حسب الأحوال، كما يجب تسجيل دعاوى صحة التعاقد على حقوق عينية عقارية.
ويتم التأشيرات والتسجيلات المشار إليها بعد إعلان صحيفة الدعوى وقيدها بجدول المحكمة.$e150$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins15;

WITH ins16 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, $eh160$الباب الثانى: فى المحررات الواجب شهرها$eh160$, $et160$مادة 16$et160$, $e160$يؤشر بمنطوق الحكم النهائى فى الدعاوى المبينة فى المادة السابقة، بالدعوى أو فى هامش التأشير بتسجيلها.$e160$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins16;

WITH ins17 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, $eh170$الباب الثانى: فى المحررات الواجب شهرها$eh170$, $et170$مادة 17$et170$, $e170$يترتب على تسجيل الدعاوى المذكورة بالمادة الخامسة عشرة أو التأشير بها أن المدعى إذا كسب حقاً بمقتضى حكم يكون حجة على من رتبت لهم حقوق عينية ابتداء من تاريخ تسجيل الدعاوى أو التأشير بها.
ولا يكون هذا الحق حجة على الغير الذى كسب حقه بحسن نية قبل التأشير أو التسجيل المشار إليهما.$e170$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins17;

WITH ins18 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, $eh180$الباب الثانى: فى المحررات الواجب شهرها$eh180$, $et180$مادة 18$et180$, $e180$لكل ذى شأن أن يطلب إلى قاضى الأمور المستعجلة محو التأشير المشار إليه فى المادة الخامسة عشرة، وذلك بالقاضى إذا كان الدين معطلاً فيه طلباً جدياً.
وكذلك للطرف ذى الشأن أن يطلب إلى القاضى محو التسجيل المشار إليه فى المادة السادسة عشرة، وذلك بالقاضى إذا تبين له أن الدعوى لم تُرفع إلا لغرض كيدى محض.$e180$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins18;

WITH ins19 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, $eh190$الباب الثانى: فى المحررات الواجب شهرها$eh190$, $et190$مادة 19$et190$, $e190$لا يصح التمسك قبل الغير بتحويل حق مضمون بقيد أو رهنه، أو التمسك بالحق الناشئ من حوالة شخص لغير الدائن فى هذا الحق بحكم هذا القانون، إلا إذا حصل التأشير بذلك فى هامش القيد الأصلى.$e190$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins19;

WITH ins20 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, $eh200$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh200$, $et200$مادة 20$et200$, $e200$تتم إجراءات الشهر فى جميع الأحوال بناء على طلب ذوى الشأن أو من يقوم مقامهم.$e200$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins20;

WITH ins21 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, $eh210$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh210$, $et210$مادة 21$et210$, $e210$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): تقدم طلبات الشهر للمأمورية التى يقع العقار فى دائرة اختصاصها على النموذج الذى يصدر به قرار من وزير العدل، ويجب أن يكون موقعاً على هذه الطلبات من المتصرف أو المتصرف له فى العقود والإشهادات أو ممن يكون المحرر لصالحه فى غير ذلك من المحررات كأوراق الإجراءات وصحف الدعاوى والأحكام، كما يمكن تقديم الطلب إلكترونياً على النحو الذى تبينه اللائحة التنفيذية لهذا القانون.$e210$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins21;

WITH ins22 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, $eh220$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh220$, $et220$مادة 22$et220$, $e220$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): مع عدم الإخلال بالأحكام الخاصة المنظمة قانوناً، يجب أن تشتمل الطلبات المنصوص عليها فى المادة (21) من هذا القانون على ما يأتى:
(أولاً) البيانات الدالة على شخصية كل طرف وصفته وسلطته، ويستثنى من ذلك الصادر بشأنهم الأحكام النهائية المطلوب شهرها.
(ثانياً) خريطة رسمية رقمية مبيناً بها بيانات وإحداثيات العقار أو الوحدة محل التسجيل أو أى مستند رسمى آخر يحمل ذات البيانات.
(ثالثاً) السند القانونى لطلب التسجيل.
(رابعاً) إقرار من صاحب الشأن بالحقوق المقررة على العقار محل التسجيل، إن وجدت.
وذلك كله على النحو الذى تبينه اللائحة التنفيذية لهذا القانون.$e220$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins22;

WITH ins23 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 1, $eh230$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh230$, $et230$مادة 22 مكرراً$et230$, $e230$لا يقيد طلب الشهر ما لم يكن مستوفياً للبيانات والمستندات الواردة بالمادة (22) من هذا القانون، ومرفقاً به مشروع المحرر المراد شهره، وتحدد اللائحة التنفيذية لهذا القانون إجراءات ومواعيد استيفاء الطلب.
[مادة مضافة بالقانون رقم 9 لسنة 2022]$e230$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins23;

WITH ins24 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, $eh240$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh240$, $et240$مادة 23$et240$, $e240$لا يُقبل من المحررات فيما يتعلق ببيانات أصل الملكية أو الحق العينى وفقاً لأحكام المادة السابقة إلا:
(1) المحررات التى سبق شهرها.
(2) المحررات التى تتضمن تصرفاً مضافاً إلى ما بعد الموت، تم قبل العمل بأحكام هذا القانون.
(3) المحررات التى ثبت تاريخها قبل سنة 1924 من غير طريق وجود توقيع أو ختم لإنسان توفى.
(4) المحررات التى تحمل تاريخاً سابقاً على سنة 1924 إذا كان قد أُخذ بها قبل العمل بأحكام هذا القانون فى محررات تم شهرها أو نُقل التكليف بمقتضاها لمن صدرت لمصلحته.$e240$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins24;

WITH ins25 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 1, $eh250$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh250$, $et250$مادة 23 مكرراً$et250$, $e250$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): إذا كان موضوع طلب الشهر إحدى الوقائع المشار إليها فى المادة (10 مكرراً) من هذا القانون، أو كان أصل الملكية أو الحق العينى محل طلب الشهر لا يستند إلى أحد المحررات المنصوص عليها فى المادة (23) من هذا القانون، وطلب صاحب الشأن إسناده إلى إحدى هذه الوقائع، فعلى المأمورية تحقيق مدى توافر شروط هذه الوقائع وفقاً لأحكام القانون ثم تحيل الطلب إلى مكتب الشهر مشفوعاً برأيها فى خلال ثلاثين يوماً من تاريخ تقديم الطلب.
وتتولى لجنة ثلاثية تشكل بمكتب الشهر برئاسة أمين المكتب وعضوية أقدم اثنين من الأمناء المساعدين أو الأعضاء القانونيين، حال عدم تواجد الأمناء المساعدين، النظر فى الطلب والاعتراضات المقدمة بشأنه، وتصدر قرارها مسبباً بقبول الطلب أو رفضه خلال سبعة أيام من تاريخ تسليم الأوراق إليها.
وتبين اللائحة التنفيذية لهذا القانون الإجراءات التى تتبع فى تحقيق تلك الوقائع والمستندات الواجب تقديمها وطرق النشر والإعلان وكيفية الاعتراض أمام اللجنة.
ويستحق على الطلب رسم محدد لا يزيد على خمسمائة جنيه، فضلاً عن مصروفات النشر والانتقال، وتبين اللائحة التنفيذية لهذا القانون فئات هذا الرسم.
ولا تسرى أحكام الفقرات السابقة على العقارات المنصوص عليها فى المادة (970) من القانون المدنى ولا على الأراضى الفضاء، كما لا تخل أحكام هذه المادة بحق ذوى الشأن فى الالتجاء إلى القضاء للمنازعة فى موضوع الحق.$e250$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins25;

WITH ins26 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, $eh260$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh260$, $et260$مادة 24 (ملغاة)$et260$, $e260$ملغاة بالقانون رقم 9 لسنة 2022. (كان نصها الأصلى بقانون 1946 ينص على كفالة قدرها مائة قرش عند تقديم طلب الشهر، تُصادر بقوة القانون إذا لم يتم الشهر خلال سنة من تاريخ قيد الطلب.)$e260$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins26;

WITH ins27 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, $eh270$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh270$, $et270$مادة 25$et270$, $e270$تُدوَّن الطلبات على حسب تواريخ وساعات تقديمها بدفتر يُعد لذلك بالمأمورية.$e270$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins27;

WITH ins28 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 26, 0, $eh280$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh280$, $et280$مادة 26 (ملغاة)$et280$, $e280$ملغاة بالقانون رقم 9 لسنة 2022. (كان نصها الأصلى بقانون 1946 ينظم إعادة نسخة الطلب مؤشراً عليها بالقبول إلى الطالب.)$e280$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins28;

WITH ins29 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 27, 0, $eh290$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh290$, $et290$مادة 27$et290$, $e290$للمأمورية من تلقاء نفسها أو بناء على طلب صاحب الشأن أن تستوفى البيانات فيما يتعلق بوصف العقار وصاحب الملكية والحق العينى مما قد يكون قد ورد إليها من طلبات أو مستندات متى كانت لديها أصولها أو صورها.
وفى هذه الحالة يجب تصوير كل مستند يُستثبت به على نفقة صاحب الشأن.$e290$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins29;

WITH ins30 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 28, 0, $eh300$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh300$, $et300$مادة 28$et300$, $e300$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): بعد انتهاء المأمورية من مراجعة المحرر والتأشير عليه بصلاحيته للشهر يتم توثيق المحرر أو التصديق عليه إن كان عرفياً، على حسب الأحوال، وتخصص دفاتر بكل مأمورية لتوثيق المحررات التى تم التأشير على مشروعاتها بصلاحيتها للشهر أو التصديق على توقيعات ذوى الشأن فيها إذا كانت عرفية، على حسب الأحوال، ثم ترفعه إلى المكتب التابعة له فى اليوم التالى على الأكثر لتوثيق المحرر أو التصديق عليه لاستكمال إجراءات الشهر خلال سبعة أيام على الأكثر من تاريخ وروده إلى المكتب.$e300$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins30;

WITH ins31 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 29, 0, $eh310$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh310$, $et310$مادة 29 (ملغاة)$et310$, $e310$ملغاة بالقانون رقم 9 لسنة 2022. (كان نصها الأصلى بقانون 1946 ينظم تقديم المحررات التى تم التأشير بمشروعاتها بصلاحيتها للشهر لمكتب الشهر المختص بعد توثيقها أو التصديق على توقيعات ذوى الشأن فيها.)$e310$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins31;

WITH ins32 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 30, 0, $eh320$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh320$, $et320$مادة 30$et320$, $e320$إذا كان محرر الشهر بطريق القيد، وجب أن يُقرَن عند تقديمه لمكتب الشهر المختص بقائمة تشتمل على البيانات الآتية:
(أولاً) اسم الدائن ولقبه وصناعته ومحل إقامته ومحله المختار، فإن لم يختر له محلاً صح إعلان الأوراق إليه فى قلم كتاب المحكمة.
(ثانياً) اسم المدين والمالك الذى رُتب الحق عليه إذا لم يكن المدين مالكاً، وصناعته ومحل إقامته.
(ثالثاً) تاريخ السند والجهة التى تم أمامها أو صدر عنها.
(رابعاً) مصدر الدين المضمون ومقداره وميعاد استحقاقه.
(خامساً) بيان يتضمن تعيين العقار الذى رُتب عليه الحق تعييناً دقيقاً.
(سادساً) فى حالة رهن الحيازة العقارية، بيان خاص بالتكليف وأن الالتزام بيّن فى موضوع عقد الرهن.$e320$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins32;

WITH ins33 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 31, 0, $eh330$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh330$, $et330$مادة 31$et330$, $e330$يُعد بالمكتب دفتر للشهر تُثبت فيه المحررات وقوائم القيد على حسب الأحوال بأرقام متتابعة وفقاً لتواريخ وساعات تقديمها.$e330$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins33;

WITH ins34 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 32, 0, $eh340$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh340$, $et340$مادة 32$et340$, $e340$يحصل التأشير بما يفيد الشهر على المحررات الواجب شهرها بطريق التسجيل، وعلى قوائم القيد فى حالة المحررات الواجب شهرها بطريق القيد. ويتم التصوير والحفظ وغير ذلك من الإجراءات طبقاً للائحة التنفيذية.$e340$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins34;

WITH ins35 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 33, 0, $eh350$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh350$, $et350$مادة 33$et350$, $e350$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): إذا قدم للمأمورية أكثر من طلب فى شأن عقار واحد يجب أن تبحث هذه الطلبات وفقاً لأسبقية تدوينها فى دفتر قيد الطلبات، ولا يجوز السير فى إجراءات بحث أى طلب لاحق إلا بعد الفصل فى الطلب الذى يسبقه.$e350$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins35;

WITH ins36 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 34, 0, $eh360$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh360$, $et360$مادة 34 (ملغاة)$et360$, $e360$ملغاة بالقانون رقم 9 لسنة 2022. (كان نصها الأصلى بقانون 1946 ينظم إخطار صاحب الشأن بنقص أو غموض البيانات وسقوط أسبقية الطلب عند عدم الاستيفاء.)$e360$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins36;

WITH ins37 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 0, $eh370$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh370$, $et370$مادة 35$et370$, $e370$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): لمن أشر على طلبه باستيفاء بيان لا يرى له وجهاً أن يتقدم بطلبه للمحرر نفسه أو بالمحرر مصحوباً بالقائمة، على حسب الأحوال، وذلك خلال عشرة أيام من وقت إبلاغه بقرار الاستيفاء أو الرفض، ويطلب من أمين المكتب إعطاء هذا المحرر أو القائمة رقماً وقتياً بعد أداء الرسم وتوثيق المحرر أو التصديق على التوقيعات فيه إن كان من المحررات العرفية وبعد إيداع كفالة قدرها نصف فى المائة من قيمة الالتزام الذى يتضمنه المحرر على ألا يزيد مقدار هذه الكفالة على ألف جنيه فى حالة الإبقاء على الرقم الوقتى، ويجب أن تبين فى الطلب الأسباب التى يستند إليها الطالب.
وفى هذه الحالة يجب على أمين المكتب إعطاء المحرر أو القائمة رقماً وقتياً فى دفتر الشهر المشار إليه فى المادة (31) من هذا القانون، ودفاتر الفهارس، وأن يرفع الأمر فوراً إلى قاضى الأمور الوقتية بالمحكمة الابتدائية التى يقع فى دائرتها المكتب.
ويصدر القاضى بعد سماع إيضاحات صاحب الشأن ومكتب الشهر العقارى قراراً مسبباً خلال سبعة أيام من رفع الأمر إليه بإبقاء الرقم الوقتى بصفة دائمة أو بإلغائه تبعاً لتحقق أو تخلف الشروط التى يتطلبها القانون لشهر المحرر أو القائمة. ويكون القرار الصادر فى هذا الشأن نهائياً.$e370$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins37;

WITH ins38 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 0, $eh380$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh380$, $et380$مادة 36$et380$, $e380$إذا صدر قرار القاضى بإلغاء الرقم الوقتى وجب التأشير بذلك فى دفتر الشهر ودفاتر الفهارس واتخاذ الإجراءات، وعمل الأخص ما يتعلق منها بالتصوير.
وإذا صدر القرار بإلغاء الرقم الوقتى وجب التأشير بذلك فى دفتر الشهر ودفاتر الفهارس، وتصادر الكفالة المتقدم ذكرها بقوة القانون، ورد المحرر أو القائمة لصاحب الشأن بمضمون القرار وتاريخه.
ولا يجوز الطعن فى القرارات التى تصدر على هذا الوجه بأى طريق.$e380$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins38;

WITH ins39 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 1, $eh390$الباب الثالث: فى إجراءات الشهر على وجه العموم$eh390$, $et390$مادة 36 مكرراً$et390$, $e390$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): مع عدم الإخلال بأى عقوبة أشد، يعاقب بالحبس مدة لا تقل عن سنة وبغرامة لا تقل عن خمسين ألف جنيه كل من قدم محرراً عرفياً مزوراً بقصد شهر محرر أو واقعة طبقاً لأحكام هذا القانون، وعلى رئيس المأمورية أو أمين المكتب، بحسب الأحوال، ضبط المحرر المزور وتحرير مذكرة بالواقعة وإحالتها للنيابة العامة المختصة.$e390$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins39;

WITH ins40 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 37, 0, $eh400$الباب الرابع: فى التأشيرات الهامشية$eh400$, $et400$مادة 37$et400$, $e400$تُقدَّم الطلبات الخاصة بالتأشير الهامشى لمكتب الشهر الذى تم فيه شهر المحرر المراد التأشير فى هامشه.
ويجب أن يكون الطلب مشتملاً على اسم الطالب ولقبه وصناعته ومحل إقامته، وتاريخ ورقم شهر المحرر المتقدم ذكره، والسند الذى يبيح التأشير مع بيان نوعه وتاريخه ومضمونه والجهة التى صدر عنها وأسماء ذوى الشأن فيه. ويجب أن يكون مصحوباً بهذا السند وبسائر الأوراق المؤيدة.
ولمكتب الشهر أن يحيل الطلب إلى المأمورية المختصة عند الاقتضاء، ويوقَّع التأشير الهامشى وفقاً للأوضاع الواردة فى اللائحة التنفيذية.$e400$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins40;

WITH ins41 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 38, 0, $eh410$الباب الرابع: فى التأشيرات الهامشية$eh410$, $et410$مادة 38$et410$, $e410$إذا تبين لأمين مكتب التأشير الهامشى أن الطلب لم يستوفِ ما يلزم لإجرائه من البيانات، أوجب النقص بمقتضى كتاب موصى عليه بإخطار وصول.
ويجب فى هذا الكتاب تحديد أجل لتلافى هذا النقص لا يجاوز شهراً، فإذا انقضى الأجل دون استيفاء الطلب، أشَّر الأمين بالحفظ مع بيان الأسباب وأبلغ الطالب ذلك بكتاب مصحوب بإخطار وصول.$e410$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins41;

WITH ins42 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 39, 0, $eh420$الباب الرابع: فى التأشيرات الهامشية$eh420$, $et420$مادة 39$et420$, $e420$لمن حُفظ طلبه أن يطلب إلى أمين مكتب الشهر خلال عشرة أيام من تاريخ إبلاغ قرار الحفظ إليه رفع الأمر إلى قاضى الأمور الوقتية بالمحكمة الابتدائية التى يقع مكتب الشهر فى دائرتها.
ويصدر القاضى قراره على وجه السرعة بعد التحقق من توافر الشروط التى يتطلبها القانون لإجراء التأشير. ولا يجوز الطعن فى القرارات التى تصدر على هذا الوجه بأى طريق.$e420$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins42;

WITH ins43 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 40, 0, $eh430$الباب الرابع: فى التأشيرات الهامشية$eh430$, $et430$مادة 40$et430$, $e430$لا يجوز إجراء أى تأشير هامشى بمقتضى طلب لاحق من شأنه الإخلال بالميعاد المعين لطالب سابق، إلا بعد انقضاء المواعيد المقررة أو الفصل فى التظلم المقدم بشأن هذا الميعاد.$e430$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins43;

WITH ins44 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 41, 0, $eh440$الباب الخامس: فى أحكام القيد$eh440$, $et440$مادة 41$et440$, $e440$لا يترتب على إغفال بيان من أكثر من البيانات المنصوص عليها فى المادة الثلاثين بطلان القيد إلا إذا نتج عن ذلك ضرر للغير.
ولا يجوز أن يطلب البطلان إلا من وقع عليه الضرر بسبب إغفال البيانات أو بسبب عدم ضبطها، وللمحكمة ألا تُبطل أثر القيد إذا اقتصرت من أثره تبعاً لطبيعة الضرر ومداه.$e440$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins44;

WITH ins45 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 0, $eh450$الباب الخامس: فى أحكام القيد$eh450$, $et450$مادة 42$et450$, $e450$يقتصر أثر القيد على المبلغ المبين بالقائمة أو المبلغ المستحق أيهما أقل.$e450$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins45;

WITH ins46 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 43, 0, $eh460$الباب الخامس: فى أحكام القيد$eh460$, $et460$مادة 43$et460$, $e460$يسقط القيد إذا لم يجدد فى خلال عشر سنوات من تاريخ إجرائه. وعلى الدائن أن يجرى تجديداً قيداً جديداً إن أمكنه ذلك قانوناً، ولا يكون التجديد نافذاً إلا للمدة العشر سنوات من التاريخ الذى أجرى فيه.$e460$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins46;

WITH ins47 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 44, 0, $eh470$الباب الخامس: فى أحكام القيد$eh470$, $et470$مادة 44$et470$, $e470$تجديد القيد واجب أثناء الإجراءات التى تتخذ لنزع ملكية العقار المثقل بالحق العينى، ولكنه لا يلزم إذا اقتضى الأمر بيع العقار بوجه خاص، وبيع العقار قضاءً واقتضى بزيادة العشر.$e470$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins47;

WITH ins48 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 45, 0, $eh480$الباب الخامس: فى أحكام القيد$eh480$, $et480$مادة 45$et480$, $e480$لا يجوز محو القيد إلا برضاء الدائن بمقتضى إقرار رسمى منه أو بمقتضى حكم نهائى. ومع ذلك يُكتفى فى إجراء المحو فى حالة رهن العقار وحقوق الامتياز العقارية بإقرار محرر مُصدَّق على التوقيع فيه.$e480$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins48;

WITH ins49 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 46, 0, $eh490$الباب الخامس: فى أحكام القيد$eh490$, $et490$مادة 46$et490$, $e490$إذا أُلغِيَ المحو، عادت للقيد مرتبته الأصلية، ولكن لا يكون لهذا الإلغاء أثر فيما بين الغير بالنسبة للقيود والتسجيلات التى أُجريت فى الفترة ما بين المحو والإلغاء.$e490$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins49;

WITH ins50 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 47, 0, $eh500$الباب الخامس: فى أحكام القيد$eh500$, $et500$مادة 47$et500$, $e500$تكون مرتبة حق الامتياز العقارى بوقت قيده، ولو كان العقد الذى أنشأه مسجلاً.$e500$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins50;

WITH ins51 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 48, 0, $eh510$الباب السادس: فى شهر حق الإرث$eh510$, $et510$مادة 48$et510$, $e510$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): يقدم الطلب الخاص بشهر حق الإرث للمأمورية التى يقع العقار فى دائرة اختصاصها، ويجب أن يكون موقعاً من الوارث طالب الشهر أو من يقوم مقامه أو من ذى الشأن وأن يشتمل على بيانات المورث والورثة، وكذلك البيانات والمستندات المنصوص عليها بالمادة (22/ ثانياً وثالثاً ورابعاً) من هذا القانون.$e510$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins51;

WITH ins52 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 49, 0, $eh520$الباب السادس: فى شهر حق الإرث$eh520$, $et520$مادة 49$et520$, $e520$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): يجب أن يرفق بالطلب الأوراق الآتية:
1- الإشهاد الشرعى أو الحكم أو غير ذلك من المستندات المثبتة لحق الإرث.
2- سند ملكية المورث على أن يراعى فى شأنه حكم المادة (23) من هذا القانون، فإذا تعذر تقديمه تتبع الأحكام الواردة فى المادة (23 مكرراً) من هذا القانون.$e520$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins52;

WITH ins53 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 50, 0, $eh530$الباب السادس: فى شهر حق الإرث$eh530$, $et530$مادة 50$et530$, $e530$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): يراعى فى شأن الطلب أحكام المادتين رقمى (25، 27) من هذا القانون.$e530$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins53;

WITH ins54 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 51, 0, $eh540$الباب السادس: فى شهر حق الإرث$eh540$, $et540$مادة 51$et540$, $e540$يُقدَّم الطالب للمأمورية قائمة جرد العقارات، ومعها صورة العقارات المؤشر عليها بقبول إجراء الشهر.
ويؤشر أمين المأمورية على قائمة الجرد وعلى السند المثبت لحق الإرث بما يفيد صلاحيتها للشهر، وذلك بعد التحقق من اشتمال هذه القائمة على البيانات الموضحة بالطلب المشابهة لطالب.
وبعد التوقيع على قائمة الجرد، يقدم الطالب أو من يقوم مقامه مع القائمة إلى مكتب الشهر المختص السند المثبت لحق الإرث وفقاً لما جاء بالمادتين 31 و32.$e540$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins54;

WITH ins55 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 52, 0, $eh550$الباب السادس: فى شهر حق الإرث$eh550$, $et550$مادة 52$et550$, $e550$تُطبَّق أحكام المواد 33 و34 و35 و36 كلما كان لذلك وجه.$e550$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins55;

WITH ins56 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 53, 0, $eh560$الباب السادس: فى شهر حق الإرث$eh560$, $et560$مادة 53$et560$, $e560$تُطبَّق أحكام المواد 48 وما يليها على حقوق الإرث التى تنشأ ابتداء من تاريخ العمل بأحكام هذا القانون. أما حقوق الإرث السابقة على هذا التاريخ فلا تُطبَّق فى شأنها المواد المذكورة إلا اختياراً.$e560$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins56;

WITH ins57 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 54, 0, $eh570$الباب السابع: أحكام وقتية$eh570$, $et570$مادة 54$et570$, $e570$لا يسرى هذا القانون على المحررات التى ثبت تاريخها رسمياً قبل أول يناير سنة 1924، ولا على الأحكام التى صدرت قبل هذا التاريخ، بل تظل هذه المحررات والأحكام خاضعة من حيث الآثار التى تترتب عليها لأحكام القوانين التى كانت سارية عليها.$e570$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins57;

WITH ins58 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 55, 0, $eh580$الباب السابع: أحكام وقتية$eh580$, $et580$مادة 55$et580$, $e580$استثناءً من حكم المادة 23، تُقبَل للشهر المحررات التى تم توثيقها أو التصديق على توقيعات المتعاقدين فيها والتى صدرت فى شأنها أحكام بصحة التعاقد أو التوقيع، أو كانت تستند فى إثبات أصل الملكية أو الحق العينى إلى محررات عرفية تحمل تاريخاً سابقاً على سنة 1924.$e580$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins58;

WITH ins59 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 56, 0, $eh590$الباب السابع: أحكام وقتية$eh590$, $et590$مادة 56$et590$, $e590$جميع المحررات التى تم شهرها وفقاً للقواعد السارية فى الجهات المختصة قبل العمل بأحكام هذا القانون تكون حجة على الكافة من وقت العمل بهذه الأحكام.$e590$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins59;

WITH ins60 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 57, 0, $eh600$الباب السابع: أحكام وقتية$eh600$, $et600$مادة 57$et600$, $e600$(نص مُستبدَل بالقانون رقم 9 لسنة 2022): استثناءً من أحكام الباب الثالث من هذا القانون، يجوز أن تُشهَر بطريق الإيداع، على الوجه المبين باللائحة التنفيذية، المحررات التى تجيز القوانين الأخرى أو قرارات رئيس الجمهورية أو قرارات رئيس مجلس الوزراء شهرها بهذا الطريق.$e600$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2022-05-06', 'active' FROM ins60;

WITH ins61 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 58, 0, $eh610$الباب السابع: أحكام وقتية$eh610$, $et610$مادة 58$et610$, $e610$لأصحاب الحيازة العقارية وحقوق الامتياز العقارية السابقة أن يقيدوا حقوقهم خلال عشر سنوات من تاريخ تسجيل العقود المرتبة لها أو خلال سنة من تاريخ العمل بهذا القانون أيهما أطول، فإذا لم يتم القيد خلال المدة المتقدمة لا يكون نافذاً بالنسبة إلى الغير بعد انقضائها، ويترتب على إجراء القيد المذكور حفظ مرتبة الحق من تاريخ تسجيل العقد المرتب له.
ويُكتفى فى إجراء هذا القيد بصورة من العقد الأصل، فإذا لم يكن العقد مشتملاً على جميع البيانات المنصوص عليها فى المادة 30 استكملها صاحب الشأن فى قائمة.
ويجب فى جميع الأحوال التصديق على توقيع صاحب الشأن فى القائمة.$e610$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins61;

WITH ins62 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 59, 0, $eh620$الباب السابع: أحكام وقتية$eh620$, $et620$مادة 59$et620$, $e620$جميع النصوص المتعلقة بالشهر العقارى فى القانون المدنى وقانون المرافعات وقانون التجارة وغيرها من القوانين يُستعاض عن عبارة "قلم كتاب المحكمة" أو "قلم الرهون" أو ما يماثلها بعبارة "مكتب الشهر".
ويُستعاض فى تلك النصوص كذلك بعبارة "أمين مكتب الشهر" عن عبارة "كاتب المحكمة" أو "كاتب الرهون" أو ما يماثلها.$e620$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins62;

WITH ins63 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 60, 0, $eh630$الباب السابع: أحكام وقتية$eh630$, $et630$مادة 60$et630$, $e630$يُلغى القانونان رقما 18 و19 لسنة 1923، وكذلك يُلغى كل نص يخالف أحكام هذا القانون.$e630$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins63;

WITH ins64 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 61, 0, $eh640$الباب السابع: أحكام وقتية$eh640$, $et640$مادة 61$et640$, $e640$على وزيرى العدل والمالية تنفيذ هذا القانون كل فيما يخصه، ويُعمل به من أول يناير التالى لتاريخ نشره بالجريدة الرسمية.$e640$
  FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '1947-01-01', 'active' FROM ins64;

-- ===== تحقق نهائى =====
DO $verify069$
DECLARE
  v_law_id uuid;
  v_total INT;
  v_versions INT;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 114 AND law_year = 1946 AND kind = 'law';
  IF v_law_id IS NULL THEN RAISE EXCEPTION 'law 114/1946 not found after seed'; END IF;
  SELECT count(*) INTO v_total FROM articles WHERE law_id = v_law_id;
  IF v_total <> 65 THEN RAISE EXCEPTION 'expected 65 articles, got %', v_total; END IF;
  SELECT count(*) INTO v_versions FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id;
  IF v_versions <> 65 THEN RAISE EXCEPTION 'expected 65 article_versions, got %', v_versions; END IF;
  RAISE NOTICE '069_seed_law_114_1946_real_estate_registration: تم بنجاح. % مادة، % نسخة.', v_total, v_versions;
END $verify069$;

COMMIT;