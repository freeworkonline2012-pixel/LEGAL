import JSZip from 'jszip';
import { DOCX_LIMITS, DocxLayoutError, applyDocxTranslation, extractDocxParagraphs } from './docx-layout';
import { arabicContractDocx, englishContractDocx } from './docx-layout.fixtures';

const NS =
  'xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" ' +
  'xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"';

/** حزمة docx دنيا بجسم XML خام (لاختبار حالات حافة لا تنتجها مكتبة التوليد). */
async function rawDocx(body: string, extra: Record<string, string> = {}): Promise<Buffer> {
  const zip = new JSZip();
  zip.file('[Content_Types].xml', '<?xml version="1.0"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="xml" ContentType="application/xml"/></Types>');
  zip.file('word/document.xml', `<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:document ${NS}><w:body>${body}<w:sectPr><w:pgSz w:w="11906" w:h="16838"/></w:sectPr></w:body></w:document>`);
  for (const [name, xml] of Object.entries(extra)) zip.file(name, xml);
  return Buffer.from(await zip.generateAsync({ type: 'nodebuffer' }));
}

const run = (t: string, props = '') => `<w:r>${props ? `<w:rPr>${props}</w:rPr>` : ''}<w:t xml:space="preserve">${t}</w:t></w:r>`;
const para = (inner: string, pPr = '') => `<w:p>${pPr ? `<w:pPr>${pPr}</w:pPr>` : ''}${inner}</w:p>`;

async function partXml(buf: Buffer, name = 'word/document.xml'): Promise<string> {
  const zip = await JSZip.loadAsync(buf);
  return zip.file(name)!.async('string');
}
const count = (s: string, re: RegExp): number => (s.match(re) ?? []).length;

describe('extractDocxParagraphs', () => {
  it('يستخرج فقرات المتن والجداول والترويسة بترتيب ثابت، ويتجاوز فقرات الحقول والفواصل بلا حروف', async () => {
    const paras = await extractDocxParagraphs(await arabicContractDocx());
    const texts = paras.map((p) => p.text);
    expect(texts[0]).toBe('عقد تقديم خدمات');
    expect(texts).toContain('تم الاتفاق بين الطرف الأول والطرف الثانى على ما يلى:');
    expect(texts).toContain('سنة واحدة تبدأ من تاريخ التوقيع'); // خلية جدول
    expect(texts).not.toContain('* * *'); // بلا حروف
    expect(texts.some((t) => t.includes('صفحة'))).toBe(false); // فقرة حقل رقم الصفحة
    expect(paras.find((p) => p.part === 'word/header1.xml')?.text).toBe('عقد تقديم خدمات استشارية');
    expect(paras.map((p) => p.ordinal)).toEqual(paras.map((_, i) => i));
    // النص بعد الرابط يُدمج فى فقرة واحدة
    expect(texts).toContain('للاطلاع على اللائحة اضغط هنا وتُعد جزءاً من العقد.');
  });

  it('يحفظ فاصل السطر داخل الفقرة كـ \\n', async () => {
    const paras = await extractDocxParagraphs(await arabicContractDocx());
    expect(paras.map((p) => p.text)).toContain('الاسم: أحمد\nالعنوان: القاهرة');
  });

  it('الاستخراج حتمى: مرتان تعطيان الترتيب نفسه', async () => {
    const buf = await englishContractDocx();
    expect(await extractDocxParagraphs(buf)).toEqual(await extractDocxParagraphs(buf));
  });

  it('لا يأخذ النص المحذوف بتتبع التغييرات ويأخذ المُدرج', async () => {
    const buf = await rawDocx(para(run('Hello ') + '<w:del><w:r><w:delText>deleted words</w:delText></w:r></w:del>' + '<w:ins><w:r><w:t xml:space="preserve">inserted words</w:t></w:r></w:ins>'));
    expect((await extractDocxParagraphs(buf)).map((p) => p.text)).toEqual(['Hello inserted words']);
  });

  it('لا يكرر نص مربع النص (mc:Fallback) ويستخرج فقرته المتداخلة مرة واحدة', async () => {
    const tb = (t: string) => `<w:txbxContent>${para(run(t))}</w:txbxContent>`;
    const buf = await rawDocx(
      para(
        run('Outer text') + `<w:r><mc:AlternateContent><mc:Choice Requires="wps"><w:drawing><wps:txbx>${tb('Inside box')}</wps:txbx></w:drawing></mc:Choice><mc:Fallback><w:pict>${tb('Inside box')}</w:pict></mc:Fallback></mc:AlternateContent></w:r>`,
      ),
    );
    expect((await extractDocxParagraphs(buf)).map((p) => p.text)).toEqual(['Outer text', 'Inside box']);
  });

  it('فقرة بحقل (فهرس/رقم صفحة) لا تُستخرج', async () => {
    const buf = await rawDocx(
      para('<w:r><w:fldChar w:fldCharType="begin"/></w:r><w:r><w:instrText>PAGE</w:instrText></w:r><w:r><w:fldChar w:fldCharType="separate"/></w:r>' + run('Page one') + '<w:r><w:fldChar w:fldCharType="end"/></w:r>') +
        para('<w:fldSimple w:instr="PAGE">' + run('7') + '</w:fldSimple>' + run('Words')) +
        para(run('Plain paragraph')),
    );
    expect((await extractDocxParagraphs(buf)).map((p) => p.text)).toEqual(['Plain paragraph']);
  });

  it('التبويب بين مقطعين نصيين يُحفظ \\t', async () => {
    const buf = await rawDocx(para(run('Name') + '<w:r><w:tab/></w:r>' + run('Date')));
    expect((await extractDocxParagraphs(buf)).map((p) => p.text)).toEqual(['Name\tDate']);
  });

  it('يرفض ما ليس docx، وما بلا document.xml، وتعريف الكيانات، والجزء المتضخم، وكثرة الفقرات', async () => {
    await expect(extractDocxParagraphs(Buffer.from('not a zip'))).rejects.toBeInstanceOf(DocxLayoutError);
    const z = new JSZip();
    z.file('x.txt', 'x');
    await expect(extractDocxParagraphs(Buffer.from(await z.generateAsync({ type: 'nodebuffer' })))).rejects.toThrow('document.xml');
    const evil = await rawDocx('<w:p/>', {});
    const zip = await JSZip.loadAsync(evil);
    zip.file('word/document.xml', `<?xml version="1.0"?><!DOCTYPE d [<!ENTITY x "boom">]><w:document ${NS}><w:body><w:p><w:r><w:t>&x;</w:t></w:r></w:p></w:body></w:document>`);
    await expect(extractDocxParagraphs(Buffer.from(await zip.generateAsync({ type: 'nodebuffer' })))).rejects.toThrow('كيانات');
    const big = await rawDocx(para(run('A'.repeat(2000))));
    await expect(extractDocxParagraphs(big, { ...DOCX_LIMITS, maxPartBytes: 1000 })).rejects.toThrow('أكبر من الحد');
    const many = await rawDocx(Array.from({ length: 5 }, (_, i) => para(run(`P${i}`))).join(''));
    await expect(extractDocxParagraphs(many, { ...DOCX_LIMITS, maxParagraphs: 3 })).rejects.toThrow('عدد الفقرات');
  });
});

