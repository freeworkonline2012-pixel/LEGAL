-- ============================================================================
-- 220 — إضافة قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 196 لسنة 2022 (تعديل قرار 107/2021: الإفصاح عن الاستدامة والآثار المالية للتغيرات المناخية)
-- ----------------------------------------------------------------------------
-- المصدر: الوقائع المصرية العدد 4 (تابع) فى 4 يناير 2023، صفحتان (2 و3) قدمهما المالك بصيغة PDF؛ قُرئتا بصرياً ونُقل النص كما طُبع (الأرقام لاتينية، والتنوين فى «مكرراً» موحَّد).
-- المحتوى: ديباجة + مادتان: (1) إضافة «المادة الأولى مكرراً» إلى قرار 107/2021 تعفى من المادة الأولى منه الشركات التى تزاول نشاط صناديق الاستثمار (ومنها صناديق المؤشرات المتداولة) أو التوريق أو التصكيك؛ (2) النشر والسريان. إجمالى النص 1192 حرفاً.
-- السريان: المادة 2 تجعل العمل به من اليوم التالى لنشره بالوقائع المصرية؛ وعدد الوقائع مؤرخ 4/1/2023 فتُحسب effective_from = 2023-01-05 (استنتاج من تاريخ العدد المطبوع على الصفحتين).
-- تنبيهات: (1) قرار 107/2021 نفسه (الذى يعدّله هذا القرار) غير موجود على المنصة بحسب فحص القاعدة المحلية؛ لذلك يُضاف هذا القرار مستقلاً بلا amended_by، ويُربط لاحقاً عند رفع 107/2021.
--   (2) المواد بلا embedding؛ تُضاف عند إعادة التضمين. (3) لم يُوسم governance_scope (الافتراضى false). (4) الرابط الرسمى غير معلوم.
-- الطريقة: إضافة فقط، قابلة لإعادة التشغيل (ON CONFLICT DO NOTHING)، ولا تمس أى قانون آخر.
-- ============================================================================

CREATE TEMP TABLE m220_art (
  article_no int NOT NULL, loc text, body text NOT NULL, body_md5 text NOT NULL
) ON COMMIT DROP;

INSERT INTO m220_art VALUES
(0,$m220$الديباجة$m220$,$m220$الهيئة العامة للرقابة المالية
قرار مجلس إدارة الهيئة رقم (196) لسنة 2022
بتاريخ 2022/12/28
بتعديل قرار مجلس إدارة الهيئة رقم 107 لسنة 2021
بشأن ضوابط إفصاح الشركات العاملة
فى مجال الأنشطة المالية غير المصرفية
عن الممارسات البيئية والمجتمعية والحوكمة المتعلقة بالاستدامة
والآثار المالية للتغيرات المناخية
مجلس إدارة الهيئة العامة للرقابة المالية ؛
بعد الاطلاع على القانون رقم (10) لسنة 2009 بتنظيم الرقابة على الأسواق والأدوات المالية غير المصرفية ؛
وعلى قرار مجلس إدارة الهيئة رقم (107) لسنة 2021 بشأن ضوابط إفصاح الشركات العاملة فى مجال الأنشطة المالية غير المصرفية عن الممارسات البيئية والمجتمعية والحوكمة المتعلقة بالاستدامة والآثار المالية للتغيرات المناخية ؛
وبعد موافقة مجلس إدارة الهيئة بجلسته المنعقدة بتاريخ 2022/12/28 ؛
قرر :$m220$,'18f5e2585bf22708623727960baad5f4'),
(1,$m220$المادة الأولى$m220$,$m220$يضاف إلى قرار مجلس إدارة الهيئة رقم (107) لسنة 2021 المشار إليه ، مادة جديدة برقم (الأولى مكرراً) ، نصها الآتى :
(المادة الأولى مكرراً) :
يعفى من تطبيق أحكام المادة الأولى من هذا القرار، الشركات التى تزاول أيًا من الأنشطة الآتية :
1 – نشاط صناديق الاستثمار (بما فى ذلك صناديق المؤشرات المتداولة) .
2 – نشاط التوريق .
3 – نشاط التصكيك .$m220$,'a5b6f1fab5fc242ea76704299b9cc611'),
(2,$m220$المادة الثانية$m220$,$m220$ينشر هذا القرار في الوقائع المصرية وعلى الموقع الإلكترونى للهيئة ، ويعمل به من اليوم التالي لتاريخ نشره بالوقائع المصرية .$m220$,'3654dd00fe7dd5734cff5c7533b005b7');

