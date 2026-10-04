-- 113_replace_corrupted_decision_1_2025_private_insurance_funds_with_clean_text.sql
--
-- إصلاح تلف النص فى قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (1) لسنة 2025
-- بشأن إنشاء أكثر من صندوق تأمين خاص فى ذات الجهة التابع لها أعضاء الصندوق
-- (المنشور بالوقائع المصرية، العدد 30 تابع، فى 6 فبراير 2025، ص 3-4).
--
-- ===== الحالة السابقة =====
-- الصف موجود فى laws (kind='board_decision') بمادتين، لكن متنهما مُستخرَج من الطبقة
-- النصية للـPDF (هجرات 004/005/006) وبه تلف: رموز استبدال (U+FFFD) داخل الكلمات،
-- وفقد/تبديل حروف "لا" (مثل "الحاالت" بدل "الحالات" و"اآلتية" بدل "الآتية"
-- و"لالئحة" بدل "للائحة")، وتسرُّب ترويسة الصفحة ("الوقائع المصرية - العدد 30 ...")
-- داخل متن المادة الأولى، وترقيم البنود مكسور ("- 1اخت..."). أى أن البحث والاستشهاد
-- يعملان على نص غير سليم.
--
-- ===== المصدر والمنهجية =====
-- PDF الوقائع المصرية (صفحتان) رفعه صاحب المشروع (نشر-قرار-رقم-1-لسنة-2025-بالوقائع.pdf).
-- نُقل النص بقراءة بصرية للصفحتين بتكبير 220 dpi كلمةً كلمة (لا من الطبقة النصية)، مع
-- الإبقاء على إملاء المصدر (فى/التى/الآتى...) واستبدال الأرقام الهندية بلاتينية اتساقاً
-- مع بقية المنصة. أُضيفت ديباجة القرار (أساس الإصدار وموافقة المجلس بتاريخ 2025/1/15)
-- كمادة article_no=0 على نمط هجرة 059، لأنها لم تكن مخزَّنة أصلاً.
--
-- ===== التواريخ =====
-- effective_from = 2025-02-07: المادة الثانية تنص على العمل به من اليوم التالى لتاريخ
-- نشره بالوقائع، والنشر 6 فبراير 2025 (ترويسة الصفحة). enacted_at لم يُعدَّل (يبقى NULL):
-- نص القرار لا يذكر تاريخ إصدار، والتاريخ المذكور (2025/1/15) هو جلسة موافقة المجلس
-- لا تاريخ الإصدار، فلا أخمِّن تاريخاً غير منصوص عليه.
--
-- official_url لم يُمس: الرابط المخزَّن من الهجرات السابقة يحمل اسم الملف نفسه المرفوع.
--
-- قابلة لإعادة التشغيل: الحذف مشروط بوجود رمز التلف فى المادة الأولى القديمة، والإدراج
-- محمى بـON CONFLICT DO NOTHING، وتحقق الختام محصور فى هذا القرار. وإعادة تشغيل
-- 004/005/006 لا تُعيد التلف لأن إدراجها يتخطى الصفوف الموجودة.
--
-- ملاحظة تشغيلية: المواد الجديدة بلا embedding؛ يلزم scripts/backfill-embeddings.js بعد النشر.

BEGIN;

DO $fix113$
DECLARE
  v_law_id uuid;
  v_bad int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 1 AND law_year = 2025 AND kind = 'board_decision';
  IF v_law_id IS NULL THEN
    RAISE WARNING '[113] القرار 1/2025 غير موجود فى laws — تخطّى';
    RETURN;
  END IF;
  SELECT count(*) INTO v_bad FROM articles
   WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no IN (1, 2)
     AND (body LIKE '%' || chr(65533) || '%' OR body LIKE '%الوقائع املصرية%');
  IF v_bad > 0 THEN
    DELETE FROM articles WHERE law_id = v_law_id AND article_suffix_order = 0 AND article_no IN (1, 2);
    RAISE NOTICE '[113] أُزيلت المادتان التالفتان';
  ELSE
    RAISE NOTICE '[113] لا تلف ظاهر — تخطّى الحذف';
  END IF;
