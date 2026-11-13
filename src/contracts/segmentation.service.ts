import { Injectable, Logger } from '@nestjs/common';
import { adverbialDiagnostics, findAdverbialHeads, findAlternativeHeads, zeroHeadLinesDump } from './clause-headings-alt';
import { describeHeadingCandidates, editDistance, findAlignedHeads } from './clause-headings-fuzzy';
import { BARE_RE, canonicalHeading, CLAUSE_RE, MAX_REST_AFTER_NOISE_PREFIX, ORDINALS, ordinalToNumber, REFERENCE_RE } from './clause-headings';
import { classifyDocumentKind, documentBundleWarning } from './document-kind';
import { findForwardGap, numberingGapEvidence, numberingGapWarningText } from './numbering-gap';

/** بادئة تسمية الفقرات التقريبية حين لم يُقرأ أى ترقيم فى عقد حقيقى (الجولة 71/72)؛ build.ts يعرف البادئة نفسها. */
export const WHOLE_TEXT_LABEL = 'نص العقد كله (غير مُقسَّم)';
export const APPROX_PARAGRAPH_PREFIX = 'فقرة تقريبية';
export const APPROX_TARGET_CHARS = 250;
export const APPROX_HARD_CHARS = 450;

/**
 * الجولة 72: تقسيم تقريبى لنص عقد بلا عناوين مقروءة إلى فقرات متجاورة (بحسب الأسطر ونهايات الجمل) ليُقيَّم كل موضوع على حدة؛
 * بند واحد بنص العقد كله لم يطابق أى نص قانونى مفهرس (عقد أتعاب من صفحتين: «0 من 1 بنداً قُيِّمت»). الحدود تقريبية وتُعلَن كذلك.
 * لا يقطع سطراً؛ يغلق الفقرة عند نهاية جملة بعد الحد المستهدف، أو عند الحد الأقصى.
 */
export function splitIntoApproxParagraphs(text: string): string[] {
  const lines = text.split('\n').map((l) => l.trim()).filter((l) => l.length > 0);
  const out: string[] = [];
  let cur = '';
  const flush = () => {
    if (cur.trim().length > 0) out.push(cur.trim());
    cur = '';
  };
  for (const line of lines) {
    cur = cur ? `${cur}\n${line}` : line;
    const endsSentence = /[.؟!؛:]\s*$/.test(line);
    if ((cur.length >= APPROX_TARGET_CHARS && endsSentence) || cur.length >= APPROX_HARD_CHARS) flush();
  }
  flush();
  // فقرة أخيرة قصيرة جداً تُضم إلى سابقتها
  if (out.length >= 2 && out[out.length - 1].length < 120) {
    const last = out.pop() as string;
    out[out.length - 1] = `${out[out.length - 1]}\n${last}`;
  }
  return out;
}
export const WHOLE_TEXT_MAX_CHARS = 12000;
export const WHOLE_TEXT_MIN_CHARS = 200;

export interface SegmentedClause {
  index: number;
  declaredNumber: number | null;
  label: string;
  title: string | null;
  text: string;
}

export interface SegmentationResult {
  clauses: SegmentedClause[];
  /** تحذير غير حاجب — مثال: ترقيم غير متسلسل (بند مفقود أو مكرر) يستحق مراجعة بشرية قبل الاعتماد */
  warnings: string[];
  /** نص ما قبل أول بند (ديباجة العقد: تعريف الطرفين)، مقتطع؛ فارغ إن لم يوجد */
  preamble: string;
}

/**
 * تقسيم بنود العقود (Phase 1، بلا LLM) — مبنى على اختبار فعلى ضد 4 عقود
 * مصرية حقيقية (إيجار × 2، خدمات تسويق × 2؛ راجع تقرير الجلسة 2026-09-05)،
 * وليس على افتراض نظرى لشكل العقد المصرى.
 *
 * درسان مستفادان فعلياً من ذلك الاختبار (كلاهما محسوم هنا، لا مؤجَّل):
 *
 * 1) العقود المصرية ترقّم البنود بأعداد ترتيبية مكتوبة بالكلمات ("البند
 *    الرابع عشر")، لا بأرقام كما تفعل مواد القوانين ("المادة 14") — فاحتجنا
 *    جدول تهجئات كامل (مع تغطية "الثانى/الثاني" بالحالتين) بدل regex أرقام
 *    بسيط كان سيفشل بالكامل على البند الأول من أى عقد اختُبر.
 *
 * 2) عنوان بند حقيقى يُطابَق فقط لو ظهر أول السطر/الفقرة — لا فى أى موضع من
 *    النص. اكتُشف هذا فعلياً حين طابقت نسخة أولى من هذا الكود جملة "يتم
 *    تنفيذ أحكام البند السابع عشر من العقد الأصلي..." (إحالة نصية داخل متن
 *    بند آخر فى عقد التسويق الإلكتروني الحقيقى) كحد فاصل خاطئ، فأنتج 13 بنداً
 *    بدل 12 بترقيم غير متسلسل. لأن كل عنوان بند حقيقى فى العقود الأربعة
 *    المفحوصة يبدأ فقرته الخاصة به فعلياً (نفس الطريقة التى يُخزِّن بها Word
 *    الفقرات)، فربط المطابقة ببداية السطر (multiline ^) حل المشكلة جذرياً
 *    بلا أى استثناء يدوى لهذه الحالة بعينها.
 *
 * حدود معروفة وصريحة (لم تُختبَر بعد): عقود تُرقِّم بـ"المادة رقم N" (كالقوانين)
 * بدل "البند"، أو عقود بلا ترقيم صريح إطلاقاً (نقاط/فقرات حرة). الـfallback
 * أدناه (extractPreamble) يمنع فقدان أى نص سابق لأول بند مكتشَف، لكنه لا يحل
 * محل اختبار حقيقى على عيّنة أوسع (15-20 عقداً كما تنص الخطة الأصلية) قبل أى
 * اعتماد نهائى على هذا الموديول وحده.
 */

// علامات الاتجاه غير المرئية التى تضيفها القراءة الآلية وبعض برامج الاستخراج فى أول السطر/آخره.
const INVISIBLE_MARKS_RE = /[\u200e\u200f\u202a-\u202e\u2066-\u2069\ufeff]/g;


interface Head {
  lineStart: number;
  markerStart: number;
  marker: string;
  /** طول نص العلامة كما ورد فى العقد فعلاً (قد يختلف عن marker المُركَّب لعنوان بلا كلمة "البند") */
  rawLength: number;
  declaredNumber: number | null;
  /** عنوان استُرجع من ترقيم الفقرة الفرعية («4-1») لا من عنوان مقروء: لا نص عنوان فى العقد المقروء (rawLength = 0) */
  synthetic?: boolean;
}

// ما يلى رقم البند فى إحالة خارجية: "من العقد الأصلي/السابق"، "من القانون"، "من اللائحة"... ("من هذا العقد" إحالة داخلية)
/**
 * أعلى رقم بند تدل عليه الفقرات الفرعية المرقمة فى أول السطر («10-1» «10-7» «8-3»…): العقود تُرقّم فقراتها «رقم البند-رقم الفقرة»، فإن وصل الرقم
 * الأول إلى 10 والعقد قُسِّم إلى 8 فعناوين بنود لم تُقرأ. ولا يُعتدّ بالرقم إلا إن تكرر على سطرين على الأقل (لا تاريخ ولا رقم عابر).
 * بعض العقود تكتب «1-N» لفقرات البنود الأولى (N = رقم البند)، فإن تتابعت قيم N (3 قيم متميزة فأكثر) حُسبت كذلك.
 */
export function subclauseMaxNumber(text: string): number {
  const re = /(?:^|\n)[ \t\u200e\u200f]*(\d{1,2})[ \t]*[-–][ \t]*(\d{1,2})(?![\d/\-–.]\d)(?!\d)/g;
  const firstCount = new Map<number, number>();
  const afterOne = new Set<number>();
  for (const m of text.matchAll(re)) {
    const a = Number(m[1]);
    const b = Number(m[2]);
    if (a < 1 || a > 60) continue;
    firstCount.set(a, (firstCount.get(a) ?? 0) + 1);
    if (a === 1 && b >= 1 && b <= 60) afterOne.add(b);
  }
  let max = 0;
  for (const [a, c] of firstCount) if (c >= 2 && a > max) max = a;
  if (afterOne.size >= 3) max = Math.max(max, ...afterOne);
  return max;
}


const SUBCLAUSE_LINE = /(?:^|\n)([ \t\u200e\u200f]*)(\d{1,2})[ \t]*[-–][ \t]*(\d{1,2})(?![\d/\-–.]\d)(?!\d)/g;

