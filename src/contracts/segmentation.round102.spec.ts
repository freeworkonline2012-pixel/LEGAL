import { readFileSync } from 'fs';
import { join } from 'path';
import { SegmentationService } from './segmentation.service';
import { findAlternativeHeads, findGarbledNumberHeads } from './clause-headings-alt';

const fx = (n: string): string => readFileSync(join(__dirname, '__fixtures__', 'r102', n), 'utf8');

describe('الجولة 102: عناوين «مادة» التالفة الأرقام فى القراءة الآلية', () => {
  const svc = new SegmentationService();
  const text = fx('llc_garbled_articles_ocr.txt');

  it('نموذج عقد التأسيس (أسطر العناوين من لوج الإنتاج): 11 مادة بدل صفر، بأرقام تسلسلية', () => {
    const heads = findGarbledNumberHeads(text);
    expect(heads.map((h) => h.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
    expect(heads.every((h) => h.numberRecovered)).toBe(true);
  });

  it('segment(): بنود حقيقية بمتون غير ملتصقة، وتنبيه صريح بأن الأرقام أُسنِدت بالتسلسل', () => {
    const r = svc.segment(text);
    expect(r.clauses.length).toBe(11);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
    expect(r.clauses[2].text).toContain('التمهيد السابق');
    expect(r.clauses[10].text).toContain('ميزانية الشركة');
    expect(r.warnings.join(' ')).toContain('أرقام عناوين «المادة» تالفة');
  });

  it('إحالة داخل جملة («المادة (114) من قانون الشركات») ليست عنواناً', () => {
    const t = 'يلتزم الشركاء بأحكام المادة (114) من قانون الشركات.\nوتسرى المادة (5) على ذلك.\nنص آخر.\nمادة\nنص.\n';
    expect(findGarbledNumberHeads(t)).toEqual([]);
  });

  it('عنوانان فقط لا يكفيان (لا ترقيم)', () => {
    expect(findGarbledNumberHeads('مادة )١(\nنص طويل.\nمادة (؟)\nنص.\n')).toEqual([]);
  });

  it('أرقام مقروءة تخالف الترتيب كثيراً ⇒ يُرفض (ليست تسلسل مواد)', () => {
    const t = 'مادة (9)\nنص.\nمادة (7)\nنص.\nمادة (4)\nنص.\nمادة (2)\nنص.\n';
    expect(findGarbledNumberHeads(t)).toEqual([]);
  });

  it('عقد سليم الترقيم لا يمسّه الاسترجاع: «المادة 1، 2، 3» تُقرأ كما هى وبلا علامة استرجاع', () => {
    const t = 'المادة 1\nنص البند الأول طويل بما يكفى.\nالمادة 2\nنص البند الثانى طويل بما يكفى.\nالمادة 3\nنص البند الثالث طويل بما يكفى.\n';
    const h = findAlternativeHeads(t);
    expect(h.map((x) => x.declaredNumber)).toEqual([1, 2, 3]);
    expect(h.some((x) => x.numberRecovered)).toBe(false);
    expect(svc.segment(t).warnings.join(' ')).not.toContain('أرقام عناوين «المادة» تالفة');
  });
});
