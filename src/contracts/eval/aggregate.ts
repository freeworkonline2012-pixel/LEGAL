import type { ContractMetrics } from './types';

export type CheckStatus = 'pass' | 'fail' | 'unmeasured';
export interface GateCheck {
  id: string;
  label: string;
  /** القيمة المقيسة (نسبة 0..1 أو عدد) */
  value: number | null;
  /** النص المعروض للعتبة */
  threshold: string;
  status: CheckStatus;
  detail?: string;
}

export type GateProfile = 'k1' | 'service';
export type FinalVerdict = 'Go' | 'No-Go' | 'غير مكتمل' | 'غير صالح';

export interface Aggregate {
  contracts: number;
  runs: number;
  issues: number;
  foundConfirmed: number;
  foundCandidateOnly: number;
  recall: number | null;
  recallWithCandidates: number | null;
  criticalHighRecall: number | null;
  confirmedItems: number;
  truePositiveItems: number;
  falseAlarms: number;
  highCriticalFalseAlarms: number;
  pending: number;
  pendingHighCritical: number;
  precision: number | null;
  falseAlarmRate: number | null;
  quotesChecked: number;
  quotesMissing: number;
  citationsChecked: number;
  citationsNotIndexed: number | null;
  citationsMalformed: number;
  segmentationMin: number | null;
  partiesChecked: number;
  partiesOk: number;
  sumsChecked: number;
  sumsFound: number;
  coverageAvg: number | null;
}

const ratio = (a: number, b: number): number | null => (b > 0 ? a / b : null);

export function aggregate(rows: ContractMetrics[]): Aggregate {
  const sum = (f: (m: ContractMetrics) => number): number => rows.reduce((a, m) => a + f(m), 0);
  const issues = sum((m) => m.issueCount);
  const found = sum((m) => m.foundConfirmed);
  const cand = sum((m) => m.foundCandidateOnly);
  const hcT = sum((m) => m.criticalHighTotal);
  const hcF = sum((m) => m.criticalHighFound);
  const conf = sum((m) => m.confirmedItems);
  const tp = sum((m) => m.truePositiveItems);
  const fa = sum((m) => m.falseAlarms);
  const pend = sum((m) => m.pendingItems.length);
  const segs = rows.map((m) => m.segmentation).filter((x): x is number => x !== null);
  const covs = rows.map((m) => m.coverage).filter((x): x is number => x !== null);
  const indexedKnown = rows.every((m) => m.citationsNotIndexed !== null);
  const partyRows = rows.filter((m) => m.parties !== 'unmeasured');
  const sums = rows.map((m) => m.paymentSums).filter((x): x is { checked: number; found: number } => x !== null);
  return {
    contracts: new Set(rows.map((m) => m.ref)).size,
    runs: rows.length,
    issues,
    foundConfirmed: found,
    foundCandidateOnly: cand,
    recall: ratio(found, issues),
    recallWithCandidates: ratio(found + cand, issues),
    criticalHighRecall: ratio(hcF, hcT),
    confirmedItems: conf,
    truePositiveItems: tp,
    falseAlarms: fa,
    highCriticalFalseAlarms: sum((m) => m.highCriticalFalseAlarms),
    pending: pend,
    pendingHighCritical: sum((m) => m.pendingHighCritical),
    // الدقة تفترض أسوأ حال: غير المحكوم فيه يُعدّ إنذاراً كاذباً حتى يحكم المحامى (والحكم النهائى يمنع «Go» ما دام هناك معلّق)
    precision: ratio(tp, tp + fa + pend),
    falseAlarmRate: ratio(fa + pend, tp + fa + pend),
    quotesChecked: sum((m) => m.quotesChecked),
    quotesMissing: sum((m) => m.quotesMissing.length),
    citationsChecked: sum((m) => m.citationsChecked),
    citationsNotIndexed: indexedKnown ? sum((m) => m.citationsNotIndexed?.length ?? 0) : null,
    citationsMalformed: sum((m) => m.citationsMalformed),
    segmentationMin: segs.length ? Math.min(...segs) : null,
    partiesChecked: partyRows.length,
    partiesOk: partyRows.filter((m) => m.parties === 'ok').length,
    sumsChecked: sums.reduce((a, s) => a + s.checked, 0),
    sumsFound: sums.reduce((a, s) => a + s.found, 0),
    coverageAvg: covs.length ? covs.reduce((a, b) => a + b, 0) / covs.length : null,
  };
}

