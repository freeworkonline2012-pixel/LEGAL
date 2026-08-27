import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { GuidanceDocument } from '../database/entities/guidance-document.entity';
import {
  GuidanceDetailResponseDto,
  GuidanceListItemDto,
  GuidanceListResponseDto,
} from './dto/guidance-response.dto';
import { ListGuidanceQueryDto } from './dto/list-guidance-query.dto';

@Injectable()
export class GuidanceService {
  constructor(
    @InjectRepository(GuidanceDocument)
    private readonly guidanceRepository: Repository<GuidanceDocument>,
  ) {}

  async list(query: ListGuidanceQueryDto): Promise<GuidanceListResponseDto> {
    const qb = this.guidanceRepository
      .createQueryBuilder('g')
      .leftJoinAndSelect('g.relatedLaw', 'law')
      // عمود مساعد لترتيب النتائج بلا تاريخ إصدار (issued_at IS NULL) فى الآخر
      // دوماً. جُرِّب من قبل: (أ) `NULLS LAST` كوسيط ثالث فى orderBy() — غير
      // مدعوم بثبات وسبّب خطأ 500 (databaseName undefined)؛ (ب) تمرير تعبير
      // بوليانى خام مباشرة إلى orderBy() — فشل لأن TypeORM يحاول تفسير أول
      // رمزين كـ alias.column فيظن أن "(g" اسم مستعار غير موجود. الحل الثابت
      // عبر كل إصدارات TypeORM: إضافة العمود كـ addSelect بـ alias صريح، ثم
      // الترتيب بحسب هذا الـ alias فقط (نمط موثّق ومستقر فى TypeORM).
      .addSelect('CASE WHEN g.issued_at IS NULL THEN 1 ELSE 0 END', 'issued_at_null_rank');

    if (query.category) {
      qb.andWhere('g.category = :category', { category: query.category });
    }

    // ملاحظة جوهرية: بما أن الاستعلام يجمع بين leftJoinAndSelect و skip/take،
    // يلجأ TypeORM داخلياً لمسار "الاستعلام المدمج" (createOrderByCombined-
    // WithSelectExpression) لتفادى مشاكل التصفح مع علاقات one-to-many. هذا
    // المسار يفسّر "alias.x" فى orderBy/addOrderBy كـ property path على
    // الـ Entity (مثل issuedAt) وليس كاسم عمود قاعدة البيانات الفعلى
    // (issued_at) — استخدام اسم العمود الخام هنا يُرجع column=undefined
    // ويسبب خطأ "Cannot read properties of undefined (reading 'databaseName')".
    // لذا وجوباً: أسماء الخصائص camelCase كما فى الـ Entity، لا snake_case.
    const [items, total] = await qb
      .orderBy('issued_at_null_rank', 'ASC')
      .addOrderBy('g.issuedAt', 'DESC')
      .addOrderBy('g.createdAt', 'DESC')
      .skip(query.offset)
      .take(query.limit)
      .getManyAndCount();

    return {
      items: items.map((item) => this.toListItem(item)),
      total,
    };
  }

  async getById(id: string): Promise<GuidanceDetailResponseDto> {
    const item = await this.guidanceRepository.findOne({
      where: { id },
      relations: { relatedLaw: true },
    });
    if (!item) {
      throw new NotFoundException('guidance document not found');
    }
    return this.toDetail(item);
  }

  private toListItem(item: GuidanceDocument): GuidanceListItemDto {
    return {
      id: item.id,
      title: item.title,
      issuing_authority: item.issuingAuthority,
      category: item.category,
      official_url: item.officialUrl,
      issued_at: item.issuedAt,
      related_law: item.relatedLaw
        ? {
            id: item.relatedLaw.id,
            law_no: item.relatedLaw.lawNo,
            law_year: item.relatedLaw.lawYear,
            title: item.relatedLaw.title,
          }
        : null,
      created_at: item.createdAt.toISOString(),
    };
  }

  private toDetail(item: GuidanceDocument): GuidanceDetailResponseDto {
    return {
      ...this.toListItem(item),
      quality_note: item.qualityNote,
      plain_summary: item.plainSummary,
      body: item.body,
      updated_at: item.updatedAt.toISOString(),
    };
  }
}