/**
 * استرجاع حدود بنود لم تُقرأ عناوينها من ترقيم فقراتها الفرعية: العقود تُرقّم فقرات البند N «N-1، N-2…»، فسطر يبدأ بـ«4-1» بين عنوانى البندين 3 و5
 * هو أول فقرة فى البند 4 وعنوانه هو الذى أسقطته القراءة (العناوين المسطّرة تسقط كثيراً فى المسح). يُقبل فقط لرقم ناقص فعلاً ولسطر يقع بين عنوانى
 * البندين المجاورين المقروءين (فلا يتحرك حدّ بند مقروء)، ولا يُقبل رقم بعد آخر بند مقروء إلا إن تكرر على سطرين (لا رقم عابر).
 * عقد يكتب «1-N» لفقرات بنوده الأولى (N = رقم البند) يُقبل بشرط تتابع ثلاث قيم متميزة فأكثر.
 */
function recoverHeadsFromSubclauses(text: string, heads: Head[]): { heads: Head[]; recovered: number[] } {
  const lines: Array<{ offset: number; a: number; b: number }> = [];
  for (const m of text.matchAll(SUBCLAUSE_LINE)) {
    const lead = m[0].startsWith('\n') ? 1 : 0;
    lines.push({ offset: (m.index ?? 0) + lead, a: Number(m[2]), b: Number(m[3]) });
  }
  if (lines.length === 0) return { heads, recovered: [] };
  const oneB = new Set(lines.filter((l) => l.a === 1).map((l) => l.b));
  const schemeB = oneB.size >= 3;
  const firstCount = new Map<number, number>();
  for (const l of lines) firstCount.set(l.a, (firstCount.get(l.a) ?? 0) + 1);

  const out = [...heads].sort((x, y) => x.lineStart - y.lineStart);
  const recovered: number[] = [];
  const known = (): number[] => out.map((h) => h.declaredNumber).filter((n): n is number => n !== null);
  const maxCandidate = Math.max(0, ...[...firstCount].filter(([, c]) => c >= 2).map(([a]) => a), ...(schemeB ? [...oneB] : []));
  for (let n = 1; n <= Math.min(maxCandidate, 60); n++) {
    if (known().includes(n)) continue;
    const before = [...out].filter((h) => h.declaredNumber !== null && h.declaredNumber < n).pop();
    const after = out.find((h) => h.declaredNumber !== null && h.declaredNumber > n);
    // لا يُسترجع بند بين عنوانين متجاورين فى النص غير متتاليين بترتيب ظهورهما (تشويش) ولا قبل أول عنوان مقروء إن لم يكن 1
    const lo = before ? before.lineStart : 0;
    const hi = after ? after.lineStart : text.length;
    if (!after && known().length > 0 && n < Math.max(...known())) continue;
    const trailing = !after;
    // الصيغة «رقم البند-رقم الفقرة» (4-1) أقوى دليلاً من «1-N»: القراءة الآلية تقلب «10-1» إلى «1-10» فى الإحالات داخل المتن («البند الفرعى 10-1»)
    const inA = lines.filter((l) => l.offset > lo && l.offset < hi && l.a === n);
    const inWindow = inA.length > 0 ? inA : lines.filter((l) => l.offset > lo && l.offset < hi && schemeB && l.a === 1 && l.b === n && n <= 9);
    if (inWindow.length === 0) continue;
    if (trailing && n > 1 && (firstCount.get(n) ?? 0) < 2 && !(schemeB && oneB.has(n))) continue;
    const at = inWindow[0].offset;
    // العنوان المسترجع لا يُقبل إن كان أول فقرة فى البند 1 يسبق ديباجة طويلة بلا أى عنوان (تخمين)، إلا بدليل «1-1» نفسه
    const label = canonicalHeading(n);
    if (!label) continue;
    out.push({ lineStart: at, markerStart: at, marker: label, rawLength: 0, declaredNumber: n, synthetic: true });
    out.sort((x, y) => x.lineStart - y.lineStart);
    recovered.push(n);
  }
  return { heads: out, recovered };
}

const EXTERNAL_REFERENCE_RE = /^[\s_\u0640]*من[\s_\u0640]+(?:ال)?(?:عقد|قانون|لائحة|لائحه|ملحق|اتفاق|اتفاقية|اتفاقيه|نظام|اللائحة)/u;

/** يضيف إلى العناوين الحرفية عناوين المطابقة التقريبية لأرقام غائبة عنها، إن بقى الترتيب متزايداً؛ وإلا يُرجع الأصل بلا إضافة. */
export function fillGapsFromAligned<H extends { lineStart: number; declaredNumber: number | null }>(
  literal: H[],
  aligned: Array<H>,
): { heads: H[]; added: number[] } {
  const have = new Set(literal.map((h) => h.declaredNumber));
  const lines = new Set(literal.map((h) => h.lineStart));
  const extra = aligned.filter((a) => a.declaredNumber !== null && !have.has(a.declaredNumber) && !lines.has(a.lineStart));
  if (extra.length === 0) return { heads: literal, added: [] };
  const all = [...literal, ...extra].sort((x, y) => x.lineStart - y.lineStart);
  for (let i = 1; i < all.length; i++) {
    const a = all[i - 1].declaredNumber;
    const b = all[i].declaredNumber;
    if (a === null || b === null || b <= a) return { heads: literal, added: [] };
  }
  return { heads: all, added: extra.map((e) => e.declaredNumber as number) };
}

const ORD_NORM = (w: string): string =>
  w
    .replace(/[\u064b-\u0652\u0640]/g, '')
    .replace(/[أإآ]/g, 'ا')
    .replace(/ى/g, 'ي')
    .replace(/ة/g, 'ه')
    .trim();
/** سطر عنوان ملحق مرقَّم فى بدايته («ملحق(4) ...» أو «ملحق رقم 2») */
const ANNEX_HEAD_RE = /^[ \t]*(?:ال)?ملحق[ \t]*(?:رقم)?[ \t]*[(\[]?[ \t]*(?<no>[0-9٠-٩]{1,2})[ \t]*[)\]]?(?=[ \t]|$)/mu;
/** كلمات تسبق ترتيبياً فى جملة عادية («الطرف الخامس»)؛ سطر بها ليس عنوان بند. */
const NOT_A_HEADING_PREFIX = /^(?:ال)?(?:طرف|شريك|مرحله|دفعه|قسط|جزء|فقره|نسخه|شخص|متهم|مدعي|عميل|مستند)$/;

/**
 * الجولة 80: عنوان بند ضاعت منه كلمة «البند» أو قُرئت رمزاً غير لاتينى («Rent الخامس» فى الجولة 77، وفى إنتاج الجولة 79 سطر لم يلتقطه لا الكاشف الحرفى
 * ولا المطابقة التقريبية فبقى «الخامس» ملتصقاً بالرابع): بحث موجَّه بالتسلسل عن الرقم الناقص n بين عنوانى n-1 وما بعد n المقروءين؛ يُقبل أول سطر قصير
 * (≤ 28 حرفاً) آخر كلمة فيه هى ترتيبى n (مطابقة تامة أو بخطأ حرف واحد لا يلتبس بترتيبى آخر) تسبقها كلمة أو كلمتان ضوضاء قصيرتان بلا أرقام، وليس فى
 * آخره علامة جملة ولا سبقته كلمة تدل على جملة عادية («الطرف الخامس»). يشترط وجود عنوان مقروء بعد الرقم (فلا يُخمَّن بند أخير) وسطر تالٍ للعنوان.
 * فاشل الأمان: لا مرشح ⇒ لا تغيير، والتنبيه الصريح يصاحب أى استرجاع.
 */
