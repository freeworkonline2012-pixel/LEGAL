import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectDataSource, InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { Article } from '../database/entities/article.entity';
import { ArticleVersion } from '../database/entities/article-version.entity';
import { Law } from '../database/entities/law.entity';
import { AddVersionDto } from './dto/add-version.dto';
import {
  ArticleDetailResponseDto,
  ArticleListResponseDto,
  ArticleResponseDto,
  ArticleVersionListResponseDto,
  ArticleVersionResponseDto,
} from './dto/article-response.dto';
import { CreateArticleDto } from './dto/create-article.dto';
import {
  assertValidEffectiveFrom,
  closeCurrentVersion,
  nextVersionNo,
  versionEffectiveOn,
} from './versioning';
import type { VersionLike } from './versioning';

@Injectable()
export class ArticlesService {
  constructor(
    @InjectRepository(Article)
    private readonly articleRepository: Repository<Article>,
    @InjectRepository(ArticleVersion)
    private readonly versionRepository: Repository<ArticleVersion>,
    @InjectDataSource()
    private readonly dataSource: DataSource,
  ) {}

  async listByLaw(
    lawId: string,
    query: { limit: number; offset: number },
  ): Promise<ArticleListResponseDto> {
    const lawExists = await this.dataSource
      .getRepository(Law)
      .findOne({ where: { id: lawId }, select: { id: true } });
    if (!lawExists) {
      throw new NotFoundException('law not found');
    }

    // استعلام واحد مع join — بلا N+1
    const [articles, total] = await this.articleRepository
      .createQueryBuilder('article')
      .where('article.law_id = :lawId', { lawId })
      .orderBy('article.article_no', 'ASC')
      .addOrderBy('article.article_suffix_order', 'ASC')
      .skip(query.offset)
      .take(query.limit)
      .getManyAndCount();

    return {
      items: articles.map((article) => this.toArticleResponse(article)),
      total,
    };
  }

  async getByLawAndNumber(
    lawId: string,
    articleNo: number,
    asOf?: string,
  ): Promise<ArticleDetailResponseDto> {
    // article_suffix_order = 0 = المادة الأساسية (وليست نسخة "مكررا" أو مادة
    // إصدار تشارك نفس الرقم) — هى المرجع الصحيح لعنوان رقمى مباشر مثل هذا.
    // نسخ "مكررا" تظهر فى قائمة listByLaw ولها article_no نفسه؛ الوصول
    // المباشر لها عبر عنوان مخصص متروك كمتابعة لاحقة (راجع تقرير 2026-09-02).
    const article = await this.articleRepository.findOne({
      where: { lawId, articleNo, articleSuffixOrder: 0 },
    });
    if (!article) {
      throw new NotFoundException('article not found');
    }

    const versions = await this.versionRepository.find({
      where: { articleId: article.id },
      order: { versionNo: 'ASC' },
    });

    const date = asOf ?? today();
    const effective = versionEffectiveOn(
      versions.map((v) => this.toVersionLike(v)),
      date,
    );

    if (!effective) {
      throw new NotFoundException(`no version of article ${articleNo} effective on ${date}`);
    }

    return {
      ...this.toArticleResponse(article),
      version: this.toVersionResponse(
        versions.find((v) => v.id === effective.id) as ArticleVersion,
      ),
    };
  }

  async create(dto: CreateArticleDto): Promise<ArticleDetailResponseDto> {
    const law = await this.dataSource
      .getRepository(Law)
      .findOne({ where: { id: dto.law_id }, select: { id: true } });
    if (!law) {
      throw new NotFoundException('law not found');
    }

    const effectiveFrom = dto.effective_from ?? today();

    return this.dataSource.transaction(async (manager) => {
      const articleRepository = manager.getRepository(Article);
      const versionRepository = manager.getRepository(ArticleVersion);

      const existing = await articleRepository.findOne({
        where: { lawId: dto.law_id, articleNo: dto.article_no },
      });
      if (existing) {
        throw new BadRequestException('article with same number already exists in this law');
      }

      const article = articleRepository.create({
        lawId: dto.law_id,
        articleNo: dto.article_no,
        hierarchicalLocation: dto.hierarchical_location ?? null,
        title: dto.title ?? null,
        body: dto.body,
        plainSummary: dto.plain_summary ?? null,
      });
      // save (وليس insert): نحتاج article.id لربط الإصدار الأول.
      const savedArticle = await articleRepository.save(article);

      const version = versionRepository.create({
        articleId: savedArticle.id,
        versionNo: 1,
        body: dto.body,
        effectiveFrom,
        effectiveTo: null,
        status: 'active',
        amendedByLawNo: null,
        amendedByLawYear: null,
        changeNote: dto.change_note ?? null,
      });
      // save: نحتاج version.id/created_at في toVersionResponse.
      const savedVersion = await versionRepository.save(version);

      return {
        ...this.toArticleResponse(savedArticle),
        version: this.toVersionResponse(savedVersion),
      };
    });
  }

