import * as fs from 'fs';
import * as path from 'path';
import { articleFitsCompanyForm, chapterKindMap, chapterKindOf, llcArticleScope, type ChapterKind } from './company-form-scope';
import { normalizeArabicForMatch } from './reasoning.util';

/**
 * الجولة 105.1: بوابة شكل الشركة تقرأ باب/فصل المادة المخزَّن فى المكتبة. الأساس الحقيقى للقياس هنا هو بيانات المكتبة نفسها
 * (migrations/072 لقانون 159/1981 وmigrations/073 للائحة 96/1982): لكل مادة فيهما باب وفصل مخزّن، فنقيس البوابة على كامل المادتين.
 */
interface Row {
  lawNo: number;
  lawYear: number;
  articleNo: number;
  suffix: number;
  location: string;
  body: string;
}

function loadRows(): Row[] {
  const files: Array<[string, number, number]> = [
    ['migrations/072_seed_law_159_1981_companies_law.sql', 159, 1981],
    ['migrations/073_seed_reg_96_1982_companies_law_executive_regulations.sql', 96, 1982],
  ];
  const rows: Row[] = [];
  for (const [f, lawNo, lawYear] of files) {
    const sql = fs.readFileSync(path.join(process.cwd(), f), 'utf8');
    const re = /SELECT id, (\d+), (-?\d+), (?:\$(h\d+)\$([\s\S]*?)\$\3\$|'([^']*)'), \$(b\w+)\$([\s\S]*?)\$\6\$/g;
    let m: RegExpExecArray | null;
    while ((m = re.exec(sql))) {
      rows.push({ lawNo, lawYear, articleNo: Number(m[1]), suffix: Number(m[2]), location: (m[4] ?? m[5] ?? '').replace(/\s+/g, ' ').trim(), body: m[7] });
    }
  }
  return rows;
}

const rows = loadRows();
const kindOf = (r: Row): ChapterKind | null => chapterKindOf(r.lawNo, r.lawYear, r.location);
const llc = (r: Row) => articleFitsCompanyForm('llc', { lawNo: r.lawNo, lawYear: r.lawYear, snippet: r.body }, kindOf(r));


const row = (lawNo: number, no: number) => rows.find((x) => x.lawNo === lawNo && x.articleNo === no && x.suffix === 0)!;
const kinds = chapterKindMap(rows.map((r) => ({ lawNo: r.lawNo, lawYear: r.lawYear, articleNo: r.articleNo, location: r.location })));

describe('round 105.2 — LLC-chapter candidates join the clause search; stock-chapter vocabulary completed', () => {
  it('llcArticleScope lists exactly the unambiguous LLC-chapter articles of each law', () => {
    const scope = llcArticleScope(kinds);
    const law = scope.find((s) => s.lawNo === 159)!;
    const reg = scope.find((s) => s.lawNo === 96)!;
    for (const n of [116, 120, 126, 128]) expect(law.articleNos).toContain(n);
    for (const n of [59, 61, 65, 74, 271, 276, 281, 284, 286]) expect(reg.articleNos).toContain(n);
    for (const n of [71, 72, 76, 90]) expect(law.articleNos).not.toContain(n);
    for (const n of [215, 216, 229, 233, 257, 261]) expect(reg.articleNos).not.toContain(n);
    // كل ما فى القائمة مخزَّن تحت فصل LLC، وكل مادة LLC غير ملتبسة فيها
    for (const s of scope) for (const n of s.articleNos) expect(kinds.get(`${s.lawNo}-${s.lawYear}-${n}`)).toBe('llc');
    const expected = [...kinds.entries()].filter(([, k]) => k === 'llc').length;
    expect(scope.reduce((a, s) => a + s.articleNos.length, 0)).toBe(expected);
  });

  it('llcArticleScope is empty without a chapter map (no scoping, no surprise)', () => {
    expect(llcArticleScope(null)).toEqual([]);
    expect(llcArticleScope(new Map())).toEqual([]);
    expect(llcArticleScope(new Map([['159-1981-71', 'stock' as ChapterKind]]))).toEqual([]);
  });

  it('stock-chapter articles about other forms are now dropped: art. 257 (limited partnership by shares), 261 (supervisory board), 214 (bondholders)', () => {
    for (const no of [257, 261, 214]) {
      const r = row(96, no);
      expect(kindOf(r)).toBe('stock');
      expect(llc(r)).toBe(false);
    }
  });

  it('generic provisions inside the stock chapters that name no stock-only concept stay available (fiscal year, venue of the assembly, agenda)', () => {
    for (const no of [186, 201, 207]) {
      const r = row(96, no);
      expect(kindOf(r)).toBe('stock');
      expect(llc(r)).toBe(true);
    }
  });

  it('measured on the library: at least 75% of the regulation stock-chapter articles and 80% of the law stock-chapter articles are removed; LLC chapters lose none', () => {
    const ratio = (lawNo: number) => {
      const st = rows.filter((r) => r.lawNo === lawNo && kindOf(r) === 'stock');
      return st.filter((r) => !llc(r)).length / st.length;
    };
    expect(ratio(96)).toBeGreaterThanOrEqual(0.75);
    expect(ratio(159)).toBeGreaterThanOrEqual(0.8);
    expect(rows.filter((r) => kindOf(r) === 'llc' && !llc(r))).toEqual([]);
  });
});
