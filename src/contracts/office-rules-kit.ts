import { sentencesOf, type ContractFamily, type FindingSeverity, type LevelClause } from './contract-level';
import { normalizeArabicForMatch } from './reasoning.util';

/** أنواع وأدوات مشتركة لقواعد المكتب (مفصولة كى تُبنى عليها ملفات قواعد أخرى بلا استيراد دائرى). */

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
  /**
   * قاعدة غياب: المخالفة عدم وجود نص (لا جملة تُقتبس). يُرجع evaluate مواضع «سياق» اختيارية (جملة ذات صلة تُقتبس إن وُجدت)،
   * وتُصدَر الملاحظة ولو بلا اقتباس. وعلى عقد ممسوح ذى تحذيرات تُوسم «غير مؤكدة» كسائر ادعاءات الغياب.
   */
  absence?: boolean;
  /** المواضع المخالفة؛ فارغ = لا تنطبق أو مستوفاة */
  evaluate: (clauses: LevelClause[], ctx: OfficeRuleContext) => OfficeRuleHit[];
}


// ===================== أدوات =====================

export const norm = (t: string): string => normalizeArabicForMatch(t);

export function* eachSentence(clauses: LevelClause[]): Generator<{ clause: LevelClause; sentence: string; n: string }> {
  for (const clause of clauses) {
    for (const sentence of sentencesOf(clause.clauseText)) yield { clause, sentence, n: norm(sentence) };
  }
}

/** أول جملة مطابقة فى كل بند (بند واحد = موضع واحد). */
export function firstPerClause(clauses: LevelClause[], test: (n: string, clauseNorm: string) => boolean): OfficeRuleHit[] {
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


/** النص بأرقام لاتينية (المُوحِّد العام يحذف الأرقام)، لفحوص تعتمد على الأرقام. */
export function toLatinDigits(t: string): string {
  return (t ?? '').replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660)).replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06f0));
}

/** النص الموحَّد مع إبقاء الأرقام اللاتينية. */
export const normD = (t: string): string => norm(toLatinDigits(t));

/** النص الكامل الموحَّد للعقد (عناوين البنود ونصوصها). */
export function fullNorm(clauses: LevelClause[]): string {
  return clauses.map((c) => norm(`${c.clauseTitle ?? ''} ${c.clauseText}`)).join(' ');
}

/** أول جملة فى العقد تطابق النمط (على الموحَّد)، موضعاً للاقتباس؛ null إن لم توجد. */
export function firstSentenceMatching(clauses: LevelClause[], re: RegExp): OfficeRuleHit | null {
  for (const { clause, sentence, n } of eachSentence(clauses)) if (re.test(n)) return { clause, sentence };
  return null;
}
