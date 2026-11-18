import { ContractsService } from './contracts.service';

/** مهام التحليل المستأنفة بعد إعادة تشغيل الخادم (migrations/267): الحفظ المؤقت المشفَّر، الاستئناف، الحذف عند الانتهاء. بيانات مُصطنَعة. */
function fakeSources() {
  const saved = new Map<string, unknown>();
  return {
    saved,
    save: jest.fn(async (id: string, p: unknown) => {
      saved.set(id, p);
      return true;
    }),
    renew: jest.fn().mockResolvedValue(undefined),
    release: jest.fn().mockResolvedValue(undefined),
    unclaim: jest.fn().mockResolvedValue(undefined),
    delete: jest.fn(async (id: string) => {
      saved.delete(id);
    }),
    has: jest.fn(async (id: string) => saved.has(id)),
    failInterruptedWithoutSource: jest.fn().mockResolvedValue(0),
    giveUpExhausted: jest.fn().mockResolvedValue([]),
    claimExpired: jest.fn().mockResolvedValue([]),
    purgeStale: jest.fn().mockResolvedValue(0),
  };
}

function build(extract: unknown) {
  const store: Record<string, Record<string, unknown>> = {};
  const contractRepo = {
    create: jest.fn().mockImplementation((v) => ({ id: 'c1', createdAt: new Date(), updatedAt: new Date(), ...v })),
    save: jest.fn().mockImplementation(async (c) => {
      store[c.id] = { ...(store[c.id] ?? {}), ...c };
      return c;
    }),
    findOne: jest.fn().mockImplementation(async ({ where }: { where: { id: string } }) => (store[where.id] ? { ...store[where.id] } : null)),
    update: jest.fn().mockResolvedValue({ affected: 0 }),
  };
  const clauseRepo = { find: jest.fn().mockResolvedValue([{ clauseIndex: 1 }]), delete: jest.fn().mockResolvedValue({ affected: 3 }) };
  const dataSource = {
    getRepository: jest.fn().mockImplementation((e: { name: string }) => (e.name === 'Contract' ? contractRepo : clauseRepo)),
  };
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const sources = fakeSources();
  const service = new ContractsService(
    dataSource as never,
    audit as never,
    { extract: jest.fn().mockResolvedValue(extract) } as never,
    new (jest.requireActual('./segmentation.service').SegmentationService)() as never,
    {} as never,
    {} as never,
    { read: jest.fn() } as never,
    { isConfigured: false } as never,
    { isConfigured: false, analyze: jest.fn().mockResolvedValue({ status: 'not_configured' }) } as never,
    { isConfigured: false } as never,
    sources as never,
  );
  jest.spyOn(service as never, 'assessAndPersistClause' as never).mockResolvedValue(undefined as never);
  jest.spyOn(service as never, 'persistInitialClause' as never).mockImplementation((async (_id: string, c: { label: string }) => ({ ...c, id: c.label })) as never);
  return { service, store, contractRepo, clauseRepo, sources, audit };
}

const ctx = { userId: 'u1', ipAddress: '1.2.3.4', userAgent: 'jest' };
const pdf = { buffer: Buffer.from('%PDF-1.4 fake'), mimetype: 'application/pdf', originalname: 'scan.pdf' };
const TEXT = ['البند الأول', 'التمهيد جزء من العقد.', '', 'البند الثانى', 'مدة العقد سنة واحدة.'].join('\n');
const jobsOf = (s: ContractsService) => (s as never as { jobs: { has: (id: string) => boolean; ids: () => string[] } }).jobs;
async function untilDone(s: ContractsService, id: string) {
  for (let i = 0; i < 400 && jobsOf(s).has(id); i++) await new Promise((r) => setImmediate(r));
}
const claimed = (id = 'c1', attempts = 2) => ({
  contractId: id,
  attempts,
  payload: {
    file: { b64: pdf.buffer.toString('base64'), mimetype: pdf.mimetype, originalname: pdf.originalname },
    context: ctx,
    position: { contractType: null, clientRole: null, clientParty: null },
  },
});

