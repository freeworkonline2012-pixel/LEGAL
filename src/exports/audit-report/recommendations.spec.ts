import { buildPlaybook } from '../../contracts/playbook';
import { extraActions, findingAction, playbookAction, PRIORITY_RANK } from './recommendations';

const f = (kind: string, severity: string, title: string, suggestion: string | null = null) => ({ kind, severity, title, suggestion });

describe('توصيات التنفيذ من ملاحظات العقد ككل', () => {
  it('بند غير مرصود ⇒ «إضافة بند يتناول» بلا تكرار صدر العنوان، والدرجة من الملاحظة', () => {
    const a = findingAction(f('missing_clause', 'متوسط', 'لم يُرصد بند يتناول: جزاء التأخير أو التعويض الاتفاقى', 'نص يحدد جزاء التأخير ونسبته وسقفه.'));
    expect(a.text).toBe('إضافة بند يتناول: جزاء التأخير أو التعويض الاتفاقى');
    expect(a.priority).toBe('متوسطة');
    expect(a.note).toContain('جزاء التأخير');
  });

  it('أنواع أخرى وصياغة الدرجات', () => {
    expect(findingAction(f('open_term', 'عالٍ', 'شرط مفتوح: رسوم الاستضافة تُترك مفتوحة')).text).toBe('تحديد الشرط المفتوح: رسوم الاستضافة تُترك مفتوحة');
    expect(findingAction(f('undefined_term', 'منخفض', 'مصطلح أو إحالة غير معرَّفة: مصطلح «س»')).priority).toBe('منخفضة');
    expect(findingAction(f('conflict', 'حرج', 'تعارض محتمل بين بندين: ص')).text.startsWith('معالجة:')).toBe(true);
    expect(findingAction(f('conflict', 'درجة مجهولة', 'ص')).priority).toBe('متوسطة');
  });

  it('محور فيه ملاحظة ضد العميل ⇒ إجراء تفاوضى بأولوية عالية وموقف «الأفضل»', () => {
    const pb = buildPlaybook({
      contractType: 'عقد خدمات أو مقاولة أو توريد',
      clientRole: 'طالب الخدمة (صاحب العمل / العميل)',
      clientParty: 'second',
      clauses: [{ clauseIndex: 1, clauseLabel: 'البند الخامس', clauseTitle: null, clauseText: 'كافة حقوق الملكية الفكرية الخاصة بتلك البرامج تكون مملوكة للطرف الأول.' }],
    })!;
    const row = pb.rows.find((r) => r.topicId === 'svc_ip')!;
    const a = playbookAction(row, true)!;
    expect(a.priority).toBe('عالية');
    expect(a.text).toContain('الملكية الفكرية');
    expect(a.text).toContain('البند الخامس');
    expect(a.note.startsWith('الأفضل:')).toBe(true);
  });

  it('محور غير مرصود أو مرصود بلا ملاحظة لا يُكرَّر إجراءً', () => {
    const pb = buildPlaybook({
      contractType: 'عقد خدمات أو مقاولة أو توريد',
      clientRole: 'طالب الخدمة (صاحب العمل / العميل)',
      clientParty: 'second',
      clauses: [{ clauseIndex: 1, clauseLabel: 'البند الأول', clauseTitle: null, clauseText: 'موضوع العقد تقديم خدمات.' }],
    })!;
    expect(extraActions([], pb)).toEqual([]);
  });

  it('ترتيب الأولويات المعرَّف ثابت', () => {
    expect(PRIORITY_RANK['حرجة']).toBeLessThan(PRIORITY_RANK['عالية']);
    expect(PRIORITY_RANK['عالية']).toBeLessThan(PRIORITY_RANK['متوسطة']);
    expect(PRIORITY_RANK['متوسطة']).toBeLessThan(PRIORITY_RANK['منخفضة']);
  });
});

describe('اقتطاع الملاحظات عند حد طبيعى', () => {
  const note = (sug: string) => findingAction(f('office_rule', 'عالٍ', 'ع', sug)).note;
  it('عند نهاية جملة إن وُجدت بعد منتصف الحد، بلا نقاط اقتطاع', () => {
    const s = `${'نص يبين المخالفة وأثرها على الطرفين بوضوح تام وشامل ويحدد الجزاء المترتب عليها بدقة. '}ثم جملة ثانية طويلة جداً تتجاوز الحد المسموح به للخانة وتستمر ${'كلمة '.repeat(20)}`;
    const n = note(s);
    expect(n.endsWith('.')).toBe(true);
    expect(n.includes('…')).toBe(false);
    expect(n.length).toBeLessThanOrEqual(130);
  });
  it('وإلا عند فاصلة ثم مسافة، ولا يُقطع وسط كلمة', () => {
    const words = Array.from({ length: 40 }, (_, i) => `كلمة${i}`);
    const s = `${words.slice(0, 12).join(' ')}، ${words.slice(12).join(' ')}`;
    const n = note(s);
    expect(n.endsWith('…')).toBe(true);
    expect(n.length).toBeLessThanOrEqual(131);
    const lastToken = n.replace('…', '').trim().split(' ').pop()!;
    expect(words).toContain(lastToken);
  });
  it('النص القصير لا يُمس', () => {
    expect(note('نص قصير.')).toBe('نص قصير.');
  });
});
