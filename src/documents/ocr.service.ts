import { Injectable, Logger } from '@nestjs/common';
import { execFile } from 'child_process';
import { mkdtemp, readdir, rm, writeFile } from 'fs/promises';
import { tmpdir } from 'os';
import * as path from 'path';
import { join } from 'path';
import { promisify } from 'util';
import { insertLinesByPosition, linesToText, OcrLine, parseTsvLines } from './ocr-recovery.util';

const execFileAsync = promisify(execFile);

/** صفحات PDF الممسوح التى تُقرأ كحد أقصى فى الطلبات المتزامنة (الباقى يُتجاهل ويُنبَّه العميل). */
export const OCR_MAX_PAGES = 8;
/**
 * حد صفحات العقود الممسوحة حين تجرى المعالجة فى الخلفية (لا طلب HTTP واقف عليها): 34 صفحة، ويُعدَّل بـOCR_MAX_PAGES_BACKGROUND
 * دون أن يقل عن حد الطلب المتزامن ولا يزيد على 100 (حماية من خطأ إعداد يفتح الباب لملفات ضخمة).
 */
export function backgroundOcrMaxPages(): number {
  const n = Number(process.env.OCR_MAX_PAGES_BACKGROUND);
  if (!Number.isFinite(n) || n < OCR_MAX_PAGES) return 34;
  return Math.min(Math.floor(n), 100);
}
const PAGE_TIMEOUT_MS = 60_000;
const RASTER_TIMEOUT_MS = 60_000;
/** تحويل الصفحات إلى صور يطول بطول المستند: مهلة أساسية + ثوانٍ لكل صفحة */
const RASTER_PER_PAGE_MS = 4_000;
/** سقف زمنى لقراءة المستند كله (تتبع الصفحات تتابعاً) حتى لا تعلق مهمة خلفية إلى الأبد */
const OVERALL_TIMEOUT_MS = 40 * 60_000;
const MAX_CONCURRENT = 2;

/** خيارات اختيارية: قراءة ثانية بدقة أعلى تُختار منها كل صفحة بالأفضل حسب مقياس تمرّره الخدمة المستدعية. */
export type OcrProgressStage = 'read' | 'reread' | 'recover';
export interface OcrProgress {
  stage: OcrProgressStage;
  done: number;
  total: number;
}

export interface OcrRecognizeOptions {
  /** أقصى صفحات تُقرأ (الافتراضى {@link OCR_MAX_PAGES}). ما زاد يُعلَن بـtruncatedPages ولا يُقرأ. */
  maxPages?: number;
  /** يُستدعى بعد كل صفحة مقروءة (للمهام الخلفية: نسبة التقدم). أى استثناء منه يُهمَل. */
  onProgress?: (p: OcrProgress) => void;
  /** يُرجع «جودة» نص الصفحة (مثلاً عدد عناوين البنود المقروءة)؛ الأعلى يُختار، وعند التعادل تبقى القراءة الأولى. */
  pageScore?: (pageText: string) => number;
  /**
   * استرجاع أسطر ضائعة: إن وُجدت أرقام ناقصة فى النص (فجوة فى ترقيم البنود) تُقرأ الصفحات قراءة متناثرة (psm 11) التى تلتقط
   * العناوين القصيرة المنفردة، وتُدرج الأسطر المطابقة للأرقام الناقصة فى موضعها الرأسى من الصفحة.
   */
  recoverMissing?: {
    missingNumbers: (fullText: string) => number[];
    /** أرقام العناوين الموجودة فى النص؛ إن وُجدت فلا يُقبل تغيير صفحة إلا إن أضاف رقماً ولم يُسقط أى رقم موجود */
    presentNumbers?: (fullText: string) => number[];
    /** رقم العنوان إن كان السطر عنواناً مقبولاً، وإلا null */
    headingNumber: (line: string) => number | null;
    /** نص قياسى يُدرج بدل السطر الملتقط (يُصلح عنواناً شوّهته رموز مجاورة) */
    canonical?: (n: number) => string | null;
    /** كلمات لتشخيص ما قرأته الأداة حول الأرقام الناقصة (تُسجَّل الأسطر القصيرة التى تحويها فقط) */
    diagnosticWords?: (missing: number[]) => string[];
  };
}

