/**
 * الاستيضاح (المرحلة 2 — 2026-10-08): منطق نقى (بلا I/O) لطبقة الأسئلة الاستيضاحية.
 *
 * الفكرة: حين يكون السؤال مبهماً أو مركباً أو ناقص الوقائع بحيث يتغير الحكم القانونى
 * جوهرياً بحسب واقعة غير مذكورة، تسأل المنصة السائل (اختيارات + «أخرى» بصياغته +
 * «لا أعرف») بدل التخمين، ثم تجيب بدقة على أساس إجاباته من قاعدة النصوص الموثقة.
 *
 * التصميم عديم الحالة (stateless): العميل يحمل السؤال الأصلى والإجابات المتراكمة ويعيدها فى
 * كل طلب (`clarification`)، فلا جدول جديد ولا جلسة على الخادم. هذا الملف يحوى:
 *  - تطبيع/تقليم مدخلات العميل (لا نثق بحجم ولا بنوع ما يأتينا).
 *  - التحقق من مخرجات النموذج الكاشف (الخادم هو الحَكَم، لا النموذج): عدد الأسئلة والخيارات،
 *    إسقاط ما يطلب بيانات شخصية، إسقاط المكرر وما سبق سؤاله.
 *  - بناء السؤال المُثرى للتوليد (وقائع السائل بوسم صريح) واستعلام الاسترجاع المضغوط.
 */
import { contentStems, normalizeForQuote } from './answer-grounding';

/** وسم قسم الوقائع فى السؤال المُثرى — تعتمد عليه تعليمات التوليد وبوابة المقادير. */
export const CLARIFICATION_FACTS_MARKER = '[توضيحات السائل]';

export const MAX_QUESTIONS_PER_ROUND = 4;
export const DEFAULT_MAX_ROUNDS = 2;
export const HARD_MAX_ROUNDS = 4;
export const MIN_OPTIONS = 2;
export const MAX_OPTIONS = 6;
export const MAX_HISTORY_ANSWERS = 12;
export const MAX_QUESTION_CHARS = 220;
export const MAX_OPTION_CHARS = 120;
export const MAX_WHY_CHARS = 180;
export const MAX_ANSWER_CHARS = 400;
export const MAX_RETRIEVAL_EXTRA_CHARS = 500;

export type ClarificationAnswerKind = 'option' | 'custom' | 'unknown';

export interface ClarificationAnswer {
  question: string;
  /** نص الإجابة (فارغ عند kind='unknown'). */
  answer: string;
  kind: ClarificationAnswerKind;
}

export interface ClarificationInput {
  /** عدد جولات الاستيضاح التى أُجيبت فعلاً (0 = الطلب الأول). */
  round: number;
  /** السائل اختار «تخطَّ وأجبنى مباشرة». */
  skip: boolean;
  answers: ClarificationAnswer[];
}

export interface ClarificationQuestion {
  id: string;
  question: string;
  why: string | null;
  options: string[];
  allow_multiple: boolean;
}

export interface ClarificationDetection {
  questions: ClarificationQuestion[];
  reason: string | null;
  dropped: string[];
}

/** مفتاح التفعيل: الافتراضى مفعَّل، والإيقاف الصريح بـCLARIFICATION_ENABLED=false. */
export function clarificationEnabled(env: NodeJS.ProcessEnv = process.env): boolean {
  return env.CLARIFICATION_ENABLED !== 'false';
}

export function clarificationMaxRounds(env: NodeJS.ProcessEnv = process.env): number {
  const n = Number.parseInt(env.CLARIFICATION_MAX_ROUNDS ?? '', 10);
  if (!Number.isFinite(n)) return DEFAULT_MAX_ROUNDS;
  return Math.min(Math.max(n, 0), HARD_MAX_ROUNDS);
}

function oneLine(value: unknown, max: number): string {
  if (typeof value !== 'string') return '';
  const s = value.replace(/[\u0000-\u001f\u007f]+/g, ' ').replace(/\s+/g, ' ').trim();
  return s.length > max ? `${s.slice(0, max).trim()}…` : s;
}

