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
