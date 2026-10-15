import {
  BadRequestException,
  Injectable,
  Logger,
  ServiceUnavailableException,
} from '@nestjs/common';
import { AuditService } from '../audit/audit.service';
import { clipForModel, parseDocumentFacts, type DocumentFact } from './document-facts';
import { DocumentFactsService } from './document-facts.service';
import { DocumentReaderService, looksLikeVisualOrderArabic } from './document-reader.service';
import { redactPersonalData, type RedactionKind } from './pii-redactor';

// أُعيد تصديره للتوافق مع الاختبارات والمستوردين القدامى (المنطق انتقل إلى document-reader.service.ts)
export { looksLikeVisualOrderArabic };

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

const FACTS_READ_MESSAGES = {
  unsupportedType: 'نوع ملف غير مدعوم — المسموح: PDF أو DOCX أو صورة PNG/JPEG',
  ocrUnavailable:
    'هذا المستند صورة أو ممسوح ضوئياً والقراءة الآلية غير متاحة حالياً — ارفع نسخة نصية (PDF نصى أو Word) أو اكتب الوقائع يدوياً.',
  ocrFailed: 'تعذّرت قراءة المستند آلياً — جرّب صورة أوضح أو اكتب الوقائع يدوياً.',
  unreadable: 'تعذّرت قراءة الملف — جرّب ملفاً آخر أو اكتب الوقائع يدوياً.',
  tooLittleText: 'لم نتمكن من قراءة نص كافٍ من المستند — صوّره بوضوح أو اكتب الوقائع يدوياً.',
};

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
    private readonly reader: DocumentReaderService,
    private readonly factsModel: DocumentFactsService,
    private readonly audit: AuditService,
  ) {}

  async analyze(
    file: { buffer: Buffer; size: number },
    question: string | undefined,
    actor: DocumentActor,
  ): Promise<AnalyzeDocumentResult> {
    if (!file.buffer || file.buffer.length === 0) throw new BadRequestException('الملف فارغ');
    if (!this.factsModel.isConfigured) {
      throw new ServiceUnavailableException('تحليل المستندات غير متاح مؤقتاً — حاول لاحقاً أو اكتب الوقائع يدوياً.');
    }

    const read = await this.reader.read(file.buffer, { messages: FACTS_READ_MESSAGES });
    const { text, type, usedOcr, warnings } = read;
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
}
