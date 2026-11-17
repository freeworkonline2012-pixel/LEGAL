import { readFileSync } from 'fs';
import { join } from 'path';
import {
  aggregate, classifyItems, evaluateGate, finalVerdict, freezeKey, holdoutKeyProblems, keyDigest, labelNumber, normalizeSnapshot,
  parseAdjudication, pendingTemplate, quoteFoundIn, renderReport, scoreContract, snapshotFromDbRows, stability, validateKey, amountInText,
} from './index';
import type { EvalKey, Snapshot, SnapClause } from './types';

const NR = 'يحتاج مراجعة';
const clause = (n: number, over: Partial<SnapClause> = {}): SnapClause => ({
  clauseIndex: n,
  clauseLabel: `البند ${n}`,
  clauseTitle: `عنوان ${n}`,
  clauseText: `نص البند رقم ${n} ويتضمن التزاماً على الطرف الثانى بسداد المبلغ كاملاً عند التسليم`,
  assessmentStatus: 'سليم',
  assessmentReasoning: null,
  matchedArticles: [{ law_no: 131, law_year: 1948, article_no: 217, snippet: 'يجوز الاتفاق على أن يتحمل المدين تبعة الحادث المفاجئ' }],
  riskLevel: null,
  verification: null,
  ...over,
});

function snap(over: Partial<Snapshot> = {}): Snapshot {
  return {
    evalRef: 'T01',
    contractId: 'c1',
    uploadedAt: '2026-11-10T10:00:00.000Z',
    capturedAt: null,
    contractType: 'supply',
    extractionWarnings: [],
    partyNames: { first: 'شركة الألفا', second: 'شركة بيتا' },
    clauses: [
      clause(1, { assessmentStatus: NR, riskLevel: 'عالٍ', assessmentReasoning: 'الشرط الجزائى مبالغ فيه', verification: { status: 'confirmed', reason: 'مؤكد', quote: 'سداد المبلغ كاملاً عند التسليم' } }),
      clause(2, { assessmentStatus: NR, riskLevel: 'متوسط', assessmentReasoning: 'مدة غير محددة', verification: { status: 'unconfirmed', reason: 'شك', basis: 'uncertain', quote: null } }),
      clause(3, { assessmentStatus: NR, riskLevel: 'حرج', assessmentReasoning: 'إعفاء من المسئولية عن الغش', verification: { status: 'confirmed', reason: 'ok' } }),
      clause(4, { assessmentStatus: 'لا يوجد نص قانونى مصرى مفهرَس ذو صلة مباشرة', matchedArticles: null }),
      clause(5, { assessmentStatus: NR, riskLevel: 'متوسط', assessmentReasoning: 'x', verification: { status: 'unconfirmed', reason: 'دحض', basis: 'refuted', refutationKind: 'clause_addresses', quote: 'التزاماً على الطرف الثانى' } }),
    ],
    contractFindings: [
      { id: 'missing:warranty', kind: 'missing_clause', severity: 'عالٍ', title: 'لا يوجد بند ضمان العيوب', explanation: 'العقد خلو من الضمان', evidence: [], verification: { status: 'confirmed', reason: 'ok' } },
      { id: 'office:x', kind: 'office_rule', severity: 'عالٍ', title: 'قاعدة المكتب: الشرط الجزائى', explanation: 'يتجاوز الحد', evidence: [{ clauseLabel: 'البند 1', quote: 'سداد المبلغ كاملاً عند التسليم' }], verification: { status: 'confirmed', reason: 'ok' } },
    ],
    notes: [],
    ...over,
  };
}

const key = (over: Partial<EvalKey> = {}): EvalKey => ({
  schema: 'shield-eval-key/1',
  contract_ref: 'T01',
  set: 'dev',
  contract_type: 'supply',
  clauses_expected: 5,
  parties: { first: 'شركة الألفا', second: 'شركة بيتا' },
  payment_sums: [250000],
  issues: [
    { id: 'I1', kind: 'clause', clause: 1, severity: 'عالٍ', topic: 'شرط جزائى', keywords: ['جزائ'] },
    { id: 'I2', kind: 'clause', clause: 2, severity: 'متوسط', topic: 'مدة', keywords: ['مدة'] },
    { id: 'I3', kind: 'absent', severity: 'عالٍ', topic: 'ضمان', finding_ids: ['missing:warranty'] },
    { id: 'I4', kind: 'clause', clause: 4, severity: 'حرج', topic: 'قوة قاهرة' },
  ],
  ...over,
});

describe('labelNumber', () => {
  it('أرقام وترتيبيات', () => {
    expect(labelNumber('البند 5')).toBe(5);
    expect(labelNumber('المادة (١٢)')).toBe(12);
    expect(labelNumber('البند الحادى عشر')).toBe(11);
    expect(labelNumber('البند العاشر')).toBe(10);
    expect(labelNumber('البند الثالث عشر')).toBe(13);
    expect(labelNumber('نص العقد كله')).toBeNull();
  });
});

