/**
 * تنظيف شرح تقييم البند قبل عرضه للمستخدم (2026-10-18).
 * النموذج يُشير أحياناً إلى المرشحين بأرقامهم الداخلية ("المرشحان 1 و2 يخصان
 * ...") وهو تفصيل داخلى بلا معنى للمستخدم ولا يظهر له ترقيم المرشحين أصلاً.
 * نحذف الجمل التى تعتمد على هذا الترقيم بدل ترك إشارات مبهمة، مع إبقاء
 * بقية الشرح كما هو. إن لم يبقَ شيء يُعاد النص الاحتياطى.
 */
const CANDIDATE_REF = /(?:ال)?مرش(?:ح|حان|حون|حين|حو)\s*(?:رقم\s*)?\d+/;

export function stripInternalCandidateRefs(reasoning: string, fallback: string): string {
  const text = (reasoning ?? '').trim();
  if (!text) {
    return fallback;
  }
  // تقسيم على نهايات الجمل العربية/اللاتينية مع إبقاء الفاصل
  const sentences = text.split(/(?<=[.؟!؛])\s+/);
  const kept = sentences.filter((s) => !CANDIDATE_REF.test(s));
  const cleaned = kept.join(' ').trim();
  return cleaned || fallback;
}
