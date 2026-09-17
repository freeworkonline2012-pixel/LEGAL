// scripts/verify_law_205_2021_ingest.js
//
// سكربت تحقّق مباشر (قراءة فقط، بلا أى تعديل) لتأكيد أن
// migrations/052_replace_corrupted_law_205_2021_with_clean_text_and_enable_governance_scope.sql
// نُفِّذ فعلياً وبشكل صحيح على قاعدة بيانات الإنتاج الحية — وليس فقط أن
// "[migrate] ... تم بنجاح." ظهرت فى سجلّات النشر. تلك الرسالة تعنى فقط أن
// ملف SQL نُفِّذ بلا استثناء غير مُلتقَط؛ رسائل RAISE NOTICE/RAISE WARNING
// داخل كتل DO فى الهجرة نفسها لا تصل لسجلّات Railway لأن run-migration.js
// يستخدم pg.Client().query() المباشر بلا مستمع لحدث 'notice' — فتُفقَد
// صامتة. هذا السكربت يستعلم القيم الفعلية مباشرة بدل الاعتماد على النية.
//
// الاستخدام:
//   railway ssh -s backend -- node scripts/verify_law_205_2021_ingest.js

const { Client } = require('pg');

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[verify-205] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  try {
    const lawRes = await client.query(
      `SELECT id, governance_scope, enacted_at, kind FROM laws WHERE law_no = 205 AND law_year = 2021`,
    );
    if (lawRes.rowCount === 0) {
      console.log('❌ [verify-205] law 205/2021 غير موجود فى جدول laws إطلاقاً — غير متوقَّع.');
      process.exit(1);
    }
    const law = lawRes.rows[0];
    console.log(
      `law 205/2021: governance_scope=${law.governance_scope}, enacted_at=${law.enacted_at}, kind=${law.kind}`,
    );

    const artRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id WHERE l.law_no = 205 AND l.law_year = 2021`,
    );
    console.log(`article count: ${artRes.rows[0].n} (متوقَّع: 15)`);

    const verRes = await client.query(
      `SELECT count(*)::int AS n FROM article_versions av
       JOIN articles a ON a.id = av.article_id
       JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 205 AND l.law_year = 2021 AND av.status = 'active'`,
    );
    console.log(`article_versions (active) count: ${verRes.rows[0].n} (متوقَّع: 15)`);

    const scopeRes = await client.query(`SELECT count(*)::int AS n FROM laws WHERE governance_scope = true`);
    console.log(`total governance_scope=true: ${scopeRes.rows[0].n} (متوقَّع: 46)`);

    const art15Res = await client.query(
      `SELECT a.title, length(a.body) AS body_len FROM articles a
       JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 205 AND l.law_year = 2021 AND a.article_no = 6`,
    );
    if (art15Res.rowCount > 0) {
      console.log(
        `spot-check المادة 6: title="${art15Res.rows[0].title}", body_len=${art15Res.rows[0].body_len} (متوقَّع ≈1589)`,
      );
    }

    const ok =
      law.governance_scope === true &&
      String(law.enacted_at).startsWith('2021-12-21') &&
      artRes.rows[0].n === 15 &&
      verRes.rows[0].n === 15 &&
      scopeRes.rows[0].n === 46;

    console.log(ok ? '\n✅ [verify-205] كل القيم مطابقة تماماً للمتوقَّع.' : '\n⚠️ [verify-205] تعارض واحد أو أكثر — راجع القيم أعلاه.');
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[verify-205] فشل غير متوقَّع:', err);
  process.exit(1);
});
