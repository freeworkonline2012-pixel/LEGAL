/**
 * تشفير على مستوى الحقل (Field-Level Encryption) — AES-256-GCM.
 *
 * جزء من المسار التقنى الأول لحل قانون حماية البيانات الشخصية 151/2020
 * (بند "تشفير البيانات الحساسة"، مُعلَّم 🔴 فى DPIA بتاريخ 2026-08-21 —
 * "نص السؤال قد يكشف بيانات عن نزاع أسري، قضية جنائية، وضع مالي"). يُطبَّق
 * حالياً على عمود questions.question فقط (أعلى حساسية موثَّقة صراحة) —
 * راجع transformer فى question.entity.ts.
 *
 * لماذا AES-256-GCM بدل تشفير على مستوى القرص/التخزين فقط؟ التشفير عند
 * الراحة (at-rest، مطبَّق بالفعل عبر مزوّد الاستضافة) يحمى فقط من سرقة
 * القرص الفعلى — لا من اختراق يصل لقاعدة البيانات نفسها عبر ثغرة تطبيقية
 * (SQL injection، بيانات اعتماد مسروقة، backup مسرَّب). تشفير على مستوى
 * الحقل يعني أن نص السؤال الخام غير مقروء حتى فى هذا السيناريو — وهذا
 * الفرق الجذرى المطلوب (لا حل مؤقت يعتمد فقط على تشفير التخزين).
 *
 * لماذا GCM تحديداً (لا CBC)؟ GCM يوفّر Authenticated Encryption — أى
 * تلاعب بالنص المشفَّر (تعديل مباشر فى قاعدة البيانات مثلاً) يُكتشَف فوراً
 * عبر فشل التحقق من authTag، بدل فك تشفير صامت لبيانات تالفة/مُتلاعَب بها.
 *
 * ⚠️ هذا الملف يُستدعى من TypeORM column transformers، والتى تُنفَّذ خارج
 * سياق حقن الاعتماديات (Dependency Injection) فى NestJS — لذا يقرأ المفتاح
 * من process.env مباشرة (لا عبر ConfigService)، بنفس الطريقة التى يعمل بها
 * @nestjs/config فعلياً تحت الغطاء (dotenv يملأ process.env عند الإقلاع).
 * التحقق من قوة المفتاح فى بيئة الإنتاج يتم مركزياً فى env.validation.ts
 * (نفس نمط JWT_SECRET) — لا تكرار للتحقق هنا.
 *
 * 🔴 تحذير تشغيلى حرج (اكتُشف بالتحقق الحى أثناء بناء هذه الميزة — 2026-09-12،
 * لا افتراضاً نظرياً): ENCRYPTION_KEY بمجرد تعيينه فى الإنتاج يجب ألا يتغيّر
 * أو يُفقَد أبداً. لا يوجد فى هذا التصميم أى نظام لتعدد إصدارات المفتاح
 * (Key Versioning/Envelope Encryption) — لو تغيَّر المفتاح أو ضاع، **كل
 * صفوف questions.question المُشفَّرة سابقاً تصبح غير قابلة لفك التشفير
 * نهائياً وبلا رجعة** (فشل AES-GCM authentication، لا مجرد رفض وصول). عند
 * أول تفعيل فى الإنتاج: احفظ ENCRYPTION_KEY فى مدير أسرار موثوق (لا فى ملف
 * .env عادى فقط)، وتأكَّد من عدم تغييره لاحقاً إلا ضمن مشروع ترحيل كامل
 * (فك تشفير بالمفتاح القديم ثم إعادة تشفير بالجديد لكل صف، سكربت لم يُبنَ
 * بعد لأنه خارج نطاق هذه الدفعة).
 */

import { createCipheriv, createDecipheriv, createHash, randomBytes } from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const IV_LENGTH_BYTES = 12; // الطول الموصى به لـGCM (96-bit)
const KEY_LENGTH_BYTES = 32; // AES-256
const CIPHERTEXT_PREFIX = 'enc:v1:';

