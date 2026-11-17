#!/usr/bin/env node
/* eslint-disable no-console */
// scripts/eval-contracts.js — أداة القياس الآلية لتدقيق العقود (الجولة 111)
//
// تقارن مخرجات المنصة بالمفتاح المرجعى الذى كتبه المحامى، وتحسب: الاستدعاء، الدقة، الإنذارات الكاذبة، حرفية الاقتباس،
// سلامة الاستشهادات، التجزئة، الأطراف، المبالغ، التغطية، وثبات التشغيلات المتكررة، ثم تعطى قرار البوابة (K1 أو الخدمة).
// لا تعدّل أى بيانات: قراءة فقط من قاعدة البيانات، وتكتب ملفاتها فى مجلد المخرجات وحده.
//
// الأوامر:
//   node scripts/eval-contracts.js template  --out key.json --ref H01 [--set holdout|dev] [--type supply]
//   node scripts/eval-contracts.js validate  --key key.json
//   node scripts/eval-contracts.js freeze    --key key.json            (يجمّد مفتاح Holdout قبل رفع العقد للمطور)
//   node scripts/eval-contracts.js snapshot  --contract <uuid> --ref H01 --out snap-H01-run1.json   (يحتاج DATABASE_URL)
//   node scripts/eval-contracts.js score     --keys <ملف|مجلد> --snapshots <ملف|مجلد>... [--adjudication adj.json]
//                                            [--profile k1|service] [--min-contracts N] [--out مجلد] [--check-index]
//
// رموز الخروج: 0 = Go، 1 = No-Go، 2 = غير مكتمل أو غير صالح، 3 = خطأ استعمال.

const fs = require('fs');
const path = require('path');

// نستعمل مترجم TypeScript الخاص بالمشروع (لا مترجماً عاماً يصادف وجوده بحسب مجلد التشغيل) ونقرأ tsconfig المشروع أياً كان المجلد الحالى.
// TypeScript 6+ يرفض moduleResolution الافتراضى القديم ما لم يُسكَت التحذير؛ الإصدارات الأقدم لا تعرف القيمة فلا نمررها لها.
const tsPath = require.resolve('typescript', { paths: [path.join(__dirname, '..')] });
const tsMajor = Number(String(require(tsPath).version).split('.')[0]);
require('ts-node').register({
  transpileOnly: true,
  compiler: tsPath,
  project: path.join(__dirname, '..', 'tsconfig.json'),
  compilerOptions: { module: 'commonjs', ...(tsMajor >= 6 ? { ignoreDeprecations: '6.0' } : {}) },
});
const E = require('../src/contracts/eval');

const fmtVal = (c) => (c.value === null ? '—' : c.threshold.includes('%') ? `${(c.value * 100).toFixed(1)}%` : String(c.value));

function parseArgs(argv) {
  const out = { _: [] };
  for (let i = 0; i < argv.length; i += 1) {
    const a = argv[i];
    if (a.startsWith('--')) {
      const k = a.slice(2);
      const vals = [];
      while (argv[i + 1] !== undefined && !argv[i + 1].startsWith('--')) {
        vals.push(argv[i + 1]);
        i += 1;
      }
      // قيم متعددة بعد العلامة الواحدة (مثل --snapshots a.json b.json) تُجمَّع فى قائمة؛ بلا قيمة = علامة منطقية
      out[k] = vals.length === 0 ? true : vals.length === 1 ? vals[0] : vals;
    } else out._.push(a);
  }
  return out;
}
const list = (v) => (v === undefined || v === true ? [] : [].concat(v));
const readJson = (p) => JSON.parse(fs.readFileSync(p, 'utf8').replace(/^﻿/, ''));
const die = (msg, code = 3) => {
  console.error(`خطأ: ${msg}`);
  process.exit(code);
};

function expandFiles(inputs) {
  const files = [];
  for (const p of inputs) {
    if (!fs.existsSync(p)) die(`المسار غير موجود: ${p}`);
    if (fs.statSync(p).isDirectory()) {
      for (const f of fs.readdirSync(p).sort()) if (f.endsWith('.json')) files.push(path.join(p, f));
    } else files.push(p);
  }
  return files;
}

