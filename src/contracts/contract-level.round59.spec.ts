import { type LevelClause, validateModelFindings } from './contract-level';

const clauses: LevelClause[] = [
  { clauseIndex: 1, clauseLabel: 'البند السادس', clauseTitle: null, clauseText: 'لا يتنازل أى من الطرفين عن حصته للغير إلا بعد عرضها على الآخر أولاً بالسعر نفسه خلال ثلاثين يوماً.' },
  { clauseIndex: 2, clauseLabel: 'البند السابع', clauseText: 'يسدد المشترى الدفعة الأولى فى المرحلة الأولى من المشروع.', clauseTitle: null },
];
const finding = (kind: string, severity: string, evidence: Array<{ clause_index: number; quote: string }>) => ({
  findings: [{ kind, severity, title: 'عنوان الملاحظة', explanation: 'يبدو أن المصطلح غير معرَّف.', evidence }],
});

describe('الجولة 59: سقف «مصطلح غير معرَّف» من النموذج', () => {
  it('يُخفَّض إلى «منخفض» مهما كانت الدرجة التى اقترحها النموذج', () => {
    const r = validateModelFindings(finding('undefined_term', 'عالٍ', [{ clause_index: 1, quote: 'إلا بعد عرضها على الآخر أولاً بالسعر نفسه' }]), clauses);
    expect(r).toHaveLength(1);
    expect(r[0].severity).toBe('منخفض');
  });
  it('لا يمس درجة التعارض ولا الشرط المفتوح', () => {
    const open = validateModelFindings(finding('open_term', 'عالٍ', [{ clause_index: 2, quote: 'يسدد المشترى الدفعة الأولى فى المرحلة الأولى من المشروع' }]), clauses);
    expect(open[0].severity).toBe('عالٍ');
  });
});
