import { openTermIsCore, validateModelFindings, type LevelClause } from './contract-level';

const cl = (i: number, text: string, label = `البند ${i}`): LevelClause => ({ clauseIndex: i, clauseLabel: label, clauseTitle: null, clauseText: text });

const C5 = cl(5, 'اتفق الطرفان على أن يتم تحديد مستوى الخدمة وخطة المشروع بعد التوصل لاتفاق لاحق بينهما.', 'البند الخامس');
const C6 = cl(6, 'تحدد رسوم الاستضافة بعد انتهاء التنفيذ ويلتزم الطرف الثانى بسدادها خلال ثلاثين يوماً.', 'البند السادس');
const C7 = cl(7, 'تسرى الإجراءات الإدارية المعتادة ويتخذ الطرفان ما يلزم من إجراءات.', 'البند السابع');

const raw = (quote: string, clauseIndex: number, severity = 'عالٍ') => ({
  findings: [{ kind: 'open_term', severity, title: 'شرط مفتوح', explanation: 'يبدو أن الالتزام مفتوح دون موعد أو آلية.', evidence: [{ clause_index: clauseIndex, quote }] }],
});

describe('الجولة 65: سقف درجة الشرط المفتوح من النموذج', () => {
  it('شرط تشغيلى (مستوى الخدمة وخطة المشروع) لا يبلغ «عالٍ» ويُخفض إلى متوسط', () => {
    const out = validateModelFindings(raw('تحديد مستوى الخدمة وخطة المشروع بعد التوصل لاتفاق لاحق', 5), [C5]);
    expect(out).toHaveLength(1);
    expect(out[0].severity).toBe('متوسط');
  });

  it('شرط مفتوح يمس رسماً ومدة يبقى «عالٍ»', () => {
    const out = validateModelFindings(raw('تحدد رسوم الاستضافة بعد انتهاء التنفيذ', 6), [C6]);
    expect(out[0].severity).toBe('عالٍ');
  });

  it('«إجراءات» لا تُعد مادة مالية (حد الكلمة)', () => {
    expect(openTermIsCore([{ quote: 'يتخذ الطرفان ما يلزم من إجراءات' }])).toBe(false);
    const out = validateModelFindings(raw('يتخذ الطرفان ما يلزم من إجراءات', 7), [C7]);
    expect(out[0].severity).toBe('متوسط');
  });

  it.each([
    'يحدد الثمن لاحقاً باتفاق الطرفين',
    'تسدد الأتعاب فى موعد يحدد لاحقاً',
    'مدتها تحدد باتفاق لاحق',
    'يحق لأى طرف الإنهاء بالشروط التى تحدد لاحقاً',
    'تحول المبالغ المحصلة بدورية يتفق عليها',
    'يتم السداد خلال مهلة تحدد لاحقاً',
  ])('مادة مالية/زمنية/إنهائية: %s', (q) => {
    expect(openTermIsCore([{ quote: q }])).toBe(true);
  });

  it('المتوسط والمنخفض لا يتغيران، ولا يرتفع منخفض', () => {
    expect(validateModelFindings(raw('تحديد مستوى الخدمة وخطة المشروع بعد التوصل لاتفاق لاحق', 5, 'منخفض'), [C5])[0].severity).toBe('منخفض');
    expect(validateModelFindings(raw('تحديد مستوى الخدمة وخطة المشروع بعد التوصل لاتفاق لاحق', 5, 'متوسط'), [C5])[0].severity).toBe('متوسط');
  });

  it('التعارض (conflict) لا يتأثر بالسقف', () => {
    const out = validateModelFindings(
      { findings: [{ kind: 'conflict', severity: 'عالٍ', title: 'تعارض', explanation: 'يبدو أن الميعادين متعارضان.', evidence: [{ clause_index: 5, quote: 'تحديد مستوى الخدمة وخطة المشروع' }, { clause_index: 6, quote: 'تحدد رسوم الاستضافة بعد انتهاء التنفيذ' }] }] },
      [C5, C6],
    );
    expect(out[0].severity).toBe('عالٍ');
  });
});