function cmdTemplate(a) {
  const ref = a.ref && a.ref !== true ? a.ref : die('--ref مطلوب (رمز مرجعى بلا هوية حقيقية مثل H01)');
  const tpl = {
    schema: 'shield-eval-key/1',
    contract_ref: ref,
    set: a.set === 'dev' ? 'dev' : 'holdout',
    contract_type: a.type && a.type !== true ? a.type : 'supply',
    clauses_expected: 0,
    parties: { first: '', second: '' },
    payment_sums: [],
    issues: [
      { id: 'I1', kind: 'clause', clause: 1, severity: 'عالٍ', topic: 'وصف المشكلة بكلام المحامى', keywords: ['كلمة تميّز المشكلة'] },
      { id: 'I2', kind: 'absent', severity: 'عالٍ', topic: 'بند لازم غير موجود', finding_ids: ['missing:warranty'], keywords: ['ضمان'] },
    ],
    acceptable: [],
  };
  const out = a.out && a.out !== true ? a.out : `key-${ref}.json`;
  if (fs.existsSync(out)) die(`الملف موجود ولن يُستبدل: ${out}`);
  fs.writeFileSync(out, `${JSON.stringify(tpl, null, 2)}\n`);
  console.log(`كُتب القالب: ${out}\nاملأه من قراءتك للعقد وحدك (لا تنسخ من مخرجات المنصة)، ثم: node scripts/eval-contracts.js freeze --key ${out}`);
}

function loadKey(p) {
  const { key, errors } = E.validateKey(readJson(p));
  if (!key) die(`مفتاح غير صالح (${p}):\n- ${errors.join('\n- ')}`);
  return key;
}

function cmdValidate(a) {
  const key = loadKey(a.key);
  const problems = E.holdoutKeyProblems(key);
  console.log(`المفتاح سليم البنية: ${key.contract_ref} (${key.set}) — ${key.issues.length} ملاحظة`);
  if (key.set === 'holdout') console.log(problems.length ? `تنبيه: ${problems.join('؛ ')}` : `مجمَّد بتاريخ ${key.frozen.at}`);
}

function cmdFreeze(a) {
  const p = a.key && a.key !== true ? a.key : die('--key مطلوب');
  const key = loadKey(p);
  if (key.frozen) die('المفتاح مجمَّد مسبقاً. التجميد لا يُعاد: أى تعديل بعده يُبطل صلاحيته كـHoldout.');
  const frozen = E.freezeKey(key);
  fs.writeFileSync(p, `${JSON.stringify(frozen, null, 2)}\n`);
  console.log(`جُمّد ${key.contract_ref} بتاريخ ${frozen.frozen.at}\nالبصمة: ${frozen.frozen.sha256}\nيمكنك الآن رفع العقد للمنصة.`);
}

function pgClient() {
  const { Client } = require('pg');
  let url = process.env.DATABASE_URL || '';
  if (!url) die('DATABASE_URL غير موجود. شغّل الأمر عبر railway run (مع عنوان عام: LOCAL_DB_PUBLIC_HOST) أو مرّر الرابط فى البيئة.');
  const internal = /postgres-pgvector\.railway\.internal:5432/;
  if (internal.test(url) && process.env.LOCAL_DB_PUBLIC_HOST) url = url.replace(internal, process.env.LOCAL_DB_PUBLIC_HOST);
  return new Client({ connectionString: url });
}

async function cmdSnapshot(a) {
  const id = a.contract && a.contract !== true ? a.contract : die('--contract مطلوب');
  const ref = a.ref && a.ref !== true ? a.ref : die('--ref مطلوب');
  const out = a.out && a.out !== true ? a.out : `snap-${ref}-${Date.now()}.json`;
  const c = pgClient();
  await c.connect();
  try {
    await c.query('SET TRANSACTION READ ONLY').catch(() => undefined);
    const contract = (await c.query('SELECT id, created_at, contract_type, extraction_warnings, contract_findings FROM contracts WHERE id = $1', [id])).rows[0];
    if (!contract) die(`العقد غير موجود: ${id}`);
    const clauses = (await c.query('SELECT clause_index, clause_label, clause_title, clause_text, assessment_status, assessment_reasoning, matched_articles, risk_level, rule_findings, verification FROM contract_clauses WHERE contract_id = $1 ORDER BY clause_index', [id])).rows;
    const snap = E.snapshotFromDbRows(contract, clauses, ref);
    fs.writeFileSync(out, `${JSON.stringify(snap, null, 2)}\n`);
    console.log(`لقطة: ${out} — ${snap.clauses.length} بنداً، ${snap.contractFindings.length} ملاحظة عقد ككل`);
  } finally {
    await c.end();
  }
}

async function buildIndexChecker(snaps) {
  const triples = new Set();
  for (const s of snaps) for (const cl of s.clauses) for (const m of cl.matchedArticles || []) triples.add(`${m.law_no}/${m.law_year}/${m.article_no}`);
  const c = pgClient();
  await c.connect();
  const have = new Set();
  try {
    for (const t of triples) {
      const [n, y, ar] = t.split('/').map(Number);
      const r = await c.query('SELECT 1 FROM articles a JOIN laws l ON l.id = a.law_id WHERE l.law_no = $1 AND l.law_year = $2 AND a.article_no = $3 LIMIT 1', [n, y, ar]);
      if (r.rowCount > 0) have.add(t);
    }
  } finally {
    await c.end();
  }
  return (n, y, ar) => have.has(`${n}/${y}/${ar}`);
}

