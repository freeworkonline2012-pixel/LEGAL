import { quoteInText } from './clause-facts';

/**
 * نتيجة المدقق المستقل (الطبقة 4): مدقق ثانٍ بتعليمات معاكسة يبحث عن سبب يجعل الملاحظة خاطئة. لا تُعرض الملاحظة «مؤكدة» إلا إن اجتازته؛
 * وإلا تُوسَم «غير مؤكدة — تحتاج مراجعة بشرية». لا تُحذف ولا تُخفَّض آلياً (الأمان أولاً: ملاحظة صحيحة تضيع أخطر من ملاحظة زائدة موسومة).
 * والاعتراض لا يُعتد به إلا باقتباس حرفى يتحقق منه الكود فى نص البند أو نص المادة المعروضة.
 */
export type VerificationStatus = 'confirmed' | 'unconfirmed';

export interface Verification {
  status: VerificationStatus;
  /** أساس الحالة: confirmed | refuted (اعتراض مسنَد باقتباس) | uncertain (شك أو اعتراض بلا اقتباس موثَّق) | reclassified (انظر reclassified) */
  basis: 'confirmed' | 'refuted' | 'uncertain' | 'reclassified';
  /**
   * 'deviation': دُحض وصف المادة بأنها آمرة (هى مكملة بمستند من نصها) لكن البند نفسه يخرج عن القاعدة بما يضر العميل (اقتباس حرفى من البند)؛
   * فتُعاد الملاحظة اختلالاً عن قاعدة مكملة (متوسط) بدل أن تسقط كلها «غير مؤكدة». لا يُعتمد إلا بالاقتباسين معاً.
   */
  reclassified?: 'deviation';
  /** سبب الدحض كما صنّفه المدقق (للتدقيق والقياس) */
  refutationKind?: 'not_mandatory' | 'clause_addresses' | 'not_applicable' | 'other';
  reason: string;
  quote: string | null;
  quoteSource: 'clause' | 'article' | null;
  verifiedAt: string;
}

/**
 * دحض موثَّق (الجولة 60): اعتراض المدقق المستقل مسنَد باقتباس حرفى تحقق منه الكود، وسببه محدد (ليس «other» الغامض):
 * المادة ليست آمرة، أو البند نفسه يعالج الموضوع، أو الملاحظة لا تنطبق. مثل هذه الملاحظة تُعرض فى ملحق مختصر «فُحصت واستُبعدت» لا مرشّحةً
 * (لا تُحذف: يبقى نصها وسبب استبعادها وقتباس الدحض ظاهرة للمراجع)، ولا ترفع المستوى ولا تجعله «مؤقتاً» على الغلاف.
 */
export const DISMISSIBLE_REFUTATION_KINDS: ReadonlySet<string> = new Set(['not_mandatory', 'clause_addresses', 'not_applicable']);

export function isDismissedVerification(v: { status?: string; basis?: string | null; refutationKind?: string | null; quote?: string | null } | null | undefined): boolean {
  return !!v && v.status === 'unconfirmed' && v.basis === 'refuted' && !!v.quote && !!v.refutationKind && DISMISSIBLE_REFUTATION_KINDS.has(v.refutationKind);
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
 * @param relatedTexts نصوص بنود ذات صلة عُرضت سياقاً (مثل حصص الشركاء لبند الأرباح) ويجوز الاقتباس منها فى الدحض فقط
 */
export function validateVerdict(raw: unknown, clauseText: string, articleTexts: string[], now = new Date(), relatedTexts: string[] = []): Verification | null {
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
    const kind: Verification['refutationKind'] =
      o.refutation_kind === 'not_mandatory' || o.refutation_kind === 'clause_addresses' || o.refutation_kind === 'not_applicable' ? o.refutation_kind : 'other';
    // دُحض وصف «آمرة» وحده؛ والبند ذاته يخرج عن الأصل ضد العميل: اقتباسان حرفيان (من البند ومن المادة) وإلا تبقى «غير مؤكدة» كما كانت
    const dq = typeof o.deviation_quote === 'string' ? o.deviation_quote : '';
    const aqd = typeof o.article_quote === 'string' ? o.article_quote : '';
    if (kind === 'not_mandatory' && o.deviates_against_client === true && dq && quoteInText(dq, clauseText) && aqd && articleTexts.some((t) => quoteInText(aqd, t))) {
      return {
        status: 'confirmed',
        basis: 'reclassified',
        reclassified: 'deviation',
        refutationKind: kind,
        reason: `المادة قاعدة مكملة لا آمرة فلا بطلان، لكن البند يخرج عن الأصل بما يضر العميل (اختلال عن قاعدة مكملة، متوسط). ${reason}`,
        quote: dq.trim(),
        quoteSource: 'clause',
        verifiedAt,
      };
    }
    const cq = typeof o.counter_quote === 'string' ? o.counter_quote : '';
    // الاقتباس من بند ذى صلة (حصص الشركاء) يصلح لدحض الملاحظة، أما الانحراف فلا يُثبت إلا من البند نفسه (انظر أعلاه)
    if (cq && (quoteInText(cq, clauseText) || relatedTexts.some((t) => quoteInText(cq, t)))) {
      return { status: 'unconfirmed', basis: 'refuted', refutationKind: kind, reason, quote: cq.trim(), quoteSource: 'clause', verifiedAt };
    }
    const aq = typeof o.article_quote === 'string' ? o.article_quote : '';
    if (aq && articleTexts.some((t) => quoteInText(aq, t))) {
      return { status: 'unconfirmed', basis: 'refuted', refutationKind: kind, reason, quote: aq.trim(), quoteSource: 'article', verifiedAt };
    }
    return { status: 'unconfirmed', basis: 'uncertain', reason: `${NO_QUOTE_NOTE}${reason}`, quote: null, quoteSource: null, verifiedAt };
  }
  return { status: 'unconfirmed', basis: 'uncertain', reason, quote: null, quoteSource: null, verifiedAt };
}

