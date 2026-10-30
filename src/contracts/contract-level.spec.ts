import { readFileSync } from 'fs';
import { join } from 'path';
import {
  type LevelClause,
  checkMissingClauses,
  contractFamily,
  definesDuration,
  inferContractFamily,
  deterministicFindings,
  mergeFindings,
  validateModelFindings,
} from './contract-level';
import { SegmentationService } from './segmentation.service';

const text = readFileSync(join(__dirname, '__fixtures__', 'golden', 'synthetic-software-supply.txt'), 'utf-8');
const seg = new SegmentationService().segment(text);
const clauses: LevelClause[] = seg.clauses.map((c) => ({
  clauseIndex: c.index,
  clauseLabel: c.label,
  clauseTitle: c.title,
  clauseText: c.text,
}));
const SERVICES = 'عقد خدمات أو مقاولة أو توريد';
const find = (list: { id: string }[], id: string) => list.find((f) => f.id === id);

describe('contractFamily', () => {
  it.each([
    ['عقد إيجار', 'lease'],
    ['عقد بيع', 'sale'],
    [SERVICES, 'services'],
    ['عقد عمل', 'employment'],
    ['عقد شراكة أو استثمار', 'partnership'],
    ['عقد تمويل أو قرض', 'finance'],
    ['عقد وكالة أو سمسرة أو تسويق', 'agency'],
    ['عقد ترخيص أو امتياز تجارى', 'licence'],
    [null, 'unknown'],
  ])('%s ⇒ %s', (t, f) => expect(contractFamily(t as string | null)).toBe(f));
});

describe('definesDuration', () => {
  it('يعترف بمدة صريحة ولا يعتد بالإحالة إلى «مدة العقد»', () => {
    const n = (s: string) => s;
    expect(definesDuration(n('مده هذا العقد سنه واحده تبدا من تاريخ التوقيع'))).toBe(true);
    expect(definesDuration(n('مده العقد 3 سنوات'))).toBe(true);
    expect(definesDuration(n('ترخيص استخدام النظام لمده هذا العقد'))).toBe(false);
    expect(definesDuration(n('يسلم الطرف الاول النظام خلال تسعين يوما'))).toBe(false);
  });
});

