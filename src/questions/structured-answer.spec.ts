import {
  hasArticleRef,
  buildStatusWarnings,
  collectProseForGate,
  computeSourceStatus,
  normalizeForQuote,
  parseStructuredAnswer,
  renderStructuredAsText,
  verifyQuote,
} from './structured-answer';

const ART_154 =
  'إذا أُبرم العقد أو جُدد لمدة تزيد على خمس سنوات، أو كان العقد غير محدد المدة، ' +
  'فإذا كان الإنهاء من جانب صاحب العمل استحق العامل مكافأة عن مدة خدمته (١٥٤).';
const ART_165 = 'يستحق العامل تعويضاً إذا فُصل دون إشعار في الحالات الواردة بالمادة 165.';

describe('computeSourceStatus', () => {
  it('ساري للحالتين active وin_force', () => {
    expect(computeSourceStatus({ status: 'active', lastAmended: null })).toBe('ساري');
    expect(computeSourceStatus({ status: 'in_force', lastAmended: null })).toBe('ساري');
  });
  it('معدّل فقط عند معرفة تاريخ التعديل، وإلا غير محسوم', () => {
    expect(computeSourceStatus({ status: 'amended', lastAmended: '2024-05-01' })).toBe('معدّل');
    expect(computeSourceStatus({ status: 'amended', lastAmended: null })).toBe('غير محسوم');
  });
  it('ملغى، وأى قيمة مجهولة أو مفقودة = غير محسوم (لا نفترض السريان)', () => {
    expect(computeSourceStatus({ status: 'repealed', lastAmended: null })).toBe('ملغى');
    expect(computeSourceStatus({ status: undefined, lastAmended: null })).toBe('غير محسوم');
    expect(computeSourceStatus({ status: 'weird', lastAmended: null })).toBe('غير محسوم');
  });
});

describe('verifyQuote', () => {
  it('يقبل مقتطفاً حرفياً بعد تطبيع الأرقام والتشكيل وعلامات الترقيم', () => {
    expect(verifyQuote('فإذا كان الإنهاء من جانب صاحب العمل استحق العامل مكافأة', ART_154)).toBe(true);
    expect(verifyQuote('أُبرم العقد أو جُدد لمدة تزيد على خمس سنوات', ART_154)).toBe(true);
  });
  it('يقبل مقطعين حرفيين بينهما حذف ...', () => {
    expect(verifyQuote('لمدة تزيد على خمس سنوات ... استحق العامل مكافأة', ART_154)).toBe(true);
    expect(verifyQuote('لمدة تزيد على خمس سنوات … استحق العامل مكافأة', ART_154)).toBe(true);
  });
  it('يرفض مقتطفاً مُعاد صياغته أو مختلقاً', () => {
    expect(verifyQuote('يستحق العامل مكافأة إذا أنهى صاحب العمل العقد', ART_154)).toBe(false);
    expect(verifyQuote('لمدة تزيد على ثلاث سنوات', ART_154)).toBe(false);
  });
  it('يرفض أى مقطع غير موجود حتى لو وُجد غيره، ويرفض الفارغ والقصير جداً', () => {
    expect(verifyQuote('لمدة تزيد على خمس سنوات ... مبلغ مقطوع ثابت', ART_154)).toBe(false);
    expect(verifyQuote('', ART_154)).toBe(false);
    expect(verifyQuote('العقد', ART_154)).toBe(false);
  });
  it('لا يطابق جزءاً من كلمة (حدود الكلمات)', () => {
    expect(verifyQuote('عقد غير محدد المد', ART_154)).toBe(false);
  });
  it('normalizeForQuote يوحّد الأرقام الهندية والهمزات', () => {
    expect(normalizeForQuote('المادة (١٥٤) أُبرم')).toBe('الماده 154 ابرم');
  });
});

