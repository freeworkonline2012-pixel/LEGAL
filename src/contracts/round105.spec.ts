import { readFileSync } from 'fs';
import { join } from 'path';
import { articleFitsCompanyForm, companyFormDiag, isJointStockOnlyArticle } from './company-form-scope';

const LLC = readFileSync(join(__dirname, '__fixtures__', 'r102', 'llc_template_local_ocr.txt'), 'utf8');

// عبارات من نص المادتين 71 و72 كما عُرضتا فى تقرير الإنتاج (نصان قانونيان منشوران)
const ART_71 = 'تكون قرارات الجمعية العامة المكونة تكوينا صحيحا والمنعقدة وفقا للقانون ونظام الشركة ملزمة لجميع المساهمين سواء كانوا حاضرين أو غائبين أو مخالفين';
const ART_72 = 'يكون لكل مساهم حضور اجتماع الجمعية العامة وله حق مناقشة الموضوعات المدرجة فى جدول الأعمال واستجواب أعضاء مجلس الإدارة ومراقبى الحسابات';
const LLC_ARTICLE = 'تتكون الجمعية العامة للشركة ذات المسئولية المحدودة من الشركاء وتصدر قراراتها بأغلبية عدد الحصص الممثلة فى الاجتماع';

describe('الجولة 105: بوابة شكل الشركة (مواد المساهمة لا تُعرض على عقد شركة ذات مسئولية محدودة)', () => {
  it('النموذج الرسمى لعقد الشركة ذات المسئولية المحدودة (OCR حقيقى) ⇒ llc رغم ذكر «شركات المساهمة» فى الغلاف', () => {
    const d = companyFormDiag(LLC);
    expect(d.form).toBe('llc');
    expect(d.llcTerm).toBeGreaterThanOrEqual(1);
    expect(d.partnerWords).toBeGreaterThanOrEqual(10);
    expect(d.stockWords).toBeLessThanOrEqual(6);
  });

  it('عقد شركة مساهمة أو عقد توريد ⇒ لا بوابة', () => {
    const stock = 'عقد تأسيس شركة مساهمة مصرية. يتكون رأس المال من أسهم. يتولى إدارة الشركة مجلس إدارة. تجتمع الجمعية العامة للمساهمين. يحق لكل مساهم حضور الجمعية. '.repeat(6);
    expect(companyFormDiag(stock).form).toBeNull();
    const supply = 'يلتزم المورد بتوريد البضاعة خلال ثلاثين يوماً ويلتزم المشترى بسداد الثمن عند التسليم. '.repeat(10);
    expect(companyFormDiag(supply).form).toBeNull();
  });

  it('مادة بمفردات المساهمة وحدها من القانون 159/1981 أو لائحته ⇒ مادة مساهمة خالصة', () => {
    expect(isJointStockOnlyArticle({ lawNo: 159, lawYear: 1981, snippet: ART_71 })).toBe(true);
    expect(isJointStockOnlyArticle({ lawNo: 159, lawYear: 1981, snippet: ART_72 })).toBe(true);
    expect(isJointStockOnlyArticle({ lawNo: 96, lawYear: 1982, snippet: ART_72 })).toBe(true);
  });

  it('مادة تذكر الشركاء أو الحصص، أو من قانون آخر، أو بلا مفردات المساهمة ⇒ تبقى', () => {
    expect(isJointStockOnlyArticle({ lawNo: 159, lawYear: 1981, snippet: LLC_ARTICLE })).toBe(false);
    expect(isJointStockOnlyArticle({ lawNo: 159, lawYear: 1981, snippet: `${ART_72} وللشركاء فى الشركة ذات المسئولية المحدودة حق مماثل` })).toBe(false);
    expect(isJointStockOnlyArticle({ lawNo: 131, lawYear: 1948, snippet: ART_72 })).toBe(false);
    expect(isJointStockOnlyArticle({ lawNo: 159, lawYear: 1981, snippet: 'يجب إخطار الجهة الإدارية بأى تعديل فى نظام الشركة' })).toBe(false);
  });

  it('articleFitsCompanyForm: تُستبعد مادة المساهمة فى عقد LLC فقط، ولا استبعاد إن كان الشكل مجهولاً', () => {
    expect(articleFitsCompanyForm('llc', { lawNo: 159, lawYear: 1981, snippet: ART_71 })).toBe(false);
    expect(articleFitsCompanyForm('llc', { lawNo: 159, lawYear: 1981, snippet: LLC_ARTICLE })).toBe(true);
    expect(articleFitsCompanyForm(null, { lawNo: 159, lawYear: 1981, snippet: ART_71 })).toBe(true);
  });
});
