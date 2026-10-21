import type { ClauseAssessmentStatus } from '../database/entities/contract-clause.entity';

/** درجة خطورة البند فى تقرير المراجعة. «غير مصنَّف» لا يُخزَّن (يُشتق عند العرض لبند يحتاج مراجعة بلا درجة). */
export type RiskLevel = 'حرج' | 'عالٍ' | 'متوسط';

/**
 * درجة الخطورة حتمية ومربوطة بالأدلة (لا حكم حر من النموذج):
 *  - «حرج»: بند يحتاج مراجعة ومخالفته لنص آمر ثابتة بعبارة حرفية موثَّقة من نص مادة معروضة (mandatoryVerified).
 *  - «عالٍ»: بند يحتاج مراجعة وادّعى النموذج فيه مخالفة قاعدة آمرة لكن لم تثبت بعبارة حرفية (يلزم محامٍ ليحسمها).
 *  - «متوسط»: بند يحتاج مراجعة، سواء اختلف عن قاعدة مكمِّلة (الاتفاق على خلافها جائز أصلاً، فالاختلاف وحده ليس خطراً
 *    قانونياً عالياً) أو لم يختلف عن نص محدد.
 * البند «سليم» أو «لا يوجد نص مفهرَس» بلا درجة (null): لا نصنّف خطورة بلا نص نقيس عليه.
 */
export function riskLevelFor(
  status: ClauseAssessmentStatus | null,
  violationType: 'none' | 'supplementary_difference' | 'mandatory_violation',
  mandatoryVerified: boolean,
): RiskLevel | null {
  if (status !== 'يحتاج مراجعة') return null;
  if (mandatoryVerified) return 'حرج';
  if (violationType === 'mandatory_violation') return 'عالٍ';
  return 'متوسط';
}
