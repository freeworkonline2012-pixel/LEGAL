import {
  BadRequestException,
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  UnauthorizedException,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { AnalyzeDocumentDto } from './dto/analyze-document.dto';
import { DocumentsService, type AnalyzeDocumentResult } from './documents.service';

const MAX_UPLOAD_BYTES = 8 * 1024 * 1024;

/**
 * مستندات العميل لاستيضاح سؤاله. المصادقة إلزامية (بيانات خاصة)، والسقف 6 طلبات فى الدقيقة
 * (كل طلب نداء نموذج خارجى وربما قراءة آلية). لا شىء يُخزَّن — راجع تعليق DocumentsService.
 */
@ApiTags('documents')
@ApiBearerAuth()
@Controller('documents')
@UseGuards(JwtAuthGuard)
export class DocumentsController {
  constructor(private readonly documents: DocumentsService) {}

  @Post('analyze')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 6, ttl: 60_000 } })
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MAX_UPLOAD_BYTES, files: 1 } }))
  @ApiConsumes('multipart/form-data')
  @ApiOkResponse({ description: 'وقائع مستخرجة من المستند للمراجعة (لا تُخزَّن)' })
  async analyze(
    @UploadedFile() file: Express.Multer.File | undefined,
    @Body() dto: AnalyzeDocumentDto,
    @Req() request: RequestWithUser,
  ): Promise<AnalyzeDocumentResult> {
    const user = request.user;
    if (!user) throw new UnauthorizedException('authentication required');
    if (!file) throw new BadRequestException('لم يُرفَع أى ملف (الحقل المتوقَّع: file)');
    return this.documents.analyze({ buffer: file.buffer, size: file.size }, dto.question, {
      userId: user.userId,
      role: user.role,
      ipAddress: request.ip ?? null,
      userAgent: (request.headers['user-agent'] as string | undefined) ?? null,
    });
  }
}
