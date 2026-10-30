import type { KeyTerm } from './key-terms';

/**
 * جدول الدفعات والتحقق الحسابى من مجموعها (الجولة 34). يُبنى حتمياً من «الشروط الرئيسية» المستخرجة فقط: نسب مئوية تخص السداد
 * داخل بند واحد (يدل على ذلك لفظ السداد أو الدفعة أو التوقيع أو التسليم أو القبول فى الاقتباس الحرفى)، مع المبلغ الإجمالى
 * الوارد فى البند نفسه. لا رقم من خارج النص: المبالغ المحسوبة = النسبة × أكبر مبلغ ورد فى البند، ويُصرَّح بذلك فى التقرير.
 *
 * الغاية: كشف نسبة مقروءة خطأً من مسح ضوئى (مثل 40% المقروءة «40 96») أو دفعات لا يبلغ مجموعها 100%. الفحص إنذار لا حكم:
 * فشله يعنى «طابق الأصل» وليس أن العقد خاطئ، ولا يغيّر مستوى المخاطرة.
 */

export interface PaymentInstallment {
  percent: number;
  /** المبلغ المحسوب = النسبة × الإجمالى؛ null إن لم يرد مبلغ فى البند */
  amount: number | null;
  /** القراءة الآلية للنسبة مشكوك فيها */
  suspect: boolean;
  quote: string;
}

export type PaymentVerdict = 'consistent' | 'mismatch' | 'suspect_consistent' | 'suspect_mismatch' | 'unverifiable';

export interface PaymentSchedule {
  clauseIndex: number;
  clauseLabel: string;
  total: number | null;
  currency: string | null;
  installments: PaymentInstallment[];
  /** مجموع النسب المقروءة (تُحتسب المشكوك فيها بقيمتها المرجَّحة) */
  sumPercent: number;
  verdict: PaymentVerdict;
  verdictText: string;
}

const PAYMENT_WORDS = /(?:دفع|سداد|يسدد|تسدد|يُسدد|قسط|أقساط|اقساط|مقدم|توقيع|التعاقد|تسليم|تسلم|استلام|إستلام|قبول|إنجاز|انجاز|اعتماد|إتمام|اتمام)/u;
const MAX_INSTALLMENTS = 8;
const EPS = 0.005;

function parseNumber(v: string): number | null {
  const m = v.match(/^([\d,]+(?:\.\d+)?)/);
  if (!m) return null;
  const n = Number(m[1].replace(/,/g, ''));
  return Number.isFinite(n) ? n : null;
}

function round2(n: number): number {
  return Math.round(n * 100) / 100;
}

export function formatMoney(n: number): string {
  return n.toLocaleString('en-US', { maximumFractionDigits: 2 });
}

export function formatPercent(n: number): string {
  return `${Number.isInteger(n) ? n : round2(n)}%`;
}

function judge(installments: PaymentInstallment[]): { sum: number; verdict: PaymentVerdict; text: string } {
  const sure = installments.filter((i) => !i.suspect);
  const doubtful = installments.filter((i) => i.suspect);
  const sureSum = round2(sure.reduce((s, i) => s + i.percent, 0));
  const sum = round2(installments.reduce((s, i) => s + i.percent, 0));
  if (doubtful.length === 0) {
    if (Math.abs(sum - 100) < EPS) return { sum, verdict: 'consistent', text: `مجموع النسب ${formatPercent(sum)}؛ يتسق مع كون الدفعات تغطى كامل المبلغ.` };
    return {
      sum,
      verdict: 'mismatch',
      text:
        `تنبيه: مجموع النسب ${formatPercent(sum)} وليس 100%. قد تكون دفعة لم تُقرأ، أو نسبة قُرئت خطأً، أو نسبة لا تخص الدفعات؛ ` +
        'طابق الجدول على أصل العقد قبل الاعتماد.',
    };
  }
  if (doubtful.length > 1) {
    return {
      sum,
      verdict: 'unverifiable',
      text: `لا يمكن الجزم بمجموع النسب لأن ${doubtful.length} نسب منها مشكوك فى قراءتها الآلية (المقروء ${formatPercent(sum)})؛ طابقها على أصل العقد.`,
    };
  }
  const remainder = round2(100 - sureSum);
  const d = doubtful[0];
  if (Math.abs(d.percent - remainder) < EPS) {
    return {
      sum,
      verdict: 'suspect_consistent',
      text:
        `النسبة المشكوك فى قراءتها (${formatPercent(d.percent)}) تساوى المتبقى من 100% بعد النسب الأخرى (${formatPercent(sureSum)})، فيرجَّح أن القراءة صحيحة؛ ` +
        'ومع ذلك يلزم مطابقتها على أصل العقد.',
    };
  }
  return {
    sum,
    verdict: 'suspect_mismatch',
    text:
      `تنبيه: النسبة المشكوك فى قراءتها (${formatPercent(d.percent)}) لا تساوى المتبقى من 100% بعد النسب الأخرى (${formatPercent(remainder)})؛ ` +
      'إما أن القراءة الآلية أخطأت أو أن الدفعات لا تستوفى كامل المبلغ. طابق الأصل قبل الاعتماد.',
  };
}

/** جداول الدفعات: واحد لكل بند فيه نسبتا سداد فأكثر. يُرجَع [] إن لم يُرصد شىء (لا جدول فارغ ولا استنتاج). */
export function buildPaymentSchedules(terms: KeyTerm[]): PaymentSchedule[] {
  const byClause = new Map<number, KeyTerm[]>();
  for (const t of terms) {
    const list = byClause.get(t.clauseIndex) ?? [];
    list.push(t);
    byClause.set(t.clauseIndex, list);
  }
  const out: PaymentSchedule[] = [];
  for (const [clauseIndex, list] of byClause) {
    const percents = list.filter((t) => t.kind === 'percent' && PAYMENT_WORDS.test(t.quote));
    const count = percents.reduce((n, t) => n + (t.occurrences ?? 1), 0);
    if (count < 2 || count > MAX_INSTALLMENTS) continue;
    const amounts = list
      .filter((t) => t.kind === 'amount')
      .map((t) => ({ n: parseNumber(t.value), cur: t.value.replace(/^[\d,.]+\s*/, '').trim() }))
      .filter((a): a is { n: number; cur: string } => a.n !== null && a.n > 0);
    const base = amounts.length > 0 ? amounts.reduce((m, a) => (a.n > m.n ? a : m)) : null;
    const installments: PaymentInstallment[] = percents
      .map((t) => ({ t, p: parseNumber(t.value) }))
      .filter((x): x is { t: KeyTerm; p: number } => x.p !== null)
      .flatMap(({ t, p }) =>
        Array.from({ length: t.occurrences ?? 1 }, () => ({ percent: p, amount: base ? round2((base.n * p) / 100) : null, suspect: Boolean(t.suspect), quote: t.quote })),
      );
    if (installments.length < 2) continue;
    const j = judge(installments);
    out.push({
      clauseIndex,
      clauseLabel: percents[0].clauseLabel,
      total: base ? base.n : null,
      currency: base ? base.cur : null,
      installments,
      sumPercent: j.sum,
      verdict: j.verdict,
      verdictText: j.text,
    });
  }
  return out.sort((a, b) => a.clauseIndex - b.clauseIndex);
}
