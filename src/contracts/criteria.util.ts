import { matchesLoose, normalizeArabicForMatch, stripDefiniteArticle } from './reasoning.util';

/**
 * معايير مراجعة العقود العشرة (مرجع المالك). تصنيف البند إليها حتمى بكلمات مفتاحية
 * (بلا LLM): لا يُصدر حكماً، وإنما يحدد (1) وسم البند لتسهيل المراجعة و(2) المواد
 * "المرجعية" التى يجب أن تكون ضمن مرشحى التقييم حتى لو لم يلتقطها البحث العام.
 *
 * المواد المرجعية كلها من القانون المدنى 131/1948 المفهرَس، وتحقَّق نصها الحرفى من
 * migrations/074 قبل ربطها (217 الإعفاء من المسئولية، 221 نطاق التعويض، 215 الاستحالة،
 * 223-225 التعويض الاتفاقى، 226-227 الفوائد، 147 القوة الملزمة والظروف الطارئة،
 * 148 حسن النية، 149 عقود الإذعان، 157-160 الفسخ، 165 السبب الأجنبى، 218 الإعذار).
 */
export type ContractCriterion =
  | 'liability'
  | 'compensation'
  | 'duration'
  | 'payment'
  | 'force_majeure'
  | 'data_protection'
  | 'exit'
  | 'reciprocity'
  | 'legal_compliance'
  | 'financial_impact';

export interface CriterionDef {
  key: ContractCriterion;
  ar: string;
  en: string;
  /** أنماط تُطبَّق على النص بعد التوحيد (normalizeArabicForMatch) */
  triggers: RegExp[];
  /** مواد القانون المدنى المرجعية، بترتيب الأهمية */
  civilCodeAnchors: number[];
  /** بحث مقيَّد بقانون بعينه (حين لا تكفى مادة مرجعية واحدة) */
  lawScope?: LawScope;
}

/** قانون مقيَّد للبحث فيه؛ seed كلمات موضوعية تُسبق نص البند فى استعلام البحث (الاستعلام يقتصر على أول 8 كلمات) */
export interface LawScope {
  lawNo: number;
  lawYear: number;
  seed?: string;
}

export const CIVIL_CODE = { lawNo: 131, lawYear: 1948 } as const;

/**
 * صيغ البيانات الشخصية وحمايتها (بعد التوحيد). توسَّع فى الجولة 5 لتشمل بيانات العملاء والمرضى والمستهلكين والمشتركين،
 * والخرق والتسريب والاختراق والأمن السيبرانى والتسويق الإلكترونى وملفات الارتباط، كى تُربط هذه البنود بقانون 151/2020.
 */
const DATA_PROTECTION_TRIGGER =
  /بيانات (?:ال)?(?:شخصيه|حساسه|عملاء|مستخدمين|موظفين|المتعاقدين|مرضي|مستهلكين|زبائن|مشتركين|عميل|مستخدم)|معلومات (?:ال)?(?:شخصيه|عملاء)|حمايه (?:ال)?(?:بيانات|خصوصيه)|معالجه (?:ال)?بيانات|تخزين (?:ال)?بيانات|نقل (?:ال)?بيانات|تسريب (?:ال)?بيانات|خرق (?:ال)?بيانات|اختراق (?:ال)?(?:بيانات|انظمه|نظم)|الامن السيبراني|امن (?:ال)?معلومات|التسويق (?:ال)?الالكتروني|ملفات (?:ال)?(?:ارتباط|تعريف)|مسئول حمايه (?:ال)?بيانات|مسؤول حمايه (?:ال)?بيانات|متحكم (?:ال)?بيانات|معالج (?:ال)?بيانات/;

/**
 * مواضيع تُقيَّد البحث فيها بقانون بعينه بصرف النظر عن المعيار الموسوم (الجولة 5): التحكيم ⇒ قانون 27/1994،
 * الملكية الفكرية وحقوق المؤلف والعلامات والبراءات وبرامج الحاسب ⇒ قانون 82/2002، البيانات الشخصية ⇒ قانون 151/2020.
 * هذا ربط بمرشحين للتقييم فقط (مادتان كحد أقصى لكل قانون) وليس حكماً؛ غياب القانون من القاعدة يعنى غياب مرشحيه بلا اختلاق.
 */
