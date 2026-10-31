import { readFileSync } from 'fs';
import { join } from 'path';
import { DocumentReaderService, hasBrokenArabicLigatures } from './document-reader.service';

/**
 * عقد PDF حقيقى (تسويق عبر وسائل التواصل) طبقة نصه تالفة بصمت: فقد «ل» فى «لا/لأ» (االجتماعى، األول، كال) وبُدّلت أرقامه
 * («2025» ⇒ «0202»، «159 لسنة 1981» ⇒ «921 لسنة 9199»). مرّ كل فحوص التلف السابقة لأن كلمات العقد الشائعة ظاهرة فيه.
 */
const BROKEN = readFileSync(join(__dirname, '__fixtures__', 'pdf-layer-broken-ligatures.txt'), 'utf-8');
const HEALTHY = readFileSync(join(__dirname, '..', 'contracts', '__fixtures__', 'golden', 'blackbelts-2019.txt'), 'utf-8');
const PDF = Buffer.concat([Buffer.from('%PDF-1.7\n'), Buffer.alloc(64)]);

describe('hasBrokenArabicLigatures', () => {
  it('يكشف طبقة النص التى فقدت اللام (قراءة حقيقية: 8.4 لكل ألف حرف)', () => {
    expect(hasBrokenArabicLigatures(BROKEN)).toBe(true);
  });

  it('لا يرفض نصاً عربياً سليماً (عقد كامل منسوخ بصرياً)', () => {
    expect(hasBrokenArabicLigatures(HEALTHY)).toBe(false);
  });

  it('لا يحكم على نص قصير، ولا على إصابة عابرة واحدة داخل نص طويل', () => {
    expect(hasBrokenArabicLigatures('االجتماعي األول كال')).toBe(false);
    expect(hasBrokenArabicLigatures(HEALTHY + ' االجتماعي')).toBe(false);
  });
});

describe('DocumentReaderService: PDF بطبقة نص تالفة الحروف يُقرأ بصرياً لا نصياً', () => {
  const messages = {
    unsupportedType: 'u',
    ocrUnavailable: 'o1',
    ocrFailed: 'o2',
    unreadable: 'r',
    tooLittleText: 't',
  };

  it('يتجاهل الطبقة النصية ويستعمل القراءة الآلية للصفحات', async () => {
    const extraction = { extract: jest.fn().mockResolvedValue({ status: 'ok', text: BROKEN }) };
    const ocr = { recognize: jest.fn().mockResolvedValue({ status: 'ok', text: HEALTHY, pages: 4, truncatedPages: false }) };
    const reader = new DocumentReaderService(extraction as never, ocr as never);
    const r = await reader.read(PDF, { messages });
    expect(ocr.recognize).toHaveBeenCalled();
    expect(r.usedOcr).toBe(true);
    expect(r.text).toBe(HEALTHY);
  });

  it('النص السليم يبقى على مساره النصى بلا OCR', async () => {
    const extraction = { extract: jest.fn().mockResolvedValue({ status: 'ok', text: HEALTHY }) };
    const ocr = { recognize: jest.fn() };
    const reader = new DocumentReaderService(extraction as never, ocr as never);
    const r = await reader.read(PDF, { messages });
    expect(ocr.recognize).not.toHaveBeenCalled();
    expect(r.usedOcr).toBe(false);
  });
});
