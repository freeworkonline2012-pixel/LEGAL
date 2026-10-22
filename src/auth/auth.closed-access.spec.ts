import { ForbiddenException, UnauthorizedException } from '@nestjs/common';
import type { ExecutionContext } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { OptionalJwtAuthGuard } from '../common/guards/optional-jwt-auth.guard';
import { AuthService } from './auth.service';

const SECRET = 'x'.repeat(40);
const ME = 'me@example.com';

function makeConfig(values: Record<string, string | undefined>): ConfigService {
  return { get: (k: string) => values[k] } as unknown as ConfigService;
}

function makeService(env: Record<string, string | undefined>, userRow?: Record<string, unknown>) {
  const userRepo = {
    create: (v: Record<string, unknown>) => ({ id: 'u-1', createdAt: new Date(), ...v }),
    save: jest.fn(async (u: Record<string, unknown>) => u),
    findOne: jest.fn(async () => userRow ?? null),
  };
  const refreshRepo = { insert: jest.fn(async () => undefined), findOne: jest.fn(), save: jest.fn() };
  const jwt = new JwtService({ secret: SECRET });
  const config = makeConfig({ JWT_SECRET: SECRET, ...env });
  const service = new AuthService(userRepo as never, refreshRepo as never, jwt, config);
  return { service, userRepo, refreshRepo, jwt, config };
}

function ctx(authHeader?: string): { context: ExecutionContext; req: { headers: Record<string, string>; user?: unknown } } {
  const req: { headers: Record<string, string>; user?: unknown } = {
    headers: authHeader ? { authorization: authHeader } : {},
  };
  const context = { switchToHttp: () => ({ getRequest: () => req }) } as unknown as ExecutionContext;
  return { context, req };
}

describe('AuthService — وضع المستخدم الواحد (ALLOWED_USER_EMAILS)', () => {
  it('التسجيل لبريد خارج القائمة مرفوض (403) ولا يكتب شيئاً', async () => {
    const { service, userRepo } = makeService({ ALLOWED_USER_EMAILS: ME });
    await expect(service.register('stranger@example.com', 'strong-pass-123')).rejects.toBeInstanceOf(
      ForbiddenException,
    );
    expect(userRepo.save).not.toHaveBeenCalled();
    expect(userRepo.findOne).not.toHaveBeenCalled();
  });

  it('التسجيل للبريد المسموح يعمل', async () => {
    const { service, userRepo } = makeService({ ALLOWED_USER_EMAILS: ME });
    const user = await service.register(' ME@Example.com ', 'strong-pass-123');
    expect(user.email).toBe(ME);
    expect(userRepo.save).toHaveBeenCalledTimes(1);
  });

  it('غير معيَّن: التسجيل كما كان (لا تغيير سلوك)', async () => {
    const { service } = makeService({});
    const user = await service.register('anyone@example.com', 'strong-pass-123');
    expect(user.email).toBe('anyone@example.com');
  });

  it('الدخول لبريد خارج القائمة يفشل برسالة بيانات الاعتماد الخاطئة دون استعلام', async () => {
    const { service, userRepo } = makeService({ ALLOWED_USER_EMAILS: ME });
    await expect(service.login('stranger@example.com', 'whatever-123')).rejects.toThrow('invalid credentials');
    expect(userRepo.findOne).not.toHaveBeenCalled();
  });

  it('الدخول للبريد المسموح بكلمة المرور الصحيحة يعمل', async () => {
    const hash = await bcrypt.hash('right-pass-123', 4);
    const { service } = makeService(
      { ALLOWED_USER_EMAILS: ME },
      { id: 'u-1', email: ME, passwordHash: hash, role: 'user', isActive: true, createdAt: new Date() },
    );
    const res = await service.login(ME, 'right-pass-123');
    expect(res.user.email).toBe(ME);
  });

  it('الوضع المغلق يعطّل الزائر حتى مع GUEST_ACCESS_ENABLED=true', async () => {
    const { service } = makeService({ ALLOWED_USER_EMAILS: ME, GUEST_ACCESS_ENABLED: 'true' });
    expect(service.isGuestEnabled()).toBe(false);
    expect(service.getGuestConfig().enabled).toBe(false);
    await expect(service.createGuest()).rejects.toThrow();
  });

  it('تجديد الجلسة لبريد خارج القائمة مرفوض ولا يُدوَّر التوكن', async () => {
    const { service, refreshRepo } = makeService({ ALLOWED_USER_EMAILS: ME });
    refreshRepo.findOne.mockResolvedValueOnce({
      revokedAt: null,
      expiresAt: new Date(Date.now() + 86_400_000),
      user: { id: 'u-2', email: 'stranger@example.com', isActive: true, role: 'user' },
    });
    await expect(service.refresh('some-refresh-token')).rejects.toBeInstanceOf(UnauthorizedException);
    expect(refreshRepo.save).not.toHaveBeenCalled();
  });
});

