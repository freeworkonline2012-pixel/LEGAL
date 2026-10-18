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
/**
 * العبارة التى تُثبت الصفة الآمرة/الناهية يجب أن تحمل أثراً ملزماً صريحاً. وجود أى عبارة
 * فى نص المادة لا يكفى: المادة 608 مثلاً حُكم عليها "آمرة" بعبارة عادية من نصها (اختبار حى 5).
 */
const MANDATORY_MARKER =
  /باطل|بطلان|لا يجوز|لا تجوز|يحظر|يحرم|ممنوع|لا يكون\s+نافذ|لا ينفذ|لا يسري|لا تسري|لا يعتد|لا يصح|يقع\s+باطل|كل اتفاق\s+يخالف|على خلاف ذلك/;

export function hasMandatoryMarker(quote: string): boolean {
  return MANDATORY_MARKER.test(normalizeArabicForMatch(quote));
}

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
  /** حالة التقييم النهائية؛ "سليم" لا تُستبدل شروحه بجملة اختلاف بل تُحذف منه جمل الادعاء القاطع فقط */
  assessmentStatus?: string;
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
  if (input.assessmentStatus === 'سليم') {
    // بند سليم لا يحمل ادعاء مخالفة: الجملة البديلة "يختلف عن القاعدة" تناقض حالته (اختبار حى 5،
    // البند 11). نُسقط فقط الجمل ذات اللغة القاطعة ونُبقى بقية الشرح.
    const sentences = (input.reasoning ?? '')
      .split(/(?<=[.؟!])\s+/)
      .map((x) => x.trim())
      .filter(Boolean)
      .filter((x) => !MANDATORY_LANGUAGE.test(x));
    return {
      reasoning: sentences.length > 0 ? sentences.join(' ') : 'لا مخالفة ظاهرة لنص آمر فى النصوص المعروضة.',
      violationType: 'none',
      mandatoryVerified: false,
    };
  }
  const verified =
    input.violationType === 'mandatory_violation' &&
    hasMandatoryMarker(input.mandatoryQuote) &&
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

  // المادة المحورية هى أول مادة معتمَدة يذكرها شرح النموذج نفسه (لا أول مرشح بالضرورة):
  // اختبار حى 5: كان الشرح عن المادة 224 فحلّت محله جملة عن المادة 598 غير ذات صلة.
  const mentioned = articleNumbersIn(input.reasoning ?? '');
  const first = input.matched.find((m) => mentioned.includes(m.articleNo)) ?? input.matched[0];
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
const NO_TEXT_CUT = /(?:\s*[،,]?\s*و?لا\s+(?:يوجد|يحكم|يسرى|يسري|توجد)|\s*[،,]?\s*فالماد|\s*[،,]?\s*بينما\s+الماد|\s*[،,]?\s*و?(?:ال)?مرش(?:ح|حان|حون|حين|حو)(?![\u0621-\u064A]))/;
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

/**
 * اختلاف البند عن قاعدة مكملة ليس "مخالفة" (الطرفان حران فى الاتفاق على خلافها): نصحّح
 * الصياغة الجارية "يخالف القاعدة المكملة" إلى "يختلف عن القاعدة المكملة". وحين لا تثبت
 * مخالفة آمرة بعبارة حرفية (verified=false) تُخفَّف أيضاً "يخالف مقتضى/حكم/نص المادة"
 * إلى "يختلف عن"، لأن لفظ المخالفة ادعاء قاطع بلا سند حرفى. جولتا اختبار حى 3 و4.
 */
export function softenSupplementaryWording(reasoning: string, verifiedMandatory = false): string {
  let out = (reasoning ?? '').replace(
    /(?:يخالف|تخالف)\s+(?=(?:ال)?قواعد?\s+(?:ال)?مكملة|(?:ال)?قاعدة\s+(?:ال)?مكملة)/g,
    'يختلف عن ',
  );
  if (!verifiedMandatory) {
    out = out.replace(
      /(?:يخالف|تخالف)\s+(?=(?:مقتضى|حكم|نص|ما\s+تقضى|ما\s+تقضي|الماد[ةه]|(?:ال)?قاعد[ةه]))/g,
      'يختلف عن ',
    );
    // "يتعارض مع" ادعاء قاطع كذلك (البند 6: "يتعارض مع المادة 598" وهى لا تمنع الإنهاء بإخطار)
    out = out.replace(
      /(?:يتعارض|تتعارض)\s+مع\s+(?=(?:مقتضى|حكم|نص|ما\s+تقضى|ما\s+تقضي|الماد[ةه]|(?:ال)?قاعد[ةه]))/g,
      'يختلف عن ',
    );
  }
  return out;
}

const ARTICLE_REF = /(?:ال)?(?:ماد(?:ة|ه|تين|تان|تي)|مواد)\s*(?:رقم\s*)?((?:\d+(?:\/\d+)?(?:\s*(?:،|,|و|أو|او|إلى|الى)\s*)?)+)/g;

function articleNumbersIn(sentence: string): number[] {
  const nums: number[] = [];
  for (const m of sentence.matchAll(ARTICLE_REF)) {
    for (const n of m[1].matchAll(/(\d+)(?:\/\d+)?/g)) {
      nums.push(Number(n[1]));
    }
  }
  return nums;
}

/**
 * جمل الشرح التى تذكر رقم مادة ليس بين المواد المعتمَدة فعلاً (غالباً مادة استبعدها
 * النموذج: "المادة 18 من نموذج عقد التأمين لا تحكم هذا البند") تُحذف: هى تفصيل داخلى
 * مربك، وأى ادعاء عن مادة غير معتمَدة بلا سند. إن لم يبقَ شىء يُستخدم الاحتياطى.
 */
export function dropUnapprovedArticleSentences(
  reasoning: string,
  approvedArticleNos: number[],
  fallback: string,
): string {
  const approved = new Set(approvedArticleNos);
  const sentences = (reasoning ?? '')
    .split(/(?<=[.؟!])\s+/)
    .map((x) => x.trim())
    .filter(Boolean);
  const kept = sentences.filter((sentence) => articleNumbersIn(sentence).every((n) => approved.has(n)));
  if (kept.length === 0) {
    return fallback;
  }
  return kept.join(' ');
}
