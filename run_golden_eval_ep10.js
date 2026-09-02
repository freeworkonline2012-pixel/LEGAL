// run_golden_eval_ep10.js
// EP-10 (2026-08-23) — نسخة من run_golden_eval_live.js لاختبار طبقة
// rerank+تحقق الهجينة (ADR-001) بعد تفعيل ENABLE_RERANK_VERIFICATION=true
// على Railway. تشغيل كامل (99 سؤال) — وليس عيّنة مُركَّزة — لأن هذا التغيير
// يمس مسار كل سؤال مُجاب، لا فئة واحدة فقط.
//
// تهدئة أوسع من الأصل (35 ثانية بدل 21): المسار الجديد قد يستدعي Voyage
// مرتين لكل سؤال (embedQuery للاسترجاع الدلالي + rerank لإعادة الترتيب)
// بدل استدعاء واحد فى المسار القديم. حد Voyage المجاني 3 طلبات/دقيقة؛
// 35 ثانية بين كل سؤال والتالي يبقينا بهامش أمان حتى لو كل سؤال استدعى
// Voyage مرتين.

const API_URL = 'https://backend-production-3faf.up.railway.app/api/questions';
const DELAY_BETWEEN_REQUESTS_MS = 35000;

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

  console.log(`[EP-10] تشغيل كامل: ${items.length} سؤال، ENABLE_RERANK_VERIFICATION=true`);

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

    fs.writeFileSync('golden_eval_ep10_results.json', JSON.stringify(results, null, 2), 'utf8');

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

  console.log('\n===== ملخص نهائي (EP-10، Live API) =====');
  console.log(`إجمالي: ${results.length} (إيجابي: ${positive.length}, سلبي: ${negative.length})`);
  console.log('توزيع النتائج:', JSON.stringify(byOutcome, null, 2));
  console.log('حسب أسلوب الصياغة (إيجابي فقط):', JSON.stringify(byStyle, null, 2));

  fs.writeFileSync(
    'golden_eval_ep10_summary.json',
    JSON.stringify({ byOutcome, byStyle }, null, 2),
    'utf8',
  );
}

main().catch((err) => {
  console.error('فشل غير متوقع:', err);
  process.exit(1);
});
