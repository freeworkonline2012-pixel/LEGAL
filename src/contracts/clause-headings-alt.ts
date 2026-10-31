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

const FEMININE: Array<[number, string[]]> = [
  [1, ['الأولى', 'الاولى']],
  [2, ['الثانية']],
  [3, ['الثالثة']],
  [4, ['الرابعة']],
  [5, ['الخامسة']],
  [6, ['السادسة']],
  [7, ['السابعة']],
  [8, ['الثامنة']],
  [9, ['التاسعة']],
  [10, ['العاشرة']],
  [11, ['الحادية عشرة', 'الحادية عشر']],
  [12, ['الثانية عشرة', 'الثانية عشر']],
  [13, ['الثالثة عشرة', 'الثالثة عشر']],
  [14, ['الرابعة عشرة', 'الرابعة عشر']],
  [15, ['الخامسة عشرة', 'الخامسة عشر']],
];

const toInt = (s: string): number => Number(s.replace(/[٠-٩]/g, (d) => String('٠١٢٣٤٥٦٧٨٩'.indexOf(d))));

const NUM = '[0-9٠-٩]{1,3}';
// «المادة 3» / «مادة (3)» / «البند 3» (رقم بالأرقام) — بعدها فاصل اختيارى
const KEYWORD_NUMBER_RE = new RegExp(`^[ \\t]*(?<kw>المادة|مادة|البند|بند)[ \\t]*(?:رقم[ \\t]*)?[(\\[]?(?<num>${NUM})[)\\]]?(?![0-9٠-٩.])[ \\t]*(?<punct>[:：.\\-–—])?`, 'gmu');
// «المادة الأولى» (ترتيبى مؤنث بالكلمات)
const KEYWORD_ORDINAL_RE = new RegExp(
  `^[ \\t]*(?<kw>المادة|مادة)[ \\t]+(?<ord>${FEMININE.flatMap(([, s]) => s)
    .sort((a, b) => b.length - a.length)
    .map((s) => s.replace(/ /g, '[ \\t]+'))
    .join('|')})(?![ء-ي])[ \\t]*(?<punct>[:：.\\-–—])?`,
  'gmu',
);
// «1. العنوان» أو «1) العنوان»: بند رئيسى بترقيم رقمى مجرد (وليس «1.1» الفرعى)
const BARE_NUMBER_RE = new RegExp(`^[ \\t]*(?<num>${NUM})[ \\t]*(?<punct>[.)])(?![0-9٠-٩])[ \\t]*(?=\\S)`, 'gmu');

function ordinalWordToNumber(spelling: string): number | null {
  const n = spelling.replace(/\s+/g, ' ').trim();
  const f = FEMININE.find(([, s]) => s.includes(n));
  return f ? f[0] : null;
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

export function findAlternativeHeads(text: string): AltHead[] {
  const options = [
    chain(toCandidates(text, KEYWORD_NUMBER_RE, 'number')),
    chain(toCandidates(text, KEYWORD_ORDINAL_RE, 'ordinal')),
    chain(toCandidates(text, BARE_NUMBER_RE, 'bare')),
  ];
  // الأطول تسلسلاً، وعند التساوى الأوضح (بكلمة مفتاحية قبل الرقم المجرد)؛ أقل من 3 بنود لا يُعدّ ترقيماً
  const best = options.reduce((a, b) => (b.length > a.length ? b : a), options[0]);
  if (best.length < 3) return [];
  return best.map(({ punct: _p, ...h }) => h);
}