describe('parseStructuredAnswer', () => {
  const arts = [{ text: ART_154 }, { text: ART_165 }];
  const good = {
    direct_answer: 'نعم، يستحق مكافأة بشرط أن تتجاوز المدة خمس سنوات.',
    rulings: [
      {
        claim: 'استحق العامل مكافأة إذا كان الإنهاء من جانب صاحب العمل.',
        kind: 'نص',
        source: 1,
        quote: 'فإذا كان الإنهاء من جانب صاحب العمل استحق العامل مكافأة',
      },
      {
        claim: 'عدم تجديد العقد المؤقت قد يُعد إنهاءً من صاحب العمل.',
        kind: 'تفسير',
        source: 1,
        quote: null,
      },
    ],
    open_issues: ['هل تُجمع مدد التجديدات السنوية نحو خمس سنوات غير منصوص عليه صراحةً.'],
    warnings: ['الحق مشروط بمدة تزيد على خمس سنوات (المادة 1).'],
    facts_to_confirm: ['ما مدة الخدمة الإجمالية؟'],
    not_covered: [],
  };

  it('يقبل بنية سليمة ويحوّل source (من 1) إلى citation_index (من 0)', () => {
    const r = parseStructuredAnswer(JSON.stringify(good), arts);
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.rulings[0]).toMatchObject({ kind: 'نص', citation_index: 0, quote_verified: true });
    expect(r.value.rulings[1]).toMatchObject({ kind: 'تفسير', quote: null, quote_verified: false });
    expect(r.value.facts_to_confirm).toEqual(['ما مدة الخدمة الإجمالية؟']);
  });

  it('يخفّض "نص" إلى "تفسير" إذا لم يثبت المقتطف الحرفى ويُسقط المقتطف', () => {
    const bad = {
      ...good,
      rulings: [{ claim: 'حكم مختلق الصياغة تماماً هنا.', kind: 'نص', source: 1, quote: 'مقتطف غير موجود فى النص أبداً' }],
    };
    const r = parseStructuredAnswer(JSON.stringify(bad), arts);
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.rulings[0].kind).toBe('تفسير');
    expect(r.value.rulings[0].quote).toBeNull();
  });

  it('يخفّض "نص" بلا مقتطف، ويعامل أى وسم غير معروف كتفسير', () => {
    const bad = {
      ...good,
      rulings: [
        { claim: 'حكم بلا مقتطف إطلاقاً.', kind: 'نص', source: 2 },
        { claim: 'حكم بوسم غريب هنا.', kind: 'قطعى', source: 2, quote: 'يستحق العامل تعويضاً إذا فُصل دون إشعار' },
      ],
    };
    const r = parseStructuredAnswer(JSON.stringify(bad), arts);
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.rulings.map((x) => x.kind)).toEqual(['تفسير', 'تفسير']);
    expect(r.value.rulings[1].quote_verified).toBe(true);
  });

  it('يُسقط الأحكام ذات source خارج النطاق ويرفض البنية إن سقطت كلها', () => {
    const bad = { ...good, rulings: [{ claim: 'حكم لمصدر غير موجود.', kind: 'تفسير', source: 7 }] };
    expect(parseStructuredAnswer(JSON.stringify(bad), arts)).toEqual({ ok: false, reason: 'no_valid_rulings' });
    const mixed = { ...good, rulings: [...good.rulings, { claim: 'حكم لمصدر غير موجود.', kind: 'تفسير', source: 0 }] };
    const r = parseStructuredAnswer(JSON.stringify(mixed), arts);
    expect(r.ok && r.value.rulings.length).toBe(2);
  });

  it('يرفض JSON تالفاً، وغياب الجواب المباشر، وغير الكائن', () => {
    expect(parseStructuredAnswer('not json', arts)).toEqual({ ok: false, reason: 'unparseable_json' });
    expect(parseStructuredAnswer('[1,2]', arts)).toEqual({ ok: false, reason: 'not_an_object' });
    expect(parseStructuredAnswer(JSON.stringify({ ...good, direct_answer: '' }), arts)).toEqual({
      ok: false,
      reason: 'missing_direct_answer',
    });
  });

  it('يقبل JSON داخل أسوار ```json ويقصّ الأطوال ويحدّ عدد العناصر ويزيل المكرَّر', () => {
    const many = {
      ...good,
      open_issues: Array.from({ length: 20 }, (_, i) => `مسألة رقم ${i} مفتوحة`).concat(['مسألة رقم 0 مفتوحة']),
      warnings: ['(المادة 1) ' + 'س'.repeat(2000)],
    };
    const r = parseStructuredAnswer('```json\n' + JSON.stringify(many) + '\n```', arts);
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.open_issues).toHaveLength(8);
    expect(r.value.warnings[0].length).toBeLessThanOrEqual(700);
  });

  it('يحدّ التحذيرات (4) والوقائع (5) والأحكام (8) ويُرجع إحصاءات التخفيض والإسقاط', () => {
    const many = {
      ...good,
      rulings: [
        ...Array.from({ length: 10 }, (_, i) => ({ claim: `حكم رقم ${i} موجز`, kind: 'تفسير', source: 1 })),
        { claim: 'حكم نص بلا مقتطف صحيح', kind: 'نص', source: 1, quote: 'مقتطف غير موجود إطلاقاً هنا' },
        { claim: 'حكم لمصدر غير صالح', kind: 'تفسير', source: 9 },
      ],
      warnings: Array.from({ length: 9 }, (_, i) => `تحذير ${i} مختلف (المادة ${i + 1})`),
      facts_to_confirm: Array.from({ length: 9 }, (_, i) => `واقعة ${i} مختلفة؟`),
    };
    const r = parseStructuredAnswer(JSON.stringify(many), arts);
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.rulings).toHaveLength(8);
    expect(r.value.warnings).toHaveLength(4);
    expect(r.value.facts_to_confirm).toHaveLength(5);
    const r2 = parseStructuredAnswer(
      JSON.stringify({
        ...good,
        rulings: [
          { claim: 'حكم نص بلا مقتطف صحيح', kind: 'نص', source: 1, quote: 'مقتطف غير موجود إطلاقاً هنا' },
          { claim: 'حكم لمصدر غير صالح', kind: 'تفسير', source: 9 },
          good.rulings[0],
        ],
      }),
      arts,
    );
    expect(r2.ok && r2.stats).toMatchObject({ requested_text: 2, downgraded: 1, dropped: 1 });
    expect(r2.ok && r2.stats.failures).toHaveLength(1);
  });

  it('يحتفظ بالمقتطف الموثَّق حتى مع kind=تفسير (نص مرتبط بالحكم)', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({
        ...good,
        rulings: [{ claim: 'ربط تفسيرى بالواقعة هنا.', kind: 'تفسير', source: 1, quote: 'استحق العامل مكافأة عن مدة خدمته' }],
      }),
      arts,
    );
    expect(r.ok && r.value.rulings[0]).toMatchObject({ kind: 'تفسير', quote_verified: true });
    expect(r.ok && r.value.rulings[0].quote).toBe('استحق العامل مكافأة عن مدة خدمته');
  });

  it('المقتطف الطويل الموثَّق يُقتطع إلى 40 كلمة مع "…" ويبقى نصاً؛ والطويل غير الموثَّق يُخفَّض', () => {
    const longText = Array.from({ length: 80 }, (_, i) => `كلمة${i}`).join(' ');
    const ok = parseStructuredAnswer(
      JSON.stringify({ ...good, rulings: [{ claim: Array.from({ length: 10 }, (_, i) => `كلمة${i}`).join(' '), kind: 'نص', source: 1, quote: longText }] }),
      [{ text: longText }, { text: ART_165 }],
    );
    expect(ok.ok && ok.value.rulings[0].kind).toBe('نص');
    expect(ok.ok && ok.value.rulings[0].quote!.split(' ').length).toBe(41); // 40 كلمة + "…"
    expect(ok.ok && ok.value.rulings[0].quote!.endsWith('…')).toBe(true);
    const bad = parseStructuredAnswer(
      JSON.stringify({ ...good, rulings: [{ claim: 'حكم بمقتطف طويل مختلق.', kind: 'نص', source: 1, quote: longText + ' زيادة مختلقة' }] }),
      [{ text: longText }, { text: ART_165 }],
    );
    expect(bad.ok && bad.value.rulings[0].kind).toBe('تفسير');
    expect(bad.ok && bad.stats.failures[0]).toContain('unverified');
  });
});

