import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import type { GovernanceVerdict } from '../../llm/deepseek-generation.service';

/**
 * عقد الحكم البنيوى — يطابق حرفياً صيغة القسم 4.3 من project doc
 * (تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى-2026-09-02.md):
 * {verdict, legal_basis, risk_note, confidence}.
 */
export class GovernanceLegalBasisDto {
  @ApiProperty({ example: 'قانون مكافحة غسل الأموال' })
  law: string;

  @ApiProperty({ example: 80 })
  law_no: number;

  @ApiProperty({ example: 2002 })
  law_year: number;

  @ApiProperty({ example: 12 })
  article_no: number;

  @ApiProperty({ example: 'تلتزم المؤسسات المالية بالإبلاغ عن العمليات المشبوهة...' })
  snippet: string;
}

export class GovernanceVerdictResponseDto {
  @ApiProperty({
    example: 'غير متوافق',
    enum: ['متوافق', 'غير متوافق', 'متوافق جزئياً', 'معلومات غير كافية'],
    description:
      '"معلومات غير كافية" هو الافتراضى الآمن عند أى شك حقيقى (لا مادة كافية، أو ' +
      'خدمة التقييم الآلى غير متاحة تقنياً) — وليس علامة فشل، بل قرار fail-closed ' +
      'متعمَّد؛ راجع تعليق GovernanceService.assess لسياسة أكثر تحفظاً عمداً من ' +
      '/api/questions.',
  })
  verdict: GovernanceVerdict;

  @ApiProperty({ type: GovernanceLegalBasisDto, isArray: true })
  legal_basis: GovernanceLegalBasisDto[];

  @ApiProperty({
    example: 'عدم الإبلاغ يُعرِّض المؤسسة لعقوبات جنائية وإدارية بموجب المادة 15.',
  })
  risk_note: string;

  @ApiPropertyOptional({
    example: 0.82,
    minimum: 0,
    maximum: 1,
    description: 'ثقة داخلية — مفيدة للمراجعة اللاحقة، لا تُعرَض كضمان دقة للمستخدم مباشرة.',
  })
  confidence: number;
}
