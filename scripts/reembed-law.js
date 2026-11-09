// scripts/reembed-law.js  (الجولة 74)
//
// يعيد حساب embedding لكل مواد قانون واحد بعينه (بنص المادة الحالى). الاستخدام: بعد هجرة تعدّل نصوص مواد قانون
// (مثل الهجرة 215 لقانون المحاماة 17/1983 التى عدّلت 229 مادة فبقيت embeddings محسوبة من النص التالف القديم).
// مقيَّد بقانون واحد؛ لا يمس أى قانون آخر. آمن لإعادة التشغيل (يحسب من جديد ويكتب فوق نفس القانون فقط).
//
// التشغيل داخل Railway (بلا فتح TCP proxy عام على قاعدة البيانات):
//   railway ssh --service backend -- node scripts/reembed-law.js 17 1983
// أو للعرض فقط بلا أى نداء ولا كتابة:
//   railway ssh --service backend -- node scripts/reembed-law.js 17 1983 --dry-run
//
// يحتاج DATABASE_URL وVOYAGE_API_KEY (متوفران داخل خدمة backend). يحترم حد المعدّل نفسه الذى فى backfill-embeddings.js:
// دفعات 8 وتهدئة 21 ثانية بين الدفعات (حساب Voyage على الخطة المجانية 3 طلبات فى الدقيقة).

const { Client } = require('pg');

const VOYAGE_API_URL = 'https://api.voyageai.com/v1/embeddings';
const MODEL = process.env.VOYAGE_EMBEDDING_MODEL ?? 'voyage-3.5';
const OUTPUT_DIMENSION = 1024;
const BATCH_SIZE = 8;
const MAX_RETRIES_PER_BATCH = 3;
const MIN_DELAY_BETWEEN_BATCHES_MS = 21000;
const DEFAULT_RATE_LIMIT_BACKOFF_MS = 25000;

const DRY_RUN = process.argv.includes('--dry-run');
const positional = process.argv.slice(2).filter((a) => !a.startsWith('--'));

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function toPgVectorLiteral(vector) {
  return `[${vector.join(',')}]`;
}

async function embedBatch(texts, apiKey) {
  const res = await fetch(VOYAGE_API_URL, {
    method: 'POST',
    headers: { 'content-type': 'application/json', authorization: `Bearer ${apiKey}` },
    body: JSON.stringify({ input: texts, model: MODEL, input_type: 'document', output_dimension: OUTPUT_DIMENSION }),
  });
  if (!res.ok) {
    const errText = await res.text().catch(() => '');
    const err = new Error(`Voyage API error ${res.status}: ${errText}`);
    err.status = res.status;
    err.retryAfterSeconds = Number.parseInt(res.headers.get('retry-after') ?? '', 10) || null;
    throw err;
  }
  const data = await res.json();
  if (!data.data) throw new Error('Voyage API response missing "data" field');
  return data.data.map((d) => d.embedding ?? null);
}

