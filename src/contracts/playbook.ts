import { quoteInText } from './clause-facts';
import { contractFamily, sentencesOf, stripDefiniteArticle, type LevelClause } from './contract-level';
import {
  LAW_NAME,
  PLAYBOOK_TOPICS,
  type PlaybookCtx,
  type PlaybookFamily,
  type PlaybookFlag,
  type PlaybookSide,
  type PlaybookTopic,
  type Stance,
} from './playbook-data';
import { norm } from './playbook-util';

/**
 * الدليل التفاوضى (الجولة 7): لكل نوع عقد (إيجار، بيع، خدمات/مقاولة/توريد/برمجيات، عمل) محاور تفاوض، وأمام كل محور:
 * ما رُصد فى العقد باقتباس حرفى، وهل فيه ما يميل ضد الطرف الذى يدقق العقد لمصلحته، وموقفه التفاوضى (الأفضل / البديل / الخط الأحمر).
 *
 * قراءة حتمية بالكامل (لا نموذج لغوى)، وفاشلة الأمان: لا يظهر اقتباس إلا إن وُجد حرفياً فى البند، ولا تُذكر مادة قانونية إلا من بيانات
 * محقَّقة مقابل النصوص المفهرسة. «لم يُرصد» تعنى أن القراءة الآلية لم تجد نصاً، لا أن العقد خلا منه؛ والمحامى هو من يقطع.
 * عرض فقط: لا يغيّر مستوى المخاطرة العام ولا حالة أى بند.
 */

export type { PlaybookFamily, PlaybookSide, Stance } from './playbook-data';
export type PlaybookStatus = 'found' | 'concern' | 'missing';

const FAMILY_LABEL: Record<PlaybookFamily, string> = {
  lease: 'عقد إيجار',
  sale: 'عقد بيع',
  services: 'عقد خدمات أو مقاولة أو توريد',
  employment: 'عقد عمل',
  partnership: 'عقد شراكة أو استثمار',
  finance: 'عقد تمويل أو قرض',
  agency: 'عقد وكالة أو سمسرة أو تسويق',
  licence: 'عقد ترخيص أو امتياز تجارى',
};

const SIDE_LABEL: Record<PlaybookFamily, Record<PlaybookSide, string>> = {
  lease: { a: 'المؤجر', b: 'المستأجر' },
  sale: { a: 'البائع', b: 'المشترى' },
  services: { a: 'مقدم الخدمة (المقاول / المورد)', b: 'طالب الخدمة (العميل)' },
  employment: { a: 'صاحب العمل', b: 'العامل' },
  partnership: { a: 'الشريك المستثمر', b: 'الشريك المدير أو صاحب المشروع' },
  finance: { a: 'الممول (الدائن)', b: 'المقترض (المدين)' },
  agency: { a: 'الموكِّل (صاحب المنتج أو الخدمة)', b: 'الوكيل أو السمسار' },
  licence: { a: 'مانح الترخيص', b: 'المرخَّص له' },
};

export interface PlaybookEvidence {
  clauseLabel: string;
  quote: string;
}

export interface PlaybookConcern extends PlaybookEvidence {
  flagId: string;
  note: string;
  /** اقتباس من بند آخر يخفف الرصد أو يعالجه (انظر PlaybookFlag.elsewhere)؛ الملاحظة عندئذ لا تقرر غياب ما وُجد */
  mitigatedBy?: PlaybookEvidence;
  against: PlaybookSide | 'both';
  /** «المؤجر» / «الطرفين»… لعرضه حين يكون الطرف غير محدد */
  againstLabel: string;
}

export interface PlaybookBasisItem {
  lawName: string;
  article: number | null;
  note: string;
}

export interface PlaybookRow {
  topicId: string;
  label: string;
  status: PlaybookStatus;
  evidence: PlaybookEvidence | null;
  concerns: PlaybookConcern[];
  /** موقف الطرف الذى يدقق العقد لمصلحته؛ null إن لم تُحدَّد صفته */
  stance: Stance | null;
  /** موقف الطرفين إن لم تُحدَّد الصفة */
  bothStances: Array<{ sideLabel: string; stance: Stance }> | null;
  ifMissing: string;
  basis: PlaybookBasisItem[];
}

export interface PlaybookResult {
  version: 1;
  family: PlaybookFamily;
  familyLabel: string;
  side: PlaybookSide | null;
  sideLabel: string | null;
  rows: PlaybookRow[];
  counts: { found: number; concern: number; missing: number };
}

export interface PlaybookInput {
  contractType: string | null;
  clientRole: string | null;
  /** أى الطرفين فى نص العقد هو العميل إن حُدِّد (يُستعمل لتحديد من هو مقدم الخدمة بالترتيب). */
  clientParty?: 'first' | 'second' | null;
  clauses: LevelClause[];
}

