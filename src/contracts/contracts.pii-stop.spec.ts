import { ContractsService } from './contracts.service';

/** الحارس داخل رفع العقد: يوقف قبل أى نداء خارجى، ولا يمس العقد النظيف. بيانات مُصطنَعة بالكامل. */
function build() {
  const contractRepo = {
    create: jest.fn().mockImplementation((v) => ({ id: 'c1', ...v })),
    save: jest.fn().mockImplementation(async (c) => c),
  };
  const clauseRepo = { find: jest.fn().mockResolvedValue([]) };
  const dataSource = {
    getRepository: jest.fn().mockImplementation((e: { name: string }) => (e.name === 'Contract' ? contractRepo : clauseRepo)),
  };
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const extract = jest.fn();
  const segmentation = new (jest.requireActual('./segmentation.service').SegmentationService)();
  const segmentSpy = jest.spyOn(segmentation, 'segment');
  const service = new ContractsService(
    dataSource as never,
    audit as never,
    { extract } as never,
    segmentation as never,
    {} as never,
    {} as never,
    { read: jest.fn() } as never,
    { isConfigured: false } as never,
    { isConfigured: false, analyze: jest.fn().mockResolvedValue({ status: 'not_configured' }) } as never,
    { isConfigured: false } as never,
  );
  jest.spyOn(service as never, 'assessAndPersistClause' as never).mockResolvedValue(undefined as never);
  jest.spyOn(service as never, 'persistInitialClause' as never).mockImplementation((async (_id: string, c: { label: string }) => ({ ...c, id: c.label })) as never);
  return { service, extract, segmentSpy, audit };
}

const ctx = { userId: 'u1', ipAddress: null, userAgent: null };
const pdf = { buffer: Buffer.from('%PDF-1.4'), mimetype: 'application/pdf', originalname: 'c.pdf' };
const CLEAN = ['البند الأول', 'التمهيد جزء من العقد.', '', 'البند الثانى', 'مدة العقد سنة واحدة بقيمة 12500 جنيه.'].join('\n');

describe('ContractsService.upload — حارس البيانات الشخصية', () => {
  const OLD = process.env.CONTRACT_PII_BLOCK;
  afterEach(() => {
    if (OLD === undefined) delete process.env.CONTRACT_PII_BLOCK;
    else process.env.CONTRACT_PII_BLOCK = OLD;
  });

  it.each([
    ['رقم قومى', 'يمثله المقيم بالبطاقة 29001011234567', '1 رقم قومى'],
    ['هاتف', 'للتواصل 01012345678', '1 رقم هاتف'],
    ['حساب بنكى', 'يسدد فى حساب رقم 1234567890123 لدى البنك', '1 حساب بنكى'],
  ])('يوقف العقد الذى فيه %s قبل التقسيم والتحليل ولا يسرّب القيمة', async (_name, line, expected) => {
    const { service, extract, segmentSpy, audit } = build();
    extract.mockResolvedValue({ status: 'ok', text: `${CLEAN}\n${line}` });
    const res = await service.upload(pdf, ctx);
    expect(res.status).toBe('extraction_failed');
    expect(res.extraction_error).toContain('أُوقف تحليل هذا العقد');
    expect(res.extraction_error).toContain(expected);
    expect(res.extraction_error).not.toMatch(/\d{9,}/);
    expect(res.clauses).toEqual([]);
    expect(segmentSpy).not.toHaveBeenCalled();
    const auditArgs = JSON.stringify(audit.record.mock.calls);
    expect(auditArgs).toContain('contracts.blocked_personal_data');
    for (const v of ['29001011234567', '01012345678', '1234567890123']) expect(auditArgs).not.toContain(v);
  });

  it('العقد النظيف يكمل كالمعتاد', async () => {
    const { service, extract } = build();
    extract.mockResolvedValue({ status: 'ok', text: CLEAN });
    const res = await service.upload(pdf, ctx);
    expect(res.status).toBe('processed');
    expect(res.clause_count).toBe(2);
  });

  it('CONTRACT_PII_BLOCK=off يعطّل الإيقاف', async () => {
    process.env.CONTRACT_PII_BLOCK = 'off';
    const { service, extract } = build();
    extract.mockResolvedValue({ status: 'ok', text: `${CLEAN}\nللتواصل 01012345678` });
    const res = await service.upload(pdf, ctx);
    expect(res.status).toBe('processed');
  });
});
