// scripts/diagnose-consumer-protection.js
//
// تشخيص فقط (2026-09-03) — لا تعديل، لا حذف، لا INSERT/UPDATE إطلاقاً.
// كل الاستعلامات SELECT خالصة. هدفه التحقق المباشر من فرضية "عطل مادة
// واحدة فقط" الموثَّقة سابقاً لقانون حماية المستهلك 181/2018 (+تعديله
// 20/2024)، بعد أن أظهر التشغيل الحي لـ golden_test_set_v2.json اليوم أن
// سؤالين عن استرجاع منتج معيب أُجيبا خطأً من قانون التجارة 17/1999 (مادة
// 101) بدل قانون حماية المستهلك — دليل غير مباشر على أن محتوى 181/2018
// الحقيقى قد لا يزال غير قابل للاسترجاع (سواء غائب من القاعدة أصلاً، أو
// موجود لكن بلا embedding).
//
// يُشغَّل حصرياً عبر:  railway ssh -s backend -- node scripts/diagnose-consumer-protection.js
// (لا railway run — نفس القيد الموثَّق سابقاً بخصوص الوصول لـ *.railway.internal)

const { Client } = require('pg');

const TARGET_LAWS = [
  { law_no: 181, law_year: 2018, label: 'قانون حماية المستهلك 181/2018 (الأصلى)' },
  { law_no: 20, law_year: 2024, label: 'تعديل حماية المستهلك 20/2024' },
  { law_no: 17, law_year: 1999, label: 'قانون التجارة 17/1999 (للمقارنة — هذا ما استُشهِد به خطأً)' },
];

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[diagnose] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }
  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  console.log('='.repeat(70));
  console.log('تشخيص قراءة فقط — قانون حماية المستهلك مقابل قانون التجارة');
  console.log('='.repeat(70));

  for (const target of TARGET_LAWS) {
    console.log(`\n----- ${target.label} (${target.law_no}/${target.law_year}) -----`);

    const lawRes = await client.query(
      `SELECT id, category, status, title FROM laws WHERE law_no = $1 AND law_year = $2`,
      [target.law_no, target.law_year],
    );

    if (lawRes.rows.length === 0) {
      console.log('  ⚠️ لا يوجد صف فى جدول laws إطلاقاً لهذا القانون.');
      continue;
    }

    const law = lawRes.rows[0];
    console.log(`  law_id: ${law.id}`);
    console.log(`  category: ${law.category} | status: ${law.status}`);
    console.log(`  title: ${law.title}`);

    const countRes = await client.query(
      `SELECT
         count(*) AS total_articles,
         count(embedding) AS with_embedding,
         count(*) FILTER (WHERE embedding IS NULL) AS missing_embedding,
         min(article_no) AS min_article_no,
         max(article_no) AS max_article_no
       FROM articles WHERE law_id = $1`,
      [law.id],
    );
    const c = countRes.rows[0];
    console.log(
      `  عدد المواد: ${c.total_articles} | لها embedding: ${c.with_embedding} | بلا embedding: ${c.missing_embedding} | نطاق أرقام المواد: ${c.min_article_no}–${c.max_article_no}`,
    );

    // عيّنة من أرقام المواد الموجودة فعلياً (للكشف عن فجوات أو تكرار)
    const sampleRes = await client.query(
      `SELECT article_no, article_suffix_order, length(body) AS body_len, (embedding IS NOT NULL) AS has_embedding
       FROM articles WHERE law_id = $1
       ORDER BY article_no, article_suffix_order
       LIMIT 15`,
      [law.id],
    );
    console.log('  أول 15 مادة موجودة فعلياً:');
    for (const row of sampleRes.rows) {
      console.log(
        `    - مادة ${row.article_no}${row.article_suffix_order ? ' (suffix ' + row.article_suffix_order + ')' : ''}: طول النص ${row.body_len} حرف، embedding: ${row.has_embedding ? 'موجود' : 'غائب'}`,
      );
    }
  }

  console.log('\n' + '='.repeat(70));
  console.log('انتهى التشخيص — لا تعديل تم إجراؤه على أى بيانات.');
  console.log('='.repeat(70));

  await client.end();
}

main().catch((err) => {
  console.error('[diagnose] فشل غير متوقع:', err);
  process.exit(1);
});
