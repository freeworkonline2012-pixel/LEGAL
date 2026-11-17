import { assessExtraSampleCount, assessNeedsExtra, resolveAssessmentVotes, type AssessSample } from './assess-vote';
import { verifierExtraSampleCount, verifierNeedsExtra, resolveVerifierVotes, type VerifierSampleOutcome } from './verifier-vote';
import { findGarbledDigitTokens, focusOfQuote, garbledDigitsInQuantitySentences } from './ocr-noise.util';
import { garbledDigitClauseVerification } from './verification';

const NO_TEXT = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
const ok = (assessment: string, confidence = 0.6): AssessSample => ({ status: 'ok', assessment, selectedIndices: [0], reasoning: 'شرح', confidence, violationType: 'none', mandatoryQuote: '' });
const err = (): AssessSample => ({ status: 'error', detail: 'http_500' });
const vOk = (status: 'confirmed' | 'unconfirmed', basis: 'verified' | 'refuted' | 'uncertain' | 'reclassified'): VerifierSampleOutcome => ({
  status: 'ok',
  verification: { status, basis, reason: 'x', quote: null, quoteSource: null, verifiedAt: '2026-11-17T00:00:00Z' } as never,
});

describe('الجولة 105.5 — تصويت تكيفى للتقييم الأول', () => {
  it('الإجماع لا يستدعى عيّنات إضافية؛ الانقسام يستدعيها', () => {
    expect(assessNeedsExtra([ok('سليم'), ok('سليم'), ok('سليم')])).toBe(false);
    expect(assessNeedsExtra([ok(NO_TEXT), ok(NO_TEXT), ok(NO_TEXT)])).toBe(false);
    expect(assessNeedsExtra([ok('سليم'), ok(NO_TEXT), ok(NO_TEXT)])).toBe(true);
    expect(assessNeedsExtra([ok('يحتاج مراجعة'), ok('يحتاج مراجعة'), ok('سليم')])).toBe(true);
  });

  it('الأعطال وحدها أو عيّنة سليمة واحدة لا تستدعى إضافية', () => {
    expect(assessNeedsExtra([err(), err(), ok('سليم')])).toBe(false);
    expect(assessNeedsExtra([err(), err(), err()])).toBe(false);
  });

  it('العدد الإضافى: افتراضى 2، 0 يعطّله، أقصى 2، تالف يرجع للافتراضى', () => {
    expect(assessExtraSampleCount(undefined)).toBe(2);
    expect(assessExtraSampleCount('0')).toBe(0);
    expect(assessExtraSampleCount('9')).toBe(2);
    expect(assessExtraSampleCount('x')).toBe(2);
    expect(assessExtraSampleCount('-1')).toBe(2);
  });

  it('حالة البند 34 (1 سليم / 2 لا نص) تُحسم بخمس عيّنات: النصاب 3', () => {
    const three = [ok('سليم'), ok(NO_TEXT), ok(NO_TEXT)];
    expect(resolveAssessmentVotes(three).decision).toBe('no_text');
    const five = [...three, ok('سليم'), ok('سليم')];
    const r = resolveAssessmentVotes(five);
    expect(r.decision).toBe('sound');
    expect(r.tally).toEqual({ review: 0, sound: 3, noText: 2, errors: 0 });
  });
});

describe('الجولة 105.5 — تصويت تكيفى للمدقق المستقل', () => {
  it('إجماع النوع لا يستدعى إضافية؛ الانقسام يستدعيها', () => {
    expect(verifierNeedsExtra([vOk('unconfirmed', 'refuted'), vOk('unconfirmed', 'refuted'), vOk('unconfirmed', 'refuted')])).toBe(false);
    expect(verifierNeedsExtra([vOk('confirmed', 'verified'), vOk('confirmed', 'verified'), vOk('unconfirmed', 'refuted')])).toBe(true);
    expect(verifierNeedsExtra([vOk('confirmed', 'verified')])).toBe(false);
  });

  it('تأكيد 2 من 3 لا يكفى: بعد عيّنتين إضافيتين رافضتين تصير 2 تأكيد من 5 ⇒ ليست مؤكدة', () => {
    const three = [vOk('confirmed', 'verified'), vOk('confirmed', 'verified'), vOk('unconfirmed', 'refuted')];
    const a = resolveVerifierVotes(three);
    expect(a.outcome.status === 'ok' && a.outcome.verification.status).toBe('confirmed');
    const five = [...three, vOk('unconfirmed', 'refuted'), vOk('unconfirmed', 'uncertain')];
    const b = resolveVerifierVotes(five);
    expect(b.outcome.status === 'ok' && b.outcome.verification.status).toBe('unconfirmed');
  });

  it('العدد الإضافى للمدقق: افتراضى 2 وأقصى 2 و0 يعطّله', () => {
    expect(verifierExtraSampleCount(undefined)).toBe(2);
    expect(verifierExtraSampleCount('0')).toBe(0);
    expect(verifierExtraSampleCount('7')).toBe(2);
  });
});

