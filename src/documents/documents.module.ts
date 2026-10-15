import { Module } from '@nestjs/common';
import { AuditModule } from '../audit/audit.module';
import { ExtractionService } from '../contracts/extraction.service';
import { DocumentFactsService } from './document-facts.service';
import { DocumentReaderService } from './document-reader.service';
import { DocumentsController } from './documents.controller';
import { DocumentsService } from './documents.service';
import { OcrService } from './ocr.service';

/**
 * مستندات العميل: استخراج نص + إخفاء + وقائع موثقة لاستيضاح السؤال. بلا جداول ولا هجرات (لا تخزين).
 * يُصدِّر DocumentReaderService (بصمة الملف + الاستخراج + القراءة الآلية) لتستعمله الترجمة القانونية.
 */
@Module({
  imports: [AuditModule],
  controllers: [DocumentsController],
  providers: [DocumentsService, DocumentFactsService, DocumentReaderService, OcrService, ExtractionService],
  exports: [DocumentReaderService],
})
export class DocumentsModule {}
