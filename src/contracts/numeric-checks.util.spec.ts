import { checkInstallments, findAmountMismatches, numericWarnings, parseArabicNumberWords } from './numeric-checks.util';

// بيانات مُصطنَعة بالكامل (لا مبالغ ولا أطراف عقد حقيقى).
describe('parseArabicNumberWords', () => {
  it.each([
    ['مليون ومائة وخمسة وعشرون ألف', 1_125_000],
    ['ثلاثمائة ألف', 300_000],
    ['خمسون ألف جنيه مصرى فقط لا غير', 50_000],
    ['ألفان وخمسمائة', 2_500],
    ['مليونان', 2_000_000],
  ])('%s', (phrase, expected) => {
    expect(parseArabicNumberWords(phrase)).toBe(expected);
  });

  it('يفشل مغلقاً (null) على عبارة غير مفهومة بدل التخمين', () => {
    expect(parseArabicNumberWords('مبلغ كبير جداً')).toBeNull();
    expect(parseArabicNumberWords('')).toBeNull();
  });
});

describe('findAmountMismatches', () => {
  it('لا يبلغ عن تطابق الرقم مع الحروف', () => {
    expect(findAmountMismatches('القيمة 1125000 جنيه ( مليون ومائة وخمسة وعشرون ألف جنيه مصرى فقط )')).toEqual([]);
  });

  it('يكشف التعارض بين الرقم والحروف', () => {
    const r = findAmountMismatches('القيمة 1500000 ( مليون ومائة وخمسة وعشرون ألف جنيه فقط )');
    expect(r).toHaveLength(1);
    expect(r[0]).toMatchObject({ digits: 1_500_000, words: 1_125_000 });
  });

  it('يتجاهل العبارة التى لا يفهمها المحلل (لا تحذير كاذب)', () => {
    expect(findAmountMismatches('القيمة 1500000 ( كما هو مبين بالملحق المرفق )')).toEqual([]);
  });
});

describe('checkInstallments', () => {
  const clean = ['الدفعة الأولى : قيمتها 30 % تسدد عند التعاقد', 'الدفعة الثانية : قيمتها 30 % عند التسليم', 'الدفعة الثالثة : قيمتها 40 % عند الاستلام'].join('\n');

  it('يقرأ النسب الواضحة ويجمعها', () => {
    expect(checkInstallments(clean)).toEqual({ percentages: [30, 30, 40], reconstructed: false, sum: 100 });
  });

  it('يتسامح مع تشوّه علامة % فى القراءة الآلية ويعلّم ذلك', () => {
    const garbled = ['الدفعة الأولى : قيمتها 30 9 تسدد عند التعاقد', 'الدفعة الثانية : قيمتها 30 90 عند التسليم', 'الدفعة الثالثة : قيمتها 9040 عند الاستلام'].join('\n');
    expect(checkInstallments(garbled)).toMatchObject({ percentages: [30, 30, 40], reconstructed: true, sum: 100 });
  });

  it('يُرجع null لدفعة واحدة فقط', () => {
    expect(checkInstallments('الدفعة الأولى : قيمتها 100 % عند التعاقد')).toBeNull();
  });
});

describe('numericWarnings', () => {
  it('يحذّر حين لا يبلغ مجموع الدفعات 100%', () => {
    const t = ['الدفعة الأولى : قيمتها 30 % عند التعاقد', 'الدفعة الثانية : قيمتها 30 % عند التسليم', 'الدفعة الثالثة : قيمتها 30 % عند الاستلام'].join('\n');
    const w = numericWarnings(t);
    expect(w).toHaveLength(1);
    expect(w[0]).toContain('90%');
  });

  it('صامت على عقد سليم', () => {
    const t = ['الدفعة الأولى : قيمتها 50 % عند التعاقد', 'الدفعة الثانية : قيمتها 50 % عند التسليم'].join('\n');
    expect(numericWarnings(t)).toEqual([]);
    expect(numericWarnings('')).toEqual([]);
  });
});
