// scripts/validate_hnsw_ef_search_hypothesis.js
//
// سكربت تحقّق حاسم (2026-09-17، قراءة فقط) — يختبر فرضية جديدة تفسّر
// تناقض gov-090 تفسيراً معمارياً حقيقياً، لا لغزاً بلا حل:
//
// اكتُشف أن عمود articles.embedding مُفهرَس بفهرس HNSW تقريبى
// (migrations/001_init.sql, 002_embeddings_dimension.sql —
// `USING hnsw (embedding vector_cosine_ops)`، بمعاملات pgvector
// الافتراضية: m=16, ef_construction=64, hnsw.ef_search=40 وقت الاستعلام).
//
// فهرس HNSW **تقريبى (Approximate Nearest Neighbor)** بطبيعته — لا يضمن
// استرجاع أقرب K نتيجة حقيقية بدقة 100%، خصوصاً مع استعلام مُرشَّح
// (WHERE l.governance_scope = true) — وهى مشكلة معروفة وموثَّقة رسمياً فى
// pgvector: الفهرس يستكشف ef_search مرشحاً فى فضاء المتجهات *قبل* تطبيق
// شرط WHERE، فلو كانت النتائج المرشَّحة (governance_scope=true) نسبة صغيرة
// من المرشحين القريبين فعلياً، فقد لا يكفى ef_search الافتراضى (40) لإيجاد
// عدد كافٍ منها ضمن LIMIT المطلوب — تماماً ما نشاهده هنا: عشرات المرشحين
// متزاحمون بتشابه متقارب جداً (0.42-0.53).
//
// هذا يفسّر التناقض بالكامل: استعلامات check_retrieval_rank.js و
// check_gov090_duplicate_rows.js (خطوة 4) **بلا LIMIT** — مخطِّط Postgres
// لا يستخدم فهرس HNSW أصلاً لاستعلام بلا LIMIT (لا فائدة تقريبية تُذكر)،
// فيُنفِّذ مسحاً كاملاً دقيقاً 100% لكل 1355 صفاً — ومن هنا رتبة #6 الثابتة
// عبر تشغيلتين مستقلتين. لكن semanticCandidates() الفعلية فى الإنتاج تستخدم
// `ORDER BY ... LIMIT 15/25` — نمط استعلام يُفعِّل فهرس HNSW التقريبى مباشرة
// — فيُفقَد المرشح الحقيقى بسبب حد الاستكشاف الافتراضى المنخفض (40) أمام
// ازدحام المرشحين وانتقائية شرط governance_scope.
//
// هذا السكربت يختبر الحل المعمارى الصحيح تجريبياً *قبل* أى تعديل على كود
// الإنتاج: تنفيذ نفس نمط استعلام semanticCandidates() (LIMIT، يُفعِّل
// الفهرس) مرتين — مرة بـ hnsw.ef_search الافتراضى (40)، ومرة برفعه صراحة
// (SET LOCAL) — لإثبات أن رفعه يُصلح الفجوة فعلاً قبل الاعتماد عليه كحل.
//
// الاستخدام: railway ssh -s backend -- node scripts/validate_hnsw_ef_search_hypothesis.js

const { Client } = require('pg');

const VOYAGE_API_URL = 'https://api.voyageai.com/v1/embeddings';
const MODEL = process.env.VOYAGE_EMBEDDING_MODEL ?? 'voyage-3.5';
const OUTPUT_DIMENSION = 1024;

const QUESTION =
  'أحد العاملين المنتدبين للأمانة الفنية للجنة رفض تزويد زميل له من إدارة أخرى داخل نفس الجهة الحكومية بأى تفاصيل عن بيانات أو معلومات حصلت عليها اللجنة بشأن أحد الكيانات، لعدم صدور تصريح رسمى بذلك.';

const TARGET_ARTICLE_ID = '75b22ece-299e-4e69-bf6c-12a5804917ab'; // من check_gov090_duplicate_rows.js

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

