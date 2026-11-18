/**
 * أنواع خدمة «صياغة العقود».
 *
 * المبدأ (قرار المنتج 2026-11-18): الصياغة حتمية بالكامل — قوالب بنود محكَّمة تُملأ بإجابات المستخدم، بلا نموذج لغوى
 * ولا أى نداء خارجى، فلا تغادر بيانات الأطراف المنصة، ولا يُخترع نص قانونى. كل مسودة تمر على بوابة جودة تستعمل قواعد المنصة
 * نفسها فى تدقيق العقود (البنود الناقصة، المواد الآمرة، الإحالات الداخلية) قبل تسليمها.
 */

export const DRAFT_TYPE_IDS = ['services', 'lease', 'nda'] as const;
export type DraftTypeId = (typeof DRAFT_TYPE_IDS)[number];

export type FieldKind = 'text' | 'longtext' | 'number' | 'money' | 'date' | 'choice';

export interface FieldOption {
  value: string;
  label: string;
}

export interface FieldSpec {
  id: string;
  label: string;
  kind: FieldKind;
  required: boolean;
  /** سطر مساعد يظهر تحت الحقل */
  help?: string;
  options?: FieldOption[];
  /** حدود الرقم (number/money) */
  min?: number;
  max?: number;
  /** حد أقصى لعدد حروف النص */
  maxLength?: number;
  /** القيمة الافتراضية المقترحة (نص) */
  default?: string;
  /** يظهر الحقل ويُطلب فقط إذا كان حقل آخر بقيمة معينة */
  showWhen?: { field: string; equals: string };
  /** مجموعة العرض فى النموذج */
  group: string;
}

export interface DraftTypeSpec {
  id: DraftTypeId;
  label: string;
  description: string;
  /** صفة المستخدم: تحدد من هو «عميلنا» فى بوابة الجودة وترتيب الأطراف */
  roles: FieldOption[];
  fields: FieldSpec[];
}

export type AnswerValue = string | number;
export type Answers = Record<string, AnswerValue | undefined>;

export interface DraftClause {
  /** رقم البند (1..N) */
  number: number;
  /** «البند الأول» */
  heading: string;
  title: string;
  paragraphs: string[];
}

export type QualitySeverity = 'حرج' | 'عالٍ' | 'متوسط' | 'منخفض';

export interface QualityFinding {
  severity: QualitySeverity;
  title: string;
  detail: string;
}

export interface DraftQuality {
  /** true = اجتازت كل فحوص البوابة بلا ملاحظات */
  passed: boolean;
  checked: string[];
  findings: QualityFinding[];
}

export interface DraftResult {
  typeId: DraftTypeId;
  typeLabel: string;
  title: string;
  role: string;
  preamble: string[];
  clauses: DraftClause[];
  closing: string[];
  /** ملاحظات المراجعة للمحامى (ليست من نص العقد) */
  lawyerNotes: string[];
  quality: DraftQuality;
  /** النص الكامل كما سيُطبع (للمعاينة والفحص) */
  fullText: string;
}

/** ما تحتاجه القوالب من السياق بعد التحقق: قيم نظيفة مضمونة الأنواع. */
export interface Ctx {
  typeId: DraftTypeId;
  role: string;
  /** نص نظيف (مفصول الأسطر) */
  s(id: string): string;
  n(id: string): number;
  /** إجابة اختيار */
  c(id: string): string;
  /** قائمة بنود من نص متعدد الأسطر */
  lines(id: string): string[];
  /** «البند الخامس» لبند بمفتاحه؛ يرمى إن كان المفتاح غير موجود فى المسودة */
  ref(key: string): string;
  has(key: string): boolean;
}

export interface ClauseDef {
  key: string;
  title: string;
  /** شرط تضمين البند (يُحسب من الإجابات فقط) */
  when?: boolean;
  paragraphs: (ctx: Ctx) => string[];
}

export interface TemplateOutput {
  title: string;
  /** الاسم المعتمد لنوع العقد عند الفحص (يحدد الأسرة فى قواعد المنصة) */
  contractTypePhrase: string;
  preamble: string[];
  clauses: ClauseDef[];
  closing: string[];
  lawyerNotes: string[];
}

export class DraftValidationError extends Error {
  constructor(public readonly fieldErrors: Record<string, string>) {
    super('بيانات الصياغة غير مكتملة أو غير صحيحة');
  }
}
