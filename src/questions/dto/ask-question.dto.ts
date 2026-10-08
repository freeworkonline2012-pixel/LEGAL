import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';

/** إجابة السائل عن سؤال استيضاحى واحد (تُعاد مع كل طلب لاحق — الخادم عديم الحالة). */
export class ClarificationAnswerDto {
  @ApiProperty({ example: 'ما نوع العقد؟' })
  @IsString()
  @MinLength(3)
  @MaxLength(300)
  question: string;

  @ApiProperty({ example: 'عقد محدد المدة', description: 'فارغ عند kind=unknown' })
  @IsString()
  @MaxLength(500)
  answer: string;

  @ApiProperty({ enum: ['option', 'custom', 'unknown'] })
  @IsIn(['option', 'custom', 'unknown'])
  kind: 'option' | 'custom' | 'unknown';
}

export class ClarificationInputDto {
  @ApiPropertyOptional({ example: 1, description: 'عدد جولات الاستيضاح التى أُجيبت (0 = الطلب الأول)' })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(10)
  round?: number;

  @ApiPropertyOptional({ description: 'true = تخطَّ الاستيضاح وأجب مباشرة (بما أُجيب حتى الآن)' })
  @IsOptional()
  @IsBoolean()
  skip?: boolean;

  @ApiPropertyOptional({ type: ClarificationAnswerDto, isArray: true })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(24)
  @ValidateNested({ each: true })
  @Type(() => ClarificationAnswerDto)
  answers?: ClarificationAnswerDto[];
}

export class AskQuestionDto {
  @ApiProperty({ example: 'هل يحق لصاحب العمل فصلي بدون إنذار؟' })
  @IsString()
  @MinLength(3)
  @MaxLength(2_000)
  question: string;

  @ApiPropertyOptional({
    example: '3b9b9a5e-8c1c-4f0d-9f2a-123456789abc',
    description: 'معرّف محادثة للأسئلة المتتابعة (اختياري)',
  })
  @IsOptional()
  @IsUUID()
  conversation_id?: string;

  @ApiPropertyOptional({
    type: ClarificationInputDto,
    description:
      'حالة الاستيضاح: يعيدها العميل بعد أن يجيب السائل عن أسئلة الاستيضاح (أو {skip:true} لتخطيها). ' +
      'غائبة = طلب أول عادى.',
  })
  @IsOptional()
  @ValidateNested()
  @Type(() => ClarificationInputDto)
  clarification?: ClarificationInputDto;
}
