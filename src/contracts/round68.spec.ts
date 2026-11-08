import { findAdverbialHeads } from './clause-headings-alt';
import { SegmentationService } from './segmentation.service';

const FEES = [
  'عقد اتفاق أتعاب محاماة',
  'إنه فى يوم الخميس الموافق 1/11/2018 تحرر هذا العقد بين كل من :',
  'أولاً : السادة/ شركة النور للتأمين ومقرها 10 شارع مصدق الدقى الجيزة ويمثلها السيد الأستاذ/ فلان الفلانى بصفته العضو المنتدب',
  '(طرف أول)',
  'ثانياً : مكتب الأمل للمحاماة والاستشارات القانونية الكائن مقره 12 شارع عماد الدين القاهرة ويمثله الأستاذ/ علان المحامى',
  '(طرف ثان)',
  'تمهيد',
  'وبعد الاجتماع الذى تم مع سيادتكم بمقر الشركة ومناقشة الأعمال التى يقوم بها المكتب لشركتكم وتم الاتفاق على الآتى :',
  'أولاً : يقوم المكتب بمراجعة كافة القضايا التى ترفع على الشركة أو منها وإبداء الرأى القانونى فيها.',
  'ثانياً : تقوم الشركة بسداد مبلغ وقدره سبعة آلاف وخمسمائة جنيه شهرياً للمكتب نظير الأعمال المذكورة.',
  'ثالثاً : يسرى هذا الاتفاق من 1/11/2018 وينتهى فى 31/12/2019 ويجوز تجديده لمدة أو لمدد مماثلة بموافقة الطرفين.',
  'رابعاً : يختص القضاء المصرى بنظر أى نزاع ينشأ عن هذا الاتفاق.',
  'الطرف الأول                الطرف الثانى',
].join('\n');

describe('الجولة 68: عناوين «أولاً/ثانياً…» بلا ترقيم «البند»', () => {
  const svc = new SegmentationService();

  it('عقد أتعاب غير مرقم: أربعة بنود من العناوين الترتيبية، وسطرا الطرفين فى الديباجة لا بنوداً', () => {
    const r = svc.segment(FEES);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4]);
    expect(r.clauses[0].text).toContain('يقوم المكتب بمراجعة');
    expect(r.clauses[1].text).toContain('سبعة آلاف وخمسمائة');
    expect(r.preamble).toContain('طرف أول');
    expect(r.preamble).toContain('تمهيد');
    expect(r.warnings.some((w) => w.includes('عناوينه الترتيبية'))).toBe(true);
  });

  it('عناوين بلا تنوين (قراءة آلية: «اولا» «ثانيا») تُقبل', () => {
    const t = ['تمهيد', 'اتفق الطرفان على ما يلى', 'اولا : التزام اول يؤديه الطرف الاول', 'ثانيا : التزام ثان يؤديه الطرف الثانى', 'ثالثا : مدة العقد سنة'].join('\n');
    expect(findAdverbialHeads(t).map((h) => h.declaredNumber)).toEqual([1, 2, 3]);
  });

  it('قائمة طرفين فقط («أولاً: السادة… (طرف أول)» «ثانياً: …») ليست بنوداً', () => {
    const t = ['عقد', 'أولاً : السادة/ شركة س ومقرها القاهرة (طرف أول)', 'ثانياً : السيد/ ص ويقيم بالجيزة (طرف ثان)', 'يلتزم الطرف الثانى بالسداد.'].join('\n');
    expect(findAdverbialHeads(t)).toEqual([]);
  });

  it('عنوانان فقط لا يُقبلان إلا بعبارة تمهيدية («اتفقا على الآتى»)', () => {
    const none = ['نص', 'أولاً : الاتفاق على كذا وكذا بين الطرفين بكل تفصيل', 'ثانياً : الاتفاق على كذا وكذا بين الطرفين بكل تفصيل'].join('\n');
    expect(findAdverbialHeads(none)).toEqual([]);
    const ok = ['اتفق الطرفان على الآتى:', 'أولاً : الاتفاق على كذا وكذا بين الطرفين بكل تفصيل', 'ثانياً : الاتفاق على كذا وكذا بين الطرفين بكل تفصيل'].join('\n');
    expect(findAdverbialHeads(ok).length).toBe(2);
  });

  it('عقد مرقم «البند الأول…» لا يمسّه هذا المسار', () => {
    const t = ['البند الأول', 'نص الأول', 'البند الثانى', 'أولاً : نقطة داخل البند', 'ثانياً : نقطة أخرى', 'ثالثاً : ثالثة', 'البند الثالث', 'نص'].join('\n');
    const r = svc.segment(t);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3]);
    expect(r.warnings.some((w) => w.includes('عناوينه الترتيبية'))).toBe(false);
  });
});

