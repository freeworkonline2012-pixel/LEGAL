import { randomBytes } from 'crypto';
import { type ContractFamily, type FindingSeverity } from './contract-level';
import { DEFAULT_OFFICE_PROFILE, type OfficeProfile } from './office-rules';
import { firstPerClause, norm, type OfficeRule } from './office-rules-kit';

/**
 * Playbook لكل مكتب: إعداد بيانات (لا كود) فوق قواعد المكتب الافتراضية.
 *
 * ما يستطيع المكتب فعله:
 *  1. تعطيل قاعدة افتراضية لا تناسب ممارسته (disabledRules).
 *  2. تغيير درجة خطورة قاعدة افتراضية (severityOverrides).
 *  3. إضافة قواعد خاصة به (customRules) من نوعين، بعبارات نصية عادية لا تعبيرات نمطية:
 *     - forbidden_phrase: عبارة لا يريدها فى العقود (تُرصد الجملة التى ترد فيها، ويُقتبس نصها الحرفى).
 *     - required_phrase: عبارة يريدها فى كل عقد (يُرصد غيابها من العقد كله، وتُوسم غير مؤكدة على الممسوح ضوئياً كسائر ادعاءات الغياب).
 *
 * لماذا لا تعبيرات نمطية من المستخدم: عبارة نمطية خبيثة أو سيئة البناء تعلّق الخادم (ReDoS) وتوقف تدقيق كل المستخدمين؛
 * والمطابقة بالاحتواء على النص الموحَّد (تطبيع الهمزات والتشكيل والتاء المربوطة) كافية لحاجة المكتب وحتمية ومأمونة.
 *
 * حدود الصدق: القاعدة الخاصة «ممارسة تعاقدية للمكتب» وليست نصاً قانونياً، وتُعرض هكذا؛ والمطابقة بالاحتواء لا تفهم المعنى
 * (عبارة «تجديد تلقائى» ترصد الجملة التى تنفيه أيضاً)، فعلى المكتب اختيار عبارات دقيقة.
 */

export const PLAYBOOK_LIMITS = {
  maxCustomRules: 30,
  maxPhrasesPerRule: 10,
  maxPhraseLength: 80,
  minPhraseLength: 3,
  maxTitleLength: 120,
  maxTextLength: 600,
  maxDisabled: 200,
} as const;

export type CustomRuleKind = 'forbidden_phrase' | 'required_phrase';

export interface CustomRuleConfig {
  id: string;
  kind: CustomRuleKind;
  title: string;
  phrases: string[];
  /** null = كل أنواع العقود */
  families: ContractFamily[] | null;
  severity: FindingSeverity;
  explanation: string;
  suggestion: string;
  enabled: boolean;
}

export interface OfficePlaybookConfig {
  disabledRules: string[];
  severityOverrides: Record<string, FindingSeverity>;
  customRules: CustomRuleConfig[];
}

export const EMPTY_PLAYBOOK_CONFIG: OfficePlaybookConfig = { disabledRules: [], severityOverrides: {}, customRules: [] };

const SEVERITIES: FindingSeverity[] = ['حرج', 'عالٍ', 'متوسط', 'منخفض'];
/** القواعد الخاصة لا تُعلَن «حرجة»: هذه الدرجة محجوزة لما يخالف نصاً آمراً أو يوقف التدقيق. */
const CUSTOM_SEVERITIES: FindingSeverity[] = ['عالٍ', 'متوسط', 'منخفض'];
const FAMILIES: ContractFamily[] = [
  'lease', 'sale', 'services', 'employment', 'partnership', 'finance', 'agency', 'licence', 'security', 'gift', 'deposit', 'settlement', 'insurance', 'nda', 'unknown',
];
const KINDS: CustomRuleKind[] = ['forbidden_phrase', 'required_phrase'];
const ID_RE = /^[a-z0-9_]{1,40}$/;

export interface CatalogRule {
  id: string;
  title: string;
  severity: FindingSeverity;
  families: ContractFamily[] | null;
  excludeFamilies: ContractFamily[];
  /** تُعرض على طالب الخدمة فقط (تحجب عن مقدمها) */
  protects: 'requester' | null;
  absence: boolean;
}

/** القواعد الافتراضية كما تُعرض لشاشة الإعداد (بياناتها لا دوال التقييم). */
export function builtInCatalog(profile: OfficeProfile = DEFAULT_OFFICE_PROFILE): CatalogRule[] {
  return profile.rules.map((r) => ({
    id: r.id,
    title: r.title,
    severity: r.severity,
    families: r.families,
    excludeFamilies: r.excludeFamilies ?? [],
    protects: r.protects ?? null,
    absence: r.absence === true,
  }));
}

export type ParseResult = { ok: true; config: OfficePlaybookConfig } | { ok: false; errors: string[] };

const isObj = (v: unknown): v is Record<string, unknown> => typeof v === 'object' && v !== null && !Array.isArray(v);

const clean = (v: unknown): string => (typeof v === 'string' ? v.replace(/\s+/g, ' ').trim() : '');

