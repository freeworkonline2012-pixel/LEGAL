import {
  CLARIFICATION_FACTS_MARKER,
  MAX_HISTORY_ANSWERS,
  buildEnrichedQuestion,
  buildRetrievalQuery,
  clarificationEnabled,
  clarificationMaxRounds,
  extractClarificationAnswers,
  extractClarificationFacts,
  isAlreadyAnsweredFact,
  parseClarificationFacts,
  normalizeClarificationInput,
  parseClarificationDetection,
  type ClarificationAnswer,
} from './clarification';

const A1: ClarificationAnswer = { question: 'ما نوع عقد العمل؟', answer: 'عقد محدد المدة', kind: 'option' };
const A2: ClarificationAnswer = { question: 'من الذى أنهى العلاقة؟', answer: '', kind: 'unknown' };
const A3: ClarificationAnswer = { question: 'كم مدة الخدمة؟', answer: 'عشر سنوات ونصف', kind: 'custom' };

describe('clarification — مفاتيح التفعيل', () => {
  it('الافتراضى مفعَّل ويُوقَف فقط بـfalse الصريحة', () => {
    expect(clarificationEnabled({} as NodeJS.ProcessEnv)).toBe(true);
    expect(clarificationEnabled({ CLARIFICATION_ENABLED: 'false' } as unknown as NodeJS.ProcessEnv)).toBe(false);
    expect(clarificationEnabled({ CLARIFICATION_ENABLED: 'true' } as unknown as NodeJS.ProcessEnv)).toBe(true);
  });
  it('عدد الجولات: افتراضى 2، ويُقيَّد بين 0 و4', () => {
    expect(clarificationMaxRounds({} as NodeJS.ProcessEnv)).toBe(2);
    expect(clarificationMaxRounds({ CLARIFICATION_MAX_ROUNDS: '3' } as unknown as NodeJS.ProcessEnv)).toBe(3);
    expect(clarificationMaxRounds({ CLARIFICATION_MAX_ROUNDS: '99' } as unknown as NodeJS.ProcessEnv)).toBe(4);
    expect(clarificationMaxRounds({ CLARIFICATION_MAX_ROUNDS: '-1' } as unknown as NodeJS.ProcessEnv)).toBe(0);
    expect(clarificationMaxRounds({ CLARIFICATION_MAX_ROUNDS: 'x' } as unknown as NodeJS.ProcessEnv)).toBe(2);
  });
});

describe('normalizeClarificationInput', () => {
  it('مدخل غائب/تالف = لا استيضاح سابق', () => {
    expect(normalizeClarificationInput(undefined, 2)).toEqual({ round: 0, skip: false, answers: [] });
    expect(normalizeClarificationInput('x', 2)).toEqual({ round: 0, skip: false, answers: [] });
  });
  it('يقلّم الأحجام ويحذف الفارغ ويضبط الجولة ويقبل unknown بلا نص', () => {
    const r = normalizeClarificationInput(
      {
        round: 9,
        skip: true,
        answers: [
          { question: '  ما\nنوع العقد؟  ', answer: 'محدد   المدة', kind: 'option' },
          { question: 'ما نوع العقد؟', answer: '', kind: 'option' },
          { question: 'س', answer: 'ج', kind: 'option' },
          { question: 'لا أعرف هذا؟', answer: 'نص يُتجاهل', kind: 'unknown' },
          { question: 'سؤال طويل؟', answer: 'ا'.repeat(900), kind: 'custom' },
          { question: 'نوع غريب؟', answer: 'ج', kind: 'hack' },
        ],
      },
      2,
    );
    expect(r.round).toBe(2);
    expect(r.skip).toBe(true);
    expect(r.answers.map((a) => a.kind)).toEqual(['option', 'unknown', 'custom', 'option']);
    expect(r.answers[0]).toEqual({ question: 'ما نوع العقد؟', answer: 'محدد المدة', kind: 'option' });
    expect(r.answers[1].answer).toBe('');
    expect(r.answers[2].answer.length).toBeLessThanOrEqual(401);
  });
  it('لا يتجاوز الحد الأقصى لعدد الإجابات', () => {
    const many = Array.from({ length: 40 }, (_, i) => ({ question: `سؤال رقم ${i}؟`, answer: 'نعم', kind: 'option' }));
    expect(normalizeClarificationInput({ answers: many }, 2).answers).toHaveLength(MAX_HISTORY_ANSWERS);
  });
});