const TOPIC_SCOPES: ReadonlyArray<{ pattern: RegExp; scope: LawScope }> = [
  {
    // «المحكمة» تحوى «محكم» لذا يُشترط حد الكلمة للمحكَّم؛ و«تحكيم» لا يرد داخل «المحكمة»
    pattern: /تحكيم|(?<![ء-ي])(?:ال|لل|بال|وال|فال)?محكم(?:ا|ين|ون|ي)?(?![ء-ي])|غرفه التجاره الدوليه|اونسيترال|uncitral|crcica|\bicc\b/i,
    scope: { lawNo: 27, lawYear: 1994, seed: 'التحكيم اتفاق المحكمين حكم' },
  },
  {
    pattern:
      /ملكيه فكريه|حقوق (?:ال)?(?:مؤلف|نشر|طبع)|حق (?:ال)?مؤلف|براءه اختراع|براءات|علامه تجاريه|علامات تجاريه|الاسم التجاري|نموذج صناعي|نماذج صناعيه|رسوم ونماذج|تصميم صناعي|برنامج (?:ال)?حاسب|برامج (?:ال)?حاسب|برمجيات|(?:شفر|كود)\S*\s+(?:ال)?مصدري|قاعده بيانات|قواعد بيانات|اسرار (?:ال)?(?:تجاريه|مهنه)|سر (?:ال)?تجاري|معلومات غير مفصح|رخصه استخدام|ترخيص (?:ال)?استخدام|حق (?:ال)?استغلال/,
    scope: { lawNo: 82, lawYear: 2002, seed: 'الملكيه الفكريه حقوق المؤلف' },
  },
  {
    pattern: DATA_PROTECTION_TRIGGER,
    scope: { lawNo: 151, lawYear: 2020, seed: 'البيانات الشخصيه معالجه حمايه' },
  },
];

export const CRITERIA: readonly CriterionDef[] = [
  {
    key: 'liability',
    ar: 'المسؤولية',
    en: 'Liability',
    triggers: [/مسئول|مسؤول|يعفي|اعفاء|لا يتحمل|لا يسال|سقف/],
    civilCodeAnchors: [217, 221, 215],
  },
  {
    key: 'compensation',
    ar: 'التعويض',
    en: 'Compensation',
    triggers: [/تعويض|شرط جزائي|جزاء|غرامه|غرامات|ضرر|اضرار/],
    civilCodeAnchors: [224, 223, 225],
  },
  {
    key: 'duration',
    ar: 'المدة',
    en: 'Duration',
    triggers: [/مده العقد|مده هذا العقد|تبدا مده|مده سريان|ينتهي العقد بانتهاء|يجدد|تجديد|تمتد|مده \d+|لمده/],
    civilCodeAnchors: [],
  },
  {
    key: 'payment',
    ar: 'شروط الدفع',
    en: 'Payment',
    triggers: [/الاجره|القيمه الايجاريه|الثمن|المقابل|يسدد|سداد|يدفع|دفعه|دفعات|فاتوره|مستحقات|فوائد|الاستحقاق/],
    civilCodeAnchors: [226, 227],
  },
  {
    key: 'force_majeure',
    ar: 'القوة القاهرة',
    en: 'Force Majeure',
    triggers: [/(?:ال)?قوه (?:ال)?قاهره|ظروف (?:ال)?قاهره|(?:ال)?اسباب (?:ال)?قهريه|ظروف قهريه|خارجه? عن (?:ال)?اراده|حادث (?:ال)?مفاجئ|ظروف طارئه|ظرف طارئ|حوادث استثنائيه|سبب اجنبي|كوارث طبيعيه|جائحه|وباء|اضراب|حاله حرب/],
    // 373: انقضاء الالتزام باستحالة التنفيذ لسبب أجنبى؛ 165: السبب الأجنبى؛ 159: انفساخ العقد؛ 147: الظروف الطارئة
    civilCodeAnchors: [373, 165, 159, 147],
  },
  {
    key: 'data_protection',
    ar: 'حماية البيانات',
    en: 'Data Protection',
    triggers: [DATA_PROTECTION_TRIGGER, /خصوصيه|سريه|معلومات سريه|اسرار|الافصاح|عدم افشاء/],
    civilCodeAnchors: [],
    lawScope: { lawNo: 151, lawYear: 2020, seed: 'البيانات الشخصيه معالجه حمايه' },
  },
  {
    key: 'exit',
    ar: 'استراتيجية الخروج / الإنهاء',
    en: 'Exit Strategy',
    triggers: [/فسخ|انهاء العقد|انهاء هذا العقد|ينهي|انذار|اخطار|مفسوخ|الاخلاء|اخلاء|الغاء العقد|انقضاء العقد|الاستغناء/],
    civilCodeAnchors: [158, 157, 160, 218],
  },
  {
    key: 'reciprocity',
    ar: 'المعاملة بالمثل',
    en: 'Reciprocity',
    triggers: [/دون موافقه|بارادته المنفرده|بارادتها المنفرده|وحده الحق|منفردا|منفرده|حق الطرف الاول وحده|للطرف الاول (?:ان|الحق)|دون الرجوع|دون اخطار|بدون موافقه|بدون اخطار/],
    civilCodeAnchors: [148, 149, 147],
  },
  {
    key: 'legal_compliance',
    ar: 'الامتثال القانوني',
    en: 'Legal Compliance',
    triggers: [/القانون واجب التطبيق|القانون الحاكم|الاختصاص|التحكيم|المحكمه المختصه|ترخيص|تراخيص|الجهات الرقابيه|الامتثال|القوانين الساريه|القوانين واللوائح|الاحكام القانونيه/],
    civilCodeAnchors: [],
  },
  {
    key: 'financial_impact',
    ar: 'الأثر المالي',
    en: 'Financial Impact',
    triggers: [/ضريب|رسوم|تامين نقدي|وديعه|خطاب ضمان|ضمان|زياده|بالمائه|في المائه|بنسبه|مصاريف|مصروفات|نفقات/],
    civilCodeAnchors: [224, 226, 227],
  },
];