function newId(taken: Set<string>): string {
  for (;;) {
    const id = `c_${randomBytes(4).toString('hex')}`;
    if (!taken.has(id)) return id;
  }
}

/**
 * يتحقق من إعداد الـPlaybook ويُنظّفه.
 *  - strict (عند الحفظ): أى خطأ يُرفض به الإعداد كله برسائل عربية واضحة، فلا يُحفظ نصف إعداد.
 *  - lenient (عند التحميل للتدقيق): ما اختل يُسقط بصمت (مثلاً قاعدة افتراضية أُزيلت من الكود)، فلا يتعطل تدقيق العقود بسبب إعداد قديم.
 */
export function parseOfficePlaybookConfig(raw: unknown, mode: 'strict' | 'lenient' = 'strict'): ParseResult {
  const strict = mode === 'strict';
  const errors: string[] = [];
  const fail = (m: string): void => {
    if (strict) errors.push(m);
  };
  if (!isObj(raw)) return strict ? { ok: false, errors: ['صيغة الإعداد غير صحيحة'] } : { ok: true, config: { ...EMPTY_PLAYBOOK_CONFIG } };

  const known = new Set(DEFAULT_OFFICE_PROFILE.rules.map((r) => r.id));

  // --- تعطيل ---
  const disabled: string[] = [];
  if (raw.disabledRules !== undefined) {
    if (!Array.isArray(raw.disabledRules)) fail('disabledRules يجب أن تكون قائمة');
    else {
      if (raw.disabledRules.length > PLAYBOOK_LIMITS.maxDisabled) fail('عدد القواعد المعطلة أكبر من المسموح');
      for (const id of raw.disabledRules.slice(0, PLAYBOOK_LIMITS.maxDisabled)) {
        if (typeof id !== 'string' || !known.has(id)) fail(`قاعدة غير معروفة للتعطيل: ${String(id).slice(0, 60)}`);
        else if (!disabled.includes(id)) disabled.push(id);
      }
    }
  }

  // --- درجات ---
  const overrides: Record<string, FindingSeverity> = {};
  if (raw.severityOverrides !== undefined) {
    if (!isObj(raw.severityOverrides)) fail('severityOverrides يجب أن تكون كائناً');
    else {
      for (const [id, sev] of Object.entries(raw.severityOverrides)) {
        if (!known.has(id)) fail(`قاعدة غير معروفة لتغيير الدرجة: ${id.slice(0, 60)}`);
        else if (typeof sev !== 'string' || !SEVERITIES.includes(sev as FindingSeverity)) fail(`درجة غير صحيحة للقاعدة ${id}`);
        else overrides[id] = sev as FindingSeverity;
      }
    }
  }

  // --- قواعد خاصة ---
  const custom: CustomRuleConfig[] = [];
  if (raw.customRules !== undefined) {
    if (!Array.isArray(raw.customRules)) fail('customRules يجب أن تكون قائمة');
    else {
      if (raw.customRules.length > PLAYBOOK_LIMITS.maxCustomRules) fail(`الحد الأقصى للقواعد الخاصة ${PLAYBOOK_LIMITS.maxCustomRules}`);
      const taken = new Set<string>();
      for (const [i, item] of raw.customRules.slice(0, PLAYBOOK_LIMITS.maxCustomRules).entries()) {
        const label = `القاعدة الخاصة رقم ${i + 1}`;
        if (!isObj(item)) {
          fail(`${label}: صيغة غير صحيحة`);
          continue;
        }
        const problems: string[] = [];
        const title = clean(item.title);
        if (!title) problems.push('العنوان مطلوب');
        else if (title.length > PLAYBOOK_LIMITS.maxTitleLength) problems.push(`العنوان أطول من ${PLAYBOOK_LIMITS.maxTitleLength} حرفاً`);

        const kind = item.kind;
        if (typeof kind !== 'string' || !KINDS.includes(kind as CustomRuleKind)) problems.push('نوع القاعدة يجب أن يكون forbidden_phrase أو required_phrase');

        const phrases: string[] = [];
        if (!Array.isArray(item.phrases) || item.phrases.length === 0) problems.push('العبارات مطلوبة (عبارة واحدة على الأقل)');
        else {
          if (item.phrases.length > PLAYBOOK_LIMITS.maxPhrasesPerRule) problems.push(`الحد الأقصى ${PLAYBOOK_LIMITS.maxPhrasesPerRule} عبارات`);
          for (const p of item.phrases.slice(0, PLAYBOOK_LIMITS.maxPhrasesPerRule)) {
            const text = clean(p);
            if (text.length > PLAYBOOK_LIMITS.maxPhraseLength) problems.push(`عبارة أطول من ${PLAYBOOK_LIMITS.maxPhraseLength} حرفاً`);
            else if (norm(text).length < PLAYBOOK_LIMITS.minPhraseLength) problems.push(`عبارة قصيرة جداً (ثلاثة أحرف على الأقل): «${text.slice(0, 20)}»`);
            else if (!phrases.includes(text)) phrases.push(text);
          }
        }

        let families: ContractFamily[] | null = null;
        if (item.families !== undefined && item.families !== null) {
          if (!Array.isArray(item.families)) problems.push('أنواع العقود يجب أن تكون قائمة');
          else if (item.families.length > 0) {
            const bad = item.families.filter((f) => typeof f !== 'string' || !FAMILIES.includes(f as ContractFamily));
            if (bad.length > 0) problems.push('نوع عقد غير معروف');
            else families = [...new Set(item.families as ContractFamily[])];
          }
        }

        const sev = item.severity ?? 'متوسط';
        if (typeof sev !== 'string' || !CUSTOM_SEVERITIES.includes(sev as FindingSeverity)) problems.push('الدرجة يجب أن تكون: عالٍ أو متوسط أو منخفض');

        const explanation = clean(item.explanation);
        const suggestion = clean(item.suggestion);
        if (explanation.length > PLAYBOOK_LIMITS.maxTextLength || suggestion.length > PLAYBOOK_LIMITS.maxTextLength) {
          problems.push(`الشرح والاقتراح لا يزيدان على ${PLAYBOOK_LIMITS.maxTextLength} حرفاً`);
        }
        if (item.enabled !== undefined && typeof item.enabled !== 'boolean') problems.push('enabled يجب أن تكون true أو false');

        let id = typeof item.id === 'string' ? item.id : '';
        if (id && (!ID_RE.test(id) || known.has(id) || taken.has(id))) {
          problems.push('معرّف غير صالح أو مكرر');
          id = '';
        }

        if (problems.length > 0) {
          for (const p of problems) fail(`${label}: ${p}`);
          continue;
        }
        if (!id) id = newId(taken);
        taken.add(id);
        custom.push({
          id,
          kind: kind as CustomRuleKind,
          title,
          phrases,
          families,
          severity: sev as FindingSeverity,
          explanation,
          suggestion,
          enabled: item.enabled !== false,
        });
      }
    }
  }

  if (strict && errors.length > 0) return { ok: false, errors };
  return { ok: true, config: { disabledRules: disabled, severityOverrides: overrides, customRules: custom } };
}

