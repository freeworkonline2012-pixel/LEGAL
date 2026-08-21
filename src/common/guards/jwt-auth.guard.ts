import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
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
  constructor(private readonly jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<RequestWithUser>();
    const token = this.extractBearerToken(request);

    if (!token) {
      throw new UnauthorizedException('missing bearer token');
    }

    try {
      const payload = await this.jwtService.verifyAsync<JwtPayload>(token);
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

  private extractBearerToken(request: RequestWithUser): string | undefined {
    const header = request.headers.authorization;
    if (!header) {
      return undefined;
    }
    const [type, token] = header.split(' ');
    return type === 'Bearer' && token ? token : undefined;
  }
}
