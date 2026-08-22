// scripts/backfill-embeddings.js
//
// EP-05 (2026-08-21) — يملأ عمود articles.embedding لكل مادة لسه NULL،
// تحديداً الـ522 مادة (298 قانون العمل 14/2025 + 224 قانون التأمين الموحد
// 155/2024) التي أُدرجت عبر migrations/003_seed_real_laws.sql (SQL خام
// مباشرة، وليس عبر IngestionService.importLaws() في TypeScript — وهو
// المسار الوحيد المربوط فعلياً بـ VoyageEmbeddingsService حالياً) —
// فبقيت هذه المواد بلا فهرسة دلالية منذ البذر رغم أن الاسترجاع النصي
// (FTS) يعمل لها بشكل طبيعي تماماً.
//
// هذا سكربت "تشغيل يدوي لمرة واحدة" (one-off) — لا يُشغَّل تلقائياً كجزء
// من preDeployCommand (بعكس run-migration.js): 522 نداء شبكي لـ Voyage AI
// أثناء كل نشر يُبطئ الديبلوي بلا داعٍ ويخاطر بتجاوز مهلة health check،
// وهو غير ضروري لأن معظم الأيام لن تكون هناك مواد جديدة بلا embedding.
// يُشغَّل بدلاً من ذلك يدوياً عبر Railway (railway run node
// scripts/backfill-embeddings.js) بعد كل استيراد محتوى قانوني جديد عبر
// SQL خام. آمن لإعادة التشغيل (idempotent) بطبيعته: يستهدف فقط
// WHERE embedding IS NULL، فإعادة التشغيل بعد نجاح جزئي أو فشل تكمل من
// حيث توقفت دون أي عمل مكرر أو تكلفة API إضافية على المواد المفهرسة أصلاً.
//
// ⚠️ متطلب: migrations/002_embeddings_dimension.sql (عمود vector(1024))
// لازم يكون مُطبَّقاً قبل تشغيل هذا السكربت — وإلا سيفشل كل UPDATE بخطأ
// "different vector dimensions". run-migration.js يطبّقه تلقائياً ضمن
// preDeployCommand فى كل نشر، فهذا مضمون فعلياً على Railway.

const { Client } = require('pg');

const VOYAGE_API_URL = 'https://api.voyageai.com/v1/embeddings';
const MODEL = process.env.VOYAGE_EMBEDDING_MODEL ?? 'voyage-3.5';
const OUTPUT_DIMENSION = 1024;
// ⚠️ إصلاح (2026-08-21): حساب Voyage AI الحالي على الخطة المجانية بدون
// طريقة دفع مضافة — محدود بـ 3 طلبات/دقيقة (RPM) و10,000 توكن/دقيقة (TPM)
// (رسالة الخطأ الفعلية: "You have not yet added your payment method...
// reduced rate limits of 3 RPM and 10K TPM"). تحقّقنا تجريبياً: BATCH_SIZE=32
// بلا أي تهدئة بين الدفعات كان يضرب حد الـ429 من ثاني دفعة فوراً، فتفشل كل
// الدفعات التالية بعد استنفاد المحاولات — نتيجة: 458 من 522 مادة بلا
// embedding رغم أن السكربت "نجح" فى الظاهر (exit code فقط). الإصلاح: تصغير
// حجم الدفعة (يبقيها بأمان تحت حد الـ10K TPM) + تهدئة إجبارية بين كل دفعة
// والتالية تحترم حد الـ3 RPM + احترام رأس Retry-After عند حدوث 429 فعلياً
// بدل إعادة المحاولة فوراً.
const BATCH_SIZE = 8;
const MAX_RETRIES_PER_BATCH = 3;
const MIN_DELAY_BETWEEN_BATCHES_MS = 21000; // >20s → يبقينا تحت 3 طلبات/دقيقة بهامش أمان
const DEFAULT_RATE_LIMIT_BACKOFF_MS = 25000; // انتظار افتراضي عند 429 بلا رأس Retry-After

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function toPgVectorLiteral(vector) {
  return `[${vector.join(',')}]`;
}

