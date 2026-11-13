import { SegmentationService } from './segmentation.service';

/** عقد إيجار ممسوح: كل كلمة ترتيبية وحدها فى سطر، و«أولاً» قُرئت «Vol»، وكلمة «الطرف» فى «الطرف الثانى» تالفة (من نص قراءة حقيقى لعقد الاختبار). */
const body = (t: string) => `${t}: يلتزم الطرف المعنى بما ورد فى هذا البند وفق ما اتفق عليه الطرفان فى هذا العقد وبالشروط المبينة فيه كاملة.`;
const scanned = (withFirst: boolean) =>
  [
    'أبرم هذا العقد فى مدينة القاهرة بين السيدة/ سعاد إبراهيم (وتشار إليها بالمؤجرة أو الطرف',
    'الأول) والسيد/ مراد عبدالله (ويشار إليه بالمستأجر أو Slat الثانى):',
    '',
    withFirst ? 'أولاً' : 'Vol',
    '',
    body('التمهيد'),
    '',
    'ثانياً',
    '',
    body('العين المؤجرة'),
    '',
    'ثالثاً',
    '',
    body('مدة الإيجار'),
    '',
    'رابعا',
    '',
    body('الأجرة'),
    '',
    ':خامسا',
    '',
    body('السداد'),
  ].join('\n');

describe('الجولة 91.1: تسلسل ترتيبى ضاعت منه «أولاً» وكلمة «الطرف» تالفة', () => {
  it('يُقبل التسلسل المبتدئ بـ2 ويُسترجع البند الأول من فقرة الأطراف', () => {
    const r = new SegmentationService().segment(scanned(false));
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5]);
    expect(r.clauses[0].text).toContain('التمهيد');
    expect(r.clauses[0].text).not.toContain('أبرم هذا العقد');
    expect(r.warnings.some((w) => w.includes('البند الأول'))).toBe(true);
  });
  it('الأول مقروء سليماً ⇒ السلوك السابق', () => {
    const r = new SegmentationService().segment(scanned(true));
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5]);
  });
  it('ثلاثة عناوين فقط تبدأ بـ2 لا تكفى (لا تخمين)', () => {
    const t = ['مذكرة داخلية للعلم', 'ثانياً', body('نص أول'), 'ثالثاً', body('نص ثان'), 'رابعا', body('نص ثالث')].join('\n\n');
    const r = new SegmentationService().segment(t);
    expect(r.clauses.map((c) => c.declaredNumber)).not.toContain(2);
  });
});