export type OcrOutcome =
  | { status: 'ok'; text: string; pages: number; truncatedPages: boolean; pageChars?: number[] }
  | { status: 'unavailable' }
  | { status: 'error'; detail: string };

/**
 * قراءة آلية (OCR) للمستندات الممسوحة ضوئياً والصور — Tesseract (ara+eng) وpdftoppm عبر execFile بوسائط
 * مصفوفة (لا shell). الملفات المؤقتة فى مجلد عشوائى يُحذف دائماً فى finally؛ لا يُستعمل اسم ملف العميل أبداً.
 * إن غابت الأدوات (بيئة بلا apk tesseract) → 'unavailable' بلا أى أثر على بقية الخدمة.
 * تحدّ ذاتى من التزامن (2) حتى لا يستنزف المعالج.
 */
@Injectable()
export class OcrService {
  private readonly logger = new Logger(OcrService.name);
  private readonly tesseract = process.env.OCR_TESSERACT_PATH ?? 'tesseract';
  private readonly pdftoppm = process.env.OCR_PDFTOPPM_PATH ?? 'pdftoppm';
  private readonly lang = process.env.OCR_LANGS ?? 'ara+eng';
  /** مجلد نموذج لغة ثانٍ (ara «fast» + eng) يُقرأ به كل صفحة قراءة إضافية؛ الغائب = لا قراءة إضافية */
  private readonly altTessdata = process.env.OCR_TESSDATA_ALT?.trim() || null;
  private availability: Promise<boolean> | null = null;
  private altAvailability: Promise<boolean> | null = null;
  private active = 0;
  private waiters: Array<() => void> = [];

  async isAvailable(): Promise<boolean> {
    if (process.env.OCR_ENABLED === 'false') return false;
    this.availability ??= (async () => {
      try {
        await execFileAsync(this.tesseract, ['--version'], { timeout: 10_000 });
        await execFileAsync(this.pdftoppm, ['-v'], { timeout: 10_000 });
        const { stdout, stderr } = await execFileAsync(this.tesseract, ['--list-langs'], { timeout: 10_000 });
        const langs = `${stdout}\n${stderr}`;
        return this.lang.split('+').every((l) => new RegExp(`^${l}$`, 'm').test(langs));
      } catch {
        return false;
      }
    })();
    return this.availability;
  }

  private async acquire(): Promise<void> {
    if (this.active < MAX_CONCURRENT) {
      this.active++;
      return;
    }
    await new Promise<void>((resolve) => this.waiters.push(resolve));
    this.active++;
  }

  private release(): void {
    this.active--;
    this.waiters.shift()?.();
  }

  private async recognizeFile(path: string, tessdataDir?: string): Promise<string> {
    const args = [path, 'stdout', '-l', this.lang, '--psm', '3', ...(tessdataDir ? ['--tessdata-dir', tessdataDir] : [])];
    const { stdout } = await execFileAsync(this.tesseract, args, {
      timeout: PAGE_TIMEOUT_MS,
      maxBuffer: 8 * 1024 * 1024,
    });
    return stdout;
  }

  /**
   * القراءة الآلية تُسقط أحياناً عناوين البنود المسطّرة، وتختلف الصفحات الضائعة باختلاف الدقة (تحقق حى على عقد ممسوح).
   * فنقرأ الصفحات مرة ثانية بدقة 300 ونختار لكل صفحة القراءة ذات المقياس الأعلى. أى فشل فى القراءة الثانية يُهمَل
   * ويبقى نص القراءة الأولى كما هو (لا يضر ولا يُسقط العقد).
   */
  private async rereadWithHigherDpi(
    pdfPath: string,
    dir: string,
    pageCount: number,
    first: string[],
    score: (t: string) => number,
    report?: (done: number, total: number) => void,
    deadline?: number,
  ): Promise<string[]> {
    const out = [...first];
    try {
      await execFileAsync(this.pdftoppm, ['-r', '300', '-png', '-l', String(pageCount), pdfPath, join(dir, 'h')], {
        timeout: RASTER_TIMEOUT_MS + RASTER_PER_PAGE_MS * pageCount,
      });
      const hi = (await readdir(dir)).filter((f) => /^h-\d+\.png$/.test(f)).sort();
      for (let i = 0; i < Math.min(hi.length, pageCount); i++) {
        if (deadline !== undefined && Date.now() > deadline) break; // نكتفى بما قُرئ (القراءة الثانية تحسين لا شرط)
        try {
          const alt = await this.recognizeFile(join(dir, hi[i]));
          if (score(alt) > score(out[i])) out[i] = alt;
        } catch {
          // نُبقى القراءة الأولى لهذه الصفحة
        }
        report?.(i + 1, Math.min(hi.length, pageCount));
      }
    } catch (err) {
      this.logger.warn(`OCR second pass skipped: ${(err as Error).message.slice(0, 120)}`);
    }
    return out;
  }

