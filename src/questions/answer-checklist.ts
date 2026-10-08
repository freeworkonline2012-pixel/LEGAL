import { contentStems, extractArticleNumbers, normalizeForQuote } from './answer-grounding';
import type { StructuredAnswer, StructuredRuling } from './structured-answer';

/**
 * قائمة الفحص الثابتة للإجابة (2j — توصية تقييم حى 7/10): كل نسخة من النظام كانت تصلح خطأً وتكسر آخر
 * (8 ← 7.5 ← 7) لأن الأخطاء المعالَجة سابقاً لا يحرسها شىء حين تُعدَّل القواعد. هذه القائمة هى الحارس:
 *  - نصها يُحقَن فى تعليمات التوليد وفى الناقد فيراجعها كل جواب قبل اعتماده (ANSWER_CHECKLIST_TEXT)،
 *  - وما يمكن فحصه حتمياً يُفحَص ويُصلَح هنا بلا اعتماد على النموذج (applyChecklist)،
 *  - وكل بند له اختبار انحدار يعيد خطأ سبق وقوعه فى تقييم حى (answer-checklist.spec.ts)، فلا يعود خطأ صُحِّح.
 * دوال نقية (بلا I/O ولا نموذج).
 */

export interface ChecklistItem {
  id: string;
  /** صياغة البند للتعليمات والناقد. */
  rule: string;
}

export const ANSWER_CHECKLIST: readonly ChecklistItem[] = [
  { id: 'C1', rule: 'المادة 161 تخص العقد غير محدد المدة وحده؛ لا يُقال عنها «فى العقد محدد المدة».' },
  { id: 'C2', rule: 'مهلة السبعة أيام فى المادة 108 على صاحب العمل بعد مطالبة العامل، لا على العامل.' },
  { id: 'C3', rule: 'مسار طبيعة العمل يستند إلى المادة 87 لا إلى المادة 88 (التى تعدّد حالات غيرها).' },
  { id: 'C4', rule: 'لا يُنسب حكم أو وصف إلى مادة لا يرد فى نصها؛ ولا يُوسَم «نص» ما أضاف إلى مقتطفه ما ليس فيه.' },
  {
    id: 'C5',
    rule:
      'الحقوق الثابتة تُذكر فى كل جواب يذكر فيه السائل مستحقات غير مستلمة أو نزاعاً: الأجر وميعاد صرفه (108)، ' +
      'مقابل رصيد الإجازات (125)، شهادة نهاية الخدمة (175)، بطلان المخالصة (6)، التسوية الودية (149)، والمحكمة (150).',
  },
  { id: 'C6', rule: 'المسار الأنفع للعامل بوقائعه يُطرح أصلياً إن كان القاعدة العامة فى النص، والأضعف احتياطياً.' },
  { id: 'C7', rule: 'الجواب المباشر يخاطب حالة السائل بوقائعها («فى حالتك...») ولا يكتفى بقاعدتين عامتين بصيغة «إذا».' },
  { id: 'C8', rule: 'كل احتمال تنفيه إجابات السائل يُحذف ولا يُعرَض، ويُبنى الجواب المباشر على الاحتمال المنطبق وحده.' },
];

/** نص القائمة للحقن فى التعليمات والناقد. */
export const ANSWER_CHECKLIST_TEXT: string = ANSWER_CHECKLIST.map((c) => `${c.id}) ${c.rule}`).join('\n');

/** مواد الحقوق الثابتة (C5): تُفرَض حتمياً إن أُرسلت للنموذج ولم يستند إليها الجواب. */
export const FIXED_RIGHTS_ARTICLES: readonly number[] = [6, 108, 125, 175, 149, 150];

export interface ChecklistArticle {
  articleNo: number;
  text: string;
}

export interface ChecklistOptions {
  /** هل ذكر السائل مستحقات غير مستلمة أو نزاعاً (يفعّل C5). */
  duesMode: boolean;
}

export interface ChecklistResult {
  value: StructuredAnswer;
  /** وصف موجز لكل إصلاح (للتسجيل التشخيصى فقط). */
  fixes: string[];
}

const SCOPE_PREFIX = /^\s*(?:فى|في)\s+العقد\s+(?:غير\s+)?محدد\s+المدة\s+فقط\s*[:،\-–]?\s*/;

