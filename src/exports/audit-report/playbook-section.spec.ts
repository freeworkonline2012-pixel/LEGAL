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
      ['عقد شراكة أو استثمار', 'الشريك المستثمر', 'الإدارة: ينفرد الشريك المدير بإدارة المشروع ويتخذ جميع القرارات دون الرجوع إلى المستثمر.', 'عقد شراكة أو استثمار من منظور الشريك المستثمر', 9],
      ['عقد تمويل أو قرض', 'المقترض (المدين)', 'الفائدة: يسدد المقترض فائدة سنوية قدرها 18 % من رصيد القرض.', 'عقد تمويل أو قرض من منظور المقترض (المدين)', 7],
      ['عقد وكالة أو سمسرة أو تسويق', 'الوكيل أو السمسار', 'العمولة: للموكل خصم أى مبالغ من العمولة المستحقة للوكيل.', 'عقد وكالة أو سمسرة أو تسويق من منظور الوكيل أو السمسار', 7],
      ['عقد ترخيص أو امتياز تجارى', 'المرخَّص له', 'المقابل: يسدد المرخص له رسوم دخول غير قابلة للاسترداد.', 'عقد ترخيص أو امتياز تجارى من منظور المرخَّص له', 8],
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

describe('الإحالة من محور الدليل إلى «ملاحظات العقد ككل» (منع الازدواج)', () => {
  const SERVICES = [clause(1, 'نطاق الخدمات: يطور الطرف الثانى برمجيات ونظم معلومات للطرف الأول ويسلمها بعد الاختبار.')];
  const svc = (findings?: Array<{ id: string; title: string }>) =>
    base({
      contractType: 'عقد خدمات أو مقاولة أو توريد',
      clientRole: 'العميل',
      clauses: SERVICES,
      contractFindings: findings?.map((f) => ({ id: f.id, kind: 'missing_clause', kindLabel: 'بند غير مرصود', severity: 'متوسط', title: f.title, explanation: 'ش', suggestion: null, evidence: [] })),
    });
  const cellOf = (blocks: RBlock[], label: string): string => {
    const g = of(blocks, 'grid').find((x) => x.columns[0] === 'المحور')!;
    const row = g.rows.find((r) => r[0].text.includes(label))!;
    return row[2].text;
  };

  it('المحور غير المرصود الذى سبقت الملاحظة عليه يُحيل إلى رقمها ويُبقى الأثر القانونى', () => {
    const { report } = buildContractAuditReport(svc([{ id: 'missing:delay_penalty', title: 'لم يُرصد بند يتناول: جزاء التأخير' }]));
    const t = cellOf(report.blocks, 'غرامات التأخير');
    expect(t).toContain('سبق التنبيه إليه');
    expect(t).toContain('(ع1)');
    expect(t).toContain('ملاحظة المنصة');
  });

  it('بلا ملاحظة سابقة لا إحالة', () => {
    const { report } = buildContractAuditReport(svc());
    expect(cellOf(report.blocks, 'غرامات التأخير')).not.toContain('سبق التنبيه إليه');
  });

  it('الرقم يتبع ترتيب الجدول فى «ملاحظات العقد ككل» لا ترتيب التخزين', () => {
    const { report } = buildContractAuditReport(svc([{ id: 'open:x', title: 'شرط مفتوح' }, { id: 'missing:acceptance', title: 'لم يُرصد بند يتناول: القبول' }]));
    expect(cellOf(report.blocks, 'التسليم والقبول')).toContain('(ع2)');
  });

  it('بلا نوع ولا طرف عند الرفع: يُبنى الدليل بالنوع المستنتج من العنوان محايداً مع تنبيه صريح (R58)', () => {
    const { report } = buildContractAuditReport(
      base({
        contractType: null,
        clientRole: null,
        inferredContractType: 'عقد عمل',
        clauses: [clause(1, 'الأجر: الأجر الشهرى 12000 جنيه شاملاً جميع البدلات والعمل الإضافى، ولصاحب العمل خفضه إذا اقتضت ظروف الشركة.')],
      }),
    );
    const banners = bannerTexts(report.blocks);
    expect(banners.some((b) => b.endsWith('الدليل التفاوضى — عقد عمل'))).toBe(true);
    const notes = of(report.blocks, 'note').map((n) => n.text).join(' ');
    expect(notes).toContain('استُنتج من عنوانه');
    expect(notes).toContain('الدليل محايد');
  });

  it('بلا نوع وبلا نوع مستنتج: لا دليل (السلوك السابق)', () => {
    const { report } = buildContractAuditReport(base({ contractType: null, clientRole: null }));
    expect(bannerTexts(report.blocks).some((b) => b.includes('الدليل التفاوضى'))).toBe(false);
  });

  it('نوع محدد وطرف محدد: لا تنبيه استنتاج ولا حياد', () => {
    const { report } = buildContractAuditReport(base());
    const notes = of(report.blocks, 'note').map((n) => n.text).join(' ');
    expect(notes).not.toContain('استُنتج من عنوانه');
    expect(notes).not.toContain('الدليل محايد');
  });
});

describe('اختلالات الدليل التفاوضى فى مصفوفة المخاطر (الجولة 58)', () => {
  const PRT = [
    clause(1, 'رأس المال: يقدم الشريك الأول مبلغ مائة ألف جنيه ويقدم الشريك الثانى عمله فقط.'),
    clause(2, 'الخسائر: تقع الخسائر كلها على الشريك الأول وحده ولا يتحمل الشريك الثانى منها شيئاً.'),
  ];
  it('محور بطلان صريح يظهر فى جدول مستقل بنوع «يستند إلى نص آمر» ولا يغيّر الأعداد ولا المستوى العام', () => {
    const plain = buildContractAuditReport(base({ contractType: 'عقد شركة', clientRole: null, clauses: PRT })).report;
    const grids = of(plain.blocks, 'grid');
    const g = grids.find((x) => x.columns[1] === 'الاختلال');
    expect(g).toBeDefined();
    expect(g!.rows[0][4].text).toBe('يستند إلى نص آمر — يلزم التحقق');
    expect(g!.rows[0][3].text).toBe('البند 2');
    expect(JSON.stringify(plain.blocks)).toContain('لا تدخل فى أعداد المخاطر');
    // لا بند مقيَّم ⇒ لا صف فى مصفوفة المخاطر الأساسية
    expect(grids.find((x) => x.columns[1] === 'وصف المخاطرة')).toBeUndefined();
  });
  it('عقد بلا اختلال أولويته عالية ⇒ لا جدول', () => {
    const { report } = buildContractAuditReport(base({ clauses: [clause(1, 'موضوع العقد تأجير الوحدة السكنية الكائنة بالقاهرة للسكنى.')] }));
    expect(of(report.blocks, 'grid').some((x) => x.columns[1] === 'الاختلال')).toBe(false);
  });
});
