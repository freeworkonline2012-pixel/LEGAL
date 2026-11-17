import { isDismissedFindingVerification, isDismissedVerification } from '../verification';
import { labelNumber, norm } from './text';
import type { ItemState, ReportedItem, SnapClause, SnapFinding, SnapVerification, Snapshot } from './types';

const oneLine = (s: string | null | undefined, max = 240): string => {
  const t = (s ?? '').replace(/\s+/g, ' ').trim();
  return t.length > max ? `${t.slice(0, max)}…` : t;
};

/**
 * تصنيف مخرجات المنصة بنفس منطق تقرير التدقيق (src/exports/audit-report/build.ts) حتى يقيس الميزان ما يراه المالك فى التقرير:
 * بند «يحتاج مراجعة» = ملاحظة؛ مؤكدة إن لم تُوسَم unconfirmed؛ مستبعدة إن دُحضت بدحض موثَّق؛ وإلا مرشّحة.
 * ملاحظة «قاعدة المكتب» المؤكدة التى يقع دليلها فى بند مؤكد تُدمج فيه ولا تُعدّ مرتين.
 */
export const NEEDS_REVIEW = 'يحتاج مراجعة';
export const NO_TEXT = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
export const UNSEGMENTED_PREFIX = 'نص سابق لـ';

const SEV_RANK: Record<string, number> = { حرج: 0, عالٍ: 1, متوسط: 2 };
const rank = (s: string): number => SEV_RANK[s] ?? 3;

function clauseSeverity(c: SnapClause): string | null {
  if (c.assessmentStatus !== NEEDS_REVIEW) return null;
  return c.riskLevel === 'حرج' || c.riskLevel === 'عالٍ' || c.riskLevel === 'متوسط' ? c.riskLevel : 'غير مصنَّف';
}

function stateOfClause(v: SnapVerification | null): ItemState {
  if (v?.status !== 'unconfirmed') return 'confirmed';
  return isDismissedVerification(v) ? 'dismissed' : 'candidate';
}

function stateOfFinding(kind: string, v: SnapVerification | null): ItemState {
  if (v?.status !== 'unconfirmed') return 'confirmed';
  return isDismissedFindingVerification(kind, v) ? 'dismissed' : 'candidate';
}

function quotesOfVerification(v: SnapVerification | null, clauseLabel: string | null): ReportedItem['quotes'] {
  return v?.quote ? [{ quote: v.quote, clauseLabel, source: v.quoteSource ?? null }] : [];
}

export function isBaseClause(c: SnapClause): boolean {
  return !c.clauseLabel.startsWith(UNSEGMENTED_PREFIX);
}

export function classifyItems(snap: Snapshot): ReportedItem[] {
  const clauses = [...snap.clauses].sort((a, b) => a.clauseIndex - b.clauseIndex);
  const items: ReportedItem[] = [];

  for (const c of clauses) {
    const sev = clauseSeverity(c);
    if (sev === null) continue;
    const n = labelNumber(c.clauseLabel);
    const rf = (c.ruleFindings ?? []).filter((r) => r && r.status === 'review');
    const hay = [c.clauseTitle, c.assessmentReasoning, c.verification?.reason, ...rf.map((r) => `${r.topic ?? ''} ${r.explanation ?? ''}`)].join(' ');
    items.push({
      fp: n !== null ? `clause:${n}` : `clause:${c.clauseLabel}`,
      source: 'clause',
      kind: 'clause',
      title: c.clauseTitle || c.clauseLabel,
      severity: sev,
      state: stateOfClause(c.verification),
      clauseNumbers: n !== null ? [n] : [],
      clauseLabels: [c.clauseLabel],
      summary: oneLine(c.assessmentReasoning || c.verification?.reason),
      haystack: norm(hay),
      quotes: [
        ...quotesOfVerification(c.verification, c.clauseLabel),
        ...rf.flatMap((r) => (r.quotes ?? []).map((q) => ({ quote: q, clauseLabel: c.clauseLabel, source: 'clause' as const }))),
      ],
    });
  }

  const byClauseLabel = new Map(items.filter((i) => i.source === 'clause' && i.state === 'confirmed').map((i) => [i.clauseLabels[0], i]));
  for (const f of snap.contractFindings) {
    const state = stateOfFinding(f.kind, f.verification);
    const labels = f.evidence.map((e) => e.clauseLabel).filter(Boolean);
    const absorbInto = state === 'confirmed' && f.kind === 'office_rule' ? labels.map((l) => byClauseLabel.get(l)).find((x) => !!x) : undefined;
    const hay = norm(`${f.title} ${f.explanation}`);
    const quotes = [
      ...f.evidence.filter((e) => e.quote).map((e) => ({ quote: e.quote, clauseLabel: e.clauseLabel || null, source: 'clause' as const })),
      ...quotesOfVerification(f.verification, null),
    ];
    if (absorbInto) {
      // يُدمج فى البند: ترتفع درجته إن كانت الملاحظة أعلى، ويُضاف نصها واقتباساتها
      if (rank(f.severity) < rank(absorbInto.severity)) absorbInto.severity = f.severity;
      absorbInto.haystack = `${absorbInto.haystack} ${hay}`;
      absorbInto.quotes.push(...quotes);
      continue;
    }
    const nums = labels.map((l) => labelNumber(l)).filter((x): x is number => x !== null);
    items.push({
      fp: `finding:${f.kind}:${f.id ? f.id : norm(f.title).slice(0, 40)}`,
      source: 'finding',
      kind: f.kind,
      title: f.title,
      severity: f.severity,
      state,
      clauseNumbers: [...new Set(nums)],
      clauseLabels: labels,
      summary: oneLine(f.explanation),
      haystack: `${hay} ${norm(f.id ?? '')}`,
      quotes,
    });
  }
  return items;
}

export type { SnapFinding };
