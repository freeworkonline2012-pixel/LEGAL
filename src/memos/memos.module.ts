import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditModule } from '../audit/audit.module';
import { LegalMemo } from '../database/entities/legal-memo.entity';
import { QuestionsModule } from '../questions/questions.module';
import { MemosController } from './memos.controller';
import { MemosService } from './memos.service';

/**
 * المذكرات والتقارير القانونية (migrations/204). تعيد استعمال QuestionsService (مُصدَّر من QuestionsModule)
 * بدل أى استرجاع/توليد جديد — راجع تعليق MemosService. forFeature إلزامى لتسجيل الكيان الجديد.
 */
@Module({
  imports: [AuditModule, QuestionsModule, TypeOrmModule.forFeature([LegalMemo])],
  controllers: [MemosController],
  providers: [MemosService],
})
export class MemosModule {}
