-- =====================================================================
-- Migration 252: إلغاء الباب الخامس من قانون التجارة 17/1999 (الإفلاس والصلح
--                الواقى منه، المواد 550-772) بموجب المادة 5 من إصدار القانون 11/2018
-- =====================================================================
--
-- السند: المادة (5) من مواد إصدار القانون رقم 11 لسنة 2018 بإصدار قانون تنظيم
--   إعادة الهيكلة والصلح الواقى والإفلاس، ونصها المخزَّن فى المنصة (الهجرة 251):
--   "يلغى الباب الخامس من قانون التجارة الصادر بالقانون رقم 17 لسنة 1999 ، كما
--    يلغى كل حكم يخالف أحكام القانون المرافق ."
--
-- المنفَّذ هنا: الشق الأول فقط (إلغاء الباب الخامس بكامله = 223 مادة، من 550 إلى 772).
-- غير المنفَّذ عمداً: الشق الثانى ("كل حكم يخالف") إلغاء ضمنى عام؛ تحديد المواد
--   المخالفة فى بقية 17/1999 وغيره يحتاج تحليلاً قانونياً مادة بمادة، ولا يُخمَّن آلياً.
--
-- نمط الإلغاء: نفس المعتمد فى الهجرة 110 وamend_common_206.py: تحديث نسخة المادة
--   الحالية (المفتوحة effective_to IS NULL) إلى status='repealed' مع effective_to
--   وamended_by_law_no/year وchange_note؛ لا حذف لأى صف، ولا تغيير لنص أى مادة؛ فتبقى
--   المواد وتاريخها (1999-10-01 حتى تاريخ الإلغاء) للاستشهاد التاريخى.
--
-- تاريخ الإلغاء (effective_to): يُقرأ من القاعدة نفسها = effective_from لنسخة مادة
--   الإصدار 5 المخزَّنة فى الهجرة 251 (لا رقم مكتوب هنا)، فيتطابق تلقائياً مع تاريخ
--   العمل بالقانون 11/2018 المخزَّن. ⚠️ ذلك التاريخ محسوب (ثلاثون يوماً بعد النشر
--   فى 19/2/2018) وليس منقولاً من الجريدة؛ إن تبيَّن بعد المطابقة أنه يختلف بيوم،
--   تُصحَّح التواريخ بهجرة صغيرة (11/2018 ثم 17/1999) دون مساس بالنصوص.
--
-- ضمانات (تفشل الهجرة وتتراجع كلها عند أى خرق، فلا تُمس بيانات بالتخمين):
--   1) قانون 17/1999 (kind=law) صف واحد، وقانون 11/2018 صف واحد بعنوان فيه "الإفلاس".
--   2) مادة الإصدار 5 موجودة بنصها المتوقع، ولها نسخة سارية بتاريخ نفاذ غير فارغ.
--   3) المواد المستهدفة: بالضبط 223 (550-772، suffix=0)، كلها موضعها "الباب الخامس..."،
--      ولا توجد مادة أخرى من 17/1999 موضعها الباب الخامس (لا مادة خارج النطاق).
--   4) لا مادة مستهدفة لها أكثر من نسخة مفتوحة (غموض لا يُحسم بالتخمين).
--   5) تاريخ بدء كل نسخة مستهدفة أسبق من تاريخ الإلغاء.
--   6) بعد التنفيذ: كل المواد الـ223 لها نسخة repealed، ولا مادة خارج النطاق
--      وُسمت بإلغاء 11/2018.
-- التنفيذ مكرَّر بأمان (idempotent): التشغيل الثانى لا يغير شيئاً (0 صف).
-- change_note السابقة (إن وُجدت) تُحفظ ويُلحَق بها نص الإلغاء.
-- لا تمس هذه الهجرة جدول laws (حالة 17/1999 نفسه تبقى سارية؛ بقية أبوابه نافذة).
-- =====================================================================

DO $m252$
DECLARE
  v_com   uuid;
  v_new   uuid;
  v_eff   date;
  v_n     int;
  v_upd   int;
  v_note  text := $n252$أُلغى الباب الخامس بأكمله (الإفلاس والصلح الواقى منه، المواد 550 إلى 772) من قانون التجارة بموجب المادة (5) من إصدار القانون رقم 11 لسنة 2018 بإصدار قانون تنظيم إعادة الهيكلة والصلح الواقى والإفلاس، اعتباراً من تاريخ العمل به. (انظر القانون 11/2018 فى المنصة.)$n252$;
