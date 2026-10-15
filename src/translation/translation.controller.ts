import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseIntPipe,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  Req,
  Res,
  StreamableFile,
  UnauthorizedException,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { Type } from 'class-transformer';
import { ArrayMaxSize, IsArray, IsOptional, IsString, MaxLength, ValidateNested } from 'class-validator';
import type { Response } from 'express';
import { Roles } from '../common/decorators/roles.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { CreateTranslationDto, EditUnitDto, ImportGlossaryTermDto } from './dto/translation.dto';
import { GlossaryService } from './glossary.service';
import type { TranslationLayout } from './translation-document';
import {
  TranslationService,
  type ExportedTranslation,
  type TranslationActor,
  type TranslationView,
  type UnitsPage,
} from './translation.service';

const MAX_UPLOAD_BYTES = 10 * 1024 * 1024;

class GlossaryRowDto extends ImportGlossaryTermDto {
  @IsOptional()
  @IsString()
  @MaxLength(30)
  domain?: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  note?: string;
}

class ImportGlossaryDto {
  @IsString()
  @MaxLength(80)
  source: string;

  @IsArray()
  @ArrayMaxSize(500)
  @ValidateNested({ each: true })
  @Type(() => GlossaryRowDto)
  terms: GlossaryRowDto[];
}

function actorOf(request: RequestWithUser): TranslationActor {
  const user = request.user;
  if (!user) throw new UnauthorizedException('authentication required');
  return {
    userId: user.userId,
    role: user.role,
    ipAddress: request.ip ?? null,
    userAgent: (request.headers['user-agent'] as string | undefined) ?? null,
  };
}

function send(res: Response, file: ExportedTranslation): StreamableFile {
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

/**
 * الترجمة القانونية للعقود. مصادقة إلزامية (عقود حقيقية)، وكل مسار يتحقق من ملكية المهمة.
 * الإنشاء مكلف (قراءة/OCR + نداء تحليل) فسقفه ضيق؛ والخطوات يقودها العميل بسقف أوسع.
 */
@ApiTags('translations')
@ApiBearerAuth()
@Controller('translations')
@UseGuards(JwtAuthGuard)
export class TranslationController {
  constructor(
    private readonly service: TranslationService,
    private readonly glossary: GlossaryService,
  ) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @Throttle({ default: { limit: 4, ttl: 60_000 } })
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MAX_UPLOAD_BYTES, files: 1 } }))
  @ApiConsumes('multipart/form-data')
  create(
    @UploadedFile() file: Express.Multer.File | undefined,
    @Body() dto: CreateTranslationDto,
    @Req() request: RequestWithUser,
  ): Promise<TranslationView> {
    if (!file) throw new BadRequestException('لم يُرفَع أى ملف (الحقل المتوقَّع: file)');
    return this.service.create(
      { buffer: file.buffer, originalname: file.originalname, size: file.size },
      dto.target_lang,
      actorOf(request),
    );
  }

  @Post(':id/step')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 40, ttl: 60_000 } })
  step(@Param('id', new ParseUUIDPipe()) id: string, @Req() request: RequestWithUser): Promise<TranslationView> {
    return this.service.step(id, actorOf(request));
  }

  @Get(':id')
  get(@Param('id', new ParseUUIDPipe()) id: string, @Req() request: RequestWithUser): Promise<TranslationView> {
    return this.service.get(id, actorOf(request));
  }

  @Get(':id/units')
  units(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query('offset') offset: string | undefined,
    @Query('limit') limit: string | undefined,
    @Req() request: RequestWithUser,
  ): Promise<UnitsPage> {
    return this.service.units(id, Number(offset ?? 0), Number(limit ?? 50), actorOf(request));
  }

  @Patch(':id/units/:n')
  editUnit(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Param('n', ParseIntPipe) n: number,
    @Body() dto: EditUnitDto,
    @Req() request: RequestWithUser,
  ) {
    return this.service.editUnit(id, n, dto.text, actorOf(request));
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async remove(@Param('id', new ParseUUIDPipe()) id: string, @Req() request: RequestWithUser): Promise<void> {
    await this.service.remove(id, actorOf(request));
  }

  @Get(':id/download')
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  async download(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query('format') format: string | undefined,
    @Query('layout') layout: string | undefined,
    @Req() request: RequestWithUser,
    @Res({ passthrough: true }) res: Response,
  ): Promise<StreamableFile> {
    const f = (format ?? 'docx').toLowerCase();
    if (f !== 'pdf' && f !== 'docx') throw new BadRequestException('format يجب أن يكون pdf أو docx');
    const l = (layout ?? 'translation').toLowerCase();
    if (l !== 'translation' && l !== 'bilingual') throw new BadRequestException('layout يجب أن يكون translation أو bilingual');
    return send(res, await this.service.download(id, f, l as TranslationLayout, actorOf(request)));
  }

  /** توسيع قاموس المصطلحات (admin): يُستعمل لإضافة مراجع الصياغة القانونية لاحقاً دون تعديل كود. */
  @Post('glossary/import')
  @UseGuards(RolesGuard)
  @Roles('admin')
  @HttpCode(HttpStatus.OK)
  importGlossary(@Body() dto: ImportGlossaryDto) {
    return this.glossary.importTerms(dto.terms, dto.source);
  }
}
