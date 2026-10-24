import { Injectable, Logger } from '@nestjs/common';
import { execFile } from 'child_process';
import { mkdtemp, readdir, rm, writeFile } from 'fs/promises';
import { tmpdir } from 'os';
import { join } from 'path';
import { promisify } from 'util';
import { insertLinesByPosition, linesToText, OcrLine, parseTsvLines } from './ocr-recovery.util';

const execFileAsync = promisify(execFile);

/** صفحات PDF الممسوح التى تُقرأ كحد أقصى (الباقى يُتجاهل ويُنبَّه العميل). */
export const OCR_MAX_PAGES = 8;
const PAGE_TIMEOUT_MS = 60_000;
const RASTER_TIMEOUT_MS = 60_000;
const MAX_CONCURRENT = 2;

/** خيارات اختيارية: قراءة ثانية بدقة أعلى تُختار منها كل صفحة بالأفضل حسب مقياس تمرّره الخدمة المستدعية. */
export interface OcrRecognizeOptions {
  /** يُرجع «جودة» نص الصفحة (مثلاً عدد عناوين البنود المقروءة)؛ الأعلى يُختار، وعند التعادل تبقى القراءة الأولى. */
  pageScore?: (pageText: string) => number;
  /**
   * استرجاع أسطر ضائعة: إن وُجدت أرقام ناقصة فى النص (فجوة فى ترقيم البنود) تُقرأ الصفحات قراءة متناثرة (psm 11) التى تلتقط
   * العناوين القصيرة المنفردة، وتُدرج الأسطر المطابقة للأرقام الناقصة فى موضعها الرأسى من الصفحة.
   */
  recoverMissing?: {
    missingNumbers: (fullText: string) => number[];
    /** رقم العنوان إن كان السطر عنواناً مقبولاً، وإلا null */
    headingNumber: (line: string) => number | null;
  };
}

export type OcrOutcome =
  | { status: 'ok'; text: string; pages: number; truncatedPages: boolean }
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
  private availability: Promise<boolean> | null = null;
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

  private async recognizeFile(path: string): Promise<string> {
    const { stdout } = await execFileAsync(this.tesseract, [path, 'stdout', '-l', this.lang, '--psm', '3'], {
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
  ): Promise<string[]> {
    const out = [...first];
    try {
      await execFileAsync(this.pdftoppm, ['-r', '300', '-png', '-l', String(pageCount), pdfPath, join(dir, 'h')], {
        timeout: RASTER_TIMEOUT_MS,
      });
      const hi = (await readdir(dir)).filter((f) => /^h-\d+\.png$/.test(f)).sort();
      for (let i = 0; i < Math.min(hi.length, pageCount); i++) {
        try {
          const alt = await this.recognizeFile(join(dir, hi[i]));
          if (score(alt) > score(out[i])) out[i] = alt;
        } catch {
          // نُبقى القراءة الأولى لهذه الصفحة
        }
      }
    } catch (err) {
      this.logger.warn(`OCR second pass skipped: ${(err as Error).message.slice(0, 120)}`);
    }
    return out;
  }

  private async tsvLines(imagePath: string, psm: number): Promise<OcrLine[]> {
    const { stdout } = await execFileAsync(this.tesseract, [imagePath, 'stdout', '-l', this.lang, '--psm', String(psm), 'tsv'], {
      timeout: PAGE_TIMEOUT_MS,
      maxBuffer: 16 * 1024 * 1024,
    });
    return parseTsvLines(stdout);
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
  ): Promise<void> {
    let missing = new Set(cfg.missingNumbers(texts.join('\n\n')));
    if (missing.size === 0) return;
    for (const images of imageSets) {
      for (let i = 0; i < texts.length && missing.size > 0; i++) {
        const image = images[i];
        if (!image) continue;
        try {
          const sparse = await this.tsvLines(image, 11);
          const found = sparse.filter((l) => {
            const n = cfg.headingNumber(l.text);
            return n !== null && missing.has(n);
          });
          if (found.length === 0) continue;
          const base = await this.tsvLines(image, 3);
          const present = new Set(base.map((l) => cfg.headingNumber(l.text)).filter((n): n is number => n !== null));
          const toInsert = found.filter((l) => !present.has(cfg.headingNumber(l.text) as number));
          // الأداة نفسها وجدت العنوان فى القراءة العادية بصيغة TSV (لا فى نص هذه الصفحة المختار): نستعمل نص TSV كما هو
          texts[i] = toInsert.length === 0 ? linesToText(base) : insertLinesByPosition(base, toInsert);
          missing = new Set(cfg.missingNumbers(texts.join('\n\n')));
        } catch (err) {
          this.logger.warn(`OCR heading recovery skipped: ${(err as Error).message.slice(0, 120)}`);
        }
      }
    }
  }

  async recognize(buffer: Buffer, kind: 'pdf' | 'png' | 'jpeg', options: OcrRecognizeOptions = {}): Promise<OcrOutcome> {
    if (!(await this.isAvailable())) return { status: 'unavailable' };
    await this.acquire();
    let dir: string | null = null;
    try {
      dir = await mkdtemp(join(tmpdir(), 'ocr-'));
      if (kind === 'pdf') {
        const pdfPath = join(dir, 'in.pdf');
        await writeFile(pdfPath, buffer, { mode: 0o600 });
        await execFileAsync(
          this.pdftoppm,
          ['-r', '200', '-png', '-l', String(OCR_MAX_PAGES + 1), pdfPath, join(dir, 'p')],
          { timeout: RASTER_TIMEOUT_MS },
        );
        const pages = (await readdir(dir)).filter((f) => /^p-\d+\.png$/.test(f)).sort();
        if (pages.length === 0) return { status: 'error', detail: 'no_pages' };
        const used = pages.slice(0, OCR_MAX_PAGES);
        const texts: string[] = [];
        for (const f of used) texts.push(await this.recognizeFile(join(dir, f)));
        if (options.pageScore) {
          const better = await this.rereadWithHigherDpi(pdfPath, dir, used.length, texts, options.pageScore);
          for (let i = 0; i < better.length; i++) texts[i] = better[i];
        }
        if (options.recoverMissing) {
          const lows = used.map((f) => join(dir as string, f));
          const hi = (await readdir(dir)).filter((f) => /^h-\d+\.png$/.test(f)).sort();
          const highs = hi.slice(0, used.length).map((f) => join(dir as string, f));
          await this.recoverMissingHeadings(texts, [lows, highs], options.recoverMissing);
        }
        return {
          status: 'ok',
          text: texts.join('\n\n'),
          pages: used.length,
          truncatedPages: pages.length > OCR_MAX_PAGES,
        };
      }
      const imgPath = join(dir, kind === 'png' ? 'in.png' : 'in.jpg');
      await writeFile(imgPath, buffer, { mode: 0o600 });
      const text = await this.recognizeFile(imgPath);
      return { status: 'ok', text, pages: 1, truncatedPages: false };
    } catch (err) {
      this.logger.warn(`OCR failed: ${(err as Error).message.slice(0, 200)}`);
      return { status: 'error', detail: (err as Error).message.slice(0, 200) };
    } finally {
      if (dir) await rm(dir, { recursive: true, force: true }).catch(() => undefined);
      this.release();
    }
  }
}