export function recoverNoisyOrdinalHeads<H extends { lineStart: number; markerStart: number; marker: string; rawLength: number; declaredNumber: number | null }>(
  text: string,
  heads: H[],
): { heads: H[]; recovered: number[] } {
  const out = [...heads].sort((a, b) => a.lineStart - b.lineStart);
  const recovered: number[] = [];
  const max = Math.max(0, ...out.map((h) => h.declaredNumber ?? 0));
  for (let n = 2; n < max && n <= 10; n++) {
    if (out.some((h) => h.declaredNumber === n)) continue;
    const before = out.filter((h) => h.declaredNumber !== null && h.declaredNumber === n - 1).pop();
    const after = out.find((h) => h.declaredNumber !== null && h.declaredNumber > n && before !== undefined && h.lineStart > before.lineStart);
    if (!before || !after) continue;
    const wanted = ORDINALS.find(([num]) => num === n)?.[1].filter((sp) => !sp.includes(' ')).map((sp) => ORD_NORM(sp).replace(/^ال/, '')) ?? [];
    const others = ORDINALS.filter(([num]) => num !== n && num <= 10).flatMap(([, sp]) => sp.map((x) => ORD_NORM(x).replace(/^ال/, '')));
    if (wanted.length === 0) continue;
    const winStart = text.indexOf('\n', before.lineStart);
    if (winStart === -1) continue;
    let pos = winStart + 1;
    while (pos < after.lineStart) {
      const nl = text.indexOf('\n', pos);
      const lineEnd = nl === -1 || nl > after.lineStart ? after.lineStart : nl;
      const raw = text.slice(pos, lineEnd);
      const lead = raw.length - raw.trimStart().length;
      const line = raw.trim();
      const next = nl === -1 ? '' : text.slice(nl + 1, after.lineStart).trim();
      const at = pos + lead;
      pos = lineEnd + 1;
      if (line.length === 0 || line.length > 28 || next.length === 0) continue;
      if (/[.،,؛;!؟?]$/.test(line) && !/[:.]$/.test(line)) continue;
      const tokens = line.replace(/[:.\-–_]+$/, '').split(/[ \t]+/).filter(Boolean);
      if (tokens.length === 0 || tokens.length > 3) continue;
      const last = ORD_NORM(tokens[tokens.length - 1]).replace(/^ال/, '');
      const prefix = tokens.slice(0, -1);
      if (prefix.some((t) => t.length > 8 || /[0-9٠-٩]/.test(t) || NOT_A_HEADING_PREFIX.test(ORD_NORM(t)))) continue;
      if (/[0-9٠-٩]/.test(last)) continue;
      const exact = wanted.includes(last);
      const near = !exact && last.length >= 4 && wanted.some((w) => editDistance(last, w, 1) <= 1) && !others.some((o) => editDistance(last, o, 1) <= 1);
      if (!exact && !near) continue;
      const label = canonicalHeading(n);
      if (!label) break;
      out.push({ ...before, lineStart: at, markerStart: at, marker: label, rawLength: line.length, declaredNumber: n, synthetic: false } as H);
      out.sort((a, b) => a.lineStart - b.lineStart);
      recovered.push(n);
      break;
    }
  }
  return { heads: out, recovered };
}

/**
 * الجولة 82: عنوان بند ضاع من القراءة الآلية كلياً (سطره فارغ فى نص الإنتاج: «gap window» بين البندين الرابع والسادس أظهر متن الرابع ثم سطراً فارغاً ثم
 * «يلتزم الطرف…»، فلا شىء يُطابَق عنواناً). الدليل البنيوى الوحيد فاصل الفقرات: بين عنوانى n-1 وما بعد آخر رقم ناقص تتتالى أرقام ناقصة k ويقع فى النافذة
 * بالضبط k فواصل فقرات (k+1 فقرة، كل منها ≥ 25 حرفاً) فيبدأ كل رقم ناقص عند فقرة بعد الأولى. k ≤ 2. أى التباس (فقرات أكثر أو أقل) ⇒ لا تغيير.
 * العنوان المسترجع تركيبى (rawLength = 0) والتنبيه الصريح يصاحبه: حدّ البند تقريبى ويلزم مقارنته بالأصل.
 */
export function recoverHeadsFromParagraphBreaks<H extends { lineStart: number; markerStart: number; marker: string; rawLength: number; declaredNumber: number | null }>(
  text: string,
  heads: H[],
): { heads: H[]; recovered: number[] } {
  const out = [...heads].sort((a, b) => a.lineStart - b.lineStart);
  const recovered: number[] = [];
  const known = (): Set<number> => new Set(out.map((h) => h.declaredNumber).filter((n): n is number => n !== null));
  const max = Math.max(0, ...known());
  for (let n = 2; n < max; n++) {
    if (known().has(n) || !known().has(n - 1)) continue;
    let m = n;
    while (m + 1 < max && !known().has(m + 1)) m++;
    const k = m - n + 1;
    const before = out.find((h) => h.declaredNumber === n - 1);
    const after = out.find((h) => h.declaredNumber === m + 1);
    if (!before || !after || k > 2 || after.lineStart <= before.lineStart) continue;
    const lineEnd = text.indexOf('\n', before.lineStart);
    if (lineEnd === -1) continue;
    const paragraphs: Array<{ at: number; len: number; endsSentence: boolean }> = [];
    let pos = lineEnd + 1;
    let blankBefore = true;
    let cur: { at: number; len: number; endsSentence: boolean } | null = null;
    while (pos < after.lineStart) {
      const nl = text.indexOf('\n', pos);
      const end = nl === -1 || nl > after.lineStart ? after.lineStart : nl;
      const raw = text.slice(pos, end);
      const t = raw.trim();
      if (t.length === 0) {
        blankBefore = true;
        cur = null;
      } else if (blankBefore || cur === null) {
        cur = { at: pos + (raw.length - raw.trimStart().length), len: t.length, endsSentence: /[.:؛]$/.test(t) };
        paragraphs.push(cur);
        blankBefore = false;
      } else {
        cur.len += t.length;
        cur.endsSentence = /[.:؛]$/.test(t);
      }
      pos = end + 1;
    }
    // الجولة 86: «ذيل» فقرة: سطر قصير (< 25 حرفاً) ينتهى بنقطة وقع بعد فراغ (آخر سطر من متن البند السابق انفصل عنه فى القراءة: «بصدر هذا العقد .» فى البند 15 من عقد وكالة،
    // فصار فى نص الإنتاج «فقرة» ثالثة وامتنع الاسترجاع) يُضم إلى الفقرة التى قبله ولا يُعد فقرة مستقلة؛ العنوان لا ينتهى بنقطة ولا يقصر هذا القصر فى هذا الموضع.
    for (let i = paragraphs.length - 1; i > 0; i--) {
      if (paragraphs[i].len < 25 && paragraphs[i].endsSentence) {
        paragraphs[i - 1].len += paragraphs[i].len;
        paragraphs[i - 1].endsSentence = true;
        paragraphs.splice(i, 1);
      }
    }
    if (paragraphs.length !== k + 1 || paragraphs.some((p) => p.len < 25)) continue;
    for (let i = 0; i < k; i++) {
      const label = canonicalHeading(n + i);
      if (!label) break;
      const p = paragraphs[i + 1];
      out.push({ ...before, lineStart: p.at, markerStart: p.at, marker: label, rawLength: 0, declaredNumber: n + i, synthetic: true } as H);
      recovered.push(n + i);
    }
    out.sort((a, b) => a.lineStart - b.lineStart);
  }
  return { heads: out, recovered };
}

/**
 * الجولة 83: عنوان بند قُرئ سطراً قصيراً تالفاً لا يشبه أى ترتيبى («T P» و«PN» فى عقد بيع ممسوح فالتصق متن البند الثالث بالثانى فنُسبت دفعات الثمن
 * إلى «البند الثانى»؛ و«geil البنسد» فى عقد وكالة). الدليل البنيوى: سطر قصير (≤ 16 حرفاً) معزول بفراغ قبله وتالٍ له متن (≥ 20 حرفاً)، فى النافذة بين
 * عنوانى n-1 وما بعد آخر رقم ناقص (k ≤ 2). يُقبل فقط إن كان عدد هذه الأسطر k بالضبط (أى التباس ⇒ لا تغيير)، وليس رقم صفحة ولا ضوضاء لاتينية طويلة
 * («Office Supplies»)، ويسبقه ويليه متن (≥ 40 حرفاً). التنبيه الصريح يصاحب أى استرجاع.
 */
