import type { ClauseFacts, PartyRef } from './clause-facts';

/**
 * محرك القواعد (Playbook as code) v1: قواعد حتمية تُطبَّق على وقائع البند الموثَّقة بالاقتباس (clause-facts.ts)، لا على رأى
 * النموذج. كل قاعدة تحمل المواد المرجعية (من القانون المدنى 131/1948 المفهرَس، ونصوصها محقَّقة حرفياً من migrations/074)،
 * وخطورة، وشرحاً عربياً قالبياً يقتبس عبارة البند. النتيجة ثابتة لنفس الوقائع ولا تتغير بتغير النموذج.
 *
 * حدود صريحة: القواعد تغطى أربعة موضوعات (الفسخ والإعذار، القوة القاهرة، الإعفاء من المسئولية، التعويض). حكمها يخص
 * الموضوع المذكور فى شرحها فقط، ولا يعنى سلامة بقية أحكام البند.
 */

export type RuleSeverity = 'critical' | 'high' | 'medium';

export interface RuleFinding {
  ruleId: string;
  topic: string;
  status: 'compliant' | 'review';
  severity: RuleSeverity | null;
  /** مواد القانون المدنى المرجعية لهذه النتيجة */
  articles: number[];
  /** اقتباسات حرفية من البند قامت عليها النتيجة */
  quotes: string[];
  explanation: string;
}

export interface RuleContext {
  clientParty: 'first' | 'second' | null;
}

type Rel = 'client' | 'other' | 'both' | 'none' | 'unknown';

function relOf(ref: PartyRef, ctx: RuleContext): Rel {
  if (ref === 'both') return 'both';
  if (ref === 'none') return 'none';
  if (ref === 'unknown') return 'unknown';
  if (!ctx.clientParty) return 'unknown';
  return ref === ctx.clientParty ? 'client' : 'other';
}

const q = (s: string) => `«${s.replace(/\s+/g, ' ').trim()}»`;

function termination(facts: ClauseFacts, ctx: RuleContext): RuleFinding[] {
  const t = facts.termination;
  if (!t) return [];
  const topic = 'الفسخ والإعذار';
  if (t.mechanism === 'court_required') {
    return [
      {
        ruleId: 'termination.court_required',
        topic,
        status: 'compliant',
        severity: null,
        articles: [157],
        quotes: [t.quote],
        explanation: `يجعل البند الفسخ بحكم قضائى ${q(t.quote)}، وهو الأصل الذى تقرره المادة 157 من القانون المدنى؛ فلا مخالفة ظاهرة من هذه الجهة.`,
      },
    ];
  }
  const n = facts.notice;
  const holder = relOf(t.holder, ctx);
  const quotes = [t.quote, ...(n && n.quote ? [n.quote] : [])];
  if (n?.state === 'waived_explicitly') {
    if (holder === 'other') {
      return [
        {
          ruleId: 'termination.waived_notice.counterparty_holds',
          topic,
          status: 'review',
          severity: 'medium',
          articles: [158, 157],
          quotes,
          explanation:
            `يجيز البند الفسخ دون حكم قضائى ${q(t.quote)} مع إعفاء صريح من الإعذار ${q(n.quote)}، والمادة 158 تُجيز ذلك بالاتفاق الصريح فلا مخالفة قانونية؛ ` +
            'لكن هذا الحق ممنوح للطرف المقابل لا للعميل، فيستطيع فسخ العقد دون إنذار أو مهلة. يستحق نظر العميل (مثل طلب مهلة تصحيح أو جعل الحق متبادلاً).',
        },
      ];
    }
    return [
      {
        ruleId: 'termination.waived_notice.explicit',
        topic,
        status: 'compliant',
        severity: null,
        articles: [158],
        quotes,
        explanation:
          `يتضمن البند حق الفسخ دون حكم قضائى ${q(t.quote)} واتفاقاً صريحاً على الإعفاء من الإعذار ${q(n.quote)}، وهو ما تشترطه المادة 158 من القانون المدنى ` +
          `(«وهذا الاتفاق لا يعفي من الإعذار إلا إذا اتفق المتعاقدان صراحة على الإعفاء منه»)؛ فلا مخالفة ظاهرة من هذه الجهة${holder === 'client' ? '، والحق هنا للعميل' : ''}.`,
      },
    ];
  }
  if (n?.state === 'required') {
    return [
      {
        ruleId: 'termination.notice_required',
        topic,
        status: 'compliant',
        severity: null,
        articles: [158, 157],
        quotes,
        explanation: `يشترط البند إعذاراً أو إخطاراً قبل الفسخ ${q(n.quote)}، وهو متسق مع المادتين 157 و158 من القانون المدنى؛ فلا مخالفة ظاهرة من هذه الجهة.`,
      },
    ];
  }
  if (n?.state === 'not_addressed') {
    if (holder === 'other') {
      return [
        {
          ruleId: 'termination.not_addressed.protects_client',
          topic,
          status: 'compliant',
          severity: null,
          articles: [158],
          quotes: [t.quote],
          explanation: `يجيز البند الفسخ دون حكم قضائى ${q(t.quote)} ولا يعفى صراحة من الإعذار، فيبقى إعذار الطرف المقابل للعميل لازماً وفق المادة 158 من القانون المدنى؛ وهذا فى مصلحة العميل.`,
        },
      ];
    }
    return [
      {
        ruleId: 'termination.not_addressed.weak_waiver',
        topic,
        status: 'review',
        severity: 'medium',
        articles: [158, 157],
        quotes: [t.quote],
        explanation:
          `يجيز البند الفسخ دون حكم قضائى ${q(t.quote)} لكنه لا ينص صراحة على الإعفاء من الإعذار، والمادة 158 تقرر أن هذا الاتفاق «لا يعفي من الإعذار إلا إذا اتفق المتعاقدان صراحة على الإعفاء منه»؛ ` +
          'فقد يُنازَع فى الفسخ دون إعذار.',
      },
    ];
  }
  return [];
}

