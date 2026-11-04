/**
 * تمييز عناوين البنود المشوَّهة بالقراءة الآلية (OCR) بمطابقة تقريبية مقيَّدة بالتسلسل.
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
 * ملف نقى بلا اعتماد على Nest أو قاعدة البيانات.
 */
import { ORDINALS } from './clause-headings';

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

const TARGETS: ReadonlyMap<number, readonly string[]> = new Map(
  ORDINALS.map(([n, spellings]) => [n, [...new Set(spellings.map((s) => `البند${skeleton(s)}`))]] as [number, readonly string[]]),
);

/** نسبة الخطأ المسموحة إلى طول الهدف: الرقم المنتظر، ثم قفزة رقم، ثم قفزة رقمين (أشد لأن الدليل أضعف) */
const RATIO_BY_SKIP = [0.34, 0.25, 0.2];
const MAX_MARKER_CHARS = 34;
const MIN_SKELETON = 7;
const MAX_SKELETON = 24;
const MAX_NUMBER = 30;

function matchExpected(sk: string, expected: number): { n: number; d: number } | null {
  let best: { n: number; d: number } | null = null;
  for (let skip = 0; skip < RATIO_BY_SKIP.length; skip++) {
    const n = expected + skip;
    const targets = TARGETS.get(n);
    if (!targets) continue;
    for (const t of targets) {
      const limit = Math.floor(t.length * RATIO_BY_SKIP[skip]);
      const d = editDistance(sk, t, limit);
      if (d > limit) continue;
      // الأقل مسافة؛ وعند التعادل الأقرب إلى الرقم المنتظر (لا قفز بلا دليل)
      if (!best || d < best.d || (d === best.d && n < best.n)) best = { n, d };
    }
  }
  if (best && best.d > 0 && closerToAnotherNumber(sk, best)) return null;
  return best;
}

/**
 * حارس: إن كان المقطع أقرب إلى ترتيبى رقم آخر (خارج المنتظر) منه إلى الذى طابقناه فهو عنوان حقيقى لرقم آخر لا تشويه
 * (مثل «البند الأول» بعد الثالث = إعادة ترقيم ملحق، لا «الرابع» مشوَّهاً) فيُرفض.
 */
function closerToAnotherNumber(sk: string, best: { n: number; d: number }): boolean {
  for (const [n, targets] of TARGETS) {
    if (n === best.n) continue;
    for (const t of targets) {
      if (editDistance(sk, t, best.d - 1) < best.d) return true;
    }
  }
  return false;
}

/**
 * المرتبة الثانية (للرقم المنتظر بالذات): عنوان سقطت أو تشوَّهت كلمة «البند» فيه كلياً («اليتس دك السسسادس») لكن ترتيبيه ظاهر فى آخر
 * السطر. لا تُقبل إلا لسطر معزول (قبله وبعده سطر فارغ، وهكذا تُخرج القراءة الآلية العناوين)، وبادئته القصيرة تبدأ بـ«ال» كأثر «البند»، وترتيبيه
 * يطابق المنتظر بمسافة ≤ 1 (≤ 2 للطويل). بهذه القيود لا يلتقطها سطر متن قصير ينتهى بكلمة ترتيبية عابرة.
 */
function matchSuffixOrdinal(sk: string, expected: number): { n: number; d: number } | null {
  if (!/^[\u0627\u0644]/.test(sk)) return null;
  const spellings = ORDINALS.find(([n]) => n === expected)?.[1] ?? [];
  let best: number | null = null;
  for (const sp of spellings) {
    const ord = skeleton(sp);
    // ترتيبى طويل (6 أحرف فأكثر) يحتمل خطأين (حرف مكرر «السسسادس» وحرف ساقط)؛ القصير خطأ واحداً فقط
    const tol = ord.length >= 6 ? 2 : 1;
    for (let k = ord.length - tol; k <= ord.length + tol; k++) {
      const prefixLen = sk.length - k;
      if (k < 4 || prefixLen < 2 || prefixLen > 9) continue;
      const d = editDistance(sk.slice(-k), ord, tol);
      if (d <= tol && (best === null || d < best)) best = d;
    }
  }
  return best === null ? null : { n: expected, d: best + 1 };
}

const INVISIBLE = /[‎‏‪-‮⁦-⁩﻿]/g;

/**
 * عناوين البنود بمطابقة مقيَّدة بالتسلسل. تُرجع قائمة فارغة إن لم يُقبل عنوانان على الأقل. لا تُعدّل النص.
 * تُستعمل بعد الكاشف الحرفى ولا تحل محله إلا حين تجد عناوين أكثر منه (راجع SegmentationService).
 */
export function findAlignedHeads(rawText: string): AlignedHead[] {
  const text = rawText.replace(INVISIBLE, '');
  const out: AlignedHead[] = [];
  let expected = 1;
  let offset = 0;
  const lines = text.split('\n');
  for (let li = 0; li < lines.length; li++) {
    const line = lines[li];
    const lineStart = offset;
    offset += line.length + 1;
    const isolated = (li === 0 || lines[li - 1].trim() === '') && (li === lines.length - 1 || lines[li + 1].trim() === '');
    if (expected > MAX_NUMBER) break;
    const lead = line.length - line.trimStart().length;
    let body = line.trimStart();
    // ختم/شخبطة قرأتها الأداة حرفاً أو رمزاً قبل العنوان: «ش البند الثانى» أو «٠. البند الأول»
    const noise = /^(?:[^ء-ي]+|[ء-ي][ \t]+(?=ال?بن))/u.exec(body);
    const skip = noise ? noise[0].length : 0;
    body = body.slice(skip);
    if (body.length === 0 || body.length > 80) continue;
    const punct = /[:：.\-–—]/.exec(body);
    const markerPart = punct ? body.slice(0, punct.index) : body;
    if (markerPart.length > MAX_MARKER_CHARS) continue;
    const sk = skeleton(markerPart);
    if (sk.length < MIN_SKELETON || sk.length > MAX_SKELETON) continue;
    const m = matchExpected(sk, expected) ?? (isolated ? matchSuffixOrdinal(sk, expected) : null);
    if (!m) continue;
    const withColon = punct && (punct[0] === ':' || punct[0] === '：' || punct[0] === '.') ? 1 : 0;
    const canonical = `البند ${TARGET_SPELLING.get(m.n) ?? ''}`.trim();
    out.push({
      lineStart,
      markerStart: lineStart + lead + skip,
      marker: `${canonical}${withColon ? (punct![0] === '.' ? '.' : ':') : ''}`,
      rawLength: markerPart.trimEnd().length + withColon,
      declaredNumber: m.n,
      distance: m.d,
    });
    expected = m.n + 1;
  }
  return out.length >= 2 ? out : [];
}

const TARGET_SPELLING: ReadonlyMap<number, string> = new Map(ORDINALS.map(([n, spellings]) => [n, spellings[0]] as [number, string]));
