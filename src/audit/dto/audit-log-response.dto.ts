import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class AuditLogResponseDto {
  @ApiProperty({ example: 42 })
  id: number;

  @ApiPropertyOptional({ example: '3b9b9a5e-...', nullable: true })
  actor_id: string | null;

  @ApiPropertyOptional({ example: 'user', nullable: true })
  actor_role: string | null;

  @ApiProperty({ example: 'question.asked' })
  action: string;

  @ApiPropertyOptional({ example: 'question', nullable: true })
  resource_type: string | null;

  @ApiPropertyOptional({ example: '5f0a...', nullable: true })
  resource_id: string | null;

  @ApiPropertyOptional({ example: '192.168.1.1', nullable: true })
  ip_address: string | null;

  @ApiPropertyOptional({ example: 'Mozilla/5.0', nullable: true })
  user_agent: string | null;

  @ApiPropertyOptional({ example: { category: 'labor' }, nullable: true })
  metadata: Record<string, unknown> | null;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;
}

export class AuditLogListResponseDto {
  @ApiProperty({ type: AuditLogResponseDto, isArray: true })
  items: AuditLogResponseDto[];

  @ApiProperty({ example: 120 })
  total: number;
}
