-- 145_replace_decision_166_2020_meaning_of_financial_institutions_consolidated_to_2023_ocr_garbled_article_1_truncated_with_preamble_three_articles_and_footnotes.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (166) لسنة 2020 (بتاريخ 2020/10/28) بشأن تحديد
-- المقصود بمصطلح "المؤسسات المالية" الوارد بقرارات مجلس إدارة الهيئة، بالنص الموحد "وفقاً لآخر تعديل بتاريخ
-- 2023/11/29" (القرارات 66 بتاريخ 2021/4/27 و154 بتاريخ 2021/9/29 و250 بتاريخ 2023/11/29) كما نشرته الهيئة
-- على موقعها (ملف PDF من 3 صفحات، هو نفسه laws.official_url).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2) =====
-- مخزَّن منذ بذور الهجرات القديمة من تفريغ ترميز/مسح تالف، بثلاث مواد (1968 و294 و320 حرفاً) وبلا ديباجة ولا حواشٍ:
--   * المادة الأولى بأرقام مشوهة ("رقم )١١١( لسنة ٠١١59" بدل (120) لسنة 2019) وبنودها بأرقام مبعثرة ("؟-" و"“-" و"*-"
--     و"5-" ...) لا يُعرف ترتيبها، والبند 14 فيه "الأذشطة"؛ وبعد البند 17 تسربت الحاشية 2 مشوهة وتذييل الهيئة (القرية الذكية
--     والرقم البريدى والهاتف) و"=== page 3 ===" داخل المتن، ثم تأتى البنود 18-20 بعدها؛ والبند 21 (صندوق مصر الفرعى) مفقود.
--   * المادة الثانية مبتورة عند "بشأن الشروط الواجب" (ينقصها "توافرها فى مؤسسى شركة صندوق الاستثمار").
--   * المادة الثالثة يلحق بها تذييل الهيئة وبقايا ترميز.
-- وقائمة "المؤسسات المالية" هى المرجع المعرِّف لمصطلح يرد فى عشرات قرارات المجلس، فاختلاط ترتيب بنودها وفقد البند 21 يعطى
-- إجابة ناقصة أو مضللة. نسخ article_versions القديمة بتاريخ تشغيل البذر.
--
-- ===== المصدر والمنهجية =====
-- PDF رفعه صاحب المشروع (توليد Word بطبقة نصية بترميز عربى قديم لا يُعتمد عليها)؛ قُرئت الصفحات الثلاث بصرياً
-- (130 dpi، والديباجة والبنود 12-21 والحاشية بتكبير 260 dpi) وقوبلت بالنص المخزَّن. الأرقام لاتينية. حُذفت ترويسة
-- الهيئة وتذييل العنوان والهاتف. فكَّت الفواصل الطباعية بين الحروف ("الـ شروط" و"بـ شأن" و"غ سل" و"إ صدار" و"ا ستمراره"
-- و"مؤ سـ سي" تصير الشروط وبشأن وغسل وإصدار واستمراره ومؤسسي) لأنها أثر الحرف المباعد فى الملف لا إملاء المصدر.
-- أُبقى إملاء المصدر وهفواته ("مجلس الإدارة" بدل "مجلس إدارة الهيئة" فى اطلاع القرار 120/2019، و"الاولي" و"تم إضافة" فى
-- الحاشية 2، و"الالكتروني"). أُسقطت علامات التشكيل الصغيرة وأُبقى تنوين الفتح. ديباجة القرار لا تنتهى فى الملف بكلمة
-- "قرر" (تنتهى باطلاع جلسة المجلس "2020/10/28؛" ثم تبدأ المادة الأولى) فلم تُضَف.
-- الحاشيتان 1 و2 نُقلتا إلى مادة مستقلة آخر القرار ("هوامش القرار") مع علامة "(حاشية N)" فى موضعها: الأولى فى عنوان
-- الديباجة والثانية فى عنوان المادة الأولى (على غرار القرار 31/2018 والقرار 101/2020).
-- البند 21 (صندوق مصر الفرعى للخدمات المالية والتحول الرقمى) وارد فى المتن الموحد، وحاشية المصدر لا تذكر القرار الذى أضافه
-- (تذكر 19 و20 و14 و15 فقط)، فأُثبت كما فى المصدر ولم يُنسب لقرار لم يرد فى الملف.
--
-- ===== الهيكل =====
-- 5 مواد، 5 نسخ (version_no = 1): ديباجة (article_no = 0) باطلاعات ستة قرارات وقانون وجلسة المجلس، المادة الأولى
-- (تعريف المؤسسات المالية: 21 بنداً)، المادة الثانية (مؤسسو شركة صندوق الاستثمار)، المادة الثالثة (النشر والعمل
-- من اليوم التالى للنشر)، والمادة 4 هوامش القرار (حاشية 1 و2). أُبقيت المواد 1–3 بأرقامها حتى لا تعيد بذور الهجرات
-- القديمة إدراج مواد قديمة (ON CONFLICT DO NOTHING).
--
-- ===== التواريخ =====
-- المادتان 2 و3 والديباجة: effective_from = 2020-10-28 (تاريخ القرار)، لأن عدد الوقائع المصرية غير وارد فى الملف
-- فلم يُخمَّن تاريخ النشر. المادة 1 وهوامش القرار: 2023-11-29 (تاريخ آخر تعديل بالقرار 250/2023)، مع amended_by
-- 250/2023؛ والنص الموحد المنشور لا يتضمن النص السابق للتعديل. لا تُمس بيانات laws (enacted_at فارغ وعنوان
-- القانون مقتضب ويُعالجان فى هجرة بيانات laws لاحقة).
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (5 مواد بديباجة سليمة والمادة 4 موجودة)؛ والإدراج ON CONFLICT DO NOTHING. تحقق
-- الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، بقايا OCR أو تذييل، بنود المادة 1 الأحد والعشرون،
-- إجمالى الطول 3238 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix145$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 166 AND law_year = 2020 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[145] القرار 166/2020 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 5
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[145] القرار 166/2020 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[145] أُزيلت % مادة من القرار 166/2020 (مادة أولى مبتورة بأرقام مشوهة وبنود 18-21 متسربة وبقايا تذييل ومادتان مبتورتان)', v_n;
  END IF;
