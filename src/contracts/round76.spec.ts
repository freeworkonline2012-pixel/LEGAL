import { ATTORNEY_FEE_CONTRACT_CONTEXT, contractContextFor } from './criteria.util';
import { formatClauseOutcome, formatClauseVerdict, verdictCode } from './retrieval-diagnostic';
import { DeepseekGenerationService } from '../llm/deepseek-generation.service';

describe('round 76: سياق العقد للنموذج + حكمه الخام فى التشخيص', () => {
  it('contractContextFor: سياق عقد الأتعاب فقط، وغيره null (بلا تغيير لبقية العقود)', () => {
    expect(contractContextFor(true)).toBe(ATTORNEY_FEE_CONTRACT_CONTEXT);
    expect(contractContextFor(false)).toBeNull();
    expect(ATTORNEY_FEE_CONTRACT_CONTEXT).toContain('17 لسنة 1983');
  });

  it('verdictCode: رموز ASCII ثابتة', () => {
    expect(verdictCode('سليم')).toBe('sound');
    expect(verdictCode('يحتاج مراجعة')).toBe('needs_review');
    expect(verdictCode('لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة')).toBe('no_text');
    expect(verdictCode('x')).toBe('other');
  });

  it('formatClauseOutcome: يلحق الحكم الخام دون أى نص عقد', () => {
    const line = formatClauseOutcome({
      clauseIndex: 2,
      outcome: 'model_no_text',
      reranked: true,
      topCandidates: 5,
      selected: 0,
      assessmentStatus: 'x',
      topIds: '17/1983#82',
      verdict: { label: 'سليم', rawSelected: 0, validSelected: 0, violationType: 'none', confidence: 0.4, contextGiven: true },
    });
    expect(line).toContain('verdict=sound rawSelected=0 validSelected=0 violation=none conf=0.40 ctx=true');
    expect(line).not.toMatch(/[؀-ۿ]/);
  });

  it('formatClauseOutcome: بلا حكم لا لاحقة (التوافق مع الجولات السابقة)', () => {
    const line = formatClauseOutcome({ clauseIndex: 1, outcome: 'rules', reranked: null, topCandidates: 0, selected: 0, assessmentStatus: 'x', topIds: '-' });
    expect(line).not.toContain('verdict=');
    expect(formatClauseVerdict({ label: 'يحتاج مراجعة', rawSelected: 1, validSelected: 1, violationType: 'none', confidence: NaN, contextGiven: false })).toContain('conf=-');
  });
});

describe('round 76: assessClause يحمل سياق العقد كبيانات ويبقى النظام كما كان بلا سياق', () => {
  const CANDIDATE = { lawTitle: 'قانون المحاماة', lawNo: 17, lawYear: 1983, articleNo: 82, articleText: 'للمحامي الحق في تقاضي أتعاب' };
  const OK = '{"assessment":"سليم","selected":[1],"reasoning":"ج","confidence":0.6}';
  const original = global.fetch;
  afterEach(() => {
    global.fetch = original;
  });
  const call = async (contractContext?: string | null) => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    const service = new DeepseekGenerationService();
    const fetchMock = jest.fn().mockResolvedValue({
      ok: true,
      status: 200,
      json: async () => ({ choices: [{ message: { content: OK }, finish_reason: 'stop' }] }),
      text: async () => '',
    });
    global.fetch = fetchMock as unknown as typeof fetch;
    await service.assessClause({ clauseText: 'تسدد الشركة مبلغاً شهرياً', contractContext, candidates: [CANDIDATE] });
    const body = JSON.parse((fetchMock.mock.calls[0][1] as { body: string }).body) as { messages: Array<{ role: string; content: string }> };
    return { system: body.messages.find((m) => m.role === 'system')!.content, user: body.messages.find((m) => m.role === 'user')!.content };
  };

  it('مع السياق: يظهر فى رسالة المستخدم وتظهر قاعدته فى النظام مع بقاء الضوابط', async () => {
    const { system, user } = await call(ATTORNEY_FEE_CONTRACT_CONTEXT);
    expect(user).toContain(`سياق العقد: """${ATTORNEY_FEE_CONTRACT_CONTEXT}"""`);
    expect(system).toContain('سياق العقد: إن ورد');
    expect(system).toContain('لا تعتمد مادة إلا إن كان نصها المعروض يحكم موضوع الفقرة فعلاً');
  });

  it('بلا سياق: لا سطر ولا قاعدة (النظام والرسالة كما قبل الجولة)', async () => {
    const withNone = await call(null);
    const undef = await call(undefined);
    expect(withNone.user).not.toContain('سياق العقد:');
    expect(withNone.system).not.toContain('سياق العقد: إن ورد');
    expect(undef.system).toBe(withNone.system);
  });
});
