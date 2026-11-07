import { buildContractAuditReport, type AuditClause, type AuditReportInput } from './build';

const clause: AuditClause = {
  clauseIndex: 1,
  clauseLabel: 'البند الأول',
  clauseTitle: null,
  clauseText: 'نص البند',
  assessmentStatus: 'سليم',
  assessmentReasoning: null,
  matchedArticles: [],
  riskLevel: null,
  suggestedWording: null,
  lawyerVerdict: null,
  lawyerNotes: null,
};

const NOTE = 'خُفضت الدرجة من «عالٍ» إلى «متوسط» آلياً: الاقتباس لا يمس مبلغاً أو مدة أو إنهاءً.';
const finding = (severityNote: string | null) => ({
  kind: 'open_term',
  kindLabel: 'شرط مفتوح',
  severity: 'متوسط',
  title: 'مستوى الخدمة وخطة المشروع معلقان على اتفاق لاحق',
  explanation: 'يبدو أن الالتزام مفتوح دون موعد أو آلية.',
  suggestion: null,
  severityNote,
  evidence: [{ clauseLabel: 'البند الخامس', quote: 'تحديد مستوى الخدمة وخطة المشروع بعد التوصل لاتفاق لاحق' }],
});

const base: AuditReportInput = {
  contractId: 'abcdef12-0000-0000-0000-000000000000',
  originalFilename: 'عقد.docx',
  uploadedAt: new Date('2026-11-07T10:00:00Z'),
  contractType: 'عقد خدمات أو مقاولة أو توريد',
  clientRole: 'طالب الخدمة (صاحب العمل / العميل)',
  clauses: [clause],
  approvedAt: null,
  approvalNote: null,
  generatedAt: new Date('2026-11-07T10:00:00Z'),
  brand: 'شيلد',
};

describe('الجولة 66: سبب الدرجة فى تقرير المحامى فقط', () => {
  it('نسخة المحامى تعرض «سبب الدرجة» حين يوجد، ولا تعرضه حين يغيب', () => {
    const withNote = JSON.stringify(buildContractAuditReport({ ...base, contractFindings: [finding(NOTE)], contractFindingsModel: 'ok' }).report.blocks);
    expect(withNote).toContain('سبب الدرجة');
    expect(withNote).toContain('خُفضت الدرجة');
    const without = JSON.stringify(buildContractAuditReport({ ...base, contractFindings: [finding(null)], contractFindingsModel: 'ok' }).report.blocks);
    expect(without).not.toContain('سبب الدرجة');
  });

  it('نسخة العميل لا تعرض سبب الدرجة', () => {
    const { report } = buildContractAuditReport({ ...base, audience: 'client', partyNames: { first: 'شركة أ', second: 'شركة ب' }, contractFindings: [finding(NOTE)], contractFindingsModel: 'ok' });
    expect(JSON.stringify(report)).not.toContain('سبب الدرجة');
    expect(JSON.stringify(report)).not.toContain('خُفضت الدرجة');
  });
});
