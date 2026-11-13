import { SegmentationService, recoverHeadsFromIsolatedShortLines } from './segmentation.service';
import { extractKeyTerms } from './key-terms';
import { contractFamily } from './contract-level';
import { articleInLawScope, lawScopeContext } from './law-scope';
import { isGarbledNumberWord } from './numeric-checks.util';

const P = (s: string) => `${s} يلتزم الطرف الثانى بتقديم كافة المستندات والبيانات والمعلومات المطلوبة فور طلبها من الطرف الأول كتابةً.`;
const seg = (t: string) => new SegmentationService().segment(t);
const nums = (t: string) => seg(t).clauses.map((c) => c.declaredNumber);

describe('الجولة 83 — عنوان قُرئ سطراً قصيراً تالفاً (عقد بيع «T P»، وكالة «geil البنسد»)', () => {
  const sale = (garbled: string) =>
    [
      'عقد بيع وحدة إدارية',
      'البند الأول',
      P('أ'),
      '',
      'البند الثانى',
      P('ب'),
      '',
      garbled,
      'اتفق الطرفان على أن يكون ثمن الوحدة المبيعة مبلغ وقدره ستة ملايين وخمسمائة ألف جنيه يسدد على النحو الآتى',
      P('ج'),
      '',
      'البند الرابع',
      P('د'),
      '',
      'البند الخامس',
      P('هـ'),
      '',
      'البند السادس',
      P('و'),
    ].join('\n');

  it('«T P» معزولاً بين الثانى والرابع ⇒ يُسترجع البند الثالث بتحذير، ولا تُنسب دفعات الثمن إلى الثانى', () => {
    const r = seg(sale('T P'));
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6]);
    const third = r.clauses[2];
    expect(third.text).toMatch(/ثمن الوحدة المبيعة/);
    expect(r.clauses[1].text).not.toMatch(/ثمن الوحدة المبيعة/);
    expect(r.warnings.join(' ')).toMatch(/قُرئ سطراً قصيراً تالفاً/);
  });

  it('سطر قصير عربى سليم غير معزول بفراغ قبله ⇒ لا استرجاع (فشل آمن)', () => {
    const t = sale('مع التحية').replace('\n\nمع التحية\n', '\nمع التحية\n');
    expect(seg(t).warnings.join(' ')).not.toMatch(/سطراً قصيراً تالفاً/);
  });

  it('رقم صفحة أو سطر أرقام ورموز ليس عنواناً', () => {
    // الاسترجاع بعنوان «سطر قصير تالف» لا يعمل (يبقى فاصل الفقرات الجولة 82 وحده، بتحذيره)
    for (const g of ['- 3 -', '129 7 - 10 . «te']) expect(seg(sale(g)).warnings.join(' ')).not.toMatch(/قُرئ سطراً قصيراً تالفاً/);
  });

  it('ترويسة لاتينية خالصة («Office Supplies») ليست عنواناً', () => {
    expect(seg(sale('Office Supplies')).warnings.join(' ')).not.toMatch(/قُرئ سطراً قصيراً تالفاً/);
  });

  it('أكثر من مرشح واحد لرقم ناقص واحد ⇒ لا تغيير', () => {
    const heads = [
      { lineStart: 0, markerStart: 0, marker: 'البند الأول', rawLength: 11, declaredNumber: 1 },
      { lineStart: 400, markerStart: 400, marker: 'البند الثالث', rawLength: 12, declaredNumber: 3 },
      { lineStart: 800, markerStart: 800, marker: 'البند الرابع', rawLength: 12, declaredNumber: 4 },
    ];
    const body = 'متن طويل يكفى كى يكون بنداً حقيقياً فى النص التجريبى هذا بلا أى لبس '.repeat(3);
    const text = `البند الأول\n${body}\n\nAB\n${body}\n\nCD\n${body}\n${'x'.repeat(100)}`;
    const h2 = [heads[0], { ...heads[1], lineStart: text.length - 120, markerStart: text.length - 120 }, { ...heads[2], lineStart: text.length - 60, markerStart: text.length - 60 }];
    expect(recoverHeadsFromIsolatedShortLines(text, h2).recovered).toEqual([]);
  });

  it('وكالة: «geil البنسد» (لاتينى قصير + كلمة عربية مشوَّهة) بين السابع والتاسع ⇒ البند الثامن', () => {
    const t = [
      'عقد وكالة',
      ...[1, 2, 3, 4, 5, 6, 7].flatMap((n) => [`البند ${['الأول', 'الثانى', 'الثالث', 'الرابع', 'الخامس', 'السادس', 'السابع'][n - 1]}`, P(String(n)), '']),
      'geil البنسد',
      'اتفق الطرفان على أن يلتزم الوكيل بتحصيل الأقساط المستحقة عن الوثائق وتوريدها للطرف الأول فى المواعيد المحددة.',
      '',
      'البند التاسع',
      P('ط'),
      '',
      'البند العاشر',
      P('ي'),
    ].join('\n');
    expect(nums(t)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });
});