/** تطبيع مدخل العميل: تقليم الأحجام، حذف الفارغ/غير الصالح، ضبط الجولة. لا يرمى استثناء أبداً. */
export function normalizeClarificationInput(raw: unknown, maxRounds: number): ClarificationInput {
  const empty: ClarificationInput = { round: 0, skip: false, answers: [] };
  if (!raw || typeof raw !== 'object') return empty;
  const r = raw as Record<string, unknown>;
  const answers: ClarificationAnswer[] = [];
  for (const a of Array.isArray(r.answers) ? r.answers : []) {
    if (!a || typeof a !== 'object') continue;
    const o = a as Record<string, unknown>;
    const question = oneLine(o.question, MAX_QUESTION_CHARS);
    if (question.length < 3) continue;
    const kind: ClarificationAnswerKind =
      o.kind === 'unknown' || o.kind === 'custom' ? o.kind : 'option';
    const answer = kind === 'unknown' ? '' : oneLine(o.answer, MAX_ANSWER_CHARS);
    if (kind !== 'unknown' && answer.length === 0) continue;
    answers.push({ question, answer, kind });
    if (answers.length >= MAX_HISTORY_ANSWERS) break;
  }
  const roundNum = Number(r.round);
  const round = Number.isInteger(roundNum) ? Math.min(Math.max(roundNum, 0), Math.max(maxRounds, 0)) : 0;
  return { round, skip: r.skip === true, answers };
}

// ---------------------------------------------------------------------------
// وقائع السائل -> السؤال المُثرى واستعلام الاسترجاع
// ---------------------------------------------------------------------------

const NUMERIC_ONLY = /^[\d\u0660-\u0669]+(?:[.,\u066b]\d+)?$/;

/** وحدة الزمن المذكورة فى نص السؤال (لرقم كتبه السائل بلا وحدة) أو null. */
function unitFromQuestion(question: string): string | null {
  const q = normalizeForQuote(question);
  if (/(?:^| )(?:سنه|سنوات|سنين|عاما?|اعوام|سنه)(?: |$)|بالسنوات|بالاعوام/.test(q)) return 'سنوات';
  if (/(?:^| )(?:شهرا?|اشهر|شهور)(?: |$)|بالاشهر|بالشهور/.test(q)) return 'أشهر';
  if (/(?:^| )(?:يوما?|ايام)(?: |$)|بالايام/.test(q)) return 'أيام';
  return null;
}

/**
 * رقم كتبه السائل بلا وحدة (مثل «12» جواباً عن «ما إجمالى مدة الخدمة؟») يُكمَّل بوحدة السؤال إن وُجدت
 * (تقييم حى 5/10: «12» فُسِّر خطأً فاستُنتج أن الخدمة أقل من خمس سنوات)، وإلا يُوسَم صراحةً أنه بلا وحدة.
 */
function annotateBareNumber(question: string, answer: string): string {
  const a = answer.trim();
  if (!NUMERIC_ONLY.test(a)) return answer;
  const unit = unitFromQuestion(question);
  return unit ? `${a} ${unit}` : `${a} (رقم بلا وحدة — فسّره بحسب سياق السؤال)`;
}

function factLine(a: ClarificationAnswer): string {
  const reply =
    a.kind === 'unknown'
      ? 'لا يعرف (غطِّ الاحتمالات المختلفة فى السيناريوهات)'
      : a.kind === 'custom'
        ? `${annotateBareNumber(a.question, a.answer)} (بصياغة السائل)`
        : annotateBareNumber(a.question, a.answer);
  return `- ${a.question} ← ${reply}`;
}

/** السؤال الذى يدخل التوليد: الأصل + قسم وقائع موسوم. بلا إجابات = السؤال كما هو. */
export function buildEnrichedQuestion(original: string, answers: readonly ClarificationAnswer[]): string {
  if (answers.length === 0) return original;
  return `${original}\n\n${CLARIFICATION_FACTS_MARKER}\n${answers.map(factLine).join('\n')}`;
}

