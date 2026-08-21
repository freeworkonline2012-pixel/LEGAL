/**
 * منطق إصدارات المواد — دوال نقية (pure functions) قابلة للاختبار دون قاعدة بيانات.
 * كل "مادة" لها عدة article_versions بتواريخ سريان؛ الإصدار الساري في تاريخ معيّن
 * هو ما يُعرض (US-02.03).
 */

export type VersionStatus = 'active' | 'amended' | 'repealed';

export interface VersionLike {
  id: string;
  versionNo: number;
  body: string;
  /** YYYY-MM-DD */
  effectiveFrom: string;
  /** YYYY-MM-DD أو null = ساري حتى إشعار آخر */
  effectiveTo: string | null;
  status: VersionStatus;
}

export interface NewVersionInput {
  body: string;
  effectiveFrom: string;
  status?: VersionStatus;
  amendedByLawNo?: number | null;
  amendedByLawYear?: number | null;
  changeNote?: string | null;
}

/** إضافة أيام لتاريخ YYYY-MM-DD (يعالج حدود الشهور) */
export function addDays(date: string, days: number): string {
  const d = new Date(`${date}T00:00:00Z`);
  if (Number.isNaN(d.getTime())) {
    throw new Error(`invalid date: ${date}`);
  }
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

/**
 * يعيد الإصدار الساري في التاريخ المحدد (YYYY-MM-DD).
 * القاعدة: effectiveFrom <= date AND (effectiveTo IS NULL OR effectiveTo >= date).
 * عند تساوي تواريخ السريان، يُرجَع الإصدار الأعلى رقماً (الأحدث).
 */
export function versionEffectiveOn(versions: VersionLike[], date: string): VersionLike | null {
  const sorted = [...versions].sort((a, b) => {
    const byFrom = b.effectiveFrom.localeCompare(a.effectiveFrom);
    if (byFrom !== 0) {
      return byFrom;
    }
    return b.versionNo - a.versionNo;
  });

  for (const version of sorted) {
    if (version.effectiveFrom <= date) {
      if (version.effectiveTo === null || version.effectiveTo >= date) {
        return version;
      }
    }
  }
  return null;
}

/**
 * يغلق الإصدار الحالي عند تعديله: يضع effectiveTo = اليوم السابق لسريان الإصدار الجديد
 * ويحوّل حالته إلى amended.
 */
export function closeCurrentVersion(current: VersionLike, newEffectiveFrom: string): VersionLike {
  return {
    ...current,
    effectiveTo: addDays(newEffectiveFrom, -1),
    status: 'amended',
  };
}

/** رقم الإصدار التالي = أعلى رقم موجود + 1 */
export function nextVersionNo(versions: VersionLike[]): number {
  return versions.reduce((max, version) => Math.max(max, version.versionNo), 0) + 1;
}

/** تحقق أن تاريخ السريان الجديد لا يتعارض مع بداية الإصدار الحالي */
export function assertValidEffectiveFrom(
  current: VersionLike | null,
  newEffectiveFrom: string,
): void {
  if (current && newEffectiveFrom <= current.effectiveFrom) {
    throw new Error(
      `new effective_from (${newEffectiveFrom}) must be after current (${current.effectiveFrom})`,
    );
  }
}
