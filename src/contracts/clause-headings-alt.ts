/**
 * أنماط ترقيم بنود بديلة لـ«البند + ترتيبى بالكلمات» (اختبار على عقود حقيقية أظهر أن عقداً كاملاً بنمط «المادة 1: …» أو «1. العنوان»
 * كان يُقسَّم إلى صفر بند فيُسقط التدقيق كله). لا تُستعمل إلا حين لا يجد النمط الأصلى بنوداً كافية، ولا يُعتمد نمط إلا إذا كوّن
 * تسلسلاً حقيقياً 1، 2، 3… (فتسقط القوائم العابرة والأرقام داخل المتون)، والبند الفرعى «1.1» ليس بنداً.
 * ملف نقى بلا أى اعتماد على Nest أو قاعدة البيانات.
 */

export interface AltHead {
  lineStart: number;
  markerStart: number;
  marker: string;
  rawLength: number;
  declaredNumber: number;
}

const UNITS_F = ['الاولى', 'الثانية', 'الثالثة', 'الرابعة', 'الخامسة', 'السادسة', 'السابعة', 'الثامنة', 'التاسعة'];
const TEENS_F = ['الحادية عشرة', 'الثانية عشرة', 'الثالثة عشرة', 'الرابعة عشرة', 'الخامسة عشرة', 'السادسة عشرة', 'السابعة عشرة', 'الثامنة عشرة', 'التاسعة عشرة'];

/** كل تهجئة مكتوبة لترتيبى مؤنث (حتى الثلاثين) → رقمه؛ بعد توحيد الحروف (أ/إ→ا، ى→ي، ة→ه) لأن العقود الممسوحة والمكتوبة بيد تخلط بينها. */
function normOrd(s: string): string {
  return s
    .replace(/[\u064b-\u0652\u0640]/g, '')
    .replace(/[أإآ]/g, 'ا')
    .replace(/ى/g, 'ي')
    .replace(/ة/g, 'ه')
    .replace(/\s+/g, ' ')
    .trim();
}

const ORDINAL_SPELLINGS: Array<[number, string]> = [];
UNITS_F.forEach((w, i) => ORDINAL_SPELLINGS.push([i + 1, w]));
ORDINAL_SPELLINGS.push([10, 'العاشرة']);
TEENS_F.forEach((w, i) => {
  ORDINAL_SPELLINGS.push([11 + i, w]);
  ORDINAL_SPELLINGS.push([11 + i, w.replace(/ عشرة$/, ' عشر')]);
});
ORDINAL_SPELLINGS.push([20, 'العشرون'], [20, 'العشرين']);
// 21–29: «الحادية والعشرون» (لا «الأولى والعشرون»)، ثم الثانية…التاسعة
UNITS_F.forEach((w, i) => {
  const unit = i === 0 ? 'الحادية' : w;
  ORDINAL_SPELLINGS.push([21 + i, `${unit} والعشرون`]);
  ORDINAL_SPELLINGS.push([21 + i, `${unit} والعشرين`]);
});
ORDINAL_SPELLINGS.push([30, 'الثلاثون'], [30, 'الثلاثين']);
const ORD_BY_NORM = new Map(ORDINAL_SPELLINGS.map(([n, w]) => [normOrd(w), n] as [string, number]));

/** حرف موحَّد → فئة حروفه المقبولة فى النص الخام (حتى يطابق «الثامنه» و«الاولي» و«الأولى» جميعاً) */
function looseOrdPattern(norm: string): string {
  return [...norm]
    .map((ch) => (ch === 'ا' ? '[أإآا]' : ch === 'ي' ? '[يى]' : ch === 'ه' ? '[هة]' : ch === ' ' ? '[ \\t]+' : ch))
    .join('');
}

const toInt = (s: string): number => Number(s.replace(/[٠-٩]/g, (d) => String('٠١٢٣٤٥٦٧٨٩'.indexOf(d))));

