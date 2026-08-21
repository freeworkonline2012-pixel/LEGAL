import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class RefreshDto {
  @ApiProperty({ description: 'توكن التحديث (refresh token)' })
  @IsString()
  @MinLength(20)
  refresh_token: string;
}
