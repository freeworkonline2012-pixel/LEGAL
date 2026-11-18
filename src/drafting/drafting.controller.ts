import { BadRequestException, Body, Controller, Get, HttpCode, HttpStatus, Post, Query, Req, Res, StreamableFile, UnauthorizedException, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiProduces, ApiQuery, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Response } from 'express';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import type { DraftResult, DraftTypeSpec } from './drafting.types';
import { type DraftActor, DraftingService } from './drafting.service';
import { GenerateDraftDto } from './dto/generate-draft.dto';

function actorOf(request: RequestWithUser): DraftActor {
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
 * صياغة العقود: المصادقة إلزامية (مثل بقية خدمات العقود). التوليد حتمى وسريع؛ سقف الطلبات للتنزيل أضيق لأنه يرسم PDF/Word.
 */
@ApiTags('drafting')
@ApiBearerAuth()
@Controller('drafting')
@UseGuards(JwtAuthGuard)
export class DraftingController {
  constructor(private readonly draftingService: DraftingService) {}

  @Get('types')
  @ApiOkResponse({ description: 'أنواع العقود المدعومة وأسئلة كل نوع' })
  types(): { items: readonly DraftTypeSpec[] } {
    return { items: this.draftingService.types() };
  }

  @Post('generate')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 30, ttl: 60_000 } })
  @ApiOkResponse({ description: 'مسودة العقد مع نتيجة فحص الجودة (أو 400 بأخطاء الحقول)' })
  generate(@Body() dto: GenerateDraftDto): DraftResult {
    return this.draftingService.generate(dto.type, dto.role, dto.answers);
  }

  @Post('export')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiQuery({ name: 'format', enum: ['pdf', 'docx'], required: false })
  @ApiProduces('application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
  async export(
    @Body() dto: GenerateDraftDto,
    @Query('format') format: string | undefined,
    @Req() request: RequestWithUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    const f = (format ?? 'docx').toLowerCase();
    if (f !== 'pdf' && f !== 'docx') throw new BadRequestException('format يجب أن يكون pdf أو docx');
    const file = await this.draftingService.export(dto.type, dto.role, dto.answers, f, actorOf(request));
    res.set({
      'Content-Type': file.contentType,
      'Content-Disposition': `attachment; filename="${file.filename}"`,
      'Content-Length': String(file.buffer.length),
      'Cache-Control': 'no-store, max-age=0',
      Pragma: 'no-cache',
      'X-Content-Type-Options': 'nosniff',
    });
    return new StreamableFile(file.buffer);
  }
}
