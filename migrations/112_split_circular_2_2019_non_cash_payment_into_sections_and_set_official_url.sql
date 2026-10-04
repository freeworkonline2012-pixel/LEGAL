-- 112_split_circular_2_2019_non_cash_payment_into_sections_and_set_official_url.sql
--
-- إصلاح عيب "المادة الواحدة" للكتاب الدورى رقم (2) لسنة 2019 الصادر عن الهيئة
-- العامة للرقابة المالية بتاريخ 26/5/2019 بشأن تنظيم استخدام وسائل الدفع غير
-- النقدى فى إتمام المعاملات المالية للمؤسسات المالية غير المصرفية، وتسجيل
-- رابطه الرسمى.
--
-- ===== الحالة السابقة =====
-- (1) متن الكتاب مخزَّن مادة واحدة (article_no=1، 4,942 حرفاً) بهجرة 015.
-- (2) laws.official_url = NULL (لا رابط رسمى للمصدر).
-- (3) تاريخ الصدور صُحِّح بهجرة 111 من 6/5/2019 إلى 26/5/2019.
--
-- ===== المصدر =====
-- الوثيقة الرسمية المنشورة على موقع الهيئة (PDF ممسوح ضوئياً، 3 صفحات):
--   https://fra.gov.eg/wp-content/uploads/fra_live_data/pdfs/UG47005_UG47006.pdf
-- (الرابط قدَّمه صاحب المشروع، وتحقَّقتُ من أنه يُحمَّل من النطاق الرسمى
-- fra.gov.eg وبنفس اسم الملف الذى رُفع). نصّ الأقسام أدناه هو نصّ المتن
-- المخزَّن حرفياً، وقد سبق التحقق بصرياً أنه مطابق للنسخة الممسوحة (الفارق
-- الوحيد كان تاريخ الصدور المكتوب بخط اليد وعولج فى 111). لم يُعدَّل أى حرف.
--
-- ===== المعالجة =====
-- تقسيم المتن إلى 7 أقسام وفق عناوين الكتاب نفسها (لا اختلاق مواد: الكتاب
-- الدورى لا يحوى "مواد" مرقَّمة، فالترقيم 1-7 ترتيب أقسام فقط، وتُحفظ
-- عناوينها الأصلية فى الحقل title). دمج الأقسام بالترتيب بفاصل سطر فارغ
-- يعيد المتن الأصلى حرفاً بحرف (تُحقِّق الاختبار المحلى من ذلك).
--
-- قابلة لإعادة التشغيل (idempotent): الحذف مشروط بوجود مادة واحدة فقط،
-- والإدراج محمى بـON CONFLICT DO NOTHING، وتحقق الختام محصور فى هذا الكتاب.
--
-- ملاحظة تشغيلية: الأقسام الجديدة تُنشأ بلا embedding؛ يلزم تشغيل
-- scripts/backfill-embeddings.js بعد النشر لتفعيل البحث الدلالى عليها.

BEGIN;

DO $fix112$
DECLARE
  v_law_id uuid;
  v_cnt int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[112] الكتاب الدورى 2/2019 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  SELECT count(*) INTO v_cnt FROM articles WHERE law_id = v_law_id;
  IF v_cnt = 1 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0;
    RAISE NOTICE '[112] أُزيلت المادة الواحدة القديمة';
  ELSIF v_cnt = 7 THEN
    RAISE NOTICE '[112] 7 أقسام موجودة بالفعل — تخطّى الحذف';
  ELSE
    RAISE WARNING '[112] عدد مواد غير متوقَّع (%) — راجع يدوياً', v_cnt;
  END IF;
END
$fix112$;

UPDATE laws SET official_url = 'https://fra.gov.eg/wp-content/uploads/fra_live_data/pdfs/UG47005_UG47006.pdf'
WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular' AND official_url IS DISTINCT FROM 'https://fra.gov.eg/wp-content/uploads/fra_live_data/pdfs/UG47005_UG47006.pdf';

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, 'الكتاب الدورى رقم 2 لسنة 2019', 'تمهيد وأساس الإصدار', $b1$فى إطار حرص الهيئة على نشر الوعى بأهم المستحدثات التنظيمية بالقطاع المالي المصري، ومع صدور القانون رقم (18) لسنة 2019 بشأن تنظيم استخدام وسائل الدفع غير النقدي بتاريخ 16 أبريل 2019، وحيث أناط القانون المخاطبين به العمل على توفيق أوضاعهم وفقاً لأحكامه خلال 6 أشهر من تاريخ العمل بلائحته التنفيذية، وإعمالاً لمتطلبات القانون المذكور فقد ارتأت الهيئة العامة للرقابة المالية تيسيراً على الجهات الخاضعة لإشرافها فى تقديم الخدمات المالية غير المصرفية بالأسواق المختلفة إصدار هذا الكتاب الدوري عملاً على توضيح متطلبات تطبيق القانون على كافة الأطراف المتعاملة فى هذه الأسواق والالتزامات المترتبة عليه، وذلك على النحو التالي:$b1$
  FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2019-05-26', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, 'الكتاب الدورى رقم 2 لسنة 2019', 'الفئات المخاطبة بالقانون والعاملة فى الأنشطة المالية غير المصرفية', $b2$الفئات المخاطبة بالقانون والعاملة فى الأنشطة المالية غير المصرفية:
