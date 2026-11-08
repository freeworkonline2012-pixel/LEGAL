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
const ADVERB_RE = new RegExp(
  `^[ \\t]*[:：\\-–—.'"’‘|!]{0,3}[ \\t]*[(\\[]?(?<ord>${ADVERB_WORDS.map(([, w]) => looseAdverbPattern(w))
    .sort((a, b) => b.length - a.length)
    .join('|')})(?![ء-ي])[)\\]]?[ \\t]*(?<punct>[:：\\-–—.،])?`,
  'gmu',
);
/** بعد العنوان مباشرة تعريف بطرف («أولاً: السادة/ شركة… (طرف أول)») فهو بند ديباجة لا بند عقد */
const PARTY_AFTER_RE = /^[\s:：\-–—.،/]*(?:السادة|السيد|السيدة|الأستاذ|الاستاذ|الدكتور|الدكتورة|المهندس|المهندسة|شركة|شركه|مكتب|بنك|مؤسسة|مؤسسه|هيئة|هيئه)/u;
const PARTY_DESIGNATION_RE = /طرف[\s_]*(?:اول|أول|الأول|الاول|ثان|ثاني|ثانى|الثاني|الثانى)/u;
/** عبارة تمهيدية بعدها بنود الاتفاق («اتفق الطرفان على الآتى»، «على ما يلى») تسوّغ قبول عنوانين فقط */
const ANNOUNCE_RE = /(?:على|الى|إلى)[\s]+(?:ما[\s]+)?(?:يلي|يلى|الآتي|الاتي|الآتى|الأتي|الاتى)|اتفق[\s]+الطرفان|اتفقا|تم[\s]+الاتفاق/u;

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
 * عنوان ترتيبى شوّهته القراءة الآلية («نالياً» بدل «ثالثاً») يُقبل فقط كالعنوان التالى المتوقَّع بعد تسلسل مقروء فعلاً، بمسافة تحرير ≤ 2،
 * وفى سطر بدايته الكلمة وبعدها نص (لا كلمة عابرة). مقيَّد بالتسلسل فلا يلتقط كلمة عادية إلا إن كانت قريبة جداً من الترتيبى المنتظر.
 */
function extendFuzzy(text: string, run: AltHead[], literal: AltHead[]): AltHead[] {
  const out = [...run];
  const used = new Set(literal.map((h) => h.lineStart));
  for (;;) {
    const want = out[out.length - 1].declaredNumber + 1;
    const word = ADVERB_WORDS.find(([n]) => n === want)?.[1];
    if (!word || word.includes(' ')) break;
    const from = out[out.length - 1].lineStart + 1;
    let found: AltHead | null = null;
    for (const m of text.matchAll(FUZZY_LINE_RE)) {
      const lineStart = m.index ?? 0;
      if (lineStart <= from || used.has(lineStart)) continue;
      const tok = normOrd(m.groups?.tok ?? '');
      if (tok.length < 4 || editDistance(tok, word) > 2) continue;
      const rest = text.slice(lineStart + m[0].length, lineStart + m[0].length + 60).split('\n')[0].trim();
      if (rest.length < 12) continue;
      const raw = m[0];
      const trimmed = raw.replace(/^[ \t]+/, '');
      found = {
        lineStart,
        markerStart: lineStart + (raw.length - trimmed.length),
        marker: ADVERB_DISPLAY[want],
        rawLength: trimmed.length,
        declaredNumber: want,
      };
      break;
    }
    if (!found) break;
    out.push(found);
  }
  return out;
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
    if (PARTY_AFTER_RE.test(after) && PARTY_DESIGNATION_RE.test(after)) continue;
    if (PARTY_AFTER_RE.test(after.slice(0, 40)) && /^[\s:：\-–—.،/]*(?:السادة|السيد|السيدة)/u.test(after)) continue;
    cands.push({
      lineStart,
      markerStart: lineStart + (raw.length - trimmed.length),
      marker: ADVERB_DISPLAY[n], // بلا نقطتين: ما بعد «أولاً:» متن البند لا عنوانه
      rawLength: trimmed.length,
      declaredNumber: n,
    });
  }
  // أطول تسلسل 1،2،3… داخل أى «دورة» (الرقم يعود إلى 1 = دورة جديدة)؛ عند التساوى الأخيرة (متن العقد يلى الديباجة)
  const runs: AltHead[][] = [];
  let cur: AltHead[] = [];
  let want = 1;
  let last = 0;
  for (const c of cands) {
    if (c.declaredNumber <= last && cur.length > 0) {
      runs.push(cur);
      cur = [];
      want = 1;
    }
    last = c.declaredNumber;
    if (c.declaredNumber === want) {
      cur.push(c);
      want++;
    }
  }
  if (cur.length > 0) runs.push(cur);
  let best: AltHead[] = [];
  for (const r of runs) if (r.length >= best.length) best = r;
  if (best.length >= 1) best = extendFuzzy(text, best, cands);
  if (best.length >= 3) return best;
  if (best.length === 2) {
    const before = normForAnnounce(text.slice(Math.max(0, best[0].lineStart - 300), best[0].lineStart));
    if (ANNOUNCE_RE.test(before)) return best;
  }
  return [];
}
