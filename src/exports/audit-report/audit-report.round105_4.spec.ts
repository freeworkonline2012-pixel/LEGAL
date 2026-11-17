import { buildContractAuditReport, type AuditClause, type AuditContractFinding, type AuditReportInput } from './build';
import { buildStockChapterNote, extractStockChapterNote } from '../../contracts/no-text-note';
import { stockChapterCounterparts, type PoolEntry } from '../../contracts/restatement';

const NOW = new Date('2026-11-16T10:00:00Z');
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
const finding = (n: number, a: string, b: string): AuditContractFinding => ({
  kind: 'conflict',
  kindLabel: 'تعارض محتمل بين بندين',
  severity: 'عالٍ',
  title: `تعارض محتمل بين المادة ${a} والمادة ${b}`,
  explanation: 'تفصيل.',
  suggestion: null,
  evidence: [
    { clauseLabel: `المادة ${a}`, quote: 'نص أول' },
    { clauseLabel: `المادة ${b}`, quote: 'نص ثان' },
  ],
  verification: { status: 'unconfirmed', basis: 'uncertain', reason: 'شك.', quote: null },
  ...(n ? {} : {}),
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
});
const rowOf = (i: AuditReportInput, label: string) => buildContractAuditReport(i).report.cover.rows.find((r) => r.label === label);

describe('الجولة 105.4 — مرشحات التعارض من نص مقروء بخلل لا تُحسب بين المرشحات العالية على الغلاف', () => {
  const blank = 'يخصص بعد ذلك مبلغ لا تتجاوز نسبته % من الأرباح المتبقية لمكافأة إدارة الشركة.';
  const clauses = [clause(14), clause(26), clause(16), clause(34, { clauseText: blank })];

  it('مرشح بين بندين سليمين القراءة يبقى على الغلاف كما كان', () => {
    const i = base(clauses, [finding(1, '14', '26')]);
    expect(rowOf(i, 'مرشحات عالية لم تُحسم')?.value).toContain('1 ملاحظة بدرجة عالية');
    expect(rowOf(i, 'مرشحات من نص مقروء بخلل')).toBeUndefined();
  });

  it('مرشح أحد بنديه فيه خانة فارغة يُعدّ على حدة بسببه ولا يُحذف من القسم الخاص', () => {
    const i = base(clauses, [finding(1, '14', '26'), finding(2, '16', '34')]);
    expect(rowOf(i, 'مرشحات عالية لم تُحسم')?.value).toContain('1 ملاحظة بدرجة عالية');
    expect(rowOf(i, 'مرشحات من نص مقروء بخلل')?.value).toContain('1 مرشّحة');
    const json = JSON.stringify(buildContractAuditReport(i).report.blocks);
    expect(json).toContain('تعارض محتمل بين المادة 16 والمادة 34');
    expect(json).toContain('تنبيه قراءة');
  });

  it('إن كانت كل المرشحات العالية من نص بخلل فلا يظهر صف «لم تُحسم» ويظهر صف الخلل فقط', () => {
    const i = base(clauses, [finding(2, '16', '34')]);
    expect(rowOf(i, 'مرشحات عالية لم تُحسم')).toBeUndefined();
    expect(rowOf(i, 'مرشحات من نص مقروء بخلل')).toBeDefined();
  });
});

describe('الجولة 105.4 — سبب «لا يوجد نص» حين يقارب البند مادة من فصل المساهمة', () => {
  const NO_TEXT = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
  const stockText = 'لا يجوز للجمعية العامة أن تتداول في غير المسائل المدرجة في جدول الأعمال المحدد سلفا بإخطار الدعوة ومع ذلك يكون للجمعية حق المداولة في الوقائع الخطيرة التي تتكشف أثناء الاجتماع';
  const clauseText = stockText.replace('الجمعية العامة', 'الجمعية العامة للشركاء');
  const entry = (id: string, text: string, gate: PoolEntry['gate']): PoolEntry => ({ id, text, shown: false, gate });

  it('stockChapterCounterparts تعيد المادة التى أسقطتها البوابة فقط وبحد أدنى للتغطية', () => {
    const ids = stockChapterCounterparts(clauseText, [entry('159/1981#71', stockText, 'dropped-company'), entry('159/1981#120', 'يدير الشركة مدير أو أكثر من الشركاء أو من غيرهم ويعينون لأول مرة عن طريق المؤسسين', 'kept')]);
    expect(ids).toEqual(['159/1981#71']);
    expect(stockChapterCounterparts(clauseText, [entry('159/1981#71', stockText, 'kept')])).toEqual([]);
    expect(stockChapterCounterparts('نسخة لكل شريك', [entry('159/1981#71', stockText, 'dropped-company')])).toEqual([]);
  });

  it('الملاحظة محايدة (رقم المادة ونصها العام) وتُستخرج من حقل التعليل', () => {
    const note = buildStockChapterNote(['159/1981#71', '96/1982#244'])!;
    expect(note).toContain('المادة 71 من قانون الشركات 159/1981');
    expect(note).toContain('المادة 244 من اللائحة التنفيذية 96/1982');
    expect(note).toContain('يلزم نظر محامٍ');
    expect(extractStockChapterNote(`البند يتناول المداولة. ${note}`)).toBe(note);
    expect(extractStockChapterNote('بلا ملاحظة')).toBeNull();
    expect(buildStockChapterNote(['999/2000#1'])).toBeNull();
  });

  it('التقرير يعرض الملاحظة بجدول مستقل ولا يغيّر حالة البند ولا التغطية', () => {
    const note = buildStockChapterNote(['159/1981#71'])!;
    const cs = [clause(23, { assessmentStatus: NO_TEXT, assessmentReasoning: `بند عن المداولة. ${note}` }), clause(24)];
    const out = buildContractAuditReport(base(cs, []));
    const json = JSON.stringify(out.report.blocks);
    expect(json).toContain('المادة 71 من قانون الشركات 159/1981');
    expect(json).toContain('لا يوجد نص مفهرس يحكمه مباشرة');
    expect(out.report.cover.rows.find((r) => r.label === 'نطاق التغطية')?.value).toContain('1 من 2');
  });

  it('بند لا يوجد نص بلا ملاحظة لا يولّد الجدول', () => {
    const cs = [clause(23, { assessmentStatus: NO_TEXT, assessmentReasoning: 'بند عن المداولة.' }), clause(24)];
    expect(JSON.stringify(buildContractAuditReport(base(cs, [])).report.blocks)).not.toContain('فصل شركات المساهمة؛ هذه المواد');
  });
});
