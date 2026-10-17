import {
  ConflictException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcryptjs';
import { createHash, randomBytes, randomUUID } from 'crypto';
import type { StringValue } from 'ms';
import { Repository } from 'typeorm';
import { PRIVACY_POLICY_VERSION } from '../common/constants/privacy-policy';
import { RefreshToken } from '../database/entities/refresh-token.entity';
import { User } from '../database/entities/user.entity';
import { AuthResponseDto, UserResponseDto } from './dto/auth-response.dto';
import { GuestConfigResponseDto } from './dto/guest.dto';
import {
  GUEST_DEFAULT_ACCESS_TOKEN_TTL,
  GUEST_EMAIL_DOMAIN,
  GUEST_REFRESH_TOKEN_DAYS,
  GUEST_UNUSABLE_PASSWORD_HASH,
  isGuestAccessEnabled,
  isGuestEmail,
} from './guest.constants';
import type { JwtPayload, TokenPair } from './interfaces/jwt-payload.interface';

const BCRYPT_ROUNDS = 12;
const ACCESS_TOKEN_ALGO = 'HS256';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(RefreshToken)
    private readonly refreshTokenRepository: Repository<RefreshToken>,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async register(
    email: string,
    password: string,
    fullName?: string,
  ): Promise<UserResponseDto> {
    const normalizedEmail = email.trim().toLowerCase();

    // النطاق guest.invalid محجوز لحسابات الزوار المؤقتة فقط
    if (isGuestEmail(normalizedEmail)) {
      throw new ConflictException('email already registered');
    }

    const existing = await this.userRepository.findOne({
      where: { email: normalizedEmail },
    });
    if (existing) {
      throw new ConflictException('email already registered');
    }

    const passwordHash = await bcrypt.hash(password, BCRYPT_ROUNDS);

    // consent يُتحقَّق منه بالفعل فى RegisterDto (@Equals(true)) قبل وصوله
    // هنا — لا فرع "ماذا لو false" لأن الطلب كان سيُرفَض بـ400 قبل استدعاء
    // هذه الدالة أصلاً. التوقيت المسجَّل هنا (لا وقت الطلب فى الـcontroller)
    // عمداً لضمان اتساقه مع created_at لنفس الصف.
    const user = this.userRepository.create({
      email: normalizedEmail,
      passwordHash,
      fullName: fullName?.trim() ? fullName.trim() : null,
      role: 'user',
      isActive: true,
      consentGivenAt: new Date(),
      consentVersion: PRIVACY_POLICY_VERSION,
    });
    // save (وليس insert): نعتمد على القيم المولّدة من قاعدة البيانات (id, created_at)
    // في toUserResponse — insert لا يعيدها إلى كائن الكيان.
    await this.userRepository.save(user);

    return this.toUserResponse(user);
  }

  async login(email: string, password: string): Promise<AuthResponseDto> {
    const normalizedEmail = email.trim().toLowerCase();

    // حسابات الزوار بلا كلمة مرور — لا يُسمح بتسجيل الدخول لها عبر هذا المسار إطلاقاً
    if (isGuestEmail(normalizedEmail)) {
      throw new UnauthorizedException('invalid credentials');
    }

    const user = await this.userRepository.findOne({
      where: { email: normalizedEmail },
    });
    if (!user) {
      throw new UnauthorizedException('invalid credentials');
    }
    if (!user.isActive) {
      throw new UnauthorizedException('account disabled');
    }

    const passwordMatches = await bcrypt.compare(password, user.passwordHash);
    if (!passwordMatches) {
      throw new UnauthorizedException('invalid credentials');
    }

    const pair = await this.createTokenPair(user);
    return this.toAuthResponse(user, pair);
  }

  async refresh(refreshToken: string): Promise<AuthResponseDto> {
    const tokenHash = this.hashToken(refreshToken);

    const stored = await this.refreshTokenRepository.findOne({
      where: { tokenHash },
      relations: { user: true },
    });

    if (!stored || stored.revokedAt) {
      throw new UnauthorizedException('invalid refresh token');
    }
    if (stored.expiresAt.getTime() < Date.now()) {
      throw new UnauthorizedException('refresh token expired');
    }
    if (!stored.user.isActive) {
      throw new UnauthorizedException('account disabled');
    }
    if (isGuestEmail(stored.user.email) && !this.isGuestEnabled()) {
      throw new UnauthorizedException('guest access disabled');
    }

    // تدوير التوكن: إبطال القديم وإصدار جديد
    stored.revokedAt = new Date();
    await this.refreshTokenRepository.save(stored);

    const pair = await this.createTokenPair(stored.user);
    return this.toAuthResponse(stored.user, pair);
  }

  async logout(refreshToken: string): Promise<{ success: true }> {
    const tokenHash = this.hashToken(refreshToken);
    const stored = await this.refreshTokenRepository.findOne({
      where: { tokenHash },
    });
    if (stored && !stored.revokedAt) {
      stored.revokedAt = new Date();
      await this.refreshTokenRepository.save(stored);
    }
    return { success: true };
  }

  /** هل وضع الزائر مفعّل؟ (GUEST_ACCESS_ENABLED=true حرفياً) */
  isGuestEnabled(): boolean {
    return isGuestAccessEnabled(this.configService.get<string>('GUEST_ACCESS_ENABLED'));
  }

  getGuestConfig(): GuestConfigResponseDto {
    return { enabled: this.isGuestEnabled(), consent_version: PRIVACY_POLICY_VERSION };
  }

  /**
   * ينشئ حساب زائر مؤقتاً معزولاً (بريد عشوائى على نطاق محجوز، بلا كلمة مرور)
   * ويُصدر له توكن عادى. الدور دائماً 'user' — لا وصول لطابور مراجعة المحامين
   * ولا لأدوات admin. يتطلب موافقة صريحة (يتحقق منها CreateGuestDto).
   * 404 عند تعطيل الوضع (لا يكشف وجود الميزة).
   */
  async createGuest(): Promise<AuthResponseDto> {
    if (!this.isGuestEnabled()) {
      throw new NotFoundException();
    }

    const user = this.userRepository.create({
      email: `guest-${randomUUID()}@${GUEST_EMAIL_DOMAIN}`,
      passwordHash: GUEST_UNUSABLE_PASSWORD_HASH,
      fullName: null,
      role: 'user',
      isActive: true,
      consentGivenAt: new Date(),
      consentVersion: PRIVACY_POLICY_VERSION,
    });
    await this.userRepository.save(user);

    const pair = await this.createTokenPair(user);
    return this.toAuthResponse(user, pair);
  }

  async getProfile(userId: string): Promise<UserResponseDto> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new UnauthorizedException('user not found');
    }
    return this.toUserResponse(user);
  }

  private async createTokenPair(user: User): Promise<TokenPair> {
    const payload: JwtPayload = {
      sub: user.id,
      email: user.email,
      role: user.role,
    };

    // الزائر: توكن وصول أطول (افتراضى 12 ساعة) لأن الواجهة لا تجدّد التوكن آلياً،
    // وتوكن تحديث ليوم واحد فقط. المستخدم العادى: بلا أى تغيير.
    const guest = isGuestEmail(user.email);
    const accessTtl = guest
      ? (this.configService.get<string>('GUEST_JWT_EXPIRES_IN') ?? GUEST_DEFAULT_ACCESS_TOKEN_TTL)
      : (this.configService.get<string>('JWT_EXPIRES_IN') ?? '15m');

    const accessToken = await this.jwtService.signAsync(payload, {
      secret: this.configService.get<string>('JWT_SECRET'),
      expiresIn: accessTtl as StringValue,
      algorithm: ACCESS_TOKEN_ALGO,
    });

    const refreshToken = randomBytes(48).toString('base64url');
    const expiresInDays = guest
      ? GUEST_REFRESH_TOKEN_DAYS
      : this.parseDays(this.configService.get<string>('REFRESH_TOKEN_EXPIRES_IN') ?? '30d');

    await this.refreshTokenRepository.insert({
      userId: user.id,
      tokenHash: this.hashToken(refreshToken),
      expiresAt: new Date(Date.now() + expiresInDays * 24 * 60 * 60 * 1000),
    });

    return { accessToken, refreshToken };
  }

  private hashToken(token: string): string {
    return createHash('sha256').update(token).digest('hex');
  }

  private parseDays(value: string): number {
    const match = /^(\d+)d$/.exec(value);
    if (!match) {
      return 30;
    }
    return Number(match[1]);
  }

  private toUserResponse(user: User): UserResponseDto {
    return {
      id: user.id,
      email: user.email,
      full_name: user.fullName,
      role: user.role,
      created_at: user.createdAt.toISOString(),
      consent_given_at: user.consentGivenAt ? user.consentGivenAt.toISOString() : null,
      consent_version: user.consentVersion,
    };
  }

  private toAuthResponse(user: User, pair: TokenPair): AuthResponseDto {
    return {
      access_token: pair.accessToken,
      refresh_token: pair.refreshToken,
      user: this.toUserResponse(user),
    };
  }
}
