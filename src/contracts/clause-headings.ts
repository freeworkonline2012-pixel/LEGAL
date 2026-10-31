/**
 * عناوين بنود العقود المصرية ("البند + ترتيبى بالكلمات") — ثوابت وأنماط مشتركة بين التقسيم
 * (segmentation.service.ts) وفحص جودة القراءة الآلية (documents/ocr.service.ts)، فلا يختلف تعريف
 * "عنوان بند" بين الموضعين. ملف نقى بلا أى اعتماد على Nest أو قاعدة البيانات.
 */

export type Ordinal = readonly [number, readonly string[]];

export const ORDINALS: readonly Ordinal[] = [
  [1, ['الأول', 'الاول']],
  [2, ['الثاني', 'الثانى', 'الثان']], // "الثان" تهجئة ناقصة شائعة فى القراءة الآلية (OCR) لنهاية الياء
  [3, ['الثالث']],
  [4, ['الرابع']],
  [5, ['الخامس']],
  [6, ['السادس']],
  [7, ['السابع']],
  [8, ['الثامن']],
  [9, ['التاسع']],
  [10, ['العاشر']],
  [11, ['الحادي عشر', 'الحادى عشر']],
  [12, ['الثاني عشر', 'الثانى عشر']],
  [13, ['الثالث عشر']],
  [14, ['الرابع عشر']],
  [15, ['الخامس عشر']],
  [16, ['السادس عشر']],
  [17, ['السابع عشر']],
  [18, ['الثامن عشر']],
  [19, ['التاسع عشر']],
  [20, ['العشرون']],
  [21, ['الحادي والعشرون', 'الحادى والعشرون']],
  [22, ['الثاني والعشرون', 'الثانى والعشرون']],
  [23, ['الثالث والعشرون']],
  [24, ['الرابع والعشرون']],
  [25, ['الخامس والعشرون']],
  [26, ['السادس والعشرون']],
  [27, ['السابع والعشرون']],
  [28, ['الثامن والعشرون']],
  [29, ['التاسع والعشرون']],
  [30, ['الثلاثون']],
];

// فاصل الكلمات داخل الترتيبى: مسافة/سطر جديد، أو شرطة سفلية/تطويل تُنتجها القراءة الآلية ("الحادى_عشر").
export const SEP = '[\\s_\\u0640]';

// الأطول أولاً (حروفاً بعد استبدال المسافات بـ\s+) — يمنع التقاط "العاشر"
// كتطابق جزئى خاطئ داخل "الحادى عشر" لو رُتبت الأقصر أولاً.
export const ALTERNATIVES = ORDINALS.flatMap(([num, spellings]) => spellings.map((s) => ({ num, s })))
  .sort((a, b) => b.s.length - a.s.length)
  .map((x) => x.s.replace(/ /g, SEP + '+'));

// (?![ء-ي]) يمنع التقاط تهجئة ناقصة كجزء من كلمة أطول. (?<pre>…) حرف شاذ واحد قبل "البند" (ختم/شخبطة
// تقرؤها القراءة الآلية مثل "ش البند الثان,")؛ لا يُقبل إلا إن كان باقى السطر قصيراً (عنوان لا جملة إحالة).
export const CLAUSE_RE = new RegExp(
  `^[ \\t]*(?<pre>[^\\s\\d:.،,\\-][ \\t]+)?البند${SEP}*(?<ord>${ALTERNATIVES.join('|')})(?![\\u0621-\\u064A])\\s*[:.]?`,
  'gmu',
);
export const MAX_REST_AFTER_NOISE_PREFIX = 30;
// سطر لا يحوى إلا الترتيبى ("الثانى"): القراءة الآلية تُسقط أحياناً كلمة "البند" من العنوان. لا يُقبل إلا
// إن كان رقمه هو التالى مباشرة للبند السابق (تسلسل حتمى) وبلا عنوان كامل تالٍ بنفس الرقم.
export const BARE_RE = new RegExp(`^[ \\t]*(?<ord>${ALTERNATIVES.join('|')})(?![\\u0621-\\u064A])[ \\t]*$`, 'gmu');


// إحالة نصية إلى بند فى أى موضع من السطر ("وفقاً للبند السادس عشر") — لا تُستعمل حداً فاصلاً أبداً، بل لفحص اكتمال التقسيم فقط.
export const REFERENCE_RE = new RegExp(
  `(?:[وفبك]?ال|[وف]?لل)بند${SEP}+(?<ord>${ALTERNATIVES.join('|')})(?![\\u0621-\\u064A])`,
  'gmu',
);

