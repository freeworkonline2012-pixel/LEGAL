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
