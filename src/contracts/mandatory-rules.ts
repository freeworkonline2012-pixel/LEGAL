import { clipQuote, sentencesOf } from './contract-level';
import { norm as normBase } from './playbook-util';

/** التوحيد للمطابقة مع إبقاء علامة % كلمة (pct) والكسر العشرى (7.5 ⇒ 7dot5)، فالتوحيد العادى يمحو الرموز غير الحرفية */
const norm = (t: string): string => normBase(t.replace(/(\d)[.,٫](\d)/g, '$1dot$2').replace(/[%٪]/g, ' pct '));

/**
 * قواعد المواد الآمرة الحتمية (الجولة 90). دفعة اصطناعية من 12 عقداً (مقاولة/توريد/تمويل/إيجار) أظهرت أن المدقق المستقل يدحض ملاحظات صحيحة على نصوص آمرة صريحة:
 *  - التنازل عن الضمان العشرى فى المقاولة دُحض (والمادة الباطلة له 653 لا 651)،
 *  - فائدة 36% شهرياً دُحضت باقتباس نصف المادة 227/1 («يجوز للمتعاقدين أن يتفقا على سعر آخر») وإغفال نصفها الثانى («وجب تخفيضها» إلى 7%)،
 *  - فائدة على الفائدة دُحضت بالمادة 64 تجارى مع أن 232 مدنى تمنعها «دون إخلال بالقواعد والعادات التجارية» وهذه عبارة لا تُسقط السقف.
 * هذه المخالفات لا تتوقف على فهم نموذج لغوى: عبارة حاسمة فى نص البند تقابلها مادة بنصها. فتُكتشف هنا بقواعد نصية ضيقة وتُوثَّق باقتباس حرفى من البند،
 * وتُطبَّق بعد المدقق فلا يُسقطها (راجع ContractsService.applyMandatoryRules). نصوص المواد المذكورة محقَّقة حرفياً من migrations/074.
 * ملف نقى بلا اعتماد على Nest أو قاعدة البيانات.
 *
 * فاشل الأمان: كل قاعدة تشترط عبارة صريحة فى الجملة نفسها (لا استنتاج من سياق بعيد)، وأى التباس ⇒ لا ملاحظة (يبقى تقدير النموذج والمدقق كما هو).
 */

export type MandatorySeverity = 'حرج' | 'عالٍ';

export interface MandatoryHit {
  ruleId: 'decennial_waiver' | 'decennial_limit' | 'interest_cap' | 'interest_compounding' | 'interest_hidden_commission' | 'penalty_no_reduction' | 'penalty_compounding' | 'liability_fraud_waiver';
  severity: MandatorySeverity;
  /** مواد القانون المدنى التى تقوم عليها المخالفة */
  articles: number[];
  /** اقتباس حرفى من البند (الجملة التى حملت العبارة الحاسمة) */
  quote: string;
  explanation: string;
  /** القراءة الآلية للنسبة تالفة وأُصلحت استنتاجاً («9636» ⇒ 36%): الملاحظة تبقى مرشحة لا مؤكدة */
  uncertainReading: boolean;
}

/** نصوص المواد حرفياً من migrations/074 (القانون المدنى 131/1948) كما تُخزَّن فى matched_articles */
export const MANDATORY_ARTICLE_TEXT: Readonly<Record<number, string>> = {
  217: '(1) يجوز الاتفاق على أن يتحمل المدين تبعة الحادث المفاجئ والقوة القاهرة. (2) وكذلك يجوز الاتفاق على إعفاء المدين من أية مسئولية تترتب على عدم تنفيذ التزامه التعاقدى إلا ما ينشأ عن غشه أو عن خطئه الجسيم، ومع ذلك يجوز للمدين أن يشترط عدم مسئوليته عن الغش أو الخطأ الجسيم الذى يقع من أشخاص يستخدمهم فى تنفيذ التزامه. (3) ويقع باطلا كل شرط يقضى بالإعفاء من المسئولية المترتبة على العمل غير المشروع.',
  224: '(1) لا يكون التعويض الاتفاقى مستحقا إذا أثبت المدين أن الدائن لم يلحقه أى ضرر. (2) ويجوز للقاضى أن يخفض هذا التعويض إذا أثبت المدين أن التقدير كان مبالغا فيه إلى درجة كبيرة، أو أن الالتزام الأصلى قد نفذ فى جزء منه. (3) ويقع باطلا كل اتفاق يخالف أحكام الفقرتين السابقتين.',
  227: '(1) يجوز للمتعاقدين أن يتفقا على سعر آخر للفوائد سواء أكان ذلك فى مقابل تأخير الوفاء أم فى أية حالة أخرى، فإذا اتفقا على فوائد تزيد على سبعة فى المائة وجب تخفيضها إلى هذا القدر. (2) وكل عمولة أو منفعة، أيا كان نوعها، اشترطها الدائن إذا زادت والفائدة المتفق عليه على الحد الأقصى تعتبر مستترة فائدة ربوية وتكون قابلة للتخفيض، إذا ما أثبت أن هذه العمولة أو المنفعة لا تقابلها خدمة حقيقية يكون الدائن قد أداها ولا منفعة مشروعة.',
  232: 'لا يجوز تقاضى فوائد على متجمد الفوائد، ولا يجوز فى أية حال أن يكون مجموع ما يتقاضاه الدائن أكثر من رأس المال وذلك كله دون إخلال بالقواعد والعادات التجارية.',
  651: '(1) يضمن المهندس المعمارى والمقاول متضامنين ما يحدث خلال عشر سنوات من تهدم كلى أو جزئى فيما شيدوه من مبان أو أقاموه من منشآت ثابتة أخرى ولو كان هذا التهدم ناشئا عن عيب فى الأرض ذاتها، أو كان رب العمل قد أجاز إقامة المنشآت المعيبة، ما لم يكن المتعاقدان فى هذه الحالة قد أرادا أن تبقى هذه المنشآت مدة أقل من عشر سنوات. (3) وتبدأ مدة السنوات العشر من وقت تسلم العمل ولا تسرى هذه المادة على ما قد يكون للمقاول من حق الرجوع على المقاولين من الباطن.',
  653: 'يكون باطلا كل شرط يقصد به إعفاء المهندس المعمارى والمقاول من الضمان أو الحد منه.',
};

