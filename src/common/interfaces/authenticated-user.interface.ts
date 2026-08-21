import type { UserRole } from '../../database/entities/user.entity';

/** المستخدم المُصادَق عليه والمُحقَن في الطلب عبر JwtAuthGuard */
export interface AuthenticatedUser {
  userId: string;
  email: string;
  role: UserRole;
}
