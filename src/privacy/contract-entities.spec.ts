import { collectContractEntities, registerContractEntities } from './contract-entities';
import { ShieldSession } from './outbound-shield';

const PREAMBLE = `عقد خدمات

إنه فى يوم الأحد الموافق 1/1/2026 تحرر هذا العقد بين:
شركة النيل للحلول الرقمية ش.م.م، سجل تجارى رقم 123456 وبطاقة ضريبية 456-789-123، ومقرها 15 شارع التحرير - الدقى - الجيزة، ويمثلها السيد/ محمود سمير عبد العزيز بصفته المدير. (الطرف الأول)
والسيدة / منى حسن فتحى، المقيمة فى 8 شارع النصر مدينة نصر القاهرة، بطاقة رقم قومى 29001011234567. (الطرف الثانى)

البند الأول: يلتزم الطرف الثانى بالتوريد.`;

describe('collectContractEntities', () => {
  const found = collectContractEntities(PREAMBLE, null);
  const has = (kind: string, part: string) => found.some((e) => e.kind === kind && e.surface.includes(part));

  it('يكشف الجهات والأشخاص والعناوين والأرقام المرجعية', () => {
    expect(has('ORG', 'النيل للحلول الرقمية')).toBe(true);
    expect(has('PER', 'محمود سمير عبد العزيز')).toBe(true);
    expect(has('PER', 'منى حسن فتحى')).toBe(true);
    expect(has('ADDR', 'شارع التحرير')).toBe(true);
    expect(has('ADDR', 'شارع النصر')).toBe(true);
    expect(has('REF', '123456')).toBe(true);
  });

  it('أسماء الطرفين المقروءة تُضاف دائماً', () => {
    const r = collectContractEntities('نص قصير', { first: 'شركة الأمل', second: 'مؤسسة البدر' } as never);
    expect(r.map((e) => e.surface)).toEqual(expect.arrayContaining(['شركة الأمل', 'مؤسسة البدر']));
  });

  it('نص فارغ لا يكسر', () => {
    expect(collectContractEntities('', null)).toEqual([]);
  });
});

describe('registerContractEntities + shield', () => {
  it('بعد التسجيل لا يبقى اسم ولا عنوان فى النص المرسل، ويعود النص الأصلى حرفياً', () => {
    const s = new ShieldSession();
    const n = registerContractEntities(s, PREAMBLE, null);
    expect(n).toBeGreaterThan(4);
    const body = `${PREAMBLE}\nيلتزم محمود سمير عبد العزيز بسداد المقابل لشركة النيل للحلول الرقمية.`;
    const out = s.shield(body);
    for (const leaked of ['محمود', 'منى حسن', 'النيل للحلول', 'شارع التحرير', 'شارع النصر', '29001011234567', '123456']) {
      expect(out).not.toContain(leaked);
    }
    expect(s.unshield(out)).toBe(body);
  });

  it('نص العقد الموضوعى (بنود بلا هويات) لا يتغير', () => {
    const s = new ShieldSession();
    registerContractEntities(s, PREAMBLE, null);
    const clause = 'البند الخامس: يحق للطرف الأول إنهاء العقد بإخطار مدته ثلاثون يوماً وفقاً للمادة 147 من القانون المدنى.';
    expect(s.shield(clause)).toBe(clause);
  });
});

describe('صيغ الألقاب والجهات الملتصقة بحروف العطف والجر', () => {
  it('يكشف «والسيدة» و«لشركة» و«بالأستاذ» و«للسيد»', () => {
    const text = 'تحرر بين والسيدة / ليلى كمال حسين، ولشركة الريان للتجارة، وبالأستاذ طارق فوزى نصر، وللسيد عادل رمزى بشير.';
    const f = collectContractEntities(text, null).map((e) => e.surface);
    expect(f.some((x) => x.includes('ليلى كمال حسين'))).toBe(true);
    expect(f.some((x) => x.includes('الريان للتجارة'))).toBe(true);
    expect(f.some((x) => x.includes('طارق فوزى نصر'))).toBe(true);
    expect(f.some((x) => x.includes('عادل رمزى بشير'))).toBe(true);
  });

  it('لا يلتقط «الشركة» أو «للشركة» المعرّفتين اسماً', () => {
    const f = collectContractEntities('تلتزم الشركة الأولى بالسداد، وتدفع للشركة الثانية المقابل.', null);
    expect(f).toEqual([]);
  });
});

describe('تفاصيل إضافية', () => {
  it('رقم السجل بين قوسين يُكشف، و«شركة مصرية» لا تُحجب اسماً', () => {
    const f = collectContractEntities('أولاً: شركة النور شركة مصرية سجل تجارى رقم (96851) ومقرها 3 شارع الهرم الجيزة.', null);
    expect(f.some((e) => e.kind === 'REF' && e.surface.includes('96851'))).toBe(true);
    expect(f.some((e) => e.kind === 'ORG' && e.surface === 'مصرية')).toBe(false);
  });
});
