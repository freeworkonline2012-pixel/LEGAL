-- 066_seed_law_174_2025_criminal_procedure_code.sql
--
-- بذر قانون الإجراءات الجنائية الجديد رقم 174 لسنة 2025 (546 مادة أساسية +
-- 6 مواد إصدار = 552 صفاً)، الجزء (ب) من "استكمال رفع القوانين الناقصة" فى
-- المحور الأول من خطة التطوير ذات الأربع محاور (بعد إغلاق دفعة الإصلاحات
-- السبعة فى migrations/059-065). أولوية قصوى: القانون يحل محل قانون
-- الإجراءات الجنائية القديم رقم 150 لسنة 1950 اعتباراً من 2026-10-01 (خمسة
-- أيام فقط من تاريخ بناء هذه الهجرة، 2026-09-26).
--
-- ===== المصدر والمنهجية =====
-- المصدر: نسخة PDF رسمية الجودة (140 صفحة) لمنشور الجريدة الرسمية، العدد 45
-- مكرر (د)، الصادر فى 12 نوفمبر 2025 (lawhub.info — رابط ناقل تم التحقق من
-- تطابق نصه الحرفى مع صيغة الإصدار الرسمية: عنوان القانون، ديباجة "باسم
-- الشعب / رئيس الجمهورية"، وتوقيع "عبد الفتاح السيسى" فى ختام مواد
-- الإصدار). طبقة النص الداخلية فى ملف الـ PDF نظيفة (غير مكسورة الترميز)،
-- فاعتُمد استخراج آلى مُدقَّق (pdftotext -layout ثم تطبيع NFKC + إزالة رموز
-- التحكم الاتجاهى bidi) بدل القراءة البصرية اليدوية الكاملة لـ140 صفحة —
-- قرار كفاءة واعٍ نظراً لضيق الموعد (خمسة أيام)، عوّضه تحقّق برمجى صارم:
--   • ترقيم متصل 1-546 بلا أى فجوة أو تكرار (تحقَّق آلياً).
--   • صفر مادة فارغة من أصل 546 (تحقَّق آلياً).
--   • صفر حرف من نطاق Private Use Area (\uE000-\uF8FF) متسرّب من زخرفة
--     خط التوقيع/الخاتمة فى نهاية الوثيقة (اكتُشف تسرّبه فى المادة 546
--     تحديداً أثناء الاستخراج الأول، وأُزيل بفلتر صريح، وأُعيد التحقق من
--     خلوّ كل الـ546 مادة منه بعد الإصلاح).
--   • تدقيق بصرى عينى لعيّنة تغطى بداية كل كتاب من كتب القانون الستة (مواد
--     1، 212، 380، 432، 508، 522) ونقاط متفرقة (12، 50، 100، 150، 200،
--     250، 300، 350، 400، 450، 500، 546) — تطابق تام، بلا تسرّب عناوين
--     أبواب/فصول داخل متن المواد.
--   • مواد الإصدار الست (نُسخت يدوياً حرفياً من أول صفحتين من الوثيقة، وهى
--     نصّية قصيرة يسهل التحقق البصرى المباشر منها بلا حاجة لاستخراج آلى):
--     تؤكد رقم القانون (174/2025)، تاريخ الإصدار (12 نوفمبر 2025)، تاريخ
--     النفاذ (1 أكتوبر 2026 — "اعتباراً من الأول من أكتوبر التالي لتاريخ
--     نشره")، وإلغاء صريح للقانون 150/1950 وللقانون 140/2014 (تسليم
--     المتهمين ونقل المحكوم عليهم).
--
-- ===== قرار معمارى: فئة جديدة 'criminal_procedure' =====
-- أُضيفت للقائمة الموحَّدة الوحيدة لقيد laws_category_check فى
-- migrations/020 (وليس بنسخة DROP+ADD جديدة هنا، التزاماً بالتحذير الصريح
-- المكتوب فى رأس ذلك الملف) — لأن الإجراءات الجنائية مجال تشريعى رئيسى
-- مستقل، لا تخصص تنظيمى/مالى كبقية الفئات الحالية.
--
-- ===== ⚠️ فجوة معمارية مكتشفة أثناء بناء هذه الهجرة (تتطلب قراراً منفصلاً) =====
-- استعلامات الاسترجاع الحالية (questions.service.ts، عدة مواضع: نحو
-- الأسطر 914، 968، 1104، 1186) تنضم لآخر نسخة سارية بشرط
-- `av.effective_to IS NULL` فقط — بلا أى شرط `av.effective_from <=
-- CURRENT_DATE`. هذا يعنى: فور نشر هذه الهجرة (066)، ستبدأ خدمة الإجابة
-- فوراً فى الاستشهاد بمواد قانون 174/2025 كنص سارٍ فعلياً — رغم أن تاريخ
-- نفاذه الحقيقى 2026-10-01 (خمسة أيام لاحقة لتاريخ هذه الهجرة). لم يظهر
-- هذا العيب فى أى هجرة سابقة (migrations/055، قرار 45/2026) لأن تاريخ
-- نفاذه كان بالفعل ماضياً وقت إدراجه. هذه أول حالة فعلية تُصادِف الفجوة.
-- effective_from أدناه يحمل التاريخ الحقيقى (2026-10-01) بلا تزييف (التزاماً
-- بقاعدة "لا اختلاق")، وقد أُبلِغ رجل الأعمال صراحة بهذه الفجوة مع توصية
-- بإصلاح جذرى منفصل (إضافة الشرط الزمنى لمواضع الاستعلام الأربعة) كي لا
-- تُعرَض إجابات تستشهد بقانون لم يبدأ نفاذه بعد خلال نافذة الخمسة أيام.
--
-- ===== الحالة السابقة =====
-- لا يوجد أى صف بـ(law_no=174, law_year=2025) فى laws إطلاقاً قبل هذه
-- الهجرة (تحقُّق مباشر عبر Railway MCP قبل بناء الملف).
--
-- قابلة لإعادة التشغيل بأمان (idempotent): ON CONFLICT (country_code,
-- law_no, law_year, kind) DO NOTHING على laws، وON CONFLICT (law_id,
-- article_no, article_suffix_order) DO NOTHING على كل مادة.

BEGIN;

-- ===== laws =====
INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
VALUES (
  174, 2025,
  $law174t1$القانون رقم 174 لسنة 2025 بإصدار قانون الإجراءات الجنائية$law174t1$,
  $law174s2$قانون الإجراءات الجنائية 174/2025$law174s2$,
  'criminal_procedure', 'law', 'in_force', NULL, '2025-11-12'
)
ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING;

-- ===== مواد الإصدار الست (article_suffix_order = -1) =====

WITH inse1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, -1, $eh15$القانون الأصلى (مواد إصدارية)$eh15$, $et14$المادة الأولى إصدار$et14$, $e13$مع عدم الإخلال بالأحكام الإجرائية المنصوص عليها في القوانين الأخرى، يعمل بأحكام هذا القانون والقانون المرافق له في شأن الإجراءات الجنائية.$e13$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM inse1;

WITH inse2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, -1, $eh28$القانون الأصلى (مواد إصدارية)$eh28$, $et27$المادة الثانية إصدار$et27$, $e26$يستمر نظر الطعون في الأحكام الغيابية الصادرة في مواد الجنح قبل سريان هذا القانون بذات الأوضاع والإجراءات المقررة قبل العمل به.$e26$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM inse2;

WITH inse3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, -1, $eh311$القانون الأصلى (مواد إصدارية)$eh311$, $et310$المادة الثالثة إصدار$et310$, $e39$لا تسري أحكام الاستئناف في مواد الجنايات إلا على الدعاوى التي لم يفصل فيها من محاكم الجنايات اعتبارا من تاريخ العمل بالقانون رقم 1 لسنة 2024 بتعديل بعض أحكام قانون الإجراءات الجنائية.$e39$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM inse3;

WITH inse4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, -1, $eh414$القانون الأصلى (مواد إصدارية)$eh414$, $et413$المادة الرابعة إصدار$et413$, $e412$يلغى قانون الإجراءات الجنائية الصادر بالقانون رقم 150 لسنة 1950، والقانون رقم 140 لسنة 2014 في شأن الأحكام الخاصة بتسليم المتهمين ونقل المحكوم عليهم، كما يلغى كل حكم يخالف أحكام هذا القانون والقانون المرافق له.$e412$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM inse4;

WITH inse5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, -1, $eh517$القانون الأصلى (مواد إصدارية)$eh517$, $et516$المادة الخامسة إصدار$et516$, $e515$مع عدم الإخلال بما ورد في شأنه نص خاص في القانون المرافق بشأن الاختصاص بإصدار القرارات التنفيذية، يصدر وزير العدل القرارات اللازمة لتنفيذ أحكام هذا القانون والقانون المرافق له، وإلى حين صدور هذه القرارات يستمر العمل بالقرارات المعمول بها بما لا يتعارض مع أحكام هذا القانون والقانون المرافق له.$e515$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM inse5;

WITH inse6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, -1, $eh620$القانون الأصلى (مواد إصدارية)$eh620$, $et619$المادة السادسة إصدار$et619$, $e618$ينشر هذا القانون في الجريدة الرسمية، ويعمل به اعتبارا من الأول من أكتوبر التالي لتاريخ نشره.

يبصم هذا القانون بخاتم الدولة، وينفذ كقانون من قوانينها.

صدر برئاسة الجمهورية فى 21 جمادى الأولى سنة 1447هـ (الموافق 12 نوفمبر سنة 2025م).

عبد الفتاح السيسى$e618$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM inse6;

-- ===== المواد الموضوعية 1-546 (article_suffix_order = 0) =====

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, $h122$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h122$, $t123$مادة (1)$t123$, $b121$تتولى النيابة العامة التحقيق ،وتحريك ،ومباشرة الدعوى الجنائية ،ولا تتخذ هـذه الإجراءات من غيرها إلا في الأحوال المحددة في القانون.
ولا يجوز ترك الدعوى الجنائية ،أو وقفها ،أو تعطيل سـيرها إلا فـي الأحـوال المحددة في القانون.$b121$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, $h225$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h225$, $t226$مادة (2)$t226$, $b224$يتولى النائب العام بنفسه أو بواسطة أحد أعضاء النيابة العامة مباشـرة الـدعوى الجنائية على النحو المبين بالقانون.$b224$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $h328$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h328$, $t329$مادة (3)$t329$, $b327$لا يجوز رفع الدعوى الجنائية أو اتخاذ أي إجراء من إجـراءات التحقيـق فيهـا إلا بناء على شكوى شفهية أو كتابية من المجني عليه أو من وكيله الخاص ،إلى النيابة العامة أو إلى أحد مأموري الضبط القضائي في الجرائم المنصوص عليها في المـواد ٣٠٨ ،٣٠٧ ،٣٠٦ ،٣٠٣ ،٢٩٣ ،٢٩٢ ،٢٧٩ ،٢٧٧ ،٢٧٤ ،١٨٥مـــن قـــانون العقوبات ،وكذلك في الأحوال الأخرى التي ينص عليها القانون.
ولا تقبل الشكوى بعد تسعين يوما من يوم علم المجني عليه بالجريمة وبمرتكبهـا ما لم ينص القانون على خلاف ذلك.$b327$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $h431$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h431$, $t432$مادة (4)$t432$, $b430$إذا تعدد المجني عليهم ،يكفي أن تقدم الشكوى من أحدهم.
وإذا تعدد المتهمون وكانت الشكوى مقدمة ضد أحدهم ،تعتبر مقدمة ضد الباقين.$b430$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $h534$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h534$, $t535$مادة (5)$t535$, $b533$تقدم الشكوى ممن له الولاية على المجني عليه إذا لم يبلغ خمـس عـشرة سـنة كاملة ،أو كان مصابا باضطراب نفسي أو عقلي.
وإذا كانت الجريمة واقعة على المال ،تقبل الشكوى كذلك من الوصي أو القيم.
وتسري جميع الأحكام الخاصة بالشكوى على الحالات المـشار إليهـا بـالفقرتين الأولى والثانية من هذه المادة.$b533$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $h637$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h637$, $t638$مادة (6)$t638$, $b636$تقوم النيابة العامة مقام المجنى عليه إذا لم يكن له مـن يمثلـه أو إذا تعارضـت مصلحته مع مصلحة من يمثله.$b636$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, $h740$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h740$, $t741$مادة (7)$t741$, $b739$ينقضي الحق في الشكوى بموت المجني عليه ،وإذا حـدث المـوت بعـد تقـديم الشكوى فلا يؤثر على سير الدعوى الجنائية.$b739$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, $h843$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h843$, $t844$مادة (8)$t844$, $b842$لا يجوز رفع الدعوى الجنائية أو اتخاذ أي إجراء من إجـراءات التحقيـق فيهـا إلا بناء على طلب كتـابي مـن وزيـر العـدل فـي الجـرائم المنـصوص عليهـا في المادتين  ١٨٢ ،١٨١من قانون العقوبات ،وكذلك في الأحوال الأخرى التي يـنص عليها القانون.$b842$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins8;

WITH ins9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, $h946$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h946$, $t947$مادة (9)$t947$, $b945$لا يجوز رفع الدعوى الجنائية في الجرائم المنصوص عليهـا فـي المـادة ١١٦ مكررا )أ( من قانون العقوبات ،إلا من النائب العام أو محامٍ عام على الأقل.
وفيما عدا الجرائم المشار إليها في المادة  ١٢٣من قانون العقوبات ،لا يجوز رفع الدعوى الجنائية ضد موظف عام أو مستخدم عام أو أحد رجال الضبط لجنحة وقعـت منه أثناء تأدية وظيفته أو بسببها إلا من رئيس نيابة على الأقل.$b945$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins9;

WITH ins10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, $h1049$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h1049$, $t1050$مادة (10)$t1050$, $b1048$لا يجوز رفع الدعوى الجنائية أو اتخاذ أي إجراء من إجراءات التحقيق فيهـا إلا بناء على طلب كتابي من الهيئة أو رئيس المـصلحة المجنـي عليهـا فـي الجـرائم المنصوص عليها في المادة  ١٨٤من قانون العقوبات.$b1048$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins10;

WITH ins11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, $h1152$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h1152$, $t1153$مادة (11)$t1153$, $b1151$في جميع الأحوال التي يشترط فيها القانون لرفع الدعوى الجنائية تقـديم شـكوى أو طلب أو الحصول على إذن من المجني عليه أو غيره ،لا يجوز اتخـاذ إجـراءات التحقيق فيها إلا بعد تقديم هذه الشكوى أو الطلب أو الحصول على هذا الإذن.
واستثناء من حكم الفقرة الأولى من هذه المادة يجوز اتخـاذ إجـراءات التحقيـق في الدعوى الجنائية دون حاجة إلى تقديم شكوى أو طلـب أو الحـصول علـى إذن، في الجرائم المنصوص عليها في المواد  ٣٠٨ ،٣٠٧ ،٣٠٦ ،٣٠٣ ،١٨٥مـن قـانون العقوبات إذا كان المجني عليه فيها موظف ًا عاما أو شخـصا ذا صـفة نيابيـة عامـة أو مكلف ًا بخدمة عامـة وكـان ارتكـاب الجريمـة بـسبب أداء الوظيفـة أو النيابـة أو الخدمة العامة.$b1151$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins11;

WITH ins12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, $h1255$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الأول تحريك الدعوى الجنائية والقيود التي ترد عليه$h1255$, $t1256$مادة (12)$t1256$, $b1254$يجوز لمن قدم الشكوى أو الطلب في الأحوال المشار إليهـا فـي هـذا الفـصل، وللمجني عليه في الجرائم المنصوص عليها فـي المـواد ،٣٠٧ ،٣٠٦ ،٣٠٣ ،١٨٥ ٣٠٨من قانون العقوبات إذا كان موظف ًا عاما أو شخصا ذا صفة نيابية عامة أو مكلف ًـا بخدمة عامة وكان ارتكاب الجريمة بسبب أداء الوظيفة أو النيابة أو الخدمـة العامـة، أن يتنازل عن الشكوى أو الطلب في أي حالة تكون عليها الدعوى ولو بعد صـيرورة الحكم بات ًا ،ويترتب على التنازل انقضاء الدعوى الجنائية ،وتأمر النيابة العامة بوقـف تنفيذ العقوبة إذا تم التنازل أثناء تنفيذها.
وفي حالة تعدد المجني عليهم لا يعتبر التنازل صحيحا إلا إذا صدر من جميع من قدموا الشكوى.
ويعد التنازل بالنسبة لأحد المتهمين تنازلا ً للباقين.
وإذا مات الشاكي لا ينتقل حقه في التنازل إلى ورثته ،إلا في دعوى الزنا يجـوز لأىِ من أولاد الزوج الشاكي من الزوج المشكو منه أن يتنازل عن الـشكوى ويترتـب على التنازل انقضاء الدعوى الجنائية.$b1254$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins12;

WITH ins13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, $h1358$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثاني إقامة الدعوى الجنائية من محكمة الجنايات أو محكمة النقض$h1358$, $t1359$مادة (13)$t1359$, $b1357$إذا رأت محكمة جنايات أول درجة في دعوى مرفوعة أمامها أن هناك متهمـين غير من أقيمت الدعوى عليهم أو وقائع أخرى غير المسندة فيها إلـيهم ،أو أن هنـاك جناية أو جنحة مرتبطة بالتهمة المعروضة عليها ،يجوز لها أن تقيم الدعوى الجنائيـة على هؤلاء الأشخاص أو بالنسبة لهذه الوقائع وت ُحيلها إلـى النيابـة العامـة لتحقيقهـا والتصرف فيها طبق ًا للباب الثالث من الكتاب الأول من هذا القانون.
ويجوز للمحكمة أن تندب أحد أعضائها للقيام بإجراءات التحقيق ،وفي هذه الحالة تسري على العضو المنتدب جميع الأحكام الخاصة بقاضي التحقيق.
وإذا صدر قرار في نهاية التحقيق بإحالة الدعوى إلى المحكمة ،وجب إحالتها إلى محكمة أخرى ،ولا يجوز أن يشترك في الحكم فيها أحد القضاة الـذين قـرروا إقامـة الدعوى.
وإذا كانت المحكمة لم تفصل في الدعوى الأصلية وكانت مرتبطة مـع الـدعوى المقامة منها ارتباط ًا لا يقبل التجزئة ،وجب إحالة الدعوى كلها إلى محكمة أخرى.$b1357$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins13;

WITH ins14 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, $h1461$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثاني إقامة الدعوى الجنائية من محكمة الجنايات أو محكمة النقض$h1461$, $t1462$مادة (14)$t1462$, $b1460$يجوز لمحكمة الجنايات المستأنفة ،وللدائرة الجنائية بمحكمة الـنقض عنـد نظـر الموضوع ،إقامة الدعوى الجنائية ،طبقا لما هو مقرر بالمادة  ١٣من هذا القانون.
وإذا طعن في الحكم الذي يصدر في الدعوى المقامة منها ،فلا يجوز أن يـشترك في نظرها أحد القضاة الذين قرروا إقامتها.$b1460$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins14;

WITH ins15 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, $h1564$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثاني إقامة الدعوى الجنائية من محكمة الجنايات أو محكمة النقض$h1564$, $t1565$مادة (15)$t1565$, $b1563$يجوز لمحكمة الجنايات بدرجتيها أو محكمة النقض إذا وقعت أفعال مـن شـأنها الإخلال بأوامرها ،أو بالاحترام الواجب لها ،أو التأثير في قضائها ،أو فـي الـشهود، وكان ذلك بصدد طلب أو دعوى منظورة أمامها أن تقيم الدعوى الجنائية على المـتهم طبق ًا للمادة  ١٣من هذا القانون.$b1563$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins15;

WITH ins16 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, $h1667$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثالث انقضاء الدعوى الجنائية$h1667$, $t1668$مادة (16)$t1668$, $b1666$تنقضي الدعوى الجنائية بموت المتهم ،أو بمضي المدة ،أو بصدور حكـم بـات فيها ،أو بالعفو الشامل ،أو بالصلح أو التصالح أو بالأسـباب الأخـرى التـي يـنص عليها القانون.
ولا يمنع موت المتهم أثناء نظر الدعوى مـن الحكـم بالمـصادرة فـي الحالـة المنصوص عليها في الفقرة الثانية من المادة  ٣٠من قانون العقوبات.
ولا يحول انقضاء الدعوى الجنائية بعد رفعهـا لأي سـبب دون الحكـم بـالرد في الأحوال المنصوص عليها فى القانون ،أو القضاء بأية عقوبات ماليـة منـصوص عليها في البابين الثالث والرابع من الكتاب الثاني من قانون العقوبات.$b1666$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins16;

WITH ins17 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, $h1770$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثالث انقضاء الدعوى الجنائية$h1770$, $t1771$مادة (17)$t1771$, $b1769$تنقضى الدعوى الجنائية فى مواد الجنايات بمضى عشر سنين مـن يـوم وقـوع الجريمة ،وفى مواد الجنح بمضى ثلاث سنين ،وفى مواد المخالفات بمضى سنة ،ما لم ينص القانون على خلاف ذلك.
واستثناء من حكم الفقرة الأولى من هذه المادة لا تنقضى بمضى المـدة الـدعوى الجنائية الناشئة عن الجـرائم المنـصوص عليهـا فـى المـواد ،١٢٧ ،١٢٦ ،١١٧ ١٦١مكــررا ٣٠٩ ،٢٨٢ ،٢٨١ ،٢٨٠ ،مكــررا ٣٠٩ ،مكــررا )أ( والجــرائم المنصوص عليها فى الباب الأول والقسم الأول من الباب الثانى مـن الكتـاب الثـانى من قانون العقوبات.
ومع عدم الإخلال بأحكام الفقرتين الأولى والثانية من هذه المـادة لا تبـدأ مـدة انقضاء الدعوى الجنائية فى الجرائم المنصوص عليها فى البابين الثالث والرابـع مـن الكتاب الثانى من قانون العقوبات ،والتى تقع من موظف عام إلا مـن تـاريخ انتهـاء الخدمة أو زوال الصفة ما لم يبدأ التحقيق فيها قبل ذلك.$b1769$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins17;

WITH ins18 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, $h1873$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثالث انقضاء الدعوى الجنائية$h1873$, $t1874$مادة (18)$t1874$, $b1872$لا يوقف سريان المدة التي تنقضي بها الدعوى الجنائية لأي سبب.$b1872$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins18;

WITH ins19 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, $h1976$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثالث انقضاء الدعوى الجنائية$h1976$, $t1977$مادة (19)$t1977$, $b1975$تنقطع المدة التي تنقضي بها الدعوى الجنائيـة بـإجراءات التحقيـق أو الاتهـام والمحاكمة ،وكذلك بالأمر الجنائي ،أو بإجراءات الاستدلال إذا اتخذت فـي مواجهـة المتهم ،أو إذا أخطر بها بوجه رسمي ،وتسري المدة من جديد ابتداء من يوم الانقطاع.
وإذا تعددت الإجراءات التي تقطع المدة فإن سريان المدة مـن جديـد يبـدأ مـن تـاريخ آخر إجراء.
وإذا تعدد المتهمون فإن انقطاع المدة بالنسبة لأحدهم يترتب عليه انقطاعها بالنسبة للباقين ولو لم تكن قد اتخذت ضدهم إجراءات قاطعة للمدة.$b1975$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins19;

WITH ins20 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, $h2079$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثالث انقضاء الدعوى الجنائية$h2079$, $t2080$مادة (20)$t2080$, $b2078$يجوز للمتهم أو وكيله الخاص التصالح في المخالفات وكذلك في الجنح التـي لا يعاقـب عليها وجوبا بغير الغرامة أو التي يعاقب عليها جواز يا بالحبس الـذي لا يزيـد حـده الأقصى على ستة أشهر.
وعلى محرر المحضر أو النيابة العامة بحسب الأحوال أن يعرض التصالح علـى المتهم أو وكيله الخاص ويثبت ذلك في المحضر.
وعلى المتهم الذي يرغب في التصالح أن يدفع قبل رفع الدعوى الجنائيـة مبلغ ًـا يعادل ثلث الحد الأقصى للغرامة المقرر للجريمة ،ويكون الدفع إلى خزانـة المحكمـة أو النيابة العامة أو إلى من يرخص له في ذلك من وزير العدل.
ولا يسقط حق المتهم في التصالح برفع الدعوى الجنائية إلى المحكمة المختـصة إذا دفع ثلثي الحد الأقصى للغرامة المقرر للجريمة أو قيمة الحد الأدنى المقـرر لهـا أيهما أكثر ،وذلك قبل صدور حكم في الموضوع.
وتنقضي الدعوى الجنائية بدفع مبلغ التصالح ،ولا يكون لهذا الانقضاء أثر علـى الدعوى المدنية.$b2078$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins20;

WITH ins21 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, $h2182$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثالث انقضاء الدعوى الجنائية$h2182$, $t2183$مادة (21)$t2183$, $b2181$يجوز للمجني عليه أو وكيله الخاص ،ولورثة المجنى عليه أو وكـيلهم الخـاص، إثبات الصلح مع المتهم أمام النيابة العامة أو المحكمة بحسب الأحوال ،وذلك في الجنح والمخالفات المنصوص عليها في المواد ) /٢٣٨الفقـرتين الأولـى والثانيـة(/٢٤١ ، )الفقرتين الأولى والثانية() /٢٤٢ ،الفقرات الأولى والثانية والثالثة() /٢٤٤ ،الفقـرتين الأولى والثانية( ٣٢١ ،٢٦٥ ،مكررا ٣٢٣ ،٣٢٣ ،مكررا ٣٢٣ ،مكـررا "أولا ً"٣٢٤ ، ـى ـرتين الأولـ ـررا) /٣٦١ ،٣٦٠ ،٣٥٨ ،٣٥٤ ،٣٤٢ ،٣٤١ ،٣٤٠ ،٣٣٦ ،الفقـ مكـ ـود ،(٩ ،٧ ،٦ ـد ) /٣٧٨ ،(٩البنـ ـة() /٣٧٧ ،٣٧٣ ،٣٧١ ،٣٧٠ ،٣٦٩ ،البنـ والثانيـ ) /٣٧٩البند  (٤من قانون العقوبات ،وفي الأحوال الأخرى التي ينص عليها القانون.
ويجوز للمتهم أو وكيله الخاص إثبات الـصلح المـشار إليـه فـي الفقـرة الأولـى من هذه المادة.
ويجوز الصلح في أية حالة كانت عليها الدعوى ،وبعد صيرورة الحكم بات ًا.
ويترتب على الصلح انقضاء الدعوى الجنائية ولو كانت مرفوعة بطريق الادعـاء المباشر ،وتأمر النيابة العامة بوقف تنفيذ العقوبة إذا حصل الصلح قبل أو أثناء تنفيذها، ولا أثر للصلح على حقوق المضرور من الجريمة.$b2181$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins21;

WITH ins22 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, $h2285$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثالث انقضاء الدعوى الجنائية$h2285$, $t2286$مادة (22)$t2286$, $b2284$مع عدم الإخلال باختصاصات رئـيس الجمهوريـة فـي العفـو عـن العقوبـة أو تخفيفها ،يجوز لورثة المجني عليه أو وكيلهم الخاص إثبات الصلح في أيـة حالـة كانت عليها الدعوى إلى أن يصدر فيها حكم بات في الجرائم المنصوص عليهـا فـي المواد ) /٢٣٤ ،٢٣٣ ،٢٣٠الفقرتين الأولى والثانية() /٢٣٦ ،٢٣٥ ،الفقـرة الأولـى( من قانون العقوبات ،ويترتب على الصلح في هذه الحالة تخفيف العقوبـة وفق ًـا لحكـم المادة  ١٧من قانون العقوبات.$b2284$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins22;

WITH ins23 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, $h2388$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الأول الدعوى الجنائية - الفصل الثالث انقضاء الدعوى الجنائية$h2388$, $t2389$مادة (23)$t2389$, $b2387$يجوز التصالح في الجرائم المنصوص عليها في الباب الرابع من الكتاب الثـاني من قانون العقوبات ويكون التصالح بموجب تسوية بمعرفة لجنة من الخبـراء يـصدر بتشكيلها قرار من رئيس مجلس الوزراء ويحرر محضر يوقعه أطرافه يعرض علـى مجلس الوزراء لاعتماده ولا يكون التصالح نافذ ًا إلا بهذا الاعتماد ويعد اعتماد مجلـس الوزراء توثيق ًا له دون رسوم ويكون لمحضر التصالح في هـذه الحالـة قـوة الـسند التنفيذي ،ويتولى مجلس الوزراء إخطار النائب العام سواء كانت الدعوى ما زالت قيـد التحقيق أو المحاكمة ويترتب عليه انقضاء الدعوى الجنائية عن الواقعة محل التـصالح بجميع أوصافها وتأمر النيابة العامة بوقف تنفيذ العقوبات المحكوم بها على المتهمـين في الواقعة إذا تم التصالح قبل صيرورة الحكم بات ًا ،فإذا تم التـصالح بعـد صـيرورة الحكم بات ًا وكان المحكوم عليه محبوسا نفاذ ًا لهذا الحكم جاز له أو لوكيلـه الخـاص أن يتقدم إلى النائب العام بطلب لوقف التنفيذ مشفوعا بالمستندات المؤيدة له ،ويرفع النائب العام الطلب إلى محكمة النقض مشفوعا بهذه المستندات ومذكرة برأي النيابـة العامـة وذلك خلال عشرة أيام من تاريخ تقديمه ،ويعرض علـى إحـدى الـدوائر الجنائيـة بالمحكمة منعقدة في غرفة المشورة لنظره لتأمر بقرار مسبب بوقف تنفيـذ العقوبـات نهائيا إذا تحققت من إتمام التصالح واستيفائه جميع الشروط والإجراءات المنـصوص عليها في هذه المادة ويكون الفصل في الطلب خلال خمسة عشر يومـا مـن تـاريخ عرضه وبعد سماع أقوال النيابة العامة والمحكوم عليه.
وفي جميع الأحوال ،يمتد أثر التصالح إلى جميع المتهمين أو المحكوم عليهم دون المساس بمسئوليتهم التأديبية ويقدم طلب التصالح مـن المـتهم أو المحكـوم عليـه أو وكيلهما الخاص ،ويجوز للأخير اتخاذ جميع الإجراءات المتعلقـة بإعـادة إجـراءات المحاكمة في غيبة المحكوم عليه في الأحكام الصادرة غيابيا.$b2387$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins23;

WITH ins24 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, $h2491$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h2491$, $t2492$مادة (24)$t2492$, $b2490$يتولى مأمور الضبط القضائي البحث عن الجرائم ومرتكبيها ،وجمع الاسـتدلالات التي تلزم للتحقيق والدعوى.$b2490$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins24;

WITH ins25 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, $h2594$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h2594$, $t2595$مادة (25)$t2595$, $b2593$مأمورو الضبط القضائي تابعون للنائب العام وخاضعون لإشـرافه فيمـا يتعلـق بأعمال وظائف الضبط القضائى.
ويجوز للنائب العام أن يطلب إلى الجهة المختصة النظر في أمر كل من تقع منـه مخالفة لواجباته ،أو تقصير في عمله ،وله أن يطلب إحالته إلـى المحاكمـة التأديبيـة، وهذا كله لا يمنع من رفع الدعوى الجنائية.$b2593$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins25;

WITH ins26 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 26, 0, $h2697$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h2697$, $t2698$مادة (26)$t2698$, $b2696$يكون من مأموري الضبط القضائي في دوائر اختصاصهم: .١أعضاء النيابة العامة ومعاونوها.
.٢ضباط الشرطة وضباط الشرف وأمناؤها والمـساعدون ومراقبـو ومنـدوبو الشرطة وضباط الصف ومعاونو الأمن.
.٣العمد ،ومشايخ البلاد ،ومشايخ الخفراء.
.٤نظار ووكلاء محطات السكك الحديدية الحكومية.
ولمديري الأمن ،ومفتشي قطاع التفتيش والرقابـة بـوزارة الداخليـة أن يـؤدوا الأعمال التي يقوم بها مأمورو الضبط القضائي في دوائر اختصاصهم.
ويكون من مأموري الضبط القضائي في جميع أنحاء الجمهورية: .١مدير ،وضباط ،وأمناء ،ومساعدو ،ومراقبـو ومنـدوبو الـشرطة ،وضـباط الصف ومعاونو الأمن بقطاع الأمن الوطني بوزارة الداخلية وفروعه ومكاتبـه علـى مستوى الجمهورية.
.٢مديرو ،وضباط ،وأمناء ،ومساعدو ،ومراقبو ،ومنـدوبو الـشرطة ،وضـباط الصف ومعانو الأمن بقطاع الأمن العام بوزارة الداخلية ،وفي إدارات وشعب البحـث بوزارة الداخلية.
.٣ضباط قطاع الحماية المجتمعية بوزارة الداخلية.
.٤مدير الإدارة العامة لشرطة النقل والمواصلات ،وضباط هذه الإدارة.
.٥قائد وضباط إدارة هجانة الشرطة.
.٦مفتشو وزارة السياحة.
ويجوز بقرار من وزير العدل بالاتفاق مع الوزير المختص تخويل بعض شـاغلى الوظائف العامة صفة مأموري الضبط القضائي بالنسبة إلى الجرائم التي تقع في دائرة اختصاصهم وتكون متعلقة بأعمال وظائفهم.$b2696$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins26;

WITH ins27 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 27, 0, $h27100$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h27100$, $t27101$مادة (27)$t27101$, $b2799$يجب على مأموري الضبط القضائي أن يتلقوا البلاغات والشكاوى التي ترد إليهم بشأن الجرائم ،وأن يرسلوها فورا إلى النيابة العامة ،ويجب عليهم وعلى مرءوسيهم أن يحصلوا على جميع الإيضاحات ،ويجروا المعاينات اللازمة لتسهيل تحقيق الوقائع التي تبلغ إليهم ،أو التي يعلنون بها بأية كيفية كانت ،وعليهم أن يتخـذوا جميـع الوسـائل التحفظية اللازمة للمحافظة على أدلة الجريمة.
ويجب أن تثبت جميع الإجراءات التي يقـوم بهـا مـأمورو الـضبط القـضائي في محاضر موقع عليها منهم يبين بها وقت اتخاذ الإجراء ومكان حصوله ،ويجـب أن تشمل تلك المحاضر أيضا على توقيع الـشهود والخبـراء الـذين سـمعوا ،وترسـل المحاضر إلى النيابة العامة مع الأوراق والأشياء المضبوطة.
ويجب على مأموري الضبط القضائي إثبات بيانات الرقم القـومي للمـتهم فـور تحديد هويته ،وإرفاق مستخرج من هذه البيانات بالمحضر.$b2799$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins27;

WITH ins28 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 28, 0, $h28103$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h28103$, $t28104$مادة (28)$t28104$, $b28102$يجب على مأموري الضبط القضائي ومرءوسيهم ورجـال الـسلطة العامـة أن يبرزوا ما يثبت شخصياتهم وصفاتهم عند مباشرة أي عمل أو إجراء منصوص عليـه قانون ًا ،ولا يترتب على مخالفة هذا الواجب بطلان العمل أو الإجراء وذلك دون إخلال بتوقيع الجزاء التأديبي.
ويعد رجل السلطة العامة في تطبيق أحكام هذا القانون كل من هو منوط به قانون ًا المحافظة على النظام والأمن والآداب العامة ،وحماية الأرواح والأعـراض والأمـوال وعلى الأخص منع الجرائم وضبطها ،وتنفيذ مـا تفرضـه عليـه القـوانين واللـوائح من واجبات.$b28102$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins28;

WITH ins29 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 29, 0, $h29106$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h29106$, $t29107$مادة (29)$t29107$, $b29105$يجوز لكل من علم بوقوع جريمة من الجرائم التي ت ُرفع من النيابة العامـة بغيـر شكوى ،أن يبلغ النيابة العامة أو أحد مأموري الضبط القضائي بها.$b29105$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins29;

WITH ins30 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 30, 0, $h30109$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h30109$, $t30110$مادة (30)$t30110$, $b30108$يجب على كل من علم من الموظفين العموميين أو المكلفين بخدمة عامـة أثنـاء تأدية أعمالهم أو بسببها بوقوع جريمة من الجرائم التي ت ُرفع من النيابة العامـة بغيـر شكوى ،أن يبلغ فورا النيابة العامة أو أقرب مأمور ضبط قضائي.$b30108$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins30;

WITH ins31 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 31, 0, $h31112$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h31112$, $t31113$مادة (31)$t31113$, $b31111$يجوز لكل من يدعي حصول ضرر له من الجريمة أن يقيم نفسه مدعيا بحقـوق مدنية في الشكوى التي يقدمها إلى النيابة العامة أو أحد مـأموري الـضبط القـضائي، وفي هذه الحالة الأخيرة يقوم المأمور بتحويل الشكوى إلى النيابة العامة مع المحـضر الذي يحرره.
ويجوز لمدعى الضرر أن يتقدم بطلب كتابى إلى النيابة العامة فـي أي مرحلـة يثبت فيها هذا الادعاء.
ويجب على النيابة العامة عند إحالة الدعوى إلى قاضي التحقيق أن تحيـل معهـا الشكوى أو الطلب المشار إليهما.
ولا يعتبر الشاكي مدعيا بحقوق مدنية إلا إذا صرح بذلك في شكواه أو في ورقـة مقدمة منه بعد ذلك إلى النيابة العامة ،أو إذا طلب في إحداهما تعويضا ما.$b31111$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins31;

WITH ins32 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 32, 0, $h32115$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الأول مأمورو الضبط القضائي وواجباتهم$h32115$, $t32116$مادة (32)$t32116$, $b32114$يجوز لمأموري الضبط القضائي أثناء جمع الاستدلالات سماع أقوال مـن يكـون لديهم معلومات عن الوقائع الجنائية ومرتكبيها وسؤال المـتهم عـن ذلـك ،ولهـم أن يستعينوا بالأطباء وغيرهم من أهل الخبرة ويطلبوا رأيهم شفهيا أو بالكتابة.
ولا يجوز لهم تحليف الشهود أو الخبراء اليمين إلا إذا خيف ألا يستطاع فيما بعـد سماع الشهادة بيمين.$b32114$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins32;

WITH ins33 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 33, 0, $h33118$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثاني التلبس بالجريمة$h33118$, $t33119$مادة (33)$t33119$, $b33117$تكون الجريمة متلبسا بها حال ارتكابها أو عقب ارتكابها ببرهة يسيرة.
وتعتبر الجريمة متلبسا بها إذا تبع المجني عليه مرتكبهـا أو تبعتـه العامـة مـع الصياح إثر وقوعها ،أو إذا وجد مرتكبها بعد وقوعهـا بوقـت قريـب حـاملا ً آلات أو أسلحة أو أمتعة أو أوراقا أو أشياء أخرى يستدل منها على أنه فاعل أو شريك فيها، أو إذا وجدت به في هذا الوقت آثار أو علامات تفيد ذلك.$b33117$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins33;

WITH ins34 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 34, 0, $h34121$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثاني التلبس بالجريمة$h34121$, $t34122$مادة (34)$t34122$, $b34120$يجب على مأمور الضبط القضائي في حالة التلبس بجناية أو جنحة أن ينتقل فورا إلى محل الواقعة ،ويعاين الآثار المادية للجريمة ،ويحافظ عليها ،ويثبت حالة الأمـاكن والأشخاص ،وكل ما يفيد في كشف الحقيقة ،ويسمع أقوال من كان حاضـرا ،أو مـن يمكن الحصول منه على إيضاحات في شأن الواقعة ومرتكبها.
ويجب عليه أن يخطر النيابة العامة فورا بانتقاله ،وعليها بمجرد إخطارها بجنايـة متلبس بها الانتقال فورا إلى محل الواقعة متى اقتضى الأمر ذلك.$b34120$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins34;

WITH ins35 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 35, 0, $h35124$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثاني التلبس بالجريمة$h35124$, $t35125$مادة (35)$t35125$, $b35123$يجوز لمأمور الضبط القضائي عند انتقاله في حالة التلـبس بـالجرائم أن يمنـع الحاضرين من مبارحة محل الواقعة أو الابتعاد عنه حتى يتم تحرير المحضر ،وله أن يستدعي في الحال من يمكن الحصول منه على إيضاحات في شأن الواقعة.$b35123$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins35;

WITH ins36 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 36, 0, $h36127$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثاني التلبس بالجريمة$h36127$, $t36128$مادة (36)$t36128$, $b36126$إذا خالف أحد الحاضرين أمر مأمور الضبط القضائي وفق ًا للمادة  ٣٥مـن هـذا القانون ،أو امتنع أحد ممن دعاهم عن الحضور ،يذكر ذلك في المحضر ،وللنيابة العامة أن تصدر أمرا جنائيا بتغريم المخالف بغرامة لا تقل عن خمسمائة جنيه ولا تزيد على ألف جنيه.$b36126$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins36;

WITH ins37 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 37, 0, $h37130$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h37130$, $t37131$مادة (37)$t37131$, $b37129$فيما عدا حالة التلبس ،لا يجوز القبض على أحد ،أو تفتيشه ،أو حبسه ،أو تقييـد حريته بأي قيد إلا بأمر قضائي مسبب يستلزمه التحقيق.
وكل من يقبض عليه أو يحبس أو ت ُقيد حريته ،تجب معاملته بمـا يحفـظ عليـه كرامته ،ولا يجوز تعذيبه ولا ترهيبه ولا إكراهه ولا إيذاؤه بدنيا أو معنويا.
وللمتهم حق الصمت ،وكل قول يثبت أنه صدر من محتجز تحت وطأة شيء مما تقدم ،أو التهديد بشيء منه ،يهدر ولا يعول عليه.$b37129$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins37;

WITH ins38 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 38, 0, $h38133$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h38133$, $t38134$مادة (38)$t38134$, $b38132$لا يجوز حجز أو تقييد حرية أي شخص إلا في أحد مراكز الإصلاح والتأهيل أو أماكن الاحتجاز المخصصة لذلك ،ولا يجوز لمدير مركز الإصلاح والتأهيل أو القـائم على أماكن الاحتجاز قبول أي شخص فيها إلا بمقتضى حكم أو أمر قـضائي مـسبب موقع عليه من السلطة المختصة ،ولا يجوز أن يبقيه فيها بعد المدة المحددة بـالحكم أو بالأمر القضائى.$b38132$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins38;

WITH ins39 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 39, 0, $h39136$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h39136$, $t39137$مادة (39)$t39137$, $b39135$يجوز لمأمور الضبط القضائي في أحوال التلبس بالجنايات أو بالجنح التي يعاقب عليها بالحبس لمدة تزيد على ثلاثة أشهر أن يأمر بالقبض على المتهم الحاضـر الـذي توجد دلائل كافية على اتهامه.$b39135$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins39;

WITH ins40 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 40, 0, $h40139$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h40139$, $t40140$مادة (40)$t40140$, $b40138$إذا لم يكن المتهم حاضرا في الأحوال المبينة في المادة  ٣٩من هذا القانون جـاز لمأمور الضبط القضائي أن يصدر أمرا بضبطه وإحضاره ،ويثبت ذلك في المحضر.
وفي غير الأحوال المبينة في المادة  ٣٩المشار إليها ،إذا وجدت قرائن كافية على اتهام شخص بارتكاب جناية أو جنحة سرقة أو نصب أو تعدٍ شديد ومقاومـة لرجـال السلطة العامة بالقوة والعنف ،جاز لمأمور الـضبط القـضائي أن يتخـذ الإجـراءات التحفظية المناسبة ،وأن يطلب فورا من النيابة العامة أن تصدر أمرا بالقبض عليه.
وفي جميع الأحوال ،تنفذ أوامر الضبط والإحضار والإجراءات التحفظية بواسطة أحد معاوني التنفيذ أو بواسطة رجال السلطة العامة.$b40138$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins40;

WITH ins41 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 41, 0, $h41142$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h41142$, $t41143$مادة (41)$t41143$, $b41141$يجب على مأمور الضبط القضائي أن يبلغ فورا المتهم المـضبوط بـسبب تقييـد حريته ،وبالتهم المنسوبة إليه ،وأن يسمع أقواله ،وأن يحيطه بحقوقه كتابة ،وأن يمكنـه من الاتصال بذويه وبمحاميه.
وإذا لم يأت المتهم بما ينفي التهمة عنه ،يرسله مأمور الضبط القـضائي خـلال أربع وعشرين ساعة من وقت تقييد حريته إلى سلطة التحقيق المختصة.$b41141$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins41;

WITH ins42 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 42, 0, $h42145$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h42145$, $t42146$مادة (42)$t42146$, $b42144$لكل من شاهد الجاني متلبسا بجناية أو جنحة يجوز فيها قانونا الحبس الاحتياطي، أن يسلمه إلى أقرب رجل سلطة عامة دون حاجة إلى أمر بضبطه.$b42144$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins42;

WITH ins43 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 43, 0, $h43148$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h43148$, $t43149$مادة (43)$t43149$, $b43147$لرجال السلطة العامة ،في أحوال التلبس بالجنايات ،والجنح التي يجوز الحكـم فيهـا بالحبس مدة تزيد على ثلاثة أشهر أن يحضروا المتهم ويسلموه إلى أقرب مـأمور ضـبط قضائي.
ولهم ذلك أيضا في الجرائم الأخرى المتلبس بها إذا لم يمكن لهـم التثبـت مـن شخصية المتهم.$b43147$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins43;

WITH ins44 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 44, 0, $h44151$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h44151$, $t44152$مادة (44)$t44152$, $b44150$فيما عدا الأحوال المنصوص عليها في الفقرة الثانية مـن المـادة  ١١مـن هـذا القانون ،إذا كانت الجريمة المتلبس بها مما يتوقف رفع الدعوى الجنائية عنهـا علـى شكوى فلا يجوز القبض على المتهم إلا إذا صرح بالشكوى من يملك تقديمها ،ويجـوز في هذه الحالة أن تكون الشكوى لمن يكون حاضرا من رجال السلطة العامة.$b44150$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins44;

WITH ins45 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 45, 0, $h45154$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h45154$, $t45155$مادة (45)$t45155$, $b45153$يجوز للنائب العام ولأعضاء النيابة العامة ولرؤساء محاكم الاستئناف والمحـاكم الابتدائية دخول مراكز الإصلاح والتأهيل أو أمـاكن الاحتجـاز المخصـصة لإيـداع المحبوسين الكائنة في دوائر اختصاصهم ،وذلك للتأكد من عدم وجود محبوس بـصفة غير قانونية ،ومن أن أوامر التحقيق وأحكام وقرارات المحاكم يجرى تنفيذها على الوجه المبين بها وطبق ًا للأحكام المقررة قانون ًا ،ولهم أن يطلعوا على الدفاتر ،وعلـى أوامـر التنفيذ ،والقبض ،والحبس ،وأن يأخذوا صورا منها ،وأن يتصلوا بأي نزيل ،ويـسمعوا منه أي شكوى ،ويجب أن تقدم لهم كل مساعدة للحصول على المعلومات التي يطلبونها.
ويكون لقضاة التحقيق فيما يباشرونه من تحقيقات السلطات المبينة بالفقرة الأولـى من هذه المادة.$b45153$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins45;

WITH ins46 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 46, 0, $h46157$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الثالث القبض على المتهم$h46157$, $t46158$مادة (46)$t46158$, $b46156$يجوز لكل نزيل في أحد مراكز الإصلاح والتأهيـل أو الأمـاكن المـشار إليهـا في المادة  ٣٨من هذا القانون أن يقدم في أي وقت للقائم على إدارتـه شـكوى كتابـة أو شفاهة ،ويطلب منه تبليغها للنيابة العامة ،وعلى الأخير قبولها وتبليغها فـي الحـال بعد إثباتها في سجل يعد لذلك.
ويجوز لكل من علم بوجود محتجز أو نزيل بصفة غير قانونية أو في محل غيـر مخصص للحبس أن يخطِر أحد أعضاء النيابة العامة وعليه بمجرد إخطاره أن ينتقـل فورا إلى المحل الموجود به النزيل وأن يقوم بإجراء التحقيق وأن يأمر بالإفراج عـن النزيل الموجود بصفة غير قانونية وعليه أن يحرر محضرا بذلك.$b46156$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins46;

WITH ins47 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 47, 0, $h47160$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h47160$, $t47161$مادة (47)$t47161$, $b47159$للمنازل حرمة لا يجوز دخولها ،ولا تفتيشها ،ولا مراقبتها أو التنصت عليهـا ،إلا بأمر قضائي مسبب يحدد المكان والتوقيت ،والغرض منه ،ويجب تنبيه من في المنزل عند دخوله أو تفتيشه ،وإطلاعه على الأمر الصادر في هذا الشأن ،وذلك ك ُلـه علـى النحو المبين في القانون.$b47159$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins47;

WITH ins48 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 48, 0, $h48163$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h48163$, $t48164$مادة (48)$t48164$, $b48162$استثناء من حكم المادة  ٤٧من هذا القانون لرجال السلطة العامة دخول المنـازل وغيرها من المحال المسكونة في حالات الاستغاثة أو الخطـر النـاجم عـن الحريـق أو الغرق أو ما شابه ذلك.$b48162$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins48;

WITH ins49 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 49, 0, $h49166$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h49166$, $t49167$مادة (49)$t49167$, $b49165$يجوز لمأمور الضبط القضائي تفتيش المتهم فـي الأحـوال التـي يجـوز فيهـا قانون ًـا القبض عليه.
وإذا كان المتهم أنثى وجـب أن يكـون تفتيـشها بمعرفـة أنثـى ينـدبها مـأمور الضبط القضائي.$b49165$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins49;

WITH ins50 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 50, 0, $h50169$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h50169$, $t50170$مادة (50)$t50170$, $b50168$إذا قامت أثناء تفتيش منزل المتهم قرائن قوية علـى أن المـتهم أو أي شـخص موجود في المنزل يخفى معه شيئًا يفيد في كشف الحقيقـة ،يجـوز لمـأمور الـضبط القضائي أن يتخذ الإجراءات التحفظية المناسبة ،وأن يبلغ النيابة العامة فورا لاتخاذ ما تراه مناسبا.$b50168$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins50;

WITH ins51 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 51, 0, $h51172$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h51172$, $t51173$مادة (51)$t51173$, $b51171$لا يجوز التفتيش إلا للبحث عن الأشـياء الخاصـة بالجريمـة الجـاري جمـع الاستدلالات أو حصول التحقيق بشأنها.
ومع ذلك إذا ظهر عرضا أثناء التفتيش وجود أشياء تعد حيازتها جريمة ،أو تفيـد في كشف الحقيقة في جريمة أخرى ،يجوز لمأمور الضبط القضائي أن يضبطها.$b51171$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins51;

WITH ins52 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 52, 0, $h52175$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h52175$, $t52176$مادة (52)$t52176$, $b52174$لا يجوز لمأمور الضبط القضائي فض أي أوراق مختومة أو مغلفة بأية طريقـة أخرى موجودة في منزل المتهم.$b52174$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins52;

WITH ins53 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 53, 0, $h53178$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h53178$, $t53179$مادة (53)$t53179$, $b53177$يجوز لمأمور الضبط القضائي أن يضع الأختام على الأمـاكن التـي بهـا آثـار أو أشياء تفيد في كشف الحقيقة ،وله أن يقيم حراسا عليها.
ويجب عليه إخطار النيابة العامة فورا بذلك ،وعلى النيابـة العامـة إذا مـا رأت ضرورة ذلك الإجراء أن ترفعه خلال أسبوع إلى القاضي الجزئي لإقراره أو إنهائه.
ولكل ذي شأن أن يتظلم للقاضي الجزئي من الأمـر الـذي أصـدره بعريـضة يقدمها إلى النيابة العامة ،وعليها رفع التظلم إلى القاضي الجزئي خلال مـدة لا تزيـد على أسبوع.$b53177$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins53;

WITH ins54 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 54, 0, $h54181$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h54181$, $t54182$مادة (54)$t54182$, $b54180$يجوز لمأمور الضبط القضائي أن يضبط الأشياء والأوراق التي يحتمل أن تكـون قد استعملت في ارتكاب الجريمة ،أو نتجت عن ارتكابها ،أو وقعت عليها ،وكل ما يفيد في كشف الحقيقة.
وتوصف هذه الأشياء والأوراق وتعرض علـى المـتهم ،ويطلـب منـه إبـداء ملاحظاته عليها ،ويحرر بذلك محضر يوقعه المتهم ،أو يذكر فيه امتناعه عن التوقيع.$b54180$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins54;

WITH ins55 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 55, 0, $h55184$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h55184$, $t55185$مادة (55)$t55185$, $b55183$توضع الأشياء والأوراق المضبوطة وفق ًا للمادة  ٥٤من هذا القانون فـي حـرز مغلق ،ويختم عليها ،ويكتب على شريط داخل الختم تاريخ المحضر المحرر بضبطها، ويشار إلى الواقعة التى حصل الضبط من أجلها.$b55183$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins55;

WITH ins56 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 56, 0, $h56187$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h56187$, $t56188$مادة (56)$t56188$, $b56186$لا يجوز فض الأختام الموضوعة طبقـا للمـادتين  ٥٥ ،٥٣مـن هـذا القـانون إلا بحضور المتهم أو وكيله ومن ضبطت عنـده هـذه الأشـياء أو الأوراق ،أو بعـد دعوتهم لذلك.$b56186$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins56;

WITH ins57 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 57, 0, $h57190$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h57190$, $t57191$مادة (57)$t57191$, $b57189$يعاقب بالعقوبات المقررة في المادة  ٣١٠من قانون العقوبات كل من يكـون قـد وصل إلى علمه بسبب التفتيش معلومات عن الأشياء والأوراق المـضبوطة ،وأفـضى بها إلى أي شخص غير ذي صفة أو انتفع بها بأية طريقة كانت.$b57189$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins57;

WITH ins58 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 58, 0, $h58193$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h58193$, $t58194$مادة (58)$t58194$, $b58192$لمن ضبطت عنده الأوراق وكان له مصلحة عاجلة فيها ،تعطى له صورة منهـا مصدق عليها من مأمور الضبط القضائي.$b58192$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins58;

WITH ins59 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 59, 0, $h59196$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الرابع دخول المنازل وتفتيشها وتفتيش الأشخاص$h59196$, $t59197$مادة (59)$t59197$, $b59195$يجوز لمأموري الضبط القضائي في حالة قيامهم بواجباتهم أن يستعينوا مباشـرة بالقوة الجبرية.$b59195$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins59;

WITH ins60 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 60, 0, $h60199$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الخامس تصرفات النيابة العامة في التهمة بعد جمع الاستدلالات$h60199$, $t60200$مادة (60)$t60200$, $b60198$إذا رأت النيابة العامة قبل البدء فـي إجـراءات التحقيـق أن لا محـل للـسير في الدعوى تأمر بحفظ الأوراق.$b60198$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins60;

WITH ins61 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 61, 0, $h61202$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الخامس تصرفات النيابة العامة في التهمة بعد جمع الاستدلالات$h61202$, $t61203$مادة (61)$t61203$, $b61201$يجب على النيابة العامة إذا أصدرت أمرا بالحفظ أن تعلنه إلـى المجنـي عليـه والمدعى بالحقوق المدنية ،فإذا مات أحدهما يعلن الورثة جملة في محل إقامته.$b61201$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins61;

WITH ins62 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 62, 0, $h62205$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثاني جمع الاستدلالات ورفع الدعوى - الفصل الخامس تصرفات النيابة العامة في التهمة بعد جمع الاستدلالات$h62205$, $t62206$مادة (62)$t62206$, $b62204$إذا رأت النيابة العامة في مواد الجنح أن الدعوى صـالحة لرفعهـا بنـاء علـى الاستدلالات التي جمعت تكلف المتهم بالحضور مباشرة أمام المحكمة المختصة.
ويجوز في مواد الجنح التي يعينها وزير العدل بقرار منه بعـد موافقـة وزيـر الداخلية إعلان ورقة التكليف بالحضور بواسطة رجال السلطة العامة.$b62204$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins62;

WITH ins63 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 63, 0, $h63208$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h63208$, $t63209$مادة (63)$t63209$, $b63207$يجب على النيابة العامة أن تجري تحقيق ًا في الجنايات ،ولها أن تجريه في الجـنح أو غيرها إذا رأت محلا ً لذلك.
ويجري التحقيق طبق ًا للأحكام المنصوص عليها في هذا الباب.$b63207$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins63;

WITH ins64 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 64, 0, $h64211$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h64211$, $t64212$مادة (64)$t64212$, $b64210$يجوز تكليف أحد معاوني النيابة العامة بتحقيق قضية بأكملها.
كما يجوز لعضو النيابة العامة من درجة مساعد نيابة عامة على الأقل أن ينـدب أحد مأموري الضبط القضائي للقيام بعمل معين أو أكثر مـن أعمـال التحقيـق عـدا استجواب المتهم.
ويكون لمأمور الضبط القضائي المندوب في حدود ندبه كل الـسلطات المخولـة لمن ندبه ،وله أن يجري أي عمل آخر من أعمال التحقيق وأن يستجوب المـتهم فـي الأحوال التي يخشى فيها فوات الوقت متى كان متصلا ً بالعمل المندوب له ولازما فـي كشف الحقيقة.$b64210$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins64;

WITH ins65 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 65, 0, $h65214$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h65214$, $t65215$مادة (65)$t65215$, $b65213$يجوز لعضو النيابة العامة أن يطلب من نيابة أخرى خـارج دائـرة اختـصاصه إجراء بعض التحقيقات في القـضية ،علـى أن يبـين المـسائل المطلـوب تحقيقهـا والإجراءات المطلوب اتخاذها ،ولهذه النيابة أن تجري أي عمـل آخـر مـن أعمـال التحقيق وأن تستجوب المتهم ،في الأحوال التي ترى فيها لزوما لذلك ،متى كان ذلـك متصلا ً بالعمل المطلوب منها إجراؤه ولازما في كشف الحقيقة.$b65213$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins65;

WITH ins66 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 66, 0, $h66217$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h66217$, $t66218$مادة (66)$t66218$, $b66216$يجرى التحقيق باللغة العربية ،ويسمع عضو النيابـة العامـة أقـوال الخـصوم والشهود الذين يجهلون اللغة العربية بواسطة مترجم بعد أن يحلف يمين ًـا بـأن يـؤدي مهمته بالصدق والأمانة.$b66216$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins66;

WITH ins67 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 67, 0, $h67220$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h67220$, $t67221$مادة (67)$t67221$, $b67219$يستصحب عضو النيابة العامة في التحقيق أحـد ك ُتـاب النيابـة العامـة لكتابـة أو تحرير المحاضر اللازمة ،ويجوز له عند الضرورة أن يكلـف غيـره بـذلك بعـد تحليفه اليمين ،ويوقع عضو النيابة والكاتب كل صفحة من هذه المحاضر.
وت َحفظ النيابة العامة المحاضر مع باقي الأوراق.$b67219$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins67;

WITH ins68 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 68, 0, $h68223$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h68223$, $t68224$مادة (68)$t68224$, $b68222$في غير الأحوال التي تصدر فيها النيابة العامة أو سلطة التحقيق المختصة بيانات رسمية ،تعتبر إجراءات التحقيق ذاتها والنتائج التي تسفر عنها من الأسـرار ،ويجـب على أعضاء النيابة العامة وأعوانهم من ك ُتاب وخبراء وغيرهم ممن يتصلون بالتحقيق أو يحضرونه بسبب وظيفتهم أو مهنتهم عدم إفشائها ،ويعاقب من يخالف ذلـك مـنهم بالعقوبة المقررة في المادة  ٣١٠من قانون العقوبات.$b68222$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins68;

WITH ins69 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 69, 0, $h69226$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h69226$, $t69227$مادة (69)$t69227$, $b69225$يجوز لمن لحقه ضرر من الجريمة أن يدعي بحقوق مدنية أثنـاء التحقيـق فـي الدعوى ،وتفصل النيابة العامة في قبوله بهذه الصفة في التحقيق خلال ثلاثة أيام مـن تقديم هذا الادعاء.
ويجوز لمن رفض طلبه الطعن في قرار الرفض أمام محكمة الجـنح المـستأنفة منعقدة في غرفة المشورة ،خلال ثلاثة أيام تسري من تاريخ إعلانه بالقرار.$b69225$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins69;

WITH ins70 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 70, 0, $h70229$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h70229$, $t70230$مادة (70)$t70230$, $b70228$يجوز للمتهم وللمجني عليه وللمدعي بالحقوق المدنية وللمسئول عنها ولـوكلائهم أن يحضروا جميع إجراءات التحقيق ،ويجوز لعضو النيابة العامة أن يجري التحقيـق في غيبتهم متى رأى ضرورة ذلك لإظهار الحقيقة ،وفور انتهاء تلك الضرورة يمكـنهم من الاطلاع على التحقيق ،وله في حالة الاستعجال أن يباشر بعض إجراءات التحقيـق في غيبة الخصوم ،ولهؤلاء الحق في الاطلاع على الأوراق المثبتة لهذه الإجراءات.
ويحق للخصوم اصطحاب وكلائهم في التحقيق.$b70228$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins70;

WITH ins71 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 71, 0, $h71232$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h71232$, $t71233$مادة (71)$t71233$, $b71231$يخطر الخصوم باليوم الـذي يباشـر فيـه عـضو النيابـة العامـة إجـراءات التحقيق ،ومكانها.$b71231$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins71;

WITH ins72 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 72, 0, $h72235$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h72235$, $t72236$مادة (72)$t72236$, $b72234$يجب على كل من المجني عليه والمدعي بـالحقوق المدنيـة والمـسئول عنهـا أن يعين له موطن ًا مختارا في المكان الكائن فيه مقر النيابة التي يجري فيها التحقيـق، أو أن يعين رقم هاتف محمول أو بريدا إلكترونيا لإعلانه عليه.
ويجب على المتهم عقب مثوله في أي إجراء تتخذه سلطة التحقيق أن يعـين لـه موطن ًا مختارا ،أو رقم هاتف محمول أو بريدا إلكترونيا لإعلانه عليه.
وإذا لم يعين أي من الأشخاص المنصوص عليهم في الفقرتين الأولى والثانية من هذه المادة البيانات المبينة بهما ،أو كان هذا البيان ناقصا أو غير صحيح أو طرأ عليـه تغيير ولم يخطر بها ،يكون إعلانه في قلم الكتاب صحيحا.$b72234$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins72;

WITH ins73 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 73, 0, $h73238$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h73238$, $t73239$مادة (73)$t73239$, $b73237$يجوز للخصوم ولوكلائهم أن يقدموا إلى عضو النيابة العامة الـدفوع والطلبـات والملاحظات التي يرون تقديمها.$b73237$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins73;

WITH ins74 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 74, 0, $h74241$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الأول أحكام عامة$h74241$, $t74242$مادة (74)$t74242$, $b74240$يجوز للمتهم وللمجني عليه وللمدعي بالحقوق المدنية وللمسئول عنها ولـوكلائهم أن يحصلوا على نفقتهم أثناء التحقيق على صور من الأوراق أيا كـان نوعهـا ،إلا إذا اقتضت مصلحة التحقيق غير ذلك.
وفي جميع الأحوال لهم أن يحصلوا على صور الأوراق أيا كـان نوعهـا عقـب انتهاء التحقيقات إذا كان التحقيق حاصلا ً بغير حضورهم بناء على قرار صادر بـذلك أو كانت مصلحة التحقيق اقتضت ذلك.$b74240$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins74;

WITH ins75 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 75, 0, $h75244$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h75244$, $t75245$مادة (75)$t75245$, $b75243$ينتقل عضو النيابة العامة إلى أي مكان ليثبت حالة الأشخاص والأماكن والأشـياء المتعلقة بالجريمة وكل ما يلزم إثبات حالته كلما اقتضت مصلحة التحقيق ذلك.$b75243$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins75;

WITH ins76 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 76, 0, $h76247$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h76247$, $t76248$مادة (76)$t76248$, $b76246$تفتيش المنازل وملحقاتها عمل من أعمال التحقيق ،ولا يكون إلا بأمر مسبب مـن عضو النيابة العامة بناء على اتهام موجه إلى شخص مقيم في المنزل المـراد تفتيـشه بارتكاب جناية أو جنحة أو باشتراكه في ارتكابها.
ولعضو النيابة العامة أن يفتش أي مكان في حيازة المتهم ويضبط مـا فيـه مـن الأوراق والأشياء ،وكل ما يحتمل أنه است ُعمل فى ارتكـاب الجريمـة أو نـتج عنهـا أو وقعت عليه ،وكل ما يفيد فى كشف الحقيقة.$b76246$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins76;

WITH ins77 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 77, 0, $h77250$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h77250$, $t77251$مادة (77)$t77251$, $b77249$يحصل التفتيش بحضور المتهم أو من ينيبه عنه إن أمكن ذلك ،وإذا حـصل التفتـيش في منزل غير المتهم يدعى صاحبه للحضور بنفـسه أو بواسـطة مـن ينيبـه عنـه إن أمكن ذلك.$b77249$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins77;

WITH ins78 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 78, 0, $h78253$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h78253$, $t78254$مادة (78)$t78254$, $b78252$مع مراعاة حكم الفقرة الثانية من المادة  ٤٩من هـذا القـانون ،يجـوز لعـضو النيابة العامة أن يفتش المتهم أو يندب لذلك أحد مأموري الضبط القضائي بنـاء علـى أمر مسبب.$b78252$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins78;

WITH ins79 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 79, 0, $h79256$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h79256$, $t79257$مادة (79)$t79257$, $b79255$لا يجوز للنيابة العامة تفتيش غير المتهم أو غير منزله إلا إذا اتـضحت دلائـل قوية أنه حائز لأشياء تتعلق بالجريمة وتفيد في كشف الحقيقة.
ويشترط لاتخاذ هذا الإجراء الحصول مقدما على إذن مـن القاضـي الجزئـي، ويصدر القاضي هذا الإذن بعد الاطلاع على الأوراق والتحقيقات.$b79255$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins79;

WITH ins80 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 80, 0, $h80259$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h80259$, $t80260$مادة (80)$t80260$, $b80258$يجوز لعضو النيابة العامة ،بعد الحصول على إذن من القاضي الجزئـي ،أن يـصدر أمرا بضبط جميع الخطابات ،والرسائل ،والبرقيات ،والجرائد والمطبوعـات ،والطـرود، وأن يأمر بمراقبة الاتصالات السلكية واللاسلكية ،وحسابات مواقـع وتطبيقـات التواصـل الاجتماعي ومحتوياتها المختلفة غير المتاحة للكافة ،والبريد الإلكتروني ،والرسائل النـصية أو المسموعة أو المصورة على الهواتـف أو الأجهـزة أو أيـة وسـيلة تقنيـة أخـرى، وضبط الوسائط الحاوية لها أو إجراء تسجيلات لأحاديث جرت في مكـان خـاص متـى كان لذلك فائدة في ظهور الحقيقة في جناية أو جنحة معاقب عليها بالحبس لمدة تزيد علـى ثلاثة أشهر.
ويجب أن يكون الأمر بالضبط أو الاطلاع أو المراقبة أو التسجيل لمدة لا تزيـد على ثلاثين يوما.
ويصدر القاضي الإذن المشار إليه مسببا بعد اطلاعه على الأوراق والتحقيقـات، ويجوز له أن يجدده لمدة أو لمدد أخرى مماثلة.$b80258$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins80;

WITH ins81 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 81, 0, $h81262$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h81262$, $t81263$مادة (81)$t81263$, $b81261$يجوز للقاضي الجزئي بناء على طلب النيابة العامة في حالة قيام دلائل قوية على أن مرتكب إحدى الجرائم المنصوص عليها في المواد  ١٦٦مكررا ٣٠٨ ،مكررا مـن قانون العقوبات ،والبند ٢ /من المادة  ٧٦من قانون تنظيم الاتصالات الصادر بالقـانون رقم  ١٠لسنة  ٢٠٠٣قد استعان في ارتكابها بهاتف معـين ثابـت أو محمـول ،أو أي موقع إلكتروني ،أو أي وسيلة تقنية أخرى ،أن يصدر أمرا مسببا بناء على تقرير فنـي وشكوى المجني عليه في الجريمة المذكورة بوضع هذه الوسيلة أو ذلك الجهاز تحـت المراقبة لمدة لا تزيد على ثلاثين يوما قابلة للتجديد لمدة أو مدد أخرى مماثلة.$b81261$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins81;

WITH ins82 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 82, 0, $h82265$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h82265$, $t82266$مادة (82)$t82266$, $b82264$لا يجوز لعضو النيابة العامة أن يضبط لدى المـدافع عـن المـتهم أو الخبيـر الاستشاري الأوراق والمستندات التي سلمها المتهم لأيهما لأداء المهمة التي عهد إليـه بها ولا المراسلات أو تسجيل الاتصالات المتبادلة بينهما في القضية.$b82264$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins82;

WITH ins83 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 83, 0, $h83268$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h83268$, $t83269$مادة (83)$t83269$, $b83267$يجوز لعضو النيابة العامة أن يطلـع علـى الخطابـات ،والرسـائل ،والأوراق، والتسجيلات المضبوطة ،على أن يتم ذلك بحضور المتهم والحائز لها أو المرسلة إليه، إن أمكن ،وتدون ملاحظاتهم عليها.
ويجوز له حسب ما يظهر من الفحص أن يأمر بضم تلك المضبوطات إلى ملـف الدعوى أو بردها إلى من كان حائزا لها أو من كانت مرسلة إليه.$b83267$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins83;

WITH ins84 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 84, 0, $h84271$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h84271$, $t84272$مادة (84)$t84272$, $b84270$الأشياء التي تضبط يتبع نحوها حكم المادة  ٥٥من هذا القانون.$b84270$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins84;

WITH ins85 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 85, 0, $h85274$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h85274$, $t85275$مادة (85)$t85275$, $b85273$يجوز لعضو النيابة العامة أن يأمر الحائز لشيء يرى ضبطه أو الاطـلاع عليـه بتقديمه ،ويسري على من يخالف ذلك حكم المادة  ٢٨٥من هذا القانون.$b85273$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins85;

WITH ins86 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 86, 0, $h86277$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني المعاينة والتفتيش وضبط الأشياء المتعلقة بالجريمة$h86277$, $t86278$مادة (86)$t86278$, $b86276$تبلغ الخطابات والرسائل التلغرافية المضبوطة إلـى المـتهم أو المرسـلة إليـه، أو تعطى إليه صورة منها في أقرب وقت ،ما لم تقتضِ مصلحة التحقيق غير ذلك.
ويجوز لكل شخص يدعي حق ًا في الأشياء المضبوطة أن يطلب إلى عضو النيابة العامة تسليمها إليه ،وله في حالة الرفض أن يتظلم أمام محكمة الجنح المستأنفة منعقـدة في غرفة المشورة ،وأن يطلب سماع أقواله أمامها.$b86276$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins86;

WITH ins87 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 87, 0, $h87280$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h87280$, $t87281$مادة (87)$t87281$, $b87279$يجوز لعضو النيابة العامة أن يسمع شهادة من يرى لزوم سـماعه مـن الـشهود عن الوقائع التي تثبت أو تؤدي إلى ثبوت الجريمة ،وظروفها وإسـنادها إلـى المـتهم أو براءته منها.$b87279$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins87;

WITH ins88 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 88, 0, $h88283$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h88283$, $t88284$مادة (88)$t88284$, $b88282$يسمع عضو النيابة العامة شهادة الشهود الذين يطلب الخصوم سـماعهم ،ويكـون تكليفهم بالحضور بواسطة المحضرين أو أفراد السلطة العامة ،أو بإعلانهم عن طريـق الهاتف المحمول أو البريد الإلكتروني المثبت ببيانات الرقم القومي بحسب الأحوال.
ويجوز له أن يسمع شهادة أي شاهد يحضر من تلقاء نفسه ،وفى هذه الحالة يثبِت ذلك في المحضر.$b88282$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins88;

WITH ins89 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 89, 0, $h89286$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h89286$, $t89287$مادة (89)$t89287$, $b89285$يسمع عضو النيابة العامة كل شاهد على انفراد ،وله أن يواجه الـشهود بعـضهم ببعض وبالمتهم.$b89285$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins89;

WITH ins90 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 90, 0, $h90289$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h90289$, $t90290$مادة (90)$t90290$, $b90288$يجب على عضو النيابة العامة أن يتثبت من شخصية كل شاهد ،وبيان اسمه ،ولقبـه، وسنه ،ومهنته ،وسكنه ،ورقمه القومي أو رقم وثيقة سفره ،وموطنه إن كان أجنبيا ،وعلاقته بالمتهم أو المجني عليه أو المدعي بالحقوق المدنية أو المسئول عنها ويتثبت من شخصيته.$b90288$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins90;

WITH ins91 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 91, 0, $h91292$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h91292$, $t91293$مادة (91)$t91293$, $b91291$يجب على الشاهد الذي أتم الخامسة عشرة من عمره أن يحلف قبل أداء الـشهادة اليمين الآتية" :أقسم باالله العظيم أن أشهد بالحق" ،ويكون الحلف على حسب الأوضـاع الخاصة بديانته إن طلب ذلك ،ويجوز سماع من لم يتم السن المـذكورة علـى سـبيل الاستدلال بغير يمين ،وتدون هذه البيانات وشهادات الـشهود ،وإجـراءات سـماعهم في المحضر بغير كشط أو تحشير ،ولا يعتمد أي تصحيح أو شطب أو تخـريج إلا إذا صدق عليه عضو النيابة العامة والكاتب والشاهد.$b91291$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins91;

WITH ins92 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 92, 0, $h92295$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h92295$, $t92296$مادة (92)$t92296$, $b92294$يضع كل من عضو النيابة العامة والكاتب توقيعه على الشهادة أو أي ملاحظـة فـي أدائها ،وكذلك الشاهد بعد تلاوتها عليه وإقراره بأنه متمسك بها ،فإن امتنع عن وضع توقيعه أو ختمه أو بصمته أو لم يستطع أُثبت ذلك في المحضر ،مع ذكر الأسباب التي يبديها.$b92294$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins92;

WITH ins93 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 93, 0, $h93298$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h93298$, $t93299$مادة (93)$t93299$, $b93297$عند الانتهاء من سماع أقوال الشاهد ،يجوز للخصوم إبداء ملاحظاتهم عليها ولهم أن يطلبوا من عضو النيابة العامة سماع أقوال الشاهد عن نقاط أخرى يبينونها.
ويجوز لعضو النيابة العامة دائما أن يرفض توجيه أي سؤال للشاهد يكون غيـر متعلق بالدعوى أو يكون في صيغته مساس بالغير ،وعليه أن يمنع عـن الـشاهد كـل كلام بالتصريح أو بالتلميح ،وكل إشارة مما ينبني عليه اضطراب أفكاره أو تخويفه.$b93297$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins93;

WITH ins94 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 94, 0, $h94301$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h94301$, $t94302$مادة (94)$t94302$, $b94300$تسرى على الشهود أحكام المواد  ٢٨٩ ،٢٨٨ ،٢٨٧ ،٢٨٦من هذا القانون.$b94300$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins94;

WITH ins95 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 95, 0, $h95304$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h95304$, $t95305$مادة (95)$t95305$, $b95303$يجب على كل من دعي للحضور أمام النيابة العامة لتأدية شهادة أن يحضر بنـاء على الطلب المحرر له ،وإلا جاز للنيابة العامة أن تصدر أمرا جنائيا بتغريمـه مبلغ ًـا لا يجاوز خمسمائة جنيه.
ويجوز لعضو النيابة العامة أن يصدر أمرا بتكليف الشاهد بالحضور مرة أخـرى على نفقته ،أو أن يصدر أمرا مسببا بضبطه وإحضاره.
وإذا حضر الشاهد بعد تكليفه بالحضور مرة أخرى أو من تلقـاء نفـسه وطلـب إعفاءه من الغرامة أو قدم طلبا بذلك كتابة ً إذا لم يستطع الحضور بنفسه ،يجوز للنيابـة العامة إعفاؤه من الغرامة إذا أبدى عذرا مقبولا ً.$b95303$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins95;

WITH ins96 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 96, 0, $h96307$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h96307$, $t96308$مادة (96)$t96308$, $b96306$إذا امتنع الشاهد عن حلف اليمين أو أداء الشهادة جاز للنيابة العامـة أن تـصدر أمرا جنائيا بتغريمه مبلغ ًا لا يجاوز ألفي جنيه ،ويجوز إعفاؤه من الغرامة أو بعـضها إذا عدل عن امتناعه قبل انتهاء التحقيق.$b96306$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins96;

WITH ins97 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 97, 0, $h97310$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h97310$, $t97311$مادة (97)$t97311$, $b97309$إذا كان الشاهد مريضا أو لديه ما يمنعه من الحضور تسمع شـهادته فـي محـل وجوده ،فإذا انتقل عضو النيابة العامة لسماع شهادته وتبين له عدم صحة العذر ،يحكم عليه من القاضي الجزئي بالجهة التي طلب حضور الشاهد فيها بناء على طلب النيابـة العامة بالحبس مدة لا تزيد على شهر أو بالغرامة التي لا تجاوز ألفي جنيه.$b97309$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins97;

WITH ins98 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 98, 0, $h98313$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث سماع الشهود$h98313$, $t98314$مادة (98)$t98314$, $b98312$يقدر عضو النيابة العامة بناء على طلب الشهود ،المصاريف والتعويضات التـي يستحقونها بسبب حضورهم لأداء الشهادة.$b98312$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins98;

WITH ins99 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 99, 0, $h99316$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الرابع ندب الخبراء$h99316$, $t99317$مادة (99)$t99317$, $b99315$إذا اقتضى التحقيق الاستعانة بخبير وجب على عضو النيابة العامـة أن يـصدر أمرا بندبه يفصلُ فيه المهمة التي يكلف بها ،ويحلف الخبير اليمين أمام عضو النيابـة العامة بأن يؤدي عمله بالأمانة والصدق ما لم يكن من فئات الخبراء الـذين سـبق أن أدوا اليمين قبل مزاولة أعمال الخبرة.$b99315$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins99;

WITH ins100 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 100, 0, $h100319$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الرابع ندب الخبراء$h100319$, $t100320$مادة (100)$t100320$, $b100318$يحدد عضو النيابة العامة للخبير ميعادا لتقديم التقرير ،وله أن يستبدل بـه خبيـرا آخر إذا لم يقدم التقرير في الميعاد المحدد.$b100318$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins100;

WITH ins101 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 101, 0, $h101322$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الرابع ندب الخبراء$h101322$, $t101323$مادة (101)$t101323$, $b101321$يجوز لعضو النيابة العامة أن يحضر وقت مباشرة الخبير مهمته ،ويجوز للخبيـر أن يؤدي مهمته بغير حضور الخصوم.$b101321$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins101;

WITH ins102 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 102, 0, $h102325$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الرابع ندب الخبراء$h102325$, $t102326$مادة (102)$t102326$, $b102324$يجوز للخصوم أن يستعينوا بخبير استشاري ،ولهم أن يطلبوا تمكينه من الاطـلاع على الأوراق وسائر ما سبق تقديمه للخبير المنتدب من قبل النيابة العامـة ،علـى ألا يترتب على ذلك تأخير السير في الدعوى.$b102324$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins102;

WITH ins103 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 103, 0, $h103328$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الرابع ندب الخبراء$h103328$, $t103329$مادة (103)$t103329$, $b103327$يجوز للخصوم رد الخبير إذا وجدت أسباب قوية تدعو لذلك ،ويقدم طلـب الـرد مبين ًا فيه أسبابه إلى عضو النيابة العامة للفصل فيه خلال ثلاثة أيام من يوم تقديمه.
ويترتب على تقديم طلب الرد عدم استمرار الخبير في عمله من تاريخ إخطـاره بذلك ،وفى حالة الاستعجال يجوز لعضو النيابة العامـة أن يـأمر باسـتمرار الخبيـر في عمله.$b103327$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins103;

WITH ins104 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 104, 0, $h104331$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الخامس الاستجواب والمواجهة$h104331$, $t104332$مادة (104)$t104332$, $b104330$يجب على عضو النيابة العامة عند حضور المتهم لأول مرة في التحقيق أن يدون جميع البيانات الخاصة بإثبات شخصيته ،ويحيطه بحقوقه كتابة وبالتهمة المنسوبة إليه، ويثبت في المحضر ما قد يبديه في شأنها من أقوال ،وأن يمكنه من الاتـصال بذويـه ومحاميه وذلك بعد تنبيهه إلى أن من حقه الصمت ،وذلك ك ُلـه مـع مراعـاة تـوفير المساعدة اللازمة للأشخاص ذوي الإعاقة والمسنين وفق ًا للإجراءات المقررة قانون ًا.$b104330$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins104;

WITH ins105 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 105, 0, $h105334$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الخامس الاستجواب والمواجهة$h105334$, $t105335$مادة (105)$t105335$, $b105333$لا يجوز لعضو النيابة العامة أن يستجوب المتهم أو يواجهه بغيره من المتهمـين أو الشهود إلا في حضور محاميه ،فإن لم يكن للمتهم محام ،أو لم يحضر محاميه ،بعد دعوته ،وجب على المحقق من تلقاء نفسه أن يندب له محاميا.
ويجوز لعضو النيابة العامة في الأحوال التي يخشى فيها على حياة المـتهم متـى كان لازما في كشف الحقيقة الانتقال لاستجوابه ،وذلك بعدما يطلب من نقابة المحـامين الفرعية ندب أحد المحامين لحضور الاستجواب على وجه السرعة بالطريقة التي يتفق عليها بين النيابة العامة والنقابة العامة للمحامين ،فإذا لم يحضر المحامي فـي الموعـد المحدد يتم استجواب المتهم ،ويحق للمحامي الموكل أو المنتدب حضور الاستجواب إذا حضر قبل انتهائه والاطلاع على ما تم من إجراءات الاستجواب في غيبته.
وعلى المتهم أن يقرر اسم محاميه في محضر التحقيق أو في القلم الجنائي للنيابـة التي يجرى التحقيق في دائرتها أو للقائم على إدارة المكان المحبوس فيه ،كمـا يجـوز لمحاميه أن يتولى هذا التقرير.
وللمحامي أن يثبت في المحضر ما يعن له من دفوع أو طلبات أو ملاحظات.
ويصدر المحقق بعد التصرف النهائي في التحقيق بناء على طلب المحـامي المنتـدب أمرا بتقدير أتعابه ،وذلك استرشادا بجـدول تقـدير الأتعـاب الـذي يـصدر بـه قـرار من وزير العدل بعد أخذ رأي مجلس النقابة العامة للمحامين ،وتأخذ هـذه الأتعـاب حكـم الرسوم القضائية.$b105333$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins105;

WITH ins106 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 106, 0, $h106337$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الخامس الاستجواب والمواجهة$h106337$, $t106338$مادة (106)$t106338$, $b106336$يجب أن يمكن محامي المتهم من الاطـلاع علـى التحقيـق قبـل الاسـتجواب أو المواجهة بمدة كافية ما لم يقرر عضو النيابة العامة غير ذلك.
وفي جميع الأحوال ،لا يجوز الفصل بـين المـتهم ومحاميـه الحاضـر معـه أثناء التحقيق.$b106336$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins106;

WITH ins107 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 107, 0, $h107340$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السادس أوامر الحضور والقبض والضبط والإحضار$h107340$, $t107341$مادة (107)$t107341$, $b107339$يجوز لعضو النيابة العامة أن يصدر بحسب الأحوال أمرا بحضور المتهم أو أمرا مسببا بالقبض عليه أو أمرا مسببا بضبطه وإحضاره.$b107339$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins107;

WITH ins108 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 108, 0, $h108343$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السادس أوامر الحضور والقبض والضبط والإحضار$h108343$, $t108344$مادة (108)$t108344$, $b108342$يجب أن يشمل كل أمر اسم المتهم ولقبه ومهنته ومحل إقامتـه ورقمـه القـومي أو رقم وثيقة سفره وموطنه إن كان أجنبيا ،والتهمة المنـسوبة إليـه ،وتـاريخ الأمـر وتوقيع عضو النيابة العامة والختم الرسمي ،ويشمل الأمر بحضوره على ميعاد معين.
ويجب أن يشمل أمر القبض أو أمر الضبط والإحضار تكليـف رجـال الـسلطة العامة بالقبض على المتهم وإحضاره أمام عضو النيابة العامـة إذا رفـض الحـضور طوعا في الحال.$b108342$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins108;

WITH ins109 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 109, 0, $h109346$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السادس أوامر الحضور والقبض والضبط والإحضار$h109346$, $t109347$مادة (109)$t109347$, $b109345$مع مراعاة حكم الفقرتين الثانية والثالثـة مـن المـادة  ٧٢مـن هـذا القـانون، تعلن الأوامر إلى المتهم بواسطة المحضرين أو رجال الـسلطة العامـة ،وتـسلم لـه صورة منها.$b109345$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins109;

WITH ins110 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 110, 0, $h110349$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السادس أوامر الحضور والقبض والضبط والإحضار$h110349$, $t110350$مادة (110)$t110350$, $b110348$إذا لم يحضر المتهم بعد الأمر بحضوره دون عذر مقبول ،أو إذا خيـف هربـه، أو إذا لم يكن له محل إقامة معروف في مصر ،أو إذا كانت الجريمة في حالـة تلـبس جاز لعضو النيابة العامة أن يصدر أمرا مسببا بضبطه وإحضاره.$b110348$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins110;

WITH ins111 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 111, 0, $h111352$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السادس أوامر الحضور والقبض والضبط والإحضار$h111352$, $t111353$مادة (111)$t111353$, $b111351$تكون الأوامـر التـي يـصدرها عـضو النيابـة العامـة نافـذة فـي جميـع الأراضي المصرية.
ولا يجوز تنفيذ أوامر القبض والضبط والإحضار بعد مضي ستة أشهر من تاريخ صدورها ما لم يقرر عضو النيابة العامة مدها لمدة أخرى.$b111351$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins111;

WITH ins112 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 112, 0, $h112355$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السادس أوامر الحضور والقبض والضبط والإحضار$h112355$, $t112356$مادة (112)$t112356$, $b112354$يجب على عضو النيابة العامة أن يستجوب المتهم المقبـوض عليـه فـورا ،وإذا تعذر ذلك يودع أحد مراكز الإصلاح والتأهيل أو أماكن الاحتجاز إلى حين اسـتجوابه، ويجب ألا تزيد مدة إيداعه على أربع وعشرين ساعة ،فإذا انتهت هذه المدة وجب على القائم على إدارة مركز الإصلاح والتأهيل أو أماكن الاحتجاز إرساله إلى النيابة العامـة لاستجوابه في الحال وإلا أمرت بإخلاء سبيله.
واستثناء من حكم الفقرة الأولى من هذه المادة ،للنيابة العامة إذا تعذر اسـتجواب المتهم بجريمة يجوز فيها الحبس الاحتياطي لعدم حضور محاميه الموكل أو المنتـدب، أن تأمر بإيداعه أحد مراكز الإصلاح والتأهيل أو أماكن الاحتجاز إلى حين اسـتجوابه بحضور محام ،ويسري في شأن حالات ودواعي الأمر بإيـداع المـتهم ،وإجراءاتـه، ومدته ،ومدها ،واستئنافه ذات القواعد المقررة بالنسبة إلى الحبس الاحتياطي.$b112354$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins112;

WITH ins113 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 113, 0, $h113358$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h113358$, $t113359$مادة (113)$t113359$, $b113357$إذا تبين بعد استجواب المتهم أن الأدلة كافية ،وكانت الواقعـة جنايـة أو جنحـة معاقبا عليها بالحبس مدة لا تقل عن سنة ،جاز لعضو النيابة العامة من درجـة وكيـل نيابة على الأقل بعد سماع دفاع المتهم أن يصدر أمرا مسببا بحبس المـتهم احتياطيـا وذلك لمدة أقصاها أربعة أيام تالية للقبض على المتهم أو تسليمه للنيابة العامة إذا كـان مقبوضا عليه من قبل ،وذلك إذا توافرت إحدى الحالات أو الدواعي الآتية: -١إذا كانت الجريمة في حالة تلبس ويجب تنفيذ الحكم فيها فور صدوره.
-٢الخشية من هروب المتهم.
-٣خشية الإضرار بمصلحة التحقيق سواء بالتأثير على المجني عليه أو الشهود، أو العبث في الأدلة أو القرائن المادية ،أو بإجراء اتفاقات مع باقي الجناة لتغيير الحقيقة أو طمس معالمها.
-٤توقي الإخلال الجسيم بالأمن والنظام العام الذي قد يترتـب علـى جـسامة الجريمة.
وفى جميع الأحوال ،يجوز حبس المتهم احتياطيا إذا لم يكن له محل إقامة ثابـت ومعروف في مصر وكانت الجريمة جناية أو جنحة معاقبا عليها بالحبس.$b113357$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins113;

WITH ins114 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 114, 0, $h114361$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h114361$, $t114362$مادة (114)$t114362$, $b114360$يجوز لعضو النيابة العامة في الأحوال المنصوص عليها بالمادة  ١١٣مـن هـذا القانون ،وكذلك في الجنح الأخرى المعاقب عليها بالحبس أن يصدر بدلا مـن الحـبس الاحتياطي أمرا مسببا بأحد التدابير الآتية: -١إلزام المتهم بعدم مبارحة مسكنه أو موطنه.
-٢إلزام المتهم بأن يقدم نفسه لمقر الشرطة في أوقات محددة.
-٣حظر ارتياد المتهم أماكن محددة.
-٤إلزام المتهم بعدم مغادرة نطـاق جغرافـي محـدد إلا بعـد الحـصول علـى إذن من النيابة العامة.
-٥إلزام المتهم بالامتناع عن استقبال أو مقابلة أشخاص معينين أو الاتصال بهم بـأي شكل من الأشكال.
-٦منع المتهم مؤقتا من حيازة أو إحراز الأسلحة النارية وذخيرتهـا ،وتـسليمها لقسم أو مركز الشرطة الذي يقع في دائرته محل إقامته.
-٧استخدام الوسائل التقنية في تتبع المتهم حال تـوافر ظـروف العمـل بهـا، ويصدر بها قرار من وزير العدل بالتنسيق مع وزيري الداخلية والاتصالات.$b114360$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins114;

WITH ins115 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 115, 0, $h115364$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h115364$, $t115365$مادة (115)$t115365$, $b115363$إذا خالف المتهم التدبير المقرر له وفق ًا للمادة  ١١٤من هذا القانون يجوز لعـضو النيابة العامة أن يستبدل بالتدبير الحبس الاحتياطي.$b115363$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins115;

WITH ins116 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 116, 0, $h116367$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h116367$, $t116368$مادة (116)$t116368$, $b116366$يجب أن يشتمل أمر الحبس فضلا ً عن البيانات المشار إليها بالمادة  ١٠٨من هـذا القانون ،بيان الجريمة المسندة إلى المتهم والعقوبة المقررة لها ،والأسباب التـي بنـي عليها الأمر ،وتكليف القائم على إدارة مركز الإصلاح والتأهيل أو أمـاكن الاحتجـاز بقبول المتهم ووضعه فيه.
ويسري حكم هذه المادة على الأوامر التي تصدر بمد الحبس الاحتيـاطي ،وفق ًـا لأحكام هذا القانون.$b116366$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins116;

WITH ins117 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 117, 0, $h117370$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h117370$, $t117371$مادة (117)$t117371$, $b117369$يكون لأعضاء النيابة العامة من درجة رئيس نيابة على الأقل في تحقيق الجنايات المنصوص عليها في الأبواب الأول والثاني والثاني مكررا والثالث والرابع من الكتاب الثاني من قانون العقوبات ،بالإضافة إلى الاختصاصات المقررة للنيابة العامة ،سـلطة إصدار أمر مسبب لمدة لا تزيد على ثلاثـين يومـا ،بـضبط الخطابـات والرسـائل والبرقيات والجرائد والمطبوعات والطرود ،وبمراقبة الاتصالات السلكية واللاسـلكية، وحسابات مواقع التواصل الاجتماعي ومحتوياتها المختلفة غير المتاحة للجميع ،والبريد الإلكتروني ،والرسائل النصية أو المسموعة أو المصورة على الهواتف والأجهزة وأي وسيلة تقنية أخرى ،وضبط الوسائط الحاوية لها ،أو إجراء تسجيلات لأحاديث جـرت في مكان خاص متى كان لذلك فائدة في ظهور الحقيقة.
ويجوز تجديد الأمر المشار إليه في الفقرة الأولى من هذه المـادة مـدة أو مـددا أخرى مماثلة.
كما يكون لهؤلاء الأعضاء في تحقيق الجنايات المشار إليه في الفقرة الأولى مـن هذه المادة عدا الجنايات المنصوص عليها في الباب الثالث من الكتاب الثاني من قانون العقوبات ،سلطة القاضي الجزئي فيما يتعلق بمدة الحبس الاحتياطي.
ويكون لهم فضلا ً عن ذلك سلطة محكمة الجنح المـستأنفة منعقـدة فـي غرفـة المشورة ،المنصوص عليها في المادة  ١٢٣من هذا القـانون ،عنـد تحقيـق الجـرائم المنصوص عليها في الباب الأول والقسم الأول من الباب الثاني من الكتاب الثاني مـن قانون العقوبات بشرط ألا تزيد مدة الحبس في كل مرة على خمسة عشر يوما.$b117369$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins117;

WITH ins118 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 118, 0, $h118373$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h118373$, $t118374$مادة (118)$t118374$, $b118372$يجب عند إيداع المتهم فى أحد مراكز الإصلاح والتأهيل أو أماكن الاحتجـاز أن تسلم إلى القائم على إدارته صورة من أمر الحبس بعد توقيعه على الأصل بالاستلام.$b118372$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins118;

WITH ins119 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 119, 0, $h119376$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h119376$, $t119377$مادة (119)$t119377$, $b119375$لا يجوز للقائم على إدارة مركز الإصلاح والتأهيل أو أماكن الاحتجاز أن يـسمح لأحد من رجال السلطة العامة أو مأموري الـضبط القـضائي بـأن يتـصل بنفـسه أو بواسطة غيره بالمحبوس احتياطيا داخل ذلك المركز أو المكان إلا بإذن كتابي مـن النيابة العامة ،وعليه أن يدون في الدفتر المعد لذلك اسم الشخص الذي سمح له ووقـت المقابلة وتاريخ ومضمون الإذن ،ويقع باطلا كل إجراء يخالف ذلك.$b119375$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins119;

WITH ins120 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 120, 0, $h120379$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h120379$, $t120380$مادة (120)$t120380$, $b120378$يجوز لعضو النيابة العامة في كل الأحوال أن يأمر بعدم اتصال المتهم المحبـوس احتياطيا بغيره من المحبوسين ومنع الزيارة عنه ،وذلك دون الإخلال بحق المتهم فـي الاتصال دائما بالمدافع عنه دون حضور أحد.$b120378$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins120;

WITH ins121 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 121, 0, $h121382$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h121382$, $t121383$مادة (121)$t121383$, $b121381$إذا رأت النيابة العامة مد مدة الحبس الاحتياطي ،وجب عليها قبـل انتهـاء مـدة الأربعة أيام المشار إليها بالمادة  ١١٣من هـذا القـانون ،أن تعـرض الأوراق علـى القاضي الجزئي ليصدر أمرا مسببا ،بعد سماع أقوال النيابة العامة والمتهم إما بالإفراج عن المتهم أو بمد مدة الحبس الاحتياطي لمدة أو مدد متعاقبة بحيث لا تزيد كـل منهـا على خمسة عشر يوما ولا يزيد مجموعها على خمسة وأربعين يوما.
وفي مواد الجنح يجب الإفراج حتما عن المتهم المقبوض عليه بعد مرور ثمانية أيـام من تاريخ استجوابه إذا كان له محل إقامة معروف في مصر وكان الحد الأقصى للعقوبـة المقررة قانون ًا لا يتجاوز سنة واحدة ولم يكن عائدا وسبق الحكم عليه بالحبس أكثر من سنة.$b121381$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins121;

WITH ins122 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 122, 0, $h122385$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h122385$, $t122386$مادة (122)$t122386$, $b122384$يكون الأمر الصادر مـن النيابـة العامـة بأحـد التـدابير المنـصوص عليهـا في المادة  ١١٤من هذا القانون نافذ المفعول لمدة الأيام العشرة التالية لبدء تنفيذه.
ومع عدم الإخلال بما ورد بشأنه نص خاص في هذا القانون ،يتبـع بـشأن هـذه التدابير ذات الأحكام المقررة للحبس الاحتياطي ،ويسري في شأن مـد مـدة التـدابير أو الحد الأقصى لها أو استئنافها ذات القواعد المقررة بالنسبة إلى الحبس الاحتياطي.$b122384$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins122;

WITH ins123 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 123, 0, $h123388$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h123388$, $t123389$مادة (123)$t123389$, $b123387$إذا لم ينته التحقيق ورأى عضو النيابة العامة مد مدة الحبس الاحتياطي أو التدبير لما يزيد على ما هو مقرر في المادتين  ١٢٢ ،١٢١من هذا القانون ،وفـي الأحـوال المنصوص عليها بالفقرة الثالثة من المادة  ١١٧من هذا القانون ،وجب عليه قبل انتهاء مدة الحبس الاحتياطي أو التدبير عرض الأوراق على محكمة الجنح المستأنفة منعقـدة في غرفة المشورة لتصدر أمرا مسببا بعد سماع أقوال النيابة العامة والمتهم بمـد مـدة الحبس أو التدبير لمدد متعاقبة لا تزيد كل منها على خمسة وأربعين يوما إذا اقتـضت مصلحة التحقيق ذلك أو بالإفراج عن المتهم أو بإنهاء التدبير بحسب الأحوال.
ومع ذلك يتعين عرض الأمر على النائب العام كلما انقضى تسعون يوما على حـبس المتهم بجناية احتياطيا أو مده وذلك لاتخاذ الإجراءات التي يراها كفيلة للانتهاء من التحقيق.$b123387$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins123;

WITH ins124 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 124, 0, $h124391$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل السابع أمر الحبس$h124391$, $t124392$مادة (124)$t124392$, $b124390$لا يجوز أن تزيد مدة الحبس الاحتياطي أو التدبير على ثلاثة أشـهر فـي مـواد الجنح ما لم يكن المتهم قد أعلن بإحالته إلى المحكمة المختصة قبل انتهاء هـذه المـدة، ويجب على النيابة العامة في هذه الحالة أن تعرض أمر الحبس أو التدبير خلال خمسة أيام على الأكثر من تاريخ الإعلان بالإحالة إلى المحكمة المختصة وفق ًا لأحكام الفقـرة الأولى من المادة  ١٣٢من هذا القانون لإعمال مقتـضى هـذه الأحكـام ،وإلا وجـب الإفراج عن المتهم أو إنهاء التدبير بحسب الأحوال.
فإذا كانت التهمة المنسوبة إليه جناية فلا يجوز أن تزيد مدة الحـبس الاحتيـاطي أو التدبير على خمسة أشهر إلا بعد الحصول قبل انقضائها على أمـر مـن المحكمـة المختصة بمد الحبس أو التدبير مدة لا تزيـد علـى خمـسة وأربعـين يومـا قابلـة للتجديد لمدة أو لمدد أخرى مماثلة وإلا وجب الإفراج عن المـتهم أو إنهـاء التـدبير بحسب الأحوال.
وفي جميع الأحوال ،لا يجوز أن تجاوز مدة الحـبس الاحتيـاطي فـي مرحلـة التحقيق الابتدائي وسائر مراحل الدعوى الجنائية ثلث الحد الأقصى للعقوبـة الـسالبة للحرية ،بحيث لا تجاوز أربعة أشهر في الجنح واثني عـشر شـهرا فـي الجنايـات، وثمانية عشر شهرا إذا كانت العقوبة المقررة للجريمة هي السجن المؤبد أو الإعـدام، ويجوز لمحكمة الجنايات المستأنفة ولمحكمة النقض إذا كان الحكم صـادرا بالإعـدام أو السجن المؤبد أن تأمر بحبس المتهم احتياطيا لمدة خمسة وأربعين يوما قابلة للتجديد لمدد أخرى بما لا يجاوز سنتين.$b124390$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins124;

WITH ins125 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 125, 0, $h125394$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h125394$, $t125395$مادة (125)$t125395$, $b125393$يجوز للنيابة العامة أن تأمر بالإفراج المؤقت عن المـتهم المحبـوس احتياطيـا أو بإنهاء التدبير في كل وقت سواء من تلقاء نفسها أو بناء على طلب المـتهم ،بكفالـة أو دون كفالة ،شريطة أن يتعهد بحضوره متى طلب منه بمعرفة النيابة العامة.$b125393$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins125;

WITH ins126 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 126, 0, $h126397$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h126397$, $t126398$مادة (126)$t126398$, $b126396$في غير الأحوال التي يكون فيها الإفراج واجبا ،لا يفرج عـن المـتهم بـضمان أو بغير ضمان إلا بعد أن يعين له موطن ًا مختارا أو رقـم هـاتف محمـول أو بريـدا إلكترونيا على النحو المبين بالفقرة الثانية من المادة  ٧٢من هذا القانون.$b126396$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins126;

WITH ins127 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 127, 0, $h127400$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h127400$, $t127401$مادة (127)$t127401$, $b127399$يجوز تعليق الإفراج المؤقت أو إنهاء التدبير في غير الأحوال التي يكـون فيهـا واجبا حتما على المتهم تقديم كفالة.
ويقدر عضو النيابة العامة أو القاضي الجزئي أو محكمة الجنح المستأنفة منعقـدة في غرفة المشورة حسب الأحوال مبلغ الكفالة.
ويخصص نصف مبلغ الكفالة ليكون جزاء لتخلف المتهم عن الحـضور فـي أي إجراء من إجراءات التحقيق والدعوى والتقدم لتنفيذ الحكم والقيـام بجميـع الواجبـات الأخرى التي تفرض عليه ،ويخصص النصف الآخر لدفع ما يأتي بترتيبه: أولا ً :المصاريف التي صرفتها الحكومة.
ثانيا :العقوبات المالية التي قد يحكم بها على المتهم.
وإذا قدرت الكفالة بغير تخصيص ،اعتبرت ضمان ًا لقيام المتهم بواجب الحـضور وعدم التهرب من التنفيذ والواجبات الأخرى التي تفرض عليه.$b127399$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins127;

WITH ins128 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 128, 0, $h128403$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h128403$, $t128404$مادة (128)$t128404$, $b128402$يدفع مبلغ الكفالة من المتهم أو من غيره ويكـون ذلـك بإيـداع المبلـغ المقـدر في خزانة المحكمة نقدا أو سندات حكومية أو مضمونة من الحكومة أو بموجب شـيك بنكي مقبول الدفع ،أو خطاب ضمان بنكي ،أو بإحدى وسـائل الـدفع غيـر النقـدي المنصوص عليها بقانون تنظيم استخدام وسائل الدفع غير النقـدي الـصادر بالقـانون رقم  ١٨لسنة ٢٠١٩ ويجوز أن يقبل من أي شخص مليء التعهد بدفع المبلغ المقدر للكفالة أو خطـاب ضمان بنكي إذا أخل المتهم بشرط من شروط الإفراج ،ويؤخـذ عليـه التعهـد بـذلك في محضر التحقيق أو بتقرير في قلم الكتـاب ،ويكـون للمحـضر أو التقريـر قـوة السند التنفيذي.$b128402$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins128;

WITH ins129 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 129, 0, $h129406$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h129406$, $t129407$مادة (129)$t129407$, $b129405$إذا لم يقم المتهم بغير عذر مقبول بتنفيذ أحد الالتزامات المفروضة عليـه يـصبح الجزء الأول من الكفالة ملك ًا للحكومة بقرار مسبب من الـسلطة المختـصة بـالتحقيق أو المحاكمة.
ويرد الجزء الثـاني إذا صـدر فـي الـدعوى قـرار بـأن لا وجـه لإقامتهـا أو حكم بالبراءة.$b129405$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins129;

WITH ins130 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 130, 0, $h130409$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h130409$, $t130410$مادة (130)$t130410$, $b130408$إذا كانت حالة المتهم لا تسمح بتقديم كفالـة يجـوز إلزامـه بـأن يقـدم نفـسه لمقر الشرطة المختص في الأوقات التي تحدد له فـي أمـر الإفـراج مـع مراعـاة ظروفه الخاصة.
كما يجوز أن يطلب منه اختيار مكان للإقامة فيه غير المكان الذي وقعـت فيـه الجريمة أو أن يحظر عليه ارتياد مكان معين.$b130408$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins130;

WITH ins131 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 131, 0, $h131412$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h131412$, $t131413$مادة (131)$t131413$, $b131411$الأمر الصادر بالإفراج لا يمنع عضو النيابة العامة من إصدار أمر جديد بالقبض على المتهم أو بحبسه احتياطيا إذا قويت الأدلة ضده ،أو أخل بالواجبـات المفروضـة عليه ،أو وجدت ظروف تستدعي اتخاذ هذا الإجراء ،وذلك مع عدم الإخـلال بأحكـام المادتين  ١٢٤ ،١٢٣من هذا القانون.$b131411$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins131;

WITH ins132 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 132, 0, $h132415$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h132415$, $t132416$مادة (132)$t132416$, $b132414$إذا أحيل المتهم إلى المحكمة يكون الإفراج عنه إن كان محبوسا أو حبسه إن كان مفرجا عنه أو إنهاء التدبير أو الأمر به من اختصاص المحكمة المحال إليها.
وفي حالة الإحالة إلى محكمة جنايات أول درجة يكـون الأمـر فـي غيـر دور الانعقاد من اختصاص محكمة الجنح المستأنفة منعقدة في غرفة المشورة.
وفي حالة الحكم بعدم الاختصاص تكون محكمة الجنح المستأنفة منعقدة في غرفة المشورة هي المختصة بالنظر في طلب الإفراج أو الحبس أو إنهاء التدابير أو الأمـر به إلى أن ترفع الدعوى إلى المحكمة المختصة.$b132414$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins132;

WITH ins133 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 133, 0, $h133418$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h133418$, $t133419$مادة (133)$t133419$, $b133417$لا يقبل من المجني عليه أو من المدعي بالحقوق المدنيـة طلـب حـبس المـتهم أو الأمر بأحد التدابير له ولا تسمع منه أقوال في المناقشات المتعلقـة بـالإفراج عنـه أو بإنهاء التدبير.$b133417$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins133;

WITH ins134 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 134, 0, $h134421$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثامن الإفراج المؤقت$h134421$, $t134422$مادة (134)$t134422$, $b134420$يجوز للقاضي الجزئي أو محكمة الجنح المستأنفة أو المحكمة المختـصة تقـدير كفالة للإفراج عن المتهم كلما طلبت النيابة العامة الأمر بمد مدة الحـبس الاحتيـاطي، وتراعى في ذلك أحكام المواد  ١٣١ ،١٣٠ ،١٢٩ ،١٢٨ ،١٢٧من هذا القانون.$b134420$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins134;

WITH ins135 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 135, 0, $h135424$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل التاسع التصرف في الأشياء المضبوطة$h135424$, $t135425$مادة (135)$t135425$, $b135423$يجوز الأمر برد الأشياء المضبوطة ،ولو قبـل صـدور الحكـم فـي الـدعوى، ما لم تكن لازمة للسير في الدعوى أو محلا ً للمصادرة.$b135423$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins135;

WITH ins136 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 136, 0, $h136427$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل التاسع التصرف في الأشياء المضبوطة$h136427$, $t136428$مادة (136)$t136428$, $b136426$يصدر الأمر بالرد من النيابة العامـة أو قاضـي التحقيـق أو محكمـة الجـنح المستأنفة منعقدة في غرفة المشورة ،ولمحكمة الموضوع وحدها أن تأمر بـالرد أثنـاء نظر الدعوى.$b136426$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins136;

WITH ins137 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 137, 0, $h137430$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل التاسع التصرف في الأشياء المضبوطة$h137430$, $t137431$مادة (137)$t137431$, $b137429$يكون رد الأشياء المضبوطة إلى من كانت في حيازته وقت ضبطها ،أما الأشـياء التي وقعت عليها الجريمة أو المتحصلة منها فيكون ردهـا إلـى مـن فقـد حيازتهـا بالجريمة ،ما لم يكن لمن ضبطت معه الحق قانون ًا في حبسها.$b137429$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins137;

WITH ins138 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 138, 0, $h138433$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل التاسع التصرف في الأشياء المضبوطة$h138433$, $t138434$مادة (138)$t138434$, $b138432$لا يمنع الأمر بالرد ذوي الشأن من المطالبة أمـام المحـاكم المدنيـة بمـا لهـم من حقوق ،وإذا كان الأمر بالرد قـد صـدر مـن المحكمـة بنـاء علـى طلـب أي من المتهم أو المدعى بالحقوق المدنية في مواجهة الآخر فلا يجوز المطالبة بـه أمـام المحاكم المدنية.$b138432$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins138;

WITH ins139 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 139, 0, $h139436$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل التاسع التصرف في الأشياء المضبوطة$h139436$, $t139437$مادة (139)$t139437$, $b139435$يجوز الأمر بالرد ولو من غير طلب.
ولا يجوز للنيابة العامة أو قاضي التحقيق الأمر بالرد عنـد المنازعـة ،ويرفـع الأمر في هذه الحالة أو في حالة وجود شك فيمن له الحق في تسلم الشيء إلى محكمـة الجنح المستأنفة منعقدة في غرفة المشورة ،بناء على طلب ذوي الشأن لتأمر بما تراه.$b139435$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins139;

WITH ins140 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 140, 0, $h140439$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل التاسع التصرف في الأشياء المضبوطة$h140439$, $t140440$مادة (140)$t140440$, $b140438$يجب عند صدور أمر بالحفظ أو بأن لا وجه لإقامة الدعوى أن يفصل في كيفيـة التصرف في الأشياء المضبوطة وكذلك الحال عند الحكم فـي الـدعوى إذا حـصلت المطالبة بالرد أمام المحكمة.$b140438$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins140;

WITH ins141 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 141, 0, $h141442$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل التاسع التصرف في الأشياء المضبوطة$h141442$, $t141443$مادة (141)$t141443$, $b141441$يجوز لمحكمة الموضوع أو محكمة الجنح المستأنفة منعقدة في غرفة المشورة أن تحيل الأمر في شأن الرد إلى المحكمة المدنيـة إذا رأت موجبـا لـذلك ،وفـي هـذه الحالة يجوز وضع الأشياء المضبوطة تحت الحراسة أو اتخـاذ إجـراءات تحفظيـة أخرى نحوها.$b141441$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins141;

WITH ins142 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 142, 0, $h142445$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل التاسع التصرف في الأشياء المضبوطة$h142445$, $t142446$مادة (142)$t142446$, $b142444$إذا كان الشيء المضبوط مما يتلف بمرور الزمن أو يستلزم حفظه نفقات تستغرق قيمته أو لم يطلبه صاحبه خلال ستة أشهر من تاريخ انتهاء الـدعوى ،يجـوز للنيابـة العامة أن تأمر ببيعه بإحدى الطرق المقررة بقانون تنظـيم التعاقـدات التـي تبرمهـا الجهات العامة الصادر بالقانون رقم  ١٨٢لسنة  ٢٠١٨متى سمحت بـذلك مقتـضيات الدعوى ،ويكون لصاحبه الحق في أن يطالب بالثمن الذي بيع به بعد خـصم النفقـات والمصروفات.$b142444$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins142;

WITH ins143 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 143, 0, $h143448$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل العاشر منع المتهم من التصرف في أمواله أو إدارتها$h143448$, $t143449$مادة (143)$t143449$, $b143447$في الأحوال التي تقوم فيها أدلة كافية من التحقيق على جدية الاتهام فـي أي مـن الجرائم المنصوص عليها في الباب الرابع من الكتاب الثاني مـن قـانون العقوبـات، وغيرها من الجرائم التي تقع على الأموال المملوكة للدولة أو الهيئـات والمؤسـسات العامة والوحدات التابعة لها أو غيرها مـن الأشـخاص الاعتباريـة العامـة ،وكـذا في الجرائم التي يوجب القانون فيها على المحكمة أن تقضي من تلقـاء نفـسها بـرد المبالغ أو قيمة الأشياء محل الجريمة أو تعويض الجهة المجني عليها ،وقـدرت فيهـا النيابة العامة أن الأمر يقتضي اتخاذ تدابير تحفظية على أموال المتهم ،بما فـي ذلـك منعه من التصرف فيها أو إدارتها ،وجب عليها أن تعـرض الأمـر علـى المحكمـة الجنائية المختصة طالبة الحكم بذلك ضمان ًا لتنفيذ ما عسى أن يقضي به مـن غرامـة أو رد أو تعويض.
وللنائب العام عند الضرورة أو في حالة الاستعجال أن يأمر مؤقت ًا بمنع المتهم من التصرف في أمواله أو إداراتها ،ويجب أن يشتمل أمر المنع من الإدارة على تعيين من يدير الأموال المتحفظ عليها ،وعلى النائب العام في جميع الأحـوال أن يعـرض أمـر المنع على المحكمة الجنائية المختصة خلال سبعة أيام على الأكثر من تاريخ صدوره، بطلب الحكم بالمنع من التصرف أو الإدارة وإلا اعتبر الأمر كأن لم يكن.$b143447$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins143;

WITH ins144 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 144, 0, $h144451$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل العاشر منع المتهم من التصرف في أمواله أو إدارتها$h144451$, $t144452$مادة (144)$t144452$, $b144450$تصدر المحكمة الجنائية حكمها خلال مدة لا تجاوز خمسة عشر يوما من تـاريخ عرض أمر المنع المشار إليه بالفقرة الأولى من المادة  ١٤٣من هـذا القـانون عليهـا وبعد سماع أقوال ذوي الشأن ،وتفصل المحكمة في مـدى اسـتمرار العمـل بـالأمر الوقتي المشار إليه بالفقرة الثانية من المادة  ١٤٣من هذا القـانون كلمـا رأت وجهـا لتأجيل نظره.
ويجب أن يشتمل الحكم على الأسباب التي بني عليها ،وأن يـشمل المنـع مـن الإدارة تعيين من يدير الأموال المتحفظ عليها بعد أخذ رأي النيابة العامة.
ويجوز للمحكمة بناء على طلب النيابة العامة أن تشمل في حكمها أي مال لـزوج المتهم أو أولاده القصر أو ورثته إذا توافرت أدلة كافية على أنه متحصل من الجريمـة موضوع التحقيق وآل إليهم من المتهم ،وذلك بعد إدخالهم في الطلب.
وعلى من يعين للإدارة أن يتسلم الأموال المتحفظ عليها ،ويبـادر إلـى جردهـا بحضور ذوي الشأن ،وممثل للنيابة العامة ،أو خبير تندبه المحكمة ،ويلتزم مـن يعـين للإدارة بالمحافظة على الأموال وحسن إدارتها ،وردها مـع غلتهـا المقبوضـة طبق ًـا للأحكام المقررة في القانون المـدني بـشأن الوكالـة فـي أعمـال الإدارة والوديعـة والحراسة ،وذلك على النحو الذي يصدر بتنظيمه قرار من النائب العام.$b144450$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins144;

WITH ins145 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 145, 0, $h145454$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل العاشر منع المتهم من التصرف في أمواله أو إدارتها$h145454$, $t145455$مادة (145)$t145455$, $b145453$لكل من صدر ضده حكم بالمنع من التـصرف أو الإدارة أن يـتظلم منـه أمـام المحكمة الجنائية المختصة بعد انقضاء ثلاثة أشهر من تاريخ الحكم ،فإذا رفض تظلمه فله أن يتقدم بتظلم جديد كلما انقضت ثلاثة أشهر من تاريخ الحكم برفض التظلم.
كما يجوز لمن صدر ضده حكم بالمنع من التصرف أو الإدارة ولكل ذي شأن أن يتظلم من إجراءات تنفيذه.
ويحصل التظلم بتقرير في قلم كتاب المحكمة الجنائية المختصة ،وعلـى رئـيس المحكمة أن يحدد جلسة لنظر التظلم يعلن بها المتظلم وكل ذي شأن ،وعلى المحكمة أن تفصل في التظلم خلال مدة لا تجاوز خمسة عشر يوما من تاريخ التقرير به.
ويجوز للمحكمة المختصة أثناء نظر الدعوى من تلقاء نفسها أو بناء على طلـب النيابة العامة أو ذوي الشأن أن تحكم بإنهاء المنع من التصرف أو الإدارة المقضي بـه أو تعديل نطاقه أو إجراءات تنفيذه.$b145453$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins145;

WITH ins146 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 146, 0, $h146457$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل العاشر منع المتهم من التصرف في أمواله أو إدارتها$h146457$, $t146458$مادة (146)$t146458$, $b146456$يجب أن يبين الأمر الصادر بالتصرف في الدعوى الجنائية أو الحكم الصادر فيها ما يتبع في شأن التدابير التحفظية المشار إليها في المادة  ١٤٣من هذا القانون.
وفي جميع الأحوال ،ينتهي المنع من التصرف أو الإدارة بـصدور قـرار بـأن لا وجه لإقامة الدعوى الجنائية أو بصدور حكم نهائي فيها بـالبراءة ،أو بتمـام تنفيـذ العقوبات المالية والتعويضات المقضي بهما.
ولا يحتج عند تنفيذ الحكم الصادر بالغرامة أو برد المبالغ أو قيمة الأشياء محـل الجريمة أو بتعويض الجهة المجني عليها بحـسب الأحـوال بـأي تـصرف يـصدر بالمخالفة للأمر أو الحكم المشار إليهما في المادتين  ١٤٤ ،١٤٣من هذا القـانون مـن تاريخ قيد أي منهما في سجل خاص يصدر بتنظيمه قرار من وزير العدل ،ويكون لكل ذي شأن حق الاطلاع على هذا السجل.$b146456$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins146;

WITH ins147 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 147, 0, $h147460$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل العاشر منع المتهم من التصرف في أمواله أو إدارتها$h147460$, $t147461$مادة (147)$t147461$, $b147459$يجوز للمحكمة عند الحكم برد المبالغ أو قيمة الأشياء محل الجرائم المشار إليها في المادة  ١٤٣من هذا القانون أو بتعويض الجهة المجني عليها فيها أن تقـضي بنـاء على طلب النيابة العامة أو المدعي بالحقوق المدنية بحسب الأحوال ،وبعد سماع أقوال ذوي الشأن بتنفيذ هذا الحكم في أموال زوج المتهم وأولاده القصر ،إذا ثبت أنها آلـت إليهم من المتهم ،وأنها متحصلة من الجريمة المحكوم فيها.$b147459$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins147;

WITH ins148 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 148, 0, $h148463$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل العاشر منع المتهم من التصرف في أمواله أو إدارتها$h148463$, $t148464$مادة (148)$t148464$, $b148462$لا يحول انقضاء الدعوى الجنائية بالموت قبل أو بعد إحالتها إلـى المحكمـة دون قضائها بالرد في الجرائم المنصوص عليها في المواد ) /١١٣ ،١١٢فقرة أولى وثانيـة ورابعة( ١١٣ ،مكررا )فقرة أولى( ١١٥ ،١١٤ ،من قانون العقوبات.
وعلى المحكمة أن تأمر بالرد في مواجهة الورثة والموصى لهم ،وكل مـن أفـاد فائدة جدية من الجريمة ليكون الحكم بالرد نافذ ًا في أموال كل منهم بقدر ما استفاد.
ويجب أن تندب المحكمة محاميا للدفاع عمن وجه إليهم طلب الرد إذا لـم ينيبـوا من يتولى الدفاع عنهم.$b148462$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins148;

WITH ins149 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 149, 0, $h149466$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الحادي عشر منع المتهم من السفر$h149466$, $t149467$مادة (149)$t149467$, $b149465$يجوز للنائب العام أو من يفوضه من تلقاء نفسه أو بناء على طلب ذوي الـشأن، ولقاضي التحقيق المختص ،عند وجود أدلة كافية على جدية الاتهام في جناية أو جنحة معاقب عليها بالحبس أن يصدر أمرا مسببا بمنع المتهم من الـسفر خـارج الـبلاد أو بوضع اسمه على قوائم ترقب الوصول لمدة سنة قابلة للتجديد لمـدة أو لمـدد أخـرى مماثلة ،لأمر تستلزمه ضرورات التحقيقات أو حسن سير إجراءات المحاكمة ،وضمان تنفيذ ما عسى أن يقضى به من عقوبات.
ويجوز للنائب العام أو من يفوضه من تلقاء نفسه أو بناء على طلب كل ذي شـأن أن يصدر أمرا مسببا بالإدراج على قوائم الممنوعين من الـسفر أو ترقـب الوصـول للمحكوم عليهم المطلوب التنفيذ عليهم ،والمتهمين والمحكوم عليهم ممن تطلب الجهـات القضائية الأجنبية المختصة تسليمهم أو محاكمتهم.$b149465$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins149;

WITH ins150 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 150, 0, $h150469$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الحادي عشر منع المتهم من السفر$h150469$, $t150470$مادة (150)$t150470$, $b150468$يجوز للممنوع من السفر ،وللمدرج على قوائم ترقب الوصول أو وكيله أن يـتظلم من هذا الأمر أمام المحكمة الجنائية المختصة منعقدة في غرفة المشورة ،خلال خمـسة عشر يوما من تاريخ علمه به.
ولا يجوز إعادة التظلم من أمر المنع أو الإدراج قبل مضي ثلاثة أشهر من تاريخ رفض التظلم السابق عليه.
ويحصل التظلم بتقرير يودع قلم كتاب المحكمة الجنائية المختصة ،وعلى رئـيس المحكمة أن يحدد جلسة لنظر التظلم يعلن بها المتظلم والنيابة العامة ،وعلى المحكمـة أن تفصل في التظلم خلال مدة لا تجاوز خمسة عشر يوما من تاريخ التقرير به ،بحكم مسبب بعد سماع أقوال المتظلم أو وكيله والنيابة العامة ،ولها في سبيل ذلك أن تتخذ ما تراه من إجراءات أو تحقيقات ترى لزومها في هذا الشأن.$b150468$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins150;

WITH ins151 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 151, 0, $h151472$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الحادي عشر منع المتهم من السفر$h151472$, $t151473$مادة (151)$t151473$, $b151471$يجوز لسلطة التحقيق مصدرة الأمر ابتداء في كل وقت العدول عن الأمر الصادر منها ،كما يجوز لها التعديل فيه برفع اسمه من على قوائم المنع من الـسفر أو ترقـب الوصول لمدة محددة إذا دعت الضرورة لذلك.
وللنائب العام للاعتبارات التي يقدرها ومن بينها الظروف الصحية مـنح أي مـن المدرجة أسماؤهم على قوائم الممنوعين من السفر بناء على طلبه أو وكيلـه أو أحـد أقاربه حتى الدرجة الرابعة تصريحا للسفر إلى دولة أو دول معينة لمدة محددة ،إذا قدم الضمانات الكفيلة بالعودة إلى البلاد عند انتهاء مدة التصريح.
وفي جميع الأحوال ،ينتهي المنع من السفر بصدور قرار بـأن لا وجـه لإقامـة الدعوى الجنائية أو بصدور حكم نهائي فيها بالبراءة أيهما أقرب.$b151471$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins151;

WITH ins152 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 152, 0, $h152475$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h152475$, $t152476$مادة (152)$t152476$, $b152474$إذا رأت النيابة العامة بعد التحقيق أنه لا وجه لإقامة الدعوى تصدر أمرا بـذلك، سا لسبب آخر ،ولا يكون صـدور وتأمر بالإفراج عن المتهم المحبوس ما لم يكن محبو الأمر بأن لا وجه لإقامة الدعوى في الجنايات إلا من المحـامي العـام أو مـن يقـوم مقامه.
ويجب أن يكون الأمر مكتوبا ،وأن يشتمل على الأسباب التي بني عليها.
ويبين بالأمر اسم المتهم ،ولقبه ،وسنه ،ومحل ميلاده ،وسكنه ،ومهنتـه ،ورقمـه القومي أو رقم وثيقة سفره ،وموطنه إن كان أجنبيا ،والواقعة المنسوبة إليـه ووصـفها القانوني.
ويعلن الأمر للمتهم وللمجني عليه وللمدعي بالحقوق المدنية ،وإذا كان أيهـم قـد توفى يكون الإعلان لورثته جملة دون ذكر أسمائهم في آخر موطن كان لمورثهم.$b152474$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins152;

WITH ins153 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 153, 0, $h153478$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h153478$, $t153479$مادة (153)$t153479$, $b153477$يجوز للنائب العام أن يلغي الأمر المشار إليه في المادة  ١٥٢من هذا القانون فـي مدة الثلاثة أشهر التالية لصدوره ،ما لم يكن قد صدر قرار من محكمـة جنايـات أول درجة أو من محكمة الجنح المستأنفة منعقدة في غرفة المشورة بحسب الأحوال برفض الطعن المرفوع في هذا الأمر.$b153477$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins153;

WITH ins154 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 154, 0, $h154481$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h154481$, $t154482$مادة (154)$t154482$, $b154480$إذا رأت النيابة العامة أن الواقعة جنحة ،وأن الأدلة على المـتهم كافيـة رفعـت الدعوى إلى المحكمة الجزئية المختصة بنظرها ،ما لم تكن الجريمة من الجنح التي تقع بواسطة الصحف أو غيرها من طرق النشر عدا الجنح المضرة بأفراد الناس.
ويكون تكليف المتهم بالحضور أمام المحكمة الجزئية المختصة ،مع مراعاة حكـم المادة  ٦٢من هذا القانون.$b154480$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins154;

WITH ins155 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 155, 0, $h155484$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h155484$, $t155485$مادة (155)$t155485$, $b155483$يجب على النيابة العامة عند صدور القرار بإحالة الدعوى إلى المحكمة الجزئيـة أن تقوم بإرسال جميع الأوراق إلى قلم كتاب المحكمة خـلال ثلاثـة أيـام ،وبـإعلان الخصوم بالحضور أمام المحكمة في أقرب جلسة في المواعيد المقررة.$b155483$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins155;

WITH ins156 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 156, 0, $h156487$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h156487$, $t156488$مادة (156)$t156488$, $b156486$إذا رأت النيابة العامة أن الواقعة جناية أو من الجنح التي تقع بواسطة الـصحف أو غيرها من طرق النشر عدا الجنح المضرة بأفراد الناس ،وأن الأدلة كافيـة ترفـع الدعوى إلى محكمة جنايات أول درجة ،وتعلن المتهم بأمر إحالتهـا ،وترسـل الأوراق إليها فورا.$b156486$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins156;

WITH ins157 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 157, 0, $h157490$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h157490$, $t157491$مادة (157)$t157491$, $b157489$يكون رفع الدعوى في مواد الجنايات بإحالتها من المحامي العـام أو مـن يقـوم مقامه إلى محكمة جنايات أول درجة بتقرير اتهام تبين فيه بيانـات المـتهم ،ورقمـه القومي ،والجريمة المسندة إليه بأركانها المكونة لها ،وجميـع الظـروف المـشددة أو المخففة للعقوبة ،ومواد القانون المراد تطبيقها ،وترفق به قائمة بمضمون أقوال الشهود وأدلة الإثبات الأخرى ،ويندب المحامي العام من تلقاء نفسه محاميا لكل مـتهم بجنايـة صدر أمر بإحالته إلى محكمة جنايات أول درجة إذا لم يكن قد وكـل محاميـا للـدفاع عنه ،وتعلن النيابة العامة الخصوم بالأمر الصادر بالإحالة إلى محكمـة جنايـات أول درجة خلال العشرة أيام التالية لصدوره.$b157489$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins157;

WITH ins158 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 158, 0, $h158493$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h158493$, $t158494$مادة (158)$t158494$, $b158492$يرسل ملف القضية المحالة إلى قلم كتاب محكمة الاسـتئناف فـورا ،وإذا طلـب محامي المتهم أجلا ً للاطلاع عليه يحدد له رئيس المحكمة ميعادا لا يجاوز عشرة أيـام يبقى خلالها ملف القضية في قلم الكتاب ،حتى يتسنى له الاطـلاع عليـه مـن غيـر أن ينقل من هذا القلم.
ويجب على الخصوم أن يعلنوا شهودهم الذين لم تـدرج أسـماؤهم فـي القائمـة المشار إليها في المـادة  ١٥٧مـن هـذا القـانون علـى يـد محـضر ،بالحـضور بالجلسة المحددة لنظر الدعوى ،وذلك مع تحمل نفقات الإعـلان ،وإيـداع مـصاريف انتقال الشهود.$b158492$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins158;

WITH ins159 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 159, 0, $h159496$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h159496$, $t159497$مادة (159)$t159497$, $b159495$إذا شمل التحقيق أكثر من جريمة واحدة من اختصاص محاكم من درجة واحـدة، وكانت مرتبطة تحال جميعا بأمر إحالة واحد إلى المحكمة المختصة مكانيـا بإحـداها، فإذا كانت الجرائم من اختصاص محاكم من درجات مختلفـة تحـال إلـى المحكمـة الأعلى درجة.
وفي أحوال الارتباط التي يجب فيها رفع الدعوى عن جميع الجرائم أمام محكمـة واحدة ،إذا كانت بعض الجرائم من اختصاص محاكم عادية ،وبعضها من اختـصاص محاكم خاصة يكون رفع الدعوى بجميع الجرائم أمام المحاكم العادية ،مـا لـم يـنص القانون على غير ذلك.$b159495$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins159;

WITH ins160 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 160, 0, $h160499$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h160499$, $t160500$مادة (160)$t160500$, $b160498$مع مراعاة أحكام المادة  ١٣٢من هذا القانون ،يفـصل عـضو النيابـة العامـة المختص في القرار أو الأمر الصادر بالإحالة إلى المحكمة الجزئية أو محكمة جنايـات أول درجة في استمرار حبس المتهم احتياطيا أو الإفراج عنه أو في القبض عليه إذا لم يكن قد قبض عليه أو كان قد أفرج عنه ،ما لم يكن قد أعلن بقرار أو أمر الإحالة ،فإذا قبض عليه تعين عرضه خلال ثمانٍ وأربعين ساعة على المحكمة المختصة.$b160498$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins160;

WITH ins161 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 161, 0, $h161502$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h161502$, $t161503$مادة (161)$t161503$, $b161501$إذا حدث بعد صدور الأمر بالإحالة ما يستوجب إجراء تحقيقات تكميليـة فعلـى النيابة العامة أن تقوم بإجرائها ،وتقدم المحضر إلى المحكمة.$b161501$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins161;

WITH ins162 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 162, 0, $h162505$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h162505$, $t162506$مادة (162)$t162506$, $b162504$يجوز للنائب العام أو المحامي العام في الأحوال المبينة في الفقـرة الأولـى مـن المادة  ١١٨مكررا )أ( من قانون العقوبات أن يحيل الدعوى إلى محاكم الجنح لتقـضي فيها وفق ًا لأحكام المادة المذكورة.$b162504$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins162;

WITH ins163 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 163, 0, $h163508$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثاني عشر انتهاء التحقيق والتصرف في الدعوى$h163508$, $t163509$مادة (163)$t163509$, $b163507$الأمر الصادر من النيابة العامة بأن لا وجه لإقامة الدعوى يمنع من العـودة إلـى التحقيق ،إلا إذا ظهرت أدلة جديدة قبل انتهاء المدة المقررة لانقضاء الدعوى الجنائية.
ويعد من الأدلة الجديدة شهادة الشهود والمحاضر والأوراق التـي تحمـل أدلـة أخرى لم تعرض على النيابة العامة ،ويكون من شأنها تقوية الأدلة التي وجـدت غيـر كافية أو زيادة الإيضاح المؤدي إلى ظهور الحقيقة.$b163507$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins163;

WITH ins164 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 164, 0, $h164511$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h164511$, $t164512$مادة (164)$t164512$, $b164510$يجوز للمتهم وللمدعي بالحقوق المدنية استئناف الأمر الصادر من النيابة العامـة بأن لا وجه لإقامة الدعوى ،ما لم يكن صـادرا فـي تهمـة موجهـة ضـد موظـف أو مستخدم عام أو أحد رجال الضبط لجريمة وقعت منه أثناء تأدية وظيفته أو بـسببها، ما لم تكن من الجرائم المنصوص عليها في المادة  ١٢٣من قانون العقوبات.
ويحصل الاستئناف بتقرير في قلم الكتاب في ميعاد عشرة أيام من تاريخ الإعلان بالأمر.
ويرفع الاستئناف إلى محكمة جنايات أول درجة منعقـدة فـي غرفـة المـشورة في مواد الجنايات ،وإلى محكمة الجـنح المـستأنفة منعقـدة فـي غرفـة المـشورة في مواد الجنح.
وعلى غرفة المشورة عند إلغاء الأمر بأن لا وجه لإقامة الدعوى أن تعيد القضية إلى النيابة العامة معينة الجريمة المرتكبة ونص القانون المنطبق عليها وأقوال شـهود الإثبات ومضمون أدلة الإثبات الأخرى ،وذلك لإحالتها إلى المحكمة المختصة.
وتكون القرارات الصادرة من غرفة المشورة وفق ًا لأحكام هذا الفصل نهائية.$b164510$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins164;

WITH ins165 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 165, 0, $h165514$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h165514$, $t165515$مادة (165)$t165515$, $b165513$يجوز لجميع الخصوم أن يـستأنفوا الأوامـر المتعلقـة بمـسائل الاختـصاص ولا يوقف الاستئناف سير التحقيق ولا يترتب على القضاء بعدم الاختـصاص بطـلان إجراءات التحقيق.
ويكون ميعاد استئناف تلك الأوامر عشرة أيام من تاريخ إعلان الخصوم بها.$b165513$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins165;

WITH ins166 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 166, 0, $h166517$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h166517$, $t166518$مادة (166)$t166518$, $b166516$يجوز للمتهم أن يستأنف الأمر الصادر بحبسه احتياطيـا أو بمـد مـدة الحـبس، وللنيابة العامة إذا استلزمت ضرورة التحقيق أن تـستأنف الأمـر الـصادر بـالإفراج المؤقت عن المتهم المحبوس احتياطيا.$b166516$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins166;

WITH ins167 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 167, 0, $h167520$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h167520$, $t167521$مادة (167)$t167521$, $b167519$يكون استئناف الأوامر الصادرة وفق ًـا لأحكـام هـذا الفـصل بتقريـر يـودع قلم كتاب المحكمة.$b167519$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins167;

WITH ins168 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 168, 0, $h168523$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h168523$, $t168524$مادة (168)$t168524$, $b168522$يكون ميعاد استئناف النيابة العامة لأمر الإفراج المؤقت أربعا وعـشرين سـاعة من تاريخ صدوره ،ويجب الفصل فـي الاسـتئناف خـلال ثمـانٍ وأربعـين سـاعة من تاريخ رفعه.
ويكون استئناف المتهم لأمر الحبس أو مد مدته في أي وقت ،فإذا صـدر قـرار برفض استئنافه جاز له أن يتقدم باستئناف جديد على ذات القرار كلما انقـضت مـدة ثلاثين يوما من تاريخ صدور قرار رفض الاستئناف.$b168522$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins168;

WITH ins169 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 169, 0, $h169526$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h169526$, $t169527$مادة (169)$t169527$, $b169525$يرفع الاستئناف أمام محكمة الجنح المستأنفة منعقدة في غرفة المـشورة إذا كـان الأمر المستأنف صادرا من القاضي الجزئي بالحبس الاحتياطي أو بمده أو بـالإفراج، فإذا كان الأمر صادرا من تلك المحكمة ،يرفع الاستئناف إلـى محكمـة جنايـات أول درجة منعقدة في غرفة المشورة ،وإذا كان صادرا من محكمة جنايات أول درجة يرفع الاستئناف إلى محكمة الجنايات المستأنفة.$b169525$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins169;

WITH ins170 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 170, 0, $h170529$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h170529$, $t170530$مادة (170)$t170530$, $b170528$في غير الحالات المشار إليها في المواد من  ١٦٤إلى  ١٦٩من هـذا القـانون، يرفع الاستئناف أمام محكمة الجنح المستأنفة منعقدة في غرفة المشورة.$b170528$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins170;

WITH ins171 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 171, 0, $h171532$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h171532$, $t171533$مادة (171)$t171533$, $b171531$يتعين الفصل في استئناف أوامر الحبس الاحتياطي أو مده أو الإفـراج المؤقـت، خلال ثمان وأربعين ساعة من تاريخ رفع الاستئناف ،وإلا وجب الإفراج عـن المـتهم إذا كان الاستئناف على قرار الإفراج المؤقت.
وتخصص دائرة أو أكثر من دوائر المحكمـة الابتدائيـة أو محكمـة الجنايـات بدرجتيها لنظر استئناف أوامر الحبس الاحتياطي أو الإفراج المؤقت المشار إليهما فـي هذه المادة.$b171531$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins171;

WITH ins172 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 172, 0, $h172535$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h172535$, $t172536$مادة (172)$t172536$, $b172534$ينفذ الأمر الصادر بالإفراج المؤقت عن المتهم المحبوس احتياطيا ما لم تـستأنفه النيابة العامة في الميعاد المنصوص عليه في المادة  ١٦٨من هذا القانون.
ويجوز للمحكمة المختصة بنظر الاستئناف ،أن تأمر بمد حبس المتهم طبق ًـا لمـا هو مقرر في المادتين  ١٢٤ ،١٢٣من هذا القانون.
وإذا لم يفصل في الاستئناف خلال ثلاثة أيام من تاريخ التقرير به وجـب تنفيـذ الأمر بالإفراج فورا.$b172534$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins172;

WITH ins173 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 173, 0, $h173538$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الثالث التحقيق بمعرفة النيابة العامة - الفصل الثالث عشر استئناف الأوامر الصادرة من النيابة العامة$h173538$, $t173539$مادة (173)$t173539$, $b173537$إذا رفض الاستئناف المرفوع من المدعي بالحقوق المدنية عن الأمر الصادر بأن لا وجه لإقامة الدعوى جاز للجهة المرفوع إليها الاستئناف أن تحكـم عليـه لـصالح المتهم بالتعويضات الناشئة عن رفع الاستئناف إذا كان لذلك محل.$b173537$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins173;

WITH ins174 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 174, 0, $h174541$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الأول تعيين قاض للتحقيق$h174541$, $t174542$مادة (174)$t174542$, $b174540$إذا رأت النيابة العامة في مواد الجنايات أو الجنح أن تحقيـق الـدعوى بمعرفـة قاضي التحقيق أكثر ملاءمة بالنظر إلى ظروفها الخاصة ،جاز لها في أية حالة كانـت عليها الدعوى أن تطلب من رئيس المحكمة الابتدائية المختصة نـدب أحـد قـضاتها لمباشرة هذا التحقيق ،ويكون الندب بقرار من الجمعية العامة للمحكمة أو من تفوضـه في ذلك في بداية كل عام قضائي ،وفي هذه الحالـة يكـون القاضـي المنـدوب هـو المختص دون غيره بإجراء التحقيق من وقت مباشرته له.
ويجوز للمتهم أو للمدعي بالحقوق المدنية إذا لم تكن الدعوى موجهة ضد موظف عام أو مستخدم عام أو أحد رجال الضبط بجريمة وقعت منه أثنـاء تأديتـه لوظيفتـه أو بسببها أن يطلب من رئيس المحكمة الابتدائية إصدار قرار بهذا الندب.
وتصدر الجمعية العامة للمحكمة أو من تفوضه قرار الندب إذا تحققت الأسـباب المبينة بالفقرة الأولى من هذه المادة بعد سماع أقوال النيابة العامة.$b174540$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins174;

WITH ins175 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 175, 0, $h175544$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الأول تعيين قاض للتحقيق$h175544$, $t175545$مادة (175)$t175545$, $b175543$يجوز لوزير العدل أن يطلب من محكمة الاستئناف ندب قاض لتحقيـق جريمـة معينة أو جرائم من نوع معين ،ويكون الندب بقرار من الجمعية العامة للمحكمة أو من تفوضه في ذلك في بداية كل عام قضائي ،وفي هذه الحالة يكون القاضي المندوب هـو المختص دون غيره بإجراء التحقيق من وقت مباشرته له.$b175543$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins175;

WITH ins176 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 176, 0, $h176547$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الأول تعيين قاض للتحقيق$h176547$, $t176548$مادة (176)$t176548$, $b176546$يجب على قاضي التحقيق المندوب وفق ًا لأحكام المادتين  ١٧٥ ،١٧٤مـن هـذا القانون أن ينتهي من التحقيق خلال مدة لا تجاوز ستة أشهر من وقت مباشرته ،إلا إذا حال دون ذلك ضرورات يستلزمها التحقيق ،فإذا استلزم التحقيق تجـاوز هـذه المـدة وجب علي قاضى التحقيق المندوب العرض على الجمعية العامة أو من تفوضـه فـي إصدار قرار الندب ،بحسب الأحوال ،لتجديده مدة لا تجاوز ستة أشهر ،وإذا لم يستلزم التحقيق تجاوز هذه المدة أو خالف قاضي التحقيق المندوب إجراءات عرض الـدعوى، ندبت الجمعية العامة أو من تفوضه قاضيا آخر لاستكمال التحقيق.$b176546$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins176;

WITH ins177 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 177, 0, $h177550$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الأول تعيين قاض للتحقيق$h177550$, $t177551$مادة (177)$t177551$, $b177549$لا يجوز لقاضي التحقيق مباشرة التحقيق في جريمة معينة أو جرائم مـن نـوع معين ،إلا بناء على طلب من النيابة العامة أو بناء على إحالتهـا إليـه مـن الجهـات الأخرى المنصوص عليها في القانون.$b177549$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins177;

WITH ins178 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 178, 0, $h178553$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h178553$, $t178554$مادة (178)$t178554$, $b178552$مع عدم الإخلال بما ورد في شأنه نص خاص في هذا الفصل ،يباشـر قاضـي التحقيق اختصاصه طبق ًا للأحكام المقررة في شأن التحقيق بمعرفة النيابة العامة.$b178552$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins178;

WITH ins179 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 179, 0, $h179556$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h179556$, $t179557$مادة (179)$t179557$, $b179555$مع عدم الإخلال بأحكام المادة  ١٧٦من هذا القانون ،إذا أحيلـت الـدعوى إلـى قاضي التحقيق كان مختصا دون غيره بتحقيقها.$b179555$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins179;

WITH ins180 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 180, 0, $h180559$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h180559$, $t180560$مادة (180)$t180560$, $b180558$يجوز لقاضي التحقيق أن يندب أحد أعضاء النيابة العامة أو أحد مأموري الضبط القضائي للقيام بعمل معين أو أكثر من أعمال التحقيق عدا استجواب المتهم.
ويكون للمندوب في حدود ندبه كل السلطة التي لقاضي التحقيق.
وله إذا كانت هناك حاجة لاتخاذ إجراء من الإجراءات خارج دائرة اختـصاصه أن يطلب من قاضي محكمة الجهة أو أحد أعضاء النيابة العامة أو يكلف أحد مأموري الضبط القضائي بها.
ولقاضي محكمة الجهة المندوب أن يكلف بذلك عند الضرورة أحد أعضاء النيابة العامة أو أحد مأموري الضبط القضائي طبق ًا للفقرة الأولى من هذه المادة.
ويجب على قاضي التحقيق أن ينتقل بنفسه للقيام بهذا الإجـراء كلمـا اقتـضت مصلحة التحقيق ذلك.$b180558$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins180;

WITH ins181 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 181, 0, $h181562$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h181562$, $t181563$مادة (181)$t181563$, $b181561$يجب على قاضي التحقيق في جميع الأحوال التي يندب فيها غيره لإجراء بعـض أعمال التحقيقات أن يبين المسائل المطلوب تحقيقها ،والإجراءات المطلوب اتخاذها.
وللمندوب أن يجري أي عمل آخر من أعمال التحقيق أو أن يستجوب المتهم فـي الأحوال التي يخشى فيها فوات الوقت متى كان ذلك متصلا بالعمل المندوب له ولازما في كشف الحقيقة.$b181561$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins181;

WITH ins182 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 182, 0, $h182565$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h182565$, $t182566$مادة (182)$t182566$, $b182564$يكون لقاضي التحقيق عند مباشرة التحقيق السلطات المخولة للقاضـي الجزئـي الواردة في هذا القانون.$b182564$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins182;

WITH ins183 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 183, 0, $h183568$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h183568$, $t183569$مادة (183)$t183569$, $b183567$يكون لقاضي التحقيـق ذات الاختـصاصات المقـررة للمحكمـة فيمـا يتعلـق بنظام الجلسة.$b183567$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins183;

WITH ins184 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 184, 0, $h184571$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h184571$, $t184572$مادة (184)$t184572$, $b184570$تقوم النيابة العامة بإعلان الشهود الذين يقرر قاضى التحقيق سماعهم على النحـو المبين بالمادة  ٨٨من هذا القانون.$b184570$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins184;

WITH ins185 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 185, 0, $h185574$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h185574$, $t185575$مادة (185)$t185575$, $b185573$يجب على كل من دعي للحضور أمام قاضي التحقيق لتأدية شـهادة أن يحـضر بناء على الطلب المحرر إليه ،وإلا جاز للقاضي الحكم عليه بعد سماع أقـوال النيابـة العامة بدفع غرامـة لا تجـاوز خمـسمائة جنيـه ،ويجـوز لـه أن يـصدر أمـرا بتكليفه بالحضور مرة أخرى بمصاريف مـن طرفـه ،أو أن يـصدر أمـرا مـسببا بضبطه وإحضاره.$b185573$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins185;

WITH ins186 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 186, 0, $h186577$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h186577$, $t186578$مادة (186)$t186578$, $b186576$إذا حضر الشاهد أمام القاضي بعد تكليفه بالحضور مرة أخرى أو من تلقاء نفـسه وأبدى أعذارا مقبولة ،جاز إعفاؤه من الغرامة بعد سماع أقوال النيابـة العامـة ،كمـا يجوز إعفاؤه بناء على طلب يقدم منه إذا لم يستطع الحضور بنفسه.$b186576$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins186;

WITH ins187 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 187, 0, $h187580$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h187580$, $t187581$مادة (187)$t187581$, $b187579$إذا حضر الشاهد أمام القاضي وامتنع عن أداء الشهادة أو عن حلف اليمين ،يحكم عليه القاضي في الجنح والجنايات بعد سماع أقوال النيابة العامة بغرامة لا تجاوز ألفى جنيه.
ويجوز إعفاؤه من كل العقوبة أو بعضها إذا عدل عن امتناعه قبل انتهاء التحقيق.$b187579$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins187;

WITH ins188 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 188, 0, $h188583$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h188583$, $t188584$مادة (188)$t188584$, $b188582$إذا كان الشاهد مريضا أو لديه ما يمنعه من الحضور تسمع شـهادته فـي محـل وجوده ،فإذا انتقل القاضي لسماع شهادته ،وتبين له عدم صحة العذر جاز له أن يحكـم عليه بالحبس مدة لا تزيد على شهر أو بغرامة لا تجاوز ألفى جنيه.$b188582$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins188;

WITH ins189 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 189, 0, $h189586$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h189586$, $t189587$مادة (189)$t189587$, $b189585$يجوز الطعن في الأحكام الصادرة على الشهود من قاضي التحقيق ،طبق ًا للمـواد ١٨٨ ،١٨٧ ،١٨٥من هذا القانون أمام المحكمة المختصة بنظر القضية المحكوم فيها على الشهود بتلك الأحكام.$b189585$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins189;

WITH ins190 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 190, 0, $h190589$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h190589$, $t190590$مادة (190)$t190590$, $b190588$يجوز للنيابة العامة الاطلاع في أي وقت على الأوراق ،لتقف علـى مـا جـرى في التحقيق ،على ألا يترتب على ذلك تأخير السير فيه.$b190588$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins190;

WITH ins191 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 191, 0, $h191592$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h191592$, $t191593$مادة (191)$t191593$, $b191591$يجوز للنيابة العامة وباقي الخصوم أن يقـدموا إلـى قاضـي التحقيـق الـدفوع والطلبات والملاحظات التي يرون تقديمها أثناء التحقيق.$b191591$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins191;

WITH ins192 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 192, 0, $h192595$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h192595$, $t192596$مادة (192)$t192596$, $b192594$يفصل قاضي التحقيق خلال أربـع وعـشرين سـاعة فـي الـدفوع والطلبـات والملاحظات المقدمة إليه ،ويبين الأسباب التي يستند إليها.$b192594$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins192;

WITH ins193 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 193, 0, $h193598$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h193598$, $t193599$مادة (193)$t193599$, $b193597$إذا لم تكن أوامر قاضي التحقيق صدرت في مواجهة الخصوم تبلغ إلـى النيابـة العامة ،وعليها أن تعلنهم بها خلال أربع وعشرين ساعة من تاريخ صدورها.$b193597$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins193;

WITH ins194 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 194, 0, $h194601$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h194601$, $t194602$مادة (194)$t194602$, $b194600$مع مراعاة حكم الفقرة الثانية من المادة  ١١٢من هذا القانون ،يجب على قاضي التحقيق أن يستجوب فورا المتهم المقبوض عليه ،وإذا تعذر ذلك يودع في أحد مراكز الإصلاح والتأهيل أو أماكن الاحتجاز إلى حين استجوابه ،ويجب ألا تزيد مدة إيداعه على أربع وعشرين ساعة فإذا مضت هذه المدة وجب على القائم على إدارة تلك الأماكن أو هذه المراكز تسليمه إلى النيابة العامة ،وعليها أن تطلب في الحال من قاضي التحقيق استجوابه ،وعند الاقتضاء تطلب ذلك من القاضي الجزئي أو رئيس المحكمة ،أو أي قاض آخر يعينه رئيس المحكمة وإلا أمرت بإخلاء سبيله.$b194600$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins194;

WITH ins195 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 195, 0, $h195604$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h195604$, $t195605$مادة (195)$t195605$, $b195603$إذا قبض على المتهم خارج دائرة المحكمة التي يجرى التحقيق فيها يرسـل إلـى النيابة العامة بالجهة التي قبض عليه فيها ،وعلى النيابة العامة أن تتحقق مـن جميـع البيانات الخاصة بشخصه ،وتحيطه علما بالواقعة المنسوبة إليه ،وتـدون أقوالـه فـي شأنها ،وترسله خلال أربع وعشرين ساعة إلى قاضي التحقيق المختص.
وإذا اعترض المتهم على نقله أو كانت حالته الصحية لا تـسمح بالنقـل يخطـر قاضي التحقيق بذلك ،وعليه أن يصدر أمره فورا بالإجراء الواجب اتباعه.$b195603$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins195;

WITH ins196 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 196, 0, $h196607$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h196607$, $t196608$مادة (196)$t196608$, $b196606$يجب على قاضي التحقيق قبل أن يصدر أمرا بالحبس أو التدبير أن يسمع أقـوال النيابة العامة ودفاع المتهم.$b196606$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins196;

WITH ins197 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 197, 0, $h197610$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h197610$, $t197611$مادة (197)$t197611$, $b197609$يجوز للنيابة العامة أن تطلب من قاضي التحقيق فـي أي وقـت حـبس المـتهم احتياطيا أو إخضاعه لأحد التدابير المنصوص عليها في المادة  ١١٤من هذا القانون.$b197609$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins197;

WITH ins198 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 198, 0, $h198613$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h198613$, $t198614$مادة (198)$t198614$, $b198612$مع مراعاة حكم الفقرة الثانية من المادة  ١٢١من هذا القـانون ،ينتهـي الحـبس الاحتياطي أو التدبير حتما بمضي خمسة عشر يوما ،ومع ذلك يجوز لقاضي التحقيـق بعد سماع أقوال النيابة العامة والمتهم أن يصدر أمرا بمـد الحـبس أو التـدبير لمـدد متعاقبة بحيث لا تزيد كل منها على خمسة عشر يوما ولا يزيد مجموعها على خمـسة وأربعين يوما.
فإذا لم ينته التحقيق ،ورأى قاضي التحقيق مد الحبس الاحتياطي أو التدبير زيـادة على ما هو مقرر في الفقرة الأولى من هذه المادة تعين الالتزام بأحكام المـادتين ،١٢٣ ١٢٤من هذا القانون.$b198612$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins198;

WITH ins199 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 199, 0, $h199616$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h199616$, $t199617$مادة (199)$t199617$, $b199615$يجوز لقاضي التحقيق في كل وقت سواء من تلقاء نفسه أو بناء على طلب المتهم أن يأمر بعد سماع أقوال النيابة العامة بالإفراج عن المتهم أو بإنهاء التدبير إذا كان هو الذي أمر بالحبس الاحتياطي أو بالتدبير أو طلب منه ذلك.
فإذا كان الأمر بالحبس الاحتياطي أو التدبير صادرا مـن محكمـة الجنايـات أو الجنح المستأنفة منعقدة في غرفة المشورة بناء على اسـتئناف النيابـة العامـة للأمـر بالإفراج السابق صدوره من قاضي التحقيق ،فلا يجوز صدور أمر بـالإفراج خـلال المدة التي صدر بها الأمر بالحبس أو بإنهاء التدبير إلا من أي منهما ،بحسب الأحوال.$b199615$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins199;

WITH ins200 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 200, 0, $h200619$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h200619$, $t200620$مادة (200)$t200620$, $b200618$يرسل قاضي التحقيق الأوراق إلى النيابة العامة بعد انتهاء التحقيـق ،وعليهـا أن تقدم له طلباتها كتابة خلال ثلاثة أيام إذا كان المتهم محبوسا أو خاضعا لأحد التـدابير، وعشرة أيام إذا كان مفرجا عنه.
وعلى قاضي التحقيق أن يخطر باقي الخصوم لإبداء ما لديهم من أقـوال خـلال ثلاثة أيام من تاريخ إخطارهم.$b200618$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins200;

WITH ins201 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 201, 0, $h201622$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h201622$, $t201623$مادة (201)$t201623$, $b201621$إذا رأى قاضي التحقيق أنه لا وجه لإقامة الدعوى الجنائية ،يصدر أمرا مكتوبـا بذلك ،ويفرج عن المتهم المحبوس ما لم يكن محبوسا لسبب آخر ،أو بإنهاء التدبير.
ولا يجوز له أن يصدر الأمر بأن لا وجه لإقامة الدعوى الجنائية لعدم الأهمية إلا بناء على طلب النيابة العامة.
ويجب أن يشتمل الأمر على الأسباب التي بني عليها.
ويعلن الأمر للنيابة العامة ،وللمتهم ،وللمجني عليه وللمدعي بـالحقوق المدنيـة، وإذا كان أحدهم قد توفى يكون الإعلان لورثته جملة ،دون ذكر أسمائهم ،وذلـك فـي آخر موطن كان لمورثهم.$b201621$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins201;

WITH ins202 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 202, 0, $h202625$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h202625$, $t202626$مادة (202)$t202626$, $b202624$إذا رأى قاضي التحقيق أن الواقعة جنحة ،وأن الأدلة على المـتهم كافيـة يـأمر بإحالتها إلى المحكمة الجزئية المختصة بنظرها ،ما لم تكن الجريمة من الجنح التي تقع بواسطة الصحف أو غيرها من طرق النشر عدا الجنح المضرة بأفراد الناس ،فيحيلهـا إلى محكمة جنايات أول درجة فإذا تبين لقاضي التحقيق أن الواقعـة مخالفـة يحيلهـا للنيابـة العامـة لاتخـاذ شئونها فيها.$b202624$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins202;

WITH ins203 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 203, 0, $h203628$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h203628$, $t203629$مادة (203)$t203629$, $b203627$يتعين على النيابة العامة عند صدور القرار بإحالة الدعوى إلى المحكمة الجزئيـة المختصة أن تقوم بإرسال جميع الأوراق إلى قلم كتاب المحكمة خـلال ثلاثـة أيـام، وبإعلان الخصوم بالحضور أمام المحكمة في أقرب جلسة وفي المواعيد المقررة.$b203627$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins203;

WITH ins204 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 204, 0, $h204631$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h204631$, $t204632$مادة (204)$t204632$, $b204630$إذا رأى قاضي التحقيق أن الواقعة جناية أو من الجنح التي تقع بواسطة الصحف أو غيرها من طرق النشر عدا الجنح المضرة بأفراد الناس ،وأن الأدلة علـى المـتهم كافية يحيل الدعوى إلى محكمة جنايات أول درجة ،ويكلف النيابـة العامـة بإرسـال الأوراق إليها فورا.$b204630$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins204;

WITH ins205 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 205, 0, $h205634$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h205634$, $t205635$مادة (205)$t205635$, $b205633$تسري في شأن الأوامر التي تصدر من قاضي التحقيق الأحكام المنصوص عليها في المواد  ١٥٧ ،١٥٢ ،١١٦ ،١٠٨من هذا القانون.$b205633$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins205;

WITH ins206 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 206, 0, $h206637$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثاني مباشرة قاضي التحقيق لاختصاصه$h206637$, $t206638$مادة (206)$t206638$, $b206636$لا تجوز العودة إلى التحقيق طبق ًا لحكم المادة  ١٦٣من هذا القانون إلا بناء علـى طلب النيابة العامة.$b206636$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins206;

WITH ins207 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 207, 0, $h207640$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثالث استئناف الأوامر الصادرة من قاضي التحقيق$h207640$, $t207641$مادة (207)$t207641$, $b207639$يجوز للنيابة العامة أن تستأنف ولو لمصلحة المتهم جميع الأوامر التي يـصدرها قاضي التحقيق سواء من تلقاء نفسه أو بناء على طلب الخصوم.$b207639$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins207;

WITH ins208 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 208, 0, $h208643$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثالث استئناف الأوامر الصادرة من قاضي التحقيق$h208643$, $t208644$مادة (208)$t208644$, $b208642$يجوز للمتهم أن يستأنف الأمر الصادر من قاضي التحقيق بحبسه احتياطيا أو بمد مدة الحبس.$b208642$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins208;

WITH ins209 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 209, 0, $h209646$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثالث استئناف الأوامر الصادرة من قاضي التحقيق$h209646$, $t209647$مادة (209)$t209647$, $b209645$يجوز للمتهم وللمدعي بالحقوق المدنية استئناف الأوامر الـصادرة مـن قاضـي التحقيق بأن لا وجه لإقامة الدعوى ،إلا إذا كان الأمر صادرا في تهمة موجهـة ضـد موظف عام أو مستخدم عام أو أحد رجال الضبط لجريمة وقعـت منـه أثنـاء تأديـة وظيفته أو بسببها ،ما لم تكن من الجرائم المنصوص عليها في المادة  ١٢٣من قـانون العقوبات.$b209645$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins209;

WITH ins210 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 210, 0, $h210649$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثالث استئناف الأوامر الصادرة من قاضي التحقيق$h210649$, $t210650$مادة (210)$t210650$, $b210648$يجوز لجميع الخصوم أن يستأنفوا الأوامر المتعلقـة بمـسائل الاختـصاص ،ولا يوقف الاستئناف سير التحقيق ،ولا يترتب على القضاء بعـدم الاختـصاص بطـلان إجراءات التحقيق.$b210648$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins210;

WITH ins211 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 211, 0, $h211652$الكتاب الأول الدعوى الجنائية وجمع الاستدلالات والتحقيق - الباب الرابع التحقيق بمعرفة قاضي التحقيق - الفصل الثالث استئناف الأوامر الصادرة من قاضي التحقيق$h211652$, $t211653$مادة (211)$t211653$, $b211651$يكون ميعاد استئناف الأوامر المشار إليها في هذا الفصل ،عشرة أيام من تـاريخ إعلان النيابة العامة وباقي الخصوم بها ،عدا الحالات المشار إليها في المادة  ٢٠٨مـن هذا القانون فيكون ميعاد استئنافها على النحو المقرر بالمادة  ١٦٨من هذا القانون.
ويحصل الاستئناف بتقرير في قلم الكتاب ويتبع فـي شـأن إجراءاتـه ونظـره والفصل فيه القواعد والأحكام المنصوص عليها بالمواد الخاصـة باسـتئناف الأوامـر الصادرة من النيابة العامة.$b211651$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins211;

WITH ins212 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 212, 0, $h212655$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الأول اختصاص المحاكم الجنائية فى المواد الجنائية$h212655$, $t212656$مادة (212)$t212656$, $b212654$تحكم المحكمة الجزئية في كل واقعة تعد بمقتضى القانون جنحة عدا الجنح التـي تقع بواسطة الصحف أو غيرها من طرق النشر على غير الأفراد.$b212654$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins212;

WITH ins213 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 213, 0, $h213658$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الأول اختصاص المحاكم الجنائية فى المواد الجنائية$h213658$, $t213659$مادة (213)$t213659$, $b213657$تحكم محكمة الجنايات في كل واقعة تعد بمقتضى القانون جناية وفي الجنح التـي تقع بواسطة الصحف أو غيرها من طرق النشر عدا الجنح المـضرة بـأفراد النـاس، وفى غيرها من الجرائم الأخرى التي ينص القانون على اختصاصها بها.$b213657$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins213;

WITH ins214 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 214, 0, $h214661$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الأول اختصاص المحاكم الجنائية فى المواد الجنائية$h214661$, $t214662$مادة (214)$t214662$, $b214660$يحدد الاختصاص بالمكان الذي وقعت فيه الجريمة ،أو الذي يقـيم فيـه المـتهم، أو الذي يقبض عليه فيه.$b214660$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins214;

WITH ins215 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 215, 0, $h215664$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الأول اختصاص المحاكم الجنائية فى المواد الجنائية$h215664$, $t215665$مادة (215)$t215665$, $b215663$في حالة الشروع تعتبر الجريمة وقعت في كل محل وقع فيه عمل مـن أعمـال البدء في التنفيذ.
وفي الجرائم المستمرة يعتبر مكان ًا للجريمة كل محل تقوم فيه حالة الاستمرار.
وفي جرائم الاعتياد والجرائم المتتابعة يعتبر مكا  ًنا للجريمة كل محل يقع فيه أحـد الأفعال الداخلة فيها.
وإذا وقعت في الخارج جريمة من الجرائم التي تـسري عليهـا أحكـام القـانون المصري ولم يكن لمرتكبها محل إقامة في مصر ولم يضبط فيها ،ترفع عليه الـدعوى في الجنايات أمام محكمة جنايات أول درجة بدائرة محكمة استئناف القاهرة وفي الجنح أمام محكمة عابدين الجزئية.$b215663$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins215;

WITH ins216 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 216, 0, $h216667$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثانى اختصاص المحاكم الجنائية فى المسائل التى يتوقف عليها الفصل فى الدعوى الجنائية$h216667$, $t216668$مادة (216)$t216668$, $b216666$يجوز رفع الدعوى المدنية ،مهما بلغت قيمتها ،بتعويض الـضرر الناشـئ عـن الجريمة أمام المحاكم الجنائية لنظرها مع الدعوى الجنائية.$b216666$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins216;

WITH ins217 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 217, 0, $h217670$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثانى اختصاص المحاكم الجنائية فى المسائل التى يتوقف عليها الفصل فى الدعوى الجنائية$h217670$, $t217671$مادة (217)$t217671$, $b217669$تختص المحكمة الجنائية بالفصل في جميع المسائل التي يتوقف عليها الحكم فـي الدعوى الجنائية المرفوعة أمامها ،ما لم ينص القانون على خلاف ذلك.$b217669$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins217;

WITH ins218 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 218, 0, $h218673$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثانى اختصاص المحاكم الجنائية فى المسائل التى يتوقف عليها الفصل فى الدعوى الجنائية$h218673$, $t218674$مادة (218)$t218674$, $b218672$إذا كان الحكم في الدعوى الجنائية يتوقف على نتيجة الفصل في دعـوى جنائيـة أخرى ،وجب وقف الدعوى الجنائية الأولى حتى يتم الفصل في الأُخرى.$b218672$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins218;

WITH ins219 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 219, 0, $h219676$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثانى اختصاص المحاكم الجنائية فى المسائل التى يتوقف عليها الفصل فى الدعوى الجنائية$h219676$, $t219677$مادة (219)$t219677$, $b219675$إذا كان الحكم في الدعوى الجنائية يتوقف على الفصل في مـسألة مـن مـسائل الأحوال الشخصية جاز للمحكمة الجنائية أن توقف الدعوى وتحدد للمـتهم أو المجنـى عليه أو المدعي بالحقوق المدنية بحسب الأحوال أجلا ً لرفع المـسألة المـذكورة إلـى الجهة ذات الاختصاص.
ولا يمنع وقف الدعوى مـن اتخـاذ الإجـراءات ،أو التحقيقـات الـضرورية، أو المستعجلة.$b219675$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins219;

WITH ins220 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 220, 0, $h220679$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثانى اختصاص المحاكم الجنائية فى المسائل التى يتوقف عليها الفصل فى الدعوى الجنائية$h220679$, $t220680$مادة (220)$t220680$, $b220678$إذا انقضى الأجل المشار إليه في المادة  ٢١٩من هذا القانون ولم ترفع الـدعوى إلى الجهة ذات الاختصاص ،يجوز للمحكمة أن تصرف النظر عـن وقـف الـدعوى وتفصل فيها.
كما يجوز لها أن تحدد للخصم أجـلا ً آخـر إذا رأت أن هنـاك أسـبابا مقبولـة تبرر ذلك.$b220678$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins220;

WITH ins221 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 221, 0, $h221682$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثانى اختصاص المحاكم الجنائية فى المسائل التى يتوقف عليها الفصل فى الدعوى الجنائية$h221682$, $t221683$مادة (221)$t221683$, $b221681$تتبع المحاكم الجنائية في المسائل غير الجنائية التي تفصل فيهـا تبعـا للـدعوى الجنائية طرق الإثبات المقررة في القانون الخاص بتلك المسائل.$b221681$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins221;

WITH ins222 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 222, 0, $h222685$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثالث تنازع الاختصاص$h222685$, $t222686$مادة (222)$t222686$, $b222684$إذا قدمت دعوى عن جريمة واحدة أو عدة جرائم مرتبطة إلى جهتين من جهـات التحقيق أو الحكم تابعتين لمحكمة ابتدائية واحدة وقررت كل منهما نهائيا اختـصاصها أو عدم اختصاصها وكان الاختصاص منحصرا فيهما ،يرفع طلب تحديد الجهة التـي تفصل فيها إلى دائرة الجنح المستأنفة بالمحكمة الابتدائية.$b222684$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins222;

WITH ins223 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 223, 0, $h223688$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثالث تنازع الاختصاص$h223688$, $t223689$مادة (223)$t223689$, $b223687$إذا صدر حكمان بالاختصاص ،أو بعدم الاختصاص من جهتين تابعتين لمحكمتين ابتدائيتين أو من محكمتين ابتدائيتين أو من محكمتين من محاكم الجنايـات بـدرجتيهما يرفع طلب تحديد المحكمة المختصة إلى محكمة النقض.$b223687$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins223;

WITH ins224 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 224, 0, $h224691$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثالث تنازع الاختصاص$h224691$, $t224692$مادة (224)$t224692$, $b224690$يجوز لكل من الخصوم في الدعوى تقديم طلب تحديد المحكمة التي تفصل فيهـا بعريضة مشفوعة بالأوراق المؤيدة لهذا الطلب.$b224690$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins224;

WITH ins225 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 225, 0, $h225694$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثالث تنازع الاختصاص$h225694$, $t225695$مادة (225)$t225695$, $b225693$تأمر المحكمة بعد اطلاعها على الطلب بإيداع الأوراق في قلم الكتاب.
ويجب على قلم الكتاب إعلان باقي الخصوم بإيـداع الأوراق ليطلعـوا عليهـا، ويقدموا مذكرة بأقوالهم في مدة العشرة الأيام التالية لإعلانهم بالإيداع ،ويترتـب علـى أمر الإيداع وقف السير في الدعوى المقدم بشأنها الطلب ،ما لم تر المحكمة غير ذلك.$b225693$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins225;

WITH ins226 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 226, 0, $h226697$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثالث تنازع الاختصاص$h226697$, $t226698$مادة (226)$t226698$, $b226696$تحدد محكمة النقض أو المحكمة الابتدائية بعد الاطلاع علـى الأوراق المحكمـة ضا في شأن الإجراءات والأحكـام أو الجهة التي تتولى السير في الدعوى ،وتفصل أي التي تكون قد صدرت من المحاكم الأخرى التي قضت بإلغاء اختصاصها.$b226696$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins226;

WITH ins227 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 227, 0, $h227700$الكتاب الثانى المحاكم - الباب الأول الاختصاص - الفصل الثالث تنازع الاختصاص$h227700$, $t227701$مادة (227)$t227701$, $b227699$إذا رفض الطلب يجوز الحكم على الطالب إذا كان من غير النيابة العامة بغرامـة لا تتجاوز خمسمائة جنيه.$b227699$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins227;

WITH ins228 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 228, 0, $h228703$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الأول إعلان الخصوم$h228703$, $t228704$مادة (228)$t228704$, $b228702$تحال الدعوى إلى محكمة الجنح بناء على تكليف المتهم مباشرة بالحـضور مـن قِبل أحد أعضاء النيابة العامة أو من المدعي بالحقوق المدنية ،أو أمـر يـصدر مـن قاضي التحقيق أو محكمة الجنح المستأنفة منعقدة في غرفة المشورة.
ويجوز الاستغناء عن تكليف المتهم بالحضور إذا حضر الجلسة ووجهـت إليـه التهمة من النيابة العامة وقبل المحاكمة ،ومع ذلك لا يجوز للمدعي بالحقوق المدنية أن يرفع الدعوى إلى المحكمة بتكليف خصمه مباشرة بالحضور أمامها إذا صدر أمر مـن قاضي التحقيق أو النيابة العامة بأن لا وجه لإقامة الـدعوى الجنائيـة ولـم يـستأنف المدعي بالحقوق المدنية هذا الأمر في الميعاد أو استأنفه فأيدته محكمة الجنح المستأنفة منعقدة في غرفة المشورة ،أو إذا كانت الدعوى موجهة ضد موظف أو مستخدم عـام أو أحد رجال الضبط لجريمة وقعت منه أثناء تأدية وظيفته أو بسببها ما لم تكـن مـن الجرائم المشار إليها في المادة  ١٢٣من قانون العقوبات.
وفي جميع الأحوال ،لا يجوز رفع أو تحريك الدعاوى لوقف أو مصادرة الأعمال الفنية والأدبية والفكرية أو ضد مبدعيها إلا عن طريق النيابة العامة.$b228702$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins228;

WITH ins229 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 229, 0, $h229706$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الأول إعلان الخصوم$h229706$, $t229707$مادة (229)$t229707$, $b229705$يكون تكليف الخصوم بالحضور أمام المحكمة قبل انعقاد الجلسة بسبعة أيام كاملة على الأقل في الجنح غير مواعيد المسافة المنصوص عليها بقانون المرافعات المدنيـة والتجارية ،وذلك بناء على طلب النيابة العامة أو المدعي بالحقوق المدنية.
وتذكر في ورقة التكليف بالحضور بيانات المتهم ،ورقمه القومي أو رقـم وثيقـة سفره وموطنه إذا كان أجنبيا ،والتهمة ،ومواد القانون التي تنص على العقوبة.
ويجوز في حالة التلبس ،وفي الحالات التي يكون فيها المتهم محبوسـا احتياطيـا في إحدى الجنح ،أن يكون التكليف بالحضور بغير ميعاد ،فإذا حضر المـتهم وطلـب إعطاءه ميعادا لتحضير دفاعه تأذن له المحكمـة بالميعـاد المقـرر بـالفقرة الأولـى من هذه المادة.$b229705$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins229;

WITH ins230 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 230, 0, $h230709$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الأول إعلان الخصوم$h230709$, $t230710$مادة (230)$t230710$, $b230708$تعلن ورقة التكليف بالحضور على النحو المنصوص عليـه بـالفقرتين الأولـى والثانية من المادة  ٧٢من هذا القانون أو لشخص المعلن إليه أو في موطنـه المثبـت ببطاقة رقمه القومي.
وإذا لم يجد المحضر الشخص المطلوب إعلانه في موطنه كان عليـه أن يـسلم الورقة إلى من يقرر أنه وكيله أو أنه يعمل في خدمته أو أنه من القـاطنين معـه مـن الأزواج والأقارب والأصهار.
وإذا لم يكن للمتهم محل إقامة ثابت يسلم الإعلان للسلطة الإدارية التابع لها آخـر محل معلوم له ،ويعتبر المكان الذي وقعت فيه الجريمة آخر محل إقامة للمتهم مـا لـم يثبت خلاف ذلك.$b230708$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins230;

WITH ins231 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 231, 0, $h231712$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الأول إعلان الخصوم$h231712$, $t231713$مادة (231)$t231713$, $b231711$إذا لم يتمكن المحضر من تسليم الورقة طبق ًا للمـادة  ٢٣٠مـن هـذا القـانون، أو امتنع من وجده من المذكورين في الفقرة الثانية من تلك المادة عـن التوقيـع علـى الأصل بالاستلام أو عن استلام الصورة ،وجب على المحضر خلال أربـع وعـشرين ساعة أن يوجه إلى المعلن إليه رسالة نصية على الهاتف المحمـول المثبـت ببيانـات رقمه القومي تشمل جميع بيانات الإعلان ،ويرفق بملف القضية تقريـر مـن مركـز الإعلانات المنصوص عليه في المادة  ٢٣٢مـن هـذا القـانون باسـتلام الرسـالة، ومستخرج مطبوع لنص رسالة الإعلان.
وفي الأحوال التي يثبت فيها من تقرير مركز الإعلان تعذر استلام الرسالة ،أو إذا لم يوجد هاتف محمول مثبت ببيانات الرقم القومي للمعلن إليه ،أو إذا تعذر الإعلان من خلال المركز المشار إليه لأي سبب من الأسباب ،وجب على المحضر أن يسلم أصـل الإعلان خلال أربع وعشرين ساعة إلى مأمور القسم أو المركز أو العمدة أو شيخ البلد الذي يقع موطن المعلن إليه فـي دائرتـه ،بحـسب الأحـوال ،وذلـك بعـد توقيعـه على الأصل بالاستلام.
ويجب على المحضر خلال أربع وعشرين ساعة أن يوجه إلى المعلن إليـه فـي موطنه الأصلي كتابا مسجلا ً ،مرفق ًا به صورة أخرى من الورقـة ،يخبـره فيـه بـأن الصورة سلمت إلى جهة الإدارة.
كما يجب على المحضر أن يحرر محضرا بالإجراءات التي اتبعهـا يرفـق بـه صورة من الإعلان يودع بالقضية ،ويعتبر الإعلان منتجا لآثاره من وقت إرفاق تقرير استلام الرسالة أو من وقت تسليم الصورة إلى من سلمت إليه قانون ًا بحسب الأحوال.$b231711$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins231;

WITH ins232 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 232, 0, $h232715$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الأول إعلان الخصوم$h232715$, $t232716$مادة (232)$t232716$, $b232714$ينشأ بدائرة كل محكمة جزئية مركز للإعلانات الهاتفية يتبع وزارة العدل يختص بالاستعلام من قطاع الأحوال المدنية عن الرقم القومي للمتهم ورقم الهـاتف المحمـول المثبت به ،وفق ًا للنظم والقواعد المعمول بها فـي قطـاع الأحـوال المدنيـة وبمـا لا يتعارض مع مقتضيات الأمن القومي وسـرية قواعـد البيانـات القوميـة ،وإرسـال الإعلانات الهاتفية والإلكترونية وإعداد تقرير بما يفيد استلام تلك الرسائل.
ويقدر القاضي المختص الرسم المستحق على الإعلان الهاتفي وفق ًا لحكـم المـادة ١٦من القانون رقم  ٩٠لسنة  ١٩٤٤بشأن الرسوم القضائية ورسوم التوثيق في المواد المدنية ،على أن يلزم بأدائه من يحكم عليه بالمصاريف الجنائية.
ويخصص الرسم المشار إليه بالفقرة الثانية من هذه المادة للإنفاق علـى تطـوير مراكز الإعلان وإعداد قواعد البيانات اللازمة.$b232714$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins232;

WITH ins233 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 233, 0, $h233718$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الأول إعلان الخصوم$h233718$, $t233719$مادة (233)$t233719$, $b233717$يجب أن تشتمل الأوراق التي يقوم المحضرون بإعلانها على البيانات الآتية: -تاريخ اليوم والشهر والسنة والساعة التي حصل فيها الإعلان.
-بيان القضية المعلن بشأنها ،وموضوعها ،وصفة المعلن إليه فيها.
-اسم المحضر والمحكمة التي يعمل بها.
-اسم المعلن إليه ،ولقبه ،ومهنته أو وظيفته ،وموطنه فإن لم يكن موطنه معلوما وقت الإعلان فآخر موطن كان له.
-تاريخ ومكان انعقاد الإجراء المعلن بشأنه.
-اسم وصفة من سلمت إليه صورة الورقة ،وتوقيعه على الأصل بالاستلام.
-توقيع المحضر باسمه الثلاثي على كل من الأصل والصورة توقيعا مقروءا.
ويصدر قرار من وزير العدل ،بالتنسيق مع الوزير المختص بتحديد آليـة إثبـات تسلسل الإعلانات الهاتفية والإلكترونية ،وكيفية التحقق من وصولها.$b233717$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins233;

WITH ins234 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 234, 0, $h234721$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الأول إعلان الخصوم$h234721$, $t234722$مادة (234)$t234722$, $b234720$يكون إعلان النزيل بتسليم الأوراق المطلوب إعلانها إليه بشخصه ،وتفهيمـه مـا تضمنته في حضور مدير مركز الإصلاح والتأهيل العمومي أو مدير مركز الإصـلاح الجغرافي أو من يقوم مقامهما ،وإذا أبدى النزيل رغبة في إرسال صورة الإعلان إلـى شخص معين وجب إرسالها إليه بكتاب موصى عليه ،وإثبات هذه الإجراءات في سجل خاص يعد لهذا الغرض.
ويكون إعلان المحبوسين بالسجون العسكرية بتسليم الأوراق المطلـوب إعلانهـا إليه بشخصه ،وتفهيمه ما تضمنته بمعرفة هيئة التنظيم والإدارة بالقوات المسلحة ،وإذا أبدى النزيل رغبة في إرسال صورة الإعلان إلى شخص معين وجب إرسـالها إليـه بكتاب موصى عليه ،وإثبات هذه الإجراءات في سجل خاص يعد لهذا الغرض.$b234720$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins234;

WITH ins235 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 235, 0, $h235724$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الأول إعلان الخصوم$h235724$, $t235725$مادة (235)$t235725$, $b235723$يجوز للخصوم أن يطلعوا على أوراق الـدعوى بمجـرد إعلانهـم بالحـضور أمام المحكمة.$b235723$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins235;

WITH ins236 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 236, 0, $h236727$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثاني حضور الخصوم$h236727$, $t236728$مادة (236)$t236728$, $b236726$يجب على المتهم في جنحـة أن يحـضر بشخـصه ،أو بمحـام عنـه موك َـل، وإذا لم يكن له محام في الجنح التي يجوز الحبس فيها وجب على المحكمة أن تندب له محاميا للدفاع عنه ،وذلك مع عدم الإخلال بما للمحكمـة مـن الحـق فـي أن تـأمر بحضوره شخصيا.$b236726$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins236;

WITH ins237 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 237, 0, $h237730$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثاني حضور الخصوم$h237730$, $t237731$مادة (237)$t237731$, $b237729$إذا لم يحضر الخصم المكلف بالحضور حسب القانون في اليوم المبـين بورقـة التكليف بالحضور بشخصه ،أو لم يحضر وكيل عنه جاز الحكم في غيبته بعد الاطلاع على الأوراق ،إلا ّ إذا كانت ورقة التكليف بالحضور قد سلمت لشخصه أو على النحـو المنصوص عليه بالفقرتين الأولى والثانية من المادة  ٧٢مـن هـذا القـانون ،وتبـين للمحكمة أنه لا مبرر لعدم حضوره ،يعتبر الحكم حضوريا.
ويجوز للمحكمة بدلا ً من الحكم غيابيا أن تؤجل الدعوى إلى جلسة تاليـة وتـأمر بإعادة إعلان الخصم في موطنه ،مع تنبيهه إلى أنه إذا تخلـف هـو أو وكيلـه عـن الحضور في هذه الجلسة يعتبر الحكم حضوريا ،فإذا لم يحـضر هـو أو وكيلـه دون مبرر تقبله المحكمة يعتبر الحكم حضوريا.$b237729$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins237;

WITH ins238 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 238, 0, $h238733$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثاني حضور الخصوم$h238733$, $t238734$مادة (238)$t238734$, $b238732$يعتبر الحكم حضوريا بالنسبة إلى كل من يحضر من الخصوم عند النـداء علـى الدعوى ولو غادر الجلسة بعد ذلك ،أو إذا حضر أيا من الجلـسات ثـم تخلـف هـو أو وكيله عن الحضور في الجلسات التي تؤجل إليهـا الـدعوى دون أن يقـدم عـذرا تقبله المحكمة.$b238732$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins238;

WITH ins239 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 239, 0, $h239736$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثاني حضور الخصوم$h239736$, $t239737$مادة (239)$t239737$, $b239735$إذا رفعت الدعوى على عدة أشخاص عن واقعة واحدة وحضر بعضهم وتخلـف البعض الآخر رغم تكليفهم بالحضور حسب القانون تؤجل المحكمة الدعوى إلى جلسة تالية وتأمر بإعادة إعلان من تخلف في موطنه مع تنبيههم إلى أنهـم إذا تخلفـوا عـن الحضور في هذه الجلسة يعتبر الحكم حضوريا بالنسبة لهم ،فإذا لم يحـضروا وتبـين للمحكمة أن لا مبرر لعدم حضورهم يعتبر الحكم حضوريا بالنسبة لهم.$b239735$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins239;

WITH ins240 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 240, 0, $h240739$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثاني حضور الخصوم$h240739$, $t240740$مادة (240)$t240740$, $b240738$في الأحوال المنصوص عليها في المواد  ٢٣٩ ،٢٣٨ ،٢٣٧من هذا القانون التي يعتبر فيها الحكم حضوريا يجب على المحكمة أن تحقق الدعوى أمامها كما لـو كـان الخصم حاضرا.$b240738$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins240;

WITH ins241 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 241, 0, $h241742$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثاني حضور الخصوم$h241742$, $t241743$مادة (241)$t241743$, $b241741$إذا حضر الخصم قبل انتهاء الجلسة التي صدر فيها الحكم عليه في غيبته ،وجب إعادة نظر الدعوى في حضوره.$b241741$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins241;

WITH ins242 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 242, 0, $h242745$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث حفظ النظام في الجلسة$h242745$, $t242746$مادة (242)$t242746$, $b242744$ضبط الجلسة وإدارتها منوطان برئيسها ،وله في سبيل ذلك أن يخرج مـن قاعـة الجلسة من يخل بنظامها ،فإن لم يمتثل وتمادى ،يجوز للمحكمة أن تحكم علـى الفـور بحبسه أربعا وعشرين ساعة أو بتغريمه خمسمائة جنيه ويكون حكمها بذلك غير جـائز استئنافه ،فإذا كان الإخلال قد وقع ممن يؤدي وظيفة في المحكمة كان لهـا أن توقـع عليه أثناء انعقاد الجلسة ما للسلطة المختصة توقيعه من الجزاءات التأديبية.
ويجوز للمحكمة إلى ما قبل انتهاء الجلسة أن ترجع عن الحكم أو القـرار الـذي تصدره بناء على الفقرة الأولى من هذه المادة.$b242744$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins242;

WITH ins243 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 243, 0, $h243748$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث حفظ النظام في الجلسة$h243748$, $t243749$مادة (243)$t243749$, $b243747$إذا وقعت جنحة أو مخالفة في الجلسة يجوز للمحكمة أن تقيم الدعوى على المتهم في الحال ،وتحكم فيها بعد سماع أقوال النيابة العامة ودفاع المتهم.
ولا يتوقف رفع الدعوى في هذه الحالة على شكوى أو طلب إذا كانـت الجريمـة من الجرائم المنصوص عليها في المواد  ١٠ ،٨ ،٣من هذا القانون ،أمـا إذا وقعـت جناية يصدر رئيس المحكمة أمرا بإحالة المتهم إلى النيابة العامة دون إخـلال بحكـم المادة  ١٥من هذا القانون.
وفي جميع الأحوال ،يحرر رئيس المحكمة محضرا ويأمر بالقبض على المتهم إذا اقتضى الحال ذلك.$b243747$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins243;

WITH ins244 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 244, 0, $h244751$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث حفظ النظام في الجلسة$h244751$, $t244752$مادة (244)$t244752$, $b244750$مع عدم الإخلال بالضمانات المقررة في قانون المحاماة وتعديلاته ،إذا وقـع مـن المحامي أثناء قيامه بواجبه في الجلسة وبسببه ما يجوز اعتباره إخلالا ً بنظام الجلـسة، أو ما يستدعي مؤاخذته جنائيا يحرر رئيس الجلسة ،مذكرة بما حدث.
وللمحكمة إحالة المذكرة إلى النيابة العامة لإجراء التحقيق إذا كان ما وقـع منـه يستدعي مؤاخذته جنائيا ،وإلى رئيس المحكمة إذا كان ما وقع منه يـستدعي مؤاخذتـه تأديبيا ،وتخطر النقابة الفرعية المختصة بذلك.
وفي جميع الأحوال لا يجوز أن يكون رئيس الجلسة التي وقع فيهـا الحـادث أو أحد أعضائها عضوا في الهيئة التي تنظر الدعوى.
وذلك ك ُله مع عدم الإخلال بحالة التلبس.$b244750$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins244;

WITH ins245 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 245, 0, $h245754$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث حفظ النظام في الجلسة$h245754$, $t245755$مادة (245)$t245755$, $b245753$الجرائم التي تقع في الجلسة ولم ت ُقم المحكمة الدعوى فيها حال انعقادهـا ،يكـون نظرها وفقا للقواعد العادية.$b245753$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins245;

WITH ins246 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 246, 0, $h246757$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الرابع تنحى القضاة وردهم عن الحكم$h246757$, $t246758$مادة (246)$t246758$, $b246756$يمتنع على القاضي أن يشترك في نظر الدعوى إذا كانت الجريمة قد وقعت عليـه شخصيا ،أو إذا كان قد قام في الدعوى بعمل مأمور الـضبط القـضائي ،أو بوظيفـة النيابة العامة ،أو المدافع عن أحد من الخصوم ،أو أدى فيها شهادة ،أو باشر عملا ً مـن أعمال أهل الخبرة.
كما يمتنع عليه أن يشترك في الحكم إذا كان قد قام في الدعوى بعمل من أعمـال التحقيق أو الإحالة أو كان قد أصدر فيها قرارا بالمنع من التصرف أو المنع من السفر أو الوضع على قوائم ترقب السفر والوصول ،أو أن يشترك في الحكم في الطعـن إذا كان الحكم المطعون فيه صادرا منه.$b246756$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins246;

WITH ins247 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 247, 0, $h247760$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الرابع تنحى القضاة وردهم عن الحكم$h247760$, $t247761$مادة (247)$t247761$, $b247759$يجوز للخصوم رد القضاة عن الحكم في الحالات الواردة فـي المـادة  ٢٤٦مـن هـذا القانون ،وفي سائر حالات الرد المبينة في قانون المرافعات في المواد المدنية والتجارية.
ولا يجوز رد أعضاء النيابة العامة ولا مأموري الضبط القضائي.
ويعتبر المجني عليه فيما يتعلق بطلب الرد بمثابة خصم في الدعوى.$b247759$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins247;

WITH ins248 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 248, 0, $h248763$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الرابع تنحى القضاة وردهم عن الحكم$h248763$, $t248764$مادة (248)$t248764$, $b248762$يتعين على القاضي إذا قام سبب من أسباب الرد أن يصرح للمحكمة لتفصل فـي أمر تنحيه في غرفة المشورة ،وعلى القاضي الجزئي أن يطرح الأمـر علـى رئـيس المحكمة ،ويجب عليه عرض الأمر على محكمة الجنح المستأنفة منعقـدة فـي غرفـة المشورة للفصل فيه وذلك للإذن له بالتنحي.
وفيما عدا أحوال الرد المقررة بالقانون ،يجوز للقاضي إذا قامـت لديـه أسـباب يستشعر منها الحرج من نظر الدعوى أن يعرض أمر تنحيه على المحكمـة ،أو علـى رئيس المحكمة بحسب الأحوال للفصل فيه.$b248762$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins248;

WITH ins249 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 249, 0, $h249766$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الرابع تنحى القضاة وردهم عن الحكم$h249766$, $t249767$مادة (249)$t249767$, $b249765$يتبع في نظر طلب الرد والحكم فيه القواعـد المنـصوص عليهـا فـي قـانون المرافعات المدنية والتجارية.
ويكون الرد لمرة واحدة طوال فترة المحاكمة متى كان ذلك من نفـس الـشخص ولذات السبب.
ولا يجوز تقديم طلب الرد في قلم الكتاب ،إلا بعد سداد كفالـة مقـدارها عـشرة آلاف جنيه ،وتتعدد الكفالة بتعدد طلبات الرد.
ويجب الحكم بمصادرة الكفالة في حالة رفض طلب الرد.
ويجوز للمحكمة التي تنظر طلب الرد أن تحكم على طالب الرد بغرامة لا تجاوز عشرة آلاف جنيه ،إذا تبين لها أن طلب الرد كان بسوء نيـة أو كـان الغـرض منـه تعطيل الفصل في الدعوى.
وتحدد الجمعية العمومية في بداية كل عام قضائي دائرة أو أكثر في محاكم الاستئناف، لنظر طلبات الرد على أن تفصل في الطلب خلال أسبوعين من تاريخ عرضه عليها.$b249765$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins249;

WITH ins250 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 250, 0, $h250769$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h250769$, $t250770$مادة (250)$t250770$, $b250768$يجوز لمن لحقه ضرر شخصي مباشر من الفعـل المـسبب للجريمـة ،محقـق الوقوع ،حالا ً أو مستقبلا ً ،أن يدعي بحقوق مدنية أمام المحكمة التـي تنظـر الـدعوى الجنائية في أي حالة كانت عليها حتى صدور القرار بإقفال باب المرافعـة ،ولا يقبـل منه ذلك أمام المحكمة الاستئنافية.
ويكون الادعاء بالحقوق المدنية وإدخال المسئول عنها أمام المحكمة بإعلان علـى يد محضر ،أو بطلب في الجلسة إذا كان الخصم حاضرا ،وإلا وجب تأجيـل الـدعوى وتكليف الطالب بإعلانه بطلباته.
فإذا كان قد سبق قبول المدعي بالحقوق المدنية بهذه الصفة ،فإن إحالـة الـدعوى الجنائية إلى المحكمة تشمل الدعوى المدنية.
ولا يجوز أن يترتب على تدخل المدعي بالحقوق المدنيـة تـأخير الفـصل فـي الدعوى الجنائية ،وإلا حكمت المحكمة بعدم قبول تدخله.$b250768$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins250;

WITH ins251 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 251, 0, $h251772$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h251772$, $t251773$مادة (251)$t251773$, $b251771$إذا كان من لحقه ضرر من الجريمة فاقد الأهلية ولم يكن له من يمثله قانون ًا ،جاز للمحكمة المرفوعة أمامها الدعوى الجنائية بناء على طلب النيابة العامة أن تحـدد لـه وكيلا ليدعي بالحقوق المدنية بالنيابة عنه ،ولا يترتب على ذلك في أية حـال إلزامـه بالمصاريف القضائية.$b251771$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins251;

WITH ins252 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 252, 0, $h252775$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h252775$, $t252776$مادة (252)$t252776$, $b252774$ترفع الدعوى المدنية بتعويض الضرر على المتهم بالجريمة إذا كان بالغ ًا واحـد وعشرين عاما ،وعلى من يمثله إذا لم يبلغها أو إذا بلغها وكان فاقد الأهلية ،فـإن لـم يكن له من يمثله ،وجب على المحكمـة أن تحـدد مـن يمثلـه طبق ًـا للمـادة ٢٥١ من هذا القانون.
ويجوز رفع الدعوى المدنية أيـضا علـى المـسئولين عـن الحقـوق المدنيـة عن فعل المتهم.
وللنيابة العامة أن تدخل المسئولين عن الحقوق المدنية ،ولو لم يكن في الـدعوى مدعٍ بحقوق مدنية ،للحكم عليهم بالمصاريف المستحقة للحكومة.
ولا يجوز أمام المحـاكم الجنائيـة أن ترفـع دعـوى الـضمان ،ولا أن يـدخل في الدعوى غير المدعى عليهم بالحقوق المدنيـة والمـسئول عـن الحقـوق المدنيـة والمؤمن لديه.$b252774$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins252;

WITH ins253 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 253, 0, $h253778$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h253778$, $t253779$مادة (253)$t253779$, $b253777$يجوز للمسئول عن الحقوق المدنية أن يتدخل من تلقاء نفسه في الدعوى الجنائيـة في أية حالة كانت عليها.
وللنيابة العامة والمدعي بالحقوق المدنية المعارضة في قبول تدخله.$b253777$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins253;

WITH ins254 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 254, 0, $h254781$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h254781$, $t254782$مادة (254)$t254782$, $b254780$يجب على كل من المجني عليه والمدعي بالحقوق المدنيـة والمـسئول عنهـا أن يعين له موطن ًا مختارا في البلدة الكائن فيها مقر المحكمة التي يجري فيها التحقيـق ،أو أن يعين رقم هاتف محمول أو بريدا إلكترونيا لإعلانه عليه ،ويكون ذلك بتقريـر فـي قلم الكتاب.
وإذا لم يعين أي من الأشخاص المشار إليهم في الفقرة الأولى مـن هـذه المـادة البيانات على النحو المبين بها ،أو كان البيان ناقصا أو غير صحيح ،أو طـرأ تغييـر على ما عينه من بيانات ولم يخطر بها ،يكون الإعلان في قلم الكتاب صحيحا.$b254780$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins254;

WITH ins255 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 255, 0, $h255784$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h255784$, $t255785$مادة (255)$t255785$, $b255783$لا يقبل الادعاء بالحقوق المدنية إلا بعد أداء الرسوم القضائية وإيداع الأمانة التـي تقدرها النيابة العامة أو قاضي التحقيق أو المحكمة التي تنظر الدعوى الجنائية ،علـى ذمة أتعاب ومصاريف الخبراء والشهود وغيرهم.$b255783$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins255;

WITH ins256 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 256, 0, $h256787$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h256787$, $t256788$مادة (256)$t256788$, $b256786$يجوز لكل من المتهم والمسئول عن الحقوق المدنية والنيابة العامة أن يعارض في الجلسة في قبول المدعي بالحقوق المدنية إذا كانت الدعوى المدنية غير جائزة أو غيـر مقبولة ،وتفصل المحكمة في المعارضة بعد سماع أقوال الخصوم.$b256786$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins256;

WITH ins257 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 257, 0, $h257790$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h257790$, $t257791$مادة (257)$t257791$, $b257789$لا يمنع القرار الصادر من النيابة العامة أو قاضي التحقيق بعدم قبـول المـدعي بالحقوق المدنية من الادعاء مدنيا بعد ذلك أمام المحكمة الجنائية ،أو من رفـع دعـواه أمام المحكمة المدنية.
ولا يترتب على القرار الصادر من المحكمة بقبـول الـدعوى المدنيـة بطـلان الإجراءات التي لم يشترك فيها المدعي بالحقوق المدنية قبل ذلك.
والقرار الصادر من النيابة العامة أو قاضي التحقيق بقبـول المـدعي بـالحقوق المدنية لا يلزم المحكمة المرفوعة أمامها الدعوى.$b257789$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins257;

WITH ins258 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 258, 0, $h258793$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h258793$, $t258794$مادة (258)$t258794$, $b258792$يجوز رفع الدعوى المدنية قبل المؤمن لديه لتعويض الضرر الناشئ عن الجريمة أمام المحكمة التي تنظر الدعوى الجنائية.
وتسري على المؤمن لديه جميع الأحكام الخاصة بالمسئول عن الحقـوق المدنيـة المنصوص عليها في هذا القانون.$b258792$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins258;

WITH ins259 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 259, 0, $h259796$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h259796$, $t259797$مادة (259)$t259797$, $b259795$تنقضي الدعوى المدنية بمضي المدة المقررة في القانون المدني ،ومـع ذلـك لا تنقضي بالتقادم الدعوى المدنية الناشئة عن الجرائم المنصوص عليها في الفقرة الثانيـة من المادة  ١٧من هذا القانون.
وإذا انقضت الدعوى الجنائية بعد رفعها لسبب من الأسباب الخاصة بها فلا تأثير لذلك في سير الدعوى المدنية المرفوعة معها.$b259795$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins259;

WITH ins260 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 260, 0, $h260799$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h260799$, $t260800$مادة (260)$t260800$, $b260798$يجوز للمدعي بالحقوق المدنية أن يترك دعواه في أية حالة كانت عليها الـدعوى، ويلزم بدفع المصاريف السابقة على ذلك ،مع عدم الإخلال بحق المتهم في التعويضات إن كان لها وجه.
ولا يكون لهذا الترك تأثير على الدعوى الجنائية ،ومع ذلك إذا كانت الدعوى قـد رفعت بطريق الادعاء المباشر فإنه يجب في حالتي ترك الـدعوى المدنيـة واعتبـار المدعي بالحقوق المدنية تارك ًا دعواه ،الحكم بترك الدعوى الجنائية ما لم تطلب النيابـة العامة الفصل فيها.
ويترتب على الحكم بترك الدعوى الجنائية سقوط حق المدعي نفسه في الادعـاء مدنيا عن ذات الفعل أمام المحكمة الجنائية.$b260798$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins260;

WITH ins261 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 261, 0, $h261802$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h261802$, $t261803$مادة (261)$t261803$, $b261801$يعتبر ترك ًا للدعوى عدم حضور المدعي أمام المحكمة بغير عـذر مقبـول بعـد إعلانه لشخصه أو عدم إرساله وكيلا عنه وكذلك عدم إبدائه طلبات بالجلسة.$b261801$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins261;

WITH ins262 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 262, 0, $h262805$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h262805$, $t262806$مادة (262)$t262806$, $b262804$إذا ترك المدعي بالحقوق المدنية دعواه المرفوعة أمام المحاكم الجنائية ،يجوز له أن يرفعها أمام المحاكم المدنية ما لم يكن قد صرح بترك الحق المرفوع به الدعوى.$b262804$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins262;

WITH ins263 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 263, 0, $h263808$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h263808$, $t263809$مادة (263)$t263809$, $b263807$يترتب على ترك المدعي بالحقوق المدنية دعواه أو عدم قبولـه مـدعيا بحقـوق مدنية استبعاد المسئول عن الحقوق المدنية من الدعوى إذا كان دخوله فيها بنـاء علـى طلب المدعي.$b263807$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins263;

WITH ins264 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 264, 0, $h264811$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h264811$, $t264812$مادة (264)$t264812$, $b264810$إذا رفع من ناله ضرر من الجريمة دعواه بطلب التعويض إلى المحكمة المدنيـة، ثم رفعت الدعوى الجنائية ،جاز له إذا ترك دعواه أمام المحكمة المدنية أن يرفعها إلـى المحكمة الجنائية مع الدعوى الجنائية.$b264810$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins264;

WITH ins265 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 265, 0, $h265814$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h265814$, $t265815$مادة (265)$t265815$, $b265813$إذا رفعت الدعوى المدنية أمام المحاكم المدنية ،يجب وقف الفصل فيها حتى يحكم نهائيا في الدعوى الجنائية المقامة قبل رفعها ،أو في أثناء السير فيها.
على أنه إذا أوقف الفـصل فـي الـدعوى الجنائيـة لجنـون المـتهم ،يفـصل في الدعوى المدنية.$b265813$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins265;

WITH ins266 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 266, 0, $h266817$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h266817$, $t266818$مادة (266)$t266818$, $b266816$يتبع في الفصل في الدعوى المدنية التي ترفع أمام المحاكم الجنائيـة الإجـراءات المقررة بهذا القانون.$b266816$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins266;

WITH ins267 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 267, 0, $h267820$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الخامس الادعاء بالحقوق المدنية$h267820$, $t267821$مادة (267)$t267821$, $b267819$يجوز للمتهم أن يطالب المدعي بالحقوق المدنية أمام المحكمة الجنائية بتعـويض الضرر الذي لحقه بسبب رفع الدعوى المدنية عليه إن كان لذلك وجه ،ولـه كـذلك أن يقيم عليه لذات السبب الدعوى المباشرة أمام ذات المحكمة بتهمة البلاغ الكاذب إن كان لذلك وجه ،وذلك بتكليفه مباشرة بالحضور أمامها ،ويجوز الاستغناء عن هذا التكليـف إذا حضر المدعي بالحقوق المدنية الجلسة ووجه إليه المتهم التهمة وقبل المحاكمة.$b267819$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins267;

WITH ins268 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 268, 0, $h268823$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h268823$, $t268824$مادة (268)$t268824$, $b268822$يجب أن تكون الجلسة علنية ،ويجوز للمحكمة مع ذلك مراعاة للنظـام العـام أو محافظة على الآداب أن تأمر بسماع الدعوى كلها أو بعضها في جلسة سرية ،أو تمنـع فئات معينة من الحضور فيها.
ولا يجوز نقل وقائع الجلسات أو بثها بأي طريقة كانت إلا بموافقـة كتابيـة مـن رئيس الدائرة بعد أخذ رأي النيابة العامة.$b268822$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins268;

WITH ins269 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 269, 0, $h269826$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h269826$, $t269827$مادة (269)$t269827$, $b269825$يجب أن يحضر أحد أعضاء النيابة العامة جلـسات المحـاكم الجنائيـة ،وعلـى المحكمة أن تسمع أقواله وتفصل في طلباته.$b269825$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins269;

WITH ins270 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 270, 0, $h270829$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h270829$, $t270830$مادة (270)$t270830$, $b270828$يحضر المتهم الجلسة بغير قيود ولا أغلال ،وتجرى عليه الملاحظة اللازمة.
ولا يجوز إبعاده عن الجلسة أثناء نظر الدعوى إلا إذا وقع منه تشويش يـستدعي ذلك ،وفي هذه الحالة تستمر الإجراءات إلى أن يمكن السير فيهـا بحـضوره ،وعلـى المحكمة أن تطلعه على ما تم في غيبته من الإجراءات.$b270828$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins270;

WITH ins271 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 271, 0, $h271832$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h271832$, $t271833$مادة (271)$t271833$, $b271831$يبدأ التحقيق في الجلسة بالمناداة على الخصوم والشهود ،ويسأل المتهم عن اسـمه ولقبه وسنه ومهنته ومحل إقامته ومولده ،وتتلى التهمة الموجهة إليه بـأمر الإحالـة أو بورقة التكليف بالحضور على حسب الأحوال ،ثم تقدم النيابة والمدعي بالحقوق المدنية إن وجد طلباتهما.
وبعد ذلك يسأل المتهم عما إذا كان معترف ًا بارتكاب الفعـل المـسند إليـه ،فـإن اعترف جاز للمحكمة الاكتفاء باعترافه والحكم عليه بغير سماع الـشهود ،وإلا تـسمع شهادة شهود الإثبات ،ويكون توجيه الأسئلة للشهود من النيابة العامـة أولا ً ،ثـم مـن المجني عليه ،ثم من المدعي بالحقوق المدنية ،ثم من المتهم ،ثم مـن المـسئول عـن الحقوق المدنية.$b271831$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins271;

WITH ins272 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 272, 0, $h272835$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h272835$, $t272836$مادة (272)$t272836$, $b272834$بعد سماع شهادة شهود الإثبات يسمع شهود النفي ويسألون بمعرفة المـتهم أولا ً، ثم بمعرفة المسئول عن الحقوق المدنية ،ثم بمعرفة النيابة العامة ،ثم بمعرفـة المجنـي عليه ،ثم بمعرفة المدعي بالحقوق المدنية وللمتهم والمسئول عن الحقـوق المدنيـة أن يوجها للشهود المذكورين أسئلة مرة ثانية لإيضاح الوقائع التي أدوا الشهادة عنها فـي أجوبتهم عن الأسئلة التي وجهت إليهم.
ويجوز لكل من الخصوم أن يطلب إعادة سماع الشهود المذكورين لإيـضاح أو تحقيـق الوقائع التي أدوا شهادتهم عنها ،أو أن يطلب سماع شهود غيرهم لهذا الغرض.$b272834$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins272;

WITH ins273 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 273, 0, $h273838$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h273838$, $t273839$مادة (273)$t273839$, $b273837$يجوز للمحكمة في أية حالة كانت عليها الدعوى أن توجه للشهود أي سؤال تـرى لزومه لظهور الحقيقة ،أو تأذن للخصوم بذلك.
ويجب عليها منع توجيه أسئلة للشاهد إذا كانت غير متعلقة بالـدعوى ،أو غيـر جائزة القبول ،ويجب عليها أن تمنع عن الشاهد كل كلام بالتصريح أو التلمـيح وكـل إشارة مما ينبني عليه اضطراب أفكاره أو تخويفه.
ويجوز لها أن تمتنع عن سماع شهادة شهود عن وقـائع تـرى أنهـا واضـحة وضوحا كافيا.$b273837$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins273;

WITH ins274 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 274, 0, $h274841$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h274841$, $t274842$مادة (274)$t274842$, $b274840$لا يجوز استجواب المتهم إلا إذا قبل ذلك.
وإذا ظهر أثناء المرافعة والمناقشة بعض وقائع يرى لزوم تقديم إيضاحات عنهـا من المتهم لظهور الحقيقة ،يلفته القاضي إليها ويرخص له بتقديم تلك الإيضاحات.
وإذا امتنع المتهم عن الإجابة ،أو إذا كانت أقواله في الجلسة مخالفة لأقوالـه فـي محضر جمع الاستدلالات أو التحقيق ،جاز للمحكمة أن تأمر بتلاوة أقواله الأولى.$b274840$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins274;

WITH ins275 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 275, 0, $h275844$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h275844$, $t275845$مادة (275)$t275845$, $b275843$بعد سماع شهادة شهود الإثبات وشهود النفي ،يجوز للنيابة العامة وللمتهم ولكـل من باقي الخصوم في الدعوى أن يتكلموا.
وفي جميع الأحوال ،يكون المتهم آخر من يتكلم.
ويجوز للمحكمة أن تمنع المتهم أو محاميه من الاسترسال في المرافعة إذا خـرج عن موضوع الدعوى أو كرر أقواله بعد التنبيه عليه.
وبعد ذلك تصدر المحكمة قرارها بإقفال باب المرافعة ،ثم تـصدر حكمهـا بعـد المداولة.$b275843$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins275;

WITH ins276 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 276, 0, $h276847$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h276847$, $t276848$مادة (276)$t276848$, $b276846$يجب أن يحرر محضر بما يجري في جلسة المحاكمة ،ويوقع على كـل صـفحة منه رئيس المحكمة وكاتبها في اليوم التالي على الأكثر.
ويشتمل هذا المحضر على تاريخ الجلسة ،ويبين به إذا ما كانت علنية أو سـرية، وأسماء القضاة والكاتب وعضو النيابة العامة الحاضـر بالجلـسة وأسـماء الخـصوم والمدافعين عنهم وشهادة الشهود وأقوال الخصوم ،ويشار فيه إلى الأوراق التي تليـت وسائر الإجراءات التي تمت ،وتدون به الطلبات التي قـدمت أثنـاء نظـر الـدعوى، وما قضي به في المسائل الفرعية ،ومنطوق الأحكام الصادرة ،وغير ذلك مما يجـري في الجلسة.$b276846$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins276;

WITH ins277 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 277, 0, $h277850$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السادس نظر الدعوى وترتيب الإجراءات في الجلسة$h277850$, $t277851$مادة (277)$t277851$, $b277849$يحكم على وجه السرعة في القضايا الخاصة بالطفل والمـرأة والمـسنين وذوي الإعاقة والجرائم المنصوص عليها في الأبواب الأول والثاني والثاني مكررا والثالـث والرابع والرابع عشر من الكتاب الثاني من قانون العقوبات والجرائم المنصوص عليها في المواد  ٣٠٨ ،٣٠٧ ،٣٠٦ ،٣٠٣ ،٣٠٢من قانون العقوبات إذا وقعـت بواسـطة الصحف والقانون رقم  ٣٩٤لسنة  ١٩٥٤في شأن الأسلحة والذخائر.
ويكون تكليف المتهم بالحضور أمام المحكمة في القضايا المبينة بـالفقرة الأولـى من هذه المادة قبل انعقاد الجلسة بيوم كامل في مواد الجنح وثلاثة أيام كاملة في مـواد الجنايات غير مواعيد المسافة المنصوص عليها بقانون المرافعات المدنية والتجارية.
ويجوز أن يكون الإعلان بواسطة أحد المحضرين أو أحد رجال السلطة العامة.
وتنظر القضية في جلسة تعقد في خلال أسبوعين من يوم إحالتها إلـى المحكمـة المختصة ،وإذا كانت القضية محالة إلى محكمة جنايات أول درجة يقوم رئيس محكمة الاستئناف المختصة بتحديد جلسة في الميعاد المذكور.$b277849$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins277;

WITH ins278 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 278, 0, $h278853$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h278853$, $t278854$مادة (278)$t278854$, $b278852$يعلن الشاهد لشخصه أو في محل إقامته بالطرق المقررة في هذا القانون ،أو عـن طريق الهاتف المحمول أو البريد الإلكتروني المثبت ببيانات رقمه القومي.
ويعلن طلب حضور الشاهد بناء على طلب الخصوم بواسطة أحـد المحـضرين أو أحد رجال السلطة العامة ،أو بالوسائل الأخرى المنصوص عليها بالفقرة الأولى من هذه المادة ،قبل الجلسة بأربع وعشرين ساعة مع مراعاة مواعيد المسافة المنـصوص عليها بقانون المرافعات المدنية والتجارية ،إلا في حال التلبس بالجريمة ،فإنـه يجـوز طلب حضوره في أي وقت ولو شفهيا بواسطة أحد مأموري الضبط القضائي أو أحـد رجال السلطة العامة.$b278852$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins278;

WITH ins279 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 279, 0, $h279856$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h279856$, $t279857$مادة (279)$t279857$, $b279855$ينادى على الشهود بأسمائهم ،وبعد الإجابة منهم يبقون في الغرفة المخصصة لهم، ولا يخرجون منها إلا بالتوالي لتأدية الشهادة أمام المحكمة ،ومن تسمع شـهادته مـنهم يبقى في قاعة الجلسة إلى حين إقفال باب المرافعة ،مـا لـم تـرخص لـه المحكمـة بالخروج ،ويجوز عند الاقتضاء أن يبعد شاهد أثناء سماع شاهد آخر ،وتسوغ مواجهة الشهود بعضهم بعضا.$b279855$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins279;

WITH ins280 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 280, 0, $h280859$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h280859$, $t280860$مادة (280)$t280860$, $b280858$إذا تخلف الشاهد عن الحضور أمام المحكمة بعد تكليفه به ،جاز الحكم عليه بعـد سماع أقوال النيابة العامة بدفع غرامة لا تجاوز خمسمائة جنيه في الجنايات والجنح.
ويجوز للمحكمة إذا رأت أن شهادته ضرورية أن تؤجل الدعوى لإعـادة تكليفـه بالحضور ،ولها أن تصدر أمرا مسببا بالقبض عليه أو ضبطه وإحضاره.$b280858$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins280;

WITH ins281 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 281, 0, $h281862$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h281862$, $t281863$مادة (281)$t281863$, $b281861$إذا حضر الشاهد بعد تكليفه بالحضور مرة أخرى أو من تلقاء نفسه وأبدى أعذارا مقبولة ،جاز إعفاؤه من الغرامة بعد سماع أقوال النيابة العامة.
وإذا لم يحضر الشاهد في المرة الأخرى ،جاز الحكم عليه بغرامة لا تجاوز ألفـى جنيه ،وللمحكمة أن تصدر أمرا مسببا بالقبض عليه أو ضبطه وإحـضاره فـي نفـس الجلسة ،أو في جلسة أخرى تؤجل إليها الدعوى.$b281861$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins281;

WITH ins282 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 282, 0, $h282865$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h282865$, $t282866$مادة (282)$t282866$, $b282864$يجوز للمحكمة إذا اعتذر الشاهد بأعذار مقبولة عن عدم إمكانه الحضور أن تنتقل إليه وتسمع شهادته بعد إخطار النيابة العامة وباقي الخصوم ،وللخصوم أن يحـضروا بأنفسهم أو بواسطة وكلائهم وأن يوجهوا للشاهد الأسئلة التي يرون لزوم توجيهها إليه.
وإذا انتقلت المحكمة إلى الشاهد وتبين لها عدم صحة العذر جاز لهـا أن تحكـم عليه بالحبس مدة لا تجاوز ثلاثة شهور وبغرامة لا تجاوز ألفى جنيه.$b282864$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins282;

WITH ins283 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 283, 0, $h283868$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h283868$, $t283869$مادة (283)$t283869$, $b283867$إذا لم يحضر الشاهد أمام المحكمة حتى صدور الحكم في الدعوى ،جاز له الطعن في حكم الغرامة أمام المحكمة التي أصدرته ،في هيئة مغايرة ،إذا حال دون حـضوره لإبداء شهادته عذر قهري.
ويجوز للشهود الطعن في الأحكام الصادرة بالحبس أو الغرامة أمام المحكمة التي أصدرته ،في هيئة مغايرة.$b283867$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins283;

WITH ins284 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 284, 0, $h284871$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h284871$, $t284872$مادة (284)$t284872$, $b284870$يجب على الشاهد الذي بلغ خمس عشرة سنة أن يحلف قبل أداء الشهادة اليمـين الآتية" :أقسم باالله العظيم أن أشهد بالحق" ،ويكون الحلف على حسب الأوضاع الخاصة بديانته إن طلب ذلك.
ويجوز سماع الشهود الذين لم يبلغوا خمس عشرة سنة كاملة دون حلـف يمـين على سبيل الاستدلال.$b284870$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins284;

WITH ins285 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 285, 0, $h285874$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h285874$, $t285875$مادة (285)$t285875$, $b285873$إذا امتنع الشاهد عن أداء اليمين أو عن الإجابة في غير الأحوال التي يجيـز لـه القانون فيها ذلك ،حكم عليه في مواد الجنايات والجنح بغرامة لا تجاوز ألفى جنيه.
وإذا عدل الشاهد عن امتناعه قبل إقفال باب المرافعة يعفى من العقوبة المحكـوم بها عليه كلها أو بعضها.$b285873$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins285;

WITH ins286 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 286, 0, $h286877$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h286877$, $t286878$مادة (286)$t286878$, $b286876$لا يجوز رد الشهود لأي سبب من الأسباب.$b286876$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins286;

WITH ins287 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 287, 0, $h287880$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h287880$, $t287881$مادة (287)$t287881$, $b287879$يجوز أن يمتنع عن أداء الشهادة ضد المتهم أصوله وفروعه وأقاربـه وأصـهاره إلى الدرجة الثانية وزوجه ولو بعد انقضاء رابطة الزوجية ،وذلك ما لم تكن الجريمـة قد وقعت على الشاهد أو على أحد أقاربه أو أصهاره الأقربين ،أو إذا كان هو المبلـغ عنها ،أو إذا لم تكن هناك أدلة إثبات أخرى.$b287879$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins287;

WITH ins288 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 288, 0, $h288883$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h288883$, $t288884$مادة (288)$t288884$, $b288882$تسري أمام المحاكم الجنائية القواعد المقررة في قانون الإثبات في المواد المدنيـة والتجارية لمنع الشاهد عن أداء الشهادة أو لإعفائه من أدائها.$b288882$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins288;

WITH ins289 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 289, 0, $h289886$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h289886$, $t289887$مادة (289)$t289887$, $b289885$يسمع المدعي بالحقوق المدنية كشاهد ويحلف اليمين.$b289885$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins289;

WITH ins290 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 290, 0, $h290889$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h290889$, $t290890$مادة (290)$t290890$, $b290888$يجوز للمحكمة أن تقرر تلاوة الشهادة التي أبديت في التحقيق الابتـدائي أو فـي محضر جمع الاستدلالات أو أمام الخبير إذا تعـذر سـماع الـشاهد لأي سـبب مـن الأسباب ،فإذا تمسك الدفاع بسماع أقوال شاهد الإثبات ،ولم تر المحكمة ضرورة لـذلك كان عليها أن ت ُضمن حكمها سبب الرفض.$b290888$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins290;

WITH ins291 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 291, 0, $h291892$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h291892$, $t291893$مادة (291)$t291893$, $b291891$إذا قرر الشاهد أنه لم يعد يذكر واقعة من الوقائع يجوز أن يتلى من شهادته التـي أقرها في التحقيق أو من أقواله في محضر جمع الاستدلالات ،الجزء الخـاص بهـذه الواقعة.
وكذلك الحال إذا تعارضت شهادة الشاهد التي أداها فـي الجلـسة مـع شـهادته أو أقواله السابقة.$b291891$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins291;

WITH ins292 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 292, 0, $h292895$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h292895$, $t292896$مادة (292)$t292896$, $b292894$يجوز للمحكمة أن تأمر ،ولو من تلقاء نفسها أثناء نظر الدعوى ،بتقديم أي دليـل تراه لازما لظهور الحقيقة.$b292894$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins292;

WITH ins293 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 293, 0, $h293898$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h293898$, $t293899$مادة (293)$t293899$, $b293897$يجوز للمحكمة سواء من تلقاء نفسها أو بناء على طلب الخصوم أن تعين خبيـرا واحدا أو أكثر في الدعوى.$b293897$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins293;

WITH ins294 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 294, 0, $h294901$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h294901$, $t294902$مادة (294)$t294902$, $b294900$يجوز للمحكمة من تلقاء نفسها ،أو بناء على طلب الخـصوم ،أن تـأمر بـإعلان الخبراء ليقدموا إيضاحات بالجلسة عن التقارير المقدمة منهم فـي التحقيـق الابتـدائي أو أمام المحكمة.$b294900$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins294;

WITH ins295 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 295, 0, $h295904$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل السابع الشهود والأدلة الأخرى$h295904$, $t295905$مادة (295)$t295905$, $b295903$إذا تعذر تحقيق دليل أمام المحكمة ،جاز لها أن تندب أحد أعـضائها أو قاضـيا آخر لتحقيقه.$b295903$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins295;

WITH ins296 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 296, 0, $h296907$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثامن دعوى التزوير الفرعية$h296907$, $t296908$مادة (296)$t296908$, $b296906$يجوز للنيابة العامة ولجميع الخصوم ،في أيـة حالـة كانـت عليهـا الـدعوى، أن يطعنوا بالتزوير في أية ورقة من أوراق القضية مقدمة فيها.$b296906$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins296;

WITH ins297 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 297, 0, $h297910$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثامن دعوى التزوير الفرعية$h297910$, $t297911$مادة (297)$t297911$, $b297909$يحصل الطعن بتقرير في قلم كتاب المحكمة المنظورة أمامهـا الـدعوى ،ويقـدم الطعن من الخصم نفسه أو وكيله إذا أرفق بطعنه توكيلا ً خاصا بالادعـاء بـالتزوير، أو إقرارا كتابيا موثق ًا من الخصم مبين ًا فيه الأوراق المطعون فيها.
ويجب أن يعلن مدعي التزوير خصمه في الثمانية الأيام التالية للتقريـر بمـذكرة تحدد فيها الورقة المطعون فيها بالتزوير والأدلة على تزويرها.$b297909$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins297;

WITH ins298 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 298, 0, $h298913$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثامن دعوى التزوير الفرعية$h298913$, $t298914$مادة (298)$t298914$, $b298912$إذا رأت المحكمة المنظور أمامها الدعوى وجها للـسير فـي تحقيـق الادعـاء بالتزوير ،وكان الفصل في الدعوى المنظورة أمامها يتوقف علـى الورقـة المطعـون فيها ،تحقق المحكمة الواقعة بنفسها ،ومع ذلك يجوز لها إذا تعذر عليها ذلك أن تحيـل الأوراق إلى النيابة العامة ،وفي هذه الحالة توقف الدعوى إلى أن يفصل في الادعـاء بالتزوير.
وإذا تبين للمحكمة أن الورقة المطعون فيها مزورة تفصل في الـدعوى وتحيـل الواقعة للنيابة العامة لاتخاذ شئونها فيها.
وفي حالة عدم وجود تزوير تقضي المحكمة بإلزام مـدعي التزويـر بغرامـة لا تجاوز عشرة آلاف جنيه.$b298912$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins298;

WITH ins299 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 299, 0, $h299916$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثامن دعوى التزوير الفرعية$h299916$, $t299917$مادة (299)$t299917$, $b299915$كل من ادعى بسوء نية تزوير محرر مقدم أمام إحدى المحاكم وحكم نهائيا بعـدم صحة هذا الادعاء ،يتعين على المحكمة مصدرة الحكم النهائي بعدم صـحة الادعـاء بالتزوير أن تحيل الواقعة للنيابة العامة لاتخاذ شئونها حيالها.
ويعاقب المدعي بتزوير المحرر بالعقوبة المقررة في الفقـرة الثانيـة مـن المـادة ٣٠٣ من قانون العقوبات.$b299915$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins299;

WITH ins300 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 300, 0, $h300919$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثامن دعوى التزوير الفرعية$h300919$, $t300920$مادة (300)$t300920$, $b300918$إذا حكم بتزوير ورقة رسمية كلها أو بعـضها ،تـأمر المحكمـة التـي حكمـت بالتزوير بإلغائها أو تصحيحها حسب الأحوال ،ويحرر بـذلك محـضر يؤشـر علـى الورقة بمقتضاه.$b300918$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins300;

WITH ins301 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 301, 0, $h301922$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h301922$, $t301923$مادة (301)$t301923$, $b301921$لا تتقيد المحكمة بما هو مدون في التحقيق الابتـدائي ،أو فـي محاضـر جمـع الاستدلالات ،ما لم ينص القانون على خلاف ذلك.$b301921$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins301;

WITH ins302 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 302, 0, $h302925$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h302925$, $t302926$مادة (302)$t302926$, $b302924$تعتبر المحاضر المحررة في مواد المخالفات حجة بالنسبة للوقـائع التـي يثبتهـا مأمور الضبط القضائي إلى أن يثبت ما ينفيها.$b302924$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins302;

WITH ins303 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 303, 0, $h303928$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h303928$, $t303929$مادة (303)$t303929$, $b303927$يحكم القاضي في الدعوى حسب العقيدة التي تكونت لديه بكامل حريته ولا يجوز له أن يبني حكمه على أي دليل لم يطرح أمامه في الجلسة ،وكل قول يثبت أنه صـدر من أحد المتهمين أو الشهود تحت وطأة الإكراه أو التهديد به يهدر ولا يعول عليه.$b303927$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins303;

WITH ins304 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 304, 0, $h304931$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h304931$, $t304932$مادة (304)$t304932$, $b304930$يصدر الحكم في الجلسة العلنية ولو كانت الدعوى نظرت في جلسة سرية ،ويجب إثباته في محضر الجلسة ،ويوقع عليه رئيس المحكمة والكاتب.
ويجوز للمحكمة أن تأمر باتخاذ الوسائل اللازمة لمنع المتهم من مغـادرة قاعـة الجلسة قبل النطق بالحكم أو لضمان حضوره في الجلسة التـي يؤجـل لهـا الحكـم، ولو كان ذلك بإصدار أمر مـسبب بحبـسه إذا كانـت الواقعـة ممـا يجـوز فيهـا الحبس الاحتياطي.$b304930$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins304;

WITH ins305 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 305, 0, $h305934$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h305934$, $t305935$مادة (305)$t305935$, $b305933$إذا كانت الواقعة غير ثابتة أو كان القانون لا يعاقب عليها ،تحكم المحكمة ببـراءة المتهم ويفرج عنه إن كان محبوسا من أجل هذه الواقعة وحدها.
أما إذا كانت الواقعة ثابتة وتكون فعلا معاقبا عليه ،تقـضي المحكمـة بالعقوبـة المقررة في القانون.$b305933$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins305;

WITH ins306 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 306, 0, $h306937$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h306937$, $t306938$مادة (306)$t306938$, $b306936$إذا تبين للمحكمة الجزئية أن الواقعة جناية أو أنها جنحة من الجـنح التـي تقـع بواسطة الصحف أو غيرها من طرق النشر على غير الأفراد تحكم بعدم اختـصاصها وتحيلها إلى النيابة العامة لاتخاذ ما يلزم فيها.$b306936$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins306;

WITH ins307 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 307, 0, $h307940$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h307940$, $t307941$مادة (307)$t307941$, $b307939$لا تجوز معاقبة المتهم عن واقعة غير التي وردت بأمر الإحالة أو طلب التكليـف بالحضور ،كما لا يجوز الحكم على غير المتهم المقامة عليه الدعوى.
وإذا تبين للمحكمة أن المتهم المعروض ليس هو مرتكـب الواقعـة وأن المـتهم الحقيقي معروف ،فلها أن تحيل الأوراق للنيابة العامة لاتخـاذ شـئونها نحـو المـتهم الحقيقي دون العرض عليها.$b307939$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins307;

WITH ins308 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 308, 0, $h308943$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h308943$, $t308944$مادة (308)$t308944$, $b308942$يجوز للمحكمة أن تغير في حكمها الوصف القانوني للفعل المسند للمـتهم ،ولهـا تعديل التهمة بإضافة الظروف المشددة التي تثبت من التحقيق أو مـن المرافعـة فـي الجلسة ،ولو كانت لم تذكر بأمر الإحالة أو بالتكليف بالحضور.
ولها أيضا إصلاح كل خطأ مادي وتدارك كل سهو في عبارة الاتهام مما يكـون في أمر الإحالة ،أو في طلب التكليف بالحضور.
ويجب على المحكمة أن تنبه المتهم إلى هذا التغيير ،وأن تمنحه أجـلا ً لتحـضير دفاعه بناء على الوصف أو التعديل الجديد إذا طلب ذلك.$b308942$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins308;

WITH ins309 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 309, 0, $h309946$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h309946$, $t309947$مادة (309)$t309947$, $b309945$كل حكم يصدر في موضوع الدعوى الجنائية يجب أن يفصل فـي التعويـضات التي يطلبها المدعي بالحقوق المدنية أو المتهم ،وكذلك في الدعوى المباشرة التي يقيمها المتهم على المدعي بالحقوق المدنية طبق ًا للمادة  ٢٦٧من هذا القانون.
ومع ذلك إذ رأت المحكمة أن الفصل في التعويضات يستلزم إجراء تحقيق خاص ينبني عليه إرجاء الفصل في الدعوى الجنائية ،فعندئذ تحيل المحكمة الـدعوى المدنيـة إلى المحكمة المختصة بلا مصروفات.$b309945$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins309;

WITH ins310 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 310, 0, $h310949$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h310949$, $t310950$مادة (310)$t310950$, $b310948$يجب أن يشتمل الحكم على الأسباب التي بني عليها ،وكل حكم بالإدانة يجـب أن يشتمل على بيانات المحكوم عليه بما فيها الرقم القـومي وبيـان الواقعـة المـستوجبة للعقوبة والظروف التي وقعت فيها ،وأن يشير إلى نص القانون الذي حكم بموجبه.$b310948$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins310;

WITH ins311 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 311, 0, $h311952$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h311952$, $t311953$مادة (311)$t311953$, $b311951$يجب على المحكمة أن تفصل في الطلبات التي تقدم لها مـن الخـصوم ،وتبـين الأسباب التي تستند إليها.$b311951$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins311;

WITH ins312 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 312, 0, $h312955$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h312955$, $t312956$مادة (312)$t312956$, $b312954$يحرر الحكم بأسبابه كاملا ً خلال ثمانية أيام من تاريخ صـدوره قـدر الإمكـان، ويوقع عليه رئيس المحكمة وكاتبها ،وإذا حصل مانع للرئيس يوقعه أحد القضاة الـذين اشتركوا معه في إصداره ،وإذا كان الحكم صادرا من المحكمة الجزئية وكان القاضـي الذي أصدره قد وضع أسبابه بنفسه سواء بخطه أو بإحدى الوسائل الإلكترونية ،يجـوز لرئيس المحكمة الابتدائية أن يوقع بنفسه على نسخة الحكم الأصـلية أو ينـدب أحـد القضاة للتوقيع عليها بناء على تلك الأسباب.
فإذا لم يكن القاضي قد كتب الأسباب بنفسه يبطل الحكم لخلوه من الأسباب.
ولا يجوز تأخير توقيع الحكم عن الثمانية الأيام المقررة إلا لأسباب قوية ،وعلى كل حال يبطل الحكم إذا مضى ثلاثون يوما دون حصول التوقيع ما لم يكن صادرا بالبراءة ،وعلى قلم كتاب المحكمة التي أصدرت الحكم أن يعطي صاحب الشأن بناء على طلبه شهادة بعدم توقيع الحكم في الميعاد المذكور.$b312954$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins312;

WITH ins313 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 313, 0, $h313958$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل التاسع الحكم$h313958$, $t313959$مادة (313)$t313959$, $b313957$تلتزم النيابة العامة بنشر كل حكم بات ببراءة من سبق حبسه احتياطيا ،وكذلك كل أمر صادر بأن لا وجه لإقامة الدعوى الجنائية قبله في جريـدتين يـوميتين واسـعتي الانتشار على نفقة الحكومة ،ويكون النشر في الحالتين بناء على طلب النيابـة العامـة أو المتهم أو أحد ورثته وبموافقة النيابة العامة في حالة صـدور أمـر بـأن لا وجـه لإقامة الدعوى.$b313957$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins313;

WITH ins314 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 314, 0, $h314961$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h314961$, $t314962$مادة (314)$t314962$, $b314960$كل متهم حكم عليه في جريمة يجوز إلزامه بالمصاريف كلها أو بعضها.$b314960$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins314;

WITH ins315 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 315, 0, $h315964$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h315964$, $t315965$مادة (315)$t315965$, $b315963$إذا حكم في الاستئناف بتأييد الحكم الابتدائي ،جاز إلزام المتهم المـستأنف بكـل مصاريف الاستئناف أو بعضها.$b315963$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins315;

WITH ins316 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 316, 0, $h316967$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h316967$, $t316968$مادة (316)$t316968$, $b316966$يجوز لمحكمة النقض أن تحكم بمصاريف الطعن كلها أو بعـضها علـى المـتهم المحكوم عليه إذا لم يقبل طلبه أو إذا رفض.$b316966$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins316;

WITH ins317 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 317, 0, $h317970$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h317970$, $t317971$مادة (317)$t317971$, $b317969$إذا حكم على عدة متهمين بحكم واحد لجريمة واحدة ،فاعلين كـانوا أو شـركاء، فالمصاريف التي يحكم بها تحصل منهم بالتساوي ،ما لم يقض الحكم بتوزيعهـا بيـنهم على خلاف ذلك ،أو إلزامهم بها متضامنين.$b317969$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins317;

WITH ins318 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 318, 0, $h318973$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h318973$, $t318974$مادة (318)$t318974$, $b318972$إذا لم يحكم على المتهم بكل المصاريف وجب أن يحدد في الحكم مقدار ما يحكـم به عليه منها.$b318972$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins318;

WITH ins319 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 319, 0, $h319976$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h319976$, $t319977$مادة (319)$t319977$, $b319975$يكون المدعي بالحقوق المدنية ملزما بأداء مصاريف الدعوى للدولة ،ويتبع في تقـدير المصاريف وكيفية تحصيلها ما هو وارد في قانون الرسوم القضائية ولوائحه وقراراته.$b319975$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins319;

WITH ins320 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 320, 0, $h320979$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h320979$, $t320980$مادة (320)$t320980$, $b320978$إذا حكم بإدانة المتهم في الجريمة وجب الحكم عليه للمـدعي بـالحقوق المدنيـة بالمصاريف التي تحملها ،وللمحكمة مع ذلك أن تخفض مقدارها إذا رأت أن بعض هذه المصاريف كان غير لازم.
وإذا لم يحكم للمدعي بالحقوق المدنية بتعويضات تكون عليه المـصاريف التـي استلزمها دخوله في الدعوى ،أما إذا قضي له ببعض التعويضات التي طلبهـا يجـوز تقدير هذه المصاريف على نسبة تبين في الحكم.$b320978$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins320;

WITH ins321 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 321, 0, $h321982$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h321982$, $t321983$مادة (321)$t321983$, $b321981$يعامل المسئول عن الحقوق المدنية معاملـة المـتهم فيمـا يخـتص بمـصاريف الدعوى المدنية.$b321981$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins321;

WITH ins322 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 322, 0, $h322985$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل العاشر المصاريف$h322985$, $t322986$مادة (322)$t322986$, $b322984$إذا حكم على المتهم بمصاريف الدعوى الجنائية كلها أو بعـضها وجـب إلـزام المسئول عن الحقوق المدنية معه بما حكم به ،وفي هذه الحالـة تحـصل المـصاريف المحكوم بها من كل منهما بالتضامن.$b322984$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins322;

WITH ins323 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 323, 0, $h323988$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h323988$, $t323989$مادة (323)$t323989$, $b323987$يجوز للنيابة العامة في مواد الجنح التي لا يوجب القانون الحكـم فيهـا بعقوبـة الحبس ،إذا رأت أن الجريمة بحسب ظروفها تكفي فيها عقوبة الغرامـة فـضلا ً عـن العقوبات التكميلية والتضمينات وما يجب رده والمصاريف ،أن تطلـب مـن قاضـي المحكمة الجزئية التي من اختصاصها نظر الدعوى توقيع العقوبة على المـتهم بـأمر جنائى يصدره بناء على محضر جمع الاستدلالات أو أدلة الإثبات الأخرى بغير إجراء تحقيق أو سماع مرافعة.$b323987$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins323;

WITH ins324 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 324, 0, $h324991$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h324991$, $t324992$مادة (324)$t324992$, $b324990$يجوز للقاضي من تلقاء نفسه عند نظر إحدى الجنح المبينـة فـي المـادة ٣٢٣ من هذا القانون أن يصدر فيها أمرا جنائيا ،وذلك إذا تغيـب المـتهم عـن الحـضور رغم إعلانه ،ولم تكن النيابة العامة قد طلبت توقيع أقصى عقوبة.$b324990$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins324;

WITH ins325 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 325, 0, $h325994$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h325994$, $t325995$مادة (325)$t325995$, $b325993$لا يقضى في الأمر الجنائي بغير الغرامـة والعقوبـات التكميليـة والتـضمينات وما يجب رده والمصاريف ،ويجوز أن يقضى فيه بالبراءة أو برفض الدعوى المدنيـة أو بوقف تنفيذ العقوبة.$b325993$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins325;

WITH ins326 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 326, 0, $h326997$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h326997$, $t326998$مادة (326)$t326998$, $b326996$يرفض القاضي إصدار الأمر إذا رأى: )أولا ً( إنه لا يمكن الفصل في الدعوى بحالتها التي هـي عليهـا أو دون تحقيـق أو مرافعة.
)ثانيا( أن الواقعة نظرا لسوابق المتهم أو لأي سبب آخر تستوجب توقيع عقوبـة أشد من الغرامة التي يجوز صدور الأمر بها.
ويصدر القاضي قراره بالرفض بتأشير على الطلب الكتابي المقدم له ولا يجـوز الطعن في هذا القرار.
ويترتب على قرار الرفض إعادة الأوراق للنيابة العامة لاتخاذ ما يلزم فيها.$b326996$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins326;

WITH ins327 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 327, 0, $h3271000$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h3271000$, $t3271001$مادة (327)$t3271001$, $b327999$يجوز لكل عضو نيابة عامة من درجة وكيل نيابة على الأقل بالمحكمة التي مـن اختصاصها نظر الدعوى أن يصدر الأمر الجنائي في الجنح التي لا يوجـب القـانون الحكم فيها بالحبس أو الغرامة التي يزيد حدها الأدنى على عشرين ألف جنيـه فـضلا ً عن العقوبات التكميلية والتضمينات وما يجب رده والمصاريف.
ولا يجوز أن يؤمر بغير الغرامة التي لا يزيد حدها الأقصى على عشرين ألـف جنيه والعقوبات التكميلية والتضمينات وما يجب رده والمـصاريف ،ويكـون إصـدار الأمر الجنائي وجوبيا في المخالفات وفي الجنح المعاقب عليها بالغرامة وحـدها التـي لا يزيد حدها الأقصى على خمسة آلاف جنيه ،والتي لا يرى حفظها.
وللمحامي العام ولرئيس النيابة ،حسب الأحوال ،خلال خمسة عـشر يومـا مـن تاريخ صدور الأمر الجنائي ،أن يأمر بتعديله أو بإلغائه وحفظ الأوراق والتقريـر فـي الدعوى بأن لا وجه لإقامتها أو رفعها إلى المحكمة المختصة والـسير فـي الـدعوى الجنائية بالطرق العادية ،ولا يجوز إعلان الأمر للخصوم قبل انقضاء هذه المدة.$b327999$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins327;

WITH ins328 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 328, 0, $h3281003$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h3281003$, $t3281004$مادة (328)$t3281004$, $b3281002$يجب أن يعين في الأمر فضلا ً عما قضى به اسم المتهم كاملا ً ،ورقمـه القـومي أو رقم وثيقة سفره ،وموطنه إن كان أجنبيا ،والواقعة التي عوقب من أجلهـا ،ومـادة القانون التي طبقت.
ويعلن الأمر على النموذج الذي يقرره وزير العدل إلى المتهم والمدعي بـالحقوق المدنية ،ويجوز أن يكون الإعلان بواسطة أحد رجال الـسلطة العامـة ،كمـا يجـوز الإعلان عن طريق الهاتف المحمول أو البريد الإلكتروني المثبت ببيانات الرقم القومى بحسب الأحوال.$b3281002$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins328;

WITH ins329 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 329, 0, $h3291006$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h3291006$, $t3291007$مادة (329)$t3291007$, $b3291005$للنيابة العامة أن تعلن عدم قبولها الأمر الجنائي الصادر مـن القاضـي ،ولبـاقي الخصوم أن يعلنوا عدم قبولهم للأمر الصادر من القاضي أو من النيابة العامة ،ويكـون ذلك بتقرير بقلم كت ّاب محكمة الجنح المستأنفة فيما يتعلق بالأمر الصادر من القاضـي طبق ًا للمادة  ٣٢٤من هذا القانون ،وبتقرير بقلم كت ّاب محكمة الجـنح فـي غيـر هـذه الحالات ،وذلك كله خلال عشرة أيام من تاريخ صدور الأمر بالنسبة للنيابـة العامـة، ومن تاريخ إعلانه بالنسبة لباقي الخصوم.
وللنائب العام أن يعلن عدم قبوله الأمر الصادر من القاضي في ميعاد ثلاثين يوما من وقت صدور الأمر ،وله أن يقرر عدم القبول فـي قلـم كتـاب محكمـة الجـنح المستأنفة المختصة.
ويترتب على هذا التقرير سقوط الأمر واعتباره كأن لم يكن.
ويحدد الكاتب وقت تقديم التقرير اليوم الذي تنظر فيه الـدعوى أمـام المحكمـة، مع مراعاة المواعيد المقررة في المادة  ٢٢٩من هـذا القـانون ،ويخطـر الخـصوم أو وكلاؤهم بتاريخ الجلسة المحددة ويعد هـذا الإخطـار بمثابـة إعـلان بميعادهـا، ويكلف باقي الخصوم والشهود بالحضور في الميعاد المحدد.
أما إذا لم يحصل اعتراض علـى الأمـر بالطريقـة المتقدمـة يـصبح نهائيـا واجب التنفيذ.
ولا يكون لما قضى به الأمر في موضوع الدعوى الجنائية حجية أمام المحاكم المدنية.$b3291005$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins329;

WITH ins330 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 330, 0, $h3301009$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h3301009$, $t3301010$مادة (330)$t3301010$, $b3301008$إذا حضر الخصم الذي لم يقبل الأمر الجنائي في الجلسة المحددة تنظر الـدعوى في مواجهته وفق ًا للإجراءات العادية.
أما إذا لم يحضر تعود للأمر قوته ويصبح نهائيا واجب التنفيذ.
وفي جميع الأحوال ،لا يجوز أن يضار المعترض باعتراضه.$b3301008$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins330;

WITH ins331 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 331, 0, $h3311012$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h3311012$, $t3311013$مادة (331)$t3311013$, $b3311011$إذا تعدد المتهمون وصدر ضدهم أمر جنائي وقرروا عدم قبوله وحضر بعـضهم في اليوم المحدد لنظر الدعوى ولم يحضر البعض الآخـر تنظـر الـدعوى بـالطرق المعتادة بالنسبة لمن حضر ويصبح الأمر نهائيا واجب التنفيذ بالنسبة لمن لم يحضر.$b3311011$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins331;

WITH ins332 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 332, 0, $h3321015$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الحادى عشر الأوامر الجنائية$h3321015$, $t3321016$مادة (332)$t3321016$, $b3321014$إذا ادعى المتهم عند التنفيذ عليه أن حقه في عدم قبول الأمر الجنـائى لا يـزال قائما لعدم إعلانه بالأمر أو لغير ذلك من الأسباب ،أو أن مانعـا قهريـا منعـه مـن الحضور في الجلسة المحددة لنظر الدعوى ،أو إذا حصل إشكال آخر في التنفيذ ،يقـدم الإشكال إلى القاضي المختص ليفصل فيه بغير مرافعة ،إلا إذا رأى عدم إمكان الفصل فيه بحالته أو دون تحقيق أو مرافعة ،يحدد يوم لينظر في الإشكال وفق ًـا للإجـراءات العادية ،ويكلف المتهم وباقي الخصوم بالحضور في اليوم المذكور ،فإذا قبل الإشـكال تجرى المحاكمة وفق ًا للمادة  ٣٣٠من هذا القانون.$b3321014$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins332;

WITH ins333 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 333, 0, $h3331018$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثانى عشر أوجه البطلان$h3331018$, $t3331019$مادة (333)$t3331019$, $b3331017$يترتب البطلان على عدم مراعاة أحكام القانون المتعلقة بأي إجراء جوهري.$b3331017$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins333;

WITH ins334 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 334, 0, $h3341021$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثانى عشر أوجه البطلان$h3341021$, $t3341022$مادة (334)$t3341022$, $b3341020$إذا كان البطلان راجعا لعدم مراعاة أحكام القانون المتعلقـة بتـشكيل المحكمـة أو بولايتها بالحكم في الدعوى أو باختصاصها من حيث نـوع الجريمـة المعروضـة عليها أو بالحرية الشخصية أو حرمة المسكن أو حرية الحياة الخاصة أو بغير ذلك مما هو متعلق بالنظام العام جاز التمسك به في أية حالة كانت عليها الدعوى ،وتقضي بـه المحكمة ولو بغير طلب.$b3341020$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins334;

WITH ins335 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 335, 0, $h3351024$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثانى عشر أوجه البطلان$h3351024$, $t3351025$مادة (335)$t3351025$, $b3351023$في غير الأحوال المشار إليها في المادة  ٣٣٤من هذا القانون ،يسقط الحـق فـي الدفع ببطلان الإجراءات الخاصة بجمع الاستدلالات أو التحقيق الابتدائي أو التحقيـق بالجلسة في الجنح والجنايات إذا كان للمتهم محام وحـصل الإجـراء بحـضوره دون اعتراض منه.
أما في مواد المخالفات فيعتبر الإجراء صحيحا إذا لم يعترض عليه المتهم.
وكذلك يسقط حق الدفع بالبطلان بالنسبة للنيابة العامة إذا لم تتمسك به في حينه.$b3351023$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins335;

WITH ins336 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 336, 0, $h3361027$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثانى عشر أوجه البطلان$h3361027$, $t3361028$مادة (336)$t3361028$, $b3361026$إذا حضر المتهم في الجلسة بنفسه أو بواسطة وكيل عنه ،فليس لـه أن يتمـسك ببطلان ورقة التكليف بالحضور ،وإنما له أن يطلب تصحيح التكليـف أو اسـتيفاء أي نقص فيه وإعطاءه ميعادا لتحضير دفاعه قبل البدء في نظر الدعوى ،وعلى المحكمـة إجابته إلى طلبه.$b3361026$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins336;

WITH ins337 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 337, 0, $h3371030$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثانى عشر أوجه البطلان$h3371030$, $t3371031$مادة (337)$t3371031$, $b3371029$يجوز للقاضي أن يصحح ولو من تلقاء نفسه كل إجراء يتبين له بطلانه.$b3371029$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins337;

WITH ins338 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 338, 0, $h3381033$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثانى عشر أوجه البطلان$h3381033$, $t3381034$مادة (338)$t3381034$, $b3381032$إذا تقرر بطلان أي إجراء ،فإنه يتناول جميع الآثار التي تترتب عليـه مباشـرة، ولزم إعادته متى أمكن ذلك.$b3381032$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins338;

WITH ins339 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 339, 0, $h3391036$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثانى عشر أوجه البطلان$h3391036$, $t3391037$مادة (339)$t3391037$, $b3391035$إذا وقع خطأ مادي في حكم أو في أمر صادر من جهات التحقيق أو المحاكمة ولم يكن يترتب عليه البطلان ،تتولى الجهة التي أصدرت الحكم أو الأمر تصحيح الخطـأ من تلقاء نفسها أو بناء على طلب أحد الخصوم وذلك بعد تكليفهم بالحضور.
ويقضى بالتصحيح في غرفة المشورة بعد سماع أقوال الخصوم ،ويؤشر بـالأمر الذي يصدر على هامش الحكم أو الأمر.
ويتبع هذا الإجراء في تصحيح اسم المتهم ولقبه.$b3391035$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins339;

WITH ins340 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 340, 0, $h3401039$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث عشر المتهمون المصابون باضطراب نفسي أو عقلي$h3401039$, $t3401040$مادة (340)$t3401040$, $b3401038$إذا استلزم التحقيق في جناية أو جنحة معاقب عليها بالحبس مدة لا تقل عن سـنة فحص حالة الاضطراب النفسي أو العقلي للمتهم ،ومدى تأثيرها على إدراكه واختياره، تعين عرض الأوراق والمتهم بناء على طلب النيابة العامة أو قاضي التحقيق بحـسب الأحوال على القاضي الجزئي ،للأمر بإيداع المتهم تحت الملاحظة في إحدى منـشآت الصحة النفسية الحكومية ،والتي يصدر بتحديدها قرار من المجلس القـومي للـصحة النفسية ،لمدة أو مدد لا يزيد مجموعها عن خمسة وأربعين يومـا ،وتكليـف المجلـس الإقليمي للصحة النفسية المختص بانتداب لجنة ثلاثية من الأطباء النفـسيين المقيـدين لديه لفحصه ،وإعداد تقرير طبي يتضمن تقييما لحالته النفسية والمرضية وقت ارتكاب الجريمة ،ووقت إجراء التقييم والخطة العلاجيـة المقترحـة ،حـال ثبـوت إصـابته باضطراب نفسي أو عقلي.
ويجوز للمحكمة مد مدة الإيداع تحت الملاحظة لمدة أو مدد أخـرى بنـاء علـى طلب المجلس الإقليمي للصحة النفسية المختص على ألا يزيد مجموع مدة الإيداع فـي جميع الأحوال بالمنشأة على ثلاثة أشهر.$b3401038$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins340;

WITH ins341 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 341, 0, $h3411042$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث عشر المتهمون المصابون باضطراب نفسي أو عقلي$h3411042$, $t3411043$مادة (341)$t3411043$, $b3411041$يجوز للنيابة العامة والمتهم ولكل ذي شأن استئناف أمر الإيداع تحت الملاحظـة المشار إليه في المادة  ٣٤٠من هذا القانون أو قرار رفـض إصـداره أو مـد مدتـه بموجب تقرير استئناف يودع لدى النيابة المختصة خلال ثمان وأربعـين سـاعة مـن تاريخ صدوره ،وينظر الاستئناف أمام محكمة الجنح المـستأنفة منعقـدة فـي غرفـة المشورة ،وتفصل فيه خلال اثنتين وسبعين ساعة على الأكثر من تاريخ التقريـر بـه، ويبدأ تنفيذ الأمر من تاريخ فوات المدة المقررة للاستئناف أو الفصل فيه من المحكمة.
ويعتبر أمر الإيداع المشار إليه بمثابة أمر حبس احتياطي يتعين خصم مدته مـن مدة العقوبة المقضي بها على المتهم إذا ثبتت سلامته مـن أي اضـطراب نفـسي أو عقلي ،وينتهي الأمر بقوة القانون بانتهاء مدته دون مده أو من اليوم التـالي لإخطـار النيابة المختصة أو قاضي التحقيق بحسب الأحوال بإعـداد التقريـر الطبـي النفـسي الخاص بالمتهم ،قبل انتهاء المدة المحددة للحجز ،ويتعين علـى النيابـة المختـصة أو قاضي التحقيق الأمر بإيداع المتهم مؤقت ًا بإحدى منشآت الـصحة النفـسية الحكوميـة، والتي يصدر بتحديدها قرار من المجلس القومي للـصحة النفـسية إذا ثبـت إصـابته باضطراب نفسي أو عقلي دون حضوره لحـين التـصرف فـي الأوراق ،أو حبـسه احتياطيا أو مد حبسه احتياطيا وفق ًا لأحكام الحبس الاحتياطي المنصوص عليها في هذا القانون أو الإفراج عنه إذا ثبت سلامته من أي اضطراب نفسي أو عقلي.
ويكون إصدار الأمر المشار إليه في المادة  ٣٤٠مـن هـذا القـانون للمحكمـة المنظورة أمامها الدعوى ،بعد سماع أقوال النيابة العامة والمدافع عن المتهم.$b3411041$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins341;

WITH ins342 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 342, 0, $h3421045$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث عشر المتهمون المصابون باضطراب نفسي أو عقلي$h3421045$, $t3421046$مادة (342)$t3421046$, $b3421044$يجوز للنيابة العامة في الجنح المعاقب عليها بالغرامة وحدها أو الحبس الذي تقـل مدته عن سنة واحدة ،وفي المخالفات ندب أحد الأطباء النفـسيين المقيـدين بـسجلات المجلس الإقليمي للصحة النفسية لفحص المتهم ،وتقرير ما إذا كانت حالتـه تـستدعي الدخول الإلزامي لإحدى منشآت الصحة النفسية ،خلال مدة لا تزيد عن ثمان وأربعـين ساعة ،فإذا ثبت إصابة المتهم باضطراب نفسي أو عقلي تأمر النيابة العامة بنقله إلـى إحدى منشآت الصحة النفسية ،واتخاذ إجراءات دخوله وعلاجه إلزاما وفق ًا للـضوابط الواردة في قانون رعاية المريض النفسي الصادر بالقانون رقم  ٧١لسنة  ،٢٠٠٩ويـتم التصرف في الأوراق في ضوء ذلك.$b3421044$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins342;

WITH ins343 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 343, 0, $h3431048$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث عشر المتهمون المصابون باضطراب نفسي أو عقلي$h3431048$, $t3431049$مادة (343)$t3431049$, $b3431047$إذا ثبت من التقرير الطبي النفسي أن المتهم غير قادر على الـدفاع عـن نفـسه، بسبب اضطراب نفسي أو عقلي ،طرأ بعد وقوع الجريمة ،يوقف رفع الدعوى عليه أو محاكمته حتى يعود إليه رشده.
ويجوز في هذه الحالة لمحكمة الجنح المستأنفة منعقدة في غرفة المشورة بناء على طلب النيابة العامة أو قاضي التحقيق بحسب الأحوال ،أو المحكمة المنظورة أمامها الدعوى ،إذا كانت الواقعة جناية أو جنحة عقوبتها الحبس مدة لا تقل عن سنة إصدار الأمر بإيداع المتهم في إحدى منشآت الصحة النفسية الحكومية ،والتي يصدر بتحديدها قرار من المجلس القومي للصحة النفسية ،لتلقي العلاج والرعاية الطبية إلى أن يتقرر إخلاء سبيله ،وفي جميع الأحوال تخصم مدة الإيداع من مدة العقوبة التي يقضي بها.$b3431047$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins343;

WITH ins344 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 344, 0, $h3441051$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث عشر المتهمون المصابون باضطراب نفسي أو عقلي$h3441051$, $t3441052$مادة (344)$t3441052$, $b3441050$لا يحول إيقاف الدعوى الجنائية لإصابة المتهم باضطراب نفـسي أو عقلـي دون اتخاذ إجراءات التحقيق التي يرى أنها مستعجلة أو لازمة.$b3441050$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins344;

WITH ins345 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 345, 0, $h3451054$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث عشر المتهمون المصابون باضطراب نفسي أو عقلي$h3451054$, $t3451055$مادة (345)$t3451055$, $b3451053$إذا ثبت من التقرير الطبي النفسي أن المتهم يعاني من اضطراب نفسي أو عقلـي أدى إلى إنقاص إدراكـه أو اختيـاره دون أن يفقـده ،يجـوز للمحكمـة أن تقـضي بقيام المحكوم عليه بتنفيذ العقوبة المقضي بها في إحـدى منـشآت الـصحة النفـسية الحكومية التي يصدر بتحديدها قرار من المجلس القومي للصحة النفسية لتلقي العـلاج والرعاية اللازمة.
وفي جميع الأحوال ،لا يجوز إيداع المتهم أو المحكوم عليه بمراكـز الإصـلاح والتأهيل العمومية أو مراكز الإصلاح الجغرافية متى ثبت إصابته باضـطراب نفـسي أو عقلي أفقده القدرة على الإدراك أو الاختيار أو نقص من هـذه القـدرة أو تـوافرت في شأنه إحدى حالات الدخول الإلزامي المنصوص عليها بقـانون رعايـة المـريض النفسي المشار إليه حتى يبرأ منه.$b3451053$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins345;

WITH ins346 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 346, 0, $h3461057$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الثالث عشر المتهمون المصابون باضطراب نفسي أو عقلي$h3461057$, $t3461058$مادة (346)$t3461058$, $b3461056$إذا صدر أمر بأن لا وجه لإقامة الدعوى أو حكم ببراءة المتهم ،وكان ذلك بسبب اضطراب نفسي أو عقلي ،تأمر الجهة التي أصدرت الأمر أو الحكم إذا كانت الواقعـة جناية أو جنحة عقوبتها الحبس مدة لا تقل عن سنة بإيداعه في إحدى منشآت الـصحة النفسية الحكومية التي يصدر بتحديدها قرار من المجلس القـومي للـصحة النفـسية، ضا وفق ًا لأحكام الدخول الإلزامـي ويكون الإفراج عنه أو الأمر بمعاملته باعتباره مري أو نقله لأية جهة أخرى عند ثبوت استقرار حالته النفسية ،مع استمرار حاجته للرعايـة أو تلقي العلاج أو الدعم النفسي من الجهة التي أصدرت الأمر أو الحكم ،بنـاء علـى توصية من اللجنة المشكلة بقرار من المجلس القومي للصحة النفسية لفحص المودعين، على أنه في الجنايات المعاقب عليها بعقوبة الإعدام والسجن المؤبد لا يجـوز الإفـراج عن المتهم إلا بعد صدور توصيتين على الأقل من اللجنة سالفة البيان يفـصل بينهمـا مدة ثلاثة أشهر على الأقل.
واني عليهم الأطفال$b3461056$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins346;

WITH ins347 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 347, 0, $h3471060$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الرابع عشر حماية انى عليهم المصابين باضطراب نفسي أو عقلي،$h3471060$, $t3471061$مادة (347)$t3471061$, $b3471059$إذا وقعت على مجني عليه مصاب باضطراب نفسي أو عقلي جناية أو جنحة من جرائم الاعتداء على النفس ،جاز لسلطة التحقيق أن تصدر أمرا بإيداعه مؤقت ًا في إحدى منشآت الصحة النفسية لتلقي العلاج والرعاية الطبية ،وفقا لأحكام الدخول الإلزامي المنصوص عليها بقانون رعاية المريض النفسي المشار إليه.$b3471059$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins347;

WITH ins348 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 348, 0, $h3481063$الكتاب الثانى المحاكم - الباب الثانى محاكم الجنح - الفصل الرابع عشر حماية انى عليهم المصابين باضطراب نفسي أو عقلي،$h3481063$, $t3481064$مادة (348)$t3481064$, $b3481062$يجوز لسلطة التحقيق المختصة عند سؤال المجني عليهم الأطفال في أي جريمـة استدعاء أحد ذوي الطفل ،أو أحد الأخصائيين الاجتماعيين لحضور إجراءات التحقيق.
كما يجوز للمحقق تسجيل أقوال الطفل المجني عليه سمعيا وبصريا ،ويجوز أن يكون التسجيل سمعيا فقط ،بناء على طلب الطفل أو الشخص الذي يحضر من ذويه، ويحفظ هذا التسجيل بواسطة إحدى وسائط التخزين الرقمية تودع ملف القضية.$b3481062$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins348;

WITH ins349 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 349, 0, $h3491066$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الأول تشكيل محاكم الجنايات وتحديد أدوار انعقادها$h3491066$, $t3491067$مادة (349)$t3491067$, $b3491065$تشكل في كل محكمة استئناف محكمة أو أكثر لنظر قضايا الجنايات ،وتؤلف كـل منها من ثلاثة من قضاتها برئاسة أحد نواب رئيس محكمة الاستئناف على الأقل.
وتخصص دائرة أو أكثر من دوائر محكمة الجنايات يكون رئيس كل منها بدرجة رئيس بمحكمة الاستئناف لنظر الجنايات المنصوص عليها في الأبواب الأول والثـاني والثاني مكررا والثالث والرابع من الكتاب الثاني مـن قـانون العقوبـات ،والجـرائم المرتبطة بتلك الجنايات ،ويفصل في هذه القضايا على وجه السرعة.$b3491065$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins349;

WITH ins350 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 350, 0, $h3501069$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الأول تشكيل محاكم الجنايات وتحديد أدوار انعقادها$h3501069$, $t3501070$مادة (350)$t3501070$, $b3501068$تشكل في كل محكمة استئناف محكمة أو أكثر تستأنف أمامها الأحكـام الـصادرة من دوائر جنايات أول درجة ،وتؤلف كل منها من ثلاثة من قضاتها أحدهم على الأقـل بدرجة رئيس محكمة استئناف ،وتكون رئاسة المحكمة لأقدمهم.$b3501068$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins350;

WITH ins351 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 351, 0, $h3511072$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الأول تشكيل محاكم الجنايات وتحديد أدوار انعقادها$h3511072$, $t3511073$مادة (351)$t3511073$, $b3511071$تحدد الجمعية العامة لكل محكمة من محاكم الاستئناف في كل سـنة بنـاء علـى طلب رئيسها ،من يعهد إليه من قضاتها للعمل بمحاكم الجنايات بدرجتيها.
وإذا حصل مانع لأحد القضاة المعينين لدور من أدوار انعقاد محكمـة الجنايـات بدرجتيها يستبدل به آخر من القضاة يندبه رئيس محكمة الاستئناف من ذات الدرجة.$b3511071$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins351;

WITH ins352 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 352, 0, $h3521075$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الأول تشكيل محاكم الجنايات وتحديد أدوار انعقادها$h3521075$, $t3521076$مادة (352)$t3521076$, $b3521074$تنعقد محكمة الجنايات بدرجتيها في كل جهة بها محكمة ابتدائية ،وتـشمل دائـرة اختصاصها ما تشمله دائـرة المحكمـة الابتدائيـة ،ويجـوز إذا اقتـضت الحـال أن تنعقد محكمة الجنايات في مكان آخر يعينه وزير العدل بناء على طلب رئيس محكمـة الاستئناف.
ويجوز عند الضرورة بقرار من الجمعية العامة لمحكمة الاستئناف أو من تفوضه أن تشمل دائرة اختصاص محكمة الجنايات المستأنفة ما تشمله أكثر من دائرة لمحكمـة ابتدائية ،ويبين القرار في هذه الحالة مكان انعقادها.$b3521074$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins352;

WITH ins353 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 353, 0, $h3531078$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الأول تشكيل محاكم الجنايات وتحديد أدوار انعقادها$h3531078$, $t3531079$مادة (353)$t3531079$, $b3531077$تنعقد محكمة الجنايات بدرجتيها كل شهر ما لم يصدر قرار من رئـيس محكمـة الاستئناف بخلاف ذلك.$b3531077$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins353;

WITH ins354 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 354, 0, $h3541081$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الأول تشكيل محاكم الجنايات وتحديد أدوار انعقادها$h3541081$, $t3541082$مادة (354)$t3541082$, $b3541080$يحدد تاريخ افتتاح كل دور من أدوار الانعقاد قبله بشهر على الأقل ،بقرار رئيس محكمة الاستئناف.$b3541080$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins354;

WITH ins355 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 355, 0, $h3551084$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الأول تشكيل محاكم الجنايات وتحديد أدوار انعقادها$h3551084$, $t3551085$مادة (355)$t3551085$, $b3551083$يعد في كل دور جدول للقضايا التي تنظر فيه ،وتوالي محكمة الجنايات بدرجتيها جلساتها إلى أن تنتهي القضايا المقيدة بالجدول.$b3551083$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins355;

WITH ins356 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 356, 0, $h3561087$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الأول تشكيل محاكم الجنايات وتحديد أدوار انعقادها$h3561087$, $t3561088$مادة (356)$t3561088$, $b3561086$يتبع في الدعاوى التي تنظرها محكمـة الجنايـات المـستأنفة جميـع الأحكـام والأوضاع المقررة أمام محاكم جنايات أول درجة.$b3561086$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins356;

WITH ins357 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 357, 0, $h3571090$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3571090$, $t3571091$مادة (357)$t3571091$, $b3571089$يكون تكليف المتهم والشهود بالحضور أمام محكمـة جنايـات أول درجـة قبـل الجلسة بعشرة أيام كاملة على الأقل.
وفي الأحوال التي يكون فيها استئناف الحكم من النيابة العامـة ،يكـون إعـلان المتهم بالاستئناف والحضور أمام محكمة الجنايات المستأنفة قبل الجلسة بعـشرة أيـام كاملة على الأقل.
ولا تتصل المحكمة بالدعوى إلا بإعلان المتهم بأمر الإحالة.$b3571089$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins357;

WITH ins358 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 358, 0, $h3581093$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3581093$, $t3581094$مادة (358)$t3581094$, $b3581092$فيما عدا حالة العذر أو المانع الذي يثبت صحته ،يجب على المحامي سواء أكـان موكلا من قبل المتهم أم كان منتدبا من قبل النيابة العامة أو قاضي التحقيق ،أو رئـيس محكمة الجنايات بدرجتيها ،أن يدافع عن المتهم في الجلسة أو ينيب محاميا غيره ،وإلا حكم عليه من محكمة الجنايات بدرجتيها بغرامة لا تتجاوز ثلاثمائة جنيـه مـع عـدم الإخلال بالمساءلة التأديبية إذا كان لذلك مقتض.
وللمحكمة إعفاؤه من الغرامة إذا ثبت لها أنه تعذر عليه أن يحضر فـي الجلـسة بنفسه أو أن ينيب عنه غيره.$b3581092$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins358;

WITH ins359 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 359, 0, $h3591096$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3591096$, $t3591097$مادة (359)$t3591097$, $b3591095$في الأحوال التي يتعذر فيها على المتهم أن يوكل محاميـا للـدفاع عنـه ،تقـدر المحكمة للمحامي المنتدب من قبل النيابة العامة أو قاضي التحقيق أو رئـيس محكمـة الجنايات بدرجتيها ،بحسب الأحوال ،أتعابا على الخزانة العامة تحـددها فـي حكمهـا الصادر في الدعوى.
ويجوز التظلم من هذا التقدير أمام المحكمة التي أصدرت الحكم بتقدير الأتعاب.$b3591095$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins359;

WITH ins360 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 360, 0, $h3601099$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3601099$, $t3601100$مادة (360)$t3601100$, $b3601098$لا تقبل المرافعة أمام محكمة جنايات أول درجـة إلا مـن المحـامين المقبـولين للمرافعة أمام المحاكم الابتدائية على الأقل ،كما لا تقبل المرافعة أمام محكمة الجنايـات المستأنفة إلا من المحامين المقبولين للمرافعة أمام محاكم الاستئناف على الأقل.$b3601098$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins360;

WITH ins361 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 361, 0, $h3611102$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3611102$, $t3611103$مادة (361)$t3611103$, $b3611101$يجب على رئيس محكمة الاستئناف عند وصول ملف القـضية أن يحـدد الـدور الذي يجب أن تنظر فيه ،وأن يعد جدول قضايا كل دور من أدوار الانعقـاد ،ويرسـل صور ملفات القضايا إلى القضاة المعينين للدور الذي أحيلت إليه ،ويأمر بإعلان المتهم والشهود باليوم الذي يحدد لنظر القضية ،مع مراعاة حكم المادة  ٣٥٧من هذا القـانون إذا كان الاستئناف مرفوعا من النيابة العامة.
وإذا دعت أسباب جدية لتأجيل نظر القضية يجب أن يكون التأجيل ليـوم معـين سواء في ذات الدور أو في دور مقبل.$b3611101$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins361;

WITH ins362 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 362, 0, $h3621105$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3621105$, $t3621106$مادة (362)$t3621106$, $b3621104$يجوز لكل من النيابة العامة والمتهم والمدعي بالحقوق المدنية والمسئول عنهـا أن يعارض في سماع شهادة الشهود الذين لم يسبق إعلانهم بأسمائهم.$b3621104$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins362;

WITH ins363 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 363, 0, $h3631108$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3631108$, $t3631109$مادة (363)$t3631109$, $b3631107$مع مراعاة أحكام المادة  ١٢٤من هذا القانون ،لمحكمة الجنايات بـدرجتيها فـي جميع الأحوال أن تأمر بالقبض على المتهم أو ضبطه وإحضاره ،ولها أن تأمر بحبسه احتياطيا ،وأن تفرج عنه بكفالة.$b3631107$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins363;

WITH ins364 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 364, 0, $h3641111$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3641111$, $t3641112$مادة (364)$t3641112$, $b3641110$تتبع أمام محكمة الجنايات بدرجتيها جميع الأحكام المقررة في الجنح ما لم يـنص على خلاف ذلك.$b3641110$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins364;

WITH ins365 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 365, 0, $h3651114$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3651114$, $t3651115$مادة (365)$t3651115$, $b3651113$لا يجوز لمحكمة الجنايات بدرجتيها أن تصدر حكما بالإعـدام إلا بإجمـاع آراء أعضائها ،ويجب عليها قبل أن تصدر هذا الحكم أن تأخـذ رأي مفتـي الجمهوريـة، ويجب إرسال أوراق القضية إليه ،ويتعين عليه في جميع الأحوال أن يرسل رأيه إلـى المحكمة قبل جلسة النطق بالحكم بفترة كافية ،فإذا لم يصل رأيه إلـى المحكمـة قبـل التاريخ المحدد للنطق بالحكم ،حكمت المحكمة في الدعوى.
وفي حالة خلو وظيفة المفتى أو غيابه أو قيام مانع لديه يندب وزير العدل بقـرار منه من يقوم مقامه.$b3651113$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins365;

WITH ins366 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 366, 0, $h3661117$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3661117$, $t3661118$مادة (366)$t3661118$, $b3661116$لا يجوز الطعن في أحكام محكمـة الجنايـات المـستأنفة إلا بطريـق الـنقض أو إعادة النظر.$b3661116$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins366;

WITH ins367 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 367, 0, $h3671120$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3671120$, $t3671121$مادة (367)$t3671121$, $b3671119$إذا رأت محكمة جنايات أول درجة أن الواقعة كما هي مبينة فـي أمـر الإحالـة وقبل تحقيقها بالجلسة تعد جنحة ،فلها أن تحكـم بعـدم الاختـصاص وتحيلهـا إلـى المحكمة الجزئية.
أما إذا لم تر ذلك إلا بعد التحقيق تحكم فيها.$b3671119$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins367;

WITH ins368 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 368, 0, $h3681123$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثانى الإجراءات أمام محاكم الجنايات$h3681123$, $t3681124$مادة (368)$t3681124$, $b3681122$لمحكمة جنايات أول درجة إذا أحيلت إليها جنحة مرتبطـة بجنايـة ورأت قبـل تحقيقها أن لا وجه لهذا الارتباط أن تفصل الجنحة وتحيلها إلى المحكمة الجزئية.$b3681122$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins368;

WITH ins369 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 369, 0, $h3691126$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3691126$, $t3691127$مادة (369)$t3691127$, $b3691125$إذا صدر أمر بإحالة متهم بجناية إلى محكمة جنايات أول درجة ولم يحضر هـو أو وكيله الخاص يوم الجلسة بعد إعلانـه قانونـا بـأمر الإحالـة وبورقـة التكليـف بالحضور ،يكون للمحكمة أن تحكم في غيبته ،ويجوز لها أن تؤجل الـدعوى وتـأمر بإعادة تكليفه بالحضور.
ومع عدم الإخلال بسلطة المحكمة المنصوص عليهـا بالمـادة  ٣٦٣مـن هـذا القانون ،يكون الحكم حضوريا إذا مثل المتهم أو وكيله الخاص بالجلسة.$b3691125$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins369;

WITH ins370 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 370, 0, $h3701129$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3701129$, $t3701130$مادة (370)$t3701130$, $b3701128$يتلى في الجلسة أمر الإحالة ثم الأوراق المثبتة لإعلان المـتهم ،وتبـدي النيابـة العامة والمدعي بالحقوق المدنية إن وجد أقوالهما وطلباتهما ،وتسمع المحكمة الـشهود إذا رأت ضرورة لذلك ثم تفصل في الدعوى.$b3701128$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins370;

WITH ins371 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 371, 0, $h3711132$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3711132$, $t3711133$مادة (371)$t3711133$, $b3711131$إذا كان المتهم مقيما خارج مصر ،يعلن إليـه أمـر الإحالـة وورقـة التكليـف بالحضور بمحل إقامته إن كان معلوما ،وذلك قبل الجلسة المحددة لنظر الدعوى بـشهر على الأقل غير مواعيد المسافة ،فإذا لم يحضر بعد إعلانه يجوز الحكم في غيبته.$b3711131$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins371;

WITH ins372 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 372, 0, $h3721135$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3721135$, $t3721136$مادة (372)$t3721136$, $b3721134$كل حكم يصدر بالإدانة في غيبة المتهم يستلزم حتما حرمانه مـن أن يتـصرف في أمواله أو أن يديرها أو أن يرفع أية دعوى باسمه ،وكل تصرف أو التـزام يتعهـد به المحكوم عليه يكون باطلا ً من نفسه ،وذلك كله مع عدم الإخلال بحقوق حسن النيـة من الغير.
وتحدد المحكمة الابتدائية الواقع في دائرتها أموال المحكوم عليه حارسا لإدارتهـا بناء على طلب النيابة العامة أو كل ذي مصلحة في ذلك ،وللمحكمة أن تلزم الحـارس الذي تنصبه بتقديم كفالة ،ويكـون تابعـا لهـا فـي جميـع مـا يتعلـق بالحراسـة وتقديم الحساب.$b3721134$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins372;

WITH ins373 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 373, 0, $h3731138$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3731138$, $t3731139$مادة (373)$t3731139$, $b3731137$تنتهي الحراسة المشار إليها في المادة  ٣٧٢من هـذا القـانون بـصدور حكـم حضوري في الدعوى أو بموت المتهم حقيقة أو حكما وفق ًا لقانون الأحوال الشخـصية، وبعد انتهاء الحراسة يقدم الحارس حسابا عن إدارته.$b3731137$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins373;

WITH ins374 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 374, 0, $h3741141$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3741141$, $t3741142$مادة (374)$t3741142$, $b3741140$ينفذ من الحكم الغيابي كل العقوبات التي يمكن تنفيذها.$b3741140$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins374;

WITH ins375 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 375, 0, $h3751144$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3751144$, $t3751145$مادة (375)$t3751145$, $b3751143$يجوز تنفيذ الحكم بالتضمينات من وقت صدوره ،ويجب على المـدعي بـالحقوق المدنية أن يقدم كفالة ،ما لم ينص الحكم على خلاف ذلك أو تقرر المحكمـة الابتدائيـة إعفاءه منها.
وتنتهي الكفالة بمضي خمس سنوات من وقت صدور الحكم.$b3751143$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins375;

WITH ins376 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 376, 0, $h3761147$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3761147$, $t3761148$مادة (376)$t3761148$, $b3761146$لا يسقط الحكم الصادر غيابيا في جناية من محكمة الجنايات بـدرجتيها بمـضي المدة ،وإنما تسقط العقوبة المحكوم بها ،ويصبح الحكم نهائيا بسقوطها.$b3761146$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins376;

WITH ins377 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 377, 0, $h3771150$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3771150$, $t3771151$مادة (377)$t3771151$, $b3771149$إذا حضر المحكوم عليه غيابيا من محكمـة الجنايـات بـدرجتيها ،أو قـبض عليـه أو حضر وكيله الخاص وطلب إعادة المحاكمة قبل سقوط العقوبة بمـضي المـدة ،يحـدد رئيس محكمة الاستئناف أقرب جلسة لإعادة نظر الدعوى ،فـإذا تخلـف المحكـوم عليـه غيابيا أو وكيله الخاص عن حضور الجلسة المحددة لإعادة نظر الدعوى ،اعتبـر الحكـم ضده قائما.
فإذا حضر المحكوم عليه غيابيا مرة أخرى قبل سقوط العقوبـة بمـضى المـدة وطلب إعادة المحاكمة ،يحدد رئيس محكمة الاستئناف أقـرب جلـسة لإعـادة نظـر الدعوى ،فإذا تخلف المحكوم عليه أو وكيله الخاص عن الحضور فى الجلسة المحـددة لإعادة نظر الدعوى أو فى جلسة تالية بغير عذر تندب له المحكمة محاميا للدفاع عنـه وتفصل فى الدعوى بحكم لا يقبل إعادة المحاكمة ،ويجوز الطعـن عليـه بالاسـتئناف أو بالنقض ،بحسب الأحوال ،وفق ًا لأحكام المادتين  ٤٠٣ ،٣٦٦من هذا القانون.
وفى جميع الأحوال ،يعرض المقبوض عليه محبوسا بالجلسة المحددة لإعادة نظر الدعوى ،وللمحكمة أن تأمر بالإفراج عنه أو استمرار حبسه احتياطيا حتى الانتهاء من نظر الدعوى ،ولا يجوز للمحكمة التشديد عما قضى به الحكم الغيابي.
وتختص بنظر إعادة الإجراءات في الأحكام الغيابية المحكمـة التـي أصـدرت الحكم ،على أنه إذا أصدرت محكمة جنايات أول درجة حكما غيابيا بالإدانة ولو كـان مشمولا ً بالتضمينات ،وتم استئنافه ،وأصدرت محكمة الجنايات المستأنفة حكما غيابيـا بتأييده أو تعديله ،تظل محكمة جنايات أول درجة مختصة بنظر إعادة الإجراءات فيه.
وإذا كان الحكم الغيابي السابق بالتضمينات قد نفذ تأمر المحكمـة بـرد المبـالغ المتحصلة كلها أو بعضها.
وإذا مات المحكوم عليه في غيبته يعاد الحكم في التضمينات في مواجهة الورثة.$b3771149$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins377;

WITH ins378 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 378, 0, $h3781153$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3781153$, $t3781154$مادة (378)$t3781154$, $b3781152$لا يترتب على غيـاب مـتهم تـأخير الحكـم فـي الـدعوى بالنـسبة لغيـره من المتهمين معه.$b3781152$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins378;

WITH ins379 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 379, 0, $h3791156$الكتاب الثانى المحاكم - الباب الثالث محاكم الجنايات - الفصل الثالث الإجراءات التي تتبع في مواد الجنايات في حق المتهمين الغائبين$h3791156$, $t3791157$مادة (379)$t3791157$, $b3791155$إذا غاب المتهم بجنحة مقدمة إلى محكمة جنايات أول درجة ،تتبـع فـي شـأنه الإجراءات المعمول بهـا أمـام محكمـة الجـنح ،ويكـون الحكـم الـصادر فيهـا قابلا ً للمعارضة.$b3791155$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins379;

WITH ins380 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 380, 0, $h3801159$الكتاب الثالث طرق الطعن في الأحكام - الباب الأول المعارضة$h3801159$, $t3801160$مادة (380)$t3801160$, $b3801158$تقبل المعارضة في الأحكام الغيابية الصادرة في الجنح ،وذلك من المتهم أو مـن المسئول عن الحقوق المدنية في خلال العشرة الأيام التالية لإعلانـه بـالحكم الغيـابي خلاف ميعاد المسافة المنصوص عليه في قانون المرافعات المدنية والتجارية ،ويجـوز أن يكون هذا الإعلان بملخص على نموذج يصدر به قرار من وزيـر العـدل ،وفـي جميع الأحوال لا يعتد بالإعلان لجهة الإدارة.
ومع ذلك إذا كان إعلان الحكم لم يحصل لشخص المتهم ،فإن ميعـاد المعارضـة بالنسبة إليه فيما يختص بالعقوبة المحكوم بها يبدأ من يوم علمـه بحـصول الإعـلان، وتكون المعارضة جائزة حتى تنقضي الدعوى بمضي المدة.
ويجوز أن يكون إعلان الأحكام الغيابية والمعتبرة حضورية بواسطة أحد رجـال السلطة العامة ،وذلك في الأحوال المنصوص عليها في الفقرة الأخيرة من المـادة ٦٢ من هذا القانون.$b3801158$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins380;

WITH ins381 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 381, 0, $h3811162$الكتاب الثالث طرق الطعن في الأحكام - الباب الأول المعارضة$h3811162$, $t3811163$مادة (381)$t3811163$, $b3811161$تقبل المعارضة في الأحكام المعتبرة حضورية في الأحوال المـشار إليهـا فـي المادتين  ٢٣٩ ،٢٣٧من هذا القانون إذا أثبت المحكوم عليه قيـام عـذر منعـه مـن الحضور ،ولم يستطع تقديمه قبل الحكم ،وكان استئنافه غير جائز.
وفى جميع الأحوال لا تقبل المعارضة في الأحكام المعتبرة حـضورية إذا أُعلـن المتهم بورقة التكليف بالحضور وسلمت لشخصه ،أو إذا حـضر عنـد النـداء علـى الدعوى وغادر الجلسة بعد ذلك ،أو إذا حضر هو أو وكيله أيا من جلسات المحاكمة ثم تخلف عن حضور باقي الجلسات حتى تاريخ صدور الحكم.$b3811161$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins381;

WITH ins382 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 382, 0, $h3821165$الكتاب الثالث طرق الطعن في الأحكام - الباب الأول المعارضة$h3821165$, $t3821166$مادة (382)$t3821166$, $b3821164$لا تجوز المعارضة من المدعي بالحقوق المدنية.$b3821164$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins382;

WITH ins383 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 383, 0, $h3831168$الكتاب الثالث طرق الطعن في الأحكام - الباب الأول المعارضة$h3831168$, $t3831169$مادة (383)$t3831169$, $b3831167$تحصل المعارضة بتقرير في قلم كت ّاب المحكمة التي أصدرت الحكم يثبـت فيـه تاريخ الجلسة التي حددت لنظرها ،ويعتبر ذلك إعلان ًا لها ولو كان التقرير من وكيـل، ويجب على النيابة العامة تكليف باقي الخصوم في الدعوى بالحضور وإعلان الـشهود للجلسة المذكورة.$b3831167$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins383;

WITH ins384 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 384, 0, $h3841171$الكتاب الثالث طرق الطعن في الأحكام - الباب الأول المعارضة$h3841171$, $t3841172$مادة (384)$t3841172$, $b3841170$يترتب على المعارضة إعادة نظر الدعوى بالنسبة إلى المعارض أمـام المحكمـة التي أصدرت الحكم ،ولا يجوز بأية حال أن يضار المعارض بناء علـى المعارضـة المرفوعة منه.
ومع ذلك إذا لم يحضر المعارض أو وكيله في أي من الجلسات المحـددة لنظـر الدعوى تعتبر المعارضة كأن لم تكن ،ويجوز للمحكمة في هذه الحالة أن تحكـم عليـه بغرامة إجرائية لا تجاوز ألف جنيه ،ولها أن تأمر بالنفاذ المؤقت ولـو مـع حـصول الاستئناف بالنسبة للتعويضات المحكوم بها ،وذلك حسب ما هو مقرر بالمادة  ٤٤٠من هذا القانون.
ولا يجوز من المعارض المعارضة في الحكم الصادر فـي غيبتـه ،وللمحكمـة في هذه الحالة أن تحكم عليه بغرامة إجرائية لا تقل عـن خمـسين جنيهـا ولا تزيـد على مائتي جنيه.$b3841170$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins384;

WITH ins385 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 385, 0, $h3851174$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3851174$, $t3851175$مادة (385)$t3851175$, $b3851173$لكل من المتهم والنيابة العامة أن يستأنف الأحكام الصادرة في الـدعوى الجنائيـة من المحكمة الجزئية في مواد الجنح.
ولا يجوز استئناف الحكم الصادر في جنحة معاقب عليهـا بغرامـة لا تجـاوز خمسة آلاف جنيه فضلا ً عن الرد والمصاريف ،إلا لمخالفة القانون أو خطأ في تطبيقه أو في تأويله أو لوقوع بطلان في الحكم أو في الإجراءات أثر في الحكم.$b3851173$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins385;

WITH ins386 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 386, 0, $h3861177$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3861177$, $t3861178$مادة (386)$t3861178$, $b3861176$يجوز استئناف الأحكام الصادرة في الدعوى المدنية من المحكمـة الجزئيـة فـي الجنح من المدعي بالحقوق المدنية ومن المسئول عنها أو المتهم فيما يختص بـالحقوق المدنية وحدها إذا كانت التعويضات المطلوبة تزيد على النـصاب الـذي يحكـم فيـه القاضي الجزئي نهائيا.$b3861176$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins386;

WITH ins387 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 387, 0, $h3871180$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3871180$, $t3871181$مادة (387)$t3871181$, $b3871179$يجوز استئناف الحكم الصادر في الجرائم المرتبطة في حكم المادة  ٣٢من قـانون العقوبات ،ولو لم يكن الاستئناف جائزا للمستأنف إلا بالنسبة لبعض هذه الجرائم فقط.$b3871179$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins387;

WITH ins388 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 388, 0, $h3881183$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3881183$, $t3881184$مادة (388)$t3881184$, $b3881182$لا يجوز قبل أن يفصل في موضوع الـدعوى اسـتئناف الأحكـام التحـضيرية والتمهيدية الصادرة في مسائل فرعية ،ويترتب حتما على استئناف الحكم الصادر فـي الموضوع استئناف هذه الأحكام.
ويجوز استئناف جميع الأحكام الصادرة بعدم الاختصاص ،والأحكـام الـصادرة بالاختصاص إذا لم يكن للمحكمة ولاية الحكم في الدعوى.$b3881182$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins388;

WITH ins389 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 389, 0, $h3891186$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3891186$, $t3891187$مادة (389)$t3891187$, $b3891185$يحصل الاستئناف بتقرير في قلم كتاب المحكمة التي أصدرت الحكم خلال عشرة أيام من تاريخ النطق بالحكم الحضوري ،أو إعلان الحكم الغيابي ،أو من تاريخ الحكـم الصادر في المعارضة في الحالات التي يجوز فيها ذلك.
وللنائب العام أن يستأنف خلال ثلاثين يوما من تـاريخ الحكـم ،ولـه أن يقـرر بالاستئناف في قلم كتاب المحكمة المختصة بنظر الاستئناف.$b3891185$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins389;

WITH ins390 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 390, 0, $h3901189$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3901189$, $t3901190$مادة (390)$t3901190$, $b3901188$الأحكام الصادرة في غيبة المتهم والمعتبرة حضوريا طبق ًا لأحكام المـواد ،٢٣٧ ٢٣٩ ،٢٣٨من هذا القانون يبدأ ميعاد استئنافها بالنسبة للمتهم من تاريخ إعلانه بها.$b3901188$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins390;

WITH ins391 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 391, 0, $h3911192$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3911192$, $t3911193$مادة (391)$t3911193$, $b3911191$يحدد قلم الكت ّاب للمستأنف في تقرير الاستئناف تاريخ الجلسة التي حددت لنظره، ويعتبر ذلك إعلان ًا لها ولو كان التقرير من وكيل ،ولا يكون هذا التاريخ قبـل مـضي ثلاثة أيام كاملة ،وتكلف النيابة العامة الخصوم الآخرين بالحضور.
وفي جميع الأحوال ،على المستأنف أن يتبع استئنافه ،حتى صدور الحكم فيه.$b3911191$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins391;

WITH ins392 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 392, 0, $h3921195$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3921195$, $t3921196$مادة (392)$t3921196$, $b3921194$إذا استأنف أحد الخصوم في مدة العشرة الأيام المقررة يمتـد ميعـاد الاسـتئناف لمن له حق الاستئناف من باقي الخصوم خمسة أيـام مـن تـاريخ انتهـاء العـشرة الأيام المذكورة.$b3921194$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins392;

WITH ins393 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 393, 0, $h3931198$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3931198$, $t3931199$مادة (393)$t3931199$, $b3931197$يرفع الاستئناف للمحكمة الابتدائية الكائنة في دائرتها المحكمـة التـي أصـدرت الحكم ،ويقدم خلال عشرين يوما على الأكثر إلى الدائرة المختصة بنظر الاستئناف في مواد الجنح.
وإذا كان المتهم محبوسا وجب على النيابة العامة نقله في الوقت المناسـب إلـى مركز الإصلاح والتأهيل بالجهة الموجودة بها المحكمة الابتدائية ،وينظـر الاسـتئناف على وجه السرعة.$b3931197$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins393;

WITH ins394 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 394, 0, $h3941201$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3941201$, $t3941202$مادة (394)$t3941202$, $b3941200$يضع أحد أعضاء الدائرة المنوط بها الحكم في الاستئناف تقريرا موقعا عليه منه، ويجب أن يشمل هذا التقرير ملخص وقائع الدعوى وظروفها وأدلـة الثبـوت والنفـي وجميع المسائل الفرعية التي رفعت والإجراءات التي تمت.
وبعد تلاوة هذا التقرير قبل إبداء رأي في الدعوى من واضـع التقريـر أو بقيـة الأعضاء ،تسمع أقوال المستأنف والأوجه المستند إليها في استئنافه ،ثم يتكلم بعد ذلـك باقي الخصوم ،ويكون المتهم آخر من يتكلم.
ثم تصدر المحكمة حكمها بعد اطلاعها على الأوراق.$b3941200$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins394;

WITH ins395 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 395, 0, $h3951204$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3951204$, $t3951205$مادة (395)$t3951205$, $b3951203$يسقط الاستئناف المرفوع من المحكوم عليه بعقوبة مقيدة للحرية واجبة النفـاذ إذا لم يتقدم للتنفيذ قبل الجلسة التي تنظر فيها الدعوى.
ومع ذلك فللمحكمة عند نظر الاستئناف أن تأمر بوقـف تنفيـذ العقوبـة مؤقت ًـا أو الإفراج عن المحكوم عليه بكفالة أو بغيرها ،وذلك إلى حين الفصل في الاستئناف.$b3951203$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins395;

WITH ins396 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 396, 0, $h3961207$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3961207$, $t3961208$مادة (396)$t3961208$, $b3961206$تسمع المحكمة الاستئنافية بنفسها ،أو بواسطة أحد القضاة تندبه لذلك الشهود الذين كان يجب سماعهم أمام محكمـة أول درجـة ،متـى رأت ضـرورة ذلـك للفـصل في الدعوى ،ولها أن تستوفى كل نقص آخر في إجراءات التحقيق.
وفي جميع الأحوال يجوز لها أن تأمر بما ترى لزومـه مـن اسـتيفاء تحقيـق أو سماع شهود.
ولا يجوز تكليف أي شاهد بالحضور إلا إذا أمرت المحكمة بذلك.$b3961206$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins396;

WITH ins397 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 397, 0, $h3971210$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3971210$, $t3971211$مادة (397)$t3971211$, $b3971209$إذا تبين للمحكمة الاستئنافية أن الواقعة جناية ،أو أنها جنحة من الجنح التي تقـع بواسطة الصحف أو غيرها من طرق النشر على غير الأفراد ،تحكم بعدم الاختصاص وتحيل الدعوى إلى النيابة العامة لاتخاذ ما يلزم فيها.$b3971209$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins397;

WITH ins398 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 398, 0, $h3981213$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3981213$, $t3981214$مادة (398)$t3981214$, $b3981212$إذا ألغي الحكم الصادر بالتعويضات ،وكان قـد نفـذ بهـا تنفيـذ ًا مؤقت ًـا ،تـرد التعويضات بناء على حكم الإلغاء.$b3981212$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins398;

WITH ins399 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 399, 0, $h3991216$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h3991216$, $t3991217$مادة (399)$t3991217$, $b3991215$إذا كان الاستئناف مرفوعا من النيابة العامة ،فللمحكمة أن تؤيد الحكـم أو تلغيـه أو تعدله سواء ضد المتهم أو لمصلحته.
ولا يجوز تشديد العقوبة المحكوم بها ولا إلغاء الحكم الصادر بالبراءة إلا بإجماع آراء قضاة المحكمة.
أما إذا كان الاستئناف مرفوعا من غير النيابة العامة فليس للمحكمة إلا أن تؤيـد الحكـم أو تعدله لمصلحة رافع الاستئناف ،ويجوز لها إذا قضت بسقوط الاسـتئناف أو بعـدم قبولـه أو بعدم جوازه أو برفضه أن تحكم على رافعه بغرامة لا تجاوز ألف جنيه.$b3991215$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins399;

WITH ins400 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 400, 0, $h4001219$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h4001219$, $t4001220$مادة (400)$t4001220$, $b4001218$يتبع في الأحكام الغيابية والمعارضة فيها أمام المحكمة الاستئنافية ما هـو مقـرر أمام محاكم أول درجة.$b4001218$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins400;

WITH ins401 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 401, 0, $h4011222$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h4011222$, $t4011223$مادة (401)$t4011223$, $b4011221$لا تقبل المعارضة في الأحكام الغيابية الصادرة من المحكمـة الاسـتئنافية إلا إذا كان الاستئناف مقررا من النيابة العامة أو من المدعي بالحقوق المدنية ولـم يحـضر الخصم أو وكيله جلسة المحاكمة رغم إعلانه بالاستئناف ،وقدم الخـصم عـذرا تقبلـه المحكمة منعه من الحضور.
وفى جميع الأحوال لا تقبل المعارضة الاستئنافية إذا أُعلن الخصم بورقة التكليف بالحضور وسلمت لشخصه ،أو إذا حضر عند النداء على الدعوى وغادر الجلسة بعـد ذلك ،أو إذا حضر هو أو وكيله أيا من جلسات المحاكمة ثم تخلف عن حـضور بـاقي الجلسات حتى تاريخ صدور الحكم.$b4011221$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins401;

WITH ins402 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 402, 0, $h4021225$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الأول استئناف الجنح$h4021225$, $t4021226$مادة (402)$t4021226$, $b4021224$إذا حكمت محكمة أول درجة في الموضوع ،ورأت المحكمة الاستئنافية أن هنـاك بطلان ًا في الإجراءات أو في الحكم ،تصحح البطلان وتحكم في الدعوى.
أما إذا حكمت بعدم الاختصاص أو بقبول دفع فرعي يترتب عليه منع السير فـي الدعوى ،وحكمت المحكمة الاستئنافية بإلغاء الحكم وباختصاص المحكمـة أو بـرفض الدفع الفرعي وبنظر الدعوى ،يجب عليها أن تعيد القضية لمحكمة أول درجـة للحكـم في موضوعها.$b4021224$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins402;

WITH ins403 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 403, 0, $h4031228$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4031228$, $t4031229$مادة (403)$t4031229$, $b4031227$يجوز لكل من النيابة العامة والمتهم أن يستأنفا الأحكـام الحـضورية الـصادرة من محكمة جنايات أول درجة.$b4031227$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins403;

WITH ins404 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 404, 0, $h4041231$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4041231$, $t4041232$مادة (404)$t4041232$, $b4041230$يجوز استئناف الأحكام الصادرة في الدعوى المدنية مـن محكمـة جنايـات أول درجة من المدعى بالحقوق المدنية أو المسئول عنها أو المتهم فيما يخـتص بـالحقوق المدنية وحدها ،إذا كانت التعويضات المطلوبة تزيد على النصاب الـذي تحكـم فيـه المحكمة الابتدائية نهائيا.$b4041230$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins404;

WITH ins405 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 405, 0, $h4051234$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4051234$, $t4051235$مادة (405)$t4051235$, $b4051233$يجوز للنيابة العامة أن تستأنف الأحكام الغيابية الصادرة في مواد الجنايات.$b4051233$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins405;

WITH ins406 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 406, 0, $h4061237$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4061237$, $t4061238$مادة (406)$t4061238$, $b4061236$يتبع في نظر الاستئناف والفصل فيه جميع الأحكام المقررة للاستئناف في مـواد الجنح ،ما لم ينص القانون على خلاف ذلك.$b4061236$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins406;

WITH ins407 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 407, 0, $h4071240$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4071240$, $t4071241$مادة (407)$t4071241$, $b4071239$يحصل الاستئناف بتقرير في قلم كتاب المحكمة التي أصدرت الحكم ،وذلك خلال أربعين يوما من تاريخ صدور الحكم.
فإذا كان مرفوعا من النيابة العامة يجب أن يكون التقرير موقعا من محـام عـام على الأقل.
وإذا كان الاستئناف مرفوعا من هيئة قضايا الدولة يجب أن يكون التقرير موقعـا من مستشار بها على الأقل.
وللنائب العام أن يستأنف الحكم خلال ستين يوما من تاريخ صدوره ،وله أن يقرر بالاستئناف في قلم كتاب المحكمة المختصة بنظر الاستئناف.$b4071239$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins407;

WITH ins408 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 408, 0, $h4081243$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4081243$, $t4081244$مادة (408)$t4081244$, $b4081242$يرفع قلم الكتاب التقرير بالاستئناف وملف الدعوى فور انتهـاء الميعـاد المحـدد لإيداع أسباب الحكم الصادر فيها إلى رئيس محكمة الاستئناف بعـد إدراج الاسـتئناف في جدول يعد لذلك ،ويحدد رئيس المحكمة جلسة لنظره ،ويأمر بإعلان المتهم وإخطار باقي الخصوم بها.$b4081242$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins408;

WITH ins409 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 409, 0, $h4091246$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4091246$, $t4091247$مادة (409)$t4091247$, $b4091245$ترسل محكمة الاستئناف صور ملفات القضايا والأحكام الصادرة فيها إلى القضاة المعينين ،لنظر الاستئناف قبل ميعاد الجلسة بوقت كاف.$b4091245$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins409;

WITH ins410 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 410, 0, $h4101249$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4101249$, $t4101250$مادة (410)$t4101250$, $b4101248$تسمع المحكمة أقوال المستأنف ،والأوجه التي يستند إليها في اسـتئنافه ،وأوجـه دفاعه ودفوعه ،كما تسمع باقي الخصوم ،على أن يكون المتهم آخر من يتكلم.$b4101248$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins410;

WITH ins411 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 411, 0, $h4111252$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4111252$, $t4111253$مادة (411)$t4111253$, $b4111251$إذا كان الاستئناف مرفوعا من المحكوم عليه ،وتخلف هو أو وكيله الخاص عـن الحضور في الجلسة المحددة لنظر الاستئناف ،أو في أي جلسة تالية ،تؤجل المحكمـة نظر الاستئناف لمرة واحدة ،وإن تخلف هو أو وكيله الخاص عن الحضور تنـدب لـه المحكمة محاميا للدفاع عنه ،وتفصل في الاستئناف بحكم لا يقبـل إعـادة المحاكمـة، ويسري في شأنه حكم المادة  ٣٦٦من هذا القانون.$b4111251$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins411;

WITH ins412 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 412, 0, $h4121255$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4121255$, $t4121256$مادة (412)$t4121256$, $b4121254$إذا كان الحكم صادرا حضوريا بعقوبة الإعدام ،ولم يجر استئنافه خـلال الميعـاد المقرر قانونا ،وجب على النيابة العامة اتباع حكم المـادة  ٤٦مـن قـانون حـالات وإجراءات الطعن أمام محكمة النقض الصادر بالقانون رقم  ٥٧لسنة .١٩٥٩$b4121254$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins412;

WITH ins413 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 413, 0, $h4131258$الكتاب الثالث طرق الطعن في الأحكام - الباب الثانى الاستئناف - الفصل الثاني استئناف أحكام محاكم الجنايات$h4131258$, $t4131259$مادة (413)$t4131259$, $b4131257$لا يترتب على استئناف الحكم الصادر من محكمة جنايـات أول درجـة وقـف تنفيذ الحكم ،إلا إذا رأت محكمة الجنايات المستأنفة وقف التنفيـذ أو إذا كـان الحكـم صادرا بالإعدام.$b4131257$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins413;

WITH ins414 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 414, 0, $h4141261$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4141261$, $t4141262$مادة (414)$t4141262$, $b4141260$يجوز طلب إعادة النظر في الأحكام الباتة الصادرة بالعقوبة في مـواد الجنايـات والجنح في الأحوال الآتية: - ١إذا حكم على المتهم في جريمة قتل ،ثم وجد المدعى قتله حيا.
- ٢إذا صدر حكم على شخص من أجل واقعة ،ثم صدر حكم على شخص آخر من أجل الواقعة عينها ،وكان بين الحكمين تناقض بحيث يـستنتج منـه بـراءة أحـد المحكوم عليهما.
- ٣إذا حكم على أحد الشهود أو الخبراء بالعقوبة لشهادة الزور وفق ًـا لأحكـام الباب السادس من الكتاب الثالث من قانون العقوبات ،أو إذا حكم بتزوير ورقة قـدمت أثناء نظر الدعوى ،وكان للشهادة أو تقرير الخبير أو الورقة تأثير في الحكم.
- ٤إذا كان الحكم مبنيا على حكم صادر من محكمة مدنية أو من إحدى محـاكم الأسرة وألغي هذا الحكم.
- ٥إذا حدثت أو ظهرت بعد الحكم وقائع ،أو إذا قدمت أوراق لم تكن معلومـة وقت المحاكمة ،وكان من شأن هذه الوقائع أو الأوراق ثبوت براءة المحكوم عليه.$b4141260$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins414;

WITH ins415 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 415, 0, $h4151264$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4151264$, $t4151265$مادة (415)$t4151265$, $b4151263$في الحالات المنصوص عليها في البنود ) (٤ ،٣ ،٢ ،١من المادة  ٤١٤من هـذا القانون ،يكون لكل من النائب العام والمحكوم عليه أو وكيله الخـاص أو مـن يمثلـه قانون ًا إذا كان عديم الأهلية أو مفقودا أو أقاربه أو زوجـه بعـد موتـه حـق طلـب إعادة النظر.
وإذا كان الطالب غير النيابة العامة فعليه تقديم الطلب إلى النائب العام بعريـضة يبين فيها الحكم المطلوب إعادة النظر فيه ،والوجـه الـذي يـستند عليـه ،ويـشفعه بالمستندات المؤيدة له.
ويرفع النائب العام الطلب سواء كان مقدما منه أو مـن غيـره مـع التحقيقـات التي يكون قد رأى إجراءها إلى محكمة النقض بتقرير يبين فيه رأيه والأسـباب التـي يستند عليها.
ويجب أن يرفع الطلب إلى المحكمة في الثلاثة الأشهر التالية لتقديمه.$b4151263$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins415;

WITH ins416 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 416, 0, $h4161267$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4161267$, $t4161268$مادة (416)$t4161268$, $b4161266$في الحالة المنصوص عليها في البند ) (٥من المادة  ٤١٤من هذا القانون يكـون حق طلب إعادة النظر للنائب العام وحده سواء من تلقاء نفسه أو بناء على طلـب ذوى الشأن ،وإذا رأى له محلا ً يرفعه مع التحقيقات التي يكون قد رأى لزومها إلـى لجنـة مشكلة من أحد قضاة محكمة النقض واثنين من قضاة محكمة الاستئناف تعين كلا ً منهم الجمعية العامة بالمحكمة التابع لها ،ويجب أن يبين في الطلب الواقعة أو الورقة التـي يستند عليها.
وتفصل اللجنة في الطلب بعد الاطلاع على الأوراق واسـتيفاء مـا تـراه مـن التحقيق ،وتأمر بإحالته إلى محكمة النقض إذا رأت قبوله.
ولا يقبل الطعن بأي وجه في القرار الصادر من النائـب العـام أو فـي الأمـر الصادر من اللجنة المشار إليها بقبول الطلب أو عدم قبوله.$b4161266$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins416;

WITH ins417 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 417, 0, $h4171270$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4171270$, $t4171271$مادة (417)$t4171271$, $b4171269$لا يقبل النائب العام طلب إعادة النظر من المتهم أو من يحل محله فـي الحـالات المنصوص عليها في البنود ) (٤ ،٣ ،٢ ،١من المادة  ٤١٤مـن هـذا القـانون إلا إذا أودع الطالب خزانة محكمة النقض كفالة مقدارها خمسة آلاف جنيه ،تخصص للوفـاء بالغرامة المنصوص عليها بالمادة  ٤٢٢من هذا القانون ،ما لم يكن قد أعفي من إيداعه بقرار من لجنة المساعدة القضائية بمحكمة النقض.$b4171269$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins417;

WITH ins418 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 418, 0, $h4181273$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4181273$, $t4181274$مادة (418)$t4181274$, $b4181272$تعلن النيابة العامة الخصوم بالجلسة المحددة لنظر الطلب أمام محكمة النقض قبل انعقادها بثمانية أيام كاملة على الأقل.$b4181272$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins418;

WITH ins419 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 419, 0, $h4191276$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4191276$, $t4191277$مادة (419)$t4191277$, $b4191275$تفصل محكمة النقض في الطلب بعد سماع أقوال النيابة العامة والخصوم ،وبعـد إجراء ما تراه لازما من التحقيق بنفسها أو بواسطة من تندبه لذلك ،فـإذا رأت قبـول الطلب تحكم بإلغاء الحكم وتقضي ببراءة المتهم إذا كانت البراءة ظـاهرة ،وإلا ت ُحِـلْ الدعوى إلى المحكمة التي أصدرت الحكم مشكلة مـن قـضاة آخـرين للفـصل فـي موضوعها ما لم تر هي إجراء ذلك بنفسها.
ومع ذلك إذا كان من غير الممكن إعادة المحاكمة كما في حالـة وفـاة المحكـوم عليه أو المصاب باضطراب نفسي أو عقلي أو انقضاء الدعوى الجنائية بمضي المـدة، تنظر محكمة النقض موضوع الدعوى ،ولا تلغي من الحكم إلا ما يظهر لها خطؤه.$b4191275$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins419;

WITH ins420 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 420, 0, $h4201279$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4201279$, $t4201280$مادة (420)$t4201280$, $b4201278$إذا مات المحكوم عليه ولم يكن الطلب مقدما من أحد الأقارب أو الـزوج ،تنظـر المحكمة الدعوى في مواجهة من تحدده للدفاع عن سمعته ،ويكون بقدر الإمكـان مـن الأقارب ،وفي هذه الحالة تحكم عند الاقتضاء بمحو ما يمس هذه السمعة.$b4201278$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins420;

WITH ins421 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 421, 0, $h4211282$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4211282$, $t4211283$مادة (421)$t4211283$, $b4211281$لا يترتب على طلب إعادة النظر إيقاف تنفيذ الحكم إلا إذا كان صادرا بالإعدام.$b4211281$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins421;

WITH ins422 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 422, 0, $h4221285$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4221285$, $t4221286$مادة (422)$t4221286$, $b4221284$يحكم على طالب إعادة النظر إذا كان غير النائب العام في الحالات المنـصوص عليها في البنود ) (٤ ،٣ ،٢ ،١من المادة  ٤١٤من هذا القانون بغرامة لا تزيـد علـى خمسة آلاف جنيه إذا لم يقبل طلبه.$b4221284$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins422;

WITH ins423 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 423, 0, $h4231288$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4231288$, $t4231289$مادة (423)$t4231289$, $b4231287$كل حكم صادر بالبراءة بناء على إعادة النظر يجب نشره على نفقة الدولـة فـي الجريدة الرسمية بناء على طلب النيابة العامة وفي جريدتين يعينهما صاحب الشأن.$b4231287$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins423;

WITH ins424 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 424, 0, $h4241291$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4241291$, $t4241292$مادة (424)$t4241292$, $b4241290$يترتب على إلغاء الحكم بناء على إعادة النظـر سـقوط الحكـم بالتعويـضات، ووجوب رد ما نفذ به منها دون إخلال بقواعد سقوط الحق بمضي المدة.$b4241290$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins424;

WITH ins425 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 425, 0, $h4251294$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4251294$, $t4251295$مادة (425)$t4251295$, $b4251293$إذا رفض طلب إعادة النظر ،فلا يجوز تجديده بنـاء علـى ذات الوقـائع التـي بني عليها.$b4251293$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins425;

WITH ins426 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 426, 0, $h4261297$الكتاب الثالث طرق الطعن في الأحكام - الباب الثالث إعادة النظر$h4261297$, $t4261298$مادة (426)$t4261298$, $b4261296$الأحكام التي تصدر في موضوع الدعوى بناء على إعادة النظر من غير محكمـة النقض ،يجوز الطعن فيها بجميع الطرق المقررة في القانون.
ولا يجوز أن يقضى على المتهم بأشد من العقوبة السابق الحكم بها عليه.$b4261296$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins426;

WITH ins427 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 427, 0, $h4271300$الكتاب الثالث طرق الطعن في الأحكام - الباب الرابع قوة الأحكام الباتة$h4271300$, $t4271301$مادة (427)$t4271301$, $b4271299$تنقضي الدعوى الجنائية بالنسبة للمتهم المرفوعة عليه والوقائع المسندة فيها إليـه بصدور حكم بات فيها بالبراءة أو بالإدانة.
وإذا صدر حكم في موضوع الدعوى الجنائية فلا يجوز إعادة نظرها إلا بـالطعن في هذا الحكم بالطرق المقررة في القانون.$b4271299$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins427;

WITH ins428 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 428, 0, $h4281303$الكتاب الثالث طرق الطعن في الأحكام - الباب الرابع قوة الأحكام الباتة$h4281303$, $t4281304$مادة (428)$t4281304$, $b4281302$لا يجوز الرجوع إلى الدعوى الجنائية بعد الحكم فيها بحكم بات بناء على ظهـور أدلة جديدة أو ظروف جديدة أو بناء على تغيير الوصف القانوني للجريمة.$b4281302$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins428;

WITH ins429 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 429, 0, $h4291306$الكتاب الثالث طرق الطعن في الأحكام - الباب الرابع قوة الأحكام الباتة$h4291306$, $t4291307$مادة (429)$t4291307$, $b4291305$يكون للحكم الجنائي الصادر من المحكمة الجنائية في موضوع الدعوى الجنائيـة بالبراءة أو بالإدانة قوة الشيء المحكوم به أمام المحاكم المدنية في الدعاوى التـي لـم يكن قد فصل فيها نهائيا فيما يتعلق بوقوع الجريمة وبوصفها القـانوني ونـسبتها إلـى فاعلها ،ويكون للحكم بالبراءة هذه القوة سواء بني على انتفاء التهمة أو على عدم كفاية الأدلة ،ولا تكون له هذه القوة إذا كان مبنيا على أن الفعل لا يعاقب عليه القانون.$b4291305$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins429;

WITH ins430 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 430, 0, $h4301309$الكتاب الثالث طرق الطعن في الأحكام - الباب الرابع قوة الأحكام الباتة$h4301309$, $t4301310$مادة (430)$t4301310$, $b4301308$لا تكون للأحكام الصادرة من المحاكم المدنية قوة الشيء المحكوم به أمام المحاكم الجنائية فيما يتعلق بوقوع الجريمة ووصفها القانوني ونسبتها إلى فاعلها.$b4301308$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins430;

WITH ins431 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 431, 0, $h4311312$الكتاب الثالث طرق الطعن في الأحكام - الباب الرابع قوة الأحكام الباتة$h4311312$, $t4311313$مادة (431)$t4311313$, $b4311311$تكون للأحكام الصادرة من محاكم الأسرة في حدود اختصاصها قوة الشيء المحكـوم به أمام المحاكم الجنائية في المسائل التي يتوقف عليها الفصل في الدعوى الجنائية.$b4311311$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins431;

WITH ins432 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 432, 0, $h4321315$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4321315$, $t4321316$مادة (432)$t4321316$, $b4321314$لا يجوز توقيع العقوبات المقررة بالقانون لأية جريمة إلا بمقتضى حكـم صـادر من محكمة مختصة بذلك.$b4321314$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins432;

WITH ins433 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 433, 0, $h4331318$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4331318$, $t4331319$مادة (433)$t4331319$, $b4331317$لا تنفذ الأحكام الصادرة من المحاكم الجنائية إلا متى صارت نهائية ،ما لم يـنص القانون على خلاف ذلك.$b4331317$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins433;

WITH ins434 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 434, 0, $h4341321$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4341321$, $t4341322$مادة (434)$t4341322$, $b4341320$يكون تنفيذ الأحكام الصادرة في الدعوى الجنائية بناء على طلب النيابـة العامـة وفق ًا لما هو مقرر بهذا القانون.
والأحكام الصادرة في الدعوى المدنية يكون تنفيذها بناء علـى طلـب المـدعي بالحقوق المدنية وفق ًا لما هو مقرر بقانون المرافعات في المواد المدنية والتجارية.$b4341320$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins434;

WITH ins435 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 435, 0, $h4351324$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4351324$, $t4351325$مادة (435)$t4351325$, $b4351323$تبادر النيابة العامة إلى تنفيذ الأحكام الواجبة التنفيذ الصادرة في الدعوى الجنائية، ولها عند اللزوم أن تستعين بالقوة الجبرية.$b4351323$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins435;

WITH ins436 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 436, 0, $h4361327$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4361327$, $t4361328$مادة (436)$t4361328$, $b4361326$الأحكام الصادرة بالغرامة والمصاريف تكون واجبة التنفيذ فورا ،ولو مع حصول استئنافها ،وكذلك الأحكام الصادرة بالحبس في سرقة أو على متهم عائد ،أو لـيس لـه محل إقامة ثابت بمصر ،وكذلك الحال في الأحوال الأخرى إذا كـان الحكـم صـادرا بالحبس ،إلا إذا قدم المتهم كفالة بأنه إذا لم يستأنف الحكم لا يفر من تنفيذه عند انقضاء مواعيد الاستئناف ،وأنه إذا استأنفه يحضر في الجلسة ولا يفر من تنفيذ الحكـم الـذي يصدر ،وكل حكم صادر بعقوبة الحبس في هذه الأحوال يعين فيه المبلغ الـذي يجـب تقديم الكفالة به.
وإذا كان المتهم محبوسا حبسا احتياطيا يجوز للمحكمة أن تـأمر بتنفيـذ الحكـم تنفيذ ًا مؤقت ًا.
وللمحكمة عند الحكم بالتعويضات للمدعي بـالحقوق المدنيـة أن تـأمر بالتنفيـذ المؤقت ،ولو مع حصول الاستئناف على حسب المقرر بالمادة  ٤٤٠من هذا القانون.$b4361326$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins436;

WITH ins437 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 437, 0, $h4371330$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4371330$, $t4371331$مادة (437)$t4371331$, $b4371329$تنفذ العقوبات التبعية المقيدة للحرية المحكوم بها مع عقوبـة الحـبس إذا نفـذت عقوبة الحبس ،طبق ًا للمادة  ٤٣٦من هذا القانون.$b4371329$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins437;

WITH ins438 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 438, 0, $h4381333$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4381333$, $t4381334$مادة (438)$t4381334$, $b4381332$يفرج في الحال عن المتهم المحبوس احتياطيا ،إذا كان الحكم صـادرا بـالبراءة، أو بعقوبة أخرى لا يقتضي تنفيذها الحبس ،أو إذا أمر في الحكم بوقف تنفيذ العقوبـة، أو إذا كان المتهم قد قضى في الحبس الاحتياطي مدة العقوبة المحكوم بها.$b4381332$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins438;

WITH ins439 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 439, 0, $h4391336$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4391336$, $t4391337$مادة (439)$t4391337$, $b4391335$في غير الأحوال المنصوص عليها في هذا الباب ،يوقف التنفيـذ أثنـاء الميعـاد المقرر للاستئناف بالمادة  ٣٨٩من هذا القانون وأثناء نظر الاستئناف الذي يرفـع فـي المدة المذكورة.$b4391335$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins439;

WITH ins440 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 440, 0, $h4401339$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4401339$, $t4401340$مادة (440)$t4401340$, $b4401338$يجوز تنفيذ الحكم الغيابي بالعقوبة إذا لم يعارض فيه المحكوم عليه فـي الميعـاد المبين بالفقرة الأولى من المادة  ٣٨٠من هذا القانون.
وللمحكمة عند الحكم بالتضمينات للمدعي بالحقوق المدنية أن تأمر بالتنفيذ المؤقت مع تقديم كفالة ولو مع حصول المعارضة أو الاستئناف بالنسبة لكل المبلغ المحكوم بـه أو بعضه ،ولها أن تعفي المحكوم له من الكفالة.$b4401338$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins440;

WITH ins441 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 441, 0, $h4411342$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4411342$, $t4411343$مادة (441)$t4411343$, $b4411341$يجوز للمحكمة عند الحكم غيابيا بالحبس مدة سنة فأكثر ،إذا لم يكن للمتهم محـل إقامة معين بمصر ،أو إذا كان صادرا ضده أمر بالحبس الاحتيـاطي ،أن تـأمر بنـاء على طلب النيابة العامة بالقبض عليه وحبسه.
ويحبس المتهم عند القبض عليه تنفيذ ًا لهذا الأمر حتى يحكم في المعارضة التـي يرفعها ،أو ينقضي الميعاد المقرر لها ،ولا يجوز بأية حال أن يبقى في الحـبس مـدة تزيد على المدة المحكوم بها ،وذلك كله ما لم تر المحكمة المرفوعة إليهـا المعارضـة الإفراج عنه قبل الفصل فيها.$b4411341$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins441;

WITH ins442 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 442, 0, $h4421345$الكتاب الرابع التنفيذ - الباب الأول الأحكام الواجبة التنفيذ$h4421345$, $t4421346$مادة (442)$t4421346$, $b4421344$مع مراعاة أحكام المادتين  ٣٦مكررا ٤١ ،من القـانون رقـم  ٥٧لـسنة ١٩٥٩ المشار إليه ،لا يترتب على الطعن بطريق النقض إيقاف التنفيـذ إلا إذا كـان الحكـم صادرا بالإعدام.$b4421344$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins442;

WITH ins443 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 443, 0, $h4431348$الكتاب الرابع التنفيذ - الباب الثاني تنفيذ عقوبة الإعدام$h4431348$, $t4431349$مادة (443)$t4431349$, $b4431347$متى صار الحكم بالإعدام بات ًا ،وجب على وزير العدل رفع أوراق الدعوى فـورا إلى رئيس الجمهورية.
وينفذ الحكم إذا لم يصدر الأمر بالعفو أو بإبدال العقوبة خلال أربعة عشر يوما.$b4431347$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins443;

WITH ins444 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 444, 0, $h4441351$الكتاب الرابع التنفيذ - الباب الثاني تنفيذ عقوبة الإعدام$h4441351$, $t4441352$مادة (444)$t4441352$, $b4441350$يودع المحكوم عليه بالإعدام في مركز الإصلاح والتأهيل بناء على أمر تـصدره النيابة العامة على النموذج الذي يقرره وزير العدل إلى أن ينفذ فيه الحكم.$b4441350$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins444;

WITH ins445 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 445, 0, $h4451354$الكتاب الرابع التنفيذ - الباب الثاني تنفيذ عقوبة الإعدام$h4451354$, $t4451355$مادة (445)$t4451355$, $b4451353$يجوز لأقارب المحكوم عليه بالإعدام أن يقابلوه في اليـوم الـسابق علـى اليـوم المعين لتنفيذ الحكم ،على أن يكون ذلك بعيدا عن محل التنفيـذ ،وعلـى إدارة مركـز الإصلاح إخطارهم بذلك.
وإذا كانت ديانة المحكوم عليه تفرض عليه الاعتراف أو غيـره مـن الفـروض الدينية قبل الموت ،وجب إجراء التـسهيلات اللازمـة لتمكـين أحـد رجـال الـدين من مقابلته.$b4451353$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins445;

WITH ins446 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 446, 0, $h4461357$الكتاب الرابع التنفيذ - الباب الثاني تنفيذ عقوبة الإعدام$h4461357$, $t4461358$مادة (446)$t4461358$, $b4461356$تنفذ عقوبة الإعدام داخل مركز الإصلاح والتأهيل ،أو في مكان آخـر مـستور، بناء على طلب كتابي من النائب العام إلى مساعد الوزير لقطاع الحمايـة المجتمعيـة يبين فيه استيفاء الإجراءات المنصوص عليها في المادة  ٤٤٣من هذا القانون.
ويجب على إدارة مراكز الإصلاح إخطار وزارة الداخلية والنائب العـام بـاليوم المحدد للتنفيذ وساعته.$b4461356$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins446;

WITH ins447 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 447, 0, $h4471360$الكتاب الرابع التنفيذ - الباب الثاني تنفيذ عقوبة الإعدام$h4471360$, $t4471361$مادة (447)$t4471361$, $b4471359$يجب أن يكون تنفيذ عقوبة الإعدام بحضور أحد أعضاء النيابة العامـة ومنـدوب من قطاع الحماية المجتمعية ومندوب من وزارة الداخليـة ومـدير مركـز الإصـلاح والتأهيل وطبيب مركز الإصلاح وطبيب آخر تندبه النيابة العامة ،ولا يجوز لغير مـن ذكروا أن يحضروا التنفيذ إلا بإذن خاص من النيابة العامة ،ويجـب دائمـا أن يـؤذن للمدافع عن المحكوم عليه بالحضور.
ويجب أن يتلى من الحكم الصادر بالإعدام منطوقه والتهمة المحكوم مـن أجلهـا على المحكوم عليه ،وذلك في مكان التنفيذ بمسمع من الحاضرين ،وإذا رغب المحكوم عليه في إبداء أقوال حرر عضو النيابة العامة محضرا بها.
وعند تمام التنفيذ يحرر عضو النيابة العامة محضرا بذلك ،ويثبـت فيـه شـهادة الطبيب بالوفاة وساعة حصولها.$b4471359$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins447;

WITH ins448 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 448, 0, $h4481363$الكتاب الرابع التنفيذ - الباب الثاني تنفيذ عقوبة الإعدام$h4481363$, $t4481364$مادة (448)$t4481364$, $b4481362$لا يجوز تنفيذ عقوبة الإعدام في أيام الأعياد الرسمية أو الأعياد الخاصـة بديانـة المحكوم عليه.$b4481362$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins448;

WITH ins449 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 449, 0, $h4491366$الكتاب الرابع التنفيذ - الباب الثاني تنفيذ عقوبة الإعدام$h4491366$, $t4491367$مادة (449)$t4491367$, $b4491365$يوقف تنفيذ عقوبة الإعدام على المحكوم عليها الحبلـى إلـى مـا بعـد سـنتين من وضعها.$b4491365$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins449;

WITH ins450 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 450, 0, $h4501369$الكتاب الرابع التنفيذ - الباب الثاني تنفيذ عقوبة الإعدام$h4501369$, $t4501370$مادة (450)$t4501370$, $b4501368$تسلم جثة المحكوم عليه بالإعدام إلى أهله إذا طلبوا ذلك ووافقـت جهـة الإدارة، ويجب أن يكون الدفن بغير احتفال ،فإذا لم يتقدم أحد مـنهم لاسـتلامها خـلال أربـع وعشرين ساعة أودعت أقرب مكان إلى مركز الإصلاح معـد لحفـظ الجثـث ،فـإذا لم يتقدم أحد منهم لتسلمها خلال سبعة أيام من تـاريخ الإيـداع سـلمت إلـى إحـدى الجهات الجامعية.$b4501368$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins450;

WITH ins451 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 451, 0, $h4511372$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4511372$, $t4511373$مادة (451)$t4511373$, $b4511371$تنفذ الأحكام الصادرة بالعقوبات المقيدة للحرية بمراكز الإصلاح والتأهيل المعـدة لذلك بمقتضى أمر يصدر من النيابة العامة على النموذج الذي يقرره وزير العدل.$b4511371$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins451;

WITH ins452 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 452, 0, $h4521375$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4521375$, $t4521376$مادة (452)$t4521376$, $b4521374$يجوز لكل محكوم عليه بالحبس البسيط لمدة لا تتجاوز ستة أشهر أن يطلب مـن النيابة العامة بدلا ً من تنفيذ عقوبة الحبس عليه إلزامه بعمل للمنفعة العامة خارج مركز الإصلاح والتأهيل وفقا لما هو مقرر بالباب الخامس من هذا الكتاب ،وذلك ما لم ينص الحكم على حرمانه من ذلك.$b4521374$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins452;

WITH ins453 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 453, 0, $h4531378$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4531378$, $t4531379$مادة (453)$t4531379$, $b4531377$يحسب اليوم الذي يبدأ فيه التنفيذ من مدة العقوبة ،ويفرج عن المحكوم عليه فـي اليوم التالي ليوم انتهاء العقوبة في الوقت المحدد للإفراج عن النزلاء.$b4531377$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins453;

WITH ins454 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 454, 0, $h4541381$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4541381$, $t4541382$مادة (454)$t4541382$, $b4541380$إذا كانت مدة عقوبة الحبس المحكوم بها على المتهم أربعا وعشرين ساعة ينتهـي تنفيذها في اليوم التالي للقبض عليه في الوقت المحدد للإفراج عن النزلاء.$b4541380$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins454;

WITH ins455 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 455, 0, $h4551384$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4551384$, $t4551385$مادة (455)$t4551385$, $b4551383$تبدأ مدة العقوبة المقيدة للحرية من يوم القبض على المحكوم عليه بناء على الحكم الواجب التنفيذ ،مع مراعاة نقصها بمقدار مدة الحبس الاحتياطي ومدة القبض ،والمـدد الأخرى المنصوص قانون ًا على خصمها.$b4551383$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins455;

WITH ins456 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 456, 0, $h4561387$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4561387$, $t4561388$مادة (456)$t4561388$, $b4561386$إذا حكم ببراءة المتهم من الجريمة التي حبس احتياطيا من أجلها ،وجـب خـصم مدة الحبس من المدة المحكوم بها في أية جريمة أخرى يكون قد ارتكبها أو حقق معـه فيها في أثناء الحبس الاحتياطي.$b4561386$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins456;

WITH ins457 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 457, 0, $h4571390$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4571390$, $t4571391$مادة (457)$t4571391$, $b4571389$يكون استنزال مدة الحبس الاحتياطي ومدة القبض عند تعـدد العقوبـات المقيـدة للحرية المحكوم بها على المتهم من العقوبة الأخف أولا ً.$b4571389$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins457;

WITH ins458 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 458, 0, $h4581393$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4581393$, $t4581394$مادة (458)$t4581394$, $b4581392$إذا كانت المحكوم عليها بعقوبة مقيدة للحرية حبلى في الشهر السادس من الحمل، جاز تأجيل التنفيذ عليها حتى تضع حملها وتمضي مدة سنتين على الوضع.
فإذا رئي التنفيذ على المحكوم عليها أو ظهر في أثناء التنفيذ أنها حبلـى ،وجبـت معاملتها في مركز الإصلاح والتأهيل معاملة المحبوسـين احتياطيـا إلـى أن تـضع مولودها وتمضي أربعين يوما على الوضع.$b4581392$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins458;

WITH ins459 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 459, 0, $h4591396$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4591396$, $t4591397$مادة (459)$t4591397$, $b4591395$إذا كان المحكوم عليه بعقوبة مقيدة للحرية مصا با بمرض يهدد بذاتـه أو بـسبب التنفيذ حياته بالخطر ،جاز تأجيل تنفيذ العقوبة عليه.$b4591395$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins459;

WITH ins460 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 460, 0, $h4601399$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4601399$, $t4601400$مادة (460)$t4601400$, $b4601398$مع عدم الإخلال بحكم المادة  ٣٤٥من هذا القانون ،إذا أصيب المحكوم عليه بعقوبة مقيدة للحرية قبل إيداعه وقبوله بمركز الإصلاح والتأهيل أو أثناء تنفيذ العقوبة باضطراب نفسي أو عقلي تندب النيابة العامة لجنة ثلاثية من الأطباء النفسيين المقيدين بسجلات المجلس القومي للصحة النفسية لإعداد تقرير طبي يتضمن تقييما لحالته النفسية والمرضية والخطة العلاجية المقترحة حال ثبوت إصابته باضطراب نفسي أو عقلي ،وتستنزل مدة الإيداع لإجراء التقييم الطبي من مدة العقوبة المقضي بها ،ويجب تأجيل تنفيذ العقوبة مؤقت ًا حتى يبرأ ،مع توقيع الكشف الطبي النفسي عليه كل ستة أشهر لبيان إذا ما كان قد تماثل للشفاء من عدمه ،ويجوز للنيابة العامة أن تأمر بإيداعه لتلقي العلاج في إحدى منشآت الصحة النفسية الحكومية التي يصدر بتحديدها قرار من المجلس القومي للصحة النفسية ،وفي هذه الحالة تستنزل مدة الإيداع التي يقضيها المحكوم عليه من مدة العقوبة المحكوم بها ،وابتداء من التاريخ المحدد للانتهاء من تنفيذ العقوبة يعامل المحكوم عليه المودع باعتباره مريضا وفق ًا لأحكام الدخول الإلزامي المنصوص عليها في قانون رعاية المريض النفسي المشار إليه.$b4601398$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins460;

WITH ins461 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 461, 0, $h4611402$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4611402$, $t4611403$مادة (461)$t4611403$, $b4611401$إذا كان محكوما على رجل وزوجته بالحبس لمدة لا تزيد على سـنة ولـو عـن جرائم مختلفة ولم يكونا مسجونين من قبل ،جاز تأجيل تنفيذ العقوبة على أحدهما حتـى يفرج عن الآخر ،وذلك إذا كانا يكفلان صغيرا لم يبلغ خمس عشرة سنة ،وكـان لهمـا محل إقامة معروف بمصر.$b4611401$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins461;

WITH ins462 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 462, 0, $h4621405$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4621405$, $t4621406$مادة (462)$t4621406$, $b4621404$للنيابة العامة في الأحوال التي يجوز فيها تأجيل تنفيذ العقوبة على المحكوم عليـه أن تطلب منه تقديم كفالة بأنه لا يفر من التنفيذ عند زوال سبب التأجيل ،ويقـدر مبلـغ الكفالة في الأمر الصادر بالتأجيل.
ولها أيضا أن تشترط لتأجيل التنفيذ ما تراه من الاحتياطات الكفيلة بمنع المحكـوم عليه من الهرب.$b4621404$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins462;

WITH ins463 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 463, 0, $h4631408$الكتاب الرابع التنفيذ - الباب الثالث تنفيذ العقوبات المقيدة للحرية$h4631408$, $t4631409$مادة (463)$t4631409$, $b4631407$لا يجوز في غير الأحوال المبينة في القانون إخلاء سبيل النزيل المحكـوم عليـه قبل أن يستوفي مدة العقوبة.$b4631407$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins463;

WITH ins464 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 464, 0, $h4641411$الكتاب الرابع التنفيذ - الباب الرابع تنفيذ المبالغ المحكوم بها$h4641411$, $t4641412$مادة (464)$t4641412$, $b4641410$يجب على النيابة العامة عند تسوية المبالغ المستحقة للدولة عن الغرامة وما يجب رده والتعويضات والمصاريف ،وقبل التنفيذ بها ،إعلان المحكوم عليـه بمقـدار هـذه المبالغ ،ما لم تكن مقدرة في الحكم.$b4641410$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins464;

WITH ins465 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 465, 0, $h4651414$الكتاب الرابع التنفيذ - الباب الرابع تنفيذ المبالغ المحكوم بها$h4651414$, $t4651415$مادة (465)$t4651415$, $b4651413$يجوز تحصيل المبالغ المستحقة للدولة بالطرق المقررة فـي قـانون المرافعـات المدنية والتجارية أو بالطرق الإدارية المقررة لتحصيل الأموال العامة.$b4651413$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins465;

WITH ins466 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 466, 0, $h4661417$الكتاب الرابع التنفيذ - الباب الرابع تنفيذ المبالغ المحكوم بها$h4661417$, $t4661418$مادة (466)$t4661418$, $b4661416$إذا لم يدفع المتهم المبالغ المستحقة للدولة ،تصدر النيابة العامة أمرا بالإلزام بعمل للمنفعة العامة وفق ًا لأحكام الباب الخامس من هذا الكتاب.$b4661416$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins466;

WITH ins467 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 467, 0, $h4671420$الكتاب الرابع التنفيذ - الباب الرابع تنفيذ المبالغ المحكوم بها$h4671420$, $t4671421$مادة (467)$t4671421$, $b4671419$إذا حكم بالغرامة وما يجب رده والتعويضات والمصاريف معا ،وكانـت أمـوال المحكوم عليه لا تفي بذلك كله ،وجب توزيع ما يتحصل منها بين ذوي الحقوق علـى حسب الترتيب الآتي: )أولا ً( المصاريف المستحقة للدولة.
)ثانيا( المبالغ المستحقة للمدعي المدني.
)ثالث ًا( الغرامة وما تستحقه الحكومة من الرد والتعويض.$b4671419$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins467;

WITH ins468 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 468, 0, $h4681423$الكتاب الرابع التنفيذ - الباب الرابع تنفيذ المبالغ المحكوم بها$h4681423$, $t4681424$مادة (468)$t4681424$, $b4681422$إذا حبس شخص احتياطيا ،ولم يحكم عليه إلا بغرامة ،وجب أن يـنقص منهـا عنـد التنفيذ خمسون جنيها عن كل يوم من أيام الحبس الاحتيـاطي .وإذا حكـم عليـه بـالحبس وبالغرامة معا ،وكانت المدة التي قضاها في الحبس الاحتياطي تزيد علـى مـدة الحـبس المحكوم به ،وجب أن ينقص من الغرامة المبلغ المذكور عن كل يوم من أيام هذه الزيادة.$b4681422$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins468;

WITH ins469 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 469, 0, $h4691426$الكتاب الرابع التنفيذ - الباب الرابع تنفيذ المبالغ المحكوم بها$h4691426$, $t4691427$مادة (469)$t4691427$, $b4691425$يجوز لعضو النيابة العامة من درجة رئيس نيابة على الأقل في الجهة التي يجري التنفيذ فيها أن يمنح المتهم في الأحوال الاستثنائية ،بنا ء على طلبه ،أجلا ً لـدفع المبـالغ المستحقة للدولة أو أن يأذن له بدفعها على أقساط ،بشرط ألا تزيد المـدة علـى اثنـي عشر شهرا ،ولا يجوز الطعن في الأمر الذي يصدر بقبول الطلب أو رفضه.
وإذا تأخر المتهم عن دفع قسط حلت باقي الأقساط ،ويجوز لعضو النيابة العامـة الرجوع في الأمر الصادر منه إذا وجد ما يدعو لذلك.$b4691425$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins469;

WITH ins470 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 470, 0, $h4701429$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4701429$, $t4701430$مادة (470)$t4701430$, $b4701428$يجوز إلزام المحكوم عليه بعمل للمنفعة العامة لتحـصيل المبـالغ الناشـئة عـن الجريمة المقضي بها للدولة ضد مرتكب الجريمة ،وذلك بتشغيله فـي عمـل للمنفعـة العامة باعتبار يوم واحد عن كل خمسين جنيها أو أقل.
ولا يجوز في مواد المخالفات أن تزيد مدة هذا العمل على سبعة أيـام للغرامـة، وعلى سبعة أيام للمصاريف وما يجب رده والتعويضات.
وفي مواد الجنح والجنايات لا يجوز أن تزيد مدة هذا العمل علـى ثلاثـة أشـهر للغرامة ،وثلاثة أشهر للمصاريف وما يجب رده والتعويضات.$b4701428$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins470;

WITH ins471 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 471, 0, $h4711432$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4711432$, $t4711433$مادة (471)$t4711433$, $b4711431$لا يجوز التنفيذ بطريق الإلزام بعمل للمنفعة العامة على المحكوم عليهم الذين لـم يبلغوا خمس عشرة سنة كاملة وقت ارتكاب الجريمة ،وكذلك المحكوم علـيهم بعقوبـة مع وقف التنفيذ.$b4711431$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins471;

WITH ins472 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 472, 0, $h4721435$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4721435$, $t4721436$مادة (472)$t4721436$, $b4721434$تسري أحكام المواد  ٤٦١ ،٤٦٠ ،٤٥٩ ،٤٥٨من هـذا القـانون علـى التنفيـذ بطريق الإلزام بعمل للمنفعة العامة.$b4721434$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins472;

WITH ins473 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 473, 0, $h4731438$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4731438$, $t4731439$مادة (473)$t4731439$, $b4731437$يكون التنفيذ باعتبار مجموع المبالغ المحكوم بها إذا تعددت الأحكام وكانت كلهـا صادرة في مخالفات أو في جنح أو في جنايات ،وفي هذه الحالة لا يجوز أن تزيد مـدة العمل للمنفعة العامة على ضعف الحد الأقصى في الجنح والجنايات ولا علـى واحـد وعشرين يوما في المخالفات.
أما إذا كانت الجرائم مختلفة النوع فيراعى الحد الأقصى المقرر لكل منها.
وفي جميع الأحوال لا يجوز أن تزيد مدة العمل للمنفعة العامة على سـتة أشـهر للغرامات ،وستة أشهر للمصاريف وما يجب رده والتعويضات.$b4731437$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins473;

WITH ins474 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 474, 0, $h4741441$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4741441$, $t4741442$مادة (474)$t4741442$, $b4741440$إذا كانت الجرائم المحكوم فيها مختلفة ،ت ُستنزل المبالغ المدفوعة أو التي تحصلت بطريق التنفيذ على ممتلكات المحكوم عليه أولا ً من المبالغ المحكوم بها في الجنايات ثم في الجنح ثم في المخالفات.$b4741440$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins474;

WITH ins475 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 475, 0, $h4751444$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4751444$, $t4751445$مادة (475)$t4751445$, $b4751443$يكون تنفيذ الإلزام بعمل للمنفعة العامة بأمر يصدر من النيابة العامة على النموذج المعد لهذا الغرض بعد إعلان المتهم طبق ًا للمادة  ٤٦٤من هذا القانون ،وبعد أن يكـون قد أمضى جميع مدد العقوبات المقيدة للحرية المحكوم بها.
ويصدر بتحديد النموذج وأنواع الأعمال التي يجوز إلزام المحكوم عليـه بالعمـل فيها للمنفعة العامة والجهات الإدارية التي تتقرر بها هذه الأعمال ،قرار مـن النائـب العام بالتنسيق مع الجهات المعنية.$b4751443$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins475;

WITH ins476 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 476, 0, $h4761447$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4761447$, $t4761448$مادة (476)$t4761448$, $b4761446$ينتهي الإلزام بعمل للمنفعة العامة متى صار المبلغ الموازي للمدة التـي قـضاها المحكوم عليه في العمل للمنفعة العامة محسوبا على مقتضى ما هو مقـرر فـي هـذا الباب مساويا للمبلغ المطلوب أصلا ً ،بعد استنزال ما يكون المحكوم عليـه قـد دفعـه أو تحصل منه بالتنفيذ على ممتلكاته.$b4761446$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins476;

WITH ins477 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 477, 0, $h4771450$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4771450$, $t4771451$مادة (477)$t4771451$, $b4771449$لا تبرأ ذمة المحكوم عليه من الغرامة والمصاريف وما يجب رده والتعويـضات بتنفيذ الالتزام بعمل للمنفعة العامة ،إلا باعتبار خمسين جنيها عن كل يوم.$b4771449$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins477;

WITH ins478 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 478, 0, $h4781453$الكتاب الرابع التنفيذ - الباب الخامس الإلزام بعمل للمنفعة العامة$h4781453$, $t4781454$مادة (478)$t4781454$, $b4781452$إذا لم يقم المحكوم عليه بتنفيذ الحكم الصادر بالتعويضات لغير الدولة بعد التنبيـه عليه بالدفع ،يجوز لمحكمة الجنح التي يقع بدائرتها موطنه ،إذا ثبت لـديها أنـه قـادر على الدفع ،وأمرته به فلم يمتثل ،أن تحكم بإلزامه بعمل للمنفعة العامة ،ولا يجـوز أن تزيد مدة هذا التشغيل على ثلاثة أشهر ،ولا يخصم شيء من التعـويض نظيـر هـذا التشغيل في هذه الحالة ،وترفع الدعوى من المحكوم له بالطرق المعتادة.$b4781452$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins478;

WITH ins479 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 479, 0, $h4791456$الكتاب الرابع التنفيذ - الباب السادس الإشكال فى التنفيذ$h4791456$, $t4791457$مادة (479)$t4791457$, $b4791455$كل إشكال من المحكوم عليه في التنفيذ يرفع إلى محكمة الجنايـات بـدرجتيها إذا كان الحكم صادرا منها وإلى محكمة الجنح المستأنفة فيما عدا ذلك ،وينعقد الاختصاص في الحالين للمحكمة التي تختص محليا بنظر الدعوى المستـشكل فـي تنفيـذ الحكـم الصادر فيها.$b4791455$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins479;

WITH ins480 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 480, 0, $h4801459$الكتاب الرابع التنفيذ - الباب السادس الإشكال فى التنفيذ$h4801459$, $t4801460$مادة (480)$t4801460$, $b4801458$يقدم الإشكال إلى المحكمة بواسطة النيابة العامة على وجه السرعة ،ويعلـن ذوو الشأن بالجلسة التي تحدد لنظره ،وتفصل المحكمة فيه في غرفة المشورة بعـد سـماع النيابة العامة وذوي الشأن .وللمحكمة أن تجري التحقيقات التي ترى لزومها ،ولها فـي كل الأحوال أن تأمر بوقف التنفيذ حتى يفصل في النزاع.
ويجوز للنيابة العامة عند الاقتضاء وقبل تقديم الإشكال إلى المحكمـة أن توقـف تنفيذ الحكم مؤقتا.$b4801458$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins480;

WITH ins481 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 481, 0, $h4811462$الكتاب الرابع التنفيذ - الباب السادس الإشكال فى التنفيذ$h4811462$, $t4811463$مادة (481)$t4811463$, $b4811461$مع عدم الإخلال بحق المحكمة في الأمر بحضور المستـشكل شخـصيا ،يجـوز حضور وكيل عن المستشكل ،وفي جميع الأحوال يجوز للمحكمة أن تـصدر قرارهـا في غيبة المستشكل.
ولا يجوز رد المحكمة التي تنظر الإشكال.
وإذا قدم المستشكل نفسه إشكالا آخر دون أسباب جدية تقضي المحكمة برفـضه، ولها أن تغرم المستشكل مبلغ ًا مقداره خمسمائة جنيه.
ولا يعد الإشكال من الإجراءات التي يترتب عليها وقف أو قطع مدة سقوط العقوبة.$b4811461$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins481;

WITH ins482 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 482, 0, $h4821465$الكتاب الرابع التنفيذ - الباب السادس الإشكال فى التنفيذ$h4821465$, $t4821466$مادة (482)$t4821466$, $b4821464$إذا حصل نزاع في شخصية المحكوم عليه يفصل فـي ذلـك النـزاع بالكيفيـة والأوضاع المقررة في المادتين  ٤٨١ ،٤٨٠من هذا القانون.
فإذا تبين للمحكمة أن المستشكل ليس هو المعني بالحكم تأمر بإخلاء سبيله وتحيل الأوراق إلى النيابة العامة لاتخاذ شئونها نحو المحكوم عليه الحقيقي.$b4821464$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins482;

WITH ins483 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 483, 0, $h4831468$الكتاب الرابع التنفيذ - الباب السادس الإشكال فى التنفيذ$h4831468$, $t4831469$مادة (483)$t4831469$, $b4831467$في حالة تنفيذ الأحكام المالية على أموال المحكوم عليه ،إذا قام نزاع مـن غيـر المتهم بشأن الأموال المطلوب التنفيذ عليها ،يرفع الأمر إلى المحكمة المدنية طبق ًا لمـا هو مقرر في قانون المرافعات المدنية والتجارية.
ويستثنى من ذلك حالة إشكال الغير حسن النية في الحكم بمصادرة أمواله ،فتنظره المحكمة التي أصدرت الحكم المستشكل فيه.$b4831467$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins483;

WITH ins484 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 484, 0, $h4841471$الكتاب الرابع التنفيذ - الباب السابع سقوط العقوبة بمضى المدة وموت المحكوم عليه$h4841471$, $t4841472$مادة (484)$t4841472$, $b4841470$تسقط العقوبة المحكوم بها في جناية بمضي عشرين سنة ،إلا عقوبة الإعدام فإنها تسقط بمضي ثلاثين سنة.
وتسقط العقوبة المحكوم بها في جنحة بمضي خمس سنين.
وتسقط العقوبة المحكوم بها في مخالفة بمضي سنتين.$b4841470$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins484;

WITH ins485 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 485, 0, $h4851474$الكتاب الرابع التنفيذ - الباب السابع سقوط العقوبة بمضى المدة وموت المحكوم عليه$h4851474$, $t4851475$مادة (485)$t4851475$, $b4851473$تبدأ مدة سقوط العقوبة من وقت صيرورة الحكم بات ًا ،إلا إذا كانت العقوبة محكومـا بهـا غيابيا من محكمة الجنايات بدرجتيها في جناية فتبدأ المدة من يوم صدور الحكم.$b4851473$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins485;

WITH ins486 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 486, 0, $h4861477$الكتاب الرابع التنفيذ - الباب السابع سقوط العقوبة بمضى المدة وموت المحكوم عليه$h4861477$, $t4861478$مادة (486)$t4861478$, $b4861476$تنقطع مدة سقوط العقوبة بالقبض على المحكوم عليه بعقوبة مقيدة للحرية وبكـل إجراء من إجراءات التنفيذ التي تتخذ في مواجهته أو تصل إلى علمه.
كما تنقطع المدة في غير مواد المخالفات إذا ارتكب المحكوم عليه خلالها جريمـة من نوع الجريمة المحكوم عليه من أجلها أو مماثلة لها.$b4861476$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins486;

WITH ins487 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 487, 0, $h4871480$الكتاب الرابع التنفيذ - الباب السابع سقوط العقوبة بمضى المدة وموت المحكوم عليه$h4871480$, $t4871481$مادة (487)$t4871481$, $b4871479$يوقف سريان مدة سقوط العقوبة كل مانع يحول دون مباشرة التنفيذ سـواء كـان قانونيا أو ماديا ويعتبر وجود المحكوم عليه في الخارج مانعا يوقف سريان المدة.$b4871479$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins487;

WITH ins488 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 488, 0, $h4881483$الكتاب الرابع التنفيذ - الباب السابع سقوط العقوبة بمضى المدة وموت المحكوم عليه$h4881483$, $t4881484$مادة (488)$t4881484$, $b4881482$تتبع الأحكام المقررة لمضي المدة في القانون المدني فيما يخـتص بالتعويـضات وما يجب رده والمصاريف المحكوم بها .ومع ذلك فلا يجوز التنفيذ بطريـق الإلـزام بعمل للمنفعة العامة بعد مضي المدة المقررة لسقوط العقوبة.$b4881482$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins488;

WITH ins489 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 489, 0, $h4891486$الكتاب الرابع التنفيذ - الباب السابع سقوط العقوبة بمضى المدة وموت المحكوم عليه$h4891486$, $t4891487$مادة (489)$t4891487$, $b4891485$مع مراعاة حكم الفقرة الثانية من المادة  ١٤٨من هذا القانون ،إذا مات المحكـوم عليه بعد الحكم عليه بحكم بات ،تنفذ العقوبات المالية والتعويـضات ومـا يجـب رده والمصاريف في تركته.$b4891485$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins489;

WITH ins490 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 490, 0, $h4901489$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4901489$, $t4901490$مادة (490)$t4901490$, $b4901488$يجوز رد الاعتبار إلى كل محكوم عليه في جناية أو جنحة ،ويصدر الحكـم بـذلك مـن محكمة جنايات أول درجة التابع لها محل إقامة المحكوم عليه ،وذلك بناء على طلبه.$b4901488$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins490;

WITH ins491 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 491, 0, $h4911492$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4911492$, $t4911493$مادة (491)$t4911493$, $b4911491$يجب للحكم برد الاعتبار ما يأتي: )أولا ً( أن تكون العقوبة قد نفذت تنفيذ ًا كاملا ً ،أو صدر عنهـا عفـو أو سـقطت بمضي المدة.
)ثانيا( أن يكون قد انقضى من تاريخ تنفيذ العقوبة أو صدور العفو عنها مدة ست سنوات إذا كانت عقوبة جناية ،أو ثلاث سنوات إذا كانت عقوبة جنحة .وتضاعف هذه المدد في حالتي الحكم للعود وسقوط العقوبة بمضي المدة.$b4911491$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins491;

WITH ins492 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 492, 0, $h4921495$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4921495$, $t4921496$مادة (492)$t4921496$, $b4921494$تبدأ المدة اللازمة لرد الاعتبار ،إذا كان المحكوم عليه قد وضـع تحـت مراقبـة الشرطة بعد انقضاء العقوبة الأصلية ،من اليوم الذي تنتهي فيه مدة المراقبة.
وإذا كان قد أفرج عن المحكوم عليه تحت شرط ،فلا تبدأ هذه المـدة إلا مـن التـاريخ المقرر لانقضاء العقوبة أو من التاريخ الذي يصبح فيه الإفراج تحت شرط نهائيا.$b4921494$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins492;

WITH ins493 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 493, 0, $h4931498$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4931498$, $t4931499$مادة (493)$t4931499$, $b4931497$يجب للحكم برد الاعتبار أن يوفي المحكوم عليه كل ما حكم به عليه من غرامـة أو رد أو تعويض أو مصاريف .ويجوز للمحكمة أن تتجاوز عن هذا إذا أثبت المحكوم عليه أنه ليس بحال يستطيع معها الوفاء.
وإذا لم يوجد المحكـوم لـه بالتعويـضات أو الـرد أو المـصاريف ،أو امتنـع عن قبولها ،وجب على المحكوم عليه أن يودعها طبق ًا لمـا هـو مقـرر فـي قـانون المرافعات في المواد المدنية والتجارية ،ويجوز لـه أن يـستردها إذا مـضت خمـس سنوات ولم يطلبها المحكوم له.
وإذا كان المحكوم عليه قد صدر عليه الحكم بالتضامن ،يكفـي أن يـدفع مقـدار ما يخصه شخصيا في الدين .وعند الاقتضاء تحدد المحكمـة الحـصة التـي يجـب عليه دفعها.$b4931497$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins493;

WITH ins494 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 494, 0, $h4941501$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4941501$, $t4941502$مادة (494)$t4941502$, $b4941500$في حالة الحكم في جريمة تفالس ،يجب على الطالب أن يثبت أنه قد حصل علـى حكم برد اعتباره التجاري.$b4941500$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins494;

WITH ins495 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 495, 0, $h4951504$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4951504$, $t4951505$مادة (495)$t4951505$, $b4951503$إذا كان الطالب قد صدرت عليه عدة أحكام ،فلا يحكم برد اعتباره إلا إذا تحققـت الشروط المنصوص عليها فى هذا الباب بالنسبة إلى كل حكم منها ،علـى أن يراعـى في حساب المدة إسنادها إلى أحدث الأحكام.$b4951503$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins495;

WITH ins496 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 496, 0, $h4961507$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4961507$, $t4961508$مادة (496)$t4961508$, $b4961506$يقدم طلب رد الاعتبار بعريضة إلى النيابة العامة ،ويجب أن يشتمل على البيانات اللازمة لتعيين شخصية الطالب ،وأن يبين فيها تاريخ الحكم الصادر عليـه والأمـاكن التي أقام فيها منذ الإفراج عنه.$b4961506$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins496;

WITH ins497 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 497, 0, $h4971510$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4971510$, $t4971511$مادة (497)$t4971511$, $b4971509$تجري النيابة العامة تحقيق ًا بشأن الطلب للاستيثاق من تاريخ إقامة الطالب في كل مكان نزله من وقت الحكم عليه ومدة تلك الإقامة ،وللوقوف علـى سـلوكه ووسـائل ارتزاقه ،وبوجه عام تتقصى كل ما تراه لازما من المعلومات وتـضم التحقيـق إلـى الطلب وترفعه إلى المحكمة في الثلاثة الأشهر التالية لتقديمه بتقرير يدون فيه رأيهـا، وتبين الأسباب التي بني عليها ،ويرفق بالطلب: ) (١صورة الحكم الصادر على الطالب.
) (٢صحيفة الحالة الجنائية.
) (٣تقرير عن سلوكه أثناء وجوده في مركز الإصلاح والتأهيل.$b4971509$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins497;

WITH ins498 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 498, 0, $h4981513$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4981513$, $t4981514$مادة (498)$t4981514$, $b4981512$تنظر المحكمة الطلب وتفصل فيه في غرفة المشورة ،ويجوز لها سـماع أقـوال النيابة العامة والطالب ،كما يجوز لها استيفاء كل ما تراه لازما من المعلومات.
ويكون إعلان الطالب بالحضور قبل الجلسة بثمانية أيام على الأقل.
ولا يقبل الطعن في الحكـم إلا بطريـق الـنقض لخطـأ فـي تطبيـق القـانون أو في تأويله ،وتتبع في الطعن الأوضاع والمواعيد المقررة للطعـن بطريـق الـنقض في الأحكام.$b4981512$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins498;

WITH ins499 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 499, 0, $h4991516$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h4991516$, $t4991517$مادة (499)$t4991517$, $b4991515$تحكم المحكمة برد الاعتبار ،متى توافرت شروطه ،ورأت أن سلوك الطالب منـذ صدور الحكم عليه يدعو إلى الثقة بتقويم نفسه.$b4991515$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins499;

WITH ins500 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 500, 0, $h5001519$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h5001519$, $t5001520$مادة (500)$t5001520$, $b5001518$ترسل النيابة العامة صورة من حكم رد الاعتبار إلى المحكمة التي صـدر منهـا الحكم بالعقوبة للتأشير به على هامشه ،وتأمر بأن يؤشر به في صحيفة الحالة الجنائية.$b5001518$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins500;

WITH ins501 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 501, 0, $h5011522$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h5011522$, $t5011523$مادة (501)$t5011523$, $b5011521$لا يجوز الحكم برد اعتبار المحكوم عليه إلا مرة واحدة.$b5011521$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins501;

WITH ins502 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 502, 0, $h5021525$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h5021525$, $t5021526$مادة (502)$t5021526$, $b5021524$إذا رفض طلب رد الاعتبار بسبب راجع إلى سلوك المحكوم عليه ،فـلا يجـوز تجديده إلا بعد مضي سنتين من تاريخ الرفض ،أما في الأحوال الأخرى فيجوز تجديده متى توافرت الشروط اللازمة لرد الاعتبار.$b5021524$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins502;

WITH ins503 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 503, 0, $h5031528$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h5031528$, $t5031529$مادة (503)$t5031529$, $b5031527$يجوز إلغاء الحكم الصادر برد الاعتبار إذا ظهر أن المحكوم عليه صدرت ضـده أحكام أخرى لم تكن المحكمة علمت بها ،أو إذا حكم عليه بعد رد الاعتبار في جريمـة وقعت قبله.
ويصدر الحكم في هذه الحالة من المحكمة التي حكمت برد الاعتبار بنـاء علـى طلب النيابة العامة.$b5031527$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins503;

WITH ins504 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 504, 0, $h5041531$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h5041531$, $t5041532$مادة (504)$t5041532$, $b5041530$يرد الاعتبار بحكم القانون إذا لم يصدر خلال الآجال التالية على المحكوم عليـه حكم بعقوبة في جناية أو جنحة مما يحفظ عنه بصحيفة الحالة الجنائية: )أولا ً( بالنسبة إلى المحكوم عليه بعقوبة جناية أو بعقوبة جنحة في جريمة سـرقة أو إخفاء أشياء مسروقة أو نصب أو خيانة أمانة أو تزوير أو شروع في هذه الجـرائم وفي الجرائم المنصوص عليها فـي المـواد  ٣٦٨ ،٣٦٧ ،٣٥٦ ،٣٥٥مـن قـانون العقوبات متى مضى على تنفيذ العقوبة أو العفو عنها أو سقوطها بمضي المـدة اثنتـا عشرة سنة.
)ثانيا( بالنسبة إلى المحكوم عليه بعقوبة جنحة في غير الجرائم المشار إليها فـي هذه المادة متى مضى على تنفيذ العقوبة أو العفو عنها ست سنوات إلا إذا كان الحكـم قد اعتبر المحكوم عليه عائدا أو كانت العقوبة قد سقطت بمضي المدة ،فتكـون المـدة اثنتي عشرة سنة.$b5041530$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins504;

WITH ins505 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 505, 0, $h5051534$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h5051534$, $t5051535$مادة (505)$t5051535$, $b5051533$إذا كان المحكوم عليه قد صدرت ضده عدة أحكام ،فلا يرد اعتباره إليـه بحكـم القانون إلا إذا تحققت بالنسبة لكل منها الشروط المنصوص عليها في المادة  ٥٠٤مـن هذا القانون ،على أن يراعى في حساب المدة إسنادها إلى أحدث الأحكام.$b5051533$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins505;

WITH ins506 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 506, 0, $h5061537$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h5061537$, $t5061538$مادة (506)$t5061538$, $b5061536$يترتب على رد الاعتبار محو الحكم القاضي بالإدانة بالنسبة للمستقبل وزوال كـل ما يترتب عليه من انعدام الأهلية والحرمان من الحقوق وسائر الآثار الجنائية.$b5061536$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins506;

WITH ins507 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 507, 0, $h5071540$الكتاب الرابع التنفيذ - الباب الثامن رد الاعتبار$h5071540$, $t5071541$مادة (507)$t5071541$, $b5071539$لا يجوز الاحتجاج برد الاعتبار على الغير فيما يتعلق بالحقوق التي تترتب لهـم من الحكم بالإدانة ،وعلى الأخص فيما يتعلق بالرد والتعويضات.$b5071539$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins507;

WITH ins508 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 508, 0, $h5081543$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5081543$, $t5081544$مادة (508)$t5081544$, $b5081542$مع عدم الإخلال بأحكام الاتفاقيات متعددة الأطراف أو الثنائية النافذة التي تكـون جمهورية مصر العربية طرف ًا فيها ،ومع مراعاة مبدأ المعاملة بالمثل ،يعمل بأحكام هذا الكتاب في شأن التعاون القضائي الدولي في المسائل الجنائية ،وتسري القواعد العامـة في كل ما لم يرد بشأنه نص خاص في هذا الكتاب وبما لا يتعارض مع أحكامه.
وتختص هيئة القضاء العسكري بالنظر في كافة طلبات التعاون القضائي الـدولي التي تدخل في اختصاصها ولائيا ،وتتولى النيابة العسكرية ممارسـة الاختـصاصات المقررة للنيابة العامة وفق ًا لأحكام هذا الكتاب.$b5081542$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins508;

WITH ins509 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 509, 0, $h5091546$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5091546$, $t5091547$مادة (509)$t5091547$, $b5091545$للجهات القضائية المصرية التعاون مع نظيراتها الأجنبية في مكافحـة وملاحقـة الجرائم بشتى صورها من خلال طلبات المساعدة القضائية وتسليم المجرمين والأشـياء واسترداد الأموال أو الأصول ونقل المحكوم عليهم وغير ذلك مـن صـور التعـاون القضائي الدولي في المسائل الجنائية.$b5091545$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins509;

WITH ins510 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 510, 0, $h5101549$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5101549$, $t5101550$مادة (510)$t5101550$, $b5101548$للجهات القضائية المصرية والأجنبية أن تطلب اتخاذ الإجراءات القانونيـة اللازمـة لتعقب أو ضبط أو تجميد أو إدارة الأموال أو الأصـول أو الأشـياء موضـوع الجريمـة أو عائداتها أو الحجز عليها ،أو تنفيذ الأحكام الجنائية النهائية باسترداد أو مصادرة الأمـوال أو الأصول أو الأشياء المتحصلة من الجرائم أو عائداتها مع عدم الإخلال بحقـوق الغيـر حسن النية.$b5101548$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins510;

WITH ins511 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 511, 0, $h5111552$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5111552$, $t5111553$مادة (511)$t5111553$, $b5111551$ترسل طلبات التعاون القضائي الدولي في المسائل الجنائية الواردة مـن الجهـات القضائية الأجنبية عبر الطريق الدبلوماسي إلى وزارة العدل متضمنة ملخص الواقعـة، ونوع وموضوع الطلب المترجم إلى اللغة العربية.
ويجب أن يرفق بالطلب المستندات المؤيدة له.
وتتولى وزارة العدل التحقق من مدى توفر الشروط المبينة بالفقرة الأولى من هذه المادة ،ولها أن تتخذ أيا من الإجراءين الآتيين: أولا ً :حفظ الطلب إذا تبين لها عدم توفر الشروط المشار إليها مع إخطار الجهـة الطالبة بأسباب الحفظ عبر الطريق الدبلوماسي.
ثانيا :إحالة الطلبات المستوفاة للشروط المشار إليها إلى النيابـة العامـة لإعمـال شئونها طبق ًا لأحكام هذا الكتاب.$b5111551$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins511;

WITH ins512 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 512, 0, $h5121555$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5121555$, $t5121556$مادة (512)$t5121556$, $b5121554$ترسل وزارة العدل طلبات التعاون القضائي الدولي في المـسائل الجنائيـة التـي توجه من النيابة العامة إلى الجهات القضائية الأجنبية عبر الطريق الدبلوماسي.$b5121554$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins512;

WITH ins513 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 513, 0, $h5131558$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5131558$, $t5131559$مادة (513)$t5131559$, $b5131557$يجوز للنيابة العامة أن تصدر أمرا مسببا بالقبض على المطلوب تسليمه بناء على طلب الجهة القضائية الأجنبية ،ولوزارة الداخلية القبض على المطلوب تـسليمه بنـاء على أمر قبض صادر من جهة قضائية أجنبية وفق ًـا للقواعـد المنظمـة لعمـل إدارة الشرطة الجنائية العربية والدولية )إنتربول القاهرة(.
ويعرض كل من يقبض عليه تنفيذ ًا لحكم الفقرة الأولى من هذه المادة على النيابـة العامة خلال أربع وعشرين ساعة من وقت القبض عليه ،والتي تباشر معه إجـراءات التحقيق في التهمة المنسوبة إليه والمبينة بالطلب وذلك بحضور محاميه ،مـع إعمـال حكم المادتين  ١١٢ ،١٠٥من هذا القانون.
ويجوز لعضو النيابة العامة من درجة رئيس نيابة على الأقـل أن يـأمر بحـبس المطلوب تسليمه احتياطيا لمدة أو مدد متعاقبة لا تجاوز كل منها خمسة عـشر يومـا، وبحيث لا تزيد المدة في مجموعها على ستين يوما لحين ورود طلب التسليم والفـصل فيه ،ويخضع أمر الحبس وتسبيبه ومد مدده والطعن فيه للأحكام الواردة بهذا القانون.
وللنائب العام أو من يفوضه إدراج المطلوب تـسليمه علـى قـوائم الممنـوعين من السفر أو وضع اسمه على قوائم ترقب الوصول وفق ًا للإجراءات المنصوص عليها في هذا القانون.$b5131557$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins513;

WITH ins514 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 514, 0, $h5141561$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5141561$, $t5141562$مادة (514)$t5141562$, $b5141560$لا يجوز تسليم الأشخاص في أي من الحالات الآتية: - ١إذا كان المطلوب تسليمه مصري الجنسية ،ويجوز للجهة القضائية الأجنبيـة تقديم طلب محاكمته مصحوبا بالتحقيقات التي أجرتها الدولـة الطالبـة والمـستندات، ويتعين إخطار الجهة القضائية الأجنبية بما آلت إليه الدعوى الجنائية ،وموافاتها بنسخة من التصرف النهائي في فترة زمنية مناسبة.
- ٢إذا كانت الجريمة موضوع طلب التسليم غير معاقب عليهـا وفق ًـا لأحكـام القانون المصري.
- ٣إذا انعقد الاختصاص للجهات القضائية المصرية بالجريمة المطلوب التـسليم من أجلها.
- ٤إذا كانت الجريمة موضوع الطلب جريمة سياسية أو جريمة مرتبطة بها.
- ٥إذا كانت الجريمة المطلوب التسليم من أجلها تنحصر في الإخلال بواجبـات عسكرية.
- ٦إذا ق ُصد بطلب التسليم معاقبة شخص لأسـباب تتعلـق بانتمائـه العرقـي أو الديني أو لجنسيته أو لآرائه السياسية ،أو أن يكون من شأن تـوافر أي مـن هـذه الأسباب الإضرار بمركز المطلوب تسليمه.
- ٧إذا صدر حكم بات بالبراءة أو الإدانـة فـي الجريمـة المطلـوب التـسليم من أجلها في جمهورية مصر العربية أو في دولة أخرى ،ونفذت العقوبة المحكوم بها.
- ٨إذا انقضت الدعوى الجنائية ،أو سقطت العقوبة المقضي بها بمضي المـدة، وفق ًا للقانون المصري أو قانون الدولة الطالبة النافذ عند تلقي طلب التسليم.
- ٩إذا صدر عفو شامل عن الجريمة محل طلب التسليم ،أو عفو عـن العقوبـة المقضي بها على الشخص المطلوب تسليمه ،أو عن المدة المتبقيـة منهـا ،أو أبـدلت العقوبة أو خ ُففت إلى عقوبة أخرى لا تتوافر بشأنها الشروط المتطلبـة للتـسليم وفق ًـا للقانون المصري أو قانون الدولة الطالبة.
-١٠إذا لم تتوافر ضمانات المحاكمة العادلة وحقوق الإنسان للمطلـوب تـسليمه في الدولة طالبة التسليم.
-١١إذا توافرت إحدى حالات الحصانة المقررة بمقتـضى الاتفاقيـات الدوليـة النافذة في جمهورية مصر العربية أو وفق ًا للمستقر عليه في الأعراف الدولية.
-١٢إذا تعارض طلب التسليم مع مقتضيات صون السيادة ،أو الأمـن القـومي، أو النظام العام.
-١٣إذا كان المطلوب تسليمه لاجئًا سياسيا.$b5141560$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins514;

WITH ins515 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 515, 0, $h5151564$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5151564$, $t5151565$مادة (515)$t5151565$, $b5151563$يصدر النائب العام أو من يفوضه قرارا مسببا في طلب التسليم ،ويجوز لكل مـن صدر قرار بتسليمه ،أن يطعن فيه أمام محكمة جنح مـستأنف عابـدين أو المحكمـة العسكرية للجنح المستأنفة بالقاهرة بحسب الأحوال ،وذلك بتقرير بالطعن بقلـم كتـاب المحكمة خلال مدة لا تزيد على سبعة أيـام مـن تـاريخ إعلانـه بـالقرار ،وتحـدد في التقرير جلسة لنظر الطعن والفصل فيه خلال مدة لا تزيد على سبعة أيام ،ويعتبـر التقرير بالطعن إعلان ًا بالجلسة المحددة ولو كان التقرير من وكيل ،ويفصل في الطعـن بقرار مسبب لا يقبل الطعن فيه ،ولا ينفذ القرار الصادر بالتـسليم إلا عقـب الفـصل في الطعن أو فوات مواعيده.$b5151563$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins515;

WITH ins516 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 516, 0, $h5161567$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5161567$, $t5161568$مادة (516)$t5161568$, $b5161566$يجوز للنيابة العامة أن تطلب مـن الجهـة القـضائية الأجنبيـة تـسليم المـتهم أو المحكوم عليه ،وفي حالة رفض التسليم لها أن تطلب محاكمته وفق ًا لقـانون الدولـة المطلوب منها ،ويجوز للنيابة العامة أن تصدر أمرا مسببا بـالقبض علـى المطلـوب تسليمه ،وتعتبر مدة حبسه التي تمت بالخارج مدة حبس احتياطي فـي شـأن تطبيـق قواعد تنفيذ العقوبة.$b5161566$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins516;

WITH ins517 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 517, 0, $h5171570$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5171570$, $t5171571$مادة (517)$t5171571$, $b5171569$يجوز للنائب العام ،أو من يفوضه ،بناء على طلب الجهة الطالبة ووفق ًا للـشروط التي يتم الاتفاق عليها ،أن يأذن بدخول أشـياء تعـد حيازتهـا جريمـة أو متحـصلة من جريمة أو أداة في ارتكابها إلى داخل البلاد أو عبورها إلى خارجها ،دون ضبطها، أو استبدالها كليا أو جزئيا ،وذلك تحت رقابة السلطات المصرية المختصة ،متى كـان من شأن ذلك التعرف على وجهة تلك الأشياء أو ضبط الجناة ،وما بحوزتهم.
ولا يجوز إصدار الإذن المشار إليه في الفقرة الأولى من هـذه المـادة ،إذا كـان من شأن تنفيذه الإضرار بالأمن أو سيادة الدولـة أو النظـام العـام أو الآداب العامـة أو يتعارض مع مقتضيات الأمن القومي.$b5171569$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins517;

WITH ins518 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 518, 0, $h5181573$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5181573$, $t5181574$مادة (518)$t5181574$, $b5181572$يشترط لإجابة طلب المساعدة القضائية المقدم من الجهة القضائية الأجنبية تـوافر الشروط الآتية: - ١أن يتعلق طلب المساعدة القضائية بجريمة معاقب عليها في الدولة الطالبـة، وتدخل في اختصاص جهاتها القضائية ولو كانت جريمة مدرجة تحت وصف آخر.
- ٢أن تكون المساعدة القضائية مرتبطة بمباشرة إجراءات قضائية في دعـوى جنائية منظورة أمام الجهة القضائية الأجنبية.
- ٣ألا يكون من شأن تنفيذ طلب المساعدة القضائية الإضرار بالأمن أو سـيادة الدولة أو النظام العام أو الآداب العامة أو التعارض مع مقتضيات الأمن القومي.$b5181572$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins518;

WITH ins519 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 519, 0, $h5191576$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5191576$, $t5191577$مادة (519)$t5191577$, $b5191575$يجوز للنيابة العامة رفض طلب المساعدة القضائية في الحالات الآتية: - ١إذا كانت الجريمة موضوع طلب المساعدة القضائية غير معاقب عليها وفق ًـا لأحكام القانون المصري.
- ٢إذا كانت الجريمة موضوع طلـب المـساعدة القـضائية جريمـة سياسـية أو جريمة مرتبطة بها.
- ٣إذا كانت الجريمة موضوع طلب المساعدة القضائية تنحصر فـي الإخـلال بواجبات عسكرية.
- ٤إذا ق ُصد بطلب المساعدة القضائية معاقبة شخص لأسباب تتعلـق بانتمائـه العرقي أو الديني أو لجنسيته أو لآرائه السياسية ،أو أن يكون من شأن توافر أي مـن هذه الأسباب الإضرار بمركزه القانوني.
- ٥إذا انعقد الاختصاص للجهات القـضائية المـصرية بالجريمـة المطلـوب المساعدة القضائية من أجلها.
- ٦إذا تعارض تنفيذ طلب المساعدة القضائية مع مبدأ عـدم جـواز محاكمـة الشخص عن ذات الجريمة أكثر من مرة.
- ٧إذا انقضت الدعوى الجنائية ،أو سقطت العقوبة المقضي بها بمضي المـدة، وفق ًا للقانون المصري أو قانون الدولة الطالبة النافذ عند تلقي طلب المساعدة القضائية.
- ٨إذا كان تنفيذ طلب المساعدة القضائية يخـرج عـن اختـصاص الجهـات القضائية المصرية.$b5191575$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins519;

WITH ins520 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 520, 0, $h5201579$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5201579$, $t5201580$مادة (520)$t5201580$, $b5201578$يصدر النائب العام أو من يفوضه قرارا في طلب المساعدة القضائية المقدم مـن الجهات القضائية الأجنبية ،وفى حالة الموافقة ينفذ على وجه السرعة.$b5201578$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins520;

WITH ins521 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 521, 0, $h5211582$الكتاب الخامس التعاون القضائي الدولي في المسائل الجنائية$h5211582$, $t5211583$مادة (521)$t5211583$, $b5211581$استثناء من أحكام هذا الكتاب ،يجوز لرئيس الجمهورية بناء على عرض النائـب العام وبعد موافقة مجلس الوزراء ،الموافقة على تسليم المتهمين ونقل المحكوم علـيهم إلى دولهم ،وذلك لمحاكمتهم أو تنفيذ العقوبة المقضي بها عليهم بحسب الأحوال ،متـى اقتضت مصلحة الدولة العليا ذلك.$b5211581$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins521;

WITH ins522 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 522, 0, $h5221585$الكتاب السادس أحكام متنوعة - الباب الأول حماية اني عليهم والشهود والمتهمين والمبلغين$h5221585$, $t5221586$مادة (522)$t5221586$, $b5221584$مع عدم الإخلال بالاتفاقيات الدولية التي تكون جمهورية مـصر العربيـة طرف ًـا فيها ،يعمل بأحكام هذا الباب في شأن حماية المجنـي علـيهم والـشهود والمتهمـين والمبلغين عند الاقتضاء.$b5221584$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins522;

WITH ins523 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 523, 0, $h5231588$الكتاب السادس أحكام متنوعة - الباب الأول حماية اني عليهم والشهود والمتهمين والمبلغين$h5231588$, $t5231589$مادة (523)$t5231589$, $b5231587$يجوز للشاهد بناء على إذن النيابة العامة ،أو قاضي التحقيق المخـتص أن يتخـذ من مقر الشرطة التابع له محل إقامته أو من مقر عمله عنوان ًا له.$b5231587$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins523;

WITH ins524 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 524, 0, $h5241591$الكتاب السادس أحكام متنوعة - الباب الأول حماية اني عليهم والشهود والمتهمين والمبلغين$h5241591$, $t5241592$مادة (524)$t5241592$, $b5241590$في الأحوال التي يكون فيها من شأن سماع أقوال أي إنـسان تعـريض حياتـه، أو سلامته ،أو أحد أفراد أسرته للخطر ،يجوز لمحكمة الموضوع أو للمحـامي العـام، أو قاضي التحقيق بناء على طلب هذا الشخص أو أحد مأموري الضبط القضائي الأمر بسماع أقواله مع ذكر بيانات لا تكشف عن هويته ،على أن ينشأ ملف فرعي للقـضية يتضمن تحديدا لشخصيته وبياناته الحقيقية.$b5241590$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins524;

WITH ins525 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 525, 0, $h5251594$الكتاب السادس أحكام متنوعة - الباب الأول حماية اني عليهم والشهود والمتهمين والمبلغين$h5251594$, $t5251595$مادة (525)$t5251595$, $b5251593$في الأحوال التي يكون فيها الكشف عن هوية الشخص لا غنى عنهـا لمباشـرة حقوق الدفاع يجوز للمتهم أو وكيله الطعن على الأمر الصادر من المحامي العـام أو قاضـي التحقيق بإخفاء بياناته ،أمام محكمة جنايات أول درجة منعقدة في غرفة مشورة ،خلال عشرة أيام من تاريخ مواجهته بفحوى هذه الشهادة ،وتفـصل المحكمـة فـي الطعـن بعد سماع ذوي الشأن بقرار نهائي مسبب ،وذلك دون إخلال بحق محكمة الموضـوع في إلغاء هذا الأمر ،أو استدعاء هذا الشخص لسماع أقواله.$b5251593$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins525;

WITH ins526 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 526, 0, $h5261597$الكتاب السادس أحكام متنوعة - الباب الأول حماية اني عليهم والشهود والمتهمين والمبلغين$h5261597$, $t5261598$مادة (526)$t5261598$, $b5261596$يجوز للمتهم أثناء المحاكمة أن يطلب مواجهة أو مناقشة الشخص الـصادر أمـر بإخفاء بياناته ،بما لا يكشف عن شخصيته ،وذلـك كلـه وفق ًـا لإجـراءات التحقيـق والمحاكمة عن بعد المنصوص عليها في هذا القانون.$b5261596$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins526;

WITH ins527 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 527, 0, $h5271600$الكتاب السادس أحكام متنوعة - الباب الأول حماية اني عليهم والشهود والمتهمين والمبلغين$h5271600$, $t5271601$مادة (527)$t5271601$, $b5271599$مع عدم الإخلال بأي عقوبة أشد منصوص عليها في أي قانون آخر ،يعاقب كـل من أدلى بأي بيانات عن الشخص الصادر أمر بإخفاء هويته بالحبس والغرامة التـي لا تقل عن خمسين ألف جنيه ،أو بإحدى هاتين العقوبتين ،وتكون العقوبة السجن المـشدد إذا ارتكبت الجريمة تنفيذ ًا لغرض إرهابي ،وفي جميع الأحوال تكون العقوبة الإعـدام أو السجن المؤبد إذا نجم عن الفعل موت شخص.$b5271599$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins527;

WITH ins528 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 528, 0, $h5281603$الكتاب السادس أحكام متنوعة - الباب الثانى التعويض عن الحبس$h5281603$, $t5281604$مادة (528)$t5281604$, $b5281602$يستحق كل من حبس احتياطيا تعويضا في الحالات الآتية: -١إذا كانت الواقعة محل الاتهام معاقبـا عليهـا بالغرامـة ،أو جنحـة معاقبـا عليها بالحبس مدة تقل عن سنة ،وكان للمتهم محل إقامة ثابت ومعلوم فـي جمهوريـة مصر العربية.
-٢إذا صدر أمر نهائي بأن لا وجه لإقامة الدعوى الجنائية لعدم صحة الواقعة.
-٣إذا صدر حكم بات ببراءته من جميع الاتهامات المنسوبة إليـه مبنيـا علـى أن الواقعة غير معاقب عليها ،أو غير صحيحة ،أو أي أسباب أخرى بخلاف حـالات البطلان أو التشكك في صحة الاتهام أو أسـباب الإباحـة أو الإعفـاء مـن العقـاب، أو العفو ،أو امتناع المسئولية.
ويسري حكم البند ) (٣من الفقرة الأولى من هذه المادة في شأن استحقاق تعويض لمن نفذ عقوبة سالبة للحرية صدر حكم بات بإلغاء الحكم المنفذة بموجبه.
وفي جميع الأحوال تتحمل الخزانة العامة للدولة التعويضات المشار إليها في هذه المادة ،بشرط ألا يكون طالب التعويض تم حبسه احتياطيا ،أو نفذ عقوبة مقيدة للحريـة على ذمة قضية أو قضايا أخرى عن فترة مماثلة أو تزيد على مدة الحبس الاحتيـاطي أو تنفيذ العقوبة محل طلب التعويض.$b5281602$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins528;

WITH ins529 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 529, 0, $h5291606$الكتاب السادس أحكام متنوعة - الباب الثانى التعويض عن الحبس$h5291606$, $t5291607$مادة (529)$t5291607$, $b5291605$يرفع طلب التعويض المشار إليه بالمادة  ٥٢٨من هذا القانون بـالطرق المعتـادة لرفع الدعاوى ،ويتبع في شأن إجراءاته والحكم فيه والطعن عليه القواعد المنـصوص عليها في قانون المرافعات المدنية والتجارية.$b5291605$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins529;

WITH ins530 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 530, 0, $h5301609$الكتاب السادس أحكام متنوعة - الباب الثالث إجراءات التحقيق والمحاكمة عن بعد$h5301609$, $t5301610$مادة (530)$t5301610$, $b5301608$مع عدم الإخلال بالقواعد والمواعيد والمدد وغيرهـا مـن إجـراءات التقاضـي المنصوص عليها في هذا القانون ،تسري أحكام هذا الباب علـى إجـراءات التحقيـق والمحاكمة عن بعد باستخدام وسائل وتقنيات الاتصال الحديثة المـسموعة والمرئيـة، وذلك ك ُله بما يضمن أحكام سرية التحقيقات والحضور والعلانيـة وشـفوية المرافعـة والمواجهة بين الخصوم الواردة في هذا القانون.$b5301608$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins530;

WITH ins531 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 531, 0, $h5311612$الكتاب السادس أحكام متنوعة - الباب الثالث إجراءات التحقيق والمحاكمة عن بعد$h5311612$, $t5311613$مادة (531)$t5311613$, $b5311611$يجوز لجهة التحقيق أو المحاكمة المختصة بحسب الأحوال اتخاذ كـل أو بعـض إجراءات التحقيق أو المحاكمة عن بعد مع المتهمـين ،والـشهود ،والمجنـي علـيهم، والخبراء ،والمـدعين بـالحقوق المدنيـة ،والمـسئولين عنهـا ،المنـصوص عليهـا في هذا القانون.
ويجوز لها اتخاذ تلك الإجراءات فيما يتعلق بالنظر في أمر الحـبس الاحتيـاطي والتدابير ومدهما والإفراج المؤقت واستئناف أوامرها.
ولها بحسب الأحوال أن تقرر منع الكشف عن الشخصية الحقيقية للشهود بجميـع وسائل وتقنيات الاتصال الحديثة المناسبة أثناء الإدلاء بأقوالهم ،وذلك ك ُله مع مراعـاة حكم المادة  ٥٢٥من هذا القانون.$b5311611$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins531;

WITH ins532 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 532, 0, $h5321615$الكتاب السادس أحكام متنوعة - الباب الثالث إجراءات التحقيق والمحاكمة عن بعد$h5321615$, $t5321616$مادة (532)$t5321616$, $b5321614$مع عدم الإخلال بأحكام قانون الطفل يجوز اتخاذ الإجـراءات عـن بعـد مـع الأطفال ،ولجهة التحقيق والمحاكمة المختصة إعفاء الطفـل مـن الحـضور أمامهـا، والاكتفاء بالاطلاع على تسجيلات تلك الإجراءات إذا رأت أن مصلحته تقتضي ذلك.$b5321614$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins532;

WITH ins533 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 533, 0, $h5331618$الكتاب السادس أحكام متنوعة - الباب الثالث إجراءات التحقيق والمحاكمة عن بعد$h5331618$, $t5331619$مادة (533)$t5331619$, $b5331617$يتعين على جهة التحقيق أو المحاكمة المختصة بحسب الأحوال إعلان الخـصوم بموعد ومكان انعقاد جلسة التحقيق أو المحاكمة التي ستتم عن بعـد ،علـى أن يكـون المكان تم تجهيزه وتهيئته لإجراءات التحقيق والمحاكمة عن بعد وفق ًا لحكم المادة ٥٣٧ من هذا القانون.$b5331617$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins533;

WITH ins534 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 534, 0, $h5341621$الكتاب السادس أحكام متنوعة - الباب الثالث إجراءات التحقيق والمحاكمة عن بعد$h5341621$, $t5341622$مادة (534)$t5341622$, $b5341620$يكون لجهات التحقيق والمحاكمة المختصة أن تتخذ ما تراه مناسبا لتسجيل وحفظ جميع الإجراءات التي تتم من خلال وسائل وتقنيات الاتـصال الحديثـة عـن بعـد، وتفريغها في محاضر ،ولها أن تستعين بأحد الخبراء في ذلك ،وتودع ملف القضية.
ويضع كل من عضو النيابة العامة أو قاضي التحقيق أو رئيس الـدائرة والكاتـب توقيعه على كل ورقة دون الحاجة إلى توقيع أي من المتهمين أو الـشهود أو الخبـراء أو المترجمين أو أي توقيع آخر.$b5341620$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins534;

WITH ins535 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 535, 0, $h5351624$الكتاب السادس أحكام متنوعة - الباب الثالث إجراءات التحقيق والمحاكمة عن بعد$h5351624$, $t5351625$مادة (535)$t5351625$, $b5351623$يجوز للمتهم في أول جلسة بأي درجة من درجات التقاضي الاعتراض على عدم مثوله شخصيا أمام المحكمة المختصة ،وعليها الفصل في الاعتراض بقبوله أو رفضه.$b5351623$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins535;

WITH ins536 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 536, 0, $h5361627$الكتاب السادس أحكام متنوعة - الباب الثالث إجراءات التحقيق والمحاكمة عن بعد$h5361627$, $t5361628$مادة (536)$t5361628$, $b5361626$يحضر المتهم الجلسة بغير قيود ولا أغلال ،وتجري عليه الملاحظة اللازمة.
ولمحامي المتهم مقابلته ،والحضور معه في مكـان تواجـده ،وأثنـاء إجـراءات التحقيق والمحاكمة عن بعد.
وفي جميع الأحوال ،لا يجـوز الفـصل بـين المـتهم ومحاميـه أثنـاء اتخـاذ تلك الإجراءات.$b5361626$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins536;

WITH ins537 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 537, 0, $h5371630$الكتاب السادس أحكام متنوعة - الباب الثالث إجراءات التحقيق والمحاكمة عن بعد$h5371630$, $t5371631$مادة (537)$t5371631$, $b5371629$تقوم وزارة العدل بالتعاون والتنسيق مع وزارة الداخليـة والجهـات والـوزارات المعنية ،بإعداد القاعات وأجهزة الاتصال المطلوبة لتنفيذ إجراءات التحقيق والمحاكمـة عن بعد باستخدام وسائل وتقنيات الاتصال الحديثة فـي الجهـات المختـصة ،وفـي المؤسسات العقابية ومراكز الإصلاح والتأهيل ،وغير ذلك مـن الإدارات ذات الـصلة وتقديم المساعدة الفنية اللازمة لذلك.$b5371629$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins537;

WITH ins538 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 538, 0, $h5381633$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5381633$, $t5381634$مادة (538)$t5381634$, $b5381632$يكون للمدعي العام العسكري والنيابة العسكرية فيما تختص به ولائيا ذات الاختصاصات والسلطات المقررة للنائب العام والنيابة العامة في هذا القانون.$b5381632$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins538;

WITH ins539 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 539, 0, $h5391636$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5391636$, $t5391637$مادة (539)$t5391637$, $b5391635$ت ُحسب جميع المدد المبينة في هذا القانون بالتقويم الميلادي.$b5391635$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins539;

WITH ins540 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 540, 0, $h5401639$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5401639$, $t5401640$مادة (540)$t5401640$, $b5401638$تلتزم نقابات المحامين الفرعية أو النقابة العامة إذا كانت النقابـة الفرعيـة غيـر قائمة أو في حال وجود مانع بالتنسيق مع رئيس المحكمة الابتدائية المختصة في بدايـة كل عام قضائي وكلما اقتضت الحاجة لذلك بإعداد قوائم بعدد كاف من المحـامين يـتم تسجيلهم في سجل خاص ينشأ لهذا الغرض بالمحكمة الابتدائية المختصة ،يـدون بـه جميع بياناتهم ويرسل رئيس المحكمة الابتدائية صورة رسـمية منهـا إلـى المحـاكم والنيابات التي تقع في دائرة اختصاص المحكمة الابتدائية للندب من بينهم أمام جهـات التحقيق أو المحاكمة بحسب الأحوال.$b5401638$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins540;

WITH ins541 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 541, 0, $h5411642$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5411642$, $t5411643$مادة (541)$t5411643$, $b5411641$تتبع الإجراءات المقررة في هذا الباب ،إذا فقدت النسخة الأصلية للحكم قبل تنفيذه أو فقدت أوراق التحقيق كلها أو بعضها قبل صدور قرار فيه.$b5411641$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins541;

WITH ins542 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 542, 0, $h5421645$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5421645$, $t5421646$مادة (542)$t5421646$, $b5421644$إذا وجدت صورة رسمية من الحكم ،فإنها تقوم مقام النسخة الأصلية.
وإذا كانت الصورة الرسمية من الحكم تحت يد شخص أو جهـة مـا ،تستـصدر النيابة العامة أمرا من رئيس المحكمة التي أصدرت الحكم بتسليمها ،ولمن أخذت منـه أن يطلب تسليمه صورة مطابقة بغير مصاريف.$b5421644$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins542;

WITH ins543 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 543, 0, $h5431648$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5431648$, $t5431649$مادة (543)$t5431649$, $b5431647$لا يترتب على فقد نسخة الحكم الأصلية إعادة المحاكمة ،متى كانت طرق الطعن في الحكم قد استنفدت.$b5431647$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins543;

WITH ins544 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 544, 0, $h5441651$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5441651$, $t5441652$مادة (544)$t5441652$, $b5441650$إذا كانت القضية منظورة أمام محكمة النقض ولم يتيسر الحصول علـى صـورة رسمية من الحكم ،تقضي المحكمة بإعادة المحاكمة متـى كانـت جميـع الإجـراءات المقررة للطعن قد استوفيت.$b5441650$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins544;

WITH ins545 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 545, 0, $h5451654$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5451654$, $t5451655$مادة (545)$t5451655$, $b5451653$إذا فقدت أوراق التحقيق كلها أو بعضها قبل صدور قرار فيه ،يعاد التحقيق فيمـا فقدت أوراقه.
وإذا كانت القضية مرفوعة أمام المحكمة ،تتولى هي إجراء ما تراه من التحقيـق، ولها إرسال الأوراق إلى النيابة العامة أو قاضي التحقيق بحـسب الأحـوال ،لإعـادة التحقيق فيما فقدت أوراقه إذا رأت محلا ً لذلك.$b5451653$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins545;

WITH ins546 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 546, 0, $h5461657$الكتاب السادس أحكام متنوعة - الباب الرابع أحكام عامة$h5461657$, $t5461658$مادة (546)$t5461658$, $b5461656$إذا فقدت أوراق التحقيق كلها أو بعضها ،وكان الحكم موجودا والقضية منظـورة أمام محكمة النقض ،فلا تعاد الإجراءات إلا إذا رأت المحكمة محلا ً لذلك.$b5461656$
  FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-10-01', 'active' FROM ins546;


-- ===== تحقق نهائى =====
DO $verify066$
DECLARE
  v_law_id uuid;
  v_total int;
  v_main int;
  v_enacting int;
  v_versions int;
  v_gaps int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 174 AND law_year = 2025 AND kind = 'law';

  IF v_law_id IS NULL THEN
    RAISE WARNING '[066] law 174/2025 غير موجود بعد الإدراج — فشل غير متوقَّع';
    RETURN;
  END IF;

  SELECT count(*) INTO v_total FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_main FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0;
  SELECT count(*) INTO v_enacting FROM articles WHERE law_id = v_law_id AND article_suffix_order = -1;
  SELECT count(*) INTO v_versions FROM article_versions av
    JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id;

  SELECT count(*) INTO v_gaps FROM generate_series(1,546) AS n
    WHERE NOT EXISTS (
      SELECT 1 FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no = n
    );

  IF v_total = 552 AND v_main = 546 AND v_enacting = 6 AND v_versions = 552 AND v_gaps = 0 THEN
    RAISE NOTICE '[066] قانون 174/2025: تم بنجاح — % صف (546 أساسية + 6 إصدارية)، % نسخة، بلا فجوة فى 1-546', v_total, v_versions;
  ELSE
    RAISE WARNING '[066] قانون 174/2025: تحقق غير مكتمل — total=% main=% enacting=% versions=% gaps=%', v_total, v_main, v_enacting, v_versions, v_gaps;
  END IF;
END
$verify066$;

COMMIT;
