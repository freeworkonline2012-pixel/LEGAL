import { createHash } from 'crypto';
import { DEFAULT_BRAND, STANDARD_DISCLAIMER, formatCairoDate, safeUrl, shortReference } from '../document-model';
import { findOcrNoiseTokens, OCR_NOISE_NOTE } from '../../contracts/ocr-noise.util';
import { extractKeyTerms, KEY_TERM_KIND_LABEL } from '../../contracts/key-terms';
import { type AuditReport, type Cell, type RBlock, type Tone } from './model';

export type Severity = 'حرج' | 'عالٍ' | 'متوسط' | 'غير مصنَّف';

export interface AuditClause {
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
  riskLevel: string | null;
  suggestedWording: string | null;
  lawyerVerdict: string | null;
  lawyerNotes: string | null;
  /** نتيجة المدقق المستقل؛ null/غائبة = لم يُجرَ التحقق */
  verification?: AuditVerification | null;
}

export interface AuditVerification {
  status: 'confirmed' | 'unconfirmed';
  reason: string;
  quote?: string | null;
}

/** صياغة التحقق المستقل فى التقرير: «مؤكدة» أو «غير مؤكدة — تحتاج مراجعة بشرية» مع السبب والاقتباس الموثَّق. */
function verificationText(v: AuditVerification): string {
  const head = v.status === 'confirmed' ? 'اجتازت التحقق المستقل (مدقق ثانٍ بتعليمات معاكسة)' : 'غير مؤكدة — تحتاج مراجعة بشرية: اعترض المدقق المستقل المعاكس أو لم يستطع الجزم';
  const quote = v.quote ? ` الاقتباس: «${oneLine(v.quote)}».` : '';
  return `${head}. ${oneLine(v.reason)}${quote}`;
}

export interface AuditReportInput {
  contractId: string;
  originalFilename: string;
  uploadedAt: Date;
  contractType: string | null;
  clientRole: string | null;
  /** أى الطرفين فى نص العقد هو العميل (إن حُدِّد). */
  clientParty?: 'first' | 'second' | null;
  clauses: AuditClause[];
  approvedAt: Date | null;
  approvalNote: string | null;
  /** تحذيرات الاستخراج المحفوظة وقت الرفع (OCR، ترقيم، نص غير مُقسَّم)؛ تُعرض فى الغلاف والملخص. */
  extractionWarnings?: string[] | null;
  /** ملاحظات العقد ككل (الجولة 3)؛ undefined/null = لم يُجرَ التحليل (عقد قديم) فلا يظهر القسم. */
  contractFindings?: AuditContractFinding[] | null;
  /** حالة تمرير النموذج على العقد كاملاً؛ تظهر ملاحظة إن لم يكتمل. */
  contractFindingsModel?: 'ok' | 'not_configured' | 'skipped' | 'error' | null;
  generatedAt: Date;
  brand?: string;
}

export interface AuditContractFinding {
  kind: string;
  kindLabel: string;
  severity: string;
  title: string;
  explanation: string;
  suggestion: string | null;
  evidence: Array<{ clauseLabel: string; quote: string }>;
  verification?: AuditVerification | null;
}

const NEEDS_REVIEW = 'يحتاج مراجعة';
/** بادئة تسمية البند الذى يُدرجه المقسِّم لنص سابق لأول عنوان مُتعرَّف (راجع SegmentationService). */
const UNSEGMENTED_PREFIX = 'نص سابق لـ';
const NO_TEXT = 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة';
const SEVERITY_ORDER: Severity[] = ['حرج', 'عالٍ', 'متوسط', 'غير مصنَّف'];
const SEVERITY_TONE: Record<Severity, Tone> = { حرج: 'critical', عالٍ: 'high', متوسط: 'medium', 'غير مصنَّف': 'grey' };
const LETTERS = ['أ', 'ب', 'ج', 'د', 'هـ', 'و', 'ز', 'ح', 'ط', 'ي'];

export interface Redraft {
  noChange: boolean;
  text: string;
  changes: string[];
  note: string | null;
}

export function parseRedraft(raw: string | null): Redraft | null {
  if (!raw) return null;
  try {
    const p = JSON.parse(raw) as { noChange?: boolean; note?: unknown; text?: unknown; changes?: unknown };
    if (p.noChange === true) {
      return { noChange: true, text: '', changes: [], note: typeof p.note === 'string' && p.note ? p.note : null };
    }
    if (typeof p.text !== 'string' || !p.text) return null;
    return {
      noChange: false,
      text: p.text,
      changes: Array.isArray(p.changes) ? p.changes.filter((c): c is string => typeof c === 'string' && c.trim().length > 0) : [],
      note: null,
    };
  } catch {
    return null;
  }
}

function severityOf(c: AuditClause): Severity | null {
  if (c.assessmentStatus !== NEEDS_REVIEW) return null;
  return c.riskLevel === 'حرج' || c.riskLevel === 'عالٍ' || c.riskLevel === 'متوسط' ? c.riskLevel : 'غير مصنَّف';
}

