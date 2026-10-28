import { hasMandatoryMarker, normalizeArabicForMatch } from './reasoning.util';

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

const BINDING_CLAIM =
  /لا\s+تجيز(?:\s+\S+){0,3}\s+(?:الاتفاق|مخالفت)|لا\s+يجوز\s+الاتفاق|(?:ال)?آمر[ةه]|ناهي[ةه]|لا\s+يجوز\s+مخالفت/;

function articleRefNumbers(text: string): number[] {
  const out: number[] = [];
  for (const m of toWesternDigits(text).matchAll(/(?:ال)?ماد[ةه]\s*(?:رقم\s*)?\(?\s*(\d+)/g)) out.push(Number(m[1]));
  for (const m of toWesternDigits(text).matchAll(/(?:ال)?ماد[ةه]\s*(?:رقم\s*)?\d+(?:\s*(?:،|,|و)\s*(\d+))+/g)) {
    for (const n of m[0].matchAll(/\d+/g)) out.push(Number(n[0]));
  }
  return out;
}

/** كلمات لا تنتهى بها جملة تامة: ورودها آخر نص البند الأصلى يعنى أن القراءة الآلية بُترت عندها. */
const DANGLING_END = new Set(
  ['على', 'الى', 'إلى', 'فى', 'في', 'من', 'عن', 'ب', 'ل', 'و', 'ان', 'أن', 'التي', 'التى', 'الذي', 'الذى', 'مع', 'حتى', 'او', 'أو', 'ثم', 'كما', 'بين', 'ما', 'عند', 'قبل', 'بعد', 'خلال', 'لدى', 'لدي'].map((w) =>
    normalizeArabicForMatch(w),
  ),
);
export const TRUNCATION_PLACEHOLDER = '[عبارة غير مكتملة فى الأصل المقروء — تُستكمل من النسخة الموقعة]';
export const TRUNCATION_NOTE = 'أُبقيت آخر عبارة فى البند كما قُرئت دون استكمالها بالتخمين؛ تُستكمل من النسخة الموقعة.';

interface RawToken {
  norm: string;
  end: number;
}

function rawTokens(text: string): RawToken[] {
  const out: RawToken[] = [];
  for (const m of text.matchAll(/\S+/g)) {
    const norm = normalizeArabicForMatch(m[0]);
    if (norm) out.push({ norm, end: (m.index ?? 0) + m[0].length });
  }
  return out;
}

/**
 * القراءة الآلية للمسح الضوئى قد تبتر البند فى منتصف جملة («للحفاظ على»). النموذج يميل إلى إكمالها بما يخمّنه («حقوقه») فتُنسب
 * للعقد عبارة لم يقرأها أحد. إن انتهى الأصل بكلمة لا تنتهى بها جملة تامة وبلا علامة وقف، تُقطع الصياغة عند أول عبارتين مطابقتين
 * لذيل الأصل ويُستبدل ما بعدهما بعلامة صريحة، فلا تُستكمل العبارة بالتخمين. فشل مغلق: إن لم يوجد الذيل فى الصياغة لا تغيير.
 */
export function sealTruncatedTail(original: string, proposed: string): { text: string; sealed: boolean } {
  const orig = (original ?? '').trim();
  if (!orig || /[.!؟؛:)»"”\]]$/.test(orig)) return { text: proposed, sealed: false };
  const ot = rawTokens(orig);
  if (ot.length < 3 || !DANGLING_END.has(ot[ot.length - 1].norm)) return { text: proposed, sealed: false };
  const tail = [ot[ot.length - 2].norm, ot[ot.length - 1].norm];
  const pt = rawTokens(proposed);
  for (let i = pt.length - 2; i >= 0; i -= 1) {
    if (pt[i].norm !== tail[0] || pt[i + 1].norm !== tail[1]) continue;
    const rest = proposed.slice(pt[i + 1].end).replace(/[\s.،؛:!؟\-–—]+/g, '');
    if (rest.length === 0) return { text: proposed, sealed: false };
    return { text: `${proposed.slice(0, pt[i + 1].end).trimEnd()} ${TRUNCATION_PLACEHOLDER}`, sealed: true };
  }
  return { text: proposed, sealed: false };
}

export function validateRedraft(input: {
  proposedText: string;
  changes: string[];
  originalText: string;
  articleTexts: string[];
  approvedArticleNos: number[];
}): { ok: true; proposal: RedraftProposal } | { ok: false; reason: string } {
  const sealedTail = sealTruncatedTail(input.originalText, (input.proposedText ?? '').trim());
  const text = sealedTail.text;
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
  const hasPlaceholder = text.includes('[____]');
  const textOfArticle = new Map<number, string>();
  input.approvedArticleNos.forEach((n, i) => textOfArticle.set(n, input.articleTexts[i] ?? ''));
  const changes = (input.changes ?? [])
    .map((c) => (typeof c === 'string' ? c.trim() : ''))
    .filter((c) => c.length > 0)
    .filter((c) => !/(?:ال)?مرشح/.test(c))
    .filter((c) => {
      const refs = [...toWesternDigits(c).matchAll(/(?:ال)?ماد[ةه]\s*(?:رقم\s*)?(\d+)/g)].map((m) => Number(m[1]));
      return refs.every((n) => approved.has(n));
    })
    // ملاحظة تذكر فراغاً [____] والنص المقترح بلا فراغ: وصف غير صحيح لما حدث (اختبار حى 7)
    .filter((c) => hasPlaceholder || !/\[____\]|فراغ/.test(c))
    // ملاحظة تصف مادة بأنها "آمرة/لا تجيز الاتفاق على مخالفتها" ولا يحمل نص المادة المعروض صيغة
    // ملزمة صريحة: ادعاء بلا سند حرفى (المادة 608 فى اختبار حى 7)؛ تُحذف الملاحظة لا النص.
    .filter((c) => {
      if (!BINDING_CLAIM.test(c)) return true;
      const refs = [...toWesternDigits(c).matchAll(/(?:ال)?ماد[ةه]\s*(?:رقم\s*)?(\d+)/g)].map((m) => Number(m[1]));
      return refs.length > 0 && refs.some((n) => hasMandatoryMarker(textOfArticle.get(n) ?? ''));
    })
    .slice(0, 6);
  if (sealedTail.sealed) changes.unshift(TRUNCATION_NOTE);

  return { ok: true, proposal: { text, changes } };
}

/** صياغة عربية ثابتة لسبب رفض الفحص الآلى، تُبلَّغ للنموذج فى المحاولة الثانية */
export function describeRedraftRejection(reason: string): string {
  const PLACEHOLDER_ADVICE = ' استعمل [____] بدل أى رقم أو مدة أو مبلغ لم يرد فى البند الأصلى أو فى نص المواد.';
  if (reason.startsWith('invented_number_word')) return `ذكرت عدداً أو مدة مكتوبة بالحروف لم ترد فى البند الأصلى أو فى نص المواد.${PLACEHOLDER_ADVICE}`;
  if (reason.startsWith('invented_number')) return `ذكرت رقماً أو مبلغاً أو نسبة لم ترد فى البند الأصلى أو فى نص المواد.${PLACEHOLDER_ADVICE}`;
  if (reason.startsWith('article_number_in_clause_text')) return 'ذكرت رقم مادة قانونية داخل نص البند نفسه.';
  if (reason === 'candidate_leak') return 'ذكرت ترقيماً داخلياً للمرشحين.';
  if (reason === 'identical_to_original') return 'أعدت البند الأصلى كما هو دون تغيير.';
  if (reason === 'too_long') return 'الصياغة أطول كثيراً من البند الأصلى.';
  return 'الصياغة لم تجتز فحوص الأمان.';
}

/** سبب رفض فحص حماية مركز العميل (الناتج من المدقق المستقل) يُبلَّغ للنموذج فى المحاولة الثانية */
export function describeWeakeningFeedback(reason: string): string {
  const r = (reason ?? '').replace(/\s+/g, ' ').trim().slice(0, 240);
  return `أضعفت مركز العميل أو منحت الطرف الآخر أو الغير حقاً جديداً${r ? ` (${r})` : ''}. أبقِ حقوق العميل كما هى كما وردت فى البند الأصلى، وعالج الخطر المبيَّن بإلزام الطرف الآخر بما يحقق شرط النفاذ أو الحماية، أو اجعل needs_change=false مع شرح السبب.`;
}