const ISOLATED_MAX_LEN = 20;
/** الجولة 84: أقصى عدد أرقام ناقصة متتالية يُقبل استرجاعها (كانت 2؛ عقد بيع ضاعت فيه عناوين 5 و6 و7 معاً). يلازمه شرط «عدد الأسطر = العدد الناقص بالضبط». */
const ISOLATED_MAX_MISSING = 4;
function isIsolatedHeadingNoise(line: string): boolean {
  const t = line.trim();
  if (t.length < 2 || t.length > ISOLATED_MAX_LEN) return false;
  if (/[.،,؛;!؟?]$/.test(t)) return false;
  if (!/[A-Za-z\u0621-\u064A]{2,}|[A-Za-z]\s+[A-Za-z]/.test(t)) return false; // أرقام/رموز فقط (رقم صفحة)
  const compact = t.replace(/\s+/g, '');
  const letters = (compact.match(/[A-Za-z\u0621-\u064A]/g) ?? []).length;
  if (letters < compact.length * 0.7) return false; // سطر أرقام ورموز غالباً (هاتف/فاكس/ترويسة)
  const tokens = t.split(/[ \t]+/).filter(Boolean);
  // ترويسة لاتينية خالصة («Office Supplies») ليست عنواناً؛ أما عنوان كبير تالف قُرئ لاتينياً («T P»، «oalall o gl» فى إنتاج عقد البيع) فيحوى دائماً رمزاً من حرف أو حرفين
  if (!/[\u0621-\u064A]/.test(t) && tokens.some((x) => /[A-Za-z]{4,}/.test(x)) && !tokens.some((x) => x.length <= 2)) return false;
  if (tokens.some((x) => x.length > 8)) return false;
  return true;
}
/** رقم عنوان تالف يحمل رقمه صراحةً: رمز عددى مستقل (1-2 خانة) يساوى رقماً ناقصاً، ومع الأرقام فوق 10 كلمة «عشر» فى السطر نفسه. */
function numberCarriedByHeadingLine(line: string, missing: ReadonlySet<number>): number | null {
  const nums = (line.match(/(?<![0-9٠-٩])[0-9٠-٩]{1,2}(?![0-9٠-٩])/g) ?? []).map((d) => Number(d.replace(/[٠-٩]/g, (x) => String('٠١٢٣٤٥٦٧٨٩'.indexOf(x)))));
  const hit = nums.filter((v) => missing.has(v));
  if (hit.length !== 1) return null;
  if (hit[0] > 10 && !/عش/.test(line)) return null;
  return hit[0];
}
/** فقرة فرعية تبدأ برقم البند الناقص («5 يلتزم الطرف…» قُرئت من «1/5»): دليل أن العنوان السابق مباشرةً هو عنوان هذا البند. */
function numberOfFollowingSubItem(nextLine: string, missing: ReadonlySet<number>): number | null {
  const m = /^\s*([0-9٠-٩]{1,2})(?![0-9٠-٩])[\s.\-/)]*[ء-ي]/.exec(nextLine);
  if (!m) return null;
  const v = Number(m[1].replace(/[٠-٩]/g, (x) => String('٠١٢٣٤٥٦٧٨٩'.indexOf(x))));
  return missing.has(v) ? v : null;
}
export function recoverHeadsFromIsolatedShortLines<H extends { lineStart: number; markerStart: number; marker: string; rawLength: number; declaredNumber: number | null }>(
  text: string,
  heads: H[],
): { heads: H[]; recovered: number[] } {
  const out = [...heads].sort((a, b) => a.lineStart - b.lineStart);
  const recovered: number[] = [];
  const known = (): Set<number> => new Set(out.map((h) => h.declaredNumber).filter((n): n is number => n !== null));
  const max = Math.max(0, ...known());
  for (let n = 2; n < max; n++) {
    if (known().has(n) || !known().has(n - 1)) continue;
    let m = n;
    while (m + 1 < max && !known().has(m + 1)) m++;
    const k = m - n + 1;
    const before = out.find((h) => h.declaredNumber === n - 1);
    const after = out.find((h) => h.declaredNumber === m + 1);
    if (!before || !after || k > ISOLATED_MAX_MISSING || after.lineStart <= before.lineStart) continue;
    const lineEnd = text.indexOf('\n', before.lineStart);
    if (lineEnd === -1) continue;
    const lines: Array<{ at: number; end: number; t: string }> = [];
    let pos = lineEnd + 1;
    while (pos < after.lineStart) {
      const nl = text.indexOf('\n', pos);
      const end = nl === -1 || nl > after.lineStart ? after.lineStart : nl;
      const raw = text.slice(pos, end);
      lines.push({ at: pos + (raw.length - raw.trimStart().length), end, t: raw.trim() });
      pos = end + 1;
    }
    const cands: Array<{ at: number; len: number; text: string; nextText: string }> = [];
    for (let i = 0; i < lines.length; i++) {
      const prevBlank = i === 0 ? false : lines[i - 1].t.length === 0;
      if (!isIsolatedHeadingNoise(lines[i].t)) continue;
      // الجولة 84: نص الإنتاج لعقد البيع بلا أسطر فارغة بين البنود 4 و8 (أرقام L83..L96 متتالية)، فلا يُشترط الفراغ قبل السطر؛ يُعوَّض بأدلة أشد:
      // سطر سابق متن كامل (≥ 25 حرفاً: ليس بداية فقرة) وفى السطر رمز لاتينى مخلوط (gl/oa/silt/«T P») وهو بصمة العنوان الكبير الممسوح.
      // لا يُقبل ترتيبى قريب هنا: الأسطر ذات الترتيبى لها بحث الجولة 80 الأضيق («الطرف الخامس» جملة لا عنوان).
      if (!prevBlank && (i === 0 || lines[i - 1].t.length < 25 || !/[A-Za-z]/.test(lines[i].t))) continue;
      const nextBody = lines.slice(i + 1).find((l) => l.t.length > 0);
      if (!nextBody || nextBody.t.length < 20) continue;
      const bodyBefore = text.slice(lineEnd, lines[i].at).replace(/\s+/g, '').length;
      const bodyAfter = text.slice(lines[i].end, after.lineStart).replace(/\s+/g, '').length;
      if (bodyBefore < 40 || bodyAfter < 40) continue;
      cands.push({ at: lines[i].at, len: lines[i].t.length, text: lines[i].t, nextText: nextBody.t });
    }
    if (cands.length !== k) {
      // الجولة 85: عدد المرشحين لا يساوى عدد الأرقام الناقصة (عنوان ضاع كلياً أو سطره لا يشبه عنواناً): يُسترجع فقط المرشح الذى يحمل رقمه بنفسه
      // («gulalla 3¢ 11 غعشر»: الرقم 11 + «عشر» فى عقد البيع) أو الذى يليه مباشرةً سطر فقرة فرعية تبدأ برقمه («5 يلتزم الطرف…» أى 1/5)؛ والباقى يبقى فى تنبيه الفجوة.
      const missingSet = new Set(Array.from({ length: k }, (_, i) => n + i));
      const taken = new Set<number>();
      for (const c of cands) {
        const own = numberCarriedByHeadingLine(c.text, missingSet) ?? numberOfFollowingSubItem(c.nextText, missingSet);
        if (own === null || taken.has(own)) continue;
        const label = canonicalHeading(own);
        if (!label) continue;
        taken.add(own);
        out.push({ ...before, lineStart: c.at, markerStart: c.at, marker: label, rawLength: c.len, declaredNumber: own, synthetic: false } as H);
        recovered.push(own);
      }
      out.sort((a, b) => a.lineStart - b.lineStart);
      continue;
    }
    for (let i = 0; i < k; i++) {
      const label = canonicalHeading(n + i);
      if (!label) break;
      out.push({ ...before, lineStart: cands[i].at, markerStart: cands[i].at, marker: label, rawLength: cands[i].len, declaredNumber: n + i, synthetic: false } as H);
      recovered.push(n + i);
    }
    out.sort((a, b) => a.lineStart - b.lineStart);
  }
  return { heads: out, recovered };
}

/**
 * الجولة 87: عنوان بند ضاع كلياً من نص الإنتاج بلا سطر فارغ ولا سطر قصير (عقد بيع: عنوانا البندين 7 و12 كبيرا الخط لم يخرجا فى القراءة أصلاً وأرقام الأسطر متتالية).
 * الدليل البنيوى الوحيد المتبقى: النص المسطور مضبوط العرض، فآخر سطر فى كل فقرة أقصر بوضوح من أسطره الكاملة، والعنوان الضائع لا يقع إلا بعد نهاية فقرة.
 * شروط صارمة (أى التباس ⇒ لا تغيير): رقم ناقص واحد فقط بين عنوانين مقروءين؛ 4 أسطر متنية على الأقل (سطر < 8 أحرف ضوضاء/توقيع يُهمل)؛ وسيط طول الأسطر ≥ 45؛
 * عدد الأسطر «الأقصر من 0.7 الوسيط» داخل النافذة (غير آخر سطر فيها) = 1 بالضبط، ويليه سطر كامل (≥ 0.8 الوسيط)، وفى كل من جانبيه متن ≥ 40 حرفاً.
 * العنوان المسترجع تركيبى (rawLength = 0) والتنبيه الصريح يصاحبه: حدّ البند تقريبى ويلزم مقارنته بالأصل.
 */
