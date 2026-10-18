import { normalizeArabicForMatch } from './reasoning.util';

/**
 * حواجز الصياغة البديلة المقترحة لبند عقد. النموذج اللغوى لا يُوثَق به لضمان الأمانة،
 * فكل اقتراح يمر ببوابة حتمية، وما لا يجتازها يُرفض (fail-closed) ولا يُعرَض:
 *  - لا أرقام/مبالغ/نسب/مدد (بالأرقام أو بالحروف) غير موجودة فى البند الأصلى أو فى نص
 *    المواد المعتمَدة (ما ينقص يُترك فراغاً [____] ليملأه صاحب العقد أو محاميه).
 *  - لا أرقام مواد قانونية داخل نص البند المقترح (بنود العقود لا تحتاجها).
 *  - لا تسرب لترقيم المرشحين الداخلى.
 *  - لا نص مطابق للأصل (لا فائدة) ولا طول مبالغ فيه.
 *  - بنود "التغييرات" التى تذكر رقم مادة غير معتمَد تُحذف.
 */
export const REDRAFT_DISCLAIMER = 'صياغة مقترحة للاسترشاد، تُراجَع من محامٍ قبل الاعتماد؛ وليست نصاً معتمداً.';

export interface RedraftProposal {
  text: string;
  changes: string[];
}

const NUMBER_WORDS = [
  'واحد', 'اثنين', 'اثنان', 'ثلاث', 'ثلاثه', 'ثلاثين', 'اربع', 'اربعه', 'اربعين', 'خمس', 'خمسه', 'خمسين',
  'ست', 'سته', 'ستين', 'سبع', 'سبعه', 'سبعين', 'ثمان', 'ثماني', 'ثمانيه', 'ثمانين', 'تسع', 'تسعه', 'تسعين',
  'عشر', 'عشره', 'عشرين', 'مائه', 'ميه', 'مئه', 'الف', 'مليون', 'نصف', 'ربع', 'سنتين', 'شهرين', 'يومين',
];

function toWesternDigits(text: string): string {
  return (text ?? '')
    .replace(/[٠-٩]/g, (d) => String('٠١٢٣٤٥٦٧٨٩'.indexOf(d)))
    .replace(/[۰-۹]/g, (d) => String('۰۱۲۳۴۵۶۷۸۹'.indexOf(d)));
}

/**
 * أرقام الترقيم "(2)" وأرقام الإحالة "المادة 215" ليست قيماً تعاقدية: تُستبعد قبل المقارنة
 * (وإلا سمح رقم فقرة فى نص المادة، مثل "(2)"، بنسبة "2%" مخترعة فى الصياغة).
 */
function stripNonValueNumbers(text: string): string {
  return toWesternDigits(text)
    .replace(/\(\s*\d+\s*\)/g, ' ')
    .replace(/(?:ال)?ماد[ةه]\s*(?:رقم\s*)?\d+(?:\s*(?:،|,|و|إلى|الى)\s*\d+)*/g, ' ')
    .replace(/(?:ال)?مواد\s*(?:من\s*)?\d+(?:\s*(?:،|,|و|إلى|الى)\s*\d+)*/g, ' ');
}

function digitTokens(text: string): string[] {
  return (stripNonValueNumbers(text).match(/\d+(?:[.,]\d+)?/g) ?? []).map((t) => t.replace(',', '.'));
}

function wordSet(text: string): Set<string> {
  return new Set(normalizeArabicForMatch(text).split(' ').filter(Boolean));
}

/** كلمات الأعداد بلا سابقة "ال"/"و"/"ب"/"ل" الشائعة */
function numberWordsIn(text: string): string[] {
  const out: string[] = [];
  for (const tok of normalizeArabicForMatch(text).split(' ')) {
    const stem = tok.replace(/^(?:و|ب|ل|ال|وال|بال|لل)/, '');
    if (NUMBER_WORDS.includes(stem) || NUMBER_WORDS.includes(tok)) out.push(stem || tok);
  }
  return out;
}

