/**
 * إخفاء البيانات الشخصية الحتمى (قانون 151/2020 — تقليل البيانات) قبل أن يغادر نص المستند خادمنا إلى
 * أى نموذج خارجى. دالة نقية بلا أى استدعاء خارجى.
 *
 * ما يُخفى: الرقم القومى (14 رقماً بتركيب صالح)، الهواتف المصرية (محمول وأرضى ودولى)، البريد، IBAN،
 * أرقام البطاقات (بفحص Luhn)، جوازات السفر، وأى رقم طويل (10 أرقام فأكثر) كأرقام الحسابات والسجلات.
 * ما لا يُخفى: الأسماء والعناوين — لا يمكن كشفها حتمياً بلا نموذج لغوى، والمبالغ والتواريخ والمدد
 * تبقى لأن الوقائع القانونية تقوم عليها. هذا الحد معلَن للعميل فى شاشة الموافقة ولا يُخفى عنه.
 *
 * الكشف يجرى على نسخة بأرقام لاتينية بالطول نفسه (الأرقام الهندية والفارسية تُطابَق أيضاً) فتبقى
 * مواضع الاستبدال دقيقة فى النص الأصلى.
 */

export type RedactionKind =
  | 'national_id'
  | 'phone'
  | 'email'
  | 'iban'
  | 'card'
  | 'passport'
  | 'long_number';

export interface RedactionResult {
  text: string;
  counts: Record<RedactionKind, number>;
  total: number;
}

const PLACEHOLDERS: Record<RedactionKind, string> = {
  national_id: '[رقم قومى محجوب]',
  phone: '[هاتف محجوب]',
  email: '[بريد محجوب]',
  iban: '[حساب بنكى محجوب]',
  card: '[بطاقة محجوبة]',
  passport: '[جواز محجوب]',
  long_number: '[رقم محجوب]',
};

/** يطابق الأرقام الهندية والفارسية بنظيرتها اللاتينية بالطول نفسه (حرف بحرف). */
function toAsciiDigitsSameLength(input: string): string {
  let out = '';
  for (const ch of input) {
    const c = ch.codePointAt(0)!;
    if (c >= 0x0660 && c <= 0x0669) out += String.fromCharCode(48 + c - 0x0660);
    else if (c >= 0x06f0 && c <= 0x06f9) out += String.fromCharCode(48 + c - 0x06f0);
    else if (/[\u200e\u200f\u202a-\u202e\u2066-\u2069]/.test(ch)) out += ' ';
    else out += ch;
  }
  return out;
}

function luhnValid(digits: string): boolean {
  let sum = 0;
  let alt = false;
  for (let i = digits.length - 1; i >= 0; i--) {
    let n = digits.charCodeAt(i) - 48;
    if (alt) {
      n *= 2;
      if (n > 9) n -= 9;
    }
    sum += n;
    alt = !alt;
  }
  return sum % 10 === 0;
}

function plausibleNationalId(id: string): boolean {
  if (!/^[23]\d{13}$/.test(id)) return false;
  const month = Number(id.slice(3, 5));
  const day = Number(id.slice(5, 7));
  return month >= 1 && month <= 12 && day >= 1 && day <= 31;
}

interface Span {
  start: number;
  end: number;
  kind: RedactionKind;
}

const RULES: Array<{ kind: RedactionKind; re: RegExp; accept?: (match: string) => boolean }> = [
  { kind: 'email', re: /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/g },
  { kind: 'iban', re: /(?<![A-Za-z0-9])EG\d{2}(?:[ -]?\d){21,27}(?!\d)/gi },
  // القراءة الآلية للصور تُدخل فراغات وعلامات اتجاه داخل الرقم: نتسامح حتى فراغين بين الخانات (الصلاحية صارمة).
  {
    kind: 'national_id',
    re: /(?<!\d)[23](?:[ -]{0,2}\d){13}(?!\d)/g,
    accept: (m) => plausibleNationalId(m.replace(/\D/g, '')),
  },
  {
    kind: 'card',
    re: /(?<!\d)\d(?:[ -]?\d){12,18}(?!\d)/g,
    accept: (m) => {
      const d = m.replace(/\D/g, '');
      return d.length >= 13 && d.length <= 19 && luhnValid(d);
    },
  },
  { kind: 'phone', re: /(?<!\d)(?:(?:\+|00)20[ -]?0?|0)1[0125](?:[ -]?\d){8}(?!\d)/g },
  { kind: 'phone', re: /(?<!\d)(?:(?:\+|00)20[ -]?|0)(?:2|3)[ -]?\d{8}(?!\d)/g },
  { kind: 'phone', re: /(?<!\d)(?:(?:\+|00)20[ -]?|0)(?:4\d|5\d|6\d|8\d|9\d)[ -]?\d{7}(?!\d)/g },
  { kind: 'passport', re: /(?<![A-Za-z0-9])[A-Z]\d{8}(?!\d)/g },
  { kind: 'long_number', re: /(?<!\d)\d{10,}(?!\d)/g },
];

export function redactPersonalData(input: string): RedactionResult {
  const ascii = toAsciiDigitsSameLength(input);
  const spans: Span[] = [];

  for (const rule of RULES) {
    rule.re.lastIndex = 0;
    let m: RegExpExecArray | null;
    while ((m = rule.re.exec(ascii)) !== null) {
      if (m[0].length === 0) {
        rule.re.lastIndex++;
        continue;
      }
      if (rule.accept && !rule.accept(m[0])) continue;
      const start = m.index;
      const end = start + m[0].length;
      // الأولوية للقاعدة الأسبق: نتجاهل ما يتداخل مع مدى سبق التقاطه.
      if (spans.some((s) => start < s.end && end > s.start)) continue;
      spans.push({ start, end, kind: rule.kind });
    }
  }

  const counts: Record<RedactionKind, number> = {
    national_id: 0,
    phone: 0,
    email: 0,
    iban: 0,
    card: 0,
    passport: 0,
    long_number: 0,
  };
  spans.sort((a, b) => b.start - a.start);
  let text = input;
  for (const s of spans) {
    text = text.slice(0, s.start) + PLACEHOLDERS[s.kind] + text.slice(s.end);
    counts[s.kind]++;
  }
  return { text, counts, total: spans.length };
}

export const REDACTION_PLACEHOLDER_PATTERN = /\[[^\]]{2,30}\s(?:محجوب|محجوبة)\]/;
