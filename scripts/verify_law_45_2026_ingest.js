// scripts/verify_law_45_2026_ingest.js
//
// سكربت تحقّق مباشر (قراءة فقط، بلا أى تعديل) لتأكيد أن
// migrations/055_seed_law_45_2026_key_functions_non_bank_finance_licensing.sql
// نُفِّذ فعلياً وبشكل صحيح على قاعدة بيانات الإنتاج الحية — وليس فقط أن
// "[migrate] ... تم بنجاح." ظهرت فى سجلّات النشر. تلك الرسالة تعنى فقط أن
// ملف SQL نُفِّذ بلا استثناء غير مُلتقَط؛ رسائل RAISE NOTICE/RAISE WARNING
// داخل كتل DO فى الهجرة نفسها لا تصل لسجلّات Railway لأن run-migration.js
// يستخدم pg.Client().query() المباشر بلا مستمع لحدث 'notice' — فتُفقَد
// صامتة (تحقَّق من هذا محلياً أثناء بناء هذه الهجرة: 3 تشغيلات متتالية
// للسلسلة الكاملة لم تُظهر أى سطر [055] فى السجلّات رغم نجاح كل شىء فعلياً
// — لذا هذا السكربت يستعلم القيم الفعلية مباشرة بدل الاعتماد على السجلّات).
//
// الاستخدام:
//   railway ssh -s backend -- node scripts/verify_law_45_2026_ingest.js

const { Client } = require('pg');

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[verify-45] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  try {
    const lawRes = await client.query(
      `SELECT id, governance_scope, enacted_at, kind, category, status FROM laws WHERE law_no = 45 AND law_year = 2026`,
    );
    if (lawRes.rowCount === 0) {
      console.log('❌ [verify-45] law 45/2026 غير موجود فى جدول laws إطلاقاً — غير متوقَّع.');
      process.exit(1);
    }
    const law = lawRes.rows[0];
    console.log(
      `law 45/2026: governance_scope=${law.governance_scope}, enacted_at=${law.enacted_at}, kind=${law.kind}, category=${law.category}, status=${law.status}`,
    );

    const artRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id WHERE l.law_no = 45 AND l.law_year = 2026`,
    );
    console.log(`article count: ${artRes.rows[0].n} (متوقَّع: 29 بالضبط — 14 مادة + ملحق1 + 14 فرعاً بملحق2)`);

    const verRes = await client.query(
      `SELECT av.status, count(*)::int AS n FROM article_versions av
       JOIN articles a ON a.id = av.article_id
       JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 45 AND l.law_year = 2026
       GROUP BY av.status ORDER BY av.status`,
    );
    let activeCount = 0;
    for (const row of verRes.rows) {
      console.log(`article_versions[${row.status}]: ${row.n}`);
      if (row.status === 'active') activeCount = row.n;
    }
    console.log(`(متوقَّع: active=29، بلا أى صف ملغى — القرار كله سارٍ)`);

    const missingVersionRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a
       JOIN laws l ON l.id = a.law_id
       LEFT JOIN article_versions av ON av.article_id = a.id
       WHERE l.law_no = 45 AND l.law_year = 2026 AND av.id IS NULL`,
    );
    console.log(`articles بلا أى article_versions: ${missingVersionRes.rows[0].n} (متوقَّع: 0)`);

    const emptyBodyRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 45 AND l.law_year = 2026 AND (a.body IS NULL OR length(trim(a.body)) = 0)`,
    );
    console.log(`articles بمتن فارغ: ${emptyBodyRes.rows[0].n} (متوقَّع: 0)`);

    const scopeRes = await client.query(`SELECT count(*)::int AS n FROM laws WHERE governance_scope = true`);
    console.log(`total governance_scope=true: ${scopeRes.rows[0].n} (متوقَّع: 49)`);

    // spot-check: المادة الأولى (نطاق التطبيق)
    const spot1 = await client.query(
      `SELECT a.title, length(a.body) AS body_len FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 45 AND l.law_year = 2026 AND a.article_no = 1 AND a.article_suffix_order = 0`,
    );
    if (spot1.rowCount > 0) {
      console.log(`spot-check المادة 1 (نطاق التطبيق): title="${spot1.rows[0].title}", body_len=${spot1.rows[0].body_len}`);
    }

    // spot-check: ملحق (1) — article_no=15
    const spot15 = await client.query(
      `SELECT a.title, length(a.body) AS body_len FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 45 AND l.law_year = 2026 AND a.article_no = 15 AND a.article_suffix_order = 0`,
    );
    if (spot15.rowCount > 0) {
      console.log(`spot-check ملحق (1): title="${spot15.rows[0].title}", body_len=${spot15.rows[0].body_len}`);
    }

    // spot-check: ملحق (2) — رابع عشر (آخر فرع، article_no=16 suffix=14)
    const spot16_14 = await client.query(
      `SELECT a.title, a.hierarchical_location, length(a.body) AS body_len FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 45 AND l.law_year = 2026 AND a.article_no = 16 AND a.article_suffix_order = 14`,
    );
    if (spot16_14.rowCount > 0) {
      console.log(
        `spot-check ملحق (2) فرع 14 (الأخير): title="${spot16_14.rows[0].title}", hierarchical_location="${spot16_14.rows[0].hierarchical_location}", body_len=${spot16_14.rows[0].body_len}`,
      );
    }

    // فحص عدد فروع ملحق (2) تحديداً (article_no=16) — يجب أن يكون 14 بالضبط
    const annex2Count = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 45 AND l.law_year = 2026 AND a.article_no = 16`,
    );
    console.log(`عدد فروع ملحق (2) (article_no=16): ${annex2Count.rows[0].n} (متوقَّع: 14 بالضبط)`);

    const enactedAtIso =
      law.enacted_at instanceof Date ? law.enacted_at.toISOString().slice(0, 10) : String(law.enacted_at);

    const ok =
      law.governance_scope === true &&
      enactedAtIso === '2026-02-09' &&
      law.category === 'non_bank_finance' &&
      artRes.rows[0].n === 29 &&
      activeCount === 29 &&
      missingVersionRes.rows[0].n === 0 &&
      emptyBodyRes.rows[0].n === 0 &&
      scopeRes.rows[0].n === 49 &&
      annex2Count.rows[0].n === 14;

    console.log(
      ok
        ? '\n✅ [verify-45] كل القيم مطابقة تماماً للمتوقَّع.'
        : '\n⚠️ [verify-45] تعارض واحد أو أكثر — راجع القيم أعلاه.',
    );
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[verify-45] فشل غير متوقَّع:', err);
  process.exit(1);
});
