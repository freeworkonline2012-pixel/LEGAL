import { Injectable, Logger } from '@nestjs/common';
import { execFile } from 'child_process';
import { mkdtemp, readdir, rm, writeFile } from 'fs/promises';
import { tmpdir } from 'os';
import { join } from 'path';
import { promisify } from 'util';

const execFileAsync = promisify(execFile);

/** صفحات PDF الممسوح التى تُقرأ كحد أقصى (الباقى يُتجاهل ويُنبَّه العميل). */
export const OCR_MAX_PAGES = 8;
const PAGE_TIMEOUT_MS = 60_000;
const RASTER_TIMEOUT_MS = 60_000;
const MAX_CONCURRENT = 2;

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

  async recognize(buffer: Buffer, kind: 'pdf' | 'png' | 'jpeg'): Promise<OcrOutcome> {
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

