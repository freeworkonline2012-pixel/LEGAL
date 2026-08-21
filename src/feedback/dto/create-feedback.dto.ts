import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';

export class CreateFeedbackDto {
  @ApiProperty({ example: 'a-uuid' })
  @IsUUID()
  answer_id: string;

  @ApiProperty({ example: 1, enum: [-1, 1], description: '1 = 👍 ، -1 = 👎' })
  @IsIn([-1, 1])
  rating: number;

  @ApiPropertyOptional({ example: 'الإجابة دقيقة ومفيدة' })
  @IsOptional()
  @IsString()
  @MaxLength(1_000)
  comment?: string;
}
