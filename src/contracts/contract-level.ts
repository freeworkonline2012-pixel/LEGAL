import { quoteInText } from './clause-facts';
import type { Verification } from './verification';
import { normalizeArabicForMatch, stripDefiniteArticle } from './reasoning.util';

export { stripDefiniteArticle };

/**
 * تحليل العقد ككل (الجولة 3): ما لا يظهر عند قراءة كل بند وحده — البنود الناقصة، المصطلحات المُحال إليها دون تعريف، الشروط المفتوحة،
 * والتعارض بين بندين. الأجزاء الحتمية هنا (قوائم البنود الناقصة حسب نوع العقد، والإحالات غير المعرَّفة، والعبارات المفتوحة) لا تعتمد على نموذج لغوى.
 * أما ما يقترحه النموذج فيمر بتحقق صارم (validateModelFindings): كل واقعة باقتباس حرفى من البند المذكور، وإلا سقطت.
 *
 * ⚠️ لغة النتائج احتمالية عمداً: «لم يُرصد فى النص المرفوع» لا «العقد ينقصه»، و«تعارض محتمل» لا «تعارض»؛ فقد يضيع جزء من النص فى القراءة الآلية
 * أو يكون الحكم فى مرفق لم يُرفع. المحامى هو من يقطع.
 */

export type ContractFindingKind = 'missing_clause' | 'undefined_term' | 'open_term' | 'conflict' | 'scope_mismatch';
export type FindingSeverity = 'حرج' | 'عالٍ' | 'متوسط' | 'منخفض';

export const FINDING_KIND_LABEL: Record<ContractFindingKind, string> = {
  missing_clause: 'بند غير مرصود',
  undefined_term: 'مصطلح أو إحالة غير معرَّفة',
  open_term: 'شرط مفتوح',
  conflict: 'تعارض محتمل بين بندين',
  scope_mismatch: 'عدم اتساق فى النطاق',
};

export interface FindingEvidence {
  clauseIndex: number;
  clauseLabel: string;
  quote: string;
}

export interface ContractFinding {
  id: string;
  kind: ContractFindingKind;
  severity: FindingSeverity;
  title: string;
  explanation: string;
  suggestion: string | null;
  evidence: FindingEvidence[];
  source: 'rule' | 'model';
  /** نتيجة المدقق المستقل (لنتائج النموذج فقط)؛ غائبة = لم يُجرَ التحقق */
  verification?: Verification | null;
}

export interface LevelClause {
  clauseIndex: number;
  clauseLabel: string;
  clauseTitle: string | null;
  clauseText: string;
}

export type ModelPassStatus = 'ok' | 'not_configured' | 'skipped' | 'error';

export interface ContractLevelResult {
  version: 1;
  findings: ContractFinding[];
  /** حالة تمرير النموذج: ok | not_configured | skipped (عقد أطول من الحد) | error */
  model: ModelPassStatus;
  generatedAt: string;
}

const SEVERITY_RANK: Record<FindingSeverity, number> = { حرج: 0, عالٍ: 1, متوسط: 2, منخفض: 3 };

export function sortFindings(list: ContractFinding[]): ContractFinding[] {
  return [...list].sort((a, b) => SEVERITY_RANK[a.severity] - SEVERITY_RANK[b.severity]);
}

/** يحوّل الأرقام العربية-الهندية إلى لاتينية قبل التوحيد، فلا تضيع الأرقام من المطابقة (المُوحِّد العام يحذفها). */
function toLatinDigits(t: string): string {
  return t.replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660)).replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06f0));
}
const norm = (t: string): string => normalizeArabicForMatch(toLatinDigits(t));

// ===================== أدوات نصية =====================

/** جمل البند الأصلية (غير الموحَّدة) لاقتباسها حرفياً. */
export function sentencesOf(text: string): string[] {
  return text
    .split(/(?<=[.؟!؛;])\s+|\n+/)
    .map((s) => s.trim())
    .filter((s) => s.length >= 6);
}

function clipQuote(s: string, max = 300): string {
  const t = s.replace(/\s+/g, ' ').trim();
  return t.length <= max ? t : `${t.slice(0, max).trim()}…`;
}

function evidenceOf(c: LevelClause, sentence: string): FindingEvidence | null {
  const q = clipQuote(sentence);
  // الاقتباس المقتطع بنقاط لا يطابق الأصل؛ نقتطع قبل النقاط عند التحقق
  const probe = q.endsWith('…') ? q.slice(0, -1) : q;
  if (!quoteInText(probe, c.clauseText)) return null;
  return { clauseIndex: c.clauseIndex, clauseLabel: c.clauseLabel, quote: probe };
}

// ===================== أنواع العقود =====================

export type ContractFamily =
  | 'lease'
  | 'sale'
  | 'services'
  | 'employment'
  | 'partnership'
  | 'finance'
  | 'agency'
  | 'licence'
  | 'unknown';