  /** هل نموذج اللغة الثانى مهيّأ ويحوى كل اللغات المطلوبة؟ (يُتحقق مرة واحدة، والفشل = تعطيل صامت للقراءة الإضافية) */
  private async isAltAvailable(): Promise<boolean> {
    if (!this.altTessdata) return false;
    this.altAvailability ??= (async () => {
      try {
        const { stdout, stderr } = await execFileAsync(this.tesseract, ['--tessdata-dir', this.altTessdata as string, '--list-langs'], { timeout: 10_000 });
        const langs = `${stdout}\n${stderr}`;
        const ok = this.lang.split('+').every((l) => new RegExp(`^${l}$`, 'm').test(langs));
        if (!ok) this.logger.warn('OCR alternate model dir lacks required languages: alternate reading disabled');
        return ok;
      } catch {
        this.logger.warn('OCR alternate model dir unusable: alternate reading disabled');
        return false;
      }
    })();
    return this.altAvailability;
  }

  /**
   * نماذج Tesseract العربية تختلف فيما تُسقطه من عناوين البنود المسطّرة (تحقق حى على 5 عقود ممسوحة: نموذج «fast» وحده التقط
   * عناوين لم يلتقطها النموذج العادى، والعكس فى عقود أخرى). فنقرأ كل صفحة بالنموذج الثانى أيضاً ونختار لكل صفحة القراءة ذات
   * المقياس الأعلى؛ وعند التعادل تبقى القراءة الحالية. أى فشل أو انقضاء السقف الزمنى يُبقى ما قُرئ سابقاً.
   */
  private async rereadWithAlternateModel(
    images: string[],
    texts: string[],
    score: (t: string) => number,
    report?: (done: number, total: number) => void,
    deadline?: number,
  ): Promise<void> {
    if (!(await this.isAltAvailable())) return;
    let adopted = 0;
    for (let i = 0; i < images.length; i++) {
      if (deadline !== undefined && Date.now() > deadline) break;
      try {
        const alt = await this.recognizeFile(images[i], this.altTessdata as string);
        if (score(alt) > score(texts[i])) {
          texts[i] = alt;
          adopted++;
        }
      } catch {
        // نُبقى القراءة السابقة لهذه الصفحة
      }
      report?.(i + 1, images.length);
    }
    this.logger.log(`OCR alternate model: pages=${images.length} adopted=${adopted}`);
  }

  /**
   * يقرأ الصورة بصيغة TSV. نستعمل `-c tessedit_create_tsv=1` بدل إعداد `tsv` لأن مجلد النموذج الثانى لا يحوى مجلد configs،
   * والمخرجات مطابقة بايتاً ببايت للصيغتين (تحقق محلى).
   */
  private async tsvLines(imagePath: string, psm: number, tessdataDir?: string): Promise<OcrLine[]> {
    const args = [imagePath, 'stdout', '-l', this.lang, '--psm', String(psm), ...(tessdataDir ? ['--tessdata-dir', tessdataDir] : []), '-c', 'tessedit_create_tsv=1'];
    const { stdout } = await execFileAsync(this.tesseract, args, {
      timeout: PAGE_TIMEOUT_MS,
      maxBuffer: 16 * 1024 * 1024,
    });
    return parseTsvLines(stdout);
  }

  /** تسجيل أسطر قصيرة تحوى كلمة الترتيبى الناقص أو «بند» فقط (عناوين لا متن)، لمعرفة سبب تعذّر الاسترجاع على الخادم. */
  private diagnose(cfg: NonNullable<OcrRecognizeOptions['recoverMissing']>, missing: number[], lines: OcrLine[], where: string): void {
    const words = [...(cfg.diagnosticWords?.(missing) ?? []), 'بند'];
    const hits = lines.filter((l) => l.text.length <= 40 && words.some((w) => l.text.includes(w))).slice(0, 6);
    this.logger.log(`OCR sparse ${where} lines=${lines.length} headingLike=${JSON.stringify(hits.map((h) => h.text))}`);
  }

