-- 266: تشغيل الترجمة فى الخلفية (بند التشغيل رقم 4)
--
-- background_run = true يعنى أن الخادم نفسه يكمل خطوات الترجمة دون أن يبقى المتصفح مفتوحاً، وأن المهمة تُستأنف
-- من آخر دفعة محفوظة إن أُعيد تشغيل الخادم (TranslationService.onApplicationBootstrap). يُصفَّر عند الاكتمال أو توقف
-- المشغِّل بإخفاق، فلا تُعاد محاولة مهمة معطوبة مع كل إقلاع. لا يمس بيانات موجودة: الافتراضى false (السلوك القديم: العميل يقود الخطوات).
-- idempotent: يُعاد تشغيلها مع كل إقلاع بلا أثر.

BEGIN;

ALTER TABLE legal_translations
  ADD COLUMN IF NOT EXISTS background_run BOOLEAN NOT NULL DEFAULT false;

-- فهرس جزئى صغير لاستعلام الاستئناف عند الإقلاع (الصفوف العاملة فى الخلفية فقط)
CREATE INDEX IF NOT EXISTS idx_legal_translations_background
  ON legal_translations (expires_at)
  WHERE background_run = true AND status <> 'completed';

DO $verify$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'legal_translations' AND column_name = 'background_run'
  ) THEN
    RAISE WARNING '266: عمود background_run غير موجود بعد التنفيذ — تحقّق يدوياً';
  END IF;
END;
$verify$;

COMMIT;
