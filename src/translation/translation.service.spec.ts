import {
  BadGatewayException,
  ConflictException,
  HttpException,
  NotFoundException,
  ServiceUnavailableException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { TranslationService, MAX_CREATED_PER_DAY } from './translation.service';
import { renderTranslationHtml } from './translation-html.renderer';
import { renderTranslationDocx } from './translation-docx.renderer';
import type { TranslationDocument } from './translation-document';

const ACTOR = { userId: 'u1', role: 'user', ipAddress: '1.1.1.1', userAgent: 'jest' };
const OTHER = { userId: 'u2', role: 'user', ipAddress: '1.1.1.1', userAgent: 'jest' };
const ADMIN = { userId: 'adm', role: 'admin', ipAddress: '1.1.1.1', userAgent: 'jest' };

const AR_TEXT = [
  'عقد عمل',
  '1. يتقاضى الطرف الثانى أجراً شهرياً قدره 12000 جنيه مصرى يُدفع فى نهاية كل شهر ميلادى طوال مدة العقد.',
  '2. يلتزم الطرف الثانى بالمحافظة على سرية المعلومات التى يطلع عليها بحكم عمله لدى الطرف الأول وبعد انتهاء العقد.',
  '3. تكون مدة العقد سنة واحدة تبدأ من 01/10/2026 وتنتهى فى 30/09/2027 وتجدد باتفاق الطرفين كتابة.',
].join('\n');

function fakeRepo() {
  const rows = new Map<string, any>();
  let seq = 0;
  let lockedIds = new Set<string>();
  const repo: any = {
    rows,
    create: (x: any) => ({ ...x }),
    save: jest.fn(async (r: any) => {
      if (!r.id) {
        r.id = `00000000-0000-4000-8000-${String(++seq).padStart(12, '0')}`;
        r.createdAt = r.createdAt ?? new Date();
      }
      rows.set(r.id, r);
      return r;
    }),
    findOne: jest.fn(async ({ where }: any) => rows.get(where.id) ?? null),
    // استعلام استئناف الخلفية عند الإقلاع: الصفوف التى علمها background_run ولم تكتمل (الشرط الزمنى يُختبر فى SQL لا هنا)
    find: jest.fn(async (q?: any) =>
      q?.where?.userId
        ? [...rows.values()].filter((r) => r.userId === q.where.userId).sort((a, b) => b.createdAt - a.createdAt)
        : [...rows.values()].filter((r) => r.backgroundRun === true && r.status !== 'completed'),
    ),
    count: jest.fn(async ({ where }: any) => [...rows.values()].filter((r) => r.userId === where.userId).length),
    update: jest.fn(async ({ id }: any, patch: any) => {
      const r = rows.get(id);
      if (r) Object.assign(r, patch);
      lockedIds.delete(id);
      return { affected: r ? 1 : 0 };
    }),
    delete: jest.fn(async ({ id }: any) => {
      rows.delete(id);
    }),
    createQueryBuilder: () => {
      let id = '';
      const qb: any = {
        update: () => qb,
        set: () => qb,
        where: (_s: string, p: any) => {
          id = p.id;
          return qb;
        },
        andWhere: () => qb,
        execute: async () => {
          const r = rows.get(id);
          if (!r || lockedIds.has(id) || r.status === 'completed') return { affected: 0 };
          lockedIds.add(id);
          return { affected: 1 };
        },
      };
      return qb;
    },
  };
  return repo;
}

type Behaviour = (input: string, call: number) => unknown;

function echoModel(extra?: { numberBug?: boolean }): any {
  let call = 0;
  return {
    isConfigured: true,
    profile: jest.fn().mockResolvedValue({ status: 'ok', raw: { contract_type: 'عقد عمل', domain: 'employment' } }),
    translateBatch: jest.fn(async (_sys: string, user: string) => {
      call++;
      const units = [...user.matchAll(/\[(\d+)\] ([^\n]*)/g)].map((m) => ({ i: Number(m[1]), src: m[2] }));
      return {
        status: 'ok',
        raw: {
          units: units.map((u) => ({
            i: u.i,
            // ترجمة وهمية تحفظ الأرقام وطولاً معقولاً
            t:
              'The parties agree that ' +
              (u.src.match(/\d+/g) ?? [])
                .map((n) => (extra?.numberBug && call === 1 ? n + '9' : n))
                .join(' and ') +
              ' shall apply to the employment relationship hereunder for the term stated herein by the parties.',
          })),
          notes: [],
          defined_terms: [],
        },
      };
    }),
  };
}

function build(opts: { model?: any; text?: string; configured?: boolean } = {}) {
  const repo = fakeRepo();
  const reader = {
    read: jest.fn().mockResolvedValue({ text: opts.text ?? AR_TEXT.repeat(1), type: 'docx', usedOcr: false, warnings: [] }),
  };
  const model = opts.model ?? echoModel();
  if (opts.configured === false) model.isConfigured = false;
  const glossary = { activeTerms: jest.fn().mockResolvedValue([]) };
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const pdf = { renderHtmlString: jest.fn().mockResolvedValue(Buffer.from('%PDF-fake')) };
  const service = new TranslationService(repo, reader as never, model as never, glossary as never, audit as never, pdf as never);
  return { service, repo, reader, model, audit, pdf };
}
const FILE = { buffer: Buffer.from('x'), originalname: 'عقد-العمل.docx', size: 1 };

async function runAll(service: TranslationService, id: string, actor = ACTOR) {
  let v = await service.get(id, actor);
  for (let k = 0; k < 20 && v.status !== 'completed'; k++) v = await service.step(id, actor);
  return v;
}

describe('TranslationService', () => {
  it('ينشئ مهمة ويكشف اللغة ويحلل نوع العقد', async () => {
    const { service, audit } = build();
    const v = await service.create(FILE, 'en', ACTOR);
    expect(v.source_lang).toBe('ar');
    expect(v.target_lang).toBe('en');
    expect(v.contract_type).toBe('عقد عمل');
    expect(v.status).toBe('ready');
    expect(v.progress.total_units).toBeGreaterThan(0);
    const created = audit.record.mock.calls.find((c) => c[0].action === 'translation.created')![0];
    expect(JSON.stringify(created.metadata)).not.toContain('يتقاضى');
  });

  it('يرفض لغة الهدف المطابقة للمصدر (422) والعقد الثنائى اللغة', async () => {
    await expect(build().service.create(FILE, 'ar', ACTOR)).rejects.toBeInstanceOf(UnprocessableEntityException);
    const mixed = ('عقد عمل بين الطرفين ويلتزم كل طرف بما ورد فيه. ' + 'This agreement is made between the parties and binds each of them. ').repeat(5);
    await expect(build({ text: mixed }).service.create(FILE, 'en', ACTOR)).rejects.toBeInstanceOf(UnprocessableEntityException);
  });

  it('يرفض عند غياب مفتاح النموذج (503) ويحترم الحد اليومى (429)', async () => {
    await expect(build({ configured: false }).service.create(FILE, 'en', ACTOR)).rejects.toBeInstanceOf(ServiceUnavailableException);
    const { service } = build();
    for (let i = 0; i < MAX_CREATED_PER_DAY; i++) await service.create(FILE, 'en', ACTOR);
    await expect(service.create(FILE, 'en', ACTOR)).rejects.toBeInstanceOf(HttpException);
    // مستخدم آخر لا يتأثر
    await expect(service.create(FILE, 'en', OTHER)).resolves.toBeDefined();
  });

  it('يكمل الخطوات ويحفظ الأرقام ثم يتيح التحرير والتنزيل', async () => {
    const { service, pdf } = build();
    const created = await service.create(FILE, 'en', ACTOR);
    const done = await runAll(service, created.id);
    expect(done.status).toBe('completed');
    expect(done.progress.done_units).toBe(done.progress.total_units);
    const page = await service.units(created.id, 0, 50, ACTOR);
    expect(page.items.some((u) => u.tgt.includes('12000'))).toBe(true);
    const edited = await service.editUnit(created.id, 1, 'Employment Contract', ACTOR);
    expect(edited.edited).toBe(true);
    const docx = await service.download(created.id, 'docx', 'translation', ACTOR);
    expect(docx.buffer.subarray(0, 2).toString()).toBe('PK');
    expect(docx.filename).toMatch(/^translation-ar-en-TRN-.*\.docx$/);
    const bi = await service.download(created.id, 'pdf', 'bilingual', ACTOR);
    expect(bi.filename).toMatch(/-bilingual\.pdf$/);
    expect(pdf.renderHtmlString).toHaveBeenCalledTimes(1);
  });

  it('يعيد ترجمة الفقرة مرة واحدة عند اختلاف الأرقام ثم يزيل الوسم إن صحّت', async () => {
    const model = echoModel({ numberBug: true });
    const { service } = build({ model });
    const created = await service.create(FILE, 'en', ACTOR);
    const done = await runAll(service, created.id);
    expect(model.translateBatch).toHaveBeenCalledTimes(2); // الأصلى + إعادة واحدة فقط
    expect(done.flagged).toHaveLength(0);
  });

  it('يوسم الفقرة للمراجعة إن بقى الخطأ بعد إعادة المحاولة', async () => {
    const model = echoModel();
    model.translateBatch.mockImplementation(async (_s: string, user: string) => {
      const units = [...user.matchAll(/\[(\d+)\] ([^\n]*)/g)].map((m) => Number(m[1]));
      return { status: 'ok', raw: { units: units.map((i) => ({ i, t: 'The parties agree to the terms stated herein for the duration of the agreement.' })), notes: [], defined_terms: [] } };
    });
    const { service } = build({ model });
    const created = await service.create(FILE, 'en', ACTOR);
    const done = await runAll(service, created.id);
    expect(done.flagged.length).toBeGreaterThan(0);
    expect(done.flagged[0].flags).toContain('numbers_mismatch');
  });

  it('فشل النموذج يرمى 502 ويحرر القفل لإعادة المحاولة', async () => {
    const model = echoModel();
    model.translateBatch.mockResolvedValueOnce({ status: 'error', detail: 'boom' });
    const { service } = build({ model });
    const created = await service.create(FILE, 'en', ACTOR);
    await expect(service.step(created.id, ACTOR)).rejects.toBeInstanceOf(BadGatewayException);
    await expect(service.step(created.id, ACTOR)).resolves.toBeDefined();
  });

  it('خطوتان متوازيتان: الثانية 409', async () => {
    const model = echoModel();
    let release!: () => void;
    const gate = new Promise<void>((r) => (release = r));
    const orig = model.translateBatch.getMockImplementation()!;
    model.translateBatch.mockImplementationOnce(async (s: string, u: string) => {
      await gate;
      return orig(s, u);
    });
    const { service } = build({ model });
    const created = await service.create(FILE, 'en', ACTOR);
    const first = service.step(created.id, ACTOR);
    await new Promise((r) => setTimeout(r, 20));
    await expect(service.step(created.id, ACTOR)).rejects.toBeInstanceOf(ConflictException);
    release();
    await first;
  });

  it('الملكية: غير المالك (حتى admin) يحصل على 404 فى كل العمليات', async () => {
    const { service } = build();
    const created = await service.create(FILE, 'en', ACTOR);
    await runAll(service, created.id);
    for (const who of [OTHER, ADMIN]) {
      await expect(service.get(created.id, who)).rejects.toBeInstanceOf(NotFoundException);
      await expect(service.step(created.id, who)).rejects.toBeInstanceOf(NotFoundException);
      await expect(service.units(created.id, 0, 10, who)).rejects.toBeInstanceOf(NotFoundException);
      await expect(service.editUnit(created.id, 1, 'x', who)).rejects.toBeInstanceOf(NotFoundException);
      await expect(service.download(created.id, 'docx', 'translation', who)).rejects.toBeInstanceOf(NotFoundException);
      await expect(service.remove(created.id, who)).rejects.toBeInstanceOf(NotFoundException);
    }
  });

  it('لا تنزيل ولا تحرير قبل الاكتمال، والحذف يزيل السجل', async () => {
    const { service } = build();
    const created = await service.create(FILE, 'en', ACTOR);
    await expect(service.download(created.id, 'pdf', 'translation', ACTOR)).rejects.toBeInstanceOf(ConflictException);
    await expect(service.editUnit(created.id, 1, 'x', ACTOR)).rejects.toBeInstanceOf(ConflictException);
    await service.remove(created.id, ACTOR);
    await expect(service.get(created.id, ACTOR)).rejects.toBeInstanceOf(NotFoundException);
  });

  it('المنتهية الصلاحية تُعامل كغير موجودة', async () => {
    const { service, repo } = build();
    const created = await service.create(FILE, 'en', ACTOR);
    repo.rows.get(created.id).expiresAt = new Date(Date.now() - 1000);
    await expect(service.get(created.id, ACTOR)).rejects.toBeInstanceOf(NotFoundException);
  });
});

describe('translation renderers', () => {
  const base: TranslationDocument = {
    layout: 'translation',
    from: 'ar',
    to: 'en',
    brand: 'Shield Legal Platform',
    reference: 'TRN-TEST',
    generatedAt: new Date('2026-10-15T10:00:00Z'),
    contractType: 'عقد عمل',
    paragraphs: [
      { src: 'عقد <b>عمل</b>', tgt: 'Employment <script>alert(1)</script> Contract', heading: true },
      { src: 'بند', tgt: 'Clause', heading: false },
    ],
    notes: [{ n: 2, term: 'بند', note: 'ملاحظة' }],
    flagged: [{ n: 2, messages: ['الأرقام لا تطابق الأصل'], excerpt: 'Clause' }],
    filenameBase: 'x',
  };

  it('HTML: يهرب المحتوى ويضبط الاتجاه بحسب لغة الهدف', () => {
    const en = renderTranslationHtml(base);
    expect(en).not.toContain('<script>alert(1)</script>');
    expect(en).toContain('&lt;script&gt;');
    expect(en).toMatch(/dir="ltr"/);
    const ar = renderTranslationHtml({ ...base, from: 'en', to: 'ar' });
    expect(ar).toMatch(/dir="rtl"/);
    const bi = renderTranslationHtml({ ...base, layout: 'bilingual' });
    expect(bi).toContain('عقد &lt;b&gt;عمل&lt;/b&gt;');
  });

  it('DOCX: ملف zip صالح للتخطيطين', async () => {
    for (const layout of ['translation', 'bilingual'] as const) {
      const buf = await renderTranslationDocx({ ...base, layout });
      expect(buf.subarray(0, 2).toString()).toBe('PK');
      expect(buf.length).toBeGreaterThan(2000);
    }
  });
});

async function waitUntil(check: () => boolean | Promise<boolean>): Promise<void> {
  for (let i = 0; i < 2000; i++) {
    if (await check()) return;
    await new Promise((r) => setImmediate(r));
  }
  throw new Error('waitUntil: timed out');
}

describe('TranslationService — تشغيل الخلفية (بند التشغيل 4)', () => {
  it('create مع background=true: الخادم يكمل الترجمة بلا أى استدعاء step من العميل ثم يصفّر العلم', async () => {
    const { service, repo, audit } = build();
    const created = await service.create(FILE, 'en', ACTOR, { background: true });
    expect(created.background).toBe('running');
    expect(repo.rows.get(created.id).backgroundRun).toBe(true);
    await waitUntil(async () => (await service.get(created.id, ACTOR)).status === 'completed');
    await waitUntil(() => repo.rows.get(created.id).backgroundRun === false);
    const done = await service.get(created.id, ACTOR);
    expect(done.background).toBe('idle');
    expect(done.progress.done_units).toBe(done.progress.total_units);
    const page = await service.units(created.id, 0, 50, ACTOR);
    expect(page.items.some((u) => u.tgt.includes('12000'))).toBe(true);
    // التدقيق: لا محتوى، وبداية/اكتمال مسجلان
    expect(audit.record.mock.calls.some((c) => c[0].action === 'translation.completed')).toBe(true);
    expect(JSON.stringify(audit.record.mock.calls)).not.toContain('يتقاضى');
  });

  it('بلا background: السلوك القديم كما هو (لا مشغِّل ولا نداء للنموذج حتى يقود العميل الخطوات)', async () => {
    const { service, repo, model } = build();
    const created = await service.create(FILE, 'en', ACTOR);
    expect(created.background).toBe('idle');
    expect(repo.rows.get(created.id).backgroundRun).toBe(false);
    await new Promise((r) => setImmediate(r));
    expect(model.translateBatch).not.toHaveBeenCalled();
    const done = await runAll(service, created.id);
    expect(done.status).toBe('completed');
  });

  it('runInBackground يكمل مهمة يقودها العميل، ويرفض مالكاً آخر (404) ولا يعيد تشغيل المكتملة', async () => {
    const { service, repo, model } = build();
    const created = await service.create(FILE, 'en', ACTOR);
    await expect(service.runInBackground(created.id, OTHER)).rejects.toBeInstanceOf(NotFoundException);
    const started = await service.runInBackground(created.id, ACTOR);
    expect(started.background).toBe('running');
    // استدعاء ثانٍ أثناء العمل لا يضاعف المشغِّل
    const again = await service.runInBackground(created.id, ACTOR);
    expect(again.background).toBe('running');
    await waitUntil(async () => (await service.get(created.id, ACTOR)).status === 'completed');
    await waitUntil(() => repo.rows.get(created.id).backgroundRun === false);
    const calls = model.translateBatch.mock.calls.length;
    const after = await service.runInBackground(created.id, ACTOR);
    expect(after.status).toBe('completed');
    expect(model.translateBatch.mock.calls.length).toBe(calls);
  });

  it('توقف النموذج (503) يوقف المشغِّل ويصفّر العلم فلا تُعاد المحاولة مع كل إقلاع، والعميل يستطيع الاستئناف', async () => {
    const { service, repo, model } = build();
    const created = await service.create(FILE, 'en', ACTOR);
    model.isConfigured = false;
    await expect(service.runInBackground(created.id, ACTOR)).rejects.toBeInstanceOf(ServiceUnavailableException);
    model.isConfigured = true;
    // مشغِّل بدأ ثم أُطفئ المزوّد: يفشل فوراً ويصفّر العلم
    const started = await service.runInBackground(created.id, ACTOR);
    expect(started.background).toBe('running');
    model.isConfigured = false;
    await waitUntil(() => repo.rows.get(created.id).backgroundRun === false);
    model.isConfigured = true;
    const v = await service.get(created.id, ACTOR);
    expect(v.background).toBe('idle');
    // العميل يكمل بنفسه من حيث وقفت المهمة
    const done = await runAll(service, created.id);
    expect(done.status).toBe('completed');
  });

  it('onApplicationBootstrap يستأنف المهام العاملة فى الخلفية من آخر دفعة محفوظة بعد إعادة التشغيل', async () => {
    const long = AR_TEXT.split('\n').slice(1).join('\n');
    const { service, repo } = build({ text: 'عقد عمل\n' + Array.from({ length: 40 }, () => long).join('\n') });
    const created = await service.create(FILE, 'en', ACTOR);
    expect(created.progress.total_batches).toBeGreaterThan(1);
    await service.step(created.id, ACTOR); // دفعة واحدة ثم «يموت» الخادم
    const row = repo.rows.get(created.id);
    expect(row.status).toBe('translating');
    row.backgroundRun = true;
    const nextBefore = row.nextBatch;

    await service.onApplicationBootstrap();
    await waitUntil(async () => (await service.get(created.id, ACTOR)).status === 'completed');
    expect(repo.rows.get(created.id).nextBatch).toBeGreaterThanOrEqual(nextBefore);
    await waitUntil(() => repo.rows.get(created.id).backgroundRun === false);
  });

  it('TRANSLATION_RESUME_ON_BOOT=false يعطل الاستئناف، وفشل الاستعلام لا يُسقط الإقلاع', async () => {
    const { service, repo } = build();
    const created = await service.create(FILE, 'en', ACTOR);
    repo.rows.get(created.id).backgroundRun = true;
    const prev = process.env.TRANSLATION_RESUME_ON_BOOT;
    process.env.TRANSLATION_RESUME_ON_BOOT = 'false';
    try {
      await service.onApplicationBootstrap();
      expect(repo.find).not.toHaveBeenCalled();
    } finally {
      if (prev === undefined) delete process.env.TRANSLATION_RESUME_ON_BOOT;
      else process.env.TRANSLATION_RESUME_ON_BOOT = prev;
    }
    repo.find.mockRejectedValueOnce(new Error('db down'));
    await expect(service.onApplicationBootstrap()).resolves.toBeUndefined();
  });

  it('حذف المهمة أثناء الخلفية يوقف المشغِّل بهدوء (404) دون تصفير علم صف محذوف', async () => {
    const { service, repo } = build();
    const created = await service.create(FILE, 'en', ACTOR, { background: true });
    await service.remove(created.id, ACTOR);
    await waitUntil(async () => (await service.get(created.id, ACTOR).catch(() => null)) === null);
    // انتظر توقف المشغِّل نفسه: لو كانت الخطوة تحفظ بـsave لعاد الصف المحذوف (عقد كامل) بعد الحذف
    await waitUntil(() => !(service as unknown as { runner: { isActive(id: string): boolean } }).runner.isActive(created.id));
    expect(repo.rows.has(created.id)).toBe(false);
  });

  it('list: ترجمات المستخدم فقط، بلا حمولة ولا نص عقد، مع حالة الخلفية', async () => {
    const { service, repo } = build();
    const mine = await service.create(FILE, 'en', ACTOR, { background: true });
    await service.create(FILE, 'en', OTHER);
    const items = await service.list(ACTOR);
    expect(items).toHaveLength(1);
    expect(items[0]).toMatchObject({ id: mine.id, source_lang: 'ar', target_lang: 'en', background: 'running' });
    expect(JSON.stringify(items)).not.toContain('يتقاضى');
    expect(Object.keys(items[0]).sort()).toEqual(
      ['background', 'created_at', 'expires_at', 'id', 'progress', 'source_lang', 'status', 'target_lang', 'title'],
    );
    // الاستعلام لا يطلب عمود payload (لا فك تشفير لقائمة)
    const q = (repo.find as jest.Mock).mock.calls.at(-1)![0];
    expect(q.select).not.toContain('payload');
    await waitUntil(async () => (await service.get(mine.id, ACTOR)).status === 'completed');
  });
});
