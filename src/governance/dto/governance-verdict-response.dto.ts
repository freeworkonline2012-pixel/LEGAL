import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import type { GovernanceVerdict } from '../../llm/deepseek-generation.service';

/**
 * عقد الحكم البنيوى — يطابق حرفياً صيغة القسم 4.3 من project doc
 * (تصور-تقنى-محترف-ثلاث-خدمات-ذكاء-اصطناعى-2026-09-02.md):
 * {verdict, legal_basis, risk_note, confidence}.
 */
export class GovernanceLegalBasisDto {
  @ApiProperty({ example: 'قانون مكافحة غسل الأموال' })
  law: string;

  @ApiProperty({ example: 80 })
  law_no: number;

  @ApiProperty({ example: 2002 })
  law_year: number;

  @ApiProperty({ example: 12 })
  article_no: number;

  @ApiProperty({ example: 'تلتزم المؤسسات المالية بالإبلاغ عن العمليات المشبوهة...' })
  snippet: string;

  /**
   * رابط المصدر الرسمى للقانون/القرار (من laws.official_url) — خطوة ثقة
   * إضافية تتيح للمستخدم مراجعة النص الكامل من مصدره الرسمى مباشرة، بدل
   * الاكتفاء بالمقتطف المعروض. null إن لم يكن الرابط مسجَّلاً لهذا القانون
   * تحديداً (نادر: 151 من 153 قانوناً فى القاعدة، و18/18 فى نطاق الحوكمة
   * تحديداً، تحمل رابطاً وقت كتابة هذا — راجع project doc ذات الصلة).
   * هذا لا يُغنى عن التحقق الداخلى من `snippet` نفسه — الرابط للمستخدم
   * البشرى، لا بديل عن استرجاع/تحقق النص الذى يبنى عليه النظام حكمه.
   */
  @ApiPropertyOptional({
    example: 'https://fra.gov.eg/wp-content/uploads/2023/10/كتاب-دوري-4.pdf',
    nullable: true,
  })
  official_url: string | null;
}

export class GovernanceVerdictResponseDto {
  @ApiProperty({
    example: 'غير متوافق',
    enum: ['متوافق', 'غير متوافق', 'متوافق جزئياً', 'معلومات غير كافية'],
    description:
      '"معلومات غير كافية" هو الافتراضى الآمن عند أى شك حقيقى (لا مادة كافية، أو ' +
      'خدمة التقييم الآلى غير متاحة تقنياً) — وليس علامة فشل، بل قرار fail-closed ' +
      'متعمَّد؛ راجع تعليق GovernanceService.assess لسياسة أكثر تحفظاً عمداً من ' +
      '/api/questions.',
  })
  verdict: GovernanceVerdict;

  @ApiProperty({ type: GovernanceLegalBasisDto, isArray: true })
  legal_basis: GovernanceLegalBasisDto[];

  @ApiProperty({
    example: 'عدم الإبلاغ يُعرِّض المؤسسة لعقوبات جنائية وإدارية بموجب المادة 15.',
  })
  risk_note: string;

  @ApiPropertyOptional({
    example: 0.82,
    minimum: 0,
    maximum: 1,
    description: 'ثقة داخلية — مفيدة للمراجعة اللاحقة، لا تُعرَض كضمان دقة للمستخدم مباشرة.',
  })
  confidence: number;
}
