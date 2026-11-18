import { BadRequestException, UnauthorizedException } from '@nestjs/common';
import type { LevelClause } from './contract-level';
import { ContractsService } from './contracts.service';
import { DEFAULT_OFFICE_PROFILE, officeRuleFindings } from './office-rules';
import {
  PLAYBOOK_LIMITS,
  buildOfficeProfile,
  builtInCatalog,
  customRuleToOfficeRule,
  isCustomized,
  parseOfficePlaybookConfig,
  type OfficePlaybookConfig,
} from './office-playbook';
import { OfficePlaybookController } from './office-playbook.controller';
import { OfficePlaybookService } from './office-playbook.service';

// عقود اصطناعية بالكامل
const clause = (i: number, title: string, text: string): LevelClause => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: title, clauseText: text });
const opts = { contractType: 'خدمات', textMayBeIncomplete: false };
const autoRenew = clause(1, 'مدة العقد', 'مدة هذا العقد سنة ميلادية واحدة. واتفق الطرفان على أن يجدد هذا العقد تلقائياً لمدد مماثلة ما لم يخطر أى من الطرفين الآخر برغبته فى عدم التجديد.');
const payment = clause(2, 'الدفع', 'يدفع العميل الأتعاب خلال ثلاثين يوماً من تاريخ الفاتورة، وتسرى غرامة تأخير على المتأخر.');

const ok = (raw: unknown): OfficePlaybookConfig => {
  const r = parseOfficePlaybookConfig(raw);
  if (!r.ok) throw new Error(r.errors.join(' | '));
  return r.config;
};
const errs = (raw: unknown): string[] => {
  const r = parseOfficePlaybookConfig(raw);
  return r.ok ? [] : r.errors;
};
const ruleIds = (cs: LevelClause[], cfg: OfficePlaybookConfig) =>
  officeRuleFindings(cs, opts, buildOfficeProfile(cfg, { id: 'o', version: 1 })).map((f) => f.id);

