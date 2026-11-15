import { checkOpenTerms, validateModelFindings, type LevelClause } from './contract-level';
import { damagedPercentFigure } from './numeric-checks.util';

const cl = (i: number, text: string): LevelClause => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: text });

describe('R96 — رقم نسبة تالف داخل قائمة نسب', () => {
  it('«%300» و«9630» و«9615» (مقاولة ب الممسوحة) ⇒ تالف', () => {
    expect(damagedPercentFigure('يسدد رب العمل 20% عند التوقيع 300% عند إنجاز الهيكل الخرسانى و 9630 عند التسليم')).toBe('300');
    expect(damagedPercentFigure('و 9630 عند التسليم')).toBe('9630');
  });
  it('نسب سليمة أو مبلغ بعملة ⇒ لا تلف', () => {
    expect(damagedPercentFigure('يسدد 40% عند التوقيع و30% عند الهيكل و30% عند التسليم')).toBeNull();
    expect(damagedPercentFigure('غرامة 150% من قيمة القسط')).toBeNull();
    expect(damagedPercentFigure('الثمن 9600 جنيه عند التسليم')).toBeNull();
    expect(damagedPercentFigure('الثمن 9600 عند التسليم جنيه')).toBe('9600');
  });
});

describe('R96 — عدم اتساق مبنى على نسب تالفة يُوسم غير مؤكد', () => {
  const clauses = [
    cl(4, 'الثمن إجمالى ثابت قدره 3600000 جنيه.'),
    cl(5, 'يسدد رب العمل 20% عند التوقيع 300% عند إنجاز الهيكل الخرسانى و 9630 عند التسليم الابتدائى.'),
  ];
  const raw = (quote: string) => ({
    findings: [
    {
      kind: 'scope_mismatch', severity: 'عالٍ', title: 'نسب الدفعات لا تجمع إلى 100%', explanation: 'نسب الدفعات لا تتسق مع الثمن الثابت فى المادة الرابعة.',
      evidence: [
        { clause_index: 5, quote },
        { clause_index: 4, quote: 'الثمن إجمالى ثابت قدره 3600000 جنيه' },
      ],
    },
  ] });
  it('الاقتباس به نسبة تالفة ⇒ unconfirmed/uncertain', () => {
    const f = validateModelFindings(raw('يسدد رب العمل 20% عند التوقيع 300% عند إنجاز الهيكل الخرسانى'), clauses);
    expect(f).toHaveLength(1);
    expect(f[0].verification?.status).toBe('unconfirmed');
    expect(f[0].verification?.basis).toBe('uncertain');
  });
  it('الاقتباس سليم ⇒ لا وسم', () => {
    const c2 = [cl(4, 'الثمن إجمالى ثابت قدره 3600000 جنيه.'), cl(5, 'يسدد رب العمل 40% عند التوقيع و50% عند الهيكل و30% عند التسليم.')];
    const f = validateModelFindings(raw('يسدد رب العمل 40% عند التوقيع و50% عند الهيكل و30% عند التسليم'), c2);
    expect(f).toHaveLength(1);
    expect(f[0].verification).toBeUndefined();
  });
});

describe('R96 — «بإخطار لاحق» حين تُسقط القراءة كلمة المبلغ', () => {
  it('«ما يستحقه المقرض من ومتابعة وإدارة يحددها بإخطار لاحق» ⇒ شرط مفتوح متوسط', () => {
    const t = 'مبلغ القرض: مبلغ القرض 2000000 جنيه يصرف بتحويل بنكى، ويخصم منه عند الصرف ما يستحقه المقرض من\nومتابعة وإدارة يحددها بإخطار لاحق.';
    const f = checkOpenTerms([cl(2, t)]);
    expect(f).toHaveLength(1);
    expect(f[0].severity).toBe('متوسط');
  });
  it('إخطار لاحق بلا فعل استحقاق ولا كلمة مبلغ ⇒ لا شىء (لا ضجيج)', () => {
    expect(checkOpenTerms([cl(9, 'يحدد الطرف الأول موعد الاجتماع بإخطار لاحق للطرف الثانى.')])).toHaveLength(0);
  });
});
