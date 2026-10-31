import { type AuditClause, type AuditReportInput, buildContractAuditReport } from './build';
import { renderAuditHtml } from './html';
import { auditDocxParts } from './docx';
import type { RBlock } from './model';
import { renderDocx } from '../renderers/docx.renderer';
import { buildContractDocument } from '../builders/contract-document.builder';

const NOW = new Date('2026-10-19T10:00:00Z');
const art = (no: number, snippet: string, url: string | null = 'https://www.example.gov.eg/law') => ({
  law: 'القانون المدنى',
  law_no: 131,
  law_year: 1948,
  article_no: no,
  snippet,
  official_url: url,
});

function clause(over: Partial<AuditClause> & { clauseIndex: number }): AuditClause {
  return {
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
  };
}

const CLAUSES: AuditClause[] = [
  clause({ clauseIndex: 1, assessmentStatus: 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة', assessmentReasoning: 'لا يوجد نص.' }),
  clause({ clauseIndex: 2, clauseTitle: 'مدة العقد', assessmentStatus: 'يحتاج مراجعة', riskLevel: 'عالٍ', assessmentReasoning: 'يخرج عن القاعدة. يلزم نظر محامٍ.', matchedArticles: [art(604, 'تاريخ ثابت سابق على البيع.')],
    suggestedWording: JSON.stringify({ text: 'نص مقترح للبند الثانى.', changes: ['أُضيف التزام المؤجر.'] }) }),
  clause({ clauseIndex: 3, assessmentStatus: 'سليم', matchedArticles: [art(558, 'الإيجار عقد.', 'javascript:alert(1)')] }),
  clause({ clauseIndex: 4, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'حرج', assessmentReasoning: 'يخالف نصاً آمراً.', matchedArticles: [art(224, 'يقع باطلاً كل اتفاق يخالف ذلك.')], suggestedWording: JSON.stringify({ noChange: true, note: 'يلزم نظر محامٍ.' }) }),
  clause({ clauseIndex: 5, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'متوسط', assessmentReasoning: 'يلزم تحديد المدة.', matchedArticles: [art(148, 'حسن النية.')] }),
  clause({ clauseIndex: 6, assessmentStatus: 'يحتاج مراجعة', riskLevel: null, assessmentReasoning: 'تعذَّر التقييم.' }),
];

const INPUT: AuditReportInput = {
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
};

const of = <T extends RBlock['t']>(blocks: RBlock[], t: T) => blocks.filter((b) => b.t === t) as Array<Extract<RBlock, { t: T }>>;

describe('buildContractAuditReport', () => {
  const { report, reference } = buildContractAuditReport(INPUT);

  it('تحذيرات الاستخراج المحفوظة تظهر فى الغلاف ثم فى أول الملخص، وغيابها لا يضيف شيئاً', () => {
    const none = buildContractAuditReport(INPUT).report;
    expect(none.cover.rows.some((r) => r.label === 'تنبيه الاستخراج')).toBe(false);
    expect(of(none.blocks, 'note').some((n) => n.label === 'تنبيه الاستخراج:')).toBe(false);

    const w = 'قُرئ هذا العقد آلياً من صور ممسوحة ضوئياً (OCR).';
    const { report: r } = buildContractAuditReport({ ...INPUT, extractionWarnings: [w, '  '] });
    expect(r.cover.rows.some((x) => x.label === 'تنبيه الاستخراج')).toBe(true);
    const notes = of(r.blocks, 'note').filter((n) => n.label === 'تنبيه الاستخراج:');
    expect(notes.map((n) => n.text)).toEqual([w]);
    const bannerIdx = r.blocks.findIndex((b) => b.t === 'banner');
    // أول الملخص: نطاق التغطية ثم تنبيه الاستخراج
    expect(r.blocks[bannerIdx + 1]).toMatchObject({ t: 'note', label: 'نطاق التغطية:' });
    expect(r.blocks[bannerIdx + 2]).toEqual({ t: 'note', label: 'تنبيه الاستخراج:', text: w });
  });

  it('ملاحظات العقد ككل: لا قسم بدونها، ومع وجودها قسم مرقَّم بجدول وتفصيل واقتباسات، وملاحظة نطاق إن تعذّر فحص التعارض', () => {
    expect(JSON.stringify(buildContractAuditReport(INPUT).report.blocks)).not.toContain('ملاحظات على العقد ككل');
    const finding = {
      kind: 'open_term',
      kindLabel: 'شرط مفتوح',
      severity: 'عالٍ',
      title: 'مقابل مالى يُترك تحديده إلى وقت لاحق',
      explanation: 'يُحدَّد المبلغ لاحقاً دون آلية.',
      suggestion: 'تحديد السقف.',
      evidence: [{ clauseLabel: 'البند السادس', quote: 'تحدد رسوم الاستضافة بعد انتهاء التنفيذ' }],
    };
    const { report: r } = buildContractAuditReport({ ...INPUT, contractFindings: [finding], contractFindingsModel: 'error' });
    const banners = of(r.blocks, 'banner').map((b) => b.text);
    expect(banners.some((t) => /^\d+\. ملاحظات على العقد ككل$/.test(t))).toBe(true);
    const json = JSON.stringify(r.blocks);
    expect(json).toContain('تحدد رسوم الاستضافة بعد انتهاء التنفيذ');
    expect(json).toContain('تعذّر إتمام فحص التعارض');
    const empty = buildContractAuditReport({ ...INPUT, contractFindings: [], contractFindingsModel: 'ok' }).report;
    expect(JSON.stringify(empty.blocks)).toContain('لم تُرصد ملاحظات على مستوى العقد ككل');
  });

  it('التحقق المستقل: غير المؤكدة تُوسَم فى المصفوفة والتفصيل ومعها السبب والاقتباس، والمؤكدة تُذكر باجتيازها', () => {
    const withV = INPUT.clauses.map((c) =>
      c.clauseIndex === 5
        ? { ...c, verification: { status: 'unconfirmed' as const, reason: 'البند يعفى صراحة من الإنذار.', quote: 'دون حاجة إلى إنذار' } }
        : c.clauseIndex === 2
          ? { ...c, verification: { status: 'confirmed' as const, reason: 'لم أجد ما ينقض الملاحظة.', quote: null } }
          : c,
    );
    const json = JSON.stringify(buildContractAuditReport({ ...INPUT, clauses: withV }).report.blocks);
    expect(json).toContain('غير مؤكدة');
    expect(json).toContain('تحتاج مراجعة بشرية');
    expect(json).toContain('دون حاجة إلى إنذار');
    expect(json).toContain('اجتازت التحقق المستقل');
    expect(JSON.stringify(buildContractAuditReport(INPUT).report.blocks)).not.toContain('التحقق المستقل');
  });

  it('نطاق التغطية: يذكر عدد البنود المقيَّمة مقابل نص مفهرس ويحذّر من أن غير المقيَّمة لم تُراجَع', () => {
    const { report: r } = buildContractAuditReport(INPUT);
    const assessed = INPUT.clauses.filter((c) => c.assessmentStatus === 'سليم' || c.assessmentStatus === 'يحتاج مراجعة').length;
    const row = r.cover.rows.find((x) => x.label === 'نطاق التغطية')!;
    expect(row.value).toBe(`${assessed} من ${INPUT.clauses.length} بنداً قُيِّمت مقابل نصوص قانونية مفهرسة`);
    const note = of(r.blocks, 'note').find((n) => n.label === 'نطاق التغطية:');
    expect(note?.text).toContain('لا يعنى سلامتها');
  });

  it('عقد مقروء آلياً: رموز مشوَّهة فى بند تُنبَّه فى التفصيل وفى الصياغة، وبدونه لا تنبيه', () => {
    const noisy = INPUT.clauses.map((c) => (c.clauseIndex === 2 ? { ...c, clauseText: 'إخلال الطرف الأول WL من إلتزاماته' } : c));
    const ocr = buildContractAuditReport({ ...INPUT, clauses: noisy, extractionWarnings: ['قُرئ هذا العقد آلياً (OCR).'] }).report;
    expect(JSON.stringify(ocr.blocks)).toContain('«WL»');
    const plain = buildContractAuditReport({ ...INPUT, clauses: noisy }).report;
    expect(JSON.stringify(plain.blocks)).not.toContain('«WL»');
  });

  it('الطرف الذى هو العميل يظهر فى الغلاف والملخص إن حُدِّد، وبدونه تبقى الصفة وحدها', () => {
    const base = { ...INPUT, clientRole: 'طالب الخدمة (صاحب العمل / العميل)' };
    const withParty = buildContractAuditReport({ ...base, clientParty: 'second' }).report;
    expect(withParty.cover.rows.find((r) => r.label === 'منظور التدقيق (العميل)')?.value).toBe('طالب الخدمة (صاحب العمل / العميل) — الطرف الثانى فى نص العقد');
    expect(JSON.stringify(withParty.blocks)).toContain('الطرف الثانى فى نص العقد');
    const without = buildContractAuditReport(base).report;
    expect(without.cover.rows.find((r) => r.label === 'منظور التدقيق (العميل)')?.value).toBe('طالب الخدمة (صاحب العمل / العميل)');
  });

  it('الملخص يستعمل عدد البنود الحقيقى (بلا النص غير المُقسَّم) ويذكره على حدة، ونحو سليم للمفرد', () => {
    const unseg = clause({ clauseIndex: 1, clauseLabel: 'نص سابق لـالبند الرابع (غير مُقسَّم)', assessmentStatus: 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة' });
    const one = [unseg, clause({ clauseIndex: 2, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'متوسط', assessmentReasoning: 'يلزم نظر.', matchedArticles: [art(148, 'حسن النية.')] }), clause({ clauseIndex: 3 })];
    const { report: r } = buildContractAuditReport({ ...INPUT, clauses: one });
    const text = JSON.stringify(r.blocks);
    expect(text).toContain('بند واحد يحتاج مراجعة من أصل بندان');
    expect(text).toContain('نص سابق لأول بند مُتعرَّف عليه لم يُقسَّم');
  });

  it('عدد البنود فى الغلاف لا يحسب النص غير المُقسَّم بنداً', () => {
    const unseg = clause({ clauseIndex: 1, clauseLabel: 'نص سابق لـالبند الرابع (غير مُقسَّم)', assessmentStatus: null });
    const { report: r } = buildContractAuditReport({ ...INPUT, clauses: [unseg, ...INPUT.clauses.map((c) => ({ ...c, clauseIndex: c.clauseIndex + 1 }))] });
    const row = r.cover.rows.find((x) => x.label === 'عدد البنود')!;
    expect(row.value).toBe(`${INPUT.clauses.length} + نص سابق غير مُقسَّم`);
  });

  it('الأقسام بترتيب التقرير المعتمد وبأرقام متسلسلة', () => {
    const banners = of(report.blocks, 'banner').map((b) => b.text);
    expect(banners).toEqual([
      '1. الملخص التنفيذى',
      '2. الشروط الرئيسية للعقد',
      '3. مصفوفة تحليل المخاطر',
      '4. التقييم التفصيلى للمخاطر',
      '5. الدليل التفاوضى — عقد إيجار من منظور المستأجر',
      '6. النسخة الاحترافية المُعدَّلة للبنود',
      '7. توصيات التنفيذ والجدول الزمنى للتفاوض',
      '8. الإطار القانونى والتشريعى المرجعى',
      '9. إخلاء المسؤولية',
      '10. الذيول المرجعية للمواد القانونية',
      '11. قسم التوقيعات واعتماد التقرير',
    ]);
  });

  it('الغلاف: عنوان وأسطر المعلومات ومستوى المخاطرة العام بحسب أعلى درجة', () => {
    expect(report.cover.subtitle).toBe('تحليل قانونى احترافى متكامل — إطار القانون المصرى');
    const labels = report.cover.rows.map((r) => r.label);
    expect(labels).toEqual(['موضوع العقد', 'ملف العقد', 'منظور التدقيق (العميل)', 'القانون الحاكم', 'عدد البنود', 'نطاق التغطية', 'تاريخ التقرير', 'حالة التقرير', 'مستوى المخاطرة العام']);
    const overall = report.cover.rows.at(-1)!;
    expect(overall.tone).toBe('critical');
    expect(overall.value).toContain('يستوجب التفاوض الفوري');
  });

  it('المصفوفة مرتبة بالخطورة ثم رقم البند، والبند غير المصنَّف يظهر بدرجة محايدة', () => {
    const grid = of(report.blocks, 'grid').find((g) => g.columns[1] === 'وصف المخاطرة')!;
    expect(grid.columns).toEqual(['#', 'وصف المخاطرة', 'الدرجة', 'البند', 'الحالة']);
    expect(grid.rows.map((r) => [r[2].text, r[3].text])).toEqual([
      ['حرج', 'البند 4'],
      ['عالٍ', 'البند 2'],
      ['متوسط', 'البند 5'],
      ['غير مصنَّف', 'البند 6'],
    ]);
    expect(grid.rows[3][2].tone).toBe('grey');
  });

  it('شريط الإحصاءات بصرف عددى صحيح', () => {
    const strip = of(report.blocks, 'strip')[0];
    expect(strip.cells.map((c) => c.text)).toEqual(['1 بند متوسط', '1 بند عالٍ', '1 بند حرج', '4 بنود مراجعة']);
  });

  it('التفصيل يعرض المشكلة والأساس القانونى بنص المادة المعتمدة والخطر المشتق من الدرجة', () => {
    const kv = of(report.blocks, 'kv')[0];
    expect(kv.rows.map((r) => r.label)).toEqual(['المشكلة', 'الأساس القانونى', 'الخطر القانونى']);
    expect(kv.rows[1].value).toContain('المادة 224 من القانون المدنى رقم 131 لسنة 1948');
    expect(kv.rows[2].value).toContain('نصاً آمراً');
  });

  it('الصياغة المعدّلة تظهر للبند الذى وُلِّدت له فقط، مع تعليقها، وبند «لا يلزم تعديل» ملاحظة', () => {
    const cmp = of(report.blocks, 'compare');
    expect(cmp).toHaveLength(1);
    expect(cmp[0].modified).toBe('نص مقترح للبند الثانى.');
    expect(of(report.blocks, 'commentary')[0].text).toContain('أُضيف التزام المؤجر.');
    expect(of(report.blocks, 'p').some((p) => p.text.includes('لا يلزم تعديل هذا البند'))).toBe(true);
  });

  it('التوصيات: أولوية وجدول زمنى بحسب الدرجة، وملاحظة تفاوضية عند وجود حرج', () => {
    const recs = of(report.blocks, 'grid').find((g) => g.columns[1] === 'الإجراء المطلوب')!;
    expect(recs.rows[0].map((c) => c.text).slice(2, 5)).toEqual(['حرجة', 'فوري — قبل التوقيع', 'شرط مانع للتوقيع']);
    expect(of(report.blocks, 'p').some((p) => p.text.startsWith('ملاحظة تفاوضية') && p.text.includes('(1)'))).toBe(true);
  });

  it('لا يختلق أقساماً: بلا تقدير مالى ولا أحكام نقض ولا معايير صناعية', () => {
    const all = JSON.stringify(report.blocks) + JSON.stringify(report.cover);
    for (const forbidden of ['USD', 'ISO/IEC', 'محكمة النقض', 'التقدير الكمي', 'دولار']) expect(all).not.toContain(forbidden);
  });

  it('الذيول: رابط غير http(s) يسقط، والمواد مرتبة بلا تكرار', () => {
    const grids = of(report.blocks, 'grid');
    const appendix = grids.find((g) => g.columns[0] === 'المصدر الرسمى')!;
    expect(appendix.rows.map((r) => r[2].text)).toEqual(['م. 148', 'م. 224', 'م. 558', 'م. 604']);
    const row558 = appendix.rows.find((r) => r[2].text === 'م. 558')!;
    expect(row558[0].link).toBeNull();
    expect(appendix.rows.find((r) => r[2].text === 'م. 604')![0].link).toBe('https://www.example.gov.eg/law');
  });

  it('الجولة 32: قانون بلا رابط رسمى لأى مادة ⇒ يُحذف عمود «المصدر الرسمى» بدل تكرار «غير متاح»', () => {
    const grids = of(report.blocks, 'grid').filter((g) => g.columns.includes('المادة'));
    expect(grids.length).toBeGreaterThan(0);
    const noLink = buildContractAuditReport({
      ...INPUT,
      clauses: CLAUSES.map((c) => ({ ...c, matchedArticles: (c.matchedArticles ?? []).map((a) => ({ ...a, official_url: null })) })),
    }).report;
    const g = of(noLink.blocks, 'grid').filter((x) => x.columns.includes('المادة'));
    expect(g.length).toBeGreaterThan(0);
    for (const x of g) {
      expect(x.columns).toEqual(['الموضوع', 'المادة']);
      expect(JSON.stringify(x.rows)).not.toContain('غير متاح');
    }
  });

  it('بصمة التحقق حتمية: نفس البيانات نفس البصمة، وتغيّر بتغيّر المحتوى', () => {
    const digest = (r: typeof report) => of(r.blocks, 'idtable')[0].rows[1].value;
    expect(digest(report)).toMatch(/^[0-9A-F]{64}$/);
    expect(digest(buildContractAuditReport(INPUT).report)).toBe(digest(report));
    const changed = buildContractAuditReport({ ...INPUT, clauses: [...CLAUSES, clause({ clauseIndex: 7 })] }).report;
    expect(digest(changed)).not.toBe(digest(report));
    expect(of(report.blocks, 'idtable')[0].rows[0].value).toBe(`CRA-${reference.slice(4)}`);
  });

  it('عقد بلا بنود تحتاج مراجعة: مستوى منخفض وأقسام التفصيل تقول ذلك دون جداول فارغة', () => {
    const r = buildContractAuditReport({ ...INPUT, clauses: [clause({ clauseIndex: 1 })] }).report;
    expect(r.cover.rows.at(-1)!.tone).toBe('info');
    expect(of(r.blocks, 'kv')).toHaveLength(0);
    expect(of(r.blocks, 'p').some((p) => p.text.includes('لا توجد بنود تحتاج مراجعة'))).toBe(true);
  });

  it('معتمد: بلا علامة مائية ويحمل تاريخ الاعتماد وملاحظة المراجع', () => {
    const r = buildContractAuditReport({ ...INPUT, approvedAt: NOW, approvalNote: 'تمت المراجعة' }).report;
    expect(r.watermark).toBeNull();
    expect(r.cover.rows.find((x) => x.label === 'حالة التقرير')!.value).toBe('معتمد بعد مراجعة بشرية');
    expect(JSON.stringify(r.blocks)).toContain('ملاحظة المراجع: تمت المراجعة');
  });
});

describe('مُخرِجا تقرير التدقيق', () => {
  const doc = buildContractDocument(INPUT);

  it('HTML: الأقسام والألوان والترويسة والتذييل، وكل نص مُهرَّب', () => {
    const hostile = buildContractAuditReport({ ...INPUT, originalFilename: '<script>alert(1)</script>.docx' }).report;
    const html = renderAuditHtml(hostile, 'ت');
    expect(html).not.toContain('<script>alert');
    expect(html).toContain('&lt;script&gt;');
    const ok = renderAuditHtml(doc.audit!, 'ت');
    expect(ok).toContain('1. الملخص التنفيذى');
    expect(ok).toContain('#FCE4D6');
    expect(ok).toContain('@top-center');
    expect(ok).toContain('صفحة " counter(page) " من " counter(pages)');
    expect(ok).toContain("Content-Security-Policy");
    expect(ok).not.toContain('javascript:');
  });

  it('Word: ملف docx صالح (أرشيف zip) يحوى الغلاف وكل الأقسام', async () => {
    const buf = await renderDocx(doc);
    expect(buf.subarray(0, 2).toString()).toBe('PK');
    const parts = auditDocxParts(doc.audit!);
    expect(parts.children.length).toBeGreaterThan(30);
  });
});

describe('الجولة 6: الملخص التنفيذى وسجل المخاطر وجدول الشروط', () => {
  const finding = (over: Record<string, unknown> = {}) => ({
    kind: 'conflict',
    kindLabel: 'تعارض محتمل',
    severity: 'حرج',
    title: 'بند يُبقى الملكية للمورد وآخر ينقلها للعميل',
    explanation: 'تعارض بين البندين.',
    suggestion: 'توحيد الحكم.',
    evidence: [
      { clauseLabel: 'البند 2', quote: 'تبقى الملكية للطرف الأول' },
      { clauseLabel: 'البند 5', quote: 'تنتقل الملكية للطرف الثانى' },
    ],
    ...over,
  });
  const quiet = [clause({ clauseIndex: 1 }), clause({ clauseIndex: 2 })];
  const base: AuditReportInput = { ...INPUT, clauses: quiet };
  const gridBy = (r: { blocks: RBlock[] }, col: string) => of(r.blocks, 'grid').find((g) => g.columns.includes(col));

  it('أهم ما يستوجب الانتباه: الأخطر أولاً من البنود والملاحظات معاً، بحد أقصى خمسة، والتوصية بحسب الأخطر', () => {
    const { report: r } = buildContractAuditReport({ ...INPUT, contractFindings: [finding()], contractFindingsModel: 'ok' });
    const top = gridBy(r, 'الملاحظة')!;
    expect(top.rows.length).toBeLessThanOrEqual(5);
    expect(top.rows.map((x) => x[3].text)).toEqual(['حرج', 'حرج', 'عالٍ']);
    expect(top.rows[0][1].text).toBe('البند 4'); // البنود قبل ملاحظات العقد عند تساوى الدرجة
    expect(top.rows[1][1].text).toBe('البند 2، البند 5');
    const note = of(r.blocks, 'note').find((n) => n.label === 'توصية:')!;
    expect(note.text).toContain('لا يُوصى بالتوقيع قبل معالجة الملاحظات الحرجة');
  });

  it('عقد بلا ملاحظات: لا جدول «أهم ما يستوجب الانتباه» والتوصية تُبقى مراجعة المحامى شرطاً', () => {
    const { report: r } = buildContractAuditReport(base);
    expect(gridBy(r, 'الملاحظة')).toBeUndefined();
    expect(of(r.blocks, 'note').find((n) => n.label === 'توصية:')!.text).toContain('تبقى مراجعة المحامى شرطاً قبل التوقيع');
  });

  it('ملاحظة عقد حرجة مؤكَّدة ترفع المستوى العام، وغير المؤكدة لا ترفعه ولا تبنى عليها التوصية', () => {
    const confirmed = buildContractAuditReport({ ...base, contractFindings: [finding({ verification: { status: 'confirmed', reason: 'ثابتة' } })] }).report;
    expect(confirmed.cover.rows.at(-1)!.tone).toBe('critical');
    const unconfirmed = buildContractAuditReport({ ...base, contractFindings: [finding({ verification: { status: 'unconfirmed', reason: 'محتملة' } })] }).report;
    expect(unconfirmed.cover.rows.at(-1)!.tone).toBe('info');
    const note = of(unconfirmed.blocks, 'note').find((n) => n.label === 'توصية:')!;
    expect(note.text).not.toContain('لا يُوصى بالتوقيع');
    expect(note.text).toContain('غير مؤكدة');
    expect(JSON.stringify(unconfirmed.blocks)).toContain('(غير مؤكدة)');
  });

  it('الجولة 34: الملاحظة غير المؤكدة لا تتصدر «أهم ما يستوجب الانتباه» ولا تُخلط بالمؤكدة: تُعرض فى قسم «مرشّحات» بدرجة رمادية وسبب عدم التأكيد', () => {
    const unconf = finding({ title: 'ملاحظة اعترض عليها المدقق', verification: { status: 'unconfirmed', reason: 'لا تعارض' } });
    const { report: r } = buildContractAuditReport({ ...INPUT, contractFindings: [unconf], contractFindingsModel: 'ok' });
    const top = gridBy(r, 'الملاحظة')!;
    expect(JSON.stringify(top.rows)).not.toContain('ملاحظة اعترض عليها المدقق');
    expect(JSON.stringify(r.blocks)).toContain('لم تُدرج هنا 1 ملاحظة غير مؤكدة');
    const matrix = gridBy(r, 'وصف المخاطرة')!;
    expect(JSON.stringify(matrix.rows)).not.toContain('ملاحظة اعترض عليها المدقق');
    expect(of(r.blocks, 'sub').map((b) => b.text)).toContain('مرشّحات للمراجعة البشرية — غير مؤكدة');
    const cand = gridBy(r, 'سبب عدم التأكيد')!;
    expect(cand.rows).toHaveLength(1);
    expect(cand.rows[0][0].text).toBe('ع1');
    expect(cand.rows[0][1].text).toContain('ملاحظة اعترض عليها المدقق');
    expect(cand.rows[0][2]).toMatchObject({ text: 'حرج (مرشّحة)', tone: 'grey' });
    expect(cand.rows[0][4].text).toContain('لا تعارض');
  });

  it('الجولة 34: بند غير مؤكد لا يدخل أعداد المخاطر ولا المستوى العام، ويظهر مرشّحاً بإجراء تحقق', () => {
    const clauses = [
      clause({ clauseIndex: 1, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'حرج', assessmentReasoning: 'يخالف نصاً آمراً.', verification: { status: 'unconfirmed', reason: 'البند يعفى صراحة من الإنذار.', quote: 'دون حاجة إلى إنذار' } }),
      clause({ clauseIndex: 2, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'متوسط', assessmentReasoning: 'يلزم تحديد المدة.' }),
    ];
    const { report: r } = buildContractAuditReport({ ...INPUT, clauses });
    expect(r.cover.rows.at(-1)!.tone).toBe('medium'); // المتوسط المؤكد وحده؛ الحرج غير المؤكد لا يرفع المستوى
    const strip = of(r.blocks, 'strip')[0];
    expect(strip.cells.map((c) => c.text)).toEqual(['1 بند متوسط', '0 بنود عالية', '0 بنود حرجة', '1 بند للمراجعة']);
    expect(JSON.stringify(r.blocks)).toContain('ومعها مرشّحة واحدة للمراجعة البشرية');
    const matrix = gridBy(r, 'وصف المخاطرة')!;
    expect(matrix.rows.map((x) => x[3].text)).toEqual(['البند 2']);
    const cand = gridBy(r, 'سبب عدم التأكيد')!;
    expect(cand.rows[0][3].text).toBe('البند 1');
    expect(cand.rows[0][4].text).toContain('اقتباس المدقق: «دون حاجة إلى إنذار»');
    const actions = gridBy(r, 'الإجراء المطلوب')!;
    const texts = actions.rows.map((x) => x[1].text);
    expect(texts.some((t) => t.startsWith('مراجعة البند 2'))).toBe(true);
    const cRow = actions.rows.find((x) => x[1].text.includes('التحقق البشرى من مرشّحة غير مؤكدة: البند 1'))!;
    expect(cRow[2].text).toBe('متوسطة'); // مرشّحة حرجة الدرجة لا تضيع فى «منخفضة»
    expect(texts.some((t) => t.startsWith('مراجعة البند 1'))).toBe(false);
  });

  it('الجولة 34: جدول الدفعات يظهر بالمبالغ المحسوبة وفحص المجموع، ونسبة OCR المشكوك فيها تُوسَم وتُقارَن بالمتبقى', () => {
    const text = 'تبلغ قيمة العقد 1125000 جنيه مصرى. تسدد على ثلاث دفعات: الأولى 30% عند التوقيع، والثانية 30% عند التسليم، والباقى 40 96 مقابل القبول النهائى.';
    const { report: r } = buildContractAuditReport({ ...base, clauses: [clause({ clauseIndex: 2, clauseTitle: 'المقابل', clauseText: text })] });
    const g = gridBy(r, 'المبلغ المحسوب')!;
    expect(g.rows.map((x) => x.map((c) => c.text))).toEqual([
      ['الدفعة 1', '30%', '337,500 جنيه'],
      ['الدفعة 2', '30%', '337,500 جنيه'],
      ['الدفعة 3', '40% (؟ يلزم التحقق)', '450,000 جنيه'],
      ['المجموع', '100%', '1,125,000 جنيه'],
    ]);
    const note = of(r.blocks, 'note').find((n) => n.label === 'فحص المجموع:')!;
    expect(note.text).toContain('تساوى المتبقى');
    expect(note.text).toContain('أكبر مبلغ ورد فى البند');
    // ملاحظة المنصة منفصلة عن الاقتباس الحرفى فى جدول الشروط
    const terms = gridBy(r, 'من نص العقد')!;
    expect(terms.rows.some((x) => x[1].text === '30% — ترد 2 مرات فى النص')).toBe(true);
    expect(terms.rows.some((x) => x[3].text.includes('\nملاحظة المنصة (ليست من نص العقد):'))).toBe(true);
  });

  it('الجولة 34: دفعات مجموعها لا يبلغ 100% تُنبَّه ولا تغيّر مستوى المخاطرة', () => {
    const text = 'قيمة العقد 100000 جنيه. تسدد الأولى 30% عند التوقيع والثانية 30% عند التسليم.';
    const { report: r } = buildContractAuditReport({ ...base, clauses: [clause({ clauseIndex: 1, clauseText: text })] });
    const note = of(r.blocks, 'note').find((n) => n.label === 'فحص المجموع:')!;
    expect(note.text).toContain('مجموع النسب 60% وليس 100%');
    expect(r.cover.rows.at(-1)!.tone).toBe('info');
  });

  it('سجل المخاطر يضم ملاحظات العقد ككل بمعرّفات ع1، ع2 وبالموضع، ويتّسق ترقيمها فى قسمها', () => {
    const { report: r } = buildContractAuditReport({
      ...INPUT,
      contractFindings: [finding(), finding({ severity: 'متوسط', title: 'مدة غير محددة', evidence: [] })],
      contractFindingsModel: 'ok',
    });
    const matrix = gridBy(r, 'وصف المخاطرة')!;
    const tail = matrix.rows.slice(-2).map((x) => [x[0].text, x[2].text, x[3].text]);
    expect(tail).toEqual([['ع1', 'حرج', 'البند 2، البند 5'], ['ع2', 'متوسط', 'العقد ككل']]);
    const json = JSON.stringify(r.blocks);
    expect(json).toContain('ع1. بند يُبقى الملكية للمورد');
  });

  it('الجولة 32: التوصيات تضم الملاحظات المؤكدة على العقد ككل (بند ناقص) ولا تضم غير المؤكدة', () => {
    const missing = finding({ kind: 'missing_clause', severity: 'متوسط', title: 'لم يُرصد بند يتناول: جزاء التأخير', suggestion: 'نص يحدد الجزاء.', evidence: [], verification: { status: 'confirmed', reason: 'ثابتة' } });
    const unconf = finding({ kind: 'open_term', severity: 'عالٍ', title: 'شرط مفتوح: رسوم مفتوحة', evidence: [], verification: { status: 'unconfirmed', reason: 'محتملة' } });
    const { report: r } = buildContractAuditReport({ ...base, contractFindings: [missing, unconf], contractFindingsModel: 'ok' });
    const g = gridBy(r, 'الإجراء المطلوب')!;
    const json = JSON.stringify(g.rows);
    expect(json).toContain('إضافة بند يتناول: جزاء التأخير');
    // غير المؤكدة لا تصير إجراء تعديل («تحديد الشرط المفتوح») بل إجراء تحقق بشرى فقط
    expect(json).not.toContain('تحديد الشرط المفتوح');
    expect(json).toContain('التحقق البشرى من مرشّحة غير مؤكدة: شرط مفتوح: رسوم مفتوحة');
  });

  it('عقد بلا بنود مراجعة لكن بملاحظة عقد: السجل يظهر ولا يقول إنه لا توجد مخاطر', () => {
    const { report: r } = buildContractAuditReport({ ...base, contractFindings: [finding({ severity: 'عالٍ' })] });
    expect(gridBy(r, 'وصف المخاطرة')!.rows).toHaveLength(1);
    expect(JSON.stringify(r.blocks)).not.toContain('لا توجد بنود تحتاج مراجعة فى هذا العقد وفق النصوص المفهرسة.');
  });

  it('الشروط الرئيسية: جدول بالنوع والقيمة والبند والاقتباس الحرفى، وأرقام الحروف موسومة', () => {
    const text = 'إجمالى الثمن 600000 ( ستمائة ألف جنيه مصرى فقط ) يسدده الطرف الثانى. التسليم خلال تسعين يوماً من التعاقد.';
    const { report: r } = buildContractAuditReport({ ...base, clauses: [clause({ clauseIndex: 1, clauseTitle: 'الثمن', clauseText: text })] });
    expect(of(r.blocks, 'banner').map((b) => b.text)).toContain('2. الشروط الرئيسية للعقد');
    const g = gridBy(r, 'من نص العقد')!;
    expect(g.rows.map((x) => [x[0].text, x[1].text, x[2].text])).toEqual([
      ['مبلغ', '600,000 جنيه', 'البند 1'],
      ['مدة', '90 يوماً (بالحروف)', 'البند 1'],
    ]);
    for (const row of g.rows) expect(text.replace(/\s+/g, ' ')).toContain(row[3].text);
  });

  it('بلا أرقام فى العقد: القسم يقول ذلك دون جدول فارغ', () => {
    const { report: r } = buildContractAuditReport(base);
    expect(gridBy(r, 'من نص العقد')).toBeUndefined();
    expect(of(r.blocks, 'p').some((p) => p.text.includes('لم تُستخرج مبالغ أو نسب أو مدد أو تواريخ'))).toBe(true);
  });
});

describe('الغلاف التجارى: الأطراف والمرشحات العالية غير المحسومة', () => {
  const coverVal = (inp: AuditReportInput, label: string) => buildContractAuditReport(inp).report.cover.rows.find((r) => r.label.startsWith(label));

  it('يعرض اسمى الطرفين كما قُرئا، وينبّه إن لم يُقرأ أحدهما', () => {
    const both = coverVal({ ...INPUT, partyNames: { first: 'بلاك بيلتس', second: 'أروب' } }, 'أطراف العقد');
    expect(both?.value).toContain('الطرف الأول: بلاك بيلتس');
    expect(both?.value).toContain('الطرف الثانى: أروب');
    const one = coverVal({ ...INPUT, partyNames: { first: 'بلاك بيلتس', second: null } }, 'أطراف العقد');
    expect(one?.value).toContain('لم يُقرأ');
    expect(one?.tone).toBe('medium');
    expect(coverVal(INPUT, 'أطراف العقد')).toBeUndefined();
  });

  it('مرشح عالٍ غير مؤكد لا يرفع المستوى لكنه يظهر فى الغلاف', () => {
    const quiet = [clause({ clauseIndex: 1, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'عالٍ', assessmentReasoning: 'تحتاج مراجعة.', verification: { status: 'unconfirmed', reason: 'لم يجزم المدقق.' } })];
    const inp = { ...INPUT, clauses: quiet };
    const { report } = buildContractAuditReport(inp);
    const overall = report.cover.rows.find((r) => r.label === 'مستوى المخاطرة العام');
    expect(overall?.value).not.toContain('مرتفعة');
    const cand = coverVal(inp, 'مرشحات عالية');
    expect(cand?.value).toContain('1 ملاحظة');
    expect(cand?.value).toContain('مؤقت');
    expect(coverVal({ ...INPUT, clauses: [clause({ clauseIndex: 1 })] }, 'مرشحات عالية')).toBeUndefined();
  });
});

describe('نسخة العميل المبسطة', () => {
  const clientInput: AuditReportInput = { ...INPUT, audience: 'client', partyNames: { first: 'شركة أ', second: 'شركة ب' } };
  const { report } = buildContractAuditReport(clientInput);
  const banners = of(report.blocks, 'banner').map((b) => b.text);

  it('عنوان ونطاق مختلفان وأقسام العميل فقط', () => {
    expect(report.cover.title).toContain('نسخة العميل');
    expect(banners).toEqual(['1. الخلاصة', '2. النقاط التى تحتاج قرارك', '3. ما نوصى بتفاوضه أولاً', '4. ما يجب أن تعرفه عن هذا التقرير']);
    expect(report.cover.rows.some((r) => r.label.startsWith('القانون الحاكم'))).toBe(false);
    expect(report.cover.rows.some((r) => r.label.startsWith('أطراف العقد'))).toBe(true);
  });

  it('لا نصوص مواد ولا اقتباسات حرفية ولا توقيعات ولا مقارنات', () => {
    const json = JSON.stringify(report.blocks);
    expect(of(report.blocks, 'compare')).toHaveLength(0);
    expect(of(report.blocks, 'signatures')).toHaveLength(0);
    expect(json).not.toContain('تاريخ ثابت سابق على البيع');
    expect(json).not.toContain('الإطار القانونى والتشريعى');
  });

  it('بنود المخاطرة المؤكدة تظهر بالترتيب والعدد صحيح، والتعديل المقترح يظهر', () => {
    const grid = of(report.blocks, 'grid')[0];
    expect(grid.columns).toEqual(['#', 'الموضع', 'ما المشكلة', 'ما المطلوب', 'الدرجة']);
    expect(grid.rows.map((r) => r[4].text)).toEqual(['حرج', 'عالٍ', 'متوسط', 'غير مصنَّف']);
    expect(JSON.stringify(grid.rows)).toContain('أُضيف التزام المؤجر.');
    const strip = of(report.blocks, 'strip')[0];
    expect(strip.cells.slice(0, 3).map((c) => c.text)).toEqual(['1 حرجة', '1 عالية', '1 متوسطة']);
  });

  it('المرشح غير المؤكد لا يظهر كخطر مؤكد لكن يُذكر عدده', () => {
    const c = [...CLAUSES, clause({ clauseIndex: 7, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'عالٍ', assessmentReasoning: 'محتملة فقط.', verification: { status: 'unconfirmed', reason: 'لم يجزم.' } })];
    const { report: r } = buildContractAuditReport({ ...clientInput, clauses: c });
    const json = JSON.stringify(r.blocks);
    expect(json).not.toContain('محتملة فقط');
    expect(json).toContain('1 ملاحظة لم يستطع الفحص المستقل تأكيدها');
  });

  it('جدول الدفعات بأساس العقد الصريح (375,000 لكل مجموعة)', () => {
    const c = [
      clause({
        clauseIndex: 1,
        clauseText:
          'إجمالى القيمة 1125000 جنيه مصرى مقسمة على ثلاث مجموعات. تسدد قيمة كل مجموعة: الدفعة الأولى 30 % عند التعاقد، والثانية 30 % بعد تحميل البرامج، والثالثة 40 % بعد إنهاء التفعيل. على أن تحسب هذه الدفعات على أساس القيمة المقدرة لكل مجموعة كلا على حدا وهى ( 375000 جنيه مصرى ).',
      }),
    ];
    const { report: r } = buildContractAuditReport({ ...clientInput, clauses: c });
    const json = JSON.stringify(r.blocks);
    expect(json).toContain('112,500');
    expect(json).toContain('لكل وحدة (مجموعة)');
    expect(json).toContain('3 × 375,000');
  });

  it('الإصدار الافتراضى لم يتغير، واسم الملف يحمل -client والمُخرِجان يعملان', async () => {
    const full = buildContractAuditReport(INPUT).report;
    expect(of(full.blocks, 'banner')[0].text).toBe('1. الملخص التنفيذى');
    const doc = buildContractDocument(clientInput);
    expect(doc.filenameBase).toContain('-client');
    expect(renderAuditHtml(doc.audit!, 'ت')).toContain('نسخة العميل');
    const buf = await renderDocx(doc);
    expect(buf.subarray(0, 2).toString()).toBe('PK');
  });
});

describe('الغلاف الكثيف الصفوف', () => {
  const rich = buildContractAuditReport({
    ...INPUT,
    partyNames: { first: 'بلاك بيلتس', second: 'أروب' },
    extractionWarnings: ['قُرئ هذا العقد آلياً من صور ممسوحة ضوئياً (OCR).'],
  }).report;

  it('يُضغط (فئة dense) حين تزيد صفوفه على ثمانية كى لا يتسرب صف الخطورة العامة إلى صفحة شبه فارغة', () => {
    expect(rich.cover.rows.length).toBeGreaterThan(8);
    expect(renderAuditHtml(rich, 'ت')).toContain('class="cover dense"');
    expect(renderAuditHtml(rich, 'ت')).toContain('table.cover-t tr{break-inside:avoid}');
  });

  it('الغلاف القليل الصفوف يبقى بهيئته الأصلية', () => {
    const lean = { ...rich, cover: { ...rich.cover, rows: rich.cover.rows.slice(0, 6) } };
    expect(renderAuditHtml(lean, 'ت')).toContain('<section class="cover">');
  });
});