END
$fix145$;

WITH ins0_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة رقم (166) لسنة 2020 بتاريخ 2020/10/28 بشأن تحديد المقصود بمصطلح المؤسسات المالية الوارد بقرارات مجلس إدارة الهيئة وفقاً لآخر تعديل بتاريخ 2023/11/29 (حاشية 1)$h0$, $t0_0$ديباجة القرار$t0_0$, $b0_0$بعد الاطلاع على القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وعلى قرار مجلس إدارة الهيئة رقم (51) لسنة 2014 بشأن الشروط الواجب توافرها في مؤسسي شركة صندوق الاستثمار؛
وعلى قرار مجلس إدارة الهيئة رقم (23) لسنة 2016 بشأن قواعد إصدار السندات وصكوك التمويل غير الحاصلة على تصنيف ائتماني وقواعد الاكتتاب فيها وضوابط قيدها بالبورصة المصرية؛
وعلى قرار مجلس إدارة الهيئة رقم (53) لسنة 2018 بشأن ضوابط منح الترخيص واستمراره وقواعد تملك أسهم الشركات العاملة في الأنشطة المالية غير المصرفية؛
وعلى قرار مجلس إدارة الهيئة رقم (172) لسنة 2018 بشأن قواعد وإجراءات إصدار وطرح السندات قصيرة الأجل؛
وعلى قرار مجلس إدارة الهيئة رقم (48) لسنة 2019 بشأن ضوابط وإجراءات الطرح العام والخاص؛
وعلى قرار مجلس الإدارة رقم (120) لسنة 2019 بشأن الضوابط الرقابية في مجال مكافحة غسل الأموال وتمويل الإرهاب للجهات العاملة في مجال الأنشطة المالية غير المصرفية؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2020/10/28؛$b0_0$
  FROM laws WHERE law_no = 166 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-28', 'active' FROM ins0_0;

