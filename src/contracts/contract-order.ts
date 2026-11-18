/**
 * طلب مراجعة العقد: مراحل الموافقة والسداد وقواعد الإتاحة (دالة نقية بلا اعتماديات — تُستعمل فى contracts وexports).
 *
 * المراحل: preview (نسخة أولية فقط) ← approved (وافق العميل) ← payment_submitted (أعلن السداد) ← paid (أكّده المالك).
 * قواعد الإتاحة لغير admin:
 *  - النسخة الأولية PDF (بعلامة «نسخة أولية»): دائماً بعد اكتمال المعالجة.
 *  - تفاصيل المراجعة على الشاشة، والصياغة البديلة، والتنزيل النهائى (Word/PDF): بعد السداد المؤكَّد فقط
 *    (والنهائى بعد اعتماد المراجعة البشرية أيضاً — راجع ExportsService).
 * admin (المالك/المطوّر) بلا مقابل ولا مراحل على الإطلاق.
 */

export type OrderStage = 'preview' | 'approved' | 'payment_submitted' | 'paid';

export interface OrderState {
  clientApprovedAt: Date | null;
  paymentStatus: 'unpaid' | 'submitted' | 'paid' | string | null | undefined;
  paidAt: Date | null;
}

export function stageOf(c: OrderState): OrderStage {
  if (c.paidAt || c.paymentStatus === 'paid') return 'paid';
  if (c.paymentStatus === 'submitted') return 'payment_submitted';
  if (c.clientApprovedAt) return 'approved';
  return 'preview';
}

export function isPaid(c: OrderState): boolean {
  return stageOf(c) === 'paid';
}

/** هل يرى هذا الفاعل تفاصيل المراجعة كاملة؟ admin دائماً، وغيره بعد السداد المؤكَّد. */
export function canSeeDetails(role: string, c: OrderState): boolean {
  return role === 'admin' || isPaid(c);
}

export interface ServiceFee {
  /** بالجنيه (عدد صحيح)؛ null = لم يُضبط سعر الخدمة فلا يمكن للعميل الموافقة/السداد */
  amount: number | null;
  currency: 'EGP';
}

/** CONTRACT_REVIEW_FEE_EGP: عدد صحيح موجب بالجنيه. أى قيمة أخرى = غير مضبوط (لا مجانية افتراضية). */
export function serviceFeeFromEnv(env: NodeJS.ProcessEnv = process.env): ServiceFee {
  const raw = env.CONTRACT_REVIEW_FEE_EGP?.trim();
  if (!raw || !/^\d{1,7}$/.test(raw)) return { amount: null, currency: 'EGP' };
  const n = Number(raw);
  return { amount: n > 0 ? n : null, currency: 'EGP' };
}

/** تعليمات السداد التى تُعرض للعميل (حساب/محفظة/رقم تحويل). نص حر من المالك، بحد أقصى 1000 حرف. */
export function paymentInstructionsFromEnv(env: NodeJS.ProcessEnv = process.env): string | null {
  const raw = env.CONTRACT_PAYMENT_INSTRUCTIONS?.replace(/[\u0000-\u001F\u007F]+/g, ' ').trim();
  return raw ? raw.slice(0, 1000) : null;
}

/** مرجع السداد: نص قصير بلا محارف تحكم (رقم عملية/تحويل يطابقه المالك). */
export function sanitizePaymentReference(input: unknown): string | null {
  if (typeof input !== 'string') return null;
  const cleaned = input.replace(/[\u0000-\u001F\u007F‎‏‪-‮]+/g, ' ').replace(/\s+/g, ' ').trim();
  return cleaned.length >= 3 && cleaned.length <= 100 ? cleaned : null;
}
