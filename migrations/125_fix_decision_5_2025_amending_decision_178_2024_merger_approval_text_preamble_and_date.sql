-- 125_fix_decision_5_2025_amending_decision_178_2024_merger_approval_text_preamble_and_date.sql
--
-- إصلاح نص قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (5) لسنة 2025 بتعديل قرار مجلس إدارة الهيئة
-- رقم (178) لسنة 2024 بشأن ضوابط موافقة الهيئة على التملك أو السيطرة أو الاندماج للشركات العاملة فى مجال
-- الأنشطة المالية غير المصرفية، المنشور بالوقائع المصرية، العدد 33 (تابع أ)، فى 10 فبراير 2025، ص 2-3.
--
-- ===== الحالة السابقة =====
-- مادتان مُستخرَجتان من الطبقة النصية للـPDF: ترويسة الوقائع المتسرِّبة وسط المادة الأولى ("٣ الوقائع
-- المصریة – العدد ٣٣تابع )أ( فى ١٠فبرایر سنة ٢٠٢٥" بالياء الفارسية)، وأرقام هندية ملتصقة بالكلمات
-- ("رقم ١٧٨لسنة ۲۰۲٤المشار")، وحروف مفككة ("وفقا ً")، وفواصل ملتصقة بالكلمة السابقة، وتوقيع "د /محمد"،
-- وبلا ديباجة (أساس الإصدار وموافقة المجلس) وبلا عناوين المواد ("المادة الأولى"، "المادة الثانية")، وتاريخ
-- سريان النسختين = تاريخ البذر (now) لا تاريخ النشر. النص الجوهرى (الفقرتان المضافتان للمادة السابعة)
-- كان مقروءاً لكنه غير نظيف.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحتان) رفعه صاحب المشروع (5.pdf)؛ الرابط المخزَّن فى laws.official_url يحمل
-- اسم الملف نفسه ولم يُمس. الصفحتان رقميتان (طبقة نصية)، قُرئتا بصرياً وقوبلتا بالطبقة
-- النصية كلمةً كلمة؛ أُبقى إملاء المصدر والأرقام الهندية محوَّلة إلى لاتينية. أُضيفت الديباجة كمادة
-- article_no=0 على نمط 113/119/122، وعناوين المواد (المادة الأولى/الثانية) فى حقل title.
--
-- ===== التاريخ (قرار موثَّق) =====
-- المادة الثانية: "ويُعمل به من اليوم التالى لتاريخ نشره"، والنشر بالوقائع المصرية 10 فبراير 2025 (من
-- ترويسة الصفحة) => effective_from = 2025-02-11 (نفس منطق 119/121). enacted_at يبقى NULL (لا تاريخ إصدار
-- فى النص؛ 2025/1/15 هو جلسة موافقة المجلس).
--
-- ===== ملاحظة على القرار المعدَّل (178/2024) =====
-- هذا القرار يضيف فقرتين (الثانية والثالثة) إلى المادة السابعة من قرار 178/2024، وهذا القرار الأم غير
-- موجود فى قاعدة البيانات أصلاً (لا صف 178/2024 فى laws)، فلا يمكن تطبيق التعديل كنسخة جديدة على مادة
-- المادة السابعة. يلزم نص 178/2024 الرسمى لإضافته ثم تطبيق نسخة المادة السابعة المعدَّلة (نمط هجرة 119).
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بوجود أرقام هندية/ياء فارسية/حروف مفككة فى المادتين المخزَّنتين (الصيغة الجديدة بلا شىء
-- من ذلك)، والإدراج بـON CONFLICT DO NOTHING (هجرة 006 تعيد إدراج المادتين القديمتين فتتعارضان مع
-- الجديدتين فلا تُضافان)، وتحقق الختام محصور فى هذا القرار.
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix125$
DECLARE
  v_law_id uuid;
  v_bad int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 5 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[125] القرار 5/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  SELECT count(*) INTO v_bad FROM articles
   WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no IN (1, 2) AND (body ~ '[٠-٩]' OR body LIKE '%الوقائع المصر' || chr(1740) || 'ة%' OR body LIKE '%وفقا ً%' OR body LIKE '%' || chr(65533) || '%');
  IF v_bad > 0 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no IN (1, 2);
    RAISE NOTICE '[125] أُزيلت مادتا 5/2025 غير النظيفتين (% بهما تلف)', v_bad;
  ELSE
    RAISE NOTICE '[125] لا أثر تلف فى 5/2025 — تخطّى الحذف';
  END IF;
