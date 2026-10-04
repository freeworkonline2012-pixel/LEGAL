-- 119_fix_decision_3_2026_and_apply_its_amendment_to_decision_2_2025_article_4_item_5.sql
--
-- (أ) إصلاح نص قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (3) لسنة 2026
--     (بتعديل القرار رقم 2 لسنة 2025 بشأن قواعد وضوابط ونسب استثمار أموال شركات التأمين وإعادة التأمين)،
--     المنشور بالوقائع المصرية، العدد 27 تابع (ب)، فى 3 فبراير 2026، ص 3-4.
-- (ب) تطبيق أثره الموضوعى: استبدال نص البند (5) من المادة الرابعة من القرار 2/2025 (إضافة نسخة ثانية).
--
-- ===== الحالة السابقة =====
-- (أ) القرار 3/2026 مخزَّن (هجرات 004/005/006) بمادتين من الطبقة النصية للـPDF: ترويسة الصفحة
--     ("الوقائع المصریة - العدد ٢٧ تابع ...") متسرِّبة فى منتصف نص المادة الأولى، والأقواس والأرقام
--     معكوسة ("البند ) (٥من"، "-٥إذا"، "المادة ) (۱۷٥")، وبلا ديباجة، وتاريخ سريان نسخهما = تاريخ البذر
--     (now) لا تاريخ السريان الحقيقى.
-- (ب) القرار 3/2026 يستبدل بند الاستكمال (5) من المادة الرابعة من القرار 2/2025: المهلة كانت "ستة أشهر
--     من تاريخ الإخطار الذى ترسله الهيئة الى الشركة" فصارت "ثلاثة أشهر من التاريخ المحدد لتقديم
--     المركز المالى الذى تحقق فيه العجز". والمنصة (بعد هجرة 115) ما زالت تُجيب بالنص القديم (ستة أشهر)
--     رغم أنه لم يعد سارياً منذ 2026-02-04 — وهذا خطأ جوهرى فى الإجابة وليس شكلياً.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحتان) رفعه صاحب المشروع (alamiria_2026_3.pdf). قُرئت الصفحتان بصرياً بتكبير
-- 130 dpi وقوبلتا كلمةً كلمة بالطبقة النصية؛ واستُبدلت الأرقام الهندية بلاتينية واتُّبع إملاء 113/115.
-- ديباجة القرار (أساس الإصدار وموافقة المجلس بتاريخ 2026/1/14) مادة article_no=0 على نمط 059/113.
-- نص البند (5) الجديد مأخوذ من متن المادة الأولى للقرار نفسه (ثابت واحد يُستعمل فى الموضعين).
--
-- ===== التواريخ =====
-- effective_from = 2026-02-04: المادة الثانية تنص على العمل به من اليوم التالى لتاريخ نشره، والنشر
-- 3 فبراير 2026 (ترويسة الصفحة). enacted_at يبقى NULL: النص لا يذكر تاريخ إصدار (2026/1/14 هو جلسة
-- موافقة المجلس لا تاريخ الإصدار) فلا أخمِّن. النسخة القديمة لمادة 2/2025 تُغلق فى 2026-02-03 (اليوم السابق).
--
-- ===== آلية التعديل (ب) =====
-- مطابقة لمسار POST /articles/:id/versions فى الخدمة (articles.service.addVersion + versioning.ts):
-- إغلاق النسخة الجارية (effective_to = اليوم السابق للسريان الجديد، status='amended')، ثم إدراج نسخة
-- version_no=2 (active، effective_to NULL) بحقول amended_by_law_no/year وchange_note، ثم مزامنة
-- articles.body مع أحدث نسخة. تُبنى النسخة الثانية من النسخة الأولى المخزَّنة نفسها باستبدال البند (5) وحده
-- (بعد التحقق من مطابقة ذيلها للنص القديم حرفياً)، فلا تُنسخ البنود (1-4) ولا تتغير. وتُصفَّر
-- articles.embedding للمادة لأن متجهها القديم يمثل نصاً لم يعد ساريا.
--
-- ===== قابلية إعادة التشغيل =====
-- حذف مادتى 3/2026 مشروط بوجود أثر التسرب فيهما؛ الإدراجات بـON CONFLICT DO NOTHING؛ التعديل (ب) مشروط
-- بوجود النسخة 1 وحدها نشطة (وإن وُجدت النسخة 2 تُتخطى). وإعادة تشغيل 004/005/006 لا تُعيد التلف لأن
-- إدراجها يتخطى الصفوف الموجودة. وقد عُدِّل تحقق 115 ليعتمد النسخ الأولى (version_no=1) فيبقى صحيحاً بعد
-- هذا التعديل (وإلا فسيفشل كل نشر لاحق).
--
-- ملاحظة تشغيلية: مواد 3/2026 الجديدة ومادة 2/2025 رقم 4 بلا embedding؛ يلزم scripts/backfill-embeddings.js.

