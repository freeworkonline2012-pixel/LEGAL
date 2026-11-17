import { createHash } from 'crypto';
import type { EvalKey, KeyIssue } from './types';
import { SEVERITIES } from './types';

/** بصمة محتوى المفتاح (بلا حقل frozen) — ثابتة مهما اختلف ترتيب الحقول. */
export function keyDigest(key: EvalKey): string {
  const { frozen: _frozen, ...rest } = key;
  const canon = (v: unknown): unknown => {
    if (Array.isArray(v)) return v.map(canon);
    if (v && typeof v === 'object') return Object.fromEntries(Object.entries(v as Record<string, unknown>).sort(([a], [b]) => (a < b ? -1 : 1)).map(([k, x]) => [k, canon(x)]));
    return v;
  };
  return createHash('sha256').update(JSON.stringify(canon(rest))).digest('hex');
}

export function freezeKey(key: EvalKey, now = new Date()): EvalKey {
  return { ...key, frozen: { at: now.toISOString(), sha256: keyDigest({ ...key, frozen: undefined }) } };
}

export function validateKey(raw: unknown): { key: EvalKey | null; errors: string[] } {
  const errors: string[] = [];
  const k = raw as Partial<EvalKey> | null;
  if (!k || typeof k !== 'object') return { key: null, errors: ['المفتاح ليس كائناً صالحاً'] };
  if (k.schema !== 'shield-eval-key/1') errors.push('schema يجب أن تكون shield-eval-key/1');
  if (typeof k.contract_ref !== 'string' || !k.contract_ref.trim()) errors.push('contract_ref مطلوب');
  if (k.set !== 'holdout' && k.set !== 'dev') errors.push('set يجب أن تكون holdout أو dev');
  if (!Array.isArray(k.issues)) errors.push('issues مطلوبة (قائمة، وقد تكون فارغة لعقد سليم)');
  const ids = new Set<string>();
  for (const i of (k.issues ?? []) as KeyIssue[]) {
    if (!i || typeof i.id !== 'string' || !i.id) errors.push('كل ملاحظة تحتاج id');
    else if (ids.has(i.id)) errors.push(`id مكرر: ${i.id}`);
    else ids.add(i.id);
    if (!SEVERITIES.includes(i.severity)) errors.push(`${i?.id}: severity غير صالحة`);
    if (i?.kind === 'clause') {
      const has = Array.isArray(i.clause) ? i.clause.length > 0 : typeof i.clause === 'number';
      if (!has) errors.push(`${i.id}: ملاحظة بند تحتاج رقم البند (clause)`);
    } else if (i?.kind === 'absent') {
      if ((i.finding_ids?.length ?? 0) === 0 && (i.keywords?.length ?? 0) === 0) errors.push(`${i.id}: ملاحظة غياب تحتاج finding_ids أو keywords`);
    } else errors.push(`${i?.id}: kind يجب أن تكون clause أو absent`);
    if (typeof i?.topic !== 'string' || !i.topic.trim()) errors.push(`${i?.id}: topic مطلوب`);
  }
  return { key: errors.length ? null : (k as EvalKey), errors };
}

/** صلاحية المفتاح كمرجع Holdout: مجمَّد وبصمته لم تتغير. */
export function holdoutKeyProblems(key: EvalKey): string[] {
  if (key.set !== 'holdout') return [];
  if (!key.frozen) return ['مفتاح Holdout غير مجمَّد (شغّل freeze قبل رفع العقد للمطور)'];
  if (key.frozen.sha256 !== keyDigest({ ...key, frozen: undefined })) return ['محتوى المفتاح تغيّر بعد التجميد (البصمة لا تطابق)'];
  return [];
}
