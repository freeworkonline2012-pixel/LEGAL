/**
 * أدوات الأرقام فى نص القراءة الآلية (الجولة 112): توحيد الأرقام الهندية والفواصل، واستخراج الرموز العددية الكاملة (مبلغ، نسبة، عدد).
 * ملف نقى بلا أى اعتماد على Nest أو أدوات النظام.
 */

const INDIC = /[٠-٩]/g;
const EXT_INDIC = /[۰-۹]/g;

/** أرقام هندية/فارسية → لاتينية، وعلامة النسبة العربية ٪ → %. */
export function toLatin(s: string): string {
  return (s ?? '')
    .replace(INDIC, (d) => String(d.charCodeAt(0) - 0x0660))
    .replace(EXT_INDIC, (d) => String(d.charCodeAt(0) - 0x06f0))
    .replace(/٪/g, '%');
}

/**
 * الرموز العددية الكاملة فى النص: «750,000» ← «750000»، «٦٪» ← «6%». فواصل الآلاف (, ٬ ،) بين رقمين تُحذف.
 * العلامة % تلتصق بالرقم إن جاورته (قبله أو بعده بمسافة واحدة).
 */
export function numericTokens(text: string): string[] {
  const t = toLatin(text).replace(/(?<=\d)[,٬،.](?=\d{3}(?!\d))/g, '');
  const out: string[] = [];
  for (const m of t.matchAll(/(\d+(?:\.\d+)?)(\s?%)?|%\s?(\d+(?:\.\d+)?)/g)) {
    if (m[3] !== undefined) out.push(`${m[3]}%`);
    else out.push(m[2] ? `${m[1]}%` : m[1]);
  }
  return out;
}

// ===================== إعادة قراءة الأرقام (الجولة 112) =====================
// السبب الجذرى (مُعاد إنتاجه ومقيس): نموذج Tesseract العربى يقرأ علامة النسبة «%» كأنها «96» فتصير «10%» «9610» و«2%» «962»، وهو سبب
// «967» بدل «6%» فى عقد حقيقى. القراءة العامة للصفحة لا تُصلَح بتعديل محلى، لكن قصّ منطقة الرقم وحدها بدقة 400 وقراءتها بنموذج eng
// بقائمة أحرف رقمية (0-9 , . %) تقرؤها صحيحة. الأرقام الهندية (٠-٩) لا يقرؤها eng ولا يوثق بها العربى، فتُعدّ «غير مؤكدة» وتُنبَّه.

const INVISIBLE = /[\u200e\u200f\u202a-\u202e\u2066-\u2069\ufeff]/g;
const HAS_WESTERN = /[0-9]/;
const HAS_INDIC = /[\u0660-\u0669\u06f0-\u06f9]/;
/** رمز رقمى صرف: أرقام لاتينية وفواصل ونقطة وعلامة %، بلا حروف (الرمز المختلط «قبل:30» لا يُعاد قراءته لأن القص يشمل حروفه). */
const PURE_NUMERIC = /^[0-9,.%\u066a\u066c]+$/;

export const stripInvisible = (s: string): string => s.replace(INVISIBLE, '');
export const hasDigit = (s: string): boolean => HAS_WESTERN.test(s) || HAS_INDIC.test(s);
export const hasIndicDigit = (s: string): boolean => HAS_INDIC.test(s);
export const isPureNumeric = (s: string): boolean => PURE_NUMERIC.test(stripInvisible(s).trim());

export interface TsvWord {
  text: string;
  left: number;
  top: number;
  width: number;
  height: number;
  conf: number;
}

/** كلمات (المستوى 5) من مخرجات TSV لـTesseract، بنصها كما هو. */
export function parseTsvWords(tsv: string): TsvWord[] {
  const out: TsvWord[] = [];
  for (const line of tsv.split(/\r?\n/)) {
    const p = line.split('\t');
    if (p.length < 12 || p[0] !== '5') continue;
    const text = p.slice(11).join('\t');
    if (!stripInvisible(text).trim()) continue;
    out.push({ text, left: Number(p[6]), top: Number(p[7]), width: Number(p[8]), height: Number(p[9]), conf: Number(p[10]) });
  }
  return out;
}

export interface DigitToken {
  start: number;
  end: number;
  text: string;
  word: TsvWord;
}