export function ordinalToNumber(spelling: string): number | null {
  const normalized = spelling.replace(/[\s_\u0640]+/g, ' ').trim();
  const found = ORDINALS.find(([, spellings]) =>
    spellings.some((s) => s.replace(/\s+/g, ' ') === normalized),
  );
  return found ? found[0] : null;
}

const INVISIBLE = /[\u200e\u200f\u202a-\u202e\u2066-\u2069\ufeff]/g;

/** أرقام عناوين البنود المتميزة فى نص مقروء (عنوان كامل "البند الثانى" أو الترتيبى وحده فى سطر). */
export function headingNumbers(text: string): number[] {
  const clean = (text ?? '').replace(INVISIBLE, '');
  const nums = new Set<number>();
  for (const re of [CLAUSE_RE, BARE_RE]) {
    for (const m of clean.matchAll(re)) {
      const n = ordinalToNumber(m.groups?.ord ?? '');
      if (n !== null) nums.add(n);
    }
  }
  return [...nums].sort((a, b) => a - b);
}

/** عدد عناوين البنود المتميزة؛ يُستعمل لاختيار الأوفى من قراءتين لنفس الصفحة (العناوين المسطَّرة تسقط عشوائياً). */
export function countHeadingLines(text: string): number {
  return headingNumbers(text).length;
}

/** أرقام البنود الناقصة بين 1 وأعلى رقم مقروء (فجوة فى التسلسل = عنوان أسقطته القراءة الآلية)؛ فارغة إن لم يُقرأ أى عنوان. */
export function missingHeadingNumbers(text: string): number[] {
  const nums = headingNumbers(text);
  if (nums.length === 0) return [];
  const have = new Set(nums);
  const out: number[] = [];
  for (let n = 1; n <= nums[nums.length - 1]; n++) if (!have.has(n)) out.push(n);
  return out;
}

/** إن كان السطر عنوان بند قصيراً ("البند الثالث" وحده تقريباً) يُرجع رقمه، وإلا null. لا يلتقط جملة إحالة داخل متن. */
export function headingLineNumber(line: string): number | null {
  const clean = (line ?? '').replace(INVISIBLE, '').trim();
  if (clean.length === 0 || clean.length > 40) return null;
  for (const m of clean.matchAll(CLAUSE_RE)) {
    if (clean.slice((m.index ?? 0) + m[0].length).trim().length <= MAX_REST_AFTER_NOISE_PREFIX) {
      return ordinalToNumber(m.groups?.ord ?? '');
    }
  }
  for (const m of clean.matchAll(BARE_RE)) return ordinalToNumber(m.groups?.ord ?? '');
  return null;
}

const LOOSE_RE = new RegExp(`بند${SEP}+(?<ord>${ALTERNATIVES.join('|')})(?![\\u0621-\\u064A])`, 'u');

/**
 * قراءة متساهلة لسطر قصير منفرد من قراءة متناثرة: "البند الثالث" فى أى موضع من سطر لا يتجاوز 40 حرفاً (حتى لو سبقته رموز
 * أختام/توقيعات أو شوّهت القراءة "ال" فى أوله). لا تُستعمل إلا على أسطر القراءة المتناثرة ولأرقام ناقصة فعلاً.
 */
export function looseHeadingLineNumber(line: string): number | null {
  const clean = (line ?? '').replace(INVISIBLE, '').trim();
  if (clean.length === 0 || clean.length > 40) return null;
  const strict = headingLineNumber(clean);
  if (strict !== null) return strict;
  const m = clean.match(LOOSE_RE);
  // الجزء المطابق يجب أن يكون معظم السطر (عنوان منفرد لا جملة إحالة قصيرة مثل «طبقاً للبند الثالث من العقد»)
  if (!m || m[0].length + 2 < clean.length * 0.6) return null;
  return ordinalToNumber(m.groups?.ord ?? '');
}

/** عنوان قياسى لرقم بند ("البند الثالث") يُدرج بدل السطر المشوَّه ليُقسَّم سليماً. */
export function canonicalHeading(n: number): string | null {
  const spelling = ORDINALS.find(([num]) => num === n)?.[1][0];
  return spelling ? `البند ${spelling}` : null;
}

/** كلمات ترتيبية لأرقام ناقصة، لتشخيص ما قرأته الأداة حولها دون تسجيل أى نص آخر من العقد. */
export function ordinalWords(numbers: readonly number[]): string[] {
  return numbers.flatMap((n) => ORDINALS.find(([num]) => num === n)?.[1] ?? []);
}