BEGIN;

DO $fix119a$
DECLARE
  v_law_id uuid;
  v_bad int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 3 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[119] القرار 3/2026 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  SELECT count(*) INTO v_bad FROM articles
   WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no IN (1, 2)
     AND (body LIKE '%الوقائع المصر' || chr(1740) || 'ة%' OR body LIKE '%العدد ٢٧%' OR body LIKE '%تابع ) ب (%');
  IF v_bad > 0 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no IN (1, 2);
    RAISE NOTICE '[119] أُزيلت مادتا 3/2026 المعيبتان (% بهما تسرُّب ترويسة)', v_bad;
  ELSE
    RAISE NOTICE '[119] لا أثر تسرُّب فى 3/2026 — تخطّى الحذف';
  END IF;
END
$fix119a$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, NULL, 'ديباجة القرار', $p0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 والقرارات الصادرة تنفيذاً له ؛
وعلى قرار مجلس إدارة الهيئة رقم 2 لسنة 2025 بشأن قواعد وضوابط ونسب استثمار أموال شركات التأمين وإعادة التأمين ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2026/1/14 ؛
قرر :$p0$
  FROM laws WHERE law_no = 3 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, 'المادة الأولى', $p1$يستبدل بنص البند (5) من المادة الرابعة من قرار مجلس إدارة الهيئة رقم (2) لسنة 2025 المشار إليه ، النص الآتي :
(المادة الرابعة / البند "5") :
5- إذا تبين للهيئة أن الأموال المخصصة طبقاً لأحكام المادة (175) من قانون التأمين الموحد غير كافية لمقابلة التزامات الشركة قبل حملة الوثائق والمستفيدين منها عن عمليات التأمين المبرمة والمنفذة في جمهورية مصر العربية، وجب على الشركة استكمال هذا النقص فوراً من الأموال الحرة المتاحة لديها، وفي حال عدم كفاية الأموال الحرة تمنح الشركة مهلة لا تجاوز ثلاثة أشهر من التاريخ المحدد لتقديم المركز المالي الذي تحقق فيه العجز مع التزام الشركة بتقديم خطة لاستيفاء العجز خلال المهلة الممنوحة.$p1$
  FROM laws WHERE law_no = 3 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, 'المادة الثانية', $p2$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$p2$
  FROM laws WHERE law_no = 3 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-02-04', 'active' FROM ins2;

-- ===== (ب) استبدال البند (5) من المادة الرابعة من القرار 2/2025 =====
DO $amend119$
DECLARE
  v_art uuid;
  v_v1 record;
  v_has2 boolean;
  v_vers int;
  v_pos int;
  v_old5 constant text := $o5$5- إذا تبين للهيئة أن الأموال المخصصة طبقاً لأحكام المادة (175) من قانون التأمين الموحد غير كافية لمقابلة التزامات الشركة قبل حملة الوثائق والمستفيدين منها عن عمليات التأمين المبرمة والمنفذة في جمهورية مصر العربية، وجب على الشركة استكمال هذا النقص فوراً من الأموال الحرة المتاحة لديها، وفى حالة عدم كفاية الأموال الحرة تمنح الشركة مهلة لا تجاوز ستة أشهر من تاريخ الإخطار الذي ترسله الهيئة الى الشركة مع إلزام الشركة بتقديم خطة لكيفية استيفاء العجز خلال المهلة الممنوحة.$o5$;
  v_new5 constant text := $n5$5- إذا تبين للهيئة أن الأموال المخصصة طبقاً لأحكام المادة (175) من قانون التأمين الموحد غير كافية لمقابلة التزامات الشركة قبل حملة الوثائق والمستفيدين منها عن عمليات التأمين المبرمة والمنفذة في جمهورية مصر العربية، وجب على الشركة استكمال هذا النقص فوراً من الأموال الحرة المتاحة لديها، وفي حال عدم كفاية الأموال الحرة تمنح الشركة مهلة لا تجاوز ثلاثة أشهر من التاريخ المحدد لتقديم المركز المالي الذي تحقق فيه العجز مع التزام الشركة بتقديم خطة لاستيفاء العجز خلال المهلة الممنوحة.$n5$;
  v_newbody text;