  /**
   * يُكمل الأرقام الناقصة: لكل صفحة (بكل دقة متاحة) قراءة متناثرة تلتقط العناوين القصيرة المنفردة التى تُسقطها القراءة العادية،
   * فإن وُجد عنوان بأحد الأرقام الناقصة أُعيدت قراءة تلك الصورة بالتخطيط العادى مع مواضع الأسطر وأُدرج العنوان فى موضعه.
   * أى فشل فى هذه الخطوة يُهمَل ويبقى نص الصفحة كما هو.
   */
  private async recoverMissingHeadings(
    texts: string[],
    imageSets: string[][],
    cfg: NonNullable<OcrRecognizeOptions['recoverMissing']>,
    report?: (done: number, total: number) => void,
    deadline?: number,
    alternateImages?: string[],
  ): Promise<void> {
    let missing = new Set(cfg.missingNumbers(texts.join('\n\n')));
    if (missing.size === 0) {
      this.logger.log(`OCR heading gap: none pages=${texts.length}`);
      return;
    }
    this.logger.log(`OCR heading gap: missing=${[...missing].join(',')} pages=${texts.length}`);
    // القراءات المتاحة: الصور بالنموذج العادى، ثم (إن وُجد) صور 200 بالنموذج الثانى — كل نموذج يلتقط عناوين لا يلتقطها الآخر
    const passes: Array<{ images: string[]; dir?: string }> = imageSets.map((images) => ({ images }));
    if (alternateImages && this.altTessdata) passes.push({ images: alternateImages, dir: this.altTessdata });
    for (const { images, dir } of passes) {
      for (let i = 0; i < texts.length && missing.size > 0; i++) {
        if (deadline !== undefined && Date.now() > deadline) return; // الاسترجاع تحسين اختيارى: نكتفى بما قُرئ
        report?.(i + 1, texts.length);
        const image = images[i];
        if (!image) continue;
        try {
          const sparse = await this.tsvLines(image, 11, dir);
          this.diagnose(cfg, [...missing], sparse, `page=${i + 1} image=${path.basename(image)}`);
          const found = sparse
            .map((l) => ({ l, n: cfg.headingNumber(l.text) }))
            .filter((x): x is { l: OcrLine; n: number } => x.n !== null && missing.has(x.n))
            .map(({ l, n }) => ({ ...l, text: cfg.canonical?.(n) ?? l.text }));
          if (found.length === 0) continue;
          const base = await this.tsvLines(image, 3, dir);
          const present = new Set(base.map((l) => cfg.headingNumber(l.text)).filter((n): n is number => n !== null));
          const toInsert = found.filter((l) => !present.has(cfg.headingNumber(l.text) as number));
          this.logger.log(`OCR heading recovered: page=${i + 1} wanted=${found.map((l) => cfg.headingNumber(l.text)).join(',')} inserted=${toInsert.length} presentInBase=${[...present].join(',')}`);
          // الأداة نفسها وجدت العنوان فى القراءة العادية بصيغة TSV (لا فى نص هذه الصفحة المختار): نستعمل نص TSV كما هو
          const previous = texts[i];
          const presentBefore = cfg.presentNumbers ? new Set(cfg.presentNumbers(texts.join('\n\n'))) : null;
          texts[i] = toInsert.length === 0 ? linesToText(base) : insertLinesByPosition(base, toInsert);
          const joined = texts.join('\n\n');
          const after = new Set(cfg.missingNumbers(joined));
          // لا يُقبل تغيير الصفحة إلا إن أضاف رقماً ولم يُسقط أى رقم كان موجوداً (وبلا مقياس للأرقام الموجودة: إن قلّت الناقصة)؛
          // وإلا استبدلنا قراءة أفضل بأسوأ (تراجع محتمل: فقدان أعلى عنوان يُنقص «الأعلى» فيبدو الناقص أقل)
          let accepted: boolean;
          if (presentBefore && cfg.presentNumbers) {
            const presentAfter = new Set(cfg.presentNumbers(joined));
            accepted = presentAfter.size > presentBefore.size && [...presentBefore].every((n) => presentAfter.has(n));
          } else {
            accepted = after.size < missing.size;
          }
          if (!accepted) {
            texts[i] = previous;
            this.logger.log(`OCR heading recovery reverted: page=${i + 1} missingBefore=${missing.size} missingAfter=${after.size}`);
          } else {
            missing = after;
          }
        } catch (err) {
          this.logger.warn(`OCR heading recovery skipped: ${(err as Error).message.slice(0, 120)}`);
        }
      }
    }
  }

