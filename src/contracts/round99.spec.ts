import { resolveVerifierVotes, verifierSampleCount, type VerifierSampleOutcome } from './verifier-vote';
import type { Verification } from './verification';

const T = new Date('2026-11-15T12:00:00Z');
const v = (status: Verification['status'], basis: Verification['basis'], extra: Partial<Verification> = {}): VerifierSampleOutcome => ({
  status: 'ok',
  verification: { status, basis, reason: 'سبب', quote: basis === 'refuted' ? 'اقتباس' : null, quoteSource: basis === 'refuted' ? 'clause' : null, verifiedAt: T.toISOString(), ...extra },
});
const confirmed = () => v('confirmed', 'confirmed');
const refuted = () => v('unconfirmed', 'refuted', { refutationKind: 'clause_addresses' });
const uncertain = () => v('unconfirmed', 'uncertain');
const reclassified = () => v('confirmed', 'reclassified', { reclassified: 'deviation', refutationKind: 'not_mandatory' });
const err = (): VerifierSampleOutcome => ({ status: 'error', detail: 'http_500' });
const basisOf = (o: VerifierSampleOutcome) => (o.status === 'ok' ? `${o.verification.status}/${o.verification.basis}` : o.status);

describe('الجولة 99: تصويت أغلبية على عيّنات المدقق المستقل', () => {
  it('عدد العيّنات: افتراضى 3، 1 يعيد السلوك السابق، وأقصى 5، وقيمة تالفة ترجع للافتراضى', () => {
    expect(verifierSampleCount(undefined)).toBe(3);
    expect(verifierSampleCount('')).toBe(3);
    expect(verifierSampleCount('1')).toBe(1);
    expect(verifierSampleCount('5')).toBe(5);
    expect(verifierSampleCount('9')).toBe(5);
    expect(verifierSampleCount('0')).toBe(3);
    expect(verifierSampleCount('abc')).toBe(3);
  });

  it('إجماع أو أغلبية على التأكيد ⇒ مؤكدة', () => {
    expect(basisOf(resolveVerifierVotes([confirmed(), confirmed(), confirmed()]).outcome)).toBe('confirmed/confirmed');
    expect(basisOf(resolveVerifierVotes([confirmed(), refuted(), confirmed()]).outcome)).toBe('confirmed/confirmed');
    expect(basisOf(resolveVerifierVotes([confirmed(), uncertain(), confirmed()]).outcome)).toBe('confirmed/confirmed');
  });

  it('أغلبية على الدحض (موثَّق بالاقتباس) ⇒ مستبعدة بنفس سبب الدحض', () => {
    const r = resolveVerifierVotes([refuted(), confirmed(), refuted()]);
    expect(basisOf(r.outcome)).toBe('unconfirmed/refuted');
    expect(r.tally).toEqual({ confirmed: 1, reclassified: 0, refuted: 2, uncertain: 0, errors: 0 });
  });

  it('لا أغلبية (تأكيد ودحض وشك) ⇒ مرشحة (unconfirmed/uncertain) لا مؤكدة ولا مستبعدة، والسبب يذكر الأعداد', () => {
    const r = resolveVerifierVotes([confirmed(), refuted(), uncertain()], T);
    expect(basisOf(r.outcome)).toBe('unconfirmed/uncertain');
    expect(r.outcome.status === 'ok' && r.outcome.verification.reason).toContain('تأكيد 1، دحض 1، شك 1');
    expect(r.outcome.status === 'ok' && r.outcome.verification.quote).toBeNull();
  });

  it('عيّنتان سليمتان مختلفتان (والثالثة عطل) ⇒ مرشحة؛ ومتفقتان ⇒ حكمهما', () => {
    expect(basisOf(resolveVerifierVotes([confirmed(), refuted(), err()]).outcome)).toBe('unconfirmed/uncertain');
    expect(basisOf(resolveVerifierVotes([confirmed(), confirmed(), err()]).outcome)).toBe('confirmed/confirmed');
    expect(basisOf(resolveVerifierVotes([refuted(), refuted(), err()]).outcome)).toBe('unconfirmed/refuted');
  });

  it('عيّنة سليمة واحدة فقط ⇒ حكمها كالسلوك السابق؛ كل العيّنات أعطال ⇒ العطل', () => {
    expect(basisOf(resolveVerifierVotes([err(), confirmed(), err()]).outcome)).toBe('confirmed/confirmed');
    expect(resolveVerifierVotes([err(), err(), err()]).outcome).toEqual({ status: 'error', detail: 'http_500' });
    expect(resolveVerifierVotes([]).outcome).toEqual({ status: 'error', detail: 'no_samples' });
  });

  it('درجة «اختلال عن قاعدة مكملة» لا تُعتمد إلا إن بلغت النصاب بنفسها، وإلا يبقى التأكيد العادى', () => {
    expect(basisOf(resolveVerifierVotes([reclassified(), reclassified(), confirmed()]).outcome)).toBe('confirmed/reclassified');
    expect(basisOf(resolveVerifierVotes([reclassified(), confirmed(), refuted()]).outcome)).toBe('confirmed/confirmed');
    expect(basisOf(resolveVerifierVotes([reclassified(), refuted(), uncertain()]).outcome)).toBe('unconfirmed/uncertain');
  });

  it('خمس عيّنات: النصاب ثلاث', () => {
    expect(basisOf(resolveVerifierVotes([confirmed(), confirmed(), refuted(), refuted(), uncertain()]).outcome)).toBe('unconfirmed/uncertain');
    expect(basisOf(resolveVerifierVotes([confirmed(), confirmed(), confirmed(), refuted(), uncertain()]).outcome)).toBe('confirmed/confirmed');
  });
});

