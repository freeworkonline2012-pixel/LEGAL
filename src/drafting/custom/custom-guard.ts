/**
 * حارس مخرجات النموذج اللغوى فى صياغة «عقد آخر». النموذج لا يُوثَق به: كل ما يعيده يُفحص هنا حتمياً قبل أن يدخل المسودة.
 *
 * ما يمنعه الحارس (وكل منع مغطى باختبار):
 *  1) أى رقم أو مدة أو مبلغ أو نسبة (بالأرقام أو بالحروف) لم يكتبها المستخدم نفسه فى إجاباته: يُستبدل فراغاً [____] يملؤه صاحب العقد.
 *  2) أى استشهاد بمادة أو قانون أو لائحة أو حكم (النموذج قد يخترع رقماً أو نصاً): تُحذف الفقرة.
 *  3) أى فقرة تخالف قاعدة آمرة تعرفها المنصة (mandatory-rules): تُحذف الفقرة.
 *  4) الروابط والـHTML والماركداون وأنماط الفراغ المتنوعة: تُوحَّد فراغاً واحداً [____] أو تُحذف الفقرة.
 *  5) بنود الهيكل الثابت (إخطارات، منازعات، أحكام عامة، توقيع): يكتبها القالب لا النموذج، فيُحذف أى بند بهذا العنوان.
 * الناتج: بنود نظيفة + إحصاءات (فراغات، فقرات محذوفة) تظهر للمستخدم صراحة.
 */

import { mandatoryRuleHits } from '../../contracts/mandatory-rules';

export interface ModelClause {
  title: string;
  paragraphs: string[];
}

export interface GuardResult {
  clauses: ModelClause[];
  blanks: number;
  droppedParagraphs: number;
  droppedClauses: number;
  /** أرقام/كلمات عدد غير مصرَّح بها استُبدلت فراغاً */
  maskedNumbers: number;
  /** أسباب الحذف (نصوص ثابتة من الحارس، بلا محتوى المستخدم) */
  problems: string[];
}

export const MIN_CLAUSES = 4;
const MAX_CLAUSES = 20;
const MAX_PARAGRAPHS = 10;
const MAX_PARAGRAPH_CHARS = 1500;
const MIN_PARAGRAPH_CHARS = 15;
const MAX_TOTAL_CHARS = 30000;
const BLANK = '[____]';

const CONTROL = /[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F‎‏‪-‮⁦-⁩]/g;

const SKELETON_TITLE = /منازع|اختصاص|تحكيم|إخطار|اخطار|أحكام عامة|الأحكام العامة|ديباجة|التوقيع|القانون الواجب/;

