/**
 * تقسيم نص العقد إلى وحدات ترجمة (فقرات منطقية) مع الحفاظ على الترتيب والعناوين والترقيم.
 *
 * الاستخراج من PDF يكسر الفقرة إلى أسطر قصيرة (التفاف الصفحة)، ومن Word يُنتج فقرة لكل سطر فاصل. القاعدة:
 *  - السطر الفارغ يفصل الفقرات.
 *  - سطر يبدأ بترقيم/عنوان بند (1. / (أ) / البند الأول / Article 3 / - ...) يبدأ وحدة جديدة.
 *  - غير ذلك: سطر متابعة يُلصق بالوحدة السابقة بمسافة (إصلاح الالتفاف).
 * الوحدة الأطول من MAX_UNIT_CHARS تُقسَّم عند نهايات الجمل إلى قطع متتابعة (cont=true) كى يبقى الطلب للنموذج صغيراً
 * ويبقى التقابل بين الأصل والترجمة دقيقاً؛ وتُلصق القطع عند العرض والتنزيل.
 */

export interface SourceUnit {
  /** نص الوحدة (فقرة أو قطعة منها) */
  text: string;
  /** قطعة متابعة لفقرة طويلة سبقتها وحدة */
  cont: boolean;
}

export const MAX_UNIT_CHARS = 2500;
export const MAX_TOTAL_CHARS = 150_000;
export const MAX_UNITS = 2500;

const LINE_STARTERS: RegExp[] = [
  /^\(?[0-9٠-٩]{1,3}\s*[).\-–:/]/, // 1.  1)  (1)  1-
  /^\([A-Za-zء-ي]{1,3}\)/, // (a) (أ)
  /^[A-Za-zء-ي]\s*[).]\s/, // a)  أ)
  /^\(?[ivxIVX]{1,5}[).]\s/, // i.  (iv)
  /^(البند|المادة|مادة|بند|الفصل|الباب|ملحق|الملحق)\b/,
  /^(Article|Clause|Section|Schedule|Annex|Appendix|Exhibit|Recital|Whereas|WHEREAS|ARTICLE|CLAUSE|SECTION|SCHEDULE|ANNEX)\b/,
  /^(أولاً|ثانياً|ثالثاً|رابعاً|خامساً|سادساً|سابعاً|ثامناً|تاسعاً|عاشراً|أولا|ثانيا|ثالثا|رابعا|خامسا)\b/,
  /^[-•*–·]\s/,
];

const PAGE_MARKER = /^\s*(--\s*)?\d+\s+(of|\/|من)\s+\d+(\s*--)?\s*$/i;

function startsNewUnit(line: string): boolean {
  const t = line.trim();
  return LINE_STARTERS.some((re) => re.test(t));
}

function splitLongUnit(text: string): string[] {
  if (text.length <= MAX_UNIT_CHARS) return [text];
  const sentences = text.split(/(?<=[.!?؟؛;:])\s+/);
  const out: string[] = [];
  let cur = '';
  for (const s of sentences) {
    if (s.length > MAX_UNIT_CHARS) {
      // جملة واحدة ضخمة بلا ترقيم: قص عند أقرب مسافة
      if (cur) out.push(cur);
      cur = '';
      let rest = s;
      while (rest.length > MAX_UNIT_CHARS) {
        const cut = rest.lastIndexOf(' ', MAX_UNIT_CHARS);
        const at = cut > MAX_UNIT_CHARS / 2 ? cut : MAX_UNIT_CHARS;
        out.push(rest.slice(0, at).trim());
        rest = rest.slice(at).trim();
      }
      cur = rest;
      continue;
    }
    if ((cur + ' ' + s).trim().length > MAX_UNIT_CHARS) {
      out.push(cur);
      cur = s;
    } else {
      cur = (cur ? cur + ' ' : '') + s;
    }
  }
  if (cur) out.push(cur);
  return out.filter((x) => x.length > 0);
}

export interface SplitResult {
  units: SourceUnit[];
  totalChars: number;
}

export function splitIntoUnits(rawText: string): SplitResult {
  const text = rawText
    .replace(/\r\n?/g, '\n')
    .replace(/[​‎‏‪-‮⁦-⁩﻿]/g, '')
    .replace(/ /g, ' ');
  const paragraphs: string[] = [];
  for (const block of text.split(/\n\s*\n/)) {
    let current = '';
    for (const rawLine of block.split('\n')) {
      const line = rawLine.replace(/[ \t]+/g, ' ').trim();
      if (!line || PAGE_MARKER.test(line)) continue;
      if (current && startsNewUnit(line)) {
        paragraphs.push(current);
        current = line;
      } else {
        current = current ? `${current} ${line}` : line;
      }
    }
    if (current) paragraphs.push(current);
  }

  const units: SourceUnit[] = [];
  let totalChars = 0;
  for (const p of paragraphs) {
    totalChars += p.length;
    splitLongUnit(p).forEach((chunk, i) => units.push({ text: chunk, cont: i > 0 }));
  }
  return { units, totalChars };
}

/** تجميع الوحدات إلى دفعات متتابعة بحد حروف وعدد وحدات — الدفعة هى وحدة طلب النموذج. */
export const BATCH_MAX_CHARS = 5000;
export const BATCH_MAX_UNITS = 40;

export function planBatches(unitLengths: number[]): Array<{ start: number; end: number }> {
  const batches: Array<{ start: number; end: number }> = [];
  let start = 0;
  let chars = 0;
  for (let i = 0; i < unitLengths.length; i++) {
    const len = unitLengths[i];
    if (i > start && (chars + len > BATCH_MAX_CHARS || i - start >= BATCH_MAX_UNITS)) {
      batches.push({ start, end: i });
      start = i;
      chars = 0;
    }
    chars += len;
  }
  if (unitLengths.length > start) batches.push({ start, end: unitLengths.length });
  return batches;
}