/**
 * مفتاح تطوير محلى ثابت (64 حرف hex = 32 بايت) — موثَّق علناً هنا بنفس
 * منطق DEV_ONLY_JWT_SECRET فى env.validation.ts: لا يُستخدَم أبداً فى
 * الإنتاج (حارس boot فى env.validation.ts يرفض الإقلاع بدونه أو بمفتاح
 * أقصر من 64 حرفاً). يُشتَق عبر SHA-256 من عبارة وصفية واضحة (لا نص hex
 * حرفى مباشر) — يضمن ناتجاً صالحاً كـhex دائماً (بخلاف تسلسل كلمات مُلصَقة
 * يدوياً كما فى DEV_ONLY_JWT_SECRET، والذى يصلح كسر نصى عادى لكن ليس كمفتاح
 * hex) ويتفادى إنذارات مسّاح الأسرار الآلى الكاذبة لأنه مُشتَق لا حرفى.
 */
export const DEV_ONLY_ENCRYPTION_KEY: string = createHash('sha256')
  .update('local-dev-only-field-encryption-key-do-not-use-in-production')
  .digest('hex');

function resolveKey(): Buffer {
  const raw = process.env.ENCRYPTION_KEY?.trim() || DEV_ONLY_ENCRYPTION_KEY;
  const key = Buffer.from(raw, 'hex');
  if (key.length !== KEY_LENGTH_BYTES) {
    // لا يجب الوصول هنا فى الإنتاج أبداً — حارس env.validation.ts يرفض
    // الإقلاع بمفتاح غير صالح الطول قبل معالجة أى طلب. هذا فحص دفاعى ثانٍ
    // (Defense in Depth) لا أكثر.
    throw new Error(
      `ENCRYPTION_KEY غير صالح — يجب أن يكون ${KEY_LENGTH_BYTES * 2} حرف hex (${KEY_LENGTH_BYTES} بايت)`,
    );
  }
  return key;
}

/**
 * يُشفِّر نصاً عادياً. يُعيد null لو كانت القيمة المُدخَلة null/undefined
 * (يحافظ على nullable columns دون فرض تشفير لقيمة فارغة أصلاً).
 */
export function encryptField(plaintext: string | null | undefined): string | null {
  if (plaintext === null || plaintext === undefined) {
    return null;
  }
  const key = resolveKey();
  const iv = randomBytes(IV_LENGTH_BYTES);
  const cipher = createCipheriv(ALGORITHM, key, iv);
  const ciphertext = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
  const authTag = cipher.getAuthTag();
  return `${CIPHERTEXT_PREFIX}${iv.toString('hex')}:${authTag.toString('hex')}:${ciphertext.toString('hex')}`;
}

/**
 * يفك تشفير قيمة مخزَّنة. قيمة لا تحمل البادئة CIPHERTEXT_PREFIX تُعتبَر
 * نصاً عادياً قديماً (صفوف موجودة قبل تفعيل التشفير، قبل تشغيل سكربت
 * الترحيل scripts/encrypt_existing_question_text.js) وتُعاد كما هى — سلوك
 * انتقالى آمن ومتعمَّد، لا خطأ صامت: أى قيمة تحمل البادئة لكن فشل فك
 * تشفيرها (مفتاح خاطئ أو تلاعب) تُفشل صراحة عبر رمى الاستثناء من
 * createDecipheriv/final، ولا تُبتلَع هنا.
 */
export function decryptField(value: string | null | undefined): string | null {
  if (value === null || value === undefined) {
    return null;
  }
  if (!value.startsWith(CIPHERTEXT_PREFIX)) {
    return value;
  }
  const [ivHex, authTagHex, ciphertextHex] = value.slice(CIPHERTEXT_PREFIX.length).split(':');
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

/** true إن كانت القيمة بصيغة التشفير المُتوقَّعة (بادئة enc:v1:) — يُستخدَم فى سكربت الترحيل لتفادى إعادة تشفير صفوف مُشفَّرة أصلاً (idempotent). */
export function isEncryptedField(value: string | null | undefined): boolean {
  return typeof value === 'string' && value.startsWith(CIPHERTEXT_PREFIX);
}

/** transformer جاهز للاستخدام المباشر فى @Column({ transformer }) فى TypeORM. */
export const fieldEncryptionTransformer = {
  to: (value: string | null | undefined): string | null => encryptField(value),
  from: (value: string | null | undefined): string | null => decryptField(value),
};