const MARKUP = /https?:\/\/|www\.|[<>`]|^#{1,6}\s|\*\*/;
const CITATION =
  /(?:ال)?ماد[ةه]\s+(?:رقم\s+)?[\d٠-٩(]|(?:ال)?ماد[ةه]\s+\S{1,20}\s+من\s+(?:ال)?قانون|(?:ال)?قانون\s+رقم|لسنة\s|اللائحة\s+التنفيذية|محكمة\s+النقض|الطعن\s+رقم/;

function toLatinDigits(s: string): string {
  return s.replace(/[٠-٩]/g, (d) => String('٠١٢٣٤٥٦٧٨٩'.indexOf(d)));
}

function normAr(s: string): string {
  return s
    .replace(/[ً-ٰٟـ]/g, '')
    .replace(/[أإآ]/g, 'ا')
    .replace(/ة/g, 'ه')
    .replace(/ى/g, 'ي')
    .replace(/ئ/g, 'ي')
    .replace(/ؤ/g, 'و');
}

/** كلمات العدد التى لا يجوز أن ينفرد بها النموذج (بعد التوحيد). «واحد/اثنان» مستثناة لأنها تُستعمل بلا معنى كمّى («طرف واحد»). */
const NUMBER_WORDS = [
  'ثلاثه', 'ثلاث', 'اربعه', 'اربع', 'خمسه', 'خمس', 'سته', 'ست', 'سبعه', 'سبع', 'ثمانيه', 'ثمان', 'تسعه', 'تسع', 'عشره', 'عشر',
  'عشرين', 'ثلاثين', 'اربعين', 'خمسين', 'ستين', 'سبعين', 'ثمانين', 'تسعين',
  'مايه', 'مائه', 'ماءه', 'مئه', 'مائتين', 'مئتين', 'مايتين', 'ثلاثمائه', 'اربعمائه', 'خمسمائه', 'ستمائه', 'سبعمائه', 'ثمانمائه', 'تسعمائه',
  'الف', 'الاف', 'الفين', 'مليون', 'مليونين', 'ملايين', 'مليار',
];
const NUMBER_WORD_SET = new Set(NUMBER_WORDS.map(normAr));
const AR = '\\u0621-\\u064A';
const WORD_RE = new RegExp(`(?<![${AR}])((?:[وفبلك]|ال|لل|وال|بال|كال|فال)?)([${AR}\\u064B-\\u065F]+)(?![${AR}])`, 'gu');

/** أرقام المستخدم المسموحة: كل تتابع أرقام فى إجاباته (بعد توحيد الأرقام وحذف فواصل الآلاف). */
export function allowedNumbersOf(text: string): Set<string> {
  const out = new Set<string>();
  for (const m of toLatinDigits(text).matchAll(/\d[\d,.،٬]*/g)) out.add(m[0].replace(/[,،٬]/g, '').replace(/\.$/, ''));
  return out;
}

export function allowedNumberWordsOf(text: string): Set<string> {
  const out = new Set<string>();
  for (const m of normAr(text).matchAll(WORD_RE)) {
    for (const w of [m[1] + m[2], m[2]]) if (NUMBER_WORD_SET.has(w)) out.add(w);
  }
  return out;
}

function stripWordParentheses(text: string): string {
  // «500000 (خمسمائة ألف جنيه مصرى فقط)»: كتابة المبلغ بالحروف من النموذج لا يُوثق بها؛ تُحذف القوسان بما فيهما
  return text.replace(/\s*\(([^()\n]{1,120})\)/g, (whole, inner: string) => {
    const toks = normAr(inner).split(/\s+/).filter(Boolean);
    if (toks.length === 0) return whole;
    const isNumberish = (t: string) => {
      const bare = t.replace(/^(?:و|ال|وال)/, '');
      return NUMBER_WORD_SET.has(t) || NUMBER_WORD_SET.has(bare) || ['جنيه', 'جنيها', 'مصري', 'مصريا', 'فقط', 'لا', 'غير', 'يوما', 'ايام', 'شهرا', 'اشهر', 'سنه', 'سنوات', 'سنتين', 'ثلاثه', 'و'].includes(t);
    };
    return toks.every(isNumberish) && toks.some((t) => NUMBER_WORD_SET.has(t.replace(/^(?:و|ال|وال)/, '')) || NUMBER_WORD_SET.has(t)) ? '' : whole;
  });
}

interface ParagraphOutcome {
  text: string | null;
  masked: number;
  reason?: string;
}

function cleanParagraph(raw: string, allowedNums: Set<string>, allowedWords: Set<string>): ParagraphOutcome {
  let t = raw.replace(CONTROL, '').replace(/\s+/g, ' ').trim();
  // علامة الترقيم الافتتاحية يعيد الحارس كتابتها
  t = t.replace(/^\(?(?:\d{1,2}|[٠-٩]{1,2})\)?\s*[-–.)]?\s+/, '').replace(/^[-–•*]\s+/, '');
  if (MARKUP.test(t)) return { text: null, masked: 0, reason: 'روابط أو رموز تنسيق' };
  if (CITATION.test(t)) return { text: null, masked: 0, reason: 'استشهاد بمادة أو قانون غير موثَّق' };

  // أنماط الفراغ المتنوعة تُوحَّد
  t = t.replace(/\[[^\]\n]{0,60}\]/g, BLANK).replace(/(?<!\[)_{3,}(?!\])/g, BLANK).replace(/\.{4,}|…+/g, BLANK);

  t = stripWordParentheses(t);

  let masked = 0;
  t = t.replace(/[\d٠-٩][\d٠-٩,.،٬]*/g, (m) => {
    const norm = toLatinDigits(m).replace(/[,،٬]/g, '').replace(/\.$/, '');
    if (allowedNums.has(norm)) return m;
    masked++;
    return BLANK;
  });
  t = t.replace(WORD_RE, (whole, prefix: string, word: string) => {
    // «الف» تُقرأ بادئة «ال» + «ف»: تُجرَّب الكلمة كاملة أولاً ثم بلا بادئة
    const full = normAr(prefix + word);
    const bare = normAr(word);
    if (NUMBER_WORD_SET.has(full)) {
      if (allowedWords.has(full)) return whole;
      masked++;
      return BLANK;
    }
    if (!NUMBER_WORD_SET.has(bare) || allowedWords.has(bare)) return whole;
    masked++;
    return `${prefix}${BLANK}`;
  });
  // [____] متجاورة من رقم وكتابته أو عدد مركّب تصير فراغاً واحداً
  t = t.replace(/\[____\](?:\s*(?:و|ثم)?\s*\[____\])+/g, BLANK).replace(/\[____\]\s*\(\s*\[____\]\s*\)/g, BLANK);

  if (t.length < MIN_PARAGRAPH_CHARS) return { text: null, masked, reason: 'فقرة قصيرة أو فارغة' };
  if (t.length > MAX_PARAGRAPH_CHARS) return { text: null, masked, reason: 'فقرة أطول من الحد' };
  if (mandatoryRuleHits(t).length > 0) return { text: null, masked, reason: 'مخالفة لنص آمر' };
  return { text: t, masked };
}

export function guardModelClauses(rawClauses: unknown, userInputText: string): GuardResult {
  const result: GuardResult = { clauses: [], blanks: 0, droppedParagraphs: 0, droppedClauses: 0, maskedNumbers: 0, problems: [] };
  if (!Array.isArray(rawClauses)) return result;
  const allowedNums = allowedNumbersOf(userInputText);
  const allowedWords = allowedNumberWordsOf(userInputText);
  const seenTitles = new Set<string>();
  const reasons = new Set<string>();
  let total = 0;

  for (const rc of rawClauses.slice(0, MAX_CLAUSES + 10)) {
    if (result.clauses.length >= MAX_CLAUSES) break;
    if (!rc || typeof rc !== 'object') continue;
    const o = rc as { title?: unknown; paragraphs?: unknown };
    const title = typeof o.title === 'string' ? o.title.replace(CONTROL, '').replace(/[\d٠-٩]+/g, '').replace(/\s+/g, ' ').replace(/^[\s:.\-–()]+|[\s:.\-–()]+$/g, '') : '';
    if (title.length < 2 || title.length > 80 || MARKUP.test(title) || SKELETON_TITLE.test(title) || /^البند\s/.test(title)) {
      result.droppedClauses++;
      continue;
    }
    const key = normAr(title);
    if (seenTitles.has(key)) {
      result.droppedClauses++;
      continue;
    }
    const paras = Array.isArray(o.paragraphs) ? o.paragraphs : typeof o.paragraphs === 'string' ? [o.paragraphs] : [];
    const kept: string[] = [];
    for (const p of paras.slice(0, MAX_PARAGRAPHS)) {
      if (typeof p !== 'string') continue;
      const out = cleanParagraph(p, allowedNums, allowedWords);
      result.maskedNumbers += out.masked;
      if (out.text === null) {
        result.droppedParagraphs++;
        if (out.reason) reasons.add(out.reason);
        continue;
      }
      if (total + out.text.length > MAX_TOTAL_CHARS) break;
      total += out.text.length;
      kept.push(out.text);
    }
    if (kept.length === 0) {
      result.droppedClauses++;
      continue;
    }
    seenTitles.add(key);
    const numbered = kept.length > 1 ? kept.map((p, i) => `(${i + 1}) ${p}`) : kept;
    result.blanks += numbered.reduce((n, p) => n + (p.match(/\[____\]/g)?.length ?? 0), 0);
    result.clauses.push({ title, paragraphs: numbered });
  }
  result.problems = [...reasons];
  return result;
}
