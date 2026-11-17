import { ORDINALS } from '../clause-headings';
import { normalizeArabicForMatch } from '../reasoning.util';

const ARABIC_INDIC = /[٠-٩]/g;
const EXT_INDIC = /[۰-۹]/g;

/** أرقام عربية/فارسية هندية → لاتينية. */
export function toLatinDigits(s: string): string {
  return (s ?? '').replace(ARABIC_INDIC, (d) => String(d.charCodeAt(0) - 0x0660)).replace(EXT_INDIC, (d) => String(d.charCodeAt(0) - 0x06f0));
}

/** توحيد عربى + أرقام لاتينية للمطابقة فقط. */
export function norm(s: string | null | undefined): string {
  return normalizeArabicForMatch(toLatinDigits(s ?? ''));
}

const ORDINAL_SPELLINGS: Array<{ n: number; s: string }> = ORDINALS.flatMap(([n, spellings]) => spellings.map((s) => ({ n, s: norm(s) })))
  .filter((x, i, a) => a.findIndex((y) => y.s === x.s) === i)
  .sort((a, b) => b.s.length - a.s.length);

/** رقم البند من تسميته: «البند 5» / «المادة (12)» / «البند الحادى عشر»؛ null إن لم يُعثر. */
export function labelNumber(label: string | null | undefined): number | null {
  const t = norm(label);
  if (!t) return null;
  const d = /(?:^| )(\d{1,3})(?: |$)/.exec(t);
  if (d) return Number(d[1]);
  const padded = ` ${t} `;
  for (const o of ORDINAL_SPELLINGS) {
    if (padded.includes(` ${o.s} `)) return o.n;
  }
  return null;
}

export function asNumbers(v: number | number[] | undefined): number[] {
  if (v === undefined) return [];
  return (Array.isArray(v) ? v : [v]).filter((n) => Number.isFinite(n));
}

/** هل يظهر أى من الكلمات (بعد التوحيد) فى النص الموحَّد؟ قائمة فارغة = لا شرط. */
export function hasAnyKeyword(haystackNorm: string, keywords: string[] | undefined): boolean {
  if (!keywords || keywords.length === 0) return true;
  return keywords.some((k) => {
    const n = norm(k);
    return n.length > 0 && haystackNorm.includes(n);
  });
}

/**
 * هل الاقتباس موجود حرفياً (بعد التوحيد) فى النص؟ يقبل اقتباساً مقتطعاً بـ«…» أو «...» فى طرفه أو وسطه:
 * كل مقطع (≥ 6 أحرف بعد التوحيد) يجب أن يوجد فى النص. اقتباس أقصر من ذلك كله لا يُقبل (لا دليل).
 */
export function quoteFoundIn(quote: string, ...texts: string[]): boolean {
  const segments = quote
    .split(/…|\.{3,}/)
    .map((s) => norm(s))
    .filter((s) => s.length > 0);
  if (segments.length === 0 || segments.every((s) => s.length < 6)) return false;
  const hay = texts.map((t) => norm(t));
  return segments.filter((s) => s.length >= 6).every((s) => hay.some((h) => h.includes(s)));
}

/** مبلغ يظهر فى نص (يطابق الأرقام بعد إزالة الفواصل العربية واللاتينية والمسافات بين الآلاف). */
export function amountInText(amount: number, text: string): boolean {
  const clean = toLatinDigits(text).replace(/[,٬،]/g, '').replace(/(\d) (?=\d{3}(?!\d))/g, '$1');
  const nums = clean.match(/\d+(?:\.\d+)?/g) ?? [];
  return nums.some((n) => Number(n) === amount);
}
