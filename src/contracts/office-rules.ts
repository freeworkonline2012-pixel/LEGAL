import { quoteInText } from './clause-facts';
import {
  contractFamily,
  inferContractFamily,
  sentencesOf,
  sortFindings,
  type ContractFamily,
  type ContractFinding,
  type FindingEvidence,
  type FindingSeverity,
  type LevelClause,
} from './contract-level';
import { normalizeArabicForMatch } from './reasoning.util';

/**
 * قواعد المكتب (Playbook المكتب): مواقف تعاقدية يضعها محامى المكتب ويريد أن تُفحص فى كل عقد، بقواعد حتمية موثَّقة بالاقتباس الحرفى
 * ولا تعتمد على نموذج لغوى. تختلف عن الدليل التفاوضى العام (playbook.ts) بأنها تعبّر عن ممارسة مكتب بعينه لا عن ممارسة عامة.
 *
 * ⚠️ حدود الصدق:
 *  - القواعد «ممارسة تعاقدية للمكتب» وليست نصوصاً قانونية، وتُعرض هكذا. لا تحمل مادة قانونية؛ ولا تُدرَج مادة هنا إلا بعد التحقق من نصها المفهرس.
 *  - «لم يُرصد» تعنى أن القراءة الآلية لم تجد نصاً مستوفياً للقاعدة، لا أن العقد خلا منه؛ والمحامى يقطع.
 *  - مصدر القواعد الأولى: ملاحظات محامى المكتب على خمسة عقود حقيقية (الدفعة 1 من المجموعة الذهبية، 2026-11-03). هى عينة صغيرة لعميل واحد؛
 *    فكل قاعدة تحمل ملاحظة المصدر، والتعميم يتطلب مزيداً من العقود.
 *  - الملف الشخصى (OfficeProfile) بيانات لا كود: تغيير القواعد أو تعطيلها لا يمس بقية المحرك (أساس Playbook لكل مكتب).
 */

export interface OfficeRuleContext {
  family: ContractFamily;
}

export interface OfficeRuleHit {
  clause: LevelClause;
  sentence: string;
}

export interface OfficeRule {
  id: string;
  /** null = كل الأنواع */
  families: ContractFamily[] | null;
  /** أنواع تُستثنى حتى مع families = null (مثل العمل الخاضع لنظام قانونى خاص) */
  excludeFamilies?: ContractFamily[];
  /** معطَّلة = لا تعمل (قاعدة مقترحة تنتظر تأكيد المكتب) */
  enabled: boolean;
  severity: FindingSeverity;
  title: string;
  explanation: string;
  suggestion: string;
  /** مصدر القاعدة وحدود تعميمها، يظهر فى الشرح */
  provenance: string;
  /** المواضع المخالفة؛ فارغ = لا تنطبق أو مستوفاة */
  evaluate: (clauses: LevelClause[], ctx: OfficeRuleContext) => OfficeRuleHit[];
}

export interface OfficeProfile {
  id: string;
  name: string;
  version: number;
  rules: OfficeRule[];
}

// ===================== أدوات =====================

const norm = (t: string): string => normalizeArabicForMatch(t);

function* eachSentence(clauses: LevelClause[]): Generator<{ clause: LevelClause; sentence: string; n: string }> {
  for (const clause of clauses) {
    for (const sentence of sentencesOf(clause.clauseText)) yield { clause, sentence, n: norm(sentence) };
  }
}

/** أول جملة مطابقة فى كل بند (بند واحد = موضع واحد). */
function firstPerClause(clauses: LevelClause[], test: (n: string, clauseNorm: string) => boolean): OfficeRuleHit[] {
  const hits: OfficeRuleHit[] = [];
  const done = new Set<number>();
  for (const { clause, sentence, n } of eachSentence(clauses)) {
    if (done.has(clause.clauseIndex)) continue;
    if (test(n, norm(`${clause.clauseTitle ?? ''} ${clause.clauseText}`))) {
      hits.push({ clause, sentence });
      done.add(clause.clauseIndex);
    }
  }
  return hits;
}

// ===================== القاعدة 1: المدة محددة بلا تجديد تلقائى =====================

