import {
  BadGatewayException,
  BadRequestException,
  ConflictException,
  HttpException,
  HttpStatus,
  Injectable,
  Logger,
  NotFoundException,
  OnApplicationBootstrap,
  Optional,
  ServiceUnavailableException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, MoreThan, Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { DocumentReaderService } from '../documents/document-reader.service';
import { LegalTranslation } from '../database/entities/legal-translation.entity';
import { PdfRenderer } from '../exports/renderers/pdf.renderer';
import { DEFAULT_BRAND, compactCairoDate, shortReference } from '../exports/document-model';
import { GlossaryService } from './glossary.service';
import { matchGlossary } from './glossary';
import { detectLanguage, type ContractLang } from './language-detect';
import { MAX_TOTAL_CHARS, MAX_UNITS, planBatches, splitIntoUnits, splitLongUnit } from './paragraph-splitter';
import { DocxLayoutError, applyDocxTranslation, extractDocxParagraphs, type DocxParagraphRef } from './docx-layout';
import { TranslationSourceService } from './translation-source.service';
import { checkUnit, type UnitFlag } from './translation-checks';
import {
  buildNotesAndFlags,
  toParagraphs,
  WATERMARK,
  type StoredUnitView,
  type TranslationDocument,
  type TranslationLayout,
} from './translation-document';
import { renderTranslationDocx } from './translation-docx.renderer';
import { renderTranslationHtml } from './translation-html.renderer';
import { TranslationModelService } from './translation-model.service';
import { TranslationBackgroundRunner, runnerLimitsFromEnv, type EnqueueOutcome, type RunnerStopReason } from './translation-background';
import {
  buildBatchUserMessage,
  buildSystemPrompt,
  mergeDefinedTerms,
  parseBatchOutput,
  parseProfile,
  type ContractProfile,
} from './translation-prompt';

/** يُسجَّل مع كل إنشاء. ارفع الرقم عند أى تعديل جوهرى لنص الموافقة فى الواجهة. */
export const TRANSLATION_CONSENT_VERSION = '2026-10-16-v1';

export const MAX_CREATED_PER_DAY = 10;
const STEP_LOCK_SECONDS = 150;
const COMPLETED_RETENTION_HOURS = 24;
const PROFILE_HEAD_CHARS = 6000;
const MAX_EDIT_CHARS = 6000;

export interface TranslationActor {
  userId: string;
  role: string;
  ipAddress: string | null;
  userAgent: string | null;
}

/** layout=original يضيف 'original': كتابة الترجمة داخل ملف Word الأصلى (يتطلب خيار الاحتفاظ بالتنسيق عند الإنشاء) */
export type DownloadLayout = TranslationLayout | 'original';

interface StoredUnit {
  src: string;
  cont: boolean;
  /** رقم الفقرة فى ملف Word الأصلى (docx-layout ordinal) — فقط عند الاحتفاظ بالتنسيق؛ قطع الفقرة الطويلة تتشارك الرقم */
  p?: number;
  tgt: string | null;
  flags: UnitFlag[];
  edited?: boolean;
}

interface StoredNote {
  i: number;
  term: string;
  note: string;
}

interface Payload extends Record<string, unknown> {
  units: StoredUnit[];
  batches: Array<{ start: number; end: number }>;
  notes: StoredNote[];
  knownTerms: Array<{ src: string; tgt: string }>;
  profile: ContractProfile;
  warnings: string[];
  ocr: boolean;
  detection: { lang: ContractLang; dominant_share: number };
  /** true = وحدات الترجمة مقابلة لفقرات ملف Word الأصلى المحفوظ (لتنزيل بتنسيق الأصل) */
  docx?: boolean;
}

export interface TranslationView {
  id: string;
  status: 'ready' | 'translating' | 'completed';
  source_lang: ContractLang;
  target_lang: ContractLang;
  title: string;
  contract_type: string | null;
  detection: { lang: ContractLang; dominant_share: number };
  progress: { done_units: number; total_units: number; done_batches: number; total_batches: number };
  warnings: string[];
  flagged: Array<{ n: number; flags: UnitFlag[]; src: string; tgt: string }>;
  notes: Array<{ n: number; term: string; note: string }>;
  expires_at: string;
  created_at: string;
  /** running = الخادم يكمل الترجمة بنفسه الآن؛ idle = لا مشغِّل (العميل يقود الخطوات أو المهمة مكتملة/متوقفة) */
  background: 'running' | 'idle';
  /** الترجمة محفوظة مع ملف Word الأصلى: التنزيل بتنسيق الأصل متاح */
  original_layout: boolean;
}

/** عنصر قائمة «ترجماتى»: بيانات وصفية فقط بلا فقرات العقد (لا نفك تشفير الحمولة لقائمة). */
export interface TranslationListItem {
  id: string;
  status: 'ready' | 'translating' | 'completed';
  source_lang: ContractLang;
  target_lang: ContractLang;
  title: string;
  progress: { done_units: number; total_units: number; done_batches: number; total_batches: number };
  background: 'running' | 'idle';
  expires_at: string;
  created_at: string;
}

export interface UnitsPage {
  total: number;
  offset: number;
  items: Array<{ n: number; src: string; tgt: string; flags: UnitFlag[]; cont: boolean; edited: boolean }>;
}

export interface ExportedTranslation {
  buffer: Buffer;
  contentType: string;
  filename: string;
}

const CONTENT_TYPES = {
  pdf: 'application/pdf',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
} as const;

const READ_MESSAGES = {
  unsupportedType: 'نوع ملف غير مدعوم — المسموح: PDF أو DOCX أو صورة PNG/JPEG',
  ocrUnavailable:
    'هذا العقد صورة أو ممسوح ضوئياً والقراءة الآلية غير متاحة حالياً — ارفع نسخة نصية (Word أو PDF نصى).',
  ocrFailed: 'تعذّرت قراءة العقد آلياً من الصورة — جرّب صورة أوضح أو ارفع نسخة نصية.',
  unreadable: 'تعذّرت قراءة الملف — جرّب ملفاً آخر (Word أو PDF نصى).',
  tooLittleText: 'لم نتمكن من قراءة نص كافٍ من الملف — ارفع نسخة نصية أو صورة أوضح.',
};

function excerpt(t: string | null, n = 400): string {
  return (t ?? '').slice(0, n);
}

/**
 * الترجمة القانونية للعقود (عربى <-> إنجليزى).
 *
 * التدفق: الإنشاء (قراءة الملف ← كشف اللغة بالحروف ← تجزئة إلى فقرات ← تحليل نوع العقد) ثم خطوات متتابعة
 * يقودها العميل (كل خطوة = دفعة فقرات ≤ 5000 حرف) فلا طلب طويل يُقطع ولا عامل خلفى يضيع عند إعادة التشغيل،
 * وتُستأنف المهمة بعد تحديث الصفحة. كل دفعة: مصطلحات القاموس الواردة فيها + المصطلحات المعرَّفة سابقاً (للاتساق) ←
 * النموذج ← فحوص حتمية (الأرقام/الطول/بقاء لغة الأصل) ← إعادة ترجمة مرة واحدة للفاشل ← وسم للمراجعة البشرية.
 *
 * الخصوصية: موافقة صريحة مسجَّلة؛ العقد وترجمته مُشفَّران ومؤقتان (48 ساعة) ويحذفهما المستخدم فوراً؛ التنزيل من
 * الخادم فقط من سجل مملوك للمستخدم (لا يُقبل نص من العميل)؛ التدقيق يسجل أعداداً بلا أى محتوى.
 */
@Injectable()
export class TranslationService implements OnApplicationBootstrap {
  private readonly logger = new Logger(TranslationService.name);
  /** مُشغِّل الخلفية: الحالة الحقيقية فى قاعدة البيانات، وهو مجرد عميل آخر يستدعى step (انظر translation-background.ts) */
  private readonly runner: TranslationBackgroundRunner;
  private readonly runActors = new Map<string, TranslationActor>();

  constructor(
    @InjectRepository(LegalTranslation) private readonly repository: Repository<LegalTranslation>,
    private readonly reader: DocumentReaderService,
    private readonly model: TranslationModelService,
    private readonly glossary: GlossaryService,
    private readonly audit: AuditService,
    private readonly pdfRenderer: PdfRenderer,
    /** اختيارى: غيابه = خيار الاحتفاظ بتنسيق Word غير متاح */
    @Optional() private readonly sources?: TranslationSourceService,
  ) {
    const limits = runnerLimitsFromEnv();
    this.runner = new TranslationBackgroundRunner({
      step: (id) => this.stepInBackground(id),
      onStop: (id, reason, err) => this.onRunnerStop(id, reason, err),
      ...limits,
    });
  }

  private get brand(): string {
    return process.env.EXPORT_BRAND_NAME?.trim() || DEFAULT_BRAND;
  }

  private brandFor(to: ContractLang): string {
    if (to === 'ar') return `منصة ${this.brand}`;
    return process.env.EXPORT_BRAND_NAME_EN?.trim() || 'Shield Legal Platform';
  }

  // ───────────────────────── الإنشاء ─────────────────────────

  async create(
    file: { buffer: Buffer; originalname: string; size: number },
    targetLang: ContractLang,
    actor: TranslationActor,
    options: { background?: boolean; preserveFormat?: boolean } = {},
  ): Promise<TranslationView> {
    if (!this.model.isConfigured) {
      throw new ServiceUnavailableException('خدمة الترجمة غير متاحة مؤقتاً — حاول لاحقاً.');
    }
    const since = new Date(Date.now() - 24 * 60 * 60 * 1000);
    const recent = await this.repository.count({ where: { userId: actor.userId, createdAt: MoreThan(since) } });
    if (recent >= MAX_CREATED_PER_DAY) {
      throw new HttpException(
        `بلغت الحد اليومى لطلبات الترجمة (${MAX_CREATED_PER_DAY}) — حاول غداً أو احذف ترجمات سابقة لا تحتاجها.`,
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const read = await this.reader.read(file.buffer, {
      messages: READ_MESSAGES,
      failOnOcrTruncation: true,
      minChars: 80,
    });

    if (options.preserveFormat === true && read.type !== 'docx') {
      throw new BadRequestException('الاحتفاظ بتنسيق الملف الأصلى متاح لملفات Word (docx) فقط.');
    }
    if (options.preserveFormat === true && !this.sources) {
      throw new ServiceUnavailableException('الاحتفاظ بتنسيق الملف الأصلى غير متاح مؤقتاً — أعد المحاولة بدونه.');
    }

    const detection = detectLanguage(read.text);
    if (!detection.lang) {
      throw new UnprocessableEntityException('لم نتمكن من تحديد لغة العقد — النص المقروء قصير جداً أو غير لغوى.');
    }
    if (detection.bilingual) {
      throw new UnprocessableEntityException(
        'العقد يبدو ثنائى اللغة (عربى وإنجليزى معاً)؛ ترجمته ستكرّر نصه. ارفع النسخة بلغة واحدة.',
      );
    }
    const sourceLang = detection.lang;
    if (sourceLang === targetLang) {
      throw new UnprocessableEntityException(
        `العقد مكتوب أصلاً ${sourceLang === 'ar' ? 'بالعربية' : 'بالإنجليزية'} (${Math.round(detection.dominantShare * 100)}% من حروفه) — اختر لغة الترجمة المقابلة.`,
      );
    }

    // الاحتفاظ بالتنسيق: وحدات الترجمة هى فقرات ملف Word نفسها (لا إعادة تجزئة للنص)؛ تعذّر قراءة بنية الملف ⇒ المسار القياسى بتنبيه
    let docxRefs: DocxParagraphRef[] | null = null;
    let formatFallbackWarning: string | null = null;
    if (options.preserveFormat === true) {
      try {
        docxRefs = await extractDocxParagraphs(file.buffer);
        if (docxRefs.length === 0) docxRefs = null;
      } catch (err) {
        docxRefs = null;
        if (!(err instanceof DocxLayoutError)) throw err;
      }
      if (!docxRefs) formatFallbackWarning = 'تعذّر الاحتفاظ بتنسيق ملف Word الأصلى (بنية الملف غير قابلة للقراءة)؛ ستُنتَج الترجمة بالتنسيق القياسى.';
    }
    const split = docxRefs
      ? this.unitsFromDocx(docxRefs)
      : splitIntoUnits(read.text);
    if (split.totalChars > MAX_TOTAL_CHARS || split.units.length > MAX_UNITS) {
      throw new UnprocessableEntityException(
        'العقد أطول من الحد المسموح للترجمة الآلية فى طلب واحد — قسّمه إلى أجزاء (مثلاً: العقد وملاحقه كل على حدة).',
      );
    }
    if (split.units.length === 0) {
      throw new UnprocessableEntityException('لم نجد نصاً قابلاً للترجمة فى الملف.');
    }

    const warnings = [...read.warnings];
    if (formatFallbackWarning) warnings.push(formatFallbackWarning);
    if (docxRefs) warnings.push('الترجمة تُكتب داخل ملف Word الأصلى بتنسيقه: تنسيق الكلمات داخل الفقرة (عريض/رابط وسط الجملة) يتوحّد على تنسيق أول مقطع، والفقرات التى فيها حقول (فهرس/أرقام صفحات) لا تُترجَم. افتح الملف فى Word وراجعه.');
    if (read.usedOcr) warnings.push('قُرئ العقد آلياً من صورة — راجع الأرقام والتواريخ والأسماء فى الترجمة بعناية.');
    if (detection.mixedMinority) {
      warnings.push('يحوى العقد نصوصاً بلغة أخرى (أسماء أو مصطلحات)؛ تُنقل الأسماء كما هى حيثما أمكن.');
    }

    const profileOutcome = await this.model.profile(read.text.slice(0, PROFILE_HEAD_CHARS));
    const profile = profileOutcome.status === 'ok' ? parseProfile(profileOutcome.raw) : parseProfile(null);

    const batches = planBatches(split.units.map((u) => u.text.length));
    const payload: Payload = {
      units: split.units.map((u) => ({ src: u.text, cont: u.cont, tgt: null, flags: [], ...(u.p !== undefined ? { p: u.p } : {}) })),
      batches,
      notes: [],
      knownTerms: [],
      profile,
      warnings,
      ocr: read.usedOcr,
      detection: { lang: sourceLang, dominant_share: Math.round(detection.dominantShare * 1000) / 1000 },
      ...(docxRefs ? { docx: true } : {}),
    };

    const title = this.titleFromFilename(file.originalname);
    const row = await this.repository.save(
      this.repository.create({
        userId: actor.userId,
        sourceLang,
        targetLang,
        status: 'ready',
        title,
        payload,
        totalUnits: split.units.length,
        doneUnits: 0,
        totalBatches: batches.length,
        nextBatch: 0,
        stepLockUntil: null,
        completedAt: null,
        expiresAt: new Date(Date.now() + 48 * 60 * 60 * 1000),
        backgroundRun: options.background === true,
      }),
    );

    if (docxRefs) {
      // الملف الأصلى يُحفظ مشفَّراً بعمر المهمة نفسه؛ تعذّر الحفظ ⇒ لا مهمة نصف معدّة (تُحذف) ويُطلب إعادة المحاولة
      const saved = await this.sources!.save(row.id, file.buffer);
      if (!saved) {
        await this.repository.delete({ id: row.id });
        throw new ServiceUnavailableException('تعذّر حفظ الملف الأصلى مؤقتاً لكتابة الترجمة بتنسيقه — أعد المحاولة، أو ابدأ الترجمة دون خيار الاحتفاظ بالتنسيق.');
      }
    }

    await this.recordAudit(actor, 'translation.created', row.id, {
      from: sourceLang,
      to: targetLang,
      type: read.type,
      bytes: file.size,
      chars: split.totalChars,
      units: split.units.length,
      batches: batches.length,
      ocr: read.usedOcr,
      contract_type: profile.contractType,
      consent_version: TRANSLATION_CONSENT_VERSION,
      background: options.background === true,
      preserve_format: docxRefs !== null,
    });
    if (options.background === true) {
      // امتلاء طابور الخلفية ليس خطأ: تبقى المهمة جاهزة ويقودها العميل كالمعتاد
      const outcome = this.enqueueBackground(row.id, actor);
      if (outcome === 'full') {
        row.backgroundRun = false;
        await this.repository.update({ id: row.id }, { backgroundRun: false });
      }
    }
    return this.toView(row, payload);
  }

  // ───────────────────────── التشغيل فى الخلفية ─────────────────────────

  private enqueueBackground(id: string, actor: TranslationActor): EnqueueOutcome {
    // الفاعل يُسجَّل قبل enqueue: المشغِّل يبدأ أول خطوة بشكل متزامن داخل enqueue نفسها
    const hadActor = this.runActors.has(id);
    this.runActors.set(id, actor);
    const outcome = this.runner.enqueue(id);
    if ((outcome === 'duplicate' || outcome === 'full') && !hadActor) this.runActors.delete(id);
    return outcome;
  }

  /** خطوة المشغِّل: نفس step التى يستدعيها العميل (القفل الذرى يمنع التداخل معه). */
  private async stepInBackground(id: string): Promise<{ status: 'ready' | 'translating' | 'completed' }> {
    const actor = this.runActors.get(id);
    if (!actor) throw new NotFoundException('لا مشغِّل لهذه المهمة');
    return this.step(id, actor);
  }

  private onRunnerStop(id: string, reason: RunnerStopReason, err?: unknown): void {
    this.runActors.delete(id);
    if (reason === 'completed') {
      this.logger.log(`[background] اكتملت الترجمة ${id}`);
    } else {
      this.logger.warn(`[background] توقفت الترجمة ${id}: ${reason}${err ? ` — ${(err as Error).message ?? String(err)}` : ''}`);
    }
    // مهمة اكتملت أو توقفت أو حُذفت لا تُعاد محاولتها مع كل إقلاع؛ المستخدم يستأنفها بزر الاستئناف (يقود العميل أو يعيد التشغيل بالخلفية)
    if (reason !== 'not_found') {
      this.repository
        .update({ id }, { backgroundRun: false })
        .catch((e) => this.logger.warn(`failed to clear background flag: ${(e as Error).message}`));
    }
  }

  /** يطلب من الخادم إكمال مهمة موجودة (مثلاً بعد توقفها): مملوكة للمستخدم، وغير مكتملة. */
  async runInBackground(id: string, actor: TranslationActor): Promise<TranslationView> {
    const row = await this.owned(id, actor);
    const payload = row.payload as Payload;
    if (row.status === 'completed') return this.toView(row, payload);
    if (!this.model.isConfigured) {
      throw new ServiceUnavailableException('خدمة الترجمة غير متاحة مؤقتاً — حاول لاحقاً.');
    }
    if (!this.runner.isActive(id)) {
      await this.repository.update({ id }, { backgroundRun: true });
      row.backgroundRun = true;
      const outcome = this.enqueueBackground(id, actor);
      if (outcome === 'full') {
        await this.repository.update({ id }, { backgroundRun: false });
        row.backgroundRun = false;
        throw new HttpException('طابور الترجمة فى الخلفية ممتلئ حالياً — حاول بعد قليل أو أكمل الترجمة من الصفحة.', HttpStatus.TOO_MANY_REQUESTS);
      }
      await this.recordAudit(actor, 'translation.background_started', id, { resumed: row.nextBatch > 0 });
    }
    return this.toView(row, payload);
  }

  /** بعد إعادة تشغيل الخادم: تُستأنف المهام التى كانت تعمل فى الخلفية من آخر دفعة محفوظة (لا تُعاد دفعة اكتملت). */
  async onApplicationBootstrap(): Promise<void> {
    if (process.env.TRANSLATION_RESUME_ON_BOOT === 'false') return;
    try {
      const rows = await this.repository.find({
        where: { backgroundRun: true, status: In(['ready', 'translating']), expiresAt: MoreThan(new Date()) },
        order: { createdAt: 'ASC' },
        take: 50,
      });
      let resumed = 0;
      for (const row of rows) {
        if (!row.userId) continue;
        const outcome = this.enqueueBackground(row.id, { userId: row.userId, role: 'user', ipAddress: null, userAgent: null });
        if (outcome === 'started' || outcome === 'queued') resumed++;
      }
      if (resumed > 0) this.logger.log(`[background] استُؤنفت ${resumed} ترجمة بعد الإقلاع`);
    } catch (err) {
      // فشل الاستئناف لا يمنع إقلاع الخادم؛ المستخدم يستأنف يدوياً
      this.logger.error(`[background] تعذر استئناف الترجمات بعد الإقلاع: ${(err as Error).message}`);
    }
  }

  // ───────────────────────── الخطوات ─────────────────────────

  async step(id: string, actor: TranslationActor): Promise<TranslationView> {
    const row = await this.owned(id, actor);
    if (row.status === 'completed') return this.toView(row, row.payload as Payload);
    if (!this.model.isConfigured) {
      throw new ServiceUnavailableException('خدمة الترجمة غير متاحة مؤقتاً — حاول لاحقاً.');
    }

    // قفل ذرّى: لا خطوتان متوازيتان على المهمة نفسها
    const locked = await this.repository
      .createQueryBuilder()
      .update(LegalTranslation)
      .set({ stepLockUntil: () => `now() + interval '${STEP_LOCK_SECONDS} seconds'` })
      .where('id = :id', { id })
      .andWhere('status IN (:...st)', { st: ['ready', 'translating'] })
      .andWhere('(step_lock_until IS NULL OR step_lock_until < now())')
      .execute();
    if (!locked.affected) {
      throw new ConflictException('هناك خطوة ترجمة جارية لهذه المهمة — انتظر اكتمالها.');
    }

    try {
      const fresh = await this.repository.findOne({ where: { id } });
      if (!fresh) throw new NotFoundException('الترجمة غير موجودة');
      const payload = fresh.payload as Payload;
      const batch = payload.batches[fresh.nextBatch];
      if (!batch) {
        return await this.finish(fresh, payload, actor);
      }
      await this.translateBatch(fresh, payload, batch);

      const nextBatch = fresh.nextBatch + 1;
      const done = nextBatch >= payload.batches.length;
      fresh.nextBatch = nextBatch;
      fresh.doneUnits = done ? fresh.totalUnits : payload.batches[nextBatch].start;
      fresh.status = 'translating';
      fresh.payload = payload;
      fresh.stepLockUntil = null;
      await this.persistProgress(fresh, {
        nextBatch: fresh.nextBatch,
        doneUnits: fresh.doneUnits,
        status: 'translating',
        payload,
        stepLockUntil: null,
      });
      if (done) return await this.finish(fresh, payload, actor);
      return this.toView(fresh, payload);
    } catch (err) {
      await this.repository
        .update({ id }, { stepLockUntil: null })
        .catch((e) => this.logger.warn(`failed to release step lock: ${(e as Error).message}`));
      throw err;
    }
  }

  /**
   * حفظ تقدم الخطوة بـUPDATE لا save: إن حذف المستخدم المهمة أثناء الخطوة (وارد جداً مع تشغيل الخلفية) فsave كانت ستعيد إدراج
   * الصف المحذوف بعقده كاملاً (TypeORM يُدرج إن لم يجد المعرّف)، أما UPDATE فلا يمس صفاً غير موجود ونرمى 404 فيتوقف كل شىء.
   */
  private async persistProgress(row: LegalTranslation, patch: Partial<LegalTranslation>): Promise<void> {
    const res = await this.repository.update({ id: row.id }, patch as never);
    if (res && res.affected === 0) {
      throw new NotFoundException('الترجمة غير موجودة أو انتهت صلاحيتها');
    }
  }

  private async finish(row: LegalTranslation, payload: Payload, actor: TranslationActor): Promise<TranslationView> {
    row.status = 'completed';
    row.completedAt = new Date();
    row.doneUnits = row.totalUnits;
    row.expiresAt = new Date(Date.now() + COMPLETED_RETENTION_HOURS * 60 * 60 * 1000);
    row.stepLockUntil = null;
    row.payload = payload;
    await this.persistProgress(row, {
      status: 'completed',
      completedAt: row.completedAt,
      doneUnits: row.doneUnits,
      expiresAt: row.expiresAt,
      stepLockUntil: null,
      payload,
    });
    const flagged = payload.units.filter((u) => u.flags.length > 0).length;
    await this.recordAudit(actor, 'translation.completed', row.id, {
      from: row.sourceLang,
      to: row.targetLang,
      units: row.totalUnits,
      flagged,
      notes: payload.notes.length,
    });
    return this.toView(row, payload);
  }

  /** يترجم دفعة واحدة (مع إعادة ترجمة واحدة للوحدات الفاشلة فى الفحوص) ويُحدّث الحمولة فى الذاكرة. */
  private async translateBatch(row: LegalTranslation, payload: Payload, batch: { start: number; end: number }): Promise<void> {
    const from = row.sourceLang;
    const to = row.targetLang;
    const indices: number[] = [];
    for (let i = batch.start; i < batch.end; i++) indices.push(i);

    const terms = await this.glossary.activeTerms();
    const joined = indices.map((i) => payload.units[i].src).join('\n');
    const glossary = matchGlossary(joined, from, terms);
    const system = buildSystemPrompt(from, to);
    const common = {
      from,
      to,
      glossary,
      knownTerms: payload.knownTerms,
      contractType: payload.profile.contractType,
      drafting: payload.profile.drafting,
    };

    const first = await this.callModel(system, { ...common, units: indices.map((i) => ({ i, text: payload.units[i].src })) }, indices);
    const results = new Map<number, string>(first.translations);
    let notes = first.notes;
    let defined = first.definedTerms;

    const problems = (): Record<number, string> => {
      const hints: Record<number, string> = {};
      for (const i of indices) {
        const t = results.get(i);
        if (t === undefined || t.trim().length === 0) {
          hints[i] = 'no translation was produced; translate this item completely.';
          continue;
        }
        const flags = checkUnit(payload.units[i].src, t, from, to);
        if (flags.includes('numbers_mismatch')) hints[i] = 'numbers, amounts or dates differ from the source; reproduce every figure exactly.';
        else if (flags.includes('length_anomaly')) hints[i] = 'translation length is out of proportion to the source; do not omit or add content.';
        else if (flags.includes('untranslated_text')) hints[i] = 'part of the text was left untranslated; translate all of it (keep proper names).';
      }
      return hints;
    };

    const hints = problems();
    const retryIdx = Object.keys(hints).map(Number);
    if (retryIdx.length > 0) {
      const second = await this.callModel(
        system,
        {
          ...common,
          knownTerms: mergeDefinedTerms(payload.knownTerms, defined),
          units: retryIdx.map((i) => ({ i, text: payload.units[i].src })),
          retryHints: hints,
        },
        retryIdx,
        true,
      );
      for (const [i, t] of second.translations) {
        // نقبل إعادة الترجمة فقط إن لم تكن أسوأ (فارغة)
        if (t.trim().length > 0) results.set(i, t);
      }
      notes = notes.concat(second.notes);
      defined = defined.concat(second.definedTerms);
    }

    for (const i of indices) {
      const t = (results.get(i) ?? '').trim();
      payload.units[i].tgt = t;
      payload.units[i].flags = checkUnit(payload.units[i].src, t, from, to);
    }
    // ملاحظات الدفعة (بلا تكرار لنفس الوحدة والمصطلح)
    const seen = new Set(payload.notes.map((n) => `${n.i}|${n.term}`));
    for (const n of notes) {
      const key = `${n.i}|${n.term}`;
      if (!seen.has(key) && payload.notes.length < 300) {
        seen.add(key);
        payload.notes.push(n);
      }
    }
    payload.knownTerms = mergeDefinedTerms(payload.knownTerms, defined);
  }

  private async callModel(
    system: string,
    input: Parameters<typeof buildBatchUserMessage>[0],
    expected: number[],
    isRetry = false,
  ) {
    const outcome = await this.model.translateBatch(system, buildBatchUserMessage(input));
    if (outcome.status !== 'ok') {
      if (isRetry) {
        // فشل إعادة المحاولة لا يُسقط الدفعة: نُبقى ترجمتها الأولى ونُوسمها للمراجعة
        return { translations: new Map<number, string>(), notes: [], definedTerms: [] };
      }
      throw new BadGatewayException('تعذّرت الترجمة الآن — لا يضيع ما أُنجز، أعد المحاولة بعد لحظات.');
    }
    return parseBatchOutput(outcome.raw, expected);
  }

  // ───────────────────────── القراءة والتحرير والحذف ─────────────────────────

  /** ترجمات المستخدم الحية (غير المنتهية) للعودة إليها بعد إغلاق الصفحة؛ بلا حمولة (لا فك تشفير ولا نص عقد). */
  async list(actor: TranslationActor): Promise<TranslationListItem[]> {
    const rows = await this.repository.find({
      where: { userId: actor.userId, expiresAt: MoreThan(new Date()) },
      select: ['id', 'status', 'sourceLang', 'targetLang', 'title', 'doneUnits', 'totalUnits', 'nextBatch', 'totalBatches', 'expiresAt', 'createdAt'],
      order: { createdAt: 'DESC' },
      take: 20,
    });
    return rows.map((row) => ({
      id: row.id,
      status: row.status,
      source_lang: row.sourceLang,
      target_lang: row.targetLang,
      title: row.title,
      progress: { done_units: row.doneUnits, total_units: row.totalUnits, done_batches: row.nextBatch, total_batches: row.totalBatches },
      background: this.runner.isActive(row.id) ? 'running' : 'idle',
      expires_at: row.expiresAt.toISOString(),
      created_at: row.createdAt.toISOString(),
    }));
  }

  async get(id: string, actor: TranslationActor): Promise<TranslationView> {
    const row = await this.owned(id, actor);
    return this.toView(row, row.payload as Payload);
  }

  async units(id: string, offset: number, limit: number, actor: TranslationActor): Promise<UnitsPage> {
    const row = await this.owned(id, actor);
    const payload = row.payload as Payload;
    const o = Math.max(0, Math.floor(offset) || 0);
    const l = Math.min(100, Math.max(1, Math.floor(limit) || 50));
    return {
      total: payload.units.length,
      offset: o,
      items: payload.units.slice(o, o + l).map((u, k) => ({
        n: o + k + 1,
        src: u.src,
        tgt: u.tgt ?? '',
        flags: u.flags,
        cont: u.cont,
        edited: Boolean(u.edited),
      })),
    };
  }

  /** تعديل المستخدم لترجمة فقرة (تصحيح بند موسوم للمراجعة مثلاً) — يُزيل وسمها. */
  async editUnit(id: string, n: number, text: string, actor: TranslationActor): Promise<UnitsPage['items'][number]> {
    const row = await this.owned(id, actor);
    if (row.status !== 'completed') throw new ConflictException('يمكن تعديل الترجمة بعد اكتمالها.');
    const payload = row.payload as Payload;
    const idx = n - 1;
    const unit = payload.units[idx];
    if (!unit) throw new NotFoundException('الفقرة غير موجودة');
    const clean = text.replace(/\u0000/g, '').trim();
    if (clean.length === 0 || clean.length > MAX_EDIT_CHARS) {
      throw new BadRequestException(`نص الفقرة يجب أن يكون بين 1 و${MAX_EDIT_CHARS} حرف`);
    }
    unit.tgt = clean;
    unit.flags = [];
    unit.edited = true;
    row.payload = payload;
    await this.repository.save(row);
    return { n, src: unit.src, tgt: clean, flags: [], cont: unit.cont, edited: true };
  }

  async remove(id: string, actor: TranslationActor): Promise<void> {
    const row = await this.owned(id, actor);
    await this.repository.delete({ id: row.id });
    await this.recordAudit(actor, 'translation.deleted', row.id, {});
  }

  /** حذف المنتهية صلاحيتها (تستدعيه مهمة الاحتفاظ). يعيد عدد المحذوف. */
  async purgeExpired(): Promise<number> {
    const res = await this.repository
      .createQueryBuilder()
      .delete()
      .from(LegalTranslation)
      .where('expires_at < now()')
      .execute();
    return res.affected ?? 0;
  }

  // ───────────────────────── التنزيل ─────────────────────────

  async download(
    id: string,
    format: 'pdf' | 'docx',
    layout: DownloadLayout,
    actor: TranslationActor,
  ): Promise<ExportedTranslation> {
    const row = await this.owned(id, actor);
    if (row.status !== 'completed') throw new ConflictException('لم تكتمل الترجمة بعد.');
    const payload = row.payload as Payload;
    if (layout === 'original') return this.downloadOriginalLayout(row, payload, format, actor);
    const views: StoredUnitView[] = payload.units.map((u) => ({
      src: u.src,
      cont: u.cont,
      tgt: u.tgt,
      flags: u.flags,
      edited: u.edited,
    }));
    const { notes, flagged } = buildNotesAndFlags(views, payload.notes);
    const reference = shortReference('TRN', row.id);
    const doc: TranslationDocument = {
      layout,
      from: row.sourceLang,
      to: row.targetLang,
      brand: this.brandFor(row.targetLang),
      reference,
      generatedAt: new Date(),
      contractType: payload.profile.contractType,
      paragraphs: toParagraphs(views),
      notes,
      flagged,
      filenameBase: `translation-${row.sourceLang}-${row.targetLang}-${reference}-${compactCairoDate(new Date())}`,
    };
    const buffer =
      format === 'pdf'
        ? await this.pdfRenderer.renderHtmlString(renderTranslationHtml(doc))
        : await renderTranslationDocx(doc);
    await this.recordAudit(actor, 'translation.downloaded', row.id, { format, layout, bytes: buffer.length, reference });
    return { buffer, contentType: CONTENT_TYPES[format], filename: `${doc.filenameBase}${layout === 'bilingual' ? '-bilingual' : ''}.${format}` };
  }

  /** وحدات الترجمة من فقرات ملف Word: فقرة = وحدة، والطويلة تُقطَّع (cont) وتتشارك رقم الفقرة. */
  private unitsFromDocx(refs: DocxParagraphRef[]): { units: Array<{ text: string; cont: boolean; p: number }>; totalChars: number } {
    const units: Array<{ text: string; cont: boolean; p: number }> = [];
    let totalChars = 0;
    for (const ref of refs) {
      totalChars += ref.text.length;
      splitLongUnit(ref.text).forEach((chunk, i) => units.push({ text: chunk, cont: i > 0, p: ref.ordinal }));
    }
    return { units, totalChars };
  }

  /** كتابة الترجمة داخل ملف Word الأصلى (جداول/ترقيم/أنماط). فقرة بلا ترجمة كاملة تبقى بنصها الأصلى. */
  private async downloadOriginalLayout(
    row: LegalTranslation,
    payload: Payload,
    format: 'pdf' | 'docx',
    actor: TranslationActor,
  ): Promise<ExportedTranslation> {
    if (format !== 'docx') throw new BadRequestException('التنزيل بتنسيق الأصل متاح بصيغة Word (docx) فقط.');
    if (payload.docx !== true || !this.sources) {
      throw new ConflictException('هذه الترجمة لم تُنشأ بخيار الاحتفاظ بتنسيق الملف الأصلى — نزّلها بالتنسيق القياسى.');
    }
    const source = await this.sources.load(row.id);
    if (!source) throw new ConflictException('الملف الأصلى لم يعد متاحاً — نزّل الترجمة بالتنسيق القياسى.');

    // قطع الفقرة الواحدة تُلصق بالترتيب؛ فقرة نقصت ترجمة أى قطعة منها تبقى بأصلها (لا نصف ترجمة)
    const parts = new Map<number, { text: string[]; complete: boolean }>();
    for (const u of payload.units) {
      if (u.p === undefined) continue;
      const entry = parts.get(u.p) ?? { text: [], complete: true };
      const t = (u.tgt ?? '').trim();
      if (!t) entry.complete = false;
      else entry.text.push(t);
      parts.set(u.p, entry);
    }
    const translations = new Map<number, string>();
    for (const [p, e] of parts) if (e.complete && e.text.length > 0) translations.set(p, e.text.join(' '));

    let buffer: Buffer;
    try {
      buffer = await applyDocxTranslation(source, translations, { to: row.targetLang, banner: WATERMARK[row.targetLang] });
    } catch (err) {
      if (err instanceof DocxLayoutError) {
        this.logger.warn(`original-layout export failed: ${err.message}`);
        throw new UnprocessableEntityException('تعذّر كتابة الترجمة داخل الملف الأصلى — نزّلها بالتنسيق القياسى.');
      }
      throw err;
    }
    const reference = shortReference('TRN', row.id);
    await this.recordAudit(actor, 'translation.downloaded', row.id, {
      format,
      layout: 'original',
      bytes: buffer.length,
      reference,
      paragraphs: translations.size,
    });
    return {
      buffer,
      contentType: CONTENT_TYPES.docx,
      filename: `translation-${row.sourceLang}-${row.targetLang}-${reference}-${compactCairoDate(new Date())}-original.docx`,
    };
  }

  // ───────────────────────── مساعدات ─────────────────────────

  /** الملكية: المالك فقط (حتى admin لا يقرأ عقوداً ليست له)؛ غير ذلك 404 دون كشف الوجود. */
  private async owned(id: string, actor: TranslationActor): Promise<LegalTranslation> {
    const row = await this.repository.findOne({ where: { id } });
    if (!row || row.userId !== actor.userId || row.expiresAt.getTime() < Date.now()) {
      throw new NotFoundException('الترجمة غير موجودة أو انتهت صلاحيتها');
    }
    return row;
  }

  private titleFromFilename(name: string): string {
    const base = name.replace(/\.[A-Za-z0-9]{1,5}$/, '').replace(/[\u0000-\u001f]/g, ' ').replace(/\s+/g, ' ').trim();
    return (base || 'عقد').slice(0, 120);
  }

  private toView(row: LegalTranslation, payload: Payload): TranslationView {
    const flagged = payload.units
      .map((u, i) => ({ u, i }))
      .filter(({ u }) => u.flags.length > 0 && !u.edited)
      .slice(0, 200)
      .map(({ u, i }) => ({ n: i + 1, flags: u.flags, src: excerpt(u.src), tgt: excerpt(u.tgt) }));
    return {
      id: row.id,
      status: row.status,
      source_lang: row.sourceLang,
      target_lang: row.targetLang,
      title: row.title,
      contract_type: payload.profile.contractType,
      detection: payload.detection,
      progress: {
        done_units: row.doneUnits,
        total_units: row.totalUnits,
        done_batches: row.nextBatch,
        total_batches: row.totalBatches,
      },
      warnings: payload.warnings,
      flagged,
      notes: payload.notes.slice(0, 100).map((n) => ({ n: n.i + 1, term: n.term, note: n.note })),
      expires_at: row.expiresAt.toISOString(),
      created_at: row.createdAt.toISOString(),
      background: this.runner.isActive(row.id) ? 'running' : 'idle',
      original_layout: payload.docx === true,
    };
  }

  private async recordAudit(
    actor: TranslationActor,
    action: string,
    resourceId: string,
    metadata: Record<string, unknown>,
  ): Promise<void> {
    await this.audit
      .record({
        actorId: actor.userId,
        actorRole: actor.role,
        action,
        resourceType: 'translation',
        resourceId,
        ipAddress: actor.ipAddress,
        userAgent: actor.userAgent,
        metadata,
      })
      .catch((err) => this.logger.warn(`translation audit failed (non-fatal): ${(err as Error).message}`));
  }
}