async function main() {
  const lawNo = Number.parseInt(positional[0] ?? '', 10);
  const lawYear = Number.parseInt(positional[1] ?? '', 10);
  if (!Number.isInteger(lawNo) || !Number.isInteger(lawYear)) {
    console.error('[reembed-law] الاستخدام: node scripts/reembed-law.js <law_no> <law_year> [--dry-run]');
    process.exit(1);
  }
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[reembed-law] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }
  const apiKey = process.env.VOYAGE_API_KEY;
  if (!DRY_RUN && !apiKey) {
    console.error('[reembed-law] VOYAGE_API_KEY غير مضبوط — توقف بلا تنفيذ.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();
  let succeeded = 0;
  let failed = 0;
  const failedIds = [];
  try {
    const { rows: laws } = await client.query(
      `SELECT id, title FROM laws WHERE law_no = $1 AND law_year = $2 AND country_code = 'EG'`,
      [lawNo, lawYear],
    );
    if (laws.length !== 1) {
      console.error(`[reembed-law] المتوقع قانون واحد للرقم ${lawNo}/${lawYear} لكن وُجد ${laws.length}. توقف بلا تغيير.`);
      process.exit(1);
    }
    const law = laws[0];
    const { rows: pending } = await client.query(
      `SELECT a.id, a.body, (a.embedding IS NOT NULL) AS had FROM articles a WHERE a.law_id = $1 ORDER BY a.article_no, a.article_suffix_order`,
      [law.id],
    );
    const withBody = pending.filter((r) => typeof r.body === 'string' && r.body.trim().length > 0);
    console.log(`[reembed-law] القانون ${lawNo}/${lawYear}: ${pending.length} مادة (${withBody.length} بنص) ، منها بـembedding سابق: ${pending.filter((r) => r.had).length}`);
    if (DRY_RUN) {
      const batches = Math.ceil(withBody.length / BATCH_SIZE);
      console.log(`[reembed-law] --dry-run: لن يُنادى Voyage ولن يُكتب شىء. الدفعات المتوقعة: ${batches} (حوالى ${Math.ceil((batches * MIN_DELAY_BETWEEN_BATCHES_MS) / 60000)} دقيقة).`);
      return;
    }

    for (let i = 0; i < withBody.length; i += BATCH_SIZE) {
      const batch = withBody.slice(i, i + BATCH_SIZE);
      const texts = batch.map((r) => r.body);
      let embeddings = null;
      let lastErr = null;
      for (let attempt = 1; attempt <= MAX_RETRIES_PER_BATCH; attempt++) {
        try {
          embeddings = await embedBatch(texts, apiKey);
          lastErr = null;
          break;
        } catch (err) {
          lastErr = err;
          console.warn(`[reembed-law] دفعة ${i}-${i + batch.length}: محاولة ${attempt}/${MAX_RETRIES_PER_BATCH} فشلت: ${err.message}`);
          if (err.status === 429 && attempt < MAX_RETRIES_PER_BATCH) {
            const backoffMs = err.retryAfterSeconds ? err.retryAfterSeconds * 1000 + 1000 : DEFAULT_RATE_LIMIT_BACKOFF_MS;
            await sleep(backoffMs);
          }
        }
      }
      if (lastErr || !embeddings) {
        failed += batch.length;
        batch.forEach((r) => failedIds.push(r.id));
        console.error(`[reembed-law] دفعة ${i}-${i + batch.length}: فشلت نهائياً — تخطٍ (أعد التشغيل لإعادة المحاولة، آمن).`);
        continue;
      }
      for (let j = 0; j < batch.length; j++) {
        const vector = embeddings[j];
        if (!vector) {
          failed += 1;
          failedIds.push(batch[j].id);
          continue;
        }
        try {
          // مقيَّد بقانون واحد حتى لو أخطأ المعرّف: law_id فى الشرط
          const r = await client.query('UPDATE articles SET embedding = $1::vector WHERE id = $2 AND law_id = $3', [
            toPgVectorLiteral(vector),
            batch[j].id,
            law.id,
          ]);
          if (r.rowCount === 1) succeeded += 1;
          else {
            failed += 1;
            failedIds.push(batch[j].id);
          }
        } catch (err) {
          failed += 1;
          failedIds.push(batch[j].id);
          console.error(`[reembed-law] المادة ${batch[j].id}: فشل UPDATE: ${err.message}`);
        }
      }
      console.log(`[reembed-law] تقدّم: ${succeeded + failed}/${withBody.length} (نجاح: ${succeeded}, فشل: ${failed})`);
      if (i + BATCH_SIZE < withBody.length) await sleep(MIN_DELAY_BETWEEN_BATCHES_MS);
    }
  } finally {
    await client.end();
  }

  if (DRY_RUN) return;
  console.log('[reembed-law] ===== ملخص نهائى =====');
  console.log(`[reembed-law] نجح: ${succeeded}`);
  console.log(`[reembed-law] فشل: ${failed}`);
  if (failedIds.length > 0) console.log(JSON.stringify(failedIds));
  if (failed > 0) process.exitCode = 1;
}

main().catch((err) => {
  console.error('[reembed-law] فشل غير متوقع:', err);
  process.exit(1);
});
