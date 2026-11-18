/**
 * تجميع مسودة «عقد آخر»: هيكل حتمى (ديباجة، إخطارات، قانون واجب وتسوية منازعات، أحكام عامة، توقيع) + بنود موضوع العقد التى
 * اجتازت حارس المخرجات. نقى بلا I/O (النداء الخارجى فى DraftingService). بوابة الجودة نفسها تُطبَّق على المسودة كاملة.
 */

import { clauseHeading } from '../drafting-text';
import { buildContext } from '../engine';
import type { DraftClause, DraftResult } from '../drafting.types';
import { assessDraft } from '../quality';
import { closingLines, commonLawyerNotes, disputesClause, generalClause, noticesClause, preambleLines } from '../templates/common';
import { MIN_CLAUSES, type GuardResult } from './custom-guard';

export function contractTitle(typeName: string): string {
  const t = typeName.trim();
  return /^(?:عقد|اتفاقية|اتفاق|بروتوكول)(?![\u0621-\u064A])/.test(t) ? t : `عقد ${t}`;
}

export function assembleCustomDraft(v: Record<string, string>, role: string, guarded: GuardResult, missingInfo: string[]): DraftResult {
  const title = contractTitle(v.contract_type_name);
  const labels = { first: v.party1_label, second: v.party2_label };
  const preamble = preambleLines(v, labels, `وحيث رغب الطرفان فى إبرام ${title} وفق الأحكام الواردة فى هذا العقد،`);

  const skeleton = [noticesClause(labels), disputesClause(v), generalClause()];
  const keys = [...guarded.clauses.map((_, i) => `m${i}`), ...skeleton.map((c) => c.key)];
  const ctx = buildContext('custom', role, v, keys);

  const clauses: DraftClause[] = [
    ...guarded.clauses.map((c) => ({ title: c.title, paragraphs: c.paragraphs })),
    ...skeleton.map((c) => ({ title: c.title, paragraphs: c.paragraphs(ctx) })),
  ].map((c, i) => ({ number: i + 1, heading: clauseHeading(i + 1), title: c.title, paragraphs: c.paragraphs }));

  const closing = closingLines(v, labels);
  const fullText = [title, ...preamble, ...clauses.flatMap((c) => [`${c.heading}: ${c.title}`, ...c.paragraphs]), ...closing].join('\n');

  const notes = [...commonLawyerNotes(v)];
  notes.push(
    `بنود موضوع العقد (من ${clauseHeading(1)} إلى ${clauseHeading(guarded.clauses.length)}) صاغها نموذج لغوى من وصفك، وفُحصت آلياً (لا أرقام ولا استشهادات غير مصرَّح بها، ولا مخالفة لقواعد آمرة تعرفها المنصة)، لكن هذا ليس مراجعة قانونية. اعرضها على محامٍ متخصص فى هذا النوع من العقود.`,
    'لم يستشهد النظام بأى مادة أو قانون فى بنود النوع. على المحامى إضافة السند القانونى، والتحقق من وجود قانون خاص يحكم هذا النوع من العقود وشكلية لازمة له (توثيق أو تسجيل أو ترخيص).',
  );
  if (guarded.maskedNumbers > 0) notes.push(`استبدل الفحص الآلى ${guarded.maskedNumbers} رقماً أو مدة أو عدداً لم تكتبه أنت بفراغ [____] بدل أن يخترعها النموذج؛ املأها أو احذفها.`);
  if (guarded.droppedParagraphs > 0) notes.push(`حذف الفحص الآلى ${guarded.droppedParagraphs} فقرة صاغها النموذج لمخالفتها قواعد السلامة (استشهاد قانونى غير موثَّق، أو شرط يخالف نصاً آمراً، أو رموز غير صالحة). قد تحتاج إلى بند بديل من محاميك.`);
  for (const m of missingInfo) notes.push(`معلومة يقترح النموذج استكمالها: ${m}`);

  const quality = assessDraft({ contractTypePhrase: title, title, typeId: 'custom', role, clauses, preamble, fullText, allowBlankSlots: true });
  if (guarded.clauses.length < MIN_CLAUSES) {
    quality.findings.push({ severity: 'عالٍ', title: 'بنود موضوع العقد قليلة', detail: `عدد البنود التى اجتازت الفحص ${guarded.clauses.length}؛ أضف وصفاً أدق أو اعرض المسودة على محامٍ.` });
    quality.passed = false;
  }
  return {
    typeId: 'custom',
    typeLabel: v.contract_type_name,
    title,
    role,
    assisted: true,
    blankSlots: (fullText.match(/\[____\]/g) ?? []).length,
    preamble,
    clauses,
    closing,
    lawyerNotes: notes,
    quality,
    fullText,
  };
}
