// scripts/check_gov090_duplicate_rows.js
//
// سكربت تشخيصى حاسم (2026-09-14، قراءة فقط) — يستهدف تفسيراً جديداً لتناقض
// gov-090 لم يُستبعَد بعد: هل يوجد أكثر من صف واحد فى laws بنفس (law_no=22,
// law_year=2018)، أو أكثر من صف واحد فى articles بنفس (article_no=15) تحت
// تلك القوانين؟ هذا المشروع سبق أن واجه فعلياً تضارب ترقيم قوانين مكرَّرة
// (راجع "تقرير-إصلاح-تضارب-ترقيم-القانون-5-2022" فى توثيق المشروع) — نمط
// معروف الحدوث، لا افتراضاً بلا سابقة.
//
// السبب: سكربت check_retrieval_rank.js السابق طابق فقط على
// (law_no, law_year, article_no) دون التحقق من تفرّد الصف — لو وُجد أكثر
// من صف مطابق، فربما قاس تشابه صف مختلف عن الصف الذى ينافس فعلياً فى
// مجمع مرشحى الإنتاج الحى (الذى أظهر عدم وجود المادة 15 إطلاقاً ضمن أفضل
// 25 نتيجة دلالية — سجلّ [DIAG-SEMANTIC-RAW] الحقيقى، qHash=a04a462a).
//
// هذا السكربت:
//   1) يطبع كل صف فى laws مطابق لـ(law_no=22, law_year=2018) — للتحقق من
//      عدم وجود تكرار على مستوى القانون نفسه.
//   2) لكل قانون مطابق، يطبع كل صف فى articles مطابق لـ(article_no=15).
//   3) يحسب embedding واحد فقط للسؤال (نداء Voyage وحيد لا نداءان منفصلان
//      كما فى المحاولات السابقة — يُزيل تماماً احتمال عدم-حتمية Voyage بين
//      نداءين كمصدر للتناقض) ثم يحسب التشابه الفعلى مقابل *كل* صف مطابق
//      وجد فى الخطوة 2، لمعرفة أيها (لو تعدَّدت) يطابق فعلاً الرتبة #6
//      المزعومة، وأيها (لو تعدَّدت) هو الذى ينافس فعلياً فى الإنتاج.
//
// الاستخدام: railway ssh -s backend -- node scripts/check_gov090_duplicate_rows.js

const { Client } = require('pg');

const VOYAGE_API_URL = 'https://api.voyageai.com/v1/embeddings';
const MODEL = process.env.VOYAGE_EMBEDDING_MODEL ?? 'voyage-3.5';
const OUTPUT_DIMENSION = 1024;

const QUESTION =
  'أحد العاملين المنتدبين للأمانة الفنية للجنة رفض تزويد زميل له من إدارة أخرى داخل نفس الجهة الحكومية بأى تفاصيل عن بيانات أو معلومات حصلت عليها اللجنة بشأن أحد الكيانات، لعدم صدور تصريح رسمى بذلك.';

async function voyageEmbed(apiKey, text) {
  const res = await fetch(VOYAGE_API_URL, {
    method: 'POST',
    headers: { 'content-type': 'application/json', authorization: `Bearer ${apiKey}` },
    body: JSON.stringify({
      input: [text],
      model: MODEL,
      input_type: 'query',
      output_dimension: OUTPUT_DIMENSION,
    }),
  });
  if (!res.ok) {
    throw new Error(`Voyage embeddings HTTP ${res.status}: ${await res.text().catch(() => '')}`);
  }
  const data = await res.json();
  return data.data[0].embedding;
}

