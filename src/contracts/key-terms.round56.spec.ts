import { amountConflictWarnings, extractKeyTerms } from './key-terms';

const run = (t: string) => extractKeyTerms([{ clauseIndex: 4, clauseLabel: 'البند الرابع', clauseTitle: null, clauseText: t }]).map((k) => k.value);

describe('الجولة 56: شظية مبلغ عبر حدّ صفحة لا تُعرض مبلغاً مستقلاً', () => {
  const NOISE = '\nSVERES Tear\n\nSSRI.\n\nas\n—\nم\n'.repeat(8);
  const SPLIT =
    'مبلغ 4500 جنيه ( اربعة ألاف وخمسمائة جنيه مصرى فقط لاغير ) تدفع كل ثلاثة أشهر باجمالى قيمته 13500 جنيه( ثلاث عشر' +
    NOISE +
    '\n\n2الف وخمسمائة جنيه مصرى فقط لاغير ) وتدفع مقدما الى يد الطرف الأول';

  it('«13500 جنيه ( ثلاث عشر … ‹ضجيج صفحة طويل› 2الف وخمسمائة جنيه»: لا صف 1,500', () => {
    const v = run(SPLIT);
    expect(v).toContain('13,500 جنيه');
    expect(v).toContain('4,500 جنيه');
    expect(v).not.toContain('1,500 جنيه');
  });

  it('ويُنبَّه على مستوى العقد أن جزءاً من مبلغ لم يُعرض', () => {
    expect(amountConflictWarnings([SPLIT]).join(' ')).toContain('جزء من مبلغ');
  });

  it('الشظية بلا رقم صغير ملتصق («… ضجيج ألف وخمسمائة جنيه») كذلك', () => {
    const t = SPLIT.replace('2الف', 'الف');
    expect(run(t)).not.toContain('1,500 جنيه');
  });

  it('مبلغ مشروع «ألف وخمسمائة جنيه» بعد رقم لا يوافق باقيه يبقى (5000 ثم 1500)', () => {
    expect(run('التأمين 5000 جنيه وتدفع غرامة الف وخمسمائة جنيه عن كل مخالفة')).toEqual(['5,000 جنيه', '1,500 جنيه']);
  });

  it('«ألف جنيه» وحدها بعد مبلغ أكبر تبقى (ليست شظية مركّبة)', () => {
    expect(run('التأمين 5000 جنيه وتدفع غرامة الف جنيه عن كل مخالفة')).toEqual(['5,000 جنيه', '1,000 جنيه']);
  });
});