describe('الجولة 99: ربط التصويت بخدمة المدقق (fetch مُحاكى)', () => {
  const OLD = { key: process.env.DEEPSEEK_API_KEY, samples: process.env.CONTRACT_VERIFIER_SAMPLES, enabled: process.env.CONTRACT_VERIFIER_ENABLED };
  afterEach(() => {
    jest.restoreAllMocks();
    process.env.DEEPSEEK_API_KEY = OLD.key;
    process.env.CONTRACT_VERIFIER_SAMPLES = OLD.samples;
    process.env.CONTRACT_VERIFIER_ENABLED = OLD.enabled;
    if (OLD.key === undefined) delete process.env.DEEPSEEK_API_KEY;
    if (OLD.samples === undefined) delete process.env.CONTRACT_VERIFIER_SAMPLES;
    if (OLD.enabled === undefined) delete process.env.CONTRACT_VERIFIER_ENABLED;
  });

  const reply = (verdict: string) => ({ ok: true, json: async () => ({ choices: [{ message: { content: JSON.stringify({ verdict, counter_quote: '', article_quote: '', reason: 'سبب الحكم' }) } }] }) });
  const run = async (verdicts: string[], samples?: string) => {
    process.env.DEEPSEEK_API_KEY = 'k';
    delete process.env.CONTRACT_VERIFIER_ENABLED;
    if (samples === undefined) delete process.env.CONTRACT_VERIFIER_SAMPLES;
    else process.env.CONTRACT_VERIFIER_SAMPLES = samples;
    let i = 0;
    const spy = jest.spyOn(global, 'fetch').mockImplementation((async () => reply(verdicts[i++ % verdicts.length])) as unknown as typeof fetch);
    const { ClauseVerifierService } = await import('./clause-verifier.service');
    const svc = new ClauseVerifierService();
    const out = await svc.verifyAssessment({ clauseText: 'نص', claim: 'ملاحظة', clientPosition: null, articles: [{ lawTitle: 'المدنى', articleNo: 224, articleText: 'نص المادة' }] });
    return { out, calls: spy.mock.calls.length };
  };

  it('افتراضياً ثلاث نداءات عند الإجماع (الجولة 105.5: لا عيّنات إضافية)', async () => {
    const r = await run(['confirmed', 'confirmed', 'confirmed']);
    expect(r.calls).toBe(3);
    expect(r.out.status === 'ok' && `${r.out.verification.status}/${r.out.verification.basis}`).toBe('confirmed/confirmed');
  });

  it('الجولة 105.5: انقسام العيّنات الثلاث ⇒ خمس نداءات والأغلبية من 5 (3 تأكيدات)', async () => {
    const r = await run(['confirmed', 'refuted', 'confirmed']);
    expect(r.calls).toBe(5);
    expect(r.out.status === 'ok' && `${r.out.verification.status}/${r.out.verification.basis}`).toBe('confirmed/confirmed');
  });

  it('الجولة 105.5: CONTRACT_VERIFIER_EXTRA_SAMPLES=0 ⇒ ثلاث نداءات رغم الانقسام', async () => {
    process.env.CONTRACT_VERIFIER_EXTRA_SAMPLES = '0';
    const r = await run(['confirmed', 'refuted', 'confirmed']);
    delete process.env.CONTRACT_VERIFIER_EXTRA_SAMPLES;
    expect(r.calls).toBe(3);
    expect(r.out.status === 'ok' && r.out.verification.status).toBe('confirmed');
  });

  it('لا أغلبية ⇒ مرشحة', async () => {
    const r = await run(['confirmed', 'uncertain', 'refuted']);
    expect(r.calls).toBe(5);
    expect(r.out.status === 'ok' && r.out.verification.basis).toBe('uncertain');
    expect(r.out.status === 'ok' && r.out.verification.status).toBe('unconfirmed');
  });

  it('CONTRACT_VERIFIER_SAMPLES=1 ⇒ نداء واحد كالسلوك السابق', async () => {
    const r = await run(['confirmed'], '1');
    expect(r.calls).toBe(1);
    expect(r.out.status === 'ok' && r.out.verification.status).toBe('confirmed');
  });
});