describe('الفحوص الحتمية على العقد الذهبى المُصطنَع', () => {
  const list = deterministicFindings(clauses, { contractType: SERVICES, textMayBeIncomplete: false });

  it('G6: يرصد الإحالة إلى «مدة هذا العقد» دون مدة، باقتباس من البند الرابع، ولا يكرر بنداً ناقصاً للمدة', () => {
    const f = find(list, 'undefined:duration') as (typeof list)[number] & { evidence: Array<{ clauseIndex: number; quote: string }> };
    expect(f).toBeDefined();
    expect(f.evidence[0].clauseIndex).toBe(4);
    expect(f.evidence[0].quote).toContain('لمدة هذا العقد');
    expect(find(list, 'missing:duration')).toBeUndefined();
  });

  it('G5: يرصد رسم الاستضافة المتروك لما بعد التنفيذ كشرط مفتوح', () => {
    const open = list.filter((f) => f.id.startsWith('open:'));
    expect(open).toHaveLength(1);
    expect((open[0] as unknown as { evidence: Array<{ clauseIndex: number }> }).evidence[0].clauseIndex).toBe(6);
  });

  it('يرصد الإحالة إلى «الجدول المرفق» الذى لم يظهر نصه', () => {
    const f = find(list, 'undefined:attachment') as unknown as { evidence: Array<{ clauseIndex: number }> };
    expect(f).toBeDefined();
    expect(f.evidence[0].clauseIndex).toBe(2);
  });

  it('G10: يرصد البنود الناقصة لعقد خدمات (جزاء التأخير، القبول، الضمان، الإخطارات، التعديل)', () => {
    for (const id of ['delay_penalty', 'acceptance', 'warranty', 'notices', 'amendments']) {
      expect(find(list, `missing:${id}`)).toBeDefined();
    }
  });

  it('لا يرصد ما هو موجود فعلاً: السرية والقانون الواجب والقوة القاهرة والفسخ والدفع والملكية وحماية البيانات', () => {
    for (const id of ['confidentiality', 'governing_law', 'force_majeure', 'termination', 'payment', 'intellectual_property', 'data_protection']) {
      expect(find(list, `missing:${id}`)).toBeUndefined();
    }
  });

  it('كل اقتباس فى النتائج الحتمية موجود حرفياً فى بنده', () => {
    for (const f of list as unknown as Array<{ evidence: Array<{ clauseIndex: number; quote: string }> }>) {
      for (const e of f.evidence) {
        const c = clauses.find((x) => x.clauseIndex === e.clauseIndex)!;
        expect(c.clauseText.replace(/\s+/g, ' ')).toContain(e.quote.replace(/\s+/g, ' '));
      }
    }
  });

  it('عند تحذير قراءة آلية يُضاف تنبيه احتمال ضياع النص إلى البنود الناقصة', () => {
    const l = checkMissingClauses(clauses, { contractType: SERVICES, textMayBeIncomplete: true });
    expect(l.length).toBeGreaterThan(0);
    expect(l.every((f) => f.explanation.includes('قارن بالأصل'))).toBe(true);
  });

  it('نوع غير محدد: لا قوائم خاصة بنوع (لا جزاء تأخير ولا قبول)', () => {
    const l = deterministicFindings(clauses, { contractType: null, textMayBeIncomplete: false });
    expect(find(l, 'missing:delay_penalty')).toBeUndefined();
    expect(find(l, 'missing:acceptance')).toBeUndefined();
  });

  it('عقد إيجار: يطلب تسليم العين والتأمين والصيانة من عقد لا يذكرها', () => {
    const l = checkMissingClauses(clauses, { contractType: 'عقد إيجار', textMayBeIncomplete: false });
    for (const id of ['lease_handover', 'lease_deposit', 'lease_maintenance', 'lease_use']) expect(find(l, `missing:${id}`)).toBeDefined();
  });

  it('حين تُعرَّف مدة صريحة تزول الإحالة غير المعرَّفة', () => {
    const patched = clauses.map((c) => (c.clauseIndex === 4 ? { ...c, clauseText: `${c.clauseText} مدة هذا العقد ثلاث سنوات تبدأ من تاريخ التوقيع.` } : c));
    const l = deterministicFindings(patched, { contractType: SERVICES, textMayBeIncomplete: false });
    expect(find(l, 'undefined:duration')).toBeUndefined();
    expect(find(l, 'missing:duration')).toBeUndefined();
  });

  it('المرفق الظاهر كعنوان فى الملف يلغى تنبيه المرفق الغائب', () => {
    const patched = [...clauses, { clauseIndex: 16, clauseLabel: 'ملحق', clauseTitle: null, clauseText: 'ملحق رقم 1\nالجدول: ثلاث وحدات.' }];
    const l = deterministicFindings(patched, { contractType: SERVICES, textMayBeIncomplete: false });
    expect(find(l, 'undefined:attachment')).toBeUndefined();
  });
});

