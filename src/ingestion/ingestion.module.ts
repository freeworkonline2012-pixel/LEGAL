import { Module } from '@nestjs/common';
import { LlmModule } from '../llm/llm.module';
import { IngestionService } from './ingestion.service';

@Module({
  imports: [LlmModule],
  providers: [IngestionService],
  exports: [IngestionService],
})
export class IngestionModule {}
