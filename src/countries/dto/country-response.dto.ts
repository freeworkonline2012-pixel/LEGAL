import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CountryResponseDto {
  @ApiProperty({ example: 'EG', description: 'ISO 3166-1 alpha-2' })
  code: string;

  @ApiProperty({ example: 'مصر' })
  name_ar: string;

  @ApiPropertyOptional({ example: 'Egypt', nullable: true })
  name_en: string | null;

  @ApiProperty({ example: 1 })
  display_order: number;

  @ApiProperty({ example: true })
  is_active: boolean;

  @ApiProperty({
    example: 127,
    description:
      'عدد القوانين المُدخَلة فعلياً لهذه الدولة (محسوب حياً — لا قيمة يدوية). ' +
      '0 يعنى دولة "قريباً" لا محتوى فيها بعد.',
  })
  law_count: number;
}

export class CountryListResponseDto {
  @ApiProperty({ type: CountryResponseDto, isArray: true })
  items: CountryResponseDto[];
}
