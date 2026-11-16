import { normalizeArabicForMatch } from './reasoning.util';

/**
 * الجولة 105: بوابة «شكل الشركة». قانون الشركات 159/1981 ولائحته 96/1982 يضمان أحكام شركات المساهمة وأحكام الشركات ذات المسئولية المحدودة فى نص واحد،
 * ومواد المساهمة تخاطب «المساهم» و«الأسهم» و«مجلس الإدارة». فى الإنتاج (نموذج رسمى لعقد شركة ذات مسئولية محدودة) قامت ملاحظة متوسطة مؤكدة (م39) على المادتين 71 و72
 * وهما تخاطبان المساهم؛ وقرر المحامى المالك أنهما لا تنطبقان على الشركة ذات المسئولية المحدودة.
 *
 * القاعدة حتمية ومحافظة ومبنية على نص المادة نفسه لا على أرقام محفوظة: لا تُعرض على عقد شركة ذات مسئولية محدودة مادةٌ من هذين النصين
 * تتكلم بمفردات المساهمة وحدها (مساهم/أسهم/مجلس إدارة) ولا ترد فيها أى مفردة من مفردات الشركاء (شركاء/حصص/حصة/ذات مسئولية محدودة/مدير).
 * المادة التى تجمع المفردتين، أو لا تحمل أيّاً منهما، تبقى مرشحة (لا استبعاد بلا يقين). ولا يُطبَّق شىء من ذلك إلا إن بدا العقد شركة ذات مسئولية محدودة بقرائن متن العقد.
 */

export type CompanyForm = 'llc';

export interface CompanyFormDiag {
  form: CompanyForm | null;
  llcTerm: number;
  partnerWords: number;
  stockWords: number;
}

const LLC_TERM = /ذات مسئوليه محدوده|ذات مسووليه محدوده|ذات مسؤوليه محدوده/g;
const PARTNER_WORDS = /جماعه الشركاء|الحصص|حصه|حصص|الشركاء|مديري الشركه|مدير الشركه/g;
const STOCK_WORDS = /مساهم|الاسهم|سهم|مجلس الاداره/g;

const count = (t: string, re: RegExp): number => (t.match(re) ?? []).length;

/**
 * شكل الشركة من متن العقد كله. «LLC» إن ورد وصفها («ذات مسئولية محدودة») وغلبت مفردات الشركاء والحصص بوضوح على مفردات المساهمة
 * (غلاف النموذج الرسمى يذكر «شركات المساهمة» مرة أو مرتين فلا يكفى وجودها). غير ذلك null (لا بوابة).
 */
export function companyFormDiag(text: string): CompanyFormDiag {
  const t = normalizeArabicForMatch(text);
  const llcTerm = count(t, LLC_TERM);
  const partnerWords = count(t, PARTNER_WORDS);
  const stockWords = count(t, STOCK_WORDS);
  const isLlc = llcTerm >= 1 && partnerWords >= 10 && partnerWords >= 5 * stockWords;
  return { form: isLlc ? 'llc' : null, llcTerm, partnerWords, stockWords };
}

const ART_STOCK = /مساهم|الاسهم|الاسهم|السهم|مجلس الاداره/;
const ART_PARTNER = /شركاء|الحصص|حصه|حصص|ذات مسئوليه محدوده|ذات المسئوليه المحدوده|المديرين|مدير الشركه/;

/** مادة من قانون الشركات 159/1981 أو لائحته 96/1982 تتكلم بمفردات المساهمة وحدها (راجع شرح الملف) */
export function isJointStockOnlyArticle(a: { lawNo: number | null; lawYear: number | null; snippet: string }): boolean {
  const company = (a.lawNo === 159 && a.lawYear === 1981) || (a.lawNo === 96 && a.lawYear === 1982);
  if (!company) return false;
  const t = normalizeArabicForMatch(a.snippet);
  return ART_STOCK.test(t) && !ART_PARTNER.test(t);
}

/** true = المادة تصلح مرشحة لعقد من هذا الشكل. شكل مجهول ⇒ تصلح. */
export function articleFitsCompanyForm(form: CompanyForm | null, a: { lawNo: number | null; lawYear: number | null; snippet: string }): boolean {
  if (form !== 'llc') return true;
  return !isJointStockOnlyArticle(a);
}
