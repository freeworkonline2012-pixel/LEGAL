/**
 * الجولة 105.6: أعطال مزود الذكاء الاصطناعى القاتلة وبنود تعذّر تقييمها تقنياً.
 *
 * وقعت فى الإنتاج: نفد رصيد المزود (HTTP 402) أثناء تحليل عقد فواصل التحليل كلها، فأكمل النظام 17 بنداً بثلاث عيّنات ومحاولتين لكل منها (نداءات تُرفض كلها)
 * ثم أصدر تقريراً من 20 صفحة بمستوى «مخاطرة متوسطة» وبنوداً معطوبة معدودة «قُيِّمت». الأعطال نوعان لا يجوز خلطهما:
 *  - قاتلة (401 مفتاح مرفوض، 402 رصيد لا يكفى): كل نداء لاحق سيفشل حتماً، فيُوقَف التحليل فوراً بحالة صريحة ولا يصدر تقرير ناقص.
 *  - عابرة (429 وأخطاء الخادم والمهلة ورد غير مقروء): تبقى كما هى (محاولة ثانية ثم fail-closed للبند وحده).
 */

/** رمز عطل قاتل فى تفصيل نتيجة المزود (`http_402`...) */
const FATAL_DETAIL = /^http_(401|402)$/;

export function isFatalProviderDetail(detail: string | null | undefined): boolean {
  return typeof detail === 'string' && FATAL_DETAIL.test(detail);
}

/** يُرمى لإيقاف التحليل كله؛ لا يُبتلع فى أى طبقة (راجع إعادة الرمى فى contracts.service). */
export class ProviderFatalError extends Error {
  constructor(
    readonly detail: string,
    readonly stage: string,
  ) {
    super(`provider fatal ${detail} at ${stage}`);
    this.name = 'ProviderFatalError';
  }
}

export const PROVIDER_FATAL_USER_MESSAGE =
  'توقّف تحليل العقد لعطل فى خدمة الذكاء الاصطناعى (الحساب غير مفعَّل أو رصيده لا يكفى). لم يُصدَر تقرير حتى لا تُعتمد نتيجة ناقصة — أعد رفع العقد بعد معالجة المشكلة أو أبلغ الدعم.';

/** أول عطل قاتل بين عيّنات التصويت أو نتائج النداءات، أو null. */
export function fatalProviderDetail(outcomes: ReadonlyArray<{ status: string; detail?: string }>): string | null {
  for (const o of outcomes) {
    if (o.status === 'error' && isFatalProviderDetail(o.detail)) return o.detail as string;
  }
  return null;
}

/** لا تُبتلع ProviderFatalError فى أى `catch` يحمى الاستمرار: يُعاد رميها. */
export function rethrowIfFatal(err: unknown): void {
  if (err instanceof ProviderFatalError) throw err;
}

// ---- بنود تعذّر تقييمها تقنياً ----

/** نصان يكتبهما المسار عند تعذّر التقييم؛ التقرير يتعرف عليهما بالبادئة فلا يعدّ البند «قُيِّم». */
export const ASSESSMENT_FAILED_REASONING = 'تعذَّر إجراء التقييم الآلى تقنياً';
export const ASSESSMENT_NOT_CONFIGURED_REASONING = 'خدمة التقييم الآلى غير مُفعَّلة';

export function isAssessmentTechnicalFailure(reasoning: string | null | undefined): boolean {
  const t = (reasoning ?? '').trim();
  return t.startsWith(ASSESSMENT_FAILED_REASONING) || t.startsWith(ASSESSMENT_NOT_CONFIGURED_REASONING);
}

/** وسم المدقق حين يتعذّر تقنياً: ملاحظة غير مؤكدة بسبب صريح لا ملاحظة محسوبة بصمت. */
export const VERIFIER_FAILED_REASON =
  'تعذّر التحقق المستقل لعطل تقنى فى خدمة المدقق؛ لم تُراجَع هذه الملاحظة آلياً فتُعرض مرشحة للمراجعة البشرية ولا تدخل الأعداد ولا المستوى.';
