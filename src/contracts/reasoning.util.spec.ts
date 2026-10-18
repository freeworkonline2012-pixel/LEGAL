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
