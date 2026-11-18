import { DeepseekGenerationService } from '../llm/deepseek-generation.service';
import { registerContractEntities } from './contract-entities';
import { ShieldSession, runWithShield } from './outbound-shield';

/** تكامل: نداء تقييم بند حقيقى عبر الخدمة الفعلية داخل جلسة حماية؛ المزوّد (مُحاكى) لا يرى الهويات، والخدمة ترى الأصل. */
describe('تدقيق العقد خلف بوابة الخصوصية (DeepseekGenerationService.assessClause)', () => {
  const originalKey = process.env.DEEPSEEK_API_KEY;
  const realFetch = globalThis.fetch;
  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
  });
  afterEach(() => {
    process.env.DEEPSEEK_API_KEY = originalKey;
    globalThis.fetch = realFetch;
  });

  const PREAMBLE =
    'بين شركة الفجر للمقاولات، ومقرها 12 شارع الجمهورية - طنطا، ويمثلها السيد/ سامح ناصر عبد الله، والسيدة / هالة جمال صبرى، بطاقة رقم قومى 29001011234567.';
  const CLAUSE = 'يلتزم سامح ناصر عبد الله بسداد غرامة قدرها 5000 جنيه لشركة الفجر للمقاولات عند التأخير، ويتصل به على 01012345678.';

  it('المزوّد لا يتسلم أى هوية، والاقتباس الذى يعيده يعود حرفياً كما فى العقد', async () => {
    let sent = '';
    globalThis.fetch = jest.fn().mockImplementation(async (_u: string, init: RequestInit) => {
      sent = String(init.body);
      const user = (JSON.parse(sent).messages as Array<{ role: string; content: string }>)[1].content;
      // النموذج يقتبس جزءاً من البند كما استلمه (برموزه)
      const quoted = /يلتزم .*? عند التأخير/.exec(user)![0];
      return new Response(
        JSON.stringify({
          choices: [
            {
              finish_reason: 'stop',
              message: {
                content: JSON.stringify({
                  assessment: 'سليم',
                  selected: [1],
                  reasoning: 'الاتفاق جائز',
                  confidence: 0.9,
                  violation_type: 'none',
                  mandatory_quote: quoted,
                }),
              },
            },
          ],
        }),
        { status: 200, headers: { 'content-type': 'application/json' } },
      );
    }) as never;

    const service = new DeepseekGenerationService();
    const session = new ShieldSession();
    registerContractEntities(session, PREAMBLE, null);
    const result = await runWithShield(session, () =>
      service.assessClause({
        clauseText: CLAUSE,
        candidates: [{ lawTitle: 'القانون المدنى', lawNo: 131, lawYear: 1948, articleNo: 224, articleText: 'يجوز للمتعاقدين أن يحددوا مقدماً قيمة التعويض بالنص عليها فى العقد.' }],
      }),
    );

    for (const leaked of ['الفجر', 'سامح', 'ناصر', '01012345678', '29001011234567']) expect(sent).not.toContain(leaked);
    expect(sent).toContain('5000'); // المبالغ الموضوعية تبقى
    expect(sent).toContain('المادة 224 من القانون المدنى'); // نص القانون يبقى
    expect(result.status).toBe('ok');
    if (result.status === 'ok') {
      expect(result.assessment).toBe('سليم');
      expect(CLAUSE).toContain(result.mandatoryQuote); // فحص الاقتباس الحرفى يبقى سليماً
      expect(result.mandatoryQuote).toContain('سامح ناصر عبد الله');
    }
  });

  it('خارج الجلسة (CONTRACT_PRIVACY_MODE=off أو خدمة أخرى) يخرج النص كما هو', async () => {
    let sent = '';
    globalThis.fetch = jest.fn().mockImplementation(async (_u: string, init: RequestInit) => {
      sent = String(init.body);
      return new Response(JSON.stringify({ choices: [{ finish_reason: 'stop', message: { content: '{"assessment":"سليم","selected":[],"reasoning":"x","confidence":0.5,"violation_type":"none","mandatory_quote":""}' } }] }), { status: 200 });
    }) as never;
    await new DeepseekGenerationService().assessClause({
      clauseText: CLAUSE,
      candidates: [{ lawTitle: 'ق', lawNo: 1, lawYear: 2000, articleNo: 1, articleText: 'نص' }],
    });
    expect(sent).toContain('01012345678');
  });
});
