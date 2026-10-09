-- 140_replace_decision_37_2023_insurance_advisory_committee_ocr_garbled_two_articles_with_clean_preamble_and_two_articles.sql
--
-- إعادة رفع قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (37) لسنة 2023 (بتاريخ 2023/3/8) بشأن
-- تشكيل اللجنة الاستشارية فى مجال التأمين، المنشور على الموقع الإلكترونى للهيئة (ملف PDF من صفحة واحدة).
--
-- ===== الحالة السابقة (مراجعة الـ153 وثيقة، أولوية P2) =====
-- مخزَّن منذ الهجرة 006 بمادتين من تفريغ مسح ضوئى (OCR) تالف: المادة الأولى (696 حرفاً) بها "بشان"
-- و"عالمياًء" وأرقام قائمة الأعضاء مبتورة (". السيدة الدكتورة" و"0. السيد" و"1 السيد" بدل 9 و10 و11)،
-- والمادة الثانية (377 حرفاً) تبدأ بسطر مشوَّه ("نم دغ يرأ حذاماْ اخ دأ مذاطا") وتحمل اسم الموقِّع
-- مشوَّهاً ("صالع" و"الغينة") وتذييل الهيئة (العنوان والهاتف والفاكس) مشوَّهاً بالأرقام والرموز. والنص
-- بلا ديباجة (أساس الإصدار وتاريخ جلستى المجلس). نسختا article_versions القديمتان تحملان
-- effective_from = تاريخ تشغيل البذر لا تاريخ سريان القرار. لم تُمس بيانات laws (enacted_at فارغ
-- وgovernance_scope = false قائمان؛ ويُترك تعديلهما لقرار منفصل).
--
-- ===== المصدر والمنهجية =====
-- PDF رفعه صاحب المشروع (مسح ضوئى بلا طبقة نصية، ملف 37.pdf وهو نفسه laws.official_url). قُرئت الصفحة
-- بصرياً على ثلاثة أجزاء بتكبير 200 dpi (الترويسة والديباجة، المادة الأولى وبعض الأعضاء، آخر الأعضاء
-- والمادة الثانية والتوقيع) وقوبلت بالنص المخزَّن كلمةً كلمة: أسماء الأعضاء الأحد عشر مطابقة للمخزَّن
-- ما عدا الترقيم المبتور. حُذفت ترويسة الهيئة ("رئيس الهيئة" والشعار) وتذييل العنوان والهاتف
-- ولا يُحتسبان من نص القرار، ويُحفظ عنوان القرار وتاريخه فى hierarchical_location للديباجة. أُبقى
-- إملاء المصدر ("السيد الاستاذ/" بلا همزة فى البند 10، و"الابجدى" بلا همزة، و"الالكترونى")، وأُسقطت
-- علامات التشكيل الصغيرة (ضمة "يُنشر" و"يُعمل" و"يُلغى"، وأُبقى تنوين الفتح كإملاء) ليتسق البحث النصى مع باقى قاعدة البيانات.
-- القرار بلا "قرر :" بنقطتين فى المصدر، فتنتهى الديباجة بـ"قرر" كما فى المصدر.
--
-- ===== الهيكل =====
-- 3 مواد، 3 نسخ (version_no = 1): ديباجة (article_no = 0) تضم الاطلاعات وجلستى المجلس، المادة الأولى
-- (تشكيل اللجنة وأسماء أعضائها الأحد عشر وسريان قواعد القرار 141/2017 على نظام عملها)، المادة الثانية
-- (النشر والعمل من تاريخ الصدور والإلغاء، مع التوقيع). أُبقيت المادتان 1 و2 بأرقامهما حتى لا يعيد بذر 006
-- إدراج مادتين قديمتين (إدراجه ON CONFLICT DO NOTHING على المفتاح نفسه).
--
-- ===== التاريخ =====
-- effective_from = 2023-03-08: المادة الثانية تُعمل القرار "من تاريخ صدوره" والقرار مؤرخ 2023/3/8
-- (والقرار منشور على الموقع لا فى الوقائع المصرية).
--
-- ===== قابلية إعادة التشغيل =====
-- الحذف مشروط بألا تكون الحالة نظيفة (3 مواد بديباجة سليمة والمادة 2 موجودة)؛ والإدراج
-- ON CONFLICT DO NOTHING. تحقق الختام محصور فى هذا القرار ويفشل عند أى انحراف (عدد، تلف، تشكيل،
-- محتوى، بقايا تذييل أو OCR، إجمالى الطول 1265 حرفاً).
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;
DO $fix140$
DECLARE
  v_law_id uuid;
  v_n int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 37 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[140] القرار 37/2023 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  IF (SELECT count(*) FROM articles WHERE law_id = v_law_id) = 3
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND article_suffix_order = 0 AND title = 'ديباجة القرار' AND body LIKE 'بعد الاطلاع%')
     AND EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND article_suffix_order = 0) THEN
    RAISE NOTICE '[140] القرار 37/2023 نظيف بالفعل — تخطّى الحذف';
  ELSE
    SELECT count(*) INTO v_n FROM articles WHERE law_id = v_law_id;
    DELETE FROM articles WHERE law_id = v_law_id;
    RAISE NOTICE '[140] أُزيلت % مادة من القرار 37/2023 (تفريغ مسح ضوئى تالف)', v_n;
  END IF;
