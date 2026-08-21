import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ArticleVersionResponseDto {
  @ApiProperty({ example: 'v-uuid' })
  id: string;

  @ApiProperty({ example: 2 })
  version_no: number;

  @ApiProperty({ example: 'النص المعدل للمادة' })
  body: string;

  @ApiProperty({ example: '2015-06-01' })
  effective_from: string;

  @ApiPropertyOptional({ example: null, nullable: true })
  effective_to: string | null;

  @ApiProperty({ example: 'active', enum: ['active', 'amended', 'repealed'] })
  status: string;

  @ApiPropertyOptional({ example: 48, nullable: true })
  amended_by_law_no: number | null;

  @ApiPropertyOptional({ example: 2022, nullable: true })
  amended_by_law_year: number | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  change_note: string | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;
}

export class ArticleResponseDto {
  @ApiProperty({ example: 'a-uuid' })
  id: string;

  @ApiProperty({ example: '3b9b9a5e-8c1c-4f0d-9f2a-123456789abc' })
  law_id: string;

  @ApiProperty({ example: 110 })
  article_no: number;

  @ApiPropertyOptional({ example: 'الباب الثاني — عقد العمل الفردي', nullable: true })
  hierarchical_location: string | null;

  @ApiPropertyOptional({ example: 'إجازة العامل السنوية', nullable: true })
  title: string | null;

  @ApiProperty({ example: 'يستحق العامل إجازة سنوية مدفوعة الأجر...' })
  body: string;

  @ApiPropertyOptional({ example: null, nullable: true })
  plain_summary: string | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  updated_at: string;
}

export class ArticleDetailResponseDto extends ArticleResponseDto {
  @ApiProperty({ type: ArticleVersionResponseDto })
  version: ArticleVersionResponseDto;
}

export class ArticleListResponseDto {
  @ApiProperty({ type: ArticleResponseDto, isArray: true })
  items: ArticleResponseDto[];

  @ApiProperty({ example: 264 })
  total: number;
}

export class ArticleVersionListResponseDto {
  @ApiProperty({ type: ArticleVersionResponseDto, isArray: true })
  items: ArticleVersionResponseDto[];

  @ApiProperty({ example: 3 })
  total: number;
}
