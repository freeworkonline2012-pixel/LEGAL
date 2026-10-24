import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import type { ContractStatus } from '../../database/entities/contract.entity';
import { ContractClauseResponseDto, VerificationDto } from './contract-clause-response.dto';

export class FindingEvidenceDto {
  @ApiProperty() clause_index: number;
  @ApiProperty() clause_label: string;
  @ApiProperty() quote: string;
}

export class ContractFindingDto {
  @ApiProperty() id: string;
  @ApiProperty({ enum: ['missing_clause', 'undefined_term', 'open_term', 'conflict', 'scope_mismatch'] }) kind: string;
  @ApiProperty() kind_label: string;
  @ApiProperty({ enum: ['حرج', 'عالٍ', 'متوسط', 'منخفض'] }) severity: string;
  @ApiProperty() title: string;
  @ApiProperty() explanation: string;
  @ApiPropertyOptional({ nullable: true }) suggestion: string | null;
  @ApiProperty({ type: [FindingEvidenceDto] }) evidence: FindingEvidenceDto[];
  @ApiProperty({ enum: ['rule', 'model'] }) source: string;
  @ApiPropertyOptional({ type: VerificationDto, nullable: true }) verification: VerificationDto | null;
}

export class ContractResponseDto {
  @ApiProperty() id: string;
  @ApiProperty() original_filename: string;
  @ApiProperty() status: ContractStatus;
  @ApiPropertyOptional({ nullable: true }) extraction_error: string | null;
  @ApiPropertyOptional({ nullable: true }) clause_count: number | null;
  @ApiPropertyOptional({ nullable: true }) contract_type: string | null;
  @ApiPropertyOptional({ nullable: true }) client_role: string | null;
  @ApiPropertyOptional({ nullable: true, enum: ['first', 'second'] }) client_party?: 'first' | 'second' | null;
  @ApiPropertyOptional({ type: [String] })
  warnings?: string[];
  @ApiPropertyOptional({ type: [ContractFindingDto], description: 'ملاحظات العقد ككل (بنود غير مرصودة، إحالات غير معرّفة، شروط مفتوحة، تعارض محتمل)' })
  contract_findings?: ContractFindingDto[];
  @ApiPropertyOptional({ nullable: true, enum: ['ok', 'not_configured', 'skipped', 'error'], description: 'حالة تمرير النموذج على العقد كاملاً' })
  contract_findings_model?: 'ok' | 'not_configured' | 'skipped' | 'error' | null;
  @ApiPropertyOptional({ type: [ContractClauseResponseDto] })
  clauses?: ContractClauseResponseDto[];
  @ApiProperty() created_at: Date;
}
