import { ALTERNATIVES, SEP, headingLineNumber, ordinalToNumber } from './clause-headings';
import { evidenceOf, sentencesOf, type ContractFinding, type LevelClause } from './contract-level';
import { normalizeArabicForMatch } from './reasoning.util';

/**
 * فحوص الاتساق الداخلى للنص (الجولة 62) — حتمية بالكامل ولا تعتمد على نموذج لغوى ولا على نص قانونى:
 *  1) عدد مفقود أو غير مقروء قبل وحدة زمنية («خلال أسبوع    أيام عمل»، «خلال ____ يوماً»): الالتزام الزمنى بلا رقم.
 *  2) إحالة داخلية معيبة: بند يصف نفسه برقم غير رقمه («بموجب هذا البند السابع» داخل البند السادس)، أو يحيل إلى بند فرعى («10-1»)
 *     لا صلة لموضوعه بالجملة المُحيلة.
 * كل ملاحظة تحمل اقتباساً حرفياً من النص. وفحص الإحالة بالموضوع قرينة (heuristic) لا يقين: درجته «منخفض» وصياغته احتمالية، والمحامى يقطع.
 */

const toLatin = (t: string): string => t.replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660)).replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06f0));
const norm = (t: string): string => normalizeArabicForMatch(toLatin(t));

// ===================== 1) عدد مفقود قبل الوحدة =====================

const UNIT = '(?:[اأإآ]يام|يوم(?:اً|ا)?|[اأإآ]سابيع|[اأإآ]شهر|شهور|ساعات|ساعة|سنوات|سنة|%|بالمائة|فى المائة|في المائة)';
const BLANK = '(?:[_\\.\\u2026\\u2025\\-–—]{3,}|\\(\\s*\\)|\\[\\s*\\])';
/** «خلال/لمدة/بعد/قبل … ____ أيام» أو فراغ «( ) يوماً»: موضع الرقم فارغ أو نقاط/شرطات. */
const BLANK_BEFORE_UNIT = new RegExp(`(?:خلال|لمدة|مدة|بعد|قبل|كل|بواقع|نسبة|بنسبة)\\s*${BLANK}\\s*${UNIT}`);
/** «أسبوع   أيام عمل»: وحدة زمنية مفردة تليها فجوة من مسافات ثم وحدة جمع — الرقم بينهما ضائع (وقع فى عقد ممسوح). */
const UNIT_GAP_UNIT = /(?:^|\s)(?:[اأإآ]سبوع|يوم|شهر|ساعة)\s{2,}(?:[اأإآ]يام|[اأإآ]سابيع|[اأإآ]شهر|شهور|ساعات)/;

/** تقسيم الجمل لهذا الفحص: النقاط المتتابعة (فراغ «.....») ليست نهاية جملة، فلا تفصل الفراغ عن وحدته. */
function sentencesKeepingBlanks(text: string): string[] {
  return text
    .split(/\n+|(?<=[^.\s][.؟!؛;])\s+/)
    .map((x) => x.trim())
    .filter((x) => x.length >= 6);
}

export function checkBlankNumbers(clauses: LevelClause[], opts: { textMayBeIncomplete: boolean }): ContractFinding[] {
  const out: ContractFinding[] = [];
  for (const c of clauses) {
    for (const s of sentencesKeepingBlanks(c.clauseText)) {
      if (!BLANK_BEFORE_UNIT.test(s) && !UNIT_GAP_UNIT.test(s)) continue;
      const e = evidenceOf(c, s);
      if (!e) continue;
      out.push({
        id: `blank:${c.clauseIndex}:${out.length + 1}`,
        kind: 'open_term',
        severity: 'متوسط',
        title: 'مدة أو نسبة بلا رقم مقروء فى النص',
        explanation:
          'ورد فى النص التزام زمنى أو نسبة وقع فيه موضع الرقم فارغاً أو غير مقروء قبل الوحدة (أيام/أسابيع/أشهر/نسبة)، فلا يُعلم الأجل أو القدر المتفق عليه، ويصعب الاحتجاج بالالتزام أو احتساب التأخير فيه.' +
          (opts.textMayBeIncomplete ? ' تنبيه: النص مقروء آلياً من صورة وبه تحذيرات قراءة، فقد يكون الرقم موجوداً فى الأصل وضاع فى القراءة؛ قارن بالأصل قبل الاعتماد.' : ''),
        suggestion: 'كتابة الأجل أو النسبة رقماً وحروفاً (مثلاً «خلال ثلاثة (3) أيام عمل من تاريخ…») مع تحديد بداية احتسابه.',
        evidence: [e],
        source: 'rule',
      });
    }
  }
  return out;
}

// ===================== 2) إحالات داخلية =====================

/** رقم البند من عنوانه («البند السادس» أو «البند 6»)، وإلا null (فشل آمن: لا حكم بلا رقم معلوم). */
export function clauseNumberOf(c: LevelClause): number | null {
  const byHeading = headingLineNumber(c.clauseLabel ?? '');
  if (byHeading !== null) return byHeading;
  const m = /(?:^|\D)(\d{1,3})(?:\D|$)/.exec(toLatin(c.clauseLabel ?? ''));
  return m ? Number(m[1]) : null;
}

