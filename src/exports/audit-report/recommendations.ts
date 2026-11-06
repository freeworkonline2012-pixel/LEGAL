import type { PlaybookResult, PlaybookRow } from '../../contracts/playbook';
import type { Tone } from './model';

/**
 * إجراءات التنفيذ المشتقة من «ملاحظات العقد ككل» المؤكدة ومن محاور الدليل التفاوضى (الجولة 32).
 * قبلها كانت التوصيات لا تُبنى إلا من البنود المقيَّمة منفردة، فتغيب عنها الفجوات الأهم: غياب جزاء التأخير أو الاستلام
 * أو حماية البيانات، وشرط الرسوم المفتوح، وبقاء ملكية البرامج للمورد. لا نص من نموذج لغوى هنا: كل سطر مأخوذ من
 * عنوان الملاحظة أو الاقتراح المحفوظ أو من موقف الدليل التفاوضى الحتمى.
 */

export type ActionPriority = 'حرجة' | 'عالية' | 'متوسطة' | 'منخفضة';

export interface ExtraAction {
  text: string;
  priority: ActionPriority;
  tone: Tone;
  timeline: string;
  note: string;
}

export const PRIORITY_RANK: Record<ActionPriority, number> = { حرجة: 0, عالية: 1, متوسطة: 2, منخفضة: 3 };

const FROM_SEVERITY: Record<string, ActionPriority> = { حرج: 'حرجة', عالٍ: 'عالية', متوسط: 'متوسطة', منخفض: 'منخفضة' };
const TONE: Record<ActionPriority, Tone> = { حرجة: 'critical', عالية: 'high', متوسطة: 'medium', منخفضة: 'grey' };
export const ACTION_TIMELINE: Record<ActionPriority, string> = {
  حرجة: 'فوري — قبل التوقيع',
  عالية: 'خلال أسبوع',
  متوسطة: 'خلال أسبوعين',
  منخفضة: 'قبل الاعتماد النهائى',
};

/** اقتطاع عند حد طبيعى: نهاية جملة، ثم فاصلة، ثم مسافة (لا وسط كلمة ولا وسط عبارة إن أمكن)، وتُلحَق «…» إن اقتُطع شىء. */
function clip(text: string, max: number): string {
  const t = text.replace(/\s+/g, ' ').trim();
  if (t.length <= max) return t;
  const head = t.slice(0, max);
  const floor = Math.floor(max * 0.5);
  const stop = Math.max(head.lastIndexOf('.'), head.lastIndexOf('؛'), head.lastIndexOf('؟'));
  if (stop >= floor) return head.slice(0, stop + 1).trim();
  const comma = Math.max(head.lastIndexOf('،'), head.lastIndexOf(','));
  if (comma >= floor) return `${head.slice(0, comma).trim()}…`;
  const sp = head.lastIndexOf(' ');
  return `${(sp >= floor ? head.slice(0, sp) : head).trim()}…`;
}

function make(text: string, priority: ActionPriority, note: string): ExtraAction {
  return { text, priority, tone: TONE[priority], timeline: ACTION_TIMELINE[priority], note: note || '—' };
}

/** الحقول اللازمة فقط، بأنواع عامة لأن نموذج التقرير يحمل النوع والدرجة نصاً. */
type ActionFinding = { kind: string; severity: string; title: string; suggestion: string | null };

export function findingAction(f: ActionFinding): ExtraAction {
  const title = f.title.replace(/\s+/g, ' ').trim();
  let text: string;
  switch (f.kind) {
    case 'missing_clause':
      text = `إضافة بند يتناول: ${clip(title.replace(/^لم يُرصد بند يتناول:\s*/, ''), 110)}`;
      break;
    case 'undefined_term':
      text = `تعريف ما ورد غير معرَّف: ${clip(title.replace(/^مصطلح أو إحالة غير معرَّفة:\s*/, ''), 110)}`;
      break;
    case 'open_term':
      text = `تحديد الشرط المفتوح: ${clip(title.replace(/^شرط مفتوح:\s*/, ''), 110)}`;
      break;
    case 'office_rule':
      text = `تعديل وفق قاعدة المكتب: ${clip(title, 110)}`;
      break;
    default:
      text = `معالجة: ${clip(title, 120)}`;
  }
  return make(text, FROM_SEVERITY[f.severity] ?? 'متوسطة', f.suggestion ? clip(f.suggestion, 130) : '—');
}

/** ملاحظة تستند إلى المادة 515 أو 530 مع نص صريح على البطلان */
const NULLITY_NOTE = /(?:المادة\s*(?:515|530)|\(المادة\s*(?:515|530)\))/;
const NULLITY_WORD = /(?:يبطل|تبطل|باطل|بطلان)/;
export const isNullityConcern = (x: { note: string }): boolean => NULLITY_NOTE.test(x.note) && NULLITY_WORD.test(x.note);

/** محور فيه ما يميل ضد العميل (أو يستلزم الانتباه) ⇒ إجراء تفاوضى؛ المحاور المرصودة بلا ملاحظة أو غير المرصودة لا تُكرَّر هنا (الأخيرة تغطيها ملاحظات «بند غير مرصود»). */
export function playbookAction(row: PlaybookRow, sideKnown: boolean): ExtraAction | null {
  if (row.status !== 'concern' || row.concerns.length === 0) return null;
  const directional = row.concerns.some((c) => c.against !== 'both');
  // ما يقوم على بطلان صريح بنص آمر (515 و530) لا يُترك للتقدير ولا يتوقف على معرفة الطرف: عالية دائماً (الجولة 58)
  const nullity = row.concerns.some(isNullityConcern);
  const priority: ActionPriority = nullity || (sideKnown && directional) ? 'عالية' : 'متوسطة';
  const c = nullity ? (row.concerns.find(isNullityConcern) ?? row.concerns[0]) : row.concerns[0];
  const text = `التفاوض على محور «${row.label}» (${c.clauseLabel}): ${clip(c.note, 150)}`;
  const note = row.stance ? `الأفضل: ${clip(row.stance.prefer, 120)}` : 'يُحدَّد الموقف بحسب صفتك فى العقد';
  return make(text, priority, note);
}

/**
 * مرشّحة للمراجعة البشرية: لم يؤكدها المدقق المستقل المعاكس (اعترض أو لم يجزم). الإجراء هنا «تحقق» لا «تعديل»، وأولويته أدنى
 * من المؤكدة (متوسطة إن كانت الدرجة المرشّحة حرجة أو عالية كى لا تضيع، وإلا منخفضة). لا تدخل فى مستوى المخاطرة العام.
 */
export function candidateAction(subject: string, candidateSeverity: string, reason: string): ExtraAction {
  const priority: ActionPriority = candidateSeverity === 'حرج' || candidateSeverity === 'عالٍ' ? 'متوسطة' : 'منخفضة';
  return make(`التحقق البشرى من مرشّحة غير مؤكدة: ${clip(subject, 110)}`, priority, `لم يؤكدها المدقق المستقل: ${clip(reason, 110)}`);
}

export function extraActions(confirmedFindings: ActionFinding[], playbook: PlaybookResult | null): ExtraAction[] {
  const out: ExtraAction[] = confirmedFindings.map(findingAction);
  if (playbook) {
    for (const row of playbook.rows) {
      const a = playbookAction(row, playbook.side !== null);
      if (a) out.push(a);
    }
  }
  return out;
}