describe('الجولة 105.5 — أرقام عربية قُرئت حروفاً لاتينية', () => {
  const q28 = 'تصدر القرارات بأغلبية ثلاثة أرباع رأس المال (Vo %). ويكون النصاب نصف رأس المال VYY في الاجتماع الأول. يوقع الشركاء على السجل.';

  it('يُكشف الرمز الشبيه برقم بجوار كلمة عربية فى جملة المقدار فقط', () => {
    expect(findGarbledDigitTokens('الأغلبية ثلاثة أرباع (Vo) من الحضور')).toEqual(['Vo']);
    expect(garbledDigitsInQuantitySentences(q28)).toEqual(['Vo', 'VYY']);
  });

  it('لا يُكشف: أرقام المواد، رمز ختم WL، اختصار VAT، أو رمز فى جملة بلا مقدار', () => {
    expect(findGarbledDigitTokens('بحسب المادة 126 من القانون 159 لسنة 1981')).toEqual([]);
    expect(findGarbledDigitTokens('الطرف الأول WL والطرف الثانى')).toEqual([]);
    expect(findGarbledDigitTokens('تضاف ضريبة VAT على الثمن')).toEqual([]);
    expect(garbledDigitsInQuantitySentences('يوقع الشركاء VYY على السجل. للجمعية نصف رأس المال.')).toEqual([]);
  });

  const row = (over: Partial<Parameters<typeof garbledDigitClauseVerification>[0]> = {}) => ({
    clauseText: q28,
    assessmentStatus: 'يحتاج مراجعة',
    riskLevel: 'متوسط',
    assessmentReasoning: 'البند يورد نسباً متعددة (ثلاثة أرباع ونصف وربع) دون ربطها بالجهة.',
    ...over,
  });

  it('بند متوسط شرحه على نسب ونصه فيه أرقام مشوهة فى جملة النسبة ⇒ غير مؤكد بسبب صريح', () => {
    const v = garbledDigitClauseVerification(row());
    expect(v?.status).toBe('unconfirmed');
    expect(v?.basis).toBe('uncertain');
    expect(v?.reason).toContain('«Vo»');
    expect(v?.reason).toContain('ليس اعتراضاً من المدقق المستقل');
  });

  it('لا ينطبق: بند سليم، درجة منخفضة، شرح بلا مقدار، أو نص بلا رموز مشوهة', () => {
    expect(garbledDigitClauseVerification(row({ assessmentStatus: 'سليم' }))).toBeNull();
    expect(garbledDigitClauseVerification(row({ riskLevel: 'منخفض' }))).toBeNull();
    expect(garbledDigitClauseVerification(row({ assessmentReasoning: 'البند يخلط بين التسجيل والتوقيع.' }))).toBeNull();
    expect(garbledDigitClauseVerification(row({ clauseText: 'تصدر القرارات بأغلبية ثلاثة أرباع رأس المال.' }))).toBeNull();
  });

  it('شرح المادة 126 بأرقام المواد وحدها لا يُعدّ كلاماً عن مقدار', () => {
    expect(garbledDigitClauseVerification(row({ assessmentReasoning: 'مخالف للمادة 126 والمادة 27 من القانون 159 لسنة 1981.' }))).toBeNull();
  });
});

describe('الجولة 105.5 — جملة الاقتباس', () => {
  const text = 'يجوز عزل المدير فى أى وقت بقرار مسبب. تنظر الجمعية فى عزل المدير / المديرين. يوقع الشركاء VYY على السجل.';
  it('يرجع جملة الاقتباس وحدها', () => {
    const f = focusOfQuote(text, 'تنظر الجمعية فى عزل المدير / المديرين');
    expect(f).toContain('عزل المدير / المديرين');
    expect(f).not.toContain('VYY');
  });
  it('اقتباس غير موجود حرفياً أو قصير ⇒ نص البند كله (السلوك المحافظ)', () => {
    expect(focusOfQuote(text, 'عبارة غير واردة بالنص إطلاقاً هنا')).toBe(text);
    expect(focusOfQuote(text, 'عزل')).toBe(text);
  });
});
