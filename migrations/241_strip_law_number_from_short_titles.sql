-- =====================================================================
-- Migration 241: إزالة «رقم/سنة» المكرر من العناوين المختصرة للقوانين
-- =====================================================================
-- الواجهة والتقارير تضيف رقم القانون وسنته بعد العنوان المختصر دائماً، فظهر الاسم مكرراً: «قانون التحكيم 27/1994 27/1994».
-- السبب أن عناوين مختصرة أُضيفت فى هجرات حديثة تحمل الرقم فى آخرها. هذه الهجرة تحذف اللاحقة «<رقم>/<سنة>» من نهاية short_title
-- فقط حين تطابق رقم القانون وسنته نفسيهما، وتُبقى العنوان كما هو إن كان ما يتبقى أقصر من 4 أحرف. لا تمس title ولا المواد ولا
-- التضمين. تغيير عرض فقط، وقابلة لإعادة التشغيل بأمان (لا تغيّر شيئاً إن لم يبقَ ما يُحذف).
-- =====================================================================

DO $$
DECLARE
  v_updated integer;
BEGIN
  UPDATE laws
     SET short_title = btrim(regexp_replace(short_title, '\s*' || law_no::text || '\s*/\s*' || law_year::text || '\s*$', ''))
   WHERE short_title IS NOT NULL
     AND short_title ~ ('\s' || law_no::text || '\s*/\s*' || law_year::text || '\s*$')
     AND length(btrim(regexp_replace(short_title, '\s*' || law_no::text || '\s*/\s*' || law_year::text || '\s*$', ''))) >= 4;
  GET DIAGNOSTICS v_updated = ROW_COUNT;
  RAISE NOTICE '[241] short_title cleaned for % law(s)', v_updated;

  -- فحص بعدى: لا يبقى عنوان مختصر ينتهى برقم قانونه وسنته
  IF EXISTS (
    SELECT 1 FROM laws
     WHERE short_title IS NOT NULL
       AND short_title ~ ('\s' || law_no::text || '\s*/\s*' || law_year::text || '\s*$')
       AND length(btrim(regexp_replace(short_title, '\s*' || law_no::text || '\s*/\s*' || law_year::text || '\s*$', ''))) >= 4
  ) THEN
    RAISE EXCEPTION '[241] some short_title values still end with their own law number';
  END IF;
END $$;
