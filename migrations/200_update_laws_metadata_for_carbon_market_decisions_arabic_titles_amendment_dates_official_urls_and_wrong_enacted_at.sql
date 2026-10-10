-- 200_update_laws_metadata_for_carbon_market_decisions_arabic_titles_amendment_dates_official_urls_and_wrong_enacted_at.sql
--
-- تحديث بيانات جدول laws الوصفية لقرارات سوق الكربون الستة التى أُعيد رفع نصوصها بالهجرات 194–199
-- (636/2024 و57/2023 و163/2023 و31/2024 و30/2024 و1732/2024). لا تمس هذه الهجرة جدولى articles وarticle_versions.
--
-- ===== ما يتغير =====
--   * title: من العنوان الإنجليزى (ترجمة غير رسمية "Decree ...") إلى العنوان العربى الرسمى كما طُبع فى المصدر (رقم القرار والسنة وموضوعه، بلا التاريخ ولا ملاحظة النص الموحد).
--     قرار 1732/2024 عنوانه "قرار رئيس الهيئة" لا "Board Decree" كما كان مخزناً. short_title (عربى أصلاً) لا يتغير؛ والمعروض للمستخدم هو short_title ثم title.
--   * enacted_at لقرار 1732/2024: من 2024-08-17 (خاطئ) إلى 2024-07-18 (تاريخ القرار المطبوع فى الوقائع المصرية العدد 155 بتاريخ 2024/7/20).
--   * last_amended_at: 57/2023 -> 2025-03-26 (النص الموحد وفقاً لآخر تعديل)، و163/2023 و31/2024 -> 2024-10-30.
--   * official_url: إلى ملفات الهيئة العربية الرسمية بعد التحقق من فتحها ومن رقم القرار وتاريخه وتاريخ آخر تعديل فى ترويستها:
--       31/2024 وفقاً لآخر تعديل 2024/10/30، و163/2023 وفقاً لآخر تعديل 2024/10/30، و30/2024 و1732/2024 (نسخة الوقائع المصرية: العدد 54 تابع (أ) والعدد 155).
--
-- ===== ما لا يتغير (ويُراجَع) =====
--   * status يبقى in_force لكل الصفوف (عُرف الجدول: 179 من 180 صفاً in_force، والتعديل يظهر فى last_amended_at).
--   * kind لقرار 1732/2024 يبقى board_decision رغم أنه قرار رئيس الهيئة: قيود chk_laws_kind لا تتيح قيمة لقرارات رئيس الهيئة، وتوسيعها يمس التطبيق.
--   * official_url لقرار 57/2023 يبقى الرابط الإنجليزى: ملف الهيئة العربى المنشور على موقعها (يناير 2025) يحمل آخر تعديل 2024/11/13 بينما المخزَّن نص 2025/3/26 فلا يطابقه.
--   * قرار 636/2024: لا enacted_at (تاريخ الإصدار غير مذكور فى النص المنشور؛ والنشر بالعدد 9 مكرر (أ) بتاريخ 2024/3/3) ولا رابط عربى متحقق منه؛ يبقى الرابط الإنجليزى.
--   * enacted_at للقرارات 57/2023 و163/2023 و31/2024 و30/2024 صحيح بالفعل (2023-03-22 و2023-08-09 و2024-01-31 و2024-01-31) ولا يُمس.
--
-- ===== قابلية إعادة التشغيل =====
-- التحديث يضبط قيماً صريحة (كل تشغيل يُنتج الحالة نفسها)؛ والقيم التى لا تتغير تُترك بـ COALESCE. ما لم يوجد القرار فى laws يُتخطى بتحذير.
-- تحقق الختام يفشل الهجرة إن اختلف أى حقل عن المتوقع، وتُتخطى مرحلة التحقق بتحذير إن لم توجد الستة كلها. الاستعلام يقصر التحديث على هذه الصفوف الستة بمفتاحها (country_code, law_no, law_year, kind) فلا يلمس غيرها.

BEGIN;

DO $upd200$
DECLARE
  r record;
  v_n int;