describe('validateModelFindings', () => {
  const ev = (idx: number, quote: string) => ({ clause_index: idx, quote });
  const good = {
    findings: [
      {
        kind: 'conflict',
        severity: 'عالٍ',
        title: 'تعارض الملكية',
        explanation: 'قد ينقل البند 13 ما يمنحه البند 5 للطرف الأول.',
        suggestion: 'توحيد الحكم',
        evidence: [ev(5, 'يظل النظام وشفرته المصدرية ملكاً للطرف الأول'), ev(13, 'وتنتقل ملكية ما نُفذ إلى الطرف الثانى')],
      },
    ],
  };

  it('G2: يقبل تعارضاً مسنداً باقتباسين حرفيين من بندين', () => {
    const r = validateModelFindings(good, clauses);
    expect(r).toHaveLength(1);
    expect(r[0].evidence.map((e) => e.clauseIndex)).toEqual([5, 13]);
    expect(r[0].source).toBe('model');
  });

  it('يُسقط التعارض إن كان أحد الاقتباسين غير موجود فى بنده', () => {
    const bad = { findings: [{ ...good.findings[0], evidence: [good.findings[0].evidence[0], ev(13, 'عبارة لا وجود لها فى البند إطلاقاً')] }] };
    expect(validateModelFindings(bad, clauses)).toHaveLength(0);
  });

  it('يُسقط التعارض إن جاء الدليلان من البند نفسه', () => {
    const same = { findings: [{ ...good.findings[0], evidence: [ev(13, 'وتنتقل ملكية ما نُفذ إلى الطرف الثانى'), ev(13, 'إذا أخل الطرف الأول بالتزام جوهرى')] }] };
    expect(validateModelFindings(same, clauses)).toHaveLength(0);
  });

  it('يرفض رقم بند غير موجود ونوعاً خارج القائمة ويخفّض الدرجة «حرج»', () => {
    const odd = {
      findings: [
        { ...good.findings[0], kind: 'legal_opinion' },
        { ...good.findings[0], kind: 'open_term', evidence: [ev(99, 'يظل النظام وشفرته المصدرية')] },
        { ...good.findings[0], kind: 'open_term', severity: 'حرج', evidence: [ev(6, 'تحدد رسوم الاستضافة بعد انتهاء التنفيذ')] },
      ],
    };
    const r = validateModelFindings(odd, clauses);
    expect(r).toHaveLength(1);
    expect(r[0].severity).toBe('متوسط');
  });

  it('مخرجات غير صالحة ⇒ لا نتائج', () => {
    expect(validateModelFindings(null, clauses)).toEqual([]);
    expect(validateModelFindings({ findings: 'x' }, clauses)).toEqual([]);
  });

  it('mergeFindings يحذف نتيجة النموذج المكررة لحتمية من النوع والبند نفسيهما', () => {
    const rules = deterministicFindings(clauses, { contractType: SERVICES, textMayBeIncomplete: false });
    const dup = validateModelFindings(
      { findings: [{ kind: 'open_term', severity: 'عالٍ', title: 'رسم الاستضافة', explanation: 'الرسم مفتوح وينفى بند آخر أى رسوم.', evidence: [ev(6, 'تحدد رسوم الاستضافة بعد انتهاء التنفيذ')] }] },
      clauses,
    );
    expect(dup).toHaveLength(1);
    const merged = mergeFindings(rules, dup);
    expect(merged.filter((f) => f.kind === 'open_term')).toHaveLength(1);
  });
});

describe('تصنيف الأنواع الإضافية (أنواع الموسوعة)', () => {
  it.each([
    ['عقد رهن حيازى', 'security'],
    ['عقد رهن رسمي', 'security'],
    ['عقد كفالة', 'security'],
    ['عقد هبة', 'gift'],
    ['عقد وديعة', 'deposit'],
    ['عقد عارية استعمال', 'deposit'],
    ['عقد صلح', 'settlement'],
    ['مخالصة نهائية', 'settlement'],
    ['عقد تأمين على الحياة', 'insurance'],
    ['اتفاقية عدم إفصاح', 'nda'],
    ['اتفاقية سرية المعلومات', 'nda'],
    ['عقد شركة تضامن', 'partnership'],
    ['عقد قرض', 'finance'],
    ['عقد تأجير تمويلى', 'finance'],
    ['عقد وكالة تجارية', 'agency'],
    ['عقد امتياز تجارى', 'licence'],
    ['عقد أتعاب محاماة', 'services'],
    ['عقد مقايضة', 'sale'],
  ])('%s ⇒ %s', (t, f) => {
    expect(contractFamily(t)).toBe(f);
  });
});

describe('inferContractFamily (من عنوان العقد)', () => {
  it.each([
    ['عقد رهن حيازى\nإنه فى يوم الأحد', 'security'],
    ['\nعقد بيع شقة سكنية بين السيد/ أحمد والسيد/ محمود', 'sale'],
    ['بسم الله\nاتفاقية عدم إفصاح بين شركة ألفا وشركة بيتا', 'nda'],
    ['نموذج عقد إيجار وحدة سكنية', 'lease'],
  ])('%j ⇒ %s', (t, f) => {
    expect(inferContractFamily(t)).toBe(f);
  });

  it('لا عنوان واضحاً أو أسماء أطراف فقط ⇒ unknown (لا تخمين)', () => {
    expect(inferContractFamily('')).toBe('unknown');
    expect(inferContractFamily(null)).toBe('unknown');
    expect(inferContractFamily('إنه فى يوم الأحد تحرر هذا العقد بين شركة ألفا للتجارة وشركة بيتا')).toBe('unknown');
    expect(inferContractFamily('العقد\nبين شركة ألفا والسيد أحمد')).toBe('unknown');
  });

  it('نوع المستخدم الصريح مقدَّم على العنوان؛ والاستنتاج يعمل حين لا نوع', () => {
    const gift = [
      { clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: 'وهب الطرف الأول للطرف الثانى الشىء المبين وصفه بعد هذا وقبل الموهوب له الهبة قبولاً تاماً نافذاً.' },
    ];
    const withTitle = checkMissingClauses(gift, { contractType: null, titleText: 'عقد هبة منقول', textMayBeIncomplete: false });
    expect(withTitle.some((f) => f.id === 'missing:gift_form')).toBe(false);
    expect(withTitle.some((f) => f.id === 'missing:gift_revocation')).toBe(true);
    const noTitle = checkMissingClauses(gift, { contractType: null, titleText: null, textMayBeIncomplete: false });
    expect(noTitle.some((f) => f.id.startsWith('missing:gift_'))).toBe(false);
    const stated = checkMissingClauses(gift, { contractType: 'عقد بيع', titleText: 'عقد هبة', textMayBeIncomplete: false });
    expect(stated.some((f) => f.id.startsWith('missing:gift_'))).toBe(false);
  });
});

