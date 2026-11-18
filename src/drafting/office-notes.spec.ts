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
