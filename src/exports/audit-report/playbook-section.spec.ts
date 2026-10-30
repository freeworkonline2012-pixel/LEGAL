import { type AuditClause, type AuditReportInput, buildContractAuditReport } from './build';
import { auditDocxParts } from './docx';
import { renderAuditHtml } from './html';
import type { RBlock } from './model';

const NOW = new Date('2026-10-25T10:00:00Z');

function clause(clauseIndex: number, clauseText: string): AuditClause {
  return {
    clauseIndex,
    clauseLabel: `البند ${clauseIndex}`,
    clauseTitle: null,
    clauseText,
    assessmentStatus: 'سليم',
    assessmentReasoning: null,
    matchedArticles: [],
    riskLevel: null,
    suggestedWording: null,
    lawyerVerdict: null,
    lawyerNotes: null,
  };
}

const LEASE = [
  clause(1, 'المدة: مدة هذا العقد ثلاث سنوات ويتجدد تلقائياً لمدد مماثلة.'),
  clause(2, 'الأجرة: القيمة الإيجارية الشهرية 20000 جنيه. وللمؤجر زيادة الأجرة سنوياً بالنسبة التى يقدرها.'),
  clause(3, 'الصيانة: يتحمل المستأجر كافة الصيانة والإصلاحات أثناء مدة العقد.'),
];

const base = (over: Partial<AuditReportInput> = {}): AuditReportInput => ({
  contractId: 'abcdef12-0000-0000-0000-000000000000',
  originalFilename: 'عقد.docx',
  uploadedAt: NOW,
  contractType: 'عقد إيجار',
  clientRole: 'المستأجر',
  clauses: LEASE,
  approvedAt: null,
  approvalNote: null,
  generatedAt: NOW,
  brand: 'شيلد',
  ...over,
});

const of = <T extends RBlock['t']>(blocks: RBlock[], t: T) => blocks.filter((b) => b.t === t) as Array<Extract<RBlock, { t: T }>>;
const bannerTexts = (blocks: RBlock[]) => of(blocks, 'banner').map((b) => b.text);