const geq = (v: number | null, t: number): CheckStatus => (v === null ? 'unmeasured' : v + 1e-9 >= t ? 'pass' : 'fail');
const leq = (v: number | null, t: number): CheckStatus => (v === null ? 'unmeasured' : v <= t + 1e-9 ? 'pass' : 'fail');
const pct = (v: number | null): string => (v === null ? '—' : `${(v * 100).toFixed(1)}%`);

/**
 * بوابات القبول. k1 = قبول Holdout (الاستدعاء ≥80%، الدقة ≥80%، صفر إنذار كاذب عالٍ/حرج، اقتباس حرفى 100%).
 * service = بوابة Go للخدمة (خطة 11-03 البند 8): استدعاء ≥85% (≥90% للعالى/الحرج)، إنذار كاذب ≤10%، لا اقتباس مفقود، لا استشهاد غير مفهرس،
 * تجزئة ≥98%، الأطراف 100%، المبالغ 100%.
 */
export function evaluateGate(profile: GateProfile, agg: Aggregate, opts: { minContracts?: number } = {}): GateCheck[] {
  const min = opts.minContracts ?? 1;
  const checks: GateCheck[] = [];
  const add = (c: GateCheck): void => void checks.push(c);
  add({ id: 'sample', label: 'عدد العقود المقيسة', value: agg.contracts, threshold: `≥ ${min}`, status: agg.contracts >= min ? 'pass' : 'fail' });
  if (profile === 'k1') {
    add({ id: 'recall', label: 'الاستدعاء (ملاحظات المفتاح المؤكدة)', value: agg.recall, threshold: '≥ 80%', status: geq(agg.recall, 0.8) });
    add({ id: 'precision', label: 'الدقة (المؤكدة الصحيحة / كل المؤكدة)', value: agg.precision, threshold: '≥ 80%', status: geq(agg.precision, 0.8) });
    add({ id: 'hc_fa', label: 'إنذارات كاذبة عالية/حرجة', value: agg.highCriticalFalseAlarms + agg.pendingHighCritical, threshold: '= 0', status: agg.highCriticalFalseAlarms > 0 ? 'fail' : agg.pendingHighCritical > 0 ? 'unmeasured' : 'pass', detail: agg.pendingHighCritical > 0 ? 'يوجد عالٍ/حرج بلا حكم محامٍ' : undefined });
    add({ id: 'quotes', label: 'الاقتباسات غير الحرفية', value: agg.quotesMissing, threshold: '= 0', status: agg.quotesMissing === 0 ? 'pass' : 'fail', detail: agg.quotesChecked === 0 ? 'لم يوجد أى اقتباس للفحص' : undefined });
  } else {
    add({ id: 'recall', label: 'الاستدعاء', value: agg.recall, threshold: '≥ 85%', status: geq(agg.recall, 0.85) });
    add({ id: 'recall_hc', label: 'استدعاء العالى/الحرج', value: agg.criticalHighRecall, threshold: '≥ 90%', status: geq(agg.criticalHighRecall, 0.9) });
    add({ id: 'false_alarm', label: 'معدل الإنذار الكاذب', value: agg.falseAlarmRate, threshold: '≤ 10%', status: leq(agg.falseAlarmRate, 0.1) });
    add({ id: 'hc_fa', label: 'إنذارات كاذبة عالية/حرجة', value: agg.highCriticalFalseAlarms + agg.pendingHighCritical, threshold: '= 0', status: agg.highCriticalFalseAlarms > 0 ? 'fail' : agg.pendingHighCritical > 0 ? 'unmeasured' : 'pass' });
    add({ id: 'quotes', label: 'اقتباسات غير موجودة فى النص', value: agg.quotesMissing, threshold: '= 0', status: agg.quotesMissing === 0 ? 'pass' : 'fail', detail: agg.quotesChecked === 0 ? 'لم يوجد أى اقتباس للفحص' : undefined });
    add({ id: 'citations', label: 'استشهادات غير مفهرسة', value: agg.citationsNotIndexed === null ? null : agg.citationsNotIndexed + agg.citationsMalformed, threshold: '= 0', status: agg.citationsNotIndexed === null ? 'unmeasured' : agg.citationsNotIndexed + agg.citationsMalformed === 0 ? 'pass' : 'fail', detail: agg.citationsNotIndexed === null ? 'شغّل اللقطة بوضع --db ليُفحص الفهرس' : undefined });
    add({ id: 'segmentation', label: 'التجزئة (أدنى عقد)', value: agg.segmentationMin, threshold: '≥ 98%', status: geq(agg.segmentationMin, 0.98) });
    add({ id: 'parties', label: 'الأطراف مقروءة صحيحاً', value: ratio(agg.partiesOk, agg.partiesChecked), threshold: '= 100%', status: agg.partiesChecked === 0 ? 'unmeasured' : agg.partiesOk === agg.partiesChecked ? 'pass' : 'fail' });
    add({ id: 'sums', label: 'المبالغ مقروءة صحيحاً', value: ratio(agg.sumsFound, agg.sumsChecked), threshold: '= 100%', status: agg.sumsChecked === 0 ? 'unmeasured' : agg.sumsFound === agg.sumsChecked ? 'pass' : 'fail' });
  }
  return checks;
}

