import { Module } from '@nestjs/common';
import { DeepseekGenerationService } from './deepseek-generation.service';
import { VoyageEmbeddingsService } from './voyage-embeddings.service';

/**
 * وحدة الذكاء الاصطناعي (EP-04): توليد مقيَّد (DeepSeek) + embeddings دلالية
 * (Voyage AI). كلا المزوّدين يتدهوران بأمان (Graceful Degradation) بلا مفاتيح
 * API — راجع تعليقات كل خدمة على حدة لتفاصيل التصميم وحدوده.
 */
@Module({
  providers: [DeepseekGenerationService, VoyageEmbeddingsService],
  exports: [DeepseekGenerationService, VoyageEmbeddingsService],
})
export class LlmModule {}