describe('parseOfficePlaybookConfig', () => {
  it('الإعداد الفارغ صحيح ولا يخصص شيئاً', () => {
    const cfg = ok({});
    expect(cfg).toEqual({ disabledRules: [], severityOverrides: {}, customRules: [] });
    expect(isCustomized(cfg)).toBe(false);
  });

  it('يرفض ما ليس كائناً', () => {
    expect(errs('x')).toHaveLength(1);
    expect(errs(null)).toHaveLength(1);
    expect(errs([])).toHaveLength(1);
  });

  it('يرفض قاعدة افتراضية غير معروفة فى التعطيل والدرجات (كشف الأخطاء الإملائية)', () => {
    expect(errs({ disabledRules: ['nope'] })[0]).toContain('غير معروفة');
    expect(errs({ severityOverrides: { nope: 'عالٍ' } })[0]).toContain('غير معروفة');
    expect(errs({ severityOverrides: { term_no_auto_renewal: 'خطير' } })[0]).toContain('درجة غير صحيحة');
  });

  it('القاعدة الخاصة: يُولَّد لها معرّف ويُنظَّف نصها وتُزال العبارات المكررة', () => {
    const cfg = ok({
      customRules: [{ kind: 'forbidden_phrase', title: '  غرامة   التأخير ', phrases: ['غرامة تأخير', 'غرامة تأخير', ' شرط جزائى '], severity: 'عالٍ' }],
    });
    expect(cfg.customRules).toHaveLength(1);
    expect(cfg.customRules[0].id).toMatch(/^c_[0-9a-f]{8}$/);
    expect(cfg.customRules[0].title).toBe('غرامة التأخير');
    expect(cfg.customRules[0].phrases).toEqual(['غرامة تأخير', 'شرط جزائى']);
    expect(cfg.customRules[0].enabled).toBe(true);
    expect(cfg.customRules[0].families).toBeNull();
  });

  it.each([
    [{ kind: 'x', title: 't', phrases: ['abc'] }, 'نوع القاعدة'],
    [{ kind: 'forbidden_phrase', title: '', phrases: ['abc'] }, 'العنوان مطلوب'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: [] }, 'العبارات مطلوبة'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: ['اب'] }, 'قصيرة جداً'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: ['x'.repeat(PLAYBOOK_LIMITS.maxPhraseLength + 1)] }, 'أطول'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: ['abc'], severity: 'حرج' }, 'الدرجة'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: ['abc'], families: ['mars'] }, 'نوع عقد غير معروف'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: ['abc'], id: 'term_no_auto_renewal' }, 'معرّف'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: ['abc'], id: 'BAD ID' }, 'معرّف'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: ['abc'], explanation: 'x'.repeat(601) }, 'الشرح'],
    [{ kind: 'forbidden_phrase', title: 't', phrases: ['abc'], enabled: 'yes' }, 'enabled'],
  ])('يرفض قاعدة خاصة معيبة %#', (rule, fragment) => {
    const e = errs({ customRules: [rule] });
    expect(e.length).toBeGreaterThan(0);
    expect(e.join(' ')).toContain(fragment);
  });

  it('يرفض تجاوز عدد القواعد الخاصة ومعرفين مكررين', () => {
    const many = Array.from({ length: PLAYBOOK_LIMITS.maxCustomRules + 1 }, (_, i) => ({ kind: 'forbidden_phrase', title: `t${i}`, phrases: ['abc'] }));
    expect(errs({ customRules: many }).join(' ')).toContain('الحد الأقصى');
    const dup = [
      { id: 'same', kind: 'forbidden_phrase', title: 'a', phrases: ['abc'] },
      { id: 'same', kind: 'forbidden_phrase', title: 'b', phrases: ['abc'] },
    ];
    expect(errs({ customRules: dup }).join(' ')).toContain('مكرر');
  });

  it('الوضع المتساهل (عند التدقيق) يُسقط المعيب ويُبقى الصالح ولا يرمى', () => {
    const r = parseOfficePlaybookConfig(
      {
        disabledRules: ['removed_rule', 'term_no_auto_renewal'],
        severityOverrides: { removed_rule: 'عالٍ', economic_courts_forum: 'عالٍ' },
        customRules: [{ kind: 'bad' }, { kind: 'forbidden_phrase', title: 'ok', phrases: ['غرامة تأخير'] }],
      },
      'lenient',
    );
    expect(r.ok).toBe(true);
    if (r.ok) {
      expect(r.config.disabledRules).toEqual(['term_no_auto_renewal']);
      expect(r.config.severityOverrides).toEqual({ economic_courts_forum: 'عالٍ' });
      expect(r.config.customRules).toHaveLength(1);
    }
    expect(parseOfficePlaybookConfig('garbage', 'lenient').ok).toBe(true);
  });
});

