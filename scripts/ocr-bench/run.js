#!/usr/bin/env node
/* eslint-disable no-console */
// scripts/ocr-bench/run.js — يقيس دقة قراءة الأرقام والنسب فى القراءة الآلية للعقود الممسوحة (الجولة 112).
// 1) python3 scripts/ocr-bench/gen_scans.py <مجلد> [عدد]    يولّد عقوداً ممسوحة اصطناعية (3 مستويات تلف) + truth.json
// 2) node scripts/ocr-bench/run.js <مجلد> [--out result.json]   يمرّرها على OcrService الفعلى (نفس خيارات مسار العقود) ويطبع الدقة
// الأرقام تُطابَق كرموز كاملة (750000، 6%) بعد توحيد الأرقام الهندية والفواصل. لا تخرج أى بيانات من الجهاز.
const fs = require('fs');
const path = require('path');

const [tsMajor] = [Number(String(require('typescript').version).split('.')[0])];
require('ts-node').register({
  transpileOnly: true,
  compiler: require.resolve('typescript', { paths: [path.join(__dirname, '..', '..')] }),
  project: path.join(__dirname, '..', '..', 'tsconfig.json'),
  compilerOptions: { module: 'commonjs', ...(tsMajor >= 6 ? { ignoreDeprecations: '6.0' } : {}) },
});
const { OcrService } = require('../../src/documents/ocr.service');
const { headingLikeScore } = require('../../src/contracts/clause-headings-fuzzy');
const { numericTokens } = require('../../src/documents/ocr-numeric');

async function main() {
  const dir = process.argv[2];
  if (!dir) { console.error('usage: node scripts/ocr-bench/run.js <dir> [--out file] [--levels clean,scan,bad]'); process.exit(3); }
  const outIdx = process.argv.indexOf('--out');
  const lvIdx = process.argv.indexOf('--levels');
  const levels = lvIdx > 0 ? process.argv[lvIdx + 1].split(',') : ['clean', 'scan', 'bad'];
  const truth = JSON.parse(fs.readFileSync(path.join(dir, 'truth.json'), 'utf8'));
  const ocr = new OcrService();
  const rows = [];
  for (const level of levels) {
    for (const name of Object.keys(truth)) {
      const f = path.join(dir, level, `${name}.pdf`);
      if (!fs.existsSync(f)) continue;
      const t0 = Date.now();
      const r = await ocr.recognize(fs.readFileSync(f), 'pdf', { pageScore: headingLikeScore, maxPages: 10 });
      if (r.status !== 'ok') { rows.push({ level, name, status: r.status }); continue; }
      const got = numericTokens(r.text);
      const pool = new Map();
      for (const g of got) pool.set(g, (pool.get(g) || 0) + 1);
      const res = { level, name, ms: Date.now() - t0, numbers: r.numbers || null, styles: {} };
      // الأرقام الغربية والهندية تُقاس على حدة: الهندية لا يقرؤها Tesseract بثقة ولا يُصلَحها هذا المسار (تُعدّ «غير مؤكدة» فقط)
      for (const style of ['western', 'indic']) {
        let hit = 0;
        const missed = [];
        for (const t of truth[name][style]) {
          if ((pool.get(t) || 0) > 0) { pool.set(t, pool.get(t) - 1); hit += 1; } else missed.push(t);
        }
        res.styles[style] = { total: truth[name][style].length, hit, missed };
      }
      res.extra = [...pool.entries()].reduce((a, [, n]) => a + n, 0);
      rows.push(res);
    }
  }
  const agg = {};
  for (const r of rows) {
    if (r.status) continue;
    const a = (agg[r.level] ||= { western: { total: 0, hit: 0 }, indic: { total: 0, hit: 0 }, extra: 0 });
    for (const st of ['western', 'indic']) { a[st].total += r.styles[st].total; a[st].hit += r.styles[st].hit; }
    a.extra += r.extra;
  }
  const pc = (x) => (x.total ? `${(100 * x.hit / x.total).toFixed(1)}% (${x.hit}/${x.total})` : '-');
  for (const [lv, a] of Object.entries(agg)) console.log(`${lv.padEnd(6)} western ${pc(a.western)}   indic ${pc(a.indic)}   stray numeric tokens: ${a.extra}`);
  for (const r of rows) if (!r.status && r.styles.western.missed.length) console.log(`  ${r.level}/${r.name}: western missed ${r.styles.western.missed.join(' ')}`);
  if (outIdx > 0) fs.writeFileSync(process.argv[outIdx + 1], JSON.stringify({ agg, rows }, null, 1));
}
main().catch((e) => { console.error(e); process.exit(1); });