describe('الجولة 83 — «البند-الثانى» بشرطة', () => {
  it('الشرطة بين «البند» وترتيبيه عنوان صحيح ولا يضيع حين تحلّ المطابقة التقريبية محل الحرفى', () => {
    const t = [
      'عقد إيجار ماكينة تصوير',
      'اليند الاول',
      P('أ'),
      '',
      'البند-الثانى',
      P('ب'),
      '',
      'البند الثالث',
      P('ج'),
      '',
      'البند اللرابع',
      P('د'),
      '',
      'البند الخامس',
      P('هـ'),
    ].join('\n');
    expect(nums(t)).toEqual([1, 2, 3, 4, 5]);
    expect(seg(t).clauses[1].label).toBe('البند الثانى');
  });
});

describe('الجولة 83 — المبالغ: «800 الف» والمضاعف', () => {
  const amounts = (text: string) => extractKeyTerms([{ clauseIndex: 0, clauseLabel: 'البند السابع عشر', clauseTitle: null, clauseText: text }], { ocrRead: true }).filter((k) => k.kind === 'amount');

  it('«800 الف جنيها ( ثمانمائة الف جنيها )» = 800,000 بلا تعارض كاذب مع 1,000', () => {
    const a = amounts('والتبكير لكل 800 الف جنيها\n\n( ثمانمائة الف جنيها ) من صافى الاصدارت');
    expect(a.map((x) => x.value)).toEqual(['800,000 جنيه']);
    expect(a[0].suspect).toBeUndefined();
  });

  it('كلمة المئات تالفة («ثمائمائة الف»): لا يُعرض 1,000 مكتوباً بالحروف؛ يبقى 800,000 بتنبيه «طابق الأصل»', () => {
    const a = amounts('والتبكير لكل 800 الف جنيها\n\n( ثمائمائة الف جنيها ) من صافى الاصدارت');
    expect(a.map((x) => x.value)).toEqual(['800,000 جنيه']);
    expect(a[0].suspect).toMatch(/طابق الأصل/);
    expect(a[0].suspect).not.toMatch(/تعارض/);
  });

  it('«5 ملايين جنيه» = 5,000,000', () => {
    expect(amounts('مبلغ 5 ملايين جنيه مصرى').map((x) => x.value)).toEqual(['5,000,000 جنيه']);
  });

  it('شظية «2 الف وخمسمائة جنيه» لا تُضرب (مركّبة)', () => {
    expect(amounts('ثلاث عشر\nضجيج 2 الف وخمسمائة جنيه').some((x) => x.value === '2,000 جنيه')).toBe(false);
  });

  it('كلمة عددية تالفة تُعرف، والكلمة العادية لا', () => {
    expect(isGarbledNumberWord('ثمائمائة')).toBe(true);
    expect(isGarbledNumberWord('ثمانمائة')).toBe(false);
    expect(isGarbledNumberWord('مبلغ')).toBe(false);
    expect(isGarbledNumberWord('وقدره')).toBe(false);
  });
});

