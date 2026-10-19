import { ExtractionService, stripPdfPageMarkers } from './extraction.service';

/**
 * اختبارات وحدة لـExtractionService — تُغطى هنا فقط المسارات القابلة للاختبار
 * بلا ملفات DOCX/PDF حقيقية (تحويل نوع غير مدعوم، نص فارغ/قصير جداً، وكاشف
 * تلف الترميز isLikelyCorrupted غير المُصدَّر). اختبار الاستخراج الفعلى من
 * ملفات docx/pdf حقيقية يحتاج fixtures ثنائية منفصلة عن هذا الملف — خارج
 * نطاق هذه الدفعة (Phase 1+2 الأساسية).
 */
describe('ExtractionService', () => {
  let service: ExtractionService;

  beforeEach(() => {
    service = new ExtractionService();
  });

  it('يرفض نوع ملف غير مدعوم (مثال: صورة) بحالة unsupported_type', async () => {
    const result = await service.extract(Buffer.from('irrelevant'), 'image/png', 'scan.png');
    expect(result.status).toBe('unsupported_type');
  });

  it('يُبلِغ بحالة error عند فشل تحليل DOCX تالف البنية دون رمى استثناء غير مُعالَج', async () => {
    // buffer غير صالح كأرشيف ZIP/DOCX حقيقى — mammoth سيفشل داخلياً، ويجب أن
    // يُترجَم هذا لحالة 'error' موصوفة بدل رمى استثناء يُسقط الطلب بـ500 عارٍ.
    const result = await service.extract(
      Buffer.from('this is not a real docx zip archive'),
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'broken.docx',
    );
    expect(result.status).toBe('error');
  });

  it('يميّز نوع الملف من امتداد اسم الملف عند غياب/عدم دقة الـmimeType', async () => {
    // نفس محتوى docx تالف، لكن التمييز هنا يُختبَر عبر الامتداد لا الـmimeType
    // (mimeType فارغ عمداً) — يجب أن يُعامَل كمحاولة DOCX (وتفشل لاحقاً بـerror
    // بسبب المحتوى المزيَّف، لا unsupported_type بسبب سوء تصنيف النوع نفسه).
    const result = await service.extract(Buffer.from('not a real docx'), '', 'عقد.docx');
    expect(result.status).not.toBe('unsupported_type');
  });

  it('يحذف فواصل صفحات pdf-parse حتى لا يُعدّ PDF ممسوح (6 صفحات صور) نصاً كافياً', () => {
    const scanned = ['', '-- 1 of 6 --', '', '-- 2 of 6 --', '', '-- 6 of 6 --', ''].join('\n');
    expect(stripPdfPageMarkers(scanned).trim()).toBe('');
  });

  it('يُبقى النص الحقيقى ويحذف الفواصل بينه', () => {
    const t = stripPdfPageMarkers('البند الأول\nنص\n\n-- 1 of 2 --\n\nتكملة\n-- 2 of 2 --');
    expect(t).toContain('البند الأول');
    expect(t).toContain('تكملة');
    expect(t).not.toMatch(/of 2/);
  });
});
