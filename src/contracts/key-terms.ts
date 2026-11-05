import { parseArabicNumberWords } from './numeric-checks.util';

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
function wordsBefore(text: string, end: number): { value: number; start: number } | null {
  const winStart = Math.max(0, end - 160);
  const head = text.slice(winStart, end);
  const tokens = [...head.matchAll(/[ء-ي]+/g)];
  const kept: Array<{ word: string; idx: number }> = [];
  let prevStart = head.length;
  let sawNumber = false;
  for (let i = tokens.length - 1; i >= 0; i -= 1) {
    const t = tokens[i];
    const idx = t.index ?? 0;
    const gap = head.slice(idx + t[0].length, prevStart);
    if (!NUMBER_GAP.test(gap)) break;
    if (isNumberWord(t[0])) {
      kept.unshift({ word: t[0], idx });
      sawNumber = true;
    } else if (isNoiseToken(t[0]) && sawNumber) {
      // ضجيج: نتخطاه، ولا يجوز أن تبدأ العبارة به (يُقصّ لاحقاً)
      kept.unshift({ word: '', idx });
    } else {
      break;
    }
    prevStart = idx;
  }
  while (kept.length > 0 && kept[0].word === '') kept.shift();
  if (kept.length === 0) return null;
  const v = parseArabicNumberWords(kept.map((k) => k.word).filter(Boolean).join(' '));
  if (v === null || v <= 0) return null;
  return { value: v, start: winStart + kept[0].idx };
}

/**
 * بعد رقم المبلغ: هل تتبعه كتابته بالحروف ثم العملة؟ (قوس اختيارى ثم كلمات كلها عددية أو ضجيج مسح ثم العملة).
 * يُرجَع موضع نهاية العملة، وإلا null؛ فلا نلتقط مبلغاً لمجرد وجود عملة بعيدة.
 */
function amountWordsTail(text: string, from: number): { currency: string; end: number } | null {
  const tail = text.slice(from, from + 200);
  const m = tail.match(new RegExp(`^[\\s]*[)）(（]?[\\s]*((?:[ء-ي]+[\\s)）(（]*){1,14}?)(${CURRENCY})`, 'u'));
  if (!m) return null;
  const words = [...m[1].matchAll(/[ء-ي]+/g)].map((x) => x[0]);
  if (words.length === 0 || !words.some((w) => isNumberWord(w))) return null;
  if (!words.every((w) => isNumberWord(w) || isNoiseToken(w))) return null;
  return { currency: m[2], end: from + m[0].length };
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
}

/** وصف التعارض بين رقم المبلغ وكتابته بالحروف: يُعرض مع القيمة فى الجدول وفى تنبيهات العقد. */
function conflictNote(digits: number | null, words: number): string {
  return digits === null
    ? `الرقم المقروء قبل المبلغ المكتوب بالحروف تالف (لا يُقرأ رقماً)؛ المعروض هو المكتوب بالحروف (${fmtNumber(words)}) — طابق الأصل`
    : `تعارض فى المبلغ: الرقم المقروء ${fmtNumber(digits)} لا يطابق المكتوب بالحروف ${fmtNumber(words)}؛ المعروض هو المكتوب بالحروف — قد يكون خطأ قراءة آلية أو خطأ فى الأصل، فطابق الأصل`;
}

/**
 * يطابق المبلغ المقروء بالأرقام مع كتابته بالحروف التى تليه فى الجملة نفسها («452,500,000 جنيه مصرى سنويا ( فقط خمسمائة الف جنيه )»).
 * المتطابقان يُعرضان مرة واحدة؛ والمتعارضان (أو الرقم التالف) يُعرضان صفاً واحداً بقيمة الحروف مع تنبيه صريح، فلا يظهر رقم
 * مشوّه بلا تحذير. الاقتران لا يتم إلا إن فصلت بينهما قوسٌ أو «فقط» ولم تفصل بينهما رقم ولا علامة وقف (فشل مغلق: لا نقرن مبلغين متباعدين).
 */
