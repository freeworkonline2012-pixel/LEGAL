import { canSeeDetails, isPaid, paymentInstructionsFromEnv, sanitizePaymentReference, serviceFeeFromEnv, stageOf } from './contract-order';

const none = { clientApprovedAt: null, paymentStatus: 'unpaid', paidAt: null };
const NOW = new Date();

describe('contract-order — المراحل', () => {
  it('preview ← approved ← payment_submitted ← paid', () => {
    expect(stageOf(none)).toBe('preview');
    expect(stageOf({ ...none, clientApprovedAt: NOW })).toBe('approved');
    expect(stageOf({ clientApprovedAt: NOW, paymentStatus: 'submitted', paidAt: null })).toBe('payment_submitted');
    expect(stageOf({ clientApprovedAt: NOW, paymentStatus: 'paid', paidAt: NOW })).toBe('paid');
  });

  it('السداد المؤكَّد يكفى بأحد مؤشريه، وقيمة غير معروفة = غير مسدَّد', () => {
    expect(isPaid({ ...none, paidAt: NOW })).toBe(true);
    expect(isPaid({ ...none, paymentStatus: 'paid' })).toBe(true);
    expect(isPaid({ ...none, paymentStatus: 'whatever' })).toBe(false);
    expect(isPaid({ ...none, paymentStatus: undefined })).toBe(false);
    // «submitted» ليس سداداً مؤكَّداً: العميل لا يفتح التفاصيل بإعلانه وحده
    expect(isPaid({ clientApprovedAt: NOW, paymentStatus: 'submitted', paidAt: null })).toBe(false);
  });

  it('التفاصيل: admin دائماً، وغيره بعد السداد المؤكَّد فقط', () => {
    expect(canSeeDetails('admin', none)).toBe(true);
    expect(canSeeDetails('user', none)).toBe(false);
    expect(canSeeDetails('user', { clientApprovedAt: NOW, paymentStatus: 'submitted', paidAt: null })).toBe(false);
    expect(canSeeDetails('user', { clientApprovedAt: NOW, paymentStatus: 'paid', paidAt: NOW })).toBe(true);
  });
});

describe('contract-order — الإعدادات', () => {
  it('السعر: عدد صحيح موجب فقط؛ غير ذلك = غير مضبوط (لا مجانية افتراضية)', () => {
    expect(serviceFeeFromEnv({ CONTRACT_REVIEW_FEE_EGP: '250' }).amount).toBe(250);
    expect(serviceFeeFromEnv({ CONTRACT_REVIEW_FEE_EGP: ' 99 ' }).amount).toBe(99);
    for (const bad of [undefined, '', '0', '-5', '12.5', 'abc', '١٠٠', '99999999']) {
      expect(serviceFeeFromEnv({ CONTRACT_REVIEW_FEE_EGP: bad }).amount).toBeNull();
    }
    expect(serviceFeeFromEnv({}).currency).toBe('EGP');
  });

  it('تعليمات السداد: نص حر بلا محارف تحكم وبحد 1000', () => {
    expect(paymentInstructionsFromEnv({})).toBeNull();
    expect(paymentInstructionsFromEnv({ CONTRACT_PAYMENT_INSTRUCTIONS: '  حوّل على المحفظة\n01000\u0007  ' })).toBe('حوّل على المحفظة 01000');
    expect(paymentInstructionsFromEnv({ CONTRACT_PAYMENT_INSTRUCTIONS: 'x'.repeat(2000) })?.length).toBe(1000);
  });

  it('مرجع السداد: 3–100 حرف بلا محارف تحكم أو توجيه اتجاه', () => {
    expect(sanitizePaymentReference('  TX 123456  ')).toBe('TX 123456');
    expect(sanitizePaymentReference('ab')).toBeNull();
    expect(sanitizePaymentReference('x'.repeat(101))).toBeNull();
    expect(sanitizePaymentReference(undefined)).toBeNull();
    expect(sanitizePaymentReference(12345)).toBeNull();
    expect(sanitizePaymentReference('رقم‮123\u0000عملية')).toBe('رقم 123 عملية');
  });
});
