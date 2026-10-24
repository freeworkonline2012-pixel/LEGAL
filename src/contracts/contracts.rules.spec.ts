import { ContractsService } from './contracts.service';

/**
 * ربط مسار القواعد بتقييم البند: الوقائع الموثَّقة ⇒ قواعد حتمية ⇒ حكم البند، بلا نداء لنموذج التقييم ولا استرجاع.
 * عند غياب وقائع أو عطلها يرجع البند للمسار العادى. بيانات مُصطنَعة بالكامل.
 */
const CLAUSE = 'يجوز للطرف الثانى فسخ العقد من جانب واحد إذا أخل الطرف الأول بالتزام جوهرى دون حاجة الى إنذار أو تنبيه، مع احتفاظه بحق التعويض.';
const FACTS = {
  termination: { mechanism: 'unilateral_right', holder: 'second', quote: 'يجوز للطرف الثانى فسخ العقد من جانب واحد' },
  notice: { state: 'waived_explicitly', quote: 'دون حاجة الى إنذار أو تنبيه' },
};

function build(factsOutcome: unknown, civilRows: unknown[] = [{ article_no: 158, short_title: 'القانون المدنى', title: 't', law_no: 131, law_year: 1948, official_url: null, body: 'نص المادة 158' }]) {
  const clauseRepo = { save: jest.fn().mockImplementation(async (c) => c), find: jest.fn() };
  const dataSource = {
    getRepository: jest.fn().mockImplementation((e: { name: string }) => (e.name === 'ContractClause' ? clauseRepo : { find: jest.fn() })),
    query: jest.fn().mockResolvedValue(civilRows),
  };
  const generation = { assessClause: jest.fn() };
  const facts = { isConfigured: true, extract: jest.fn() };
  if (Array.isArray(factsOutcome)) factsOutcome.forEach((o) => facts.extract.mockResolvedValueOnce(o));
  else facts.extract.mockResolvedValue(factsOutcome);
  const service = new ContractsService(
    dataSource as never,
    { record: jest.fn().mockResolvedValue(undefined) } as never,
    {} as never,
    {} as never,
    generation as never,
    {} as never,
    {} as never,
    facts as never,
    { isConfigured: false, analyze: jest.fn() } as never,
    { isConfigured: false } as never,
  );
  const row = { id: 'r1', contractId: 'c1', clauseIndex: 13, clauseLabel: 'البند الثالث عشر', clauseTitle: 'الفسخ', clauseText: CLAUSE } as never;
  return { service, generation, facts, clauseRepo, row, dataSource };
}
const ctx = { userId: 'u1', ipAddress: null, userAgent: null };
const call = (s: ContractsService, row: never, party: 'first' | 'second' | null) =>
  (s as unknown as { assessAndPersistClause: (r: never, c: typeof ctx, p: unknown) => Promise<void> }).assessAndPersistClause(
    row,
    ctx,
    { contractType: 'عقد برمجيات', clientRole: 'طالب الخدمة', clientParty: party },
  );

describe('assessAndPersistClause — مسار القواعد', () => {
  it('G1: إعفاء صريح من الإعذار والحق للعميل ⇒ سليم بالمادة 158، ولا نداء لنموذج التقييم', async () => {
    const { service, generation, row, clauseRepo } = build({ status: 'ok', facts: FACTS });
    await call(service, row, 'second');
    const r = row as unknown as Record<string, unknown>;
    expect(r.assessmentStatus).toBe('سليم');
    expect(String(r.assessmentReasoning)).toContain('158');
    expect((r.matchedArticles as Array<{ article_no: number }>)[0].article_no).toBe(158);
    expect(r.riskLevel).toBeNull();
    expect(generation.assessClause).not.toHaveBeenCalled();
    expect(clauseRepo.save).toHaveBeenCalled();
    expect((r.ruleFindings as unknown[]).length).toBeGreaterThan(0);
    expect((r.facts as { termination: unknown }).termination).toBeDefined();
  });

  it('الحق للطرف المقابل ⇒ يحتاج مراجعة بدرجة متوسطة', async () => {
    const { service, row } = build({ status: 'ok', facts: FACTS });
    await call(service, row, 'first');
    const r = row as unknown as Record<string, unknown>;
    expect(r.assessmentStatus).toBe('يحتاج مراجعة');
    expect(r.riskLevel).toBe('متوسط');
  });

  it('تعطل استخراج الوقائع (مرتين) ⇒ يرجع للمسار العادى بلا إسقاط البند', async () => {
    const { service, row, generation, facts } = build([{ status: 'error', detail: 'x' }, { status: 'error', detail: 'x' }]);
    generation.assessClause.mockResolvedValue({ status: 'error', detail: 'x' });
    // المسار العادى يحتاج استرجاعاً لم نُحلّه هنا ⇒ يسقط إلى catch ويعلّم البند للمراجعة البشرية
    await call(service, row, 'second');
    expect(facts.extract).toHaveBeenCalledTimes(2);
    expect((row as unknown as Record<string, unknown>).assessmentStatus).toBe('يحتاج مراجعة');
  });

  it('لا وقائع موثَّقة ⇒ لا تُطبَّق قاعدة', async () => {
    const { service, row, facts } = build({ status: 'ok', facts: {} });
    await call(service, row, 'second');
    expect(facts.extract).toHaveBeenCalledTimes(1);
    expect((row as unknown as Record<string, unknown>).ruleFindings ?? null).toBeNull();
  });

  it('لا مادة مفهرَسة للقاعدة ⇒ لا حكم من القواعد', async () => {
    const { service, row } = build({ status: 'ok', facts: FACTS }, []);
    await call(service, row, 'second');
    expect((row as unknown as Record<string, unknown>).assessmentStatus).not.toBe('سليم');
  });
});
