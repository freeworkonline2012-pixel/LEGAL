-- 262: طلب مراجعة العقد — موافقة العميل على النسخة الأولية ثم السداد، قبل تسليم النسخة النهائية (Word/PDF).
--
-- التدفق: رفع Word ← نسخة أولية PDF (علامة مائية) ← موافقة العميل ← سداد ← تأكيد السداد من المالك (admin)
-- ← بعد اعتماد المراجعة البشرية (203) ينزّل العميل العقد المراجَع Word أو PDF. المالك/admin بلا مقابل دائماً.
--
-- أعمدة على contracts مباشرة (علاقة 1:1) بلا جدول جديد. لا تخزَّن بيانات دفع حساسة: «مرجع السداد» نص قصير
-- يكتبه العميل (رقم عملية/تحويل) ليطابقه المالك. idempotent.

BEGIN;

ALTER TABLE contracts ADD COLUMN IF NOT EXISTS client_approved_at timestamptz;
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS service_fee_minor integer;
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS service_fee_currency text;
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS payment_status text NOT NULL DEFAULT 'unpaid';
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS payment_reference text;
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS payment_submitted_at timestamptz;
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS paid_at timestamptz;
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS paid_confirmed_by uuid;

COMMENT ON COLUMN contracts.payment_status IS 'unpaid | submitted (العميل أعلن السداد) | paid (أكّده المالك)';
COMMENT ON COLUMN contracts.service_fee_minor IS 'قيمة الخدمة بأصغر وحدة (قرش) وقت موافقة العميل — من CONTRACT_REVIEW_FEE_EGP';

CREATE INDEX IF NOT EXISTS idx_contracts_payment_submitted ON contracts (payment_submitted_at) WHERE payment_status = 'submitted';

DO $verify$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'contracts' AND column_name = 'paid_at') THEN
    RAISE WARNING '262: عمود contracts.paid_at غير موجود بعد التنفيذ — تحقّق يدوياً';
  ELSE
    RAISE NOTICE '262: أعمدة طلب مراجعة العقد موجودة كما هو متوقَّع';
  END IF;
END;
$verify$;

COMMIT;
