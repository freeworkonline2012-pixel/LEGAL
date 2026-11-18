/**
 * مُشغِّل الترجمة فى الخلفية (داخل العملية): يكمل خطوات ترجمة مهمة موجودة فى الخادم دون أن يبقى المتصفح مفتوحاً.
 *
 * المبدأ: الحالة الحقيقية دائماً فى قاعدة البيانات (nextBatch + القفل الذرى)، والمشغِّل مجرد «عميل» آخر يستدعى الخطوة نفسها؛
 * فإن ضاعت العملية (إعادة تشغيل الخادم) تُستأنف المهمة من آخر دفعة محفوظة (يتولى ذلك TranslationService عند الإقلاع)،
 * وإن فتح المستخدم الصفحة وقاد الخطوات بنفسه تكفل قفل الخطوة بعدم التداخل (409 عندئذ ننتظر ونعيد، ولا نعتبره فشلاً).
 *
 * ملف نقى بلا اعتماد على Nest أو قاعدة البيانات: الخطوة والنوم تُحقنان، فيُختبر بلا زمن حقيقى.
 * يفترض نسخة تشغيل واحدة غالباً؛ تعدد النسخ آمن بفضل القفل الذرى لكنه قد يكرر محاولة استئناف عند الإقلاع.
 */

export type RunnerStopReason = 'completed' | 'failed' | 'not_found' | 'conflict_timeout';

export interface RunnerStepResult {
  status: 'ready' | 'translating' | 'completed';
}

export interface RunnerOptions {
  /** خطوة واحدة (دفعة) على المهمة؛ ترمى خطأً يحمل status عددياً (HTTP) أو name يدل على نوعه */
  step: (id: string) => Promise<RunnerStepResult>;
  onStop?: (id: string, reason: RunnerStopReason, err?: unknown) => void;
  maxConcurrent?: number;
  maxQueued?: number;
  /** أقصى إخفاقات متتالية قبل التوقف (الإخفاق العابر: تعذر دفعة عند المزود) */
  maxConsecutiveFailures?: number;
  /** أقصى مرات 409 متتالية (خطوة أخرى جارية) قبل التوقف */
  maxConflicts?: number;
  conflictWaitMs?: number;
  retryWaitMs?: number;
  sleep?: (ms: number) => Promise<void>;
}

export type EnqueueOutcome = 'started' | 'queued' | 'duplicate' | 'full';

/** أخطاء Nest HttpException تحمل getStatus()؛ نقرأ الرمز دون اعتماد على Nest. */
export function httpStatusOf(err: unknown): number | null {
  const e = err as { getStatus?: () => number; status?: unknown } | null;
  if (e && typeof e.getStatus === 'function') {
    try {
      return e.getStatus();
    } catch {
      return null;
    }
  }
  return typeof e?.status === 'number' ? e.status : null;
}

export function runnerLimitsFromEnv(env: NodeJS.ProcessEnv = process.env): { maxConcurrent: number; maxQueued: number } {
  const int = (v: string | undefined, d: number, lo: number, hi: number): number => {
    const n = Number(v);
    return Number.isFinite(n) && n >= lo ? Math.min(Math.floor(n), hi) : d;
  };
  return {
    maxConcurrent: int(env.TRANSLATION_MAX_BACKGROUND, 2, 1, 6),
    maxQueued: int(env.TRANSLATION_MAX_QUEUED, 20, 0, 200),
  };
}

export class TranslationBackgroundRunner {
  private readonly active = new Set<string>();
  private readonly waiting: string[] = [];
  private running = 0;
  private readonly maxConcurrent: number;
  private readonly maxQueued: number;
  private readonly maxFailures: number;
  private readonly maxConflicts: number;
  private readonly conflictWaitMs: number;
  private readonly retryWaitMs: number;
  private readonly sleep: (ms: number) => Promise<void>;

  constructor(private readonly opts: RunnerOptions) {
    this.maxConcurrent = opts.maxConcurrent ?? 2;
    this.maxQueued = opts.maxQueued ?? 20;
    this.maxFailures = opts.maxConsecutiveFailures ?? 3;
    this.maxConflicts = opts.maxConflicts ?? 40;
    this.conflictWaitMs = opts.conflictWaitMs ?? 3000;
    this.retryWaitMs = opts.retryWaitMs ?? 5000;
    this.sleep = opts.sleep ?? ((ms) => new Promise((r) => setTimeout(r, ms)));
  }

  /** هل المهمة تعمل الآن أو فى الانتظار؟ */
  isActive(id: string): boolean {
    return this.active.has(id);
  }

  get queued(): number {
    return this.waiting.length;
  }

  enqueue(id: string): EnqueueOutcome {
    if (this.active.has(id)) return 'duplicate';
    if (this.running >= this.maxConcurrent && this.waiting.length >= this.maxQueued) return 'full';
    this.active.add(id);
    if (this.running < this.maxConcurrent) {
      void this.run(id);
      return 'started';
    }
    this.waiting.push(id);
    return 'queued';
  }

  private async run(id: string): Promise<void> {
    this.running++;
    let reason: RunnerStopReason = 'failed';
    let lastErr: unknown;
    try {
      reason = await this.loop(id, (e) => (lastErr = e));
    } catch (e) {
      lastErr = e;
      reason = 'failed';
    } finally {
      this.active.delete(id);
      this.running--;
      try {
        this.opts.onStop?.(id, reason, lastErr);
      } catch {
        /* مستمع الإيقاف لا يُسقط المشغّل */
      }
      const next = this.waiting.shift();
      if (next) void this.run(next);
    }
  }

  private async loop(id: string, setErr: (e: unknown) => void): Promise<RunnerStopReason> {
    let failures = 0;
    let conflicts = 0;
    for (;;) {
      try {
        const res = await this.opts.step(id);
        failures = 0;
        conflicts = 0;
        if (res.status === 'completed') return 'completed';
      } catch (err) {
        const status = httpStatusOf(err);
        if (status === 404) return 'not_found';
        if (status === 409) {
          // خطوة أخرى جارية (المتصفح مثلاً): ننتظر ثم نعيد، ولو اكتملت فى الأثناء ننهى بأول استجابة مكتملة
          conflicts++;
          if (conflicts > this.maxConflicts) {
            setErr(err);
            return 'conflict_timeout';
          }
          await this.sleep(this.conflictWaitMs);
          continue;
        }
        // 503 (خدمة غير مفعلة) وأخطاء العميل 4xx لا تُحَل بالإعادة
        if (status !== null && status !== 502 && status !== 429 && status < 500 && status !== 408) {
          setErr(err);
          return 'failed';
        }
        if (status === 503) {
          setErr(err);
          return 'failed';
        }
        failures++;
        setErr(err);
        if (failures >= this.maxFailures) return 'failed';
        await this.sleep(this.retryWaitMs * failures);
      }
    }
  }
}