function forceMajeure(facts: ClauseFacts, ctx: RuleContext): RuleFinding[] {
  const f = facts.forceMajeure;
  if (!f) return [];
  const topic = 'القوة القاهرة';
  const beneficiary = relOf(f.beneficiary, ctx);
  if (f.extraCauses === 'open_ended') {
    if (f.counterpartyCanReject) {
      return [
        {
          ruleId: 'force_majeure.open_ended.reviewable',
          topic,
          status: 'compliant',
          severity: null,
          articles: [165, 373, 217],
          quotes: [f.quote],
          explanation:
            `يوسّع البند الإعفاء من التأخير ليشمل أسباباً أخرى خارجة عن الإرادة ${q(f.quote)}، لكنه يربطها بإخطار ويُبقى للطرف المقابل حق قبولها أو رفضها؛ ` +
            'والاتفاق على تحمل تبعة القوة القاهرة والحادث المفاجئ جائز بنص المادة 217(1) من القانون المدنى، والسبب الأجنبى (المادة 165) وانقضاء الالتزام بالاستحالة (المادة 373) يحكمان ما يثبت منها؛ فلا مخالفة ظاهرة.',
        },
      ];
    }
    return [
      {
        ruleId: 'force_majeure.open_ended.unchecked',
        topic,
        status: 'review',
        severity: beneficiary === 'other' ? 'high' : 'medium',
        articles: [165, 373, 215],
        quotes: [f.quote],
        explanation:
          `يوسّع البند الإعفاء من التأخير ليشمل أسباباً أخرى غير محددة خارجة عن الإرادة ${q(f.quote)} دون أن يُبقى للطرف المقابل حقاً فى رفضها أو التحقق منها؛ ` +
          'والسبب الأجنبى الذى يرفع التعويض (المادة 165) والاستحالة التى تُنهى الالتزام (المادة 373) لهما ضوابط قانونية، فترك تحديد ما يُعد سبباً معفياً لأحد الطرفين بلا ضابط يحمل خطراً على الطرف الآخر ' +
          (beneficiary === 'other' ? '(وهو العميل هنا).' : beneficiary === 'client' ? '(والعميل هو المستفيد من هذا الإعفاء).' : '.'),
      },
    ];
  }
  return [
    {
      ruleId: f.extraCauses === 'legal_only' ? 'force_majeure.legal_only' : 'force_majeure.listed',
      topic,
      status: 'compliant',
      severity: null,
      articles: [165, 217],
      quotes: [f.quote],
      explanation: `يقصر البند الإعفاء من التأخير على القوة القاهرة والأسباب التى ينص عليها القانون أو يحددها ${q(f.quote)}، وهو متسق مع المادتين 165 و217(1) من القانون المدنى؛ فلا مخالفة ظاهرة من هذه الجهة.`,
    },
  ];
}

