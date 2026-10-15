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
import { NotExportableError } from './answer-document.builder';

export interface GovernanceExportInput {
  assessmentId: string;
  requestText: string;
  /** GovernanceVerdictResponseDto كما حُفظ (JSON) — يُقرأ بحذر */
  result: unknown;
  createdAt: Date;
  generatedAt: Date;
  brand?: string;
}

const isObj = (v: unknown): v is Record<string, unknown> => typeof v === 'object' && v !== null && !Array.isArray(v);
const str = (v: unknown): string => (typeof v === 'string' ? v.trim() : '');
const strList = (v: unknown): string[] => (Array.isArray(v) ? v.map(str).filter((s) => s.length > 0) : []);
const num = (v: unknown): number | null => (typeof v === 'number' && Number.isFinite(v) ? v : null);

interface Basis {
  law: string;
  lawNo: number;
  lawYear: number;
  articleNo: number;
  snippet: string;
  officialUrl: string | null;
  sourceStatus: string;
}

function readBasis(list: unknown): Basis[] {
  if (!Array.isArray(list)) return [];
  const out: Basis[] = [];
  for (const b of list) {
    if (!isObj(b)) continue;
    const lawNo = num(b.law_no);
    const lawYear = num(b.law_year);
    const articleNo = num(b.article_no);
    const law = str(b.law);
    const snippet = str(b.snippet);
    if (!law || lawNo === null || lawYear === null || articleNo === null || !snippet) continue;
    const label = str(b.source_status);
    out.push({
      law,
      lawNo,
      lawYear,
      articleNo,
      snippet,
      officialUrl: typeof b.official_url === 'string' ? b.official_url : null,
      sourceStatus: label || computeSourceStatus({ status: 'active', lastAmended: null }),
    });
  }
  return out;
}

function sourceBlocks(list: Basis[], startAt: number): Block[] {
  return list.map((b, i) => ({
    type: 'source' as const,
    ref: `[${startAt + i + 1}] ${formatSourceRef(b)}`,
    status: b.sourceStatus,
    details: [`حالة المصدر: ${b.sourceStatus}`],
    snippet: b.snippet,
    url: safeUrl(b.officialUrl),
  }));
}

/**
 * مستند «تقييم الحوكمة والالتزام». الحكم الرسمى هو verdict وحده؛ التوصية التكميلية من الويب
 * (web_supplementary) تُعرض قسماً منفصلاً مُعلَّماً صراحةً بأنه غير موثَّق داخلياً ولا يغيّر الحكم.
 */
