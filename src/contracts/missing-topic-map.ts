/**
 * ربط «بند ناقص» فى فحص مستوى العقد بمحور الدليل التفاوضى الذى يتناول الموضوع نفسه.
 * الغاية: ألا يبدو الموضوع الواحد ملاحظتين مستقلتين فى التقرير (حكم المستشار على الدفعة 1: 8 من 31 ملاحظة مكررة بين الطبقتين).
 * الملاحظة على مستوى العقد هى الوحدة المعدودة (درجة وإجراء)، ويُحيل محور الدليل إليها ويضيف عليها الموقف التفاوضى والأثر القانونى.
 * لا يُربط إلا ما هو موضوع واحد صراحةً؛ ما التبس تُرك دون ربط (يبقى كل منهما ظاهراً).
 */
export const MISSING_CHECK_TO_TOPICS: Readonly<Record<string, readonly string[]>> = {
  payment: ['svc_payment'],
  termination: ['svc_termination', 'agy_termination', 'emp_termination', 'lease_termination'],
  governing_law: ['common_disputes'],
  confidentiality: ['svc_confidentiality'],
  liability: ['svc_liability', 'agy_liability'],
  delay_penalty: ['svc_delay'],
  acceptance: ['svc_acceptance'],
  warranty: ['svc_warranty', 'sale_warranty'],
  intellectual_property: ['svc_ip', 'lic_ip'],
  data_protection: ['svc_data_protection'],
  lease_deposit: ['lease_deposit'],
  lease_handover: ['lease_handover'],
  lease_maintenance: ['lease_maintenance'],
  lease_use: ['lease_use'],
  sale_title: ['sale_title'],
  employment_hours: ['emp_hours'],
  employment_insurance: ['emp_insurance'],
  finance_return: ['fin_interest'],
  finance_security: ['fin_security'],
  finance_default: ['fin_default'],
  finance_prepayment: ['fin_prepayment'],
  partnership_capital: ['prt_contribution'],
  partnership_profit: ['prt_profit'],
  partnership_exit: ['prt_exit'],
  partnership_liability: ['prt_liability'],
  partnership_info: ['prt_info'],
  partnership_noncompete: ['prt_noncompete'],
  agency_authority: ['agy_authority'],
  agency_commission: ['agy_commission'],
  licence_scope: ['lic_scope'],
  licence_quality: ['lic_quality'],
};

/** محور الدليل -> رقم الملاحظة (مثل «ع3») التى تتناول غياب الموضوع نفسه فى «ملاحظات العقد ككل». */
export function coveredTopicRefs(findings: ReadonlyArray<{ id?: string }>): Map<string, string> {
  const out = new Map<string, string>();
  findings.forEach((f, i) => {
    if (!f.id || !f.id.startsWith('missing:')) return;
    for (const topic of MISSING_CHECK_TO_TOPICS[f.id.slice('missing:'.length)] ?? []) {
      if (!out.has(topic)) out.set(topic, `ع${i + 1}`);
    }
  });
  return out;
}
