-- 269: الملف الأصلى (Word) للترجمة بنفس تنسيق الأصل
--
-- حين يختار المستخدم «احتفظ بتنسيق ملف Word» يُحفظ ملف docx الأصلى هنا مُشفَّراً (AES-256-GCM) مع مهمة الترجمة نفسها،
-- لتُكتب الترجمة داخله عند التنزيل (جداول وترقيم وأنماط). عمره عمر المهمة: يُحذف بحذفها (CASCADE) أو بانتهاء صلاحيتها
-- (48 ساعة من الإنشاء / 24 ساعة من الاكتمال) أو بزر «احذف الآن». لا يُحفظ ملف إلا بطلب صريح من المستخدم.
-- idempotent: يُعاد تشغيلها مع كل إقلاع بلا أثر.

BEGIN;

CREATE TABLE IF NOT EXISTS legal_translation_sources (
  translation_id UUID PRIMARY KEY REFERENCES legal_translations(id) ON DELETE CASCADE,
  payload        TEXT NOT NULL,
  bytes          INT NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

DO $verify$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'legal_translation_sources') THEN
    RAISE WARNING '269: جدول legal_translation_sources غير موجود بعد التنفيذ — تحقّق يدوياً';
  END IF;
END;
$verify$;

COMMIT;