const BY_KEY: Record<string, CriterionDef> = Object.fromEntries(CRITERIA.map((c) => [c.key, c]));

export function criterionLabel(key: string): string | null {
  return BY_KEY[key]?.ar ?? null;
}

/**
 * يصنّف نص البند (مع عنوانه) إلى معيار أو أكثر (بحد أقصى 3، بترتيب عدد المطابقات
 * ثم ترتيب المعايير). لا يُفترض أن التصنيف حكم قانونى: هو وسم تقريبى.
 */
/**
 * الجولة 77: فى عقد أتعاب محاماة تدور موضوعات البنود حول «قضايا التعويض» و«مبلغ التعويض المرفوع به الدعوى» (محل عمل المحامى لا التزام تعاقدى بتعويض).
 * كلمة «تعويض» وحدها كانت توسم بند الأتعاب بمعيار «التعويض» فتُرفق به م223–225 (التعويض الاتفاقى) فاعتمدها النموذج على نسبة أتعاب
 * (إنتاج 2026-11-09: «يحدد البند التعويض مقدماً» عن نسبة 10% أتعاب). فى هذا النوع من العقود لا يُوسَم البند بالتعويض إلا بصيغة جزاء/تعويض اتفاقى صريحة.
 */
const STRICT_PENALTY_TRIGGERS: RegExp[] = [/شرط جزائي|تعويض اتفاقي|تعويضا اتفاقيا|تعويض مقدر|غرامه|غرامات|جزاء/];

export interface ClassifyOptions {
  /** العقد كله عقد أتعاب محاماة (isAttorneyFeeContract) */
  attorneyFeeContract?: boolean;
}