function liability(facts: ClauseFacts, ctx: RuleContext): RuleFinding[] {
  const l = facts.liability;
  if (!l || l.kind === 'none') return [];
  const topic = 'الإعفاء من المسئولية';
  const beneficiary = relOf(l.beneficiary, ctx);
  if (l.kind === 'cap') {
    return [
      {
        ruleId: 'liability.cap',
        topic,
        status: 'compliant',
        severity: null,
        articles: [217],
        quotes: [l.quote],
        explanation: `يضع البند حداً أقصى للمسئولية ${q(l.quote)}، والاتفاق على تخفيف المسئولية العقدية جائز بنص المادة 217(2) من القانون المدنى إلا ما ينشأ عن الغش أو الخطأ الجسيم؛ فلا مخالفة ظاهرة من هذه الجهة.`,
      },
    ];
  }
  if (l.grossFault === 'covered') {
    return [
      {
        ruleId: 'liability.exclusion.covers_gross_fault',
        topic,
        status: 'review',
        severity: 'critical',
        articles: [217],
        quotes: [l.quote],
        explanation:
          `يعفى البند من المسئولية بما يشمل الغش أو الخطأ الجسيم ${q(l.quote)}، والمادة 217(2) تجيز الإعفاء من المسئولية العقدية «إلا ما ينشأ عن غشه أو عن خطئه الجسيم»؛ ` +
          'فالشرط فى هذا الجزء مخالف لنص المادة وقابل للإبطال.',
      },
    ];
  }
  if (l.grossFault === 'reserved') {
    return [
      {
        ruleId: 'liability.exclusion.reserves_gross_fault',
        topic,
        status: 'compliant',
        severity: null,
        articles: [217],
        quotes: [l.quote],
        explanation: `يعفى البند من المسئولية مع استثناء الغش والخطأ الجسيم ${q(l.quote)}، وهو متسق مع المادة 217(2) من القانون المدنى؛ فلا مخالفة ظاهرة من هذه الجهة.`,
      },
    ];
  }
  return [
    {
      ruleId: 'liability.exclusion.silent_on_gross_fault',
      topic,
      status: 'review',
      severity: beneficiary === 'other' ? 'high' : 'medium',
      articles: [217],
      quotes: [l.quote],
      explanation:
        `يعفى البند من المسئولية ${q(l.quote)} دون أن يستثنى الغش والخطأ الجسيم، والمادة 217(2) من القانون المدنى تجيز الإعفاء «إلا ما ينشأ عن غشه أو عن خطئه الجسيم»؛ ` +
        'فلا يسرى الإعفاء على هذين الأمرين مهما أُطلق النص، والأفضل النص على هذا الاستثناء صراحة منعاً للنزاع' +
        (beneficiary === 'other' ? '، والإعفاء هنا لمصلحة الطرف المقابل.' : '.'),
    },
  ];
}

