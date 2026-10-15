import { matchGlossary, normalizeArabic, type GlossaryTerm } from './glossary';

const TERMS: GlossaryTerm[] = [
  { ar: 'القوة القاهرة', en: 'Force Majeure', domain: 'general', note: 'ملاحظة' },
  { ar: 'الشرط الجزائى', en: 'Liquidated Damages Clause', domain: 'general', note: null },
  { ar: 'التحكيم', en: 'Arbitration', domain: 'general', note: null },
  { ar: 'الضمان', en: 'Warranty', domain: 'general', note: 'ملاحظة' },
  { ar: 'المقابل', en: 'Consideration', domain: 'general', note: 'ملاحظة' },
];

describe('normalizeArabic', () => {
  it('يوحّد الألف والياء والتاء المربوطة ويحذف التشكيل', () => {
    expect(normalizeArabic('القُوَّة القاهِرة')).toBe(normalizeArabic('القوه القاهره'));
    expect(normalizeArabic('الجزائى')).toBe(normalizeArabic('الجزائي'));
  });
});

describe('matchGlossary', () => {
  it('عربى: يطابق رغم اختلاف الهمزة/الياء واللواصق', () => {
    const hits = matchGlossary('فى حالة وقوع القوة القاهرة وبالتحكيم وفقاً للشرط الجزائي', 'ar', TERMS);
    expect(hits.map((h) => h.en).sort()).toEqual(['Arbitration', 'Force Majeure', 'Liquidated Damages Clause']);
  });

  it('إنجليزى: كلمة كاملة وغير حساس للحالة', () => {
    const hits = matchGlossary('The Consideration is paid. Arbitrations are out of scope; FORCE MAJEURE applies.', 'en', TERMS);
    expect(hits.map((h) => h.en).sort()).toEqual(['Consideration', 'Force Majeure']);
  });

  it('المصطلحات ذات الملاحظة أولاً', () => {
    const hits = matchGlossary('التحكيم والقوة القاهرة', 'ar', TERMS);
    expect(hits[0].en).toBe('Force Majeure');
  });

  it('لا يطابق مصطلحاً داخل كلمة أخرى (ضمان ≠ مضمون جزئياً)', () => {
    const t: GlossaryTerm[] = [{ ar: 'شرط', en: 'Condition', domain: 'general', note: null }];
    expect(matchGlossary('هذا بيع مشروط بموافقة الجهة', 'ar', t)).toEqual([]);
    expect(matchGlossary('يخضع هذا الشرط للقانون', 'ar', t).map((h) => h.en)).toEqual(['Condition']);
  });

  it('لا تطابق = قائمة فارغة', () => {
    expect(matchGlossary('نص بلا مصطلحات', 'ar', TERMS)).toEqual([]);
  });
});
