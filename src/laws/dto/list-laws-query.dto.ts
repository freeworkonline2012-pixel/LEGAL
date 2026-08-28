import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsInt, IsOptional, Matches, Max, Min } from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { DOMAIN_KEYS } from '../../database/entities/domain-key';
import { LAW_KINDS } from '../../database/entities/law-kind';
import { COUNTRY_CODE_PATTERN } from '../../database/entities/country-code';

// T-VOCAB-1: مصدر واحد للمفردات (DOMAIN_KEYS) — راجع التعليق فى create-law.dto.ts
const LAW_CATEGORIES = DOMAIN_KEYS;

export class ListLawsQueryDto {
  @ApiPropertyOptional({ example: 'labor', enum: LAW_CATEGORIES })
  @IsOptional()
  @IsIn(LAW_CATEGORIES)
  category?: (typeof LAW_CATEGORIES)[number];

  @ApiPropertyOptional({
    example: 'EG',
    description: 'ISO 3166-1 alpha-2 — لا قائمة enum ثابتة، راجع country-code.ts',
  })
  @IsOptional()
  @Matches(COUNTRY_CODE_PATTERN)
  country?: string;

  @ApiPropertyOptional({ example: 'in_force', enum: ['in_force', 'amended', 'repealed'] })
  @IsOptional()
  @IsIn(['in_force', 'amended', 'repealed'])
  status?: 'in_force' | 'amended' | 'repealed';

  /**
   * فلترة حسب نوع الأداة التشريعية (T-VOCAB-2 — راجع law-kind.ts). تقبل قيمة
   * واحدة أو عدة قيم مفصولة بفاصلة فى نفس رابط الاستعلام (مثال:
   * kind=pm_decision,ministerial_decision,board_decision,circular) — هذا هو
   * ما تعتمد عليه صفحة «القرارات» فى الواجهة لتجميع عدة أنواع فى استعلام واحد،
   * بينما صفحة «اللوائح التنفيذية» تمرّر kind=regulation فقط.
   */
  @ApiPropertyOptional({
    example: 'pm_decision,ministerial_decision,board_decision,circular',
    description: 'قيمة واحدة أو عدة قيم مفصولة بفاصلة من law-kind.ts',
  })
  @IsOptional()
  @Transform(({ value }): string[] =>
    typeof value === 'string'
      ? value
          .split(',')
          .map((v) => v.trim())
          .filter((v) => v.length > 0)
      : (value as string[]),
  )
  @IsIn(LAW_KINDS, { each: true })
  kind?: string[];

  @ApiPropertyOptional({ default: 20, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit: number = 20;

  @ApiPropertyOptional({ default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  offset: number = 0;
}