describe('buildOfficeProfile', () => {
  it('بلا تخصيص تطابق نتائجه الملف الافتراضي تماماً', () => {
    const base = officeRuleFindings([autoRenew, payment], opts, DEFAULT_OFFICE_PROFILE).map((f) => `${f.id}:${f.severity}`);
    const same = officeRuleFindings([autoRenew, payment], opts, buildOfficeProfile(ok({}), { id: 'o', version: 1 })).map((f) => `${f.id}:${f.severity}`);
    expect(same).toEqual(base);
  });

  it('تعطيل قاعدة افتراضية يُخفى ملاحظتها فقط، ولا يمس الملف الافتراضى المشترك', () => {
    expect(ruleIds([autoRenew], ok({}))).toContain('office:term_no_auto_renewal');
    expect(ruleIds([autoRenew], ok({ disabledRules: ['term_no_auto_renewal'] }))).not.toContain('office:term_no_auto_renewal');
    // لا تسرب إلى الافتراضى
    expect(DEFAULT_OFFICE_PROFILE.rules.find((r) => r.id === 'term_no_auto_renewal')!.enabled).toBe(true);
    expect(officeRuleFindings([autoRenew], opts).map((f) => f.id)).toContain('office:term_no_auto_renewal');
  });

  it('تغيير الدرجة يظهر فى الملاحظة، ولا يغير الافتراضى', () => {
    const f = officeRuleFindings([autoRenew], opts, buildOfficeProfile(ok({ severityOverrides: { term_no_auto_renewal: 'منخفض' } }), { id: 'o', version: 1 })).find(
      (x) => x.id === 'office:term_no_auto_renewal',
    );
    expect(f?.severity).toBe('منخفض');
    expect(DEFAULT_OFFICE_PROFILE.rules.find((r) => r.id === 'term_no_auto_renewal')!.severity).toBe('عالٍ');
  });

  it('قاعدة العبارة الممنوعة ترصد الجملة وتقتبسها حرفياً، وتطابق مع اختلاف الهمزة والتشكيل', () => {
    const cfg = ok({ customRules: [{ id: 'late_fee', kind: 'forbidden_phrase', title: 'لا غرامة تأخير', phrases: ['غرامة تأخير'], severity: 'متوسط' }] });
    const f = officeRuleFindings([autoRenew, payment], opts, buildOfficeProfile(cfg, { id: 'o', version: 1 })).find((x) => x.id === 'office:custom_late_fee');
    expect(f).toBeDefined();
    expect(f!.severity).toBe('متوسط');
    expect(f!.evidence.map((e) => e.clauseIndex)).toEqual([2]);
    expect(payment.clauseText).toContain(f!.evidence[0].quote);
    expect(f!.explanation).toContain('ممارسة تعاقدية للمكتب');
    const diacritics = ok({ customRules: [{ id: 'x', kind: 'forbidden_phrase', title: 't', phrases: ['غَرَامَةُ تَأْخِير'] }] });
    expect(ruleIds([payment], diacritics)).toContain('office:custom_x');
  });

  it('قاعدة العبارة المطلوبة: تصدر ملاحظة غياب بلا اقتباس، وتختفى متى وردت العبارة', () => {
    const cfg = ok({ customRules: [{ id: 'law', kind: 'required_phrase', title: 'القانون الواجب التطبيق', phrases: ['القانون المصرى', 'القانون الواجب التطبيق'], severity: 'عالٍ' }] });
    const f = officeRuleFindings([autoRenew, payment], opts, buildOfficeProfile(cfg, { id: 'o', version: 1 })).find((x) => x.id === 'office:custom_law');
    expect(f).toBeDefined();
    expect(f!.evidence).toEqual([]);
    const withLaw = clause(3, 'القانون', 'يخضع هذا العقد لأحكام القانون المصرى.');
    expect(ruleIds([autoRenew, payment, withLaw], cfg)).not.toContain('office:custom_law');
  });

  it('على نص ممسوح ذى تحذيرات يُوسم ادعاء الغياب غير مؤكد', () => {
    const cfg = ok({ customRules: [{ id: 'law', kind: 'required_phrase', title: 't', phrases: ['القانون المصرى'] }] });
    const f = officeRuleFindings([payment], { ...opts, textMayBeIncomplete: true }, buildOfficeProfile(cfg, { id: 'o', version: 1 })).find((x) => x.id === 'office:custom_law');
    expect(f?.verification?.status).toBe('unconfirmed');
  });

  it('القاعدة الخاصة تحترم أنواع العقود وتعطيلها', () => {
    const only = ok({ customRules: [{ id: 'k', kind: 'forbidden_phrase', title: 't', phrases: ['غرامة تأخير'], families: ['lease'] }] });
    expect(ruleIds([payment], only)).not.toContain('office:custom_k'); // العقد خدمات
    const off = ok({ customRules: [{ id: 'k', kind: 'forbidden_phrase', title: 't', phrases: ['غرامة تأخير'], enabled: false }] });
    expect(ruleIds([payment], off)).not.toContain('office:custom_k');
  });

  it('لا تنفّذ عبارة المستخدم كتعبير نمطى (رموز regex تُعامل نصاً)', () => {
    const rule = customRuleToOfficeRule({ id: 'r', kind: 'forbidden_phrase', title: 't', phrases: ['(a+)+$'], families: null, severity: 'متوسط', explanation: '', suggestion: '', enabled: true });
    const t0 = Date.now();
    const hits = rule.evaluate([clause(1, 't', 'a'.repeat(50) + '!')], { family: 'services' });
    expect(Date.now() - t0).toBeLessThan(200);
    expect(hits).toEqual([]);
  });

  it('الكتالوج يعرض كل القواعد الافتراضية بمعرفاتها الفريدة', () => {
    const cat = builtInCatalog();
    expect(cat.length).toBe(DEFAULT_OFFICE_PROFILE.rules.length);
    expect(new Set(cat.map((c) => c.id)).size).toBe(cat.length);
    expect(cat.every((c) => c.title && c.severity)).toBe(true);
  });
});

