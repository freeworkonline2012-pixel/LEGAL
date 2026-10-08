import {
  TEXT_COVERAGE_MIN,
  TEXT_UPGRADE_COVERAGE_MIN,
  claimCoverage,
  contentStems,
  extractArticleNumbers,
  findUnsupportedTerms,
  normalizeForQuote,
} from './answer-grounding';
import { detectCrossReferencedArticles } from './retrieval';
import { isAlreadyAnsweredFact, type ParsedFact } from './clarification';

export { normalizeForQuote };

/**
 * الإجابة المنظَّمة (2026-10-05 — طلب صريح من صاحب المشروع: "جواب مباشر أولاً،
 * سند عند كل حكم، تمييز نص/تفسير، حالة المصدر، تحذيرات ومسائل مفتوحة بارزة،
 * وقائع تحتاج تأكيداً، نص المادة أو رابطها، إيجاز").
 *
 * هذا الملف دوال **نقية** (بلا I/O ولا نموذج لغوى) — كل ما يمكن التحقق منه
 * حتمياً يُتحقَّق منه هنا لا بالاعتماد على التزام النموذج:
 *   - وسم "نص" لا يُقبل إلا إذا وُجد مقتطف حرفى منسوخ فعلاً من نص المادة
 *     المرفقة (verifyQuote)؛ وإلا يُخفَّض تلقائياً إلى "تفسير".
 *   - حالة المصدر (ساري/معدّل/ملغى/غير محسوم) تأتى من قاعدة البيانات
 *     (computeSourceStatus) لا من النموذج.
 *   - بنية JSON الخارجة من النموذج تُفحَص وتُنظَّف وتُقيَّد الأطوال
 *     (parseStructuredAnswer) — أى بنية فاسدة تُرفَض كلياً فيرجع الاستدعاء
 *     للمسار القديم المُعايَر (composeGroundedAnswerMulti) بلا أى تغيير.
 */

export type RulingKind = 'نص' | 'تفسير';
export type SourceStatusLabel = 'ساري' | 'معدّل' | 'ملغى' | 'غير محسوم';

export interface StructuredRuling {
  /** الحكم/الحق/الالتزام فى جملة موجزة واحدة (الشروط والاستثناءات داخل نفس الجملة). */
  claim: string;
  /** "نص": مقتطف حرفى تحقَّقنا منه؛ "تفسير": ربط/استنتاج/تطبيق على واقعة. */
  kind: RulingKind;
  /** فهرس (من صفر) للمادة المستند إليها داخل مصفوفة citations فى نفس الاستجابة. */
  citation_index: number;
  /** المقتطف الحرفى المنسوخ من المادة (إن وُجد). */
  quote: string | null;
  /** هل وُجد المقتطف فعلاً داخل نص المادة (فحص حتمى). */
  quote_verified: boolean;
}

/**
 * سيناريو تطبيقى: «إن كانت الواقعة كذا فالنتيجة كذا» مستنبَط من مادة واحدة مرفقة
 * (تطبيق للنص على احتمال فى حالة السائل — ليس نصاً حرفياً ولا يُوسَم نصاً أبداً).
 */
export interface StructuredScenario {
  condition: string;
  outcome: string;
  /** فهرس (من صفر) للمادة التى يُستنبَط منها السيناريو. */
  citation_index: number;
}

/**
 * تطبيق واقعة ذكرها السائل (فى سؤاله أو إجابته عن أسئلة الاستيضاح) على نص: «الواقعة ← أثرها القانونى ← المادة».
 * خطوة إلزامية فى وضع الوقائع تُكتب قبل الجواب المباشر فتُلزم النموذج بتطبيق ما قاله السائل بدل تجاهله
 * (تقييم حى 5/10، 2026-10-08)، وتُعرَض للسائل قسماً مستقلاً «تطبيق على وقائعك».
 */
export interface StructuredFactApplied {
  fact: string;
  effect: string;
  /** فهرس (من صفر) للمادة المستند إليها الأثر، أو null إن لم يُسنَد لمادة بعينها. */
  citation_index: number | null;
}

export interface StructuredAnswer {
  direct_answer: string;
  /** وقائع السائل مطبَّقة على النصوص — موجودة فقط فى وضع الوقائع (بعد الاستيضاح). */
  facts_applied?: StructuredFactApplied[];
  rulings: StructuredRuling[];
  scenarios: StructuredScenario[];
  open_issues: string[];
  warnings: string[];
  facts_to_confirm: string[];
  not_covered: string[];
}

export interface StructuredArticleMeta {
  /** نص المادة المرفق فعلياً للنموذج (للتحقق الحرفى من المقتطفات). */
  text: string;
  /** رقم المادة (لربط رقم المادة المذكور فى تحذير بنصها وفحص تأصيله). اختيارى للتوافق. */
  articleNo?: number;
}

