import { parseArabicNumberWords } from './numeric-checks.util';

/**
 * جدول الشروط الرئيسية للعقد (الجولة 6): المبالغ والنسب والمدد والتواريخ المنصوص عليها فى البنود، مستخرجة حتمياً بأنماط
 * نصية (بلا نموذج لغوى). كل شرط يحمل اقتباساً حرفياً من نص البند (جزء متصل منه بعد توحيد المسافات)، فلا يظهر رقم لا أصل
 * له فى العقد. القراءة الآلية للعقود الممسوحة قد تُشوّه الأرقام؛ لذلك يُعرض الجدول مع تنبيه مراجعة بشرية، ولا يُبنى عليه حكم.
 */

export type KeyTermKind = 'amount' | 'percent' | 'duration' | 'date';

export const KEY_TERM_KIND_LABEL: Record<KeyTermKind, string> = {
  amount: 'مبلغ',
  percent: 'نسبة',
  duration: 'مدة',
  date: 'تاريخ',
};

export interface KeyTerm {
  kind: KeyTermKind;
  /** القيمة كما تُعرض (مثل «1,125,000 جنيه» أو «30 يوماً» أو «40%») */
  value: string;
  clauseIndex: number;
  clauseLabel: string;
  clauseTitle: string | null;
  /** جزء متصل من نص البند (مسافاته موحَّدة) يحوى الشرط */
  quote: string;
  /** هل القيمة مقروءة من أرقام (false) أم من حروف (true) */
  fromWords: boolean;
}

export interface KeyTermClause {
  clauseIndex: number;
  clauseLabel: string;
  clauseTitle: string | null;
  clauseText: string;
}

const MAX_TERMS = 60;
const MAX_QUOTE = 300;

/** أرقام عربية-هندية → لاتينية بنفس الطول (فتبقى مواضع الأحرف صالحة للاقتطاع من النص الأصلى). */
function latinDigitsSameLength(t: string): string {
  return t.replace(/[٠-٩]/g, (d) => String.fromCharCode(d.charCodeAt(0) - 0x0660 + 48)).replace(/[۰-۹]/g, (d) =>
    String.fromCharCode(d.charCodeAt(0) - 0x06f0 + 48),
  );
}

const UNIT = '(?:يوم|يوما|يوماً|ايام|أيام|اسبوع|أسبوع|اسابيع|أسابيع|شهر|شهرا|شهراً|اشهر|أشهر|شهور|سنة|سنه|سنوات|سنين|عام|اعوام|أعوام)';
const CURRENCY = '(?:جنيه|جنيها|جنيهاً|ج\\.م|دولار|دولارا|دولاراً|يورو|ريال|درهم)';

function unitLabel(unit: string, n: number): string {
  const u = unit.replace(/[أإآ]/g, 'ا');
  if (/^(?:يوم|ايام)/.test(u)) return n === 1 ? 'يوم' : n === 2 ? 'يومان' : n <= 10 ? 'أيام' : 'يوماً';
  if (/^(?:اسبوع|اسابيع)/.test(u)) return n === 1 ? 'أسبوع' : n === 2 ? 'أسبوعان' : n <= 10 ? 'أسابيع' : 'أسبوعاً';
  if (/^(?:شهر|اشهر|شهور)/.test(u)) return n === 1 ? 'شهر' : n === 2 ? 'شهران' : n <= 10 ? 'أشهر' : 'شهراً';
  return n === 1 ? 'سنة' : n === 2 ? 'سنتان' : n <= 10 ? 'سنوات' : 'سنة';
}

function fmtNumber(n: number): string {
  return n.toLocaleString('en-US', { maximumFractionDigits: 2 });
}