describe('classifyItems', () => {
  it('يطابق منطق التقرير: مؤكد/مرشح/مستبعد، والدمج لقاعدة المكتب', () => {
    const items = classifyItems(snap());
    const by = (fp: string) => items.find((i) => i.fp === fp)!;
    expect(by('clause:1').state).toBe('confirmed');
    expect(by('clause:2').state).toBe('candidate');
    expect(by('clause:5').state).toBe('dismissed');
    expect(items.find((i) => i.fp.startsWith('finding:office_rule'))).toBeUndefined();
    expect(by('clause:1').haystack).toContain('قاعده المكتب');
    expect(items.some((i) => i.fp === 'clause:3' && i.severity === 'حرج')).toBe(true);
    expect(items.find((i) => i.fp === 'clause:4')).toBeUndefined();
  });
});

describe('scoreContract', () => {
  it('الاستدعاء: مؤكدة/مرشحة/فائتة', () => {
    const m = scoreContract(key(), snap());
    const o = Object.fromEntries(m.issues.map((i) => [i.id, i.outcome]));
    expect(o).toEqual({ I1: 'confirmed', I2: 'candidate', I3: 'confirmed', I4: 'missed' });
    expect(m.foundConfirmed).toBe(2);
    expect(m.foundCandidateOnly).toBe(1);
    expect(m.criticalHighTotal).toBe(3);
    expect(m.criticalHighFound).toBe(2);
  });

  it('كلمة مفتاحية خاطئة على البند الصحيح لا تطابق', () => {
    const k = key({ issues: [{ id: 'X', kind: 'clause', clause: 1, severity: 'عالٍ', topic: 't', keywords: ['تحكيم'] }] });
    expect(scoreContract(k, snap()).issues[0].outcome).toBe('missed');
  });

  it('عنصر مؤكد خارج المفتاح معلّق حتى يحكم المحامى', () => {
    const m = scoreContract(key(), snap());
    expect(m.pendingItems.map((p) => p.fp)).toEqual(['clause:3']);
    expect(m.pendingHighCritical).toBe(1);
    const adj = parseAdjudication({ 'T01|clause:3': 'false_alarm' });
    const m2 = scoreContract(key(), snap(), { adjudication: adj });
    expect(m2.pendingItems).toHaveLength(0);
    expect(m2.falseAlarms).toBe(1);
    expect(m2.highCriticalFalseAlarms).toBe(1);
    const m3 = scoreContract(key(), snap(), { adjudication: parseAdjudication({ 'T01|clause:3': 'true_issue' }) });
    expect(m3.extraTrueIssues).toBe(1);
    expect(m3.truePositiveItems).toBe(m3.confirmedItems);
  });

  it('المقبول بقرار مالك لا يُعدّ إنذاراً كاذباً', () => {
    const k = key({ acceptable: [{ id: 'A1', clause: 3, reason: 'قرار المالك' }] });
    const m = scoreContract(k, snap());
    expect(m.acceptableItems).toBe(1);
    expect(m.pendingItems).toHaveLength(0);
  });

  it('الاقتباس: يكشف غير الحرفى ويقبل المقتطع', () => {
    expect(quoteFoundIn('سداد المبلغ…عند التسليم', 'يتم سداد المبلغ كاملاً عند التسليم')).toBe(true);
    expect(quoteFoundIn('عبارة لا وجود لها فى النص أبداً', 'نص آخر تماماً')).toBe(false);
    expect(quoteFoundIn('قصير', 'قصير')).toBe(false);
    const bad = snap();
    bad.clauses[0].verification = { status: 'confirmed', reason: 'ok', quote: 'اقتباس مختلق لم يرد فى نص البند إطلاقاً' };
    const m = scoreContract(key(), bad);
    expect(m.quotesMissing.length).toBe(1);
  });

  it('الاستشهادات: بنية مشوهة وغير مفهرسة', () => {
    const s = snap();
    s.clauses[0].matchedArticles = [{ law_no: 131, law_year: 1948, article_no: 999, snippet: 'نص' }, { law_no: 131, law_year: 1948, article_no: 0, snippet: '' }];
    const m = scoreContract(key(), s, { isIndexed: (_l, _y, a) => a !== 999 });
    expect(m.citationsMalformed).toBe(1);
    expect(m.citationsNotIndexed).toEqual([{ law_no: 131, law_year: 1948, article_no: 999 }]);
    expect(scoreContract(key(), s).citationsNotIndexed).toBeNull();
  });

  it('التجزئة والأطراف والمبالغ والتغطية', () => {
    const s = snap();
    s.clauses[0].clauseText += ' بمبلغ ٢٥٠,٠٠٠ جنيه';
    const m = scoreContract(key(), s);
    expect(m.segmentation).toBe(1);
    expect(m.parties).toBe('ok');
    expect(m.paymentSums).toEqual({ checked: 1, found: 1 });
    expect(m.coverage).toBeCloseTo(4 / 5);
    const m2 = scoreContract(key({ parties: { first: 'شركة أخرى' } }), s);
    expect(m2.parties).toBe('mismatch');
    expect(amountInText(250000, '250 000 جنيه')).toBe(true);
    expect(amountInText(250000, '2500 جنيه')).toBe(false);
    expect(amountInText(250000, '250,000 جنيه')).toBe(true);
  });
});

