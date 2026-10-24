import { ContractConsistencyService } from './contract-consistency.service';
import type { LevelClause } from './contract-level';

const clauses: LevelClause[] = [
  { clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: 'يظل النظام وشفرته المصدرية ملكاً للطرف الأول دائماً.' },
  { clauseIndex: 2, clauseLabel: 'البند الثانى', clauseTitle: null, clauseText: 'تنتقل ملكية ما نُفذ إلى الطرف الثانى عند الفسخ.' },
];

const reply = (content: unknown, ok = true, status = 200) =>
  jest.fn().mockResolvedValue({ ok, status, json: async () => ({ choices: [{ message: { content: typeof content === 'string' ? content : JSON.stringify(content) } }] }) });

describe('ContractConsistencyService', () => {
  const realFetch = global.fetch;
  const env = { ...process.env };
  beforeEach(() => {
    process.env.DEEPSEEK_API_KEY = 'test-key';
    delete process.env.CONTRACT_CONSISTENCY_ENABLED;
  });
  afterEach(() => {
    global.fetch = realFetch;
    process.env = { ...env };
  });

  it('بلا مفتاح أو مع المفتاح المعطِّل ⇒ not_configured ولا نداء', async () => {
    delete process.env.DEEPSEEK_API_KEY;
    const f = jest.fn();
    global.fetch = f as never;
    expect(await new ContractConsistencyService().analyze(clauses)).toEqual({ status: 'not_configured' });
    process.env.DEEPSEEK_API_KEY = 'k';
    process.env.CONTRACT_CONSISTENCY_ENABLED = 'false';
    expect(await new ContractConsistencyService().analyze(clauses)).toEqual({ status: 'not_configured' });
    expect(f).not.toHaveBeenCalled();
  });

  it('يقبل نتيجة مسنَّدة باقتباسين حرفيين ويُسقط غير المسنَّدة', async () => {
    global.fetch = reply({
      findings: [
        {
          kind: 'conflict',
          severity: 'عالٍ',
          title: 'تعارض الملكية',
          explanation: 'قد ينقل البند الثانى ما يحجزه الأول.',
          evidence: [
            { clause_index: 1, quote: 'يظل النظام وشفرته المصدرية ملكاً للطرف الأول' },
            { clause_index: 2, quote: 'تنتقل ملكية ما نُفذ إلى الطرف الثانى' },
          ],
        },
        { kind: 'conflict', severity: 'عالٍ', title: 'ادعاء بلا سند', explanation: 'لا اقتباس صحيح.', evidence: [{ clause_index: 1, quote: 'عبارة مخترعة لا وجود لها' }] },
      ],
    }) as never;
    const out = await new ContractConsistencyService().analyze(clauses);
    expect(out.status).toBe('ok');
    if (out.status === 'ok') expect(out.findings.map((f) => f.title)).toEqual(['تعارض الملكية']);
  });

  it('خطأ HTTP أو JSON تالف أو استثناء ⇒ error دون رمى', async () => {
    global.fetch = reply('', false, 500) as never;
    expect((await new ContractConsistencyService().analyze(clauses)).status).toBe('error');
    global.fetch = reply('ليس JSON') as never;
    expect((await new ContractConsistencyService().analyze(clauses)).status).toBe('error');
    global.fetch = jest.fn().mockRejectedValue(new Error('boom')) as never;
    expect((await new ContractConsistencyService().analyze(clauses)).status).toBe('error');
  });

  it('عقد أطول من الحد ⇒ skipped صراحةً بدل اقتطاع صامت، وبند واحد ⇒ skipped', async () => {
    const f = jest.fn();
    global.fetch = f as never;
    const big = Array.from({ length: 20 }, (_, i) => ({ clauseIndex: i + 1, clauseLabel: `ب${i}`, clauseTitle: null, clauseText: 'س'.repeat(5500) }));
    expect(await new ContractConsistencyService().analyze(big)).toEqual({ status: 'skipped', detail: 'too_long' });
    expect(await new ContractConsistencyService().analyze([clauses[0]])).toEqual({ status: 'skipped', detail: 'single_clause' });
    expect(f).not.toHaveBeenCalled();
  });

  it('نص العقد يُرسل كبيانات داخل رسالة المستخدم لا فى رسالة النظام', async () => {
    const f = reply({ findings: [] });
    global.fetch = f as never;
    await new ContractConsistencyService().analyze(clauses);
    const body = JSON.parse((f.mock.calls[0][1] as { body: string }).body);
    expect(body.messages[0].content).not.toContain('يظل النظام');
    expect(body.messages[1].content).toContain('يظل النظام');
    expect(body.temperature).toBe(0);
  });
});
