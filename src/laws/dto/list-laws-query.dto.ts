import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsInt, IsOptional, Matches, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';
import { COUNTRY_CODE_PATTERN } from '../../database/entities/country-code';

// T-VOCAB-1: مصدر واحد للمفردات (DOMAIN_KEYS) — راجع التعليق فى create-law.dto.ts
const LAW_CATEGORIES = DOMAIN_KEYS;

export class ListLawsQueryDto {
  @ApiPropertyOptional({ example: 'labor', enum: LAW_CATEGORIES })
  @IsOptional()
  @IsIn(LAW_CATEGORIES)
  category?: (typeof LAW_CATEGORIES)[number];

  @ApiPropertyOptional({
    example: 'EG',
    description: 'ISO 3166-1 alpha-2 — لا قائمة enum ثابتة، راجع country-code.ts',
  })
  @IsOptional()
  @Matches(COUNTRY_CODE_PATTERN)
  country?: string;

  @ApiPropertyOptional({ example: 'in_force', enum: ['in_force', 'amended', 'repealed'] })
  @IsOptional()
  @IsIn(['in_force', 'amended', 'repealed'])
  status?: 'in_force' | 'amended' | 'repealed';

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
