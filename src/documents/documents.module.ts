import { Module } from '@nestjs/common';
import { AuditModule } from '../audit/audit.module';
import { ExtractionService } from '../contracts/extraction.service';
import { DocumentFactsService } from './document-facts.service';
import { DocumentsController } from './documents.controller';
import { DocumentsService } from './documents.service';
import { OcrService } from './ocr.service';

/** مستندات العميل لاستيضاح السؤال: استخراج نص + إخفاء + وقائع موثقة. بلا جداول ولا هجرات (لا تخزين). */
@Module({
  imports: [AuditModule],
  controllers: [DocumentsController],
  providers: [DocumentsService, DocumentFactsService, OcrService, ExtractionService],
})
export class DocumentsModule {}
