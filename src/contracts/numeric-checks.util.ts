import { normalizeArabicForMatch } from './reasoning.util';

/**
 * فحوص حسابية حتمية على نص العقد (بلا نموذج لغوى): المبلغ المكتوب بالحروف مقابل الأرقام، ومجموع نسب الدفعات.
 * الغاية: الأرقام والمبالغ أكثر ما تخطئ فيه القراءة الآلية للعقود الممسوحة، وأخطرها أثراً؛ فنكشف التناقض فيها
 * ونُنبّه المستخدم بدل أن يمر صامتاً. لا يصدر حكم قانونى ولا يُعدَّل النص: تحذيرات فقط، وكل فحص يتجاهل ما لا يفهمه.
 */

// ===== أعداد بالحروف العربية =====

const UNITS: Record<string, number> = {
  واحد: 1, واحده: 1, احد: 1, احده: 1, اثني: 2, اثنا: 2, اثنان: 2, اثنين: 2, اثنتان: 2, اثنتين: 2, ثلاثه: 3, ثلاث: 3, اربعه: 4, اربع: 4,
  خمسه: 5, خمس: 5, سته: 6, ست: 6, سبعه: 7, سبع: 7, ثمانيه: 8, ثماني: 8, ثمان: 8, تسعه: 9, تسع: 9,
};
const TEENS: Record<string, number> = { عشره: 10, عشر: 10 };
const TENS: Record<string, number> = {
  عشرون: 20, عشرين: 20, ثلاثون: 30, ثلاثين: 30, اربعون: 40, اربعين: 40, خمسون: 50, خمسين: 50,
  ستون: 60, ستين: 60, سبعون: 70, سبعين: 70, ثمانون: 80, ثمانين: 80, تسعون: 90, تسعين: 90,
};
const HUNDREDS: Record<string, number> = {
  مايه: 100, ميه: 100, مئه: 100, مائه: 100, مائتان: 200, مائتين: 200, مئتان: 200, مئتين: 200, ميتين: 200,
  ثلاثمايه: 300, ثلاثمائه: 300, ثلاثمئه: 300, ثلثمايه: 300, اربعمايه: 400, اربعمائه: 400, اربعمئه: 400,
  خمسمايه: 500, خمسمائه: 500, خمسمئه: 500, ستمايه: 600, ستمائه: 600, ستمئه: 600, سبعمايه: 700,
  سبعمائه: 700, سبعمئه: 700, ثمانمايه: 800, ثمانمائه: 800, ثمانمئه: 800, ثمانيمايه: 800, تسعمايه: 900,
  تسعمائه: 900, تسعمئه: 900,
};
const THOUSANDS = new Set(['الف', 'الاف', 'الفان', 'الفين']);
const MILLIONS = new Set(['مليون', 'ملايين', 'مليونان', 'مليونين']);
const FILLERS = new Set(['فقط', 'لا', 'غير', 'جنيه', 'جنيها', 'مصري', 'مصريا', 'مصرى']);

function norm(word: string): string {
  // بعد التوحيد: ة→ه، ى→ي، همزات→ا؛ نوحّد أشكال الأعداد التى تتغير بهما
  return normalizeArabicForMatch(word).replace(/^و(?=[^\s])/, '');
}

/**
 * يحوّل عبارة عددية بالحروف ("مليون ومائة وخمسة وعشرون ألف") إلى عدد صحيح، أو null إن تعذّر فهمها كلها
 * (فشل مغلق: لا نخمّن). يغطى الآحاد والعشرات والمئات والآلاف والملايين.
 */
export function parseArabicNumberWords(phrase: string): number | null {
  const tokens = normalizeArabicForMatch(phrase)
    .split(' ')
    .map((t) => norm(t))
    .filter((t) => t.length > 0 && !FILLERS.has(t));
  if (tokens.length === 0) return null;

  let total = 0;
  let current = 0;
  let seen = false;
  for (const t of tokens) {
    if (MILLIONS.has(t)) {
      total += (current === 0 ? (t === 'مليونان' || t === 'مليونين' ? 2 : 1) : current) * 1_000_000;
      current = 0;
    } else if (THOUSANDS.has(t)) {
      const mult = current === 0 ? (t === 'الفان' || t === 'الفين' ? 2 : 1) : current;
      total += mult * 1000;
      current = 0;
    } else if (t in HUNDREDS) {
      current += HUNDREDS[t];
    } else if (t in TENS) {
      current += TENS[t];
    } else if (t in UNITS) {
      current += UNITS[t];
    } else if (t in TEENS) {
      current += TEENS[t];
    } else {
      return null;
    }
    seen = true;
  }
  return seen ? total + current : null;
}

// ===== المبلغ بالأرقام مقابل الحروف =====

export interface AmountMismatch {
  digits: number;
  words: number;
  wordsText: string;
}

