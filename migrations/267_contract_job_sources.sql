-- 267: ملف العقد المؤقت المشفَّر لاستئناف التحليل فى الخلفية بعد إعادة تشغيل الخادم (بند التشغيل رقم 4)
--
-- قرار تصميم سابق: ملف العقد لا يُخزَّن. نتيجته أن إعادة تشغيل الخادم أثناء تحليل (قد يطول لدقائق) كانت تُفقد المهمة وتُعلنها فاشلة.
-- الحل الجذرى بلا تغيير فى سياسة الاحتفاظ العامة: يُحفظ الملف مشفَّراً (AES-256-GCM، enc:v1:) طوال مدة التحليل فقط،
-- ويُحذف فور انتهائه (نجاحاً أو فشلاً) أو بعد 24 ساعة كحد أقصى (تنظيف دورى) أو بحذف العقد (ON DELETE CASCADE).
--   attempts      عدد مرات تشغيل المهمة (الأولى + الاستئنافات) — سقف يمنع «عقد سام» من إسقاط الخادم فى حلقة.
--   claimed_until عقد إيجار (lease): من يستأنف يحجز المهمة؛ لا تُستأنف مهمة حجزها حى (نسخة أخرى أثناء نشر متداخل).
-- idempotent: يُعاد تشغيلها مع كل إقلاع بلا أثر.

BEGIN;

CREATE TABLE IF NOT EXISTS contract_job_sources (
  contract_id UUID PRIMARY KEY REFERENCES contracts(id) ON DELETE CASCADE,
  payload TEXT NOT NULL,
  attempts INTEGER NOT NULL DEFAULT 1,
  claimed_until TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_contract_job_sources_claim ON contract_job_sources (claimed_until);
CREATE INDEX IF NOT EXISTS idx_contract_job_sources_created ON contract_job_sources (created_at);

DO $verify$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'contract_job_sources') THEN
    RAISE WARNING '267: جدول contract_job_sources غير موجود بعد التنفيذ — تحقّق يدوياً';
  END IF;
END;
$verify$;

COMMIT;