import { buildContractAuditReport, type AuditReportInput } from '../exports/audit-report/build';
import { classifyDocumentKind } from './document-kind';

const NOW68 = new Date('2026-11-08T10:00:00Z');
const base68: AuditReportInput = {
  contractId: 'abcdef12-0000-0000-0000-000000000000',
  originalFilename: 'عقد.pdf',
  uploadedAt: NOW68,
  contractType: null,
  clientRole: null,
  clauses: [],
  approvedAt: null,
  approvalNote: null,
  generatedAt: NOW68,
  brand: 'شيلد',
};

describe('الجولة 68: بوابة الصدق عند صفر بنود', () => {
  const rows = (inp: AuditReportInput) => buildContractAuditReport(inp).report.cover.rows;
  const val = (inp: AuditReportInput, label: string) => rows(inp).find((r) => r.label === label)?.value ?? '';

  it('صفر بنود: «تعذّر تحليل العقد» لا «لم تُرصد بنود تحتاج مراجعة»', () => {
    const inp = { ...base68, extractionWarnings: ['لم يُعثَر على أى بند بترقيم مقروء'] };
    expect(val(inp, 'مستوى المخاطرة العام')).toContain('تعذّر تحليل العقد');
    expect(val(inp, 'مستوى المخاطرة العام')).not.toContain('لم تُرصد بنود');
    expect(val(inp, 'عدد البنود')).toContain('تعذّر التقسيم');
    expect(val(inp, 'نطاق التغطية')).toContain('لا تغطية');
    const text = JSON.stringify(buildContractAuditReport(inp).report.blocks);
    expect(text).not.toContain('لم تُرصد فى هذا العقد بنود تحتاج مراجعة');
    expect(text).toContain('تعذّر تحليل هذا العقد آلياً');
  });

  it('عقد سليم بلا بنود لا يتأثر حين توجد بنود (النص القديم)', () => {
    const inp = { ...base68, clauses: [{ clauseIndex: 1, clauseLabel: 'البند 1', clauseTitle: null, clauseText: 'نص', assessmentStatus: 'سليم', assessmentReasoning: null, matchedArticles: [], riskLevel: null, suggestedWording: null, lawyerVerdict: null, lawyerNotes: null }] };
    expect(val(inp as AuditReportInput, 'مستوى المخاطرة العام')).toContain('لم تُرصد بنود');
  });

  it('ملف مستندات (خطاب + محضر + شيك + بطاقة) يُصنَّف «مجموعة مستندات» ويُنبَّه إليه', () => {
    const t = ['تحية طيبة وبعد', 'الموضوع : توريد وتركيب مصعد', 'محضر استلام ابتدائى للمصعد', 'Cheque No. 190000 Pay this cheque', 'بطاقة الرقم القومى', 'PACKING LIST'].join('\n');
    expect(classifyDocumentKind(t).kind).toBe('document_bundle');
    const r = new SegmentationService().segment(t);
    expect(r.clauses.length).toBe(0);
    expect(r.warnings.some((w) => w.includes('مجموعة مستندات') && w.includes('ليس نص عقد'))).toBe(true);
  });

  it('عقد حقيقى بلا ترقيم لا يُصنَّف ملف مستندات', () => {
    expect(classifyDocumentKind('تحرر هذا العقد بين الطرف الأول والطرف الثانى واتفقا على أن يلتزم الطرف الثانى بالسداد').kind).toBe('contract_like');
  });
});

