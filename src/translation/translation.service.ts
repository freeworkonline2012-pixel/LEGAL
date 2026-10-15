import {
  BadGatewayException,
  BadRequestException,
  ConflictException,
  HttpException,
  HttpStatus,
  Injectable,
  Logger,
  NotFoundException,
  ServiceUnavailableException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { MoreThan, Repository } from 'typeorm';
import { AuditService } from '../audit/audit.service';
import { DocumentReaderService } from '../documents/document-reader.service';
import { LegalTranslation } from '../database/entities/legal-translation.entity';
import { PdfRenderer } from '../exports/renderers/pdf.renderer';
import { DEFAULT_BRAND, compactCairoDate, shortReference } from '../exports/document-model';
import { GlossaryService } from './glossary.service';
import { matchGlossary } from './glossary';
import { detectLanguage, type ContractLang } from './language-detect';
import { MAX_TOTAL_CHARS, MAX_UNITS, planBatches, splitIntoUnits } from './paragraph-splitter';
import { checkUnit, type UnitFlag } from './translation-checks';
import {
  buildNotesAndFlags,
  toParagraphs,
  type StoredUnitView,
  type TranslationDocument,
  type TranslationLayout,
} from './translation-document';
import { renderTranslationDocx } from './translation-docx.renderer';
import { renderTranslationHtml } from './translation-html.renderer';
import { TranslationModelService } from './translation-model.service';
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

interface StoredUnit {
  src: string;
  cont: boolean;
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
export class TranslationService {
  private readonly logger = new Logger(TranslationService.name);

  constructor(
    @InjectRepository(LegalTranslation) private readonly repository: Repository<LegalTranslation>,
    private readonly reader: DocumentReaderService,
    private readonly model: TranslationModelService,
    private readonly glossary: GlossaryService,
    private readonly audit: AuditService,
    private readonly pdfRenderer: PdfRenderer,
  ) {}

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

    const split = splitIntoUnits(read.text);
    if (split.totalChars > MAX_TOTAL_CHARS || split.units.length > MAX_UNITS) {
      throw new UnprocessableEntityException(
        'العقد أطول من الحد المسموح للترجمة الآلية فى طلب واحد — قسّمه إلى أجزاء (مثلاً: العقد وملاحقه كل على حدة).',
      );
    }
    if (split.units.length === 0) {
      throw new UnprocessableEntityException('لم نجد نصاً قابلاً للترجمة فى الملف.');
    }

    const warnings = [...read.warnings];
    if (read.usedOcr) warnings.push('قُرئ العقد آلياً من صورة — راجع الأرقام والتواريخ والأسماء فى الترجمة بعناية.');
    if (detection.mixedMinority) {
      warnings.push('يحوى العقد نصوصاً بلغة أخرى (أسماء أو مصطلحات)؛ تُنقل الأسماء كما هى حيثما أمكن.');
    }

    const profileOutcome = await this.model.profile(read.text.slice(0, PROFILE_HEAD_CHARS));
    const profile = profileOutcome.status === 'ok' ? parseProfile(profileOutcome.raw) : parseProfile(null);

    const batches = planBatches(split.units.map((u) => u.text.length));
    const payload: Payload = {
      units: split.units.map((u) => ({ src: u.text, cont: u.cont, tgt: null, flags: [] })),
      batches,
      notes: [],
      knownTerms: [],
      profile,
      warnings,
      ocr: read.usedOcr,
      detection: { lang: sourceLang, dominant_share: Math.round(detection.dominantShare * 1000) / 1000 },
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
      }),
    );

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
    });
    return this.toView(row, payload);
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
      await this.repository.save(fresh);
      if (done) return await this.finish(fresh, payload, actor);
      return this.toView(fresh, payload);
    } catch (err) {
      await this.repository
        .update({ id }, { stepLockUntil: null })
        .catch((e) => this.logger.warn(`failed to release step lock: ${(e as Error).message}`));
      throw err;
    }
  }

  private async finish(row: LegalTranslation, payload: Payload, actor: TranslationActor): Promise<TranslationView> {
    row.status = 'completed';
    row.completedAt = new Date();
    row.doneUnits = row.totalUnits;
    row.expiresAt = new Date(Date.now() + COMPLETED_RETENTION_HOURS * 60 * 60 * 1000);
    row.stepLockUntil = null;
    row.payload = payload;
    await this.repository.save(row);
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
    layout: TranslationLayout,
    actor: TranslationActor,
  ): Promise<ExportedTranslation> {
    const row = await this.owned(id, actor);
    if (row.status !== 'completed') throw new ConflictException('لم تكتمل الترجمة بعد.');
    const payload = row.payload as Payload;
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
