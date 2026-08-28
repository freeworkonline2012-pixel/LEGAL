import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  Matches,
  MaxLength,
  Min,
} from 'class-validator';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';
import { LAW_KINDS, type LawKind } from '../../database/entities/law-kind';
import { COUNTRY_CODE_PATTERN } from '../../database/entities/country-code';

// T-VOCAB-1: مصدر واحد للمفردات (DOMAIN_KEYS) — راجع التعليق فى create-law.dto.ts
const LAW_CATEGORIES = DOMAIN_KEYS;

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

  @ApiPropertyOptional({ example: 'law', enum: LAW_KINDS })
  @IsOptional()
  @IsIn(LAW_KINDS)
  kind?: LawKind;

  @ApiPropertyOptional({ example: 'EG', description: 'ISO 3166-1 alpha-2' })
  @IsOptional()
  @Matches(COUNTRY_CODE_PATTERN)
  country_code?: string;

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
