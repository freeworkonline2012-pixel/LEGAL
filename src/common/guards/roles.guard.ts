import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { UserRole } from '../../database/entities/user.entity';
import { ROLES_KEY } from '../decorators/roles.decorator';
import type { RequestWithUser } from '../interfaces/request-with-user.interface';

/**
 * RBAC Guard — يُستخدم بعد JwtAuthGuard.
 * يقرأ الأدوار المطلوبة من @Roles(...) ويمنع الوصول إن لم يكن دور المستخدم ضمنها.
 * إن لم يُحدَّد @Roles على المسار، يسمح للجميع (المصادَق عليهم فقط).
 */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<UserRole[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles || requiredRoles.length === 0) {
      return true;
    }

    const request = context.switchToHttp().getRequest<RequestWithUser>();
    const user = request.user;
    if (!user) {
      throw new ForbiddenException('authenticated user required');
    }

    if (!requiredRoles.includes(user.role)) {
      throw new ForbiddenException('insufficient role');
    }

    return true;
  }
}