WITH ins1_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1_0$المادة الأولى (حاشية 2)$t1_0$, $b1_0$مع عدم الإخلال بتعريف المؤسسات المالية الوارد بقرار مجلس إدارة الهيئة رقم (120) لسنة 2019 المشار إليه، يقصد بمصطلح «المؤسسات المالية» أينما ورد في قرارات مجلس إدارة الهيئة، ما يلي:
1- البنوك المصرية وفروع البنوك الأجنبية الخاضعة لإشراف البنك المركزي المصري.
2- شركات التأمين أو إعادة التأمين.
3- الشركات التي يكون غرضها الاشتراك في تأسيس الشركات التي تصدر أوراق مالية أو زيادة رؤوس أموالها (بنوك الاستثمار).
4- الشركات والجهات التي تزاول نشاط البورصات.
5- شركات الوساطة في السندات والمتعاملون الرئيسيون.
6- شركات رأس المال المخاطر.
7- شركات المقاصة والإيداع والقيد المركزي.
8- شركات التمويل العقاري أو إعادة التمويل العقاري.
9- شركات التأجير التمويلي أو التخصيم.
10- شركات التمويل الاستهلاكي.
11- شركات تمويل المشروعات المتوسطة والصغيرة و/أو متناهية الصغر.
12- صناديق الاستثمار.
13- شركات الاستثمار المباشر.
14- الأشخاص الاعتبارية الأجنبية التي تمارس إحدى الأنشطة المالية المصرفية أو غير المصرفية الخاضعة لإشراف ورقابة جهة تمارس اختصاصات مثيلة للبنك المركزي المصري أو الهيئة بحسب الأحوال.
15- المؤسسات المالية العربية والإقليمية والدولية التي توافق عليها الهيئة.
16- الهيئة القومية للبريد.
17- صناديق التأمين الخاصة التي تبلغ حجم أموالها المستثمرة أكثر من 100 مليون جنيه.
18- الشركات أو الجهات من الأشخاص الاعتبارية العامة والخاصة الصادر بشأنها قرار من مجلس إدارة الهيئة.
19- جهاز تنمية المشروعات المتوسطة والصغيرة ومتناهية الصغر.
20- صندوق مصر السيادي للاستثمار والتنمية.
21- صندوق مصر الفرعي للخدمات المالية والتحول الرقمي.$b1_0$
  FROM laws WHERE law_no = 166 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2023-11-29', 'active', 250, 2023, $c1_0$النص الموحد للمادة الأولى بعد التعديلات بقرارات مجلس إدارة الهيئة رقم 66 بتاريخ 2021/4/27 ورقم 154 بتاريخ 2021/9/29 ورقم 250 بتاريخ 2023/11/29 (استبدال نصي البندين 14 و15)؛ والنص السابق للتعديل غير وارد فى المصدر.$c1_0$ FROM ins1_0;

WITH ins2_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2_0$المادة الثانية$t2_0$, $b2_0$مع عدم الإخلال بالمادة السابقة، يجوز أن تكون شركات إدارة صناديق الاستثمار (مدير الاستثمار) وشركات إدارة الأصول (الشركات التي تزاول نشاط إدارة صناديق الاستثمار وتكوين وإدارة محافظ الأوراق المالية)، من مؤسسي شركة صندوق الاستثمار وفقاً لقرار مجلس إدارة الهيئة رقم (51) لسنة 2014 بشأن الشروط الواجب توافرها في مؤسسي شركة صندوق الاستثمار.$b2_0$
  FROM laws WHERE law_no = 166 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-28', 'active' FROM ins2_0;

WITH ins3_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 3, 0, NULL, $t3_0$المادة الثالثة$t3_0$, $b3_0$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الالكتروني للهيئة، ويعمل به اعتباراً من اليوم التالي لتاريخ نشره بالوقائع المصرية.$b3_0$
  FROM laws WHERE law_no = 166 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2020-10-28', 'active' FROM ins3_0;

WITH ins4_0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 4, 0, NULL, $t4_0$هوامش القرار$t4_0$, $b4_0$حاشية 1: تم تعديل القرار بموجب قرارات مجلس إدارة الهيئة أرقام 66 بتاريخ 2021/4/27، 154 بتاريخ 2021/9/29، وقرار رقم (250) بتاريخ 2023/11/29.
حاشية 2: تم إضافة البند رقم 19 بموجب قرار مجلس إدارة الهيئة رقم 66 بتاريخ 2021/4/27، ثم إضافة البندين رقمي (19، 20) بموجب قرار مجلس إدارة الهيئة رقم 154 بتاريخ 2021/9/29. ثم تم استبدال نصي البندين (14، 15) من المادة الاولي بموجب قرار مجلس إدارة الهيئة رقم (250) بتاريخ 2023/11/29.$b4_0$
  FROM laws WHERE law_no = 166 AND law_year = 2020 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status, amended_by_law_no, amended_by_law_year, change_note)
SELECT id, 1, body, '2023-11-29', 'active', 250, 2023, $c4_0$هوامش القرار كما وردت فى النص الموحد المنشور (حاشية 1 على عنوان القرار وحاشية 2 على المادة الأولى).$c4_0$ FROM ins4_0;

