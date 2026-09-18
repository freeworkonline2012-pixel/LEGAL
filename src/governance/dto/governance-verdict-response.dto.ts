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

/** مصدر ويب فردى — نفس بنية WebFallbackSource فى web-search-fallback.service.ts
 * (مكرَّرة هنا كـDTO مستقل بدل استيراد النوع الداخلى مباشرة فى عقد API عام). */
export class GovernanceWebSourceDto {
  @ApiProperty({ example: 'الهيئة العامة للرقابة المالية — كتاب دورى' })
  title: string;

  @ApiProperty({ example: 'https://fra.gov.eg/...' })
  url: string;

  @ApiProperty({ example: 'مقتطف من نص الصفحة ذو صلة بالسؤال...' })
  snippet: string;
}

/**
 * طبقة النصيحة (2026-09-18) — راجع تقرير بناء طبقة النصيحة بنفس التاريخ
 * للقرار الكامل والتبرير. تُبنى **فوق** {verdict, legal_basis, risk_note,
 * confidence} الأساسى بلا أى تعديل عليه — إضافة صرفة لا تُغيِّر معنى أو قيمة
 * أى حقل أساسى موجود مسبقاً (القسم 4.3 من project doc يبقى كما هو حرفياً).
 */
export class GovernanceRecommendationDto {
  @ApiProperty({
    example: 'غير موصى به',
    enum: ['موصى به', 'غير موصى به', 'موصى به بشرط'],
    description:
      '"موصى به بشرط" حصراً عندما verdict الأساسى = "متوافق جزئياً" — راجع ' +
      'conditions_for_compliance أدناه للشروط الدقيقة؛ ليست تصنيفاً ثنائياً ' +
      'مُجبَراً على "غير موصى به" لأن الإجراء الجزئى قد يكون معقولاً للمضى فيه ' +
      'أثناء استيفاء الشروط الباقية — القرار التجارى النهائى يبقى لصاحب المشروع.',
  })
  advice: 'موصى به' | 'غير موصى به' | 'موصى به بشرط';

  @ApiProperty({
    example: 'الإجراء يخالف صراحة المادة 12 من القانون رقم 80 لسنة 2002 لعدم استيفاء إخطار الجهة الرقابية.',
  })
  reasoning: string;

  @ApiProperty({
    example: 'database',
    enum: ['database', 'web_supplementary'],
    description:
      '"database": التوصية مبنية مباشرة على legal_basis المسترجَع والمتحقَّق ' +
      'منه من قاعدتنا القانونية — بنفس درجة ثقة verdict الأساسى تماماً. ' +
      '"web_supplementary": طبقة تكميلية من بحث ويب مقيَّد النطاق (allowlist)، ' +
      'تظهر فقط عندما verdict="معلومات غير كافية" — **لا تُغيِّر أو تُلغى** ' +
      'الحكم الأساسى fail-closed إطلاقاً، ودائماً بثقة أقل بنيوياً ومُعلَّمة ' +
      'بوضوح كمصدر منفصل غير موثَّق داخلياً.',
  })
  basis_type: 'database' | 'web_supplementary';

  @ApiPropertyOptional({
    example: 0.82,
    minimum: 0,
    maximum: 1,
    description:
      'ثقة التوصية تحديداً — منفصلة عن confidence الخاص بـverdict الأساسى أعلاه ' +
      '(عادة نفس القيمة عندما basis_type="database"، وأقل بنيوياً دائماً عندما ' +
      'basis_type="web_supplementary").',
  })
  confidence: number;

  @ApiPropertyOptional({
    type: [String],
    example: ['استيفاء إخطار الجهة الرقابية كتابياً خلال المهلة المتبقية', 'توثيق موافقة مجلس الإدارة'],
    description: 'الشروط اللازمة تحديداً للانتقال من "متوافق جزئياً" إلى "متوافق" الكامل — موجودة فقط عندما verdict="متوافق جزئياً"، وإلا null.',
    nullable: true,
  })
  conditions_for_compliance: string[] | null;

  @ApiPropertyOptional({
    type: GovernanceLegalBasisDto,
    isArray: true,
    description:
      'الأجزاء المخالفة تحديداً (نفس عناصر legal_basis أعلاه، مكرَّرة هنا صراحةً ' +
      'لوضوح العقد دون إجبار المستهلك على الاستنتاج) — موجودة فقط عندما ' +
      'verdict="غير متوافق"، وإلا null.',
    nullable: true,
  })
  violated_provisions: GovernanceLegalBasisDto[] | null;