const AUTO_RENEW =
  /(?:يجدد|تجدد|يتجدد|يمتد|يمدد|تمدد|تمتد)[^.]{0,60}(?:تلقائيا|تلقائي|اليا|ذاتيا|من تلقاء)|(?:تلقائيا|تلقائي|اليا|ذاتيا)[^.]{0,30}(?:يجدد|تجدد|يتجدد|تجديد|امتداد)|تجديد (?:هذا )?(?:العقد |الاتفاقيه )?(?:ال)?(?:تلقائي|اليا|ذاتي)|(?:يجدد|يتجدد|تجدد) (?:هذا )?(?:العقد |الاتفاقيه )?لمده|(?:يجدد|يتجدد|تجدد) (?:هذا )?(?:العقد |الاتفاقيه )?لمدد/;
/** نفى التجديد التلقائى نفسه. «عدم التجديد» وحدها ليست نفياً: هى عادةً إخطار الراغب فى عدم التجديد (ما لم يخطر برغبته فى عدم التجديد). */
const NO_AUTO_RENEW =
  /(?:لا|ولا|بدون|دون)\s+(?:ال)?(?:يجدد|يتجدد|تجدد|تجديد|تمديد|يمتد|يمدد|تمتد)|غير (?:قابل|قابله) (?:لل)?تجديد|لا يجوز تجديد/;

const RULE_TERM_NO_AUTO_RENEWAL: OfficeRule = {
  id: 'term_no_auto_renewal',
  families: ['services', 'agency', 'licence', 'nda'],
  enabled: true,
  severity: 'عالٍ',
  title: 'تجديد العقد تلقائياً بدل مدة محددة تنتهى بانتهائها',
  explanation:
    'قاعدة المكتب: تُحدَّد مدة العقد بتاريخ وينتهى بانتهائها، ولا يتجدد تلقائياً؛ فإن رغب الطرفان فى الاستمرار فبعقد واتفاق جديدين ولو بالشروط نفسها. ' +
    'ورد فى العقد نص يجدده تلقائياً لمدد مماثلة، فيستمر الالتزام (والزيادات المرتبطة بالتجديد) إن لم يصدر إخطار فى موعد قد يفوت.',
  suggestion: 'نص يحدد مدة العقد بتاريخ البدء والانتهاء، وينص على أنه ينتهى بانتهاء مدته دون تجديد تلقائى، وأن أى تجديد يكون بعقد واتفاق جديدين.',
  provenance: 'مصدر القاعدة: ملاحظات محامى المكتب على ثلاثة عقود (الدفعة 1).',
  evaluate: (clauses) => {
    const hits: OfficeRuleHit[] = [];
    const done = new Set<number>();
    for (const { clause, sentence, n } of eachSentence(clauses)) {
      if (done.has(clause.clauseIndex)) continue;
      if (AUTO_RENEW.test(n) && !NO_AUTO_RENEW.test(n)) {
        hits.push({ clause, sentence });
        done.add(clause.clauseIndex);
      }
    }
    return hits;
  },
};

// ===================== القاعدة 2: أثر الإخلال بالسرية =====================

const CONF_UNDERTAKING =
  /(?:سريه|السريه)[^.]{0,60}(?:معلومات|بيانات)|(?:معلومات|بيانات)[^.]{0,60}(?:سريه|سري)\b|(?:الحفاظ|يحافظ|تحافظ|يلتزم|تلتزم|يتعهد|تتعهد)[^.]{0,40}(?:سريه|السريه)|(?:عدم|لا يجوز) (?:ال)?(?:افشاء|افصاح|كشف)|لا يجوز (?:له |لها )?(?:ان )?(?:يفصح|يفشي|يكشف|تفصح|تفشي)/;
/** نص يربط الإخلال بالسرية صراحةً بفسخ أو إنهاء أو تعويض. */
const CONF_CONSEQUENCE =
  /(?:اخلال|مخالفه|افشاء|خرق)[^.]{0,80}(?:سريه|بهذا البند|بالتزام)[^.]{0,120}(?:فسخ|مفسوخ|انهاء|تعويض|جزاء|شرط جزائي)|(?:سريه|بهذا البند)[^.]{0,80}(?:اخلال|مخالفه|افشاء)[^.]{0,120}(?:فسخ|مفسوخ|انهاء|تعويض|جزاء|شرط جزائي)/;
/** حق إنهاء أو فسخ عام عند الإخلال بأى بند (يغطى السرية). */
const BREACH_TERMINATION =
  /(?:اخلال|مخالفه|اخل|خالف|اخلت)[^.]{0,120}(?:فسخ|مفسوخ|ينفسخ|انهاء|ينهي|تنهي|انهاء)|(?:فسخ|مفسوخ|ينفسخ|انهاء|ينهي|تنهي)[^.]{0,120}(?:اخلال|مخالفه|اخل|خالف)/;

