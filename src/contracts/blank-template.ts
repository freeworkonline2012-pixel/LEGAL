import { evidenceOf, type ContractFinding, type FindingEvidence, type LevelClause } from './contract-level';
import { normalizeArabicForMatch } from './reasoning.util';

/**
 * الجولة 104: كاشف «نموذج عقد غير مكتمل».
 *
 * مشكلة الإنتاج (نموذج رسمى لعقد تأسيس شركة): المواضع التى يملؤها الأطراف عادةً (مدة الشركة «( ) سنة»، عدد الحصص وقيمتها، نسبة النصاب «% من رأس المال»...)
 * ظهرت فى التقرير «شرط مفتوح — متوسط» وأُحصيت ضمن الملاحظات المؤكدة، وهى ليست عيباً فى الصياغة بل نموذجاً لم يُملأ بعد.
 *
 * الجذر: لا فرق عند النموذج اللغوى ولا عند فحص «شرط مفتوح» بين «شرط تُرك لاتفاق لاحق» و«خانة فارغة فى استمارة». والمعيار الفارق بنيوى حتمى:
 * عدد مواضع الفراغ المطبوعة («( )» و«[ ]» و«____» و«%» بلا رقم) فى العقد كله وانتشارها فى عدة بنود. وجود فراغ واحد أو اثنين فى عقد موقَّع
 * عيب حقيقى يُترك كما هو (درجته وتصنيفه كما كانا)؛ أما ≥ 4 مواضع فى ≥ 3 بنود فهو نموذج لم يُملأ.
 *
 * فى حالة النموذج: تُجمَّع كل ملاحظات «الشرط المفتوح/المصطلح غير المعرَّف» المبنية على خانة فارغة (حتمية أو من النموذج اللغوى) فى ملاحظة واحدة
 * «نموذج عقد غير مكتمل» بدرجة «منخفض» تسرد المواضع، بدل عدة ملاحظات متوسطة. ولا يُمسّ شىء آخر (التعارض، الإحالات، قواعد المكتب...).
 */

/** فراغ مطبوع: «( )» «[ ]» أو سلسلة نقاط/شرطات/شُرط سفلية (≥ 3) */
const BLANK_RUN = /\(\s*\)|\[\s*\]|[_…‥]{3,}|\.{4,}|[-–—]{4,}/;
/** «%» أو «٪» لا يسبقها رقم (مع مسافات) ولا يليها رقم: النسبة نفسها ضائعة أو متروكة */
const BARE_PERCENT = /(?<![\d٠-٩][\s.,]*)[%٪](?!\s*[\d٠-٩])/;

export const MIN_BLANK_SLOTS = 4;
export const MIN_BLANK_CLAUSES = 3;
const MAX_LISTED = 12;
const MAX_EVIDENCE = 4;

export const isBlankSlotText = (t: string): boolean => BLANK_RUN.test(t) || BARE_PERCENT.test(t);

export interface BlankSlot {
  clauseIndex: number;
  clauseLabel: string;
  quote: string;
}

export interface BlankTemplateDiag {
  slots: number;
  clauses: number;
  template: boolean;
}

/** جمل لا تفصلها نقاط الفراغ المتتابعة (البند «مدة الشركة ..... سنة» جملة واحدة) */
function slotSentences(text: string): string[] {
  return text
    .split(/\n+|(?<=[^.\s][.؟!؛;])\s+/)
    .map((x) => x.trim())
    .filter((x) => x.length >= 8);
}

export function findBlankSlots(clauses: LevelClause[]): BlankSlot[] {
  const out: BlankSlot[] = [];
  for (const c of clauses) {
    for (const s of slotSentences(c.clauseText)) {
      if (!isBlankSlotText(s)) continue;
      const e = evidenceOf(c, s);
      if (!e) continue;
      out.push({ clauseIndex: c.clauseIndex, clauseLabel: c.clauseLabel, quote: e.quote });
    }
  }
  return out;
}

export function blankTemplateDiag(slots: BlankSlot[]): BlankTemplateDiag {
  const clauses = new Set(slots.map((s) => s.clauseIndex)).size;
  return { slots: slots.length, clauses, template: slots.length >= MIN_BLANK_SLOTS && clauses >= MIN_BLANK_CLAUSES };
}

/** وصف الملاحظة نفسه يتكلم عن «متروك/فارغ/غير محدد»: أى ملاحظة نموذج على خانة فارغة */
const BLANK_TALK = /متروك|متروكه|فارغ|فراغ|خالي|دون تحديد|بدون تحديد|بلا تحديد|غير محدد|لم يحدد|لم تحدد|غير مكتمل|غير مملوء|لم يملا|بلا رقم|بدون رقم/;

export const BLANK_TEMPLATE_FINDING_ID = 'blank:template';