  async addVersion(articleId: string, dto: AddVersionDto): Promise<ArticleDetailResponseDto> {
    return this.dataSource.transaction(async (manager) => {
      const articleRepository = manager.getRepository(Article);
      const versionRepository = manager.getRepository(ArticleVersion);

      const article = await articleRepository.findOne({
        where: { id: articleId },
      });
      if (!article) {
        throw new NotFoundException('article not found');
      }

      const versions = await versionRepository.find({
        where: { articleId },
        order: { versionNo: 'ASC' },
      });
      const versionLikes = versions.map((v) => this.toVersionLike(v));

      // الإصدار الساري حالياً = الأعلى رقم (آخر سلسلة)
      const current = versionLikes[versionLikes.length - 1] ?? null;
      try {
        assertValidEffectiveFrom(current, dto.effective_from);
      } catch {
        // عقد API (openapi.yaml): POST /articles/{id}/versions يعيد 400
        // «تاريخ سريان غير صالح» — لا 500. versioning.ts تبقى نقية (plain Error)
        // والتحويل إلى HTTP 400 هنا في طبقة الخدمة.
        throw new BadRequestException(
          'invalid effective_from: must be after current version start',
        );
      }

      if (current) {
        const closed = closeCurrentVersion(current, dto.effective_from);
        const currentEntity = versions.find((v) => v.id === closed.id);
        if (!currentEntity) {
          throw new NotFoundException('current version missing');
        }
        currentEntity.effectiveTo = closed.effectiveTo;
        currentEntity.status = closed.status;
        await versionRepository.save(currentEntity);
      }

      const newVersion = versionRepository.create({
        articleId,
        versionNo: nextVersionNo(versionLikes),
        body: dto.body,
        effectiveFrom: dto.effective_from,
        effectiveTo: null,
        status: 'active',
        amendedByLawNo: dto.amended_by_law_no ?? null,
        amendedByLawYear: dto.amended_by_law_year ?? null,
        changeNote: dto.change_note ?? null,
      });
      // save (وليس insert): نحتاج newVersion.id/created_at في toVersionResponse.
      const savedVersion = await versionRepository.save(newVersion);

      // تحديث نص المادة الحالي ليتطابق مع أحدث إصدار
      article.body = dto.body;
      await articleRepository.save(article);

      return {
        ...this.toArticleResponse(article),
        version: this.toVersionResponse(savedVersion),
      };
    });
  }

  async listVersions(articleId: string): Promise<ArticleVersionListResponseDto> {
    const article = await this.articleRepository.findOne({
      where: { id: articleId },
      select: { id: true },
    });
    if (!article) {
      throw new NotFoundException('article not found');
    }

    const [versions, total] = await this.versionRepository
      .createQueryBuilder('version')
      .where('version.article_id = :articleId', { articleId })
      .orderBy('version.version_no', 'DESC')
      .getManyAndCount();

    return {
      items: versions.map((v) => this.toVersionResponse(v)),
      total,
    };
  }

  private toVersionLike(version: ArticleVersion): VersionLike {
    return {
      id: version.id,
      versionNo: version.versionNo,
      body: version.body,
      effectiveFrom: version.effectiveFrom,
      effectiveTo: version.effectiveTo,
      status: version.status,
    };
  }

  private toArticleResponse(article: Article): ArticleResponseDto {
    return {
      id: article.id,
      law_id: article.lawId,
      article_no: article.articleNo,
      article_suffix_order: article.articleSuffixOrder,
      hierarchical_location: article.hierarchicalLocation,
      title: article.title,
      body: article.body,
      plain_summary: article.plainSummary,
      created_at: article.createdAt.toISOString(),
      updated_at: article.updatedAt.toISOString(),
    };
  }

  private toVersionResponse(version: ArticleVersion): ArticleVersionResponseDto {
    return {
      id: version.id,
      version_no: version.versionNo,
      body: version.body,
      effective_from: version.effectiveFrom,
      effective_to: version.effectiveTo,
      status: version.status,
      amended_by_law_no: version.amendedByLawNo,
      amended_by_law_year: version.amendedByLawYear,
      change_note: version.changeNote,
      created_at: version.createdAt.toISOString(),
    };
  }
}

function today(): string {
  return new Date().toISOString().slice(0, 10);
}
