import { checkMissingClauses, servicesSubtype } from './contract-level';
import { buildPlaybook } from './playbook';

const FEE = [
  { clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: 'تعاقد الأستاذ المحامى مع الشركة لتمثيلها أمام المحاكم والجهات القضائية فى القضايا التى ترفع منها أو عليها مقابل أتعاب محاماة متفق عليها.' },
  { clauseIndex: 2, clauseLabel: 'البند الثانى', clauseTitle: null, clauseText: 'يتقاضى المحامى أتعابه عن كل قضية وفقاً للجدول المرفق ويحق للموكل مراجعة أعمال المحامى فى أى وقت، وتسدد الأتعاب شهرياً.' },
  { clauseIndex: 3, clauseLabel: 'البند الثالث', clauseTitle: null, clauseText: 'يلتزم المحامى ببذل العناية الواجبة ويحافظ على مستندات الموكل، وللموكل إنهاء التوكيل فى أى وقت دون مسوغ.' },
];
const opts = { contractType: null, titleText: 'عقد اتفاق أتعاب محاماة', fileName: 'x.pdf', textMayBeIncomplete: false } as never;
const ids = (c: typeof FEE) => checkMissingClauses(c, opts).map((f) => f.id);

describe('round 81: عقد أتعاب المحاماة لا يُنبَّه فيه على بنود التوريد والمقاولة والترخيص', () => {
  it('النوع الفرعى attorney_fees', () => {
    expect(servicesSubtype(FEE.map((c) => c.clauseText).join(' ').replace(/[ًٌٍَُِّْ]/g, ''))).toBe('attorney_fees');
  });
  it('الملكية الفكرية والضمان والتسليم والقوة القاهرة لا تظهر «غير مرصودة»', () => {
    const r = ids(FEE);
    for (const k of ['intellectual_property', 'warranty', 'acceptance', 'force_majeure']) expect(r).not.toContain(`missing:${k}`);
  });
  it('بقية الفحوص المناسبة تبقى (الفسخ/القانون الواجب/المسئولية…)', () => {
    const r = ids(FEE.slice(0, 2));
    expect(r.length).toBeGreaterThan(0);
    expect(r).toContain('missing:governing_law');
  });
  it('عقد ممسوح لا يتكرر فيه «المحامى» داخل البنود: يكفى عنوانه «أتعاب محاماه»', () => {
    const scanned = [
      { clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: 'يلتزم الطرف الأول ببذل أقصى درجات العناية والعمل القانونى المنوط به ودون تقصير أو إهمال ويحافظ على أوراق الشركة التى تسلم إليه.' },
      { clauseIndex: 2, clauseLabel: 'البند الثانى', clauseTitle: null, clauseText: 'يسدد الطرف الثانى المبالغ المستحقة للطرف الأول فور إستحقاقها دون حاجة لتنبيه أو إنذار وتسدد شهرياً بحسب الاتفاق.' },
    ];
    const r = checkMissingClauses(scanned, { contractType: null, titleText: 'بسم الله الرحمن الرحيم\nعقد إتفاق أتعاب محاماه', fileName: null, textMayBeIncomplete: true } as never).map((f) => f.id);
    for (const k of ['intellectual_property', 'warranty', 'acceptance', 'force_majeure']) expect(r).not.toContain(`missing:${k}`);
  });
  it('عقد خدمات عادى (ذكر عابر لمحام) لا يتأثر', () => {
    const svc = [
      { clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: 'يقدم الطرف الأول خدمات تطوير برمجيات للطرف الثانى مقابل أجر شهرى ويسلم المخرجات حسب الجدول الزمنى المتفق عليه بين الطرفين.' },
      { clauseIndex: 2, clauseLabel: 'البند الثانى', clauseTitle: null, clauseText: 'يرجع الطرف الثانى إلى محاميه فى أى نزاع ويتحمل أتعابه، وتسدد الأجور شهرياً بحسب ما يتم الاتفاق عليه كتابة بين الطرفين.' },
    ];
    const r = checkMissingClauses(svc, { contractType: 'عقد خدمات أو مقاولة أو توريد', titleText: null, fileName: null, textMayBeIncomplete: false } as never).map((f) => f.id);
    expect(r).toContain('missing:intellectual_property');
    expect(r).toContain('missing:warranty');
  });
  it('الدليل التفاوضى: محاور الملكية الفكرية والضمان والتسليم لا تظهر «غير مرصود» فى عقد الأتعاب', () => {
    const pb = buildPlaybook({ contractType: 'عقد أتعاب محاماة', clientRole: null, clientParty: null, clauses: FEE });
    const labels = (pb?.rows ?? []).filter((r) => r.status === 'missing').map((r) => r.label).join('|');
    expect(labels).not.toContain('الملكية الفكرية');
    expect(labels).not.toContain('الضمان');
    expect(labels).not.toContain('التسليم والقبول');
  });
});
