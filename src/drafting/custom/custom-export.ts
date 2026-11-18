/**
 * تنظيف المسودة التى يحرّرها المستخدم قبل التنزيل. لا يُخزَّن شىء من العقد على الخادم، فمسار التنزيل للنوع الحر يستلم النص كما يراه
 * المستخدم (بعد تعديله) ويعيد ترقيمه وفحصه حتمياً ثم يرسمه. لا نموذج لغوى هنا ولا نداء خارجى.
 */

import { clauseHeading } from '../drafting-text';
import type { DraftClause, DraftResult } from '../drafting.types';
import { assessDraft } from '../quality';

const CONTROL = /[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F‎‏‪-‮⁦-⁩]/g;

export class EditedDraftError extends Error {}

function lines(v: unknown, max: number, maxLen: number, field: string, min = 0): string[] {
  if (!Array.isArray(v)) throw new EditedDraftError(`${field}: قائمة مطلوبة`);
  if (v.length > max) throw new EditedDraftError(`${field}: أكثر من الحد المسموح`);
  const out = v.map((x) => {
    if (typeof x !== 'string') throw new EditedDraftError(`${field}: نص مطلوب`);
    const t = x.replace(CONTROL, '').replace(/[ \t]+/g, ' ').trim();
    if (t.length > maxLen) throw new EditedDraftError(`${field}: فقرة أطول من ${maxLen} حرفاً`);
    return t;
  }).filter((t) => t.length > 0);
  if (out.length < min) throw new EditedDraftError(`${field}: مطلوب`);
  return out;
}

export function sanitizeEditedDraft(body: unknown): DraftResult {
  if (!body || typeof body !== 'object') throw new EditedDraftError('المسودة مطلوبة');
  const d = body as Record<string, unknown>;
  const str = (v: unknown, max: number, field: string): string => {
    if (typeof v !== 'string') throw new EditedDraftError(`${field}: نص مطلوب`);
    const t = v.replace(CONTROL, '').replace(/\s+/g, ' ').trim();
    if (t.length === 0 || t.length > max) throw new EditedDraftError(`${field}: بين 1 و${max} حرفاً`);
    return t;
  };
  const title = str(d.title, 150, 'العنوان');
  const typeLabel = str(d.typeLabel, 60, 'نوع العقد');
  const preamble = lines(d.preamble, 12, 1200, 'الديباجة', 1);
  const closing = lines(d.closing, 8, 600, 'التوقيعات', 1);
  const lawyerNotes = lines(d.lawyerNotes, 40, 800, 'الملاحظات');
  if (!Array.isArray(d.clauses) || d.clauses.length < 1 || d.clauses.length > 40) throw new EditedDraftError('البنود: من 1 إلى 40');
  let total = 0;
  const clauses: DraftClause[] = d.clauses.map((c, i) => {
    if (!c || typeof c !== 'object') throw new EditedDraftError('بند غير صالح');
    const o = c as Record<string, unknown>;
    const paragraphs = lines(o.paragraphs, 20, 3000, 'فقرات البند', 1);
    total += paragraphs.join('').length;
    return { number: i + 1, heading: clauseHeading(i + 1), title: str(o.title, 80, 'عنوان البند'), paragraphs };
  });
  if (total > 60000) throw new EditedDraftError('النص أطول من الحد المسموح');

  const fullText = [title, ...preamble, ...clauses.flatMap((c) => [`${c.heading}: ${c.title}`, ...c.paragraphs]), ...closing].join('\n');
  const quality = assessDraft({ contractTypePhrase: title, title, typeId: 'custom', role: 'first', clauses, preamble, fullText, allowBlankSlots: true });
  return {
    typeId: 'custom',
    typeLabel,
    title,
    role: 'first',
    assisted: true,
    blankSlots: (fullText.match(/\[____\]/g) ?? []).length,
    preamble,
    clauses,
    closing,
    lawyerNotes,
    quality,
    fullText,
  };
}
