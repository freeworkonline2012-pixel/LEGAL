// scripts/check_missing_governance_articles.js
//
// سكربت تشخيصى مستهدف (2026-09-13) — جزء من إصلاح جذرى لثلاثة بنود فى
// Golden Test Set فشلت باستمرار عبر 3 محاولات قياس مستقلة (gov-090،
// gov-123، gov-182؛ راجع تقرير-تراجع-غير-متوقع-فى-دقة-الحوكمة... فى
// توثيق المشروع). خلافاً لبقية البنود المتراجعة (التى فُسِّرت بعدم-حتمية
// DeepSeek ومُعولجت عبر تصويت أغلبية فى governance.service.ts)، هذه الثلاثة
// أثبت السجل التشخيصى المباشر ([DIAG-RERANK-FULL] على Railway) أن أساسها
// القانونى الصحيح **لم يدخل مجمع المرشحين إطلاقاً** (لا بعد rerank فقط، بل
// فى كامل مجمع الاسترجاع الخام الأولى قبل الترتيب) — أى عطل فى الاسترجاع
// نفسه، لا فى القرار. تصويت الأغلبية لن يصلح هذه الحالات (المشكلة ليست
// عشوائية بل نظامية)، فتحتاج تشخيصاً منفصلاً: هل المادة غير مفهرسة أصلاً فى
// قاعدة البيانات، أم مفهرسة لكن بلا embedding (نفس عطل EP-05 السابق)، أم
// مفهرسة تماماً لكن لا تُسترجَع لأسباب نصية (FTS 'simple' لا يطابق صيغاً
// صرفية مختلفة — نفس العطل الموثَّق سابقاً فى تعليق GovernanceService.assess)؟
//
// الاستخدام (قراءة فقط — لا تعديل على البيانات، آمن للتشغيل فى أى وقت):
//   railway ssh -s backend -- node scripts/check_missing_governance_articles.js

const { Client } = require('pg');

const TARGETS = [
  { id: 'gov-090', lawNo: 22, lawYear: 2018, articleNo: 15 },
  { id: 'gov-123', lawNo: 11, lawYear: 2014, articleNo: 40 },
  { id: 'gov-182', lawNo: 2036, lawYear: 2026, articleNo: 2 },
];

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[check] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  console.log('[check] فحص 3 مواد فشل استرجاعها باستمرار فى قياسات الحوكمة الحية:\n');

  for (const t of TARGETS) {
    console.log(`--- ${t.id}: قانون/قرار ${t.lawNo}/${t.lawYear}، المادة ${t.articleNo} ---`);

    const lawRes = await client.query(
      `SELECT id, title, category, governance_scope, status FROM laws WHERE law_no = $1 AND law_year = $2`,
      [t.lawNo, t.lawYear],
    );
    if (lawRes.rowCount === 0) {
      console.log(`  ❌ القانون/القرار نفسه غير موجود فى جدول laws إطلاقاً.\n`);
      continue;
    }
    const law = lawRes.rows[0];
    console.log(
      `  ✅ القانون موجود (id=${law.id}) — الفئة=${law.category}، ` +
        `governance_scope=${law.governance_scope}، الحالة=${law.status}`,
    );
    if (!law.governance_scope) {
      console.log(
        `  ⚠️ governance_scope=false — هذا وحده يكفى لاستبعاد كل مواد هذا القانون من ` +
          `مسار استرجاع الحوكمة كلياً (شرط صريح فى semanticCandidates وftsCandidates)، ` +
          `بصرف النظر عن حالة الفهرسة أدناه.`,
      );
    }

    const artRes = await client.query(
      `SELECT id, article_no, article_suffix_order,
              (embedding IS NOT NULL) AS has_embedding,
              length(body) AS body_len
       FROM articles WHERE law_id = $1 AND article_no = $2
       ORDER BY article_suffix_order`,
      [law.id, t.articleNo],
    );

    if (artRes.rowCount === 0) {
      console.log(`  ❌ المادة ${t.articleNo} غير موجودة فى جدول articles لهذا القانون إطلاقاً.`);
      console.log(`     → فجوة محتوى حقيقية (لم تُفهرَس هذه المادة قط)، لا عطل ترتيب.\n`);
      continue;
    }

    for (const row of artRes.rows) {
      const suffix = row.article_suffix_order !== 0 ? ` (فرعى=${row.article_suffix_order})` : '';
      console.log(
        `  ✅ المادة موجودة${suffix} — embedding=${row.has_embedding ? 'موجود' : '❌ NULL'}، ` +
          `طول النص=${row.body_len} حرفاً`,
      );
      if (!row.has_embedding) {
        console.log(
          `     → نفس عطل EP-05 السابق (مادة مفهرسة نصياً لكن بلا embedding) — ` +
            `يلزم تشغيل backfill-embeddings.js.`,
        );
      }
    }
    console.log('');
  }

  await client.end();
  console.log('[check] انتهى — لا تعديل على أى بيانات.');
}

main().catch((err) => {
  console.error('[check] فشل غير متوقَّع:', err);
  process.exit(1);
});
