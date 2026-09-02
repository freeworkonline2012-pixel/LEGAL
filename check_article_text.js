// check_article_text.js
// EP-10 (2026-08-25) — بعد التصميم المقارن الجديد (selectBestCandidate)،
// g051 لسه بتختار 155/13 بدل 155/1 المتوقَّعة، حتى مع رؤية الاتنين معاً.
// هذا السكريبت يجيب النص الفعلي لأول اصدار (version) لكل من المادتين
// مباشرة من الـAPI العام، عشان نتأكد بأنفسنا هل 155/1 فعلاً أدق من 155/13
// لسؤال "الالتزام الذى يقع على شركة التأمين تجاه المستفيد عند تحقق الخطر"
// — أو إن حكم DeepSeek (المتكرر مرتين بتصميمين مختلفين) له وجه صحيح.

const fs = require('fs');

const BASE_URL = 'https://backend-production-3faf.up.railway.app/api';

// EP-10 (2026-08-25) — ملاحظة تشغيل مهمة:
// شغّل هذا السكريبت مباشرة بدون أي إعادة توجيه شِل (>) — مثل:
//   node check_article_text.js
// وليس:
//   node check_article_text.js > article_check_output.txt   ← ممنوع فى PowerShell
// السبب: PowerShell يكتب الملف الناتج عن > بترميز UTF-16LE مع BOM افتراضياً،
// فيتحوّل كل النص العربى لرموز غير مقروءة (mojibake) بالكامل. لتفادى هذا
// نهائياً، السكريبت هنا يكتب الملف بنفسه مباشرة عبر fs.writeFileSync بترميز
// utf8 صريح — لا حاجة لأي إعادة توجيه شِل إطلاقاً.
const OUTPUT_FILE = 'article_check_output.txt';
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

async function main() {
  // law_no فى بيانات golden set هو 155، لكن معرّف القانون (lawId) فى الـAPI
  // قد يكون UUID مختلف عن رقم القانون النصي — لو فشل الطلب بـ404، جرّب أولاً
  // GET /api/laws للحصول على الـid الصحيح لقانون رقم 155.
  const lawsRes = await fetch(`${BASE_URL}/laws`);
  const laws = await lawsRes.json();
  const law155 = Array.isArray(laws)
    ? laws.find((l) => String(l.law_no ?? l.lawNo) === '155')
    : Array.isArray(laws?.items)
      ? laws.items.find((l) => String(l.law_no ?? l.lawNo) === '155')
      : null;

  if (!law155) {
    out('لم أجد قانون رقم 155 فى /api/laws. الرد الخام:');
    out(JSON.stringify(laws, null, 2).slice(0, 2000));
    fs.writeFileSync(OUTPUT_FILE, outputLines.join('\n'), 'utf8');
    return;
  }

  const lawId = law155.id;
  out(`قانون 155 → id=${lawId}, title=${law155.title ?? law155.name ?? '?'}`);

  for (const articleNo of [1, 13]) {
    const { status, body } = await fetchArticle(lawId, articleNo);
    out(`\n===== المادة ${articleNo} (status=${status}) =====`);
    out(JSON.stringify(body, null, 2));
  }

  fs.writeFileSync(OUTPUT_FILE, outputLines.join('\n'), 'utf8');
  console.log(`\n✅ تمت الكتابة إلى ${OUTPUT_FILE} بترميز UTF-8 مباشرة (بدون إعادة توجيه شِل).`);
}

main().catch((err) => {
  console.error('فشل غير متوقع:', err);
  fs.writeFileSync(OUTPUT_FILE, outputLines.join('\n') + '\n\nفشل غير متوقع: ' + String(err), 'utf8');
  process.exit(1);
});
