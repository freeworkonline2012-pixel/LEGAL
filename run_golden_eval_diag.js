// run_golden_eval_diag.js
// EP-10 (2026-08-24) — 3 أسئلة فقط (g004, g007, g051) لفهم سبب رفض/خطأ
// الاستشهاد فعلياً عبر سجلات Railway (تسجيل تشخيصي مؤقت مضاف فى commit
// d6ff0bf). شغّل هذا السكريبت ثم افحص Railway logs بدل ملف النتائج وحده.

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

async function main() {
  const fs = require('fs');
  const sample = JSON.parse(fs.readFileSync('golden_diag_sample.json', 'utf8'));
  const items = sample.items;

  console.log(`[EP-10 diag] ${items.length} أسئلة تشخيصية`);

  for (let i = 0; i < items.length; i++) {
    const item = items[i];
    let attempt = null;
    try {
      attempt = await askQuestion(item.question);
    } catch (err) {
      attempt = { status: 0, body: { networkError: String(err) } };
    }
    console.log(
      `[${i + 1}/${items.length}] ${item.id}: confidence=${attempt.body?.confidence}, refused=${attempt.body?.refused}, ` +
        `citation=${attempt.body?.citations?.[0]?.law_no}/${attempt.body?.citations?.[0]?.article_no ?? 'none'} (توقعنا ${item.law_no}/${item.expected_article_no})`,
    );

    if (i < items.length - 1) {
      await sleep(DELAY_BETWEEN_REQUESTS_MS);
    }
  }

  console.log('\n[EP-10 diag] خلص. افحص Railway logs الآن (فلتر "EP-10 verify").');
}

main().catch((err) => {
  console.error('فشل غير متوقع:', err);
  process.exit(1);
});
