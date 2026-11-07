import { type AuditClause, type AuditReportInput, buildContractAuditReport } from './build';
import type { RBlock } from './model';

const NOW = new Date('2026-11-07T10:00:00Z');
const clause = (over: Partial<AuditClause> & { clauseIndex: number }): AuditClause => ({
  clauseLabel: `البند ${over.clauseIndex}`,
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
const INPUT: AuditReportInput = {
  contractId: 'abcdef12-0000-0000-0000-000000000000',
  originalFilename: 'عقد.docx',
  uploadedAt: NOW,
  contractType: 'عقد شراكة',
  clientRole: 'الشريك المستثمر',
  clauses: [clause({ clauseIndex: 1 })],
  approvedAt: null,
  approvalNote: null,
  generatedAt: NOW,
  brand: 'شيلد',
};
const finding = (over: Record<string, unknown> = {}) => ({
  kind: 'conflict',
  kindLabel: 'تعارض محتمل',
  severity: 'عالٍ',
  title: 'بند يقرر التحويل أسبوعياً وآخر يطلب تقارير يومية',
  explanation: 'تعارض بين البندين.',
  suggestion: 'توحيد الحكم.',
  evidence: [{ clauseLabel: 'البند الثانى', quote: 'يتم تحويل اجمالى المبالغ المحصلة أسبوعيا' }],
  ...over,
});
const refuted = (kind: string, quote: string | null = 'لا يسأل كل شريك عن ديون الشراكة') => ({
  status: 'unconfirmed' as const,
  basis: 'refuted',
  refutationKind: kind,
  reason: 'فلا تعارض بين البندين.',
  quote,
});
const all = (r: { blocks: RBlock[]; cover: { rows: Array<{ label: string; value: string }> } }) => JSON.stringify(r.blocks);
const gridBy = (r: { blocks: RBlock[] }, col: string) => r.blocks.find((b) => b.t === 'grid' && b.columns.includes(col)) as Extract<RBlock, { t: 'grid' }> | undefined;

describe('الجولة 60: المرشحات المدحوضة بدحض موثَّق تنتقل إلى ملحق ولا تؤقّت المستوى', () => {
  it('ملاحظة عالية دحضها المدقق باقتباس موثَّق وسبب محدد: ملحق «فُحصت واستُبعدت»، لا غلاف مؤقت ولا مرشحات ولا توصية تحقق', () => {
    const { report } = buildContractAuditReport({ ...INPUT, contractFindings: [finding({ verification: refuted('clause_addresses') })], contractFindingsModel: 'ok' });
    expect(report.cover.rows.map((r) => r.label)).not.toContain('مرشحات عالية لم تُحسم');
    const json = all(report);
    expect(json).toContain('ملاحظات فُحصت واستُبعدت بدحض موثَّق');
    expect(json).toContain('الاقتباس الموثَّق: «لا يسأل كل شريك عن ديون الشراكة»');
    expect(json).not.toContain('مرشّحات للمراجعة البشرية — غير مؤكدة');
    expect(json).not.toContain('(مرشّحة)');
    expect(json).not.toContain('التحقق البشرى من مرشّحة');
    const dismissed = gridBy(report, 'الملاحظة المستبعدة')!;
    expect(dismissed.rows).toHaveLength(1);
    expect(dismissed.rows[0][0].text).toBe('د1');
  });

  it('الجولة 61: ملاحظة تعارض على مستوى العقد دُحضت بسبب «التوفيق» (reconciled) باقتباس موثَّق تنتقل إلى الملحق', () => {
    const { report } = buildContractAuditReport({ ...INPUT, contractFindings: [finding({ verification: refuted('reconciled') })], contractFindingsModel: 'ok' });
    expect(report.cover.rows.map((r) => r.label)).not.toContain('مرشحات عالية لم تُحسم');
    const json = all(report);
    expect(json).toContain('ملاحظات فُحصت واستُبعدت بدحض موثَّق');
    expect(json).not.toContain('(مرشّحة)');
    expect(gridBy(report, 'الملاحظة المستبعدة')!.rows).toHaveLength(1);
  });

  it('اعتراض بلا اقتباس (uncertain) أو بسبب غامض (other) يبقى مرشّحاً على الغلاف والمستوى مؤقت', () => {
    for (const v of [
      { status: 'unconfirmed' as const, basis: 'uncertain', reason: 'اعترض المدقق دون اقتباس موثَّق.', quote: null },
      refuted('other'),
      refuted('clause_addresses', null),
    ]) {
      const { report } = buildContractAuditReport({ ...INPUT, contractFindings: [finding({ verification: v })], contractFindingsModel: 'ok' });
      expect(report.cover.rows.map((r) => r.label)).toContain('مرشحات عالية لم تُحسم');
      expect(all(report)).not.toContain('ملاحظات فُحصت واستُبعدت بدحض موثَّق');
      expect(all(report)).toContain('(مرشّحة)');
    }
  });

  it('بند حرج غير مؤكد مدحوض بدحض موثَّق ينتقل إلى الملحق ولا يدخل الأعداد ولا الغلاف، ويبقى بند آخر مرشّحاً', () => {
    const clauses = [
      clause({ clauseIndex: 1, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'حرج', assessmentReasoning: 'يخالف نصاً آمراً.', verification: refuted('not_mandatory', 'دون حاجة إلى إنذار') }),
      clause({ clauseIndex: 2, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'عالٍ', assessmentReasoning: 'تحتاج مراجعة.', verification: { status: 'unconfirmed', reason: 'لم يجزم المدقق.' } }),
    ];
    const { report } = buildContractAuditReport({ ...INPUT, clauses });
    const dismissed = gridBy(report, 'الملاحظة المستبعدة')!;
    expect(dismissed.rows.map((r) => r[2].text)).toEqual(['البند 1']);
    const cand = gridBy(report, 'سبب عدم التأكيد')!;
    expect(cand.rows.map((r) => r[3].text)).toEqual(['البند 2']);
    const high = report.cover.rows.find((r) => r.label === 'مرشحات عالية لم تُحسم')!;
    expect(high.value).toContain('1 ملاحظة');
  });

  it('ملاحظة مستبعدة وحدها: لا تظهر فى القسم الخامس ولا فى الأعداد، وتُذكر فى الملحق فقط', () => {
    const { report } = buildContractAuditReport({ ...INPUT, contractFindings: [finding({ verification: refuted('not_applicable') })], contractFindingsModel: 'ok' });
    const json = all(report);
    expect(json).not.toContain('ع1. بند يقرر التحويل');
    expect(json).toContain('ما استُبعد بدحض موثَّق مذكور فى ملحق مصفوفة المخاطر');
    const overall = report.cover.rows.at(-1)!;
    expect(overall.value).not.toContain('ملاحظة');
  });
});