function reconcileAmounts(text: string, hits: Hit[], garbled: Array<{ pos: number; end: number }>): Hit[] {
  const drop = new Set<Hit>();
  const replaced = new Map<Hit, Hit>();
  const digitsEnd = (h: Hit) => h.pos + h.len;
  for (const wh of hits) {
    if (wh.kind !== 'amount' || !wh.fromWords || wh.amount === undefined) continue;
    const cands: Array<{ hit?: Hit; pos: number; end: number }> = [
      ...hits.filter((h) => h.kind === 'amount' && !h.fromWords && h.amount !== undefined && !h.conflict && digitsEnd(h) <= wh.pos).map((h) => ({ hit: h, pos: h.pos, end: digitsEnd(h) })),
      ...garbled.filter((g) => g.end <= wh.pos).map((g) => ({ pos: g.pos, end: g.end })),
    ].sort((a, b) => b.end - a.end);
    const d = cands[0];
    if (!d || wh.pos - d.end > 90) continue;
    const gap = text.slice(d.end, wh.pos);
    if (/[\d.؛؟!]/.test(gap) || !/[(（]|فقط/.test(gap)) continue;
    if (hits.some((h) => h !== wh && h !== d.hit && h.kind === 'amount' && h.pos >= d.end && h.pos < wh.pos)) continue;
    if (!d.hit) {
      replaced.set(wh, { ...wh, suspect: conflictNote(null, wh.amount), conflict: { digits: null, words: wh.amount } });
    } else if (d.hit.amount === wh.amount) {
      drop.add(wh);
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
  const garbledDigits: Array<{ pos: number; end: number }> = [];
  for (const m of text.matchAll(amountDigits)) {
    let curMatch = m[3] ?? (m[2] ? m[2].match(new RegExp(CURRENCY, 'u'))?.[0] : undefined);
    let spanEnd = (m.index ?? 0) + m[0].length;
    if (!curMatch) {
      // الرقم ثم كتابته بالحروف (قد يضيع القوس الافتتاحى فى المسح): «1125000 ) مليون ومائة … ألف جنيه»
      const tail = amountWordsTail(text, spanEnd);
      if (!tail) continue;
      curMatch = tail.currency;
      spanEnd = tail.end;
    }
    const n = Number(m[1].replace(/[,٬]/g, ''));
    if (!Number.isFinite(n)) continue;
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
      }
    }
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
    hits.push({ kind: 'amount', value: `${fmtNumber(w.value)} ${cur}`, pos: w.start, len: pos + m[0].length - w.start, fromWords: true, amount: w.value });
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
    if (!w || w.value > 1000) continue;
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

  // تواريخ: 15/3/2026 أو 2026-03-15
  const dateDmy = /(?<![\d/.\-])(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{4})(?![\d/])/gu;
  for (const m of text.matchAll(dateDmy)) {
    const d = Number(m[1]);
    const mo = Number(m[2]);
    if (d < 1 || d > 31 || mo < 1 || mo > 12) continue;
    hits.push({ kind: 'date', value: `${m[1]}/${m[2]}/${m[3]}`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
  }
  const dateYmd = /(?<![\d/.\-])(\d{4})[/\-.](\d{1,2})[/\-.](\d{1,2})(?![\d/])/gu;
  for (const m of text.matchAll(dateYmd)) {
    const mo = Number(m[2]);
    const d = Number(m[3]);
    if (d < 1 || d > 31 || mo < 1 || mo > 12) continue;
    hits.push({ kind: 'date', value: `${m[3]}/${m[2]}/${m[1]}`, pos: m.index ?? 0, len: m[0].length, fromWords: false });
  }

  return reconcileAmounts(text, hits, garbledDigits).sort((a, b) => a.pos - b.pos);
}

/** الشروط الرئيسية لكل البنود بترتيب ورودها، بلا تكرار، بحد أقصى. */
export function extractKeyTerms(clauses: KeyTermClause[]): KeyTerm[] {
  const out: KeyTerm[] = [];
  const seen = new Map<string, KeyTerm>();
  const ordered = [...clauses].sort((a, b) => a.clauseIndex - b.clauseIndex);
  for (const c of ordered) {
    for (const h of scan(c.clauseText ?? '')) {
      const quote = quoteAround(c.clauseText, h.pos, h.len);
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
      };
      seen.set(key, term);
      out.push(term);
      if (out.length >= MAX_TERMS) return out;
    }
  }
  return out;
}

/**
 * تنبيهات على مستوى العقد للمبالغ التى تعارض فيها الرقم المقروء مع المكتوب بالحروف (أو تلف الرقم). تتخطى ما سبق أن نبّه عليه
 * `numericWarnings` بالقيمتين نفسيهما، فلا يتكرر التنبيه.
 */
export function amountConflictWarnings(clauseTexts: string[], existing: string[] = []): string[] {
  const out: string[] = [];
  for (const t of clauseTexts) {
    for (const h of scan(t ?? '')) {
      if (!h.conflict) continue;
      const w = fmtNumber(h.conflict.words);
      const d = h.conflict.digits === null ? null : fmtNumber(h.conflict.digits);
      const msg =
        d === null
          ? `مبلغ مكتوب بالحروف (${w}) سبقه رقم تالف فى القراءة الآلية؛ طابق المبلغ بالأصل قبل الاعتماد.`
          : `تناقض فى مبلغ: الرقم ${d} لا يطابق المكتوب بالحروف (${w}) — قد يكون خطأ قراءة آلية أو خطأ فى العقد الأصلى؛ قارن بالأصل قبل الاعتماد.`;
      if (out.includes(msg)) continue;
      if (d !== null && existing.some((e) => e.includes(d) && e.includes(w))) continue;
      out.push(msg);
    }
  }
  return out;
}
