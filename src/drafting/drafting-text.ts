/**
 * مساعدات نصية نقية للصياغة: المبلغ بالحروف، التاريخ، تسمية البنود. بلا I/O.
 */

import { canonicalHeading } from '../contracts/clause-headings';

const ONES = ['', 'واحد', 'اثنان', 'ثلاثة', 'أربعة', 'خمسة', 'ستة', 'سبعة', 'ثمانية', 'تسعة', 'عشرة', 'أحد عشر', 'اثنا عشر', 'ثلاثة عشر', 'أربعة عشر', 'خمسة عشر', 'ستة عشر', 'سبعة عشر', 'ثمانية عشر', 'تسعة عشر'];
const TENS = ['', '', 'عشرون', 'ثلاثون', 'أربعون', 'خمسون', 'ستون', 'سبعون', 'ثمانون', 'تسعون'];
const ONES_GEN = ['', 'واحد', 'اثنين', 'ثلاثة', 'أربعة', 'خمسة', 'ستة', 'سبعة', 'ثمانية', 'تسعة', 'عشرة', 'أحد عشر', 'اثنى عشر', 'ثلاثة عشر', 'أربعة عشر', 'خمسة عشر', 'ستة عشر', 'سبعة عشر', 'ثمانية عشر', 'تسعة عشر'];
const TENS_GEN = ['', '', 'عشرين', 'ثلاثين', 'أربعين', 'خمسين', 'ستين', 'سبعين', 'ثمانين', 'تسعين'];
const HUNDREDS_GEN = ['', 'مائة', 'مائتين', 'ثلاثمائة', 'أربعمائة', 'خمسمائة', 'ستمائة', 'سبعمائة', 'ثمانمائة', 'تسعمائة'];
const HUNDREDS = ['', 'مائة', 'مائتان', 'ثلاثمائة', 'أربعمائة', 'خمسمائة', 'ستمائة', 'سبعمائة', 'ثمانمائة', 'تسعمائة'];

/** عدد صحيح 1..999 بالحروف (gen = حالة الجر بعد حرف جر: «ثلاثين»، «اثنى عشر»، «مائتين»). */
function below1000(n: number, gen = false): string {
  const ones = gen ? ONES_GEN : ONES;
  const tens = gen ? TENS_GEN : TENS;
  const hundreds = gen ? HUNDREDS_GEN : HUNDREDS;
  const h = Math.floor(n / 100);
  const rest = n % 100;
  const parts: string[] = [];
  if (h) parts.push(hundreds[h]);
  if (rest) {
    if (rest < 20) parts.push(ones[rest]);
    else {
      const t = Math.floor(rest / 10);
      const o = rest % 10;
      parts.push(o ? `${ones[o]} و${tens[t]}` : tens[t]);
    }
  }
  return parts.join(' و');
}

/** مجموعة (آلاف/ملايين/مليارات) بصيغتها المفردة والمثناة والجمع. */
function scaled(g: number, one: string, two: string, few: string, many: string, gen: boolean): string {
  if (g === 1) return one;
  if (g === 2) return gen ? `${two.slice(0, -2)}ين` : two;
  if (g >= 3 && g <= 10) return `${below1000(g, gen)} ${few}`;
  // مائتا ألف / مائتى ألف
  if (g === 200) return gen ? `مائتى ${one}` : `مائتا ${one}`;
  return `${below1000(g, gen)} ${many}`;
}

/** عدد صحيح غير سالب (حتى 999 مليار) بالحروف. الصفر = «صفر». gen = حالة الجر. */
export function integerInWords(n: number, gen = false): string {
  if (!Number.isInteger(n) || n < 0 || n > 999_999_999_999) throw new RangeError('عدد خارج النطاق');
  if (n === 0) return 'صفر';
  const billions = Math.floor(n / 1_000_000_000);
  const millions = Math.floor((n % 1_000_000_000) / 1_000_000);
  const thousands = Math.floor((n % 1_000_000) / 1000);
  const rest = n % 1000;
  const parts: string[] = [];
  if (billions) parts.push(scaled(billions, 'مليار', 'ملياران', 'مليارات', 'مليار', gen));
  if (millions) parts.push(scaled(millions, 'مليون', 'مليونان', 'ملايين', 'مليون', gen));
  if (thousands) parts.push(scaled(thousands, 'ألف', 'ألفان', 'آلاف', 'ألف', gen));
  if (rest) parts.push(below1000(rest, gen));
  return parts.join(' و');
}

/** «جنيه مصرى واحد» / «جنيهان مصريان» / «ثلاثة جنيهات مصرية» / «خمسون جنيهاً مصرياً» / «مائة جنيه مصرى». */
function poundsPhrase(n: number): string {
  if (n === 1) return 'جنيه مصرى واحد';
  if (n === 2) return 'جنيهان مصريان';
  const last2 = n % 100;
  if (last2 >= 3 && last2 <= 10) return `${integerInWords(n)} جنيهات مصرية`;
  if (n % 100 === 0) return `${integerInWords(n)} جنيه مصرى`;
  return `${integerInWords(n)} جنيهاً مصرياً`;
}

function filsPhrase(n: number): string {
  if (n === 1) return 'قرش واحد';
  if (n === 2) return 'قرشان';
  if (n >= 3 && n <= 10) return `${integerInWords(n)} قروش`;
  return `${integerInWords(n)} قرشاً`;
}

