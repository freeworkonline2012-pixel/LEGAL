import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';

/** حقول نموذج multipart (الملف نفسه يصل عبر FileInterceptor). */
export class AnalyzeDocumentDto {
  @ApiProperty({
    enum: ['true'],
    description: 'موافقة العميل الصريحة على إرسال نص المستند (بعد إخفاء البيانات الشخصية) لمزوّد نموذج خارجى',
  })
  @IsString()
  @IsIn(['true'], { message: 'يلزم الموافقة الصريحة على معالجة المستند قبل رفعه' })
  consent: string;

  @ApiPropertyOptional({ description: 'سؤال العميل — لتحديد الوقائع الأهم فقط، لا يُخزَّن هنا' })
  @IsOptional()
  @IsString()
  @MaxLength(2_000)
  question?: string;
}
