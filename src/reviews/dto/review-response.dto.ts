import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CitationResponseDto } from '../../questions/dto/answer-response.dto';

/**
 * سياق المراجعة الكامل (EP-06): السؤال + الإجابة + درجة الثقة + الاستشهادات.
 * يُمكّن المحامي من حسم المراجعة دون مغادرة الشاشة — كل البيانات في نظر واحد.
 * هذا الحقل إضافي (اختياري) على عقد ReviewResponse الأساسي؛ الواجهة الحالية
 * (review/page.tsx) لا تستهلك الـ endpoint بعد، فلا كسر — لكنه يُغلق فجوة
 * «طابور بلا سياق» التي كانت تجعل المراجعة مستحيلة عملياً.
 */
export class ReviewDetailContextDto {
  @ApiProperty({ example: 'هل يحق لصاحب العمل فصلي بدون إنذار؟' })
  question: string;

  @ApiProperty({
    example: 'طبقاً للمادة 110 من قانون العمل (رقم 12 لسنة 2003): إذا أنهي عقد العمل...',
  })
  answer: string;

  @ApiProperty({ example: 0.87, minimum: 0, maximum: 1 })
  confidence: number;

  @ApiPropertyOptional({ example: 'labor', nullable: true })
  category: string | null;

  @ApiProperty({ type: CitationResponseDto, isArray: true })
  citations: CitationResponseDto[];
}

export class ReviewResponseDto {
  @ApiProperty({ example: 'r-uuid' })
  id: string;

  @ApiProperty({ example: 'a-uuid' })
  answer_id: string;

  @ApiPropertyOptional({ example: 'lawyer-uuid', nullable: true })
  reviewer_id: string | null;

  @ApiProperty({
    example: 'pending',
    enum: ['pending', 'approved', 'rejected', 'needs_changes'],
  })
  status: string;

  @ApiPropertyOptional({ example: null, nullable: true })
  review_note: string | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  reviewed_at: string | null;

  @ApiProperty({
    example: 'auto_refused',
    enum: ['auto_refused', 'random_sample'],
    description: 'migrations/031: سبب دخول الصف الطابور — رفض تلقائى أم عيّنة عشوائية دورية',
  })
  trigger_reason: string;

  @ApiPropertyOptional({ example: null, nullable: true })
  corrected_answer: string | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  corrected_law_no: number | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  corrected_law_year: number | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  corrected_article_no: number | null;

  @ApiProperty({ example: false })
  promote_to_golden_set: boolean;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;

  @ApiPropertyOptional({
    description:
      'سياق المراجعة: نص السؤال والإجابة والثقة والاستشهادات (EP-06) — يُضمَّن في القائمة والحسم',
    type: ReviewDetailContextDto,
  })
  context?: ReviewDetailContextDto;
}

export class ReviewListResponseDto {
  @ApiProperty({ type: ReviewResponseDto, isArray: true })
  items: ReviewResponseDto[];

  @ApiProperty({ example: 3 })
  total: number;
}
