/**
 * تمييز عناوين البنود المشوَّهة بالقراءة الآلية (OCR) بمحاذاة مرتَّبة (برمجة ديناميكية) بين الأسطر المرشَّحة وتسلسل الأرقام.
 *
 * المشكلة (عقد وساطة ممسوح حقيقى، 17 بنداً): القراءة الآلية للعربية تُخرج العنوان مشوَّهاً — «البن دالاول» و«البندالالث» و«البنسد الرا يسع»
 * و«الند الخامس» و«البندالئثل امن» و«البندالعاث» و«البند الحادى عش» — فلا يطابق أى منها قائمة التهجئات الحرفية، فيلتقط المحرك بنداً أو
 * اثنين ويلصق الباقى بهما: يُقيَّم العقد كله كأنه بندان.
 *
 * الحل: لا نبحث عن «شبه عنوان» فى أى موضع (فيكثر الخطأ)، بل نمشى على أسطر العقد بالترتيب وننتظر فى كل لحظة رقماً بعينه (الأول، ثم ما بعد
 * آخر عنوان قُبل). السطر القصير يُقبل عنواناً إذا اقترب هيكله الحرفى (بعد توحيد الحروف وحذف الفراغات) من «البند + ترتيبى الرقم المنتظر» بمسافة
 * تحرير محدودة نسبة إلى طوله؛ ويُسمح بقفز رقم أو رقمين (عنوان سقط تماماً من القراءة) بعتبة أشد. فلا يُقبل سطر عن رقم غير منتظر، ولا يتكرر رقم، ولا
 * تدخل عناوين المرفقات التى تعيد الترقيم («البند الأول: …» بعد البند السابع عشر).
 *
 * الجولة 46: كان المشى الجشع ينتظر الرقم التالى فقط (حتى +2) فيتوقف عند أول ثلاثة عناوين مشوّهة جداً على خادم الإنتاج (محرك قراءة
 * مختلف يُشوّه العناوين بنمط آخر). صارت المحاذاة شاملة: كل سطر مرشَّح يُوزَن مقابل كل رقم، ويُختار أفضل تسلسل متزايد بعقوبة
 * على الأرقام المتروكة، فيصمد أمام فقد عدة عناوين متتالية دون أن تُقبل سطور غير مرتّبة أو مكرَّرة.
 *
 * ملف نقى بلا اعتماد على Nest أو قاعدة البيانات.
 */
import { ORDINALS, REFERENCE_RE, headingNumbers, ordinalToNumber } from './clause-headings';

export interface AlignedHead {
  lineStart: number;
  markerStart: number;
  /** عنوان قياسى («البند الثالث»)، مع النقطتين إن وردتا فى السطر الأصلى */
  marker: string;
  /** طول نص العلامة كما ورد فى العقد فعلاً */
  rawLength: number;
  declaredNumber: number;
  /** مسافة التحرير عن الهيكل المنتظر؛ 0 = عنوان سليم */
  distance: number;
}

/** هيكل حرفى: بلا تشكيل ولا تطويل ولا فراغات ولا غير العربى، وبتوحيد أ/إ/آ→ا وى→ي وة→ه */
export function skeleton(s: string): string {
  return s
    .replace(/[ً-ْـ]/g, '')
    .replace(/[أإآٱ]/g, 'ا')
    .replace(/ى/g, 'ي')
    .replace(/ة/g, 'ه')
    .replace(/[^ء-ي]/g, '');
}

/** مسافة التحرير (إدراج/حذف/استبدال) مع قطع مبكر حين تتجاوز الحد */
export function editDistance(a: string, b: string, limit: number): number {
  if (Math.abs(a.length - b.length) > limit) return limit + 1;
  let prev = Array.from({ length: b.length + 1 }, (_, j) => j);
  for (let i = 1; i <= a.length; i++) {
    const cur = [i];
    let rowMin = i;
    for (let j = 1; j <= b.length; j++) {
      const v = Math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
      cur.push(v);
      if (v < rowMin) rowMin = v;
    }
    if (rowMin > limit) return limit + 1;
    prev = cur;
  }
  return prev[b.length];
}

