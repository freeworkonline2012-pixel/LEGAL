import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLog } from '../database/entities/audit-log.entity';
import { AuditLogResponseDto } from './dto/audit-log-response.dto';

export interface AuditEntryInput {
  actorId?: string | null;
  actorRole?: string | null;
  action: string;
  resourceType?: string | null;
  resourceId?: string | null;
  ipAddress?: string | null;
  userAgent?: string | null;
  metadata?: Record<string, unknown> | null;
}

export interface AuditListQuery {
  actorId?: string;
  action?: string;
  limit: number;
  offset: number;
}

export interface AuditListResult {
  items: AuditLogResponseDto[];
  total: number;
}

/**
 * سجل تدقيق append-only (F-12 / EP-09).
 * لا تُكشف أي طريقة update/delete — الكتابة INSERT فقط، والقراءة مقصورة على admin.
 */
@Injectable()
export class AuditService {
  constructor(
    @InjectRepository(AuditLog)
    private readonly auditRepository: Repository<AuditLog>,
  ) {}

  async record(input: AuditEntryInput): Promise<void> {
    const entry = this.auditRepository.create({
      actorId: input.actorId ?? null,
      actorRole: input.actorRole ?? null,
      action: input.action,
      resourceType: input.resourceType ?? null,
      resourceId: input.resourceId ?? null,
      ipAddress: input.ipAddress ?? null,
      userAgent: input.userAgent ?? null,
      metadata: input.metadata ?? null,
    });
    await this.auditRepository.save(entry);
  }

  async list(query: AuditListQuery): Promise<AuditListResult> {
    const qb = this.auditRepository.createQueryBuilder('log');

    if (query.actorId) {
      qb.andWhere('log.actor_id = :actorId', { actorId: query.actorId });
    }
    if (query.action) {
      qb.andWhere('log.action = :action', { action: query.action });
    }

    const [items, total] = await qb
      .orderBy('log.created_at', 'DESC')
      .skip(query.offset)
      .take(query.limit)
      .getManyAndCount();

    return {
      items: items.map((entry) => this.toResponse(entry)),
      total,
    };
  }

  private toResponse(entry: AuditLog): AuditLogResponseDto {
    return {
      id: entry.id,
      actor_id: entry.actorId,
      actor_role: entry.actorRole,
      action: entry.action,
      resource_type: entry.resourceType,
      resource_id: entry.resourceId,
      ip_address: entry.ipAddress,
      user_agent: entry.userAgent,
      metadata: entry.metadata,
      created_at: entry.createdAt.toISOString(),
    };
  }
}
