import { SegmentationService, recoverHeadsFromTitleLines } from './segmentation.service';
import { findAdverbialHeads } from './clause-headings-alt';

// الجولة 92: نص إيجار ممسوح كما قرأه الخادم فى الإنتاج (بدايات الأسطر فقط من سجل Railway): عناوين «رابعاً… سابعاً، عاشراً، حادى عشر، رابع عشر» مقروءة،
// و«أولاً/ثانياً/ثالثاً» و«ثامناً/تاسعاً» و«ثالث عشر» و«خامس عشر» لم تُقرأ؛ وكل بند يبدأ بسطر «العنوان: متن».
const IJAR_A_PROD = `أبرم هذا العقد فى مدينة القاهرة بين السيدة/ سعاد
الأول) والسيد/ مراد عبدالله (وبشار إلية بالمستاج

Vol

التمهيد: تمتلك المؤجرة المحل التجارى رقم 6 بالعق
نصر, ويرغب المستأجر فى استئجاره لمزاولة نشاط بيع
العين المؤجزة: أجزرت المؤجزة للمستأجر المحل بالح
بمعاينته ورضائه وتنازل عن التمسك بأى عيب ظاهر أو
مدة الإيجار: مدة الإيجار سنة واحدة تبدأ من 1/1/2
قبل انتهاء مدته بإخطار قبل سبعة أيام دون تعويض.

رابعاً

الأجرة: الأجرة «axi> 15000 d.u.@.w.“ تزاد %15 ست
بنسية أخرى بحسب ما تقذره من ظروف السوق دون موافق

خامساً
السداد: تسدد الأجرة عن سنة كاملة مقدماً فى أول ك
التزم بغرامة %5 يوميا من الأجرة المستحقة.

سادسا

التأمين: يدفع المستأجر تأميناً قدره ستة أشهر أجر
المؤجرة ملكاً خالصاً.

سابعاً
الصيانة والإصلاحات: يتحمل المستأجر جميع الإصلاحا

والجسيمة والعيوب القائمة وقت العقد. ولا يحق له ا
التنازل والتأجير من الباطن: لا يجوز للمستأجر الت

بأى حال, ويجوز للمؤجرة التنازل عن العقد وبيع الع
ودون إخطاره.


الإخلاء والفسخ: إذا تأخر المستأجر عن سداد الأجرة

الأقفال وإخراج منقولاته بنفسها وحجزها وبيعها است
تلقاء نفسه دون إنذار أو حكم قضائى.

عاشراً

دخول المؤجرة للعين: يحق للمؤجرة دخول المحل فى أى
لمغاينته أو Y غرض تزتئيه. ويتحمل المستأجر sl تلف

حادى عشر

التجديد: يتجدد العقد تلقائياً لمدد متتالية كل من
للمستأجر إنهاؤه إلا بإخطار قبل ستة أشهر من انتها

البند الثاني عشر

الفسكولية والتامين على العين: يتحمل المسئولية ال
تلف بالعين L كان سببه ولو بقوة قاهرة أو بفعل الغ
رد الغين عند الانتهاء: 350 المستأجر العين عند ال
تحسينات أو تجهيزات ثابتة ملكاً للمؤجرة دون ٠ (SR
رابع عشر

القانون الواجب والنزاعات: ينعقد الاختصاص لمحكم ت
il ويتخمل المستاجر نفقاته.

إحكام ختافية: > هذا العقد من نسختين بيد كل طرف ن

i a,le الطرف الأول`;