const CIVIL = 'القانون المدنى (131 لسنة 1948)';

export function mandatoryArticleRef(n: number): { law: string; law_no: number; law_year: number; article_no: number; snippet: string; official_url: null } | null {
  const text = MANDATORY_ARTICLE_TEXT[n];
  return text ? { law: CIVIL, law_no: 131, law_year: 1948, article_no: n, snippet: text, official_url: null } : null;
}

// ---------------------------------------------------------------------------------------------------------------------------------
// الضمان العشرى (651/653)
// ---------------------------------------------------------------------------------------------------------------------------------

const DECENNIAL_CONTEXT = /(?:الضمان العشري|ضمان (?:المقاول|المبني|المنشا\w*|المباني)|يضمن المقاول|يضمن المهندس|عشر سنوات|10 سنوات|التهدم|تصدع|سلامه (?:المبني|المنشا\w*|الهيكل|المباني)|عيب\w* (?:انشائي\w*|هيكلي\w*))/;
const WAIVER_CUE = /(?:يتنازل|تنازل|اعفاء|يعفي|اعفي|يخلي|اخلاء|ابراء|يبرئ|يسقط|اسقاط|لا يضمن|لا يسال|لا يكون مسئولا|لا يتحمل|غير مسئول|لا يلتزم|بدون ضمان|دون ضمان|لا ضمان)/;
const WAIVER_OBJECT = /(?:ضمان\w*\s+(?:المقاول\s+)?(?:العشري|المبني|المباني|المنشا\w*)|الضمان العشري|مسئوليه\w*\s+(?:المقاول\s+)?عن\s+(?:اي\s+)?(?:عيب|تصدع|تهدم|خلل)|التهدم|التصدع|العيوب (?:الانشائيه|الهيكليه))/;
const SHORT_YEARS = /(?:ضمان|يضمن|مسئول)\w*[^.\n]{0,60}?(?:لمده\s+)?(\d{1,2}|سنه واحده|سنتين|ثلاث\w*|اربع\w*|خمس\w*|ست\w*|سبع\w*|ثماني\w*|تسع\w*)\s*(?:\(\s*\d+\s*\)\s*)?(?:سنوات|سنين|سنه|سنتين)/;
const STRUCTURAL_CUE = /(?:المبني|المباني|المنشا\w*|الهيكل|تهدم|تصدع|سلامه|انشائي\w*|هيكلي\w*|عشري)/;
const EXCLUSION_CUE = /(?:لا يسري هذا الضمان|لا يسري الضمان|لا يشمل الضمان|يستثني من الضمان|لا يضمن (?:المقاول )?(?:العيوب|ما)|لا يغطي الضمان|يخرج من الضمان)[^.\n]{0,200}?(?:وافق عليها|حددها|اعتمدها|المخططات|التصميمات|تربه|الارض|الموقع|اجازه|اجاز)/;
const LATE_START = /(?:عشر سنوات|10 سنوات|الضمان العشري)[^.\n]{0,60}?من\s+(?:تاريخ\s+)?(?:انجاز|اتمام|الانتهاء من|انتهاء|الفراغ من)\s+(?:الهيكل|الاعمال|التنفيذ|البناء)/;

const YEARS_WORD: Array<[RegExp, number]> = [
  [/^سنه واحده$|^سنتين$/, 0],
  [/^ثلاث/, 3],
  [/^اربع/, 4],
  [/^خمس/, 5],
  [/^ست/, 6],
  [/^سبع/, 7],
  [/^ثماني/, 8],
  [/^تسع/, 9],
];

function yearsOf(token: string): number | null {
  if (/^\d+$/.test(token)) return Number(token);
  if (token === 'سنه واحده') return 1;
  if (token === 'سنتين') return 2;
  for (const [re, n] of YEARS_WORD) if (re.test(token)) return n;
  return null;
}