/**
 * يقابل الرموز الحاوية لرقم فى نص الصفحة العادى بنظيراتها فى TSV بالترتيب (الصفحة نفسها بالإعداد نفسه ⇒ الترتيب والنص متطابقان).
 * أى اختلاف فى العدد أو النص يعنى أن النص ليس من هذه الصورة فيُرجَع null (فشل مغلق: لا تعديل).
 */
export function alignDigitTokens(pageText: string, words: TsvWord[]): DigitToken[] | null {
  const fromText: Array<{ start: number; end: number; text: string }> = [];
  for (const m of pageText.matchAll(/\S+/g)) {
    const core = stripInvisible(m[0]);
    if (core && hasDigit(core)) fromText.push({ start: m.index as number, end: (m.index as number) + m[0].length, text: core });
  }
  const fromTsv = words.filter((w) => hasDigit(stripInvisible(w.text)));
  if (fromText.length !== fromTsv.length) return null;
  const out: DigitToken[] = [];
  for (let i = 0; i < fromText.length; i++) {
    if (stripInvisible(fromTsv[i].text).trim() !== fromText[i].text) return null;
    out.push({ ...fromText[i], word: fromTsv[i] });
  }
  return out;
}

const NUMERIC_SHAPE = /^[0-9][0-9,.]*%?$|^%[0-9][0-9,.]*$|^%$/;

/** صيغة موحدة: «%10» ← «10%». يُرجع null إن لم تكن القراءة رقماً سليم الشكل. */
export function canonicalRead(raw: string): string | null {
  const r = stripInvisible(raw).replace(/\s+/g, '').replace(/^[.,]+|[.,]+$/g, (m) => (m.includes('%') ? m : ''));
  if (!r || !NUMERIC_SHAPE.test(r)) return null;
  if (r.startsWith('%') && r.length > 1) return `${r.slice(1)}%`;
  return r;
}

export type NumberVerdict =
  | { kind: 'verified' }
  | { kind: 'corrected'; text: string }
  | { kind: 'uncertain' }
  | { kind: 'indic' };

/** أرقام الرمز بلا فواصل الآلاف («5.000» و«5,000» و«5000» سواء). */
const digitsOf = (x: string): string => x.replace(/[^0-9]/g, '');

/**
 * القرار لرمز واحد من قراءاته المخصصة (psm 7 وpsm 8 وpsm 13، بعضها قد يكون null). الأرقام الهندية لا تُصحَّح (indic).
 * القراءة المخصصة تُقرأ فيها منطقة الرقم وحدها بدقة 400 وبقائمة أحرف رقمية، فهى أدق من القراءة العامة للصفحة؛ لكنها قد تتلوث بحافة حرف مجاور،
 * فلا نقبلها إلا بتحقق متدرج:
 *  1) لا بد من قراءتين صالحتين على الأقل متفقتين تماماً على الأرقام (دون النظر لعلامة %)، وإلا «غير مؤكد» ويبقى النص كما هو.
 *  2) العطل المقيس وحده يُقبل بقراءتين: «%» مقروءة «96/98/90…» ملتصقة بأول الرقم («9610» ← «10%»، «96» وحدها ← «%»)، أو سقوط % كلياً وأكدته قراءتان.
 *  3) استكمال رقم بتره القراءة العامة (مثل «0» ← «75,000»، «1000» ← «10000»): لا يُقبل إلا إن كان رقم القراءة العامة بادئة أو لاحقة
 *     لرقم القراءة المخصصة واتفقت ثلاث قراءات. فلا يُقصَّر رقم ولا يُبدَّل برقم مختلف أبداً (قراءة مخصصة متفقة على «0» لا تُسقط «15000»).
 * وكل ما عدا ذلك يبقى كما قرأته القراءة العامة ويُعدّ «غير مؤكد» ليُراجَع بالأصل.
 */
