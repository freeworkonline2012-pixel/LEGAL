import {
  BadRequestException,
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  Req,
  Res,
  StreamableFile,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiProduces, ApiQuery, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Response } from 'express';
import { IsOptional, IsString, MaxLength } from 'class-validator';
import { Roles } from '../common/decorators/roles.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { ExportsService, type ExportActor, type ExportedFile, type ExportFormat } from './exports.service';

class ApproveContractReportDto {
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  note?: string;
}

function parseFormat(raw: string | undefined): ExportFormat {
  const f = (raw ?? 'pdf').toLowerCase();
  if (f !== 'pdf' && f !== 'docx') throw new BadRequestException('format يجب أن يكون pdf أو docx');
  return f;
}

function actorOf(request: RequestWithUser): ExportActor {
  const user = request.user;
  if (!user) throw new UnauthorizedException('authentication required');
  return {
    userId: user.userId,
    role: user.role,
    ipAddress: request.ip ?? null,
    userAgent: (request.headers['user-agent'] as string | undefined) ?? null,
  };
}

/** يرسل الملف كمرفق، بلا تخزين مؤقت (مستند قانونى شخصى)، واسم ملف ASCII فقط. */
function send(res: Response, file: ExportedFile): StreamableFile {
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

@ApiTags('exports')
@ApiBearerAuth()
@Controller('exports')
@UseGuards(JwtAuthGuard)
// توليد المستندات مكلف (PDF عبر متصفح) — سقف أضيق من العام
@Throttle({ default: { limit: 15, ttl: 60_000 } })
export class ExportsController {
  constructor(private readonly exportsService: ExportsService) {}

  /** هل PDF متاح فى هذه البيئة؟ (الواجهة تُخفى زر PDF إن لم يتوفر Chromium؛ وفحص سريع بعد كل نشر) */
  @Get('capabilities')
  capabilities(): { pdf: boolean; docx: boolean } {
    return this.exportsService.capabilities();
  }

  @Get('answers/:id')
  @ApiQuery({ name: 'format', enum: ['pdf', 'docx'], required: false })
  @ApiProduces('application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
  async answer(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query('format') format: string | undefined,
    @Req() request: RequestWithUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    return send(res, await this.exportsService.exportAnswer(id, parseFormat(format), actorOf(request)));
  }

  @Get('governance/:id')
  @ApiQuery({ name: 'format', enum: ['pdf', 'docx'], required: false })
  async governance(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query('format') format: string | undefined,
    @Req() request: RequestWithUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    return send(res, await this.exportsService.exportGovernance(id, parseFormat(format), actorOf(request)));
  }

  @Get('memos/:id')
  @ApiQuery({ name: 'format', enum: ['pdf', 'docx'], required: false })
  async memo(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query('format') format: string | undefined,
    @Req() request: RequestWithUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    return send(res, await this.exportsService.exportMemo(id, parseFormat(format), actorOf(request)));
  }

  @Get('contracts/:id')
  @ApiQuery({ name: 'format', enum: ['pdf', 'docx'], required: false })
  async contract(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query('format') format: string | undefined,
    @Req() request: RequestWithUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    return send(res, await this.exportsService.exportContract(id, parseFormat(format), actorOf(request)));
  }

  @Get('contracts/:id/tracked')
  @ApiOkResponse({ description: 'نسخة Word من العقد بتعديلات متتبَّعة وتعليقات مراجعة (الصياغات المقترحة للاسترشاد)' })
  async contractTracked(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Req() request: RequestWithUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    return send(res, await this.exportsService.exportContractTracked(id, actorOf(request)));
  }

  @Post('contracts/:id/approve')
  @UseGuards(RolesGuard)
  @Roles('admin')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ description: 'اعتماد المراجعة البشرية لتقرير العقد (admin) — شرط إتاحته للعميل' })
  approveContract(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: ApproveContractReportDto,
    @Req() request: RequestWithUser,
  ): Promise<{ approved_at: string; already_approved: boolean }> {
    return this.exportsService.approveContractReport(id, dto.note ?? null, actorOf(request));
  }
}
