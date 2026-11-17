import { fmtPct, type Aggregate, type FinalVerdict, type GateCheck, type StabilityReport } from './aggregate';
import type { Adjudication, ContractMetrics } from './types';

export interface EvalResult {
  profile: 'k1' | 'service';
  generatedAt: string;
  verdict: FinalVerdict;
  reasons: string[];
  checks: GateCheck[];
  aggregate: Aggregate;
  contracts: ContractMetrics[];
  stability: StabilityReport[];
}

const ICON: Record<string, string> = { pass: 'نجح', fail: 'رسب', unmeasured: 'لم يُقَس' };
const OUT: Record<string, string> = { confirmed: 'مؤكدة', candidate: 'مرشّحة فقط', missed: 'فاتت' };
const cell = (s: string | number | null): string => String(s ?? '—').replace(/\|/g, '/').replace(/\s+/g, ' ');
const val = (c: GateCheck): string => (c.value === null ? '—' : !c.threshold.includes('%') ? String(c.value) : fmtPct(c.value));

/** قالب حكم المحامى على العناصر المؤكدة خارج المفتاح (تُملأ القيم null ثم يُعاد تمريره للأداة). */
export function pendingTemplate(rows: ContractMetrics[]): Record<string, { title: string; severity: string; clauses: string[]; summary: string; verdict: null }> {
  const out: Record<string, { title: string; severity: string; clauses: string[]; summary: string; verdict: null }> = {};
  for (const m of rows) for (const p of m.pendingItems) out[`${m.ref}|${p.fp}`] = { title: p.title, severity: p.severity, clauses: p.clauseLabels, summary: p.summary, verdict: null };
  return out;
}

/** يحوّل قالب الأحكام المملوء إلى خريطة أحكام صالحة (يتجاهل null والقيم الخاطئة). */
export function parseAdjudication(raw: unknown): Adjudication {
  const out: Adjudication = {};
  if (!raw || typeof raw !== 'object') return out;
  for (const [k, v] of Object.entries(raw as Record<string, unknown>)) {
    const verdict = typeof v === 'string' ? v : (v as { verdict?: unknown } | null)?.verdict;
    if (verdict === 'true_issue' || verdict === 'acceptable' || verdict === 'false_alarm') out[k] = verdict;
  }
  return out;
}

export function renderReport(r: EvalResult): string {
  const L: string[] = [];
  const a = r.aggregate;
  L.push(`# تقرير القياس الآلى — بوابة ${r.profile === 'k1' ? 'K1 (قبول Holdout)' : 'الخدمة (Go)'}`);
  L.push('');
  L.push(`التاريخ: ${r.generatedAt} · عقود: ${a.contracts} · تشغيلات: ${a.runs}`);
  L.push('');
  L.push(`## القرار: ${r.verdict}`);
  if (r.reasons.length) {
    L.push('');
    for (const x of r.reasons) L.push(`- ${x}`);
  }
  L.push('');
  L.push('## البوابات');
  L.push('');
  L.push('| البند | القيمة | العتبة | النتيجة |');
  L.push('|---|---|---|---|');
  for (const c of r.checks) L.push(`| ${cell(c.label)} | ${val(c)} | ${c.threshold} | ${ICON[c.status]}${c.detail ? ` (${cell(c.detail)})` : ''} |`);
  L.push('');
  L.push('## الأرقام الكلية');
  L.push('');
  L.push(`- ملاحظات المفتاح: ${a.issues}؛ ظهرت مؤكدة: ${a.foundConfirmed}؛ ظهرت مرشّحة فقط: ${a.foundCandidateOnly}؛ فاتت: ${a.issues - a.foundConfirmed - a.foundCandidateOnly}`);
  L.push(`- الاستدعاء: ${fmtPct(a.recall)} (بعد احتساب المرشّحات: ${fmtPct(a.recallWithCandidates)}) · عالٍ/حرج: ${fmtPct(a.criticalHighRecall)}`);
  L.push(`- ملاحظات مؤكدة: ${a.confirmedItems}؛ صحيحة: ${a.truePositiveItems}؛ إنذار كاذب محكوم: ${a.falseAlarms}؛ تنتظر حكم المحامى: ${a.pending}`);
  L.push(`- الدقة (أسوأ حال): ${fmtPct(a.precision)} · معدل الإنذار الكاذب: ${fmtPct(a.falseAlarmRate)}`);
  L.push(`- اقتباسات مفحوصة: ${a.quotesChecked}؛ غير حرفية: ${a.quotesMissing}`);
  L.push(`- استشهادات قانونية فريدة: ${a.citationsChecked}؛ غير مفهرسة: ${a.citationsNotIndexed === null ? 'لم يُقَس' : a.citationsNotIndexed}؛ مشوّهة البنية: ${a.citationsMalformed}`);
  L.push(`- التجزئة (أدنى عقد): ${fmtPct(a.segmentationMin)} · التغطية (متوسط): ${fmtPct(a.coverageAvg)}`);
  L.push(`- الأطراف: ${a.partiesOk}/${a.partiesChecked} · المبالغ: ${a.sumsFound}/${a.sumsChecked}`);

  for (const m of r.contracts) {
    L.push('');
    L.push(`## ${m.ref} (${m.set === 'holdout' ? 'Holdout' : 'Dev'} · ${m.contractType} · تشغيل ${m.runIndex + 1})`);
    if (!m.valid) L.push(`\n**غير صالح للقياس:** ${m.invalidReasons.join('؛ ')}`);
    L.push('');
    L.push('| الملاحظة | الدرجة | الحالة | المطابقة |');
    L.push('|---|---|---|---|');
    for (const i of m.issues) L.push(`| ${cell(i.id)} — ${cell(i.topic)} | ${i.severity} | ${OUT[i.outcome]} | ${cell(i.matchedFp)} |`);
    L.push('');
    L.push(`مؤكدة: ${m.confirmedItems} (صحيحة ${m.truePositiveItems}، مقبولة ${m.acceptableItems}، كاذبة ${m.falseAlarms}، معلّقة ${m.pendingItems.length}) · مرشّحات: ${m.candidateItems} (تطابق المفتاح: ${m.candidateMatchedKey}) · مستبعدة: ${m.dismissedItems}`);
    if (m.pendingItems.length) {
      L.push('');
      L.push('تنتظر حكم المحامى (خارج المفتاح):');
      for (const p of m.pendingItems) L.push(`- ${p.fp} — ${cell(p.title)} (${p.severity}) ${p.clauseLabels.join('، ')}`);
    }
    if (m.quotesMissing.length) {
      L.push('');
      L.push('اقتباسات غير موجودة حرفياً:');
      for (const q of m.quotesMissing) L.push(`- ${q.fp}: «${cell(q.quote).slice(0, 120)}»`);
    }
  }
  if (r.stability.length) {
    L.push('');
    L.push('## ثبات التشغيلات');
    L.push('');
    L.push('| العقد | تشغيلات | تشابه المؤكدة | ثابت | ملاحظات متذبذبة |');
    L.push('|---|---|---|---|---|');
    for (const s of r.stability) L.push(`| ${s.ref} | ${s.runs} | ${fmtPct(s.jaccard)} | ${s.stable ? 'نعم' : 'لا'} | ${s.flapping.join('، ') || '—'} |`);
  }
  L.push('');
  return L.join('\n');
}
