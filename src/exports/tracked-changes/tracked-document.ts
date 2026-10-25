import {
  AlignmentType,
  BorderStyle,
  CommentRangeEnd,
  CommentRangeStart,
  CommentReference,
  DeletedTextRun,
  Document,
  Footer,
  Header,
  InsertedTextRun,
  Packer,
  PageNumber,
  Paragraph,
  ShadingType,
  TextRun,
  type ParagraphChild,
} from 'docx';
import { parseRedraft } from '../audit-report/build';
import { wordDiff } from './diff';

/**
 * نسخة Word من العقد بتعديلات متتبَّعة (Track Changes): نص كل بند له صياغة مقترحة يظهر بحذفه وإضافاته الفعلية على مستوى الكلمات
 * (قابلة للقبول أو الرفض فى Word)، وتعليقات Word على البنود التى رُصدت لها ملاحظة تحمل المشكلة والأساس القانونى والتعليل.
 *
 * حدود صريحة: النص مُعاد بناؤه من بنود العقد المخزَّنة (لا من ملف Word الأصلى)، فلا يحفظ تنسيق الملف الأصلى ولا جداوله وصوره؛
 * ورفض كل التعديلات يعيد نص كل بند كما قرأته المنصة بالضبط. الصياغات اقتراحات آلية للاسترشاد لا نص معتمد.
 */

export interface TrackedClause {
  clauseIndex: number;
  clauseLabel: string;
  clauseTitle: string | null;
  clauseText: string;
  assessmentStatus: string | null;
  assessmentReasoning: string | null;
  riskLevel: string | null;
  matchedArticles: Array<{ law: string; law_no: number; law_year: number; article_no: number }> | null;
  suggestedWording: string | null;
  verification?: { status: 'confirmed' | 'unconfirmed'; reason: string } | null;
}

export interface TrackedInput {
  originalFilename: string;
  contractType: string | null;
  reference: string;
  generatedAt: Date;
  approvedAt: Date | null;
  brand: string;
  clauses: TrackedClause[];
}

export interface TrackedStats {
  trackedClauses: number;
  commentedClauses: number;
  insertions: number;
  deletions: number;
}

const FONT = { ascii: 'Arial', hAnsi: 'Arial', cs: 'Arial' };
const BODY = 24;
const SMALL = 20;
const NEEDS_REVIEW = 'يحتاج مراجعة';

function plain(text: string, o: { bold?: boolean; size?: number; color?: string } = {}): TextRun {
  return new TextRun({ text, bold: o.bold, size: o.size ?? BODY, color: o.color, font: FONT, rightToLeft: true });
}

function para(children: ParagraphChild[], extra: Partial<ConstructorParameters<typeof Paragraph>[0] & object> = {}): Paragraph {
  return new Paragraph({ bidirectional: true, alignment: AlignmentType.START, spacing: { after: 100, line: 340 }, children, ...extra });
}

function lawLine(c: TrackedClause): string | null {
  const a = c.matchedArticles ?? [];
  if (a.length === 0) return null;
  return a.map((m) => `المادة ${m.article_no} من ${m.law} رقم ${m.law_no} لسنة ${m.law_year}`).join('؛ ');
}

function commentParagraphs(c: TrackedClause, changes: string[]): Paragraph[] {
  const lines: string[] = [];
  const sev = c.riskLevel ? `الدرجة: ${c.riskLevel}` : 'الدرجة: غير مصنَّفة';
  lines.push(`ملاحظة المراجعة الآلية — ${sev}`);
  if (c.assessmentReasoning?.trim()) lines.push(`المشكلة: ${c.assessmentReasoning.trim()}`);
  const law = lawLine(c);
  if (law) lines.push(`الأساس القانونى: ${law}`);
  if (c.verification?.status === 'unconfirmed') lines.push(`غير مؤكدة — تحتاج مراجعة بشرية: ${c.verification.reason}`);
  if (changes.length > 0) lines.push(`التعديل المقترح: ${changes.join(' ')}`);
  lines.push('اقتراح آلى للاسترشاد، يُراجَع من محامٍ قبل القبول.');
  return lines.map((l) => para([plain(l, { size: SMALL })], { spacing: { after: 60 } }));
}

