-- 122_fix_decision_4_2026_insurance_intermediaries_capital_deadline_extension_text_and_date.sql
--
-- إصلاح نص قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (4) لسنة 2026 بشأن مد المهلة الممنوحة
-- لزيادة رؤوس أموال بعض الشركات التى تزاول المهن والأنشطة المرتبطة بالتأمين (وساطة التأمين وإعادة
-- التأمين وخبرة المعاينة وتقدير الأضرار وخبرة الاستشارات التأمينية)، المنشور بالوقائع المصرية،
-- العدد 22 (تابع)، فى 27 يناير 2026، ص 5.
--
-- ===== الحالة السابقة =====
-- مادتان مُستخرَجتان من الطبقة النصية للـPDF: حروف مفككة ("ت ُمد")، وأرقام هندية ملتصقة بالكلمات
-- ("رقم ١٩٦لسنة ٢٠٢٤المشار")، وفاصلة ملتصقة بالكلمة السابقة، وتوقيع "د /محمد"، وبلا ديباجة
-- (أساس الإصدار وموافقة المجلس)، وتاريخ سريان النسختين = تاريخ البذر (now) لا تاريخ النشر.
-- النص الجوهرى (ستة أشهر أخرى، جدول زمنى خلال شهر من النشر، حظر توزيع الأرباح النقدية إلا بعدم
-- ممانعة الهيئة) كان مقروءاً لكنه غير نظيف، فالإصلاح تنظيفى مع إضافة الديباجة وضبط التاريخ.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحة واحدة) رفعه صاحب المشروع (alamiria_2026_4.pdf)؛ الرابط المخزَّن فى
-- laws.official_url يحمل اسم الملف نفسه ولم يُمس. قُرئت الصفحة بصرياً بتكبير 130 dpi وقوبلت
-- بالطبقة النصية كلمةً كلمة (تطابقت)؛ أُبقى إملاء المصدر ("فى"، "الالكترونى"، "المُشار") والأرقام
-- الهندية محوَّلة إلى لاتينية. أُضيفت الديباجة كمادة article_no=0 على نمط 113/119.
--
-- ===== التاريخ (قرار موثَّق) =====
-- effective_from = 2026-01-27 (تاريخ نشره بالوقائع المصرية، من ترويسة الصفحة). المادة الثانية تنص على النشر
-- فقط ولا تحدد تاريخ سريان آخر (بخلاف قرارات أخرى تقول "من اليوم التالى لتاريخ نشره")، والمادة الأولى
-- نفسها تحتسب مهلة الشهر "من تاريخ نشر هذا القرار" — أى أنه يُعمل به من النشر. enacted_at يبقى NULL
-- (لا تاريخ إصدار فى النص؛ 2026/1/14 هو جلسة موافقة المجلس).
--
-- ===== ملاحظة على القرار الأم (196/2024) =====
-- هذا القرار يمد مهلة واردة بالقرار 196/2024 دون استبدال نص مادة فيه، فلا تُضاف نسخة جديدة لمواد
-- 196/2024 (لا يوجد نص بديل منصوص عليه). ونص 196/2024 المخزَّن نفسه تالف (جدول الحد الأدنى لرؤوس
-- الأموال مبعثر وترويسة الوقائع متسرِّبة) ويحتاج إصلاحاً مستقلاً من مصدره الرسمى.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بوجود أرقام هندية/حروف مفككة فى المادتين المخزَّنتين (الصيغة الجديدة بلا أرقام هندية)،
-- والإدراج بـON CONFLICT DO NOTHING، وتحقق الختام محصور فى هذا القرار.
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix122$
DECLARE
  v_law_id uuid;
  v_bad int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 4 AND law_year = 2026 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[122] القرار 4/2026 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  SELECT count(*) INTO v_bad FROM articles
   WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no IN (1, 2) AND (body ~ '[٠-٩]' OR body LIKE '%ت ُمد%' OR body LIKE '%' || chr(65533) || '%');
  IF v_bad > 0 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no IN (1, 2);
    RAISE NOTICE '[122] أُزيلت مادتا 4/2026 غير النظيفتين (% بهما تلف)', v_bad;
  ELSE
    RAISE NOTICE '[122] لا أثر تلف فى 4/2026 — تخطّى الحذف';
  END IF;
END
$fix122$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, NULL, 'ديباجة القرار', $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وعلى قرار مجلس إدارة الهيئة رقم 196 لسنة 2024 بشأن تحديد الحد الأدنى لرؤوس أموال الشركات العاملة فى قطاع التأمين ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2026/1/14 ؛
قرر :$b0$
  FROM laws WHERE law_no = 4 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-27', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$تُمد المهلة الممنوحة لزيادة رؤوس أموال الشركات التى تزاول أنشطة الوساطة فى التأمين والوساطة فى إعادة التأمين وخبرة المعاينة وتقدير الأضرار وخبرة الاستشارات التأمينية ، على النحو المنصوص عليه بقرار مجلس إدارة الهيئة رقم 196 لسنة 2024 المُشار إليه ، لمدة ستة أشهر أخرى اعتبارًا من تاريخ انتهاء المدة الواردة بالقرار المذكور .
وتلتزم الشركات المُشار إليها بإعداد جدول زمنى موضحًا به مراحل زيادة رؤوس أموالها وموافاة الهيئة به خلال شهر من تاريخ نشر هذا القرار ، ويُحظر على تلك الشركات توزيع أى أرباح نقدية على مساهميها قبل استيفاء متطلبات الحد الأدنى لرأس المال إلا بعد الحصول على عدم ممانعة الهيئة .$b1$
  FROM laws WHERE law_no = 4 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-27', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$يُنشر هذا القرار فى الوقائع المصرية ، وعلى الموقع الالكترونى للهيئة .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b2$
  FROM laws WHERE law_no = 4 AND law_year = 2026 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-01-27', 'active' FROM ins2;

DO $verify122$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
  v_content int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 4 AND law_year = 2026 AND kind = 'board_decision';
  SELECT count(*), COALESCE(sum(length(body)),0), count(*) FILTER (WHERE (body ~ '[٠-٩]' OR body LIKE '%ت ُمد%' OR body LIKE '%' || chr(65533) || '%')),
         count(*) FILTER (WHERE (article_no = 0 AND strpos(body, 'رقم 196 لسنة 2024') > 0)
                             OR (article_no = 1 AND strpos(body, 'لمدة ستة أشهر أخرى') > 0
                                 AND strpos(body, 'خلال شهر من تاريخ نشر هذا القرار') > 0
                                 AND strpos(body, 'إلا بعد الحصول على عدم ممانعة الهيئة') > 0)
                             OR (article_no = 2 AND strpos(body, 'محمد فريد صالح') > 0))
    INTO v_arts, v_len, v_bad, v_content FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2026-01-27' AND av.status = 'active';
  IF v_arts <> 3 OR v_vers <> 3 THEN
    RAISE EXCEPTION '[122] متوقَّع 3 مواد و3 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 OR v_content <> 3 THEN
    RAISE EXCEPTION '[122] فشل التحقق من المحتوى (تلف=%, محتوى=%)', v_bad, v_content;
  END IF;
  IF v_len <> 1076 THEN
    RAISE EXCEPTION '[122] مجموع الأطوال % لا يطابق المتوقع 1076', v_len;
  END IF;
  RAISE NOTICE '[122] قرار 4/2026: % مواد و% نسخ سليمة.', v_arts, v_vers;
END
$verify122$;

COMMIT;
