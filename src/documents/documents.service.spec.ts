import { BadRequestException, ServiceUnavailableException, UnprocessableEntityException } from '@nestjs/common';
import { validate } from 'class-validator';
import { plainToInstance } from 'class-transformer';
import { AnalyzeDocumentDto } from './dto/analyze-document.dto';
import { DocumentReaderService } from './document-reader.service';
import { DocumentsService, looksLikeVisualOrderArabic } from './documents.service';

const PDF = Buffer.from('%PDF-1.7\n' + 'x'.repeat(50));
const PNG = Buffer.concat([
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 13]),
  Buffer.from('IHDR', 'latin1'),
  Buffer.from([0, 0, 0x03, 0xe8, 0, 0, 0x03, 0xe8]),
  Buffer.alloc(10),
]);
const ACTOR = { userId: 'u1', role: 'user', ipAddress: '1.1.1.1', userAgent: 'jest' };

const TEXT =
  'عقد عمل غير محدد المدة. يتقاضى العامل أجراً شهرياً قدره 12000 جنيه. رقمه القومى 29001011234567 وهاتفه 01012345678.';
const FACT_RAW = {
  doc_type: 'عقد عمل',
  facts: [{ label: 'الأجر الشهرى', value: '12000 جنيه', quote: 'يتقاضى العامل أجراً شهرياً قدره 12000 جنيه' }],
};

function setup(over: {
  extract?: unknown;
  ocr?: unknown;
  model?: unknown;
  configured?: boolean;
} = {}) {
  const extraction = { extract: jest.fn().mockResolvedValue(over.extract ?? { status: 'ok', text: TEXT }) };
  const ocr = { recognize: jest.fn().mockResolvedValue(over.ocr ?? { status: 'ok', text: TEXT, pages: 1, truncatedPages: false }) };
  const factsModel = {
    isConfigured: over.configured ?? true,
    extract: jest.fn().mockResolvedValue(over.model ?? { status: 'ok', raw: FACT_RAW }),
  };
  const audit = { record: jest.fn().mockResolvedValue(undefined) };
  const reader = new DocumentReaderService(extraction as never, ocr as never);
  const service = new DocumentsService(reader, factsModel as never, audit as never);
  return { service, extraction, ocr, factsModel, audit };
}

describe('DocumentsService.analyze', () => {
  it('مسار PDF نصى: يحجب البيانات الشخصية قبل النموذج ويُرجع وقائع موثقة', async () => {
    const { service, factsModel, ocr } = setup();
    const r = await service.analyze({ buffer: PDF, size: PDF.length }, 'سؤال', ACTOR);
    const sent = factsModel.extract.mock.calls[0][0] as string;
    expect(sent).not.toContain('29001011234567');
    expect(sent).not.toContain('01012345678');
    expect(sent).toContain('[رقم قومى محجوب]');
    expect(r.facts).toHaveLength(1);
    expect(r.redactions.national_id).toBe(1);
    expect(r.redactions.phone).toBe(1);
    expect(r.ocr).toBe(false);
    expect(ocr.recognize).not.toHaveBeenCalled();
  });

  it('PDF ممسوح (empty) يتحول للقراءة الآلية وينبّه العميل لمراجعة الأرقام', async () => {
    const { service, ocr } = setup({ extract: { status: 'empty', detail: 'x' } });
    const r = await service.analyze({ buffer: PDF, size: PDF.length }, undefined, ACTOR);
    expect(ocr.recognize).toHaveBeenCalledWith(PDF, 'pdf');
    expect(r.ocr).toBe(true);
    expect(r.warnings.join(' ')).toContain('راجع الأرقام');
  });

  it('الصورة تذهب للقراءة الآلية مباشرة', async () => {
    const { service, extraction, ocr } = setup();
    const r = await service.analyze({ buffer: PNG, size: PNG.length }, undefined, ACTOR);
    expect(extraction.extract).not.toHaveBeenCalled();
    expect(ocr.recognize).toHaveBeenCalledWith(PNG, 'png');
    expect(r.ocr).toBe(true);
  });

  it('القراءة الآلية غير متاحة → 422 برسالة واضحة', async () => {
    const { service } = setup({ extract: { status: 'empty', detail: 'x' }, ocr: { status: 'unavailable' } });
    await expect(service.analyze({ buffer: PDF, size: 1 }, undefined, ACTOR)).rejects.toThrow(UnprocessableEntityException);
  });

  it('نوع غير مدعوم (بصمة) → 400 ولو سُمّى .pdf', async () => {
    const { service } = setup();
    const exe = Buffer.from('MZ\x90\x00\x03\x00\x00\x00 executable bytes');
    await expect(service.analyze({ buffer: exe, size: exe.length }, undefined, ACTOR)).rejects.toThrow(BadRequestException);
  });

  it('صورة بأبعاد ضخمة → 400 قبل القراءة الآلية', async () => {
    const { service, ocr } = setup();
    const huge = Buffer.from(PNG);
    huge.writeUInt32BE(10_000, 16);
    huge.writeUInt32BE(10_000, 20);
    await expect(service.analyze({ buffer: huge, size: huge.length }, undefined, ACTOR)).rejects.toThrow(BadRequestException);
    expect(ocr.recognize).not.toHaveBeenCalled();
  });

  it('النموذج غير مهيأ → 503 دون أى معالجة', async () => {
    const { service, extraction } = setup({ configured: false });
    await expect(service.analyze({ buffer: PDF, size: 1 }, undefined, ACTOR)).rejects.toThrow(ServiceUnavailableException);
    expect(extraction.extract).not.toHaveBeenCalled();
  });

  it('فشل النموذج → 503 ولا وقائع', async () => {
    const { service } = setup({ model: { status: 'error', detail: 'http_500' } });
    await expect(service.analyze({ buffer: PDF, size: 1 }, undefined, ACTOR)).rejects.toThrow(ServiceUnavailableException);
  });

  it('وقائع بلا مقتطف حرفى تُسقَط ويُنبَّه العميل', async () => {
    const { service } = setup({
      model: { status: 'ok', raw: { doc_type: 'عقد', facts: [{ label: 'الأجر', value: '99999 جنيه', quote: 'أجر خيالى 99999 جنيه' }] } },
    });
    const r = await service.analyze({ buffer: PDF, size: 1 }, undefined, ACTOR);
    expect(r.facts).toHaveLength(0);
    expect(r.warnings.join(' ')).toContain('اكتب الوقائع يدوياً');
  });

  it('التدقيق يسجّل الموافقة والأعداد دون أى محتوى للمستند', async () => {
    const { service, audit } = setup();
    await service.analyze({ buffer: PDF, size: 123 }, 'سؤال', ACTOR);
    const entry = audit.record.mock.calls[0][0];
    expect(entry.action).toBe('document.analyzed');
    expect(entry.metadata.consent_version).toMatch(/^\d{4}-/);
    const dump = JSON.stringify(entry);
    expect(dump).not.toContain('12000');
    expect(dump).not.toContain('29001011234567');
    expect(dump).not.toContain('عقد عمل');
  });
});

