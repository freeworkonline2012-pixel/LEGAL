// run_golden_eval_live.js
// EP-06 (2026-08-22) — يشغّل golden_test_set_v1.json ضد الـAPI الحقيقي المنشور
// فعلياً على Railway (POST /api/questions) بعد اكتمال:
//   1. إصلاح FTS (to_tsquery/OR) — a1fb44d
//   2. تعبئة embeddings كاملة للـ522 مادة (522/522 نجاح، فشل: 0)
// هذا اختبار حقيقي end-to-end للمسار الكامل (FTS → semantic fallback →
// توليد DeepSeek) كما يراه أي مستخدم فعلي، وليس إعادة تنفيذ منطق محلي.
//
// تهدئة: Voyage AI لسه على الخطة المجانية (3 طلبات/دقيقة) — المسار الدلالي
// (embedQuery) يُستدعى تلقائياً لأي سؤال لا يكفيه FTS وحده (الأغلبية حسب
// نتائج EP-06 السابقة)، فنحترم نفس حد الـ21 ثانية بين كل سؤال والتالي.

const API_URL = 'https://backend-production-3faf.up.railway.app/api/questions';
const DELAY_BETWEEN_REQUESTS_MS = 21000;

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function askQuestion(question) {
  const res = await fetch(API_URL, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ question }),
  });
  const status = res.status;
  let body = null;
  try {
    body = await res.json();
  } catch (err) {
    body = { parseError: String(err) };
  }
  return { status, body };
}

function classify(item, result) {
  if (result.status !== 201 && result.status !== 200) {
    return 'HTTP_ERROR';
  }
  const { refused, citations } = result.body ?? {};
  const top = Array.isArray(citations) && citations.length > 0 ? citations[0] : null;

  if (item.expected_behavior === 'refuse') {
    return refused ? 'correctly_refused' : 'FALSE_POSITIVE_should_refuse';
  }

  // expected_behavior === 'answer'
  if (!refused && top && top.article_no === item.expected_article_no && top.law_no === item.law_no) {
    return 'correct_answer';
  }
  if (!refused && top) {
    return 'WRONG_CITATION';
  }
  return 'false_refusal';
}

async function main() {
  const fs = require('fs');
  const goldenSet = JSON.parse(fs.readFileSync('golden_test_set_v1.json', 'utf8'));
  const items = goldenSet.items;

  const results = [];
  for (let i = 0; i < items.length; i++) {
    const item = items[i];
    let attempt = null;
    try {
      attempt = await askQuestion(item.question);
    } catch (err) {
      attempt = { status: 0, body: { networkError: String(err) } };
    }
    const outcome = classify(item, attempt);
    const record = {
      id: item.id,
      question: item.question,
      expected_behavior: item.expected_behavior,
      expected_article_no: item.expected_article_no,
      law_no: item.law_no,
      phrasing_style: item.phrasing_style,
      category: item.category,
      http_status: attempt.status,
      confidence: attempt.body?.confidence ?? null,
      refused: attempt.body?.refused ?? null,
      citation_article_no: attempt.body?.citations?.[0]?.article_no ?? null,
      citation_law_no: attempt.body?.citations?.[0]?.law_no ?? null,
      outcome,
    };
    results.push(record);
    console.log(
      `[${i + 1}/${items.length}] ${item.id} (${item.phrasing_style}/${item.category}) → ${outcome} (confidence=${record.confidence}, refused=${record.refused})`,
    );

    fs.writeFileSync('golden_eval_live_results.json', JSON.stringify(results, null, 2), 'utf8');

    if (i < items.length - 1) {
      await sleep(DELAY_BETWEEN_REQUESTS_MS);
    }
  }

  const positive = results.filter((r) => r.expected_behavior === 'answer');
  const negative = results.filter((r) => r.expected_behavior === 'refuse');

  const byOutcome = {};
  for (const r of results) {
    byOutcome[r.outcome] = (byOutcome[r.outcome] || 0) + 1;
  }
  const byStyle = {};
  for (const r of positive) {
    byStyle[r.phrasing_style] = byStyle[r.phrasing_style] || {};
    byStyle[r.phrasing_style][r.outcome] = (byStyle[r.phrasing_style][r.outcome] || 0) + 1;
  }

  const positiveConfidences = positive
    .filter((r) => r.confidence !== null)
    .map((r) => r.confidence)
    .sort((a, b) => a - b);
  const negativeConfidences = negative
    .filter((r) => r.confidence !== null)
    .map((r) => r.confidence)
    .sort((a, b) => b - a);

  console.log('\n===== ملخص نهائي (Live API) =====');
  console.log(`إجمالي: ${results.length} (إيجابي: ${positive.length}, سلبي: ${negative.length})`);
  console.log('توزيع النتائج:', JSON.stringify(byOutcome, null, 2));
  console.log('حسب أسلوب الصياغة (إيجابي فقط):', JSON.stringify(byStyle, null, 2));
  console.log('توزيع الثقة (إيجابي، الأدنى→الأعلى):', JSON.stringify(positiveConfidences.map((n) => Number(n.toFixed(4)))));
  console.log('توزيع الثقة (سلبي/خارج النطاق، الأعلى→الأدنى):', JSON.stringify(negativeConfidences.map((n) => Number(n.toFixed(4)))));

  fs.writeFileSync(
    'golden_eval_live_summary.json',
    JSON.stringify({ byOutcome, byStyle, positiveConfidences, negativeConfidences }, null, 2),
    'utf8',
  );
}

main().catch((err) => {
  console.error('فشل غير متوقع:', err);
  process.exit(1);
});
