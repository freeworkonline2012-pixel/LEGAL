import { normalizeArabicForMatch } from './reasoning.util';

/**
 * أطراف العقد من ديباجته (الجولة 31). العقود المصرية تعرّف الطرفين فى الصدر بالاسم ثم تحيل إليهما فى البنود إما بـ«الطرف الأول/الثانى»
 * أو بالاسم مباشرة («يجوز لشركة أروب الرجوع على بلاك بيلتس»). بلا هذا الربط يخمّن النموذج أى الطرفين هو العميل فتنقلب اتجاهات
 * المخاطر (وقع فعلاً: حق ممنوح للعميل وُصف بأنه يعرّضه لتعويض بلا سقف). الاستخراج حتمى ومحافظ: ما لم يُقرأ بيقين يبقى null
 * ولا يُخمَّن، وكل اتجاه لا يمكن ربطه بطرف يُعامل «غير معروف» فلا تُبنى عليه درجة خطورة.
 */

export interface PartyNames {
  first: string | null;
  second: string | null;
}

const MAX_PREAMBLE = 4000;
const MAX_NAME_WORDS = 5;
const ENTITY = /(?<!ال)(?<!لل)(?:شركة|شركه|مؤسسة|مؤسسه|بنك|مكتب|مجموعة|مجموعه|الأستاذ|الاستاذ|السيد|السيدة|السيده)\s+/gu;
/** ألقاب الأشخاص: تُحسب اسم طرف فقط إن لم يرد فى المقطع اسم جهة (الشخص بعد اسم الشركة هو الممثل الموقّع لا الطرف). */
const PERSON_TITLE = new Set(['الأستاذ', 'الاستاذ', 'السيد', 'السيدة', 'السيده'].map((w) => normalizeArabicForMatch(w)));
/** كلمات تنهى الاسم (ما بعدها وصف لا اسم). */
const STOP = new Set(
  [
    'ويمثلها', 'ويمثله', 'وتمثلها', 'يمثلها', 'يمثله', 'ممثلة', 'ممثله', 'ممثل', 'ومقرها', 'مقرها', 'ومقره', 'مقره', 'الكائن', 'والكائن', 'الكائنة',
    'رقم', 'ورقم', 'سجل', 'والمسجلة', 'المسجلة', 'المقيدة', 'بطاقة', 'ويقيم', 'المقيم', 'والمقيم', 'بصفته', 'بصفتها', 'ويشار', 'والمشار', 'المشار',
    'ومركزها', 'ومركزه', 'وعنوانها', 'عنوانها', 'وعنوانه', 'عنوانه', 'والتي', 'التي', 'والتى', 'التى', 'الذي', 'الذى', 'والذي', 'والذى',
    'ش.م.م', 'ش.ذ.م.م', 'المحدودة', 'المحدوده', 'المساهمة', 'المساهمه', 'مساهمة', 'مساهمه', 'تأسست', 'تاسست', 'وفقا', 'وفقاً', 'طبقا', 'طبقاً', 'من', 'فى', 'في', 'ب', 'ومقيد',
    'مصرية', 'مصريه', 'منشأة', 'منشاه', 'ومنشأة', 'ومنشاه', 'شركة', 'شركه', 'مسجلة', 'مسجله', 'ذات', 'ثانيا', 'ثانياً', 'ثالثا', 'اولا', 'أولا', 'أولاً', 'تجارى', 'تجاري', 'سجلها', 'ومسجلة', 'ومسجله', 'ويقع', 'يقع', 'تحت',
  ].map((w) => normalizeArabicForMatch(w)),
);
const GENERIC = new Set(['شركه', 'مؤسسه', 'بنك', 'مكتب', 'مجموعه', 'السيد', 'السيده', 'الاستاذ'].map((w) => normalizeArabicForMatch(w)));

/** بعد عبارة الطرف مباشرة نقطتان (وقد يتوسطهما دور بين قوسين): «الطرف الأول:» «طرف أول (العميل):» */
const LABEL_AFTER = /^\s*(?:\([^)]{0,40}\)\s*)?[:：]\s*/u;

