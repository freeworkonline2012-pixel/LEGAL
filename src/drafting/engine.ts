/**
 * محرك الصياغة: يتحقق من الإجابات ثم يجمع بنود القالب المطلوب فى مسودة. نقى بلا I/O، حتمى (نفس الإجابات ⇒ نفس النص حرفياً).
 */

import { CATALOG, specOf } from './catalog';
import { clauseHeading, dayAndDate, parseIsoDate } from './drafting-text';
import {
  type Answers,
  type ClauseDef,
  type Ctx,
  type TemplateOutput,
  type DraftClause,
  type DraftResult,
  type AnyDraftTypeId,
  type DraftTypeId,
  type DraftTypeSpec,
  type FieldSpec,
  DraftValidationError,
} from './drafting.types';
import { assessDraft } from './quality';
import { buildLease } from './templates/lease';
import { buildNda } from './templates/nda';
import { buildServices } from './templates/services';

const CONTROL = /[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F‎‏‪-‮⁦-⁩]/g;

/** ينظّف نصاً حراً: يحذف أحرف التحكم، يوحّد المسافات، ويُبقى الأسطر (للقوائم) بلا أسطر فارغة. */
function cleanMultiline(raw: string): string {
  return raw
    .replace(CONTROL, '')
    .split(/\r?\n/)
    .map((l) => l.replace(/\s+/g, ' ').trim())
    .filter(Boolean)
    .join('\n');
}

function visible(field: FieldSpec, values: Record<string, string>): boolean {
  if (!field.showWhen) return true;
  return values[field.showWhen.field] === field.showWhen.equals;
}

/** يتحقق من الإجابات وفق الكتالوج ويعيدها نظيفة؛ يرمى DraftValidationError بأخطاء لكل حقل. */
export function validateAnswers(spec: DraftTypeSpec, role: string, answers: Answers): Record<string, string> {
  const errors: Record<string, string> = {};
  if (!spec.roles.some((r) => r.value === role)) errors.role = 'اختر صفتك فى العقد';
  const raw: Record<string, string> = {};
  for (const f of spec.fields) {
    const v = answers[f.id];
    raw[f.id] = v === undefined || v === null ? '' : String(v).trim();
  }
  const out: Record<string, string> = {};
  for (const f of spec.fields) {
    if (!visible(f, raw)) continue;
    let value = raw[f.id];
    if (value === '' && f.default !== undefined && !f.required) value = f.default;
    if (value === '') {
      if (f.required) errors[f.id] = 'هذا الحقل مطلوب';
      continue;
    }
    switch (f.kind) {
      case 'text':
      case 'longtext': {
        const cleaned = f.kind === 'text' ? cleanMultiline(value).replace(/\n/g, ' ') : cleanMultiline(value);
        if (f.maxLength && cleaned.length > f.maxLength) errors[f.id] = `الحد الأقصى ${f.maxLength} حرفاً`;
        else if (cleaned === '') errors[f.id] = 'هذا الحقل مطلوب';
        else out[f.id] = cleaned;
        break;
      }
      case 'number':
      case 'money': {
        const num = Number(value.replace(/,/g, ''));
        if (!Number.isFinite(num)) errors[f.id] = 'أدخل رقماً صحيحاً';
        else if (f.min !== undefined && num < f.min) errors[f.id] = `لا يقل عن ${f.min}`;
        else if (f.max !== undefined && num > f.max) errors[f.id] = `لا يزيد عن ${f.max}`;
        else if (f.kind === 'money' && Math.round(num * 100) !== num * 100 && Math.abs(Math.round(num * 100) - num * 100) > 1e-6) errors[f.id] = 'حتى منزلتين عشريتين';
        else if (f.kind === 'number' && f.id.endsWith('_months') && !Number.isInteger(num)) errors[f.id] = 'أدخل عدداً صحيحاً';
        else if (f.kind === 'number' && /_days$|_years$/.test(f.id) && !Number.isInteger(num)) errors[f.id] = 'أدخل عدداً صحيحاً';
        else out[f.id] = String(num);
        break;
      }
      case 'date': {
        if (!parseIsoDate(value)) errors[f.id] = 'تاريخ غير صالح';
        else out[f.id] = value;
        break;
      }
      case 'choice': {
        if (!f.options?.some((o) => o.value === value)) errors[f.id] = 'اختر من الخيارات المتاحة';
        else out[f.id] = value;
        break;
      }
    }
  }
  crossValidate(spec.id, out, errors);
  if (Object.keys(errors).length > 0) throw new DraftValidationError(errors);
  return out;
}

