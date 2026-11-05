import { amountConflictWarnings, extractKeyTerms, type KeyTermClause } from './key-terms';
import { normalizeArabicForMatch } from './reasoning.util';

const clause = (clauseIndex: number, clauseText: string, clauseLabel = `البند ${clauseIndex}`): KeyTermClause => ({
  clauseIndex,
  clauseLabel,
  clauseTitle: null,
  clauseText,
});

describe('extractKeyTerms (الجولة 6)', () => {
  it('amounts in digits, with and without the written-out words', () => {
    const t = extractKeyTerms([
      clause(1, 'تبلغ قيمة العقد 1125000 جنيه مصرى تسدد على دفعات.'),
      clause(2, 'يدفع الطرف الثانى مبلغ 50,000 ( خمسون ألف ) جنيه عند التوقيع.'),
    ]);
    expect(t.filter((x) => x.kind === 'amount').map((x) => x.value)).toEqual(['1,125,000 جنيه', '50,000 جنيه']);
  });

  it('amounts written only in words are read, and flagged fromWords', () => {
    const t = extractKeyTerms([clause(1, 'يلتزم الطرف الأول بدفع مبلغ مائة وخمسون ألف جنيه عند التسليم.')]);
    const a = t.find((x) => x.kind === 'amount');
    expect(a?.value).toBe('150,000 جنيه');
    expect(a?.fromWords).toBe(true);
  });

  it('percentages, including Arabic-Indic digits and the written %', () => {
    const t = extractKeyTerms([clause(1, 'الدفعة الأولى ٣٠% عند التعاقد، والثانية 30 % عند التسليم، والباقى 40 بالمائة.')]);
    expect(t.filter((x) => x.kind === 'percent').map((x) => x.value)).toEqual(['30%', '40%']);
  });

  it('durations in digits and in words, without reading dates or article numbers as durations', () => {
    const t = extractKeyTerms([
      clause(1, 'مدة العقد 3 سنوات تبدأ من 1/1/2026. ويخطر الطرف الآخر قبل ثلاثين يوماً، وللطرف الأول مهلة 12 ( اثنا عشر ) شهراً.'),
      clause(2, 'تسرى المادة 5 من هذا العقد.'),
    ]);
    expect(t.filter((x) => x.kind === 'duration').map((x) => x.value)).toEqual(['3 سنوات', '30 يوماً', '12 شهراً']);
  });

  it('dates in both orders, rejecting impossible ones', () => {
    const t = extractKeyTerms([clause(1, 'يبدأ العقد فى 15/03/2026 وينتهى فى 2027-03-14 ولا أثر لـ 45/13/2026.')]);
    expect(t.filter((x) => x.kind === 'date').map((x) => x.value)).toEqual(['15/03/2026', '14/03/2027']);
  });

  it('every quote is a real contiguous passage of the clause (after whitespace normalisation)', () => {
    const text =
      'تبلغ قيمة العقد 1125000 جنيه مصرى.\nتسدد القيمة على ثلاث دفعات: الأولى 30% عند التعاقد، والثانية 30% عند التسليم الأولى، والأخيرة 40% بعد القبول النهائى خلال 15 يوماً من التسليم.';
    const terms = extractKeyTerms([clause(1, text)]);
    expect(terms.length).toBeGreaterThanOrEqual(4);
    const hay = normalizeArabicForMatch(text);
    for (const t of terms) {
      expect(hay.includes(normalizeArabicForMatch(t.quote))).toBe(true);
      expect(t.quote.length).toBeLessThanOrEqual(320);
    }
  });

  it('long sentences are windowed around the term, still verbatim', () => {
    const filler = 'وذلك وفقاً للشروط والضوابط المتفق عليها بين الطرفين '.repeat(12);
    const text = `${filler}ويلتزم الطرف الثانى بالسداد خلال 45 يوماً من تاريخ الفاتورة ${filler}.`;
    const [t] = extractKeyTerms([clause(1, text)]);
    expect(t.value).toBe('45 يوماً');
    expect(t.quote.length).toBeLessThanOrEqual(320);
    expect(normalizeArabicForMatch(text).includes(normalizeArabicForMatch(t.quote))).toBe(true);
  });

  it('digits followed by the words in brackets with the currency inside them are read as digits', () => {
    const t = extractKeyTerms([clause(1, 'إجمالى الثمن 600000 ( ستمائة ألف جنيه مصرى فقط ) يسدده الطرف الثانى.')]);
    const a = t.filter((x) => x.kind === 'amount');
    expect(a).toHaveLength(1);
    expect(a[0]).toMatchObject({ value: '600,000 جنيه', fromWords: false });
  });

  it('keeps repeated percentages that sit in different sentences (instalments)', () => {
    const t = extractKeyTerms([clause(1, 'الدفعة الأولى : قيمتها 30 % تسدد عند التعاقد.\nالدفعة الثانية : قيمتها 30 % تسدد عند التسليم.\nالدفعة الثالثة : قيمتها 40 % عند الإطلاق.')]);
    expect(t.filter((x) => x.kind === 'percent').map((x) => x.value)).toEqual(['30%', '30%', '40%']);
  });

  it('is deterministic, de-duplicates within a clause and keeps clause order', () => {
    const cl = [clause(2, 'المدة 30 يوماً ثم 30 يوماً أخرى.'), clause(1, 'السعر 100000 جنيه.')];
    const a = extractKeyTerms(cl);
    expect(a.map((x) => `${x.clauseIndex}:${x.value}`)).toEqual(['1:100,000 جنيه', '2:30 يوماً']);
    expect(extractKeyTerms(cl)).toEqual(a);
  });

  it('returns nothing for clauses without figures, and caps the total', () => {
    expect(extractKeyTerms([clause(1, 'يلتزم الطرفان بحسن النية فى تنفيذ العقد.')])).toEqual([]);
    const many = Array.from({ length: 80 }, (_, i) => clause(i + 1, `السعر ${1000 + i} جنيه.`));
    expect(extractKeyTerms(many)).toHaveLength(60);
  });

  describe('الجولة 30: ضجيج المسح الضوئى', () => {
    const REAL =
      'قيمة هذا العقد هى مبلغ 1125000 ) مليون ومائة وذ خمسة وعشرون ألف جنيه مصرى فقط ) مقسمة على ثلاث مجموعات.';

    it('never emits a partial amount from words broken by OCR noise (25,000 instead of 1,125,000)', () => {
      const amounts = extractKeyTerms([clause(1, REAL)]).filter((x) => x.kind === 'amount');
      expect(amounts.map((a) => a.value)).toEqual(['1,125,000 جنيه']);
      expect(amounts.some((a) => a.value === '25,000 جنيه')).toBe(false);
    });

    it('reads the full amount from words when OCR noise sits inside it and no digits exist', () => {
      const t = extractKeyTerms([clause(1, 'قيمة العقد مليون ومائة وذ خمسة وعشرون ألف جنيه مصرى فقط تسدد على دفعات.')]);
      const a = t.find((x) => x.kind === 'amount');
      expect(a).toMatchObject({ value: '1,125,000 جنيه', fromWords: true });
    });

    it('does not swallow ordinary words before the number (fail closed on the span)', () => {
      const t = extractKeyTerms([clause(1, 'يلتزم الطرف الأول بدفع مبلغ خمسون ألف جنيه عند التسليم.')]);
      expect(t.find((x) => x.kind === 'amount')?.value).toBe('50,000 جنيه');
    });

    it('flags "15 96 سنويا" as a suspect percentage instead of dropping it', () => {
      const t = extractKeyTerms([clause(1, 'رسوم ثابتة وقدرها 15 96 سنويا من قيمة كل مجموعة.')]);
      const p = t.find((x) => x.kind === 'percent');
      expect(p?.value).toBe('15%');
      expect(p?.suspect).toContain('96');
      expect(p?.quote).toContain('15 96');
    });

    it('flags "قيمتها 9640" as a suspect 40% but leaves real amounts alone', () => {
      const t = extractKeyTerms([clause(1, 'الدفعة الثالثة : قيمتها 9640 تسدد بعد إنهاء تفعيل البرامج.')]);
      const p = t.find((x) => x.kind === 'percent');
      expect(p?.value).toBe('40%');
      expect(p?.suspect).toBeTruthy();
      const none = extractKeyTerms([clause(1, 'قيمتها 9640 جنيه تسدد عند التسليم.')]);
      expect(none.some((x) => x.kind === 'percent')).toBe(false);
      expect(none.find((x) => x.kind === 'amount')?.value).toBe('9,640 جنيه');
    });

    it('clean percentages carry no suspect flag', () => {
      const t = extractKeyTerms([clause(1, 'تسدد 40 % عند التسليم.')]);
      expect(t[0].suspect).toBeUndefined();
    });
  });
});

