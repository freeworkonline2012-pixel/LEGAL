import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  MaxLength,
  Min,
} from 'class-validator';

const LAW_CATEGORIES = [
  'labor',
  'rent',
  'personal_status',
  'traffic',
  'consumer_protection',
  'other',
] as const;

const LAW_STATUSES = ['in_force', 'amended', 'repealed'] as const;

export class UpdateLawDto {
  @ApiPropertyOptional({ example: 12 })
  @IsOptional()
  @IsInt()
  @Min(1)
  law_no?: number;

  @ApiPropertyOptional({ example: 2003 })
  @IsOptional()
  @IsInt()
  @Min(1800)
  law_year?: number;

  @ApiPropertyOptional({ example: 'قانون العمل الصادر بالقانون رقم 12 لسنة 2003' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  title?: string;

  @ApiPropertyOptional({ example: 'قانون العمل', nullable: true })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  short_title?: string | null;

  @ApiPropertyOptional({ example: 'labor', enum: LAW_CATEGORIES })
  @IsOptional()
  @IsIn(LAW_CATEGORIES)
  category?: (typeof LAW_CATEGORIES)[number];

  @ApiPropertyOptional({ example: 'in_force', enum: LAW_STATUSES })
  @IsOptional()
  @IsIn(LAW_STATUSES)
  status?: (typeof LAW_STATUSES)[number];

  @ApiPropertyOptional({ example: 'https://example.gov.eg/law/12-2003' })
  @IsOptional()
  @IsUrl()
  @MaxLength(1000)
  official_url?: string;

  @ApiPropertyOptional({ example: '2003-07-07' })
  @IsOptional()
  @IsDateString()
  enacted_at?: string;

  @ApiPropertyOptional({ example: null, nullable: true })
  @IsOptional()
  @IsDateString()
  last_amended_at?: string | null;
}