describe('JwtAuthGuard — وضع المستخدم الواحد', () => {
  function token(jwt: JwtService, email: string): string {
    return jwt.sign({ sub: 'u-1', email, role: 'user' });
  }

  it('توكن لبريد مسموح يمر', async () => {
    const jwt = new JwtService({ secret: SECRET });
    const guard = new JwtAuthGuard(jwt, makeConfig({ ALLOWED_USER_EMAILS: ME }));
    const { context, req } = ctx(`Bearer ${token(jwt, ME)}`);
    await expect(guard.canActivate(context)).resolves.toBe(true);
    expect((req.user as { email: string }).email).toBe(ME);
  });

  it('توكن صالح لبريد خارج القائمة يُرفض فوراً (قطع الجلسات القائمة)', async () => {
    const jwt = new JwtService({ secret: SECRET });
    const guard = new JwtAuthGuard(jwt, makeConfig({ ALLOWED_USER_EMAILS: ME }));
    const { context } = ctx(`Bearer ${token(jwt, 'stranger@example.com')}`);
    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('غير معيَّن: أى توكن صالح يمر كما كان', async () => {
    const jwt = new JwtService({ secret: SECRET });
    const guard = new JwtAuthGuard(jwt, makeConfig({}));
    const { context } = ctx(`Bearer ${token(jwt, 'stranger@example.com')}`);
    await expect(guard.canActivate(context)).resolves.toBe(true);
  });
});

describe('OptionalJwtAuthGuard — وضع المستخدم الواحد', () => {
  it('الوضع المغلق: طلب بلا توكن مرفوض (لا مسار مجهول)', async () => {
    const jwt = new JwtService({ secret: SECRET });
    const guard = new OptionalJwtAuthGuard(jwt, makeConfig({ ALLOWED_USER_EMAILS: ME }));
    const { context } = ctx();
    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('الوضع المغلق: توكن تالف أو بصيغة خاطئة مرفوض', async () => {
    const jwt = new JwtService({ secret: SECRET });
    const guard = new OptionalJwtAuthGuard(jwt, makeConfig({ ALLOWED_USER_EMAILS: ME }));
    await expect(guard.canActivate(ctx('Bearer garbage').context)).rejects.toBeInstanceOf(UnauthorizedException);
    await expect(guard.canActivate(ctx('Basic abc').context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('الوضع المغلق: توكن لبريد خارج القائمة مرفوض، وللمسموح يمر ويحقن المستخدم', async () => {
    const jwt = new JwtService({ secret: SECRET });
    const guard = new OptionalJwtAuthGuard(jwt, makeConfig({ ALLOWED_USER_EMAILS: ME }));
    const bad = ctx(`Bearer ${jwt.sign({ sub: 'u-2', email: 'stranger@example.com', role: 'user' })}`);
    await expect(guard.canActivate(bad.context)).rejects.toBeInstanceOf(UnauthorizedException);
    const good = ctx(`Bearer ${jwt.sign({ sub: 'u-1', email: ME, role: 'user' })}`);
    await expect(guard.canActivate(good.context)).resolves.toBe(true);
    expect((good.req.user as { userId: string }).userId).toBe('u-1');
  });

  it('غير معيَّن: يبقى اختيارياً — بلا توكن أو بتوكن تالف يمر مجهولاً', async () => {
    const jwt = new JwtService({ secret: SECRET });
    const guard = new OptionalJwtAuthGuard(jwt, makeConfig({}));
    const anon = ctx();
    await expect(guard.canActivate(anon.context)).resolves.toBe(true);
    expect(anon.req.user).toBeUndefined();
    await expect(guard.canActivate(ctx('Bearer garbage').context)).resolves.toBe(true);
  });
});
