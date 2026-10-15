import { computeSourceStatus } from '../../questions/structured-answer';
import {
  type Block,
  type LegalDocument,
  DEFAULT_BRAND,
  STANDARD_DISCLAIMER,
  compactCairoDate,
  formatCairoDateTime,
  formatSourceRef,
  safeUrl,
  shortReference,
} from '../document-model';
import { type AnswerExportCitation, NotExportableError, coerceStructured } from './answer-document.builder';

export type MemoDocType = 'opinion_memo' | 'defense_memo' | 'legal_report';
export type MemoPartyRole = 'claimant' | 'defendant' | 'advisory';

export interface MemoExportInput {
  memoId: string;
  memoType: MemoDocType;
  partyRole: MemoPartyRole;
  title: string;
  issue: string;
  facts: string;
  /** الطلبات الختامية كما كتبها المستخدم (قد تكون فارغة) */
  requests: string[];
  /** الإجابة المنظَّمة المحفوظة (أسانيد المذكرة) */
  answerText: string;
  structured: unknown;
  citations: AnswerExportCitation[];
  createdAt: Date;
  generatedAt: Date;
  brand?: string;
}

export const MEMO_WATERMARK = 'مسودة — تحتاج مراجعة محامٍ';

const TYPE_LABELS: Record<MemoDocType, string> = {
  opinion_memo: 'مذكرة رأى قانونى',
  defense_memo: 'مذكرة دفاع',
  legal_report: 'تقرير قانونى',
};

const PARTY_LABELS: Record<MemoPartyRole, string> = {
  claimant: 'مدعٍ / طالب',
  defendant: 'مدعى عليه / مطلوب ضده',
  advisory: 'استشارى (بلا صفة خصومة)',
};

/** ما لا يغطيه النظام وعلى المحامى استكماله — ثابت فى كل مذكرة وتقرير. */
export const LAWYER_COMPLETION_ITEMS: readonly string[] = [
  'التحقق من صحة الوقائع المذكورة ومن المستندات المؤيدة لها (لم يتحقق النظام منها).',
  'التحقق من سريان النصوص المذكورة وتعديلاتها حتى تاريخ الاستعمال الفعلى ومطابقتها للنص الرسمى المنشور.',
  'تحديد الجهة المختصة والمواعيد القانونية (التقادم، مواعيد الطعن والإخطار) — غير مغطاة فى هذه المسودة.',
  'إضافة السوابق القضائية وآراء الفقه عند الحاجة — لا تتضمنها المسودة.',
  'المراجعة النهائية للصياغة والتوقيع بمعرفة محامٍ مقيد قبل أى تقديم لجهة قضائية أو إدارية.',
];

const DRAFT_NOTICE =
  'أُعدّت هذه المسودة آلياً. الأسانيد القانونية فيها مأخوذة من نصوص مفهرسة لدى المنصة ومُتحقَّق منها، ' +
  'أما الوقائع والطلبات فهى كما أوردها صاحب الطلب ولم يتحقق منها النظام. ' +
  'لا تُقدَّم لجهة قضائية أو إدارية قبل مراجعة محامٍ مقيد.';

/**
 * يبنى مستند مذكرة/تقرير قانونى. الأسانيد تأتى حصراً من الإجابة المنظَّمة المحفوظة (محرك الإجابات
 * المُتحقَّق منه) — لا يُضاف هنا أى حكم أو استشهاد من عندنا. الوقائع والطلبات تُنقل كما هى.
 * لا يُبنى بلا استشهاد واحد على الأقل. المستند دائماً مسودة بعلامة مائية.
 */
