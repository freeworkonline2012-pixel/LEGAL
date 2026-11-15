import { validateClauseFacts, quoteIsLegalDefaultOnly, quoteIsConsiderationNotDamages } from './clause-facts';
import { checkUndefinedTerms } from './contract-level';
import { resolveVerifierVotes, type VerifierSampleOutcome } from './verifier-vote';
import type { Verification } from './verification';

const lc = (text: string, i = 1) => [{ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: text }];

describe('الجولة 100: بوابات دلالية بعد قياس عقود «ب» النظيفة', () => {
  describe('إعفاء المسئولية: تكرار الأصل القانونى ليس إعفاءً', () => {
    const CL12 =
      'المسئولية والتأمين على العين: يسأل المستأجر عن الحريق والتلف الناشئ بخطئه، ولا يسأل عن الهلاك بسبب أجنبى لا يد له فيه أو بسبب عيب بالعقار، وعليه التأمين على محتوياته.';
    const raw = (quote: string) => ({ liability: { kind: 'exclusion', gross_fault: 'unspecified', beneficiary: 'second', quote } });

    it('بند إيجار ب 12 (يحمّل المستأجر خطأه وينفى السبب الأجنبى فقط): تسقط واقعة الإعفاء', () => {
      const q = 'يسأل المستأجر عن الحريق والتلف الناشئ بخطئه، ولا يسأل عن الهلاك بسبب أجنبى لا يد له فيه أو بسبب عيب بالعقار';
      expect(quoteIsLegalDefaultOnly(q)).toBe(true);
      expect(validateClauseFacts(raw(q), CL12).liability).toBeUndefined();
    });
    it('الاقتباس بالعبارة النافية وحدها يسقط أيضاً', () => {
      const q = 'ولا يسأل عن الهلاك بسبب أجنبى لا يد له فيه أو بسبب عيب بالعقار';
      expect(validateClauseFacts(raw(q), CL12).liability).toBeUndefined();
    });
    it('إعفاء حقيقى يبقى: «لا تسأل الشركة عن أى خسارة»', () => {
      const text = 'لا تسأل الشركة عن أى خسارة تلحق العميل مهما كان سببها.';
      const f = validateClauseFacts(raw('لا تسأل الشركة عن أى خسارة تلحق العميل مهما كان سببها'), text);
      expect(f.liability?.kind).toBe('exclusion');
    });
    it('إعفاء مطلق يشمل السبب الأجنبى مع غيره يبقى: «ولو كان بسبب أجنبى»', () => {
      const text = 'لا يسأل المورد عن أى تأخير ولو كان بسبب أجنبى أو بخطئه.';
      expect(quoteIsLegalDefaultOnly('لا يسأل المورد عن أى تأخير ولو كان بسبب أجنبى أو بخطئه')).toBe(false);
      expect(validateClauseFacts(raw('لا يسأل المورد عن أى تأخير ولو كان بسبب أجنبى أو بخطئه'), text).liability?.kind).toBe('exclusion');
    });
    it('إعفاء مضاف إليه استثناء السبب الأجنبى يبقى إعفاءً: «يعفى المقاول من الغرامة، ولا يسأل عن السبب الأجنبى»', () => {
      const q = 'يعفى المقاول من غرامة التأخير، ولا يسأل عن سبب أجنبى';
      expect(quoteIsLegalDefaultOnly(q)).toBe(false);
    });
  });

  describe('التعويض: العوض والمقابل ليسا تعويضاً عن ضرر', () => {
    const CL13 = 'رد العين عند الانتهاء: يرد المستأجر العين بالحالة التى تسلمها بها، وله نزع ما أدخله من تجهيزات منقولة، وتبقى التحسينات الثابتة التى وافقت المؤجرة عليها لقاء تعويض يتفق عليه.';
    const raw = (quote: string) => ({ compensation: { method: 'unspecified', waives_proof_of_damage: false, has_cap: false, payer: 'first', quote } });

    it('بند إيجار ب 13 «لقاء تعويض يتفق عليه» عن تحسينات: تسقط الواقعة فلا تنطبق المادة 221', () => {
      const q = 'وتبقى التحسينات الثابتة التى وافقت المؤجرة عليها لقاء تعويض يتفق عليه';
      expect(quoteIsConsiderationNotDamages(q)).toBe(true);
      expect(validateClauseFacts(raw(q), CL13).compensation).toBeUndefined();
    });
    it('تعويض عن ضرر أو إخلال بلا طريقة يبقى: «يلتزم بتعويض الطرف الآخر عن أى ضرر»', () => {
      const text = 'يلتزم المقاول بتعويض رب العمل عن أى ضرر يلحقه بسبب الإخلال.';
      const q = 'يلتزم المقاول بتعويض رب العمل عن أى ضرر يلحقه بسبب الإخلال';
      expect(quoteIsConsiderationNotDamages(q)).toBe(false);
      expect(validateClauseFacts(raw(q), text).compensation?.method).toBe('unspecified');
    });
    it('«تعويض يتفق عليه» مع ذكر ضرر أو تأخير يبقى تعويضاً', () => {
      expect(quoteIsConsiderationNotDamages('عن تأخير المورد يستحق المشترى تعويضاً يتفق عليه')).toBe(false);
      expect(quoteIsConsiderationNotDamages('لقاء تعويض يتفق عليه عن الضرر الناشئ')).toBe(false);
    });
    it('طريقة محددة (نسبة/مبلغ) لا تتأثر بالبوابة', () => {
      const text = 'غرامة تأخير بنسبة 1% لقاء تعويض عن التأخير.';
      const f = validateClauseFacts({ compensation: { method: 'percentage', waives_proof_of_damage: false, has_cap: false, payer: 'first', quote: 'غرامة تأخير بنسبة 1% لقاء تعويض عن التأخير' } }, text);
      expect(f.compensation?.method).toBe('percentage');
    });
  });

  describe('إحالة مرفق غير ظاهر: قيد على اكتمال الملف، ومالى فقط يبقى متوسطاً', () => {
    it('«المخططات والمواصفات المرفقة» (مقاولة ب): منخفضة فلا ترفع المستوى', () => {
      const f = checkUndefinedTerms(lc('ولا يجرى أى تعديل على الأعمال إلا بأمر كتابى من رب العمل وفق المخططات والمواصفات المرفقة.', 2));
      const a = f.find((x) => x.id === 'undefined:attachment');
      expect(a).toBeDefined();
      expect(a!.severity).toBe('منخفض');
    });
    it('مرفق يحدد السعر أو الأجرة يبقى متوسطاً', () => {
      const f = checkUndefinedTerms(lc('يلتزم المشترى بسداد ثمن الأصناف وفق الجدول المرفق بهذا العقد.', 3));
      expect(f.find((x) => x.id === 'undefined:attachment')!.severity).toBe('متوسط');
    });
    it('أى جملة مالية بين الجمل تكفى لرفع الدرجة (حتى لو لم تكن ضمن الأدلة الثلاثة الأولى)', () => {
      const text =
        'يلتزم بالمواصفات المرفقة. ويلتزم بالمخططات المرفقة. ويراعى المواصفات المرفقة أيضاً. وتحدد الأجرة بحسب الجدول المرفق.';
      const f = checkUndefinedTerms(lc(text));
      expect(f.find((x) => x.id === 'undefined:attachment')!.severity).toBe('متوسط');
    });
  });

  describe('صياغة سبب المرشح', () => {
    const T = new Date('2026-11-15T12:00:00Z');
    const v = (status: Verification['status'], basis: Verification['basis']): VerifierSampleOutcome => ({
      status: 'ok',
      verification: { status, basis, reason: 'سبب', quote: null, quoteSource: null, verifiedAt: T.toISOString() },
    });
    const reasonOf = (o: VerifierSampleOutcome) => (o.status === 'ok' ? o.verification.reason : '');
    it('إجماع الشك (0/0/3): «اتفقت» لا «لم يتفق»', () => {
      const r = resolveVerifierVotes([v('unconfirmed', 'uncertain'), v('unconfirmed', 'uncertain'), v('unconfirmed', 'uncertain')], T);
      expect(reasonOf(r.outcome)).toContain('اتفقت عيّنات المدقق المستقل على الشك');
      expect(reasonOf(r.outcome)).not.toContain('لم يتفق');
    });
    it('انقسام حقيقى: «انقسمت» مع الأعداد', () => {
      const r = resolveVerifierVotes([v('confirmed', 'confirmed'), v('unconfirmed', 'refuted'), v('unconfirmed', 'uncertain')], T);
      expect(reasonOf(r.outcome)).toContain('انقسمت عيّنات المدقق المستقل (تأكيد 1، دحض 1، شك 1)');
    });
  });
});