/** صيغة المؤنث لترتيبى العدد («الثانى عشر» ← «الثانية عشرة») لعناوين «المادة» */
function feminine(spelling: string): string {
  return spelling
    .split(' ')
    .map((w) => (w === 'الأول' ? 'الأولى' : w.endsWith('ون') ? w : w === 'عشر' ? 'عشرة' : `${w}ة`))
    .join(' ');
}

interface Family {
  /** كلمة العنوان بالهيكل الحرفى */
  word: string;
  /** «البند» أو «المادة» كما تُكتب فى العنوان القياسى */
  label: string;
  spellings: (n: number) => string[];
  targets: ReadonlyMap<number, readonly string[]>;
}

function makeFamily(label: string, convert: (s: string) => string): Family {
  const spellings = (n: number): string[] => (ORDINALS.find(([x]) => x === n)?.[1] ?? []).map(convert);
  return {
    word: skeleton(label),
    label,
    spellings,
    targets: new Map(
      ORDINALS.map(([n]) => [n, [...new Set(spellings(n).map((sp) => `${skeleton(label)}${skeleton(sp)}`))]] as [number, readonly string[]]),
    ),
  };
}

const BAND = makeFamily('البند', (s) => s);
const MADDA = makeFamily('المادة', feminine);
const FAMILIES: readonly Family[] = [BAND, MADDA];

/** أقصى نسبة (مسافة تحرير ÷ طول الهيكل المنتظر) تُقبل لعنوان مشوَّه */
const MAX_RATIO = 0.42;
const MAX_MARKER_CHARS = 34;
const MIN_SKELETON = 7;
const MAX_SKELETON = 24;
const MAX_NUMBER = 30;
/** عقوبة كل رقم متروك بين عنوانين مقبولين (القراءة تُسقط بعض العناوين فلا تكون العقوبة كبيرة) */
const GAP_PENALTY = 0.25;
const INVISIBLE = /[‎‏‪-‮⁦-⁩﻿]/g;

interface NumberOption {
  n: number;
  d: number;
  weight: number;
}

/** أثر كلمة العنوان («البند» أو «المادة») فى أول الهيكل: نافذة من 4 إلى 7 أحرف بمسافة تحرير ≤ 1 (تُسقط «الباب» و«المرفق» وأمثالها) */
function looksLikeWord(sk: string, word: string): boolean {
  for (let len = Math.max(3, word.length - 1); len <= word.length + 1; len++) {
    if (editDistance(sk.slice(0, len), word, 1) <= 1) return true;
  }
  return false;
}

/**
 * كل الأرقام التى يقاربها الهيكل، بعد حذف ما كان أبعد من أقرب رقم بأكثر من درجة واحدة (سطر «البند الأول» فى ملحق قريب من
 * «الأول» فلا يُحسب «الرابع» مشوَّهاً). ترتيب النتيجة بالأفضلية.
 */
function numberOptions(sk: string, family: Family): NumberOption[] {
  const all: NumberOption[] = [];
  for (const [n, targets] of family.targets) {
    let best = Infinity;
    let bestLen = 1;
    for (const t of targets) {
      const limit = Math.floor(t.length * MAX_RATIO);
      const d = editDistance(sk, t, limit);
      if (d <= limit && d < best) {
        best = d;
        bestLen = t.length;
      }
    }
    if (best !== Infinity) all.push({ n, d: best, weight: 1 - (best / bestLen / MAX_RATIO) * 0.6 });
  }
  if (all.length === 0) return [];
  const nearest = Math.min(...all.map((o) => o.d));
  return all.filter((o) => o.d <= nearest + 1).sort((a, b) => a.d - b.d);
}

interface Candidate {
  line: number;
  lineStart: number;
  markerStart: number;
  markerEnd: number;
  rawLength: number;
  colon: string;
  options: NumberOption[];
  sk: string;
  isolated: boolean;
}

