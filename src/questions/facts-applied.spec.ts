import {
  collectProseForGate,
  parseStructuredAnswer,
  renderStructuredAsText,
  sameArticleWarning,
  toRawSchema,
  MAX_FACTS_APPLIED,
  type StructuredAnswer,
} from './structured-answer';
import { parseClarificationFacts, extractClarificationAnswers } from './clarification';

const ART_87 = 'يبرم عقد العمل الفردى لمدة غير محددة،أو لمدة محددة إذا كانت طبيعة العمل تقتضى ذلك.';
const ART_165 =
  'يستحق العامل تعويضاً لا يقل عن أجر شهرين عن كل سنة من سنوات الخدمة إذا أنهى صاحب العمل العقد لسبب غير مشروع.';
const ARTS = [
  { text: ART_87, articleNo: 87 },
  { text: ART_165, articleNo: 165 },
];
const FACTS = '- كم مدة خدمتك؟ ← 12 سنوات\n- هل العمل مستمر بطبيعته؟ ← نعم، العمل مستمر بطبيعته';
const base = {
  direct_answer: 'المسار الأقوى: العمل مستمر بطبيعته فيُعدّ العقد غير محدد المدة.',
  rulings: [{ claim: 'يبرم عقد العمل لمدة غير محددة أو محددة إذا اقتضت طبيعة العمل ذلك.', kind: 'تفسير', source: 1 }],
  open_issues: [],
  warnings: [],
  facts_to_confirm: [],
  not_covered: [],
};
const opts = { factsText: extractClarificationAnswers(`س\n\n[توضيحات السائل]\n${FACTS}`), answeredFacts: parseClarificationFacts(FACTS) };

describe('facts_applied — تطبيق وقائع السائل', () => {
  it('يُقبل بند «واقعة ← أثر» مسنداً لمادة، ويُحسب المبلغ المشتق (12 سنة × شهرين = 24 شهراً)', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({
        ...base,
        facts_applied: [
          { fact: 'مدة الخدمة 12 سنة', effect: 'تعويض لا يقل عن 24 شهراً من الأجر', source: 2 },
          { fact: 'العمل مستمر بطبيعته', effect: 'العقد غير محدد المدة بحسب المادة 87', source: 1 },
        ],
      }),
      ARTS,
      opts,
    );
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.facts_applied).toHaveLength(2);
    expect(r.value.facts_applied?.[0]).toMatchObject({ citation_index: 1 });
  });

  it('مقدار ملفَّق (30 شهراً) وأثر شديد بلا أصل (سقوط) يُسقطان، ويُسجَّل السبب', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({
        ...base,
        facts_applied: [
          { fact: 'مدة الخدمة 12 سنة', effect: 'تعويض 30 شهراً من الأجر', source: 2 },
          { fact: 'العمل مستمر بطبيعته', effect: 'يسقط حقك بالتقادم', source: 1 },
          { fact: 'مدة الخدمة 12 سنة', effect: 'تعويض 24 شهراً من الأجر', source: 2 },
        ],
      }),
      ARTS,
      opts,
    );
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.facts_applied).toHaveLength(1);
    expect(r.value.facts_applied?.[0].effect).toContain('24');
    expect(r.stats.guard_details.filter((d) => d.startsWith('facts_applied'))).toHaveLength(2);
  });

  it('خارج وضع الوقائع (بلا factsText) يُتجاهل facts_applied كلياً', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({ ...base, facts_applied: [{ fact: 'واقعة ما', effect: 'أثر ما بحسب النص', source: 1 }] }),
      ARTS,
    );
    expect(r.ok && r.value.facts_applied).toBeUndefined();
  });

  it('يُحدّ بـ6 ويُزال المكرر', () => {
    const items = Array.from({ length: 9 }, (_, i) => ({ fact: `واقعة رقم ${i}`, effect: `أثر العقد غير محدد المدة ${i}`, source: 1 }));
    const r = parseStructuredAnswer(JSON.stringify({ ...base, facts_applied: [...items, items[0]] }), ARTS, opts);
    expect(r.ok && r.value.facts_applied).toHaveLength(MAX_FACTS_APPLIED);
    expect(MAX_FACTS_APPLIED).toBe(6);
  });

  it('يدخل فى بوابة الهلوسة ويُعرَض قسماً مستقلاً بعنوان «تطبيق على وقائعك»', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({ ...base, facts_applied: [{ fact: 'العمل مستمر بطبيعته', effect: 'العقد غير محدد المدة', source: 1 }] }),
      ARTS,
      opts,
    );
    if (!r.ok) throw new Error('parse');
    expect(collectProseForGate(r.value)).toContain('العمل مستمر بطبيعته');
    const cites = [
      { articleNo: 87, lawTitle: 'ق', lawNo: 14, lawYear: 2025, sourceStatus: 'ساري' as const },
      { articleNo: 165, lawTitle: 'ق', lawNo: 14, lawYear: 2025, sourceStatus: 'ساري' as const },
    ];
    const text = renderStructuredAsText(r.value, cites as never);
    expect(text).toContain('تطبيق على وقائعك');
    expect(text).toContain('العقد غير محدد المدة (المادة 87)');
    expect(text.indexOf('تطبيق على وقائعك')).toBeGreaterThan(text.indexOf('الجواب المباشر'));
  });
});

