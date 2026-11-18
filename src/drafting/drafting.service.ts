import { randomUUID } from 'node:crypto';
import { BadRequestException, Injectable, Logger, Optional, ServiceUnavailableException, UnprocessableEntityException } from '@nestjs/common';
import { AuditService } from '../audit/audit.service';
import { OfficePlaybookService } from '../contracts/office-playbook.service';
import type { OfficeProfile } from '../contracts/office-rules';
import { buildDraftDocument } from '../exports/builders/draft-document.builder';
import { renderDocx } from '../exports/renderers/docx.renderer';
import { PdfRenderer } from '../exports/renderers/pdf.renderer';
import { DeepseekGenerationService } from '../llm/deepseek-generation.service';
import { detectBlockingPersonalData } from '../privacy/personal-data-guard';
import { ShieldSession, runWithShield } from '../privacy/outbound-shield';
import { CATALOG } from './catalog';
import { assembleCustomDraft } from './custom/custom-draft';
import { EditedDraftError, sanitizeEditedDraft } from './custom/custom-export';
import { type GuardResult, MIN_CLAUSES, guardModelClauses } from './custom/custom-guard';
import { buildCustomPrompt, parseModelJson } from './custom/custom-prompt';
import { CUSTOM_SPEC } from './custom/custom-spec';
import { generateDraft, validateAnswers } from './engine';
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
    private readonly llm: DeepseekGenerationService,
    /** اختيارى: غيابه = قواعد المكتب الافتراضية لكل المستخدمين */
    @Optional() private readonly playbooks?: OfficePlaybookService,
  ) {}

  types(): readonly DraftTypeSpec[] {
    return [...CATALOG, CUSTOM_SPEC];
  }

  /** Playbook مكتب صاحب الطلب لملاحظات قواعد المكتب فى المسودة. لا يرمى استثناء. */
  async officeProfileFor(userId: string | null | undefined): Promise<OfficeProfile | undefined> {
    const r = await this.playbooks?.profileFor(userId);
    return r && r.customized ? r.profile : undefined;
  }

  generate(type: string, role: string, answers: Answers, officeProfile?: OfficeProfile): DraftResult {
    if (Object.keys(answers ?? {}).length > MAX_ANSWER_KEYS) throw new BadRequestException('عدد الإجابات أكبر من المسموح');
    try {
      return generateDraft(type, role, answers, officeProfile);
    } catch (err) {
      if (err instanceof DraftValidationError) {
        throw new BadRequestException({ message: err.message, field_errors: err.fieldErrors });
      }
      throw err;
    }
  }

  async export(type: string, role: string, answers: Answers, format: 'pdf' | 'docx', actor: DraftActor): Promise<DraftFile> {
    if (format !== 'pdf' && format !== 'docx') throw new BadRequestException('الصيغة غير مدعومة');
    return this.render(this.generate(type, role, answers, await this.officeProfileFor(actor.userId)), format, actor);
  }

  private async render(draft: DraftResult, format: 'pdf' | 'docx', actor: DraftActor): Promise<DraftFile> {
    const doc = buildDraftDocument({ draft, nonce: randomUUID(), generatedAt: new Date() });
    const buffer = format === 'pdf' ? await this.pdfRenderer.render(doc) : await renderDocx(doc);
    await this.audit(actor, 'draft.exported', { format, type: draft.typeId, bytes: buffer.length, qualityPassed: draft.quality.passed });
    return { buffer, contentType: CONTENT_TYPES[format], filename: `${doc.filenameBase}.${format}` };
  }

  private async audit(actor: DraftActor, action: string, metadata: Record<string, unknown>): Promise<void> {
    await this.auditService
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action,
        resourceType: 'contract_draft',
        resourceId: null,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
        metadata,
      })
      .catch((err) => this.logger.warn(`draft audit failed (non-fatal): ${(err as Error).message}`));
  }

  /**
   * «عقد آخر»: هيكل حتمى + بنود موضوع يصوغها نموذج لغوى. الخصوصية: لا اسم طرف ولا عنوان ولا ممثل يدخل الموجِّه أصلاً، والنص الحر
   * يُفحص بحارس البيانات الشخصية (رقم قومى/هاتف/حساب بنكى ⇒ إيقاف قبل أى نداء)، وما يخرج يمر على بوابة الحجب العكوسة التى تسجَّل
   * فيها أسماء الطرفين وعناوينهم. المخرجات لا تدخل المسودة إلا بعد حارس المخرجات (custom-guard) وبوابة الجودة. لا يُخزَّن شىء.
   */
  async generateCustom(role: string, answers: Answers, actor: DraftActor): Promise<DraftResult> {
    if (Object.keys(answers ?? {}).length > MAX_ANSWER_KEYS) throw new BadRequestException('عدد الإجابات أكبر من المسموح');
    let v: Record<string, string>;
    try {
      v = validateAnswers(CUSTOM_SPEC, role, answers);
    } catch (err) {
      if (err instanceof DraftValidationError) throw new BadRequestException({ message: err.message, field_errors: err.fieldErrors });
      throw err;
    }

    const piiErrors: Record<string, string> = {};
    for (const f of ['contract_type_name', 'party1_label', 'party2_label', 'purpose', 'key_terms', 'special_clauses']) {
      const found = v[f] ? detectBlockingPersonalData(v[f]) : null;
      if (found) piiErrors[f] = 'يحتوى بيانات شخصية (رقم قومى أو هاتف أو حساب بنكى). احذفها: لن يُرسَل هذا الوصف لنموذج خارجى وهى فيه.';
    }
    if (Object.keys(piiErrors).length > 0) throw new BadRequestException({ message: 'أُوقف الطلب قبل إرسال أى شىء لنموذج خارجى', field_errors: piiErrors });

    const session = new ShieldSession();
    for (const [k, kind] of [['party1_name', 'ORG'], ['party2_name', 'ORG'], ['party1_rep', 'PER'], ['party2_rep', 'PER'], ['party1_address', 'ADDR'], ['party2_address', 'ADDR']] as const) {
      if (v[k]) session.registerEntity(kind, v[k]);
    }

    const userText = [v.contract_type_name, v.party1_label, v.party2_label, v.purpose, v.key_terms ?? '', v.special_clauses ?? ''].join('\n');
    const base = {
      typeName: v.contract_type_name,
      label1: v.party1_label,
      label2: v.party2_label,
      purpose: v.purpose,
      keyTerms: v.key_terms ?? '',
      special: v.special_clauses ?? '',
      stance: (v.stance === 'protect_me' ? 'protect_me' : 'balanced') as 'balanced' | 'protect_me',
      mySide: (role === 'second' ? 'second' : 'first') as 'first' | 'second',
    };

    let best: { guarded: GuardResult; missing: string[] } | null = null;
    let feedback: string | undefined;
    let attempts = 0;
    for (; attempts < 2; ) {
      attempts++;
      const prompt = buildCustomPrompt({ ...base, retryFeedback: feedback });
      const res = await runWithShield(session, () => this.llm.completeContractDraft(prompt));
      if (res.status === 'not_configured') throw new ServiceUnavailableException('الصياغة المساعدة لعقد آخر غير مفعّلة حالياً على الخادم.');
      if (res.status === 'error') throw new ServiceUnavailableException('تعذّر الاتصال بخدمة الصياغة المساعدة الآن — حاول بعد قليل.');
      const parsed = parseModelJson(res.text);
      if (!parsed) {
        feedback = 'ردّك لم يكن JSON صالحاً بالشكل المحدد.';
        continue;
      }
      const guarded = guardModelClauses(parsed.clauses, userText);
      if (!best || guarded.clauses.length > best.guarded.clauses.length) best = { guarded, missing: parsed.missingInfo };
      if (guarded.clauses.length >= MIN_CLAUSES) break;
      feedback = `لم يبق من بنودك ما يكفى بعد الفحص الآلى (${guarded.problems.join('، ') || 'عدد البنود قليل'}). اكتب 8 بنود على الأقل بلا استشهاد قانونى ولا أرقام غير واردة فى رسالتى.`;
    }
    if (!best || best.guarded.clauses.length === 0) {
      throw new UnprocessableEntityException('تعذّرت صياغة بنود آمنة لهذا الوصف. أضف وصفاً أدق لموضوع العقد والتزامات الطرفين ثم أعد المحاولة.');
    }
    const draft = assembleCustomDraft(v, role, best.guarded, best.missing);
    await this.audit(actor, 'draft.assisted_generated', {
      clauses: best.guarded.clauses.length,
      blanks: draft.blankSlots,
      masked: best.guarded.maskedNumbers,
      dropped: best.guarded.droppedParagraphs,
      attempts,
      qualityPassed: draft.quality.passed,
    });
    return draft;
  }

  /** تنزيل «عقد آخر» من النص كما حرّره المستخدم (يُعاد ترقيمه وفحصه حتمياً؛ لا نموذج لغوى ولا تخزين). */
  async exportCustom(edited: unknown, format: 'pdf' | 'docx', actor: DraftActor): Promise<DraftFile> {
    if (format !== 'pdf' && format !== 'docx') throw new BadRequestException('الصيغة غير مدعومة');
    let draft: DraftResult;
    try {
      draft = sanitizeEditedDraft(edited);
    } catch (err) {
      if (err instanceof EditedDraftError) throw new BadRequestException(err.message);
      throw err;
    }
    return this.render(draft, format, actor);
  }
}
