import { readFileSync } from 'fs';
import { join } from 'path';
import { aliasTokens, directionResolvable, extractPartyNames, partiesNamedIn } from './parties.util';

const PREAMBLE =
  'إنه فى يوم الثلاثاء الموافق 10/3/2026 تم الاتفاق بين كل من: 1- شركة بلاك بيلتس لتكنولوجيا المعلومات ، سجل تجارى رقم 12345 ويمثلها السيد/ أحمد ويشار إليها فيما بعد بـ (الطرف الأول). ' +
  '2- شركة أروب لتأمينات الممتلكات والمسئوليات ش.م.م ومقرها القاهرة ويمثلها السيد/ محمد ويشار إليها فيما بعد بـ (الطرف الثانى).';

describe('extractPartyNames (الجولة 31)', () => {
  it('يقرأ اسمى الطرفين من الديباجة ويقف عند وصف الجهة', () => {
    const p = extractPartyNames(PREAMBLE);
    expect(p.first).toBe('بلاك بيلتس لتكنولوجيا المعلومات');
    expect(p.second).toBe('أروب لتأمينات الممتلكات والمسئوليات');
  });

  it('لا يخمّن: بلا عبارة «الطرف الأول/الثانى» أو بلا اسم جهة يبقى null', () => {
    expect(extractPartyNames('هذا عقد توريد بين الشركتين.')).toEqual({ first: null, second: null });
    expect(extractPartyNames('')).toEqual({ first: null, second: null });
    expect(extractPartyNames(undefined)).toEqual({ first: null, second: null });
    const one = extractPartyNames('شركة ألفا للتجارة (الطرف الأول) والطرف الثانى هو العميل.');
    expect(one.first).toBe('ألفا للتجارة');
    expect(one.second).toBeNull();
  });

  it('اسم واحد لطرفين = التباس فلا يُعتمد أيهما', () => {
    expect(extractPartyNames('شركة ألفا (الطرف الأول) وشركة ألفا (الطرف الثانى).')).toEqual({ first: null, second: null });
  });
});

describe('الإحالة بالاسم', () => {
  const names = extractPartyNames(PREAMBLE);
  it('aliasTokens: رمزان مميزان بلا «شركة» ولا «ال»', () => {
    expect(aliasTokens('بلاك بيلتس لتكنولوجيا المعلومات')).toEqual(['بلاك', 'بيلتس']);
    expect(aliasTokens('الأروب')).toEqual(['اروب']);
  });
  it('يتعرف على الطرف بالاسم ولو شوّه المسح الحرف الأول («روب» لـ«أروب»)', () => {
    expect(partiesNamedIn('يجوز لشركة روب لتأمينات الممتلكات الرجوع على (شركة بلاك بيلتس) بما تراه.', names).sort()).toEqual(['first', 'second']);
    expect(partiesNamedIn('يلتزم الطرف الأول بالتسليم.', names)).toEqual([]);
  });
  it('directionResolvable: «الطرف الأول» أو اسم معروف يكفى، وإلا لا', () => {
    expect(directionResolvable('يحق للطرف الثانى الفسخ.', null)).toBe(true);
    expect(directionResolvable('يجوز لشركة أروب الرجوع بالتعويض.', names)).toBe(true);
    expect(directionResolvable('يجوز لشركة أروب الرجوع بالتعويض.', null)).toBe(false);
    expect(directionResolvable('يجوز للشركة الرجوع بالتعويض.', names)).toBe(false);
  });
});

describe('اسم الطرف لا اسم ممثله الموقّع (تصحيح بعد تقرير عقد حقيقى)', () => {
  const REAL =
    'تحرر هذا العقد بين كلا من :- أولا : شركة بلاك بيلتس شركة مصرية منشأة طبقا لأحكام ( القانون رقم 8 لسنة 1997 ) سجل تجارى رقم (96851) ومقرها الرئيسى كائن بالدور الثالث ' +
    'ويمثلها فى التوقيع على هذا العقد السيد / محمد عبد الواحد إسماعيل بصفته رئيس الشركة ( طرف أول ) ' +
    'ثانيا: شركة أروب لتأمينات الممتلكات والمسئوليات – مصر شركة مساهمة مصرية ومنشأة وفقا للقانون رقم 159 لسنة 1981 , سجل تجارى رقم ( 33541 ) ' +
    'ويمثلها فى التوقيع على هذا العقد السيد / مدحت صابر عبدالرحمن بصفته العضو المنتدب للشركة ( طرف ثانى )';

  it('يأخذ اسم الشركة لا الشخص الموقّع عنها ولو كُتب «السيد /» بمسافة', () => {
    expect(extractPartyNames(REAL)).toEqual({ first: 'بلاك بيلتس', second: 'أروب لتأمينات الممتلكات والمسئوليات' });
  });

  it('يبقى الشخص الطبيعى طرفاً إن لم يرد فى مقطعه اسم جهة', () => {
    const p = extractPartyNames('بين السيد / أحمد محمود علي المقيم بالقاهرة ( طرف أول ) وشركة ألفا للتجارة ( طرف ثانى )');
    expect(p.first).toBe('أحمد محمود علي');
    expect(p.second).toBe('ألفا للتجارة');
  });

  it('لا يُظهر ضجيج المسح اسماً: «بصسفته به» أو شرطة أو «/» وحدها تُرفض', () => {
    const noisy = REAL.replace('شركة بلاك بيلتس شركة مصرية', 'ش ر ك ة').replace('ويمثلها فى التوقيع على هذا العقد السيد / محمد عبد الواحد إسماعيل بصفته', 'ويمثلها السيد / بصسفته به');
    const p = extractPartyNames(noisy);
    expect(p.first).toBeNull();
    expect(p.second).toBe('أروب لتأمينات الممتلكات والمسئوليات');
    for (const bad of ['بصسفته', 'بصفتة', '/', '–']) {
      expect(extractPartyNames(`السيد ${bad} به ( طرف أول )`).first).toBeNull();
    }
  });
});

