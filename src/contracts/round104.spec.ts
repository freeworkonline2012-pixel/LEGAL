import { readFileSync } from 'fs';
import { join } from 'path';
import { SegmentationService } from './segmentation.service';
import { blankTemplateDiag, BLANK_TEMPLATE_FINDING_ID, findBlankSlots, isBlankSlotText, reclassifyBlankTemplate } from './blank-template';
import { type ContractFinding, type LevelClause } from './contract-level';
import { quoteInText } from './clause-facts';
import { findingAction } from '../exports/audit-report/recommendations';
import { BLANK_TEMPLATE_CONTEXT, contractContextFor } from './criteria.util';
import { formatClauseVerdict } from './retrieval-diagnostic';

const LLC = readFileSync(join(__dirname, '__fixtures__', 'r102', 'llc_template_local_ocr.txt'), 'utf8');

function llcClauses(): LevelClause[] {
  const r = new SegmentationService().segment(LLC);
  return r.clauses.map((c, i) => ({ clauseIndex: i + 1, clauseLabel: c.label ?? `المادة ${c.declaredNumber}`, clauseTitle: c.title ?? null, clauseText: c.text }));
}

const mk = (o: Partial<ContractFinding> & Pick<ContractFinding, 'id' | 'kind' | 'title'>): ContractFinding => ({
  severity: 'متوسط',
  explanation: 'شرح',
  suggestion: null,
  evidence: [],
  source: 'model',
  ...o,
});

