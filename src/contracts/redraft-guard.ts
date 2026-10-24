import type { ClauseFacts, PartyRef } from './clause-facts';

/**
 * حارس حتمى لحماية مركز العميل فى الصياغة المقترحة، يقارن وقائع البند الأصلى بوقائع الصياغة المقترحة (المستخرجة بالطريقة نفسها
 * وبالاقتباس الحرفى، راجع clause-facts.ts) ويكشف الإضعاف بقواعد ثابتة لا برأى نموذج ولا بملاحظة الخطر الناتجة عن التقييم الأول.
 * هذا ما سدّ ثغرة «المدقق الثانى يعتمد على الخطر المبيَّن»: إن كان الخطر المبيَّن خاطئاً ظل الحارس يقارن النصين أنفسهما.
 *
 * حدود صريحة: يقارن الأقسام الموجودة فى النصين معاً فقط؛ حذف قسم كامل لا يكشفه هذا الحارس (يكشفه المدقق اللغوى الموازى)،
 * لأن عجز الاستخراج عن قسم لا يصح أن يُعدّ إضعافاً. ويلزمه معرفة طرف العميل؛ بدونها لا يحكم.
 */

export interface Weakening {
  code: string;
  explanation: string;
}

type Rel = 'client' | 'other' | 'both' | 'none';

function rel(ref: PartyRef, clientParty: 'first' | 'second'): Rel {
  if (ref === 'both') return 'both';
  if (ref === 'none') return 'none';
  return ref === clientParty ? 'client' : 'other';
}

const gainsForOther = (before: Rel, after: Rel): boolean =>
  (after === 'other' || after === 'both') && !(before === 'other' || before === 'both');
const losesForClient = (before: Rel, after: Rel): boolean =>
  (before === 'client' || before === 'both') && !(after === 'client' || after === 'both');

