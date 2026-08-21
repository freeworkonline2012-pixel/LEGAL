import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, IsUUID, MaxLength, MinLength } from 'class-validator';

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
}
