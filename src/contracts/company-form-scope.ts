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

/**
 * الجولة 105.1: باب/فصل المادة المخزَّن فى المكتبة (articles.hierarchical_location) هو المرجع القاطع لشكل الشركة التى تخاطبها المادة؛
 * المفردات وحدها مقياس ضعيف (م229 من اللائحة تخاطب «مساهمون أو أصحاب حصص رأس مال» فمرّت من بوابة R105 لأن «حصص» عُدّت مفردة شركاء).
 * - قانون 159/1981: فصل «شركات المساهمة» و«التوصية بالأسهم» ⇒ stock؛ فصل «الشركات ذات المسئولية المحدودة» ⇒ llc؛ غيرهما other.
 * - اللائحة 96/1982 (عناوين الفصول فيها مختصرة بالترتيب): الباب الأول/الثانى × الفصل الأول ⇒ stock؛ × الفصل الثانى ⇒ llc؛ غيرها other.
 * موقع مجهول (فارغ/غير مفهوم) ⇒ null فيعود القرار إلى قاعدة المفردات القديمة (R105).
 */
export type ChapterKind = 'stock' | 'llc' | 'other';

const ORDINALS: Record<string, number> = { الاول: 1, الثاني: 2, الثالث: 3, الرابع: 4, الخامس: 5, السادس: 6, السابع: 7 };

export function chapterKindOf(lawNo: number | null, lawYear: number | null, location: string | null | undefined): ChapterKind | null {
  if (!location || !location.trim()) return null;
  const t = normalizeArabicForMatch(location);
  if (lawNo === 159 && lawYear === 1981) {
    if (/ذات المسئوليه المحدوده/.test(t)) return 'llc';
    if (/شركات المساهمه|التوصيه بالاسهم/.test(t)) return 'stock';
    return /^الباب/.test(t) || /مواد الاصدار/.test(t) ? 'other' : null;
  }
  if (lawNo === 96 && lawYear === 1982) {
    const part = t.match(/^الباب (\S+)/);
    const chapter = t.match(/الفصل (\S+)/);
    if (!part || !chapter) return /^مواد الاصدار/.test(t) ? 'other' : null;
    const p = ORDINALS[part[1]];
    const c = ORDINALS[chapter[1]];
    if (!p || !c) return null;
    if ((p === 1 || p === 2) && c === 1) return 'stock';
    if ((p === 1 || p === 2) && c === 2) return 'llc';
    return 'other';
  }
  return null;
}

const EXPLICIT_LLC = /ذات المسئوليه المحدوده|ذات مسئوليه محدوده/;

/**
 * true = المادة تصلح مرشحة لعقد من هذا الشكل. شكل مجهول ⇒ تصلح.
 * عند عقد LLC: مادة فى فصل LLC تبقى دائماً؛ مادة فى فصل المساهمة/التوصية بالأسهم وتتكلم بمفردات المساهمة (مساهم/أسهم/مجلس إدارة) تُستبعد ما لم تذكر
 * «ذات المسئولية المحدودة» صراحة؛ ما سوى ذلك (أحكام عامة/اندماج/تصفية/موقع مجهول) يُحكم عليه بقاعدة المفردات القديمة.
 */
export function articleFitsCompanyForm(
  form: CompanyForm | null,
  a: { lawNo: number | null; lawYear: number | null; snippet: string },
  kind?: ChapterKind | null,
): boolean {
  if (form !== 'llc') return true;
  const company = (a.lawNo === 159 && a.lawYear === 1981) || (a.lawNo === 96 && a.lawYear === 1982);
  if (!company) return true;
  if (kind === 'llc') return true;
  if (kind === 'stock') {
    const t = normalizeArabicForMatch(a.snippet);
    return !ART_STOCK.test(t) || EXPLICIT_LLC.test(t);
  }
  return !isJointStockOnlyArticle(a);
}

/**
 * خريطة (قانون-سنة-رقم المادة) ⇒ نوع الفصل من صفوف المكتبة. رقم مادة مكرر بين نوعين مختلفين (مواد الإصدار مقابل مواد القانون) أو موقع مجهول ⇒ يُهمل المفتاح
 * فيعود القرار لقاعدة المفردات (لا استبعاد بلا يقين).
 */
export function chapterKindMap(rows: ReadonlyArray<{ lawNo: number; lawYear: number; articleNo: number; location: string | null }>): Map<string, ChapterKind> {
  const seen = new Map<string, Set<ChapterKind | 'unknown'>>();
  for (const r of rows) {
    const key = `${r.lawNo}-${r.lawYear}-${r.articleNo}`;
    const set = seen.get(key) ?? new Set<ChapterKind | 'unknown'>();
    set.add(chapterKindOf(r.lawNo, r.lawYear, r.location) ?? 'unknown');
    seen.set(key, set);
  }
  const out = new Map<string, ChapterKind>();
  for (const [key, set] of seen) {
    if (set.size !== 1) continue;
    const only = [...set][0];
    if (only !== 'unknown') out.set(key, only);
  }
  return out;
}