BEGIN
  SELECT a.id INTO v_art FROM articles a JOIN laws l ON l.id = a.law_id
   WHERE l.law_no = 2 AND l.law_year = 2025 AND l.kind = 'board_decision'
     AND a.article_no = 4 AND a.article_suffix_order = 0;
  IF v_art IS NULL THEN
    RAISE WARNING '[119] المادة الرابعة من 2/2025 غير موجودة — تخطّى التعديل (يلزم تطبيق 115 أولاً)';
    RETURN;
  END IF;

  SELECT count(*) INTO v_vers FROM article_versions WHERE article_id = v_art;
  SELECT EXISTS (SELECT 1 FROM article_versions WHERE article_id = v_art AND version_no = 2) INTO v_has2;
  IF v_has2 THEN
    RAISE NOTICE '[119] النسخة 2 موجودة سلفاً — تخطّى التعديل';
    RETURN;
  END IF;

  SELECT * INTO v_v1 FROM article_versions WHERE article_id = v_art AND version_no = 1;
  IF v_vers <> 1 OR v_v1.id IS NULL OR v_v1.status <> 'active' OR v_v1.effective_to IS NOT NULL THEN
    RAISE EXCEPTION '[119] حالة نسخ المادة الرابعة من 2/2025 غير متوقعة (نسخ=%) — لا تعديل آلى', v_vers;
  END IF;

  v_pos := position('5- إذا تبين للهيئة' IN v_v1.body);
  IF v_pos = 0 OR substr(v_v1.body, v_pos) <> v_old5 THEN
    RAISE EXCEPTION '[119] ذيل نص المادة الرابعة لا يطابق البند (5) القديم المتوقَّع — لا تعديل آلى';
  END IF;
  v_newbody := left(v_v1.body, v_pos - 1) || v_new5;

  UPDATE article_versions SET effective_to = DATE '2026-02-03', status = 'amended' WHERE id = v_v1.id;
  INSERT INTO article_versions (article_id, version_no, body, effective_from, effective_to, status,
                                amended_by_law_no, amended_by_law_year, change_note)
  VALUES (v_art, 2, v_newbody, DATE '2026-02-04', NULL, 'active', 3, 2026, $cn$استُبدل نص البند (5) بموجب قرار مجلس إدارة الهيئة رقم 3 لسنة 2026 (الوقائع المصرية، العدد 27 تابع (ب)، 3 فبراير 2026): صارت مهلة استكمال العجز ثلاثة أشهر من التاريخ المحدد لتقديم المركز المالي الذي تحقق فيه العجز، بدلاً من ستة أشهر من تاريخ إخطار الهيئة للشركة.$cn$);
  UPDATE articles SET body = v_newbody, embedding = NULL, updated_at = now() WHERE id = v_art;
  RAISE NOTICE '[119] أُضيفت النسخة 2 للمادة الرابعة من 2/2025 (البند 5: ثلاثة أشهر)';
END
$amend119$;

DO $verify119$
DECLARE
  v_law3 uuid;
  v_law2 uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_art uuid;
  v_n int;
  v_body text;
  v_v1body text;
