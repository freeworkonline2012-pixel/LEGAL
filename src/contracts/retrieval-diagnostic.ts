/**
 * تشخيص الاسترجاع (الجولة 73): أعداد ومعرّفات قانونية عامة فقط، بلا أى جزء من نص العقد (سرى).
 * الغرض: لماذا يقول البند «لا يوجد نص مفهرَس»؟ هل القراءة الآلية قصيرة/مشوّهة؟ هل فشل البحث النصى أو الدلالى؟
 * هل حجبته بوابتا النوع والقانون القطاعى؟ أم أن النموذج لم يختر مادة من المرشحين؟
 */

export interface DiagCandidate {
  lawNo: number | null;
  lawYear: number | null;
  articleNo: number;
}

/** «131/1948#646» — معرّف مادة قانونية عامة، لا نص عقد. */
export function candidateId(c: DiagCandidate): string {
  return `${c.lawNo ?? '?'}/${c.lawYear ?? '?'}#${c.articleNo}`;
}

/** أول n معرّفات مرتبة بلا تكرار. */
export function idList(cs: DiagCandidate[], n = 4): string {
  const ids = Array.from(new Set(cs.map(candidateId))).slice(0, n);
  return ids.length ? ids.join(',') : '-';
}

/** القوانين (بلا أرقام مواد) فى مجموعة، مع عدد المواد لكل قانون: «131/1948x3,181/2018x1». */
export function lawCounts(cs: DiagCandidate[], n = 5): string {
  const m = new Map<string, number>();
  for (const c of cs) {
    const k = `${c.lawNo ?? '?'}/${c.lawYear ?? '?'}`;
    m.set(k, (m.get(k) ?? 0) + 1);
  }
  const out = Array.from(m.entries())
    .sort((a, b) => b[1] - a[1])
    .slice(0, n)
    .map(([k, v]) => `${k}x${v}`);
  return out.length ? out.join(',') : '-';
}

export interface TextShape {
  chars: number;
  nonSpace: number;
  arabicLetters: number;
  digits: number;
  latinLetters: number;
  /** نسبة الحروف العربية من غير المسافات (0..1): انخفاضها دليل رموز دخيلة/قراءة مشوهة */
  arabicRatio: number;
  lines: number;
  words: number;
}

/** أعداد شكلية لنص (بلا محتوى). */
export function textShape(text: string): TextShape {
  const t = text ?? '';
  const nonSpace = (t.match(/\S/g) ?? []).length;
  const arabicLetters = (t.match(/[ء-ي]/g) ?? []).length;
  const digits = (t.match(/[0-9٠-٩]/g) ?? []).length;
  const latinLetters = (t.match(/[A-Za-z]/g) ?? []).length;
  return {
    chars: t.length,
    nonSpace,
    arabicLetters,
    digits,
    latinLetters,
    arabicRatio: nonSpace > 0 ? Math.round((arabicLetters / nonSpace) * 100) / 100 : 0,
    lines: t.length === 0 ? 0 : t.split('\n').length,
    words: (t.match(/\S+/g) ?? []).length,
  };
}

export function formatShape(s: TextShape): string {
  return `chars=${s.chars} words=${s.words} lines=${s.lines} arabic=${s.arabicRatio} digits=${s.digits} latin=${s.latinLetters}`;
}

export interface ClauseRetrievalDiag {
  clauseIndex: number;
  shape: TextShape;
  criteria: string;
  family: string | null;
  ftsTokens: number;
  fts: DiagCandidate[];
  semConfigured: boolean;
  sem: DiagCandidate[];
  merged: DiagCandidate[];
  afterFamily: DiagCandidate[];
  afterLawScope: DiagCandidate[];
  anchorsRaw: DiagCandidate[];
  anchorsKept: DiagCandidate[];
}

/** سطر واحد قابل للبحث فى Deploy Logs بكلمة retrieval-diag. */
export function formatRetrievalStage(d: ClauseRetrievalDiag): string {
  const famDropped = d.merged.length - d.afterFamily.length;
  const lawDropped = d.afterFamily.length - d.afterLawScope.length;
  const droppedLaws = lawCounts(
    d.merged.filter((c) => !d.afterLawScope.some((k) => candidateId(k) === candidateId(c))),
  );
  return (
    `[retrieval-diag] stage=retrieval clause=${d.clauseIndex} ${formatShape(d.shape)} criteria=${d.criteria || '-'} family=${d.family ?? '-'} ` +
    `ftsTokens=${d.ftsTokens} fts=${d.fts.length} semConfigured=${d.semConfigured} sem=${d.sem.length} ` +
    `merged=${d.merged.length} droppedByFamily=${famDropped} droppedByLawScope=${lawDropped} kept=${d.afterLawScope.length} ` +
    `anchorsRaw=${d.anchorsRaw.length} anchorsKept=${d.anchorsKept.length} ` +
    `ftsLaws=${lawCounts(d.fts)} semLaws=${lawCounts(d.sem)} droppedLaws=${droppedLaws} anchorsRawIds=${idList(d.anchorsRaw, 24)} anchorIds=${idList(d.anchorsKept, 24)}`
  );
}

export interface ClauseOutcomeDiag {
  clauseIndex: number;
  /** empty_retrieval | rules | model_selected | model_selected_none | model_no_text | model_error | model_not_configured */
  outcome: string;
  reranked: boolean | null;
  topCandidates: number;
  selected: number;
  assessmentStatus: string | null;
  topIds: string;
}

export function formatClauseOutcome(o: ClauseOutcomeDiag): string {
  return (
    `[retrieval-diag] stage=outcome clause=${o.clauseIndex} outcome=${o.outcome} reranked=${o.reranked ?? '-'} ` +
    `topCandidates=${o.topCandidates} selected=${o.selected} status=${o.assessmentStatus ? 'set' : 'null'} topIds=${o.topIds}`
  );
}

export interface ContractShapeDiag {
  contractId: string;
  extraction: TextShape;
  clauseCount: number;
  clauseChars: number[];
  preambleChars: number;
}

export function formatContractShape(d: ContractShapeDiag): string {
  const lens = d.clauseChars.slice(0, 40).join(',');
  return (
    `[retrieval-diag] stage=contract contract=${d.contractId} ${formatShape(d.extraction)} clauses=${d.clauseCount} ` +
    `preambleChars=${d.preambleChars} clauseChars=[${lens}]`
  );
}

export interface OcrStageDiag {
  contractId: string;
  /** حالة الاستخراج الأول للملف (ok | empty | corrupted_encoding ...) وعدد أحرفه قبل أى قراءة آلية */
  firstStatus: string;
  firstChars: number;
  usedOcr: boolean;
  pages: number | null;
  truncated: boolean | null;
  /** أحرف غير بيضاء لكل صفحة بعد القراءة الآلية (أعداد فقط، بلا نص) */
  pageChars: number[];
}

/** الجولة 75: هل الـ1,039 حرفاً هى العقد كله أم قراءة مقطوعة؟ صفحات الملف وأحرف كل صفحة. */
export function formatOcrStage(d: OcrStageDiag): string {
  const per = d.pageChars.slice(0, 80).join(',');
  return (
    `[retrieval-diag] stage=ocr contract=${d.contractId} firstExtraction=${d.firstStatus}/${d.firstChars} usedOcr=${d.usedOcr} ` +
    `pages=${d.pages ?? '-'} truncated=${d.truncated ?? '-'} pageChars=[${per}]`
  );
}
