-- 203: أساس ميزة تنزيل الإجابات والتقارير (PDF / Word)
--
-- المبدأ: كل مستند يُنزَّل يُبنى على الخادم من سجل محفوظ فيه ومملوك للمستخدم،
-- لا من نص يرسله المتصفح — فلا يستطيع أحد تزوير مستند يبدو صادراً عن المنصة.
-- لذلك يلزم حفظ ما كان يُعاد للعميل ولا يُحفظ:
--   1) answers.structured: الإجابة المنظَّمة كاملة (الأحكام وسندها ووسم نص/تفسير
--      والتحذيرات) كما أُرسلت للعميل. صفوف ما قبل هذه الهجرة تبقى NULL ويُنزَّل
--      لها نص الإجابة المحفوظ مع الاستشهادات (مسار احتياطى فى البناء).
--   2) governance_assessments: حكم الحوكمة والالتزام. يحوى نص طلب العميل ونتيجته
--      (قد تردد وقائعه) فكلاهما مُشفَّر على مستوى التطبيق (AES-256-GCM) بنفس
--      آلية questions.question، والربط بالمستخدم ON DELETE CASCADE (حذف الحساب
--      يحذف تقييماته) وتفصله مهمة الاحتفاظ الدورية بعد نافذة الاحتفاظ كما فى الأسئلة.
--   3) contracts.report_approved_*: اعتماد المراجعة البشرية لتقرير العقد قبل
--      تصديره للعميل (التقرير الآلى مسودة عمل إلى أن يعتمده محامٍ/مدير).
--
-- idempotent: يُعاد تشغيلها مع كل إقلاع بلا أثر.

BEGIN;

ALTER TABLE answers ADD COLUMN IF NOT EXISTS structured jsonb;

COMMENT ON COLUMN answers.structured IS
  'الإجابة المنظَّمة (StructuredAnswer + تحذيرات المنصة) كما أُرسلت للعميل — مصدر بناء مستند التنزيل. NULL للإجابات القديمة وللمسار النصى.';

CREATE TABLE IF NOT EXISTS governance_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  -- مُشفَّران بصيغة enc:v1: (راجع src/common/crypto/field-encryption.ts)
  request_text TEXT NOT NULL,
  result TEXT NOT NULL,
  -- الحكم الرسمى بلا تشفير (أربع قيم ثابتة غير شخصية) لأغراض الإحصاء والتدقيق
  verdict TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_governance_assessments_user
  ON governance_assessments (user_id, created_at DESC);

ALTER TABLE contracts ADD COLUMN IF NOT EXISTS report_approved_by UUID REFERENCES users(id) ON DELETE SET NULL;
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS report_approved_at TIMESTAMPTZ;
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS report_approval_note TEXT;

DO $verify$
DECLARE
  v_ok boolean;
BEGIN
  SELECT
    EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'answers' AND column_name = 'structured')
    AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'governance_assessments')
    AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'contracts' AND column_name = 'report_approved_at')
  INTO v_ok;
  IF NOT v_ok THEN
    RAISE WARNING '203: بنية التصدير غير مكتملة بعد التنفيذ — تحقّق يدوياً';
  ELSE
    RAISE NOTICE '203: بنية التصدير موجودة كما هو متوقَّع';
  END IF;
END;
$verify$;

COMMIT;
