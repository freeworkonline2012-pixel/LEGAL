// scripts/check_retrieval_rank.js
//
// سكربت تشخيصى مستهدف (2026-09-13، قراءة فقط، آمن تماماً) — يكمل
// check_missing_governance_articles.js: ذاك أثبت أن مادتى gov-090
// (22/2018 م15) وgov-182 (2036/2026 م2) موجودتان ومُفهرَستان بالكامل
// (embedding موجود)، أى أن غيابهما عن مجمع المرشحين ([DIAG-RERANK-FULL]
// على Railway) ليس فجوة محتوى بل فجوة **ترتيب/استرجاع مبكرة** — المادة
// لا تدخل حتى أفضل 15 نتيجة FTS ولا أفضل 15 نتيجة دلالية (الحد الحالى فى
// GovernanceService.assess قبل الدمج وrerank).
//
// هذا السكربت يحسب **الرتبة الفعلية** لكل مادة مستهدَفة لو أُزيل حد الـ15
// كلياً (FTS ودلالياً على حدة) — إجابة حاسمة قبل أى تعديل كود: لو كانت
// الرتبة الحقيقية قريبة (مثلاً 16-40)، فتوسيع الحد المبكر حل مباشر ومبرَّر
// بدليل. لو كانت بعيدة جداً (مئات)، فالمشكلة فى جودة التطابق نفسها (FTS
// 'simple' بلا اشتقاق عربى، أو تمثيل دلالى ضعيف لنص قصير) لا فى الحد
// العددى — ويحتاج حلاً مختلفاً تماماً، لا مجرد رفع رقم.
//
// الاستخدام:
//   railway ssh -s backend -- node scripts/check_retrieval_rank.js

const { Client } = require('pg');
const { buildFtsQuery } = require('../dist/questions/retrieval');

const VOYAGE_API_URL = 'https://api.voyageai.com/v1/embeddings';
const MODEL = process.env.VOYAGE_EMBEDDING_MODEL ?? 'voyage-3.5';
const OUTPUT_DIMENSION = 1024;

