import { SegmentationService, describeGapWindow } from './segmentation.service';

const seg = (t: string) => new SegmentationService().segment(t);
const nums = (t: string) => seg(t).clauses.map((c) => c.declaredNumber);
const BODY = 'يلتزم الطرف الأول بتسليم الطرف الثانى الوحدة المبيعة فى الموعد المتفق عليه كتابةً';

/** عقد البيع كما ظهر فى لوج الإنتاج (نص بلا أسطر فارغة بين البنود 4 و8): L86 = «oalall o gl»، والفقرة الفرعية 1/5 قُرئت «5 يلتزم…». */
const saleDense = (five: string, six: string, seven: string) =>
  [
    'عقد بيع وحدة إدارية',
    'البند الأول', BODY, `${BODY} ويقر الطرف الأول بذلك`,
    'البند الثانى', BODY, `${BODY} ويقر الطرف الأول بذلك`,
    'البند الثالث', BODY, `${BODY} ويقر الطرف الأول بذلك`,
    'البندالرايجع',
    'يشمل هذا البيع حصة للوحدة محل التعامل شائعة قدرها اثنين قيراط من أربعة',
    'وعشرون قيراط فى كامل أرض ومبانى العقار وكافة المرافق والأجزاء المشتركة بالإضافة',
    'لمساحة سيارة واحدة بالجراج والمبينة فى ملحق هذا العقد',
    five,
    '5 يلتزم الطرف الأول بتسليم الطرف الثانى الوحدة المبيعة فى موعد غايته 2/1/2013 م',
    'بالمواصفات الآتية .',
    '2/5 يلتزم الطرف الأول بعمل توكيل رسمى عام غير قابل للإلغاء للطرف الثانى بالبيع',
    six,
    'قبل الطرف الثانى أن يكون عضواً فى اتحاد الملاك بنصيب فى الأرض والأجزاء المشتركة',
    seven,
    'يقر الطرف الأول بأن ملكية العقار قد آلت إليه بموجب العقد المشهر رقم 3394 بتاريخ 2007',
    'البند الثامن', BODY, `${BODY} ويقر الطرف الأول بذلك`,
    'البند التاسع', BODY, `${BODY} ويقر الطرف الأول بذلك`,
  ].join('\n');

describe('الجولة 85 — عناوين البيع كما قُرئت فى الإنتاج', () => {
  it('«oalall o gl» (لاتينى خالص بحرف وحرفين) يُقرأ البند الخامس بدليل الفقرة الفرعية «5 يلتزم»', () => {
    const r = seg(saleDense('oalall o gl', 'عضوية الاتحاد', 'الملكية'));
    const c5 = r.clauses.find((c) => c.declaredNumber === 5);
    expect(c5).toBeDefined();
    expect(c5?.text).toContain('يلتزم الطرف الأول بتسليم');
    const c4 = r.clauses.find((c) => c.declaredNumber === 4);
    expect(c4?.text).not.toContain('بتسليم');
    expect(r.warnings.join(' ')).toMatch(/سطراً قصيراً تالفاً/);
  });

  it('ترويسة لاتينية خالصة بلا رمز قصير («Office Supplies») ليست عنواناً', () => {
    expect(nums(saleDense('Office Supplies', 'عضوية الاتحاد', 'الملكية'))).not.toContain(5);
  });

  it('«gulalla 3¢ 11 غعشر» يحمل رقمه 11 فيُسترجع البند 11، وعنوان 12 الضائع كلياً يُحدَّد فى الجولة 87 من نهاية الفقرة المبتورة', () => {
    const t = [
      'عقد بيع',
      'البند الأول', BODY, `${BODY} ويقر`,
      'البند الثانى', BODY, `${BODY} ويقر`,
      'البند الثالث', BODY, `${BODY} ويقر`,
      'البند الرابع', BODY, `${BODY} ويقر`,
      'البند الخامس', BODY, `${BODY} ويقر`,
      'البند السادس', BODY, `${BODY} ويقر`,
      'البند السابع', BODY, `${BODY} ويقر`,
      'البند الثامن', BODY, `${BODY} ويقر`,
      'البند التاسع', BODY, `${BODY} ويقر`,
      'البند العاشر',
      'ملاك الوحدات يكونوا اتحاد فيما بينهم يكون المشترى طرفاً فيه ويلتزم',
      'الطرف الثانى بدفع مبلغ مائة ألف جنيه لاتحاد الشاغلين عند استلام الوحدة المبيعة',
      'وأجرة البواب .',
      '',
      'gulalla 3¢ 11 غعشر',
      '',
      'يلتزم الطرف الثانى المشترى ألا يجرى أى أعمال بالواجهة أو الشرفات',
      'يغير من شكلها العام ولا يجوز له إحداث أى تعديل داخل الوحدة المبيعة',
      'حرصاً على سلامة المبنى.',
      'يمتنع على عمال الطرف الثانى فى حالة إتمام التشطيبات بمعرفة المشترى أن',
      'يقوموا بأعمال تحدث أى تلف بالعمارة أو تسبب للجيران أى ضرر وفى حالة',
      'البند الثالث عشر', BODY, `${BODY} ويقر`,
    ].join('\n');
    const r = seg(t);
    const n = r.clauses.map((c) => c.declaredNumber);
    expect(n).toContain(11);
    expect(n).toContain(12);
    expect(r.clauses.find((c) => c.declaredNumber === 12)?.text).toContain('يمتنع على عمال');
    expect(r.clauses.find((c) => c.declaredNumber === 11)?.text).not.toContain('يمتنع على عمال');
    expect(r.clauses.find((c) => c.declaredNumber === 11)?.text).toContain('ألا يجرى');
    expect(r.clauses.find((c) => c.declaredNumber === 10)?.text).not.toContain('ألا يجرى');
  });

  it('سطر قصير يحمل رقماً لا يطابق رقماً ناقصاً لا يُعد عنواناً', () => {
    const t = saleDense('oalall o 77 gl', 'عضوية الاتحاد', 'الملكية').replace('5 يلتزم', 'يلتزم');
    expect(nums(t)).not.toContain(5);
  });
});

describe('الجولة 85 — لوج نافذة الفجوة يعرض كل الأسطر القصيرة', () => {
  it('أسطر قصيرة كاملة وطويلة بطولها فقط، وأكثر من 14 سطراً', () => {
    const lines = ['البند الأول', ...Array.from({ length: 30 }, (_, i) => (i === 20 ? 'oalall o gl' : `سطر طويل من المتن رقم ${i} لا عنوان فيه ولا ضوضاء إطلاقاً أبداً`)), 'البند الثالث'];
    const text = lines.join('\n');
    const heads = [
      { lineStart: 0, declaredNumber: 1 },
      { lineStart: text.indexOf('البند الثالث'), declaredNumber: 3 },
    ];
    const out = describeGapWindow(text, heads, 2);
    expect(out).toContain('"oalall o gl"');
    expect(out.split(' | ').length).toBe(30);
    expect(out).not.toContain('سطر طويل');
  });
});