export function classifyClauseCriteria(title: string | null | undefined, text: string, opts?: ClassifyOptions): ContractCriterion[] {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${title ?? ''} ${text ?? ''}`);
  // الصياغات المعرَّفة بـ«ال» («الملكية الفكرية») تُطابَق كما تُطابَق نكرتاها: يُحسب الأكثر مطابقةً من النص ونسخته بلا «ال»
  const loose = stripDefiniteArticle(haystack);
  const scored: Array<{ key: ContractCriterion; score: number; order: number }> = [];
  CRITERIA.forEach((def, order) => {
    let score = 0;
    const triggers = opts?.attorneyFeeContract && def.key === 'compensation' ? STRICT_PENALTY_TRIGGERS : def.triggers;
    for (const re of triggers) {
      const g = new RegExp(re.source, re.flags.includes('g') ? re.flags : re.flags + 'g');
      score += Math.max(haystack.match(g)?.length ?? 0, loose.match(g)?.length ?? 0);
    }
    if (score > 0) scored.push({ key: def.key, score, order });
  });
  return scored
    .sort((a, b) => b.score - a.score || a.order - b.order)
    .slice(0, 3)
    .map((s) => s.key);
}

/** مواد القانون المدنى المرجعية للمعايير المكتشفة، بلا تكرار وبحد أقصى `max` */
export function anchorArticleNumbers(criteria: ContractCriterion[], max = 3): number[] {
  const out: number[] = [];
  // جولة واحدة لكل معيار بالتناوب كى لا يستحوذ المعيار الأول على كل الحصة
  const lists = criteria.map((k) => [...(BY_KEY[k]?.civilCodeAnchors ?? [])]);
  let progressed = true;
  while (out.length < max && progressed) {
    progressed = false;
    for (const list of lists) {
      const next = list.shift();
      if (next !== undefined) {
        progressed = true;
        if (!out.includes(next) && out.length < max) out.push(next);
      }
    }
  }
  return out;
}

/** القوانين المقيَّدة المطلوب البحث فيها لهذه المعايير (مثل حماية البيانات) */
export function scopedLawsForCriteria(criteria: ContractCriterion[]): LawScope[] {
  return criteria.map((k) => BY_KEY[k]?.lawScope).filter((s): s is LawScope => !!s);
}

/**
 * القوانين المقيَّدة لبند بعينه: ما تفرضه معاييره ثم ما يفرضه موضوعه (تحكيم، ملكية فكرية، بيانات شخصية)، بلا تكرار.
 * هذا ما يضمن أن بنداً عن حقوق الملكية أو التحكيم أو البيانات الشخصية يحمل مرشحاً من القانون المخصص له ولو لم يوسَم بمعيار.
 */
export function scopedLawsForClause(
  criteria: ContractCriterion[],
  title: string | null | undefined,
  text: string,
): LawScope[] {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${text ?? ''}`);
  const out: LawScope[] = [];
  const add = (s: LawScope) => {
    if (!out.some((o) => o.lawNo === s.lawNo && o.lawYear === s.lawYear)) out.push(s);
  };
  scopedLawsForCriteria(criteria).forEach(add);
  for (const t of TOPIC_SCOPES) if (matchesLoose(t.pattern, haystack)) add(t.scope);
  return out;
}

/** يحوّل قائمة المفاتيح إلى النص المخزَّن فى clause_type_guess (مفاتيح مفصولة بفاصلة) */
export function serializeCriteria(criteria: ContractCriterion[]): string | null {
  return criteria.length > 0 ? criteria.join(',') : null;
}

/**
 * بنود عقود الإيجار: مواد فصل الإيجار من القانون المدنى (558-609) بحسب موضوع البند. نصها
 * الحرفى متحقَّق منه من migrations/074 (576-578 ضمان العيوب وبطلان الإعفاء عند تعمد
 * الإخفاء، 579-583 التزامات المستأجر، 586 وفاء الأجرة، 590-591 رد العين، 593-595
 * التنازل والإيجار من الباطن، 598-599 انتهاء المدة والتجديد، 604 نقل الملكية،
 * 607-608 الإنهاء المبكر). تُفعَّل فقط حين يظهر من البند نفسه أنه بند إيجار.
 */
const LEASE_CONTEXT = /مؤجر|مستاجر|ايجار|الاجره|العين المؤجره/;

const LEASE_TOPICS: ReadonlyArray<{ pattern: RegExp; articles: number[] }> = [
  { pattern: /عاين|معاينه|الجهاله|عيوب|عيب/, articles: [576, 578, 577] },
  { pattern: /ديكور|تغيير|هدم|بناء|تعديلات/, articles: [580, 581] },
  { pattern: /من الباطن|التنازل عن/, articles: [593, 594, 595] },
  { pattern: /تسليم العين|رد العين|اخلاء|انتهاء العقد|انتهاء مده/, articles: [590, 591, 598] },
  { pattern: /الاجره|القيمه الايجاريه|سداد|يسدد|يدفع/, articles: [586] },
  { pattern: /انهاء|فسخ|اخطار/, articles: [608, 607] },
  { pattern: /مده|سنه|سنوات|تجديد|يجدد/, articles: [598, 599] },
  { pattern: /استخدام|استعمال|مقر|نشاط/, articles: [579, 583] },
  { pattern: /صيانه|ترميم|اصلاح/, articles: [582, 567] },
  { pattern: /نقل الملكيه|يحل محل|خلف/, articles: [604] },
];