function decennialHits(sentences: Array<{ raw: string; n: string }>): MandatoryHit[] {
  const out: MandatoryHit[] = [];
  const paragraph = sentences.map((s) => s.n).join(' ');
  if (!DECENNIAL_CONTEXT.test(paragraph)) return out;
  for (const s of sentences) {
    if (!DECENNIAL_CONTEXT.test(s.n) && !WAIVER_OBJECT.test(s.n)) continue;
    // تنازل/إخلاء من الضمان العشرى أو من المسئولية عن التصدع والتهدم بعد التسلم
    if (WAIVER_CUE.test(s.n) && WAIVER_OBJECT.test(s.n)) {
      out.push({
        ruleId: 'decennial_waiver',
        severity: 'حرج',
        articles: [651, 653],
        quote: clipQuote(s.raw),
        explanation:
          'يتضمن البند تنازلاً عن ضمان المقاول والمهندس لسلامة المبانى والمنشآت الثابتة أو إخلاءً من المسئولية عن التصدع والتهدم بعد التسلم؛ والمادة 653 من القانون المدنى تقضى بأن «كل شرط يقصد به إعفاء المهندس المعمارى والمقاول من الضمان أو الحد منه» باطل، ' +
          'والمادة 651 تقرر الضمان عشر سنوات من تسلم العمل. فالتنازل لا أثر له قانوناً ويظل الضمان قائماً؛ وإبقاؤه فى العقد يضلل رب العمل بأنه تنازل عن حق لا يملك التنازل عنه ويفتح نزاعاً.',
        uncertainReading: false,
      });
      continue;
    }
    // نقص مدة الضمان عن عشر سنوات فى المبانى والمنشآت
    const sy = SHORT_YEARS.exec(s.n);
    if (sy && STRUCTURAL_CUE.test(s.n) && !/عشر سنوات|10 سنوات/.test(s.n)) {
      const y = yearsOf(sy[1]);
      if (y !== null && y > 0 && y < 10) {
        out.push({
          ruleId: 'decennial_limit',
          severity: 'عالٍ',
          articles: [651, 653],
          quote: clipQuote(s.raw),
          explanation: `يحدد البند ضمان سلامة المبنى بمدة ${y} سنوات دون العشر المقررة بالمادة 651 من القانون المدنى، والمادة 653 تبطل كل شرط يقصد به «الحد» من هذا الضمان؛ فتظل المدة عشر سنوات من تسلم العمل ويبقى الشرط الأدنى بلا أثر.`,
          uncertainReading: false,
        });
        continue;
      }
    }
    if (EXCLUSION_CUE.test(s.n)) {
      out.push({
        ruleId: 'decennial_limit',
        severity: 'عالٍ',
        articles: [651, 653],
        quote: clipQuote(s.raw),
        explanation:
          'يستثني البند من الضمان عيوباً ناشئة عن مواد وافق عليها رب العمل أو عن المخططات أو عن تربة الموقع؛ والمادة 651/1 تقرر الضمان «ولو كان هذا التهدم ناشئا عن عيب فى الأرض ذاتها، أو كان رب العمل قد أجاز إقامة المنشآت المعيبة» ' +
          '(ما لم يكن المتعاقدان قد أرادا أن تبقى المنشآت أقل من عشر سنوات)، والمادة 653 تبطل كل شرط يقصد به «الحد» من الضمان. فهذا الاستثناء حدٌّ من الضمان لا يُعتد به.',
        uncertainReading: false,
      });
      continue;
    }
    if (LATE_START.test(s.n)) {
      out.push({
        ruleId: 'decennial_limit',
        severity: 'عالٍ',
        articles: [651, 653],
        quote: clipQuote(s.raw),
        explanation:
          'يبدأ البند مدة الضمان العشرى من إنجاز الهيكل أو الأعمال لا من تسلم العمل، والمادة 651/3 تقضى بأن «مدة السنوات العشر» تبدأ «من وقت تسلم العمل»؛ فتبكير البدء يقتطع من مدة الضمان، ' +
          'والمادة 653 تبطل كل شرط يقصد به الحد من الضمان.',
        uncertainReading: false,
      });
    }
  }
  return out;
}

// ---------------------------------------------------------------------------------------------------------------------------------
// الفوائد (227/232)
// ---------------------------------------------------------------------------------------------------------------------------------

const INTEREST_CUE = /(?:فائده|فوائد|عائد تاخيري|عائد التاخير|الفائده|عائدا? (?:بواقع|بنسبه)|العائد (?:الشهري|السنوي))/;
const PERCENT_RE = /(?<![\d/])(\d{1,4}(?:dot\d+)?)\s*(?:pct|بالمائه|بالمئه|في المائه|في المئه)/g;
/** علامة % قرأتها الآلة «90» أو «96» ملتصقة قبل الرقم (25% ⇒ «9625»، 5% ⇒ «905»)؛ لا تُقبل إلا بعد كلمة فائدة بمسافة قصيرة وبلا عملة بعدها. */
const GARBLED_PERCENT_RE = /(?<![\d/a-z])9[06](\d{1,2})(?![\d/]|dot)(?!\s*(?:pct|(?:جنيه|جنيها|ج م|دولار|يورو|يوم|شهر|سنه|سنوات|متر|كجم)(?![ء-ي])))/g;
const MONTHLY = /(?:شهري\w*|في الشهر|كل شهر|لكل شهر|عن كل شهر)/;
const YEARLY = /(?:سنوي\w*|في السنه|كل سنه|لكل سنه|عن كل سنه|عن السنه)/;
const DAILY = /(?:يومي\w*|في اليوم|كل يوم|لكل يوم|عن كل يوم)/;
const WEEKLY = /(?:اسبوعي\w*|في الاسبوع|كل اسبوع|لكل اسبوع|عن كل اسبوع)/;
export const AGREED_INTEREST_CAP = 7;

interface RateRead {
  value: number;
  annual: number;
  period: 'شهرياً' | 'سنوياً' | 'يومياً' | 'أسبوعياً';
  repaired: boolean;
}