describe('السؤال المُثرى واستعلام الاسترجاع', () => {
  it('بلا إجابات: السؤال كما هو', () => {
    expect(buildEnrichedQuestion('سؤالى؟', [])).toBe('سؤالى؟');
    expect(extractClarificationFacts('سؤالى؟')).toBe('');
  });
  it('مع إجابات: قسم موسوم بالوقائع، و«لا أعرف» تُصرَّح، والنص الحر موسوم بصياغة السائل', () => {
    const q = buildEnrichedQuestion('ما حقوقى؟', [A1, A2, A3]);
    expect(q.startsWith('ما حقوقى؟')).toBe(true);
    expect(q).toContain(CLARIFICATION_FACTS_MARKER);
    expect(q).toContain('- ما نوع عقد العمل؟ ← عقد محدد المدة');
    expect(q).toContain('لا يعرف');
    expect(q).toContain('عشر سنوات ونصف (بصياغة السائل)');
    const facts = extractClarificationFacts(q);
    expect(facts).toContain('عقد محدد المدة');
    expect(facts).not.toContain('ما حقوقى؟');
  });
  it('استعلام الاسترجاع: الأصل + الإجابات الفعلية فقط (لا أسئلة ولا «لا أعرف»)، ومضغوط', () => {
    const rq = buildRetrievalQuery('ما حقوقى؟', [A1, A2, A3]);
    expect(rq).toBe('ما حقوقى؟ عقد محدد المدة عشر سنوات ونصف');
    expect(rq).not.toContain('نوع');
    expect(buildRetrievalQuery('ما حقوقى؟', [A2])).toBe('ما حقوقى؟');
    const long = Array.from({ length: 12 }, (_, i) => ({ question: `س${i} طويل؟`, answer: 'ب'.repeat(100), kind: 'custom' as const }));
    expect(buildRetrievalQuery('س؟', long).length).toBeLessThanOrEqual(2 + 500 + 10);
  });
});

describe('parseClarificationDetection — الخادم هو الحَكَم', () => {
  const GOOD = {
    needs_clarification: true,
    reason: 'الحكم يختلف بين العقد المحدد وغير المحدد',
    questions: [
      {
        question: 'ما نوع عقد العمل؟',
        why: 'تختلف الحقوق بين المحدد المدة وغير المحدد (المادتان 87 و88)',
        options: ['عقد محدد المدة', 'عقد غير محدد المدة', 'لا أعرف', 'أخرى'],
        allow_multiple: false,
      },
      { question: 'من الذى أنهى العلاقة؟', options: ['صاحب العمل', 'العامل'], allow_multiple: false },
    ],
  };

  it('يقبل أسئلة سليمة، يحذف «أخرى/لا أعرف» من الخيارات (تضيفها الواجهة)، ويعطى معرّفات', () => {
    const d = parseClarificationDetection(GOOD, []);
    expect(d.questions).toHaveLength(2);
    expect(d.questions[0].options).toEqual(['عقد محدد المدة', 'عقد غير محدد المدة']);
    expect(d.questions.map((q) => q.id)).toEqual(['q1', 'q2']);
    expect(d.questions[0].why).toContain('المادتان');
    expect(d.questions[1].why).toBeNull();
    expect(d.reason).toContain('يختلف');
  });
  it('needs_clarification=false أو بنية تالفة = لا أسئلة', () => {
    expect(parseClarificationDetection({ needs_clarification: false, questions: GOOD.questions }, []).questions).toEqual([]);
    expect(parseClarificationDetection(null, []).questions).toEqual([]);
    expect(parseClarificationDetection([], []).questions).toEqual([]);
    expect(parseClarificationDetection({ needs_clarification: true }, []).questions).toEqual([]);
  });
  it('يُسقط سؤالاً بأقل من خيارين (بعد حذف العام والمكرر)', () => {
    const d = parseClarificationDetection(
      { needs_clarification: true, questions: [{ question: 'سؤال بلا خيارات كافية؟', options: ['خيار', 'خيار', 'أخرى'] }] },
      [],
    );
    expect(d.questions).toEqual([]);
    expect(d.dropped[0]).toContain('خيارات غير كافية');
  });
  it('يُسقط الأسئلة التى تطلب بيانات شخصية', () => {
    const asks = ['ما اسمك الكامل؟', 'ما رقم هاتفك؟', 'ما الرقم القومي للعامل؟', 'ما عنوان الشركة؟', 'ما بريدك الإلكتروني؟'];
    for (const question of asks) {
      const d = parseClarificationDetection(
        { needs_clarification: true, questions: [{ question, options: ['أ', 'ب'].map((x) => x + x) }] },
        [],
      );
      expect(d.questions).toEqual([]);
      expect(d.dropped[0]).toContain('بيانات شخصية');
    }
  });
  it('لا يمنع سؤالاً مشروعاً يحوى كلمة قريبة (مثل: اسم الراتب غير وارد، لكن «نوع الأجر» مقبول)', () => {
    const d = parseClarificationDetection(
      { needs_clarification: true, questions: [{ question: 'ما نوع الأجر المتفق عليه؟', options: ['شهرى ثابت', 'بالقطعة'] }] },
      [],
    );
    expect(d.questions).toHaveLength(1);
  });
  it('لا يكرر سؤالاً سبقت الإجابة عنه ولا سؤالاً مكرراً داخل الجولة', () => {
    const d = parseClarificationDetection(
      {
        needs_clarification: true,
        questions: [
          { question: 'ما هو نوع عقد العمل؟', options: ['محدد', 'غير محدد'] },
          { question: 'من الذى أنهى علاقة العمل؟', options: ['صاحب العمل', 'العامل'] },
          { question: 'من الذى أنهى علاقة العمل بالتحديد؟', options: ['صاحب العمل', 'العامل'] },
        ],
      },
      [A1],
    );
    expect(d.questions.map((q) => q.question)).toEqual(['من الذى أنهى علاقة العمل؟']);
    expect(d.dropped.filter((x) => x.startsWith('مكرر'))).toHaveLength(2);
  });
  it('سقف 4 أسئلة و6 خيارات لكل سؤال، وallow_multiple لا تُقبل إلا true صريحة', () => {
    const topics = ['نوع العقد', 'سبب الإنهاء', 'مدة الخدمة', 'طريقة صرف الأجر', 'وجود إنذار مكتوب', 'مكان العمل', 'ساعات الدوام'];
    const qs = Array.from({ length: 7 }, (_, i) => ({
      question: `ما ${topics[i]} فى حالتك؟`,
      options: Array.from({ length: 9 }, (_, k) => `خيار ${k} للسؤال ${i}`),
      allow_multiple: i === 0 ? true : 'true',
    }));
    const d = parseClarificationDetection({ needs_clarification: true, questions: qs }, []);
    expect(d.questions).toHaveLength(4);
    expect(d.questions[0].options).toHaveLength(6);
    expect(d.questions[0].allow_multiple).toBe(true);
    expect(d.questions[1].allow_multiple).toBe(false);
  });
});

