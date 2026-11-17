import {
  confidentialityAnchorArticleNumbers,
  governingLawAnchorArticleNumbers,
  servicesAnchorArticleNumbers,
} from './criteria.util';

/**
 * الجولة 113: مراسى البنود التعاقدية الشائعة التى كانت تصل إلى النموذج بلا أى نص يحكمها (السرية، القانون الحاكم، الاختصاص القضائى، نطاق الخدمات والتزامات الطرفين).
 * النصوص أدناه صيغ عامة مكتوبة للاختبار لا نقل عن عقد بعينه.
 */
describe('confidentialityAnchorArticleNumbers (الجولة 113)', () => {
  it('بند عدم الإفصاح يُربط بم57 وم55 من 82/2002', () => {
    const r = confidentialityAnchorArticleNumbers(
      'السرية (اتفاقية عدم الإفصاح)',
      'يتعهد الطرفان بالتعامل مع جميع المعلومات المتبادلة على أنها سرية ولا يجوز للطرف المتلقى الإفصاح عنها أو استخدامها لغير غرض العقد.',
    );
    expect(r).toEqual([57, 55]);
  });
  it('صيغ أخرى: إفشاء الأسرار، المعلومات السرية، NDA', () => {
    expect(confidentialityAnchorArticleNumbers(null, 'يمتنع الطرف الثانى عن إفشاء أسرار العمل التجارية للغير.')).toEqual([57, 55]);
    expect(confidentialityAnchorArticleNumbers('Confidentiality', 'يخضع الطرفان لاتفاقية NDA الموقعة بينهما.')).toEqual([57, 55]);
    expect(confidentialityAnchorArticleNumbers(null, 'تلتزم الشركة بحماية المعلومات السرية للعميل.')).toEqual([57, 55]);
  });
  it('بند سداد أو تسليم لا يحمل مراسى السرية', () => {
    expect(confidentialityAnchorArticleNumbers('الرسوم', 'يسدد الطرف الأول الأجر شهرياً خلال ثلاثين يوماً من استلام الفاتورة.')).toEqual([]);
    expect(confidentialityAnchorArticleNumbers('التسليم', 'يسلم المقاول العمل فى الموعد المحدد.')).toEqual([]);
  });
});

describe('governingLawAnchorArticleNumbers (الجولة 113)', () => {
  it('القانون الحاكم ← م19 مدنى وحدها', () => {
    expect(governingLawAnchorArticleNumbers('القانون الحاكم', 'تخضع هذه الاتفاقية وتفسر وفقاً للقانون المصرى.')).toEqual({ civil: [19], econ: [] });
  });
  it('الاختصاص القضائى ← م22 مدنى وم6 من 120/2008', () => {
    expect(governingLawAnchorArticleNumbers('تسوية المنازعات', 'تختص محكمة القاهرة الابتدائية بنظر ما ينشأ من منازعات عن تنفيذ هذا العقد.')).toEqual({ civil: [22], econ: [6] });
  });
  it('بند يجمع القانون الحاكم والاختصاص', () => {
    const r = governingLawAnchorArticleNumbers(
      'القانون الحاكم وتسوية المنازعات',
      'تخضع هذه الاتفاقية لقوانين جمهورية مصر العربية، وتختص المحاكم المختصة بنظر أى نزاع.',
    );
    expect(r.civil).toEqual([19, 22]);
    expect(r.econ).toEqual([6]);
  });
  it('بند لا يتناول القانون ولا الاختصاص يبقى بلا مراسى', () => {
    expect(governingLawAnchorArticleNumbers('الرسوم', 'يسدد العميل الأجر شهرياً.')).toEqual({ civil: [], econ: [] });
    expect(governingLawAnchorArticleNumbers('المدة', 'مدة هذا العقد سنة تبدأ من تاريخ التوقيع.')).toEqual({ civil: [], econ: [] });
  });
});

describe('servicesAnchorArticleNumbers: نطاق الخدمات والتزامات الطرفين (الجولة 113)', () => {
  it('بند نطاق الخدمات فى عقد خدمات يحمل م646 وم148', () => {
    const r = servicesAnchorArticleNumbers('نطاق الخدمات', 'يوافق مقدم الخدمة على تزويد العميل بالخدمات التالية كما هو موضح أدناه.', 3, true);
    expect(r).toEqual([646, 148]);
  });
  it('بند مسئوليات الأطراف فى عقد خدمات يحمل م646 وم148', () => {
    const r = servicesAnchorArticleNumbers('مسؤوليات الأطراف', 'يلتزم مزود الخدمة بتعيين موظفين أكفاء، ويلتزم العميل بتوفير الوصول إلى الوثائق.', 3, true);
    expect(r).toEqual(expect.arrayContaining([646, 148]));
  });
  it('لا يغيّر ما كان: التسليم والأجر والإنهاء بترتيبها السابق', () => {
    expect(servicesAnchorArticleNumbers(null, 'يسدد رب العمل الأجر على دفعات حسب مراحل تنفيذ العمل.', 3)).toEqual(expect.arrayContaining([656]));
    expect(servicesAnchorArticleNumbers(null, 'لرب العمل إنهاء العقد ووقف تنفيذ العمل فى أى وقت.')).toContain(663);
  });
  it('بلا سياق خدمات لا يُفعَّل، وعقد الإيجار والبيع والعمل مستبعد كما كان', () => {
    expect(servicesAnchorArticleNumbers('نطاق الخدمات', 'الخدمات التالية موضحة أدناه.', 3, false)).toEqual([]);
    expect(servicesAnchorArticleNumbers('التزامات الأطراف', 'يلتزم المستأجر بسداد الأجرة وتسليم العين المؤجرة.', 3, true)).toEqual([]);
    expect(servicesAnchorArticleNumbers('التزامات الأطراف', 'يلتزم العامل بالعمل مقابل الراتب.', 3, true)).toEqual([]);
  });
});
