import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsOptional } from 'class-validator';

export class GetArticleQueryDto {
  @ApiPropertyOptional({
    example: '2020-01-01',
    description: 'تاريخ YYYY-MM-DD لاسترجاع النسخة السارية فيه (افتراضي: اليوم)',
  })
  @IsOptional()
  @IsDateString()
  as_of?: string;
}
