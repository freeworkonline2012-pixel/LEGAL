import { findAdverbialHeads } from './clause-headings-alt';
import { SegmentationService } from './segmentation.service';
import { damagedNumberClauseVerification } from './verification';
import { amountConflictWarnings, extractKeyTerms } from './key-terms';
import { articleInLawScope, lawScopeContext } from './law-scope';

describe('الجولة 69: عناوين «أولاً/ثانياً…» على قراءة ممسوحة مدموجة أو بضجيج', () => {
  const svc = new SegmentationService();

  it('ضجيج حرف مفرد قبل العنوان ورموز بينه وبين النقطتين لا يمنعان الالتقاط', () => {
    const t = [
      'عقد اتفاق أتعاب محاماة وتم الاتفاق على الآتى :',
      'أولاً : يقوم المكتب بمراجعة كافة القضايا التى ترفع على الشركة.',
      'ش ثانياً ‎٠: تقوم الشركة بسداد مبلغ وقدره سبعة آلاف جنيه شهرياً.',
      '| ثالثاً : يسرى هذا الاتفاق لمدة سنة واحدة تبدأ من 1/11/2018.',
    ].join('\n');
    expect(findAdverbialHeads(t).map((h) => h.declaredNumber)).toEqual([1, 2, 3]);
  });

  it('قراءة دمجت الأسطر فى فقرة واحدة: المرحلة الاحتياطية تلتقط العناوين ذات علامة الوقف', () => {
    const t =
      'عقد اتفاق أتعاب. وتم الاتفاق على الآتى : أولاً: يقوم المكتب بمراجعة القضايا. ثانياً: تسدد الشركة سبعة آلاف جنيه شهرياً. ثالثاً: يسرى الاتفاق سنة.';
    const r = svc.segment(t);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3]);
    expect(r.clauses[1].text).toContain('سبعة آلاف');
  });

  it('لا التقاط عابر: «أولاً:» مفردة أو كلمات عادية لا تصنع تقسيماً', () => {
    expect(findAdverbialHeads('نص عادى. أولاً: ملاحظة واحدة فقط ولا شىء بعدها فى العقد كله.')).toEqual([]);
    expect(findAdverbialHeads('ثانياً - وثالثاً - فقط جملتان داخل فقرة بلا تمهيد.')).toEqual([]);
  });

  it('تعريف الأطراف «أولاً: السادة/ … (طرف أول)» لا يُحسب بنداً فى المرحلة الاحتياطية أيضاً', () => {
    const t = 'تحرر بين كل من أولاً: السادة/ شركة النور ويمثلها فلان (طرف أول) ثانياً: مكتب الأمل للمحاماة (طرف ثان) وتم الاتفاق على الآتى أولاً: يؤدى المكتب الخدمات. ثانياً: تدفع الشركة الأتعاب. ثالثاً: ينتهى الاتفاق بنهاية السنة.';
    const heads = findAdverbialHeads(t);
    expect(heads.length).toBe(3);
    expect(t.slice(heads[0].markerStart, heads[0].markerStart + 8)).toContain('أولاً');
    expect(t.slice(heads[0].markerStart - 20, heads[0].markerStart)).toContain('الآتى');
  });
});

describe('الجولة 69: بند يبنى حكمه على رقم زيادة تالف', () => {
  const base = {
    clauseText: 'تزاد الأجرة سنوياً بنسبة 7610 اعتباراً من السنة الثانية.',
    assessmentStatus: 'يحتاج مراجعة',
    riskLevel: 'متوسط',
    assessmentReasoning: 'غموض فى عبارة الزيادة السنوية ("7610") يعرض المستأجر لالتزام غير محدد.',
  };
  it('يُوسم غير مؤكد حتمياً', () => {
    const v = damagedNumberClauseVerification(base);
    expect(v?.status).toBe('unconfirmed');
    expect(v?.basis).toBe('uncertain');
    expect(v?.reason).toContain('تالف');
  });
  it('لا يُوسم بند سليم الرقم ولا بند قيّمته القواعد ولا خطر منخفض ولا حكم غير متعلق بالزيادة', () => {
    expect(damagedNumberClauseVerification({ ...base, clauseText: 'تزاد الأجرة سنوياً بنسبة 10% اعتباراً من السنة الثانية.' })).toBeNull();
    expect(damagedNumberClauseVerification({ ...base, assessmentStatus: 'متوافق' })).toBeNull();
    expect(damagedNumberClauseVerification({ ...base, riskLevel: 'منخفض' })).toBeNull();
    expect(damagedNumberClauseVerification({ ...base, assessmentReasoning: 'مدة العقد غير محددة بوضوح.' })).toBeNull();
  });
});

