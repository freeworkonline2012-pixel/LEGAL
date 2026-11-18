/**
 * إخفاء تفاصيل المراجعة قبل السداد (طلب مراجعة العقد، migrations/262).
 *
 * يبقى للعميل ما يخصّه: بنوده بنصّها، وحالة كل بند وعنوان ملاحظات العقد ودرجتها؛ ويُخفى الذى يُدفع مقابله: تفسير الحكم،
 * المواد المطابَقة، نتائج القواعد والتحقق، الصياغة البديلة، وشرح الملاحظات واقتراحاتها وشواهدها.
 * دالة نقية: تُطبَّق على نسخة جديدة ولا تعدّل المدخل.
 */
import type { ContractResponseDto } from './dto/contract-response.dto';

export function redactForPreview(dto: ContractResponseDto): ContractResponseDto {
  return {
    ...dto,
    details_locked: true,
    clauses: (dto.clauses ?? []).map((c) => ({
      ...c,
      assessment_reasoning: null,
      matched_articles: null,
      assessment_confidence: null,
      rule_findings: null,
      verification: null,
      suggested_redraft: null,
    })),
    contract_findings: (dto.contract_findings ?? []).map((f) => ({
      ...f,
      explanation: '',
      suggestion: null,
      evidence: [],
      verification: null,
    })),
  };
}
