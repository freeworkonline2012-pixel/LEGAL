import { buildDraftDocument } from '../exports/builders/draft-document.builder';
import { generateDraft } from './engine';
import { BASE, ROLES } from './fixtures';
import { DRAFT_TYPE_IDS } from './drafting.types';

describe('قواعد المكتب على مسودات الصياغة (ملاحظات منفصلة لا تُسقط الفحص)', () => {
  const ALL: Array<[string, string]> = DRAFT_TYPE_IDS.flatMap((t) => ROLES[t].map((r): [string, string] => [t, r]));

  it.each(ALL)('%s/%s: officeNotes موجودة كمصفوفة، وquality.passed لا يتأثر بها', (type, role) => {
    const d = generateDraft(type, role, BASE[type]);
    expect(Array.isArray(d.quality.officeNotes)).toBe(true);
    expect(d.quality.findings).toEqual([]);
    expect(d.quality.passed).toBe(true);
    for (const n of d.quality.officeNotes ?? []) {
      expect(n.title).toBeTruthy();
      expect(n.detail).toBeTruthy();
      // لا تعرض الملاحظة موقفاً بلا نص مقترح للنظر
      expect(n.suggestion.length).toBeGreaterThan(10);
    }
  });

  it('اتفاقية السرية: موقف المكتب من أثر الإخلال بالسرية يظهر ملاحظة لا عيباً (قرار نص القالب للمحامى)', () => {
    const d = generateDraft('nda', 'discloser', BASE.nda);
    const note = d.quality.officeNotes?.find((n) => n.title.includes('السرية بلا أثر'));
    expect(note).toBeDefined();
    expect(note?.severity).toBe('عالٍ');
    expect(d.quality.passed).toBe(true);
  });

  it('الملاحظات حتمية: توليد المسودة نفسها مرتين يعطى الملاحظات نفسها', () => {
    const a = generateDraft('services', 'client', BASE.services).quality.officeNotes;
    const b = generateDraft('services', 'client', BASE.services).quality.officeNotes;
    expect(a).toEqual(b);
  });

  it('مستند Word: يحمل قسم ملاحظات المكتب بجدول، ويخلو منه إن لم توجد ملاحظات', () => {
    const d = generateDraft('nda', 'discloser', BASE.nda);
    const doc = buildDraftDocument({ draft: d, nonce: 'abc123', generatedAt: new Date('2026-11-18T10:00:00Z') });
    const text = JSON.stringify(doc.blocks);
    expect(text).toContain('ملاحظات قواعد المكتب');
    expect(text).toContain('نص مقترح للنظر');

    const none = { ...d, quality: { ...d.quality, officeNotes: [] } };
    const doc2 = buildDraftDocument({ draft: none, nonce: 'abc123', generatedAt: new Date('2026-11-18T10:00:00Z') });
    expect(JSON.stringify(doc2.blocks)).not.toContain('ملاحظات قواعد المكتب');

    const legacy = { ...d, quality: { passed: true, checked: [], findings: [] } };
    expect(() => buildDraftDocument({ draft: legacy, nonce: 'abc123', generatedAt: new Date() })).not.toThrow();
  });
});

describe('Playbook المكتب على مسودات الصياغة', () => {
  // eslint-disable-next-line @typescript-eslint/no-require-imports
  const { buildOfficeProfile, parseOfficePlaybookConfig } = require('../contracts/office-playbook') as typeof import('../contracts/office-playbook');
  const profileOf = (raw: unknown) => {
    const r = parseOfficePlaybookConfig(raw);
    if (!r.ok) throw new Error(r.errors.join('|'));
    return buildOfficeProfile(r.config, { id: 'o', version: 2 });
  };

  it('تعطيل قاعدة فى Playbook المكتب يخفى ملاحظتها من المسودة، والمسودة الأخرى بلا Playbook تبقى كما هى', () => {
    const base = generateDraft('nda', 'discloser', BASE.nda);
    expect(base.quality.officeNotes?.some((n) => n.title.includes('السرية بلا أثر'))).toBe(true);
    const custom = generateDraft('nda', 'discloser', BASE.nda, profileOf({ disabledRules: ['confidentiality_breach_consequence'] }));
    expect(custom.quality.officeNotes?.some((n) => n.title.includes('السرية بلا أثر'))).toBe(false);
    expect(custom.quality.passed).toBe(true);
    expect(generateDraft('nda', 'discloser', BASE.nda).quality.officeNotes).toEqual(base.quality.officeNotes);
  });

  it('قاعدة مطلوبة خاصة بالمكتب تظهر ملاحظة على المسودة ولا تُسقط الفحص ولا تغير نص القالب', () => {
    const base = generateDraft('services', 'client', BASE.services);
    const d = generateDraft(
      'services',
      'client',
      BASE.services,
      profileOf({ customRules: [{ id: 'zz', kind: 'required_phrase', title: 'بند الوساطة قبل التقاضى', phrases: ['وساطة قبل التقاضي ٧٧٧'], severity: 'عالٍ' }] }),
    );
    expect(d.quality.officeNotes?.some((n) => n.title === 'بند الوساطة قبل التقاضى')).toBe(true);
    expect(d.quality.passed).toBe(true);
    expect(d.quality.findings).toEqual([]);
    expect(d.clauses).toEqual(base.clauses);
  });
});
