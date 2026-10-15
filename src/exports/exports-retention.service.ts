import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { GovernanceAssessment } from '../database/entities/governance-assessment.entity';

const DEFAULT_LINK_RETENTION_DAYS = 730;

/**
 * سياسة الاحتفاظ لتقييمات الحوكمة المحفوظة (migrations/203) — نفس نافذة وفلسفة DataRetentionService
 * للأسئلة (151/2020): بعد DATA_RETENTION_LINK_DAYS يُفصَل الربط بالمستخدم فيبقى المحتوى مُشفَّراً بلا هوية.
 * خدمة مستقلة عمداً كى لا تُغيَّر خدمة الاحتفاظ القائمة ولا اختباراتها.
 */
@Injectable()
export class ExportsRetentionService {
  private readonly logger = new Logger(ExportsRetentionService.name);

  constructor(
    @InjectRepository(GovernanceAssessment)
    private readonly repository: Repository<GovernanceAssessment>,
    private readonly auditService: AuditService,
    private readonly configService: ConfigService,
  ) {}

  @Cron(CronExpression.EVERY_DAY_AT_3AM)
  async sweep(): Promise<void> {
    try {
      const days = this.configService.get<number>('DATA_RETENTION_LINK_DAYS') ?? DEFAULT_LINK_RETENTION_DAYS;
      const cutoff = new Date(Date.now() - days * 24 * 60 * 60 * 1000);
      const result = await this.repository
        .createQueryBuilder()
        .update(GovernanceAssessment)
        .set({ userId: null })
        .where('user_id IS NOT NULL')
        .andWhere('created_at < :cutoff', { cutoff })
        .execute();
      const unlinked = result.affected ?? 0;
      this.logger.log(`[retention] فصل ${unlinked} ربط user_id قديم من تقييمات الحوكمة.`);
      await this.auditService.record({
        action: 'privacy.retention_sweep_executed',
        resourceType: 'system',
        metadata: { governance_assessments_unlinked: unlinked, link_retention_days: days },
      });
    } catch (err) {
      this.logger.error('[retention] فشلت دورة احتفاظ تقييمات الحوكمة — سيُعاد المحاولة غداً.', err as Error);
    }
  }
}