END
$fix125$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, NULL, 'ديباجة القرار', $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 178 لسنة 2024 بشأن ضوابط موافقة الهيئة على التملك أو السيطرة أو الاندماج للشركات العاملة في مجال الأنشطة المالية غير المصرفية ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/1/15 ؛
قرر :$b0$
  FROM laws WHERE law_no = 5 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-11', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$تضاف فقرتان جديدتان إلى المادة السابعة من قرار مجلس إدارة الهيئة رقم 178 لسنة 2024 المشار إليه ، نصهما الآتي :
(المادة السابعة / الفقرة الثانية) :
ومع عدم الإخلال بالفقرة السابقة، في حال رغبة شركتين أو أكثر من شركات التأمين التي تزاول نفس نوع النشاط في مصر في الاندماج ، فيجب الحصول على موافقة الجمعية العامة غير العادية لتلك الشركات على الاندماج بشكل نهائي ، وإذا كان الاندماج سيتم بناءً على عملية استحواذ فيجب موافقة الجمعية العامة غير العادية للشركات الراغبة في الاندماج على النحو المشار إليه خلال شهرين من تاريخ الاستحواذ وأن يكون الاستحواذ بالنسب التي تمكن الشركة من السير في إجراءات الاندماج سواء تم الاستحواذ من خلال اتفاق مع مساهم بمفرده أو مع أطرافه المرتبطة أو أي مساهمين آخرين على أن يتم تنفيذ الاندماج خلال ستة أشهر بحد أقصى من تاريخ تقديم الطلب للهيئة ، ويجوز للهيئة مد هذه المدة بناءً على مبررات تقدمها الشركة وتقبلها الهيئة . ولا يجوز خلال الفترة من تاريخ الاستحواذ وحتى إتمام الاندماج التصرف في الأسهم المستحوذ عليها أو التصويت بها إلا لأغراض الاندماج أو لتسيير أعمال الشركة وفقاً للتشريعات المعمول بها مع وجوب الحصول على عدم ممانعة مسبقة من الهيئة بشأن الدعوة لاجتماع الجمعية العامة المشار إليها .
(المادة السابعة / الفقرة الثالثة) :
وفي حال مخالفة الفقرة السابقة، توقف حقوق التصويت وتوزيعات الأرباح الخاصة بأسهم الشركة المستحوذة في الشركة المستحوذ عليها ، ويتعين على الشركة المستحوذة في هذه الحالة التصرف في النسبة المشتراة خلال ثلاثة أشهر من تاريخ المخالفة، وإلا كان للهيئة الأمر بتعيين إحدى شركات السمسرة في الأوراق المالية لتولي إجراءات بيع الأسهم المشتراة على أن تؤول حصيلة البيع للمساهم بعد خصم المصروفات .$b1$
  FROM laws WHERE law_no = 5 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-11', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة والبورصة المصرية ، ويُعمل به من اليوم التالي لتاريخ نشره .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b2$
  FROM laws WHERE law_no = 5 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-11', 'active' FROM ins2;

DO $verify125$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_content int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 5 AND law_year = 2025 AND kind = 'board_decision';
  SELECT count(*), COALESCE(sum(length(body)),0), count(*) FILTER (WHERE (body ~ '[٠-٩]' OR body LIKE '%الوقائع المصر' || chr(1740) || 'ة%' OR body LIKE '%وفقا ً%' OR body LIKE '%' || chr(65533) || '%') OR body LIKE '%د /محمد%'),
         count(*) FILTER (WHERE (article_no = 0 AND strpos(body, 'رقم 178 لسنة 2024') > 0 AND strpos(body, 'بتاريخ 2025/1/15') > 0)
                             OR (article_no = 1 AND strpos(body, '(المادة السابعة / الفقرة الثانية) :') > 0
                                 AND strpos(body, '(المادة السابعة / الفقرة الثالثة) :') > 0
                                 AND strpos(body, 'ستة أشهر بحد أقصى') > 0
                                 AND strpos(body, 'ثلاثة أشهر من تاريخ المخالفة') > 0)
                             OR (article_no = 2 AND strpos(body, 'من اليوم التالي لتاريخ نشره') > 0 AND strpos(body, 'محمد فريد صالح') > 0))
    INTO v_arts, v_len, v_bad, v_content FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2025-02-11' AND av.status = 'active';
  IF v_arts <> 3 OR v_vers <> 3 THEN
    RAISE EXCEPTION '[125] متوقَّع 3 مواد و3 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_content <> 3 THEN
    RAISE EXCEPTION '[125] فشل التحقق من المحتوى (تلف=%, محتوى=%)', v_bad, v_content;
  END IF;
  IF v_len <> 2108 THEN
    RAISE EXCEPTION '[125] مجموع الأطوال % لا يطابق المتوقع 2108', v_len;
  END IF;
  RAISE NOTICE '[125] قرار 5/2025: % مواد و% نسخ سليمة.', v_arts, v_vers;
END
$verify125$;

COMMIT;
