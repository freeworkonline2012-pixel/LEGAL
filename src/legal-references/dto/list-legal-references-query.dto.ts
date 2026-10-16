import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Matches, Max, MaxLength, Min } from 'class-validator';
import { COUNTRY_CODE_PATTERN } from '../../database/entities/country-code';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';
import { LEGAL_REFERENCE_TYPES } from '../../database/entities/legal-reference.entity';

const trimString = ({ value }: { value: unknown }): unknown =>
  typeof value === 'string' ? value.trim() : value;

export class ListLegalReferencesQueryDto {
  @ApiPropertyOptional({ example: 'EG', description: 'ISO 3166-1 alpha-2 (أو XA = الوطن العربى)' })
  @IsOptional()
  @Matches(COUNTRY_CODE_PATTERN)
  country?: string;

  @ApiPropertyOptional({ enum: LEGAL_REFERENCE_TYPES })
  @IsOptional()
  @IsIn(LEGAL_REFERENCE_TYPES)
  reference_type?: (typeof LEGAL_REFERENCE_TYPES)[number];

  @ApiPropertyOptional({ enum: DOMAIN_KEYS })
  @IsOptional()
  @IsIn(DOMAIN_KEYS)
  category?: (typeof DOMAIN_KEYS)[number];

  @ApiPropertyOptional({ description: 'بحث فى العنوان والمؤلف' })
  @IsOptional()
  @Transform(trimString)
  @IsString()
  @MaxLength(200)
  q?: string;

  @ApiPropertyOptional({ default: 20, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit: number = 20;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  offset: number = 0;
}

/** بحث نصى كامل داخل أقسام المراجع. */
export class SearchLegalReferencesQueryDto {
  @ApiPropertyOptional({ description: 'نص البحث (حرفان على الأقل)', minLength: 2 })
  @Transform(trimString)
  @IsString()
  @MaxLength(200)
  q: string;

  @ApiPropertyOptional({ example: 'EG' })
  @IsOptional()
  @Matches(COUNTRY_CODE_PATTERN)
  country?: string;

  @ApiPropertyOptional({ enum: LEGAL_REFERENCE_TYPES })
  @IsOptional()
  @IsIn(LEGAL_REFERENCE_TYPES)
  reference_type?: (typeof LEGAL_REFERENCE_TYPES)[number];

  @ApiPropertyOptional({ default: 20, maximum: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit: number = 20;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  offset: number = 0;
}