/** الاسم بعد «الطرف الأول:» — بلا اشتراط كلمة «شركة»؛ يقف عند القوس أو الفاصلة أو النقطة أو الشرطة المحاطة بمسافات. */
function nameAfterLabel(raw: string): string | null {
  let seg = raw.replace(/^\s*\d+\s*[-.)]\s*/, '').replace(/^(?:ال)?(?:سيد|سيده|سيدة|استاذ|أستاذ)\s*[/:]?\s*/u, '');
  seg = seg.replace(/^(?:شركة|شركه|مؤسسة|مؤسسه|بنك|مكتب|مجموعة|مجموعه)\s+/u, '');
  const cut = seg.search(/[(（,،.:؛;/]|\s[-–—]\s|[–—]/u);
  return cleanName(cut >= 0 ? seg.slice(0, cut) : seg);
}

/** «بصفته/بصفتها» بكل تشويهات المسح الشائعة (حرف زائد أو ناقص أو ة بدل ه). */
const NOISE_CAPACITY = /^[وف]?ب?ص[سص]?ف[تط]?[هةها]*$/u;

// «طرف ثان» بلا ياء تُقرأ أيضاً (المسح يُسقط الياء/الألف المقصورة الأخيرة كثيراً)
const DESIGNATION = /(?:ال)?طرف\s*(?:ال)?\s*(أول|اول|الأول|الاول|ثان[يى]?|الثان[يى]?)(?![ء-ي])/gu;
/** ترقيم الأطراف فى الصدر: «أولاً: شركة …» «ثانياً: شركة …» — احتياط حين تضيع عبارة «(طرف ثان)» من المسح. */
const ORDINAL = /(?:^|\s)(?:(?<first>[أا]ولا)|(?<second>ثانيا))[ًا]?\s*[:：\-–—]/gu;

