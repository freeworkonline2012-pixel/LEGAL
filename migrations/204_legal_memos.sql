-- 204: المذكرات والتقارير القانونية (مسودات مقيَّدة بالمصادر)
--
-- المبدأ: المذكرة لا تُولَّد بتعليمات جديدة للنموذج. تُبنى فوق محرك الإجابات المُتحقَّق منه (الاسترجاع
-- والتحقق الحرفى ووسم نص/تفسير): الأسانيد = الإجابة المنظَّمة المحفوظة فى answers (answer_id)،
-- والوقائع والمسألة والطلبات تُنقل كما كتبها المستخدم. لذلك يحفظ هذا الجدول وصف المذكرة فقط.
--   * title / facts / issue / requests مُشفَّرة على مستوى التطبيق (AES-256-GCM، صيغة enc:v1:)
--     لأنها قد تحوى وقائع وأسماء أطراف — نفس آلية questions.question وgovernance_assessments.
--   * user_id ON DELETE CASCADE (حذف الحساب يحذف مذكراته) وتفصله مهمة الاحتفاظ الدورية بعد النافذة.
--   * answer_id ON DELETE CASCADE: حذف السؤال/الإجابة (حق الحذف 151/2020) يحذف مذكرته المبنية عليها،
--     فلا تبقى مذكرة بلا أسانيدها.
-- idempotent: يُعاد تشغيلها مع كل إقلاع بلا أثر.

BEGIN;

CREATE TABLE IF NOT EXISTS legal_memos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  answer_id UUID NOT NULL REFERENCES answers(id) ON DELETE CASCADE,
  memo_type TEXT NOT NULL,
  party_role TEXT NOT NULL,
  title TEXT NOT NULL,
  issue TEXT NOT NULL,
  facts TEXT NOT NULL,
  requests TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT chk_legal_memos_type CHECK (memo_type IN ('opinion_memo', 'defense_memo', 'legal_report')),
  CONSTRAINT chk_legal_memos_party CHECK (party_role IN ('claimant', 'defendant', 'advisory'))
);

CREATE INDEX IF NOT EXISTS idx_legal_memos_user ON legal_memos (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_legal_memos_answer ON legal_memos (answer_id);

DO $verify$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'legal_memos') THEN
    RAISE WARNING '204: جدول legal_memos غير موجود بعد التنفيذ — تحقّق يدوياً';
  ELSE
    RAISE NOTICE '204: جدول legal_memos موجود كما هو متوقَّع';
  END IF;
END;
$verify$;

COMMIT;