• كافة الشركات والجهات الخاضعة لإشراف ورقابة الهيئة العامة للرقابة المالية.
• كافة المتعاملين مع الشركات والجهات الخاضعة لإشراف الهيئة العامة للرقابة المالية سواء كانوا أشخاص اعتباريين أو أشخاص طبيعيين.$b2$
  FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2019-05-26', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, 'الكتاب الدورى رقم 2 لسنة 2019', 'مفهوم وسائل الدفع غير النقدي', $b3$مفهوم وسائل الدفع غير النقدي:
المقصود بها كل وسيلة دفع ينتج عنها إضافة فى أحد الحسابات المصرفية للمستفيد، مثل أوامر الإيداع والتحويل والخصم وبطاقات الائتمان والخصم، والدفع باستخدام الهاتف المحمول، أو غيرها من الوسائل التي يُقرها محافظ البنك المركزي المصري. ولا يُعد من بينها القيام بالإيداع النقدي المباشر لدى البنك الذي يحتفظ لديه بحساب الشركة أو الجهة المالية غير المصرفية التي سيتم التعامل معها.$b3$
  FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2019-05-26', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, 'الكتاب الدورى رقم 2 لسنة 2019', 'الحساب المصرفي', $b4$الحساب المصرفي:
عقد يتفق بمقتضاه شخص طبيعي أو اعتباري مع أحد البنوك المسجلة لدى البنك المركزي أو إحدى الجهات المصرح لها بمباشرة نشاط الإيداع أو الائتمان فى جمهورية مصر العربية على فتح حساب يستخدم فى قيد جميع العمليات لسداد واستلام وتسوية المدفوعات المتبادلة نقداً أو عن طريق الوحدات النقدية الإلكترونية، مثل: الحساب الجاري، وحساب التوفير، وحساب الوديعة لأجل، وحساب الدفع باستخدام الهاتف المحمول، والحسابات المرتبطة ببطاقات الائتمان، والبطاقات مسبقة الدفع.$b4$
  FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2019-05-26', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, 'الكتاب الدورى رقم 2 لسنة 2019', 'نطاق الالتزام بوسائل الدفع غير النقدي: أولاً - سداد المدفوعات', $b5$نطاق الالتزام بوسائل الدفع غير النقدي فى المعاملات المالية:
تلتزم الشركات والجهات الخاضعة لرقابة وإشراف الهيئة على اختلاف أنواعها بما يلي:

أولاً: سداد المدفوعات التالية بوسائل الدفع غير النقدي، متى تجاوزت قيمتها الحدود التي تبينها اللائحة التنفيذية لهذا القانون:
1) منح التمويل النقدي، وهو التمويل المقدم من شركات التمويل العقاري أو التأجير التمويلي أو التخصيم أو شركات وجمعيات التمويل متناهي الصغر، أو أية جهة مالية غير مصرفية.
2) مستحقات الموردين والمقاولين ومقدمي الخدمات وغيرهم من المتعاقدين معها.
3) توزيع الأرباح الناتجة عن المساهمة في رؤوس أموال الشركات أو صناديق الاستثمار.
4) صرف مستحقات أعضاء النقابات ومستحقات المشتركين بصناديق التأمين الخاصة وتعويضات التأمين.
5) صرف الإعانات والتبرعات بواسطة الجمعيات والمؤسسات العاملة في مجال العمل الأهلي، أو غيرها من الأشخاص الاعتبارية الخاصة والمنشآت بمختلف أنواعها.
6) سداد المقابل في حالات الشراء، أو الإيجار، أو الاستغلال، أو الانتفاع بالأراضي، أو العقارات، أو مركبات النقل السريع.
7) مستحقات العاملين بها والخبراء ورؤساء وأعضاء مجالس الإدارات واللجان، واشتراكات التأمينات الاجتماعية، وذلك متى جاوز عدد العاملين بها أو إجمالي قيمة أجورهم الشهرية الحدود التي تبينها اللائحة التنفيذية لهذا القانون.$b5$
  FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2019-05-26', 'active' FROM ins5;

