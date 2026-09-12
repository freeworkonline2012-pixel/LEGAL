import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class DataExportUserDto {
  @ApiProperty({ example: '3b9b9a5e-8c1c-4f0d-9f2a-123456789abc' })
  id: string;

  @ApiProperty({ example: 'user@example.com' })
  email: string;

  @ApiPropertyOptional({ example: 'أحمد محمد', nullable: true })
  full_name: string | null;

  @ApiProperty({ example: 'user' })
  role: string;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;

  @ApiPropertyOptional({ example: '2026-09-12T10:00:00.000Z', nullable: true })
  consent_given_at: string | null;

  @ApiPropertyOptional({ example: '2026-09-12-draft-v1', nullable: true })
  consent_version: string | null;
}

export class DataExportCitationDto {
  @ApiProperty({ example: 'قانون العمل' })
  law: string;

  @ApiProperty({ example: 12 })
  law_no: number;

  @ApiProperty({ example: 2003 })
  law_year: number;

  @ApiProperty({ example: 110 })
  article_no: number;

  @ApiProperty({ example: 'نص المادة...' })
  snippet: string;
}

export class DataExportAnswerDto {
  @ApiProperty({ example: 'a-uuid' })
  id: string;

  @ApiProperty({ example: 'نص الإجابة...' })
  answer: string;

  @ApiProperty({ example: 0.87 })
  confidence: number;

  @ApiProperty({ example: false })
  refused: boolean;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;

  @ApiProperty({ type: DataExportCitationDto, isArray: true })
  citations: DataExportCitationDto[];
}

export class DataExportQuestionDto {
  @ApiProperty({ example: 'q-uuid' })
  id: string;

  @ApiProperty({ example: 'هل يحق لصاحب العمل فصلي بدون إنذار؟' })
  question: string;

  @ApiPropertyOptional({ example: 'labor', nullable: true })
  category: string | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;

  @ApiProperty({ type: DataExportAnswerDto, isArray: true })
  answers: DataExportAnswerDto[];
}

export class DataExportFeedbackDto {
  @ApiProperty({ example: 'f-uuid' })
  id: string;

  @ApiProperty({ example: 'a-uuid' })
  answer_id: string;

  @ApiProperty({ example: 1 })
  rating: number;

  @ApiPropertyOptional({ example: null, nullable: true })
  comment: string | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;
}

export class DataExportResponseDto {
  @ApiProperty({
    example: '2026-09-12T12:00:00.000Z',
    description: 'تاريخ ووقت توليد هذا التصدير (وليس تاريخ إنشاء البيانات نفسها)',
  })
  exported_at: string;

  @ApiProperty({ type: DataExportUserDto })
  user: DataExportUserDto;

  @ApiProperty({ type: DataExportQuestionDto, isArray: true })
  questions: DataExportQuestionDto[];

  @ApiProperty({ type: DataExportFeedbackDto, isArray: true })
  feedback: DataExportFeedbackDto[];
}
