import type { Verification } from './verification';

/**
 * الجولة 99: تصويت أغلبية على عيّنات المدقق المستقل (self-consistency).
 * DeepSeek لا يوفّر معامل seed ويعطى أحكاماً مختلفة لنفس المدخل رغم temperature 0 (مؤكَّد فى الحوكمة وفى قياس 15 نوفمبر 2026:
 * 8 من 29 التقاطة لم تثبت بين تشغيلتين متطابقتين). فلا يُقبل حكم عيّنة واحدة على ملاحظة قد تُؤكَّد أو تُستبعد بها.
 *
 * القاعدة (الأمان أولاً): تُحسب العيّنات السليمة فقط؛ النصاب أكثر من نصفها.
 *  - تأكيد بنصاب ⇒ مؤكدة. ودرجة «اختلال عن قاعدة مكملة» (reclassified) لا تُعتمد إلا إن بلغت هى نفسها النصاب.
 *  - دحض بنصاب (والدحض فى كل عيّنة موثَّق باقتباس تحقق منه الكود) ⇒ مستبعدة.
 *  - غير ذلك (لا أغلبية، أو شك) ⇒ مرشحة للمراجعة البشرية (unconfirmed/uncertain)؛ لا تُحذف ولا تُؤكَّد بلا إجماع كاف.
 *  - عيّنة سليمة واحدة فقط (والباقى أعطال) ⇒ حكمها (السلوك السابق)، وكل العيّنات أعطال ⇒ العطل الأول.
 */
export type VerifierSampleOutcome =
  | { status: 'ok'; verification: Verification }
  | { status: 'not_configured' }
  | { status: 'error'; detail: string };

export interface VoteTally {
  confirmed: number;
  reclassified: number;
  refuted: number;
  uncertain: number;
  errors: number;
}

export const DEFAULT_VERIFIER_SAMPLES = 3;
export const MAX_VERIFIER_SAMPLES = 5;

/** عدد العيّنات المطلوب: CONTRACT_VERIFIER_SAMPLES (افتراضى 3، 1 = السلوك السابق، أقصاه 5). */
export function verifierSampleCount(raw: string | undefined = process.env.CONTRACT_VERIFIER_SAMPLES): number {
  if (raw === undefined || raw.trim() === '') return DEFAULT_VERIFIER_SAMPLES;
  const n = Math.floor(Number(raw));
  if (!Number.isFinite(n) || n < 1) return DEFAULT_VERIFIER_SAMPLES;
  return Math.min(n, MAX_VERIFIER_SAMPLES);
}

/**
 * الجولة 105.5: تصويت تكيفى للمدقق (راجع assess-vote.ts). تأكيد 2 من 3 قلب ملاحظة (م28) من مرشحة إلى مؤكدة بين تشغيلتين فتغيّر المستوى العام.
 * إن لم تُجمع العيّنات الثلاث على نوع حكم واحد تُسحب عيّنتان إضافيتان (أغلبية من 5). CONTRACT_VERIFIER_EXTRA_SAMPLES (افتراضى 2، 0 يعطّله، أقصاه 2).
 */
export const DEFAULT_VERIFIER_EXTRA_SAMPLES = 2;

export function verifierExtraSampleCount(raw: string | undefined = process.env.CONTRACT_VERIFIER_EXTRA_SAMPLES): number {
  if (raw === undefined || raw.trim() === '') return DEFAULT_VERIFIER_EXTRA_SAMPLES;
  const n = Math.floor(Number(raw));
  if (!Number.isFinite(n) || n < 0) return DEFAULT_VERIFIER_EXTRA_SAMPLES;
  return Math.min(n, 2);
}

export function verifierNeedsExtra(outcomes: VerifierSampleOutcome[]): boolean {
  const oks = outcomes.filter((o): o is Extract<VerifierSampleOutcome, { status: 'ok' }> => o.status === 'ok');
  if (oks.length < 2) return false;
  return new Set(oks.map((o) => kindOf(o.verification))).size > 1;
}

function kindOf(v: Verification): 'confirmed' | 'reclassified' | 'refuted' | 'uncertain' {
  if (v.status === 'confirmed') return v.basis === 'reclassified' ? 'reclassified' : 'confirmed';
  return v.basis === 'refuted' ? 'refuted' : 'uncertain';
}

export function resolveVerifierVotes(
  outcomes: VerifierSampleOutcome[],
  now: Date = new Date(),
): { outcome: VerifierSampleOutcome; tally: VoteTally } {
  const oks = outcomes.filter((o): o is Extract<VerifierSampleOutcome, { status: 'ok' }> => o.status === 'ok');
  const tally: VoteTally = { confirmed: 0, reclassified: 0, refuted: 0, uncertain: 0, errors: outcomes.length - oks.length };
  if (oks.length === 0) return { outcome: outcomes[0] ?? { status: 'error', detail: 'no_samples' }, tally };
  for (const o of oks) tally[kindOf(o.verification)] += 1;
  if (oks.length === 1) return { outcome: oks[0], tally };

  const quorum = Math.floor(oks.length / 2) + 1;
  const pick = (k: ReturnType<typeof kindOf>): Extract<VerifierSampleOutcome, { status: 'ok' }> | undefined => oks.find((o) => kindOf(o.verification) === k);

  if (tally.confirmed + tally.reclassified >= quorum) {
    if (tally.reclassified >= quorum) return { outcome: pick('reclassified')!, tally };
    return { outcome: pick('confirmed') ?? pick('reclassified')!, tally };
  }
  if (tally.refuted >= quorum) return { outcome: pick('refuted')!, tally };

  // الجولة 100: إجماع العيّنات على الشك اتفاق لا خلاف؛ كانت العبارة «لم يتفق المدقق» تُقال حتى عند شك 3 من 3 (مضلِّلة للمحامى القارئ).
  const reason =
    tally.uncertain === oks.length
      ? `اتفقت عيّنات المدقق المستقل على الشك (شك ${tally.uncertain} من ${oks.length}) فلم تُؤكَّد الملاحظة ولم تُدحض، وبقيت مرشحة للمراجعة البشرية.`
      : `انقسمت عيّنات المدقق المستقل (تأكيد ${tally.confirmed + tally.reclassified}، دحض ${tally.refuted}، شك ${tally.uncertain}) ` +
        'فلا أغلبية تحسم حكمها، وبقيت الملاحظة مرشحة للمراجعة البشرية.';
  return {
    outcome: { status: 'ok', verification: { status: 'unconfirmed', basis: 'uncertain', reason, quote: null, quoteSource: null, verifiedAt: now.toISOString() } },
    tally,
  };
}
