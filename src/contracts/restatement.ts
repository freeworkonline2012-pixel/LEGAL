import { normalizeArabicForMatch } from './reasoning.util';

/**
 * الجولة 105.3: بند يكرر نص مادة قانونية بصياغتها (القوالب الرسمية لعقود التأسيس تنقل نصوص القانون واللائحة نقلاً) لا يجوز أن يبقى «لا يوجد نص
 * يحكمه» لأن النموذج لم تُعرض عليه المادة أو رفضها بحكم تقديرى. القياس هنا حتمى ومحافظ ولا يعتمد على أى نموذج:
 * - نُوحّد الكلمات (تطبيع عربى + حذف «ال» التعريف وحروف الجر الملتصقة) ثم نقيس نسبة ثلاثيات الكلمات المتتالية فى البند التى ترد فى المادة.
 * - لا يُعدّ البند «ناقلاً» للمادة إلا إن كانت نسبته مرتفعة وبه من الكلمات ما يكفى، وكل رقم أو عدد مذكور فى البند وارد فى المادة نفسها
 *   (نسخة غيّرت نسبة أو مدة لا تُعدّ نقلاً حتى لو تطابقت بقية الكلمات).
 */

const MIN_CLAUSE_TOKENS = 12;
const SHINGLE = 3;

const NUMBER_WORDS = new Set([
  'واحد', 'واحده', 'اثنين', 'اثنان', 'اثنتين', 'ثلاثه', 'ثلاث', 'اربعه', 'اربع', 'خمسه', 'خمس', 'سته', 'ست', 'سبعه', 'سبع', 'ثمانيه', 'ثمان', 'تسعه', 'تسع',
  'عشره', 'عشر', 'عشرين', 'ثلاثين', 'اربعين', 'خمسين', 'ستين', 'سبعين', 'ثمانين', 'تسعين', 'مائه', 'مئه', 'الف', 'نصف', 'ثلث', 'ربع', 'خمس', 'ثلثي', 'ثلاثه ارباع',
  'ارباع', 'سنه', 'سنوات', 'شهر', 'شهرا', 'يوم', 'يوما', 'ايام', 'اشهر',
]);

function tokens(text: string): string[] {
  return normalizeArabicForMatch(text)
    .split(' ')
    .map((w) => w.replace(/^(?:[وفبكل])?ال(?=[ء-ي]{2})/, '').replace(/^[وفبل](?=[ء-ي]{3})/, ''))
    .filter((w) => w.length >= 2);
}

function shingles(ts: string[]): string[] {
  const out: string[] = [];
  for (let i = 0; i + SHINGLE <= ts.length; i++) out.push(ts.slice(i, i + SHINGLE).join(' '));
  return out;
}

export interface Restatement {
  /** نسبة ثلاثيات البند المتتالية الواردة فى المادة (0..1) */
  coverage: number;
  /** كل رقم/عدد/مقدار فى البند وارد فى المادة */
  numbersAgree: boolean;
  clauseTokens: number;
}

/** هل (وإلى أى مدى) يكرر البند نص المادة؟ الدالة تقيس فقط؛ العتبات عند المستدعى. */
export function restatementOf(clauseText: string, articleText: string): Restatement {
  const ct = tokens(clauseText);
  const at = tokens(articleText);
  const cs = shingles(ct);
  if (cs.length === 0 || at.length < SHINGLE) return { coverage: 0, numbersAgree: false, clauseTokens: ct.length };
  const aset = new Set(shingles(at));
  const hit = cs.filter((s) => aset.has(s)).length;
  const aTokens = new Set(at);
  const quantities = ct.filter((w) => /[0-9]/.test(w) || NUMBER_WORDS.has(w));
  const numbersAgree = quantities.every((w) => aTokens.has(w));
  return { coverage: hit / cs.length, numbersAgree, clauseTokens: ct.length };
}

/** عتبة إدخال المادة ضمن ما يُعرض على النموذج: تغطية ≥ 0.4 وبند لا يقل عن 12 كلمة (ما دونه لا يُقاس). */
export const RESTATEMENT_SHOW_COVERAGE = 0.4;
/** عتبة «يقابل مادة» فى التشخيص فقط. */
export const RESTATEMENT_DIAG_COVERAGE = 0.3;

