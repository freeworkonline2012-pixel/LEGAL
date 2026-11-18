import { readNameFrom, type PartyNames } from '../contracts/parties.util';
import type { EntityKind, ShieldSession } from './outbound-shield';

/**
 * كشف استدلالى للأسماء والعناوين والأرقام المرجعية فى نص عقد، لتُحجب قبل النداء الخارجى (بوابة الخصوصية).
 * محافظ عمداً: يبحث فى ديباجة العقد وخاتمته (حيث تُكتب هويات الأطراف والممثلين والتوقيع) لا فى كل البنود، لأن اسم الشخص
 * يتكرر بعد ذلك بصيغته فتُمسك البوابة كل مواضعه بمجرد تسجيله. ما لا يطابق هذه الصيغ يبقى ولا يُعلن حجبه.
 */

export interface DetectedEntity {
  kind: EntityKind;
  surface: string;
}

const HEAD_CHARS = 4500;
const TAIL_CHARS = 3000;

// ألقاب الأشخاص: «السيد/ فلان»، «الأستاذة فلانة»… (تتبعها «/» أو «:» أو فراغ)
const TITLES = 'الأستاذة|الاستاذة|الأستاذ|الاستاذ|السيدة|السيده|السيد|الدكتورة|الدكتور|المهندسة|المهندس|المحاسبة|المحاسب|المستشار|اللواء|العميد|الحاجة|الحاج';
const TITLES_AFTER_LAM = 'أستاذة|استاذة|أستاذ|استاذ|سيدة|سيده|سيد|دكتورة|دكتور|مهندسة|مهندس|محاسبة|محاسب|مستشار|لواء|عميد|حاجة|حاج';
const TITLE_TAIL = '(?:\\s*[/:：]\\s*|\\s+)';
// ألقاب الأشخاص: «السيد/ فلان»، «والسيدة فلانة»، «للسيد فلان»، «بالأستاذ فلان»…
const PERSON_TITLE = new RegExp(
  `(?<![ء-ي])(?:[وف]?[بك]?(?:${TITLES})|[وف]?لل(?:${TITLES_AFTER_LAM}))${TITLE_TAIL}`,
  'gu',
);

// الجهات: «شركة X»، «وشركة X»، «لشركة X»، «مؤسسة X»، «بنك X»… (لا «الشركة» ولا «للشركة» المعرّفتين)
const ORG_PREFIX = /(?<![ء-ي])(?:[وفبك]|[وف]?ل)?(?:شركة|شركه|مؤسسة|مؤسسه|بنك|مجموعة|مجموعه|مكتب)\s+/gu;

// عبارات العناوين: «ومقرها …»، «المقيم فى …»، «الكائن …»، «وعنوانه …»
const ADDRESS_CUE =
  /(?<![ء-ي])(?:و?مقر(?:ها|ه)|و?الكائنة?|و?يقيم|و?المقيمة?|و?مقيمة?|و?عنوان(?:ها|ه)|و?محل\s+إقامت(?:ها|ه)|و?موطن(?:ها|ه)\s+المختار|و?محل(?:ها|ه)\s+المختار)(?:\s+(?:فى|في|ب|بـ))?\s*[:：]?\s*/gu;