/** «5 بنود حرجة» بصرف صحيح للعدد (1 / 2 / 3–10 / 11+). */
function countPhrase(n: number, adj: [string, string, string, string]): string {
  if (n === 1) return `1 بند ${adj[0]}`;
  if (n === 2) return `2 بندان ${adj[1]}`;
  if (n <= 10) return `${n} بنود ${adj[2]}`;
  return `${n} بنداً ${adj[3]}`;
}
/** «بند واحد / بندان / 5 بنود / 12 بنداً» (العدد والمعدود). */
function bands(n: number): string {
  if (n === 0) return 'لا بنود';
  if (n === 1) return 'بند واحد';
  if (n === 2) return 'بندان';
  if (n <= 10) return `${n} بنود`;
  return `${n} بنداً`;
}
const ADJ = {
  critical: ['حرج', 'حرجان', 'حرجة', 'حرجاً'] as [string, string, string, string],
  high: ['عالٍ', 'عاليان', 'عالية', 'عالياً'] as [string, string, string, string],
  medium: ['متوسط', 'متوسطان', 'متوسطة', 'متوسطاً'] as [string, string, string, string],
  review: ['للمراجعة', 'للمراجعة', 'مراجعة', 'للمراجعة'] as [string, string, string, string],
};

function oneLine(text: string): string {
  return text.replace(/\s+/g, ' ').trim();
}

function clip(text: string, max: number): string {
  const t = oneLine(text);
  if (t.length <= max) return t;
  const cut = t.slice(0, max);
  const sp = cut.lastIndexOf(' ');
  return `${(sp > max * 0.6 ? cut.slice(0, sp) : cut).trim()}…`;
}

function firstSentence(text: string): string {
  const t = oneLine(text);
  const m = t.match(/^(.+?[.؟!])(\s|$)/);
  return m ? m[1] : t;
}

function clauseHeading(c: AuditClause): string {
  return c.clauseTitle ? `${c.clauseLabel}: ${c.clauseTitle}` : c.clauseLabel;
}

function hostOf(url: string | null): string {
  const u = safeUrl(url);
  if (!u) return 'غير متاح';
  try {
    return new URL(u).host;
  } catch {
    return 'غير متاح';
  }
}

function lawName(a: { law: string; law_no: number; law_year: number }): string {
  return `${a.law} رقم ${a.law_no} لسنة ${a.law_year}`;
}

const RISK_TEXT: Record<Severity, string> = {
  حرج: 'يخالف البند نصاً آمراً ثابتاً بعبارة حرفية من النصوص المفهرسة، وقد لا ينتج أثره القانونى كاملاً؛ يلزم تعديله قبل التوقيع.',
  عالٍ: 'يخرج البند عن القاعدة المقررة فى النص المذكور، ويستحق نظر محامٍ مختص لتقدير أثر هذا الاختلاف قبل التوقيع.',
  متوسط: 'يحتاج البند إلى مراجعة بشرية لتقدير أثره؛ ولم يثبت تعارضه مع نص آمر موثَّق.',
  'غير مصنَّف': 'لم تتحدد درجة خطورة هذا البند آلياً؛ يلزم مراجعة قانونية بشرية.',
};

const TIMELINE: Record<Severity, string> = {
  حرج: 'فوري — قبل التوقيع',
  عالٍ: 'خلال أسبوع',
  متوسط: 'خلال أسبوعين',
  'غير مصنَّف': 'بعد المراجعة البشرية',
};
const PRIORITY: Record<Severity, string> = { حرج: 'حرجة', عالٍ: 'عالية', متوسط: 'متوسطة', 'غير مصنَّف': 'غير محدَّدة' };
const PRIORITY_NOTE: Record<Severity, string> = {
  حرج: 'شرط مانع للتوقيع',
  عالٍ: 'يُنصح بتسويته قبل التوقيع',
  متوسط: '—',
  'غير مصنَّف': '—',
};

/** أثقل درجة بين بنود العقد وملاحظاته ككل (غير المؤكدة لا ترفع المستوى العام؛ تُعرض موسومة فقط). */
function overallRisk(counts: Record<Severity, number>, findingCounts: { critical: number; high: number; medium: number }): { text: string; tone: Tone } {
  if (counts['حرج'] > 0 || findingCounts.critical > 0) return { text: 'مخاطرة مرتفعة — يستوجب التفاوض الفوري', tone: 'critical' };
  if (counts['عالٍ'] > 0 || findingCounts.high > 0) return { text: 'مخاطرة مرتفعة نسبياً — يستوجب المراجعة قبل التوقيع', tone: 'high' };
  if (counts['متوسط'] + counts['غير مصنَّف'] > 0 || findingCounts.medium > 0) return { text: 'مخاطرة متوسطة — يستحق المراجعة', tone: 'medium' };
  return { text: 'لم تُرصد بنود تحتاج مراجعة وفق النصوص المفهرسة (لا يُغنى ذلك عن مراجعة محامٍ)', tone: 'info' };
}

const FINDING_TONE = (sev: string): Tone => (sev === 'حرج' ? 'critical' : sev === 'عالٍ' ? 'high' : sev === 'متوسط' ? 'medium' : 'grey');

/**
 * يبنى تقرير «مراجعة وتدقيق مخاطر العقد» بالشكل المعتمد. كل ما فيه مشتق من بيانات محفوظة وموثَّقة (حالة البند، شرحه الذى
 * اجتاز الحواجز، المواد المعتمدة، الصياغات المقترحة التى اجتازت البوابة)؛ لا تُضاف أرقام ولا مراجع ولا أحكام من خارجها.
 */
