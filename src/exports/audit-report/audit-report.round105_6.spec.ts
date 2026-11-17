import { buildContractAuditReport, type AuditClause, type AuditContractFinding, type AuditReportInput } from './build';
import { candidateAction } from './recommendations';

const NOW = new Date('2026-11-17T10:00:00Z');
const FAIL = 'تعذَّر إجراء التقييم الآلى تقنياً — يلزم مراجعة قانونية بشرية.';
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
const base = (clauses: AuditClause[], findings: AuditContractFinding[] = []): AuditReportInput => ({
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
  extractionWarnings: [],
});
const report = (i: AuditReportInput) => buildContractAuditReport(i).report;
const row = (i: AuditReportInput, label: string) => report(i).cover.rows.find((r) => r.label === label);

describe('الجولة 105.6 — تغطية صادقة: بند تعذّر تقييمه تقنياً ليس «قُيِّم»', () => {
  const NO_TEXT = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
  const failed = (i: number) => clause(i, { assessmentStatus: 'يحتاج مراجعة', assessmentReasoning: FAIL, riskLevel: null });
  const mixed = [
    ...[1, 2, 3, 4].map((i) => clause(i)),
    clause(5, { assessmentStatus: NO_TEXT }),
    clause(6, { assessmentStatus: NO_TEXT }),
    failed(7),
    failed(8),
    failed(9),
    clause(10, { assessmentStatus: 'يحتاج مراجعة', assessmentReasoning: 'يخالف حكماً مكملاً.', riskLevel: 'متوسط' }),
  ];

  it('الغلاف: القُيِّم 5 فقط (4 سليم + 1 حقيقى) لا 8، وصف «تعذّر تقنياً: 3» ظاهر بنبرة عالية', () => {
    const i = base(mixed);
    expect(row(i, 'نطاق التغطية')?.value).toContain('5 من 10 بنداً قُيِّمت');
    const r = row(i, 'بنود تعذّر تقييمها تقنياً');
    expect(r?.value).toContain('3 من 10');
    expect(r?.tone).toBe('high');
  });

  it('الملخص: ملاحظة «تعذّر تقنى» منفصلة عن ملاحظة «لا نص مفهرس» (2 بنود لا نص فقط)', () => {
    const text = JSON.stringify(report(base(mixed)).blocks);
    expect(text).toContain('تعذّر تقنى');
    expect(text).toContain('لعطل تقنى فى خدمة التقييم الآلى');
    // لا نص مفهرس: 2 فقط (لا 5)
    expect(text).toMatch(/الأخريان|2|اثنان|بندان/);
  });

  it('بلا أعطال: لا صف جديد ولا تغيير فى العدّ', () => {
    const i = base([clause(1), clause(2), clause(3, { assessmentStatus: NO_TEXT })]);
    expect(row(i, 'بنود تعذّر تقييمها تقنياً')).toBeUndefined();
    expect(row(i, 'نطاق التغطية')?.value).toContain('2 من 3 بنداً قُيِّمت');
  });

  it('البند المعطوب يبقى ظاهراً للمراجعة (لا يُحذف) فلا يُقرأ العقد «سليماً»', () => {
    const lvl = report(base([clause(1), failed(2)])).cover.rows.find((r) => r.label === 'مستوى المخاطرة العام');
    expect(lvl?.value).not.toContain('لم تُرصد');
  });
});

describe('الجولة 105.6 — أولوية المرشحة المبنية على قراءة معيبة', () => {
  it('مرشحة عالية عادية: «متوسطة» (لا تضيع)؛ ومعيبة القراءة: «منخفضة» مع مقارنة بالأصل', () => {
    expect(candidateAction('تعارض', 'عالٍ', 'شك').priority).toBe('متوسطة');
    const d = candidateAction('تعارض', 'عالٍ', 'شك', true);
    expect(d.priority).toBe('منخفضة');
    expect(d.note).toContain('قابل المقتطفين بالأصل');
    expect(candidateAction('تعارض', 'متوسط', 'شك').priority).toBe('منخفضة');
  });

  it('فى التقرير: ع2 المشوَّهة لا تتصدر جدول التوصيات بأولوية متوسطة', () => {
    const q14 = 'المدير قابل للعزل فى أى وقت بقرار مسبب';
    const q26 = 'النظر فى عزل المدير VYY المديرين';
    const f: AuditContractFinding = {
      kind: 'conflict', kindLabel: 'تعارض محتمل بين بندين', severity: 'عالٍ', title: 'تعارض محتمل بين المادة 14 والمادة 26', explanation: 'ت', suggestion: null,
      evidence: [{ clauseLabel: 'المادة 14', quote: q14 }, { clauseLabel: 'المادة 26', quote: q26 }],
      verification: { status: 'unconfirmed', basis: 'uncertain', reason: 'شك.', quote: null },
    };
    const i = { ...base([clause(14, { clauseText: `${q14}.` }), clause(26, { clauseText: `${q26}.` })], [f]), extractionWarnings: ['تمت قراءة العقد آلياً (OCR) من صور ممسوحة ضوئياً'] };
    const grids = report(i).blocks.filter((b) => b.t === 'grid') as unknown as Array<{ columns: string[]; rows: Array<Array<{ text: string }>> }>;
    const g = grids.find((x) => x.columns.includes('الأولوية'));
    const a = g?.rows.map((r) => ({ text: r[1].text, priority: r[2].text })).find((x) => x.text.includes('تعارض محتمل'));
    expect(a?.priority).toBe('منخفضة');
  });
});