BEGIN
  FOR r IN SELECT * FROM (VALUES
  (636, 2024, 'pm_decision', 'قرار رئيس مجلس الوزراء رقم (636) لسنة 2024 بتعديل بعض أحكام معايير المحاسبة المصرية', NULL, NULL, NULL),
  (57, 2023, 'board_decision', 'قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (57) لسنة 2023 بشأن لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية واختصاصاتها', NULL, DATE '2025-03-26', NULL),
  (163, 2023, 'board_decision', 'قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (163) لسنة 2023 بشأن معايير قيد جهات التحقق والمصادقة لمشروعات خفض الانبعاثات الكربونية لدى الهيئة', NULL, DATE '2024-10-30', 'https://fra.gov.eg/wp-content/uploads/2025/01/163-2023-%D9%85%D8%B9%D8%A7%D9%8A%D9%8A%D8%B1-%D9%82%D9%8A%D8%AF-%D8%AC%D9%87%D8%A7%D8%AA-%D8%A7%D9%84%D8%AA%D8%AD%D9%82%D9%82-%D9%88%D8%A7%D9%84%D9%85%D8%B5%D8%A7%D8%AF%D9%82%D8%A9-%D9%84%D9%85%D8%B4%D8%B1%D9%88%D8%B9%D8%A7%D8%AA-%D8%AE%D9%81%D8%B6-%D8%A7%D9%84%D8%A7%D9%86%D8%A8%D8%B9%D8%A7%D8%AB%D8%A7%D8%AA.pdf'),
  (31, 2024, 'board_decision', 'قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (31) لسنة 2024 بشأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية', NULL, DATE '2024-10-30', 'https://fra.gov.eg/wp-content/uploads/2025/01/31-2024-%D9%88%D9%81%D9%82%D8%A7-%D9%84%D8%A7%D8%AE%D8%B1-%D8%AA%D8%B9%D8%AF%D9%8A%D9%84.pdf'),
  (30, 2024, 'board_decision', 'قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (30) لسنة 2024 بشأن معايير اعتماد سجلات الكربون الطوعية المحلية لدى الهيئة', NULL, NULL, 'https://fra.gov.eg/wp-content/uploads/2025/01/alamiria_2024_30.pdf'),
  (1732, 2024, 'board_decision', 'قرار رئيس الهيئة العامة للرقابة المالية رقم (1732) لسنة 2024 بشأن شروط حصول شركات السمسرة في الأوراق المالية على موافقة الهيئة للتعامل على شهادات خفض الانبعاثات الكربونية', DATE '2024-07-18', NULL, 'https://fra.gov.eg/wp-content/uploads/2025/01/alamiria_2024_1732.pdf')
  ) AS t(law_no, law_year, kind, title, enacted_at, last_amended_at, official_url)
  LOOP
    UPDATE laws
       SET title = r.title,
           enacted_at = COALESCE(r.enacted_at, enacted_at),
           last_amended_at = COALESCE(r.last_amended_at, last_amended_at),
           official_url = COALESCE(r.official_url, official_url)
     WHERE country_code = 'EG' AND law_no = r.law_no AND law_year = r.law_year AND kind = r.kind;
    GET DIAGNOSTICS v_n = ROW_COUNT;
    IF v_n = 0 THEN
      RAISE WARNING '[200] القرار %/% غير موجود فى laws — تخطّى', r.law_no, r.law_year;
    END IF;
  END LOOP;
END
$upd200$;

DO $verify200$
DECLARE
  v_n int;
