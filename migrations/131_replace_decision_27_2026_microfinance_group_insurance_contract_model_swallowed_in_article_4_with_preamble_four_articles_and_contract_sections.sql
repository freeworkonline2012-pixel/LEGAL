-- 131_replace_decision_27_2026_microfinance_group_insurance_contract_model_swallowed_in_article_4_with_preamble_four_articles_and_contract_sections.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (27) لسنة 2026 بإصدار نموذج عقد التأمين
-- النمطى الجماعى فى شأن التغطية التأمينية للعملاء الحاصلين على تمويل للمشروعات متناهية الصغر،
-- المنشور بالوقائع المصرية، العدد 27 (تابع د)، فى 3 فبراير 2026.
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P3) =====
-- مخزَّن منذ الهجرة 004 بأربع مواد، لكن المادة الرابعة (النشر والتوقيع) ابتلعت نموذج العقد المرفق كله
-- (نحو 8.7 ألف حرف: العنوان والأطراف والتمهيد والبنود الثلاثة عشر والتوقيعات) فصارت مادة النشر أكبر
-- مواد القرار وضاعت بنود العقد (مدة التأمين، الأخطار المستثناة، العجز الكلى المستديم، الأقساط، المستندات،
-- مهلة الدفع) من الاسترجاع. والنص كذلك بلا ديباجة (أساس الإصدار وجلستا المجلس)، وبه أرقام هندية
-- ملتصقة بالكلمات ("١٦لسنة ٢٠١٩") وتنوين منفصل ("وفقا ً") وترويسة الوقائع متسربة ورقم الصفحة.
-- القرار ضمن نطاق الحوكمة (لا تُمس بيانات laws).
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (9 صفحات، alamiria_2026_27.pdf) رفعه صاحب المشروع؛ رابط laws.official_url
-- يحمل الاسم نفسه ولم يُمس. استُخرجت الطبقة النصية (بعد إصلاح جدول الإحالات التالف فى الملف) وطُبّعت
-- (أشكال العرض، الأقواس المعكوسة، التنوين، الأرقام الهندية → لاتينية)، ثم قُرئت الصفحات 1 و2 و3 و9
-- بصرياً وقوبلت: تطابقت الديباجة والمواد الأربع وعنوان النموذج والأطراف والتمهيد والبند الأول والبندان
-- الثانى عشر والثالث عشر. وقوبلت بقية البنود (2–11) بالطبقة النصية المنسَّقة كلمةً كلمة.
-- أُبقى إملاء المصدر (مثل "لسنه 2009" فى الديباجة و"حاله وفاة" و"الي" و"علي"،
-- وعلامات التنصيص غير المتوازنة فى التمهيد والبند التاسع/6) ولم يُصحَّح، والحقول الفارغة بنقاط
-- و"-/-/-" كما هى لأنها نموذج يُملأ عند التعاقد.
--
-- ===== الهيكل =====
-- 19 مادة، 19 نسخة (version_no = 1): ديباجة (article_no = 0) + المواد 1–4 + قسم للعنوان والأطراف
-- والتمهيد (5) + 13 قسماً للبنود (6–18) بعناوين "نموذج العقد - البند ...". أرقام 5–18 أقسام لنموذج
-- العقد المرفق وليست مواداً من القرار؛ والـhierarchical_location يحمل "نموذج عقد التأمين الجماعى
-- المرافق للقرار رقم 27 لسنة 2026" لتمييزها. أُبقيت المواد 1–4 بأرقامها حتى لا يعيد بذر 004 فى كل
-- نشر إدراج مواد قديمة (إدراجه ON CONFLICT DO NOTHING على المفتاح نفسه).
--
-- ===== التاريخ =====
-- effective_from = 2026-02-04: المادة الرابعة تُعمل القرار من اليوم التالى لتاريخ نشره بالوقائع المصرية،
-- والنشر فى 3 فبراير 2026 (ترويسة الصفحات). enacted_at يبقى NULL (لا تاريخ إصدار فى النص؛ جلستا
-- المجلس 2025/9/10 و2026/1/22 مثبتتان فى الديباجة).
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (19 مادة بديباجة سليمة والمادة 18 موجودة)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف
-- (عدد، تلف، محتوى، إجمالى الطول 9120 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix131$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[131] القرار 27/2026 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 19
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 18 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[131] القرار 27/2026 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[131] أُزيلت % مادة من القرار 27/2026 (4 مواد، رابعتها تبتلع نموذج العقد)', v_n;
  END IF;
END
$fix131$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, NULL, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على القانون رقم 10 لسنه 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى القانون رقم 141 لسنة 2014 بتنظيم مزاولة نشاط تمويل المشروعات المتوسطة والصغيرة ومتناهية الصغر ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 173 لسنة 2014 بشأن قواعد وضوابط ممارسة الشركات لنشاط تمويل المشروعات متناهية الصغر ؛
وعلى قرار مجلس إدارة الهيئة رقم 31 لسنة 2015 بشأن قواعد ومعايير ممارسة نشاط تمويل المشروعات متناهية الصغر للجمعيات والمؤسسات الأهلية ؛
وعلى قرار مجلس إدارة الهيئة رقم 16 لسنة 2019 بإصدار نموذج عقد التأمين متناهي الصغر النمطي الجماعي لتغطية الحاصلين على تمويل للمشروعات متناهية الصغر ؛
وعلى قرار مجلس إدارة الهيئة رقم 17 لسنة 2019 بإعفاء عقود التأمين متناهي الصغر والحاصلين على تمويل متناهي الصغر من مقابل خدمات مراجعة واعتماد نماذج ووثائق التأمين ؛
وبعد موافقة مجلس إدارة الهيئة بجلستيه المنعقدتين بتاريخي 2025/9/10 و 2026/1/22 ؛
قرر :$b0$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$تلتزم شركات تأمينات الأشخاص وعمليات تكوين الأموال بالنموذج المرفق بهذا القرار في شأن التغطية التأمينية للعملاء حتى سن الخامسة والستين الحاصلين على تمويل للمشروعات متناهية الصغر من الشركات أو الجمعيات والمؤسسات الأهلية الفئتين (أ ، ب) ، وذلك ضد مخاطر الوفاة والعجز الكلي المستديم .
ويجوز التأمين على العملاء ممن تجاوزوا السن المشار إليه ضد المخاطر المذكورة وفقاً لما يتم الاتفاق عليه بين شركة التأمين وجهة التمويل .$b1$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$تلتزم شركات التأمين والجهات المرخص لها بتمويل المشروعات متناهية الصغر بتوفيق أوضاعها وفقاً لأحكام هذا القرار خلال ستة أشهر من تاريخ العمل به .$b2$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3$المادة الثالثة$t3$, $b3$يلغى قرار مجلس إدارة الهيئة رقم 16 لسنة 2019 المشار إليه .$b3$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4$المادة الرابعة$t4$, $b4$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية .
رئيس مجلس إدارة الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b4$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $h5$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h5$, $t5$نموذج العقد: العنوان والأطراف والتمهيد$t5$, $b5$نموذج عقد تأمين جماعي على عملاء الشركات / الجمعيات والمؤسسات الأهلية (أ ، ب) المرخص لها بمزاولة نشاط تمويل المشروعات متناهية الصغر ضد حالات الوفاة والعجز الكلي المستديم
تحرر هذا العقد في تاريخ -/-/- بين كلٍ من :
أولاً - الجمعية أو المؤسسة الأهلية أو الشركة المرخص لها بتمويل المشروعات متناهية الصغر ....................... بيانات جهة التمويل . ...................
(الطرف الأول - ويشار إليه فيما بعد ب المتعاقد )
ثانياً - شركة التأمين على الحياة ......... بيانات شركة التأمين . ..........
(الطرف الثاني - ويشار اليه فيما بعد بشركة التأمين)
وقد تم الاتفاق بينهما على الآتي :
تمهيد
بناء على رغبة الطرف الأول" في التعاقد مع "الطرف الثاني" على التأمين على عملائهم الحاصلين على تمويل للمشروعات متناهية الصغر لتغطية حالات الوفاة (لأي سبب) والعجز الكلي المستديم .
وتحقيقاً لتلك الرغبة فقد قبل "الطرف الثاني" إبرام هذا التأمين بالشروط والمزايا الواردة في هذا العقد .
وبعد أن أقر الطرفان بأهليتهما القانونية للتعاقد والتصرف فقد اتفقا على إبرام هذا العقد وفقاً للبنود والشروط الآتية :$b5$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $h6$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h6$, $t6$نموذج العقد - البند الأول: مرفقات العقد$t6$, $b6$يعتبر التمهيد السابق وأي ملاحق إضافية وكشوف بيانات عملاء الطرف الأول الذين يشملهم التأمين (المتضمنة الاسم وتاريخ الميلاد والرقم القومي ومبلغ التمويل ورصيد مبلغ التمويل) بعد التوقيع عليها من المتعاقد واعتمادها من شركة التأمين والأسطوانة المدمجة (CD) التي تحتوي على بيانات تلك الكشوف إن وجدت - جزءا لا يتجزأ من هذا العقد .$b6$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, $h7$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h7$, $t7$نموذج العقد - البند الثاني: تاريخ السريان$t7$, $b7$يسري هذا التأمين لمدة تبدأ من (---/-/-) وتنتهي في (---/-/-) ويجوز تجديده لمدد أخرى وبعد موافقة طرفي العقد .$b7$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, $h8$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h8$, $t8$نموذج العقد - البند الثالث: المنتفعون بالتغطية التأمينية$t8$, $b8$يشمل هذا التأمين جميع السادة العملاء المنتفعين بالتمويلات من المتعاقد (المؤمن عليهم) ، والواردة أسماؤهم وبياناتهم بالكشوف المشار إليها بالبند الأول ، وبمبلغ تأمين مساوي للرصيد المستحق من القرض ضد مخاطر الوفاة (لأي سبب) والعجز الكلي المستديم من خلال عقد تأمين جماعي على أن تشمل التغطية التأمينية العملاء حتى سن 65 عام .$b8$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins8;

WITH ins9 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 9, 0, $h9$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h9$, $t9$نموذج العقد - البند الرابع: مبلغ التأمين - نطاق التغطية التأمينية - سياسة القبول$t9$, $b9$(أ) مبلغ التأمين :
هو رصيد التمويل المستحق علي المؤمن عليه للمتعاقد ، والذي يتم إبلاغ شركة التأمين به من قبل المتعاقد وتم على أساسه سداد قسط التأمين الشهر الأخير إلى شركة التأمين .
(ب) التغطية التأمينية ومدة التأمين :
تبدأ التغطية التأمينية لكل مؤمن عليه من التاريخ المحدد بالبيانات المقدمة من المتعاقد الي شركة التأمين ، وتنتهي بانتهاء مدة التمويل .
(ج) سياسة القبول :
يتم قبول المؤمن عليهم من المتعاقد تلقائيا بدون كشف طبي ما لم يتم الاتفاق على غير ذلك وفقاً للسياسة الاكتتابية لكل شركة تأمين مع إلزام المتعاقد بإدراج كافة الحاصلين على تمويل منه دون استثناء في القائمة الدورية التي يرسلها إلى شركة التأمين .
ويحق لشركة التأمين طلب المستند الدال على العلاقة التعاقدية بين المتعاقد والعملاء المؤمن عليهم .$b9$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins9;

WITH ins10 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 10, 0, $h10$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h10$, $t10$نموذج العقد - البند الخامس: المزايا المضمونة$t10$, $b10$في حالة وفاة المؤمن عليه سواء كانت طبيعية أو بحادث أو في حالة عجزه الكلي المستديم ، تلتزم شركة التأمين بأن تدفع للمتعاقد مبلغ تأمين مساوياً للرصيد المستحق (الباقي) من مبلغ التمويل .$b10$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins10;

WITH ins11 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 11, 0, $h11$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h11$, $t11$نموذج العقد - البند السادس: الأخطار التي لا يغطيها هذا العقد$t11$, $b11$لا يغطي هذا التأمين الأخطار الآتية :
1- جريمة ينفذها الطرف المستفيد من التأمين بطريق مباشر أو غير مباشر .
2- الإشعاع النووي أو تلوث كيميائي أو بيولوجي .
3- أي حالات إصابة بالإيدز سابقة على تاريخ بدء التأمين .$b11$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins11;

WITH ins12 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 12, 0, $h12$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h12$, $t12$نموذج العقد - البند السابع: العجز الكلي المستديم$t12$, $b12$هي حالة إصابة المؤمن عليه بعجز كلي دائم غير قابل للشفاء يستمر لمدة ستة أشهر متصلة على الأقل دون تحسن ويحول كلياً بصفة مستديمة بين المؤمن عليه وبين استمراره في العمل الذي يزاوله أو أي عمل آخر يمكنه التكسب منه ، وتعتبر على الأخص الحالات الآتية من حالات العجز الكلي الدائم المغطاة بهذا التأمين :
1- فقد إبصار العينين فقداً كلياً بحيث لا يكون قابلاً للشفاء .
2- الشلل الكامل غير القابل للشفاء للذراعين أو اليدين أو فقد الذراعين أو اليدين أو بترهما .
3- الشلل الكامل غير قابل للشفاء للساقين أو القدمين أو فقد القدمين أو بترهما .
4- الشلل الكامل غير القابل للشفاء لذراع وساق أو ليد وقدم أو فقد ذراع وساق أو يد وقدم أو بترهما .$b12$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins12;

WITH ins13 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 13, 0, $h13$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h13$, $t13$نموذج العقد - البند الثامن: أقساط التأمين$t13$, $b13$1- تحتسب الأقساط لتغطية المزايا المضمنة على أساس مبالغ التمويل التي حصل عليها المؤمن عليهم ومازالت قائمة .
2- لا تكون الأقساط شاملة الرسوم والدمغات المقررة واشتراك صندوق ضمان حملة الوثائق .
3- يتم مراجعة هذا السعر في نهاية كل سنة تأمينية في ضوء نتائج العقد على أن يتم الاتفاق بين الطرفين على السعر الجديد في حالة تعديله وبعد الحصول على موافقة الهيئة .
4- جميع الرسوم والضرائب المفروضة على اختلاف أنواعها في الوقت الحاضر والتي يتم إقرارها مستقبلاً على أقساط التأمين ، يتحملها كل طرف طبقاً لأحكام القوانين واللوائح التي تصدر في هذا الشأن .
5- يجب على المتعاقد موافاة شركة التأمين ببيان شهري بالمؤمن عليهم (الحاليين - الجدد - الخارجين) ، وذلك خلال خمسة عشر يوم عمل من أول يوم من كل شهر ، وعلى أن يشمل الرصيد المستحق من القرض لكل مؤمن عليه ومبلغ التأمين الإضافي إن وجد .
6- على المتعاقد سداد الأقساط خلال ثلاثين يوماً من تاريخ الاستحقاق ، وفي حالة عدم السداد يتم إلغاء التأمين ويستحق لشركة التأمين قسط يتناسب مع الفترة المغطاة حتى تاريخ الإلغاء .$b13$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins13;

WITH ins14 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 14, 0, $h14$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h14$, $t14$نموذج العقد - البند التاسع: المستندات الواجب تقديمها$t14$, $b14$1- يقدم طلب صرف المزايا الخاصة بهذا العقد لشركة التأمين مكتوباً ، ويسلم باليد مقابل توقيع بالاستلام أو عن طريق البريد الإلكتروني ، والذي يلحقهم خطاب مسجل أو بأي وسيلة أخرى يتم الاتفاق عليها بين شركة التأمين والمتعاقد .
2- الجهة أو الشخص المخول له تقديم طلب صرف المزايا الخاصة بالعقد هو المتعاقد ، ويقدم هذا الطلب مع المستندات المؤيدة للصرف وأي مستندات أخرى تطلبها شركة التأمين بموجب هذا العقد ، وذلك في خلال فترة لا تزيد على ستة أشهر من تاريخ حدوث الخطر المسبب للمطالبة .
3- ترفق المستندات الآتية بالإضافة إلى الطلب المقدم لصرف المزايا التأمينية في حاله وفاة المؤمن عليه :
- صورة ضوئية من الرقم القومي للمؤمن عليه معتمدة من المتعاقد .
- أصل شهادة الوفاة الصادرة من الجهة المعنية موضحاً بها سبب الوفاة أو صورة منها معتمدة من المتعاقد .
- أي مستند أو دليل يكون ضرورياً لإثبات أحقية الصرف .
- كشف حساب المؤمن عليه منذ بداية التمويل وحتى تاريخ الوفاة مبيناً به الرصيد المدين .
4- ترفق المستندات الآتية بالإضافة إلى الطلب المقدم لصرف المزايا التأمينية في حالة العجز الكلي المستديم للمؤمن عليه :
- صورة ضوئية من البطاقة الشخصية للمؤمن عليه معتمدة من المتعاقد .
- تقرير طبي من جهة يتم الاتفاق عليها بين الطرفين عند التعاقد موضحاً به سبب وتاريخ العجز .
- كشف حساب المؤمن عليه منذ بداية الحصول على التمويل وحتى تاريخ حدوث العجز الكلي المستديم مبيناً به الرصيد المدين .
5- تعهد شركة التأمين في حال المطالبة وبعد تلقيها كافة المستندات المطلوبة والتحقق من صحتها وذلك وفق الجدول الزمني المتفق عليه بين الطرفين ، متضمناً ما يلي :
- تدفع شركة التأمين الرصيد المستحق من مبلغ التمويل للمتعاقد في حال المطالبة بمزايا التأمين كما هو محدد بهذه الوثيقة وفقاً لآخر رصيد تم على أساسه سداد القسط .
- في الحالات التي يثبت فيها أن رصيد التمويل الخاص بالمؤمن عليه وقت الوفاة أو العجز أقل من مبلغ التأمين المسدد عنه قسط التأمين وطالما كان التأمين سارياً تدفع شركة التأمين الفرق للمؤمن عليه أو المستفيدين الذين يحددهم وورثتهم الشرعيين وفقاً لإعلام الوراثة .
6- يقوم "المتعاقد" بإخطار "شركة التأمين " بالتعديلات التي قد تطرأ على "المؤمن عليهم شهرياً بالدخول أو بالخروج ، كما إن البيانات والإقرارات وسائر المستندات المقدمة من المتعاقد إلى شركة التأمين تُتخذ أساساً لهذا التأمين ، ويضمن المتعاقد صحتها ومطابقتها للحقيقة ، وما قد يترتب على الإخلال بذلك من آثار .$b14$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins14;

WITH ins15 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 15, 0, $h15$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h15$, $t15$نموذج العقد - البند العاشر: دفع مبالغ التأمين المستحقة$t15$, $b15$تلتزم شركة التأمين بأن تدفع المبالغ المستحقة بمقتضى هذا العقد مباشرة إلى المتعاقد أو المؤمن عليه أو المستفيدين ، كل فيما يخصه خلال مدة لا تتجاوز خمسة أيام عمل من تاريخ تقديمه كافة المستندات المبينة بالبند التاسع .$b15$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins15;

WITH ins16 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 16, 0, $h16$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h16$, $t16$نموذج العقد - البند الحادي عشر: بطلان التأمين$t16$, $b16$البيانات المقدمة من المتعاقد وكافة المستندات الأخرى المقدمة إلى شركة التأمين قد تم قبولها بمنتهي حسن النية وتعتبر أساسا لإصدار هذا العقد ، وأي خطأ جوهري في بيانات أي من المؤمن عليهم ، أو إذا كانت المعلومات تنطوي على خطأ يقصد به الغش لتضليل الشركة ، ففي هذه الحالة يبطل التأمين على المؤمن عليه الذي ورد في بياناته هذا الخطأ .$b16$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins16;

WITH ins17 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 17, 0, $h17$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h17$, $t17$نموذج العقد - البند الثاني عشر: الاختصاص القضائي$t17$, $b17$كل نزاع ينشأ - لا قدر الله - بسبب تنفيذ أو تفسير أي بند من بنود هذا العقد تختص بالفصل فيه المحكمة الاقتصادية التي تقع بدائرتها الجهة التي أصدرت هذا العقد "الطرف الثاني" وفي حالة تغيير عنوان أحد الأطراف يجب إخطار الطرف الآخر فوراً بالعنوان الجديد .$b17$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins17;

WITH ins18 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 18, 0, $h18$نموذج عقد التأمين الجماعي المرافق للقرار رقم 27 لسنة 2026$h18$, $t18$نموذج العقد - البند الثالث عشر: نسخ العقد والتوقيعات$t18$, $b18$تحرر هذا العقد من نسختين متطابقتين ، بيد كل طرف نسخة للعمل بموجبها عند اللزوم .
التوقيعات : الطرف الأول - الطرف الثاني$b18$
  FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins18;

DO $verify131$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 27 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[131] القرار 27/2026 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 19 THEN RAISE EXCEPTION '[131] عدد المواد % بدل 19', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active';
  IF v_v <> 19 THEN RAISE EXCEPTION '[131] عدد النسخ % بدل 19', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الوقائع المصریة%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[131] % مادة بها تلف (أرقام هندية/استبدال/تطويل/ترويسة)', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%2026/1/22%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[131] الديباجة غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE '%سن الخامسة والستين%' AND body LIKE '%الفئتين (أ ، ب)%') THEN RAISE EXCEPTION '[131] المادة 1 غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND body LIKE '%رقم 16 لسنة 2019%') THEN RAISE EXCEPTION '[131] المادة 3 غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND body LIKE '%د. محمد فريد صالح' AND length(body) < 400) THEN RAISE EXCEPTION '[131] المادة 4 غير سليمة أو ما زال النموذج داخلها'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 18 AND body LIKE '%التوقيعات%') THEN RAISE EXCEPTION '[131] البند 13 غير سليم'; END IF;
  IF v_len <> 9120 THEN RAISE EXCEPTION '[131] إجمالى طول المواد % بدل 9120', v_len; END IF;
  RAISE NOTICE '[131] القرار 27/2026: 19 مادة (ديباجة + 4 مواد + 14 قسما لنموذج العقد) و19 نسخة، إجمالى % حرف', v_len;
END
$verify131$;

COMMIT;
