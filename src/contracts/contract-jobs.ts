/**
 * سجل مهام تحليل العقود فى الخلفية (داخل العملية): التقدم الظاهر للمستخدم، وطابور بحد تزامن، وكشف المهام اليتيمة.
 *
 * لماذا فى الذاكرة لا فى قاعدة البيانات: المهمة نفسها تعيش فى هذه العملية (ملف العقد فى الذاكرة ولا يُخزَّن أصلاً بقرار
 * تصميم الخدمة)، فإن أُعيد تشغيل الخادم ضاعت المهمة حتماً ولا قيمة لتقدم محفوظ لها؛ المهم أن يُعلَن فشلها بوضوح بدل أن تبقى
 * «قيد المعالجة» إلى الأبد (يتولى ذلك ContractsService عند الإقلاع وعند الاستعلام). يفترض نسخة تشغيل واحدة (كما هو الحال على
 * Railway اليوم)؛ تعدد النسخ يلزمه طابور خارجى فيُراجَع هذا الملف حينها.
 * ملف نقى بلا اعتماد على Nest أو قاعدة البيانات.
 */

export type JobStage = 'queued' | 'reading' | 'rereading' | 'recovering' | 'segmenting' | 'assessing' | 'verifying' | 'contract_level';

export interface JobProgress {
  stage: JobStage;
  done: number;
  total: number;
}

export const JOB_STAGE_LABEL: Record<JobStage, string> = {
  queued: 'فى الانتظار (عقود أخرى قيد التحليل)',
  reading: 'قراءة صفحات العقد الممسوح',
  rereading: 'إعادة قراءة الصفحات بدقة أعلى',
  recovering: 'استرجاع عناوين البنود الضائعة',
  segmenting: 'تقسيم العقد إلى بنود',
  assessing: 'تقييم البنود',
  verifying: 'التحقق المستقل من الملاحظات',
  contract_level: 'تحليل العقد ككل',
};

/** تحويل مرحلة القراءة الآلية إلى مرحلة المهمة */
export function stageFromOcr(stage: 'read' | 'reread' | 'recover'): JobStage {
  return stage === 'read' ? 'reading' : stage === 'reread' ? 'rereading' : 'recovering';
}

/** كم عقداً يُحلَّل معاً (الافتراضى 2) وكم ينتظر فى الطابور قبل رفض الجديد (الافتراضى 10) */
export function jobLimitsFromEnv(env: NodeJS.ProcessEnv = process.env): { maxConcurrent: number; maxQueued: number } {
  const int = (v: string | undefined, d: number, lo: number, hi: number): number => {
    const n = Number(v);
    return Number.isFinite(n) && n >= lo ? Math.min(Math.floor(n), hi) : d;
  };
  return {
    maxConcurrent: int(env.CONTRACTS_MAX_BACKGROUND, 2, 1, 8),
    maxQueued: int(env.CONTRACTS_MAX_QUEUED, 10, 0, 100),
  };
}

export class ContractJobs {
  private readonly progress = new Map<string, JobProgress>();
  private readonly waiting: Array<() => void> = [];
  private running = 0;

  constructor(
    private readonly maxConcurrent = 2,
    private readonly maxQueued = 10,
  ) {}

  has(id: string): boolean {
    return this.progress.has(id);
  }

  get(id: string): JobProgress | null {
    return this.progress.get(id) ?? null;
  }

  set(id: string, p: JobProgress): void {
    if (this.progress.has(id)) this.progress.set(id, p);
  }

  /** هل يتسع الطابور لمهمة جديدة؟ (تُفحص قبل إنشاء سجل العقد حتى لا يبقى سجل بلا مهمة) */
  hasCapacity(): boolean {
    return this.running < this.maxConcurrent || this.waiting.length < this.maxQueued;
  }

  get queued(): number {
    return this.waiting.length;
  }

  /** تتبع مهمة متزامنة (طلب HTTP واقف عليها) كى لا تُحسب يتيمة */
  async track<T>(id: string, task: () => Promise<T>): Promise<T> {
    this.progress.set(id, { stage: 'queued', done: 0, total: 0 });
    try {
      return await task();
    } finally {
      this.progress.delete(id);
    }
  }

  /**
   * تُجدوَل المهمة: تُسجَّل «فى الانتظار» فوراً ثم تعمل متى توفر موضع. لا تُرمى أخطاؤها (المهمة مسؤولة عن تسجيل فشلها)؛
   * أى استثناء غير ملتقَط يُمرَّر إلى onUnhandled ولا يُسقط العملية.
   */
  enqueue(id: string, task: () => Promise<void>, onUnhandled: (err: unknown) => void = () => undefined): void {
    this.progress.set(id, { stage: 'queued', done: 0, total: 0 });
    const run = async (): Promise<void> => {
      this.running++;
      try {
        await task();
      } catch (err) {
        onUnhandled(err);
      } finally {
        this.progress.delete(id);
        this.running--;
        this.waiting.shift()?.();
      }
    };
    if (this.running < this.maxConcurrent) {
      void run();
    } else {
      this.waiting.push(() => void run());
    }
  }
}
