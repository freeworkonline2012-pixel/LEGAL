import { isGarbledNumberWord, parseArabicNumberWords, strayPrefix, strayPrefixWarning } from './numeric-checks.util';
import { normalizeArabicForMatch } from './reasoning.util';

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
  /** تنبيه إن كانت القراءة الآلية مشكوكاً فيها (مثل رمز % مقروء 96)؛ تُعرض القيمة مع التنبيه ولا تُعتمد دون مطابقة الأصل */
  suspect?: string;
  /**
   * الجولة 79: قيمة مقروءة بالأرقام من نسخة ممسوحة ضوئياً (OCR) ولم تؤيدها كتابتها بالحروف: Tesseract لا يُعتمد على قراءته للأرقام العربية-الهندية
   * (750 قُرئت 76,560 و10% قُرئت 9011 فى إنتاج عقد الأتعاب). تُعرض «غير موثَّق—قراءة آلية» ولا يتغير حساب جدول الدفعات ولا حكم أى بند.
   */
  ocrUnverified?: boolean;
  /** عدد مرات ورود الشرط نفسه فى الاقتباس نفسه (يظهر فى الجدول مرة واحدة؛ يحتاجه فحص مجموع الدفعات: 30% مرتين = دفعتان) */
  occurrences?: number;
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
const CURRENCY = '(?:جنيه|جنيها|جنيهاً|جنية|ج\\.م|جم(?![ء-ي])|دولار|دولارا|دولاراً|يورو|ريال|درهم)';

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

/**
 * الجولة 68: تاريخ فى سياق وثيقة هوية («تاريخ الإصدار 15/12/2014» لجواز سفر، «بطاقة رقم قومى … تاريخ إصدار») ليس شرطاً تعاقدياً؛ وظهر فى جدول
 * الشروط الرئيسية لعقد إيجار ممسوح مع رقم الجواز نفسه. يُفحص السياق قبل التاريخ على السطر نفسه فقط.
 */
const IDENTITY_CONTEXT = /(?:جواز\s*سفر|بطاقة|سجل\s*(?:ال)?(?:تجار[يى]|ضريب[يى])|رقم\s*قوم[يى]|الرقم\s*القوم[يى]|تاريخ\s*(?:ال)?[اإ]صدار|تاريخ\s*ال[اإ]صدار|صادر[ةه]?\s*من)/u;
function isIdentityDate(text: string, pos: number): boolean {
  const lineStart = text.lastIndexOf('\n', pos - 1) + 1;
  // السياق ما بعد آخر نهاية جملة فقط: «… تاريخ الإصدار 15/8/2015 ويقيم بالقاهرة. تبدأ المدة من 1/12/2018» تاريخها الثانى تعاقدى
  const before = text.slice(Math.max(lineStart, pos - 60), pos).replace(/^[\s\S]*[.؛!؟]/, '');
  return IDENTITY_CONTEXT.test(before);
}

/**
 * الجولة 68: أى سلسلة أرقام من 9 خانات فأكثر (رقم قومى 14 خانة، رقم شيك، رقم جواز، رقم حساب) تُقنَّع فى المقتطف المعروض بالتقرير، إلا إن تلتها عملة
 * (مبلغ حقيقى مثل 452500000 جنيه). بيانات الهوية لا مكان لها فى جدول الشروط.
 */
export function maskLongNumbers(quote: string): string {
  return quote.replace(/(?<![\d.,٫])\d{9,}(?![\d])(?!\s*(?:\([^)]{0,80}\)\s*)?(?:جنيه|جنيها|جنية|ج\.م|جم(?![ء-ي])|دولار|يورو|ريال|درهم))/gu, '[رقم مُقنَّع]');
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

/** هل الكلمة (بعد التوحيد) جزء من عدد بالحروف؟ */
function isNumberWord(token: string): boolean {
  return parseArabicNumberWords(token) !== null;
}

const FUNCTION_WORDS = new Set(['من', 'في', 'فى', 'عن', 'على', 'الى', 'إلى', 'ثم', 'او', 'أو', 'لا', 'ما', 'هو', 'هي', 'هى', 'مع', 'بل', 'قد', 'كل']);

/** ضجيج مسح ضوئى محتمل: حرف أو حرفان لا يكوّنان كلمة وظيفية معروفة ولا كلمة عددية. */
function isNoiseToken(token: string): boolean {
  return token.length <= 2 && !FUNCTION_WORDS.has(token) && !isNumberWord(token);
}

/** الفاصل المسموح بين كلمات العدد الواحد: مسافات وأقواس وشرطات فقط (لا أرقام ولا نقطة ولا فاصلة). */
const NUMBER_GAP = /^[\s()（）\-–]*$/u;

/**
 * يقرأ العدد المكتوب بالحروف الذى ينتهى قبل الموضع. يمشى للخلف كلمة كلمة: كلمة عددية تُضمّ، وحرف أو حرفان لا معنى لهما
 * (ضجيج مسح ضوئى مثل «وذ») يُتخطّيان ولا يقطعان العبارة، وأى كلمة أخرى توقف المشى. العبارة كلها تُقرأ دفعة واحدة، فلا يُخرَج
 * جزء من عدد أكبر (فشل مغلق): إن لم تُقرأ العبارة كاملة يُرجَع null.
 */
