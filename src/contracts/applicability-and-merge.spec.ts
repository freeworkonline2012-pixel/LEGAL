import { coveredTopicRefs, MISSING_CHECK_TO_TOPICS } from './missing-topic-map';
import type { LevelClause } from './contract-level';
import { buildPlaybook } from './playbook';
import { PLAYBOOK_TOPICS } from './playbook-data';

const cl = (i: number, text: string, title: string | null = null): LevelClause => ({ clauseIndex: i, clauseLabel: `البند ${i}`, clauseTitle: title, clauseText: text });
const topics = (clauses: LevelClause[], type = 'عقد خدمات') => buildPlaybook({ contractType: type, clientRole: 'العميل', clauses })!.rows.map((r) => `${r.topicId}:${r.status}`);

// عقد تسويق/تواصل اجتماعى: لا بيانات أشخاص ولا منتج تقنى مسلَّم (حكم المستشار على الدفعة 1)
const MARKETING = [
  cl(1, 'يقدم الطرف الثانى خدمات إدارة حسابات الطرف الأول على وسائل التواصل الاجتماعى ونشر المحتوى الإعلانى بحسب الخطة الشهرية.', 'نطاق الخدمات'),
  cl(2, 'يسدد الطرف الأول مقابلاً شهرياً قدره 10000 جنيه خلال 15 يوماً من استلام الفاتورة.', 'المقابل'),
];
const SOC = [
  cl(1, 'يقدم مزود الخدمة خدمات مركز العمليات الأمنية ومراقبة نظم المعلومات والبرمجيات والتطبيقات الخاصة بالعميل.', 'نطاق الخدمات'),
  cl(2, 'يسدد العميل المقابل خلال 30 يوماً من تاريخ الفاتورة.', 'المقابل'),
];

describe('انطباق محاور الدليل على نوع العقد (appliesWhen)', () => {
  it('عقد تسويق بلا بيانات أشخاص ولا منتج تقنى: لا يُعرض محورا حماية البيانات والضمان والدعم «غير مرصودين»', () => {
    const t = topics(MARKETING);
    expect(t.some((x) => x.startsWith('svc_data_protection'))).toBe(false);
    expect(t.some((x) => x.startsWith('svc_warranty'))).toBe(false);
    expect(t).toContain('svc_payment:found');
  });

  it('عقد خدمات تقنية: يبقى محور الضمان والدعم غير مرصود حين لا نص فيه', () => {
    expect(topics(SOC)).toContain('svc_warranty:missing');
  });

  it('عقد يعالج بيانات عملاء ولم ينظمها: يبقى محور حماية البيانات غير مرصود', () => {
    const c = [...MARKETING, cl(3, 'يحصل الطرف الثانى على بيانات عملاء الطرف الأول لأغراض الحملات.', 'البيانات')];
    expect(topics(c)).toContain('svc_data_protection:missing');
  });

  it('المحور المرصود نصه يُعرض دائماً ولو لم يطابق شرط الانطباق', () => {
    const c = [...MARKETING, cl(3, 'يلتزم الطرف الثانى بضمان جودة المحتوى وإصلاح الأخطاء دون مقابل.', 'الضمان')];
    expect(topics(c).some((x) => x.startsWith('svc_warranty') && !x.endsWith(':missing'))).toBe(true);
  });

  it('كل appliesWhen معرَّف على محور يدعم الغياب، ولا يُغيّر الأنواع الأخرى', () => {
    expect(PLAYBOOK_TOPICS.filter((t) => t.appliesWhen).map((t) => t.id).sort()).toEqual(['svc_data_protection', 'svc_warranty']);
    const lease = buildPlaybook({ contractType: 'عقد إيجار', clientRole: 'المستأجر', clauses: [cl(1, 'المدة: ثلاث سنوات.')] })!;
    expect(lease.rows.length).toBe(PLAYBOOK_TOPICS.filter((t) => t.families.includes('lease')).length);
  });
});

describe('ربط البند الناقص بمحور الدليل (منع الازدواج)', () => {
  it('كل محور مرتبط موجود فعلاً فى بيانات الدليل', () => {
    const ids = new Set(PLAYBOOK_TOPICS.map((t) => t.id));
    for (const [check, list] of Object.entries(MISSING_CHECK_TO_TOPICS)) for (const t of list) expect([check, t, ids.has(t)]).toEqual([check, t, true]);
  });

  it('ملاحظة «بند ناقص» تُسند رقمها لمحورها؛ وغير الناقصة لا تُسند', () => {
    const m = coveredTopicRefs([{ id: 'open:indefinite_duration' }, { id: 'missing:delay_penalty' }, { id: 'missing:warranty' }, {}, { id: 'office:x' }]);
    expect(m.get('svc_delay')).toBe('ع2');
    expect(m.get('svc_warranty')).toBe('ع3');
    expect(m.get('sale_warranty')).toBe('ع3');
    expect(m.size).toBe(3);
  });

  it('ملاحظة غير معروفة المعرّف أو بلا معرّف (عقد قديم) لا تكسر شيئاً', () => {
    expect(coveredTopicRefs([{ id: 'missing:غير_معروف' }]).size).toBe(0);
    expect(coveredTopicRefs([]).size).toBe(0);
  });
});
