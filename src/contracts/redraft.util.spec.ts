import { validateRedraft } from './redraft.util';

const base = {
  originalText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 5% عن كل يوم تأخير، ولا يجوز تخفيضها بأى حال.',
  articleTexts: ['(2) ويجوز للقاضى أن يخفض هذا التعويض إذا أثبت المدين أن التقدير كان مبالغا فيه.'],
  approvedArticleNos: [224],
  changes: [],
};

describe('validateRedraft', () => {
  it('يقبل صياغة سليمة بلا أرقام جديدة', () => {
    const r = validateRedraft({
      ...base,
      proposedText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 5% عن كل يوم تأخير، مع بقاء حق القاضى فى تخفيضها إذا كان التقدير مبالغاً فيه.',
      changes: ['إزالة عبارة منع التخفيض لأنها تخالف المادة 224'],
    });
    expect(r.ok).toBe(true);
    if (r.ok) expect(r.proposal.changes).toHaveLength(1);
  });

  it('يرفض رقماً مخترعاً', () => {
    const r = validateRedraft({
      ...base,
      proposedText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 3% عن كل يوم تأخير مع جواز تخفيضها قضاءً.',
    });
    expect(r).toEqual({ ok: false, reason: 'invented_number:3' });
  });

  it('يرفض عدداً مخترعاً بالحروف', () => {
    const r = validateRedraft({
      ...base,
      proposedText: 'يلتزم المستأجر بالسداد خلال ثلاثين يوماً من الإخطار مع جواز تخفيض الغرامة قضاءً إذا بولغ فيها.',
    });
    expect(r.ok).toBe(false);
  });

  it('يقبل عدداً بالحروف موجوداً فى الأصل', () => {
    const r = validateRedraft({
      originalText: 'يسدد المستأجر الأجرة خلال ثلاثين يوماً ولا يجوز التخفيض.',
      articleTexts: [],
      approvedArticleNos: [],
      proposedText: 'يسدد المستأجر الأجرة خلال ثلاثين يوماً من تاريخ الاستحقاق، وللقاضى تخفيض الغرامة المبالغ فيها.',
      changes: [],
    });
    expect(r.ok).toBe(true);
  });

  it('يرفض رقم مادة داخل نص البند', () => {
    const r = validateRedraft({
      ...base,
      proposedText: 'يلتزم المستأجر بسداد غرامة التأخير مع مراعاة المادة 224 من القانون المدنى فى التخفيض عند المبالغة.',
    });
    expect(r).toEqual({ ok: false, reason: 'article_number_in_clause_text:224' });
  });

  it('يُبقى إحالة داخلية موجودة أصلاً فى البند الأصلى، ويرفض الجديد منها', () => {
    const original = 'يلتزم المستأجر بسداد غرامة التأخير وفقاً للمادة 5 من هذا العقد ولا يجوز تخفيضها بأى حال.';
    const kept = validateRedraft({
      ...base,
      originalText: original,
      proposedText: 'يلتزم المستأجر بسداد غرامة التأخير وفقاً للمادة 5 من هذا العقد ويجوز تخفيضها إن ثبتت المبالغة.',
    });
    expect(kept.ok).toBe(true);
    const added = validateRedraft({
      ...base,
      originalText: original,
      proposedText: 'يلتزم المستأجر بسداد غرامة التأخير وفقاً للمادة 5 من هذا العقد مع مراعاة المادة 224 عند المبالغة.',
    });
    expect(added).toEqual({ ok: false, reason: 'article_number_in_clause_text:224' });
  });

  it('يرفض النص المطابق للأصل', () => {
    expect(validateRedraft({ ...base, proposedText: base.originalText }).ok).toBe(false);
  });

  it('يرفض تسرب ترقيم المرشحين', () => {
    const r = validateRedraft({
      ...base,
      proposedText: 'يلتزم المستأجر بسداد غرامة التأخير وفقاً للمرشح 1 مع جواز التخفيض قضاءً عند المبالغة فيها.',
    });
    expect(r).toEqual({ ok: false, reason: 'candidate_leak' });
  });

  it('يحذف بنود التغييرات التى تذكر مادة غير معتمدة', () => {
    const r = validateRedraft({
      ...base,
      proposedText: 'يلتزم المستأجر بسداد غرامة التأخير مع جواز تخفيضها قضاءً إذا كان التقدير مبالغاً فيه جداً.',
      changes: ['تعديل بسبب المادة 224', 'تعديل بسبب المادة 999'],
    });
    expect(r.ok).toBe(true);
    if (r.ok) expect(r.proposal.changes).toEqual(['تعديل بسبب المادة 224']);
  });

  it('رقم فقرة فى نص المادة لا يجيز نسبة مخترعة (2%)', () => {
    const r = validateRedraft({
      ...base,
      articleTexts: ['(2) ويجوز للقاضى أن يخفض هذا التعويض.\n(3) ويقع باطلا كل اتفاق يخالف ذلك.'],
      proposedText: 'يلتزم المستأجر بسداد غرامة تأخير قدرها 2% عن كل يوم تأخير مع جواز تخفيضها قضاءً عند المبالغة.',
    });
    expect(r).toEqual({ ok: false, reason: 'invented_number:2' });
  });

  it('يقبل ترقيم الفقرات (1) و(2) داخل الصياغة', () => {
    const r = validateRedraft({
      ...base,
      proposedText: '(1) يلتزم المستأجر بسداد غرامة تأخير قدرها 5% عن كل يوم تأخير. (2) للقاضى تخفيضها إذا بولغ فى تقديرها.',
    });
    expect(r.ok).toBe(true);
  });

  it('يقبل الأرقام الهندية المطابقة للأصل', () => {
    const r = validateRedraft({
      originalText: 'غرامة ٥ % يومياً دون تخفيض.',
      articleTexts: [],
      approvedArticleNos: [],
      proposedText: 'غرامة 5 % يومياً مع جواز التخفيض قضاءً إذا بولغ فى تقديرها.',
      changes: [],
    });
    expect(r.ok).toBe(true);
  });

  describe('ملاحظات التغييرات: ادعاءات بلا سند', () => {
    const art608 = 'إذا طرأت ظروف غير متوقعة جاز طلب إنهاء العقد على أن يعوض الطالب الطرف الآخر تعويضا عادلا';
    const art224 = '(3) ويقع باطلا كل اتفاق يخالف أحكام الفقرتين السابقتين.';
    const run = (changes: string[], proposedText: string) =>
      validateRedraft({
        proposedText,
        changes,
        originalText: 'يحق لكل من الطرفين إنهاء العقد فى أى وقت بإخطار ثلاثة أشهر.',
        articleTexts: [art608, art224],
        approvedArticleNos: [608, 224],
      });
    const TEXT = 'لا يجوز إنهاء العقد قبل انقضاء مدته إلا لظروف غير متوقعة مع تعويض عادل بعد إخطار ثلاثة أشهر.';

    it('تُحذف ملاحظة تصف مادة بأنها لا تجيز الاتفاق على مخالفتها حين لا يحمل نصها صيغة ملزمة', () => {
      const r = run(['قُصر الإنهاء على الظروف غير المتوقعة وفقاً للمادة 608 التى لا تجيز الاتفاق على مخالفتها.', 'أُبقيت مدة الإخطار.'], TEXT);
      expect(r.ok && r.proposal.changes).toEqual(['أُبقيت مدة الإخطار.']);
    });

    it('تُبقى ملاحظة البطلان حين يحمل نص المادة المعروض صيغة البطلان', () => {
      const r = run(['أُضيف حق إثبات المبالغة وإبطال كل اتفاق يخالف ذلك وفق المادة 224 التى لا تجيز الاتفاق على مخالفتها.'], TEXT);
      expect(r.ok && r.proposal.changes.length).toBe(1);
    });

    it('تُحذف ملاحظة الفراغ [____] إن لم يحوِ النص المقترح فراغاً', () => {
      const r = run(['تُرك فراغ [____] غير لازم لأن المواعيد تُحال إلى القانون.', 'أُبقيت مدة الإخطار.'], TEXT);
      expect(r.ok && r.proposal.changes).toEqual(['أُبقيت مدة الإخطار.']);
    });

    it('تُبقى ملاحظة الفراغ إن كان فى النص فراغ فعلاً', () => {
      const r = run(['تُرك فراغ [____] للمهلة.'], `${TEXT} وتكون المهلة [____].`);
      expect(r.ok && r.proposal.changes.length).toBe(1);
    });
  });
});
