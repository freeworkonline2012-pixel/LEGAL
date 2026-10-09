-- 133_replace_decision_78_2025_insurance_fees_and_service_charges_schedule_swallowed_in_article_2_with_preamble_two_articles_and_schedule_sections.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (78) لسنة 2025 بشأن الرسوم ومقابل
-- الخدمات المستحق على الأشخاص العاملة فى قطاع التأمين وفقاً لقانون التأمين الموحد، المنشور بالوقائع
-- المصرية، العدد 128 (تابع)، فى 12 يونية 2025 (الصفحات 44–49).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P3) =====
-- مخزَّن منذ الهجرتين 004/005 بمادتين، والمادة الثانية (النشر والتوقيع) ابتلعت جدول الرسوم المرفق كله
-- (نحو 4.6 ألف حرف) بترتيب أعمدة مبعثر: الطبقة النصية للـPDF تخلط عمودى الجدول (الخدمة/القيمة) فتنفصل
-- قيمة كل رسم عن الخدمة التى تخصها ("-مائتا ألف جنيه" بعيدة عن "مقابل فحص طلب تأسيس الشركات")، فكان
-- الاسترجاع يعطى أرقاماً لا يُعرف لأى خدمة هى. والنص بلا ديباجة، وبه أرقام هندية وترويسة الوقائع.
-- القرار ضمن نطاق الحوكمة (لا تُمس بيانات laws).
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (6 صفحات) رفعه صاحب المشروع؛ رابط laws.official_url لم يُمس. الجدول ثنائى العمود
-- (الخدمة | قيمة الرسم أو مقابل الخدمة المستحقة)؛ أعيد بناء كل صف بصرياً من صور الصفحات الست (110 dpi)
-- وقوبل بالطبقة النصية: كل بند صار "الخدمة : ..." ثم "قيمة الرسم أو مقابل الخدمة المستحقة : ..." فلا
-- ينفصل رقم عن خدمته. قُرئت كل القيم بصرياً (المبالغ بالحروف كما فى المصدر، ونسب الألف). أُبقى إملاء
-- المصدر، ومنه "أربعة آلاف جنية" فى رسم تسجيل وقيد وسطاء التأمين للأشخاص الطبيعيين.
-- وقوبل عدد كل كلمة مبلغ (ألف/آلاف/ألفا، مائة/مائتا/مائتان، العشرات، جنيه، مليون...) بين النص المخزَّن
-- والنص الجديد فتطابقت كلها؛ فالتغيير فى البنية وربط القيمة بخدمتها لا فى المبالغ.
--
-- ===== الهيكل =====
-- 9 مواد، 9 نسخ (version_no = 1): ديباجة (article_no = 0) + المادتان 1–2 + 6 أقسام لجدول الرسوم (3–8):
-- أولاً شركات التأمين وإعادة التأمين وشركات إدارة برامج الرعاية الصحية (3 بنود)، ثانياً صناديق التأمين
-- الخاصة، ثالثاً الصناديق الحكومية، رابعاً (أ) وسطاء التأمين وإعادة التأمين، رابعاً (ب) الخبراء، خامساً
-- الأجهزة المعاونة. أرقام 3–8 أقسام للجدول المرفق وليست مواداً من القرار، ويميزها hierarchical_location.
-- أُبقيت المادتان 1–2 بأرقامهما حتى لا يعيد بذر 004/005 إدراج مواد قديمة (ON CONFLICT DO NOTHING).
--
-- ===== التاريخ =====
-- effective_from = 2025-06-13: المادة الثانية تُعمل القرار من اليوم التالى لتاريخ نشره بالوقائع المصرية،
-- والنشر فى 12 يونية 2025 (ترويسة الصفحات). enacted_at يبقى NULL (لا تاريخ إصدار فى النص؛ جلستا
-- المجلس 2025/4/16 و2025/6/4 مثبتتان فى الديباجة).
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (9 مواد بديباجة سليمة والمادة 8 موجودة)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، محتوى،
-- مبالغ رئيسية، إجمالى الطول 4843 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix133$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[133] القرار 78/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 9
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[133] القرار 78/2025 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[133] أُزيلت % مادة من القرار 78/2025 (مادتان، ثانيتهما تبتلع جدول الرسوم)', v_n;
  END IF;
