import { Module } from '@nestjs/common';
import { AnthropicGenerationService } from './anthropic-generation.service';
import { VoyageEmbeddingsService } from './voyage-embeddings.service';

/**
 * وحدة الذكاء الاصطناعي (EP-04): توليد مقيَّد (Claude) + embeddings دلالية
 * (Voyage AI). كلا المزوّدين يتدهوران بأمان (Graceful Degradation) بلا مفاتيح
 * API — راجع تعليقات كل خدمة على حدة لتفاصيل التصميم وحدوده.
 */
@Module({
  providers: [AnthropicGenerationService, VoyageEmbeddingsService],
  exports: [AnthropicGenerationService, VoyageEmbeddingsService],
})
export class LlmModule {}
