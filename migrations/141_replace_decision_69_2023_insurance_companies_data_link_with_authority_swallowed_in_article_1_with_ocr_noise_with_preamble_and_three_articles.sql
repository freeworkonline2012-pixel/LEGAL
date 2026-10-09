-- 141_replace_decision_69_2023_insurance_companies_data_link_with_authority_swallowed_in_article_1_with_ocr_noise_with_preamble_and_three_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (69) لسنة 2023 (بتاريخ 2023/3/29) بشأن
-- التزام شركات التأمين بتوفير البنية التكنولوجية اللازمة لربط قاعدة بياناتها مع قاعدة بيانات الهيئة،
-- المنشور بالوقائع المصرية، العدد 85 (تابع)، فى 11 أبريل 2023 (الصفحتان 8 و9).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2) =====
-- مخزَّن منذ الهجرات 004/005/006 من تفريغ مسح ضوئى (OCR) تالف: المادة الأولى ابتلعت المادتين الثانية والثالثة
-- والتوقيع (والمادتان 2 و3 مكررتان بصفوف مستقلة)، وفيها ترويسة الوقائع مشوَّهة ("العدد 65 ... ٠١571 3")،
-- وترقيم البنود مشوَّه ("-١" مكررة، "5" بدل 6، "- بيانات مقار" بلا رقم وبعض "5" بدل "7")، ونص المادة الثانية
-- فاسد ("وافقًا الأحكانة" و"مد لاه ألبيلة اللستة سير أقوىبالنسبة" و"(" 5٠ 56 16)" بدل "لأحكامه" و"هذه
-- المهلة لستة أشهر أخرى بالنسبة" و"(3 ، 4 ، 5 ، 6)")، وعناوين المواد مكسورة ("الشانية" و"الشالشة")،
-- وبلا ديباجة. وفى laws: enacted_at = 7117-04-11 (سنة 7117 من قراءة الأرقام الهندية خطأً، وهو تاريخ
-- نشر الوقائع 2023-04-11) — لم يُمس هنا ويُصحَّح فى هجرة بيانات laws لاحقة.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحتان، مسح ضوئى بلا طبقة نصية) رفعه صاحب المشروع؛ رابط laws.official_url يحمل
-- الاسم نفسه ولم يُمس. قُرئت الصفحتان بصرياً (130 dpi) كلمةً كلمة وقوبلتا بالنص المخزَّن؛ الأعداد المقروءة
-- (قانون 10 لسنة 1981، قانون 10 لسنة 2009، جلسة المجلس 2023/3/29، ستة أشهر، البنود 3-6) مطابقة للمخزَّن
-- حيث سلم. الأرقام الهندية حُوِّلت إلى لاتينية. حُذفت ترويسة الوقائع (العدد وتاريخه ورقم الصفحة) والشعار،
-- ويُحفظ عنوان القرار وتاريخه فى hierarchical_location للديباجة. الحرف "قـــرر :" كُتب "قرر :".
--
-- ===== الهيكل =====
-- 4 مواد، 4 نسخ (version_no = 1): ديباجة (article_no = 0) بثلاثة اطلاعات وجلسة المجلس، المادة الأولى
-- (الالتزام بالربط التكنولوجى، البيانات الثمانية المطلوب إتاحتها، سريتها)، المادة الثانية (مهلة ستة أشهر
-- وجواز مدها ستة أخرى للبنود 3-6)، المادة الثالثة (النشر والعمل من اليوم التالى للنشر، مع التوقيع).
-- أُبقيت المواد 1-3 بأرقامها حتى لا تعيد بذور 004/005/006 إدراج مواد قديمة (ON CONFLICT DO NOTHING).
--
-- ===== التاريخ =====
-- effective_from = 2023-04-12: المادة الثالثة تُعمل القرار من اليوم التالى لتاريخ نشره بالوقائع المصرية،
-- والنشر فى 11 أبريل 2023 (ترويسة الصفحة). كان القديم تاريخ تشغيل البذر لا تاريخ سريان.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (4 مواد بديباجة سليمة والمادة 3 موجودة)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، ترويسة أو
-- بقايا OCR، محتوى، إجمالى الطول 1760 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix141$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 69 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[141] القرار 69/2023 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 4
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[141] القرار 69/2023 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[141] أُزيلت % مادة من القرار 69/2023 (مادة أولى ابتلعت المادتين 2 و3 مع بقايا OCR)', v_n;
  END IF;
END
$fix141$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 69 لسنة 2023 بتاريخ 2023/3/29 بشأن التزام شركات التأمين بتوفير البنية التكنولوجية اللازمة لربط قاعدة بياناتها مع قاعدة بيانات الهيئة$h0$, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على قانون الإشراف والرقابة على التأمين فى مصر الصادر بالقانون رقم 10 لسنة 1981 ولائحته التنفيذية ؛
وعلى القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2023/3/29 ؛
قرر :$b0$
  FROM laws WHERE law_no = 69 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-04-12', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$تلتزم شركات التأمين بتوفير البنية التكنولوجية اللازمة لربط قاعدة بياناتها مع قاعدة بيانات الهيئة وفقاً للضوابط التى تحددها الهيئة فى هذا الشأن .