describe('الجولة 68: قراءة آلية مشوَّهة لعناوين «أولاً/ثانياً…»', () => {
  const noisy = [
    'عقد اتفاق أتعاب محاماة',
    'أولاً : السادة/ شركة النور للتأمين ومقرها 10 شارع مصدق ويمثلها السيد الأستاذ/ فلان (طرف أول)',
    'ثانياً : مكتب الأمل للمحاماة ويمثله الأستاذ/ علان المحامى (طرف ثانى)',
    'وبعد الاجتماع الذى تم مع سيادتكم تم الاتفاق مع سيادتكم على الآتى :',
    'أولاً : يقوم المكتب بمراجعة كافة القضايا التى ترفع على الشركة أو منها وإبداء الرأى القانونى فيها.',
    ": ثانياً' تقوم الشركة بسداد مبلغ وقدره سبعة آلاف وخمسمائة جنيه شهرياً للمكتب نظير الأعمال.",
    "' نالياً. هذا الاتفاق يسرى من 1/11/2018 وينتهى فى 31/12/2019 ويجوز تجديده بموافقة الطرفين.",
    'الطرف الأول                الطرف الثانى',
  ].join('\n');

  it('سطر يبدأ بعلامة زائدة («: ثانياً») وعنوان مشوَّه («نالياً» = ثالثاً) يُسترجعان بتسلسل مقيَّد', () => {
    const heads = findAdverbialHeads(noisy);
    expect(heads.map((h) => h.declaredNumber)).toEqual([1, 2, 3]);
    const r = new SegmentationService().segment(noisy);
    expect(r.clauses.length).toBe(3);
    expect(r.clauses[1].text).toContain('سبعة آلاف وخمسمائة');
  });

  it('كلمة عادية بعد عنوانين لا تُلتقط عنواناً (بعيدة عن «ثالثاً»)', () => {
    const t = ['اتفق الطرفان على الآتى:', 'أولاً : التزام المكتب بمراجعة القضايا المرفوعة على الشركة', 'ثانياً : التزام الشركة بسداد الأتعاب المتفق عليها كل شهر', 'تاريخ التحرير هو يوم الخميس الموافق كذا كذا'].join('\n');
    expect(findAdverbialHeads(t).length).toBe(2);
  });
});

it('الجولة 68: متن بند «أولاً: …» يبقى متناً كاملاً لا يُقتطع منه عنوان', () => {
  const r = new SegmentationService().segment(FEES);
  expect(r.clauses[0].title).toBeNull();
  expect(r.clauses[0].text).toContain('يقوم المكتب بمراجعة');
  expect(r.clauses[0].label).toBe('أولاً');
});

import { damagedEscalationNumber, numericWarnings } from './numeric-checks.util';
import { extractKeyTerms, maskLongNumbers } from './key-terms';
import { validateModelFindings } from './contract-level';

