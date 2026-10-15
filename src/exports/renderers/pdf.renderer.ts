import { Injectable, Logger, OnModuleDestroy, ServiceUnavailableException } from '@nestjs/common';
import { existsSync } from 'fs';
import type { Browser, HTTPRequest } from 'puppeteer-core';
import type { LegalDocument } from '../document-model';
import { renderHtml } from './html.renderer';

const CHROMIUM_CANDIDATES = [
  '/usr/bin/chromium',
  '/usr/bin/chromium-browser',
  '/usr/bin/google-chrome-stable',
  '/opt/pw-browsers/chromium/chrome-linux/chrome',
];

const MAX_CONCURRENT = 2;
const RENDER_TIMEOUT_MS = 30_000;

/**
 * مُخرِج PDF عبر Chromium بلا واجهة — هو الحل الجذرى للعربية (وصل الحروف، الاتجاه RTL، الأرقام
 * والنصوص المختلطة) لأن محرك المتصفح هو الأدق فى الشكل والاتجاه، بخلاف مكتبات رسم PDF المباشرة.
 *
 * الأمان: HTML يُولَّد من نموذج داخلى بهروب شامل ويُحمَّل عبر setContent (لا تنقّل لأى رابط)؛
 * كل طلب شبكة غير data: يُحبَس؛ و CSP داخل المستند تمنع أى سكربت. متصفح واحد مشترك وصفحة لكل طلب،
 * بسقف تزامن وحدّ زمنى، ويُعاد تشغيله تلقائياً إن انقطع.
 */
@Injectable()
export class PdfRenderer implements OnModuleDestroy {
  private readonly logger = new Logger(PdfRenderer.name);
  private browserPromise: Promise<Browser> | null = null;
  private active = 0;
  private readonly waiters: Array<() => void> = [];

  private resolveExecutable(): string | null {
    const fromEnv = process.env.PDF_CHROMIUM_PATH || process.env.PUPPETEER_EXECUTABLE_PATH;
    if (fromEnv && existsSync(fromEnv)) return fromEnv;
    return CHROMIUM_CANDIDATES.find((p) => existsSync(p)) ?? null;
  }

  isAvailable(): boolean {
    return this.resolveExecutable() !== null;
  }

  /**
   * متصفح واحد مشترك. ⚠️ الوعد يُسنَد إلى browserPromise **بشكل متزامن** قبل أى await — وإلا فإن طلبين
   * متزامنين عند أول استعمال يُطلقان متصفحين ويتسرب أحدهما (عملية Chromium يتيمة تُبقى الخدمة حية وتستهلك ذاكرة).
   * اكتُشف هذا بالاختبار الفعلى (6 طلبات متوازية) لا بالقراءة.
   */
  private getBrowser(): Promise<Browser> {
    if (this.browserPromise) return this.browserPromise;
    const executablePath = this.resolveExecutable();
    if (!executablePath) {
      return Promise.reject(new ServiceUnavailableException('تصدير PDF غير متاح مؤقتاً — يمكن تنزيل نسخة Word.'));
    }
    const launched: Promise<Browser> = (async () => {
      const puppeteer = await import('puppeteer-core');
      const browser = await puppeteer.launch({
        executablePath,
        headless: true,
        // داخل حاوية بلا مستخدم root وبلا user namespaces؛ المحتوى المعروض مُولَّد داخلياً ومحبوس الشبكة (راجع أعلاه)
        args: [
          '--no-sandbox',
          '--disable-setuid-sandbox',
          '--disable-dev-shm-usage',
          '--disable-gpu',
          '--disable-breakpad',
          '--font-render-hinting=none',
        ],
        // مستخدم الحاوية غير root وقد لا يملك HOME قابلاً للكتابة — Chromium يحتاج مجلداً للملف الشخصى/الإعدادات
        env: { ...process.env, HOME: '/tmp', XDG_CONFIG_HOME: '/tmp', XDG_CACHE_HOME: '/tmp' } as Record<string, string>,
      });
      browser.on('disconnected', () => {
        if (this.browserPromise === launched) this.browserPromise = null;
      });
      return browser;
    })();
    this.browserPromise = launched;
    launched.catch(() => {
      if (this.browserPromise === launched) this.browserPromise = null;
    });
    return launched;
  }

  private async acquire(): Promise<void> {
    if (this.active < MAX_CONCURRENT) {
      this.active += 1;
      return;
    }
    await new Promise<void>((resolve) => this.waiters.push(resolve));
    this.active += 1;
  }

  private release(): void {
    this.active -= 1;
    this.waiters.shift()?.();
  }

  async render(doc: LegalDocument): Promise<Buffer> {
    // فحص مبكر رخيص قبل بناء HTML وحجز مقعد التزامن
    if (!this.isAvailable()) {
      throw new ServiceUnavailableException('تصدير PDF غير متاح مؤقتاً — يمكن تنزيل نسخة Word.');
    }
    await this.acquire();
    try {
      return await this.renderOnce(doc);
    } finally {
      this.release();
    }
  }

  private async renderOnce(doc: LegalDocument): Promise<Buffer> {
    const html = renderHtml(doc);
    const browser = await this.getBrowser();
    const page = await browser.newPage();
    try {
      page.setDefaultTimeout(RENDER_TIMEOUT_MS);
      await page.setRequestInterception(true);
      page.on('request', (req: HTTPRequest) => {
        const url = req.url();
        // يُسمح فقط بمحتوى المستند نفسه (about:blank/data:) — أى طلب خارجى يُحبَس
        if (url.startsWith('data:') || url === 'about:blank') void req.continue();
        else void req.abort();
      });
      await page.setContent(html, { waitUntil: 'load', timeout: RENDER_TIMEOUT_MS });
      await page.evaluate('document.fonts.ready.then(() => true)');
      const pdf = await page.pdf({ format: 'A4', printBackground: true, preferCSSPageSize: true, timeout: RENDER_TIMEOUT_MS });
      return Buffer.from(pdf);
    } catch (err) {
      this.logger.error(`PDF render failed: ${(err as Error).message}`);
      throw err;
    } finally {
      await page.close().catch(() => undefined);
    }
  }

  async onModuleDestroy(): Promise<void> {
    if (this.browserPromise) {
      const b = await this.browserPromise.catch(() => null);
      await b?.close().catch(() => undefined);
    }
  }
}
