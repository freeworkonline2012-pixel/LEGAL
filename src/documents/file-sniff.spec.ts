import { imageDimensions, sniffFileType } from './file-sniff';

const PNG = Buffer.concat([
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 13]),
  Buffer.from('IHDR', 'latin1'),
  Buffer.from([0, 0, 0x03, 0xe8, 0, 0, 0x07, 0xd0]), // 1000 x 2000
  Buffer.alloc(10),
]);

describe('sniffFileType', () => {
  it('يتعرف على الأنواع المسموحة من البصمة', () => {
    expect(sniffFileType(Buffer.from('%PDF-1.7 ....'))).toBe('pdf');
    expect(sniffFileType(Buffer.from([0x50, 0x4b, 0x03, 0x04, 0, 0, 0, 0]))).toBe('docx');
    expect(sniffFileType(PNG)).toBe('png');
    expect(sniffFileType(Buffer.from([0xff, 0xd8, 0xff, 0xe0, 0, 0, 0, 0, 0]))).toBe('jpeg');
  });
  it('يرفض أى شىء آخر ولو سُمّى .pdf (تنفيذى، نص، HTML، ملف قصير)', () => {
    expect(sniffFileType(Buffer.from('MZ\x90\x00\x03\x00\x00\x00 executable'))).toBeNull();
    expect(sniffFileType(Buffer.from('<html><script>alert(1)</script></html>'))).toBeNull();
    expect(sniffFileType(Buffer.from('%PDF'))).toBeNull();
  });
});

describe('imageDimensions', () => {
  it('يقرأ أبعاد PNG من الترويسة', () => {
    expect(imageDimensions(PNG, 'png')).toEqual({ width: 1000, height: 2000 });
  });
  it('يقرأ أبعاد JPEG من علامة SOF ويتجاوز APPn', () => {
    const app0 = Buffer.concat([Buffer.from([0xff, 0xe0, 0x00, 0x10]), Buffer.alloc(14)]);
    const sof = Buffer.from([0xff, 0xc0, 0x00, 0x11, 8, 0x01, 0x2c, 0x00, 0xc8, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    const jpeg = Buffer.concat([Buffer.from([0xff, 0xd8]), app0, sof]);
    expect(imageDimensions(jpeg, 'jpeg')).toEqual({ width: 200, height: 300 });
  });
  it('يعيد null لترويسة مبتورة', () => {
    expect(imageDimensions(Buffer.from([0xff, 0xd8, 0xff]), 'jpeg')).toBeNull();
    expect(imageDimensions(Buffer.alloc(10), 'png')).toBeNull();
  });
});
