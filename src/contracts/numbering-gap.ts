/**
 * فجوة الترقيم المُعلَن بين عناوين البنود (13 ثم 18): هل هى بنود لم تُقرأ أم ترقيم العقد المكتوب نفسه يقفز؟
 *
 * الجولة 67. تحذير «ترقيم غير متسلسل» كان يُعامَل دائماً كاحتمال نقص بنود (فيُلصق بالغلاف «التقسيم غير مكتمل» ويحوّل ادعاءات الغياب إلى مرشّحات)،
 * وهو فى عقد قُرئت كل بنوده (15 عنواناً بعدد البنود الفعلى) إنذار كاذب: العقد نفسه كتب «الثالثة عشر» ثم «الثامنة عشر».
 * لا نُجزم بأيٍّ من الاحتمالين من الرقم وحده، بل من أدلة فى النص: (1) إحالة صريحة إلى رقم من أرقام الفجوة («المادة الرابعة عشر»)،
 * (2) فقرات فرعية مرقمة بأرقام الفجوة («14-1»)، (3) بند قبل القفزة متضخم بما يوحى أنه ابتلع بنوداً سقطت عناوينها. وجود أى دليل ⇒ نقص محتمل
 * (السلوك السابق)، وغيابها كلها ⇒ تحذير موسوم بـ{@link NUMBERING_GAP_NO_EVIDENCE_MARK} لا يرفع الغلاف إلى «غير مُقدَّر» ولا يُسقط تأكيد ادعاءات الغياب.
 *
 * ملف نقى بلا أى اعتماد على Nest أو قاعدة البيانات.
 */
import { ORDINALS } from './clause-headings';

/** عبارة ثابتة فى نص التحذير تدل على أن الفجوة بلا أى دليل نصى على نقص (يقرؤها التقرير ومنطق «النص قد يكون ناقصاً»). */
export const NUMBERING_GAP_NO_EVIDENCE_MARK = 'لا دليل فى النص على بنود ناقصة';

/** هل هذا التحذير فجوة ترقيم لا دليل على نقص بنود فيها؟ */
export function isBenignNumberingGapWarning(w: string): boolean {
  return typeof w === 'string' && w.includes(NUMBERING_GAP_NO_EVIDENCE_MARK);
}

const STRIP_DIACRITICS = /[ً-ْـ]/g;

/** توحيد كلمة ترتيبية: أ/إ/آ→ا، ى→ي، وحذف ة/ه الأخيرة من كل كلمة (المؤنث والمذكر سواء: «الخامسة»=«الخامس»). */
function normOrdinal(s: string): string {
  return s
    .replace(STRIP_DIACRITICS, '')
    .replace(/[أإآ]/g, 'ا')
    .replace(/ى/g, 'ي')
    .split(/[\s_]+/)
    .filter(Boolean)
    .map((w) => w.replace(/[ةه]$/, ''))
    .join(' ');
}

const ORDINAL_BY_NORM: Map<string, number> = (() => {
  const m = new Map<string, number>();
  for (const [n, spellings] of ORDINALS) {
    for (const s of spellings) {
      m.set(normOrdinal(s), n);
      m.set(normOrdinal(s.replace(/ون$/, 'ين')), n);
    }
  }
  // «الأولى» المؤنثة تُطبَّع إلى «الاولي» لا «الاول»
  m.set('الاولي', 1);
  m.set('الاول', 1);
  return m;
})();

/** ترتيبى بالكلمات (أى تهجئة، مؤنث أو مذكر) → رقمه، أو null. */
export function ordinalWordsToNumber(words: string): number | null {
  return ORDINAL_BY_NORM.get(normOrdinal(words)) ?? null;
}

export interface NumberingGap {
  /** موضع (1-based) أول بند لا يطابق ترقيمه الموضع */
  position: number;
  /** الرقم المتوقع فى ذلك الموضع */
  expected: number;
  /** الرقم المُعلَن فعلاً */
  found: number;
  /** الأرقام الساقطة بين المتوقَّع والمُعلَن [expected, found) */
  missing: number[];
}