/** الجملة التى تحوى الموضع، أو نافذة حولها إن طالت (جزء متصل من الأصل دائماً). */
function quoteAround(text: string, pos: number, len: number): string {
  const isStop = (ch: string) => ch === '.' || ch === '؟' || ch === '!' || ch === '؛' || ch === '\n';
  let start = pos;
  while (start > 0 && !isStop(text[start - 1])) start -= 1;
  let end = pos + len;
  while (end < text.length && !isStop(text[end])) end += 1;
  if (end < text.length && text[end] !== '\n') end += 1; // يشمل علامة الوقف
  let slice = text.slice(start, end);
  if (slice.replace(/\s+/g, ' ').trim().length > MAX_QUOTE) {
    const from = Math.max(start, pos - 140);
    const to = Math.min(end, pos + len + 160);
    slice = text.slice(from, to);
    // لا نقطع كلمة من طرفيها
    const firstSpace = from > start ? slice.search(/\s/) : 0;
    if (firstSpace > 0) slice = slice.slice(firstSpace);
    const lastSpace = to < end ? slice.search(/\s\S*$/) : -1;
    if (lastSpace > 0) slice = slice.slice(0, lastSpace);
  }
  return slice.replace(/\s+/g, ' ').trim();
}

/** يحاول قراءة عدد مكتوب بالحروف من آخر 1–3 كلمات قبل الموضع (الأطول أولاً). */
function wordsBefore(text: string, end: number): { value: number; start: number } | null {
  const head = text.slice(Math.max(0, end - 80), end);
  const tokens = [...head.matchAll(/[ء-ي]+/g)];
  for (let take = Math.min(4, tokens.length); take >= 1; take -= 1) {
    const slice = tokens.slice(tokens.length - take);
    const phrase = slice.map((m) => m[0]).join(' ');
    const v = parseArabicNumberWords(phrase);
    if (v !== null && v > 0) {
      const firstIdx = slice[0].index ?? 0;
      return { value: v, start: Math.max(0, end - 80) + firstIdx };
    }
  }
  return null;
}

interface Hit {
  kind: KeyTermKind;
  value: string;
  pos: number;
  len: number;
  fromWords: boolean;
}