export function finalVerdict(checks: GateCheck[], rows: ContractMetrics[], pending: number): { verdict: FinalVerdict; reasons: string[] } {
  const invalid = rows.filter((m) => !m.valid);
  if (invalid.length > 0) return { verdict: 'غير صالح', reasons: [...new Set(invalid.flatMap((m) => m.invalidReasons.map((r) => `${m.ref}: ${r}`)))] };
  if (checks.some((c) => c.status === 'fail')) return { verdict: 'No-Go', reasons: checks.filter((c) => c.status === 'fail').map((c) => c.label) };
  const open = checks.filter((c) => c.status === 'unmeasured').map((c) => c.label);
  if (pending > 0) open.push(`${pending} ملاحظة مؤكدة خارج المفتاح تنتظر حكم المحامى`);
  if (open.length > 0) return { verdict: 'غير مكتمل', reasons: open };
  return { verdict: 'Go', reasons: [] };
}

export const fmtPct = pct;

// ===================== ثبات التشغيلات =====================

export interface StabilityReport {
  ref: string;
  runs: number;
  /** متوسط تشابه Jaccard بين مجموعات الملاحظات المؤكدة لكل زوج تشغيلات (1 = متطابقة) */
  jaccard: number | null;
  /** ملاحظات المفتاح: نسبة التشغيلات التى أظهرتها مؤكدة */
  issueRates: Array<{ id: string; rate: number }>;
  /** ملاحظات مؤكدة تظهر فى بعض التشغيلات دون بعض */
  flapping: string[];
  stable: boolean;
}

export function stability(rows: ContractMetrics[]): StabilityReport[] {
  const byRef = new Map<string, ContractMetrics[]>();
  for (const m of rows) byRef.set(m.ref, [...(byRef.get(m.ref) ?? []), m]);
  const out: StabilityReport[] = [];
  for (const [ref, runs] of byRef) {
    if (runs.length < 2) continue;
    const sets = runs.map((r) => new Set(r.confirmedFps));
    const pairs: number[] = [];
    for (let i = 0; i < sets.length; i += 1) {
      for (let j = i + 1; j < sets.length; j += 1) {
        const inter = [...sets[i]].filter((x) => sets[j].has(x)).length;
        const uni = new Set([...sets[i], ...sets[j]]).size;
        pairs.push(uni === 0 ? 1 : inter / uni);
      }
    }
    const all = new Set(runs.flatMap((r) => r.confirmedFps));
    const flapping = [...all].filter((fp) => sets.some((s) => s.has(fp)) && sets.some((s) => !s.has(fp))).sort();
    const ids = Object.keys(runs[0].issueFound);
    const issueRates = ids.map((id) => ({ id, rate: runs.filter((r) => r.issueFound[id]).length / runs.length }));
    const jaccard = pairs.reduce((a, b) => a + b, 0) / pairs.length;
    out.push({ ref, runs: runs.length, jaccard, issueRates, flapping, stable: flapping.length === 0 && issueRates.every((x) => x.rate === 0 || x.rate === 1) });
  }
  return out;
}