describe('Holdout: التجميد والصلاحية', () => {
  it('غير مجمَّد = غير صالح', () => {
    const k = key({ set: 'holdout' });
    expect(holdoutKeyProblems(k)).toHaveLength(1);
    expect(scoreContract(k, snap()).valid).toBe(false);
  });
  it('بصمة التجميد تكشف التعديل اللاحق', () => {
    const k = freezeKey(key({ set: 'holdout' }), new Date('2026-11-01T00:00:00Z'));
    expect(holdoutKeyProblems(k)).toHaveLength(0);
    expect(keyDigest(k)).toBe(k.frozen!.sha256);
    const tampered: EvalKey = { ...k, issues: k.issues.slice(1) };
    expect(holdoutKeyProblems(tampered)[0]).toContain('تغيّر');
  });
  it('عقد رُفع قبل التجميد لا يصلح', () => {
    const k = freezeKey(key({ set: 'holdout' }), new Date('2026-11-20T00:00:00Z'));
    const m = scoreContract(k, snap());
    expect(m.valid).toBe(false);
    expect(m.invalidReasons.join(' ')).toContain('قبل تجميد');
  });
  it('مفتاح مجمَّد قبل الرفع صالح', () => {
    const k = freezeKey(key({ set: 'holdout' }), new Date('2026-11-01T00:00:00Z'));
    expect(scoreContract(k, snap()).valid).toBe(true);
  });
  it('رمز اللقطة يجب أن يطابق المفتاح', () => {
    expect(scoreContract(key(), snap({ evalRef: 'OTHER' })).valid).toBe(false);
  });
});

describe('البوابات والقرار', () => {
  // عقد مثالى: كل ملاحظات المفتاح مؤكدة ولا شىء زائد
  const perfect = (): Snapshot =>
    snap({
      clauses: [
        clause(1, { assessmentStatus: NR, riskLevel: 'عالٍ', assessmentReasoning: 'جزائى', verification: { status: 'confirmed', reason: 'ok' } }),
        clause(2, { assessmentStatus: NR, riskLevel: 'متوسط', assessmentReasoning: 'مدة', verification: { status: 'confirmed', reason: 'ok' } }),
        clause(4, { assessmentStatus: NR, riskLevel: 'حرج', assessmentReasoning: 'قوة', verification: { status: 'confirmed', reason: 'ok' } }),
        clause(3), clause(5),
      ],
      contractFindings: [{ id: 'missing:warranty', kind: 'missing_clause', severity: 'عالٍ', title: 'لا ضمان', explanation: 'x', evidence: [], verification: { status: 'confirmed', reason: 'ok' } }],
    });

  it('K1: Go عند الاجتياز الكامل', () => {
    const rows = [scoreContract(key(), perfect())];
    const agg = aggregate(rows);
    expect(agg.recall).toBe(1);
    expect(agg.precision).toBe(1);
    const checks = evaluateGate('k1', agg);
    expect(finalVerdict(checks, rows, agg.pending).verdict).toBe('Go');
  });

  it('K1: No-Go عند إنذار كاذب عالٍ محكوم', () => {
    const rows = [scoreContract(key(), snap(), { adjudication: parseAdjudication({ 'T01|clause:3': 'false_alarm' }) })];
    const agg = aggregate(rows);
    const checks = evaluateGate('k1', agg);
    const v = finalVerdict(checks, rows, agg.pending);
    expect(v.verdict).toBe('No-Go');
    expect(v.reasons.join(' ')).toContain('إنذارات كاذبة');
  });

  it('معلّق بلا حكم = غير مكتمل وليس Go', () => {
    const rows = [scoreContract(key(), snap())];
    const agg = aggregate(rows);
    const v = finalVerdict(evaluateGate('k1', { ...agg, recall: 0.9, precision: 0.9 }), rows, agg.pending);
    expect(['غير مكتمل', 'No-Go']).toContain(v.verdict);
    expect(v.verdict).not.toBe('Go');
  });

  it('بوابة الخدمة: الاستشهادات غير المقيسة لا تعنى نجاحاً', () => {
    const rows = [scoreContract(key(), perfect())];
    const checks = evaluateGate('service', aggregate(rows));
    expect(checks.find((c) => c.id === 'citations')!.status).toBe('unmeasured');
    expect(finalVerdict(checks, rows, 0).verdict).not.toBe('Go');
  });

  it('عقد غير صالح يمنع أى حكم', () => {
    const rows = [scoreContract(key({ set: 'holdout' }), perfect())];
    const v = finalVerdict(evaluateGate('k1', aggregate(rows)), rows, 0);
    expect(v.verdict).toBe('غير صالح');
  });
});