function cleanName(raw: string): string | null {
  const words = raw
    .replace(/[()（）\[\]«»"“”]/g, ' ')
    .split(/[\s،,;:؛]+/)
    .filter(Boolean);
  const out: string[] = [];
  for (const w of words) {
    const nw = normalizeArabicForMatch(w);
    if (STOP.has(nw)) break;
    if (/[\d٠-٩]/.test(w)) break;
    // رمز بلا حروف (« / » بعد «السيد»، شرطة…): قبل أول كلمة يُتجاوز، وبعدها يُنهى به الاسم ولا يكون جزءاً منه
    if (!/[\p{L}]/u.test(w)) {
      if (out.length === 0) continue;
      break;
    }
    // «بصفته/بصفتها» وما يشوّهه المسح منها («بصسفته»، «بصفتة») تنهى الاسم كذلك
    if (NOISE_CAPACITY.test(nw)) break;
    out.push(w);
    if (out.length >= MAX_NAME_WORDS) break;
  }
  const name = out.join(' ').trim();
  return normalizeArabicForMatch(name).length >= 3 ? name : null;
}

/**
 * اسم الطرف فى المقطع الذى يسبق عبارة «الطرف الأول/الثانى». الاسم يرد أول المقطع (جهة التعاقد)، ويليه عادة وصفها ثم ممثلها
 * الموقّع («ويمثلها السيد / فلان بصفته …»)، فالممثل ليس الطرف. لذلك تُفضَّل أول جهة اعتبارية (شركة/مؤسسة/بنك…)، ولا يُؤخذ لقب شخص
 * («السيد») إلا إذا لم يرد فى المقطع اسم جهة اعتبارية، أى كان الطرف شخصاً طبيعياً. ما لا يصلح اسماً يبقى null ولا يُخمَّن.
 */
function pickEntityName(raw: string): string | null {
  const segment = stripBidi(raw);
  let firstCorporate: string | null = null;
  let firstPerson: string | null = null;
  ENTITY.lastIndex = 0;
  for (const m of segment.matchAll(ENTITY)) {
    const at = m.index ?? 0;
    const start = at + m[0].length;
    const name = cleanName(segment.slice(start, start + 120));
    if (!name) continue;
    const isPerson = PERSON_TITLE.has(normalizeArabicForMatch(m[0].trim()));
    // شخص سبقته عبارة «ويمثلها/ممثلاً بـ» هو الممثل الموقّع لا الطرف
    if (isPerson && REPRESENTATIVE.test(segment.slice(0, at))) continue;
    if (isPerson) firstPerson ??= name;
    else firstCorporate ??= name;
  }
  return firstCorporate ?? nameBeforeDescription(segment) ?? firstPerson;
}

const REPRESENTATIVE = /(?<![ء-ي])(?:و?يمثل(?:ها|ه|هم)?|و?ممثل[ةه]?|و?تمثل(?:ها)?|وكيل(?:ها|ه)?)(?![ء-ي])/u;
/** أول ما يدل على أن ما قبله اسم الجهة وما بعده وصفها (شكلها القانونى أو سجلها أو مقرها أو ممثلها). */
const DESCRIPTION_MARK =
  /(?<![ء-ي])(?:شركة|شركه)\s+(?:مساهمة|مساهمه|مصرية|مصريه|ذات|توصية|تضامن)|(?<![ء-ي])(?:منشأة|منشاه|ومنشأة|ومنشاه|سجل|مقرها|ومقرها|مقره|ومقره|ويمثلها|يمثلها|الكائن)(?![ء-ي])/u;

/**
 * احتياط حين لا تسبق الاسمَ كلمةُ «شركة» (وقع فى مسح حقيقى: عنوان «ثانياً: شركة» تحول إلى رموز لاتينية فصار الاسم أول ما يُقرأ):
 * الاسم هو سلسلة الكلمات العربية الملاصقة قبل أول عبارة وصف (شكل الشركة/السجل/المقر)، مقطوعة عند الشرطة، وبحد أقصى خمس كلمات.
 */
function nameBeforeDescription(segment: string): string | null {
  const mark = DESCRIPTION_MARK.exec(segment);
  if (!mark) return null;
  const tokens = segment.slice(0, mark.index).split(/\s+/).filter(Boolean);
  const run: string[] = [];
  for (let i = tokens.length - 1; i >= 0 && run.length < 8; i--) {
    const t = tokens[i];
    if (/^[\u0621-\u064A]{2,}$/u.test(t) || /^[—–-]+$/.test(t)) run.unshift(t);
    else break;
  }
  const dash = run.findIndex((t) => /^[—–-]+$/.test(t));
  let head = (dash >= 0 ? run.slice(0, dash) : run).join(' ');
  // كلمة «شركة» ملتصقة برقم الترتيب بعد المسح («ثانياشركة أروب…»): الاسم ما بعدها
  const glued = /(?:شركة|شركه)\s+/u.exec(head);
  if (glued) head = head.slice(glued.index + glued[0].length);
  return cleanName(head);
}

function stripBidi(s: string): string {
  return s.replace(/[\u200e\u200f\u202a-\u202e\u2066-\u2069]/g, '');
}

export function extractPartyNames(preamble: string | null | undefined): PartyNames {
  const text = stripBidi(preamble ?? '').replace(/\s+/g, ' ').trim().slice(0, MAX_PREAMBLE);
  const names: PartyNames = { first: null, second: null };
  if (!text) return names;
  // الصيغة الشائعة الأخرى: العبارة أولاً ثم الاسم («الطرف الأول: شركة …» أو «طرف أول (العميل): شركة …»). تُقرأ أولاً لأن الاسم
  // يتبعها لا يسبقها؛ ولو قُرئ بصيغة الاسم-قبل-العبارة لأُخذ اسم الطرف السابق وانقلب الطرفان (اتجاه كل حق والتزام).
  const all = [...text.matchAll(DESIGNATION)];
  all.forEach((m, i) => {
    const side = /ثان/.test(m[1]) ? 'second' : 'first';
    if (names[side]) return;
    const after = text.slice((m.index ?? 0) + m[0].length);
    const label = LABEL_AFTER.exec(after);
    if (!label) return;
    const nextAt = all[i + 1] ? (all[i + 1].index ?? 0) - ((m.index ?? 0) + m[0].length) : after.length;
    const name = nameAfterLabel(after.slice(label[0].length, Math.min(nextAt, label[0].length + 400)));
    if (name) names[side] = name;
  });

  let prevEnd = 0;
  DESIGNATION.lastIndex = 0;
  for (const m of text.matchAll(DESIGNATION)) {
    const idx = m.index ?? 0;
    const side = /ثان/.test(m[1]) ? 'second' : 'first';
    const name = pickEntityName(text.slice(prevEnd, idx));
    prevEnd = idx + m[0].length;
    if (name && !names[side]) names[side] = name;
  }
  // احتياط: ما لم تحدده عبارة «طرف أول/ثان» يُقرأ من ترقيم «أولاً:/ثانياً:» (اسم الجهة الأولى بعد الرقم مباشرة)
  if (!names.first || !names.second) {
    const marks = [...text.matchAll(ORDINAL)].map((m) => ({ side: m.groups?.second ? ('second' as const) : ('first' as const), start: (m.index ?? 0) + m[0].length }));
    marks.forEach((mk, i) => {
      if (names[mk.side]) return;
      let end = marks[i + 1]?.start ?? Math.min(text.length, mk.start + 700);
      // ولا يتعدى عبارة التعريف «(طرف …)» إن وُجدت، فما بعدها ليس اسم هذا الطرف
      DESIGNATION.lastIndex = 0;
      const d = DESIGNATION.exec(text.slice(mk.start, end));
      if (d) end = mk.start + d.index;
      const name = pickEntityName(text.slice(mk.start, end));
      if (name) names[mk.side] = name;
    });
  }
  // اسم واحد لطرفين = التباس: لا نعتمد أيهما
  if (names.first && names.second && sameName(names.first, names.second)) return { first: null, second: null };
  return names;
}

function tokens(s: string): string[] {
  return normalizeArabicForMatch(s)
    .split(' ')
    .map((t) => t.replace(/^(?:[وفبكل])?ال(?=[ء-ي]{2})/, ''))
    .filter((t) => t.length >= 2);
}

function sameName(a: string, b: string): boolean {
  const ta = aliasTokens(a);
  const tb = aliasTokens(b);
  return ta.length > 0 && ta.join(' ') === tb.join(' ');
}

/** الرمز/الرمزان المميزان للاسم (بعد «شركة»)، به يُحال إلى الطرف فى البنود: «شركة بلاك بيلتس لتكنولوجيا …» ⇒ [بلاك، بيلتس]. */
export function aliasTokens(name: string): string[] {
  return tokens(name)
    .filter((t) => !GENERIC.has(t))
    .slice(0, 2);
}

/** أى الطرفين يُذكر فى نص البند بالاسم؟ (تسامح مع تشويه المسح: «روب» لـ«أروب» بلاحقة/بادئة حرف). */
export function partiesNamedIn(clauseText: string, names: PartyNames | null | undefined): Array<'first' | 'second'> {
  if (!names) return [];
  const hay = tokens(clauseText);
  const out: Array<'first' | 'second'> = [];
  for (const side of ['first', 'second'] as const) {
    const n = names[side];
    if (!n) continue;
    const alias = aliasTokens(n)[0];
    if (!alias || alias.length < 3) continue;
    if (hay.some((h) => h === alias || (h.length >= 3 && (h.endsWith(alias) || alias.endsWith(h))))) out.push(side);
  }
  return out;
}

/** هل البند يحيل إلى الطرفين بالاسم أو بـ«الطرف الأول/الثانى» بما يسمح بالحكم على اتجاه الحق/الالتزام فيه؟ */
const GENERIC_PARTY_REF = /(?:ال)?طرف (?:ال)?(?:اول|ثان[يى])/;
export function directionResolvable(clauseText: string, names: PartyNames | null | undefined): boolean {
  if (GENERIC_PARTY_REF.test(normalizeArabicForMatch(clauseText))) return true;
  return partiesNamedIn(clauseText, names).length > 0;
}
