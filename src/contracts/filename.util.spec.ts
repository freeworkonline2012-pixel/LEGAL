import { normalizeUploadedFilename } from './filename.util';

describe('normalizeUploadedFilename', () => {
  it('يصلح اسماً عربياً وصل مشوَّهاً بترميز latin1', () => {
    const arabic = 'عقد ايجار فرع.docx';
    const mojibake = Buffer.from(arabic, 'utf8').toString('latin1');
    expect(normalizeUploadedFilename(mojibake)).toBe(arabic);
  });

  it('لا يمسّ اسماً عربياً سليماً أصلاً', () => {
    expect(normalizeUploadedFilename('عقد ايجار.docx')).toBe('عقد ايجار.docx');
  });

  it('لا يمسّ اسماً لاتينياً عادياً', () => {
    expect(normalizeUploadedFilename('contract-v2.pdf')).toBe('contract-v2.pdf');
  });

  it('يزيل فواصل المسارات والمحارف التحكمية', () => {
    expect(normalizeUploadedFilename('..\\..\\evil\u0000/name.docx')).toBe('.._.._evil_name.docx');
  });

  it('يحدّ الطول مع إبقاء الامتداد', () => {
    const out = normalizeUploadedFilename('a'.repeat(500) + '.pdf');
    expect(out.length).toBeLessThanOrEqual(200);
    expect(out.endsWith('.pdf')).toBe(true);
  });

  it('يعيد اسماً افتراضياً عند الفراغ', () => {
    expect(normalizeUploadedFilename('   ')).toBe('contract');
  });
});
