import { NotExportableError } from './answer-document.builder';
import { buildMemoDocument, LAWYER_COMPLETION_ITEMS, MEMO_WATERMARK, type MemoExportInput } from './memo-document.builder';
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
const structured = {
  direct_answer: 'يستحق العامل تعويضاً عند الفصل التعسفى.',
  facts_applied: [{ fact: 'فصل دون إخطار', effect: 'يرجح الفصل التعسفى', citation_index: 0 }],
  rulings: [
    { claim: 'حكم موثق', kind: 'نص', citation_index: 0, quote: 'تعويض العامل', quote_verified: true },
    { claim: 'حكم غير موثق', kind: 'نص', citation_index: 0, quote: 'نص مختلق', quote_verified: false },
  ],
  scenarios: [{ condition: 'إن كان العقد محدد المدة', outcome: 'تختلف النتيجة', citation_index: 0 }],
  warnings: ['تحقق من سريان النص'],
  open_issues: ['خلاف حول احتساب الأجر'],
  facts_to_confirm: ['مدة الخدمة'],
  not_covered: ['الاختصاص'],
};
const base: MemoExportInput = {
  memoId: 'bbbbbbbb-1111-2222-3333-444444444444',
  memoType: 'opinion_memo',
  partyRole: 'advisory',
  title: 'مذكرة بشأن إنهاء العقد',
  issue: 'هل يستحق العامل تعويضاً؟',
  facts: 'فُصل العامل بتاريخ كذا.\nولم يُخطر.',
  requests: [],
  answerText: 'نص الإجابة\n\nفقرة ثانية',
  structured,
  citations: [cit()],
  createdAt: NOW,
  generatedAt: NOW,
};
const headings = (blocks: Block[]) => blocks.filter((b): b is Extract<Block, { type: 'heading' }> => b.type === 'heading').map((b) => b.text);
const ofType = <T extends Block['type']>(blocks: Block[], t: T) => blocks.filter((b) => b.type === t) as Array<Extract<Block, { type: T }>>;

