/**
 * رموز مشوَّهة ناتجة عن القراءة الآلية (OCR) لعقد ممسوح ضوئياً: حروف لاتينية قصيرة (1–3 أحرف) تقع بين كلمات عربية
 * (مثل «WL» بعد «الطرف الأول» أو «S S (W» وسط جملة عربية). هى فى الغالب ختم أو شخبطة أو شعار قُرئ خطأً، لا نص تعاقدى.
 * لا تُحذف من الأصل (يُعرَض كما قُرئ ويُنبَّه إليه)، ولا تُنقل إلى صياغة مقترحة (تُستبدل بفراغ ظاهر ليراجعه الإنسان).
 */
const ARABIC = '\\u0621-\\u064A';
// حرف لاتينى قصير معزول، وأحد جاريه (السابق أو اللاحق، متخطياً المسافات والأقواس) حرف عربى.
const PREV_ARABIC = new RegExp(`[${ARABIC}][\\s().,،:;\\-]*$`);
const NEXT_ARABIC = new RegExp(`^[\\s().,،:;\\-]*[${ARABIC}]`);
const SHORT_LATIN = /(?<![A-Za-z0-9])[A-Za-z]{1,3}(?![A-Za-z0-9])/g;

import { normalizeArabicForMatch } from './reasoning.util';

export const OCR_NOISE_PLACEHOLDER = '[____]';

function isNoiseAt(text: string, start: number, end: number): boolean {
  return PREV_ARABIC.test(text.slice(0, start)) || NEXT_ARABIC.test(text.slice(end));
}

/** الرموز المشوَّهة المرجَّحة فى نص بند (بلا تكرار، بترتيب الظهور). */
export function findOcrNoiseTokens(text: string): string[] {
  const found: string[] = [];
  for (const m of (text ?? '').matchAll(SHORT_LATIN)) {
    const i = m.index ?? 0;
    if (isNoiseAt(text, i, i + m[0].length) && !found.includes(m[0])) found.push(m[0]);
  }
  return found;
}

/**
 * يستبدل فى صياغة مقترحة كل رمز مشوَّه ورد فى البند الأصلى بفراغ ظاهر، ويُرجع الرموز المُستبدَلة.
 * لا يمس رمزاً غير موجود فى الأصل (فلا يُعاقَب نص ولّده النموذج نفسه).
 */
export function neutralizeOcrNoise(proposed: string, original: string): { text: string; replaced: string[] } {
  const noise = new Set(findOcrNoiseTokens(original));
  if (noise.size === 0) return { text: proposed, replaced: [] };
  const replaced: string[] = [];
  let out = '';
  let last = 0;
  for (const m of proposed.matchAll(SHORT_LATIN)) {
    const i = m.index ?? 0;
    if (!noise.has(m[0]) || !isNoiseAt(proposed, i, i + m[0].length)) continue;
    out += proposed.slice(last, i) + OCR_NOISE_PLACEHOLDER;
    last = i + m[0].length;
    if (!replaced.includes(m[0])) replaced.push(m[0]);
  }
  out += proposed.slice(last);
  return { text: out, replaced };
}

export const OCR_NOISE_NOTE = (tokens: string[]): string =>
  `نص هذا البند مقروء آلياً ويحوى رموزاً مشوَّهة (${tokens.map((t) => `«${t}»`).join('، ')}) فى الأرجح ختم أو شخبطة؛ تحقق منه من النسخة الموقَّعة قبل أى اعتماد.`;

/**
 * الجولة 105.5: أرقام عربية-هندية قُرئت حروفاً لاتينية. قياس الجولة 105.4 على الإنتاج: نص بند فيه «VYY» و«V» و«Vo» (الأرجح ٧٢٢ و٧ و٧٥) وملاحظته عن نسب النصاب
 * (ثلاثة أرباع/نصف/ربع) صارت «مؤكدة» بتأكيد 2 من 3 من المدقق. الرمز الذى يشبه رقماً (V=٧، Y=٢، A=٨، o=٥، T=٣، S=٥) ويقع بجوار كلمة عربية مرجَّح أنه رقم تالف.
 * لا يُحذف شىء من الأصل؛ تُستخدم فقط لمنع وسم الملاحظة المبنية على الأرقام «مؤكدة».
 */
const DIGIT_LOOKALIKE = /(?<![A-Za-z0-9])[VYAoOTS]{1,5}(?![A-Za-z0-9])/g;

/** اختصارات لاتينية حقيقية تتألف حروفها من حروف الأرقام الشبيهة فلا تُعدّ أرقاماً تالفة */
const REAL_LATIN_ACRONYMS = new Set(['VAT', 'SAS']);

export function findGarbledDigitTokens(text: string): string[] {
  const found: string[] = [];
  for (const m of (text ?? '').matchAll(DIGIT_LOOKALIKE)) {
    const i = m.index ?? 0;
    if (REAL_LATIN_ACRONYMS.has(m[0])) continue;
    if (isNoiseAt(text, i, i + m[0].length) && !found.includes(m[0])) found.push(m[0]);
  }
  return found;
}

/** جمل البند (يفصلها . ؛ ; وسطر جديد). */
export function splitSentences(text: string): string[] {
  return (text ?? '')
    .split(/[.؛;\n]+/)
    .map((x) => x.trim())
    .filter((x) => x.length > 0);
}

// كلام عن مقدار: نسبة مئوية، كسر (ثلاثة أرباع/نصف/ربع/ثلث)، أغلبية/نصاب. لا يشمل أرقام المواد ولا سنوات القوانين.
const QUANTITY_TALK = /%|٪|نسب[هة]|ثلاث[هة]?\s+ارباع|نصف|ربع|ثلث|اغلبي[هة]|نصاب/;

export function hasQuantityTalk(text: string): boolean {
  return QUANTITY_TALK.test(normalizeArabicForMatch(text)) || /%|٪/.test(text ?? '');
}

/** الرموز المشوَّهة الشبيهة بالأرقام فى جمل البند التى تتكلم عن مقدار/نسبة/نصاب (وحدها، لا فى بقية البند). */
export function garbledDigitsInQuantitySentences(clauseText: string): string[] {
  const out: string[] = [];
  for (const sentence of splitSentences(clauseText)) {
    if (!hasQuantityTalk(sentence)) continue;
    for (const t of findGarbledDigitTokens(sentence)) if (!out.includes(t)) out.push(t);
  }
  return out;
}

/**
 * الجملة التى ورد فيها الاقتباس من نص البند (لا البند كله)، ليُفحص عيب القراءة فى موضع الاقتباس نفسه.
 * إن لم يوجد الاقتباس حرفياً فى النص (إعادة صياغة) يرجع نص البند كله (السلوك المحافظ السابق).
 */
export function focusOfQuote(clauseText: string, quote: string): string {
  const flat = (x: string) => (x ?? '').replace(/\s+/g, ' ').trim();
  const q = flat(quote).replace(/^[«"“\s]+|[»"”\s.…]+$/g, '');
  if (q.length < 6) return clauseText ?? '';
  const probe = q.slice(0, 30);
  const hit = splitSentences(clauseText).filter((s) => flat(s).includes(probe) || (flat(s).length >= 12 && q.includes(flat(s).slice(0, 30))));
  return hit.length > 0 ? hit.join(' ') : (clauseText ?? '');
}
