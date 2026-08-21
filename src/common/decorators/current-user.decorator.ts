import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import type { AuthenticatedUser } from '../interfaces/authenticated-user.interface';
import type { RequestWithUser } from '../interfaces/request-with-user.interface';

/**
 * يستخرج المستخدم المُصادَق عليه من الطلب.
 * يجب استخدامه بعد JwtAuthGuard (وإلا يرمي خطأ صريحاً).
 */
export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): AuthenticatedUser => {
    const request = ctx.switchToHttp().getRequest<RequestWithUser>();
    if (!request.user) {
      throw new Error('CurrentUser decorator requires JwtAuthGuard to be applied first');
    }
    return request.user;
  },
);
