// check_articles_batch.js
// EP-10 (2026-08-25) — فحص المادتين المتشابهتين وراء g067/g069 (165 مقابل 166،
// قيد التصويت لمالك ≥10% من رأس مال شركة تأمين بدون موافقة الهيئة) وg039
// (139 مقابل 148، العقوبات الإدارية المتدرجة) — بنفس المنهج اللي أثبت صحته مع
// g051: قراءة النص الفعلي من الـAPI مباشرة قبل الحكم هل الخطأ فى النظام أو فى
// Golden Test Set نفسه.
//
// يكتب النتيجة بنفسه مباشرة بترميز UTF-8 عبر fs.writeFileSync — بدون أي
// اعتماد على إعادة توجيه شِل (>)، لتفادي مشكلة PowerShell UTF-16LE نهائياً.
// شغّله مباشرة: node check_articles_batch.js  (بدون أي > بعده)

const fs = require('fs');

const BASE_URL = 'https://backend-production-3faf.up.railway.app/api';
const OUTPUT_FILE = 'articles_batch_output.txt';
const outputLines = [];
function out(line) {
  outputLines.push(line);
  console.log(line);
}

async function fetchArticle(lawId, articleNo) {
  const res = await fetch(`${BASE_URL}/laws/${lawId}/articles/${articleNo}`);
  const status = res.status;
  let body = null;
  try {
    body = await res.json();
  } catch (err) {
    body = { parseError: String(err) };
  }
  return { status, body };
}

async function getLawId(lawNo) {
  const lawsRes = await fetch(`${BASE_URL}/laws`);
  const laws = await lawsRes.json();
  const list = Array.isArray(laws) ? laws : Array.isArray(laws?.items) ? laws.items : [];
  const law = list.find((l) => String(l.law_no ?? l.lawNo) === String(lawNo));
  return law ? { id: law.id, title: law.title ?? law.name ?? '?' } : null;
}

async function main() {
  // g039: قانون 14 (العمل)، المادتان 139 و148 — العقوبات الإدارية المتدرجة
  // g067/g069: قانون 155 (التأمين)، المادتان 165 و166 — قيد التصويت لمالك حصة كبيرة
  const targets = [
    { lawNo: 14, articles: [139, 148] },
    { lawNo: 155, articles: [165, 166] },
  ];

  for (const t of targets) {
    const law = await getLawId(t.lawNo);
    if (!law) {
      out(`\n لم أجد قانون رقم ${t.lawNo} فى /api/laws.`);
      continue;
    }
    out(`\n########## قانون ${t.lawNo} → id=${law.id}, title=${law.title} ##########`);
    for (const articleNo of t.articles) {
      const { status, body } = await fetchArticle(law.id, articleNo);
      out(`\n===== المادة ${articleNo} (قانون ${t.lawNo}) (status=${status}) =====`);
      out(JSON.stringify(body, null, 2));
    }
  }

  fs.writeFileSync(OUTPUT_FILE, outputLines.join('\n'), 'utf8');
  console.log(`\n✅ تمت الكتابة إلى ${OUTPUT_FILE} بترميز UTF-8 مباشرة (بدون إعادة توجيه شِل).`);
}

main().catch((err) => {
  console.error('فشل غير متوقع:', err);
  fs.writeFileSync(OUTPUT_FILE, outputLines.join('\n') + '\n\nفشل غير متوقع: ' + String(err), 'utf8');
  process.exit(1);
});
