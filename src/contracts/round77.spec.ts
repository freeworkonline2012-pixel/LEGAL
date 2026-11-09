import { classifyClauseCriteria } from './criteria.util';

const FEE_PERCENT_CLAUSE =
  'يلتزم الطرف الثانى بسداد نسبة 10% عن كل حكم نهائى يصدر فى الدعوى لصالح الشركة سواء المقام من الشركة أو ضدها أو أن يقضى بتخفيض مبلغ التعويض المرفوع به الدعوى ضد الشركة حتى مبلغ أربعون الف جنيها قضاء أو رضاء';

describe('round 77: معيار التعويض فى عقد أتعاب المحاماة', () => {
  it('بدون وسم عقد الأتعاب: كلمة التعويض توسم البند بمعيار التعويض كما كان', () => {
    expect(classifyClauseCriteria(null, FEE_PERCENT_CLAUSE)).toContain('compensation');
  });

  it('فى عقد أتعاب: بند نسبة الأتعاب عن قضايا التعويض لا يُوسم بمعيار التعويض (فلا مراسى م223-225)', () => {
    expect(classifyClauseCriteria(null, FEE_PERCENT_CLAUSE, { attorneyFeeContract: true })).not.toContain('compensation');
  });

  it('فى عقد أتعاب: صيغة الشرط الجزائى أو الغرامة الصريحة تبقى موسومة بالتعويض', () => {
    expect(classifyClauseCriteria(null, 'يلتزم الموكل بغرامة تأخير عن كل يوم', { attorneyFeeContract: true })).toContain('compensation');
    expect(classifyClauseCriteria(null, 'اتفق الطرفان على شرط جزائى قدره ألف جنيه', { attorneyFeeContract: true })).toContain('compensation');
  });

  it('لا أثر على بقية المعايير فى عقد الأتعاب (المسؤولية/الدفع)', () => {
    const r = classifyClauseCriteria(null, 'يلتزم الطرف الأول ببذل العناية ولا يتحمل مسئولية بدون خطأ جسيم ويسدد المبلغ شهريا', { attorneyFeeContract: true });
    expect(r).toEqual(expect.arrayContaining(['liability']));
  });
});

import { SegmentationService } from './segmentation.service';

describe('round 77: عنوان بند ضاعت كلمة «البند» منه فقُرئت رمزاً لاتينياً', () => {
  const body = (n: string) => `${n}\nيلتزم الطرف الثانى بتقديم كافة المستندات والبيانات والمعلومات فور طلبها من الطرف الأول وإلا كان مسئولاً عن التأخير فى التنفيذ.`;
  it('«Rent الخامس» بعد البند الرابع يُقسَّم بنداً خامساً مستقلاً', () => {
    const text = [
      'عقد اتفاق أتعاب محاماة',
      body('البند الأول'),
      body('البند الثانى'),
      body('البند الثالث'),
      body('البند الرابع'),
      body('Rent الخامس'),
      body('البند السادس'),
    ].join('\n');
    const r = new SegmentationService().segment(text);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6]);
  });
  it('لا يُقبل «Rent الخامس» إن لم يكن الرقم التالى مباشرة (حماية التسلسل)', () => {
    const text = ['عقد اتفاق أتعاب محاماة', body('البند الأول'), body('البند الثانى'), body('Rent الخامس'), body('البند الثالث')].join('\n');
    const r = new SegmentationService().segment(text);
    expect(r.clauses.map((c) => c.declaredNumber)).not.toContain(5);
  });
});

import { fillGapsFromAligned } from './segmentation.service';

describe('round 77: fillGapsFromAligned', () => {
  const h = (n: number, at: number) => ({ lineStart: at, declaredNumber: n });
  it('يضيف الرقم الناقص بين رقمين إن بقى الترتيب متزايداً', () => {
    const r = fillGapsFromAligned([h(1, 0), h(2, 100), h(4, 300), h(5, 400)], [h(1, 0), h(2, 100), h(3, 200), h(4, 300)]);
    expect(r.added).toEqual([3]);
    expect(r.heads.map((x) => x.declaredNumber)).toEqual([1, 2, 3, 4, 5]);
  });
  it('لا يضيف إن كسر الترتيب (رقم أصغر بعد أكبر)', () => {
    const r = fillGapsFromAligned([h(1, 0), h(2, 100), h(5, 300)], [h(3, 400)]);
    expect(r.added).toEqual([]);
  });
  it('لا يضيف عنواناً على سطر عنوان حرفى قائم', () => {
    const r = fillGapsFromAligned([h(1, 0), h(2, 100)], [h(3, 100)]);
    expect(r.added).toEqual([]);
  });
});
