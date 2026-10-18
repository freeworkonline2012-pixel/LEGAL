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

// ===================== حواجز الادعاءات القانونية القاطعة (2026-10-18) =====================
// اختبار حى ثانٍ على عقد حقيقى أظهر أن تعليمات النموذج وحدها لا تكفى: وصف المادة 608
// بأنها "قاعدة آمرة لا يجوز الاتفاق على مخالفتها" رغم أن نصها المعروض لا يحوى منعاً.
// الحاجز الآن بنيوى لا لغوى: لا يُقبل ادعاء "آمرة/مخالفة صريحة" إلا مع عبارة حرفية
// يستشهد بها النموذج من نص المادة المعتمَدة نفسها، ونتحقق برمجياً أنها موجودة فعلاً.

export type ViolationType = 'none' | 'supplementary_difference' | 'mandatory_violation';

/** توحيد عربى للمطابقة فقط (لا يُعرض): تشكيل، تطويل، ألف/ياء/تاء مربوطة، مسافات. */
export function normalizeArabicForMatch(text: string): string {
  return (text ?? '')
    .replace(/[ً-ٰٟـ]/g, '')
    .replace(/[آأإ]/g, 'ا')
    .replace(/ى/g, 'ي')
    .replace(/ة/g, 'ه')
    .replace(/[^ء-ي0-9a-zA-Z\s]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

const MIN_QUOTE_LENGTH = 10;

/** هل العبارة المستشهَد بها موجودة حرفياً (بعد التوحيد) فى أحد نصوص المواد المعتمَدة؟ */
export function isQuoteInArticles(quote: string, articleTexts: string[]): boolean {
  const q = normalizeArabicForMatch(quote);
  if (q.length < MIN_QUOTE_LENGTH) {
    return false;
  }
  return articleTexts.some((t) => normalizeArabicForMatch(t).includes(q));
}

const MANDATORY_LANGUAGE =
  /(?:قاعدة\s+آمرة|القاعدة\s+الآمرة|القواعد\s+الآمرة|لا\s+يجوز\s+الاتفاق|يخالف\s+صراحة|تخالف\s+صراحة|مخالفة\s+صريحة|يخالف\s+نصاً\s+آمراً|باطل)/;

export interface GuardInput {
  reasoning: string;
  violationType: ViolationType;
  mandatoryQuote: string;
  /** نصوص المواد المعتمَدة فعلاً كأساس (matched) مع ترويسة كل منها لبناء الجملة الآمنة */
  matched: Array<{ law: string; articleNo: number; text: string }>;
}

export interface GuardResult {
  reasoning: string;
  violationType: ViolationType;
  mandatoryVerified: boolean;
}

/**
 * إن ادّعى النموذج مخالفة آمرة ولم تُثبتها عبارة حرفية من نص المادة، أو احتوى الشرح
 * لغة قاطعة بلا إثبات: تُخفَّض إلى "اختلاف عن القاعدة العامة" ويُستبدل الشرح بجملة
 * آمنة تذكر المادة فقط. لا نترك ادعاءً قانونياً قاطعاً بلا سند حرفى.
 */
export function guardMandatoryClaims(input: GuardInput): GuardResult {
  const verified =
    input.violationType === 'mandatory_violation' &&
    isQuoteInArticles(
      input.mandatoryQuote,
      input.matched.map((m) => m.text),
    );

  if (verified) {
    return { reasoning: input.reasoning, violationType: 'mandatory_violation', mandatoryVerified: true };
  }

  const claimsMandatory =
    input.violationType === 'mandatory_violation' || MANDATORY_LANGUAGE.test(input.reasoning ?? '');
  if (!claimsMandatory) {
    return { reasoning: input.reasoning, violationType: input.violationType, mandatoryVerified: false };
  }

  const first = input.matched[0];
  const safe = first
    ? `البند يختلف عن القاعدة العامة الواردة فى المادة ${first.articleNo} من ${first.law}، ويستحق نظر محامٍ مختص لتقدير أثر هذا الاختلاف.`
    : 'يلزم نظر محامٍ مختص فى هذا البند.';
  return { reasoning: safe, violationType: 'supplementary_difference', mandatoryVerified: false };
}

/**
 * بند بلا نص مفهرَس: الشرح الجيد جملة واحدة تصف موضوع البند. النموذج يُلحق أحياناً
 * تعليلاً عن نصوص استبعدها ("فالمادة 191 من قانون التجارة تخص...") — تفصيل داخلى
 * مربك للمستخدم، فنقتطع الشرح عند أول إشارة لذلك ونُلحق جملة موحّدة.
 */
const NO_TEXT_CUT = /(?:\s*[،,]?\s*و?لا\s+(?:يوجد|يحكم|يسرى|يسري|توجد)|\s*[،,]?\s*فالماد|\s*[،,]?\s*بينما\s+الماد)/;
const NO_TEXT_SUFFIX = 'لم نجد نصاً مفهرَساً يحكم هذا البند مباشرة.';

export function tidyNoTextReasoning(reasoning: string): string {
  const text = (reasoning ?? '').trim();
  const idx = text.search(NO_TEXT_CUT);
  const topic = (idx >= 0 ? text.slice(0, idx) : text).replace(/[،,\s.]+$/, '').trim();
  if (!topic || topic.length < 8) {
    return 'لا يوجد نص قانونى مصرى مفهرَس يحكم هذا البند مباشرة.';
  }
  return `${topic}. ${NO_TEXT_SUFFIX}`;
}
