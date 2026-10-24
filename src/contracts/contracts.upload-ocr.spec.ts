import { UnprocessableEntityException } from '@nestjs/common';
import { ContractsService } from './contracts.service';

/**
 * رفع عقد PDF ممسوح ضوئياً: بدل "0 بند" يُقرأ بالـOCR مع تنبيه صريح، وإن تعذّرت القراءة يُرفض بسبب واضح.
 * بيانات مُصطنَعة بالكامل (لا عقد عميل حقيقى).
 */
function build(extract: unknown, readImpl?: jest.Mock) {
  const contractRepo = {
    create: jest.fn().mockImplementation((v) => ({ id: 'c1', ...v })),
    save: jest.fn().mockImplementation(async (c) => c),
  };
  const clauseRepo = { find: jest.fn().mockResolvedValue([]) };
  const dataSource = {
    getRepository: jest.fn().mockImplementation((e: { name: string }) => (e.name === 'Contract' ? contractRepo : clauseRepo)),
  };
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const extraction = { extract: jest.fn().mockResolvedValue(extract) };
  const reader = { read: readImpl ?? jest.fn() };
  const service = new ContractsService(
    dataSource as never,
    audit as never,
    extraction as never,
    new (jest.requireActual('./segmentation.service').SegmentationService)() as never,
    {} as never,
    {} as never,
    reader as never,
    { isConfigured: false } as never,
    { isConfigured: false, analyze: jest.fn().mockResolvedValue({ status: 'not_configured' }) } as never,
    { isConfigured: false } as never,
  );
  jest.spyOn(service as never, 'assessAndPersistClause' as never).mockResolvedValue(undefined as never);
  jest.spyOn(service as never, 'persistInitialClause' as never).mockImplementation((async (_id: string, c: { label: string }) => ({ ...c, id: c.label })) as never);
  return { service, reader, contractRepo };
}

const ctx = { userId: 'u1', ipAddress: null, userAgent: null };
const pdf = { buffer: Buffer.from('%PDF-1.4'), mimetype: 'application/pdf', originalname: 'scan.pdf' };
const SCANNED_TEXT = ['البند الأول', 'التمهيد جزء من العقد.', '', 'البند الثانى', 'مدة العقد سنة واحدة.'].join('\n');

