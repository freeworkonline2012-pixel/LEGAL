/**
 * نموذج «تقرير مراجعة وتدقيق مخاطر العقد» — الشكل النهائى المعتمد من المالك (Contract_Risk_Audit_Final_v3_AR).
 * نموذج مستقل عن LegalDocument العام لأن هذا التقرير له غلاف وترويسة وألوان وجداول خاصة؛ المُخرِجان (HTML→PDF وWord)
 * يرسمان من هذا النموذج نفسه فلا يتباعد الشكل بين الصيغتين. كل النصوص خام (الهروب مسؤولية المُخرِج).
 */

/** نغمات الخلايا (مأخوذة من لوحة الألوان الفعلية للتقرير المرجعى). */
export type Tone = 'critical' | 'high' | 'medium' | 'info' | 'navy' | 'grey' | 'plain';

export interface Cell {
  text: string;
  tone?: Tone;
  bold?: boolean;
  /** رابط رسمى (http/https فقط، يُتحقَّق منه قبل الإدراج) */
  link?: string | null;
  center?: boolean;
}

export type RBlock =
  /** شريط قسم مرقَّم (خلفية كحلية ونص أبيض) */
  | { t: 'banner'; text: string }
  /** عنوان فرعى ملوَّن بخط سفلى (المخاطر الحرجة/العالية/المتوسطة، التشريعات…) */
  | { t: 'sub'; text: string; tone: 'critical' | 'high' | 'medium' | 'navy' }
  /** عنوان بند (كحلى عريض بخط سفلى رفيع أحياناً) */
  | { t: 'h3'; text: string; rule?: boolean }
  | { t: 'p'; text: string; size?: 'normal' | 'small' }
  /** شريط الإحصاءات (4 خلايا ملوَّنة) */
  | { t: 'strip'; cells: Array<{ text: string; tone: Tone }> }
  /** جدول بترويسة كحلية */
  | { t: 'grid'; columns: string[]; rows: Cell[][]; widths?: number[] }
  /** جدول بلا ترويسة (خلايا بنغمات) */
  | { t: 'table'; rows: Cell[][]; widths?: number[] }
  /** جدول تفاصيل: عمود تسمية ملوَّن + عمود قيمة */
  | { t: 'kv'; rows: Array<{ label: string; tone: Tone; value: string }> }
  /** مقارنة: النص المُعدَّل (يمين) مقابل النص الأصلى (يسار) */
  | { t: 'compare'; modifiedTitle: string; originalTitle: string; modified: string; original: string }
  /** التعليق القانونى (مائل كحلى) */
  | { t: 'commentary'; text: string }
  | { t: 'bullets'; items: string[] }
  /** ملاحظة بخلفية صفراء */
  | { t: 'note'; label: string; text: string }
  /** جدول بيانات رأسى بتسمية كحلية (رقم الوثيقة/البصمة) */
  | { t: 'idtable'; rows: Array<{ label: string; value: string }> }
  /** قسم التوقيعات: عمودان (المستشار القانونى / ممثل العميل) */
  | { t: 'signatures'; left: SignatureColumn; right: SignatureColumn; dateRow: { left: string; right: string } }
  /** فاصل صفحة */
  | { t: 'pagebreak' };

export interface SignatureColumn {
  title: string;
  fields: string[];
  signatureLabel: string;
}

export interface AuditReport {
  /** نص الترويسة (أعلى كل صفحة، رمادى) */
  headerText: string;
  /** عنوان التذييل (يليه رقم الصفحة) */
  footerText: string;
  watermark: string | null;
  cover: {
    title: string;
    subtitle: string;
    rows: Array<{ label: string; value: string; tone?: Tone }>;
  };
  blocks: RBlock[];
}

/** ألوان التقرير المرجعى (hex بلا #). */
export const PALETTE = {
  navy: '1F3864',
  blue: '2E74B5',
  info: 'DEEAF1',
  critical: 'FCE4D6',
  criticalInk: 'C00000',
  high: 'FFF2CC',
  highInk: 'C55A11',
  medium: 'E2EFDA',
  mediumInk: '375623',
  grey: '888888',
  line: 'BFBFBF',
  white: 'FFFFFF',
  black: '000000',
} as const;

export interface ToneStyle {
  fill: string | null;
  ink: string;
  bold: boolean;
}

/** نمط كل نغمة: خلفية، لون الخط، وهل الخط عريض افتراضياً. */
export const TONE_STYLE: Record<Tone, ToneStyle> = {
  critical: { fill: PALETTE.critical, ink: PALETTE.criticalInk, bold: true },
  high: { fill: PALETTE.high, ink: PALETTE.highInk, bold: true },
  medium: { fill: PALETTE.medium, ink: PALETTE.mediumInk, bold: true },
  info: { fill: PALETTE.info, ink: PALETTE.navy, bold: true },
  navy: { fill: PALETTE.navy, ink: PALETTE.white, bold: true },
  grey: { fill: 'EDEDED', ink: '595959', bold: true },
  plain: { fill: null, ink: PALETTE.black, bold: false },
};
