import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AnswerResponseDto } from './answer-response.dto';

export class QuestionDetailResponseDto {
  @ApiProperty({ example: 'q-uuid' })
  id: string;

  @ApiProperty({ example: 'هل يحق لصاحب العمل فصلي بدون إنذار؟' })
  question: string;

  @ApiPropertyOptional({ example: 'labor', nullable: true })
  category: string | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  conversation_id: string | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;

  @ApiProperty({ type: AnswerResponseDto })
  answer: AnswerResponseDto;
}

export class QuestionHistoryItemDto {
  @ApiProperty({ example: 'q-uuid' })
  id: string;

  @ApiProperty({ example: 'هل يحق لصاحب العمل فصلي بدون إنذار؟' })
  question: string;

  @ApiPropertyOptional({ example: 'labor', nullable: true })
  category: string | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;

  @ApiProperty({ example: false })
  refused: boolean;

  @ApiProperty({ example: 0.87 })
  confidence: number;
}

export class QuestionHistoryResponseDto {
  @ApiProperty({ type: QuestionHistoryItemDto, isArray: true })
  items: QuestionHistoryItemDto[];

  @ApiProperty({ example: 12 })
  total: number;
}

export class QuestionDeleteResponseDto {
  @ApiProperty({ example: true })
  success: boolean;
}