BEGIN
  -- 1) القانونان
  SELECT count(*) INTO v_n FROM laws WHERE country_code='EG' AND law_no=17 AND law_year=1999 AND kind='law';
  IF v_n <> 1 THEN
    RAISE EXCEPTION '[252] قانون التجارة 17/1999 غير موجود بصف واحد (العدد=%)', v_n;
  END IF;
  SELECT id INTO v_com FROM laws WHERE country_code='EG' AND law_no=17 AND law_year=1999 AND kind='law';

  SELECT count(*) INTO v_n FROM laws WHERE country_code='EG' AND law_no=11 AND law_year=2018 AND kind='law' AND title LIKE '%الإفلاس%';
  IF v_n <> 1 THEN
    RAISE EXCEPTION '[252] القانون 11/2018 غير موجود بصف واحد (العدد=%) - يلزم تطبيق الهجرة 251 أولاً', v_n;
  END IF;
  SELECT id INTO v_new FROM laws WHERE country_code='EG' AND law_no=11 AND law_year=2018 AND kind='law' AND title LIKE '%الإفلاس%';

  -- 2) مادة الإصدار 5 ونص الإلغاء وتاريخ نفاذها
  SELECT count(*) INTO v_n FROM articles
   WHERE law_id=v_new AND article_no=5 AND article_suffix_order=-1
     AND body LIKE '%يلغى الباب الخامس من قانون التجارة الصادر بالقانون رقم 17 لسنة 1999%';
  IF v_n <> 1 THEN
    RAISE EXCEPTION '[252] مادة الإصدار 5 من 11/2018 غير موجودة بنصها المتوقع (العدد=%)', v_n;
  END IF;
  SELECT v.effective_from INTO v_eff
    FROM articles a JOIN article_versions v ON v.article_id = a.id
   WHERE a.law_id=v_new AND a.article_no=5 AND a.article_suffix_order=-1 AND v.status='active'
   ORDER BY v.version_no LIMIT 1;
  IF v_eff IS NULL THEN
    RAISE EXCEPTION '[252] لا نسخة سارية بتاريخ نفاذ لمادة الإصدار 5 من 11/2018';
  END IF;

  -- 3) المواد المستهدفة
  SELECT count(*) INTO v_n FROM articles
   WHERE law_id=v_com AND article_suffix_order=0 AND article_no BETWEEN 550 AND 772
     AND hierarchical_location LIKE 'الباب الخامس%';
  IF v_n <> 223 THEN
    RAISE EXCEPTION '[252] عدد مواد الباب الخامس (550-772) % بدل 223', v_n;
  END IF;
  SELECT count(*) INTO v_n FROM articles WHERE law_id=v_com AND hierarchical_location LIKE 'الباب الخامس%';
  IF v_n <> 223 THEN
    RAISE EXCEPTION '[252] عدد الصفوف الموضوعة تحت الباب الخامس فى 17/1999 % بدل 223 (مادة خارج النطاق)', v_n;
  END IF;

  -- 4) لا غموض فى النسخ المفتوحة
  SELECT count(*) INTO v_n FROM (
    SELECT a.id FROM articles a JOIN article_versions v ON v.article_id=a.id
     WHERE a.law_id=v_com AND a.article_suffix_order=0 AND a.article_no BETWEEN 550 AND 772
       AND v.effective_to IS NULL
     GROUP BY a.id HAVING count(*) > 1) x;
  IF v_n <> 0 THEN
    RAISE EXCEPTION '[252] % مادة لها أكثر من نسخة مفتوحة - لا تُحسم بالتخمين', v_n;
  END IF;

  -- 5) تاريخ البدء أسبق من تاريخ الإلغاء
  SELECT count(*) INTO v_n
    FROM articles a JOIN article_versions v ON v.article_id=a.id
   WHERE a.law_id=v_com AND a.article_suffix_order=0 AND a.article_no BETWEEN 550 AND 772
     AND v.effective_to IS NULL AND v.status <> 'repealed'
     AND (v.effective_from IS NULL OR v.effective_from >= v_eff);
  IF v_n <> 0 THEN
    RAISE EXCEPTION '[252] % نسخة تاريخ بدئها غير أسبق من تاريخ الإلغاء %', v_n, v_eff;
  END IF;

  -- التنفيذ
  UPDATE article_versions v SET
      status = 'repealed',
      effective_to = v_eff,
      amended_by_law_no = 11,
      amended_by_law_year = 2018,
      change_note = CASE WHEN v.change_note IS NULL OR v.change_note = '' THEN v_note
                         ELSE v.change_note || E'\n' || v_note END
    FROM articles a
   WHERE v.article_id = a.id
     AND a.law_id = v_com AND a.article_suffix_order = 0 AND a.article_no BETWEEN 550 AND 772
     AND a.hierarchical_location LIKE 'الباب الخامس%'
     AND v.effective_to IS NULL AND v.status <> 'repealed';
  GET DIAGNOSTICS v_upd = ROW_COUNT;

  -- 6) التحقق بعد التنفيذ
  SELECT count(*) INTO v_n FROM articles a
   WHERE a.law_id=v_com AND a.article_suffix_order=0 AND a.article_no BETWEEN 550 AND 772
     AND EXISTS (SELECT 1 FROM article_versions v WHERE v.article_id=a.id AND v.status='repealed');
  IF v_n <> 223 THEN
    RAISE EXCEPTION '[252] المواد التى صارت ملغاة % بدل 223', v_n;
  END IF;
  SELECT count(*) INTO v_n
    FROM articles a JOIN article_versions v ON v.article_id=a.id
   WHERE a.law_id=v_com AND v.amended_by_law_no=11 AND v.amended_by_law_year=2018
     AND NOT (a.article_suffix_order=0 AND a.article_no BETWEEN 550 AND 772);
  IF v_n <> 0 THEN
    RAISE EXCEPTION '[252] % نسخة خارج الباب الخامس وُسمت بإلغاء 11/2018', v_n;
  END IF;

  RAISE NOTICE '[252] إلغاء الباب الخامس من 17/1999 بالقانون 11/2018 (تاريخ الإلغاء %): نسخ مُحدَّثة=%', v_eff, v_upd;
END
$m252$;
