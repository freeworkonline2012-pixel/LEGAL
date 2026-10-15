/**
 * فحوص حتمية لجودة كل وحدة مترجمة — لا تعتمد على النموذج: الأرقام والمبالغ والتواريخ هى أخطر ما يُفسد عقداً مترجماً.
 * ما يفشل فحصاً يُعاد ترجمته مرة واحدة بتنبيه محدد، وإن بقى فاشلاً يُوسم للمراجعة البشرية (لا يُخفى أبداً).
 */
import type { ContractLang } from './language-detect';

export type UnitFlag = 'numbers_mismatch' | 'length_anomaly' | 'untranslated_text' | 'empty_translation';

const ARABIC_INDIC = /[٠-٩]/g;
const EXT_ARABIC_INDIC = /[۰-۹]/g;

export function normalizeDigits(text: string): string {
  return text
    .replace(ARABIC_INDIC, (d) => String(d.charCodeAt(0) - 0x0660))
    .replace(EXT_ARABIC_INDIC, (d) => String(d.charCodeAt(0) - 0x06f0));
}

/** الأعداد المذكورة بالأرقام (بعد توحيد الأرقام وحذف فواصل الآلاف والأصفار البادئة). */
export function extractNumbers(text: string): string[] {
  const t = normalizeDigits(text)
    .replace(/(?<=\d)[,٬،](?=\d{3}(?!\d))/g, '')
    .replace(/٫/g, '.');
  const nums = t.match(/\d+(?:\.\d+)?/g) ?? [];
  return nums.map((n) => n.replace(/^0+(?=\d)/, ''));
}

/** كل رقم فى الأصل يجب أن يرد فى الترجمة (الزيادة مقبولة: «عشرة (10)» تُترجم «ten (10)»). */
export function missingNumbers(source: string, translation: string): string[] {
  const inTranslation = new Set(extractNumbers(translation));
  return [...new Set(extractNumbers(source))].filter((n) => !inTranslation.has(n));
}

function wordCount(text: string): number {
  return (text.match(/[\p{L}\p{N}]+/gu) ?? []).length;
}

/** نطاق نسبة (كلمات الترجمة/كلمات الأصل) المعقول لكل اتجاه؛ خارجه = احتمال حذف أو حشو. */
const RATIO_RANGE: Record<`${ContractLang}-${ContractLang}`, [number, number]> = {
  'ar-en': [0.7, 2.3],
  'en-ar': [0.4, 1.4],
  'ar-ar': [0, Infinity],
  'en-en': [0, Infinity],
};

const MIN_WORDS_FOR_RATIO = 6;

export function lengthAnomaly(source: string, translation: string, from: ContractLang, to: ContractLang): boolean {
  const s = wordCount(source);
  if (s < MIN_WORDS_FOR_RATIO) return false;
  const [lo, hi] = RATIO_RANGE[`${from}-${to}`];
  const ratio = wordCount(translation) / s;
  return ratio < lo || ratio > hi;
}

/** بقاء نص كثير بلغة الأصل داخل الترجمة (يُستثنى القصير والأسماء بين أقواس). */
export function looksUntranslated(translation: string, to: ContractLang): boolean {
  const body = translation.replace(/\([^)]*\)|\[[^\]]*\]/g, ' ');
  const arabic = (body.match(/[؀-ۿ]/g) ?? []).length;
  const latin = (body.match(/[A-Za-z]/g) ?? []).length;
  const total = arabic + latin;
  if (total < 12) return false;
  if (to === 'en') return arabic / total > 0.25;
  return latin / total > 0.45;
}

export function checkUnit(source: string, translation: string, from: ContractLang, to: ContractLang): UnitFlag[] {
  const flags: UnitFlag[] = [];
  if (translation.trim().length === 0) return ['empty_translation'];
  if (missingNumbers(source, translation).length > 0) flags.push('numbers_mismatch');
  if (lengthAnomaly(source, translation, from, to)) flags.push('length_anomaly');
  if (looksUntranslated(translation, to)) flags.push('untranslated_text');
  return flags;
}

export const FLAG_MESSAGES_AR: Record<UnitFlag, string> = {
  numbers_mismatch: 'أرقام أو مبالغ أو تواريخ الأصل لا تطابق الترجمة — راجعها',
  length_anomaly: 'طول الترجمة غير معتاد قياساً بالأصل (احتمال حذف أو إضافة) — راجعها',
  untranslated_text: 'بقى جزء من النص دون ترجمة — راجعه',
  empty_translation: 'لم تُنتَج ترجمة لهذه الفقرة — ترجمها يدوياً',
};
