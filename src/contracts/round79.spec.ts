import { Logger } from '@nestjs/common';
import { ATTORNEY_FEE_CONTRACT_LABEL, isAttorneyFeeContract } from './criteria.util';
import { contractFamily } from './contract-level';
import { extractKeyTerms, OCR_UNVERIFIED_LABEL, OCR_UNVERIFIED_NOTE } from './key-terms';
import { playbookFamily } from './playbook';
import { SegmentationService } from './segmentation.service';
import { buildContractAuditReport, type AuditClause, type AuditReportInput } from '../exports/audit-report/build';

const kt = (text: string) => [{ clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: text }];

describe('round 79: وسم أرقام النسخ الممسوحة «غير موثَّق—قراءة آلية»', () => {
  const DIGITS = 'يسدد الطرف الثانى مبلغ 750 جنيها شهريا ونسبة 10% عن كل حكم';
  it('بلا قراءة آلية: لا وسم (سلوك الملفات النصية كما هو)', () => {
    expect(extractKeyTerms(kt(DIGITS)).some((t) => t.ocrUnverified)).toBe(false);
  });
  it('مع قراءة آلية: كل قيمة بالأرقام تُوسم', () => {
    const terms = extractKeyTerms(kt(DIGITS), { ocrRead: true });
    expect(terms.length).toBeGreaterThanOrEqual(2);
    expect(terms.every((t) => t.ocrUnverified === true)).toBe(true);
  });
  it('الرقم المؤيَّد بكتابته بالحروف لا يُوسم', () => {
    const terms = extractKeyTerms(kt('يسدد مبلغ 750 ( سبعمائة وخمسون جنيها فقط ) شهريا'), { ocrRead: true });
    const amount = terms.filter((t) => t.kind === 'amount');
    expect(amount.length).toBeGreaterThan(0);
    expect(amount.some((t) => t.ocrUnverified)).toBe(false);
  });
  it('رقم يخالف حروفه يبقى «يلزم التحقق» (suspect) لا الوسم العام', () => {
    const t = extractKeyTerms(kt('يسدد مبلغ 76560 ( سبعمائة وخمسون جنيها فقط ) شهريا'), { ocrRead: true }).filter((x) => x.kind === 'amount');
    expect(t.some((x) => x.suspect)).toBe(true);
    expect(t.some((x) => x.ocrUnverified)).toBe(false);
  });
  it('المكتوب بالحروف فقط لا يُوسم', () => {
    const terms = extractKeyTerms(kt('يسدد مبلغ سبعمائة وخمسون جنيها شهريا'), { ocrRead: true });
    expect(terms.some((t) => t.fromWords)).toBe(true);
    expect(terms.filter((t) => t.fromWords).some((t) => t.ocrUnverified)).toBe(false);
  });
});

const clause: AuditClause = {
  clauseIndex: 1,
  clauseLabel: 'البند الأول',
  clauseTitle: null,
  clauseText: 'يسدد الطرف الثانى مبلغ 750 جنيها شهريا',
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
  originalFilename: 'عقد.pdf',
  uploadedAt: new Date('2026-11-09T10:00:00Z'),
  contractType: null,
  clientRole: null,
  clauses: [clause],
  approvedAt: null,
  approvalNote: null,
  generatedAt: new Date('2026-11-09T10:00:00Z'),
  brand: 'شيلد',
};
const OCR_WARN = 'قُرئ هذا العقد آلياً من صور ممسوحة ضوئياً (OCR). قد تحتوى القراءة أخطاء.';

describe('round 79: التقرير', () => {
  it('عقد ممسوح: الجدول يعرض الوسم والتنبيه', () => {
    const json = JSON.stringify(buildContractAuditReport({ ...base, extractionWarnings: [OCR_WARN] }).report.blocks);
    expect(json).toContain(OCR_UNVERIFIED_LABEL);
    expect(json).toContain(OCR_UNVERIFIED_NOTE.slice(0, 40));
  });
  it('عقد نصى: لا وسم', () => {
    expect(JSON.stringify(buildContractAuditReport({ ...base }).report.blocks)).not.toContain(OCR_UNVERIFIED_LABEL);
  });
  it('نسخة العميل لا تُسقط القيمة صامتة بل تعرضها موسومة', () => {
    const { report } = buildContractAuditReport({ ...base, audience: 'client', partyNames: { first: 'أ', second: 'ب' }, extractionWarnings: [OCR_WARN] });
    const json = JSON.stringify(report);
    expect(json).toContain('750');
    expect(json).toContain(OCR_UNVERIFIED_LABEL);
  });
});

describe('round 79: تسمية عقد الأتعاب', () => {
  it('التسمية تبقى فى عائلة الخدمات (الدليل لا يتغير) ولا تُقرأ وكالة', () => {
    expect(contractFamily(ATTORNEY_FEE_CONTRACT_LABEL)).toBe('services');
    expect(playbookFamily(ATTORNEY_FEE_CONTRACT_LABEL)).toBe('services');
  });
  it('isAttorneyFeeContract يميّز عقد الأتعاب من عقد الخدمات العادى', () => {
    expect(isAttorneyFeeContract('عقد اتفاق أتعاب محاماة بين الشركة والأستاذ المحامى يتقاضى أتعابا عن القضايا')).toBe(true);
    expect(isAttorneyFeeContract('عقد توريد أجهزة بين شركتين')).toBe(false);
  });
});

describe('round 79: لوج الأسطر الشبيهة بعنوان عند فجوة الترقيم', () => {
  const body = (n: string) => `${n}\nيلتزم الطرف الثانى بتقديم كافة المستندات والبيانات والمعلومات فور طلبها من الطرف الأول وإلا كان مسئولاً عن التأخير فى التنفيذ.`;
  it('فجوة (الخامس ناقص) مع ≥4 عناوين مقروءة تسجّل سطر التشخيص', () => {
    const spy = jest.spyOn(Logger.prototype, 'log').mockImplementation(() => undefined);
    const text = ['عقد اتفاق أتعاب محاماة', body('البند الأول'), body('البند الثانى'), body('البند الثالث'), body('البند الرابع'), body('البند السادس'), body('البند السابع')].join('\n');
    new SegmentationService().segment(text);
    const lines = spy.mock.calls.map((c) => String(c[0]));
    spy.mockRestore();
    expect(lines.some((l) => l.startsWith('segmentation numbering gap: missing=5'))).toBe(true);
  });
  it('ترقيم سليم: لا سطر فجوة', () => {
    const spy = jest.spyOn(Logger.prototype, 'log').mockImplementation(() => undefined);
    const text = ['عقد اتفاق أتعاب محاماة', body('البند الأول'), body('البند الثانى'), body('البند الثالث'), body('البند الرابع'), body('البند الخامس')].join('\n');
    new SegmentationService().segment(text);
    const lines = spy.mock.calls.map((c) => String(c[0]));
    spy.mockRestore();
    expect(lines.some((l) => l.startsWith('segmentation numbering gap'))).toBe(false);
  });
});