const RULE_CONFIDENTIALITY_BREACH: OfficeRule = {
  id: 'confidentiality_breach_consequence',
  families: ['services', 'agency', 'licence', 'partnership', 'nda'],
  enabled: true,
  severity: 'عالٍ',
  title: 'السرية بلا أثر منصوص عند الإخلال بها (فسخ وتعويض)',
  explanation:
    'قاعدة المكتب: يُنص على أن إخلال الملتزم بالسرية يجعل العقد مفسوخاً من تلقاء نفسه، وأن للطرف المتضرر اتخاذ الإجراءات القانونية لتعويض أضراره. ' +
    'ورد فى العقد التزام بالسرية ولم يُرصد نص يرتب على الإخلال به فسخاً أو إنهاءً أو تعويضاً؛ وغالباً ينفع ذلك الطرف الذى يُفصح عن معلوماته، فيُراجع من هو الملتزم بالسرية فى هذا العقد.',
  suggestion:
    'نص يقرر أنه فى حالة إخلال الطرف الملتزم بالسرية يكون العقد مفسوخاً من تلقاء نفسه، ويجوز للطرف المتضرر اتخاذ الإجراءات القانونية لتعويض الأضرار الناتجة عن مخالفة هذا البند.',
  provenance: 'مصدر القاعدة: ملاحظات محامى المكتب على أربعة بنود فى ثلاثة عقود (الدفعة 1). النص العام «تعويض كل طرف عن إخلاله» لم يكفِ عنده، فلا يُحتسب مستوفياً.',
  evaluate: (clauses) => {
    const confHits = firstPerClause(clauses, (n) => CONF_UNDERTAKING.test(n) && /سري|سريه/.test(n));
    if (confHits.length === 0) return [];
    for (const { n } of eachSentence(clauses)) {
      if (CONF_CONSEQUENCE.test(n)) return [];
      if (BREACH_TERMINATION.test(n)) return [];
    }
    return confHits;
  },
};

// ===================== القاعدة 3: إخطار بالمخالفة ومهلة قبل الفسخ أو التعويض =====================

const AUTO_RESCISSION =
  /مفسوخا (?:من تلقاء|تلقائيا|بقوه|دون|بدون)|يعتبر (?:العقد )?مفسوخا|يعتبر (?:العقد )?منفسخا|ينفسخ (?:العقد )?(?:من تلقاء|تلقائيا|بحكم|دون)|(?:دون|بدون|بغير) (?:الحاجه|حاجه) (?:الي|الى) (?:حكم|انذار|اعذار|تنبيه|اخطار)/;
const INDEMNITY_FOR_BREACH =
  /(?:يلتزم|يتعهد|يلزم|تلتزم|تتعهد)[^.]{0,40}(?:كل طرف|الطرف المخل|الطرف المخالف)[^.]{0,60}(?:بتعويض|تعويض)|تعويض (?:ال)?طرف الاخر[^.]{0,80}(?:اخلال|مخالفه)/;
const BREACH_WORD = /اخلال|مخالفه|اخل|خالف|اخلت/;
/** إخطار/إنذار/خطاب مسجل مقروناً بمهلة أو بحق الرد أو التصحيح. */
const NOTICE_AND_CURE =
  /(?:انذار|اخطار|اعذار|خطاب مسجل|اشعار|تنبيه)[^.]{0,120}(?:مهله|خلال \d+|خلال [^.]{0,25}(?:يوم|اسبوع|ايام|شهر)|للرد|لتصحيح|لتدارك|لازاله|لتسويه)|(?:مهله|مده)[^.]{0,40}(?:للرد|لتصحيح|لتدارك|لازاله|لتسويه)/;

