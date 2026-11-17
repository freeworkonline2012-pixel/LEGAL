import { SegmentationService } from './segmentation.service';
import { findTolerantBareHeads } from './clause-headings-alt';

// نص اصطناعى بشكل عقد الإنتاج: عناوين مجردة 1،3…9 (العقد نفسه يقفز من 1 إلى 3) ثم عنوان عاشر قرأته القراءة الآلية «0.» (لا نص ولا أسماء من عقد حقيقى)
const body = (w: string) => `${w} يلتزم الطرف المعنى بما هو مبين فى هذا البند وفق ما تقتضيه طبيعة الخدمة المتفق عليها بين الطرفين.`;
const heads = (nums: number[]) => nums.flatMap((n) => [`${n}. عنوان رقم ${['صفر', 'واحد', 'اثنان', 'ثلاثة', 'اربعة', 'خمسة', 'ستة', 'سبعة', 'ثمانية', 'تسعة'][n % 10]}`, body('نص'), '']);
const base = (tail: string[]) => ['عقد خدمات', 'بين شركة الاولى وشركة الثانية', ...heads([1, 3, 4, 5, 6, 7, 8, 9]), ...tail].join('\n');

const seg = (t: string) => new SegmentationService().segment(t);

describe('الجولة 109: عنوان العاشر المقروء «0.»', () => {
  it('«0. متفرقات» بعد التاسع عنوان للبند 10 فلا يلتصق بالتاسع', () => {
    const t = base(['0. متفرقات', body('تشكل هذه الاتفاقية الكاملة بين الطرفين'), 'يجب أن تكون التعديلات مكتوبة وموقعة من كلا الطرفين.']);
    const r = seg(t);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 3, 4, 5, 6, 7, 8, 9, 10]);
    expect(r.clauses[7].text).not.toContain('متفرقات');
    expect(r.clauses[7].text).not.toContain('التعديلات');
    expect(r.clauses[7].title).toContain('تسعة');
    expect(r.clauses[8].title).toContain('متفرقات');
    expect(r.clauses[8].text).toContain('التعديلات');
    expect(r.warnings.some((w) => w.includes('ترقيم البنود'))).toBe(true);
  });

  it('«٠.» بالهندية والقوس «0)» يُقبلان أيضاً', () => {
    expect(findTolerantBareHeads(base(['٠. متفرقات', body('نص')])).map((h) => h.declaredNumber)).toContain(10);
    expect(findTolerantBareHeads(base(['0) متفرقات', body('نص')])).map((h) => h.declaredNumber)).toContain(10);
  });

  it('«0.» بعد التاسع عشر عنوان للعشرين', () => {
    const nums = Array.from({ length: 19 }, (_, i) => i + 1);
    const t = ['عقد', 'بين شركة وشركة', ...heads(nums.filter((n) => n !== 2)), '0. أحكام ختامية', body('نص')].join('\n');
    expect(findTolerantBareHeads(t).map((h) => h.declaredNumber).slice(-2)).toEqual([19, 20]);
  });

  it('سلبيات: «0.» جملة طويلة، أو بلا علامة وقف، أو لا تسبقه 9 فى السلسلة، لا تُقبل', () => {
    const long = '0. تحل أى نزاعات عن طريق المفاوضات الودية وإلا فتعرض على الاختصاص القضائى الحصرى للمحاكم المختصة';
    expect(findTolerantBareHeads(base([long, body('نص')])).map((h) => h.declaredNumber)).not.toContain(10);
    expect(findTolerantBareHeads(base(['0 متفرقات', body('نص')])).map((h) => h.declaredNumber)).not.toContain(10);
    // السلسلة بلغت 7 فقط: «0.» لا تُسنَد 8
    const shortChain = ['عقد', 'بين شركة وشركة', ...heads([1, 3, 4, 5, 6, 7]), '0. متفرقات', body('نص')].join('\n');
    expect(findTolerantBareHeads(shortChain).map((h) => h.declaredNumber)).toEqual([1, 3, 4, 5, 6, 7]);
  });

  it('نقطة قائمة مقروءة «0 تخضع…» وسط البند لا تُحدث عنواناً', () => {
    const t = base(['0 تخضع هذه الاتفاقية وتفسر بموجب القانون المصرى', '0 تحل النزاعات ودياً']);
    expect(seg(t).clauses.map((c) => c.declaredNumber)).toEqual([1, 3, 4, 5, 6, 7, 8, 9]);
  });

  it('عقد بلا «0.» يخرج كما كان (الجولة 106 دون تغيير)', () => {
    expect(seg(base([])).clauses.map((c) => c.declaredNumber)).toEqual([1, 3, 4, 5, 6, 7, 8, 9]);
  });
});
