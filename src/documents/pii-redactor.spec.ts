import { redactPersonalData } from './pii-redactor';

describe('redactPersonalData', () => {
  it('يخفى الرقم القومى بالأرقام اللاتينية والهندية', () => {
    const a = redactPersonalData('الرقم القومى 29001011234567 للعامل');
    expect(a.text).toBe('الرقم القومى [رقم قومى محجوب] للعامل');
    expect(a.counts.national_id).toBe(1);
    const b = redactPersonalData('الرقم القومى ٢٩٠٠١٠١١٢٣٤٥٦٧ للعامل');
    expect(b.text).toContain('[رقم قومى محجوب]');
    expect(b.text).not.toMatch(/[٠-٩]{10}/);
  });

  it('لا يخفى رقماً من 14 خانة بتركيب غير صالح لرقم قومى (شهر 99)', () => {
    const r = redactPersonalData('رقم 29099011234567 ');
    expect(r.counts.national_id).toBe(0);
    // لكنه رقم طويل فيُخفى كرقم عام
    expect(r.counts.long_number).toBe(1);
  });

  it('يخفى الهواتف المصرية بصيغها', () => {
    const t = 'اتصل 01012345678 أو +201112345678 أو 002 0 1212345678 أو 0227654321';
    const r = redactPersonalData(t);
    expect(r.counts.phone).toBeGreaterThanOrEqual(3);
    expect(r.text).not.toContain('01012345678');
    expect(r.text).not.toContain('0227654321');
  });

  it('يخفى البريد وIBAN والبطاقة (Luhn) والجواز', () => {
    const r = redactPersonalData(
      'a.b@example.com EG380019000500000000263180002 بطاقة 4539 1488 0343 6467 جواز A12345678',
    );
    expect(r.counts.email).toBe(1);
    expect(r.counts.iban).toBe(1);
    expect(r.counts.card).toBe(1);
    expect(r.counts.passport).toBe(1);
  });

  it('لا يمس المبالغ والتواريخ والمدد', () => {
    const t = 'الأجر 12000 جنيه شهرياً من 2021/03/15 لمدة 36 شهراً وبمبلغ 1,250,000 جنيه';
    const r = redactPersonalData(t);
    expect(r.text).toBe(t);
    expect(r.total).toBe(0);
  });

  it('رقم حساب طويل يُخفى', () => {
    const r = redactPersonalData('حساب رقم 1234567890123 بالبنك');
    expect(r.counts.long_number).toBe(1);
    expect(r.text).toContain('[رقم محجوب]');
  });

  it('يخفى الرقم القومى الذى قطّعته القراءة الآلية بفراغات وعلامات اتجاه', () => {
    const r = redactPersonalData('الرقم 2900101 \u200e1234567 للعامل');
    expect(r.counts.national_id).toBe(1);
    expect(r.text).not.toMatch(/1234567/);
    const spaced = redactPersonalData('2 9001 01 123 4567');
    expect(spaced.counts.national_id).toBe(1);
  });

  it('لا يخفى تواريخ متجاورة تشبه رقماً قومياً بتركيب غير صالح', () => {
    const r = redactPersonalData('من 2021/03/15 إلى 2022/04/16');
    expect(r.total).toBe(0);
  });

  it('لا تداخل: الرقم القومى لا يُحتسب مرتين', () => {
    const r = redactPersonalData('29001011234567');
    expect(r.total).toBe(1);
  });
});
