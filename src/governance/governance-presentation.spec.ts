import { buildGovernancePresentation } from './governance-presentation';

const B = (n: number, st?: 'ساري' | 'معدّل' | 'ملغى' | 'غير محسوم') => ({
  law: 'قانون تجريبى',
  law_no: 80,
  law_year: 2002,
  article_no: n,
  snippet: 'نص المادة.',
  official_url: null,
  source_status: st,
});
const REC = (over: object = {}) => ({
  advice: 'غير موصى به',
  basis_type: 'database' as const,
  conditions_for_compliance: null,
  applicable_penalties: null,
  penalty_note: null,
  disclaimer: null,
  ...over,
});

describe('buildGovernancePresentation', () => {
  it('غير متوافق: جواب مباشر + توصية، الحكم موسوم تفسيراً، الأساس نص حرفى، وتنبيه غياب العقوبة', () => {
    const p = buildGovernancePresentation({
      verdict: 'غير متوافق',
      legal_basis: [B(12, 'ساري')],
      recommendation: REC(),
    });
    expect(p.direct_answer).toBe(
      'الإجراء غير متوافق مع النصوص القانونية المسترجَعة. التوصية: غير موصى به.',
    );
    expect(p.verdict_kind).toBe('تفسير');
    expect(p.basis[0]).toMatchObject({ text_kind: 'نص حرفي', source_status: 'ساري' });
    expect(p.open_issues.join()).toContain('لا يعنى عدم وجود عقوبة');
    expect(p.warnings).toEqual([]);
  });

  it('مصدر غير ساري/غير معروف يظهر تحذيراً، والمجهول يُعامَل غير محسوم', () => {
    const p = buildGovernancePresentation({
      verdict: 'متوافق',
      legal_basis: [B(1, 'ملغى'), B(2)],
      recommendation: REC({ advice: 'موصى به' }),
    });
    expect(p.warnings).toHaveLength(2);
    expect(p.warnings[0]).toContain('ملغاة');
    expect(p.warnings[1]).toContain('غير محسومة');
    expect(p.basis[1].source_status).toBe('غير محسوم');
  });

  it('متوافق جزئياً: الشروط تظهر كوقائع للتأكيد', () => {
    const p = buildGovernancePresentation({
      verdict: 'متوافق جزئياً',
      legal_basis: [B(3, 'ساري')],
      recommendation: REC({ advice: 'موصى به بشرط', conditions_for_compliance: ['إخطار الجهة الرقابية'] }),
    });
    expect(p.facts_to_confirm).toEqual(['تأكد من استيفاء: إخطار الجهة الرقابية']);
    expect(p.direct_answer).toContain('متوافق جزئياً');
  });

  it('معلومات غير كافية: بلا وسم حكم، مسألة مفتوحة، وتنويه الويب التكميلى إن وُجد', () => {
    const p = buildGovernancePresentation({
      verdict: 'معلومات غير كافية',
      legal_basis: [],
      recommendation: REC({ basis_type: 'web_supplementary', disclaimer: 'تنويه.' }),
    });
    expect(p.verdict_kind).toBeNull();
    expect(p.verdict_kind_note).toBeNull();
    expect(p.open_issues).toHaveLength(1);
    expect(p.warnings).toEqual(['تنويه.']);
    expect(p.direct_answer).not.toContain('التوصية');
  });

  it('مواد العقوبة غير السارية تدخل التحذيرات بلا تكرار', () => {
    const p = buildGovernancePresentation({
      verdict: 'غير متوافق',
      legal_basis: [B(12, 'ساري')],
      recommendation: REC({ applicable_penalties: [B(12, 'ساري'), B(15, 'ملغى')], penalty_note: 'ن' }),
    });
    expect(p.warnings).toHaveLength(1);
    expect(p.warnings[0]).toContain('المادة 15');
    expect(p.open_issues).toEqual([]);
  });

  it('recommendation=null لا يكسر البناء', () => {
    const p = buildGovernancePresentation({ verdict: 'متوافق', legal_basis: [B(1, 'ساري')], recommendation: null });
    expect(p.direct_answer).toBe('الإجراء متوافق مع النصوص القانونية المسترجَعة.');
  });
});