describe('OfficePlaybookService', () => {
  const make = (rowsByCall: unknown[]) => {
    const query = jest.fn();
    for (const r of rowsByCall) query.mockResolvedValueOnce(r);
    return { svc: new OfficePlaybookService({ query } as never), query };
  };

  it('بلا صف: الافتراضى ورقم 0', async () => {
    const { svc } = make([[]]);
    expect(await svc.get('u1')).toEqual({ config: { disabledRules: [], severityOverrides: {}, customRules: [] }, version: 0, updatedAt: null, customized: false });
  });

  it('profileFor: بلا تخصيص يعيد كائن الملف الافتراضى نفسه', async () => {
    const { svc } = make([[]]);
    expect((await svc.profileFor('u1')).profile).toBe(DEFAULT_OFFICE_PROFILE);
  });

  it('profileFor: يبنى ملفاً مخصصاً من الصف المحفوظ ويُرجع رقمه', async () => {
    const { svc } = make([[{ version: 3, config: { disabledRules: ['term_no_auto_renewal'] }, updated_at: new Date() }]]);
    const r = await svc.profileFor('u1');
    expect(r.version).toBe(3);
    expect(r.customized).toBe(true);
    expect(r.profile.rules.find((x) => x.id === 'term_no_auto_renewal')!.enabled).toBe(false);
  });

  it('profileFor لا يرمى أبداً: عطل القاعدة أو غياب المستخدم ⇒ الافتراضى', async () => {
    const query = jest.fn().mockRejectedValue(new Error('db down'));
    const svc = new OfficePlaybookService({ query } as never);
    expect((await svc.profileFor('u1')).profile).toBe(DEFAULT_OFFICE_PROFILE);
    expect((await svc.profileFor(null)).profile).toBe(DEFAULT_OFFICE_PROFILE);
  });

  it('save يستخدم upsert ويزيد الرقم', async () => {
    const { svc, query } = make([[], [{ version: 2, config: {}, updated_at: new Date() }]]);
    const out = await svc.save('u1', { disabledRules: [], severityOverrides: {}, customRules: [] });
    expect(String(query.mock.calls[0][0])).toContain('ON CONFLICT (user_id) DO UPDATE');
    expect(String(query.mock.calls[0][0])).toContain('version + 1');
    expect(out.version).toBe(2);
  });
});

