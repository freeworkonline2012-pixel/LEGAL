import { clientSideOf, bodyDirectionWarning, requesterPartyFromBody } from './client-side';
import { checkMissingClauses, servicesSubtype, type LevelClause } from './contract-level';
import { officeRuleFindings } from './office-rules';
import { articleInLawScope, lawScopeContext } from './law-scope';
import { norm } from './playbook-util';

const clause = (i: number, title: string, text: string, label = `البند ${i}`): LevelClause => ({ clauseIndex: i, clauseLabel: label, clauseTitle: title, clauseText: text });

describe('الجولة 63: تصنيف جهة العميل من الصفة', () => {
  it('طالب الخدمة/الموكل/العميل ⇒ requester', () => {
    for (const r of ['طالب الخدمة (صاحب العمل/العميل)', 'الموكل', 'العميل', 'صاحب العمل']) expect(clientSideOf(r)).toBe('requester');
  });
  it('مقدم الخدمة/الوكيل/الوسيط/المقاول/المورد ⇒ provider', () => {
    for (const r of ['مقدم الخدمة', 'الوكيل', 'الوسيط', 'المقاول', 'المورد']) expect(clientSideOf(r)).toBe('provider');
  });
  it('الملتبس أو المجهول أو الفارغ ⇒ null (لا يُحجب شىء)', () => {
    for (const r of [null, '', 'المستأجر', 'العميل (وكيل المبيعات)']) expect(clientSideOf(r)).toBeNull();
  });
});

describe('الجولة 63: قواعد المكتب بحسب جهة العميل', () => {
  const c0174: LevelClause[] = [
    clause(1, 'موضوع العقد', 'يلتزم الطرف الأول بتقديم خدمات التحصيل الإلكترونى لأقساط الوثائق من عملاء الطرف الثانى.', 'البند الأول'),
    clause(3, 'التحصيل', 'يقوم الطرف الأول بتحصيل أقساط الوثائق من عملاء الطرف الثانى وإرسال التقارير الدورية.', 'البند الثالث'),
    clause(
      4,
      'العمولات وآلية التحويل',
      '4-1 تحسب عمولات التحصيل كالتالى:\nأقل من 5000000: 1.3%\n5000000:10000000: 1.2%\nأكبر من 10000000: 1.1%\nعمولة المحافظ الإلكترونية 1.8% + 2 جنيه.\nجميع هذه العمولات غير متضمنة ضريبة القيمة المضافة.\n4-2 يتم تحويل إجمالى المبالغ المحصلة أسبوعياً بعد استلامها.',
      'البند الرابع',
    ),
    clause(6, 'السرية', 'يلتزم الطرفان بالحفاظ على سرية المعلومات.', 'البند السادس'),
    clause(9, 'الاختصاص', '9-1 تختص المحاكم المختصة بجمهورية مصر العربية بنظر النزاع.', 'البند التاسع'),
    clause(10, 'أحكام عامة', '10-4 لا يجوز للعميل — فى أى وقت طوال مدة هذا العقد — التعاون أو العمل بأى شكل من الأشكال مع أى جهة قد تكون من المنافسين لمقدم الخدمة.', 'البند العاشر'),
  ];
  const ids = (role: string | null) => officeRuleFindings(c0174, { contractType: 'خدمات', textMayBeIncomplete: false, clientRole: role }).map((f) => f.id.replace('office:', ''));
  const REQUESTER_ONLY = ['exclusivity_binds_client', 'collected_funds_transfer_terms', 'collected_funds_no_audit_right', 'collected_funds_no_segregation', 'commission_tiers_ambiguous', 'fixed_fee_plus_percent_unspecified', 'fees_exclusive_of_vat'];

  it('عميل طالب خدمة: تظهر قواعد حمايته', () => {
    const got = ids('طالب الخدمة');
    for (const r of ['collected_funds_transfer_terms', 'fees_exclusive_of_vat', 'exclusivity_binds_client', 'commission_tiers_ambiguous']) expect(got).toContain(r);
  });
  it('صفة غير محددة: يبقى السلوك السابق (تظهر)', () => {
    const got = ids(null);
    for (const r of ['collected_funds_transfer_terms', 'fees_exclusive_of_vat', 'exclusivity_binds_client']) expect(got).toContain(r);
  });
  it('عميل مقدّم خدمة: تُحجب القواعد السبع المصاغة لحماية طالب الخدمة', () => {
    const got = ids('مقدم الخدمة');
    for (const r of REQUESTER_ONLY) expect(got).not.toContain(r);
  });
  it('قواعد «الطرفان» تبقى ظاهرة لمقدّم الخدمة (المحكمة غير المحددة، السرية، حدود المسئولية)', () => {
    const got = ids('مقدم الخدمة');
    expect(got).toContain('court_not_specified');
    expect(got).toContain('confidentiality_breach_consequence');
    expect(got).toContain('no_liability_and_indemnity_terms');
  });
});

