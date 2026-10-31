import { createHash } from 'crypto';
import { STANDARD_DISCLAIMER } from '../document-model';
import { extractKeyTerms, KEY_TERM_KIND_LABEL, type KeyTerm } from '../../contracts/key-terms';
import { buildPaymentSchedules, formatMoney, formatPercent } from '../../contracts/payment-schedule';
import type { AuditReport, Cell, RBlock, Tone } from './model';

/**
 * نسخة العميل المبسطة من تقرير تدقيق العقد. مشتقة حصراً مما حُسب فى نسخة المحامى (بنود مؤكدة، ملاحظات مؤكدة، شروط رئيسية،
 * إجراءات): لا حكم ولا رقم ولا مادة قانونية من خارجها. تحذف ما يهم المحامى وحده (نصوص المواد والاقتباسات الحرفية والملاحق
 * وقسم التوقيعات) وتُبقى ما يلزم صاحب القرار: الخلاصة، النقاط التى تستوجب قراره، المبالغ والمواعيد، ما يُطلب تفاوضياً، حدود التقرير.
 */

export interface ClientRisk {
  where: string;
  title: string | null;
  sev: string;
  tone: Tone;
  /** الجملة الأولى من شرح البند المعتمد (بعد حواجز الجودة) */
  reason: string;
  /** أول تعديل مقترح مسجَّل فى الصياغة المقترحة؛ null إن لم توجد صياغة */
  change: string | null;
}

export interface ClientFinding {
  where: string;
  title: string;
  sev: string;
  tone: Tone;
  suggestion: string | null;
}

export interface ClientAction {
  text: string;
  priority: string;
  tone: Tone;
  timeline: string;
}

export interface ClientContext {
  brand: string;
  contractType: string | null;
  reference: string;
  year: string;
  approved: boolean;
  coverRows: AuditReport['cover']['rows'];
  overall: { text: string; tone: Tone };
  counts: { critical: number; high: number; medium: number };
  risks: ClientRisk[];
  findings: ClientFinding[];
  candidateTotal: number;
  warnings: string[];
  clauses: Array<{ clauseIndex: number; clauseLabel: string; clauseTitle: string | null; clauseText: string }>;
  actions: ClientAction[];
  recommendation: string;
}

const MEANING: Record<string, string> = {
  حرج: 'يلزم تعديله قبل التوقيع',
  عالٍ: 'يُنصح بتعديله قبل التوقيع',
  متوسط: 'يستحق التفاوض',
};

/** صف الغلاف الذى لا يهم العميل غير القانونى (القانون الحاكم المفصَّل وعدد البنود وتغطية التقييم). */
const COVER_DROP = ['القانون الحاكم', 'عدد البنود', 'نطاق التغطية'];

function listTerms(terms: KeyTerm[], kinds: KeyTerm['kind'][]): KeyTerm[] {
  return terms.filter((t) => kinds.includes(t.kind) && !t.suspect).slice(0, 14);
}