const ADDRESS_END =
  /(?=\s*(?:و?يمثل|و?ممثل|بصفت|و?يشار|و?المشار|\(|و?يحمل|و?تحمل|بطاقة|و?سجل|و?رقم\s+قومى|\.|\n|$))/u;

// أرقام مرجعية بعد تسمياتها: «سجل تجارى رقم 12345»، «بطاقة ضريبية 123-456-789»
const REF_NUMBER =
  /(?:سجل(?:ها|ه)?\s+(?:ال)?تجار[ىي]|(?:ال)?بطاقة\s+(?:ال)?ضريب[يى]ة?|(?:ال)?رقم\s+(?:ال)?ضريب[ىي]|(?:ال)?ترخيص|(?:ال)?رقم\s+(?:ال)?قوم[ىي]|بطاقة\s+(?:ال)?رقم\s+(?:ال)?قوم[ىي]|جواز\s+سفر)\s*(?:رقم\s*)?[:：]?\s*[(\[]?\s*([0-9٠-٩][0-9٠-٩\-/ ]{3,})/gu;

// كلمات وصف عامة تلى «شركة» (شركة مصرية/مساهمة…) وليست اسماً: لا تُحجب لأن نوع الشركة مما يحتاجه التحليل القانونى
const GENERIC_ORG_WORDS = new Set(
  ['مصرية', 'مصريه', 'مساهمة', 'مساهمه', 'تضامن', 'توصية', 'ذات', 'محدودة', 'محدوده', 'فردية', 'فرديه', 'أجنبية', 'اجنبية', 'عامة', 'خاصة', 'قابضة', 'تابعة', 'وطنية', 'قطاع', 'منشأة', 'مرخصة', 'مسجلة', 'المذكورة', 'الموقعة', 'المتعاقدة', 'تعمل', 'تأسست', 'قائمة'],
);

function pushUnique(out: DetectedEntity[], kind: EntityKind, surface: string | null | undefined): void {
  const s = (surface ?? '').replace(/\s+/g, ' ').trim();
  if (s.length < 3) return;
  if (kind === 'ORG' && !s.includes(' ') && GENERIC_ORG_WORDS.has(s)) return;
  if (out.some((e) => e.surface === s && e.kind === kind)) return;
  out.push({ kind, surface: s });
}

// كلمة تبدأ لقباً أو جهة (بحرف عطف/جر ملتصق أو دونه): يقف عندها الاسم المقروء فلا يلتهم ما بعده («سامح ناصر والسيدة هالة»)
const NAME_BREAKER =
  /^(?:[وفبك]|[وف]?ل)?(?:ال)?(?:سيد|سيدة|سيده|أستاذ|استاذ|أستاذة|استاذة|دكتور|دكتورة|مهندس|مهندسة|محاسب|محاسبة|مستشار|لواء|عميد|حاج|حاجة|شركة|شركه|مؤسسة|مؤسسه|بنك|مجموعة|مجموعه|مكتب)$/u;

function trimAtBreaker(name: string | null): string | null {
  if (!name) return null;
  const words = name.split(/\s+/);
  const cut = words.findIndex((w, i) => i > 0 && NAME_BREAKER.test(w));
  return (cut > 0 ? words.slice(0, cut) : words).join(' ');
}

// صفات ووظائف تلى اللقب وليست أسماء («المستشار القانونى»، «المحاسب القانونى»): تُستبعد من أسماء الأشخاص
const GENERIC_AFTER_TITLE = new Set(
  ['قانونى', 'قانوني', 'القانونى', 'القانوني', 'المختص', 'المسئول', 'المسؤول', 'الفنى', 'الفني', 'المالى', 'المالي', 'الاقتصادى', 'الاقتصادي', 'العام', 'الخاص', 'المعتمد', 'القضائى', 'القضائي', 'الإدارى', 'الإداري'],
);

/**
 * اسم الشخص بعد اللقب يلزم أن يكون كلمتين فأكثر وأولهما لا تبدأ بـ«ال»: الأسماء الأولى مجردة لا تُسجَّل، لأن كلمة واحدة عامة بعد لقب
 * (تحديداً «المستشار القانونى») كانت تُحجب فى كل نداء وتشوّش على النموذج (قياس الإنتاج: رمز واحد 2210 مرة من 2223 استبدال).
 * وهذه ثغرة معلنة: اسم أول وحده بعد لقب لا يُحجب، لكن اسمه الكامل حين يرد فى مكان آخر من الصدر يُحجب ويُمسك كل صيغه.
 */
function plausiblePersonName(name: string): boolean {
  const words = name.split(' ');
  if (words.length < 2) return false;
  if (words[0].startsWith('ال')) return false;
  if (words.some((w) => GENERIC_AFTER_TITLE.has(w))) return false;
  return true;
}

/** اسم شخص من 3 كلمات فأكثر يُذكر فى البنود غالباً بأول كلمتين؛ تُسجَّل الصيغتان. */
function addPerson(out: DetectedEntity[], raw: string | null): void {
  const name = trimAtBreaker(raw);
  if (!name || !plausiblePersonName(name)) return;
  pushUnique(out, 'PER', name);
  const words = name.split(' ');
  if (words.length >= 3) pushUnique(out, 'PER', words.slice(0, 2).join(' '));
}

function scanRegion(region: string, out: DetectedEntity[]): void {
  PERSON_TITLE.lastIndex = 0;
  for (const m of region.matchAll(PERSON_TITLE)) {
    const start = (m.index ?? 0) + m[0].length;
    addPerson(out, readNameFrom(region.slice(start, start + 120)));
  }
  ORG_PREFIX.lastIndex = 0;
  for (const m of region.matchAll(ORG_PREFIX)) {
    const start = (m.index ?? 0) + m[0].length;
    pushUnique(out, 'ORG', trimAtBreaker(readNameFrom(region.slice(start, start + 120))));
  }
  ADDRESS_CUE.lastIndex = 0;
  for (const m of region.matchAll(ADDRESS_CUE)) {
    const start = (m.index ?? 0) + m[0].length;
    const rest = region.slice(start, start + 200);
    const end = ADDRESS_END.exec(rest);
    // عنوان بلا نهاية واضحة يُقتطع عند 160 حرفاً؛ ما كان أقصر من 6 أحرف ليس عنواناً
    const addr = (end ? rest.slice(0, end.index) : rest.slice(0, 160)).replace(/[\s،,;:؛-]+$/u, '').trim();
    if (addr.length >= 6) pushUnique(out, 'ADDR', addr);
  }
  REF_NUMBER.lastIndex = 0;
  for (const m of region.matchAll(REF_NUMBER)) {
    const num = (m[1] ?? '').replace(/[\s\-/]+$/u, '').trim();
    if (num.replace(/\D/g, '').length >= 5) pushUnique(out, 'REF', num);
  }
}

/**
 * يجمع كيانات العقد الحساسة: أسماء الطرفين المقروءة (إن وجدت) وكل ما يطابق الصيغ أعلاه فى صدر العقد وذيله.
 * `text` هو نص العقد كله كما استُخرج؛ لا يُعدَّل.
 */
export function collectContractEntities(text: string, parties?: PartyNames | null): DetectedEntity[] {
  const out: DetectedEntity[] = [];
  if (parties?.first) pushUnique(out, 'ORG', parties.first);
  if (parties?.second) pushUnique(out, 'ORG', parties.second);
  const clean = (text ?? '').replace(/[‎‏‪-‮⁦-⁩]/g, '');
  if (!clean) return out;
  const head = clean.slice(0, HEAD_CHARS);
  scanRegion(head, out);
  if (clean.length > HEAD_CHARS) scanRegion(clean.slice(Math.max(HEAD_CHARS, clean.length - TAIL_CHARS)), out);
  return out;
}

/** يسجّل كيانات العقد فى جلسة الحماية؛ يعيد عدد ما سُجّل. */
export function registerContractEntities(session: ShieldSession, text: string, parties?: PartyNames | null): number {
  const found = collectContractEntities(text, parties);
  for (const e of found) session.registerEntity(e.kind, e.surface);
  return found.length;
}