function collectCandidates(lines: string[], family: Family): Candidate[] {
  const out: Candidate[] = [];
  let offset = 0;
  for (let li = 0; li < lines.length; li++) {
    const line = lines[li];
    const lineStart = offset;
    offset += line.length + 1;
    const lead = line.length - line.trimStart().length;
    let body = line.trimStart();
    // ختم/شخبطة قرأتها الأداة حرفاً أو رمزاً قبل العنوان: «ش البند الثانى» أو «٠. البند الأول»
    const noise = /^(?:[^ء-ي]+|[ء-ي][ \t]+(?=ال?[بم]))/u.exec(body);
    const skip = noise ? noise[0].length : 0;
    body = body.slice(skip);
    if (body.length === 0 || body.length > 80) continue;
    const punct = /[:：.\-–—]/.exec(body);
    const markerPart = punct ? body.slice(0, punct.index) : body;
    if (markerPart.length > MAX_MARKER_CHARS) continue;
    const sk = skeleton(markerPart);
    if (sk.length < MIN_SKELETON || sk.length > MAX_SKELETON) continue;
    const isolated = (li === 0 || lines[li - 1].trim() === '') && (li === lines.length - 1 || lines[li + 1].trim() === '');
    const colon = punct && (punct[0] === ':' || punct[0] === '：') ? ':' : punct && punct[0] === '.' ? '.' : '';
    out.push({
      line: li,
      lineStart,
      markerStart: lineStart + lead + skip,
      markerEnd: lineStart + lead + skip + markerPart.trimEnd().length + (colon ? 1 : 0),
      rawLength: markerPart.trimEnd().length + (colon ? 1 : 0),
      colon,
      options: looksLikeWord(sk, family.word) ? numberOptions(sk, family) : [],
      sk,
      isolated,
    });
  }
  return out;
}

interface Assigned {
  cand: Candidate;
  n: number;
  d: number;
}

/** أفضل تسلسل متزايد من الأسطر المرشَّحة (برمجة ديناميكية): مجموع الأوزان ناقص عقوبة الأرقام المتروكة */
function alignAnchors(cands: Candidate[]): Assigned[] {
  type Cell = { score: number; prev: { k: number; o: number } | null };
  const table: Cell[][] = cands.map((c) => c.options.map(() => ({ score: -Infinity, prev: null })));
  let bestEnd: { k: number; o: number; score: number } | null = null;
  for (let k = 0; k < cands.length; k++) {
    for (let o = 0; o < cands[k].options.length; o++) {
      const opt = cands[k].options[o];
      let score = opt.weight - GAP_PENALTY * (opt.n - 1);
      let prev: Cell['prev'] = null;
      for (let j = 0; j < k; j++) {
        for (let q = 0; q < cands[j].options.length; q++) {
          const pm = cands[j].options[q];
          if (pm.n >= opt.n) continue;
          const cand = table[j][q].score + opt.weight - GAP_PENALTY * (opt.n - pm.n - 1);
          if (cand > score) {
            score = cand;
            prev = { k: j, o: q };
          }
        }
      }
      table[k][o] = { score, prev };
      if (!bestEnd || score > bestEnd.score) bestEnd = { k, o, score };
    }
  }
  const out: Assigned[] = [];
  let cur: { k: number; o: number } | null = bestEnd ? { k: bestEnd.k, o: bestEnd.o } : null;
  while (cur) {
    const opt = cands[cur.k].options[cur.o];
    out.push({ cand: cands[cur.k], n: opt.n, d: opt.d });
    cur = table[cur.k][cur.o].prev;
  }
  return out.reverse();
}