export function contractFamily(contractType: string | null | undefined): ContractFamily {
  const t = norm(contractType ?? '');
  if (!t) return 'unknown';
  if (/ايجار/.test(t)) return 'lease';
  if (/ترخيص|امتياز/.test(t)) return 'licence';
  if (/وكاله|سمسره|تسويق/.test(t)) return 'agency';
  if (/شراكه|استثمار/.test(t)) return 'partnership';
  if (/تمويل|قرض/.test(t)) return 'finance';
  if (/عقد عمل/.test(t)) return 'employment';
  if (/خدمات|مقاوله|توريد|برمج/.test(t)) return 'services';
  if (/بيع/.test(t)) return 'sale';
  return 'unknown';
}

// ===================== البنود غير المرصودة =====================

interface MissingCheck {
  id: string;
  label: string;
  /** null = كل الأنواع (بما فيها غير المحدَّد) */
  families: ContractFamily[] | null;
  /** يُرصد البند إن طابق أى نمط على النص الموحَّد للعقد كله */
  patterns: RegExp[];
  /** شرط انطباق إضافى على النص الموحَّد */
  when?: RegExp;
  severity: FindingSeverity;
  why: string;
  suggestion: string;
}

export const CHECKS: MissingCheck[] = [
  {
    id: 'duration',
    label: 'مدة العقد وبدايته ونهايته',
    families: ['lease', 'services', 'employment', 'partnership', 'finance', 'agency', 'licence', 'unknown'],
    patterns: [],
    severity: 'عالٍ',
    why: 'بلا مدة محددة تتعذر معرفة متى ينتهى الالتزام ومتى يُستحق التجديد أو الإنهاء، وتتفاوت آثار ذلك بحسب نوع العقد.',
    suggestion: 'نص يحدد تاريخ البدء والمدة وشروط التجديد أو الانتهاء.',
  },
  {
    id: 'payment',
    label: 'الثمن أو المقابل وطريقة السداد',
    families: ['lease', 'sale', 'services', 'employment', 'agency', 'licence', 'finance'],
    patterns: [/الثمن|الاجره|الاجر|المقابل|اتعاب|عموله|القيمه الايجاريه|الراتب|المرتب|سداد|يسدد|الدفعه|دفعات|اقساط|القسط/],
    severity: 'عالٍ',
    why: 'تحديد المقابل ومواعيد سداده وجزاء التأخر فيه أساس التنفيذ وأكثر مصادر النزاع.',
    suggestion: 'نص يحدد المبلغ وعملته ومواعيد السداد ووسيلته.',
  },
  {
    id: 'termination',
    label: 'الفسخ أو الإنهاء وشروطه',
    families: null,
    patterns: [/فسخ|انهاء.{0,20}(?:ال)?(?:عقد|اتفاق)|ينتهي (?:هذا )?(?:ال)?عقد|الغاء.{0,15}(?:ال)?عقد|يجوز لاي من الطرفين انهاء/],
    severity: 'عالٍ',
    why: 'غياب نص الفسخ يُحيل الأمر إلى القواعد العامة (التقاضى غالباً)، فيطول الخروج من العقد ويتعذر تقدير كلفته.',
    suggestion: 'نص يبين حالات الفسخ والإخطار المطلوب وآثاره (رد ما نُفذ والتعويض).',
  },
  {
    id: 'governing_law',
    label: 'القانون الواجب التطبيق والاختصاص القضائى أو التحكيمى',
    families: null,
    patterns: [/قانون مصري|قانون واجب تطبيق|قانون حاكم|القانون المصري|القانون واجب التطبيق|القانون الحاكم|يخضع.{0,40}لقانون|تختص محاكم|محكمه.{0,20}المختصه|الاختصاص القضائي|الاختصاص المحلي|التحكيم|هيئه تحكيم|ينعقد الاختصاص/],
    severity: 'متوسط',
    why: 'بلا نص يحدد القانون والجهة المختصة يتحدد الاختصاص بالقواعد العامة وقد يطول النزاع على المحكمة نفسها قبل موضوعه.',
    suggestion: 'نص يحدد القانون الحاكم والمحكمة أو مركز التحكيم المختص ومقره.',
  },
  {
    id: 'notices',
    label: 'العناوين المختارة وطريقة الإخطار',
    families: null,
    patterns: [/الموطن المختار|عنوان.{0,25}الطرف|العنوان المبين|الاخطارات|الاخطار.{0,40}(?:يتم|يوجه|توجه|ترسل|يرسل|بخطاب|بالبريد)|المراسلات|الاعلانات|البريد الالكتروني|يعتد بالعنوان/],
    severity: 'منخفض',
    why: 'بلا عنوان معتمد وطريقة إخطار صحيحة يصعب إثبات الإنذارات والإخطارات التى يعتمد عليها الفسخ والتعويض.',
    suggestion: 'نص يحدد عنوان كل طرف وبريده ووسائل الإخطار المعتد بها ومتى يُعد الإخطار واصلاً.',
  },
  {
    id: 'amendments',
    label: 'تعديل العقد كتابةً',
    families: null,
    patterns: [/تعديل.{0,30}العقد|لا يعتد باي تعديل|الا بموافقه كتابيه|الا بمحرر كتابي|الا باتفاق كتابي|ملحق.{0,20}كتاب/],
    severity: 'منخفض',
    why: 'اشتراط الكتابة للتعديل يمنع ادعاء تعديلات شفهية أو تنازلات ضمنية.',
    suggestion: 'نص يشترط أن يكون أى تعديل أو تنازل كتابياً وموقعاً من الطرفين.',
  },
  {
    id: 'confidentiality',
    label: 'السرية وعدم الإفشاء',
    families: ['services', 'licence', 'partnership', 'agency', 'employment', 'finance'],
    patterns: [/سريه|اسرار|معلومات سريه|عدم افشاء|عدم الافصاح|لا يجوز افشاء|لا يفشي/],
    severity: 'متوسط',
    why: 'العقود التى يتبادل أطرافها معلومات تجارية أو فنية أو بيانات عملاء تحتاج التزاماً صريحاً بالسرية ومدته.',
    suggestion: 'نص يعرّف المعلومات السرية ويحدد الاستثناءات ومدة الالتزام بعد انتهاء العقد.',
  },
  {
    id: 'force_majeure',
    label: 'القوة القاهرة',
    families: ['services', 'sale', 'licence', 'agency', 'partnership', 'lease'],
    patterns: [/قوه قاهره|قوه قهريه|ظروف قاهره|ظروف طارئه|حادث مفاجئ|اسباب قهريه|ظروف قهريه|سبب اجنبي|السبب الاجنبي/],
    severity: 'متوسط',
    why: 'بلا تنظيم للقوة القاهرة تتحدد آثارها بالقواعد العامة، ولا يُعرف سلفاً من يتحمل التأخر وكيف تُخطر الظروف وتُثبت.',
    suggestion: 'نص يحدد الحالات ومتطلبات الإخطار والإثبات وأثرها على المواعيد وحق الإنهاء إن طالت.',
  },
  {
    id: 'liability',
    label: 'توزيع المسئولية أو تحديدها',
    families: ['services', 'licence', 'agency'],
    patterns: [/مسئول|مسؤول|يسال|يتحمل الطرف|يضمن|حد اقصي للتعويض|لا تتجاوز مسئوليه/],
    severity: 'عالٍ',
    why: 'غياب تنظيم المسئولية يترك أمرها للقواعد العامة دون سقف متفق عليه، وهو من أهم ما يحرص عليه مقدم الخدمة والعميل معاً.',
    suggestion: 'نص يحدد نطاق المسئولية والحد الأقصى المتفق عليه (إن وُجد) وما لا يجوز الإعفاء منه قانوناً.',
  },
  {
    id: 'delay_penalty',
    label: 'جزاء التأخير أو التعويض الاتفاقى',
    families: ['services', 'sale'],
    patterns: [/غرام(?:ه|ات) (?:عن )?(?:ال)?تاخير|شرط جزائي|تعويض اتفاقي|التعويض الاتفاقي|تعويض.{0,20}(?:ال)?تاخير|جزاء.{0,20}(?:ال)?تاخير|غرامه عن كل/],
    severity: 'متوسط',
    why: 'بلا جزاء مقدّر للتأخير يلزم إثبات الضرر وتقديره قضاءً، وهو بطىء وغير مؤكد.',
    suggestion: 'نص يحدد جزاء التأخير ونسبته وسقفه وشرط استحقاقه.',
  },
  {
    id: 'acceptance',
    label: 'التسليم والاستلام وقبول المخرجات',
    families: ['services', 'sale'],
    patterns: [/استلام|الاستلام|قبول|محضر.{0,12}(?:تسليم|استلام)|فحص|اختبار القبول|يعتبر مقبولا/],
    severity: 'متوسط',
    why: 'بلا إجراء قبول واضح (مدة الفحص، الاعتراض، أثر السكوت) يُنازَع فى اكتمال التنفيذ وفى استحقاق الدفعات المرتبطة به.',
    suggestion: 'نص يحدد إجراء الفحص ومدته وكيفية الاعتراض وأثر السكوت.',
  },
  {
    id: 'warranty',
    label: 'الضمان والعيوب',
    families: ['sale', 'services'],
    patterns: [/ضمان|عيوب|عيب|كفاله|فتره الصيانه|الصيانه/],
    severity: 'متوسط',
    why: 'مدة الضمان ونطاقه وإجراءات الإصلاح ما يُبنى عليه رجوع المشترى أو العميل عند ظهور العيوب.',
    suggestion: 'نص يحدد مدة الضمان ونطاقه وإجراءات الإبلاغ والإصلاح.',
  },
  {
    id: 'intellectual_property',
    label: 'الملكية الفكرية وحقوق الاستخدام',
    families: ['services', 'licence'],
    patterns: [/ملكيه فكريه|حقوق الملكيه|حقوق المؤلف|المصنفات|الشفره المصدريه|ملكا لل|يظل.{0,40}ملكا|ملكيه (?:النظام|البرنامج|المخرجات)/],
    severity: 'عالٍ',
    why: 'بلا نص صريح قد يُنازَع فى ملكية المخرجات وحق استعمالها وتعديلها بعد انتهاء العقد.',
    suggestion: 'نص يحدد مالك المخرجات ونطاق الترخيص المتاح للطرف الآخر ومدته.',
  },
  {
    id: 'data_protection',
    label: 'حماية البيانات الشخصية',
    families: ['services', 'licence', 'agency', 'partnership', 'finance', 'unknown'],
    when: /بيانات.{0,20}(?:شخصيه|عملاء|العملاء|مستخدمين|المستخدمين|موظفين|الموظفين)|قاعده بيانات|قواعد بيانات/,
    patterns: [/قانون حمايه البيانات|151 لسنه 2020|معالجه البيانات الشخصيه|حمايه البيانات الشخصيه|مسئول حمايه البيانات|المتحكم|المعالج|مركز حمايه البيانات/],
    severity: 'متوسط',
    why: 'يتعامل العقد مع بيانات أشخاص ولا ينظم صفة كل طرف (متحكم/معالج) ولا التزامات التأمين والإبلاغ، وهو ما يفرضه قانون حماية البيانات الشخصية.',
    suggestion: 'نص يحدد صفة كل طرف والغرض من المعالجة وإجراءات التأمين والإبلاغ عن الاختراق وإعادة البيانات أو إتلافها عند الانتهاء.',
  },
  // ---- الإيجار
  {
    id: 'lease_handover',
    label: 'تسليم العين المؤجرة وحالتها',
    families: ['lease'],
    patterns: [/تسليم العين|تسلم المستاجر|تسلم العين|محضر.{0,12}(?:تسليم|استلام)|حاله العين|استلم المستاجر|تسليم الوحده/],
    severity: 'عالٍ',
    why: 'محضر تسليم موثق لحالة العين يمنع الخلاف عند الإخلاء حول التلفيات والتحسينات.',
    suggestion: 'نص يثبت استلام العين بحالتها ويرفق محضراً أو قائمة بمحتوياتها.',
  },
  {
    id: 'lease_deposit',
    label: 'التأمين (الوديعة) وشروط رده',
    families: ['lease'],
    patterns: [/مبلغ تامين|تامين نقدي|وديعه|مقدم ايجار|دفعه مقدمه|تامين (?:قدره|بمبلغ)|التامين المدفوع/],
    severity: 'متوسط',
    why: 'حين يُدفع تأمين يلزم النص على قيمته ووقت رده وما يجوز خصمه.',
    suggestion: 'نص يحدد قيمة التأمين وشروط الخصم منه وموعد رده بعد الإخلاء.',
  },
  {
    id: 'lease_maintenance',
    label: 'الصيانة والإصلاحات',
    families: ['lease'],
    patterns: [/صيانه|ترميم|اصلاحات|اصلاح/],
    severity: 'متوسط',
    why: 'توزيع الصيانة بين المؤجر والمستأجر من أكثر ما يُنازَع فيه أثناء العقد.',
    suggestion: 'نص يبين الصيانة الدورية وما يتحمله كل طرف وإجراء الإبلاغ عن الأعطال.',
  },
  {
    id: 'lease_use',
    label: 'الغرض من الاستعمال والتأجير من الباطن',
    families: ['lease'],
    patterns: [/الغرض|يستعمل|الاستعمال|يخصص|الايجار من الباطن|التاجير من الباطن|التنازل عن الايجار|تغيير النشاط/],
    severity: 'متوسط',
    why: 'تحديد الغرض ومنع أو إباحة التأجير من الباطن والتنازل يحمى المؤجر من تغيير الاستعمال ويحمى المستأجر من الفسخ المفاجئ.',
    suggestion: 'نص يحدد الغرض المسموح وحكم التأجير من الباطن والتنازل.',
  },
  // ---- العمل
  {
    id: 'employment_hours',
    label: 'ساعات العمل والإجازات',
    families: ['employment'],
    patterns: [/ساعات العمل|مواعيد العمل|وقت العمل|اجازه|اجازات|الراحه الاسبوعيه/],
    severity: 'متوسط',
    why: 'ساعات العمل والإجازات من الحقوق التى يحكمها قانون العمل ويلزم ألا يقل العقد عن حدودها.',
    suggestion: 'نص يحدد مواعيد العمل والراحة والإجازات وفق قانون العمل النافذ.',
  },
  {
    id: 'employment_insurance',
    label: 'التأمينات الاجتماعية',
    families: ['employment'],
    patterns: [/تامينات|التامين الاجتماعي|التامين الصحي/],
    severity: 'عالٍ',
    why: 'التسجيل فى التأمينات التزام قانونى على صاحب العمل، وغيابه عن العقد يُضعف إثبات حقوق العامل.',
    suggestion: 'نص يلزم صاحب العمل بالتسجيل فى التأمينات الاجتماعية من تاريخ التعيين.',
  },
  // ---- التمويل
  {
    id: 'finance_return',
    label: 'العائد أو الفائدة وطريقة احتسابه',
    families: ['finance'],
    patterns: [/فائده|عائد|ربح|هامش|مصروفات اداريه/],
    severity: 'عالٍ',
    why: 'عقد التمويل بلا عائد أو بلا طريقة احتساب واضحة يصعب تقدير كلفته أو الاعتراض على المطالبة به.',
    suggestion: 'نص يحدد المعدل وطريقة الاحتساب ومواعيد الاستحقاق وحدود الفوائد المتأخرة.',
  },
  {
    id: 'finance_security',
    label: 'الضمانات',
    families: ['finance'],
    patterns: [/ضمان|رهن|كفاله|كفيل|سند اذني|شيك|كمبياله|ضمانات/],
    severity: 'عالٍ',
    why: 'نوع الضمان وأولوية الدائن ومصير الضمان عند الوفاء يلزم أن يكون واضحاً.',
    suggestion: 'نص يحدد الضمانات المقدمة وإجراءات إنشائها وفكها.',
  },
  {
    id: 'finance_default',
    label: 'حالات الإخلال وحلول الأجل',
    families: ['finance'],
    patterns: [/حلول الاجل|حالات الاخلال|حاله الاخلال|التاخر في السداد|الاخلال بالسداد|اعتبار الدين حالا|يحل الاجل/],
    severity: 'عالٍ',
    why: 'بدون حالات إخلال محددة يُنازَع فى حق الدائن بإنهاء التمويل وطلب كامل الرصيد.',
    suggestion: 'نص يحدد حالات الإخلال ومهلة التصحيح وأثرها.',
  },
  // ---- الشراكة
  {
    id: 'partnership_capital',
    label: 'الحصص ورأس المال',
    families: ['partnership'],
    patterns: [/حصه|حصص|راس المال|مساهمه/],
    severity: 'عالٍ',
    why: 'مقدار ما يقدمه كل شريك ونوعه وموعده يحدد الحقوق والخسارة المحتملة.',
    suggestion: 'نص يحدد حصة كل شريك وكيفية الوفاء بها.',
  },
  {
    id: 'partnership_profit',
    label: 'توزيع الأرباح والخسائر',
    families: ['partnership'],
    patterns: [/توزيع الارباح|الارباح والخسائر|نسبه الربح|تحمل الخسائر|الخسائر|نصيب كل شريك/],
    severity: 'عالٍ',
    why: 'بلا بيان نسب توزيع الأرباح وتحمل الخسائر تُطبق القواعد العامة وقد تخالف مقصود الشركاء.',
    suggestion: 'نص يحدد النسب ومواعيد التوزيع وكيفية تحمل الخسائر.',
  },
  {
    id: 'partnership_exit',
    label: 'الإدارة والتخارج والتصفية',
    families: ['partnership'],
    patterns: [/الاداره|المدير|تخارج|انسحاب|التنازل عن الحصه|بيع الحصه|حق الاولويه|التصفيه|حل الشركه/],
    severity: 'عالٍ',
    why: 'من يدير ومن يملك قرار الخروج وكيف تُقوَّم الحصة من أكثر ما ينشأ عنه نزاع بين الشركاء.',
    suggestion: 'نص يحدد سلطات الإدارة وقواعد التخارج وتقويم الحصة والتصفية.',
  },
  // ---- الوكالة والتسويق
  {
    id: 'agency_scope',
    label: 'نطاق الوكالة والحصرية',
    families: ['agency'],
    patterns: [/نطاق|حدود الوكاله|المنطقه|الاقليم|حصريه|غير حصريه|الحصر/],
    severity: 'عالٍ',
    why: 'نطاق الوكيل (منتجات، منطقة، حصرية) يحدد حقه فى العمولة وحق الموكل فى التعاقد مع غيره.',
    suggestion: 'نص يحدد النطاق والحصرية وما يستثنى منها.',
  },
  {
    id: 'agency_commission',
    label: 'العمولة وتسوية الحساب',
    families: ['agency'],
    patterns: [/عموله|عمولات|كشف حساب|تسويه|اتعاب/],
    severity: 'عالٍ',
    why: 'احتساب العمولة ووقت استحقاقها وأثر إنهاء العلاقة عليها مصدر شائع للنزاع.',
    suggestion: 'نص يحدد أساس احتساب العمولة وموعد استحقاقها وأثر الإنهاء.',
  },
  // ---- الترخيص
  {
    id: 'licence_scope',
    label: 'نطاق الترخيص (حصرى/غير حصرى، إقليم، مدة)',
    families: ['licence'],
    patterns: [/نطاق الترخيص|ترخيص حصري|ترخيص غير حصري|غير حصري|حصري|الاقليم|المنطقه|الاستخدام المسموح/],
    severity: 'عالٍ',
    why: 'حدود الترخيص هي جوهر العقد، وغموضها يفتح باب الادعاء بتجاوزها.',
    suggestion: 'نص يحدد طبيعة الترخيص وإقليمه وحدود الاستخدام والتنازل عنه.',
  },
  {
    id: 'licence_quality',
    label: 'معايير الجودة والرقابة على الاستخدام',
    families: ['licence'],
    patterns: [/معايير الجوده|الجوده|الرقابه|التفتيش|مراجعه|ضبط الجوده/],
    severity: 'متوسط',
    why: 'مانح الترخيص يحتاج رقابة على جودة الاستخدام حمايةً لعلامته أو لتقنيته.',
    suggestion: 'نص يحدد معايير الجودة وحق المراجعة والتفتيش.',
  },
];