const NUM = '[0-9٠-٩]{1,3}';
// «المادة 3» / «مادة (3)» / «البند 3» (رقم بالأرقام) — بعدها فاصل اختيارى
const KEYWORD_NUMBER_RE = new RegExp(`^[ \\t]*(?<kw>المادة|مادة|البند|بند)[ \\t]*(?:رقم[ \\t]*)?[(\\[]?(?<num>${NUM})[)\\]]?(?![0-9٠-٩.])[ \\t]*(?<punct>[:：.\\-–—])?`, 'gmu');
// «المادة الأولى» (ترتيبى مؤنث بالكلمات، بأى تهجئة شائعة، حتى الثلاثين)
const KEYWORD_ORDINAL_RE = new RegExp(
  `^[ \\t]*(?<kw>المادة|مادة)[ \\t]+(?<ord>${[...ORD_BY_NORM.keys()]
    .sort((x, y) => y.length - x.length)
    .map(looseOrdPattern)
    .join('|')})(?![ء-ي])[ \\t]*(?<punct>[:：.\\-–—])?`,
  'gmu',
);
// «1. العنوان» أو «1) العنوان»: بند رئيسى بترقيم رقمى مجرد (وليس «1.1» الفرعى)
const BARE_NUMBER_RE = new RegExp(`^[ \\t]*(?<num>${NUM})[ \\t]*(?<punct>[.)])(?![0-9٠-٩])[ \\t]*(?=\\S)`, 'gmu');

function ordinalWordToNumber(spelling: string): number | null {
  return ORD_BY_NORM.get(normOrd(spelling)) ?? null;
}

interface Candidate extends AltHead {
  punct: string;
}

function toCandidates(text: string, re: RegExp, kind: 'number' | 'ordinal' | 'bare'): Candidate[] {
  const out: Candidate[] = [];
  for (const m of text.matchAll(re)) {
    const raw = m[0];
    const trimmed = raw.replace(/^[ \t]+/, '');
    const lineStart = m.index ?? 0;
    const g = m.groups ?? {};
    const n = kind === 'ordinal' ? ordinalWordToNumber(g.ord ?? '') : toInt(g.num ?? '');
    if (n === null || !Number.isFinite(n) || n < 1) continue;
    const kw = kind === 'bare' ? 'البند' : (g.kw ?? 'البند').replace(/^ال/, 'ال');
    const punct = (g.punct ?? '').replace('：', ':');
    out.push({
      lineStart,
      markerStart: lineStart + (raw.length - trimmed.length),
      marker: `${kw === 'مادة' ? 'المادة' : kw === 'بند' ? 'البند' : kw} ${n}${punct === ':' || punct === '.' ? punct : ''}`,
      rawLength: trimmed.length,
      declaredNumber: n,
      punct,
    });
  }
  return out;
}

/** أطول سلسلة 1، 2، 3… (كل رقم هو أول ظهور للتالى بعد سابقه) — تُسقط ما عداها من أرقام عابرة. */
function chain(cands: Candidate[]): Candidate[] {
  const out: Candidate[] = [];
  let want = 1;
  for (const c of cands) {
    if (c.declaredNumber === want) {
      out.push(c);
      want++;
    }
  }
  return out;
}

// إحالة إلى مادة فى نص آخر («المادة 157 من القانون المدنى») ليست عنوان بند فى هذا العقد
const EXTERNAL_REF_AFTER_RE = /^[\s_\u0640]*(?:\(?\d+\)?[\s_\u0640]*)?من[\s_\u0640]+(?:ال)?(?:عقد|قانون|لائحة|لائحه|ملحق|اتفاق|اتفاقية|اتفاقيه|نظام)/u;
/** أقصى قفزة مقبولة فوق أعلى رقم قُبِل (عقود حقيقية تقفز من «13» إلى «18» أو تكرر رقماً أو تكتبه خارج الترتيب). */
const MAX_NUMBER_GAP = 10;

/**
 * سلسلة صارمة 1، 2، 3… ثم، لعناوين «المادة/البند» الصريحة فقط، يُقبَل ما بعدها من عناوين على بداية السطر حتى مع قفزة أو تكرار أو ترتيب
 * مخالف (ما دام الرقم ضمن {@link MAX_NUMBER_GAP} فوق أعلى رقم مقبول) — فلا يسقط نصف العقد لأن ترقيمه المكتوب غير متسلسل. الشذوذ يُنبَّه إليه
 * لاحقاً بتحذير «ترقيم غير متسلسل» لا بإسقاط البنود. الترقيم المجرد «1.» يبقى صارماً (قوائم المتون).
 */