/** الفترة تُقرأ من لاحقة النسبة المباشرة («3% شهرياً») ثم من سابقتها («شهرية 3%»)، وإلا سنوية؛ لا من الجملة كلها («أول كل شهر» وصف لموعد لا لدورية الفائدة) */
function periodOf(n: string, from: number, until: number): { factor: number; label: RateRead['period'] } {
  const after = n.slice(from, from + 16);
  const before = n.slice(Math.max(0, until - 22), until);
  for (const text of [after, before]) {
    if (MONTHLY.test(text)) return { factor: 12, label: 'شهرياً' };
    if (DAILY.test(text)) return { factor: 365, label: 'يومياً' };
    if (WEEKLY.test(text)) return { factor: 52, label: 'أسبوعياً' };
    if (YEARLY.test(text)) return { factor: 1, label: 'سنوياً' };
  }
  return { factor: 1, label: 'سنوياً' };
}

/** كلمات تدل على أن النسبة المجاورة لكلمة الفائدة ليست سعرها (مصروفات/عمولة/غرامة/خصم/احتجاز/دفعة…): النسبة عندئذ لشىء آخر فلا تُقاس بسقف 227/1 */
const NOT_A_RATE_BETWEEN = /(?:مصروفات|مصاريف|عموله|رسوم|غرامه|خصم|يخصم|احتجاز|يحتجز|ضمان|تامين|مقدم|دفعه|قسط|اتعاب|جزاء|تعويض|pct)/;

function interestRatesIn(n: string): RateRead[] {
  const out: RateRead[] = [];
  const cues = [...n.matchAll(new RegExp(INTEREST_CUE.source, 'g'))].map((m) => ({ at: m.index ?? 0, end: (m.index ?? 0) + m[0].length }));
  if (cues.length === 0) return out;
  // النسبة سعر فائدة إن اتصلت بكلمة الفائدة قبلها أو بعدها بمسافة قصيرة لا تتخللها كلمة تنفى ذلك
  const bound = (idx: number, end: number): boolean =>
    cues.some((c) => {
      const seg = c.end <= idx ? n.slice(c.end, idx) : c.at >= end ? n.slice(end, c.at) : '';
      // نسبة «من الرصيد/من المبلغ» تتلوها كلمة الفائدة ليست سعراً لها (كأن تُحسب غرامة على المسدَّد معجلاً ثم تُذكر الفوائد بعدها)
      if (c.at >= end && /^\s*من\s/.test(n.slice(end, end + 6))) return false;
      return (c.end <= idx || c.at >= end) && seg.length <= 45 && !NOT_A_RATE_BETWEEN.test(seg);
    });
  for (const m of n.matchAll(PERCENT_RE)) {
    const idx = m.index ?? 0;
    if (!bound(idx, idx + m[0].length)) continue;
    const v = Number.parseFloat(m[1].replace('dot', '.'));
    if (!Number.isFinite(v) || v <= 0 || v > 1000) continue;
    const p = periodOf(n, idx + m[0].length, idx);
    out.push({ value: v, annual: v * p.factor, period: p.label, repaired: false });
  }
  for (const m of n.matchAll(GARBLED_PERCENT_RE)) {
    const idx = m.index ?? 0;
    if (!bound(idx, idx + m[0].length)) continue;
    const v = Number(m[1]);
    if (!Number.isFinite(v) || v <= 0 || v > 100 || out.some((r) => r.value === v)) continue;
    const p = periodOf(n, idx + m[0].length, idx);
    out.push({ value: v, annual: v * p.factor, period: p.label, repaired: true });
  }
  return out;
}

const COMPOUNDING = /(?:(?:اضافه|ضم)\s+(?:ال)?(?:فائده|فوائد|عائد)\w*\s+(?:المستحق\w*\s+)?(?:الي|الى)\s+(?:ال)?(?:رصيد|راس المال|اصل)|فائده\s+(?:على|علي)\s+(?:ال)?فائده|فوائد\s+(?:على|علي)\s+(?:ال)?فوائد|فائده مركبه|فوائد مركبه|متجمد الفوائد|رسمله\s+(?:ال)?فوائد|ترسمل|(?:تضاف|تضم|تحتسب|تدمج|تجمع)\s+(?:ال)?(?:فائده|فوائد)[^.\n]{0,60}?(?:الي|الى|على|علي|مع)\s+(?:راس المال|اصل الدين|اصل المبلغ|المبلغ الاصلي|الدين)|(?:تحسب|يحسب|تسري)\s+(?:ال)?(?:فائده|فوائد)\s+(?:على|علي)\s+(?:اصل الدين|راس المال|المبلغ)\s+(?:و|مضافا اليه|مع)\s*(?:ال)?فوائد|(?:الرصيد|رصيد)[^.\n]{0,60}?(?:بعد|مع)\s+(?:اضافه|ضم)\s+(?:ال)?(?:عائد|فائده|فوائد)[ء-ي]*|(?:بعد|مع)\s+(?:اضافه|ضم)\s+(?:ال)?(?:عائد|فائده|فوائد)[ء-ي]*[^.\n]{0,40}?(?:الي|الى|على|علي|ل)\s*(?:ال)?(?:رصيد|اصل|راس المال)|(?:تتراكم|تتجمع|تتحول)\s+(?:ال)?(?:فائده|فوائد|عائد)[^.\n]{0,40}?(?:جزء[ء-ي]*\s+من\s+)?(?:اصل الدين|راس المال|الدين|اصل المبلغ)|(?:تصبح|تعتبر|تعد)\s+(?:ال)?(?:فائده|فوائد|عائد)\w*[^.\n]{0,30}?جزء[ء-ي]*\s+من\s+(?:اصل الدين|راس المال|الدين|اصل المبلغ))/;