/** المبلغ بالجنيه المصرى مع قروش اختيارية (حتى منزلتين) بالحروف: «خمسون ألف جنيه مصرى». */
export function egpInWords(amount: number): string {
  if (!Number.isFinite(amount) || amount < 0 || amount > 999_999_999_999) throw new RangeError('مبلغ غير صالح');
  const piastres = Math.round(amount * 100);
  const pounds = Math.floor(piastres / 100);
  const fils = piastres % 100;
  const parts: string[] = [];
  if (pounds > 0 || fils === 0) parts.push(pounds === 0 ? 'صفر جنيه مصرى' : poundsPhrase(pounds));
  if (fils > 0) parts.push(filsPhrase(fils));
  return parts.join(' و');
}

/** رقم بفواصل الآلاف بأرقام لاتينية: 1,250,000 (ويُبقى الكسر إن وُجد). */
export function groupDigits(n: number): string {
  const [i, f] = n.toFixed(2).split('.');
  const intPart = i.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  return f === '00' ? intPart : `${intPart}.${f}`;
}

/** «50,000 جنيه مصرى (فقط خمسون ألف جنيه مصرى لا غير)» */
export function moneyPhrase(amount: number): string {
  return `${groupDigits(amount)} جنيه مصرى (فقط ${egpInWords(amount)} لا غير)`;
}

const DAYS_AR = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];

/** تاريخ ISO (YYYY-MM-DD) إلى {y,m,d} أو null إن لم يكن تاريخاً حقيقياً. */
export function parseIsoDate(s: string): { y: number; m: number; d: number } | null {
  const mt = /^(\d{4})-(\d{2})-(\d{2})$/.exec(s);
  if (!mt) return null;
  const y = Number(mt[1]);
  const m = Number(mt[2]);
  const d = Number(mt[3]);
  const dt = new Date(Date.UTC(y, m - 1, d));
  if (dt.getUTCFullYear() !== y || dt.getUTCMonth() !== m - 1 || dt.getUTCDate() !== d) return null;
  return { y, m, d };
}

/** 05/03/2026 */
export function formatDate(iso: string): string {
  const p = parseIsoDate(iso);
  if (!p) throw new RangeError('تاريخ غير صالح');
  return `${String(p.d).padStart(2, '0')}/${String(p.m).padStart(2, '0')}/${p.y}`;
}

/** «يوم الأحد الموافق 05/03/2026» */
export function dayAndDate(iso: string): string {
  const p = parseIsoDate(iso);
  if (!p) throw new RangeError('تاريخ غير صالح');
  const dow = new Date(Date.UTC(p.y, p.m - 1, p.d)).getUTCDay();
  return `يوم ${DAYS_AR[dow]} الموافق ${formatDate(iso)}`;
}

/** إضافة أشهر مع الاحتفاظ بنهاية الشهر عند الحاجة، ثم طرح يوم واحد (نهاية المدة شاملة). */
export function endOfTerm(startIso: string, months: number): string {
  const p = parseIsoDate(startIso);
  if (!p) throw new RangeError('تاريخ غير صالح');
  const total = p.m - 1 + months;
  const y = p.y + Math.floor(total / 12);
  const m = ((total % 12) + 12) % 12;
  const lastDay = new Date(Date.UTC(y, m + 1, 0)).getUTCDate();
  const d = Math.min(p.d, lastDay);
  const end = new Date(Date.UTC(y, m, d));
  end.setUTCDate(end.getUTCDate() - 1);
  return `${end.getUTCFullYear()}-${String(end.getUTCMonth() + 1).padStart(2, '0')}-${String(end.getUTCDate()).padStart(2, '0')}`;
}

/** «ثلاثة (3) أيام» / «يوم واحد» / «شهران» … بصياغة عددية قصيرة: «30 (ثلاثين) يوماً». */
export function countPhrase(n: number, unit: 'day' | 'month' | 'year' | 'week'): string {
  const forms = {
    day: ['يوم', 'يومين', 'أيام', 'يوماً'],
    week: ['أسبوع', 'أسبوعين', 'أسابيع', 'أسبوعاً'],
    month: ['شهر', 'شهرين', 'أشهر', 'شهراً'],
    year: ['سنة', 'سنتين', 'سنوات', 'سنة'],
  }[unit];
  if (n === 1) return `${forms[0]} واحد`.replace('سنة واحد', 'سنة واحدة');
  if (n === 2) return forms[1];
  const word = integerInWords(n, true);
  const noun = n >= 3 && n <= 10 ? forms[2] : forms[3];
  return `${n} (${word}) ${noun}`;
}

/** رقم البند كعنوان: «البند الأول». */
export function clauseHeading(n: number): string {
  const h = canonicalHeading(n);
  if (!h) throw new RangeError(`لا عنوان ترتيبى للبند ${n}`);
  return h;
}

/** نسبة مئوية مقروءة: 0.5 => «0.5%». */
export function percent(n: number): string {
  return `${Number.isInteger(n) ? n : String(n)}%`;
}

/** اللام الجارة مع اسم الطرف: «العميل» ⇒ «للعميل»، «مقدم الخدمة» ⇒ «لمقدم الخدمة». */
export function lam(label: string): string {
  return label.startsWith('ال') ? `لل${label.slice(2)}` : `ل${label}`;
}
