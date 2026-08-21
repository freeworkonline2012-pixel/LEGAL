import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import type { UserRole } from '../../database/entities/user.entity';

export class UserResponseDto {
  @ApiProperty({ example: '3b9b9a5e-8c1c-4f0d-9f2a-123456789abc' })
  id: string;

  @ApiProperty({ example: 'user@example.com' })
  email: string;

  @ApiPropertyOptional({ example: 'أحمد محمد', nullable: true })
  full_name: string | null;

  @ApiProperty({ example: 'user', enum: ['user', 'lawyer', 'admin'] })
  role: UserRole;

  @ApiProperty({ example: '2026-01-01T10:00:00.000Z' })
  created_at: string;
}

export class AuthResponseDto {
  @ApiProperty({ example: 'eyJhbGciOi...' })
  access_token: string;

  @ApiProperty({ example: 'eyJhbGciOi...' })
  refresh_token: string;

  @ApiProperty({ type: UserResponseDto })
  user: UserResponseDto;
}

export class LogoutResponseDto {
  @ApiProperty({ example: true })
  success: boolean;
}