export function buildClientAuditReport(ctx: ClientContext): AuditReport {
  const blocks: RBlock[] = [];
  let section = 0;
  const banner = (text: string) => {
    section += 1;
    blocks.push({ t: 'banner', text: `${section}. ${text}` });
  };

  // 1) الخلاصة
  blocks.push({ t: 'pagebreak' });
  banner('الخلاصة');
  blocks.push({
    t: 'strip',
    cells: [
      { text: `${ctx.counts.critical} حرجة`, tone: 'critical' },
      { text: `${ctx.counts.high} عالية`, tone: 'high' },
      { text: `${ctx.counts.medium} متوسطة`, tone: 'medium' },
      { text: ctx.overall.text, tone: 'navy' },
    ],
  });
  blocks.push({ t: 'note', label: 'توصيتنا:', text: ctx.recommendation });
  if (ctx.candidateTotal > 0) {
    blocks.push({
      t: 'p',
      text: `بالإضافة إلى ما سبق، هناك ${ctx.candidateTotal} ملاحظة لم يستطع الفحص المستقل تأكيدها؛ لم نعدّها من المخاطر المؤكدة، لكن يراجعها المحامى قبل التوقيع.`,
    });
  }
  for (const w of ctx.warnings) blocks.push({ t: 'note', label: 'تنبيه عن قراءة الملف:', text: w });

  // 2) النقاط التى تحتاج قرارك
  banner('النقاط التى تحتاج قرارك');
  const rows: Cell[][] = [
    ...ctx.risks.map((r, i): Cell[] => [
      { text: String(i + 1), center: true },
      { text: r.title ? `${r.where}: ${r.title}` : r.where },
      { text: r.reason },
      { text: r.change ? `${MEANING[r.sev] ?? 'تحتاج مراجعة'}. التعديل المقترح: ${r.change}` : MEANING[r.sev] ?? 'تحتاج مراجعة' },
      { text: r.sev, tone: r.tone, center: true },
    ]),
    ...ctx.findings.map((f, i): Cell[] => [
      { text: String(ctx.risks.length + i + 1), center: true },
      { text: f.where },
      { text: f.title },
      { text: f.suggestion ?? MEANING[f.sev] ?? 'تحتاج مراجعة' },
      { text: f.sev, tone: f.tone, center: true },
    ]),
  ];
  if (rows.length === 0) {
    blocks.push({ t: 'p', text: 'لم تُرصد فى هذا العقد نقاط مؤكدة تحتاج تعديلاً وفق النصوص القانونية المفهرسة؛ وتبقى مراجعة المحامى شرطاً قبل التوقيع.' });
  } else {
    blocks.push({ t: 'grid', columns: ['#', 'الموضع', 'ما المشكلة', 'ما المطلوب', 'الدرجة'], widths: [5, 17, 36, 30, 12], rows });
  }

  // 3) المبالغ والمواعيد
  const terms = extractKeyTerms(ctx.clauses);
  const schedules = buildPaymentSchedules(terms);
  const listed = listTerms(terms, ['amount', 'duration', 'date']);
  if (schedules.length > 0 || listed.length > 0) {
    banner('المبالغ والمواعيد المهمة');
    for (const s of schedules) {
      const has = s.total !== null;
      const money = (n: number) => `${formatMoney(n)} ${s.currency ?? ''}`.trim();
      blocks.push({ t: 'h3', text: `جدول الدفعات — ${s.clauseLabel}`, rule: true });
      blocks.push({
        t: 'grid',
        columns: has ? ['الدفعة', 'النسبة', 'القيمة'] : ['الدفعة', 'النسبة'],
        widths: has ? [28, 32, 40] : [40, 60],
        rows: s.installments.map((inst, k): Cell[] => [
          { text: `الدفعة ${k + 1}`, center: true },
          { text: formatPercent(inst.percent), center: true, bold: true },
          ...(has && inst.amount !== null ? [{ text: money(inst.amount), center: true }] : []),
        ]),
      });
      const basis =
        has && s.baseBasis === 'explicit'
          ? `القيم محسوبة على ${money(s.total as number)}${s.perUnit ? ' لكل وحدة (مجموعة)' : ''}، وهو الأساس الذى ينص عليه العقد${s.unitCount !== null && s.largestAmount !== null ? `؛ والإجمالى ${money(s.largestAmount)} = ${s.unitCount} × ${money(s.total as number)}` : ''}.`
          : has
            ? `القيم محسوبة على ${money(s.total as number)} وهو أكبر مبلغ ورد فى البند؛ تأكد أنه أساس الدفعات.`
            : '';
      blocks.push({ t: 'note', label: 'تنبيه:', text: `${s.verdictText}${basis ? ` ${basis}` : ''} هذه حسابات المنصة وليست نصاً من العقد.` });
    }
    if (listed.length > 0) {
      blocks.push({ t: 'h3', text: 'مبالغ ومدد وتواريخ وردت فى العقد', rule: true });
      blocks.push({
        t: 'grid',
        columns: ['النوع', 'القيمة', 'فى'],
        widths: [18, 52, 30],
        rows: listed.map((t): Cell[] => [{ text: KEY_TERM_KIND_LABEL[t.kind], tone: 'info', center: true }, { text: t.fromWords ? `${t.value} (مكتوبة بالحروف)` : t.value, bold: true }, { text: t.clauseLabel, center: true }]),
      });
      blocks.push({ t: 'p', size: 'small', text: 'القيم مستخرجة آلياً من نص الملف؛ طابقها على الأصل الموقَّع قبل الاعتماد عليها.' });
    }
  }

  // 4) ما نبدأ بتفاوضه
  banner('ما نوصى بتفاوضه أولاً');
  if (ctx.actions.length === 0) {
    blocks.push({ t: 'p', text: 'لا توجد إجراءات تعديل مطلوبة وفق النصوص المفهرسة؛ ويُنصح بمراجعة محامٍ مختص قبل التوقيع.' });
  } else {
    blocks.push({
      t: 'grid',
      columns: ['#', 'المطلوب', 'الأولوية', 'متى'],
      widths: [6, 56, 16, 22],
      rows: ctx.actions.slice(0, 12).map((a, i): Cell[] => [
        { text: String(i + 1), center: true },
        { text: a.text },
        { text: a.priority, tone: a.tone, center: true },
        { text: a.timeline, center: true },
      ]),
    });
    if (ctx.actions.length > 12) blocks.push({ t: 'p', size: 'small', text: `اقتصر الجدول على أول 12 إجراءً من ${ctx.actions.length}؛ القائمة الكاملة فى نسخة المحامى.` });
  }

  // 5) حدود التقرير
  banner('ما يجب أن تعرفه عن هذا التقرير');
  blocks.push({
    t: 'bullets',
    items: [
      'هذه نسخة مبسطة لمساعدتك على اتخاذ القرار؛ التحليل الكامل بالمواد القانونية والاقتباسات والصياغات البديلة فى نسخة المحامى.',
      ctx.approved ? 'اعتمد مراجع بشرى هذا التقرير.' : 'هذا التقرير مسودة آلية لم يعتمدها مراجع بشرى بعد.',
      'النقاط المذكورة هنا قائمة على النصوص القانونية المصرية المفهرسة لدى المنصة؛ وخلو بند من الملاحظات لا يعنى صحته.',
      'ما يُقرأ من ملف ممسوح ضوئياً قد يحوى أخطاء قراءة؛ تُطابَق الأرقام والأسماء على الأصل.',
    ],
  });
  blocks.push({ t: 'p', size: 'small', text: STANDARD_DISCLAIMER });

  const cover = {
    title: 'ملخص مخاطر العقد — نسخة العميل',
    subtitle: 'خلاصة مبسطة لاتخاذ القرار قبل التوقيع',
    rows: ctx.coverRows.filter((r) => !COVER_DROP.some((d) => r.label.startsWith(d))),
  };
  const digest = createHash('sha256').update(JSON.stringify({ cover, blocks })).digest('hex').toUpperCase();
  blocks.push({
    t: 'idtable',
    rows: [
      { label: 'رقم تعريف الوثيقة (Document ID)', value: `CRC-${ctx.reference.slice(4)}` },
      { label: 'بصمة التحقق (SHA-256)', value: digest },
    ],
  });
  return {
    headerText: `سري — للمستلمين المعتمدين فقط  |  منصة ${ctx.brand}${ctx.contractType ? ` — ${ctx.contractType}` : ''}`,
    footerText: `ملخص مخاطر العقد (نسخة العميل) — إصدار ${ctx.year}`,
    watermark: ctx.approved ? null : 'مسودة — غير معتمد',
    cover,
    blocks,
  };
}
