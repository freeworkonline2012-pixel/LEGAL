import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { AuditService } from '../audit/audit.service';
import { TranslationService } from './translation.service';

/** حذف الترجمات المنتهية صلاحيتها (48 ساعة من الإنشاء أو 24 ساعة من الاكتمال) كل ساعة — العقد لا يبقى بلا حاجة. */
@Injectable()
export class TranslationRetentionService {
  private readonly logger = new Logger(TranslationRetentionService.name);

  constructor(
    private readonly translations: TranslationService,
    private readonly audit: AuditService,
  ) {}

  @Cron(CronExpression.EVERY_HOUR)
  async sweep(): Promise<void> {
    try {
      const deleted = await this.translations.purgeExpired();
      if (deleted > 0) {
        this.logger.log(`[retention] حُذفت ${deleted} ترجمة منتهية الصلاحية.`);
        await this.audit.record({
          action: 'translation.retention_purge',
          resourceType: 'system',
          metadata: { deleted },
        });
      }
    } catch (err) {
      this.logger.error('[retention] فشلت دورة حذف الترجمات المنتهية — سيُعاد المحاولة بعد ساعة.', err as Error);
    }
  }
}
