import { type LegalDocument, DEFAULT_BRAND, STANDARD_DISCLAIMER, compactCairoDate } from '../document-model';
import { buildContractAuditReport, type AuditClause, type AuditReportInput } from '../audit-report/build';

export type ContractExportClause = AuditClause;
export type ContractExportInput = AuditReportInput;

/**
 * تقرير «مراجعة وتدقيق مخاطر العقد» بالتصميم المعتمد (راجع ../audit-report). التقرير الآلى مسودة عمل إلى أن يعتمده مراجع
 * بشرى (approvedAt)؛ قبل الاعتماد يحمل علامة مائية «مسودة» ولا يصل العميل أصلاً (راجع ExportsService).
 */
export function buildContractDocument(input: ContractExportInput): LegalDocument {
  const { report, reference } = buildContractAuditReport(input);
  const approved = input.approvedAt !== null;
  return {
    kind: 'contract_report',
    brand: input.brand ?? DEFAULT_BRAND,
    title: report.cover.title,
    subtitle: input.originalFilename,
    reference,
    generatedAt: input.generatedAt,
    meta: [],
    watermark: report.watermark,
    blocks: [],
    disclaimer: STANDARD_DISCLAIMER,
    filenameBase: `contract-${reference.slice(4).toLowerCase()}-${compactCairoDate(input.generatedAt)}${input.audience === 'client' ? '-client' : ''}${approved ? '' : '-draft'}`,
    audit: report,
  };
}
