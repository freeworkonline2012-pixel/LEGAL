import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Equals, IsEmail, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail()
  @MaxLength(254)
  email: string;

  @ApiProperty({ example: 'strong-pass-123', minLength: 8 })
  @IsString()
  @MinLength(8)
  @MaxLength(72)
  password: string;

  @ApiPropertyOptional({ example: 'أحمد محمد' })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  full_name?: string;

  /**
   * موافقة صريحة على سياسة الخصوصية — إلزامية (يجب أن تكون true حرفياً،
   * لا مجرد حقل موجود). راجع migrations/051 وPRIVACY_POLICY_VERSION.
   * الواجهة الأمامية مسؤولة عن عرض نص السياسة وربط هذا الحقل بمربع اختيار
   * غير مُحدَّد افتراضياً (لا Pre-checked) — موافقة ضمنية لا تُعتبر صريحة.
   */
  @ApiProperty({
    example: true,
    description: 'يجب أن تكون true — إقرار المستخدم الصريح بالموافقة على سياسة الخصوصية',
  })
  @Equals(true, { message: 'الموافقة على سياسة الخصوصية إلزامية لإنشاء حساب' })
  consent: boolean;
}
