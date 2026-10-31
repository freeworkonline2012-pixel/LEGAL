import { readFileSync } from 'fs';
import { join } from 'path';
import type { LevelClause } from './contract-level';
import { buildPlaybook } from './playbook';
import { SegmentationService } from './segmentation.service';

/**
 * مجموعة ذهبية من عقد حقيقى (Blackbelts × Arope، 18/12/2019، 15 بنداً): النص المرجعى مُنسَخ بصرياً من الأصل الموقَّع، لا ناتج OCR.
 * كل اختبار هنا يُثبِّت خطأ واقعياً ظهر فى تقرير تدقيق فعلى ثم صُحِّح (راجع «تقييم تقرير تدقيق عقد Blackbelts مقابل الأصل»).
 */
const text = readFileSync(join(__dirname, '__fixtures__', 'golden', 'blackbelts-2019.txt'), 'utf-8');
const seg = new SegmentationService().segment(text);
const clauses: LevelClause[] = seg.clauses.map((c, i) => ({ clauseIndex: i + 1, clauseLabel: c.label, clauseTitle: c.title, clauseText: c.text }));

describe('Blackbelts — التقسيم على النص المرجعى', () => {
  it('15 بنداً بترقيم متسلسل وبلا تنبيهات', () => {
    expect(clauses).toHaveLength(15);
    expect(seg.clauses.map((c) => c.declaredNumber)).toEqual(Array.from({ length: 15 }, (_, i) => i + 1));
    expect(seg.warnings).toEqual([]);
  });

  it('السعر والدفعات والضريبة والاستضافة فى البند الثالث لا الثانى', () => {
    const second = clauses[1].clauseText;
    const third = clauses[2].clauseText;
    expect(third).toContain('1125000');
    expect(third).toContain('غير شامل ضريبة القيمة المضافة');
    expect(third).toContain('رسوم الإستضافة');
    expect(second).not.toContain('1125000');
  });
});

describe('Blackbelts — الدليل التفاوضى للملكية الفكرية (طالب الخدمة = الطرف الثانى)', () => {
  const pb = buildPlaybook({
    contractType: 'عقد تقديم خدمات إلكترونية ودعم فنى وصيانة',
    clientRole: 'طالب الخدمة',
    clientParty: 'second',
    clauses,
  })!;
  const ip = pb.rows.find((r) => r.topicId === 'svc_ip')!;

  it('يرصد بقاء الملكية لمقدم الخدمة (البند 5)', () => {
    const c = ip.concerns.find((x) => x.flagId === 'supplier_owns_output');
    expect(c).toBeDefined();
    expect(c!.clauseLabel).toBe('البند الخامس');
  });

  it('لا يقرر غياب الرخصة أو الشفرة المصدرية وقد نص عليهما البند الرابع', () => {
    const c = ip.concerns.find((x) => x.flagId === 'supplier_owns_output')!;
    expect(c.mitigatedBy?.clauseLabel).toBe('البند الرابع');
    expect(c.mitigatedBy?.quote).toMatch(/رخصة|Source Code/);
    expect(c.note).not.toMatch(/دون نص على|لم يُرصد/);
    expect(c.note).toContain('بند آخر');
  });

  it('يرصد أن الرخصة مقيدة بمدة العقد (البند 4) وأن العقد لا يحدد مدته', () => {
    const c = ip.concerns.find((x) => x.flagId === 'licence_term_bound');
    expect(c).toBeDefined();
    expect(c!.clauseLabel).toBe('البند الرابع');
    expect(c!.note).toContain('مدته');
  });

  it('بلا بند رخصة/شفرة فى العقد يبقى نص الغياب القديم مع التنبيه إلى أثر القراءة الآلية', () => {
    const only5 = clauses.filter((c) => c.clauseLabel === 'البند الخامس');
    const pb2 = buildPlaybook({ contractType: 'عقد خدمات', clientRole: 'طالب الخدمة', clientParty: 'second', clauses: only5 })!;
    const c = pb2.rows.find((r) => r.topicId === 'svc_ip')!.concerns.find((x) => x.flagId === 'supplier_owns_output')!;
    expect(c.mitigatedBy).toBeUndefined();
    expect(c.note).toContain('ولم يُرصد فى العقد المقروء');
    expect(c.note).toContain('القراءة الآلية');
  });
});

describe('سقف المسئولية/الغرامة فى بند آخر لا يُعامل كغائب', () => {
  const mk = (texts: string[]): LevelClause[] => texts.map((t, i) => ({ clauseIndex: i + 1, clauseLabel: `البند ${i + 1}`, clauseTitle: null, clauseText: t }));
  const run = (texts: string[], topic: string, flag: string) =>
    buildPlaybook({ contractType: 'عقد تقديم خدمات', clientRole: 'مقدم الخدمة (المقاول / المورد)', clientParty: 'first', clauses: mk(texts) })!
      .rows.find((r) => r.topicId === topic)!
      .concerns.find((c) => c.flagId === flag);

  it('غرامة تأخير بلا سقف فى بندها وسقفها فى بند آخر', () => {
    const c = run(['تفرض غرامة تأخير عن كل يوم تأخير على الطرف الأول.', 'لا يجاوز إجمالى الغرامات 10 % من قيمة العقد كحد أقصى.'], 'svc_delay', 'no_cap');
    expect(c?.mitigatedBy?.clauseLabel).toBe('البند 2');
    expect(c?.note).toContain('بند آخر');
    expect(c?.note).not.toContain('بلا سقف ظاهر');
  });

  it('غرامة تأخير بلا سقف فى أى بند تبقى بملاحظتها مع تنبيه القراءة الآلية', () => {
    const c = run(['تفرض غرامة تأخير عن كل يوم تأخير على الطرف الأول.', 'يحكم القانون المصرى هذا العقد.'], 'svc_delay', 'no_cap');
    expect(c).toBeDefined();
    expect(c?.mitigatedBy).toBeUndefined();
    expect(c?.note).toContain('القراءة الآلية');
  });

  it('مسئولية غير محدودة وسقفها فى بند آخر', () => {
    const c = run(['تكون مسئولية الطرف الأول غير محدودة عن كل الأضرار.', 'لا تتجاوز مسئولية الطرف الأول فى جميع الأحوال قيمة العقد.'], 'svc_liability', 'unlimited');
    expect(c?.mitigatedBy?.clauseLabel).toBe('البند 2');
  });
});
