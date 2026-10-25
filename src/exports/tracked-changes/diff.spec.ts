import { wordDiff } from './diff';

const orig = (s: ReturnType<typeof wordDiff>) => s.filter((x) => x.kind !== 'ins').map((x) => x.text).join('');
const rev = (s: ReturnType<typeof wordDiff>) => s.filter((x) => x.kind !== 'del').map((x) => x.text).join('');
const squash = (t: string) => t.replace(/\s+/g, ' ').trim();

describe('wordDiff', () => {
  it('رفض كل التعديلات يعيد الأصل حرفياً، وقبولها يعيد الصياغة (بعد توحيد المسافات)', () => {
    const a = 'يجوز للطرف الأول فسخ العقد دون حاجة إلى إنذار.\nويلتزم الطرف الثانى بالسداد.';
    const b = 'يجوز للطرف الأول فسخ العقد دون حاجة إلى إنذار أو حكم قضائى.\nويلتزم الطرف الثانى بالسداد فوراً.';
    const d = wordDiff(a, b);
    expect(orig(d)).toBe(a);
    expect(squash(rev(d))).toBe(squash(b));
    expect(d.some((x) => x.kind === 'ins' && x.text.includes('أو حكم قضائى'))).toBe(true);
  });

  it('تعديل صغير فى بند طويل لا يعيد كتابته كله', () => {
    const base = Array.from({ length: 60 }, (_, i) => `كلمة${i}`).join(' ');
    const changed = base.replace('كلمة30', 'بديل');
    const d = wordDiff(base, changed);
    expect(d.filter((x) => x.kind === 'del').map((x) => x.text.trim())).toEqual(['كلمة30']);
    expect(d.filter((x) => x.kind === 'ins').map((x) => x.text.trim())).toEqual(['بديل']);
  });

  it('اختلاف التشكيل وحده ليس تعديلاً', () => {
    const d = wordDiff('يَلتزم الطرف الأول', 'يلتزم الطرف الأول');
    expect(d.every((x) => x.kind === 'same')).toBe(true);
  });

  it('نصان متطابقان: قطعة واحدة بلا تعديل، وفارغان: لا شىء، وأحدهما فارغ: حذف كامل أو إضافة كاملة', () => {
    expect(wordDiff('أ ب ج', 'أ ب ج')).toEqual([{ kind: 'same', text: 'أ ب ج' }]);
    expect(wordDiff('', '')).toEqual([]);
    expect(wordDiff('أ ب', '')).toEqual([{ kind: 'del', text: 'أ ب' }]);
    expect(wordDiff('', 'أ ب')).toEqual([{ kind: 'ins', text: 'أ ب' }]);
  });

  it('نص ضخم جداً: استبدال كامل بدل فرق مكلف، والأصل محفوظ', () => {
    const big = Array.from({ length: 2500 }, (_, i) => `ك${i}`).join(' ');
    const other = Array.from({ length: 2500 }, (_, i) => `م${i}`).join(' ');
    const d = wordDiff(big, other);
    expect(d.map((x) => x.kind)).toEqual(['del', 'ins']);
    expect(orig(d)).toBe(big);
  });
});