/** إحصاءات تشخيصية للتسجيل فقط (لا تُعرَض للمستخدم). */
export interface ParseStats {
  /** عدد الأحكام التى طلب النموذج وسمها "نص". */
  requested_text: number;
  /** منها ما خُفِّض إلى "تفسير" لعدم ثبوت المقتطف الحرفى. */
  downgraded: number;
  /** أحكام أُسقطت لمصدر غير صالح. */
  dropped: number;
  /** سبب كل تخفيض (للتسجيل التشخيصى فقط): 'no_quote' | 'unverified' مع رأس المقتطف. */
  failures: string[];
  /** تحذيرات أُسقطت لأنها لا تذكر رقم المادة المستندة إليها (حكم قانونى بلا سند). */
  warnings_dropped: number;
  /** أحكام خُفِّضت من «نص» إلى «تفسير» لأن المقتطف الظاهر لا يغطى الحكم (تغطية < العتبة). */
  coverage_downgraded: number;
  /** أحكام رُفعت من «تفسير» إلى «نص» لأنها تطابق مقتطفها الموثَّق عملياً. */
  coverage_upgraded: number;
  /** بنود أُسقطت لأن أثراً شديداً أو مقداراً فيها لا أصل لفظياً له فى المادة المستند إليها. */
  guard_dropped: { rulings: number; warnings: number; scenarios: number };
  /** تفاصيل الإسقاط للتسجيل التشخيصى فقط (لا تُعرَض للمستخدم). */
  guard_details: string[];
}

export interface ParseOptions {
  /** مفتاح إيقاف فحص التأصيل (الافتراضى مفعَّل). يُقرأ من STRUCTURED_GUARD_ENABLED عند الاستدعاء. */
  guard?: boolean;
  /** إجابات السائل من الاستيضاح: تُقبل مقاديرها (لا آثارها) فى بوابة التأصيل، ويُفعَّل بها وضع الوقائع. */
  factsText?: string;
  /** وقائع أجاب عنها السائل: تُحذف من facts_to_confirm أى واقعة تكررها (لا نسأله ثانيةً عما أجاب). */
  answeredFacts?: readonly ParsedFact[];
}

export type ParseStructuredResult =
  | { ok: true; value: StructuredAnswer; stats: ParseStats }
  | { ok: false; reason: string };

export const MAX_RULINGS = 10;
export const MAX_SCENARIOS = 6;
export const MAX_LIST_ITEMS = 8;
/** إيجاز العرض: حدود أضيق لقوائم التحذيرات والوقائع (المسائل المفتوحة تبقى حتى MAX_LIST_ITEMS). */
export const MAX_WARNINGS = 5;
export const MAX_FACTS = 5;
export const MAX_FACTS_APPLIED = 6;
export const MAX_FIELD_CHARS = 700;
export const MAX_QUOTE_WORDS = 40;

/**
 * تحذير النموذج لا يُقبل إلا إذا ذكر رقم المادة المستند إليها («المادة 156» / «المواد 87 و88»
 * / «م 95»): التحذير الذى يقرر مدة أو شرطاً بلا سند حكم قانونى بلا سند، ويخالف قاعدة
 * «السند عند كل حكم». (بوابة الهلوسة تتحقق بعدها أن كل رقم مادة مذكور ضمن النصوص المرسلة.)
 * تحذيرات حالة المصدر (ساري/معدّل/ملغى) يضيفها الخادم من قاعدة البيانات وتُستثنى من هذا الشرط.
 */
