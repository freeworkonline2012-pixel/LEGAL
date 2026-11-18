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
  Req,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiConsumes, ApiCreatedResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import type { RequestWithUser } from '../common/interfaces/request-with-user.interface';
import { ContractClauseResponseDto } from './dto/contract-clause-response.dto';
import { ContractResponseDto } from './dto/contract-response.dto';
import { ContractsService } from './contracts.service';
import { normalizeUploadedFilename } from './filename.util';
import { sanitizeClientPosition } from './position.util';
import { redactForPreview } from './preview-redaction';

const MAX_UPLOAD_BYTES = 10 * 1024 * 1024; // 10MB — عقود نصّية عادةً بضع مئات KB، هامش واسع كافٍ بلا فتح الباب لملفات ضخمة غير منطقية
const DOCX_MIME = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

/**
 * رفع العميل: ملف Word (DOCX) فقط — قرار المنتج (عقد بلا بيانات شخصية لأطرافه، وتسليم نسخة معدَّلة قابلة للتحرير).
 * admin (المالك/المطوّر) يستثنى فيرفع PDF والمسوح للقياس والتجربة؛ ولغيره CONTRACT_ALLOW_PDF_UPLOAD=true تفتح PDF.
 */
function isDocxUpload(file: Express.Multer.File): boolean {
  return file.mimetype === DOCX_MIME || /\.docx$/i.test(file.originalname);
}
function isPdfUpload(file: Express.Multer.File): boolean {
  return file.mimetype === 'application/pdf' || /\.pdf$/i.test(file.originalname);
}
/** DOCX = حزمة zip تبدأ بـ«PK» — نرفض مبكراً ما ليس كذلك بدل أن تفشل المعالجة بعد ثوانٍ */
function looksLikeZip(buffer: Buffer): boolean {
  return buffer.length > 4 && buffer[0] === 0x50 && buffer[1] === 0x4b;
}

/** حقل multipart نصى: 'true' أو '1' */
function isTruthyFlag(v: unknown): boolean {
  return v === true || v === 'true' || v === '1';
}

/**
 * Service 2 — المدقق القانونى للعقود (Phase 1+2 الأساسية). راجع تعليق
 * ContractsService للتصميم الكامل والفجوات المعروفة.
 *
 * ⚠️ مصادقة **إلزامية** (JwtAuthGuard، لا OptionalJwtAuthGuard كالحوكمة/الأسئلة):
 * هذه بيانات عقود عمل حقيقية للمستخدم (أسماء أطراف، مبالغ، أرقام سجلات) — لا
 * مسار مجهول الهوية هنا بعكس الأسئلة القانونية العامة.
 */
@ApiTags('contracts')
@Controller('contracts')
@UseGuards(JwtAuthGuard)
export class ContractsController {
  constructor(private readonly contractsService: ContractsService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MAX_UPLOAD_BYTES } }))
  @ApiConsumes('multipart/form-data')
  @ApiCreatedResponse({
    description: 'رفع عقد (PDF/DOCX) لاستخراج بنوده وتقييمها الأولى مقابل النصوص القانونية المصرية المفهرَسة',
    type: ContractResponseDto,
  })
  async upload(
    @UploadedFile() file: Express.Multer.File | undefined,
    @Req() request: RequestWithUser,
    @Body() body?: Record<string, unknown>,
  ): Promise<ContractResponseDto> {
    if (!file) {
      throw new BadRequestException('لم يُرفَع أى ملف (الحقل المتوقَّع: file)');
    }
    const isAdmin = request.user?.role === 'admin';
    const pdfAllowed = isAdmin || process.env.CONTRACT_ALLOW_PDF_UPLOAD === 'true';
    if (isDocxUpload(file)) {
      if (!looksLikeZip(file.buffer)) {
        throw new BadRequestException('الملف ليس مستند Word (DOCX) صالحاً — احفظه من Word بصيغة DOCX وأعد الرفع.');
      }
    } else if (!(pdfAllowed && isPdfUpload(file))) {
      throw new BadRequestException('المسموح رفع ملف Word (DOCX) فقط.');
    }
    // request.user مضمون الوجود هنا (JwtAuthGuard إلزامى على كل مسارات هذا الـcontroller)
    const userId = request.user!.userId;
    const created = await this.contractsService.upload(
      {
        buffer: file.buffer,
        mimetype: file.mimetype,
        originalname: normalizeUploadedFilename(file.originalname),
      },
      {
        userId,
        ipAddress: request.ip ?? null,
        userAgent: request.headers['user-agent'] ?? null,
      },
      // مركز العميل من الاستيضاح قبل الرفع (اختيارى): حقلا multipart نصيان يُنقّيان فى الخادم
      sanitizeClientPosition(body),
      // التحليل فى الخلفية (يعود الطلب فوراً والواجهة تتابع الحالة)؛ غياب الحقل = السلوك القديم المتزامن، فلا تنكسر واجهة قديمة
      { background: isTruthyFlag(body?.background) },
    );
    // عقد جديد = غير مسدَّد: غير admin لا يرى تفاصيل المراجعة (إن عاد التحليل متزامناً)
    return isAdmin ? created : redactForPreview(created);
  }

  @Get(':id')
  @ApiOkResponse({ description: 'حالة عقد وبنوده وتقييمها', type: ContractResponseDto })
  async findById(
    @Param('id', ParseUUIDPipe) id: string,
    @Req() request: RequestWithUser,
  ): Promise<ContractResponseDto> {
    const user = request.user!;
    return this.contractsService.findById(id, { userId: user.userId, role: user.role });
  }

  @Post(':id/clauses/:clauseId/redraft')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({
    description: 'صياغة بديلة مقترحة لبند يحتاج مراجعة وله سند قانونى معتمَد (للاسترشاد، تُراجَع من محامٍ)',
    type: ContractClauseResponseDto,
  })
  async proposeRedraft(
    @Param('id', ParseUUIDPipe) id: string,
    @Param('clauseId', ParseUUIDPipe) clauseId: string,
    @Req() request: RequestWithUser,
  ): Promise<ContractClauseResponseDto> {
    const user = request.user!;
    return this.contractsService.proposeRedraft(id, clauseId, {
      userId: user.userId,
      role: user.role,
      ipAddress: request.ip ?? null,
      userAgent: request.headers['user-agent'] ?? null,
    });
  }
}