async function cmdScore(a) {
  const profile = a.profile === 'service' ? 'service' : 'k1';
  const keyFiles = expandFiles(list(a.keys));
  const snapFiles = expandFiles(list(a.snapshots));
  if (!keyFiles.length) die('--keys مطلوب (ملف أو مجلد)');
  if (!snapFiles.length) die('--snapshots مطلوب (ملف أو مجلد)');
  const keys = new Map(keyFiles.map((f) => { const k = loadKey(f); return [k.contract_ref, k]; }));
  const snaps = snapFiles.map((f) => {
    try {
      return E.normalizeSnapshot(readJson(f));
    } catch (e) {
      return die(`لقطة غير صالحة (${f}): ${e.message}`);
    }
  });
  const adjudication = a.adjudication && a.adjudication !== true ? E.parseAdjudication(readJson(a.adjudication)) : {};
  const isIndexed = a['check-index'] ? await buildIndexChecker(snaps) : undefined;

  const runCount = new Map();
  const rows = [];
  for (const s of snaps) {
    const key = keys.get(s.evalRef);
    if (!key) die(`لا يوجد مفتاح لرمز اللقطة ${s.evalRef}`);
    const idx = runCount.get(s.evalRef) || 0;
    runCount.set(s.evalRef, idx + 1);
    rows.push(E.scoreContract(key, s, { adjudication, isIndexed, runIndex: idx }));
  }
  const missing = [...keys.keys()].filter((k) => !runCount.has(k));
  const agg = E.aggregate(rows);
  const minContracts = a['min-contracts'] && a['min-contracts'] !== true ? Number(a['min-contracts']) : 1;
  const checks = E.evaluateGate(profile, agg, { minContracts });
  // الثبات: يُضاف شرطاً حاكماً متى وُجدت تشغيلات متكررة لعقد واحد (أو عند طلبه صراحة بـ --require-stability)
  const stab = E.stability(rows);
  if (stab.length > 0 || a['require-stability']) {
    const unstable = stab.filter((x) => !x.stable);
    checks.push({
      id: 'stability',
      label: 'ثبات التشغيلات (نفس الملاحظات المؤكدة فى كل تشغيل)',
      value: unstable.length,
      threshold: '0 عقد متذبذب',
      status: stab.length === 0 ? 'unmeasured' : unstable.length === 0 ? 'pass' : 'fail',
      detail: stab.length === 0 ? 'يلزم تشغيلان على الأقل لكل عقد' : undefined,
    });
  }
  const v = E.finalVerdict(checks, rows, agg.pending);
  if (missing.length) v.reasons.push(`مفاتيح بلا لقطة: ${missing.join('، ')}`);
  const result = { profile, generatedAt: new Date().toISOString(), verdict: v.verdict, reasons: v.reasons, checks, aggregate: agg, contracts: rows, stability: stab };

  const outDir = a.out && a.out !== true ? a.out : 'eval-out';
  fs.mkdirSync(outDir, { recursive: true });
  fs.writeFileSync(path.join(outDir, 'result.json'), `${JSON.stringify(result, null, 2)}\n`);
  fs.writeFileSync(path.join(outDir, 'report.md'), E.renderReport(result));
  const tpl = E.pendingTemplate(rows);
  if (Object.keys(tpl).length) fs.writeFileSync(path.join(outDir, 'adjudication-pending.json'), `${JSON.stringify(tpl, null, 2)}\n`);

  console.log(`القرار: ${v.verdict}`);
  for (const c of result.checks) console.log(`  ${c.status === 'pass' ? 'OK  ' : c.status === 'fail' ? 'FAIL' : '??  '} ${c.label}: ${fmtVal(c)} (المطلوب ${c.threshold})`);
  for (const r of v.reasons) console.log(`  - ${r}`);
  console.log(`المخرجات: ${outDir}/report.md , result.json${Object.keys(tpl).length ? ' , adjudication-pending.json (املأ verdict لكل عنصر ثم أعد التشغيل مع --adjudication)' : ''}`);
  process.exit(v.verdict === 'Go' ? 0 : v.verdict === 'No-Go' ? 1 : 2);
}

(async () => {
  const a = parseArgs(process.argv.slice(2));
  const cmd = a._[0];
  try {
    if (cmd === 'template') cmdTemplate(a);
    else if (cmd === 'validate') cmdValidate(a);
    else if (cmd === 'freeze') cmdFreeze(a);
    else if (cmd === 'snapshot') await cmdSnapshot(a);
    else if (cmd === 'score') await cmdScore(a);
    else die('الأمر مطلوب: template | validate | freeze | snapshot | score', 3);
  } catch (e) {
    die(e && e.stack ? e.stack : String(e));
  }
})();
