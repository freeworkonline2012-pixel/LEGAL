import { CanActivate, ExecutionContext, Injectable, Optional } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { isGuestAccessEnabled, isGuestEmail } from '../../auth/guest.constants';
import type { AuthenticatedUser } from '../interfaces/authenticated-user.interface';
import type { RequestWithUser } from '../interfaces/request-with-user.interface';
import type { JwtPayload } from '../../auth/interfaces/jwt-payload.interface';

/**
 * مصادقة اختيارية: يقرأ التوكن إن وُجد وصالحاً فيحقن user،
 * لكنه لا يمنع الطلب عند غيابه (يُستخدم في POST /api/questions حتى يعمل
 * السؤال دون تسجيل — مسار P0 في wireframes).
 */
@Injectable()
export class OptionalJwtAuthGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    @Optional() private readonly configService?: ConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<RequestWithUser>();
    const header = request.headers.authorization;
    if (!header) {
      return true;
    }

    const [type, token] = header.split(' ');
    if (type !== 'Bearer' || !token) {
      return true;
    }

    try {
      const payload = await this.jwtService.verifyAsync<JwtPayload>(token);
      // توكن زائر بعد تعطيل وضع الزائر = زائر مجهول (لا ربط بحساب)
      if (
        isGuestEmail(payload.email) &&
        !isGuestAccessEnabled(
          this.configService?.get<string>('GUEST_ACCESS_ENABLED') ?? process.env.GUEST_ACCESS_ENABLED,
        )
      ) {
        return true;
      }
      const user: AuthenticatedUser = {
        userId: payload.sub,
        email: payload.email,
        role: payload.role,
      };
      request.user = user;
    } catch {
      // توكن غير صالح = نتعامل معه كزائر (لا نمنع)
    }

    return true;
  }
}
