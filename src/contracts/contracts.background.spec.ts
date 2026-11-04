import { ServiceUnavailableException } from '@nestjs/common';
import { ContractsService } from './contracts.service';

/** التحليل فى الخلفية: يعود الطلب فوراً، التقدم يظهر، الأعطال تصير حالة فشل مقروءة، ولا يبقى عقد معلّقاً. بيانات مُصطنَعة. */
function build(extract: unknown, readImpl?: jest.Mock) {
  const store: Record<string, Record<string, unknown>> = {};
  const contractRepo = {
    create: jest.fn().mockImplementation((v) => ({ id: 'c1', createdAt: new Date(), updatedAt: new Date(), ...v })),
    save: jest.fn().mockImplementation(async (c) => {
      store[c.id] = { ...(store[c.id] ?? {}), ...c };
      return c;
    }),
    findOne: jest.fn().mockImplementation(async ({ where }: { where: { id: string } }) => (store[where.id] ? { ...store[where.id] } : null)),
    update: jest.fn().mockResolvedValue({ affected: 2 }),
  };
  const clauseRepo = { find: jest.fn().mockResolvedValue([{ clauseIndex: 1 }]) };
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
  return { service, reader, contractRepo, store, clauseRepo };
}

const ctx = { userId: 'u1', ipAddress: null, userAgent: null };
const pdf = { buffer: Buffer.from('%PDF-1.4'), mimetype: 'application/pdf', originalname: 'scan.pdf' };
const TEXT = ['البند الأول', 'التمهيد جزء من العقد.', '', 'البند الثانى', 'مدة العقد سنة واحدة.'].join('\n');
const jobsOf = (s: ContractsService) => (s as never as { jobs: { has: (id: string) => boolean; get: (id: string) => unknown } }).jobs;
async function untilDone(s: ContractsService, id: string) {
  for (let i = 0; i < 200 && jobsOf(s).has(id); i++) await new Promise((r) => setImmediate(r));
}

describe('ContractsService.upload — خلفى', () => {
  it('يعود فوراً بحالة processing بلا بنود، ثم تنتهى المهمة إلى processed', async () => {
    const { service, store } = build({ status: 'ok', text: TEXT });
    const res = await service.upload(pdf, ctx, undefined, { background: true });
    expect(res.status).toBe('processing');
    expect(res.clauses).toEqual([]);
    expect(res.processing).toEqual(expect.objectContaining({ stage: 'queued' }));
    await untilDone(service, res.id);
    expect(store[res.id].status).toBe('processed');
    expect(store[res.id].clauseCount).toBe(2);
  });

  it('ممسوح: يمرَّر حد 34 صفحة ومتتبع التقدم، والتقدم يظهر فى الاستعلام أثناء القراءة', async () => {
    let seenProgress: unknown = null;
    let svc!: ContractsService;
    const read = jest.fn().mockImplementation(async (_b: Buffer, opts: { onOcrProgress: (p: unknown) => void }) => {
      opts.onOcrProgress({ stage: 'read', done: 5, total: 20 });
      seenProgress = jobsOf(svc).get('c1');
      return { text: TEXT, type: 'pdf', usedOcr: true, warnings: [] };
    });
    const b = build({ status: 'empty', detail: 'x' }, read);
    svc = b.service;
    const res = await svc.upload(pdf, ctx, undefined, { background: true });
    await untilDone(svc, res.id);
    expect(read.mock.calls[0][1].ocrMaxPages).toBe(34);
    expect(seenProgress).toEqual({ stage: 'reading', done: 5, total: 20 });
    expect(b.store[res.id].status).toBe('processed');
  });

  it('المتزامن القديم: لا حد موسَّع ولا متتبع تقدم، ويعود بالنتيجة كاملة', async () => {
    const read = jest.fn().mockResolvedValue({ text: TEXT, type: 'pdf', usedOcr: true, warnings: [] });
    const { service } = build({ status: 'empty', detail: 'x' }, read);
    const res = await service.upload(pdf, ctx);
    expect(read.mock.calls[0][1].ocrMaxPages).toBeUndefined();
    expect(read.mock.calls[0][1].onOcrProgress).toBeUndefined();
    expect(res.status).toBe('processed');
  });

  it('عطل غير متوقَّع فى الخلفية ⇒ extraction_failed برسالة واضحة (لا عقد معلّق)', async () => {
    const { service, store } = build({ status: 'ok', text: TEXT });
    jest.spyOn(service as never, 'analyzeContractLevel' as never).mockRejectedValue(new Error('db down') as never);
    const res = await service.upload(pdf, ctx, undefined, { background: true });
    await untilDone(service, res.id);
    expect(store[res.id].status).toBe('extraction_failed');
    expect(String(store[res.id].extractionError)).toContain('أعد رفع العقد');
  });

  it('الطابور ممتلئ ⇒ 503 قبل إنشاء أى سجل', async () => {
    const { service, contractRepo } = build({ status: 'ok', text: TEXT });
    jest.spyOn(jobsOf(service) as never, 'hasCapacity' as never).mockReturnValue(false as never);
    await expect(service.upload(pdf, ctx, undefined, { background: true })).rejects.toBeInstanceOf(ServiceUnavailableException);
    expect(contractRepo.create).not.toHaveBeenCalled();
  });
});

