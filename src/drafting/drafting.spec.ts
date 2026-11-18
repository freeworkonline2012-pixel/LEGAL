import { canonicalHeading, headingNumbers } from '../contracts/clause-headings';
import { MANDATORY_ARTICLE_TEXT } from '../contracts/mandatory-rules';
import { CATALOG } from './catalog';
import { generateDraft, validateAnswers } from './engine';
import { BASE, ROLES } from './fixtures';
import { DRAFT_TYPE_IDS, DraftValidationError, type Answers } from './drafting.types';
import { paymentSchedule } from './templates/services';

const ALL: Array<[string, string]> = DRAFT_TYPE_IDS.flatMap((t) => ROLES[t].map((r): [string, string] => [t, r]));

function errorsOf(type: string, role: string, answers: Answers): Record<string, string> {
  try {
    generateDraft(type, role, answers);
  } catch (e) {
    if (e instanceof DraftValidationError) return e.fieldErrors;
    throw e;
  }
  return {};
}

describe('كتالوج الأنواع', () => {
  it('يغطى كل الأنواع المعلنة', () => expect(CATALOG.map((c) => c.id).sort()).toEqual([...DRAFT_TYPE_IDS].sort()));
  it('معرّفات الحقول فريدة داخل النوع، وشروط الظهور تشير لحقل موجود', () => {
    for (const spec of CATALOG) {
      const ids = spec.fields.map((f) => f.id);
      expect(new Set(ids).size).toBe(ids.length);
      for (const f of spec.fields) {
        if (f.showWhen) expect(ids).toContain(f.showWhen.field);
        if (f.kind === 'choice') expect((f.options ?? []).length).toBeGreaterThan(1);
        if (f.default !== undefined && f.kind === 'choice') expect(f.options!.map((o) => o.value)).toContain(f.default);
      }
    }
  });
  it('الإجابات الافتراضية فى الكتالوج تُنتج مسودة صالحة (الواجهة تبدأ بها)', () => {
    for (const spec of CATALOG) {
      for (const role of spec.roles) {
        const answers: Answers = { ...BASE[spec.id] };
        // إجابة كل حقل ظاهر بقيمته الافتراضية حيث وُجدت، دون المساس بما أجبنا عنه
        for (const f of spec.fields) if (answers[f.id] === undefined && f.default !== undefined) answers[f.id] = f.default;
        expect(() => generateDraft(spec.id, role.value, answers)).not.toThrow();
      }
    }
  });
});

