/**
 * T-VOCAB-1 — المفتاح الموحّد لمجالات القانون (DomainKey).
 *
 * مفردات واحدة تُستخدم في كل طبقات النظام:
 *   - laws.category (CHECK في 001_init.sql + كيان Law)
 *   - questions.category (CHECK في 001_init.sql + كيان Question — هذه النقطة كانت
 *     نصاً حراً بلا قيد؛ أصبحت DomainKey موحّداً)
 *   - عقد OpenAPI (backend/openapi.yaml)
 *
 * عند وصول مصنّف المجال القانوني (EP-03 / وكيل ai) يجب أن يُخرج أحد هذه المفاتيح
 * حصراً؛ أي قيمة أخرى تُرفض (نوعياً عبر TS، وقاعدياً عبر CHECK في قاعدة البيانات).
 */
export const DOMAIN_KEYS = [
  'labor',
  'rent',
  'personal_status',
  'traffic',
  'consumer_protection',
  'other',
] as const;

export type DomainKey = (typeof DOMAIN_KEYS)[number];

export function isDomainKey(value: unknown): value is DomainKey {
  return typeof value === 'string' && (DOMAIN_KEYS as readonly string[]).includes(value);
}