async function runLimitedQuery(client, vecLiteral, limit, label) {
  const explainRes = await client.query(
    `EXPLAIN SELECT a.id FROM articles a
     JOIN laws l ON l.id = a.law_id
     JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
     WHERE a.embedding IS NOT NULL AND l.governance_scope = true
     ORDER BY a.embedding <=> $1::vector
     LIMIT $2`,
    [vecLiteral, limit],
  );
  const usesIndex = explainRes.rows.some((r) => /Index Scan.*idx_articles_embedding/i.test(r['QUERY PLAN']));

  const res = await client.query(
    `SELECT a.id, a.article_no, l.law_no, l.law_year,
            1 - (a.embedding <=> $1::vector) AS similarity
     FROM articles a
     JOIN laws l ON l.id = a.law_id
     JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
     WHERE a.embedding IS NOT NULL AND l.governance_scope = true
     ORDER BY a.embedding <=> $1::vector
     LIMIT $2`,
    [vecLiteral, limit],
  );
  const pos = res.rows.findIndex((r) => r.id === TARGET_ARTICLE_ID);
  console.log(
    `[${label}] استخدام فهرس HNSW=${usesIndex} | limit=${limit} | ` +
      `المادة 15 موجودة=${pos !== -1 ? `نعم (#${pos + 1})` : 'لا ❌'}`,
  );
  return pos !== -1;
}

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  const voyageKey = process.env.VOYAGE_API_KEY;
  if (!databaseUrl || !voyageKey) {
    console.error('[hnsw] DATABASE_URL أو VOYAGE_API_KEY غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  const embedding = await voyageEmbed(voyageKey, QUESTION);
  const vecLiteral = toPgVectorLiteral(embedding);

  // ⚠️ 2026-09-17: SHOW/SET لمعامل GUC خاص بامتداد (hnsw.ef_search) يفشل
  // بخطأ guc.c/find_option لو نُفِّذ قبل أى استعلام حقيقى يستخدم عامل
  // pgvector فى نفس الجلسة (المعامل لا يُسجَّل إلا بعد تحميل مكتبة
  // الامتداد ضمنياً عبر أول استخدام فعلى له) — لذلك ننفّذ الاستعلام الحقيقى
  // (اختبار 1) أولاً، ثم SHOW بعده بأمان (ومحاط بـtry/catch احتياطاً، فهو
  // معلوماتى بحت ولا يجب أن يوقف بقية الاختبارات الحاسمة لو فشل لأى سبب).
  console.log('=== اختبار 1: نفس نمط استعلام semanticCandidates() تماماً (limit=25) بالإعداد الافتراضى ===');
  await runLimitedQuery(client, vecLiteral, 25, 'افتراضى');

  try {
    const curSetting = await client.query('SHOW hnsw.ef_search');
    console.log(`\n[معلومة] hnsw.ef_search الحالى (بعد تحميل الامتداد) = ${curSetting.rows[0].hnsw_ef_search}`);
  } catch (err) {
    console.log(`\n[معلومة] تعذّر قراءة hnsw.ef_search الحالى (غير حاسم): ${err.message}`);
  }

  for (const efSearch of [100, 200, 400]) {
    await client.query('BEGIN');
    await client.query(`SET LOCAL hnsw.ef_search = ${efSearch}`);
    console.log(`\n=== اختبار: hnsw.ef_search = ${efSearch} (limit=25) ===`);
    await runLimitedQuery(client, vecLiteral, 25, `ef_search=${efSearch}`);
    await client.query('COMMIT');
  }

  await client.end();
  console.log('\n[hnsw] انتهى — لا تعديل على أى بيانات أو إعدادات دائمة (كل SET LOCAL محصور بمعاملة واحدة).');
}

main().catch((err) => {
  console.error('[hnsw] فشل غير متوقَّع:', err);
  process.exit(1);
});
