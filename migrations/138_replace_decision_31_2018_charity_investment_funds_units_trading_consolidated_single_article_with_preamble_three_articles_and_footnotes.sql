-- 138_replace_decision_31_2018_charity_investment_funds_units_trading_consolidated_single_article_with_preamble_three_articles_and_footnotes.sql
--
-- إعادة هيكلة قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (31) لسنة 2018 (بتاريخ 2018/4/3) بشأن
-- ضوابط تداول ونقل ملكية وثائق صناديق الاستثمار الخيرية، بالنص الموحد "وفقاً لآخر تعديل بتاريخ
-- 2026/4/8" (تعديل بقرار مجلس إدارة الهيئة رقم 83 فى 2026/4/8) كما نشرته الهيئة على موقعها.
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P3) =====
-- مزروع بالهجرة 035 كمادة واحدة (article_no = 1، نحو 3689 حرفاً) تضم القرار كله: العنوان، الديباجة،
-- المادة الأولى بقسميها (أولاً المغلقة وثانياً المفتوحة) والمادتين الثانية والثالثة والهوامش، وبلا أى
-- نسخة فى article_versions. فكان الاسترجاع يعيد القرار كله لأى سؤال ولا يمكن الاستشهاد بمادة بعينها.
-- نص المحتوى نفسه سليم (أرقام لاتينية بلا تلف) ومطابق لصورتى PDF الهيئة؛ العيب فى الهيكل لا فى النص.
-- القرار ضمن نطاق الحوكمة (لا تُمس بيانات laws؛ enacted_at = 2018-04-03 قائم).
--
-- ===== المصدر والمنهجية =====
-- PDF الهيئة الموحد (صفحتان، 2026/05) رفعه صاحب المشروع؛ رابط laws.official_url لم يُمس. الطبقة
-- النصية لهذا الملف مشوهة (حروف ناقصة وأشكال عرض) فلم تُستعمل؛ قوبل النص المخزَّن القديم بصورتى
-- الصفحتين سطراً بسطر (130 dpi) فتطابق كلمة بكلمة، ثم أعيد تقسيمه دون تغيير حرف فى المتن
-- (تُقسَّم الأسطر آلياً من النص المخزَّن لا بإعادة كتابة). الإملاء كما فى المصدر ("الارباح"، "الى").
-- عنوان القرار وتاريخه وعبارة "وفقاً لآخر تعديل" فى hierarchical_location للديباجة. نص القرار لا يحمل
-- النقطتين بعد "قرر".
--
-- ===== الهيكل =====
-- 5 مواد، 5 نسخ (version_no = 1): ديباجة (article_no = 0)، المادة الأولى (مقدمة + أولاً المغلقة بخمسة
-- بنود + ثانياً المفتوحة بأربعة بنود، وفيها علامة الهامش (2) للبند 3 المستبدل)، المادة الثانية (إلغاء
-- القرار 21 لسنة 2016)، المادة الثالثة (النشر والنفاذ)، ثم القسم 4 "هوامش التعديل" (نص الهامشين
-- (1) و(2) عن القرار 83 فى 2026/4/8). أُبقيت الأرقام 1–3 كما كانت حتى لا يعيد بذر 035 إدراجاً.
-- لم تُقسَّم المادة الأولى (نحو 2.3 ألف حرف) لأن "أولاً/ثانياً" بندان من مادة واحدة والاستشهاد
-- بها يكون بالمادة الأولى بندى أولاً/ثانياً.
--
-- ===== التاريخ والنسخ (قرار تقديرى يُراجَع) =====
-- النص المتاح هو الموحد بعد تعديل 2026/4/8 فقط؛ لا نص أصلى لعام 2018 (قبل استبدال البند 3 من ثانياً)
-- ولا تاريخ نشر بالوقائع للقرارين 31/2018 و83/2026 فى المصدر. فجُعل effective_from = 2026-04-08
-- (تاريخ التعديل المذكور فى المصدر) للنسخ الخمس، وسُجِّل على المادة الأولى amended_by = 83/2026
-- وchange_note. أثر ذلك: لا نسخة للقرار قبل 2026-04-08 فى الاستعلام بالتاريخ (فجوة معلنة بدل نص
-- معدَّل منسوب لتواريخ سابقة). لاحقاً: رفع نص 2018 الأصلى ونشر القرار 83/2026 لبناء نسختين.
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (5 مواد بديباجة سليمة والقسم 4 موجود)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، محتوى،
-- إجمالى الطول 3375 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix138$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 31 AND law_year = 2018 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[138] القرار 31/2018 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 5
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[138] القرار 31/2018 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[138] أُزيلت % مادة من القرار 31/2018 (مادة واحدة تضم القرار كله بلا نسخ)', v_n;
  END IF;