describe('facts_to_confirm — لا يُسأل السائل عما أجاب', () => {
  it('تُحذف الوقائع المُجاب عنها وتبقى غير المُجاب عنها وما أجاب عنه بـ«لا أعرف»', () => {
    const facts = parseClarificationFacts(
      '- هل العمل مستمر بطبيعته؟ ← نعم\n- هل الإخطار كان مكتوباً؟ ← لا يعرف (غطِّ الاحتمالات المختلفة فى السيناريوهات)',
    );
    const r = parseStructuredAnswer(
      JSON.stringify({
        ...base,
        facts_to_confirm: ['هل العمل مستمر بطبيعته؟', 'هل الإخطار كان مكتوباً؟', 'هل لديك نسخة من العقد؟'],
      }),
      ARTS,
      { factsText: 'نعم', answeredFacts: facts },
    );
    // 2i: فى وضع الوقائع لا يبقى إلا ما يخص واقعة «لا أعرف»؛ سؤال لم يُطرح أصلاً («نسخة من العقد») يُحذف أيضاً.
    expect(r.ok && r.value.facts_to_confirm).toEqual(['هل الإخطار كان مكتوباً؟']);
  });

  it('2i: أسئلة معاد صياغتها عن وقائع أُجيب عنها (المدة، طبيعة العمل، المبرر) تُحذف حتى لو فشل التطابق المعجمى', () => {
    const facts = parseClarificationFacts(
      '- ما إجمالى مدة خدمتك لدى صاحب العمل؟ ← أكثر من 5 سنوات\n' +
        '- هل طبيعة عملك تقتضى تحديد مدة للعقد؟ ← لا، العمل مستمر بطبيعته\n' +
        '- هل كان لدى صاحب العمل مبرر مشروع للإنهاء؟ ← لا',
    );
    const r = parseStructuredAnswer(
      JSON.stringify({
        ...base,
        facts_to_confirm: [
          'هل كانت المدة الإجمالية للعقد محدد المدة تزيد على خمس سنوات؟',
          'هل العمل بطبيعته يقتضى تحديد المدة؟',
          'هل تم الإنهاء من جانب صاحب العمل مع مبرر مشروع أم لا؟',
        ],
      }),
      ARTS,
      { factsText: 'أكثر من 5 سنوات', answeredFacts: facts },
    );
    expect(r.ok && r.value.facts_to_confirm).toEqual([]);
  });

  it('2i: المسار العادى بلا وقائع استيضاح لا يتغير (يُحذف المكرر فقط ويبقى غيره)', () => {
    const r = parseStructuredAnswer(
      JSON.stringify({ ...base, facts_to_confirm: ['هل لديك نسخة من العقد؟'] }),
      ARTS,
    );
    expect(r.ok && r.value.facts_to_confirm).toEqual(['هل لديك نسخة من العقد؟']);
  });
});

describe('sameArticleWarning — التنبيه المكرر', () => {
  it('صياغتان لحظر النزول عن الإخطار فى المادة نفسها = مكرران', () => {
    expect(
      sameArticleWarning(
        'لا يجوز لصاحب العمل التنازل عن شرط الإخطار الكتابى (المادة 161).',
        'شرط الإخطار الكتابى لا يجوز التنازل عنه ولا الاتفاق على خلافه (المادة 161).',
      ),
    ).toBe(true);
  });
  it('مادتان مختلفتان أو موضوعان مختلفان فى المادة نفسها = غير مكررين', () => {
    expect(sameArticleWarning('ميعاد صرف المستحقات سبعة أيام (المادة 108).', 'ميعاد صرف المستحقات سبعة أيام (المادة 125).')).toBe(false);
    expect(sameArticleWarning('الإخطار الكتابى واجب (المادة 161).', 'تبطل المخالصة خلال ثلاثة أشهر (المادة 161).')).toBe(false);
  });
});

describe('toRawSchema — المسودة المعروضة على المصحِّح', () => {
  it('يحوّل الفهارس إلى أرقام نصوص (1..N) ويحتفظ بـfacts_applied', () => {
    const s: StructuredAnswer = {
      direct_answer: 'جواب',
      facts_applied: [{ fact: 'ف', effect: 'أثر', citation_index: 1 }],
      rulings: [{ claim: 'حكم', kind: 'نص', citation_index: 0, quote: 'مقتطف', quote_verified: true }],
      scenarios: [{ condition: 'ش', outcome: 'ن', citation_index: 1 }],
      open_issues: ['م'],
      warnings: ['ت'],
      facts_to_confirm: [],
      not_covered: [],
    };
    const raw = toRawSchema(s) as Record<string, Array<Record<string, unknown>>>;
    expect(Object.keys(raw)[0]).toBe('facts_applied');
    expect(raw.facts_applied[0].source).toBe(2);
    expect(raw.rulings[0]).toEqual({ claim: 'حكم', kind: 'نص', source: 1, quote: 'مقتطف' });
    expect(raw.scenarios[0].source).toBe(2);
  });
});
