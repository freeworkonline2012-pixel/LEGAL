import { CanActivate, ExecutionContext, Injectable, Optional, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { isClosedAccessMode, isEmailAllowed } from '../../auth/allowed-users.util';
import { isGuestAccessEnabled, isGuestEmail } from '../../auth/guest.constants';
import type { AuthenticatedUser } from '../interfaces/authenticated-user.interface';
import type { RequestWithUser } from '../interfaces/request-with-user.interface';
import type { JwtPayload } from '../../auth/interfaces/jwt-payload.interface';

/**
 * مصادقة اختيارية: يقرأ التوكن إن وُجد وصالحاً فيحقن user،
 * لكنه لا يمنع الطلب عند غيابه (يُستخدم في POST /api/questions حتى يعمل
 * السؤال دون تسجيل — مسار P0 في wireframes).
 *
 * استثناء: حين يكون الوضع المغلق (ALLOWED_USER_EMAILS) مفعَّلاً تصبح المصادقة إلزامية —
 * يُرفض الطلب بلا توكن أو بتوكن غير صالح أو لبريد خارج القائمة، فلا يبقى أى مسار مجهول.
 */
@Injectable()
export class OptionalJwtAuthGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    @Optional() private readonly configService?: ConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<RequestWithUser>();
    const allowedRaw = this.allowedEmailsRaw();
    const closed = isClosedAccessMode(allowedRaw);
    const header = request.headers.authorization;
    if (!header) {
      if (closed) throw new UnauthorizedException('access closed');
      return true;
    }

    const [type, token] = header.split(' ');
    if (type !== 'Bearer' || !token) {
      if (closed) throw new UnauthorizedException('access closed');
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
        if (closed) throw new UnauthorizedException('access closed');
        return true;
      }
      if (!isEmailAllowed(allowedRaw, payload.email)) {
        throw new UnauthorizedException('access closed');
      }
      const user: AuthenticatedUser = {
        userId: payload.sub,
        email: payload.email,
        role: payload.role,
      };
      request.user = user;
    } catch {
      // توكن غير صالح = نتعامل معه كزائر (لا نمنع) — إلا فى الوضع المغلق
      if (closed) throw new UnauthorizedException('access closed');
    }

    return true;
  }

  private allowedEmailsRaw(): string | undefined {
    return this.configService?.get<string>('ALLOWED_USER_EMAILS') ?? process.env.ALLOWED_USER_EMAILS;
  }
}