END
$fix133$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, NULL, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وبعد موافقة مجلس إدارة الهيئة بجلستيه المنعقدتين بتاريخى 2025/4/16 ، 2025/6/4 ؛
قرر :$b0$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$تلتزم الأشخاص العاملة فى قطاع التأمين بسداد الرسوم ومقابل الخدمات المرتبطة بمزاولة نشاطها وفقاً لأحكام قانون التأمين الموحد ، وذلك على النحو المبين بالجدول المرفق بهذا القرار .$b1$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$يُنشر هذا القرار فى الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره فى الوقائع المصرية .
رئيس مجلس إدارة الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b2$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, $h3$الجدول المرفق بالقرار رقم 78 لسنة 2025 - الرسوم ومقابل الخدمات المستحق على الأشخاص العاملة فى قطاع التأمين وفقاً لقانون التأمين الموحد$h3$, $t3$الجدول المرفق - أولاً: شركات التأمين وإعادة التأمين وشركات إدارة برامج الرعاية الصحية$t3$, $b3$1- الخدمة : مقابل فحص طلب تأسيس الشركات .
قيمة الرسم أو مقابل الخدمة المستحقة :
أولاً : شركات إعادة التأمين : مائتا ألف جنيه .
ثانياً : شركات التأمين أياً كان نوع أو صيغة مزاولة النشاط : مائة ألف جنيه .
ثالثاً : شركات التأمين الطبى المتخصصة طويلة وقصيرة الأجل : أربعون ألف جنيه .
رابعاً : شركات التأمين متناهى الصغر : عشرة آلاف جنيه .
خامساً : شركات إدارة برامج الرعاية الصحية : عشرون ألف جنيه .
2- الخدمة : رسم تسجيل شركات التأمين وإعادة التأمين المرخص لها بمزاولة نشاطها من الهيئة وفروعها الجغرافية ومنافذ تسويق وتوزيع وثائقها بالسجل المعد لذلك لدى الهيئة .
قيمة الرسم أو مقابل الخدمة المستحقة :
أولاً : شركات إعادة التأمين : مائتان وخمسون ألف جنيه عن المركز الرئيسى .
ثانياً : شركات التأمين أياً كان نوع أو صيغة مزاولة النشاط :
- مائتا ألف جنيه عن المركز الرئيسى .
- أربعون ألف جنيه عن كل فرع .
- ثمانية آلاف جنيه عن كل منفذ تسويق أو توزيع دائم لوثائق التأمين .
ثالثاً : شركات التأمين الطبى المتخصصة طويلة وقصيرة الأجل :
- ثمانون ألف جنيه عن المركز الرئيسى .
- عشرون ألف جنيه عن كل فرع .
- أربعة آلاف جنيه عن كل منفذ تسويق أو توزيع دائم لوثائق التأمين .
رابعاً : شركات التأمين متناهى الصغر :
- خمسة عشر ألف جنيه عن المركز الرئيسى .
- ثمانية آلاف جنيه عن كل فرع .
- أربعة آلاف جنيه عن كل منفذ تسويق أو توزيع وثائق .
خامساً : شركات إدارة برامج الرعاية الصحية :
- أربعون ألف جنيه عن المركز الرئيسى .
- عشرون ألف جنيه عن كل فرع .
- أربعة آلاف جنيه عن كل منفذ تسويق أو توزيع .
3- الخدمة : الرسم السنوى لمراجعة أسس تسعير المنتجات التأمينية ، وجمع وترتيب وتصنيف البيانات والمعلومات وتحليلها وإتاحتها لتنمية النشاط ، وفحص ما يرد تجاه هذه الشركات من وحملة الوثائق ومستفيدى برامج الرعاية الصحية .
قيمة الرسم أو مقابل الخدمة المستحقة :
1- اثنان ونصف فى الألف من جملة الأقساط المباشرة التى تستحق للشركة على حملة الوثائق عن السنة المالية المنقضية ، بالنسبة لعمليات التأمين المنصوص عليها فى البند أولاً من المادة (2) من قانون التأمين الموحد .
2- ستة فى الألف من جملة الأقساط المباشرة التى تستحق للشركة على حملة الوثائق عن السنة المالية المنقضية ، بالنسبة لعمليات التأمين المنصوص عليها فى البند ثانياً من المادة (2) من قانون التأمين الموحد .
3- أربعة فى الألف من جملة الأقساط المباشرة التى تستحق للشركة على حملة الوثائق عن السنة المالية المنقضية ، بالنسبة لشركات التأمين الطبى المتخصصة .
4- اثنان ونصف فى الألف من مقابل إدارة برامج الرعاية الصحية بالنسبة لشركات إدارة الرعاية الصحية وذلك عن جميع تعاقداتها .$b3$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $h4$الجدول المرفق بالقرار رقم 78 لسنة 2025 - الرسوم ومقابل الخدمات المستحق على الأشخاص العاملة فى قطاع التأمين وفقاً لقانون التأمين الموحد$h4$, $t4$الجدول المرفق - ثانياً: صناديق التأمين الخاصة$t4$, $b4$1- الخدمة : رسم قيد صندوق التأمين الخاص بالسجل لدى الهيئة .
قيمة الرسم أو مقابل الخدمة المستحقة : ألفا جنيه .
2- الخدمة : الرسم السنوى المستحق على صناديق التأمين الخاصة مقابل فحص واعتماد أسس تحديد اشتراكات وتعويضات الأعضاء بالصناديق .
قيمة الرسم أو مقابل الخدمة المستحقة :
- واحد ونصف فى الألف من جملة الاشتراكات السنوية بالنسبة لصناديق التأمين الخاصة التى يبلغ حجم أموالها خمسمائة مليون جنيه فأكثر .
- واحد فى الألف من جملة الاشتراكات بالنسبة لصناديق التأمين الخاصة التى يقل حجم أموالها عن خمسمائة مليون جنيه .$b4$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $h5$الجدول المرفق بالقرار رقم 78 لسنة 2025 - الرسوم ومقابل الخدمات المستحق على الأشخاص العاملة فى قطاع التأمين وفقاً لقانون التأمين الموحد$h5$, $t5$الجدول المرفق - ثالثاً: صناديق التأمين الحكومية$t5$, $b5$1- الخدمة : رسم تسجيل صناديق التأمين الحكومية بالسجل لدى الهيئة .
قيمة الرسم أو مقابل الخدمة المستحقة : أربعون ألف جنيه .$b5$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, $h6$الجدول المرفق بالقرار رقم 78 لسنة 2025 - الرسوم ومقابل الخدمات المستحق على الأشخاص العاملة فى قطاع التأمين وفقاً لقانون التأمين الموحد$h6$, $t6$الجدول المرفق - رابعاً: مزاولو المهن التأمينية (أ) وسطاء التأمين وإعادة التأمين$t6$, $b6$(أ) وسطاء التأمين وإعادة التأمين
1- الخدمة : مقابل فحص طلب تأسيس الشركات .
قيمة الرسم أو مقابل الخدمة المستحقة : عشرون ألف جنيه .
2- الخدمة : رسم تسجيل وقيد وسطاء التأمين وإعادة التأمين .
قيمة الرسم أو مقابل الخدمة المستحقة :
أولاً : الأشخاص الطبيعيون : أربعة آلاف جنية .
ثانياً : الأشخاص الاعتبارية :
- أربعون ألف جنيه عن المركز الرئيسى .
- ثمانية آلاف جنيه عن كل فرع .
- أربعة آلاف جنيه عن كل منفذ .
3- الخدمة : رسم تجديد قيد وسطاء التأمين وإعادة التأمين .
قيمة الرسم أو مقابل الخدمة المستحقة :
- أربعة آلاف جنيه بالنسبة للشخص الطبيعى .
- أربعون ألف جنيه بالنسبة للشخص الاعتبارى .$b6$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, $h7$الجدول المرفق بالقرار رقم 78 لسنة 2025 - الرسوم ومقابل الخدمات المستحق على الأشخاص العاملة فى قطاع التأمين وفقاً لقانون التأمين الموحد$h7$, $t7$الجدول المرفق - رابعاً: مزاولو المهن التأمينية (ب) الخبراء$t7$, $b7$(ب) خبراء تقييم الأخطار أو معاينة وتقدير الأضرار / خبراء التأمين الاستشاريون / الخبراء الاكتواريون
1- الخدمة : مقابل فحص طلب تأسيس الشركات .
قيمة الرسم أو مقابل الخدمة المستحقة : عشرة آلاف جنيه .
2- الخدمة : رسم تسجيل وقيد الخبراء .
قيمة الرسم أو مقابل الخدمة المستحقة :
أولاً : الأشخاص الطبيعيون : ألفا جنيه .
ثانياً : الأشخاص الاعتبارية :
- عشرون ألف جنيه عن المركز الرئيسى .
- أربعة آلاف جنيه عن كل فرع .
- ألفا جنيه عن كل منفذ .
3- الخدمة : رسم تجديد قيد الخبراء .
قيمة الرسم أو مقابل الخدمة المستحقة :
- ألفا جنيه بالنسبة للشخص الطبيعى .
- عشرون ألف جنيه بالنسبة للشخص الاعتبارى .$b7$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins7;

