import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsInt, IsOptional, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

const LAW_CATEGORIES = [
  'labor',
  'rent',
  'personal_status',
  'traffic',
  'consumer_protection',
  'other',
] as const;

export class ListLawsQueryDto {
  @ApiPropertyOptional({ example: 'labor', enum: LAW_CATEGORIES })
  @IsOptional()
  @IsIn(LAW_CATEGORIES)
  category?: (typeof LAW_CATEGORIES)[number];

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
