import { ApiProperty } from '@nestjs/swagger';
import { IsIn, IsObject, IsString, MaxLength } from 'class-validator';
import { DRAFT_TYPE_IDS } from '../drafting.types';

/** حد أقصى مجمع لحجم الإجابات (حماية من حمولة ضخمة): الحقول النصية فى الكتالوج محدودة فرادى أيضاً. */
export const MAX_ANSWER_KEYS = 40;

export class GenerateDraftDto {
  @ApiProperty({ enum: DRAFT_TYPE_IDS })
  @IsIn(DRAFT_TYPE_IDS as unknown as string[])
  type: (typeof DRAFT_TYPE_IDS)[number];

  @ApiProperty({ description: 'صفة المستخدم (من أدوار النوع فى الكتالوج)' })
  @IsString()
  @MaxLength(40)
  role: string;

  @ApiProperty({ description: 'إجابات الكتالوج: معرّف الحقل ← القيمة', type: 'object', additionalProperties: true })
  @IsObject()
  answers: Record<string, string | number>;
}

/** «عقد آخر»: النوع ثابت (custom) فلا يُرسَل؛ الإجابات بحدود الكتالوج نفسها. */
export class GenerateCustomDraftDto {
  @ApiProperty({ description: 'first | second' })
  @IsString()
  @MaxLength(10)
  role: string;

  @ApiProperty({ type: 'object', additionalProperties: true })
  @IsObject()
  answers: Record<string, string | number>;
}

/** المسودة كما حرّرها المستخدم؛ يتحقق منها sanitizeEditedDraft يدوياً (حدود وأنواع). */
export class ExportCustomDraftDto {
  @ApiProperty({ type: 'object', additionalProperties: true })
  @IsObject()
  draft: Record<string, unknown>;
}