export function recoverHeadsFromRaggedLines<H extends { lineStart: number; markerStart: number; marker: string; rawLength: number; declaredNumber: number | null }>(
  text: string,
  heads: H[],
): { heads: H[]; recovered: number[] } {
  const out = [...heads].sort((a, b) => a.lineStart - b.lineStart);
  const recovered: number[] = [];
  const known = (): Set<number> => new Set(out.map((h) => h.declaredNumber).filter((n): n is number => n !== null));
  const max = Math.max(0, ...known());
  for (let n = 2; n < max; n++) {
    if (known().has(n) || !known().has(n - 1) || !known().has(n + 1)) continue;
    const before = out.find((h) => h.declaredNumber === n - 1);
    const after = out.find((h) => h.declaredNumber === n + 1);
    if (!before || !after || after.lineStart <= before.lineStart) continue;
    const lineEnd = text.indexOf('\n', before.lineStart);
    if (lineEnd === -1) continue;
    const lines: Array<{ at: number; t: string }> = [];
    let pos = lineEnd + 1;
    let blankInside = false;
    let pendingBlank = false;
    while (pos < after.lineStart) {
      const nl = text.indexOf('\n', pos);
      const end = nl === -1 || nl > after.lineStart ? after.lineStart : nl;
      const raw = text.slice(pos, end);
      const t = raw.trim();
      if (t.length === 0) pendingBlank = true;
      else if (t.length >= 8) {
        if (pendingBlank && lines.length > 0) blankInside = true;
        pendingBlank = false;
        lines.push({ at: pos + (raw.length - raw.trimStart().length), t });
      }
      pos = end + 1;
    }
    // وجود فراغ بين أسطر المتن يعنى أن لبنية الفقرات الصريحة (الجولة 82) الأولوية؛ هذا الاسترجاع للنص المتصل بلا فراغ فقط
    if (blankInside || lines.length < 4) continue;
    const sorted = lines.map((l) => l.t.length).sort((a, b) => a - b);
    const median = sorted[Math.floor(sorted.length / 2)];
    if (median < 45) continue;
    const ragged: number[] = [];
    for (let i = 0; i < lines.length - 1; i++) if (lines[i].t.length < 0.7 * median) ragged.push(i);
    if (ragged.length !== 1) continue;
    const i = ragged[0];
    const next = lines[i + 1];
    if (next.t.length < 0.8 * median) continue;
    const bodyBefore = lines.slice(0, i + 1).reduce((a, l) => a + l.t.replace(/\s+/g, '').length, 0);
    const bodyAfter = lines.slice(i + 1).reduce((a, l) => a + l.t.replace(/\s+/g, '').length, 0);
    if (bodyBefore < 40 || bodyAfter < 40) continue;
    const label = canonicalHeading(n);
    if (!label) continue;
    out.push({ ...before, lineStart: next.at, markerStart: next.at, marker: label, rawLength: 0, declaredNumber: n, synthetic: true } as H);
    out.sort((a, b) => a.lineStart - b.lineStart);
    recovered.push(n);
  }
  return { heads: out, recovered };
}

/**
 * الجولة 90: عنوان البند الأول ضاع من القراءة الآلية (مقاولة ممسوحة: «المادة الأولى» تالفة فخرج العقد بـ14 من 15 بنداً وكتلة غير مقسَّمة قبل الثانى تضم الديباجة والبند الأول).
 * الدليل البنيوى: أول عنوان مقروء رقمه 2 (الأول ناقص بالتحديد)، وفى النص السابق له فقرة تعريف الأطراف المنتهية بعبارة «الطرف الثانى»؛ فأول سطر يلى نهاية تلك الفقرة هو بداية البند الأول،
 * بشرط أن يبقى بينه وبين العنوان 2 متن ≥ 60 حرفاً. إن كان السطر قصيراً (≤ 24 حرفاً، بلا نقطة ختامية) ويتلوه متن فهو عنوان البند التالف ويُستهلك؛ وإلا العنوان ضائع بلا أثر ويبدأ البند من السطر نفسه.
 * أى التباس (لا فقرة أطراف، لا سطر تالٍ، متن قصير) ⇒ لا تغيير، فيبقى سلوك الكتلة غير المقسَّمة السابق. التنبيه الصريح يصاحب الاسترجاع.
 */
const SECOND_PARTY_RE = /(?:الطرف|طرف)[\s_]*(?:ال)?(?:ثان|ثاني|ثانى|ثانيه|ثانية)/u;
export function recoverFirstHead<H extends { lineStart: number; markerStart: number; marker: string; rawLength: number; declaredNumber: number | null }>(
  text: string,
  heads: H[],
): { heads: H[]; recovered: number[] } {
  const out = [...heads].sort((a, b) => a.lineStart - b.lineStart);
  const first = out[0];
  if (!first || first.declaredNumber !== 2 || out.some((h) => h.declaredNumber === 1)) return { heads: out, recovered: [] };
  const label = canonicalHeading(1);
  if (!label) return { heads: out, recovered: [] };
  const lines: Array<{ at: number; raw: string }> = [];
  let pos = 0;
  while (pos < first.lineStart) {
    const nl = text.indexOf('\n', pos);
    const end = nl === -1 || nl > first.lineStart ? first.lineStart : nl;
    lines.push({ at: pos, raw: text.slice(pos, end) });
    pos = end + 1;
  }
  // عبارة «الطرف الثانى» قد تنكسر بين سطرين («الطرف» / «الثانى») فيُبحث فى النص السابق كله لا فى كل سطر منفرداً
  const leadingText = text.slice(0, first.lineStart);
  const pm = SECOND_PARTY_RE.exec(leadingText);
  if (!pm) return { heads: out, recovered: [] };
  const partyEnd = pm.index + pm[0].length;
  const partyIdx = lines.findIndex((l, k) => l.at <= partyEnd && (k === lines.length - 1 || lines[k + 1].at > partyEnd));
  if (partyIdx === -1) return { heads: out, recovered: [] };
  // نهاية فقرة الأطراف: أول سطر (من سطر التعريف فصاعداً) ينتهى بعلامة وقف، أو يليه سطر فارغ
  let endIdx = partyIdx;
  while (endIdx < lines.length - 1 && !/[.:؛)][\s\u200e\u200f]*$/.test(lines[endIdx].raw.trimEnd()) && lines[endIdx + 1].raw.trim().length > 0) endIdx++;
  let j = endIdx + 1;
  while (j < lines.length && lines[j].raw.trim().length === 0) j++;
  if (j >= lines.length) return { heads: out, recovered: [] };
  const cand = lines[j];
  const candText = cand.raw.trim();
  const bodyFrom = cand.at;
  if (first.lineStart - bodyFrom < 60) return { heads: out, recovered: [] };
  const lead = cand.raw.length - cand.raw.trimStart().length;
  const nextLine = lines.slice(j + 1).find((l) => l.raw.trim().length > 0)?.raw.trim() ?? '';
  const shortMarker = candText.length <= 24 && !/[.،؛]$/.test(candText) && nextLine.length >= 20;
  const head = shortMarker
    ? ({ ...first, lineStart: cand.at, markerStart: cand.at + lead, marker: label, rawLength: candText.length, declaredNumber: 1, synthetic: false } as H)
    : ({ ...first, lineStart: cand.at, markerStart: cand.at + lead, marker: label, rawLength: 0, declaredNumber: 1, synthetic: true } as H);
  out.unshift(head);
  return { heads: out, recovered: [1] };
}

/** تشخيص بلا نص عقد (أرقام وبداية قصيرة فقط): أسطر النافذة بين عنوانى الرقم الناقص، لمعرفة كيف قُرئ العنوان الضائع. */
export function describeGapWindow(text: string, heads: Array<{ lineStart: number; declaredNumber: number | null }>, missing: number): string {
  const sorted = [...heads].sort((a, b) => a.lineStart - b.lineStart);
  const before = sorted.filter((h) => h.declaredNumber !== null && h.declaredNumber < missing).pop();
  const after = sorted.find((h) => h.declaredNumber !== null && h.declaredNumber > missing);
  if (!before) return 'no-before';
  const lo = text.indexOf('\n', before.lineStart);
  const hi = after ? after.lineStart : Math.min(text.length, (lo === -1 ? 0 : lo) + 800);
  if (lo === -1) return 'no-window';
  const firstLine = text.slice(0, before.lineStart).split('\n').length;
  const out: string[] = [];
  text
    .slice(lo + 1, hi)
    .split('\n')
    .forEach((l, i) => {
      const t = l.trim();
      if (t.length === 0) return;
      // الجولة 85: كل الأسطر القصيرة (مرشحات العناوين) كاملة، والطويلة طولها وبدايتها فقط؛ فاللوج كان يقطع عند 14 سطراً فلا تظهر عناوين البنود التالية
      out.push(`L${firstLine + 1 + i} len=${t.length}${t.length <= 28 ? ` ${JSON.stringify(t)}` : ''}`);
    });
  return out.slice(0, 60).join(' | ');
}

@Injectable()
export class SegmentationService {
  private readonly logger = new Logger(SegmentationService.name);

