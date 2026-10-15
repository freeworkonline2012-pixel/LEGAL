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

export interface AnswerExportCitation {
  law: string;
  lawNo: number;
  lawYear: number;
  articleNo: number;
  status: string;
  lastAmended: string | null;
  officialUrl: string | null;
  snippet: string;
  position: number;
}

export interface AnswerExportInput {
  answerId: string;
  /** السؤال كما خُزِّن (الأصل + وقائع السائل الموسومة إن وُجد استيضاح) */
  question: string;
  /** نص الإجابة المحفوظ (يُستعمل فقط حين لا توجد إجابة منظَّمة محفوظة) */
  answerText: string;
  structured: unknown;
  citations: AnswerExportCitation[];
  createdAt: Date;
  generatedAt: Date;
  brand?: string;
}

/** سبب عدم قابلية الإجابة للتنزيل — يُحوَّل إلى 409 فى الخدمة. */
export class NotExportableError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'NotExportableError';
  }
}

interface SRuling {
  claim: string;
  kind: 'نص' | 'تفسير';
  citationIndex: number;
  quote: string | null;
  quoteVerified: boolean;
}
interface SScenario {
  condition: string;
  outcome: string;
  citationIndex: number;
}
interface SFact {
  fact: string;
  effect: string;
  citationIndex: number | null;
}
interface SAnswer {
  directAnswer: string;
  factsApplied: SFact[];
  rulings: SRuling[];
  scenarios: SScenario[];
  warnings: string[];
  openIssues: string[];
  factsToConfirm: string[];
  notCovered: string[];
}

const isObj = (v: unknown): v is Record<string, unknown> => typeof v === 'object' && v !== null && !Array.isArray(v);
const str = (v: unknown): string => (typeof v === 'string' ? v.trim() : '');
const strList = (v: unknown): string[] => (Array.isArray(v) ? v.map(str).filter((s) => s.length > 0) : []);
const idx = (v: unknown): number | null => (typeof v === 'number' && Number.isInteger(v) && v >= 0 ? v : null);

/**
 * يقرأ jsonb المحفوظ بحذر (قد يكون من إصدار أقدم أو تالفاً): أى بنية لا تحوى جواباً مباشراً
 * صالحاً تُعدّ غائبة، فيرجع البناء للنص المحفوظ بدل إنتاج مستند ناقص أو منهار.
 */
export function coerceStructured(raw: unknown): SAnswer | null {
  if (!isObj(raw)) return null;
  const directAnswer = str(raw.direct_answer);
  if (!directAnswer) return null;
  const arr = (v: unknown): unknown[] => (Array.isArray(v) ? v : []);
  const rulings: SRuling[] = [];
  for (const r of arr(raw.rulings)) {
    if (!isObj(r)) continue;
    const claim = str(r.claim);
    const ci = idx(r.citation_index);
    if (!claim || ci === null) continue;
    rulings.push({
      claim,
      kind: r.kind === 'نص' ? 'نص' : 'تفسير',
      citationIndex: ci,
      quote: str(r.quote) || null,
      quoteVerified: r.quote_verified === true,
    });
  }
  const scenarios: SScenario[] = [];
  for (const s of arr(raw.scenarios)) {
    if (!isObj(s)) continue;
    const condition = str(s.condition);
    const outcome = str(s.outcome);
    const ci = idx(s.citation_index);
    if (!condition || !outcome || ci === null) continue;
    scenarios.push({ condition, outcome, citationIndex: ci });
  }
  const factsApplied: SFact[] = [];
  for (const f of arr(raw.facts_applied)) {
    if (!isObj(f)) continue;
    const fact = str(f.fact);
    const effect = str(f.effect);
    if (!fact || !effect) continue;
    factsApplied.push({ fact, effect, citationIndex: idx(f.citation_index) });
  }
  return {
    directAnswer,
    factsApplied,
    rulings,
    scenarios,
    warnings: strList(raw.warnings),
    openIssues: strList(raw.open_issues),
    factsToConfirm: strList(raw.facts_to_confirm),
    notCovered: strList(raw.not_covered),
  };
}

/**
 * يبنى مستند «إجابة قانونية مسندة». لا يُبنى إلا لإجابة موثَّقة باستشهاد واحد على الأقل:
 * الإجابة المرفوضة أو بلا مصدر لا تصلح للاستشهاد بها، فلا نُصدرها بترويسة المنصة.
 */
