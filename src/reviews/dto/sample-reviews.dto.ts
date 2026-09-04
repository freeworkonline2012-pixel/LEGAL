import { ApiProperty } from '@nestjs/swagger';
import { IsInt, Max, Min } from 'class-validator';

/**
 * migrations/031 — Phase 1 من "الخدمة الأولى" (تصور-تقنى-محترف-ثلاث-خدمات-
 * ذكاء-اصطناعى، القسم 2.3، بند "عيّنة عشوائية من الأسئلة المُجاب عليها").
 * حد أقصى 200 فى الطلب الواحد — يمنع طلباً واحداً من إغراق طابور المراجعة
 * البشرية بالكامل دفعة واحدة (كلفة مراجعة بشرية محدودة، يُفضَّل التحكم فيها
 * بطلبات متكررة صغيرة بدل طلب ضخم واحد).
 */
export class SampleReviewsDto {
  @ApiProperty({
    example: 20,
    minimum: 1,
    maximum: 200,
    description: 'عدد الإجابات (غير المرفوضة) المطلوب أخذها كعيّنة عشوائية للمراجعة',
  })
  @IsInt()
  @Min(1)
  @Max(200)
  count: number;
}