  @ApiPropertyOptional({
    type: GovernanceWebSourceDto,
    isArray: true,
    description: 'مصادر بحث الويب المُستخدَمة — موجودة فقط عندما basis_type="web_supplementary"، وإلا null.',
    nullable: true,
  })
  web_sources: GovernanceWebSourceDto[] | null;

  @ApiPropertyOptional({
    example:
      '⚠️ هذه التوصية تكميلية من بحث ويب عام، وليست مبنية على قاعدتنا القانونية المُراجَعة — لا تُغنى عن مراجعة مستشار قانونى قبل اتخاذ أى قرار.',
    description: 'تنويه إلزامى — موجود فقط عندما basis_type="web_supplementary"، وإلا null.',
    nullable: true,
  })
  disclaimer: string | null;

  /**
   * طبقة استشهاد العقوبة (مشروع منفصل — 2026-09-18، راجع تقريره الخاص).
   * مبنية على استرجاع + تحقق دلالى من نفس قوانين legal_basis أعلاه (لا بحث
   * ويب) — تُحاوَل فقط عندما verdict="غير متوافق" أو "متوافق جزئياً".
   */
  @ApiPropertyOptional({
    type: GovernanceLegalBasisDto,
    isArray: true,
    description:
      'مادة (مواد) العقوبة المنطبقة تحديداً على هذه المخالفة (لا أى عقوبة ' +
      'أخرى فى نفس القانون تخص فعلاً مختلفاً — القوانين المصرية كثيراً ما ' +
      'تحوى عدة مواد عقوبة منفصلة) — موجودة فقط عندما verdict="غير متوافق" ' +
      'أو "متوافق جزئياً" ووُجدت عقوبة مطابقة تحديداً وبثقة كافية. **null لا ' +
      'يعنى عدم وجود عقوبة أصلاً** — فقط أن النظام لم يحدد واحدة بثقة كافية ' +
      'آلياً؛ يلزم مراجعة مستشار قانونى للتأكد فى كل الأحوال.',
    nullable: true,
  })
  applicable_penalties: GovernanceLegalBasisDto[] | null;

  @ApiPropertyOptional({
    example:
      'يُعاقَب على هذه المخالفة بالسجن مدة لا تجاوز سبع سنوات وبغرامة تعادل مثلى الأموال محل الجريمة (المادة 14).',
    description: 'شرح مبسَّط بلغة غير متخصصة لمضمون applicable_penalties أعلاه — موجود فقط معها، وإلا null.',
    nullable: true,
  })
  penalty_note: string | null;
}

export class GovernanceVerdictResponseDto {
  @ApiProperty({
    example: 'غير متوافق',
    enum: ['متوافق', 'غير متوافق', 'متوافق جزئياً', 'معلومات غير كافية'],
    description:
      '"معلومات غير كافية" هو الافتراضى الآمن عند أى شك حقيقى (لا مادة كافية، أو ' +
      'خدمة التقييم الآلى غير متاحة تقنياً) — وليس علامة فشل، بل قرار fail-closed ' +
      'متعمَّد؛ راجع تعليق GovernanceService.assess لسياسة أكثر تحفظاً عمداً من ' +
      '/api/questions. **يبقى هذا الحقل الحكم الرسمى الوحيد المعتمَد دائماً** — ' +
      'حتى لو أضاف recommendation أدناه رأياً تكميلياً (basis_type="web_supplementary")، ' +
      'فذلك لا يغيّر verdict هنا إطلاقاً.',
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

  @ApiPropertyOptional({
    type: GovernanceRecommendationDto,
    nullable: true,
    description:
      'طبقة النصيحة (2026-09-18) — null فقط فى حالة نادرة: verdict="معلومات ' +
      'غير كافية" ولم تنجح طبقة بحث الويب التكميلية فى إنتاج توصية (غير ' +
      'مُفعَّلة، أو فشلت، أو قرَّرت هى أيضاً "معلومات غير كافية"). فى الحالات ' +
      'الثلاث الأخرى (متوافق/غير متوافق/متوافق جزئياً) هذا الحقل مملوء دائماً ' +
      'ومبنى مباشرة على legal_basis أعلاه (basis_type="database").',
  })
  recommendation: GovernanceRecommendationDto | null;
}