describe('فحوص البنود الناقصة للأنواع الإضافية', () => {
  const mk = (txt: string): LevelClause[] => [{ clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: txt }];
  const filler = ' يلتزم الطرفان بتنفيذ هذا الاتفاق بحسن نية وفقاً لما تقضى به القواعد العامة وبما لا يخالف النظام العام.';
  const ids = (fs: { id: string }[]) => fs.map((f) => f.id);

  it('اتفاقية سرية بلا تعريف ولا مدة ⇒ تُعلن ناقصة، وببنودها تُرصد', () => {
    const bare = checkMissingClauses(mk('تتعهد الأطراف بالتعاون.' + filler), { contractType: 'اتفاقية عدم إفصاح', textMayBeIncomplete: false });
    expect(ids(bare)).toEqual(expect.arrayContaining(['missing:nda_definition', 'missing:nda_exceptions', 'missing:nda_duration', 'missing:nda_return', 'missing:nda_remedy']));
    const full = checkMissingClauses(
      mk(
        'يقصد بالمعلومات السرية كل ما يفصح عنه أحد الطرفين من بيانات. لا تشمل المعلومات السرية ما أصبح متاحاً للجمهور. يستمر الالتزام بالسرية لمدة ثلاث سنوات من تاريخ انتهاء الاتفاق. يلتزم المتلقى برد جميع المعلومات أو إتلافها عند الطلب. يلتزم المخل بالتعويض عن الأضرار.' + filler,
      ),
      { contractType: 'اتفاقية عدم إفصاح', textMayBeIncomplete: false },
    );
    expect(ids(full).filter((i) => i.startsWith('missing:nda_'))).toEqual([]);
  });

  it('رهن بلا بيع ولا فك ⇒ يعلن الناقص ولا يعلن ما ورد', () => {
    const r = checkMissingClauses(mk('رهن الطرف الأول العقار المبين حيازياً ضماناً لسداد الدين المضمون بمبلغ مائة ألف جنيه.' + filler), {
      contractType: 'عقد رهن',
      textMayBeIncomplete: false,
    });
    expect(ids(r)).toEqual(expect.arrayContaining(['missing:security_enforcement', 'missing:security_release']));
    expect(ids(r)).not.toContain('missing:security_debt');
  });

  it('تأمين: القسط وإخطار الحادث والاستثناءات', () => {
    const r = checkMissingClauses(mk('يؤمن الطرف الأول على المنشأة ضد الحريق والخطر المؤمن منه.' + filler), { contractType: 'عقد تأمين', textMayBeIncomplete: false });
    expect(ids(r)).toEqual(expect.arrayContaining(['missing:insurance_premium', 'missing:insurance_claim', 'missing:insurance_exclusions']));
    expect(ids(r)).not.toContain('missing:insurance_risk');
  });

  it('فحص قيد الترخيص لا ينطبق إلا على ترخيص العلامات', () => {
    const noTm = checkMissingClauses(mk('يرخص المرخص برنامج حاسب آلي للمرخص له لمدة سنة.' + filler), { contractType: 'عقد ترخيص', textMayBeIncomplete: false });
    expect(ids(noTm)).not.toContain('missing:licence_registration');
    const tm = checkMissingClauses(mk('يرخص المرخص باستعمال العلامة التجارية المسجلة للمرخص له لمدة سنة.' + filler), { contractType: 'عقد ترخيص', textMayBeIncomplete: false });
    expect(ids(tm)).toContain('missing:licence_registration');
  });
});
