import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import type { ContractStatus } from '../../database/entities/contract.entity';
import { ContractClauseResponseDto } from './contract-clause-response.dto';

export class ContractResponseDto {
  @ApiProperty() id: string;
  @ApiProperty() original_filename: string;
  @ApiProperty() status: ContractStatus;
  @ApiPropertyOptional({ nullable: true }) extraction_error: string | null;
  @ApiPropertyOptional({ nullable: true }) clause_count: number | null;
  @ApiPropertyOptional({ type: [String] })
  warnings?: string[];
  @ApiPropertyOptional({ type: [ContractClauseResponseDto] })
  clauses?: ContractClauseResponseDto[];
  @ApiProperty() created_at: Date;
}