function interestHits(sentences: Array<{ raw: string; n: string }>): MandatoryHit[] {
  const out: MandatoryHit[] = [];
  for (const s of sentences) {
    if (!INTEREST_CUE.test(s.n) && !COMPOUNDING.test(s.n)) continue;
    const rates = interestRatesIn(s.n);
    const over = rates.filter((r) => r.annual > AGREED_INTEREST_CAP);
    if (over.length > 0) {
      const top = over.reduce((a, b) => (b.annual > a.annual ? b : a));
      const repairedNote = top.repaired
        ? ` (تنبيه قراءة: النسبة وردت فى النص الممسوح بصيغة تالفة ثابتة الشكل تُرجَّح أنها ${top.value}% بعد أن قُرئت علامة % رقمين ملتصقين؛ قارنها بالأصل قبل الاعتماد)`
        : '';
      const annualNote = top.period === 'سنوياً' ? '' : ` (تعادل نحو ${Math.round(top.annual)}% سنوياً)`;
      out.push({
        ruleId: 'interest_cap',
        severity: 'عالٍ',
        articles: [227],
        quote: clipQuote(s.raw),
        explanation:
          `يشترط البند فائدة بنسبة ${top.value}% ${top.period}${annualNote}${repairedNote}، والمادة 227/1 من القانون المدنى تجيز الاتفاق على سعر آخر للفوائد لكنها تقضى بأنه «إذا اتفقا على فوائد تزيد على سبعة فى المائة وجب تخفيضها إلى هذا القدر». ` +
          'فيُخفَّض ما زاد على 7% وجوباً، وتُعدّ العمولات والمنافع الإضافية التى لا تقابلها خدمة حقيقية فائدة مستترة تُخفَّض كذلك (227/2). والمادة 64 من القانون التجارى لا تُسقط هذا السقف بل تنظم استحقاق العائد التأخيرى التجارى وحده الأقصى بالنسبة لأصل الدين؛ فتعملان معاً.',
        uncertainReading: top.repaired,
      });
    }
    if (COMPOUNDING.test(s.n) && (INTEREST_CUE.test(s.n) || /ترسمل|رسمله|متجمد|عائد/.test(s.n))) {
      out.push({
        ruleId: 'interest_compounding',
        severity: 'عالٍ',
        articles: [232],
        quote: clipQuote(s.raw),
        explanation:
          'يقضى البند باحتساب فائدة على الفوائد المتجمدة أو بضمها إلى الأصل لتولد فائدة؛ والمادة 232 من القانون المدنى تنص على أنه «لا يجوز تقاضى فوائد على متجمد الفوائد، ولا يجوز فى أية حال أن يكون مجموع ما يتقاضاه الدائن أكثر من رأس المال»، ' +
          'وعبارة «دون إخلال بالقواعد والعادات التجارية» فى ختامها ليست إذناً بفائدة مركبة مطلقة؛ فيُستبعد ما زاد من هذا الأثر وتبقى الفوائد على الأصل وحده وفى حدود 227.',
        uncertainReading: false,
      });
    }
  }
  return out;
}

// ---------------------------------------------------------------------------------------------------------------------------------
// التعويض الاتفاقى (224)
// ---------------------------------------------------------------------------------------------------------------------------------

const PENALTY_CUE = /(?:التعويض (?:الاتفاقي)?|الشرط الجزائي|الغرامه|غرامه (?:التاخير)?|الجزاء)/;
const NO_REDUCTION = new RegExp(
  [
    'يتنازل\\s+(?:المدين|الطرف|المستاجر|المشتري|المقاول|المورد|المقترض|العميل)[^.\\n]{0,60}?(?:عن\\s+)?(?:حقه\\s+)?(?:في\\s+)?(?:طلب\\s+)?(?:تخفيض|تعديل|خفض)',
    'لا\\s+(?:يجوز|يحق)\\s+(?:للمدين|للمستاجر|للمشتري|للمقاول|للمورد|للمقترض|للعميل|له)?[^.\\n]{0,40}?(?:طلب\\s+)?(?:تخفيض|تعديل|خفض|الاعتراض على)\\s+(?:هذا\\s+)?(?:ال)?(?:تعويض|غرامه|شرط جزائي|جزاء|مبلغ)',
    // الجولة 91: «ولا يجوز طلب تخفيضها» (ضمير متصل بدل ذكر الغرامة) و«غير قابلة للتخفيض»
    'لا\\s+(?:يجوز|يحق|يقبل)\\s+(?:للمدين|للمستاجر|للمشتري|للمقاول|للمورد|للمقترض|للعميل|له|للقاضي|للمحكمه)?[^.\\n]{0,30}?(?:طلب\\s+)?(?:تخفيض|تعديل|خفض|تقليل)(?:ها|ه|هذه|هذا)(?![ء-ي])',
    '(?:غير|لا)\\s+قابل\\w*\\s+(?:لل)?(?:تخفيض|تعديل|خفض)',
    'لا\\s+(?:يخفض|تخفض|يعدل|تعدل)(?![ء-ي])[^.\\n]{0,30}?(?:ولو|حتي|مهما|باي)',
    'لا\\s+(?:يخضع|تخضع)\\s+(?:هذه?\\s+)?(?:ال)?(?:غرامه|تعويض|شرط جزائي|مبلغ)[^.\\n]{0,40}?لتقدير\\s+(?:المحكمه|القاضي|القضاء)',
    '(?:مستحق|يستحق|واجب)\\s+(?:الاداء\\s+)?(?:ولو|حتي لو|حتي ولو|ولو لم|دون حاجه الي اثبات|دون اثبات|بغض النظر عن)[^.\\n]{0,40}?(?:ضرر|اضرار)',
    'دون\\s+حاجه\\s+(?:الي|لاثبات)\\s+(?:اثبات\\s+)?(?:وقوع\\s+)?(?:اي\\s+)?ضرر',
  ].join('|'),
);

