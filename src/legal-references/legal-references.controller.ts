import { Controller, Get, Param, ParseIntPipe, ParseUUIDPipe, Query } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import {
  LegalReferenceDetailResponseDto,
  LegalReferenceListResponseDto,
  LegalReferenceSearchResponseDto,
  LegalReferenceSectionResponseDto,
} from './dto/legal-reference-response.dto';
import {
  ListLegalReferencesQueryDto,
  SearchLegalReferencesQueryDto,
} from './dto/list-legal-references-query.dto';
import { LegalReferencesService } from './legal-references.service';

/**
 * قراءة فقط عمداً (عرض وبحث) — المحتوى يُدخَل عبر migrations كبقية المكتبة.
 * قراءة عامة بلا مصادقة، نفس نمط laws وguidance (تصفح عام للمكتبة القانونية).
 */
@ApiTags('legal-references')
@Controller('legal-references')
export class LegalReferencesController {
  constructor(private readonly service: LegalReferencesService) {}

  @Get()
  @ApiOkResponse({ description: 'قائمة المراجع القانونية (مع ترقيم)', type: LegalReferenceListResponseDto })
  list(@Query() query: ListLegalReferencesQueryDto): Promise<LegalReferenceListResponseDto> {
    return this.service.list(query);
  }

  // يجب أن يسبق مسار :id حتى لا يُفسَّر "search" معرّفاً.
  @Get('search')
  @ApiOkResponse({ description: 'بحث نصى كامل داخل أقسام المراجع', type: LegalReferenceSearchResponseDto })
  search(@Query() query: SearchLegalReferencesQueryDto): Promise<LegalReferenceSearchResponseDto> {
    return this.service.search(query);
  }

  @Get(':id')
  @ApiOkResponse({ description: 'بيانات المرجع وفهرس أقسامه', type: LegalReferenceDetailResponseDto })
  getById(@Param('id', new ParseUUIDPipe()) id: string): Promise<LegalReferenceDetailResponseDto> {
    return this.service.getById(id);
  }

  @Get(':id/sections/:seq')
  @ApiOkResponse({ description: 'نص قسم واحد من المرجع', type: LegalReferenceSectionResponseDto })
  getSection(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Param('seq', new ParseIntPipe()) seq: number,
  ): Promise<LegalReferenceSectionResponseDto> {
    return this.service.getSection(id, seq);
  }
}