describe('clarification — وقائع 2d: وحدة الرقم المجرد والتفكيك وفلتر المكرر', () => {
  const num = (question: string, answer: string) => buildEnrichedQuestion('س', [{ question, answer, kind: 'custom' }]);
  it('رقم مجرد يأخذ وحدة السؤال (سنوات/أشهر/أيام)، وإلا يُوسَم صراحةً بلا وحدة', () => {
    expect(num('كم إجمالى مدة الخدمة بالسنوات؟', '12')).toContain('← 12 سنوات (بصياغة السائل)');
    expect(num('كم شهراً عملت؟', '8')).toContain('8 أشهر');
    expect(num('كم يوماً تأخر الأجر؟', '20')).toContain('20 أيام');
    expect(num('ما الرقم المطلوب؟', '12')).toContain('رقم بلا وحدة');
    expect(num('كم إجمالى مدة الخدمة بالسنوات؟', '12 عاماً')).not.toContain('رقم بلا وحدة');
  });
  it('parseClarificationFacts تفكّك السطور وتميّز «لا يعرف»، وextractClarificationAnswers تأخذ الإجابات وحدها', () => {
    const q = buildEnrichedQuestion('س', [A1, A2, A3]);
    const facts = parseClarificationFacts(extractClarificationFacts(q));
    expect(facts.map((f) => f.unknown)).toEqual([false, true, false]);
    expect(facts[0]).toMatchObject({ question: 'ما نوع عقد العمل؟' });
    const answers = extractClarificationAnswers(q);
    expect(answers).toContain('عقد محدد المدة');
    expect(answers).toContain('عشر سنوات ونصف');
    expect(answers).not.toContain('الذى أنهى');
    expect(extractClarificationAnswers('سؤال بلا توضيحات')).toBe('');
  });
  it('isAlreadyAnsweredFact: المُجاب عنه يُعدّ معروفاً، و«لا يعرف» وغير المرتبط لا', () => {
    const facts = parseClarificationFacts(extractClarificationFacts(buildEnrichedQuestion('س', [A1, A2, A3])));
    expect(isAlreadyAnsweredFact('ما نوع عقد العمل؟', facts)).toBe(true);
    expect(isAlreadyAnsweredFact('من الذى أنهى العلاقة؟', facts)).toBe(false);
    expect(isAlreadyAnsweredFact('هل لديك نسخة من العقد؟', facts)).toBe(false);
    expect(isAlreadyAnsweredFact('ما نوع عقد العمل؟', [])).toBe(false);
  });
});
