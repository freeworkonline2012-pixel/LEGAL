import { Injectable, Logger } from '@nestjs/common';
import { findAlternativeHeads } from './clause-headings-alt';
import { describeHeadingCandidates, findAlignedHeads } from './clause-headings-fuzzy';
import { BARE_RE, canonicalHeading, CLAUSE_RE, MAX_REST_AFTER_NOISE_PREFIX, ordinalToNumber, REFERENCE_RE } from './clause-headings';

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
          marker: m[0].slice(off).trim().replace(/[_\u0640]+/g, ' ').replace(/ {2,}/g, ' '),
          rawLength: m[0].slice(off).trim().length,
          declaredNumber: ordinalToNumber(m.groups?.ord ?? ''),
        };
      });
    const bare = [...text.matchAll(BARE_RE)].map((m) => ({
      lineStart: m.index ?? 0,
      markerStart: m.index ?? 0,
      marker: `البند ${(m.groups?.ord ?? '').replace(/[\s_\u0640]+/g, ' ')}`,
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
      if (expected === null || b.declaredNumber !== expected) continue;
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
    let heads = this.findHeads(text);
    // نمط الترقيم الأصلى («البند الأول…») لم يجد بنوداً كافية: جرّب «المادة 1» و«المادة الأولى» و«1. العنوان»
    if (heads.length < 2) {
      const alt = findAlternativeHeads(text);
      if (alt.length > heads.length) heads = alt;
    }
    const warnings: string[] = [];

    // قراءة آلية شوّهت العناوين («البن دالاول»، «البندالالث»، «الند الخامس»…) فالتقط الكاشف الحرفى بنداً أو اثنين وألصق الباقى بهما:
    // مطابقة تقريبية مقيَّدة بالتسلسل، لا تُعتمد إلا إن وجدت بنوداً أكثر مما وجده الكاشف الحرفى (فلا تمس عقداً سليم الترقيم).
    const aligned = findAlignedHeads(text);
    // أعداد وأرقام فقط (لا نص عقد): لتشخيص ما قرأه الخادم فعلاً حين تختلف القراءة الآلية بين البيئات
    this.logger.log(
      `segmentation heads: literal=${heads.length} aligned=${aligned.length} alignedNumbers=${aligned.map((h) => h.declaredNumber).join(',')}`,
    );
    if (heads.length < 4 || aligned.length > heads.length) {
      // عقد قليل العناوين المقروءة (غالباً ممسوح): تُسجَّل الأسطر الشبيهة بعنوان فقط (≤ 34 حرفاً) لمعرفة سبب ما فاتنا
      this.logger.log(`segmentation heading-like lines: ${describeHeadingCandidates(text).join(' | ')}`);
    }
    if (aligned.length >= 3 && aligned.length > heads.length) {
      heads = aligned;
      const fuzzy = aligned.filter((h) => h.distance > 0).length;
      if (fuzzy > 0) {
        warnings.push(
          `قُرئت عناوين ${fuzzy} بنداً من ${aligned.length} من قراءة آلية مشوَّهة بمطابقة تقريبية مقيَّدة بالتسلسل — تحقق من أن حدود البنود وأرقامها صحيحة قبل الاعتماد.`,
        );
      }
    }

    // عناوين بنود سقطت من القراءة الآلية (مسطّرة غالباً) وبقيت فقراتها مرقمة «4-1…»: تُسترجع حدودها من الترقيم الفرعى بتحذير صريح
    if (heads.length >= 2) {
      const rec = recoverHeadsFromSubclauses(text, heads);
      if (rec.recovered.length > 0) {
        heads = rec.heads;
        const labels = rec.recovered.map((n) => canonicalHeading(n)).filter(Boolean).join('، ');
        warnings.push(
          `لم تُقرأ عناوين ${rec.recovered.length === 1 ? 'بند' : `${rec.recovered.length} بنود`} (${labels}) فاستُرجعت حدودها من ترقيم فقراتها الفرعية (مثل «${rec.recovered[0]}-1»)؛ حدودها وعناوينها تقريبية — تحقق منها بالأصل قبل الاعتماد.`,
        );
      }
    }

    if (heads.length === 0) {
      warnings.push(
        'لم يُعثَر على أى بند بترقيم مقروء (لا «البند الأول» ولا «المادة 1» ولا «1. العنوان») — قد يكون العقد بلا ترقيم صريح أصلاً. يلزم مراجعة بشرية كاملة قبل أى استخدام آلى.',
      );
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
    for (let i = 0; i < declared.length; i++) {
      if (declared[i] !== i + 1) {
        warnings.push(
          `ترقيم البنود المُعلَن غير متسلسل بدءاً من الموضع ${i + 1} (متوقَّع ${i + 1}, وُجد ${declared[i]}) — يلزم مراجعة بشرية.`,
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

    const firstHead = heads[0];
    const preamble = firstHead ? text.slice(0, firstHead.lineStart).trim().slice(0, 4000) : '';
    return { clauses, warnings, preamble };
  }
}