function wordsBefore(text: string, end: number): { value: number; start: number; partial: boolean } | null {
  const winStart = Math.max(0, end - 160);
  const head = text.slice(winStart, end);
  const tokens = [...head.matchAll(/[ء-ي]+/g)];
  const kept: Array<{ word: string; idx: number }> = [];
  let prevStart = head.length;
  let sawNumber = false;
  // العبارة قُطعت بفاصل غير مسموح (رقم/رموز لاتينية/سطر ضجيج) وما قبل الفاصل كلمة عددية أو ضجيج: يعنى أن العدد أكبر مما قُرئ
  // وأن ما قرأناه جزؤه الأخير فقط («اربعة ألاف سم ال ل ل 3 وخمسمائة» ← «وخمسمائة» وحدها = 500 خطأ)
  let partial = false;
  for (let i = tokens.length - 1; i >= 0; i -= 1) {
    const t = tokens[i];
    const idx = t.index ?? 0;
    const gap = head.slice(idx + t[0].length, prevStart);
    if (!NUMBER_GAP.test(gap)) {
      partial = sawNumber && (isNumberWord(t[0]) || isNoiseToken(t[0]));
      break;
    }
    if (isNumberWord(t[0])) {
      kept.unshift({ word: t[0], idx });
      sawNumber = true;
    } else if (isNoiseToken(t[0]) && sawNumber) {
      // ضجيج: نتخطاه، ولا يجوز أن تبدأ العبارة به (يُقصّ لاحقاً)
      kept.unshift({ word: '', idx });
    } else {
      // الجولة 69: «ثلاثة) او خمسمائة جنيها» — حرف العطف «أو» بعد كلمة عددية يعنى أن العبارة تبدّلت أو التُبس عددها (بدائل لا مبلغ واحد)،
      // فما بعده وحده («خمسمائة» = 500) ليس المبلغ؛ يُعامل جزءاً غير كامل لا مبلغاً مستقلاً.
      // الجولة 83: كلمة عددية تالفة («ثمائمائة») ملاصقة لبداية العبارة المقروءة («الف»): العدد المكتوب أكبر مما قُرئ ⇒ جزئى لا «1,000»
      if (sawNumber && isGarbledNumberWord(t[0])) partial = true;
      if (sawNumber && /^(?:او|أو)$/.test(t[0]) && i > 0 && isNumberWord(tokens[i - 1][0]) && NUMBER_GAP.test(head.slice((tokens[i - 1].index ?? 0) + tokens[i - 1][0].length, idx))) {
        partial = true;
      }
      break;
    }
    prevStart = idx;
  }
  while (kept.length > 0 && kept[0].word === '') kept.shift();
  if (kept.length === 0) return null;
  const v = parseArabicNumberWords(kept.map((k) => k.word).filter(Boolean).join(' '));
  if (v === null || v <= 0) return null;
  return { value: v, start: winStart + kept[0].idx, partial };
}

/**
 * بعد رقم المبلغ: هل تتبعه كتابته بالحروف ثم العملة؟ (قوس اختيارى ثم كلمات كلها عددية أو ضجيج مسح ثم العملة).
 * يُرجَع موضع نهاية العملة، وإلا null؛ فلا نلتقط مبلغاً لمجرد وجود عملة بعيدة.
 */
function amountWordsTail(text: string, from: number): { currency: string; end: number; words: number | null } | null {
  const tail = text.slice(from, from + 200);
  const m = tail.match(new RegExp(`^[\\s]*[)）(（]?[\\s]*((?:[ء-ي]+[\\s)）(（]*){1,14}?)(${CURRENCY})`, 'u'));
  if (!m) return null;
  const words = [...m[1].matchAll(/[ء-ي]+/g)].map((x) => x[0]);
  if (words.length === 0 || !words.some((w) => isNumberWord(w))) return null;
  if (!words.every((w) => isNumberWord(w) || isNoiseToken(w))) return null;
  return { currency: m[2], end: from + m[0].length, words: parseArabicNumberWords(words.filter((w) => !isNoiseToken(w)).join(' ')) };
}


const FUZZY_NUMBER_BASE: Array<[string, number]> = [
  ['واحد', 1], ['واحدة', 1], ['اثنين', 2], ['اثنان', 2], ['ثلاث', 3], ['ثلاثة', 3], ['اربع', 4], ['اربعة', 4], ['اربعه', 4], ['خمس', 5], ['خمسة', 5], ['خمسه', 5],
  ['ست', 6], ['ستة', 6], ['سته', 6], ['سبع', 7], ['سبعة', 7], ['سبعه', 7], ['ثمان', 8], ['ثمانية', 8], ['ثمانيه', 8], ['تسع', 9], ['تسعة', 9], ['تسعه', 9],
  ['عشر', 10], ['عشرة', 10], ['عشره', 10], ['ستين', 60], ['ثلاثين', 30], ['اربعين', 40], ['خمسين', 50],
];

function editDistanceAtMostOne(a: string, b: string): boolean {
  if (a === b) return true;
  if (Math.abs(a.length - b.length) > 1) return false;
  let i = 0;
  while (i < a.length && i < b.length && a[i] === b[i]) i += 1;
  if (a.length === b.length) return a.slice(i + 1) === b.slice(i + 1);
  return a.length > b.length ? a.slice(i + 1) === b.slice(i) : b.slice(i + 1) === a.slice(i);
}

/**
 * الكلمة الملاصقة للوحدة قبل أن تُقرأ عدداً: «خم سنوات». تُقبل إن كانت على بعد حرف واحد من كلمة عددية معروفة وكل ما يطابقها يعطى القيمة نفسها
 * (فلا لبس)، وبشرط ألا تكون كلمة عادية معروفة. الناتج يُعرض دائماً مع تنبيه ولا يُعتمد دون مطابقة الأصل.
 */
