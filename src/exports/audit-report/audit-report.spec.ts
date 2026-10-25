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
      '5. النسخة الاحترافية المُعدَّلة للبنود',
      '6. توصيات التنفيذ والجدول الزمنى للتفاوض',
      '7. الإطار القانونى والتشريعى المرجعى',
      '8. إخلاء المسؤولية',
      '9. الذيول المرجعية للمواد القانونية',
      '10. قسم التوقيعات واعتماد التقرير',
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
