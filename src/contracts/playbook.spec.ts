import { readFileSync } from 'fs';
import { join } from 'path';
import type { LevelClause } from './contract-level';
import { buildPlaybook, playbookFamily, playbookSide, type PlaybookFamily, type PlaybookSide } from './playbook';
import { PLAYBOOK_TOPICS } from './playbook-data';
import { durationDays, daysIn, hoursIn, norm, percentsIn } from './playbook-util';

const cl = (text: string, clauseIndex = 1, title: string | null = null): LevelClause => ({
  clauseIndex,
  clauseLabel: `البند ${clauseIndex}`,
  clauseTitle: title,
  clauseText: text,
});

describe('playbook-util', () => {
  it('durationDays: يوم/أسبوع/شهر/سنة', () => {
    expect(durationDays('30 يوماً')).toBe(30);
    expect(durationDays('2 أسبوعان')).toBe(14);
    expect(durationDays('3 أشهر')).toBe(90);
    expect(durationDays('2 سنتان')).toBe(730);
    expect(durationDays('غير ذلك')).toBeNull();
  });
  it('daysIn / percentsIn / hoursIn على جمل واحدة', () => {
    expect(daysIn('يسدد خلال ٦٠ يوماً')).toEqual([60]);
    expect(daysIn('مدة ثلاثة أشهر')).toEqual([90]);
    expect(percentsIn('غرامة 2 % عن كل يوم')).toEqual([2]);
    expect(hoursIn(norm('يعمل 10 ساعات يومياً'), 'day')).toEqual([10]);
    expect(hoursIn(norm('يعمل 60 ساعة أسبوعياً'), 'week')).toEqual([60]);
    expect(hoursIn(norm('يعمل 8 ساعات يومياً'), 'week')).toEqual([]);
  });
});

describe('تحديد النوع والصفة', () => {
  it('الأنواع المدعومة فقط', () => {
    expect(playbookFamily('عقد إيجار')).toBe('lease');
    expect(playbookFamily('عقد بيع')).toBe('sale');
    expect(playbookFamily('عقد خدمات أو مقاولة أو توريد')).toBe('services');
    expect(playbookFamily('عقد عمل')).toBe('employment');
    expect(playbookFamily('عقد شراكة أو استثمار')).toBe('partnership');
    expect(playbookFamily('عقد تمويل أو قرض')).toBe('finance');
    expect(playbookFamily('عقد وكالة أو سمسرة أو تسويق')).toBe('agency');
    expect(playbookFamily('عقد ترخيص أو امتياز تجارى')).toBe('licence');
    // أنواع تُعرف لفحوص البنود الناقصة فقط، ولا دليل تفاوضى لها بعد
    for (const t of ['عقد رهن', 'عقد كفالة', 'عقد هبة', 'عقد وديعة', 'عقد صلح', 'عقد تأمين', 'اتفاقية عدم إفصاح']) expect(playbookFamily(t)).toBeNull();
    expect(playbookFamily(null)).toBeNull();
  });

  const ROLES: Array<[PlaybookFamily, string, PlaybookSide]> = [
    ['lease', 'المؤجر (المالك)', 'a'],
    ['lease', 'المستأجر', 'b'],
    ['sale', 'البائع', 'a'],
    ['sale', 'المشترى', 'b'],
    ['services', 'مقدم الخدمة (المقاول / المورد)', 'a'],
    ['services', 'طالب الخدمة (صاحب العمل / العميل)', 'b'],
    ['services', 'الطرف الذى يقدّم الأداء الرئيسى (مؤجر / بائع / مقدم خدمة...)', 'a'],
    ['services', 'الطرف الذى يتلقى الأداء الرئيسى (مستأجر / مشترٍ / طالب خدمة...)', 'b'],
    ['employment', 'صاحب العمل', 'a'],
    ['employment', 'العامل', 'b'],
    ['partnership', 'الشريك المستثمر', 'a'],
    ['partnership', 'الشريك المدير أو صاحب المشروع', 'b'],
    ['finance', 'الممول (الدائن)', 'a'],
    ['finance', 'المقترض (المدين)', 'b'],
    ['agency', 'الموكِّل (صاحب المنتج أو الخدمة)', 'a'],
    ['agency', 'الوكيل أو السمسار', 'b'],
    ['licence', 'مانح الترخيص', 'a'],
    ['licence', 'المرخَّص له', 'b'],
  ];
  it.each(ROLES)('%s: «%s» ← %s', (family, role, side) => {
    expect(playbookSide(family, role)).toBe(side);
  });
  it('صفة غير مفهومة أو فارغة = null (دليل محايد) ولا تخمين', () => {
    expect(playbookSide('lease', 'وسيط')).toBeNull();
    expect(playbookSide('sale', null)).toBeNull();
    expect(playbookSide('employment', 'مدير الموارد البشرية')).toBeNull();
    // الصفة من نوع آخر لا تُقرأ بالخطأ لنوع العقد الحالى
    expect(playbookSide('sale', 'المستأجر')).toBeNull();
    expect(playbookSide('partnership', 'الشريك')).toBeNull();
    expect(playbookSide('licence', 'وسيط')).toBeNull();
    expect(playbookSide('finance', 'الوكيل أو السمسار')).toBeNull();
  });
});

// ---------- حراسة البيانات ----------

const MIG = (f: string): string => readFileSync(join(__dirname, '..', '..', 'migrations', f), 'utf-8');

function civilArticles(): Map<number, string> {
  const out = new Map<number, string>();
  const re = /SELECT id, (\d+), 0, \$(h\d+)\$[\s\S]*?\$\2\$, \$(b\d+)\$([\s\S]*?)\$\3\$/g;
  for (const m of MIG('074_seed_law_131_1948_civil_code.sql').matchAll(re)) out.set(Number(m[1]), m[4]);
  return out;
}

function labourArticles(): Map<number, string> {
  const sql = MIG('003_seed_real_laws.sql');
  const out = new Map<number, string>();
  const marker = 'FROM laws WHERE law_no = 14 AND law_year = 2025';
  let pos = -1;
  while ((pos = sql.indexOf(marker, pos + 1)) !== -1) {
    const start = sql.lastIndexOf('SELECT id, ', pos);
    const head = sql.slice(start, pos);
    const m = /^SELECT id, (\d+), \$(q\d+)\$[\s\S]*?\$\2\$, \$(q\d+)\$([\s\S]*?)\$\3\$\s*$/.exec(head);
    if (m) out.set(Number(m[1]), m[4]);
  }
  return out;
}