describe('buildMemoDocument', () => {
  it('يرفض مذكرة بلا استشهاد', () => {
    expect(() => buildMemoDocument({ ...base, citations: [] })).toThrow(NotExportableError);
  });

  it('المستند دائماً مسودة بعلامة مائية وتنبيه صريح ويحوى قائمة استكمال المحامى', () => {
    for (const memoType of ['opinion_memo', 'defense_memo', 'legal_report'] as const) {
      const doc = buildMemoDocument({ ...base, memoType });
      expect(doc.watermark).toBe(MEMO_WATERMARK);
      expect(ofType(doc.blocks, 'callout')[0].text).toContain('مراجعة محامٍ مقيد');
      const lists = ofType(doc.blocks, 'list');
      expect(lists.some((l) => l.items.length === LAWYER_COMPLETION_ITEMS.length)).toBe(true);
    }
  });

  it('وسم «نص» لا يظهر إلا بمقتطف مُتحقَّق منه (قاعدة المنصة محفوظة فى المذكرات)', () => {
    const doc = buildMemoDocument(base);
    const rulings = ofType(doc.blocks, 'ruling');
    expect(rulings.map((r) => r.label)).toEqual(['نص', 'تفسير']);
    expect(rulings[1].quote).toBeNull();
  });

  it('مذكرة الرأى: الموضوع ثم الوقائع ثم الرأى ثم الأسانيد، والوقائع موسومة بأنها غير مُتحقَّق منها', () => {
    const doc = buildMemoDocument(base);
    const h = headings(doc.blocks);
    expect(h.indexOf('الموضوع')).toBeLessThan(h.indexOf('الوقائع'));
    expect(h.indexOf('الوقائع')).toBeLessThan(h.indexOf('الرأى المبدئى'));
    expect(h.indexOf('الرأى المبدئى')).toBeLessThan(h.indexOf('الأسانيد القانونية'));
    expect(ofType(doc.blocks, 'callout').some((c) => c.text.includes('لم يتحقق النظام من صحتها'))).toBe(true);
    expect(doc.kind).toBe('memo');
    expect(doc.reference).toBe('MEM-BBBBBBBB');
    expect(doc.filenameBase).toMatch(/^memo-bbbbbbbb-\d{8}$/);
  });

  it('الوقائع تُنقل كما كتبها المستخدم فقرة لكل سطر', () => {
    const doc = buildMemoDocument(base);
    const paras = ofType(doc.blocks, 'paragraph').map((p) => p.text);
    expect(paras).toContain('فُصل العامل بتاريخ كذا.');
    expect(paras).toContain('ولم يُخطر.');
  });

  it('مذكرة الدفاع: الطلبات كما كتبها المستخدم مرقَّمة، وبدونها تنبيه أن المحامى يحددها', () => {
    const withReq = buildMemoDocument({ ...base, memoType: 'defense_memo', requests: ['الحكم بالتعويض', 'إلزام المدعى عليه بالمصروفات'] });
    const list = ofType(withReq.blocks, 'list').find((l) => l.items.includes('الحكم بالتعويض'));
    expect(list?.ordered).toBe(true);
    expect(list?.items).toEqual(['الحكم بالتعويض', 'إلزام المدعى عليه بالمصروفات']);
    expect(headings(withReq.blocks)).toContain('الطلبات');

    const without = buildMemoDocument({ ...base, memoType: 'defense_memo', requests: [] });
    expect(ofType(without.blocks, 'callout').some((c) => c.text.includes('يحددها المحامى'))).toBe(true);
  });

  it('التقرير القانونى: ملخص تنفيذى أولاً، ومرجع RPT، ونوع الوثيقة legal_report', () => {
    const doc = buildMemoDocument({ ...base, memoType: 'legal_report' });
    const h = headings(doc.blocks);
    expect(h[0]).toBe('الملخص التنفيذى');
    expect(doc.kind).toBe('legal_report');
    expect(doc.reference).toBe('RPT-BBBBBBBB');
    expect(doc.filenameBase.startsWith('report-')).toBe(true);
  });

  it('صفة الطرف تظهر فى الترويسة فقط ولا تغيّر الأسانيد', () => {
    const a = buildMemoDocument({ ...base, partyRole: 'claimant' });
    const b = buildMemoDocument({ ...base, partyRole: 'defendant' });
    expect(a.meta.find((m) => m.label === 'صفة مقدِّم المستند')?.value).toContain('مدعٍ');
    expect(b.meta.find((m) => m.label === 'صفة مقدِّم المستند')?.value).toContain('مدعى عليه');
    expect(ofType(a.blocks, 'ruling')).toEqual(ofType(b.blocks, 'ruling'));
  });

  it('بلا إجابة منظَّمة صالحة يرجع للنص المحفوظ بدل مستند ناقص', () => {
    const doc = buildMemoDocument({ ...base, structured: null });
    const paras = ofType(doc.blocks, 'paragraph').map((p) => p.text);
    expect(paras).toContain('نص الإجابة');
    expect(paras).toContain('فقرة ثانية');
    expect(ofType(doc.blocks, 'source')).toHaveLength(1);
  });

  it('التحذيرات والمسائل المفتوحة والوقائع المطلوبة تنتقل من الإجابة المنظَّمة', () => {
    const doc = buildMemoDocument(base);
    const h = headings(doc.blocks);
    expect(h).toEqual(expect.arrayContaining(['مسائل خلافية أو غير محسومة', 'ما لا تغطيه النصوص المتاحة']));
    expect(ofType(doc.blocks, 'callout').some((c) => c.title === 'تحذيرات')).toBe(true);
  });

  it('يسقط روابط غير http(s) من المصادر', () => {
    const doc = buildMemoDocument({ ...base, citations: [cit({ officialUrl: 'javascript:alert(1)' })] });
    expect(ofType(doc.blocks, 'source')[0].url).toBeNull();
  });
});