function articleRefNumbers(text: string): number[] {
  const out: number[] = [];
  for (const m of toWesternDigits(text).matchAll(/(?:ال)?ماد[ةه]\s*(?:رقم\s*)?\(?\s*(\d+)/g)) out.push(Number(m[1]));
  for (const m of toWesternDigits(text).matchAll(/(?:ال)?ماد[ةه]\s*(?:رقم\s*)?\d+(?:\s*(?:،|,|و)\s*(\d+))+/g)) {
    for (const n of m[0].matchAll(/\d+/g)) out.push(Number(n[0]));
  }
  return out;
}

export function validateRedraft(input: {
  proposedText: string;
  changes: string[];
  originalText: string;
  articleTexts: string[];
  approvedArticleNos: number[];
}): { ok: true; proposal: RedraftProposal } | { ok: false; reason: string } {
  const text = (input.proposedText ?? '').trim();
  if (text.length < 20) return { ok: false, reason: 'empty_or_too_short' };
  if (text.length > Math.max(1500, input.originalText.length * 3 + 400)) {
    return { ok: false, reason: 'too_long' };
  }
  if (normalizeArabicForMatch(text) === normalizeArabicForMatch(input.originalText)) {
    return { ok: false, reason: 'identical_to_original' };
  }
  if (/(?:ال)?مرشح/.test(text)) return { ok: false, reason: 'candidate_leak' };
  // إحالة داخلية موجودة أصلاً فى البند الأصلى (مثل "المادة 5 من هذا العقد") تُبقى كما هى؛ المرفوض هو
  // رقم مادة لم يرد فى الأصل (سجلات الإنتاج: البند 6 رُفض ثلاث مرات لإبقائه إحالة من أصله).
  const originalRefs = new Set(articleRefNumbers(input.originalText));
  const newRef = articleRefNumbers(text).find((n) => !originalRefs.has(n));
  if (newRef !== undefined || /\b[Aa]rt(?:icle)?\.?\s*\d+/.test(text)) {
    return { ok: false, reason: `article_number_in_clause_text${newRef !== undefined ? ':' + newRef : ''}` };
  }

  const allowedSource = `${input.originalText}\n${input.articleTexts.join('\n')}`;
  const allowedDigits = new Set(digitTokens(allowedSource));
  for (const d of digitTokens(text)) {
    if (!allowedDigits.has(d)) return { ok: false, reason: `invented_number:${d}` };
  }
  const allowedWords = wordSet(allowedSource);
  const allowedStems = new Set<string>(numberWordsIn(allowedSource));
  for (const w of numberWordsIn(text)) {
    if (!allowedStems.has(w) && !allowedWords.has(w)) return { ok: false, reason: `invented_number_word:${w}` };
  }

  const approved = new Set(input.approvedArticleNos);
  const changes = (input.changes ?? [])
    .map((c) => (typeof c === 'string' ? c.trim() : ''))
    .filter((c) => c.length > 0)
    .filter((c) => !/(?:ال)?مرشح/.test(c))
    .filter((c) => {
      const refs = [...toWesternDigits(c).matchAll(/(?:ال)?ماد[ةه]\s*(?:رقم\s*)?(\d+)/g)].map((m) => Number(m[1]));
      return refs.every((n) => approved.has(n));
    })
    .slice(0, 6);

  return { ok: true, proposal: { text, changes } };
}

/** صياغة عربية ثابتة لسبب رفض الفحص الآلى، تُبلَّغ للنموذج فى المحاولة الثانية */
export function describeRedraftRejection(reason: string): string {
  if (reason.startsWith('invented_number_word')) return 'ذكرت عدداً أو مدة مكتوبة بالحروف لم ترد فى البند الأصلى أو فى نص المواد.';
  if (reason.startsWith('invented_number')) return 'ذكرت رقماً أو مبلغاً أو نسبة لم ترد فى البند الأصلى أو فى نص المواد.';
  if (reason.startsWith('article_number_in_clause_text')) return 'ذكرت رقم مادة قانونية داخل نص البند نفسه.';
  if (reason === 'candidate_leak') return 'ذكرت ترقيماً داخلياً للمرشحين.';
  if (reason === 'identical_to_original') return 'أعدت البند الأصلى كما هو دون تغيير.';
  if (reason === 'too_long') return 'الصياغة أطول كثيراً من البند الأصلى.';
  return 'الصياغة لم تجتز فحوص الأمان.';
}