describe('ContractsService.findById وإقلاع الخادم', () => {
  const owner = { userId: 'u1', role: 'user' };
  const stale = new Date(Date.now() - 10 * 60_000);

  it('عقد معلّق لا مهمة له وقديم ⇒ يُعلَن فاشلاً (إعادة تشغيل أثناء التحليل)', async () => {
    const { service, contractRepo, store } = build({ status: 'ok', text: TEXT });
    store.c9 = { id: 'c9', uploadedBy: 'u1', status: 'processing', updatedAt: stale, createdAt: stale, originalFilename: 'a.pdf' };
    const res = await service.findById('c9', owner);
    expect(res.status).toBe('extraction_failed');
    expect(res.extraction_error).toContain('أُعيد تشغيله');
    expect(contractRepo.save).toHaveBeenCalled();
  });

  it('عقد معلّق حديث لا يُعدّ يتيماً (مهلة السماح)', async () => {
    const { service, store } = build({ status: 'ok', text: TEXT });
    const now = new Date();
    store.c8 = { id: 'c8', uploadedBy: 'u1', status: 'processing', updatedAt: now, createdAt: now, originalFilename: 'a.pdf' };
    expect((await service.findById('c8', owner)).status).toBe('processing');
  });

  it('أثناء المعالجة تُعرض الحالة والتقدم بلا بنود نصف مقيَّمة', async () => {
    const { service, store } = build({ status: 'ok', text: TEXT });
    store.c7 = { id: 'c7', uploadedBy: 'u1', status: 'processing', updatedAt: new Date(), createdAt: new Date(), originalFilename: 'a.pdf' };
    // مهمة جارية فى هذه العملية
    let release!: () => void;
    (service as never as { jobs: { enqueue: (id: string, t: () => Promise<void>) => void; set: (id: string, p: unknown) => void } }).jobs.enqueue('c7', () => new Promise<void>((r) => (release = r)));
    (service as never as { jobs: { set: (id: string, p: unknown) => void } }).jobs.set('c7', { stage: 'assessing', done: 4, total: 12 });
    const res = await service.findById('c7', owner);
    expect(res.clauses).toEqual([]);
    expect(res.processing).toEqual({ stage: 'assessing', label: 'تقييم البنود', done: 4, total: 12 });
    release();
  });

  it('عقد منتهٍ: لا حقل تقدم، وتُعرض بنوده', async () => {
    const { service, store } = build({ status: 'ok', text: TEXT });
    store.c6 = { id: 'c6', uploadedBy: 'u1', status: 'processed', updatedAt: stale, createdAt: stale, originalFilename: 'a.pdf' };
    const res = await service.findById('c6', owner);
    expect(res.processing).toBeNull();
    expect(res.status).toBe('processed');
  });

  it('الإقلاع: يُعلَن فاشلاً كل عقد uploaded/processing عالق، ولا يسقط الإقلاع إن تعذّر التحديث', async () => {
    const { service, contractRepo } = build({ status: 'ok', text: TEXT });
    await service.onModuleInit();
    expect(contractRepo.update).toHaveBeenCalledTimes(1);
    const [where, patch] = contractRepo.update.mock.calls[0];
    expect(JSON.stringify(where)).toContain('uploaded');
    expect(JSON.stringify(where)).toContain('processing');
    expect(patch.status).toBe('extraction_failed');
    contractRepo.update.mockRejectedValueOnce(new Error('no db'));
    await expect(service.onModuleInit()).resolves.toBeUndefined();
  });
});
