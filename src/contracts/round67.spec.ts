import { buildContractAuditReport, type AuditClause, type AuditReportInput } from '../exports/audit-report/build';
import { validateModelFindings, type LevelClause } from './contract-level';
import {
  findForwardGap,
  isBenignNumberingGapWarning,
  NUMBERING_GAP_NO_EVIDENCE_MARK,
  numberingGapEvidence,
  numberingGapWarningText,
  ordinalWordsToNumber,
  referencedMissingNumbers,
  subclauseMissingNumbers,
} from './numbering-gap';
import { SegmentationService } from './segmentation.service';

const ORD = ['الأولى', 'الثانية', 'الثالثة', 'الرابعة', 'الخامسة', 'السادسة', 'السابعة', 'الثامنة', 'التاسعة', 'العاشرة', 'الحادية عشر', 'الثانية عشر', 'الثالثة عشر', 'الرابعة عشر', 'الخامسة عشر', 'السادسة عشر', 'السابعة عشر', 'الثامنة عشر', 'التاسعة عشر'];
const BODY = 'يلتزم الطرف الثانى بتنفيذ ما ورد فى هذا البند وفقاً لأحكام العقد والقوانين المعمول بها فى جمهورية مصر العربية.';

/** عقد ترخيص مُركَّب: مواد بالترتيبى المؤنث مرقمة 1..13 ثم 18 و19 (قفزة فى الأصل نفسه) */
function contractWithJump(extraInBody = '', afterThirteen = ''): string {
  const nums = [...Array.from({ length: 13 }, (_, i) => i + 1), 18, 19];
  const parts = nums.map((n, i) => `المادة ${ORD[n - 1]}:\n${BODY}${i === 4 ? ' ' + extraInBody : ''}${n === 13 ? afterThirteen : ''}`);
  return `عقد ترخيص استغلال مساحة\n\nتحرر هذا العقد بين طرفين.\n\n${parts.join('\n\n')}`;
}

const seg = new SegmentationService();
const gapWarnings = (text: string): string[] => seg.segment(text).warnings.filter((w) => /غير متسلسل/.test(w));

describe('الجولة 67: ترتيبى الكلمات إلى رقم', () => {
  it.each([
    ['الخامسة', 5],
    ['الخامس', 5],
    ['الخامسه', 5],
    ['الأولى', 1],
    ['الاولي', 1],
    ['الحادية عشر', 11],
    ['الحادى عشر', 11],
    ['الثانية عشرة', 12],
    ['الثامنة عشر', 18],
    ['التاسعة عشر', 19],
  ])('%s ← %i', (w, n) => {
    expect(ordinalWordsToNumber(w as string)).toBe(n);
  });
  it('كلمة ليست ترتيبية ← null', () => {
    expect(ordinalWordsToNumber('الطرف')).toBeNull();
  });
});

