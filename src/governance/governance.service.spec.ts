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
      // ⚠️ 2026-09-18 (طبقة النصيحة): حقل حقيقى فى assessCompliance الآن —
      // مُدرَج هنا فقط لمطابقة الشكل الواقعى؛ resolveConsensus لا يقرأه.
      conditions: string[];
      confidence: number;
    };

type Verdict = 'متوافق' | 'غير متوافق' | 'متوافق جزئياً' | 'معلومات غير كافية';

function ok(verdict: Verdict, confidence: number, riskNote = 'note'): Sample {
  return { status: 'ok', verdict, selectedIndices: [0], riskNote, conditions: [], confidence };
}

describe('GovernanceService.resolveConsensus (self-consistency)', () => {
  function buildService(): GovernanceService {
    const dataSource = { getRepository: () => ({}) } as never;
    const auditService = {} as never;
    const generationService = {} as never;
    const embeddingsService = {} as never;
    // ⚠️ 2026-09-18: طبقة النصيحة أضافت WebSearchFallbackService كتبعية خامسة
    // فى المُنشئ — mock فارغ هنا لأن resolveConsensus (موضوع هذا الملف) لا
    // يستخدمها إطلاقاً (نفس منطق التبعيات الأربع الأخرى أعلاه تماماً).
    const webFallbackService = {} as never;
    return new GovernanceService(dataSource, auditService, generationService, embeddingsService, webFallbackService);
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

/**
 * اختبار وحدة لـ buildRecommendation وattemptWebAdvisory (طبقة النصيحة،
 * 2026-09-18) — راجع تعليق كل منهما فى governance.service.ts للتصميم الكامل.
 * buildRecommendation دالة خالصة بلا I/O (يسهل اختبارها مباشرة بمدخلات
 * متنوعة)؛ attemptWebAdvisory تُختبَر هنا بتبعيات مُموَّهة (mock) للتحقق
 * تحديداً من ضمان fail-closed: أى فشل/عدم تفعيل فى الطبقة التكميلية يجب أن
 * يُرجع null بهدوء، لا أن يُلقى استثناءً يُسقِط استجابة /api/governance/assess
 * الأساسية.
 */
describe('GovernanceService.buildRecommendation (طبقة النصيحة — دالة خالصة)', () => {
  function buildService(): GovernanceService {
    const dataSource = { getRepository: () => ({}) } as never;
    const auditService = {} as never;
    const generationService = {} as never;
    const embeddingsService = {} as never;
    const webFallbackService = {} as never;
    return new GovernanceService(dataSource, auditService, generationService, embeddingsService, webFallbackService);
  }

  function recommend(
    verdict: Verdict,
    legalBasis: unknown[],
    riskNote: string,
    conditions: string[],
    confidence: number,
  ) {
    const service = buildService() as unknown as {
      buildRecommendation: (
        v: Verdict,
        lb: unknown[],
        rn: string,
        c: string[],
        conf: number,
      ) => Record<string, unknown> | null;
    };
    return service.buildRecommendation(verdict, legalBasis, riskNote, conditions, confidence);
  }

  it('"متوافق" → موصى به، basis_type=database، بلا شروط أو أجزاء مخالفة', () => {
    const basis = [{ law_no: 80, law_year: 2002, article_no: 12 }];
    const rec = recommend('متوافق', basis, 'يستوفى المتطلبات', [], 0.9);
    expect(rec).toMatchObject({
      advice: 'موصى به',
      basis_type: 'database',
      reasoning: 'يستوفى المتطلبات',
      confidence: 0.9,
      conditions_for_compliance: null,
      violated_provisions: null,
      web_sources: null,
      disclaimer: null,
    });
  });

  it('"غير متوافق" → غير موصى به، وviolated_provisions تساوى legal_basis نفسه (الأجزاء المخالفة)', () => {
    const basis = [{ law_no: 80, law_year: 2002, article_no: 12 }];
    const rec = recommend('غير متوافق', basis, 'يخالف المادة 12', [], 0.85);
    expect(rec?.advice).toBe('غير موصى به');
    expect(rec?.basis_type).toBe('database');
    expect(rec?.violated_provisions).toBe(basis);
    expect(rec?.conditions_for_compliance).toBeNull();
  });

  it('"غير متوافق" بلا legal_basis (حالة دفاعية نظرية) → violated_provisions=null لا مصفوفة فارغة', () => {
    const rec = recommend('غير متوافق', [], 'يخالف', [], 0.5);
    expect(rec?.violated_provisions).toBeNull();
  });

  it('"متوافق جزئياً" → موصى به بشرط (لا "غير موصى به" قسراً)، وconditions_for_compliance تحمل الشروط', () => {
    const conditions = ['استيفاء إخطار الجهة الرقابية خلال المهلة المتبقية'];
    const rec = recommend('متوافق جزئياً', [{ law_no: 1 }], 'يستوفى جوهر الالتزام مع تأخر إجرائى', conditions, 0.7);
    expect(rec?.advice).toBe('موصى به بشرط');
    expect(rec?.basis_type).toBe('database');
    expect(rec?.conditions_for_compliance).toEqual(conditions);
    expect(rec?.violated_provisions).toBeNull();
  });

  it('"متوافق جزئياً" بلا شروط مُستخرَجة (حالة دفاعية) → conditions_for_compliance=null لا []', () => {
    const rec = recommend('متوافق جزئياً', [], 'note', [], 0.5);
    expect(rec?.conditions_for_compliance).toBeNull();
  });

  it('"معلومات غير كافية" → null دائماً من buildRecommendation (لا أساس قاعدة بيانات كافٍ لتوصية)', () => {
    const rec = recommend('معلومات غير كافية', [], 'لا توجد مادة كافية', [], 0);
    expect(rec).toBeNull();
  });
});

describe('GovernanceService.attemptWebAdvisory (طبقة النصيحة التكميلية — fail-closed)', () => {
  function buildService(overrides: {
    webFallbackService?: Record<string, unknown>;
    generationService?: Record<string, unknown>;
  }): GovernanceService {
    const dataSource = { getRepository: () => ({}) } as never;
    const auditService = {} as never;
    const generationService = (overrides.generationService ?? {}) as never;
    const embeddingsService = {} as never;
    const webFallbackService = (overrides.webFallbackService ?? {}) as never;
    return new GovernanceService(dataSource, auditService, generationService, embeddingsService, webFallbackService);
  }

  function attempt(
    webFallbackService: Record<string, unknown>,
    generationService: Record<string, unknown> = {},
  ) {
    const service = buildService({ webFallbackService, generationService }) as unknown as {
      attemptWebAdvisory: (q: string, h: string) => Promise<Record<string, unknown> | null>;
    };
    return service.attemptWebAdvisory('سؤال اختبارى', 'hash1234');
  }

  it('غير مُفعَّلة (isConfigured=false) → null فوراً، بلا أى استدعاء بحث', async () => {
    const search = jest.fn();
    const result = await attempt({ isConfigured: false, searchAllowlisted: search });
    expect(result).toBeNull();
    expect(search).not.toHaveBeenCalled();
  });

  it('مُفعَّلة لكن لا مصادر مسموحة (searchAllowlisted يُعيد null) → null', async () => {
    const result = await attempt({
      isConfigured: true,
      searchAllowlisted: jest.fn().mockResolvedValue(null),
    });
    expect(result).toBeNull();
  });

  it('النموذج نفسه يقرِّر عدم كفاية مقتطفات الويب (composeGovernanceWebAdvisory يُعيد null) → null', async () => {
    const result = await attempt(
      {
        isConfigured: true,
        searchAllowlisted: jest.fn().mockResolvedValue([{ title: 't', url: 'https://fra.gov.eg/x', snippet: 's' }]),
      },
      { composeGovernanceWebAdvisory: jest.fn().mockResolvedValue(null) },
    );
    expect(result).toBeNull();
  });

  it('استثناء غير متوقَّع فى أى خطوة → fail-closed (null)، لا يتسرَّب الاستثناء', async () => {
    const result = await attempt({
      isConfigured: true,
      searchAllowlisted: jest.fn().mockRejectedValue(new Error('network down')),
    });
    expect(result).toBeNull();
  });

  it('مسار النجاح الكامل → recommendation بـbasis_type=web_supplementary وdisclaimer إلزامى ومصادر مُرفَقة', async () => {
    const sources = [{ title: 'مصدر رسمى', url: 'https://fra.gov.eg/x', snippet: 'مقتطف' }];
    const result = await attempt(
      { isConfigured: true, searchAllowlisted: jest.fn().mockResolvedValue(sources) },
      {
        composeGovernanceWebAdvisory: jest
          .fn()
          .mockResolvedValue({ advice: 'غير موصى به', reasoning: 'حسب المصدر [1]', confidence: 0.4 }),
      },
    );
    expect(result).toMatchObject({
      advice: 'غير موصى به',
      basis_type: 'web_supplementary',
      confidence: 0.4,
    });
    expect(result?.web_sources).toEqual(sources);
    expect(typeof result?.disclaimer).toBe('string');
    expect((result?.disclaimer as string).length).toBeGreaterThan(0);
  });
});