function fuzzyNumberBefore(text: string, unitPos: number): { value: number; start: number; token: string; canonical: string } | null {
  const head = text.slice(Math.max(0, unitPos - 24), unitPos);
  const m = /([ء-ي]{2,8})\s*$/u.exec(head);
  if (!m) return null;
  const token = m[1];
  const nt = normalizeArabicForMatch(token);
  if (isNumberWord(token) || FUNCTION_WORDS.has(nt)) return null;
  const matches = FUZZY_NUMBER_BASE.filter(([w]) => editDistanceAtMostOne(nt, w));
  if (matches.length === 0) return null;
  const values = new Set(matches.map(([, v]) => v));
  if (values.size !== 1) return null;
  return { value: matches[0][1], start: unitPos - head.length + (m.index ?? 0), token, canonical: matches[0][0] };
}

interface Hit {
  kind: KeyTermKind;
  value: string;
  pos: number;
  len: number;
  fromWords: boolean;
  suspect?: string;
  /** القيمة العددية للمبلغ (للمطابقة بين ما كُتب بالأرقام وما كُتب بالحروف) */
  amount?: number;
  /** تعارض بين رقم المبلغ وكتابته بالحروف (الرقم null إن كان تالفاً لا يُقرأ) */
  conflict?: { digits: number | null; words: number };
  /** المقروء بالحروف جزء من عدد أكبر لم يُقرأ كله (بدايته مشوّهة أو فى صفحة سابقة): لا يُعرض مبلغاً مستقلاً ولا يُقدَّم على الرقم */
  partial?: boolean;
  /** الرقم المقروء طابق كتابته بالحروف المجاورة له (قراءتان مستقلتان متفقتان) */
  wordsConfirmed?: boolean;
}

/** وصف التعارض بين رقم المبلغ وكتابته بالحروف: يُعرض مع القيمة فى الجدول وفى تنبيهات العقد. */
function conflictNote(digits: number | null, words: number): string {
  return digits === null
    ? `الرقم المقروء قبل المبلغ المكتوب بالحروف تالف (لا يُقرأ رقماً)؛ المعروض هو المكتوب بالحروف (${fmtNumber(words)}) — طابق الأصل`
    : strayPrefix(digits, words)
      ? `تعارض فى المبلغ: الرقم المقروء ${fmtNumber(digits)} يحوى المبلغ المكتوب بالحروف (${fmtNumber(words)}) مسبوقاً بأرقام زائدة، والأرجح أنها رموز دخيلة من القراءة الآلية؛ المعروض هو المكتوب بالحروف — طابق الأصل`
      : `تعارض فى المبلغ: الرقم المقروء ${fmtNumber(digits)} لا يطابق المكتوب بالحروف ${fmtNumber(words)}؛ المعروض هو المكتوب بالحروف — قد يكون خطأ قراءة آلية أو خطأ فى الأصل، فطابق الأصل`;
}

/** قبل الموضع (داخل الجملة نفسها، حتى 80 حرفاً، عبر الأسطر والضجيج) كلمة عددية تنتظر تكملة: «… ثلاث عشر». */
function precededByIncompleteNumber(text: string, pos: number): boolean {
  const head = text.slice(Math.max(0, pos - 80), pos);
  const cut = Math.max(head.lastIndexOf('.'), head.lastIndexOf('؟'), head.lastIndexOf('!'), head.lastIndexOf('؛'));
  const seg = cut >= 0 ? head.slice(cut + 1) : head;
  const tokens = [...seg.matchAll(/[ء-ي]+/g)].map((t) => t[0]);
  // آخر كلمة عربية قبل الموضع (يُتخطّى الضجيج القصير) كلمة عددية
  for (let i = tokens.length - 1; i >= 0; i -= 1) {
    if (isNoiseToken(tokens[i])) continue;
    return isNumberWord(tokens[i]);
  }
  return false;
}

/**
 * شظية «ألف وخمسمائة جنيه … )» عبر حدّ صفحة: العدد كله «ثلاث عشر ألف وخمسمائة» ورقمه 13500 مذكور قبلها، والصفحة التالية بدأت بـ«ألف …» دون مضاعفها،
 * وبينهما عادة رأس صفحة وختم وضجيج مسح أطول من نافذة الكلمات. عبارة تبدأ بـ«ألف» مجردة وأقرب مبلغ قبلها رقمى أكبر منها وفرقهما من مضاعفات الألف
 * ولا مبلغ آخر بينهما: جزء من ذلك المبلغ لا مبلغ مستقل.
 */
function continuesEarlierDigits(text: string, hits: Hit[], wordsStart: number, wordsValue: number): boolean {
  // مركّبة («ألف وخمسمائة») لا «ألف جنيه» وحدها: ألف مجردة مبلغ مشروع كثيراً ما يرد بعد مبلغ رقمى أكبر
  if (wordsValue % 1000 === 0 || !/^[اأ]لف(?![ء-ي])/u.test(text.slice(wordsStart, wordsStart + 6))) return false;
  const prev = hits.filter((h) => h.kind === 'amount' && h.pos < wordsStart).sort((a, b) => b.pos - a.pos)[0];
  return !!prev && prev.fromWords === false && prev.amount !== undefined && wordsStart - prev.pos <= 3000 && prev.amount > wordsValue && (prev.amount - wordsValue) % 1000 === 0;
}

