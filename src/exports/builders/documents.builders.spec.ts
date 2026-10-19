import { buildAnswerDocument, coerceStructured, NotExportableError } from './answer-document.builder';
import { buildContractDocument } from './contract-document.builder';
import { buildGovernanceDocument } from './governance-document.builder';
import type { Block } from '../document-model';

const NOW = new Date('2026-10-15T09:00:00Z');
const cit = (over: Partial<Record<string, unknown>> = {}) => ({
  law: 'قانون العمل',
  lawNo: 12,
  lawYear: 2003,
  articleNo: 154,
  status: 'active',
  lastAmended: null,
  officialUrl: 'https://example.gov.eg/law',
  snippet: 'تعويض العامل بما لا يقل عن شهرين من الأجر عن كل سنة',
  position: 0,
  ...over,
});
const base = { answerId: 'aaaaaaaa-1111-2222-3333-444444444444', question: 'سؤال', answerText: 'نص الإجابة\n\nفقرة ثانية', createdAt: NOW, generatedAt: NOW };
const ofType = <T extends Block['type']>(blocks: Block[], t: T) => blocks.filter((b) => b.type === t) as Array<Extract<Block, { type: T }>>;

describe('buildAnswerDocument', () => {
  it('يرفض إجابة بلا استشهاد (لا تُصدَّر مستنداً للاستشهاد)', () => {
    expect(() => buildAnswerDocument({ ...base, structured: null, citations: [] })).toThrow(NotExportableError);
  });

  it('وسم «نص» لا يظهر إلا بمقتطف مُتحقَّق منه وإلا يصير تفسيراً بلا مقتطف', () => {
    const doc = buildAnswerDocument({
      ...base,
      citations: [cit()],
      structured: {
        direct_answer: 'جواب',
        rulings: [
          { claim: 'حكم موثق', kind: 'نص', citation_index: 0, quote: 'تعويض العامل', quote_verified: true },
          { claim: 'حكم غير موثق', kind: 'نص', citation_index: 0, quote: 'نص مختلق', quote_verified: false },
          { claim: 'استنتاج', kind: 'تفسير', citation_index: 0, quote: null, quote_verified: false },
        ],
      },
    });
    const rulings = ofType(doc.blocks, 'ruling');
    expect(rulings.map((r) => r.label)).toEqual(['نص', 'تفسير', 'تفسير']);
    expect(rulings[0].quote).toBe('تعويض العامل');
    expect(rulings[1].quote).toBeNull();
  });

  it('يربط كل حكم بمصدره المقروء ويُظهر حالة المصدر فى الملحق', () => {
    const doc = buildAnswerDocument({
      ...base,
      citations: [cit({ status: 'amended', lastAmended: '2020-05-01' })],
      structured: { direct_answer: 'جواب', rulings: [{ claim: 'ح', kind: 'تفسير', citation_index: 0, quote: null, quote_verified: false }] },
    });
    expect(ofType(doc.blocks, 'ruling')[0].sourceRef).toBe('قانون العمل — رقم 12 لسنة 2003 — المادة 154');
    const src = ofType(doc.blocks, 'source')[0];
    expect(src.status).toBe('معدّل');
    expect(src.details.join(' ')).toContain('2020-05-01');
  });

  it('يسقط روابط غير http(s)', () => {
    const doc = buildAnswerDocument({ ...base, structured: null, citations: [cit({ officialUrl: 'javascript:alert(1)' })] });
    expect(ofType(doc.blocks, 'source')[0].url).toBeNull();
  });

  it('يرجع للنص المحفوظ حين تغيب البنية المنظَّمة أو تكون تالفة', () => {
    for (const structured of [null, 'x', {}, { direct_answer: '' }, [1]]) {
      const doc = buildAnswerDocument({ ...base, structured, citations: [cit()] });
      expect(ofType(doc.blocks, 'paragraph').map((p) => p.text)).toEqual(expect.arrayContaining(['نص الإجابة', 'فقرة ثانية']));
    }
  });

  it('مرجع واسم ملف ASCII وتنويه إلزامى', () => {
    const doc = buildAnswerDocument({ ...base, structured: null, citations: [cit()] });
    expect(doc.reference).toBe('ANS-AAAAAAAA');
    expect(doc.filenameBase).toMatch(/^answer-aaaaaaaa-\d{8}$/);
    expect(doc.disclaimer.length).toBeGreaterThan(50);
    expect(doc.watermark).toBeNull();
  });
});