WITH ins6 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 6, 0, 'الكتاب الدورى رقم 2 لسنة 2019', 'نطاق الالتزام بوسائل الدفع غير النقدي: ثانياً - تحصيل المدفوعات', $b6$ثانياً: تحصيل المدفوعات التالية بوسائل الدفع غير النقدي، متى جاوزت قيمتها الحدود التي تبينها اللائحة التنفيذية لهذا القانون:
1) أقساط التمويل النقدي، وأقساط وثائق التأمين، واشتراكات النقابات، واشتراكات صناديق التأمين الخاصة.
2) تلقى الإعانات والتبرعات بواسطة الجمعيات والمؤسسات العاملة في مجال العمل الأهلي، أو غيرها من الأشخاص الاعتبارية الخاصة والمنشآت بمختلف أنواعها.
3) تحصيل المقابل في حالات البيع أو الإيجار أو الاستغلال أو الانتفاع بالأراضي أو العقارات أو مركبات النقل السريع.
4) الغرامات.
وغيرها من المستحقات للشركات والجهات العاملة في الأنشطة المالية غير المصرفية.$b6$
  FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2019-05-26', 'active' FROM ins6;

WITH ins7 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 7, 0, 'الكتاب الدورى رقم 2 لسنة 2019', 'التحذير وخطة توفيق الأوضاع والتوقيع', $b7$هذا، ودرءاً لتعرض أياً من الجهات الخاضعة لإشراف ورقابة الهيئة أو المسئولين عنها من الأشخاص الطبيعيين للعقوبات والغرامات التي وردت بمواد القانون رقمي (8،7)، فإنه تؤكد الهيئة على كافة الجهات والتي تؤدى معاملاتها المالية باستخدام وسائل الدفع النقدي سرعة العمل على تفعيل خطة توفيق أوضاعها مع القانون على النحو الاسترشادي التالي:

المرحلة الأولى: بدء الجهة عمليات التشاور واختيار مقدمي خدمات الدفع غير النقدي الذين سيتم التعاقد معهم لتنفيذ مدفوعات السداد والمتحصلات سالفة الذكر من خلالهم، وذلك في حالة إذا كان المتعاملين مع الجهة ليس لديهم حسابات مصرفية قائمة أو غيرها من وسائل الدفع غير النقدي مثل بطاقات الائتمان والخصم، والدفع باستخدام الهاتف المحمول، والبطاقات مسبقة الدفع.

المرحلة الثانية: توقيع الجهة التعاقد مع مقدمي خدمات الدفع غير النقدي، والحصول على موافقة الهيئة المسبقة والمطلوبة فقط للجهات المرخص لها بمزاولة نشاط التمويل متناهي الصغر فى شأن تفعيل معاملات الدفع غير النقدي لعملائها.

المرحلة الثالثة: تشغيل تجريبي لكافة خدمات الدفع غير النقدي وبدء خطة التوعية للعملاء وأصحاب المصلحة.

المرحلة الرابعة: بدء تنفيذ عمليات التحصيل غير النقدي لمدفوعات الجهة.

المرحلة الخامسة: بدء تنفيذ عمليات الصرف/ السداد غير النقدي لمدفوعات الجهة.

المرحلة السادسة: التوافق التام لإتمام كافة المدفوعات (السداد والتحصيل) بوسائل الدفع غير النقدي ومعالجة كافة المعوقات.

وعلى أن يتم الانتهاء من خطة توفيق الأوضاع فى فترة أقصاها التاريخ المحدد لبدء العمل باللائحة التنفيذية لقانون وسائل الدفع غير النقدي رقم 18 لسنة 2019.

رئيس مجلس إدارة الهيئة العامة للرقابة المالية
د. محمد عمران$b7$
  FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2019-05-26', 'active' FROM ins7;

DO $verify112$
DECLARE
  v_law_id uuid;
  v_url text;
  v_arts int;
  v_vers int;
  v_len int;
BEGIN
  SELECT id, official_url INTO v_law_id, v_url FROM laws WHERE law_no = 2 AND law_year = 2019 AND kind = 'circular';
  SELECT count(*), COALESCE(sum(length(body)),0) INTO v_arts, v_len FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
    WHERE a.law_id = v_law_id AND av.effective_from = DATE '2019-05-26';
  IF v_url IS DISTINCT FROM 'https://fra.gov.eg/wp-content/uploads/fra_live_data/pdfs/UG47005_UG47006.pdf' THEN
    RAISE EXCEPTION '[112] official_url غير مطابق: %', v_url;
  END IF;
  IF v_arts <> 7 OR v_vers <> 7 THEN
    RAISE EXCEPTION '[112] متوقَّع 7 أقسام و7 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_len <> 4930 THEN
    RAISE EXCEPTION '[112] مجموع أطوال الأقسام % لا يطابق المتوقع 4930', v_len;
  END IF;
  RAISE NOTICE '[112] الكتاب الدورى 2/2019: % أقسام و% نسخ، والرابط الرسمى مسجَّل.', v_arts, v_vers;
END
$verify112$;

COMMIT;
