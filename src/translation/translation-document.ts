/**
 * نموذج مستند الترجمة المُنزَّل (Word / PDF). مستقل عن LegalDocument عمداً: مستند الترجمة هو العقد نفسه بلغة
 * أخرى لا تقرير منصة، فلا ترويسة تقارير ولا جدول بيانات علوى؛ ويدعم الاتجاه LTR/RTL حسب لغة الهدف.
 */
import { FLAG_MESSAGES_AR, type UnitFlag } from './translation-checks';
import type { ContractLang } from './language-detect';

export type TranslationLayout = 'translation' | 'bilingual';

export interface DocParagraph {
  src: string;
  tgt: string;
  /** عنوان بند/قسم (يُعرض بخط عريض) */
  heading: boolean;
}

export interface DocNote {
  n: number;
  term: string;
  note: string;
}

export interface DocFlagged {
  n: number;
  messages: string[];
  excerpt: string;
}

export interface TranslationDocument {
  layout: TranslationLayout;
  from: ContractLang;
  to: ContractLang;
  brand: string;
  reference: string;
  generatedAt: Date;
  contractType: string | null;
  paragraphs: DocParagraph[];
  notes: DocNote[];
  flagged: DocFlagged[];
  filenameBase: string;
}

const HEADING_RE = /^(Article|Clause|Section|Schedule|Annex|Appendix|البند|المادة|مادة|بند|ملحق|الملحق|الفصل|الباب)\b/i;

export function looksLikeHeading(text: string): boolean {
  const t = text.trim();
  return t.length > 0 && t.length <= 90 && HEADING_RE.test(t) && !/[.؛;]$/.test(t) && t.split(/\s+/).length <= 14;
}

export interface StoredUnitView {
  src: string;
  cont: boolean;
  tgt: string | null;
  flags: UnitFlag[];
  edited?: boolean;
}

/** يلصق قطع الفقرات الطويلة (cont) بفقراتها الأم ويُنتج فقرات المستند. */
export function toParagraphs(units: readonly StoredUnitView[]): DocParagraph[] {
  const out: DocParagraph[] = [];
  for (const u of units) {
    const tgt = (u.tgt ?? '').trim();
    if (u.cont && out.length > 0) {
      const last = out[out.length - 1];
      last.src = `${last.src} ${u.src}`.trim();
      last.tgt = `${last.tgt} ${tgt}`.trim();
      last.heading = false;
    } else {
      out.push({ src: u.src, tgt, heading: looksLikeHeading(u.src) });
    }
  }
  return out;
}

export function buildNotesAndFlags(
  units: readonly StoredUnitView[],
  notes: ReadonlyArray<{ i: number; term: string; note: string }>,
): { notes: DocNote[]; flagged: DocFlagged[] } {
  const docNotes = notes.map((x) => ({ n: x.i + 1, term: x.term, note: x.note }));
  const flagged: DocFlagged[] = [];
  units.forEach((u, i) => {
    if (u.flags.length > 0 && !u.edited) {
      flagged.push({
        n: i + 1,
        messages: u.flags.map((f) => FLAG_MESSAGES_AR[f]),
        excerpt: (u.tgt ?? u.src).slice(0, 160),
      });
    }
  });
  return { notes: docNotes, flagged };
}

export function langLabel(lang: ContractLang, inLang: ContractLang): string {
  if (inLang === 'ar') return lang === 'ar' ? 'العربية' : 'الإنجليزية';
  return lang === 'ar' ? 'Arabic' : 'English';
}

export const DISCLAIMER = {
  ar:
    'هذه ترجمة آلية أُعدّت عبر المنصة بمصطلحات قانونية مُعتمدة داخلياً، وهى مسودة لا تُغنى عن مراجعة مترجم قانونى ' +
    'ومحامٍ مختص قبل التوقيع أو التقديم لأى جهة. الأصل هو المرجع عند أى اختلاف. بنود العقد المنقولة لا تُعد رأياً قانونياً.',
  en:
    'This is a machine translation prepared by the platform using internally maintained legal terminology. It is a draft and ' +
    'does not replace review by a qualified legal translator and a competent lawyer before signing or filing with any authority. ' +
    'The original document prevails in case of any discrepancy. Translating a contract is not legal advice.',
} as const;

export const WATERMARK = { ar: 'مسودة ترجمة — تحتاج مراجعة', en: 'DRAFT TRANSLATION — REVIEW REQUIRED' } as const;