describe('الجولة 92 — استرجاع عناوين بنود عقد ممسوح من سطور «العنوان:»', () => {
  const svc = new SegmentationService();

  it('إيجار الإنتاج: التسلسل المتأخر مقبول وكل البنود الـ15 تُسترجع بأرقامها', () => {
    const r = svc.segment(IJAR_A_PROD);
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    expect(r.clauses[1].text).toContain('العين المؤجزة');
    expect(r.clauses[1].text).not.toContain('مدة الإيجار');
    expect(r.clauses[2].text).toContain('مدة الإيجار');
    expect(r.clauses[7].text).toContain('التنازل والتأجير من الباطن');
    expect(r.clauses[8].text).toContain('الإخلاء والفسخ');
    expect(r.clauses[11].text).toContain('الفسكولية');
    expect(r.clauses[12].text).toContain('رد الغين');
    expect(r.clauses[14].text).toContain('ختافية');
    // عنوان «البند الثاني عشر» المقروء لا يبقى ذيلاً فى البند 11
    expect(r.clauses[10].text).not.toContain('البند الثاني عشر');
    expect(r.preamble).toContain('أبرم هذا العقد');
    expect(r.preamble).not.toContain('التمهيد');
    expect(r.warnings.some((w) => w.includes('سطر «العنوان: …»'))).toBe(true);
  });

  it('عناوين مقروءة متأخرة قليلة (أقل من 5) لا تُعد تسلسلاً', () => {
    const text = ['مقدمة العقد بين الطرفين وما اتفقا عليه.', 'رابعاً', 'الأجرة: تسدد الأجرة كل شهر مقدماً.', 'خامساً', 'السداد: يسدد المبلغ فى موعده المحدد.', 'سادساً', 'التأمين: يدفع المستأجر تأميناً.'].join('\n');
    expect(findAdverbialHeads(text)).toEqual([]);
  });

  it('عدد سطور العناوين لا يطابق عدد الأرقام الناقصة ⇒ لا تغيير', () => {
    const lines = IJAR_A_PROD.split('\n');
    // سطر عنوان زائد فى نافذة البندين 7 و10 (3 عناوين بدل 2)
    const idx = lines.findIndex((l) => l.startsWith('الإخلاء والفسخ'));
    lines.splice(idx + 1, 0, 'ويحق للمؤجرة كذلك: أن تنهى العقد عند أى مخالفة جسيمة');
    const r = svc.segment(lines.join('\n'));
    const nums = r.clauses.map((c) => c.declaredNumber);
    expect(nums).not.toContain(8);
    expect(nums).not.toContain(9);
  });

  it('عقد بلا نمط «العنوان:» (عناوين قصيرة لا تتبع العناوين الترتيبية) ⇒ لا استرجاع', () => {
    const heads = [
      { lineStart: 0, markerStart: 0, marker: 'رابعاً', rawLength: 6, declaredNumber: 4 },
      { lineStart: 40, markerStart: 40, marker: 'خامساً', rawLength: 6, declaredNumber: 5 },
      { lineStart: 80, markerStart: 80, marker: 'سابعاً', rawLength: 6, declaredNumber: 7 },
    ];
    const text = 'رابعاً\nتسدد الأجرة مقدماً كل شهر.\n\n\nخامساً\nيلتزم المستأجر بالصيانة الدورية.\n\nسادساً: بند ضائع العنوان تسدد فيه الأجرة\n\nسابعاً\nنص البند السابع كاملاً هنا.';
    const r = recoverHeadsFromTitleLines(text, heads);
    expect(r.recovered).toEqual([]);
  });
  it('البند الختامى يُسترجع حتى لو سبقه سطر «كلمة: …» عابر من متن البند الأخير', () => {
    const lines = IJAR_A_PROD.split('\n');
    const i = lines.findIndex((l) => l.startsWith('il ويتخمل'));
    lines[i] = 'نهائن: ويتحمل المستاجر نفقاته كاملة.';
    const r = svc.segment(lines.join('\n'));
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    expect(r.clauses[13].text).toContain('نهائن');
    expect(r.clauses[14].text).toContain('ختافية');
  });
});

describe('الجولة 92.1 — رمز أو رقم ملصق بسطر العنوان لا يُسقط السطر من العدّ', () => {
  const svc = new SegmentationService();
  it('«مدة الإيجار 520: …» و«520 العين المؤجرة: …» تُعدّان سطرى عنوان', () => {
    const lines = IJAR_A_PROD.split('\n');
    const i2 = lines.findIndex((l) => l.startsWith('العين المؤجزة'));
    const i3 = lines.findIndex((l) => l.startsWith('مدة الإيجار'));
    lines[i2] = '520 ' + lines[i2];
    lines[i3] = lines[i3].replace('مدة الإيجار:', 'مدة الإيجار 520:');
    const r = svc.segment(lines.join('\n'));
    expect(r.clauses.map((c) => c.declaredNumber)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
    expect(r.clauses[1].text).toContain('العين المؤجزة');
    expect(r.clauses[2].text).toContain('مدة الإيجار');
  });
});
