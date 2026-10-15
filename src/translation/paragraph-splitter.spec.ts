import { MAX_UNIT_CHARS, planBatches, splitIntoUnits } from './paragraph-splitter';

describe('splitIntoUnits', () => {
  it('يلصق الأسطر الملتفة ويفصل عند الترقيم والعناوين', () => {
    const text = [
      'عقد عمل',
      '',
      'البند الأول: الموضوع',
      'يلتزم العامل بأداء العمل المسند إليه',
      'بكل أمانة وإخلاص.',
      '1. مدة العقد سنة واحدة.',
      '2- يبدأ العقد من تاريخ التوقيع.',
    ].join('\n');
    const { units } = splitIntoUnits(text);
    expect(units.map((u) => u.text)).toEqual([
      'عقد عمل',
      'البند الأول: الموضوع يلتزم العامل بأداء العمل المسند إليه بكل أمانة وإخلاص.',
      '1. مدة العقد سنة واحدة.',
      '2- يبدأ العقد من تاريخ التوقيع.',
    ]);
    expect(units.every((u) => !u.cont)).toBe(true);
  });

  it('عناوين البنود الإنجليزية والتعداد الفرعى', () => {
    const { units } = splitIntoUnits('Article 1\nThe Contractor shall perform\nthe services.\n(a) first duty\n(b) second duty');
    expect(units.map((u) => u.text)).toEqual([
      'Article 1 The Contractor shall perform the services.',
      '(a) first duty',
      '(b) second duty',
    ]);
  });

  it('يحذف علامات الصفحات والأحرف الاتجاهية غير المرئية', () => {
    const { units } = splitIntoUnits('نص أول‏\n-- 1 of 5 --\nمتابعة النص');
    expect(units).toHaveLength(1);
    expect(units[0].text).toBe('نص أول متابعة النص');
  });

  it('الفقرة الطويلة تُقسَّم عند نهايات الجمل إلى قطع متتابعة', () => {
    const sentence = 'يلتزم الطرف الثانى بتنفيذ الالتزامات المتفق عليها كاملة فى المواعيد المحددة. ';
    const long = sentence.repeat(Math.ceil((MAX_UNIT_CHARS * 2.2) / sentence.length));
    const { units } = splitIntoUnits(long);
    expect(units.length).toBeGreaterThanOrEqual(3);
    expect(units[0].cont).toBe(false);
    expect(units.slice(1).every((u) => u.cont)).toBe(true);
    expect(units.every((u) => u.text.length <= MAX_UNIT_CHARS)).toBe(true);
    // لا فقد: إعادة اللصق تطابق الأصل (بعد توحيد المسافات)
    expect(units.map((u) => u.text).join(' ').replace(/\s+/g, ' ')).toBe(long.replace(/\s+/g, ' ').trim());
  });
});

describe('planBatches', () => {
  it('دفعات متتابعة متصلة بلا فجوات', () => {
    const lens = Array.from({ length: 30 }, () => 700);
    const batches = planBatches(lens);
    expect(batches[0].start).toBe(0);
    for (let i = 1; i < batches.length; i++) expect(batches[i].start).toBe(batches[i - 1].end);
    expect(batches[batches.length - 1].end).toBe(30);
    expect(batches.every((b) => b.end - b.start <= 7)).toBe(true);
  });

  it('وحدة أكبر من الحد وحدها فى دفعة', () => {
    expect(planBatches([100, 4900, 300])).toEqual([
      { start: 0, end: 2 },
      { start: 2, end: 3 },
    ]);
    expect(planBatches([9000])).toEqual([{ start: 0, end: 1 }]);
    expect(planBatches([])).toEqual([]);
  });
});
