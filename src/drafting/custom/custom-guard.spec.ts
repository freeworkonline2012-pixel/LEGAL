import { guardModelClauses } from './custom-guard';

const P = (t: string) => ({ title: 'موضوع العقد', paragraphs: [t] });
const run = (paras: string[], input = 'وصف الصفقة بلا أرقام') => guardModelClauses([{ title: 'الثمن وسداده', paragraphs: paras }], input);

describe('guardModelClauses — الأرقام', () => {
  it('رقم لم يكتبه المستخدم يصير فراغاً', () => {
    const r = run(['يسدد الطرف الثانى الثمن خلال 30 يوماً من تاريخ الفاتورة المستحقة.']);
    expect(r.clauses[0].paragraphs[0]).toContain('خلال [____] يوماً');
    expect(r.maskedNumbers).toBe(1);
    expect(r.blanks).toBe(1);
  });

  it('رقم كتبه المستخدم يبقى، بأى شكل أرقام وفواصل', () => {
    const r = run(['يلتزم الطرف الثانى بسداد مبلغ 500,000 جنيه مصرى عند التسليم الكامل.'], 'الثمن ٥٠٠٠٠٠ جنيه');
    expect(r.clauses[0].paragraphs[0]).toContain('500,000');
    expect(r.maskedNumbers).toBe(0);
  });

  it('الأرقام بالحروف غير المصرَّح بها تصير فراغاً، وكل عدد مركّب فراغ واحد', () => {
    const r = run(['يسدد الطرف الثانى الثمن خلال ثلاثين يوماً، وتبلغ الغرامة خمسمائة ألف عن كل مخالفة.']);
    const t = r.clauses[0].paragraphs[0];
    expect(t).toContain('خلال [____] يوماً');
    expect(t).toContain('تبلغ الغرامة [____] عن كل مخالفة');
    expect(t).not.toMatch(/ثلاثين|خمسمائة|ألف/);
  });

  it('«الألف» ببادئة ال تُعامل كعدد', () => {
    const r = run(['يتحمل الطرف الأول مصروفات النقل والتأمين عن الألف الأولى من الوحدات المسلمة.']);
    expect(r.clauses[0].paragraphs[0]).toContain('[____]');
  });

  it('كلمة العدد التى كتبها المستخدم تبقى', () => {
    const r = run(['يسدد الطرف الثانى الثمن خلال ثلاثين يوماً من تاريخ استلام الفاتورة كاملة.'], 'السداد خلال ثلاثين يوماً');
    expect(r.clauses[0].paragraphs[0]).toContain('ثلاثين');
  });

  it('كتابة المبلغ بالحروف بين قوسين بعد رقم مصرَّح به تُحذف ولا تبقى كتابة غير موثقة', () => {
    const r = run(['يلتزم الطرف الثانى بسداد 500000 (خمسمائة ألف جنيه مصرى فقط) عند التسليم الكامل.'], 'الثمن 500000');
    const t = r.clauses[0].paragraphs[0];
    expect(t).toContain('500000');
    expect(t).not.toMatch(/خمسمائة|فقط/);
  });

  it('«واحد» و«اثنين» لا تُعد أرقاماً (طرف واحد، الطرفين)', () => {
    const r = run(['لا يجوز لطرف واحد تعديل شروط هذا العقد دون موافقة الطرفين المكتوبة والصريحة.']);
    expect(r.clauses[0].paragraphs[0]).not.toContain('[____]');
  });
});

