import { amountConflictWarnings, extractKeyTerms } from './key-terms';
import { definesDuration, deterministicFindings } from './contract-level';
import { normalizeArabicForMatch } from './reasoning.util';

/**
 * الجولة 55: عقدان ممسوحان حقيقيان (إيجار مخزن 0176 وإطار تحصيل 0174). النصوص أدناه مقتطفات من القراءة الآلية الفعلية للأصل (Tesseract)
 * أو من تقرير الإنتاج، بتشوّهاتها.
 */
const clause = (i: number, text: string) => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null as string | null, clauseText: text });
const n = (s: string) => normalizeArabicForMatch(s);

// بند 3 كما قرأه المسح: «خم سنوات» و«وتنتهى» رموز لاتينية
const LEASE_3 =
  'اتفق الطرفان على ان تكون مدة هذا العقد خم سنوات ميلادية تبدأ من 1 / 6 / 2019 ths فى 1/ 6 / 2024 » ويجوز تجديد هذا العقد لمدد ممائلة باتفاق الطرفان » كما اتفق االطرفان على زيادة وقدرها 9010 Lyin على ان تطبق بداية من 1 / 6 / 2020 .';
// بند 4: حروف مشوّهة ثم حدّ صفحة يقطع «ثلاث عشر | الف وخمسمائة»
const LEASE_4 =
  'اتفق الطرفان على أن تكون القيمة الايجارية الشهرية للعين المؤجرة مبلغ 4500 جنيه ( اربعة آلاف سم ال ل ل 3 وخمسمائة جنيه مصرى فقط لاغير ) تدفع كل ثلاث أشهر باجمالى قيمته 13500 جنيه ( ثلاث عشر\nES\n2S\n—\n2 الف وخمسمائة جنيه مصرى فقط لاغير ) وتدفع مقدما الى يد الطرف الأول المؤجر فى موعد أقصاه اليوم الخامس عشر من الشهر الأول.';

describe('الجولة 55: كاشف المدة يتحمل تشوه المسح', () => {
  it('«خم سنوات ميلادية تبدأ من 1/6/2019 ths 1/6/2024» تعرّف مدة', () => {
    expect(definesDuration(n(LEASE_3))).toBe(true);
  });

  it('نطاق تاريخين بلا كلمة عدد ولا وحدة مقروءة يكفى', () => {
    expect(definesDuration(n('مدة هذا العقد XX تبدأ من 1 / 6 / 2019 وحتى 1 / 6 / 2024'))).toBe(true);
  });

  it('«ثلا سنوات» و«خم سنوات» كلتاهما بوحدة مقروءة', () => {
    expect(definesDuration(n('مدة هذا العقد ثلا سنوات من تاريخ التوقيع'))).toBe(true);
  });

  it('مهلة الإخطار ليست مدة العقد: «قبل انتهاء مدة هذا العقد بشهرين»', () => {
    expect(definesDuration(n('يخطر الطرف الثانى الطرف الاول قبل انتهاء مدة هذا العقد بشهرين'))).toBe(false);
  });

  it('تاريخان بلا عبارة بدء أو مدة لا يُعدّان مدة (تاريخ توقيع وتاريخ سداد)', () => {
    expect(definesDuration(n('حرر هذا العقد فى 1/6/2019 ويسدد المبلغ فى 1/7/2020 للعقد'))).toBe(false);
  });
});

describe('الجولة 55: ادعاء الغياب على نص ممسوح يُوسم غير مؤكد', () => {
  const refs = [
    clause(1, 'يلتزم الطرف الاول بتسليم العين المؤجرة للطرف الثانى فى مكان العقار وفق الاصول.'),
    clause(2, 'يجوز للطرف الثانى انهاء العقد قبل انتهاء مدة هذا العقد باخطار مسبق مدته شهرين الى الطرف الاول.'),
    clause(3, 'اتفق الطرفان على الاتى بخصوص القيمة الايجارية والتزامات الطرفين وحدود الانتفاع بالعين المؤجرة.'),
  ];

  it('عقد ممسوح بتحذيرات قراءة: «مدة غير معرفة» تُوسم غير مؤكدة (مرشحة) بسبب مذكور', () => {
    const f = deterministicFindings(refs as never, { contractType: 'عقد إيجار', textMayBeIncomplete: true });
    const d = f.find((x) => x.id === 'undefined:duration')!;
    expect(d).toBeDefined();
    expect(d.severity).toBe('عالٍ');
    expect(d.verification?.status).toBe('unconfirmed');
    expect(d.verification?.reason).toMatch(/صورة ممسوحة/);
  });

  it('عقد نصى سليم: الادعاء يبقى مؤكداً (لا إفراط فى التساهل)', () => {
    const f = deterministicFindings(refs as never, { contractType: 'عقد إيجار', textMayBeIncomplete: false });
    const d = f.find((x) => x.id === 'undefined:duration')!;
    expect(d.verification ?? null).toBeNull();
  });

  it('مع المدة المقروءة بتشوه («خم سنوات…») لا يُصدر ادعاء الغياب أصلاً', () => {
    const f = deterministicFindings([...refs.slice(0, 2), clause(3, LEASE_3)] as never, { contractType: 'عقد إيجار', textMayBeIncomplete: true });
    expect(f.some((x) => x.id === 'undefined:duration' || x.id === 'missing:duration')).toBe(false);
  });
});

