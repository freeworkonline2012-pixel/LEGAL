import { BadRequestException, Body, Controller, Delete, Get, HttpCode, HttpStatus, Put, Req, UnauthorizedException, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { PLAYBOOK_LIMITS, builtInCatalog, parseOfficePlaybookConfig, type CatalogRule, type OfficePlaybookConfig } from './office-playbook';
import { OfficePlaybookService, type StoredPlaybook } from './office-playbook.service';

export interface OfficePlaybookView extends StoredPlaybook {
  catalog: CatalogRule[];
  limits: typeof PLAYBOOK_LIMITS;
}

function userIdOf(request: RequestWithUser): string {
  const user = request.user;
  if (!user) throw new UnauthorizedException('authentication required');
  return user.userId;
}

/**
 * Playbook المكتب: كل حساب يرى ويعدّل إعداده هو فقط (المعرّف من الرمز لا من الطلب، فلا وصول لإعداد غيره).
 * يُطبَّق على العقود التى تُرفع بعد الحفظ؛ لا يعيد تقييم عقود سبق تدقيقها (تقريرها يحمل رقم الإعداد الذى طُبّق عليه).
 */
@ApiTags('office-playbook')
@ApiBearerAuth()
@Controller('office-playbook')
@UseGuards(JwtAuthGuard)
export class OfficePlaybookController {
  constructor(private readonly service: OfficePlaybookService) {}

  private view(stored: StoredPlaybook): OfficePlaybookView {
    return { ...stored, catalog: builtInCatalog(), limits: PLAYBOOK_LIMITS };
  }

  @Get()
  async get(@Req() request: RequestWithUser): Promise<OfficePlaybookView> {
    return this.view(await this.service.get(userIdOf(request)));
  }

  @Put()
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 20, ttl: 60_000 } })
  async put(@Body() body: Record<string, unknown>, @Req() request: RequestWithUser): Promise<OfficePlaybookView> {
    const userId = userIdOf(request);
    const parsed = parseOfficePlaybookConfig(body, 'strict');
    if (!parsed.ok) throw new BadRequestException({ message: 'إعداد Playbook غير صالح', errors: parsed.errors });
    const config: OfficePlaybookConfig = parsed.config;
    return this.view(await this.service.save(userId, config));
  }

  @Delete()
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  async reset(@Req() request: RequestWithUser): Promise<OfficePlaybookView> {
    return this.view(await this.service.reset(userIdOf(request)));
  }
}