describe('الطرف الثانى حين تضيع عبارة «(طرف ثانى)» من المسح', () => {
  const BASE =
    'تحرر هذا العقد بين كلا من :- أولا : شركة بلاك بيلتس شركة مصرية سجل تجارى رقم (96851) ويمثلها السيد / محمد بصفته رئيس الشركة ( طرف أول ) ' +
    'ثانيا: شركة روب لتأمينات الممتلكات والمسئوليات – مصر شركة مساهمة مصرية سجل تجارى رقم ( 33541 ) ويمثلها السيد / مدحت بصفته العضو المنتدب ';

  it('يقرأه من ترقيم «ثانياً:» إن غابت عبارة الطرف الثانى أصلاً', () => {
    expect(extractPartyNames(BASE)).toEqual({ first: 'بلاك بيلتس', second: 'روب لتأمينات الممتلكات والمسئوليات' });
  });

  it('يقبل «طرف ثان» بلا ياء، وبلا التباس مع كلمات أخرى', () => {
    expect(extractPartyNames(BASE + '( طرف ثان )').second).toBe('روب لتأمينات الممتلكات والمسئوليات');
  });

  it('يقرأ الطرفين من الترقيم وحده، ولا يخمّن حيث لا اسم جهة', () => {
    expect(extractPartyNames('بين: أولا: شركة ألفا للتجارة ثانيا: شركة بيتا للمقاولات').first).toBe('ألفا للتجارة');
    expect(extractPartyNames('بين: أولا: السيد فلان ثانيا: ورثة المرحوم').second).toBeNull();
  });
});

describe('ديباجة ممسوحة حقيقية (Blackbelts، ناتج Tesseract الفعلى للصفحة الأولى)', () => {
  const fixture = (name: string) => {
    const t = readFileSync(join(__dirname, '__fixtures__', 'golden', name), 'utf-8');
    const end = t.indexOf('تمهيد');
    return end > 0 ? t.slice(0, end) : t.slice(0, 1500);
  };

  it('بدقة 200: الطرفان من الاسم رغم أن عنوان «ثانياً: شركة» صار رموزاً لاتينية وعلامات اتجاه مخفية', () => {
    expect(extractPartyNames(fixture('blackbelts-ocr-page1-200dpi.txt'))).toEqual({
      first: 'بلاك بيلتس',
      second: 'أروب لتأمينات الممتلكات والمسئوليات',
    });
  });

  it('بدقة 120 (أسوأ): الطرف الثانى يُقرأ، والأول يحتمل حرفاً زائداً من المسح لكنه لا يصير اسم الموقّع', () => {
    const p = extractPartyNames(fixture('blackbelts-ocr-page1-120dpi.txt'));
    expect(p.second).toBe('أروب لتأمينات الممتلكات والمسئوليات');
    expect(p.first).toMatch(/^بلاك بيلتس/);
  });

  it('الموقّع بعد «ويمثلها» لا يصير طرفاً حتى لو لم يرد اسم الجهة بكلمة «شركة»', () => {
    const p = extractPartyNames('أروب لتأمينات الممتلكات مصر ومقرها القاهرة ويمثلها السيد / مدحت صابر بصفته العضو المنتدب ( طرف ثانى )');
    expect(p.second).toBe('أروب لتأمينات الممتلكات مصر');
  });
});

describe('التصاق كلمة «شركة» برقم الترتيب بعد المسح', () => {
  it('«أولاشركة» و«ثانياشركة» تُقرآن، و«الشركة» و«للشركة» ليستا بداية اسم', () => {
    const p = extractPartyNames('بين أولاشركة بلاك بيلتس شركة مصرية ويمثلها السيد / محمد بصفته رئيس الشركة ( طرف أول ) ثانياشركة أروب للتأمين شركة مساهمة ومقرها القاهرة ( طرف ثانى )');
    expect(p).toEqual({ first: 'بلاك بيلتس', second: 'أروب للتأمين' });
  });
});