describe('الجولة 67: فجوة الترقيم', () => {
  it('قفزة إلى الأمام فقط: 1..13 ثم 18', () => {
    const g = findForwardGap([...Array.from({ length: 13 }, (_, i) => i + 1), 18, 19]);
    expect(g).toEqual({ position: 14, expected: 14, found: 18, missing: [14, 15, 16, 17] });
  });
  it('التكرار والرجوع ليسا قفزة', () => {
    expect(findForwardGap([1, 2, 2, 3])).toBeNull();
    expect(findForwardGap([1, 2, 3, 3, 5])).toBeNull();
    expect(findForwardGap([1, 2, 3, 4])).toBeNull();
  });

  it('عقد بقفزة ولا دليل على نقص ⇒ تحذير موسوم لا يُحتسب نقص بنود', () => {
    const w = gapWarnings(contractWithJump());
    expect(w).toHaveLength(1);
    expect(w[0]).toContain('(متوقَّع 14, وُجد 18)');
    expect(w[0]).toContain(NUMBERING_GAP_NO_EVIDENCE_MARK);
    expect(isBenignNumberingGapWarning(w[0])).toBe(true);
  });

  it('إحالة داخلية إلى رقم من الفجوة ⇒ دليل نقص (التحذير القديم)', () => {
    const w = gapWarnings(contractWithJump('وفقاً للمادة الرابعة عشر من هذا العقد.'));
    expect(w).toHaveLength(1);
    expect(isBenignNumberingGapWarning(w[0])).toBe(false);
    expect(w[0]).toContain('يلزم مراجعة بشرية');
    expect(w[0]).toContain('يحيل إلى البند 14');
  });

  it('إحالة إلى مادة بالرقم من قانون خارجى ليست دليلاً', () => {
    const w = gapWarnings(contractWithJump('وفقاً للمادة 15 من القانون المدنى.'));
    expect(isBenignNumberingGapWarning(w[0])).toBe(true);
  });

  it('إحالة إلى رقم خارج الفجوة ليست دليلاً', () => {
    const w = gapWarnings(contractWithJump('وفقاً للمادة الثالثة من هذا العقد.'));
    expect(isBenignNumberingGapWarning(w[0])).toBe(true);
  });

  it('فقرات فرعية «15-1» تُسترجع بها حدود البند 15 فتضيق الفجوة، ولا يُدّعى نقص للرقم 14 بلا دليل', () => {
    const w = seg.segment(contractWithJump('', '\n15-1 التزام أول.\n15-2 التزام ثان.')).warnings;
    expect(w.some((x) => /فاستُرجعت حدودها/.test(x))).toBe(true);
    const gap = w.find((x) => /غير متسلسل/.test(x))!;
    expect(gap).toContain('(متوقَّع 14, وُجد 15)');
    expect(isBenignNumberingGapWarning(gap)).toBe(true);
  });

  it('بند متضخم قبل القفزة ⇒ دليل نقص', () => {
    const big = `${' '.repeat(0)}${BODY} `.repeat(40);
    const w = gapWarnings(contractWithJump('', ` ${big}`));
    expect(isBenignNumberingGapWarning(w[0])).toBe(false);
    expect(w[0]).toContain('متضخم');
  });

  it('أدوات الأدلة منفردة', () => {
    expect(referencedMissingNumbers('انظر المادة الخامسة عشر والمادة (16) ثم البند 3', [14, 15, 16, 17])).toEqual([15, 16]);
    expect(referencedMissingNumbers('المادة الرابعة عشر من القانون المدنى', [14])).toEqual([]);
    expect(subclauseMissingNumbers('14-1 أول\n14-2 ثان', [14, 15])).toEqual([14]);
    expect(subclauseMissingNumbers('تاريخ\n14-1', [14])).toEqual([14]);
    expect(subclauseMissingNumbers('بند عادى بلا ترقيم فرعى', [14])).toEqual([]);
  });

  it('نص التحذير بلا أدلة يحفظ صيغة التقرير ويذكر نطاق الأرقام', () => {
    const gap = findForwardGap([...Array.from({ length: 13 }, (_, i) => i + 1), 18])!;
    const t = numberingGapWarningText(gap, numberingGapEvidence('نص', [{ declaredNumber: 13, text: 'قصير' }], gap));
    expect(t).toMatch(/غير متسلسل[^()]*\(متوقَّع 14, وُجد 18\)/);
    expect(t).toContain('14–17');
  });

  it('عقد متسلسل سليم لا يُنتج تحذيراً', () => {
    const nums = Array.from({ length: 8 }, (_, i) => i + 1);
    const text = `عقد\n\n${nums.map((n) => `المادة ${ORD[n - 1]}:\n${BODY}`).join('\n\n')}`;
    expect(gapWarnings(text)).toHaveLength(0);
  });
});

describe('الجولة 67: الغلاف لا يعتبر قفزة بلا دليل تقسيماً غير مكتمل', () => {
  const clause: AuditClause = {
    clauseIndex: 1,
    clauseLabel: 'المادة الأولى',
    clauseTitle: null,
    clauseText: 'نص البند',
    assessmentStatus: 'سليم',
    assessmentReasoning: null,
    matchedArticles: [],
    riskLevel: null,
    suggestedWording: null,
    lawyerVerdict: null,
    lawyerNotes: null,
  };
  const base: AuditReportInput = {
    contractId: 'abcdef12-0000-0000-0000-000000000000',
    originalFilename: 'عقد.docx',
    uploadedAt: new Date('2026-11-07T10:00:00Z'),
    contractType: 'عقد ترخيص',
    clientRole: 'المرخَّص له',
    clauses: [clause],
    approvedAt: null,
    approvalNote: null,
    generatedAt: new Date('2026-11-07T10:00:00Z'),
    brand: 'شيلد',
  };
  const cover = (warnings: string[]): string => JSON.stringify(buildContractAuditReport({ ...base, extractionWarnings: warnings }).report.cover);
  const gap = findForwardGap([...Array.from({ length: 13 }, (_, i) => i + 1), 18, 19])!;

  it('قفزة بلا دليل: لا «ترقيم متقطع» ولا «غير مُقدَّر» على الغلاف', () => {
    const out = cover([numberingGapWarningText(gap, { referenced: [], subclause: [], oversizedClause: false, any: false })]);
    expect(out).not.toContain('متقطع');
    expect(out).not.toContain('غير مُقدَّر');
  });

  it('قفزة بدليل: يبقى التحفظ كما كان', () => {
    const out = cover([numberingGapWarningText(gap, { referenced: [14], subclause: [], oversizedClause: false, any: true })]);
    expect(out).toContain('غير مُقدَّر');
  });
});