export interface ParsedFact {
  question: string;
  answer: string;
  /** أجاب السائل «لا أعرف» — الواقعة غير معلومة (يجوز أن يُطلب تأكيدها). */
  unknown: boolean;
}

const FACT_SEP = ' ← ';

/** يفكّك قسم الوقائع (سطر لكل «سؤال ← جواب») إلى بنود. سطر بلا فاصل يُتجاهل. */
export function parseClarificationFacts(factsText: string): ParsedFact[] {
  const out: ParsedFact[] = [];
  for (const raw of factsText.split('\n')) {
    const line = raw.replace(/^\s*-\s*/, '').trim();
    const i = line.indexOf(FACT_SEP);
    if (i < 0) continue;
    const question = line.slice(0, i).trim();
    const answer = line.slice(i + FACT_SEP.length).trim();
    if (!question || !answer) continue;
    out.push({ question, answer, unknown: answer.startsWith('لا يعرف') });
  }
  return out;
}

/** إجابات السائل وحدها (دون صياغة الأسئلة) مجمَّعة فى نص: مرجع «الوقائع» لبوابة المقادير. */
export function extractClarificationAnswers(question: string): string {
  return parseClarificationFacts(extractClarificationFacts(question))
    .filter((f) => !f.unknown)
    .map((f) => f.answer)
    .join(' ؛ ');
}

/**
 * هل واقعة يطلب النموذج تأكيدها (facts_to_confirm) سبق أن أجاب عنها السائل؟ (تقييم حى 5/10: عادت الإجابة
 * تسأل عن طبيعة العمل وكتابة الإخطار وقد أجاب السائل عنهما.) تقاطع جذور الكلمات المضمونية ≥ 0.6 من الأصغر
 * (وكلمتان على الأقل). «لا أعرف» لا تُعد جواباً فيجوز طلب تأكيدها.
 */
export function isAlreadyAnsweredFact(item: string, facts: readonly ParsedFact[]): boolean {
  const mine = new Set(contentStems(item));
  if (mine.size === 0) return false;
  for (const f of facts) {
    if (f.unknown) continue;
    const theirs = new Set(contentStems(f.question));
    if (theirs.size === 0) continue;
    let inter = 0;
    for (const x of mine) if (theirs.has(x)) inter++;
    if (inter >= 2 && inter / Math.min(mine.size, theirs.size) >= 0.6) return true;
  }
  return false;
}

/** نص قسم الوقائع من سؤال مُثرى ('' إن لم يوجد) — يُستعمل لقبول مقادير السائل فى بوابة التأصيل. */
export function extractClarificationFacts(question: string): string {
  const i = question.indexOf(CLARIFICATION_FACTS_MARKER);
  return i < 0 ? '' : question.slice(i + CLARIFICATION_FACTS_MARKER.length).trim();
}

/**
 * استعلام الاسترجاع: السؤال الأصلى + إجابات السائل الفعلية فقط (الاختيارات والنص الحر)، مضغوطاً.
 * أسئلة الاستيضاح نفسها لا تدخل (تلوث التشابه الدلالى)، و«لا أعرف» لا تضيف شيئاً.
 */
export function buildRetrievalQuery(original: string, answers: readonly ClarificationAnswer[]): string {
  const extras: string[] = [];
  let used = 0;
  for (const a of answers) {
    if (a.kind === 'unknown' || !a.answer) continue;
    const piece = a.answer.length > 100 ? a.answer.slice(0, 100) : a.answer;
    if (used + piece.length > MAX_RETRIEVAL_EXTRA_CHARS) break;
    extras.push(piece);
    used += piece.length + 1;
  }
  return extras.length === 0 ? original : `${original} ${extras.join(' ')}`;
}

// ---------------------------------------------------------------------------
// التحقق من مخرجات الكاشف
// ---------------------------------------------------------------------------

