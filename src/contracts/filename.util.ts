/**
 * اسم الملف المرفوع: Multer يفك ترميز اسم الملف فى multipart على أنه latin1،
 * فيصل الاسم العربى (UTF-8) مشوَّهاً مثل "Ø¹ÙØ¯..." — عطل ظهر فى واجهة
 * المدقق (2026-10-18). نعيد الترميز الصحيح هنا، ونُنقّى الاسم من فواصل
 * المسارات والمحارف التحكمية ونحدّ طوله قبل تخزينه أو عرضه.
 */
const MAX_FILENAME_LENGTH = 200;

export function normalizeUploadedFilename(raw: string): string {
  let name = raw ?? '';
  const looksLatin1Mojibake = /[\u0080-ÿ]/.test(name) && !/[^\u0000-ÿ]/.test(name);
  if (looksLatin1Mojibake) {
    const decoded = Buffer.from(name, 'latin1').toString('utf8');
    if (!decoded.includes('�')) {
      name = decoded;
    }
  }
  name = name
    .replace(/[\u0000-\u001f\u007f]/g, '')
    .replace(/[\\/]+/g, '_')
    .trim();
  if (name.length > MAX_FILENAME_LENGTH) {
    const dot = name.lastIndexOf('.');
    const ext = dot > 0 && name.length - dot <= 8 ? name.slice(dot) : '';
    name = name.slice(0, MAX_FILENAME_LENGTH - ext.length) + ext;
  }
  return name || 'contract';
}
