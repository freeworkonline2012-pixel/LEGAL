import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';

export class RelatedLawSummaryDto {
  @ApiProperty({ example: '3b9b9a5e-8c1c-4f0d-9f2a-123456789abc' })
  id: string;

  @ApiProperty({ example: 161 })
  law_no: number;

  @ApiProperty({ example: 2024 })
  law_year: number;

  @ApiProperty({ example: 'قرار مجلس إدارة الهيئة رقم (161) لسنة 2024 ...' })
  title: string;
}

/** عنصر قائمة — بلا body الكامل (قد يكون طويلاً جداً لصفحة قائمة) */
export class GuidanceListItemDto {
  @ApiProperty({ example: 'g-uuid' })
  id: string;

  @ApiProperty({ example: 'إجراءات العناية الواجبة لعملاء المؤسسات المالية الخاضعة لرقابة الهيئة' })
  title: string;

  @ApiPropertyOptional({ example: 'وحدة مكافحة غسل الأموال وتمويل الإرهاب', nullable: true })
  issuing_authority: string | null;

  @ApiProperty({ example: 'aml_cft', enum: DOMAIN_KEYS })
  category: string;

  @ApiPropertyOptional({ example: 'https://fra.gov.eg/...', nullable: true })
  official_url: string | null;

  @ApiPropertyOptional({ example: '2020-02-01', nullable: true })
  issued_at: string | null;

  @ApiPropertyOptional({ type: RelatedLawSummaryDto, nullable: true })
  related_law: RelatedLawSummaryDto | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;
}

export class GuidanceListResponseDto {
  @ApiProperty({ type: GuidanceListItemDto, isArray: true })
  items: GuidanceListItemDto[];

  @ApiProperty({ example: 1 })
  total: number;
}

/** تفاصيل كاملة — تشمل النص الكامل (body) */
export class GuidanceDetailResponseDto extends GuidanceListItemDto {
  @ApiPropertyOptional({
    example: 'ملاحظة جودة استخراج النص إن وُجدت',
    nullable: true,
  })
  quality_note: string | null;

  @ApiPropertyOptional({ example: null, nullable: true })
  plain_summary: string | null;

  @ApiProperty({ example: 'النص الكامل للدليل...' })
  body: string;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  updated_at: string;
}