describe('الثبات', () => {
  it('تشغيلان متطابقان = ثابت، ومختلفان = متذبذب', () => {
    const a = scoreContract(key(), snap(), { runIndex: 0 });
    const b = scoreContract(key(), snap(), { runIndex: 1 });
    expect(stability([a, b])[0]).toMatchObject({ jaccard: 1, stable: true, flapping: [] });
    const s2 = snap();
    s2.clauses[2].verification = { status: 'unconfirmed', reason: 'شك', basis: 'uncertain' };
    const c = scoreContract(key(), s2, { runIndex: 1 });
    const st = stability([a, c])[0];
    expect(st.stable).toBe(false);
    expect(st.flapping).toContain('clause:3');
    expect(stability([a])).toHaveLength(0);
  });
});

describe('التطبيع والقوالب والتقرير', () => {
  it('يقبل صيغة الـAPI ويُنبّه لغياب درجة الخطورة', () => {
    const s = normalizeSnapshot(
      { id: 'abc', created_at: '2026-11-10T00:00:00Z', clauses: [{ clause_index: 1, clause_label: 'البند 1', clause_text: 'نص', assessment_status: NR, matched_articles: null, verification: null }], contract_findings: [] },
      { evalRef: 'T9' },
    );
    expect(s.evalRef).toBe('T9');
    expect(s.notes.join(' ')).toContain('درجة الخطورة');
    expect(classifyItems(s)[0].severity).toBe('غير مصنَّف');
  });
  it('يرفض لقطة بلا رمز', () => {
    expect(() => normalizeSnapshot({ clauses: [] })).toThrow();
  });
  it('snapshotFromDbRows يبنى من صفوف القاعدة', () => {
    const s = snapshotFromDbRows(
      { id: 'c', created_at: new Date('2026-11-10T00:00:00Z'), contract_type: 'lease', extraction_warnings: ['w'], contract_findings: { findings: [{ id: 'missing:a', kind: 'missing_clause', severity: 'عالٍ', title: 't', explanation: 'e', evidence: [] }], parties: { first: 'أ', second: 'ب' } } },
      [{ clause_index: 1, clause_label: 'البند 1', clause_text: 'نص', assessment_status: NR, risk_level: 'حرج', matched_articles: [], verification: null }],
      'R1',
    );
    expect(s.uploadedAt).toBe('2026-11-10T00:00:00.000Z');
    expect(s.partyNames).toEqual({ first: 'أ', second: 'ب' });
    expect(s.clauses[0].riskLevel).toBe('حرج');
    expect(s.contractFindings).toHaveLength(1);
  });
  it('تحقق المفتاح', () => {
    expect(validateKey(key()).errors).toEqual([]);
    expect(validateKey({ ...key(), issues: [{ id: 'a', kind: 'absent', severity: 'عالٍ', topic: 't' }] }).errors.join(' ')).toContain('finding_ids');
    expect(validateKey({ ...key(), issues: [{ id: 'a', kind: 'clause', severity: 'عالٍ', topic: 't' }] }).errors.join(' ')).toContain('رقم البند');
  });
  it('قالب الأحكام والتقرير العربى', () => {
    const rows = [scoreContract(key(), snap())];
    const tpl = pendingTemplate(rows);
    expect(Object.keys(tpl)).toEqual(['T01|clause:3']);
    const agg = aggregate(rows);
    const checks = evaluateGate('k1', agg);
    const v = finalVerdict(checks, rows, agg.pending);
    const md = renderReport({ profile: 'k1', generatedAt: 'x', verdict: v.verdict, reasons: v.reasons, checks, aggregate: agg, contracts: rows, stability: [] });
    expect(md).toContain('القرار');
    expect(md).toContain('T01');
  });
});

describe('حارس: لا \\w فى ملفات الأداة (لا يطابق الحروف العربية)', () => {
  it.each(['text', 'classify', 'key', 'score', 'aggregate', 'normalize', 'report'])('%s.ts', (f) => {
    const src = readFileSync(join(__dirname, `${f}.ts`), 'utf8');
    const code = src.split('\n').filter((l) => !/^\s*(\/\/|\*|\/\*)/.test(l)).join('\n');
    expect(/\\w/.test(code)).toBe(false);
  });
});
