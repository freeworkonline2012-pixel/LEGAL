import type { PlaybookFamily } from './playbook';
import { norm } from './playbook-util';
import { matchesLoose } from './reasoning.util';

/**
 * بوابة نطاق القانون (الجولة 60): قوانين قطاعية لا تحكم إلا نشاطاً بعينه، فلا تُعرض مواده على عقد لا يشير نصه إلى ذلك النشاط.
 * وقع فى إنتاج عقد خدمات تحصيل إلكترونى (0174): ظهر القانون 176 لسنة 2018 (التأجير التمويلى والتخصيم) «قانوناً حاكماً» فى الغلاف،
 * واستُشهد بمادته 65 فى تقييم بند العمولات، فبدا البند مراجَعاً قانونياً وهو لم يُراجَع على قانونه الصحيح. بوابة نوع العقد وحدها (article-scope)
 * لا تكفى لأن النوع كثيراً ما لا يُختار عند الرفع؛ لذا تُقرأ الإشارات من نص العقد كله.
 *
 * القاعدة: القانون القطاعى يُقبل إذا ورد فى نص العقد أى مؤشر لنشاطه (أو كانت أسرة العقد المعلومة مما يحتمله)؛ لا مؤشر ⇒ يُحجب حتماً قبل التقييم.
 * الأسرة المجهولة لا تُعفى القانون من اشتراط المؤشر (عكس بوابة المادة)، لأن الحجب هنا مبنى على غياب الدليل فى النص نفسه لا على النوع.
 */
interface SectorLaw {
  lawNo: number;
  lawYear: number;
  /** نشاط القانون، للتقارير والاختبارات. */
  sector: string;
  /** مؤشرات النشاط على النص الموحَّد (norm) — تُجرَّب بلا «ال» التعريف أيضاً. */
  signals: RegExp[];
  /** أسر عقود يُقبل لها القانون دون مؤشر نصى لأن نوعها نفسه قد يكون نشاطه. */
  allowFamilies?: ReadonlyArray<PlaybookFamily>;
  /** تُحذف أسماء شركات التأمين من النص قبل مطابقة المؤشرات (قوانين قطاع التأمين). */
  stripInsurerNames?: boolean;
}

/**
 * مؤشرات قطاع التأمين (الجولة 62): عبارات موضوع لا مجرد لفظ «تأمين»؛ فلفظ «تأمين» وحده يرد فى اسم الطرف («شركة … للتأمين») ولا يجعل العقد عقد تأمين
 * (وقع فى 0174: عقد تحصيل إلكترونى مع شركة تأمين مرّ عليه قرارات هيئة الرقابة المالية على الوساطة وإصدار الوثائق). تُحذف أسماء الشركات قبل المطابقة.
 */
const INSURANCE_SIGNALS: RegExp[] = [/وثيقه تامين|وثائق تامين|اصدار (?:ال)?وثائق|اعاده التامين|عقد (?:ال)?تامين|وساطه (?:في )?(?:ال)?تامين|وسيط تامين|وسطاء التامين|اقساط (?:ال)?تامين|اكتتاب/];

/** اسم شركة تأمين على صيغة «شركة … للتأمين …»: لا يُحسب مؤشراً. لا يُحذف إن تضمن «وساطة/وسيط» لأنه حينئذ نشاط لا اسم فقط. */
const INSURER_NAME = /(?<![ء-ي])(?:ال)?(?:شركه|شركات|مجموعه|هيئه|اتحاد)\s+(?:(?!وساط|وسيط|وسطاء)[ء-ي]+\s+){0,5}?للتامين(?:\s+(?:ال)?(?:تكافلي|تعاوني|عامه|حياه|ممتلكات|والمعاشات))?/g;
const withoutInsurerNames = (t: string): string => t.replace(INSURER_NAME, ' ');

/**
 * مؤشرات حماية المستهلك (الجولة 63، قرار المستشار): القانون 181 لسنة 2018 يظهر إذا كان محل العقد سلعة أو خدمة استهلاكية، سواء كان الطرفان
 * شخصين طبيعيين أم شركتين أم أحدهما. عقد بين شركتين لا يشير نصه إلى مستهلك ولا سلعة استهلاكية (مثل تحصيل أقساط الوثائق) لا يُعرض عليه.
 */
const CONSUMER_SIGNALS: RegExp[] = [/مستهلك/, /(?:سلع|سلعه|منتجات|منتج|بضاعه|بضائع|خدمات|خدمه)\s+استهلاك/, /بيع (?:ب)?(?:ال)?تجزئه|تجاره (?:ال)?تجزئه|بيع للجمهور/];

