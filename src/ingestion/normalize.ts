/**
 * تطبيع عربي نقي (pure functions) — يُستخدم في خط التجميع والبحث.
 * يطابق سلوك دالة arabic_normalize في SQL (001_init.sql) قدر الإمكان.
 */

/** توحيد الهمزات/الألف/التاء المربوطة/الألف المقصورة */
export function normalizeArabic(input: string): string {
  return input
    .trim()
    .toLowerCase()
    .replace(/[أإآ]/g, 'ا')
    .replace(/ى/g, 'ي')
    .replace(/ة/g, 'ه')
    .replace(/ؤ/g, 'و')
    .replace(/ئ/g, 'ي');
}

const ARABIC_INDIC = '٠١٢٣٤٥٦٧٨٩';
const PERSIAN_INDIC = '۰۱۲۳۴۵۶۷۸۹';

/** تحويل الأرقام العربية/الفارسية إلى أرقام لاتينية */
export function toEnglishDigits(input: string): string {
  return input
    .replace(/[٠-٩]/g, (d) => String(ARABIC_INDIC.indexOf(d)))
    .replace(/[۰-۹]/g, (d) => String(PERSIAN_INDIC.indexOf(d)));
}

/** مفتاح فريد لمادة داخل قانون — أساس إزالة التكرار */
export function articleKey(lawId: string, articleNo: number): string {
  return `${lawId}:${articleNo}`;
}

/** تطبيع نص قبل التخزين: إزالة المسافات المتكررة وتوحيد الأحرف */
export function cleanText(input: string): string {
  return normalizeArabic(input).replace(/\s+/g, ' ').trim();
}
