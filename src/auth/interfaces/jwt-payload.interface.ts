import type { UserRole } from '../../database/entities/user.entity';

/** حمولة JWT — sub يحمل معرّف المستخدم */
export interface JwtPayload {
  sub: string;
  email: string;
  role: UserRole;
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
}
