import { riskLevelFor } from './risk-level.util';

describe('riskLevelFor', () => {
  it('حرج فقط عند ثبوت مخالفة نص آمر بعبارة حرفية موثَّقة', () => {
    expect(riskLevelFor('يحتاج مراجعة', 'mandatory_violation', true)).toBe('حرج');
  });
  it('ادّعاء مخالفة آمرة لم تثبت يُخفَّض إلى عالٍ لا حرج', () => {
    expect(riskLevelFor('يحتاج مراجعة', 'mandatory_violation', false)).toBe('عالٍ');
  });
  it('اختلاف عن قاعدة مكملة عالٍ، وبلا اختلاف محدد متوسط', () => {
    expect(riskLevelFor('يحتاج مراجعة', 'supplementary_difference', false)).toBe('عالٍ');
    expect(riskLevelFor('يحتاج مراجعة', 'none', false)).toBe('متوسط');
  });
  it('لا درجة لبند سليم أو بلا نص مفهرس مهما قال النموذج', () => {
    expect(riskLevelFor('سليم', 'mandatory_violation', true)).toBeNull();
    expect(riskLevelFor('لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة', 'none', false)).toBeNull();
    expect(riskLevelFor(null, 'none', false)).toBeNull();
  });
});
