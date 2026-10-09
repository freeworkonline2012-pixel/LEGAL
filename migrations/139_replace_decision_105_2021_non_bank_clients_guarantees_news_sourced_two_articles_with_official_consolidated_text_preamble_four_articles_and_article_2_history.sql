-- 139_replace_decision_105_2021_non_bank_clients_guarantees_news_sourced_two_articles_with_official_consolidated_text_preamble_four_articles_and_article_2_history.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (105) لسنة 2021 (بتاريخ 2021/6/20) بشأن
-- تنظيم الضمانات المقدمة من عملاء الجهات العاملة فى مجال الأنشطة المالية غير المصرفية، بالنص الرسمى
-- الموحد "وفقاً لآخر تعديل بتاريخ 2025/7/9" (تعديل المادة الثانية بقرار مجلس إدارة الهيئة رقم 145 لسنة
-- 2025، الوقائع المصرية، العدد 154 (تابع)، 15 يوليو 2025).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P3) =====
-- مزروع بالهجرة 040 كمادة واحدة (article_no = 1، نحو 2546 حرفاً) من نقل صحفى لا من الجريدة الرسمية
-- (رابط laws.official_url يشير إلى خبر لليوم السابع): فيها المادتان الأولى والثانية فقط بين علامات تنصيص،
-- بلا ديباجة ولا المادتين الثالثة (الالتزام شرط لاستمرار الترخيص) والرابعة (النشر والنفاذ)، وبإضافات
-- غير رسمية ("أصدره: الدكتور محمد عمران"، "نُشر ... العدد 157")، وبلا أى نسخة فى article_versions
-- (فلا تاريخ سريان ولا سجل تعديل للمادة الثانية). القرار ضمن نطاق الحوكمة (لا تُمس بيانات laws).
--
-- ===== المصدر والمنهجية =====
-- ملفان رفعهما صاحب المشروع: (1) نسخة الهيئة الموحدة 105/2021 "وفقاً لآخر تعديل بتاريخ 2025/7/9"
-- (صفحة واحدة)، (2) قرار 145/2025 بالوقائع (صفحتان). أُصلح الـxref بـqpdf وقوبل النص بالصور.
-- نصوص الديباجة والمواد 1 و3 و4 من النسخة الموحدة الرسمية؛ نص المادة الثانية بعد التعديل من الوقائع
-- ومطابق للموحدة (كلمة بكلمة بعد توحيد المسافات). نص المادة الثانية قبل التعديل منقول من النص
-- المخزَّن (نقل صحفى لا يتوفر له أصل رسمى بين أيدينا) فيُسجَّل نسخةً سابقة بحالة amended مع تنبيه فى
-- change_note؛ والعملية قابلة للمراجعة برفع الجريدة الرسمية 2021 (العدد 157 المذكور فى النقل
-- الصحفى). لم تُنقل إضافات "أصدره/نُشر" لأنها ليست من نص القرار؛ والهوامش (1) و(2) أُدرجت كقسم.
--
-- ===== الهيكل =====
-- 6 مواد، 7 نسخ: ديباجة (article_no = 0)، المواد 1–4، وقسم 5 "هوامش التعديل". المادة 2 لها نسختان
-- (version_no 1 = نص 2021 بحالة amended وeffective_to = 2025-07-15؛ version_no 2 = نص 145/2025 بحالة
-- active وamended_by = 145/2025) على غرار القرار 2/2025 (المادة 4). المادة الأولى من الهجرة القديمة
-- (article_no = 1) تبقى المادة الأولى حتى لا يعيد بذر 040 إدراجاً.
--
-- ===== التواريخ =====
-- effective_from = 2021-07-15 للنسخ الأصلية (القرار يعمل به من اليوم التالى لنشره بالوقائع، والنشر فى
-- 14 يوليو 2021 بحسب النقل الصحفى الذى لا تذكره النسخة الموحدة) و2025-07-16 لنسخة المادة 2 الجديدة
-- (النشر فى 15 يوليو 2025 بترويسة الوقائع). يُنبَّه إلى أن laws.enacted_at المسجَّل 2021-07-14 هو تاريخ
-- النشر لا تاريخ القرار (2021/6/20)؛ لم يُمس لأن laws خارج نطاق هذه الهجرة.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (6 مواد بديباجة سليمة والقسم 5 موجود)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد المواد والنسخ،
-- تلف، محتوى، حالة نسختى المادة 2 وتواريخهما، إجمالى الطول 1943 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix139$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 105 AND law_year = 2021 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[139] القرار 105/2021 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 6
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[139] القرار 105/2021 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[139] أُزيلت % مادة من القرار 105/2021 (مادة واحدة تضم القرار كله بلا نسخ)', v_n;
  END IF;