describe('PDF بترتيب بصرى معكوس', () => {
  const REVERSED = 'ةﺪﻤﻟا دﺪﺤﻣ ﺮﻴﻏ ﻞﻤﻋ ﺪﻘﻋ ﻰﻣﻮﻘﻟا ﻢﻗﺮﻟا ﻞﻣﺎﻌﻟا ﻰﻧﺎﺜﻟا فﺮﻄﻟوا ﻞﻤﻌﻟا ﺐﺣﺎﺻ';

  it('يكتشف أشكال العرض ولا يشتبه فى النص العادى', () => {
    expect(looksLikeVisualOrderArabic(REVERSED)).toBe(true);
    expect(looksLikeVisualOrderArabic(TEXT)).toBe(false);
    expect(looksLikeVisualOrderArabic('abc')).toBe(false);
  });

  it('PDF نصى معكوس يُحوَّل للقراءة الآلية بدل تحليل نص تالف', async () => {
    const { service, ocr } = setup({ extract: { status: 'ok', text: REVERSED } });
    const r = await service.analyze({ buffer: PDF, size: 1 }, undefined, ACTOR);
    expect(ocr.recognize).toHaveBeenCalledWith(PDF, 'pdf');
    expect(r.ocr).toBe(true);
  });

  it('DOCX لا يُحوَّل للقراءة الآلية حتى لو بدا نصه معكوساً (لا صفحات لقراءتها)', async () => {
    const docx = Buffer.from([0x50, 0x4b, 0x03, 0x04, 0, 0, 0, 0, 0]);
    const { service, ocr } = setup({ extract: { status: 'ok', text: REVERSED } });
    await service.analyze({ buffer: docx, size: 1 }, undefined, ACTOR);
    expect(ocr.recognize).not.toHaveBeenCalled();
  });
});

describe('AnalyzeDocumentDto', () => {
  it('الموافقة شرط: بدونها أو بقيمة غير true يفشل التحقق', async () => {
    expect((await validate(plainToInstance(AnalyzeDocumentDto, {}))).length).toBeGreaterThan(0);
    expect((await validate(plainToInstance(AnalyzeDocumentDto, { consent: 'false' }))).length).toBeGreaterThan(0);
    expect((await validate(plainToInstance(AnalyzeDocumentDto, { consent: 'true' }))).length).toBe(0);
  });
});