BEGIN
  SELECT count(*) INTO v_n FROM laws WHERE country_code = 'EG' AND (law_no, law_year) IN ((636,2024),(57,2023),(163,2023),(31,2024),(30,2024),(1732,2024));
  IF v_n <> 6 THEN
    RAISE WARNING '[200] وُجد % صفاً فقط من ستة قرارات متوقعة — تُتخطى مرحلة التحقق', v_n;
    RETURN;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM laws WHERE country_code = 'EG' AND law_no = 636 AND law_year = 2024 AND kind = 'pm_decision' AND title = 'قرار رئيس مجلس الوزراء رقم (636) لسنة 2024 بتعديل بعض أحكام معايير المحاسبة المصرية') THEN RAISE EXCEPTION '[200] بيانات القرار 636/2024 غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM laws WHERE country_code = 'EG' AND law_no = 57 AND law_year = 2023 AND kind = 'board_decision' AND title = 'قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (57) لسنة 2023 بشأن لجنة الإشراف والرقابة على وحدات خفض الانبعاثات الكربونية واختصاصاتها' AND last_amended_at = DATE '2025-03-26') THEN RAISE EXCEPTION '[200] بيانات القرار 57/2023 غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM laws WHERE country_code = 'EG' AND law_no = 163 AND law_year = 2023 AND kind = 'board_decision' AND title = 'قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (163) لسنة 2023 بشأن معايير قيد جهات التحقق والمصادقة لمشروعات خفض الانبعاثات الكربونية لدى الهيئة' AND last_amended_at = DATE '2024-10-30' AND official_url = 'https://fra.gov.eg/wp-content/uploads/2025/01/163-2023-%D9%85%D8%B9%D8%A7%D9%8A%D9%8A%D8%B1-%D9%82%D9%8A%D8%AF-%D8%AC%D9%87%D8%A7%D8%AA-%D8%A7%D9%84%D8%AA%D8%AD%D9%82%D9%82-%D9%88%D8%A7%D9%84%D9%85%D8%B5%D8%A7%D8%AF%D9%82%D8%A9-%D9%84%D9%85%D8%B4%D8%B1%D9%88%D8%B9%D8%A7%D8%AA-%D8%AE%D9%81%D8%B6-%D8%A7%D9%84%D8%A7%D9%86%D8%A8%D8%B9%D8%A7%D8%AB%D8%A7%D8%AA.pdf') THEN RAISE EXCEPTION '[200] بيانات القرار 163/2023 غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM laws WHERE country_code = 'EG' AND law_no = 31 AND law_year = 2024 AND kind = 'board_decision' AND title = 'قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (31) لسنة 2024 بشأن قواعد قيد وشطب شهادات خفض الانبعاثات الكربونية بالبورصات المصرية' AND last_amended_at = DATE '2024-10-30' AND official_url = 'https://fra.gov.eg/wp-content/uploads/2025/01/31-2024-%D9%88%D9%81%D9%82%D8%A7-%D9%84%D8%A7%D8%AE%D8%B1-%D8%AA%D8%B9%D8%AF%D9%8A%D9%84.pdf') THEN RAISE EXCEPTION '[200] بيانات القرار 31/2024 غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM laws WHERE country_code = 'EG' AND law_no = 30 AND law_year = 2024 AND kind = 'board_decision' AND title = 'قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم (30) لسنة 2024 بشأن معايير اعتماد سجلات الكربون الطوعية المحلية لدى الهيئة' AND official_url = 'https://fra.gov.eg/wp-content/uploads/2025/01/alamiria_2024_30.pdf') THEN RAISE EXCEPTION '[200] بيانات القرار 30/2024 غير سليمة'; END IF;
  IF NOT EXISTS (SELECT 1 FROM laws WHERE country_code = 'EG' AND law_no = 1732 AND law_year = 2024 AND kind = 'board_decision' AND title = 'قرار رئيس الهيئة العامة للرقابة المالية رقم (1732) لسنة 2024 بشأن شروط حصول شركات السمسرة في الأوراق المالية على موافقة الهيئة للتعامل على شهادات خفض الانبعاثات الكربونية' AND enacted_at = DATE '2024-07-18' AND official_url = 'https://fra.gov.eg/wp-content/uploads/2025/01/alamiria_2024_1732.pdf') THEN RAISE EXCEPTION '[200] بيانات القرار 1732/2024 غير سليمة'; END IF;
  IF EXISTS (SELECT 1 FROM laws WHERE country_code = 'EG' AND (law_no, law_year) = (1732, 2024) AND (title LIKE '%Decree%' OR enacted_at <> DATE '2024-07-18')) THEN
    RAISE EXCEPTION '[200] قرار 1732/2024 ما زال بعنوان إنجليزى أو بتاريخ خاطئ';
  END IF;
  RAISE NOTICE '[200] بيانات laws الوصفية لقرارات الكربون الستة سليمة';
END
$verify200$;

COMMIT;