function tolerantChain(cands: Candidate[], text: string): Candidate[] {
  const strict = chain(cands);
  if (strict.length < 3) return strict;
  const last = strict[strict.length - 1];
  let max = last.declaredNumber;
  const out = [...strict];
  for (const c of cands) {
    if (c.lineStart <= last.lineStart) continue;
    if (c.declaredNumber > max + MAX_NUMBER_GAP) continue;
    const after = text.slice(c.markerStart + c.rawLength, c.markerStart + c.rawLength + 40);
    if (EXTERNAL_REF_AFTER_RE.test(after)) continue;
    out.push(c);
    if (c.declaredNumber > max) max = c.declaredNumber;
  }
  return out;
}

export function findAlternativeHeads(text: string): AltHead[] {
  const options = [
    tolerantChain(toCandidates(text, KEYWORD_NUMBER_RE, 'number'), text),
    tolerantChain(toCandidates(text, KEYWORD_ORDINAL_RE, 'ordinal'), text),
    chain(toCandidates(text, BARE_NUMBER_RE, 'bare')),
  ];
  // الأطول تسلسلاً، وعند التساوى الأوضح (بكلمة مفتاحية قبل الرقم المجرد)؛ أقل من 3 بنود لا يُعدّ ترقيماً
  const best = options.reduce((a, b) => (b.length > a.length ? b : a), options[0]);
  if (best.length < 3) return [];
  return best.map(({ punct: _p, ...h }) => h);
}


// ---------------------------------------------------------------------------------------------------------------------------------
// الجولة 68: عناوين «أولاً/ثانياً/ثالثاً…» (ترتيبى بصيغة الحال) بلا كلمة «البند». عقد أتعاب محاماة حقيقى ممسوح بنوده «أولاً: … ثانياً: …»
// بلا أى ترقيم «البند …» خرج بصفر بنود وبغلاف يقول «لم تُرصد بنود تحتاج مراجعة». لا يُستعمل إلا حين لا يجد أى نمط آخر بنوداً كافية.
// ---------------------------------------------------------------------------------------------------------------------------------

const ADVERB_WORDS: Array<[number, string]> = [
  [1, 'اولا'], [2, 'ثانيا'], [3, 'ثالثا'], [4, 'رابعا'], [5, 'خامسا'], [6, 'سادسا'], [7, 'سابعا'], [8, 'ثامنا'], [9, 'تاسعا'], [10, 'عاشرا'],
  [11, 'حادي عشر'], [12, 'ثاني عشر'], [13, 'ثالث عشر'], [14, 'رابع عشر'], [15, 'خامس عشر'],
];
/** صيغة العرض الصحيحة لكل رقم (مع التنوين) كما تظهر فى عنوان البند بالتقرير */
const ADVERB_DISPLAY: Record<number, string> = {
  1: 'أولاً', 2: 'ثانياً', 3: 'ثالثاً', 4: 'رابعاً', 5: 'خامساً', 6: 'سادساً', 7: 'سابعاً', 8: 'ثامناً', 9: 'تاسعاً', 10: 'عاشراً',
  11: 'حادى عشر', 12: 'ثانى عشر', 13: 'ثالث عشر', 14: 'رابع عشر', 15: 'خامس عشر',
};
const MARKS = '[\\u064b-\\u0652\\u0640]*';
function looseAdverbPattern(norm: string): string {
  return [...norm]
    .map((ch) => {
      const cls = ch === 'ا' ? '[أإآا]' : ch === 'ي' ? '[يى]' : ch === ' ' ? '[ \\t]+' : ch;
      return ch === ' ' ? cls : `${cls}${MARKS}`;
    })
    .join('');
}
const ADVERB_NUMBER = new Map(ADVERB_WORDS.map(([n, w]) => [w, n] as [string, number]));
// «أولاً» «ثانيا» «(ثالثاً)» فى أول السطر، ثم فاصل اختيارى (: - – . ،)؛ ما بعده نص البند
const ORD_ALT = ADVERB_WORDS.map(([, w]) => looseAdverbPattern(w))
  .sort((a, b) => b.length - a.length)
  .join('|');
