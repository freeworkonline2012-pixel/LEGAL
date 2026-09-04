// export_golden_candidates.js
//
// Phase 1 من "الخدمة الأولى" (راجع: تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى
// -2026-09-02.md فى مشروع المستخدم على claude.ai، القسم 2.3 — بند "حلقة
// التحسين المستمر"). يقرأ فقط (لا يعدّل أى شىء) صفوف reviews التى:
//   - وافق عليها محامٍ فعلياً (status IN ('approved','needs_changes')،
//     وليس pending — لا يُستخرَج شىء لم يُحسَم بعد)
//   - promote_to_golden_set = true (علامة صريحة من المحامى نفسه عند
//     الحسم — راجع migrations/031 وتعليق الحقل فى review.entity.ts)
//
// وينتج ملف JSON بنفس بنية golden_test_set_v2.json (items array) لمراجعة
// يدوية قبل الدمج فى الملف الفعلى — عمداً **لا يدمج تلقائياً**، لتبقى نفس
// درجة الرقابة البشرية المُطبَّقة على كل توسيع سابق لمجموعة الاختبار.
//
// طريقة الاستخدام (نفس نمط structural_integrity_check.js):
//   DATABASE_URL=postgres://... node scripts/export_golden_candidates.js [out.json]
//
// أو عبر railway ssh:
//   railway ssh -s backend -- node -e "eval(Buffer.from('<base64>','base64').toString())"
// (الإخراج فى هذه الحالة يُطبَع كـJSON على stdout بدل كتابة ملف — انظر
// الشرط IS_SSH_INLINE أدناه).

const { Client } = require('pg');
const fs = require('fs');

async function run() {
  const client = new Client({ connectionString: process.env.DATABASE_URL });
  await client.connect();

  const { rows } = await client.query(`
    SELECT
      r.id AS review_id,
      r.corrected_answer,
      r.corrected_law_no,
      r.corrected_law_year,
      r.corrected_article_no,
      r.review_note,
      r.trigger_reason,
      q.question,
      c.law_no AS original_law_no,
      c.law_year AS original_law_year,
      c.article_no AS original_article_no
    FROM reviews r
    JOIN answers a ON a.id = r.answer_id
    JOIN questions q ON q.id = a.question_id
    LEFT JOIN citations c ON c.answer_id = a.id
    WHERE r.promote_to_golden_set = true
      AND r.status IN ('approved', 'needs_changes')
    ORDER BY r.reviewed_at ASC NULLS LAST
  `);

  const items = rows.map((row, i) => ({
    id: `gc${String(i + 1).padStart(3, '0')}`,
    // مصدر رقم القانون/المادة: تصحيح المحامى إن وُجد، وإلا الاستشهاد الأصلى
    // كما عرضه النظام (المحامى وافق عليه ضمنياً بوضع علامة الترقية بلا تصحيح).
    law_no: row.corrected_law_no ?? row.original_law_no ?? null,
    law_year: row.corrected_law_year ?? row.original_law_year ?? null,
    // category وphrasing_style: تُترَك null عمداً — تحتاج تصنيفاً يدوياً عند
    // المراجعة النهائية قبل الدمج (نفس ما فعلناه لكل دفعة توسيع سابقة)،
    // ولا يمكن استنتاجها تلقائياً بثقة من بيانات المراجعة وحدها.
    category: null,
    expected_article_no: row.corrected_article_no ?? row.original_article_no ?? null,
    phrasing_style: null,
    expected_behavior: 'answer',
    question: row.question,
    // حقول مصدر إضافية (ليست جزءاً من بنية Golden Test Set القياسية،
    // تُحذَف عند الدمج الفعلى) — تسهّل تتبع كل مرشح لمراجعته فى reviews.
    _source_review_id: row.review_id,
    _source_review_note: row.review_note,
    _source_trigger_reason: row.trigger_reason,
    _corrected_answer_text: row.corrected_answer,
  }));

  const output = {
    meta: {
      generated_at: new Date().toISOString(),
      purpose:
        'مرشحون لإضافة Golden Test Set (migrations/031) — مستخرَجون من تصحيحات محامٍ فعلية فى ' +
        'لوحة المراجعة، بانتظار مراجعة يدوية نهائية (تصنيف category/phrasing_style + تأكيد الدقة) ' +
        'قبل الدمج فى golden_test_set الفعلى. لا يُدمَج تلقائياً.',
      total: items.length,
    },
    items,
  };

  console.log(`EXPORT_GOLDEN_CANDIDATES: ${items.length} مرشحاً موجوداً.`);

  const outPath = process.argv[2];
  if (outPath) {
    fs.writeFileSync(outPath, JSON.stringify(output, null, 2), 'utf8');
    console.log(`EXPORT_GOLDEN_CANDIDATES_WRITTEN: ${outPath}`);
  } else {
    console.log(JSON.stringify(output, null, 2));
  }

  await client.end();
}

run().catch((e) => {
  console.error('EXPORT_GOLDEN_CANDIDATES_ERROR', e.message);
  process.exit(1);
});