describe('تعارض الرقم مع الحروف ووحدة المدة غير المقروءة (الجولة 51)', () => {
  const only = (text: string) => extractKeyTerms([clause(4, text)]);

  it('keeps the duration when the unit word was read as Latin noise, flagged', () => {
    const t = only('هذا العقد فى اى وقت بشرط اخطار الطرف الاخر قبل الالغاء بمدة ثلاثين \u200elags\u200f .');
    const d = t.find((x) => x.kind === 'duration');
    expect(d).toBeDefined();
    expect(d?.value).toBe('30 (وحدة المدة غير مقروءة)');
    expect(d?.suspect).toContain('وحدة المدة');
    expect(d?.fromWords).toBe(true);
  });

  it('the same for digits followed by Latin noise, and never invents a unit', () => {
    const d = only('يخطر الطرف الآخر بمدة 60 days كاملة.').find((x) => x.kind === 'duration');
    expect(d?.value).toBe('60 (وحدة المدة غير مقروءة)');
    expect(d?.value).not.toMatch(/يوم|شهر|سنة/);
  });

  it('a clean unit still wins and is not flagged', () => {
    const d = only('بمدة ثلاثين يوماً من تاريخه.').find((x) => x.kind === 'duration');
    expect(d?.value).toBe('30 يوماً');
    expect(d?.suspect).toBeUndefined();
  });

  it('unreadable words before a Latin token are not turned into a duration', () => {
    expect(only('خلال مدة سريان هذا العقد lags وما بعده.').some((x) => x.kind === 'duration')).toBe(false);
  });

  it('flags a digits-vs-words contradiction as one row with the words value', () => {
    const t = only('الحد الأدنى للأقساط 452,500,000 جنيه مصرى سنويا ( فقط خمسمائة الف جنيها مصريالاغير) عن العمليات.');
    const amounts = t.filter((x) => x.kind === 'amount');
    expect(amounts).toHaveLength(1);
    expect(amounts[0].value).toBe('500,000 جنيه');
    expect(amounts[0].fromWords).toBe(true);
    expect(amounts[0].suspect).toContain('452,500,000');
    expect(amounts[0].suspect).toContain('500,000');
  });

  it('matching digits and words appear once, unflagged', () => {
    const t = only('حد أدنى 500,000 جم ( خمسمائة الف جنيها مصريا) صافى الرسوم.');
    const amounts = t.filter((x) => x.kind === 'amount');
    expect(amounts).toHaveLength(1);
    expect(amounts[0].suspect).toBeUndefined();
    expect(amounts[0].value).toBe('500,000 جنيه');
  });

  it('flags a garbled digit ("0") that precedes an amount written in words', () => {
    const t = only('الاقساط\n0 جنيه مصرى سنويا ( فقط خمسمائة الف جنيها مصريالاغير) عن العمليات.');
    const amounts = t.filter((x) => x.kind === 'amount');
    expect(amounts).toHaveLength(1);
    expect(amounts[0].value).toBe('500,000 جنيه');
    expect(amounts[0].suspect).toContain('تالف');
  });

  it('parenthesised words that contradict the digits are flagged too', () => {
    const t = only('يدفع 5000 ( ستة آلاف ) جنيه عند التسليم.');
    expect(t.find((x) => x.kind === 'amount')?.suspect).toContain('تعارض');
  });

  it('does not pair two separate amounts in different sentences', () => {
    const t = only('يدفع 5,000 جنيه شهرياً. ثم يدفع ( خمسون ألف جنيه ) عند الإنهاء.');
    expect(t.filter((x) => x.kind === 'amount' && x.suspect)).toHaveLength(0);
  });

  it('reads the OCR 90/96-prefixed percentages in rate tables, flagged', () => {
    const t = only('فى حالة تحقيق 1,000,000 جنيه مصرى تصرف مصروفات ادارية بواقع 967 وحصة 9030 من اجمالى المحفظة.');
    const pcts = t.filter((x) => x.kind === 'percent');
    expect(pcts.map((x) => x.value)).toEqual(['7%', '30%']);
    expect(pcts.every((x) => !!x.suspect)).toBe(true);
  });

  it('a plain amount near "بواقع" is not mistaken for a percentage', () => {
    const t = only('تصرف مصروفات بواقع 9640 جنيه شهرياً.');
    expect(t.some((x) => x.kind === 'percent')).toBe(false);
  });

  it('builds one contract-level warning per contradiction and skips ones already reported', () => {
    const text = 'الحد الأدنى 452,500,000 جنيه مصرى سنويا ( فقط خمسمائة الف جنيها مصريالاغير) عن العمليات.';
    const w = amountConflictWarnings([text, text]);
    expect(w).toHaveLength(1);
    expect(w[0]).toContain('452,500,000');
    expect(amountConflictWarnings([text], w.map(() => 'تناقض 452,500,000 مقابل 500,000'))).toHaveLength(0);
    expect(amountConflictWarnings(['يدفع 5000 جنيه.'])).toHaveLength(0);
  });
});
