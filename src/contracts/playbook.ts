import { quoteInText } from './clause-facts';
import { contractFamily, sentencesOf, type LevelClause } from './contract-level';
import {
  LAW_NAME,
  PLAYBOOK_TOPICS,
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
};

const SIDE_LABEL: Record<PlaybookFamily, Record<PlaybookSide, string>> = {
  lease: { a: 'المؤجر', b: 'المستأجر' },
  sale: { a: 'البائع', b: 'المشترى' },
  services: { a: 'مقدم الخدمة (المقاول / المورد)', b: 'طالب الخدمة (العميل)' },
  employment: { a: 'صاحب العمل', b: 'العامل' },
};

export interface PlaybookEvidence {
  clauseLabel: string;
  quote: string;
}

export interface PlaybookConcern extends PlaybookEvidence {
  flagId: string;
  note: string;
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
  clauses: LevelClause[];
}

/** الأنواع المدعومة فقط؛ غيرها (شراكة، تمويل، وكالة، ترخيص، غير محدد) لا دليل لها بعد. */
export function playbookFamily(contractType: string | null | undefined): PlaybookFamily | null {
  const f = contractFamily(contractType);
  return f === 'lease' || f === 'sale' || f === 'services' || f === 'employment' ? f : null;
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
  }
}

const MAX_QUOTE = 300;

/** اقتباس حرفى من البند (مقتطع عند الحد دون نقاط) ويُرفض إن لم يطابق نصه. */
function evidenceOf(c: LevelClause, sentence: string): PlaybookEvidence | null {
  const q = sentence.replace(/\s+/g, ' ').trim();
  const probe = q.length <= MAX_QUOTE ? q : q.slice(0, MAX_QUOTE).trim();
  if (!quoteInText(probe, c.clauseText)) return null;
  return { clauseLabel: c.clauseLabel, quote: probe };
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
      if (!preferTitle || preferTitle.test(`${p.titleNorm} ${p.headNorm}`)) return ev;
      fallback ??= ev;
    }
  }
  return fallback;
}

function flagHit(prepared: PreparedClause[], flag: PlaybookFlag): PlaybookEvidence | null {
  return firstEvidence(prepared, (s, p) => {
    if (flag.pattern && !flag.pattern.test(s.norm)) return false;
    if (flag.test && !flag.test(s.norm, s.raw, p.clauseNorm)) return false;
    if (!flag.pattern && !flag.test) return false;
    if (flag.unless && flag.unless.test(p.clauseNorm)) return false;
    return true;
  });
}

function sideName(family: PlaybookFamily, against: PlaybookSide | 'both'): string {
  return against === 'both' ? 'الطرفين' : SIDE_LABEL[family][against];
}

function buildRow(topic: PlaybookTopic, family: PlaybookFamily, side: PlaybookSide | null, prepared: PreparedClause[], fullNorm: string): PlaybookRow {
  const evidence = firstEvidence(prepared, (s) => topic.detect.test(s.norm), topic.detect);
  const concerns: PlaybookConcern[] = [];
  for (const f of topic.flags) {
    if (side && f.against !== 'both' && f.against !== side) continue;
    const ev = flagHit(prepared, f);
    if (ev) concerns.push({ ...ev, flagId: f.id, note: f.note, against: f.against, againstLabel: sideName(family, f.against) });
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
      .filter((b) => !b.when || b.when.test(fullNorm))
      .map((b) => ({ lawName: LAW_NAME[b.law], article: b.article ?? null, note: b.note })),
  };
}

export function buildPlaybook(input: PlaybookInput): PlaybookResult | null {
  const family = playbookFamily(input.contractType);
  if (!family || input.clauses.length === 0) return null;
  const side = playbookSide(family, input.clientRole);
  const prepared = prepare(input.clauses);
  const fullNorm = prepared.map((p) => p.clauseNorm).join(' ');
  const rows = PLAYBOOK_TOPICS.filter((t) => t.families.includes(family)).map((t) => buildRow(t, family, side, prepared, fullNorm));
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
