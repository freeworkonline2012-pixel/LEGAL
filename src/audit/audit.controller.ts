import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Roles } from '../common/decorators/roles.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { AuditService } from './audit.service';
import { ListAuditLogsQueryDto } from './dto/list-audit-logs-query.dto';
import { AuditLogListResponseDto } from './dto/audit-log-response.dto';

@ApiTags('audit')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('audit-logs')
export class AuditController {
  constructor(private readonly auditService: AuditService) {}

  @Get()
  @Roles('admin')
  @ApiOkResponse({
    description: 'قائمة سجل التدقيق (admin فقط)',
    type: AuditLogListResponseDto,
  })
  async list(@Query() query: ListAuditLogsQueryDto): Promise<AuditLogListResponseDto> {
    return this.auditService.list({
      actorId: query.actor_id,
      action: query.action,
      limit: query.limit,
      offset: query.offset,
    });
  }
}
