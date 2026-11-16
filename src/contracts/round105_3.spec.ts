import * as fs from 'fs';
import * as path from 'path';
import { bestRestated, noTextDiagnosis, restatementOf, type PoolEntry } from './restatement';

/**
 * الجولة 105.3: تشخيص بنود «لا يوجد نص» ومادة صالحة يكاد البند ينقل نصها لا تُحجب عن النموذج. القياس على نصوص المكتبة نفسها (migrations/072 و073).
 */
function body(file: string, articleNo: number): string {
  const sql = fs.readFileSync(path.join(process.cwd(), 'migrations', file), 'utf8');
  const re = /SELECT id, (\d+), (-?\d+), (?:\$(h\d+)\$([\s\S]*?)\$\3\$|'([^']*)'), \$(b\w+)\$([\s\S]*?)\$\6\$/g;
  let m: RegExpExecArray | null;
  while ((m = re.exec(sql))) if (Number(m[1]) === articleNo && Number(m[2]) === 0) return m[7].replace(/\s+/g, ' ').trim();
  throw new Error(`article ${articleNo} not found in ${file}`);
}
const LAW = '072_seed_law_159_1981_companies_law.sql';
const art126 = body(LAW, 126);
const art71 = body(LAW, 71);
const art120 = body(LAW, 120);

describe('round 105.3 — restatement measure and no-text diagnosis', () => {
  it('an article restated verbatim covers fully; unrelated text covers almost nothing', () => {
    const r = restatementOf(art126, art126);
    expect(r.coverage).toBeGreaterThan(0.99);
    expect(r.numbersAgree).toBe(true);
    expect(restatementOf(art126, art120).coverage).toBeLessThan(0.3);
  });

  it('a clause that edits a quantity does not agree on numbers (even when the other words match)', () => {
    const edited = art126.replace('ربع رأس المال', 'عشر رأس المال');
    const r = restatementOf(edited, art126);
    expect(r.coverage).toBeGreaterThan(0.8);
    expect(r.numbersAgree).toBe(false);
  });

  it('tolerates the usual template adaptation (partners instead of shareholders)', () => {
    const adapted = art71.replace(/المساهمين/g, 'الشركاء').replace(/المساهم/g, 'الشريك');
    expect(restatementOf(adapted, art71).coverage).toBeGreaterThan(0.85);
  });

  it('bestRestated returns the closest article above the show threshold, null below it or for very short clauses', () => {
    const pool = [{ id: '126', text: art126 }, { id: '120', text: art120 }];
    expect(bestRestated(art126, pool)?.article.id).toBe('126');
    expect(bestRestated('يلتزم الشريك بالمواعيد المتفق عليها فقط', pool)).toBeNull();
    expect(bestRestated(art120, [{ id: '126', text: art126 }])).toBeNull();
  });

  const entry = (id: string, text: string, shown: boolean, gate: PoolEntry['gate']): PoolEntry => ({ id, text, shown, gate });

  it('classifies a clause whose closest article is a gated stock-chapter article as a legitimate no-text', () => {
    const adapted = art71.replace(/المساهمين/g, 'الشركاء');
    const d = noTextDiagnosis(adapted, [entry('159/1981#71', art71, false, 'dropped-company'), entry('159/1981#120', art120, true, 'kept')]);
    expect(d.cls).toBe('stock-article-restated');
    expect(d.line).toContain('159/1981#71');
    expect(d.line).toContain('dropped-company');
  });

  it('classifies an eligible near-restated article by whether the model was shown it', () => {
    const shown = noTextDiagnosis(art126, [entry('159/1981#126', art126, true, 'kept')]);
    const hidden = noTextDiagnosis(art126, [entry('159/1981#126', art126, false, 'kept')]);
    expect(shown.cls).toBe('eligible-restated-shown');
    expect(hidden.cls).toBe('eligible-restated-not-shown');
  });

  it('reports no-restatement for unrelated text and too-short for short clauses; the line never contains clause text', () => {
    const clause = 'تلتزم الشركة بسداد أتعاب الخبير الاستشارى عن كل دراسة جدوى يطلبها مجلس المديرين خلال مدة التنفيذ المتفق عليها بين الطرفين فى هذا العقد';
    const d = noTextDiagnosis(clause, [entry('159/1981#126', art126, true, 'kept')]);
    expect(d.cls).toBe('no-restatement');
    expect(d.line).not.toContain('أتعاب');
    expect(noTextDiagnosis('نسخة لكل شريك', [entry('159/1981#126', art126, true, 'kept')]).cls).toBe('too-short');
  });
});