function compensation(facts: ClauseFacts, ctx: RuleContext): RuleFinding[] {
  const c = facts.compensation;
  if (!c) return [];
  const topic = 'التعويض';
  const payer = relOf(c.payer, ctx);
  if ((c.method === 'fixed_amount' || c.method === 'percentage') && c.waivesProofOfDamage) {
    return [
      {
        ruleId: 'compensation.agreed.waives_proof',
        topic,
        status: 'review',
        severity: 'high',
        articles: [224, 223],
        quotes: [c.quote],
        explanation:
          `يقرر البند تعويضاً اتفاقياً ويستحقه دون إثبات ضرر ${q(c.quote)}، والمادة 224 من القانون المدنى تقرر أن التعويض الاتفاقى «لا يكون مستحقاً إذا أثبت المدين أن الدائن لم يلحقه أى ضرر» ` +
          'وأن كل اتفاق يخالف ذلك باطل؛ فالشرط فى هذا الجزء لا يُعمل به.',
      },
    ];
  }
  if (c.method === 'fixed_amount' || c.method === 'percentage') {
    return [
      {
        ruleId: 'compensation.agreed',
        topic,
        status: 'compliant',
        severity: null,
        articles: [223, 224, 225],
        quotes: [c.quote],
        explanation:
          `يحدد البند التعويض مقدماً ${q(c.quote)}، وهو جائز بنص المادة 223 من القانون المدنى؛ مع بقاء حق المدين فى إثبات انتفاء الضرر أو طلب تخفيض المبالغة (المادة 224)، ` +
          'وعدم جواز مطالبة الدائن بأكثر من القيمة المتفق عليها إلا مع الغش أو الخطأ الجسيم (المادة 225).',
      },
    ];
  }
  if (c.method === 'party_discretion') {
    return [
      {
        ruleId: 'compensation.party_discretion',
        topic,
        status: 'review',
        severity: payer === 'client' ? 'high' : 'medium',
        articles: [221, 223, 224],
        quotes: [c.quote],
        explanation:
          `يترك البند تقدير التعويض لأحد الطرفين ${q(c.quote)}، بينما المادة 221 من القانون المدنى تجعل تقدير التعويض للقاضى ما لم يكن مقدراً فى العقد أو بنص القانون، ` +
          'والمادتان 223 و224 تجيزان تحديده مقدماً بقيمة معلومة قابلة للرقابة القضائية؛ فتقدير أحد الطرفين له منفرداً غير منضبط ' +
          (payer === 'client' ? 'ويعرّض العميل لتعويض لا سقف له.' : 'ويستحق تحديداً بمبلغ أو نسبة أو تركه للقضاء.'),
      },
    ];
  }
  if (c.method === 'unspecified' && !c.hasCap) {
    return [
      {
        ruleId: 'compensation.unspecified',
        topic,
        status: 'review',
        severity: 'medium',
        articles: [221, 223],
        quotes: [c.quote],
        explanation:
          `يذكر البند تعويضاً دون تحديد قيمته أو طريقة تقديره ${q(c.quote)}؛ فيرجع الأمر إلى المادة 221 من القانون المدنى (يقدره القاضى ويشمل ما لحق الدائن من خسارة وما فاته من كسب)، ` +
          'والأفضل تحديده مقدماً بقيمة أو نسبة أو سقف وفق المادة 223.',
      },
    ];
  }
  return [
    {
      ruleId: 'compensation.court_assessed',
      topic,
      status: 'compliant',
      severity: null,
      articles: [221],
      quotes: [c.quote],
      explanation: `يُبقى البند التعويض عن الضرر الفعلى لتقدير القضاء ${q(c.quote)}، وهو الأصل بنص المادة 221 من القانون المدنى؛ فلا مخالفة ظاهرة من هذه الجهة.`,
    },
  ];
}

/** يطبّق كل القواعد على وقائع بند واحد. فارغ إن لم تتوافر وقائع موثَّقة تنطبق عليها قاعدة. */
export function evaluateRules(facts: ClauseFacts, ctx: RuleContext): RuleFinding[] {
  return [...termination(facts, ctx), ...forceMajeure(facts, ctx), ...liability(facts, ctx), ...compensation(facts, ctx)];
}

const SEVERITY_ORDER: Record<RuleSeverity, number> = { critical: 3, high: 2, medium: 1 };

/** ملخص نتائج القواعد لبند واحد: الحالة (أى مراجعة ⇒ يحتاج مراجعة)، أعلى خطورة، المواد، والشرح مجمَّعاً. */
export function summarizeFindings(findings: RuleFinding[]): {
  status: 'سليم' | 'يحتاج مراجعة';
  risk: 'حرج' | 'عالٍ' | 'متوسط' | null;
  articles: number[];
  reasoning: string;
} {
  const reviews = findings.filter((f) => f.status === 'review');
  const top = reviews.reduce<RuleSeverity | null>(
    (acc, f) => (f.severity && (!acc || SEVERITY_ORDER[f.severity] > SEVERITY_ORDER[acc]) ? f.severity : acc),
    null,
  );
  const ordered = [...reviews, ...findings.filter((f) => f.status === 'compliant')];
  const articles = Array.from(new Set(ordered.flatMap((f) => f.articles))).slice(0, 6);
  const body = ordered.map((f) => (ordered.length > 1 ? `${f.topic}: ${f.explanation}` : f.explanation)).join('\n');
  const reasoning = reviews.length === 0 ? `${body}\nهذا الحكم يخص الجوانب المذكورة فقط ولا يعنى اعتماد بقية أحكام البند.` : body;
  return {
    status: reviews.length > 0 ? 'يحتاج مراجعة' : 'سليم',
    risk: top === 'critical' ? 'حرج' : top === 'high' ? 'عالٍ' : top === 'medium' ? 'متوسط' : null,
    articles,
    reasoning,
  };
}