END
$fix138$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (31) لسنة 2018 بتاريخ 2018/4/3 بشأن ضوابط تداول ونقل ملكية وثائق صناديق الاستثمار الخيرية (النص الموحد وفقا لآخر تعديل بتاريخ 2026/4/8)$h0$, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على قانون شركات المساهمة وشركات التوصية بالأسهم والشركات ذات المسئولية المحدودة وشركات الشخص الواحد الصادر بالقانون رقم (159) لسنة 1981 ؛
وعلى قانون سوق رأس المال الصادر بالقانون رقم (95) لسنة 1992 والقرارات الصادرة تنفيذاً له ؛
وعلى قانون الإيداع والقيد المركزي للأوراق المالية الصادر بالقانون رقم (93) لسنة 2000 ولائحته التنفيذية ؛
وعلى القانون رقم (10) لسنة 2009 بشأن تنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قرار رئيس الجمهورية رقم (191) لسنة 2009 بالأحكام المنظمة للبورصة المصرية وشئونها المالية ؛
وعلى قرار رئيس الجمهورية رقم (192) لسنة 2009 بإصدار النظام الأساسي للهيئة العامة للرقابة المالية ؛
وعلى قرار مجلس إدارة الهيئة رقم (17) لسنة 2016 بشأن الشروط الواجب توافرها في مؤسسي شركة صندوق الاستثمار الخيري ؛
وعلى قرار مجلس إدارة الهيئة رقم (20) لسنة 2016 بالموافقة على نموذج عقد التأسيس والنظام الأساسي لصناديق الاستثمار الخيرية ؛
وعلى قرار مجلس إدارة الهيئة رقم (21) لسنة 2016 بشأن ضوابط تداول ونقل ملكية وثائق صناديق الاستثمار الخيرية ؛
وعلى موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2018/4/3.
قرر$b0$
  FROM laws WHERE law_no = 31 AND law_year = 2018 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-08', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$يتم تداول ونقل ملكية وثائق صناديق الاستثمار الخيرية على النحو التالي: -
أولاً: بالنسبة لصناديق الاستثمار الخيرية المغلقة:
يتم تداول ونقل ملكية وثائق صناديق الاستثمار الخيرية المغلقة خارج بورصات الأوراق المالية وفقاً لما يلي:
1. الالتزام بالضوابط الواردة بنشرة الاكتتاب أو مذكرة المعلومات للصندوق بحسب الأحوال.
2. تقديم إقرار من المشتري بالاطلاع على النظام الأساسي للصندوق وكافة شروط نشرة الاكتتاب أو مذكرة المعلومات وأنه على علم بأنه صندوق استثمار خيري توجه كافة الارباح والعوائد الناتجة عن استثمارات الصندوق حتى انقضائه للأغراض الاجتماعية والخيرية المحددة بنشرة الاكتتاب أو مذكرة المعلومات، وأن أصول الصندوق عند انقضائه أو تصفيته تؤول الى الجهات المحددة بنشرة الاكتتاب أو مذكرة المعلومات.
3. يتم تداول الوثيقة بقيمة لا تزيد عن القيمة الاسمية.
4. يتم نقل ملكية من خلال شركة خدمات الإدارة والتي عليها مراعاة التأكد من ملكية البائع للوثائق المباعة.
5. يتم تحديث بيانات مالكي الوثائق بشركة الإيداع والقيد المركزي فور نقل ملكية الوثائق للمشتري، كما تلتزم شركة خدمات الإدارة بتحديث سجل حملة الوثائق لديها في ضوء ذلك.
ثانياً: بالنسبة لصناديق الاستثمار الخيرية المفتوحة:
يتم الاسترداد ونقل ملكية وثائق صناديق الاستثمار الخيرية المفتوحة وفقاً لما يلي: -
1. الالتزام بالبندين (1، 2) من البند أولاً.
2. يتم الاسترداد طبقاً لقيمة الوثيقة المعلنة في إقفال اليوم المحدد للاسترداد أو بالقيمة الشرائية أيهما أقل.
3. يتم تنفيذ طلبات الاسترداد في حدود طلبات الشراء المقدمة في إقفال ذات اليوم المحدد للاسترداد، وإذا تجاوز عدد الوثائق المطلوب استردادها عدد الوثائق المطلوب شرائها، يتم تطبيق نظام التخصيص بنسبة الوثائق المطلوب استردادها إلى إجمالي طلبات الاسترداد مع جبر الكسور التي تنشأ عن عملية التخصيص لصالح مقدمي طلبات الاسترداد الأقل عدداً. ويجوز أن تتضمن نشرة الاكتتاب أو مذكرة المعلومات بحسب الأحوال تنفيذ طلبات استرداد تجاوز طلبات الشراء وفقاً للمبررات التي يقدمها مدير الاستثمار وبعد موافقة مجلس إدارة الصندوق أو لجنة الإشراف بحسب الأحوال. (2)
4. يتم تحديث بيانات مالكي الوثائق من خلال شركة خدمات الإدارة فور نقل ملكية الوثائق للمشتري.$b1$
  FROM laws WHERE law_no = 31 AND law_year = 2018 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2026-04-08', 'active', 83, 2026, 'النص الموحد: استبدال البند 3 من ثانياً (صناديق مفتوحة) بقرار مجلس إدارة الهيئة رقم 83 بتاريخ 2026/4/8' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$يُلغى قرار مجلس إدارة الهيئة رقم (21) لسنة 2016.$b2$
  FROM laws WHERE law_no = 31 AND law_year = 2018 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-08', 'active' FROM ins2;