describe('الجولة 69: المبالغ المكتوبة بالحروف', () => {
  it('«ثلاثة) أو خمسمائة جنيها» بدائل لا مبلغ 500', () => {
    const t = 'تدفع الأجرة بمبلغ (ثلاثة) او خمسمائة جنيها شهرياً.';
    const terms = extractKeyTerms([{ clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: t }]);
    expect(terms.some((x) => x.kind === 'amount' && /500/.test(String(x.value)) && !x.suspect)).toBe(false);
  });

  it('مبلغ سبقه رقم تالف يؤيده حسابياً مبلغ فى بند آخر (41,250 = 3 × 13,750) فلا تنبيه ولا «يلزم التحقق»', () => {
    const c1 = 'القيمة الإيجارية الشهرية مبلغ 0 جنيه ( ثلاثة عشر ألف وسبعمائة وخمسون جنيه مصرى فقط لا غير ) شهرياً.';
    const c2 = 'وتدفع كل ثلاثة أشهر 0 جنيه ( واحد واربعون الف ومائتان وخمسون جنيه مصرى فقط لا غير ) مقدماً.';
    const clauses = [
      { clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: c1 },
      { clauseIndex: 2, clauseLabel: 'البند الثانى', clauseTitle: null, clauseText: c2 },
    ];
    const terms = extractKeyTerms(clauses);
    expect(terms.filter((x) => x.kind === 'amount' && x.suspect).length).toBe(0);
    expect(amountConflictWarnings([c1, c2]).length).toBe(0);
    // وبند واحد فقط لا يكفى لتأييد نفسه
    expect(amountConflictWarnings([c1]).length).toBe(1);
  });

  it('تاريخ فى سياق «سجل تجارى» لا يظهر شرطاً رئيسياً', () => {
    const t = 'شركة النور سجل تجارى رقم 12345 بتاريخ 24/7/2017 ويقع مقرها بالقاهرة. تبدأ المدة من 1/12/2018.';
    const dates = extractKeyTerms([{ clauseIndex: 0, clauseLabel: 'نص سابق', clauseTitle: null, clauseText: t }])
      .filter((x) => x.kind === 'date')
      .map((x) => x.value);
    expect(dates).toEqual(['1/12/2018']);
  });
});

describe('الجولة 69: بوابة نطاق قانون 164 لسنة 2025 (الإيجار القديم)', () => {
  const law = { lawNo: 164, lawYear: 2025 };
  it('محجوب عن عقد إيجار سكنى حديث', () => {
    const ctx = lawScopeContext('عقد إيجار وحدة سكنية مدة سنة تبدأ فى 1/12/2018 وتخضع لأحكام القانون المدنى والقانون 4 لسنة 1996.', 'lease');
    expect(articleInLawScope(ctx, law)).toBe(false);
  });
  it('مقبول إذا أشار النص إلى الإيجار القديم أو القانونين 49/1977 و136/1981', () => {
    for (const t of ['عقد إيجار قديم لوحدة سكنية', 'عقد خاضع للقانون 136 لسنة 1981', 'مستأجر أصلى بموجب القانون 49 لسنة 1977', 'الامتداد القانونى للعقد لورثة المستأجر']) {
      expect(articleInLawScope(lawScopeContext(t, 'lease'), law)).toBe(true);
    }
  });
});

import { buildContractAuditReport, type AuditReportInput } from '../exports/audit-report/build';