describe('hasArticleRef وإسقاط التحذيرات بلا سند', () => {
  it('يتعرف على صيغ الإحالة إلى المادة', () => {
    expect(hasArticleRef('مهلة الإخطار ثلاثة أشهر (المادة 156).')).toBe(true);
    expect(hasArticleRef('بحسب المواد 87 و88')).toBe(true);
    expect(hasArticleRef('وفق م 95')).toBe(true);
    expect(hasArticleRef('المادة (١٥٦)')).toBe(true);
    expect(hasArticleRef('مهلة الإخطار ثلاثة أشهر كتابةً.')).toBe(false);
    expect(hasArticleRef('تسقط الحقوق بعدم تقديم طلب خلال المدد المقررة.')).toBe(false);
  });

  it('يُسقط التحذير الذى لا يذكر مادة ويُحصيه، ويُبقى المسنَد', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({
        direct_answer: 'جواب مباشر مفصل كفاية.',
        rulings: [{ claim: 'حكم موجز واحد.', kind: 'تفسير', source: 1 }],
        warnings: ['تحذير بلا مادة تماماً.', 'مهلة الإخطار ثلاثة أشهر كتابةً (المادة 1).'],
      }),
      [{ text: 'نص المادة الأولى: مهلة الإخطار ثلاثة أشهر.' }],
    );
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.warnings).toEqual(['مهلة الإخطار ثلاثة أشهر كتابةً (المادة 1).']);
    expect(r.stats.warnings_dropped).toBe(1);
  });

  it('لا يعدّ التحذيرات المُسقَطة ضمن حدّ الأربعة', () => {
    const warnings = [
      ...Array.from({ length: 3 }, (_, i) => `بلا مادة ${i} مختلف.`),
      ...Array.from({ length: 4 }, (_, i) => `بمادة ${i} مختلف (المادة ${i + 1}).`),
    ];
    const r = parseStructuredAnswer(
      JSON.stringify({
        direct_answer: 'جواب مباشر مفصل كفاية.',
        rulings: [{ claim: 'حكم موجز واحد.', kind: 'تفسير', source: 1 }],
        warnings,
      }),
      [{ text: 'نص' }],
    );
    expect(r.ok && r.value.warnings).toHaveLength(4);
  });
});