describe('ContractsService.upload — PDF ممسوح ضوئياً', () => {
  it('يقرأ الممسوح بالـOCR ويُرجع تنبيه القراءة الآلية بدل رفضه', async () => {
    const read = jest.fn().mockResolvedValue({ text: SCANNED_TEXT, type: 'pdf', usedOcr: true, warnings: [] });
    const { service } = build({ status: 'empty', detail: 'x' }, read);
    const res = await service.upload(pdf, ctx);
    expect(read).toHaveBeenCalledTimes(1);
    expect(read.mock.calls[0][1].failOnOcrTruncation).toBe(true);
    expect(res.status).toBe('processed');
    expect(res.clause_count).toBe(2);
    expect((res.warnings ?? []).some((w) => w.includes('OCR') && w.includes('قارن كل بند بالأصل'))).toBe(true);
  });

  it('لا يستعمل الـOCR لملف نصى سليم', async () => {
    const read = jest.fn();
    const { service } = build({ status: 'ok', text: SCANNED_TEXT }, read);
    const res = await service.upload(pdf, ctx);
    expect(read).not.toHaveBeenCalled();
    expect((res.warnings ?? []).some((w) => w.includes('OCR'))).toBe(false);
  });

  it('عند تعذّر القراءة الآلية يُسجَّل extraction_failed بسبب واضح لا "0 بند"', async () => {
    const read = jest
      .fn()
      .mockRejectedValue(new UnprocessableEntityException('القراءة الآلية للصور غير متاحة حالياً'));
    const { service } = build({ status: 'empty', detail: 'x' }, read);
    const res = await service.upload(pdf, ctx);
    expect(res.status).toBe('extraction_failed');
    expect(res.extraction_error).toContain('غير متاحة');
    expect(res.clauses).toEqual([]);
  });

  it('لا يستعمل الـOCR لملف DOCX فارغ', async () => {
    const read = jest.fn();
    const { service } = build({ status: 'empty', detail: 'فارغ' }, read);
    const res = await service.upload(
      { buffer: Buffer.from('x'), mimetype: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', originalname: 'a.docx' },
      ctx,
    );
    expect(read).not.toHaveBeenCalled();
    expect(res.status).toBe('extraction_failed');
  });
});

describe('ContractsService.analyzeContractLevel', () => {
  const rows = [
    { clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: 'ترخيص استخدام النظام لمدة هذا العقد وفق الجدول المرفق.' },
    { clauseIndex: 2, clauseLabel: 'البند الثانى', clauseTitle: null, clauseText: 'تحدد رسوم الاستضافة بعد انتهاء التنفيذ وفق ما يتفق عليه الطرفان.' },
  ];
  const mk = (analyze: jest.Mock) => {
    const { service } = build({ status: 'ok', text: 'x' } as never);
    (service as unknown as { consistencyService: unknown }).consistencyService = { analyze };
    return service;
  };

  it('عطل تمرير النموذج لا يُسقط الفحوص الحتمية ويُسجَّل model=error', async () => {
    const s = mk(jest.fn().mockRejectedValue(new Error('x')));
    const r = await s.analyzeContractLevel(rows as never, 'عقد خدمات أو مقاولة أو توريد', []);
    expect(r.model).toBe('error');
    expect(r.findings.some((f) => f.id === 'undefined:duration')).toBe(true);
    expect(r.findings.some((f) => f.kind === 'open_term')).toBe(true);
  });

  it('نتائج النموذج تُدمج مع الحتمية وحالته تُسجَّل', async () => {
    const model = {
      id: 'model:conflict:1', kind: 'conflict', severity: 'عالٍ', title: 't', explanation: 'e', suggestion: null, source: 'model',
      evidence: [{ clauseIndex: 1, clauseLabel: 'a', quote: 'q1' }, { clauseIndex: 2, clauseLabel: 'b', quote: 'q2' }],
    };
    const s = mk(jest.fn().mockResolvedValue({ status: 'ok', findings: [model] }));
    const r = await s.analyzeContractLevel(rows as never, null, []);
    expect(r.model).toBe('ok');
    expect(r.findings.some((f) => f.id === 'model:conflict:1')).toBe(true);
  });
});

describe('ContractsService — الطبقة 4 (المدقق المستقل) وحارس الصياغة', () => {
  const mkService = (verifier: unknown, facts: unknown = { isConfigured: false }) => {
    const { service } = build({ status: 'ok', text: 'x' } as never);
    Object.assign(service as unknown as Record<string, unknown>, { verifierService: verifier, factsService: facts });
    return service as unknown as {
      verifyClauseFlags: (rows: unknown[], p: unknown) => Promise<void>;
      verifyContractFindings: (l: unknown, rows: unknown[]) => Promise<void>;
      guardRedraftFacts: (c: unknown, text: string, party: 'first' | 'second') => Promise<Array<{ code: string }>>;
    };
  };
  const row = (over: Record<string, unknown> = {}) => ({
    clauseIndex: 13, clauseLabel: 'ب13', clauseText: 'نص', assessmentStatus: 'يحتاج مراجعة', riskLevel: 'عالٍ', assessmentReasoning: 'ملاحظة',
    matchedArticles: [{ law: 'ق', article_no: 158, snippet: 'م' }], ruleFindings: null, verification: null, ...over,
  });

  it('يوسم بند النموذج بنتيجة المدقق، ويتجاوز بند القواعد، ويستمر بعد عطل بند', async () => {
    const verifyAssessment = jest
      .fn()
      .mockRejectedValueOnce(new Error('x'))
      .mockResolvedValueOnce({ status: 'ok', verification: { status: 'unconfirmed', basis: 'refuted', reason: 'r', quote: 'q', quoteSource: 'clause', verifiedAt: 't' } });
    const s = mkService({ isConfigured: true, verifyAssessment });
    const rows = [row({ clauseIndex: 1 }), row({ clauseIndex: 2 }), row({ clauseIndex: 3, ruleFindings: [{}] })];
    await s.verifyClauseFlags(rows, { contractType: null, clientRole: null, clientParty: null });
    expect(verifyAssessment).toHaveBeenCalledTimes(2);
    expect((rows[1] as unknown as { verification: { status: string } }).verification.status).toBe('unconfirmed');
    expect((rows[0] as { verification: unknown }).verification).toBeNull();
    expect((rows[2] as { verification: unknown }).verification).toBeNull();
  });

  it('المدقق غير مفعَّل ⇒ لا نداء ولا وسم', async () => {
    const verifyAssessment = jest.fn();
    const s = mkService({ isConfigured: false, verifyAssessment });
    await s.verifyClauseFlags([row()], { contractType: null, clientRole: null, clientParty: null });
    expect(verifyAssessment).not.toHaveBeenCalled();
  });

  it('ملاحظات العقد ككل: يوسم نتائج النموذج فقط', async () => {
    const verifyFinding = jest.fn().mockResolvedValue({ status: 'ok', verification: { status: 'confirmed', basis: 'confirmed', reason: 'r', quote: null, quoteSource: null, verifiedAt: 't' } });
    const s = mkService({ isConfigured: true, verifyFinding });
    const level = {
      findings: [
        { id: 'a', kind: 'conflict', source: 'model', title: 't', explanation: 'e', evidence: [{ clauseIndex: 13, clauseLabel: 'ب13', quote: 'q' }] },
        { id: 'b', kind: 'open_term', source: 'rule', title: 't', explanation: 'e', evidence: [] },
      ],
    };
    await s.verifyContractFindings(level, [row()]);
    expect(verifyFinding).toHaveBeenCalledTimes(1);
    expect((level.findings[0] as { verification?: { status: string } }).verification?.status).toBe('confirmed');
    expect((level.findings[1] as { verification?: unknown }).verification).toBeUndefined();
  });

  it('G12: الحارس يكشف صياغة تضيف الإنذار على عميل يملك حق الفسخ، ولا يحكم بلا استخراج ناجح', async () => {
    const orig = { termination: { mechanism: 'automatic_without_court', holder: 'second', quote: 'يجوز للطرف الثانى فسخ العقد' }, notice: { state: 'waived_explicitly', quote: 'دون حاجة إلى إنذار' } };
    const prop = { termination: { mechanism: 'automatic_without_court', holder: 'second', quote: 'يجوز للطرف الثانى فسخ العقد' }, notice: { state: 'required', quote: 'بعد إنذار مدته ثلاثون يوماً' } };
    const extract = jest.fn().mockResolvedValueOnce({ status: 'ok', facts: orig }).mockResolvedValueOnce({ status: 'ok', facts: prop });
    const s = mkService({ isConfigured: false }, { isConfigured: true, extract });
    const w = await s.guardRedraftFacts({ clauseText: 'نص', facts: null }, 'مقترح', 'second');
    expect(w.map((x) => x.code)).toContain('notice.waiver_removed_from_client');
    const failing = mkService({ isConfigured: false }, { isConfigured: true, extract: jest.fn().mockResolvedValue({ status: 'error', detail: 'x' }) });
    expect(await failing.guardRedraftFacts({ clauseText: 'نص', facts: null }, 'مقترح', 'second')).toEqual([]);
    const off = mkService({ isConfigured: false }, { isConfigured: false });
    expect(await off.guardRedraftFacts({ clauseText: 'نص', facts: null }, 'مقترح', 'second')).toEqual([]);
  });
});