/** توزيع دورى للمواد بين المواضيع المطابقة (الأول من كل موضوع، ثم الثانى…) حتى الحد الأقصى. */
function roundRobinArticles(lists: number[][], max: number): number[] {
  const out: number[] = [];
  let progressed = true;
  while (out.length < max && progressed) {
    progressed = false;
    for (const list of lists) {
      const next = list.shift();
      if (next !== undefined) {
        progressed = true;
        if (!out.includes(next) && out.length < max) out.push(next);
      }
    }
  }
  return out;
}

export function leaseAnchorArticleNumbers(title: string | null | undefined, text: string, max = 3): number[] {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${text ?? ''}`);
  if (!matchesLoose(LEASE_CONTEXT, haystack)) return [];
  return roundRobinArticles(
    LEASE_TOPICS.filter((t) => matchesLoose(t.pattern, haystack)).map((t) => [...t.articles]),
    max,
  );
}

/**
 * الجولة 92: بنود عقود القرض والتمويل. عقد تمويل ممسوح (14 بنداً) ظهر فى سجل الإنتاج أن بنوده لا تُسترجع لها مواد القرض والكفالة بل مراسى الفوائد وحدها (224/226/227):
 * بند الكفالة المطلقة («يضمن شخصياً وبالتضامن جميع التزامات الشركة دون حد») والسداد المعجل بغرامة (544 «لا يجوز إلزامه بمقابل بسبب تعجيل الوفاء») والحوالة بلا إخطار (305)
 * لم تصل إلى النموذج فخرجت بلا ملاحظة. مواد القانون المدنى (131/1948) نصها الحرفى متحقَّق منه من migrations/074: 538-539 عقد القرض وتسليمه، 542 الفوائد،
 * 543 انتهاء القرض بانتهاء ميعاده، 544 الرد قبل الأجل، 273 سقوط الأجل، 773/778/780/781/788 الكفالة (الكتابة، الدين المستقبل بمبلغ محدد، عدم تجاوز الدين، الملحقات، التجريد)،
 * 303/305 الحوالة ونفاذها. الكفالة تُسترجع ولو لم يظهر القرض لأن عقوداً أخرى (إيجار، توريد) تكفل التزاماتها بالطريقة نفسها؛ أما بقية المواضيع فمشروطة بسياق القرض/التمويل.
 */
const LOAN_CONTEXT = /قرض|مقرض|مقترض|ممول|تمويل|الممول/;
const LOAN_TOPICS: ReadonlyArray<{ pattern: RegExp; articles: number[] }> = [
  { pattern: /السداد المعجل|السداد المبكر|الوفاء المعجل|الوفاء المبكر|تعجيل (?:السداد|الوفاء)|سداد (?:القرض|المبلغ|الدين) (?:قبل|مبكر)/, articles: [544] },
  { pattern: /حلول (?:الاجل|اجل)|يحل (?:الاجل|اجل)|سقوط الاجل|عند الطلب|مده القرض|انتهاء القرض|استحقاق (?:القرض|الدين)|حالا|فورا/, articles: [273, 543] },
  { pattern: /فائده|فوائد|عائد|عموله/, articles: [542] },
  { pattern: /مبلغ القرض|صرف|يخصم|خصم|اقتطاع|مصروفات|تسليم المبلغ/, articles: [538, 539] },
  { pattern: /الحواله|حواله|يحيل|احاله حقوق|التنازل عن (?:حقوقه|الدين|القرض|العقد)/, articles: [305, 303] },
];
const SURETY_TOPIC = /كفال|كفيل|كفل|ضامن|يضمن (?:\S+ ){0,3}(?:شخصيا|بالتضامن)/;
const SURETY_ARTICLES = [778, 780, 773, 788, 781];

export function loanAnchorArticleNumbers(title: string | null | undefined, text: string, max = 3): number[] {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${text ?? ''}`);
  const lists: number[][] = [];
  if (matchesLoose(SURETY_TOPIC, haystack)) lists.push([...SURETY_ARTICLES]);
  if (matchesLoose(LOAN_CONTEXT, haystack)) lists.push(...LOAN_TOPICS.filter((t) => matchesLoose(t.pattern, haystack)).map((t) => [...t.articles]));
  return roundRobinArticles(lists, max);
}