export function buildMemoDocument(input: MemoExportInput): LegalDocument {
  const citations = [...input.citations].sort((a, b) => a.position - b.position);
  if (citations.length === 0) {
    throw new NotExportableError('المذكرة بلا استشهاد موثَّق — لا تصلح للتنزيل.');
  }

  const refOf = (i: number | null): string | null => {
    if (i === null) return null;
    const c = citations[i];
    return c ? formatSourceRef(c) : null;
  };

  const s = coerceStructured(input.structured);
  const blocks: Block[] = [];
  blocks.push({ type: 'callout', tone: 'warning', title: 'مسودة آلية مقيَّدة بالمصادر', text: DRAFT_NOTICE });

  const factsBlock = (heading: string): void => {
    blocks.push({ type: 'heading', text: heading });
    blocks.push({
      type: 'callout',
      tone: 'note',
      text: 'الوقائع كما أوردها صاحب الطلب — لم يتحقق النظام من صحتها.',
    });
    for (const p of paragraphsOf(input.facts)) blocks.push({ type: 'paragraph', text: p });
  };

  const directAnswerBlock = (heading: string): void => {
    blocks.push({ type: 'heading', text: heading });
    if (s) blocks.push({ type: 'callout', tone: 'info', text: s.directAnswer });
    else for (const p of paragraphsOf(input.answerText)) blocks.push({ type: 'paragraph', text: p });
  };

  const groundsBlocks = (heading: string): void => {
    if (!s) return;
    if (s.factsApplied.length > 0) {
      blocks.push({ type: 'heading', text: 'تطبيق النصوص على الوقائع' });
      blocks.push({
        type: 'table',
        columns: ['الواقعة', 'أثرها القانونى', 'السند'],
        rows: s.factsApplied.map((f) => [f.fact, f.effect, refOf(f.citationIndex) ?? '—']),
      });
    }
    if (s.rulings.length > 0) {
      blocks.push({ type: 'heading', text: heading });
      for (const r of s.rulings) {
        const verified = r.kind === 'نص' && r.quoteVerified && r.quote !== null;
        blocks.push({
          type: 'ruling',
          claim: r.claim,
          // وسم «نص» لا يُعرض إلا بمقتطف حرفى مُتحقَّق منه (قاعدة المنصة) وإلا فهو تفسير
          label: verified ? 'نص' : 'تفسير',
          quote: verified ? r.quote : null,
          sourceRef: refOf(r.citationIndex) ?? 'مصدر غير محدد',
        });
      }
    }
  };

  const scenariosBlocks = (): void => {
    if (!s || s.scenarios.length === 0) return;
    blocks.push({ type: 'heading', text: 'السيناريوهات المحتملة بحسب الوقائع' });
    blocks.push({
      type: 'table',
      columns: ['إذا كانت الواقعة', 'فالنتيجة', 'السند'],
      rows: s.scenarios.map((x) => [x.condition, x.outcome, refOf(x.citationIndex) ?? '—']),
    });
  };

  const caveatsBlocks = (): void => {
    if (!s) return;
    if (s.warnings.length > 0) {
      blocks.push({ type: 'callout', tone: 'warning', title: 'تحذيرات', text: s.warnings.join('\n') });
    }
    if (s.openIssues.length > 0) {
      blocks.push({ type: 'heading', text: 'مسائل خلافية أو غير محسومة' });
      blocks.push({ type: 'list', items: s.openIssues });
    }
    if (s.factsToConfirm.length > 0) {
      blocks.push({ type: 'heading', text: 'وقائع يلزم تأكيدها لتصير النتيجة قاطعة' });
      blocks.push({ type: 'list', items: s.factsToConfirm });
    }
    if (s.notCovered.length > 0) {
      blocks.push({ type: 'heading', text: 'ما لا تغطيه النصوص المتاحة' });
      blocks.push({ type: 'list', items: s.notCovered });
    }
  };

  const lawyerBlock = (): void => {
    blocks.push({ type: 'heading', text: 'ما يستكمله المحامى قبل الاستعمال' });
    blocks.push({ type: 'list', items: [...LAWYER_COMPLETION_ITEMS], ordered: true });
  };

  if (input.memoType === 'opinion_memo') {
    blocks.push({ type: 'heading', text: 'الموضوع' });
    blocks.push({ type: 'paragraph', text: input.issue });
    factsBlock('الوقائع');
    directAnswerBlock('الرأى المبدئى');
    groundsBlocks('الأسانيد القانونية');
    scenariosBlocks();
    caveatsBlocks();
    lawyerBlock();
  } else if (input.memoType === 'defense_memo') {
    factsBlock('بيان الوقائع');
    blocks.push({ type: 'heading', text: 'المسألة القانونية' });
    blocks.push({ type: 'paragraph', text: input.issue });
    directAnswerBlock('التكييف القانونى المبدئى');
    groundsBlocks('الأسانيد القانونية ذات الصلة');
    scenariosBlocks();
    caveatsBlocks();
    blocks.push({ type: 'heading', text: 'الطلبات' });
    if (input.requests.length > 0) {
      blocks.push({ type: 'callout', tone: 'note', text: 'الطلبات كما حددها صاحب الطلب — لم يضفها النظام ولم يُقيِّم أحقيتها.' });
      blocks.push({ type: 'list', items: input.requests, ordered: true });
    } else {
      blocks.push({
        type: 'callout',
        tone: 'note',
        text: 'لم يُدخل صاحب الطلب طلبات ختامية — يحددها المحامى عند الصياغة النهائية.',
      });
    }
    lawyerBlock();
  } else {
    directAnswerBlock('الملخص التنفيذى');
    blocks.push({ type: 'heading', text: 'نطاق التقرير' });
    blocks.push({ type: 'paragraph', text: input.issue });
    factsBlock('الوقائع محل التقرير');
    groundsBlocks('النتائج وأسانيدها');
    scenariosBlocks();
    caveatsBlocks();
    lawyerBlock();
  }

  blocks.push({ type: 'heading', text: 'المصادر القانونية' });
  citations.forEach((c, i) => {
    const status = computeSourceStatus({ status: c.status, lastAmended: c.lastAmended });
    const details = [`حالة المصدر وقت الإعداد: ${status}`];
    if (c.lastAmended) details.push(`آخر تعديل معروف: ${c.lastAmended}`);
    blocks.push({
      type: 'source',
      ref: `[${i + 1}] ${formatSourceRef(c)}`,
      status,
      details,
      snippet: c.snippet,
      url: safeUrl(c.officialUrl),
    });
  });

  const isReport = input.memoType === 'legal_report';
  const reference = shortReference(isReport ? 'RPT' : 'MEM', input.memoId);
  return {
    kind: isReport ? 'legal_report' : 'memo',
    brand: input.brand ?? DEFAULT_BRAND,
    title: input.title,
    subtitle: `${TYPE_LABELS[input.memoType]} — مسودة`,
    reference,
    generatedAt: input.generatedAt,
    meta: [
      { label: 'رقم المرجع', value: reference },
      { label: 'نوع المستند', value: TYPE_LABELS[input.memoType] },
      { label: 'صفة مقدِّم المستند', value: PARTY_LABELS[input.partyRole] },
      { label: 'تاريخ الإعداد', value: formatCairoDateTime(input.createdAt) },
      { label: 'تاريخ إصدار المستند', value: formatCairoDateTime(input.generatedAt) },
      { label: 'عدد المصادر', value: String(citations.length) },
    ],
    watermark: MEMO_WATERMARK,
    blocks,
    disclaimer: STANDARD_DISCLAIMER,
    filenameBase: `${isReport ? 'report' : 'memo'}-${reference.slice(4).toLowerCase()}-${compactCairoDate(input.generatedAt)}`,
  };
}

function paragraphsOf(text: string): string[] {
  return text
    .split(/\n{1,}/)
    .map((p) => p.trim())
    .filter((p) => p.length > 0);
}