END
$fix139$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (105) لسنة 2021 بتاريخ 2021/6/20 بشأن تنظيم الضمانات المقدمة من عملاء الجهات العاملة في مجال الأنشطة المالية غير المصرفية (النص الموحد وفقا لآخر تعديل بتاريخ 2025/7/9)$h0$, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قرار مجلس إدارة الهيئة رقم 53 لسنة 2018 بشأن ضوابط منح الترخيص واستمراره وقواعد تملك أسهم الشركات العاملة في الأنشطة المالية غير المصرفية ؛
وعلى قرار مجلس إدارة الهيئة رقم 31 لسنة 2015 بشأن قواعد ومعايير ممارسة نشاط التمويل متناهي الصغر للجمعيات والمؤسسات الأهلية ؛
وعلى قرار مجلس إدارة الهيئة رقم 186 لسنة 2020 بشأن قواعد ومعايير مزاولة نشاط تمويل المشروعات المتوسطة والصغيرة للجمعيات والمؤسسات الأهلية المرخص لها بمزاولة نشاطي تمويل المشروعات المتوسطة والصغيرة وتمويل المشروعات متناهية الصغر ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2021/6/20 ؛
قرر$b0$
  FROM laws WHERE law_no = 105 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-15', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$على الجهات المرخص لها من الهيئة بمزاولة الأنشطة المالية غير المصرفية استيفاء كافة البيانات الواردة بالعقود المبرمة بينها وبين عملائها ومرفقاتها والضمانات المرتبطة بها وعدم ترك أي بيان من هذه البيانات دون استيفاء.$b1$
  FROM laws WHERE law_no = 105 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-15', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$تلتزم الجهات المشار إليها بالمادة الأولى من هذا القرار بمنح التمويل لعملائها في الغرض المخصص له وفقا لأحكام القوانين المنظمة لتلك الأنشطة كل حسب نوعه ، كما تلتزم بمراعاة القواعد القانونية المقررة عند الحصول على ضمانات من عملائها ، ويحظر عليها الحصول على إيصالات أمانة أو عقود وديعة وما في حكم ذلك من العقود أو السندات المعاقب على الإخلال بها جنائيا ، أو الحصول على أي أوراق أخرى موقعة على بياض ، سواء من العملاء أو من ضامنيهم ؛ كضمان للتمويل ، كما يحظر عليها استخدام أي مما سبق ضد عملائها أو ضامنيهم .
وعلى الجهات المشار إليها بذل عناية الرجل الحريص في الحفاظ على الضمانات المقدمة إليها من عملائها أو ضامنيهم ، وتسليم هذه الضمانات إليهم فور انتهاء التعاملات المتعلقة بها .$b2$
  FROM laws WHERE law_no = 105 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, effective_to, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT ins2.id, v.version_no, v.body, v.effective_from, v.effective_to, v.status, v.amb_no, v.amb_year, v.note
FROM ins2 CROSS JOIN (VALUES
  (1, $o2$تلتزم الجهات المشار إليها بالمادة الأولى من هذا القرار بمنح التمويل لعملائها في الغرض المخصص له وفقًا لأحكام القوانين المنظمة لتلك الأنشطة كل حسب نوعه، كما تلتزم بمراعاة القواعد القانونية المقررة عند الحصول على ضمانات من عملائها، ويحظر عليها الحصول على إيصالات أمانة من العملاء أو ضامنيهم أو الحصول على أية أوراق أخرى موقعة على بياض كضمان للتمويل، وعليها بذل عناية الرجل الحريص في الحفاظ على الضمانات المقدمة إليها من عملائها، وتسليم هذه الضمانات للعملاء فور انتهاء التعاملات المتعلقة بها.$o2$, DATE '2021-07-15', DATE '2025-07-15', 'amended', NULL::int, NULL::int, $n1$النص السابق للمادة الثانية (قبل الاستبدال بالقرار 145 لسنة 2025): منقول من النص المخزَّن عن نقل صحفى للجريدة الرسمية (اليوم السابع، 14 يوليو 2021)؛ لا أصل رسمى متاح بعد.$n1$),
  (2, $b2$تلتزم الجهات المشار إليها بالمادة الأولى من هذا القرار بمنح التمويل لعملائها في الغرض المخصص له وفقا لأحكام القوانين المنظمة لتلك الأنشطة كل حسب نوعه ، كما تلتزم بمراعاة القواعد القانونية المقررة عند الحصول على ضمانات من عملائها ، ويحظر عليها الحصول على إيصالات أمانة أو عقود وديعة وما في حكم ذلك من العقود أو السندات المعاقب على الإخلال بها جنائيا ، أو الحصول على أي أوراق أخرى موقعة على بياض ، سواء من العملاء أو من ضامنيهم ؛ كضمان للتمويل ، كما يحظر عليها استخدام أي مما سبق ضد عملائها أو ضامنيهم .
وعلى الجهات المشار إليها بذل عناية الرجل الحريص في الحفاظ على الضمانات المقدمة إليها من عملائها أو ضامنيهم ، وتسليم هذه الضمانات إليهم فور انتهاء التعاملات المتعلقة بها .$b2$, DATE '2025-07-16', NULL::date, 'active', 145, 2025, $n2$استُبدل نص المادة الثانية بموجب قرار مجلس إدارة الهيئة رقم 145 لسنة 2025 (الوقائع المصرية، العدد 154 تابع، 15 يوليو 2025): حظر إيصالات الأمانة وعقود الوديعة وما فى حكمها والسندات المعاقب على الإخلال بها جنائياً والأوراق الموقعة على بياض، وحظر استخدامها ضد العملاء والضامنين، وإلزام الجهات بتسليم الضمانات فور انتهاء التعاملات.$n2$)
) AS v(version_no, body, effective_from, effective_to, status, amb_no, amb_year, note);

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3$المادة الثالثة$t3$, $b3$يعد الالتزام بالأحكام الواردة بهذا القرار أحد شروط استمرار الترخيص بمزاولة النشاط.$b3$
  FROM laws WHERE law_no = 105 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-15', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4$المادة الرابعة$t4$, $b4$ينشر هذا القرار في الوقائع المصرية ، وعلى الموقع الإلكتروني للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية .$b4$
  FROM laws WHERE law_no = 105 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-15', 'active' FROM ins4;

