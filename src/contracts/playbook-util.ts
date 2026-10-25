import { extractKeyTerms } from './key-terms';
import { normalizeArabicForMatch } from './reasoning.util';

/**
 * أدوات الدليل التفاوضى (الجولة 7): توحيد النص للمطابقة وقراءة المدد والنسب من جملة واحدة.
 * المطابقة على النص الموحَّد (بلا همزات/تاء مربوطة/ألف مقصورة)، والاقتباس يؤخذ من النص الأصلى.
 */

function toLatinDigits(t: string): string {
  return t.replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660)).replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06f0));
}

/** نص موحَّد للمطابقة، الأرقام العربية-الهندية لاتينية. */
export const norm = (t: string): string => normalizeArabicForMatch(toLatinDigits(t));

const DAY_FACTORS: Array<[RegExp, number]> = [
  [/^(?:يوم|ايام|أيام)/, 1],
  [/^(?:اسبوع|أسبوع|اسابيع|أسابيع)/, 7],
  [/^(?:شهر|اشهر|أشهر|شهور)/, 30],
  [/^(?:سنة|سنه|سنوات|سنتان|سنتين|سنين|عام|اعوام|أعوام)/, 365],
];

/** «30 يوماً» / «3 سنوات» → عدد الأيام التقريبى (شهر = 30، سنة = 365)؛ غير ذلك null. */
export function durationDays(value: string): number | null {
  const m = /^(\d+)\s+(\S+)/.exec(value.trim());
  if (!m) return null;
  const unit = m[2];
  for (const [re, f] of DAY_FACTORS) if (re.test(unit)) return Number(m[1]) * f;
  return null;
}

function termsOf(sentence: string) {
  return extractKeyTerms([{ clauseIndex: 0, clauseLabel: '', clauseTitle: null, clauseText: sentence }]);
}

/** كل المدد المذكورة فى الجملة بالأيام (الأرقام أو الحروف). */
export function daysIn(sentence: string): number[] {
  return termsOf(sentence)
    .filter((t) => t.kind === 'duration')
    .map((t) => durationDays(t.value))
    .filter((n): n is number => n !== null);
}

/** كل النسب المئوية المذكورة فى الجملة. */
export function percentsIn(sentence: string): number[] {
  return termsOf(sentence)
    .filter((t) => t.kind === 'percent')
    .map((t) => Number.parseFloat(t.value))
    .filter((n) => Number.isFinite(n));
}

/** «12 ساعة» أو «اثنتا عشرة ساعة» غير مدعومة بالحروف: الأرقام فقط، لأن الغرض فحص حد قانونى صريح. */
export function hoursIn(sentenceNorm: string, unit: 'day' | 'week'): number[] {
  const per = unit === 'day' ? '(?:في اليوم|يوميا|في اليوم الواحد|كل يوم)' : '(?:في الاسبوع|اسبوعيا|كل اسبوع)';
  const out: number[] = [];
  const re = new RegExp(`(\\d{1,3})\\s*ساع(?:ه|ات)?\\s*(?:عمل\\s*)?(?:فعليه\\s*)?${per}`, 'g');
  for (const m of sentenceNorm.matchAll(re)) out.push(Number(m[1]));
  return out;
}