describe('coerceStructured', () => {
  it('يتجاهل عناصر تالفة ويُبقى الصالح', () => {
    const s = coerceStructured({
      direct_answer: 'ج',
      rulings: [null, { claim: '', citation_index: 0 }, { claim: 'ك', citation_index: -1 }, { claim: 'سليم', citation_index: 1, kind: 'تفسير' }],
      warnings: ['a', 5, ''],
    });
    expect(s?.rulings).toHaveLength(1);
    expect(s?.warnings).toEqual(['a']);
  });
});

describe('buildGovernanceDocument', () => {
  const result = {
    verdict: 'غير متوافق',
    legal_basis: [{ law: 'ق', law_no: 80, law_year: 2002, article_no: 12, snippet: 'نص', official_url: null, source_status: 'ساري' }],
    risk_note: 'مخاطر',
    recommendation: { advice: 'غير موصى به', reasoning: 'سبب', basis_type: 'database', violated_provisions: null, applicable_penalties: null, penalty_note: null },
    presentation: { direct_answer: 'الجواب', warnings: [], open_issues: [], facts_to_confirm: [] },
  };
  const input = { assessmentId: '99999999-1111-2222-3333-444444444444', requestText: 'إجراء', createdAt: NOW, generatedAt: NOW };

  it('يعرض الحكم الرسمى والأساس القانونى', () => {
    const doc = buildGovernanceDocument({ ...input, result });
    expect(doc.meta.find((m) => m.label === 'الحكم')?.value).toBe('غير متوافق');
    expect(ofType(doc.blocks, 'source')).toHaveLength(1);
  });

  it('التوصية التكميلية من الويب قسم منفصل مُعلَّم بأنه لا يغيّر الحكم', () => {
    const doc = buildGovernanceDocument({
      ...input,
      result: { ...result, verdict: 'معلومات غير كافية', recommendation: { ...result.recommendation, basis_type: 'web_supplementary', web_sources: [{ title: 'ت', url: 'https://fra.gov.eg/x' }, { title: 'س', url: 'javascript:1' }] } },
    });
    const callouts = ofType(doc.blocks, 'callout');
    expect(callouts.some((c) => c.title === 'لا تغيّر الحكم أعلاه')).toBe(true);
    const table = ofType(doc.blocks, 'table')[0];
    expect(table.rows).toEqual([['ت', 'https://fra.gov.eg/x'], ['س', '—']]);
  });

  it('نتيجة تالفة أو بلا حكم → NotExportableError', () => {
    expect(() => buildGovernanceDocument({ ...input, result: 'x' })).toThrow(NotExportableError);
    expect(() => buildGovernanceDocument({ ...input, result: {} })).toThrow(NotExportableError);
  });
});

describe('buildContractDocument', () => {
  const clauses = [
    { clauseIndex: 2, clauseLabel: 'ب2', clauseTitle: null, clauseText: 'نص', assessmentStatus: 'سليم', assessmentReasoning: null, matchedArticles: null, riskLevel: null, suggestedWording: null, lawyerVerdict: null, lawyerNotes: null },
    { clauseIndex: 1, clauseLabel: 'ب1', clauseTitle: 'عنوان', clauseText: 'س'.repeat(5000), assessmentStatus: 'يحتاج مراجعة', assessmentReasoning: 'سبب.', matchedArticles: null, riskLevel: 'عالٍ', suggestedWording: null, lawyerVerdict: null, lawyerNotes: null },
  ];
  const input = { contractId: '11111111-2222-3333-4444-555555555555', originalFilename: 'عقد.docx', uploadedAt: NOW, generatedAt: NOW, contractType: null, clientRole: null, clauses, approvalNote: null };

  it('قبل الاعتماد: علامة مائية ومسودة، وبعده لا', () => {
    const draft = buildContractDocument({ ...input, approvedAt: null });
    expect(draft.watermark).not.toBeNull();
    expect(draft.filenameBase.endsWith('-draft')).toBe(true);
    const approved = buildContractDocument({ ...input, approvedAt: NOW });
    expect(approved.watermark).toBeNull();
    expect(approved.filenameBase.endsWith('-draft')).toBe(false);
  });

  it('يحمل تقرير التدقيق بتصميمه الخاص (الغلاف والأقسام) لا الكتل العامة', () => {
    const doc = buildContractDocument({ ...input, approvedAt: null });
    expect(doc.kind).toBe('contract_report');
    expect(doc.blocks).toEqual([]);
    expect(doc.audit?.cover.title).toBe('تقرير مراجعة وتدقيق مخاطر العقد');
  });
});