describe('applyDocxTranslation — عربى إلى إنجليزى', () => {
  async function translated() {
    const src = await arabicContractDocx();
    const paras = await extractDocxParagraphs(src);
    const map = new Map<number, string>();
    paras.forEach((p) => map.set(p.ordinal, `EN${p.ordinal}` + (p.text.includes('\n') ? '\nline2' : '')));
    const out = await applyDocxTranslation(src, map, { to: 'en', banner: 'DRAFT TRANSLATION — REVIEW REQUIRED' });
    return { src, out, paras };
  }

  it('الناتج حزمة Word صالحة، وكل أجزائها غير النصية كما هى', async () => {
    const { src, out } = await translated();
    const a = await JSZip.loadAsync(src);
    const b = await JSZip.loadAsync(out);
    expect(Object.keys(b.files).sort()).toEqual(Object.keys(a.files).sort());
    for (const name of ['word/styles.xml', 'word/numbering.xml', 'word/_rels/document.xml.rels', '[Content_Types].xml', 'word/footer1.xml']) {
      expect(await b.file(name)!.async('string')).toBe(await a.file(name)!.async('string'));
    }
  });

  it('الترجمة تحل محل النص كله ولا يبقى حرف عربى فى الفقرات المترجمة (متن وترويسة)', async () => {
    const { out } = await translated();
    const doc = await partXml(out);
    const text = [...doc.matchAll(/<w:t[^>]*>([^<]*)<\/w:t>/g)].map((m) => m[1]).join(' ');
    expect(text).not.toMatch(/[؀-ۿ]/);
    expect(text).toContain('EN1');
    expect(text).toContain('DRAFT TRANSLATION');
    expect(await partXml(out, 'word/header1.xml')).toContain('EN13');
  });

  it('البنية محفوظة: الترقيم الآلى والجدول وخلاياه والروابط وفاصل السطر', async () => {
    const { src, out } = await translated();
    const a = await partXml(src);
    const b = await partXml(out);
    expect(count(b, /<w:numPr>/g)).toBe(count(a, /<w:numPr>/g));
    expect(count(b, /<w:tbl>/g)).toBe(1);
    expect(count(b, /<w:tc>/g)).toBe(count(a, /<w:tc>/g));
    expect(count(b, /<w:tr>/g)).toBe(count(a, /<w:tr>/g));
    expect(count(b, /<w:br\/>/g)).toBeGreaterThanOrEqual(1);
    // الرابط أُزيل نصه مع باقى الفقرة ولم يبق حاوية رابط فارغة
    expect(b).not.toMatch(/<w:hyperlink[^>]*>\s*<\/w:hyperlink>/);
    // فقرة الحقل (التذييل) لم تُمس
    expect(await partXml(out, 'word/footer1.xml')).toContain('صفحة');
  });

  it('الاتجاه ينعكس إلى LTR صراحةً: bidi=0 للفقرات وrtl=0 للمقاطع وbidiVisual=0 للجدول', async () => {
    const { out } = await translated();
    const b = await partXml(out);
    expect(b).not.toMatch(/<w:bidi\/>/);
    expect(count(b, /<w:bidi w:val="0"\/>/g)).toBeGreaterThan(5);
    expect(b).toMatch(/<w:bidiVisual w:val="0"\/>/);
    expect(b).not.toMatch(/<w:rtl\/>/);
    expect(b).toMatch(/<w:rtl w:val="0"\/>/);
    expect(b).toMatch(/<w:lang [^>]*w:val="en-US"/);
  });

  it('خصائص الخط تُنقل: الحجم والسماكة للمقطع الجديد، وعنصر rPr بترتيب المخطط', async () => {
    const { out } = await translated();
    const b = await partXml(out);
    const title = b.slice(b.indexOf('EN0') - 700, b.indexOf('EN0'));
    expect(title).toMatch(/<w:sz w:val="32"\/>/);
    expect(title).toMatch(/<w:b\/>/);
    // ترتيب العناصر داخل كل rPr وفق المخطط (rFonts < b < sz < rtl < lang)
    const order = ['rFonts', 'b', 'bCs', 'i', 'iCs', 'color', 'sz', 'szCs', 'rtl', 'lang'];
    for (const m of b.matchAll(/<w:rPr>(.*?)<\/w:rPr>/g)) {
      const names = [...m[1].matchAll(/<w:([A-Za-z]+)[ />]/g)].map((x) => x[1]).filter((n) => order.includes(n));
      const idx = names.map((n) => order.indexOf(n));
      expect([...idx].sort((x, y) => x - y)).toEqual(idx);
    }
  });

  it('الإدخال فى pPr بترتيب المخطط (bidi قبل spacing وjc)', async () => {
    const { out } = await translated();
    const b = await partXml(out);
    for (const m of b.matchAll(/<w:pPr>(.*?)<\/w:pPr>/g)) {
      const names = [...m[1].matchAll(/<w:([A-Za-z]+)[ />]/g)].map((x) => x[1]);
      const bidi = names.indexOf('bidi');
      for (const later of ['spacing', 'ind', 'jc', 'rPr']) {
        const i = names.indexOf(later);
        if (bidi >= 0 && i >= 0) expect(bidi).toBeLessThan(i);
      }
    }
  });

  it('رحلة ذهاب وإياب: إعادة استخراج الناتج تعطى الترجمات نفسها بالترتيب نفسه', async () => {
    const { out, paras } = await translated();
    const again = await extractDocxParagraphs(out);
    // الفقرات المترجمة نفسها (والبانر فقرة إضافية أولى فى المتن)
    expect(again.map((p) => p.text).filter((t) => /^EN\d+/.test(t))).toEqual(paras.map((p, i) => `EN${i}` + (p.text.includes('\n') ? '\nline2' : '')));
  });

  it('فقرة بلا ترجمة تبقى بنصها الأصلى، وإدخال فارغ يُتجاهل', async () => {
    const src = await arabicContractDocx();
    const out = await applyDocxTranslation(src, new Map([[0, 'Title only'], [1, '   ']]), { to: 'en' });
    const texts = (await extractDocxParagraphs(out)).map((p) => p.text);
    expect(texts[0]).toBe('Title only');
    expect(texts[1]).toBe('تم الاتفاق بين الطرف الأول والطرف الثانى على ما يلى:');
    expect(await partXml(out)).not.toContain('DRAFT');
  });

  it('خريطة فارغة: لا يعدّل شيئاً (الأجزاء كما هى بايتاً ببايت)', async () => {
    const src = await arabicContractDocx();
    const out = await applyDocxTranslation(src, new Map(), { to: 'en', banner: 'X' });
    expect(await partXml(out)).toBe(await partXml(src));
  });
});

