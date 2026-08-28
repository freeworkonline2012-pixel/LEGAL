import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
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
import type { LawCategory } from '../../database/entities/law.entity';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';
import { COUNTRY_CODE_PATTERN } from '../../database/entities/country-code';

// T-VOCAB-1: مصدر واحد للمفردات (DOMAIN_KEYS) بدل قائمة مكررة هنا — كانت
// هذه القائمة نسخة يدوية منفصلة نسيت إضافة 'insurance' إليها رغم إضافتها
// لـ DomainKey وقيد قاعدة البيانات فى 2026-08-21 (EP-05)، وهي بالضبط فجوة
// النوع (type safety gap) التى اكتُشفت فى مراجعة ما بعد الإطلاق — إعادة
// استخدام DOMAIN_KEYS هنا يمنع تكرار هذا الخطأ مستقبلاً.
const LAW_CATEGORIES = DOMAIN_KEYS;

const LAW_STATUSES = ['in_force', 'amended', 'repealed'] as const;

export class CreateLawDto {
  @ApiProperty({ example: 12 })
  @IsInt()
  @Min(1)
  law_no: number;

  @ApiProperty({ example: 2003 })
  @IsInt()
  @Min(1800)
  law_year: number;

  @ApiProperty({ example: 'قانون العمل الصادر بالقانون رقم 12 لسنة 2003' })
  @IsString()
  @MaxLength(500)
  title: string;

  @ApiPropertyOptional({ example: 'قانون العمل' })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  short_title?: string;

  @ApiPropertyOptional({
    example: 'labor',
    enum: LAW_CATEGORIES,
  })
  @IsOptional()
  @IsIn(LAW_CATEGORIES)
  category?: LawCategory;

  @ApiPropertyOptional({
    example: 'EG',
    description: 'ISO 3166-1 alpha-2 — افتراضى EG إن لم يُحدَّد',
  })
  @IsOptional()
  @Matches(COUNTRY_CODE_PATTERN)
  country_code?: string;

  @ApiPropertyOptional({
    example: 'in_force',
    enum: LAW_STATUSES,
  })
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