  async recognize(buffer: Buffer, kind: 'pdf' | 'png' | 'jpeg', options: OcrRecognizeOptions = {}): Promise<OcrOutcome> {
    if (!(await this.isAvailable())) return { status: 'unavailable' };
    const maxPages = Math.max(1, Math.floor(options.maxPages ?? OCR_MAX_PAGES));
    const report = (p: OcrProgress): void => {
      try {
        options.onProgress?.(p);
      } catch {
        // التقدم معلومة عرض فقط ولا يُسقط القراءة
      }
    };
    await this.acquire();
    let dir: string | null = null;
    try {
      dir = await mkdtemp(join(tmpdir(), 'ocr-'));
      const deadline = Date.now() + OVERALL_TIMEOUT_MS;
      if (kind === 'pdf') {
        const pdfPath = join(dir, 'in.pdf');
        await writeFile(pdfPath, buffer, { mode: 0o600 });
        await execFileAsync(
          this.pdftoppm,
          ['-r', '200', '-png', '-l', String(maxPages + 1), pdfPath, join(dir, 'p')],
          { timeout: RASTER_TIMEOUT_MS + RASTER_PER_PAGE_MS * (maxPages + 1) },
        );
        const pages = (await readdir(dir)).filter((f) => /^p-\d+\.png$/.test(f)).sort();
        if (pages.length === 0) return { status: 'error', detail: 'no_pages' };
        const used = pages.slice(0, maxPages);
        const texts: string[] = [];
        for (const f of used) {
          // الصفحات الأولى لا غنى عنها: إن انقضى السقف الزمنى قبل اكتمالها فالقراءة فاشلة لا ناقصة بصمت
          if (Date.now() > deadline) return { status: 'error', detail: 'ocr_deadline' };
          texts.push(await this.recognizeFile(join(dir, f)));
          report({ stage: 'read', done: texts.length, total: used.length });
        }
        if (options.pageScore) {
          const better = await this.rereadWithHigherDpi(
            pdfPath,
            dir,
            used.length,
            texts,
            options.pageScore,
            (done, total) => report({ stage: 'reread', done, total }),
            deadline,
          );
          for (let i = 0; i < better.length; i++) texts[i] = better[i];
          await this.rereadWithAlternateModel(
            used.map((f) => join(dir as string, f)),
            texts,
            options.pageScore,
            (done, total) => report({ stage: 'reread', done, total }),
            deadline,
          );
        }
        if (options.recoverMissing) {
          const lows = used.map((f) => join(dir as string, f));
          const hi = (await readdir(dir)).filter((f) => /^h-\d+\.png$/.test(f)).sort();
          const highs = hi.slice(0, used.length).map((f) => join(dir as string, f));
          await this.recoverMissingHeadings(
            texts,
            [lows, highs],
            options.recoverMissing,
            (done, total) => report({ stage: 'recover', done, total }),
            deadline,
            (await this.isAltAvailable()) ? lows : undefined,
          );
        }
        return {
          status: 'ok',
          text: texts.join('\n\n'),
          pages: used.length,
          truncatedPages: pages.length > maxPages,
          // الجولة 75 (تشخيص): أحرف غير بيضاء لكل صفحة، أعداد فقط
          pageChars: texts.map((t) => t.replace(/\s+/g, '').length),
        };
      }
      const imgPath = join(dir, kind === 'png' ? 'in.png' : 'in.jpg');
      await writeFile(imgPath, buffer, { mode: 0o600 });
      const text = await this.recognizeFile(imgPath);
      return { status: 'ok', text, pages: 1, truncatedPages: false, pageChars: [text.replace(/\s+/g, '').length] };
    } catch (err) {
      this.logger.warn(`OCR failed: ${(err as Error).message.slice(0, 200)}`);
      return { status: 'error', detail: (err as Error).message.slice(0, 200) };
    } finally {
      if (dir) await rm(dir, { recursive: true, force: true }).catch(() => undefined);
      this.release();
    }
  }
}