export function buildGovernanceDocument(input: GovernanceExportInput): LegalDocument {
  if (!isObj(input.result)) {
    throw new NotExportableError('نتيجة التقييم المحفوظة تالفة — تعذّر بناء المستند.');
  }
  const r = input.result;
  const verdict = str(r.verdict);
  if (!verdict) throw new NotExportableError('نتيجة التقييم بلا حكم — تعذّر بناء المستند.');

  const presentation = isObj(r.presentation) ? r.presentation : null;
  const recommendation = isObj(r.recommendation) ? r.recommendation : null;
  const legalBasis = readBasis(r.legal_basis);
  const violated = readBasis(recommendation?.violated_provisions);
  const penalties = readBasis(recommendation?.applicable_penalties);

  const blocks: Block[] = [];
  blocks.push({ type: 'heading', text: 'الإجراء محل التقييم' });
  blocks.push({ type: 'paragraph', text: input.requestText });

  blocks.push({ type: 'heading', text: 'الحكم' });
  const tone = verdict === 'متوافق' ? 'info' : verdict === 'معلومات غير كافية' ? 'note' : 'warning';
  blocks.push({ type: 'callout', tone, title: verdict, text: str(presentation?.direct_answer) || str(r.risk_note) });

  const kindNote = str(presentation?.verdict_kind_note);
  if (kindNote) blocks.push({ type: 'paragraph', text: kindNote });

  const riskNote = str(r.risk_note);
  if (riskNote && riskNote !== str(presentation?.direct_answer)) {
    blocks.push({ type: 'heading', text: 'ملاحظة المخاطر' });
    blocks.push({ type: 'paragraph', text: riskNote });
  }

  const warnings = strList(presentation?.warnings);
  if (warnings.length > 0) {
    blocks.push({ type: 'callout', tone: 'warning', title: 'تحذيرات', text: warnings.join('\n') });
  }

  if (recommendation) {
    const basisType = str(recommendation.basis_type);
    const advice = str(recommendation.advice);
    const reasoning = str(recommendation.reasoning);
    if (basisType === 'web_supplementary') {
      blocks.push({ type: 'heading', text: 'توصية تكميلية من بحث ويب (غير موثَّقة داخلياً)' });
      blocks.push({
        type: 'callout',
        tone: 'warning',
        title: 'لا تغيّر الحكم أعلاه',
        text:
          (str(recommendation.disclaimer) ||
            'هذه التوصية تكميلية من بحث ويب عام، وليست مبنية على قاعدة المنصة القانونية المُراجَعة.') +
          (advice ? `\nالتوصية: ${advice}` : '') +
          (reasoning ? `\n${reasoning}` : ''),
      });
      const web = Array.isArray(recommendation.web_sources) ? recommendation.web_sources : [];
      const rows = web
        .filter(isObj)
        .map((w) => [str(w.title) || '—', safeUrl(typeof w.url === 'string' ? w.url : null) ?? '—'])
        .slice(0, 8);
      if (rows.length > 0) blocks.push({ type: 'table', columns: ['المصدر', 'الرابط'], rows });
    } else {
      blocks.push({ type: 'heading', text: 'التوصية' });
      if (advice) blocks.push({ type: 'callout', tone: 'info', title: advice, text: reasoning });
      const conditions = strList(recommendation.conditions_for_compliance);
      if (conditions.length > 0) {
        blocks.push({ type: 'heading', text: 'شروط الانتقال إلى التوافق الكامل', level: 3 });
        blocks.push({ type: 'list', items: conditions, ordered: true });
      }
    }
  }

  const openIssues = strList(presentation?.open_issues);
  if (openIssues.length > 0) {
    blocks.push({ type: 'heading', text: 'مسائل غير محسومة' });
    blocks.push({ type: 'list', items: openIssues });
  }
  const toConfirm = strList(presentation?.facts_to_confirm);
  if (toConfirm.length > 0) {
    blocks.push({ type: 'heading', text: 'وقائع يلزم تأكيدها' });
    blocks.push({ type: 'list', items: toConfirm });
  }

  let n = 0;
  if (legalBasis.length > 0) {
    blocks.push({ type: 'heading', text: 'الأساس القانونى' });
    blocks.push(...sourceBlocks(legalBasis, n));
    n += legalBasis.length;
  }
  if (violated.length > 0) {
    blocks.push({ type: 'heading', text: 'الأحكام المخالفة تحديداً' });
    blocks.push(...sourceBlocks(violated, n));
    n += violated.length;
  }
  if (penalties.length > 0) {
    blocks.push({ type: 'heading', text: 'العقوبة المنطبقة' });
    const penaltyNote = str(recommendation?.penalty_note);
    if (penaltyNote) blocks.push({ type: 'paragraph', text: penaltyNote });
    blocks.push(...sourceBlocks(penalties, n));
  } else if (str(recommendation?.penalty_note)) {
    blocks.push({ type: 'heading', text: 'العقوبة' });
    blocks.push({ type: 'paragraph', text: str(recommendation?.penalty_note) });
  }

  const reference = shortReference('GOV', input.assessmentId);
  return {
    kind: 'governance',
    brand: input.brand ?? DEFAULT_BRAND,
    title: 'تقييم الحوكمة والالتزام',
    subtitle: 'مطابقة إجراء أو قرار مع النصوص القانونية واللوائح المفهرسة',
    reference,
    generatedAt: input.generatedAt,
    meta: [
      { label: 'رقم المرجع', value: reference },
      { label: 'الحكم', value: verdict },
      { label: 'تاريخ التقييم', value: formatCairoDateTime(input.createdAt) },
      { label: 'تاريخ إصدار المستند', value: formatCairoDateTime(input.generatedAt) },
    ],
    watermark: null,
    blocks,
    disclaimer: STANDARD_DISCLAIMER,
    filenameBase: `governance-${reference.slice(4).toLowerCase()}-${compactCairoDate(input.generatedAt)}`,
  };
}