/** القاعدة الخاصة كقاعدة مكتب قابلة للتقييم. معرّفها يبدأ بـ custom_ كى لا يتصادم مع القواعد الافتراضية. */
export function customRuleToOfficeRule(c: CustomRuleConfig): OfficeRule {
  const needles = c.phrases.map((p) => norm(p)).filter((p) => p.length >= PLAYBOOK_LIMITS.minPhraseLength);
  const base = {
    id: `custom_${c.id}`,
    families: c.families,
    enabled: c.enabled && needles.length > 0,
    severity: c.severity,
    title: c.title,
    provenance: 'قاعدة خاصة أضافها المكتب.',
  };
  if (c.kind === 'forbidden_phrase') {
    return {
      ...base,
      explanation: c.explanation || 'قاعدة المكتب: وردت فى العقد عبارة لا يرغب المكتب فى ورودها فى عقوده؛ تُراجع الجملة المقتبسة.',
      suggestion: c.suggestion || 'تُراجع الجملة المقتبسة وتُعدَّل أو تُحذف بما يوافق ممارسة المكتب.',
      evaluate: (clauses) => firstPerClause(clauses, (n) => needles.some((p) => n.includes(p))),
    };
  }
  return {
    ...base,
    absence: true,
    explanation: c.explanation || 'قاعدة المكتب: يشترط المكتب ورود نص معين فى عقوده، ولم تُرصد فى النص المرفوع أى من العبارات المطلوبة.',
    suggestion: c.suggestion || 'يُضاف نص يفى بما يشترطه المكتب.',
    evaluate: (clauses) => {
      if (clauses.length === 0) return [];
      const present = clauses.some((cl) => {
        const n = norm(`${cl.clauseTitle ?? ''} ${cl.clauseText}`);
        return needles.some((p) => n.includes(p));
      });
      // موضع «سياق» بلا جملة: تُصدر ملاحظة الغياب بلا اقتباس (المطلوب غير موجود أصلاً)
      return present ? [] : [{ clause: clauses[0], sentence: '' }];
    },
  };
}

/** الملف الشخصى الفعلى للمكتب = الافتراضى + تعطيل وتغيير درجات + قواعد خاصة. لا يغيّر الملف الافتراضى المشترك. */
export function buildOfficeProfile(config: OfficePlaybookConfig, meta: { id: string; version: number }): OfficeProfile {
  const disabled = new Set(config.disabledRules);
  const rules: OfficeRule[] = DEFAULT_OFFICE_PROFILE.rules.map((r) => ({
    ...r,
    enabled: r.enabled && !disabled.has(r.id),
    severity: config.severityOverrides[r.id] ?? r.severity,
  }));
  for (const c of config.customRules) rules.push(customRuleToOfficeRule(c));
  return { id: meta.id, name: 'Playbook المكتب', version: meta.version, rules };
}

export function isCustomized(config: OfficePlaybookConfig): boolean {
  return config.disabledRules.length > 0 || Object.keys(config.severityOverrides).length > 0 || config.customRules.length > 0;
}