describe('applyDocxTranslation — إنجليزى إلى عربى', () => {
  it('يضيف bidi وrtl وbidiVisual وينقل sz إلى szCs وb إلى bCs ويضع لغة bidi', async () => {
    const src = await englishContractDocx();
    const paras = await extractDocxParagraphs(src);
    const out = await applyDocxTranslation(src, new Map(paras.map((p) => [p.ordinal, `ع${p.ordinal}`])), { to: 'ar', banner: 'مسودة ترجمة — تحتاج مراجعة' });
    const b = await partXml(out);
    expect(b).toMatch(/<w:bidi\/>/);
    expect(b).not.toMatch(/<w:bidi w:val="0"\/>/);
    expect(b).toMatch(/<w:bidiVisual\/>/);
    expect(b).toMatch(/<w:rtl\/>/);
    expect(b).toMatch(/<w:lang [^>]*w:bidi="ar-SA"/);
    const title = b.slice(b.indexOf('ع0') - 700, b.indexOf('ع0'));
    expect(title).toMatch(/<w:sz w:val="32"\/>/);
    expect(title).toMatch(/<w:szCs w:val="32"\/>/);
    expect(title).toMatch(/<w:bCs\/>/);
    expect(b).toContain('مسودة ترجمة');
    expect(count(b, /<w:numPr>/g)).toBe(2);
  });
});