BEGIN
  -- القرار 3/2026
  SELECT id INTO v_law3 FROM laws WHERE law_no = 3 AND law_year = 2026 AND kind = 'board_decision';
  SELECT count(*), COALESCE(sum(length(body)),0),
         count(*) FILTER (WHERE body LIKE '%الوقائع المصر' || chr(1740) || 'ة%' OR body LIKE '%العدد ٢٧%' OR body LIKE '%تابع ) ب (%'
                             OR body LIKE '%' || chr(65533) || '%')
    INTO v_arts, v_len, v_bad FROM articles WHERE law_id = v_law3;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law3 AND av.effective_from = DATE '2026-02-04' AND av.status = 'active';
  IF v_arts <> 3 OR v_vers <> 3 THEN
    RAISE EXCEPTION '[119] 3/2026: متوقَّع 3 مواد و3 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 THEN
    RAISE EXCEPTION '[119] 3/2026: ما زال فى % مادة أثر تلف/تسرُّب', v_bad;
  END IF;
  IF v_len <> 1161 THEN
    RAISE EXCEPTION '[119] 3/2026: مجموع الأطوال % لا يطابق المتوقع 1161', v_len;
  END IF;
  SELECT count(*) INTO v_n FROM articles
   WHERE law_id = v_law3 AND ((article_no = 1 AND body LIKE '%ثلاثة أشهر من التاريخ المحدد لتقديم المركز المالي%')
                           OR (article_no = 2 AND body LIKE '%محمد فريد صالح%'));
  IF v_n <> 2 THEN
    RAISE EXCEPTION '[119] 3/2026: محتوى المادتين 1 و2 غير مكتمل';
  END IF;

  -- القرار 2/2025، المادة الرابعة
  SELECT id INTO v_law2 FROM laws WHERE law_no = 2 AND law_year = 2025 AND kind = 'board_decision';
  SELECT id, body INTO v_art, v_body FROM articles WHERE law_id = v_law2 AND article_no = 4 AND article_suffix_order = 0;
  IF v_art IS NULL THEN
    RAISE EXCEPTION '[119] المادة الرابعة من 2/2025 مفقودة';
  END IF;
  SELECT count(*) INTO v_n FROM article_versions WHERE article_id = v_art;
  IF v_n <> 2 THEN
    RAISE EXCEPTION '[119] 2/2025 م4: متوقَّع نسختان، الفعلى %', v_n;
  END IF;
  SELECT count(*) INTO v_n FROM article_versions
   WHERE article_id = v_art AND version_no = 1 AND status = 'amended'
     AND effective_from = DATE '2025-06-04' AND effective_to = DATE '2026-02-03';
  IF v_n <> 1 THEN
    RAISE EXCEPTION '[119] 2/2025 م4: النسخة 1 غير مُغلقة كما يجب';
  END IF;
  SELECT count(*) INTO v_n FROM article_versions
   WHERE article_id = v_art AND version_no = 2 AND status = 'active' AND effective_to IS NULL
     AND effective_from = DATE '2026-02-04' AND amended_by_law_no = 3 AND amended_by_law_year = 2026
     AND body = v_body;
  IF v_n <> 1 THEN
    RAISE EXCEPTION '[119] 2/2025 م4: النسخة 2 غير متطابقة مع نص المادة الحالى';
  END IF;
  SELECT count(*) INTO v_n FROM article_versions WHERE article_id = v_art AND effective_to IS NULL;
  IF v_n <> 1 THEN
    RAISE EXCEPTION '[119] 2/2025 م4: يجب وجود نسخة ساريا واحدة فقط (الفعلى %)', v_n;
  END IF;
  SELECT body INTO v_v1body FROM article_versions WHERE article_id = v_art AND version_no = 1;
  IF v_body NOT LIKE '%ثلاثة أشهر من التاريخ المحدد لتقديم المركز المالي الذي تحقق فيه العجز%'
     OR v_body LIKE '%ستة أشهر%'
     OR left(v_body, position('5- إذا تبين للهيئة' IN v_body) - 1) <> left(v_v1body, position('5- إذا تبين للهيئة' IN v_v1body) - 1) THEN
    RAISE EXCEPTION '[119] 2/2025 م4: نص البند (5) الجديد أو سلامة البنود 1-4 غير مطابقة';
  END IF;
  -- بقية مواد 2/2025 لم تُمسّ: نسخة واحدة لكل منها
  SELECT count(*) INTO v_n FROM articles a WHERE a.law_id = v_law2 AND a.id <> v_art
     AND (SELECT count(*) FROM article_versions av WHERE av.article_id = a.id) <> 1;
  IF v_n <> 0 THEN
    RAISE EXCEPTION '[119] 2/2025: % مادة أخرى تغيّر عدد نسخها', v_n;
  END IF;
  RAISE NOTICE '[119] 3/2026: % مواد و% نسخ سليمة؛ 2/2025 م4: النسخة 2 سارية من 2026-02-04 (ثلاثة أشهر).', v_arts, v_vers;
END
$verify119$;

COMMIT;
