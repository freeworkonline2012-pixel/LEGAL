import { Controller, Get, Param, ParseUUIDPipe, Query } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import {
  GuidanceDetailResponseDto,
  GuidanceListResponseDto,
} from './dto/guidance-response.dto';
import { ListGuidanceQueryDto } from './dto/list-guidance-query.dto';
import { GuidanceService } from './guidance.service';

/** قراءة فقط عمداً — لا مسارات إنشاء/تعديل بعد (المحتوى يُبذَر عبر migrations خام حالياً). */
@ApiTags('guidance')
@Controller('guidance')
export class GuidanceController {
  constructor(private readonly guidanceService: GuidanceService) {}

  @Get()
  @ApiOkResponse({
    description: 'قائمة الأدلة الإرشادية غير المرقّمة رسمياً (مع ترقيم)',
    type: GuidanceListResponseDto,
  })
  list(@Query() query: ListGuidanceQueryDto): Promise<GuidanceListResponseDto> {
    return this.guidanceService.list(query);
  }

  @Get(':id')
  @ApiOkResponse({ description: 'تفاصيل دليل إرشادى (يشمل النص الكامل)', type: GuidanceDetailResponseDto })
  getById(@Param('id', new ParseUUIDPipe()) id: string): Promise<GuidanceDetailResponseDto> {
    return this.guidanceService.getById(id);
  }
}