/**
 * بنود عقود الخدمات والمقاولة والتوريد والتطوير: مواد عقد المقاولة من القانون المدنى (646-667) بحسب موضوع البند.
 * نصها الحرفى متحقَّق منه من migrations/074 (648-650 جودة المادة وطريقة التنفيذ، 651-654 ضمان المبانى، 655 تسلم العمل،
 * 656 وقت استحقاق الأجر، 657-659 تقدير الأجر والزيادة، 661-662 المقاول من الباطن، 663 تحلل رب العمل، 664-665 الاستحالة
 * والهلاك). تُفعَّل فقط حين يظهر من البند نفسه أنه بند خدمات/مقاولة، وتُستبعد بنود الإيجار والبيع والعمل.
 */
const SERVICES_CONTEXT =
  /مقاول|رب العمل|مقدم الخدمه|تنفيذ (?:العمل|المشروع|الاعمال|الخدمات)|الخدمات المتفق|اعمال التطوير|تطوير|برمج|برنامج|منصه|تطبيق|المشروع|اتمام العمل|تسليم (?:العمل|المشروع|الاعمال)/;
const SERVICES_EXCLUDE = /مؤجر|مستاجر|ايجار|العين المؤجره|بائع|مشتري|المبيع|صاحب العمل|العامل|الراتب|اجر شهري/;

const SERVICES_TOPICS: ReadonlyArray<{ pattern: RegExp; articles: number[] }> = [
  { pattern: /تسليم|تسلم|استلام|قبول|محضر/, articles: [655, 650] },
  { pattern: /الاجر|المقابل|الدفعه|دفعات|سداد|يسدد|مستخلص|قيمه العقد|الاتعاب|رسوم/, articles: [656, 659, 658] },
  { pattern: /اجر اجمالي|مقطوع|زياده|اعمال اضافيه|اعمال جديده|تعديل|مجاوزه/, articles: [658, 657] },
  { pattern: /من الباطن|التعاقد مع الغير|التنازل عن العقد|الاسناد/, articles: [661, 662] },
  { pattern: /انهاء|فسخ|وقف التنفيذ|وقف العمل|الغاء/, articles: [663, 664] },
  { pattern: /مواد|جوده|مطابق|مواصفات|معيب|عيوب|اصول الفن/, articles: [648, 650, 649] },
  { pattern: /مبان|منشات|تهدم|انشاءات|عماره|اعمال بناء/, articles: [651, 653, 654] },
  { pattern: /استحاله|هلاك|حادث مفاجئ|قوه قهريه/, articles: [664, 665] },
];

/**
 * `contractIsServices`: نوع العقد (من مدخل المستخدم) خدمات/مقاولة/توريد. حينئذ يُكتفى به سياقاً: بنود مثل «لا يجوز لأحد الطرفين
 * فسخ العقد من جانب واحد» لا تحوى كلمة مقاولة أو برنامج فكان السياق على مستوى البند وحده يُسقطها فلا تُقيَّم. الاستبعاد
 * (إيجار/بيع/عمل) يبقى على مستوى البند فى الحالين.
 */
export function servicesAnchorArticleNumbers(
  title: string | null | undefined,
  text: string,
  max = 3,
  contractIsServices = false,
): number[] {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${text ?? ''}`);
  if ((!contractIsServices && !matchesLoose(SERVICES_CONTEXT, haystack)) || matchesLoose(SERVICES_EXCLUDE, haystack)) return [];
  return roundRobinArticles(
    SERVICES_TOPICS.filter((t) => matchesLoose(t.pattern, haystack)).map((t) => [...t.articles]),
    max,
  );
}

/**
 * بنود ملكية البرامج والمصنفات: مواد قانون حماية الملكية الفكرية 82/2002 المتحقَّق من نصها فى migrations/239
 * (140 المصنفات المحمية ومنها برامج الحاسب، 147 الحق الاستئثارى للمؤلف، 149 شرط نقل الحقوق المالية كتابةً وتفصيلاً،
 * 150 المقابل النقدى أو العينى لنقلها، 151 رقابة المحكمة على الاتفاق المجحف). بحث نصى عام كان يختار المادة 802 المدنية
 * (حق المالك) لبند «ملكية البرامج للطرف الأول»، وهى لا تحكم الحقوق على المصنفات؛ والمراسى تضع المواد الأقرب موضوعاً أمام النموذج.
 * تُفعَّل فقط حين يظهر من البند نفسه أنه بند ملكية فكرية أو برامج.
 */
export const IP_LAW = { lawNo: 82, lawYear: 2002 } as const;
const IP_CONTEXT =
  /ملكيه فكريه|حقوق (?:ال)?(?:مؤلف|ملكيه)|حق (?:ال)?مؤلف|(?:شفر|كود)\S*\s+(?:ال)?مصدري|(?:ملكيه|مملوك|ملك)\S*.{0,50}(?:البرامج|برنامج|البرمجيات|النظام|الكود|التطبيق)|(?:البرامج|برنامج|البرمجيات|التطبيق).{0,50}(?:مملوك|ملكيه|ملكا)/;
const IP_TOPICS: ReadonlyArray<{ pattern: RegExp; articles: number[] }> = [
  { pattern: /ملكيه|مملوك|ملكا|حقوق|حق /, articles: [147, 140] },
  { pattern: /نقل|تنازل|تصريح|ترخيص|بيع|تسويق|تسليم الشفره|التصرف/, articles: [149, 147] },
  { pattern: /مقابل|ثمن|اجر|نسبه/, articles: [150, 149] },
  { pattern: /مجحف|اخلال|تعويض/, articles: [151] },
];

export function ipAnchorArticleNumbers(title: string | null | undefined, text: string, max = 3): number[] {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${text ?? ''}`);
  if (!matchesLoose(IP_CONTEXT, haystack)) return [];
  return roundRobinArticles(
    IP_TOPICS.filter((t) => matchesLoose(t.pattern, haystack)).map((t) => [...t.articles]),
    max,
  );
}

