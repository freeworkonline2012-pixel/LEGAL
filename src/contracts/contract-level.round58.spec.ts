import { type LevelClause, checkMissingClauses } from './contract-level';

const mk = (texts: string[]): LevelClause[] => texts.map((t, i) => ({ clauseIndex: i + 1, clauseLabel: `البند ${i + 1}`, clauseTitle: null, clauseText: t }));
const ids = (list: { id: string }[]) => list.map((f) => f.id);
const PART = 'عقد شراكة أو استثمار';
const BASE = ['رأس مال الشراكة مليون جنيه ويقدم كل شريك حصته نقداً وتحسب الحصص بنسبة المساهمة.', 'يتولى الشريك المدير الإدارة اليومية للمشروع.', 'يوزع صافى الربح والخسائر بنسبة المساهمة فى رأس المال.', 'يحق لكل شريك الاطلاع على الدفاتر والمستندات.'];

describe('البنود الناقصة — إنذارات كاذبة رصدها الإنتاج (R58)', () => {
  it('الشراكة: الانسحاب بإخطار وحل الشراكة وتصفيتها يغنيان عن «بند فسخ»', () => {
    const l = checkMissingClauses(mk([...BASE, 'مدة الشراكة خمس سنوات ويجوز لأى منهما الانسحاب بإخطار كتابى قبل تسعين يوماً مع تسوية حقوقه.', 'عند انتهاء الشراكة أو حلها يعين الطرفان مصفياً مستقلاً.']), { contractType: PART, textMayBeIncomplete: false });
    expect(ids(l)).not.toContain('missing:termination');
  });
  it('الشراكة: بند «الضمان الشخصى» لديون الشراكة هو نص عن مسئولية الشركاء (حتى لو كان معيباً)', () => {
    const l = checkMissingClauses(mk([...BASE, 'الضمان الشخصى: يضمن الطرف الأول شخصياً وبالتضامن جميع ديون الشراكة والتزاماتها تجاه الغير.']), { contractType: PART, textMayBeIncomplete: false });
    expect(ids(l)).not.toContain('missing:partnership_liability');
  });
  it('الشراكة: غياب أى نص عن ديون الشركاء ما زال يُرصد', () => {
    const l = checkMissingClauses(mk(BASE), { contractType: PART, textMayBeIncomplete: false });
    expect(ids(l)).toContain('missing:partnership_liability');
    expect(ids(l)).toContain('missing:termination');
  });
  it('الاختصاص بنص «يختص بنظر المنازعات القضاء المختص» يُعد نصاً عن الاختصاص', () => {
    const l = checkMissingClauses(mk(['تعتبر عناوين الطرفين موطناً مختاراً لهما. ويختص بنظر المنازعات القضاء المختص بمحل العقار.', 'يلتزم البائع بتسليم الوحدة والثمن مليون جنيه يسدد على أقساط.']), { contractType: 'عقد بيع', textMayBeIncomplete: false });
    expect(ids(l)).not.toContain('missing:governing_law');
  });
  it('غياب أى نص عن الاختصاص فى البيع ما زال يُرصد', () => {
    const l = checkMissingClauses(mk(['تعتبر عناوين الطرفين موطناً مختاراً لهما.', 'يلتزم البائع بتسليم الوحدة والثمن مليون جنيه يسدد على أقساط ولا يتنازل المشترى عن حصته.']), { contractType: 'عقد بيع', textMayBeIncomplete: false });
    expect(ids(l)).toContain('missing:governing_law');
  });
});