describe('الجولة 63: تنبيه الاتجاه من متن العقد (ديباجة ممسوحة غير مقروءة)', () => {
  const parties = { first: 'فورى لتكنولوجيا البنوك والمدفوعات الإلكترونية', second: 'أروب لتأمينات الممتلكات والمسئوليات' };
  const body = [
    'التعريفات: مقدم الخدمة هو الطرف الأول.',
    'العميل: شركة أروب لتأمين الممتلكات والمسئوليات ش.م.م. العنوان: 80 شارع مصدق - الدقى — محافظة الجيزة',
  ];
  it('يستخلص طالب الخدمة من بند «العميل: شركة …» ويربطه بالطرف الثانى', () => {
    expect(requesterPartyFromBody(body, parties)?.requesterParty).toBe('second');
  });
  it('صفة طالب الخدمة مع الطرف الأول (وهو مقدّم الخدمة) ⇒ تنبيه', () => {
    const w = bodyDirectionWarning('طالب الخدمة', 'first', body, parties);
    expect(w).toContain('تنبيه اتجاه');
    expect(w).toContain('الطرف الثانى');
  });
  it('صفة طالب الخدمة مع الطرف الثانى ⇒ لا تنبيه؛ وصفة مقدّم الخدمة مع الطرف الأول ⇒ لا تنبيه', () => {
    expect(bodyDirectionWarning('طالب الخدمة', 'second', body, parties)).toBeNull();
    expect(bodyDirectionWarning('مقدم الخدمة', 'first', body, parties)).toBeNull();
  });
  it('صفة مقدّم الخدمة مع الطرف الثانى (وهو العميل) ⇒ تنبيه', () => {
    expect(bodyDirectionWarning('مقدم الخدمة', 'second', body, parties)).toContain('تنبيه اتجاه');
  });
  it('فشل مغلق: اسم لا يطابق أى طرف، أو تعريفان متعارضان، أو أسماء الأطراف مجهولة ⇒ لا تنبيه', () => {
    expect(bodyDirectionWarning('طالب الخدمة', 'first', ['العميل: شركة نور للتجارة ش.م.م.'], parties)).toBeNull();
    const conflicting = [...body, 'العميل: شركة فورى لتكنولوجيا البنوك'];
    expect(bodyDirectionWarning('طالب الخدمة', 'first', conflicting, parties)).toBeNull();
    expect(bodyDirectionWarning('طالب الخدمة', 'first', body, { first: null, second: null })).toBeNull();
    expect(bodyDirectionWarning(null, 'first', body, parties)).toBeNull();
    expect(bodyDirectionWarning('طالب الخدمة', null, body, parties)).toBeNull();
  });
});