const RULE_BREACH_NOTICE_CURE: OfficeRule = {
  id: 'breach_notice_and_cure',
  families: null,
  excludeFamilies: ['employment', 'unknown'],
  enabled: true,
  severity: 'عالٍ',
  title: 'فسخ أو تعويض عن الإخلال دون إخطار بالمخالفة ومهلة للرد والتصحيح',
  explanation:
    'قاعدة المكتب: لا يُفسخ العقد ولا يُطالَب بالتعويض عن مخالفة قبل أن يخطر الطرف الذى يدعيها الطرف الآخر كتابةً (بخطاب مسجل بعلم الوصول مثلاً) ببيان المخالفة، ويمنحه مهلة محددة للرد أو التصحيح؛ ' +
    'فإن لم يقبل رده انفتح طريق الفسخ أو اللجوء إلى القضاء بحسب ما يتفق عليه. ' +
    'ورد فى العقد فسخ أو التزام بالتعويض عند المخالفة دون هذه الآلية، فيجوز الاحتجاج بالمخالفة دون إتاحة فرصة معلنة للتدارك.',
  suggestion:
    'نص يلزم مدعى المخالفة بإخطار مسجل يبين المخالفة، ويمنح الطرف الآخر مدة محددة (15 أو 30 يوماً مثلاً) للرد والتصحيح، ثم يرتب الفسخ أو التعويض أو اللجوء للقضاء على عدم قبول الرد أو عدم التصحيح.',
  provenance: 'مصدر القاعدة: ملاحظات محامى المكتب على بندين فى عقدين (الدفعة 1): فسخ تلقائى فى إيجار، وتعويض عن الإخلال فى خدمات.',
  evaluate: (clauses) =>
    firstPerClause(clauses, (n, clauseNorm) => {
      const rescission = AUTO_RESCISSION.test(n);
      const indemnity = INDEMNITY_FOR_BREACH.test(n) && BREACH_WORD.test(n);
      if (!rescission && !indemnity) return false;
      return !NOTICE_AND_CURE.test(clauseNorm);
    }),
};

// ===================== القاعدة 5: بند «عدم اعتبار التنازل» بصيغة عامة =====================

/** «لا يعتبر تنازل أى طرف عن حق فى مناسبة بمثابة تنازل عنه فى مناسبات لاحقة» وما يماثلها. */
const NON_WAIVER =
  /لا (?:يعتبر|يعد|يشكل) (?:ال)?تنازل[^.]{0,100}(?:بمثابه|يعد|يعتبر|يشكل)[^.]{0,20}تنازل|عدم (?:ممارسه|استعمال|استخدام) (?:اي )?(?:طرف )?(?:ل)?(?:اي )?حق[^.]{0,80}لا (?:يعد|يعتبر|يشكل)[^.]{0,20}تنازل|(?:تاخر|تراخي|سكوت)[^.]{0,60}لا (?:يعد|يعتبر|يشكل)[^.]{0,20}تنازل/;
/** اشتراط الكتابة أو التوقيع لصحة التنازل: إن وُجد فالبند غير عام. */
const WAIVER_FORMALITY = /كتاب|مكتوب|موقع|توقيع|صريح/;

const RULE_GENERIC_NON_WAIVER: OfficeRule = {
  id: 'generic_non_waiver',
  families: null,
  excludeFamilies: ['employment', 'unknown'],
  enabled: true,
  severity: 'عالٍ',
  title: 'بند «عدم اعتبار التنازل» بصيغة عامة (يُنصح بحذفه وإعادة صياغته)',
  explanation:
    'قاعدة المكتب: بند عدم اعتبار التنازل عن حق تنازلاً عن غيره، إذا ورد بصيغة عامة مرسلة، يحمل مستوى مخاطرة عالياً، فيُنصح بحذفه وإعادة صياغته. ' +
    'ورد فى العقد بند بهذه الصيغة دون شروط تحدد متى يصح التنازل وكيف يثبت (الكتابة والتوقيع وتحديد الحق والمناسبة).',
  suggestion:
    'حذف البند بصيغته وإعادة صياغته بحيث لا يصح التنازل عن أى حق إلا إذا كان صريحاً ومكتوباً وموقعاً ممن يملكه، ويسرى على الحق والمناسبة المحددين فيه وحدهما، ويسرى على الطرفين.',
  provenance: 'مصدر القاعدة: ملاحظة محامى المكتب على بند واحد فى عقد واحد (الدفعة 1)، وسببه أن صياغته عامة وفيها مخاطرة عالية؛ فهى أضعف القواعد سنداً وتحتاج عقوداً أخرى لتأكيدها.',
  evaluate: (clauses) =>
    firstPerClause(clauses, (n, clauseNorm) => NON_WAIVER.test(n) && !WAIVER_FORMALITY.test(clauseNorm)),
};

// ===================== القاعدة 6: تحديد المسئولية بصيغة عامة =====================