describe('الجولة 83 — نوع عقد الحراسة والقانون الحاكم', () => {
  it('«عقد خدمات امنية وحراسة» خدمات لا وديعة', () => {
    expect(contractFamily('عقد خدمات امنية وحراسة')).toBe('services');
    expect(contractFamily('عقد حراسة منشآت')).toBe('services');
    expect(contractFamily('عقد وديعة وحراسة')).toBe('deposit');
  });

  const cand = (lawNo: number, lawYear: number) => ({ lawNo, lawYear });
  it('قوانين الإيجار (49/1977 و136/1981 و164/2025) لا تُعرض إلا على عقد إيجار (قرار المالك)، لا على بيع ولا خدمات ولا أسرة مجهولة', () => {
    const txt = 'العين مؤجرة بقانون الإيجار القديم 49 لسنة 1977 والقانون 136 لسنة 1981 والقانون 164 لسنة 2025';
    for (const law of [cand(49, 1977), cand(136, 1981), cand(164, 2025)]) {
      expect(articleInLawScope(lawScopeContext('عقد بيع وحدة إدارية بين البائع والمشترى', 'sale'), law)).toBe(false);
      expect(articleInLawScope(lawScopeContext(txt, 'sale'), law)).toBe(false);
      expect(articleInLawScope(lawScopeContext(txt, 'services'), law)).toBe(false);
      expect(articleInLawScope(lawScopeContext(txt, null), law)).toBe(false);
    }
    // الجولة 90 (قرار المالك): 49/1977 و136/1981 لا يسريان على عقد إيجار جديد (يحكمه المدنى بعد القانون 4/1996)؛ فلا يكفى أن يكون العقد إيجاراً، بل يلزم مؤشر علاقة قديمة فى النص
    expect(articleInLawScope(lawScopeContext('عقد إيجار مكتب بين المؤجر والمستأجر', 'lease'), cand(49, 1977))).toBe(false);
    expect(articleInLawScope(lawScopeContext('عقد إيجار مكتب بين المؤجر والمستأجر', 'lease'), cand(136, 1981))).toBe(false);
    expect(articleInLawScope(lawScopeContext(txt, 'lease'), cand(49, 1977))).toBe(true);
    expect(articleInLawScope(lawScopeContext(txt, 'lease'), cand(136, 1981))).toBe(true);
    // 164/2025 يبقى مشروطاً بمؤشر الإيجار القديم حتى على عقد الإيجار (الجولة 69)
    expect(articleInLawScope(lawScopeContext('عقد إيجار مكتب حديث', 'lease'), cand(164, 2025))).toBe(false);
    expect(articleInLawScope(lawScopeContext(txt, 'lease'), cand(164, 2025))).toBe(true);
  });

  it('قانون العمل 14/2025 ومواد عقد العمل فى المدنى (674-698): لعقد العمل، أو لعقد نصّ صراحةً على قانون العمل أو علاقة عمل؛ لا لمجرد ذكر «عامل» فى عقد حراسة', () => {
    const guard = 'عقد خدمات أمنية وحراسة بين شركتين؛ يلتزم الطرف الأول بسداد قيمة اثنى عشر شهراً عن كل عامل يقوم بتوظيفه ويكون عدد الأفراد كما بالجدول';
    const labor = { lawNo: 14, lawYear: 2025 };
    const civilWork = { lawNo: 131, lawYear: 1948, articleNo: 685 };
    const civilOther = { lawNo: 131, lawYear: 1948, articleNo: 217 };
    expect(articleInLawScope(lawScopeContext(guard, 'services'), labor)).toBe(false);
    expect(articleInLawScope(lawScopeContext(guard, 'services'), civilWork)).toBe(false);
    expect(articleInLawScope(lawScopeContext(guard, null), labor)).toBe(false);
    expect(articleInLawScope(lawScopeContext(guard, 'services'), civilOther)).toBe(true);
    expect(articleInLawScope(lawScopeContext('عقد عمل بين صاحب العمل والعامل', 'employment'), labor)).toBe(true);
    expect(articleInLawScope(lawScopeContext('عقد عمل بين صاحب العمل والعامل', 'employment'), civilWork)).toBe(true);
    expect(articleInLawScope(lawScopeContext('عقد مقاولة يخضع لأحكام قانون العمل فيما يخص عمال المقاول', 'services'), labor)).toBe(true);
    expect(articleInLawScope(lawScopeContext('عقد مقاولة يخضع لأحكام قانون العمل فيما يخص عمال المقاول', 'services'), civilWork)).toBe(true);
  });

  it('قانون المحاماة 17/1983 لا يُعرض على عقد إيجار بلا ذكر محام، ويُعرض على عقد أتعاب', () => {
    expect(articleInLawScope(lawScopeContext('عقد إيجار مكتب بين المؤجر والمستأجر', 'lease'), cand(17, 1983))).toBe(false);
    expect(articleInLawScope(lawScopeContext('اتفاق أتعاب بين المحامى وموكله', 'services'), cand(17, 1983))).toBe(true);
  });

  it('قانون التجارة 17/1999 محجوب عن الإيجار بلا إشارة تجارية، ومقبول لغير الإيجار والأسرة المجهولة', () => {
    expect(articleInLawScope(lawScopeContext('عقد إيجار مكتب بين المؤجر والمستأجر', 'lease'), cand(17, 1999))).toBe(false);
    expect(articleInLawScope(lawScopeContext('عقد إيجار محل تحكمه أحكام قانون التجارة', 'lease'), cand(17, 1999))).toBe(true);
    expect(articleInLawScope(lawScopeContext('عقد توريد بضائع', 'services'), cand(17, 1999))).toBe(true);
    expect(articleInLawScope(lawScopeContext('عقد توريد بضائع', null), cand(17, 1999))).toBe(true);
  });

  it('قانون سوق رأس المال ولائحته 135/1993 محجوبان عن عقد إيجار بلا نشاط سوق مال', () => {
    const lease = lawScopeContext('عقد إيجار مكتب بين المؤجر والمستأجر', 'lease');
    expect(articleInLawScope(lease, cand(135, 1993))).toBe(false);
    expect(articleInLawScope(lease, cand(95, 1992))).toBe(false);
    expect(articleInLawScope(lawScopeContext('عقد إدارة صندوق استثمار وفق قانون سوق رأس المال', 'services'), cand(95, 1992))).toBe(true);
  });
});
