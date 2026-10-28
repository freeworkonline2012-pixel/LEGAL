import type { PlaybookResult, PlaybookRow, PlaybookStatus } from '../../contracts/playbook';
import type { Stance } from '../../contracts/playbook-data';
import { type Cell, type RBlock, type Tone } from './model';

/**
 * قسم «الدليل التفاوضى» فى تقرير تدقيق العقد (الجولة 7). يُبنى من نتيجة buildPlaybook الحتمية فقط؛ لا نص من نموذج لغوى.
 * الاقتباسات حرفية من البنود، والمواد القانونية من بيانات محقَّقة، والمواقف التفاوضية موسومة بأنها ممارسة تعاقدية لا نص قانونى.
 */

const STATUS_TONE: Record<PlaybookStatus, Tone> = { concern: 'critical', found: 'medium', missing: 'high' };

/** ملاحظات كلها «تسرى على الطرفين» (لا يُعرف من صاحب الحق): تستلزم الانتباه ولا تُوصف بأنها ضد موقف القارئ. */
function isNeutral(row: PlaybookRow): boolean {
  return row.status === 'concern' && row.concerns.length > 0 && row.concerns.every((c) => c.against === 'both');
}

function rowTone(row: PlaybookRow): Tone {
  return isNeutral(row) ? 'high' : STATUS_TONE[row.status];
}

function statusText(row: PlaybookRow, sideKnown: boolean): string {
  if (row.status === 'concern') return sideKnown && !isNeutral(row) ? 'فيه ما يميل ضد موقفك' : 'فيه ما يستلزم الانتباه';
  if (row.status === 'found') return 'مرصود';
  return 'لم يُرصد';
}

function stanceLines(s: Stance): string {
  return `الأفضل: ${s.prefer}\nالبديل: ${s.fallback}\nالخط الأحمر: ${s.redLine}`;
}

function observedText(row: PlaybookRow, sideKnown: boolean): string {
  if (row.status === 'missing') return `لم يُرصد نص فى العقد المرفوع. ${row.ifMissing}`;
  const parts: string[] = [];
  if (row.evidence && !row.concerns.some((c) => c.quote === row.evidence?.quote)) {
    parts.push(`${row.evidence.clauseLabel}: «${row.evidence.quote}»`);
  }
  for (const c of row.concerns) {
    const who = c.against === 'both' ? ' (قد يسرى على الطرفين — تحقق لمن الحق قبل الحكم عليه)' : sideKnown ? '' : ` (يضر بـ${c.againstLabel})`;
    parts.push(`${c.clauseLabel}: «${c.quote}»\n⚠ ${c.note}${who}`);
  }
  return parts.join('\n\n');
}

function stanceText(row: PlaybookRow): string {
  if (row.stance) return stanceLines(row.stance);
  return (row.bothStances ?? []).map((b) => `${b.sideLabel}:\n${stanceLines(b.stance)}`).join('\n\n');
}

/** «محور واحد / محورين / 5 محاور / 12 محوراً» بعد حرف جر. */
function axes(n: number): string {
  if (n === 1) return 'محور واحد';
  if (n === 2) return 'محورين';
  return n <= 10 ? `${n} محاور` : `${n} محوراً`;
}

export function playbookIntro(pb: PlaybookResult): string[] {
  const n = pb.rows.length;
  const side = pb.sideLabel ? ` من منظور «${pb.sideLabel}»` : '';
  const who = pb.sideLabel ? 'موقفك' : 'أحد الطرفين';
  const parts: string[] = [];
  const neutral = pb.rows.filter(isNeutral).length;
  const directional = pb.counts.concern - neutral;
  parts.push(
    directional > 0
      ? `رُصد ما يميل ضد ${who} فى ${axes(directional)} من أصل ${n}.`
      : `لم يُرصد فى أى من المحاور الـ${n} ما يميل ضد ${who} بالأنماط المطبَّقة.`,
  );
  if (neutral > 0) parts.push(`ورُصد فى ${axes(neutral)} ما يستلزم الانتباه دون أن يتحدد انحيازه لطرف (ينطبق على الطرفين).`);
  if (pb.counts.missing > 0) parts.push(`ولم يُرصد نص فى ${axes(pb.counts.missing)}.`);
  if (pb.counts.found > 0) parts.push(`وبقية المحاور المرصودة (${pb.counts.found}) دون ملاحظة.`);
  return [
    `يعرض هذا القسم محاور التفاوض المعتادة فى ${pb.familyLabel}${side}، وما رُصد فى نص العقد تحت كل محور باقتباس حرفى، وموقفاً تفاوضياً من ثلاث درجات: الأفضل (ما تطلبه ابتداءً)، والبديل (ما يمكن القبول به)، والخط الأحمر (ما يُنصح بعدم قبوله).`,
    parts.join(' '),
  ];
}

export function playbookBlocks(pb: PlaybookResult): RBlock[] {
  const sideKnown = pb.side !== null;
  const blocks: RBlock[] = [];
  for (const p of playbookIntro(pb)) blocks.push({ t: 'p', text: p });
  if (!sideKnown) {
    blocks.push({
      t: 'note',
      label: 'صفة العميل غير محددة:',
      text: 'لم تُحدَّد صفتك فى هذا العقد بما يمكّن من اختيار موقف واحد، فيُعرض موقف كل من الطرفين، وتُبيَّن أمام كل ملاحظة جهة الطرف الذى تضره.',
    });
  }
  blocks.push({
    t: 'grid',
    columns: ['المحور', 'الحالة', 'ما رُصد فى العقد', sideKnown ? 'موقفك التفاوضى' : 'المواقف التفاوضية'],
    widths: [14, 12, 36, 38],
    rows: pb.rows.map((r): Cell[] => [
      { text: r.label, bold: true },
      { text: statusText(r, sideKnown), tone: rowTone(r), center: true },
      { text: observedText(r, sideKnown) },
      { text: stanceText(r) },
    ]),
  });

  const withBasis = pb.rows.filter((r) => r.status !== 'found' && r.basis.length > 0);
  if (withBasis.length > 0) {
    blocks.push({ t: 'h3', text: 'السند القانونى للمحاور الملحوظة', rule: true });
    blocks.push({
      t: 'bullets',
      items: withBasis.map((r) => {
        const byLaw = new Map<string, string[]>();
        for (const b of r.basis) {
          const list = byLaw.get(b.lawName) ?? [];
          list.push(b.article !== null ? `المادة ${b.article}: ${b.note}` : b.note);
          byLaw.set(b.lawName, list);
        }
        return `${r.label} — ${[...byLaw.entries()].map(([law, items]) => `${law}: ${items.join('؛ ')}`).join(' | ')}`;
      }),
    });
  }
  blocks.push({
    t: 'note',
    label: 'حدود هذا القسم:',
    text:
      'الرصد آلى بالنص ولا يقيّم كفاية الصياغة ولا ما ورد فى مرفقات لم تُرفع، ولا يغنى عن قراءة المحامى للعقد كاملاً. ' +
      'المواقف التفاوضية ممارسة تعاقدية معتادة وليست نصوصاً قانونية، وتتفاوت بحسب قوة التفاوض وطبيعة الصفقة؛ أما المواد المذكورة فمن النصوص القانونية المفهرسة لدى المنصة. ' +
      'ولا يغيّر هذا القسم مستوى المخاطرة العام ولا حالة أى بند.',
  });
  return blocks;
}
