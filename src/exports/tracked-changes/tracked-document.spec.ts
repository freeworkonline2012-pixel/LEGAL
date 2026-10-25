import JSZip from 'jszip';
import { buildTrackedDocx, type TrackedClause, type TrackedInput } from './tracked-document';

const NOW = new Date('2026-10-25T10:00:00Z');
const clause = (over: Partial<TrackedClause> & { clauseIndex: number }): TrackedClause => ({
  clauseLabel: `البند ${over.clauseIndex}`,
  clauseTitle: null,
  clauseText: 'نص البند.',
  assessmentStatus: 'سليم',
  assessmentReasoning: null,
  riskLevel: null,
  matchedArticles: null,
  suggestedWording: null,
  ...over,
});

const ORIGINAL_13 = 'يجوز للطرف الأول فسخ العقد دون حاجة إلى إنذار أو تنبيه.\nويكون الفسخ بلا حكم قضائى.';
const INPUT: TrackedInput = {
  originalFilename: 'عقد.docx',
  contractType: 'عقد خدمات برمجية',
  reference: 'CTR-ABCDEF12',
  generatedAt: NOW,
  approvedAt: null,
  brand: 'شيلد',
  clauses: [
    clause({ clauseIndex: 2, clauseText: 'مدة العقد سنة واحدة.' }),
    clause({
      clauseIndex: 13,
      clauseTitle: 'الفسخ',
      clauseText: ORIGINAL_13,
      assessmentStatus: 'يحتاج مراجعة',
      riskLevel: 'عالٍ',
      assessmentReasoning: 'لا يقيّد حق الفسخ بمهلة.',
      matchedArticles: [{ law: 'القانون المدنى', law_no: 131, law_year: 1948, article_no: 158 }],
      suggestedWording: JSON.stringify({
        text: 'يجوز للطرف الأول فسخ العقد دون حاجة إلى إنذار أو تنبيه أو حكم قضائى.\nويكون الفسخ بلا حكم قضائى بعد مهلة عشرة أيام.',
        changes: ['أُضيفت مهلة عشرة أيام.'],
      }),
    }),
    clause({ clauseIndex: 5, assessmentStatus: 'يحتاج مراجعة', riskLevel: 'متوسط', assessmentReasoning: 'يلزم تحديد المدة.', clauseText: 'تحدد المدة لاحقاً.' }),
  ],
};

async function parts(buf: Buffer): Promise<{ doc: string; comments: string }> {
  const zip = await JSZip.loadAsync(buf);
  return {
    doc: await zip.file('word/document.xml')!.async('string'),
    comments: (await zip.file('word/comments.xml')?.async('string')) ?? '',
  };
}
const textOf = (xml: string, tag: 't' | 'delText') =>
  [...xml.matchAll(new RegExp(`<w:${tag}[^>]*>([^<]*)</w:${tag}>`, 'g'))].map((m) => m[1]).join('');

describe('buildTrackedDocx (الجولة 6)', () => {
  it('ملف docx صالح بتعديلات متتبَّعة فعلية (w:ins / w:del) وتعليقات Word', async () => {
    const { buffer, stats } = await buildTrackedDocx(INPUT);
    expect(buffer.subarray(0, 2).toString()).toBe('PK');
    const { doc, comments } = await parts(buffer);
    expect(doc).toContain('<w:ins ');
    expect(comments).toContain('<w:comment ');
    expect(doc).toContain('<w:commentRangeStart');
    expect(doc).toContain('<w:commentReference');
    expect(stats.trackedClauses).toBe(1);
    expect(stats.commentedClauses).toBe(2); // البند 13 (صياغة) والبند 5 (ملاحظة بلا صياغة)
    expect(stats.insertions).toBeGreaterThan(0);
  });

  it('الإضافات تحمل عبارة الصياغة الجديدة، والمؤلف منسوب للمنصة بلا اسم مستخدم', async () => {
    const { doc } = await parts((await buildTrackedDocx(INPUT)).buffer);
    const inserted = [...doc.matchAll(/<w:ins [^>]*>([\s\S]*?)<\/w:ins>/g)].map((m) => textOf(m[1], 't')).join(' ');
    expect(inserted).toContain('عشرة أيام');
    expect(doc).toContain('w:author="منصة شيلد (اقتراح آلى)"');
  });

  it('رفض كل التعديلات يعيد نص البند 13 كما قُرئ حرفياً (النص غير المُدرَج + المحذوف)', async () => {
    const { doc } = await parts((await buildTrackedDocx(INPUT)).buffer);
    const withoutIns = doc.replace(/<w:ins [\s\S]*?<\/w:ins>/g, '');
    const rejected = [...withoutIns.matchAll(/<w:(?:t|delText)[^>]*>([^<]*)<\/w:(?:t|delText)>/g)].map((m) => m[1]).join('');
    expect(rejected.replace(/\s+/g, '')).toContain(ORIGINAL_13.replace(/\s+/g, ''));
  });

  it('البند بلا صياغة يُعرض كما هو بلا أى تعديل متتبَّع، والتعليق على البند المرصود يحمل المشكلة والأساس', async () => {
    const { doc, comments } = await parts((await buildTrackedDocx(INPUT)).buffer);
    expect(textOf(doc, 't')).toContain('مدة العقد سنة واحدة.');
    expect(comments).toContain('لا يقيّد حق الفسخ بمهلة.');
    expect(comments).toContain('المادة 158 من القانون المدنى رقم 131 لسنة 1948');
    expect(comments).toContain('أُضيفت مهلة عشرة أيام.');
    expect(comments).toContain('يلزم تحديد المدة.');
  });

  it('«لا يلزم تعديل» أو صياغة تالفة لا تُنتج تعديلاً متتبَّعاً (البند يبقى نصه الأصلى)', async () => {
    for (const w of [JSON.stringify({ noChange: true, note: 'سليم' }), 'not json', JSON.stringify({ text: '' })]) {
      const input = { ...INPUT, clauses: [clause({ clauseIndex: 1, clauseText: 'نص أصلى طويل بما يكفى.', assessmentStatus: 'يحتاج مراجعة', riskLevel: 'عالٍ', suggestedWording: w })] };
      const { buffer, stats } = await buildTrackedDocx(input);
      const { doc } = await parts(buffer);
      expect(stats.trackedClauses).toBe(0);
      expect(doc).not.toContain('<w:ins ');
      expect(doc).not.toContain('<w:del ');
      expect(textOf(doc, 't')).toContain('نص أصلى طويل بما يكفى.');
    }
  });

  it('ملاحظة الاستخدام والحدود تظهر فى أول المستند، والمسودة موسومة قبل الاعتماد', async () => {
    const { doc } = await parts((await buildTrackedDocx(INPUT)).buffer);
    const text = textOf(doc, 't');
    expect(text).toContain('لا يحفظ تنسيق الملف الأصلى');
    expect(text).toContain('مسودة آلية بانتظار المراجعة البشرية');
    const approved = await parts((await buildTrackedDocx({ ...INPUT, approvedAt: NOW })).buffer);
    expect(textOf(approved.doc, 't')).toContain('بعد اعتماد المراجعة البشرية');
  });

  it('عقد بلا بنود: ملف صالح بلا تعليقات', async () => {
    const { buffer, stats } = await buildTrackedDocx({ ...INPUT, clauses: [] });
    expect(buffer.subarray(0, 2).toString()).toBe('PK');
    expect(stats).toEqual({ trackedClauses: 0, commentedClauses: 0, insertions: 0, deletions: 0 });
  });
});
