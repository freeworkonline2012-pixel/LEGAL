import { buildContractAuditReport, type AuditClause, type AuditContractFinding, type AuditReportInput } from './build';

const NOW = new Date('2026-11-17T10:00:00Z');
const clause = (i: number, over: Partial<AuditClause> = {}): AuditClause => ({
  clauseIndex: i,
  clauseLabel: `المادة ${i}`,
  clauseTitle: null,
  clauseText: 'يلتزم الشريك بسداد حصته كاملة فى المواعيد المحددة بهذا العقد.',
  assessmentStatus: 'سليم',
  assessmentReasoning: null,
  matchedArticles: [],
  riskLevel: null,
  suggestedWording: null,
  lawyerVerdict: null,
  lawyerNotes: null,
  ...over,
});
const finding = (a: string, qa: string, b: string, qb: string): AuditContractFinding => ({
  kind: 'conflict',
  kindLabel: 'تعارض محتمل بين بندين',
  severity: 'عالٍ',
  title: `تعارض محتمل بين المادة ${a} والمادة ${b}`,
  explanation: 'تفصيل.',
  suggestion: null,
  evidence: [
    { clauseLabel: `المادة ${a}`, quote: qa },
    { clauseLabel: `المادة ${b}`, quote: qb },
  ],
  verification: { status: 'unconfirmed', basis: 'uncertain', reason: 'شك.', quote: null },
});
const base = (clauses: AuditClause[], findings: AuditContractFinding[]): AuditReportInput => ({
  contractId: 'abcdef12-0000-0000-0000-000000000000',
  originalFilename: 'عقد.pdf',
  uploadedAt: NOW,
  contractType: 'عقد تأسيس شركة',
  clientRole: null,
  clauses,
  approvedAt: null,
  approvalNote: null,
  generatedAt: NOW,
  brand: 'شيلد',
  contractFindings: findings,
  contractFindingsModel: 'ok',
  extractionWarnings: ['تمت قراءة العقد آلياً (OCR) من صور ممسوحة ضوئياً'],
});
const rowOf = (i: AuditReportInput, label: string) => buildContractAuditReport(i).report.cover.rows.find((r) => r.label === label);

describe('الجولة 105.5 — عيب القراءة يُفحص فى جملة الاقتباس لا فى البند كله', () => {
  const q14 = 'المدير قابل للعزل فى أى وقت بقرار مسبب';
  const q26 = 'النظر فى عزل المدير / المديرين';
  // رمز مشوَّه فى جملة بعيدة عن الاقتباس (توقيع) لا يجعل التعارض ناشئاً من القراءة
  const c26 = clause(26, { clauseText: `${q26}. يوقع الشركاء VYY على السجل.` });
  const c14 = clause(14, { clauseText: `${q14}.` });

  it('اقتباس نظيف فى بند به رمز مشوَّه بعيد عنه ⇒ يبقى بين المرشحات العالية (ع2)', () => {
    const i = base([c14, c26], [finding('14', q14, '26', q26)]);
    expect(rowOf(i, 'مرشحات عالية لم تُحسم')?.value).toContain('1 ملاحظة بدرجة عالية');
    expect(rowOf(i, 'مرشحات من نص مقروء بخلل')).toBeUndefined();
  });

  it('الرمز المشوَّه داخل جملة الاقتباس نفسها ⇒ يُعدّ على حدة بسببه', () => {
    const bad = clause(26, { clauseText: 'النظر فى عزل المدير VYY المديرين. يوقع الشركاء على السجل.' });
    const i = base([c14, bad], [finding('14', q14, '26', 'النظر فى عزل المدير VYY المديرين')]);
    expect(rowOf(i, 'مرشحات عالية لم تُحسم')).toBeUndefined();
    expect(rowOf(i, 'مرشحات من نص مقروء بخلل')?.value).toContain('1 مرشّحة');
  });

  it('اقتباس غير موجود حرفياً فى النص (إعادة صياغة) ⇒ السلوك المحافظ: فحص البند كله', () => {
    const i = base([c14, c26], [finding('14', q14, '26', 'عبارة معاد صياغتها لا ترد حرفياً فى البند')]);
    expect(rowOf(i, 'مرشحات من نص مقروء بخلل')).toBeDefined();
  });
});