/** أول قفزة إلى الأمام فى أرقام العناوين المُعلَنة (قفزة فقط: التكرار والرجوع ليسا نقص بنود). */
export function findForwardGap(declared: readonly number[]): NumberingGap | null {
  for (let i = 0; i < declared.length; i++) {
    if (declared[i] === i + 1) continue;
    if (declared[i] <= i + 1) return null;
    const missing: number[] = [];
    for (let n = i + 1; n < declared[i]; n++) missing.push(n);
    return { position: i + 1, expected: i + 1, found: declared[i], missing };
  }
  return null;
}

const WORD = '[ء-ي\\u064b-\\u0652\\u0640]+';
// «المادة الرابعة عشر»، «بند رقم 14»، «البند (14)»: كلمة العنوان ثم رقم أو ترتيبى (حتى ثلاث كلمات)
const REFERENCE_ANY_RE = new RegExp(
  `(?<![ء-ي])(?:[وفبكل]?ال|لل)?(?:بند|مادة|ماده)[ \\t]+(?:رقم[ \\t]*)?(?:[(\\[]?(?<num>[0-9٠-٩]{1,2})[)\\]]?(?![0-9٠-٩])|(?<ord>${WORD}(?:[ \\t_]+${WORD}){0,2}))`,
  'gu',
);
const EXTERNAL_AFTER_RE = /^[\s_ـ]*(?:\(?\d+\)?[\s_ـ]*)?من[\s_ـ]+(?:ال)?(?:عقد|قانون|لائحة|لائحه|ملحق|اتفاق|اتفاقية|اتفاقيه|نظام|اللائحة)/u;

const toInt = (s: string): number => Number(s.replace(/[٠-٩]/g, (d) => String('٠١٢٣٤٥٦٧٨٩'.indexOf(d))));

/** أرقام الفجوة التى يحيل إليها المتن صراحةً (إحالة داخلية لا إلى قانون/عقد آخر). */
export function referencedMissingNumbers(text: string, missing: readonly number[]): number[] {
  const want = new Set(missing);
  const found = new Set<number>();
  const re = new RegExp(REFERENCE_ANY_RE.source, REFERENCE_ANY_RE.flags);
  let m: RegExpExecArray | null;
  while ((m = re.exec(text)) !== null) {
    const start = m.index;
    let n: number | null = null;
    // نهاية الجزء المقروء كرقم: منها يُفحص ما بعده بحثاً عن إحالة خارجية («من القانون») وتُستأنف المطابقة التالية
    let end = start + m[0].length;
    if (m.groups?.num) n = toInt(m.groups.num);
    else if (m.groups?.ord) {
      // أطول بادئة من الكلمات تُقرأ ترتيبياً («الرابعة عشر من العقد» ← «الرابعة عشر»)
      const ord = m.groups.ord;
      const words = ord.split(/[ \t_]+/);
      const ordStart = start + m[0].length - ord.length;
      for (let k = words.length; k >= 1 && n === null; k--) {
        n = ordinalWordsToNumber(words.slice(0, k).join(' '));
        if (n !== null) {
          const rawPrefix = new RegExp(`^${WORD}(?:[ \\t_]+${WORD}){${k - 1}}`, 'u').exec(ord);
          end = ordStart + (rawPrefix ? rawPrefix[0].length : 0);
        }
      }
    }
    re.lastIndex = Math.max(end, start + 1);
    if (n === null || !want.has(n)) continue;
    const after = text.slice(end, end + 40);
    if (EXTERNAL_AFTER_RE.test(after)) continue;
    found.add(n);
  }
  return [...found].sort((a, b) => a - b);
}

const SUB_LINE_RE = /(?:^|\n)[ \t‎‏]*(\d{1,2})[ \t]*[-–][ \t]*(\d{1,2})(?![\d/\-–.]\d)(?!\d)/g;

