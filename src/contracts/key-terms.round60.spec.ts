import { amountConflictWarnings } from './key-terms';
import { numericWarnings, strayPrefix } from './numeric-checks.util';

const STRAY = 'قيمة العقد 452500,000 جنيه مصرى ( خمسمائة الف جنيها مصريا لا غير ) تدفع سنويا.';
const REAL = 'قيمة العقد 450,000 جنيه مصرى ( خمسمائة الف جنيها مصريا لا غير ) تدفع سنويا.';

describe('الجولة 60: صياغة موحدة لتنبيه المبلغ المسبوق بأرقام زائدة', () => {
  it('strayPrefix يميز الأرقام الزائدة قبل المبلغ المكتوب بالحروف من التعارض الحقيقى', () => {
    expect(strayPrefix(452_500_000, 500_000)).toBe(true);
    expect(strayPrefix(450_000, 500_000)).toBe(false);
    expect(strayPrefix(5_000_000, 500_000)).toBe(false);
  });
  it('تنبيه الغلاف (numericWarnings) وتنبيه المبالغ المجزأة يستعملان الصياغة نفسها، فلا يتكرر التنبيه', () => {
    const numeric = numericWarnings(STRAY);
    expect(numeric).toHaveLength(1);
    expect(numeric[0]).toContain('يحوى المبلغ المكتوب بالحروف');
    expect(numeric[0]).toContain('أرقام زائدة');
    expect(amountConflictWarnings([STRAY], numeric)).toEqual([]);
  });
  it('تعارض حقيقى (بلا أرقام زائدة) يبقى بصياغته القديمة', () => {
    const numeric = numericWarnings(REAL);
    expect(numeric[0]).toContain('لا يطابق المكتوب بالحروف');
  });
});
