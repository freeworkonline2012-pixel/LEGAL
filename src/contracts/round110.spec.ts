import { checkMissingClauses, CHECKS } from './contract-level';

/**
 * الجولة 110: \w فى JavaScript لا تطابق الحروف العربية، فكانت كل قاعدة تضع \w* ثم مسافة أو كلمة (مثل «مكتوب\w* وموقع\w*») لا تطابق
 * إلا الكلمة المجردة بلا تاء مربوطة/لاحقة، فيظهر ترشيح «بند غائب» كاذب وبند التعديل موجود نصاً.
 */
const base = 'عقد خدمات أمن المعلومات بين الطرفين لمدة سنة يخضع للقانون المصري ويدفع الطرف الثاني مبلغ 1000 جنيه سداد';
const ids = (tail: string) =>
  checkMissingClauses(
    [
      { clauseIndex: 1, clauseTitle: 'مقدمة', clauseText: base },
      { clauseIndex: 9, clauseTitle: 'متفرقات', clauseText: tail },
    ] as any,
    { contractType: null, textMayBeIncomplete: false },
  ).map((f) => f.id);

describe('round110: \\w لا تغطى العربية', () => {
  it('«التعديلات مكتوبة وموقعة من كلا الطرفين» تُعد بند تعديل', () => {
    expect(ids('يجب أن تكون التعديلات مكتوبة وموقعة من كلا الطرفين.')).not.toContain('missing:amendments');
  });
  it('«تعديل أى من بنود هذا الاتفاق» و«لا يعتد بأى تعديل» ما زالتا تعدّان بند تعديل', () => {
    expect(ids('لا يجوز تعديل أي من بنود هذه الاتفاقية إلا بموافقة كتابية.')).not.toContain('missing:amendments');
    expect(ids('لا يعتد بأي تعديل شفهي.')).not.toContain('missing:amendments');
  });
  it('غياب نص التعديل فعلاً ما زال يُرصد', () => {
    expect(ids('تختص محاكم القاهرة بنظر أي نزاع.')).toContain('missing:amendments');
  });
  it('لا يبقى \\w فى ملفات القواعد العربية', () => {
    const fs = require('fs');
    for (const f of ['contract-level', 'mandatory-rules', 'playbook-flags-r57']) {
      const src: string = fs.readFileSync(`${__dirname}/${f}.ts`, 'utf8');
      const code = src.split('\n').filter((l) => !/^\s*(\/\/|\*|\/\*)/.test(l)).join('\n');
      expect(code).not.toMatch(/\\w/);
    }
    expect(CHECKS.length).toBeGreaterThan(0);
  });
});
