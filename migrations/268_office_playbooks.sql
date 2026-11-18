-- 268: Playbook لكل مكتب (حساب)
--
-- إعداد كل مستخدم/مكتب لقواعد المكتب: تعطيل قواعد افتراضية، تغيير درجاتها، وقواعد خاصة بعبارات نصية (لا تعبيرات نمطية).
-- الإعداد بيانات ممارسة لا بيانات عملاء، فهو JSONB غير مُشفَّر. يُتحقق منه فى الخادم قبل الحفظ (office-playbook.ts)،
-- ويُقرأ وقت التدقيق بتساهل (ما أُزيل من القواعد الافتراضية يُتجاهل) فلا يتعطل التدقيق بسبب إعداد قديم.
-- version يزيد مع كل حفظ ويُسجَّل مع نتيجة التدقيق لإعادة بناء ما طُبّق على كل عقد.
-- idempotent: يُعاد تشغيله مع كل إقلاع بلا أثر.

BEGIN;

CREATE TABLE IF NOT EXISTS office_playbooks (
  user_id    UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  version    INT NOT NULL DEFAULT 1,
  config     JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

DO $verify$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'office_playbooks') THEN
    RAISE WARNING '268: جدول office_playbooks غير موجود بعد التنفيذ — تحقّق يدوياً';
  END IF;
END;
$verify$;

COMMIT;
