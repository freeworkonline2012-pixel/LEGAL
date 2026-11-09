import { ContractsService } from './contracts.service';
import { lawScopeContext } from './law-scope';

/** الجولة 73: سجل التشخيص يُكتب لكل بند، بأعداد فقط، ولا يغيّر نتيجة التقييم. */
describe('round 73 retrieval diagnostic wiring', () => {
  const SECRET = 'نص-سرى-للعقد-لا-يجوز-تسجيله';

  function build(opts: { fts: unknown[]; sem: unknown[]; semConfigured: boolean }) {
    const svc = Object.create(ContractsService.prototype) as any;
    const lines: string[] = [];
    svc.logger = { log: (m: string) => lines.push(m), warn: (m: string) => lines.push(`WARN ${m}`), error: jest.fn() };
    svc.clauseRepository = { save: jest.fn(async (r: unknown) => r) };
    svc.auditService = { log: jest.fn() };
    svc.audit = jest.fn(async () => undefined);
    svc.factsService = { isConfigured: false };
    svc.embeddingsService = { isConfigured: opts.semConfigured, rerank: jest.fn(async () => null) };
    svc.generationService = {
      assessClause: jest.fn(async () => ({ status: 'ok', assessment: 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة', reasoning: '', selectedIndices: [], confidence: 0.2, violationType: 'none', mandatoryQuote: null })),
    };
    svc.ftsCandidates = jest.fn(async () => opts.fts);
    svc.semanticCandidates = jest.fn(async () => opts.sem);
    svc.anchorCandidates = jest.fn(async () => []);
    return { svc, lines };
  }

  const cand = (lawNo: number, lawYear: number, articleNo: number, source: 'fts' | 'semantic') => ({
    citation: { law: 'x', lawNo, lawYear, articleNo, snippet: 'مادة', officialUrl: null },
    confidence: 0.5,
    source,
  });

  const row = () => ({ contractId: 'c1', clauseIndex: 2, clauseTitle: null, clauseText: `${SECRET} مقابل أتعاب المحاماة`, clauseTypeGuess: null } as any);
  const ctx = { userId: 'u', ipAddress: null, userAgent: null };
  const position = { contractType: null } as any;

  it('empty retrieval logs counts and outcome=empty_retrieval, status unchanged', async () => {
    const { svc, lines } = build({ fts: [], sem: [], semConfigured: false });
    const r = row();
    await svc.assessAndPersistClause(r, ctx, position, lawScopeContext(r.clauseText, null));
    expect(r.assessmentStatus).toBe('لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة');
    const stage = lines.find((l) => l.includes('stage=retrieval'))!;
    expect(stage).toContain('fts=0 semConfigured=false sem=0 merged=0');
    expect(lines.some((l) => l.includes('stage=outcome clause=2 outcome=empty_retrieval'))).toBe(true);
    expect(lines.join('\n')).not.toContain(SECRET);
  });

  it('gate drops are counted (sector law 176/2018 with no signal) and model_no_text outcome is reported', async () => {
    const { svc, lines } = build({ fts: [cand(176, 2018, 65, 'fts')], sem: [cand(131, 1948, 699, 'semantic')], semConfigured: true });
    const r = row();
    await svc.assessAndPersistClause(r, ctx, position, lawScopeContext(r.clauseText, null));
    const stage = lines.find((l) => l.includes('stage=retrieval'))!;
    expect(stage).toContain('merged=2 droppedByFamily=0 droppedByLawScope=1 kept=1');
    expect(stage).toContain('droppedLaws=176/2018x1');
    const out = lines.find((l) => l.includes('stage=outcome'))!;
    expect(out).toContain('outcome=model_no_text');
    expect(out).toContain('topCandidates=1');
    expect(lines.join('\n')).not.toContain(SECRET);
  });

  it('a throwing diagnostic never breaks assessment', async () => {
    const { svc } = build({ fts: [], sem: [], semConfigured: true });
    svc.logger.log = () => {
      throw new Error('log sink down');
    };
    const r = row();
    await svc.assessAndPersistClause(r, ctx, position, lawScopeContext(r.clauseText, null));
    expect(r.assessmentStatus).toBe('لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة');
  });
});