WITH ins5 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 5, 0, $h5$قرار مجلس إدارة الهيئة رقم (105) لسنة 2021 - هوامش التعديلات اللاحقة$h5$, $t5$هوامش التعديل بقرار مجلس إدارة الهيئة رقم (145) لسنة 2025$t5$, $b5$هوامش (تعديلات لاحقة):
(1) تم تعديل القرار بموجب قرار مجلس إدارة الهيئة رقم (145) بتاريخ 2025/7/9.
(2) تم استبدال المادة الثانية بموجب قرار مجلس إدارة الهيئة رقم (145) بتاريخ 2025/7/9.$b5$
  FROM laws WHERE law_no = 105 AND law_year = 2021 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2021-07-15', 'active' FROM ins5;

DO $verify139$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 105 AND law_year = 2021 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[139] القرار 105/2021 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 6 THEN RAISE EXCEPTION '[139] عدد المواد % بدل 6', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id;
  IF v_v <> 7 THEN RAISE EXCEPTION '[139] عدد النسخ % بدل 7', v_v; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.status = 'active' AND av.effective_to IS NULL;
  IF v_v <> 6 THEN RAISE EXCEPTION '[139] النسخ النافذة % بدل 6', v_v; END IF;
  IF NOT EXISTS (SELECT 1 FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND a.article_no = 2 AND av.version_no = 1 AND av.status = 'amended' AND av.effective_from = DATE '2021-07-15' AND av.effective_to = DATE '2025-07-15' AND av.body LIKE '%أو الحصول على أية أوراق أخرى موقعة على بياض كضمان للتمويل%') THEN RAISE EXCEPTION '[139] نسخة المادة 2 السابقة غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND a.article_no = 2 AND av.version_no = 2 AND av.status = 'active' AND av.effective_from = DATE '2025-07-16' AND av.amended_by_law_no = 145 AND av.amended_by_law_year = 2025) THEN RAISE EXCEPTION '[139] نسخة المادة 2 الحالية غير سليمة'; END IF;
  IF EXISTS (SELECT 1 FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND a.article_no <> 2 AND (av.version_no <> 1 OR av.effective_from <> DATE '2021-07-15')) THEN RAISE EXCEPTION '[139] نسخ المواد الأخرى غير سليمة'; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%FINANCIAL REGULATORY%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[139] % مادة بها تلف أو ترويسة أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND body LIKE 'بعد الاطلاع على القانون رقم 10 لسنة 2009%' AND body LIKE '%53 لسنة 2018%' AND body LIKE '%31 لسنة 2015%' AND body LIKE '%186 لسنة 2020%' AND body LIKE '%بتاريخ 2021/6/20 ؛%' AND body LIKE '%قرر') THEN RAISE EXCEPTION '[139] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE '%استيفاء كافة البيانات الواردة بالعقود%') THEN RAISE EXCEPTION '[139] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE '%إيصالات أمانة أو عقود وديعة%' AND body LIKE '%موقعة على بياض%' AND body LIKE '%بذل عناية الرجل الحريص%' AND body LIKE '%فور انتهاء التعاملات المتعلقة بها .') THEN RAISE EXCEPTION '[139] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND body LIKE '%أحد شروط استمرار الترخيص بمزاولة النشاط.%') THEN RAISE EXCEPTION '[139] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND body LIKE '%من اليوم التالي لتاريخ نشره بالوقائع المصرية .%') THEN RAISE EXCEPTION '[139] المادة 4 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 5 AND body LIKE '%(1) تم تعديل القرار بموجب قرار مجلس إدارة الهيئة رقم (145)%' AND body LIKE '%(2) تم استبدال المادة الثانية%') THEN RAISE EXCEPTION '[139] الهوامش غير سليم'; END IF;
  IF v_len <> 1943 THEN RAISE EXCEPTION '[139] إجمالى طول المواد % بدل 1943', v_len; END IF;
  RAISE NOTICE '[139] القرار 105/2021: 6 مواد (ديباجة + 4 مواد + هوامش) و7 نسخ (للمادة 2 نسختان)، إجمالى % حرف', v_len;
END
$verify139$;

COMMIT;
