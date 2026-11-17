import { asNumbers, amountInText, hasAnyKeyword, labelNumber, quoteFoundIn } from './text';
import { classifyItems, isBaseClause, NO_TEXT } from './classify';
import { holdoutKeyProblems } from './key';
import type {
  Adjudication, ContractMetrics, EvalKey, IssueResult, KeyAcceptable, KeyIssue, ReportedItem, Severity, Snapshot,
} from './types';
import { SEVERITIES } from './types';

export interface ScoreOptions {
  adjudication?: Adjudication;
  /** يُمرَّر من المشغّل فى وضع قاعدة البيانات: هل المادة مفهرسة؟ undefined = لا يمكن القياس */
  isIndexed?: (lawNo: number, lawYear: number, articleNo: number) => boolean;
  runIndex?: number;
}

function matchesKeyRef(item: ReportedItem, ref: { clause?: number | number[]; keywords?: string[]; finding_ids?: string[] }, kind: 'clause' | 'absent'): boolean {
  if (item.state === 'dismissed') return false;
  if (kind === 'absent') {
    if (item.source !== 'finding') return false;
    const byId = (ref.finding_ids ?? []).some((id) => item.fp.includes(id.toLowerCase()) || item.haystack.includes(id.toLowerCase()));
    return byId || ((ref.keywords?.length ?? 0) > 0 && hasAnyKeyword(item.haystack, ref.keywords));
  }
  const nums = asNumbers(ref.clause);
  if (nums.length > 0 && !item.clauseNumbers.some((n) => nums.includes(n))) return false;
  return hasAnyKeyword(item.haystack, ref.keywords);
}

function matchIssue(issue: KeyIssue, items: ReportedItem[]): IssueResult {
  const hits = items.filter((it) => matchesKeyRef(it, issue, issue.kind));
  const best = hits.find((h) => h.state === 'confirmed') ?? hits.find((h) => h.state === 'candidate') ?? null;
  return {
    id: issue.id,
    topic: issue.topic,
    severity: issue.severity,
    outcome: best ? (best.state === 'confirmed' ? 'confirmed' : 'candidate') : 'missed',
    matchedFp: best?.fp ?? null,
  };
}

const emptySev = (): Record<Severity, number> => ({ حرج: 0, عالٍ: 0, متوسط: 0, 'غير مصنَّف': 0 });
const isHC = (s: string): boolean => s === 'حرج' || s === 'عالٍ';

