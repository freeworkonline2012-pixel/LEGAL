import { normalizeArabic, toEnglishDigits } from '../ingestion/normalize';

/**
 * فحوص حتمية (بلا I/O ولا نموذج لغوى) لتأصيل الإجابة المنظَّمة فى نص المواد المرفقة
 * (2026-10-08 — من تقييم حى 7/10 لإجابة سؤال تجديد العقد محدد المدة):
 *
 *  1) تحذير قال إن الأجر ومقابل الإجازة «يسقطان» ونسب ذلك للمادة 108، بينما نص 108
 *     يقرر ميعاد وفاء (سبعة أيام من المطالبة) لا ميعاد سقوط. سببه أن فلتر «يذكر رقم
 *     مادة» السابق يتحقق من وجود الرقم لا من أن المادة تقول ما نُسب إليها. الحل هنا:
 *     أى أثر قانونى شديد (سقوط/تقادم/بطلان/حرمان/فقدان) أو مقدار (عدد + وحدة زمنية)
 *     يرد فى حكم أو تحذير أو سيناريو يجب أن يرد فى نص المادة المستند إليها نفسه، وإلا
 *     يُسقَط البند. الفحص على الألفاظ الحاملة للحكم لا على المعنى، فهو لا يضمن
 *     صحة الاستنتاج، لكنه يمنع أخطر أنواع التلفيق (أثر أو مدة لا وجود لهما فى النص).
 *
 *  2) وسم «نص/تفسير» كان يعتمد على ادعاء النموذج + وجود مقتطف حرفى صحيح، فيمر حكم
 *     نصه أوسع من مقتطفه الظاهر (م154) موسوماً «نص». الحل: تغطية الحكم بالمقتطف
 *     تُحسَب حتمياً (نسبة كلمات الحكم المضمونية الواردة فى المقتطف)، فلا يوسم «نص» إلا
 *     ما يغطيه المقتطف فعلاً، ويُرفَع إلى «نص» ما يطابق مقتطفه عملياً.
 */