describe('collectProseForGate / renderStructuredAsText / buildStatusWarnings', () => {
  const structured = {
    direct_answer: 'يعتمد على مدة الخدمة.',
    rulings: [
      { claim: 'حكم أول.', kind: 'نص' as const, citation_index: 0, quote: 'ق', quote_verified: true },
      { claim: 'حكم ثانٍ.', kind: 'تفسير' as const, citation_index: 1, quote: null, quote_verified: false },
    ],
    scenarios: [{ condition: 'كانت الخدمة أقل من خمس سنوات', outcome: 'لا مكافأة.', citation_index: 0 }],
    open_issues: ['مسألة مفتوحة.'],
    warnings: ['تحذير.'],
    facts_to_confirm: ['ما مدة الخدمة؟'],
    not_covered: ['جزء غير مغطى.'],
  };
  const cites = [
    { law: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 154, sourceStatus: 'ساري' as const },
    { law: 'قانون العمل', lawNo: 14, lawYear: 2025, articleNo: 165, sourceStatus: 'غير محسوم' as const },
  ];

  it('collectProseForGate لا يشمل المقتطفات الحرفية', () => {
    const t = collectProseForGate(structured);
    expect(t).toContain('حكم أول.');
    expect(t).toContain('جزء غير مغطى.');
    expect(t).toContain('لا مكافأة.');
    expect(t).not.toContain('\nق\n');
  });

  it('العرض النصى: الجواب المباشر أولاً ثم التطبيق على الحالة ثم التنبيهات ثم المسائل المفتوحة ثم الوقائع ثم الأحكام بسندها', () => {
    const text = renderStructuredAsText(structured, cites, buildStatusWarnings(cites));
    const order = ['الجواب المباشر:', 'تطبيق على حالتك', 'تنبيهات:', 'مسائل مفتوحة', 'وقائع يلزم تأكيدها', 'الأحكام وسندها:', 'أجزاء من السؤال'].map(
      (h) => text.indexOf(h),
    );
    expect(order.every((i) => i >= 0)).toBe(true);
    expect([...order].sort((a, b) => a - b)).toEqual(order);
    expect(text).toContain('1. حكم أول. [نص]');
    expect(text).toContain('- إذا كانت الخدمة أقل من خمس سنوات: لا مكافأة. (المادة 154)');
    expect(text).toContain('السند: المادة 165 من قانون العمل (رقم 14 لسنة 2025) — غير محسوم');
  });

  it('تحذيرات الحالة تخص غير الساري فقط', () => {
    const w = buildStatusWarnings([
      ...cites,
      { law: 'ق', lawNo: 1, lawYear: 1990, articleNo: 3, sourceStatus: 'ملغى' },
      { law: 'ق', lawNo: 2, lawYear: 1991, articleNo: 4, sourceStatus: 'معدّل' },
    ]);
    expect(w).toHaveLength(3);
    expect(w.join('|')).toContain('ملغاة');
    expect(w.join('|')).toContain('معدَّلة');
    expect(w.join('|')).toContain('غير محسومة');
  });
});
