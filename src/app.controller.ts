import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

export interface RootResponse {
  service: string;
  message: string;
}

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getRoot(): RootResponse {
    return this.appService.getRoot();
  }
}
