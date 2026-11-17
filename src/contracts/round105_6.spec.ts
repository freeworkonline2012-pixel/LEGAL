import { ContractsService } from './contracts.service';
import { ClauseVerifierService } from './clause-verifier.service';
import {
  ASSESSMENT_FAILED_REASONING,
  ASSESSMENT_NOT_CONFIGURED_REASONING,
  PROVIDER_FATAL_USER_MESSAGE,
  ProviderFatalError,
  VERIFIER_FAILED_REASON,
  fatalProviderDetail,
  isAssessmentTechnicalFailure,
  isFatalProviderDetail,
} from './provider-failure';
import { verifierFailedVerification } from './verification';

const ok = { status: 'ok', assessment: 'سليم', selectedIndices: [0], reasoning: 'ش', confidence: 0.8, violationType: 'none', mandatoryQuote: '' };

describe('الجولة 105.6 — أعطال المزود القاتلة تُوقف التحليل ولا تُبتلع', () => {
  it('التمييز بين القاتل (401/402) والعابر (429/5xx/مهلة/رد غير مقروء)', () => {
    expect(isFatalProviderDetail('http_402')).toBe(true);
    expect(isFatalProviderDetail('http_401')).toBe(true);
    for (const d of ['http_429', 'http_500', 'http_503', 'empty_response', 'unparseable_json', 'invalid_verdict', 'fetch failed', 'http_4020', null, undefined]) {
      expect(isFatalProviderDetail(d as never)).toBe(false);
    }
    expect(fatalProviderDetail([{ status: 'ok' }, { status: 'error', detail: 'http_500' }])).toBeNull();
    expect(fatalProviderDetail([{ status: 'ok' }, { status: 'error', detail: 'http_402' }])).toBe('http_402');
    // عطل قاتل فى «ok» مستحيل: لا يُقرأ إلا من status=error
    expect(fatalProviderDetail([{ status: 'ok', detail: 'http_402' }])).toBeNull();
  });

  describe('assessWithVote', () => {
    const mk = (results: unknown[]) => {
      const s = Object.create(ContractsService.prototype) as unknown as {
        generationService: { assessClause: jest.Mock };
        logger: { log: jest.Mock; warn: jest.Mock };
        assessWithVote(req: unknown, i: number): Promise<unknown>;
      };
      let n = 0;
      s.generationService = { assessClause: jest.fn(async () => results[n++ % results.length]) };
      s.logger = { log: jest.fn(), warn: jest.fn() };
      return s;
    };
    const OLD = process.env.CONTRACT_ASSESS_SAMPLES;
    afterEach(() => {
      if (OLD === undefined) delete process.env.CONTRACT_ASSESS_SAMPLES;
      else process.env.CONTRACT_ASSESS_SAMPLES = OLD;
    });

    it('402 فى كل العيّنات ⇒ ProviderFatalError بمرحلة وبند (لا نتيجة error هادئة)', async () => {
      delete process.env.CONTRACT_ASSESS_SAMPLES;
      const s = mk([{ status: 'error', detail: 'http_402' }]);
      await expect(s.assessWithVote({ clauseText: 'ن', candidates: [] }, 17)).rejects.toMatchObject({ name: 'ProviderFatalError', detail: 'http_402', stage: 'assess clause=17' });
      expect(s.generationService.assessClause).toHaveBeenCalledTimes(3);
    });

    it('402 فى عيّنة واحدة وباقى العيّنات سليمة ⇒ يُوقَف أيضاً (الرصيد نفد لتوّه)', async () => {
      delete process.env.CONTRACT_ASSESS_SAMPLES;
      const s = mk([ok, ok, { status: 'error', detail: 'http_402' }]);
      await expect(s.assessWithVote({ clauseText: 'ن', candidates: [] }, 3)).rejects.toBeInstanceOf(ProviderFatalError);
    });

    it('عطل عابر (500/429) كما كان: نتيجة error للبند وحده، لا رمى', async () => {
      delete process.env.CONTRACT_ASSESS_SAMPLES;
      const s = mk([{ status: 'error', detail: 'http_500' }, { status: 'error', detail: 'http_429' }, { status: 'error', detail: 'http_500' }]);
      const out = (await s.assessWithVote({ clauseText: 'ن', candidates: [] }, 3)) as { status: string };
      expect(out.status).toBe('error');
    });

    it('عيّنة واحدة (CONTRACT_ASSESS_SAMPLES=1): 401 يوقف كذلك', async () => {
      process.env.CONTRACT_ASSESS_SAMPLES = '1';
      const s = mk([{ status: 'error', detail: 'http_401' }]);
      await expect(s.assessWithVote({ clauseText: 'ن', candidates: [] }, 1)).rejects.toBeInstanceOf(ProviderFatalError);
    });
  });

  describe('assessAndPersistClause لا يبتلع العطل القاتل', () => {
    it('الاستثناء القاتل يخرج من catch الخارجى؛ والعادى يبقى fail-closed للبند', async () => {
      const mk = (thrown: Error) => {
        const s = Object.create(ContractsService.prototype) as unknown as Record<string, unknown> & {
          assessAndPersistClause(row: Record<string, unknown>, ctx: unknown, pos: unknown): Promise<void>;
        };
        s.logger = { log: jest.fn(), warn: jest.fn() };
        s.safeDiag = jest.fn();
        s.clauseRepository = { save: jest.fn(async (r: unknown) => r) };
        // أول نداء داخل try: التصنيف يجرى حتمياً ثم tryRuleAssessment (داخل try داخلى) ثم الاسترجاع: نرمى منه
        s.tryRuleAssessment = jest.fn(async () => false);
        s.ftsCandidates = jest.fn(async () => {
          throw thrown;
        });
        s.semanticCandidates = jest.fn(async () => []);
        return s;
      };
      const row = () => ({ contractId: 'c', clauseIndex: 2, clauseTitle: null, clauseText: 'يلتزم الشريك بسداد حصته.', assessmentStatus: null, assessmentReasoning: null });
      const fatal = mk(new ProviderFatalError('http_402', 'x'));
      await expect(fatal.assessAndPersistClause(row(), {}, { contractType: null, clientRole: null, clientParty: null })).rejects.toBeInstanceOf(ProviderFatalError);
      const normal = mk(new Error('db down'));
      const r = row();
      await normal.assessAndPersistClause(r, {}, { contractType: null, clientRole: null, clientParty: null });
      expect(r.assessmentStatus).toBe('يحتاج مراجعة');
      expect(isAssessmentTechnicalFailure(r.assessmentReasoning)).toBe(true);
    });
  });

  describe('processUpload: حالة صريحة ورسالة مقروءة، لا تقرير', () => {
    it('ProviderFatalError ⇒ extraction_failed + رسالة المزود + تدقيق، وبلا بنود', async () => {
      const contract = { id: 'c1', status: 'processing', extractionError: null, originalFilename: 'a.pdf', clauseCount: 50 };
      const s = Object.create(ContractsService.prototype) as unknown as Record<string, unknown> & {
        processUpload(...a: unknown[]): Promise<{ status: string; extraction_error: string | null; clauses: unknown[] }>;
      };
      s.logger = { log: jest.fn(), warn: jest.fn(), error: jest.fn() };
      s.analyzeUpload = jest.fn(async () => {
        throw new ProviderFatalError('http_402', 'assess clause=34');
      });
      s.contractRepository = { findOne: jest.fn(async () => ({ ...contract })), save: jest.fn(async (c: unknown) => c) };
      const audit = jest.fn();
      s.audit = audit;
      const res = await s.processUpload(contract, { buffer: Buffer.from('x'), mimetype: 'application/pdf', originalname: 'a.pdf' }, { userId: 'u', ipAddress: null, userAgent: null }, { contractType: null, clientRole: null, clientParty: null }, true);
      expect(res.status).toBe('extraction_failed');
      expect(res.extraction_error).toBe(PROVIDER_FATAL_USER_MESSAGE);
      expect(res.clauses).toEqual([]);
      expect(audit).toHaveBeenCalledWith(expect.anything(), 'contracts.provider_fatal', 'c1', { stage: 'assess clause=34', detail: 'http_402' });
    });

    it('استثناء غير قاتل يعاد رميه كما كان (يلتقطه runBackgroundJob)', async () => {
      const s = Object.create(ContractsService.prototype) as unknown as Record<string, unknown> & { processUpload(...a: unknown[]): Promise<unknown> };
      s.logger = { error: jest.fn() };
      s.analyzeUpload = jest.fn(async () => {
        throw new Error('boom');
      });
      await expect(s.processUpload({ id: 'c' }, {}, {}, {}, true)).rejects.toThrow('boom');
    });
  });

  describe('المدقق', () => {
    const realFetch = global.fetch;
    beforeEach(() => {
      process.env.DEEPSEEK_API_KEY = 'k';
      delete process.env.CONTRACT_VERIFIER_ENABLED;
    });
    afterEach(() => {
      global.fetch = realFetch;
    });
    const input = { clauseText: 'نص البند', claim: 'ملاحظة', clientPosition: 'عميل', articles: [] };

    it('402 فى المدقق (بعد اكتمال التقييم) ⇒ ProviderFatalError لا نتيجة error', async () => {
      global.fetch = jest.fn().mockResolvedValue({ ok: false, status: 402, json: async () => ({}) }) as never;
      await expect(new ClauseVerifierService().verifyAssessment(input)).rejects.toMatchObject({ detail: 'http_402', stage: 'verifier' });
    });

    it('500 فى المدقق ⇒ error عادى كما كان', async () => {
      global.fetch = jest.fn().mockResolvedValue({ ok: false, status: 500, json: async () => ({}) }) as never;
      expect((await new ClauseVerifierService().verifyAssessment(input)).status).toBe('error');
    });

    const mkSvc = (verifier: unknown) => {
      const s = Object.create(ContractsService.prototype) as unknown as Record<string, unknown> & {
        verifyClauseFlags(rows: unknown[], p: unknown): Promise<void>;
        verifyContractFindings(l: unknown, rows: unknown[]): Promise<void>;
      };
      s.logger = { log: jest.fn(), warn: jest.fn() };
      s.verifierService = verifier;
      s.clauseRepository = { save: jest.fn(async (r: unknown) => r) };
      return s;
    };
    const row = (i: number) => ({
      clauseIndex: i, clauseLabel: `م${i}`, clauseText: 'نص', assessmentStatus: 'يحتاج مراجعة', riskLevel: 'عالٍ', assessmentReasoning: 'ملاحظة',
      matchedArticles: [{ law: 'ق', article_no: 1, snippet: 'م' }], ruleFindings: null, verification: null as unknown,
    });
    const pos = { contractType: null, clientRole: null, clientParty: null };

    it('verifyClauseFlags: status=error ⇒ الملاحظة غير مؤكدة بسبب صريح ويستمر ما بعدها', async () => {
      const verifyAssessment = jest
        .fn()
        .mockResolvedValueOnce({ status: 'error', detail: 'http_500' })
        .mockResolvedValueOnce({ status: 'ok', verification: { status: 'confirmed', basis: 'confirmed', reason: 'ر', quote: null, quoteSource: null, verifiedAt: 't' } });
      const s = mkSvc({ isConfigured: true, verifyAssessment });
      const rows = [row(1), row(2)];
      await s.verifyClauseFlags(rows, pos);
      expect(rows[0].verification).toMatchObject({ status: 'unconfirmed', basis: 'uncertain', reason: VERIFIER_FAILED_REASON });
      expect(rows[1].verification).toMatchObject({ status: 'confirmed' });
    });

    it('verifyClauseFlags: ProviderFatalError يخرج ولا يُبتلع', async () => {
      const verifyAssessment = jest.fn().mockRejectedValue(new ProviderFatalError('http_402', 'verifier'));
      const s = mkSvc({ isConfigured: true, verifyAssessment });
      await expect(s.verifyClauseFlags([row(1), row(2)], pos)).rejects.toBeInstanceOf(ProviderFatalError);
      expect(verifyAssessment).toHaveBeenCalledTimes(1);
    });

    it('verifyContractFindings: error أو استثناء عادى ⇒ وسم تعذّر المدقق؛ والقاتل يخرج', async () => {
      const level = () => ({ findings: [{ id: 'a', kind: 'conflict', severity: 'متوسط', source: 'model', title: 't', explanation: 'e', evidence: [] as unknown[], verification: undefined as unknown }] });
      let l = level();
      await mkSvc({ isConfigured: true, verifyFinding: jest.fn().mockResolvedValue({ status: 'error', detail: 'http_503' }) }).verifyContractFindings(l, [row(1)]);
      expect(l.findings[0].verification).toMatchObject({ status: 'unconfirmed', reason: VERIFIER_FAILED_REASON });
      l = level();
      await mkSvc({ isConfigured: true, verifyFinding: jest.fn().mockRejectedValue(new Error('x')) }).verifyContractFindings(l, [row(1)]);
      expect(l.findings[0].verification).toMatchObject({ status: 'unconfirmed', reason: VERIFIER_FAILED_REASON });
      l = level();
      await expect(mkSvc({ isConfigured: true, verifyFinding: jest.fn().mockRejectedValue(new ProviderFatalError('http_402', 'verifier')) }).verifyContractFindings(l, [row(1)])).rejects.toBeInstanceOf(ProviderFatalError);
    });

    it('مراجعة الدحض الثانية: العطل القاتل يخرج، والعادى يُبقى المرشحة', async () => {
      const dismissed = { status: 'unconfirmed', basis: 'refuted', refutationKind: 'clause_addresses', reason: 'ر', quote: 'ن', quoteSource: 'clause', verifiedAt: 't' };
      const lvl = () => ({ findings: [{ id: 'a', kind: 'open_term', severity: 'عالٍ', source: 'model', title: 't', explanation: 'e', evidence: [] as unknown[], verification: undefined as unknown }] });
      const l = lvl();
      await expect(
        mkSvc({ isConfigured: true, verifyFinding: jest.fn().mockResolvedValueOnce({ status: 'ok', verification: dismissed }).mockRejectedValueOnce(new ProviderFatalError('http_402', 'verifier')) }).verifyContractFindings(l, [row(1)]),
      ).rejects.toBeInstanceOf(ProviderFatalError);
    });
  });

  describe('تحليل العقد ككل', () => {
    it('402 من محلل الاتساق ⇒ ProviderFatalError (لا model=error صامت)', async () => {
      const s = Object.create(ContractsService.prototype) as unknown as Record<string, unknown> & { analyzeContractLevel(...a: unknown[]): Promise<unknown> };
      s.logger = { log: jest.fn(), warn: jest.fn() };
      s.safeDiag = jest.fn();
      s.consistencyService = { analyze: jest.fn(async () => ({ status: 'error', detail: 'http_402' })) };
      const rows = [
        { clauseIndex: 1, clauseLabel: 'أ', clauseTitle: null, clauseText: 'ترخيص استخدام النظام لمدة هذا العقد.' },
        { clauseIndex: 2, clauseLabel: 'ب', clauseTitle: null, clauseText: 'تحدد رسوم الاستضافة بعد التنفيذ.' },
      ];
      await expect(s.analyzeContractLevel(rows, null, [])).rejects.toMatchObject({ stage: 'contract-level' });
    });
    it('500 من محلل الاتساق ⇒ model=error كما كان', async () => {
      const s = Object.create(ContractsService.prototype) as unknown as Record<string, unknown> & { analyzeContractLevel(...a: unknown[]): Promise<{ model: string }> };
      s.logger = { log: jest.fn(), warn: jest.fn() };
      s.safeDiag = jest.fn();
      s.consistencyService = { analyze: jest.fn(async () => ({ status: 'error', detail: 'http_500' })) };
      const rows = [
        { clauseIndex: 1, clauseLabel: 'أ', clauseTitle: null, clauseText: 'ترخيص استخدام النظام لمدة هذا العقد.' },
        { clauseIndex: 2, clauseLabel: 'ب', clauseTitle: null, clauseText: 'تحدد رسوم الاستضافة بعد التنفيذ.' },
      ];
      expect((await s.analyzeContractLevel(rows, null, [])).model).toBe('error');
    });
  });

  it('نصا فشل التقييم يتعرف عليهما التقرير، ونص عادى لا', () => {
    expect(isAssessmentTechnicalFailure(`${ASSESSMENT_FAILED_REASONING} — يلزم مراجعة قانونية بشرية.`)).toBe(true);
    expect(isAssessmentTechnicalFailure(`${ASSESSMENT_FAILED_REASONING} لهذا البند — يلزم`)).toBe(true);
    expect(isAssessmentTechnicalFailure(`${ASSESSMENT_NOT_CONFIGURED_REASONING} حالياً على هذه البيئة`)).toBe(true);
    expect(isAssessmentTechnicalFailure('يخالف البند حكم المادة 224.')).toBe(false);
    expect(isAssessmentTechnicalFailure(null)).toBe(false);
    expect(verifierFailedVerification()).toMatchObject({ status: 'unconfirmed', basis: 'uncertain', quote: null });
  });
});
