import { matchesLoose, normalizeArabicForMatch } from './reasoning.util';

/**
 * وقائع البند المستخرجة بالنموذج، بمخطط مغلق: كل واقعة قيمها من قائمة ثابتة وتحمل اقتباساً حرفياً من نص البند يتحقق الكود
 * من وجوده فيه (بعد التوحيد). الواقعة التى يفشل أى تحقق فيها تسقط كلها (fail-closed): فلا تُطبَّق عليها قاعدة، ويرجع البند
 * إلى التقييم الآلى العادى. النموذج هنا يقرأ ويستخرج فقط؛ الحكم القانونى فى clause-rules.ts بقواعد حتمية.
 */

/** unknown: البند يسمّى الطرف باسم أو وصف لا يمكن ربطه بالطرف الأول/الثانى بيقين؛ لا تُبنى عليه درجة خطورة. */
export type PartyRef = 'first' | 'second' | 'both' | 'none' | 'unknown';

export interface TerminationFact {
  mechanism: 'automatic_without_court' | 'unilateral_right' | 'court_required';
  holder: PartyRef;
  quote: string;
}
export interface NoticeFact {
  state: 'waived_explicitly' | 'required' | 'not_addressed';
  /** مطلوب إلا فى not_addressed */
  quote: string;
}
export interface LiabilityFact {
  kind: 'exclusion' | 'cap' | 'none';
  grossFault: 'reserved' | 'covered' | 'unspecified';
  beneficiary: PartyRef;
  quote: string;
}
export interface ForceMajeureFact {
  extraCauses: 'open_ended' | 'legal_only' | 'listed';
  counterpartyCanReject: boolean;
  noticeRequired: boolean;
  beneficiary: PartyRef;
  quote: string;
}
export interface CompensationFact {
  method: 'fixed_amount' | 'percentage' | 'court_assessed' | 'party_discretion' | 'unspecified';
  waivesProofOfDamage: boolean;
  hasCap: boolean;
  payer: PartyRef;
  quote: string;
}

export interface ClauseFacts {
  termination?: TerminationFact;
  notice?: NoticeFact;
  liability?: LiabilityFact;
  forceMajeure?: ForceMajeureFact;
  compensation?: CompensationFact;
}

const PARTIES: readonly PartyRef[] = ['first', 'second', 'both', 'none', 'unknown'];
const MIN_QUOTE = 6;
const MAX_QUOTE = 400;

/** هل الاقتباس موجود حرفياً (بعد التوحيد العربى) فى نص البند؟ */
export function quoteInText(quote: unknown, clauseText: string): boolean {
  if (typeof quote !== 'string') return false;
  const q = normalizeArabicForMatch(quote);
  if (q.length < MIN_QUOTE || quote.length > MAX_QUOTE) return false;
  return normalizeArabicForMatch(clauseText).includes(q);
}

/**
 * بوابة دلالية على اقتباس «الإعفاء من المسئولية» (الجولة 64). من الإنتاج (عقد السمسرة 0178، البند 8): استخرج النموذج واقعة
 * «إعفاء» من بند يحمّل الوسيط وحده المسئولية عن تابعيه («بحيث يكون مسئولاً وحده عنهم أمام الطرف الأول أو الغير»)، فخرجت ملاحظة
 * عالية بأن البند «يعفى من المسئولية» بينما هو يوزّع المسئولية على الوسيط ولا يعفيه، وهو فى صالح العميل. توزيع المسئولية أو تحميلها
 * ليس إعفاءً ولا تحديداً لها فلا ينطبق عليه حكم المادة 217(2). فلا تُقبل واقعة exclusion/cap إلا إن حمل اقتباسها ذاته لفظ إعفاء أو نفى
 * مسئولية أو حد أقصى؛ وإلا سقطت (fail-closed) ورجع البند إلى التقييم العادى.
 */
const LIABILITY_REDUCTION_CUE = new RegExp(
  [
    '(?:^| )(?:يعفي|تعفي|يعفيان|يعفون|اعفاء|معفي|معفاه|معفيه|معفون|اعفاءه|ابراء|يبرا|تبرا|بري[ءئ]|بريئه|اخلاء)(?: |$)',
    '(?:^| )[وف]?لا (?:[ء-ي]+ ){0,4}?(?:مس[ؤئ]ول|يسال|تسال|يسالان|يتحمل|تتحمل|يلتزم|تلتزم|يضمن|تضمن|تقع|يقع|تترتب|يترتب|يكون ملتزم|تكون ملتزم)',
    '(?:^| )غير (?:مس[ؤئ]ول|ملتزم|متحمل|ضامن)',
    '(?:^| )(?:دون|بدون|عدم) (?:[ء-ي]+ ){0,2}?(?:مس[ؤئ]ول|تحمل|التزام|ضمان)',
    '(?:^| )(?:حد|الحد) (?:ا|ال)?اقصي',
    '(?:^| )(?:بحد|سقف|الحد الاعلي)(?: |$)',
    '(?:^| )[وف]?(?:لا|الا) (?:[ء-ي]+ ){0,2}?(?:يزيد|تزيد|يتجاوز|تتجاوز|يجاوز|تجاوز|يتعدي|تتعدي|يزيدان)',
    '(?:^| )بما لا يزيد',
    '(?:^| )(?:في حدود|فقط في حدود|يقتصر|تقتصر|مقصور)',
    '(?:^| )(?:يتنازل|تتنازل|تنازل)(?: [ء-ي]+){0,3} عن (?:[ء-ي]+ ){0,2}?(?:مس[ؤئ]ول|مطالب|تعويض)',
  ].join('|'),
  'u',
);

