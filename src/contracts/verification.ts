import { quoteInText } from './clause-facts';

/**
 * نتيجة المدقق المستقل (الطبقة 4): مدقق ثانٍ بتعليمات معاكسة يبحث عن سبب يجعل الملاحظة خاطئة. لا تُعرض الملاحظة «مؤكدة» إلا إن اجتازته؛
 * وإلا تُوسَم «غير مؤكدة — تحتاج مراجعة بشرية». لا تُحذف ولا تُخفَّض آلياً (الأمان أولاً: ملاحظة صحيحة تضيع أخطر من ملاحظة زائدة موسومة).
 * والاعتراض لا يُعتد به إلا باقتباس حرفى يتحقق منه الكود فى نص البند أو نص المادة المعروضة.
 */
export type VerificationStatus = 'confirmed' | 'unconfirmed';

export interface Verification {
  status: VerificationStatus;
  /** أساس الحالة: confirmed | refuted (اعتراض مسنَد باقتباس) | uncertain (شك أو اعتراض بلا اقتباس موثَّق) */
  basis: 'confirmed' | 'refuted' | 'uncertain';
  reason: string;
  quote: string | null;
  quoteSource: 'clause' | 'article' | null;
  verifiedAt: string;
}

function str(v: unknown, max: number): string | null {
  if (typeof v !== 'string') return null;
  const t = v.replace(/\s+/g, ' ').trim();
  if (t.length < 3) return null;
  return t.length > max ? `${t.slice(0, max).trim()}…` : t;
}

const NO_QUOTE_NOTE = 'اعترض المدقق المستقل دون اقتباس موثَّق من النص، فلا يُعتد باعتراضه؛ ';

/**
 * يحوّل رد المدقق الخام إلى نتيجة موثَّقة، أو null إن كان الرد غير صالح (فلا تُوسَم الملاحظة بشىء ويُسجَّل العطل).
 * @param clauseText نص البند (أو نصوص البنود المستشهَد بها معاً فى ملاحظة العقد ككل)
 * @param articleTexts نصوص المواد المعروضة للمدقق (فارغة فى ملاحظات العقد ككل)
 */
export function validateVerdict(raw: unknown, clauseText: string, articleTexts: string[], now = new Date()): Verification | null {
  const o = raw && typeof raw === 'object' && !Array.isArray(raw) ? (raw as Record<string, unknown>) : null;
  if (!o) return null;
  const verdict = o.verdict;
  if (verdict !== 'confirmed' && verdict !== 'refuted' && verdict !== 'uncertain') return null;
  const reason = str(o.reason, 500);
  if (!reason) return null;
  const verifiedAt = now.toISOString();
  if (verdict === 'confirmed') {
    return { status: 'confirmed', basis: 'confirmed', reason, quote: null, quoteSource: null, verifiedAt };
  }
  if (verdict === 'refuted') {
    const cq = typeof o.counter_quote === 'string' ? o.counter_quote : '';
    if (cq && quoteInText(cq, clauseText)) {
      return { status: 'unconfirmed', basis: 'refuted', reason, quote: cq.trim(), quoteSource: 'clause', verifiedAt };
    }
    const aq = typeof o.article_quote === 'string' ? o.article_quote : '';
    if (aq && articleTexts.some((t) => quoteInText(aq, t))) {
      return { status: 'unconfirmed', basis: 'refuted', reason, quote: aq.trim(), quoteSource: 'article', verifiedAt };
    }
    return { status: 'unconfirmed', basis: 'uncertain', reason: `${NO_QUOTE_NOTE}${reason}`, quote: null, quoteSource: null, verifiedAt };
  }
  return { status: 'unconfirmed', basis: 'uncertain', reason, quote: null, quoteSource: null, verifiedAt };
}

/** البنود التى يستحق تقييمها الآلى تحققاً مستقلاً: المراجعة الآلية بالنموذج (لا القواعد الحتمية) وبمخاطرة غير منخفضة. */
export function needsVerification(c: {
  assessmentStatus: string | null;
  riskLevel: string | null;
  matchedArticles: unknown[] | null;
  ruleFindings: unknown[] | null;
}): boolean {
  if (c.assessmentStatus !== 'يحتاج مراجعة') return false;
  if (c.ruleFindings && c.ruleFindings.length > 0) return false;
  if (!c.matchedArticles || c.matchedArticles.length === 0) return false;
  return c.riskLevel === 'حرج' || c.riskLevel === 'عالٍ' || c.riskLevel === 'متوسط';
}

const RISK_ORDER: Record<string, number> = { حرج: 0, عالٍ: 1, متوسط: 2 };
export const MAX_VERIFIED_CLAUSES = 12;

export function pickForVerification<T extends { clauseIndex: number; riskLevel: string | null }>(list: T[]): T[] {
  return [...list]
    .sort((a, b) => (RISK_ORDER[a.riskLevel ?? ''] ?? 9) - (RISK_ORDER[b.riskLevel ?? ''] ?? 9) || a.clauseIndex - b.clauseIndex)
    .slice(0, MAX_VERIFIED_CLAUSES);
}
