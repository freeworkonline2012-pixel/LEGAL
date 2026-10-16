import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';
import { LEGAL_REFERENCE_TYPES } from '../../database/entities/legal-reference.entity';

export class LegalReferenceListItemDto {
  @ApiProperty() id: string;
  @ApiProperty() title: string;
  @ApiPropertyOptional({ nullable: true }) author: string | null;
  @ApiPropertyOptional({ nullable: true }) publisher: string | null;
  @ApiPropertyOptional({ nullable: true }) edition: string | null;
  @ApiPropertyOptional({ nullable: true }) published_year: number | null;
  @ApiProperty({ enum: LEGAL_REFERENCE_TYPES }) reference_type: string;
  @ApiProperty({ example: 'EG' }) country_code: string;
  @ApiProperty({ enum: DOMAIN_KEYS }) category: string;
  @ApiPropertyOptional({ nullable: true }) summary: string | null;
  @ApiProperty({ description: 'عدد الأقسام' }) section_count: number;
  @ApiProperty() created_at: string;
}

export class LegalReferenceListResponseDto {
  @ApiProperty({ type: LegalReferenceListItemDto, isArray: true })
  items: LegalReferenceListItemDto[];

  @ApiProperty() total: number;
}

export class LegalReferenceTocEntryDto {
  @ApiProperty() seq: number;
  @ApiPropertyOptional({ nullable: true }) heading: string | null;
  @ApiPropertyOptional({ nullable: true }) page_from: number | null;
  @ApiPropertyOptional({ nullable: true }) page_to: number | null;
}

export class LegalReferenceDetailResponseDto extends LegalReferenceListItemDto {
  @ApiPropertyOptional({ nullable: true }) source_note: string | null;
  @ApiPropertyOptional({ nullable: true }) rights_note: string | null;
  @ApiProperty({ type: LegalReferenceTocEntryDto, isArray: true })
  toc: LegalReferenceTocEntryDto[];
}

export class LegalReferenceSectionResponseDto {
  @ApiProperty() reference_id: string;
  @ApiProperty() reference_title: string;
  @ApiProperty() seq: number;
  @ApiPropertyOptional({ nullable: true }) heading: string | null;
  @ApiPropertyOptional({ nullable: true }) page_from: number | null;
  @ApiPropertyOptional({ nullable: true }) page_to: number | null;
  @ApiProperty() body: string;
  @ApiPropertyOptional({ nullable: true }) prev_seq: number | null;
  @ApiPropertyOptional({ nullable: true }) next_seq: number | null;
}

export class LegalReferenceSearchHitDto {
  @ApiProperty() reference_id: string;
  @ApiProperty() reference_title: string;
  @ApiPropertyOptional({ nullable: true }) author: string | null;
  @ApiProperty() reference_type: string;
  @ApiProperty() country_code: string;
  @ApiProperty() seq: number;
  @ApiPropertyOptional({ nullable: true }) heading: string | null;
  @ApiPropertyOptional({ nullable: true }) page_from: number | null;
  @ApiPropertyOptional({ nullable: true }) page_to: number | null;
  @ApiProperty({ description: 'مقتطف من القسم؛ مواضع التطابق محاطة بـ [[ ]]' })
  snippet: string;
}

export class LegalReferenceSearchResponseDto {
  @ApiProperty({ type: LegalReferenceSearchHitDto, isArray: true })
  items: LegalReferenceSearchHitDto[];

  @ApiProperty() total: number;
}
