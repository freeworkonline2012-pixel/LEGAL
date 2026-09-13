#!/usr/bin/env node
/**
 * سكربت تشخيصى مؤقت (2026-09-13 — يُحذف بعد إغلاق التحقيق فى تراجع دقة
 * الحوكمة بعد backfill-embeddings.js، راجع تقرير-تراجع-غير-متوقع-فى-دقة-
 * الحوكمة-بعد-إصلاح-فجوة-embeddings-2026-09-13 فى توثيق المشروع).
 *
 * يستدعى فقط الـ21 بنداً التى تراجعت (لا الـ246 كاملة — توفيراً للوقت
 * والتكلفة) ضد نقطة النهاية الحية، لتحفيز سطر التسجيل التشخيصى الجديد
 * `[DIAG-RERANK-FULL]` فى governance.service.ts. لا يحتاج قراءة مخرجاته —
 * الهدف فقط توليد السجلات، وستُقرأ من Railway مباشرة بعد التشغيل.
 *
 * الاستخدام:
 *   GOVERNANCE_API_BASE_URL=https://<production-url> node scripts/run_diag_sample.js
 */

const fs = require('fs');
const path = require('path');

const BASE_URL = process.env.GOVERNANCE_API_BASE_URL || 'http://localhost:3000';
const ENDPOINT = `${BASE_URL.replace(/\/$/, '')}/api/governance/assess`;
const DATASET_PATH = path.join(__dirname, '..', 'golden_governance_test_set_v1.json');
const DELAY_MS = Number(process.env.GOVERNANCE_TEST_DELAY_MS || 1500);

const REGRESSED_IDS = [
  'gov-011', 'gov-025', 'gov-031', 'gov-047', 'gov-065', 'gov-090', 'gov-099',
  'gov-116', 'gov-123', 'gov-150', 'gov-157', 'gov-158', 'gov-168', 'gov-173',
  'gov-182', 'gov-185', 'gov-187', 'gov-205', 'gov-214', 'gov-216', 'gov-231',
];

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  const dataset = JSON.parse(fs.readFileSync(DATASET_PATH, 'utf8'));
  const byId = Object.fromEntries(dataset.items.map((it) => [it.id, it]));
  const items = REGRESSED_IDS.map((id) => byId[id]).filter(Boolean);

  console.log(`[diag-sample] سيُستدعى ${items.length} بنداً ضد ${ENDPOINT}`);

  for (const item of items) {
    try {
      const res = await fetch(ENDPOINT, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action_description: item.action_description }),
      });
      const body = await res.json().catch(() => ({}));
      console.log(`  ${item.id}: HTTP ${res.status} → ${body.verdict ?? 'n/a'}`);
    } catch (err) {
      console.log(`  ${item.id}: خطأ شبكة — ${String(err)}`);
    }
    await sleep(DELAY_MS);
  }

  console.log('[diag-sample] انتهى — السجلات التشخيصية جاهزة على Railway الآن.');
}

main().catch((err) => {
  console.error('[diag-sample] فشل غير متوقَّع:', err);
  process.exit(1);
});
