-- 068_seed_law_15_2004_electronic_signature.sql
--
-- بذر القانون رقم 15 لسنة 2004 بتنظيم التوقيع الإلكترونى وبإنشاء هيئة
-- تنمية صناعة تكنولوجيا المعلومات (31 مادة). الجزء (ج) من استكمال رفع
-- القوانين الناقصة فى المحور الأول من الخطة (الترتيب رقم 2 فى القائمة
-- المرتَّبة بالحجم، بعد استبعاد قانون الكسب غير المشروع 62/1975 بقرار
-- صريح من صاحب المشروع لعدم توفر مصدر رسمى موثوق له).
--
-- ===== المصدر (لا اختلاق — مصدر رسمى موثَّق) =====
-- نسخة PDF رسمية من بوابة التقاضى الإلكترونى للمحاكم الاقتصادية التابعة
-- لوزارة العدل المصرية (elec.eecourts.gov.eg)، رابط مباشر:
-- https://elec.eecourts.gov.eg/assets/laws/11-%D9%82%D8%A7%D9%86%D9%88%D9%86%20%D8%B1%D9%82%D9%85%2015%20%D9%84%D8%B3%D9%86%D8%A9%202004.pdf
-- تم التحقق من موثوقية المصدر قبل تسليم الرابط (نطاق .gov.eg تابع لموقع
-- وزارة العدل moj.gov.eg) بناء على تعليمات صريحة بعدم تسليم أى رابط غير
-- موثوق. الملف: نص رقمى أصلى (لا مسح ضوئى)، 8 صفحات، منشور بالجريدة
-- الرسمية العدد 17 تابع (د) بتاريخ 2004-04-22، صدر برئاسة الجمهورية فى
-- غرة ربيع الأول 1425هـ الموافق 21 أبريل 2004.
--
-- ===== تصحيح مقابل التقدير الأولى =====
-- تقدير البحث الأولى (مصدر ثانوى) قدَّر 30 مادة. بعد القراءة البصرية
-- المباشرة للنص الرسمى الكامل، العدد الصحيح المؤكَّد 31 مادة (المادة
-- الأخيرة 31 هى مادة إصدار/بصم الدولة، أُغفلت على الأرجح فى تقدير
-- المصدر الثانوى). لا تعديلات لاحقة على المواد الـ31 نفسها منذ 2004 —
-- التعديل الوحيد المؤكَّد عبر بحث ويب مباشر كان على اللائحة التنفيذية
-- فقط (إضافة خدمات الختم الإلكترونى والتوقيت الزمنى)، وليس على متن
-- القانون الأصلى.
--
-- ===== ملاحظات بنيوية =====
-- بنية مسطَّحة تمامًا: لا أبواب ولا فصول (hierarchical_location = NULL
-- لكل المواد)، لا مواد 'مكرر' إطلاقاً، ترقيم متصل 1-31 فى تسلسل واحد
-- (خلافاً لقوانين أخرى ذات 'مواد إصدار' منفصلة الترقيم — هنا الإصدار
-- والنشر والبصم جزء من نفس تسلسل 1-31). التصنيف category='other'
-- قياساً على سابقة مباشرة مؤكَّدة: القانون 175/2018 (مكافحة جرائم
-- تقنية المعلومات) مُصنَّف 'other' فى migrations/020 لكونه قانوناً
-- تنظيمياً/تقنياً متخصصاً وليس مجالاً تشريعياً رئيسياً مستقلاً.
--
-- effective_from = 2004-04-23 (اليوم التالى لتاريخ النشر 2004-04-22،
-- طبقاً لنص المادة 30 صراحة: "يعمل به اعتباراً من اليوم التالى لتاريخ
-- نشره").
--
-- قابلة لإعادة التشغيل بأمان (idempotent).

BEGIN;

-- ===== laws =====
INSERT INTO laws (law_no, law_year, title, short_title, category, kind, status, official_url, enacted_at)
VALUES (
  15, 2004,
  $lawt0$القانون رقم 15 لسنة 2004 بتنظيم التوقيع الإلكترونى وبإنشاء هيئة تنمية صناعة تكنولوجيا المعلومات$lawt0$,
  $laws0$التوقيع الإلكترونى 15/2004$laws0$,
  'other', 'law', 'in_force',
  $url0$https://elec.eecourts.gov.eg/assets/laws/11-%D9%82%D8%A7%D9%86%D9%88%D9%86%20%D8%B1%D9%82%D9%85%2015%20%D9%84%D8%B3%D9%86%D8%A9%202004.pdf$url0$,
  '2004-04-22'
)
ON CONFLICT (country_code, law_no, law_year, kind) DO NOTHING;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $et00$مادة 1$et00$, $e00$فى تطبيق أحكام هذا القانون يقصد بالمصطلحات الآتية المعانى المبينة قرين كل منها:

(أ) الكتابة الالكترونية:
كل حروف أو أرقام أو رموز أو أى علامات أخرى تثبت على دعامة الكترونية أو رقمية أو ضوئية أو أية وسيلة أخرى مشابهة وتعطى دلالة قابلة للإدراك.

(ب) المحرر الالكترونى:
رسالة بيانات تتضمن معلومات تنشأ أو تدمج، أو تخزن، أو ترسل أو تستقبل كليًا أو جزئيًا بوسيلة الكترونية، أو رقمية، أو ضوئية، أو بأية وسيلة أخرى مشابهة.

(جـ) التوقيع الالكترونى:
ما يوضع على محرر الكترونى ويتخذ شكل حروف أو أرقام أو رموز أو إشارات أو غيرها ويكون له طابع متفرد يسمح بتحديد شخص الموقّع ويميزه عن غيره.

(د) الوسيط الالكترونى:
أداة أو أدوات أو أنظمة إنشاء التوقيع الالكترونى.

(هـ) الموقّع:
الشخص الحائز على بيانات إنشاء التوقيع ويوقع عن نفسه أو عمن ينيبه أو يمثله قانونًا.

(و) شهادة التصديق الالكترونى:
الشهادة التى تصدر من الجهة المرخص لها بالتصديق وتثبت الارتباط بين الموقّع وبيانات إنشاء التوقيع.

(ز) الهيئة:
هيئة تنمية صناعة تكنولوجيا المعلومات.

(ح) الوزارة المختصة:
الوزارة المختصة بشئون الاتصالات والمعلومات.

(ط) الوزير المختص:
الوزير المختص بشئون الاتصالات والمعلومات.$e00$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $et10$مادة 2$et10$, $e10$تنشأ هيئة عامة تسمى "هيئة تنمية صناعة تكنولوجيا المعلومات" تكون لها الشخصية الاعتبارية العامة وتتبع الوزير المختص، ويكون مقرها الرئيسى محافظة الجيزة، ولها إنشاء فروع فى جميع أنحاء جمهورية مصر العربية.$e10$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $et20$مادة 3$et20$, $e20$تهدف الهيئة إلى تحقيق الأغراض الآتية:

(أ) تشجيع وتنمية صناعة تكنولوجيا المعلومات والاتصالات.
(ب) نقل التكنولوجيا المتقدمة للمعلومات وتحقيق الاستفادة منها.
(جـ) زيادة فرص تصدير خدمات الاتصالات وتكنولوجيا المعلومات ومنتجاتها.
(د) الإسهام فى تطوير وتنمية الجهات العاملة فى مجال تكنولوجيا المعلومات والاتصالات.
(هـ) توجيه وتشجيع وتنمية الاستثمار فى مجال صناعة تكنولوجيا المعلومات والاتصالات.
(و) رعاية المصالح المشتركة لأنشطة تكنولوجيا المعلومات.
(ز) دعم البحوث والدراسات فى مجال تكنولوجيا المعلومات والاتصالات وتشجيع الاستفادة بنتائجها.
(ح) تشجيع ودعم المشروعات الصغيرة والمتوسطة فى مجال استخدام وتوظيف آليات المعاملات الالكترونية.
(ط) تنظيم نشاط خدمات التوقيع الالكترونى وغيرها من الأنشطة فى مجال المعاملات الالكترونية وصناعة تكنولوجيا المعلومات.$e20$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $et30$مادة 4$et30$, $e30$تباشر الهيئة الاختصاصات اللازمة لتحقيق أغراضها ولها على الأخص ما يأتى:

(أ) إصدار وتجديد التراخيص اللازمة لمزاولة أنشطة خدمات التوقيع الالكترونى وغيرها من الأنشطة فى مجال المعاملات الالكترونية وصناعة تكنولوجيا المعلومات، وذلك وفقًا لأحكام القوانين واللوائح المنظمة لها.
(ب) تحديد معايير منظومة التوقيع الالكترونى بما يؤدى إلى ضبط مواصفاتها الفنية.
(جـ) تلقى الشكاوى المتعلقة بأنشطة التوقيع الالكترونى والمعاملات الالكترونية وتكنولوجيا المعلومات واتخاذ ما يلزم فى شأنها.
(د) تقييم الجهات العاملة فى مجال أنشطة تكنولوجيا المعلومات وتحديد مستوياتها الفنية بحسب نتائج هذا التقييم.
(هـ) تقديم المشورة الفنية بشأن المنازعات التى تنشأ بين الأطراف المعنية بأنشطة التوقيع الالكترونى والمعاملات الالكترونية وتكنولوجيا المعلومات.
(و) تقديم المشورة الفنية إلى الجهات العاملة فى مجال أنشطة تكنولوجيا المعلومات، وتدريب العاملين فيها.
(ز) إقامة المعارض والمؤتمرات والندوات المتخصصة فى مجال تكنولوجيا المعلومات والاتصالات داخليًا وخارجيًا.
(ح) إنشاء الشركات التى تساعد على تنمية صناعة تكنولوجيا المعلومات والاتصالات، أو المساهمة فيها.
(ط) إيداع وقيد وتسجيل النسخ الأصلية لبرامج الحاسب الآلى وقواعد البيانات، التى تتقدم بها الجهات أو الأفراد الناشرون والطابعون والمنتجون لها للمحافظة على حقوق الملكية الفكرية وغيرها من الحقوق.$e30$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, NULL, $et40$مادة 5$et40$, $e40$يفرض لصالح الهيئة رسم بواقع واحد فى المائة من إيرادات الخدمات والأعمال التى تقدمها المنشآت العاملة فى مجال تكنولوجيا المعلومات والاتصالات تلتزم به هذه المنشآت، يودع فى حساب خاص للمساهمة فى تنمية صناعة تكنولوجيا المعلومات والاتصالات، ويصدر بتحديد هذه الخدمات والأعمال قرار من مجلس إدارة الهيئة.

كما يكون إصدار، وتجديد التراخيص المنصوص عليها، فى البند (أ) من المادة (4) من هذا القانون بمقابل يصدر بتحديد فئاته وبقواعد وإجراءات اقتضائه قرار من مجلس إدارة الهيئة.$e40$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, NULL, $et50$مادة 6$et50$, $e50$تتكون موارد ومصادر تمويل الهيئة مما يأتى:

(أ) الاعتمادات التى تخصصها لها الدولة.
(ب) الرسم المنصوص عليه فى الفقرة الأولى من المادة (5) من هذا القانون.
(جـ) المقابل المنصوص عليه فى الفقرة الثانية من المادة (5)، البند (ج) من المادة (9)، المادتين (19)، (22) من هذا القانون.
(د) مقابل الخدمات الأخرى التى تؤديها الهيئة.
(هـ) الهبات والتبرعات والإعانات التى يقبلها مجلس إدارة الهيئة.
(و) القروض والمنح التى تعقد لصالح الهيئة.
(ز) عائد استثمار أموال الهيئة.$e50$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, NULL, $et60$مادة 7$et60$, $e60$تكون للهيئة موازنة مستقلة يجرى إعدادها وفقًا لقواعد إعداد موازنات الهيئات الاقتصادية، وتبدأ السنة المالية للهيئة مع بداية السنة المالية للدولة وتنتهى بانتهائها، ويكون للهيئة حساب خاص لدى البنك المركزى المصرى تودع فيه مواردها، ويجوز بموافقة وزير المالية فتح حساب للهيئة فى أحد البنوك.

ويرحل الفائض من موازنة الهيئة من سنة إلى أخرى. ويجوز بقرار من رئيس مجلس الوزراء بناء على عرض الوزير المختص وبعد التشاور مع وزير المالية أن يؤول جزء من هذا الفائض إلى الخزانة العامة للدولة.$e60$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, NULL, $et70$مادة 8$et70$, $e70$يتولى إدارة الهيئة مجلس إدارة يشكل بقرار من رئيس مجلس الوزراء برئاسة الوزير المختص وعضوية كل من:

(أ) الرئيس التنفيذى للهيئة.
(ب) مستشار من مجلس الدولة يختاره رئيس مجلس الدولة.
(جـ) ممثل لوزارة الدفاع يختاره وزير الدفاع.
(د) ممثل لوزارة الداخلية يختاره وزير الداخلية.
(هـ) ممثل لوزارة المالية يختاره وزير المالية.
(و) ممثل لجهاز رئاسة الجمهورية يختاره رئيس ديوان رئيس الجمهورية.
(ز) ممثل لجهاز المخابرات العامة يختاره رئيس جهاز المخابرات العامة.
(ح) سبعة أعضاء من ذوى الخبرة يختارهم الوزير المختص.

تكون مدة عضوية مجلس الإدارة ثلاث سنوات قابلة للتجديد، ويصدر بتحديد مكافأة العضوية قرار من رئيس مجلس الوزراء.

ولمجلس الإدارة أن يشكل من بين أعضائه لجنة أو أكثر يعهد إليها بصفة مؤقتة ببعض المهام، وله أن يفوض رئيس مجلس الإدارة أو الرئيس التنفيذى للهيئة فى بعض اختصاصاته.$e70$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, NULL, $et80$مادة 9$et80$, $e80$مجلس إدارة الهيئة هو السلطة المسئولة عن شئونها وتصريف أمورها، ويباشر اختصاصاته على الوجه المبين فى هذا القانون، وله أن يتخذ ما يراه لازمًا من قرارات لتحقيق الأغراض التى أنشئت الهيئة من أجلها، وله على الأخص ما يأتى:

(أ) وضع نظم وقواعد التوقيع الالكترونى والمعاملات الالكترونية طبقًا لأحكام القوانين واللوائح المنظمة لها.
(ب) وضع القواعد الفنية والإدارية والمالية والضمانات الخاصة بإصدار التراخيص اللازمة لمزاولة أنشطة خدمات التوقيع الالكترونى وغيرها من الأنشطة فى مجال المعاملات الالكترونية وتكنولوجيا المعلومات.
(جـ) تحديد الخدمات التى تؤديها الهيئة للغير فى مجال تكنولوجيا المعلومات والاتصالات، ومقابل أداء هذه الخدمات.
(د) وضع القواعد التى تكفل احترام تقاليد المهنة فى مجال المعاملات الالكترونية وتكنولوجيا المعلومات والاتصالات.
(هـ) وضع اللوائح الداخلية المتعلقة بالشئون الفنية والمالية والإدارية ولوائح المشتريات والمخازن وغيرها من اللوائح المتعلقة بتنظيم نشاط الهيئة، وذلك دون التقيد بالقواعد والنظم الحكومية.
(و) اعتماد مشروع الموازنة السنوية للهيئة.
(ز) وضع لائحة شئون العاملين بالهيئة المنظمة لتعيينهم وتحديد رواتبهم وبدلاتهم ومكافآتهم وترقياتهم وتأديبهم وإنهاء خدمتهم وسائر شئونهم الوظيفية، وذلك مع مراعاة قواعد الكفاية الإنتاجية وتوازن اقتصاديات الهيئة وبالتشاور مع المنظمة النقابية ذات الصلة، ودون التقيد بقواعد ونظم العاملين المدنيين بالدولة.
(ح) وضع خطط وبرامج التدريب والتأهيل على صناعة تكنولوجيا المعلومات.

ويصدر باللوائح والنظم المنصوص عليها فى هذه المادة قرار من الوزير المختص.$e80$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins8;

WITH ins9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, NULL, $et90$مادة 10$et90$, $e90$يجتمع مجلس الإدارة بدعوة من رئيسه مرة على الأقل كل شهر وكلما اقتضت الضرورة ذلك، ويكون اجتماعه صحيحًا بحضور أغلبية أعضائه، وتصدر قراراته بأغلبية أصوات الحاضرين وعند التساوى يرجح الجانب الذى منه الرئيس.

وللمجلس أن يدعو لحضور جلساته من يرى الاستعانة بخبراتهم دون أن يكون لهم صوت معدود فى المداولات.$e90$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins9;

WITH ins10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, NULL, $et100$مادة 11$et100$, $e100$للهيئة رئيس تنفيذى يصدر بتعيينه وتحديد معاملته المالية قرار من رئيس مجلس الوزراء بناء على اقتراح الوزير المختص.

ويمثل الرئيس التنفيذى الهيئة أمام القضاء وفى علاقاتها بالغير، ويكون مسئولًا أمام مجلس الإدارة عن سير أعمال الهيئة فنيًا وإداريًا وماليًا، ويختص بما يأتى:

(أ) تنفيذ قرارات مجلس الإدارة.
(ب) إدارة الهيئة وتصريف شئونها والإشراف على سير العمل بها.
(جـ) عرض تقارير دورية على مجلس الإدارة عن نشاط الهيئة وسير العمل بها، وما تم إنجازه وفقًا للخطط والبرامج الموضوعة، وتحديد معوقات الأداء، والحلول المقترحة لتفاديها.
(د) القيام بأية أعمال أو مهام يكلفه بها مجلس الإدارة.
(هـ) الاختصاصات الأخرى التى تحددها اللوائح الداخلية للهيئة.$e100$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins10;

WITH ins11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, NULL, $et110$مادة 12$et110$, $e110$يحل الرئيس التنفيذى محل رئيس مجلس إدارة الهيئة حال غيابه.$e110$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins11;

WITH ins12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, NULL, $et120$مادة 13$et120$, $e120$تلتزم جميع الجهات والشركات العاملة فى مجال المعاملات الالكترونية وتكنولوجيا المعلومات بموافاة الهيئة بما تطلبه من تقارير أو إحصاءات أو معلومات تتصل بنشاط الهيئة.$e120$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins12;

WITH ins13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, NULL, $et130$مادة 14$et130$, $e130$للتوقيع الالكترونى، فى نطاق المعاملات المدنية والتجارية والإدارية، ذات الحجية المقررة للتوقيعات فى أحكام قانون الإثبات فى المواد المدنية والتجارية، إذا روعى فى إنشائه وإتمامه الشروط المنصوص عليها فى هذا القانون والضوابط الفنية والتقنية التى تحددها اللائحة التنفيذية لهذا القانون.$e130$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins13;

WITH ins14 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, NULL, $et140$مادة 15$et140$, $e140$للكتابة الالكترونية وللمحررات الالكترونية، فى نطاق المعاملات المدنية والتجارية والإدارية، ذات الحجية المقررة للكتابة والمحررات الرسمية والعرفية فى أحكام قانون الإثبات فى المواد المدنية والتجارية، متى استوفت الشروط المنصوص عليها فى هذا القانون وفقًا للضوابط الفنية والتقنية التى تحددها اللائحة التنفيذية لهذا القانون.$e140$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins14;

WITH ins15 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, NULL, $et150$مادة 16$et150$, $e150$الصورة المنسوخة على الورق من المحرر الالكترونى الرسمى حجة على الكافة بالقدر الذى تكون فيها مطابقة لأصل هذا المحرر، وذلك ما دام المحرر الالكترونى الرسمى والتوقيع الالكترونى موجودين على الدعامة الالكترونية.$e150$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins15;

WITH ins16 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, NULL, $et160$مادة 17$et160$, $e160$تسرى فى شأن إثبات صحة المحررات الالكترونية الرسمية والعرفية والتوقيع الالكترونى والكتابة الالكترونية، فيما لم يرد بشأنه نص فى هذا القانون أو فى لائحته التنفيذية الأحكام المنصوص عليها فى قانون الإثبات فى المواد المدنية والتجارية.$e160$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins16;

WITH ins17 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, NULL, $et170$مادة 18$et170$, $e170$يتمتع التوقيع الالكترونى والكتابة الالكترونية والمحررات الالكترونية بالحجية فى الإثبات إذا ما توافرت فيها الشروط الآتية:

(أ) ارتباط التوقيع الالكترونى بالموقّع وحده دون غيره.
(ب) سيطرة الموقّع وحده دون غيره على الوسيط الالكترونى.
(جـ) إمكانية كشف أى تعديل أو تبديل فى بيانات المحرر الالكترونى أو التوقيع الالكترونى.

وتحدد اللائحة التنفيذية لهذا القانون الضوابط الفنية والتقنية اللازمة لذلك.$e170$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins17;

WITH ins18 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 19, 0, NULL, $et180$مادة 19$et180$, $e180$لا تجوز مزاولة نشاط إصدار شهادات التصديق الالكترونى إلا بترخيص من الهيئة، وذلك نظير مقابل يحدده مجلس إدارتها وفقًا للإجراءات والقواعد والضمانات التى تقررها اللائحة التنفيذية لهذا القانون ودون التقيد بأحكام القانون رقم 129 لسنة 1947 بالتزامات المرافق العامة، ومع مراعاة ما يأتى:

(أ) أن يتم اختيار المرخص له فى إطار من المنافسة والعلانية.
(ب) أن يحدد مجلس إدارة الهيئة مدة الترخيص بحيث لا تزيد على تسعة وتسعين عامًا.
(جـ) أن تحدد وسائل الإشراف والمتابعة الفنية والمالية التى تكفل حسن سير المرفق بانتظام واطراد.

ولا يجوز التوقف عن مزاولة النشاط المرخص به أو الاندماج فى جهة أخرى أو التنازل عن الترخيص للغير إلا بعد الحصول على موافقة كتابية مسبقة من الهيئة.$e180$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins18;

WITH ins19 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 20, 0, NULL, $et190$مادة 20$et190$, $e190$تحدد اللائحة التنفيذية لهذا القانون البيانات التى يجب أن تشتمل عليها شهادة التصديق الالكترونى.$e190$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins19;

WITH ins20 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 21, 0, NULL, $et200$مادة 21$et200$, $e200$بيانات التوقيع الالكترونى والوسائط الالكترونية والمعلومات التى تقدم إلى الجهة المرخص لها بإصدار شهادات التصديق الالكترونى سرية، ولا يجوز لمن قدمت إليه أو اتصل بها بحكم عمله إفشاؤها للغير أو استخدامها فى غير الغرض الذى قدمت من أجله.$e200$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins20;

WITH ins21 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 22, 0, NULL, $et210$مادة 22$et210$, $e210$تختص الهيئة باعتماد الجهات الأجنبية المختصة بإصدار شهادات التصديق الالكترونى، وذلك نظير المقابل الذى يحدده مجلس إدارة الهيئة، وفى هذه الحالة تكون للشهادات التى تصدرها تلك الجهات ذات الحجية فى الإثبات المقررة لما تصدره نظيراتها فى الداخل من شهادات نظيرة، وذلك كله وفقًا للقواعد والإجراءات والضمانات التى تقررها اللائحة التنفيذية لهذا القانون.$e210$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins21;

WITH ins22 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 23, 0, NULL, $et220$مادة 23$et220$, $e220$مع عدم الإخلال بأية عقوبة أشد منصوص عليها فى قانون العقوبات أو فى أى قانون آخر، يعاقب بالحبس وبغرامة لا تقل عن عشرة آلاف جنيه ولا تجاوز مائة ألف جنيه أو بإحدى هاتين العقوبتين كل من:

(أ) أصدر شهادة تصديق إلكترونى دون الحصول على ترخيص بمزاولة النشاط من الهيئة.
(ب) أتلف أو عيّب توقيعًا أو محررًا أو وسيطًا إلكترونيًا، أو زوّر شيئًا من ذلك بطريق الاصطناع أو التعديل أو التحوير أو بأى طريق آخر.
(جـ) استعمل توقيعًا أو محررًا أو وسيطًا إلكترونيًا معيبًا أو محرّرًا أو مزوّرًا مع علمه بذلك.
(د) خالف أيًا من أحكام المادتين (19)، (21) من هذا القانون.
(هـ) توصل بأية وسيلة إلى الحصول بغير حق على توقيع أو وسيط أو محرر الكترونى، أو اخترق هذا الوسيط أو اعترضه أو عطله عن أداء وظيفته.

وتكون العقوبة على مخالفة المادة (13) من هذا القانون، الغرامة التى لا تقل عن خمسة آلاف جنيه ولا تجاوز خمسين ألف جنيه.

وفى حالة العود تزاد بمقدار المثل العقوبة المقررة لهذه الجرائم فى حديها الأدنى والأقصى.

وفى جميع الأحوال يحكم بنشر حكم الإدانة فى جريدتين يوميتين واسعتى الانتشار، وعلى شبكات المعلومات الإلكترونية المفتوحة على نفقة المحكوم عليه.$e220$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins22;

WITH ins23 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 24, 0, NULL, $et230$مادة 24$et230$, $e230$يعاقب المسئول عن الإدارة الفعلية للشخص الاعتبارى المخالف بذات العقوبات المقررة عن الأفعال التى ترتكب بالمخالفة لأحكام هذا القانون، إذا كان إخلاله بالواجبات التى تفرضها عليه تلك الإدارة قد أسهم فى وقوع الجريمة مع علمه بذلك.

ويكون الشخص الاعتبارى مسئولًا بالتضامن عن الوفاء بما يحكم به من عقوبات مالية وتعويضات، إذا كانت المخالفة قد ارتكبت من أحد العاملين به باسم ولصالح الشخص الاعتبارى.$e230$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins23;

WITH ins24 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 25, 0, NULL, $et240$مادة 25$et240$, $e240$يكون للعاملين بالهيئة الذين يصدر بهم قرار من وزير العدل بالاتفاق مع الوزير المختص صفة مأمورى الضبط القضائى بالنسبة إلى الجرائم التى تقع فى حدود اختصاصهم بالمخالفة لأحكام هذا القانون.$e240$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins24;

WITH ins25 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 26, 0, NULL, $et250$مادة 26$et250$, $e250$مع عدم الإخلال بأحكام المادة (23) من هذا القانون، يكون للهيئة، إذا خالف المرخص له بإصدار شهادات تصديق إلكترونى شروط الترخيص أو خالف أيًا من أحكام المادة (19) من هذا القانون، أن تلغى الترخيص، كما يكون لها أن توقف سريانه حتى إزالة أسباب المخالفة، وذلك كله وفقًا للقواعد والإجراءات التى تحددها اللائحة التنفيذية لهذا القانون.$e250$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins25;

WITH ins26 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 27, 0, NULL, $et260$مادة 27$et260$, $e260$على كل من يباشر نشاط إصدار شهادات التصديق الإلكترونى قبل تاريخ العمل بهذا القانون أن يوفق أوضاعه طبقًا لأحكامه خلال مدة لا تجاوز ستة أشهر من تاريخ صدور لائحته التنفيذية، وذلك وفقًا للقواعد والإجراءات التى تنص عليها هذه اللائحة.$e260$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins26;

WITH ins27 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 28, 0, NULL, $et270$مادة 28$et270$, $e270$لا تسرى أحكام المادة (13) من هذا القانون على أجهزة رئاسة الجمهورية والقوات المسلحة ووزارة الداخلية وجهاز المخابرات العامة وهيئة الرقابة الإدارية.$e270$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins27;

WITH ins28 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 29, 0, NULL, $et280$مادة 29$et280$, $e280$يصدر الوزير المختص اللائحة التنفيذية لهذا القانون خلال ستة أشهر من تاريخ نشره.$e280$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins28;

WITH ins29 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 30, 0, NULL, $et290$مادة 30$et290$, $e290$ينشر هذا القانون فى الجريدة الرسمية، ويعمل به اعتبارًا من اليوم التالى لتاريخ نشره.$e290$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins29;

WITH ins30 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 31, 0, NULL, $et300$مادة 31$et300$, $e300$يبصم هذا القانون بخاتم الدولة، وينفذ كقانون من قوانينها.$e300$
  FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2004-04-23', 'active' FROM ins30;

-- ===== تحقق نهائى =====
DO $verify068$
DECLARE
  v_law_id uuid;
  v_total INT;
  v_versions INT;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 15 AND law_year = 2004 AND kind = 'law';
  IF v_law_id IS NULL THEN RAISE EXCEPTION 'law 15/2004 not found after seed'; END IF;
  SELECT count(*) INTO v_total FROM articles WHERE law_id = v_law_id;
  IF v_total <> 31 THEN RAISE EXCEPTION 'expected 31 articles, got %', v_total; END IF;
  SELECT count(*) INTO v_versions FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id;
  IF v_versions <> 31 THEN RAISE EXCEPTION 'expected 31 article_versions, got %', v_versions; END IF;
  RAISE NOTICE '068_seed_law_15_2004_electronic_signature: تم بنجاح. % مادة، % نسخة.', v_total, v_versions;
END $verify068$;

COMMIT;