function partialWordsNote(digits: number, words: number): string {
  return `كُتب المبلغ بالحروف أيضاً لكن قراءته الآلية مشوّهة (لم يُقرأ منه إلا ${fmtNumber(words)} فى آخره)؛ المعروض هو المقروء بالأرقام ${fmtNumber(digits)} — طابق الأصل`;
}

/**
 * يطابق المبلغ المقروء بالأرقام مع كتابته بالحروف التى تليه فى الجملة نفسها («452,500,000 جنيه مصرى سنويا ( فقط خمسمائة الف جنيه )»).
 * المتطابقان يُعرضان مرة واحدة؛ والمتعارضان (أو الرقم التالف) يُعرضان صفاً واحداً بقيمة الحروف مع تنبيه صريح، فلا يظهر رقم
 * مشوّه بلا تحذير. الاقتران لا يتم إلا إن فصلت بينهما قوسٌ أو «فقط» ولم تفصل بينهما رقم ولا علامة وقف (فشل مغلق: لا نقرن مبلغين متباعدين).
 */
function reconcileAmounts(text: string, hits: Hit[], garbled: Array<{ pos: number; end: number; amount?: number }>): Hit[] {
  const drop = new Set<Hit>();
  const replaced = new Map<Hit, Hit>();
  const digitsEnd = (h: Hit) => h.pos + h.len;
  for (const wh of hits) {
    if (wh.kind !== 'amount' || !wh.fromWords || wh.amount === undefined) continue;
    const cands: Array<{ hit?: Hit; pos: number; end: number; digitsOnly?: number }> = [
      ...hits.filter((h) => h.kind === 'amount' && !h.fromWords && h.amount !== undefined && !h.conflict && digitsEnd(h) <= wh.pos).map((h) => ({ hit: h, pos: h.pos, end: digitsEnd(h) })),
      ...garbled
        .filter((g) => g.end <= wh.pos)
        .map((g) => ({ pos: g.pos, end: g.end, ...(g.amount !== undefined ? { digitsOnly: g.amount } : {}) })),
    ].sort((a, b) => b.end - a.end);
    const d = cands[0];
    if (!d || wh.pos - d.end > 90) continue;
    const gap = text.slice(d.end, wh.pos);
    if (/[\d.؛؟!]/.test(gap) || !/[()（）]|فقط/.test(gap)) continue;
    if (hits.some((h) => h !== wh && h !== d.hit && h.kind === 'amount' && h.pos >= d.end && h.pos < wh.pos)) continue;
    if (wh.partial) {
      // المكتوب بالحروف مشوّه ولم يُقرأ منه إلا جزؤه الأخير: لا يحلّ محل الرقم ولا يُعدّ تعارضاً؛ يبقى المقروء بالأرقام مع تنبيه
      if (d.hit) replaced.set(d.hit, { ...d.hit, suspect: partialWordsNote(d.hit.amount ?? 0, wh.amount) });
      continue;
    }
    if (!d.hit) {
      // رقم تالف (لا قيمة له) أو رقم بلا عملة قرئ قبل المبلغ بالحروف: لا يُعرض بصمت، والمعروض هو المكتوب بالحروف
      if (d.digitsOnly !== undefined && d.digitsOnly === wh.amount) continue;
      const digits = d.digitsOnly ?? null;
      replaced.set(wh, { ...wh, suspect: conflictNote(digits, wh.amount), conflict: { digits, words: wh.amount } });
    } else if (d.hit.amount === wh.amount) {
      drop.add(wh);
      replaced.set(d.hit, { ...d.hit, wordsConfirmed: true });
    } else {
      drop.add(wh);
      replaced.set(d.hit, {
        kind: 'amount',
        value: wh.value,
        pos: d.pos,
        len: wh.pos + wh.len - d.pos,
        fromWords: true,
        amount: wh.amount,
        suspect: conflictNote(d.hit.amount ?? null, wh.amount),
        conflict: { digits: d.hit.amount ?? null, words: wh.amount },
      });
    }
  }
  return hits.filter((h) => !drop.has(h)).map((h) => replaced.get(h) ?? h);
}