describe('حالات حافة', () => {
  it('مقطع صورة/مرساة وسط الفقرة يبقى، والنص يُستبدل', async () => {
    const drawing = '<w:r><w:drawing><wp:inline xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"/></w:drawing></w:r>';
    const buf = await rawDocx(para(run('Before ') + drawing + run('after')));
    const out = await applyDocxTranslation(buf, new Map([[0, 'مترجم']]), { to: 'ar' });
    const x = await partXml(out);
    expect(x).toContain('<w:drawing>');
    expect(x).toContain('مترجم');
    expect(x).not.toContain('Before');
    expect(x).not.toContain('after');
  });

  it('رابط ورابط فى وسط الفقرة: النمط Hyperlink لا يُنسخ إلى النص المترجم', async () => {
    const link = `<w:hyperlink r:id="rId5"><w:r><w:rPr><w:rStyle w:val="Hyperlink"/></w:rPr><w:t>click</w:t></w:r></w:hyperlink>`;
    const buf = await rawDocx(para(run('See ') + link + run(' for details')));
    const out = await applyDocxTranslation(buf, new Map([[0, 'انظر الرابط للتفاصيل']]), { to: 'ar' });
    const x = await partXml(out);
    expect(x).not.toContain('Hyperlink');
    expect(x).toContain('انظر الرابط للتفاصيل');
    expect(x).not.toContain('<w:hyperlink');
  });

  it('خلية جدول متداخل وعلامات مرجعية: تُترجم وتبقى العلامات', async () => {
    const inner = `<w:tbl><w:tr><w:tc>${para(run('Nested cell'))}</w:tc></w:tr></w:tbl><w:p/>`;
    const buf = await rawDocx(`<w:tbl><w:tr><w:tc>${inner}</w:tc></w:tr></w:tbl>` + para('<w:bookmarkStart w:id="0" w:name="b"/>' + run('Marked') + '<w:bookmarkEnd w:id="0"/>'));
    const paras = await extractDocxParagraphs(buf);
    expect(paras.map((p) => p.text)).toEqual(['Nested cell', 'Marked']);
    const out = await applyDocxTranslation(buf, new Map(paras.map((p) => [p.ordinal, `T${p.ordinal}`])), { to: 'ar' });
    const x = await partXml(out);
    expect(count(x, /<w:bidiVisual\/>/g)).toBe(2); // الجدولان
    expect(x).toContain('w:name="b"');
    expect(x).toContain('T0');
    expect(x).toContain('T1');
  });

  it('أقسام الصفحة: sectPr يأخذ bidi حسب لغة الهدف بترتيب المخطط', async () => {
    const buf = await rawDocx(para(run('Hello')));
    const out = await applyDocxTranslation(buf, new Map([[0, 'مرحبا']]), { to: 'ar' });
    const x = await partXml(out);
    expect(x).toMatch(/<w:sectPr>.*<w:pgSz[^>]*\/><w:bidi\/>.*<\/w:sectPr>/);
  });

  it('نص يحوى رموز XML يُهرَّب صحيحاً', async () => {
    const buf = await rawDocx(para(run('Terms')));
    const out = await applyDocxTranslation(buf, new Map([[0, 'A & B <c> "d"']]), { to: 'en' });
    expect(await partXml(out)).toContain('A &amp; B &lt;c&gt;');
    expect((await extractDocxParagraphs(out)).map((p) => p.text)).toEqual(['A & B <c> "d"']);
  });
});
