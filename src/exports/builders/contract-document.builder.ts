import {
  type Block,
  type LegalDocument,
  DEFAULT_BRAND,
  STANDARD_DISCLAIMER,
  compactCairoDate,
  formatCairoDate,
  formatCairoDateTime,
  formatSourceRef,
  safeUrl,
  shortReference,
} from '../document-model';

export interface ContractExportClause {
  clauseIndex: number;
  clauseLabel: string;
  clauseTitle: string | null;
  clauseText: string;
  assessmentStatus: string | null;
  assessmentReasoning: string | null;
  matchedArticles: Array<{
    law: string;
    law_no: number;
    law_year: number;
    article_no: number;
    snippet: string;
    official_url: string | null;
  }> | null;
  lawyerVerdict: string | null;
  lawyerNotes: string | null;
}

export interface ContractExportInput {
  contractId: string;
  originalFilename: string;
  uploadedAt: Date;
  clauses: ContractExportClause[];
  /** null = لم يُعتمد بعد → مسودة بعلامة مائية */
  approvedAt: Date | null;
  approvalNote: string | null;
  generatedAt: Date;
  brand?: string;
}

const MAX_CLAUSE_CHARS = 3000;
const STATUS_ORDER = ['يحتاج مراجعة', 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة', 'سليم'];

/**
 * تقرير «مراجعة العقد». التقرير الآلى مسودة عمل إلى أن يعتمده مراجع بشرى (approvedAt)؛
 * قبل الاعتماد يحمل علامة مائية «مسودة» وتنويهاً صريحاً، ولا تُتاح للعميل أصلاً (راجع ExportsService).
 */
export function buildContractDocument(input: ContractExportInput): LegalDocument {
  const clauses = [...input.clauses].sort((a, b) => a.clauseIndex - b.clauseIndex);
  const approved = input.approvedAt !== null;

  const blocks: Block[] = [];
  blocks.push({
    type: 'callout',
    tone: approved ? 'info' : 'warning',
    title: approved ? 'تقرير معتمد بعد مراجعة بشرية' : 'مسودة — لم تُعتمد بعد من مراجعة بشرية',
    text: approved
      ? `اعتُمد التقرير بتاريخ ${formatCairoDate(input.approvedAt as Date)}.` +
        (input.approvalNote ? `\nملاحظة المراجع: ${input.approvalNote}` : '')
      : 'هذا التقرير ناتج التقييم الآلى وحده، وهو مسودة عمل لا يجوز تسليمها للعميل أو الاعتماد عليها قبل المراجعة البشرية.',
  });

  blocks.push({ type: 'heading', text: 'ملخص التقييم' });
  const counts = new Map<string, number>();
  for (const c of clauses) {
    const k = c.assessmentStatus ?? 'لم يُقيَّم';
    counts.set(k, (counts.get(k) ?? 0) + 1);
  }
  const keys = [...counts.keys()].sort((a, b) => {
    const ia = STATUS_ORDER.indexOf(a);
    const ib = STATUS_ORDER.indexOf(b);
    return (ia === -1 ? 99 : ia) - (ib === -1 ? 99 : ib);
  });
  blocks.push({
    type: 'table',
    columns: ['حالة التقييم', 'عدد البنود'],
    rows: [...keys.map((k) => [k, String(counts.get(k))]), ['الإجمالى', String(clauses.length)]],
  });
  blocks.push({
    type: 'paragraph',
    text:
      'التصنيف الآلى لا يعنى خلو البند من المخاطر: «سليم» تعنى أنه لم يظهر تعارض مع النصوص المفهرسة لدى المنصة فقط، ' +
      'و«لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة» تعنى أن المنصة لا تملك نصاً تقيس عليه، لا أن البند صحيح.',
  });

  blocks.push({ type: 'heading', text: 'تفصيل البنود' });
  for (const c of clauses) {
    blocks.push({
      type: 'heading',
      level: 3,
      text: c.clauseTitle ? `${c.clauseLabel} — ${c.clauseTitle}` : c.clauseLabel,
    });
    const text =
      c.clauseText.length > MAX_CLAUSE_CHARS ? `${c.clauseText.slice(0, MAX_CLAUSE_CHARS)} …(اقتُطع النص للعرض)` : c.clauseText;
    blocks.push({ type: 'quote', text, caption: 'نص البند كما ورد فى العقد' });
    if (c.assessmentStatus) {
      const tone = c.assessmentStatus === 'يحتاج مراجعة' ? 'warning' : 'note';
      blocks.push({ type: 'callout', tone, title: c.assessmentStatus, text: c.assessmentReasoning ?? '' });
    }
    (c.matchedArticles ?? []).forEach((m, i) => {
      blocks.push({
        type: 'source',
        ref: `[${i + 1}] ${formatSourceRef({ law: m.law, lawNo: m.law_no, lawYear: m.law_year, articleNo: m.article_no })}`,
        status: '',
        details: [],
        snippet: m.snippet,
        url: safeUrl(m.official_url),
      });
    });
    if (c.lawyerVerdict || c.lawyerNotes) {
      blocks.push({
        type: 'callout',
        tone: 'info',
        title: c.lawyerVerdict ? `رأي المراجع البشرى: ${c.lawyerVerdict}` : 'ملاحظة المراجع البشرى',
        text: c.lawyerNotes ?? '',
      });
    }
  }

  const reference = shortReference('CTR', input.contractId);
  return {
    kind: 'contract_report',
    brand: input.brand ?? DEFAULT_BRAND,
    title: 'تقرير مراجعة العقد',
    subtitle: input.originalFilename,
    reference,
    generatedAt: input.generatedAt,
    meta: [
      { label: 'رقم المرجع', value: reference },
      { label: 'الملف', value: input.originalFilename },
      { label: 'تاريخ الرفع', value: formatCairoDateTime(input.uploadedAt) },
      { label: 'عدد البنود', value: String(clauses.length) },
      { label: 'حالة التقرير', value: approved ? 'معتمد بعد مراجعة بشرية' : 'مسودة' },
    ],
    watermark: approved ? null : 'مسودة — غير معتمد',
    blocks,
    disclaimer: STANDARD_DISCLAIMER,
    filenameBase: `contract-${reference.slice(4).toLowerCase()}-${compactCairoDate(input.generatedAt)}${approved ? '' : '-draft'}`,
  };
}