DO $m220$
DECLARE
  v_law uuid;
  v_title text;
  v_new_law boolean := false;
  v_ins_art int;
  v_ins_ver int;
  v_cnt int;
  v_nover int;
BEGIN
  IF (SELECT count(*) FROM m220_art WHERE md5(body) <> body_md5) <> 0 THEN
    RAISE EXCEPTION '[220] تلف فى نص أحد المواد داخل الملف';
  END IF;
  IF (SELECT count(*) FROM m220_art) <> 3 OR (SELECT sum(char_length(body)) FROM m220_art) <> 1192 THEN
    RAISE EXCEPTION '[220] عدد المواد أو طول النص داخل الملف غير مطابق';
  END IF;

  SELECT id, title INTO v_law, v_title FROM laws WHERE country_code='EG' AND law_no=196 AND law_year=2022;
  IF v_law IS NOT NULL AND v_title NOT LIKE '%107%' THEN
    RAISE EXCEPTION '[220] يوجد قانون/قرار آخر برقم 196 لسنة 2022 (%): لا يُدمج هذا القرار فيه', v_title;
  END IF;
  IF v_law IS NULL THEN
    INSERT INTO laws (law_no, law_year, title, short_title, category, status, official_url, enacted_at, country_code, kind, governance_scope)
    VALUES (196, 2022, $t220$قرار مجلس إدارة الهيئة العامة للرقابة المالية رقم 196 لسنة 2022 بتعديل قرار مجلس إدارة الهيئة رقم 107 لسنة 2021 بشأن ضوابط إفصاح الشركات العاملة فى مجال الأنشطة المالية غير المصرفية عن الممارسات البيئية والمجتمعية والحوكمة المتعلقة بالاستدامة والآثار المالية للتغيرات المناخية$t220$, $t220$قرار الهيئة 196/2022 (إعفاء صناديق الاستثمار والتوريق والتصكيك من إفصاح الاستدامة)$t220$, 'non_bank_finance', 'in_force', NULL, DATE '2022-12-28', 'EG', 'board_decision', false)
    RETURNING id INTO v_law;
    v_new_law := true;
  END IF;

  INSERT INTO articles (law_id, article_no, article_suffix_order, hierarchical_location, body)
  SELECT v_law, article_no, 0, loc, body FROM m220_art
  ON CONFLICT (law_id, article_no, article_suffix_order) DO NOTHING;
  GET DIAGNOSTICS v_ins_art = ROW_COUNT;

  INSERT INTO article_versions (article_id, version_no, body, effective_from, status)
  SELECT a.id, 1, a.body, DATE '2023-01-05', 'active'
    FROM articles a JOIN m220_art m ON m.article_no = a.article_no
   WHERE a.law_id = v_law AND a.article_suffix_order = 0
     AND NOT EXISTS (SELECT 1 FROM article_versions v WHERE v.article_id = a.id)
  ON CONFLICT (article_id, version_no) DO NOTHING;
  GET DIAGNOSTICS v_ins_ver = ROW_COUNT;

  SELECT count(*) INTO v_cnt FROM articles a JOIN m220_art m ON m.article_no=a.article_no
   WHERE a.law_id=v_law AND a.article_suffix_order=0;
  IF v_cnt <> 3 THEN
    RAISE EXCEPTION '[220] عدد مواد القرار % بدل 3', v_cnt;
  END IF;
  SELECT count(*) INTO v_nover FROM articles a
   WHERE a.law_id=v_law AND NOT EXISTS (SELECT 1 FROM article_versions v WHERE v.article_id=a.id);
  IF v_nover <> 0 THEN
    RAISE EXCEPTION '[220] % مادة بلا نسخة', v_nover;
  END IF;
  RAISE NOTICE '[220] قرار 196/2022: جديد=%، مواد مضافة=%، نسخ مضافة=%', v_new_law, v_ins_art, v_ins_ver;
END
$m220$;
