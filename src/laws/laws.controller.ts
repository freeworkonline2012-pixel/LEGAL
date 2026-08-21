import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiCreatedResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Roles } from '../common/decorators/roles.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { CreateLawDto } from './dto/create-law.dto';
import { LawListResponseDto, LawResponseDto } from './dto/law-response.dto';
import { ListLawsQueryDto } from './dto/list-laws-query.dto';
import { UpdateLawDto } from './dto/update-law.dto';
import { LawsService } from './laws.service';

@ApiTags('laws')
@Controller('laws')
export class LawsController {
  constructor(private readonly lawsService: LawsService) {}

  @Get()
  @ApiOkResponse({
    description: 'قائمة القوانين مع ترقيم',
    type: LawListResponseDto,
  })
  list(@Query() query: ListLawsQueryDto): Promise<LawListResponseDto> {
    return this.lawsService.list(query);
  }

  @Get(':id')
  @ApiOkResponse({ description: 'تفاصيل قانون', type: LawResponseDto })
  getById(@Param('id', new ParseUUIDPipe()) id: string): Promise<LawResponseDto> {
    return this.lawsService.getById(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @ApiBearerAuth()
  @ApiCreatedResponse({ description: 'إنشاء قانون (admin)', type: LawResponseDto })
  create(@Body() dto: CreateLawDto): Promise<LawResponseDto> {
    return this.lawsService.create(dto);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @ApiBearerAuth()
  @ApiOkResponse({ description: 'تحديث قانون (admin)', type: LawResponseDto })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateLawDto,
  ): Promise<LawResponseDto> {
    return this.lawsService.update(id, dto);
  }
}
