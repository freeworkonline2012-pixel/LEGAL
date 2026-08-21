import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class LogoutDto {
  @ApiProperty({ description: 'توكن التحديث المراد إبطاله' })
  @IsString()
  @MinLength(20)
  refresh_token: string;
}