describe('قسم الدليل التفاوضى فى تقرير تدقيق العقد (الجولة 7)', () => {
  it('يظهر لنوع مدعوم باسم النوع والصفة، قبل النسخة المعدلة وبعد ملاحظات العقد ككل', () => {
    const { report } = buildContractAuditReport(base());
    const banners = bannerTexts(report.blocks);
    const i = banners.findIndex((b) => b.includes('الدليل التفاوضى'));
    expect(i).toBeGreaterThan(-1);
    expect(banners[i]).toMatch(/^\d+\. الدليل التفاوضى — عقد إيجار من منظور المستأجر$/);
    expect(banners[i + 1]).toContain('النسخة الاحترافية');
    // الترقيم متسلسل
    expect(banners.map((b) => Number.parseInt(b, 10))).toEqual(banners.map((_, k) => k + 1));
  });

  it('يظهر لأنواع الجولة 33 (شراكة وتمويل ووكالة وترخيص) باسم النوع والصفة وبمحاورها', () => {
    const cases: Array<[string, string, string, string, number]> = [
      ['عقد شراكة أو استثمار', 'الشريك المستثمر', 'الإدارة: ينفرد الشريك المدير بإدارة المشروع ويتخذ جميع القرارات دون الرجوع إلى المستثمر.', 'عقد شراكة أو استثمار من منظور الشريك المستثمر', 8],
      ['عقد تمويل أو قرض', 'المقترض (المدين)', 'الفائدة: يسدد المقترض فائدة سنوية قدرها 18 % من رصيد القرض.', 'عقد تمويل أو قرض من منظور المقترض (المدين)', 6],
      ['عقد وكالة أو سمسرة أو تسويق', 'الوكيل أو السمسار', 'العمولة: للموكل خصم أى مبالغ من العمولة المستحقة للوكيل.', 'عقد وكالة أو سمسرة أو تسويق من منظور الوكيل أو السمسار', 6],
      ['عقد ترخيص أو امتياز تجارى', 'المرخَّص له', 'المقابل: يسدد المرخص له رسوم دخول غير قابلة للاسترداد.', 'عقد ترخيص أو امتياز تجارى من منظور المرخَّص له', 7],
    ];
    for (const [type, role, text, heading, rows] of cases) {
      const { report } = buildContractAuditReport(base({ contractType: type, clientRole: role, clauses: [clause(1, text)] }));
      const banners = bannerTexts(report.blocks);
      expect(banners.some((b) => b.endsWith(`الدليل التفاوضى — ${heading}`))).toBe(true);
      const grid = of(report.blocks, 'grid').find((g) => g.columns[0] === 'المحور')!;
      expect(grid.rows).toHaveLength(rows);
      expect(grid.rows.some((r) => r[1].tone === 'critical')).toBe(true);
    }
  });

  it('الجدول: صف لكل محور، الاقتباس حرفى بين «»، وموقف بثلاث درجات، والحالات بنغماتها', () => {
    const { report } = buildContractAuditReport(base());
    const grid = of(report.blocks, 'grid').find((g) => g.columns[0] === 'المحور')!;
    expect(grid.columns).toEqual(['المحور', 'الحالة', 'ما رُصد فى العقد', 'موقفك التفاوضى']);
    expect(grid.rows).toHaveLength(7);
    const rent = grid.rows.find((r) => r[0].text === 'الأجرة وموعد سدادها وزيادتها')!;
    expect(rent[1]).toMatchObject({ text: 'فيه ما يميل ضد موقفك', tone: 'critical' });
    expect(rent[2].text).toContain('«الأجرة: القيمة الإيجارية الشهرية 20000 جنيه.');
    expect(rent[2].text).toContain('بالنسبة التى يقدرها.»');
    expect(rent[2].text).toContain('\nملاحظة المنصة (ليست من نص العقد):');
    expect(rent[3].text).toMatch(/^الأفضل: .*\nالبديل: .*\nالخط الأحمر: /s);
    const deposit = grid.rows.find((r) => r[0].text.startsWith('التأمين'))!;
    expect(deposit[1]).toMatchObject({ text: 'لم يُرصد', tone: 'high' });
    expect(deposit[2].text).toMatch(/^لم يُرصد نص فى العقد المرفوع\.\nملاحظة المنصة \(ليست من نص العقد\): /);
    const term = grid.rows.find((r) => r[0].text.startsWith('المدة'))!;
    expect(term[1]).toMatchObject({ text: 'مرصود', tone: 'medium' });
  });

  it('السند القانونى يُذكر للمحاور الملحوظة فقط وبأرقام مواد من البيانات المحقَّقة', () => {
    const { report } = buildContractAuditReport(base());
    const idx = report.blocks.findIndex((b) => b.t === 'h3' && b.text === 'السند القانونى للمحاور الملحوظة');
    expect(idx).toBeGreaterThan(-1);
    const bullets = report.blocks[idx + 1] as Extract<RBlock, { t: 'bullets' }>;
    expect(bullets.t).toBe('bullets');
    expect(bullets.items.some((x) => x.includes('المادة 562') && x.includes('القانون المدنى (131 لسنة 1948): المادة 562'))).toBe(true);
    // المحور «مرصود» بلا ملاحظة لا سند له فى هذه القائمة (المدة والتجديد: 563/598/599)
    expect(bullets.items.some((x) => x.startsWith('المدة والتجديد'))).toBe(false);
  });

  it('صفة العميل غير محددة: موقفا الطرفين وملاحظة توضيحية، والعنوان بلا «من منظور»', () => {
    const { report } = buildContractAuditReport(base({ clientRole: null }));
    const banner = bannerTexts(report.blocks).find((b) => b.includes('الدليل التفاوضى'))!;
    expect(banner).toMatch(/عقد إيجار$/);
    const notes = of(report.blocks, 'note');
    expect(notes.some((n) => n.label === 'صفة العميل غير محددة:')).toBe(true);
    const grid = of(report.blocks, 'grid').find((g) => g.columns[0] === 'المحور')!;
    expect(grid.columns[3]).toBe('المواقف التفاوضية');
    expect(grid.rows[0][3].text).toContain('المؤجر:');
    expect(grid.rows[0][3].text).toContain('المستأجر:');
    const rent = grid.rows.find((r) => r[0].text.startsWith('الأجرة'))!;
    expect(rent[2].text).toContain('يضر بـالمستأجر');
  });

  it('لا يظهر لنوع غير مدعوم أو بلا نوع أو بلا بنود', () => {
    for (const over of [
      { contractType: 'عقد رهن', clientRole: 'الراهن' },
      { contractType: null, clientRole: null },
      { clauses: [] },
    ] as Array<Partial<AuditReportInput>>) {
      const { report } = buildContractAuditReport(base(over));
      expect(bannerTexts(report.blocks).some((b) => b.includes('الدليل التفاوضى'))).toBe(false);
    }
  });

  it('عرض فقط: لا يغيّر مستوى المخاطرة العام ولا عدد البنود ولا الغلاف', () => {
    const withPb = buildContractAuditReport(base()).report;
    const without = buildContractAuditReport(base({ contractType: 'عقد رهن', clientRole: 'الراهن' })).report;
    const level = (r: typeof withPb) => r.cover.rows.find((x) => x.label === 'مستوى المخاطرة العام');
    expect(level(withPb)).toEqual(level(without));
  });

  it('يُرسم فى PDF/HTML وWord دون خطأ، ويُهرَّب فيه النص', () => {
    const { report } = buildContractAuditReport(base({ clauses: [clause(1, 'الأجرة: <script>alert(1)</script> وللمؤجر زيادة الأجرة سنوياً بالنسبة التى يقدرها.')] }));
    const html = renderAuditHtml(report, 'ت');
    expect(html).toContain('الدليل التفاوضى');
    expect(html).not.toContain('<script>alert');
    const parts = auditDocxParts(report);
    expect(parts).toBeDefined();
  });

  it('أقسام النقل: عقد عمل وبيع وخدمات تُنتج أقسامها بأسماء الصفات الصحيحة', () => {
    const cases: Array<[string, string, string]> = [
      ['عقد عمل', 'العامل', 'عقد عمل من منظور العامل'],
      ['عقد بيع', 'البائع', 'عقد بيع من منظور البائع'],
      ['عقد خدمات أو مقاولة أو توريد', 'مقدم الخدمة (المقاول / المورد)', 'من منظور مقدم الخدمة (المقاول / المورد)'],
    ];
    for (const [type, role, expected] of cases) {
      const { report } = buildContractAuditReport(base({ contractType: type, clientRole: role }));
      const banner = bannerTexts(report.blocks).find((b) => b.includes('الدليل التفاوضى'))!;
      expect(banner).toContain(expected);
    }
  });
});
