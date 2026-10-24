import { normalizeArabicForMatch } from './reasoning.util';

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
  lawScope?: { lawNo: number; lawYear: number };
}

export const CIVIL_CODE = { lawNo: 131, lawYear: 1948 } as const;

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
    triggers: [/(?:ال)?قوه (?:ال)?قاهره|ظروف (?:ال)?قاهره|حادث (?:ال)?مفاجئ|ظروف طارئه|ظرف طارئ|حوادث استثنائيه|سبب اجنبي|كوارث طبيعيه|جائحه|وباء|اضراب|حاله حرب/],
    // 373: انقضاء الالتزام باستحالة التنفيذ لسبب أجنبى؛ 165: السبب الأجنبى؛ 159: انفساخ العقد؛ 147: الظروف الطارئة
    civilCodeAnchors: [373, 165, 159, 147],
  },
  {
    key: 'data_protection',
    ar: 'حماية البيانات',
    en: 'Data Protection',
    triggers: [/بيانات (?:ال)?شخصيه|حمايه (?:ال)?بيانات|بيانات (?:ال)?(?:عملاء|مستخدمين|موظفين|المتعاقدين)|معالجه (?:ال)?بيانات|تخزين (?:ال)?بيانات|نقل (?:ال)?بيانات|خصوصيه|سريه|معلومات سريه|اسرار|الافصاح|عدم افشاء/],
    civilCodeAnchors: [],
    lawScope: { lawNo: 151, lawYear: 2020 },
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
  const scored: Array<{ key: ContractCriterion; score: number; order: number }> = [];
  CRITERIA.forEach((def, order) => {
    let score = 0;
    for (const re of def.triggers) {
      const m = haystack.match(new RegExp(re.source, re.flags.includes('g') ? re.flags : re.flags + 'g'));
      if (m) score += m.length;
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
export function scopedLawsForCriteria(criteria: ContractCriterion[]): Array<{ lawNo: number; lawYear: number }> {
  return criteria.map((k) => BY_KEY[k]?.lawScope).filter((s): s is { lawNo: number; lawYear: number } => !!s);
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

export function leaseAnchorArticleNumbers(title: string | null | undefined, text: string, max = 3): number[] {
  const haystack = normalizeArabicForMatch(`${title ?? ''} ${text ?? ''}`);
  if (!LEASE_CONTEXT.test(haystack)) return [];
  const out: number[] = [];
  const lists = LEASE_TOPICS.filter((t) => t.pattern.test(haystack)).map((t) => [...t.articles]);
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
