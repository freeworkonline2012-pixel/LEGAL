// scripts/diagnostic_sample_json_parse_rate.js
//
// Cheap diagnostic script (2026-09-19, English comments/messages only on
// purpose -- see the encoding lessons documented in
// merge-golden-test-set-402.ps1) to measure the real "unparseable_json"
// failure rate of the majority-vote consensus mechanism (3 DeepSeek
// samples per /api/governance/assess call) BEFORE spending the full
// ~1206-call remeasurement on all 402 Golden Test Set items.
//
// Context: a manual trigger for gov-182 showed 5 out of 6 majority-vote
// samples across two attempts failing with "unparseable_json" in the
// Railway deploy logs. That item's cited article also happened to be an
// unusually long, artifact-heavy legal text (page-break characters,
// running headers embedded mid-article), which COULD explain the failure
// on its own rather than being representative of the whole dataset. This
// script sends a small, deliberately diverse sample (13 items spanning
// all 5 categories and multiple verdicts, chosen from the merged 402-item
// set, explicitly excluding gov-182 itself) so the failure rate measured
// here reflects normal conditions, not that one already-diagnosed edge
// case.
//
// This script does NOT read the failure rate itself -- the
// "unparseable_json" detail and the "X/3 عينات صالحة" consensus line are
// only written to Railway's deploy logs, not returned in the HTTP
// response. After running this script, the qHash values it prints below
// must be looked up in Railway deploy logs (grep for each qHash, or for
// "consensus:" lines in the time window this script ran) to get the
// actual valid-sample count per item.
//
// Usage: railway ssh -s backend -- node scripts/diagnostic_sample_json_parse_rate.js

const ENDPOINT =
  process.env.GOVERNANCE_ENDPOINT ??
  'https://backend-production-3faf.up.railway.app/api/governance/assess';

const { createHash } = require('crypto');

