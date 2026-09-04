import { Body, Controller, HttpCode, HttpStatus, Post, Req, UseGuards } from '@nestjs/common';
import { ApiCreatedResponse, ApiTags } from '@nestjs/swagger';
import { OptionalJwtAuthGuard } from '../common/guards/optional-jwt-auth.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { AssessGovernanceDto } from './dto/assess-governance.dto';
import { GovernanceVerdictResponseDto } from './dto/governance-verdict-response.dto';
import { GovernanceService } from './governance.service';

/**
 * Service 3 — راجع تعليق GovernanceService للتصميم الكامل. المصادقة
 * اختيارية (OptionalJwtAuthGuard) اتساقاً مع POST /api/questions — نفس مبدأ
 * "لا تسجيل مطلوب لمسار P0" الموثَّق فى wireframes المنصة؛ يبقى actorId فى
 * سجل التدقيق null للزوار غير المسجَّلين.
 *
 * ⚠️ Phase 1-3 فقط (راجع خطة القسم 4.4): لا واجهة عرض مخصَّصة بعد (Phase 3
 * تشمل أيضاً واجهة أمامية، لم تُبنَ فى هذه الدفعة)، ولا Golden Test Set
 * مخصَّص (Phase 4) — هذا الـendpoint API فقط، غير مربوط بأى تنقُّل فى
 * الواجهة الأمامية الحالية، ودقته غير مقيسة بعد على مجموعة اختبار مخصَّصة.
 */
@ApiTags('governance')
@Controller('governance')
export class GovernanceController {
  constructor(private readonly governanceService: GovernanceService) {}

  @Post('assess')
  @UseGuards(OptionalJwtAuthGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiCreatedResponse({
    description: 'تقييم مطابقة إجراء/قرار مع قوانين ولوائح الحوكمة والالتزام والمخاطر المفهرَسة',
    type: GovernanceVerdictResponseDto,
  })
  async assess(
    @Body() dto: AssessGovernanceDto,
    @Req() request: RequestWithUser,
  ): Promise<GovernanceVerdictResponseDto> {
    return this.governanceService.assess(dto, {
      userId: request.user?.userId ?? null,
      ipAddress: request.ip ?? null,
      userAgent: request.headers['user-agent'] ?? null,
    });
  }
}
