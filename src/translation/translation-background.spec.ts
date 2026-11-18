import { BadGatewayException, ConflictException, NotFoundException, ServiceUnavailableException } from '@nestjs/common';
import { TranslationBackgroundRunner, httpStatusOf, runnerLimitsFromEnv, type RunnerStopReason } from './translation-background';

const noSleep = async (): Promise<void> => undefined;

function make(step: (id: string) => Promise<{ status: 'ready' | 'translating' | 'completed' }>, extra: Record<string, unknown> = {}) {
  const stops: Array<{ id: string; reason: RunnerStopReason }> = [];
  const runner = new TranslationBackgroundRunner({
    step,
    sleep: noSleep,
    onStop: (id, reason) => stops.push({ id, reason }),
    ...extra,
  });
  return { runner, stops };
}

/** ينتظر حتى يتوقف المشغّل (الحلقات غير المتزامنة تعمل بميكروتاسكات) */
async function settle(check: () => boolean): Promise<void> {
  for (let i = 0; i < 200 && !check(); i++) await new Promise((r) => setImmediate(r));
}

describe('TranslationBackgroundRunner', () => {
  it('يكرر الخطوة حتى الاكتمال ويعلن السبب completed', async () => {
    let calls = 0;
    const { runner, stops } = make(async () => ({ status: ++calls >= 4 ? 'completed' : 'translating' }));
    expect(runner.enqueue('a')).toBe('started');
    expect(runner.isActive('a')).toBe(true);
    await settle(() => stops.length > 0);
    expect(calls).toBe(4);
    expect(stops).toEqual([{ id: 'a', reason: 'completed' }]);
    expect(runner.isActive('a')).toBe(false);
  });

  it('لا يشغّل المهمة نفسها مرتين', async () => {
    let release!: () => void;
    const gate = new Promise<void>((r) => (release = r));
    const { runner, stops } = make(async () => {
      await gate;
      return { status: 'completed' };
    });
    expect(runner.enqueue('a')).toBe('started');
    expect(runner.enqueue('a')).toBe('duplicate');
    release();
    await settle(() => stops.length > 0);
    expect(stops).toHaveLength(1);
  });

  it('يحترم حد التزامن: الزائد ينتظر ثم يبدأ عند فراغ موضع', async () => {
    const order: string[] = [];
    const gates: Record<string, () => void> = {};
    const { runner, stops } = make(
      (id) =>
        new Promise((resolve) => {
          order.push(`start:${id}`);
          gates[id] = () => resolve({ status: 'completed' });
        }),
      { maxConcurrent: 1, maxQueued: 5 },
    );
    expect(runner.enqueue('a')).toBe('started');
    expect(runner.enqueue('b')).toBe('queued');
    expect(runner.queued).toBe(1);
    expect(runner.isActive('b')).toBe(true);
    expect(order).toEqual(['start:a']);
    gates.a();
    await settle(() => order.includes('start:b'));
    expect(order).toEqual(['start:a', 'start:b']);
    gates.b();
    await settle(() => stops.length === 2);
    expect(stops.map((s) => s.id)).toEqual(['a', 'b']);
  });

  it('يرفض عند امتلاء الطابور', () => {
    const { runner } = make(() => new Promise(() => undefined), { maxConcurrent: 1, maxQueued: 1 });
    expect(runner.enqueue('a')).toBe('started');
    expect(runner.enqueue('b')).toBe('queued');
    expect(runner.enqueue('c')).toBe('full');
    expect(runner.isActive('c')).toBe(false);
  });

  it('يعيد المحاولة عند تعذر دفعة عند المزود (502) ثم ينجح', async () => {
    let calls = 0;
    const { runner, stops } = make(async () => {
      calls++;
      if (calls <= 2) throw new BadGatewayException('x');
      return { status: 'completed' };
    });
    runner.enqueue('a');
    await settle(() => stops.length > 0);
    expect(calls).toBe(3);
    expect(stops[0].reason).toBe('completed');
  });

  it('يتوقف بعد إخفاقات متتالية ويعلن failed', async () => {
    let calls = 0;
    const { runner, stops } = make(async () => {
      calls++;
      throw new BadGatewayException('x');
    }, { maxConsecutiveFailures: 3 });
    runner.enqueue('a');
    await settle(() => stops.length > 0);
    expect(calls).toBe(3);
    expect(stops[0].reason).toBe('failed');
  });

  it('503 (الخدمة غير مفعلة) لا يُعاد: failed فوراً', async () => {
    let calls = 0;
    const { runner, stops } = make(async () => {
      calls++;
      throw new ServiceUnavailableException('off');
    });
    runner.enqueue('a');
    await settle(() => stops.length > 0);
    expect(calls).toBe(1);
    expect(stops[0].reason).toBe('failed');
  });

  it('404 (حُذفت الترجمة) يوقف بسبب not_found', async () => {
    const { runner, stops } = make(async () => {
      throw new NotFoundException('gone');
    });
    runner.enqueue('a');
    await settle(() => stops.length > 0);
    expect(stops[0].reason).toBe('not_found');
  });

  it('409 (خطوة أخرى جارية من المتصفح) ينتظر ويعيد ولا يُحسب فشلاً', async () => {
    let calls = 0;
    const { runner, stops } = make(async () => {
      calls++;
      if (calls <= 5) throw new ConflictException('busy');
      return { status: 'completed' };
    }, { maxConsecutiveFailures: 2 });
    runner.enqueue('a');
    await settle(() => stops.length > 0);
    expect(calls).toBe(6);
    expect(stops[0].reason).toBe('completed');
  });

  it('409 دائم ينتهى بـ conflict_timeout بدل حلقة أبدية', async () => {
    const { runner, stops } = make(async () => {
      throw new ConflictException('busy');
    }, { maxConflicts: 3 });
    runner.enqueue('a');
    await settle(() => stops.length > 0);
    expect(stops[0].reason).toBe('conflict_timeout');
  });

  it('فشل مستمع الإيقاف لا يُسقط المشغّل ويبدأ التالى فى الطابور', async () => {
    const done: string[] = [];
    const runner = new TranslationBackgroundRunner({
      step: async (id) => {
        done.push(id);
        return { status: 'completed' };
      },
      sleep: noSleep,
      maxConcurrent: 1,
      onStop: () => {
        throw new Error('listener');
      },
    });
    runner.enqueue('a');
    runner.enqueue('b');
    await settle(() => done.length === 2);
    expect(done).toEqual(['a', 'b']);
  });
});

describe('httpStatusOf / runnerLimitsFromEnv', () => {
  it('يقرأ رمز HttpException وخاصية status ويُرجع null لغيرهما', () => {
    expect(httpStatusOf(new NotFoundException())).toBe(404);
    expect(httpStatusOf({ status: 502 })).toBe(502);
    expect(httpStatusOf(new Error('x'))).toBeNull();
    expect(httpStatusOf(null)).toBeNull();
  });

  it('الحدود الافتراضية 2 و20 وتُقيَّد القيم المتطرفة', () => {
    expect(runnerLimitsFromEnv({})).toEqual({ maxConcurrent: 2, maxQueued: 20 });
    expect(runnerLimitsFromEnv({ TRANSLATION_MAX_BACKGROUND: '99', TRANSLATION_MAX_QUEUED: '500' } as NodeJS.ProcessEnv)).toEqual({
      maxConcurrent: 6,
      maxQueued: 200,
    });
    expect(runnerLimitsFromEnv({ TRANSLATION_MAX_BACKGROUND: 'abc' } as NodeJS.ProcessEnv).maxConcurrent).toBe(2);
  });
});