function hashQuestion(text) {
  return createHash('sha256').update(text).digest('hex').slice(0, 8);
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

const ITEMS = [
  {
    "id": "gov-008",
    "question": "شركة تأمين أرسلت لعميلها إيصال سداد قسط تأمين لا يتضمن قيمة أو نسبة العمولة الأساسية المستحقة لوسيط التأمين الذى تعامل معه العميل.",
    "expectedHash": "8c70f012"
  },
  {
    "id": "gov-077",
    "question": "شركة تأمين متناهى الصغر قدّمت دراسة جدوى لتعديل ترخيصها تناولت استراتيجية الاستثمار والرقابة الداخلية بالتفصيل، لكنها لم تتطرق إطلاقاً لأوجه الحوكمة.",
    "expectedHash": "c01240b8"
  },
  {
    "id": "gov-183",
    "question": "شركة تأمين عيّنت مسئولاً تنفيذياً جديداً عن إدارة الاستثمار وبدأ فى مباشرة مهامه فعلياً فور اعتماد مجلس إدارة الشركة لتعيينه، قبل صدور موافقة الهيئة على شغله للوظيفة.",
    "expectedHash": "c6e7d742"
  },
  {
    "id": "gov-216",
    "question": "تضمّن النظام الأساسى المقدَّم لتسجيل صندوق تأمين خاص قواعد وإجراءات واضحة لتعيين مراقبى الحسابات وتقدير مكافآتهم.",
    "expectedHash": "6344e10b"
  },
  {
    "id": "gov-283",
    "question": "شكّلت شركة تمويل عقارى مجلس إدارتها الجديد بحيث ضم عضواً واحدة من النساء على الأقل ضمن تشكيلته، ولم تكن الشركة من ضمن الشركات المهنية المستثناة من هذا الشرط بقرار من رئيس الهيئة.",
    "expectedHash": "0a3fe7eb"
  },
  {
    "id": "gov-315",
    "question": "أنشأت شركة تأمين إدارة مستقلة لإدارة المخاطر يتبع رئيسها فنياً للجنة المخاطر المنبثقة عن مجلس الإدارة، واعتمد مجلس الإدارة استراتيجية واضحة لتحديد المخاطر التى قد تواجه الشركة، وتقوم الإدارة بتزويد الإدارة العليا ولجنة المخاطر بتقارير دورية ربع سنوية عن مدى الالتزام بحدود المخاطر المحددة.",
    "expectedHash": "4a5a0436"
  },
  {
    "id": "gov-005",
    "question": "شركة تعمل فى نشاط التمويل العقارى، مجلس إدارتها مكوّن من 9 أعضاء وتضم امرأة واحدة فقط (11% تقريباً)، ولا تخطط لزيادة هذا العدد.",
    "expectedHash": "2fca968a"
  },
  {
    "id": "gov-147",
    "question": "شركة تمويل مشروعات متناهية الصغر تعمل حصرياً فى النشاط المرخص لها به، ولا تتلقى أى ودائع من العملاء ولا تمارس أى نشاط آخر خارج نطاق ترخيصها.",
    "expectedHash": "da790e96"
  },
  {
    "id": "gov-037",
    "question": "شركة عاملة فى إصدار صكوك عيّنت عضواً فى لجنة الرقابة الشرعية المركزية كان مساهماً رئيسياً فى شركة تمويل غير مصرفى قبل 8 أشهر من تعيينه، ولم توافِ الهيئة بأى إفصاح عن هذا التعارض المحتمل.",
    "expectedHash": "48ec6a6e"
  },
  {
    "id": "gov-128",
    "question": "شركة مرخص لها بمزاولة نشاطى السمسرة وتكوين وإدارة محافظ الأوراق المالية معاً، أفردت لكل نشاط إدارة مستقلة تماماً مع فصل كامل بين الإدارتين لتجنب أى تعارض مصالح بينهما.",
    "expectedHash": "e10af113"
  },
  {
    "id": "gov-001",
    "question": "بنك مصرى اكتشف عملية تحويل مالية مشبوهة من أحد عملائه تتضمن مبالغ كبيرة غير متناسبة مع نشاطه المعتاد، فقرر البنك تجاهل الأمر وعدم اتخاذ أى إجراء لأن العميل قديم وموثوق.",
    "expectedHash": "8a0931b5"
  },
  {
    "id": "gov-102",
    "question": "قامت شركة تمويل عقارى بإعداد التقرير الإحصائى نصف السنوى الخاص بعدد حالات الاشتباه المحالة للوحدة، وأرسلته إلى الهيئة خلال 5 أيام من تاريخ انتهاء الفترة المعنية بالتقرير.",
    "expectedHash": "261e6461"
  },
  {
    "id": "gov-034",
    "question": "شركة ناشئة تخطط لدخول قطاع التمويل غير المصرفى فى مصر وتسأل: 'هل خطتنا العامة متوافقة مع متطلبات الحوكمة؟' دون ذكر أى تفاصيل عن نوع النشاط المحدد، أو هيكل الملكية، أو تشكيل مجلس الإدارة، أو أى إجراء فعلى اتخذته.",
    "expectedHash": "6450faab"
  }
];

async function main() {
  console.log(`[diag] Sending ${ITEMS.length} diagnostic sample items, one at a time, with a pause between each so each one is easy to find in the logs by qHash and timestamp.\n`);

  const results = [];

  for (const item of ITEMS) {
    const actualHash = hashQuestion(item.question);
    if (actualHash !== item.expectedHash) {
      console.error(`[diag] MISMATCH for ${item.id}: expected ${item.expectedHash}, got ${actualHash}. Skipping this item -- do not trust its result.`);
      results.push({ id: item.id, qHash: actualHash, httpStatus: null, skipped: true });
      continue;
    }

    console.log(`[diag] ${item.id}: qHash=${actualHash} -- sending...`);
    const startedAt = new Date().toISOString();

    try {
      const res = await fetch(ENDPOINT, {
        method: 'POST',
        headers: { 'content-type': 'application/json; charset=utf-8' },
        body: JSON.stringify({ action_description: item.question }),
      });
      const bodyText = await res.text();
      let topLevelStatus = null;
      try {
        const parsed = JSON.parse(bodyText);
        topLevelStatus = parsed.verdict ? 'verdict_present' : (parsed.status ?? 'unknown_shape');
      } catch {
        topLevelStatus = 'http_body_not_json';
      }
      console.log(`[diag] ${item.id}: qHash=${actualHash} startedAt=${startedAt} HTTP ${res.status} topLevelStatus=${topLevelStatus}`);
      results.push({ id: item.id, qHash: actualHash, startedAt, httpStatus: res.status, topLevelStatus });
    } catch (err) {
      console.error(`[diag] ${item.id}: qHash=${actualHash} REQUEST FAILED: ${err.message}`);
      results.push({ id: item.id, qHash: actualHash, startedAt, error: String(err.message) });
    }

    // Space calls out so Railway log timestamps do not overlap between items.
    await sleep(3000);
  }

  console.log('\n[diag] Done sending all items. Summary (id -> qHash -> HTTP result):');
  for (const r of results) {
    console.log(`  ${r.id}: qHash=${r.qHash} httpStatus=${r.httpStatus ?? 'n/a'} topLevelStatus=${r.topLevelStatus ?? r.error ?? (r.skipped ? 'SKIPPED (hash mismatch)' : 'n/a')}`);
  }
  console.log('\n[diag] Next step: for each qHash above, find the "governance consensus: qHash=<hash> ... -> X/3 عينات صالحة" line in Railway deploy logs covering the time window this script ran, and record X/3 for each item. That gives the real unparseable_json failure rate across a diverse, representative sample.');
}

main().catch((err) => {
  console.error('[diag] Unexpected failure:', err);
  process.exit(1);
});
