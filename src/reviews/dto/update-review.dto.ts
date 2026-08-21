import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';

const REVIEW_STATUSES = ['approved', 'rejected', 'needs_changes'] as const;

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
}