export function scoreContract(key: EvalKey, snap: Snapshot, opts: ScoreOptions = {}): ContractMetrics {
  const items = classifyItems(snap);
  const issues = key.issues.map((i) => matchIssue(i, items));
  const invalidReasons: string[] = [...holdoutKeyProblems(key)];
  if (key.set === 'holdout') {
    const frozenAt = key.frozen ? Date.parse(key.frozen.at) : NaN;
    const up = snap.uploadedAt ? Date.parse(snap.uploadedAt) : NaN;
    if (Number.isNaN(up)) invalidReasons.push('وقت رفع العقد غير معروف: لا يمكن إثبات أن المفتاح سبق رؤية المطور للعقد');
    else if (!Number.isNaN(frozenAt) && up < frozenAt) invalidReasons.push('رُفع العقد للمنصة قبل تجميد المفتاح: لا يصلح Holdout');
  }
  if (snap.evalRef !== key.contract_ref) invalidReasons.push(`رمز اللقطة (${snap.evalRef}) لا يطابق رمز المفتاح (${key.contract_ref})`);

  // ---- الاستدعاء (Recall)
  const foundConfirmed = issues.filter((i) => i.outcome === 'confirmed').length;
  const foundCandidateOnly = issues.filter((i) => i.outcome === 'candidate').length;
  const hcIssues = issues.filter((i) => isHC(i.severity));

  // ---- الدقة: العناصر المؤكدة فقط
  const confirmed = items.filter((i) => i.state === 'confirmed');
  const acceptable: KeyAcceptable[] = key.acceptable ?? [];
  // عنصر مؤكد يطابق أى ملاحظة صحيحة (لا أفضلها فقط) يُعدّ صحيحاً
  const matchesAnyIssue = (it: ReportedItem): boolean => key.issues.some((k) => matchesKeyRef(it, k, k.kind));
  const matchesAcceptable = (it: ReportedItem): boolean => acceptable.some((a) => matchesKeyRef(it, a, a.finding_ids?.length ? 'absent' : 'clause'));
  let tp = 0;
  let acc = 0;
  let fa = 0;
  let faHC = 0;
  let extraTrue = 0;
  const pending: ContractMetrics['pendingItems'] = [];
  for (const it of confirmed) {
    if (matchesAnyIssue(it)) { tp += 1; continue; }
    if (matchesAcceptable(it)) { acc += 1; continue; }
    const v = opts.adjudication?.[`${key.contract_ref}|${it.fp}`];
    if (v === 'true_issue') { extraTrue += 1; tp += 1; }
    else if (v === 'acceptable') acc += 1;
    else if (v === 'false_alarm') { fa += 1; if (isHC(it.severity)) faHC += 1; }
    else pending.push({ fp: it.fp, title: it.title, severity: it.severity, clauseLabels: it.clauseLabels, summary: it.summary });
  }

  // ---- المرشحات
  const candidates = items.filter((i) => i.state === 'candidate');
  const candidateMatched = candidates.filter((c) => matchesAnyIssue(c)).length;

  // ---- الاقتباسات الحرفية: كل اقتباس من أى عنصر معروض (مؤكد أو مرشح أو مستبعد)
  const clauseByLabel = new Map(snap.clauses.map((c) => [c.clauseLabel, c]));
  const allText = snap.clauses.map((c) => c.clauseText);
  const quotesMissing: ContractMetrics['quotesMissing'] = [];
  let quotesChecked = 0;
  for (const it of items) {
    for (const q of it.quotes) {
      quotesChecked += 1;
      const c = q.clauseLabel ? clauseByLabel.get(q.clauseLabel) : undefined;
      const snippets = (c?.matchedArticles ?? []).map((a) => a.snippet ?? '');
      const ok = c
        ? quoteFoundIn(q.quote, c.clauseText, ...(q.source === 'clause' ? [] : snippets))
        : quoteFoundIn(q.quote, ...allText, ...snap.clauses.flatMap((x) => (x.matchedArticles ?? []).map((a) => a.snippet ?? '')));
      if (!ok) quotesMissing.push({ fp: it.fp, quote: q.quote });
    }
  }

  // ---- الاستشهادات القانونية
  const seen = new Set<string>();
  let malformed = 0;
  const notIndexed: Array<{ law_no: number; law_year: number; article_no: number }> = [];
  for (const c of snap.clauses) {
    for (const a of c.matchedArticles ?? []) {
      const okShape = Number.isInteger(a.law_no) && Number.isInteger(a.law_year) && Number.isInteger(a.article_no) && a.article_no > 0 && !!a.snippet;
      if (!okShape) { malformed += 1; continue; }
      const k = `${a.law_no}/${a.law_year}/${a.article_no}`;
      if (seen.has(k)) continue;
      seen.add(k);
      if (opts.isIndexed && !opts.isIndexed(a.law_no, a.law_year, a.article_no)) notIndexed.push({ law_no: a.law_no, law_year: a.law_year, article_no: a.article_no });
    }
  }

  // ---- التجزئة والتغطية والأطراف والمبالغ
  const base = snap.clauses.filter(isBaseClause);
  const readNums = new Set(base.map((c) => labelNumber(c.clauseLabel)).filter((n): n is number => n !== null));
  let segmentation: number | null = null;
  if (key.clause_numbers && key.clause_numbers.length > 0) segmentation = key.clause_numbers.filter((n) => readNums.has(n)).length / key.clause_numbers.length;
  else if (key.clauses_expected && key.clauses_expected > 0) segmentation = Math.min(base.length, key.clauses_expected) / Math.max(base.length, key.clauses_expected);
  const covered = base.filter((c) => c.assessmentStatus !== null && c.assessmentStatus !== NO_TEXT).length;
  const coverage = base.length > 0 ? covered / base.length : null;

  let parties: ContractMetrics['parties'] = 'unmeasured';
  if (key.parties && (key.parties.first || key.parties.second)) {
    const pn = snap.partyNames;
    const eq = (a?: string | null, b?: string | null): boolean => !b || (!!a && norm2(a) === norm2(b));
    parties = pn && eq(pn.first, key.parties.first) && eq(pn.second, key.parties.second) ? 'ok' : 'mismatch';
  }
  let paymentSums: ContractMetrics['paymentSums'] = null;
  if (key.payment_sums && key.payment_sums.length > 0) {
    const all = snap.clauses.map((c) => c.clauseText).join('\n');
    paymentSums = { checked: key.payment_sums.length, found: key.payment_sums.filter((s) => amountInText(s, all)).length };
  }

  const confirmedBySeverity = emptySev();
  for (const it of confirmed) confirmedBySeverity[(SEVERITIES as readonly string[]).includes(it.severity) ? (it.severity as Severity) : 'غير مصنَّف'] += 1;

  return {
    ref: key.contract_ref,
    set: key.set,
    contractType: key.contract_type,
    runIndex: opts.runIndex ?? 0,
    contractId: snap.contractId,
    valid: invalidReasons.length === 0,
    invalidReasons,
    issues,
    issueCount: issues.length,
    foundConfirmed,
    foundCandidateOnly,
    missed: issues.length - foundConfirmed - foundCandidateOnly,
    criticalHighTotal: hcIssues.length,
    criticalHighFound: hcIssues.filter((i) => i.outcome === 'confirmed').length,
    confirmedItems: confirmed.length,
    truePositiveItems: tp,
    acceptableItems: acc,
    falseAlarms: fa,
    highCriticalFalseAlarms: faHC,
    pendingItems: pending,
    pendingHighCritical: pending.filter((p) => isHC(p.severity)).length,
    extraTrueIssues: extraTrue,
    candidateItems: candidates.length,
    candidateMatchedKey: candidateMatched,
    dismissedItems: items.filter((i) => i.state === 'dismissed').length,
    quotesChecked,
    quotesMissing,
    citationsChecked: seen.size,
    citationsNotIndexed: opts.isIndexed ? notIndexed : null,
    citationsMalformed: malformed,
    clausesRead: base.length,
    segmentation,
    parties,
    paymentSums,
    coverage,
    confirmedBySeverity,
    confirmedFps: confirmed.map((i) => i.fp).sort(),
    issueFound: Object.fromEntries(issues.map((i) => [i.id, i.outcome === 'confirmed'])),
  };
}

function norm2(s: string): string {
  return s.replace(/[ً-ٰٟـ]/g, '').replace(/[آأإ]/g, 'ا').replace(/ى/g, 'ي').replace(/ة/g, 'ه').replace(/[^ء-ي0-9a-zA-Z]/g, '');
}