/**
 * عقود أتعاب المحاماة والوكالة بالخصومة (الجولة 74). تشخيص الجولة 73 على عقد أتعاب حقيقى: البحث النصى والدلالى لم يرجعا
 * ولا مادة من قانون المحاماة ولا من الوكالة (كلها قوانين ضريبة/شركات/تجارى)، والمراسى كانت مواد المسئولية والتعويض فقط،
 * فرفض النموذج كل المرشحين وخرج البندان «لا نص مفهرس» رغم أن النص الحاكم مفهرس. المراسى هنا نصها الحرفى متحقَّق منه
 * من migrations/012 وmigrations/074:
 * - قانون المحاماة 17/1983: م82 (حق المحامى فى الأتعاب وفق العقد، سقف 20% عند التقدير، منع الحصة العينية من الحق المتنازع عليه)،
 *   م83 (استحقاق الأتعاب المتفق عليها عند الصلح/التحكيم، واستحقاقها إن أنهى الموكل الوكالة بلا مسوغ قبل إتمام المهمة).
 *   لم تُربط م84 (ساقطة بحكم دستورى) ولا م85 (حالتها غير محسومة).
 * - القانون المدنى 131/1948 فى الوكالة: 699 تعريف الوكالة، 704 عناية الوكيل (المعتاد إن كانت بأجر)، 709 الوكالة تبرعية ما لم يُتفق
 *   على أجر والأجر خاضع لتقدير القاضى، 714 انتهاء الوكالة، 715 إنهاء الموكل لها فى أى وقت ولو خالف اتفاق (والتعويض إن كانت بأجر وبلا
 *   مسوغ)، 716 تنازل الوكيل.
 * التفعيل: العقد كله عقد أتعاب محاماة (محامٍ + أتعاب/موكل/توكيل/دعوى)، أو البند نفسه يجمع الأتعاب مع المحامى/الموكل/الوكيل.
 * وهى مرشحات للتقييم فقط، لا حكم؛ يبقى القرار للنموذج بنص المادة.
 */
export const ADVOCACY_LAW = { lawNo: 17, lawYear: 1983 } as const;

const ATTORNEY_ANY = /محام/;
const ATTORNEY_FEE_SIGNAL = /اتعاب|موكل|توكيل|وكاله|دعوي|دعاوي|قضيه|قضايا|مرافعه|تمثيل قانوني/;
const ATTORNEY_CLAUSE_SIGNAL = /(?:اتعاب|الاتعاب).{0,80}(?:محام|موكل|وكيل|وكاله)|(?:محام|موكل|وكيل|وكاله).{0,80}(?:اتعاب|الاتعاب)/;

/**
 * الجولة 79: تسمية نوع العقد على الغلاف حين يكون عقد أتعاب محاماة. لا تحوى «وكالة» عمداً (contractFamily يقرأها agency قبل services)، وتبقى فى عائلة
 * الخدمات فيبقى الدليل التفاوضى كما هو، فالتغيير فى ما يُقرأ على الغلاف لا فى نوع الدليل.
 */
