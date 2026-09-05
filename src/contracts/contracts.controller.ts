import {
  BadRequestException,
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
import { ContractResponseDto } from './dto/contract-response.dto';
import { ContractsService } from './contracts.service';

const MAX_UPLOAD_BYTES = 10 * 1024 * 1024; // 10MB — عقود نصّية عادةً بضع مئات KB، هامش واسع كافٍ بلا فتح الباب لملفات ضخمة غير منطقية
const ALLOWED_MIME_TYPES = new Set([
  'application/pdf',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
]);

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
  ): Promise<ContractResponseDto> {
    if (!file) {
      throw new BadRequestException('لم يُرفَع أى ملف (الحقل المتوقَّع: file)');
    }
    if (!ALLOWED_MIME_TYPES.has(file.mimetype) && !/\.(pdf|docx)$/i.test(file.originalname)) {
      throw new BadRequestException('نوع ملف غير مدعوم — المسموح: PDF أو DOCX فقط');
    }
    // request.user مضمون الوجود هنا (JwtAuthGuard إلزامى على كل مسارات هذا الـcontroller)
    const userId = request.user!.userId;
    return this.contractsService.upload(
      { buffer: file.buffer, mimetype: file.mimetype, originalname: file.originalname },
      {
        userId,
        ipAddress: request.ip ?? null,
        userAgent: request.headers['user-agent'] ?? null,
      },
    );
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
}
