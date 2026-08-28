import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Country } from '../database/entities/country.entity';
import { CountryListResponseDto, CountryResponseDto } from './dto/country-response.dto';

@Injectable()
export class CountriesService {
  constructor(
    @InjectRepository(Country)
    private readonly countryRepository: Repository<Country>,
  ) {}

  /**
   * قائمة الدول مع عدد القوانين الفعلى لكل دولة — محسوب حياً بـ LEFT JOIN
   * (لا عمود مخزَّن يحتاج تزامناً يدوياً). LEFT JOIN عمداً: دولة بلا أى قانون
   * بعد (السعودية/الإمارات/قطر/البحرين حالياً) يجب أن تظهر بـ law_count=0،
   * لا أن تختفى من القائمة — الواجهة تستخدم هذا الصفر لعرض شارة "قريباً".
   */
  async list(): Promise<CountryListResponseDto> {
    const rows = await this.countryRepository
      .createQueryBuilder('country')
      .leftJoin('laws', 'law', 'law.country_code = country.code')
      .select('country.code', 'code')
      .addSelect('country.nameAr', 'name_ar')
      .addSelect('country.nameEn', 'name_en')
      .addSelect('country.displayOrder', 'display_order')
      .addSelect('country.isActive', 'is_active')
      .addSelect('COUNT(law.id)', 'law_count')
      .groupBy('country.code')
      .addGroupBy('country.nameAr')
      .addGroupBy('country.nameEn')
      .addGroupBy('country.displayOrder')
      .addGroupBy('country.isActive')
      .orderBy('country.displayOrder', 'ASC')
      .getRawMany<{
        code: string;
        name_ar: string;
        name_en: string | null;
        display_order: number;
        is_active: boolean;
        law_count: string;
      }>();

    const items: CountryResponseDto[] = rows.map((row) => ({
      code: row.code,
      name_ar: row.name_ar,
      name_en: row.name_en,
      display_order: row.display_order,
      is_active: row.is_active,
      law_count: Number(row.law_count),
    }));

    return { items };
  }
}
