import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsInt, IsOptional, IsString, IsUUID, MaxLength, Min } from 'class-validator';

export class CreateArticleDto {
  @ApiProperty({ example: '3b9b9a5e-8c1c-4f0d-9f2a-123456789abc' })
  @IsUUID()
  law_id: string;

  @ApiProperty({ example: 110 })
  @IsInt()
  @Min(1)
  article_no: number;

  @ApiPropertyOptional({ example: 'الباب الثاني — عقد العمل الفردي' })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  hierarchical_location?: string;

  @ApiPropertyOptional({ example: 'إجازة العامل السنوية' })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  title?: string;

  @ApiProperty({ example: 'يستحق العامل إجازة سنوية مدفوعة الأجر...' })
  @IsString()
  @MaxLength(20_000)
  body: string;

  @ApiPropertyOptional({ example: 'للعمل الحق في إجازة سنوية بأجر كامل.' })
  @IsOptional()
  @IsString()
  @MaxLength(5_000)
  plain_summary?: string;

  @ApiPropertyOptional({
    example: '2003-07-07',
    description: 'تاريخ سريان الإصدار الأول (افتراضي: تاريخ الإنشاء)',
  })
  @IsOptional()
  @IsDateString()
  effective_from?: string;

  @ApiPropertyOptional({ example: 'إدراج المادة ضمن خط التجميع' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  change_note?: string;
}
