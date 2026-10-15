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
import { Throttle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { CreateMemoDto } from './dto/create-memo.dto';
import { MemosService, type CreateMemoResult, type MemoActor, type MemoSummary } from './memos.service';

function actorOf(request: RequestWithUser): MemoActor {
  const user = request.user;
  if (!user) throw new UnauthorizedException('authentication required');
  return {
    userId: user.userId,
    role: user.role,
    ipAddress: request.ip ?? null,
    userAgent: (request.headers['user-agent'] as string | undefined) ?? null,
  };
}

/**
 * المذكرات والتقارير القانونية. المصادقة إلزامية (المذكرة مملوكة لمستخدم وتُنزَّل من حسابه).
 * التوليد مكلف (استرجاع + نداءات نموذج) فسقف الطلبات أضيق من العام: 5 فى الدقيقة.
 */
@ApiTags('memos')
@ApiBearerAuth()
@Controller('memos')
@UseGuards(JwtAuthGuard)
export class MemosController {
  constructor(private readonly memosService: MemosService) {}

  @Post()
  @Throttle({ default: { limit: 5, ttl: 60_000 } })
  @HttpCode(HttpStatus.CREATED)
  @ApiCreatedResponse({ description: 'مسودة مذكرة/تقرير مقيَّدة بالمصادر (أو 422 عند غياب السند القانونى)' })
  create(@Body() dto: CreateMemoDto, @Req() request: RequestWithUser): Promise<CreateMemoResult> {
    return this.memosService.create(dto, actorOf(request));
  }

  @Get()
  @ApiOkResponse({ description: 'مذكرات المستخدم الحالى' })
  list(
    @Req() request: RequestWithUser,
    @Query('limit') limit = 20,
    @Query('offset') offset = 0,
  ): Promise<{ items: MemoSummary[]; total: number }> {
    return this.memosService.list(actorOf(request), Number(limit) || 20, Number(offset) || 0);
  }

  @Delete(':id')
  @ApiOkResponse({ description: 'حذف مذكرة (مالكها أو admin)' })
  remove(@Param('id', new ParseUUIDPipe()) id: string, @Req() request: RequestWithUser): Promise<{ success: boolean }> {
    return this.memosService.remove(id, actorOf(request));
  }
}
