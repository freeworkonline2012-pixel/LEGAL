import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { AuditService } from '../audit/audit.service';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import type { AuthenticatedUser } from '../common/interfaces/authenticated-user.interface';
import { DataExportService } from './data-export.service';
import { DataExportResponseDto } from './dto/data-export-response.dto';

/** عتبة معتدلة — التصدير عملية أثقل من قراءة عادية (عدة JOIN)، ولا حاجة لتكرارها كثيراً */
const EXPORT_THROTTLE = { default: { limit: 5, ttl: 60_000 } };

@ApiTags('privacy')
@Controller('privacy')
export class DataExportController {
  constructor(
    private readonly dataExportService: DataExportService,
    private readonly auditService: AuditService,
  ) {}

  @Get('me/export')
  @UseGuards(JwtAuthGuard)
  @Throttle(EXPORT_THROTTLE)
  @ApiBearerAuth()
  @ApiOkResponse({
    description:
      'تصدير كامل لبيانات المستخدم الحالى (حق نقل البيانات) — الملف الشخصى، الأسئلة والإجابات، والتقييمات',
    type: DataExportResponseDto,
  })
  async exportMyData(@CurrentUser() user: AuthenticatedUser): Promise<DataExportResponseDto> {
    const result = await this.dataExportService.exportForUser(user.userId);
    await this.auditService.record({
      actorId: user.userId,
      actorRole: user.role,
      action: 'privacy.data_exported',
      resourceType: 'user',
      resourceId: user.userId,
    });
    return result;
  }
}
