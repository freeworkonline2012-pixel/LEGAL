import {
  BadRequestException,
  Injectable,
  Logger,
  ServiceUnavailableException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { AuditService } from '../audit/audit.service';
import { ExtractionService } from '../contracts/extraction.service';
import { clipForModel, parseDocumentFacts, type DocumentFact } from './document-facts';
import { DocumentFactsService } from './document-facts.service';
import { imageDimensions, MAX_IMAGE_PIXELS, sniffFileType } from './file-sniff';
import { OcrService, OCR_MAX_PAGES } from './ocr.service';
import { redactPersonalData, type RedactionKind } from './pii-redactor';

/**
 * PDF عربى بترتيب بصرى معكوس وبأشكال العرض (U+FE70–FEFF/FB50–FDFF): أشهر عيوب الاستخراج من PDF، والنص
 * الناتج لا يصلح للتحليل ولا للمطابقة الحرفية. القراءة الآلية لصور الصفحات هى الحل الجذرى.
 */
export function looksLikeVisualOrderArabic(text: string): boolean {
  const arabic = (text.match(/[\u0600-\u06ff\ufb50-\ufdff\ufe70-\ufefc]/g) ?? []).length;
  if (arabic < 20) return false;
  const presentation = (text.match(/[\ufb50-\ufdff\ufe70-\ufefc]/g) ?? []).length;
  return presentation / arabic > 0.25;
}

/** يُسجَّل مع كل رفع (مسار تدقيق الموافقة). ارفع الرقم عند أى تعديل جوهرى لنص الموافقة فى الواجهة. */
export const DOCUMENT_CONSENT_VERSION = '2026-10-15-v1';

export interface DocumentActor {
  userId: string;
  role: string;
  ipAddress: string | null;
  userAgent: string | null;
}

export interface AnalyzeDocumentResult {
  doc_type: string;
  facts: DocumentFact[];
  redactions: Record<RedactionKind, number>;
  redactions_total: number;
  truncated: boolean;
  ocr: boolean;
  warnings: string[];
}

const MIME_BY_TYPE = {
  pdf: 'application/pdf',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
} as const;

/**
 * تحليل مستند العميل لاستخراج وقائعه (الغرض: استيضاح سؤاله). التصميم يقلّل البيانات إلى أدنى حد:
 *  - الملف الأصلى يُعالَج فى الذاكرة فقط ولا يُخزَّن، ولا يُخزَّن نصه المستخرج.
 *  - البيانات الشخصية الحتمية (قومى/هاتف/بريد/حساب...) تُحجب قبل أى إرسال خارجى.
 *  - نداء نموذج واحد لكل رفع، والمخرج وقائع موثَّقة بمقتطف حرفى يراجعها العميل قبل استعمالها.
 *  - الموافقة الصريحة شرط (DTO) وتُسجَّل بنسختها فى audit_logs مع أعداد الإخفاء دون أى محتوى.
 */
@Injectable()
export class DocumentsService {
  private readonly logger = new Logger(DocumentsService.name);

  constructor(
    private readonly extraction: ExtractionService,
    private readonly ocr: OcrService,
    private readonly factsModel: DocumentFactsService,
    private readonly audit: AuditService,
  ) {}

  async analyze(
    file: { buffer: Buffer; size: number },
    question: string | undefined,
    actor: DocumentActor,
  ): Promise<AnalyzeDocumentResult> {
    if (!file.buffer || file.buffer.length === 0) throw new BadRequestException('الملف فارغ');
    const type = sniffFileType(file.buffer);
    if (!type) {
      throw new BadRequestException('نوع ملف غير مدعوم — المسموح: PDF أو DOCX أو صورة PNG/JPEG');
    }
    if (!this.factsModel.isConfigured) {
      throw new ServiceUnavailableException('تحليل المستندات غير متاح مؤقتاً — حاول لاحقاً أو اكتب الوقائع يدوياً.');
    }

    const warnings: string[] = [];
    let text = '';
    let usedOcr = false;

    if (type === 'png' || type === 'jpeg') {
      const dim = imageDimensions(file.buffer, type);
      if (!dim || dim.width * dim.height > MAX_IMAGE_PIXELS) {
        throw new BadRequestException('أبعاد الصورة غير صالحة أو كبيرة جداً — صوّر المستند بدقة أقل.');
      }
      text = await this.runOcr(file.buffer, type, warnings);
      usedOcr = true;
    } else {
      const extracted = await this.extraction.extract(
        file.buffer,
        MIME_BY_TYPE[type],
        type === 'pdf' ? 'document.pdf' : 'document.docx',
      );
      const visualOrder = extracted.status === 'ok' && looksLikeVisualOrderArabic(extracted.text);
      if (extracted.status === 'ok' && !(type === 'pdf' && visualOrder)) {
        text = extracted.text;
      } else if (
        type === 'pdf' &&
        (visualOrder || extracted.status === 'empty' || extracted.status === 'corrupted_encoding')
      ) {
        // PDF ممسوح ضوئياً أو بترميز تالف: القراءة الآلية للصفحات هى الحل الجذرى
        text = await this.runOcr(file.buffer, 'pdf', warnings);
        usedOcr = true;
      } else {
        throw new UnprocessableEntityException(
          extracted.status === 'empty'
            ? 'لم نستخرج نصاً من الملف.'
            : 'تعذّرت قراءة الملف — جرّب ملفاً آخر أو اكتب الوقائع يدوياً.',
        );
      }
    }

    if (text.replace(/\s+/g, '').length < 20) {
      throw new UnprocessableEntityException('لم نتمكن من قراءة نص كافٍ من المستند — صوّره بوضوح أو اكتب الوقائع يدوياً.');
    }
    if (usedOcr) {
      warnings.push('قُرئ المستند آلياً من صورة — راجع الأرقام والتواريخ بعناية قبل اعتماد الوقائع.');
    }

    const redacted = redactPersonalData(text);
    const clipped = clipForModel(redacted.text);
    if (clipped.truncated) warnings.push('المستند طويل فاقتُصر على أوله وآخره عند الاستخراج.');

    const outcome = await this.factsModel.extract(clipped.text, question);
    if (outcome.status !== 'ok') {
      throw new ServiceUnavailableException('تعذّر تحليل المستند الآن — حاول مرة أخرى أو اكتب الوقائع يدوياً.');
    }
    const parsed = parseDocumentFacts(outcome.raw, clipped.text);
    if (parsed.facts.length === 0) {
      warnings.push('لم نجد وقائع موثقة بنص المستند — اكتب الوقائع يدوياً.');
    }

    await this.audit
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action: 'document.analyzed',
        resourceType: 'document',
        resourceId: null,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
        metadata: {
          type,
          bytes: file.size,
          chars: text.length,
          ocr: usedOcr,
          redactions: redacted.counts,
          facts: parsed.facts.length,
          dropped: parsed.dropped,
          truncated: clipped.truncated,
          consent_version: DOCUMENT_CONSENT_VERSION,
        },
      })
      .catch((err) => this.logger.warn(`document audit failed (non-fatal): ${(err as Error).message}`));

    return {
      doc_type: parsed.docType,
      facts: parsed.facts,
      redactions: redacted.counts,
      redactions_total: redacted.total,
      truncated: clipped.truncated,
      ocr: usedOcr,
      warnings,
    };
  }

  private async runOcr(buffer: Buffer, kind: 'pdf' | 'png' | 'jpeg', warnings: string[]): Promise<string> {
    const r = await this.ocr.recognize(buffer, kind);
    if (r.status === 'unavailable') {
      throw new UnprocessableEntityException(
        'هذا المستند صورة أو ممسوح ضوئياً والقراءة الآلية غير متاحة حالياً — ارفع نسخة نصية (PDF نصى أو Word) أو اكتب الوقائع يدوياً.',
      );
    }
    if (r.status === 'error') {
      throw new UnprocessableEntityException('تعذّرت قراءة المستند آلياً — جرّب صورة أوضح أو اكتب الوقائع يدوياً.');
    }
    if (r.truncatedPages) warnings.push(`قُرئت أول ${OCR_MAX_PAGES} صفحات فقط من المستند.`);
    return r.text;
  }
}
