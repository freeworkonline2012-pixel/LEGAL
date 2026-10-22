/**
 * وضع المستخدم الواحد (الوصول المغلق).
 *
 * المتغير ALLOWED_USER_EMAILS: قائمة بريد مسموح لها فقط بالتسجيل والدخول واستخدام الواجهة
 * (مفصولة بفاصلة أو مسافة أو فاصلة منقوطة). حين يكون المتغير معيَّناً بقيمة غير فارغة:
 *  - يُرفض التسجيل والدخول وتجديد الجلسة لأى بريد خارج القائمة،
 *  - يُعطَّل وضع الزائر مهما كان GUEST_ACCESS_ENABLED،
 *  - يُرفض كل طلب بلا توكن أو بتوكن لبريد خارج القائمة على المسارات التى كانت تقبل طلباً مجهولاً
 *    (الأسئلة والحوكمة)، وتُقطع فوراً أى جلسة قائمة لبريد غير مسموح.
 * حين لا يكون معيَّناً (الافتراضى) لا يتغير أى سلوك.
 *
 * فشل مغلق عمداً: لو عُيِّن المتغير بقيمة غير فارغة لكنها لا تحوى بريداً صالحاً (خطأ كتابة)
 * يبقى الوضع المغلق مفعَّلاً ولا يُسمح لأحد، ولا يفتح المنصة بالخطأ للجميع.
 */

/** هل الوضع المغلق مفعَّل؟ (قيمة نصية غير فارغة بعد التقليم) */
export function isClosedAccessMode(raw: unknown): boolean {
  return typeof raw === 'string' && raw.trim().length > 0;
}

/** البريد المسموح بعد التطبيع (حروف صغيرة، بلا فراغات) */
export function parseAllowedEmails(raw: unknown): string[] {
  if (typeof raw !== 'string') return [];
  return raw
    .split(/[\s,;]+/)
    .map((e) => e.trim().toLowerCase())
    .filter((e) => e.length > 0 && e.includes('@'));
}

/** true إن كان الوضع المغلق غير مفعَّل، أو كان البريد ضمن القائمة */
export function isEmailAllowed(raw: unknown, email: string | null | undefined): boolean {
  if (!isClosedAccessMode(raw)) return true;
  if (typeof email !== 'string') return false;
  return parseAllowedEmails(raw).includes(email.trim().toLowerCase());
}
