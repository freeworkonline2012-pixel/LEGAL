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
export function classifyClauseCriteria(title: string | null | undefined, text: string): ContractCriterion[] {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${title ?? ''} ${text ?? ''}`);
  // الصياغات المعرَّفة بـ«ال» («الملكية الفكرية») تُطابَق كما تُطابَق نكرتاها: يُحسب الأكثر مطابقةً من النص ونسخته بلا «ال»
  const loose = stripDefiniteArticle(haystack);
  const scored: Array<{ key: ContractCriterion; score: number; order: number }> = [];
  CRITERIA.forEach((def, order) => {
    let score = 0;
    for (const re of def.triggers) {
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