/** ضجيج مسح قبل العنوان على السطر نفسه (الجولة 69): حرف عربى مفرد («ش ثانياً»)، أو 1–3 رموز/أرقام، أو حرفان لاتينيان؛ حتى اثنين. */
const LEAD_JUNK = '(?:(?:[ء-ي]|[A-Za-z]{1,2}|[^\\s\\u0600-\\u06FFA-Za-z]{1,3})[ \\t]+){0,2}';
/** ضجيج بين العنوان وعلامة الوقف («ثانياً ‎٠:») */
const TRAIL_JUNK = '[ \\t\\u200e\\u200f٠-٩0-9]{0,4}';
const ADVERB_RE = new RegExp(
  `^[ \\t]*[:：\\-–—.'"’‘|!]{0,3}[ \\t]*${LEAD_JUNK}[(\\[]?(?<ord>${ORD_ALT})(?![ء-ي])[)\\]]?[ \\t]*(?<punct>[:：\\-–—.،])?`,
  'gmu',
);
/**
 * الجولة 69 (مرحلة احتياطية): العنوان وسط السطر بعد نهاية جملة، لأن القراءة الآلية قد تدمج أسطر العقد الممسوح فى فقرة واحدة
 * (عقد الأتعاب 0 بند فى الإنتاج رغم نجاحه على قراءة تجريبية). يُشترط هنا علامة وقف بعد العنوان («أولاً:» / «ثانياً -») منعاً للالتقاط العابر،
 * ويبقى شرط التسلسل 1،2،3 (≥3 أو اثنان مع عبارة تمهيدية).
 */
const ADVERB_MID_RE = new RegExp(
  `(?<![ء-ي])[(\\[]?(?<ord>${ORD_ALT})(?![ء-ي])[)\\]]?${TRAIL_JUNK}(?<punct>[:：\\-–—])`,
  'gu',
);
/** بعد العنوان مباشرة تعريف بطرف («أولاً: السادة/ شركة… (طرف أول)») فهو بند ديباجة لا بند عقد */
const PARTY_AFTER_RE = /^[\s:：\-–—.،/]*(?:السادة|السيد|السيدة|الأستاذ|الاستاذ|الدكتور|الدكتورة|المهندس|المهندسة|شركة|شركه|مكتب|بنك|مؤسسة|مؤسسه|هيئة|هيئه)/u;
const PARTY_DESIGNATION_RE = /طرف[\s_]*(?:اول|أول|الأول|الاول|ثان|ثاني|ثانى|الثاني|الثانى)/u;
/** عبارة تمهيدية بعدها بنود الاتفاق («اتفق الطرفان على الآتى»، «على ما يلى») تسوّغ قبول عنوانين فقط */
// الجولة 69.1: «علي الأني» (قراءة آلية لـ«على الآتى») و«على التالى» تُقبل أيضاً؛ كان عدم مطابقة «الأني» يُسقط عقد أتعاب من عنوانين
const ANNOUNCE_RE = /(?:على|علي|الى|إلى)[\s]+(?:ما[\s]+)?(?:يلي|يلى|ال[اأآإ]ت[يى]|ال[اأآإ]ن[يى]|التال[يى])|اتفق[\s]+الطرفان|اتفقا|تم[\s]+الاتفاق/u;
/** تعريف أطراف بصيغة «(طرف أول)» أو «الطرف الأول/الثانى» قبل العنوانين: يكفى مع عنوانين متسلسلين لقبول التقسيم (عقد ثنائى الأطراف لا خطاب) */
const PARTIES_BEFORE_RE = /(?:الطرف|طرف)[\s_]*(?:ال)?(?:اول|أول|ثان|ثاني|ثانى)/u;

function normForAnnounce(s: string): string {
  return s.replace(/[\u064b-\u0652\u0640]/g, '');
}

