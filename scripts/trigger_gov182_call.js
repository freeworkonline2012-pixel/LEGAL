// scripts/trigger_gov182_call.js
//
// سكربت تشخيصى مستهدف (2026-09-18) — على نمط trigger_gov090_call.js تماماً،
// لكن لـgov-182 (قرار 2036/2026، المادة 2). الغرض: بعد إصلاح gov-090
// (رفع hnsw.ef_search إلى 200، مؤكَّد حياً)، هل يدخل الأساس القانونى
// الصحيح لـgov-182 الآن فعلاً مجمع الـrerank الحى فى الإنتاج (لا فقط
// الرتبة الدلالية المحسوبة يدوياً بدون LIMIT فى check_retrieval_rank.js)؟
// هذا هو "الفحص الرخيص" المطلوب قبل أى قرار بتعديل نص embedding — إن كان
// gov-182 يدخل المجمع الآن بفضل إصلاح ef_search نفسه (نفس آلية gov-090)،
// فلا حاجة لأى تدخّل معمارى إضافى؛ وإن ظل غائباً، فهذا دليل أن مشكلته
// مختلفة جذرياً عن gov-090 (مثلاً ضعف تمثيل دلالى حقيقى للنص القصير، لا
// مجرد قيد الفهرس التقريبى) وتحتاج تشخيصاً منفصلاً بدلاً من افتراض نفس
// الحل.
//
// ⚠️ ملحوظة تصحيح مهمة (2026-09-18): نص السؤال هنا مأخوذ حرفياً (byte-for-
// byte) من action_description الفعلى لـgov-182 فى
// golden_governance_test_set_v1.json — وهو **أطول** من النص الذى كان
// مستخدَماً سابقاً فى check_retrieval_rank.js (كان ينقصه الجملة الختامية
// "وأتمت التوفيق قبل انتهاء المهلة."، مما أعطى qHash مختلفاً تماماً). تم
// تصحيح ذلك الملف بالتوازى مع كتابة هذا السكربت. استخدم النص أدناه فقط
// كمرجع للـhash الصحيح — لا نصاً آخر من أى مصدر سابق.
//
// الاستخدام: railway ssh -s backend -- node scripts/trigger_gov182_call.js

const { createHash } = require('crypto');

const ENDPOINT =
  process.env.GOVERNANCE_ENDPOINT ??
  'https://backend-production-3faf.up.railway.app/api/governance/assess';

// مطابق حرفياً لـ gov-182.action_description فى golden_governance_test_set_v1.json
const QUESTION =
  'خلال مهلة الثلاثة أشهر الممنوحة من تاريخ العمل بقرار 2036/2026، عدّلت شركة تأمين على الحياة سياسة الاكتتاب لديها لتشمل الاستعلام عن القوائم السلبية والاستعلام الائتمانى والتحقق من ملكية رقم الهاتف المحمول، وأتمت التوفيق قبل انتهاء المهلة.';

function hashQuestion(text) {
  // مطابق حرفياً لـ GovernanceService.hashQuestion
  return createHash('sha256').update(text).digest('hex').slice(0, 8);
}

async function main() {
  // محسوب محلياً بعد تثبيت النص الصحيح أعلاه (راجع تعليق التصحيح) —
  // لو تغيّر هذا الرقم عن التوقع المذكور فى تقرير التسليم، فالنص هنا نفسه
  // تعرّض لتحويل غير متوقَّع (ترميز، نسخ/لصق) ويجب التوقف قبل الإرسال.
  const expectedHash = 'ff7f15d3';
  const actualHash = hashQuestion(QUESTION);

  console.log(`[trigger] طول النص=${QUESTION.length} حرفاً`);
  console.log(`[trigger] qHash المحسوب محلياً = ${actualHash}`);
  console.log(`[trigger] qHash المتوقَّع (من golden_governance_test_set_v1.json)  = ${expectedHash}`);

  if (actualHash !== expectedHash) {
    console.error(
      '[trigger] ❌ عدم تطابق! النص فى هذا السكربت نفسه غير مطابق لنص gov-182 المرجعى — ' +
        'توقف هنا قبل الإرسال، راجع QUESTION أعلاه يدوياً.',
    );
    process.exit(1);
  }
  console.log('[trigger] ✅ تطابق تام — النص المُرسَل الآن هو نص gov-182 الحرفى بلا أى شك.\n');

  console.log(`[trigger] إرسال POST إلى ${ENDPOINT} ...`);
  const res = await fetch(ENDPOINT, {
    method: 'POST',
    headers: { 'content-type': 'application/json; charset=utf-8' },
    body: JSON.stringify({ action_description: QUESTION }),
  });

  const bodyText = await res.text();
  console.log(`[trigger] HTTP ${res.status}`);
  console.log(`[trigger] الرد:\n${bodyText}`);

  if (!res.ok) {
    process.exit(1);
  }
  console.log(
    `\n[trigger] انتهى بنجاح — ابحث الآن فى سجلات Railway عن qHash=${actualHash} ` +
      `فى سطر [DIAG-RERANK-FULL] (وكذلك [DIAG-SEMANTIC-RAW] إن وُجد) لمعرفة هل دخلت ` +
      `المادة 2 من قرار 2036/2026 مجمع الترشيح الفعلى بعد إصلاح hnsw.ef_search=200، ` +
      `أم لا تزال غائبة رغم الإصلاح — الحالتان تحسمان الخطوة التالية.`,
  );
}

main().catch((err) => {
  console.error('[trigger] فشل غير متوقَّع:', err);
  process.exit(1);
});