function penaltyHits(sentences: Array<{ raw: string; n: string }>): MandatoryHit[] {
  const out: MandatoryHit[] = [];
  for (const s of sentences) {
    if (!PENALTY_CUE.test(s.n) || !NO_REDUCTION.test(s.n)) continue;
    out.push({
      ruleId: 'penalty_no_reduction',
      severity: 'عالٍ',
      articles: [224],
      quote: clipQuote(s.raw),
      explanation:
        'يمنع البند المدين من طلب تخفيض التعويض أو الغرامة أو يجعلها مستحقة دون إثبات ضرر؛ والمادة 224 من القانون المدنى تقضى بأنه «لا يكون التعويض الاتفاقى مستحقا إذا أثبت المدين أن الدائن لم يلحقه أى ضرر» وللقاضى خفضه عند المبالغة الكبيرة أو تنفيذ جزء من الالتزام، ' +
        'و«يقع باطلا كل اتفاق يخالف» ذلك (224/3). فالمنع من التخفيض باطل وتبقى سلطة القاضى قائمة.',
      uncertainReading: false,
    });
  }
  return out;
}

// ---------------------------------------------------------------------------------------------------------------------------------
// الجولة 91: الإعفاء من الغش والخطأ الجسيم (217/2)، والعمولة الدورية المقنَّعة فائدة (227/2)، والغرامة على الغرامة (232/224)
// ---------------------------------------------------------------------------------------------------------------------------------

const EXEMPTION_CUE = /(?:يخلي|اخلاء|يعفي|اعفاء|يعفى|لا يسال|لا يكون مسئولا|لا يتحمل|لا يلتزم|لا يضمن|غير مسئول|يتنازل|تنازل|ابراء|يبرئ|استبعاد|يستبعد|لا مسئوليه|عدم مسئوليه|تنتفي مسئوليت|تقتصر مسئوليت)/;
const FRAUD_EXPLICIT = /(?:ولو|حتي لو|حتي ولو|حتي في حاله|حتي مع|وان|ولو كان|ولو كانت|سواء)[^.\n]{0,40}?(?:غش|خط[ء-ي]*\s+جسيم[ء-ي]*|(?:ب)?اهمال[ء-ي]*\s+جسيم[ء-ي]*|(?:ب)?سوء\s+ني[ء-ي]*|تعمد[ء-ي]*|عمد(?![ء-ي]))/;
const FRAUD_BROAD = /(?:مهما كان[ء-ي]*\s+(?:سبب|اسباب)[ء-ي]*|ايا كان[ء-ي]*\s+(?:سبب|اسباب)[ء-ي]*|اي كان[ء-ي]*\s+(?:سبب|اسباب)[ء-ي]*|في جميع الاحوال|باي حال من الاحوال|دون استثناء)/;
const FRAUD_CARVE_OUT = /(?:(?:عدا|ماعدا|باستثناء|عدم الاخلال ب|دون الاخلال ب|الا (?:ما ينشا عن|في حاله|اذا كان|اذا ثبت|عن|في)|ما لم (?:يكن|ينشا|يثبت|يكن ناتجا))[^.\n]{0,60}?(?:غش|خطا[ء-ي]*\s+جسيم|سوء نيه|تعمد))/;
const FORCE_MAJEURE_CONTEXT = /(?:قوه قاهره|ظرف طارئ|حادث مفاجئ|كارثه طبيعيه)/;

function fraudWaiverHits(sentences: Array<{ raw: string; n: string }>): MandatoryHit[] {
  const out: MandatoryHit[] = [];
  for (const s of sentences) {
    if (!EXEMPTION_CUE.test(s.n) || FRAUD_CARVE_OUT.test(s.n)) continue;
    const explicit = FRAUD_EXPLICIT.test(s.n);
    const broad = !explicit && FRAUD_BROAD.test(s.n) && !FORCE_MAJEURE_CONTEXT.test(s.n);
    if (!explicit && !broad) continue;
    out.push({
      ruleId: 'liability_fraud_waiver',
      severity: explicit ? 'حرج' : 'عالٍ',
      articles: [217],
      quote: clipQuote(s.raw),
      explanation:
        (explicit
          ? 'يعفى البند أحد الطرفين من المسئولية صراحة ولو نشأت عن غشه أو خطئه الجسيم أو سوء نيته؛ '
          : 'يعفى البند أحد الطرفين من المسئولية «أياً كان السبب» دون أن يستثنى الغش والخطأ الجسيم؛ ') +
        'والمادة 217/2 من القانون المدنى تجيز الاتفاق على الإعفاء من المسئولية التعاقدية «إلا ما ينشأ عن غشه أو عن خطئه الجسيم»، فالإعفاء من هذين باطل فى الجزء الذى يشملهما، ولا يملك المتعاقدان الاتفاق على خلاف ذلك.',
      uncertainReading: false,
    });
  }
  return out;
}

