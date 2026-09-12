import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditModule } from '../audit/audit.module';
import { AuditLog } from '../database/entities/audit-log.entity';
import { Feedback } from '../database/entities/feedback.entity';
import { Question } from '../database/entities/question.entity';
import { User } from '../database/entities/user.entity';
import { DataExportController } from './data-export.controller';
import { DataExportService } from './data-export.service';
import { DataRetentionService } from './data-retention.service';

/**
 * وحدة الخصوصية — المسار التقنى الأول لحل قانون حماية البيانات الشخصية
 * 151/2020 (قرار 2026-09-12): سياسة الاحتفاظ الآلية (DataRetentionService)
 * وحق نقل البيانات (DataExportController/Service). راجع تقرير الجلسة
 * المُسجَّل فى قاعدة المعرفة للسياق الكامل.
 */
@Module({
  imports: [TypeOrmModule.forFeature([User, Question, Feedback, AuditLog]), AuditModule],
  controllers: [DataExportController],
  providers: [DataExportService, DataRetentionService],
})
export class PrivacyModule {}
