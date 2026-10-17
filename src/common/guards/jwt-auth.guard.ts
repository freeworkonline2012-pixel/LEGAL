import {
  CanActivate,
  ExecutionContext,
  Injectable,
  Optional,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { isGuestAccessEnabled, isGuestEmail } from '../../auth/guest.constants';
import type { UserRole } from '../../database/entities/user.entity';
import type { AuthenticatedUser } from '../interfaces/authenticated-user.interface';
import type { RequestWithUser } from '../interfaces/request-with-user.interface';

export interface JwtPayload {
  sub: string;
  email: string;
  role: UserRole;
}

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    @Optional() private readonly configService?: ConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<RequestWithUser>();
    const token = this.extractBearerToken(request);

    if (!token) {
      throw new UnauthorizedException('missing bearer token');
    }

    try {
      const payload = await this.jwtService.verifyAsync<JwtPayload>(token);
      // مفتاح الإيقاف الفورى لوضع الزائر: أى توكن زائر يُرفض فور تعطيل GUEST_ACCESS_ENABLED
      // (لا ننتظر انتهاء صلاحيته). المصدر: ConfigService ثم process.env كاحتياط.
      if (isGuestEmail(payload.email) && !this.guestEnabled()) {
        throw new UnauthorizedException('guest access disabled');
      }
      const user: AuthenticatedUser = {
        userId: payload.sub,
        email: payload.email,
        role: payload.role,
      };
      request.user = user;
      return true;
    } catch {
      throw new UnauthorizedException('invalid or expired token');
    }
  }

  private guestEnabled(): boolean {
    return isGuestAccessEnabled(
      this.configService?.get<string>('GUEST_ACCESS_ENABLED') ?? process.env.GUEST_ACCESS_ENABLED,
    );
  }

  private extractBearerToken(request: RequestWithUser): string | undefined {
    const header = request.headers.authorization;
    if (!header) {
      return undefined;
    }
    const [type, token] = header.split(' ');
    return type === 'Bearer' && token ? token : undefined;
  }
}
