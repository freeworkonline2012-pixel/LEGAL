import { redactForPreview } from './preview-redaction';
import type { ContractResponseDto } from './dto/contract-response.dto';

const full = {
  id: 'c1',
  original_filename: 'عقد.docx',
  status: 'processed',
  extraction_error: null,
  clause_count: 1,
  contract_type: 'عقد إيجار',
  client_role: 'المستأجر',
  client_party: 'second',
  warnings: [],
  contract_findings: [
    { id: 'ع1', kind: 'missing_clause', kind_label: 'بند ناقص', severity: 'عالٍ', title: 'لا بند للفسخ', explanation: 'شرح مفصل', suggestion: 'أضف بنداً', evidence: [{ clause_index: 1, clause_label: 'البند 1', quote: 'اقتباس' }], source: 'rule', verification: { status: 'confirmed', basis: 'confirmed', reason: 'ر', quote: null } },
  ],
  contract_findings_model: 'ok',
  clauses: [
    {
      id: 'cl1', clause_index: 1, clause_label: 'البند الأول', clause_title: 'الأجرة', clause_type_guess: 'rent', clause_text: 'نص البند كما رفعه العميل',
      assessment_status: 'يحتاج مراجعة', assessment_reasoning: 'تفسير مدفوع', matched_articles: [{ law: 'ق', law_no: 131, law_year: 1948, article_no: 1, snippet: 's', official_url: null }],
      assessment_confidence: 0.9, rule_findings: [], verification: { status: 'confirmed', basis: 'confirmed', reason: 'ر', quote: null },
      suggested_redraft: { text: 'صياغة', changes: ['x'], disclaimer: 'd', no_change: false, note: null },
    },
  ],
  processing: null,
  created_at: new Date(),
} as unknown as ContractResponseDto;

describe('redactForPreview', () => {
  const out = redactForPreview(full);

  it('يُخفى ما يُدفع مقابله ويُعلَّم details_locked', () => {
    expect(out.details_locked).toBe(true);
    const c = out.clauses![0];
    expect(c.assessment_reasoning).toBeNull();
    expect(c.matched_articles).toBeNull();
    expect(c.rule_findings).toBeNull();
    expect(c.verification).toBeNull();
    expect(c.suggested_redraft).toBeNull();
    expect(c.assessment_confidence).toBeNull();
    const f = out.contract_findings![0];
    expect(f.explanation).toBe('');
    expect(f.suggestion).toBeNull();
    expect(f.evidence).toEqual([]);
    expect(f.verification).toBeNull();
  });

  it('يبقى ما يخص العميل: نص بنده وحالة كل بند وعنوان الملاحظة ودرجتها', () => {
    const c = out.clauses![0];
    expect(c.clause_text).toBe('نص البند كما رفعه العميل');
    expect(c.assessment_status).toBe('يحتاج مراجعة');
    expect(c.clause_label).toBe('البند الأول');
    expect(out.contract_findings![0].title).toBe('لا بند للفسخ');
    expect(out.contract_findings![0].severity).toBe('عالٍ');
    expect(out.status).toBe('processed');
  });

  it('نقية: لا تعدّل المدخل', () => {
    expect(full.clauses![0].assessment_reasoning).toBe('تفسير مدفوع');
    expect(full.details_locked).toBeUndefined();
    expect(full.contract_findings![0].explanation).toBe('شرح مفصل');
  });

  it('عقد بلا بنود أو ملاحظات (قيد المعالجة) لا ينهار', () => {
    const r = redactForPreview({ ...full, clauses: [], contract_findings: undefined } as unknown as ContractResponseDto);
    expect(r.clauses).toEqual([]);
    expect(r.contract_findings).toEqual([]);
  });
});