describe('الجولة 63: لزوم البنود بحسب النوع الفرعى لعقد الخدمات', () => {
  const collection: LevelClause[] = [
    clause(1, 'موضوع العقد', 'يقدم مقدم الخدمة خدمات تحصيل أقساط الوثائق من عملاء العميل ويحول المبالغ المحصلة إلى حساب العميل.', 'البند الأول'),
    clause(2, 'التحصيل', 'يتم تحصيل الأقساط وإرسال تقرير بالمتحصلات يومياً، وتحويل الحصيلة إلى العميل.', 'البند الثانى'),
    clause(3, 'العمولة', 'تحسب عمولة التحصيل بنسبة 1% من المبالغ المحصلة.', 'البند الثالث'),
  ];
  const works: LevelClause[] = [
    clause(1, 'موضوع العقد', 'يلتزم المقاول بتنفيذ أعمال المقاولة الموضحة بالمقايسة وتسليمها فى المواعيد المحددة.', 'البند الأول'),
    clause(2, 'المستخلصات', 'يقدم المقاول مستخلصاً شهرياً بالأعمال المنفذة، ويصرف صاحب العمل قيمته بعد المراجعة.', 'البند الثانى'),
    clause(3, 'التنفيذ', 'ينفذ المقاول الأعمال وفق المواصفات تحت إشراف صاحب العمل.', 'البند الثالث'),
  ];
  const missing = (cs: LevelClause[]) => checkMissingClauses(cs, { contractType: 'خدمات', textMayBeIncomplete: false });
  it('يُستنتج النوع الفرعى من المتن', () => {
    expect(servicesSubtype(norm(collection.map((c) => c.clauseText).join(' ')))).toBe('collection');
    expect(servicesSubtype(norm(works.map((c) => c.clauseText).join(' ')))).toBe('works');
    expect(servicesSubtype(norm('نص قصير بلا مؤشرات'))).toBeNull();
  });
  it('تحصيل: الملكية الفكرية والضمان لا يُفحصان', () => {
    const ids = missing(collection).map((f) => f.id);
    expect(ids).not.toContain('missing:intellectual_property');
    expect(ids).not.toContain('missing:warranty');
    expect(ids).toContain('missing:force_majeure'); // قرار المستشار: لازم فى كل الأنواع
  });
  it('مقاولة: الضمان لازم بدرجته المعتادة، والملكية الفكرية لا تُفحص (قرار المالك، الجولة 90.1)', () => {
    const f = missing(works);
    expect(f.find((x) => x.id === 'missing:intellectual_property')).toBeUndefined();
    expect(f.find((x) => x.id === 'missing:warranty')?.severity).toBe('متوسط');
  });
  it('بلا نوع فرعى بيّن: يبقى السلوك السابق', () => {
    const generic = [clause(1, 'موضوع العقد', 'يقدم الطرف الأول خدمات استشارية للطرف الثانى مقابل أتعاب شهرية يتفق عليها الطرفان كتابة.', 'البند الأول')];
    expect(missing(generic).map((f) => f.id)).toContain('missing:intellectual_property');
  });
});

describe('الجولة 63: بوابة قانون حماية المستهلك 181/2018', () => {
  const consumerLaw = { lawNo: 181, lawYear: 2018 };
  it('عقد تحصيل بين شركتين لا يشير إلى مستهلك ⇒ يُحجب', () => {
    const t = 'يلتزم الطرف الأول بتقديم خدمات التحصيل الإلكترونى لأقساط الوثائق من عملاء الطرف الثانى شركة التأمين.';
    expect(articleInLawScope(lawScopeContext(t, null), consumerLaw)).toBe(false);
  });
  it('محل العقد سلعة استهلاكية ⇒ يظهر ولو كان الطرفان شركتين', () => {
    const t = 'تبيع الشركة الأولى للشركة الثانية سلعاً استهلاكية معدة للبيع بالتجزئة للجمهور.';
    expect(articleInLawScope(lawScopeContext(t, 'sale'), consumerLaw)).toBe(true);
  });
  it('ذكر المستهلك صراحة ⇒ يظهر', () => {
    expect(articleInLawScope(lawScopeContext('يلتزم البائع بحقوق المستهلك وفق القانون.', 'sale'), consumerLaw)).toBe(true);
  });
  it('قوانين غير قطاعية لا تتأثر', () => {
    expect(articleInLawScope(lawScopeContext('نص', null), { lawNo: 131, lawYear: 1948 })).toBe(true);
  });
});