function editDistance(a: string, b: string): number {
  const dp: number[] = Array.from({ length: b.length + 1 }, (_, j) => j);
  for (let i = 1; i <= a.length; i++) {
    let prev = dp[0];
    dp[0] = i;
    for (let j = 1; j <= b.length; j++) {
      const tmp = dp[j];
      dp[j] = Math.min(dp[j] + 1, dp[j - 1] + 1, prev + (a[i - 1] === b[j - 1] ? 0 : 1));
      prev = tmp;
    }
  }
  return dp[b.length];
}

const FUZZY_LINE_RE = /^[ \t]*[:：\-–—.'"’‘|!]{0,3}[ \t]*(?<tok>[ء-ي\u064b-\u0652]{4,8})(?![ء-ي])[ \t]*(?<punct>[:：\-–—.،'])?/gmu;

/**
 * الجولة 90 (استبدلت extendFuzzy): عنوان ترتيبى شوّهته القراءة الآلية («نالياً» بدل «ثالثاً»، «سنادننا» بدل «سادساً»، «نامنا» بدل «ثامناً») يُقرأ بمطابقة
 * تقريبية مقيَّدة بالتسلسل فى ثلاثة مواضع: بين عنوانين مقروءين (ثغرة داخلية)، بعد آخر عنوان (امتداد)، وقبل أول عنوان مقروء (إن ضاع «أولاً»).
 * قبل هذه الجولة كان الامتداد وحده يعمل، ويشترط نصاً بعد الكلمة فى السطر نفسه؛ فعقد إيجار ممسوح تقف فيه كل كلمة ترتيبية وحدها فى سطر (والمتن فى السطر التالى)
 * خرج ببندين أو صفر لأن أول عنوان تالف قطع التسلسل ولم يُسترجع ما بعده.
 * شروط القبول (أى إخفاق ⇒ لا تغيير): (1) سطر عنوان الشكل: الكلمة وحدها (≤ 12 حرفاً) يليها سطر متن ≥ 12 حرفاً، أو كلمة 4–9 أحرف يليها علامة وقف ثم نص ≥ 12 حرفاً؛
 * (2) داخل النافذة بين العنوانين المجاورين؛ (3) مسافة التحرير إلى الترتيبى المنتظر ≤ 2 (≤ 3 لكلمة وحدها طولها ≥ 5)، ولا يقرب أى ترتيبى آخر أكثر منه؛
 * (4) أقرب مرشح فى النافذة يفوز، فلا يُختار سطر لاحق على حساب أقرب؛ والتنبيه الصريح يصاحب التقسيم فى الخدمة.
 */
const HEADING_SHAPE_ALONE_MAX = 12;
const HEADING_SHAPE_INLINE_MAX = 9;
const NEIGHBOUR_BODY_MIN = 12;

function bestAdverbDistance(tok: string, want: number): number | null {
  const own = ADVERB_WORDS.find(([n]) => n === want)?.[1];
  if (!own) return null;
  const d = editDistance(tok, own);
  for (const [n, w] of ADVERB_WORDS) {
    if (n === want) continue;
    if (editDistance(tok, w) < d) return null;
  }
  return d;
}