const ARTICLE_REF_RE = /(?:المادة|المواد|مادة|م)\s*\.?\s*\(?\s*[0-9\u0660-\u0669]+/;
export function hasArticleRef(text: string): boolean {
  return ARTICLE_REF_RE.test(text);
}

/**
 * حالة المصدر لعرضها للمستخدم — مشتقة حتمياً من حالة القانون المخزَّنة.
 *  - in_force/active → ساري
 *  - amended → معدّل (إن عُرف تاريخ آخر تعديل) وإلا غير محسوم: نعلم أنه عُدِّل
 *    لكن لا نعلم هل النص المخزَّن هو النص المعدَّل أم قبل التعديل.
 *  - repealed → ملغى
 *  - أى قيمة أخرى/مفقودة → غير محسوم (لا نفترض السريان أبداً).
 */
export function computeSourceStatus(input: {
  status: string | null | undefined;
  lastAmended: string | null | undefined;
}): SourceStatusLabel {
  const s = (input.status ?? '').toLowerCase();
  if (s === 'active' || s === 'in_force') return 'ساري';
  if (s === 'repealed') return 'ملغى';
  if (s === 'amended') return input.lastAmended ? 'معدّل' : 'غير محسوم';
  return 'غير محسوم';
}

/**
 * يتحقق أن المقتطف منسوخ حرفياً من نص المادة. يسمح بفواصل حذف ("..." أو "…")
 * بين مقاطع المقتطف: كل مقطع (3 كلمات فأكثر) يجب أن يظهر كاملاً فى نص المادة.
 * لا يتسامح مع مقطع أقصر من كلمتين (تفادياً لمطابقة عرضية).
 */
export function verifyQuote(quote: string, articleText: string): boolean {
  const hay = ` ${normalizeForQuote(articleText)} `;
  const fragments = quote
    .split(/\.{2,}|…|\[…\]|\[\.\.\.\]/)
    .map((f) => normalizeForQuote(f))
    .filter((f) => f.length > 0);
  if (fragments.length === 0) return false;
  let totalWords = 0;
  for (const f of fragments) {
    const words = f.split(' ').length;
    totalWords += words;
    if (!hay.includes(` ${f} `)) return false;
  }
  return totalWords >= 3;
}

/**
 * ترقيم فرعى مبتكر (2h — تقييم حى 7.5/10: «المادة 108/8» والبند الصحيح 4): الترقيم بالشرطة المائلة بعد رقم المادة
 * لا يرد فى مصدرنا (البنود تُذكر نصاً: «البند 4») فيُحذف الجزء الفرعى ويبقى رقم المادة وحده، كى لا يُنسَب للمادة
 * بند غير موجود. لا يُطبَّق على المقتطفات الحرفية.
 */
export function stripInventedSubCitation(text: string): string {
  return text.replace(/((?:المادة|مادة|المادتين|م)\s*\(?\s*[0-9٠-٩]{1,4})\s*\/\s*[0-9٠-٩]{1,3}(?![0-9٠-٩])/g, '$1');
}

function cleanStr(v: unknown, max = MAX_FIELD_CHARS, verbatim = false): string {
  if (typeof v !== 'string') return '';
  const s0 = v.replace(/\s+/g, ' ').trim();
  const s = verbatim ? s0 : stripInventedSubCitation(s0);
  return s.length > max ? `${s.slice(0, max - 1).trimEnd()}…` : s;
}

function cleanList(v: unknown, max: number = MAX_LIST_ITEMS): string[] {
  if (!Array.isArray(v)) return [];
  const out: string[] = [];
  for (const item of v) {
    const s = cleanStr(item);
    if (s.length >= 3 && !out.includes(s)) out.push(s);
    if (out.length >= max) break;
  }
  return out;
}

function stripFences(raw: string): string {
  const t = raw.trim();
  const m = t.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i);
  return m ? m[1] : t;
}

/**
 * يزيل أداة الشرط الافتتاحية («إذا/إن/لو/فى حال/عند») من بداية شرط السيناريو: العرض (الخادم والواجهة)
 * يضيف «إذا» قبل الشرط، فكان شرط يبدأ بها أصلاً يُعرَض «إذا إذا ...» (تقييم حى 8/10، 2026-10-08).
 */
export function stripConditionLead(condition: string): string {
  return condition
    .replace(/^\s*(?:[وف]\s*)?(?:(?:إذا|اذا|إن|لو)|فى\s+حال(?:ة)?|في\s+حال(?:ة)?|عند(?:ما)?)\s+/, '')
    .trim();
}

function newParseStats(): ParseStats {
  return {
    requested_text: 0,
    downgraded: 0,
    dropped: 0,
    failures: [],
    warnings_dropped: 0,
    coverage_downgraded: 0,
    coverage_upgraded: 0,
    guard_dropped: { rulings: 0, warnings: 0, scenarios: 0 },
    guard_details: [],
  };
}

interface ParseCtx {
  articles: readonly StructuredArticleMeta[];
  guard: boolean;
  stats: ParseStats;
  factsText?: string;
  answeredFacts?: readonly ParsedFact[];
}

/**
 * اقتطاع المقتطف الطويل الموثَّق (2h — تقييم حى 7.5/10: حكم المادة 88 وُسم «تفسير» رغم أنه نص حرفى): كان الاقتطاع
 * يأخذ أول MAX_QUOTE_WORDS كلمة دائماً، فإن جاءت كلمات الحكم المضمونية فى ذيل مادة طويلة سقطت من المقتطف الظاهر
 * وهبط الوسم. الآن يُختار أفضل نافذة متصلة من MAX_QUOTE_WORDS كلمة (أعلى تغطية لكلمات الحكم؛ التعادل للأبكر).
 * النافذة جزء حرفى متصل من المقتطف الموثَّق، وتُعلَّم بـ«…» عند كل طرف مقتطع.
 */
export function clipQuoteToBestWindow(rawQuote: string, claim: string): string {
  const words = rawQuote.split(/\s+/);
  if (words.length <= MAX_QUOTE_WORDS) return rawQuote;
  let bestStart = 0;
  let bestScore = -1;
  for (let i = 0; i + MAX_QUOTE_WORDS <= words.length; i += 3) {
    const score = claimCoverage(claim, words.slice(i, i + MAX_QUOTE_WORDS).join(' '));
    if (score > bestScore + 1e-9) {
      bestScore = score;
      bestStart = i;
    }
  }
  const lastStart = words.length - MAX_QUOTE_WORDS;
  const lastScore = claimCoverage(claim, words.slice(lastStart).join(' '));
  if (lastScore > bestScore + 1e-9) bestStart = lastStart;
  const end = bestStart + MAX_QUOTE_WORDS;
  const body = words.slice(bestStart, end).join(' ');
  return `${bestStart > 0 ? '… ' : ''}${body}${end < words.length ? ' …' : ''}`;
}

function parseRulingsList(rawRulings: unknown, ctx: ParseCtx): StructuredRuling[] {
  const { articles, guard, stats, factsText } = ctx;
  const rulings: StructuredRuling[] = [];
  for (const r of Array.isArray(rawRulings) ? rawRulings : []) {
    if (!r || typeof r !== 'object') continue;
    const rr = r as Record<string, unknown>;
    const claim = cleanStr(rr.claim);
    const srcNum = Number(rr.source);
    if (claim.length < 5) continue;
    if (!Number.isInteger(srcNum) || srcNum < 1 || srcNum > articles.length) {
      stats.dropped++;
      continue;
    }
    const idx = srcNum - 1;
    // فحص التأصيل: أثر شديد (سقوط/تقادم/بطلان...) أو مقدار (عدد+وحدة) فى الحكم لا أصل لفظياً له
    // فى المادة المستند إليها → يُسقَط الحكم (لا يُخفَّض): حكم بمدة أو أثر ملفَّق أخطر من حكم ناقص.
    if (guard) {
      const unsupported = findUnsupportedTerms(claim, [articles[idx].text], factsText);
      if (unsupported.length > 0) {
        stats.guard_dropped.rulings++;
        stats.guard_details.push(`ruling[م${articles[idx].articleNo ?? srcNum}]: ${unsupported.join('،')}`);
        continue;
      }
    }
    const rawQuote: string | null = cleanStr(rr.quote, 1200, true) || null;
    // التحقق يجرى على المقتطف كاملاً (حتى لو طويل)؛ المقتطف الطويل الموثَّق يُعرَض مقتطعاً
    // بأول MAX_QUOTE_WORDS كلمة مع "…" (جزء حرفى حقيقى من النص) بدل إسقاطه كلياً.
    const verified = rawQuote ? verifyQuote(rawQuote, articles[idx].text) : false;
    let quote: string | null = null;
    if (verified && rawQuote) {
      quote = clipQuoteToBestWindow(rawQuote, claim);
    }
    const requested = cleanStr(rr.kind, 20);
    // الوسم يُحسَب حتمياً لا بادعاء النموذج وحده: «نص» يتطلب (1) مقتطفاً حرفياً صحيحاً و(2) أن
    // يغطى المقتطف *الظاهر للمستخدم* كلمات الحكم المضمونية (عتبة TEXT_COVERAGE_MIN)؛ وحكم وسمه
    // النموذج «تفسير» لكنه يكاد يطابق مقتطفه الموثَّق (≥ TEXT_UPGRADE_COVERAGE_MIN) يُرفَع إلى «نص».
    const coverage = verified && quote ? claimCoverage(claim, quote) : 0;
    let kind: RulingKind = 'تفسير';
    if (verified) {
      if (requested === 'نص' && coverage >= TEXT_COVERAGE_MIN) kind = 'نص';
      else if (requested !== 'نص' && coverage >= TEXT_UPGRADE_COVERAGE_MIN) kind = 'نص';
    }
    if (requested === 'نص') {
      stats.requested_text++;
      if (kind !== 'نص') {
        stats.downgraded++;
        if (verified) {
          stats.coverage_downgraded++;
          // الكلمات المضمونية فى الحكم غير الواردة فى المقتطف الظاهر: تشخيص حى لضبط العتبة بدليل.
          const shown = new Set(contentStems(quote ?? ''));
          const missing = contentStems(claim).filter((w) => !shown.has(w));
          stats.failures.push(
            `coverage(${coverage.toFixed(2)}): ${claim.slice(0, 60)} غير_مغطى=[${missing.join(' ')}]`,
          );
        } else {
          stats.failures.push(rawQuote ? `unverified(${rawQuote.split(/\s+/).length}w): ${rawQuote.slice(0, 70)}` : 'no_quote');
        }
      }
    } else if (kind === 'نص') {
      stats.coverage_upgraded++;
    }
    rulings.push({
      claim,
      kind,
      citation_index: idx,
      quote,
      quote_verified: verified,
    });
    if (rulings.length >= MAX_RULINGS) break;
  }
  return rulings;
}

function parseWarningsList(rawWarnings: unknown, ctx: ParseCtx): string[] {
  const { articles, guard, stats, factsText } = ctx;
  // نصوص المواد حسب الرقم (لربط «(المادة 108)» المذكورة فى تحذير بنص تلك المادة فعلاً).
  const textsByNo = new Map<number, string[]>();
  for (const a of articles) {
    if (typeof a.articleNo === 'number') {
      textsByNo.set(a.articleNo, [...(textsByNo.get(a.articleNo) ?? []), a.text]);
    }
  }
  const warningsRaw = cleanList(rawWarnings, MAX_LIST_ITEMS);
  const warningsSourced: string[] = [];
  let guardDroppedHere = 0;
  for (const w of warningsRaw) {
    if (!hasArticleRef(w)) continue;
    if (guard) {
      // بلا أرقام مواد فى بيانات المواد (استدعاء قديم/اختبار) يُفحَص على اتحاد كل النصوص.
      const nos = extractArticleNumbers(w);
      const support =
        textsByNo.size === 0
          ? articles.map((a) => a.text)
          : nos.flatMap((n) => textsByNo.get(n) ?? []);
      if (support.length === 0) {
        stats.guard_dropped.warnings++;
        guardDroppedHere++;
        stats.guard_details.push(`warning[مادة غير مرسَلة ${nos.join(',')}]: ${w.slice(0, 50)}`);
        continue;
      }
      const unsupported = findUnsupportedTerms(w, support, factsText);
      if (unsupported.length > 0) {
        stats.guard_dropped.warnings++;
        guardDroppedHere++;
        stats.guard_details.push(`warning[م${nos.join(',')}]: ${unsupported.join('،')} — ${w.slice(0, 50)}`);
        continue;
      }
    }
    if (warningsSourced.some((x) => sameArticleWarning(x, w))) continue;
    warningsSourced.push(w);
  }
  stats.warnings_dropped += warningsRaw.length - warningsSourced.length - guardDroppedHere;
  return warningsSourced;
}

/**
 * تطبيقات الوقائع (facts_applied): كل بند «واقعة ← أثر» يخضع لنفس بوابة التأصيل: أثره لا يحمل أثراً شديداً
 * أو مقداراً بلا أصل فى المادة المستند إليها (أو فى إجابات السائل للمقادير). بند بلا مادة يُفحَص بلا مادة
 * (أى أثر شديد فيه يُسقطه). لا يُقبل أى بند خارج وضع الوقائع.
 */
function parseFactsAppliedList(rawFacts: unknown, ctx: ParseCtx): StructuredFactApplied[] {
  const { articles, guard, stats, factsText } = ctx;
  if (!factsText || factsText.trim().length === 0) return [];
  const out: StructuredFactApplied[] = [];
  for (const it of Array.isArray(rawFacts) ? rawFacts : []) {
    if (!it || typeof it !== 'object') continue;
    const o = it as Record<string, unknown>;
    const fact = cleanStr(o.fact, 260);
    const effect = cleanStr(o.effect, 420);
    if (fact.length < 3 || effect.length < 5) continue;
    const srcNum = Number(o.source);
    const hasSrc = Number.isInteger(srcNum) && srcNum >= 1 && srcNum <= articles.length;
    const idx = hasSrc ? srcNum - 1 : null;
    if (guard) {
      const unsupported = findUnsupportedTerms(effect, idx === null ? [] : [articles[idx].text], factsText);
      if (unsupported.length > 0) {
        stats.guard_details.push(`facts_applied[${idx === null ? '-' : `م${articles[idx].articleNo ?? srcNum}`}]: ${unsupported.join('،')}`);
        continue;
      }
    }
    if (out.some((x) => x.fact === fact && x.effect === effect)) continue;
    out.push({ fact, effect, citation_index: idx });
    if (out.length >= MAX_FACTS_APPLIED) break;
  }
  return out;
}

function parseScenariosList(rawScenarios: unknown, ctx: ParseCtx): StructuredScenario[] {
  const { articles, guard, stats, factsText } = ctx;
  const scenarios: StructuredScenario[] = [];
  for (const sc of Array.isArray(rawScenarios) ? rawScenarios : []) {
    if (!sc || typeof sc !== 'object') continue;
    const ss = sc as Record<string, unknown>;
    const condition = stripConditionLead(cleanStr(ss.condition, 260));
    const outcome = cleanStr(ss.outcome, 360);
    const srcNum = Number(ss.source);
    if (condition.length < 5 || outcome.length < 5) continue;
    if (!Number.isInteger(srcNum) || srcNum < 1 || srcNum > articles.length) continue;
    const idx = srcNum - 1;
    if (guard) {
      const unsupported = findUnsupportedTerms(`${condition} ${outcome}`, [articles[idx].text], factsText);
      if (unsupported.length > 0) {
        stats.guard_dropped.scenarios++;
        stats.guard_details.push(`scenario[م${articles[idx].articleNo ?? srcNum}]: ${unsupported.join('،')}`);
        continue;
      }
    }
    if (scenarios.some((x) => x.condition === condition && x.outcome === outcome)) continue;
    scenarios.push({ condition, outcome, citation_index: idx });
    if (scenarios.length >= MAX_SCENARIOS) break;
  }
  return scenarios;
}

/**
 * يحوّل مخرَج النموذج (نص JSON) إلى StructuredAnswer نظيف ومُتحقَّق منه.
 * الأرقام فى rulings[].source تبدأ من 1 (كما تُرقَّم النصوص فى الـprompt) وتُحوَّل
 * هنا إلى citation_index يبدأ من صفر. أى حكم يشير لنص غير موجود يُسقَط (لا
 * يُخمَّن) — وإن سقطت كل الأحكام تُرفَض البنية كلياً.
 */
export function parseStructuredAnswer(
  raw: string,
  articles: readonly StructuredArticleMeta[],
  options: ParseOptions = {},
): ParseStructuredResult {
  const guard = options.guard !== false;
  let data: unknown;
  try {
    data = JSON.parse(stripFences(raw));
  } catch {
    return { ok: false, reason: 'unparseable_json' };
  }
  if (!data || typeof data !== 'object' || Array.isArray(data)) {
    return { ok: false, reason: 'not_an_object' };
  }
  const obj = data as Record<string, unknown>;
  const direct = cleanStr(obj.direct_answer, 900);
  if (direct.length < 8) {
    return { ok: false, reason: 'missing_direct_answer' };
  }
  const stats = newParseStats();
  const ctx: ParseCtx = {
    articles,
    guard,
    stats,
    factsText: options.factsText,
    answeredFacts: options.answeredFacts,
  };
  const rulings = parseRulingsList(obj.rulings, ctx);
  if (rulings.length === 0) {
    return { ok: false, reason: 'no_valid_rulings' };
  }
  const warningsSourced = parseWarningsList(obj.warnings, ctx);
  const scenarios = parseScenariosList(obj.scenarios, ctx);
  const factsApplied = parseFactsAppliedList(obj.facts_applied, ctx);
  const factsToConfirm = cleanList(obj.facts_to_confirm, MAX_FACTS).filter(
    (f) => !isAlreadyAnsweredFact(f, options.answeredFacts ?? []),
  );
  return {
    ok: true,
    value: {
      direct_answer: direct,
      ...(factsApplied.length > 0 ? { facts_applied: factsApplied } : {}),
      rulings,
      scenarios,
      open_issues: cleanList(obj.open_issues),
      warnings: warningsSourced.slice(0, MAX_WARNINGS),
      facts_to_confirm: factsToConfirm,
      not_covered: cleanList(obj.not_covered),
    },
    stats,
  };
}

// ---------------------------------------------------------------------------
// خطوة الاستكمال: مواد مُرسَلة لم يُستند إليها (2026-10-08 — من تقييم حى 8/10)
// ---------------------------------------------------------------------------

/** إضافات الاستكمال بعد التحقق: أحكام/سيناريوهات/تنبيهات + مواد أقرّ النموذج بعدم صلتها. */
export interface StructuredAddition {
  rulings: StructuredRuling[];
  scenarios: StructuredScenario[];
  warnings: string[];
  /** مواد قرر النموذج عدم إدراجها مع سبب موجز (للتسجيل فقط). */
  skipped: Array<{ article: number; reason: string }>;
}

export type ParseAdditionResult =
  | { ok: true; value: StructuredAddition; stats: ParseStats }
  | { ok: false; reason: string };

/**
 * يحلل مخرَج خطوة الاستكمال: {rulings, scenarios, warnings, skipped}. نفس فحوص التأصيل والاقتباس
 * والوسم الحتمى للمسار الأول بالحرف (دوال مشتركة)، وبلا اشتراط جواب مباشر أو حكم واحد على الأقل
 * (قد يقر النموذج بعدم صلة كل المواد المتبقية).
 */
export function parseStructuredAddition(
  raw: string,
  articles: readonly StructuredArticleMeta[],
  options: ParseOptions = {},
): ParseAdditionResult {
  let data: unknown;
  try {
    data = JSON.parse(stripFences(raw));
  } catch {
    return { ok: false, reason: 'unparseable_json' };
  }
  if (!data || typeof data !== 'object' || Array.isArray(data)) {
    return { ok: false, reason: 'not_an_object' };
  }
  const obj = data as Record<string, unknown>;
  const stats = newParseStats();
  const ctx: ParseCtx = { articles, guard: options.guard !== false, stats, factsText: options.factsText, answeredFacts: options.answeredFacts };
  const skipped: Array<{ article: number; reason: string }> = [];
  for (const sk of Array.isArray(obj.skipped) ? obj.skipped : []) {
    if (!sk || typeof sk !== 'object') continue;
    const o = sk as Record<string, unknown>;
    const article = Number(o.article);
    if (Number.isInteger(article) && article > 0) skipped.push({ article, reason: cleanStr(o.reason, 160) });
  }
  return {
    ok: true,
    value: {
      rulings: parseRulingsList(obj.rulings, ctx),
      scenarios: parseScenariosList(obj.scenarios, ctx),
      warnings: parseWarningsList(obj.warnings, ctx),
      skipped,
    },
    stats,
  };
}

/** أرقام المواد المرسَلة التى لم يستند إليها أى حكم أو سيناريو ولم يذكرها أى تحذير فى الإجابة. */
export function findUncoveredArticles(
  value: StructuredAnswer,
  articles: ReadonlyArray<{ articleNo: number }>,
): number[] {
  const used = new Set<number>();
  for (const r of value.rulings) {
    const a = articles[r.citation_index];
    if (a) used.add(a.articleNo);
  }
  for (const sc of value.scenarios ?? []) {
    const a = articles[sc.citation_index];
    if (a) used.add(a.articleNo);
  }
  for (const w of value.warnings) for (const n of extractArticleNumbers(w)) used.add(n);
  const out = new Set<number>();
  for (const a of articles) if (!used.has(a.articleNo)) out.add(a.articleNo);
  return [...out].sort((x, y) => x - y);
}

const DUP_COVERAGE = 0.8;
function nearDuplicate(a: string, b: string): boolean {
  return claimCoverage(a, b) >= DUP_COVERAGE && claimCoverage(b, a) >= DUP_COVERAGE;
}

/**
 * تنبيهان مكرران: متطابقان تقريباً، أو يستندان إلى المجموعة نفسها من المواد ويشتركان فى معظم كلماتهما المضمونية
 * (تقييم حى 5/10: تنبيه المادة 161 ورد مرتين بصياغتين). الاشتراك ≥ 0.5 من الأصغر وكلمتان على الأقل.
 */
export function sameWarning(a: string, b: string): boolean {
  return a === b || nearDuplicate(a, b) || sameArticleWarning(a, b);
}

/** تنبيهان يستندان إلى المجموعة نفسها من المواد ويشتركان فى معظم كلماتهما المضمونية (يُستعمل وحده فى التحليل). */
export function sameArticleWarning(a: string, b: string): boolean {
  if (a === b) return true;
  const na = extractArticleNumbers(a).sort((x, y) => x - y).join(',');
  const nb = extractArticleNumbers(b).sort((x, y) => x - y).join(',');
  if (!na || na !== nb) return false;
  // الإشارة إلى المادة نفسها («المادة 161») لا تُحسب اشتراكاً مضمونياً.
  const strip = (t: string) => t.replace(/(?:ال)?ماد[ةه]\s*\(?\d+\)?(?:\s*[و،,]\s*\d+)*/g, ' ');
  const sa = new Set(contentStems(strip(a)));
  const sb = new Set(contentStems(strip(b)));
  if (sa.size === 0 || sb.size === 0) return false;
  let inter = 0;
  for (const x of sa) if (sb.has(x)) inter++;
  return inter >= 2 && inter / Math.min(sa.size, sb.size) >= 0.5;
}

/**
 * يدمج إضافات الاستكمال فى الإجابة الأساسية دون تكرار ودون تجاوز السقوف (الأساسى أولاً دائماً:
 * الاستكمال لا يعيد ترتيب ما رآه المستخدم ولا يحذف منه شيئاً).
 */
export function mergeStructuredAddition(
  base: StructuredAnswer,
  add: StructuredAddition,
): { value: StructuredAnswer; added: { rulings: number; scenarios: number; warnings: number } } {
  const rulings = [...base.rulings];
  let addedRulings = 0;
  for (const r of add.rulings) {
    if (rulings.length >= MAX_RULINGS) break;
    if (rulings.some((x) => x.citation_index === r.citation_index && nearDuplicate(x.claim, r.claim))) continue;
    rulings.push(r);
    addedRulings++;
  }
  const scenarios = [...(base.scenarios ?? [])];
  let addedScenarios = 0;
  for (const sc of add.scenarios) {
    if (scenarios.length >= MAX_SCENARIOS) break;
    if (
      scenarios.some(
        (x) =>
          (x.condition === sc.condition && x.outcome === sc.outcome) ||
          (x.citation_index === sc.citation_index && nearDuplicate(`${x.condition} ${x.outcome}`, `${sc.condition} ${sc.outcome}`)),
      )
    ) {
      continue;
    }
    scenarios.push(sc);
    addedScenarios++;
  }
  const warnings = [...base.warnings];
  let addedWarnings = 0;
  for (const w of add.warnings) {
    if (warnings.length >= MAX_WARNINGS) break;
    if (warnings.some((x) => sameWarning(x, w))) continue;
    warnings.push(w);
    addedWarnings++;
  }
  return {
    value: { ...base, rulings, scenarios, warnings },
    added: { rulings: addedRulings, scenarios: addedScenarios, warnings: addedWarnings },
  };
}

/** كل النصوص الحرة فى الإجابة (بدون المقتطفات الحرفية) — تُمرَّر لبوابة هلوسة أرقام المواد. */
export function collectProseForGate(s: StructuredAnswer): string {
  return [
    s.direct_answer,
    ...(s.facts_applied ?? []).flatMap((x) => [x.fact, x.effect]),
    ...s.rulings.map((r) => r.claim),
    ...(s.scenarios ?? []).flatMap((x) => [x.condition, x.outcome]),
    ...s.open_issues,
    ...s.warnings,
    ...s.facts_to_confirm,
    ...s.not_covered,
  ].join('\n');
}

export interface RenderCitationMeta {
  law: string;
  lawNo: number;
  lawYear: number;
  articleNo: number;
  sourceStatus: SourceStatusLabel;
}

/**
 * عرض نصى بسيط للإجابة المنظَّمة — هو ما يُخزَّن فى answers.answer ويظهر فى
 * سجل الأسئلة وفى أى عميل لا يعرف الحقل structured. لا يُضيف أى محتوى جديد،
 * فقط يعيد ترتيب الحقول بأقسام واضحة.
 */
export function renderStructuredAsText(
  s: StructuredAnswer,
  cites: readonly RenderCitationMeta[],
  platformWarnings: readonly string[] = [],
): string {
  const parts: string[] = [];
  parts.push(`الجواب المباشر:\n${s.direct_answer}`);
  const applied = s.facts_applied ?? [];
  if (applied.length > 0) {
    parts.push(
      `تطبيق على وقائعك (ما ذكرتَه فى إجاباتك):\n${applied
        .map((x) => {
          const c = x.citation_index === null ? undefined : cites[x.citation_index];
          return `- ${x.fact} ← ${x.effect}${c ? ` (المادة ${c.articleNo})` : ''}`;
        })
        .join('\n')}`,
    );
  }
  const scenarios = s.scenarios ?? [];
  if (scenarios.length > 0) {
    parts.push(
      `تطبيق على حالتك (بحسب الوقائع):\n${scenarios
        .map((x) => {
          const c = cites[x.citation_index];
          return `- إذا ${x.condition}: ${x.outcome}${c ? ` (المادة ${c.articleNo})` : ''}`;
        })
        .join('\n')}`,
    );
  }
  const warnings = [...platformWarnings, ...s.warnings];
  if (warnings.length > 0) {
    parts.push(`تنبيهات:\n${warnings.map((w) => `- ${w}`).join('\n')}`);
  }
  if (s.open_issues.length > 0) {
    parts.push(`مسائل مفتوحة (غير محسومة):\n${s.open_issues.map((w) => `- ${w}`).join('\n')}`);
  }
  if (s.facts_to_confirm.length > 0) {
    parts.push(`وقائع يلزم تأكيدها لدقة الإجابة:\n${s.facts_to_confirm.map((w) => `- ${w}`).join('\n')}`);
  }
  const rulings = s.rulings.map((r, i) => {
    const c = cites[r.citation_index];
    const basis = c
      ? `المادة ${c.articleNo} من ${c.law} (رقم ${c.lawNo} لسنة ${c.lawYear}) — ${c.sourceStatus}`
      : '';
    return `${i + 1}. ${r.claim} [${r.kind}]${basis ? `\n   السند: ${basis}` : ''}`;
  });
  parts.push(`الأحكام وسندها:\n${rulings.join('\n')}`);
  if (s.not_covered.length > 0) {
    parts.push(`أجزاء من السؤال لا تجيب عنها النصوص المتاحة:\n${s.not_covered.map((w) => `- ${w}`).join('\n')}`);
  }
  return parts.join('\n\n');
}

/**
 * تحذيرات حتمية من حالة المصادر (لا من النموذج): أى مصدر غير "ساري" يُنبَّه
 * عليه صراحة فى أول التحذيرات.
 */
export function buildStatusWarnings(cites: readonly RenderCitationMeta[]): string[] {
  const out: string[] = [];
  for (const c of cites) {
    const label = `المادة ${c.articleNo} من ${c.law} (رقم ${c.lawNo} لسنة ${c.lawYear})`;
    if (c.sourceStatus === 'ملغى') {
      out.push(`${label} مُسجَّلة عندنا كملغاة — لا تُعتمَد أحكامها دون التحقق من القانون الحالى.`);
    } else if (c.sourceStatus === 'معدّل') {
      out.push(`${label} معدَّلة — تحقق من النص الحالى المعدَّل قبل الاعتماد.`);
    } else if (c.sourceStatus === 'غير محسوم') {
      out.push(`حالة سريان ${label} غير محسومة فى قاعدتنا — تحقق من سريانها قبل الاعتماد.`);
    }
  }
  return out;
}

/**
 * أرقام المواد المرفقة التى أحالت إليها صراحةً مادة مرفقة *أخرى* (مثل 87 و88 المُحال
 * إليهما فى نص المادة 154). تُمرَّر للنموذج كتوجيه («افحص صلة كل منها بوصف الواقعة») وتُسجَّل
 * مع ما لم يُستَند إليه منها فى أى حكم أو سيناريو لقياس التغطية حياً. لا تُفرَض قسراً لأن الصلة
 * بسؤال بعينه حكم قانونى لا يُحسَم حتمياً.
 */
export function referencedProvidedArticles(
  articles: ReadonlyArray<{ articleNo: number; text: string }>,
): number[] {
  const provided = new Set(articles.map((a) => a.articleNo));
  const out = new Set<number>();
  for (const a of articles) {
    for (const n of detectCrossReferencedArticles(a.text, a.articleNo)) {
      if (provided.has(n)) out.add(n);
    }
  }
  return [...out].sort((x, y) => x - y);
}

/**
 * يحوّل إجابة منظَّمة محقَّقة إلى الصيغة الخام نفسها التى يُنتجها النموذج (source = رقم النص 1..N)،
 * ليُعرَض مسودةً فى نداء المراجعة/التصحيح فيعدّلها النموذج بدل أن يبدأ من الصفر. نقية ولا تُسرِّب
 * أى حقل خاص بالعرض (quote_verified وحالة المصدر).
 */
export function toRawSchema(s: StructuredAnswer): Record<string, unknown> {
  return {
    ...((s.facts_applied ?? []).length > 0
      ? {
          facts_applied: (s.facts_applied ?? []).map((x) => ({
            fact: x.fact,
            effect: x.effect,
            source: x.citation_index === null ? null : x.citation_index + 1,
          })),
        }
      : {}),
    direct_answer: s.direct_answer,
    rulings: s.rulings.map((r) => ({
      claim: r.claim,
      kind: r.kind,
      source: r.citation_index + 1,
      quote: r.quote ?? '',
    })),
    scenarios: (s.scenarios ?? []).map((x) => ({
      condition: x.condition,
      outcome: x.outcome,
      source: x.citation_index + 1,
    })),
    open_issues: s.open_issues,
    warnings: s.warnings,
    facts_to_confirm: s.facts_to_confirm,
    not_covered: s.not_covered,
  };
}
