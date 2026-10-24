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

  describe('نص مقروء آلياً (OCR)', () => {
    it('يتجاوز علامات الاتجاه غير المرئية فى أول السطر وآخره', () => {
      const text = '\u200fالتمهيد\u200e\n\u200fالبند الأول\u200e\nنص أول.\n\u200fالبند الثانى\u200e\nنص ثان.';
      const r = service.segment(text);
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2]);
    });

    it('يقبل حرفاً شاذاً واحداً قبل عنوان البند وتهجئة "الثان," الناقصة', () => {
      const text = ['البند الأول', 'نص أول.', 'ش البند الثان, ظ', 'نص ثان.', 'البند الثالث ْ ْ', 'نص ثالث.'].join('\n');
      const r = service.segment(text);
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3]);
      expect(r.clauses[1].text).toContain('نص ثان');
      expect(r.clauses[0].text).not.toContain('ش');
    });

    it('لا يعتبر سطراً يبدأ بحرف شاذ ثم جملة إحالة طويلة عنوان بند', () => {
      const text = [
        'البند الأول',
        'يلتزم الطرف الثانى بالسداد.',
        'و البند الثانى من هذا العقد يحكم مدة السداد وطريقة الدفع بين الطرفين.',
        'البند الثانى',
        'مدة العقد سنة.',
      ].join('\n');
      const r = service.segment(text);
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2]);
    });

    it('يقبل ترتيبياً بشرطة سفلية أو مسافة بعدها ("الحادى_عشر"، "الثالث_ عشر")', () => {
      const lines: string[] = [];
      for (const w of ['الأول', 'الثانى', 'الثالث', 'الرابع', 'الخامس', 'السادس', 'السابع', 'الثامن', 'التاسع', 'العاشر']) {
        lines.push(`البند ${w}`, 'نص.');
      }
      lines.push('البند الحادى_عشر', 'نص.', 'البند الثانى عشر', 'نص.', 'البند الثالث_ عشر', 'نص.');
      const r = service.segment(lines.join('\n'));
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]);
      expect(r.clauses[10].label).toBe('البند الحادى عشر');
      expect(r.warnings).toEqual([]);
    });

    it('يستعيد عنواناً سقطت منه كلمة "البند" فقط إن كان رقمه التالى مباشرة للبند السابق', () => {
      const text = ['البند الأول', 'نص أول.', 'الثانى', 'نص ثان.', 'البند الثالث', 'نص ثالث.'].join('\n');
      const r = service.segment(text);
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3]);
      expect(r.clauses[1].label).toBe('البند الثانى');
      expect(r.warnings).toEqual([]);
    });

    it('لا يعتبر سطراً مفرداً بترتيبى لا يتبع التسلسل عنوان بند', () => {
      const text = ['البند الأول', 'نص أول.', 'الخامس', 'نص.', 'البند الثانى', 'نص ثان.'].join('\n');
      const r = service.segment(text);
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2]);
    });

    it('لا يلتقط تهجئة ناقصة كجزء من كلمة أطول', () => {
      const r = service.segment('البند الثانية\nنص.');
      expect(r.clauses).toHaveLength(0);
    });
  });
  describe('بنود سابقة لأول عنوان مُتعرَّف عليه', () => {
    it('لا يُسقط النص الذى يسبق "البند الرابع" بصمت: يُدرجه بنداً واحداً غير مُقسَّم مع تنبيه', () => {
      const pre = 'تحرر هذا العقد بين شركتين وأتفق الطرفان على إنشاء برامج بسعر مليون جنيه وسداد الدفعات على ثلاث مراحل.';
      const r = service.segment([pre, 'البند الرابع', 'مدة العقد سنة.', 'البند الخامس', 'نص خامس.'].join('\n'));
      expect(r.clauses).toHaveLength(3);
      expect(r.clauses[0].declaredNumber).toBeNull();
      expect(r.clauses[0].text).toContain('بسعر مليون جنيه');
      expect(r.clauses.map((c) => c.index)).toEqual([1, 2, 3]);
      expect(r.warnings.some((w) => w.includes('غير مُقسَّم'))).toBe(true);
    });

    it('عقد سليم يبدأ بـ"البند الأول" لا يُضاف له بند سابق حتى مع وجود ديباجة', () => {
      const pre = 'تحرر هذا العقد بين شركتين وأتفق الطرفان على ما يلى بعد أن أقرا بأهليتهما القانونية للتعاقد.';
      const r = service.segment([pre, 'البند الأول', 'نص أول.', 'البند الثانى', 'نص ثان.'].join('\n'));
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2]);
      expect(r.warnings).toEqual([]);
    });
  });
  describe('استرجاع عناوين أسقطتها القراءة الآلية وتنبيه الإحالات', () => {
    it('يسترجع «الأول» المجرد حين يتبعه «البند الثانى» (عنوان مسطّر أسقطت القراءة كلمة «البند» منه)', () => {
      const text = ['ديباجة العقد بين الطرفين.', 'الأول', 'مدة العقد سنة.', 'البند الثانى', 'السداد شهرياً.'].join('\n');
      const r = service.segment(text);
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2]);
    });

    it('لا يعتبر «الأول» المجرد بنداً إن لم يتبعه عنوان كامل برقم أعلى', () => {
      const text = ['ديباجة.', 'الأول', 'نص عابر.', 'البند الأول', 'نص البند.'].join('\n');
      const r = service.segment(text);
      expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1]);
    });

    it('ينبّه حين يحيل النص إلى بند أعلى من آخر بند مقسَّم (علامة عنوان ساقط)', () => {
      const text = ['البند الأول', 'نص.', 'البند الثانى', 'تُسدد الغرامة وفقاً للبند الخامس من هذا العقد.'].join('\n');
      const r = service.segment(text);
      expect(r.warnings.some((w) => w.includes('البند رقم 5'))).toBe(true);
    });

    it('لا ينبّه لإحالة إلى بند فى عقد آخر («من العقد الأصلي»)', () => {
      const text = ['البند الأول', 'نص.', 'البند الثانى', 'تنفذ أحكام البند السابع عشر من العقد الأصلي.'].join('\n');
      const r = service.segment(text);
      expect(r.warnings).toEqual([]);
    });
  });
});
