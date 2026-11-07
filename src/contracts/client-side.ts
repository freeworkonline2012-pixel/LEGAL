import { aliasTokens, type PartyNames } from './parties.util';
import { normalizeArabicForMatch } from './reasoning.util';

/**
 * جهة العميل فى عقود الخدمات والوكالة (الجولة 63، بحسب إجابات المستشار): طالب الخدمة/الموكل (الذى يدفع ويملك الأموال المحصلة)
 * أم مقدّم الخدمة/الوكيل/المورّد. قواعد المكتب المصاغة لحماية طالب الخدمة لا تُعرض كمخاطرة على عميل هو مقدّم الخدمة:
 * مثالها من الإنتاج عقد التحصيل 0174 رُفع بعميلين متقابلين فخرجت الملاحظات نفسها حرفياً وهى فى الحالة الثانية فى صالح العميل.
 * الصفة نص حر يدخله المستخدم، فيُصنَّف بالكلمات الدالة؛ ما كان ملتبساً أو مجهولاً ⇒ null (لا يُحجب شىء، فشل مغلق).
 */
export type ClientSide = 'requester' | 'provider';

const REQUESTER_ROLE = /(?<![ء-ي])(?:[وبلف]?ال)?(?:طالب|عميل|موكل|صاحب (?:ال)?عمل|رب (?:ال)?عمل|مستفيد|منتفع)(?![ء-ي])/u;
const PROVIDER_ROLE = /(?<![ء-ي])(?:[وبلف]?ال)?(?:مقدم|مزود|مورد|مقاول|وكيل|وسيط|سمسار|مسوق|متعهد|مؤدي)(?![ء-ي])/u;

export function clientSideOf(clientRole: string | null | undefined): ClientSide | null {
  if (!clientRole) return null;
  const role = normalizeArabicForMatch(clientRole);
  const req = REQUESTER_ROLE.test(role);
  const prov = PROVIDER_ROLE.test(role);
  if (req === prov) return null;
  return req ? 'requester' : 'provider';
}

// ===================== اتجاه العميل من متن العقد =====================

/** تطبيع خفيف يُبقي علامات الترقيم (النقطتان بعد الصفة): توحيد الألف والياء والتاء المربوطة وحذف التشكيل فقط. */
const lightNorm = (t: string): string =>
  (t ?? '')
    .replace(/[‎‏‪-‮⁦-⁩]/g, '')
    .replace(/[ً-ٰٟـ]/g, '')
    .replace(/[آأإ]/g, 'ا')
    .replace(/ى/g, 'ي')
    .replace(/ة/g, 'ه');

const SIDE_LABELS: Array<{ side: ClientSide; term: string; shown: string }> = [
  { side: 'requester', term: '(?:ال)?عميل', shown: 'العميل' },
  { side: 'requester', term: '(?:ال)?موكل', shown: 'الموكل' },
  { side: 'requester', term: '(?:ال)?طالب (?:ال)?خدمه', shown: 'طالب الخدمة' },
  { side: 'requester', term: '(?:ال)?(?:صاحب|رب) (?:ال)?عمل', shown: 'صاحب العمل' },
  { side: 'provider', term: '(?:ال)?مقدم (?:ال)?خدمه', shown: 'مقدم الخدمة' },
  { side: 'provider', term: '(?:ال)?مقاول', shown: 'المقاول' },
  { side: 'provider', term: '(?:ال)?وكيل', shown: 'الوكيل' },
  { side: 'provider', term: '(?:ال)?وسيط', shown: 'الوسيط' },
  { side: 'provider', term: '(?:ال)?مورد', shown: 'المورد' },
];

