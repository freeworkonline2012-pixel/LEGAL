import { ContractJobs, JOB_STAGE_LABEL, jobLimitsFromEnv, stageFromOcr } from './contract-jobs';

const tick = () => new Promise<void>((r) => setImmediate(r));

describe('ContractJobs', () => {
  it('مهمة واحدة: تُسجَّل فى الانتظار ثم تُزال بعد انتهائها', async () => {
    const jobs = new ContractJobs(1, 5);
    let release!: () => void;
    jobs.enqueue('a', () => new Promise<void>((r) => (release = r)));
    expect(jobs.has('a')).toBe(true);
    expect(jobs.get('a')?.stage).toBe('queued');
    jobs.set('a', { stage: 'assessing', done: 3, total: 10 });
    expect(jobs.get('a')).toEqual({ stage: 'assessing', done: 3, total: 10 });
    release();
    await tick();
    await tick();
    expect(jobs.has('a')).toBe(false);
  });

  it('حد التزامن: الثالثة تنتظر حتى تنتهى إحدى الأوليين', async () => {
    const jobs = new ContractJobs(2, 5);
    const started: string[] = [];
    const releases: Record<string, () => void> = {};
    for (const id of ['a', 'b', 'c']) {
      jobs.enqueue(id, () => {
        started.push(id);
        return new Promise<void>((r) => (releases[id] = r));
      });
    }
    await tick();
    expect(started).toEqual(['a', 'b']);
    expect(jobs.queued).toBe(1);
    releases.a();
    await tick();
    await tick();
    expect(started).toEqual(['a', 'b', 'c']);
    expect(jobs.queued).toBe(0);
    releases.b();
    releases.c();
    await tick();
    await tick();
    expect(jobs.has('b') || jobs.has('c')).toBe(false);
  });

  it('السعة: تمتلئ حين يبلغ الجارى والمنتظر حدّيهما ولا ترفض قبل ذلك', async () => {
    const jobs = new ContractJobs(1, 1);
    expect(jobs.hasCapacity()).toBe(true);
    jobs.enqueue('a', () => new Promise<void>(() => undefined)); // جارية للأبد
    expect(jobs.hasCapacity()).toBe(true); // موضع واحد فى الطابور
    jobs.enqueue('b', () => new Promise<void>(() => undefined));
    expect(jobs.hasCapacity()).toBe(false);
  });

  it('استثناء غير ملتقَط من مهمة لا يُسقط الطابور ويُبلَّغ به، وتبدأ التالية', async () => {
    const jobs = new ContractJobs(1, 5);
    const seen: unknown[] = [];
    const ran: string[] = [];
    jobs.enqueue('a', async () => { throw new Error('boom'); }, (e) => seen.push((e as Error).message));
    jobs.enqueue('b', async () => { ran.push('b'); });
    await tick();
    await tick();
    expect(seen).toEqual(['boom']);
    expect(ran).toEqual(['b']);
    expect(jobs.has('a')).toBe(false);
  });

  it('set على مهمة غير مسجَّلة لا ينشئ سجلاً (لا تسرب ذاكرة بعد الانتهاء)', () => {
    const jobs = new ContractJobs();
    jobs.set('ghost', { stage: 'reading', done: 1, total: 2 });
    expect(jobs.has('ghost')).toBe(false);
  });

  it('track: تُحسب المهمة المتزامنة مسجَّلة أثناء عملها وتُزال حتى لو فشلت', async () => {
    const jobs = new ContractJobs();
    await jobs.track('s', async () => {
      expect(jobs.has('s')).toBe(true);
    });
    expect(jobs.has('s')).toBe(false);
    await expect(jobs.track('t', async () => { throw new Error('x'); })).rejects.toThrow('x');
    expect(jobs.has('t')).toBe(false);
  });

  it('الإعدادات من البيئة: افتراضيات سليمة وحدود عليا وقيم تالفة تُهمَل', () => {
    expect(jobLimitsFromEnv({})).toEqual({ maxConcurrent: 2, maxQueued: 10 });
    expect(jobLimitsFromEnv({ CONTRACTS_MAX_BACKGROUND: '4', CONTRACTS_MAX_QUEUED: '3' } as never)).toEqual({ maxConcurrent: 4, maxQueued: 3 });
    expect(jobLimitsFromEnv({ CONTRACTS_MAX_BACKGROUND: '999' } as never).maxConcurrent).toBe(8);
    expect(jobLimitsFromEnv({ CONTRACTS_MAX_BACKGROUND: '0', CONTRACTS_MAX_QUEUED: 'abc' } as never)).toEqual({ maxConcurrent: 2, maxQueued: 10 });
  });

  it('تسميات المراحل مكتملة وتحويل مراحل القراءة الآلية', () => {
    expect(stageFromOcr('read')).toBe('reading');
    expect(stageFromOcr('reread')).toBe('rereading');
    expect(stageFromOcr('recover')).toBe('recovering');
    for (const l of Object.values(JOB_STAGE_LABEL)) expect(l.length).toBeGreaterThan(3);
  });
});
