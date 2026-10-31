import { BadRequestException, Injectable, UnprocessableEntityException } from '@nestjs/common';
import { ExtractionService } from '../contracts/extraction.service';
import { imageDimensions, MAX_IMAGE_PIXELS, sniffFileType, type SniffedType } from './file-sniff';
import { OcrRecognizeOptions, OcrService, OCR_MAX_PAGES } from './ocr.service';

/**
 * PDF عربى بترتيب بصرى معكوس وبأشكال العرض (U+FE70–FEFF/FB50–FDFF): أشهر عيوب الاستخراج من PDF، والنص
 * الناتج لا يصلح للتحليل ولا للمطابقة الحرفية. القراءة الآلية لصور الصفحات هى الحل الجذرى.
 */
export function looksLikeVisualOrderArabic(text: string): boolean {
  const arabic = (text.match(/[؀-ۿﭐ-﷿ﹰ-ﻼ]/g) ?? []).length;
  if (arabic < 20) return false;
  const presentation = (text.match(/[ﭐ-﷿ﹰ-ﻼ]/g) ?? []).length;
  return presentation / arabic > 0.25;
}

/**
 * طبقة نص PDF فقدت حرف اللام فى «لا/لأ» (ligature) فصار «الاجتماعى» «االجتماعى» و«الأول» «األول» و«كلا» «كال» — وغالباً
 * معها أرقام مقلوبة أو مبدّلة (وقع فى عقد حقيقى: «2025» قُرئت «0202» و«159 لسنة 1981» قُرئت «921 لسنة 9199»). النص يبدو عربياً
 * سليماً فيمرّ كل الفحوص الأخرى ثم تُبنى عليه مبالغ وتواريخ وأرقام قوانين خاطئة. فى النص السليم لا تقع هذه التركيبة تقريباً أبداً
 * (قيس 0.0 لكل ألف حرف على عقود Word وممسوحة سليمة مقابل 8.4 هنا)، فتكفى عتبة قليلة الحساسية. العلاج الجذرى: القراءة الآلية لصور الصفحات.
 */
export function hasBrokenArabicLigatures(text: string): boolean {
  const arabic = (text.match(/[ء-ي]/g) ?? []).length;
  if (arabic < 300) return false;
  const hits = (text.match(/اال(?=[ء-ي])/g) ?? []).length + (text.match(/ا[أإآ]ل/g) ?? []).length;
  return hits >= 4 && (hits * 1000) / arabic >= 2;
}

const MIME_BY_TYPE = {
  pdf: 'application/pdf',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
} as const;

export interface ReadDocumentOptions {
  /** نصوص أخطاء مخصَّصة للخدمة المستدعية (مثلاً «اكتب الوقائع يدوياً» لا تناسب الترجمة) */
  messages: {
    unsupportedType: string;
    ocrUnavailable: string;
    ocrFailed: string;
    unreadable: string;
    tooLittleText: string;
  };
  /** الترجمة لا تقبل نصاً مبتوراً صامتاً: إن تجاوز المستند الممسوح حد صفحات القراءة الآلية يُرفض بدل ترجمة جزء منه. */
  failOnOcrTruncation?: boolean;
  /** مقياس جودة صفحة للقراءة الآلية المزدوجة (يُفعَّل للعقود فقط: عدد عناوين البنود). بدونه تبقى قراءة واحدة كما كانت. */
  ocrPageScore?: (pageText: string) => number;
  /** استرجاع العناوين الناقصة (للعقود): يُمرَّر إلى OcrService كما هو. */
  ocrRecoverMissing?: OcrRecognizeOptions['recoverMissing'];
  /** حد أدنى لعدد الأحرف غير البيضاء المقبولة (افتراضى 20) */
  minChars?: number;
}

export interface ReadDocumentResult {
  text: string;
  type: SniffedType;
  usedOcr: boolean;
  warnings: string[];
}

/**
 * قارئ المستندات المشترك: بصمة الملف ← استخراج النص ← بديل القراءة الآلية (OCR) للممسوح/التالف/المعكوس.
 * يُستعمل فى تحليل مستند الاستيضاح وفى الترجمة القانونية؛ لا يُخزّن شيئاً ولا يُرسل شيئاً لأى جهة خارجية.
 */
@Injectable()
export class DocumentReaderService {
  constructor(
    private readonly extraction: ExtractionService,
    private readonly ocr: OcrService,
  ) {}

  async read(buffer: Buffer, options: ReadDocumentOptions): Promise<ReadDocumentResult> {
    if (!buffer || buffer.length === 0) throw new BadRequestException('الملف فارغ');
    const type = sniffFileType(buffer);
    if (!type) throw new BadRequestException(options.messages.unsupportedType);

    const warnings: string[] = [];
    let text = '';
    let usedOcr = false;

    if (type === 'png' || type === 'jpeg') {
      const dim = imageDimensions(buffer, type);
      if (!dim || dim.width * dim.height > MAX_IMAGE_PIXELS) {
        throw new BadRequestException('أبعاد الصورة غير صالحة أو كبيرة جداً — صوّر المستند بدقة أقل.');
      }
      text = await this.runOcr(buffer, type, warnings, options);
      usedOcr = true;
    } else {
      const extracted = await this.extraction.extract(
        buffer,
        MIME_BY_TYPE[type],
        type === 'pdf' ? 'document.pdf' : 'document.docx',
      );
      const visualOrder = extracted.status === 'ok' && (looksLikeVisualOrderArabic(extracted.text) || hasBrokenArabicLigatures(extracted.text));
      if (extracted.status === 'ok' && !(type === 'pdf' && visualOrder)) {
        text = extracted.text;
      } else if (
        type === 'pdf' &&
        (visualOrder || extracted.status === 'empty' || extracted.status === 'corrupted_encoding')
      ) {
        // PDF ممسوح ضوئياً أو بترميز تالف: القراءة الآلية للصفحات هى الحل الجذرى
        text = await this.runOcr(buffer, 'pdf', warnings, options);
        usedOcr = true;
      } else {
        throw new UnprocessableEntityException(
          extracted.status === 'empty' ? options.messages.tooLittleText : options.messages.unreadable,
        );
      }
    }

    if (text.replace(/\s+/g, '').length < (options.minChars ?? 20)) {
      throw new UnprocessableEntityException(options.messages.tooLittleText);
    }
    return { text, type, usedOcr, warnings };
  }

  private async runOcr(
    buffer: Buffer,
    kind: 'pdf' | 'png' | 'jpeg',
    warnings: string[],
    options: ReadDocumentOptions,
  ): Promise<string> {
    const r = await (options.ocrPageScore || options.ocrRecoverMissing
        ? this.ocr.recognize(buffer, kind, { pageScore: options.ocrPageScore, recoverMissing: options.ocrRecoverMissing })
        : this.ocr.recognize(buffer, kind));
    if (r.status === 'unavailable') throw new UnprocessableEntityException(options.messages.ocrUnavailable);
    if (r.status === 'error') throw new UnprocessableEntityException(options.messages.ocrFailed);
    if (r.truncatedPages) {
      if (options.failOnOcrTruncation) {
        throw new UnprocessableEntityException(
          `المستند الممسوح أطول من ${OCR_MAX_PAGES} صفحات ولا نترجم جزءاً منه بصمت — ارفع نسخة نصية (Word أو PDF نصى) أو قسّمه.`,
        );
      }
      warnings.push(`قُرئت أول ${OCR_MAX_PAGES} صفحات فقط من المستند.`);
    }
    return r.text;
  }
}
