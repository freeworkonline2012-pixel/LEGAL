// scripts/dump_defective_single_article_laws.js
//
// سكربت قراءة-فقط (2026-09-19) — يستخرج النص الخام الكامل المخزَّن حالياً
// لكل واحد من الـ14 قانوناً المؤكَّدين بعيب "المادة الواحدة الضخمة"
// (audit_governance_single_article_pattern.js، 2026-09-18)، كأساس أولى قبل
// البحث عن نص مصدر خارجى موثوق لإعادة التقطيع. لا يُعدِّل أى بيانات إطلاقاً.
//
// لماذا هذا السكربت منفصل عن سكربت التدقيق الأصلى: ذاك السكربت يحسب إحصاءات
// فقط (عدد المواد، طول النص)؛ هذا السكربت يستخرج *النص نفسه* حرفياً، لازم
// لمطابقته مع أى مصدر خارجى بديل قبل أى قرار إعادة تقطيع (نفس منهجية
// migration 025_fix_rent_law_164_2025.sql بالحرف — تحقق تطابق الأرقام/
// الاستشهادات أولاً، ثم استبدال).
//
// الاستخدام: railway ssh -s backend -- node scripts/dump_defective_single_article_laws.js
// الناتج: dump_defective_articles_<timestamp>.json فى المجلد الحالى.

const fs = require('fs');
const { Client } = require('pg');

// (law_no, law_year) لكل قانون من الـ14 — قانون 5/2022 يظهر مرتين (تأمين
// وتمويل غير مصرفى، صفّان منفصلان تماماً بفضل قيد UNIQUE(country_code,
// law_no, law_year, kind) — راجع migration 002b) لذلك لا نفلتر بـkind هنا،
// نُرجع كل الصفوف المطابقة لـ(law_no, law_year) ونترك التمييز فى المخرجات.
const TARGET_LAW_NO_YEAR = [
  [11, 2014],
  [5, 2022], // insurance + non_bank_finance معاً
  [176, 2018],
  [141, 2014],
  [1, 2024],
  [148, 2001],
  [58, 2018],
  [18, 2020],
  [61, 2017],
  [177, 2024],
  [42, 2019],
  [114, 2021],
  [9, 2021],
];

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[dump] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  const output = [];

  for (const [lawNo, lawYear] of TARGET_LAW_NO_YEAR) {
    const lawsRes = await client.query(
      `SELECT id, law_no, law_year, title, short_title, category, kind, official_url, status
       FROM laws
       WHERE law_no = $1 AND law_year = $2 AND governance_scope = true
       ORDER BY category`,
      [lawNo, lawYear],
    );

    if (lawsRes.rowCount === 0) {
      console.log(`[dump] تحذير: لا يوجد صف لـ${lawNo}/${lawYear} فى نطاق الحوكمة — تخطّى.`);
      continue;
    }

    for (const law of lawsRes.rows) {
      const artRes = await client.query(
        `SELECT id, article_no, article_suffix_order, hierarchical_location, title, body,
                length(body) AS body_len
         FROM articles
         WHERE law_id = $1
         ORDER BY article_no, article_suffix_order`,
        [law.id],
      );

      console.log(
        `[dump] ${law.law_no}/${law.law_year} [${law.category}/${law.kind}] "${law.title}" — ` +
          `${artRes.rowCount} صف مادة، أطوال: ${artRes.rows.map((r) => r.body_len).join(', ')}`,
      );

      output.push({
        law_id: law.id,
        law_no: law.law_no,
        law_year: law.law_year,
        title: law.title,
        short_title: law.short_title,
        category: law.category,
        kind: law.kind,
        official_url: law.official_url,
        status: law.status,
        articles: artRes.rows.map((r) => ({
          article_id: r.id,
          article_no: r.article_no,
          article_suffix_order: r.article_suffix_order,
          hierarchical_location: r.hierarchical_location,
          title: r.title,
          body_len: r.body_len,
          body: r.body,
        })),
      });
    }
  }

  await client.end();

  const outPath = `dump_defective_articles_${Date.now()}.json`;
  fs.writeFileSync(outPath, JSON.stringify(output, null, 2), 'utf8');
  console.log(`\n[dump] تم — ${output.length} صف قانون مستخرَج. الملف: ${outPath}`);
  console.log('[dump] لا تعديل على أى بيانات — قراءة فقط بالكامل.');
}

main().catch((err) => {
  console.error('[dump] فشل غير متوقَّع:', err);
  process.exit(1);
});
