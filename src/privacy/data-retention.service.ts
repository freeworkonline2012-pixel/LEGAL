import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { AuditLog } from '../database/entities/audit-log.entity';
import { Question } from '../database/entities/question.entity';

const DEFAULT_LINK_RETENTION_DAYS = 730; // ≈ سنتان — قيمة تحفظية مبدئية، راجع env.validation.ts
const DEFAULT_IP_RETENTION_DAYS = 90;

/**
 * خدمة سياسة الاحتفاظ الآلية — المسار التقنى الأول لحل قانون حماية
 * البيانات الشخصية 151/2020 (بند "مدة الاحتفاظ بالبيانات"، مُعلَّم 🔴 فى
 * DPIA بتاريخ 2026-08-21: "لا توجد آلية حذف تلقائي دوري في المخطط الحالي").
 *
 * ⚠️ هذه الخدمة لا تحذف صفوفاً (القيمة التجارية لنص الأسئلة/الإجابات فى
 * تحسين دقة النظام وGolden Test Set candidates موثَّقة وحقيقية — راجع
 * scripts/export_golden_candidates.js) — بل تفصل الربط المُعرِّف بالهوية
 * (user_id، عنوان IP) بعد نافذة زمنية، بحيث يبقى المحتوى مفيداً للأعمال
 * دون أن يظل "بيانات شخصية" مرتبطة بشخص مُعرَّف. هذا هو الفرق الجذرى بين
 * "تقليل المخاطرة القانونية" و"إتلاف بيانات ذات قيمة تجارية حقيقية" — حل لا
 * يضر المشروع، لا حل يُضحّى بقيمته مقابل الامتثال.
 *
 * فترتا الاحتفاظ (DATA_RETENTION_LINK_DAYS/DATA_RETENTION_IP_DAYS) قيم
 * تحفظية مبدئية قابلة للتعديل فوراً عبر متغيرات البيئة بلا إعادة نشر كود —
 * القيمة النهائية المناسبة قانونياً قرار مؤجَّل لجلسة المحامى (راجع تقرير
 * 2026-09-12).
 */
@Injectable()
export class DataRetentionService {
  private readonly logger = new Logger(DataRetentionService.name);

  constructor(
    @InjectRepository(Question)
    private readonly questionRepository: Repository<Question>,
    @InjectRepository(AuditLog)
    private readonly auditLogRepository: Repository<AuditLog>,
    private readonly auditService: AuditService,
    private readonly configService: ConfigService,
  ) {}

  @Cron(CronExpression.EVERY_DAY_AT_3AM)
  async runRetentionSweep(): Promise<void> {
    try {
      const linkResult = await this.severOldQuestionUserLinks();
      const ipResult = await this.anonymizeOldAuditLogIps();

      this.logger.log(
        `[retention] فصل ${linkResult} ربط user_id قديم، وأخفى IP فى ${ipResult} سجل تدقيق قديم.`,
      );

      await this.auditService.record({
        action: 'privacy.retention_sweep_executed',
        resourceType: 'system',
        metadata: {
          questions_unlinked: linkResult,
          audit_logs_ip_anonymized: ipResult,
          link_retention_days: this.linkRetentionDays,
          ip_retention_days: this.ipRetentionDays,
        },
      });
    } catch (err) {
      // فشل هذه المهمة الدورية يجب ألا يُسقِط التطبيق بالكامل (نفس فلسفة
      // Graceful Degradation المُطبَّقة فى بقية المشروع — راجع DEF-2 فى
      // typeorm.config.ts) — يُسجَّل الخطأ ويُعاد المحاولة فى الدورة التالية.
      this.logger.error('[retention] فشلت دورة سياسة الاحتفاظ — سيُعاد المحاولة غداً.', err as Error);
    }
  }

  /** يفصل user_id عن الأسئلة الأقدم من نافذة الاحتفاظ. يُعيد عدد الصفوف المتأثرة. */
  private async severOldQuestionUserLinks(): Promise<number> {
    const cutoff = this.daysAgo(this.linkRetentionDays);
    const result = await this.questionRepository
      .createQueryBuilder()
      .update(Question)
      .set({ userId: null })
      .where('user_id IS NOT NULL')
      .andWhere('created_at < :cutoff', { cutoff })
      .execute();
    return result.affected ?? 0;
  }

  /** يُخفى IP/User-Agent فى سجلات التدقيق الأقدم من نافذة الاحتفاظ. يُعيد عدد الصفوف المتأثرة. */
  private async anonymizeOldAuditLogIps(): Promise<number> {
    const cutoff = this.daysAgo(this.ipRetentionDays);
    const result = await this.auditLogRepository
      .createQueryBuilder()
      .update(AuditLog)
      .set({ ipAddress: null, userAgent: null })
      .where('ip_address IS NOT NULL')
      .andWhere('created_at < :cutoff', { cutoff })
      .execute();
    return result.affected ?? 0;
  }

  private daysAgo(days: number): Date {
    return new Date(Date.now() - days * 24 * 60 * 60 * 1000);
  }

  private get linkRetentionDays(): number {
    return this.configService.get<number>('DATA_RETENTION_LINK_DAYS') ?? DEFAULT_LINK_RETENTION_DAYS;
  }

  private get ipRetentionDays(): number {
    return this.configService.get<number>('DATA_RETENTION_IP_DAYS') ?? DEFAULT_IP_RETENTION_DAYS;
  }
}