describe('حفظ مصدر المهمة أثناء التحليل', () => {
  it('الرفع فى الخلفية يحفظ الملف وسياقه ومركز العميل قبل بدء المهمة، ويُحذف بعد النجاح', async () => {
    const { service, sources, store } = build({ status: 'ok', text: TEXT });
    let savedBeforeRun: unknown = null;
    sources.save.mockImplementationOnce(async (id: string, p: unknown) => {
      savedBeforeRun = { id, p, jobRunning: jobsOf(service).has(id) };
      sources.saved.set(id, p);
      return true;
    });
    const res = await service.upload(pdf, ctx, { contractType: 'عقد خدمات', clientRole: 'العميل', clientParty: null }, { background: true });
    await untilDone(service, res.id);
    expect(store[res.id].status).toBe('processed');
    expect(savedBeforeRun).toMatchObject({
      id: 'c1',
      jobRunning: false, // حُفظ قبل enqueue: سقوط الخادم بعد الحفظ مباشرة يعنى مهمة قابلة للاستئناف
      p: {
        file: { b64: pdf.buffer.toString('base64'), mimetype: 'application/pdf', originalname: 'scan.pdf' },
        context: ctx,
        position: { contractType: 'عقد خدمات', clientRole: 'العميل' },
      },
    });
    expect(sources.delete).toHaveBeenCalledWith('c1');
    expect(sources.saved.has('c1')).toBe(false);
  });

  it('الفشل المعلن (عطل غير متوقع) يحذف المصدر أيضاً: لا ملف عقد يبقى', async () => {
    const { service, sources, store } = build({ status: 'ok', text: TEXT });
    jest.spyOn(service as never, 'analyzeContractLevel' as never).mockRejectedValue(new Error('db down') as never);
    const res = await service.upload(pdf, ctx, undefined, { background: true });
    await untilDone(service, res.id);
    expect(store[res.id].status).toBe('extraction_failed');
    expect(sources.delete).toHaveBeenCalledWith('c1');
  });

  it('فشل الحفظ لا يمنع التحليل (يعمل كما كان بلا استئناف)', async () => {
    const { service, sources, store } = build({ status: 'ok', text: TEXT });
    sources.save.mockResolvedValue(false);
    const res = await service.upload(pdf, ctx, undefined, { background: true });
    await untilDone(service, res.id);
    expect(store[res.id].status).toBe('processed');
  });

  it('الرفع المتزامن القديم لا يحفظ شيئاً', async () => {
    const { service, sources } = build({ status: 'ok', text: TEXT });
    await service.upload(pdf, ctx);
    expect(sources.save).not.toHaveBeenCalled();
  });
});

describe('استئناف المهام المنقطعة', () => {
  it('مهمة محجوزة بعد انقضاء حجزها: تُحذف بنودها الناقصة وتُعاد من أولها وتنتهى processed ويُحذف المصدر', async () => {
    const { service, sources, store, clauseRepo, audit } = build({ status: 'ok', text: TEXT });
    const now = new Date(Date.now() - 20 * 60_000);
    store.c1 = { id: 'c1', uploadedBy: 'u1', status: 'processing', updatedAt: now, createdAt: now, originalFilename: 'scan.pdf', extractionError: null };
    sources.claimExpired.mockResolvedValueOnce([claimed()]);
    await service.resumeSweep();
    await untilDone(service, 'c1');
    expect(clauseRepo.delete).toHaveBeenCalledWith({ contractId: 'c1' });
    expect(store.c1.status).toBe('processed');
    expect(store.c1.clauseCount).toBe(2);
    expect(sources.delete).toHaveBeenCalledWith('c1');
    expect(audit.record.mock.calls.some((c) => c[0].action === 'contracts.job_resumed')).toBe(true);
  });

  it('عقد انتهى بالفعل (processed/فشل): لا يُعاد تشغيله ويُحذف مصدره', async () => {
    const { service, sources, store, clauseRepo } = build({ status: 'ok', text: TEXT });
    store.c1 = { id: 'c1', uploadedBy: 'u1', status: 'processed', updatedAt: new Date(), createdAt: new Date(), originalFilename: 'a.pdf' };
    sources.claimExpired.mockResolvedValueOnce([claimed()]);
    await service.resumeSweep();
    expect(clauseRepo.delete).not.toHaveBeenCalled();
    expect(sources.delete).toHaveBeenCalledWith('c1');
    expect(jobsOf(service).has('c1')).toBe(false);
  });

  it('لا اتساع فى الطابور: يُفرَج عن الحجز ويرجع العداد (تُستأنف فى دورة لاحقة)', async () => {
    const { service, sources, store } = build({ status: 'ok', text: TEXT });
    store.c1 = { id: 'c1', uploadedBy: 'u1', status: 'processing', updatedAt: new Date(), createdAt: new Date(), originalFilename: 'a.pdf' };
    jest.spyOn(jobsOf(service) as never, 'hasCapacity' as never).mockReturnValue(false as never);
    sources.claimExpired.mockResolvedValueOnce([claimed()]);
    await service.resumeSweep();
    expect(sources.unclaim).toHaveBeenCalledWith('c1');
  });

  it('مهمة تعمل فعلاً فى هذه العملية لا تُكرَّر', async () => {
    const { service, sources, store, clauseRepo } = build({ status: 'ok', text: TEXT });
    store.c1 = { id: 'c1', uploadedBy: 'u1', status: 'processing', updatedAt: new Date(), createdAt: new Date(), originalFilename: 'a.pdf' };
    jest.spyOn(jobsOf(service) as never, 'has' as never).mockReturnValue(true as never);
    sources.claimExpired.mockResolvedValueOnce([claimed()]);
    await service.resumeSweep();
    expect(clauseRepo.delete).not.toHaveBeenCalled();
  });

  it('الدورة تُعلن فاشلة المهام التى استنفدت محاولاتها وتنظف المنتهية، ولا تدخلها بعد ذلك', async () => {
    const { service, sources } = build({ status: 'ok', text: TEXT });
    sources.giveUpExhausted.mockResolvedValueOnce(['cx']);
    await service.resumeSweep();
    expect(sources.giveUpExhausted).toHaveBeenCalledTimes(1);
    expect(sources.purgeStale).toHaveBeenCalledTimes(1);
    expect(sources.claimExpired).toHaveBeenCalledTimes(1);
  });

  it('عطل فى الاستعلام لا يرمى ويُسمح بدورة تالية، ولا دورتان متداخلتان', async () => {
    const { service, sources } = build({ status: 'ok', text: TEXT });
    sources.claimExpired.mockRejectedValueOnce(new Error('db down'));
    await expect(service.resumeSweep()).resolves.toBeUndefined();
    let release!: () => void;
    sources.giveUpExhausted.mockImplementationOnce(() => new Promise((r) => (release = () => r([]))));
    const first = service.resumeSweep();
    await service.resumeSweep(); // متداخلة: تُتجاهل
    expect(sources.giveUpExhausted).toHaveBeenCalledTimes(2); // 1 من الدورة الفاشلة + 1 من الأولى فقط
    release();
    await first;
  });
});

