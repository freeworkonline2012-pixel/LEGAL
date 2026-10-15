/**
 * نموذج المستند الموحَّد للتنزيل (PDF / Word).
 *
 * كل خدمة (الإجابات، الحوكمة والالتزام، تدقيق العقود، وغداً المذكرات والتقارير القانونية)
 * تُنتج `LegalDocument` من بنّاء نقى (بلا I/O)، ثم تُخرجه مُخرِجات مستقلة (HTML→PDF و DOCX)
 * من النموذج نفسه — فلا يتكرر منطق المحتوى بين الصيغتين، ولا تحتاج خدمة جديدة أكثر من بنّاء واحد.
 * كل النصوص هنا خام (غير مُهرَّبة): الهروب مسؤولية المُخرِج حصراً.
 */

export type DocumentKind = 'answer' | 'governance' | 'contract_report' | 'memo' | 'legal_report';

export type CalloutTone = 'warning' | 'info' | 'note';

export type Block =
  | { type: 'heading'; text: string; level?: 2 | 3 }
  | { type: 'paragraph'; text: string }
  | { type: 'list'; items: string[]; ordered?: boolean }
  | { type: 'callout'; tone: CalloutTone; title?: string; text: string }
  | { type: 'quote'; text: string; caption?: string }
  | {
      type: 'ruling';
      claim: string;
      /** "نص" (مقتطف حرفى مُتحقَّق منه) أو "تفسير" (استنتاج/تطبيق) */
      label: 'نص' | 'تفسير';
      quote: string | null;
      /** وصف المصدر المقروء: «القانون … المادة …» */
      sourceRef: string;
    }
  | { type: 'table'; columns: string[]; rows: string[][] }
  | {
      type: 'source';
      ref: string;
      /** ساري / معدّل / ملغى / غير محسوم */
      status: string;
      /** أسطر وصفية إضافية (آخر تعديل …) */
      details: string[];
      snippet: string;
      url: string | null;
    };

export interface DocumentMetaRow {
  label: string;
  value: string;
}

export interface LegalDocument {
  kind: DocumentKind;
  brand: string;
  title: string;
  subtitle?: string;
  /** رقم المرجع المعروض فى الترويسة والتذييل (يُستعمل للاستشهاد بالمستند) */
  reference: string;
  generatedAt: Date;
  meta: DocumentMetaRow[];
  /** علامة مائية قطرية (مثل «مسودة — لم تُعتمد») أو null */
  watermark: string | null;
  blocks: Block[];
  /** إخلاء المسؤولية الختامى — إلزامى فى كل مستند */
  disclaimer: string;
  /** اسم الملف بلا امتداد (ASCII فقط) */
  filenameBase: string;
}

export const DEFAULT_BRAND = 'شيلد';

export const STANDARD_DISCLAIMER =
  'هذا المستند ناتج آلى من المنصة استناداً إلى النصوص القانونية المفهرسة لديها وقت إصداره، وليس رأياً قانونياً ' +
  'ولا استشارة، ولا يُغنى عن مراجعة محامٍ مقيد قبل اتخاذ أى قرار أو الاستناد إليه أمام جهة قضائية أو إدارية. ' +
  'يلزم التحقق من سريان النصوص المذكورة وقت الاستشهاد بها، ومن مطابقتها للنص الرسمى المنشور.';

/** وصف مصدر مقروء: «قانون العمل — القانون رقم 12 لسنة 2003 — المادة 110» */
export function formatSourceRef(c: { law: string; lawNo: number; lawYear: number; articleNo: number }): string {
  return `${c.law} — رقم ${c.lawNo} لسنة ${c.lawYear} — المادة ${c.articleNo}`;
}

/** تاريخ ووقت بتوقيت القاهرة بأرقام لاتينية (متسق مع أرقام المواد فى المنصة). */
export function formatCairoDateTime(d: Date): string {
  return new Intl.DateTimeFormat('ar-EG-u-nu-latn', {
    timeZone: 'Africa/Cairo',
    dateStyle: 'long',
    timeStyle: 'short',
  }).format(d);
}

export function formatCairoDate(d: Date): string {
  return new Intl.DateTimeFormat('ar-EG-u-nu-latn', { timeZone: 'Africa/Cairo', dateStyle: 'long' }).format(d);
}

/** YYYYMMDD بتوقيت القاهرة لأسماء الملفات. */
export function compactCairoDate(d: Date): string {
  const parts = new Intl.DateTimeFormat('en-CA', {
    timeZone: 'Africa/Cairo',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(d);
  return parts.replace(/-/g, '');
}

/** مرجع قصير مقروء من UUID: ANS-1A2B3C4D */
export function shortReference(prefix: string, uuid: string): string {
  return `${prefix}-${uuid.replace(/-/g, '').slice(0, 8).toUpperCase()}`;
}

/** يقبل روابط http/https فقط — أى مخطط آخر (javascript:, data:, file:) يُسقَط. */
export function safeUrl(url: string | null | undefined): string | null {
  if (!url) return null;
  try {
    const u = new URL(url);
    return u.protocol === 'https:' || u.protocol === 'http:' ? u.toString() : null;
  } catch {
    return null;
  }
}
