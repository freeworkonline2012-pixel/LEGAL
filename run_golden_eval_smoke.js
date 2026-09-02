// run_golden_eval_smoke.js
// EP-10 (2026-08-24) — عيّنة مُركَّزة (10 أسئلة) قبل أي تشغيل كامل، بعد إصلاح
// عطل max_tokens وتصحيح سياسة fail-open→fail-closed. الهدف: تأكيد أن طبقة
// التحقق شغّالة فعلياً (بلا فشل تحليل صامت) قبل تعريض كل الـ99 سؤال للمخاطرة.
//
// العيّنة: g039 وg051 (استشهادان خاطئان معروفان — الهدف الأساسي لهذه الطبقة)،
// g089 (التسريب الكاذب المعروف من EP-08 — أهم فحص أمان)، 3 أسئلة فصحى كاملة
// سهلة (تأكيد عدم كسر شيء يعمل بالفعل)، 4 أسئلة سلبية إضافية (فحص أمان أوسع).

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
  const sample = JSON.parse(fs.readFileSync('golden_smoke_sample.json', 'utf8'));
  const items = sample.items;

  console.log(`[EP-10 smoke] عيّنة مُركَّزة: ${items.length} أسئلة`);

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
      http_status: attempt.status,
      confidence: attempt.body?.confidence ?? null,
      refused: attempt.body?.refused ?? null,
      citation_article_no: attempt.body?.citations?.[0]?.article_no ?? null,
      citation_law_no: attempt.body?.citations?.[0]?.law_no ?? null,
      outcome,
    };
    results.push(record);
    console.log(
      `[${i + 1}/${items.length}] ${item.id} → ${outcome} (confidence=${record.confidence}, refused=${record.refused}, citation=${record.citation_law_no}/${record.citation_article_no})`,
    );

    fs.writeFileSync('golden_eval_smoke_results.json', JSON.stringify(results, null, 2), 'utf8');

    if (i < items.length - 1) {
      await sleep(DELAY_BETWEEN_REQUESTS_MS);
    }
  }

  console.log('\n===== ملخص العيّنة المُركَّزة =====');
  results.forEach((r) => console.log(`${r.id}: ${r.outcome}`));
}

main().catch((err) => {
  console.error('فشل غير متوقع:', err);
  process.exit(1);
});