describe('الجولة 67: عنوان البند فى نص الملاحظة', () => {
  const C5: LevelClause = { clauseIndex: 5, clauseLabel: 'المادة الخامسة', clauseTitle: null, clauseText: 'مدة هذا العقد شهري قابل للتجديد تبدأ من ............... وتنتهي في ...............' };
  const mk = (title: string, explanation: string) => ({
    findings: [{ kind: 'open_term', severity: 'عالٍ', title, explanation, suggestion: 'تحديد مدة العقد فى البند الخامسة صراحة.', evidence: [{ clause_index: 5, quote: 'تبدأ من ............... وتنتهي في' }] }],
  });

  it('«البند الخامسة» لمادة عنوانها «المادة الخامسة» يصير عنوانها', () => {
    const out = validateModelFindings(mk('البند الخامسة يترك مدة العقد مفتوحة', 'يبدو أن البند الخامسة يترك مدة العقد مفتوحة، وفى البند الخامسة تواريخ فارغة.'), [C5]);
    expect(out[0].title).toBe('المادة الخامسة يترك مدة العقد مفتوحة');
    expect(out[0].explanation).toContain('أن المادة الخامسة يترك');
    expect(out[0].explanation).toContain('وفى المادة الخامسة');
    expect(out[0].suggestion).toContain('فى المادة الخامسة صراحة');
    expect(JSON.stringify(out[0])).not.toContain('البند الخامسة');
  });

  it('«البند الخامس» (مذكر) لمادة عنوانها «المادة الخامسة» يُوحَّد أيضاً، والسابقة تُحفظ', () => {
    const out = validateModelFindings(mk('مدة مفتوحة', 'يخالف ما ورد بالبند الخامس وللبند الخامس أثر.'), [C5]);
    expect(out[0].explanation).toBe('يخالف ما ورد بالمادة الخامسة وللمادة الخامسة أثر.');
  });

  it('بند آخر غير مستشهد به أو ترتيبى مختلف لا يُمس', () => {
    const out = validateModelFindings(mk('مدة مفتوحة', 'يخالف البند السادس والبند الخامسة فقط.'), [C5]);
    expect(out[0].explanation).toBe('يخالف البند السادس والمادة الخامسة فقط.');
  });

  it('عقد عنوان بنوده «البند …» لا يتغير نصه', () => {
    const c: LevelClause = { ...C5, clauseLabel: 'البند الخامس' };
    const out = validateModelFindings(mk('البند الخامس يترك مدة العقد مفتوحة', 'يبدو أن البند الخامس يترك مدة العقد مفتوحة.'), [c]);
    expect(out[0].title).toBe('البند الخامس يترك مدة العقد مفتوحة');
  });

  it('ترتيبى من كلمتين («الحادية عشر»)', () => {
    const c: LevelClause = { clauseIndex: 11, clauseLabel: 'المادة الحادية عشر', clauseTitle: null, clauseText: 'يحدد الطرف الأول الأجرة وفقاً لما يراه مناسباً.' };
    const out = validateModelFindings(
      { findings: [{ kind: 'open_term', severity: 'عالٍ', title: 'أجرة مفتوحة', explanation: 'يبدو أن البند الحادى عشر يترك الأجرة مفتوحة.', evidence: [{ clause_index: 11, quote: 'يحدد الطرف الأول الأجرة وفقاً لما يراه مناسباً' }] }] },
      [c],
    );
    expect(out[0].explanation).toBe('يبدو أن المادة الحادية عشر يترك الأجرة مفتوحة.');
  });
});
