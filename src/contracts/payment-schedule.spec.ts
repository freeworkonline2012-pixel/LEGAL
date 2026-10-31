import { extractKeyTerms } from './key-terms';
import { buildPaymentSchedules } from './payment-schedule';

const clause = (clauseIndex: number, clauseText: string) => ({ clauseIndex, clauseLabel: `البند ${clauseIndex}`, clauseTitle: null, clauseText });

describe('buildPaymentSchedules (الجولة 34)', () => {
  it('ثلاث دفعات 30/30/40 من 1,125,000: المبالغ المحسوبة صحيحة والمجموع 100%', () => {
    const t = extractKeyTerms([
      clause(2, 'تبلغ قيمة العقد 1125000 جنيه مصرى. تسدد القيمة على ثلاث دفعات: الأولى 30% عند التعاقد، والثانية 30% عند التسليم الأولى، والأخيرة 40% بعد القبول النهائى.'),
    ]);
    const [s] = buildPaymentSchedules(t);
    expect(s.total).toBe(1125000);
    expect(s.installments.map((i) => [i.percent, i.amount])).toEqual([
      [30, 337500],
      [30, 337500],
      [40, 450000],
    ]);
    expect(s.sumPercent).toBe(100);
    expect(s.verdict).toBe('consistent');
  });

  it('مجموع لا يبلغ 100% ⇒ تنبيه mismatch لا حكم', () => {
    const t = extractKeyTerms([clause(1, 'قيمة العقد 100000 جنيه. تسدد الدفعة الأولى 30% عند التوقيع والثانية 30% عند التسليم.')]);
    const [s] = buildPaymentSchedules(t);
    expect(s.sumPercent).toBe(60);
    expect(s.verdict).toBe('mismatch');
    expect(s.verdictText).toContain('وليس 100%');
  });

  it('نسبة مشكوك فيها (40 96) تساوى المتبقى ⇒ يرجَّح صحتها مع طلب المطابقة', () => {
    const t = extractKeyTerms([
      clause(2, 'قيمة العقد 1125000 جنيه. تسدد الدفعة الأولى 30% عند التوقيع والثانية 30% عند التسليم والباقى 40 96 مقابل القبول النهائى.'),
    ]);
    const [s] = buildPaymentSchedules(t);
    expect(s.installments.some((i) => i.suspect)).toBe(true);
    expect(s.verdict).toBe('suspect_consistent');
    expect(s.verdictText).toContain('يلزم مطابقتها');
  });

  it('نسبة مشكوك فيها لا تساوى المتبقى ⇒ suspect_mismatch', () => {
    const t = extractKeyTerms([
      clause(2, 'قيمة العقد 1125000 جنيه. تسدد الدفعة الأولى 30% عند التوقيع والثانية 30% عند التسليم والباقى 15 96 مقابل القبول النهائى.'),
    ]);
    const [s] = buildPaymentSchedules(t);
    expect(s.verdict).toBe('suspect_mismatch');
  });

  it('نسبة واحدة فى بند، أو نسب لا تخص السداد، لا تنتج جدولاً', () => {
    expect(buildPaymentSchedules(extractKeyTerms([clause(1, 'تسدد دفعة مقدمة 50% عند التوقيع.')]))).toEqual([]);
    expect(buildPaymentSchedules(extractKeyTerms([clause(1, 'تبلغ نسبة الفائدة 5% وتبلغ نسبة الخصم 10% للعملاء القدامى.')]))).toEqual([]);
  });

  it('بلا مبلغ فى البند: فحص المجموع فقط والمبالغ null', () => {
    const [s] = buildPaymentSchedules(extractKeyTerms([clause(3, 'تسدد الدفعة الأولى 50% عند التوقيع والثانية 50% عند التسليم.')]));
    expect(s.total).toBeNull();
    expect(s.installments.every((i) => i.amount === null)).toBe(true);
    expect(s.verdict).toBe('consistent');
  });

  it('نسبتان مشكوك فيهما ⇒ unverifiable (فشل مغلق)', () => {
    const [s] = buildPaymentSchedules(
      extractKeyTerms([clause(3, 'تسدد الدفعة الأولى 40 96 عند التوقيع والثانية 60 96 عند التسليم.')]),
    );
    expect(s.verdict).toBe('unverifiable');
  });
});

describe('buildPaymentSchedules — أساس الدفعات الصريح (عقد Blackbelts)', () => {
  const text = require('fs').readFileSync(require('path').join(__dirname, '__fixtures__', 'golden', 'blackbelts-2019.txt'), 'utf-8');
  const { SegmentationService } = require('./segmentation.service');
  const seg = new SegmentationService().segment(text);
  const terms = extractKeyTerms(seg.clauses.map((c: any, i: number) => ({ clauseIndex: i + 1, clauseLabel: c.label, clauseTitle: c.title, clauseText: c.text })));
  const [s] = buildPaymentSchedules(terms);

  it('الدفعات تُحسب على 375000 لكل مجموعة لا على 1125000', () => {
    expect(s).toBeDefined();
    expect(s.clauseLabel).toBe('البند الثالث');
    expect(s.total).toBe(375000);
    expect(s.baseBasis).toBe('explicit');
    expect(s.perUnit).toBe(true);
    expect(s.unitCount).toBe(3);
    expect(s.largestAmount).toBe(1125000);
    expect(s.installments.map((i) => i.amount)).toEqual([112500, 112500, 150000]);
    expect(s.verdict).toBe('consistent');
  });

  it('بلا نص صريح يبقى الافتراض القديم (أكبر مبلغ) ويُوسَم بذلك', () => {
    const [d] = buildPaymentSchedules(extractKeyTerms([clause(2, 'تبلغ قيمة العقد 1125000 جنيه مصرى. تسدد 30% عند التعاقد و30% عند التسليم و40% بعد القبول.')]));
    expect(d.baseBasis).toBe('largest');
    expect(d.perUnit).toBe(false);
    expect(d.unitCount).toBeNull();
  });
});