async function embedBatch(texts, apiKey) {
  const res = await fetch(VOYAGE_API_URL, {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
      authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      input: texts,
      model: MODEL,
      input_type: 'document',
      output_dimension: OUTPUT_DIMENSION,
    }),
  });

  if (!res.ok) {
    const errText = await res.text().catch(() => '');
    const err = new Error(`Voyage API error ${res.status}: ${errText}`);
    err.status = res.status;
    err.retryAfterSeconds = Number.parseInt(res.headers.get('retry-after') ?? '', 10) || null;
    throw err;
  }

  const data = await res.json();
  if (!data.data) {
    throw new Error('Voyage API response missing "data" field');
  }
  return data.data.map((d) => d.embedding ?? null);
}

async function main() {
  const databaseUrl = process.env.DATABASE_URL;
  if (!databaseUrl) {
    console.error('[backfill] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const apiKey = process.env.VOYAGE_API_KEY;
  if (!apiKey) {
    console.error(
      '[backfill] VOYAGE_API_KEY غير مضبوط — لا يمكن حساب أي embedding. توقف بلا تنفيذ (بدل تدهور صامت هنا، لأن هذا سكربت يدوي صريح الغرض).',
    );
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  let succeeded = 0;
  let failed = 0;
  const failedIds = [];

  try {
    const { rows: pending } = await client.query(
      `SELECT id, body FROM articles WHERE embedding IS NULL ORDER BY created_at ASC`,
    );

    console.log(`[backfill] عدد المواد بلا embedding: ${pending.length}`);
    if (pending.length === 0) {
      console.log('[backfill] لا شيء للفعل — كل المواد مفهرسة دلالياً بالفعل.');
      return;
    }

    for (let i = 0; i < pending.length; i += BATCH_SIZE) {
      const batch = pending.slice(i, i + BATCH_SIZE);
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
          console.warn(
            `[backfill] دفعة ${i}-${i + batch.length}: محاولة ${attempt}/${MAX_RETRIES_PER_BATCH} فشلت: ${err.message}`,
          );
          if (err.status === 429 && attempt < MAX_RETRIES_PER_BATCH) {
            const backoffMs = err.retryAfterSeconds
              ? err.retryAfterSeconds * 1000 + 1000
              : DEFAULT_RATE_LIMIT_BACKOFF_MS;
            console.warn(`[backfill] حد المعدّل (429) — انتظار ${Math.round(backoffMs / 1000)} ثانية قبل إعادة المحاولة...`);
            await sleep(backoffMs);
          }
        }
      }

      if (lastErr || !embeddings) {
        failed += batch.length;
        batch.forEach((r) => failedIds.push(r.id));
        console.error(
          `[backfill] دفعة ${i}-${i + batch.length}: فشلت نهائياً بعد ${MAX_RETRIES_PER_BATCH} محاولات — تخطٍ (يمكن إعادة تشغيل السكربت لاحقاً، آمن).`,
        );
        continue;
      }

      for (let j = 0; j < batch.length; j++) {
        const vector = embeddings[j];
        if (!vector) {
          failed += 1;
          failedIds.push(batch[j].id);
          console.warn(`[backfill] المادة ${batch[j].id}: Voyage لم يُرجع متجهاً — تخطٍ.`);
          continue;
        }
        try {
          await client.query('UPDATE articles SET embedding = $1::vector WHERE id = $2', [
            toPgVectorLiteral(vector),
            batch[j].id,
          ]);
          succeeded += 1;
        } catch (err) {
          failed += 1;
          failedIds.push(batch[j].id);
          console.error(`[backfill] المادة ${batch[j].id}: فشل UPDATE: ${err.message}`);
        }
      }

      console.log(
        `[backfill] تقدّم: ${succeeded + failed}/${pending.length} (نجاح: ${succeeded}, فشل: ${failed})`,
      );

      const hasMoreBatches = i + BATCH_SIZE < pending.length;
      if (hasMoreBatches) {
        await sleep(MIN_DELAY_BETWEEN_BATCHES_MS);
      }
    }
  } finally {
    await client.end();
  }

  console.log('[backfill] ===== ملخص نهائي =====');
  console.log(`[backfill] نجح: ${succeeded}`);
  console.log(`[backfill] فشل: ${failed}`);
  if (failedIds.length > 0) {
    console.log(`[backfill] معرّفات المواد الفاشلة (أعد تشغيل السكربت لإعادة محاولتها):`);
    console.log(JSON.stringify(failedIds, null, 2));
  }

  if (failed > 0) {
    process.exitCode = 1;
  }
}

main().catch((err) => {
  console.error('[backfill] فشل غير متوقع:', err);
  process.exit(1);
});