DO $verify145$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 166 AND law_year = 2020 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[145] القرار 166/2020 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 5 THEN RAISE EXCEPTION '[145] عدد المواد % بدل 5', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2020-10-28';
  IF v_v <> 3 THEN RAISE EXCEPTION '[145] عدد النسخ % بدل 3', v_v; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND a.article_no = 1 AND a.article_suffix_order = 0 AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2023-11-29' AND av.amended_by_law_no = 250 AND av.amended_by_law_year = 2023;
  IF v_v <> 1 THEN RAISE EXCEPTION '[145] نسخة المادة 1/0 غير سليمة'; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND a.article_no = 4 AND a.article_suffix_order = 0 AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2023-11-29' AND av.amended_by_law_no = 250 AND av.amended_by_law_year = 2023;
  IF v_v <> 1 THEN RAISE EXCEPTION '[145] نسخة المادة 4/0 غير سليمة'; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%٠١١59%' OR body LIKE '%الأذشطة%' OR body LIKE '%القرية الذكية%' OR body LIKE '%تليفون%' OR body LIKE '%البريدى%' OR body LIKE '%؟-%' OR body LIKE '%“-%' OR body LIKE '%*-%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[145] % مادة بها تلف أو بقايا OCR أو ترويسة', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%القانون رقم (10) لسنة 2009%' AND body LIKE '%رقم (51) لسنة 2014%' AND body LIKE '%رقم (23) لسنة 2016%' AND body LIKE '%رقم (53) لسنة 2018%' AND body LIKE '%رقم (172) لسنة 2018%' AND body LIKE '%رقم (48) لسنة 2019%' AND body LIKE '%مجلس الإدارة رقم (120) لسنة 2019%' AND body LIKE '%بتاريخ 2020/10/28؛') THEN RAISE EXCEPTION '[145] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND article_suffix_order = 0 AND body LIKE 'مع عدم الإخلال بتعريف المؤسسات المالية%' AND body LIKE '%رقم (120) لسنة 2019 المشار إليه%' AND body LIKE '%1- البنوك المصرية وفروع البنوك الأجنبية%' AND body LIKE '%2- شركات التأمين أو إعادة التأمين.%' AND body LIKE '%3- الشركات التي يكون غرضها الاشتراك%(بنوك الاستثمار).%' AND body LIKE '%6- شركات رأس المال المخاطر.%' AND body LIKE '%10- شركات التمويل الاستهلاكي.%' AND body LIKE '%12- صناديق الاستثمار.%' AND body LIKE '%14- الأشخاص الاعتبارية الأجنبية%بحسب الأحوال.%' AND body LIKE '%15- المؤسسات المالية العربية والإقليمية والدولية%' AND body LIKE '%16- الهيئة القومية للبريد.%' AND body LIKE '%17- صناديق التأمين الخاصة%أكثر من 100 مليون جنيه.%' AND body LIKE '%18- الشركات أو الجهات من الأشخاص الاعتبارية%' AND body LIKE '%19- جهاز تنمية المشروعات%' AND body LIKE '%20- صندوق مصر السيادي للاستثمار والتنمية.%' AND body LIKE '%21- صندوق مصر الفرعي للخدمات المالية والتحول الرقمي.') THEN RAISE EXCEPTION '[145] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0 AND body LIKE 'مع عدم الإخلال بالمادة السابقة%' AND body LIKE '%رقم (51) لسنة 2014%' AND body LIKE '%في مؤسسي شركة صندوق الاستثمار.') THEN RAISE EXCEPTION '[145] المادة 2 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 3 AND article_suffix_order = 0 AND body LIKE 'ينشر هذا القرار في الوقائع المصرية%' AND body LIKE '%من اليوم التالي لتاريخ نشره بالوقائع المصرية.') THEN RAISE EXCEPTION '[145] المادة 3 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 4 AND article_suffix_order = 0 AND body LIKE 'حاشية 1:%' AND body LIKE '%حاشية 2:%استبدال نصي البندين (14، 15)%بتاريخ 2023/11/29.') THEN RAISE EXCEPTION '[145] الهوامش غير سليم'; END IF;
  IF v_len <> 3238 THEN RAISE EXCEPTION '[145] إجمالى طول المواد % بدل 3238', v_len; END IF;
  RAISE NOTICE '[145] القرار 166/2020: 5 مواد و5 نسخ، إجمالى % حرف', v_len;
END
$verify145$;

COMMIT;