export function isRestatementWorthShowing(r: Restatement): boolean {
  return r.clauseTokens >= MIN_CLAUSE_TOKENS && r.coverage >= RESTATEMENT_SHOW_COVERAGE;
}

/** أفضل مادة يقترب البند من نقلها (يرجع null إن لم تبلغ العتبة). */
export function bestRestated<T extends { text: string }>(
  clauseText: string,
  articles: T[],
  accept: (r: Restatement) => boolean = isRestatementWorthShowing,
): { article: T; restatement: Restatement } | null {
  let best: { article: T; restatement: Restatement } | null = null;
  for (const a of articles) {
    const r = restatementOf(clauseText, a.text);
    if (!accept(r)) continue;
    if (!best || r.coverage > best.restatement.coverage) best = { article: a, restatement: r };
  }
  return best;
}

export type PoolGate = 'kept' | 'dropped-family' | 'dropped-company' | 'dropped-law';

export interface PoolEntry {
  id: string;
  text: string;
  shown: boolean;
  gate: PoolGate;
}

export type NoTextClass = 'stock-article-restated' | 'eligible-restated-shown' | 'eligible-restated-not-shown' | 'no-restatement' | 'too-short';

/**
 * تشخيص بند انتهى «لا يوجد نص» (أعداد ومعرّفات مواد ونسب فقط، بلا أى نص عقد): أى مواد المجمّع يقاربها البند نصاً وما حال كل منها (عُرضت على النموذج؟ أم أسقطتها بوابة؟)
 * - stock-article-restated: أقرب مادة نصاً أسقطتها بوابة شكل الشركة (فصل المساهمة) — رفض مشروع بقرار المالك أن مواد المساهمة لا تسرى على الشركة ذات المسئولية المحدودة.
 * - eligible-restated-shown / -not-shown: مادة صالحة للعقد يقاربها البند نصاً؛ عُرضت على النموذج (رفضها بحكمه) أم لم تُعرض (خلل استرجاع).
 */
export function noTextDiagnosis(clauseText: string, pool: PoolEntry[]): { cls: NoTextClass; line: string } {
  const tok = tokens(clauseText).length;
  const scored = pool
    .map((p) => ({ p, r: restatementOf(clauseText, p.text) }))
    .sort((a, b) => b.r.coverage - a.r.coverage);
  const top = scored.slice(0, 3).filter((x) => x.r.coverage >= 0.15);
  const items = top.map((x) => `${x.p.id}:${x.r.coverage.toFixed(2)}:${x.p.shown ? 'shown' : 'hidden'}:${x.p.gate}`).join(',') || '-';
  let cls: NoTextClass;
  if (tok < MIN_CLAUSE_TOKENS) cls = 'too-short';
  else {
    const best = scored[0];
    if (!best || best.r.coverage < RESTATEMENT_DIAG_COVERAGE) cls = 'no-restatement';
    else if (best.p.gate === 'dropped-company') cls = 'stock-article-restated';
    else {
      const eligible = scored.find((x) => x.p.gate === 'kept' && x.r.coverage >= RESTATEMENT_DIAG_COVERAGE);
      cls = !eligible ? 'no-restatement' : eligible.p.shown ? 'eligible-restated-shown' : 'eligible-restated-not-shown';
    }
  }
  return { cls, line: `tokens=${tok} class=${cls} top=${items}` };
}

/**
 * الجولة 105.4: معرّفات مواد فصل المساهمة (التى أسقطتها بوابة شكل الشركة) التى يقاربها البند نصاً، لتُذكر فى التقرير سبباً لـ«لا يوجد نص».
 * حتمى ومحافظ: مادة أسقطتها البوابة فقط، تغطية ثلاثيات ≥ 0.3، بند ≥ 12 كلمة، ولا أكثر من اثنتين (الأقرب أولاً).
 */
export function stockChapterCounterparts(clauseText: string, pool: PoolEntry[], limit = 2): string[] {
  if (tokens(clauseText).length < MIN_CLAUSE_TOKENS) return [];
  return pool
    .filter((p) => p.gate === 'dropped-company')
    .map((p) => ({ id: p.id, cov: restatementOf(clauseText, p.text).coverage }))
    .filter((x) => x.cov >= RESTATEMENT_DIAG_COVERAGE)
    .sort((a, b) => b.cov - a.cov)
    .slice(0, limit)
    .map((x) => x.id);
}
