import { Module } from '@nestjs/common';
import { DeepseekGenerationService } from './deepseek-generation.service';
import { VoyageEmbeddingsService } from './voyage-embeddings.service';
import { WebSearchFallbackService } from './web-search-fallback.service';

/**
 * وحدة الذكاء الاصطناعي (EP-04): توليد مقيَّد (DeepSeek) + embeddings دلالية
 * (Voyage AI) + احتياطى بحث الويب المقيَّد (WebSearchFallbackService — Tier 2
 * عند فشل الاسترجاع الموثوق، راجع تعليق ذلك الملف الكامل). كل المزوّدين
 * يتدهورون بأمان (Graceful Degradation) بلا مفاتيح API — راجع تعليقات كل
 * خدمة على حدة لتفاصيل التصميم وحدوده.
 */
@Module({
  providers: [DeepseekGenerationService, VoyageEmbeddingsService, WebSearchFallbackService],
  exports: [DeepseekGenerationService, VoyageEmbeddingsService, WebSearchFallbackService],
})
export class LlmModule {}
