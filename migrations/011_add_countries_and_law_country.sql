-- 011_add_countries_and_law_country.sql
-- توسعة معمارية: دعم تعدد الدول فى المنصة (مصر كبداية، ثم السعودية/الإمارات/
-- قطر/البحرين) تمهيداً لإعادة هيكلة القائمة الجانبية إلى "القائمة الرئيسية"
-- المقسّمة بالدولة المستهدفة.
--
-- قرارات معمارية مقصودة (لا اختصارات):
-- (1) جدول countries منفصل (لا CHECK enum ثابت) — نفس السبب الموثّق فى تعليق
--     008 حول laws.kind: أى دولة جديدة تُضاف لاحقاً تصبح INSERT عادى، لا
--     ALTER CONSTRAINT قد يتعارض مع بيانات موجودة أو ينكسر عند إعادة التشغيل.
-- (2) إصلاح جذرى لقيد uq_laws_no_year: كان UNIQUE(law_no, law_year) فقط —
--     هذا يتعطّل حتماً بمجرد إدخال أول قانون سعودى/إماراتى يحمل نفس الرقم
--     والسنة لقانون مصرى موجود (احتمال وارد وليس نظرياً). الإصلاح: يصبح القيد
--     UNIQUE(country_code, law_no, law_year) — لا يمنع فقط التكرار الحقيقى.
-- (3) country_code NOT NULL DEFAULT 'EG' على الجدولين (laws وguidance_documents)
--     — يُصنَّف كل المحتوى الحالى (127+ قانون/قرار، كلها من الهيئة المصرية)
--     تلقائياً كمصرى دون أى INSERT/UPDATE يدوى إضافى، ودون كسر أى صف موجود.
-- قابل لإعادة التشغيل بأمان (idempotent): IF NOT EXISTS فى كل مكان، وفحص
-- pg_constraint قبل إضافة القيد الجديد لتفادى خطأ "already exists" عند إعادة
-- تشغيل هذه الدفعة (نفس نمط 002_embeddings_dimension.sql فى المشروع).

BEGIN;

-- ===== الجزء 1: جدول countries =====
CREATE TABLE IF NOT EXISTS countries (
  code text PRIMARY KEY,             -- ISO 3166-1 alpha-2 بأحرف كبيرة: EG, SA, AE, QA, BH...
  name_ar text NOT NULL,
  name_en text,
  display_order integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO countries (code, name_ar, name_en, display_order) VALUES
  ('EG', 'مصر', 'Egypt', 1),
  ('SA', 'السعودية', 'Saudi Arabia', 2),
  ('AE', 'الإمارات', 'United Arab Emirates', 3),
  ('QA', 'قطر', 'Qatar', 4),
  ('BH', 'البحرين', 'Bahrain', 5)
ON CONFLICT (code) DO NOTHING;

-- ===== الجزء 2: laws.country_code =====
ALTER TABLE laws ADD COLUMN IF NOT EXISTS country_code text NOT NULL DEFAULT 'EG'
  REFERENCES countries(code);

-- إصلاح جذرى للقيد الفريد (راجع الشرح فى رأس الملف، بند 2)
ALTER TABLE laws DROP CONSTRAINT IF EXISTS uq_laws_no_year;
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'uq_laws_country_no_year'
  ) THEN
    ALTER TABLE laws ADD CONSTRAINT uq_laws_country_no_year
      UNIQUE (country_code, law_no, law_year);
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_laws_country ON laws(country_code);

-- ===== الجزء 3: guidance_documents.country_code (اتساق معمارى — لا يُستخدم بعد
-- فى شجرة القائمة الجانبية فى هذه الدفعة، لكن يمنع نصف تحوّل (half-migration)
-- يترك جدول محتوى كامل بلا تصنيف دولة بينما جدول laws أصبح مصنّفاً) =====
ALTER TABLE guidance_documents ADD COLUMN IF NOT EXISTS country_code text NOT NULL DEFAULT 'EG'
  REFERENCES countries(code);
CREATE INDEX IF NOT EXISTS idx_guidance_documents_country ON guidance_documents(country_code);

COMMIT;