/** الأنواع التى لها دليل تفاوضى (ثمانية)؛ غيرها (رهن، هبة، وديعة، صلح، تأمين، سرية، غير محدد) لها فحوص بنود ناقصة فقط. */
export function playbookFamily(contractType: string | null | undefined): PlaybookFamily | null {
  const f = contractFamily(contractType);
  switch (f) {
    case 'lease':
    case 'sale':
    case 'services':
    case 'employment':
    case 'partnership':
    case 'finance':
    case 'agency':
    case 'licence':
      return f;
    default:
      return null;
  }
}

/** صفة العميل → الطرف a/b بالنص المطابق للأدوار المعروضة فى الاستيضاح؛ نص حر لا يُفهم = null (دليل محايد). */
export function playbookSide(family: PlaybookFamily, clientRole: string | null | undefined): PlaybookSide | null {
  const r = norm(clientRole ?? '').replace(/^ال/, '');
  if (!r) return null;
  switch (family) {
    case 'lease':
      return /^(?:مستاجر)/.test(r) ? 'b' : /^(?:مؤجر|مالك)/.test(r) ? 'a' : null;
    case 'sale':
      return /^(?:مشتري)/.test(r) ? 'b' : /^(?:بائع)/.test(r) ? 'a' : null;
    case 'services':
      if (/^(?:مقدم|مقاول|مورد|متعهد|مزود)/.test(r) || /^طرف الذي يقدم الاداء/.test(r)) return 'a';
      if (/^(?:طالب|عميل|صاحب العمل|رب العمل|مستفيد)/.test(r) || /^طرف الذي يتلقي الاداء/.test(r)) return 'b';
      return null;
    case 'employment':
      return /^(?:عامل|موظف)/.test(r) ? 'b' : /^(?:صاحب العمل|رب العمل|منشاه|شركه|مؤسسه)/.test(r) ? 'a' : null;
    case 'partnership':
      // الشريك المستثمر (الممول بالمال) = a؛ الشريك المدير أو صاحب المشروع = b. «الشريك» وحدها لا تحدد الصفة.
      if (/^(?:شريك (?:ال)?)?(?:مستثمر|ممول|صامت|موصي)/.test(r)) return 'a';
      return /^(?:شريك (?:ال)?)?(?:مدير|عامل|متضامن|منفذ|مؤسس)|^صاحب (?:ال)?مشروع/.test(r) ? 'b' : null;
    case 'finance':
      if (/^(?:مقترض|مدين|متمول|مستفيد)/.test(r)) return 'b';
      return /^(?:ممول|دائن|مقرض|بنك|مصرف|شركه تمويل|مؤسسه تمويل)/.test(r) ? 'a' : null;
    case 'agency':
      if (/^(?:وكيل|سمسار|مسوق|موزع|وسيط)/.test(r)) return 'b';
      return /^(?:موكل|صاحب (?:ال)?(?:منتج|خدمه)|منتج)/.test(r) ? 'a' : null;
    case 'licence':
      // «المرخص له» قبل «المانح/المرخِّص» حتى لا يلتبس اللفظان.
      if (/^(?:مرخص له|حامل (?:ال)?ترخيص|صاحب (?:ال)?امتياز|ممنوح له)/.test(r)) return 'b';
      return /^(?:مانح|مرخص|مالك|صاحب (?:ال)?علامه)/.test(r) ? 'a' : null;
  }
}

/** مقدم الخدمة بالترتيب: العميل هو الجانب b فى الخدمات؛ فمقدم الخدمة هو الطرف المقابل لترتيب العميل (وعند كون العميل هو المقدم نفسه فهو ترتيبه). */
export function playbookCtx(family: PlaybookFamily, side: PlaybookSide | null, clientParty: 'first' | 'second' | null): PlaybookCtx {
  if (family !== 'services' || !side || !clientParty) return { providerOrdinal: null };
  const other = clientParty === 'first' ? 'second' : 'first';
  return { providerOrdinal: side === 'b' ? other : clientParty };
}

const MAX_QUOTE = 300;

/** اقتباس حرفى من البند (مقتطع عند الحد دون نقاط) ويُرفض إن لم يطابق نصه. */
function evidenceOf(c: LevelClause, sentence: string): PlaybookEvidence | null {
  const q = sentence.replace(/\s+/g, ' ').trim();
  const probe = q.length <= MAX_QUOTE ? q : q.slice(0, MAX_QUOTE).trim();
  if (!quoteInText(probe, c.clauseText)) return null;
  return { clauseLabel: c.clauseLabel, quote: probe };
}

/** النمط على النص كما هو وعلى النص بلا «ال» التعريف (انظر stripDefiniteArticle): «الشرط الجزائى» و«الملكية الفكرية» تُرصد كما تُرصد نكرتاهما. */
function reHit(re: RegExp, text: string): boolean {
  return re.test(text) || re.test(stripDefiniteArticle(text));
}

interface PreparedClause {
  c: LevelClause;
  clauseNorm: string;
  titleNorm: string;
  /** عنوان البند المضمَّن فى أول سطره («التسليم: …») موحَّداً */
  headNorm: string;
  sentences: Array<{ raw: string; norm: string }>;
}

