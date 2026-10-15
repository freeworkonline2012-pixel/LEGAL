/**
 * مطابقة مصطلحات القاموس القانونى مع نص الدفعة. القاموس فى جدول legal_glossary_terms (يُوسَّع لاحقاً برفع المراجع
 * القانونية العربية والإنجليزية دون تغيير كود)، وتُحقن المصطلحات الموجودة فعلاً فى الدفعة فقط فى تعليمات النموذج.
 */
import type { ContractLang } from './language-detect';

export interface GlossaryTerm {
  ar: string;
  en: string;
  domain: string;
  note: string | null;
}

/** توحيد عربى للمطابقة: تشكيل/تطويل/ألف/ياء/تاء مربوطة/همزات. */
export function normalizeArabic(text: string): string {
  return text
    .replace(/[ً-ٰٟـ]/g, '')
    .replace(/[أإآ]/g, 'ا')
    .replace(/ى/g, 'ي')
    .replace(/ة/g, 'ه')
    .replace(/ؤ/g, 'و')
    .replace(/ئ/g, 'ي');
}

function escapeRe(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

export const MAX_GLOSSARY_TERMS_PER_BATCH = 25;

const regexCache = new Map<string, RegExp>();

/**
 * تعبير مطابقة لمصطلح عربى: يتسامح مع «ال» التعريف وسوابق الحروف الشائعة (و/ف/ب/ك/ل/لل/بال/كال) ومع اندماج «لل»
 * (للشرط الجزائى = ل + الشرط الجزائى)، ولا يقبل بداية فى منتصف كلمة (فلا يطابق «شرط» داخل «مشروط»).
 */
export function arabicTermRegex(term: string): RegExp {
  const cached = regexCache.get(term);
  if (cached) return cached;
  const words = normalizeArabic(term)
    .split(/\s+/)
    .filter(Boolean)
    .map((w) => escapeRe(w.replace(/^ال(?=.{2,})/, '')));
  const re = new RegExp(
    `(?<![\\u0600-\\u06ff])[وف]?(?:لل|ال|بال|كال|[بكل])?${words.join('\\s+(?:ال)?')}`,
  );
  regexCache.set(term, re);
  return re;
}

/** المصطلحات الواردة فى نص الدفعة (باتجاه الترجمة المطلوب)، الأكثر تحديداً أولاً وبحد أقصى. */
export function matchGlossary(sourceText: string, from: ContractLang, terms: readonly GlossaryTerm[]): GlossaryTerm[] {
  const hits: GlossaryTerm[] = [];
  if (from === 'ar') {
    const hay = normalizeArabic(sourceText);
    for (const t of terms) {
      if (arabicTermRegex(t.ar).test(hay)) hits.push(t);
    }
  } else {
    const hay = sourceText;
    for (const t of terms) {
      const re = new RegExp(`(?<![A-Za-z])${escapeRe(t.en)}(?![A-Za-z])`, 'i');
      if (re.test(hay)) hits.push(t);
    }
  }
  hits.sort((a, b) => {
    const noteA = a.note ? 1 : 0;
    const noteB = b.note ? 1 : 0;
    if (noteA !== noteB) return noteB - noteA;
    const lenA = (from === 'ar' ? a.ar : a.en).length;
    const lenB = (from === 'ar' ? b.ar : b.en).length;
    return lenB - lenA;
  });
  // إزالة التكرار بالمفتاح المصدرى
  const seen = new Set<string>();
  const out: GlossaryTerm[] = [];
  for (const t of hits) {
    const key = from === 'ar' ? normalizeArabic(t.ar) : t.en.toLowerCase();
    if (seen.has(key)) continue;
    seen.add(key);
    out.push(t);
    if (out.length >= MAX_GLOSSARY_TERMS_PER_BATCH) break;
  }
  return out;
}