describe('الجولة 69: لا طمأنة متبقية فى تقرير صفر بنود', () => {
  const NOW = new Date('2026-11-08T10:00:00Z');
  const inp: AuditReportInput = {
    contractId: 'abcdef12-0000-0000-0000-000000000000',
    originalFilename: 'عقد.pdf',
    uploadedAt: NOW,
    contractType: null,
    clientRole: null,
    clauses: [],
    approvedAt: null,
    approvalNote: null,
    generatedAt: NOW,
    brand: 'شيلد',
    extractionWarnings: ['لم يُعثَر على أى بند بترقيم مقروء'],
  };
  const text = JSON.stringify(buildContractAuditReport(inp).report.blocks);
  it('لا «من بقية البنود» ولا «لم تُرصد ملاحظات فى النطاق المقيَّس» ولا «لم تُرصد ملاحظات على مستوى العقد ككل»', () => {
    expect(text).not.toContain('من بقية البنود');
    expect(text).not.toContain('لم تُرصد ملاحظات فى النطاق المقيَّس');
    expect(text).not.toContain('لم تُرصد ملاحظات على مستوى العقد ككل');
  });
  it('التوصية صريحة: لا توصية آلية وتلزم مراجعة المحامى', () => {
    expect(text).toContain('لا توصية آلية');
  });
});

describe('الجولة 70: عقد أتعاب قصير بعنوانين وإعلان مشوَّه', () => {
  it('«علي الأني» تُحسب عبارة تمهيدية: عنوانان يكفيان', () => {
    const t = 'عقد اتفاق أتعاب\nوتم الاتفاق مع سيادتكم علي الأني :.\nأولاً : يقوم المكتب بمراجعة كافة القضايا التى ترفع على الشركة.\nثانياً : تسدد الشركة سبعة آلاف جنيه شهرياً للمكتب.\n';
    expect(findAdverbialHeads(t).map((h) => h.declaredNumber)).toEqual([1, 2]);
  });
  it('عنوانان بعد تعريف طرفين (طرف أول/ثان) وبلا عبارة إعلان: يُقبلان', () => {
    const t = 'تحرر بين السادة شركة النور (طرف أول) ومكتب الأمل (طرف ثان)\nأولاً : يؤدى المكتب الخدمات القانونية للشركة بالكامل.\nثانياً : تسدد الشركة الأتعاب شهرياً مقدماً للمكتب.\n';
    expect(findAdverbialHeads(t).length).toBe(2);
  });
  it('عنوانان فى خطاب بلا أطراف ولا إعلان: لا يُقبلان', () => {
    const t = 'تحية طيبة وبعد\nأولاً : نفيدكم بأن الطلب قيد الدراسة لدى الإدارة المختصة.\nثانياً : سنوافيكم بالرد خلال أيام قليلة بإذن الله.\n';
    expect(findAdverbialHeads(t)).toEqual([]);
  });
});


// أسطر عقد الأتعاب كما قرأها OCR الإنتاج فعلاً (سجل Railway 8 نوفمبر): العناوين «أولاً/ثانياً» تالفة فلا تتسلسل
const FEES_PROD = [
  'رن بارع ماه اتاحتخخخ م ١١', '. شارع عماد الدين بالقاهرة ٠', 'مكتب سلامة للاستشارات القانونبة', 'Salama_law@hotmail.com', 'عقد إتفاق أتعاب محاماه',
  ') في يوم الخميس الموافق ١رتنا/غ١ ٠', 'تحرر هذا العقد بين كل من', 'أولاً : السادة/ شركة أروب لتأمينات الممتلكات والمسئوليات مصر ومقرها شارع مصدق',
  'مصدق = الدفي -- الجيزة ويمثلها السيد الأستاذ/ بشار عدنان الحلبى', 'B by أول»', 'L : مكتب سلامة للمحاماة والأسدشارات القانونية الكائن مقره شارع عماد',
  'الدين - القاهرة ويمثله في الدوقيع علي هذا العقد الأستاذ فحى فهيم', '(g8 by', 'تمهيد', 'الأعمال التي يقوم بها المكتب لشركتكم وبباشرة قضايا التعويض',
  'Y مع سيادتكم علي Syl', 'ب - يلوم المكتب ابمراجعة ك8 القضايا الي ب علي - وإبداء الرأى القانونى', 'بالتتسيق مع إدارة قسم + العويضات" في قضايا لابين',
  'ثانياً: تقوم الشركة بسداد مبلغ وقدره سبعة آلاف وخمسمائة جنيه شهرياً للمكتب', 'اند سس', 's ¥ في ١ 11/17/7١ ريم', 'VAN من (G هذا الإنفاق Ty',
  'تجديده لمدة أو لمدد ممائلة بموافقة الطرفين.', 'شركة أروب لتأمينات الممتلكاث', 'والمسئوليات- مصر',
].join('\n');