describe('الإقلاع والإيقاف والاستعلام مع المصدر المحفوظ', () => {
  beforeEach(() => jest.useFakeTimers());
  afterEach(() => jest.useRealTimers());

  it('الإقلاع: يُعلَن فاشلاً ما بلا مصدر فقط (لا تحديث شامل)، ويُجدول الاستئناف دون انتظاره', async () => {
    const { service, sources, contractRepo } = build({ status: 'ok', text: TEXT });
    sources.failInterruptedWithoutSource.mockResolvedValueOnce(2);
    await service.onModuleInit();
    expect(sources.failInterruptedWithoutSource).toHaveBeenCalledTimes(1);
    expect(contractRepo.update).not.toHaveBeenCalled();
    expect(sources.claimExpired).not.toHaveBeenCalled();
    await jest.advanceTimersByTimeAsync(21_000);
    expect(sources.giveUpExhausted).toHaveBeenCalledTimes(1);
  });

  it('الإيقاف الآمن يُفرج عن حجوزات مهام هذه العملية', async () => {
    const { service, sources } = build({ status: 'ok', text: TEXT });
    jest.spyOn(jobsOf(service) as never, 'ids' as never).mockReturnValue(['c1', 'c2'] as never);
    await service.beforeApplicationShutdown();
    expect(sources.release).toHaveBeenCalledWith(['c1', 'c2']);
  });

  it('findById: معلّق قديم له مصدر لا يُعلَن فاشلاً، وبلا مصدر يُعلَن', async () => {
    const { service, sources, store } = build({ status: 'ok', text: TEXT });
    const stale = new Date(Date.now() - 10 * 60_000);
    store.a = { id: 'a', uploadedBy: 'u1', status: 'processing', updatedAt: stale, createdAt: stale, originalFilename: 'a.pdf' };
    store.b = { id: 'b', uploadedBy: 'u1', status: 'processing', updatedAt: stale, createdAt: stale, originalFilename: 'b.pdf' };
    sources.saved.set('a', {});
    const owner = { userId: 'u1', role: 'user' };
    expect((await service.findById('a', owner)).status).toBe('processing');
    expect((await service.findById('b', owner)).status).toBe('extraction_failed');
  });
});

describe('تجديد الحجز بالتقدم', () => {
  it('يتجدد مرة واحدة فى الدقيقة مهما تكرر التقدم', async () => {
    const { service, sources } = build({ status: 'ok', text: TEXT });
    const progress = (service as never as { progressOf: (id: string) => (p: unknown) => void }).progressOf('c1');
    for (let i = 0; i < 10; i++) progress({ stage: 'assessing', done: i, total: 10 });
    expect(sources.renew).toHaveBeenCalledTimes(1);
  });
});

describe('rowsOf', () => {
  // eslint-disable-next-line @typescript-eslint/no-require-imports
  const { rowsOf } = require('./contract-job-sources.service') as typeof import('./contract-job-sources.service');
  it('يفك الزوج [صفوف، عدد] الذى يعيده TypeORM من UPDATE/DELETE ... RETURNING', () => {
    expect(rowsOf([[{ id: 'a' }, { id: 'b' }], 2])).toEqual([{ id: 'a' }, { id: 'b' }]);
    expect(rowsOf([[], 0])).toEqual([]);
  });
  it('يترك نتيجة SELECT كما هى ويتسامح مع غير المصفوفة', () => {
    expect(rowsOf([{ id: 'a' }, { id: 'b' }])).toEqual([{ id: 'a' }, { id: 'b' }]);
    expect(rowsOf(undefined)).toEqual([]);
  });
});
