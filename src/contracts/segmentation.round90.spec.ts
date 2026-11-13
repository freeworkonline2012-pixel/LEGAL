import { readFileSync } from 'fs';
import { join } from 'path';
import { SegmentationService, recoverFirstHead } from './segmentation.service';
import { findAdverbialHeads } from './clause-headings-alt';

const fx = (n: string): string => readFileSync(join(__dirname, '__fixtures__', 'r90', n), 'utf8');

describe('الجولة 90: تقسيم العقود الممسوحة ذات العناوين الترتيبية الظرفية', () => {
  const svc = new SegmentationService();

  it('إيجار ممسوح (قراءة محلية): العناوين التالفة «سنادننا»/«نامنا»/«نانى ع» تُقرأ بالتسلسل فيخرج العقد بنحو 14 بنداً لا ببندين', () => {
    const r = svc.segment(fx('lease_a_ocr.txt'));
    expect(r.clauses.length).toBeGreaterThanOrEqual(14);
    const labels = r.clauses.map((c) => c.label);
    expect(labels.slice(0, 10)).toEqual(['أولاً', 'ثانياً', 'ثالثاً', 'رابعاً', 'خامساً', 'سادساً', 'سابعاً', 'ثامناً', 'تاسعاً', 'عاشراً']);
    // المتن لم يلتصق ببند واحد: أطول بند أقل من نصف النص
    const total = r.clauses.reduce((n, c) => n + c.text.length, 0);
    expect(Math.max(...r.clauses.map((c) => c.text.length))).toBeLessThan(total / 3);
    expect(r.warnings.join(' ')).toContain('عناوينه الترتيبية');
  });

  it('إيجار ممسوح ثانٍ: 14 بنداً على الأقل ولا يلتقط «رابع عشر» مكان «حادى عشر»', () => {
    const r = svc.segment(fx('lease_c_ocr.txt'));
    expect(r.clauses.length).toBeGreaterThanOrEqual(14);
    const nums = r.clauses.map((c) => c.declaredNumber);
    expect(nums.filter((n) => n === 14)).toHaveLength(1);
    expect(nums.filter((n) => n === 11)).toHaveLength(1);
  });

  it('لا يلتقط سطراً عادياً وحده كعنوان: عقد بلا عناوين ترتيبية يبقى كما هو', () => {
    const plain = 'عقد توريد\nالتمهيد\nنص عادى طويل يكفى لأن يكون متناً لا عنواناً أبداً.\nالأجرة\nنص آخر طويل يكفى لأن يكون متناً لا عنواناً أبداً.\n';
    expect(findAdverbialHeads(plain)).toEqual([]);
  });

  it('عنوان الترتيبى التالف لا يُقبل في غير موضعه المتسلسل (يبقى «ثانياً» حرفاً واحداً فقط)', () => {
    const t = 'أبرم العقد بين الطرف الأول والطرف الثانى واتفقا على الآتى:\nأولاً\nنص البند الأول وهو طويل بما يكفى لأن يكون متناً.\nثانياً\nنص البند الثانى وهو طويل بما يكفى لأن يكون متناً.\nثالثاً\nنص البند الثالث وهو طويل بما يكفى لأن يكون متناً.\n';
    const h = findAdverbialHeads(t);
    expect(h.map((x) => x.declaredNumber)).toEqual([1, 2, 3]);
  });
});

describe('الجولة 90: استرجاع البند الأول حين يضيع عنوانه', () => {
  const svc = new SegmentationService();
  const base = fx('con_b_ocr.txt');

  it('ضياع سطر «المادة الأولى» وحده: يُسترجع البند الأول من نهاية فقرة الأطراف ولا يبقى نص سابق غير مقسَّم', () => {
    const damaged = base.replace(/^المادة الأولى\n/m, '');
    expect(damaged).not.toEqual(base);
    const r = svc.segment(damaged);
    expect(r.clauses[0].declaredNumber).toBe(1);
    expect(r.clauses[0].text).toContain('التمهيد');
    expect(r.clauses.some((c) => c.label.startsWith('نص سابق'))).toBe(false);
    expect(r.warnings.join(' ')).toContain('البند الأول');
  });

  it('عنوان أول تالف قصير («المادة الاولى» → «الماده الأولي») يُستهلك عنواناً ولا يبقى فى المتن', () => {
    const damaged = base.replace(/^المادة الأولى\n/m, 'المدة الاولى\n');
    const r = svc.segment(damaged);
    expect(r.clauses[0].declaredNumber).toBe(1);
    expect(r.clauses[0].text.startsWith('المدة')).toBe(false);
  });

  it('لا استرجاع بلا فقرة أطراف: يبقى السلوك القديم', () => {
    const noParty = 'تمهيد قصير بلا تعريف أطراف يكفى طوله لكنه ليس فيه ما يدل على فقرة الأطراف أبداً ولا على بند.\nالمادة الثانية\nنص البند الثانى طويل بما يكفى ليكون متناً حقيقياً.\nالمادة الثالثة\nنص البند الثالث طويل بما يكفى ليكون متناً حقيقياً.\nالمادة الرابعة\nنص البند الرابع طويل بما يكفى ليكون متناً حقيقياً.\n';
    const heads = [
      { lineStart: noParty.indexOf('المادة الثانية'), markerStart: noParty.indexOf('المادة الثانية'), marker: 'المادة 2', rawLength: 13, declaredNumber: 2 },
    ];
    expect(recoverFirstHead(noParty, heads).recovered).toEqual([]);
  });
});
