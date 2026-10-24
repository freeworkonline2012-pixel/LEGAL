import { Injectable } from '@nestjs/common';
import { BARE_RE, CLAUSE_RE, MAX_REST_AFTER_NOISE_PREFIX, ordinalToNumber, REFERENCE_RE } from './clause-headings';

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
}

// ما يلى رقم البند فى إحالة خارجية: "من العقد الأصلي/السابق"، "من القانون"، "من اللائحة"... ("من هذا العقد" إحالة داخلية)
const EXTERNAL_REFERENCE_RE = /^[\s_\u0640]*من[\s_\u0640]+(?:ال)?(?:عقد|قانون|لائحة|لائحه|ملحق|اتفاق|اتفاقية|اتفاقيه|نظام|اللائحة)/u;

@Injectable()
export class SegmentationService {
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
    const text = rawText.replace(INVISIBLE_MARKS_RE, '').replace(/\r\n/g, '\n');
    const heads = this.findHeads(text);
    const warnings: string[] = [];

    if (heads.length === 0) {
      warnings.push(
        'لم يُعثَر على أى بند بنمط "البند + ترتيبى" — قد يستخدم العقد نمط ترقيم مختلف (مثال: "المادة رقم")، أو تقسيماً بلا ترقيم صريح إطلاقاً. يلزم مراجعة بشرية كاملة قبل أى استخدام آلى.',
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

    const emptyClauses = clauses.filter((c) => c.text.trim().length < 3);
    if (emptyClauses.length > 0) {
      warnings.push(
        `${emptyClauses.length} بند(بنود) بمتن شبه فارغ بعد التقسيم — مؤشر خطأ تقسيم محتمل: ${emptyClauses.map((c) => c.label).join('، ')}.`,
      );
    }

    return { clauses, warnings };
  }
}