function prepare(clauses: LevelClause[]): PreparedClause[] {
  return [...clauses]
    .sort((a, b) => a.clauseIndex - b.clauseIndex)
    .map((c) => ({
      c,
      clauseNorm: norm(c.clauseText),
      titleNorm: norm(c.clauseTitle ?? ''),
      headNorm: norm(c.clauseText.split(/[:：\n]/)[0].slice(0, 40)),
      sentences: sentencesOf(c.clauseText).map((raw) => ({ raw, norm: norm(raw) })),
    }));
}

function firstEvidence(
  prepared: PreparedClause[],
  hit: (s: { raw: string; norm: string }, p: PreparedClause) => boolean,
  preferTitle?: RegExp,
): PlaybookEvidence | null {
  let fallback: PlaybookEvidence | null = null;
  for (const p of prepared) {
    for (const s of p.sentences) {
      if (!hit(s, p)) continue;
      const ev = evidenceOf(p.c, s.raw);
      if (!ev) continue;
      if (!preferTitle || reHit(preferTitle, `${p.titleNorm} ${p.headNorm}`)) return ev;
      fallback ??= ev;
    }
  }
  return fallback;
}

function flagHit(prepared: PreparedClause[], flag: PlaybookFlag, ctx: PlaybookCtx): PlaybookEvidence | null {
  return firstEvidence(prepared, (s, p) => {
    if (flag.pattern && !reHit(flag.pattern, s.norm)) return false;
    if (flag.test && !flag.test(s.norm, s.raw, p.clauseNorm, ctx)) return false;
    if (!flag.pattern && !flag.test) return false;
    if (flag.unless && reHit(flag.unless, p.clauseNorm)) return false;
    return true;
  });
}

/** أول جملة فى بند غير بند الرصد تطابق نمط التخفيف (اقتباس حرفى موثَّق)، أو null. */
function elsewhereEvidence(prepared: PreparedClause[], re: RegExp, ownLabel: string): PlaybookEvidence | null {
  return firstEvidence(prepared, (s, p) => p.c.clauseLabel !== ownLabel && reHit(re, s.norm));
}

function sideName(family: PlaybookFamily, against: PlaybookSide | 'both'): string {
  return against === 'both' ? 'الطرفين' : SIDE_LABEL[family][against];
}

function buildRow(topic: PlaybookTopic, family: PlaybookFamily, side: PlaybookSide | null, prepared: PreparedClause[], fullNorm: string, ctx: PlaybookCtx): PlaybookRow {
  const evidence = firstEvidence(prepared, (s) => reHit(topic.detect, s.norm), topic.detect);
  const concerns: PlaybookConcern[] = [];
  for (const f of topic.flags) {
    if (side && f.against !== 'both' && f.against !== side) continue;
    const ev = flagHit(prepared, f, ctx);
    if (!ev) continue;
    const mitigatedBy = f.elsewhere ? elsewhereEvidence(prepared, f.elsewhere, ev.clauseLabel) : null;
    concerns.push({
      ...ev,
      flagId: f.id,
      note: mitigatedBy && f.noteIfMitigated ? f.noteIfMitigated : f.note,
      ...(mitigatedBy ? { mitigatedBy } : {}),
      against: f.against,
      againstLabel: sideName(family, f.against),
    });
  }
  const status: PlaybookStatus = concerns.length > 0 ? 'concern' : evidence ? 'found' : 'missing';
  return {
    topicId: topic.id,
    label: topic.label,
    status,
    evidence,
    concerns,
    stance: side ? topic.stance[side] : null,
    bothStances: side
      ? null
      : (['a', 'b'] as const).map((k) => ({ sideLabel: SIDE_LABEL[family][k], stance: topic.stance[k] })),
    ifMissing: topic.ifMissing,
    basis: topic.basis
      .filter((b) => !b.when || reHit(b.when, fullNorm))
      .map((b) => ({ lawName: LAW_NAME[b.law], article: b.article ?? null, note: b.note })),
  };
}

export function buildPlaybook(input: PlaybookInput): PlaybookResult | null {
  const family = playbookFamily(input.contractType);
  if (!family || input.clauses.length === 0) return null;
  const side = playbookSide(family, input.clientRole);
  const prepared = prepare(input.clauses);
  const fullNorm = prepared.map((p) => p.clauseNorm).join(' ');
  const ctx = playbookCtx(family, side, input.clientParty ?? null);
  const rows = PLAYBOOK_TOPICS.filter((t) => t.families.includes(family)).map((t) => buildRow(t, family, side, prepared, fullNorm, ctx));
  return {
    version: 1,
    family,
    familyLabel: FAMILY_LABEL[family],
    side,
    sideLabel: side ? SIDE_LABEL[family][side] : null,
    rows,
    counts: {
      found: rows.filter((r) => r.status === 'found').length,
      concern: rows.filter((r) => r.status === 'concern').length,
      missing: rows.filter((r) => r.status === 'missing').length,
    },
  };
}