WITH ins3 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3$المادة الثالثة$t3$, $b3$يُنشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكتروني للهيئة، ويُعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية.$b3$
  FROM laws WHERE law_no = 31 AND law_year = 2018 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-08', 'active' FROM ins3;

WITH ins4 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, $h4$قرار مجلس إدارة الهيئة رقم (31) لسنة 2018 - هوامش التعديلات اللاحقة$h4$, $t4$هوامش التعديل بقرار مجلس إدارة الهيئة رقم (83) بتاريخ 2026/4/8$t4$, $b4$هوامش (تعديلات لاحقة):
(1) تم التعديل بموجب قرار مجلس إدارة الهيئة رقم (83) بتاريخ 2026/4/8.
(2) تم استبدال البند "3" بنص البند (ثانياً: بالنسبة لصناديق الاستثمار الخيرية المفتوحة) بموجب قرار مجلس إدارة الهيئة رقم (83) بتاريخ 2026/4/8.$b4$
  FROM laws WHERE law_no = 31 AND law_year = 2018 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2026-04-08', 'active' FROM ins4;

DO $verify138$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 31 AND law_year = 2018 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[138] القرار 31/2018 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 5 THEN RAISE EXCEPTION '[138] عدد المواد % بدل 5', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2026-04-08';
  IF v_v <> 5 THEN RAISE EXCEPTION '[138] عدد النسخ % بدل 5', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%الوقائع المصریة%' OR body LIKE '%FINANCIAL REGULATORY%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[138] % مادة بها تلف أو ترويسة أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND body LIKE 'بعد الاطلاع على قانون شركات المساهمة%' AND body LIKE '%قرار مجلس إدارة الهيئة رقم (21) لسنة 2016 بشأن ضوابط تداول%' AND body LIKE '%بتاريخ 2018/4/3.%' AND body LIKE '%قرر') THEN RAISE EXCEPTION '[138] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE 'يتم تداول ونقل ملكية وثائق صناديق الاستثمار الخيرية على النحو التالي%' AND body LIKE '%أولاً: بالنسبة لصناديق الاستثمار الخيرية المغلقة%' AND body LIKE '%ثانياً: بالنسبة لصناديق الاستثمار الخيرية المفتوحة%' AND body LIKE '%جبر الكسور%' AND body LIKE '%لجنة الإشراف بحسب الأحوال. (2)%' AND body LIKE '%وأنه على علم بأنه صندوق استثمار خيري%') THEN RAISE EXCEPTION '[138] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE '%رقم (21) لسنة 2016%') THEN RAISE EXCEPTION '[138] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND body LIKE '%من اليوم التالي لتاريخ نشره بالوقائع المصرية.%') THEN RAISE EXCEPTION '[138] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND body LIKE '%(1) تم التعديل بموجب قرار مجلس إدارة الهيئة رقم (83)%' AND body LIKE '%(2) تم استبدال البند%') THEN RAISE EXCEPTION '[138] الهوامش غير سليم'; END IF;
  IF v_len <> 3375 THEN RAISE EXCEPTION '[138] إجمالى طول المواد % بدل 3375', v_len; END IF;
  RAISE NOTICE '[138] القرار 31/2018: 5 مواد (ديباجة + 3 مواد + هوامش) و5 نسخ، إجمالى % حرف', v_len;
END
$verify138$;

COMMIT;
