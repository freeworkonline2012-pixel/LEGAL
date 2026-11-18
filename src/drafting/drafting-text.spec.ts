import { countPhrase, dayAndDate, egpInWords, endOfTerm, formatDate, groupDigits, integerInWords, lam, moneyPhrase, parseIsoDate } from './drafting-text';

describe('integerInWords', () => {
  const cases: Array<[number, string]> = [
    [0, 'صفر'],
    [1, 'واحد'],
    [11, 'أحد عشر'],
    [12, 'اثنا عشر'],
    [21, 'واحد وعشرون'],
    [100, 'مائة'],
    [250, 'مائتان وخمسون'],
    [1000, 'ألف'],
    [1500, 'ألف و خمسمائة'.replace('و ', 'و')],
    [2000, 'ألفان'],
    [3000, 'ثلاثة آلاف'],
    [11000, 'أحد عشر ألف'],
    [50000, 'خمسون ألف'],
    [200000, 'مائتا ألف'],
    [300000, 'ثلاثمائة ألف'],
    [1_000_000, 'مليون'],
    [2_500_000, 'مليونان و خمسمائة ألف'.replace('و ', 'و')],
  ];
  it.each(cases)('%d', (n, words) => expect(integerInWords(n)).toBe(words));

  it('حالة الجر بعد حرف الجر', () => {
    expect(integerInWords(30, true)).toBe('ثلاثين');
    expect(integerInWords(12, true)).toBe('اثنى عشر');
    expect(integerInWords(200, true)).toBe('مائتين');
    expect(integerInWords(60, true)).toBe('ستين');
  });

  it('يرفض غير الصحيح والسالب والضخم', () => {
    expect(() => integerInWords(1.5)).toThrow(RangeError);
    expect(() => integerInWords(-1)).toThrow(RangeError);
    expect(() => integerInWords(1e12)).toThrow(RangeError);
  });
});

describe('المبلغ بالجنيه', () => {
  it('صيغ الجنيه المختلفة', () => {
    expect(egpInWords(1)).toBe('جنيه مصرى واحد');
    expect(egpInWords(2)).toBe('جنيهان مصريان');
    expect(egpInWords(3)).toBe('ثلاثة جنيهات مصرية');
    expect(egpInWords(50)).toBe('خمسون جنيهاً مصرياً');
    expect(egpInWords(100)).toBe('مائة جنيه مصرى');
    expect(egpInWords(300000)).toBe('ثلاثمائة ألف جنيه مصرى');
  });
  it('القروش', () => {
    expect(egpInWords(10.5)).toBe('عشرة جنيهات مصرية وخمسون قرشاً');
    expect(egpInWords(0.25)).toBe('خمسة وعشرون قرشاً');
    expect(egpInWords(1.01)).toBe('جنيه مصرى واحد وقرش واحد');
  });
  it('العبارة الكاملة بالأرقام والحروف', () => {
    expect(moneyPhrase(50000)).toBe('50,000 جنيه مصرى (فقط خمسون ألف جنيه مصرى لا غير)');
    expect(moneyPhrase(1250.5)).toBe('1,250.50 جنيه مصرى (فقط ألف ومائتان وخمسون جنيهاً مصرياً وخمسون قرشاً لا غير)');
  });
  it('فواصل الآلاف', () => {
    expect(groupDigits(1234567)).toBe('1,234,567');
    expect(groupDigits(12.3)).toBe('12.30');
  });
});

describe('التواريخ', () => {
  it('تحقق التاريخ', () => {
    expect(parseIsoDate('2026-02-29')).toBeNull();
    expect(parseIsoDate('2028-02-29')).toEqual({ y: 2028, m: 2, d: 29 });
    expect(parseIsoDate('18/11/2026')).toBeNull();
  });
  it('اليوم والتاريخ', () => {
    expect(formatDate('2026-03-05')).toBe('05/03/2026');
    expect(dayAndDate('2026-11-18')).toBe('يوم الأربعاء الموافق 18/11/2026');
  });
  it('نهاية المدة شاملة', () => {
    expect(endOfTerm('2026-12-01', 6)).toBe('2027-05-31');
    expect(endOfTerm('2027-01-01', 12)).toBe('2027-12-31');
    expect(endOfTerm('2026-01-31', 1)).toBe('2026-02-27');
    expect(endOfTerm('2026-03-15', 24)).toBe('2028-03-14');
  });
});

describe('الصياغة اللغوية', () => {
  it('عدد مع وحدة (حالة الجر)', () => {
    expect(countPhrase(1, 'day')).toBe('يوم واحد');
    expect(countPhrase(2, 'month')).toBe('شهرين');
    expect(countPhrase(7, 'day')).toBe('7 (سبعة) أيام');
    expect(countPhrase(30, 'day')).toBe('30 (ثلاثين) يوماً');
    expect(countPhrase(12, 'month')).toBe('12 (اثنى عشر) شهراً');
    expect(countPhrase(3, 'year')).toBe('3 (ثلاثة) سنوات');
    expect(countPhrase(1, 'year')).toBe('سنة واحدة');
  });
  it('اللام الجارة', () => {
    expect(lam('العميل')).toBe('للعميل');
    expect(lam('المستأجر')).toBe('للمستأجر');
    expect(lam('مقدم الخدمة')).toBe('لمقدم الخدمة');
  });
});
