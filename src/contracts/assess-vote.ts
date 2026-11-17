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
 *
 * الجولة 107: العيّنة الممثِّلة كانت تُختار بالثقة وحدها دون النظر إلى كونها اختارت مادة صالحة. وحكم «سليم» أو «يحتاج مراجعة» بلا مادة صالحة تُخفِّضه الخدمة قسراً
 * إلى «لا يوجد نص» وتُحصى البند غير مقيَّم. فإذا اتفقت العيّنات على «سليم» (3 من 5) واختارت إحداها مادة ولم تختر الأخرى، تقرّر وجود تغطية بحسب أى العيّنتين
 * كانت أعلى ثقة أو أسبق. المقيس على الإنتاج بعد الجولة 106 (تشغيلتان على عقد خدمات، البند 8 نفسه بثقة 0.60 فى الاثنتين): مواد مختارة 0 ثم 2 ⇒ تغطية 2 ثم 3 من 8، ويُرجَّح أنه سبب التذبذب (ما لم تكن كل العيّنات السليمة بلا مادة، وعندها لا يغيّر هذا شيئاً).
 * القاعدة: ضمن العيّنات المتفقة على الحالة الفائزة ونوع المخالفة، تُفضَّل العيّنات التى اختارت مادة صالحة (فهرسها ضمن المرشحات المعروضة)، ثم الأعلى ثقة، ثم الأسبق.
 * إن لم تختر أى منها مادة صالحة (أو لم يُعلَم عدد المرشحات) يبقى السلوك السابق حرفياً.
 *
 * الجولة 108 (تصويت على المواد): (أ) العيّنة الممثِّلة هى الأعلى «دعماً» أى التى وافقتها عيّنات الأغلبية على مادتها، ثم الأعلى ثقة (كانت الثقة وحدها فى 107 بين المغطّاة)؛
 * (ب) إجماع «سليم»/«يحتاج مراجعة» بلا أى مادة صالحة يستدعى العيّنتين الإضافيتين (أغلبية من 5) لأن هذا بالذات ما تتذبذب فيه التغطية. الأصل أن المزوّد غير حتمى
 * رغم temperature 0، فالتصويت وحده هو ما يثبّت النتيجة. بلا مرشحات أو بإجماع «لا يوجد نص» لا نداءات إضافية.
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

/**
 * الجولة 105.5: تصويت تكيفى. قياس الجولة 105.4 على الإنتاج: بند بتصويت 1 سليم / 2 لا نص (البند 34) انقلب إلى «لا يوجد نص» بعيّنة واحدة بين تشغيلتين،
 * وملاحظة (م28) انقلبت من مرشحة إلى مؤكدة بتأكيد 2 من 3. الأغلبية من 3 عند الحدود هشّة. فإذا لم تُجمع العيّنات الثلاث على حكم واحد تُسحب عيّنتان
 * إضافيتان (أغلبية من 5)؛ وإن أجمعت (الأغلب الأعم) فلا نداء إضافى. CONTRACT_ASSESS_EXTRA_SAMPLES (افتراضى 2، 0 يعطّله، أقصاه 2).
 */
export const DEFAULT_ASSESS_EXTRA_SAMPLES = 2;

export function assessExtraSampleCount(raw: string | undefined = process.env.CONTRACT_ASSESS_EXTRA_SAMPLES): number {
  if (raw === undefined || raw.trim() === '') return DEFAULT_ASSESS_EXTRA_SAMPLES;
  const n = Math.floor(Number(raw));
  if (!Number.isFinite(n) || n < 0) return DEFAULT_ASSESS_EXTRA_SAMPLES;
  return Math.min(n, 2);
}

/** فهارس المواد الصالحة فى عيّنة: أعداد صحيحة داخل المرشحات المعروضة، بلا تكرار. */
function validIndicesOf(s: Ok, candidateCount: number): number[] {
  return [...new Set(s.selectedIndices.filter((i) => Number.isInteger(i) && i >= 0 && i < candidateCount))];
}

/**
 * هل تحتاج العيّنات الأولى عيّنات إضافية؟ نعم فى حالتين:
 *  1) انقسمت العيّنات السليمة (عيّنتان فأكثر) بين حكمين فأكثر. الأعطال وحدها لا تستدعى إضافية (تُعاد المحاولة بمسارها).
 *  2) الجولة 108: أجمعت على «سليم» أو على «يحتاج مراجعة» ولم تختر أى منها مادة صالحة. حكم كهذا تُخفّضه الخدمة قسراً إلى «لا يوجد نص»، وهو بالتحديد
 *     الحالة التى تتذبذب فيها التغطية (عيّنة واحدة تختار مادة فى تشغيلة وتتركها فى أخرى). فتُسحب الإضافيتان ليُحسم وجود مادة بأغلبية 5 لا 3.
 *     إجماع «لا يوجد نص» لا يستدعيها (حكم ثابت أصلاً)، ولا يُستدعى بلا مرشحات (candidateCount = 0).
 */
export function assessNeedsExtra(samples: AssessSample[], candidateCount = 0): boolean {
  const oks = samples.filter((s): s is Extract<AssessSample, { status: 'ok' }> => s.status === 'ok');
  if (oks.length < 2) return false;
  const kinds = new Set(oks.map((s) => (s.assessment === REVIEW ? 'review' : s.assessment === NO_TEXT ? 'noText' : 'sound')));
  if (kinds.size > 1) return true;
  if (kinds.has('noText') || candidateCount <= 0) return false;
  return oks.every((s) => validIndicesOf(s, candidateCount).length === 0);
}

const REVIEW: AssessLabel = 'يحتاج مراجعة';
const SOUND: AssessLabel = 'سليم';
const NO_TEXT: AssessLabel = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
const SEVERITY_RANK: Record<ViolationType, number> = { none: 0, supplementary_difference: 1, mandatory_violation: 2 };

type Ok = Extract<AssessSample, { status: 'ok' }>;

export function resolveAssessmentVotes(samples: AssessSample[], candidateCount = 0): { outcome: AssessSample; tally: AssessTally; decision: string } {
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
  const sameKind = pool.filter((s) => s.violationType === chosenKind);
  // الجولة 107 + 108: تصويت على المواد نفسها. لكل مادة صالحة عدد العيّنات الفائزة التى اختارتها؛ تُمثِّل البندَ العيّنةُ الأعلى «دعماً» (متوسط أصوات موادها)،
  // فتُقدَّم المادة التى أجمعت عليها العيّنات على مادة انفردت بها عيّنة عالية الثقة، وتُهمَل العيّنة التى لم تختر مادة صالحة ما دامت غيرها اختارت.
  // التعادل: الأعلى ثقة ثم الأسبق. المواد والشرح والاقتباس تبقى من هذه العيّنة وحدها. بلا أى عيّنة مغطّاة (أو عدد المرشحات مجهول) يبقى السلوك السابق.
  const votes = new Map<number, number>();
  for (const s of sameKind) for (const i of validIndicesOf(s, candidateCount)) votes.set(i, (votes.get(i) ?? 0) + 1);
  const support = (s: Ok): number => {
    const v = validIndicesOf(s, candidateCount);
    return v.length === 0 ? 0 : v.reduce((a, i) => a + (votes.get(i) ?? 0), 0) / v.length;
  };
  let best = sameKind[0];
  let bestSupport = support(best);
  for (const s of sameKind) {
    const sp = support(s);
    if (sp > bestSupport || (sp === bestSupport && s.confidence > best.confidence)) {
      best = s;
      bestSupport = sp;
    }
  }
  return { outcome: best, tally, decision };
}
