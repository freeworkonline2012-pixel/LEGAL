import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  Req,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiCreatedResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { OptionalJwtAuthGuard } from '../common/guards/optional-jwt-auth.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { AskQuestionDto } from './dto/ask-question.dto';
import { AnswerResponseDto } from './dto/answer-response.dto';
import {
  QuestionDeleteResponseDto,
  QuestionDetailResponseDto,
  QuestionHistoryResponseDto,
} from './dto/question-response.dto';
import { QuestionsService } from './questions.service';

@ApiTags('questions')
@Controller('questions')
export class QuestionsController {
  constructor(private readonly questionsService: QuestionsService) {}

  @Post()
  @UseGuards(OptionalJwtAuthGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiCreatedResponse({
    description: 'إرسال سؤال → إجابة موثقة بالمصدر + استشهادات + ثقة (أو رفض صريح)',
    type: AnswerResponseDto,
  })
  async ask(
    @Body() dto: AskQuestionDto,
    @Req() request: RequestWithUser,
  ): Promise<AnswerResponseDto> {
    return this.questionsService.ask(dto, {
      userId: request.user?.userId ?? null,
      role: request.user?.role ?? null,
      ipAddress: request.ip ?? null,
      userAgent: request.headers['user-agent'] ?? null,
    });
  }

  @Get('history')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOkResponse({
    description: 'سجل أسئلة المستخدم الحالي',
    type: QuestionHistoryResponseDto,
  })
  history(
    @Req() request: RequestWithUser,
    @Query('limit') limit = 20,
    @Query('offset') offset = 0,
  ): Promise<QuestionHistoryResponseDto> {
    const parsedLimit = Math.min(Math.max(Number(limit) || 20, 1), 100);
    const parsedOffset = Math.max(Number(offset) || 0, 0);
    const userId = request.user?.userId;
    if (!userId) {
      throw new UnauthorizedException('history requires authenticated user');
    }
    return this.questionsService.history(userId, {
      limit: parsedLimit,
      offset: parsedOffset,
    });
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOkResponse({
    description: 'تفاصيل سؤال معين (مالكه أو admin)',
    type: QuestionDetailResponseDto,
  })
  getById(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Req() request: RequestWithUser,
  ): Promise<QuestionDetailResponseDto> {
    const user = request.user;
    if (!user) {
      throw new UnauthorizedException('detail requires authenticated user');
    }
    return this.questionsService.getById(id, {
      userId: user.userId,
      role: user.role,
    });
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOkResponse({
    description: 'حذف سؤال (مالكه أو admin)',
    type: QuestionDeleteResponseDto,
  })
  remove(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Req() request: RequestWithUser,
  ): Promise<QuestionDeleteResponseDto> {
    const user = request.user;
    if (!user) {
      throw new UnauthorizedException('delete requires authenticated user');
    }
    return this.questionsService.remove(id, {
      userId: user.userId,
      role: user.role,
    });
  }
}
