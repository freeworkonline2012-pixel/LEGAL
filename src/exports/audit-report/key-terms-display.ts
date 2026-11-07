import type { KeyTerm } from '../../contracts/key-terms';

/**
 * عرض الشروط الرئيسية بلا تكرار (الجولة 42). المستخرِج يعطى نافذة اقتباس حول كل قيمة، فإذا تجاورت قيم فى البند نفسه
 * (مبلغ بالأرقام ثم بالحروف، أو مبلغ ثم مدة فى الجملة نفسها) تكرّر النص نفسه فى صفوف متتالية. هنا (للعرض فقط؛ مدخلات جدول الدفعات لا تتغير):
 * 1) قيمة واحدة مكتوبة بالأرقام وبالحروف فى البند نفسه تُعرض مرة واحدة،
 * 2) القيم المتجاورة التى تتداخل نوافذ اقتباسها فى البند نفسه تُجمع فى صف واحد باقتباس واحد متصل (اتحاد النافذتين من الأصل).
 */

export interface KeyTermRow {
  terms: KeyTerm[];
  clauseLabel: string;
  /** اقتباس متصل من البند (اتحاد نوافذ القيم المجمَّعة). */
  quote: string;
}

const MIN_OVERLAP = 30;
const MAX_GROUP_QUOTE = 700;

/** اتحاد نافذتين متصلتين من النص نفسه، أو null إن لم تتداخلا. */
export function unionQuotes(a: string, b: string): string | null {
  if (a.includes(b)) return a;
  if (b.includes(a)) return b;
  const max = Math.min(a.length, b.length);
  for (let n = max; n >= MIN_OVERLAP; n -= 1) {
    if (a.slice(a.length - n) === b.slice(0, n)) return a + b.slice(n);
  }
  for (let n = max; n >= MIN_OVERLAP; n -= 1) {
    if (b.slice(b.length - n) === a.slice(0, n)) return b + a.slice(n);
  }
  return null;
}

/** يحذف نسخة «بالحروف» حين تُقرأ القيمة نفسها بالأرقام فى البند نفسه (تبقى نسخة الأرقام). */
function dropWordsDuplicates(terms: KeyTerm[]): KeyTerm[] {
  const digitKeys = new Set(terms.filter((t) => !t.fromWords).map((t) => `${t.clauseIndex}|${t.kind}|${t.value}`));
  return terms.filter((t) => !(t.fromWords && digitKeys.has(`${t.clauseIndex}|${t.kind}|${t.value}`)));
}

/**
 * التاريخ نفسه فى البند نفسه يُعرض مرة واحدة (الجولة 60): ظهر «05/07/2021» صفين متتاليين فى ذيل نموذج عقد سمسرة ممسوح (سطر «تحريراً فى» ثم سطر الاستلام).
 * التاريخ وحده يُدمج هكذا؛ أما النسبة نفسها فقد ترد فى جملتين مختلفتين بمعنيين (سقف المحفظة وسقف الفردة) فلا تُدمج.
 */
function dropDuplicateDates(terms: KeyTerm[]): KeyTerm[] {
  const seen = new Set<string>();
  return terms.filter((t) => {
    if (t.kind !== 'date') return true;
    const k = `${t.clauseIndex}|${t.value}`;
    if (seen.has(k)) return false;
    seen.add(k);
    return true;
  });
}

export function groupKeyTerms(all: KeyTerm[]): KeyTermRow[] {
  const rows: Array<KeyTermRow & { clauseIndex: number }> = [];
  for (const t of dropDuplicateDates(dropWordsDuplicates(all))) {
    const last = rows[rows.length - 1];
    if (last && last.clauseIndex === t.clauseIndex) {
      const u = unionQuotes(last.quote, t.quote);
      if (u !== null && u.length <= MAX_GROUP_QUOTE) {
        last.terms.push(t);
        last.quote = u;
        continue;
      }
    }
    rows.push({ terms: [t], clauseLabel: t.clauseLabel, clauseIndex: t.clauseIndex, quote: t.quote });
  }
  return rows.map(({ terms, clauseLabel, quote }) => ({ terms, clauseLabel, quote }));
}
