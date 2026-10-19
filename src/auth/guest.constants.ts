/**
 * وضع الزائر (Guest Access) — للاختبار قبل الإطلاق التجريبى (Soft Opening).
 *
 * الفكرة: بدل إزالة JwtAuthGuard من الخدمات (مما يكسر ملكية البيانات: العقود
 * والمذكرات والمستندات والتنزيلات كلها مربوطة بـuserId)، يحصل كل زائر على
 * حساب مؤقت حقيقى معزول (صف فى users) وتوكن عادى — فتبقى كل الحراس وفحوص
 * الملكية (IDOR) سليمة كما هى بلا أى تعديل فى بقية الخدمات.
 *
 * المفتاح: متغير البيئة GUEST_ACCESS_ENABLED (القيمة الحرفية true فقط). الافتراضى
 * معطَّل. إيقافه يقطع كل جلسات الزوار فوراً (راجع JwtAuthGuard) بلا إعادة نشر كود.
 *
 * ⚠️ المقارنة بالنص الحرفى 'true' عمداً: ConfigModule يطبّق enableImplicitConversion
 * فلو كان الحقل Boolean لتحوّل النص 'false' إلى true (Boolean('false') === true).
 */

/** نطاق محجوز (RFC 2606: .invalid لا يُحل أبداً) — لا يمكن أن يخص بريداً حقيقياً */
export const GUEST_EMAIL_DOMAIN = 'guest.invalid';

/** قيمة ليست تجزئة bcrypt صالحة — bcrypt.compare تُرجع false دائماً، فلا دخول بكلمة مرور لحساب زائر */
export const GUEST_UNUSABLE_PASSWORD_HASH = '!guest-no-password!';

/**
 * مدة جلسة الزائر. كانت 12 ساعة ويوماً واحداً فانتهت جلسة المختبر بين يوم وآخر وظهرت له رسالة
 * "سجّل الدخول" (اختبار 19/10/2026) بينما قرار المالك أن يبقى وضع الزائر مفتوحاً حتى يطلب هو
 * إعادة التسجيل. الواجهة لا تجدّد التوكن، فالتوكن نفسه طويل. الأمان لم يتغير: الحساب مؤقت بلا
 * صلاحيات admin، ومفتاح الإيقاف GUEST_ACCESS_ENABLED يقطع كل الجلسات فوراً، والمدة قابلة للضبط
 * بـGUEST_JWT_EXPIRES_IN.
 */
export const GUEST_DEFAULT_ACCESS_TOKEN_TTL = '30d';
export const GUEST_REFRESH_TOKEN_DAYS = 30;

export function isGuestEmail(email: string | null | undefined): boolean {
  return typeof email === 'string' && email.trim().toLowerCase().endsWith(`@${GUEST_EMAIL_DOMAIN}`);
}

export function isGuestAccessEnabled(raw: unknown): boolean {
  return typeof raw === 'string' && raw.trim().toLowerCase() === 'true';
}
