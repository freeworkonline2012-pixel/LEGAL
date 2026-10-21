import { findOcrNoiseTokens, neutralizeOcrNoise, OCR_NOISE_PLACEHOLDER } from './ocr-noise.util';

describe('ocr-noise.util', () => {
  it('يكشف الحروف اللاتينية القصيرة بين كلمات عربية فقط', () => {
    expect(findOcrNoiseTokens('فى حالة إخلال الطرف الأول WL من إلتزاماته')).toEqual(['WL']);
    expect(findOcrNoiseTokens('ترت S S (W م الأمر')).toEqual(['S', 'W']);
  });

  it('لا يعتبر نصاً لاتينياً كاملاً أو كلمة أطول من 3 أحرف رمزاً مشوَّهاً', () => {
    expect(findOcrNoiseTokens('Module Timeframe Price in EGP')).toEqual([]);
    expect(findOcrNoiseTokens('الكود المصدرى Source Code للبرامج')).toEqual([]);
  });

  it('يستبدل فى الصياغة المقترحة الرمز المشوَّه الموجود فى الأصل بفراغ ظاهر', () => {
    const original = 'إخلال الطرف الأول WL من إلتزاماته';
    const proposed = 'عند إخلال الطرف الأول WL من إلتزاماته يعذره الطرف الثانى';
    const r = neutralizeOcrNoise(proposed, original);
    expect(r.text).toBe(`عند إخلال الطرف الأول ${OCR_NOISE_PLACEHOLDER} من إلتزاماته يعذره الطرف الثانى`);
    expect(r.replaced).toEqual(['WL']);
  });

  it('لا يمس رمزاً لم يرد فى الأصل ولا يغيّر نصاً سليماً', () => {
    const r = neutralizeOcrNoise('يرسل الطرف الأول SMS للعميل', 'نص أصلى سليم بلا رموز');
    expect(r.text).toBe('يرسل الطرف الأول SMS للعميل');
    expect(r.replaced).toEqual([]);
  });
});
