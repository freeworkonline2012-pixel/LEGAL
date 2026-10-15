import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ArrayMaxSize, IsArray, IsIn, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export const MEMO_TYPES = ['opinion_memo', 'defense_memo', 'legal_report'] as const;
export const PARTY_ROLES = ['claimant', 'defendant', 'advisory'] as const;

/**
 * حدود الأطوال مقصودة: المسألة والوقائع تُدمجان فى سؤال واحد لمحرك الإجابات (حدّه 2000 حرف)،
 * فمجموع الحدّين + الفواصل لا يتجاوزه (500 + 1400 + ثوابت قصيرة).
 */
export const MAX_ISSUE_CHARS = 500;
export const MAX_FACTS_CHARS = 1400;
export const MAX_REQUESTS = 6;
export const MAX_REQUEST_CHARS = 200;
export const MAX_TITLE_CHARS = 150;

export class CreateMemoDto {
  @ApiProperty({ enum: MEMO_TYPES, description: 'مذكرة رأى قانونى / مذكرة دفاع / تقرير قانونى' })
  @IsIn(MEMO_TYPES as unknown as string[])
  memo_type: (typeof MEMO_TYPES)[number];

  @ApiProperty({
    enum: PARTY_ROLES,
    description:
      'صفة مقدِّم المستند (مدعٍ / مدعى عليه / استشارى). تؤثر على ترويسة المستند فقط، ولا تدخل فى الاسترجاع ' +
      'أو الأسانيد: الأساس القانونى محايد دائماً ولا يُلوَّى لصالح طرف.',
  })
  @IsIn(PARTY_ROLES as unknown as string[])
  party_role: (typeof PARTY_ROLES)[number];

  @ApiPropertyOptional({ example: 'مذكرة بشأن إنهاء عقد عمل دون إخطار' })
  @IsOptional()
  @IsString()
  @MaxLength(MAX_TITLE_CHARS)
  title?: string;

  @ApiProperty({ example: 'هل يستحق العامل تعويضاً عن إنهاء عقده دون إخطار؟', description: 'المسألة القانونية المطلوب بحثها' })
  @IsString()
  @MinLength(10)
  @MaxLength(MAX_ISSUE_CHARS)
  issue: string;

  @ApiProperty({ description: 'الوقائع كما يرويها صاحب الطلب — تُنقل للمستند كما هى ولا يتحقق منها النظام' })
  @IsString()
  @MinLength(30)
  @MaxLength(MAX_FACTS_CHARS)
  facts: string;

  @ApiPropertyOptional({ type: String, isArray: true, description: 'الطلبات الختامية كما يريدها صاحب الطلب (تُنقل حرفياً)' })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(MAX_REQUESTS)
  @IsString({ each: true })
  @MaxLength(MAX_REQUEST_CHARS, { each: true })
  requests?: string[];
}