const GENERIC_OPTIONS = new Set(
  ['اخرى', 'غير ذلك', 'لا اعرف', 'لا ادري', 'غير متاكد', 'غير متأكد', 'لا اعلم', 'اخري', 'غيرها', 'غير ذالك'].map(
    (s) => normalizeForQuote(s),
  ),
);

/** أسئلة تطلب بيانات تعريفية/شخصية: تُسقَط دائماً (لا حاجة لها قانونياً ولا نريد جمعها). */
const PERSONAL_DATA_ASK =
  /(?<![ء-ي])(?:اسم(?:ك|ه|ها)?|الاسم|رقم\s*(?:هاتف|الهاتف|الموبايل|المحمول|الجوال|قومي|القومي|البطاقه|الجواز|حساب|الحساب)|الرقم\s*القومي|بريد|ايميل|عنوان|كلمه\s*(?:السر|المرور)|تاريخ\s*ميلاد)(?:ك|ه|ها|ي|نا)?(?![ء-ي])/;

function norm(s: string): string {
  return normalizeForQuote(s);
}

function similarQuestion(a: string, b: string): boolean {
  if (norm(a) === norm(b)) return true;
  const sa = new Set(contentStems(a));
  const sb = new Set(contentStems(b));
  if (sa.size === 0 || sb.size === 0) return false;
  let inter = 0;
  for (const s of sa) if (sb.has(s)) inter++;
  return inter / Math.min(sa.size, sb.size) >= 0.8 && inter >= 2;
}

/**
 * يُحوِّل ناتج الكاشف الخام إلى أسئلة صالحة. الخادم هو الحَكَم: لا يمرّ سؤال بلا خيارين على الأقل،
 * ولا سؤال يطلب بيانات شخصية، ولا مكرر ولا سبق سؤاله/الإجابة عنه. فارغ = لا استيضاح (الإجابة المباشرة).
 */
export function parseClarificationDetection(
  raw: unknown,
  history: readonly ClarificationAnswer[],
  maxQuestions: number = MAX_QUESTIONS_PER_ROUND,
): ClarificationDetection {
  const dropped: string[] = [];
  const out: ClarificationQuestion[] = [];
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) {
    return { questions: [], reason: null, dropped: ['بنية غير صالحة'] };
  }
  const obj = raw as Record<string, unknown>;
  const reason = oneLine(obj.reason, 240) || null;
  if (obj.needs_clarification === false) {
    return { questions: [], reason, dropped };
  }
  for (const q of Array.isArray(obj.questions) ? obj.questions : []) {
    if (out.length >= Math.max(maxQuestions, 0)) break;
    if (!q || typeof q !== 'object') continue;
    const o = q as Record<string, unknown>;
    const question = oneLine(o.question, MAX_QUESTION_CHARS);
    if (question.length < 5) continue;
    if (PERSONAL_DATA_ASK.test(norm(question))) {
      dropped.push(`بيانات شخصية: ${question.slice(0, 40)}`);
      continue;
    }
    if (history.some((h) => similarQuestion(h.question, question)) || out.some((p) => similarQuestion(p.question, question))) {
      dropped.push(`مكرر: ${question.slice(0, 40)}`);
      continue;
    }
    const seen = new Set<string>();
    const options: string[] = [];
    for (const opt of Array.isArray(o.options) ? o.options : []) {
      const text = oneLine(opt, MAX_OPTION_CHARS);
      const key = norm(text);
      if (text.length < 2 || GENERIC_OPTIONS.has(key) || seen.has(key)) continue;
      seen.add(key);
      options.push(text);
      if (options.length >= MAX_OPTIONS) break;
    }
    if (options.length < MIN_OPTIONS) {
      dropped.push(`خيارات غير كافية: ${question.slice(0, 40)}`);
      continue;
    }
    out.push({
      id: `q${out.length + 1}`,
      question,
      why: oneLine(o.why, MAX_WHY_CHARS) || null,
      options,
      allow_multiple: o.allow_multiple === true,
    });
  }
  return { questions: out, reason, dropped };
}