describe('الجولة 68: رقم الزيادة التالف وتقنيع الهوية', () => {
  it('«بزيادة سنوية 7610» رقم لا يصلح نسبة: تنبيه قراءة', () => {
    const t = 'ويتفق الطرفان على أن تكون الزيادة السنوية بنسبة 7610 تطبق من السنة الثانية.';
    expect(damagedEscalationNumber(t)).toBe('7610');
    expect(numericWarnings(t).some((w) => w.includes('7610') && w.includes('نسبة تالفة'))).toBe(true);
  });

  it('لا إنذار على نسبة سليمة أو مبلغ زيادة بعملة أو سنة', () => {
    expect(damagedEscalationNumber('بزيادة سنوية قدرها 10 % تطبق من السنة الثانية')).toBeNull();
    expect(damagedEscalationNumber('بزيادة سنوية 1500 جنيه')).toBeNull();
    expect(damagedEscalationNumber('تزاد الأجرة اعتباراً من 2021')).toBeNull();
    expect(damagedEscalationNumber('بزيادة قدرها 5%')).toBeNull();
  });

  it('ملاحظة «شرط مفتوح» من النموذج على اقتباس رقمه تالف تُوسم غير مؤكدة', () => {
    const clauses = [{ clauseIndex: 4, clauseLabel: 'البند الرابع', clauseTitle: null, clauseText: 'ويتفق الطرفان على أن تكون الزيادة السنوية بنسبة 7610 تطبق من السنة الثانية.' }];
    const out = validateModelFindings(
      { findings: [{ kind: 'open_term', severity: 'متوسط', title: 'نسبة الزيادة غير محددة', explanation: 'النسبة غير واضحة فى النص.', evidence: [{ clause_index: 4, quote: 'الزيادة السنوية بنسبة 7610' }] }] },
      clauses as never,
    );
    expect(out.length).toBe(1);
    expect(out[0].verification?.status).toBe('unconfirmed');
    expect(out[0].verification?.reason).toContain('رقم');
  });

  it('رقم الجواز وتاريخ إصداره لا يظهران فى الشروط الرئيسية', () => {
    const terms = extractKeyTerms([
      { clauseIndex: 0, clauseLabel: 'نص سابق', clauseTitle: null, clauseText: 'السيد رامز جواز سفر رقم RL 3332051 تاريخ الإصدار 15/8/2015 ويقيم بالقاهرة. تبدأ المدة من 1/12/2018.' },
    ]);
    const dates = terms.filter((t) => t.kind === 'date').map((t) => t.value);
    expect(dates).toEqual(['1/12/2018']);
  });

  it('تقنيع الأرقام الطويلة إلا المبالغ', () => {
    expect(maskLongNumbers('رقم قومى 28411012500217 بتاريخ')).toContain('[رقم مُقنَّع]');
    expect(maskLongNumbers('رقم قومى 28411012500217 بتاريخ')).not.toContain('28411012500217');
    expect(maskLongNumbers('مبلغ 452500000 جنيه')).toBe('مبلغ 452500000 جنيه');
    expect(maskLongNumbers('أجرة 13750 جنيه')).toBe('أجرة 13750 جنيه');
  });
});

describe('الجولة 68: عناوين «حادى عشر … خامس عشر» بلا «ال» ولا «البند» (عقد إيجار حقيقى: 15 بنداً قُرئ منها 11)', () => {
  const svc2 = new SegmentationService();
  const doc = (heads: string[]) => ['عقد إيجار', 'تمهيد', 'يمتلك الطرف الأول عقاراً.'].concat(...heads.map((h) => [h, 'نص البند يتضمن التزامات الطرفين وأحكاماً متنوعة بما يكفى.'])).join('\n');
  const first10 = ['الأول', 'الثانى', 'الثالث', 'الرابع', 'الخامس', 'السادس', 'السابع', 'الثامن', 'التاسع', 'العاشر'].map((x) => `البند ${x}`);

  it('بنود 11–15 بعناوين «حادى عشر» … «خامس عشر» تُقسَّم كلها (15 بنداً)', () => {
    const r = svc2.segment(doc([...first10, 'حادى عشر', 'ثانى عشر', 'ثالث عشر', 'رابع عشر', 'خامس عشر']));
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    expect(r.clauses[10].label).toBe('البند الحادى عشر');
  });

  it('عنوان «حادى عشر» لم يُقرأ: بقية البنود (12–15) لا تضيع، وتظهر قفزة الترقيم', () => {
    const r = svc2.segment(doc([...first10, 'ثانى عشر', 'ثالث عشر', 'رابع عشر', 'خامس عشر']));
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15]);
    expect(r.warnings.some((w) => w.includes('غير متسلسل'))).toBe(true);
  });

  it('كلمة عادية («ثانى») وحدها فى سطر لا تصير بنداً فى عقد مرقم', () => {
    const r = svc2.segment(['البند الأول', 'نص', 'ثانى', 'نص', 'البند الثانى', 'نص آخر'].join('\n'));
    expect(r.clauses.length).toBe(2);
  });
});