/** سقف لمسئولية الطرف أو استبعاد للأضرار غير المباشرة/خسارة الأرباح. */
const LIABILITY_LIMIT =
  /(?:لا|الا|ألا)\s+(?:تتجاوز|تزيد|تتعدي)[^.]{0,60}(?:ال)?(?:مس[ؤوئ]?[ولي]?ل?يه|تعويض)|لن يكون[^.]{0,60}مس[ؤوئ]?[ولي]?لا[^.]{0,40}(?:اضرار|ضرر)|(?:الاضرار|الخسائر) (?:غير المباشره|التبعيه|العرضيه)[^.]{0,80}(?:خساره الارباح|فوات الربح|انقطاع الاعمال)|خساره الارباح|انقطاع الاعمال/;
/** البند يتناول المسئولية أصلاً (لا مجرد ذكر عابر لخسارة الأرباح فى بند آخر). */
const LIABILITY_TOPIC = /مس[ؤوئ]?[ولي]?[ل]?يه|مسوول|مسئول/;
/** استثناء الغش أو الخطأ الجسيم أو العمد من السقف: إن وُجد فالبند ليس مرسلاً. */
const LIABILITY_CARVEOUT = /غش|خطا جسيم|اهمال جسيم|تعمد|عمدي|سوء نيه/;

const RULE_GENERIC_LIABILITY_LIMIT: OfficeRule = {
  id: 'generic_liability_limit',
  families: ['services', 'agency', 'licence'],
  enabled: true,
  severity: 'عالٍ',
  title: 'تحديد المسئولية بصيغة عامة دون استثناءات (يُنصح بحذفه وإعادة صياغته)',
  explanation:
    'قاعدة المكتب: بند تحديد المسئولية الذى يرد بصيغة عامة (سقف للتعويض أو استبعاد للأضرار غير المباشرة وخسارة الأرباح) يحمل مستوى مخاطرة عالياً، فيُنصح بحذفه وإعادة صياغته. ' +
    'ورد فى العقد بند يحدد المسئولية أو يستبعد الأضرار غير المباشرة دون استثناء الغش والخطأ الجسيم أو العمد، ولا يتضح فيه من يحميه ولا ما يغطيه.',
  suggestion:
    'حذف البند بصيغته وإعادة صياغته: سقف متناسب مع قيمة العقد ويسرى على الطرفين، يستثنى الغش والخطأ الجسيم والإخلال بالسرية وحماية البيانات وانتهاك الملكية الفكرية، وبيان نوع الأضرار المستبعدة بدقة، وإفراد القوة القاهرة ببند مستقل لا يُخلط بالمسئولية.',
  provenance: 'مصدر القاعدة: ملاحظة محامى المكتب على بند واحد فى عقد واحد (الدفعة 1)، وسببه أن صياغته عامة وفيها مخاطرة عالية؛ فهى أضعف القواعد سنداً وتحتاج عقوداً أخرى لتأكيدها.',
  evaluate: (clauses) =>
    firstPerClause(clauses, (n, clauseNorm) => LIABILITY_LIMIT.test(n) && LIABILITY_TOPIC.test(clauseNorm) && !LIABILITY_CARVEOUT.test(clauseNorm)),
};

// ===================== القاعدة 4 (معطَّلة): الاختصاص للمحاكم الاقتصادية =====================

const ARBITRATION = /(?:يحال|تحال|يحل|يفصل|يسوي|تسوي|يتم تسويه)[^.]{0,80}(?:التحكيم|محكم|هيئه تحكيم)|(?:شرط|اتفاق) (?:ال)?تحكيم|وفقا (?:ل)?قانون (?:ال)?تحكيم/;
/** «المحاكم/للمحاكم/بالمحاكم الاقتصادية» وصيغ المفرد؛ المطابقة على النص الموحَّد، وسابقة اللام لا تمنع المطابقة. */
const ECON_COURTS = /(?:محاكم|محكمه)\s+(?:ال)?اقتصاديه/;

