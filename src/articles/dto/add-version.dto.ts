import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsInt, IsOptional, IsString, MaxLength, Min } from 'class-validator';

export class AddVersionDto {
  @ApiProperty({ example: 'النص المعدل للمادة بعد تعديل القانون رقم 48 لسنة 2022' })
  @IsString()
  @MaxLength(20_000)
  body: string;

  @ApiProperty({
    example: '2022-08-01',
    description: 'تاريخ سريان الإصدار الجديد (يغلق الإصدار الحالي قبله بيوم)',
  })
  @IsDateString()
  effective_from: string;

  @ApiPropertyOptional({ example: 48 })
  @IsOptional()
  @IsInt()
  @Min(1)
  amended_by_law_no?: number;

  @ApiPropertyOptional({ example: 2022 })
  @IsOptional()
  @IsInt()
  @Min(1800)
  amended_by_law_year?: number;

  @ApiPropertyOptional({ example: 'تعديل نص المادة وفق الجريدة الرسمية' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  change_note?: string;
}