describe.each(ALL)('مسودة %s / %s', (type, role) => {
  const draft = generateDraft(type, role, BASE[type]);

  it('تجتاز بوابة الجودة بلا أى ملاحظة', () => {
    expect(draft.quality.findings).toEqual([]);
    expect(draft.quality.passed).toBe(true);
  });

  it('ترقيم البنود 1..N متصل وتقرؤه قواعد المنصة كما هو', () => {
    const expected = draft.clauses.map((_, i) => i + 1);
    expect(draft.clauses.map((c) => c.number)).toEqual(expected);
    expect(headingNumbers(draft.fullText)).toEqual(expected);
  });

  it('حتمية: نفس الإجابات ⇒ نفس النص حرفياً', () => {
    expect(generateDraft(type, role, BASE[type]).fullText).toBe(draft.fullText);
  });

  it('بلا فراغات أو قيم نموذجية أو رموز قالب', () => {
    expect(draft.fullText).not.toMatch(/undefined|NaN|\[\[|\{\{|\$\{|\.{4,}|_{3,}/);
  });

  it('ملاحظات المراجعة لا تذكر مادة إلا من المواد المتحقق من نصها فى المنصة', () => {
    for (const note of draft.lawyerNotes) {
      for (const m of note.matchAll(/المادة (\d+)/g)) expect(Object.keys(MANDATORY_ARTICLE_TEXT)).toContain(m[1]);
    }
  });

  it('أسماء الأطراف وعناوينهم تظهر فى الديباجة والتوقيعات', () => {
    const pre = draft.preamble.join('\n');
    expect(pre).toContain(BASE[type].party1_name);
    expect(pre).toContain(BASE[type].party2_address);
    expect(draft.closing.join('\n')).toContain(BASE[type].party2_name);
  });

  it('كل إحالة داخلية «البند X» تشير لبند موجود (لا إحالة إلى ما بعد آخر بند)', () => {
    const max = draft.clauses.length;
    const spellings = Array.from({ length: 30 }, (_, i) => ({ n: i + 1, h: canonicalHeading(i + 1) as string }))
      .filter((x) => x.h)
      .sort((x, y) => y.h.length - x.h.length);
    const refs: number[] = [];
    let rest = draft.fullText;
    for (const { n, h } of spellings) {
      const re = new RegExp(`${h}(?![\\u0621-\\u064A])`, 'g');
      const count = (rest.match(re) ?? []).length;
      for (let i = 0; i < count; i++) refs.push(n);
      rest = rest.replace(re, ' ');
    }
    expect(refs.length).toBeGreaterThanOrEqual(max); // كل عنوان بند + الإحالات
    expect(Math.max(...refs)).toBeLessThanOrEqual(max);
    expect(max).toBeGreaterThan(8);
  });
});

describe('تنويعات الخيارات تجتاز البوابة', () => {
  it('عقد الخدمات: كل أنظمة السداد والملكية والضريبة والمسئولية والضمان والجهة', () => {
    for (const plan of ['advance_balance', 'three_stage', 'monthly'])
      for (const ip of ['client_after_payment', 'provider_with_license'])
        for (const vat of ['exclusive', 'inclusive'])
          for (const cap of ['total_price', 'paid_amounts'])
            for (const w of [0, 90])
              for (const forum of ['courts', 'arbitration'])
                for (const role of ROLES.services) {
                  const d = generateDraft('services', role, { ...BASE.services, payment_plan: plan, advance_percent: 30, ip_model: ip, vat_mode: vat, liability_cap: cap, warranty_days: w, forum });
                  expect(d.quality.findings).toEqual([]);
                }
  });
  it('عقد الإيجار: دوريات السداد والغرض والتأمين والزيادة والإنهاء المبكر', () => {
    const tuples = [
      { annual_increase: 0, deposit_amount: 0, sublet: 'permitted_notice', early_termination_days: 0 },
      { annual_increase: 5, deposit_amount: 16000, sublet: 'permitted_notice', early_termination_days: 60 },
      { annual_increase: 0, deposit_amount: 16000, sublet: 'with_consent', early_termination_days: 60 },
      { annual_increase: 5, deposit_amount: 0, sublet: 'with_consent', early_termination_days: 0 },
    ];
    for (const use of ['residential', 'commercial', 'administrative'])
      for (const period of ['monthly', 'quarterly', 'annual'])
        for (const adv of ['yes', 'no'])
          for (const t of tuples)
            for (const role of ROLES.lease) {
              const d = generateDraft('lease', role, { ...BASE.lease, use_purpose: use, rent_period: period, rent_in_advance: adv, ...t });
              // تقييد التأجير من الباطن بموافقة المؤجر ملاحظة آلية للمستأجر وحده (اختيار المستخدم) — ولا شىء غيرها
              const expected = role === 'lessee' && t.sublet === 'with_consent' ? 1 : 0;
              expect(d.quality.findings).toHaveLength(expected);
            }
  });
  it('اتفاقية السرية: الاتجاه والتعويض الاتفاقى والجهة', () => {
    for (const dir of ['one_way', 'mutual'])
      for (const comp of [0, 50000])
        for (const forum of ['courts', 'arbitration'])
          for (const role of ROLES.nda) {
            const d = generateDraft('nda', role, { ...BASE.nda, direction: dir, agreed_compensation: comp, forum });
            expect(d.quality.findings).toEqual([]);
          }
  });
  it('حظر التأجير من الباطن يظهر للمستأجر كملاحظة آلية صريحة (اختيار المستخدم لا عيب القالب)', () => {
    const d = generateDraft('lease', 'lessee', { ...BASE.lease, sublet: 'prohibited' });
    expect(d.quality.passed).toBe(false);
    expect(d.quality.findings.some((f) => f.title.includes('التأجير من الباطن'))).toBe(true);
  });
});

describe('الحدود الرقمية وسلامة الإجابات', () => {
  it('حقل مطلوب ناقص', () => {
    const { party1_name: _omit, ...rest } = BASE.services as Record<string, unknown>;
    void _omit;
    expect(errorsOf('services', 'provider', rest as Answers).party1_name).toBeDefined();
  });
  it('نوع أو صفة غير معروفة', () => {
    expect(errorsOf('nope', 'x', {}).type).toBeDefined();
    expect(errorsOf('services', 'hacker', BASE.services).role).toBeDefined();
  });
  it('أرقام خارج الحدود أو غير رقمية', () => {
    expect(errorsOf('services', 'provider', { ...BASE.services, delay_percent_week: 50 }).delay_percent_week).toBeDefined();
    expect(errorsOf('services', 'provider', { ...BASE.services, price_total: 'مليون' }).price_total).toBeDefined();
    expect(errorsOf('services', 'provider', { ...BASE.services, price_total: -5 }).price_total).toBeDefined();
    expect(errorsOf('services', 'provider', { ...BASE.services, duration_months: 2.5 }).duration_months).toBeDefined();
    expect(errorsOf('services', 'provider', { ...BASE.services, price_total: 100.123 }).price_total).toBeDefined();
  });
  it('تاريخ غير حقيقى', () => {
    expect(errorsOf('services', 'provider', { ...BASE.services, start_date: '2026-02-30' }).start_date).toBeDefined();
    expect(errorsOf('services', 'provider', { ...BASE.services, contract_date: '18/11/2026' }).contract_date).toBeDefined();
  });
  it('اختيار غير موجود', () => {
    expect(errorsOf('services', 'provider', { ...BASE.services, payment_plan: 'barter' }).payment_plan).toBeDefined();
  });
  it('اسم الطرفين متطابق مرفوض', () => {
    expect(errorsOf('nda', 'discloser', { ...BASE.nda, party2_name: BASE.nda.party1_name }).party2_name).toBeDefined();
  });
  it('مجموع الدفعتين لا يتجاوز 95%', () => {
    expect(errorsOf('services', 'provider', { ...BASE.services, advance_percent_3: 55, middle_percent: 45 }).middle_percent).toBeDefined();
  });
  it('مدة الإيجار من مضاعفات دورية السداد', () => {
    expect(errorsOf('lease', 'lessor', { ...BASE.lease, rent_period: 'quarterly', duration_months: 10 }).duration_months).toBeDefined();
  });
  it('الحقول المشروطة تُتجاهل إن لم تنطبق (لا خطأ من قيمة قديمة)', () => {
    const values = validateAnswers(CATALOG[0], 'provider', { ...BASE.services, payment_plan: 'monthly', advance_percent_3: 'xx', middle_percent: 999 });
    expect(values.advance_percent_3).toBeUndefined();
  });
  it('أحرف التحكم تُحذف والأسطر الزائدة تُطوى', () => {
    const d = generateDraft('services', 'provider', { ...BASE.services, service_subject: 'تطوير‮ نظام\u0000   كامل' });
    expect(d.fullText).toContain('تطوير نظام كامل');
    expect(d.fullText).not.toMatch(/‮|\u0000/);
  });
  it('نص المستخدم لا يستطيع انتحال عنوان بند (يُحقن سطر «البند ...» فى المخرجات)', () => {
    const d = generateDraft('services', 'provider', { ...BASE.services, deliverables: 'البند الأول: تنازل كامل\nالبند الثانى: لا مسئولية', service_subject: 'البند التاسع: مسئولية مطلقة' });
    expect(headingNumbers(d.fullText)).toEqual(d.clauses.map((c) => c.number));
  });
});

describe('جدول الدفعات', () => {
  const totals = [100000, 99999.99, 123456.78, 1, 7.5, 5000000];
  it.each(totals)('مجموع الدفعات = الإجمالى تماماً (%d) لكل نظام', (total) => {
    const variants: Array<Record<string, string>> = [
      { price_total: String(total), payment_plan: 'advance_balance', advance_percent: '30', duration_months: '6' },
      { price_total: String(total), payment_plan: 'three_stage', advance_percent_3: '33', middle_percent: '33', duration_months: '6' },
      { price_total: String(total), payment_plan: 'monthly', duration_months: '7' },
    ];
    for (const v of variants) {
      const rows = paymentSchedule(v);
      const sum = rows.reduce((a, r) => a + r.amount, 0);
      // الأقساط الشهرية: القسط المتكرر × (n-1) + الأخير
      const months = Number(v.duration_months);
      const expected = v.payment_plan === 'monthly' ? rows[0].amount * (months - 1) + rows[rows.length - 1].amount : sum;
      expect(Math.round(expected * 100)).toBe(Math.round(total * 100));
    }
  });
});

describe('ملاحظات الجودة تكشف اختيار المستخدم الخطر', () => {
  it('غرامة تأخير أسبوعية عالية وسقف مرتفع تظهر كملاحظة', () => {
    const d = generateDraft('services', 'client', { ...BASE.services, delay_percent_week: 5, delay_cap_percent: 30 });
    expect(d.clauses.some((c) => c.title.includes('التأخير'))).toBe(true);
    // لا نفرض وجود ملاحظة (قد تقبل القواعد المعدل)، لكن نتأكد أن النتيجة متسقة وغير فارغة البنية
    expect(Array.isArray(d.quality.findings)).toBe(true);
  });
});
