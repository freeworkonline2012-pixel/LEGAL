// scripts/encrypt_existing_question_text.js
//
// سكربت ترحيل لمرة واحدة (يُشغَّل يدوياً، لا يُدمَج فى scripts/run-migration.js
// التلقائى) — يُشفِّر أى صفوف questions.question لا تزال نصاً عادياً (سُجِّلت
// قبل تفعيل التشفير على مستوى التطبيق فى questions.service.ts). راجع
// المسار التقنى الأول لحل قانون حماية البيانات الشخصية 151/2020 (قرار
// 2026-09-12) وsrc/common/crypto/field-encryption.ts.
//
// idempotent وآمن لإعادة التشغيل: يتخطى أى صف مُشفَّر أصلاً (بادئة enc:v1:)
// عبر isEncryptedField() — لا خطر من تشغيله أكثر من مرة أو مقاطعته فى
// المنتصف (كل صف يُحدَّث فى معاملة مستقلة).
//
// ⚠️ شرط مسبق إلزامى: يجب تعيين ENCRYPTION_KEY فى بيئة التشغيل قبل تشغيل
// هذا السكربت لأول مرة على الإنتاج — إن شُغِّل بدونه سيستخدم المفتاح
// الافتراضى للتطوير (DEV_ONLY_ENCRYPTION_KEY) ويُشفِّر به، وهو مفتاح معروف
// علناً فى الكود المصدرى ولا يوفر أى حماية فعلية. السكربت يرفض العمل على
// NODE_ENV=production بمفتاح التطوير صراحة (نفس حارس env.validation.ts).
//
// طريقة الاستخدام:
//   DATABASE_URL=postgres://... ENCRYPTION_KEY=<64 حرف hex> \
//     node scripts/encrypt_existing_question_text.js [--dry-run]

const { Client } = require('pg');
const { encryptField, isEncryptedField, DEV_ONLY_ENCRYPTION_KEY } = require('./lib/field-encryption');

const DRY_RUN = process.argv.includes('--dry-run');
const BATCH_SIZE = 500;

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[encrypt-backfill] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const encryptionKey = (process.env.ENCRYPTION_KEY || '').trim();
  if (process.env.NODE_ENV === 'production' && (!encryptionKey || encryptionKey === DEV_ONLY_ENCRYPTION_KEY)) {
    console.error(
      '[encrypt-backfill] رُفض التشغيل: ENCRYPTION_KEY غير مضبوط أو يساوي مفتاح التطوير الافتراضي ' +
        'فى NODE_ENV=production. عيّن مفتاحاً حقيقياً أولاً (openssl rand -hex 32).',
    );
    process.exit(1);
  }
  if (!encryptionKey) {
    console.warn(
      '[encrypt-backfill] ⚠️ ENCRYPTION_KEY غير مضبوط — سيُستخدَم مفتاح التطوير الافتراضى ' +
        '(غير آمن، مقبول فقط فى بيئة تطوير محلية).',
    );
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  let totalScanned = 0;
  let totalEncrypted = 0;
  let lastId = '00000000-0000-0000-0000-000000000000';

  try {
    for (;;) {
      const { rows } = await client.query(
        `SELECT id, question FROM questions WHERE id > $1 ORDER BY id ASC LIMIT $2`,
        [lastId, BATCH_SIZE],
      );
      if (rows.length === 0) break;

      for (const row of rows) {
        totalScanned += 1;
        lastId = row.id;
        if (isEncryptedField(row.question)) {
          continue; // مُشفَّر أصلاً — idempotent
        }
        const ciphertext = encryptField(row.question);
        if (DRY_RUN) {
          totalEncrypted += 1;
          continue;
        }
        await client.query(`UPDATE questions SET question = $1 WHERE id = $2`, [ciphertext, row.id]);
        totalEncrypted += 1;
      }

      console.log(`[encrypt-backfill] ... ${totalScanned} صفاً مفحوصاً حتى الآن (${totalEncrypted} مُشفَّر/سيُشفَّر)`);
    }
  } finally {
    await client.end();
  }

  console.log(
    `[encrypt-backfill] اكتمل${DRY_RUN ? ' (--dry-run، لم يُكتَب شىء فعلياً)' : ''}: ` +
      `${totalScanned} صفاً مفحوصاً، ${totalEncrypted} صفاً ${DRY_RUN ? 'سيُشفَّر' : 'شُفِّر'}.`,
  );
}

main().catch((err) => {
  console.error('[encrypt-backfill] فشل:', err);
  process.exit(1);
});