وتلتزم شركات التأمين المشار إليها بإتاحة البيانات التالية للهيئة من خلال النظم الالكترونية التى يتم إعدادها وفقاً للفقرة الأولى من هذه المادة :
1- بيانات الأشخاص الذين تم رفض التعاقد معهم وأسباب الرفض .
2- بيانات العملاء المتعثرين والمتوقفين عن سداد القروض فى حالات تأمين الائتمان .
3- البيانات الخاصة بسجل الإصدار ، بما فى ذلك بيانات إصدار الوثائق وتعديلها وإلغائها ، وتسويات الإصدار ، وتحصيل الأقساط .
4- البيانات الخاصة بسجل التعويضات ، بما فى ذلك بيانات الإخطار ، وسداد التعويضات وتسويتها .
5- البيانات الخاصة بسجل الأموال المخصصة (ربط الأموال بأنواعها ، إيرادات الأموال ، المصروفات المتعلقة بالأموال) .
6- البيانات الخاصة بسجل اتفاقيات إعادة التأمين وسجل العمليات الاختيارية وأرصدة معيدى التأمين الدائنة والمدينة .
7- بيانات مقار وفروع الشركة .
8- أى بيانات أخرى تطلبها الهيئة .
وتكون البيانات والمعلومات الخاصة بالعملاء والشركات أعلاه سرية ولا يجوز إتاحتها إلا للهيئة ، وتضع الهيئة الضوابط الخاصة بالتعامل عليها .$b1$
  FROM laws WHERE law_no = 69 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-04-12', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$تمنح شركات التأمين المخاطبة بأحكام هذا القرار مهلة لمدة ستة أشهر لتوفيق أوضاعها وفقاً لأحكامه ، ويجوز مد هذه المهلة لستة أشهر أخرى بالنسبة للبنود (3 ، 4 ، 5 ، 6) الواردة بالمادة الأولى من هذا القرار ، وذلك فى ضوء المبررات التى تقدمها الشركة وتقبلها الهيئة .$b2$
  FROM laws WHERE law_no = 69 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-04-12', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3$المادة الثالثة$t3$, $b3$ينشر هذا القرار فى الوقائع المصرية وعلى الموقع الالكترونى للهيئة ، ويعمل به من اليوم التالى لتاريخ نشره .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د/ محمد فريد صالح$b3$
  FROM laws WHERE law_no = 69 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-04-12', 'active' FROM ins3;

DO $verify141$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 69 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[141] القرار 69/2023 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 4 THEN RAISE EXCEPTION '[141] عدد المواد % بدل 4', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2023-04-12';
  IF v_v <> 4 THEN RAISE EXCEPTION '[141] عدد النسخ % بدل 4', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%العدد%' OR body LIKE '%الأحكانة%' OR body LIKE '%اللستة%' OR body LIKE '%الشانية%' OR body LIKE '%الشالشة%' OR body LIKE '%وافقًا%' OR body LIKE '%صالع%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[141] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%رقم 10 لسنة 1981%' AND body LIKE '%رقم 10 لسنة 2009%' AND body LIKE '%بتاريخ 2023/3/29 ؛%' AND body LIKE '%قرر :') THEN RAISE EXCEPTION '[141] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE 'تلتزم شركات التأمين بتوفير%' AND body LIKE '%1- بيانات الأشخاص الذين تم رفض التعاقد معهم وأسباب الرفض .%' AND body LIKE '%5- البيانات الخاصة بسجل الأموال المخصصة (ربط الأموال بأنواعها ، إيرادات الأموال ، المصروفات المتعلقة بالأموال) .%' AND body LIKE '%6- البيانات الخاصة بسجل اتفاقيات إعادة التأمين%المدينة .%' AND body LIKE '%7- بيانات مقار وفروع الشركة .%' AND body LIKE '%8- أى بيانات أخرى تطلبها الهيئة .%' AND body LIKE '%سرية ولا يجوز إتاحتها إلا للهيئة%' AND body LIKE '%عليها .') THEN RAISE EXCEPTION '[141] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE 'تمنح شركات التأمين%' AND body LIKE '%مهلة لمدة ستة أشهر%' AND body LIKE '%وفقاً لأحكامه%' AND body LIKE '%لستة أشهر أخرى%' AND body LIKE '%(3 ، 4 ، 5 ، 6)%' AND body LIKE '%وتقبلها الهيئة .') THEN RAISE EXCEPTION '[141] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND body LIKE 'ينشر هذا القرار فى الوقائع المصرية%' AND body LIKE '%من اليوم التالى لتاريخ نشره .%' AND body LIKE '%د/ محمد فريد صالح') THEN RAISE EXCEPTION '[141] المادة 3 غير سليم'; END IF;
  IF v_len <> 1760 THEN RAISE EXCEPTION '[141] إجمالى طول المواد % بدل 1760', v_len; END IF;
  RAISE NOTICE '[141] القرار 69/2023: 4 مواد و4 نسخ، إجمالى % حرف', v_len;
END
$verify141$;

COMMIT;