function scan(rawText: string): Hit[] {
  const text = latinDigitsSameLength(rawText);
  const hits: Hit[] = [];

  // مبالغ بالأرقام: 1125000 جنيه / 25,000 دولار / 5000 (خمسة آلاف) جنيه
  // الرقم ثم (اختيارياً) الحروف بين قوسين، ثم العملة؛ والعملة قد تقع داخل القوسين: 600000 ( ستمائة ألف جنيه مصرى فقط )
  const amountDigits = new RegExp(`(\\d[\\d,٬]*(?:\\.\\d+)?)\\s*(?:([(（][^()（）\\n]{0,100}[)）])\\s*)?(${CURRENCY})?`, 'gu');
  const amountSpans: Array<[number, number]> = [];
  const garbledDigits: Array<{ pos: number; end: number; amount?: number }> = [];
  for (const m of text.matchAll(amountDigits)) {
    let curMatch = m[3] ?? (m[2] ? m[2].match(new RegExp(CURRENCY, 'u'))?.[0] : undefined);
    let spanEnd = (m.index ?? 0) + m[0].length;
    let n = Number(m[1].replace(/[,٬]/g, ''));
    if (!Number.isFinite(n)) continue;
    let confirmedByWords = false;
    // الجولة 83: «800 الف جنيها» / «5 ملايين جنيه»: الرقم مضروب فى مضاعفه المكتوب بعده مباشرة (800,000 و5,000,000)، لا يُقرأ «الف» وحدها كأنها كتابة المبلغ بالحروف
    if (!m[2] && !m[3]) {
      const scale = text.slice(spanEnd).match(/^[ \t]*(?:(?<th>[اأآ]لاف|[اأ]لف|الاف)|(?<mi>مليون|ملايين))(?![ء-ي])/u);
      // لا يُضرب إلا إن تلت كلمةَ المضاعف العملةُ أو نهاية العبارة (لا «وخمسمائة…» فتلك شظية عدد مركّب) ولم تسبق الرقمَ كلمةٌ عددية ناقصة
      const afterScale = scale ? text.slice(spanEnd + scale[0].length) : '';
      const closes = scale ? new RegExp(`^[ \\t]*(?:${CURRENCY}|[()（）.,،؛:\\n]|$)`, 'u').test(afterScale) : false;
      if (scale && closes && n > 0 && n < 1000 && !precededByIncompleteNumber(text, m.index ?? 0)) {
        n *= scale.groups?.mi ? 1_000_000 : 1000;
        spanEnd += scale[0].length;
        const cm = text.slice(spanEnd).match(new RegExp(`^[ \\t]*(${CURRENCY})`, 'u'));
        if (cm) {
          curMatch = cm[1];
          spanEnd += cm[0].length;
        }
      }
    }
    if (!curMatch) {
      // الرقم ثم كتابته بالحروف (قد يضيع القوس الافتتاحى فى المسح): «1125000 ) مليون ومائة … ألف جنيه»
      const tail = amountWordsTail(text, spanEnd);
      if (!tail) {
        // «452500000 مصرى سنويا ( فقط خمسمائة الف جنيها )»: ضاعت كلمة «جنيه» فبقى الرقم بلا عملة. لا يُعرض مبلغاً وحده؛ يُسجَّل
        // ليُقارَن بالمكتوب بالحروف إن وُجد بعده، وإلا يُتجاهل (فشل مغلق).
        if (n > 0 && /^\s*مصر[يى](?![ء-ي])/u.test(text.slice(spanEnd, spanEnd + 12))) {
          garbledDigits.push({ pos: m.index ?? 0, end: spanEnd, amount: n });
        }
        continue;
      }
      if (tail.words !== null && tail.words >= 100 && n < 100) {
        // «( 1 خمسمائة الف جنيها )»: الرقم الصغير ضجيج مسح (بقايا «فقط» أو القوس) لا مبلغ؛ المبلغ هو المكتوب بالحروف وحده.
        // استثناء: قبل الرقم الصغير كلمة عددية لم يكتمل عددها («اربعة آلاف سم ال ل ل 3 وخمسمائة جنيه» أو «ثلاث عشر ‹سطر ضجيج› 2 الف
        // وخمسمائة جنيه» بعد حدّ صفحة): ما بعد الرقم ذيل مبلغ أكبر لا مبلغ مستقل (4,500 لا 500؛ 13,500 لا 1,500).
        const wordsStart = (m.index ?? 0) + m[0].length + (text.slice((m.index ?? 0) + m[0].length).match(/^\s*/)?.[0].length ?? 0);
        if (precededByIncompleteNumber(text, m.index ?? 0) || continuesEarlierDigits(text, hits, wordsStart, tail.words)) {
          hits.push({
            kind: 'amount',
            value: `${fmtNumber(tail.words)} جنيه`,
            pos: m.index ?? 0,
            len: tail.end - (m.index ?? 0),
            fromWords: true,
            amount: tail.words,
            partial: true,
          });
          amountSpans.push([m.index ?? 0, tail.end]);
          continue;
        }
        hits.push({
          kind: 'amount',
          value: `${fmtNumber(tail.words)} ${/دولار/.test(tail.currency) ? 'دولار' : /يورو/.test(tail.currency) ? 'يورو' : /ريال/.test(tail.currency) ? 'ريال' : /درهم/.test(tail.currency) ? 'درهم' : 'جنيه'}`,
          pos: m.index ?? 0,
          len: tail.end - (m.index ?? 0),
          fromWords: true,
          amount: tail.words,
        });
        amountSpans.push([m.index ?? 0, tail.end]);
        continue;
      }
      curMatch = tail.currency;
      spanEnd = tail.end;
      if (tail.words !== null && tail.words === n) confirmedByWords = true;
      if (tail.words !== null && tail.words >= 100 && tail.words !== n) {
        const cur0 = /دولار/.test(curMatch) ? 'دولار' : /يورو/.test(curMatch) ? 'يورو' : /ريال/.test(curMatch) ? 'ريال' : /درهم/.test(curMatch) ? 'درهم' : 'جنيه';
        hits.push({
          kind: 'amount',
          value: `${fmtNumber(tail.words)} ${cur0}`,
          pos: m.index ?? 0,
          len: spanEnd - (m.index ?? 0),
          fromWords: true,
          amount: tail.words,
          suspect: conflictNote(n, tail.words),
          conflict: { digits: n, words: tail.words },
        });
        amountSpans.push([m.index ?? 0, spanEnd]);
        continue;
      }
    }
    if (n <= 0) {
      // «0 جنيه ( خمسمائة ألف جنيه )»: الرقم تالف فى القراءة؛ نسجّله ليُنبَّه على المبلغ المكتوب بالحروف الذى يليه
      garbledDigits.push({ pos: m.index ?? 0, end: spanEnd });
      continue;
    }
    const cur = /دولار/.test(curMatch) ? 'دولار' : /يورو/.test(curMatch) ? 'يورو' : /ريال/.test(curMatch) ? 'ريال' : /درهم/.test(curMatch) ? 'درهم' : 'جنيه';
    const hit: Hit = { kind: 'amount', value: `${fmtNumber(n)} ${cur}`, pos: m.index ?? 0, len: spanEnd - (m.index ?? 0), fromWords: false, amount: n };
    if (m[2]) {
      // الحروف بين قوسين بعد الرقم مباشرة: إن فهمناها كلها وخالفت الرقم نُنبّه (وإلا نتجاهل: فشل مغلق)
      const w = parseArabicNumberWords(m[2].replace(/[()（）]/g, ' '));
      if (w !== null && w >= 100 && w !== n) {
        hit.suspect = conflictNote(n, w);
        hit.conflict = { digits: n, words: w };
      } else if (w !== null && w === n) {
        confirmedByWords = true;
      }
    }
    if (confirmedByWords && !hit.suspect) hit.wordsConfirmed = true;
    hits.push(hit);
    amountSpans.push([m.index ?? 0, spanEnd]);
  }
  // مبالغ بالحروف فقط: "مبلغ ... خمسون ألف جنيه"
  const currencyOnly = new RegExp(`(${CURRENCY})`, 'gu');
  for (const m of text.matchAll(currencyOnly)) {
    const pos = m.index ?? 0;
    if (amountSpans.some(([a, b]) => pos >= a && pos <= b)) continue;
    const w = wordsBefore(text, pos);
    if (!w || w.value < 100) continue;
    const cur = /دولار/.test(m[0]) ? 'دولار' : /يورو/.test(m[0]) ? 'يورو' : /ريال/.test(m[0]) ? 'ريال' : /درهم/.test(m[0]) ? 'درهم' : 'جنيه';
    const splitFromDigits = continuesEarlierDigits(text, hits, w.start, w.value);
    hits.push({ kind: 'amount', value: `${fmtNumber(w.value)} ${cur}`, pos: w.start, len: pos + m[0].length - w.start, fromWords: true, amount: w.value, ...(w.partial || splitFromDigits ? { partial: true } : {}) });
  }

  // نسب
  const percent = /(\d+(?:[.,]\d+)?)\s*(?:%|٪|بالمائة|بالمئة|فى المائة|في المائة|فى المئة|في المئة)/gu;
  for (const m of text.matchAll(percent)) {
    const n = Number(m[1].replace(',', '.'));
    if (!Number.isFinite(n) || n <= 0 || n > 1000) continue;
    hits.push({ kind: 'percent', value: `${fmtNumber(n)}%`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
  }

  // نسب مشكوك فيها بسبب المسح الضوئى: الرمز % يُقرأ أحياناً «96» («15 96 سنويا» أو «قيمتها 9640»). لا نُسقط الشرط
  // ولا نعتمده بصمت: يُعرض بالقيمة المرجَّحة مع تنبيه صريح، والاقتباس حرفى فيرى القارئ ما فى النص المقروء.
  const ocrPct1 = /(?<![\d.,/])(\d{1,3})\s+96(?![\d%٪])(?=\s*(?:سنوي|شهري|اسبوعي|أسبوعي|من\s|عن\s|تسدد|تدفع|يدفع|عند|مقابل|بحد))/gu;
  for (const m of text.matchAll(ocrPct1)) {
    const n = Number(m[1]);
    if (n < 1 || n > 100) continue;
    hits.push({
      kind: 'percent',
      value: `${fmtNumber(n)}%`,
      pos: m.index ?? 0,
      len: m[0].length,
      fromWords: false,
      suspect: `النص المقروء «${m[1]} 96»؛ يُرجَّح أن الرمز % قُرئ آلياً «96» — طابق الأصل`,
    });
  }
  // «بواقع 965» / «قيمتها 9640»: الرمز % يُقرأ «90» أو «96» ملتصقاً بالرقم. النسبة لا تبلغ تسعمائة، فالبادئة هى الرمز.
  const ocrPct2 = /(?<![\d.,/])(?:قيمتها|قيمتهما|نسبتها|بنسبة|وقدرها|وقدره|بواقع|نسبة)\s*(9[06])(\d{1,2})(?![\d%٪])(?!\s*(?:ج\.?م|جنيه|جنية|دولار|يورو|ريال|درهم))/gu;
  // «حصة ... 9030 من اجمالى المحفظة» / «عن 9030 بحد اقصى»: الرقم الملتصق بالرمز ثم «من إجمالى» أو «بحد أقصى» نسبة بلا شك.
  const ocrPct3 = /(?<![\d.,/])(9[06])(\d{2})(?![\d%٪])(?=\s+(?:من\s+)?[اإأ]جمالى|\s+بحد\s+[اأ]قصى)/gu;
  for (const re of [ocrPct2, ocrPct3]) {
    for (const m of text.matchAll(re)) {
      const n = Number(m[2]);
      const pos = m.index ?? 0;
      if (n < 1 || n > 99) continue;
      if (hits.some((h) => h.kind === 'percent' && h.pos < pos + m[0].length && pos < h.pos + h.len)) continue;
      hits.push({
        kind: 'percent',
        value: `${fmtNumber(n)}%`,
        pos,
        len: m[0].length,
        fromWords: false,
        suspect: `النص المقروء «${m[1]}${m[2]}»؛ يُرجَّح أن الرمز % قُرئ آلياً «${m[1]}» — طابق الأصل`,
      });
    }
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
    if (!w) {
      // كلمة العدد مشوّهة فى المسح («خم سنوات» بدل «خمس سنوات»): تُقبل بتصحيح حرف واحد إن أعطت عدداً واحداً لا لبس فيه، مع تنبيه صريح
      const fz = fuzzyNumberBefore(text, pos);
      if (!fz) continue;
      hits.push({
        kind: 'duration',
        value: `${fz.value} ${unitLabel(m[1], fz.value)}`,
        pos: fz.start,
        len: pos + m[0].length - fz.start,
        fromWords: true,
        suspect: `كلمة العدد قُرئت مشوّهة («${fz.token}») ورُجّح أنها «${fz.canonical}» — طابق الأصل`,
      });
      continue;
    }
    if (w.value > 1000 || w.partial) continue;
    hits.push({ kind: 'duration', value: `${w.value} ${unitLabel(m[1], w.value)}`, pos: w.start, len: pos + m[0].length - w.start, fromWords: true });
  }

  // مدة وحدتها غير مقروءة: «بمدة ثلاثين ‎lags‏ .» — الصورة قُرئت لاتينية («يوماً» ← lags). لا نُسقط الشرط بصمت: يُعرض العدد
  // مع تنبيه أن الوحدة (يوم/شهر/سنة) لم تُقرأ، ولا نخمّنها.
  const durGarbled = /(?<![ء-ي])(?:[بل]?مدة|خلال)\s*(?:(\d{1,4})|((?:[ء-ي]+\s+){0,5}?[ء-ي]+))\s*[\u200e\u200f]*\s*[A-Za-z]{2,12}(?![A-Za-z])/gu;
  for (const m of text.matchAll(durGarbled)) {
    const pos = m.index ?? 0;
    if (durSpans.some(([a, b]) => pos < b && a < pos + m[0].length)) continue;
    const n = m[1] ? Number(m[1]) : parseArabicNumberWords(m[2]);
    if (n === null || !Number.isFinite(n) || n <= 0 || n > 1000) continue;
    hits.push({
      kind: 'duration',
      value: `${n} (وحدة المدة غير مقروءة)`,
      pos,
      len: m[0].length,
      fromWords: !m[1],
      suspect: 'وحدة المدة (يوم / شهر / سنة) لم تُقرأ من الصورة؛ الثابت هو العدد فقط — طابق الأصل',
    });
  }

  // مدة بلا وحدة أصلاً: «بمدة ثلاثين ».» — ضاعت كلمة الوحدة كلها فى المسح (قرأها الإنتاج رمز اقتباس). نفس المعاملة: العدد مع التنبيه.
  const durNoUnit = /(?<![ء-ي])(?:[بل]?مدة|خلال)\s*(?:(\d{1,4})|((?:[ء-ي]+\s+){0,5}?[ء-ي]+))\s*[\u200e\u200f]*\s*(?=[»«"'‘’“”.،,؛:؟!)\]]|$)/gmu;
  for (const m of text.matchAll(durNoUnit)) {
    const pos = m.index ?? 0;
    if (hits.some((h) => h.kind === 'duration' && pos < h.pos + h.len && h.pos < pos + m[0].length)) continue;
    const n = m[1] ? Number(m[1]) : parseArabicNumberWords(m[2]);
    if (n === null || !Number.isFinite(n) || n <= 0 || n > 1000) continue;
    hits.push({
      kind: 'duration',
      value: `${n} (وحدة المدة غير مقروءة)`,
      pos,
      len: m[0].length,
      fromWords: !m[1],
      suspect: 'وحدة المدة (يوم / شهر / سنة) لم تُقرأ من الصورة؛ الثابت هو العدد فقط — طابق الأصل',
    });
  }

  // تواريخ: 15/3/2026 أو 2026-03-15
  const dateDmy = /(?<![\d/.\-])(\d{1,2})\s*[/\-.]\s*(\d{1,2})\s*[/\-.]\s*(\d{4})(?![\d/])/gu;
  for (const m of text.matchAll(dateDmy)) {
    const d = Number(m[1]);
    const mo = Number(m[2]);
    if (d < 1 || d > 31 || mo < 1 || mo > 12) continue;
    if (isIdentityDate(text, m.index ?? 0)) continue;
    hits.push({ kind: 'date', value: `${m[1]}/${m[2]}/${m[3]}`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
  }
  const dateYmd = /(?<![\d/.\-])(\d{4})[/\-.](\d{1,2})[/\-.](\d{1,2})(?![\d/])/gu;
  for (const m of text.matchAll(dateYmd)) {
    const mo = Number(m[2]);
    const d = Number(m[3]);
    if (d < 1 || d > 31 || mo < 1 || mo > 12) continue;
    if (isIdentityDate(text, m.index ?? 0)) continue;
    hits.push({ kind: 'date', value: `${m[3]}/${m[2]}/${m[1]}`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
  }

  const reconciled = reconcileAmounts(text, hits, garbledDigits).sort((a, b) => a.pos - b.pos);
  corroborateByArithmetic(reconciled);
  return reconciled;
}

/**
 * الجولة 68: مبلغ مكتوب بالحروف سبقه رقم تالف (يُوسم «يلزم التحقق») وله علاقة حسابية صحيحة بمبلغ آخر فى العقد (الدفعة الربع سنوية = 3 × الأجرة الشهرية:
 * 41,250 = 3 × 13,750 وقد أيّدهما شيكان فى الأصل) لا يبقى موسوماً: قراءتان مستقلتان بحروف مختلفة تتفقان حسابياً. التطابق التام بنسبة 2 أو 3 أو 4 أو 6 أو 12 فقط.
 */
function corroborateByArithmetic(hits: Hit[], pool: Hit[] = hits): void {
  const RATIOS = [2, 3, 4, 6, 12];
  for (const h of hits) {
    if (h.kind !== 'amount' || !h.conflict || h.conflict.digits !== null || h.amount === undefined || h.amount < 100) continue;
    const a = h.amount;
    const corroborated = pool.some((o) => {
      const b = o.amount;
      return o !== h && o.kind === 'amount' && b !== undefined && b >= 100 && b !== a && RATIOS.some((k) => b === a * k || a === b * k);
    });
    if (corroborated) {
      delete h.conflict;
      delete h.suspect;
    }
  }
}

/**
 * الجولة 69: مسح كل البنود ثم التأييد الحسابى عبر العقد كله (الأجرة الشهرية فى بند والدفعة الربع سنوية فى بند آخر: 41,250 = 3 × 13,750).
 * كان التأييد داخل البند وحده فبقى «يلزم التحقق» على المبلغ وتنبيه الغلاف رغم تطابق القراءتين المستقلتين.
 */
function scanAll(texts: string[]): Hit[][] {
  const per = texts.map((t) => scan(t ?? ''));
  const pool = per.flat();
  for (const hits of per) corroborateByArithmetic(hits, pool);
  return per;
}

/** الشروط الرئيسية لكل البنود بترتيب ورودها، بلا تكرار، بحد أقصى. */
export function extractKeyTerms(clauses: KeyTermClause[], opts: { ocrRead?: boolean } = {}): KeyTerm[] {
  const out: KeyTerm[] = [];
  const seen = new Map<string, KeyTerm>();
  const ordered = [...clauses].sort((a, b) => a.clauseIndex - b.clauseIndex);
  const scanned = scanAll(ordered.map((c) => c.clauseText ?? ''));
  for (const [ci, c] of ordered.entries()) {
    for (const h of scanned[ci]) {
      if (h.partial) continue;
      const quote = maskLongNumbers(quoteAround(c.clauseText, h.pos, h.len));
      const key = `${c.clauseIndex}|${h.kind}|${h.value}|${quote}`;
      const prior = seen.get(key);
      if (prior) {
        prior.occurrences = (prior.occurrences ?? 1) + 1;
        continue;
      }
      const term: KeyTerm = {
        kind: h.kind,
        value: h.value,
        clauseIndex: c.clauseIndex,
        clauseLabel: c.clauseLabel,
        clauseTitle: c.clauseTitle,
        quote,
        fromWords: h.fromWords,
        ...(h.suspect ? { suspect: h.suspect } : {}),
        ...(opts.ocrRead && !h.fromWords && !h.suspect && !h.wordsConfirmed ? { ocrUnverified: true } : {}),
      };
      seen.set(key, term);
      out.push(term);
      if (out.length >= MAX_TERMS) return out;
    }
  }
  return out;
}

/** الجولة 79: وسم الجدول كله حين كانت قراءة العقد آلية (OCR) — ما قُرئ بالأرقام ولم يؤيده نص بالحروف. */
export const OCR_UNVERIFIED_LABEL = 'غير موثَّق—قراءة آلية';
export const OCR_UNVERIFIED_NOTE =
  'القيم الموسومة «غير موثَّق—قراءة آلية» مقروءة آلياً من نسخة ممسوحة ضوئياً بلا مطابقة بالحروف؛ الأرقام العربية-الهندية تُقرأ آلياً بلا ثقة (قد يُقرأ 750 «76,560» و10% «9011») — طابقه بالأصل قبل الاعتماد.';

/**
 * تنبيهات على مستوى العقد للمبالغ التى تعارض فيها الرقم المقروء مع المكتوب بالحروف (أو تلف الرقم). تتخطى ما سبق أن نبّه عليه
 * `numericWarnings` بالقيمتين نفسيهما، فلا يتكرر التنبيه.
 */
export function amountConflictWarnings(clauseTexts: string[], existing: string[] = []): string[] {
  const out: string[] = [];
  for (const hits of scanAll(clauseTexts)) {
    for (const h of hits) {
      if (h.partial) {
        const msg = `جزء من مبلغ مكتوب بالحروف («${fmtNumber(h.amount ?? 0)}» فى آخره) لم يُعرض مبلغاً مستقلاً: بدايته مشوّهة أو فى صفحة سابقة؛ طابق المبالغ بالأصل قبل الاعتماد.`;
        if (!out.includes(msg)) out.push(msg);
        continue;
      }
      if (!h.conflict) continue;
      const w = fmtNumber(h.conflict.words);
      const d = h.conflict.digits === null ? null : fmtNumber(h.conflict.digits);
      const msg =
        d === null
          ? `مبلغ مكتوب بالحروف (${w}) سبقه رقم تالف فى القراءة الآلية؛ طابق المبلغ بالأصل قبل الاعتماد.`
          : h.conflict.digits !== null && strayPrefix(h.conflict.digits, h.conflict.words)
            ? strayPrefixWarning(d, w)
            : `تناقض فى مبلغ: الرقم ${d} لا يطابق المكتوب بالحروف (${w}) — قد يكون خطأ قراءة آلية أو خطأ فى العقد الأصلى؛ قارن بالأصل قبل الاعتماد.`;
      if (out.includes(msg)) continue;
      if (d !== null && existing.some((e) => e.includes(d) && e.includes(w))) continue;
      out.push(msg);
    }
  }
  return out;
}
