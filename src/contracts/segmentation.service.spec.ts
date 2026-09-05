import { SegmentationService } from './segmentation.service';

/**
 * بيانات اختبار **مُصطنَعة** بالكامل (لا نص عقد عميل حقيقى) — قرار خصوصية
 * صريح (راجع تقرير جلسة 2026-09-05): العقود الأربعة الحقيقية المُختبَر بها
 * هذا المنطق فعلياً (إيجار إسكندرية/أسيوط، تسويق إلكترونى/PDF) تحتوى مبالغ
 * إيجار وأرقام هوية وأسماء أطراف حقيقية، فلا يجوز الالتزام بها فى git كـ
 * fixtures. الحالات هنا مصمَّمة عمداً لتكرار نفس الأنماط البنيوية المكتشَفة
 * فعلياً من تلك العقود الحقيقية (لا نظرياً):
 *  - ترقيم ببنود مكتوبة بالكلمات (لا أرقام).
 *  - بند بعنوان صريح بعد ":" وبند بلا عنوان.
 *  - جملة إحالة داخل متن بند تذكر رقم بند آخر منتصف السطر (نفس بنية الجملة
 *    الحقيقية "يتم تنفيذ أحكام البند السابع عشر من العقد الأصلي..." التى
 *    سبَّبت الخطأ الحقيقى المُكتشَف والمُصلَح فى segmentation.service.ts).
 */
describe('SegmentationService', () => {
  let service: SegmentationService;

  beforeEach(() => {
    service = new SegmentationService();
  });

  it('يقسّم عقداً بسيطاً ذا 3 بنود مرقّمة بالكلمات دون فقد أى بند', () => {
    const text = [
      'تمهيد: هذا العقد مبرم بين الطرف الأول والطرف الثانى.',
      '',
      'البند الأول: مدة العقد',
      'مدة هذا العقد سنة واحدة قابلة للتجديد.',
      '',
      'البند الثانى: قيمة العقد',
      'يلتزم الطرف الثانى بسداد القيمة المتفق عليها شهرياً.',
      '',
      'البند الثالث',
      'يخضع هذا العقد لأحكام القانون المصرى.',
    ].join('\n');

    const result = service.segment(text);

    expect(result.clauses).toHaveLength(3);
    expect(result.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3]);
    expect(result.clauses[0].title).toBe('مدة العقد');
    expect(result.clauses[0].text).toContain('سنة واحدة');
    expect(result.clauses[1].title).toBe('قيمة العقد');
    // البند الثالث بلا ":" — لا عنوان صريح، والمتن هو كل ما بعد العلامة
    expect(result.clauses[2].title).toBeNull();
    expect(result.clauses[2].text).toContain('يخضع هذا العقد');
    expect(result.warnings).toHaveLength(0);
  });

  it('لا يُطابِق إحالة نصية داخل متن بند تذكر رقم بند آخر منتصف السطر (الخطأ الحقيقى المُكتشَف والمُصلَح)', () => {
    // إعادة بناء بنيوية للنمط الحقيقى: جملة تبدأ بكلمة أخرى ("يتم") وتذكر
    // "البند السابع عشر" فى منتصفها — يجب ألا تُعامَل كحد فاصل لبند جديد.
    const text = [
      'البند الأول: الالتزامات العامة',
      'يلتزم كل طرف بتنفيذ ما ورد فى هذا العقد. يتم تنفيذ أحكام البند السابع عشر من العقد الأصلي المبرم سابقاً بين الطرفين عند التعارض.',
      '',
      'البند الثانى: الإنهاء',
      'يجوز لأى طرف إنهاء العقد بإخطار كتابى.',
    ].join('\n');

    const result = service.segment(text);

    expect(result.clauses).toHaveLength(2);
    expect(result.clauses.map((c) => c.declaredNumber)).toEqual([1, 2]);
    expect(result.warnings).toHaveLength(0);
    // الجملة المُحيلة يجب أن تبقى جزءاً من متن البند الأول، لا بنداً مستقلاً
    expect(result.clauses[0].text).toContain('يتم تنفيذ أحكام البند السابع عشر');
  });

  it('يُصدر تحذيراً عند ترقيم غير متسلسل (بند مفقود)', () => {
    const text = [
      'البند الأول: مقدمة',
      'نص البند الأول.',
      '',
      'البند الثالث: نطاق العمل',
      'نص البند الثالث (البند الثانى مفقود من هذا العقد الاختبارى عمداً).',
    ].join('\n');

    const result = service.segment(text);

    expect(result.clauses).toHaveLength(2);
    expect(result.warnings.some((w) => w.includes('غير متسلسل'))).toBe(true);
  });

  it('يُصدر تحذيراً عند عدم العثور على أى بند إطلاقاً', () => {
    const text = 'نص عقد بلا أى نمط ترقيم "البند" معروف — فقرات حرة فقط.';

    const result = service.segment(text);

    expect(result.clauses).toHaveLength(0);
    expect(result.warnings.some((w) => w.includes('لم يُعثَر على أى بند'))).toBe(true);
  });

  it('يُصدر تحذيراً عند وجود بند بلا أى متن (لا عنوان بعد ":" ولا نص) قبل بدء البند التالى مباشرة', () => {
    // "البند الأول" بلا ":" وبلا أى حرف بعده إطلاقاً قبل بدء "البند الثانى" —
    // حالة نادرة لكن واردة (خطأ فى العقد الأصلى، أو ترقيم بند تمهيدى فارغ).
    const text = ['البند الأول', '', 'البند الثانى: بند طبيعى', 'نص كافٍ هنا.'].join('\n');

    const result = service.segment(text);

    expect(result.warnings.some((w) => w.includes('شبه فارغ'))).toBe(true);
  });

  it('يدعم تهجئتى "الثانى" و"الثاني" كترقيم صالح لنفس الرقم 2', () => {
    const textAlefMaksura = 'البند الأول: أ\nنص.\n\nالبند الثانى: ب\nنص.';
    const textYaa = 'البند الأول: أ\nنص.\n\nالبند الثاني: ب\nنص.';

    expect(service.segment(textAlefMaksura).clauses[1].declaredNumber).toBe(2);
    expect(service.segment(textYaa).clauses[1].declaredNumber).toBe(2);
  });
});