END
$fix113$;

WITH ins0 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 0, 0, NULL, 'ديباجة القرار', $b0$بعد الاطلاع على القانون رقم 10 لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قانون التأمين الموحد الصادر بالقانون رقم 155 لسنة 2024 ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2025/1/15 ؛
قرر :$b0$
  FROM laws WHERE law_no = 1 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-07', 'active' FROM ins0;

WITH ins1 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 1, 0, NULL, 'المادة الأولى', $b1$يجوز إنشاء أكثر من صندوق تأمين خاص فى ذات الجهة التابع لها أعضاء الصندوق فى الحالات الآتية :
1 - اختلاف المزايا التى يمنحها كل صندوق عن الآخر وفقًا للائحة النظام الأساسى ، وتكون أنواع المزايا الممنوحة على النحو الآتى :
(أ) المزايا التأمينية .
(ب) المزايا الادخارية .
(ج) المزايا العلاجية .
(د) المزايا الاجتماعية .
(هـ) مزايا المعاشات الدورية .
(و) المزايا الأخرى .
2 - اختلاف أعضاء كل صندوق داخل الجهة التابع لها هؤلاء الأعضاء ، سواء من حيث الكادر أو الفئة الوظيفية أو الأجر أو غيرها .
3 - أى أسباب أخرى تراها الهيئة وبعد موافاتها بمبررات إنشاء أكثر من صندوق داخل الجهة الواحدة .$b1$
  FROM laws WHERE law_no = 1 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-07', 'active' FROM ins1;

WITH ins2 AS (
  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, title, body)
  SELECT id, 2, 0, NULL, 'المادة الثانية', $b2$يُنشر هذا القرار فى الوقائع المصرية ، وعلى الموقع الإلكترونى للهيئة ، ويُعمل به من اليوم التالى لتاريخ نشره بالوقائع المصرية .
رئيس مجلس إدارة
الهيئة العامة للرقابة المالية
د. محمد فريد صالح$b2$
  FROM laws WHERE law_no = 1 AND law_year = 2025 AND kind = 'board_decision'
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING
  RETURNING id, body
)
INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
SELECT id, 1, body, '2025-02-07', 'active' FROM ins2;

DO $verify113$
DECLARE
  v_law_id uuid;
  v_arts int;
  v_vers int;
  v_bad int;
  v_len int;
BEGIN
  SELECT id INTO v_law_id FROM laws WHERE law_no = 1 AND law_year = 2025 AND kind = 'board_decision';
  SELECT count(*), COALESCE(sum(length(body)),0),
         count(*) FILTER (WHERE body LIKE '%' || chr(65533) || '%' OR body LIKE '%الوقائع املصرية%' OR body LIKE '%الحاالت%' OR body LIKE '%اآلتي%')
    INTO v_arts, v_len, v_bad FROM articles WHERE law_id = v_law_id;
  SELECT count(*) INTO v_vers FROM article_versions av JOIN articles a ON a.id = av.article_id
   WHERE a.law_id = v_law_id AND av.effective_from = DATE '2025-02-07' AND av.status = 'active';
  IF v_arts <> 3 OR v_vers <> 3 THEN
    RAISE EXCEPTION '[113] متوقَّع 3 مواد و3 نسخ، الفعلى: % / %', v_arts, v_vers;
  END IF;
  IF v_bad <> 0 THEN
    RAISE EXCEPTION '[113] ما زال فى % مادة أثر تلف', v_bad;
  END IF;
  IF v_len <> 1002 THEN
    RAISE EXCEPTION '[113] مجموع الأطوال % لا يطابق المتوقع 1002', v_len;
  END IF;
  RAISE NOTICE '[113] قرار 1/2025: % مواد و% نسخ سليمة.', v_arts, v_vers;
END
$verify113$;

COMMIT;