function toPgVectorLiteral(vec) {
  return `[${vec.join(',')}]`;
}

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  const voyageKey = process.env.VOYAGE_API_KEY;
  if (!databaseUrl || !voyageKey) {
    console.error('[dup] DATABASE_URL أو VOYAGE_API_KEY غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  console.log('=== الخطوة 1: كل صف فى laws مطابق لـ(law_no=22, law_year=2018) ===');
  const lawRows = await client.query(
    `SELECT id, law_no, law_year, title, short_title, governance_scope, status, category
     FROM laws WHERE law_no = 22 AND law_year = 2018`,
  );
  console.log(`عدد الصفوف=${lawRows.rowCount}`);
  for (const l of lawRows.rows) {
    console.log(
      `  id=${l.id} | governance_scope=${l.governance_scope} | status=${l.status} | ` +
        `category=${l.category} | title=${l.title}`,
    );
  }
  if (lawRows.rowCount > 1) {
    console.log(
      '  ⚠️ أكثر من صف واحد لنفس (law_no, law_year) — تضارب ترقيم قوانين محتمَل (نمط معروف سابقاً فى هذا المشروع).',
    );
  }

  console.log('\n=== الخطوة 2: كل صف فى articles مطابق لـ(article_no=15) تحت هذه القوانين ===');
  const allArticles = [];
  for (const l of lawRows.rows) {
    const artRows = await client.query(
      `SELECT a.id, a.article_no, a.article_suffix_order,
              (a.embedding IS NOT NULL) AS has_embedding,
              av.body, length(av.body) AS body_len, av.effective_to
       FROM articles a
       LEFT JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
       WHERE a.law_id = $1 AND a.article_no = 15`,
      [l.id],
    );
    console.log(`  قانون id=${l.id}: عدد صفوف المادة 15=${artRows.rowCount}`);
    for (const a of artRows.rows) {
      console.log(
        `    article.id=${a.id} | suffix=${a.article_suffix_order} | embedding=${a.has_embedding ? 'موجود' : 'NULL'} | ` +
          `طول النص=${a.body_len ?? 'null'} | النص=${(a.body ?? '(لا يوجد إصدار سارٍ)').slice(0, 80)}...`,
      );
      allArticles.push({ lawId: l.id, ...a });
    }
  }

  if (allArticles.length === 0) {
    console.log('\n[dup] لا توجد أى مادة 15 مطابقة إطلاقاً — غير متوقَّع، راجع يدوياً.');
    await client.end();
    return;
  }
  if (allArticles.length > 1) {
    console.log(
      `\n  ⚠️ يوجد ${allArticles.length} صف مختلف لمادة 15 تحت هذا الترقيم — هذا يفسّر التناقض مباشرة: ` +
        'كل سكربت/طلب سابق قد يكون قاس صفاً مختلفاً دون أن يدرى.',
    );
  }

  console.log('\n=== الخطوة 3: تشابه فعلى (نداء Voyage واحد فقط) مقابل كل صف موجود ===');
  const embedding = await voyageEmbed(voyageKey, QUESTION);
  const vecLiteral = toPgVectorLiteral(embedding);

  for (const a of allArticles) {
    if (!a.has_embedding) {
      console.log(`  article.id=${a.id}: لا يوجد embedding — تخطّى.`);
      continue;
    }
    const simRes = await client.query(
      `SELECT 1 - (embedding <=> $1::vector) AS similarity FROM articles WHERE id = $2`,
      [vecLiteral, a.id],
    );
    const similarity = Number(simRes.rows[0].similarity);
    console.log(`  article.id=${a.id} (law.id=${a.lawId}): similarity=${similarity.toFixed(4)}`);
  }

  // رتبة هذا التشابه وسط كل مجمع المرشحين (نفس منطق semanticCandidates
  // الفعلى تماماً، لمعرفة أين يقع كل صف حقيقةً بلا أي فارق نداء API).
  console.log('\n=== الخطوة 4: الرتبة الفعلية لكل صف ضمن كامل مجمع الحوكمة (نفس نداء Voyage أعلاه) ===');
  const allRes = await client.query(
    `SELECT a.id, 1 - (a.embedding <=> $1::vector) AS similarity
     FROM articles a
     JOIN laws l ON l.id = a.law_id
     JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
     WHERE a.embedding IS NOT NULL AND l.governance_scope = true
     ORDER BY similarity DESC`,
    [vecLiteral],
  );
  for (const a of allArticles) {
    if (!a.has_embedding) continue;
    const pos = allRes.rows.findIndex((r) => r.id === a.id);
    console.log(
      `  article.id=${a.id}: الرتبة=${pos === -1 ? 'غير موجودة فى مجمع الحوكمة (governance_scope=false على قانونها أو لا إصدار سارٍ)' : `#${pos + 1} من ${allRes.rowCount}`}`,
    );
  }

  await client.end();
  console.log('\n[dup] انتهى — لا تعديل على أى بيانات.');
}

main().catch((err) => {
  console.error('[dup] فشل غير متوقَّع:', err);
  process.exit(1);
});
