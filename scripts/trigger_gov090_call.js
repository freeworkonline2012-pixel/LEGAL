// scripts/trigger_gov090_call.js
//
// سكربت تشخيصى مستهدف (2026-09-14) — يستدعى /api/governance/assess مباشرة
// بنص سؤال gov-090 (22/2018 م15) **من داخل Node لا من PowerShell على جهاز
// المستخدم**، لتفادى تماماً أى مخاطرة تحويل/تشويه للنص العربى قد تحدث عبر
// نسخ-لصق أو ترميز الطرفية (وهى مخاطرة حقيقية: محاولة سابقة عبر
// Invoke-RestMethod من PowerShell وصلت فعلاً للخادم لكن بـqHash مختلف تماماً
// (2392ca14) عن الـqHash المتوقَّع لنص gov-090 الدقيق (a04a462a) — أى أن
// النص الذى وصل للخادم لم يكن هو نص gov-090 كما كُتب، رغم عدم وجود أى خطأ
// HTTP ظاهر).
//
// هذا السكربت يطبع الـhash المحسوب محلياً **قبل** الإرسال (يجب أن يطابق
// a04a462a حرفياً) — إثبات قاطع أن النص المُرسَل صحيح 100% قبل أى اعتماد
// على النتيجة، ثم يرسل الطلب الفعلى ويطبع الرد كاملاً.
//
// الاستخدام: railway ssh -s backend -- node scripts/trigger_gov090_call.js

const { createHash } = require('crypto');

const ENDPOINT =
  process.env.GOVERNANCE_ENDPOINT ??
  'https://backend-production-3faf.up.railway.app/api/governance/assess';

// ⚠️ يجب أن يكون مطابقاً حرفياً (byte-for-byte) لنص TARGETS[0].question فى
// check_retrieval_rank.js — هو نفسه نص gov-090 فى Golden Test Set.
const QUESTION =
  'أحد العاملين المنتدبين للأمانة الفنية للجنة رفض تزويد زميل له من إدارة أخرى داخل نفس الجهة الحكومية بأى تفاصيل عن بيانات أو معلومات حصلت عليها اللجنة بشأن أحد الكيانات، لعدم صدور تصريح رسمى بذلك.';

function hashQuestion(text) {
  // مطابق حرفياً لـ GovernanceService.hashQuestion
  return createHash('sha256').update(text).digest('hex').slice(0, 8);
}

async function main() {
  const expectedHash = 'a04a462a';
  const actualHash = hashQuestion(QUESTION);

  console.log(`[trigger] طول النص=${QUESTION.length} حرفاً`);
  console.log(`[trigger] qHash المحسوب محلياً = ${actualHash}`);
  console.log(`[trigger] qHash المتوقَّع (من check_retrieval_rank.js)  = ${expectedHash}`);

  if (actualHash !== expectedHash) {
    console.error(
      '[trigger] ❌ عدم تطابق! النص فى هذا السكربت نفسه غير مطابق لنص gov-090 المرجعى — ' +
        'توقف هنا قبل الإرسال، راجع QUESTION أعلاه يدوياً.',
    );
    process.exit(1);
  }
  console.log('[trigger] ✅ تطابق تام — النص المُرسَل الآن هو نص gov-090 الحرفى بلا أى شك.\n');

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
      `فى سطر [DIAG-SEMANTIC-RAW] لمقارنته بنتيجة check_retrieval_rank.js.`,
  );
}

main().catch((err) => {
  console.error('[trigger] فشل غير متوقَّع:', err);
  process.exit(1);
});
