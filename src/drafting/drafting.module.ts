import { Module } from '@nestjs/common';
import { AuditModule } from '../audit/audit.module';
import { ExportsModule } from '../exports/exports.module';
import { DraftingController } from './drafting.controller';
import { DraftingService } from './drafting.service';

/**
 * صياغة العقود (قوالب حتمية + بوابة جودة). يعيد استعمال PdfRenderer من ExportsModule ومُخرِج Word نفسه.
 */
@Module({
  imports: [AuditModule, ExportsModule],
  controllers: [DraftingController],
  providers: [DraftingService],
})
export class DraftingModule {}