/**
 * المرتبة الثانية (بين مرساتين فقط): عنوان سقطت أو تشوَّهت كلمة «البند» فيه كلياً («اليتس دك السسسادس») لكن ترتيبيه ظاهر فى آخر
 * السطر. لا تُقبل إلا لسطر معزول بين مرساتين مقبولتين (فرقهما فى الرقم يتّسع له)، وبادئته القصيرة تبدأ بـ«ال» أثراً لـ«البند»،
 * وترتيبيه يطابق الرقم المنتظر بمسافة ≤ 1 (≤ 2 للطويل).
 */
function suffixDistance(sk: string, n: number, family: Family): number | null {
  if (!/^[ال]/.test(sk)) return null;
  const spellings = family.spellings(n);
  let best: number | null = null;
  for (const sp of spellings) {
    const ord = skeleton(sp);
    const tol = ord.length >= 6 ? 2 : 1;
    for (let k = ord.length - tol; k <= ord.length + tol; k++) {
      const prefixLen = sk.length - k;
      if (k < 4 || prefixLen < 2 || prefixLen > 9) continue;
      const d = editDistance(sk.slice(-k), ord, tol);
      if (d <= tol && (best === null || d < best)) best = d;
    }
  }
  return best;
}

function fillGapsBySuffix(anchors: Assigned[], cands: Candidate[], family: Family): Assigned[] {
  const out: Assigned[] = [];
  for (let a = 0; a < anchors.length; a++) {
    out.push(anchors[a]);
    const next = anchors[a + 1];
    if (!next || next.n - anchors[a].n < 2) continue;
    let want = anchors[a].n + 1;
    for (const c of cands) {
      if (c.line <= anchors[a].cand.line || c.line >= next.cand.line || !c.isolated || want >= next.n) continue;
      if (c.options.length > 0) continue; // له قراءة مباشرة لرقم آخر: ليس عنواناً ساقطاً
      const d = suffixDistance(c.sk, want, family);
      if (d === null) continue;
      out.push({ cand: c, n: want, d: d + 1 });
      want++;
    }
  }
  return out;
}

/**
 * عناوين البنود بمحاذاة مرتَّبة. تُرجع قائمة فارغة إن لم يُقبل عنوانان على الأقل. لا تُعدّل النص.
 * تُستعمل بعد الكاشف الحرفى ولا تحل محله إلا حين تجد عناوين أكثر منه (راجع SegmentationService).
 */
export function findAlignedHeads(rawText: string): AlignedHead[] {
  const text = rawText.replace(INVISIBLE, '');
  const lines = text.split('\n');
  let best: { heads: AlignedHead[]; score: number } | null = null;
  // كل عائلة عناوين («البند» ثم «المادة») تُحاذى على حدة؛ يُختار الأعلى مجموع أوزان (عقد واحد يستعمل كلمة عنوان واحدة)
  for (const family of FAMILIES) {
    const cands = collectCandidates(lines, family);
    const withOptions = cands.filter((c) => c.options.length > 0);
    if (withOptions.length < 2) continue;
    const anchors = alignAnchors(withOptions);
    const all = fillGapsBySuffix(anchors, cands, family).filter((x) => x.n <= MAX_NUMBER);
    if (all.length < 2) continue;
    const score = all.reduce((sum, x) => sum + (x.d === 0 ? 1 : 0.7), 0);
    if (!best || score > best.score) {
      best = {
        score,
        heads: all.map((x) => ({
          lineStart: x.cand.lineStart,
          markerStart: x.cand.markerStart,
          marker: `${family.label} ${family.spellings(x.n)[0] ?? ''}${x.cand.colon}`.trim(),
          rawLength: x.cand.rawLength,
          declaredNumber: x.n,
          distance: x.d,
        })),
      };
    }
  }
  return best ? best.heads : [];
}

/**
 * رقم العنوان إن كان هذا السطر وحده عنواناً مشوَّهاً مقبولاً (بلا سياق تسلسل): مطابقة أشد (نسبة ≤ 0.25) وأقرب رقم واحد بلا التباس.
 * لسطور القراءة المتناثرة فقط، ولا يُؤخذ منه إلا ما كان رقماً ناقصاً فعلاً.
 */
