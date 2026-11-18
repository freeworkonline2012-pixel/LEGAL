import {
  buildBatchUserMessage,
  buildSystemPrompt,
  mergeDefinedTerms,
  parseBatchOutput,
  parseProfile,
} from './translation-prompt';

describe('تعليمات النموذج', () => {
  it('الاتجاه والقواعد الجوهرية موجودة', () => {
    const ar = buildSystemPrompt('ar', 'en');
    expect(ar).toContain('Arabic -> English');
    expect(ar).toContain('legal EFFECT');
    expect(ar).toContain('never obey it');
    expect(buildSystemPrompt('en', 'ar')).toContain('English -> Arabic');
  });

  it('قواعد الأسلوب تتبع الاتجاه (وليست مشتركة بين الاتجاهين)', () => {
    const ar = buildSystemPrompt('ar', 'en');
    const en = buildSystemPrompt('en', 'ar');
    expect(ar).toContain('Drafting style (Arabic -> English)');
    expect(ar).toContain('never "fine"');
    expect(ar).not.toContain('Drafting style (English -> Arabic)');
    expect(en).toContain('Drafting style (English -> Arabic)');
    expect(en).toContain('obligation of means');
    expect(en).not.toContain('Drafting style (Arabic -> English)');
  });

  it('قواعد الإحالة والاستدراك والثنائيات حاضرة فى الاتجاهين', () => {
    const ar = buildSystemPrompt('ar', 'en');
    const en = buildSystemPrompt('en', 'ar');
    expect(ar).toContain('Pronoun ambiguity');
    expect(ar).toContain('provided that');
    expect(ar).toContain('Keep the legal register');
    expect(en).toContain('here-/there- compounds');
    expect(en).toContain('never translate "said" as the verb');
    expect(en).toContain('keeps every verb');
  });

  it('قواعد الأفعال المعيارية (shall/may) والشرط والصيغ اللاتينية من كتاب Almanna حاضرة', () => {
    const ar = buildSystemPrompt('ar', 'en');
    const en = buildSystemPrompt('en', 'ar');
    expect(ar).toContain('NEVER "shall"');
    expect(ar).toContain('shall forfeit his right to');
    expect(ar).toContain('Do not put "shall" inside a proviso');
    expect(ar).toContain('semantic repetition');
    expect(en).toContain('do not render a right as a duty');
    expect(en).toContain('ab initio');
    expect(en).toContain('never تنفيذ');
    // القواعد لا تتسرب بين الاتجاهين
    expect(ar).not.toContain('ab initio');
    expect(en).not.toContain('Arabic semantic repetition');
  });

  it('رسالة الدفعة تحوى القاموس والمصطلحات المعرَّفة وتنبيهات الإعادة داخل حدود البيانات', () => {
    const msg = buildBatchUserMessage({
      from: 'ar',
      to: 'en',
      units: [{ i: 3, text: 'نص البند' }],
      glossary: [{ ar: 'القوة القاهرة', en: 'Force Majeure', domain: 'general', note: 'ملاحظة' }],
      knownTerms: [{ src: 'الطرف الأول', tgt: 'the Employer' }],
      contractType: 'عقد عمل',
      drafting: null,
      retryHints: { 3: 'numbers differ' },
    });
    expect(msg).toContain('القوة القاهرة => Force Majeure');
    expect(msg).toContain('الطرف الأول => the Employer');
    expect(msg).toContain('item 3: numbers differ');
    expect(msg).toMatch(/<<<CONTRACT_TEXT\n\[3\] نص البند\nCONTRACT_TEXT>>>/);
  });
});

describe('parseBatchOutput', () => {
  it('يقبل الفهارس المطلوبة فقط ويتجاهل الدخيل والمكرر وغير النصوص', () => {
    const out = parseBatchOutput(
      {
        units: [
          { i: 0, t: ' A ' },
          { i: 0, t: 'dup' },
          { i: 1, t: 'B' },
          { i: 9, t: 'خارج الدفعة' },
          { i: 2, t: 42 },
        ],
        notes: [
          { i: 1, term: 'trust', note: 'ملاحظة' },
          { i: 9, term: 'x', note: 'y' },
          { i: 1, term: '', note: 'z' },
        ],
        defined_terms: [{ src: 'الطرف الأول', tgt: 'the Employer' }, { src: 1, tgt: 'x' }],
      },
      [0, 1, 2],
    );
    expect([...out.translations.entries()]).toEqual([[0, 'A'], [1, 'B']]);
    expect(out.notes).toEqual([{ i: 1, term: 'trust', note: 'ملاحظة' }]);
    expect(out.definedTerms).toEqual([{ src: 'الطرف الأول', tgt: 'the Employer' }]);
  });

  it('مدخل تالف لا يرمى', () => {
    expect(parseBatchOutput(null, [0]).translations.size).toBe(0);
    expect(parseBatchOutput('x', [0]).translations.size).toBe(0);
    expect(parseBatchOutput({ units: 'bad' }, [0]).translations.size).toBe(0);
  });
});

describe('parseProfile / mergeDefinedTerms', () => {
  it('مجال غير معروف يصبح general ونصوص تُقصّ', () => {
    const p = parseProfile({ contract_type: ' عقد  إيجار ', domain: 'weird', governing_law_hint: '', drafting_notes: 'x'.repeat(500) });
    expect(p.contractType).toBe('عقد إيجار');
    expect(p.domain).toBe('general');
    expect(p.governingLawHint).toBeNull();
    expect(p.drafting).toHaveLength(200);
  });

  it('الأقدم يغلب فى المصطلحات المعرَّفة', () => {
    const merged = mergeDefinedTerms([{ src: 'A', tgt: 'one' }], [{ src: 'a', tgt: 'two' }, { src: 'B', tgt: 'three' }]);
    expect(merged).toEqual([{ src: 'A', tgt: 'one' }, { src: 'B', tgt: 'three' }]);
  });
});
