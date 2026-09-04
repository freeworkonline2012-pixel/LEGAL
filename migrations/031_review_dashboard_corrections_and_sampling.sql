-- 031_review_dashboard_corrections_and_sampling.sql
-- Phase 1 من "الخدمة الأولى — الرد الذكى على استفسارات الجمهور"
-- (راجع: تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى-2026-09-02.md فى مشروع
-- المستخدم، القسم 2.3 — "لوحة المراجعة البشرية أهم استثمار تقني فى هذه
-- الخدمة لأنها الآلية الوحيدة التى تُترجم خبرة رجل الأعمال القانونية
-- الشخصية إلى تحسين قابل للقياس فى النظام").
--
-- الوضع قبل هذه الهجرة: جدول reviews موجود لكنه يغطى فقط الإجابات
-- "المرفوضة تلقائياً" (answer.refused=true فى questions.service.ts) —
-- لا آلية لأخذ عيّنة عشوائية من الإجابات المُجاب عليها فعلاً (لضبط الدقة
-- الفعلية باستمرار)، ولا حقل لتسجيل تصحيح المحامى نفسه (النص/الاستشهاد
-- الصحيح) بشكل بنيوى قابل للاستخراج لاحقاً كحالة اختبار دائمة فى
-- Golden Test Set.
--
-- هذه الهجرة تضيف الحقول الثلاثة اللازمة فقط لسد هذه الفجوة، بلا أى جدول
-- جديد (توسيع reviews الموجود أبسط وأقل مخاطرة من جدول منفصل يحتاج ربطاً
-- إضافياً)، ولا تُعدَّل أى بيانات موجودة (كل الأعمدة الجديدة NULL-able أو
-- بقيمة افتراضية آمنة لا تُغيّر سلوك الصفوف الحالية).

DO $mig031$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'trigger_reason'
  ) THEN
    ALTER TABLE reviews
      ADD COLUMN trigger_reason TEXT NOT NULL DEFAULT 'auto_refused';

    ALTER TABLE reviews
      ADD CONSTRAINT chk_reviews_trigger_reason
      CHECK (trigger_reason IN ('auto_refused', 'random_sample'));
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'reviews' AND column_name = 'corrected_answer'
  ) THEN
    ALTER TABLE reviews ADD COLUMN corrected_answer TEXT NULL;
    ALTER TABLE reviews ADD COLUMN corrected_law_no INTEGER NULL;
    ALTER TABLE reviews ADD COLUMN corrected_law_year INTEGER NULL;
    ALTER TABLE reviews ADD COLUMN corrected_article_no INTEGER NULL;
    ALTER TABLE reviews
      ADD COLUMN promote_to_golden_set BOOLEAN NOT NULL DEFAULT false;
  END IF;
END
$mig031$;

-- فهرس يسرّع استعلام "عيّنة عشوائية من الأسئلة المُجاب عليها بلا مراجعة
-- موجودة بعد" (يُستخدَم فى ReviewsService.sampleAnswered) — بحث عن
-- answers.id غير الموجودة فى reviews.answer_id، بشرط answers.refused=false.
CREATE INDEX IF NOT EXISTS idx_answers_refused_false
  ON answers (id)
  WHERE refused = false;
