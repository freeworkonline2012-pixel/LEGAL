import { decryptField, encryptField, isEncryptedField } from './field-encryption';

describe('field-encryption (AES-256-GCM field-level encryption)', () => {
  it('يشفّر ويفكّ التشفير برحلة كاملة تُعيد النص الأصلى بالضبط', () => {
    const plaintext = 'هل يجوز عدم الإبلاغ عن عملية مشبوهة تخص نزاعاً أسرياً؟';
    const encrypted = encryptField(plaintext);
    expect(encrypted).not.toBeNull();
    expect(encrypted).not.toBe(plaintext);
    expect(decryptField(encrypted)).toBe(plaintext);
  });

  it('يُنتج قيماً مشفَّرة مختلفة لنفس النص فى كل مرة (IV عشوائى)', () => {
    const plaintext = 'نفس النص';
    const first = encryptField(plaintext);
    const second = encryptField(plaintext);
    expect(first).not.toBe(second);
    expect(decryptField(first)).toBe(plaintext);
    expect(decryptField(second)).toBe(plaintext);
  });

  it('يمرّر null/undefined كما هى دون تشفير', () => {
    expect(encryptField(null)).toBeNull();
    expect(encryptField(undefined)).toBeNull();
    expect(decryptField(null)).toBeNull();
    expect(decryptField(undefined)).toBeNull();
  });

  it('يعامل نصاً قديماً بلا بادئة enc:v1: كنص عادى (توافق رجعى انتقالى)', () => {
    const legacyPlaintext = 'سؤال قديم مُخزَّن قبل تفعيل التشفير';
    expect(decryptField(legacyPlaintext)).toBe(legacyPlaintext);
    expect(isEncryptedField(legacyPlaintext)).toBe(false);
  });

  it('isEncryptedField يميّز القيم المشفَّرة بدقة', () => {
    const encrypted = encryptField('نص');
    expect(isEncryptedField(encrypted)).toBe(true);
    expect(isEncryptedField('نص عادى')).toBe(false);
    expect(isEncryptedField(null)).toBe(false);
  });

  it('يرفض فك تشفير قيمة مشفَّرة تم التلاعب بها (فشل التحقق من authTag)', () => {
    const encrypted = encryptField('نص حساس')!;
    const tampered = encrypted.slice(0, -4) + '0000';
    expect(() => decryptField(tampered)).toThrow();
  });

  it('يرمى خطأً واضحاً لقيمة تحمل البادئة لكن بصيغة مقاطع ناقصة', () => {
    expect(() => decryptField('enc:v1:onlyonepart')).toThrow(/بصيغة تالفة/);
  });
});