END
$fix140$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, $h0$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 37 لسنة 2023 بتاريخ 2023/3/8 بشأن تشكيل اللجنة الاستشارية في مجال التأمين$h0$, $t0$ديباجة القرار$t0$, $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية؛
وعلى قرار رئيس الجمهورية رقم 192 لسنة 2009 بإصدار النظام الأساسي للهيئة العامة للرقابة المالية؛
وعلى قرار مجلس إدارة الهيئة رقم 141 لسنة 2017 بشأن تشكيل لجان الهيئة الاستشارية من المتخصصين وأهل الخبرة وتعديلاته؛
وعلى موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2023/2/22 وبتاريخ 2023/3/8
قرر$b0$
  FROM laws WHERE law_no = 37 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-08', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, $t1$المادة الأولى$t1$, $b1$تشكل لجنة استشارية من المتخصصين وأهل الخبرة في مجال نشاط التأمين لإبداء الرأي وتقديم المشورة للهيئة بشأن تنمية النشاط وتطوير نظم العمل به وتحسين القدرات التنافسية إقليمياً وعالمياً، ويكون تشكيلها على النحو التالي: (حسب الترتيب الابجدي)
1. السيد الأستاذ/إيهاب محمد أبو المجد
2. السيد الأستاذ/ حسن محمد حسن درويش
3. السيد الأستاذ/ سعيد عادل الألفي
4. السيد الأستاذ/ عادل أحمد موسى
5. السيدة الأستاذة/ عالية حلمي
6. السيدة الأستاذة/ عبير حلمي صالح
7. السيد الأستاذ/ علاء الزهيري
8. السيد الأستاذ/ عمر عبد الحميد جودة
9. السيدة الدكتورة/ غادة محمود علي
10. السيد الاستاذ/ محمد مهران طايع أحمد
11. السيد الأستاذ/ وليد إبراهيم عوف
ويسري بشأن نظام عمل اللجنة القواعد الواردة بقرار مجلس إدارة الهيئة رقم 141 لسنة 2017.$b1$
  FROM laws WHERE law_no = 37 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-08', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, $t2$المادة الثانية$t2$, $b2$ينشر هذا القرار على الموقع الالكتروني للهيئة، ويعمل به من تاريخ صدوره، ويلغى كل حكم يخالف أحكامه.
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b2$
  FROM laws WHERE law_no = 37 AND law_year = 2023 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2023-03-08', 'active' FROM ins2;