  private findHeads(text: string): Head[] {
    const full: Head[] = [...text.matchAll(CLAUSE_RE)]
      .filter((m) => {
        if (!m.groups?.pre) return true;
        const lineEnd = text.indexOf('\n', (m.index ?? 0) + m[0].length);
        const rest = text.slice((m.index ?? 0) + m[0].length, lineEnd === -1 ? text.length : lineEnd);
        return rest.trim().length <= MAX_REST_AFTER_NOISE_PREFIX;
      })
      .map((m) => {
        const off = m[0].indexOf('البند');
        return {
          lineStart: m.index ?? 0,
          markerStart: (m.index ?? 0) + off,
          marker: m[0].slice(off).trim().replace(/[_\u0640\-\u2013\u2014]+/g, ' ').replace(/ {2,}/g, ' '),
          rawLength: m[0].slice(off).trim().length,
          declaredNumber: ordinalToNumber(m.groups?.ord ?? ''),
        };
      });
    const bare = [...text.matchAll(BARE_RE)].map((m) => ({
      lineStart: m.index ?? 0,
      markerStart: m.index ?? 0,
      marker: `البند ${((m.groups?.ord ?? '').startsWith('ال') ? '' : 'ال') + (m.groups?.ord ?? '').replace(/[\s_\u0640]+/g, ' ')}`,
      rawLength: (m.groups?.ord ?? '').length,
      declaredNumber: ordinalToNumber(m.groups?.ord ?? ''),
    }));
    const merged = [...full];
    for (const b of bare) {
      if (b.declaredNumber === null) continue;
      const prev = [...merged].filter((h) => h.lineStart < b.lineStart).pop();
      const nextFull = full.find((h) => h.lineStart > b.lineStart);
      // التسلسل المتوقع: التالى مباشرة للسابق؛ وقبل أول عنوان مقبول يبدأ من "الأول" (استرجاع عناوين البنود الأولى التى
      // أسقطتها القراءة الآلية) ولا يُقبل إلا إن تلاه عنوان كامل برقم أعلى (دليل أن ما قبله بنود فعلاً لا قائمة عابرة).
      const expected = prev ? (prev.declaredNumber === null ? null : prev.declaredNumber + 1) : 1;
      // الجولة 68: ترتيبى مركّب («ثالث عشر») لا يلتبس بكلمة عادية، فيُقبل بقفزة حتى رقمين فوق المتوقع (عنوان «حادى عشر» لم تقرأه الآلة)
      // دون أن تضيع بقية البنود؛ وتُنبِّه فحوص الترقيم لاحقاً إلى القفزة نفسها.
      const compoundJump = expected !== null && b.declaredNumber > expected && b.declaredNumber - expected <= 2 && b.declaredNumber >= 11;
      if (expected === null || (b.declaredNumber !== expected && !compoundJump)) continue;
      if (!prev && !(nextFull && nextFull.declaredNumber !== null && nextFull.declaredNumber > b.declaredNumber)) continue;
      if (nextFull && nextFull.declaredNumber === b.declaredNumber) continue;
      merged.push(b);
      merged.sort((x, y) => x.lineStart - y.lineStart);
    }
    return merged;
  }

