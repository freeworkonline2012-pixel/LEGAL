import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditModule } from '../audit/audit.module';
import { Answer } from '../database/entities/answer.entity';
import { Citation } from '../database/entities/citation.entity';
import { Contract } from '../database/entities/contract.entity';
import { ContractClause } from '../database/entities/contract-clause.entity';
import { GovernanceAssessment } from '../database/entities/governance-assessment.entity';
import { LegalMemo } from '../database/entities/legal-memo.entity';
import { Question } from '../database/entities/question.entity';
import { ExportsController } from './exports.controller';
import { ExportsRetentionService } from './exports-retention.service';
import { ExportsService } from './exports.service';
import { PdfRenderer } from './renderers/pdf.renderer';

/**
 * تنزيل الإجابات والتقارير والمستندات (PDF / Word). نموذج المستند الموحَّد يتسع للخدمات المستقبلية
 * (المذكرات والتقارير القانونية): تكفى إضافة بنّاء جديد يُنتج LegalDocument.
 */
@Module({
  imports: [
    AuditModule,
    TypeOrmModule.forFeature([Answer, Citation, Question, Contract, ContractClause, GovernanceAssessment, LegalMemo]),
  ],
  controllers: [ExportsController],
  providers: [ExportsService, ExportsRetentionService, PdfRenderer],
  // يُشارك مُخرِج PDF (متصفح واحد مشترك) مع الترجمة القانونية
  exports: [PdfRenderer],
})
export class ExportsModule {}