export function buildContractAuditReport(input: AuditReportInput): { report: AuditReport; reference: string } {
  const clauses = [...input.clauses].sort((a, b) => a.clauseIndex - b.clauseIndex);
  const brand = input.brand ?? DEFAULT_BRAND;
  const approved = input.approvedAt !== null;
  const reference = shortReference('CTR', input.contractId);

  const counts: Record<Severity, number> = { حرج: 0, عالٍ: 0, متوسط: 0, 'غير مصنَّف': 0 };
  const risky: Array<{ c: AuditClause; sev: Severity; n: number; redraft: Redraft | null }> = [];
  const ordered = clauses
    .map((c) => ({ c, sev: severityOf(c) }))
    .filter((x): x is { c: AuditClause; sev: Severity } => x.sev !== null)
    .sort((a, b) => SEVERITY_ORDER.indexOf(a.sev) - SEVERITY_ORDER.indexOf(b.sev) || a.c.clauseIndex - b.c.clauseIndex);
  ordered.forEach((x, i) => {
    counts[x.sev] += 1;
    risky.push({ ...x, n: i + 1, redraft: parseRedraft(x.c.suggestedWording) });
  });
  const totalRisky = risky.length;
  // النص السابق لأول بند مُتعرَّف عليه (يُدرجه المقسِّم) ليس بنداً: يُذكر على حدة ولا يدخل فى أعداد البنود
  const unsegmentedBlocks = clauses.filter((c) => c.clauseLabel.startsWith(UNSEGMENTED_PREFIX));
  const baseClauses = clauses.filter((c) => !c.clauseLabel.startsWith(UNSEGMENTED_PREFIX));
  const noTextClauses = baseClauses.filter((c) => c.assessmentStatus === NO_TEXT);
  const soundClauses = baseClauses.filter((c) => c.assessmentStatus === 'سليم');
  const unassessed = baseClauses.filter((c) => c.assessmentStatus === null);

  // القوانين المستشهد بها (بترتيب أول ظهور) والمواد لكل قانون
  type LawEntry = {
    name: string;
    articles: Map<number, { snippet: string; url: string | null }>;
    clauseLabels: Set<string>;
  };
  const laws = new Map<string, LawEntry>();
  for (const c of clauses) {
    for (const m of c.matchedArticles ?? []) {
      const key = lawName(m);
      const e = laws.get(key) ?? { name: key, articles: new Map(), clauseLabels: new Set<string>() };
      if (!e.articles.has(m.article_no)) e.articles.set(m.article_no, { snippet: m.snippet, url: safeUrl(m.official_url) });
      e.clauseLabels.add(c.clauseLabel);
      laws.set(key, e);
    }
  }
  const lawList = [...laws.values()];

  const findings = input.contractFindings ?? [];
  const confirmedFindings = findings.filter((f) => f.verification?.status !== 'unconfirmed');
  const findingCounts = {
    critical: confirmedFindings.filter((f) => f.severity === 'حرج').length,
    high: confirmedFindings.filter((f) => f.severity === 'عالٍ').length,
    medium: confirmedFindings.filter((f) => f.severity === 'متوسط').length,
  };
  const overall = overallRisk(counts, findingCounts);
  const year = new Intl.DateTimeFormat('en', { timeZone: 'Africa/Cairo', year: 'numeric' }).format(input.generatedAt);
  const dateText = formatCairoDate(input.generatedAt);

  // ---------- الغلاف ----------
  const coverRows: AuditReport['cover']['rows'] = [];
  if (input.contractType) coverRows.push({ label: 'موضوع العقد', value: input.contractType });
  coverRows.push({ label: 'ملف العقد', value: input.originalFilename });
  if (input.clientRole) {
    const party = input.clientParty === 'first' ? 'الطرف الأول' : input.clientParty === 'second' ? 'الطرف الثانى' : null;
    coverRows.push({ label: 'منظور التدقيق (العميل)', value: party ? `${input.clientRole} — ${party} فى نص العقد` : input.clientRole });
  }
  coverRows.push({
    label: 'القانون الحاكم',
    value:
      lawList.length > 0
        ? `القانون المصرى — ${lawList
            .slice(0, 3)
            .map((l) => l.name)
            .join('، ')}${lawList.length > 3 ? ' وغيرها' : ''}`
        : 'القانون المصرى',
  });
  const realCount = baseClauses.length;
  coverRows.push({
    label: 'عدد البنود',
    value: unsegmentedBlocks.length > 0 ? `${realCount} + نص سابق غير مُقسَّم` : String(clauses.length),
  });
  const warnings = (input.extractionWarnings ?? []).filter((w) => w.trim().length > 0);
  const ocrRead = warnings.some((w) => w.includes('OCR'));
  const realClauses = baseClauses;
  const assessedCount = realClauses.filter((c) => c.assessmentStatus === 'سليم' || c.assessmentStatus === NEEDS_REVIEW).length;
  const notAssessedCount = realClauses.length - assessedCount;
  coverRows.push({
    label: 'نطاق التغطية',
    value: `${assessedCount} من ${realClauses.length} بنداً قُيِّمت مقابل نصوص قانونية مفهرسة`,
    ...(notAssessedCount > 0 ? { tone: 'high' as Tone } : {}),
  });
  if (warnings.length > 0) {
    coverRows.push({ label: 'تنبيه الاستخراج', value: 'يحتوى تحذيرات قراءة/تقسيم — راجع القسم 1', tone: 'medium' });
  }
  coverRows.push({ label: 'تاريخ التقرير', value: dateText });
  coverRows.push({
    label: 'حالة التقرير',
    value: approved ? 'معتمد بعد مراجعة بشرية' : 'مسودة آلية — بانتظار المراجعة البشرية',
  });
  coverRows.push({ label: 'مستوى المخاطرة العام', value: overall.text, tone: overall.tone });

  const blocks: RBlock[] = [];
  let section = 0;
  const banner = (text: string) => {
    section += 1;
    blocks.push({ t: 'banner', text: `${section}. ${text}` });
  };

  // ---------- 1. الملخص التنفيذى ----------
  blocks.push({ t: 'pagebreak' });
  banner('الملخص التنفيذى');
  if (notAssessedCount > 0) {
    blocks.push({
      t: 'note',
      label: 'نطاق التغطية:',
      text:
        `قُيِّم ${bands(assessedCount)} فقط من أصل ${bands(realClauses.length)} مقابل نصوص قانونية مفهرسة. أما ${bands(notAssessedCount)} الأخرى فلم يوجد نص مفهرس يحكمها مباشرة، ` +
        'فلم تُقيَّم قانونياً؛ وهذا لا يعنى سلامتها، بل يلزم أن يراجعها محامٍ مختص قبل التوقيع (توازنها التجارى ووضوحها وقابليتها للتنفيذ خارج نطاق هذا التقرير الآلى).',
    });
  }
  for (const w of warnings) {
    blocks.push({ t: 'note', label: 'تنبيه الاستخراج:', text: w });
  }
  const partyPhrase =
    input.clientParty === 'first' ? ' (الطرف الأول فى نص العقد)' : input.clientParty === 'second' ? ' (الطرف الثانى فى نص العقد)' : '';
  const position =
    input.clientRole && input.contractType
      ? ` وقيس كل بند منظوراً إليه من جهة «${input.clientRole}» فى ${input.contractType}${partyPhrase}.`
      : input.clientRole
        ? ` وقيس كل بند منظوراً إليه من جهة «${input.clientRole}»${partyPhrase}.`
        : '';
  const lawsPhrase = lawList.length > 0 ? ` ومنها: ${lawList.map((l) => l.name).join('، ')}` : '';
  if (totalRisky > 0) {
    const dist: string[] = [];
    if (counts['حرج']) dist.push(`حرجة (${counts['حرج']})`);
    if (counts['عالٍ']) dist.push(`عالية الخطورة (${counts['عالٍ']})`);
    if (counts['متوسط']) dist.push(`متوسطة (${counts['متوسط']})`);
    if (counts['غير مصنَّف']) dist.push(`غير مصنَّفة الدرجة (${counts['غير مصنَّف']})`);
    blocks.push({
      t: 'p',
      text:
        `رُصد فى هذا العقد ${bands(totalRisky)} ${totalRisky === 1 ? 'يحتاج' : totalRisky === 2 ? 'يحتاجان' : 'تحتاج'} مراجعة من أصل ${bands(baseClauses.length)}، ` +
        `${totalRisky === 1 ? 'وهو' : totalRisky === 2 ? 'وهما' : 'وهى'} بحسب الخطورة: ${dist.join('، ')}. ` +
        `ويرتكز هذا التحليل على النصوص القانونية المصرية المفهرسة لدى المنصة${lawsPhrase}.${position}`,
    });
  } else {
    blocks.push({
      t: 'p',
      text:
        `لم تُرصد فى هذا العقد بنود تحتاج مراجعة وفق النصوص القانونية المصرية المفهرسة لدى المنصة، من أصل ${bands(baseClauses.length)}.${position}`,
    });
  }
  blocks.push({
    t: 'strip',
    cells: [
      { text: countPhrase(counts['متوسط'], ADJ.medium), tone: 'medium' },
      { text: countPhrase(counts['عالٍ'], ADJ.high), tone: 'high' },
      { text: countPhrase(counts['حرج'], ADJ.critical), tone: 'critical' },
      { text: countPhrase(totalRisky, ADJ.review), tone: 'navy' },
    ],
  });
  blocks.push({
    t: 'p',
    text:
      `من بقية البنود: ${bands(soundClauses.length)} لم يظهر فيها اختلاف عن النصوص المفهرسة، و${bands(noTextClauses.length)} لا يوجد نص قانونى مصرى مفهرس يحكمها مباشرة` +
      ` (وهذا لا يعنى صحتها، بل أن المنصة لا تملك نصاً تقيس عليه).` +
      (unassessed.length > 0 ? ` و${bands(unassessed.length)} لم تُقيَّم.` : '') +
      (unsegmentedBlocks.length > 0 ? ' ويضاف إليها نص سابق لأول بند مُتعرَّف عليه لم يُقسَّم إلى بنود، فلم يُقيَّم كبنود مستقلة.' : ''),
  });
  const hasRedrafts = risky.some((r) => r.redraft && !r.redraft.noChange);
  blocks.push({
    t: 'p',
    text:
      'يُقدّم هذا التقرير لكل بند يحتاج مراجعة: تحليل المخاطرة، والأساس القانونى المستند إلى النصوص المصرية المفهرسة' +
      (hasRedrafts ? '، والتعديل التعاقدى المقترح، والتعليق القانونى.' : '.'),
  });

  // أهم ما يستوجب الانتباه (بنود وملاحظات على العقد ككل) والتوصية الآلية
  {
    const rank = (sev: string): number => ['حرج', 'عالٍ', 'متوسط'].indexOf(sev) === -1 ? 3 : ['حرج', 'عالٍ', 'متوسط'].indexOf(sev);
    type Top = { where: string; text: string; sev: string; tone: Tone; order: number };
    const tops: Top[] = [
      ...risky.map((r) => ({
        where: r.c.clauseLabel,
        text: clip(firstSentence(r.c.assessmentReasoning ?? ''), 150) || clauseHeading(r.c),
        sev: r.sev as string,
        tone: SEVERITY_TONE[r.sev],
        order: 0,
      })),
      ...findings.map((f) => ({
        where: f.evidence.length > 0 ? [...new Set(f.evidence.map((e) => e.clauseLabel))].join('، ') : 'العقد ككل',
        text: clip(f.title, 150) + (f.verification?.status === 'unconfirmed' ? ' (غير مؤكدة)' : ''),
        sev: f.severity,
        tone: FINDING_TONE(f.severity),
        order: 1,
      })),
    ]
      .map((t, i) => ({ t, i }))
      .sort((a, b) => rank(a.t.sev) - rank(b.t.sev) || a.t.order - b.t.order || a.i - b.i)
      .map((x) => x.t);
    const serious = tops.filter((t) => rank(t.sev) <= 1);
    const shown = (serious.length > 0 ? serious : tops).slice(0, 5);
    if (shown.length > 0) {
      blocks.push({ t: 'h3', text: 'أهم ما يستوجب الانتباه', rule: true });
      blocks.push({
        t: 'grid',
        columns: ['#', 'الموضع', 'الملاحظة', 'الدرجة'],
        widths: [6, 22, 56, 16],
        rows: shown.map((t, i) => [
          { text: String(i + 1), center: true },
          { text: t.where },
          { text: t.text },
          { text: t.sev, tone: t.tone, center: true },
        ]),
      });
    }
    const recommendation =
      counts['حرج'] > 0 || findingCounts.critical > 0
        ? 'التوصية الآلية: لا يُوصى بالتوقيع قبل معالجة الملاحظات الحرجة وعرضها على محامٍ مختص.'
        : counts['عالٍ'] > 0 || findingCounts.high > 0
          ? 'التوصية الآلية: يُوصى بمعالجة الملاحظات عالية الخطورة قبل التوقيع، وعرضها على محامٍ مختص.'
          : totalRisky > 0 || findings.length > 0
            ? 'التوصية الآلية: يُوصى بمراجعة بشرية للملاحظات المرصودة قبل التوقيع.'
            : 'التوصية الآلية: لم تُرصد ملاحظات فى النطاق المقيَّس آلياً؛ وتبقى مراجعة المحامى شرطاً قبل التوقيع.';
    const hasUnconfirmed = findings.some((f) => f.verification?.status === 'unconfirmed');
    blocks.push({
      t: 'note',
      label: 'توصية:',
      text: hasUnconfirmed ? `${recommendation} الملاحظات الموسومة «غير مؤكدة» لا ترفع مستوى المخاطرة العام ولا تُبنى عليها هذه التوصية.` : recommendation,
    });
  }

  // ---------- الشروط الرئيسية ----------
  {
    const terms = extractKeyTerms(clauses);
    banner('الشروط الرئيسية للعقد');
    if (terms.length === 0) {
      blocks.push({ t: 'p', text: 'لم تُستخرج مبالغ أو نسب أو مدد أو تواريخ من نص العقد بالقراءة الآلية.' });
    } else {
      blocks.push({
        t: 'p',
        text:
          'مبالغ ونسب ومدد وتواريخ مستخرجة آلياً من نص البنود، وأمام كل شرط الجزء الحرفى من العقد الذى استُخرج منه. ' +
          'ما كُتب بالحروف فقط يُعرض مقروءاً بالأرقام ويُوسَم «بالحروف». يلزم مطابقة الأرقام على أصل العقد قبل الاعتماد، وخاصة فى العقود الممسوحة ضوئياً.',
      });
      blocks.push({
        t: 'grid',
        columns: ['النوع', 'القيمة', 'البند', 'من نص العقد'],
        widths: [10, 20, 16, 54],
        rows: terms.map((t) => [
          { text: KEY_TERM_KIND_LABEL[t.kind], tone: 'info' as Tone, center: true },
          { text: t.fromWords ? `${t.value} (بالحروف)` : t.value, bold: true },
          { text: t.clauseLabel, center: true },
          { text: t.quote },
        ]),
      });
    }
  }

  // ---------- 2. مصفوفة تحليل المخاطر ----------
  banner('مصفوفة تحليل المخاطر');
  if (totalRisky === 0 && findings.length === 0) {
    blocks.push({ t: 'p', text: 'لا توجد بنود تحتاج مراجعة فى هذا العقد وفق النصوص المفهرسة.' });
  } else {
    const rows: Cell[][] = risky.map((r) => {
      const verdict = r.c.lawyerVerdict ? ` — رأى المراجع: ${r.c.lawyerVerdict}` : '';
      let status: Cell;
      const unconfirmed = r.c.verification?.status === 'unconfirmed' ? ' — غير مؤكدة' : '';
      if (r.redraft && !r.redraft.noChange) status = { text: `صياغة مقترحة — بانتظار مراجعة محامٍ${unconfirmed}${verdict}`, tone: 'medium', bold: false };
      else if (r.redraft?.noChange) status = { text: `لا يلزم تعديل بحسب الفحص الآلى — بانتظار مراجعة محامٍ${verdict}`, tone: 'medium', bold: false };
      else status = { text: `بانتظار الصياغة المقترحة${verdict}`, tone: 'high', bold: false };
      return [
        { text: String(r.n), center: true },
        { text: clip(firstSentence(r.c.assessmentReasoning ?? ''), 120) || '—' },
        { text: r.sev, tone: SEVERITY_TONE[r.sev], center: true },
        { text: r.c.clauseLabel, center: true },
        status,
      ];
    });
    // ملاحظات العقد ككل (ع1، ع2…) فى السجل نفسه ليكتمل: بنود تحتاج مراجعة + علاقات بين البنود + بنود ناقصة
    findings.forEach((f, i) => {
      const where = f.evidence.length > 0 ? [...new Set(f.evidence.map((e) => e.clauseLabel))].join('، ') : 'العقد ككل';
      rows.push([
        { text: `ع${i + 1}`, center: true },
        { text: `${f.kindLabel}: ${clip(f.title, 120)}${f.verification?.status === 'unconfirmed' ? ' (غير مؤكدة)' : ''}` },
        { text: f.severity, tone: FINDING_TONE(f.severity), center: true },
        { text: where, center: true },
        { text: f.suggestion ? 'معالجة مقترحة — بانتظار مراجعة محامٍ' : 'بانتظار مراجعة محامٍ', tone: 'medium' as Tone, bold: false },
      ]);
    });
    blocks.push({ t: 'grid', columns: ['#', 'وصف المخاطرة', 'الدرجة', 'البند', 'الحالة'], rows, widths: [6, 38, 12, 16, 28] });
  }

  // ---------- 3. التقييم التفصيلى ----------
  banner('التقييم التفصيلى للمخاطر');
  if (totalRisky === 0) {
    blocks.push({ t: 'p', text: 'لا توجد مخاطر تُفصَّل.' });
  } else {
    let letterIdx = 0;
    for (const sev of SEVERITY_ORDER) {
      const group = risky.filter((r) => r.sev === sev);
      if (group.length === 0) continue;
      const title =
        sev === 'حرج' ? 'المخاطر الحرجة' : sev === 'عالٍ' ? 'المخاطر العالية' : sev === 'متوسط' ? 'المخاطر المتوسطة' : 'بنود تحتاج مراجعة ولم تُصنَّف درجتها';
      blocks.push({ t: 'sub', text: `${LETTERS[letterIdx++]}. ${title}`, tone: sev === 'حرج' ? 'critical' : sev === 'عالٍ' ? 'high' : sev === 'متوسط' ? 'medium' : 'navy' });
      for (const r of group) {
        blocks.push({ t: 'h3', text: `${r.n}. ${clauseHeading(r.c)}` });
        const basis = (r.c.matchedArticles ?? []).map(
          (m) => `المادة ${m.article_no} من ${lawName(m)}: «${clip(m.snippet, 900)}»`,
        );
        blocks.push({
          t: 'kv',
          rows: [
            { label: 'المشكلة', tone: 'critical', value: r.c.assessmentReasoning?.trim() || '—' },
            { label: 'الأساس القانونى', tone: 'info', value: basis.length > 0 ? basis.join('\n') : 'لا مادة معتمدة مرتبطة بهذا البند.' },
            { label: 'الخطر القانونى', tone: 'high', value: RISK_TEXT[r.sev] },
            ...(r.c.verification
              ? [{ label: 'التحقق المستقل', tone: (r.c.verification.status === 'confirmed' ? 'info' : 'high') as Tone, value: verificationText(r.c.verification) }]
              : []),
            ...(ocrRead && findOcrNoiseTokens(r.c.clauseText).length > 0
              ? [{ label: 'تنبيه قراءة آلية', tone: 'medium' as Tone, value: OCR_NOISE_NOTE(findOcrNoiseTokens(r.c.clauseText)) }]
              : []),
            ...(r.c.lawyerVerdict || r.c.lawyerNotes
              ? [{ label: 'رأى المراجع', tone: 'info' as Tone, value: [r.c.lawyerVerdict, r.c.lawyerNotes].filter(Boolean).join(' — ') }]
              : []),
          ],
        });
      }
    }
  }

  // ---------- ملاحظات العقد ككل (الجولة 3) ----------
  if (input.contractFindings) {
    banner('ملاحظات على العقد ككل');
    blocks.push({
      t: 'p',
      text:
        'تُفحص هنا العلاقات بين البنود لا كل بند وحده: البنود التى لم يُرصد لها نص بحسب نوع العقد، والإحالات والمصطلحات غير المعرَّفة، والشروط المفتوحة، والتعارض المحتمل بين بندين. ' +
        'صيغة «لم يُرصد» أو «محتمل» مقصودة: فقد يكون الحكم فى مرفق لم يُرفع أو فى نص لم تقرأه القراءة الآلية، والتقدير النهائى لمحامٍ مختص.',
    });
    if (input.contractFindingsModel === 'error' || input.contractFindingsModel === 'skipped') {
      blocks.push({
        t: 'note',
        label: 'نطاق الفحص:',
        text:
          input.contractFindingsModel === 'skipped'
            ? 'العقد أطول من الحد المعتمد لفحص التعارض بين البنود آلياً، فلم يُجرَ هذا الفحص؛ وما يلى نتائج الفحوص الحتمية فقط.'
            : 'تعذّر إتمام فحص التعارض بين البنود آلياً وقت المعالجة؛ وما يلى نتائج الفحوص الحتمية فقط.',
      });
    }
    if (findings.length === 0) {
      blocks.push({ t: 'p', text: 'لم تُرصد ملاحظات على مستوى العقد ككل بالفحوص المطبَّقة.' });
    } else {
      blocks.push({
        t: 'grid',
        columns: ['#', 'النوع', 'الملاحظة', 'الدرجة'],
        rows: findings.map((f, i) => [
          { text: `ع${i + 1}`, center: true },
          { text: f.kindLabel },
          { text: clip(f.title, 140) + (f.verification?.status === 'unconfirmed' ? ' (غير مؤكدة)' : '') },
          { text: f.severity, tone: FINDING_TONE(f.severity), center: true },
        ]),
        widths: [6, 24, 52, 18],
      });
      findings.forEach((f, i) => {
        blocks.push({ t: 'h3', text: `ع${i + 1}. ${f.title}` });
        blocks.push({
          t: 'kv',
          rows: [
            { label: 'التفصيل', tone: 'high', value: f.explanation },
            ...(f.evidence.length > 0
              ? [{ label: 'من نص العقد', tone: 'info' as Tone, value: f.evidence.map((e) => `${e.clauseLabel}: «${clip(e.quote, 400)}»`).join('\n') }]
              : []),
            ...(f.verification
              ? [{ label: 'التحقق المستقل', tone: (f.verification.status === 'confirmed' ? 'info' : 'high') as Tone, value: verificationText(f.verification) }]
              : []),
            ...(f.suggestion ? [{ label: 'المعالجة المقترحة', tone: 'medium' as Tone, value: f.suggestion }] : []),
          ],
        });
      });
    }
  }

  // ---------- 4. النسخة المعدّلة ----------
  banner('النسخة الاحترافية المُعدَّلة للبنود');
  const redrafted = risky.filter((r) => r.redraft).sort((a, b) => a.c.clauseIndex - b.c.clauseIndex);
  if (redrafted.length === 0) {
    blocks.push({
      t: 'p',
      text: 'لم تُولَّد صياغات مقترحة لبنود هذا العقد بعد؛ يمكن توليد صياغة لكل بند يحتاج مراجعة من شاشة المدقق (زر «صياغة مقترحة»).',
    });
  } else {
    blocks.push({
      t: 'p',
      text: 'تعرض الصفحات التالية كل بند بنسخته الأصلية مقابل النسخة المُعدَّلة مع التعليق القانونى المستند إلى النصوص المفهرسة. الصياغات المقترحة للاسترشاد وتُراجَع من محامٍ قبل الاعتماد؛ وليست نصاً معتمداً.',
    });
    for (const r of redrafted) {
      blocks.push({ t: 'h3', text: clauseHeading(r.c), rule: true });
      if (r.redraft && !r.redraft.noChange) {
        blocks.push({
          t: 'compare',
          modifiedTitle: 'البند المُعدَّل',
          originalTitle: 'النص الأصلى',
          modified: r.redraft.text,
          original: clip(r.c.clauseText, 3000),
        });
        if (ocrRead && findOcrNoiseTokens(r.c.clauseText).length > 0) {
          blocks.push({ t: 'note', label: 'تنبيه قراءة آلية:', text: OCR_NOISE_NOTE(findOcrNoiseTokens(r.c.clauseText)) });
        }
        if (r.redraft.changes.length > 0) {
          blocks.push({ t: 'commentary', text: `⚖ التعليق القانونى: ${r.redraft.changes.join(' ')}` });
        }
      } else if (r.redraft) {
        blocks.push({ t: 'p', text: `لا يلزم تعديل هذا البند.${r.redraft.note ? ` ${r.redraft.note}` : ''}` });
      }
    }
  }

  // ---------- 5. التوصيات ----------
  banner('توصيات التنفيذ والجدول الزمنى للتفاوض');
  if (totalRisky === 0) {
    blocks.push({ t: 'p', text: 'لا توجد إجراءات تعديل مطلوبة وفق النصوص المفهرسة؛ ويُنصح بمراجعة محامٍ مختص قبل التوقيع.' });
  } else {
    blocks.push({
      t: 'grid',
      columns: ['#', 'الإجراء المطلوب', 'الأولوية', 'الجدول الزمنى', 'ملاحظات'],
      widths: [6, 38, 14, 20, 22],
      rows: risky.map((r) => [
        { text: String(r.n), center: true },
        {
          text:
            `مراجعة ${r.c.clauseLabel}${r.c.clauseTitle ? ` (${r.c.clauseTitle})` : ''} وتعديله` +
            (r.redraft && !r.redraft.noChange ? ' وفق الصياغة المقترحة' : ''),
        },
        { text: PRIORITY[r.sev], tone: SEVERITY_TONE[r.sev], center: true },
        { text: TIMELINE[r.sev], center: true },
        { text: PRIORITY_NOTE[r.sev] },
      ]),
    });
    if (counts['حرج'] > 0) {
      const nums = risky.filter((r) => r.sev === 'حرج').map((r) => r.n).join('، ');
      blocks.push({
        t: 'p',
        text: `ملاحظة تفاوضية: إن رفض الطرف الآخر تعديل البنود الحرجة (${nums})، يُوصى بعرض الأمر على محامٍ مختص قبل المضى فى توقيع العقد.`,
      });
    }
  }

  // ---------- 6. الإطار القانونى ----------
  banner('الإطار القانونى والتشريعى المرجعى');
  blocks.push({ t: 'sub', text: `${LETTERS[0]}. التشريعات المصرية المستشهد بها`, tone: 'navy' });
  if (lawList.length === 0) {
    blocks.push({ t: 'p', text: 'لم يُستشهد بأى نص مفهرس فى تقييم بنود هذا العقد.' });
  } else {
    blocks.push({
      t: 'grid',
      columns: ['التشريع', 'الصلة بالعقد'],
      widths: [38, 62],
      rows: lawList.map((l) => [
        { text: l.name, tone: 'info' as Tone },
        { text: `المواد ${[...l.articles.keys()].sort((a, b) => a - b).join('، ')}: مستشهد بها فى تقييم ${[...l.clauseLabels].join('، ')}` },
      ]),
    });
  }

  // ---------- 7. إخلاء المسؤولية ----------
  banner('إخلاء المسؤولية');
  blocks.push({ t: 'p', text: STANDARD_DISCLAIMER });
  blocks.push({
    t: 'table',
    widths: [50, 50],
    rows: [
      [
        { text: `تاريخ الإصدار: ${dateText}`, tone: 'info', bold: false },
        { text: `مُعدّ بواسطة: منصة ${brand} (تحليل آلى)`, tone: 'info', bold: false },
      ],
      [
        {
          text: approved
            ? `الحالة: معتمد بتاريخ ${formatCairoDate(input.approvedAt as Date)}`
            : 'الحالة: مسودة آلية — بانتظار المراجعة البشرية',
          tone: 'info',
          bold: false,
        },
        { text: 'السرية: للمستلمين المعتمدين فقط', tone: 'info', bold: true },
      ],
    ],
  });
  if (approved && input.approvalNote) blocks.push({ t: 'p', text: `ملاحظة المراجع: ${input.approvalNote}`, size: 'small' });

  // ---------- 8. الذيول ----------
  banner('الذيول المرجعية للمواد القانونية');
  if (lawList.length === 0) {
    blocks.push({ t: 'p', text: 'لا مواد قانونية مستشهد بها.' });
  }
  lawList.forEach((l, i) => {
    blocks.push({ t: 'sub', text: `${LETTERS[i] ?? String(i + 1)}. ${l.name}`, tone: 'navy' });
    blocks.push({
      t: 'grid',
      columns: ['المصدر الرسمى', 'الموضوع', 'المادة'],
      widths: [30, 56, 14],
      rows: [...l.articles.entries()]
        .sort((a, b) => a[0] - b[0])
        .map(([no, a]) => [
          { text: hostOf(a.url), link: a.url },
          { text: clip(a.snippet, 1500) },
          { text: `م. ${no}`, tone: 'info' as Tone, center: true },
        ]),
    });
  });
  const restRows: Cell[][] = [
    ...soundClauses.map((c) => [{ text: 'لم يظهر اختلاف عن النصوص المفهرسة', tone: 'medium' as Tone, bold: false }, { text: clauseHeading(c) }]),
    ...noTextClauses.map((c) => [{ text: 'لا يوجد نص مفهرس يحكمه مباشرة', tone: 'grey' as Tone, bold: false }, { text: clauseHeading(c) }]),
  ];
  if (restRows.length > 0) {
    blocks.push({ t: 'sub', text: `${LETTERS[lawList.length] ?? ''}. حالة بقية البنود`.replace(/^\. /, ''), tone: 'navy' });
    blocks.push({ t: 'grid', columns: ['الحالة', 'البند'], rows: restRows, widths: [38, 62] });
  }

  // ---------- 9. التوقيعات ----------
  blocks.push({ t: 'pagebreak' });
  banner('قسم التوقيعات واعتماد التقرير');
  blocks.push({
    t: 'p',
    text:
      'يُعتمد هذا التقرير بتوقيع المراجع القانونى المختص وتاريخ الاعتماد؛ ولا تُعدّ النسخة المنشأة آلياً دليلاً على الاعتماد ما لم تحمل ذلك التوقيع.',
  });
  blocks.push({
    t: 'signatures',
    right: {
      title: 'المستشار القانونى / مُعِد التقرير',
      fields: ['الاسم', 'رقم القيد / الترخيص'],
      signatureLabel: 'التوقيع الإلكترونى / ختم المكتب',
    },
    left: { title: 'ممثل العميل', fields: ['الاسم', 'المسمى الوظيفى'], signatureLabel: 'التوقيع الإلكترونى / الختم الرسمى' },
    dateRow: {
      right: `تاريخ الإصدار: ${dateText}`,
      left: approved ? `تاريخ الاعتماد: ${formatCairoDate(input.approvedAt as Date)}` : 'تاريخ الاعتماد: ______ / ______ / 20______',
    },
  });
  blocks.push({
    t: 'note',
    label: 'ملاحظة:',
    text: 'هذا التقرير ناتج تحليل آلى للنصوص المفهرسة، ولا يُغنى عن مراجعة محامٍ مقيد قبل التوقيع على العقد أو الاستناد إلى التقرير أمام أى جهة.',
  });

  const cover = { title: 'تقرير مراجعة وتدقيق مخاطر العقد', subtitle: 'تحليل قانونى احترافى متكامل — إطار القانون المصرى', rows: coverRows };
  const digest = createHash('sha256').update(JSON.stringify({ cover, blocks })).digest('hex').toUpperCase();
  blocks.push({
    t: 'idtable',
    rows: [
      { label: 'رقم تعريف الوثيقة (Document ID)', value: `CRA-${reference.slice(4)}` },
      { label: 'بصمة التحقق (SHA-256)', value: digest },
    ],
  });

  return {
    reference,
    report: {
      headerText: `سري — للمستلمين المعتمدين فقط  |  منصة ${brand}${input.contractType ? ` — ${input.contractType}` : ''}`,
      footerText: `تقرير مراجعة وتدقيق مخاطر العقد — إصدار ${year}`,
      watermark: approved ? null : 'مسودة — غير معتمد',
      cover,
      blocks,
    },
  };
}
