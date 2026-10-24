import { ClauseVerifierService } from './clause-verifier.service';

const CLAUSE = 'يجوز للطرف الثانى فسخ العقد دون حاجة إلى إنذار أو تنبيه إذا أخل الطرف الأول بالتزام جوهرى.';
const reply = (content: unknown, ok = true, status = 200) =>
  jest.fn().mockResolvedValue({ ok, status, json: async () => ({ choices: [{ message: { content: typeof content === 'string' ? content : JSON.stringify(content) } }] }) });
const input = {
  clauseText: CLAUSE,
  claim: 'لا يوجد اتفاق صريح على الإعفاء من الإعذار.',
  clientPosition: 'طالب الخدمة',
  articles: [{ lawTitle: 'القانون المدنى', articleNo: 158, articleText: 'يجوز الاتفاق على أن يعتبر العقد مفسوخاً من تلقاء نفسه دون حاجة إلى حكم قضائى.' }],
};

describe('ClauseVerifierService', () => {
  const realFetch = global.fetch;
  const env = { ...process.env };
  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'k';
    delete process.env.CONTRACT_VERIFIER_ENABLED;
  });
  afterEach(() => {
    global.fetch = realFetch;
    process.env = { ...env };
  });

  it('G1: المدقق المعاكس يدحض ملاحظة خاطئة باقتباس حرفى من البند فتصير غير مؤكدة', async () => {
    global.fetch = reply({ verdict: 'refuted', counter_quote: 'دون حاجة إلى إنذار أو تنبيه', reason: 'البند يعفى صراحة من الإنذار.' }) as never;
    const out = await new ClauseVerifierService().verifyAssessment(input);
    expect(out.status).toBe('ok');
    if (out.status === 'ok') expect(out.verification).toMatchObject({ status: 'unconfirmed', basis: 'refuted', quoteSource: 'clause' });
  });

  it('الاعتراض بلا اقتباس موثَّق لا يُعتد به', async () => {
    global.fetch = reply({ verdict: 'refuted', counter_quote: 'نص مخترع غير موجود', reason: 'سبب.' }) as never;
    const out = await new ClauseVerifierService().verifyAssessment(input);
    if (out.status === 'ok') expect(out.verification.basis).toBe('uncertain');
    else throw new Error('expected ok');
  });

  it('معطَّل أو بلا مفتاح ⇒ not_configured ولا نداء؛ والأعطال ⇒ error دون رمى', async () => {
    const f = jest.fn();
    global.fetch = f as never;
    process.env.CONTRACT_VERIFIER_ENABLED = 'false';
    expect(await new ClauseVerifierService().verifyAssessment(input)).toEqual({ status: 'not_configured' });
    expect(f).not.toHaveBeenCalled();
    delete process.env.CONTRACT_VERIFIER_ENABLED;
    global.fetch = reply('', false, 500) as never;
    expect((await new ClauseVerifierService().verifyAssessment(input)).status).toBe('error');
    global.fetch = reply('ليس JSON') as never;
    expect((await new ClauseVerifierService().verifyAssessment(input)).status).toBe('error');
    global.fetch = jest.fn().mockRejectedValue(new Error('boom')) as never;
    expect((await new ClauseVerifierService().verifyAssessment(input)).status).toBe('error');
  });

  it('نص البند يُرسل بيانات فى رسالة المستخدم لا النظام، والتعليمات معاكسة', async () => {
    const f = reply({ verdict: 'confirmed', reason: 'قائمة.' });
    global.fetch = f as never;
    await new ClauseVerifierService().verifyAssessment(input);
    const body = JSON.parse((f.mock.calls[0][1] as { body: string }).body);
    expect(body.messages[0].content).toContain('معاكسة');
    expect(body.messages[0].content).not.toContain('يجوز للطرف الثانى');
    expect(body.messages[1].content).toContain('يجوز للطرف الثانى');
  });

  it('verifyFinding يقبل الاعتراض باقتباس من المقتطفات', async () => {
    global.fetch = reply({ verdict: 'refuted', counter_quote: 'إلا إذا اتفق الطرفان كتابة', reason: 'يمكن التوفيق.' }) as never;
    const out = await new ClauseVerifierService().verifyFinding({
      kindLabel: 'تعارض محتمل بين بندين',
      title: 't',
      explanation: 'e',
      evidence: [{ clauseLabel: 'البند الخامس', quote: 'يظل النظام ملكاً للطرف الأول إلا إذا اتفق الطرفان كتابة' }],
      clauseTexts: ['يظل النظام ملكاً للطرف الأول إلا إذا اتفق الطرفان كتابة على غير ذلك.'],
    });
    if (out.status === 'ok') expect(out.verification.basis).toBe('refuted');
    else throw new Error('expected ok');
  });
});
