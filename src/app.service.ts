import { Injectable } from '@nestjs/common';
import type { RootResponse } from './app.controller';

@Injectable()
export class AppService {
  getRoot(): RootResponse {
    return {
      service: 'backend',
      message: 'منصة قانونية عربية — API (Grounded Legal RAG)',
    };
  }
}
