/**
 * أداة القياس الآلية (الجولة 111): أنواع المفتاح المرجعى (يكتبه المالك/المستشار) ولقطة مخرجات المنصة ونتائج القياس.
 * ملف أنواع نقى بلا أى اعتماد على Nest أو قاعدة البيانات.
 */

export type Severity = 'حرج' | 'عالٍ' | 'متوسط' | 'غير مصنَّف';
export const SEVERITIES: readonly Severity[] = ['حرج', 'عالٍ', 'متوسط', 'غير مصنَّف'];

export type ContractSet = 'holdout' | 'dev';

/** ملاحظة صحيحة يجب أن تظهر فى تقرير المنصة (يكتبها المحامى قبل أن يرى المطور العقد). */
export interface KeyIssue {
  id: string;
  /** clause: عيب فى بند موجود (يُحدَّد برقمه)؛ absent: بند/حكم لازم غير موجود فى العقد. */
  kind: 'clause' | 'absent';
  /** رقم البند (أو أرقام) لنوع clause */
  clause?: number | number[];
  severity: Severity;
  /** وصف قصير بكلام المحامى (للتقرير فقط) */
  topic: string;
  /**
   * كلمات تُميّز نفس المشكلة (يكفى ظهور إحداها فى عنوان/تعليل الملاحظة). اختيارية لنوع clause (رقم البند وحده يكفى حينها)
   * وإلزامية مع finding_ids لنوع absent.
   */
  keywords?: string[];
  /** معرّفات ملاحظات العقد ككل المتوقعة (مثل missing:warranty) — لنوع absent */
  finding_ids?: string[];
}

/** ملاحظة تقبلها المنصة دون أن تُعدّ إنذاراً كاذباً (قرار مالك مسجَّل، مثل ملاحظة مقبولة لا تُعدّ خطأ). */
export interface KeyAcceptable {
  id: string;
  clause?: number | number[];
  keywords?: string[];
  finding_ids?: string[];
  reason: string;
}

export interface EvalKey {
  schema: 'shield-eval-key/1';
  /** رمز مرجعى للعقد بلا أى هوية حقيقية (مثل H03) */
  contract_ref: string;
  set: ContractSet;
  contract_type: string;
  /** عدد البنود الفعلى فى العقد كما يعدّه المحامى (للتجزئة) */
  clauses_expected?: number;
  /** أرقام البنود الفعلية إن أراد قياساً أدق من العدد */
  clause_numbers?: number[];
  /** اسما الطرفين كما فى الديباجة (للمقارنة الآلية؛ لا يُنشر فى وثائق المشروع) */
  parties?: { first?: string; second?: string };
  /** مبالغ مالية فى العقد يجب أن تُقرأ بدقة (أرقام صرفة) */
  payment_sums?: number[];
  issues: KeyIssue[];
  acceptable?: KeyAcceptable[];
  /** يضعه الأمر freeze: تاريخ التجميد وبصمة المحتوى. مفتاح Holdout بلا تجميد غير صالح للقياس. */
  frozen?: { at: string; sha256: string };
}

// ===================== لقطة مخرجات المنصة =====================

export interface SnapVerification {
  status: 'confirmed' | 'unconfirmed';
  reason?: string;
  quote?: string | null;
  quoteSource?: 'clause' | 'article' | null;
  reclassified?: 'deviation' | null;
  basis?: string | null;
  refutationKind?: string | null;
}

export interface SnapMatchedArticle {
  law?: string;
  law_no: number;
  law_year: number;
  article_no: number;
  snippet?: string;
}

export interface SnapClause {
  clauseIndex: number;
  clauseLabel: string;
  clauseTitle: string | null;
  clauseText: string;
  assessmentStatus: string | null;
  assessmentReasoning: string | null;
  matchedArticles: SnapMatchedArticle[] | null;
  riskLevel: string | null;
  verification: SnapVerification | null;
  ruleFindings?: Array<{ topic?: string; status?: string; explanation?: string; quotes?: string[] }> | null;
}

export interface SnapFinding {
  id?: string;
  kind: string;
  severity: string;
  title: string;
  explanation: string;
  evidence: Array<{ clauseLabel: string; quote: string }>;
  verification: SnapVerification | null;
}

export interface Snapshot {
  /** رمز العقد المرجعى (يطابق contract_ref فى المفتاح)؛ تكرار اللقطات بنفس الرمز = تشغيلات متكررة للثبات */
  evalRef: string;
  contractId: string;
  /** وقت رفع العقد للمنصة (ISO) — يُقارَن بتاريخ تجميد مفتاح Holdout */
  uploadedAt: string | null;
  /** وقت التقاط اللقطة */
  capturedAt: string | null;
  contractType: string | null;
  extractionWarnings: string[];
  partyNames: { first: string | null; second: string | null } | null;
  clauses: SnapClause[];
  contractFindings: SnapFinding[];
  /** تنبيهات من التطبيع (مثل غياب درجة الخطورة عند القراءة من الـAPI) */
  notes: string[];
}

// ===================== عناصر التقرير ونتائج القياس =====================

export type ItemState = 'confirmed' | 'candidate' | 'dismissed';

export interface ReportedItem {
  /** بصمة ثابتة بين التشغيلات: clause:<رقم> أو finding:<نوع>:<معرّف|عنوان> */
  fp: string;
  source: 'clause' | 'finding';
  kind: string;
  title: string;
  severity: string;
  state: ItemState;
  clauseNumbers: number[];
  clauseLabels: string[];
  /** تعليل المنصة مقتطعاً كما هو (لمساعدة المحامى على الحكم) */
  summary: string;
  /** نص موحَّد للبحث بالكلمات المفتاحية */
  haystack: string;
  /** اقتباسات تُفحص حرفيتها */
  quotes: Array<{ quote: string; clauseLabel: string | null; source: 'clause' | 'article' | null }>;
}

export type Verdict = 'true_issue' | 'acceptable' | 'false_alarm';
/** بصمة العنصر → حكم المحامى. المفتاح مركّب: contract_ref + '|' + fp */
export type Adjudication = Record<string, Verdict>;

export interface IssueResult {
  id: string;
  topic: string;
  severity: Severity;
  outcome: 'confirmed' | 'candidate' | 'missed';
  matchedFp: string | null;
}

export interface ContractMetrics {
  ref: string;
  set: ContractSet;
  contractType: string;
  runIndex: number;
  contractId: string;
  valid: boolean;
  invalidReasons: string[];
  issues: IssueResult[];
  issueCount: number;
  foundConfirmed: number;
  foundCandidateOnly: number;
  missed: number;
  criticalHighTotal: number;
  criticalHighFound: number;
  confirmedItems: number;
  truePositiveItems: number;
  acceptableItems: number;
  falseAlarms: number;
  highCriticalFalseAlarms: number;
  pendingItems: Array<{ fp: string; title: string; severity: string; clauseLabels: string[]; summary: string }>;
  pendingHighCritical: number;
  extraTrueIssues: number;
  candidateItems: number;
  candidateMatchedKey: number;
  dismissedItems: number;
  quotesChecked: number;
  quotesMissing: Array<{ fp: string; quote: string }>;
  citationsChecked: number;
  citationsNotIndexed: Array<{ law_no: number; law_year: number; article_no: number }> | null;
  citationsMalformed: number;
  clausesRead: number;
  segmentation: number | null;
  parties: 'ok' | 'mismatch' | 'unmeasured';
  paymentSums: { checked: number; found: number } | null;
  coverage: number | null;
  confirmedBySeverity: Record<Severity, number>;
  confirmedFps: string[];
  issueFound: Record<string, boolean>;
}
