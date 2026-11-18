import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { detectBlockingPersonalData, personalDataStopMessage, piiBlockFromEnv } from './personal-data-guard';

describe('detectBlockingPersonalData', () => {
  it('يوقف على الرقم القومى (لاتينى وهندى وبفراغات القراءة الآلية)', () => {
    expect(detectBlockingPersonalData('الرقم القومى 29001011234567')?.counts.national_id).toBe(1);
    expect(detectBlockingPersonalData('الرقم القومى ٢٩٠٠١٠١١٢٣٤٥٦٧')?.counts.national_id).toBe(1);
    expect(detectBlockingPersonalData('الرقم القومى 2900 1011 2345 67')?.counts.national_id).toBe(1);
  });

  it('يوقف على الهاتف المحمول والأرضى والدولى', () => {
    expect(detectBlockingPersonalData('اتصال 01012345678')?.counts.phone).toBe(1);
    expect(detectBlockingPersonalData('اتصال +20 100 123 4567')?.counts.phone).toBe(1);
    expect(detectBlockingPersonalData('هاتف أرضى 0233456789')?.counts.phone).toBe(1);
  });

  it('يوقف على IBAN والبطاقة البنكية ورقم الحساب المسبوق بما يدل عليه', () => {
    expect(detectBlockingPersonalData('IBAN EG380019000500000000263180002')?.counts.bank_account).toBe(1);
    expect(detectBlockingPersonalData('بطاقة 4111 1111 1111 1111')?.counts.bank_account).toBe(1);
    expect(detectBlockingPersonalData('يُسدد فى حساب البنك الأهلى رقم 1234567890123')?.counts.bank_account).toBe(1);
    expect(detectBlockingPersonalData('Account No: 1234567890123')?.counts.bank_account).toBe(1);
  });

  it('لا يوقف على رقم طويل مجرد بلا دلالة حساب (رقم عقد/سجل)', () => {
    expect(detectBlockingPersonalData('عقد رقم 20261118001234 المؤرخ أول العام')).toBeNull();
  });

  it('لا يوقف على أرقام العقود المعتادة: مبالغ وتواريخ وقوانين ومدد ونسب', () => {
    const clean = [
      'القانون رقم 131 لسنة 1948 والمادة 147 والقانون 82 لسنة 2002',
      'مبلغ 1,250,000 جنيه مصرى بواقع 15% سنوياً لمدة 36 شهراً اعتباراً من 01/01/2026',
      'أجرة شهرية 12500 جنيه وتأمين 25000 جنيه وغرامة 5000 جنيه عن كل يوم',
      'سجل تجارى 96851 وبطاقة ضريبية 123-456-789',
    ].join('\n');
    expect(detectBlockingPersonalData(clean)).toBeNull();
  });

  it('يعيد الأنواع والأعداد وأرقام الأسطر ولا يعيد أى قيمة', () => {
    const text = 'سطر أول\nالرقم القومى 29001011234567\nهاتف 01012345678 وهاتف 01112345678\nحساب رقم 1234567890123';
    const f = detectBlockingPersonalData(text)!;
    expect(f.counts).toEqual({ national_id: 1, phone: 2, bank_account: 1 });
    expect(f.total).toBe(4);
    expect(f.lines).toEqual([2, 3, 4]);
    const msg = personalDataStopMessage(f);
    expect(msg).toContain('1 رقم قومى');
    expect(msg).toContain('2 رقم هاتف');
    expect(msg).toContain('1 حساب بنكى');
    for (const value of ['29001011234567', '01012345678', '01112345678', '1234567890123']) expect(msg).not.toContain(value);
  });

  it('piiBlockFromEnv: يعمل افتراضياً ويُعطَّل بـoff فقط', () => {
    expect(piiBlockFromEnv({} as NodeJS.ProcessEnv)).toBe(true);
    expect(piiBlockFromEnv({ CONTRACT_PII_BLOCK: 'OFF' } as unknown as NodeJS.ProcessEnv)).toBe(false);
    expect(piiBlockFromEnv({ CONTRACT_PII_BLOCK: 'on' } as unknown as NodeJS.ProcessEnv)).toBe(true);
  });
});

/** عقود العيّنات المحفوظة (بلا هويات حقيقية): الحارس لا يوقف أياً منها. */
describe('الحارس على عقود العيّنات', () => {
  const files: string[] = [];
  const walk = (dir: string) => {
    for (const n of readdirSync(dir)) {
      const p = join(dir, n);
      if (statSync(p).isDirectory()) walk(p);
      else if (p.endsWith('.txt')) files.push(p);
    }
  };
  walk(join(__dirname, '..', 'contracts', '__fixtures__'));

  it.each(files.map((f) => [f.split('__fixtures__/')[1], f]))('%s: لا إيقاف كاذب', (_n, f) => {
    expect(detectBlockingPersonalData(readFileSync(f, 'utf8'))).toBeNull();
  });
});
