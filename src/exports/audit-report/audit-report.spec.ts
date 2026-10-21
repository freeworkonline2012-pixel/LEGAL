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
      '2. مصفوفة تحليل المخاطر',
      '3. التقييم التفصيلى للمخاطر',
      '4. النسخة الاحترافية المُعدَّلة للبنود',
      '5. توصيات التنفيذ والجدول الزمنى للتفاوض',
      '6. الإطار القانونى والتشريعى المرجعى',
      '7. إخلاء المسؤولية',
      '8. الذيول المرجعية للمواد القانونية',
      '9. قسم التوقيعات واعتماد التقرير',
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
    const grid = of(report.blocks, 'grid')[0];
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
    const recs = of(report.blocks, 'grid')[1];
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