/**
 * مؤشرات الإيجار القديم (الجولة 69): القانون 164 لسنة 2025 ينظّم انتهاء/زيادة الأجرة فى عقود الإيجار القديمة الخاضعة للقانونين 49/1977 و136/1981
 * وامتدادها القانونى؛ وليس قانوناً عاماً «للإيجارات الجديدة». وقع فى إنتاج عقد إيجار سكنى حديث (2018، قانون 4/1996 والقانون المدنى) أن استُشهد بمادته 6
 * (زيادة سنوية 15%) فى تقييم بند الزيادة، فوُصف البند بأنه «يخالف القانون الجديد» وهو لا ينطبق. يُقبل إذا ورد فى النص ما يدل على علاقة إيجار قديمة.
 */
const OLD_RENT_SIGNALS: RegExp[] = [
  /ايجار قديم|الايجار القديم|عقود الايجار القديمه|عقد ايجار قديم/,
  /49\s*(?:لسنه|\/|-)\s*1977/,
  /136\s*(?:لسنه|\/|-)\s*1981/,
  /امتداد (?:ال)?قانوني|الامتداد القانوني|امتداد (?:ال)?عقد بقوه (?:ال)?قانون|امتد العقد (?:ال)?قانون/,
  /164\s*(?:لسنه|\/|-)\s*2025/,
];

const SECTOR_LAWS: ReadonlyArray<SectorLaw> = [
  { lawNo: 181, lawYear: 2018, sector: 'حماية المستهلك', signals: CONSUMER_SIGNALS },
  { lawNo: 164, lawYear: 2025, sector: 'الإيجار القديم', signals: OLD_RENT_SIGNALS },
  {
    lawNo: 176,
    lawYear: 2018,
    sector: 'التأجير التمويلى والتخصيم',
    signals: [/تاجير تمويل/, /ايجار تمويل/, /تخصيم/, /فاكتورينج|factoring/i, /مؤجر تمويل|مستاجر تمويل/, /شراء (?:ال)?حقوق (?:ال)?مالي/, /شركه (?:ال)?تخصيم|شركه (?:ال)?تاجير تمويل/],
    allowFamilies: ['finance'],
  },
  // قطاع التأمين: قرارات الهيئة (وساطة التأمين 69/2025 و5/2023 وإصدار الوثائق رقمياً 199/2025 وشكاوى القطاع 77/2025)
  { lawNo: 69, lawYear: 2025, sector: 'وساطة التأمين', signals: INSURANCE_SIGNALS, stripInsurerNames: true },
  { lawNo: 5, lawYear: 2023, sector: 'وسطاء التأمين', signals: INSURANCE_SIGNALS, stripInsurerNames: true },
  { lawNo: 199, lawYear: 2025, sector: 'إصدار وثائق التأمين رقمياً', signals: INSURANCE_SIGNALS, stripInsurerNames: true },
  { lawNo: 77, lawYear: 2025, sector: 'شكاوى قطاع التأمين', signals: INSURANCE_SIGNALS, stripInsurerNames: true },
];

/** هل يحوى نص العقد مؤشراً على نشاط القانون القطاعى؟ */
function hasSignal(law: SectorLaw, normalizedText: string): boolean {
  const text = law.stripInsurerNames ? withoutInsurerNames(normalizedText) : normalizedText;
  return law.signals.some((re) => matchesLoose(re, text));
}

export interface LawScopeContext {
  /** نص العقد كله موحَّداً (norm) — يُحسب مرة واحدة لكل عقد. */
  normalizedText: string;
  family: PlaybookFamily | null;
}

export function lawScopeContext(contractText: string, family: PlaybookFamily | null): LawScopeContext {
  return { normalizedText: norm(contractText), family };
}

/** true = المادة تصلح مرشّحة لهذا العقد. قانون غير قطاعى ⇒ true دائماً. */
export function articleInLawScope(ctx: LawScopeContext, a: { lawNo: number | null; lawYear: number | null }): boolean {
  if (a.lawNo == null || a.lawYear == null) return true;
  const law = SECTOR_LAWS.find((l) => l.lawNo === a.lawNo && l.lawYear === a.lawYear);
  if (!law) return true;
  if (ctx.family && law.allowFamilies?.includes(ctx.family)) return true;
  return hasSignal(law, ctx.normalizedText);
}

/** للاختبارات والتقارير: القوانين القطاعية المسجَّلة. */
export const SECTOR_LAW_KEYS: ReadonlyArray<string> = SECTOR_LAWS.map((l) => `${l.lawNo}/${l.lawYear}`);
