import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  ParseUUIDPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiCreatedResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Roles } from '../common/decorators/roles.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { AddVersionDto } from './dto/add-version.dto';
import {
  ArticleDetailResponseDto,
  ArticleListResponseDto,
  ArticleVersionListResponseDto,
} from './dto/article-response.dto';
import { CreateArticleDto } from './dto/create-article.dto';
import { GetArticleQueryDto } from './dto/get-article-query.dto';
import { ListArticlesQueryDto } from './dto/list-articles-query.dto';
import { ArticlesService } from './articles.service';

@ApiTags('articles')
@Controller()
export class ArticlesController {
  constructor(private readonly articlesService: ArticlesService) {}

  @Get('laws/:lawId/articles')
  @ApiOkResponse({
    description: 'مواد قانون معيّن (مع ترقيم)',
    type: ArticleListResponseDto,
  })
  listByLaw(
    @Param('lawId', new ParseUUIDPipe()) lawId: string,
    @Query() query: ListArticlesQueryDto,
  ): Promise<ArticleListResponseDto> {
    return this.articlesService.listByLaw(lawId, query);
  }

  @Get('laws/:lawId/articles/:articleNo')
  @ApiOkResponse({
    description: 'مادة محددة مع النسخة السارية في تاريخ as_of',
    type: ArticleDetailResponseDto,
  })
  getByLawAndNumber(
    @Param('lawId', new ParseUUIDPipe()) lawId: string,
    @Param('articleNo', new ParseIntPipe()) articleNo: number,
    @Query() query: GetArticleQueryDto,
  ): Promise<ArticleDetailResponseDto> {
    return this.articlesService.getByLawAndNumber(lawId, articleNo, query.as_of);
  }

  @Post('articles')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @ApiBearerAuth()
  @ApiCreatedResponse({
    description: 'إنشاء مادة مع إصدارها الأول (admin)',
    type: ArticleDetailResponseDto,
  })
  create(@Body() dto: CreateArticleDto): Promise<ArticleDetailResponseDto> {
    return this.articlesService.create(dto);
  }

  @Post('articles/:id/versions')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @ApiBearerAuth()
  @ApiCreatedResponse({
    description: 'إضافة إصدار جديد لمادة (admin) — يغلق الإصدار الحالي',
    type: ArticleDetailResponseDto,
  })
  addVersion(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: AddVersionDto,
  ): Promise<ArticleDetailResponseDto> {
    return this.articlesService.addVersion(id, dto);
  }

  @Get('articles/:id/versions')
  @ApiOkResponse({
    description: 'كل إصدارات مادة (الأحدث أولاً)',
    type: ArticleVersionListResponseDto,
  })
  listVersions(
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<ArticleVersionListResponseDto> {
    return this.articlesService.listVersions(id);
  }
}