const LABEL_SEP = '، ';

function clip(t: string, max: number): string {
  const s = t.replace(/\s+/g, ' ').trim();
  return s.length <= max ? s : `${s.slice(0, max).trim()}…`;
}

/** ملاحظة مبنية على خانة فارغة: اقتباس دليلها يحمل الفراغ، أو يتكلم نصها عن «المتروك» والبند يحمل فراغاً */
function isBlankBased(f: ContractFinding, slotClauses: ReadonlySet<number>, durationSlot: boolean): boolean {
  if (f.kind !== 'open_term' && f.kind !== 'undefined_term') return false;
  // «الإحالة إلى مدة العقد دون تحديد مدة»: إن كانت خانة المدة نفسها موجودة فارغة فالمدة «لم تُملأ» لا «لم تُحدَّد» (وقعت مرشحة عالية متكررة على نموذج عقد تأسيس)
  if (f.id === 'undefined:duration') return durationSlot;
  if (f.evidence.some((e) => isBlankSlotText(e.quote))) return true;
  if (f.source !== 'model') return false;
  const talk = BLANK_TALK.test(normalizeArabicForMatch(`${f.title} ${f.explanation}`));
  return talk && f.evidence.length > 0 && f.evidence.every((e) => slotClauses.has(e.clauseIndex));
}

export interface BlankReclassResult {
  findings: ContractFinding[];
  diag: BlankTemplateDiag;
  absorbed: number;
}

/**
 * يُعيد تصنيف الملاحظات المبنية على خانات فارغة فى عقد يُحكم بأنه نموذج غير مكتمل. غير النموذج تعود قائمته كما هى.
 * لا يرمى استثناء (فشل آمن: تبقى الملاحظات كما كانت).
 */
export function reclassifyBlankTemplate(findings: ContractFinding[], clauses: LevelClause[]): BlankReclassResult {
  try {
    const slots = findBlankSlots(clauses);
    const diag = blankTemplateDiag(slots);
    if (!diag.template) return { findings, diag, absorbed: 0 };
    const slotClauses = new Set(slots.map((s) => s.clauseIndex));
    const durationSlot = slots.some((x) => /مده|مدة/.test(normalizeArabicForMatch(x.quote)));
    const kept = findings.filter((f) => !isBlankBased(f, slotClauses, durationSlot));
    const absorbed = findings.length - kept.length;
    const labels = [...new Map(slots.map((s) => [s.clauseIndex, s.clauseLabel])).values()];
    const listed = slots.slice(0, MAX_LISTED).map((s) => `${s.clauseLabel}: «${clip(s.quote, 90)}»`);
    const evidence: FindingEvidence[] = slots.slice(0, MAX_EVIDENCE).map((s) => ({ clauseIndex: s.clauseIndex, clauseLabel: s.clauseLabel, quote: s.quote }));
    const summary: ContractFinding = {
      id: BLANK_TEMPLATE_FINDING_ID,
      kind: 'blank_field',
      severity: 'منخفض',
      title: `نموذج عقد غير مكتمل: ${diag.slots} موضعاً فارغاً فى ${diag.clauses} بنداً لم يُملأ بعد`,
      explanation:
        `يحمل النص ${diag.slots} خانة فارغة مطبوعة (مثل «( )» أو «____» أو «%» بلا نسبة) موزعة على ${diag.clauses} بنداً (${labels.join(LABEL_SEP)})، وهذا شأن نموذج أو استمارة لم تُملأ بياناتها بعد ` +
        'وليس شرطاً مفتوحاً تُرك لاتفاق لاحق؛ لذلك جُمعت هذه المواضع فى ملاحظة واحدة بدرجة منخفضة ولم تُحتسب ملاحظات متوسطة منفصلة. ' +
        `المواضع: ${listed.join(' | ')}${slots.length > MAX_LISTED ? ` | … و${slots.length - MAX_LISTED} أخرى` : ''}. ` +
        'قبل التوقيع يلزم ملء كل خانة (المدة والنسب والمبالغ وعدد الحصص...)، وبعدها يُعاد تدقيق العقد لأن مضمون هذه البيانات يحدد سلامة البنود التى تتعلق بها.' +
        (absorbed > 0 ? ` (ضُمّت إلى هذه الملاحظة ${absorbed} ملاحظة آلية كانت مبنية على هذه الخانات نفسها.)` : ''),
      suggestion: 'ملء كل الخانات الفارغة رقماً وحروفاً ثم إعادة رفع العقد للتدقيق.',
      evidence,
      source: 'rule',
    };
    return { findings: [...kept, summary], diag, absorbed };
  } catch {
    return { findings, diag: { slots: 0, clauses: 0, template: false }, absorbed: 0 };
  }
}
