import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditModule } from '../audit/audit.module';
import { GovernanceAssessment } from '../database/entities/governance-assessment.entity';
import { LlmModule } from '../llm/llm.module';
import { GovernanceController } from './governance.controller';
import { GovernanceService } from './governance.service';

/**
 * Service 3 — مساعد الحوكمة والالتزام والمخاطر (2026-09-04). يستورد
 * AuditModule وLlmModule فقط (نفس اعتماديات QuestionsModule) — بلا
 * TypeOrmModule.forFeature خاص لأن GovernanceService يحقن DataSource مباشرة
 * (نفس نمط QuestionsService) بدل @InjectRepository لكل كيان على حدة.
 */
@Module({
  // TypeOrmModule.forFeature إلزامى لتسجيل GovernanceAssessment (كيان جديد لا يستعمله موديول آخر) —
  // راجع التعليق التاريخى فى contracts.module.ts عن EntityMetadataNotFoundError.
  imports: [AuditModule, LlmModule, TypeOrmModule.forFeature([GovernanceAssessment])],
  controllers: [GovernanceController],
  providers: [GovernanceService],
  exports: [GovernanceService],
})
export class GovernanceModule {}
