import { randomUUID } from 'node:crypto';
import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { AuditService } from '../audit/audit.service';
import { buildDraftDocument } from '../exports/builders/draft-document.builder';
import { renderDocx } from '../exports/renderers/docx.renderer';
import { PdfRenderer } from '../exports/renderers/pdf.renderer';
import { CATALOG } from './catalog';
import { generateDraft } from './engine';
import { type Answers, type DraftResult, type DraftTypeSpec, DraftValidationError } from './drafting.types';
import { MAX_ANSWER_KEYS } from './dto/generate-draft.dto';

export interface DraftActor {
  userId: string;
  role: string;
  ipAddress: string | null;
  userAgent: string | null;
}

export interface DraftFile {
  buffer: Buffer;
  contentType: string;
  filename: string;
}

const CONTENT_TYPES = {
  pdf: 'application/pdf',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
} as const;

/**
 * صياغة العقود. لا تخزّن شيئاً من محتوى العقد: التوليد حتمى من الإجابات عند كل طلب، والتنزيل يعيد التوليد ثم يرسم الملف.
 * لا نداء خارجياً ولا نموذج لغوى فى أى خطوة، فلا تغادر بيانات الأطراف المنصة. يُسجَّل فى سجل التدقيق نوع العقد وصيغته فقط.
 */
@Injectable()
export class DraftingService {
  private readonly logger = new Logger(DraftingService.name);

  constructor(
    private readonly auditService: AuditService,
    private readonly pdfRenderer: PdfRenderer,
  ) {}

  types(): readonly DraftTypeSpec[] {
    return CATALOG;
  }

  generate(type: string, role: string, answers: Answers): DraftResult {
    if (Object.keys(answers ?? {}).length > MAX_ANSWER_KEYS) throw new BadRequestException('عدد الإجابات أكبر من المسموح');
    try {
      return generateDraft(type, role, answers);
    } catch (err) {
      if (err instanceof DraftValidationError) {
        throw new BadRequestException({ message: err.message, field_errors: err.fieldErrors });
      }
      throw err;
    }
  }

  async export(type: string, role: string, answers: Answers, format: 'pdf' | 'docx', actor: DraftActor): Promise<DraftFile> {
    if (format !== 'pdf' && format !== 'docx') throw new BadRequestException('الصيغة غير مدعومة');
    const draft = this.generate(type, role, answers);
    const doc = buildDraftDocument({ draft, nonce: randomUUID(), generatedAt: new Date() });
    const buffer = format === 'pdf' ? await this.pdfRenderer.render(doc) : await renderDocx(doc);
    await this.auditService
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action: 'draft.exported',
        resourceType: 'contract_draft',
        resourceId: null,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
        metadata: { format, type: draft.typeId, bytes: buffer.length, qualityPassed: draft.quality.passed },
      })
      .catch((err) => this.logger.warn(`draft export audit failed (non-fatal): ${(err as Error).message}`));
    return { buffer, contentType: CONTENT_TYPES[format], filename: `${doc.filenameBase}.${format}` };
  }
}
