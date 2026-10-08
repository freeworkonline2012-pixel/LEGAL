import { ANSWER_CHECKLIST, ANSWER_CHECKLIST_TEXT, FIXED_RIGHTS_ARTICLES, applyChecklist } from './answer-checklist';
import type { StructuredAnswer } from './structured-answer';

/**
 * اختبارات الانحدار لقائمة الفحص الثابتة: كل حالة هنا خطأ سبق وقوعه فى تقييم حى (8 ← 7.5 ← 7) ولا يجوز أن يعود
 * حين تُعدَّل القواعد أو التعليمات.
 */

const A87 = 'يبرم عقد العمل الفردى لمدة غير محددة، أو لمدة محددة إذا كانت طبيعة العمل تقتضى ذلك.';
const A88 = 'يعتبر العقد غير محدد المدة منذ إبرامه فى الحالات الثلاث: عدم الكتابة، أو الاستمرار بعد انتهاء المدة.';
const A108 = 'يلتزم صاحب العمل بأداء الأجور والمستحقات خلال سبعة أيام من تاريخ مطالبة العامل بها عند انتهاء العلاقة.';
const A125 = 'يستحق العامل مقابل رصيد إجازاته السنوية عند انتهاء علاقة العمل. ويصرف له عند التسوية.';
const A157 = 'لا يجوز إنهاء العقد غير محدد المدة إلا لمبرر مشروع وكاف.';
const A161 = 'لا يجوز لصاحب العمل الإعفاء من شرط الإخطار الكتابى فى العقد غير محدد المدة أو تخفيض مدته.';
const A150 = 'تحال المنازعة إلى المحكمة العمالية، وتفصل فى طلب فصل العامل على وجه الاستعجال.';

const ARTS = [
  { articleNo: 87, text: A87 },
  { articleNo: 88, text: A88 },
  { articleNo: 108, text: A108 },
  { articleNo: 125, text: A125 },
  { articleNo: 157, text: A157 },
  { articleNo: 161, text: A161 },
  { articleNo: 150, text: A150 },
];
const idx = (no: number) => ARTS.findIndex((a) => a.articleNo === no);

const base = (over: Partial<StructuredAnswer> = {}): StructuredAnswer => ({
  direct_answer: 'فى حالتك، العقد غير محدد المدة (المادة 87).',
  rulings: [
    { claim: 'يبرم عقد العمل لمدة غير محددة، أو محددة إذا اقتضت طبيعة العمل.', kind: 'نص', citation_index: idx(87), quote: A87, quote_verified: true },
  ],
  scenarios: [],
  open_issues: [],
  warnings: [],
  facts_to_confirm: [],
  not_covered: [],
  ...over,
});

describe('قائمة الفحص الثابتة — النص المحقون', () => {
  it('ثمانية بنود C1..C8 ونصها يحوى كلها', () => {
    expect(ANSWER_CHECKLIST.map((c) => c.id)).toEqual(['C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8']);
    for (const c of ANSWER_CHECKLIST) expect(ANSWER_CHECKLIST_TEXT).toContain(c.rule);
  });
  it('الحقوق الثابتة تشمل المخالصة والأجر والإجازات والشهادة والتسوية والمحكمة', () => {
    expect([...FIXED_RIGHTS_ARTICLES].sort((a, b) => a - b)).toEqual([6, 108, 125, 149, 150, 175]);
  });
});

describe('C1: المادة 161 تخص العقد غير محدد المدة', () => {
  it('تنبيه «فى العقد محدد المدة فقط» يُصحَّح', () => {
    const r = applyChecklist(
      base({ warnings: ['فى العقد محدد المدة فقط: لا يجوز الإعفاء من شرط الإخطار الكتابى (المادة 161).'] }),
      ARTS,
      { duesMode: false },
    );
    expect(r.value.warnings[0]).toContain('فى العقد غير محدد المدة فقط');
    expect(r.value.warnings[0]).not.toMatch(/العقد محدد المدة فقط/);
    expect(r.fixes.some((f) => f.startsWith('C1'))).toBe(true);
  });
  it('التنبيه الصحيح لا يُمَس', () => {
    const w = 'فى العقد غير محدد المدة فقط: لا يجوز الإعفاء من شرط الإخطار الكتابى (المادة 161).';
    expect(applyChecklist(base({ warnings: [w] }), ARTS, { duesMode: false }).value.warnings).toEqual([w]);
  });
});

describe('C2: مهلة المادة 108 على صاحب العمل', () => {
  it('تنبيه يجعل السبعة أيام على العامل يُسقَط، والصياغة الصحيحة تبقى', () => {
    const bad = 'على العامل الصرف خلال سبعة أيام من مطالبته (المادة 108).';
    const good = 'يطالب العامل كتابةً، وعلى صاحب العمل الصرف خلال سبعة أيام من طلبه (المادة 108).';
    const good2 = 'يجب على العامل المطالبة كتابة، وعلى صاحب العمل الصرف خلال سبعة أيام (المادة 108).';
    const r = applyChecklist(base({ warnings: [bad, good, good2] }), ARTS, { duesMode: false });
    expect(r.value.warnings).toEqual([good, good2]);
    expect(r.fixes.some((f) => f.startsWith('C2'))).toBe(true);
  });
  it('حكم 108 يجعل المهلة على العامل يُسقَط', () => {
    const r = applyChecklist(
      base({
        rulings: [
          ...base().rulings,
          { claim: 'يلتزم العامل بالمطالبة خلال سبعة أيام.', kind: 'تفسير', citation_index: idx(108), quote: null, quote_verified: false },
        ],
      }),
      ARTS,
      { duesMode: false },
    );
    expect(r.value.rulings).toHaveLength(1);
  });
});

