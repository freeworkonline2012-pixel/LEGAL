import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

const REVIEW_STATUSES = ['approved', 'rejected', 'needs_changes'] as const;

/**
 * migrations/031 — Phase 1 من "الخدمة الأولى" (راجع تصور-تقنى-محترف-ثلاث-
 * خدمات-ذكاء-اصطناعى، القسم 2.3، بند "واجهة تصحيح"). كل حقول التصحيح
 * اختيارية عمداً: الحالة الشائعة (موافقة/رفض بلا بديل محدَّد) لا تحتاجها.
 * corrected_answer وحقول الاستشهاد الثلاثة مستقلة عن بعضها — يمكن تصحيح
 * النص فقط، أو الاستشهاد فقط، أو الاثنين معاً.
 */
export class UpdateReviewDto {
  @ApiProperty({
    example: 'approved',
    enum: REVIEW_STATUSES,
    description: 'حالة المراجعة النهائية (تبدأ من pending)',
  })
  @IsIn(REVIEW_STATUSES)
  status: (typeof REVIEW_STATUSES)[number];

  @ApiPropertyOptional({ example: 'الاستشهاد صحيح والنص مطابق للمادة' })
  @IsOptional()
  @IsString()
  @MaxLength(2_000)
  review_note?: string;

  @ApiPropertyOptional({
    example: 'الصواب أن العقد ينتهى تلقائياً وفقاً للمادة 110 لا 108',
    description: 'نص الإجابة الصحيح كما يراه المحامى (اختيارى — بديل عن answer.answer الحالى)',
  })
  @IsOptional()
  @IsString()
  @MaxLength(4_000)
  corrected_answer?: string;

  @ApiPropertyOptional({ example: 12, description: 'رقم القانون الصحيح للاستشهاد (اختيارى)' })
  @IsOptional()
  @IsInt()
  @Min(1)
  corrected_law_no?: number;

  @ApiPropertyOptional({ example: 2003, description: 'سنة القانون الصحيح للاستشهاد (اختيارى)' })
  @IsOptional()
  @IsInt()
  @Min(1800)
  @Max(2100)
  corrected_law_year?: number;

  @ApiPropertyOptional({ example: 110, description: 'رقم المادة الصحيح للاستشهاد (اختيارى)' })
  @IsOptional()
  @IsInt()
  @Min(1)
  corrected_article_no?: number;

  @ApiPropertyOptional({
    example: true,
    description:
      'علامة صريحة من المحامى: هل يستحق هذا التصحيح أن يُضاف كحالة اختبار دائمة فى ' +
      'Golden Test Set؟ (يُستخرَج لاحقاً عبر scripts/export_golden_candidates.js لمراجعة ' +
      'يدوية قبل الدمج — لا دمج تلقائى بلا رقابة). افتراضياً false.',
  })
  @IsOptional()
  @IsBoolean()
  promote_to_golden_set?: boolean;
}