function findFuzzyAdverb(text: string, want: number, from: number, to: number): AltHead | null {
  const word = ADVERB_WORDS.find(([n]) => n === want)?.[1];
  if (!word) return null;
  let best: { d: number; head: AltHead } | null = null;
  let pos = from;
  while (pos < to) {
    const nl = text.indexOf('\n', pos);
    const lineEnd = nl === -1 || nl > to ? to : nl;
    const raw = text.slice(pos, lineEnd);
    const lineStart = pos;
    pos = lineEnd + 1;
    const trimmedLine = raw.trim();
    if (trimmedLine.length === 0) continue;
    const trimmed = raw.replace(/^[ \t]+/, '');
    const lead = raw.length - trimmed.length;
    // (أ) الكلمة وحدها فى السطر (تشمل «حادى عشر» ذات الكلمتين)، والمتن فى السطر التالى
    const stripped = trimmedLine.replace(/^[:：\-–—.'"’‘|!]+/, '').replace(/[:：\-–—.،'"\s]+$/, '');
    let tok = '';
    let alone = false;
    let rawLength = 0;
    if (stripped.length > 0 && stripped.length <= HEADING_SHAPE_ALONE_MAX + 4 && /^[ء-ي\u064b-\u0652 ]+$/u.test(stripped)) {
      const after = text.slice(Math.min(pos, to), to).split('\n').map((l) => l.trim()).find((l) => l.length > 0) ?? '';
      if (after.length >= NEIGHBOUR_BODY_MIN) {
        tok = normOrd(stripped);
        alone = true;
        rawLength = trimmed.trimEnd().length;
      }
    }
    // (ب) كلمة 3–9 أحرف يليها علامة وقف ثم نص فى السطر نفسه (وبها لا تُقبل الكلمتان)
    if (!alone && !word.includes(' ')) {
      const m = /^[:：\-–—.'"’‘|!]{0,3}[ \t]*(?<tok>[ء-ي\u064b-\u0652]{3,9})[ \t]*(?<punct>[:：\-–—.،'])[ \t]*(?<rest>.*)$/u.exec(trimmedLine);
      if (m?.groups && m.groups.rest.trim().length >= NEIGHBOUR_BODY_MIN) {
        tok = normOrd(m.groups.tok);
        rawLength = lead === 0 ? m[0].length - m.groups.rest.length : trimmed.length - m.groups.rest.length;
      }
    }
    if (tok.length < 3) continue;
    const d = bestAdverbDistance(tok, want);
    if (d === null) continue;
    const limit = alone && tok.length >= 5 ? 3 : 2;
    if (d > limit || d >= tok.length / 2 + 1) continue;
    if (!best || d < best.d) {
      best = { d, head: { lineStart, markerStart: lineStart + lead, marker: ADVERB_DISPLAY[want], rawLength: Math.max(1, rawLength), declaredNumber: want } };
    }
  }
  return best ? best.head : null;
}

/** يكمل تسلسلاً مقروءاً بالمطابقة التقريبية: قبله (إن ضاع «أولاً»)، وفى ثغراته، وبعده. المدخل مرتب بالموضع ومتزايد الأرقام. */
function completeAdverbial(text: string, anchors: AltHead[]): AltHead[] {
  const out = [...anchors].sort((a, b) => a.lineStart - b.lineStart);
  const MAX = 15;
  for (let want = 1; want <= MAX; want++) {
    if (out.some((h) => h.declaredNumber === want)) continue;
    const prev = [...out].filter((h) => h.declaredNumber < want).pop();
    const next = out.find((h) => h.declaredNumber > want);
    if (!prev && !next) break;
    const from = prev ? (text.indexOf('\n', prev.lineStart) === -1 ? text.length : text.indexOf('\n', prev.lineStart) + 1) : 0;
    const to = next ? next.lineStart : text.length;
    if (from >= to) continue;
    const found = findFuzzyAdverb(text, want, from, to);
    if (!found) {
      // ثغرة داخلية لم تُسترجع: يتوقف الامتداد بعد الأخير فقط، أما اللاحق المقروء فيبقى
      if (!next) break;
      continue;
    }
    out.push(found);
    out.sort((a, b) => a.lineStart - b.lineStart);
  }
  return out;
}

function isPartyIntro(after: string): boolean {
  if (PARTY_AFTER_RE.test(after) && PARTY_DESIGNATION_RE.test(after)) return true;
  return PARTY_AFTER_RE.test(after.slice(0, 40)) && /^[\s:：\-–—.،/]*(?:السادة|السيد|السيدة)/u.test(after);
}

/**
 * أطول تسلسل متزايد داخل أى «دورة» (الرقم يعود إلى ما دون السابق = دورة جديدة)، ثم يُكمَّل بالمطابقة التقريبية (completeAdverbial) قبل المفاضلة بين الدورات؛
 * عند التساوى الأخيرة (متن العقد يلى الديباجة). يُقبل التسلسل المكتمل إن بدأ بالرقم 1 (الجولة 90: كان يُشترط أن يكون 1،2،3 متصلاً فتقطعه أول كلمة تالفة).
 * قبول بحسب العدد: ≥ 3، أو اثنان مع عبارة تمهيدية/تعريف طرفين.
 */
/** أعلى رقم يجوز أن تبدأ به سلسلة عناوين ترتيبية مقروءة (الثلاثة الأولى كانت الحد القديم) وأدنى عدد عناوين مقروءة لقبول سلسلة لا تبدأ بـ1 أو 2 */
const MAX_LATE_START = 8;
const LATE_START_MIN_HEADS = 5;

function pickRun(text: string, cands: AltHead[]): AltHead[] {
  const cycles: AltHead[][] = [];
  let cur: AltHead[] = [];
  let last = 0;
  for (const c of cands) {
    if (c.declaredNumber <= last && cur.length > 0) {
      cycles.push(cur);
      cur = [];
      last = 0;
    }
    // قفزة أكبر من 3 فى الأرقام ليست تسلسلاً بل عنواناً عابراً؛ إلا الترتيبى المركّب («رابع عشر») فلا يلتبس بكلمة عادية فيُقبل بعد عدة عناوين تالفة
    // الجولة 92: السلسلة قد تبدأ بعنوان متأخر («رابعاً») حين ضاعت الثلاثة الأولى من القراءة؛ يُحسم قبولها لاحقاً بعدد العناوين المقروءة (≥ 5 بعد الاستكمال)
    if (c.declaredNumber > last && (cur.length === 0 ? c.declaredNumber <= MAX_LATE_START : c.declaredNumber - last <= 3 || c.declaredNumber >= 11)) {
      cur.push(c);
      last = c.declaredNumber;
    }
  }
  if (cur.length > 0) cycles.push(cur);
  let best: AltHead[] = [];
  let startsAtTwo: AltHead[] = [];
  let startsLater: AltHead[] = [];
  for (const chain of cycles) {
    const done = completeAdverbial(text, chain);
    if (done.length > 0 && done[0].declaredNumber === 1 && done.length >= best.length) best = done;
    if (done.length > 0 && done[0].declaredNumber === 2 && done.length >= startsAtTwo.length) startsAtTwo = done;
    if (done.length > 0 && done[0].declaredNumber >= 3 && done.length >= startsLater.length) startsLater = done;
  }
  // الجولة 92: عقد ممسوح ضاعت عناوينه الأولى («أولاً/ثانياً/ثالثاً» لم تُقرأ) وبقى من عناوين الإنتاج «رابعاً، خامساً، سادساً، سابعاً، عاشراً، حادى عشر، رابع عشر» (إيجار ممسوح خرج بثلاثة بنود من 15).
  // سلسلة بدأت بعنوان متأخر لا يُقبل إلا بأدلة كثيرة: ≥ 5 عناوين مقروءة بعد الاستكمال (7 عناوين لا تأتى عرضاً فى متن عقد)، وإلا يبقى الرفض السابق.
  if (best.length === 0 && startsAtTwo.length < 4 && startsLater.length >= LATE_START_MIN_HEADS) return startsLater;
  // الجولة 91.1: «أولاً» ضاعت كلياً من القراءة (قُرئت «Vol» مثلاً) فلا تُسترجع بالمطابقة التقريبية، لكن ثلاثة عناوين ترتيبية متتالية أو أكثر بعدها (ثانياً…)
  // يقف كل منها وحده فى سطر دليل كافٍ على التسلسل؛ فيُقبل التسلسل المبتدئ بـ2 (≥ 4 عناوين بعد الاستكمال) ويسترجع الخدمة بدء البند الأول من فقرة الأطراف (recoverFirstHead).
  if (best.length === 0 && startsAtTwo.length >= 4) best = startsAtTwo;
  if (best.length >= 3) return best;
  if (best.length === 2) {
    const before = normForAnnounce(text.slice(Math.max(0, best[0].lineStart - 300), best[0].lineStart));
    if (ANNOUNCE_RE.test(before)) return best;
    // عنوانان متسلسلان بعد تعريف طرفين (طرف أول/ثان) فى النص نفسه: عقد قصير حقيقى («أولاً: … ثانياً: …») وليس خطاباً
    const wide = normForAnnounce(text.slice(Math.max(0, best[0].lineStart - 1500), best[0].lineStart));
    if (PARTIES_BEFORE_RE.test(wide)) return best;
  }
  return [];
}

export function findAdverbialHeads(text: string): AltHead[] {
  const cands: AltHead[] = [];
  for (const m of text.matchAll(ADVERB_RE)) {
    const raw = m[0];
    const trimmed = raw.replace(/^[ \t]+/, '');
    const lineStart = m.index ?? 0;
    const n = ADVERB_NUMBER.get(normOrd(m.groups?.ord ?? '')) ?? null;
    if (n === null) continue;
    const after = text.slice(lineStart + raw.length, lineStart + raw.length + 320);
    if (isPartyIntro(after)) continue;
    cands.push({
      lineStart,
      markerStart: lineStart + (raw.length - trimmed.length),
      marker: ADVERB_DISPLAY[n], // بلا نقطتين: ما بعد «أولاً:» متن البند لا عنوانه
      rawLength: trimmed.length,
      declaredNumber: n,
    });
  }
  const lineMode = pickRun(text, cands);
  if (lineMode.length > 0) return lineMode;

  // مرحلة احتياطية: عناوين وسط السطر بعلامة وقف صريحة (قراءة دمجت الأسطر)
  const mid: AltHead[] = [];
  for (const m of text.matchAll(ADVERB_MID_RE)) {
    const at = m.index ?? 0;
    const n = ADVERB_NUMBER.get(normOrd(m.groups?.ord ?? '')) ?? null;
    if (n === null) continue;
    const after = text.slice(at + m[0].length, at + m[0].length + 320);
    if (isPartyIntro(after)) continue;
    mid.push({ lineStart: at, markerStart: at, marker: ADVERB_DISPLAY[n], rawLength: m[0].length, declaredNumber: n });
  }
  return pickRun(text, mid);
}

/**
 * تشخيص بنيوى بلا محتوى (الجولة 69): حين لا يُستخرج أى بند يُسجَّل فى سجل النشر عدد الأسطر وعدد كل كلمة ترتيبية (أولاً…) فى أى موضع وفى أول السطر
 * والحرف السابق لها (فئته لا قيمته)، ليُعرف سبب العجز على نص الإنتاج دون كشف نص العقد.
 */
export function adverbialDiagnostics(text: string): string {
  const lines = text.split('\n');
  const parts: string[] = [];
  for (const [n, w] of ADVERB_WORDS.slice(0, 6)) {
    const re = new RegExp(`(?<![ء-ي])${looseAdverbPattern(w)}(?![ء-ي])`, 'gu');
    let any = 0;
    let atStart = 0;
    const prev: Record<string, number> = {};
    for (const l of lines) {
      for (const m of l.matchAll(re)) {
        any++;
        const before = l.slice(0, m.index ?? 0).trimEnd();
        if (before.length === 0) atStart++;
        const ch = before.slice(-1);
        const cls = !ch ? 'start' : /[.،؛:]/.test(ch) ? 'punct' : /[ء-ي]/.test(ch) ? 'arabic' : /\d|[٠-٩]/.test(ch) ? 'digit' : 'symbol';
        prev[cls] = (prev[cls] ?? 0) + 1;
      }
    }
    parts.push(`${n}:any=${any},lineStart=${atStart},prev=${JSON.stringify(prev)}`);
  }
  return `lines=${lines.length} chars=${text.length} ${parts.join(' ')}`;
}

/**
 * الجولة 70: حين لا يُستخرج أى بند يُسجَّل فى سجل النشر (لا فى التقرير) بداية كل سطر مقروء (حتى 48 حرفاً، حتى 90 سطراً) لمعرفة ما قرأته
 * القراءة الآلية فعلاً من عقد ممسوح قصير؛ فقد خرج عقد أتعاب من صفحتين بـ52 سطراً و1065 حرفاً وبلا أى عنوان ترتيبى ثالث ولا يظهر السبب فى العدّادات وحدها.
 * سجل خاص بمالك المنصة على Railway.
 */
export function zeroHeadLinesDump(text: string): string {
  return text
    .split('\n')
    .map((l, i) => `L${i + 1} ${l.trim().slice(0, 48)}`)
    .filter((l) => l.length > 4)
    .slice(0, 90)
    .join(' | ');
}
