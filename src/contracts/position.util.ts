/**
 * مركز العميل فى العقد (نوع العقد + صفته): مدخل المستخدم من الاستيضاح قبل الرفع.
 * نص حر قصير يدخل فى تعليمات النموذج، فيُنقّى هنا: سطر واحد، حد أقصى للطول، بلا أحرف
 * تحكم، ويُرفض ما فيه أرقام طويلة (أرقام قومية/هواتف: الاستيضاح لا يطلب بيانات شخصية).
 */
export const MAX_POSITION_CHARS = 80;
export const MIN_POSITION_CHARS = 2;

/** أى الطرفين فى نص العقد هو العميل (الذى يُدقَّق العقد لمصلحته): بلا ذلك يخمّن النموذج فيحمى الطرف الخطأ. */
export type ClientParty = 'first' | 'second';
export const CLIENT_PARTY_LABEL: Record<ClientParty, string> = { first: 'الطرف الأول', second: 'الطرف الثانى' };

export interface ClientPosition {
  contractType: string | null;
  clientRole: string | null;
  clientParty?: ClientParty | null;
  /** اسما الطرفين كما وردا فى ديباجة العقد (يُستخرجان حتمياً؛ null إن لم يُقرآ بيقين) */
  partyNames?: { first: string | null; second: string | null } | null;
}

function cleanPart(value: unknown): string | null {
  if (typeof value !== 'string') return null;
  const s = value
    .replace(/[\u0000-\u001f\u007f]+/g, ' ')
    .replace(/[<>{}\[\]"`\\]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
  if (s.length < MIN_POSITION_CHARS) return null;
  if (/[\d٠-٩]{6,}/.test(s)) return null;
  return s.length > MAX_POSITION_CHARS ? s.slice(0, MAX_POSITION_CHARS).trim() : s;
}

export function sanitizeClientPosition(raw: unknown): ClientPosition {
  const r = raw && typeof raw === 'object' ? (raw as Record<string, unknown>) : {};
  const party = r.client_party === 'first' || r.client_party === 'second' ? r.client_party : null;
  const clientRole = cleanPart(r.client_role);
  // الطرف بلا صفة لا معنى له (لا مركز أصلاً)
  return { contractType: cleanPart(r.contract_type), clientRole, clientParty: clientRole ? party : null };
}

/** الوصف الذى يُمرَّر للنموذج: "المستأجر فى عقد إيجار" أو null إن لم يُحدَّد المركز */
export function describePosition(position: ClientPosition | null | undefined): string | null {
  if (!position?.clientRole) return null;
  const base = position.contractType ? `${position.clientRole} (فى ${position.contractType})` : position.clientRole;
  if (!position.clientParty) return base;
  const otherKey = position.clientParty === 'first' ? 'second' : 'first';
  const mine = CLIENT_PARTY_LABEL[position.clientParty];
  const other = CLIENT_PARTY_LABEL[otherKey];
  const myName = position.partyNames?.[position.clientParty];
  const otherName = position.partyNames?.[otherKey];
  const mineFull = myName ? `${mine} (${myName})` : mine;
  const otherFull = otherName ? `${other} (${otherName})` : other;
  const named = myName || otherName ? ' والأسماء الواردة فى البنود تُربط بهذا التعريف لا بالترتيب فى الجملة.' : '';
  return `${base} — وهو «${mineFull}» فى نص العقد، والطرف الآخر هو «${otherFull}»؛ فكل حق أو التزام ورد فى البند لـ«${mine}» فهو للعميل، وما ورد لـ«${other}» فهو للطرف المقابل.${named} إن لم تستطع تحديد لمن الحق أو الالتزام بيقين فصرّح بذلك ولا ترفع درجة الخطورة على هذا الأساس`;
}