describe('الجولة 71: عقد حقيقى تلفت عناوينه يُقيَّم نصه كله كبند واحد', () => {
  const svc = new SegmentationService();
  it('عقد الأتعاب كما قرأه الإنتاج: بند واحد «النص كله» بتنبيه صريح', () => {
    const r = svc.segment(FEES_PROD);
    expect(r.clauses.length).toBeGreaterThanOrEqual(2);
    expect(r.clauses.every((c) => c.declaredNumber === null && c.label.startsWith('فقرة تقريبية'))).toBe(true);
    expect(r.clauses.map((c) => c.text).join('\n')).toContain('سبعة آلاف وخمسمائة');
    expect(r.clauses.some((c) => c.text.includes('سبعة آلاف وخمسمائة') && c.text.includes('تقوم الشركة'))).toBe(true);
    // لا يُفقد من النص شىء: ضم الفقرات يعيد الأسطر كلها
    expect(r.clauses.map((c) => c.text).join('\n').replace(/\s+/g, ' ')).toBe(FEES_PROD.replace(/\s+/g, ' ').trim());
    expect(r.warnings.some((w) => w.includes('فقرات تقريبية'))).toBe(true);
    expect(r.warnings.some((w) => w.includes('تعذّر تقسيم العقد إلى بنود'))).toBe(true);
  });
  it('ملف مستندات أو نص بلا صيغة عقد أو نص أطول من الحد: يبقى صفر بنود', () => {
    const bundle = ['تحية طيبة وبعد', 'الموضوع : توريد وتركيب مصعد', 'محضر استلام ابتدائى للمصعد', 'Cheque No. 190000 Pay this cheque', 'بطاقة الرقم القومى', 'PACKING LIST'].join('\n').padEnd(400, ' ملاحظة');
    expect(svc.segment(bundle).clauses.length).toBe(0);
    expect(svc.segment('نص عادى لا صيغة عقد فيه '.repeat(30)).clauses.length).toBe(0);
    expect(svc.segment(FEES_PROD + '\n' + 'تحرر هذا العقد بين الطرفين. '.repeat(500)).clauses.length).toBe(0);
  });
  it('التقرير: لا «تعذّر التقسيم — لم يُستخرج أى بند» ويقول إن النص كله قُيِّم كبند واحد', () => {
    const NOW = new Date('2026-11-08T10:00:00Z');
    const r = buildContractAuditReport({
      contractId: 'abcdef12-0000-0000-0000-000000000000', originalFilename: 'عقد.pdf', uploadedAt: NOW, contractType: null, clientRole: null,
      clauses: [1, 2, 3].map((i) => ({ clauseIndex: i, clauseLabel: `فقرة تقريبية ${i}`, clauseTitle: null, clauseText: 'نص', assessmentStatus: 'سليم', assessmentReasoning: null, matchedArticles: [], riskLevel: null, suggestedWording: null, lawyerVerdict: null, lawyerNotes: null })),
      approvedAt: null, approvalNote: null, generatedAt: NOW, brand: 'شيلد',
      extractionWarnings: ['تعذّر تقسيم العقد إلى بنود (لا ترقيم)'],
    }).report;
    const val = (l: string) => r.cover.rows.find((x) => x.label === l)?.value ?? '';
    expect(val('عدد البنود')).toContain('3 فقرات تقريبية');
    expect(val('مستوى المخاطرة العام')).toContain('فقرات تقريبية');
  });
  it('تقرير صفر بنود لا يدّعى أن العقد أطول من الحد المعتمد', () => {
    const NOW = new Date('2026-11-08T10:00:00Z');
    const r = buildContractAuditReport({
      contractId: 'abcdef12-0000-0000-0000-000000000000', originalFilename: 'عقد.pdf', uploadedAt: NOW, contractType: null, clientRole: null, clauses: [],
      approvedAt: null, approvalNote: null, generatedAt: NOW, brand: 'شيلد', contractFindings: [], contractFindingsModel: 'skipped',
    } as AuditReportInput).report;
    const text = JSON.stringify(r.blocks);
    expect(text).not.toContain('أطول من الحد المعتمد');
    expect(text).toContain('لا توجد بنود متعددة يُقارَن بينها');
  });
});