/**
 * يبحث عن النمط الشائع "1125000 ( مليون ومائة ... جنيه مصرى فقط )" (الرقم ثم الحروف بين قوسين، أو العكس)، ويُرجع
 * التعارضات فقط. العبارة التى لا يفهمها المحلل بالكامل تُتجاهل (لا تحذير).
 */
export function findAmountMismatches(text: string): AmountMismatch[] {
  const out: AmountMismatch[] = [];
  const clean = (text ?? '').replace(/[‎‏‪-‮⁦-⁩﻿]/g, '');
  const digitsThenWords = /(\d[\d,٬.]*)\s*(?:جنيه\s*(?:مصري|مصرى)?\s*)?[(（]\s*([^()（）\n]{4,120}?)\s*[)）]/gu;
  for (const m of clean.matchAll(digitsThenWords)) {
    const digits = Number(m[1].replace(/[,٬]/g, ''));
    if (!Number.isFinite(digits) || digits < 100) continue; // أرقام صغيرة (نسب/أعداد) خارج نطاق هذا الفحص
    const words = parseArabicNumberWords(m[2]);
    if (words === null || words < 100) continue;
    if (words !== digits) out.push({ digits, words, wordsText: m[2].trim() });
  }
  return out;
}

// ===== الدفعات =====

export interface InstallmentRead {
  percentages: number[];
  /** true إن لم تُقرأ علامة % بوضوح فى بعض الدفعات (القراءة الآلية تحوّلها كثيراً إلى 9 أو 90 أو تلصقها بالرقم: "9040" = %40) */
  reconstructed: boolean;
  sum: number;
}

const INSTALLMENT_LINE = /دفعه\s+(?:ال)?(?:اولي|اولى|ثانيه|ثالثه|رابعه|خامسه|سادسه|اخيره)/;

/**
 * يلتقط نسب الدفعات المتتابعة، سطراً بسطر: "الدفعة الأولى : قيمتها 30 % تسدد عند التعاقد". يتسامح مع تشوّه علامة % فى القراءة
 * الآلية (اختبار حى على عقد ممسوح: "30 9"، "30 90"، "9040") ويضع reconstructed=true. يُرجع null إن وُجدت أقل من دفعتين.
 */
export function checkInstallments(text: string): InstallmentRead | null {
  const values: number[] = [];
  let reconstructed = false;
  for (const raw of (text ?? '').replace(/[\u200e\u200f\u202a-\u202e\u2066-\u2069\ufeff]/g, '').split('\n')) {
    if (!INSTALLMENT_LINE.test(normalizeArabicForMatch(raw))) continue;
    const colon = raw.search(/[:：]/);
    const seg = colon >= 0 ? raw.slice(colon + 1) : raw;
    const clean = seg.match(/(?<![\d.])(\d{1,3}(?:\.\d+)?)\s*[%٪]/);
    if (clean) {
      values.push(Number(clean[1]));
      continue;
    }
    const tokens = seg.match(/\d+(?:\.\d+)?/g) ?? [];
    const first = tokens[0];
    if (!first) continue;
    if (/^90\d{2}$/.test(first)) {
      values.push(Number(first.slice(2)));
      reconstructed = true;
    } else if (first.length <= 3) {
      values.push(Number(first));
      reconstructed = true;
    }
  }
  if (values.length < 2) return null;
  return { percentages: values, reconstructed, sum: Math.round(values.reduce((a, b) => a + b, 0) * 100) / 100 };
}

// ===== التحذيرات للمستخدم =====

function fmt(n: number): string {
  return n.toLocaleString('en-US');
}

/** تحذيرات حسابية غير حاجبة تُضاف إلى تنبيهات العقد؛ فارغة إن لم يُكتشف تناقض. */
export function numericWarnings(text: string): string[] {
  const out: string[] = [];
  for (const m of findAmountMismatches(text)) {
    out.push(
      `تناقض فى مبلغ: الرقم ${fmt(m.digits)} لا يطابق المكتوب بالحروف («${m.wordsText}» = ${fmt(m.words)}) — قد يكون خطأ قراءة آلية أو خطأ فى العقد الأصلى؛ قارن بالأصل قبل الاعتماد.`,
    );
  }
  const inst = checkInstallments(text);
  if (inst && Math.abs(inst.sum - 100) > 0.001) {
    out.push(
      `نسب الدفعات (${inst.percentages.join(' + ')}) مجموعها ${inst.sum}% وليس 100% — قد تكون دفعة ناقصة أو زائدة أو خطأ قراءة؛ راجع شروط الدفع فى الأصل.`,
    );
  } else if (inst && inst.reconstructed) {
    out.push(
      `علامة % فى نسب الدفعات (${inst.percentages.join(' + ')}) لم تُقرأ بوضوح من الصورة؛ بعد تصحيحها يساوى المجموع 100%. تأكد من كل نسبة بالأصل قبل الاعتماد.`,
    );
  }
  return out;
}
