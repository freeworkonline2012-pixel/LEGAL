import { type AuditClause, type AuditContractFinding, type AuditReportInput, buildContractAuditReport } from './build';
import type { RBlock } from './model';

/**
 * وحدة معالجة واحدة لكل بند (الجولة 41): ملاحظة «قاعدة المكتب» المؤكدة التى يقع دليلها فى بند مؤكد الخطورة تُدمج فيه فلا تُعدّ ولا تُعرض مرتين،
 * وتدخل ملاحظات العقد ككل المؤكدة عدّاد الخطورة بدرجتها (قرار محامى المكتب: «تُحتسب»).
 */

const NOW = new Date('2026-11-03T10:00:00Z');
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
const CLAUSES: AuditClause[] = [
  clause(1),
  clause(7, {
    assessmentStatus: 'يحتاج مراجعة',
    riskLevel: 'متوسط',
    assessmentReasoning: 'يجيز البند الفسخ دون حكم قضائى. يستحق نظر العميل.',
    suggestedWording: JSON.stringify({ text: 'بند معدّل.', changes: ['أُضيفت مهلة تصحيح.'] }),
  }),
  clause(13),
];
const finding = (over: Partial<AuditContractFinding> = {}): AuditContractFinding => ({
  kind: 'office_rule',
  kindLabel: 'قاعدة المكتب',
  severity: 'عالٍ',
  title: 'فسخ أو تعويض عن الإخلال دون إخطار بالمخالفة ومهلة للرد والتصحيح',
  explanation: 'قاعدة المكتب.',
  suggestion: 'نص يلزم مدعى المخالفة بإخطار مسجل يبين المخالفة.',
  evidence: [
    { clauseLabel: 'البند 7', quote: 'يحق للطرف الاول المطالبة بانتهاء العقد' },
    { clauseLabel: 'البند 13', quote: 'يد غاصبة' },
  ],
  ...over,
});
const MISSING = finding({ kind: 'missing_clause', kindLabel: 'بند غير مرصود', severity: 'متوسط', title: 'لم يُرصد بند يتناول: الصيانة والإصلاحات', suggestion: 'نص يبين الصيانة الدورية.', evidence: [] });
const LOW = finding({ kind: 'undefined_term', kindLabel: 'مصطلح غير معرَّف', severity: 'منخفض', title: 'إحالة إلى «العنوان المبين بصدر العقد»', suggestion: null, evidence: [] });

const run = (findings: AuditContractFinding[], extra: Partial<AuditReportInput> = {}) =>
  buildContractAuditReport({
    contractId: 'abcdef12-0000-0000-0000-000000000000',
    originalFilename: 'عقد.docx',
    uploadedAt: NOW,
    contractType: 'عقد إيجار',
    clientRole: 'المستأجر',
    clauses: CLAUSES,
    approvedAt: null,
    approvalNote: null,
    generatedAt: NOW,
    brand: 'شيلد',
    contractFindings: findings,
    contractFindingsModel: 'ok',
    ...extra,
  }).report;

const grids = (blocks: RBlock[]) => blocks.filter((b): b is Extract<RBlock, { t: 'grid' }> => b.t === 'grid');
const matrix = (blocks: RBlock[]) => grids(blocks).find((g) => g.columns[1] === 'وصف المخاطرة')!;
const actions = (blocks: RBlock[]) => grids(blocks).find((g) => g.columns.includes('الإجراء المطلوب'))!;
const strip = (blocks: RBlock[]) => (blocks.find((b) => b.t === 'strip') as Extract<RBlock, { t: 'strip' }>).cells.map((c) => c.text);

