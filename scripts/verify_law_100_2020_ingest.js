// scripts/verify_law_100_2020_ingest.js
//
// سكربت تحقّق مباشر (قراءة فقط، بلا أى تعديل) لتأكيد أن
// migrations/054_replace_corrupted_law_100_2020_with_clean_text_and_enable_governance_scope.sql
// نُفِّذ فعلياً وبشكل صحيح على قاعدة بيانات الإنتاج الحية — وليس فقط أن
// "[migrate] ... تم بنجاح." ظهرت فى سجلّات النشر. تلك الرسالة تعنى فقط أن
// ملف SQL نُفِّذ بلا استثناء غير مُلتقَط؛ رسائل RAISE NOTICE/RAISE WARNING
// داخل كتل DO فى الهجرة نفسها لا تصل لسجلّات Railway لأن run-migration.js
// يستخدم pg.Client().query() المباشر بلا مستمع لحدث 'notice' — فتُفقَد
// صامتة. هذا السكربت يستعلم القيم الفعلية مباشرة بدل الاعتماد على النية.
//
// ملاحظة اتساق ذاتى (idempotency) مهمة: خلال الاختبار المحلى الثلاثى قبل
// التسليم، اكتُشف أن إعادة تشغيل سلسلة الهجرات الكاملة (كما يحدث فى كل نشر
// إنتاجى فعلى) كانت تُعيد زراعة صف تالف قديم (article_no=2،
// article_suffix_order=0 الافتراضى من migrations/006) لأن الفصل 2 الجديد لا
// يشغل تلك القيمة أبداً — فلا يصطدم بقيد ON CONFLICT. أُصلح هذا جذرياً داخل
// migration 054 نفسها (كتلة تنظيف غير مشروط تحذف أى صف خارج المجموعة
// النظيفة الـ21 فى كل تشغيل). فحص article_count = 21 بالضبط أدناه (لا 22
// ولا أكثر) هو تحديداً ما يكشف عودة هذا العطل لو حدث مستقبلاً.
//
// الاستخدام:
//   railway ssh -s backend -- node scripts/verify_law_100_2020_ingest.js

