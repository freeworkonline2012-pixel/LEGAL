import * as fs from 'fs';
import * as path from 'path';
import { articleFitsCompanyForm, chapterKindMap, chapterKindOf, type ChapterKind } from './company-form-scope';
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

describe('round 105.1 — company-form gate reads the stored chapter of each article', () => {
  it('loads both laws from the library migrations', () => {
    expect(rows.filter((r) => r.lawNo === 159).length).toBeGreaterThan(200);
    expect(rows.filter((r) => r.lawNo === 96).length).toBeGreaterThan(350);
  });

  it('classifies the chapters (law: stock / LLC / other; regulation: by part and chapter)', () => {
    expect(chapterKindOf(159, 1981, 'الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة / 2- الجمعية العامة')).toBe('stock');
    expect(chapterKindOf(159, 1981, 'الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثانى - شركات التوصية بالأسهم')).toBe('stock');
    expect(chapterKindOf(159, 1981, 'الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة')).toBe('llc');
    expect(chapterKindOf(159, 1981, 'الباب الرابع - تصفية الشركة')).toBe('other');
    expect(chapterKindOf(96, 1982, 'الباب الثانى > الفصل الأول > الفرع الثانى: إدارة الشركة > ثالثاً: الجمعية العامة غير العادية')).toBe('stock');
    expect(chapterKindOf(96, 1982, 'الباب الثانى > الفصل الثانى > الفرع الثانى: إدارة الشركة')).toBe('llc');
    expect(chapterKindOf(96, 1982, 'الباب الأول: فى تأسيس الشركات > الفصل الأول: تأسيس شركات المساهمة والتوصية بالأسهم > الفرع الأول: فى الأحكام العامة')).toBe('stock');
    expect(chapterKindOf(96, 1982, 'الباب الأول > الفصل الثانى: فى تأسيس الشركات ذات المسئولية المحدودة > الفرع الأول: فى الأحكام العامة')).toBe('llc');
    expect(chapterKindOf(96, 1982, 'الباب الثانى > الفصل الثالث: شركات الشخص الواحد')).toBe('other');
    expect(chapterKindOf(96, 1982, 'الباب الثالث: الاندماج وتغيير شكل الشركة والتقسيم > الفصل الأول: الاندماج')).toBe('other');
    expect(chapterKindOf(96, 1982, '')).toBeNull();
    expect(chapterKindOf(96, 1982, null)).toBeNull();
    expect(chapterKindOf(131, 1948, 'الباب الأول > الفصل الأول')).toBeNull();
  });

  it('never drops an article stored under the limited-liability-company chapters (zero false drops, whole law and regulation)', () => {
    const llcRows = rows.filter((r) => kindOf(r) === 'llc');
    expect(llcRows.length).toBeGreaterThanOrEqual(40);
    expect(llcRows.filter((r) => !llc(r))).toEqual([]);
  });

  it('drops every stock-chapter article that speaks in joint-stock vocabulary (unless it names LLCs explicitly)', () => {
    const stockRows = rows.filter((r) => kindOf(r) === 'stock');
    expect(stockRows.length).toBeGreaterThan(300);
    const stockSpeaking = stockRows.filter((r) => /مساهم|الاسهم|السهم|مجلس الاداره/.test(normalizeArabicForMatch(r.body)) && !/ذات (ال)?مسئوليه (ال)?محدوده/.test(normalizeArabicForMatch(r.body)));
    expect(stockSpeaking.length).toBeGreaterThan(200);
    expect(stockSpeaking.filter((r) => llc(r))).toEqual([]);
  });

  it('beats the R105 vocabulary-only gate on the regulation: far more stock-chapter articles are removed', () => {
    const stock96 = rows.filter((r) => r.lawNo === 96 && kindOf(r) === 'stock');
    const droppedByVocabulary = stock96.filter((r) => !articleFitsCompanyForm('llc', { lawNo: r.lawNo, lawYear: r.lawYear, snippet: r.body })).length;
    const droppedByChapter = stock96.filter((r) => !llc(r)).length;
    expect(droppedByChapter).toBeGreaterThan(droppedByVocabulary * 1.5);
  });

  it('art. 229 of the regulation (general-assembly quorum of joint-stock companies) leaked through the vocabulary gate and is now dropped', () => {
    const r = rows.find((x) => x.lawNo === 96 && x.articleNo === 229 && x.suffix === 0)!;
    expect(r).toBeDefined();
    expect(/مساهمون/.test(r.body)).toBe(true);
    expect(articleFitsCompanyForm('llc', { lawNo: 96, lawYear: 1982, snippet: r.body })).toBe(true); // بلا باب: سلوك R105 كما كان
    expect(kindOf(r)).toBe('stock');
    expect(llc(r)).toBe(false);
  });

  it('articles that govern an LLC stay: law art. 126 (LLC assembly quorum), art. 120 (managers), regulation art. 286 (LLC assembly)', () => {
    for (const [lawNo, no] of [[159, 126], [159, 120], [96, 286], [96, 281]] as Array<[number, number]>) {
      const r = rows.find((x) => x.lawNo === lawNo && x.articleNo === no && x.suffix === 0)!;
      expect(r).toBeDefined();
      expect(kindOf(r)).toBe('llc');
      expect(llc(r)).toBe(true);
    }
  });

  it('stays conservative: unknown location falls back to the vocabulary rule; other laws and non-LLC contracts are untouched', () => {
    const stockOnly = 'يحق للمساهم حضور الجمعية وللأسهم حق التصويت وينتخب مجلس الإدارة.';
    expect(articleFitsCompanyForm('llc', { lawNo: 159, lawYear: 1981, snippet: stockOnly }, null)).toBe(false);
    expect(articleFitsCompanyForm('llc', { lawNo: 159, lawYear: 1981, snippet: stockOnly }, 'other')).toBe(false);
    expect(articleFitsCompanyForm('llc', { lawNo: 131, lawYear: 1948, snippet: stockOnly }, 'stock')).toBe(true);
    expect(articleFitsCompanyForm(null, { lawNo: 159, lawYear: 1981, snippet: stockOnly }, 'stock')).toBe(true);
    expect(articleFitsCompanyForm('llc', { lawNo: 159, lawYear: 1981, snippet: 'تسرى هذه المادة على الشركات ذات المسئولية المحدودة والمساهمين فيها.' }, 'stock')).toBe(true);
    expect(articleFitsCompanyForm('llc', { lawNo: 159, lawYear: 1981, snippet: 'يجوز التأشير على السجل التجارى بما يطرأ على العقد.' }, 'stock')).toBe(true);
  });

  it('chapterKindMap: duplicated article numbers across kinds (issuance vs law articles) and unknown locations are left to the vocabulary rule', () => {
    const map = chapterKindMap([
      { lawNo: 159, lawYear: 1981, articleNo: 4, location: 'مواد الإصدار' },
      { lawNo: 159, lawYear: 1981, articleNo: 4, location: 'الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة' },
      { lawNo: 159, lawYear: 1981, articleNo: 71, location: 'الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الأول - شركات المساهمة / ثانياً: إدارة الشركة' },
      { lawNo: 159, lawYear: 1981, articleNo: 120, location: 'الباب الثانى - الأحكام الخاصة بأنواع الشركات / الفصل الثالث - الشركات ذات المسئولية المحدودة / 2- إدارة الشركة' },
      { lawNo: 96, lawYear: 1982, articleNo: 500, location: null },
    ]);
    expect(map.has('159-1981-4')).toBe(false);
    expect(map.get('159-1981-71')).toBe('stock');
    expect(map.get('159-1981-120')).toBe('llc');
    expect(map.has('96-1982-500')).toBe(false);
  });
});
