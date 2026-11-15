import { buildContractAuditReport, DENSITY_MIN_SHARE, DENSITY_MIN_UNITS, type AuditClause, type AuditReportInput } from './build';

const NOW = new Date('2026-11-15T10:00:00Z');
const clause = (i: number, over: Partial<AuditClause> = {}): AuditClause => ({
  clauseIndex: i,
  clauseLabel: `البند ${i}`,
  clauseTitle: null,
  clauseText: 'نص البند',
  assessmentStatus: 'سليم',
  assessmentReasoning: null,
  matchedArticles: [],
  riskLevel: null,
  suggestedWording: null,
  lawyerVerdict: null,
  lawyerNotes: null,
  ...over,
});
const medium = (i: number): AuditClause => clause(i, { assessmentStatus: 'يحتاج مراجعة', riskLevel: 'متوسط', assessmentReasoning: 'اختلال تجارى.' });
const input = (mediumCount: number, total = 15): AuditReportInput => ({
  contractId: 'abcdef12-0000-0000-0000-000000000000',
  originalFilename: 'عقد.pdf',
  uploadedAt: NOW,
  contractType: 'عقد إيجار',
  clientRole: 'المستأجر',
  clauses: Array.from({ length: total }, (_, k) => (k < mediumCount ? medium(k + 1) : clause(k + 1))),
  approvedAt: null,
  approvalNote: null,
  generatedAt: NOW,
  brand: 'شيلد',
});
const level = (i: AuditReportInput) => buildContractAuditReport(i).report.cover.rows.find((r) => r.label === 'مستوى المخاطرة العام')!;

describe('الجولة 99: تراكم الملاحظات المتوسطة يرفع المستوى العام', () => {
  it('العتبات المعلنة', () => {
    expect(DENSITY_MIN_UNITS).toBe(6);
    expect(DENSITY_MIN_SHARE).toBe(0.4);
  });

  it('عقد سليم عليه ملاحظات قليلة (4 من 15) يبقى «متوسطة»', () => {
    const l = level(input(4));
    expect(l.value).toContain('مخاطرة متوسطة');
    expect(l.tone).toBe('medium');
  });

  it('12 ملاحظة متوسطة من 15 بنداً ⇒ «مرتفعة نسبياً» مع ذكر التراكم', () => {
    const l = level(input(12));
    expect(l.value).toContain('مخاطرة مرتفعة نسبياً');
    expect(l.value).toContain('تراكم 12 ملاحظة مؤكدة');
    expect(l.tone).toBe('high');
  });

  it('حدّ العتبة: 5 وحدات لا تكفى، و6 من 15 (40%) تكفى', () => {
    expect(level(input(5)).value).toContain('مخاطرة متوسطة');
    expect(level(input(6)).value).toContain('مرتفعة نسبياً');
  });

  it('عدد كبير من البنود يخفف النسبة: 6 من 30 لا ترفع', () => {
    expect(level(input(6, 30)).value).toContain('مخاطرة متوسطة');
  });

  it('المرشحات غير المؤكدة لا تُحسب فى التراكم', () => {
    const i = input(12);
    i.clauses = i.clauses.map((c) => (c.riskLevel === 'متوسط' ? { ...c, verification: { status: 'unconfirmed', basis: 'uncertain', reason: 'ش', quote: null, quoteSource: null, verifiedAt: NOW.toISOString() } } : c)) as AuditClause[];
    expect(level(i).value).not.toContain('تراكم');
  });

  it('المخاطرة الحرجة تسبق التراكم', () => {
    const i = input(12);
    i.clauses[0] = { ...i.clauses[0], riskLevel: 'حرج' };
    expect(level(i).value).toContain('يستوجب التفاوض الفوري');
  });
});
