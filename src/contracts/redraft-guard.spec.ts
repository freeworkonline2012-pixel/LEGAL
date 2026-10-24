import type { ClauseFacts } from './clause-facts';
import { compareFactsForClient } from './redraft-guard';

const term = (holder: 'first' | 'second' | 'both' | 'none', mechanism: 'automatic_without_court' | 'unilateral_right' | 'court_required' = 'automatic_without_court') =>
  ({ mechanism, holder, quote: 'يجوز لأى من الطرفين فسخ العقد' }) as const;
const codes = (o: ClauseFacts, p: ClauseFacts, party: 'first' | 'second' | null = 'second') => compareFactsForClient(o, p, party).map((w) => w.code);

describe('compareFactsForClient', () => {
  it('بلا طرف معروف للعميل لا يحكم', () => {
    expect(codes({ termination: term('second') }, { termination: term('first') }, null)).toEqual([]);
  });

  it('G12: إضافة الإنذار على عميل يملك حق الفسخ مع إعفاء صريح ⇒ إضعاف', () => {
    const o: ClauseFacts = { termination: term('second'), notice: { state: 'waived_explicitly', quote: 'دون حاجة إلى إنذار' } };
    const p: ClauseFacts = { termination: term('second'), notice: { state: 'required', quote: 'بعد إنذار مدته 30 يوماً' } };
    expect(codes(o, p)).toContain('notice.waiver_removed_from_client');
  });

  it('إضافة إنذار على الطرف الآخر صاحب الحق لا يُعد إضعافاً (يقوّى العميل)', () => {
    const o: ClauseFacts = { termination: term('first'), notice: { state: 'waived_explicitly', quote: 'دون حاجة إلى إنذار' } };
    const p: ClauseFacts = { termination: term('first'), notice: { state: 'required', quote: 'بعد إنذار مدته 30 يوماً' } };
    expect(codes(o, p)).toEqual([]);
  });

  it('إعفاء الطرف الآخر من الإنذار بعد أن كان واجباً ⇒ إضعاف', () => {
    const o: ClauseFacts = { termination: term('first'), notice: { state: 'required', quote: 'بعد إنذار مدته 30 يوماً' } };
    const p: ClauseFacts = { termination: term('first'), notice: { state: 'waived_explicitly', quote: 'دون حاجة إلى إنذار' } };
    expect(codes(o, p)).toContain('notice.waiver_added_for_other');
  });

  it('حق الفسخ: فقده أو منحه للطرف الآخر أو اشتراط حكم قضائى على العميل ⇒ إضعاف', () => {
    expect(codes({ termination: term('second') }, { termination: term('first') })).toContain('termination.holder_lost');
    expect(codes({ termination: term('second') }, { termination: term('both') })).toContain('termination.other_gains');
    expect(codes({ termination: term('second') }, { termination: term('second', 'court_required') })).toContain('termination.out_of_court_lost');
    expect(codes({ termination: term('first', 'court_required') }, { termination: term('second', 'automatic_without_court') })).toEqual([]);
  });

  it('المسئولية: نقل الإعفاء عن العميل أو إضافة إعفاء للآخر أو إسقاط استثناء الخطأ الجسيم ⇒ إضعاف', () => {
    const L = (kind: 'exclusion' | 'cap' | 'none', beneficiary: 'first' | 'second' | 'both' | 'none', grossFault: 'reserved' | 'covered' | 'unspecified' = 'unspecified') =>
      ({ kind, beneficiary, grossFault, quote: 'لا يسأل الطرف عن أى ضرر' }) as const;
    expect(codes({ liability: L('exclusion', 'second') }, { liability: L('exclusion', 'first') })).toContain('liability.client_protection_lost');
    expect(codes({ liability: L('none', 'none') }, { liability: L('exclusion', 'first') })).toContain('liability.other_gains');
    expect(codes({}, { liability: L('cap', 'first') })).toContain('liability.new_exclusion_for_other');
    expect(codes({ liability: L('exclusion', 'first', 'reserved') }, { liability: L('exclusion', 'first', 'unspecified') })).toContain('liability.gross_fault_reservation_lost');
    expect(codes({ liability: L('exclusion', 'first', 'unspecified') }, { liability: L('exclusion', 'first', 'reserved') })).toEqual([]);
  });

  it('القوة القاهرة: توسيع أسباب الطرف الآخر أو إسقاط إخطاره أو تحميل العميل إخطاراً ⇒ إضعاف', () => {
    const F = (beneficiary: 'first' | 'second' | 'both' | 'none', extraCauses: 'legal_only' | 'listed' | 'open_ended', noticeRequired = false) =>
      ({ extraCauses, counterpartyCanReject: false, noticeRequired, beneficiary, quote: 'قوة قاهرة أو أسباب أخرى' }) as const;
    expect(codes({ forceMajeure: F('first', 'legal_only') }, { forceMajeure: F('first', 'open_ended') })).toContain('force_majeure.broader_causes_for_other');
    expect(codes({ forceMajeure: F('first', 'legal_only', true) }, { forceMajeure: F('first', 'legal_only', false) })).toContain('force_majeure.notice_dropped');
    expect(codes({ forceMajeure: F('second', 'legal_only') }, { forceMajeure: F('second', 'legal_only', true) })).toContain('force_majeure.notice_added_for_client');
    expect(codes({ forceMajeure: F('first', 'open_ended') }, { forceMajeure: F('first', 'legal_only') })).toEqual([]);
  });

  it('التعويض: إسقاط سقف يحمى العميل أو تقدير بيد الآخر أو نقل العبء للعميل ⇒ إضعاف', () => {
    const C = (payer: 'first' | 'second' | 'both' | 'none', extra: Partial<{ method: 'fixed_amount' | 'percentage' | 'court_assessed' | 'party_discretion' | 'unspecified'; hasCap: boolean; waivesProofOfDamage: boolean }> = {}) =>
      ({ method: 'court_assessed', waivesProofOfDamage: false, hasCap: false, payer, quote: 'يلتزم بالتعويض', ...extra }) as const;
    expect(codes({ compensation: C('second', { hasCap: true }) }, { compensation: C('second', { hasCap: false }) })).toContain('compensation.cap_lost');
    expect(codes({ compensation: C('second') }, { compensation: C('second', { method: 'party_discretion' }) })).toContain('compensation.party_discretion_added');
    expect(codes({ compensation: C('first') }, { compensation: C('second') })).toContain('compensation.payer_shifted_to_client');
    expect(codes({ compensation: C('first') }, { compensation: C('first', { hasCap: true }) })).toContain('compensation.cap_added_on_other');
    expect(codes({ compensation: C('first', { hasCap: true }) }, { compensation: C('first', { hasCap: false }) })).toEqual([]);
  });

  it('القسم الغائب عن أحد الطرفين لا يُعد إضعافاً (لا يُبنى حكم على عجز الاستخراج)', () => {
    expect(codes({ termination: term('second') }, {})).toEqual([]);
  });
});