const ORD_ALT = ALTERNATIVES.join('|');
const SELF_ORD = new RegExp(`هذا${SEP}+البند${SEP}+(?<ord>${ORD_ALT})(?![\\u0621-\\u064A])`, 'gu');
const SELF_NUM = /هذا\s+البند\s*(?:رقم\s*)?\(?(\d{1,3})\)?(?![\d\-–.\/])/g;
const SUB_REF = /(?:البند|الفقرة|النص)\s*(?:الفرعي|الفرعى)?\s*(?:رقم\s*)?\(?(\d{1,3})\s*[-–./]\s*(\d{1,3})\)?/g;

const STOP = new Set(
  'التي الذي هذا هذه ذلك تلك على الي الى من في فى عن مع او أو ثم قد لا ان أن إن كل اي أي بين حتي حتى عند بعد قبل خلال طوال وفقا طبقا بموجب البند الفرعي الفرعى المنصوص عليها عليه الطرف الطرفين العقد الاتفاق'
    .split(/\s+/)
    .map((w) => normalizeArabicForMatch(w)),
);

function topicTokens(text: string): Set<string> {
  const out = new Set<string>();
  for (const w of norm(text).split(' ')) {
    const t = w.replace(/^(?:[وفبكل])?ال(?=[ء-ي]{3})/, '');
    if (t.length >= 4 && !STOP.has(t) && !/^\d+$/.test(t)) out.add(t);
  }
  return out;
}

export function checkInternalReferences(clauses: LevelClause[]): ContractFinding[] {
  const out: ContractFinding[] = [];
  const byNumber = new Map<number, LevelClause>();
  for (const c of clauses) {
    const n = clauseNumberOf(c);
    if (n !== null && !byNumber.has(n)) byNumber.set(n, c);
  }
  for (const c of clauses) {
    const own = clauseNumberOf(c);
    if (own === null) continue;
    for (const s of sentencesOf(c.clauseText)) {
      // أ) البند يصف نفسه برقم غير رقمه
      let wrong: number | null = null;
      for (const m of s.matchAll(SELF_ORD)) {
        const n = ordinalToNumber(m.groups?.ord ?? '');
        if (n !== null && n !== own) wrong = n;
      }
      for (const m of s.matchAll(SELF_NUM)) {
        const n = Number(toLatin(m[1]));
        if (n !== own) wrong = n;
      }
      if (wrong !== null) {
        const e = evidenceOf(c, s);
        if (e) {
          out.push({
            id: `ref:self:${c.clauseIndex}`,
            kind: 'undefined_term',
            severity: 'منخفض',
            title: 'إحالة داخلية خاطئة: البند يذكر نفسه برقم غير رقمه',
            explanation:
              `يرد هذا النص فى ${c.clauseLabel} ويصف نفسه بأنه «هذا البند» برقم آخر؛ فيلتبس على من يقرأ العقد أو ينفذه أى البندين هو المقصود بالالتزام، وقد يُفسَّر النص على غير مراد الطرفين.`,
            suggestion: 'تصحيح رقم البند المُحال إليه (أو استعمال «هذا البند» دون رقم) والتأكد من أن ترقيم البنود والإحالات متسق فى العقد كله.',
            evidence: [e],
            source: 'rule',
          });
        }
      }
      // ب) إحالة إلى بند فرعى لا صلة لموضوعه بالجملة المُحيلة (قرينة)
      for (const m of toLatin(s).matchAll(SUB_REF)) {
        const target = byNumber.get(Number(m[1]));
        if (!target || target.clauseIndex === c.clauseIndex) continue;
        const sentenceTokens = topicTokens(s.replace(m[0], ' '));
        if (sentenceTokens.size < 3) continue;
        const targetTokens = topicTokens(`${target.clauseTitle ?? ''} ${target.clauseText}`);
        const shared = [...sentenceTokens].filter((t) => targetTokens.has(t));
        if (shared.length > 0) continue;
        const e = evidenceOf(c, s);
        if (!e) continue;
        out.push({
          id: `ref:topic:${c.clauseIndex}:${m[1]}-${m[2]}`,
          kind: 'undefined_term',
          severity: 'منخفض',
          title: `إحالة إلى البند ${m[1]}-${m[2]} قد لا يتصل بموضوعها`,
          explanation:
            `تحيل الجملة إلى البند الفرعى ${m[1]}-${m[2]}، ولم يُرصد فى ${target.clauseLabel} ما يتصل بموضوع الجملة المُحيلة؛ فقد يكون رقم الإحالة خاطئاً أو أُحيل إلى بند لا يعالج الأمر. ` +
            'هذا فحص آلى بقرينة الألفاظ لا بقراءة المعنى، والمحامى يقطع.',
          suggestion: 'مراجعة الإحالة والتأكد أن البند المُحال إليه يعالج الموضوع فعلاً، أو تصحيح رقمه.',
          evidence: [e],
          source: 'rule',
        });
      }
    }
  }
  // لا تكرار لنفس الجملة
  const seen = new Set<string>();
  return out.filter((f) => {
    const k = `${f.id}`;
    if (seen.has(k)) return false;
    seen.add(k);
    return true;
  });
}

export function internalConsistencyFindings(clauses: LevelClause[], opts: { textMayBeIncomplete: boolean }): ContractFinding[] {
  try {
    return [...checkBlankNumbers(clauses, opts), ...checkInternalReferences(clauses)];
  } catch {
    return [];
  }
}