export function compareFactsForClient(
  original: ClauseFacts,
  proposed: ClauseFacts,
  clientParty: 'first' | 'second' | null,
): Weakening[] {
  if (!clientParty) return [];
  const out: Weakening[] = [];
  const add = (code: string, explanation: string) => out.push({ code, explanation });

  // ---- الفسخ والإعذار
  const ot = original.termination;
  const pt = proposed.termination;
  if (ot && pt) {
    const oh = rel(ot.holder, clientParty);
    const ph = rel(pt.holder, clientParty);
    const outOfCourt = (m: string) => m === 'automatic_without_court' || m === 'unilateral_right';
    if (losesForClient(oh, ph)) add('termination.holder_lost', 'تُسقط الصياغة حق العميل فى فسخ العقد أو تقصره على الطرف الآخر.');
    else if (gainsForOther(oh, ph) && oh === 'client') add('termination.other_gains', 'تمنح الصياغة الطرف الآخر حق فسخ لم يكن له فى الأصل.');
    if (outOfCourt(ot.mechanism) && pt.mechanism === 'court_required' && (oh === 'client' || oh === 'both')) {
      add('termination.out_of_court_lost', 'تجعل الصياغة فسخ العميل مشروطاً بحكم قضائى بعد أن كان بغير حكم.');
    }
  }
  const on = original.notice;
  const pn = proposed.notice;
  if (on && pn) {
    const holder = rel((pt ?? ot)?.holder ?? 'none', clientParty);
    const clientHoldsRight = holder === 'client';
    const otherHoldsRight = holder === 'other';
    if (clientHoldsRight && on.state === 'waived_explicitly' && pn.state !== 'waived_explicitly') {
      add('notice.waiver_removed_from_client', 'تُسقط الصياغة الإعفاء الصريح من الإنذار الذى يستفيد منه العميل صاحب حق الفسخ، فتُلزمه بإعذار لم يكن مطلوباً.');
    }
    if (otherHoldsRight && on.state !== 'waived_explicitly' && pn.state === 'waived_explicitly') {
      add('notice.waiver_added_for_other', 'تعفى الصياغة الطرف الآخر من الإنذار قبل فسخ العقد على العميل بعد أن كان الإنذار قائماً.');
    }
  }

  // ---- المسئولية
  const ol = original.liability;
  const pl = proposed.liability;
  if (pl) {
    const pb = rel(pl.beneficiary, clientParty);
    if (ol) {
      const ob = rel(ol.beneficiary, clientParty);
      if (pl.kind !== 'none' && ol.kind !== 'none' && losesForClient(ob, pb)) {
        add('liability.client_protection_lost', 'تنقل الصياغة الإعفاء أو الحد من المسئولية بعيداً عن العميل.');
      }
      if (ol.kind !== 'none' && pl.kind === 'none' && (ob === 'client' || ob === 'both')) {
        add('liability.client_protection_removed', 'تلغى الصياغة إعفاء أو حداً من المسئولية كان يحمى العميل.');
      }
      if (gainsForOther(ob, pb) && pl.kind !== 'none') {
        add('liability.other_gains', 'تمنح الصياغة الطرف الآخر إعفاء أو حداً من المسئولية لم يكن له فى الأصل.');
      }
      if ((pb === 'other' || pb === 'both') && ol.grossFault === 'reserved' && pl.grossFault !== 'reserved') {
        add('liability.gross_fault_reservation_lost', 'تُسقط الصياغة استثناء الغش والخطأ الجسيم من إعفاء الطرف الآخر.');
      }
      if (ob === 'client' && ol.grossFault === 'covered' && pl.grossFault === 'reserved') {
        add('liability.client_gross_fault_cover_lost', 'تستثنى الصياغة الغش والخطأ الجسيم من إعفاء كان يشمل العميل.');
      }
    } else if (pl.kind !== 'none' && (pb === 'other' || pb === 'both')) {
      add('liability.new_exclusion_for_other', 'تضيف الصياغة إعفاءً أو حداً من المسئولية لصالح الطرف الآخر لم يكن فى الأصل.');
    }
  }

  // ---- القوة القاهرة
  const of = original.forceMajeure;
  const pf = proposed.forceMajeure;
  if (of && pf) {
    const ob = rel(of.beneficiary, clientParty);
    const pb = rel(pf.beneficiary, clientParty);
    if (losesForClient(ob, pb)) add('force_majeure.client_relief_lost', 'تُسقط الصياغة استفادة العميل من الإعفاء بالقوة القاهرة.');
    if (gainsForOther(ob, pb)) add('force_majeure.other_gains', 'توسّع الصياغة الاستفادة من القوة القاهرة لصالح الطرف الآخر.');
    const rank = { legal_only: 0, listed: 1, open_ended: 2 } as const;
    if ((pb === 'other' || pb === 'both') && rank[pf.extraCauses] > rank[of.extraCauses]) {
      add('force_majeure.broader_causes_for_other', 'توسّع الصياغة أسباب الإعفاء التى يستفيد منها الطرف الآخر.');
    }
    if (ob === 'client' && rank[pf.extraCauses] < rank[of.extraCauses]) {
      add('force_majeure.narrower_causes_for_client', 'تضيّق الصياغة أسباب الإعفاء التى يستفيد منها العميل.');
    }
    if ((pb === 'other' || pb === 'both') && of.noticeRequired && !pf.noticeRequired) {
      add('force_majeure.notice_dropped', 'تُسقط الصياغة اشتراط الإخطار من الطرف الآخر عند التمسك بالقوة القاهرة.');
    }
    if (pb === 'client' && !of.noticeRequired && pf.noticeRequired) {
      add('force_majeure.notice_added_for_client', 'تضيف الصياغة التزام العميل بالإخطار عند التمسك بالقوة القاهرة.');
    }
  }

  // ---- التعويض
  const oc = original.compensation;
  const pc = proposed.compensation;
  if (oc && pc) {
    const op = rel(oc.payer, clientParty);
    const pp = rel(pc.payer, clientParty);
    if (op === 'other' && (pp === 'client' || pp === 'both')) {
      add('compensation.payer_shifted_to_client', 'تنقل الصياغة عبء التعويض إلى العميل بعد أن كان على الطرف الآخر.');
    }
    if ((pp === 'client' || pp === 'both') && oc.hasCap && !pc.hasCap) {
      add('compensation.cap_lost', 'تُسقط الصياغة الحد الأقصى للتعويض الذى كان يحمى العميل.');
    }
    if (pp === 'other' && !oc.hasCap && pc.hasCap) {
      add('compensation.cap_added_on_other', 'تضع الصياغة حداً أقصى لتعويض يستحقه العميل لم يكن فى الأصل.');
    }
    if ((pp === 'client' || pp === 'both') && oc.method !== 'party_discretion' && pc.method === 'party_discretion') {
      add('compensation.party_discretion_added', 'تجعل الصياغة تقدير التعويض الذى يتحمله العميل بيد الطرف الآخر.');
    }
    if ((pp === 'client' || pp === 'both') && !oc.waivesProofOfDamage && pc.waivesProofOfDamage) {
      add('compensation.proof_waived_against_client', 'تعفى الصياغة الطرف الآخر من إثبات الضرر عند مطالبة العميل بالتعويض.');
    }
    if (pp === 'other' && oc.waivesProofOfDamage && !pc.waivesProofOfDamage) {
      add('compensation.proof_burden_added_on_client', 'تُلزم الصياغة العميل بإثبات الضرر بعد أن كان معفى منه.');
    }
  }
  return out;
}

/** نص ملاحظة تُعاد للنموذج فى المحاولة الثانية، أو سبب الرفض النهائى. */
export function describeWeakenings(list: Weakening[]): string {
  return list.map((w) => w.explanation).join(' ');
}
