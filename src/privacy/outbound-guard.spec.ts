import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';

/**
 * حارس: لا نداء خارجى مباشر بـ fetch داخل وحدات الذكاء الاصطناعى وتدقيق العقود والمستندات والترجمة.
 * كل نداء يجب أن يمر بـ outboundFetch (src/privacy/outbound-shield.ts) كى تعمل بوابة الخصوصية.
 * من يضيف نداءً جديداً بـ fetch المباشر يفشل هذا الاختبار قبل أن يصل إلى الإنتاج.
 */
const ROOT = join(__dirname, '..');
const DIRS = ['llm', 'contracts', 'documents', 'translation'];

function walk(dir: string, out: string[]): void {
  for (const name of readdirSync(dir)) {
    const p = join(dir, name);
    if (statSync(p).isDirectory()) walk(p, out);
    else if (p.endsWith('.ts') && !p.endsWith('.spec.ts')) out.push(p);
  }
}

describe('outbound guard', () => {
  it('لا fetch مباشر فى الوحدات التى تُرسل نصوصاً لمزوّد خارجى', () => {
    const files: string[] = [];
    for (const d of DIRS) walk(join(ROOT, d), files);
    expect(files.length).toBeGreaterThan(10);
    const offenders: string[] = [];
    for (const f of files) {
      const lines = readFileSync(f, 'utf8').split('\n');
      lines.forEach((line, i) => {
        const code = line.replace(/\/\/.*$/, '');
        if (/(^|[^.\w])fetch\(/.test(code) || /\bglobalThis\.fetch\b|\bwindow\.fetch\b|require\(['"]node-fetch['"]\)|from ['"](axios|node-fetch|undici)['"]/.test(code)) {
          offenders.push(`${f.replace(ROOT + '/', '')}:${i + 1}`);
        }
      });
    }
    expect(offenders).toEqual([]);
  });

  it('كل ملف يستخدم outboundFetch يستورده من بوابة الخصوصية', () => {
    const files: string[] = [];
    for (const d of DIRS) walk(join(ROOT, d), files);
    const bad = files.filter((f) => {
      const src = readFileSync(f, 'utf8');
      return /outboundFetch\(/.test(src) && !/import \{[^}]*\boutboundFetch\b[^}]*\} from '\.\.\/privacy\/outbound-shield'/.test(src);
    });
    expect(bad).toEqual([]);
  });
});
