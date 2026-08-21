import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class LawResponseDto {
  @ApiProperty({ example: '3b9b9a5e-8c1c-4f0d-9f2a-123456789abc' })
  id: string;

  @ApiProperty({ example: 12 })
  law_no: number;

  @ApiProperty({ example: 2003 })
  law_year: number;

  @ApiProperty({ example: 'قانون العمل الصادر بالقانون رقم 12 لسنة 2003' })
  title: string;

  @ApiPropertyOptional({ example: 'قانون العمل', nullable: true })
  short_title: string | null;

  @ApiProperty({
    example: 'labor',
    enum: ['labor', 'rent', 'personal_status', 'traffic', 'consumer_protection', 'other'],
  })
  category: string;

  @ApiProperty({ example: 'in_force', enum: ['in_force', 'amended', 'repealed'] })
  status: string;

  @ApiPropertyOptional({ example: 'https://example.gov.eg/law/12-2003', nullable: true })
  official_url: string | null;

  @ApiPropertyOptional({ example: '2003-07-07', nullable: true })
  enacted_at: string | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  last_amended_at: string | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  updated_at: string;
}

export class LawListResponseDto {
  @ApiProperty({ type: LawResponseDto, isArray: true })
  items: LawResponseDto[];

  @ApiProperty({ example: 5 })
  total: number;
}