describe('OfficePlaybookController', () => {
  const req = (userId?: string) => ({ user: userId ? { userId, role: 'user' } : undefined }) as never;
  const stored = { config: { disabledRules: [], severityOverrides: {}, customRules: [] }, version: 0, updatedAt: null, customized: false };

  it('GET يرجع الإعداد مع الكتالوج والحدود، والمعرّف من الرمز فقط', async () => {
    const service = { get: jest.fn().mockResolvedValue(stored) };
    const c = new OfficePlaybookController(service as never);
    const v = await c.get(req('u9'));
    expect(service.get).toHaveBeenCalledWith('u9');
    expect(v.catalog.length).toBe(DEFAULT_OFFICE_PROFILE.rules.length);
    expect(v.limits.maxCustomRules).toBe(PLAYBOOK_LIMITS.maxCustomRules);
  });

  it('بلا مستخدم: 401', async () => {
    const c = new OfficePlaybookController({} as never);
    await expect(c.get(req())).rejects.toBeInstanceOf(UnauthorizedException);
    await expect(c.put({}, req())).rejects.toBeInstanceOf(UnauthorizedException);
    await expect(c.reset(req())).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('PUT يرفض الإعداد المعيب برسائل ولا يحفظ شيئاً', async () => {
    const service = { save: jest.fn() };
    const c = new OfficePlaybookController(service as never);
    await expect(c.put({ disabledRules: ['nope'] }, req('u1'))).rejects.toBeInstanceOf(BadRequestException);
    expect(service.save).not.toHaveBeenCalled();
  });

  it('PUT يحفظ الإعداد المُنظَّف لصاحب الرمز، وDELETE يعيد الضبط', async () => {
    const service = { save: jest.fn().mockResolvedValue({ ...stored, version: 1, customized: true }), reset: jest.fn().mockResolvedValue(stored) };
    const c = new OfficePlaybookController(service as never);
    const v = await c.put({ disabledRules: ['term_no_auto_renewal'], userId: 'attacker' }, req('u1'));
    expect(service.save).toHaveBeenCalledWith('u1', { disabledRules: ['term_no_auto_renewal'], severityOverrides: {}, customRules: [] });
    expect(v.version).toBe(1);
    await c.reset(req('u1'));
    expect(service.reset).toHaveBeenCalledWith('u1');
  });
});

describe('ContractsService.analyzeContractLevel مع Playbook المكتب', () => {
  const build = () =>
    new ContractsService(
      { getRepository: jest.fn().mockReturnValue({}) } as never,
      {} as never,
      {} as never,
      {} as never,
      {} as never,
      {} as never,
      {} as never,
      {} as never,
      { analyze: jest.fn().mockResolvedValue({ status: 'not_configured' }) } as never,
      {} as never,
    );
  const rows = [autoRenew, payment].map((c) => ({ ...c })) as never;

  it('بلا ملف مخصص: الافتراضى ولا حقل playbook', async () => {
    const r = await build().analyzeContractLevel(rows, 'خدمات', []);
    expect(r.findings.map((f) => f.id)).toContain('office:term_no_auto_renewal');
    expect(r.playbook).toBeUndefined();
  });

  it('بملف المكتب: التعطيل والقاعدة الخاصة يؤثران ويُسجَّل رقم الإعداد', async () => {
    const cfg = ok({ disabledRules: ['term_no_auto_renewal'], customRules: [{ id: 'late', kind: 'forbidden_phrase', title: 'غرامة', phrases: ['غرامة تأخير'] }] });
    const profile = buildOfficeProfile(cfg, { id: 'office-u1', version: 4 });
    const r = await build().analyzeContractLevel(rows, 'خدمات', [], null, null, null, profile, { version: 4, customized: true });
    const ids = r.findings.map((f) => f.id);
    expect(ids).not.toContain('office:term_no_auto_renewal');
    expect(ids).toContain('office:custom_late');
    expect(r.playbook).toEqual({ version: 4, customized: true });
  });
});

describe('تدقيق العقد المرفوع يطبق Playbook صاحب الحساب', () => {
  const sources = { save: jest.fn().mockResolvedValue(true), renew: jest.fn(), release: jest.fn(), unclaim: jest.fn(), delete: jest.fn(), has: jest.fn(), failInterruptedWithoutSource: jest.fn().mockResolvedValue(0), giveUpExhausted: jest.fn().mockResolvedValue([]), claimExpired: jest.fn().mockResolvedValue([]), purgeStale: jest.fn().mockResolvedValue(0) };
  const TEXT = ['البند الأول', 'مدة العقد سنة واحدة تجدد تلقائياً لمدد مماثلة.', '', 'البند الثانى', 'يدفع العميل الأتعاب خلال ثلاثين يوماً.'].join('\n');

  async function run(playbooks: unknown) {
    const store: Record<string, Record<string, unknown>> = {};
    const contractRepo = {
      create: jest.fn().mockImplementation((v) => ({ id: 'c1', createdAt: new Date(), updatedAt: new Date(), ...v })),
      save: jest.fn().mockImplementation(async (c) => {
        store[c.id] = { ...(store[c.id] ?? {}), ...c };
        return c;
      }),
      findOne: jest.fn().mockImplementation(async ({ where }: { where: { id: string } }) => (store[where.id] ? { ...store[where.id] } : null)),
      update: jest.fn().mockResolvedValue({ affected: 0 }),
    };
    const clauseRepo = { find: jest.fn().mockResolvedValue([{ clauseIndex: 1, clauseLabel: 'البند 1', clauseTitle: 'المدة', clauseText: 'مدة العقد سنة واحدة تجدد تلقائياً لمدد مماثلة.' }]), delete: jest.fn().mockResolvedValue({ affected: 0 }) };
    const dataSource = { getRepository: jest.fn().mockImplementation((e: { name: string }) => (e.name === 'Contract' ? contractRepo : clauseRepo)) };
    const service = new ContractsService(
      dataSource as never,
      { record: jest.fn().mockResolvedValue(undefined) } as never,
      { extract: jest.fn().mockResolvedValue({ status: 'ok', text: TEXT }) } as never,
      new (jest.requireActual('./segmentation.service').SegmentationService)() as never,
      {} as never,
      {} as never,
      { read: jest.fn() } as never,
      { isConfigured: false } as never,
      { isConfigured: false, analyze: jest.fn().mockResolvedValue({ status: 'not_configured' }) } as never,
      { isConfigured: false } as never,
      sources as never,
      playbooks as never,
    );
    jest.spyOn(service as never, 'assessAndPersistClause' as never).mockResolvedValue(undefined as never);
    jest.spyOn(service as never, 'persistInitialClause' as never).mockImplementation((async (_id: string, c: { label: string }) => ({ ...c, id: c.label })) as never);
    const spy = jest.spyOn(service, 'analyzeContractLevel');
    const res = await service.upload({ buffer: Buffer.from('%PDF-1.4'), mimetype: 'application/pdf', originalname: 'a.pdf' }, { userId: 'owner-7', ipAddress: null, userAgent: null });
    return { res, spy, store };
  }

  it('يطلب ملف المكتب بمعرّف صاحب الرفع ويمرره مع رقم الإعداد', async () => {
    const profile = buildOfficeProfile(ok({ disabledRules: ['term_no_auto_renewal'] }), { id: 'office-owner-7', version: 5 });
    const playbooks = { profileFor: jest.fn().mockResolvedValue({ profile, version: 5, customized: true }) };
    const { spy, store } = await run(playbooks);
    expect(playbooks.profileFor).toHaveBeenCalledWith('owner-7');
    expect(spy.mock.calls[0][6]).toBe(profile);
    expect(spy.mock.calls[0][7]).toEqual({ version: 5, customized: true });
    const level = store['c1'].contractFindings as { findings: Array<{ id: string }>; playbook?: unknown };
    expect(level.findings.map((f) => f.id)).not.toContain('office:term_no_auto_renewal');
    expect(level.playbook).toEqual({ version: 5, customized: true });
  });

  it('بلا خدمة Playbook (أو بلا إعداد محفوظ) يبقى الافتراضى ولا يُسجَّل playbook', async () => {
    const { spy: spy1, store: s1 } = await run(undefined);
    expect(spy1.mock.calls[0][6]).toBeUndefined();
    expect((s1['c1'].contractFindings as { playbook?: unknown }).playbook).toBeUndefined();
    const playbooks = { profileFor: jest.fn().mockResolvedValue({ profile: DEFAULT_OFFICE_PROFILE, version: 0, customized: false }) };
    const { spy: spy2 } = await run(playbooks);
    expect(spy2.mock.calls[0][7]).toBeUndefined();
  });
});