export function quoteReducesLiability(quote: string): boolean {
  return matchesLoose(LIABILITY_REDUCTION_CUE, normalizeArabicForMatch(quote));
}

function oneOf<T extends string>(value: unknown, allowed: readonly T[]): T | null {
  return typeof value === 'string' && (allowed as readonly string[]).includes(value) ? (value as T) : null;
}

function obj(v: unknown): Record<string, unknown> | null {
  return v && typeof v === 'object' && !Array.isArray(v) ? (v as Record<string, unknown>) : null;
}

/**
 * يتحقق من رد النموذج ويُرجع الوقائع السليمة فقط. أى قسم ناقص القيم أو بقيمة خارج المخطط أو باقتباس غير موجود فى البند
 * يُحذف كله. لا يُصلح ولا يخمّن شيئاً.
 */
export function validateClauseFacts(raw: unknown, clauseText: string): ClauseFacts {
  const root = obj(raw);
  const out: ClauseFacts = {};
  if (!root) return out;

  const t = obj(root.termination);
  if (t) {
    const mechanism = oneOf(t.mechanism, ['automatic_without_court', 'unilateral_right', 'court_required'] as const);
    const holder = oneOf(t.holder, PARTIES);
    if (mechanism && holder && quoteInText(t.quote, clauseText)) {
      out.termination = { mechanism, holder, quote: String(t.quote).trim() };
    }
  }

  const n = obj(root.notice);
  if (n) {
    const state = oneOf(n.state, ['waived_explicitly', 'required', 'not_addressed'] as const);
    if (state === 'not_addressed') out.notice = { state, quote: '' };
    else if (state && quoteInText(n.quote, clauseText)) out.notice = { state, quote: String(n.quote).trim() };
  }

  const l = obj(root.liability);
  if (l) {
    const kind = oneOf(l.kind, ['exclusion', 'cap', 'none'] as const);
    const grossFault = oneOf(l.gross_fault, ['reserved', 'covered', 'unspecified'] as const);
    const beneficiary = oneOf(l.beneficiary, PARTIES);
    if (kind && grossFault && beneficiary && quoteInText(l.quote, clauseText) && (kind === 'none' || quoteReducesLiability(String(l.quote)))) {
      out.liability = { kind, grossFault, beneficiary, quote: String(l.quote).trim() };
    }
  }

  const f = obj(root.force_majeure);
  if (f) {
    const extraCauses = oneOf(f.extra_causes, ['open_ended', 'legal_only', 'listed'] as const);
    const beneficiary = oneOf(f.beneficiary, PARTIES);
    if (
      extraCauses &&
      beneficiary &&
      typeof f.counterparty_can_reject === 'boolean' &&
      typeof f.notice_required === 'boolean' &&
      quoteInText(f.quote, clauseText)
    ) {
      out.forceMajeure = {
        extraCauses,
        counterpartyCanReject: f.counterparty_can_reject,
        noticeRequired: f.notice_required,
        beneficiary,
        quote: String(f.quote).trim(),
      };
    }
  }

  const c = obj(root.compensation);
  if (c) {
    const method = oneOf(c.method, ['fixed_amount', 'percentage', 'court_assessed', 'party_discretion', 'unspecified'] as const);
    const payer = oneOf(c.payer, PARTIES);
    if (
      method &&
      payer &&
      typeof c.waives_proof_of_damage === 'boolean' &&
      typeof c.has_cap === 'boolean' &&
      quoteInText(c.quote, clauseText)
    ) {
      out.compensation = {
        method,
        waivesProofOfDamage: c.waives_proof_of_damage,
        hasCap: c.has_cap,
        payer,
        quote: String(c.quote).trim(),
      };
    }
  }
  return out;
}

export function hasAnyFact(f: ClauseFacts): boolean {
  return Boolean(f.termination || f.notice || f.liability || f.forceMajeure || f.compensation);
}

/**
 * بند لا يمكن ربط اتجاهه بطرف (يسمّى الطرف باسم لم تُعرف نسبته إلى الأول/الثانى): كل قيمة «first/second» فى حقول الاتجاه تصير unknown
 * فلا تُبنى عليها درجة خطورة ولا نص يتهم طرفاً بعينه. فشل مغلق: خطأ اتجاه أخطر على المحامى من فقدان درجة.
 */
export function neutralizeDirections(facts: ClauseFacts): ClauseFacts {
  const flip = (p: PartyRef): PartyRef => (p === 'first' || p === 'second' ? 'unknown' : p);
  const out: ClauseFacts = { ...facts };
  if (facts.termination) out.termination = { ...facts.termination, holder: flip(facts.termination.holder) };
  if (facts.liability) out.liability = { ...facts.liability, beneficiary: flip(facts.liability.beneficiary) };
  if (facts.forceMajeure) out.forceMajeure = { ...facts.forceMajeure, beneficiary: flip(facts.forceMajeure.beneficiary) };
  if (facts.compensation) out.compensation = { ...facts.compensation, payer: flip(facts.compensation.payer) };
  return out;
}