DO $verify140$
DECLARE
  v_law_id uuid;
  v_n int; v_v int; v_bad int; v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 37 AND law_year = 2023 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[140] القرار 37/2023 غير موجود — لا تحقق';
    RETURN;
  END IF;
  SELECT count(*), COALESCE(sum(length(body)), 0) INTO v_n, v_len FROM articles WHERE law_id = v_law_id;
  IF v_n <> 3 THEN RAISE EXCEPTION '[140] عدد المواد % بدل 3', v_n; END IF;
  SELECT count(*) INTO v_v FROM article_versions av JOIN articles a ON a.id = av.article_id WHERE a.law_id = v_law_id AND av.version_no = 1 AND av.status = 'active' AND av.effective_from = DATE '2023-03-08';
  IF v_v <> 3 THEN RAISE EXCEPTION '[140] عدد النسخ % بدل 3', v_v; END IF;
  SELECT count(*) INTO v_bad FROM articles WHERE law_id = v_law_id AND (body ~ '[٠-٩۰-۹]' OR body ~ '[ٌ-ْ]' OR body LIKE '%' || chr(65533) || '%' OR body LIKE '%ـ%' OR body LIKE '%بشان%' OR body LIKE '%عالمياًء%' OR body LIKE '%نم دغ%' OR body LIKE '%صالع%' OR body LIKE '%الغينة%' OR body LIKE '%القرية الذكية%' OR body LIKE '%الرقم البريدى%' OR body LIKE '%تليفون%' OR body LIKE '%FRA%');
  IF v_bad > 0 THEN RAISE EXCEPTION '[140] % مادة بها تلف أو بقايا OCR أو تذييل', v_bad; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 0 AND body LIKE 'بعد الاطلاع%' AND body LIKE '%القانون رقم 10 لسنة 2009%' AND body LIKE '%رقم 192 لسنة 2009%' AND body LIKE '%رقم 141 لسنة 2017%' AND body LIKE '%بتاريخ 2023/2/22 وبتاريخ 2023/3/8%' AND body LIKE '%قرر') THEN RAISE EXCEPTION '[140] الديباجة غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 1 AND body LIKE '%إيهاب محمد أبو المجد%' AND body LIKE '%حسن محمد حسن درويش%' AND body LIKE '%سعيد عادل الألفي%' AND body LIKE '%عادل أحمد موسى%' AND body LIKE '%عالية حلمي%' AND body LIKE '%عبير حلمي صالح%' AND body LIKE '%علاء الزهيري%' AND body LIKE '%عمر عبد الحميد جودة%' AND body LIKE '%غادة محمود علي%' AND body LIKE '%محمد مهران طايع أحمد%' AND body LIKE '%وليد إبراهيم عوف%' AND body LIKE '%11. السيد الأستاذ/ وليد%' AND body LIKE '%10. السيد الاستاذ/%' AND body LIKE 'تشكل لجنة استشارية%' AND body LIKE '%رقم 141 لسنة 2017.') THEN RAISE EXCEPTION '[140] المادة 1 غير سليم'; END IF;
  IF NOT EXISTS (SELECT 1 FROM articles WHERE law_id = v_law_id AND article_no = 2 AND body LIKE 'ينشر هذا القرار على الموقع الالكتروني للهيئة، ويعمل به من تاريخ صدوره%' AND body LIKE '%د. محمد فريد صالح' AND length(body) < 300) THEN RAISE EXCEPTION '[140] المادة 2 غير سليمة'; END IF;
  IF v_len <> 1265 THEN RAISE EXCEPTION '[140] إجمالى طول المواد % بدل 1265', v_len; END IF;
  RAISE NOTICE '[140] القرار 37/2023: 3 مواد (ديباجة + مادتان) و3 نسخ، إجمالى % حرف', v_len;
END
$verify140$;

COMMIT;