const PERIODIC_COMMISSION = /(?:عموله|رسوم|مصروفات|مصاريف)\s+(?:[ء-ي]+\s+){0,2}?(?:شهري[ء-ي]*|سنوي[ء-ي]*|ربع سنوي[ء-ي]*|دوري[ء-ي]*)[^.\n]{0,40}?(?:بنسبه|بواقع|قدرها|تعادل)?\s*(\d{1,3}(?:dot\d+)?)\s*(?:pct|بالمائه|بالمئه|في المائه|في المئه)|(?:عموله|رسوم|مصروفات|مصاريف)[^.\n]{0,40}?(\d{1,3}(?:dot\d+)?)\s*(?:pct|بالمائه|بالمئه|في المائه|في المئه)\s*(?:شهري[ء-ي]*|سنوي[ء-ي]*|في الشهر|كل شهر|في السنه|كل سنه|عن كل شهر)/;
const BALANCE_BASE = /(?:الرصيد|رصيد|اصل الدين|اصل المبلغ|مبلغ القرض|قيمه القرض|المبلغ المتبقي|الدين القائم|القيمه القائمه)/;
const LOAN_CONTEXT = /(?:قرض|تمويل|مقرض|مقترض|الدائن|المدين|فائده|عائد|الرصيد)/;

function commissionHits(sentences: Array<{ raw: string; n: string }>, whole: string): MandatoryHit[] {
  if (!LOAN_CONTEXT.test(whole)) return [];
  const out: MandatoryHit[] = [];
  for (const s of sentences) {
    const m = PERIODIC_COMMISSION.exec(s.n);
    if (!m || !BALANCE_BASE.test(s.n)) continue;
    const pct = m[1] ?? m[2] ?? '';
    const monthly = MONTHLY.test(s.n);
    out.push({
      ruleId: 'interest_hidden_commission',
      severity: 'عالٍ',
      articles: [227],
      quote: clipQuote(s.raw),
      explanation:
        `يشترط البند عمولة دورية بنسبة ${pct}%${monthly ? ' شهرياً' : ''} محسوبة على الرصيد القائم فوق الفائدة المتفق عليها؛ وهى بهذه الصفة مقابل للتمويل نفسه لا لخدمة محددة. ` +
        'والمادة 227/2 من القانون المدنى تقضى بأن كل عمولة أو منفعة اشترطها الدائن إذا زادت مع الفائدة المتفق عليها على الحد الأقصى «تعتبر مستترة فائدة ربوية وتكون قابلة للتخفيض» إذا ثبت أنها لا تقابلها خدمة حقيقية أداها الدائن؛ ' +
        'ويُحتسب مجموع الفائدة والعمولة سنوياً فإن جاوز 7% وجب تخفيضه.',
      uncertainReading: false,
    });
  }
  return out;
}

const PENALTY_ON_PENALTY = /(?:غرامه|غرامات|جزاء|جزاءات|تعويض)[^.\n]{0,80}?(?:مضافا اليه|مضافه الي|ما استحق من غرامات|ما سبقها من غرامات|ما سبق من غرامات|وما سبقها|وما سبق|وتحسب عليها غرامه|غرامه علي غرامه|غرامات علي غرامات|تحسب علي (?:ال)?غرامات)/;

function penaltyCompoundingHits(sentences: Array<{ raw: string; n: string }>): MandatoryHit[] {
  const out: MandatoryHit[] = [];
  for (const s of sentences) {
    if (!PENALTY_ON_PENALTY.test(s.n)) continue;
    if (!/(?:ما استحق من غرامات|ما سبق[ء-ي]* من غرامات|وتحسب عليها غرامه|غرامه علي غرامه|غرامات علي غرامات|تحسب علي (?:ال)?غرامات|مضافا اليه ما استحق|مضافه الي (?:ال)?غرامات|وما سبقها)/.test(s.n)) continue;
    out.push({
      ruleId: 'penalty_compounding',
      severity: 'عالٍ',
      articles: [232, 224],
      quote: clipQuote(s.raw),
      explanation:
        'تُحتسب الغرامة على المبلغ مضافاً إليه ما استحق من غرامات سابقة (غرامة على غرامة)؛ وهذا تركيب لا يجيزه القانون المدنى: المادة 232 تمنع تقاضى فوائد على متجمد الفوائد وألا يزيد مجموع ما يتقاضاه الدائن على رأس المال، ' +
        'والمادة 224 تجعل التعويض الاتفاقى خاضعاً لتقدير القاضى وتخفيضه عند المبالغة ولا تُقر شرطاً يخالف ذلك.',
      uncertainReading: false,
    });
  }
  return out;
}

