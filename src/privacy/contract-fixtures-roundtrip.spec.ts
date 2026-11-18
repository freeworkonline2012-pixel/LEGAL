import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { collectContractEntities, registerContractEntities } from './contract-entities';
import { ShieldSession } from './outbound-shield';

function walk(dir: string, out: string[]): void {
  for (const n of readdirSync(dir)) {
    const p = join(dir, n);
    if (statSync(p).isDirectory()) walk(p, out);
    else if (p.endsWith('.txt')) out.push(p);
  }
}

/** على نصوص العقود الفعلية المحفوظة كعيّنات: الحجب عكوس تماماً، والتغيير محدود (لا يمسح نص العقد الموضوعى). */
describe('الحجب على عقود العيّنات', () => {
  const files: string[] = [];
  walk(join(__dirname, '..', 'contracts', '__fixtures__'), files);

  it('توجد عيّنات', () => expect(files.length).toBeGreaterThan(3));

  it.each(files.map((f) => [f.split('__fixtures__/')[1], f]))('%s: رحلة ذهاب وإياب حرفية وتغيير محدود', (_n, f) => {
    const text = readFileSync(f, 'utf8');
    const s = new ShieldSession();
    registerContractEntities(s, text, null);
    const out = s.shield(text);
    expect(s.unshield(out)).toBe(text);
    const changedShare = 1 - out.replace(/\[\[[A-Z]+\d+\]\]/g, '').length / Math.max(1, text.length);
    // ثابت ضد الإفراط فى الحجب: لا يتجاوز ربع النص فى أى عيّنة
    expect(changedShare).toBeLessThan(0.25);
    if (process.env.PRIVACY_STATS) {
      // eslint-disable-next-line no-console
      console.log(`${_n}: entities=${collectContractEntities(text, null).length} names=${s.counts.names} pii=${s.counts.pii} changed=${(changedShare * 100).toFixed(1)}%`);
    }
  });
});
