import type { SnapClause, SnapFinding, SnapMatchedArticle, SnapVerification, Snapshot } from './types';

type Obj = Record<string, unknown>;
const isObj = (v: unknown): v is Obj => !!v && typeof v === 'object' && !Array.isArray(v);
const str = (v: unknown): string | null => (typeof v === 'string' && v.trim() ? v : null);
const pick = (o: Obj, ...keys: string[]): unknown => {
  for (const k of keys) if (o[k] !== undefined) return o[k];
  return undefined;
};

/** نتيجة التحقق كما يخزّنها النظام أو يعرضها الـAPI → الصيغة المستعملة فى القياس (نفس منطق reportVerification فى التصدير). */
export function normVerification(v: unknown): SnapVerification | null {
  if (!isObj(v)) return null;
  if (v.status !== 'confirmed' && v.status !== 'unconfirmed') return null;
  const reason = str(v.reason);
  if (!reason) return null;
  return {
    status: v.status,
    reason,
    quote: str(v.quote),
    ...(v.quoteSource === 'clause' || v.quoteSource === 'article' ? { quoteSource: v.quoteSource } : {}),
    ...(v.reclassified === 'deviation' ? { reclassified: 'deviation' as const } : {}),
    ...(typeof v.basis === 'string' ? { basis: v.basis } : {}),
    ...(typeof v.refutationKind === 'string' ? { refutationKind: v.refutationKind } : {}),
  };
}

function normArticles(v: unknown): SnapMatchedArticle[] | null {
  if (!Array.isArray(v)) return null;
  return v.filter(isObj).map((a) => ({
    law: typeof a.law === 'string' ? a.law : undefined,
    law_no: Number(a.law_no),
    law_year: Number(a.law_year),
    article_no: Number(a.article_no),
    snippet: typeof a.snippet === 'string' ? a.snippet : undefined,
  }));
}

function normClause(raw: Obj, notes: string[]): SnapClause {
  const risk = pick(raw, 'riskLevel', 'risk_level');
  if (risk === undefined && !notes.includes('درجة الخطورة غير متاحة فى المصدر: تُعامل كل ملاحظة كغير مصنفة')) notes.push('درجة الخطورة غير متاحة فى المصدر: تُعامل كل ملاحظة كغير مصنفة');
  const rf = pick(raw, 'ruleFindings', 'rule_findings');
  return {
    clauseIndex: Number(pick(raw, 'clauseIndex', 'clause_index') ?? 0),
    clauseLabel: String(pick(raw, 'clauseLabel', 'clause_label') ?? ''),
    clauseTitle: str(pick(raw, 'clauseTitle', 'clause_title')),
    clauseText: String(pick(raw, 'clauseText', 'clause_text') ?? ''),
    assessmentStatus: str(pick(raw, 'assessmentStatus', 'assessment_status')),
    assessmentReasoning: str(pick(raw, 'assessmentReasoning', 'assessment_reasoning')),
    matchedArticles: normArticles(pick(raw, 'matchedArticles', 'matched_articles')),
    riskLevel: str(risk),
    verification: normVerification(raw.verification),
    ruleFindings: Array.isArray(rf)
      ? rf.filter(isObj).map((r) => ({
          topic: str(r.topic) ?? undefined,
          status: str(r.status) ?? undefined,
          explanation: str(r.explanation) ?? undefined,
          quotes: Array.isArray(r.quotes) ? r.quotes.filter((q): q is string => typeof q === 'string') : [],
        }))
      : null,
  };
}

function normFinding(raw: Obj): SnapFinding {
  const ev = Array.isArray(raw.evidence) ? raw.evidence.filter(isObj) : [];
  return {
    id: str(raw.id) ?? undefined,
    kind: String(raw.kind ?? ''),
    severity: String(raw.severity ?? 'متوسط'),
    title: String(raw.title ?? ''),
    explanation: String(raw.explanation ?? ''),
    evidence: ev
      .map((e) => ({ clauseLabel: String(pick(e, 'clauseLabel', 'clause_label') ?? ''), quote: String(e.quote ?? '') }))
      .filter((e) => e.quote),
    verification: normVerification(raw.verification),
  };
}

/**
 * يقبل: (1) لقطة المشغّل نفسها، (2) AuditReportInput (camelCase)، (3) استجابة الـAPI (snake_case).
 * يرمى خطأً واضحاً إن لم يجد بنوداً.
 */
export function normalizeSnapshot(raw: unknown, defaults: { evalRef?: string } = {}): Snapshot {
  if (!isObj(raw)) throw new Error('اللقطة ليست كائناً');
  const clausesRaw = raw.clauses;
  if (!Array.isArray(clausesRaw)) throw new Error('اللقطة بلا مصفوفة clauses');
  const notes: string[] = Array.isArray(raw.notes) ? raw.notes.filter((n): n is string => typeof n === 'string') : [];
  const findingsRaw = pick(raw, 'contractFindings', 'contract_findings');
  const pn = pick(raw, 'partyNames', 'party_names');
  const warnings = pick(raw, 'extractionWarnings', 'extraction_warnings');
  const evalRef = str(raw.evalRef) ?? defaults.evalRef;
  if (!evalRef) throw new Error('اللقطة بلا evalRef (رمز العقد المرجعى)');
  return {
    evalRef,
    contractId: String(pick(raw, 'contractId', 'contract_id', 'id') ?? ''),
    uploadedAt: str(pick(raw, 'uploadedAt', 'created_at', 'createdAt')) ?? (raw.uploadedAt instanceof Date ? raw.uploadedAt.toISOString() : null),
    capturedAt: str(raw.capturedAt),
    contractType: str(pick(raw, 'contractType', 'contract_type')),
    extractionWarnings: Array.isArray(warnings) ? warnings.filter((w): w is string => typeof w === 'string') : [],
    partyNames: isObj(pn) ? { first: str(pn.first), second: str(pn.second) } : null,
    clauses: clausesRaw.filter(isObj).map((c) => normClause(c, notes)),
    contractFindings: Array.isArray(findingsRaw) ? findingsRaw.filter(isObj).map(normFinding) : [],
    notes,
  };
}

/**
 * يبنى لقطة من صفّى قاعدة البيانات (contracts + contract_clauses) بنفس تحويلات تصدير التقرير:
 * ملاحظات العقد ككل من contract_findings.findings، والطرفان من contract_findings.parties.
 */
export function snapshotFromDbRows(contract: Obj, clauseRows: Obj[], evalRef: string, now = new Date()): Snapshot {
  const cf = isObj(contract.contract_findings) ? contract.contract_findings : null;
  const findings = cf && Array.isArray(cf.findings) ? cf.findings.filter(isObj).filter((f) => str(f.title) && str(f.explanation)) : [];
  const parties = cf && isObj(cf.parties) ? cf.parties : null;
  const created = contract.created_at;
  return normalizeSnapshot(
    {
      evalRef,
      contractId: contract.id,
      uploadedAt: created instanceof Date ? created.toISOString() : created,
      capturedAt: now.toISOString(),
      contractType: contract.contract_type,
      extractionWarnings: contract.extraction_warnings,
      partyNames: parties ? { first: parties.first, second: parties.second } : null,
      clauses: clauseRows.map((c) => ({ ...c, riskLevel: c.risk_level ?? null })),
      contractFindings: findings,
    },
    { evalRef },
  );
}