/** مخالفات المواد الآمرة الظاهرة فى نص بند واحد، مرتبة الأخطر أولاً، بلا تكرار لقاعدة واحدة. */
export function mandatoryRuleHits(clauseText: string): MandatoryHit[] {
  const sentences = sentencesOf(clauseText ?? '').map((raw) => ({ raw, n: norm(raw) }));
  if (sentences.length === 0) return [];
  const all = [...decennialHits(sentences), ...fraudWaiverHits(sentences), ...interestHits(sentences), ...commissionHits(sentences, norm(clauseText ?? '')), ...penaltyHits(sentences), ...penaltyCompoundingHits(sentences)];
  const seen = new Set<string>();
  const uniq = all.filter((h) => {
    if (seen.has(h.ruleId)) return false;
    seen.add(h.ruleId);
    return true;
  });
  return uniq.sort((a, b) => (a.severity === b.severity ? 0 : a.severity === 'حرج' ? -1 : 1));
}

// ---------------------------------------------------------------------------------------------------------------------------------
// تطبيق النتيجة على البند بعد المدقق المستقل
// ---------------------------------------------------------------------------------------------------------------------------------

export interface MandatoryClauseState {
  assessmentStatus: string | null;
  riskLevel: string | null;
  assessmentReasoning: string | null;
  matchedArticles: Array<{ law: string; law_no: number; law_year: number; article_no: number; snippet: string; official_url: string | null }> | null;
  verification: Record<string, unknown> | null;
}

export interface MandatoryClausePatch {
  assessmentStatus: 'يحتاج مراجعة';
  riskLevel: MandatorySeverity | string;
  assessmentReasoning: string;
  matchedArticles: NonNullable<MandatoryClauseState['matchedArticles']>;
  verification: Record<string, unknown>;
}

const RISK_RANK: Record<string, number> = { حرج: 0, عالٍ: 1, متوسط: 2 };
const rank = (r: string | null | undefined): number => RISK_RANK[r ?? ''] ?? 9;

/** حكم المدقق دحض الملاحظة (استُبعدت بدحض موثَّق أو «غير مؤكدة بالدحض») */
function wasRefuted(v: Record<string, unknown> | null): boolean {
  return !!v && v['status'] === 'unconfirmed' && v['basis'] === 'refuted';
}

/**
 * يحسب ما يُكتب على البند حين تثبت مخالفة آمرة نصياً. القاعدة: النص الآمر الصريح لا يُسقطه دحض المدقق (الأمان أولاً)، ولا درجة أقل من درجة القاعدة.
 * البند الذى لم يرصد النموذج فيه شيئاً يُرفع إلى «يحتاج مراجعة» بدرجة القاعدة. تُضاف المواد المذكورة بنصوصها المحقَّقة إن لم تكن معروضة.
 * إن كانت قراءة النسبة تالفة (uncertainReading) تبقى الملاحظة «غير مؤكدة» بسبب صريح، لا مؤكدة.
 */
export function mandatoryClausePatch(state: MandatoryClauseState, hits: MandatoryHit[], now = new Date()): MandatoryClausePatch | null {
  if (hits.length === 0) return null;
  const top = hits[0];
  const riskLevel = rank(top.severity) < rank(state.riskLevel) ? top.severity : (state.riskLevel as string);
  const deterministic = hits.map((h) => `${h.explanation} (من نص البند: «${h.quote}»)`).join('\n\n');
  const keepModelReasoning = state.assessmentStatus === 'يحتاج مراجعة' && !wasRefuted(state.verification) && !!state.assessmentReasoning && rank(state.riskLevel) <= 1;
  const assessmentReasoning = keepModelReasoning ? `${state.assessmentReasoning}\n\nقاعدة نصية حتمية: ${deterministic}` : deterministic;
  const have = new Set((state.matchedArticles ?? []).filter((m) => m.law_no === 131 && m.law_year === 1948).map((m) => m.article_no));
  const matchedArticles = [...(state.matchedArticles ?? [])];
  for (const n of hits.flatMap((h) => h.articles)) {
    if (have.has(n)) continue;
    const ref = mandatoryArticleRef(n);
    if (ref) {
      matchedArticles.push(ref);
      have.add(n);
    }
  }
  const firm = hits.find((h) => !h.uncertainReading);
  const verifiedAt = now.toISOString();
  const articlesList = hits.flatMap((h) => h.articles).filter((n, i, arr) => arr.indexOf(n) === i).join('، ');
  const refutedNote = wasRefuted(state.verification) ? ' ولا يُسقطها دحض المدقق المستقل الذى خالف نص المادة؛ وسبب دحضه محفوظ للمراجعة.' : '';
  const verification: Record<string, unknown> = firm
    ? {
        status: 'confirmed',
        basis: 'confirmed',
        reason: `ثبتت المخالفة بقاعدة نصية حتمية على عبارة صريحة فى البند (المواد ${articlesList})${refutedNote || '.'}`,
        quote: firm.quote,
        quoteSource: 'clause',
        verifiedAt,
      }
    : {
        status: 'unconfirmed',
        basis: 'uncertain',
        reason: 'النسبة المنصوص عليها قُرئت من صورة ممسوحة بصيغة تالفة يُرجَّح أنها نسبة مئوية؛ فلا تُعدّ المخالفة مؤكدة حتى تُطابَق بالأصل. (وُسم آلياً: ليس اعتراضاً من المدقق المستقل.)',
        quote: null,
        quoteSource: null,
        verifiedAt,
      };
  return { assessmentStatus: 'يحتاج مراجعة', riskLevel, assessmentReasoning, matchedArticles, verification };
}