/**
 * طبيعة الادعاء الذى يتحقق منه المدقق (تُشتق من درجة الخطورة المخزَّنة بلا حقل جديد):
 *  - mandatory: ادعاء مخالفة نص آمر (حرج/عالٍ) ⇒ يُسأل المدقق هل المادة آمرة فعلاً وهل تنطبق.
 *  - deviation: اختلاف عن قاعدة عامة أو اختلال لمصلحة طرف (متوسط) ⇒ كون المادة مكملة مسلَّم به فى الملاحظة نفسها فلا يصلح سبباً
 *    للدحض، ويُسأل المدقق عن صحة الواقعة وانطباق المادة وجوهرية الاختلاف فقط.
 * تقرير إنتاج 5 نوفمبر 2026 (ستة عقود اصطناعية): 19 من 27 ملاحظة صحيحة على بنود معيبة وُسمت «غير مؤكدة» لأن المدقق دحضها بأن المادة مكملة.
 */
export type ClaimKind = 'mandatory' | 'deviation';

export function claimKindFromRisk(riskLevel: string | null | undefined): ClaimKind {
  return riskLevel === 'حرج' || riskLevel === 'عالٍ' ? 'mandatory' : 'deviation';
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

export interface ContextClause {
  clauseLabel: string;
  clauseText: string;
}

const PROFIT_LOSS = /(?:الأرباح|الارباح|الخسائر|الخسارة|الخساره|ربح|أرباح|ارباح|خسائر)/;
const CONTRIBUTION = /(?:رأس\s*المال|راس\s*المال|رأسمال|حصة|حصص|حصته|حصتهم|يقدم|يقدّم|مساهمة|بعمله|بالعمل|عمله\s+فقط)/;
const MAX_CONTEXT_CLAUSES = 2;
const MAX_CONTEXT_CHARS = 700;

/**
 * سياق البنود لمدقق بند الأرباح والخسائر: المادة 515/2 تتوقف على ما يقدمه الشريك (عمل فقط أم مال)، وهذا لا يظهر فى بند الأرباح وحده.
 * يُعاد بند أو بندان من بنود العقد الأخرى يتناولان رأس المال أو الحصص (يُقدَّم ما يجمع الأمرين)، وإلا فارغة.
 */
export function pickContributionContext(
  row: { clauseIndex: number; clauseText: string; matchedArticles?: Array<{ article_no: number }> | null },
  all: Array<{ clauseIndex: number; clauseLabel: string; clauseText: string }>,
): ContextClause[] {
  const isProfitLoss = (row.matchedArticles ?? []).some((m) => m.article_no === 515) || PROFIT_LOSS.test(row.clauseText);
  if (!isProfitLoss) return [];
  return all
    .filter((c) => c.clauseIndex !== row.clauseIndex && CONTRIBUTION.test(c.clauseText) && !(PROFIT_LOSS.test(c.clauseText) && !/رأس\s*المال|راس\s*المال|حصة|حصص/.test(c.clauseText)))
    .map((c) => ({ c, score: (/رأس\s*المال|راس\s*المال|رأسمال/.test(c.clauseText) ? 2 : 0) + (/حصة|حصص|بالعمل|بعمله/.test(c.clauseText) ? 1 : 0) }))
    .sort((a, b) => b.score - a.score || a.c.clauseIndex - b.c.clauseIndex)
    .slice(0, MAX_CONTEXT_CLAUSES)
    .map(({ c }) => ({ clauseLabel: c.clauseLabel, clauseText: c.clauseText.replace(/\s+/g, ' ').trim().slice(0, MAX_CONTEXT_CHARS) }));
}
