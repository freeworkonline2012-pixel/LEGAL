import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import type { HealthResponse } from './health.controller';

export interface DatabaseHealth {
  status: 'ok';
  database: 'up' | 'down';
  latency_ms: number;
}

@Injectable()
export class HealthService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

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
}