/** أرقام الفجوة التى تحمل فقراتها الفرعية ترقيمها («14-1») فى أول سطر: دليل أن لها بنداً لم يُقرأ عنوانه. */
export function subclauseMissingNumbers(text: string, missing: readonly number[]): number[] {
  const want = new Set(missing);
  const count = new Map<number, number>();
  const hasFirst = new Set<number>();
  for (const m of text.matchAll(SUB_LINE_RE)) {
    const a = Number(m[1]);
    if (!want.has(a)) continue;
    count.set(a, (count.get(a) ?? 0) + 1);
    if (Number(m[2]) === 1) hasFirst.add(a);
  }
  return [...count].filter(([a, c]) => c >= 2 || hasFirst.has(a)).map(([a]) => a).sort((x, y) => x - y);
}

const median = (xs: number[]): number => {
  const s = [...xs].sort((a, b) => a - b);
  return s.length === 0 ? 0 : s.length % 2 ? s[(s.length - 1) / 2] : (s[s.length / 2 - 1] + s[s.length / 2]) / 2;
};

/** حد التضخم: بند قبل القفزة طوله أكبر من 3 أمثال وسيط أطوال البنود وأطول من 1500 حرف قد يكون ابتلع بنوداً سقطت عناوينها. */
const OVERSIZE_FACTOR = 3;
const OVERSIZE_MIN_CHARS = 1500;

export interface GapClause {
  declaredNumber: number | null;
  text: string;
}

export interface GapEvidence {
  referenced: number[];
  subclause: number[];
  oversizedClause: boolean;
  /** هل ثمة أى دليل على نقص بنود */
  any: boolean;
}

/** أدلة النقص حول أول قفزة إلى الأمام. clauses بالترتيب الفعلى للظهور (تشمل البند غير المُرقَّم إن وُجد). */
export function numberingGapEvidence(fullText: string, clauses: readonly GapClause[], gap: NumberingGap): GapEvidence {
  const referenced = referencedMissingNumbers(fullText, gap.missing);
  const subclause = subclauseMissingNumbers(fullText, gap.missing);
  const lengths = clauses.map((c) => c.text.length);
  const med = median(lengths);
  const before = clauses.find((c) => c.declaredNumber === gap.expected - 1) ?? null;
  const oversizedClause = !!before && before.text.length > OVERSIZE_MIN_CHARS && before.text.length > OVERSIZE_FACTOR * Math.max(med, 1);
  return { referenced, subclause, oversizedClause, any: referenced.length > 0 || subclause.length > 0 || oversizedClause };
}

const MISSING_LIST = (missing: readonly number[]): string => (missing.length === 1 ? `${missing[0]}` : `${missing[0]}–${missing[missing.length - 1]}`);

/**
 * نص تحذير الفجوة. يحافظ على صيغة «غير متسلسل بدءاً من الموضع N (متوقَّع X, وُجد Y)» التى يقرؤها التقرير، ثم يختلف الختام:
 * مع دليل ⇒ «يلزم مراجعة بشرية» كما كان؛ بلا دليل ⇒ العبارة الموسومة وشرح ما فُحص.
 */
export function numberingGapWarningText(gap: NumberingGap, ev: GapEvidence | null): string {
  const head = `ترقيم البنود المُعلَن غير متسلسل بدءاً من الموضع ${gap.position} (متوقَّع ${gap.expected}, وُجد ${gap.found})`;
  if (!ev || ev.any) {
    const why: string[] = [];
    if (ev?.referenced.length) why.push(`المتن يحيل إلى البند ${MISSING_LIST(ev.referenced)}`);
    if (ev?.subclause.length) why.push(`فقرات فرعية مرقمة «${ev.subclause[0]}-1» بلا عنوان بند`);
    if (ev?.oversizedClause) why.push('بند قبل القفزة متضخم قياساً بباقى البنود');
    return `${head} — ${why.length ? `${why.join('؛ ')}؛ ` : ''}يلزم مراجعة بشرية.`;
  }
  return `${head} — ${NUMBERING_GAP_NO_EVIDENCE_MARK}: لا إحالة فى المتن ولا فقرة فرعية تشير إلى البند ${MISSING_LIST(gap.missing)} ولا بند متضخم قبل القفزة؛ الأرجح أن ترقيم العقد المكتوب نفسه يقفز (أو شوّهت القراءة كلمة ترتيبية)، فقارن عناوين البنود بالأصل.`;
}