const { Client } = require('pg');

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[verify-100] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  try {
    const lawRes = await client.query(
      `SELECT id, governance_scope, enacted_at, kind, category FROM laws WHERE law_no = 100 AND law_year = 2020`,
    );
    if (lawRes.rowCount === 0) {
      console.log('❌ [verify-100] law 100/2020 غير موجود فى جدول laws إطلاقاً — غير متوقَّع.');
      process.exit(1);
    }
    const law = lawRes.rows[0];
    console.log(
      `law 100/2020: governance_scope=${law.governance_scope}, enacted_at=${law.enacted_at}, kind=${law.kind}, category=${law.category}`,
    );

    const artRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id WHERE l.law_no = 100 AND l.law_year = 2020`,
    );
    console.log(`article count: ${artRes.rows[0].n} (متوقَّع: 21 بالضبط — أى رقم أكبر يعنى عودة تلوث الصف اليتيم القديم)`);

    const verRes = await client.query(
      `SELECT av.status, count(*)::int AS n FROM article_versions av
       JOIN articles a ON a.id = av.article_id
       JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 100 AND l.law_year = 2020
       GROUP BY av.status ORDER BY av.status`,
    );
    let activeCount = 0;
    for (const row of verRes.rows) {
      console.log(`article_versions[${row.status}]: ${row.n}`);
      if (row.status === 'active') activeCount = row.n;
    }
    console.log(`(متوقَّع: active=21، بلا أى صف ملغى — القرار كله سارٍ)`);

    const missingVersionRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a
       JOIN laws l ON l.id = a.law_id
       LEFT JOIN article_versions av ON av.article_id = a.id
       WHERE l.law_no = 100 AND l.law_year = 2020 AND av.id IS NULL`,
    );
    console.log(`articles بلا أى article_versions: ${missingVersionRes.rows[0].n} (متوقَّع: 0)`);

    const emptyBodyRes = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 100 AND l.law_year = 2020 AND (a.body IS NULL OR length(trim(a.body)) = 0)`,
    );
    console.log(`articles بمتن فارغ: ${emptyBodyRes.rows[0].n} (متوقَّع: 0)`);

    const scopeRes = await client.query(`SELECT count(*)::int AS n FROM laws WHERE governance_scope = true`);
    console.log(`total governance_scope=true: ${scopeRes.rows[0].n} (متوقَّع: 48)`);

    // spot-check: الفصل 1 - الفرع الفرعى 1_1 (تشكيل مجلس الإدارة، يتضمن
    // تعريف "عضو مجلس الإدارة المستقل" المُعلَّم بثقة استخراج أقل من المعتاد)
    const spotC1S1 = await client.query(
      `SELECT a.title, length(a.body) AS body_len FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 100 AND l.law_year = 2020 AND a.article_no = 1 AND a.article_suffix_order = 1`,
    );
    if (spotC1S1.rowCount > 0) {
      console.log(
        `spot-check الفصل 1 فرع 1 (تشكيل مجلس الإدارة): title="${spotC1S1.rows[0].title}", body_len=${spotC1S1.rows[0].body_len} (متوقَّع تقريبى: ~3600)`,
      );
    }

    // spot-check: الفصل 8 (أسهم الخزينة) — أقصر فصل، للتأكد من عدم انقطاع النص
    const spotC8 = await client.query(
      `SELECT a.title, length(a.body) AS body_len FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 100 AND l.law_year = 2020 AND a.article_no = 8 AND a.article_suffix_order = 0`,
    );
    if (spotC8.rowCount > 0) {
      console.log(
        `spot-check الفصل 8 (أسهم الخزينة): title="${spotC8.rows[0].title}", body_len=${spotC8.rows[0].body_len} (متوقَّع تقريبى: ~150)`,
      );
    }

    // spot-check: المادة الثانية الإجرائية (الإلغاء) بـ article_suffix_order=-1،
    // للتأكد أنها لم تُستبدَل خطأً بأى صف آخر يحمل article_no=2
    const spotP2 = await client.query(
      `SELECT a.title FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 100 AND l.law_year = 2020 AND a.article_no = 2 AND a.article_suffix_order = -1`,
    );
    if (spotP2.rowCount > 0) {
      console.log(`spot-check المادة الثانية الإجرائية: title="${spotP2.rows[0].title}"`);
    }

    // فحص تحديدى مباشر لعطل الاتساق الذاتى المُكتشَف والمُصلَح: يجب ألا يوجد
    // أى صف بـ article_no=2 وarticle_suffix_order=0 (الصف اليتيم التالف القديم)
    const orphanCheck = await client.query(
      `SELECT count(*)::int AS n FROM articles a JOIN laws l ON l.id = a.law_id
       WHERE l.law_no = 100 AND l.law_year = 2020 AND a.article_no = 2 AND a.article_suffix_order = 0`,
    );
    console.log(`spot-check صف يتيم (article_no=2, suffix=0) — يجب أن يكون 0: ${orphanCheck.rows[0].n}`);

    const enactedAtIso =
      law.enacted_at instanceof Date ? law.enacted_at.toISOString().slice(0, 10) : String(law.enacted_at);

    const ok =
      law.governance_scope === true &&
      enactedAtIso === '2020-06-23' &&
      artRes.rows[0].n === 21 &&
      activeCount === 21 &&
      missingVersionRes.rows[0].n === 0 &&
      emptyBodyRes.rows[0].n === 0 &&
      scopeRes.rows[0].n === 48 &&
      orphanCheck.rows[0].n === 0;

    console.log(
      ok
        ? '\n✅ [verify-100] كل القيم مطابقة تماماً للمتوقَّع.'
        : '\n⚠️ [verify-100] تعارض واحد أو أكثر — راجع القيم أعلاه.',
    );
  } finally {
    await client.end();
  }
}

main().catch((err) => {
  console.error('[verify-100] فشل غير متوقَّع:', err);
  process.exit(1);
});
