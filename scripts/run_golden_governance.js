#!/usr/bin/env node
/**
 * تشغيل golden_governance_test_set_v1.json ضد نقطة نهاية حقيقية
 * (POST /api/governance/assess) وقياس دقة فعلية — لا تقديرية.
 *
 * الاستخدام:
 *   GOVERNANCE_API_BASE_URL=https://<production-url> node scripts/run_golden_governance.js
 *   (افتراضياً: http://localhost:3000)
 *
 * ⚠️ هذا السكريبت يستدعى نقطة نهاية HTTP عامة فقط (لا يتعامل مع أى مفتاح
 * API مباشرة — المفتاح، إن وُجد، يبقى فى بيئة الخادم نفسه). كل استدعاء
 * يستهلك استدعاءً حقيقياً لـDeepSeek/Voyage على حساب الخادم المستهدَف —
 * لا تُشغِّله ضد الإنتاج دون وعى بتكلفة 36 استدعاءً وبرصيد الحساب المتاح.
 *
 * التقرير الناتج (JSON + ملخص فى الطرفية) يقيس بُعدين منفصلين لكل بند:
 *   1) تطابق الحكم (verdict) مع proposed_verdict.
 *   2) تطابق الأساس القانونى (نفس law_no/law_year، إن وُجد فى البند)
 *      ضمن قائمة legal_basis المُعادة.
 * بنود "معلومات غير كافية" (law_no=null) تُقاس فقط على تطابق الحكم.
 */

const fs = require('fs');
const path = require('path');

const BASE_URL = process.env.GOVERNANCE_API_BASE_URL || 'http://localhost:3000';
const ENDPOINT = `${BASE_URL.replace(/\/$/, '')}/api/governance/assess`;
const DATASET_PATH = path.join(__dirname, '..', 'golden_governance_test_set_v1.json');
const DELAY_MS = Number(process.env.GOVERNANCE_TEST_DELAY_MS || 1500);

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function callAssess(actionDescription) {
  const res = await fetch(ENDPOINT, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ action_description: actionDescription }),
  });
  const text = await res.text();
  let body;
  try {
    body = JSON.parse(text);
  } catch {
    body = { _raw: text };
  }
  return { status: res.status, body };
}

function legalBasisMatches(item, legalBasis) {
  if (!item.law_no || !item.law_year) return null; // غير قابل للتطبيق (بند insufficient_info)
  if (!Array.isArray(legalBasis)) return false;
  return legalBasis.some(
    (b) => Number(b.law_no) === Number(item.law_no) && Number(b.law_year) === Number(item.law_year),
  );
}

async function main() {
  const dataset = JSON.parse(fs.readFileSync(DATASET_PATH, 'utf8'));
  const items = dataset.items;

  console.log(`[golden-governance] ${items.length} بند — الهدف: ${ENDPOINT}`);
  console.log(`[golden-governance] حالة المجموعة: ${dataset.meta.status} — راجع التقارير المرافقة قبل اعتماد أى رقم دقة كنهائى.\n`);

  const results = [];
  let verdictMatches = 0;
  let basisMatches = 0;
  let basisApplicable = 0;
  let httpErrors = 0;

  for (const item of items) {
    let outcome;
    try {
      const { status, body } = await callAssess(item.action_description);
      if (status !== 201 && status !== 200) {
        httpErrors += 1;
        outcome = { id: item.id, http_status: status, error: true, body };
      } else {
        const verdictMatch = body.verdict === item.proposed_verdict;
        const basisMatch = legalBasisMatches(item, body.legal_basis);
        if (verdictMatch) verdictMatches += 1;
        if (basisMatch !== null) {
          basisApplicable += 1;
          if (basisMatch) basisMatches += 1;
        }
        outcome = {
          id: item.id,
          expected_verdict: item.proposed_verdict,
          actual_verdict: body.verdict,
          verdict_match: verdictMatch,
          expected_law: item.law_no ? `${item.law_no}/${item.law_year}` : null,
          actual_legal_basis: (body.legal_basis || []).map((b) => `${b.law_no}/${b.law_year} م${b.article_no}`),
          basis_match: basisMatch,
          confidence: body.confidence,
        };
      }
    } catch (err) {
      httpErrors += 1;
      outcome = { id: item.id, error: true, message: String(err) };
    }
    results.push(outcome);
    process.stdout.write(
      outcome.error
        ? `  ${item.id}: ❌ خطأ HTTP/شبكة\n`
        : `  ${item.id}: ${outcome.verdict_match ? '✅' : '❌'} حكم (${outcome.actual_verdict}) ` +
            `${outcome.basis_match === null ? '' : outcome.basis_match ? '✅ أساس' : '❌ أساس'}\n`,
    );
    await sleep(DELAY_MS);
  }

  const total = items.length;
  const answered = total - httpErrors;
  const summary = {
    generated_at: new Date().toISOString(),
    endpoint: ENDPOINT,
    dataset_status: dataset.meta.status,
    total_items: total,
    http_errors: httpErrors,
    verdict_accuracy: answered ? +(verdictMatches / answered).toFixed(4) : null,
    legal_basis_accuracy_when_applicable: basisApplicable ? +(basisMatches / basisApplicable).toFixed(4) : null,
    verdict_matches: verdictMatches,
    basis_matches: basisMatches,
    basis_applicable_count: basisApplicable,
  };

  console.log('\n=== الملخص ===');
  console.log(JSON.stringify(summary, null, 2));

  const outPath = path.join(__dirname, '..', `golden_governance_run_report_${Date.now()}.json`);
  fs.writeFileSync(outPath, JSON.stringify({ summary, results }, null, 2), 'utf8');
  console.log(`\n[golden-governance] التقرير الكامل: ${outPath}`);
}

main().catch((err) => {
  console.error('[golden-governance] فشل غير متوقع:', err);
  process.exit(1);
});
