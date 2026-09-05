import { ApiProperty } from '@nestjs/swagger';
import { IsString, MaxLength, MinLength } from 'class-validator';

export class AssessGovernanceDto {
  @ApiProperty({
    example: 'شركة تمويل استهلاكى تنوي عدم إبلاغ وحدة مكافحة غسل الأموال عن عملية تحويل تتجاوز الحد المقرر',
    description:
      'وصف حر بالعربية لإجراء أو قرار يعتزم المستخدم اتخاذه، يُفحَص مقابل نطاق ' +
      'الحوكمة والالتزام والمخاطر المفهرَس حالياً (مكافحة غسل أموال/تمويل ' +
      'إرهاب، تأمين، تمويل غير مصرفى) — وليس سؤالاً عاماً كما فى /api/questions.',
  })
  @IsString()
  @MinLength(10)
  @MaxLength(4_000)
  action_description: string;
}