// ---------- تعريف المدة ----------

const NUM_WORDS =
  '(?:\\d+|واحد|واحده|اثنين|اثنتين|سنتين|شهرين|ثلاث\\w*|اربع\\w*|خمس\\w*|ست\\w*|سبع\\w*|ثمان\\w*|تسع\\w*|عشر\\w*|احدي عشر|اثني عشر)';
const DURATION_UNITS = '(?:سنه|سنوات|سنتين|عام|اعوام|شهر|اشهر|شهور|شهرين|يوم|ايام|اسبوع|اسابيع)';
const DURATION_TOPIC = /العقد|الايجار|الاتفاق|الترخيص|الوكاله|الشراكه|الخدمه|التعاقد|سريان|الاستخدام|الاستضافه/;
const DURATION_NUMBERED = new RegExp(
  [
    `(?:مده|لمده|ينتهي|تنتهي|يستمر|تستمر)[^.\\n]{0,40}?${NUM_WORDS}[^.\\n]{0,15}?${DURATION_UNITS}`,
    `(?:مده|لمده)[^.\\n]{0,40}?${DURATION_UNITS}\\s+(?:واحده|واحد|كامله|كامل)`,
    `(?:مده|لمده)[^.\\n]{0,40}?(?:سنتين|شهرين|عامين)`,
  ].join('|'),
);
const DURATION_DATED = /(?:يبدا|تبدا|يسري|تسري|بدايه)[^.\n]{0,60}(?:وينتهي|وتنتهي|حتي|الي|ينتهي|تنتهي)[^.\n]{0,40}\d/;

