import {
  anchorArticleNumbers,
  classifyClauseCriteria,
  leaseAnchorArticleNumbers,
  scopedLawsForCriteria,
  serializeCriteria,
} from './criteria.util';

describe('classifyClauseCriteria', () => {
  it('يصنّف شرطاً جزائياً كتعويض', () => {
    const r = classifyClauseCriteria('الشرط الجزائي', 'إذا تأخر المستأجر فى السداد التزم بغرامة تأخير قدرها 5%.');
    expect(r).toContain('compensation');
  });
  it('يصنّف القوة القاهرة', () => {
    expect(classifyClauseCriteria('القوة القاهرة', 'لا يسأل أى طرف عن التأخير الناشئ عن قوة قاهرة.')).toContain(
      'force_majeure',
    );
  });
  it('يصنّف الفسخ والإنهاء كخروج', () => {
    expect(classifyClauseCriteria('الفسخ', 'يحق للمؤجر فسخ العقد بإخطار كتابى.')).toContain('exit');
  });
  it('يصنّف الإعفاء من المسؤولية', () => {
    expect(classifyClauseCriteria('المسؤولية', 'يُعفى الطرف الأول من أية مسئولية عن الأضرار.')).toContain('liability');
  });
  it('يصنّف التفرد بالقرار كمعاملة بالمثل', () => {
    expect(classifyClauseCriteria(null, 'يجوز للطرف الأول تعديل الأجرة بإرادته المنفردة.')).toContain('reciprocity');
  });
  it('يصنّف حماية البيانات الشخصية', () => {
    expect(classifyClauseCriteria('البيانات', 'يلتزم الطرفان بحماية البيانات الشخصية.')).toContain('data_protection');
  });
  it('لا يصنّف بنداً بلا إشارات (أطراف العقد)', () => {
    expect(classifyClauseCriteria('الأطراف', 'تم الاتفاق بين السيد أحمد والسيد محمد')).toEqual([]);
  });
  it('بحد أقصى 3 معايير', () => {
    const r = classifyClauseCriteria(
      'عام',
      'تعويض ومسئولية وفسخ وسداد وقوة قاهرة وضريبة وبيانات شخصية وإخطار ودفعات',
    );
    expect(r.length).toBeLessThanOrEqual(3);
  });
});

describe('anchorArticleNumbers', () => {
  it('يناوب بين المعايير بلا تكرار ويحترم الحد الأقصى', () => {
    const r = anchorArticleNumbers(['liability', 'compensation', 'financial_impact'], 4);
    expect(r).toHaveLength(4);
    expect(new Set(r).size).toBe(4);
    expect(r[0]).toBe(217);
    expect(r[1]).toBe(224);
  });
  it('يعيد قائمة فارغة لمعيار بلا مواد مرجعية', () => {
    expect(anchorArticleNumbers(['duration', 'legal_compliance'])).toEqual([]);
  });
  it('القوة القاهرة تضم 373 و165 و159 و147', () => {
    expect(anchorArticleNumbers(['force_majeure'], 5)).toEqual([373, 165, 159, 147]);
  });
});

describe('scopedLawsForCriteria / serializeCriteria', () => {
  it('حماية البيانات مقيَّدة بالقانون 151/2020', () => {
    expect(scopedLawsForCriteria(['data_protection', 'exit'])).toEqual([{ lawNo: 151, lawYear: 2020 }]);
  });
  it('تسلسل المفاتيح', () => {
    expect(serializeCriteria(['exit', 'payment'])).toBe('exit,payment');
    expect(serializeCriteria([])).toBeNull();
  });
});

describe('leaseAnchorArticleNumbers', () => {
  it('بند معاينة فى عقد إيجار يجلب مواد ضمان العيوب', () => {
    const r = leaseAnchorArticleNumbers(null, 'يقر المستأجر بأنه عاين العين المؤجرة المعاينة التامة النافية للجهالة.');
    expect(r).toContain(576);
    expect(r).toContain(578);
  });
  it('بند رد العين وانتهاء المدة', () => {
    const r = leaseAnchorArticleNumbers('الانتهاء', 'عند انتهاء العقد يلتزم المستأجر بتسليم العين المؤجرة خالية.');
    expect(r).toContain(590);
  });
  it('لا مواد إيجار لبند ليس فى سياق إيجار', () => {
    expect(leaseAnchorArticleNumbers(null, 'يحل البائع محل الشركة فى التزامات التوريد وتسليم البضاعة.')).toEqual([]);
  });
  it('يحترم الحد الأقصى', () => {
    expect(
      leaseAnchorArticleNumbers(null, 'المستأجر يسدد الأجرة ويعاين العين وينهى العقد ويغير الديكور ويجدد المدة.', 3).length,
    ).toBeLessThanOrEqual(3);
  });
});
