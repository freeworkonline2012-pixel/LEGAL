import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/**
 * عقد الإجابة — يطابق حرفياً عقد API الإصدار 0.1 في docs/build/implementation_notes.md (القسم 4).
 */
export class CitationResponseDto {
  @ApiProperty({ example: 'قانون العمل' })
  law: string;

  @ApiProperty({ example: 12 })
  law_no: number;

  @ApiProperty({ example: 2003 })
  law_year: number;

  @ApiProperty({ example: 110 })
  article_no: number;

  @ApiProperty({ example: 'active', enum: ['active', 'amended', 'repealed'] })
  status: string;

  @ApiPropertyOptional({ example: null, nullable: true })
  last_amended: string | null;

  @ApiPropertyOptional({ example: 'https://example.gov.eg/law/12-2003', nullable: true })
  official_url: string | null;

  @ApiProperty({ example: 'يستحق العامل إجازة سنوية مدفوعة الأجر...' })
  snippet: string;
}

export class AnswerResponseDto {
  @ApiProperty({
    example: 'a-uuid',
    description:
      'معرّف الإجابة المحفوظة — يُستخدم كـ answer_id في POST /api/feedback (عقد C-2). إلزامي في الرد الفعلي (openapi.yaml) ويُضبط قبل الإرجاع في ask()؛ اختياري هنا لأن كائن DTO يُبنى قبل حفظ الكيان.',
  })
  id?: string;

  @ApiProperty({
    example: 'لا تتوفر معلومة موثقة كافية للإجابة بدقة.',
    description: 'نص الإجابة (عند الرفض: جملة الرفض الصريحة)',
  })
  answer: string;

  @ApiProperty({ example: 0.87, minimum: 0, maximum: 1 })
  confidence: number;

  @ApiProperty({ type: CitationResponseDto, isArray: true })
  citations: CitationResponseDto[];

  @ApiProperty({ example: false })
  refused: boolean;
}
