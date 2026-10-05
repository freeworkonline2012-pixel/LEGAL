import { normalizeArabic, toEnglishDigits } from '../ingestion/normalize';

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

export interface StructuredAnswer {
  direct_answer: string;
  rulings: StructuredRuling[];
  open_issues: string[];
  warnings: string[];
  facts_to_confirm: string[];
  not_covered: string[];
}

export interface StructuredArticleMeta {
  /** نص المادة المرفق فعلياً للنموذج (للتحقق الحرفى من المقتطفات). */
  text: string;
}

/** إحصاءات تشخيصية للتسجيل فقط (لا تُعرَض للمستخدم). */
export interface ParseStats {
  /** عدد الأحكام التى طلب النموذج وسمها "نص". */
  requested_text: number;
  /** منها ما خُفِّض إلى "تفسير" لعدم ثبوت المقتطف الحرفى. */
  downgraded: number;
  /** أحكام أُسقطت لمصدر غير صالح. */
  dropped: number;
}

export type ParseStructuredResult =
  | { ok: true; value: StructuredAnswer; stats: ParseStats }
  | { ok: false; reason: string };

export const MAX_RULINGS = 8;
export const MAX_LIST_ITEMS = 8;
/** إيجاز العرض: حدود أضيق لقوائم التحذيرات والوقائع (المسائل المفتوحة تبقى حتى MAX_LIST_ITEMS). */
export const MAX_WARNINGS = 4;
export const MAX_FACTS = 5;
export const MAX_FIELD_CHARS = 700;
export const MAX_QUOTE_WORDS = 40;

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

/** تطبيع للمقارنة الحرفية: أرقام لاتينية، توحيد الهمزات، حذف التشكيل والتطويل وعلامات الترقيم. */
export function normalizeForQuote(input: string): string {
  return normalizeArabic(toEnglishDigits(input))
    .replace(/[ً-ْـ‎‏‪-‮]/g, '')
    .replace(/[^\p{L}\p{N}\s]/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim();
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

function cleanStr(v: unknown, max = MAX_FIELD_CHARS): string {
  if (typeof v !== 'string') return '';
  const s = v.replace(/\s+/g, ' ').trim();
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
 * يحوّل مخرَج النموذج (نص JSON) إلى StructuredAnswer نظيف ومُتحقَّق منه.
 * الأرقام فى rulings[].source تبدأ من 1 (كما تُرقَّم النصوص فى الـprompt) وتُحوَّل
 * هنا إلى citation_index يبدأ من صفر. أى حكم يشير لنص غير موجود يُسقَط (لا
 * يُخمَّن) — وإن سقطت كل الأحكام تُرفَض البنية كلياً.
 */
export function parseStructuredAnswer(
  raw: string,
  articles: readonly StructuredArticleMeta[],
): ParseStructuredResult {
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
  const rawRulings = Array.isArray(obj.rulings) ? obj.rulings : [];
  const rulings: StructuredRuling[] = [];
  const stats: ParseStats = { requested_text: 0, downgraded: 0, dropped: 0 };
  for (const r of rawRulings) {
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
    let quote: string | null = cleanStr(rr.quote, 500) || null;
    if (quote && quote.split(/\s+/).length > MAX_QUOTE_WORDS) {
      quote = null; // مقتطف طويل جداً = نسخ لا استشهاد؛ لا يُعرَض
    }
    const verified = quote ? verifyQuote(quote, articles[idx].text) : false;
    const requested = cleanStr(rr.kind, 20);
    // نص إلا إذا ثبت المقتطف الحرفى؛ أى شىء آخر (أو وسم غير معروف) = تفسير.
    const kind: RulingKind = requested === 'نص' && verified ? 'نص' : 'تفسير';
    if (requested === 'نص') {
      stats.requested_text++;
      if (kind !== 'نص') stats.downgraded++;
    }
    rulings.push({
      claim,
      kind,
      citation_index: idx,
      quote: verified ? quote : null,
      quote_verified: verified,
    });
    if (rulings.length >= MAX_RULINGS) break;
  }
  if (rulings.length === 0) {
    return { ok: false, reason: 'no_valid_rulings' };
  }
  return {
    ok: true,
    value: {
      direct_answer: direct,
      rulings,
      open_issues: cleanList(obj.open_issues),
      warnings: cleanList(obj.warnings, MAX_WARNINGS),
      facts_to_confirm: cleanList(obj.facts_to_confirm, MAX_FACTS),
      not_covered: cleanList(obj.not_covered),
    },
    stats,
  };
}

/** كل النصوص الحرة فى الإجابة (بدون المقتطفات الحرفية) — تُمرَّر لبوابة هلوسة أرقام المواد. */
export function collectProseForGate(s: StructuredAnswer): string {
  return [
    s.direct_answer,
    ...s.rulings.map((r) => r.claim),
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
