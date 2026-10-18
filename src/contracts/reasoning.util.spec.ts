import { stripInternalCandidateRefs } from './reasoning.util';

describe('stripInternalCandidateRefs', () => {
  const FALLBACK = 'لا يوجد نص مفهرَس يحكم هذا البند مباشرة.';

  it('يحذف الجمل المبنية على ترقيم المرشحين الداخلى', () => {
    const input = 'البند يتعلق بإيجار مقر إدارى. المرشحان 1 و2 يخصان التأجير التمويلى. المادة 579 تحكم الاستعمال.';
    expect(stripInternalCandidateRefs(input, FALLBACK)).toBe(
      'البند يتعلق بإيجار مقر إدارى. المادة 579 تحكم الاستعمال.',
    );
  });

  it('يعيد النص الاحتياطى إن لم يبقَ شيء', () => {
    expect(stripInternalCandidateRefs('المرشح 3 لا صلة له.', FALLBACK)).toBe(FALLBACK);
  });

  it('لا يمسّ شرحاً بلا إشارة للمرشحين', () => {
    const input = 'البند يحدد عنوان المراسلات.';
    expect(stripInternalCandidateRefs(input, FALLBACK)).toBe(input);
  });

  it('يعيد الاحتياطى للنص الفارغ', () => {
    expect(stripInternalCandidateRefs('  ', FALLBACK)).toBe(FALLBACK);
  });
});

import { guardMandatoryClaims, isQuoteInArticles, normalizeArabicForMatch, tidyNoTextReasoning } from './reasoning.util';

describe('guardMandatoryClaims', () => {
  const ART_608 = 'إذا طرأت ظروف خطيرة غير متوقعة من شأنها أن تجعل تنفيذ الالتزام مرهقاً للمستأجر جاز له أن يطلب إنهاء العقد';
  const matched = [{ law: 'القانون المدنى 131/1948', articleNo: 608, text: ART_608 }];

  it('يخفّض ادعاء "قاعدة آمرة" بلا عبارة حرفية مُثبتة ويستبدل الشرح بجملة آمنة', () => {
    const out = guardMandatoryClaims({
      reasoning: 'يخالف القاعدة الآمرة فى المادة 608 ولا يجوز الاتفاق على مخالفتها.',
      violationType: 'mandatory_violation',
      mandatoryQuote: 'لا يجوز الاتفاق على مخالفة هذه المادة',
      matched,
    });
    expect(out.violationType).toBe('supplementary_difference');
    expect(out.mandatoryVerified).toBe(false);
    expect(out.reasoning).toContain('المادة 608');
    expect(out.reasoning).not.toMatch(/آمرة|لا يجوز الاتفاق/);
  });

  it('يخفّض لغة قاطعة حتى لو صنّف النموذج الاختلاف مكملاً', () => {
    const out = guardMandatoryClaims({
      reasoning: 'البند يخالف صراحة نص المادة.',
      violationType: 'supplementary_difference',
      mandatoryQuote: '',
      matched,
    });
    expect(out.reasoning).not.toContain('يخالف صراحة');
  });

  it('يقبل الادعاء الآمر عندما توجد العبارة حرفياً فى نص المادة', () => {
    const out = guardMandatoryClaims({
      reasoning: 'يخالف نصاً ناهياً صراحة.',
      violationType: 'mandatory_violation',
      mandatoryQuote: 'ظروف خطيرة غير متوقعة من شأنها',
      matched,
    });
    expect(out.mandatoryVerified).toBe(true);
    expect(out.violationType).toBe('mandatory_violation');
    expect(out.reasoning).toBe('يخالف نصاً ناهياً صراحة.');
  });

  it('لا يمسّ شرحاً هادئاً بلا ادعاء قاطع', () => {
    const out = guardMandatoryClaims({
      reasoning: 'يستحق نظر محامٍ.',
      violationType: 'none',
      mandatoryQuote: '',
      matched,
    });
    expect(out.reasoning).toBe('يستحق نظر محامٍ.');
  });
});

describe('isQuoteInArticles / normalizeArabicForMatch', () => {
  it('يطابق رغم اختلاف التشكيل وصور الألف والتاء المربوطة', () => {
    expect(isQuoteInArticles('أَن تَجعل تنفيذ الالتزام مرهقا', ['من شأنها أن تجعل تنفيذ الالتزام مرهقاً للمستأجر'])).toBe(true);
  });
  it('يرفض العبارات القصيرة جداً والغائبة', () => {
    expect(isQuoteInArticles('مرهق', ['مرهق'])).toBe(false);
    expect(isQuoteInArticles('عبارة غير موجودة إطلاقاً هنا', ['نص آخر تماماً'])).toBe(false);
  });
  it('normalize يزيل التشكيل', () => {
    expect(normalizeArabicForMatch('الْعَقْد')).toBe('العقد');
  });
});

describe('tidyNoTextReasoning', () => {
  it('يقتطع تعليل النصوص المستبعدة ويُلحق جملة موحّدة', () => {
    const input =
      'البند يتعلق باتفاق الطرفين على اختصاص محاكم الإسكندرية، ولا يوجد بين النصوص المعروضة نص يحكمه؛ فالمادة 191 من قانون التجارة تخص وكالة العقود.';
    expect(tidyNoTextReasoning(input)).toBe(
      'البند يتعلق باتفاق الطرفين على اختصاص محاكم الإسكندرية. لم نجد نصاً مفهرَساً يحكم هذا البند مباشرة.',
    );
  });
  it('يعيد جملة افتراضية إن لم يبقَ وصف مفيد', () => {
    expect(tidyNoTextReasoning('ولا يوجد نص.')).toBe('لا يوجد نص قانونى مصرى مفهرَس يحكم هذا البند مباشرة.');
  });
});

import { softenSupplementaryWording } from './reasoning.util';

describe('tidyNoTextReasoning — إشارات المرشحين (جولة 3)', () => {
  it('يقتطع "والمرشحان 1 و2 يخصان..." الملحق بوصف الموضوع', () => {
    const input = 'البند يتعلق باعتبار التمهيد جزءاً لا يتجزأ من العقد، والمرشحان 1 و2 يخصان نماذج عقود تأمين جماعى.';
    expect(tidyNoTextReasoning(input)).toBe(
      'البند يتعلق باعتبار التمهيد جزءاً لا يتجزأ من العقد. لم نجد نصاً مفهرَساً يحكم هذا البند مباشرة.',
    );
  });
});

describe('softenSupplementaryWording', () => {
  it('يحوّل "يخالف القاعدة المكملة" إلى "يختلف عن القاعدة المكملة"', () => {
    expect(softenSupplementaryWording('وهذا يخالف القاعدة المكملة في المادة 604.')).toBe(
      'وهذا يختلف عن القاعدة المكملة في المادة 604.',
    );
  });
  it('لا يمسّ "يخالف" فى سياق آخر', () => {
    expect(softenSupplementaryWording('يخالف نص المادة 5.')).toBe('يخالف نص المادة 5.');
  });
});
