import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsInt, IsOptional, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';

export class ListGuidanceQueryDto {
  @ApiPropertyOptional({ example: 'aml_cft', enum: DOMAIN_KEYS })
  @IsOptional()
  @IsIn(DOMAIN_KEYS)
  category?: (typeof DOMAIN_KEYS)[number];

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