import { checkUndefinedTerms } from './contract-level';

describe('الجولة 68: مرفقات عامة وتأييد حسابى للمبالغ', () => {
  const lc = (text: string, i = 1) => [{ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: text }];
  it('«التمهيد وكافة المرفقات وملحقات هذا العقد جزء لا يتجزأ» عبارة عامة لا تصنع إنذار مرفق مفقود', () => {
    const f = checkUndefinedTerms(lc('يعتبر التمهيد السابق وكافة المرفقات وملحقات هذا العقد جزء لا يتجزأ من هذا العقد ومكمل ومتمم لبنوده.'));
    expect(f.some((x) => x.id === 'undefined:attachment')).toBe(false);
  });
  it('إحالة معيَّنة إلى «الملحق رقم 1» تبقى مفحوصة', () => {
    const f = checkUndefinedTerms(lc('يلتزم المقاول بالمواصفات الواردة بالملحق رقم 1 المرفق بهذا العقد.'));
    expect(f.some((x) => x.id === 'undefined:attachment')).toBe(true);
  });
  it('41,250 = 3 × 13,750: لا يبقى الوسم «يلزم التحقق» على مبلغين تالفى الرقم متطابقين حسابياً', () => {
    const t = 'القيمة الإيجارية الشهرية مبلغ 0 جنيه ( ثلاثة عشر ألف وسبعمائة وخمسون جنيه مصرى فقط لا غير ) وتدفع كل ثلاثة أشهر 0 جنيه ( واحد واربعون الف ومائتان وخمسون جنيه مصرى فقط لا غير ) مقدماً.';
    const terms = extractKeyTerms([{ clauseIndex: 4, clauseLabel: 'البند الرابع', clauseTitle: null, clauseText: t }]);
    const amounts = terms.filter((x) => x.kind === 'amount');
    expect(amounts.map((x) => x.value).sort()).toEqual(['13,750 جنيه', '41,250 جنيه']);
    expect(amounts.every((x) => !x.suspect)).toBe(true);
  });
  it('مبلغ تالف بلا علاقة حسابية بغيره يبقى «يلزم التحقق»', () => {
    const t = 'الأجرة الشهرية مبلغ 0 جنيه ( ثلاثة عشر ألف وسبعمائة وخمسون جنيه مصرى فقط لا غير ) والتأمين 0 جنيه ( سبعة آلاف جنيه مصرى فقط ).';
    const terms = extractKeyTerms([{ clauseIndex: 4, clauseLabel: 'البند الرابع', clauseTitle: null, clauseText: t }]);
    expect(terms.some((x) => x.kind === 'amount' && x.suspect)).toBe(true);
  });
});

import { buildPlaybook } from './playbook';

describe('الجولة 68: بند الكهرباء والمياه ومقابل الصيانة (رسم اتحاد الملاك) ليس محور «الصيانة والترميمات»', () => {
  const run = (text: string) =>
    buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clientParty: 'second', clauses: [{ clauseIndex: 1, clauseLabel: 'البند 1', clauseTitle: null, clauseText: text }] });
  const row = (text: string) => run(text)?.rows.find((r) => r.topicId === 'lease_maintenance');

  it('«مقابل الصيانة الذى يفرضه اتحاد الملاك» مع الكهرباء والمياه: المحور غير مرصود', () => {
    const r = row('يلتزم المستأجر بسداد مقابل استهلاك الكهرباء والمياه والغاز الطبيعى ومقابل الصيانة الذى يفرضه اتحاد الملاك.');
    expect(r?.status).toBe('missing');
  });

  it('بند صيانة حقيقى يبقى مرصوداً', () => {
    const r = row('يلتزم المستأجر بإجراء أعمال الصيانة والترميمات الدورية للعين المؤجرة على نفقته.');
    expect(r?.status === 'found' || r?.status === 'concern').toBe(true);
  });
});
