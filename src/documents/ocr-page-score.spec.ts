import { DocumentReaderService } from './document-reader.service';

// يتحقق أن مقياس جودة الصفحة (للعقود) يصل إلى OcrService وأن غيابه يُبقى السلوك القديم (قراءة واحدة).
describe('DocumentReaderService — ocrPageScore', () => {
  function build() {
    const ocr = { recognize: jest.fn().mockResolvedValue({ status: 'ok', text: 'x'.repeat(300), pages: 1, truncatedPages: false }) };
    const extraction = { extract: jest.fn().mockResolvedValue({ status: 'empty', detail: '' }) };
    return { service: new DocumentReaderService(extraction as never, ocr as never), ocr };
  }
  const pdf = Buffer.from('%PDF-1.4\n');
  const messages = { unsupportedType: 'a', ocrUnavailable: 'b', ocrFailed: 'c', unreadable: 'd', tooLittleText: 'e' };

  it('يمرّر المقياس حين يُطلب', async () => {
    const { service, ocr } = build();
    const score = (t: string) => t.length;
    await service.read(pdf, { messages, ocrPageScore: score });
    expect(ocr.recognize).toHaveBeenCalledWith(expect.anything(), 'pdf', { pageScore: score });
  });

  it('بدون مقياس يستدعى بوسيطين فقط كما كان', async () => {
    const { service, ocr } = build();
    await service.read(pdf, { messages });
    expect(ocr.recognize.mock.calls[0]).toHaveLength(2);
  });
});
