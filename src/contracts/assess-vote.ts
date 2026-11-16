/**
 * الجولة 101: تصويت أغلبية على عيّنات مرحلة التقييم الأولى للبند (self-consistency)، امتداداً لما فعلته الجولة 99 مع المدقق المستقل.
 * قياس الجولة 100 على الإنتاج: ما زال التذبذب بين تشغيلتين متطابقتين فى بنود مثل توريد أ 5 و12 ومقاولة أ 3 و12 مصدره هذه المرحلة، لأن النموذج
 * (DeepSeek بلا seed) يحكم على البند نفسه بالسلامة مرة وبـ«يحتاج مراجعة» مرة. حكم عيّنة واحدة لا يُعتمد.
 *
 * القاعدة (الأمان أولاً، والمدقق المستقل بعدها هو المصفاة النهائية للملاحظات):
 *  - تُحسب العيّنات السليمة فقط (status ok)؛ عيّنة واحدة سليمة ⇒ حكمها (السلوك السابق)؛ لا سليمة ⇒ أول عطل (يُعاد للمحاولة الثانية كما كان).
 *  - الحالة النهائية = الحالة التى بلغت النصاب (أكثر من نصف العيّنات السليمة). بلا نصاب: «يحتاج مراجعة» إن قالتها أى عيّنة (لا يُسكَت عن بند لم يُجمَع على سلامته)،
 *    وإلا «سليم» ثم «لا يوجد نص».
 *  - العيّنة الممثِّلة من الحالة الفائزة هى صاحبة نوع المخالفة الأكثر تكراراً، وعند التعادل الأخف (none ثم supplementary_difference ثم mandatory_violation): لا يُصعَّد
 *    ادعاء آمرة بلا أغلبية. ثم الأعلى ثقة، ثم الأسبق. المواد المختارة والشرح ونص الاقتباس كلها من هذه العيّنة وحدها فلا يختلط تعليل بمواد غيره.
 */
export type AssessLabel = 'سليم' | 'يحتاج مراجعة' | 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
export type ViolationType = 'none' | 'supplementary_difference' | 'mandatory_violation';

export type AssessSample =
  | { status: 'not_configured' }
  | { status: 'error'; detail: string }
  | {
      status: 'ok';
      assessment: string;
      selectedIndices: number[];
      reasoning: string;
      confidence: number;
      violationType: ViolationType;
      mandatoryQuote: string;
    };

export interface AssessTally {
  review: number;
  sound: number;
  noText: number;
  errors: number;
}

export const DEFAULT_ASSESS_SAMPLES = 3;
export const MAX_ASSESS_SAMPLES = 5;

/** عدد العيّنات: CONTRACT_ASSESS_SAMPLES (افتراضى 3، 1 = السلوك السابق، أقصاه 5). */
export function assessSampleCount(raw: string | undefined = process.env.CONTRACT_ASSESS_SAMPLES): number {
  if (raw === undefined || raw.trim() === '') return DEFAULT_ASSESS_SAMPLES;
  const n = Math.floor(Number(raw));
  if (!Number.isFinite(n) || n < 1) return DEFAULT_ASSESS_SAMPLES;
  return Math.min(n, MAX_ASSESS_SAMPLES);
}

const REVIEW: AssessLabel = 'يحتاج مراجعة';
const SOUND: AssessLabel = 'سليم';
const NO_TEXT: AssessLabel = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
const SEVERITY_RANK: Record<ViolationType, number> = { none: 0, supplementary_difference: 1, mandatory_violation: 2 };

type Ok = Extract<AssessSample, { status: 'ok' }>;

export function resolveAssessmentVotes(samples: AssessSample[]): { outcome: AssessSample; tally: AssessTally; decision: string } {
  const oks = samples.filter((s): s is Ok => s.status === 'ok');
  const tally: AssessTally = { review: 0, sound: 0, noText: 0, errors: samples.length - oks.length };
  if (oks.length === 0) return { outcome: samples[0] ?? { status: 'error', detail: 'no_samples' }, tally, decision: 'none' };
  for (const s of oks) {
    if (s.assessment === REVIEW) tally.review += 1;
    else if (s.assessment === NO_TEXT) tally.noText += 1;
    else tally.sound += 1;
  }
  if (oks.length === 1) return { outcome: oks[0], tally, decision: 'single' };

  const quorum = Math.floor(oks.length / 2) + 1;
  let winner: AssessLabel;
  let decision: string;
  if (tally.review >= quorum) [winner, decision] = [REVIEW, 'review'];
  else if (tally.sound >= quorum) [winner, decision] = [SOUND, 'sound'];
  else if (tally.noText >= quorum) [winner, decision] = [NO_TEXT, 'no_text'];
  else if (tally.review > 0) [winner, decision] = [REVIEW, 'review_no_quorum'];
  else if (tally.sound > 0) [winner, decision] = [SOUND, 'sound_no_quorum'];
  else [winner, decision] = [NO_TEXT, 'no_text_no_quorum'];

  const pool = oks.filter((s) => (winner === REVIEW ? s.assessment === REVIEW : winner === NO_TEXT ? s.assessment === NO_TEXT : s.assessment !== REVIEW && s.assessment !== NO_TEXT));
  // نوع المخالفة الأكثر تكراراً بين عيّنات الحالة الفائزة؛ التعادل للأخف
  const counts = new Map<ViolationType, number>();
  for (const s of pool) counts.set(s.violationType, (counts.get(s.violationType) ?? 0) + 1);
  const kinds = [...counts.entries()].sort((a, b) => b[1] - a[1] || SEVERITY_RANK[a[0]] - SEVERITY_RANK[b[0]]);
  const chosenKind = kinds[0][0];
  const group = pool.filter((s) => s.violationType === chosenKind);
  let best = group[0];
  for (const s of group) if (s.confidence > best.confidence) best = s;
  return { outcome: best, tally, decision };
}