export const ATTORNEY_FEE_CONTRACT_LABEL = 'عقد أتعاب محاماة';

/** هل نص العقد كله عقد أتعاب محاماة؟ (محامٍ + أتعاب/موكل/توكيل/دعوى). يُحسب مرة واحدة لكل عقد. */
export function isAttorneyFeeContract(contractText: string): boolean {
  const h = normalizeArabicForMatch(contractText ?? '');
  return matchesLoose(ATTORNEY_ANY, h) && matchesLoose(ATTORNEY_FEE_SIGNAL, h) && matchesLoose(/اتعاب|موكل|توكيل/, h);
}

/**
 * الجولة 76: سياق العقد كله للنموذج حين يقيّم فقرة منه. فى عقد أتعاب ممسوح تُقسَّم الفقرات تقسيماً تقريبياً فتصل الفقرة للنموذج وحدها
 * («تسدد الشركة مبلغ كذا شهرياً») بلا ما يدل على أن العلاقة محامٍ/موكل، فلا يربطها بمادة 82 أو 709 ويختار «لا يوجد نص» (م82/709 وصلتاه كمراسٍ
 * ورُفضتا فى إنتاج الجولة 75). السياق بيانات وصفية حتمية (isAttorneyFeeContract) لا حكم، وتبقى ضوابط الخطوات الأربع كما هى.
 */
export const ATTORNEY_FEE_CONTRACT_CONTEXT =
  'اتفاق أتعاب محاماة: علاقة وكالة بأجر بين موكل (عميل) ومحامٍ أو مكتب محاماة؛ يحكمها قانون المحاماة 17 لسنة 1983 (الأتعاب والمصروفات وإنهاء الوكالة) وأحكام الوكالة فى القانون المدنى.';

export function contractContextFor(attorneyFeeContract: boolean): string | null {
  return attorneyFeeContract ? ATTORNEY_FEE_CONTRACT_CONTEXT : null;
}

const ATTORNEY_TOPICS: ReadonlyArray<{ pattern: RegExp; law17: number[]; civil: number[] }> = [
  { pattern: /اتعاب|اجر|مقابل|مبلغ|سداد|يسدد|دفعه|دفعات|مقدم|مصروفات|رسوم|نجاح|حصه|نسبه/, law17: [82], civil: [709] },
  { pattern: /انهاء|فسخ|الغاء|عزل|تنازل|انسحاب|وقف|صلح|تحكيم|دون مسوغ|بدون مسوغ|قبل (?:ال)?انتهاء|اتمام المهمه/, law17: [83], civil: [715, 716] },
  { pattern: /مده|سنه|سنوات|اشهر|شهر|تجديد|يجدد|ينتهي|سريان/, law17: [], civil: [714] },
  { pattern: /مسئوليه|مسوليه|تقصير|اهمال|عنايه|خطا|ضمان|التزام|بذل/, law17: [], civil: [704] },
  { pattern: /وكاله|توكيل|تمثيل|اعمال المحاماه|نطاق|قضيه|دعوي/, law17: [], civil: [699] },
];

/**
 * مراسى بند فى عقد أتعاب محاماة: مواد من قانون المحاماة (حتى 2) ومن الوكالة بالمدنى (حتى 3) بحسب موضوع البند.
 * `attorneyFeeContract` حكم العقد كله (isAttorneyFeeContract). بند بلا موضوع مطابق فى عقد أتعاب يأخذ م82 من قانون المحاماة وم704 المدنية كأساس.
 */
export function attorneyFeeAnchorArticleNumbers(
  title: string | null | undefined,
  text: string,
  attorneyFeeContract: boolean,
): { law17: number[]; civil: number[] } {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${text ?? ''}`);
  const active = attorneyFeeContract || matchesLoose(ATTORNEY_CLAUSE_SIGNAL, haystack);
  if (!active) return { law17: [], civil: [] };
  const hits = ATTORNEY_TOPICS.filter((t) => matchesLoose(t.pattern, haystack));
  if (hits.length === 0) return attorneyFeeContract ? { law17: [82], civil: [704] } : { law17: [], civil: [] };
  return {
    law17: roundRobinArticles(hits.map((t) => [...t.law17]), 2),
    civil: roundRobinArticles(hits.map((t) => [...t.civil]), 3),
  };
}