function scan(rawText: string): Hit[] {
  const text = latinDigitsSameLength(rawText);
  const hits: Hit[] = [];

  // مبالغ بالأرقام: 1125000 جنيه / 25,000 دولار / 5000 (خمسة آلاف) جنيه
  // الرقم ثم (اختيارياً) الحروف بين قوسين، ثم العملة؛ والعملة قد تقع داخل القوسين: 600000 ( ستمائة ألف جنيه مصرى فقط )
  const amountDigits = new RegExp(`(\\d[\\d,٬]*(?:\\.\\d+)?)\\s*(?:([(（][^()（）\\n]{0,100}[)）])\\s*)?(${CURRENCY})?`, 'gu');
  const amountSpans: Array<[number, number]> = [];
  for (const m of text.matchAll(amountDigits)) {
    const curMatch = m[3] ?? (m[2] ? m[2].match(new RegExp(CURRENCY, 'u'))?.[0] : undefined);
    if (!curMatch) continue;
    const n = Number(m[1].replace(/[,٬]/g, ''));
    if (!Number.isFinite(n) || n <= 0) continue;
    const cur = /دولار/.test(curMatch) ? 'دولار' : /يورو/.test(curMatch) ? 'يورو' : /ريال/.test(curMatch) ? 'ريال' : /درهم/.test(curMatch) ? 'درهم' : 'جنيه';
    hits.push({ kind: 'amount', value: `${fmtNumber(n)} ${cur}`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
    amountSpans.push([m.index ?? 0, (m.index ?? 0) + m[0].length]);
  }
  // مبالغ بالحروف فقط: "مبلغ ... خمسون ألف جنيه"
  const currencyOnly = new RegExp(`(${CURRENCY})`, 'gu');
  for (const m of text.matchAll(currencyOnly)) {
    const pos = m.index ?? 0;
    if (amountSpans.some(([a, b]) => pos >= a && pos <= b)) continue;
    const w = wordsBefore(text, pos);
    if (!w || w.value < 100) continue;
    const cur = /دولار/.test(m[0]) ? 'دولار' : /يورو/.test(m[0]) ? 'يورو' : /ريال/.test(m[0]) ? 'ريال' : /درهم/.test(m[0]) ? 'درهم' : 'جنيه';
    hits.push({ kind: 'amount', value: `${fmtNumber(w.value)} ${cur}`, pos: w.start, len: pos + m[0].length - w.start, fromWords: true });
  }

  // نسب
  const percent = /(\d+(?:[.,]\d+)?)\s*(?:%|٪|بالمائة|بالمئة|فى المائة|في المائة|فى المئة|في المئة)/gu;
  for (const m of text.matchAll(percent)) {
    const n = Number(m[1].replace(',', '.'));
    if (!Number.isFinite(n) || n <= 0 || n > 1000) continue;
    hits.push({ kind: 'percent', value: `${fmtNumber(n)}%`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
  }

  // مدد بالأرقام: 30 يوماً / 12 (اثنا عشر) شهراً
  const durDigits = new RegExp(`(?<![\\d/.\\-])(\\d{1,4})\\s*(?:[(（][^()（）\\n]{0,40}[)）]\\s*)?(${UNIT})(?![ء-ي])`, 'gu');
  const durSpans: Array<[number, number]> = [];
  for (const m of text.matchAll(durDigits)) {
    const n = Number(m[1]);
    if (!Number.isFinite(n) || n <= 0) continue;
    hits.push({ kind: 'duration', value: `${n} ${unitLabel(m[2], n)}`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
    durSpans.push([m.index ?? 0, (m.index ?? 0) + m[0].length]);
  }
  // مدد بالحروف: ثلاثة أشهر / ستون يوماً
  const unitOnly = new RegExp(`(?<![ء-ي])(${UNIT})(?![ء-ي])`, 'gu');
  for (const m of text.matchAll(unitOnly)) {
    const pos = m.index ?? 0;
    if (durSpans.some(([a, b]) => pos >= a && pos <= b)) continue;
    const w = wordsBefore(text, pos);
    if (!w || w.value > 1000) continue;
    hits.push({ kind: 'duration', value: `${w.value} ${unitLabel(m[1], w.value)}`, pos: w.start, len: pos + m[0].length - w.start, fromWords: true });
  }

  // تواريخ: 15/3/2026 أو 2026-03-15
  const dateDmy = /(?<![\d/.\-])(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{4})(?![\d/])/gu;
  for (const m of text.matchAll(dateDmy)) {
    const d = Number(m[1]);
    const mo = Number(m[2]);
    if (d < 1 || d > 31 || mo < 1 || mo > 12) continue;
    hits.push({ kind: 'date', value: `${m[1]}/${m[2]}/${m[3]}`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
  }
  const dateYmd = /(?<![\d/.\-])(\d{4})[/\-.](\d{1,2})[/\-.](\d{1,2})(?![\d/])/gu;
  for (const m of text.matchAll(dateYmd)) {
    const mo = Number(m[2]);
    const d = Number(m[3]);
    if (d < 1 || d > 31 || mo < 1 || mo > 12) continue;
    hits.push({ kind: 'date', value: `${m[3]}/${m[2]}/${m[1]}`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
  }

  return hits.sort((a, b) => a.pos - b.pos);
}

/** الشروط الرئيسية لكل البنود بترتيب ورودها، بلا تكرار، بحد أقصى. */
export function extractKeyTerms(clauses: KeyTermClause[]): KeyTerm[] {
  const out: KeyTerm[] = [];
  const seen = new Set<string>();
  const ordered = [...clauses].sort((a, b) => a.clauseIndex - b.clauseIndex);
  for (const c of ordered) {
    for (const h of scan(c.clauseText ?? '')) {
      const quote = quoteAround(c.clauseText, h.pos, h.len);
      const key = `${c.clauseIndex}|${h.kind}|${h.value}|${quote}`;
      if (seen.has(key)) continue;
      seen.add(key);
      out.push({
        kind: h.kind,
        value: h.value,
        clauseIndex: c.clauseIndex,
        clauseLabel: c.clauseLabel,
        clauseTitle: c.clauseTitle,
        quote,
        fromWords: h.fromWords,
      });
      if (out.length >= MAX_TERMS) return out;
    }
  }
  return out;
}