describe('وحدة معالجة واحدة لكل بند', () => {
  const r = run([finding(), MISSING, LOW]);

  it('ملاحظة قاعدة المكتب تدخل العدّاد بدرجتها: البند 7 المتوسط يصير عالياً ولا تُعدّ الملاحظة مرتين', () => {
    expect(strip(r.blocks)).toEqual(['1 ملاحظة متوسطة', '1 ملاحظة عالية', '0 ملاحظات حرجة', '3 ملاحظات للمراجعة']);
    expect(r.cover.rows.find((x) => x.label === 'مستوى المخاطرة العام')?.tone).toBe('high');
  });

  it('المصفوفة: صف واحد للبند 7 بالدرجة الأعلى ويحيل إلى ع1، ولا صف مستقل لـ ع1 المدمجة', () => {
    const rows = matrix(r.blocks).rows;
    const first = rows[0];
    expect(first[2]).toMatchObject({ text: 'عالٍ' });
    expect(first[1].text).toContain('ويشمل أيضاً ع1');
    expect(first[1].text).toContain('رُفعت الدرجة إلى عالٍ');
    expect(rows.map((x) => x[0].text)).not.toContain('ع1');
    expect(rows.map((x) => x[0].text)).toEqual(expect.arrayContaining(['ع2', 'ع3']));
  });

  it('أهم ما يستوجب الانتباه: صف واحد لوحدة البند 7 بسبب الرفع (عنوان قاعدة المكتب) لا نصان متكرران', () => {
    const top = grids(r.blocks).find((g) => g.columns.includes('الموضع') && g.columns.includes('الملاحظة'))!;
    expect(top.rows).toHaveLength(1);
    expect(top.rows[0][1].text).toBe('البند 7، البند 13');
    expect(top.rows[0][2].text).toContain('فسخ أو تعويض عن الإخلال');
    expect(top.rows[0][3]).toMatchObject({ text: 'عالٍ' });
  });

  it('التوصيات: إجراء واحد للبند 7 بأولوية عالية، ولا إجراء «تعديل وفق قاعدة المكتب» مستقل، ونصه يذكر ع1', () => {
    const rows = actions(r.blocks).rows;
    const texts = rows.map((x) => x[1].text);
    expect(texts.filter((t) => t.includes('البند 7'))).toHaveLength(1);
    expect(texts.some((t) => t.startsWith('تعديل وفق قاعدة المكتب'))).toBe(false);
    const unitRow = rows.find((x) => x[1].text.includes('البند 7'))!;
    expect(unitRow[2]).toMatchObject({ text: 'عالية' });
    expect(unitRow[4].text).toContain('قاعدة المكتب (ع1)');
    expect(unitRow[1].text).toContain('وفق الصياغة المقترحة');
  });

  it('تفصيل البند: صف «قاعدة المكتب» ورسالة الرفع، وجدول ملاحظات العقد ككل يوسم ع1 بأنها محسوبة ضمن البند', () => {
    const json = JSON.stringify(r.blocks);
    expect(json).toContain('رُفعت درجة هذا البند من متوسط إلى عالٍ');
    const whole = grids(r.blocks).find((g) => g.columns.includes('النوع') && g.columns.includes('الملاحظة'))!;
    expect(whole.rows[0][2].text).toContain('محسوبة ضمن البند 7');
    expect(whole.rows[1][2].text).not.toContain('محسوبة ضمن');
  });

  it('ملخص النص يصف الملاحظات بنطاقها ويذكر أن ملاحظات المكتب تُعدّ بدرجتها', () => {
    const p = r.blocks.filter((b) => b.t === 'p').map((b) => (b as { text: string }).text).find((t) => t.startsWith('رُصدت فى هذا العقد'))!;
    expect(p).toContain('3 ملاحظات');
    expect(p).toContain('على العقد ككل');
    expect(p).toContain('حُسبت مرة واحدة بأعلى الدرجتين');
  });
});

describe('حالات حدّية للدمج', () => {
  it('ملاحظة مكتب أدنى من درجة البند لا ترفعه ولا تُعدّ مرتين', () => {
    const r = run([finding({ severity: 'منخفض' })]);
    expect(matrix(r.blocks).rows[0][2]).toMatchObject({ text: 'متوسط' });
    expect(matrix(r.blocks).rows[0][1].text).not.toContain('رُفعت الدرجة');
    // الملاحظة المدمجة لا تضيف وحدة: لا ملاحظات مستقلة فيبقى الشريط بصياغة البنود
    expect(strip(r.blocks)).toEqual(['1 بند متوسط', '0 بنود عالية', '0 بنود حرجة', '1 بند للمراجعة']);
  });

  it('نوع آخر من الملاحظات (غير قاعدة المكتب) لا يُدمج حتى لو تقاطع دليله مع بند', () => {
    const r = run([finding({ kind: 'conflict', kindLabel: 'تعارض محتمل بين بندين' })]);
    expect(matrix(r.blocks).rows.map((x) => x[0].text)).toContain('ع1');
  });

  it('ملاحظة مكتب لا يقع دليلها فى بند مؤكد تبقى وحدة مستقلة وتُعدّ بدرجتها', () => {
    const r = run([finding({ evidence: [{ clauseLabel: 'البند 13', quote: 'يد غاصبة' }] })]);
    expect(matrix(r.blocks).rows.map((x) => x[0].text)).toContain('ع1');
    expect(strip(r.blocks)[1]).toBe('1 ملاحظة عالية');
    expect(actions(r.blocks).rows.some((x) => x[1].text.startsWith('تعديل وفق قاعدة المكتب'))).toBe(true);
  });

  it('ملاحظة مرشّحة غير مؤكدة لا تُدمج ولا تُعدّ', () => {
    const r = run([finding({ verification: { status: 'unconfirmed', reason: 'محتملة' } })]);
    expect(matrix(r.blocks).rows[0][2]).toMatchObject({ text: 'متوسط' });
    expect(strip(r.blocks)[1]).toBe('0 بنود عالية');
  });

  it('بلا ملاحظات عقد ككل: الشريط بصياغة البنود كما كان', () => {
    const r = run([]);
    expect(strip(r.blocks)).toEqual(['1 بند متوسط', '0 بنود عالية', '0 بنود حرجة', '1 بند للمراجعة']);
  });

  it('نسخة العميل: العدّاد يحسب الوحدات والملاحظة المدمجة لا تتكرر فى قائمة الملاحظات', () => {
    const r = run([finding(), MISSING], { audience: 'client' });
    const json = JSON.stringify(r.blocks);
    expect(json).toContain('1 عالية');
    expect(json.split('فسخ أو تعويض عن الإخلال دون إخطار').length - 1).toBeLessThanOrEqual(1);
  });
});