describe('الجولة 104: كاشف «نموذج عقد غير مكتمل»', () => {
  it('الخانة الفارغة: ( ) و[ ] و____ و% بلا رقم؛ والنسبة المكتوبة ليست خانة', () => {
    for (const t of ['مدة الشركة : ( ) سنة تبدأ من تاريخه', 'المبلغ [ ] جنيه يسدد', 'يدفع ______ جنيها عند التسليم', 'يمثل % من رأس مال الشركة على الأقل']) {
      expect(isBlankSlotText(t)).toBe(true);
    }
    for (const t of ['بنسبة 5% من الثمن', 'بنسبة 10 % من الثمن', 'بنسبة ٥٪ من الثمن', 'غرامة قدرها %10 من القيمة', 'مدة العقد (5) سنوات', 'المبلغ ( 500 ) جنيه']) {
      expect(isBlankSlotText(t)).toBe(false);
    }
  });

  it('النموذج الرسمى الحقيقى (OCR): ≥ 4 مواضع فى ≥ 3 بنود ⇒ نموذج غير مكتمل، ومنها م4 وم6', () => {
    const slots = findBlankSlots(llcClauses());
    const diag = blankTemplateDiag(slots);
    expect(diag.template).toBe(true);
    expect(diag.slots).toBeGreaterThanOrEqual(6);
    const labels = slots.map((s) => s.clauseLabel);
    expect(labels).toContain('المادة 4');
    expect(labels).toContain('المادة 6');
    for (const s of slots) expect(quoteInText(s.quote, llcClauses().find((c) => c.clauseIndex === s.clauseIndex)!.clauseText)).toBe(true);
  });

  it('فى النموذج: ملاحظتا «شرط مفتوح» على م4 وم6 (من النموذج اللغوى) تُجمعان فى ملاحظة واحدة منخفضة، وغيرهما لا يُمسّ', () => {
    const clauses = llcClauses();
    const c4 = clauses.find((c) => c.clauseLabel === 'المادة 4')!;
    const c6 = clauses.find((c) => c.clauseLabel === 'المادة 6')!;
    const q4 = findBlankSlots(clauses).find((s) => s.clauseIndex === c4.clauseIndex)!.quote;
    const findings: ContractFinding[] = [
      mk({ id: 'model:open_term:1', kind: 'open_term', title: 'مدة الشركة متروكة دون تحديد فى المادة 4', evidence: [{ clauseIndex: c4.clauseIndex, clauseLabel: c4.clauseLabel, quote: q4 }] }),
      // اقتباس بلا خانة لكن الشرح يتكلم عن المتروك والبند يحمل خانة
      mk({ id: 'model:open_term:2', kind: 'open_term', title: 'رأس المال موزع على عدد حصص وقيمة كل حصة متروكة دون تحديد', evidence: [{ clauseIndex: c6.clauseIndex, clauseLabel: c6.clauseLabel, quote: 'وقد أودع رأسمال الشركة' }] }),
      mk({ id: 'model:conflict:3', kind: 'conflict', severity: 'عالٍ', title: 'تعارض محتمل بين بندين', evidence: [{ clauseIndex: 1, clauseLabel: 'المادة 1', quote: 'x' }] }),
    ];
    const r = reclassifyBlankTemplate(findings, clauses);
    expect(r.diag.template).toBe(true);
    expect(r.absorbed).toBe(2);
    expect(r.findings.map((f) => f.id).sort()).toEqual([BLANK_TEMPLATE_FINDING_ID, 'model:conflict:3'].sort());
    const sum = r.findings.find((f) => f.id === BLANK_TEMPLATE_FINDING_ID)!;
    expect(sum.kind).toBe('blank_field');
    expect(sum.severity).toBe('منخفض');
    expect(sum.source).toBe('rule');
    expect(sum.title).toContain('نموذج عقد غير مكتمل');
    expect(sum.explanation).toContain('المادة 4');
    expect(sum.evidence.length).toBeGreaterThan(0);
    expect(r.findings.find((f) => f.id === 'model:conflict:3')!.severity).toBe('عالٍ');
  });

  it('شرط مفتوح حقيقى («يحدد لاحقاً») فى بند بلا خانة فارغة يبقى كما هو داخل النموذج', () => {
    const clauses = llcClauses();
    const real = mk({ id: 'rule:open:9', kind: 'open_term', source: 'rule', title: 'مقابل مالى يُترك تحديده إلى وقت لاحق', evidence: [{ clauseIndex: 2, clauseLabel: 'المادة 2', quote: 'يحدد الأجر لاحقاً باتفاق الطرفين' }] });
    const r = reclassifyBlankTemplate([real], clauses);
    expect(r.absorbed).toBe(0);
    expect(r.findings.some((f) => f.id === 'rule:open:9' && f.severity === 'متوسط' && f.kind === 'open_term')).toBe(true);
  });

  it('عقد موقَّع فيه خانة فارغة واحدة (عيب حقيقى): لا يُعاد تصنيف شىء', () => {
    const clauses: LevelClause[] = [
      { clauseIndex: 1, clauseLabel: 'البند 1', clauseTitle: null, clauseText: 'يلتزم المشترى بسداد الثمن كاملاً عند التسليم فى مقر البائع.' },
      { clauseIndex: 2, clauseLabel: 'البند 2', clauseTitle: null, clauseText: 'مدة هذا العقد ( ) سنة تبدأ من تاريخ التوقيع عليه من الطرفين.' },
      { clauseIndex: 3, clauseLabel: 'البند 3', clauseTitle: null, clauseText: 'تسرى على العقد أحكام القانون المصرى وتختص محاكم القاهرة.' },
    ];
    const f = mk({ id: 'model:open_term:1', kind: 'open_term', title: 'مدة العقد متروكة دون تحديد', evidence: [{ clauseIndex: 2, clauseLabel: 'البند 2', quote: 'مدة هذا العقد ( ) سنة تبدأ من تاريخ التوقيع' }] });
    const r = reclassifyBlankTemplate([f], clauses);
    expect(r.diag.template).toBe(false);
    expect(r.findings).toEqual([f]);
  });

  it('عقد توريد طويل بنسب وأرقام مكتوبة: لا خانات ولا إعادة تصنيف', () => {
    const clauses: LevelClause[] = [1, 2, 3, 4, 5].map((i) => ({
      clauseIndex: i,
      clauseLabel: `البند ${i}`,
      clauseTitle: null,
      clauseText: `يلتزم المورد بتوريد الكمية خلال ${i + 10} يوماً وبغرامة ${i}% عن كل أسبوع تأخير بحد أقصى 10 % من قيمة العقد.`,
    }));
    expect(blankTemplateDiag(findBlankSlots(clauses)).slots).toBe(0);
  });

  it('إجراء التقرير للنوع الجديد: استكمال الخانات لا «معالجة» عامة', () => {
    const a = findingAction({ kind: 'blank_field', severity: 'منخفض', title: 't', suggestion: null });
    expect(a.text).toContain('الخانات الفارغة');
  });

  it('سياق النموذج غير المكتمل يُضاف للبند الحامل لخانة فقط، وبجانب سياق نوع العقد لا بدلاً منه', () => {
    expect(contractContextFor(false, false, false)).toBeNull();
    expect(contractContextFor(false, false, true)).toBe(BLANK_TEMPLATE_CONTEXT);
    const both = contractContextFor(false, true, true)!;
    expect(both).toContain('عقد تأسيس شركة');
    expect(both).toContain(BLANK_TEMPLATE_CONTEXT);
    expect(contractContextFor(false, true, false)).not.toContain('نموذج عقد غير مكتمل');
  });

  it('تشخيص البند يُظهر blankSlot', () => {
    const line = formatClauseVerdict({ label: 'سليم', rawSelected: 0, validSelected: 0, violationType: 'none', confidence: 0.9, contextGiven: true, contextKind: 'company', blankSlot: true });
    expect(line).toContain('blankSlot=true');
    expect(formatClauseVerdict({ label: 'سليم', rawSelected: 0, validSelected: 0, violationType: 'none', confidence: 0.9, contextGiven: true, contextKind: 'company' })).not.toContain('blankSlot');
  });

  it('«الإحالة إلى مدة العقد دون مدة» تُضمّ للنموذج إن كانت خانة المدة موجودة فارغة، وتبقى فى عقد بلا خانة مدة', () => {
    const clauses = llcClauses();
    const dur = mk({ id: 'undefined:duration', kind: 'undefined_term', severity: 'عالٍ', source: 'rule', title: 'الإحالة إلى «مدة العقد» دون تحديد مدة فى أى بند', evidence: [{ clauseIndex: 5, clauseLabel: 'المادة 5', quote: 'طوال مدة العقد' }] });
    const r = reclassifyBlankTemplate([dur], clauses);
    expect(r.absorbed).toBe(1);
    expect(r.findings.some((f) => f.id === 'undefined:duration')).toBe(false);
    // نموذج فيه ≥ 4 خانات فى ≥ 3 بنود لكن لا خانة مدة: الملاحظة تبقى
    const noDur: LevelClause[] = [1, 2, 3, 4].map((i) => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: null, clauseText: `يدفع الطرف الأول مبلغ ( ) جنيها للطرف الثانى عند التسليم رقم ${i}.` }));
    const r2 = reclassifyBlankTemplate([dur], noDur);
    expect(r2.diag.template).toBe(true);
    expect(r2.findings.some((f) => f.id === 'undefined:duration')).toBe(true);
  });
});