  segment(rawText: string): SegmentationResult {
    // علامات تنسيق Markdown (**عريض**، ### عنوان) تصل أحياناً حرفية فى نص العقد وتُخفى عنوان البند عن المطابقة
    const text = rawText
      .replace(INVISIBLE_MARKS_RE, '')
      .replace(/\r\n/g, '\n')
      .replace(/\*\*/g, '')
      .replace(/^[ \t]*#{1,6}[ \t]+/gm, '');
    let wholeText: string | null = null;
    let heads = this.findHeads(text);
    // نمط الترقيم الأصلى («البند الأول…») لم يجد بنوداً كافية: جرّب «المادة 1» و«المادة الأولى» و«1. العنوان»
    if (heads.length < 2) {
      const alt = findAlternativeHeads(text);
      if (alt.length > heads.length) heads = alt;
    }
    const warnings: string[] = [];
    // الجولة 68: عقد بلا «البند»/«المادة» أصلاً، بنوده «أولاً: … ثانياً: …» (عقد أتعاب محاماة حقيقى خرج بصفر بنود وبغلاف مطمئن)
    // الجولة 90: وكذلك حين التقطت الأنماط الأخرى بنداً أو اثنين من عقد ممسوح عناوينه «أولاً/ثانياً…» وعناوينه الترتيبية تكوّن تسلسلاً أطول بكثير (إيجار ممسوح خرج ببندين)
    if (heads.length < 4) {
      const adv = findAdverbialHeads(text);
      if (adv.length >= 2 && adv.length > heads.length && (heads.length < 2 || (adv.length >= 5 && adv.length >= heads.length + 3))) {
        heads = adv;
        warnings.push(
          `لا يوجد فى العقد ترقيم «البند …» أو «المادة …»؛ قُسِّم بحسب عناوينه الترتيبية («${adv.map((h) => h.marker).slice(0, 3).join('، ')}…») وعددها ${adv.length}. حدود البنود وأرقامها تقريبية — قارنها بالأصل قبل الاعتماد.`,
        );
      }
    }

    // قراءة آلية شوّهت العناوين («البن دالاول»، «البندالالث»، «الند الخامس»…) فالتقط الكاشف الحرفى بنداً أو اثنين وألصق الباقى بهما:
    // مطابقة تقريبية مقيَّدة بالتسلسل، لا تُعتمد إلا إن وجدت بنوداً أكثر مما وجده الكاشف الحرفى (فلا تمس عقداً سليم الترقيم).
    const aligned = findAlignedHeads(text);
    // أعداد وأرقام فقط (لا نص عقد): لتشخيص ما قرأه الخادم فعلاً حين تختلف القراءة الآلية بين البيئات
    this.logger.log(
      `segmentation heads: literal=${heads.length} aligned=${aligned.length} alignedNumbers=${aligned.map((h) => h.declaredNumber).join(',')}`,
    );
    let headingLinesLogged = false;
    if (heads.length < 4 || aligned.length > heads.length) {
      // عقد قليل العناوين المقروءة (غالباً ممسوح): تُسجَّل الأسطر الشبيهة بعنوان فقط (≤ 34 حرفاً) لمعرفة سبب ما فاتنا
      this.logger.log(`segmentation heading-like lines: ${describeHeadingCandidates(text).join(' | ')}`);
      headingLinesLogged = true;
    }
    if (aligned.length >= 3 && aligned.length <= heads.length) {
      // الجولة 77: الكاشف الحرفى وجد عدداً مساوياً أو أكبر لكنه أسقط رقماً قرأته المطابقة التقريبية («البنك السادس») بينما التقط الحرفى رقماً لم تلتقطه هى
      // («Rent الخامس»): يُضاف الناقص فقط، بشرط بقاء الأرقام متزايدة بحسب موضع العنوان، وإلا تُترك القراءة الحرفية كما هى.
      const filled = fillGapsFromAligned(heads, aligned);
      if (filled.added.length > 0) {
        heads = filled.heads;
        warnings.push(
          `قُرئ عنوان ${filled.added.length === 1 ? 'بند' : `${filled.added.length} بنود`} (${filled.added.map((n) => canonicalHeading(n)).filter(Boolean).join('، ')}) بمطابقة تقريبية مقيَّدة بالتسلسل لأن قراءته الآلية مشوَّهة — تحقق من حدود البنود وأرقامها بالأصل قبل الاعتماد.`,
        );
      }
    }
    if (aligned.length >= 3 && aligned.length > heads.length) {
      // الجولة 83: عنوان حرفى سليم (مثل «البند-الثانى») لم تلتقطه المطابقة التقريبية يُضاف إليها بدل أن يضيع، إن بقى الترتيب متزايداً
      const literalHeads = heads;
      heads = aligned;
      const kept = fillGapsFromAligned(aligned as unknown as Head[], literalHeads);
      if (kept.added.length > 0) heads = kept.heads as unknown as typeof aligned;
      const fuzzy = aligned.filter((h) => h.distance > 0).length;
      if (fuzzy > 0) {
        warnings.push(
          `قُرئت عناوين ${fuzzy} بنداً من ${aligned.length} من قراءة آلية مشوَّهة بمطابقة تقريبية مقيَّدة بالتسلسل — تحقق من أن حدود البنود وأرقامها صحيحة قبل الاعتماد.`,
        );
      }
    }

    // الجولة 86: خطوات الاسترجاع تعتمد على بعضها (بند يُسترجع بالخطوة الثالثة هو «البند السابق» الذى تحتاجه الخطوة الأولى لتبحث عن التالى: «السادس» لم يُلتقط فى إنتاج
    // الجولة 85 لأن «الخامس» لم يكن قد استُرجع بعد حين جرت الخطوة الأولى)؛ فتُعاد الخطوات حتى لا يتغير شىء (حد أقصى 4 دورات). كل خطوة لها شروطها وتنبيهها الصريح كما هى.
    for (let pass = 0; pass < 4; pass++) {
      let changed = false;
      // الجولة 80: عنوان ناقص بين رقمين مقروءين وسطره «ضوضاء + ترتيبى» (لا «البند» ولا بادئة لاتينية): بحث موجَّه بالتسلسل مع تحذير صريح
      if (heads.length >= 3) {
        const noisy = recoverNoisyOrdinalHeads(text, heads);
        if (noisy.recovered.length > 0) {
          changed = true;
          heads = noisy.heads;
          warnings.push(
            `قُرئ عنوان ${noisy.recovered.length === 1 ? 'بند' : `${noisy.recovered.length} بنود`} (${noisy.recovered.map((n) => canonicalHeading(n)).filter(Boolean).join('، ')}) من سطر مشوَّه لم تُقرأ فيه كلمة «البند» (بحث موجَّه بالتسلسل بين البندين المجاورين) — تحقق من حدود البنود وأرقامها بالأصل قبل الاعتماد.`,
          );
        }
      }

      // عناوين بنود سقطت من القراءة الآلية (مسطّرة غالباً) وبقيت فقراتها مرقمة «4-1…»: تُسترجع حدودها من الترقيم الفرعى بتحذير صريح
      if (heads.length >= 2) {
        const rec = recoverHeadsFromSubclauses(text, heads);
        if (rec.recovered.length > 0) {
          changed = true;
          heads = rec.heads;
          const labels = rec.recovered.map((n) => canonicalHeading(n)).filter(Boolean).join('، ');
          warnings.push(
            `لم تُقرأ عناوين ${rec.recovered.length === 1 ? 'بند' : `${rec.recovered.length} بنود`} (${labels}) فاستُرجعت حدودها من ترقيم فقراتها الفرعية (مثل «${rec.recovered[0]}-1»)؛ حدودها وعناوينها تقريبية — تحقق منها بالأصل قبل الاعتماد.`,
          );
        }
      }

      // الجولة 83: عنوان قُرئ سطراً قصيراً تالفاً معزولاً (لا يشبه ترتيبياً): يُسترجع من بنية الفقرات بتحذير صريح
      if (heads.length >= 3) {
        const iso = recoverHeadsFromIsolatedShortLines(text, heads);
        if (iso.recovered.length > 0) {
          changed = true;
          heads = iso.heads;
          warnings.push(
            `عنوان ${iso.recovered.length === 1 ? 'بند' : `${iso.recovered.length} بنود`} (${iso.recovered.map((n) => canonicalHeading(n)).filter(Boolean).join('، ')}) قُرئ سطراً قصيراً تالفاً لا يُقرأ ترتيبيه؛ حُدِّد من موضعه المعزول بين البندين المجاورين، فنسبة المتن إلى هذا البند تقريبية — قارنها بالأصل قبل الاعتماد.`,
          );
        }
      }

      // الجولة 82: عنوان ضاع كلياً من القراءة (سطره فارغ): يُسترجع حدّه من فاصل الفقرات حين يطابق عدد الفقرات عدد الأرقام الناقصة بالضبط، بتحذير صريح
      if (heads.length >= 3) {
        const para = recoverHeadsFromParagraphBreaks(text, heads);
        if (para.recovered.length > 0) {
          changed = true;
          heads = para.heads;
          warnings.push(
            `لم يُقرأ عنوان ${para.recovered.length === 1 ? 'بند' : `${para.recovered.length} بنود`} (${para.recovered.map((n) => canonicalHeading(n)).filter(Boolean).join('، ')}) إطلاقاً من القراءة الآلية؛ حُدِّد بدء ${para.recovered.length === 1 ? 'البند' : 'كل بند'} من فاصل الفقرات بين البندين المجاورين، فحدّه تقريبى — قارنه بالأصل قبل الاعتماد.`,
          );
        }
      }

      // الجولة 87: عنوان ضاع كلياً بلا فراغ ولا سطر قصير: يُحدَّد من آخر سطر مبتور (أقصر من أسطر الفقرة الكاملة) بين البندين المجاورين، بشروط صارمة وتنبيه صريح
      if (heads.length >= 3) {
        const rag = recoverHeadsFromRaggedLines(text, heads);
        if (rag.recovered.length > 0) {
          changed = true;
          heads = rag.heads;
          warnings.push(
            `لم يُقرأ عنوان ${rag.recovered.length === 1 ? 'بند' : `${rag.recovered.length} بنود`} (${rag.recovered.map((n) => canonicalHeading(n)).filter(Boolean).join('، ')}) إطلاقاً من القراءة الآلية؛ حُدِّد بدء ${rag.recovered.length === 1 ? 'البند' : 'كل بند'} من نهاية فقرة (سطر أقصر من أسطر الفقرة الكاملة) بين البندين المجاورين، فحدّه تقريبى — قارنه بالأصل قبل الاعتماد.`,
          );
        }
      }

      if (!changed) break;
    }

    // الجولة 90: العنوان الأول ضاع (أول مقروء هو الثانى) والديباجة تنتهى بتعريف الطرف الثانى
    if (heads.length >= 3) {
      const firstRec = recoverFirstHead(text, heads);
      if (firstRec.recovered.length > 0) {
        heads = firstRec.heads;
        warnings.push(
          'لم يُقرأ عنوان البند الأول من القراءة الآلية؛ حُدِّد بدؤه من نهاية فقرة تعريف الأطراف (بعد «الطرف الثانى»)، فحدّه تقريبى — قارنه بالأصل قبل الاعتماد.',
        );
      }
    }

    if (heads.length === 0) {
      // الجولة 69: تشخيص بنيوى بلا محتوى لسبب العجز على نص الإنتاج
      this.logger.log(`segmentation adverbial diagnostics: ${adverbialDiagnostics(text)}`);
      this.logger.log(`segmentation zero-heads lines: ${zeroHeadLinesDump(text)}`);
      // الجولة 68: صفر بنود لا يُقدَّم كأن العقد سليم؛ ويُفرَّق بين عقد بلا ترقيم وملف مستندات ليس عقداً أصلاً
      const bundle = documentBundleWarning(classifyDocumentKind(text));
      if (bundle) warnings.push(bundle);
      warnings.push(
        'لم يُعثَر على أى بند بترقيم مقروء (لا «البند الأول» ولا «المادة 1» ولا «1. العنوان») — قد يكون العقد بلا ترقيم صريح أصلاً. يلزم مراجعة بشرية كاملة قبل أى استخدام آلى.',
      );
      // الجولة 71: نص عقد حقيقى (صيغة عقد مقروءة) قصير لا يُترك بلا تحليل لأن قراءته الآلية أتلفت عناوينه (عقد أتعاب ممسوح من صفحتين: «أولاً» قُرئت «ب -»
      // و«ثانياً» قُرئت «L»): يُقيَّم نصه كله كبند واحد غير مُقسَّم بتنبيه صريح. ملف المستندات والنص الطويل جداً أو غير الواضح يبقيان بلا بنود.
      const kind = classifyDocumentKind(text);
      const trimmed = text.trim();
      if (kind.kind !== 'document_bundle' && kind.contractSignals.length >= 1 && trimmed.length >= WHOLE_TEXT_MIN_CHARS && trimmed.length <= WHOLE_TEXT_MAX_CHARS) {
        wholeText = trimmed;
        const n = splitIntoApproxParagraphs(trimmed).length;
        warnings.push(
          `تعذّر تقسيم العقد إلى بنود (لا ترقيم ولا عناوين ترتيبية مقروءة)؛ قُسِّم نصه آلياً إلى ${n === 1 ? 'فقرة واحدة' : `${n} فقرات تقريبية`} متجاورة ليخضع للتقييم، فالنتيجة عامة وحدود البنود غير دقيقة — يلزم تقسيمه ومراجعته يدوياً، ويُفضَّل رفع نسخة أوضح أو نص Word إن وُجد.`,
        );
      }
    }

    const clauses: SegmentedClause[] = heads.map((h, i) => {
      const next = heads[i + 1];
      const start = h.markerStart;
      const end = next ? next.lineStart : text.length;
      const fullSlice = text.slice(start, end).trim();
      const marker = h.marker;
      const afterMarker = fullSlice.slice(h.rawLength).trim();

      // العنوان الصريح (إن وُجد): موجود داخل نفس السطر الأول فقط، بعد ":" —
      // مثال حقيقى: "البند الثاني: نطاق العمل والخدمات". لو لم يوجد ":" فى
      // نص العلامة نفسها (حالة "البند الاول" بلا عنوان، كما فى عقدى الإيجار
      // الحقيقيين)، لا عنوان صريح ونعتبر afterMarker كله متن البند.
      const hasColon = marker.endsWith(':') || marker.endsWith('.');
      let title: string | null = null;
      let body = afterMarker;
      if (!hasColon) {
        // العنوان قد يكون فى نفس سطر العلامة نفسه بعد فاصل غير مُلتقَط —
        // لا شىء إضافى مطلوب هنا فعلياً بناءً على العقود الأربعة المُختبَرة؛
        // تُرك الفرع صراحةً بدل حذفه ليوثّق أن هذه الحالة فُحصت لا أُغفلت.
        title = null;
      } else {
        const firstLineBreak = afterMarker.indexOf('\n');
        if (firstLineBreak > 0 && firstLineBreak < 80) {
          title = afterMarker.slice(0, firstLineBreak).trim() || null;
          body = afterMarker.slice(firstLineBreak).trim();
        } else if (firstLineBreak === -1 && afterMarker.length < 80) {
          // العنوان هو السطر بأكمله (لا متن بعده فى نفس الفقرة — نادر لكن وارد)
          title = afterMarker || null;
          body = '';
        }
      }

      return {
        index: i + 1,
        declaredNumber: h.declaredNumber,
        label: marker.replace(/[:.]$/, ''),
        title,
        text: body || afterMarker,
      };
    });

    // الجولة 87: ملحق مرقَّم («ملحق(4) عقد الوكالة فى الانتاج») يلى توقيع العقد التصق بآخر بند فنُسبت نسب العمولة والحوافز التى فيه إلى «البند السابع عشر» فى تقرير الوكالة؛
    // يُفصل عن آخر بند كوحدة مستقلة بعنوانها (بلا رقم بند)، بتنبيه صريح. شرطه: سطر يبدأ بـ«ملحق» ورقمه، وقبله متن ≥ 30 حرفاً وبعده نص ≥ 60 حرفاً.
    if (clauses.length >= 2) {
      const lastClause = clauses[clauses.length - 1];
      const am = ANNEX_HEAD_RE.exec(lastClause.text);
      if (am && am.index >= 30 && lastClause.text.length - am.index >= 60) {
        const annexText = lastClause.text.slice(am.index).trim();
        const annexNo = am.groups?.no ?? '';
        lastClause.text = lastClause.text.slice(0, am.index).trim();
        clauses.push({ index: clauses.length + 1, declaredNumber: null, label: `ملحق (${annexNo})`, title: null, text: annexText });
        warnings.push(
          `فُصل «ملحق (${annexNo})» عن «${lastClause.label}» وأُدرج وحدة مستقلة: يلى توقيع العقد ويحمل شروطاً خاصة به (نسب/مدد/مبالغ)، فلا تُنسب إلى البند الأخير — قارن حدوده بالأصل قبل الاعتماد.`,
        );
      }
    }

    // أول بند مُتعرَّف عليه ليس "الأول": نص ما قبله قد يحوى بنوداً لم تُقرأ عناوينها (قراءة آلية رديئة).
    // لا نُسقطه بصمت — يُدرَج كبند واحد غير مُقسَّم ليخضع للتقييم والمراجعة، مع تنبيه صريح.
    const first = heads[0];
    if (first && first.declaredNumber !== null && first.declaredNumber > 1) {
      const leading = text.slice(0, first.lineStart).trim();
      if (leading.length >= 40) {
        clauses.unshift({
          index: 0,
          declaredNumber: null,
          label: `نص سابق لـ${first.marker.replace(/[:.]$/, '')} (غير مُقسَّم)`,
          title: null,
          text: leading,
        });
        clauses.forEach((c, i) => { c.index = i + 1; });
        warnings.push(
          `لم تُقرأ عناوين البنود السابقة لـ"${first.marker.replace(/[:.]$/, '')}"؛ أُدرج النص الذى يسبقه كبند واحد غير مُقسَّم (قد يضم الديباجة وعدة بنود) — يلزم تقسيمه ومراجعته يدوياً.`,
        );
      }
    }

    // فحص تسلسل الترقيم المُصرَّح به داخل العقد نفسه (لا الترتيب الفعلى للظهور
    // فقط) — بند مفقود أو مكرر مؤشر خطأ تقسيم أو خطأ فى العقد الأصلى نفسه،
    // وفى الحالتين يستحق تنبيهاً صريحاً بدل تمريره بصمت.
    const declared = clauses.map((c) => c.declaredNumber).filter((n): n is number => n !== null);
    // الجولة 79: قفزة فى الترقيم المُعلَن (عنوان «البند الخامس» ما زال ملتصقاً بالرابع فى إنتاج عقد الأتعاب) ولم يُسجَّل شىء لأن عدد العناوين ≥ 4:
    // تُسجَّل الأسطر الشبيهة بعنوان لمعرفة كيف قُرئ العنوان الناقص فعلاً (تشخيص فقط، لا يغيّر التقسيم)
    const forwardGap = findForwardGap(declared);
    if (forwardGap && !headingLinesLogged) {
      this.logger.log(
        `segmentation numbering gap: missing=${forwardGap.missing.join(',')} declared=${declared.join(',')} heading-like lines: ${describeHeadingCandidates(text).join(' | ')}`,
      );
    }
    if (forwardGap) {
      // الجولة 80: أسطر النافذة بين عنوانى الرقم الناقص (أرقام وبدايات قصيرة فقط) لمعرفة كيف قُرئ العنوان الضائع إن بقيت الفجوة
      // الجولة 84: كل مجموعة أرقام ناقصة متتالية تُسجَّل نافذتها (كانت الأولى فقط؛ عقد البيع ضاع فيه 5-7 و11-12 ولم يظهر لوج الثانية)
      const have = new Set(declared);
      const allMissing = Array.from({ length: Math.max(0, ...declared) }, (_, i) => i + 1).filter((m) => !have.has(m));
      const groupStarts = allMissing.filter((m, i) => i === 0 || m !== allMissing[i - 1] + 1).slice(0, 4);
      for (const g of groupStarts) {
        this.logger.log(`segmentation gap window n=${g}: ${describeGapWindow(text, heads, g)}`);
      }
    }
    for (let i = 0; i < declared.length; i++) {
      if (declared[i] !== i + 1) {
        // قفزة إلى الأمام: تُفحص أدلة النقص فى النص (إحالة/فقرات فرعية/بند متضخم)؛ التكرار والرجوع يبقيان بصيغتهما (الجولة 67)
        const gap = findForwardGap(declared);
        warnings.push(
          gap
            ? numberingGapWarningText(gap, numberingGapEvidence(text, clauses, gap))
            : `ترقيم البنود المُعلَن غير متسلسل بدءاً من الموضع ${i + 1} (متوقَّع ${i + 1}, وُجد ${declared[i]}) — يلزم مراجعة بشرية.`,
        );
        break;
      }
    }

    // إحالة نصية إلى بند أعلى من آخر بند مُقسَّم ("وفقاً للبند السادس عشر") مؤشر قوى على عنوان بند أسقطته القراءة
    // الآلية فالتصق نص بند كامل بسابقه: تنبيه صريح بدل عدد بنود يبدو سليماً وهو ناقص.
    const maxDeclared = declared.length > 0 ? Math.max(...declared) : 0;
    let maxReferenced = 0;
    for (const m of text.matchAll(REFERENCE_RE)) {
      const n = ordinalToNumber(m.groups?.ord ?? '');
      if (n === null || n <= maxReferenced) continue;
      // إحالة إلى بند فى عقد/قانون/لائحة آخر ("البند السابع عشر من العقد الأصلي") ليست بنداً مفقوداً من هذا العقد
      const after = text.slice((m.index ?? 0) + m[0].length, (m.index ?? 0) + m[0].length + 40);
      if (EXTERNAL_REFERENCE_RE.test(after)) continue;
      maxReferenced = n;
    }
    if (maxDeclared > 0 && maxReferenced > maxDeclared) {
      warnings.push(
        `نص العقد يُحيل إلى "البند رقم ${maxReferenced}" بينما قُسِّم إلى ${maxDeclared} بنداً فقط — قد يكون عنوان بند أو أكثر قد سقط من القراءة فالتصق نصه بالبند السابق؛ راجع نهاية العقد يدوياً.`,
      );
    }

    // الفقرات الفرعية المرقمة («10-1»…) تدل على بنود أكثر مما قُسِّم: عناوينها لم تُقرأ فالتصق نصها بما قبلها (لا تُحصى مرة ثانية إن نبّهت الإحالة النصية)
    const subMax = subclauseMaxNumber(text);
    if (maxDeclared > 0 && subMax > maxDeclared && !(maxReferenced > maxDeclared)) {
      warnings.push(
        `ترقيم الفقرات الفرعية فى النص يصل إلى ${subMax} (مثل «${subMax}-1») بينما قُسِّم العقد إلى ${maxDeclared} بنداً فقط — يظهر أن بنوداً حتى رقم ${subMax} لم تُقرأ عناوينها فالتصق نصها بما قبلها؛ راجع نهاية العقد يدوياً.`,
      );
    }

    const emptyClauses = clauses.filter((c) => c.text.trim().length < 3);
    if (emptyClauses.length > 0) {
      warnings.push(
        `${emptyClauses.length} بند(بنود) بمتن شبه فارغ بعد التقسيم — مؤشر خطأ تقسيم محتمل: ${emptyClauses.map((c) => c.label).join('، ')}.`,
      );
    }

    if (clauses.length === 0 && wholeText) {
      const parts = splitIntoApproxParagraphs(wholeText);
      parts.forEach((p, i) =>
        clauses.push({ index: i + 1, declaredNumber: null, label: parts.length === 1 ? WHOLE_TEXT_LABEL : `${APPROX_PARAGRAPH_PREFIX} ${i + 1}`, title: null, text: p }),
      );
    }

    const firstHead = heads[0];
    const preamble = firstHead ? text.slice(0, firstHead.lineStart).trim().slice(0, 4000) : '';
    return { clauses, warnings, preamble };
  }
}
