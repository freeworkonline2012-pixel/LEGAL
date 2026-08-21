import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class FeedbackResponseDto {
  @ApiProperty({ example: 'f-uuid' })
  id: string;

  @ApiProperty({ example: 'a-uuid' })
  answer_id: string;

  @ApiProperty({ example: 1 })
  rating: number;

  @ApiPropertyOptional({ example: 'الإجابة دقيقة ومفيدة', nullable: true })
  comment: string | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;
}
