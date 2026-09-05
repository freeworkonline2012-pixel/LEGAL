import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { VoyageEmbeddingsService } from '../llm/voyage-embeddings.service';
import type { HealthResponse } from './health.controller';

export interface DatabaseHealth {
  status: 'ok';
  database: 'up' | 'down';
  latency_ms: number;
}

/**
 * حادثة 2026-09-05: قياس دقة خدمة الحوكمة (36 استدعاء حقيقى) كشف أن حساب
 * Voyage AI بلا وسيلة دفع مسجَّلة يُقيَّد بـ3 RPM، فيفشل embed()/rerank()
 * تكراراً بصمت نسبى (سطر سجلّ خام لا يراقبه أحد)، ويتدهور الاسترجاع لـFTS
 * الخام بلا تحذير مرئى — راجع VoyageEmbeddingsService لتفاصيل الإصلاح
 * الكامل (إعادة محاولة + عدّادات). هذا الحقل يكشف تلك العدّادات هنا كى لا
 * يتكرر هذا الاكتشاف صدفة فقط عند قياس دقة يدوى.
 */
export interface VoyageHealth {
  status: 'ok';
  configured: boolean;
  rerank_rate_limit_count: number;
  rerank_failure_count: number;
  embed_rate_limit_count: number;
  embed_failure_count: number;
}

@Injectable()
export class HealthService {
  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly voyageEmbeddingsService: VoyageEmbeddingsService,
  ) {}

  getHealth(): HealthResponse {
    return {
      status: 'ok',
      service: 'backend',
      timestamp: new Date().toISOString(),
    };
  }

  async checkDatabase(): Promise<DatabaseHealth> {
    const startedAt = Date.now();
    try {
      await this.dataSource.query('SELECT 1');
      return {
        status: 'ok',
        database: 'up',
        latency_ms: Date.now() - startedAt,
      };
    } catch {
      return {
        status: 'ok',
        database: 'down',
        latency_ms: Date.now() - startedAt,
      };
    }
  }

  checkVoyage(): VoyageHealth {
    return {
      status: 'ok',
      ...this.voyageEmbeddingsService.getDegradationStats(),
    };
  }
}