/** يبنى مستند Word بتعديلات متتبَّعة ويُرجع الملف وإحصاءاته. */
export async function buildTrackedDocx(input: TrackedInput): Promise<{ buffer: Buffer; stats: TrackedStats }> {
  const author = `منصة ${input.brand} (اقتراح آلى)`;
  const date = input.generatedAt;
  const revisionDate = date.toISOString();
  const stats: TrackedStats = { trackedClauses: 0, commentedClauses: 0, insertions: 0, deletions: 0 };
  let revisionId = 1000;
  let commentId = 0;
  const comments: Array<{ id: number; author: string; date: Date; children: Paragraph[] }> = [];
  const body: Paragraph[] = [];

  body.push(para([plain(`نسخة العقد بتعديلات مقترحة — ${input.originalFilename.replace(/\.(docx|pdf)$/i, '')}`, { bold: true, size: 32, color: '1F3864' })], { spacing: { after: 120 } }));
  body.push(
    para(
      [
        plain(
          `${input.contractType ? `${input.contractType} — ` : ''}المرجع ${input.reference} — ${input.approvedAt ? 'بعد اعتماد المراجعة البشرية' : 'مسودة آلية بانتظار المراجعة البشرية'}`,
          { size: SMALL, color: '595959' },
        ),
      ],
      { spacing: { after: 160 } },
    ),
  );
  body.push(
    para(
      [
        plain('كيف تقرأ هذه النسخة: ', { bold: true, size: SMALL }),
        plain(
          'الحذف والإضافة ظاهران كتعديلات متتبَّعة يمكنك قبولها أو رفضها فى Word (تبويب مراجعة). والتعليقات الجانبية تشرح المشكلة وأساسها القانونى. ' +
            'النص أُعيد بناؤه من بنود العقد كما قرأتها المنصة، فلا يحفظ تنسيق الملف الأصلى؛ ورفض كل التعديلات يعيد نص كل بند كما قُرئ. ' +
            'الصياغات اقتراحات آلية للاسترشاد ولا تُغنى عن مراجعة محامٍ قبل التوقيع.',
          { size: SMALL },
        ),
      ],
      {
        shading: { type: ShadingType.CLEAR, fill: 'FFF2CC', color: 'auto' },
        border: { right: { style: BorderStyle.SINGLE, size: 24, color: 'C55A11', space: 6 } },
        spacing: { before: 80, after: 200, line: 320 },
      },
    ),
  );

  for (const c of [...input.clauses].sort((a, b) => a.clauseIndex - b.clauseIndex)) {
    body.push(
      para([plain(c.clauseTitle ? `${c.clauseLabel}: ${c.clauseTitle}` : c.clauseLabel, { bold: true, size: 26, color: '1F3864' })], {
        spacing: { before: 240, after: 80 },
        keepNext: true,
        border: { bottom: { style: BorderStyle.SINGLE, size: 4, color: 'BFBFBF', space: 2 } },
      }),
    );

    const redraft = parseRedraft(c.suggestedWording);
    const tracked = redraft !== null && !redraft.noChange && redraft.text.trim().length > 0;
    const flagged = c.assessmentStatus === NEEDS_REVIEW;

    // أسطر الفقرات: كل سطر قائمة أبناء
    const lines: ParagraphChild[][] = [[]];
    const newLine = () => lines.push([]);
    const addRun = (kind: 'same' | 'del' | 'ins', text: string) => {
      const o = { text, font: FONT, size: BODY, rightToLeft: true };
      const last = lines[lines.length - 1];
      if (kind === 'same') last.push(new TextRun(o));
      else if (kind === 'del') {
        stats.deletions += 1;
        last.push(new DeletedTextRun({ ...o, id: revisionId++, author, date: revisionDate }));
      } else {
        stats.insertions += 1;
        last.push(new InsertedTextRun({ ...o, id: revisionId++, author, date: revisionDate }));
      }
    };
    if (tracked && redraft) {
      stats.trackedClauses += 1;
      for (const seg of wordDiff(c.clauseText, redraft.text)) {
        seg.text.split(/\r?\n/).forEach((part, k) => {
          if (k > 0) newLine();
          if (part.length > 0) addRun(seg.kind, part);
        });
      }
    } else {
      c.clauseText.split(/\r?\n/).forEach((part, k) => {
        if (k > 0) newLine();
        if (part.length > 0) addRun('same', part);
      });
    }
    const filled = lines.filter((l) => l.length > 0);
    if (filled.length === 0) filled.push([plain('(لا نص)', { color: '888888' })]);

    if (flagged || tracked) {
      stats.commentedClauses += 1;
      const id = commentId++;
      comments.push({ id, author, date, children: commentParagraphs(c, redraft?.changes ?? []) });
      filled[0].unshift(new CommentRangeStart(id));
      const last = filled[filled.length - 1];
      last.push(new CommentRangeEnd(id), new TextRun({ children: [new CommentReference(id)] }));
    }
    for (const l of filled) body.push(para(l));
  }

  const doc = new Document({
    creator: author,
    title: `نسخة بتعديلات مقترحة — ${input.originalFilename}`,
    comments: { children: comments },
    features: { trackRevisions: false },
    sections: [
      {
        properties: { page: { size: { width: 11906, height: 16838 }, margin: { top: 1200, bottom: 1200, left: 1200, right: 1200 } } },
        headers: {
          default: new Header({ children: [para([plain(`سري — منصة ${input.brand} — ${input.reference}`, { size: 16, color: '888888' })])] }),
        },
        footers: {
          default: new Footer({
            children: [
              para([new TextRun({ children: ['صفحة ', PageNumber.CURRENT, ' من ', PageNumber.TOTAL_PAGES], size: 16, color: '888888', font: FONT })], {
                alignment: AlignmentType.CENTER,
              }),
            ],
          }),
        },
        children: body,
      },
    ],
  });
  return { buffer: Buffer.from(await Packer.toBuffer(doc)), stats };
}