/** «العميل: شركة أروب لتأمين …» أو «المقاول - شركة …»: الصفة ثم نقطتان أو شرطة ثم اسم جهة. لا تُقبل صفة بلا اسم جهة بعدها. */
function labelledNames(text: string): Array<{ side: ClientSide; shown: string; name: string }> {
  const out: Array<{ side: ClientSide; shown: string; name: string }> = [];
  const t = lightNorm(text);
  for (const l of SIDE_LABELS) {
    const re = new RegExp(
      `(?<![ء-ي])${l.term}\\s*(?:\\([^)]{0,30}\\)\\s*)?[:：\\-–]\\s*(?:شركه|مؤسسه|بنك|مكتب|مجموعه)\\s+((?:[ء-ي]+\\s+){0,2}[ء-ي]+)`,
      'gu',
    );
    for (const m of t.matchAll(re)) out.push({ side: l.side, shown: l.shown, name: m[1] });
  }
  return out;
}

function sideOfName(name: string, parties: PartyNames): 'first' | 'second' | null {
  const key = aliasTokens(name)[0];
  if (!key) return null;
  const hits: Array<'first' | 'second'> = [];
  for (const s of ['first', 'second'] as const) {
    const p = parties[s];
    if (p && aliasTokens(p)[0] === key) hits.push(s);
  }
  return hits.length === 1 ? hits[0] : null;
}

export interface BodyDirection {
  /** الطرف الذى يعرّفه متن العقد بأنه طالب الخدمة/الموكل */
  requesterParty: 'first' | 'second';
  label: string;
  name: string;
}

/**
 * طرف طالب الخدمة كما يعرّفه متن العقد (بند «العميل: شركة …» ونحوه)، للعقود التى لم تُقرأ ديباجتها (الممسوحة). يُعتمد فقط إن
 * اتفقت كل التعريفات الموجودة على جانب واحد وربط الاسم بطرف واحد بيقين؛ التعارض أو الالتباس ⇒ null.
 */
export function requesterPartyFromBody(clauseTexts: string[], parties: PartyNames): BodyDirection | null {
  if (!parties.first && !parties.second) return null;
  const votes = new Set<'first' | 'second'>();
  let first: BodyDirection | null = null;
  for (const text of clauseTexts) {
    for (const hit of labelledNames(text)) {
      const side = sideOfName(hit.name, parties);
      if (!side) continue;
      const requester = hit.side === 'requester' ? side : side === 'first' ? 'second' : 'first';
      votes.add(requester);
      if (!first) first = { requesterParty: requester, label: hit.shown, name: hit.name };
    }
  }
  return votes.size === 1 ? first : null;
}

/**
 * تنبيه اتجاه من المتن (الجولة 63): اختار المستخدم صفة «طالب الخدمة» لطرف يعرّف متن العقد الطرف الآخر بأنه طالب الخدمة (أو العكس).
 * يُنبَّه ولا يُمنع: قد يكون الاختيار مقصوداً. null إن لم تُحدَّد صفة أو طرف، أو لم يُحسم الاتجاه من المتن، أو اتفق الاختياران.
 */
export function bodyDirectionWarning(
  clientRole: string | null | undefined,
  clientParty: 'first' | 'second' | null | undefined,
  clauseTexts: string[],
  parties: PartyNames,
): string | null {
  const side = clientSideOf(clientRole);
  if (!side || !clientParty) return null;
  const body = requesterPartyFromBody(clauseTexts, parties);
  if (!body) return null;
  const expected = side === 'requester' ? body.requesterParty : body.requesterParty === 'first' ? 'second' : 'first';
  if (expected === clientParty) return null;
  const label = (s: 'first' | 'second') => (s === 'first' ? 'الطرف الأول' : 'الطرف الثانى');
  return (
    `تنبيه اتجاه: حدّدت صفتك «${clientRole}» وطرفك «${label(clientParty)}»، لكن متن العقد يعرّف «${label(body.requesterParty)}» (${body.name}) بأنه «${body.label}». ` +
    `يُقاس كل حق والتزام ومخاطرة من جهة الطرف الذى اخترته؛ إن لم يكن اختيارك مقصوداً فأعد رفع العقد بطرفك الصحيح.`
  );
}
