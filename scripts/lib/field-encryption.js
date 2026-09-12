// scripts/lib/field-encryption.js
//
// نسخة CommonJS مطابقة تماماً لـ src/common/crypto/field-encryption.ts —
// لسكربتات pg الخام (scripts/*.js) التى تُشغَّل خارج بناء Nest/TypeScript
// (نفس السبب الذى يجعل scripts/run-migration.js يستخدم pg مباشرة بدل
// TypeORM). ⚠️ أى تعديل على منطق التشفير فى الملف الأصلى (خوارزمية، صيغة
// البادئة، طول IV) يجب أن يُعاد هنا يدوياً بالتطابق الكامل — لا يوجد بناء
// مشترك بين src/ وscripts/ فى هذا المشروع حالياً يمنع هذا التكرار جذرياً.

const { createCipheriv, createDecipheriv, createHash, randomBytes } = require('crypto');

const ALGORITHM = 'aes-256-gcm';
const IV_LENGTH_BYTES = 12;
const KEY_LENGTH_BYTES = 32;
const CIPHERTEXT_PREFIX = 'enc:v1:';

const DEV_ONLY_ENCRYPTION_KEY = createHash('sha256')
  .update('local-dev-only-field-encryption-key-do-not-use-in-production')
  .digest('hex');

function resolveKey() {
  const raw = (process.env.ENCRYPTION_KEY || '').trim() || DEV_ONLY_ENCRYPTION_KEY;
  const key = Buffer.from(raw, 'hex');
  if (key.length !== KEY_LENGTH_BYTES) {
    throw new Error(
      `ENCRYPTION_KEY غير صالح — يجب أن يكون ${KEY_LENGTH_BYTES * 2} حرف hex (${KEY_LENGTH_BYTES} بايت)`,
    );
  }
  return key;
}

function encryptField(plaintext) {
  if (plaintext === null || plaintext === undefined) return null;
  const key = resolveKey();
  const iv = randomBytes(IV_LENGTH_BYTES);
  const cipher = createCipheriv(ALGORITHM, key, iv);
  const ciphertext = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
  const authTag = cipher.getAuthTag();
  return `${CIPHERTEXT_PREFIX}${iv.toString('hex')}:${authTag.toString('hex')}:${ciphertext.toString('hex')}`;
}

function decryptField(value) {
  if (value === null || value === undefined) return null;
  if (!value.startsWith(CIPHERTEXT_PREFIX)) return value;
  const parts = value.slice(CIPHERTEXT_PREFIX.length).split(':');
  const [ivHex, authTagHex, ciphertextHex] = parts;
  if (!ivHex || !authTagHex || !ciphertextHex) {
    throw new Error('قيمة مشفَّرة بصيغة تالفة (مقاطع ناقصة)');
  }
  const key = resolveKey();
  const decipher = createDecipheriv(ALGORITHM, key, Buffer.from(ivHex, 'hex'));
  decipher.setAuthTag(Buffer.from(authTagHex, 'hex'));
  const plaintext = Buffer.concat([
    decipher.update(Buffer.from(ciphertextHex, 'hex')),
    decipher.final(),
  ]);
  return plaintext.toString('utf8');
}

function isEncryptedField(value) {
  return typeof value === 'string' && value.startsWith(CIPHERTEXT_PREFIX);
}

module.exports = { encryptField, decryptField, isEncryptedField, DEV_ONLY_ENCRYPTION_KEY };
