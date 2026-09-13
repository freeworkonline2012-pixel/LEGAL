import { GovernanceService } from './governance.service';

/**
 * اختبار وحدة لـ resolveConsensus (2026-09-13) — الإصلاح الجذرى لعدم-حتمية
 * DeepSeek الموثَّق فى تعليق استدعائها داخل assess(): استبدال عيّنة واحدة
 * غير موثوقة بتصويت أغلبية على عيّنات مستقلة متعددة. هذا اختبار حقيقى
 * لمنطق القرار نفسه (لا افتراض أن التعليق التوثيقى كافٍ) — يغطى بالتحديد
 * الحالات التى صُمِّمت الدالة من أجلها: أغلبية واضحة، انقسام تام بلا
 * أغلبية (يجب أن يفشل بأمان لـ"معلومات غير كافية" لا تخميناً)، وفشل كل
 * العيّنات (يُمرَّر بلا تعديل لمسارات fail-closed القديمة أسفل assess()).
 *
 * الدالة private — تُستدعى عبر (service as any) عمداً، بلا تغيير فى واجهة
 * الإنتاج العامة، وهو نمط اختبار مقبول لمنطق داخلى بحت لا يعتمد على أى من
 * تبعيات الحقن (dataSource/auditService/generationService/embeddingsService
 * كلها بلا استخدام فعلى داخل resolveConsensus نفسها).
 */

type Sample =
  | { status: 'not_configured' }
  | { status: 'error'; detail: string }
  | {
      status: 'ok';
      verdict: 'متوافق' | 'غير متوافق' | 'متوافق جزئياً' | 'معلومات غير كافية';
      selectedIndices: number[];
      riskNote: string;
      confidence: number;
    };

type Verdict = 'متوافق' | 'غير متوافق' | 'متوافق جزئياً' | 'معلومات غير كافية';

function ok(verdict: Verdict, confidence: number, riskNote = 'note'): Sample {
  return { status: 'ok', verdict, selectedIndices: [0], riskNote, confidence };
}

describe('GovernanceService.resolveConsensus (self-consistency)', () => {
  function buildService(): GovernanceService {
    const dataSource = { getRepository: () => ({}) } as never;
    const auditService = {} as never;
    const generationService = {} as never;
    const embeddingsService = {} as never;
    return new GovernanceService(dataSource, auditService, generationService, embeddingsService);
  }

  function resolve(samples: Sample[]) {
    const service = buildService() as unknown as {
      resolveConsensus: (s: Sample[]) => { selection: Sample; consensusDetail: string };
    };
    return service.resolveConsensus(samples);
  }

  it('يختار الحكم الذى اتفقت عليه أغلبية واضحة (2 من 3)', () => {
    const samples: Sample[] = [
      ok('غير متوافق', 0.6),
      ok('غير متوافق', 0.9),
      ok('معلومات غير كافية', 0.3),
    ];
    const { selection, consensusDetail } = resolve(samples);
    expect(selection.status).toBe('ok');
    if (selection.status === 'ok') {
      expect(selection.verdict).toBe('غير متوافق');
      // من بين المتفقين، الأعلى ثقة (0.9) هى المُختارة كممثل
      expect(selection.confidence).toBe(0.9);
    }
    expect(consensusDetail).toContain('2/3');
  });

  it('إجماع كامل (3/3) يُختار مباشرة دون غموض', () => {
    const samples: Sample[] = [ok('متوافق', 0.7), ok('متوافق', 0.8), ok('متوافق', 0.5)];
    const { selection, consensusDetail } = resolve(samples);
    expect(selection.status).toBe('ok');
    if (selection.status === 'ok') expect(selection.verdict).toBe('متوافق');
    expect(consensusDetail).toContain('3/3');
  });

  it('انقسام تام بلا أغلبية (3 أحكام مختلفة) → fail-closed لـ"معلومات غير كافية" لا تخميناً', () => {
    const samples: Sample[] = [ok('متوافق', 0.9), ok('غير متوافق', 0.9), ok('متوافق جزئياً', 0.9)];
    const { selection, consensusDetail } = resolve(samples);
    expect(selection.status).toBe('ok');
    if (selection.status === 'ok') {
      expect(selection.verdict).toBe('معلومات غير كافية');
      expect(selection.confidence).toBe(0);
    }
    expect(consensusDetail).toContain('انقسام بلا أغلبية');
  });

  it('عيّنة صالحة واحدة فقط من أصل 3 (فشلت اثنتان) — لا أغلبية ممكنة، تُستخدم كما هى', () => {
    const samples: Sample[] = [
      ok('متوافق جزئياً', 0.5),
      { status: 'error', detail: 'http_500' },
      { status: 'error', detail: 'unparseable_json' },
    ];
    const { selection } = resolve(samples);
    expect(selection.status).toBe('ok');
    if (selection.status === 'ok') expect(selection.verdict).toBe('متوافق جزئياً');
  });

  it('فشل كل العيّنات (not_configured) — تُمرَّر أول عيّنة كما هى لمسار fail-closed القديم', () => {
    const samples: Sample[] = [
      { status: 'not_configured' },
      { status: 'not_configured' },
      { status: 'not_configured' },
    ];
    const { selection, consensusDetail } = resolve(samples);
    expect(selection.status).toBe('not_configured');
    expect(consensusDetail).toContain('0/3');
  });

  it('فشل كل العيّنات (error) — نفس المبدأ، أول عيّنة كما هى بلا تخمين', () => {
    const samples: Sample[] = [
      { status: 'error', detail: 'http_500' },
      { status: 'error', detail: 'http_500' },
    ];
    const { selection } = resolve(samples);
    expect(selection.status).toBe('error');
  });

  it('تعادل ثنائى بلا أغلبية (عيّنتان فقط، حكمان مختلفان) → fail-closed', () => {
    const samples: Sample[] = [ok('متوافق', 0.9), ok('غير متوافق', 0.9)];
    const { selection } = resolve(samples);
    expect(selection.status).toBe('ok');
    if (selection.status === 'ok') expect(selection.verdict).toBe('معلومات غير كافية');
  });
});
