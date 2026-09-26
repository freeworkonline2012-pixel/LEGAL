import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/**
 * عقد الإجابة — يطابق حرفياً عقد API الإصدار 0.1 في docs/build/implementation_notes.md (القسم 4).
 */
export class CitationResponseDto {
  @ApiProperty({ example: 'قانون العمل' })
  law: string;

  @ApiProperty({ example: 12 })
  law_no: number;

  @ApiProperty({ example: 2003 })
  law_year: number;

  @ApiProperty({ example: 110 })
  article_no: number;

  @ApiProperty({ example: 'active', enum: ['active', 'amended', 'repealed'] })
  status: string;

  @ApiPropertyOptional({ example: null, nullable: true })
  last_amended: string | null;

  @ApiPropertyOptional({ example: 'https://example.gov.eg/law/12-2003', nullable: true })
  official_url: string | null;

  @ApiProperty({ example: 'يستحق العامل إجازة سنوية مدفوعة الأجر...' })
  snippet: string;
}

export class WebFallbackSourceDto {
  @ApiProperty({ example: 'قرار مجلس إدارة الهيئة رقم 98 لسنة 2023' })
  title: string;

  @ApiProperty({ example: 'https://fra.gov.eg/...' })
  url: string;

  @ApiProperty({ example: 'زيادة الحد الأقصى للتمويل...' })
  snippet: string;
}

export class WebFallbackResponseDto {
  @ApiProperty({
    description:
      'إجابة غير موثَّقة من قاعدة البيانات القانونية — نتيجة بحث ويب مقيَّد ' +
      'النطاق (مصادر رسمية فقط)، تتضمن دائماً تنويهاً صريحاً فى نهايتها. لا ' +
      'تُعامَل بنفس ثقة citations. حقل إضافى يظهر فقط عندما refused=true ' +
      'وكانت خاصية ENABLE_WEB_FALLBACK مفعَّلة ووُجدت نتائج ضمن النطاق المسموح.',
  })
  answer: string;

  @ApiProperty({ type: WebFallbackSourceDto, isArray: true })
  sources: WebFallbackSourceDto[];

  @ApiProperty({ example: 'tavily' })
  provider: string;
}

export class AnswerResponseDto {
  @ApiProperty({
    example: 'a-uuid',
    description:
      'معرّف الإجابة المحفوظة — يُستخدم كـ answer_id في POST /api/feedback (عقد C-2). إلزامي في الرد الفعلي (openapi.yaml) ويُضبط قبل الإرجاع في ask()؛ اختياري هنا لأن كائن DTO يُبنى قبل حفظ الكيان.',
  })
  id?: string;

  @ApiProperty({
    example: 'لا تتوفر معلومة موثقة كافية للإجابة بدقة.',
    description: 'نص الإجابة (عند الرفض: جملة الرفض الصريحة)',
  })
  answer: string;

  // "إلغاء بادج الثقة بالكامل" (2026-09-25 — قرار صريح من رجل الأعمال):
  // كان هذا الحقل confidence: number موجوداً هنا (وفى QuestionHistoryItemDto
  // فى question-response.dto.ts) قبل هذا القرار، ثم أُضيفت إليه فى نفس اليوم
  // ميزة "ربط بادج الثقة بتقييم دقة الإجابة" (راجع computeFinalConfidence فى
  // questions.service.ts، أُزيلت الآن بالكامل). سبب الإلغاء الكامل (لا مجرد
  // التراجع عن إضافة اليوم): اختبار حى تالٍ مباشرة (تقييم 7/10 لسؤال حقوق
  // الموظف عند عدم تجديد العقد المؤقت مقارنة بمستند مرجعى) كشف أن الإجابة
  // أسقطت مادتين متاحتين فعلياً (159، 161) من التوليف رغم نجاح التوليد
  // ونظافته من أى رفض — وهذا نوع من نقص الدقة لا يكشفه confidence الأصلى (كان
  // ثقة استرجاع بحتة، لا صلة له بجودة التوليف) ولا الإضافة الملغاة (كانت تكشف
  // فقط رفض بوابة الهلوسة، لا إسقاط الشمول). بمعنى: كل نسخة من هذا الحقل
  // جُرِّبت فعلياً هذه الجلسة أعطت ثقة لا تعكس الدقة الفعلية للإجابة، فقرر
  // رجل الأعمال إزالته من عقد الـAPI كلياً بدل الاستمرار فى تصحيحه تدريجياً.
  // القيمة تبقى مُخزَّنة داخلياً فى عمود Answer.confidence لأغراض التدقيق
  // (AuditModule) فقط — راجع تعليق ask() فى questions.service.ts — دون أى
  // كشف لها فى أى استجابة API. ⚠️ يطابق docs/build/implementation_notes.md
  // (القسم 4) وopenapi.yaml (إن وُجدا فى مستودع آخر غير هذا الفرع) — يلزم
  // تحديثهما يدوياً بإزالة confidence من عقد الإجابة الموثَّق فيهما أيضاً.

  @ApiProperty({ type: CitationResponseDto, isArray: true })
  citations: CitationResponseDto[];

  @ApiProperty({ example: false })
  refused: boolean;

  @ApiPropertyOptional({
    type: WebFallbackResponseDto,
    nullable: true,
    description:
      'يظهر فقط عندما refused=true وتوفَّرت نتيجة احتياطية من بحث ويب مقيَّد ' +
      'النطاق (Tier 2 — راجع WebSearchFallbackService). غائب/null فى كل الحالات ' +
      'الأخرى، بما فيها كل الاستخدام الحالى قبل تفعيل ENABLE_WEB_FALLBACK.',
  })
  web_fallback?: WebFallbackResponseDto | null;
}