/** هل تعرّف هذه الجملة (الموحَّدة) مدة العقد فعلاً؟ */
export function definesDuration(sentenceNorm: string): boolean {
  if (!DURATION_TOPIC.test(sentenceNorm)) return false;
  return DURATION_NUMBERED.test(sentenceNorm) || DURATION_DATED.test(sentenceNorm);
}

function textDefinesDuration(clauses: LevelClause[]): boolean {
  return clauses.some((c) => sentencesOf(c.clauseText).some((s) => definesDuration(norm(s))));
}

function checkMatches(check: MissingCheck, fullNorm: string, clauses: LevelClause[]): boolean {
  if (check.id === 'duration') return textDefinesDuration(clauses);
  const loose = stripDefiniteArticle(fullNorm);
  return check.patterns.some((p) => p.test(fullNorm) || p.test(loose));
}

export interface MissingOptions {
  contractType: string | null;
  /** تحذير قراءة آلية/ترقيم: قد يكون البند ضمن نص لم يُقرأ */
  textMayBeIncomplete: boolean;
}

export function checkMissingClauses(clauses: LevelClause[], opts: MissingOptions): ContractFinding[] {
  const family = contractFamily(opts.contractType);
  const fullNorm = norm(clauses.map((c) => `${c.clauseTitle ?? ''}\n${c.clauseText}`).join('\n'));
  if (fullNorm.length < 40) return [];
  const out: ContractFinding[] = [];
  for (const check of CHECKS) {
    if (check.families && !check.families.includes(family)) continue;
    if (check.when && !check.when.test(fullNorm) && !check.when.test(stripDefiniteArticle(fullNorm))) continue;
    if (checkMatches(check, fullNorm, clauses)) continue;
    const caveat = opts.textMayBeIncomplete
      ? ' تنبيه: توجد تحذيرات قراءة أو ترقيم لهذا الملف، فقد يكون هذا البند ضمن نص لم يُقرأ؛ قارن بالأصل قبل الاعتماد.'
      : '';
    out.push({
      id: `missing:${check.id}`,
      kind: 'missing_clause',
      severity: check.severity,
      title: `لم يُرصد بند يتناول: ${check.label}`,
      explanation: `لم يُرصد فى نص العقد المرفوع ما يتناول ${check.label}. ${check.why}${caveat}`,
      suggestion: check.suggestion,
      evidence: [],
      source: 'rule',
    });
  }
  return out;
}

