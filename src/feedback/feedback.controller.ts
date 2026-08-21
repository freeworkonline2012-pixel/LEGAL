import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiCreatedResponse, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { AuditService } from '../audit/audit.service';
import { CreateFeedbackDto } from './dto/create-feedback.dto';
import { FeedbackResponseDto } from './dto/feedback-response.dto';
import { FeedbackService } from './feedback.service';

@ApiTags('feedback')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('feedback')
export class FeedbackController {
  constructor(
    private readonly feedbackService: FeedbackService,
    private readonly auditService: AuditService,
  ) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiCreatedResponse({
    description: 'تقييم إجابة 👍/👎 (مرة واحدة لكل إجابة)',
    type: FeedbackResponseDto,
  })
  async create(
    @Body() dto: CreateFeedbackDto,
    @Req() request: RequestWithUser,
  ): Promise<FeedbackResponseDto> {
    const user = request.user;
    if (!user) {
      throw new UnauthorizedException('feedback requires authenticated user');
    }
    const result = await this.feedbackService.create(dto, user.userId);

    await this.auditService.record({
      actorId: user.userId,
      actorRole: user.role,
      action: 'feedback.given',
      resourceType: 'answer',
      resourceId: dto.answer_id,
      metadata: { rating: dto.rating },
    });

    return result;
  }
}
