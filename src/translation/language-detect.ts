/**
 * كشف لغة العقد بالحروف لا بالتخمين: نسبة الحروف العربية إلى اللاتينية (الأرقام وعلامات الترقيم لا تُحتسب).
 * العقود المصرية تحوى كثيراً أسماء شركات لاتينية و«LLC» ونحوها، فنسمح بأقلية لغوية صغيرة؛ أما العقد الثنائى
 * اللغة (نسختان متجاورتان) فيُرفض لأن ترجمته ستكرّر نصه — ونطلب نسخة بلغة واحدة.
 */

export type ContractLang = 'ar' | 'en';

export interface LanguageDetection {
  /** اللغة السائدة أو null عند عدم كفاية الحروف */
  lang: ContractLang | null;
  arabicLetters: number;
  latinLetters: number;
  /** نسبة اللغة السائدة من مجموع الحروف (0..1) */
  dominantShare: number;
  /** ثنائى اللغة: نسبة الأقلية تتجاوز الحد المسموح */
  bilingual: boolean;
  /** أقلية ملحوظة لكن دون حد الرفض (أسماء/مصطلحات أجنبية) */
  mixedMinority: boolean;
}

/** أقلية أعلى من هذا = عقد ثنائى اللغة (يُرفض) */
export const BILINGUAL_MINORITY_LIMIT = 0.3;
/** أقلية أعلى من هذا = تنبيه فقط */
export const MINORITY_WARN_LIMIT = 0.08;
const MIN_LETTERS = 40;

const ARABIC_RE = /[؀-ۿݐ-ݿࢠ-ࣿﭐ-﷿ﹰ-ﻼ]/g;
const LATIN_RE = /[A-Za-zÀ-ɏ]/g;

export function detectLanguage(text: string): LanguageDetection {
  const arabicLetters = (text.match(ARABIC_RE) ?? []).length;
  const latinLetters = (text.match(LATIN_RE) ?? []).length;
  const total = arabicLetters + latinLetters;
  if (total < MIN_LETTERS) {
    return { lang: null, arabicLetters, latinLetters, dominantShare: 0, bilingual: false, mixedMinority: false };
  }
  const lang: ContractLang = arabicLetters >= latinLetters ? 'ar' : 'en';
  const dominant = lang === 'ar' ? arabicLetters : latinLetters;
  const minorityShare = 1 - dominant / total;
  return {
    lang,
    arabicLetters,
    latinLetters,
    dominantShare: dominant / total,
    bilingual: minorityShare > BILINGUAL_MINORITY_LIMIT,
    mixedMinority: minorityShare > MINORITY_WARN_LIMIT,
  };
}