export function buildAnswerDocument(input: AnswerExportInput): LegalDocument {
  const citations = [...input.citations].sort((a, b) => a.position - b.position);
  if (citations.length === 0) {
    throw new NotExportableError('الإجابة بلا استشهاد موثَّق — لا تصلح للتنزيل كمستند مسنَد.');
  }

  const refOf = (i: number | null): string | null => {
    if (i === null) return null;
    const c = citations[i];
    return c ? formatSourceRef(c) : null;
  };

  const blocks: Block[] = [];
  blocks.push({ type: 'heading', text: 'السؤال' });
  blocks.push({ type: 'paragraph', text: input.question });

  const s = coerceStructured(input.structured);
  if (s) {
    blocks.push({ type: 'heading', text: 'الجواب المباشر' });
    blocks.push({ type: 'callout', tone: 'info', text: s.directAnswer });

    if (s.warnings.length > 0) {
      blocks.push({ type: 'callout', tone: 'warning', title: 'تحذيرات', text: s.warnings.join('\n') });
    }

    if (s.factsApplied.length > 0) {
      blocks.push({ type: 'heading', text: 'تطبيق على الوقائع المذكورة' });
      blocks.push({
        type: 'table',
        columns: ['الواقعة', 'أثرها القانونى', 'السند'],
        rows: s.factsApplied.map((f) => [f.fact, f.effect, refOf(f.citationIndex) ?? '—']),
      });
    }

    if (s.rulings.length > 0) {
      blocks.push({ type: 'heading', text: 'الأحكام وسندها' });
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

    if (s.scenarios.length > 0) {
      blocks.push({ type: 'heading', text: 'السيناريوهات المحتملة' });
      blocks.push({
        type: 'table',
        columns: ['إذا كانت الواقعة', 'فالنتيجة', 'السند'],
        rows: s.scenarios.map((x) => [x.condition, x.outcome, refOf(x.citationIndex) ?? '—']),
      });
    }
    if (s.openIssues.length > 0) {
      blocks.push({ type: 'heading', text: 'مسائل خلافية أو غير محسومة' });
      blocks.push({ type: 'list', items: s.openIssues });
    }
    if (s.factsToConfirm.length > 0) {
      blocks.push({ type: 'heading', text: 'وقائع يلزم تأكيدها لتصير الإجابة قاطعة' });
      blocks.push({ type: 'list', items: s.factsToConfirm });
    }
    if (s.notCovered.length > 0) {
      blocks.push({ type: 'heading', text: 'ما لا تغطيه النصوص المتاحة' });
      blocks.push({ type: 'list', items: s.notCovered });
    }
  } else {
    // مسار احتياطى: إجابات ما قبل حفظ البنية المنظَّمة، أو المسار النصى
    blocks.push({ type: 'heading', text: 'الإجابة' });
    const paragraphs = input.answerText
      .split(/\n{2,}/)
      .map((p) => p.trim())
      .filter((p) => p.length > 0);
    for (const p of paragraphs) blocks.push({ type: 'paragraph', text: p });
  }

  blocks.push({ type: 'heading', text: 'المصادر القانونية' });
  citations.forEach((c, i) => {
    const status = computeSourceStatus({ status: c.status, lastAmended: c.lastAmended });
    const details = [`حالة المصدر وقت الإجابة: ${status}`];
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

  const reference = shortReference('ANS', input.answerId);
  return {
    kind: 'answer',
    brand: input.brand ?? DEFAULT_BRAND,
    title: 'إجابة قانونية مسندة بالنصوص',
    subtitle: 'مستند للاستشهاد',
    reference,
    generatedAt: input.generatedAt,
    meta: [
      { label: 'رقم المرجع', value: reference },
      { label: 'تاريخ الإجابة', value: formatCairoDateTime(input.createdAt) },
      { label: 'تاريخ إصدار المستند', value: formatCairoDateTime(input.generatedAt) },
      { label: 'عدد المصادر', value: String(citations.length) },
    ],
    watermark: null,
    blocks,
    disclaimer: STANDARD_DISCLAIMER,
    filenameBase: `answer-${reference.slice(4).toLowerCase()}-${compactCairoDate(input.generatedAt)}`,
  };
}