function ipArticles(): Map<number, string> {
  const out = new Map<number, string>();
  const re = /\((\d+),0,\$m239\$المادة (\d+)\$m239\$,\$m239\$([\s\S]*?)\$m239\$,'/g;
  for (const m of MIG('239_add_law_82_2002_intellectual_property_protection.sql').matchAll(re)) if (m[1] === m[2]) out.set(Number(m[1]), m[3]);
  return out;
}

/** كلمة مميِّزة يجب أن ترد فى نص كل مادة مستشهَد بها: تمنع رقماً صحيح الوجود لكن مضمونه غير ما كُتب فى الدليل. */
/** قانون 82/2002 (ترخيص العلامات 95–99، وتصرف المؤلف 149). */
const IP_ANCHORS: Record<number, string> = {
  95: 'دون استعمال مالك العلامة', 96: 'موثقا أو مصدقا', 97: 'التنازل عن عقد الترخيص', 98: 'مراقبة جودة', 149: 'مدة الاستغلال ومكانه',
};

const ANCHORS: Record<'civil' | 'labour', Record<number, string>> = {
  civil: {
    157: 'بعد إعذاره', 158: 'مفسوخا من تلقاء نفسه', 215: 'استحال', 217: 'القوة القاهرة', 221: 'ما لحق الدائن', 224: 'مبالغا فيه',
    423: 'الأسس', 424: 'السعر المتداول', 430: 'موقوفا على استيفاء', 431: 'بالحالة التى كان عليها', 437: 'انفسخ البيع', 439: 'عدم التعرض',
    445: 'ضمان الاستحقاق', 446: 'يقع باطلا', 447: 'عيب', 449: 'التحقق من حالته', 452: 'سنة من وقت تسليم', 453: 'تعمد إخفاء العيب',
    457: 'مستحق الوفاء', 459: 'يحبس المبيع', 462: 'الدمغة', 463: 'المكان الذى يوجد فيه المبيع', 464: 'نفقات تسلم', 562: 'أجرة المثل',
    563: 'نبه المتعاقد الآخر بالإخلاء', 564: 'يسلم المستأجر العين', 567: 'الترميمات الضرورية', 576: 'يضمن المؤجر', 579: 'يستعمل العين', 582: 'التأجيرية',
    585: 'يبادر', 586: 'وفاء الأجرة', 591: 'بالحالة التى تسلمها', 593: 'التنازل عن الإيجار', 594: 'يؤجر من الباطن',
    598: 'دون حاجة إلى تنبيه', 599: 'تجدد', 648: 'جودتها', 651: 'عشر سنوات', 653: 'إعفاء المهندس', 655: 'تسلمه', 656: 'يستحق دفع الأجر',
    657: 'مقايسة', 658: 'أجر إجمالى', 659: 'قيمة العمل', 663: 'يتحلل',
    // الجولة 33: الشراكة والقرض والوكالة والكفالة
    505: 'لاقتسام', 506: 'إجراءات النشر', 507: 'مكتوبا وإلا كان باطلا', 508: 'متساوية القيمة', 510: 'تعويض تكميلى', 514: 'بنسبة حصته',
    515: 'لا يساهم فى أرباح الشركة', 516: 'بالرغم من معارضة', 519: 'ممنوعون من الإدارة', 520: 'مفوضا من الآخرين', 521: 'يمتنع عن أى نشاط',
    523: 'مسئولين عن هذه الديون', 524: 'لا تضامن', 529: 'بانسحاب', 530: 'بحل الشركة', 531: 'بفصل', 532: 'تصفية أموال الشركة',
    226: 'أربعة فى المائة', 227: 'سبعة فى المائة', 232: 'متجمد الفوائد', 538: 'ملكية مبلغ من النقود', 539: 'فى الوقت المحدد',
    542: 'اعتبر القرض بغير أجر', 543: 'بانتهاء الميعاد', 544: 'تعجيل الوفاء',
    701: 'أعمال الإدارة', 702: 'وكالة خاصة', 703: 'حدودها المرسومة', 704: 'عناية الرجل المعتاد', 705: 'يقدم له حسابا', 706: 'مال الموكل لصالح نفسه',
    708: 'أناب الوكيل', 709: 'تبرعية', 710: 'ما أنفقه', 711: 'دون خطأ منه', 714: 'بموت الموكل', 715: 'ولو وجد اتفاق يخالف ذلك', 716: 'أن ينزل فى أى وقت',
    773: 'لا تثبت الكفالة إلا بالكتابة', 778: 'المبلغ المكفول', 780: 'أكبر مما هو مستحق', 788: 'بعد رجوعه على المدين', 793: 'لا يجوز للكفيل المتضامن',
  },
  labour: {
    6: 'يقع باطلا', 87: 'لمدة غير محددة', 88: 'غير مكتوب', 89: 'أربع نسخ', 90: 'ثلاثة أشهر', 91: 'يخرج على الشروط', 95: 'نفقات التدريب',
    107: 'أجر المثل', 117: 'ثمانى ساعات', 124: 'إجازة سنوية', 125: 'النزول عن إجازته', 136: 'الاحتفاظ لنفسه', 148: 'جزاء الفصل', 157: 'بمبرر مشروع',
  },
};

describe('حراسة بيانات الدليل التفاوضى', () => {
  const civil = civilArticles();
  const labour = labourArticles();

  it('المصدران مقروءان (القانون المدنى وقانون العمل 14/2025)', () => {
    expect(civil.size).toBeGreaterThan(1000);
    expect(labour.size).toBeGreaterThan(250);
  });

  it('كل مادة مستشهد بها موجودة فى النص المفهرس وتحمل الكلمة المميِّزة لمضمونها', () => {
    const cited: Array<['civil' | 'labour', number]> = [];
    for (const t of PLAYBOOK_TOPICS) for (const b of t.basis) if (b.article !== undefined && (b.law === 'civil' || b.law === 'labour')) cited.push([b.law, b.article]);
    expect(cited.length).toBeGreaterThan(40);
    for (const [law, n] of cited) {
      const body = (law === 'civil' ? civil : labour).get(n);
      expect(body).toBeDefined();
      const anchor = ANCHORS[law][n];
      expect(anchor).toBeDefined();
      expect(norm(body ?? '')).toContain(norm(anchor));
    }
  });

  it('مواد قانون 82/2002 المستشهد بها موجودة وتحمل الكلمة المميِّزة لمضمونها', () => {
    const ip = ipArticles();
    expect(ip.size).toBeGreaterThan(200);
    const cited = PLAYBOOK_TOPICS.flatMap((t) => t.basis.filter((b) => b.law === 'ip' && b.article !== undefined).map((b) => b.article as number));
    expect(cited.length).toBeGreaterThan(5);
    for (const n of cited) {
      expect(ip.get(n)).toBeDefined();
      expect(IP_ANCHORS[n]).toBeDefined();
      expect(norm(ip.get(n) ?? '')).toContain(norm(IP_ANCHORS[n]));
    }
  });

  it('كل رقم مادة يرد فى نص أى محور (ملاحظات، مواقف، أثر الغياب) مذكور فى سند المحور نفسه', () => {
    const cite = /المادة\s+(\d+)|المادتان\s+(\d+)\s+و\s*(\d+)|المادتين\s+(\d+)\s+و\s*(\d+)/g;
    for (const t of PLAYBOOK_TOPICS) {
      const basisNums = new Set(t.basis.map((b) => b.article).filter((a): a is number => a !== undefined));
      const texts = [t.ifMissing, ...t.flags.map((f) => f.note), ...t.basis.map((b) => b.note), ...Object.values(t.stance).flatMap((s) => [s.prefer, s.fallback, s.redLine])];
      for (const text of texts) {
        for (const m of text.matchAll(cite)) {
          for (const g of m.slice(1)) {
            if (g === undefined) continue;
            expect({ topic: t.id, article: Number(g), listed: basisNums.has(Number(g)) }).toEqual({ topic: t.id, article: Number(g), listed: true });
          }
        }
      }
    }
  });

  it('أنماط المطابقة مكتوبة على النص الموحَّد (بلا ة ى أ إ آ) وإلا لن تطابق شيئاً', () => {
    const bad: string[] = [];
    const check = (id: string, re?: RegExp) => {
      if (re && /[ةىأإآ]/.test(re.source)) bad.push(`${id}: ${re.source}`);
    };
    for (const t of PLAYBOOK_TOPICS) {
      check(`${t.id}.detect`, t.detect);
      for (const f of t.flags) {
        check(`${t.id}.${f.id}.pattern`, f.pattern);
        check(`${t.id}.${f.id}.unless`, f.unless);
      }
      for (const b of t.basis) check(`${t.id}.basis.when`, b.when);
    }
    expect(bad).toEqual([]);
  });

  it('بنية المحاور: معرّفات فريدة، ولكل نوع محاور، ولكل محور موقف كامل للطرفين، وكل علم له معرّف فريد داخل محوره', () => {
    const ids = PLAYBOOK_TOPICS.map((t) => t.id);
    expect(new Set(ids).size).toBe(ids.length);
    for (const fam of ['lease', 'sale', 'services', 'employment', 'partnership', 'finance', 'agency', 'licence'] as const) {
      expect(PLAYBOOK_TOPICS.filter((t) => t.families.includes(fam)).length).toBeGreaterThanOrEqual(6);
    }
    for (const t of PLAYBOOK_TOPICS) {
      for (const side of ['a', 'b'] as const) {
        expect(t.stance[side].prefer.length).toBeGreaterThan(20);
        expect(t.stance[side].fallback.length).toBeGreaterThan(10);
        expect(t.stance[side].redLine.length).toBeGreaterThan(10);
      }
      expect(t.ifMissing.length).toBeGreaterThan(20);
      const fids = t.flags.map((f) => f.id);
      expect(new Set(fids).size).toBe(fids.length);
      for (const f of t.flags) expect(Boolean(f.pattern) || Boolean(f.test)).toBe(true);
    }
  });
});

// ---------- أعلام الرصد: حالة موجبة وأخرى سالبة لكل علم ----------

type FlagCase = [topicId: string, flagId: string, positive: string, negative: string];

const FLAG_CASES: FlagCase[] = [
  ['lease_rent', 'rent_unilateral', 'للمؤجر زيادة الأجرة سنوياً بالنسبة التى يراها.', 'للمؤجر زيادة الأجرة سنوياً بنسبة لا تتجاوز 10 %.'],
  ['lease_rent', 'rent_long_prepay', 'يسدد المستأجر الأجرة مقدماً عن 12 شهراً.', 'يسدد المستأجر الأجرة مقدماً عن شهر واحد.'],
  ['lease_term', 'auto_renew', 'يتجدد العقد تلقائياً لمدة مماثلة.', 'يتجدد العقد تلقائياً لمدة مماثلة ما لم يخطر أحد الطرفين الآخر برغبته فى عدم التجديد.'],
  ['lease_term', 'early_exit_full_rent', 'فى حالة انهاء المستأجر للعقد قبل نهاية مدته يلتزم بسداد باقى الأجرة.', 'إذا أنهى المستأجر العقد قبل نهاية مدته أخطر المؤجر قبل شهرين.'],
  ['lease_deposit', 'deposit_forfeit', 'التأمين لا يرد للمستأجر فى أى حال.', 'يرد التأمين للمستأجر بعد التسليم.'],
  ['lease_deposit', 'deposit_no_return', 'يدفع المستأجر مبلغ تأمين قدره 40000 جنيه.', 'يدفع المستأجر مبلغ تأمين قدره 40000 جنيه يرد عند الإخلاء.'],
  ['lease_use', 'sublet_banned', 'لا يجوز للمستأجر التأجير من الباطن.', 'يجوز للمستأجر التأجير من الباطن بإذن كتابى.'],
  ['lease_use', 'sublet_free', 'يجوز للمستأجر الإيجار من الباطن دون موافقة المؤجر.', 'يجوز للمستأجر الإيجار من الباطن بموافقة المؤجر الكتابية.'],
  ['lease_maintenance', 'tenant_all_repairs', 'يتحمل المستأجر جميع الإصلاحات.', 'يتحمل المستأجر الترميمات التأجيرية البسيطة فقط.'],
  ['lease_maintenance', 'landlord_all_repairs', 'يتحمل المؤجر جميع الإصلاحات والصيانة.', 'يتحمل المؤجر الإصلاحات الإنشائية.'],
  ['lease_handover', 'waive_defects', 'عاين المستأجر العين المعاينة التامة النافية للجهالة.', 'تسلم المستأجر العين بموجب محضر تسليم موقع.'],
  ['lease_termination', 'auto_rescission', 'يعتبر العقد مفسوخاً من تلقاء نفسه عند التأخر.', 'يجوز للمؤجر طلب الفسخ بعد إنذار المستأجر.'],
  ['lease_termination', 'short_cure', 'إذا تأخر المستأجر عن سداد الأجرة 7 أيام جاز للمؤجر الفسخ.', 'إذا تأخر المستأجر عن سداد الأجرة 30 يوماً جاز للمؤجر الفسخ.'],
  ['lease_termination', 'tenant_free_exit', 'للمستأجر إنهاء العقد فى أى وقت بدون سبب.', 'للمستأجر إنهاء العقد بإخطار قبل شهرين.'],

  ['sale_price', 'full_prepay', 'يسدد المشترى كامل الثمن عند التوقيع.', 'يسدد المشترى الثمن على ثلاث دفعات.'],
  ['sale_price', 'nonrefundable', 'العربون لا يرد فى أى حال.', 'العربون يرد إذا أخل البائع بالتزامه.'],
  ['sale_delivery', 'soft_dates', 'مواعيد التسليم تقديرية.', 'موعد التسليم 1/2/2027 وبحد أقصى 15 يوماً.'],
  ['sale_delivery', 'early_risk_transfer', 'تنتقل تبعة الهلاك إلى المشترى من وقت التعاقد.', 'تنتقل تبعة الهلاك إلى المشترى من وقت التسليم الفعلى.'],
  ['sale_warranty', 'sold_as_is', 'يباع المبيع بحالته الراهنة.', 'يسلم البائع المبيع مطابقاً للمواصفات.'],
  ['sale_warranty', 'short_notice', 'يخطر المشترى بالعيب خلال 3 أيام من الاستلام.', 'يخطر المشترى بالعيب خلال 30 يوماً من الاستلام.'],
  ['sale_warranty', 'open_warranty', 'يقدم البائع ضماناً دائماً على المبيع.', 'يقدم البائع ضمان سنة واحدة.'],
  ['sale_title', 'no_title_warranty', 'لا يضمن البائع التعرض أو الاستحقاق.', 'يضمن البائع عدم التعرض.'],
  ['sale_inspection', 'deemed_acceptance', 'يعتبر المشترى قابلاً للمبيع بمجرد استلامه.', 'للمشترى فحص المبيع خلال 14 يوماً قبل القبول.'],
  ['sale_default', 'auto_rescission', 'يعتبر العقد مفسوخاً من تلقاء نفسه عند التأخر.', 'يجوز للبائع طلب الفسخ بعد إنذار المشترى.'],
  ['sale_default', 'penalty_no_cap', 'تفرض غرامة تأخير دون حد أقصى.', 'تفرض غرامة تأخير بحد أقصى 10 % من الثمن.'],
  ['sale_costs', 'prior_taxes_on_buyer', 'يتحمل الضرائب والرسوم المستحقة على المبيع قبل البيع على المشترى.', 'يتحمل البائع الضرائب والرسوم المستحقة قبل البيع.'],

  ['svc_scope', 'free_changes', 'يلتزم المقاول بأى تعديلات تطلب منه دون مقابل إضافى.', 'أى تعديلات تطلب بعد الاعتماد تُسعَّر بمقابل إضافى يتفق عليه كتابة.'],
  ['svc_payment', 'slow_pay', 'يسدد العميل الفاتورة خلال 90 يوماً من تقديمها.', 'يسدد العميل الفاتورة خلال 15 يوماً من تقديمها.'],
  ['svc_payment', 'retention', 'يحتجز العميل 10 % من كل دفعة حتى القبول النهائى.', 'يسدد العميل كل دفعة عند القبول.'],
  ['svc_payment', 'open_fee', 'رسوم الدعم الفنى سوف تتحدد بعد انتهاء فترة الضمان.', 'رسوم الدعم الفنى 5000 جنيه سنوياً.'],
  ['svc_payment', 'vat_exclusive', 'المبالغ الواردة فى هذا العقد لا تشمل ضريبة القيمة المضافة.', 'المبالغ الواردة فى هذا العقد شاملة جميع الضرائب.'],
  ['svc_payment', 'full_prepay', 'يسدد العميل كامل المقابل مقدماً قبل البدء.', 'يسدد العميل المقابل على دفعات مرتبطة بالمراحل.'],
  ['svc_acceptance', 'deemed_accept', 'يعتبر العمل مقبولاً بمجرد انقضاء 5 أيام دون اعتراض.', 'يفحص العميل العمل خلال 10 أيام ويخطر بملاحظاته.'],
  ['svc_acceptance', 'sole_discretion', 'يكون القبول وفقاً لتقدير العميل وحده.', 'يكون القبول وفق معايير القبول المرفقة بالملحق.'],
  ['svc_liability', 'unlimited', 'مسئولية المقاول غير محدودة عن كل الأضرار.', 'مسئولية المقاول غير محدودة عن الغش، ولا تتجاوز مسئوليته فى غير ذلك قيمة العقد.'],
  ['svc_liability', 'cap_on_provider', 'لا تتجاوز مسئولية مقدم الخدمة قيمة العقد.', 'لا تتجاوز مسئولية مقدم الخدمة قيمة العقد، ولا يسرى هذا السقف على الغش والخطأ الجسيم.'],
  ['svc_liability', 'exclusion_of_provider', 'لا يتحمل مقدم الخدمة أى مسئولية عن أى أضرار.', 'يتحمل مقدم الخدمة المسئولية عن إخلاله.'],
  ['svc_liability', 'exclusion_of_customer', 'لا يتحمل العميل أى مسئولية عن التأخير.', 'يتحمل العميل مسئولية التأخر فى السداد.'],
  ['svc_delay', 'no_cap', 'تفرض غرامة عن كل يوم تأخير.', 'تفرض غرامة عن كل يوم تأخير بحد أقصى 10 % من قيمة العقد.'],
  ['svc_delay', 'heavy_rate', 'غرامة 5 % عن كل أسبوع تأخير بحد أقصى 20 %.', 'غرامة 1 % عن كل أسبوع تأخير بحد أقصى 20 %.'],
  ['svc_termination', 'auto_rescission', 'يعتبر العقد مفسوخاً دون حاجة إلى إنذار عند الإخلال الجوهرى.', 'يجوز طلب الفسخ بعد إنذار الطرف المخل.'],
  ['svc_termination', 'convenience_no_comp', 'للعميل إنهاء العقد فى أى وقت بدون سبب ودون أى تعويض للمقاول.', 'للعميل إنهاء العقد فى أى وقت بإخطار قبل شهر مع سداد قيمة الأعمال المنفذة.'],
  ['svc_ip', 'limited_licence', 'يمنح المورد ترخيص استخدام غير حصرى للنظام.', 'تؤول ملكية النظام بالكامل للعميل بعد السداد.'],
  ['svc_ip', 'licence_term_bound', 'يمنح الطرف الأول الطرف الثانى رخصة استخدام البرامج وذلك خلال مدة هذا العقد.', 'يمنح الطرف الأول الطرف الثانى ترخيص دائم باستخدام البرامج.'],
  ['common_disputes', 'foreign_law_or_forum', 'يخضع هذا العقد للقانون الانجليزى وتختص محاكم لندن بالنظر فى أى نزاع.', 'يخضع هذا العقد للقانون المصرى وتختص محاكم القاهرة بالنظر فى أى نزاع.'],
  ['common_disputes', 'arbitration_unspecified', 'تحل المنازعات الناشئة عن هذا العقد بالتحكيم.', 'تحل المنازعات بالتحكيم وفق قواعد مركز القاهرة الإقليمى للتحكيم التجارى الدولى أمام ثلاثة محكمين.'],
  ['common_disputes', 'forum_without_governing_law', 'تختص محاكم القاهرة بالنظر فى أى نزاع ينشأ عن هذا العقد.', 'يخضع هذا العقد للقانون المصرى وتختص محاكم القاهرة بالنظر فى أى نزاع.'],
  ['svc_ip', 'supplier_owns_output', 'كافة حقوق الملكية الفكرية الخاصة بتلك البرامج تكون مملوكة للطرف الأول.', 'تؤول ملكية البرامج للعميل بعد السداد الكامل.'],
  ['svc_ip', 'assign_pre_existing', 'تؤول جميع حقوق الملكية الفكرية للعميل بما فى ذلك الأدوات السابقة الخاصة بمقدم الخدمة.', 'تؤول ملكية المخرجات المخصصة للعميل بعد السداد.'],
  ['svc_warranty', 'no_warranty', 'يسلم النظام كما هو عليه دون ضمان.', 'يقدم المورد ضمان 12 شهراً.'],
  ['svc_warranty', 'open_warranty', 'يقدم المقاول ضماناً مدى الحياة.', 'يقدم المقاول ضمان 12 شهراً.'],

  ['emp_probation', 'long_probation', 'فترة الاختبار مدتها ستة أشهر.', 'فترة الاختبار مدتها ثلاثة أشهر.'],
  ['emp_wage', 'inclusive_wage', 'الأجر شامل لجميع البدلات والعمل الإضافى.', 'الأجر الأساسى 8000 جنيه والبدلات تصرف بشكل منفصل.'],
  ['emp_wage', 'unilateral_wage_change', 'لصاحب العمل تعديل الأجر حسب الظروف.', 'لا يجوز تعديل الأجر إلا باتفاق كتابى.'],
  ['emp_hours', 'excess_hours', 'يعمل العامل 10 ساعات يومياً.', 'يعمل العامل 8 ساعات يومياً.'],
  ['emp_hours', 'excess_hours', 'يعمل العامل 60 ساعة أسبوعياً.', 'يعمل العامل 48 ساعة أسبوعياً.'],
  ['emp_hours', 'leave_waiver', 'يتنازل العامل عن الإجازة السنوية.', 'لا يجوز للعامل النزول عن الإجازة السنوية.'],
  ['emp_termination', 'at_will', 'لصاحب العمل إنهاء العقد فى أى وقت دون سبب.', 'لصاحب العمل إنهاء العقد لمبرر مشروع بإخطار كتابى.'],
  ['emp_termination', 'resignation_penalty', 'إذا استقال العامل دون إخطار التزم بسداد تعويض لصاحب العمل.', 'يحق للعامل الاستقالة بإخطار صاحب العمل قبل شهر.'],
  ['emp_noncompete', 'broad_noncompete', 'يلتزم العامل بعدم المنافسة لمدة 3 سنوات.', 'يلتزم العامل بعدم المنافسة لمدة ستة أشهر فى نفس المدينة.'],
  ['emp_insurance', 'employee_bears', 'يتحمل العامل حصة صاحب العمل فى التأمينات.', 'يسجل صاحب العمل العامل فى التأمينات من أول يوم.'],

  ['prt_form', 'verbal_amendments', 'يجوز تعديل هذا العقد شفاهة بين الشركاء.', 'لا يجوز تعديل هذا العقد إلا بملحق مكتوب موقع من الشركاء.'],
  ['prt_contribution', 'lump_sum_upfront', 'يسدد الشريك المستثمر كامل رأس المال عند التوقيع.', 'يسدد الشريك المستثمر رأس المال على دفعات مرتبطة بمراحل الإنجاز.'],
  ['prt_contribution', 'inkind_self_valued', 'تقدر الحصة العينية للشريك المدير بمعرفة الشريك المدير وحده.', 'تقدر الحصة العينية بمعرفة مقيم مستقل يتفق عليه الشركاء.'],
  ['prt_profit', 'loss_exempt', 'لا يتحمل الشريك المدير أي خسائر.', 'يتحمل كل شريك الخسائر بنسبة حصته.'],
  ['prt_profit', 'guaranteed_return', 'يضمن الشريك المدير للشريك المستثمر رأس ماله.', 'يتحمل المستثمر الخسارة بنسبة حصته في رأس المال.'],
  ['prt_profit', 'profit_discretion', 'يتم توزيع الأرباح وفقاً لتقدير الشريك المدير.', 'يتم توزيع الأرباح وفقاً لتقدير الشريك المدير خلال 30 يوماً من اعتماد الحسابات.'],
  ['prt_management', 'manager_sole_authority', 'ينفرد الشريك المدير بإدارة المشروع ويتخذ القرارات كلها.', 'ينفرد الشريك المدير بالإدارة اليومية باستثناء الاقتراض والرهن فيلزم موافقة المستثمر.'],
  ['prt_management', 'blanket_approval', 'لا يجوز للمدير إجراء أي تصرف دون موافقة المستثمر المكتوبة.', 'لا يجوز للمدير إجراء أي تصرف تتجاوز قيمته 100000 جنيه دون موافقة المستثمر.'],
  ['prt_info', 'no_inspection', 'لا يحق للشريك المستثمر الاطلاع على دفاتر الشركة.', 'يحق للشريك المستثمر الاطلاع على دفاتر الشركة في أي وقت.'],
  ['prt_noncompete', 'broad_noncompete', 'يلتزم المدير بعدم المنافسة لمدة 3 سنوات.', 'يلتزم المدير بعدم المنافسة لمدة ستة أشهر في نفس المدينة.'],
  ['prt_liability', 'joint_liability', 'يكون الشركاء مسئولين بالتضامن عن ديون الشركة.', 'يسأل كل شريك عن ديون الشركة بقدر حصته.'],
  ['prt_liability', 'personal_guarantee', 'يضمن الشريك المستثمر قروض الشركة بكفالة شخصية.', 'يسهم الشريك المستثمر برأس المال فقط.'],
  ['prt_exit', 'exit_barred', 'لا يجوز لأي شريك الانسحاب من الشركة قبل انتهاء مدتها.', 'لا يجوز لأي شريك الانسحاب إلا بموافقة باقي الشركاء.'],
  ['prt_exit', 'waive_dissolution', 'يتنازل كل شريك عن حقه في طلب حل الشركة.', 'يجوز لأي شريك طلب حل الشركة بحكم قضائي.'],
  ['prt_exit', 'exit_valuation_discretion', 'تقدر حصة الشريك الخارج بمعرفة الشريك المدير.', 'تقدر حصة الشريك الخارج بمعرفة خبير مقيم مستقل.'],

  ['fin_principal', 'lender_may_suspend', 'للممول إيقاف الصرف في أي وقت.', 'للممول إيقاف الصرف عند إخلال المقترض بأي التزام.'],
  ['fin_principal', 'fees_netted', 'تخصم الرسوم والعمولات من مبلغ القرض عند الصرف.', 'يسدد المقترض الرسوم والعمولات بشيك منفصل.'],
  ['fin_interest', 'rate_above_cap', 'يسدد المقترض فائدة سنوية قدرها 12 % من رصيد القرض.', 'يسدد المقترض فائدة سنوية قدرها 6 %.'],
  ['fin_interest', 'hidden_fee', 'يسدد المقترض عمولة ترتيب قدرها 3 % من مبلغ القرض.', 'يسدد المقترض رسوم دراسة ثابتة قدرها 5000 جنيه.'],
  ['fin_interest', 'compound_interest', 'تحتسب فوائد مركبة على الرصيد المتأخر.', 'تحتسب الفائدة بسيطة على الرصيد المتبقي.'],
  ['fin_interest', 'rate_unilateral', 'للممول تعديل سعر الفائدة في أي وقت.', 'للممول تعديل سعر الفائدة بما لا يزيد عن سعر الإقراض المعلن من البنك المركزي.'],
  ['fin_repayment', 'heavy_late_charge', 'في حالة التأخير في السداد تحتسب غرامة 3 % شهرياً.', 'في حالة التأخير في السداد تحتسب فائدة تأخير 1 % سنوياً.'],
  ['fin_default', 'acceleration_no_notice', 'تحل جميع الأقساط فوراً دون إنذار أو إخطار عند التأخر.', 'تحل جميع الأقساط بعد إخطار المقترض بمهلة 15 يوماً.'],
  ['fin_default', 'cross_default_broad', 'يعد المقترض مخلاً إذا تخلف عن أي التزام لدى أي بنك آخر.', 'يعد المقترض مخلاً إذا تخلف عن سداد أي قسط مستحق بموجب هذا العقد.'],
  ['fin_security', 'blank_instrument', 'يسلم المقترض شيكاً على بياض ضماناً للسداد.', 'يسلم المقترض شيكاً بالمبلغ والتاريخ المحددين في ملحق السداد.'],
  ['fin_security', 'open_guarantee', 'يكفل الكفيل المقترض كفالة مطلقة وغير محدودة بكافة ديونه.', 'يكفل الكفيل المقترض في حدود مبلغ 500000 جنيه ولمدة سنة.'],
  ['fin_security', 'guarantor_joint', 'يكون الكفيل متضامناً مع المدين في السداد.', 'يكون الكفيل غير متضامن ويحق له طلب تجريد المدين.'],
  ['fin_prepayment', 'prepay_penalty', 'يسدد المقترض رسم سداد مبكر قدره 2 % من الرصيد.', 'يحق للمقترض السداد المبكر في أي وقت دون أي رسوم.'],
  ['fin_prepayment', 'no_prepay', 'لا يجوز للمقترض السداد قبل الأجل المحدد.', 'يجوز للمقترض السداد المبكر بإخطار مسبق.'],

  ['agy_authority', 'broad_authority', 'يتمتع الوكيل بكافة الصلاحيات في التعاقد باسم الموكل.', 'يتمتع الوكيل بكافة الصلاحيات في حدود مبلغ 50000 جنيه للصفقة الواحدة.'],
  ['agy_authority', 'sub_agent_free', 'للوكيل إنابة غيره في تنفيذ الوكالة.', 'للوكيل إنابة غيره في تنفيذ الوكالة بعد موافقة الموكل الكتابية.'],
  ['agy_commission', 'commission_post_termination', 'تستحق العمولة عن الصفقات المبرمة بعد انتهاء العقد.', 'تستحق العمولة عن الصفقات المبرمة خلال مدة العقد فقط.'],
  ['agy_commission', 'commission_setoff', 'للموكل خصم أي مبالغ من العمولة المستحقة للوكيل.', 'للموكل خصم المرتجعات المؤكدة من العمولة.'],
  ['agy_commission', 'commission_on_collection', 'لا تستحق العمولة إلا بعد تحصيل الثمن كاملاً من العميل.', 'تستحق العمولة بمجرد إبرام الصفقة.'],
  ['agy_exclusivity', 'exclusive_no_target', 'يكون الوكيل وكيلاً حصرياً للموكل في إقليم القاهرة.', 'يكون الوكيل وكيلاً حصرياً في إقليم القاهرة بشرط تحقيق حد أدنى للمبيعات قدره مليون جنيه سنوياً.'],
  ['agy_exclusivity', 'principal_may_compete', 'للموكل تعيين وكلاء آخرين في الإقليم نفسه.', 'لا يعين الموكل وكلاء آخرين في الإقليم.'],
  ['agy_accounting', 'slow_remittance', 'يورد الوكيل المبالغ المحصلة إلى الموكل خلال 60 يوماً.', 'يورد الوكيل المبالغ المحصلة إلى الموكل خلال 7 أيام.'],
  ['agy_termination', 'principal_exit_barred', 'لا يجوز للموكل إنهاء الوكالة قبل انقضاء خمس سنوات.', 'لا يجوز للموكل إنهاء الوكالة إلا بإخطار قبل ثلاثة أشهر.'],
  ['agy_termination', 'agent_exit_barred', 'لا يجوز للوكيل التنازل عن الوكالة خلال مدة العقد.', 'لا يجوز للوكيل التنازل عن الوكالة إلا بإخطار قبل شهرين.'],
  ['agy_termination', 'heavy_termination_comp', 'يلتزم الموكل بتعويض الوكيل عند إنهاء العقد بما يعادل عمولة سنتين.', 'يحق للموكل إنهاء العقد بإخطار قبل ثلاثة أشهر دون تعويض.'],
  ['agy_liability', 'agent_guarantees_customers', 'يضمن الوكيل سداد العملاء لمستحقات الموكل.', 'يلتزم الوكيل بتقديم تقرير شهري عن العملاء.'],

  ['lic_scope', 'exclusive_no_minimum', 'يمنح المانح المرخص له ترخيصاً حصرياً لاستعمال العلامة في مصر.', 'يمنح المانح المرخص له ترخيصاً حصرياً في مصر بشرط حد أدنى للمبيعات السنوية.'],
  ['lic_scope', 'non_exclusive', 'الترخيص الممنوح غير حصري.', 'الترخيص الممنوح حصري.'],
  ['lic_scope', 'scope_unlimited', 'يسري الترخيص في جميع أنحاء العالم.', 'يسري الترخيص في جميع أنحاء العالم باستثناء الولايات المتحدة.'],
  ['lic_fees', 'minimum_royalty', 'يسدد المرخص له حداً أدنى للأتاوة قدره 100000 جنيه سنوياً.', 'يسدد المرخص له أتاوة بنسبة 5 % من صافي المبيعات.'],
  ['lic_fees', 'upfront_nonrefundable', 'يدفع المرخص له رسوم دخول غير قابلة للاسترداد.', 'يدفع المرخص له رسوم دخول تسترد جزئياً عند إنهاء المانح العقد دون سبب.'],
  ['lic_fees', 'royalty_gross_base', 'تحتسب الأتاوة بنسبة 6 % من إجمالي الإيرادات دون خصم أي مبالغ.', 'تحتسب الأتاوة بنسبة 6 % من صافي المبيعات بعد خصم المرتجعات.'],
  ['lic_term', 'licensor_terminate_anytime', 'للمانح إنهاء الترخيص في أي وقت.', 'للمانح إنهاء الترخيص عند إخلال المرخص له إخلالاً جوهرياً.'],
  ['lic_term', 'licensee_exit_balance', 'عند الإنهاء المبكر يسدد المرخص له باقي الأتاوة عن المدة المتبقية.', 'عند الإنهاء المبكر يسدد المرخص له الأتاوة المستحقة حتى تاريخ الإنهاء فقط.'],
  ['lic_quality', 'unilateral_standards', 'للمانح تعديل معايير الجودة ويلتزم المرخص له بتنفيذها على نفقته.', 'للمانح تعديل معايير الجودة بإخطار مسبق.'],
  ['lic_quality', 'no_quality_control', 'ليس للمانح حق الفحص أو الرقابة.', 'للمانح حق الفحص والتفتيش بإخطار مسبق.'],
  ['lic_ip', 'improvements_to_licensor', 'التحسينات التي يجريها المرخص له تؤول ملكيتها للمانح.', 'التحسينات المستقلة التي يبتكرها المرخص له تبقى ملكاً له.'],
  ['lic_ip', 'no_infringement_defence', 'لا يلتزم المانح بالدفاع عن العلامة ضد التعدي.', 'يلتزم المانح بالدفاع عن العلامة ضد التعدي.'],
  ['lic_transfer', 'free_assignment', 'يجوز للمرخص له التنازل عن الترخيص دون موافقة المانح.', 'يجوز للمرخص له التنازل عن الترخيص بموافقة المانح الكتابية.'],
  ['lic_transfer', 'no_assignment', 'لا يجوز للمرخص له التنازل عن الترخيص.', 'لا يجوز للمرخص له التنازل عن الترخيص إلا بموافقة المانح.'],
  ['lic_warranty', 'licensor_no_warranty', 'يمنح الترخيص دون ضمان لملكية المانح للحقوق.', 'يضمن المانح ملكيته للحقوق المرخصة.'],
  ['lic_warranty', 'licensee_unlimited_indemnity', 'يلتزم المرخص له بتعويض المانح عن جميع المطالبات والأضرار.', 'يلتزم المرخص له بتعويض المانح عن جميع المطالبات بحد أقصى مجموع الأتاوات المدفوعة.'],
];

function concernIds(topicId: string, flagId: string, text: string): string[] {
  const topic = PLAYBOOK_TOPICS.find((t) => t.id === topicId)!;
  const flag = topic.flags.find((f) => f.id === flagId)!;
  const family = topic.families[0];
  const side: PlaybookSide = flag.against === 'both' ? 'a' : flag.against;
  const role: Record<PlaybookFamily, Record<PlaybookSide, string>> = {
    lease: { a: 'المؤجر (المالك)', b: 'المستأجر' },
    sale: { a: 'البائع', b: 'المشترى' },
    services: { a: 'مقدم الخدمة (المقاول / المورد)', b: 'طالب الخدمة (صاحب العمل / العميل)' },
    employment: { a: 'صاحب العمل', b: 'العامل' },
    partnership: { a: 'الشريك المستثمر', b: 'الشريك المدير أو صاحب المشروع' },
    finance: { a: 'الممول (الدائن)', b: 'المقترض (المدين)' },
    agency: { a: 'الموكِّل (صاحب المنتج أو الخدمة)', b: 'الوكيل أو السمسار' },
    licence: { a: 'مانح الترخيص', b: 'المرخَّص له' },
  };
  const type: Record<PlaybookFamily, string> = {
    lease: 'عقد إيجار',
    sale: 'عقد بيع',
    services: 'عقد خدمات أو مقاولة أو توريد',
    employment: 'عقد عمل',
    partnership: 'عقد شراكة أو استثمار',
    finance: 'عقد تمويل أو قرض',
    agency: 'عقد وكالة أو سمسرة أو تسويق',
    licence: 'عقد ترخيص أو امتياز تجارى',
  };
  const pb = buildPlaybook({ contractType: type[family], clientRole: role[family][side], clientParty: side === 'b' ? 'second' : 'first', clauses: [cl(text)] });
  return pb!.rows.find((r) => r.topicId === topicId)!.concerns.map((c) => c.flagId);
}

describe('أعلام الرصد (حالة موجبة وأخرى سالبة لكل علم)', () => {
  it('كل علم معرَّف فى البيانات له حالة موجبة فى الجدول', () => {
    const tested = new Set(FLAG_CASES.map(([t, f]) => `${t}.${f}`));
    const all = PLAYBOOK_TOPICS.flatMap((t) => t.flags.map((f) => `${t.id}.${f.id}`));
    expect(all.filter((x) => !tested.has(x))).toEqual([]);
  });

  it.each(FLAG_CASES)('%s / %s', (topicId, flagId, positive, negative) => {
    expect(concernIds(topicId, flagId, positive)).toContain(flagId);
    expect(concernIds(topicId, flagId, negative)).not.toContain(flagId);
  });
});

describe('ملكية المخرجات لمقدم الخدمة (الترتيب لا الافتراض)', () => {
  const owns = 'كافة حقوق الملكية الفكرية الخاصة بتلك البرامج تكون مملوكة للطرف الأول.';
  const run = (clientParty: 'first' | 'second' | null, text = owns) =>
    buildPlaybook({ contractType: 'عقد خدمات أو مقاولة أو توريد', clientRole: 'طالب الخدمة (صاحب العمل / العميل)', clientParty, clauses: [cl(text)] })!
      .rows.find((r) => r.topicId === 'svc_ip')!;

  it('العميل هو الطرف الثانى والملكية للأول ⇒ ضد العميل', () => {
    const row = run('second');
    expect(row.status).toBe('concern');
    expect(row.concerns.map((c) => c.flagId)).toContain('supplier_owns_output');
    expect(row.concerns[0].against).toBe('b');
  });

  it('العميل هو الطرف الأول والملكية للأول ⇒ لا يُرصد ضده', () => {
    expect(run('first').concerns.map((c) => c.flagId)).not.toContain('supplier_owns_output');
  });

  it('ترتيب العميل غير معلوم ⇒ لا حكم بالترتيب (فاشل الأمان)', () => {
    expect(run(null).concerns.map((c) => c.flagId)).not.toContain('supplier_owns_output');
  });

  it('النص على ترخيص دائم أو إيداع الشفرة يُسقط الرصد', () => {
    expect(run('second', owns + ' ويمنح الطرف الأول الطرف الثانى ترخيص دائم باستخدامها.').concerns.map((c) => c.flagId)).not.toContain('supplier_owns_output');
  });
});

// ---------- السلوك العام ----------

describe('buildPlaybook', () => {
  const lease = [
    cl('المدة: مدة العقد ثلاث سنوات ويتجدد تلقائياً لمدة مماثلة.', 1),
    cl('الأجرة: القيمة الإيجارية الشهرية 20000 جنيه. وللمؤجر زيادة الأجرة سنوياً بالنسبة التى يقدرها.', 2),
  ];

  it('بلا نوع مدعوم أو بلا بنود = null', () => {
    expect(buildPlaybook({ contractType: 'عقد رهن', clientRole: 'الراهن', clauses: lease })).toBeNull();
    expect(buildPlaybook({ contractType: null, clientRole: null, clauses: lease })).toBeNull();
    expect(buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clauses: [] })).toBeNull();
  });

  it('صفة معروفة: موقف واحد، وأعلام الطرف الآخر لا تظهر ضد العميل', () => {
    const tenant = buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clauses: lease })!;
    const landlord = buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المؤجر (المالك)', clauses: lease })!;
    expect(tenant.side).toBe('b');
    expect(tenant.sideLabel).toBe('المستأجر');
    const rentT = tenant.rows.find((r) => r.topicId === 'lease_rent')!;
    const rentL = landlord.rows.find((r) => r.topicId === 'lease_rent')!;
    expect(rentT.status).toBe('concern');
    expect(rentL.status).toBe('found');
    expect(rentT.stance).toBe(PLAYBOOK_TOPICS.find((t) => t.id === 'lease_rent')!.stance.b);
    expect(rentT.bothStances).toBeNull();
    const termT = tenant.rows.find((r) => r.topicId === 'lease_term')!;
    const termL = landlord.rows.find((r) => r.topicId === 'lease_term')!;
    expect(termT.status).toBe('found');
    expect(termL.status).toBe('concern');
  });

  it('صفة غير محددة: موقفان وكل الملاحظات مع جهة الطرف المتضرر', () => {
    const pb = buildPlaybook({ contractType: 'عقد إيجار', clientRole: null, clauses: lease })!;
    expect(pb.side).toBeNull();
    expect(pb.sideLabel).toBeNull();
    const rent = pb.rows.find((r) => r.topicId === 'lease_rent')!;
    expect(rent.stance).toBeNull();
    expect(rent.bothStances?.map((b) => b.sideLabel)).toEqual(['المؤجر', 'المستأجر']);
    expect(rent.concerns[0].againstLabel).toBe('المستأجر');
    expect(pb.rows.find((r) => r.topicId === 'lease_term')!.concerns[0].againstLabel).toBe('المؤجر');
  });

  it('محور بلا نص = missing مع أثر الغياب والسند؛ ولا اقتباس', () => {
    const pb = buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clauses: lease })!;
    const dep = pb.rows.find((r) => r.topicId === 'lease_deposit')!;
    expect(dep.status).toBe('missing');
    expect(dep.evidence).toBeNull();
    expect(dep.concerns).toEqual([]);
    expect(dep.ifMissing.length).toBeGreaterThan(20);
    const hand = pb.rows.find((r) => r.topicId === 'lease_handover')!;
    expect(hand.status).toBe('missing');
    expect(hand.basis.map((b) => b.article)).toEqual([564, 576, 591]);
    expect(pb.counts.found + pb.counts.concern + pb.counts.missing).toBe(pb.rows.length);
  });

  it('كل اقتباس نص متصل من بنده، ولا يتجاوز 300 حرف، ويُرفض ما لا يطابق', () => {
    const long = 'وللمؤجر زيادة الأجرة سنوياً ' + 'بالنسبة التى يقدرها دون الرجوع إلى المستأجر '.repeat(12);
    const pb = buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clauses: [cl(`الأجرة: القيمة الإيجارية 5000 جنيه. ${long}`, 1)] })!;
    const q = pb.rows.find((r) => r.topicId === 'lease_rent')!.concerns[0].quote;
    expect(q.length).toBeLessThanOrEqual(300);
    expect(norm(`الأجرة: القيمة الإيجارية 5000 جنيه. ${long}`)).toContain(norm(q));
  });

  it('حتمى: النتيجة نفسها دائماً، وترتيب البنود في الإدخال لا يغيّرها', () => {
    const a = buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clauses: lease });
    const b = buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clauses: [...lease].reverse() });
    expect(b).toEqual(a);
  });

  it('عنوان البند المطابق يُفضَّل مصدراً للاقتباس على ذكر عابر لكلمة المحور في بند آخر', () => {
    const pb = buildPlaybook({
      contractType: 'عقد بيع',
      clientRole: 'المشترى',
      clauses: [cl('الثمن: يسدد المشترى الثمن قبل التسليم بيومين.', 1), cl('التسليم: يسلم البائع المبيع في مقر المشترى.', 2)],
    })!;
    expect(pb.rows.find((r) => r.topicId === 'sale_delivery')!.evidence?.clauseLabel).toBe('البند 2');
  });
});