describe('guardModelClauses — الاستشهادات والمخالفات', () => {
  it.each([
    'يخضع هذا الالتزام لأحكام المادة 217 من القانون المدنى فى كل ما لم يرد فيه نص.',
    'يسرى على العقد القانون رقم كذا المنظم لهذا النشاط بالكامل وبلا استثناء.',
    'وذلك طبقاً لقانون التجارة الصادر لسنة كذا وتعديلاته اللاحقة عليه.',
    'استقر قضاء محكمة النقض على بطلان هذا الشرط فى مثل هذه العقود جميعاً.',
  ])('فقرة بها استشهاد تُحذف: %s', (t) => {
    const r = guardModelClauses([{ title: 'أحكام', paragraphs: [t, 'يلتزم كل طرف بتنفيذ التزاماته التعاقدية بحسن نية وعناية.'] }], 'x');
    expect(r.droppedParagraphs).toBe(1);
    expect(r.clauses[0].paragraphs).toHaveLength(1);
    expect(r.problems).toContain('استشهاد بمادة أو قانون غير موثَّق');
  });

  it('فقرة تخالف نصاً آمراً (فائدة تأخير مبالغ فيها) تُحذف حتى لو كان الرقم مصرَّحاً به', () => {
    const r = guardModelClauses(
      [{ title: 'التأخير', paragraphs: ['يلتزم العميل بسداد فائدة تأخير مقدارها 12% شهرياً عن كل شهر تأخير فى السداد.', 'يخطر العميل المورد كتابة بأى سبب يعوق السداد فى الموعد المحدد.'] }],
      'فائدة التأخير 12%',
    );
    expect(r.droppedParagraphs).toBe(1);
    expect(r.problems).toContain('مخالفة لنص آمر');
  });

  it('روابط وماركداون ورموز HTML', () => {
    const r = run(['راجع الشروط على https://example.com قبل التنفيذ الفعلى للعقد.', '**مهم** يلتزم الطرف الأول بالتسليم فى الموعد المحدد بالعقد.', '<b>يلتزم</b> الطرف الثانى بالاستلام فى الموعد المحدد بالعقد.']);
    expect(r.clauses).toHaveLength(0);
    expect(r.droppedParagraphs).toBe(3);
  });
});

describe('guardModelClauses — الشكل', () => {
  it('أنماط الفراغ تُوحَّد، والترقيم الافتتاحى يُعاد كتابته (1) (2)', () => {
    const r = run(['1- يسدد الطرف الثانى الثمن خلال [مدة] من تاريخ الفاتورة المستحقة.', '٢) يلتزم الطرف الأول بإصدار فاتورة ........ عن كل دفعة مستحقة.']);
    expect(r.clauses[0].paragraphs[0]).toBe('(1) يسدد الطرف الثانى الثمن خلال [____] من تاريخ الفاتورة المستحقة.');
    expect(r.clauses[0].paragraphs[1]).toBe('(2) يلتزم الطرف الأول بإصدار فاتورة [____] عن كل دفعة مستحقة.');
    expect(r.blanks).toBe(2);
  });

  it('فقرة وحيدة بلا ترقيم', () => {
    const r = run(['يلتزم الطرف الأول بتسليم المورد فى الموعد المتفق عليه بين الطرفين.']);
    expect(r.clauses[0].paragraphs[0]).not.toMatch(/^\(/);
  });

  it('بنود الهيكل الثابت تُحذف، والمكرر، والعنوان بأرقام يُنظَّف', () => {
    const para = 'يلتزم كل طرف بتنفيذ التزاماته التعاقدية بحسن نية وعناية الرجل المعتاد.';
    const r = guardModelClauses(
      [
        { title: 'تسوية المنازعات', paragraphs: [para] },
        { title: 'الإخطارات', paragraphs: [para] },
        { title: 'أحكام عامة', paragraphs: [para] },
        { title: '3- التسليم', paragraphs: [para] },
        { title: 'التسليم', paragraphs: [para] },
        { title: 'البند الخامس', paragraphs: [para] },
      ],
      'x',
    );
    expect(r.clauses.map((c) => c.title)).toEqual(['التسليم']);
    expect(r.droppedClauses).toBe(5);
  });

  it('مدخل ليس مصفوفة أو بند بلا فقرات صالحة', () => {
    expect(guardModelClauses(null, 'x').clauses).toEqual([]);
    expect(guardModelClauses('x', 'x').clauses).toEqual([]);
    expect(guardModelClauses([{ title: 'ت', paragraphs: [] }, 5, null], 'x').clauses).toEqual([]);
  });

  it('حدود الحجم: فقرة قصيرة أو طويلة جداً تُحذف، وعدد البنود محدود', () => {
    const many = Array.from({ length: 40 }, (_, i) => ({ title: `بند مختلف ${'ا'.repeat(i + 1)}`, paragraphs: ['يلتزم كل طرف بتنفيذ التزاماته التعاقدية بحسن نية وعناية.'] }));
    expect(guardModelClauses(many, 'x').clauses.length).toBeLessThanOrEqual(20);
    const r = run(['قصيرة', 'ا'.repeat(1600)]);
    expect(r.clauses).toHaveLength(0);
  });
});
