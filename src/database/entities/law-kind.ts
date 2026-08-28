/**
 * T-VOCAB-2 — المفتاح الموحّد لنوع الأداة التشريعية (LawKind).
 *
 * العمود laws.kind أُضيف فى migrations/008_law_kind_and_guidance_documents.sql
 * (تصنيف/فلترة فقط — لا علاقة له بقيد uq_laws_country_no_year) لكنه ظل غير
 * مكشوف فى أي طبقة من طبقات الـ API (الكيان TypeORM، الـ DTOs، الخدمة) منذ
 * تلك الدفعة — فجوة اكتُشفت 2026-08-28 أثناء بناء صفحتى «القرارات» و«اللوائح
 * التنفيذية» فى الواجهة الأمامية، اللتين تحتاجان فلترة القوانين حسب kind.
 *
 * نفس نمط DOMAIN_KEYS (domain-key.ts) تماماً — مصدر واحد للحقيقة يُستخدم فى
 * الكيان والـ DTOs والخدمة معاً لتفادى فجوة النوع (type safety gap) المتكررة
 * الموثّقة هناك.
 *
 * القيم مطابقة حرفياً لقيد chk_laws_kind فى migrations/008:
 *   law                 — قانون (نص تشريعى أساسى، مثال: قانون العمل 14/2025)
 *   pm_decision         — قرار رئيس مجلس الوزراء
 *   ministerial_decision — قرار وزارى
 *   board_decision      — قرار مجلس إدارة هيئة (الافتراضى — الأغلبية الساحقة
 *                          من قرارات الرقابة المالية وغسل الأموال المُدخَلة حالياً)
 *   circular            — تعميم
 *   regulation          — لائحة تنفيذية (لا يوجد محتوى مُدخَل بعد لهذا النوع
 *                          اعتباراً من 2026-08-28 — راجع صفحة /regulations
 *                          فى الواجهة، حالة فارغة متعمَّدة)
 *   other                — أخرى
 */
export const LAW_KINDS = [
  'law',
  'pm_decision',
  'ministerial_decision',
  'board_decision',
  'circular',
  'regulation',
  'other',
] as const;

export type LawKind = (typeof LAW_KINDS)[number];

export function isLawKind(value: unknown): value is LawKind {
  return typeof value === 'string' && (LAW_KINDS as readonly string[]).includes(value);
}

/** التجميع المعروض للمستخدم كصفحة "القرارات" فى الواجهة — كل ما ليس قانوناً أساسياً أو لائحة تنفيذية أو "أخرى". */
export const DECISION_KINDS: readonly LawKind[] = [
  'pm_decision',
  'ministerial_decision',
  'board_decision',
  'circular',
];
