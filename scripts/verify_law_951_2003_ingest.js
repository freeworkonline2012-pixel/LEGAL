// scripts/verify_law_951_2003_ingest.js
//
// سكربت تحقّق مباشر (قراءة فقط، بلا أى تعديل) لتأكيد أن
// migrations/053_replace_corrupted_law_951_2003_with_clean_text_and_enable_governance_scope.sql
// نُفِّذ فعلياً وبشكل صحيح على قاعدة بيانات الإنتاج الحية — وليس فقط أن
// "[migrate] ... تم بنجاح." ظهرت فى سجلّات النشر. تلك الرسالة تعنى فقط أن
// ملف SQL نُفِّذ بلا استثناء غير مُلتقَط؛ رسائل RAISE NOTICE/RAISE WARNING
// داخل كتل DO فى الهجرة نفسها لا تصل لسجلّات Railway لأن run-migration.js
// يستخدم pg.Client().query() المباشر بلا مستمع لحدث 'notice' — فتُفقَد
// صامتة. هذا السكربت يستعلم القيم الفعلية مباشرة بدل الاعتماد على النية.
//
// الاستخدام:
//   railway ssh -s backend -- node scripts/verify_law_951_2003_ingest.js

const { Client } = require('pg');

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[verify-951] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  try {
    const lawRes = await client.query(
      `SELECT id, governance_scope, enacted_at, kind FROM laws WHERE law_no = 951 AND law_year = 2003`,
    );
    if (lawRes.rowCount === 0) {
      console.log('❌ [verify-951] law 951/2003 غير موجود فى جدول laws إطلاقاً — غير متوقَّع.');
      process.exit(1);
    }
    const law = lawRes.rows[0];
    console.log(
      `law 951/2003: governance_scope=${law.governance_scope}, enacted_at=${law.enacted_at}, kind=${law.kind}`,
    );

    const artRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id WHERE l.law_no = 951 AND l.law_year = 2003`,
    );
    console.log(`article count: ${artRes.rows[0].n} (متوقَّع: 100)`);

    const verRes = await client.query(
      `SELECT av.status, count(*)::int AS n FROM article_versions av
       JOIN articles a ON a.id = av.article_id
       JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 951 AND l.law_year = 2003
       GROUP BY av.status ORDER BY av.status`,
    );
    let activeCount = 0;
    let repealedCount = 0;
    for (const row of verRes.rows) {
      console.log(`article_versions[${row.status}]: ${row.n}`);
      if (row.status === 'active') activeCount = row.n;
      if (row.status === 'repealed') repealedCount = row.n;
    }
    console.log(`(متوقَّع: active=99, repealed=1, إجمالى=100)`);

    const missingVersionRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a
       JOIN laws l ON l.id = a.law_id
       LEFT JOIN article_versions av ON av.article_id = a.id
       WHERE l.law_no = 951 AND l.law_year = 2003 AND av.id IS NULL`,
    );
    console.log(`articles بلا أى article_versions: ${missingVersionRes.rows[0].n} (متوقَّع: 0)`);

    const emptyBodyRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 951 AND l.law_year = 2003 AND (a.body IS NULL OR length(trim(a.body)) = 0)`,
    );
    console.log(`articles بمتن فارغ: ${emptyBodyRes.rows[0].n} (متوقَّع: 0)`);

    const scopeRes = await client.query(`SELECT count(*)::int AS n FROM laws WHERE governance_scope = true`);
    console.log(`total governance_scope=true: ${scopeRes.rows[0].n} (متوقَّع: 47)`);

    const spot1 = await client.query(
      `SELECT a.title, length(a.body) AS body_len FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 951 AND l.law_year = 2003 AND a.article_no = 1 AND a.article_suffix_order = 0`,
    );
    if (spot1.rowCount > 0) {
      console.log(`spot-check المادة 1 (التعريفات): title="${spot1.rows[0].title}", body_len=${spot1.rows[0].body_len}`);
    }

    const spot56 = await client.query(
      `SELECT length(body) AS body_len FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 951 AND l.law_year = 2003 AND a.article_no = 56`,
    );
    if (spot56.rowCount > 0) {
      console.log(`spot-check المادة 56 (الأخيرة): body_len=${spot56.rows[0].body_len}`);
    }

    const spot7bis = await client.query(
      `SELECT av.status, av.body FROM articles a
       JOIN laws l ON l.id = a.law_id
       JOIN article_versions av ON av.article_id = a.id
       WHERE l.law_no = 951 AND l.law_year = 2003 AND a.article_no = 7 AND a.article_suffix_order = 1`,
    );
    if (spot7bis.rowCount > 0) {
      console.log(`spot-check المادة 7 مكرر (ملغاة): status=${spot7bis.rows[0].status}`);
    }

    const ok =
      law.governance_scope === true &&
      artRes.rows[0].n === 100 &&
      activeCount === 99 &&
      repealedCount === 1 &&
      missingVersionRes.rows[0].n === 0 &&
      emptyBodyRes.rows[0].n === 0 &&
      scopeRes.rows[0].n === 47;

    console.log(ok ? '\n✅ [verify-951] كل القيم مطابقة تماماً للمتوقَّع.' : '\n⚠️ [verify-951] تعارض واحد أو أكثر — راجع القيم أعلاه.');
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[verify-951] فشل غير متوقَّع:', err);
  process.exit(1);
});