describe('C3/C4: الإسناد إلى المادة الصحيحة', () => {
  it('«طبيعة العمل» منسوبة للمادة 88 (لا تذكرها) تُسقَط حكماً وسيناريو؛ ومنسوبة للمادة 87 تبقى', () => {
    const r = applyChecklist(
      base({
        rulings: [
          ...base().rulings,
          { claim: 'يعتبر العقد غير محدد المدة إذا اقتضت طبيعة العمل ذلك.', kind: 'تفسير', citation_index: idx(88), quote: null, quote_verified: false },
        ],
        scenarios: [{ condition: 'كانت طبيعة العمل دائمة', outcome: 'يكون العقد غير محدد المدة', citation_index: idx(88) }],
      }),
      ARTS,
      { duesMode: false },
    );
    expect(r.value.rulings.map((x) => x.citation_index)).toEqual([idx(87)]);
    expect(r.value.scenarios).toHaveLength(0);
  });
  it('حكم موسوم «نص» أضاف «الإخطار» إلى مقتطف المادة 157 يُخفَّض إلى «تفسير»', () => {
    const r = applyChecklist(
      base({
        rulings: [
          {
            claim: 'لا يجوز إنهاء العقد غير محدد المدة إلا لمبرر مشروع مع الإخطار الكتابى قبل الإنهاء بثلاثة أشهر.',
            kind: 'نص',
            citation_index: idx(157),
            quote: A157,
            quote_verified: true,
          },
        ],
      }),
      ARTS,
      { duesMode: false },
    );
    expect(r.value.rulings[0].kind).toBe('تفسير');
    expect(r.value.rulings[0].quote).toBe(A157);
  });
  it('حكم نص سليم يبقى «نص»', () => {
    const r = applyChecklist(base(), ARTS, { duesMode: false });
    expect(r.value.rulings[0].kind).toBe('نص');
  });
  it('تنبيه المادتين 149/150 لا يُقيَّد بنوع العقد', () => {
    const r = applyChecklist(
      base({ warnings: ['فى العقد غير محدد المدة فقط: يُحال النزاع إلى المحكمة العمالية بسرعة استعجالية (المادة 150).'] }),
      ARTS,
      { duesMode: false },
    );
    expect(r.value.warnings[0]).not.toContain('غير محدد المدة فقط');
    expect(r.value.warnings[0]).toContain('المادة 150');
  });
});

describe('C5: الحقوق الثابتة', () => {
  it('عند مستحقات غير مستلمة تُضاف نصوص المواد المرسلة غير المذكورة حرفياً', () => {
    const r = applyChecklist(base(), ARTS, { duesMode: true });
    const added = r.value.rulings.filter((x) => x.citation_index !== idx(87));
    expect(added.map((x) => ARTS[x.citation_index].articleNo).sort((a, b) => a - b)).toEqual([108, 125, 150]);
    for (const x of added) {
      expect(x.kind).toBe('نص');
      expect(x.quote_verified).toBe(true);
      expect(ARTS[x.citation_index].text).toContain((x.quote ?? '').replace(/\.$/, ''));
    }
    // المقتطف جملة أولى كاملة
    const a125 = added.find((x) => ARTS[x.citation_index].articleNo === 125);
    expect(a125?.quote).toBe('يستحق العامل مقابل رصيد إجازاته السنوية عند انتهاء علاقة العمل.');
  });
  it('لا إضافة خارج وضع المستحقات، ولا للمادة المذكورة فى تنبيه', () => {
    expect(applyChecklist(base(), ARTS, { duesMode: false }).value.rulings).toHaveLength(1);
    const r = applyChecklist(base({ warnings: ['يُصرف مقابل رصيد الإجازات عند الانتهاء (المادة 125).'] }), ARTS, { duesMode: true });
    expect(r.value.rulings.some((x) => ARTS[x.citation_index].articleNo === 125)).toBe(false);
  });
});

describe('C8: المسائل المفتوحة المكررة', () => {
  it('مسألة تكرر مضمون أخرى تُحذف', () => {
    const r = applyChecklist(
      base({
        open_issues: [
          'هل يُعد عدم التجديد فصلاً بالمعنى الذى تقصده المادتان 150 و165؟',
          'هل يُعد عدم التجديد فصلاً بالمعنى الذى تقصده المادتان 150 و165 أم لا؟',
          'هل تُجمع التجديدات المتتالية لحساب الخمس سنوات؟',
        ],
      }),
      ARTS,
      { duesMode: false },
    );
    expect(r.value.open_issues).toHaveLength(2);
  });
});