describe('الجولة 55: جدول الشروط على بنود عقد الإيجار الممسوح', () => {
  const terms = extractKeyTerms([clause(3, LEASE_3), clause(4, LEASE_4)]);
  const byKind = (k: string) => terms.filter((t) => t.kind === k);

  it('المدة 5 سنوات تظهر بتنبيه كلمة عدد مشوّهة', () => {
    const d = byKind('duration').find((t) => t.value.startsWith('5 '));
    expect(d).toBeDefined();
    expect(d!.suspect).toMatch(/خم/);
  });

  it('تواريخ البدء والانتهاء المفصولة بمسافات تُقرأ', () => {
    const vals = byKind('date').map((t) => t.value);
    expect(vals).toEqual(expect.arrayContaining(['1/6/2019', '1/6/2024', '1/6/2020']));
  });

  it('الإيجار الشهرى 4,500 لا يُستبدل بـ500 من حروف مشوّهة؛ المعروض الرقم مع تنبيه', () => {
    const amounts = byKind('amount');
    expect(amounts.some((t) => t.value === '500 جنيه')).toBe(false);
    const rent = amounts.find((t) => t.value === '4,500 جنيه');
    expect(rent).toBeDefined();
    expect(rent!.suspect).toMatch(/مشوّهة/);
  });

  it('ذيل «الف وخمسمائة» عبر حدّ الصفحة لا يظهر 1,500 مستقلاً؛ 13,500 قائم', () => {
    const amounts = byKind('amount');
    expect(amounts.some((t) => t.value === '1,500 جنيه')).toBe(false);
    expect(amounts.some((t) => t.value === '13,500 جنيه')).toBe(true);
  });

  it('تنبيه على مستوى العقد بدل الصف المحذوف', () => {
    const w = amountConflictWarnings([LEASE_4]);
    expect(w.some((x) => /جزء من مبلغ مكتوب بالحروف/.test(x))).toBe(true);
  });

  it('لا انحدار: «ألف وخمسمائة» مستقلة فى جملة سليمة تبقى مبلغاً 1,500', () => {
    const t = extractKeyTerms([clause(1, 'يسدد المستأجر مبلغ ألف وخمسمائة جنيه مصرى فقط لاغير عند التوقيع.')]);
    expect(t.some((x) => x.value === '1,500 جنيه')).toBe(true);
  });

  it('لا انحدار: رقم صغير ضجيج قبل مبلغ بالحروف «( 1 خمسمائة الف جنيها )»', () => {
    const t = extractKeyTerms([clause(1, 'قيمة العقد مبلغ ( 1 خمسمائة الف جنيها ) تسدد عند التوقيع.')]);
    expect(t.some((x) => x.value === '500,000 جنيه')).toBe(true);
  });
});

describe('الجولة 55: شرح النموذج يسمّى البند بعنوانه لا بموضعه', () => {
  // عقد ممسوح سقطت عناوين بعض بنوده: الموضع 4 = «البند الخامس»
  const cls = [
    { clauseIndex: 3, clauseLabel: 'البند الثالث', clauseTitle: null, clauseText: 'الخدمات التى سيوفرها مقدم الخدمة للعميل من خلال الشبكة.' },
    { clauseIndex: 4, clauseLabel: 'البند الخامس', clauseTitle: null, clauseText: 'اتفق الطرفان على انه وبعد التوصل لاتفاق حول مستوى الخدمة وخطة المشروع يجب على الطرفين توقيع الملاحق.' },
  ];
  const { validateModelFindings } = jest.requireActual('./contract-level') as typeof import('./contract-level');

  it('«البند 4» يصير «البند الخامس» إذا كان 4 موضع بند مستشهَد به', () => {
    const out = validateModelFindings(
      {
        findings: [
          {
            kind: 'open_term',
            severity: 'متوسط',
            title: 'شرط مفتوح',
            explanation: 'يترك البند 4 مستويات الخدمة لاتفاق لاحق دون موعد.',
            evidence: [{ clause_index: 4, quote: 'بعد التوصل لاتفاق حول مستوى الخدمة وخطة المشروع' }],
          },
        ],
      },
      cls,
    );
    expect(out[0].explanation).toContain('البند الخامس');
    expect(out[0].explanation).not.toMatch(/البند 4/);
  });

  it('رقم بند غير مستشهَد به يُترك كما كتبه النموذج', () => {
    const out = validateModelFindings(
      {
        findings: [
          {
            kind: 'open_term',
            severity: 'متوسط',
            title: 'شرط مفتوح',
            explanation: 'يحيل البند 9 إلى مرفق، ويترك مستويات الخدمة لاتفاق لاحق.',
            evidence: [{ clause_index: 4, quote: 'بعد التوصل لاتفاق حول مستوى الخدمة وخطة المشروع' }],
          },
        ],
      },
      cls,
    );
    expect(out[0].explanation).toContain('البند 9');
  });
});
