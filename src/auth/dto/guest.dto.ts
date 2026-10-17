import { ApiProperty } from '@nestjs/swagger';
import { Equals } from 'class-validator';

export class CreateGuestDto {
  /**
   * موافقة صريحة على سياسة الخصوصية — إلزامية حتى للزائر (قانون 151/2020):
   * الواجهة تعرض زر «موافق وابدأ» ولا ترسل true إلا بعد ضغطه (أو بعد موافقة
   * سابقة محفوظة على نفس نسخة السياسة).
   */
  @ApiProperty({ example: true, description: 'يجب أن تكون true — موافقة صريحة على سياسة الخصوصية' })
  @Equals(true, { message: 'الموافقة على سياسة الخصوصية إلزامية لبدء جلسة زائر' })
  consent: boolean;
}

export class GuestConfigResponseDto {
  @ApiProperty({ example: false, description: 'هل وضع الزائر مفعّل حالياً؟' })
  enabled: boolean;

  @ApiProperty({ example: '2026-09-12-draft-v1', description: 'نسخة سياسة الخصوصية المطلوب الموافقة عليها' })
  consent_version: string;
}
