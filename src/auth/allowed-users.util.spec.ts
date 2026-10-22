import { isClosedAccessMode, isEmailAllowed, parseAllowedEmails } from './allowed-users.util';

describe('allowed-users.util — وضع المستخدم الواحد', () => {
  it('غير معيَّن أو فارغ = الوضع المغلق غير مفعَّل ولا قيد على أحد', () => {
    for (const raw of [undefined, null, '', '   ', 0, false]) {
      expect(isClosedAccessMode(raw)).toBe(false);
      expect(isEmailAllowed(raw, 'anyone@example.com')).toBe(true);
    }
  });

  it('معيَّن: يُسمح للبريد المذكور فقط، بلا حساسية لحالة الأحرف أو الفراغات', () => {
    const raw = ' Me@Example.com ';
    expect(isClosedAccessMode(raw)).toBe(true);
    expect(isEmailAllowed(raw, 'me@example.com')).toBe(true);
    expect(isEmailAllowed(raw, '  ME@EXAMPLE.COM ')).toBe(true);
    expect(isEmailAllowed(raw, 'other@example.com')).toBe(false);
    expect(isEmailAllowed(raw, 'me@example.com.evil.io')).toBe(false);
    expect(isEmailAllowed(raw, 'xme@example.com')).toBe(false);
    expect(isEmailAllowed(raw, null)).toBe(false);
    expect(isEmailAllowed(raw, undefined)).toBe(false);
  });

  it('عدة بريد مفصولة بفاصلة أو مسافة أو فاصلة منقوطة', () => {
    const raw = 'a@x.com, b@x.com;c@x.com d@x.com';
    expect(parseAllowedEmails(raw)).toEqual(['a@x.com', 'b@x.com', 'c@x.com', 'd@x.com']);
    expect(isEmailAllowed(raw, 'c@x.com')).toBe(true);
    expect(isEmailAllowed(raw, 'e@x.com')).toBe(false);
  });

  it('فشل مغلق: قيمة غير فارغة بلا بريد صالح (خطأ كتابة) تبقى الوضع المغلق ولا تسمح لأحد', () => {
    expect(isClosedAccessMode('ahmed')).toBe(true);
    expect(parseAllowedEmails('ahmed')).toEqual([]);
    expect(isEmailAllowed('ahmed', 'ahmed@example.com')).toBe(false);
    expect(isEmailAllowed('ahmed', 'anyone@example.com')).toBe(false);
  });

  it('الزائر لا يُسمح له فى الوضع المغلق مهما كان بريده', () => {
    expect(isEmailAllowed('me@example.com', 'guest-1@guest.invalid')).toBe(false);
  });
});
