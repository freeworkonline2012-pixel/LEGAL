import { detectLanguage } from './language-detect';

const AR = 'يلتزم الطرف الثانى بسداد الأجر الشهرى المتفق عليه فى موعده المحدد بالعقد وفقاً لأحكام القانون.';
const EN = 'The Second Party shall pay the agreed monthly fee on its due date in accordance with the provisions of the Contract.';

describe('detectLanguage', () => {
  it('عربى سائد', () => {
    const d = detectLanguage(AR);
    expect(d.lang).toBe('ar');
    expect(d.bilingual).toBe(false);
    expect(d.dominantShare).toBeGreaterThan(0.95);
  });

  it('إنجليزى سائد', () => {
    expect(detectLanguage(EN).lang).toBe('en');
  });

  it('الأرقام وعلامات الترقيم لا تؤثر', () => {
    expect(detectLanguage(`${AR} 12000 - 2026/01/01 (٥٠٠٠)`).lang).toBe('ar');
  });

  it('أسماء لاتينية قليلة داخل عقد عربى: عربى مع تنبيه لا رفض', () => {
    const d = detectLanguage(`${AR} ${AR} شركة ABC Trading Co. LLC الطرف الأول`);
    expect(d.lang).toBe('ar');
    expect(d.bilingual).toBe(false);
  });

  it('عقد ثنائى اللغة (نصفان) يُكتشف', () => {
    const d = detectLanguage(`${AR} ${EN}`);
    expect(d.bilingual).toBe(true);
  });

  it('نص قصير جداً: لا لغة', () => {
    expect(detectLanguage('عقد').lang).toBeNull();
    expect(detectLanguage('12345 ---').lang).toBeNull();
  });
});