/** مفاهيم عالية الخطر فى الإسناد الخاطئ: لا تُنسب لمادة لا يرد المفهوم فى نصها. */
const ATTRIBUTION_CONCEPTS: ReadonlyArray<{ label: string; stem: string }> = [
  { label: 'طبيعة العمل', stem: 'طبيعه العمل' },
  { label: 'مبرر', stem: 'مبرر' },
  { label: 'إخطار', stem: 'اخطار' },
];

function norm(s: string): string {
  return normalizeForQuote(s);
}

function hasConcept(text: string, stem: string): boolean {
  return norm(text).includes(stem);
}

function articleOf(articles: readonly ChecklistArticle[], idx: number): ChecklistArticle | undefined {
  return articles[idx];
}

/** C1 + C2 كأنماط نصية لبند واحد (تنبيه أو حكم أو سيناريو). */
function brokenDeadlineParty(text: string): boolean {
  const t = norm(text);
  return (
    /(?:علي العامل|يلتزم العامل|ينبغي للعامل|يجب علي العامل|يتعين علي العامل)(?:(?!صاحب العمل)[^.؛]){0,60}(?:سبعه ايام|7 ايام)/.test(t) ||
    /(?:سبعه ايام|7 ايام)[^.؛]{0,40}(?:علي العامل|يلتزم العامل|من العامل)/.test(t)
  );
}

function wrongScope161(text: string): boolean {
  const t = norm(text);
  return /(?<!غير )محدد المده فقط/.test(t) && !/غير محدد المده/.test(t);
}

/** الإسقاط (لا التخفيض) لمفهوم واحد فقط: «طبيعة العمل» لا تُنسب لغير ما يذكرها (C3)؛ بقية المفاهيم تُخفَّض ولا تُسقَط لاحتمال اختلاف الصياغة. */
const DROP_CONCEPTS = ATTRIBUTION_CONCEPTS.filter((c) => c.stem === 'طبيعه العمل');

function missingConcept(text: string, articleText: string): string | null {
  for (const c of DROP_CONCEPTS) {
    if (hasConcept(text, c.stem) && !hasConcept(articleText, c.stem)) return c.label;
  }
  return null;
}

/** أول جملة (حتى 40 كلمة) من نص مادة: مقتطف حرفى للحق الثابت. */
function verbatimExcerpt(articleText: string): string {
  const words = articleText.replace(/\s+/g, ' ').trim().split(' ');
  const head = words.slice(0, 40).join(' ');
  const cut = head.search(/[.؛](?=\s|$)/);
  const excerpt = cut > 20 ? head.slice(0, cut + 1) : head;
  return excerpt.trim();
}

/**
 * يطبّق القائمة على إجابة منظَّمة. لا يضيف معرفة قانونية من عنده: يصلح نطاقاً لفظياً، أو يُسقط بنداً منسوباً لمادة
 * لا يرد فيها ما نُسب إليها، أو يخفّض وسم «نص» لحكم يضيف إلى مقتطفه، أو يضيف نص مادة حق ثابت أُرسلت ولم تُذكر.
 */
