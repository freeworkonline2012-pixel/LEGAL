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

// أكواد Postgres لـ "الكائن موجود مسبقاً" — آمنة التجاهل هنا لأنها تعني
// فقط أن هذا الجزء من المخطط طُبِّق في تشغيل سابق.
const ALREADY_EXISTS_CODES = new Set(['42P06', '42P07', '42710', '42723']);

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[migrate] DATABASE_URL غير مضبوط — تخطي التطبيق.');
    process.exit(1);
  }

  const sqlPath = path.join(__dirname, '..', 'migrations', '001_init.sql');
  const sql = fs.readFileSync(sqlPath, 'utf8');

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();
  try {
    console.log('[migrate] تطبيق migrations/001_init.sql ...');
    await client.query(sql);
    console.log('[migrate] تم بنجاح.');
  } catch (err) {
    if (err && ALREADY_EXISTS_CODES.has(err.code)) {
      console.warn(
        `[migrate] تحذير غير حاسم: ${err.message} (المخطط مطبَّق مسبقاً على الأرجح — متابعة).`,
      );
    } else {
      throw err;
    }
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[migrate] فشل تطبيق المخطط:', err);
  process.exit(1);
});
