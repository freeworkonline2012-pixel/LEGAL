-- ============================================================================
-- 201 — laws.status = 'repealed' للقرارات التي نصت قرارات معاد رفعها (الهجرات 142
--       و148 و158 و161 و166 و175 و177 و178) صراحةً على إلغائها.
-- ----------------------------------------------------------------------------
-- المشكلة: هذه القرارات الثمانية ما زالت (إن كانت موجودة فى laws) بحالة in_force، فقد
-- تستشهد بها المنصة كأنها سارية وقد ألغاها قرار لاحق بنص صريح فى مادة مخزَّنة.
--
-- المبدأ: لا تغيير بالتخمين. لكل إلغاء يتحقق الملف أولاً من أن المادة الملغِية موجودة
-- فعلاً فى القاعدة وبنصها "يلغى قرار ... رقم N لسنة Y" (عبر تعبير نمطى)، ثم من أن
-- المستهدَف صف واحد فقط غير قانون ولا لائحة. غير ذلك: تخطٍّ بتنبيه (لا فشل)، فلا تُمس
-- صفوف غامضة ولا مفقودة. التحديث يمس عمود status وحده، ولا يمس أى نص مادة ولا تاريخ.
--
--   المستهدَف          الملغِى (المادة)        يوم العمل بالإلغاء (مرجع، لا يُخزَّن)
--   53/2018            177/2024 (6)            2024-08-30
--   23/2019            70/2026  (21)           2026-05-07
--   181/2019           59/2021  (1)            2021-04-04
--   122/2015           199/2025 (7)            2025-09-26
--   193/2018           54/2026  (27)           2026-04-21
--   345/2007           302/2025 (6)            2025-12-31
--   46/2014            304/2025 (2)            2025-12-31
--   902/2016           319/2025 (11)           2026-02-06
--
-- ما لم يُعالَج عمداً (يحتاج مصدراً أو قراراً قانونياً):
--   * 74/2019: ورد فى هامش 53/2018 دون تحديد القرار الملغِى؛ لا دليل مخزَّن عليه.
--   * 90/2025: يُلغى جزئياً بالمادة 2 من 229/2025 "فيما يخص الشركات المخاطبة" عند نهاية
--     مدة توفيق الأوضاع (2026/7/10 قابلة للمد من المجلس)؛ إلغاء جزئى معلَّق على مد المهلة.
--   * 82/2020 (وقف منح التراخيص): لا نص مخزَّن يبين متى انتهى الوقف.
--   * 48/2019: لا ينص 145/2021 المخزَّن على إلغائه.
--
-- ملاحظة: الحالة repealed تُظهر فى جواب المنصة الوسم "ملغى" على الاستشهاد (النص يبقى للاستشهاد
-- به فى الوقائع السابقة على الإلغاء)، ولا تحذف شيئاً.
--
-- قابلية إعادة التشغيل: لا تغيير إذا كانت الحالة repealed بالفعل. ختام الملف يفشل التشغيل إذا
-- بقى هدف مؤكد الإلغاء بحالة غير repealed.
-- ============================================================================

DO $m201$
DECLARE
  r RECORD;
  v_rep_id uuid;
  v_t_id uuid;
  v_n int;
  v_ok int := 0;
  v_changed int := 0;
  v_skip int := 0;
  v_targets uuid[] := ARRAY[]::uuid[];
BEGIN
  FOR r IN
    SELECT * FROM (VALUES
      (53,  2018, 177, 2024, 6),
      (23,  2019,  70, 2026, 21),
      (181, 2019,  59, 2021, 1),
      (122, 2015, 199, 2025, 7),
      (193, 2018,  54, 2026, 27),
      (345, 2007, 302, 2025, 6),
      (46,  2014, 304, 2025, 2),
      (902, 2016, 319, 2025, 11)
    ) AS t(t_no, t_year, rep_no, rep_year, rep_art)
  LOOP
    SELECT count(*) INTO v_n FROM laws
      WHERE country_code = 'EG' AND law_no = r.rep_no AND law_year = r.rep_year AND kind = 'board_decision';
    IF v_n <> 1 THEN
      RAISE WARNING '[201] القرار الملغِى %/% غير موجود أو غير فريد (%) — تخطّى %/%', r.rep_no, r.rep_year, v_n, r.t_no, r.t_year;
      v_skip := v_skip + 1;
      CONTINUE;
    END IF;
    SELECT id INTO v_rep_id FROM laws
      WHERE country_code = 'EG' AND law_no = r.rep_no AND law_year = r.rep_year AND kind = 'board_decision';

    IF NOT EXISTS (
      SELECT 1 FROM articles a
      WHERE a.law_id = v_rep_id AND a.article_no = r.rep_art
        AND a.body ~ ('يلغى قرار[^.،]{0,80}رقم \(?' || r.t_no || '\)? لسنة ' || r.t_year)
    ) THEN
      RAISE WARNING '[201] مادة الإلغاء % من %/% غير موجودة بنصها المتوقع — تخطّى %/%', r.rep_art, r.rep_no, r.rep_year, r.t_no, r.t_year;
      v_skip := v_skip + 1;
      CONTINUE;
    END IF;

    SELECT count(*) INTO v_n FROM laws
      WHERE country_code = 'EG' AND law_no = r.t_no AND law_year = r.t_year
        AND kind NOT IN ('law', 'regulation') AND id <> v_rep_id;
    IF v_n = 0 THEN
      RAISE NOTICE '[201] القرار %/% غير موجود فى laws — لا شىء لتحديثه', r.t_no, r.t_year;
      v_skip := v_skip + 1;
      CONTINUE;
    ELSIF v_n > 1 THEN
      RAISE WARNING '[201] % صفوف باسم %/% — غامض، تخطّى', v_n, r.t_no, r.t_year;
      v_skip := v_skip + 1;
      CONTINUE;
    END IF;

    SELECT id INTO v_t_id FROM laws
      WHERE country_code = 'EG' AND law_no = r.t_no AND law_year = r.t_year
        AND kind NOT IN ('law', 'regulation') AND id <> v_rep_id;
    v_targets := v_targets || v_t_id;
    v_ok := v_ok + 1;

    UPDATE laws SET status = 'repealed' WHERE id = v_t_id AND status <> 'repealed';
    GET DIAGNOSTICS v_n = ROW_COUNT;
    v_changed := v_changed + v_n;
    IF v_n = 1 THEN
      RAISE NOTICE '[201] %/% → repealed (بالمادة % من %/%)', r.t_no, r.t_year, r.rep_art, r.rep_no, r.rep_year;
    END IF;
  END LOOP;

  -- ختام: كل هدف أُكِّد إلغاؤه يجب أن يكون repealed
  SELECT count(*) INTO v_n FROM laws WHERE id = ANY(v_targets) AND status <> 'repealed';
  IF v_n <> 0 THEN
    RAISE EXCEPTION '[201] % هدفاً مؤكَّد الإلغاء ما زال بغير حالة repealed', v_n;
  END IF;
  RAISE NOTICE '[201] مؤكَّد الإلغاء: %، غُيِّر فى هذا التشغيل: %، متخطّى: %', v_ok, v_changed, v_skip;
END
$m201$;