const TARGETS = [
  {
    id: 'gov-090',
    lawNo: 22,
    lawYear: 2018,
    articleNo: 15,
    question:
      'أحد العاملين المنتدبين للأمانة الفنية للجنة رفض تزويد زميل له من إدارة أخرى داخل نفس الجهة الحكومية بأى تفاصيل عن بيانات أو معلومات حصلت عليها اللجنة بشأن أحد الكيانات، لعدم صدور تصريح رسمى بذلك.',
  },
  {
    id: 'gov-182',
    lawNo: 2036,
    lawYear: 2026,
    articleNo: 2,
    question:
      'خلال مهلة الثلاثة أشهر الممنوحة من تاريخ العمل بقرار 2036/2026، عدّلت شركة تأمين على الحياة سياسة الاكتتاب لديها لتشمل الاستعلام عن القوائم السلبية والاستعلام الائتمانى والتحقق من ملكية رقم الهاتف المحمول.',
  },
];

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
  if (!databaseUrl) {
    console.error('[rank] DATABASE_URL غير مضبوط.');
    process.exit(1);
  }

  const client = new Client({ connectionString: databaseUrl });
  await client.connect();

  for (const t of TARGETS) {
    console.log(`\n=== ${t.id}: ${t.lawNo}/${t.lawYear} م${t.articleNo} ===`);

    // --- FTS: رتبة كاملة بلا حد، ضمن نطاق الحوكمة فقط ---
    const ftsQuery = buildFtsQuery(t.question);
    if (!ftsQuery) {
      console.log('  [FTS] لا يوجد استعلام صالح (كل الكلمات قصيرة/مستبعدة).');
    } else {
      const ftsRows = await client.query(
        `SELECT a.article_no, a.article_suffix_order, l.law_no, l.law_year,
                ts_rank(to_tsvector('simple', arabic_normalize(v.body)), to_tsquery('simple', $1)) AS rank
         FROM article_versions v
         JOIN articles a ON a.id = v.article_id
         JOIN laws l ON l.id = a.law_id
         WHERE to_tsvector('simple', arabic_normalize(v.body)) @@ to_tsquery('simple', $1)
           AND v.effective_to IS NULL
           AND l.governance_scope = true
         ORDER BY rank DESC`,
        [ftsQuery],
      );
      const pos = ftsRows.rows.findIndex(
        (r) => r.law_no === t.lawNo && r.law_year === t.lawYear && r.article_no === t.articleNo,
      );
      console.log(
        `  [FTS] إجمالى النتائج المطابقة=${ftsRows.rowCount} — رتبة المادة المستهدَفة=${
          pos === -1 ? 'غير موجودة إطلاقاً فى نتائج FTS (لا تطابق لفظى أصلاً)' : `#${pos + 1}`
        }${pos !== -1 ? ` (rank=${Number(ftsRows.rows[pos].rank).toFixed(4)})` : ''}`,
      );
    }

    // --- الدلالى: رتبة كاملة بلا حد، ضمن نطاق الحوكمة فقط ---
    if (!voyageKey) {
      console.log('  [دلالى] VOYAGE_API_KEY غير مضبوط — تخطّى.');
      continue;
    }
    const embedding = await voyageEmbed(voyageKey, t.question);
    const vecLiteral = toPgVectorLiteral(embedding);
    // ⚠️ يجب مطابقة semanticCandidates() فى governance.service.ts حرفياً —
    // بما فى ذلك JOIN article_versions (av.effective_to IS NULL). محاولة
    // أولى سابقة نسيت هذا الـJOIN فأعطت رتباً متفائلة زائفة (تحسب مواد
    // بإصدار غير سارٍ ضمن المنافسة، رغم أن الاستعلام الفعلى فى الإنتاج
    // يستبعدها بـINNER JOIN) — هذا الإصلاح يطابق واقع الإنتاج تماماً.
    const semRows = await client.query(
      `SELECT a.article_no, a.article_suffix_order, l.law_no, l.law_year,
              1 - (a.embedding <=> $1::vector) AS similarity
       FROM articles a
       JOIN laws l ON l.id = a.law_id
       JOIN article_versions av ON av.article_id = a.id AND av.effective_to IS NULL
       WHERE a.embedding IS NOT NULL AND l.governance_scope = true
       ORDER BY similarity DESC`,
      [vecLiteral],
    );
    const semPos = semRows.rows.findIndex(
      (r) => r.law_no === t.lawNo && r.law_year === t.lawYear && r.article_no === t.articleNo,
    );
    console.log(
      `  [دلالى] إجمالى المواد المفهرَسة=${semRows.rowCount} — رتبة المادة المستهدَفة=${
        semPos === -1 ? 'لم تُوجَد (غير متوقَّع، راجع يدوياً)' : `#${semPos + 1}`
      }${semPos !== -1 ? ` (similarity=${Number(semRows.rows[semPos].similarity).toFixed(4)})` : ''}`,
    );
    // ⚠️ 2026-09-13: طباعة أفضل 15 نتيجة دلالية بالكامل — للمقارنة المباشرة
    // مع سجلّ "governance pool" الفعلى على Railway لنفس qHash (تناقض ظاهرى
    // لوحظ: رتبة محسوبة هنا #6 لم تظهر إطلاقاً فى ذلك السجلّ رغم أن الحد
    // فيه 15 أيضاً — يجب حسمه بالمقارنة المباشرة قبل أى استنتاج نهائى).
    console.log(
      `  [دلالى top-15]: ` +
        semRows.rows
          .slice(0, 15)
          .map(
            (r, i) =>
              `#${i + 1}:${r.law_no}/${r.law_year}م${r.article_no}` +
              (r.article_suffix_order !== 0 ? `.${r.article_suffix_order}` : '') +
              `(${Number(r.similarity).toFixed(4)})`,
          )
          .join(', '),
    );
  }

  await client.end();
  console.log('\n[rank] انتهى — لا تعديل على أى بيانات.');
}

main().catch((err) => {
  console.error('[rank] فشل غير متوقَّع:', err);
  process.exit(1);
});
