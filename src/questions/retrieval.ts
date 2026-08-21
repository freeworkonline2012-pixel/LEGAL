/**
 * أدوات استرجاع نقية (pure functions) — تُستخدم في خط سؤال/إجابة (US-03.x).
 * تُحدَّد هنا إشارات أرقام المواد والقوانين داخل نص السؤال، وعتبات الثقة.
 */
import { normalizeArabic, toEnglishDigits } from '../ingestion/normalize';

export interface ArticleReference {
  articleNo: number;
  lawNo?: number;
  lawYear?: number;
}

/** عتبة الرفض: أي ثقة أقل منها → إجابة رفض صريحة (عقد API: refused=true) */
export const REFUSAL_THRESHOLD = 0.2;

/** مفردات حالة الاستشهاد (عقد API + قيد CHECK في citations.status) */
export type CitationStatusValue = 'active' | 'amended' | 'repealed';

/**
 * يحوّل حالة القانون إلى مفردات حالة الاستشهاد.
 * القانون يستخدم in_force/amended/repealed بينما الاستشهاد (citations.status)
 * يستخدم active/amended/repealed — الخلط بين المفردتين يكسر قيد CHECK في
 * قاعدة البيانات (INSERT يفشل → 500 على POST /api/questions) وينحرف عن
 * عقد API الموثّق في openapi.yaml (CitationResponse.status enum).
 */
export function toCitationStatus(
  lawStatus: 'in_force' | 'amended' | 'repealed',
): CitationStatusValue {
  return lawStatus === 'in_force' ? 'active' : lawStatus;
}

/**
 * يستخرج إشارة صريحة لرقم مادة (وقانون إن وُجد) من نص السؤال.
 * يدعم: «مادة 110»، «المادة 224»، «ماده ١١٠»، «مادة 110 من قانون 12 لسنة 2003».
 */
export function detectArticleReference(text: string): ArticleReference | null {
  const normalized = normalizeArabic(toEnglishDigits(text));

  const articleMatch = normalized.match(/(?:ماده|الماده)\s+(\d+)/);
  if (!articleMatch) {
    return null;
  }

  const articleNo = Number.parseInt(articleMatch[1], 10);
  if (!Number.isInteger(articleNo) || articleNo <= 0) {
    return null;
  }

  const ref: ArticleReference = { articleNo };

  const lawMatch = normalized.match(/قانون\s+رقم\s+(\d+)/) ?? normalized.match(/قانون\s+(\d+)/);
  if (lawMatch) {
    const lawNo = Number.parseInt(lawMatch[1], 10);
    if (Number.isInteger(lawNo) && lawNo > 0) {
      ref.lawNo = lawNo;
    }
  }

  const yearMatch = normalized.match(/(?:لسنه|لسنة|سنه|سنة)\s+(\d{4})/);
  if (yearMatch) {
    ref.lawYear = Number.parseInt(yearMatch[1], 10);
  }

  return ref;
}

/** نص استعلام FTS: يحوّل السؤال لتوكينز متسامحة مع العربية */
export function buildFtsQuery(text: string): string {
  const tokens = normalizeArabic(toEnglishDigits(text))
    .split(/\s+/)
    .filter((token) => token.length > 1)
    .slice(0, 8);
  return tokens.join(' & ');
}

/** تحويل rank خام (0..1 عادة) إلى ثقة محصورة 0..1 */
export function confidenceFromRank(rank: number): number {
  if (!Number.isFinite(rank)) {
    return 0;
  }
  return Math.min(1, Math.max(0, rank));
}

export function isConfident(confidence: number): boolean {
  return confidence >= REFUSAL_THRESHOLD;
}
