import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsInt, IsOptional, Matches, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';
import { COUNTRY_CODE_PATTERN } from '../../database/entities/country-code';

export class ListGuidanceQueryDto {
  @ApiPropertyOptional({ example: 'aml_cft', enum: DOMAIN_KEYS })
  @IsOptional()
  @IsIn(DOMAIN_KEYS)
  category?: (typeof DOMAIN_KEYS)[number];

  @ApiPropertyOptional({
    example: 'EG',
    description: 'ISO 3166-1 alpha-2 (أو رمز مخصص للمستخدم مثل XA = الوطن العربى) — راجع country-code.ts',
  })
  @IsOptional()
  @Matches(COUNTRY_CODE_PATTERN)
  country?: string;

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