WITH ins8 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 8, 0, $h8$الجدول المرفق بالقرار رقم 78 لسنة 2025 - الرسوم ومقابل الخدمات المستحق على الأشخاص العاملة فى قطاع التأمين وفقاً لقانون التأمين الموحد$h8$, $t8$الجدول المرفق - خامساً: الأجهزة المعاونة$t8$, $b8$1- الخدمة : رسم تسجيل الأجهزة المعاونة (مثل : المعاهد التأمينية - مراكز التدريب) .
قيمة الرسم أو مقابل الخدمة المستحقة : خمسون ألف جنيه .$b8$
  FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-06-13', 'active' FROM ins8;

DO $verify133$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 78 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[133] القرار 78/2025 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 9 THEN RAISE EXCEPTION '[133] عدد المواد % بدل 9', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active';
  IF v_v <> 9 THEN RAISE EXCEPTION '[133] عدد النسخ % بدل 9', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الوقائع المصریة%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[133] % مادة بها تلف (أرقام هندية/استبدال/تطويل/ترويسة)', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%2025/4/16%' AND body LIKE '%2025/6/4%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[133] الديباجة غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE '%بالجدول المرفق بهذا القرار%') THEN RAISE EXCEPTION '[133] المادة 1 غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE '%د. محمد فريد صالح' AND length(body) < 400) THEN RAISE EXCEPTION '[133] المادة 2 غير سليمة أو ما زال الجدول داخلها'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND body LIKE '%مائتان وخمسون ألف جنيه عن المركز الرئيسى%' AND body LIKE '%ستة فى الألف%' AND body LIKE '%ثمانون ألف جنيه عن المركز الرئيسى%') THEN RAISE EXCEPTION '[133] الجدول (أولاً) غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND body LIKE '%ألفا جنيه%' AND body LIKE '%واحد ونصف فى الألف%' AND body LIKE '%خمسمائة مليون جنيه%') THEN RAISE EXCEPTION '[133] الجدول (ثانياً) غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND body LIKE '%أربعون ألف جنيه%') THEN RAISE EXCEPTION '[133] الجدول (ثالثاً) غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 6 AND body LIKE '%أربعة آلاف جنية%' AND body LIKE '%عشرون ألف جنيه%') THEN RAISE EXCEPTION '[133] الجدول (رابعاً أ) غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 7 AND body LIKE '%عشرة آلاف جنيه%' AND body LIKE '%ألفا جنيه عن كل منفذ%') THEN RAISE EXCEPTION '[133] الجدول (رابعاً ب) غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 8 AND body LIKE '%خمسون ألف جنيه%') THEN RAISE EXCEPTION '[133] الجدول (خامساً) غير سليم'; END IF;
  IF v_len <> 4843 THEN RAISE EXCEPTION '[133] إجمالى طول المواد % بدل 4843', v_len; END IF;
  RAISE NOTICE '[133] القرار 78/2025: 9 مواد (ديباجة + مادتان + 6 أقسام لجدول الرسوم) و9 نسخ، إجمالى % حرف', v_len;
END
$verify133$;

COMMIT;