describe('الجولة 30: قواعد عقد الخدمات المستخرجة من اختبار حى', () => {
  const run = (texts: string[], role = 'طالب الخدمة (صاحب العمل / العميل)') =>
    buildPlaybook({
      contractType: 'عقد خدمات أو مقاولة أو توريد',
      clientRole: role,
      clauses: texts.map((t, i) => cl(t, i + 1)),
    })!;
  const row = (pb: ReturnType<typeof run>, id: string) => pb.rows.find((r) => r.topicId === id)!;

  it('«بعد إنهاء تفعيل البرامج» فى بند السداد لا يُحسب نص إنهاء للعقد', () => {
    const pb = run(['الدفعة الثالثة : قيمتها 40% تسدد بعد إنهاء تفعيل البرامج.']);
    expect(row(pb, 'svc_termination').status).toBe('missing');
  });

  it('إنهاء العقد وفسخه يُرصدان', () => {
    const pb = run(['يحق للطرف الأول إنهاء هذا العقد بإخطار كتابى قبل ثلاثين يوماً.']);
    expect(row(pb, 'svc_termination').status).not.toBe('missing');
  });

  it('رسوم تتحدد لاحقاً تُنبَّه للعميل', () => {
    const pb = run(['رسوم الدعم الفنى سوف تتحدد بعد انتهاء فترة الضمان وفق تقدير الطرف الأول.']);
    expect(row(pb, 'svc_payment').concerns.map((c) => c.flagId)).toContain('open_fee');
  });

  it('أسعار غير شاملة للضريبة تُنبَّه للعميل ولا تُنبَّه لمقدم الخدمة', () => {
    const t = ['جميع المبالغ الواردة فى هذا العقد لا تشمل ضريبة القيمة المضافة.'];
    expect(row(run(t), 'svc_payment').concerns.map((c) => c.flagId)).toContain('vat_exclusive');
    expect(row(run(t, 'مقدم الخدمة (المقاول / المورد)'), 'svc_payment').concerns.map((c) => c.flagId)).not.toContain('vat_exclusive');
  });

  it('بقاء حقوق الملكية الفكرية للبرامج ملكاً لمقدم الخدمة يُنبَّه للعميل', () => {
    const pb = run(['تظل حقوق الملكية الفكرية للبرامج ملكاً للطرف الأول ويمنح الطرف الثانى حق الاستخدام.']);
    expect(row(pb, 'svc_ip').concerns.map((c) => c.flagId)).toContain('limited_licence');
  });
});
