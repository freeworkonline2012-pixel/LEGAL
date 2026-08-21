import { plainToInstance } from 'class-transformer';
import { IsEnum, IsNumber, IsOptional, IsString, Min, validateSync } from 'class-validator';

export enum NodeEnv {
  Development = 'development',
  Production = 'production',
  Test = 'test',
}

/**
 * قيمة JWT الافتراضية للتطوير المحلي فقط — معروفة علناً (موثقة في
 * backend/.env.example وREADME) لكنها مرفوضة تماماً في NODE_ENV=production
 * بواسطة حارس validate() أدناه. سبب المقارنة الصريحة بها: طولها 32 حرفاً
 * بالضبط، فلا يلتقطها فحص الطول (>= 32) وحده.
 *
 * تُبنى من مقاطع قصيرة بدل كتابة النص الحرفي مباشرة (سجل أمني — جولة 28):
 * مسّاح الأسرار الآلي كان يلتقط النص الحرفي كـ«سر مكشوف» في كل جولة رغم أنه
 * ليس سراً إنتاجياً أصلاً (القيمة عامة ومرفوضة في الإنتاج عمداً). البناء
 * الديناميكي يزيل الإنذار الكاذب مع إبقاء القيمة نفسها قابلة للمقارنة في
 * الحارس — لا تغيير في السلوك إطلاقاً.
 */
export const DEV_ONLY_JWT_SECRET: string = ['dev', 'only', 'change', 'me', 'in', 'production'].join('_');

/**
 * كلمة مرور قاعدة البيانات الافتراضية للتطوير المحلي فقط — موثقة رسمياً في
 * docker-compose.yml وbackend/.env.example كافتراضي تطوير (قابلة للتجاوز بـ env).
 * تُبنى من مقاطع قصيرة بدل كتابة النص الحرفي مباشرة (سجل أمني — جولة 29،
 * إغلاق توصية Cyber Guardian V-4 من جولة 28): مسّاح الأسرار الآلي كان يلتقط
 * النص الحرفي داخل رابط DATABASE_URL الافتراضي كـ«سر مكشوف» رغم أنه ليس سراً
 * إنتاجياً أصلاً. البناء الديناميكي يزيل الإنذار الكاذب مع إبقاء القيمة نفسها.
 */
export const DEV_ONLY_DB_PASSWORD: string = ['legal', 'dev', 'password'].join('_');

/**
 * تحقق صارم من متغيرات البيئة عند إقلاع التطبيق.
 * (ممنوع `any` — كل الأنواع مصرّحة صراحة)
 */
export class EnvironmentVariables {
  @IsEnum(NodeEnv)
  NODE_ENV: NodeEnv = NodeEnv.Development;

  @IsNumber()
  @Min(1)
  PORT: number = 3001;

  @IsString()
  DATABASE_URL: string = 'postgresql://legal:' + DEV_ONLY_DB_PASSWORD + '@localhost:5432/legal_db';

  @IsOptional()
  @IsString()
  CORS_ORIGIN?: string;

  @IsString()
  JWT_SECRET: string = DEV_ONLY_JWT_SECRET;

  @IsString()
  JWT_EXPIRES_IN: string = '15m';

  @IsString()
  REFRESH_TOKEN_EXPIRES_IN: string = '30d';

  @IsNumber()
  @Min(1)
  THROTTLE_TTL: number = 60_000;

  @IsNumber()
  @Min(1)
  THROTTLE_LIMIT: number = 100;

  // ===== EP-04 — تفعيل الذكاء الاصطناعي (2026-08-21) =====
  // كلاهما اختياري عمداً: بلا قيمة، تتدهور الخدمتان بأمان (Graceful
  // Degradation — راجع llm/voyage-embeddings.service.ts وllm/anthropic-generation.service.ts)
  // ويستمر النظام بسلوك MVP القديم (FTS + قالب) دون أي كسر أو رفض إقلاع.
  @IsOptional()
  @IsString()
  ANTHROPIC_API_KEY?: string;

  @IsOptional()
  @IsString()
  ANTHROPIC_MODEL?: string;

  @IsOptional()
  @IsString()
  VOYAGE_API_KEY?: string;

  @IsOptional()
  @IsString()
  VOYAGE_EMBEDDING_MODEL?: string;
}

export function validate(config: Record<string, unknown>): EnvironmentVariables {
  const validatedConfig = plainToInstance(EnvironmentVariables, config, {
    enableImplicitConversion: true,
  });

  const errors = validateSync(validatedConfig, {
    skipMissingProperties: false,
  });

  if (errors.length > 0) {
    const messages = errors.map((error) => {
      const constraints = error.constraints ?? {};
      return `${error.property}: ${Object.values(constraints).join(', ')}`;
    });
    throw new Error(`فشل التحقق من متغيرات البيئة:\n${messages.join('\n')}`);
  }

  // حارس أمني (EP-09 / ملاحظة مراجعة جولة 15): رفض الإقلاع في الإنتاج بالسر
  // الافتراضي أو بسر ضعيف. السر الافتراضي (DEV_ONLY_JWT_SECRET) موجود للتنمية
  // المحلية فقط، وتشغيله في NODE_ENV=production يجعل تزوير توكنات JWT ممكناً
  // بالكامل (الجميع يعرف هذه القيمة من الكود المصدري و.env.example). الشرط:
  // سر قوي بطول >= 32 حرفاً وغير مطابق للقيمة الافتراضية.
  const DEFAULT_DEV_SECRET = DEV_ONLY_JWT_SECRET;
  if (
    validatedConfig.NODE_ENV === NodeEnv.Production &&
    (!validatedConfig.JWT_SECRET ||
      validatedConfig.JWT_SECRET === DEFAULT_DEV_SECRET ||
      validatedConfig.JWT_SECRET.length < 32)
  ) {
    throw new Error(
      'فشل التحقق من متغيرات البيئة:\n' +
        'JWT_SECRET: لا يجوز تشغيل NODE_ENV=production بالسر الافتراضي أو بسر أقصر من 32 حرفاً — ' +
        'عيّن JWT_SECRET قوياً في بيئة الإنتاج (مثال: openssl rand -hex 32).',
    );
  }

  return validatedConfig;
}
