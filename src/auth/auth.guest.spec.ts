import { ConflictException, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import type { ExecutionContext } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { OptionalJwtAuthGuard } from '../common/guards/optional-jwt-auth.guard';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { AuthService } from './auth.service';
import { GUEST_EMAIL_DOMAIN, isGuestAccessEnabled, isGuestEmail } from './guest.constants';

const SECRET = 'x'.repeat(40);

function makeConfig(values: Record<string, string | undefined>): ConfigService {
  return { get: (k: string) => values[k] } as unknown as ConfigService;
}

function makeService(env: Record<string, string | undefined>) {
  const saved: Array<Record<string, unknown>> = [];
  const userRepo = {
    create: (v: Record<string, unknown>) => ({ id: 'u-1', createdAt: new Date(), ...v }),
    save: jest.fn(async (u: Record<string, unknown>) => {
      saved.push(u);
      return u;
    }),
    findOne: jest.fn(async () => null),
  };
  const refreshRepo = { insert: jest.fn(async () => undefined), findOne: jest.fn(), save: jest.fn() };
  const jwt = new JwtService({ secret: SECRET });
  const config = makeConfig({ JWT_SECRET: SECRET, ...env });
  const service = new AuthService(userRepo as never, refreshRepo as never, jwt, config);
  return { service, userRepo, refreshRepo, jwt, saved, config };
}

function ctx(authHeader?: string): { context: ExecutionContext; req: { headers: Record<string, string>; user?: unknown } } {
  const req: { headers: Record<string, string>; user?: unknown } = {
    headers: authHeader ? { authorization: authHeader } : {},
  };
  const context = { switchToHttp: () => ({ getRequest: () => req }) } as unknown as ExecutionContext;
  return { context, req };
}

describe('guest helpers', () => {
  it('isGuestAccessEnabled: يقبل النص الحرفى true فقط (لا تحويل ضمنى)', () => {
    expect(isGuestAccessEnabled('true')).toBe(true);
    expect(isGuestAccessEnabled(' TRUE ')).toBe(true);
    expect(isGuestAccessEnabled('false')).toBe(false);
    expect(isGuestAccessEnabled('1')).toBe(false);
    expect(isGuestAccessEnabled('')).toBe(false);
    expect(isGuestAccessEnabled(undefined)).toBe(false);
    expect(isGuestAccessEnabled(true)).toBe(false);
  });

  it('isGuestEmail: النطاق المحجوز فقط (بلا التباس مع نطاقات تنتهى بنفس النص)', () => {
    expect(isGuestEmail(`guest-1@${GUEST_EMAIL_DOMAIN}`)).toBe(true);
    expect(isGuestEmail(`GUEST-1@${GUEST_EMAIL_DOMAIN.toUpperCase()}`)).toBe(true);
    expect(isGuestEmail('a@notguest.invalid')).toBe(false);
    expect(isGuestEmail('a@guest.invalid.com')).toBe(false);
    expect(isGuestEmail('a@example.com')).toBe(false);
    expect(isGuestEmail(null)).toBe(false);
  });
});

describe('AuthService — وضع الزائر', () => {
  it('معطَّل افتراضياً: createGuest يرمى 404 ولا يكتب شيئاً', async () => {
    const { service, userRepo } = makeService({});
    await expect(service.createGuest()).rejects.toBeInstanceOf(NotFoundException);
    expect(userRepo.save).not.toHaveBeenCalled();
    expect(service.getGuestConfig().enabled).toBe(false);
  });

  it('GUEST_ACCESS_ENABLED=false (نص) يبقى معطَّلاً', async () => {
    const { service } = makeService({ GUEST_ACCESS_ENABLED: 'false' });
    await expect(service.createGuest()).rejects.toBeInstanceOf(NotFoundException);
  });

  it('مفعَّل: ينشئ حساباً معزولاً بدور user وموافقة مسجَّلة وتوكن وصول 12 ساعة', async () => {
    const { service, saved, jwt } = makeService({ GUEST_ACCESS_ENABLED: 'true' });
    const res = await service.createGuest();

    expect(saved).toHaveLength(1);
    expect(res.user.email).toMatch(new RegExp(`^guest-[0-9a-f-]{36}@${GUEST_EMAIL_DOMAIN}$`));
    expect(res.user.role).toBe('user');
    expect(res.user.consent_given_at).not.toBeNull();
    expect(res.user.consent_version).toBeTruthy();
    expect(res.refresh_token.length).toBeGreaterThan(20);

    const payload = jwt.verify<{ exp: number; iat: number; role: string }>(res.access_token);
    expect(payload.role).toBe('user');
    expect(payload.exp - payload.iat).toBe(12 * 3600);
  });

  it('GUEST_JWT_EXPIRES_IN يضبط مدة التوكن', async () => {
    const { service, jwt } = makeService({ GUEST_ACCESS_ENABLED: 'true', GUEST_JWT_EXPIRES_IN: '2h' });
    const res = await service.createGuest();
    const p = jwt.verify<{ exp: number; iat: number }>(res.access_token);
    expect(p.exp - p.iat).toBe(2 * 3600);
  });

  it('كل زائر حساب مختلف', async () => {
    const { service } = makeService({ GUEST_ACCESS_ENABLED: 'true' });
    const a = await service.createGuest();
    const b = await service.createGuest();
    expect(a.user.email).not.toBe(b.user.email);
  });

  it('لا دخول بكلمة مرور لحساب زائر (login يرفض قبل أى استعلام)', async () => {
    const { service, userRepo } = makeService({ GUEST_ACCESS_ENABLED: 'true' });
    await expect(service.login(`guest-abc@${GUEST_EMAIL_DOMAIN}`, 'anything-123')).rejects.toBeInstanceOf(
      UnauthorizedException,
    );
    expect(userRepo.findOne).not.toHaveBeenCalled();
  });

  it('التجزئة المخزَّنة للزائر لا تطابق أى كلمة مرور', async () => {
    const { service, saved } = makeService({ GUEST_ACCESS_ENABLED: 'true' });
    await service.createGuest();
    const hash = String(saved[0].passwordHash);
    await expect(bcrypt.compare('', hash)).resolves.toBe(false);
    await expect(bcrypt.compare('password', hash)).resolves.toBe(false);
  });

  it('التسجيل بالنطاق المحجوز مرفوض', async () => {
    const { service } = makeService({ GUEST_ACCESS_ENABLED: 'true' });
    await expect(service.register(`me@${GUEST_EMAIL_DOMAIN}`, 'strong-pass-123')).rejects.toBeInstanceOf(
      ConflictException,
    );
  });

  it('refresh لتوكن زائر بعد تعطيل الوضع مرفوض', async () => {
    const { service, refreshRepo } = makeService({ GUEST_ACCESS_ENABLED: 'false' });
    refreshRepo.findOne.mockResolvedValueOnce({
      revokedAt: null,
      expiresAt: new Date(Date.now() + 1e6),
      user: { id: 'g', email: `guest-x@${GUEST_EMAIL_DOMAIN}`, isActive: true },
    });
    await expect(service.refresh('tok')).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('المستخدم العادى بلا تغيير: توكن 15 دقيقة', async () => {
    const hash = await bcrypt.hash('strong-pass-123', 4);
    const { service, userRepo, jwt } = makeService({});
    userRepo.findOne.mockResolvedValueOnce({
      id: 'r1',
      email: 'real@example.com',
      passwordHash: hash,
      role: 'user',
      isActive: true,
      createdAt: new Date(),
      consentGivenAt: null,
      consentVersion: null,
      fullName: null,
    } as never);
    const res = await service.login('real@example.com', 'strong-pass-123');
    const p = jwt.verify<{ exp: number; iat: number }>(res.access_token);
    expect(p.exp - p.iat).toBe(15 * 60);
  });
});

describe('الحراس — مفتاح الإيقاف الفورى', () => {
  const jwt = new JwtService({ secret: SECRET });
  const guestToken = jwt.sign({ sub: 'g1', email: `guest-1@${GUEST_EMAIL_DOMAIN}`, role: 'user' });
  const realToken = jwt.sign({ sub: 'r1', email: 'real@example.com', role: 'user' });

  it('JwtAuthGuard: توكن زائر مقبول والوضع مفعّل', async () => {
    const guard = new JwtAuthGuard(jwt, makeConfig({ GUEST_ACCESS_ENABLED: 'true' }));
    const { context, req } = ctx(`Bearer ${guestToken}`);
    await expect(guard.canActivate(context)).resolves.toBe(true);
    expect((req.user as { userId: string }).userId).toBe('g1');
  });

  it('JwtAuthGuard: توكن زائر يُرفض فور تعطيل الوضع (حتى لو لم تنتهِ صلاحيته)', async () => {
    const guard = new JwtAuthGuard(jwt, makeConfig({ GUEST_ACCESS_ENABLED: 'false' }));
    const { context } = ctx(`Bearer ${guestToken}`);
    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('JwtAuthGuard: توكن مستخدم عادى لا يتأثر بالمفتاح', async () => {
    const guard = new JwtAuthGuard(jwt, makeConfig({ GUEST_ACCESS_ENABLED: 'false' }));
    const { context } = ctx(`Bearer ${realToken}`);
    await expect(guard.canActivate(context)).resolves.toBe(true);
  });

  it('JwtAuthGuard: بلا ConfigService يقرأ process.env (توافق مع الإنشاء اليدوى)', async () => {
    delete process.env.GUEST_ACCESS_ENABLED;
    const guard = new JwtAuthGuard(jwt);
    const { context } = ctx(`Bearer ${guestToken}`);
    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('JwtAuthGuard: بلا توكن ما زال 401', async () => {
    const guard = new JwtAuthGuard(jwt, makeConfig({ GUEST_ACCESS_ENABLED: 'true' }));
    await expect(guard.canActivate(ctx().context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('OptionalJwtAuthGuard: توكن زائر بعد التعطيل = مجهول (لا user)', async () => {
    const guard = new OptionalJwtAuthGuard(jwt, makeConfig({ GUEST_ACCESS_ENABLED: 'false' }));
    const { context, req } = ctx(`Bearer ${guestToken}`);
    await expect(guard.canActivate(context)).resolves.toBe(true);
    expect(req.user).toBeUndefined();
  });

  it('OptionalJwtAuthGuard: توكن زائر والوضع مفعّل = user محقون', async () => {
    const guard = new OptionalJwtAuthGuard(jwt, makeConfig({ GUEST_ACCESS_ENABLED: 'true' }));
    const { context, req } = ctx(`Bearer ${guestToken}`);
    await guard.canActivate(context);
    expect((req.user as { userId: string }).userId).toBe('g1');
  });
});
