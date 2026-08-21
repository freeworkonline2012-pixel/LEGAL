// scripts/run-migration.js
// يُشغَّل كـ preDeployCommand على Railway قبل كل نشر — يطبّق مخطط قاعدة
// البيانات (migrations/001_init.sql) عبر DATABASE_URL. آمن للتكرار: كل
// عبارات CREATE TABLE/EXTENSION في الملف تستخدم IF NOT EXISTS (راجع
// migrations/README.md) — فتشغيله في كل نشر لا يفشل ولا يكرر شيئاً.
//
// لماذا سكربت Node بدل psql مباشرة؟ صورة node:20-alpine لا تحمل psql، لكن
// حزمة `pg` موجودة بالفعل ضمن اعتماديات المشروع — فنستخدمها بدل تثبيت أداة
// إضافية في صورة الإنتاج.

const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

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
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[migrate] فشل تطبيق المخطط:', err);
  process.exit(1);
});