function crossValidate(typeId: AnyDraftTypeId, v: Record<string, string>, errors: Record<string, string>): void {
  if (v.party1_name && v.party2_name && v.party1_name.replace(/\s+/g, '') === v.party2_name.replace(/\s+/g, '')) {
    errors.party2_name = 'اسم الطرفين لا يجوز أن يتطابق';
  }
  if (typeId === 'services' && v.payment_plan === 'three_stage') {
    const sum = Number(v.advance_percent_3 ?? 0) + Number(v.middle_percent ?? 0);
    if (sum > 95) errors.middle_percent = 'مجموع الدفعتين يجب ألا يتجاوز 95% ليبقى ما يُسدد عند القبول النهائى';
  }
  if (typeId === 'lease' && v.duration_months && v.rent_period) {
    const per = { monthly: 1, quarterly: 3, annual: 12 }[v.rent_period] ?? 1;
    if (Number(v.duration_months) % per !== 0) errors.duration_months = `مدة الإيجار يجب أن تكون من مضاعفات دورية السداد (${per} ${per === 1 ? 'شهر' : 'أشهر'})`;
  }
  if (typeId === 'services' && v.price_total && Number(v.price_total) < 1) errors.price_total = 'المقابل يجب أن يكون أكبر من صفر';
}

export function buildContext(typeId: AnyDraftTypeId, role: string, values: Record<string, string>, keys: string[]): Ctx {
  const numbered = new Map<string, number>();
  keys.forEach((k, i) => numbered.set(k, i + 1));
  return {
    typeId,
    role,
    s: (id) => values[id] ?? '',
    n: (id) => Number(values[id] ?? 0),
    c: (id) => values[id] ?? '',
    lines: (id) => (values[id] ?? '').split('\n').filter(Boolean),
    ref: (key) => {
      const n = numbered.get(key);
      if (n === undefined) throw new Error(`إحالة إلى بند غير موجود: ${key}`);
      return clauseHeading(n);
    },
    has: (key) => numbered.has(key),
  };
}

function templateOf(typeId: AnyDraftTypeId, role: string, v: Record<string, string>): TemplateOutput {
  switch (typeId) {
    case 'services':
      return buildServices(role, v);
    case 'lease':
      return buildLease(role, v);
    case 'nda':
      return buildNda(role, v);
    default:
      throw new DraftValidationError({ type: 'نوع العقد غير مدعوم فى مسار القوالب' });
  }
}

/** يولّد المسودة كاملة (مع بوابة الجودة). يرمى DraftValidationError عند خطأ فى الإجابات. */
export function generateDraft(typeId: string, role: string, answers: Answers): DraftResult {
  const spec = specOf(typeId);
  if (!spec) throw new DraftValidationError({ type: 'نوع العقد غير مدعوم' });
  const values = validateAnswers(spec, role, answers);
  const tpl = templateOf(spec.id, role, values);

  const active = tpl.clauses.filter((c) => c.when !== false);
  const ctx = buildContext(spec.id, role, values, active.map((c) => c.key));
  const clauses: DraftClause[] = active.map((c, i) => ({
    number: i + 1,
    heading: clauseHeading(i + 1),
    title: c.title,
    paragraphs: c.paragraphs(ctx),
  }));

  const fullText = [
    tpl.title,
    ...tpl.preamble,
    ...clauses.flatMap((c) => [`${c.heading}: ${c.title}`, ...c.paragraphs]),
    ...tpl.closing,
  ].join('\n');

  const quality = assessDraft({ contractTypePhrase: tpl.contractTypePhrase, title: tpl.title, typeId: spec.id, role, clauses, preamble: tpl.preamble, fullText });
  return {
    typeId: spec.id,
    typeLabel: spec.label,
    title: tpl.title,
    role,
    preamble: tpl.preamble,
    clauses,
    closing: tpl.closing,
    lawyerNotes: tpl.lawyerNotes,
    quality,
    fullText,
  };
}

export { CATALOG, dayAndDate };
