// scripts/run-migration.js
// يُشغَّل كـ preDeployCommand على Railway قبل كل نشر — يطبّق مخطط قاعدة
// البيانات (migrations/001_init.sql) عبر DATABASE_URL.
//
// حادثة حية (2026-08-21): عبارات CREATE TABLE/EXTENSION في الملف تستخدم
// IF NOT EXISTS فعلاً، لكن عبارات CREATE TRIGGER لا تدعم IF NOT EXISTS —
// فأول نشر نجح ونشأ المخطط كاملاً، وثاني نشر (بنفس الملف بلا تعديل) فشل بـ
// "trigger ... already exists" (Postgres code 42710) لأن التريجرز مش زي
// الجداول. الحل هنا: لا نعدّل ملف SQL الأصلي (مصدر الحقيقة لبقية الفريق)،
// بل نلتقط أخطاء "already exists" تحديداً (العائلة 42P06/42P07/42710/42723)
// ونعاملها كنجاح صامت (المخطط مطبَّق أصلاً) — أي خطأ آخر غير هذه الأكواد
// يظل يُفشل النشر فعلياً كما هو متوقع.
//
// لماذا سكربت Node بدل psql مباشرة؟ صورة node:20-alpine لا تحمل psql، لكن
// حزمة `pg` موجودة بالفعل ضمن اعتماديات المشروع — فنستخدمها بدل تثبيت أداة
// إضافية في صورة الإنتاج.

const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

// أكواد Postgres لـ "الكائن موجود مسبقاً/غير موجود من الأساس" — آمنة التجاهل
// هنا لأنها تعني فقط أن هذا الجزء من المخطط طُبِّق (أو أُزيل) في تشغيل سابق.
// 42704: undefined_object (مثال: DROP INDEX IF EXISTS على فهرس مُزال أصلاً —
// أُضيف مع 002_embeddings_dimension.sql، 2026-08-21).
const ALREADY_EXISTS_CODES = new Set(['42P06', '42P07', '42710', '42723', '42704']);

/**
 * يطبّق كل ملفات migrations/*.sql بالترتيب الأبجدي (001_ ثم 002_ ...) ضمن
 * اتصال واحد — وليس 001_init.sql فقط كما كان قبل EP-04 (2026-08-21). كل ملف
 * مستقل: فشل غير متوقع في ملف واحد يوقف التشغيل بالكامل (نفس السلوك السابق)،
 * بينما "الكائن موجود/غير موجود مسبقاً" يُسجَّل تحذيراً ويتابع للملف التالي.
 *
 * حادثة حية ثانية (2026-08-21، بعد أول نشر لهذا الملف): بروتوكول Postgres
 * البسيط (simple query protocol) ينفّذ كل العبارات المفصولة بـ ";" داخل
 * استدعاء client.query() واحد كمعاملة (transaction) ضمنية واحدة. حين تفشل
 * عبارة CREATE TRIGGER بخطأ "already exists" في 001_init.sql، تدخل الجلسة
 * كاملة في حالة "aborted transaction" — والتقاطنا للخطأ في JS واعتباره
 * تحذيراً غير حاسم لا يُصلح حالة الاتصال نفسها. فحين ننتقل لملف 002 على
 * *نفس* الاتصال، تفشل فوراً بخطأ Postgres 25P02
 * ("current transaction is aborted, commands ignored until end of
 * transaction block") — حتى لو كانت عبارات 002 نفسها صحيحة تماماً. الحل:
 * إصدار ROLLBACK صريح بعد أي خطأ نعتبره غير حاسم، لإعادة الاتصال لحالة
 * نظيفة قبل الانتقال للملف التالي.
 */
async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[migrate] DATABASE_URL غير مضبوط — تخطي التطبيق.');
    process.exit(1);
  }

  const migrationsDir = path.join(__dirname, '..', 'migrations');
  const files = fs
    .readdirSync(migrationsDir)
    .filter((name) => name.endsWith('.sql'))
    .sort();

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();
  try {
    for (const file of files) {
      const sql = fs.readFileSync(path.join(migrationsDir, file), 'utf8');
      console.log(`[migrate] تطبيق migrations/${file} ...`);
      try {
        await client.query(sql);
        console.log(`[migrate] ${file}: تم بنجاح.`);
      } catch (err) {
        if (err && ALREADY_EXISTS_CODES.has(err.code)) {
          console.warn(
            `[migrate] ${file}: تحذير غير حاسم: ${err.message} (مطبَّق/محذوف مسبقاً على الأرجح — متابعة).`,
          );
          // لازم نعيد الاتصال لحالة نظيفة قبل أي ملف تالٍ — وإلا يفشل
          // الملف التالي فوراً بـ 25P02 حتى لو كان صحيحاً تماماً (راجع
          // شرح الحادثة الثانية أعلى الملف).
          try {
            await client.query('ROLLBACK');
          } catch {
            // لا معاملة مفتوحة أصلاً — لا شيء نفعله، آمن التجاهل.
          }
        } else {
          throw err;
        }
      }
    }
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[migrate] فشل تطبيق المخطط:', err);
  process.exit(1);
});