export function decideNumber(original: string, reads: Array<string | null>): NumberVerdict {
  const old = stripInvisible(original).trim();
  if (hasIndicDigit(old)) return { kind: 'indic' };
  const valid = reads.map((r) => (r === null ? null : canonicalRead(r))).filter((r): r is string => r !== null);
  if (valid.length < 2) return { kind: 'uncertain' };
  const da = digitsOf(valid[0]);
  if (valid.some((v) => digitsOf(v) !== da)) return { kind: 'uncertain' };
  const pctCount = valid.filter((v) => v.includes('%')).length;
  const next = pctCount > 0 ? `${da}%` : da;
  const oldC = canonicalRead(old) ?? old;
  const oldDigits = digitsOf(oldC);
  const oldPct = oldC.includes('%');
  if (digitsOf(next) === oldDigits && next.includes('%') === oldPct) return { kind: 'verified' };
  if (!oldPct && pctCount > 0) {
    if (da === '' && /^9\d$/.test(oldDigits)) return { kind: 'corrected', text: '%' };
    if (da !== '' && /^9\d/.test(oldDigits) && oldDigits.length === da.length + 2 && oldDigits.endsWith(da)) return { kind: 'corrected', text: `${da}%` };
    if (da !== '' && da === oldDigits && pctCount >= 2) return { kind: 'corrected', text: `${da}%` };
  }
  if (da !== '' && valid.length >= 3 && oldDigits !== '' && da.length > oldDigits.length && (da.startsWith(oldDigits) || da.endsWith(oldDigits))) return { kind: 'corrected', text: next };
  return { kind: 'uncertain' };
}

export interface NumberFix {
  start: number;
  end: number;
  text: string;
}

/** يطبّق التصحيحات على نص الصفحة (من النهاية للبداية) ويُلصق «%» المنفردة بالرقم الذى يليها: «% 10» ← «10%». */
export function applyNumberFixes(pageText: string, fixes: NumberFix[]): string {
  let out = pageText;
  for (const f of [...fixes].sort((a, b) => b.start - a.start)) out = out.slice(0, f.start) + f.text + out.slice(f.end);
  return out.replace(/(^|\s)%[ \t]+(\d[\d,.]*)(?!\d|%)/g, '$1$2%');
}

export interface NumberPassStats {
  checked: number;
  verified: number;
  corrected: number;
  uncertain: number;
  indic: number;
  pagesSkipped: number;
  /** صفحات رفض أكثر من نصف أرقامها (غير الهندية) التأكيد: صورتها باهتة أو غير واضحة */
  weakPages: number;
}

export const emptyNumberStats = (): NumberPassStats => ({ checked: 0, verified: 0, corrected: 0, uncertain: 0, indic: 0, pagesSkipped: 0, weakPages: 0 });

/** تنبيهات المستخدم من نتيجة خطوة إعادة قراءة الأرقام (فارغة إن لم تُجرَ الخطوة أو لم يظهر ما يُنبَّه إليه). */
export function numberWarnings(n: NumberPassStats | undefined): string[] {
  if (!n) return [];
  const out: string[] = [];
  if (n.corrected > 0) {
    out.push(
      `أُعيدت قراءة ${n.corrected} رقماً أو نسبة من الصفحات الممسوحة بقراءة مخصصة للأرقام (أشهر ما يُصلَح علامة «%» التى تقرؤها القراءة العامة «96»)؛ ما زال لازماً مطابقة المبالغ والنسب بالأصل قبل أى اعتماد.`,
    );
  }
  if (n.indic > 0) {
    out.push(`${n.indic} رقماً مكتوباً بالأرقام الهندية (٠-٩) لا تقرؤه القراءة الآلية بدقة، فقد يكون خطأً أو ناقصاً؛ راجعه بالأصل أو ارفع نسخة Word أو PDF نصى.`);
  }
  if (n.weakPages > 0) {
    out.push(
      `${n.weakPages} صفحة صورتها باهتة أو غير واضحة فلم نتمكن من تأكيد أرقامها، فأرقام هذه الصفحات غير موثوقة؛ أعد المسح بدقة 300 نقطة أو ارفع نسخة نصية.`,
    );
  } else if (n.uncertain > 0) {
    out.push(`${n.uncertain} رقماً لم تتأكد قراءته بالقراءة المخصصة فبقى كما قرأته القراءة العامة؛ راجع المبالغ والنسب بالأصل.`);
  }
  if (n.pagesSkipped > 0) out.push(`تعذّر فحص أرقام ${n.pagesSkipped} صفحة فبقيت أرقامها كما قُرئت؛ راجعها بالأصل.`);
  return out;
}
