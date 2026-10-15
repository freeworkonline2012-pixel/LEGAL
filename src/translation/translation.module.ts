import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuditModule } from '../audit/audit.module';
import { LegalGlossaryTerm } from '../database/entities/legal-glossary-term.entity';
import { LegalTranslation } from '../database/entities/legal-translation.entity';
import { DocumentsModule } from '../documents/documents.module';
import { ExportsModule } from '../exports/exports.module';
import { GlossaryService } from './glossary.service';
import { TranslationController } from './translation.controller';
import { TranslationModelService } from './translation-model.service';
import { TranslationRetentionService } from './translation-retention.service';
import { TranslationService } from './translation.service';

/**
 * الترجمة القانونية للعقود (عربى <-> إنجليزى). هجرة 205. تعيد استعمال قارئ المستندات (استخراج + OCR) من
 * DocumentsModule ومُخرِج PDF المشترك من ExportsModule.
 */
@Module({
  imports: [
    AuditModule,
    DocumentsModule,
    ExportsModule,
    TypeOrmModule.forFeature([LegalTranslation, LegalGlossaryTerm]),
  ],
  controllers: [TranslationController],
  providers: [TranslationService, TranslationModelService, GlossaryService, TranslationRetentionService],
})
export class TranslationModule {}