/** تطبيع للمقارنة الحرفية: أرقام لاتينية، توحيد الهمزات، حذف التشكيل والتطويل وعلامات الترقيم. */
export function normalizeForQuote(input: string): string {
  return normalizeArabic(toEnglishDigits(input))
    .replace(/[ً-ْـ‎‏‪-‮]/g, '')
    .replace(/[^\p{L}\p{N}\s]/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

// ---------------------------------------------------------------------------
// تغطية الحكم بالمقتطف
// ---------------------------------------------------------------------------

/** عتبة وسم «نص»: لا يوسم الحكم «نص» إلا إذا غطّى المقتطف هذه النسبة من كلمات الحكم المضمونية. */
export const TEXT_COVERAGE_MIN = 0.7;
/** عتبة رفع حكم وسمه النموذج «تفسير» إلى «نص»: حكم يكاد يطابق مقتطفه الموثَّق. */
export const TEXT_UPGRADE_COVERAGE_MIN = 0.9;

/** كلمات وظيفية لا تحمل مضموناً (مُطبَّعة). النفى (لا/لم/لن/غير/دون/بلا) يبقى عمداً: فقدانه يقلب المعنى. */
const STOPWORDS = new Set([
  'من', 'في', 'علي', 'الي', 'عن', 'او', 'ان', 'اذا', 'اذ', 'ما', 'قد', 'كل', 'هذا', 'هذه', 'ذلك', 'تلك',
  'التي', 'الذي', 'الذين', 'اللذين', 'بين', 'مع', 'حتي', 'ثم', 'بعد', 'قبل', 'عند', 'حيث', 'كما', 'لكن',
  'بل', 'هو', 'هي', 'هم', 'هن', 'كان', 'يكون', 'تكون', 'كانت', 'ايضا', 'لدي', 'له', 'لها', 'لهم', 'به',
  'بها', 'بهم', 'فيه', 'فيها', 'منه', 'منها', 'عليه', 'عليها', 'اليه', 'اليها', 'بان', 'لان', 'اي', 'وفق',
  'وفقا', 'طبقا', 'الا', 'هل', 'ذات', 'نفس', 'ايه',
]);
const KEEP_SHORT = new Set(['لا', 'لم', 'لن']);

/** تجذيع خفيف متماثل على الطرفين (حكم ومقتطف) — يكفى للمقارنة النسبية لا للّغويات. */
function stem(token: string): string {
  let s = token;
  if (s.length > 4 && (s[0] === 'و' || s[0] === 'ف')) s = s.slice(1);
  if (s.length > 5 && (s.startsWith('بال') || s.startsWith('كال') || s.startsWith('فال'))) s = s.slice(3);
  else if (s.length > 4 && (s.startsWith('لل') || s.startsWith('ال'))) s = s.slice(2);
  else if (s.length > 4 && (s[0] === 'ب' || s[0] === 'ل' || s[0] === 'ك')) s = s.slice(1);
  if (s.length > 5 && /(?:ها|هم|هن|كم|نا)$/.test(s)) s = s.slice(0, -2);
  if (s.length > 4 && /(?:ون|ين|ان|ات)$/.test(s)) s = s.slice(0, -2);
  if (s.length > 3 && /[هي]$/.test(s)) s = s.slice(0, -1);
  return s;
}

/** جذور الكلمات المضمونية فى نص (بلا مكرر): بلا وظيفية، مع إبقاء النفى والأرقام. */
export function contentStems(text: string): string[] {
  const out = new Set<string>();
  for (const raw of normalizeForQuote(text).split(' ')) {
    if (!raw) continue;
    if (STOPWORDS.has(raw)) continue;
    if (raw.length < 3 && !KEEP_SHORT.has(raw) && !/^\d+$/.test(raw)) continue;
    out.add(stem(raw));
  }
  return [...out];
}

/** نسبة (0..1) من كلمات الحكم المضمونية التى يحتويها المقتطف. حكم بلا كلمات مضمونية = 0. */
export function claimCoverage(claim: string, quote: string): number {
  const claimStems = contentStems(claim);
  if (claimStems.length === 0) return 0;
  const quoteStems = new Set(contentStems(quote));
  let hit = 0;
  for (const s of claimStems) if (quoteStems.has(s)) hit++;
  return hit / claimStems.length;
}

// ---------------------------------------------------------------------------
// الألفاظ الحاملة للحكم: أثر شديد + مقدار
// ---------------------------------------------------------------------------

const EFFECT_FAMILIES: ReadonlyArray<{ key: string; stems: readonly string[] }> = [
  { key: 'سقوط', stems: ['سقط', 'سقوط', 'اسقاط'] },
  { key: 'تقادم', stems: ['تقادم'] },
  { key: 'بطلان', stems: ['بطل', 'باطل', 'ابطال'] },
  { key: 'حرمان', stems: ['حرم'] },
  { key: 'فقدان', stems: ['فقد', 'ضياع', 'يضيع', 'تضيع', 'ضاع'] },
];

const NUM_WORDS: Readonly<Record<string, number>> = {
  واحد: 1, واحده: 1, اثنين: 2, اثنان: 2, اثني: 2, اثنتين: 2,
  ثلاث: 3, ثلاثه: 3, اربع: 4, اربعه: 4, خمس: 5, خمسه: 5, ست: 6, سته: 6,
  سبع: 7, سبعه: 7, ثمان: 8, ثماني: 8, ثمانيه: 8, تسع: 9, تسعه: 9, عشر: 10, عشره: 10,
  عشرين: 20, ثلاثين: 30, اربعين: 40, خمسين: 50, ستين: 60, سبعين: 70, ثمانين: 80, تسعين: 90,
  مائه: 100, مئه: 100,
};

const UNITS: Readonly<Record<string, string>> = {
  يوم: 'يوم', يوما: 'يوم', ايام: 'يوم',
  اسبوع: 'اسبوع', اسابيع: 'اسبوع',
  شهر: 'شهر', شهرا: 'شهر', اشهر: 'شهر', شهور: 'شهر',
  سنه: 'سنه', سنوات: 'سنه', سنين: 'سنه', عام: 'سنه', اعوام: 'سنه',
  ساعه: 'ساعه', ساعات: 'ساعه',
};

const DUALS: Readonly<Record<string, readonly [number, string]>> = {
  يومين: [2, 'يوم'], اسبوعين: [2, 'اسبوع'], شهرين: [2, 'شهر'], سنتين: [2, 'سنه'], عامين: [2, 'سنه'],
};

export interface Quantity {
  n: number;
  unit: string;
}

function numberOf(token: string): number | undefined {
  if (/^\d+$/.test(token)) return Number.parseInt(token, 10);
  if (token in NUM_WORDS) return NUM_WORDS[token];
  if (token.length > 3 && token[0] === 'و' && token.slice(1) in NUM_WORDS) return NUM_WORDS[token.slice(1)];
  return undefined;
}

/** مقادير «عدد + وحدة زمنية» الصريحة فى نص (سبعة أيام، ثلاثة أشهر، خمس سنوات، شهرين...). */
export function extractQuantities(text: string): Quantity[] {
  const tokens = normalizeForQuote(text).split(' ').filter(Boolean);
  const out: Quantity[] = [];
  for (let i = 0; i < tokens.length; i++) {
    const t = tokens[i].length > 4 && tokens[i][0] === 'و' && !(tokens[i] in DUALS) ? tokens[i].slice(1) : tokens[i];
    if (t in DUALS) {
      const [n, unit] = DUALS[t];
      out.push({ n, unit });
      continue;
    }
    let n = numberOf(tokens[i]);
    if (n === undefined) continue;
    let j = i + 1;
    if (n >= 3 && n <= 9 && (tokens[j] === 'عشر' || tokens[j] === 'عشره')) {
      n += 10;
      j += 1;
    }
    const unit = tokens[j] ? UNITS[tokens[j]] : undefined;
    if (unit) {
      out.push({ n, unit });
      i = j;
    }
  }
  return out;
}

function effectKeys(normalized: string): string[] {
  return EFFECT_FAMILIES.filter((f) => f.stems.some((s) => normalized.includes(s))).map((f) => f.key);
}

/**
 * الألفاظ الحاملة للحكم الواردة فى `text` والغائبة عن كل نصوص `supportTexts`.
 * فارغة = كل ما تدّعيه العبارة من أثر شديد أو مقدار له أصل لفظى فى المادة المستند إليها.
 */
export function findUnsupportedTerms(
  text: string,
  supportTexts: readonly string[],
  quantitySupport = '',
): string[] {
  const norm = normalizeForQuote(text);
  const supportNorm = supportTexts.map((s) => normalizeForQuote(s)).join(' ');
  const out: string[] = [];
  const supportEffects = new Set(effectKeys(supportNorm));
  for (const k of effectKeys(norm)) {
    if (!supportEffects.has(k)) out.push(`أثر:${k}`);
  }
  // quantitySupport: وقائع السائل (من الاستيضاح) — تُقبل منها المقادير وحدها (مدة خدمته مثلاً)،
  // أما الآثار الشديدة (سقوط/بطلان...) فلا بد من أصلها فى المادة دائماً.
  const supportQty = new Set(
    extractQuantities(`${supportNorm} ${normalizeForQuote(quantitySupport)}`).map((q) => `${q.n}|${q.unit}`),
  );
  for (const q of extractQuantities(norm)) {
    if (!supportQty.has(`${q.n}|${q.unit}`)) out.push(`مقدار:${q.n} ${q.unit}`);
  }
  return out;
}

// ---------------------------------------------------------------------------
// أرقام المواد المذكورة فى عبارة حرة
// ---------------------------------------------------------------------------

/** أرقام المواد المذكورة صراحة («المادة 108» / «المواد 87 و88» / «م 125») بلا تكرار. */
export function extractArticleNumbers(text: string): number[] {
  const normalized = normalizeArabic(toEnglishDigits(text));
  const re = /(?:المواد|مواد|المادتين|مادتين|الماده|ماده|(?<![ء-ي])م(?![ء-ي]))[\s:.()]*((?:\d+\s*[،,و]?\s*)+)/g;
  const found = new Set<number>();
  for (const m of normalized.matchAll(re)) {
    for (const n of m[1].match(/\d+/g) ?? []) {
      const v = Number.parseInt(n, 10);
      if (Number.isInteger(v) && v > 0) found.add(v);
    }
  }
  return [...found];
}
