import { Body, Controller, Get, HttpCode, HttpStatus, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiCreatedResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import type { AuthenticatedUser } from '../common/interfaces/authenticated-user.interface';
import { AuditService } from '../audit/audit.service';
import { AuthService } from './auth.service';
import { AuthResponseDto, LogoutResponseDto, UserResponseDto } from './dto/auth-response.dto';
import { LoginDto } from './dto/login.dto';
import { LogoutDto } from './dto/logout.dto';
import { RefreshDto } from './dto/refresh.dto';
import { RegisterDto } from './dto/register.dto';

/** عتبة أشد على نقاط المصادقة (10 محاولات/دقيقة لكل IP) */
const AUTH_THROTTLE = { default: { limit: 10, ttl: 60_000 } };

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly auditService: AuditService,
  ) {}

  @Post('register')
  @Throttle(AUTH_THROTTLE)
  @HttpCode(HttpStatus.CREATED)
  @ApiCreatedResponse({
    description: 'إنشاء حساب جديد',
    type: UserResponseDto,
  })
  async register(@Body() dto: RegisterDto): Promise<UserResponseDto> {
    const user = await this.authService.register(dto.email, dto.password, dto.full_name);
    await this.auditService.record({
      actorId: user.id,
      actorRole: user.role,
      action: 'auth.registered',
      resourceType: 'user',
      resourceId: user.id,
    });
    return user;
  }

  @Post('login')
  @Throttle(AUTH_THROTTLE)
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ description: 'تسجيل الدخول', type: AuthResponseDto })
  async login(@Body() dto: LoginDto): Promise<AuthResponseDto> {
    const result = await this.authService.login(dto.email, dto.password);
    await this.auditService.record({
      actorId: result.user.id,
      actorRole: result.user.role,
      action: 'auth.logged_in',
      resourceType: 'user',
      resourceId: result.user.id,
    });
    return result;
  }

  @Post('refresh')
  @Throttle(AUTH_THROTTLE)
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ description: 'تحديث التوكنين', type: AuthResponseDto })
  async refresh(@Body() dto: RefreshDto): Promise<AuthResponseDto> {
    return this.authService.refresh(dto.refresh_token);
  }

  @Post('logout')
  @Throttle(AUTH_THROTTLE)
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({
    description: 'إبطال توكن التحديث',
    type: LogoutResponseDto,
  })
  async logout(@Body() dto: LogoutDto): Promise<LogoutResponseDto> {
    return this.authService.logout(dto.refresh_token);
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOkResponse({
    description: 'الملف الشخصي للمستخدم الحالي',
    type: UserResponseDto,
  })
  async me(@CurrentUser() user: AuthenticatedUser): Promise<UserResponseDto> {
    return this.authService.getProfile(user.userId);
  }
}