const RULE_ECONOMIC_COURTS: OfficeRule = {
  id: 'economic_courts_forum',
  families: ['services', 'agency', 'licence', 'partnership', 'sale', 'finance'],
  enabled: false,
  severity: 'متوسط',
  title: 'فض المنازعات بالتحكيم بدل الاختصاص للمحاكم الاقتصادية',
  explanation:
    'قاعدة مقترحة (معطلة حتى يؤكدها المكتب): يُفضَّل أن ينعقد الاختصاص بمنازعات العقد للمحاكم الاقتصادية. ورد فى العقد إحالة المنازعات إلى التحكيم دون ذكر المحاكم الاقتصادية. ' +
    'الاختيار بين التحكيم والقضاء قرار استراتيجى لكل عميل، ولا يُعد التحكيم خطأ فى ذاته.',
  suggestion: 'نص ينعقد بموجبه الاختصاص بنظر أى نزاع ينشأ عن تنفيذ العقد أو تفسير بنوده للمحاكم الاقتصادية.',
  provenance:
    'مصدر القاعدة: ملاحظتان على عقد واحد فقط (الدفعة 1)، وتعارضتا مع بند آخر قبله المحامى (اختصاص محكمة ابتدائية عادية)؛ فلا تكفى لتعميمها. معطلة افتراضياً.',
  evaluate: (clauses) => {
    if (clauses.some((c) => ECON_COURTS.test(norm(c.clauseText)))) return [];
    return firstPerClause(clauses, (n) => ARBITRATION.test(n));
  },
};

// ===================== الملف الشخصى الافتراضى =====================

export const DEFAULT_OFFICE_PROFILE: OfficeProfile = {
  id: 'office-default-v1',
  name: 'ممارسة المكتب — الدفعة الأولى (نوفمبر 2026)',
  version: 1,
  rules: [
    RULE_TERM_NO_AUTO_RENEWAL,
    RULE_CONFIDENTIALITY_BREACH,
    RULE_BREACH_NOTICE_CURE,
    RULE_GENERIC_NON_WAIVER,
    RULE_GENERIC_LIABILITY_LIMIT,
    RULE_ECONOMIC_COURTS,
  ],
};

// ===================== التطبيق =====================

export interface OfficeRuleOptions {
  contractType: string | null;
  titleText?: string | null;
  textMayBeIncomplete: boolean;
}

function evidenceOf(hit: OfficeRuleHit): FindingEvidence | null {
  const q = hit.sentence.replace(/\s+/g, ' ').trim();
  const text = q.length <= 300 ? q : q.slice(0, 300).trim();
  if (!quoteInText(text, hit.clause.clauseText)) return null;
  return { clauseIndex: hit.clause.clauseIndex, clauseLabel: hit.clause.clauseLabel, quote: text };
}

/**
 * ملاحظات قواعد المكتب للعقد: ملاحظة واحدة لكل قاعدة منطبقة، بأدلتها (اقتباس حرفى متحقق منه من كل بند مخالف)؛ ما لا اقتباس له يسقط.
 * لا يرمى استثناء لأى نص.
 */
export function officeRuleFindings(
  clauses: LevelClause[],
  opts: OfficeRuleOptions,
  profile: OfficeProfile = DEFAULT_OFFICE_PROFILE,
): ContractFinding[] {
  if (clauses.length === 0) return [];
  const stated = contractFamily(opts.contractType);
  const family = stated === 'unknown' ? inferContractFamily(opts.titleText) : stated;
  const caveat = opts.textMayBeIncomplete
    ? ' تنبيه: توجد تحذيرات قراءة أو ترقيم لهذا الملف، فقد يكون النص المطلوب ضمن جزء لم يُقرأ؛ قارن بالأصل قبل الاعتماد.'
    : '';
  const out: ContractFinding[] = [];
  for (const rule of profile.rules) {
    if (!rule.enabled) continue;
    if (rule.families && !rule.families.includes(family)) continue;
    if (rule.excludeFamilies?.includes(family)) continue;
    let hits: OfficeRuleHit[];
    try {
      hits = rule.evaluate(clauses, { family });
    } catch {
      continue;
    }
    const evidence = hits.map(evidenceOf).filter((e): e is FindingEvidence => e !== null);
    if (evidence.length === 0) continue;
    out.push({
      id: `office:${rule.id}`,
      kind: 'office_rule',
      severity: rule.severity,
      title: rule.title,
      // المصدر (provenance) للتوثيق الداخلى فى الكود فقط: لا يُعرض فى تقرير العميل أسماء دفعات التطوير ولا عدد العقود.
      explanation: `${rule.explanation} وهذه ممارسة تعاقدية للمكتب وليست نصاً قانونياً.${caveat}`,
      suggestion: rule.suggestion,
      evidence: evidence.slice(0, 4),
      source: 'rule',
    });
  }
  return sortFindings(out);
}