export function fuzzyHeadingLineNumber(line: string): number | null {
  const clean = (line ?? '').replace(INVISIBLE, '').trim();
  if (clean.length === 0 || clean.length > 40) return null;
  const c = collectCandidates([clean], BAND)[0];
  if (!c || c.options.length === 0) return null;
  const best = c.options[0];
  if (best.d / (BAND.targets.get(best.n)?.[0].length ?? 1) > 0.25) return null;
  if (c.options.length > 1 && c.options[1].d === best.d) return null; // التباس بين رقمين
  return best.n;
}

/**
 * أرقام البنود الناقصة اعتماداً على القراءة الحرفية والتقريبية معاً، وعلى أعلى رقم تُحيل إليه عبارات «البند X» فى المتن:
 * عقد قُرئ منه العنوانان 1 و2 فقط وتُحيل جملة إلى «البند الخامس» ناقصه 3 و4 و5. تُستعمل لتشغيل مرحلة الاسترجاع على خادم قرأ
 * العناوين أسوأ من المتوقع فلم يظهر فيه فرق ترقيم حرفى.
 */
export function missingHeadingNumbersFuzzy(text: string): number[] {
  const clean = (text ?? '').replace(INVISIBLE, '');
  const have = new Set<number>([...headingNumbers(clean), ...findAlignedHeads(clean).map((h) => h.declaredNumber)]);
  let upper = have.size > 0 ? Math.max(...have) : 0;
  for (const m of clean.matchAll(REFERENCE_RE)) {
    const n = ordinalToNumber(m.groups?.ord ?? '');
    if (n !== null && n <= MAX_NUMBER && n > upper) upper = n;
  }
  const out: number[] = [];
  for (let n = 1; n <= upper; n++) if (!have.has(n)) out.push(n);
  return out;
}

/**
 * «جودة» نص صفحة من حيث عناوين البنود: مجموع أوزان الأسطر الشبيهة بعنوان («البند X» أو «المادة X») ولو مشوَّهة. يُستعمل لاختيار الأوفى
 * من قراءتين لنفس الصفحة بدل عدّ العناوين السليمة حرفياً فقط (قراءة مشوَّهة العناوين كلها تساوى صفراً فتبقى الأولى دائماً).
 */
export function headingLikeScore(pageText: string): number {
  const lines = (pageText ?? '').replace(INVISIBLE, '').split('\n');
  const perFamily = FAMILIES.map((f) => collectCandidates(lines, f).reduce((sum, c) => sum + (c.options[0]?.weight ?? 0), 0));
  return Math.max(...perFamily);
}

/**
 * تشخيص بلا نص عقد إلا الأسطر الشبيهة بعنوان (قصيرة ≤ 34 حرفاً ومشابهة لـ«البند» أو «المادة»): كل سطر مرشَّح مع أقرب رقم ومسافته،
 * و«=>N» = اعتُمد عنواناً برقم N. لمعرفة ما قرأه الخادم فعلاً حين تختلف القراءة الآلية بين البيئات.
 */
export function describeHeadingCandidates(rawText: string, max = 40): string[] {
  const text = rawText.replace(INVISIBLE, '');
  const lines = text.split('\n');
  const used = new Map(findAlignedHeads(text).map((h) => [h.lineStart, h.declaredNumber] as [number, number]));
  const out: string[] = [];
  const seen = new Set<number>();
  for (const family of FAMILIES) {
    for (const c of collectCandidates(lines, family)) {
      if (c.options.length === 0 || seen.has(c.line)) continue;
      seen.add(c.line);
      const o = c.options[0];
      out.push(`L${c.line + 1} ${JSON.stringify(lines[c.line].trim().slice(0, 34))} -> ${o.n}/d${o.d}${used.has(c.lineStart) ? ` =>${used.get(c.lineStart)}` : ''}`);
    }
  }
  return out.sort((a, b) => Number(a.slice(1, a.indexOf(' '))) - Number(b.slice(1, b.indexOf(' ')))).slice(0, max);
}
