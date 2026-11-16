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

  it('أرقام مقروءة تبتعد كثيراً عن ترتيبها ⇒ يُرفض (ليست تسلسل مواد)', () => {
    const t = 'مادة (41)\nنص.\nمادة (52)\nنص.\nمادة (63)\nنص.\nمادة (74)\nنص.\n';
    expect(findGarbledNumberHeads(t)).toEqual([]);
  });

  it('عقد سليم الترقيم لا يمسّه الاسترجاع: «المادة 1، 2، 3» تُقرأ كما هى وبلا علامة استرجاع', () => {
    const t = 'المادة 1\nنص البند الأول طويل بما يكفى.\nالمادة 2\nنص البند الثانى طويل بما يكفى.\nالمادة 3\nنص البند الثالث طويل بما يكفى.\n';
    const h = findAlternativeHeads(t);
    expect(h.map((x) => x.declaredNumber)).toEqual([1, 2, 3]);
    expect(h.some((x) => x.numberRecovered)).toBe(false);
    expect(svc.segment(t).warnings.join(' ')).not.toContain('أرقام عناوين «المادة» تالفة');
  });

  describe('قراءة محلية كاملة للنموذج الرسمى (11 صفحة) بنفس محرك OCR', () => {
    const real = fx('llc_template_local_ocr.txt');

    it('الكلمة نفسها قد تتشوّه («Baka»، «bale») والأقواس تنعكس والأرقام تتلف: يخرج العقد بنحو 39 مادة بدل صفر', () => {
      const r = svc.segment(real);
      expect(r.clauses.length).toBeGreaterThanOrEqual(36);
      const nums = r.clauses.map((c) => c.declaredNumber);
      expect(nums).toEqual(nums.map((_, i) => i + 1));
      expect(r.warnings.join(' ')).toContain('أرقام عناوين «المادة» تالفة');
    });

    it('المتون لا تلتصق ببند واحد: أطول بند أقل من 15% من النص', () => {
      const r = svc.segment(real);
      const total = r.clauses.reduce((n, c) => n + c.text.length, 0);
      expect(Math.max(...r.clauses.map((c) => c.text.length))).toBeLessThan(total * 0.15);
    });

    it('الأشكال المشوّهة المسجَّلة تُلتقط كلها: «Baka )2(» و«(A) Baka» و«١ مادة (VY)» و«مادة 59 )»', () => {
      const t = ['مادة (1)', 'نص', 'Baka )2(', 'نص', '(A) Baka', 'نص', '١ مادة (VY)', 'نص', 'مادة 59 )', 'نص'].join('\n');
      expect(findGarbledNumberHeads(t)).toHaveLength(5);
    });

    it('كلمة لاتينية بأقواس لا تكفى وحدها: «Page (1)» بلا «مادة» لا تُعدّ عناوين', () => {
      const t = ['Page (1)', 'نص', 'Page (2)', 'نص', 'Page (3)', 'نص', 'Page (4)', 'نص'].join('\n');
      expect(findGarbledNumberHeads(t)).toEqual([]);
    });

    it('إحالة ملفوفة («المادة (5)» ثم سطر «من القانون…») ليست عنواناً', () => {
      const t = ['مادة (1)', 'نص', 'مادة (2)', 'نص', 'مادة (3)', 'نص', 'المادة (5)', 'من القانون المدنى'].join('\n');
      expect(findGarbledNumberHeads(t)).toHaveLength(3);
    });
  });
});