export function applyChecklist(
  value: StructuredAnswer,
  articles: readonly ChecklistArticle[],
  options: ChecklistOptions,
): ChecklistResult {
  const fixes: string[] = [];
  const textsByNo = new Map<number, string>();
  for (const a of articles) textsByNo.set(a.articleNo, a.text);

  // ---- C4 (إسناد) + C2 على الأحكام ----
  const rulings: StructuredRuling[] = [];
  for (const r of value.rulings) {
    const art = articleOf(articles, r.citation_index);
    if (art) {
      const miss = missingConcept(r.claim, art.text);
      if (miss) {
        fixes.push(`C4: أُسقط حكم منسوب للمادة ${art.articleNo} ولفظ «${miss}» غير وارد فى نصها`);
        continue;
      }
      if (art.articleNo === 108 && brokenDeadlineParty(r.claim)) {
        fixes.push('C2: أُسقط حكم يجعل مهلة المادة 108 على العامل');
        continue;
      }
      // وسم «نص» لا يبقى لحكم أضاف إلى مقتطفه الظاهر مفهوماً ليس فيه (خلط مادتين تحت وسم النقل الحرفى).
      if (r.kind === 'نص') {
        const shown = r.quote ?? '';
        const added = ATTRIBUTION_CONCEPTS.find((c) => hasConcept(r.claim, c.stem) && !hasConcept(shown, c.stem));
        if (added) {
          fixes.push(`C4: خُفِّض وسم حكم المادة ${art.articleNo} إلى «تفسير» لأن «${added.label}» ليس فى مقتطفه`);
          rulings.push({ ...r, kind: 'تفسير' });
          continue;
        }
      }
    }
    rulings.push(r);
  }

  // ---- السيناريوهات ----
  const scenarios = (value.scenarios ?? []).filter((s) => {
    const art = articleOf(articles, s.citation_index);
    if (!art) return true;
    const miss = missingConcept(`${s.condition} ${s.outcome}`, art.text);
    if (miss) {
      fixes.push(`C4: أُسقط سيناريو منسوب للمادة ${art.articleNo} ولفظ «${miss}» غير وارد فى نصها`);
      return false;
    }
    if (art.articleNo === 108 && brokenDeadlineParty(`${s.condition} ${s.outcome}`)) {
      fixes.push('C2: أُسقط سيناريو يجعل مهلة المادة 108 على العامل');
      return false;
    }
    return true;
  });

  // ---- التحذيرات: C1 إصلاح النطاق، C2/C4 إسقاط، 149/150 بلا تقييد بنوع العقد ----
  const warnings: string[] = [];
  for (const w0 of value.warnings) {
    let w = w0;
    const nos = extractArticleNumbers(w);
    if (nos.includes(161) && wrongScope161(w)) {
      w = w.replace(/(?:فى|في)\s+العقد\s+محدد\s+المدة\s+فقط/, 'فى العقد غير محدد المدة فقط');
      fixes.push('C1: صُحِّح نطاق تنبيه المادة 161 إلى العقد غير محدد المدة');
    }
    if ((nos.includes(149) || nos.includes(150)) && !nos.includes(161) && SCOPE_PREFIX.test(w)) {
      w = w.replace(SCOPE_PREFIX, '').trim();
      fixes.push('C4: أُزيل تقييد تنبيه المادتين 149/150 بنوع العقد (النص لا يقيّده)');
    }
    if (nos.includes(108) && brokenDeadlineParty(w)) {
      fixes.push('C2: أُسقط تنبيه يجعل مهلة المادة 108 على العامل');
      continue;
    }
    if (nos.length === 1) {
      const t = textsByNo.get(nos[0]);
      const miss = t ? missingConcept(w, t) : null;
      if (miss) {
        fixes.push(`C4: أُسقط تنبيه منسوب للمادة ${nos[0]} ولفظ «${miss}» غير وارد فى نصها`);
        continue;
      }
    }
    warnings.push(w);
  }

  // ---- C5: الحقوق الثابتة ----
  if (options.duesMode) {
    const used = new Set<number>();
    for (const r of rulings) {
      const a = articleOf(articles, r.citation_index);
      if (a) used.add(a.articleNo);
    }
    for (const s of scenarios) {
      const a = articleOf(articles, s.citation_index);
      if (a) used.add(a.articleNo);
    }
    for (const w of warnings) for (const n of extractArticleNumbers(w)) used.add(n);
    for (const no of FIXED_RIGHTS_ARTICLES) {
      if (used.has(no)) continue;
      const idx = articles.findIndex((a) => a.articleNo === no);
      if (idx < 0) continue;
      const excerpt = verbatimExcerpt(articles[idx].text);
      if (excerpt.length < 15) continue;
      rulings.push({ claim: excerpt, kind: 'نص', citation_index: idx, quote: excerpt, quote_verified: true });
      fixes.push(`C5: أُضيف نص المادة ${no} حرفياً (حق ثابت لم يستند إليه الجواب)`);
    }
  }

  // ---- مسائل مفتوحة مكررة (C8 شكلى) ----
  const open: string[] = [];
  for (const o of value.open_issues) {
    const ostems = new Set(contentStems(o));
    const dup = open.some((p) => {
      const ps = contentStems(p);
      if (ps.length === 0 || ostems.size === 0) return false;
      let hit = 0;
      for (const s of ps) if (ostems.has(s)) hit++;
      return hit / Math.min(ps.length, ostems.size) >= 0.8;
    });
    if (dup) {
      fixes.push('C8: أُسقطت مسألة مفتوحة مكررة');
      continue;
    }
    open.push(o);
  }

  return { value: { ...value, rulings, scenarios, warnings, open_issues: open }, fixes };
}
