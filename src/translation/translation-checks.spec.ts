import { checkUnit, extractNumbers, lengthAnomaly, looksUntranslated, missingNumbers, normalizeDigits } from './translation-checks';

describe('الأرقام', () => {
  it('يوحّد الأرقام الهندية والفارسية ويحذف فواصل الآلاف', () => {
    expect(normalizeDigits('٢٠٢٦ و ۱۲')).toBe('2026 و 12');
    expect(extractNumbers('مبلغ ١٢,٥٠٠ جنيه و 3.5% بتاريخ 01/02/2026')).toEqual(['12500', '3.5', '1', '2', '2026']);
  });

  it('رقم مفقود أو متغيّر يُكتشف؛ الزيادة مقبولة', () => {
    expect(missingNumbers('أجر 12000 جنيه لمدة 6 أشهر', 'wage of 12000 for 6 months')).toEqual([]);
    expect(missingNumbers('أجر 12000 جنيه', 'wage of 21000 EGP')).toEqual(['12000']);
    expect(missingNumbers('خلال عشرة أيام', 'within ten (10) days')).toEqual([]);
  });
});

describe('الطول وبقاء لغة الأصل', () => {
  const src = 'يلتزم الطرف الثانى بسداد الأجر الشهرى المتفق عليه فى موعده المحدد بالعقد وفقاً لأحكام القانون';
  it('نسبة معقولة مقبولة وحذف كبير يُوسم', () => {
    expect(lengthAnomaly(src, 'The Second Party shall pay the agreed monthly wage on the date specified in the Contract in accordance with the law', 'ar', 'en')).toBe(false);
    expect(lengthAnomaly(src, 'The Second Party shall pay.', 'ar', 'en')).toBe(true);
  });
  it('النص القصير لا يُفحص طوله', () => {
    expect(lengthAnomaly('عقد عمل', 'x', 'ar', 'en')).toBe(false);
  });
  it('بقاء الأصل العربى فى ترجمة إنجليزية (الأسماء بين أقواس مستثناة)', () => {
    expect(looksUntranslated('The Contractor shall pay يلتزم المقاول بسداد المبلغ كاملاً فى موعده', 'en')).toBe(true);
    expect(looksUntranslated('The Contractor (شركة النور للمقاولات) shall pay the full amount on time', 'en')).toBe(false);
  });
});

describe('checkUnit', () => {
  it('ترجمة فارغة', () => {
    expect(checkUnit('نص', '  ', 'ar', 'en')).toEqual(['empty_translation']);
  });
  it('ترجمة سليمة بلا وسوم', () => {
    expect(
      checkUnit(
        'يتقاضى العامل أجراً شهرياً قدره 12000 جنيه مصرى يدفع فى نهاية كل شهر',
        'The Employee shall receive a monthly wage of 12000 Egyptian Pounds payable at the end of each month',
        'ar',
        'en',
      ),
    ).toEqual([]);
  });
});
