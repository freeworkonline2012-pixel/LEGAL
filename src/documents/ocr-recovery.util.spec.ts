import { insertLinesByPosition, linesToText, parseTsvLines } from './ocr-recovery.util';

const HEADER = 'level\tpage_num\tblock_num\tpar_num\tline_num\tword_num\tleft\ttop\twidth\theight\tconf\ttext';
const w = (block: number, line: number, top: number, text: string, conf = 90) =>
  `5\t1\t${block}\t1\t${line}\t1\t10\t${top}\t50\t20\t${conf}\t${text}`;

describe('parseTsvLines', () => {
  it('يجمّع كلمات السطر ويتجاهل الفارغ والضعيف جداً', () => {
    const tsv = [HEADER, w(1, 1, 100, 'البند'), w(1, 1, 100, 'الثانى'), w(1, 2, 150, 'نص'), w(1, 2, 150, 'مشوّه', 3), `4\t1\t1\t1\t1\t0\t0\t0\t0\t0\t-1\t`].join('\n');
    expect(parseTsvLines(tsv)).toEqual([
      { text: 'البند الثانى', top: 100, block: 1 },
      { text: 'نص', top: 150, block: 1 },
    ]);
  });
  it('مدخل بلا بيانات يعطى قائمة فارغة', () => {
    expect(parseTsvLines('')).toEqual([]);
  });
});

describe('insertLinesByPosition', () => {
  const base = [
    { text: 'سطر أعلى', top: 100, block: 1 },
    { text: 'سطر وسط', top: 500, block: 2 },
    { text: 'سطر أسفل', top: 900, block: 3 },
  ];
  it('يضع العنوان بين السطرين حسب موضعه الرأسى', () => {
    const t = insertLinesByPosition(base, [{ text: 'البند الثالث', top: 700, block: 9 }]);
    const lines = t.split('\n').filter(Boolean);
    expect(lines).toEqual(['سطر أعلى', 'سطر وسط', 'البند الثالث', 'سطر أسفل']);
  });
  it('يضعه فى آخر الصفحة إن كان أسفل كل الأسطر ويعزله بسطر فارغ', () => {
    const t = insertLinesByPosition(base, [{ text: 'البند الثالث', top: 2000, block: 9 }]);
    expect(t.endsWith('سطر أسفل\n\nالبند الثالث')).toBe(true);
  });
  it('بلا أسطر مسترجعة يطابق linesToText', () => {
    expect(insertLinesByPosition(base, [])).toBe(linesToText(base));
  });
});
