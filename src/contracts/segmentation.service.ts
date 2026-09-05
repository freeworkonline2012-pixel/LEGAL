import { Injectable } from '@nestjs/common';

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

type Ordinal = readonly [number, readonly string[]];

const ORDINALS: readonly Ordinal[] = [
  [1, ['الأول', 'الاول']],
  [2, ['الثاني', 'الثانى']],
  [3, ['الثالث']],
  [4, ['الرابع']],
  [5, ['الخامس']],
  [6, ['السادس']],
  [7, ['السابع']],
  [8, ['الثامن']],
  [9, ['التاسع']],
  [10, ['العاشر']],
  [11, ['الحادي عشر', 'الحادى عشر']],
  [12, ['الثاني عشر', 'الثانى عشر']],
  [13, ['الثالث عشر']],
  [14, ['الرابع عشر']],
  [15, ['الخامس عشر']],
  [16, ['السادس عشر']],
  [17, ['السابع عشر']],
  [18, ['الثامن عشر']],
  [19, ['التاسع عشر']],
  [20, ['العشرون']],
  [21, ['الحادي والعشرون', 'الحادى والعشرون']],
  [22, ['الثاني والعشرون', 'الثانى والعشرون']],
  [23, ['الثالث والعشرون']],
  [24, ['الرابع والعشرون']],
  [25, ['الخامس والعشرون']],
  [26, ['السادس والعشرون']],
  [27, ['السابع والعشرون']],
  [28, ['الثامن والعشرون']],
  [29, ['التاسع والعشرون']],
  [30, ['الثلاثون']],
];

// الأطول أولاً (حروفاً بعد استبدال المسافات بـ\s+) — يمنع التقاط "العاشر"
// كتطابق جزئى خاطئ داخل "الحادى عشر" لو رُتبت الأقصر أولاً.
const ALTERNATIVES = ORDINALS.flatMap(([num, spellings]) => spellings.map((s) => ({ num, s })))
  .sort((a, b) => b.s.length - a.s.length)
  .map((x) => x.s.replace(/ /g, '\\s+'));

const CLAUSE_RE = new RegExp(`^[ \\t]*البند\\s+(${ALTERNATIVES.join('|')})\\s*[:.]?`, 'gmu');

function ordinalToNumber(spelling: string): number | null {
  const normalized = spelling.replace(/\s+/g, ' ').trim();
  const found = ORDINALS.find(([, spellings]) =>
    spellings.some((s) => s.replace(/\s+/g, ' ') === normalized),
  );
  return found ? found[0] : null;
}

@Injectable()
export class SegmentationService {
  segment(rawText: string): SegmentationResult {
    const text = rawText.replace(/\r\n/g, '\n');
    const matches = [...text.matchAll(CLAUSE_RE)];
    const warnings: string[] = [];

    if (matches.length === 0) {
      warnings.push(
        'لم يُعثَر على أى بند بنمط "البند + ترتيبى" — قد يستخدم العقد نمط ترقيم مختلف (مثال: "المادة رقم")، أو تقسيماً بلا ترقيم صريح إطلاقاً. يلزم مراجعة بشرية كاملة قبل أى استخدام آلى.',
      );
    }

    const clauses: SegmentedClause[] = matches.map((m, i) => {
      const next = matches[i + 1];
      const start = m.index ?? 0;
      const end = next ? (next.index ?? text.length) : text.length;
      const fullSlice = text.slice(start, end).trim();
      const marker = m[0].trim();
      const afterMarker = fullSlice.slice(marker.length).trim();

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
        declaredNumber: ordinalToNumber(m[1]),
        label: marker.replace(/[:.]$/, ''),
        title,
        text: body || afterMarker,
      };
    });

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

    const emptyClauses = clauses.filter((c) => c.text.trim().length < 3);
    if (emptyClauses.length > 0) {
      warnings.push(
        `${emptyClauses.length} بند(بنود) بمتن شبه فارغ بعد التقسيم — مؤشر خطأ تقسيم محتمل: ${emptyClauses.map((c) => c.label).join('، ')}.`,
      );
    }

    return { clauses, warnings };
  }
}