// ===================== مصطلحات وإحالات غير معرَّفة =====================

const DURATION_REF = /مده (?:هذا )?(?:العقد|الاتفاق|الايجار|الترخيص|الوكاله|الشراكه)|طوال مده|طيله مده|خلال مده (?:هذا )?العقد|مده سريان/;
const ATTACHMENT_REF =
  /(?:الجدول|الكشف|الملحق|المواصفات|قائمه\w*|الشروط الخاصه|البيان|الوثيقه)\s+(?:ال)?(?:مرفق\w*|المرفقه)|(?:الملحق|الجدول|المرفق)\s*(?:رقم\s*)?\(?\d+\)?|المرفقات|ملحق\w* هذا العقد|الجدول الزمني المرفق/;
const ATTACHMENT_HEADING = /^\s*(?:ال)?(?:ملحق|جدول|مرفق)(?=[\s:\d(]|$)/m;

export function checkUndefinedTerms(clauses: LevelClause[]): ContractFinding[] {
  const out: ContractFinding[] = [];

  // 1) الإحالة إلى «مدة العقد» دون مدة معرَّفة
  if (!textDefinesDuration(clauses)) {
    const ev: FindingEvidence[] = [];
    for (const c of clauses) {
      for (const s of sentencesOf(c.clauseText)) {
        if (DURATION_REF.test(norm(s))) {
          const e = evidenceOf(c, s);
          if (e && ev.length < 3) ev.push(e);
        }
      }
    }
    if (ev.length > 0) {
      out.push({
        id: 'undefined:duration',
        kind: 'undefined_term',
        severity: 'عالٍ',
        title: 'الإحالة إلى «مدة العقد» دون تحديد مدة فى أى بند',
        explanation:
          'يربط العقد التزاماً أو حقاً بمدته، ولم يُرصد فى النص المرفوع بند يحدد هذه المدة أو تاريخى بدايتها ونهايتها؛ فيصبح الحق أو الالتزام بلا حد زمنى معلوم ويتعذر معرفة متى ينتهى أو يُجدَّد.',
        suggestion: 'إضافة بند يحدد تاريخ بدء العقد ومدته وشروط تجديده أو إنهائه، أو ربط الالتزام بمدة صريحة.',
        evidence: ev,
        source: 'rule',
      });
    }
  }

  // 2) الإحالة إلى مرفق/جدول/ملحق لم يظهر فى الملف
  const fullOriginal = clauses.map((c) => c.clauseText).join('\n');
  if (!ATTACHMENT_HEADING.test(fullOriginal)) {
    const ev: FindingEvidence[] = [];
    for (const c of clauses) {
      for (const s of sentencesOf(c.clauseText)) {
        if (ATTACHMENT_REF.test(norm(s))) {
          const e = evidenceOf(c, s);
          if (e && ev.length < 3) ev.push(e);
        }
      }
    }
    if (ev.length > 0) {
      out.push({
        id: 'undefined:attachment',
        kind: 'undefined_term',
        severity: 'متوسط',
        title: 'إحالة إلى مرفق أو جدول لم يظهر نصه فى الملف المرفوع',
        explanation:
          'يحيل العقد إلى مرفق أو جدول أو ملحق يُحدد نطاقاً أو التزاماً، ولم يظهر نصه فى الملف المرفوع؛ فلا يمكن مراجعة ما أُحيل إليه، ولا التأكد من أنه مرفق وموقّع مع العقد.',
        suggestion: 'ارفع المرفق مع العقد وتأكد من توقيعه، وأن يكون العقد نفسه ينص على أن المرفقات جزء لا يتجزأ منه.',
        evidence: ev,
        source: 'rule',
      });
    }
  }
  return out;
}

// ===================== شروط مفتوحة =====================

const MONEY_WORD = /رسوم|اجر|اجره|ثمن|سعر|مقابل|مبلغ|غرامه|تعويض|اتعاب|عموله|مصاريف|مصروفات|قيمه|ايجار/;
const DEFERRED = /(?:تحدد|يحدد|تقدر|يقدر|يتفق (?:عليه|عليها|عليهما)|تتفق|يتم الاتفاق|تقرر|يقرر)[^.\n]{0,40}(?:لاحقا|فيما بعد|بعد (?:انتهاء|اتمام|التنفيذ|التعاقد|التسليم|الاطلاق))|(?:لاحقا|فيما بعد)[^.\n]{0,30}(?:تحدد|يحدد|يتفق)/;
const UNILATERAL = /(?:يحدده|تحدده|يقدره|تقدره|يقرره|تقرره)\s+(?:الطرف (?:الاول|الثاني)|المؤجر|المالك|الشركه)\s*(?:وحده|منفردا|بارادته المنفرده)?|حسب (?:ما )?(?:يراه|تراه) (?:الطرف|المؤجر|الشركه)|وفق تقديره (?:المنفرد|الخاص)|بمعرفه الطرف (?:الاول|الثاني) وحده/;

export function checkOpenTerms(clauses: LevelClause[]): ContractFinding[] {
  const out: ContractFinding[] = [];
  for (const c of clauses) {
    for (const s of sentencesOf(c.clauseText)) {
      const n = norm(s);
      if (!MONEY_WORD.test(n)) continue;
      const deferred = DEFERRED.test(n);
      const unilateral = UNILATERAL.test(n);
      if (!deferred && !unilateral) continue;
      const e = evidenceOf(c, s);
      if (!e) continue;
      out.push({
        id: `open:${c.clauseIndex}:${out.length + 1}`,
        kind: 'open_term',
        severity: unilateral ? 'عالٍ' : 'متوسط',
        title: unilateral ? 'مقابل مالى يحدده أحد الطرفين منفرداً' : 'مقابل مالى يُترك تحديده إلى وقت لاحق',
        explanation: unilateral
          ? 'يترك النص تحديد مبلغ أو رسم مالى لتقدير أحد الطرفين وحده، فيصير التزام الطرف الآخر غير معلوم القدر وقت التعاقد، وقد يُنازَع فى صحة هذا الشرط أو تُقدَّر قيمته بمعرفة القضاء.'
          : 'يُحدَّد مبلغ أو رسم مالى لاحقاً دون بيان آلية تحديده أو سقفه أو جهة الفصل عند الخلاف، فيصير التزاماً غير معلوم القدر وقت التعاقد.',
        suggestion: 'تحديد المبلغ أو سقفه أو آلية احتسابه وموعد الاتفاق عليه، وما يُعمل به عند عدم الاتفاق (مثلاً جهة خبرة محايدة).',
        evidence: [e],
        source: 'rule',
      });
    }
  }
  return out;
}

/** كل الفحوص الحتمية معاً. «مدة غير معرَّفة» ذات الاقتباسات تغنى عن «بند المدة غير مرصود» فلا يتكرر العيب نفسه مرتين. */
export function deterministicFindings(clauses: LevelClause[], opts: MissingOptions): ContractFinding[] {
  const undef = checkUndefinedTerms(clauses);
  const hasDurationRef = undef.some((f) => f.id === 'undefined:duration');
  const missing = checkMissingClauses(clauses, opts).filter((f) => !(hasDurationRef && f.id === 'missing:duration'));
  return sortFindings([...missing, ...undef, ...checkOpenTerms(clauses)]);
}

// ===================== تحقق مخرجات النموذج =====================

const MODEL_KINDS: ReadonlyArray<ContractFindingKind> = ['conflict', 'scope_mismatch', 'open_term', 'undefined_term'];
const NEEDS_TWO: ReadonlySet<ContractFindingKind> = new Set(['conflict', 'scope_mismatch']);
const MODEL_SEVERITIES: ReadonlyArray<FindingSeverity> = ['عالٍ', 'متوسط', 'منخفض'];
const MAX_MODEL_FINDINGS = 8;

function str(v: unknown, max: number): string | null {
  if (typeof v !== 'string') return null;
  const t = v.replace(/\s+/g, ' ').trim();
  if (t.length < 3) return null;
  return t.length > max ? `${t.slice(0, max).trim()}…` : t;
}

/**
 * يقبل مخرجات النموذج بشروط صارمة: النوع من قائمة مغلقة، الدرجة لا ترتفع عن «عالٍ» (الحرج للقواعد الحتمية فقط)، وكل دليل برقم بند موجود
 * واقتباس حرفى موجود فى ذلك البند. التعارض وعدم الاتساق يلزمهما دليلان من بندين مختلفين. ما لا يستوفى ذلك يسقط، فلا يُعرض ادعاء بلا سند.
 */
export function validateModelFindings(raw: unknown, clauses: LevelClause[]): ContractFinding[] {
  const root = raw && typeof raw === 'object' ? (raw as Record<string, unknown>) : null;
  const list = root && Array.isArray(root.findings) ? (root.findings as unknown[]) : [];
  const byIndex = new Map(clauses.map((c) => [c.clauseIndex, c]));
  const out: ContractFinding[] = [];
  for (const item of list) {
    if (out.length >= MAX_MODEL_FINDINGS) break;
    const f = item && typeof item === 'object' ? (item as Record<string, unknown>) : null;
    if (!f) continue;
    const kind = MODEL_KINDS.find((k) => k === f.kind);
    const severity = MODEL_SEVERITIES.find((s) => s === f.severity) ?? 'متوسط';
    const title = str(f.title, 140);
    const explanation = str(f.explanation, 700);
    if (!kind || !title || !explanation) continue;
    const evidence: FindingEvidence[] = [];
    const rawEv = Array.isArray(f.evidence) ? (f.evidence as unknown[]) : [];
    for (const e of rawEv) {
      const o = e && typeof e === 'object' ? (e as Record<string, unknown>) : null;
      if (!o) continue;
      const idx = typeof o.clause_index === 'number' ? o.clause_index : Number(o.clause_index);
      const clause = byIndex.get(idx);
      if (!clause || typeof o.quote !== 'string') continue;
      if (!quoteInText(o.quote, clause.clauseText)) continue;
      if (evidence.some((x) => x.clauseIndex === clause.clauseIndex && x.quote === o.quote)) continue;
      evidence.push({ clauseIndex: clause.clauseIndex, clauseLabel: clause.clauseLabel, quote: o.quote.trim() });
    }
    const distinctClauses = new Set(evidence.map((x) => x.clauseIndex)).size;
    if (NEEDS_TWO.has(kind) ? distinctClauses < 2 : evidence.length < 1) continue;
    out.push({
      id: `model:${kind}:${out.length + 1}`,
      kind,
      severity,
      title,
      explanation,
      suggestion: str(f.suggestion, 400),
      evidence: evidence.slice(0, 4),
      source: 'model',
    });
  }
  return out;
}

/** يزيل نتائج النموذج المكررة لنتيجة حتمية من النوع نفسه تستند إلى البند نفسه. */
export function mergeFindings(rules: ContractFinding[], model: ContractFinding[]): ContractFinding[] {
  const kept = model.filter(
    (m) =>
      !rules.some(
        (r) =>
          r.kind === m.kind &&
          r.evidence.length > 0 &&
          r.evidence.some((re) => m.evidence.some((me) => me.clauseIndex === re.clauseIndex)),
      ),
  );
  return sortFindings([...rules, ...kept]);
}
