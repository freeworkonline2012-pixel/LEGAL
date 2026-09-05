import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { DatabaseHealth, HealthService, VoyageHealth } from './health.service';

export interface HealthResponse {
  status: string;
  service: string;
  timestamp: string;
}

@ApiTags('health')
@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  @ApiOkResponse({
    description: 'فحص صحة الخدمة (العقد الثابت مع الواجهة)',
    schema: {
      type: 'object',
      properties: {
        status: { type: 'string', example: 'ok' },
        service: { type: 'string', example: 'backend' },
        timestamp: { type: 'string', example: '2026-01-01T10:00:00.000Z' },
      },
    },
  })
  getHealth(): HealthResponse {
    return this.healthService.getHealth();
  }

  @Get('db')
  @ApiOkResponse({
    description: 'فحص الاتصال بقاعدة البيانات',
    schema: {
      type: 'object',
      properties: {
        status: { type: 'string', example: 'ok' },
        database: { type: 'string', enum: ['up', 'down'], example: 'up' },
        latency_ms: { type: 'number', example: 3 },
      },
    },
  })
  checkDatabase(): Promise<DatabaseHealth> {
    return this.healthService.checkDatabase();
  }

  @Get('voyage')
  @ApiOkResponse({
    description:
      'عدّادات تدهور Voyage AI (embeddings/rerank) — تكشف تكرار 429 (غالباً بسبب ' +
      'غياب وسيلة دفع مسجَّلة فى حساب Voyage) الذى يُسقط الاسترجاع لـFTS الخام ' +
      'بلا بحث دلالى أو rerank دون أى أثر ظاهر غير سجلّات الخادم الخام.',
    schema: {
      type: 'object',
      properties: {
        status: { type: 'string', example: 'ok' },
        configured: { type: 'boolean', example: true },
        rerank_rate_limit_count: { type: 'number', example: 0 },
        rerank_failure_count: { type: 'number', example: 0 },
        embed_rate_limit_count: { type: 'number', example: 0 },
        embed_failure_count: { type: 'number', example: 0 },
      },
    },
  })
  checkVoyage(): VoyageHealth {
    return this.healthService.checkVoyage();
  }
}
