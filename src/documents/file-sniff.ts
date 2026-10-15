/**
 * تعرّف حتمى على نوع الملف من بصمته (magic bytes) لا من الامتداد ولا من mimetype الذى يرسله العميل،
 * مع حد لأبعاد الصور (قنبلة بكسلات) قبل تمريرها لأدوات القراءة الآلية.
 */

export type SniffedType = 'pdf' | 'docx' | 'png' | 'jpeg';

export const MAX_IMAGE_PIXELS = 24_000_000;

export function sniffFileType(buf: Buffer): SniffedType | null {
  if (buf.length < 8) return null;
  if (buf.subarray(0, 5).toString('latin1') === '%PDF-') return 'pdf';
  if (buf[0] === 0x50 && buf[1] === 0x4b && (buf[2] === 0x03 || buf[2] === 0x05)) return 'docx';
  if (buf.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) return 'png';
  if (buf[0] === 0xff && buf[1] === 0xd8 && buf[2] === 0xff) return 'jpeg';
  return null;
}

/** أبعاد صورة PNG/JPEG من الترويسة دون فك الترميز، أو null إن تعذّر. */
export function imageDimensions(buf: Buffer, type: 'png' | 'jpeg'): { width: number; height: number } | null {
  if (type === 'png') {
    if (buf.length < 24) return null;
    return { width: buf.readUInt32BE(16), height: buf.readUInt32BE(20) };
  }
  let i = 2;
  while (i + 9 < buf.length) {
    if (buf[i] !== 0xff) {
      i++;
      continue;
    }
    const marker = buf[i + 1];
    if (marker === 0xd8 || marker === 0x01 || (marker >= 0xd0 && marker <= 0xd7)) {
      i += 2;
      continue;
    }
    const len = buf.readUInt16BE(i + 2);
    if (len < 2) return null;
    const isSof = marker >= 0xc0 && marker <= 0xcf && marker !== 0xc4 && marker !== 0xc8 && marker !== 0xcc;
    if (isSof) {
      return { height: buf.readUInt16BE(i + 5), width: buf.readUInt16BE(i + 7) };
    }
    i += 2 + len;
  }
  return null;
}
